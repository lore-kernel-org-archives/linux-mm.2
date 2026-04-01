Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8FDC1112240
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 23:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAC3E6B0088; Wed,  1 Apr 2026 19:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B60196B0089; Wed,  1 Apr 2026 19:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCC46B008A; Wed,  1 Apr 2026 19:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 881666B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 19:02:29 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1EA6557855
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:02:29 +0000 (UTC)
X-FDA: 84611512818.25.A583F55
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf18.hostedemail.com (Postfix) with ESMTP id A429F1C001B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 23:02:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cm18WejN;
	spf=pass (imf18.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775084545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g4Ue+D8vxzS5NAMrnCtbXTjzsF/CD1slnPrtX9HdHvg=;
	b=vR1khUf+cb/0XmM+9Cxmoae35A7X+r97sL30XSfpBC/ol1851hPh7AovsWcPAKXlpjgOQl
	CZ76dpxBG8Le74EHUIoNPrQEU6zC4tGQ7lfnwFmzKqDFGj/wvX+odpKfofOD3UV5mcC8iV
	EF70x+j/c4nBm6sDD1BKUunIq0AzVOQ=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Cm18WejN;
	spf=pass (imf18.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775084545; a=rsa-sha256;
	cv=fail;
	b=6gPz7ST/wedYDXpsB90nzP59BMSE1ouRMKM4cdw9KB47Q8A9ZICCE5MI+9h11OyZfTKDLU
	QygWzj/Tc+mhujxuBHDwqmO1iOwxbyYgKgLlq5ifkh7mOuRSIVsc3LwyQhQ7eSyGJ2Ul5i
	Wda7i0eFAgW3o3Gdr/soXovgis1QgLU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775084545; x=1806620545;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=fsBbzqnEl6gFV+3RfOuWjFM82jmsJj+r5gr9ogAizvI=;
  b=Cm18WejNCwDiiMOwvQ1QW6BxdJWsD5yKuF+pJxybYqb2yU+0xOrwAlsZ
   2ZqQEsCi8GGgs6m7LBwkEY8RvFdRdUcfAfOoNq9D1ijsUI3zYc6o7FFNn
   bvhWsL12ujivt1IBYrJvgvPZ3wYXPx5hSV2oZJeidOFchbM1cZ01N4iFz
   m6fb8h87bhEFyz2p3yl1npRkio+mhPBL2RFTXQEClvDuULOqGHIiGr0va
   phfui/Dj8+FCurFyx6ENPtdQTMgDR3oOs9aALTeO79u6qJVq+brdfG96j
   EymirsgQN2WTSQVTOmR24CdzU09rk2GsWJTG61PPBJGmhJeBBRQYdd173
   w==;
X-CSE-ConnectionGUID: mdcvLhIsTBGQhEXJ0RrhIA==
X-CSE-MsgGUID: HvMDrj12SEqvEgb5IRN/LA==
X-IronPort-AV: E=McAfee;i="6800,10657,11746"; a="75312056"
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="75312056"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 16:02:23 -0700
X-CSE-ConnectionGUID: kgSz1AvqQPucEfdhrj8dBw==
X-CSE-MsgGUID: NiQgB3yATF+EeMpZt9Onjw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,153,1770624000"; 
   d="scan'208";a="231220941"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa004.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2026 16:02:22 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 16:02:21 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 1 Apr 2026 16:02:21 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.16) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 1 Apr 2026 16:01:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q4rwFL3iJ2PeJlnVn9J5nVzsddUwWpszWCWyOHnZFMxHdafINTA9AISWrMnzC7V4p91tcAFtGAAqWIg3pPQ34VhwyOFg/rXSTnf0Xo79BFmO6bwukNKLmCnyKH4DdBO9Vt0/+dpt/Kp5BoyiJK1dkJrPvG4OEOAARyepzYoUcd1riZJLB1gVMEJVK+WxImeheZ9P65Edo05fscBq7fhSwMTSuMLXMRcPmrruxZjimLP2k5w2/8FGQQxOySxcIk8o2dmqPyQW/tIqjSHNb2JpXVFEWcEyOTtXKG2yJGibIQ62YSkFPsHFZ8YXhknlngTNOOmmpFmhek4N/veGVPcyJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g4Ue+D8vxzS5NAMrnCtbXTjzsF/CD1slnPrtX9HdHvg=;
 b=lp0EEwBw8s9lQxvRspuMlXTCS5tm7cesPiOKcd7HpqQ9cz1tPYn6rrBC3/pK8/MKYGE61nE9pNxPMP605RzDyufabAfwDewTdk8jRjMoBvJ2j2pVmm6MdDaMsdn7f9WCTVvuFznQhXs7w+5wU0GrlT4gjHD8GjCYz7Siqp6MlA6BrbnUdeSA8nn67+q7Zb4mpmapYp3UbY0G7NZ5mSSvX2RUGWKjpD6z0OqgBv6e/eDqd2yy3aKAklG7fTAAxQwp+XASTFlmA+7/yskmvQB6bsSNK/yDRM+DDRA4WVtuP7m3H2RGJ3K62s3QlV1pCB/M9J6dlHEZE3VXTue/5Jm5Cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by DS0PR11MB7904.namprd11.prod.outlook.com (2603:10b6:8:f8::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9769.17; Wed, 1 Apr 2026 23:01:56 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5%7]) with mapi id 15.20.9769.016; Wed, 1 Apr 2026
 23:01:56 +0000
Date: Wed, 1 Apr 2026 16:01:52 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Alistair Popple <apopple@nvidia.com>
CC: <linux-mm@kvack.org>, <zenghui.yu@linux.dev>, <Liam.Howlett@oracle.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>, <jgg@ziepe.ca>,
	<leon@kernel.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
	<mhocko@suse.com>, <rppt@kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <dri-devel@lists.freedesktop.org>, <balbirs@nvidia.com>
Subject: Re: [PATCH 2/3] selftests/mm: hmm-tests: don't hardcode THP size to
 2MB
Message-ID: <ac2j4BLA/jY01rgl@gsse-cloud1.jf.intel.com>
References: <20260331063445.3551404-1-apopple@nvidia.com>
 <20260331063445.3551404-3-apopple@nvidia.com>
 <acyq8B7/Uwowj+kl@gsse-cloud1.jf.intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <acyq8B7/Uwowj+kl@gsse-cloud1.jf.intel.com>
X-ClientProxiedBy: MW4PR03CA0244.namprd03.prod.outlook.com
 (2603:10b6:303:b4::9) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|DS0PR11MB7904:EE_
X-MS-Office365-Filtering-Correlation-Id: c2bf37a9-31b5-45dd-8d6d-08de9042abe5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|13003099007|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: YuhbtK7g1rJTXyUPuFge77IuBkfkPZv6XF+1wOZlF9FAtQcscHYt7dZHBvCBE5t6k+2M1LpODQitG9l+IQW6s28zQm86mSi7qBbGaTBwkbImNf9EdnUmUuJZBvWMygi0oHxWW3J9J/+dCdXyTaMMz8csGpKjyhBqOHR3IEJA7c2bvvfzEkDpcD2TLRkQSwb+17XhsgY09cSq8W7N0eLOcRfCt8jcc05Da0YSevc33HS14Fa/z15GWOxc0YOSPPfzecjlo3QA9kt2kyn5/qUlBkKdU2x5xoPwknp3E1KaC0Y7o2G35Iozrf6cVgga2giRUU6J8jg6zmrAwyusGORVHO0ckWBfu2XcvIOjhzzREz3SSFRzLGJ5pbhdOCOjfobtG9G4rYsNCyjgLaWB2iFVnrHgSbFmkd1d0HxZHhDVwUmgymCILiavOuSs/AdaojMOR1hqmd8p2tR0opWJGmO/v1wHaMd3z7Mr40egTfY2p2uuQ2BXC85898mAOqmEsJ+6yGW5UPhc+LmU+eyGo4u5eqvc1EdGh1lha1RldYzw/5kUstesgWztOLqE0FdFyLf5eRikv3643GNxTsjhIkJ/PBNZtXbVP8A4oIRMQDow8LaijzQqwXR8kAR43iUmcoC6EVUFWDPz9xay4EcpUG2R1vo5bMeRngjaUOLuQgwAOvm6U0LYpIw2oWiXkNOmpzcZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(13003099007)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUxtVUczWGpKUG1LVlprSXF4aHdqRU1sblVqWDloR3lkSzU4TGdzWWxDckcy?=
 =?utf-8?B?ai93clJBcE9EcUZFd0JGaFpsMENBaGM1cERQS1BVVnJjS29sSk1HTHgxcjB4?=
 =?utf-8?B?citWeVJTc09FRHF5SXVFT2VuZy8wNWQvVDNVUzZYZ3lFZmVNY25mcWZQdzE0?=
 =?utf-8?B?TGllZkRYWHVPVkdlZmFVdmZ6bzN3dlhNNy85ZmNQcldGaVFhMkNhL1pXTlEw?=
 =?utf-8?B?YzFhMkJ0NEFXTHdRM3VRbXNqSUp1YVNSYXBHQnZaTnlyMU9jYytCWEdsdGdv?=
 =?utf-8?B?NitQMDF0NVlZc1NLc1VNMk1FamRSQTEvRU9wcVlWMHhPaUk3eWlQbXZYYlgr?=
 =?utf-8?B?dndvaTlpMzU5Zy8vOFpQbisvRVVKbUdIYWZ2TFAvaTdqeHRQRHlVaURyR2lX?=
 =?utf-8?B?MjloSVVaZEk3L0tYQk1RNlJzMUs4N2tGT2hyckI5T0RXdzRuUUpYTDZCb253?=
 =?utf-8?B?VGdDSC9LUXdiakVjR3Y5Q2d5OEs3YklFRFExem1zNHQ2Z2JJajBJUTlubGFW?=
 =?utf-8?B?ZkhlZ2RwbjhZdDk0T2t2bXFmZ2Y0M0FrL3d0SE5OT3VudFFMNWRpQWNrczAx?=
 =?utf-8?B?dDlXTTREWEVBMjRKdnVUNkJuNVJtbElFVDIrVG12QkFUTFBkNDc1QVN6RytN?=
 =?utf-8?B?WHQ2SkZyaHgrV1NyMFJ5WjArY2duZitxaFZOZHdDY2xNMDkvVlZpc0ZVM1Rk?=
 =?utf-8?B?QS9rRndqb2dKaml2aXBpS2U5ei9CYW11OEJCMERFUU1WRWY5bjhIRTA0T216?=
 =?utf-8?B?UVFLTzAvcm1xRks5di9SRFlSSHZvQmM0Q1NxQ0hGUi9NYlgyMmpmM3hBRVlM?=
 =?utf-8?B?dVJ5aHhHb0lrWTFzVUVzVHhjUk5IRVBMdVJiVER0a1RGOUJhd1ROTWgxMkZT?=
 =?utf-8?B?Q0RkcWsyRm43KzJzVnp0MkpxN1BLRk5PdDlkL2pWTVZ5WFJ4dVFMUVlJUlZE?=
 =?utf-8?B?OC9kWXliUkRBQzZuUjZYVmJsWU5xYlhCUmJ5ZUpkdkRPTnpvVWY1MjFyalEy?=
 =?utf-8?B?RHBBSUJ4YVAyL1RZMHlHQUpsS1Bod0wxNnQxdFdpR1VaSVhxN0tnWlZuK1Z3?=
 =?utf-8?B?cDlncThsMmI3SlpHQmxGRDNHaXA4S2NaNXVKUkloQmZaSHlwNUhxRWlnRytu?=
 =?utf-8?B?ZndWNHE5Zkpwb1VVRWpqenFLQlFjdmtYWjZTNVRtcDJIckJEQ1Z0U0tmakcz?=
 =?utf-8?B?aFRkOHdLaXh0V1ZJVVlZRWdra251V3RQa0g1RmtBcm0rS3FNTlh1UWtXUlpG?=
 =?utf-8?B?RkFIdlZnZ1ZaUHM2Nyt5VS9LSUdQWlMxTVNscHVMbTFlcTc1ekIzc1RzVDZI?=
 =?utf-8?B?Rks3WWYyMEJ0b2NUNnBsV0tRWFN2alVzZUM0ayt4RG51Ymx3TEtYbGpLTE5Q?=
 =?utf-8?B?VG5lc3d2WkpRWDdZRVduNTBjdDgzRmJwbHZuZHlJRE5UNGVDVWtVNTdFVXpa?=
 =?utf-8?B?NDRENGEza2lKKzZJT3JYWlY2RmtMT2loWDY2RlNFSU9vbTRvQ1BXYk5GanJX?=
 =?utf-8?B?RnJTWVdGbTVNL002c1liTTVCVzlwdXdFK1lZU1JUOWtwZ2VhRy9tZnlXZWt5?=
 =?utf-8?B?dytiVlArTERaSXBQV1ZVSTJEOHp5OTBaSitta0lpSDJSa3k0cHBEVGs3aGJn?=
 =?utf-8?B?eEdjWExxbW56RXpFV2duclZXdmJ1cDBEeHNCejZPYTZIa0t3SUlYalJzelNo?=
 =?utf-8?B?bGFlOWh4d2VlajdpNzEzbzM2VWUrYTlJNTZmUzgxRU1xZldvaEFac2tkVFVQ?=
 =?utf-8?B?OXplcG1mMXJjdXV6QXlKczlFVk9kak1Ea2RCY1JHQkpENUNrNFUrbUVUR2RS?=
 =?utf-8?B?RGpEWkU3aC9vMlJnSlNIZzFDREFvUWF1c013Qzc2YkMrRXp6NEpUcFhDcVVN?=
 =?utf-8?B?SWFseVRadk8xWWFLU3Y1bG52bkNVR0RpM0FhKzhKU012K2RjTk00VnpMLy94?=
 =?utf-8?B?MWRkTHNJMTcvWnd1aUNORHZFUTR5dDlVdUszQzRoNGYxUGpaMlpFckZMMlpG?=
 =?utf-8?B?d3JtZnBMYy91L0pPYUNrOTFUcWl1K2grd2pWUkJHdUl1WWw2SHFkUGdpbFUv?=
 =?utf-8?B?YlN5aDhOblBzSVBBaGg4MWFjMzhxRVBiTGxUWC9xTE9HeTA3NDI4OFVpUkM4?=
 =?utf-8?B?cFhsazNULzliODRHcXIrMng3S3pXaEU3Y3o0NEorYm1QR244dFFHTXc5Z0hv?=
 =?utf-8?B?aW9rdFNKakhYblRTd3J1QjFFMkJKRzVyYzl5SEdnQTY5R0lNbjg2NlBpU2FG?=
 =?utf-8?B?TGpPTUVxVlVnb0RtVXo2NUdXOFRlNlMvRnpzREpxaVpodFEza0h6UE02dzN4?=
 =?utf-8?B?Nm1EOHUyVmVtM05yeXNPQWR3U1NjWVQ0U1VnbmoweTcrYWpMQ1J0eW91Ui8y?=
 =?utf-8?Q?tgKyyL4esO8TFjUM=3D?=
X-Exchange-RoutingPolicyChecked: LT/Rdxqw4kU/vEHp4jQ20vkzSSu95Hw42LTDtf/6CEn1UWnkjwiQakvgo4Q3lViNMPOIgnJEBI9FQ0yqVY9/aN11Yx2uIQBtIivnvT5OAZ9d33obxxQea1BNr3p9R1os4mWn8LSHYJpwyQ+MyBXWp6IPJaZNc4KdfTWtlpKUeHleFyIfkxKxVaGvpwKcjtFXRZCGl885kzU+67Tpcax55VnvZ/82SVurrmsokMiWV78wbpmFIo0JE3n2cWBb8vA+e43SKG5z4O2b0GL8x6uO9/r9WxFIQkFK3TuEFVGmqsKWDstbgd1hDAcD1VXd4tNAEdhSahQefQi8XsO4JKWf4g==
X-MS-Exchange-CrossTenant-Network-Message-Id: c2bf37a9-31b5-45dd-8d6d-08de9042abe5
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2026 23:01:56.1042
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bNgzqDrM+70YBLPv7GMKQWHC7gfF0CJN95cGsnRZHoQzfEvu7dy3GKB+kL9gt9infFQNv0c6AYY6x7Bo2KiWCw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7904
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A429F1C001B
X-Stat-Signature: mhnz51857syigs5i9rrrkiirm1x3z5hy
X-Rspam-User: 
X-HE-Tag: 1775084544-414608
X-HE-Meta: U2FsdGVkX19NaZf8tRXZpQhUyBmv/FJI1m66bw8lX0tk9bSRex5152ilmsGM7qdSxvUH3gip28vri4FNGPt5OQSwp9W1F7AkYfpRrsw3W2gW2OfRHMBClnSTkmNx39ZrviqFZMgrcEPf9/XKdV446fimd2lBTZnEEYhWlmSELaGRbcRt8l85ckQQ1wkD7Y0FqEGGPkCJ3u6hYVl84wNg2NrYDYYiQXqiFByAjgpajCZTeGe+F1dOmtKeo3YPp9VnZULkyFkJjMAFrnJSXWFt4XFLUNM11StVox4WY1yL81IbQFAbW8vrHadMnd09DBSQKxOcdxrGF8T7a913gckijQU1EJi05QnH8kE2p7RNjUg9mpoiiOaWJDhDzzcxDik6gxqSN7g14T4cH2P27btKb0Vz5nn9ZvZp2G2OXixTnI98K/Npcp8tHgDDGhxUPbnWkoYaxfC/z4OzUAr/GKDEnMF8lboJCQGju9GjyJp0LRy+fdSHuZLmmtp0o6az0xMAeJggJsxa9UFwrsqAX0UAUDdtglhXKvSlA8iebtPMmtU0SW6Fp+zk92Tsk1MRuySkzVrsOmMteKSwTXGSZyKB2SmM+UCS88BKf4ISbIsU7ozNpn3sphRA9CSX+8U8xBIGBsatqhdEG2dRmjTlxCfwvD4DiUq4erjiq0b9OY09srtmUu1pjo82sWGAiLYwnBZNm4y258AHtGL/C6mBITsATpfg3WgU8AGw+4yNSlyCv+EIxrtnhowM2LudRIm/SwjYF4u6TEQ/9TMVfhjYz3mNwhnD6/gQKDRpnCRFlke5DzCrkkF1Z184sYqTU0o7KUcuOoJzrDROcLofTmI1H3BHxM5yi0wmVHkBoieyQKcBqv9P672+6jHInR2UzaMNI3B/fG4C+grwH5FYT9/dEZLRhrkGLgJhfsrSXger9Dfx2zs/N+Plw6SHTyAksSkbR8tLp9aFDeR7VEoFQHI1qb6
 b4gJ86Pu
 JzDlBtmi9UtcIevoOydNrH/0leJ6g0Sj6pw70j1zb+mPwewvpMysWPibZisUlfahoTl80WJJKHD8sM6TzvCSfjTt+PzH2TdaO1HfymwtQxK8HivGkmsb5uZG6SRdObUygrOoX93QKon1Z0JmVhA2DPnAwYES5ecvq+CbNULYcsozhY6HoJIdItdl964qNUQvZxEmnx5R6pMUFjj9rPfiHxuhSJUyjhPnSKjNM7reIibWOdd7envRwbzH46i2YcMY3aeNQ2bH4K2qDpGWLXV5JJMtR05JjByI19I9pRh3GUGTXFRh7rXwzB+jvxQcRMED7LVUNol5lCWL6GFkj6llddPtfuCCQcrD0IWGZxj0G8P1OaC3+/JfTNmC9VkKIBS7rA0p1wbM/JieDKbb/mNOKPWCchYfD+WWw2sxZkiRUxZ0xrczNoV1jBCkGyKXJCT98iupjzd5MikAvQk76ac3Xydq2CWh8RQwBgN6tG4g0gWPSECHhOTXQXD8BuSqhNNjzlk6MSoGQF6RgJT4ytvHvqOzIScIzvyLZQaF64MxUdJCtCor+jEeNKTNo/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 10:19:44PM -0700, Matthew Brost wrote:
> On Tue, Mar 31, 2026 at 05:34:44PM +1100, Alistair Popple wrote:
> > Several HMM tests hardcode TWOMEG as the THP size. This is wrong on
> > architectures where the PMD size is not 2MB such as arm64 with 64K base
> 
> +1
> 
> But one question…
> 
> Can’t the THP size be derived via HPAGE_PMD_ORDER?
> 
> If not, then some DRM common code I’ve written will break on arm64.
> 

Ignore this I seemly forgot we are in userspace here.

Matt

> Matt
> 
> > pages where THP is 512MB. Fix this by using read_pmd_pagesize() from
> > vm_util instead.
> > 
> > While here also replace the custom file_read_ulong() helper used to
> > parse the default hugetlbfs page size from /proc/meminfo with the
> > existing default_huge_page_size() from vm_util.
> > 
> > [1] https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> > 
> > Fixes: fee9f6d1b8df ("mm/hmm/test: add selftests for HMM")
> > Fixes: 519071529d2a ("selftests/mm/hmm-tests: new tests for zone device THP migration")
> > Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> > Closes: https://lore.kernel.org/linux-mm/8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev/
> > Signed-off-by: Alistair Popple <apopple@nvidia.com>
> > ---
> >  tools/testing/selftests/mm/hmm-tests.c | 83 +++++---------------------
> >  1 file changed, 16 insertions(+), 67 deletions(-)
> > 
> > diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> > index e8328c89d855..788689497e92 100644
> > --- a/tools/testing/selftests/mm/hmm-tests.c
> > +++ b/tools/testing/selftests/mm/hmm-tests.c
> > @@ -34,6 +34,7 @@
> >   */
> >  #include <lib/test_hmm_uapi.h>
> >  #include <mm/gup_test.h>
> > +#include <mm/vm_util.h>
> >  
> >  struct hmm_buffer {
> >  	void		*ptr;
> > @@ -548,7 +549,7 @@ TEST_F(hmm, anon_write_child)
> >  
> >  	for (migrate = 0; migrate < 2; ++migrate) {
> >  		for (use_thp = 0; use_thp < 2; ++use_thp) {
> > -			npages = ALIGN(use_thp ? TWOMEG : HMM_BUFFER_SIZE,
> > +			npages = ALIGN(use_thp ? read_pmd_pagesize() : HMM_BUFFER_SIZE,
> >  				       self->page_size) >> self->page_shift;
> >  			ASSERT_NE(npages, 0);
> >  			size = npages << self->page_shift;
> > @@ -728,7 +729,7 @@ TEST_F(hmm, anon_write_huge)
> >  	int *ptr;
> >  	int ret;
> >  
> > -	size = 2 * TWOMEG;
> > +	size = 2 * read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > @@ -744,7 +745,7 @@ TEST_F(hmm, anon_write_huge)
> >  			   buffer->fd, 0);
> >  	ASSERT_NE(buffer->ptr, MAP_FAILED);
> >  
> > -	size = TWOMEG;
> > +	size /= 2;
> >  	npages = size >> self->page_shift;
> >  	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
> >  	ret = madvise(map, size, MADV_HUGEPAGE);
> > @@ -770,54 +771,6 @@ TEST_F(hmm, anon_write_huge)
> >  	hmm_buffer_free(buffer);
> >  }
> >  
> > -/*
> > - * Read numeric data from raw and tagged kernel status files.  Used to read
> > - * /proc and /sys data (without a tag) and from /proc/meminfo (with a tag).
> > - */
> > -static long file_read_ulong(char *file, const char *tag)
> > -{
> > -	int fd;
> > -	char buf[2048];
> > -	int len;
> > -	char *p, *q;
> > -	long val;
> > -
> > -	fd = open(file, O_RDONLY);
> > -	if (fd < 0) {
> > -		/* Error opening the file */
> > -		return -1;
> > -	}
> > -
> > -	len = read(fd, buf, sizeof(buf));
> > -	close(fd);
> > -	if (len < 0) {
> > -		/* Error in reading the file */
> > -		return -1;
> > -	}
> > -	if (len == sizeof(buf)) {
> > -		/* Error file is too large */
> > -		return -1;
> > -	}
> > -	buf[len] = '\0';
> > -
> > -	/* Search for a tag if provided */
> > -	if (tag) {
> > -		p = strstr(buf, tag);
> > -		if (!p)
> > -			return -1; /* looks like the line we want isn't there */
> > -		p += strlen(tag);
> > -	} else
> > -		p = buf;
> > -
> > -	val = strtol(p, &q, 0);
> > -	if (*q != ' ') {
> > -		/* Error parsing the file */
> > -		return -1;
> > -	}
> > -
> > -	return val;
> > -}
> > -
> >  /*
> >   * Write huge TLBFS page.
> >   */
> > @@ -826,15 +779,13 @@ TEST_F(hmm, anon_write_hugetlbfs)
> >  	struct hmm_buffer *buffer;
> >  	unsigned long npages;
> >  	unsigned long size;
> > -	unsigned long default_hsize;
> > +	unsigned long default_hsize = default_huge_page_size();
> >  	unsigned long i;
> >  	int *ptr;
> >  	int ret;
> >  
> > -	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
> > -	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
> > +	if (!default_hsize)
> >  		SKIP(return, "Huge page size could not be determined");
> > -	default_hsize = default_hsize*1024; /* KB to B */
> >  
> >  	size = ALIGN(TWOMEG, default_hsize);
> >  	npages = size >> self->page_shift;
> > @@ -1606,7 +1557,7 @@ TEST_F(hmm, compound)
> >  	struct hmm_buffer *buffer;
> >  	unsigned long npages;
> >  	unsigned long size;
> > -	unsigned long default_hsize;
> > +	unsigned long default_hsize = default_huge_page_size();
> >  	int *ptr;
> >  	unsigned char *m;
> >  	int ret;
> > @@ -1614,10 +1565,8 @@ TEST_F(hmm, compound)
> >  
> >  	/* Skip test if we can't allocate a hugetlbfs page. */
> >  
> > -	default_hsize = file_read_ulong("/proc/meminfo", "Hugepagesize:");
> > -	if (default_hsize < 0 || default_hsize*1024 < default_hsize)
> > +	if (!default_hsize)
> >  		SKIP(return, "Huge page size could not be determined");
> > -	default_hsize = default_hsize*1024; /* KB to B */
> >  
> >  	size = ALIGN(TWOMEG, default_hsize);
> >  	npages = size >> self->page_shift;
> > @@ -2106,7 +2055,7 @@ TEST_F(hmm, migrate_anon_huge_empty)
> >  	int *ptr;
> >  	int ret;
> >  
> > -	size = TWOMEG;
> > +	size = read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > @@ -2158,7 +2107,7 @@ TEST_F(hmm, migrate_anon_huge_zero)
> >  	int ret;
> >  	int val;
> >  
> > -	size = TWOMEG;
> > +	size = read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > @@ -2221,7 +2170,7 @@ TEST_F(hmm, migrate_anon_huge_free)
> >  	int *ptr;
> >  	int ret;
> >  
> > -	size = TWOMEG;
> > +	size = read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > @@ -2280,7 +2229,7 @@ TEST_F(hmm, migrate_anon_huge_fault)
> >  	int *ptr;
> >  	int ret;
> >  
> > -	size = TWOMEG;
> > +	size = read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > @@ -2332,7 +2281,7 @@ TEST_F(hmm, migrate_partial_unmap_fault)
> >  {
> >  	struct hmm_buffer *buffer;
> >  	unsigned long npages;
> > -	unsigned long size = TWOMEG;
> > +	unsigned long size = read_pmd_pagesize();
> >  	unsigned long i;
> >  	void *old_ptr;
> >  	void *map;
> > @@ -2398,7 +2347,7 @@ TEST_F(hmm, migrate_remap_fault)
> >  {
> >  	struct hmm_buffer *buffer;
> >  	unsigned long npages;
> > -	unsigned long size = TWOMEG;
> > +	unsigned long size = read_pmd_pagesize();
> >  	unsigned long i;
> >  	void *old_ptr, *new_ptr = NULL;
> >  	void *map;
> > @@ -2498,7 +2447,7 @@ TEST_F(hmm, migrate_anon_huge_err)
> >  	int *ptr;
> >  	int ret;
> >  
> > -	size = TWOMEG;
> > +	size = read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > @@ -2593,7 +2542,7 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
> >  	int *ptr;
> >  	int ret;
> >  
> > -	size = TWOMEG;
> > +	size = read_pmd_pagesize();
> >  
> >  	buffer = malloc(sizeof(*buffer));
> >  	ASSERT_NE(buffer, NULL);
> > -- 
> > 2.53.0
> > 

