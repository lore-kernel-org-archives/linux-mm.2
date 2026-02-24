Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E5AF4BB7A
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 19:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AC1D6B0005; Tue, 24 Feb 2026 14:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25A236B0089; Tue, 24 Feb 2026 14:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7136B008A; Tue, 24 Feb 2026 14:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E93596B0005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 14:47:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 977B08A84B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:47:26 +0000 (UTC)
X-FDA: 84480384492.08.6B5A378
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAA2B18000C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 19:47:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eEmpJq95;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771962443; a=rsa-sha256;
	cv=pass;
	b=yJTKvE+5Dc6Q4ZmaDwYQWai/gp2AUL+II1+IveB4rqQAuEMoKYHgWw6ZW5Je/cIfNrDmwk
	9b9e3GGV4cHsaXAXI2gYHZZfvZ1xVu5jnlXCKyJvCuuVrrvU0vXLgF/M29ZfJnIiql8C6w
	1CR9G3phqChQnn7MrnUv86CPOrOE7aE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eEmpJq95;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771962443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqQJ5a+DaLd1sEnglgRCE2eIE+9NfkwW/LjywX+CYRI=;
	b=vYXMjGqBYBDieQIkXDadIqYF02NSRb9ov3AmZftacduxAr/HfaBhZM1PSai0t8KidocFB7
	PobskbauBrznHhqEqYk3r7aUS9KHUF8fBjyR4y7RquX8ul5QGttsiVEYgg5eJNTXsoK7qf
	JQGhblto3xU+IywSwEyLWetIHhc6bgk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771962441; x=1803498441;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IqQJ5a+DaLd1sEnglgRCE2eIE+9NfkwW/LjywX+CYRI=;
  b=eEmpJq956S9Pp/hWjEW05ygTbEsslEUIR5OvrLkyyghUxacU2MXf60R1
   3WufFQUF9G/2CXaggc6OYRAvC/k7SSdLzPlultAh/N5d/xUdM8d6laluw
   QglXLpcxcz760xD31RPe/fjkQffIQsjJf/XzEsJ9ucAaGxbnYF+TqGn9z
   7xDOGdcwtnq4g8t/BrDo/YVte7z2S7kJfAiSJBEEDf51w/FlmC/huKL7W
   FzpCmBpGeJAuHIwPTJ79DCXIcEWBhnuiPRf9x5GXNI4HO6Hrfg/PLk3ke
   jHE6fXvv2+aS64518W7U+0vwBHuxblYfqnGGvBE0o19c8oVEjdQxk/1oo
   A==;
X-CSE-ConnectionGUID: h+peUPSGRmi2q3YyLor0YQ==
X-CSE-MsgGUID: X54DpM6fRSqDy8bRl/LtSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11711"; a="98457344"
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="98457344"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 11:47:20 -0800
X-CSE-ConnectionGUID: ew1edbn7Qdii2WcV8Jd1aQ==
X-CSE-MsgGUID: Jv/n+Z/xS1WRzadbLDpu0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,309,1763452800"; 
   d="scan'208";a="239008737"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 11:47:20 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 11:47:19 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 11:47:19 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.0) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 11:47:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M1P6fJ3eW0BpxX7+4uu2ENVHXvs8qxfFi8CW66FFoIJVXC8ZYKqa3UQ1JTAoa1NvsrmpDrdE+0jGV3b3R+nJDxyTcvZ157QDhVQMHIW505VMLWb85V6SZv6rmslAas5GdTv/P7+zYzyGnP7Sj8NYKBEhLmTUn1PuOFp0qp2G41GHFJLYTpopNAdai0PG2B/HEH9fU3b7HbQBNbz6I0+NTCsFwq77mJPg45KBE1nlr6sq/wf68BZn7Q9SrZXBnxJYU7e8qWNdv5OCFerIvL4wmFggTh+/B0VdVY+GmxIrhmoWEanFPv7bJl/HekKXhyIKpxnTqC0tO9SMUe18rZj+qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IqQJ5a+DaLd1sEnglgRCE2eIE+9NfkwW/LjywX+CYRI=;
 b=hz6CYrhWEbi5c60XiFeyNKdegjmJn/i3YFfCFBoAzP3+E9XDOVvCimQ70zge7OhlBjR59y9R3oiaDeOdHCvTiJXZLjeXPB5emUStmxYijO0Np8mMvhdIH9z0zFapJLRqjq1HHeNatEIUMu4eZ1uNYa7oM46NLATgmdXSM7ZPV+L9H6ldo5usDMKbOTKfC5HcyswK+QXt7eYtz7viVg1NKLhlBnxIbOPc1D/KksbdkhNBG0ta2M5Bxqw//OjB6xyTHztG0R0cOzZUKcn4Jzx5dcrKOGIrCSzSfFG01bu/aHbSUygrbJN5n/zs6jncxM9MgL0SasB2/UFEiansWnHI9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8863.namprd11.prod.outlook.com (2603:10b6:208:598::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Tue, 24 Feb
 2026 19:47:11 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9632.010; Tue, 24 Feb 2026
 19:47:11 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "david@kernel.org" <david@kernel.org>, "broonie@kernel.org"
	<broonie@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "debug@rivosinc.com"
	<debug@rivosinc.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"alex@ghiti.fr" <alex@ghiti.fr>, "aou@eecs.berkeley.edu"
	<aou@eecs.berkeley.edu>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"will@kernel.org" <will@kernel.org>, "tglx@kernel.org" <tglx@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] mm: Introduce vm_mmap_shadow_stack() as a helper for
 VM_SHADOW_STACK mappings
Thread-Topic: [PATCH 1/5] mm: Introduce vm_mmap_shadow_stack() as a helper for
 VM_SHADOW_STACK mappings
Thread-Index: AQHcpbcsVpAGC9/Fwkupapd/P4x0AbWSQUwA
Date: Tue, 24 Feb 2026 19:47:10 +0000
Message-ID: <cec3d1a8939f591208756ed11dea584a2a488360.camel@intel.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
	 <20260224175800.2500729-2-catalin.marinas@arm.com>
In-Reply-To: <20260224175800.2500729-2-catalin.marinas@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8863:EE_
x-ms-office365-filtering-correlation-id: c10eaf5b-5a16-42cd-7cac-08de73dd803e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?RXl4M1FSUW82TkFHYUN4MmxIbWRNYXZBdW0zSUhkdkQ0V1RKU0t5NmNTV1Mx?=
 =?utf-8?B?cHdHdlVIeS9KMHRUbXJqSmF5a1VDMmtxYjIxaGFGNEVNOVFNVW12NXN4dm5S?=
 =?utf-8?B?QzZBSWo4ZkE1aW9ZanBzeENYS3A0ek1YNVU4MmFLa2ZVMk9Qdld6cWV4N1Q2?=
 =?utf-8?B?bVRoOUtGSmVJNkVLL0Z3eEZvY3FWaGc5OGpEMHE4MmpXdjQ5SmdkYXFSbGc5?=
 =?utf-8?B?TlRXanlRbXJpcXA4RGFTam9UY3BuY3I5Y3BaMEpNbVNZaVE5R0xiMTIrTUts?=
 =?utf-8?B?STBxYTVFdzhsK1E5REI2UDRTOURoR3ZzL2l2dmYxdkFJcnkrOTE1dE1KaXBG?=
 =?utf-8?B?SVZ5QWNWYWdtUkRJVGFOL3lGc1Bwd0I3cll1QXR2Qi9oRTJQcXRESTYwUG1K?=
 =?utf-8?B?bDN3eSs5OVlXalU2cTEySXdmdXp0SWJETGJjcEhLQVZsU2dNMGIrUm15bUJQ?=
 =?utf-8?B?NWVKUlYrZ3dUSUFraEl0eExReVlhNEZkTUs5YnQrL2l6cFBNYyt2bUM4VnNF?=
 =?utf-8?B?RlR6a0ZnU21vaHlvbzRuOTlReGZhU1AxTTI1bmJrb2U4ZDRTb2hmRUdERlJY?=
 =?utf-8?B?bkR6YlFiSlNuWkxieHVROU1GNnhQSG1QTVlEWkJNdmxkM2Jwb0M5NkJCT1lP?=
 =?utf-8?B?QnZTcGJTQU1YUkxjQnY0TVpiTEgyeTh1TURWd0JYallCbEVMeko3QnZUSWxU?=
 =?utf-8?B?N3p2RkM3b1pFMjFPSDFJS2s4VGtQOE14YzVCS1k4TUI2UlVGdUo4SjFqdkdV?=
 =?utf-8?B?THAvSm45M3pranhyWmhQWjJUVE1ySTNVWnk0M2U5VDRHdVp6WTQ2UTI5UDZ4?=
 =?utf-8?B?Y2VCK2h3dkJPaEFwWjJHYXdWQjhEcFY3N0V0ZFMxTWh3ZnVnUHdBTmtSdWRD?=
 =?utf-8?B?TGIwaWNGS1ZyOTg5eW1TbzBhMkh3b0xISW9SRk03WndkWFBkL3hSZVJvS1lM?=
 =?utf-8?B?YnhzbStOS0kwZXlnM2h4NGlxZmZxK1dMRXBZTWozV0dHb2I5WlprWTZIcjJl?=
 =?utf-8?B?QUs4RTlUcDRSU2IwbXIrc2dzQnlxdGNURGQxY1Q5a2JXbTFHMnlzYzJWczFt?=
 =?utf-8?B?Q2xDRnU3RUJyVGNLUGRjYXpXbHVhdUROSGRMam8ybS8zOW9lSE1tVzZEdFJr?=
 =?utf-8?B?TUt4Z2dEYS9iUVVkZnJua21YNWVxNXNWaVhOTWhNbC9YbTJMcUh1d01vQjl2?=
 =?utf-8?B?TC83M1UzbE5xZkZPSjBTaFdFR0V6a2QvZVc1TzdSMGxWUnBBSi9zNlVCMHlu?=
 =?utf-8?B?NTFnYkFSUll5QnloUEw1amc0OXFnZThVTTkwcEtJaVpVbEl3ZG5QYndLS0Za?=
 =?utf-8?B?UDdCTTZ6dUlmV3RabU41TFZmNHo0N2pwRjA4UUluaXRnSU9BQ2xPL25qdHBp?=
 =?utf-8?B?TktSUS9KQmw3QmRqRmpiV3dVSXNmeExxUGF1cjlzcnN4Y3ZGZTl4ams2aUZW?=
 =?utf-8?B?d1Y1bjlvM1RyS2lXWkpBOXV5SXptZ0lQRTVhNDBoY1ZDYzJNOUZ5TkJUVzd3?=
 =?utf-8?B?K2pxQm9rRDhtdE8rTEVGbHRVQXRWemNaQXdPQW9NT3A3TXhZWXVGaEg4aElz?=
 =?utf-8?B?dWNKTUQ1WjYzc2k4dUlpc0dNc1lyOEZPQUZLSTlQZkF0TWdhU1QwbUZEQ0M3?=
 =?utf-8?B?YS9DSklnT0hsc0NJSWUyMEpLTFRVZnNwbk84Znh2d3lQeUUyQ1ZMMzFSM3lv?=
 =?utf-8?B?NzVPeE1MaUdIazlVSUpKZm80Nzl3QzB6NUVRTnFUSmJGM0dMRlJ1NlAydEtZ?=
 =?utf-8?B?VFFzeG41aFJHS1lvUENKVTZ0S0tGZUJ6V1JWenJtdTQrT2JHck1Sd3d2WkNm?=
 =?utf-8?B?SGJrdy9TSHRyVXpYbkpMM1BSQlZrOWcwb3RCUXNVaWxZNERhaUV6bTRxT3Vw?=
 =?utf-8?B?WjRuSjlNenlYdGhkVVJOQVlESlVpR2xnNkVMWWhrOW9VZUZPMHV3em4zbkFv?=
 =?utf-8?B?aEtpMGFoL09VSzh2cGcwSmMrRXdDcEF5Ykx3dkVVbTdTenhNS0NSQU1BN05K?=
 =?utf-8?B?Vlc5U2lESU04eE8zM2ZVWlMwdExPUzVSSXIwUDEvM2tkTWxibm9BeElTSWdB?=
 =?utf-8?B?eGNBdG1ZWmEvM3FiNzNqU2tRY1RJY1FpNlhiakJaZGFEZ3hxWmh3SEtzc014?=
 =?utf-8?B?dFlmeW1FSWdxZ21TYmhzbWRkTHpLejJ3cGhRVlQ0WGtRVTZ1VzFXUG1Cd0Rl?=
 =?utf-8?Q?GgUnqAB2pqi8XbPLTPewVow=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WHdYRFliSHZsT3dFVmJOcjEySUZ6Uk9TcERRYk95UWhBYkh0L0RBbFVYeW1t?=
 =?utf-8?B?V296a0cwemp2WEZtbVdzU2Q3NUlmNHhGQUk3VzBaYUs4SENvUHhoNkxYOVZr?=
 =?utf-8?B?WVIwMkV6a1NVQ1VJdnBuc0lUUU1qMTkyYVBVemFXQ2EwYWhOMlg5cVBsUkRm?=
 =?utf-8?B?UjFoRTIvdnpIK28yZ0puR09ycHI0UGR6Z2R0Nm1qY1M2bVFkZHFXWTJoZHVE?=
 =?utf-8?B?Mkp5LzJQMUlXYzl2Y1owY3JSTUd1bmNab1J5a0xoWFdaK3JFaWIvd2J4WHVM?=
 =?utf-8?B?ZWFlbDh2UzZ6K1dHQkFXNmZ0RVAzQkJpMTZ3QkpQNEV6SVF6YUxyd3NsaS9H?=
 =?utf-8?B?K1BONkpxbzRDL1dIdk1YUzNwd3ZhbFJJOERPcXFXQ3U4NDNqNGhKTUoxY2dT?=
 =?utf-8?B?K0l5RmUxK2R4ZVQxSnB3b0dpTnFKWUNwUVFqUFltN1lhUXAwQnhhS0FGalcy?=
 =?utf-8?B?TnlraFpRQklKWERTc0Ztb0U3Vkkya09GRHhnVm1ydStDVmY4WTVwWlVadW5R?=
 =?utf-8?B?VWRNZDFJZjBCTVdmbFlTS3ZWS1ZBVkUwMXZVL1FmK0MvUVF2ZUpURUs3dHE2?=
 =?utf-8?B?ekNwZ1pqV1Q3ZWFyUmJYRWZGMG1FL1dHaDVIS3NUd2JFTHBSU2hwUW9NdXhQ?=
 =?utf-8?B?blRmNERJN3QzRUJFNEFIeGtXVFVTOGVzWmtPTWJlZEhINFVRcndTb0JkKy9I?=
 =?utf-8?B?UTBTMmVNcU91SjRYZllhT0ljbFRaL1h6N1BlSXc1L0luRE93ZSsxbk0rWWFN?=
 =?utf-8?B?U3cxL3NrOFpzY21RYXk0U2ZnSGo2cXF5L0lLUGxRV1RCOUZ0YXpHOUZIVHhT?=
 =?utf-8?B?Mlh4RXhaSmVITkN5UTlSaXZ4bFR3Q3F0QWswVUhlMzR0aFBDQU9FWlhTQVdx?=
 =?utf-8?B?WEk0ZGRHdjB3bDVZWGxoSWpTb3ZYbFJ4MWpvTkdLT0dnTFFuYVRIOVFSdzli?=
 =?utf-8?B?eGl4VzQxQ3VEWnZzbERwbitzWHoxN2dVRlgxdU5XTVNpTzJQUFlJaUFHUzBj?=
 =?utf-8?B?clRYUlk2WXFBTUFvSlpkZnFkS3Zidnl1ajhDYTZXYStnTE9MRVJpdkxUQjFo?=
 =?utf-8?B?b3JvSzZDR0QrQ2dUekNSRUJaZnhYUjRxZ1ZUN2tMbGE5RFk4SG5pN0pRMmtj?=
 =?utf-8?B?dFpRNlNNczFpSGRqd2d3QmlnN1VsNXpKdkVpL1RlUCt3MGwyUHFxVUh4b1dm?=
 =?utf-8?B?U2RWWENRREREL2hJV01DdEZmTU1TeTJpV296NlozRFlLYmVjQ3UvOFo5OUxl?=
 =?utf-8?B?UTU5SjZ5dVRRK0kwKzI0UFBPOEkrMUFnMXpkZFRHNlk5ajduVko3QXF0NXd6?=
 =?utf-8?B?NWhQTHVodU8wN01WOWNTT0xCaDg3QnpHckd2bEpaUDV0OThoMHV0d0RGMU1t?=
 =?utf-8?B?bFg0VEY5MmZOandmNDhJUjNDejhsNDhRMm9LOVFXdktla05iZ28vZ0VqU0VJ?=
 =?utf-8?B?OTZmKy9Zb3QwZkh1QjNwaDhKeFVZRy8rYVJPbzVQcGNZRzhPTlZxY2J2aWlU?=
 =?utf-8?B?TlZXclFtOEw1bzI3WVFtQTRXUWZXNzlQVHF6VlcwNUw4TkQxRmpHQ04zbFUy?=
 =?utf-8?B?bENzVWZkc0tOZVlpNDNaSmk4WVFmT1dING56bk82SnA3cTBpNkV0ME5NMUZJ?=
 =?utf-8?B?ZVlISGRJZUhiUTNIcDBYeTBaYm5MelkwOWZYYlo4U0lveCtwNFM4KzdkZ3dP?=
 =?utf-8?B?eW02MmV2SWtRQjBvUU9aTTVyT2NwTjVXMlFVbXJGN2F0eDZWSmk2WlpWcHZ3?=
 =?utf-8?B?QndvclhrZTdQQzRheUFUL212TC8rYkc2TzRjOEJwL1p6a0dMYkdTUjdaRzIv?=
 =?utf-8?B?ZUh6TGQ2Zis3MWNFZjFlc01jRTBsamhNeFNiSUQ2Ym9meTgrQ2g3dlBHYnMr?=
 =?utf-8?B?VTlzRXBSREZmSVN6eTBFdU12bWRRdUR0UFNlb2QvMkhjc2RtVU05V0hzWEV1?=
 =?utf-8?B?MStzSGhDU0Rqb25KVXNVZlNBR096THJsTG9zWGxIR3VQcFhHR0dEVmlmbGg0?=
 =?utf-8?B?cGluOWxoTVFmdXlrbDBtVTJxV01wWlU4YWduV0VnSk9nbFQ0cEUvSjJZT2d5?=
 =?utf-8?B?UktYbmlCbXJhNXNTeVllOFU3OEVoTVE3OVA1VUdpSm52ak1uMGVaU3J1UDdH?=
 =?utf-8?B?WjU4b0wzdGRyZjJ1VTJ5Rmk0TlJOVzJZVytla1ZHYXBEQTNhQjlCQWczZlhZ?=
 =?utf-8?B?UklSdzhEb1pDTnE5Ry9lTUtwZUlEeWtnczkvTnpFVXJaKzVxV0RYODA0SSto?=
 =?utf-8?B?NWRYd1hNU3lzK080dzJqWXkraHcyNEJaMWFvcHJVRDA2TzBsZERFdEhNNFhQ?=
 =?utf-8?B?cGNBZ09scmxzSE1uSzYydmNBL2Z6NW5wUGc1VXJ4NC9hMzh0dXpwQUZOb0dw?=
 =?utf-8?Q?Q549bVXSOGacrfPQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE636F1FFDF9844DBF29420BAF7F0421@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c10eaf5b-5a16-42cd-7cac-08de73dd803e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 19:47:10.9657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8F14lhhGy2EyNZ6RRmUT8bspq3jV6t1o32XsNQhOle2WQ4sNsiSnGYgngznB8uCssrDoKK6uAVDFUUAepKmlE2+5JuIH1RxlL70ySTb6irA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8863
X-OriginatorOrg: intel.com
X-Stat-Signature: 3kx5awrwgcfaxy7xai15qaqacjneibon
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BAA2B18000C
X-HE-Tag: 1771962441-185965
X-HE-Meta: U2FsdGVkX1/qwLNKMtbXq2ipVlub83zBVX2EUl5bZKKJRt5vwmBHnyHyk6jfus5syXzFwLI5Cc7GrfGbqbEoeHj9q/PNf3Cv6oCMRY5pKSABlrtFthA2jjBGa0+U1NVW4pJOn5Sz5cb5ZshgORH+hyAofGhO40Q01BOYXiE1NsOsCipHwOSfTPI5R6fvmPoWdJeRBSnVAxAitj49YnBbk7nxVbMIh9smLQnKG2pY7T4otqND3xY9vFjQjYBrIiYNEelYoTWXweBpYRxCajN2S3Bu2/+M+QGq9nkb08Zx+q7L3Raa/g9vnKhLcnmxjII41GO/pKYblnX6IixBdEG5sY044WqME9dy0p2J2Dks4+CS9DF93sWVuNHIsADDotL3IHKgNdedaiFr2VOH1G54/nEZ9jCedWD6t2dNerr7iY7f20fu5SgtVFAQFMH9rwlF7NPGNOgwUkxMFKw3Xeu9U7jswMRB/l8AnNFuwwQwSMdJp1HScFBk6op29OSVM4W3LxNLQo9tOjnmCkuomSyz8XosraNobNRDkbYN4I9HTHd+p1N0itmxky1m4OMkzgwGyWCCNUQWi3dRaaGSf/9ly4UtvPt7za+0CLQQloC9w9Jr9c6f9xymwYBL9Q9kHeLXZI5tsG84QmNRKye3rZFbFbNmk2h7anFs7FMHFdf+Dy/ZBf26SjuyPo0MeUmzJw+S8ANd34DSTjfGr89h9JbuReRiE/HaSgpWaynUko8CKet0GRS11WkZiUwCIf2exK0mc5DmVL4ZNanzHbCbDVdXtIqfUeU+nhapgBeC4RfGdh1FxImMidRF3hpmCvEiB+Ilkbom7uHZoJld8Y256GI3ViZRHMt0N/hQTOfCEYXF4Q9eNuwpN9FaWrwQWiClU63LJyBtbP8e/BHJAWkvVQdXUXxvw47qBt+IfH4raak4K3wy2O5YVu1g8FCIR00rhoTz0ayYd/ut26JLdiJ+kZW
 G6zSLlGp
 XdX2ekIKib0TVrNI5ioz27Dg7QoZGx5T3nSgcXegcbCA9BLwXymZoovAs+crk3E5pHY1DszjMR8+MQqBJtbvhdCi/VB7NWGRIRTKn1QTbCG7PXAs7ivi13f9fu1aZ2xDjlgRMveAGzgbBvLgCzhgDWXkMWNFj0IiNEbOrAa6GLRdxXDyKvgadQGlhKIFEk9ACla1gOIIK8DthARgAnGbwhJswXf45eFmlYk5tasmHjOvFCrp5UxUP5rBwJM0oQboBIvnr4OQB/ziYTh7Fa+QZokORfqeTHo0KJP5/ZU7j0m/+VLZlY4YTf5SEKlJ1P5tjXeBNwST6a7zYGUp0JlZO+Ij6lhCViLmHt649Q0Ncfbs+XdbDRFGTLI2XK52IhHiVnLsN5VXBMH89KLTTNFEMZ3geL5VwKQ6K6DX4sjSzfvIYxTVoxZjXFbvHMrRpOk2f8rhhGcG2I5hRpu0DXjTSchEaCPphwvXpCjXZrdwnurPlt3IxQ4f936jm46ncMCB+K5dLrbPfB/ZA7EG7XrulDxwBjESiZZHt1ORxcbfTvHdc6a9mpoqN8qSuFDZ//HvGF0Bse5VmaTSfA8tyV3YRnz1AH4YIBksjpxZ5LuBzrOAVuVeFh2NvPc+X7G4zEHkx9QEz3rYZBEqNdjjSqcClMOpoeI+y9XKMEhra+q9Cf4pwhPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDE3OjU3ICswMDAwLCBDYXRhbGluIE1hcmluYXMgd3JvdGU6
DQo+IGFybTY0LCByaXNjdiBhbmQgeDg2IHVzZSBhIHNpbWlsYXIgcGF0dGVybiBmb3IgbWFwcGlu
ZyB0aGUgdXNlciBzaGFkb3cNCj4gc3RhY2sgKGNsb25lZCBmcm9tIHg4NikuIEV4dHJhY3QgdGhp
cyBpbnRvIGEgaGVscGVyIHRvIGZhY2lsaXRhdGUgY29kZQ0KPiByZXVzZS4NCj4gDQo+IFRoZSBj
YWxsIHRvIGRvX21tYXAoKSBmcm9tIHRoZSBuZXcgaGVscGVyIHVzZXMgUFJPVF9SRUFEfFBST1Rf
V1JJVEUgcHJvdA0KPiBiaXRzIGluc3RlYWQgb2YgdGhlIFBST1RfUkVBRCB3aXRoIGFuIGV4cGxp
Y2l0IFZNX1dSSVRFIHZtX2ZsYWcuIFRoZQ0KPiB4ODYgaW50ZW50IHdhcyB0byBhdm9pZCBQUk9U
X1dSSVRFIGltcGx5aW5nIG5vcm1hbCB3cml0ZSBzaW5jZSB0aGUNCj4gc2hhZG93IHN0YWNrIGlz
IG5vdCB3cml0YWJsZSBieSBub3JtYWwgc3RvcmVzLiBIb3dldmVyLCBmcm9tIGEga2VybmVsDQo+
IHBlcnNwZWN0aXZlLCB0aGUgdm1hIGlzIHdyaXRlYWJsZS4gRnVuY3Rpb25hbGx5IHRoZXJlIGlz
IG5vIGRpZmZlcmVuY2UuDQoNCldlIGFsbG93IG1wcm90ZWN0KClpbmcgc2hhZG93IHN0YWNrIG1l
bW9yeSB3aXRoIFBST1RfV1JJVEUgdG8gc2V0IG9yIGNsZWFyDQpzaGFkb3cgc3RhY2sgdHlwZSBv
ZiB3cml0YWJpbGl0eS4gU28gUFJPVF9XUklURSBkb2Vzbid0IGV2ZW4gaW1wbHkgbm9ybWFsDQp3
cml0YWJsZSBtZW1vcnkgaW4gdGhlIHJlYWwgbW1hcCgpIHN5c2NhbGwuIEkgYWdyZWUgdGhlIGNv
ZGUgaXMgY2xlYXJlciB3aXRoDQp0aGlzIGNoYW5nZS4NCg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Q2F0YWxpbiBNYXJpbmFzIDxjYXRhbGluLm1hcmluYXNAYXJtLmNvbT4NCj4gQ2M6IEFuZHJldyBN
b3J0b24gPGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc+DQo+IENjOiBEYXZpZCBIaWxkZW5icmFu
ZCA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gLS0tDQo+ICBpbmNsdWRlL2xpbnV4L21tLmggfCAgNCAr
KysrDQo+ICBtbS91dGlsLmMgICAgICAgICAgfCAyNSArKysrKysrKysrKysrKysrKysrKysrKysr
DQo+ICAyIGZpbGVzIGNoYW5nZWQsIDI5IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL2xpbnV4L21tLmggYi9pbmNsdWRlL2xpbnV4L21tLmgNCj4gaW5kZXggNWJlM2Q4
YThmODA2Li4xZjI4YmU5NzVmODYgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUvbGludXgvbW0uaA0K
PiArKysgYi9pbmNsdWRlL2xpbnV4L21tLmgNCj4gQEAgLTM5MDgsNiArMzkwOCwxMCBAQCBleHRl
cm4gaW50IHZtX211bm1hcCh1bnNpZ25lZCBsb25nLCBzaXplX3QpOw0KPiAgZXh0ZXJuIHVuc2ln
bmVkIGxvbmcgX19tdXN0X2NoZWNrIHZtX21tYXAoc3RydWN0IGZpbGUgKiwgdW5zaWduZWQgbG9u
ZywNCj4gICAgICAgICAgdW5zaWduZWQgbG9uZywgdW5zaWduZWQgbG9uZywNCj4gICAgICAgICAg
dW5zaWduZWQgbG9uZywgdW5zaWduZWQgbG9uZyk7DQo+ICsjaWZkZWYgQ09ORklHX0FSQ0hfSEFT
X1VTRVJfU0hBRE9XX1NUQUNLDQoNCldoeSBkb2VzIGl0IG5lZWQgdG8gY29tcGlsZSBvdXQgdGhl
IGRlY2xhcmF0aW9uIGhlcmU/DQoNCj4gK2V4dGVybiB1bnNpZ25lZCBsb25nIF9fbXVzdF9jaGVj
ayB2bV9tbWFwX3NoYWRvd19zdGFjayh1bnNpZ25lZCBsb25nIGFkZHIsDQo+ICsJdW5zaWduZWQg
bG9uZyBsZW4sIHVuc2lnbmVkIGxvbmcgZmxhZ3MpOw0KPiArI2VuZGlmDQo+ICANCj4gIHN0cnVj
dCB2bV91bm1hcHBlZF9hcmVhX2luZm8gew0KPiAgI2RlZmluZSBWTV9VTk1BUFBFRF9BUkVBX1RP
UERPV04gMQ0KPiBkaWZmIC0tZ2l0IGEvbW0vdXRpbC5jIGIvbW0vdXRpbC5jDQo+IGluZGV4IGIw
NWFiNmY5N2UxMS4uMjU5MjI5MTk0OGYwIDEwMDY0NA0KPiAtLS0gYS9tbS91dGlsLmMNCj4gKysr
IGIvbW0vdXRpbC5jDQo+IEBAIC02MTgsNiArNjE4LDMxIEBAIHVuc2lnbmVkIGxvbmcgdm1fbW1h
cChzdHJ1Y3QgZmlsZSAqZmlsZSwgdW5zaWduZWQgbG9uZyBhZGRyLA0KPiAgfQ0KPiAgRVhQT1JU
X1NZTUJPTCh2bV9tbWFwKTsNCj4gIA0KPiArI2lmZGVmIENPTkZJR19BUkNIX0hBU19VU0VSX1NI
QURPV19TVEFDSw0KPiArLyoNCj4gKyAqIFBlcmZvcm0gYSB1c2VybGFuZCBtZW1vcnkgbWFwcGlu
ZyBmb3IgYSBzaGFkb3cgc3RhY2sgaW50byB0aGUgY3VycmVudA0KPiArICogcHJvY2VzcyBhZGRy
ZXNzIHNwYWNlLiBUaGlzIGlzIGludGVuZGVkIHRvIGJlIHVzZWQgYnkgYXJjaGl0ZWN0dXJlcyB0
aGF0DQo+ICsgKiBzdXBwb3J0IHVzZXIgc2hhZG93IHN0YWNrcy4NCj4gKyAqLw0KPiArdW5zaWdu
ZWQgbG9uZyB2bV9tbWFwX3NoYWRvd19zdGFjayh1bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVk
IGxvbmcgbGVuLA0KPiArCQkJCSAgIHVuc2lnbmVkIGxvbmcgZmxhZ3MpDQo+ICt7DQo+ICsJc3Ry
dWN0IG1tX3N0cnVjdCAqbW0gPSBjdXJyZW50LT5tbTsNCj4gKwl1bnNpZ25lZCBsb25nIHJldCwg
dW51c2VkOw0KPiArDQo+ICsJZmxhZ3MgfD0gTUFQX0FOT05ZTU9VUyB8IE1BUF9QUklWQVRFOw0K
PiArCWlmIChhZGRyKQ0KPiArCQlmbGFncyB8PSBNQVBfRklYRURfTk9SRVBMQUNFOw0KPiArDQo+
ICsJbW1hcF93cml0ZV9sb2NrKG1tKTsNCj4gKwlyZXQgPSBkb19tbWFwKE5VTEwsIGFkZHIsIGxl
biwgUFJPVF9SRUFEIHwgUFJPVF9XUklURSwgZmxhZ3MsDQo+ICsJCSAgICAgIFZNX1NIQURPV19T
VEFDSywgMCwgJnVudXNlZCwgTlVMTCk7DQo+ICsJbW1hcF93cml0ZV91bmxvY2sobW0pOw0KPiAr
DQo+ICsJcmV0dXJuIHJldDsNCj4gK30NCj4gKyNlbmRpZiAvKiBDT05GSUdfQVJDSF9IQVNfVVNF
Ul9TSEFET1dfU1RBQ0sgKi8NCj4gKw0KPiAgLyoqDQo+ICAgKiBfX3ZtYWxsb2NfYXJyYXkgLSBh
bGxvY2F0ZSBtZW1vcnkgZm9yIGEgdmlydHVhbGx5IGNvbnRpZ3VvdXMgYXJyYXkuDQo+ICAgKiBA
bjogbnVtYmVyIG9mIGVsZW1lbnRzLg0KDQo=

