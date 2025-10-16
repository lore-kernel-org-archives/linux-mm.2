Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418FACCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:08:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9E88E0008; Thu, 16 Oct 2025 02:08:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 689CE8E0002; Thu, 16 Oct 2025 02:08:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 578EB8E0008; Thu, 16 Oct 2025 02:08:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 461818E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:08:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CAF4F139550
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:08:41 +0000 (UTC)
X-FDA: 84002948442.14.C819389
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2DF6B180006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:08:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nkiX9KHm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760594918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hmuhObJfZ20RvmA6d/Zx1zXkX0JQPmmurlLqeKlG9rc=;
	b=yfJp4N+/a2SSZO6aoOYkxnw8qSF6gaVIn8eSIhse2CKAP/oDGoIQ9TULkUQMxvkiuu+MdP
	tmSoE6LF2mTRG9jrOlpTJOoJnAeTRgS1sesONP3b87jOo876fKYCVhOHkotE6iXTu3jn4D
	y7obpAwtSlvZTUFnGrlXixAZICtpB7o=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760594918; a=rsa-sha256;
	cv=fail;
	b=NU+iui+C816WK+dJK/ct4SwoTulYc3+dGYpv3uo/vdszH/CJSNgeIx4QScuV6vjTMSHY+r
	yR1k4M6W/AF3cPiCDJhlkOjgWIeSP1Sc7caCO/6eqZDXxd4ULtivNZD9IDxRMPzbOo79jo
	AnXh6h9q/Eaz4is7LQRmK07wEHYYUGA=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=nkiX9KHm;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf06.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760594918; x=1792130918;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=typuW+jatCU7qa1MvIxqSS4eyWpeyIZp6PViSGk2XlQ=;
  b=nkiX9KHmxgO0ztwqdOk3+lInIti8l2TpSVFGriMR/ZATUR3BM+mL/ITV
   KtasjMdKMvIWIoa5eV99xMTdakrIgTOlQo6xZUqLpBopwBDPl8o7/2mtg
   iCc+aM+JCjBOWfhGcRHLstwu++8aACkb6iLwRfHAbWxkrVogWo1jvGqwk
   m92KWvX29V2cJlfmbQMixm9QD6opKtsSMykeuZFKxvLWBAddN2O6aywgl
   zxRti5wmhu0Jprscy3JXalTkX/A+qDTxflb0+C9NArnhAmz8sDdEpmpbT
   2dMnJrfSbs2Svl9zROaSEVhGTLB6F2sloo4q4tkym3lCKjbEge7R+S1gz
   g==;
X-CSE-ConnectionGUID: yaJ53ATETU+tC4Xa2AzLUg==
X-CSE-MsgGUID: y3UjNuLrRMO20dl5sXnxpQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11583"; a="88246918"
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="88246918"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 23:08:37 -0700
X-CSE-ConnectionGUID: RE1vJfeeTz6qixDElANhMg==
X-CSE-MsgGUID: W2fhUM29TRm0mQev9Z9glg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,233,1754982000"; 
   d="scan'208";a="182769941"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2025 23:08:37 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 23:08:36 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 15 Oct 2025 23:08:36 -0700
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.23) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 15 Oct 2025 23:08:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cAFA5YGpUbD9/fhqVeqRGQqj9CphLeL30nc63ug+bmNGkIiRHcFgvVhKOl2tvncfJVqWeKThqVBu9rRy/xEpctDububuJJBJ6q9RI/aRhXiljQGAKVhlipOV2Q8kk+n6BlfL13YO4zuIXT16X5vp783DVOIjyWdVEUcBbXNKTqRixm390sU+vS5rdzh5MEYyTb50ZqhZCVvs8qTsnnds28arQqxZCA0mGJERuZeNq3JEF5SJfzmRUi1gwQWsPDEkQVB/VvnjOLSj/vRVDq26LZsxhw3R9IhQkkyY+1shmkuJl2k0k5CO6Ck1AoBsGGU8w8HtdnX5kshr0LjIKjeL6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hmuhObJfZ20RvmA6d/Zx1zXkX0JQPmmurlLqeKlG9rc=;
 b=I5FQ8+SKCY0S3J1vRbW3Tdi6Ojv8c98D/1eoSu/wDtmzhv5ml/UdEYvCUwXLwCb6/1h3/YiT+aNhIquvGQf8UIUfPPl4NAD/FCtAPIo45fgNvGqsqIY6kqmx+71u2AHOJlirb63F0ZtDICye3iXp6t6WGI/kUlbH+QnyRkLhzgK4qp1pU/pX66mgER0QUuoqOwWFl8OqUgMtxMbkF8fM9cOduQ4Ur2pgoCe3HhYwqCrMV4Go/M2X0EgeAFOtoST7/EICLaJ7zb/zp5/IFzvKASrLekBHrKXbuL+r0kdwOiFpLcNefijugeAkQ5vgU79pZiiquXUqnjz7QEbwMN+2xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW4PR11MB6785.namprd11.prod.outlook.com (2603:10b6:303:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Thu, 16 Oct
 2025 06:08:33 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9228.010; Thu, 16 Oct 2025
 06:08:33 +0000
Date: Thu, 16 Oct 2025 14:08:26 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:b4/sheaves-for-all] [slab]  de840681a1:
 BUG:using_smp_processor_id()in_preemptible
Message-ID: <202510161416.b7adda58-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: PS2PR01CA0017.apcprd01.prod.exchangelabs.com
 (2603:1096:300:2d::29) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW4PR11MB6785:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f30fb37-ec41-44c4-bb7e-08de0c7a6fa5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WKP+vDmASKCBV9z9bt6bsbjXbD7Ks4YBVQKl2HfAR3ep6XztfaIGI2Eq+Wt4?=
 =?us-ascii?Q?IU0gHtGY+CKq/tAdFQHRD/ZNbt4i/sZKOKwfk39DihU/TYMDagpFuyAmh3l2?=
 =?us-ascii?Q?qW0A+zhpV+p+718ijIB761xvepUEjZYnnX0j+x3JPuTdRk/mUvCb1sV6Jqj/?=
 =?us-ascii?Q?bFrwp3vlYw4LSqc8aYP6XOtjj96pRANeNElet0CBHV5QEZ37wZTXPSv3RjNs?=
 =?us-ascii?Q?sMq9AmD3SR0p+2N2kUNe/FGY9BIegHuF3ttYgsmnwHZI/DOR7DhezTuiWZyN?=
 =?us-ascii?Q?vMSOIUJSEvJQG+C6/Vm+YixTBH7Xh5VCXvaVHpCZ4lHUs8E6lj2hCjzlmx8w?=
 =?us-ascii?Q?XMa9vkzJ57SrmR/6Qbx+QmMjTNcT+IQkqtnmuSOhm+rhWJKaxD9tJAbdGgWf?=
 =?us-ascii?Q?ti+IKtcLVovw5pyP26TglzoBMrqiRd97RRpQmS12CbcTEVsNxv/ZambPo4K5?=
 =?us-ascii?Q?JlAN6+LcnwEVmgEyGl8cviA/fjAn1RDM7u6mWa37ILtoTbMHRRNiiHV04err?=
 =?us-ascii?Q?Pi/GYI+hmIYnXtTDDCkxpAXWtYrCVhqP93noJGup8mx/Z4+DhnevuRVbnpJl?=
 =?us-ascii?Q?TcEii9ELqgMaZevDcGa285zHPVku3RrCA489F2mq+BwmevjCI0ItA9sepi0b?=
 =?us-ascii?Q?atWspwJqzPAJgIVQmvTUIppC4fIA+d6m0NBxUNP0jeBHnHr9nPBzfhJBrJvu?=
 =?us-ascii?Q?g5ETRYpiN4qYaMrOdW8xZa3CbGf/FBHEIq0YDhlz/DZj744vEVcQyptlMSXc?=
 =?us-ascii?Q?BABfnhw9m5oYuyR9bU3PuOGdQVXQr52kHWibgs06Y9PAU3k2DD34jmq8EMwu?=
 =?us-ascii?Q?vSBHdlwGgoI997QnpwS+Qs/Ppmb+0dmInx+WZihSePRr2uAlUTVwMqEPsW5E?=
 =?us-ascii?Q?TN3Lwna34dMJ0dJGq+L4URZUFvzM1CnpqSTKTx9F0OYzLCIHn5cqvjtnvT9u?=
 =?us-ascii?Q?NQ2DSHrXjewuYgKeUDL0nzJhbS7twhc4gkcXpL66Hlt4fT2/mjXqs/IzGJcF?=
 =?us-ascii?Q?SO71RzZg8Z36EAaF8MoaKXbiKWdpQ7lp9tEwkQCklqqrOIIxCBU1X778Gz2g?=
 =?us-ascii?Q?Jw42PWFWBqeCk6eHF8e26/gz3mSUc+2jtjW+Me+fbdSuOkv27ndtKKy1kVsY?=
 =?us-ascii?Q?oWWd9OIDXmbjKTAdKsLmceqZ+pK1H2MwQLDOwGeP83yVzmL0KyDxUb/jNrSP?=
 =?us-ascii?Q?5eWrQaAAxBjS/mtfpw7uNnvfw9a6n7UOWC6Zr91+fPGgYKLo1GmcFgNyYIjz?=
 =?us-ascii?Q?SFacl6l5o+zxG4COgOnvhGT4lY1Lffm26eyvOVJ23X0lgYLDjL2Rqdu9v2Ck?=
 =?us-ascii?Q?wJ47pkKQ/+kCshWMTHLrTSAvTRJhNayiRaONupg1RmmY01Zg9ZfPeVeH3W+H?=
 =?us-ascii?Q?XhI/G9GWW4cruG1ELy0Ll7VYvWnXhKhoiywNE6G+XkUR2MwTR1+bQTeblPSs?=
 =?us-ascii?Q?W3LMlIpOsCI=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ARmbg7asCj9wd9CTzHwqhyzrzwMVgYFQ1ET9HRllIkDctkfmOH9mxDnAKs2I?=
 =?us-ascii?Q?eCjKrj3MQU8DHECaH24HsO689pvXTOCfmkyVYZ79Zk6Zzcq9raxdS8SLjSmV?=
 =?us-ascii?Q?ypxx3X+Jt8+INya2AR15EJGNqlMoxWdechMvA0Y5EXFu1AK/JAlq80jYGzV4?=
 =?us-ascii?Q?eT+l969h+hQxJD8kR/0FJ9HwvxNfLQo32crrM2KjI8Gz1PCXH9TDdldfEKwr?=
 =?us-ascii?Q?y7ntmvfhJiyk9LQnZKw8T29ghgX+qX33uRwT0aangCQi3TdCfAqSiFB1n50Z?=
 =?us-ascii?Q?kjpvfWW4I3P3DuASfMi2cnIcfHO/cygYl8L1KhDhL+urrVx4erU37QhFs9ao?=
 =?us-ascii?Q?Y4pleEyh9h56+L2MmS9K6+wV57bfyMoRF6KRYDOyqp0JCyfxzR5r4B54yAQ7?=
 =?us-ascii?Q?dWI9RhcWYm6zoUq7bG20SoURWcOX8QB1f7n3U+xk8tx74vckqDP5ZGVqNnYr?=
 =?us-ascii?Q?rdhiLv9TdpU4iMaa02lE61Qb1/zJuQLrFyaKTvHMeJ9hTo83+2bwwaeDrWWd?=
 =?us-ascii?Q?3eI9nuf6tXnqj/Agq1EM+uF3uIJKkMOSfVaOpwm34HQygS5QKDUx4Z60pLI2?=
 =?us-ascii?Q?h6VgA/DWrpejmYJCMp7waAZ4SdBUm59JuPiRiEWTIj+oyBpyWLhPRGTaoENz?=
 =?us-ascii?Q?tLfxZR8cykhwtN5GC5OoJO8r3OBxp8r2lPnj4M/+hUUYYtZvMPKPU6nRiko+?=
 =?us-ascii?Q?xUqJTKjXqMMfax3+KW1dC/FL4FN0TSK8JT48ZsjCHBUJItq1xem0zjnte3tx?=
 =?us-ascii?Q?/sDBBXAAxOdnwfOikNha4nFwpFvpqwvV917sQ32b8zgi3B+EfcjSVCMffJ59?=
 =?us-ascii?Q?X8Kk4+XzSuSY+avte7rtpqIHMiO7uo79tMljjvPDlcsngvT0dD7JVDxVd7Uy?=
 =?us-ascii?Q?iQzHdFmABDucnhQQElznLToKQgP1H5E3EIo2WlGiVG3tLj16KC2T7sfXL2Bk?=
 =?us-ascii?Q?aETcXULT84ZpA7I2PSyhIySvwKborYkYZCihhOIz5ZAgHUa/gTDie00L4uNv?=
 =?us-ascii?Q?dL7zPTIpu0m88yLHzd8MAoPMfxdF6PM2yaUCIgu/ZbF1C1/t3oIUSdswNO+X?=
 =?us-ascii?Q?8FVGhJaKW7nAQKrNo7enIHYgP9w3hbvIU9TVp1OPX7gvy1Oelrr2gJrV8AxV?=
 =?us-ascii?Q?VS1KQ6cgJMHbHmykfssoXFm2+nVdAp4v0pP2bztJ/8SAZJZqpaaMIpjEcYx4?=
 =?us-ascii?Q?/uXhjt2xPKdOZXnlbJfKgasA+gKBkc0LJHky/J74jqCpvpZRvw6nACLHoeCL?=
 =?us-ascii?Q?7ojI2aTivjQ0ekUNswR2gvndmqgUh1lvFq2ragy8BLO+dU++nhnP4I5GVuQj?=
 =?us-ascii?Q?N4RsRObVDSwjG8/g/0J6fQeU9zpeIHQP4bbb3e8QRGkHPJ9TEWy2s0z9Qlr4?=
 =?us-ascii?Q?fDSPQxb6gQr1KK6mMZKoohVHa45MCTyaTHUciNqivyne+mmXgKEIMfb1N9fV?=
 =?us-ascii?Q?XQ/i/siR9b2Qs+34mCO1F/8u1WzuwjSBEtWDsXy6Dub8ct+9lQExfhCKdonW?=
 =?us-ascii?Q?m2qyCmVyXlLblli5+6XqalPsDQX68Lq0nAY/XldrX2P8IggXoRt7wbARoclK?=
 =?us-ascii?Q?L0mvGOF862GzPTxIulW1g95e0WeOitpx6b9f25i6mcxc4X6IjW4taxap+dlM?=
 =?us-ascii?Q?SQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f30fb37-ec41-44c4-bb7e-08de0c7a6fa5
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2025 06:08:33.4988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IN3oKXq3a/wP0TIgECyL+1sPlBbbCx+unflbchGJUPjHy6TR9GZtov4uL4MeFTUj2vmpZuP7kTsvr+wTD7rzSw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6785
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam01
X-Stat-Signature: a3ymt1ywfj3z1e6ce17zwfpq49puy4by
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DF6B180006
X-HE-Tag: 1760594917-457178
X-HE-Meta: U2FsdGVkX1/YxkBrKkddRlALg17ASLJ8nS/XQEmx1FP/j7t4wtUIeQktkuGIwTm5lpoT1enX9HSKcwSnNGVP1Wd5gB1vLLmlwHZv/7m7YJk23P7XLPoklU9ZoeJ1j36kgktN6zhFOY8nnZ6fso5yP00k7lND6av7CGW6c6u+3+NAPw4NIA3oTreMgeqUlk+XspQ6kklrSaZXpUTqPnpqEe5CHjH1LJFNoJDrVDpCNZlItUEzfZv42OSEk2xcEq6aSw8/w18obGCDJItHGIf9xnta8glVXRCVAkk4xJjWJbBG73tDp74PYjIqTc1/KwFf8rN995DIOSSPPak3HOLfuT9m/ThFtFrStwZzmEpv4b7f9pXa9cqM/m7+UdlJQ9n4UwFYixLOosSGxNxfbpOfQsECcXnEkzIzmCnN12ir5zPm8dd6HUKnuEKNB7BBQVD0Kz6M0TVl4TNb22AjLV2QAhCc2XwoJrGtBpPLTD3NzDOH7e+3S2OGvP7J6iUZkj7KWCwi0dbnWN6z4uCB8x2WQoZd9TUN5tB+uqv1jDWZryttWNHmfLGewg/uicxikpPqAdxcOFYlP6qdeRDF2VVd7/1lIzKbNdMr9G/+wu0ROXHJh5AYaO9cfst5iQFy/Q7VGafg8zLn/5IhJl/ZZMGqBqBuGtaHFiuJraCZ07UUT4LPaz3Y/MbBTIQ3/VocEtPIxNqFUlSa6U3V8wF4MC14zT2jDNXjkhVlnLQ7HmVD5WS6uwHrECU5jU1qUvs+gwFc1jLEv77+p0S9WR28XPl0uGUyfDQp/zaNFChy8Dgt0U2pPLyxXLHCpS0gfwMdBUgZNypbMYKUtFi0gGbmrr37RIDSy8SinFzLF4weCt9IrtShX8wrsfHwwY0KLpbDsORIo8jflg2I6c/Cr200KfvzNJsa9C3snxK9rhu+ApaN+PK9w0sySLYtfDK4Sq3ovZmgYpiknM3JHFe4OA30iZg
 Tg4krbNL
 fki2RHMsaQlCbb/FG88EUnySL5dLl+6yQ+/03XD1scQHkDdpJ1sAZyWSxHKkR8h6e0Pr9i8f5fkdREK/kR+w4Ubwevqr+bkghTNexoZF9K1qLt1wfzfpUWVLNx2ROpScZgFT97Gqp/Hb3C4x/yBGuoJ7m9MvgwqPWw1xi4fbVwJ5HPbLPC+niIH51OyLqvADXTFM0qArdr6UhByRkF2BwswH00TZY1X4fzV1PG/cjw1lcHaPwjk4xJq9tqURtUXpm72yEpa2K7GDcQM/bN18xCl/zccU/l1gJV5YluKUfYYojB32t5xDy8fg2LozY04v8rSwF4OtI/0v+yGrEUqe08S3sEE7OqylKynEz4S/CLYg8oWJqdBdBDtc1IK52r7qzKOSX3qESY0wlTWF+9Zwyz92BsWBzLsK+q/jbaJvq8Ij05ncjjnkpanTjQD+vM8vTB8InQTZlf7ICDJ9IuPfP4Hqh2dUegWmJy8QAIDshgqznn4SvpD7Mnnr6CVqiYsf+4FweNvngeH9fwZi1Ju+WL2Qu89yDhfMe0ApEBQRoe4+kmN+KDCwzMar+PtPI/ZaVeJ0jVL058NXNLR3x0oYDoaUw8PDD+wendQlaOroyjIXe6RUyO812Ej6F7k50QP4TuDrB6YINHT9ypRAmfhjAg1tiYo6kVuxZnISytZyDEbeWNnOxCMZlZc0Eag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:using_smp_processor_id()in_preemptible" on:

commit: de840681a162e0a5a0862e7a0b495fb34deab7ef ("slab: remove cpu (partial) slabs usage from allocation paths")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git b4/sheaves-for-all

in testcase: boot

config: i386-randconfig-002-20251015
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202510161416.b7adda58-lkp@intel.com


[    2.688724][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.690336][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.692339][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.693316][    T2] Tainted: [T]=RANDSTRUCT
[    2.693316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.693316][    T2] Call Trace:
[    2.693316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.693316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.693316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.693316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.693316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.693316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.693316][    T2]  ? copy_process (kernel/fork.c:184 (discriminator 2) kernel/fork.c:873 (discriminator 2) kernel/fork.c:2012 (discriminator 2))
[    2.693316][    T2]  kmem_cache_alloc_node_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4993)
[    2.693316][    T2]  ? copy_process (kernel/fork.c:184 (discriminator 2) kernel/fork.c:873 (discriminator 2) kernel/fork.c:2012 (discriminator 2))
[    2.693316][    T2]  copy_process (kernel/fork.c:184 (discriminator 2) kernel/fork.c:873 (discriminator 2) kernel/fork.c:2012 (discriminator 2))
[    2.693316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.693316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.693316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.693316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.693316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.693316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.693316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.693316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.693316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.693316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.693386][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.695335][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.697340][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.698316][    T2] Tainted: [T]=RANDSTRUCT
[    2.698316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.698316][    T2] Call Trace:
[    2.698316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.698316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.698316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.698316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.698316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.698316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.698316][    T2]  ? __set_page_owner (mm/page_owner.c:173 mm/page_owner.c:214 mm/page_owner.c:333)
[    2.698316][    T2]  __kmalloc_cache_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:5455)
[    2.698316][    T2]  ? __set_page_owner (mm/page_owner.c:173 mm/page_owner.c:214 mm/page_owner.c:333)
[    2.698316][    T2]  __set_page_owner (mm/page_owner.c:173 mm/page_owner.c:214 mm/page_owner.c:333)
[    2.698316][    T2]  post_alloc_hook (mm/page_alloc.c:1852)
[    2.698316][    T2]  prep_new_page (mm/page_alloc.c:1860)
[    2.698316][    T2]  get_page_from_freelist (mm/page_alloc.c:3890 (discriminator 1))
[    2.698316][    T2]  __alloc_frozen_pages_noprof (mm/page_alloc.c:5184 (discriminator 1))
[    2.698316][    T2]  __alloc_pages_noprof (mm/page_alloc.c:5218)
[    2.698316][    T2]  copy_process (kernel/fork.c:367 (discriminator 1) kernel/fork.c:881 (discriminator 1) kernel/fork.c:2012 (discriminator 1))
[    2.698316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.698316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.698316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.698316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.698316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.698316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.698316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.698316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.698316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.698316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.698369][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.700334][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.702016][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.702316][    T2] Tainted: [T]=RANDSTRUCT
[    2.702316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.702316][    T2] Call Trace:
[    2.702316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.702316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.702316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.702316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.702316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.702316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.702316][    T2]  ? prepare_creds (kernel/cred.c:213)
[    2.702316][    T2]  kmem_cache_alloc_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4948)
[    2.702316][    T2]  ? prepare_creds (kernel/cred.c:213)
[    2.702316][    T2]  prepare_creds (kernel/cred.c:213)
[    2.702316][    T2]  copy_creds (kernel/cred.c:314)
[    2.702316][    T2]  copy_process (kernel/fork.c:2046)
[    2.702316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.702316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.702316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.702316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.702316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.702316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.702316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.702316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.702316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.702316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.703358][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.705335][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.707023][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.707316][    T2] Tainted: [T]=RANDSTRUCT
[    2.707316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.707316][    T2] Call Trace:
[    2.707316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.707316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.707316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.707316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.707316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.707316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.707316][    T2]  ? set_kthread_struct (include/linux/slab.h:957 include/linux/slab.h:1094 kernel/kthread.c:125)
[    2.707316][    T2]  __kmalloc_cache_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:5455)
[    2.707316][    T2]  ? set_kthread_struct (include/linux/slab.h:957 include/linux/slab.h:1094 kernel/kthread.c:125)
[    2.707316][    T2]  set_kthread_struct (include/linux/slab.h:957 include/linux/slab.h:1094 kernel/kthread.c:125)
[    2.707316][    T2]  copy_process (kernel/fork.c:2110 (discriminator 1))
[    2.707316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.707316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.707316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.707316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.707316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.707316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.707316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.707316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.707316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.707316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.707369][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.710331][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.712340][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.713316][    T2] Tainted: [T]=RANDSTRUCT
[    2.713316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.713316][    T2] Call Trace:
[    2.713316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.713316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.713316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.713316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.713316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.713316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.713316][    T2]  ? copy_sighand (kernel/fork.c:1611 (discriminator 2))
[    2.713316][    T2]  kmem_cache_alloc_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4948)
[    2.713316][    T2]  ? copy_sighand (kernel/fork.c:1611 (discriminator 2))
[    2.713316][    T2]  copy_sighand (kernel/fork.c:1611 (discriminator 2))
[    2.713316][    T2]  copy_process (kernel/fork.c:2176)
[    2.713316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.713316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.713316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.713316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.713316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.713316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.713316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.713316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.713316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.713316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.713362][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.715337][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.717345][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.718316][    T2] Tainted: [T]=RANDSTRUCT
[    2.718316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.718316][    T2] Call Trace:
[    2.718316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.718316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.718316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.718316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.718316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.718316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.718316][    T2]  ? copy_signal (kernel/fork.c:1659 (discriminator 2))
[    2.718316][    T2]  kmem_cache_alloc_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4948)
[    2.718316][    T2]  ? copy_signal (kernel/fork.c:1659 (discriminator 2))
[    2.718316][    T2]  copy_signal (kernel/fork.c:1659 (discriminator 2))
[    2.718316][    T2]  copy_process (kernel/fork.c:2179)
[    2.718316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.718316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.718316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.718316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.718316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.718316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.718316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.718316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.718316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.718316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.718387][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.720336][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.722027][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.722316][    T2] Tainted: [T]=RANDSTRUCT
[    2.722316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.722316][    T2] Call Trace:
[    2.722316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.722316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.722316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.722316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.722316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.722316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.722316][    T2]  ? alloc_pid (kernel/pid.c:184 (discriminator 2))
[    2.722316][    T2]  kmem_cache_alloc_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4948)
[    2.722316][    T2]  ? alloc_pid (kernel/pid.c:184 (discriminator 2))
[    2.722316][    T2]  alloc_pid (kernel/pid.c:184 (discriminator 2))
[    2.722316][    T2]  copy_process (kernel/fork.c:2197)
[    2.722316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.722316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.722316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.722316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.722316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.722316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.722316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.722316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.722316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.722316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.722693][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.724339][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.726341][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.727316][    T2] Tainted: [T]=RANDSTRUCT
[    2.727316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.727316][    T2] Call Trace:
[    2.727316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.727316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.727316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.727316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.727316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.727316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.727316][    T2]  ? copy_process (kernel/fork.c:184 (discriminator 2) kernel/fork.c:873 (discriminator 2) kernel/fork.c:2012 (discriminator 2))
[    2.727316][    T2]  kmem_cache_alloc_node_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4993)
[    2.727316][    T2]  ? copy_process (kernel/fork.c:184 (discriminator 2) kernel/fork.c:873 (discriminator 2) kernel/fork.c:2012 (discriminator 2))
[    2.727316][    T2]  copy_process (kernel/fork.c:184 (discriminator 2) kernel/fork.c:873 (discriminator 2) kernel/fork.c:2012 (discriminator 2))
[    2.727316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.727316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.727316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.727316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.727316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.727316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.727316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.727316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.727316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.727316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.727388][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.729337][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.731340][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.732316][    T2] Tainted: [T]=RANDSTRUCT
[    2.732316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.732316][    T2] Call Trace:
[    2.732316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.732316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.732316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.732316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.732316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.732316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.732316][    T2]  ? prepare_creds (kernel/cred.c:213)
[    2.732316][    T2]  kmem_cache_alloc_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:4948)
[    2.732316][    T2]  ? prepare_creds (kernel/cred.c:213)
[    2.732316][    T2]  prepare_creds (kernel/cred.c:213)
[    2.732316][    T2]  copy_creds (kernel/cred.c:314)
[    2.732316][    T2]  copy_process (kernel/fork.c:2046)
[    2.732316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.732316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.732316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.732316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.732316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.732316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.732316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.732316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.732316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.732316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)
[    2.732364][    T2] BUG: using smp_processor_id() in preemptible [00000000] code: kthreadd/2
[    2.734337][    T2] caller is debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.736018][    T2] CPU: 0 UID: 0 PID: 2 Comm: kthreadd Tainted: G                T   6.18.0-rc1-00012-gde840681a162 #1 PREEMPT(full)
[    2.736316][    T2] Tainted: [T]=RANDSTRUCT
[    2.736316][    T2] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    2.736316][    T2] Call Trace:
[    2.736316][    T2]  dump_stack_lvl (lib/dump_stack.c:122)
[    2.736316][    T2]  dump_stack (lib/dump_stack.c:130)
[    2.736316][    T2]  check_preemption_disabled+0x98/0xa8
[    2.736316][    T2]  debug_smp_processor_id (lib/smp_processor_id.c:59)
[    2.736316][    T2]  set_track_update (mm/slub.c:1035 (discriminator 1))
[    2.736316][    T2]  ___slab_alloc (mm/slub.c:1046 mm/slub.c:4511)
[    2.736316][    T2]  ? set_kthread_struct (include/linux/slab.h:957 include/linux/slab.h:1094 kernel/kthread.c:125)
[    2.736316][    T2]  __kmalloc_cache_noprof (mm/slub.c:4544 mm/slub.c:4929 mm/slub.c:5455)
[    2.736316][    T2]  ? set_kthread_struct (include/linux/slab.h:957 include/linux/slab.h:1094 kernel/kthread.c:125)
[    2.736316][    T2]  set_kthread_struct (include/linux/slab.h:957 include/linux/slab.h:1094 kernel/kthread.c:125)
[    2.736316][    T2]  copy_process (kernel/fork.c:2110 (discriminator 1))
[    2.736316][    T2]  kernel_clone (include/linux/random.h:26 kernel/fork.c:2610)
[    2.736316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.736316][    T2]  kernel_thread (kernel/fork.c:2671)
[    2.736316][    T2]  ? kthread_is_per_cpu (kernel/kthread.c:412)
[    2.736316][    T2]  kthreadd (kernel/kthread.c:486 kernel/kthread.c:846)
[    2.736316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.736316][    T2]  ret_from_fork (arch/x86/kernel/process.c:164)
[    2.736316][    T2]  ? kthreads_online_cpu (kernel/kthread.c:818)
[    2.736316][    T2]  ret_from_fork_asm (arch/x86/entry/entry_32.S:737)
[    2.736316][    T2]  entry_INT80_32 (arch/x86/entry/entry_32.S:942)


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251016/202510161416.b7adda58-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


