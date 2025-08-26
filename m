Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E6F1CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA2CD8E00BC; Tue, 26 Aug 2025 04:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79E68E00A8; Tue, 26 Aug 2025 04:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9415C8E00BC; Tue, 26 Aug 2025 04:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75BF88E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:09:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF396BA0B5
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:09:07 +0000 (UTC)
X-FDA: 83818183134.16.0FACDF4
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id A2C6DC000A
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:09:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ED1xQDP/";
	spf=pass (imf22.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756195744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bDSgbDcFvmtf8166YRRfccFg98nE49rbTf/w57jWOig=;
	b=sYzXBJtOZXCu/C0q6YFrD30XSfJvwCpz1QiA8soPd1Ifzn8cAwJEcGlkuI7Eht0aM8S7Ht
	4unZ6pQ9Qlvx5j7Xc3eFJUPPKKMY9Nci1BxdLDE3yHQyClTaHwbj1/TidhkXHXpXtzFJOG
	YaZgtJKGZwzhmolSFEHFWqfaWgrXhys=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="ED1xQDP/";
	spf=pass (imf22.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756195744; a=rsa-sha256;
	cv=fail;
	b=6VXPgsm+2KPSBq2nwQ+6PKWk/VL2OzorfblhQNW7ZqpkVaa8kakoDjpGIif/EXA6ZqFGGv
	rmsRkwXTHYMBEIXYVRi64Onyu0t2squL3pqOXNCqK6GU9Ln0HB8lbumZqJ15/KzrXv4Qhd
	nt/7bRz9oa/4J81ZNy+HVgMoq25dT8w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756195744; x=1787731744;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=lO5lpWjBKYXVsro/PKMk4bAEOupuNz2u87rGW28cxvw=;
  b=ED1xQDP/FetG9bo99lHP3qlR/xcVoVOE263p7jK8uCppj0MW8OLj/2JM
   mkXoKaUP0Oku2+aJab1+aouflpCgjz+v5YRnPF593n8lh3LamObCF1J8n
   OWHTZHSxE2bH4hayXWUnstlDpDByeG6QISSX/xInltaeg6gEtjQRBrRyk
   d7hk732wnbkgSClwua5wDd+HsLpsMzn5HmhpTTwB96mHGpsY8jiYETCN5
   tfz3F1nfmOe06bSlobND+m3iULUnQ5AOXDqTxFzuUENT6IOumjL9D7qe5
   SYfEggpl8FYDtd5uOZ3+RAFYteAA+WJGUHxTCFW9MjkinBQpyghBs2DQU
   A==;
X-CSE-ConnectionGUID: /EOyGb7bRqCNvB72QR+HPg==
X-CSE-MsgGUID: nNhxBqIBQpmMwuXCIuCdSQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11533"; a="57622517"
X-IronPort-AV: E=Sophos;i="6.18,214,1751266800"; 
   d="scan'208";a="57622517"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 01:09:02 -0700
X-CSE-ConnectionGUID: tE+tbY1sTmGJCmXWHuv9Mg==
X-CSE-MsgGUID: YtuUBoX1TeCuKnYL9x0DQw==
X-ExtLoop1: 1
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2025 01:09:01 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 01:09:01 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Tue, 26 Aug 2025 01:09:01 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.63)
 by edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Tue, 26 Aug 2025 01:09:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DwLShSAwdYdnIhVsAsot3NV923qztYPOp2O9WZFmBHZIu6O4UmccUFu279D2JEnSt9GdDtMJswjFf7VW5q6y2ewQd2akSjui+rS4OABMMeJl0+8Isg7evQNqbHLPgSnGpqG+FekPSpkfezJu9za28BvVkQjAyb2byErt1wHYHgkNTFAoPzsHJn4hakmFx0RNDpUiPFhBLt/3QAl2y5pC/XfHEz7pQZywltlddK64CdsOY1PVr4JZCz4ZrqdGklMvxFSaPpknDovbWSzTnDJxBeVak1phEjarT60lYkD31X/iyDLcZwgr8noJu3Yasc9+AIHNC9wep7fnb0Y+9L1EFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fXAztG1pfak7phDmkZ3uVz9FzMCHfT06yZB6sMShAP8=;
 b=QMxe3cyUuseDK80nexzRYOR1ak4T7Snv7J/Fltsb82UO5Yb+z07SJBbfDbX+ilSEWlLZHtefVjIbfKKR4tdXOx4LZijkznbg7BsZiyYeRPDboTflBnHmDIq1+kqVX4NQIMTHZLhJaZLkQJfMQcUIa5g0AhRl1i84tSV/fOPY4jEI33fPq7N+0ALb2ZjJbivat1yEdxhZBxbDOChjO8tsdjsm4Ff+FdIj5b/uEj8XJ891Qj18Sr+0sy5/+3Y15Me0LEDPczyDV2jyAgzZWhqa1Tk7ARKE1QP5hpPyMydl4UIvyS+pBifCtHCEqS7aCXNjSc/muxw1WFAU1mvF3gs3UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN2PR11MB3934.namprd11.prod.outlook.com (2603:10b6:208:152::20)
 by DS0PR11MB8717.namprd11.prod.outlook.com (2603:10b6:8:1ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 08:08:56 +0000
Received: from MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2]) by MN2PR11MB3934.namprd11.prod.outlook.com
 ([fe80::45fd:d835:38c1:f5c2%6]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 08:08:56 +0000
Date: Tue, 26 Aug 2025 10:08:17 +0200
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Dave Hansen <dave.hansen@intel.com>
CC: <sohil.mehta@intel.com>, <baohua@kernel.org>, <david@redhat.com>,
	<kbingham@kernel.org>, <weixugc@google.com>, <Liam.Howlett@oracle.com>,
	<alexandre.chartre@oracle.com>, <kas@kernel.org>, <mark.rutland@arm.com>,
	<trintaeoitogc@gmail.com>, <axelrasmussen@google.com>, <yuanchu@google.com>,
	<joey.gouly@arm.com>, <samitolvanen@google.com>, <joel.granados@kernel.org>,
	<graf@amazon.com>, <vincenzo.frascino@arm.com>, <kees@kernel.org>,
	<ardb@kernel.org>, <thiago.bauermann@linaro.org>, <glider@google.com>,
	<thuth@redhat.com>, <kuan-ying.lee@canonical.com>,
	<pasha.tatashin@soleen.com>, <nick.desaulniers+lkml@gmail.com>,
	<vbabka@suse.cz>, <kaleshsingh@google.com>, <justinstitt@google.com>,
	<catalin.marinas@arm.com>, <alexander.shishkin@linux.intel.com>,
	<samuel.holland@sifive.com>, <dave.hansen@linux.intel.com>, <corbet@lwn.net>,
	<xin@zytor.com>, <dvyukov@google.com>, <tglx@linutronix.de>,
	<scott@os.amperecomputing.com>, <jason.andryuk@amd.com>, <morbo@google.com>,
	<nathan@kernel.org>, <lorenzo.stoakes@oracle.com>, <mingo@redhat.com>,
	<brgerst@gmail.com>, <kristina.martsenko@arm.com>, <bigeasy@linutronix.de>,
	<luto@kernel.org>, <jgross@suse.com>, <jpoimboe@kernel.org>,
	<urezki@gmail.com>, <mhocko@suse.com>, <ada.coupriediaz@arm.com>,
	<hpa@zytor.com>, <leitao@debian.org>, <peterz@infradead.org>,
	<wangkefeng.wang@huawei.com>, <surenb@google.com>, <ziy@nvidia.com>,
	<smostafa@google.com>, <ryabinin.a.a@gmail.com>, <ubizjak@gmail.com>,
	<jbohac@suse.cz>, <broonie@kernel.org>, <akpm@linux-foundation.org>,
	<guoweikang.kernel@gmail.com>, <rppt@kernel.org>, <pcc@google.com>,
	<jan.kiszka@siemens.com>, <nicolas.schier@linux.dev>, <will@kernel.org>,
	<andreyknvl@gmail.com>, <jhubbard@nvidia.com>, <bp@alien8.de>,
	<x86@kernel.org>, <linux-doc@vger.kernel.org>, <linux-mm@kvack.org>,
	<llvm@lists.linux.dev>, <linux-kbuild@vger.kernel.org>,
	<kasan-dev@googlegroups.com>, <linux-kernel@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 10/19] x86: LAM compatible non-canonical definition
Message-ID: <4rkxgsa5zfrvjqtii7cxocdk6g2qel3hif4hcpeboos2exndoe@hp7bok5o2inx>
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <c1902b7c161632681dac51bc04ab748853e616d0.1756151769.git.maciej.wieczor-retman@intel.com>
 <c68330de-c076-45be-beac-147286f2b628@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c68330de-c076-45be-beac-147286f2b628@intel.com>
X-ClientProxiedBy: DU2PR04CA0246.eurprd04.prod.outlook.com
 (2603:10a6:10:28e::11) To MN2PR11MB3934.namprd11.prod.outlook.com
 (2603:10b6:208:152::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR11MB3934:EE_|DS0PR11MB8717:EE_
X-MS-Office365-Filtering-Correlation-Id: fb78fb8a-92b2-4b79-319f-08dde477cdf1
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?Yhy+t+NKimrjMgXSPwdL1SWd+yVea1M7LcwQVgv22EKqX/k9h2Vvs1+ybE?=
 =?iso-8859-1?Q?uvrNe57gnhJ4cDmRswqhIyzSPjzKlRAm6AVHTeGwvd5wed238QXoCA2PFL?=
 =?iso-8859-1?Q?YA441gciBRhfj4iGbG9HnN85wp41gIUUngBNw+KKZNjG2dLpg4SyYFhHF/?=
 =?iso-8859-1?Q?BOz79JMY23bFCfuCwLElMLwXcejk7YQIHBgXXRSevZr47O8cGd1yj80Dv7?=
 =?iso-8859-1?Q?3wUCrFi55P/Bt32SmlRLidimxqwUrzoVaf+/mVHteuOqfTXkcszY0/bwzm?=
 =?iso-8859-1?Q?O9RYQ4L4fLACLhMCi4Z98/ALVQatRFN1XJyE+ieNYLOd219k1pOzW4GIkf?=
 =?iso-8859-1?Q?SdJ2W2/O/KyriRXV4/LTW6qu5fqjtDaYAVzVt/HFrFfJ4nTuYfpycrSUbI?=
 =?iso-8859-1?Q?LD1tdWUIBaMnw4lxuqqNixvIQbjjYpqoJdrqdIQewPd+a2RMWhuhjVbeYM?=
 =?iso-8859-1?Q?KzqNZh8om0KpvtOUpg7ucJftKQNR6IE9siGtxsLgxOX879t/B6PdJ+YTNr?=
 =?iso-8859-1?Q?t1b0sQdti8cOtieRffm++1sKTboDt+hk6S5j2xpBTRJCQs2O/BVwfkX77x?=
 =?iso-8859-1?Q?72r2rjt964N6/m+4mRQCEPo4Hq0u7mlJVM5iSulJPW+4tW7X1vOVJJiC9I?=
 =?iso-8859-1?Q?Onfb5WjUSsGxaU/FQEd8AvI5Oot4pUw4pjElK0YKFxl8w+82GZMMUUlDAQ?=
 =?iso-8859-1?Q?aixwY8O+b/xTY/1WtJQ381OslsiImm4NBKis4oPfaaVzO0hW5XjmH9tbrg?=
 =?iso-8859-1?Q?DU8LbbYBDEdrDgXSuSzBmxuxBqKZAGuOQjLYsUD0oNeyJGWBs6HgfNKYa9?=
 =?iso-8859-1?Q?Tc/ZsRWrOxfmte91gCmZh0PNwhqwN05+fPOkKPFBKdEm2WFl4kjPKMwuAq?=
 =?iso-8859-1?Q?HdvL8ZW+t5Wsroo+GXdu3ST9Er1WpawVKb9c4IKs60kJfJ6wddTIQYwINg?=
 =?iso-8859-1?Q?jdAfQfhbSAHi58sXVqbXGgeOtHRVpdP7UF8Fn6e9zaZNxnP7Oiz7asYagw?=
 =?iso-8859-1?Q?mPk9W1zMtGx8nhO1PZv0a4plND6kw3lNK5vhmyUaHK8VOlTajMTwPKxtEK?=
 =?iso-8859-1?Q?eFu0cu4lUoSG9yCztA7YJ6Yo/QJ3xDHh4ajIjmCe7zEBhNnzlCbtEqiUwK?=
 =?iso-8859-1?Q?5tuePgJ1IPb0zOcSrvR+K5tzRed38qMUbBukrM8g77UHqvgbcNfbLRftYX?=
 =?iso-8859-1?Q?PQjRBt047BJ/2Idi+v1/lhxtwDXHFYRgwT8BkoSv9H2ZCu10ZnL3R5PjCm?=
 =?iso-8859-1?Q?+gCM7ZczKdbK7udwfLLMpa37Hf2XrghJqSQUJnLGqwHgWFNcqfbn4UMplw?=
 =?iso-8859-1?Q?xrnTVswVeXYhsM9wtHNAfRlAIAK1RwuPFOdiOYHQ3EX9gQIvrf/IoFgfmv?=
 =?iso-8859-1?Q?et5yEikPVJ17Kfzi/1jgiQyQZkcTdgx93Vlg5MkM1Zggm6fAzGLWul9K/R?=
 =?iso-8859-1?Q?x3MeGIniBnzkWTbs8wxeyW8EGr8MADEudqqnIA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3934.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?UETUxd56y5zgBEZDV0psvtQHQs8cC/p+8kGGsCYLq7Y5w3u8pU2GvLkRa5?=
 =?iso-8859-1?Q?WbU0Oc2yDw7qErqavuI1bgLkzJe3K8LP0zUy2gCkGngNIcrLxQtXksXp0F?=
 =?iso-8859-1?Q?0W/+UBN64AMQMxKP1Qn+E4fSoreXaLKkfHCxozJEJuc+BBhp00f+4yQprb?=
 =?iso-8859-1?Q?yEf/dKKgv0xujoprmW30ixMe9xQ4n7FWvUvmod4oPRNe/fQD5uUlfdHDXQ?=
 =?iso-8859-1?Q?L3/5zgtBmS4w3C+/C9pNefPscfAdh0UC7iy2keoG2bsHIm/4BJTar7eOot?=
 =?iso-8859-1?Q?HkUG0M6vsv0iB5PWx0F4ndkWKzB+AT/CGBj4zKYG5uoSkV2OPIoAIBJcDH?=
 =?iso-8859-1?Q?rbT8mRXV6RHUy+7yUYDRxVKzminlqdJ6lbbZ5GnzfUA1ye/NQAc7VJiqnv?=
 =?iso-8859-1?Q?JMBPO7dowYSFMoM/P8y+wdrOtoi+K/b4RISg0cjfZDXiruF0HfEAXGDVlM?=
 =?iso-8859-1?Q?AezlZvKCxm6o4RgFkyc+jlXegWX+2kk9X0FYUaC8CKPQJCMSlpMk8sYF3c?=
 =?iso-8859-1?Q?++mvDHfsdCYa/c1oN4YbIlAWrOQvRgKhR0dKm3Mcrri7pRYtzLf0nAFH/D?=
 =?iso-8859-1?Q?RpBh43Igij9LY/LgNwlPxcSOU8/9UvPqDfDLAZ8by6oCLuVIwIQe76FyHW?=
 =?iso-8859-1?Q?BiHX3C+kdG3phPeyHIrJ/8mO4h9XaYtwgRsF4TvNpHUsXXt7PfvKZA0Ziq?=
 =?iso-8859-1?Q?2N9RBkisgBTLZVBpPPsTfRwhQfl6HNPue3Icz72GxHky+HkcXnD5TFa8TM?=
 =?iso-8859-1?Q?zdxCaty8aRMbJF9BnQ8aojLkm29HqcXC2zo1AlmI/l5aiC9BJnMKuZjtc7?=
 =?iso-8859-1?Q?7Q3/ra3G6urfeOOZ/9D6tj1NMxF3Du5CBkEp5OpkMbPx1Jz7jcSnjV4cdb?=
 =?iso-8859-1?Q?clt9g93OrKj56dRkemMI5881UWlz0k4UDp8ncvzy1G3SfXQPpBtBJ/3zcA?=
 =?iso-8859-1?Q?cjTaa4RkfaT4UasCjjcLH7OGVkE1RNmOsDdDZ/s+yowahOE3+JzRp4ymKK?=
 =?iso-8859-1?Q?1RgX+hKglQwjLENK0rNNn/KyEC/Vl8S4oppBdvedMdLVNaRnaX9Y8Eu2ZM?=
 =?iso-8859-1?Q?xkFM4yWEj/uOdWBq4C/vNOfjwVW2uyb5PadMg9rod4lQDFZt4GjgZKiUnA?=
 =?iso-8859-1?Q?YzmVJgn4efaZKD/gErwhsE4iO9+8eCvzJO5patFvRPRRVf3UV35uRllVuM?=
 =?iso-8859-1?Q?oivYPprg+FgoutD2hvAa1z5ornn7a3AeCwiHW8Zl0Ol2YwHkZZa15JYFEH?=
 =?iso-8859-1?Q?q98q6O8MdJAD8Dof7mj3cFhQvpMZKysFo5sB0rnmj7uXd86rToaXTmGSX4?=
 =?iso-8859-1?Q?l8N15bugcFMhNJ9DrDrCIOjFaQqIBbrYu9ylig1SWmoetKc76ylLYr42xo?=
 =?iso-8859-1?Q?n4SaEH/KsPeqMe1KzGycNYQlMTvC+t31qgNmM6nwZVgkZw2uhTkdmr4q/u?=
 =?iso-8859-1?Q?zvCvLsWXBHPual3XEnqH3MzwJXctOkaNqDj21lUiGfafpbzthyF3wUJ8or?=
 =?iso-8859-1?Q?zO6WM5eMzT6S4mCUILeMgL//6F2oebJA5UQotnSckoQauEX67JcngEQgXX?=
 =?iso-8859-1?Q?6GXMNugPxQYWtkVoIarRzgsPVzOMfDjZhKshPAVHV+Fna4rLjI/Uz3pCTx?=
 =?iso-8859-1?Q?imq7Zwj4lPh+EAC87I8WlV+2RjZshP3tyuQkC12dx08+X5IcuCvsd9gVxo?=
 =?iso-8859-1?Q?BuOTQbxyb3UPiMXI82I=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fb78fb8a-92b2-4b79-319f-08dde477cdf1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3934.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 08:08:56.7109
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wsbR1631Oh+jOi13LRqR8gMDmyTI7WBthML40+quydiUbywwPEyeAURAVORes/vpmlylUWWXbtgYI5E7CzhJ0wRvX2f5/uGX2LWh6vBNr5s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8717
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: A2C6DC000A
X-Rspam-User: 
X-Stat-Signature: 9xeeahxdpsmycwzgmhsy49k68mr5ziis
X-Rspamd-Server: rspam09
X-HE-Tag: 1756195743-858699
X-HE-Meta: U2FsdGVkX197Wtm+9wlJLTZjaVVawt7LH35PNdvY5xlwcJ1CAO4dOGj4bACbGfycsi/fSkXxgup/ItpG5RU8qqnaZ/w9zkzoLT1gSIvEzgQ6yzRR5k+lV/55USd8uhvGUXWmTlpMe1atkgi1dExXzT6JvpM+yh4EQjMNr6uBjlU6Gbqw4/J8LvmRVM4VReV1VfVSyjHcGj7FTPLXCR3QbUZ5r9IAHKF/UdzM5CPUNepsGp/dktTlqrnYptnOTl9apxnlJYjk2XUUFpVTV4CuUqu/SMvsCPJWxYOO7r7Ttd+OLvotWYZHJbPbbLtqU4Wr8DjuPvYLAgt9YEpQtd3qhLVkHSD2X160wBCLZAM4qE8WZS1S6NFSDv9qJNb91LOkXyglgt2/bA43fa28ANE9yM6ZheuwaUWn4ZUoE/PbNNLLrgTsdAOcwcxboskry/0JbgdKqqVq3UzkBaqiwR3mfcNh6iejDDB4PqUJMQSo6UN6oj8lLFO6H1LHygAB/6NmR4iJHy+C8PtMv+UEc4X9N95f7AgKGsAm+S4GwP+7EpnXubEniGkNBo34nKdC/jd0U0t7IrT1DOMC36YVvAPxB/FmsJ27kmvNgs5soLFJqPgFUxohGoMZYZ9MW+PkrEGKnllpHmX63i0PqT866PAQeM5ewNQ3ljT6Hl2ZgOe3ZeSJFwbSPnIjcYIYnNwHZqw50rte/U6HYFzgKHO5EM0CZXnBtT15/QBGA0n5w89aI+4EuoHc20QmtP+K2nCq1lKQot7DkKCuhV9Ll81mzSPRTMx0+1xnfW9jo5jSgd/hOROLSy3AjXvfyq/i1V0MzWOZFW+qNKFmGYhSrpq0g0euL75le0riJ/6qREK85QdbWgKBuYWxH53tM1SvDDjTtruq452jmxoeuEtpzwJmNXlx1R4yrM5/wNfnAl2yhpVeVnQnMCCxHrvlGEujeu613WlxNsE2O7tRKp/2q5FSTv9
 YT7JRNDr
 Liwx8zqlsEUz3Iy+PZHEKFP1uyp/i1iQnRj0Jtz+NSSsV0FX56WsP8/3jTFoFVThnb7Qq0BU4b4VIuzkf65641js7oSCTQ4HmVFf7iDn9L1W/EirdkoD337FEC++IVW+cPipOCbZZYNnjxA6thr6MPFP/S6UxoDCfI5Yv23bZKo4Gp0YUEP3zWdUDRP81an3dDQnqQSeNm6/GHheDFGCBQhmfRCFZEhWQMOjh2MOQKIDwtDIfPZxweOqEEo3ijsaaerK+TzrL/EqeszmTJ530H3AhCZyjKz7l39CfCFIwxdW5EB04+dqstNmWcHINWstpNiug05Vps5z3MyTmfJxAp71U+cXGTYlu4DhBxsVFBirsStbnuc0dkPb2D7UQKv74RyefU+EDz55WrgN+4VoyLZxMugiXv1uBwvWeqbA2s0HjAiGysCwj2d9TBz57SJDSiWlmgJpss6t3mnYoie33+f0uNumD+CUKI2KAO+zwH5JlOpnP5yWkSTT0YXC2I4TammyreHVH7DQger1Zzx/eedRxRhpYVZdZ1gBPUn2E2OhrbL0pExRc/FxDDauT7DyZr9yrJPlYx2ySoGVg3AewuFS9rY8GWh9961tkEcnf9ROYmBs9x8+NyvLqZzB+76SSY3/e4sPRUk3JowBqn/i+QYSQ3O3qATz2uo1q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-08-25 at 14:36:35 -0700, Dave Hansen wrote:
>On 8/25/25 13:24, Maciej Wieczor-Retman wrote:
>> +/*
>> + * CONFIG_KASAN_SW_TAGS requires LAM which changes the canonicality checks.
>> + */
>> +#ifdef CONFIG_KASAN_SW_TAGS
>> +static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>> +{
>> +	return (vaddr | BIT_ULL(63) | BIT_ULL(vaddr_bits - 1));
>> +}
>> +#else
>>  static __always_inline u64 __canonical_address(u64 vaddr, u8 vaddr_bits)
>>  {
>>  	return ((s64)vaddr << (64 - vaddr_bits)) >> (64 - vaddr_bits);
>>  }
>> +#endif
>
>This is the kind of thing that's bound to break. Could we distill it
>down to something simpler, perhaps?
>
>In the end, the canonical enforcement mask is the thing that's changing.
>So perhaps it should be all common code except for the mask definition:
>
>#ifdef CONFIG_KASAN_SW_TAGS
>#define CANONICAL_MASK(vaddr_bits) (BIT_ULL(63) | BIT_ULL(vaddr_bits-1))
>#else
>#define CANONICAL_MASK(vaddr_bits) GENMASK_UL(63, vaddr_bits)
>#endif
>
>(modulo off-by-one bugs ;)
>
>Then the canonical check itself becomes something like:
>
>	unsigned long cmask = CANONICAL_MASK(vaddr_bits);
>	return (vaddr & mask) == mask;
>
>That, to me, is the most straightforward way to do it.

Thanks, I'll try something like this. I will also have to investigate what
Samuel brought up that KVM possibly wants to pass user addresses to this
function as well.

>
>I don't see it addressed in the cover letter, but what happens when a
>CONFIG_KASAN_SW_TAGS=y kernel is booted on non-LAM hardware?

That's a good point, I need to add it to the cover letter. On non-LAM hardware
the kernel just doesn't boot. Disabling KASAN in runtime on unsupported hardware
isn't that difficult in outline mode, but I'm not sure it can work in inline
mode (where checks into shadow memory are just pasted into code by the
compiler).

Since for now there is no compiler support for the inline mode anyway, I'll try to
disable KASAN on non-LAM hardware in runtime.

-- 
Kind regards
Maciej Wieczór-Retman

