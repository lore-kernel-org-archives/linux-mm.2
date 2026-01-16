Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FDFC98301
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 20:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 214AD6B0005; Fri, 16 Jan 2026 15:05:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C2B26B0088; Fri, 16 Jan 2026 15:05:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 011696B0089; Fri, 16 Jan 2026 15:05:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEA086B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:05:39 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8840A1AD9CC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:05:39 +0000 (UTC)
X-FDA: 84338907198.29.13C752B
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf26.hostedemail.com (Postfix) with ESMTP id 44BC014000C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:05:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B3lofWAi;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768593936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNY8fU5LFp+Li/My94+kYcmyNn8PnZVo1W57YVqwMQI=;
	b=PBRaoggDydoO0UOudodrFhZcS16vcn0lzVRxixE5DlQA+JCaPIppuC4FqpFX+AkoYPgC+A
	EZVYKguZXm1sA/GTWmrd9lJdmMCb16LCT2MQzfSA38PCMtJKih460hPIEVZ7oMx7gmYn+2
	yABfugirxLBg+35VXTCQZMP9MVIp+Mw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768593936; a=rsa-sha256;
	cv=fail;
	b=8Esl4EkVhwWVTXoOIJbZkoEd/da6GwBAZ7Y4QcqImD0hdbRCyQB38S2jOX7EHe7HFD06AK
	sPCrC2VJ9YBfjDjugg5AZdvz8gLEt31O3Upz6LPnajWZpDvX3fS+pgpVkewqe8NEzHTKPt
	pqIfGFUFT2yIZ5wLmVaEkUmOTKbsOWc=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=B3lofWAi;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf26.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768593935; x=1800129935;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rn2lLrOLDVoOZLF75DlFcu8q3FjcIB9wNzB/IuQSUxA=;
  b=B3lofWAivs7fjI8dQpbhVhYwG5y4n4WYaNh99mPQbzu2pFeiHwPcT62G
   klyQWDHGAUHD5Ve1KpgHld0pCjlJb+P6STrWV17d0W5jR0iZrQple0rmx
   6iaUv5uPJ6G9HErJmGlLEBpYFV9tP/Tg3VaNsja1Oo1EcPYpWvVj1mxNt
   dvfDHE4/VepBm6k55Chn/Fo3JDeN0sZfa8uuWcojdmb5feMmiLaX153yI
   TraR2YEXMg0Mn49BUvcqzxfu1lnDcCxoJFeHmQeo8zudE+t1lR5MAIz15
   pvqMVhR5tGj91hqUTTs5e1yoBhor920EdeugR72QKsPoXkspQlAuYXidC
   w==;
X-CSE-ConnectionGUID: lwTYR+J8TRGkyIEjMUvQ7g==
X-CSE-MsgGUID: c44LAUz6R267dqcLXPOpCw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="69115379"
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="69115379"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 12:05:33 -0800
X-CSE-ConnectionGUID: gH0RyG/bQjuUlC94hVl1Lg==
X-CSE-MsgGUID: zVDkmY31QyirE8qWcsvTzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,232,1763452800"; 
   d="scan'208";a="204553824"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 12:05:33 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 12:05:31 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 12:05:31 -0800
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.14) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 12:05:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=My4se+U5TE1FR1+6Ll2siIOZhS6gyOEjDRaRUHIafUPleeYFjG30izBzUMMYJ5FGF5AJwbQSoC8CWZtUgvqXJzN/Y2lmQCvd6pVmRbj9LlF3wEEJ30q8uif8xWdki8dbys54rjqzLNNpbnDFoTPUzOovYcN+0MNuaxlocIyzY5WYIMlJktBoYvXoAO/zDbowSKDhG2xS5PwkzCUfy51wm/tXpJYkPf4uIjIGCCsF5EdX7MoxTpK5ixacGA0gs05qcXRKKpIyLsr5QtMQFvECnWCPwsVvQgPojtnhNN5pcjUjjxRwDE5MY8ZVzfHOMEus7TqX6qc1FjsdZ0fP0i7S4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qNY8fU5LFp+Li/My94+kYcmyNn8PnZVo1W57YVqwMQI=;
 b=fCHvEJQ+qi7Pj+Xz1xG99yJAZhJW6HalDg7oc/yuvNuREqSg2K3SLjD/JjGnHZdFQ+K/lEQx5yWpYL/E1GK2GAIkhjqGGODJ0QqMdS6aSLCEicBiehbsUjWRz4oL+r8frV8zLOyZ2w5WDrnumFsx4QQ00Ya+VVLMYxXnWpniMnYNUAjFtz0w2ccLhRcuU68vFgcv4mKhLfd+MltHt6y7O702mBxon7QnFjuCWOfTOw0Y1Pi3DouMhfgFRQo37hR9K+GI8/l8YU3UcnGWS2LMvoi9ZvOcjCleFSVH+uLjyUOE10CUqgDzzmx4sZFJP+k0feqeRy4oAJKR/OFYnIiIig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS0PR11MB8688.namprd11.prod.outlook.com (2603:10b6:8:1a0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Fri, 16 Jan
 2026 20:05:28 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Fri, 16 Jan 2026
 20:05:28 +0000
Date: Fri, 16 Jan 2026 12:05:25 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, David Hildenbrand
	<david@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>, Leon Romanovsky
	<leonro@nvidia.com>, Alistair Popple <apopple@nvidia.com>, Balbir Singh
	<balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <aWqaBe+JVL3sz9bS@lstrano-desk.jf.intel.com>
References: <20260114091923.3950465-1-mpenttil@redhat.com>
 <20260114091923.3950465-2-mpenttil@redhat.com>
 <aWmdOMOYomnJrJWQ@lstrano-desk.jf.intel.com>
 <151ee03d-423b-4ac2-9dd4-11b1ceaadbaf@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <151ee03d-423b-4ac2-9dd4-11b1ceaadbaf@redhat.com>
X-ClientProxiedBy: BYAPR03CA0019.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::32) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS0PR11MB8688:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c17750b-9c73-43de-d268-08de553a97dc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWhvVk5vVzRKekVJRnhrbzRiV1c0L0thMWlWbVlzeFh6NG81NjltUUVZSlpj?=
 =?utf-8?B?S3JqTk03dy82UjVIUG90eUNFbWp4SFlHUno2aWp2dGloZ0dKcXVSQ1pkdWpm?=
 =?utf-8?B?SnpDRndOOFUxZVhzRHpsdmRDTHFDNkd2Rjc0OVRFTE83c2JqU2lGN3pRVkpa?=
 =?utf-8?B?ekZCOW9rdEJ1ZWJGekhnUlowZ1AzSVA2MTRkT0Fhb0FCWkZhdndwYnR2Tk1H?=
 =?utf-8?B?US9CSkxPSjNqaVZTZ25GRXBsK3Q3ZEtteWxScDNsYUhpTnFOdWM5VTQxN2NF?=
 =?utf-8?B?OUxmRHNQMDBaK2Z4VjFMbHJZVTkzR25nS0dETlMyY2d2c0xWSjk2R3I5RE1O?=
 =?utf-8?B?ZERkNEdoTnBwTzQxcG5PdEgvM1BjdWdiMkc3a0xnUGcxZTl5MkR4WGdCNFNS?=
 =?utf-8?B?WlNoTzVSZGJBY1hTT1p5TEJXTUtHMDYwai9YQXJFTjUwaGIrQUFDdytUeE14?=
 =?utf-8?B?cWRBSzVtNUwxYkZUeGRQekpWSHR5WlZkaldaVUtQUVlJNWx4YXVXaFNBSlpq?=
 =?utf-8?B?SjA4M3hSZFQzSmJabzVJNjNXek91c21yNDlETmhUYlVoM05vRUY4VUtvK3Jj?=
 =?utf-8?B?bDFySzVlaVNwNzZubzF2UVl2aFY5Wm00cnVTbHRSbFUzNnZvcVhLTkVlQm9X?=
 =?utf-8?B?RExLeHU1VEhUS3NUM1B6NXR2S0JzT0x0TkJDUE5WOFNGcHNhRlZQSGd3ajNw?=
 =?utf-8?B?VTZMd0c0UUYwZTQrVUFpNURyRzVWQ242amVxYU1GQXlsVktXaElEdERFRE5E?=
 =?utf-8?B?a0RpNnp1dEZHTDJ4SkZRMGtCU1J0RjdaYlhwMHJWZ0NFN01YR1R4UHBmRkU2?=
 =?utf-8?B?b3F0UHBGZ0ZZMzdJajNubVFsQTBsQkFkYmZ5Q2pKUUdQc2VZTVArQWV2SmQ3?=
 =?utf-8?B?Rlc0SUdGSEpza1JocjMxY1pBN013dnRvYTduT2R0UjZaV3FOZGM1REFMZnFD?=
 =?utf-8?B?RFVFMVFxMVdZVGpybXRHZlNsWGlEWUtEcnYyaitDUDY2bEk4NmRKY2ZNVjR2?=
 =?utf-8?B?ZmEwdVI5d2UwUG5heHh3akdpK2ZERU9NUkZhQUQ2eTg2VVhFVUptU2xSSXdK?=
 =?utf-8?B?SUJQUjIyRVpIVlRlRjNPcm1kamc4dFVOTnFLVkdiUlI3K0F4TytwMms5Y2N5?=
 =?utf-8?B?V3dJUmEralJqZ24xekxHNm40WW1MVkNESE1VMlcwTDdGOG5TN1YwektCWGU5?=
 =?utf-8?B?TktvczRCZnZob0ZaTGVyWEtQRndrNk03aUwrTGZ6b1dtWjBFZzFiMkgxY01V?=
 =?utf-8?B?ZDdPVE1JMzcyeC9jSGViSVlLamNRK09aNzRoU3BEeXFmdUNnV0phYlZYdkV1?=
 =?utf-8?B?MHhTekRmdDFheEthaWVDOEtiNTVNMDRaNDVTbktFQ2libGZyVDJrN3hFZm5z?=
 =?utf-8?B?eFlubUZ2VkVTclU3WHhjMDhVd0tBNFVldnpZSUp3RzJsSjlMaUhxNnNMbG12?=
 =?utf-8?B?Z1B0SEZvajQ1TXlyTnAyR29wWStDdkluRnVwVmRjUThNMjE4VjZNdlM4TUV0?=
 =?utf-8?B?S1ptMnBKRDNUZnRZbG1Ob21kemU0WmtNdWlydXlpbnc1cEZ1Z3lkZmRRV053?=
 =?utf-8?B?UnlPTEdwNjhXUmxVMElNem54UzFkSXhRdkRYcjVCVmJGbkhxWmNMR2V4aFJJ?=
 =?utf-8?B?Qk1jNnhtaStKWlFzZDJ5NmowcUROM1FWSnVGQzZDTjRBbEk2RGxSNkRYV2x5?=
 =?utf-8?B?Rm43T1FNWVNZTitKcDlKVE5ncGpYVFhaSXJEbi9wcmpvbDA5Zk54SVl5T2xG?=
 =?utf-8?B?TEcwZXBqRWNaTjR6M2hpU1I3SjU2N1NybFdyRmNZQWxUMmIyamlsbTBOOUZL?=
 =?utf-8?B?UHpQV1VuM2ZPRTBZeFYxeWRMZDZ5MWVTMW9BdFFaVTVUcjFBT1FiVTc1ZlZV?=
 =?utf-8?B?Mk5hdjkydG84cVNpRGErYWJ2NnNERFphR2hQT3cxK0V1RlpHbDR6cTg1eDdx?=
 =?utf-8?B?MTJGY0E4czczK2V0cGZRQ2tWTGY3M3FRSlN1QVhRT2FrT2NhdCt6K2lwSlQ0?=
 =?utf-8?B?T2tubnlCVkV0Z2dTSmdIMVc3Z1dzY1hFOFZqQW5GYTA5SWRIWUtLbklPb2pa?=
 =?utf-8?B?bUlHNEg0MmZYd01sdGVkRFJuVnAxZFBMZGNLdGgrdzNPQlJUQXRRSW1wUEFz?=
 =?utf-8?Q?bl3U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3pCeXJSV3c4d21XZ3FaSXhJd1BpdS9KRk93eFQra3hDYW8rTEs1T1E1T0hq?=
 =?utf-8?B?cmVqVFp0V2lDZDhwWkR4WU1WaHhFVVhZQURKOTBwV1Z0YVNubHNReTJmMW0y?=
 =?utf-8?B?Rm5RQ09jS2p6QzBWQTRxemVVbFhITUh2dXlOV2hsay91aVZzMDU1Q0J5Z2dm?=
 =?utf-8?B?TGtxK1M4U25WWTQ1MytkM1Nzbm1XMWl4WlIyOFVNUmxPVWVoN0ZXMm8zczBz?=
 =?utf-8?B?K0dJaEIzY0lrSzI3M0ZoMjBHS2h5eGQ0QVVSQnFzWU5lc1ZyVHNvTjVnQjlM?=
 =?utf-8?B?cmpobkFTNDhDblVqZHloYk5MOEdhTVZFejlqazA5dWZWSytIMkhZeWQ0UWtp?=
 =?utf-8?B?N2VJZXNiWVpQc1pnMWEyNXRXbFlHbEpZbjAwRHJLTXEzd3Bad09GLzg5eXBK?=
 =?utf-8?B?MU82LzNJbHpJaTNnNXluUE9YRHkrYVc3RUZ5cVdqNlA1SnVya05ZZnBJcGhp?=
 =?utf-8?B?WWNjT3lKMTM5SFVFbHp2WndnbDhhZ0FNeVFwdWhTejA3dHFlcHlOalpUUU8v?=
 =?utf-8?B?ZmI5emRNRjVVS1RMS29lWkRBb214aElLblh0a1RVZGdTV1owSHNIV3BVUXpN?=
 =?utf-8?B?ZjNyaGpGbjRpVitTMDlYQVJLb0d3dUFyMDBiaE1yTlUrU3ZLaUR5VVllc1p4?=
 =?utf-8?B?bU91VmdDNUVCdkxBQUVPeVZuZ0NIT3Y3dEkxU3dXK3J0QzN2VUR5Zzg0VGF3?=
 =?utf-8?B?U2NSdlVlSXkzeEsvcXo2RVdSeDIvRFBkSVlDYVRJSGlpZUxaTGthZElqQXUw?=
 =?utf-8?B?RkNPaDZCa0NJcHYzUVVCQ0svT0VUS0hFWFFkVXMzRUZJYStObWZ2N2RiWEh1?=
 =?utf-8?B?L2ROeE80dWtlVU9oZ2x4eWJEa2VHdE8zTll5SnhRL1VXdWduSFl3RlNncFR1?=
 =?utf-8?B?eC9XL0l5dzVtMmVYQTBrMFBaTG1ZeDNmLzJZMU8vNGJVZ3BMSDlNMGhRTWtO?=
 =?utf-8?B?eERHZk5tK1BPQ3EzRU5lcm1ZQnVjNC82MUhXZmZZVzdJRDhyd3kzaWQ0bWhM?=
 =?utf-8?B?Q3cxUS9FZ21HeUZVekxONE9rSHYyKzh1OUQvOUFoV3NKSEJIVWVGQkExYU1M?=
 =?utf-8?B?ZDNoREdma3ZrVmNVRXBxVnp5ZXUzMUY5Nnh3Y2phbUtoNEpkOXg2Uy9zR00r?=
 =?utf-8?B?SHFSeXRwSXQwYnROQ3kwSkJ5UHZSYjRUM0JUSjUvMUZWZWx4YVY2SldkOHln?=
 =?utf-8?B?c3h0ZHkxNWljTDNhMDNMV3pFcFpRL0srenBTeVVNUHB6NEFhTG00ZW1hRFBl?=
 =?utf-8?B?U0s4YjhtdFcycVlraFA0RE1GTnZkTzg1V0prWDRpNDBOQWltZjBXdFhpWEZ1?=
 =?utf-8?B?N1FPZzU2M2hrdkFIdWtLM2F4bm51Nm5ieFNzWnVyVURtN1JnQy90bTBoSkRu?=
 =?utf-8?B?dlA2eW1vQitDTm50UkZ5cnloL2R6elZtUUZKRDhkdEtZNVVEZWJDcU91NUtq?=
 =?utf-8?B?Qk1jclN4MTNGSW8xSUp3dkdjTmN0QVR2dndXdnJIVVIrNWd0M01YSnJqd2Vn?=
 =?utf-8?B?d01mSWFvVFJ3eWFVSm5LY1pjcWpTbjk4bUhKRDVtclJ5bmVXZDdMYzFIV0po?=
 =?utf-8?B?dkVva2VmOGxDVEs1S3puSXNobXk4MHZlbW50bCsvMm03ZG9aRDdYUUV0ZW0w?=
 =?utf-8?B?cTVMb1UrcURnTUF3VU44QWhJeEpCMDZyVzlzZ1RrOURTZzRTa09BVGN4MGJ6?=
 =?utf-8?B?ckFOamF2czhNUS9UU0hZQStxYjJCaEdZM1l5VytTYkR4MGh3bkZOb2lyV3py?=
 =?utf-8?B?N0ZtTHVoSjZpUERud053YldLcHpoRThOYlNGY3J3RTBiNHZybzhaYkUwTmU2?=
 =?utf-8?B?b1J5T1o5aE5ocXNYc09UOU9NWEVBbzB5elVIcDBzTm9ZNXZib3FJbHlaSWVq?=
 =?utf-8?B?bzYrWWlLZlYrZkJVMlVpMDNmSHdrbStHaDFHSXVvNFNWbWU1aVdrNUNYMUxm?=
 =?utf-8?B?d2hpR3B1WHFXc0tSQmJWSkdVMTlTaGxNTE5KT1FyTmZCSkZ1UE5NbTRIeHh2?=
 =?utf-8?B?Q3htVG0xSW9LcVNuNDdhYWI3SXl2eDU1Wk55encwQXdJTit3ZjVlWmYwRENj?=
 =?utf-8?B?MStlTFBkakR0SmRETEQ3WGV3MGtQbmFTSkhRWTNId1Ezcjh6SlNtSjkwVnFC?=
 =?utf-8?B?OWNBMjlLd2paelpRRElBL3dqS1NUQVNxSDRCRm85bGpOWVN1eUU0RCtuWFVv?=
 =?utf-8?B?d3dBTzhmaDhGd2pBSWlxb3NHdmY1UExNbUVkSDllblk4Uk1lZSthSCs3bURy?=
 =?utf-8?B?ZXBDVFA2N2lkN3NHejJLWjlCKzlmUGpkdUFFSmU0VjJENmlRR05JNzA3bGNW?=
 =?utf-8?B?K0JzL2hpbUJnY29Hd25CQkVqbFhXaFYvRkcvdkFLVVVKSlk1VEsxZz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c17750b-9c73-43de-d268-08de553a97dc
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 20:05:27.9100
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 75K6s0ZyN99Y1RViQuV9h0FhnzMtIzWDVjSMKuD0zLNeJ+17maSBpqaCHmHTOUdkVWQ4AgUrVKxhxdT1JjFMbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8688
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44BC014000C
X-Rspam-User: 
X-Stat-Signature: qt9b9ytijwm6qyyxui5ydxh6s4nt3aup
X-HE-Tag: 1768593935-723636
X-HE-Meta: U2FsdGVkX1/BZE3JGUncLbdVrHHHI/4wRrMddPD++96bk286G9/BP1YVGoktsnqGR77CYc+XLLBd67lClYvcLU9e6jN0t+dnCsYtrQkWdsuPS/gGqkLDshrtJk303LCyZgYREwjIVR5H8qSu/I4LSk9Kegbe8ZZndMcQ/8Ny5s6onpWDB2VsKtJ3oY6VnSYEadIWtpqWKaDNtVCCmzv5ZK25eIo+UxbqEBw3YAJ+PvWHa8Y25EPNu/9imQPF2G0bKYOaJKoaFh/HVywCK/cWDWsZIJu1cRHpePJAPpH2lw4UCmBeqMEx29pbiLLK7R7HtSK2h9H4Aa3lKRFO7uNp1jL8qJ52sSkIjNzqsl++FPs9t4KVblYepDWH54/7yalexvGvAsJOvxOLdcGTWzGMM82/Y4Bv+Xi85dP34R2R48OyX2F/kF1eLA2THoOvGK4cNflWZuVg8n3vN5EWU9VsYrMcOZfelP1GZfLXuJD86r3Cn5Qhw5C2KXvrkC2pBsZarFHMd8GySuSMhTviHjrn/HDphIH9Ly1UXZFxyn1cnLH8sYwTKRhodImK9WoduxIr3vKw6kLVN5hsI5/XOvampOBE9xVtCbUM99MUo79tYKuiHFJ3l+f8rzn5hARUOUkmkruUOlb+cvNLmjykyFyjddc1O8oZK0hDZ5xI+5QdE1Z54z2+VzPYo9VuqTL/77hH1I6cumJK+uu0lTdXa2wYiJcUbY28zILATZxY3eCmiUxJwHYTkFOnLRH4rrE3hYDS7uOiX5ZkoFQg+7JbHKUiylG8mPuU4xWbdYjdcMbOknkVAt6u5pPeI+3XWdxFtL1KpoLuAZOe41LNC4+qDLokGCM58BtW012eLUKGLlbboDEDlQJRIwnZJwhZfbO8towmU3Hcr3CREI/E8Yre+gn6qus/CAoiNbvweNWKBMc6hLnTCsWvmlrkLmu9zyA6miCQU8nPZglz7MlTwssCo18
 M5rNfays
 CigD/XzgZOzYVqgmacxsoBS97AVFcfwSbw75ugSU7EFcFomt5pmMkIEsnP4HmMO5uy7DAGTiHNiYZiyLfDqFPsC8Q8XCRdsJVEqtvUYx8gNAbWtUOQ2l0qoBtlvi+KHPq2omHKV9aMePdNj1aaHVloXZY7iHTRJp3HUP9LXAz2ZyrJjZ/QpIwbTjCj1yEW5iTvLLcbUad1pvijiSuHr2DC4sJ/wm0vM8AcpV5+TVC8wpy4TMJiaREJ6AKjWwiwvi7GzCzWqJi/smhkzNf2m1h7zYTna7IHtDdey9cT0558hEfuFQgHO7A/XxCo16cE6/0tXekVRDYTlFnEMT26nsPBcNTZaH35YSsD5E16sbYwHpSyVNUkiK2akW/CFAHq84sz8glACVDuSludzGJHu5gyx8vTZhCVPzOJMTIj0oz+gwqcDDvK8zD1u5/4514CjlE7mRXddwXyvK38xQhUET49hIZNg4AGpBWT1etANqjMDg2UDFQIB0+07ysFMRl+zzsn0Dy7JewGzAXucrKJKiip579P4wyLMA27eTrUWUvNX6IIzsBe4Dktd6cwmc4a9PzVjIW49ibFbAgIGZ4ZMpgesJyBGMY/zNzZdWwQOJca1r2oEiD8H05a87ocIT5PQs7VBun
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 12:39:30PM +0200, Mika Penttilä wrote:
> Hi,
> 
> On 1/16/26 04:06, Matthew Brost wrote:
> 
> > On Wed, Jan 14, 2026 at 11:19:21AM +0200, mpenttil@redhat.com wrote:
> >> From: Mika Penttilä <mpenttil@redhat.com>
> >>
> >> Currently, the way device page faulting and migration works
> >> is not optimal, if you want to do both fault handling and
> >> migration at once.
> >>
> >> Being able to migrate not present pages (or pages mapped with incorrect
> >> permissions, eg. COW) to the GPU requires doing either of the
> >> following sequences:
> >>
> >> 1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
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
> >> page walks even when most of the time the pages are present or zero page
> >> mappings so the common case takes a performance hit.
> >>
> >> The second sequence is better for the common case, but far worse if
> >> pages aren't present because now you have to walk the page tables three
> >> times (once to find the page is not present, once so hmm_range_fault()
> >> can find a non-present page to fault in and once again to setup the
> >> migration). It is also tricky to code correctly.
> >>
> >> We should be able to walk the page table once, faulting
> >> pages in as required and replacing them with migration entries if
> >> requested.
> >>
> >> Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
> >> which tells to prepare for migration also during fault handling.
> >> Also, for the migrate_vma_setup() call paths, a flags, MIGRATE_VMA_FAULT,
> >> is added to tell to add fault handling to migrate.
> >>
> >> Cc: David Hildenbrand <david@redhat.com>
> >> Cc: Jason Gunthorpe <jgg@nvidia.com>
> >> Cc: Leon Romanovsky <leonro@nvidia.com>
> >> Cc: Alistair Popple <apopple@nvidia.com>
> >> Cc: Balbir Singh <balbirs@nvidia.com>
> >> Cc: Zi Yan <ziy@nvidia.com>
> >> Cc: Matthew Brost <matthew.brost@intel.com>
> > I'll try to test this when I can but horribly behind at the moment.
> >
> > You can use Intel's CI system to test SVM too. I can get you authorized
> > to use this. The list to trigger is intel-xe@lists.freedesktop.org and
> > patches must apply to drm-tip. I'll let you know when you are
> > authorized.
> 
> Thanks, appreciate, will do that also!
> 

Working on enabling this for you in CI.

I did a quick test by running our complete test suite and got a kernel
hang in this section:

xe_exec_system_allocator.threads-shared-vm-many-stride-malloc-prefetch

Stack trace:

[  182.915763] INFO: task xe_exec_system_:5357 blocked for more than 30 seconds.
[  182.922866]       Tainted: G     U  W           6.19.0-rc4-xe+ #2549
[  182.929183] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  182.936912] task:xe_exec_system_ state:D stack:0     pid:5357  tgid:1862  ppid:1853   task_flags:0x400040 flags:0x00080000
[  182.936916] Call Trace:
[  182.936918]  <TASK>
[  182.936919]  __schedule+0x4df/0xc20
[  182.936924]  schedule+0x22/0xd0
[  182.936925]  io_schedule+0x41/0x60
[  182.936926]  migration_entry_wait_on_locked+0x21c/0x2a0
[  182.936929]  ? __pfx_wake_page_function+0x10/0x10
[  182.936931]  migration_entry_wait+0xad/0xf0
[  182.936933]  hmm_vma_walk_pmd+0xd5f/0x19b0
[  182.936935]  walk_pgd_range+0x51d/0xa60
[  182.936938]  __walk_page_range+0x75/0x1e0
[  182.936940]  walk_page_range_mm_unsafe+0x138/0x1f0
[  182.936941]  hmm_range_fault+0x8f/0x160
[  182.936945]  drm_gpusvm_get_pages+0x1ae/0x8a0 [drm_gpusvm_helper]
[  182.936949]  drm_gpusvm_range_get_pages+0x2d/0x40 [drm_gpusvm_helper]
[  182.936951]  xe_svm_range_get_pages+0x1b/0x50 [xe]
[  182.936979]  xe_vm_bind_ioctl+0x15c3/0x17e0 [xe]
[  182.937001]  ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
[  182.937021]  ? drm_ioctl_kernel+0xa3/0x100
[  182.937024]  drm_ioctl_kernel+0xa3/0x100
[  182.937026]  drm_ioctl+0x213/0x440
[  182.937028]  ? __pfx_xe_vm_bind_ioctl+0x10/0x10 [xe]
[  182.937061]  xe_drm_ioctl+0x5a/0xa0 [xe]
[  182.937083]  __x64_sys_ioctl+0x7f/0xd0
[  182.937085]  do_syscall_64+0x50/0x290
[  182.937088]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  182.937091] RIP: 0033:0x7ff00f724ded
[  182.937092] RSP: 002b:00007ff00b9fa640 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
[  182.937094] RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007ff00f724ded
[  182.937095] RDX: 00007ff00b9fa6d0 RSI: 0000000040886445 RDI: 0000000000000003
[  182.937096] RBP: 00007ff00b9fa690 R08: 0000000000000000 R09: 0000000000000000
[  182.937097] R10: 0000000000000001 R11: 0000000000000246 R12: 00007ff00b9fa6d0
[  182.937098] R13: 0000000040886445 R14: 0000000000000003 R15: 00007ff00f8a9000
[  182.937099]  </TASK>

This section is a racy test with parallel CPU and device access that is
likely causing the migration process to abort and retry. From the stack
trace, it looks like a migration PMD didn’t get properly removed, and a
subsequent call to hmm_range_fault hangs on a migration entry that was
not removed during the migration abort.

IIRC, some of the last bits in Balbir’s large device pages series had a
similar bug, which I sent to Andrew with fixup patches. I suspect you
have a similar bug. If I can find the time, I’ll see if I can track it
down.

> >> Suggested-by: Alistair Popple <apopple@nvidia.com>
> >> Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
> >> ---
> >>  include/linux/hmm.h     |  17 +-
> >>  include/linux/migrate.h |   6 +-
> >>  mm/hmm.c                | 657 +++++++++++++++++++++++++++++++++++++---
> >>  mm/migrate_device.c     |  81 ++++-
> >>  4 files changed, 706 insertions(+), 55 deletions(-)
> >>
> >> diff --git a/include/linux/hmm.h b/include/linux/hmm.h
> >> index db75ffc949a7..7b7294ad0f62 100644
> >> --- a/include/linux/hmm.h
> >> +++ b/include/linux/hmm.h
> >> @@ -12,7 +12,7 @@
> >>  #include <linux/mm.h>
> >>  
> >>  struct mmu_interval_notifier;
> >> -
> >> +struct migrate_vma;
> >>  /*
> >>   * On output:
> >>   * 0             - The page is faultable and a future call with 
> >> @@ -48,15 +48,25 @@ enum hmm_pfn_flags {
> >>  	HMM_PFN_P2PDMA     = 1UL << (BITS_PER_LONG - 5),
> >>  	HMM_PFN_P2PDMA_BUS = 1UL << (BITS_PER_LONG - 6),
> >>  
> >> -	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 11),
> >> +	/* Migrate request */
> >> +	HMM_PFN_MIGRATE    = 1UL << (BITS_PER_LONG - 7),
> >> +	HMM_PFN_COMPOUND   = 1UL << (BITS_PER_LONG - 8),
> >> +	HMM_PFN_ORDER_SHIFT = (BITS_PER_LONG - 13),
> >>  
> >>  	/* Input flags */
> >>  	HMM_PFN_REQ_FAULT = HMM_PFN_VALID,
> >>  	HMM_PFN_REQ_WRITE = HMM_PFN_WRITE,
> >> +	HMM_PFN_REQ_MIGRATE = HMM_PFN_MIGRATE,
> > I believe you are missing kernel for HMM_PFN_MIGRATE.
> 
> I explain below the HMM_PFN_MIGRATE usage.
> 

I had a typo here: s/missing kernel/missing doc kernel/

> >
> >>  
> >>  	HMM_PFN_FLAGS = ~((1UL << HMM_PFN_ORDER_SHIFT) - 1),
> >>  };
> >>  
> >> +enum {
> >> +	/* These flags are carried from input-to-output */
> >> +	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> >> +		HMM_PFN_P2PDMA_BUS,
> >> +};
> >> +
> >>  /*
> >>   * hmm_pfn_to_page() - return struct page pointed to by a device entry
> >>   *
> >> @@ -107,6 +117,7 @@ static inline unsigned int hmm_pfn_to_map_order(unsigned long hmm_pfn)
> >>   * @default_flags: default flags for the range (write, read, ... see hmm doc)
> >>   * @pfn_flags_mask: allows to mask pfn flags so that only default_flags matter
> >>   * @dev_private_owner: owner of device private pages
> >> + * @migrate: structure for migrating the associated vma
> >>   */
> >>  struct hmm_range {
> >>  	struct mmu_interval_notifier *notifier;
> >> @@ -117,12 +128,14 @@ struct hmm_range {
> >>  	unsigned long		default_flags;
> >>  	unsigned long		pfn_flags_mask;
> >>  	void			*dev_private_owner;
> >> +	struct migrate_vma      *migrate;
> >>  };
> >>  
> >>  /*
> >>   * Please see Documentation/mm/hmm.rst for how to use the range API.
> >>   */
> >>  int hmm_range_fault(struct hmm_range *range);
> >> +int hmm_range_migrate_prepare(struct hmm_range *range, struct migrate_vma **pargs);
> >>  
> >>  /*
> >>   * HMM_RANGE_DEFAULT_TIMEOUT - default timeout (ms) when waiting for a range
> >> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> >> index 26ca00c325d9..0889309a9d21 100644
> >> --- a/include/linux/migrate.h
> >> +++ b/include/linux/migrate.h
> >> @@ -3,6 +3,7 @@
> >>  #define _LINUX_MIGRATE_H
> >>  
> >>  #include <linux/mm.h>
> >> +#include <linux/hmm.h>
> >>  #include <linux/mempolicy.h>
> >>  #include <linux/migrate_mode.h>
> >>  #include <linux/hugetlb.h>
> >> @@ -140,11 +141,12 @@ static inline unsigned long migrate_pfn(unsigned long pfn)
> >>  	return (pfn << MIGRATE_PFN_SHIFT) | MIGRATE_PFN_VALID;
> >>  }
> >>  
> >> -enum migrate_vma_direction {
> >> +enum migrate_vma_info {
> >>  	MIGRATE_VMA_SELECT_SYSTEM = 1 << 0,
> >>  	MIGRATE_VMA_SELECT_DEVICE_PRIVATE = 1 << 1,
> >>  	MIGRATE_VMA_SELECT_DEVICE_COHERENT = 1 << 2,
> >>  	MIGRATE_VMA_SELECT_COMPOUND = 1 << 3,
> >> +	MIGRATE_VMA_FAULT = 1 << 4,
> >>  };
> >>  
> >>  struct migrate_vma {
> >> @@ -192,7 +194,7 @@ void migrate_device_pages(unsigned long *src_pfns, unsigned long *dst_pfns,
> >>  			unsigned long npages);
> >>  void migrate_device_finalize(unsigned long *src_pfns,
> >>  			unsigned long *dst_pfns, unsigned long npages);
> >> -
> >> +void migrate_hmm_range_setup(struct hmm_range *range);
> >>  #endif /* CONFIG_MIGRATION */
> >>  
> >>  #endif /* _LINUX_MIGRATE_H */
> >> diff --git a/mm/hmm.c b/mm/hmm.c
> >> index 4ec74c18bef6..39a07d895043 100644
> >> --- a/mm/hmm.c
> >> +++ b/mm/hmm.c
> >> @@ -20,6 +20,7 @@
> >>  #include <linux/pagemap.h>
> >>  #include <linux/leafops.h>
> >>  #include <linux/hugetlb.h>
> >> +#include <linux/migrate.h>
> >>  #include <linux/memremap.h>
> >>  #include <linux/sched/mm.h>
> >>  #include <linux/jump_label.h>
> >> @@ -31,8 +32,12 @@
> >>  #include "internal.h"
> >>  
> >>  struct hmm_vma_walk {
> >> -	struct hmm_range	*range;
> >> -	unsigned long		last;
> >> +	struct mmu_notifier_range	mmu_range;
> >> +	struct vm_area_struct		*vma;
> >> +	struct hmm_range		*range;
> >> +	unsigned long			start;
> >> +	unsigned long			end;
> >> +	unsigned long			last;
> >>  };
> >>  
> >>  enum {
> >> @@ -41,21 +46,49 @@ enum {
> >>  	HMM_NEED_ALL_BITS = HMM_NEED_FAULT | HMM_NEED_WRITE_FAULT,
> >>  };
> >>  
> >> -enum {
> >> -	/* These flags are carried from input-to-output */
> >> -	HMM_PFN_INOUT_FLAGS = HMM_PFN_DMA_MAPPED | HMM_PFN_P2PDMA |
> >> -			      HMM_PFN_P2PDMA_BUS,
> >> -};
> >> +static enum migrate_vma_info hmm_select_migrate(struct hmm_range *range)
> >> +{
> >> +	enum migrate_vma_info minfo;
> >> +
> >> +	minfo = range->migrate ? range->migrate->flags : 0;
> >> +	minfo |= (range->default_flags & HMM_PFN_REQ_MIGRATE) ?
> >> +		MIGRATE_VMA_SELECT_SYSTEM : 0;
> > I'm trying to make sense of HMM_PFN_REQ_MIGRATE and why it sets
> > MIGRATE_VMA_SELECT_SYSTEM?
> >
> > Also the just the general usage - would range->migrate be NULL in the
> > expected usage.
> >
> > Maybe an example of how hmm_range_fault would be called with this flag
> > and subsequent expected migrate calls would clear this up.
> 
> hmm_select_migrate() figures out the migration type (or none) that's going
> to happen based on the caller (of hmm_range_fault() or migrate_vma_setup()).
> 
> HMM_PFN_REQ_MIGRATE is hmm_range_fault() user's way to say it wants
> migrate on fault (with default_flags, the whole range) and for that
> direction is system->device.

Can’t range->migrate->flags just set MIGRATE_VMA_SELECT_SYSTEM?

As far as I can tell, HMM_PFN_REQ_MIGRATE doesn’t really do anything if
range->migrate is NULL or range->migrate->flags is 0.
 
> migrate_vma_setup() users (the current device migration) express their
> migration intention with migrate_vma.flags (direction being which ever).
> 
> >
> >> +
> >> +	return minfo;
> >> +}
> >>  
> >>  static int hmm_pfns_fill(unsigned long addr, unsigned long end,
> >> -			 struct hmm_range *range, unsigned long cpu_flags)
> >> +			 struct hmm_vma_walk *hmm_vma_walk, unsigned long cpu_flags)
> >>  {
> >> +	struct hmm_range *range = hmm_vma_walk->range;
> >>  	unsigned long i = (addr - range->start) >> PAGE_SHIFT;
> >> +	enum migrate_vma_info minfo;
> >> +	bool migrate = false;
> >> +
> >> +	minfo = hmm_select_migrate(range);
> >> +	if (cpu_flags != HMM_PFN_ERROR) {
> >> +		if (minfo && (vma_is_anonymous(hmm_vma_walk->vma))) {
> >> +			cpu_flags |= (HMM_PFN_VALID | HMM_PFN_MIGRATE);
> >> +			migrate = true;
> >> +		}
> >> +	}
> >> +
> >> +	if (migrate && thp_migration_supported() &&
> >> +	    (minfo & MIGRATE_VMA_SELECT_COMPOUND) &&
> >> +	    IS_ALIGNED(addr, HPAGE_PMD_SIZE) &&
> >> +	    IS_ALIGNED(end, HPAGE_PMD_SIZE)) {
> >> +		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> >> +		range->hmm_pfns[i] |= cpu_flags | HMM_PFN_COMPOUND;
> >> +		addr += PAGE_SIZE;
> >> +		i++;
> >> +		cpu_flags = 0;
> >> +	}
> >>  
> >>  	for (; addr < end; addr += PAGE_SIZE, i++) {
> >>  		range->hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> >>  		range->hmm_pfns[i] |= cpu_flags;
> >>  	}
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -171,11 +204,11 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
> >>  	if (!walk->vma) {
> >>  		if (required_fault)
> >>  			return -EFAULT;
> >> -		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
> >> +		return hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
> >>  	}
> >>  	if (required_fault)
> >>  		return hmm_vma_fault(addr, end, required_fault, walk);
> >> -	return hmm_pfns_fill(addr, end, range, 0);
> >> +	return hmm_pfns_fill(addr, end, hmm_vma_walk, 0);
> >>  }
> >>  
> >>  static inline unsigned long hmm_pfn_flags_order(unsigned long order)
> >> @@ -289,10 +322,13 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
> >>  			goto fault;
> >>  
> >>  		if (softleaf_is_migration(entry)) {
> >> -			pte_unmap(ptep);
> >> -			hmm_vma_walk->last = addr;
> >> -			migration_entry_wait(walk->mm, pmdp, addr);
> >> -			return -EBUSY;
> >> +			if (!hmm_select_migrate(range)) {
> >> +				pte_unmap(ptep);
> >> +				hmm_vma_walk->last = addr;
> >> +				migration_entry_wait(walk->mm, pmdp, addr);
> >> +				return -EBUSY;
> >> +			} else
> >> +				goto out;
> >>  		}
> >>  
> >>  		/* Report error for everything else */
> >> @@ -376,7 +412,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
> >>  			return -EFAULT;
> >>  	}
> >>  
> >> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> >> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> >>  }
> >>  #else
> >>  static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
> >> @@ -389,10 +425,448 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
> >>  
> >>  	if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> >>  		return -EFAULT;
> >> -	return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> >> +	return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> >>  }
> >>  #endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
> >>  
> >> +/**
> >> + * migrate_vma_split_folio() - Helper function to split a THP folio
> >> + * @folio: the folio to split
> >> + * @fault_page: struct page associated with the fault if any
> >> + *
> >> + * Returns 0 on success
> >> + */
> >> +static int migrate_vma_split_folio(struct folio *folio,
> >> +				   struct page *fault_page)
> >> +{
> >> +	int ret;
> >> +	struct folio *fault_folio = fault_page ? page_folio(fault_page) : NULL;
> >> +	struct folio *new_fault_folio = NULL;
> >> +
> >> +	if (folio != fault_folio) {
> >> +		folio_get(folio);
> >> +		folio_lock(folio);
> >> +	}
> >> +
> >> +	ret = split_folio(folio);
> >> +	if (ret) {
> >> +		if (folio != fault_folio) {
> >> +			folio_unlock(folio);
> >> +			folio_put(folio);
> >> +		}
> >> +		return ret;
> >> +	}
> >> +
> >> +	new_fault_folio = fault_page ? page_folio(fault_page) : NULL;
> >> +
> >> +	/*
> >> +	 * Ensure the lock is held on the correct
> >> +	 * folio after the split
> >> +	 */
> >> +	if (!new_fault_folio) {
> >> +		folio_unlock(folio);
> >> +		folio_put(folio);
> >> +	} else if (folio != new_fault_folio) {
> >> +		if (new_fault_folio != fault_folio) {
> >> +			folio_get(new_fault_folio);
> >> +			folio_lock(new_fault_folio);
> >> +		}
> >> +		folio_unlock(folio);
> >> +		folio_put(folio);
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >> +static int hmm_vma_handle_migrate_prepare_pmd(const struct mm_walk *walk,
> >> +					      pmd_t *pmdp,
> >> +					      unsigned long start,
> >> +					      unsigned long end,
> >> +					      unsigned long *hmm_pfn)
> >> +{
> >> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> >> +	struct hmm_range *range = hmm_vma_walk->range;
> >> +	struct migrate_vma *migrate = range->migrate;
> >> +	struct mm_struct *mm = walk->vma->vm_mm;
> >> +	struct folio *fault_folio = NULL;
> >> +	struct folio *folio;
> >> +	enum migrate_vma_info minfo;
> >> +	spinlock_t *ptl;
> >> +	unsigned long i;
> >> +	int r = 0;
> >> +
> >> +	minfo = hmm_select_migrate(range);
> >> +	if (!minfo)
> >> +		return r;
> >> +
> >> +	fault_folio = (migrate && migrate->fault_page) ?
> >> +		page_folio(migrate->fault_page) : NULL;
> >> +
> >> +	ptl = pmd_lock(mm, pmdp);
> >> +	if (pmd_none(*pmdp)) {
> >> +		spin_unlock(ptl);
> >> +		return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> >> +	}
> >> +
> >> +	if (pmd_trans_huge(*pmdp)) {
> >> +		if (!(minfo & MIGRATE_VMA_SELECT_SYSTEM))
> >> +			goto out;
> >> +
> >> +		folio = pmd_folio(*pmdp);
> >> +		if (is_huge_zero_folio(folio)) {
> >> +			spin_unlock(ptl);
> >> +			return hmm_pfns_fill(start, end, hmm_vma_walk, 0);
> >> +		}
> >> +
> >> +	} else if (!pmd_present(*pmdp)) {
> >> +		const softleaf_t entry = softleaf_from_pmd(*pmdp);
> >> +
> >> +		folio = softleaf_to_folio(entry);
> >> +
> >> +		if (!softleaf_is_device_private(entry))
> >> +			goto out;
> >> +
> >> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> >> +			goto out;
> >> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> >> +			goto out;
> >> +
> >> +	} else {
> >> +		spin_unlock(ptl);
> >> +		return -EBUSY;
> >> +	}
> >> +
> >> +	folio_get(folio);
> >> +
> >> +	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
> >> +		spin_unlock(ptl);
> >> +		folio_put(folio);
> >> +		return 0;
> >> +	}
> >> +
> >> +	if (thp_migration_supported() &&
> >> +	    (migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> >> +	    (IS_ALIGNED(start, HPAGE_PMD_SIZE) &&
> >> +	     IS_ALIGNED(end, HPAGE_PMD_SIZE))) {
> >> +
> >> +		struct page_vma_mapped_walk pvmw = {
> >> +			.ptl = ptl,
> >> +			.address = start,
> >> +			.pmd = pmdp,
> >> +			.vma = walk->vma,
> >> +		};
> >> +
> >> +		hmm_pfn[0] |= HMM_PFN_MIGRATE | HMM_PFN_COMPOUND;
> >> +
> >> +		r = set_pmd_migration_entry(&pvmw, folio_page(folio, 0));
> >> +		if (r) {
> >> +			hmm_pfn[0] &= ~(HMM_PFN_MIGRATE | HMM_PFN_COMPOUND);
> >> +			r = -ENOENT;  // fallback
> >> +			goto unlock_out;
> >> +		}
> >> +		for (i = 1, start += PAGE_SIZE; start < end; start += PAGE_SIZE, i++)
> >> +			hmm_pfn[i] &= HMM_PFN_INOUT_FLAGS;
> >> +
> >> +	} else {
> >> +		r = -ENOENT;  // fallback
> >> +		goto unlock_out;
> >> +	}
> >> +
> >> +
> >> +out:
> >> +	spin_unlock(ptl);
> >> +	return r;
> >> +
> >> +unlock_out:
> >> +	if (folio != fault_folio)
> >> +		folio_unlock(folio);
> >> +	folio_put(folio);
> >> +	goto out;
> >> +
> >> +}
> >> +
> >> +/*
> >> + * Install migration entries if migration requested, either from fault
> >> + * or migrate paths.
> >> + *
> >> + */
> >> +static int hmm_vma_handle_migrate_prepare(const struct mm_walk *walk,
> >> +					  pmd_t *pmdp,
> >> +					  unsigned long addr,
> >> +					  unsigned long *hmm_pfn)
> >> +{
> >> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> >> +	struct hmm_range *range = hmm_vma_walk->range;
> >> +	struct migrate_vma *migrate = range->migrate;
> >> +	struct mm_struct *mm = walk->vma->vm_mm;
> >> +	struct folio *fault_folio = NULL;
> >> +	enum migrate_vma_info minfo;
> >> +	struct dev_pagemap *pgmap;
> >> +	bool anon_exclusive;
> >> +	struct folio *folio;
> >> +	unsigned long pfn;
> >> +	struct page *page;
> >> +	softleaf_t entry;
> >> +	pte_t pte, swp_pte;
> >> +	spinlock_t *ptl;
> >> +	bool writable = false;
> >> +	pte_t *ptep;
> >> +
> >> +	// Do we want to migrate at all?
> >> +	minfo = hmm_select_migrate(range);
> >> +	if (!minfo)
> >> +		return 0;
> >> +
> >> +	fault_folio = (migrate && migrate->fault_page) ?
> >> +		page_folio(migrate->fault_page) : NULL;
> >> +
> >> +again:
> >> +	ptep = pte_offset_map_lock(mm, pmdp, addr, &ptl);
> >> +	if (!ptep)
> >> +		return 0;
> >> +
> >> +	pte = ptep_get(ptep);
> >> +
> >> +	if (pte_none(pte)) {
> >> +		// migrate without faulting case
> >> +		if (vma_is_anonymous(walk->vma)) {
> >> +			*hmm_pfn &= HMM_PFN_INOUT_FLAGS;
> >> +			*hmm_pfn |= HMM_PFN_MIGRATE | HMM_PFN_VALID;
> >> +			goto out;
> >> +		}
> >> +	}
> >> +
> >> +	if (!pte_present(pte)) {
> >> +		/*
> >> +		 * Only care about unaddressable device page special
> >> +		 * page table entry. Other special swap entries are not
> >> +		 * migratable, and we ignore regular swapped page.
> >> +		 */
> >> +		entry = softleaf_from_pte(pte);
> >> +		if (!softleaf_is_device_private(entry))
> >> +			goto out;
> >> +
> >> +		if (!(minfo & MIGRATE_VMA_SELECT_DEVICE_PRIVATE))
> >> +			goto out;
> >> +
> >> +		page = softleaf_to_page(entry);
> >> +		folio = page_folio(page);
> >> +		if (folio->pgmap->owner != migrate->pgmap_owner)
> >> +			goto out;
> >> +
> >> +		if (folio_test_large(folio)) {
> >> +			int ret;
> >> +
> >> +			pte_unmap_unlock(ptep, ptl);
> >> +			ret = migrate_vma_split_folio(folio,
> >> +						      migrate->fault_page);
> >> +			if (ret)
> >> +				goto out_unlocked;
> >> +			goto again;
> >> +		}
> >> +
> >> +		pfn = page_to_pfn(page);
> >> +		if (softleaf_is_device_private_write(entry))
> >> +			writable = true;
> >> +	} else {
> >> +		pfn = pte_pfn(pte);
> >> +		if (is_zero_pfn(pfn) &&
> >> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> >> +			*hmm_pfn = HMM_PFN_MIGRATE|HMM_PFN_VALID;
> >> +			goto out;
> >> +		}
> >> +		page = vm_normal_page(walk->vma, addr, pte);
> >> +		if (page && !is_zone_device_page(page) &&
> >> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> >> +			goto out;
> >> +		} else if (page && is_device_coherent_page(page)) {
> >> +			pgmap = page_pgmap(page);
> >> +
> >> +			if (!(minfo &
> >> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> >> +			    pgmap->owner != migrate->pgmap_owner)
> >> +				goto out;
> >> +		}
> >> +
> >> +		folio = page_folio(page);
> >> +		if (folio_test_large(folio)) {
> >> +			int ret;
> >> +
> >> +			pte_unmap_unlock(ptep, ptl);
> >> +			ret = migrate_vma_split_folio(folio,
> >> +						      migrate->fault_page);
> >> +			if (ret)
> >> +				goto out_unlocked;
> >> +
> >> +			goto again;
> >> +		}
> >> +
> >> +		writable = pte_write(pte);
> >> +	}
> >> +
> >> +	if (!page || !page->mapping)
> >> +		goto out;
> >> +
> >> +	/*
> >> +	 * By getting a reference on the folio we pin it and that blocks
> >> +	 * any kind of migration. Side effect is that it "freezes" the
> >> +	 * pte.
> >> +	 *
> >> +	 * We drop this reference after isolating the folio from the lru
> >> +	 * for non device folio (device folio are not on the lru and thus
> >> +	 * can't be dropped from it).
> >> +	 */
> >> +	folio = page_folio(page);
> >> +	folio_get(folio);
> >> +
> >> +	/*
> >> +	 * We rely on folio_trylock() to avoid deadlock between
> >> +	 * concurrent migrations where each is waiting on the others
> >> +	 * folio lock. If we can't immediately lock the folio we fail this
> >> +	 * migration as it is only best effort anyway.
> >> +	 *
> >> +	 * If we can lock the folio it's safe to set up a migration entry
> >> +	 * now. In the common case where the folio is mapped once in a
> >> +	 * single process setting up the migration entry now is an
> >> +	 * optimisation to avoid walking the rmap later with
> >> +	 * try_to_migrate().
> >> +	 */
> >> +
> >> +	if (fault_folio == folio || folio_trylock(folio)) {
> >> +		anon_exclusive = folio_test_anon(folio) &&
> >> +			PageAnonExclusive(page);
> >> +
> >> +		flush_cache_page(walk->vma, addr, pfn);
> >> +
> >> +		if (anon_exclusive) {
> >> +			pte = ptep_clear_flush(walk->vma, addr, ptep);
> >> +
> >> +			if (folio_try_share_anon_rmap_pte(folio, page)) {
> >> +				set_pte_at(mm, addr, ptep, pte);
> >> +				folio_unlock(folio);
> >> +				folio_put(folio);
> >> +				goto out;
> >> +			}
> >> +		} else {
> >> +			pte = ptep_get_and_clear(mm, addr, ptep);
> >> +		}
> >> +
> >> +		/* Setup special migration page table entry */
> >> +		if (writable)
> >> +			entry = make_writable_migration_entry(pfn);
> >> +		else if (anon_exclusive)
> >> +			entry = make_readable_exclusive_migration_entry(pfn);
> >> +		else
> >> +			entry = make_readable_migration_entry(pfn);
> >> +
> >> +		swp_pte = swp_entry_to_pte(entry);
> >> +		if (pte_present(pte)) {
> >> +			if (pte_soft_dirty(pte))
> >> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> >> +			if (pte_uffd_wp(pte))
> >> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> >> +		} else {
> >> +			if (pte_swp_soft_dirty(pte))
> >> +				swp_pte = pte_swp_mksoft_dirty(swp_pte);
> >> +			if (pte_swp_uffd_wp(pte))
> >> +				swp_pte = pte_swp_mkuffd_wp(swp_pte);
> >> +		}
> >> +
> >> +		set_pte_at(mm, addr, ptep, swp_pte);
> >> +		folio_remove_rmap_pte(folio, page, walk->vma);
> >> +		folio_put(folio);
> >> +		*hmm_pfn |= HMM_PFN_MIGRATE;
> >> +
> >> +		if (pte_present(pte))
> >> +			flush_tlb_range(walk->vma, addr, addr + PAGE_SIZE);
> >> +	} else
> >> +		folio_put(folio);
> >> +out:
> >> +	pte_unmap_unlock(ptep, ptl);
> >> +	return 0;
> >> +out_unlocked:
> >> +	return -1;
> >> +
> >> +}
> >> +
> >> +static int hmm_vma_walk_split(pmd_t *pmdp,
> >> +			      unsigned long addr,
> >> +			      struct mm_walk *walk)
> >> +{
> >> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> >> +	struct hmm_range *range = hmm_vma_walk->range;
> >> +	struct migrate_vma *migrate = range->migrate;
> >> +	struct folio *folio, *fault_folio;
> >> +	spinlock_t *ptl;
> >> +	int ret = 0;
> >> +
> >> +	fault_folio = (migrate && migrate->fault_page) ?
> >> +		page_folio(migrate->fault_page) : NULL;
> >> +
> >> +	ptl = pmd_lock(walk->mm, pmdp);
> >> +	if (unlikely(!pmd_trans_huge(*pmdp))) {
> >> +		spin_unlock(ptl);
> >> +		goto out;
> >> +	}
> >> +
> >> +	folio = pmd_folio(*pmdp);
> >> +	if (is_huge_zero_folio(folio)) {
> >> +		spin_unlock(ptl);
> >> +		split_huge_pmd(walk->vma, pmdp, addr);
> >> +	} else {
> >> +		folio_get(folio);
> >> +		spin_unlock(ptl);
> >> +
> >> +		if (folio != fault_folio) {
> >> +			if (unlikely(!folio_trylock(folio))) {
> >> +				folio_put(folio);
> >> +				ret = -EBUSY;
> >> +				goto out;
> >> +			}
> >> +		}  else
> >> +			folio_put(folio);
> >> +
> >> +		ret = split_folio(folio);
> >> +		if (fault_folio != folio) {
> >> +			folio_unlock(folio);
> >> +			folio_put(folio);
> >> +		}
> >> +
> >> +	}
> >> +out:
> >> +	return ret;
> >> +}
> >> +
> >> +static int hmm_vma_capture_migrate_range(unsigned long start,
> >> +					 unsigned long end,
> >> +					 struct mm_walk *walk)
> >> +{
> >> +	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> >> +	struct hmm_range *range = hmm_vma_walk->range;
> >> +
> >> +	if (!hmm_select_migrate(range))
> >> +		return 0;
> >> +
> >> +	if (hmm_vma_walk->vma && (hmm_vma_walk->vma != walk->vma))
> >> +		return -ERANGE;
> >> +
> >> +	hmm_vma_walk->vma = walk->vma;
> >> +	hmm_vma_walk->start = start;
> >> +	hmm_vma_walk->end = end;
> >> +
> >> +	if (end - start > range->end - range->start)
> >> +		return -ERANGE;
> >> +
> >> +	if (!hmm_vma_walk->mmu_range.owner) {
> >> +		mmu_notifier_range_init_owner(&hmm_vma_walk->mmu_range, MMU_NOTIFY_MIGRATE, 0,
> >> +					      walk->vma->vm_mm, start, end,
> >> +					      range->dev_private_owner);
> >> +		mmu_notifier_invalidate_range_start(&hmm_vma_walk->mmu_range);
> >> +	}
> >> +
> >> +	return 0;
> >> +}
> >> +
> >>  static int hmm_vma_walk_pmd(pmd_t *pmdp,
> >>  			    unsigned long start,
> >>  			    unsigned long end,
> >> @@ -404,42 +878,90 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
> >>  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
> >>  	unsigned long npages = (end - start) >> PAGE_SHIFT;
> >>  	unsigned long addr = start;
> >> +	enum migrate_vma_info minfo;
> >> +	unsigned long i;
> >> +	spinlock_t *ptl;
> >>  	pte_t *ptep;
> >>  	pmd_t pmd;
> >> +	int r;
> >>  
> >> +	minfo = hmm_select_migrate(range);
> >>  again:
> >> +
> >>  	pmd = pmdp_get_lockless(pmdp);
> >> -	if (pmd_none(pmd))
> >> -		return hmm_vma_walk_hole(start, end, -1, walk);
> >> +	if (pmd_none(pmd)) {
> >> +		r = hmm_vma_walk_hole(start, end, -1, walk);
> >> +		if (r || !minfo)
> >> +			return r;
> >> +
> >> +		ptl = pmd_lock(walk->mm, pmdp);
> >> +		if (pmd_none(*pmdp)) {
> >> +			// hmm_vma_walk_hole() filled migration needs
> >> +			spin_unlock(ptl);
> >> +			return r;
> >> +		}
> >> +		spin_unlock(ptl);
> >> +	}
> >>  
> >>  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
> >> -		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> >> -			hmm_vma_walk->last = addr;
> >> -			pmd_migration_entry_wait(walk->mm, pmdp);
> >> -			return -EBUSY;
> >> +		if (!minfo) {
> >> +			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
> >> +				hmm_vma_walk->last = addr;
> >> +				pmd_migration_entry_wait(walk->mm, pmdp);
> >> +				return -EBUSY;
> >> +			}
> >>  		}
> >> -		return hmm_pfns_fill(start, end, range, 0);
> >> +		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
> >> +			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
> >> +
> >> +		return 0;
> >>  	}
> >>  
> >> -	if (!pmd_present(pmd))
> >> -		return hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> >> -						 pmd);
> >> +	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
> >> +
> >> +		if (!pmd_present(pmd)) {
> >> +			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
> >> +						      pmd);
> >> +			if (r || !minfo)
> >> +				return r;
> >> +		} else {
> >> +
> >> +			/*
> >> +			 * No need to take pmd_lock here, even if some other thread
> >> +			 * is splitting the huge pmd we will get that event through
> >> +			 * mmu_notifier callback.
> >> +			 *
> >> +			 * So just read pmd value and check again it's a transparent
> >> +			 * huge or device mapping one and compute corresponding pfn
> >> +			 * values.
> >> +			 */
> >> +
> >> +			pmd = pmdp_get_lockless(pmdp);
> >> +			if (!pmd_trans_huge(pmd))
> >> +				goto again;
> >> +
> >> +			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> >> +
> >> +			if (r || !minfo)
> >> +				return r;
> >> +		}
> >>  
> >> -	if (pmd_trans_huge(pmd)) {
> >> -		/*
> >> -		 * No need to take pmd_lock here, even if some other thread
> >> -		 * is splitting the huge pmd we will get that event through
> >> -		 * mmu_notifier callback.
> >> -		 *
> >> -		 * So just read pmd value and check again it's a transparent
> >> -		 * huge or device mapping one and compute corresponding pfn
> >> -		 * values.
> >> -		 */
> >> -		pmd = pmdp_get_lockless(pmdp);
> >> -		if (!pmd_trans_huge(pmd))
> >> -			goto again;
> >> +		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
> >> +
> >> +		if (r == -ENOENT) {
> >> +			r = hmm_vma_walk_split(pmdp, addr, walk);
> >> +			if (r) {
> >> +				/* Split not successful, skip */
> >> +				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> >> +			}
> >> +
> >> +			/* Split successful or "again", reloop */
> >> +			hmm_vma_walk->last = addr;
> >> +			return -EBUSY;
> >> +		}
> >> +
> >> +		return r;
> >>  
> >> -		return hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
> >>  	}
> >>  
> >>  	/*
> >> @@ -451,22 +973,26 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
> >>  	if (pmd_bad(pmd)) {
> >>  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
> >>  			return -EFAULT;
> >> -		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> >> +		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> >>  	}
> >>  
> >>  	ptep = pte_offset_map(pmdp, addr);
> >>  	if (!ptep)
> >>  		goto again;
> >>  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
> >> -		int r;
> >>  
> >>  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
> >>  		if (r) {
> >>  			/* hmm_vma_handle_pte() did pte_unmap() */
> >>  			return r;
> >>  		}
> >> +
> >> +		r = hmm_vma_handle_migrate_prepare(walk, pmdp, addr, hmm_pfns);
> >> +		if (r)
> >> +			break;
> >>  	}
> >>  	pte_unmap(ptep - 1);
> >> +
> >>  	return 0;
> >>  }
> >>  
> >> @@ -600,6 +1126,11 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
> >>  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
> >>  	struct hmm_range *range = hmm_vma_walk->range;
> >>  	struct vm_area_struct *vma = walk->vma;
> >> +	int r;
> >> +
> >> +	r = hmm_vma_capture_migrate_range(start, end, walk);
> >> +	if (r)
> >> +		return r;
> >>  
> >>  	if (!(vma->vm_flags & (VM_IO | VM_PFNMAP)) &&
> >>  	    vma->vm_flags & VM_READ)
> >> @@ -622,7 +1153,7 @@ static int hmm_vma_walk_test(unsigned long start, unsigned long end,
> >>  				 (end - start) >> PAGE_SHIFT, 0))
> >>  		return -EFAULT;
> >>  
> >> -	hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
> >> +	hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
> >>  
> >>  	/* Skip this vma and continue processing the next vma. */
> >>  	return 1;
> >> @@ -652,9 +1183,17 @@ static const struct mm_walk_ops hmm_walk_ops = {
> >>   *		the invalidation to finish.
> >>   * -EFAULT:     A page was requested to be valid and could not be made valid
> >>   *              ie it has no backing VMA or it is illegal to access
> >> + * -ERANGE:     The range crosses multiple VMAs, or space for hmm_pfns array
> >> + *              is too low.
> >>   *
> >>   * This is similar to get_user_pages(), except that it can read the page tables
> >>   * without mutating them (ie causing faults).
> >> + *
> >> + * If want to do migrate after faultin, call hmm_rangem_fault() with
> > s/faultin/faulting
> >
> > s/hmm_rangem_fault/hmm_range_fault
> 
> Will fix, thanks!
> 
> >
> >> + * HMM_PFN_REQ_MIGRATE and initialize range.migrate field.
> > I'm not following the HMM_PFN_REQ_MIGRATE usage.
> >
> >> + * After hmm_range_fault() call migrate_hmm_range_setup() instead of
> >> + * migrate_vma_setup() and after that follow normal migrate calls path.
> >> + *
> > Also since migrate_vma_setup calls hmm_range_fault then
> > migrate_hmm_range_setup what would the use case for not just calling
> > migrate_vma_setup be?
> 
> It's the call context that matters. When resolving device faults and based on a policy,
> some regions you mirror, some migrate, you start with
> call(s) to hmm_range_fault() (+HMM_PFN_REQ_MIGRATE optionally),
> and explicitly call migrate_hmm_range_setup() + other migrate_vma* when migrating.
> For resolving device faults it's just the hmm_range_fault() part like before.
> For current migration users, migrate_vma_setup() keeps the current behavior calling
> hmm_range_fault() under the hood for installing migration ptes 
> after optionally bringing in swapped pages (with MIGRATE_VMA_FAULT).
> I think we get better understanding how the entrypoints should look like when used for a real device.
> For now I have tried to keep the current behavior and entry points, refactoring under the hood
> for code reuse.
> 

I’m not completely following the above, but I did think of a case where
hmm_range_fault + migrate_hmm_range_setup is better than using
migrate_vma_setup() alone. Previously, before calling
migrate_vma_setup(), we had to look up the VMA. If hmm_range_fault
populates the migrate_vma arguments (include the VMA,) that’s better
than the current flow.

> >
> >>   */
> >>  int hmm_range_fault(struct hmm_range *range)
> >>  {
> >> @@ -662,16 +1201,28 @@ int hmm_range_fault(struct hmm_range *range)
> >>  		.range = range,
> >>  		.last = range->start,
> >>  	};
> >> -	struct mm_struct *mm = range->notifier->mm;
> >> +	bool is_fault_path = !!range->notifier;
> >> +	struct mm_struct *mm;
> >>  	int ret;
> >>  
> >> +	/*
> >> +	 *
> >> +	 *  Could be serving a device fault or come from migrate
> >> +	 *  entry point. For the former we have not resolved the vma
> >> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> >> +	 *
> >> +	 */
> >> +	mm = is_fault_path ? range->notifier->mm : range->migrate->vma->vm_mm;
> >>  	mmap_assert_locked(mm);
> >>  
> >>  	do {
> >>  		/* If range is no longer valid force retry. */
> >> -		if (mmu_interval_check_retry(range->notifier,
> >> -					     range->notifier_seq))
> >> -			return -EBUSY;
> >> +		if (is_fault_path && mmu_interval_check_retry(range->notifier,
> >> +					     range->notifier_seq)) {
> >> +			ret = -EBUSY;
> >> +			break;
> >> +		}
> >> +
> >>  		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
> >>  				      &hmm_walk_ops, &hmm_vma_walk);
> >>  		/*
> >> @@ -681,6 +1232,18 @@ int hmm_range_fault(struct hmm_range *range)
> >>  		 * output, and all >= are still at their input values.
> >>  		 */
> >>  	} while (ret == -EBUSY);
> >> +
> >> +	if (hmm_select_migrate(range) && range->migrate &&
> >> +	    hmm_vma_walk.mmu_range.owner) {
> >> +		// The migrate_vma path has the following initialized
> >> +		if (is_fault_path) {
> >> +			range->migrate->vma   = hmm_vma_walk.vma;
> >> +			range->migrate->start = range->start;
> >> +			range->migrate->end   = hmm_vma_walk.end;
> >> +		}
> >> +		mmu_notifier_invalidate_range_end(&hmm_vma_walk.mmu_range);
> >> +	}
> >> +
> >>  	return ret;
> >>  }
> >>  EXPORT_SYMBOL(hmm_range_fault);
> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >> index 23379663b1e1..d89efdfca8f6 100644
> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -734,7 +734,17 @@ static void migrate_vma_unmap(struct migrate_vma *migrate)
> >>   */
> >>  int migrate_vma_setup(struct migrate_vma *args)
> >>  {
> >> +	int ret;
> >>  	long nr_pages = (args->end - args->start) >> PAGE_SHIFT;
> >> +	struct hmm_range range = {
> >> +		.notifier = NULL,
> >> +		.start = args->start,
> >> +		.end = args->end,
> >> +		.migrate = args,
> >> +		.hmm_pfns = args->src,
> >> +		.dev_private_owner = args->pgmap_owner,
> >> +		.migrate = args
> >> +	};
> >>  
> >>  	args->start &= PAGE_MASK;
> >>  	args->end &= PAGE_MASK;
> >> @@ -759,17 +769,19 @@ int migrate_vma_setup(struct migrate_vma *args)
> >>  	args->cpages = 0;
> >>  	args->npages = 0;
> >>  
> >> -	migrate_vma_collect(args);
> >> +	if (args->flags & MIGRATE_VMA_FAULT)
> >> +		range.default_flags |= HMM_PFN_REQ_FAULT;
> > Next level here might be skip faulting pte_none() in hmm_range_fault
> > too?
> 
> That would be a possible optimization!
> 

Yes, I think that would make this really useful, and we (Xe’s SVM
implementation) would likely always want to set the flag that says
‘fault in !pte_present() && !pte_none’. I’m not 100% sure on this, but
that’s my initial feeling.

Matt

> >
> > Matt
> 
> Thanks,
> Mika
> 
> >
> >> +
> >> +	ret = hmm_range_fault(&range);
> >>  
> >> -	if (args->cpages)
> >> -		migrate_vma_unmap(args);
> >> +	migrate_hmm_range_setup(&range);
> >>  
> >>  	/*
> >>  	 * At this point pages are locked and unmapped, and thus they have
> >>  	 * stable content and can safely be copied to destination memory that
> >>  	 * is allocated by the drivers.
> >>  	 */
> >> -	return 0;
> >> +	return ret;
> >>  
> >>  }
> >>  EXPORT_SYMBOL(migrate_vma_setup);
> >> @@ -1489,3 +1501,64 @@ int migrate_device_coherent_folio(struct folio *folio)
> >>  		return 0;
> >>  	return -EBUSY;
> >>  }
> >> +
> >> +void migrate_hmm_range_setup(struct hmm_range *range)
> >> +{
> >> +
> >> +	struct migrate_vma *migrate = range->migrate;
> >> +
> >> +	if (!migrate)
> >> +		return;
> >> +
> >> +	migrate->npages = (migrate->end - migrate->start) >> PAGE_SHIFT;
> >> +	migrate->cpages = 0;
> >> +
> >> +	for (unsigned long i = 0; i < migrate->npages; i++) {
> >> +
> >> +		unsigned long pfn = range->hmm_pfns[i];
> >> +
> >> +		pfn &= ~HMM_PFN_INOUT_FLAGS;
> >> +
> >> +		/*
> >> +		 *
> >> +		 *  Don't do migration if valid and migrate flags are not both set.
> >> +		 *
> >> +		 */
> >> +		if ((pfn & (HMM_PFN_VALID | HMM_PFN_MIGRATE)) !=
> >> +		    (HMM_PFN_VALID | HMM_PFN_MIGRATE)) {
> >> +			migrate->src[i] = 0;
> >> +			migrate->dst[i] = 0;
> >> +			continue;
> >> +		}
> >> +
> >> +		migrate->cpages++;
> >> +
> >> +		/*
> >> +		 *
> >> +		 * The zero page is encoded in a special way, valid and migrate is
> >> +		 * set, and pfn part is zero. Encode specially for migrate also.
> >> +		 *
> >> +		 */
> >> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE)) {
> >> +			migrate->src[i] = MIGRATE_PFN_MIGRATE;
> >> +			migrate->dst[i] = 0;
> >> +			continue;
> >> +		}
> >> +		if (pfn == (HMM_PFN_VALID|HMM_PFN_MIGRATE|HMM_PFN_COMPOUND)) {
> >> +			migrate->src[i] = MIGRATE_PFN_MIGRATE|MIGRATE_PFN_COMPOUND;
> >> +			migrate->dst[i] = 0;
> >> +			continue;
> >> +		}
> >> +
> >> +		migrate->src[i] = migrate_pfn(page_to_pfn(hmm_pfn_to_page(pfn)))
> >> +			| MIGRATE_PFN_MIGRATE;
> >> +		migrate->src[i] |= (pfn & HMM_PFN_WRITE) ? MIGRATE_PFN_WRITE : 0;
> >> +		migrate->src[i] |= (pfn & HMM_PFN_COMPOUND) ? MIGRATE_PFN_COMPOUND : 0;
> >> +		migrate->dst[i] = 0;
> >> +	}
> >> +
> >> +	if (migrate->cpages)
> >> +		migrate_vma_unmap(migrate);
> >> +
> >> +}
> >> +EXPORT_SYMBOL(migrate_hmm_range_setup);
> >> -- 
> >> 2.50.0
> >>
> 

