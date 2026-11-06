Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6950606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Uq9+uKN7
Received: by kanga.kvack.org (Postfix)
	id 68B516B05B3; Thu,  5 Nov 2026 22:56:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 615056B05B4; Thu,  5 Nov 2026 22:56:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF936B05B5; Thu,  5 Nov 2026 22:56:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 11D146B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:56:43 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 747A28077A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:56:40 +0000 (UTC)
X-FDA: 85403332560.24.96E9013
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8BB6B140004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:56:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Uq9+uKN7;
	spf=pass (imf26.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793937397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJ5iynLB+JozSVhACX1w19eM3zBt27WYLLNbFDwB8vw=;
	b=hgrVlE1L7P7wi0VkcwzhOWyzsAcWT6YQIuqsKOi8cKERdGaIPHsf59H+ZP2/htlabltWrT
	uzEOpaYd+ixFKDhebolIMzJojH8PNC3iKkEyLwlt4yZTPF036Z0/ohPH8EK7HNLgpeumTX
	WyajvQrj57ePw9WSrHtI3+/skWM3h/8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1793937397;
	b=v05u8UuZmuVi9m5mhMsWVm6rcuCjDGBpJE7jROUYCwqERJ0snEuyImdEe5J6QcgZvsG4qV
	1Tu7qOCnwPzpWGIKSqVWykFREC1mWvItMDcNp0w3JwoKeTIeKN4EgFKo7y4KHuqhHZI7xF
	BToFqi0Sq0i6IWPqWLcnW9XPkJN8egY=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Uq9+uKN7;
	spf=pass (imf26.hostedemail.com: domain of philip.li@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=philip.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793937397; x=1825473397;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=R4NC/CsHTqQ5ipyBYAroIpb3JKXMNVwvDgqLZsFvpN8=;
  b=Uq9+uKN7uZn8QBwztO8GgvADgnUkY4Fwwq4KlZoQUswJpvtAy4Y+2CXM
   wDenIzwuTbGFqf6hK/LXCWdJhUv9QqYuFePYeC8+NMKbd8WBexSVXAdj+
   LkNCCWPY27ypeRXOS5KQAfTSasmKDaVQ+/TKHYo4Sd9qZUrjygYB76uDo
   r+vXWPQ7UMk30mX5OPqL4wggQ3RYuEKUHZM6lRXW0tA3Sl9wd78UvKSvM
   V9cr9h6BfKa8PRZZzuSs2WVpNtvsHbgYlW+bIc6YKADZRbS01fFd/HNrE
   DlY4UjtCVJiOqMkPFMIL+4EuPerfkU+qr/qaXEhm7aHHeRPb5e+YoPn6q
   A==;
X-CSE-ConnectionGUID: 45Kr+35TTMK/3qqFcfj5aQ==
X-CSE-MsgGUID: bJJSQpV2TEW16atQplHxEw==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2769458"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2769458"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 19:56:36 -0800
X-CSE-ConnectionGUID: GSUMbV6MRiC29KRdBLqN5g==
X-CSE-MsgGUID: fmJA/DHESFeAR3Mof9CngA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7210156"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 19:56:35 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 19:56:34 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56 via Frontend Transport; Thu, 5 Nov 2026 19:56:34 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.13) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 19:56:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VqVY6a4lx/Irb6DezewTD0WdaxLQ9KjfE7T945y5GqC9EV2gSA1DjHm1zP/Yi2sHLhldZ5OpiNymlsQHXjBSaowHHLSfDPc1Yk+9pI3LzZNWgBMPkHii5ieruGUvbR6/WUqdngCqSvLr8ghXsH7Rc/pL0BOEY5SGkGN3Yp/EytKU9CKqMakwEyCy53Xnp990ai5nebVNZemiuIz8WHyQRSdh6uKJvMZHTypcopCclUFIcjRNtzVeJiUSpIH1d7GxOk+v9KzYi21q/HDQbwDuXgvQPwkT9w9phonncWFZcnHyxpD5FKUAmhPeSF3Pd7pJ6YSiNt3hwilDeeiUW0rFMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YJ5iynLB+JozSVhACX1w19eM3zBt27WYLLNbFDwB8vw=;
 b=fA6KUI+0b6Oiy+ueLbQw+aYRVMLoI0WgJ5ydwFoPOAqxcpCIQI/7qFT5uEZctZvQTS/mkVfO7RG6eFPrFKqSobhN18VDnyqDMdZ4crXo602jX3feF/At1h3WWdkvhsZ3yyg7IlI2eEZPnkLA5e5sm2oTw9WBHN/lbti+3criuHC6h3d4OjDFntpVkpsow4IH0Od9B3uaY4yxBpxwBwWNiDNkb0l+PmLKrCsMR+WbqoRMxJu01JgeWUsHyewCmurrsCVHhkt5dmfea5RvlYpD1FO1p0T0/ykWPJygaRNju7zUHw5oYlPAsd+VAZp1FAwFl8syxT19R4bnz5J/fEh9Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS6PR11MB362586.namprd11.prod.outlook.com (2603:10b6:8:4c4::14)
 by PH3PPFF1A08ABF9.namprd11.prod.outlook.com (2603:10b6:518:1::d5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Fri, 6 Nov
 2026 03:56:26 +0000
Received: from DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a]) by DS6PR11MB362586.namprd11.prod.outlook.com
 ([fe80::71a6:38f9:43ed:8f8a%6]) with mapi id 15.21.0592.009; Fri, 6 Nov 2026
 03:56:26 +0000
Date: Fri, 6 Nov 2026 11:56:15 +0800
From: Philip Li <philip.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: kernel test robot <lkp@intel.com>, David Hildenbrand <david@kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	<mm-commits@vger.kernel.org>
Subject: Re: [akpm-mm:mm-new] BUILD REGRESSION
 dba8aba0a9a00ff781c03d82ae534fc6f8c2e263
Message-ID: <au1P3+HYvy4uiJMQ@rli9-mobl>
References: <20261106095340.lgMcCHGK-lkp@intel.com>
 <20261105190559.5656444f0cb52cbf888427a6@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261105190559.5656444f0cb52cbf888427a6@linux-foundation.org>
X-ClientProxiedBy: SI2PR02CA0004.apcprd02.prod.outlook.com
 (2603:1096:4:194::14) To DS6PR11MB362586.namprd11.prod.outlook.com
 (2603:10b6:8:4c4::14)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS6PR11MB362586:EE_|PH3PPFF1A08ABF9:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e6ecec2-4612-48bd-51b9-08df3bb9ee61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|376014|4143699003|11063799006|56012099006|261022075727099003|261009223027099003|18002099003|22082099003|10067099003;
X-Microsoft-Antispam-Message-Info: XPkYvCuHir1PA7Vj0Q3uJ4bhHerEQPne4vp9y9AOjjUbcbOpe6BvLjRiE8/38zNX0e7RhqYZRUornSm+Piwf0bywnIIRwMX1hRoRT3hj2uxpHpMb//tqztFfHP4VthWwENHz5KcddXe6TI6/gY5OX6LI8jXrlI1rZRycXbkSgR9bB/j3eOYYoRlPOEFuEC/Ok1YmnyPiR1PEsi+ZKEOoGV+s1QNfI1p98b+bklBKKi8ENeez1ChmNmED2InWHTRIvXjaF+t8SveAnSx2XhITm2nGRPzdNMRbVyKSp999mUTRJEoEOtW19wgB4l/NKNsNFf8nYxA9PmNpoco3c/1llKyJ4z+Q3udQPjVHvIuUJ47HpCzphgBNQiMN8cwEqX/QYVZtFWtK4l3onsTOsUUWODXX2sBS8NQ39TJnt/GgkenEw/ifVFKIwHcRnbsbZ00kFhxVHqjUMyY2/NZxz5IaKiKYZ8FAsXw0rACNJUjg9HjHWdf6DamrMHiD1zS3m2ZTp7eKwgB53I7k933+zPQUata4ej4DJ2prTUCfArsC6imlkCyI4TKyP+y5yAyyR+HwNT9ZHl8faRHwD8VAxNO2SdB3K+x5MGCPwb6A9eUEHnAN1nEa5tgtbpopVy0v98YA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS6PR11MB362586.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(376014)(4143699003)(11063799006)(56012099006)(261022075727099003)(261009223027099003)(18002099003)(22082099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UIf8cG5dJnH1v6r1gjvNf2eL9mDGTm4MLPg8luSJSIwR2kQxGdV0LoCVDPJd?=
 =?us-ascii?Q?J99WIRFpmFWo/mR/OYxVhFLGP8Mg7SejQj3MlLK2D8rliHVdVyaP5ygHf9dK?=
 =?us-ascii?Q?D5FNL+hSPPnOfey9IrtIAMtZJPzKKxQ7Qr3azjcNp6qKH3Ghvgp3FjXJtXLn?=
 =?us-ascii?Q?qD7R71R1sh6zVAa3UfKUH1ljOifsabuy1Qtk3nQskqynqooyeVIC6Dui/csT?=
 =?us-ascii?Q?v5HzSIXGtfYq3GX+6RJr263oF8q2zPoORDF1Be4hxoQoWsbrR9Xlr6XQX0ZR?=
 =?us-ascii?Q?2IxbIPEgh3uX8iTymji/XTr8uqB4++lgxAztHQOPHtw5Q9LTr00qSgtP0pq9?=
 =?us-ascii?Q?g68qNaGHvyeCE7GHsKZaiXMm7uysuCF1YIFPstGcnLwnnlx/AJ8CzEkA2yuc?=
 =?us-ascii?Q?mJXZPdLVUrkyFkx21dWK/q29KYpDis25H8uSHSsUDrmoCRx6Do/5cXnPVGxH?=
 =?us-ascii?Q?HDb7nBkBbdw/t13hQ0igEZrl2+gLQB9Zjq/XULAzLGawEG9WVc6fLw4zZ8Lj?=
 =?us-ascii?Q?1JTDANJ63mKyYfQVNODQ+jnH6U+5Ba3CPup3UAvWPyp00i3JmpannSLe/5gi?=
 =?us-ascii?Q?FfdV0r3/AmzrJ+EzLEhGLqdBmUy5/SEcBa7wh7bPHkzT9tGLeDBiWPKJKeFR?=
 =?us-ascii?Q?9kKMMyOHqEPql7s8Q2HIn02xxlQgBqjqIi5GYvmqYda8xp2u4uYKEXIBxQCE?=
 =?us-ascii?Q?rIG0/HTLzMce+MiMbVPsMZSekVI5ghT0zLjpSOd5CQLazgbTkXdZRtCot27a?=
 =?us-ascii?Q?0EJFBZCt79q8BZRL8EkwQe5yxS6TD2HiS30wtGWxDyMQtcrO6pcW4ck/qwHj?=
 =?us-ascii?Q?JLtcZmaagaAOMHOlsvTpoMvyMNcsl4m7Y4Xv5xdzgq+3HFL8lHl/ru4bLnhk?=
 =?us-ascii?Q?PKbVZrfaObFAhbouc0rXKJ9fZ4rjnyDO+Fs3hWl4LRF+0C2iPluJADn0tBG2?=
 =?us-ascii?Q?hb2kkBZTS11KanBHzmEwzwVkuwsX7FqGcwVOtJz/N41OTEmuzr4gJdV/w0DH?=
 =?us-ascii?Q?nrUo6WxUtcWycpuoFi6Di3OEbHQOAFSsae1LgKPvrTpBjjl0y2GwBNjIODKJ?=
 =?us-ascii?Q?nXJwYNmqA58sxdrdn4uPtWNcEJW9tqVYQW2OIhNqlgak2zRLz67S1Ap7tpiD?=
 =?us-ascii?Q?tvfxbXtSdzA4/Ak/Z2b7vRBfPsQBV3CWqAXBHZVTo56cpgl2a6v/VCo6TR8s?=
 =?us-ascii?Q?0VDnfPZcauc6d3rMSc6sag3KjLPqUrmfRHuOiRgyH4ZYMWw4+3OuLldwtafx?=
 =?us-ascii?Q?5XcTlAeTaPXmjmsLHlhgNzkX9VvUEggt74qtDFQlKoqaSlbLPTKVjzOZ5hPn?=
 =?us-ascii?Q?keZ2E5VsJUccofYWqjjBGHwCN9JgVlWYoWuxCX6jm59tHS6NnbeNBpsp01kF?=
 =?us-ascii?Q?KLaOPXaIx2zdy/3sWzbQ2jWno5Pw3bnIfM52vHpYkZBtEOfvZvTxfQpM+ogu?=
 =?us-ascii?Q?uYB8GIxuYOz/VH4vwJp5l4y2C7LOX+mm9Du+psDeqjR+X/hzLkycUOLy671A?=
 =?us-ascii?Q?4kyjK/OVbSEDAGNWWcPjaOx5oskhtFL2w6rVBEUaQz3RFZ0nsUiH+skANrAB?=
 =?us-ascii?Q?wZxXOn00Qfy7zUcDHYzV2TcxhBuUYCW+VAE4cfUgaoPXRdhA6q8fS2VySQxi?=
 =?us-ascii?Q?Dqc5TalCorQLDSIRnV4FV1B3n684gJUOG5fwnZ2opk/MYx8iadc2PGG7afXE?=
 =?us-ascii?Q?1yNDn6vNZkDm9G0eBXNgdoyHx8BiZTDWy/ikUUa2Sdw4q6Y+4P4gbn6Qabl7?=
 =?us-ascii?Q?NJte/mqjmw=3D=3D?=
X-Exchange-RoutingPolicyChecked: dh47GA3mmTTWfVs1wnFTUHORyZRyem1tks15IUUy4b7hFxTGMKFZ0R0q+0VV3mX6KMXR/gDIuflrRnln1Sczkl79R790AlbbKpZU5rjWe04ho1Y1Dl+RK4zRIj3gu+4e6rf7vYQ2uMx5sm/ZPKj93k1+KE6CIkS22mZrnbtvD4sKjBuIJhjbS9EYUJIxWZA2tyMpUJW8udVoZbcvleTRXi/3bYvXHIR0T8hV8t0VA62fEZ3C3I7qaY+5nUOCj6l6HSpn7ZELW67rtvGt9hjbCUMucxNw/vxV/UzLfxT8KI2W65uYNul4k1zVXvStSWJknpDK3yG7IP2pRvmVbeh5xA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e6ecec2-4612-48bd-51b9-08df3bb9ee61
X-MS-Exchange-CrossTenant-AuthSource: DS6PR11MB362586.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2026 03:56:26.7385
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cZCa5PP6M7Y0Y4vLuFEnG/tB1i663ZW8VXLNV/yWRNsNfj85g152cj9bMX/NE0FaOqyc73EaJ2tqT7ACOLL/FQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH3PPFF1A08ABF9
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam06
X-Stat-Signature: 38yq6f9pqidh5dib46ch9xdbttbyinh3
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 8BB6B140004
X-Rspam-User: 
X-HE-Tag: 1793937396-640767
X-HE-Meta: U2FsdGVkX1+J3+lIlpfOFPFLCsJNu6XvXLzSHtUslnsLrj7t8whpAWHtbjh4AEByL15vm0PwQnd5bdkq9e3ulk2i7xo3FjkDFRMNc/tkevNRAnAMLqnEW4PWs8zWGg4HaCSb8OvES4DGVJMmHz9X+rQVbJbhGCPXfvIP7UAoOhnhsX9aKc1I0xhRSy+CZofBjVO4FBC+AK9hvE/wUa9uNfRQ8oYgg9XbbUYcCJYUhVTgqaj2LLnE8h+ICCRma6uUKYGXJH8X5Y5Q8HS4Fli7k9SaHuTabQhhPD7azcLSDB2xfAd67CxbQyM0OBSZtxMR9DRbfCcVGsRm50demdrYaefwlj81RTICxEhPqT8J5ax095m7kkfCNaYYyf+F0uEJVmjKsIibWklcFSZomvTzApHEe9LIO7+Gdr8XTFxHs69xFMjZQ5hhB9IcuAOCptM5+a53WuRyMoPpeVW0vhqMw1g/WnfYCIuQ768RuJO1YQ96dmNQC2K5fyhEUoXMMERyGD3mGz+fTPYGGD+MHFQkr3Mv/R6EWdbzBJNYZK4VjN7Csyt8h+wWzDmM/QbgLok786LxrxnKIC7yKpj/3pzoW2J5fZCZ6ajKwdTTaDxVDxOUAL3wfFetqElmuUi5dyiSKnryiW9QORd1aqsGSSzJ8ctqCflB850j/25UUwiqjx7R3zFcqe2Tn7V4eb+zuAbtfHi5I99ZAmIPi8BG3OgSsyLNi2fblZ1Mwp0IssA/la41FFPUs8NLfUgzzLM5lpU07n1Cxoc397nFxGNPn6bzxtMtTWdKAjIjbtu0sS6oKwOvkbpZGa/RQZO6hS/zG9brAcOoe30LLp04t8q3/pepNsaf8QPk0lwt/Bo8OF9wepCZmWYuCfcVrVv8ThhX/7Hj0ha2yvzOy0fz03HPYlVdW5CyjauuKpQ4L8TAbjU4TMEj31JPgj87dHwGLqiZz3HzZaGEa3ERL5gg97Qn/Dv
 Odqfq7dJ
 sY8+jVJR8SB4ut+1KhetP/vBmFR7xClOcNUM4eFvK0KzNNYAR3PS7xZ0KmwQfDXNcrLoFY1K0mEx45PyQO+pzrkDXVfMByONjWyFGIhu+JM3mEm3+/wwptao0BcrgvtZ7x6e7ozsj0aqL1VOg68W+LZ8iF3vqNwM2GmwWt17YfVQrkse6/SeCxgz96TloiL5/9hpKkI0ivYAnV26WH8RZHSleBzhKO0gUXAquFDn1fS8KyzMcb1UVeFKO5NFtg4NRv7xeWw5i2VpFZcFEpGqak86iO5Dw/5CuDWAQFOOT9vX5iAVLIrTymQtWH66KD/GFXEKbtofXc9/rEpMXpK0FQfp3bzrcX3uOu/zArdY0U1CLrTrFjv8o/kZzF9JFVf92d87YuqPSkf3dLBy7ASJsDYaqv7b8yvqhuUVhf8A/QX0h9NW1ibhISyCOQwxCpKEFYVnJ3zkJQsygGV+8g0zx6j3GTOAP9KPor7zOcgpPTzSymrwOyPAOxviU1RmpAh63JKf9XU2PhHvNjE2fwaRKq1sS+jXELhnfWv8V1zq86Cr3+l8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 07:05:59PM -0800, Andrew Morton wrote:
> On Fri, 06 Nov 2026 09:53:40 +0800 kernel test robot <lkp@intel.com> wrote:
> 
> > tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> > branch HEAD: dba8aba0a9a00ff781c03d82ae534fc6f8c2e263  riscv: mm: fix concurrency in mark_new_valid_map()
> > 
> > Error/Warning ids grouped by kconfigs:
> > 
> > recent_errors
> > `-- csky-allmodconfig
> >     `-- drivers-net-wireless-ath-ath11k-dbring.c:internal-compiler-error:in-final_scan_insn_1-at-final.cc
> > 
> 
> Thanks.
> 
> Am I being dumb here.  I can't find any error report other than this.

Sorry, kindly ignore this issue, it is "internal compiler error", thus there's no
public report for this. And I will config bot to avoid including such compiler issue
in the status report, that also wrongly judges the status as regression.

> 
> And I'm not going to lose much sleep about a CSKY gcc ICE in ath11k ;)
> 

