Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACADCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 07:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E501A6B008C; Thu, 14 May 2026 03:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E281A6B0092; Thu, 14 May 2026 03:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEF836B0093; Thu, 14 May 2026 03:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B968D6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:18:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CA761A0535
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:18:52 +0000 (UTC)
X-FDA: 84765173304.02.6FA5B62
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf02.hostedemail.com (Postfix) with ESMTP id 39A9480005
	for <linux-mm@kvack.org>; Thu, 14 May 2026 07:18:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=isK5iV9Y;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778743128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gtVqKdk925rNhgVjB9r1hC0J1OpcMbg7Qsuo7kJMqmg=;
	b=4zMhyAtz0rOilaenXzu0c5qBSzIFO74xw50X0OGLJ/R2DZQv9LXSDjh/YdDz1jsGA97fqF
	mXULJUbq4gC/A8Ee8ErL6H9vN42ipZX6EQg1Rokbz6nsw3338x6SKy256Wn7FT3cEW0RwG
	vOc3+JUommKaflDTixW5RzbAVMeWqgY=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778743128; a=rsa-sha256;
	cv=fail;
	b=PA39YlAk+Ot9GjOvfBgSS1UlNz681iMMsa0gkHdrzQKCbOA2FT0c0uylNUzQx/CDrwd+0x
	zQSP4iJ+bX6uSLTefYK0mv+cw6Lk/vi1Gaq3izn/dMRFZfoQn4jUiPIi8RakclJNZB3K96
	FjVBRW+iWQfKMs61NGVUXkVBzNfdc8o=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=isK5iV9Y;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf02.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1778743128; x=1810279128;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=iM+BTtG5aMTz+gFIwTbCvW34rtB8BRLu3yvM9F7OYRs=;
  b=isK5iV9YYPT9zBjN6FzNE5O4mIJF2gCEGWZaAG8xYG6F+Jajps89HU+F
   fMx4Z1T0tninBm+q1CXP3UEVQ9EN0rm/N5mPikMx9D7I5ILB8794LlmAz
   qc1AF1JAK/fRJueMXv4QX2mOgEIDjDme+vHZ3sD1EXso+9fgl73jVodNI
   OsTEwriiD+98IhipF7bNXmUQ16SDuMkr9jWc5TM4u4ne3iPaB+7+z3B+v
   1ya2KPM41t5NcuCCiGjKmrCvByNGCQd3Ihhad9r0Pf293DyVtyi1Z3+4y
   3CU1CD9MAcwFY2Cf0XK3EdeH9NZAIizBxbN7sdu4UxnU4H3wlrP/U7G+4
   g==;
X-CSE-ConnectionGUID: Gts6WhJLSNuGW+UUAIrXvw==
X-CSE-MsgGUID: 2zlitdlsTGudRs0qjhB/iA==
X-IronPort-AV: E=McAfee;i="6800,10657,11785"; a="90374127"
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="90374127"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 00:18:46 -0700
X-CSE-ConnectionGUID: 5SRKE1+gSDOXiFMEWOpQig==
X-CSE-MsgGUID: 2hB0o7bCT/KXbMHl7okpNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,234,1770624000"; 
   d="scan'208";a="276395495"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2026 00:18:46 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 00:18:45 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 14 May 2026 00:18:45 -0700
Received: from BN8PR05CU002.outbound.protection.outlook.com (52.101.57.10) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 14 May 2026 00:18:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vb3LPD7CrPbrYZE4/fcNtSXkgLnJL4VTYj1V5k82QS5nN/o6uF6J87dfpgzg7l1RseOzK6qTOYlLdl6VgnKOnNOwpZ67wwZD+Mth6/IAFezYdNbNOghOzXJ0QjVqXDl5GhDi9/16bthlYKsQDPZl2+k9FBo4V4+deYxm2i2JrNZFmB/NqFltALfC7atQnBEW42DdCoyC55KlCpcyrsihglLPQpc9GGevYHI3R9sjUyKSjM8PKqmlkR3XjUJtoY0mxuTFU01SytKE2tM6lzca3LrdYgDVvV178YINckxaS7e+sG/oI75Ss7t5/BUVUmx8+9CZkerb2/McwrrUjnSygw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dR7+0mQzy3q+zBvqSslKTPpSfJSj/uY9UrBcVH+GU9Q=;
 b=H0L4uoRTKMnA5uoV/7Cc28LyWjQTlsWfwOf+fwsYcQxWYaiIZFpboTMASx6/tzERrAffd/YpF8eCq8RhoaC7z8O0WIu+GfIR0yt6ncYfaZLwBibnkNX7I0DYjr4pHX1cr5rjD3hYbvufyfdIMWtP3sw+BujQTvNTA7P3vYcwi8xIptYYUjXH+t6cC++NNqzgGx7Xyc9OaNaH1vWOCjXQHKktbXTjT5j1vIDLVtGm5m9OMoFcspyyRySkE6g2F2zCpB+vhfNFKr4EM6wbzBo9FtQ5m825kEr6E8XPt25/53cH03EKzp22BCx9/DdWpbRheWUXucaDxCcih+EMpQVNbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by PH0PR11MB7633.namprd11.prod.outlook.com (2603:10b6:510:26c::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.22; Thu, 14 May
 2026 07:18:40 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9891.019; Thu, 14 May 2026
 07:18:40 +0000
Date: Thu, 14 May 2026 15:18:27 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: "Liam R. Howlett" <liam@infradead.org>
CC: "Liam R. Howlett" <Liam.Howlett@oracle.com>, <oe-lkp@lists.linux.dev>,
	<lkp@intel.com>, <linux-kernel@vger.kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Alice Ryhl <aliceryhl@google.com>, "Andrew
 Ballance" <andrewjballance@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Christian Kujau <lists@nerdbynature.de>, Geert Uytterhoeven
	<geert@linux-m68k.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Matthew Wilcox <willy@infradead.org>, SeongJae Park <sj@kernel.org>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
	<maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: Re: [linus:master] [maple_tree]  280b792cac:
 will-it-scale.per_process_ops 6.0% regression
Message-ID: <agV3Q2fBlQrB5v9w@xsang-OptiPlex-9020>
References: <202605131554.92e7df6b-lkp@intel.com>
 <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <22y6gvr7yzwdocwpd3wxrxfykmpvhbxytiiuht32db3dh7w522@pglkrpqognjk>
X-ClientProxiedBy: KUZPR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:d10:30::12) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|PH0PR11MB7633:EE_
X-MS-Office365-Filtering-Correlation-Id: 8176b763-56b9-43fa-29ef-08deb18905e2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003|11063799003|3023799003|4143699003;
X-Microsoft-Antispam-Message-Info: ObLhkKcAuEQxT/uAJK7IYNGCKi85qB1FjgDImNw8nnpB+lBOJzmXkZizZx2GCzfxeCev9eEP+xaC0NZu4bDXlDq39afWQhRkG7eI3IhJpoTJQFMHjm8075Bd58xGJnhqHzytdrATBA3pVnX8oku+q9UnIPI4GhNrQJGosYfqTgQJu/CvRfMvSmkBLSFlrDNq/wkYZhr2KcIykSGjxt856n7VexDnJx3UBElgDCUVRTUUCxi+Z/pV8lc4ugqZjztz+IMuUmmXQblM7VfysaWxH9AenP2Xi2yj3PvbwbCSJsbEi9SVAiz9mJIa+UiTpvmKoGiIPijSSyyjKCM4+cVD+BbhxDQ+BnwITluT8RqNiIq/zJ13O1DEXO9Fh3L+CAd5Qgxr8tq5w/Lyba5jC9KZjazHpf+pKs6zPOMGNrcP6vrOwlaFA8oFNBEQqxQCeg4NiG4gjGq4Iilf9pP3c3j3lC138ErM4XoFVQRqEf3lrVkLN4Yrw5LKFG+b83CfEmLhRtwnZ6DjYws4iE6P+NB3vZ8atLegSKV51pWdZOEFQvIa30xAFe7h6yMNC9YJMszdbjwFHEujAxpz3nYvoiECIPT1gmZ4kWL8prPzu9TjpEXyGu1TLtf8rnMpppv7fwn6g9uE8h4dx2nfL+uWHd/+Uw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003)(11063799003)(3023799003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?q9HkYFZ4PJHo5qaSTOAKupHr23fBQmhNQaXYJ4PtRbmheLv4LbWAJ7vD7o?=
 =?iso-8859-1?Q?RSSajruWIP4htKgyCMb9mG+bntkyImjp5sn1t+RDSKxGtYfpC4OvsqT78Y?=
 =?iso-8859-1?Q?Vi/YC/p4RiV4wyRdJJbjuPZFMdXc/bpf8UKL/b18eBzRogAsDes7M/7c56?=
 =?iso-8859-1?Q?mZ/1pUElVpnZ9bNrefVzP4KMees5fqY4QGD6y/M9Bn9jGPGQMATw1u2Nn8?=
 =?iso-8859-1?Q?nSJPjqogOaMA/t3g7DYY6nkAU0iKwhAiiLuil6I5LrxEHlk8pU0CMTeVCC?=
 =?iso-8859-1?Q?Nb+efFLJG/nVlMw23tPW1i32nX8O32DWkqJnKHQorkgF8Eq/Bychhmy/yE?=
 =?iso-8859-1?Q?B5f0LDw0phT6rh94SS55vvN5OoTs/DJRK2DIBgyJbXem35+F3Mvlnaur2E?=
 =?iso-8859-1?Q?a1Dn73uJb3Ua3gLKwJ0zRO8Ma+Rgz1ib9JpJ7aEOKz3wCrzwSa/HQRsRAd?=
 =?iso-8859-1?Q?l6U0C8BI5dXJ05J0yWPhz00BYRDUJZqIhJ89WRft7odK3acU8blCCSHwXD?=
 =?iso-8859-1?Q?oKOjDdAgWpasNcu4pVUTB3dGQ7btNG3cdUyIemX5dsyM0TTqOazdLL6Se9?=
 =?iso-8859-1?Q?Omhq4HbyHrQFk4rXji0TyknCxyrhaKyNiawGA5YxV3ElS6pHpXzfKAM0Qx?=
 =?iso-8859-1?Q?OnS3IzenPzavQEiQc3EquemncH3MkoW3ng4rny2rsr+9owQ1uhRfpF+5ss?=
 =?iso-8859-1?Q?HYjy71lBbYFNM32fFESoKTxWpdP/DM7k92cCfxkYpSRqZXUK28y5tAPjy/?=
 =?iso-8859-1?Q?wWWnuFs1Zum/GmNVk8iiKwA7dG2H/yAafEKzvG6dq+0yQxikROX/V/de7U?=
 =?iso-8859-1?Q?BI5fgbB0y4QmIg0G2Q540dtC6DlO+tSK+g4t4gn7DJiZ08tjC4jXVqow7W?=
 =?iso-8859-1?Q?3R3Pqs6U515bwh4F3Eh22HwQhUDf9+wgTmwKBLTXblmxh53IdV+HU4mPkr?=
 =?iso-8859-1?Q?HqgWA5GaBmzn9ee2PDQXTDS67Jcb3g4HQ0UsBIgDFAA+4qOx28w5exnqmd?=
 =?iso-8859-1?Q?t9Jmyt24jOWHoFwpRX4yE8yvMXBkUjxT9Cz6JvjWXS7aMLEdjTBu66YH4F?=
 =?iso-8859-1?Q?MTohuSRK/2uZmKEG5QNZht/Dbrt2EctztcgNmlic7qPnjbB7rv4zIwxZKu?=
 =?iso-8859-1?Q?1f6VSAe9pOkbjAUsOI4iFOA8vY8DQvH+hvmQkbFxK79HJBG5KhVFDBgOSG?=
 =?iso-8859-1?Q?Erq2SzmsBDcYO4PBzMEiLT2g2UPaFogkfOPs5mRJ4cvQIzkk434up1Gbz0?=
 =?iso-8859-1?Q?vQ2nJrwSQxpX9QEqWpIERv6PmvPoyq1bq+lSdxeqtHZsZRCUcnr/X0FoBa?=
 =?iso-8859-1?Q?Q1ovfMCZ5DWN5GGViy5NpMRs/nNkeyDNMMMf7DBWGosu9wJxCs2XXdktr6?=
 =?iso-8859-1?Q?iX+YfzBklnsCRgCm+ypipifMkRoNqXAeNWcShOj2tz1S6J/N0PtbOgj8BA?=
 =?iso-8859-1?Q?rNSjLNpaw58z5tS46vQREJDVCPqZxVSoXFP/aQWrt+kwQuBGsZuDGckwKa?=
 =?iso-8859-1?Q?oeT/lzV0Jbt/JX+WWu+WcU3Gk6a8q9l2CPzaSE3Za0FmbwnzJLwkUnpmkw?=
 =?iso-8859-1?Q?9WuV/cj04m6BRvROUZZZ4ODF/h48Hp5P9VlD0eDvXxVQ0c/+XknRM9Uy3T?=
 =?iso-8859-1?Q?G9QfPBMGfNZkzOQ3L74sEs4KJPc+0b6yL/1dt+rXktEGA1TjzhtJxscYrw?=
 =?iso-8859-1?Q?QXhe00ignFeLfESjcx6gNTUOLjunZw1pGVbMBhp3cyLha6LMG1grPVTrqv?=
 =?iso-8859-1?Q?YQAgIi4i6HI+rz57x5lRvH3V0zDMyfZQnryUk0gELCzBv4yxSQlzrNO37y?=
 =?iso-8859-1?Q?iqv55sGIuA=3D=3D?=
X-Exchange-RoutingPolicyChecked: YfZy/NkLDb2l+FE1dWx6KV2iy8a/vqAVR5y/R84dw+P+54Q008Z4mDmPti+5j8ig1zLClozjffh9ASL2GJCaGbppCY5yXlH33HUt1uCQlJOc/s0cc+op20/Wzc+TOVf3b1yZS03A2hv0eRznRC71a2uCPnOSayithrnRs0a25FUc4cPRxmcnGQOvhzHx/FEs3a/yIDZsgAa5bc7FoyY/mBpITkdE8OHhTXQGLR2W0lKAQCIV0j9kKv+wbdiHPWTOBTYcr+AaKbuxypfxttYcLdYHxTym8ZacdG/mfkDBACSNyuCeSPMQeSAcS5++lDAxo+7int2E0oBUmiUZxk7Q7A==
X-MS-Exchange-CrossTenant-Network-Message-Id: 8176b763-56b9-43fa-29ef-08deb18905e2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 May 2026 07:18:40.4393
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B/bEQEV1X0e92CZAS0rlGIhMM+zdzRKZ+GuHvaXRXy7Xt6wXyMp5NS3Zb6n7Z9q8HwT2Ws9miLYknReSSZLA0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7633
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39A9480005
X-Stat-Signature: gs7ugffzoebihi7jpnf5ussk4wdq9zxq
X-Rspam-User: 
X-HE-Tag: 1778743128-671747
X-HE-Meta: U2FsdGVkX1+bpyHAZi528K/crOzDO0DE/0fQNS0/K+wrhLXK3FDQmkgv1geCt0ca8aof/pGvvOgksc2/cxZtB/zl5g9MPFyqV8XOQm3PCSn1uIeO3/VcyzptqgXi9OUzrfPOZutL3LKIyW0Tzfd2Dvo5lXmc0eNsguv4eisT892EUF9ri7VzYgUY3+dg8wtCh1suUBtKc+cEn8ok4IIu6NEYzDz5wu4rCE3Mwk4ZbcKMyBhO3Y+RYKkI0zZH1AfumfJJy8RkEQ7lEG6ZjbxOGME3SBCp4pOoSuelXKHrPUhknTn07lrNiGFqxsakjWrMqwd2kdzq76Wd+sFqfR7ikgXwgAzebg7z3A9eFnSdz7VKLORquUwaGIEXKEjoyT71LVW91ODPW9ssWbGHUFIbny+pTt1ypFP46jhiaa8hjOguR0yai6PVZy6E1i9oYJaKJvbhTMVr7HRWlI/AE4/N5r9E6tPPgCHUc+3a/Crve4a+QOHlIDQKfwzmjEKgDczBTaHLx5x38jgFKWyf9uv7qQJEvNX9Ki37lqWpIDVlv+drLrZ7Wel0fPFRyptCacqOYVleAoFji7I1DVqtrKcmYyDKKtunmUEFinML9Jwi49dArlB962YI+n9fJOMPIaJjytn04s2dUqGaPg9YzmOQohpQGUJ0mvTFDXPXsXhsoqUbWJblIAxpyQDZo4asmuMRmuBdzl32LBFTURqA4TIP4pZ3nEYrE7ppLWuxaGj2FYHiry1ZhRido8/zs0aY/7+e4znWcM2yRZAMskiRl+NCxx/AyfDLAPWxWxxgEcSZOyxEMUcT1qCvwSMBKF37lT7hXs7hhhC3ZdEuUPcFU4XUaWctaMFz4ihGLufP5l+vCIbqG0K4qcxgmUZLoOgooVpEFGmTASL+dFUpNuIxGnDBhTN6qO/vrVYNysCuMDqq4BeFQzJVV3LV1xs8EX8c++DOqHtC+jneIKC31LdXQkK
 D1vFqe2z
 XFEiTjC2C7veZ0UG4fPbF0+SoTKMNNgwFdt8GLMoHSWMTAfHyqvvtngN8vtVa8a4597d3J66CE/YsJfeChXtUrYyA+fF0YYr/LL8wESJHmTGHmFRyxLpLh2/0GplwU+zpWN67voW9ZRX9dY3/JDhcW1GeOBBnm/t+pPRrABby26MC+wDBJZALKS0lh18KMqaJPtmmdKUGf6lmM35/Jwav5jEjmGq2+XXhPaV0Cs8WdSWl0kHK4L5mHKvUJ6BPyJ4X5xWR+zuxlqK/SwQwgOOMtJIyRK2VdvMRr/C3hEwsezUgllpmNPUGg0WPtQ3m9KJp5QuB1MAVZi96ly5t5jfWdpKnSnwidhI3q1SsnqtLsT576Volz15kqGQv7jyp589tNcL8tetEnJmElQK65TmVZc+nf5H8J7b/W1OaiafiFvhMh7/d2tGAjJLHvZFcCD2oan+/E5+LQEJe6XSMBzN0j1RhW1Sinvw4jJdRVvkJ0DH5dnOL4AZvzuWGUYhXjWh47sFSoMdquZLhIV59Eznd8Aru0p92Ekr/RIIIDirM1+9b+RKleWWAXi+HyHLAnMda7c9N19xshN3VdkvDVr7PWVTu3WPZAYvZOf7GNP5f4Q33j7wiVpsSpdW5y+k2/UGrlgA5GI/+0Oa0SChcxjQN1XPGAEy9qNTnmv4811RO0aSJ8+riyO7tOd8gcHAQONcgAGj7VnC/QwUu9G28aHQULax6kFbuIznfwDi7zEfbEiP2dK9lC5ClYzQubWExh++uvzMp2mipdfccpCArMdoudFBPpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hi, Liam,

On Wed, May 13, 2026 at 08:16:42PM -0400, Liam R. Howlett wrote:
> On 26/05/13 03:40PM, kernel test robot wrote:
> > 
> > 
> > Hello,
> > 
> > kernel test robot noticed a 6.0% regression of will-it-scale.per_process_ops on:
> > 
> > 
> > commit: 280b792cac62ddadca2935766ca870b438c86323 ("maple_tree: use maple copy node for mas_wr_split()")
> > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > 
> > [still regression on linus/master      5d6919055dec134de3c40167a490f33c74c12581]
> > [still regression on linux-next/master e98d21c170b01ddef366f023bbfcf6b31509fa83]
> > 
> > testcase: will-it-scale
> > config: x86_64-rhel-9.4
> > compiler: gcc-14
> > test machine: 48 threads 2 sockets Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz (Ivy Bridge-EP) with 64G memory
> > parameters:
> > 
> > 	nr_task: 100%
> > 	mode: process
> > 	test: mmap2
> > 	cpufreq_governor: performance
> > 
> > 
> 
> Thank you for the report.
> 
> 48 threads on a 2 socket E5-2697 v2 looks to be 12 cores (24 threads)
> per cpu (so x2), or exactly one mmap2 process per hyperthread.

this is the cpu information:

Architecture:        x86_64
CPU op-mode(s):      32-bit, 64-bit
Byte Order:          Little Endian
Address sizes:       46 bits physical, 48 bits virtual
CPU(s):              48
On-line CPU(s) list: 0-47
Thread(s) per core:  2
Core(s) per socket:  12
Socket(s):           2
NUMA node(s):        2
Vendor ID:           GenuineIntel
CPU family:          6
Model:               62
Model name:          Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz
Stepping:            4

> 
> Is this across all process counts and peaks at 48, or just 48?

just 48. the run script is in
https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com/repro-script

cd /lkp/benchmarks/will-it-scale
python3 ./runtest.py mmap2 295 process 0 0 48

> Is this across many runs?

we run 6 times for both parent and this commit, the data looks stable

11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json:  "will-it-scale.per_process_ops": [
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143595,
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143474,
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    144104,
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    142796,
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143081,
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-    143623
11e7f22f5e85058b09ca90e74002a3b82f50e940/matrix.json-  ],


280b792cac62ddadca2935766ca870b438c86323/matrix.json:  "will-it-scale.per_process_ops": [
280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134451,
280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135089,
280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135080,
280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135039,
280b792cac62ddadca2935766ca870b438c86323/matrix.json-    134082,
280b792cac62ddadca2935766ca870b438c86323/matrix.json-    135301
280b792cac62ddadca2935766ca870b438c86323/matrix.json-  ],


> 
> My testing didn't produce anything like this.  I'll have a look into
> this when I can, but there isn't anything obvious that sticks out as a
> likely cause.

if you want us to test any debug patch, it will be our great pleasure. thanks!

> 
> Thanks,
> Liam
> 
> 
> > 
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > | Closes: https://lore.kernel.org/oe-lkp/202605131554.92e7df6b-lkp@intel.com
> > 
> > 
> > Details are as below:
> > -------------------------------------------------------------------------------------------------->
> > 
> > 
> > The kernel config and materials to reproduce are available at:
> > https://download.01.org/0day-ci/archive/20260513/202605131554.92e7df6b-lkp@intel.com
> > 
> > =========================================================================================
> > compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
> >   gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-ivb-2ep2/mmap2/will-it-scale
> > 
> > commit: 
> >   11e7f22f5e ("maple_tree: add cp_converged() helper")
> >   280b792cac ("maple_tree: use maple copy node for mas_wr_split()")
> > 
> > 11e7f22f5e85058b 280b792cac62ddadca2935766ca 
> > ---------------- --------------------------- 
> >          %stddev     %change         %stddev
> >              \          |                \  
> >    6885401            -6.0%    6472359        will-it-scale.48.processes
> >     143445            -6.0%     134840        will-it-scale.per_process_ops
> >    6885401            -6.0%    6472359        will-it-scale.workload
> >      14.44            -1.0       13.42        mpstat.cpu.all.usr%
> >      17.55            -4.9%      16.69        turbostat.RAMWatt
> >       4812 ±  4%     -11.4%       4266 ±  4%  vmstat.system.cs
> >      17354 ±  3%      -9.2%      15750 ±  3%  sched_debug.cpu.nr_switches.avg
> >      10034 ± 11%     -25.7%       7451 ± 16%  sched_debug.cpu.nr_switches.min
> >     674817            -2.6%     657530        proc-vmstat.nr_active_anon
> >    1446441            -1.2%    1429254        proc-vmstat.nr_file_pages
> >     505185            -3.4%     487999        proc-vmstat.nr_shmem
> >      50084            -3.1%      48542        proc-vmstat.nr_slab_unreclaimable
> >     674817            -2.6%     657530        proc-vmstat.nr_zone_active_anon
> >       0.37 ±  2%      -6.8%       0.35        perf-stat.i.MPKI
> >   76468991            -1.9%   74991763        perf-stat.i.branch-misses
> >      20.62 ±  2%      -2.6       18.02 ±  2%  perf-stat.i.cache-miss-rate%
> >   34114286 ±  2%      -7.8%   31452733        perf-stat.i.cache-misses
> >  1.675e+08            +6.0%  1.775e+08        perf-stat.i.cache-references
> >       4800 ±  4%     -11.4%       4254 ±  4%  perf-stat.i.context-switches
> >       1.55            +0.9%       1.57        perf-stat.i.cpi
> >       4185 ±  2%      +8.3%       4534        perf-stat.i.cycles-between-cache-misses
> >  9.151e+10            -1.0%  9.063e+10        perf-stat.i.instructions
> >       0.37 ±  2%      -6.9%       0.35        perf-stat.overall.MPKI
> >       0.39            -0.0        0.39        perf-stat.overall.branch-miss-rate%
> >      20.35 ±  2%      -2.6       17.70 ±  2%  perf-stat.overall.cache-miss-rate%
> >       1.55            +0.9%       1.57        perf-stat.overall.cpi
> >       4163 ±  2%      +8.4%       4514        perf-stat.overall.cycles-between-cache-misses
> >    4010019            +5.4%    4225135        perf-stat.overall.path-length
> >   76161250            -1.9%   74678157        perf-stat.ps.branch-misses
> >   34001097 ±  2%      -7.8%   31340807        perf-stat.ps.cache-misses
> >  1.671e+08            +6.0%  1.771e+08        perf-stat.ps.cache-references
> >       4780 ±  4%     -11.4%       4233 ±  4%  perf-stat.ps.context-switches
> >   9.12e+10            -1.0%  9.033e+10        perf-stat.ps.instructions
> >      19.40            -0.9       18.54        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
> >      15.57            -0.8       14.77        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       8.86            -0.5        8.39 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >      12.99            -0.5       12.52        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >       8.50            -0.5        8.05 ±  2%  perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_region.do_mmap.vm_mmap_pgoff
> >       7.73            -0.4        7.32        perf-profile.calltrace.cycles-pp.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
> >       8.46            -0.4        8.06        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
> >       3.94            -0.4        3.56        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
> >       6.70            -0.4        6.33        perf-profile.calltrace.cycles-pp.zap_pmd_range.unmap_page_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
> >       6.08            -0.4        5.71        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
> >      55.07            -0.4       54.71        perf-profile.calltrace.cycles-pp.__mmap
> >       3.59            -0.3        3.25        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
> >       3.72            -0.3        3.40        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__mmap
> >       3.09            -0.3        2.79        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
> >       4.14            -0.3        3.86        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
> >       3.54            -0.3        3.27        perf-profile.calltrace.cycles-pp.entry_SYSRETQ_unsafe_stack.__munmap
> >       3.22 ±  2%      -0.3        2.96 ±  2%  perf-profile.calltrace.cycles-pp.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
> >       1.57            -0.2        1.37        perf-profile.calltrace.cycles-pp.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >       4.98            -0.2        4.81        perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
> >       0.88            -0.2        0.71        perf-profile.calltrace.cycles-pp.mas_walk.mas_find.__mmap_region.do_mmap.vm_mmap_pgoff
> >       3.78            -0.1        3.66        perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       1.82 ±  2%      -0.1        1.72 ±  2%  perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       0.65            -0.1        0.56        perf-profile.calltrace.cycles-pp.memcpy_orig.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
> >       1.53            -0.1        1.45        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__munmap
> >       1.38            -0.1        1.30        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
> >       0.65            -0.1        0.58        perf-profile.calltrace.cycles-pp.vma_merge_new_range.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >       1.46            -0.1        1.41        perf-profile.calltrace.cycles-pp.syscall_return_via_sysret.__mmap
> >       0.97 ±  2%      -0.1        0.91        perf-profile.calltrace.cycles-pp.atime_needs_update.touch_atime.shmem_mmap_prepare.__mmap_region.do_mmap
> >       1.36            -0.0        1.31        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
> >       0.76            -0.0        0.72        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       0.69            -0.0        0.66        perf-profile.calltrace.cycles-pp.__filemap_get_folio_mpol.freader_get_folio.freader_fetch.__build_id_parse.perf_event_mmap_event
> >       0.56            -0.0        0.53 ±  2%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_safe_stack.__mmap
> >       0.78 ±  2%      +0.0        0.83        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
> >       0.72            +0.1        0.80        perf-profile.calltrace.cycles-pp.vma_link_file.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
> >       1.24            +0.1        1.32        perf-profile.calltrace.cycles-pp.unlink_file_vma_batch_final.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
> >       1.38            +0.1        1.48        perf-profile.calltrace.cycles-pp.mas_find.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
> >       2.39            +0.2        2.55        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
> >      45.68            +0.2       45.93        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
> >      45.52            +0.3       45.78        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
> >       0.82            +0.3        1.09        perf-profile.calltrace.cycles-pp.mas_wr_store_type.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       1.59            +0.3        1.89        perf-profile.calltrace.cycles-pp.mas_rev_awalk.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
> >      44.54            +0.4       44.94        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
> >       7.12            +0.4        7.56        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
> >       6.68            +0.5        7.16        perf-profile.calltrace.cycles-pp.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >      42.98            +0.5       43.52        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
> >      41.67            +0.6       42.29        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >       5.47            +0.6        6.10        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap.vm_mmap_pgoff
> >       0.00            +0.6        0.64 ±  8%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
> >      32.58            +0.7       33.24        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
> >       0.56 ±  2%      +0.7        1.27        perf-profile.calltrace.cycles-pp.mas_prev_slot.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area
> >      34.16            +0.7       34.89        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
> >       4.48            +0.7        5.20        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area.do_mmap
> >       0.00            +0.7        0.73        perf-profile.calltrace.cycles-pp.mas_prev_node.mas_prev_slot.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown
> >       4.32            +0.7        5.07        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.shmem_get_unmapped_area.__get_unmapped_area
> >       0.00            +0.8        0.75        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.__mmap_region.do_mmap.vm_mmap_pgoff
> >      34.96            +0.8       35.72        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
> >      35.97            +0.8       36.73        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
> >      35.80            +0.8       36.57        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
> >       0.00            +0.8        0.79        perf-profile.calltrace.cycles-pp.mas_next_node.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap
> >       0.79            +0.8        1.58        perf-profile.calltrace.cycles-pp.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       0.00            +0.8        0.80 ±  2%  perf-profile.calltrace.cycles-pp.mas_prev_node.mas_prev_slot.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
> >       0.00            +0.8        0.80        perf-profile.calltrace.cycles-pp.mas_prev_slot.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >      35.04            +0.8       35.85        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
> >       0.00            +0.8        0.81 ±  7%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
> >       0.97            +0.8        1.80        perf-profile.calltrace.cycles-pp.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
> >       0.73            +0.8        1.56        perf-profile.calltrace.cycles-pp.mas_next_slot.mas_find.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
> >       0.00            +0.9        0.95 ±  7%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region
> >       0.00            +1.1        1.09        perf-profile.calltrace.cycles-pp.mas_next_slot.__mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
> >       5.22            +1.5        6.75        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
> >       0.00            +1.5        1.55 ±  5%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma.__mmap_region.do_mmap
> >      19.61            -0.8       18.76        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
> >      15.58            -0.8       14.79        perf-profile.children.cycles-pp.unmap_region
> >       8.68            -0.8        7.93        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
> >       8.88            -0.5        8.40 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap
> >      13.03            -0.5       12.57        perf-profile.children.cycles-pp.__mmap_new_vma
> >       8.56            -0.5        8.11 ±  2%  perf-profile.children.cycles-pp.perf_event_mmap_event
> >       1.40            -0.4        0.98        perf-profile.children.cycles-pp.memcpy_orig
> >       7.75            -0.4        7.34        perf-profile.children.cycles-pp.unmap_page_range
> >       8.08            -0.4        7.67        perf-profile.children.cycles-pp.mas_wr_node_store
> >       8.48            -0.4        8.07        perf-profile.children.cycles-pp.unmap_vmas
> >       3.96            -0.4        3.58        perf-profile.children.cycles-pp.free_pgd_range
> >       6.72            -0.4        6.35        perf-profile.children.cycles-pp.zap_pmd_range
> >       6.16            -0.4        5.80        perf-profile.children.cycles-pp.free_pgtables
> >       3.61            -0.3        3.26        perf-profile.children.cycles-pp.free_p4d_range
> >       3.10            -0.3        2.80        perf-profile.children.cycles-pp.free_pud_range
> >      54.52            -0.3       54.23        perf-profile.children.cycles-pp.__mmap
> >       3.24 ±  2%      -0.3        2.98 ±  2%  perf-profile.children.cycles-pp.mas_preallocate
> >       5.28            -0.2        5.06        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
> >       2.34            -0.2        2.13        perf-profile.children.cycles-pp.mas_walk
> >       5.00            -0.2        4.82        perf-profile.children.cycles-pp.mas_store_prealloc
> >       3.46            -0.2        3.31        perf-profile.children.cycles-pp.entry_SYSCALL_64
> >       3.06            -0.1        2.92        perf-profile.children.cycles-pp.syscall_return_via_sysret
> >       1.95 ±  2%      -0.1        1.84        perf-profile.children.cycles-pp.__pcs_replace_empty_main
> >       0.30 ±  3%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.mas_prev_setup
> >       1.83 ±  2%      -0.1        1.74        perf-profile.children.cycles-pp.kmem_cache_free
> >       1.40            -0.1        1.32        perf-profile.children.cycles-pp.__refill_objects_node
> >       0.70            -0.1        0.62        perf-profile.children.cycles-pp.vma_merge_new_range
> >       0.27 ±  2%      -0.1        0.20 ±  3%  perf-profile.children.cycles-pp.unlink_file_vma_batch_add
> >       0.57 ±  3%      -0.1        0.50 ±  3%  perf-profile.children.cycles-pp.mas_prev
> >       0.23 ±  2%      -0.1        0.17 ±  4%  perf-profile.children.cycles-pp.mas_prev_range
> >       0.38 ±  8%      -0.1        0.32 ±  3%  perf-profile.children.cycles-pp.strlen
> >       0.43 ±  2%      -0.1        0.37        perf-profile.children.cycles-pp.fput
> >       0.68 ±  2%      -0.1        0.62 ±  2%  perf-profile.children.cycles-pp.copy_from_kernel_nofault
> >       0.62            -0.1        0.57 ±  2%  perf-profile.children.cycles-pp.__vma_start_exclude_readers
> >       0.76 ±  2%      -0.0        0.71 ±  2%  perf-profile.children.cycles-pp.prepend_copy
> >       0.79            -0.0        0.74 ±  4%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
> >       0.99 ±  2%      -0.0        0.95 ±  2%  perf-profile.children.cycles-pp.atime_needs_update
> >       1.12            -0.0        1.07 ±  2%  perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
> >       0.36 ±  2%      -0.0        0.32 ±  2%  perf-profile.children.cycles-pp.security_mmap_file
> >       0.38 ±  2%      -0.0        0.34        perf-profile.children.cycles-pp.arch_exit_to_user_mode_prepare
> >       0.19 ±  3%      -0.0        0.16 ±  4%  perf-profile.children.cycles-pp.__x64_sys_mmap
> >       0.63            -0.0        0.60        perf-profile.children.cycles-pp.up_write
> >       0.39            -0.0        0.36        perf-profile.children.cycles-pp.mas_wr_store_entry
> >       0.11 ±  4%      -0.0        0.08        perf-profile.children.cycles-pp.get_align_mask
> >       0.24 ±  3%      -0.0        0.22 ±  4%  perf-profile.children.cycles-pp.copy_from_kernel_nofault_allowed
> >       0.40            -0.0        0.38 ±  2%  perf-profile.children.cycles-pp.mas_next_range
> >       0.30 ±  2%      -0.0        0.28 ±  3%  perf-profile.children.cycles-pp.can_vma_merge_right
> >       0.32 ±  3%      -0.0        0.30 ±  3%  perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
> >       0.33 ±  2%      -0.0        0.31        perf-profile.children.cycles-pp.unmap_single_vma
> >       0.21 ±  3%      -0.0        0.19 ±  2%  perf-profile.children.cycles-pp.mmap_action_complete
> >       0.34            -0.0        0.33 ±  2%  perf-profile.children.cycles-pp.tlb_gather_mmu
> >       0.33            -0.0        0.32        perf-profile.children.cycles-pp.tlb_finish_mmu
> >       0.09 ±  5%      -0.0        0.07 ±  6%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
> >       0.14 ±  3%      -0.0        0.12 ±  3%  perf-profile.children.cycles-pp.get_mmap_base
> >       0.06            -0.0        0.05        perf-profile.children.cycles-pp.barn_get_empty_sheaf
> >       0.06            -0.0        0.05        perf-profile.children.cycles-pp.rcu_cblist_dequeue
> >       0.08            +0.0        0.09        perf-profile.children.cycles-pp.mas_nomem
> >       0.06            +0.0        0.07 ±  5%  perf-profile.children.cycles-pp.unlink_file_vma_batch_init
> >       0.31            +0.0        0.32 ±  2%  perf-profile.children.cycles-pp.userfaultfd_unmap_complete
> >       0.13 ±  3%      +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.vm_area_free
> >       0.11            +0.0        0.13 ±  3%  perf-profile.children.cycles-pp.build_id_parse_nofault
> >       0.14 ±  5%      +0.0        0.16 ±  3%  perf-profile.children.cycles-pp.userfaultfd_unmap_prep
> >       0.48            +0.0        0.50        perf-profile.children.cycles-pp.hrtimer_interrupt
> >       0.20 ±  3%      +0.0        0.22 ±  3%  perf-profile.children.cycles-pp.is_vmalloc_addr
> >       0.46 ±  2%      +0.0        0.48        perf-profile.children.cycles-pp.filemap_get_entry
> >       0.08 ±  4%      +0.0        0.11 ±  4%  perf-profile.children.cycles-pp.vma_wants_writenotify
> >       0.13 ±  7%      +0.0        0.16 ±  2%  perf-profile.children.cycles-pp.mmap_region
> >       0.11 ±  4%      +0.0        0.14 ±  5%  perf-profile.children.cycles-pp.mas_next_setup
> >       0.27 ±  3%      +0.0        0.31 ±  4%  perf-profile.children.cycles-pp.__thp_vma_allowable_orders
> >       0.31 ±  3%      +0.0        0.35 ±  3%  perf-profile.children.cycles-pp.__x86_indirect_thunk_rax
> >       0.13 ±  3%      +0.0        0.18 ±  4%  perf-profile.children.cycles-pp.rb_next
> >       0.08 ±  6%      +0.1        0.14 ±  3%  perf-profile.children.cycles-pp.ksm_vma_flags
> >       0.47 ±  3%      +0.1        0.53 ±  3%  perf-profile.children.cycles-pp.down_write
> >       0.35 ±  3%      +0.1        0.42 ±  3%  perf-profile.children.cycles-pp.vma_interval_tree_remove
> >       0.74            +0.1        0.82        perf-profile.children.cycles-pp.vma_link_file
> >       1.24            +0.1        1.33        perf-profile.children.cycles-pp.unlink_file_vma_batch_final
> >       2.44            +0.1        2.58        perf-profile.children.cycles-pp.mas_empty_area_rev
> >       0.66 ±  5%      +0.2        0.89        perf-profile.children.cycles-pp.mas_wr_walk_descend
> >       1.62            +0.3        1.90        perf-profile.children.cycles-pp.mas_rev_awalk
> >       1.71            +0.3        2.04        perf-profile.children.cycles-pp.mas_wr_store_type
> >      44.55            +0.4       44.96        perf-profile.children.cycles-pp.ksys_mmap_pgoff
> >       7.13            +0.4        7.56        perf-profile.children.cycles-pp.__get_unmapped_area
> >       6.69            +0.5        7.17        perf-profile.children.cycles-pp.shmem_get_unmapped_area
> >      43.01            +0.5       43.55        perf-profile.children.cycles-pp.vm_mmap_pgoff
> >       5.53            +0.6        6.14        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
> >      41.71            +0.6       42.34        perf-profile.children.cycles-pp.do_mmap
> >      32.60            +0.7       33.26        perf-profile.children.cycles-pp.do_vmi_align_munmap
> >       5.05            +0.7        5.75        perf-profile.children.cycles-pp.mas_find
> >      34.19            +0.7       34.90        perf-profile.children.cycles-pp.do_vmi_munmap
> >       4.49            +0.7        5.21        perf-profile.children.cycles-pp.vm_unmapped_area
> >       4.34            +0.7        5.09        perf-profile.children.cycles-pp.unmapped_area_topdown
> >      34.99            +0.8       35.74        perf-profile.children.cycles-pp.__vm_munmap
> >      35.06            +0.8       35.87        perf-profile.children.cycles-pp.__x64_sys_munmap
> >       0.00            +1.0        0.99        perf-profile.children.cycles-pp.mas_ascend
> >      81.44            +1.0       82.44        perf-profile.children.cycles-pp.do_syscall_64
> >      81.77            +1.0       82.79        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
> >       5.30            +1.5        6.82        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
> >       0.00            +1.6        1.58        perf-profile.children.cycles-pp.mas_next_node
> >       1.84            +1.6        3.48        perf-profile.children.cycles-pp.mas_next_slot
> >       1.75            +2.0        3.72        perf-profile.children.cycles-pp.mas_prev_slot
> >       0.00            +2.0        2.01        perf-profile.children.cycles-pp.mas_prev_node
> >       8.62            -0.8        7.87        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
> >       1.32            -0.4        0.91        perf-profile.self.cycles-pp.memcpy_orig
> >       4.40            -0.3        4.09        perf-profile.self.cycles-pp.zap_pmd_range
> >       2.96            -0.3        2.68        perf-profile.self.cycles-pp.free_pud_range
> >       2.19            -0.2        1.99        perf-profile.self.cycles-pp.mas_walk
> >       3.05            -0.2        2.89        perf-profile.self.cycles-pp.syscall_return_via_sysret
> >       3.07            -0.1        2.94        perf-profile.self.cycles-pp.entry_SYSCALL_64
> >       0.38 ±  7%      -0.1        0.27 ±  3%  perf-profile.self.cycles-pp.current_time
> >       0.62            -0.1        0.52        perf-profile.self.cycles-pp.do_vmi_align_munmap
> >       0.80            -0.1        0.71 ±  5%  perf-profile.self.cycles-pp.do_syscall_64
> >       0.25 ±  3%      -0.1        0.17 ±  4%  perf-profile.self.cycles-pp.mas_prev_setup
> >       0.76 ±  5%      -0.1        0.68 ±  3%  perf-profile.self.cycles-pp.perf_event_mmap_event
> >       0.24            -0.1        0.17 ±  2%  perf-profile.self.cycles-pp.unlink_file_vma_batch_add
> >       0.52 ±  6%      -0.1        0.46 ±  6%  perf-profile.self.cycles-pp.kmem_cache_free
> >       0.80            -0.1        0.73 ±  2%  perf-profile.self.cycles-pp.arch_get_unmapped_area_topdown
> >       0.73            -0.1        0.66        perf-profile.self.cycles-pp.__mmap_new_vma
> >       0.36 ±  8%      -0.1        0.30 ±  3%  perf-profile.self.cycles-pp.strlen
> >       0.40 ±  2%      -0.1        0.34        perf-profile.self.cycles-pp.fput
> >       1.03            -0.1        0.98        perf-profile.self.cycles-pp.__refill_objects_node
> >       0.36 ±  2%      -0.1        0.30 ±  2%  perf-profile.self.cycles-pp.vm_mmap_pgoff
> >       0.68 ±  3%      -0.1        0.62 ±  3%  perf-profile.self.cycles-pp.unmapped_area_topdown
> >       0.77 ±  2%      -0.1        0.71 ±  4%  perf-profile.self.cycles-pp.__kmem_cache_free_bulk
> >       0.34            -0.1        0.29        perf-profile.self.cycles-pp.__build_id_parse
> >       0.53            -0.0        0.48        perf-profile.self.cycles-pp.__vma_start_exclude_readers
> >       0.64 ±  2%      -0.0        0.59        perf-profile.self.cycles-pp.ksys_mmap_pgoff
> >       0.28 ±  2%      -0.0        0.23        perf-profile.self.cycles-pp.mas_next_range
> >       0.30 ±  3%      -0.0        0.26 ±  6%  perf-profile.self.cycles-pp.vma_merge_new_range
> >       0.24            -0.0        0.20 ±  3%  perf-profile.self.cycles-pp.__filemap_get_folio_mpol
> >       0.60            -0.0        0.56        perf-profile.self.cycles-pp.mas_preallocate
> >       0.64            -0.0        0.60 ±  5%  perf-profile.self.cycles-pp.__kfree_rcu_sheaf
> >       0.71 ±  2%      -0.0        0.67 ±  2%  perf-profile.self.cycles-pp.mas_empty_area_rev
> >       0.37 ±  2%      -0.0        0.34        perf-profile.self.cycles-pp.arch_exit_to_user_mode_prepare
> >       0.18 ±  4%      -0.0        0.15 ±  4%  perf-profile.self.cycles-pp.do_vmi_munmap
> >       0.33 ±  3%      -0.0        0.30 ±  2%  perf-profile.self.cycles-pp.free_pgd_range
> >       0.25 ±  3%      -0.0        0.22 ±  3%  perf-profile.self.cycles-pp.__get_unmapped_area
> >       0.10 ±  3%      -0.0        0.07        perf-profile.self.cycles-pp.get_align_mask
> >       0.16 ±  4%      -0.0        0.13 ±  4%  perf-profile.self.cycles-pp.security_mmap_file
> >       0.34 ±  2%      -0.0        0.32        perf-profile.self.cycles-pp.mas_wr_store_entry
> >       0.59 ±  2%      -0.0        0.56        perf-profile.self.cycles-pp.up_write
> >       0.32 ±  3%      -0.0        0.30 ±  3%  perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
> >       0.30 ±  2%      -0.0        0.28        perf-profile.self.cycles-pp.perf_event_mmap
> >       0.21 ±  3%      -0.0        0.19 ±  4%  perf-profile.self.cycles-pp.copy_from_kernel_nofault_allowed
> >       0.18 ±  2%      -0.0        0.16 ±  3%  perf-profile.self.cycles-pp.mmap_action_complete
> >       0.12 ±  3%      -0.0        0.10 ±  3%  perf-profile.self.cycles-pp.khugepaged_enter_vma
> >       0.30            -0.0        0.28 ±  2%  perf-profile.self.cycles-pp.unmap_vmas
> >       0.15 ±  4%      -0.0        0.13 ±  3%  perf-profile.self.cycles-pp.__vm_enough_memory
> >       0.06            -0.0        0.04 ± 44%  perf-profile.self.cycles-pp.rcu_cblist_dequeue
> >       0.18 ±  3%      -0.0        0.16 ±  4%  perf-profile.self.cycles-pp.unmap_single_vma
> >       0.31            -0.0        0.29        perf-profile.self.cycles-pp.tlb_finish_mmu
> >       0.11 ±  3%      -0.0        0.09 ±  5%  perf-profile.self.cycles-pp.vm_unmapped_area
> >       0.33            -0.0        0.31 ±  2%  perf-profile.self.cycles-pp.tlb_gather_mmu
> >       0.14 ±  3%      -0.0        0.12 ±  5%  perf-profile.self.cycles-pp.__x64_sys_mmap
> >       0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_nomem
> >       0.05            +0.0        0.06 ±  6%  perf-profile.self.cycles-pp.unlink_file_vma_batch_init
> >       0.06            +0.0        0.07 ±  5%  perf-profile.self.cycles-pp.__pi_memcpy
> >       0.28            +0.0        0.30 ±  2%  perf-profile.self.cycles-pp.userfaultfd_unmap_complete
> >       0.12 ±  5%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.userfaultfd_unmap_prep
> >       0.15 ±  6%      +0.0        0.17 ±  2%  perf-profile.self.cycles-pp.freader_get_folio
> >       0.23 ±  2%      +0.0        0.25        perf-profile.self.cycles-pp.filemap_get_entry
> >       0.19 ±  2%      +0.0        0.22 ±  4%  perf-profile.self.cycles-pp.remove_vma
> >       0.24 ±  2%      +0.0        0.26        perf-profile.self.cycles-pp.vma_link_file
> >       0.07 ±  6%      +0.0        0.10 ±  5%  perf-profile.self.cycles-pp.vma_wants_writenotify
> >       0.12 ±  8%      +0.0        0.14 ±  3%  perf-profile.self.cycles-pp.mmap_region
> >       0.23 ±  4%      +0.0        0.26 ±  2%  perf-profile.self.cycles-pp.vma_interval_tree_remove
> >       0.10 ±  4%      +0.0        0.13 ±  2%  perf-profile.self.cycles-pp.mas_next_setup
> >       0.26 ±  2%      +0.0        0.29 ±  4%  perf-profile.self.cycles-pp.__thp_vma_allowable_orders
> >       0.11 ±  3%      +0.0        0.15 ±  6%  perf-profile.self.cycles-pp.rb_next
> >       0.27            +0.0        0.30        perf-profile.self.cycles-pp.freader_fetch
> >       0.29 ±  3%      +0.0        0.33 ±  4%  perf-profile.self.cycles-pp.__x86_indirect_thunk_rax
> >       0.45 ±  2%      +0.0        0.49 ±  4%  perf-profile.self.cycles-pp.down_write_killable
> >       0.33 ±  2%      +0.0        0.38 ±  3%  perf-profile.self.cycles-pp.__vma_start_write
> >       1.55            +0.1        1.60        perf-profile.self.cycles-pp.mas_store_gfp
> >       0.07 ±  7%      +0.1        0.12 ±  5%  perf-profile.self.cycles-pp.ksm_vma_flags
> >       0.26            +0.1        0.32        perf-profile.self.cycles-pp.shmem_mmap_prepare
> >       0.44 ±  4%      +0.1        0.50 ±  3%  perf-profile.self.cycles-pp.down_write
> >       1.00            +0.1        1.10        perf-profile.self.cycles-pp.mas_wr_store_type
> >       1.69            +0.1        1.79        perf-profile.self.cycles-pp.mas_next_slot
> >       0.65            +0.1        0.75 ±  2%  perf-profile.self.cycles-pp.mas_store_prealloc
> >       1.10            +0.1        1.23        perf-profile.self.cycles-pp.mas_find
> >       0.62 ±  5%      +0.2        0.84        perf-profile.self.cycles-pp.mas_wr_walk_descend
> >       1.16            +0.6        1.80        perf-profile.self.cycles-pp.mas_rev_awalk
> >       0.00            +0.9        0.91        perf-profile.self.cycles-pp.mas_ascend
> >       0.00            +1.2        1.18        perf-profile.self.cycles-pp.mas_next_node
> >       0.00            +1.3        1.27 ±  2%  perf-profile.self.cycles-pp.mas_prev_node
> > 
> > 
> > 
> > 
> > Disclaimer:
> > Results have been estimated based on internal Intel analysis and are provided
> > for informational purposes only. Any difference in system hardware or software
> > design or configuration may affect actual performance.
> > 
> > 
> > -- 
> > 0-DAY CI Kernel Test Service
> > https://github.com/intel/lkp-tests/wiki
> > 
> > 
> > -- 
> > maple-tree mailing list
> > maple-tree@lists.infradead.org
> > https://lists.infradead.org/mailman/listinfo/maple-tree
> 

