Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C3BFEA803
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 05:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A38906B0005; Wed, 25 Mar 2026 01:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E86E6B0089; Wed, 25 Mar 2026 01:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0AD6B008A; Wed, 25 Mar 2026 01:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 753C86B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 01:04:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07B54C26FA
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:04:22 +0000 (UTC)
X-FDA: 84583394364.16.79AAFF8
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 017CC40002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:04:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BPnqCDEB;
	spf=pass (imf17.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774415058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QYp8cuLIX6n1GG1MjEwUb+rBbncSQBRnjuQaUKnmKA=;
	b=YC7b5g5fuR92ZYCPTphLpqYHkIypYy6imc5f0tB4numLq4UuJ6BRqsqM8c9yz8tVfEgras
	vAEzvxK5k/g02R6CjaaF4bw8w56tUYEw/SvQhjYgooO5Tjs5W6bWdjMRCgndAoHyJU0U/z
	QVxlm2Dioy8ZFO4841u2ShxZquck/R4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BPnqCDEB;
	spf=pass (imf17.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774415058; a=rsa-sha256;
	cv=fail;
	b=cwtKovvnE26PssXxYoHjwa98DMkjTJ851EjdZS/tW32ZTDsUO9QVKVjePGNI2Mqzl6U8t8
	5S9PB67mLKb2RCyyKILudrayovuSfTgx3OmWjbPQC7tTTlEtqT+w5ybmAs/IxHApVoEvyh
	YlfzFhHTuC5H1EMJJRCFOXOYYCvijWQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1774415058; x=1805951058;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=bQC2mVxuv5Hyju2SVTnUQDMy1xV06iGyJHspPD6oMwg=;
  b=BPnqCDEBBtP0mQ5g/gcV6rXRQplcamP7gMYWzqVwDfYFZqrMjd/g7BD0
   CHmgyC3+LPrpEU1Fvo88VAGpco4H32HC7g0dv/bF1Yl5UvSOOJ5sJxSWh
   1qb3xRUVEcB84ueKLCQCDW4R+BjTyEeLMu4mx7yCTUgSe3DAwPVoPjaf8
   N97NNAGwpPQ2Sptvc1ncUBfMMs9NJVEV1WSjQdET+etcp/cY6vGhxvnNU
   zS03pnDbuxM1SC9nvCBLjbgmzWTrz7+rss2JFWqvWuMbuWEpLElwVCG/A
   Tq+hkwxieGcqA5B0dy2btoLy79uXqtCYKvaDjDHUOx7nZWaXOD5Tt3jqy
   A==;
X-CSE-ConnectionGUID: ZuG1AffQS2SjnS1XYxmXDw==
X-CSE-MsgGUID: Hmx0W9I9QF+s2oVHEoZdOg==
X-IronPort-AV: E=McAfee;i="6800,10657,11739"; a="86818591"
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="86818591"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 22:04:16 -0700
X-CSE-ConnectionGUID: YbA9N1+pTxWZct82NQSjpQ==
X-CSE-MsgGUID: xBMojPr0RICi1Z+kiXQ5Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,139,1770624000"; 
   d="scan'208";a="221675870"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Mar 2026 22:04:16 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 22:04:16 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Tue, 24 Mar 2026 22:04:16 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.58) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Tue, 24 Mar 2026 22:04:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xj7ADFo2ixsF9Ato/hPR4pDneZ+V/tmwwZnY8S/JgEt4y7HIUURtxcTg7QIlZo0upXvyk0FPQjBUqbeqeNG9QZsqJgAJolppU12JAf41qPq9ZuJtxEpve40onOkfQIwl16jiOeah2PYZBtOzYSQzonBHcg1X09u0Us7aZwpUvrG58nBIB2tcWmfkY5NhAOm0jeIivzvzm718NZ01fxSKu65BkLIHBgWzDXJjtEL4FpgDOb6NQfzEYMF0DMQdUeEcPpp9yu1abpL4sBL4CYTtpYLTPssSMGDAhWoDdulFXVvLH8uQCAQo4xb2aQ99CDfexPZNSmUl680co2uLiyJT/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5QYp8cuLIX6n1GG1MjEwUb+rBbncSQBRnjuQaUKnmKA=;
 b=kvaNcxoW5TWHHT1Cb9fiXgMM6954XYdCDiao+skZN+AL5NesYU7u7h5Yz+vdBr7SY4inwrmeGpqMPhYvgL7On4/ueE4V+3pk3g/rrc2ca6Z8OG3/gU2Z0LqzY5JkMqxMgEa1gHqxyIiOTsxcG2FtaFql3K1/EatoxYiPVN3hmZHtiRnJgofMWqgSxtTcgCbaBdS1D1dc6pkYZHla064OgK+eUnBJ7sRRX+mVLhNJN15Uj1GuVE8zfHd3EewWj9Gl25X/QgsPOHGRzAZinExXa09FgSp5FFL7U90Ud/0w6W7rGjbWZxVEqOG4FdqgvJVcQKm2K4QX+DwWTlGe32edvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB2808.namprd11.prod.outlook.com (2603:10b6:a02:c8::26)
 by IA1PR11MB8785.namprd11.prod.outlook.com (2603:10b6:208:599::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.15; Wed, 25 Mar
 2026 05:04:12 +0000
Received: from BYAPR11MB2808.namprd11.prod.outlook.com
 ([fe80::defa:788:da96:2f9a]) by BYAPR11MB2808.namprd11.prod.outlook.com
 ([fe80::defa:788:da96:2f9a%4]) with mapi id 15.20.9745.007; Wed, 25 Mar 2026
 05:04:12 +0000
Date: Wed, 25 Mar 2026 13:04:03 +0800
From: Philip Li <philip.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel test robot <lkp@intel.com>, Chengkaitao <chengkaitao@kylinos.cn>,
	<oe-kbuild-all@lists.linux.dev>, David Hildenbrand <david@kernel.org>, "Linux
 Memory Management List" <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-stable 72/140] arch/sparc/mm/init_64.c:2582:16:
 error: implicit declaration of function 'vmemmap_pgd_populate'; did you mean
 'vmemmap_populate'?
Message-ID: <acNsw6lmMmSpk+c1@rli9-mobl>
References: <202603251147.CtgepAeH-lkp@intel.com>
 <20260324202754.6f29c4f6530ec7ea9d1f753d@linux-foundation.org>
 <acNdJ/q5tNB0nNjp@rli9-mobl>
 <20260324212658.a267bb861af1dcbf119a1901@linux-foundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260324212658.a267bb861af1dcbf119a1901@linux-foundation.org>
X-ClientProxiedBy: SG2PR04CA0159.apcprd04.prod.outlook.com (2603:1096:4::21)
 To BYAPR11MB2808.namprd11.prod.outlook.com (2603:10b6:a02:c8::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB2808:EE_|IA1PR11MB8785:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e727321-3d67-40a2-47f6-08de8a2bf48b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: c/WaqtupdN42mYRlE269LKG0GCYv6dQVpw1un6JZuctZx93QlhM0MB9n6qV2YpOkzwm/0gPEYgRy6mbDcQWgj8BDQaNqEwiXRK6xdEj6eYW3JtlpqDS7EeSBSG4SRCgD3X0njCcX+VJcKh68d4A6PFch8vkgy643WWnWGrBxXB7TekF98b5OVi3O67jRy4rpy9ZzaDYUaqvYQeqENn/o9MB5wTmUVuJTap4/SzV1hpQ6qyS07dMbXWZXarD4+rJaAbmuGbGfHkPNR/pbOcCZVtekBRzBX7UBEiQLrxPevWLSXdw6xSLJryJ//B74t+hlnhXohaNlkkguDSDJD9BuzavXe2KtyJPX0B4xY0mMTWQ3j9lYjw38hXlox5SnP5OdkRi7vfH0CAFV/BgNX0V4rtsqm/YgubzQylibzg2hH5FK3GL0M8D/5WN7jFSvpJmEoS35RLJnHBBchDaOYUcE+PZ+kXDxugkZRTm/nkDLwf9r4aH8ko9GYkfEadPQ14D+aO7lda/3GtpaqgvHJiiQw6jh5zBMZb7oXlW7UdYWNE2gR3KS/NQRv7OOg941ODLJSzqZpvK06H1Xr66T518k7E9+RRM6q5vKH+q3/hdvm28gvMQSZnqkCZjZ7jBUydqYn1+LdpxwxoQU3f5UYwLC9QMwJLNmXYeXSDuZ6t+SyOx8o99TZK7fdQrxqVQyTHtcrbU/zCGgJTGQQGvcLQPECCuNEebpBjW/ToQEGDKeL0g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2808.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aWtGaHVzN0htclVWL3hrb09FVUdCdVpUNnZKTWhoZ3EvSHhqWWtybEkwc05W?=
 =?utf-8?B?b210cm9ZY3hnWk5yN01JamI4L0N2TWxRaHdKY3pESGp4WEY1TVgxQkZLN2k2?=
 =?utf-8?B?SCt4YmUycHUzZ1V3V0tBOGJYam9NNFN4U25GQW9OSjFCb1JJeUxZS2hOeEFh?=
 =?utf-8?B?ekNsMWUzTVFBYzBtU1JZRXZ2N0JqRHpyeG1ubndnUm5hRUdEZkF4T2FBdGRR?=
 =?utf-8?B?YUFjWnVvY0pWTUJZMHQxQ1ZXOE51NnplRWpiaTYwQ0RKQnBhd1RwUnNHSk1z?=
 =?utf-8?B?S1h3RVVlU29ONWp2cHBHU1FTcFgyUTVyVXN4a1NKZVBqYzdvVUc0MnJYT0VU?=
 =?utf-8?B?STc3UHVrNXhpUGh2YjFFdFArZnJrcWV1WklhZU9ySFE5MUo3SW5CTjlyaXRZ?=
 =?utf-8?B?Q21mcXVML0x1YmVONnprK3BxcUk0OHllVUhKRktOS0tGdCs3WXdRY3ZJdTdl?=
 =?utf-8?B?LzRoSGFjMGFFNmlYU3Q4QkhTbTh6eDFialBlRGdCQm1qVS9udCs2N1FQZFR4?=
 =?utf-8?B?QmhDNDFyWU9hbHNOTzR3RXZ6UnczemxJSEdTNWNRSVloTWlVN1BzM3ROLzY2?=
 =?utf-8?B?MFdkK3d5VVh5NWZFUC9CZVV3bXBwbG0vbXdiMGZlTjkxdkJ2VUZ4SktmcVJQ?=
 =?utf-8?B?UDRkUHcrZVhYUkFLWUtIUDFHUENFNnpRVS8zV3c1ZkxEZFZtTUV3VEtoazVR?=
 =?utf-8?B?VlAvS1ZhRk10Nk1rcU1iYTY4MEpRU2lGRllvZTZUenMyUjhPb1VPTnZqWUMr?=
 =?utf-8?B?K3VOaEtOTWJ2NThQYzZBRmxteEpVdGJmNWhJYkpiRFVFeG5uNHp5S2pxLzR3?=
 =?utf-8?B?WnduMWZnT1FpOWZWdXRZai8vcUlmZFpMZEpIQ3YxV2h1djk1aFo3ZE1jNTVC?=
 =?utf-8?B?MEtkcFk1UEUwK1M1M1l4QXk2RzUrQ0lEUEJqS1BVZll4K1FUTW95S09lcnhx?=
 =?utf-8?B?RUliOGxPdUozd0ZUcGdMOHQrY2dnR3NiczlYOGljcGgrYnduSkVUVlRWQmhp?=
 =?utf-8?B?aURPOVc0eldQRHVNM1BydWwyYTJISVhYeHA4a051R3RqSnp2bUxheFBkSU9J?=
 =?utf-8?B?dldvN3MwSVJVQ3lVOXdSczRzUXlaT0lCdm5qREFydXpsTVF1M0lHVktOR21R?=
 =?utf-8?B?Q24rTEt2N29HNm1FeTBHUk0rYUFhb0lKdW9NZW1nN2NMQzNxaHpmc1kyTE1V?=
 =?utf-8?B?N0MwUDlLNE9JK3NadE5KOUJ6NWJzMk9Dc1MxakVxaTE1WnkwN3daTUpCQ0pN?=
 =?utf-8?B?UGdMSS9GQ2J6VVd0NTlIMThoTkg3bHVoZ3FkbDlmVkFrWklBdlQyejFwVXQ2?=
 =?utf-8?B?Y09PMDdGcUNCQ0NMV1d3cldJdWdxNk5Xc2YxbjdreHQvaUUvUVE5dVlIM3dW?=
 =?utf-8?B?WHNlTUNHMVlBRXdSMzMxMEUwNGxkTmE3Y3FvM2dQL3Z4alNSQWxRRmxNM0pI?=
 =?utf-8?B?enEycm94UTRhL1FYS29yaVcySnhiTjhmSFdmZC9vUlYvaVdWUzBXWWE4UEtu?=
 =?utf-8?B?aDB4aHcrOEJEbTIxUXVmdkVHNVpZOTE1TkpxRGlvTW9UZGhkOWhzMStpZ3ZM?=
 =?utf-8?B?WjhrMVZrVEFCY2ZScVpKRFFWaDdGTHlSd2E1QW5EZVNwSDlRZGFZL0JzUS8x?=
 =?utf-8?B?bUw1YTJzeEFxSVgwbEthMm1UWXJiNmlnSzZtSGQrVTNWNE44VEthUHY3blMx?=
 =?utf-8?B?NllBaDZFS0VRNnFiQnNDdG4yaDlhYSthVVdkZ05CR1RIZ0N5MzhRcXErMUN5?=
 =?utf-8?B?bGhwWENic3NWRlBMMzFGQTVETXR4R3JhUVh1RkZwT3BUazlyMkR2TngrVWxF?=
 =?utf-8?B?UUx4djdVdFBscXNWUTZtekcrK2RBejJkdFVwYmRqMUpyZ1NKQ1gvYjhac0tM?=
 =?utf-8?B?aWFwVFYyREVkQ0Z3aVpWblhMN3prcytSUWpXTVl6Z0pKQU5lVUhMeDkxaW90?=
 =?utf-8?B?YytBSXVNcktnSXhCNjRjUWVGUkVKWW0wbjROSnpIUDZwM2R4VVhGT09IdGRz?=
 =?utf-8?B?TWQzWFpqblBSMkxzdTlwWk1iVEU4MS9jMXVhT3BxeXJSbFBCdUlKZ3VJaDZ6?=
 =?utf-8?B?US9HcU1qV0hXb3VSNkh1Mm5KdUZxcmo0ZDJVRk54Wm14cHUrVndtcTFWY21O?=
 =?utf-8?B?RVFrUXc2M3BoRXphVEtTd05kK0FnUm9ZbkRnU2ppcEZJRzJYYThET1J2VXpN?=
 =?utf-8?B?WmhZMjIrTVRPY2FoaVpOdGlVSTZTaTQ5b2hnM2xMRU9mNmY5MnN2eHZzdW1l?=
 =?utf-8?B?OU44YnRhdzFNZEtrbjY2eThLdnJUakJHdHJZTVNndW56c0dGbmJ2cEhUbjVx?=
 =?utf-8?B?QUFrUUIvWnV3Y0hiUUw2SERvZ01FSk5qVEZhYnBiSFBra1hUbmp6dz09?=
X-Exchange-RoutingPolicyChecked: h4jr7G++NnhXucthD4dKGA44AiYe7ydZk5w6eYFQ6CeITrJ70cCis9V84RH3uuW38kAgGcjTYhdQVI1KmjkW7YexbrFEqu0z7eDgkkT33fwK1CtPHRw9Vaa8I03OOsjKsJTlLPTxAvYPTnUsDKVM8k1EWNaoTZsbgX52WO/KOhShRMV+c55B+OSpG43+KaJtz8jb9jg9TwTqiE6vAc9VQ4tvSU0H7mzPFErDaSI55PFWQ0FL9PTUYDCS1KwgNtHyoJBR8CuvB1HaeUOCAF0NWvBjz0PnEoYKUS4BnLn1SXJYz+va7/FTBwC/aErN1hjw9Syz8pA4hD7OOtn21dLW4w==
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e727321-3d67-40a2-47f6-08de8a2bf48b
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2808.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2026 05:04:12.6988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iHThKskqUKpD4GfTpGx9Iac+r4sQ1fMDqtHhcTWgIvlXHQfXX6IRTLTcIy8gfdP0ryVXt7NK/9Ic+FA+1K+/2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8785
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Stat-Signature: buynpgk7rojob1omhhg1skdeg7muz4i3
X-Rspamd-Queue-Id: 017CC40002
X-Rspamd-Server: rspam09
X-HE-Tag: 1774415057-957389
X-HE-Meta: U2FsdGVkX19U6ucOmF5M1Xvt9szYKomwSn2bPDsuemqrMh5pbgRsEUSJg5LCKzTTtQzqzXPPios7bzPGj4lELeOfLHUSopFhfv3ssYC9wC/yTLgpCMBCSyUmL46hG0wfTNZsvQ7Rmm83txizbad6qnBh2WzvB2RR9EgIN/MRYV0c2bDxkvENk6sXr8qzPKTs7BmSwxQNuCnDIJ/5Hj/AXWB/rArp0M3eAXTn6xkVB1MVFUMX3a8v8ciLyI+85wn6XMycudBlu/Lk8IHK/wJBH2/+weIr0x+ouNn3ygWl257jTxoxnmGCpY8sWn5rkEGwkE1TT2tRFNLklWZ0/Xabv8XDHOOmq0cQIf5ZNgNmNex3lniWCiA5zWEYCdiV567JubvC+h1lLxFc/NlkUpMNiPhdSKHl1A9osuOZuv9nd0tmaKZOLCe0ay0QKDgN3bk25qag9CsHJFlWwzU41b6CDB4OtLPQJSPdfx2HZ5fQvQNzED3A6wNOk/SVjMyc2+UQXmP1X9D+36HeRVqaGmrrRyIBy+N9wsa333WTF4CvoEkoXHRB4eb3ti0Mu0nJqdwHJX7KTnAUAGGmBtl3ZM48S6PiRs8zKnSsbSlslnowCNZvm5MldGb0b/MbW1F8F5b6hrctNltYBqMvGBGxzznf0vvTVzmaHWmlEBDO/lwiZL1Z7kUz/7+o0aOvWpbDjJQz4OH4scQ8G1KJUYCpoA/WUhBjPpSDTeM6f1jSIq3wWP+YpOf/1+URS8f50HtQRFVDwUGndsQ4qVoCtz6ow1Qr4T9K/kvpFqtfMiIwF4dtJDZy9HxL0+saQ6VuQIYFAOG5VVlRNev1Ky789KQYKCzUeJFO3lMGzlVdwqlw1rby3g6GYGC66K1r5s9EYIB5ErP7W+ONN9NNLCIwbFufDV/C+RVl2EvWvCIICxJD9fdyMAmHppGEEWZk3D7XkIBYLRwKTcdsvP0pAcoLxR8wkGN
 LOPgiq/D
 53UqdzFMJd+RjtUF3Ln7SzI7MggKu/Aw6/NLMUSodTBTn3YfnpwxzZ0dw/wHbmymw1KEYlu+aEUPQuck=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 24, 2026 at 09:26:58PM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 11:57:27 +0800 Philip Li <philip.li@intel.com> wrote:
> 
> > > The coincidence is too great.  I assume Kernel Test Robot is somehow
> > > treating the mm-stable differently from other branches?  Can we please
> > > not do that?
> > 
> > Sorry for this "coincidence", the bot does treat all branches equally and
> > there's no special handling of mm-stable. One possibility is the randconfig
> > is just generated on 20260325 "sparc-randconfig-001-20260325", which is able
> > to expose this issue for sparc arch.
> 
> huh, OK, thanks.  I was able to reproduce it with sparc64 defconfig.

Apologize for my conclusion, i did a check of internal data when replies mail at
that time and only find the errors of randconfig. Since sparc64-defconfig is recorded
as done but not shown in the error record, I made the wrong conclusion that this is
exposed by randconfig. The truth is sparc64-defconfig does cause build failure.

recent_errors/
└── sparc-randconfig-001-20260325
    ├── arch-sparc-mm-init_64.c:error:implicit-declaration-of-function-vmemmap_p4d_populate
    ├── arch-sparc-mm-init_64.c:error:implicit-declaration-of-function-vmemmap_pgd_populate
    ├── arch-sparc-mm-init_64.c:error:implicit-declaration-of-function-vmemmap_pud_populate
    ├── arch-sparc-mm-init_64.c:warning:assignment-to-p4d_t-aka-struct-anonymous-from-int-makes-pointer-from-integer-without-a-cast
    ├── arch-sparc-mm-init_64.c:warning:assignment-to-pud_t-aka-struct-anonymous-from-int-makes-pointer-from-integer-without-a-cast
    └── arch-sparc-mm-init_64.c:warning:initialization-of-pgd_t-aka-struct-anonymous-from-int-makes-pointer-from-integer-without-a-cast

I will do more investigation to understand why bot doesn't report issue out during the
7 weeks window, and fix the bug. Sorry again about this miss.

Thanks

> 
> 

