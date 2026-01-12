Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D8D1D2505E
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:41:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EB46B0089; Mon, 12 Jan 2026 04:41:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF096B008A; Mon, 12 Jan 2026 04:41:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 745BC6B008C; Mon, 12 Jan 2026 04:41:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63EC86B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:41:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DB371A0721
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:41:30 +0000 (UTC)
X-FDA: 84322819140.04.FE0E5FC
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf10.hostedemail.com (Postfix) with ESMTP id EA459C0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:41:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EhZ2X32+;
	spf=pass (imf10.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768210886;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2NZpzAYi93atpMOqRw3hQ2qw8T7ybWHrXnCJ2hAj/s=;
	b=ca2XWw00u25eixbbaSyGjhzJ8OBRMVCF8q+4sL3VOX39zqyPb2dNz6ejBEHfLl33sdQpgC
	nA1PkVEzGVeo9WvhfRA113QDVliWw+n471HUUGmAlSYhnERfVnYJ2JDFhLEPN/x7xnTW4c
	/ynkcP1AWohG93R4vIMl6laBZLjME2s=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EhZ2X32+;
	spf=pass (imf10.hostedemail.com: domain of yan.y.zhao@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768210886; a=rsa-sha256;
	cv=fail;
	b=YTKGs7CxI0q/SXGGRV619AgPH25TSQaEiNWQAQ5AXdSum8GktR9CFsjDtgsgpkFVLXcoui
	KHv9rv/4+crX35vDvmVXGNQ+POtnjgK2H9uBXc+iREydcHkp+huFnJisKozlryHOICZS0x
	6/8LLw/9/hkAcaOgbmOIpjQ1Wf7QObQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768210886; x=1799746886;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=zPD4p/vAomzr7x5HkZV2Yjpaxk5EWwQ99xAXxJioCdI=;
  b=EhZ2X32+Nar5twwOmVQysF88X0tusaIw3Di4o4kS7r/uOloCb0h5A3vq
   qQQHnu/0buGyv2vG8NR3QZZmzjYbd4S7QV0YKm2xLhO3dkAee24STi2Tz
   HGiod9pQhiy4RaCuU0yW3EcKxRMVicbLn2DkMjx5Ia6ecmCEMYrhacGus
   ZiY+THcTX7l8/CEvh7IGj+TlPSqHFwKE4W4380uV3qVuv0ffdmpJ1xDUF
   RCgFMYAPuQT1vSiMzCEbjYbLc3S523asPOVS+hIuM4j6plVwRmem16hFU
   kvdzJDw2Rj5lKr+jCL8IALw02VCONI4wiDYskCPl0GdKAWHZQwz6U5xrG
   Q==;
X-CSE-ConnectionGUID: a8WfQ11MTvmO65b08b26eA==
X-CSE-MsgGUID: Nx+k61RCT8SQiVloJgSZBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11668"; a="73114356"
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="73114356"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:41:25 -0800
X-CSE-ConnectionGUID: jhBIloIBTuiIV3qbA6Ou7g==
X-CSE-MsgGUID: luMX28/eSQqSvN+laA22Ug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,219,1763452800"; 
   d="scan'208";a="203957014"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2026 01:41:24 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:41:24 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 12 Jan 2026 01:41:24 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.43) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Jan 2026 01:41:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lWKpQd/o6DHs+hWISQs8oKuYGexKHo6LCBVDQ4RwiqtcMHdjzC5ovcBUXCnIZuDAReWlGcSCxwEsb42pk2bbdtGT9Rs9NGjBoQRMFb12eJObGQWcS2eoH+ycYwGnwyHjM219YV1wzL/YtIbyXXPniX7Fi5ge5rQBb+y9lClsEIOMcxAcXJE+1Bt6OL+bTMe9/bXlsxnKh1RQN/lkWvxJ8EJoM19ndQtpvAcxWpt+ZjQJYgCFTU9S5To3WpQUXTPW7jsno25l4Zni/0urrqSN0QXWIGhr32gfBodVgkx+ZH7IHxZbDtwJOj20m3yjtI1lMEnfjNXZKV79on67uJ1bkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y2NZpzAYi93atpMOqRw3hQ2qw8T7ybWHrXnCJ2hAj/s=;
 b=Q96NP/EKVjn5qE3ocpKx82xPC2remA3nEuABkitig/pBaqyaVjK1dduWrzA8oI/Lq9WRbJG+C/0ajn+bnHKoUjO1e8M0ElkSiGanMaIvM2yiUjZ7osV372Gd1WeJMD89bxB2ywEdCYPS9VZ+ulJgKTAsRmq/5QmCALvaAJAhqBOQ4N00bhYp99BNPMzIsl50HRV2jwHdCa4GTK87qUupZean58ZDA/sdx32VMolERoIb5fATlT1WztYxm6LLqYy3HwtjCyfRKKo3Km07y0/lDoDl+GGpx+CHyKNM/cL1l/39CAv/YiDa5/Gl5cVbJMIMWwSf8YmBr5d/9XBs0DBpjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 IA4PR11MB8914.namprd11.prod.outlook.com (2603:10b6:208:56b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 09:41:21 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::413f:aab:68fa:b1b2%4]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 09:41:21 +0000
Date: Mon, 12 Jan 2026 17:39:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Michael Roth <michael.roth@amd.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <thomas.lendacky@amd.com>,
	<pbonzini@redhat.com>, <seanjc@google.com>, <vbabka@suse.cz>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <david@redhat.com>,
	<vannapurve@google.com>, <ackerleytng@google.com>, <aik@amd.com>,
	<ira.weiny@intel.com>, <pankaj.gupta@amd.com>, Kai Huang
	<kai.huang@intel.com>
Subject: Re: [PATCH v3 2/6] KVM: guest_memfd: Remove partial hugepage
 handling from kvm_gmem_populate()
Message-ID: <aWTBPjl2TNEczy2C@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20260108214622.1084057-1-michael.roth@amd.com>
 <20260108214622.1084057-3-michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260108214622.1084057-3-michael.roth@amd.com>
X-ClientProxiedBy: KUZPR06CA0004.apcprd06.prod.outlook.com
 (2603:1096:d10:30::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|IA4PR11MB8914:EE_
X-MS-Office365-Filtering-Correlation-Id: bbf8b622-06e5-4bf2-a217-08de51bebe1e
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?E2lx3kbHNyDqIWUKtl+5dfrkywLjPazwi+YwNRS0+PfzOUbIFNdwpk3uZv7q?=
 =?us-ascii?Q?zPfcht3gyvjYufKvi5sUfes+AWiHcegvMX5y26aZXyNFpyQuL0lnbVRR0A64?=
 =?us-ascii?Q?nbEq2hYZYioSeND4V61BXrX5MOEtaT16Vy32XgIgsyggBc+HPYb5hSqyL3c4?=
 =?us-ascii?Q?cqCFSfzkxTxzS5DOr7y/jmOvQwZ/avyiw3hACY6xN0X+F0kHuwwbil7gw9WQ?=
 =?us-ascii?Q?VYdkd6g4wQZO65My5gPdxAbp83K1FDPFyIuHCBG+HWNmR6ERXwWH/80PkPKb?=
 =?us-ascii?Q?+J08O1odGcokJaehUvbbeUQlgn/dUHK2rueFpBypUnjrr2ffEYkA8aw7eQmj?=
 =?us-ascii?Q?U6JOmGr9cRWM74fTQuyONrb5OHYr04Tj0SOIt8sCzU6v39OOyWQmdLOyQmRq?=
 =?us-ascii?Q?u8oewtDydi8g/mTlKdBBhcWIxDUSRft/9B/Qi2ANeiFdDJE2RKNXVDSXmBxs?=
 =?us-ascii?Q?rxUgc6ajWHok/h0Lls5mlH4WXxPBHpnDXvo0Iio1hoqC3oVhwkZaML6PZo7c?=
 =?us-ascii?Q?SuDU51OVpzp1R/i+WZd0ZBECdliw3YgHLvnuKShxk5DMkv6KijgUx9RHvq28?=
 =?us-ascii?Q?fM/aUJ8cbRhlQ9o0tckfhXQ0AsU64qndqDL8ZQEFqHjG+o/arJR8YKV/MYmH?=
 =?us-ascii?Q?fp7yrW3eyIWOsIOKYso/lbAvM5+Wo+KFsZmiEmk/DQ6Js4ae77mtl2j0JpzR?=
 =?us-ascii?Q?JVDDMuFcuAKfIoAnmSB6uCVq46k2INdGunATHG4hxC/325iTTrklXToA75dA?=
 =?us-ascii?Q?sH2BRNJFysiT0BV6fvEX7mR3bVfrBus2vbjXUhAZFU1wD8NVYyKp64sxP76H?=
 =?us-ascii?Q?ipvRhABZIFNWO151Tq+K+4ce7e/DRbCBdVV12xYbpcqgnSGixWYa3w8XJfQn?=
 =?us-ascii?Q?LYTlG8+pd2qzBY8Kmujw8SnAN3JNBnbT/gldDXBeChlmEoD3IYommRVqa2VC?=
 =?us-ascii?Q?kww4nlZlnf59DHz3bKcL1bDAx/3PjN5MAXjvlJDl8nYz0b24vFtUE636TLm4?=
 =?us-ascii?Q?XWGy3wxB/+yiqaDql/dJmtlFtiPH43o2QxMr9ChND4gibGZaGZ50qACgvE9k?=
 =?us-ascii?Q?ZnotQnv85LA2hI9jpQyOep6I12Z3eZP3EkIwtL6iAzQUubdr+hKUc0bVOrG8?=
 =?us-ascii?Q?OJDDIBV8CCS2gvyPp2zA/4faQn6bOCkfP38GAxg9Xjg2HIsaSP4uOIKaDX4c?=
 =?us-ascii?Q?2Xttho9aTDD04vMiVK0YRSl2cbnhLYWuvaVfYfhkBW5xyZ3x+gSuw5m2vES7?=
 =?us-ascii?Q?mBVqLSJ2GtdTQOAQw06vns415KzmT3C7Y70iDbcPqDDaLfWCOdIjwZXzc9kw?=
 =?us-ascii?Q?A2RyysL24U8usXORWVBnkhBFkg9gcH0HXS7N5ytecH7V7puyNGkSBHs7cmv8?=
 =?us-ascii?Q?hmidyujghwBvJcjByEHzOOU3mxAXY9yJpgDCD34UgCzDwat23vBZG9ox7452?=
 =?us-ascii?Q?/AAnycT6GsSS0b7JPb09B0sRDatI4+MO?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jwNw3yCKVjX+w5ZmNKMkZLerZc1ZEDGEaW4xjBVeENoZtoMAwmN3UGuamVzz?=
 =?us-ascii?Q?COijOsuovsJPWEtiejd/bviqOPF+XWYpkPatkew5oXCn8nkGjISdbBbc5jGv?=
 =?us-ascii?Q?3P7cRJ+0c2Z1hA4D6UcfeQheCMo+5OD4Gn3vkN3TDkiWyK/546DH+PmHPcoQ?=
 =?us-ascii?Q?jO4KhtWn2tOEINSRXmvKjV7Y88QJLU+VrxR2TPRFYINhKSmkLEJxyyIFL7RH?=
 =?us-ascii?Q?3pbmBFfrHV9pQGG1syHRXUuLUf9pHiAJuPZi4JgfJzDHY5SLO2w5f6dSG2tW?=
 =?us-ascii?Q?jgwuFJJeafMmD7iZpfkxKL2GXUdK08JuhQzcZ9MVkQUBXMfUIQ4RH12Ae3IC?=
 =?us-ascii?Q?6Ekc5+V8x8zXE9MtkaTWXzCbTiVx8dC+xss77bfdrNxzwRJd8gL86qlltjVs?=
 =?us-ascii?Q?fcvQVGhL4ZTq3ljFNjEqflEI9PHzUbROKSxG4eTtkJ1Olz1WX9OsnDcehypw?=
 =?us-ascii?Q?VZOVON+7AjkXMhGrv8smAA8ay07k2MESBkmm9jF77/7A+sqp2hK4Y8ix5Jxq?=
 =?us-ascii?Q?Ay0pbZUyz7nigzdOSyLFSGL4G/Kr4BeqPEd11iQbX/iU8ycns1ka9kQqnV2f?=
 =?us-ascii?Q?i/GPZ5t2GIc9KfGX/yurm8P5S1XDKJMlNIiEQlppXa8j+e36gbPp4q9ktaT7?=
 =?us-ascii?Q?nZYJ2r4oYYt9WrVS/RkGNXOLjWKAYe7c9wR3ECdKO1YzqHUz6ipvpO/9R8DH?=
 =?us-ascii?Q?dgnHzGMn9mhbjsUiKxP1P1hvVs/JFwFrEiOK0AH7lURJ/ubcQX4CQtkRIVDt?=
 =?us-ascii?Q?lCZToksdXykl8dhota+bxinDG3rYE0GASIqkIQcg7UhKFRdwAEllO9eW/UDu?=
 =?us-ascii?Q?/HG4LI8DR97F4/+/pxqSVKMuALGihDCOorUKDkS9H2VOcidep9XA3aWJHE1Y?=
 =?us-ascii?Q?49hExY/ooIp6NILKxQKGA1KTnNDijcfki1/hhan7uGGq19GTG6wh14vqyv6Z?=
 =?us-ascii?Q?qsPNDICc/Sjf6ZH4dW35WkgXXoh1gxRYF2rb+Dq8zvZuhbCzrbohqcRbmd3R?=
 =?us-ascii?Q?Dwh9uxDSelsFxZXDmf/1jDj2wtXCLZ7g7KHGPB6iVpWCQQALXJFcMWP5bc+M?=
 =?us-ascii?Q?6GEqbRTVj5omUhdYxLtlbcrLhstvv8av/qWsfC98NPz4WWyty2ebu5uQMvQI?=
 =?us-ascii?Q?AOy+IBa3ZeX+pTmhLewVPqrsr8mWo4ab58cU9tDnnqlR40BK89uQWulQx8e/?=
 =?us-ascii?Q?mLOQqutJVzRZSkFEHiUBpHOIS+5v6e+Zs5d/DaForViYSxrhVho54m1b0vXg?=
 =?us-ascii?Q?76txWtlka1wDrWA1SP6n0fPB/LPb5Wm8VGE5u6Q3bmfNyiY0TgSylbv0HEn7?=
 =?us-ascii?Q?CYcifqvAqOq79FF9eDrzeKX2tdcHRFIsOfTD0f5dxoOhw7h11RgNCmyoq14G?=
 =?us-ascii?Q?qpIWfCcxbrloxkuyLaWXycu0IHDyGimaB7iNmNRS2UV0lEg8cVKofvswih6F?=
 =?us-ascii?Q?SyUcLegRrEJ1m60YDn16gkFCrPWKHg1XBQ9ExY9uWHPWAzICjc6LdHiyziQN?=
 =?us-ascii?Q?rWCVmrqCCE3nZR6WPebG9uy1kxdsHARiEcCWAnoGh+IvqNbCMdNsQs507Hyu?=
 =?us-ascii?Q?91fgy1cxI2L9fGiGnnKSFunQN4/SEYsq5wAbgMaWLfGeID8v3hwmS/c9rOkU?=
 =?us-ascii?Q?ryOi1la+NEnsfeaMycboolBmf93Hyx9/P0wKD5XBJubwx6hclUVWzlYDfu4B?=
 =?us-ascii?Q?FeBrhNSmKq8/E2EPoalFnGynqE5g2GmaHhnuPpXqio8FiQewO8RPvcm4a0oM?=
 =?us-ascii?Q?Z5dHPjO8vw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: bbf8b622-06e5-4bf2-a217-08de51bebe1e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 09:41:21.0209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bfZZWHTx7tSjZCLxVpmDNqQ8VVplw4+sUM3rwa0upLpYINXJjr3vuroRyh1p5TeNOrJh4nJnbELAGxfldp5cdA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB8914
X-OriginatorOrg: intel.com
X-Stat-Signature: 4jhq68d5fa4hatd7piu1ifod5ecbuhg8
X-Rspam-User: 
X-Rspamd-Queue-Id: EA459C0005
X-Rspamd-Server: rspam08
X-HE-Tag: 1768210885-298171
X-HE-Meta: U2FsdGVkX1+mAuGrLO8XS2WrgtPasg6tmCvyPsJBfzU3jcFsLDdrMQAdwzBHR//cLbdg5hoUxl3tvfh2bPTxyqmIev5zjlwfM6I3RPvLthHIrymO8WnmVO0J/YWI455S/Itomu/eSS3tQZyTE7ikRiaKvYMm7TpAF8X5JQm9EHcOIATHZ7HVB6SSujxAQ8CGeyRc3MFSl1LTnn0HJ0GZ4aCwbUmbeOFeaiUK4v3G8xrDLcBa3rpJduLu8t5FQNP9ZfoD9ghTFIImVUhuzPX3y271WLMC/W9fFXZTT/ZH3ZjAPY/QWxrN5iRrcIyZhzaH2kaGV6p5u3pHDcAsQau+sC4xoayuFYBSyGFl+FzckbOyw+HNc5BcrXYGGCj5SpKPeInaGBDih+SXWyBml0hQglShNPXW+G9LFLmLxq5xMR7kI9ihFCd/G8qyNo/pYYhgTl/7sk2bY2L+RDFsHJD2fdCxdgqmOwlKqZwExKoaBIWMqdeSM5etxFImeo1UFO2KJ7f+e+q7Zu+kR3di+iJu7Rv+1O2E2BfUkAcPFrc5n+mn7DXqhWnrovaDDAwa+OehPFhHWIN4EewJCe7Le7OZ3QAgHxPFf/fkuddXPe8ml5GNPo2K3ODug4Ys41wigxtdDQAYtdDKSEAJgbV/n4/ABTtllp21F5XwXnWqi2fjzGmPcS9kt8WTzqPvLYcf6/Ttp3zlSp635/+fqLE0YC31d+skG7SthvtRM7JBDV8qQWgjcSwfiYsxl8Y4PvelSoMXCJz07Hj6GBhjq+4b6Po7XjKAdVylbWyQeu5PrihYJgEX0aDGqNVHtfox//GIxSR3N4UlArHwTqAmvJzXoZ+MZJhk5Clr17DqpYR+GqgG/stbEq3190VNKKBN8t67NVpLNI9uZLDGYlD8Qx9rB6Vma1ud8+8B6jZdc+Yrt0mn2aR9Wf5tgvyizD9p0ILE3Y+uJisM/U1zHRs4SXZX7pm
 F82tvyrw
 xTZNPRt4C2qLx0DRHDJS4C0m8LpnNDSihMohIHcbwsqXxY7frNgQgJGwy8oFJP02tzZEmBmxvmTDlTBd/amBSEKfvByW+BHLaQyE3gze+HHjDfj9yt61KeNMll1pwnI7MYypixoHjLPutTu3phntZ4lC56kctK1PveN9f1u8Y0GSnML14pld1LJ1wzMa4ioTua5Z77kGEREfhAqOb/2yNEgZ92gO/PtvPRtlKRhLzDnohtNaCfMKZ1RgAsO7csjcYmsL1XOB2vN8yt3KlcHdwJDlGTpItBOVedvKWQd6sQ4jk5PreZdX+qOW8PV+vaKIW6X4iCFRHZTKVj/VlTAaOV/VTIRGwOc5quwLLrGJmIEI1F5eJ999DG90P9Q2hz6iLZ6qY99CK1ZnF8q77ZOJI85xE+094KD77VuI4/+QQtqcjDaiiWSRZoDGLAivAFkVT7BhHJSS7XQreqEnEbDlkvNLuqaHxU8DY63s8XNyY/NV+xhM2syDJaHoaI1y0sPmTNCAxZzsBB3DI7lojR0ZbDDZcxLhickbdyrouSXX/181qmVH2ToM7FLTPsL1S7Ow7uxS+FkCLKziaqNe4p+1kHBY+q7Bfig0WnMHjFCTHO8wiaUiYfumZ+CATcsycOofHDxH1egXsy/+gT7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tested-by: Yan Zhao <yan.y.zhao@intel.com>
Reviewed-by: Yan Zhao <yan.y.zhao@intel.com>

> @@ -848,7 +857,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  	filemap_invalidate_lock(file->f_mapping);
>  
>  	npages = min_t(ulong, slot->npages - (start_gfn - slot->base_gfn), npages);
> -	for (i = 0; i < npages; i += (1 << max_order)) {
> +	for (i = 0; i < npages; i++) {
>  		struct folio *folio;
>  		gfn_t gfn = start_gfn + i;
>  		pgoff_t index = kvm_gmem_get_index(slot, gfn);
> @@ -860,7 +869,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  			break;
>  		}
>  
> -		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, &max_order);
> +		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &is_prepared, NULL);
>  		if (IS_ERR(folio)) {
>  			ret = PTR_ERR(folio);
>  			break;
> @@ -874,20 +883,15 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
>  		}
>  
>  		folio_unlock(folio);
> -		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
> -			(npages - i) < (1 << max_order));
>  
>  		ret = -EINVAL;
Nit: Can move this "ret = -EINVAL" to inside the "if". i.e.,

               if (!kvm_gmem_range_is_private(gi, index, 1, kvm, gfn)) {
                       ret = -EINVAL;
                       goto put_folio_and_exit;
               }


> -		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
> -							KVM_MEMORY_ATTRIBUTE_PRIVATE,
> -							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
> -			if (!max_order)
> -				goto put_folio_and_exit;
> -			max_order--;
> -		}
> +		if (!kvm_range_has_memory_attributes(kvm, gfn, gfn + 1,
> +						     KVM_MEMORY_ATTRIBUTE_PRIVATE,
> +						     KVM_MEMORY_ATTRIBUTE_PRIVATE))
> +			goto put_folio_and_exit;
>  
>  		p = src ? src + i * PAGE_SIZE : NULL;
> -		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
> +		ret = post_populate(kvm, gfn, pfn, p, opaque);
>  		if (!ret)
>  			kvm_gmem_mark_prepared(folio);
>  
> -- 
> 2.25.1
> 

