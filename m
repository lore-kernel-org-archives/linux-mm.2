Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33179D3CCA5
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 02:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 950696B0088; Wed, 14 Jan 2026 21:54:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F74D6B0089; Wed, 14 Jan 2026 21:54:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AE716B008A; Wed, 14 Jan 2026 21:54:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6892A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 21:54:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F3C341AB0E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:54:10 +0000 (UTC)
X-FDA: 84332679060.07.3845AA9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3EAB140005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:54:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EvQhcosX;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768445647; a=rsa-sha256;
	cv=fail;
	b=8GNfXWD7upcF0ZSTG1Tf4tUFmlopZXBAFCT1vM3AQagJqV2QTcelepaxxZCy02qWljOWqj
	2MRcY+d3mGBgFXHXOmsIv4uH+845g118vDTTjOBApttGynvVCjB7cXXrPijsLSziQfTkwQ
	+47cnb65obm3Zxb2bUxfTGXkY09nOXM=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EvQhcosX;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=matthew.brost@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768445647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xnYeziFkqHXt/ny8+WNhs9wH2bOXgGB54lv87lWZ+no=;
	b=5u0OUy4GBAhdIxh79/IFUgHF21Ox4jSNjeC3D8jdln17qMGAhp27WciGukEtq8dpKgpfkI
	GPcNkw/8eZNYwXjIBOO/XrijFFceBMcTxSBEFLi88VeBZxltoMuBLKbSd7E7VeP+CfobOm
	5vSd1WA467AFwcYDBPZRq66UXUZNfp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768445647; x=1799981647;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=5rggWCnHGfJKdXZf3vw1bR2fOdp+SBqcLaNW/okztaQ=;
  b=EvQhcosXBAh/Q7S93lG3uQau17xiUL8NbGDl0sxjMy9qIE8tPoQMcD0A
   mKTLeZAwCIHrV2FFBAmSTRveqmfBVWxaKE9oMm2qFIJt3VTqhJ+dyiuXz
   a2ID4ujw6Yq5sKJknhqgStcKFP5dWtJVWfG0yMAU+QMFcvIbGI13pY+cB
   4pFvAzWlpVu/1DfbxaNT4DKQUPh9cIh1HfJqHe/aXgNikBB/Vz6SzhbqI
   RCmLiaD6kV+cLBBxbgm44zoj/kigYJPdPEb1nvgYZLJ7KK3xK2RDcbw49
   N/T4v5V1B2HMW6Y+PkiqsZOk2SI1kw20jYFaAQDC/zEGP7sNgQL3TIey1
   A==;
X-CSE-ConnectionGUID: q2aCPHUaSSGerKvEOV5PsQ==
X-CSE-MsgGUID: Q9NloLxHS02J1lOurZKFZA==
X-IronPort-AV: E=McAfee;i="6800,10657,11671"; a="80399235"
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="80399235"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 18:54:06 -0800
X-CSE-ConnectionGUID: OsZpYjzsTdmH968f+umyNA==
X-CSE-MsgGUID: Eyo9CeUzTBOfr+ohelWPxw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,226,1763452800"; 
   d="scan'208";a="204461161"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 18:54:06 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 18:54:05 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 14 Jan 2026 18:54:05 -0800
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.20) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Jan 2026 18:54:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Sn91flmAnf005kPf+8QsSbByMmjIK/OLQMaRQ8LoWoNxrbxW/C1ts1pSbwAZG655ZvmE3LQ8Rs+k2g6kKyxaWBtr4g5eSqfgJUpXqN1tHUFINf3nl0LrUKGf1PU2jLnmtvne+wQsZ+iJWOWdKxTaBqCyqizuQz7HIzAsTAl4Kd/9Z8Utq4j9Cqzo9L8gO7xHV3bJfi3A2LBBnrtLiQauYtcq79runn8+fUHTJnOUq74wP96khUTwJY1TOrWtekTdNBrVW6TFAt4bB8Ts0Hu0qXRKfWcRXJ7vrlq9eCOnkaxBksxdsaYtaHnBBmnNtdk0GNt8YWUbZmNcn7t0Lgl40g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xnYeziFkqHXt/ny8+WNhs9wH2bOXgGB54lv87lWZ+no=;
 b=q2W2drbCUbqLusN3MY1pgCwQ+Anduvdp8BY/NdIIfDXJoE0VrDHHy3Z/xTr0laWQiez/Kb8r/aGfCn3Ek4melKwgcgjSlp58h4OIVZkS4Lni5fufkC7Tj9lv/NiFaDGUz3un8XckBGgCscmHJhkiFY9PorDRuuUT6X1/fTNXZF6yRM1lScScZM+izl2PLD/ghO8Ns9nNd8tRtkB40TVuZwnN8ow9EwoCVUrY6wQ5roieUf32w5XOm0B34XfUP22rpX15MoGNh3Gk0DHPtbMNxE6AV4cikNRsYs4x47wXQTShNvZbjOiUj+jixLqvfHgZ4KGAgdqWEFxEgL1F3ZKFXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by IA1PR11MB7941.namprd11.prod.outlook.com (2603:10b6:208:3ff::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.4; Thu, 15 Jan
 2026 02:54:02 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::9e94:e21f:e11a:332%7]) with mapi id 15.20.9456.015; Thu, 15 Jan 2026
 02:54:02 +0000
Date: Wed, 14 Jan 2026 18:54:00 -0800
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: Francois Dugast <francois.dugast@intel.com>,
	<intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
	<Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
	<rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
	<mhocko@suse.com>, Zi Yan <ziy@nvidia.com>, Alistair Popple
	<apopple@nvidia.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v5 2/5] drm/pagemap: Unlock and put folios when possible
Message-ID: <aWhWyEUlp13PycO0@lstrano-desk.jf.intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
 <20260114192111.1267147-3-francois.dugast@intel.com>
 <ce644d03-2257-4bfc-ae3e-3d6e578c3cad@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ce644d03-2257-4bfc-ae3e-3d6e578c3cad@nvidia.com>
X-ClientProxiedBy: SJ0PR03CA0181.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::6) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|IA1PR11MB7941:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cb1c9f3-bdf4-474b-887e-08de53e156ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?vFVDoI7Vjc+XIv95tQv3RLeIptR8GnOhc5PY5lBAjtAOASkE3cHknJuz96P+?=
 =?us-ascii?Q?JQ+kWo3Fiz9xW2uqYxg/+1hw5skMc87+6WuwIJi0CuubFgxGVDC1H190tGv5?=
 =?us-ascii?Q?i63k4cDe794I3gQvSX+z68g+9R0VrF0+uXFLVh5S8cSgMdEcAkIqojhJORNV?=
 =?us-ascii?Q?ZM47+o0zfeSFLR3s8lfGEBqR+RFM7qhiHwtRNiC2K7vel8j1yl4UXCyVVWlt?=
 =?us-ascii?Q?7lzt57pOJKbCRVWNl5OLEN1ZostthedRj+iV+bEOIZKC9UE4ubosP+1D9z6p?=
 =?us-ascii?Q?led99Z7D/Gb1iZ99J3HyMkc+kpP4yBRzfuE/lGUkI9X/SB9TlI528QKff11U?=
 =?us-ascii?Q?AghQP0VDGQ4BQRouOLGxxQc3O0OzlJj8B3sa1qrLkNX7/SM1ypXIZgandG1F?=
 =?us-ascii?Q?BWa9I/xrDbZbAseOdubChXpEpMdjaia1nrXiSRdoC8zOGI3IKbVVQ+ZlVBdD?=
 =?us-ascii?Q?4YQEgtv2I6VQt6FR8PSEzUV6mHTz4akeW6d9juWjwdKZJFBiHuYzxLieyHAe?=
 =?us-ascii?Q?zhIVq2AFSLn4/k6MEU4sYwWFtSPxpbLfcllnlJr0o1EzxSIeWvT6IJyJXlbL?=
 =?us-ascii?Q?3NaRwKYVDKPbV1TRGKwhqX4+hBXuhiv+D/tosXVLL3Clww38ITSO1MVDdL1o?=
 =?us-ascii?Q?hGmQeuHO4gdEnxLhtzzzxJwmYh276IH63OAdXlWFlBmXaVdq25s7uDOpHKJI?=
 =?us-ascii?Q?a5EdDQl2ygRXn8JvezCrMQjvy0KdJ94ROPI2Jv4ud843QKtEWkHrGOykMqN8?=
 =?us-ascii?Q?oixLnz/SKYZPa6pvQ9AKvqMmIVnHXOUPF3MLL7HfJPVS90wzKGDdqhbaRAIv?=
 =?us-ascii?Q?w/CtTKD8FssNT0Uf6JRvQ+0htFnTafbEuUfGS4kD58528wZePl9Yn18ljDip?=
 =?us-ascii?Q?6GQeQcdm86OgrWtRYgNY0b96NWpmTW3hRgo+7XWLjVZt1kWGplK4thukrYNZ?=
 =?us-ascii?Q?BWVSGIxzlkNG7A0mOwKQNHRVcl36nS1yheMiuyIzixsGONyyDaBkTQrTiJUC?=
 =?us-ascii?Q?VNyhKGoEO15TNCotgw3t7F34T+a1PeT0Fx/oc3OORdZUj7PL99wImok+qmYG?=
 =?us-ascii?Q?ETOV3AdTUshd661NbPcLjr9QI6Mz8ViHl9LvB5kXfZOhT5V4W1StbmNx90lM?=
 =?us-ascii?Q?5q5KrtxcpOvGGouv+XF4SLIl9y//AJ1esqYQobTEe7CGXTZLDHfPSktQieru?=
 =?us-ascii?Q?Lvmd1TRJ5KhSc+7kAD/nxSrGly4rhGN1s9CK9aVyY5p0PsBngLTgxEvebwKC?=
 =?us-ascii?Q?Sa6+TMSojbqJ06niyqRziVIQJAycgay7jjnQlVJfyD1ptLKQVBgBBxQNGn0N?=
 =?us-ascii?Q?LlsKe/gg+k1Jo+P/lDgdzo/lfXg5tUhZKP5tdsG5lXXAKIQ/mtno1NKDn2jP?=
 =?us-ascii?Q?TGHwJhZEEMAZWbLBkObpjdSzUmzwfqBDxZUUOfAexvni1XB9i6MSU0P1cOe4?=
 =?us-ascii?Q?OdjWI++NVoJ5gKOBbh0r1g8AlRZeNEJYU3kPsxSABZ7PqK5uidzcjORwlJJj?=
 =?us-ascii?Q?wAqogGxb/qGpsR0EhWztLuM06WTGGDc7rFLOoTGFkp2Zy7I0PZ8kvqn38Ww5?=
 =?us-ascii?Q?zr65fPzXdencgfqoQfU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pRDCWOdCDXdEoCMS4hs68pvezsBHSJBj/Zqucnkrh1JTW3xFKcONCDPtJ2Tc?=
 =?us-ascii?Q?hDq8t/W1wMG09S20Past3lOVX+69Eu0ijIsYiWLDGB/DEXfazZAXP4uSfeU+?=
 =?us-ascii?Q?bPDDswyTO7uerNE1r/aw+ifmzL4cbicsCxqwVIi8OKjkVQmRT6rxuS72o80x?=
 =?us-ascii?Q?T9ekvlmZ2tE6YpZTpuzZSMvZB4FpnKX0jN/FZWIKTmxWVc4j6S9b8B4nBF+B?=
 =?us-ascii?Q?tn8VtLi8K7MuxkP9Vrnl3PfWmA4v3T8WYsjKFLYYQLocsD7CEo9a0fQspOhS?=
 =?us-ascii?Q?m90c4qVcJ1VnvSknMaiOGTNA4kPRSpo7bdoPgOGn18F58q6KWXOf45pdOb2B?=
 =?us-ascii?Q?e1AQb5iIJU/qmNCqrLTI9pl0koXkeV6VlBL4dgQCSPWuYsSvolOe8djSOX9m?=
 =?us-ascii?Q?yf5Wz+APRD6u7SWDwqlt9K0J/HuyQRlIGzufaavcY/K4KHryOFc1adsm71o8?=
 =?us-ascii?Q?rTHtsmSdAKl43fxex6k591G6yta5/w272jKDkozq1kWho3tODhcZh3mLGZBJ?=
 =?us-ascii?Q?bXDleSmcwix+WutvZFEO8CQZY0xVXrF4t6OZhZ9luf3P8Vks2jzv/jj4PsoC?=
 =?us-ascii?Q?yPUb/G/OtNO5JMvjEplToDrPScQJucY8DxK/ughIRMCQ2mpwIUaDOSFvxvur?=
 =?us-ascii?Q?pgR+UkhktscTREEpnhDnRQfu+eeC9ISFAeEkG+H5RnRxfizR7oO9fc8LFLUG?=
 =?us-ascii?Q?rO9y9wlrNyzfNYFo5HHHeQBPn2/ZeDDaMlPV8+EtHDhprSFcI5YyM7/fahV4?=
 =?us-ascii?Q?42zvpL4g9OVXji3v/ZtqonrvgqJH62T05aaC0jXUPcSrtkoEINhzLsHNPYGc?=
 =?us-ascii?Q?HIMC0g2MA9WIh8dOvGltJUVT5Nxhm90CUVIp7Tp8gKUUcfgH3LUh1p6Vmu5S?=
 =?us-ascii?Q?vTaw47QzUj03kKBY0qwnoxWwegjeTjlmvODQ63Y/LH+ZlR8SWdI/gTum30nT?=
 =?us-ascii?Q?eJyyvZs7lV7PEaqNN7t3aLg7Zo/VquHrHjLSss8ftPLg5wwICjH/I3atKh2J?=
 =?us-ascii?Q?AL1OTh1AD+bQ4JSgokCl1onq8Ba4uuQ//Es8CiacvOaMndmU3o0EN4xQIZFb?=
 =?us-ascii?Q?EFiQF6UkPxJu03zJbcTNPRqssh419ve4JoEvfPzeGw6ZymjB1dXGhO/u8Y8I?=
 =?us-ascii?Q?HUXLYpDEZTQCk5L30ySswzI4TcGBYtAo0IFpZ4J+j/zhGY1LOtJfVHtKgDrW?=
 =?us-ascii?Q?F0obr1sPg6AZ6qAwRkPhwOV1lfApW3OOhBo49G3RBIJyl5L7KWsPy/wR6RjU?=
 =?us-ascii?Q?BzXavczZDtHWCrisUnZtGMsmDbqeIN/KRIBs40tlR0ZEKvJLI+3413tTWfw3?=
 =?us-ascii?Q?5WHOxbZS5J/S+BkWlHg63QbFnP0eorBIdg21bCJbB3nzAtjU4NA9fhAd1AJE?=
 =?us-ascii?Q?T/jq0N/qgd1ZDCwhB1619WJdr/PPD0cdxKJBTl9P4PnAGpwSbzLvwXCpH6zk?=
 =?us-ascii?Q?kyLRaGbGmbc3r5MDobkaHQuF2EJC4OQ96H7OTmV0fN3QFpeje5qqk89MXAbM?=
 =?us-ascii?Q?8YA7ymai3bOQlHbfDhNDusCEXSAGvNuCeyhAHbpK6Wp78/38zOJPTxye/wp2?=
 =?us-ascii?Q?GCoqntKUoc/Uc0NSeLlpPYaVq3bGROx/xbN/P5TKwW8rVLQyOt6UncJl1/pe?=
 =?us-ascii?Q?vht/SZ1V4s+DpSCsyblIEO72xLYZjE7jZU5g5nM3CYN5j31O+Jwivx4ptMW6?=
 =?us-ascii?Q?wqPweajv3f35X7dHbaH6J9TN5VuzgTqJ7NsE9ejiBKMLtNmU+vCAjk1AsJ0D?=
 =?us-ascii?Q?ph35v1Irv/nr+G/HbUUiYTu9eM2C5FE=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb1c9f3-bdf4-474b-887e-08de53e156ff
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 02:54:02.6701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eb3d/rgCmKeMt/RdaUgVQonW9AjUjhgRZnW2MAQ4SrGfbmV6GFeTKpwTC5dthCl2D6qWO7RgOknKv8vZEKuQug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7941
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3EAB140005
X-Stat-Signature: w6rbc6btrfukq9cd8kxhr4o35rqmtdbz
X-Rspam-User: 
X-HE-Tag: 1768445647-411386
X-HE-Meta: U2FsdGVkX1+hVj+E8YdrmvBlqs/0jZuSwjJ7yJgIeqa8kUWFBgH9khUT2LCoUAk+CoOVHthyGQvNbBpCd5h1KkesQrtznHlLX3ZaNR6TlaQTPjwGP+Jc75jp5zwaQ6/u1UH4L2Urk9579ggUQi0GyrVhZdWPLQorQD+mPsSbJ8d1FSfW+R6h+WcUqAOSoHTF09zbX46jdfDlFmI8CKn/3m4/OBpntGUJJusm5UvAKnI5q/sRUJqMr+dudFqKp4bUR1oVnf0Y9+XtBNwN+UQ0qRCSRNjZh98yaH9V6aRrOwlLw7ELvkxq6AKTE/uiqaI3BudHDaQeA5tBighcDryjsyhK9eia3Dh7sRtXa7R0TKXbNLd1QUOEduZIuxAoVQSR43oWP/yC/jQROsY6PNv9bb7TEuxmlESZJuUqfhRLkzDWcuGhp6PiEo2Tj3QZ7a5u4HDRODwT1gBNqulroiMGOir9gEOEWQW02aDYHeXXftPZ5W2tOekwRccMCkR1noDdWTG8X7aarWMnz9NiC77s2xxKdBp0wl6BGVbhZZPl7tQtg0G7+i9lSZr5pu6qRiDmEUQy17YuUXMhrkg34sWaB1ObfS4OlCxpgJ2njrGtAvuwdTXDq2pORC2lA/vnVovqBSHw+x1vEM/GXB2R2nhuBViQzto1bVfGyEmnJiBBpNEUWN6Obsor4RTddI3ocjqY/atHf0kvVI0D2DoZGzZ4GRUKu5k2HDWK2wCa5uhiQXR+rBitQcoz4I4QY2BpgPWq51xr0eZCDnjxXN0TrPPeqjk3JT5yWK5vT/H9lXXWsgAy85kvUKu8xTkqUXDp4pvZnxuy1nVLxA0n/8ihMpst37BtFO0Q8MwtEgUeVFLw+e0/JsDKzq2x1vzO5w8YCFgawwPHL3Zeb065UFaecODDSKfF8s0Fqu+5ukxz9slplhjBc4uZqLn2PNOedmsUp9R9jfNd0KbFPcihRiaMktj
 nSXTbVvV
 LiEMJ8zxMJWm38eVGeCDWJXKCtAkfiqQBsb9AmGcyiYEoIMIbyrdB8ljkgNcg45tJ99TR4QJHuuh3qmckgstmEYN9WTz5DGEUCDtuH1EF+EQfCa4xoEUSCyV/2A1+Fu9r+W4GGIVHsMBde/1B2aEQdGQEogsu5/P01hIddTn9AEZvpqX27BjnLuukX+E+z5xaQbqx54sbg13m/C0Z9bjGIdlRHHKkDYj2NJZ/+k/0/KptP3GDbfj0d9gygwLa4ZoOH0cy8S/XWa2YG+tZFhggi85ijDCV4AZWwUQn62eyJSKsHZnm/sfTuavhqycyJo+KQd6hvVYZmenvPizmL7qk4mJgkRwyi1WA+qUpGBkRHwPldvLucaS8mYWCCy4sdh0AfGfeDiAVtzfD6RlltUb1FLkt0wnfKgdAald6m4yK+x4hY4+PyC/Gxtmx/OI2Zvi4LNsnbVx4rT5PXOx/FZEhneDx5VuZGNcB6bXN9pmVnPXt5EuI4ZMwNET/fEoUac91FMcVqM6Lg5aKACogrcetN1s1gvKub7HN4Dn9oeJ4qeCoLAg1Tomu3ZH0tFmOUCWSsRGPO62t3036Pie0hqGdQEpy88lyeIRZB8xi2m7A15wliNMZ9S5Kb489VlFIdst2qUvuiL0OOldoNBycT5PZahegI9YRElY+fQWVH5dAYbHpFH1kw0ZLUsHAznl6g9xEjcK+G5mePvVUoXSPGoJ0txqu/OtqNRTYprp5iOUGevvWeDTwrE9eqlbywUs7ZYMI2NVxxkRqIJ4OeoNgHBSEi0+QK6w54S3//IoCs1y/WPv6xj4VDq8tHmrZfnWOyrFbp75E3g05AaiS1Kg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 01:41:11PM +1100, Balbir Singh wrote:
> On 1/15/26 06:19, Francois Dugast wrote:
> > If the page is part of a folio, unlock and put the whole folio at once
> > instead of individual pages one after the other. This will reduce the
> > amount of operations once device THP are in use.
> > 
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Alistair Popple <apopple@nvidia.com>
> > Cc: Balbir Singh <balbirs@nvidia.com>
> > Cc: linux-mm@kvack.org
> > Suggested-by: Matthew Brost <matthew.brost@intel.com>
> > Reviewed-by: Matthew Brost <matthew.brost@intel.com>
> > Signed-off-by: Francois Dugast <francois.dugast@intel.com>
> > ---
> >  drivers/gpu/drm/drm_pagemap.c | 26 +++++++++++++++++---------
> >  1 file changed, 17 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
> > index c497726b0147..b31090b8e97c 100644
> > --- a/drivers/gpu/drm/drm_pagemap.c
> > +++ b/drivers/gpu/drm/drm_pagemap.c
> > @@ -154,15 +154,15 @@ static void drm_pagemap_zdd_put(struct drm_pagemap_zdd *zdd)
> >  }
> >  
> >  /**
> > - * drm_pagemap_migration_unlock_put_page() - Put a migration page
> > - * @page: Pointer to the page to put
> > + * drm_pagemap_migration_unlock_put_folio() - Put a migration folio
> > + * @folio: Pointer to the folio to put
> >   *
> > - * This function unlocks and puts a page.
> > + * This function unlocks and puts a folio.
> >   */
> > -static void drm_pagemap_migration_unlock_put_page(struct page *page)
> > +static void drm_pagemap_migration_unlock_put_folio(struct folio *folio)
> >  {
> > -	unlock_page(page);
> > -	put_page(page);
> > +	folio_unlock(folio);
> > +	folio_put(folio);
> >  }
> >  
> >  /**
> > @@ -177,15 +177,23 @@ static void drm_pagemap_migration_unlock_put_pages(unsigned long npages,
> >  {
> >  	unsigned long i;
> >  
> > -	for (i = 0; i < npages; ++i) {
> > +	for (i = 0; i < npages;) {
> >  		struct page *page;
> > +		struct folio *folio;
> > +		unsigned int order = 0;
> >  
> >  		if (!migrate_pfn[i])
> > -			continue;
> > +			goto next;
> >  
> >  		page = migrate_pfn_to_page(migrate_pfn[i]);
> > -		drm_pagemap_migration_unlock_put_page(page);
> > +		folio = page_folio(page);
> > +		order = folio_order(folio);
> > +
> > +		drm_pagemap_migration_unlock_put_folio(folio);
> >  		migrate_pfn[i] = 0;
> > +
> > +next:
> > +		i += NR_PAGES(order);
> 
> Is this just a wrapper on top of folio_nr_pages()?
> 

We might not have folio order. This is a macro defined here [1].

There probably is a similar macro elsewhere in kernel that does the same
thing, I can look for that and clean this up in a follow up if I can
find one.

[1] https://elixir.bootlin.com/linux/v6.19-rc5/source/include/drm/drm_pagemap.h#L9

> >  	}
> >  }
> >  
> 
> Reviewed-by: Balbir Singh <balbirs@nvidia.com>

Thanks!

Matt

