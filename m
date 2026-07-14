Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0950C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771076B0098; Tue, 14 Jul 2026 09:48:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB166B0099; Tue, 14 Jul 2026 09:48:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59CB66B009B; Tue, 14 Jul 2026 09:48:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 202C36B0098
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:48:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AE9FA03F1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:48:56 +0000 (UTC)
X-FDA: 84987513072.01.88E0016
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	by imf25.hostedemail.com (Postfix) with ESMTP id 80887A0013
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:48:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dsB/HmsW";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784036933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hl/ZhAQ1yl17/4DGa7mrnBdPAyoXp1z9enw3Zf/1144=;
	b=NDhKI6G9wAIWlMgd+02YJaGZEWVLU0sTZMhWvlbPN2D5/2wfwV4NkfwuPiRYJqRoiHVgEt
	LMtoh61x/GlkESnoWTatxi7WPKbvvneOcO3E1ksNNZ1uDEF0gJitsBSofptEmJjkLRjInL
	9FbYJU0a/eJc04TgxTKmWApCKYmW1rw=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="dsB/HmsW";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf25.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.20 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1784036933;
	b=LVzGDCbkDG1+xfb8cd640oZusTOpu7EDJvuKKHfvoALg782X1ceutMLzNsz9ik5D6qhN7i
	6fVjtNJ8i1cvUyJz+tDrZL7nfH+upO3Qn8jJj2nLKitC0EzxIUOmsabdXWL0T+B+RxZZdT
	yPitRYCqwMfqejARcCvYml56xGqo6L4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784036933; x=1815572933;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Vbg30Wg/Ylfsmx34N5SLJuGNSdYiyAoie5W/ufnops8=;
  b=dsB/HmsWHzsrdJ3pn62clxKI4Fcco9IIK0FHE4ccvbkIXxP0wAuGKVWb
   JQGHedbiUM1aIo5IITo9XZi9G9WdOPZLfhsO9Fhb5nkNQhCEsZzlMwbZN
   gArjQvKdBGikkLxz7Qoa/s7zj9ySTSocYUDjfTsdQ7sKB0R07ILLSRKWH
   EBPIo5WJVyrkCDas2GTEAX+N/FzczLjk2D1XxdV0r9amashU2N4mPRLUv
   NlCO+bLeFzIjwBL2b6s6tKD/EFHM0TJ9MR/k+vCJk3FK3cN3/cO73rkz3
   MSW/3fpjFJI7rgx4lqYcht9gCuEU+w8+4QR/Wd4HccJXxcsr4MH5P4Jx7
   A==;
X-CSE-ConnectionGUID: yVXJ7K4uTVayFxY1D32DwA==
X-CSE-MsgGUID: zG7xrw4rQ3yWT/Vo8k8DSg==
X-IronPort-AV: E=McAfee;i="6800,10657,11846"; a="84443433"
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="84443433"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:48:51 -0700
X-CSE-ConnectionGUID: Fto0bBBmSre8O0A1ynVCfw==
X-CSE-MsgGUID: G+CFWhOdTui0Hy+zoOawMg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,163,1779174000"; 
   d="scan'208";a="251906481"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 06:48:51 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 06:48:50 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Tue, 14 Jul 2026 06:48:50 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.35)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 14 Jul 2026 06:48:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Vetdt/7hgpap30VcFBijYsKQbP+k2bZ7HHRN9CrjPHbgRcYnD5PC09z45X8un0Lq6NuzREbEL/7uQEvmYgfhwXnFclL8Y91beeEGX3BGFh2tlzQw90vu6FNo3uMtEdOQNaTjsaK29ZKBwYg063t6MNWeJiPdOFSJN/8qRPGOuwkDfiizOeW60E4wnkatlf6fF3JaPzILlPcVf4c1OoeIlRErJVfaFKteJ7ifnAWDSg2WshVVlgvRphg6yXrQZY/gYLJdyDwdQk5UO32/YBPrXDjXIUy6sfT7J5nUCoqMs5ogYQlXAE1V2BhCvLASHaLuBcQKb9ALRy1zdvLNvp0ZVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hl/ZhAQ1yl17/4DGa7mrnBdPAyoXp1z9enw3Zf/1144=;
 b=U+PqmGpzKrAGJl/jacnNKJuz8n63VjnHSazwtwmS0/tEWlXwbGxIh9K2c0oagQOFl0W+h0rVUOdoMwavz3PqglagrQXWxmArOHLSK2aFWOiPunVJNvSZO7tU7TlKVkdXFNwKdocW+OjMOgVNtgH9uKEjNV8ecBuFF1C5NJ6fWJ6vdPG0m8EWzRC5DQQNyuP0Ej6iRwmFGWMkSiQHGN7r2QuPWM/xsXyyf0TKb0QwIoSKfrvv0sNL0ywCG2/LQSdqbMdya2nszh72X9psx4eKq9nTC1s5zHKit7ZoiNsjgFq9OqzXCAeoA8FOwpa3Sl812SeycyzXU+v02Qs8XjOBSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
 by SA2PR11MB4890.namprd11.prod.outlook.com (2603:10b6:806:117::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.223.9; Tue, 14 Jul
 2026 13:48:47 +0000
Received: from SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7]) by SJ0PR11MB5815.namprd11.prod.outlook.com
 ([fe80::7c33:9702:ea7:13d7%3]) with mapi id 15.21.0223.008; Tue, 14 Jul 2026
 13:48:47 +0000
Date: Tue, 14 Jul 2026 21:48:40 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Harry Yoo <harry@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Danielle Costantino
	<dcostantino@meta.com>, Shakeel Butt <shakeel.butt@linux.dev>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [harry:kmalloc-no-objext-rfc-v1r3] [mm/slab]  d6967566f4:
 RIP:mark_obj_codetag_empty
Message-ID: <202607142131.f70bbad3-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TPYP295CA0031.TWNP295.PROD.OUTLOOK.COM (2603:1096:7d0:7::9)
 To SJ0PR11MB5815.namprd11.prod.outlook.com (2603:10b6:a03:426::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR11MB5815:EE_|SA2PR11MB4890:EE_
X-MS-Office365-Filtering-Correlation-Id: 398e4723-b5b8-47d1-c875-08dee1aea0d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|23010399003|18002099003|56012099006|11063799006|3023799007;
X-Microsoft-Antispam-Message-Info: t2AdzroyfncPDNPAOq2IhACq+tkGyBGt4FthBfZ1fkwPhVbgKKuY8Za7n9CrE/3GCKrMnGsSZljSHO8IuRr4KgJn0nZrx8e8eonrajNKxy+wXrNuTjFgs5g6kn3Ux/JBPiRSw0UWeLkMNZ1+bQa13k0t13OiCngoN4UOMJWl+3Vp21M/WuWu8yWYj6oq8nFcj02X84pidbnlKugpyCYR2BIrntjb3ILUXRn6BYNxfXQlJEEMOXCeoctDXBteb4XE7rp+IgbnSxV/tlCDdzcDqSKtdSMEDyT8RmJ4qizKjwRMwcnPZ8B4Z3Erkjgv4agZKa/DKaLtn5DbuTNyIC+bGUJrZkkuRj2XRTzUmpS5dObLv50wFlzq5na1UwLEyWK+xRWcJCpVSpg0v7uG/1NCK9KZHHGNHBWr10LTY5FcjG5iIuAfZY37LI4gSJPf90dZ2IZFOYEjoaNkXmcfF+0ncC80jackw79nauKfsQkQ/95MQz3GHZTAo3JSoWVgaxlGnDgIgcvpTRDiRcmqAppi+riXuEOHz4yHorjWC8Kh6n9ANC0RA/psMZoyx1LhSZnGemwq7gYnzvHplO3Wrrmtppr/QL8xXgF/fVNnN47dYKo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5815.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(23010399003)(18002099003)(56012099006)(11063799006)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pCJeqDFcHiH4+9oiuZy3Da04sGEBkedxzmNDWb/Qm3PeSkgLDBfv+GN88GdQ?=
 =?us-ascii?Q?GfVY8jR3+ffHodAkRZ2QhjvHzCT/DOkWu0OFEu8UbZ/h3dYO0MTRR98J3X0m?=
 =?us-ascii?Q?apTZakksUu5V55UJb0s3fiHpXHsavztjlGamJc9KODca2xl66sRRyvIgU0WV?=
 =?us-ascii?Q?D+/GSlCIs89m1M+Bn0Q3sq4lsMOZ5qM+W/7sf32BINWCdlfMpPYoApySTffY?=
 =?us-ascii?Q?Ip2qammt/a2cZp7upbr7RPIagNrDe+ltPQfid2OTPQpQSjKygol2cWqNwyul?=
 =?us-ascii?Q?V6qnkirEnt3HGmJh+ZR5H3XbSER9RqM1c9VHROHRdiaagQcwOe7zuEoE4YQY?=
 =?us-ascii?Q?6/4ucBw1HmEkGx9DCeEULwJX1g7h5uuO2oXBcxrqSHfCsnfJQ9yVHD/9eh4w?=
 =?us-ascii?Q?ynVIJa3BeOsVME3hsO5WgAl7n3i+oxufMVfQU6SQ2lYoYmTHI1t89ycblHgi?=
 =?us-ascii?Q?SF01WWzhuVBYZT6D0dgYatRQfQJcBf9dTZsZyUxphTjoo6do91rfYgnEvCEY?=
 =?us-ascii?Q?3NR9o6wd1fxafeK2JDw3USNg8SPALM8SIALX8qT1nqNvzkyA/KZIEJyG+e4s?=
 =?us-ascii?Q?Z0PDfOTQg5UMry5N48jye/2etJo8GmOu1wVGLyViT9Fr8x5FOvG/OMOLqQ9O?=
 =?us-ascii?Q?ATlt5NqDkRAoL5buWBqfQnwDFCzwgLMiELHzi2xy/sWCVl5gYXzTxPqP4uY5?=
 =?us-ascii?Q?263h5EQnMe4+Q0CcOfDr7EAryii6KuesBQQDjYkhcdgh2Q2pG8h9I3ljt7Fk?=
 =?us-ascii?Q?CjicYTtszHL49t/fGeMX7jS2+H1w3R46az7qzDonLlV1+f551eawD+i0sbnV?=
 =?us-ascii?Q?PqvT55EFqtKL5YmTDgqzpujeAXyMKV86ej7mJaVy5lqrPKWdPgR7G5bSRo19?=
 =?us-ascii?Q?fEF6L1gnmrIupZMOxU5wwc77/ZOPySiJTZMkd/pw1nugp7oGyDkbDwcG6QtH?=
 =?us-ascii?Q?zlqlDZ5dw0KVcUNrc27NTukyGkoWhpEIVYeNhulPJ85Cu/YWLgSqlzAvT8Uu?=
 =?us-ascii?Q?Xx5F9hNo5I1D4WGkwbvsC9hGRMnf/N/tPsLkN/fUvaVF90PHAuUTKaA+pqea?=
 =?us-ascii?Q?mLNgK1zqQoNVZPjx20YkwInsvJQc/R2EeBpEbMQqynFKTIGaZCFUYdN/HmPd?=
 =?us-ascii?Q?UmXWWyKSKTombZGrm6+d89n24CSzCuhTaJNZ+ZgJ6Gr6wz76Q9J5Vy1a76gr?=
 =?us-ascii?Q?02Su85+cE98xwlDjvvsoh8BSacHOH6tc3QrPz92iPGG6lmylHDfB0sqPKi+Z?=
 =?us-ascii?Q?kvph6MmprzHdManaHgWKBL4UDjoq+K8UFBrod0pUDxW6BgkCPjeIAtj1b6pI?=
 =?us-ascii?Q?tYUpytjH5B6VGb5Y5vjwPy6yXaiZZUAZwaNj6cInCFN0wcFI0Yb31bLnBuS2?=
 =?us-ascii?Q?cjdKm0O7Yc8fozhqKfppd3BKQB30G+74VxgYwiqqrVLRsaCdqnZmZek4B+UJ?=
 =?us-ascii?Q?cVTzvgAnEw+yhBVPu838wmBNpDrlJ6ve5cIzLWv3lRNUTkUZMHLujVuBTA5V?=
 =?us-ascii?Q?XMhM9+pUxMO2SdKJ9xf37Ow0Nub5cgu3VkWClrEn3YWZRO8/XUGyb6oiBITH?=
 =?us-ascii?Q?aPNZ55vAsuuNDggkPosKj21irpYEj69NKVFCeMIkP3812xTexI2HOe2C2Fke?=
 =?us-ascii?Q?Z8zhggkMd+qHGrT2kwjKWX0J0M93Tb1GHVCj8tNGKlj3QkKvTW9C0tvCrAov?=
 =?us-ascii?Q?4pq0CU3xYDimfDdGpvxjKjklzL6CxIPpuV9CYv883bGmKEuhNoM6eASANwsy?=
 =?us-ascii?Q?rlmgFFpIzg=3D=3D?=
X-Exchange-RoutingPolicyChecked: m1BvLVgrLAoJXt1Ie5G3v7ERKi9mAvp/Jk0sMmZ6kmgXt113+bA0chAH1T8qZAdfPyBDqa/H0yeqYWVgdjd03mro2z5O7S6P1fvw3NP9a4vlHI0D3hLkN71HGV+lb0+q2qVplEhAJ0qL2Ix27u5zfB0jVvx6Z1s7PT1m2EZJFkSE0pajkDEylDMDFI+FisplvboGSvI+tUVCDV2Ropygylz9RG3h8DPNv9v2TspR9M52rNDvzGGRcZQPx6JbfRyZnU9ybRTeeTNimXUnvVhjNywID/6RWWTq6GqOtVVGWRC7iBtShfSmlQ43z5dqq5aqVVFRBbKy3eCzULytlXODpg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 398e4723-b5b8-47d1-c875-08dee1aea0d2
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5815.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2026 13:48:47.3560
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HtLUYjrcPBUWbUkeS8pVgJgHppinItV3ElGdi0VhNUqDDBC+37XbSOQqX54ncKaJ3gT3DbCI6lTaDqPPzWyY0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4890
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 80887A0013
X-Stat-Signature: pq8y5goiytxf5t5bwhasqkppsrdqq3cw
X-HE-Tag: 1784036932-936661
X-HE-Meta: U2FsdGVkX18n7MJqOCOqDrLWEBra8RH2xwCSDpTx+8/7Y0xxGaxTB6L4DoWsy/RlPkdHF1IotLe6u2+T/A9cm+oPY6AOMFo0M0iFxOK7vhWhK+fPqxvSV6ncTIZxZk7XDrgNZo6i2Yz30aME8d/2KdIcwXRy2n61ZsPU1Q3kXZ877cPD53vA8A7q2fNBqmHnV2+tknbgRWz6VbSU5iV11yD0gM79AHj0skvBxN2/nra8DwfvAzjoZ+rtLmgujiylmTZLoHHZDXXJXREaY9W8BSf6y/9vEVqS7dDdeJCL2BgZhSQb4FxeNQrv+s0/14fP1DFd47rLEeqJW9HsSCIfOnbas5G3e/yrI4xsK1ZgaODzpbuqw5MNApeTXDgborI+qBLiic1haEKviacVMOmEyep6itrhR33NjjAJvRmNEk5u7lTtVW98e1opj9Yi7EHVmh1DxDB1LlVDitYAQWD9N7RtRy96rl0Jj0EwUdGDFZ1/qD37SoSNISnj+UIppDDomgu2MM+9kCcGeY3LqLelYkS4G6x4qu8TTjEBqd2EihhnZ4WTPhvI1H4nW+qtlzW7FYpJ5fwSeZSrpFJitWudL22+hcc7VsMfSDp9KnV1YnXZ7Iu52IHhdavm38QMF4yNHmBeAwVeBdEeiZrLtzRn/ic7Lmxel9KnPAcyxGpZVnH3RAo10LCEkeFH7K9JJEsKfDTMhd6ojVUIKVcBNph9Ab+kuB31u0Ws+iYDILLAHao+JmFjiJM+9ts0WU0IPu73mX3mUOM+y4xQbBSPSOd/CjE0U2t56r1GMa3BtqgFuJykjlovd21heJG53otGcqsw3ar9aTEtQ+JGpmaI5v+SEQ1rY76xIwQkC17Oyxfg1yAn6lCjL/PkE6BxZ2zUW1a15kb/umAW7XINpDtCXC6GVeu1Ch76ed3QNFt/67RoOHqhk87vZ31BlfOAG/bsKHrVQXMpjToiN4m3JAvQq5m
 meUEofp2
 SVhiEAtXpsffQEmlUXY2UkGETPBrVU7xrauQM/snOOGBz2ppVm30jf3LNUUsWtGtzJrJAs6eS5M3sukEVQDxwTjTD/nstwzFg/09tCtb/LMLhZqaXlSHtUWV2J1nZfaRNwTXziiI26Zo3+5wojWc5LIlRZrYcpa8pqAol1BRgBmYU2qDjhJtZtt0palCeZt22qN22G9SAeBifB2+WefF8Nh+p1rb1a8jUYiWZo8I3g8qJZHTuBqjcGs6l4cnOVxWyKQgbzn5y/nDOliM8MGOoDLDmyKh2ZwD7ZbcqKSLSc1R7zoH+27PBihN+z0Vd4F5DgiDj/GDjkbPNXpoXgsMCAvW7tEbGOmJO6O/VZSc2mPwo06Xsbo8tEVV2rHsO7jwXHSSFMe/mayeU/pXJOszMPtrQbRR2qR4FUL/4Q7YHuvlS0W7lONRNqWLIQWssFXz0ipKLtd0Z210JMX/UE2rBIWpR3eUdQEECfkRHUjnxgpDrhFwFna+w4rgdodDVD8XS4Z/dKYeX2jWgVmJGpB3EBBHUpw3f5BLjcwy6pb+9PAp+yzQsvDBM7PUsSCFRxDjR077X6HHSHZz98uDt6iDAIoz+CxwS4IiAODS9E0Q05ECFf9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "RIP:mark_obj_codetag_empty" on:

commit: d6967566f41090d5e58861f3b5d3d9b1293ccb0f ("mm/slab: prevent unbounded recursion in free path with new kmalloc type")
https://git.kernel.org/cgit/linux/kernel/git/harry/linux.git kmalloc-no-objext-rfc-v1r3

in testcase: locktorture
version: 
with following parameters:

	runtime: 300s
	test: cpuhotplug



config: x86_64-randconfig-073-20260706
compiler: clang-22
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202607142131.f70bbad3-lkp@intel.com



[    7.170805][    T1] ------------[ cut here ]------------
[    7.173964][    T1] ext->ref.ct
[    7.173973][    T1] WARNING: mm/slub.c:2085 at mark_obj_codetag_empty+0x12d/0x180, CPU#1: swapper/0/1
[    7.180958][    T1] Modules linked in:
[    7.183435][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G                T   7.2.0-rc1+ #1 PREEMPTLAZY
[    7.198751][    T1] Tainted: [T]=RANDSTRUCT
[    7.200585][    T1] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    7.204811][    T1] RIP: 0010:mark_obj_codetag_empty (slub.c:2079 (discriminator 256))
[    7.206959][    T1] Code: 31 c0 31 c9 31 ff 31 d2 31 f6 e9 6e e6 02 00 5b 41 5c 41 5d 41 5e 41 5f 5d 31 c0 31 c9 31 ff 31 d2 31 f6 c3 48 83 f8 01 74 cc <0f> 0b eb b4 89 de 41 0f b6 d7 48 c7 c7 d0 01 0f 87 e8 fd 56 87 01
All code
========
   0:	31 c0                	xor    %eax,%eax
   2:	31 c9                	xor    %ecx,%ecx
   4:	31 ff                	xor    %edi,%edi
   6:	31 d2                	xor    %edx,%edx
   8:	31 f6                	xor    %esi,%esi
   a:	e9 6e e6 02 00       	jmp    0x2e67d
   f:	5b                   	pop    %rbx
  10:	41 5c                	pop    %r12
  12:	41 5d                	pop    %r13
  14:	41 5e                	pop    %r14
  16:	41 5f                	pop    %r15
  18:	5d                   	pop    %rbp
  19:	31 c0                	xor    %eax,%eax
  1b:	31 c9                	xor    %ecx,%ecx
  1d:	31 ff                	xor    %edi,%edi
  1f:	31 d2                	xor    %edx,%edx
  21:	31 f6                	xor    %esi,%esi
  23:	c3                   	ret
  24:	48 83 f8 01          	cmp    $0x1,%rax
  28:	74 cc                	je     0xfffffffffffffff6
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	eb b4                	jmp    0xffffffffffffffe2
  2e:	89 de                	mov    %ebx,%esi
  30:	41 0f b6 d7          	movzbl %r15b,%edx
  34:	48 c7 c7 d0 01 0f 87 	mov    $0xffffffff870f01d0,%rdi
  3b:	e8 fd 56 87 01       	call   0x187573d

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	eb b4                	jmp    0xffffffffffffffb8
   4:	89 de                	mov    %ebx,%esi
   6:	41 0f b6 d7          	movzbl %r15b,%edx
   a:	48 c7 c7 d0 01 0f 87 	mov    $0xffffffff870f01d0,%rdi
  11:	e8 fd 56 87 01       	call   0x1875713
[    7.216881][    T1] RSP: 0000:ffffc9000001f700 EFLAGS: 00010282
[    7.218936][    T1] RAX: ffffffff87f3cc38 RBX: 0000000000000800 RCX: 000000000000000a
[    7.226952][    T1] RDX: ffffea0004151200 RSI: ffffea00041524c0 RDI: ffff888105448800
[    7.229430][    T1] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[    7.232919][    T1] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888105448410
[    7.236484][    T1] R13: ffffea0004151200 R14: 000000000000000a R15: 0000000000000a01
[    7.238648][    T1] FS:  0000000000000000(0000) GS:ffff888795e7f000(0000) knlGS:0000000000000000
[    7.241013][    T1] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.242973][    T1] CR2: 0000000000000000 CR3: 0000000006b26000 CR4: 00000000000406f0
[    7.245167][    T1] Call Trace:
[    7.246092][    T1]  <TASK>
[    7.246905][    T1]  __free_slab (slub.c:2244)
[    7.248085][    T1]  ___cache_free (slub.c:6436 (discriminator 1))
[    7.249275][    T1]  qlist_free_all (kasan/quarantine.c:163 (discriminator 1) kasan/quarantine.c:179 (discriminator 1))
[    7.250498][    T1]  kasan_quarantine_remove_cache (kasan/quarantine.c:364)
[    7.252073][    T1]  kmem_cache_shrink (slab_common.c:604)
[    7.253337][    T1]  acpi_os_purge_cache (acpi/osl.c:1622)
[    7.254628][    T1]  acpi_purge_cached_objects (acpi/acpica/utxface.c:237 (discriminator 512))
[    7.256086][    T1]  acpi_initialize_objects (acpi/acpica/utxfinit.c:250)
[    7.257334][    T1]  acpi_bus_init (acpi/bus.c:1503)
[    7.258535][    T1]  ? acpi_init (bus.c:?)
[    7.259714][    T1]  ? __kasan_kmalloc (kasan/common.c:398 kasan/common.c:415)
[    7.261025][    T1]  ? __kmalloc_cache_noprof (linux/kasan.h:263 slub.c:5474)
[    7.262488][    T1]  ? kobject_init (linux/instrumented.h:97 linux/atomic/atomic-instrumented.h:67 linux/refcount.h:134 linux/kref.h:31 kobject.c:201 kobject.c:352)
[    7.263709][    T1]  ? kobject_create_and_add (kobject.c:798)
[    7.265173][    T1]  acpi_init (acpi/bus.c:1592)
[    7.266287][    T1]  do_one_initcall (main.c:1347)
[    7.267461][    T1]  ? acpi_arch_init+0x40/0x40
[    7.268701][    T1]  ? perf_trace_initcall_finish (main.c:?)
[    7.270254][    T1]  ? do_raw_spin_lock (linux/instrumented.h:55 linux/atomic/atomic-instrumented.h:1301 asm-generic/qspinlock.h:111 locking/spinlock_debug.c:116)
[    7.271619][    T1]  ? find_held_lock (locking/lockdep.c:5350)
[    7.272891][    T1]  ? stack_depot_save_flags (stackdepot.c:728 (discriminator 1))
[    7.274356][    T1]  ? _raw_spin_unlock_irqrestore (linux/spinlock_api_smp.h:178 (discriminator 2))
[    7.275877][    T1]  ? stack_depot_save_flags (stackdepot.c:728 (discriminator 1))
[    7.277336][    T1]  ? do_initcalls (linux/slab.h:985 linux/slab.h:1302 main.c:1418)
[    7.278561][    T1]  ? kasan_save_track (kasan/common.c:58 kasan/common.c:78)
[    7.280348][    T1]  ? kasan_save_track (kasan/common.c:57 kasan/common.c:78)
[    7.288349][    T1]  ? __kasan_kmalloc (kasan/common.c:398 kasan/common.c:415)
[    7.290315][    T1]  ? __kmalloc_noprof (linux/kasan.h:263 slub.c:5317 slub.c:5342)
[    7.292347][    T1]  ? do_initcalls (linux/slab.h:985 linux/slab.h:1302 main.c:1418)
[    7.294211][    T1]  ? kernel_init_freeable (main.c:1658)
[    7.296477][    T1]  ? kernel_init (main.c:1548)
[    7.298274][    T1]  ? ret_from_fork (x86/kernel/process.c:158)
[    7.300206][    T1]  ? ret_from_fork_asm (x86/entry/entry_64.S:245)
[    7.302217][    T1]  ? __lock_acquire (locking/lockdep.c:4674)
[    7.307839][    T1]  ? _raw_spin_unlock_irqrestore (linux/spinlock_api_smp.h:178 (discriminator 2))
[    7.310305][    T1]  ? parameq (linux/fortify-string.h:218 params.c:99)
[    7.312115][    T1]  ? parse_args (params.c:153)
[    7.314076][    T1]  ? lock_acquire (locking/lockdep.c:5868)
[    7.316041][    T1]  ? local_trylock_acquire (linux/local_lock_internal.h:53)
[    7.317915][    T1]  ? parameq (params.c:99)
[    7.319735][    T1]  ? __kmalloc_noprof (linux/local_lock_internal.h:53)
[    7.321920][    T1]  ? __kmalloc_noprof (linux/local_lock_internal.h:53)
[    7.326225][    T1]  ? trace_kmalloc (trace/events/kmem.h:57 (discriminator 6))
[    7.327722][    T1]  do_initcall_level (main.c:1409 (discriminator 1))
[    7.329722][    T1]  do_initcalls (main.c:1425)
[    7.331702][    T1]  ? kernel_init (main.c:1548)
[    7.333605][    T1]  kernel_init_freeable (main.c:1658)
[    7.335051][    T1]  ? rest_init (main.c:?)
[    7.336248][    T1]  kernel_init (main.c:1548)
[    7.337273][    T1]  ? rest_init (main.c:?)
[    7.338461][    T1]  ret_from_fork (x86/kernel/process.c:158)
[    7.339695][    T1]  ? exit_thread (x86/kernel/process.c:138)
[    7.340878][    T1]  ? __switch_to (linux/instrumented.h:82 asm-generic/bitops/instrumented-non-atomic.h:141 linux/thread_info.h:133 linux/sched.h:2087 x86/include/asm/fpu/sched.h:34 x86/kernel/process_64.c:619)
[    7.342110][    T1]  ? rest_init (main.c:?)
[    7.343300][    T1]  ret_from_fork_asm (x86/entry/entry_64.S:245)
[    7.344579][    T1]  </TASK>
[    7.345444][    T1] irq event stamp: 29481
[    7.346581][    T1] hardirqs last  enabled at (29495): __console_unlock (printk/printk.c:347 (discriminator 3) printk/printk.c:2932 (discriminator 3))
[    7.348686][    T1] hardirqs last disabled at (29510): __console_unlock (printk/printk.c:345 (discriminator 6) printk/printk.c:2932 (discriminator 6))
[    7.351184][    T1] softirqs last  enabled at (29232): handle_softirqs (softirq.c:468 (discriminator 2))
[    7.353729][    T1] softirqs last disabled at (29227): __irq_exit_rcu (softirq.c:656 softirq.c:496 softirq.c:735)
[    7.356197][    T1] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260714/202607142131.f70bbad3-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


