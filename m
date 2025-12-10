Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04CEAD3C91A
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 14:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFE256B0006; Wed, 10 Dec 2025 09:56:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED5C66B0007; Wed, 10 Dec 2025 09:56:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D966B0008; Wed, 10 Dec 2025 09:56:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61226B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 09:56:09 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56F89C059C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:56:09 +0000 (UTC)
X-FDA: 84203861658.03.C55836C
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf11.hostedemail.com (Postfix) with ESMTP id 000814000E
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 14:56:04 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eb4tPmnw;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765378566; a=rsa-sha256;
	cv=fail;
	b=1edVYE9vxdAFVR/nhbue4qxg16KaANB4wM/aA0yGI1t213CsOPt+l4BK6k3TUOJM+x/kK+
	v56jjJuuDkU+HWJlFPrg14w0Sb/G7DweUMy0b2+nuwuYnttZgEm4D3LS8nu6NvMlwu3fDY
	yWg3N1Ll62ED8whZEZhVk8u0XOYyvZw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eb4tPmnw;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf11.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765378566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Eymuh32uAm6WxTmrKHr7vQaQ6Dl6poJruWRvk3tSsBs=;
	b=mccQtMJIfLlmUQH+ADV6G7P2iCc8mMhie/pt5ED1pHbAFNkZ7v/En143uXjs9D6aOI5svc
	GRTfYukGJJc6iGHhHMUOgPcVmz1Jov7ueK1kvjFqs09QplaJFb20AdM8ExIgaMceeXjTuS
	1rHn8Jvjk5h30s5XY1gSE5oUvqGSZ2Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765378565; x=1796914565;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=NFRWTh8+cGvquOUjKhghqG1yWywc41hQh5SZfj/EUn8=;
  b=eb4tPmnwvLmb66iat3OIpSfK26eCTHMeSdlNL75A77bMiykS6dMmB6Yz
   2017LH3nxAS9hYJcUkmhPLs99QhMH7D1YgByD3wtz4IPDqWBdE1qRLtJa
   eYzHO+g1O3MjD/z534FAvBXeGp/DkRgtrumSHK5fkFlZDV9hjPt0sWqPn
   EdiEYyeTnccGoT6eaVthhpHa6d7W6eLE1jqq4ToTG+iF/55/cwjw2OM0g
   FZmRCm6SDoyDOOKaH/nyA7V2ahvn+UnwYbjdIGHMSW1i7AmTstEJnA9f8
   7bbTYE35qn9KIqOC8y3ujxr1v3cMvoB/9ecpSK7gJw2jNo0oEoQv0Iy56
   Q==;
X-CSE-ConnectionGUID: GzT8G82STMqfC0akWAXq9Q==
X-CSE-MsgGUID: RBP87yhsSbyXeakW/MthkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11638"; a="71214671"
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="71214671"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 06:56:02 -0800
X-CSE-ConnectionGUID: Y5M7dRpyQbGM7mNR9YwDXg==
X-CSE-MsgGUID: yiEO2cRlQ/Sv+IdMv4ZW/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,264,1758610800"; 
   d="scan'208";a="196531807"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2025 06:56:02 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 06:56:01 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Wed, 10 Dec 2025 06:56:01 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.10) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 10 Dec 2025 06:55:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NsEK2AiexXklyvVC9KuWAlC2jtQsW3Li5sHJ/YG5zRm6m8QVUEc7qHLKQHjBuqGSM0W9voOv0ShMehWOiLV0rOiz/0rNVbV7KhvbTmOgj80PSVsmeUdfjGkDhHuYXKGZdJX19HUVSME0pkUBPqhOpX0/iJyx6I7IeOMjb26u7l0b6A+oNI3tM+9BsYROuJX6XvgfQVjEA5Egl1arCoBEZEjno+H076sGeWmgI8V6BiW6xGPyM3urrI0xlN89P6yjzMo0LZK2Pim1V+5BU2B7Gbj+Q7KkwRXya0m6Ws2VWJmMlFP2Md749i0+TCzRneP70SLV6KPOb33kE9KdQuETtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Eymuh32uAm6WxTmrKHr7vQaQ6Dl6poJruWRvk3tSsBs=;
 b=XmfNRdNORrFnI4TaP8Mau98XMWzSSnO24c31HAf4zV6Won3UODcnn4y5pGSWCEUJVB4LkMp6adW7RcVyopYmkvPB6ECEKDcO6aT+WxGqHZPWzH2nL33cVMgH9wxwr9Ns3PayD9gRYc4khsRcrM0TricUHfPCWRwF9GAiO3GNaZ49S8Cx4BlNop7CZ/OwP11vKNS/JLkspYo+25eDikpk/vqzb3MVaELyDxYmxHTfKAqwsSSPDtMSOU0Oyyn88cREe4U9tot4hWrTIjNdg5eS8FgrXqiklwJzl52OQhtWZcnHMnNf1Kc4/E+S/uSm1BUZTnf6sk9xh52OPed2G4ZPVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH0PR11MB5901.namprd11.prod.outlook.com (2603:10b6:510:143::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.7; Wed, 10 Dec
 2025 14:55:56 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 14:55:56 +0000
Date: Wed, 10 Dec 2025 22:55:40 +0800
From: kernel test robot <oliver.sang@intel.com>
To: David Hildenbrand <david@kernel.org>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, <suschako@amazon.de>, Laurence Oberman
	<loberman@redhat.com>, <aneesh.kumar@kernel.org>, Arnd Bergmann
	<arnd@arndb.de>, Jann Horn <jannh@google.com>, Liam Howlett
	<liam.howlett@oracle.com>, Liu Shixin <liushixin2@huawei.com>, "Lorenzo
 Stoakes" <lorenzo.stoakes@oracle.com>, Muchun Song <muchun.song@linux.dev>,
	Nadav Amit <nadav.amit@gmail.com>, Nicholas Piggin <npiggin@gmail.com>,
	"Oscar Salvador" <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>,
	"Prakash Sangappa" <prakash.sangappa@oracle.com>, Rik van Riel
	<riel@surriel.com>, Vlastimil Babka <vbabka@suse.cz>, Will Deacon
	<will@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<linux-arch@vger.kernel.org>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/hugetlb]  0e1ad0324a:
 WARNING:at_mm/mmu_gather.c:#tlb_finish_mmu
Message-ID: <202512102246.ee3d6d07-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: KU2P306CA0053.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3d::19) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH0PR11MB5901:EE_
X-MS-Office365-Filtering-Correlation-Id: 695cf257-7195-467d-9c58-08de37fc3933
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?4YlotVGBgLzzrd04KY4HTyt5lFFQMUU9EUZ5y3ywef11A9AFobDzA/ozgTEt?=
 =?us-ascii?Q?KB8OR2XNK5bM+CMt6Gv68bAlB7ltEP8rY6DPB/475V64t3RinvDaMvYaSUfA?=
 =?us-ascii?Q?AQdmeqqwWTFy5JCe8ryZx411yoRYsd/RDqzo9MmqW5KAm+uP4R5zYo3UPkcf?=
 =?us-ascii?Q?At30qBwGy8moQwu+Qbq2eUwIkRwR32yD5AezEq4+80oORaGPgWQEvSIYzHYJ?=
 =?us-ascii?Q?trs/IgtZWpMgaf+vRWOl2OzmDfSI/m67ziGCqAiuS8gHL75f/af/xJHiyXcL?=
 =?us-ascii?Q?I+qAMifvSToXjTNO2XSPpv289F+4+nwcWIzAv//vsh9wRlS3waGABLZtgA+9?=
 =?us-ascii?Q?/IuKVDXRXAgqn1hFWGd2OEHtLwzKjm6LYsK+64xt5eN8OXiethqbNk1AbO9e?=
 =?us-ascii?Q?rUJfEPeSktCKQDB5xmNx1ivkWMKfNxWdZeLvcOQD7gCB2de5XpUBiIIMRXKF?=
 =?us-ascii?Q?gU1vQ9HN8PTNRoJq+S6PqxCVUfsyKRWdNvAMYmF9A5ZQb/pVsBDLRhIcQmV0?=
 =?us-ascii?Q?O51Xk36HTWwxkJcalhI9HM4LYzq2T0IwYhJi9YrILqPJBy44WC672tbRCSn6?=
 =?us-ascii?Q?V0fW6t2dyivo4U2Mae46PFEkYi/wQi8QH0a5xc1OzcK3Ink7N3ZLXkUOs5O+?=
 =?us-ascii?Q?jSMc5Ms3iF/9tMsWiLYd+j9G8W6+JS8gKOM/f0j/p1dUGJtYJsOfj1VWwFC5?=
 =?us-ascii?Q?AODqBeB2eYqGY+6y0KXtdJ87ZWqg8KUJPl+KU+dFlprI8+/VfYO/Wz+QhzM0?=
 =?us-ascii?Q?6t54e1zNVa3xEVclBanntxyn1dxA01oeyFq6rYRlzmHRhMMFds4z47hd5YGw?=
 =?us-ascii?Q?3rLvEPSSsCT7uGsi2ULTwXgC+OEjOGo6NgtkLyWIcQ1mVPhDyQQBsewrGs1J?=
 =?us-ascii?Q?QXM34Bpkfc+3x2HR1jKz66lfLS4Cc0Z/VhGDthj/WOUkzzhWYyRZRpS935J0?=
 =?us-ascii?Q?aiBfV9ssb4FkSy4qZbdRu8bfHkvyxYjnKdMsMNi82Kf4lnLakohF39HMXGrG?=
 =?us-ascii?Q?KqD3xwHNi6Dkjalmb8FR5PZZHI/30XsKKyRWg3EVPQURwrTXvNxqVvGgmyAA?=
 =?us-ascii?Q?13AUjWdNbsKpZaeU5LK+jrLoLR8SrhU02fSY9CgL3j0k/Hr/nspBLa7jgQ61?=
 =?us-ascii?Q?BJcgByhDjBkEckr/oY1cEu+5yIF+ARzWyFzozonE6eyb3UzhtM9Alg2kee6k?=
 =?us-ascii?Q?A6RQ0U4Joss8KUUEXiK0uAMnZ7OQNVYQId40A3tU9coqum1hS1walS98eCvM?=
 =?us-ascii?Q?kJREXEVjx892PGjYJm6qb+cErVxU6cwuGVgi6SkGWVQ79AsYEGflxIVSOhnS?=
 =?us-ascii?Q?ejpB29nbruh6O+mttWKtKn20+F1moulTj67aw/HJL2OxhEEuarFGNqV7cduK?=
 =?us-ascii?Q?vWaTDsxeyBDJPCmDSw/I90BNW+LdTbNZ5JTTpGPsjscuUNldQmxhmbmRYtQR?=
 =?us-ascii?Q?WxonEOfeeoFPWpTb5lQblTMN+QggIk0FPO5yfdk9XyRRo+YPciLDzQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QgKGyxJeZ4d5NjeQGAJ1NGu4i9Ih//a7L6A16sgVRGnmj0Hv/4Q6kjyYaKgP?=
 =?us-ascii?Q?5dbWagzJp0xCDegiAltJ/E09aw3eIfE3zXM6hsqsH2zSkKTlW5rBz102T9+3?=
 =?us-ascii?Q?PfCMGlIeZtXI2DVFsaiIDtXvxjo2uhAYuEBnfXuBdXqXiW1aMRszIDQxi7qD?=
 =?us-ascii?Q?AuIMU9wUAT1bY5GGTNZgck8pkzl3s3cZavtvzf1+sRs/QYLXPbkXnRq3PEY/?=
 =?us-ascii?Q?lVz9CXo7XxklsPi/m3CrmfsoKN+wU8y8ZrXHpPZsi22kvP6IC/A7aPnYnC2Y?=
 =?us-ascii?Q?mITvgrLZ6pN9oGkAOc9HVcn7c3c0G8chbIN38NA6+AH94G3r7k0yL6QbEVUQ?=
 =?us-ascii?Q?UwBIGc8I6OzDL+cSUPyGm5B1F+FUIu/Lyu3PA/BhvAvZoytqc0KN24Mu7JUR?=
 =?us-ascii?Q?PmUvuQVJkYwxQqwFkDzlOWhDWFVTwLhMktC3Idy+YZIJb+/FTi8oifI14Ksl?=
 =?us-ascii?Q?7hQBoA66U5k4w2xj1UVfcb8WL1sAcaUK39B48dfIf0snZ7Nm5QJmwcRz9yc4?=
 =?us-ascii?Q?QnPLFdUoaPZ4KvqR/96N+yUJE0V0nV2bk6DQ1/FUxRim5hDfOPjyHTsj6QoE?=
 =?us-ascii?Q?wNOGf7Y1g/17Hd/N6zZzv99NyrjgViE74YxDHjKfVQ4//2IJuOWXd9/z4C+j?=
 =?us-ascii?Q?dLJU1BIeSx7XlZ57qfLLlDWfsbLZJJjL6a7g76IA7p/TDEW/JJUi20IDbywN?=
 =?us-ascii?Q?xAOq7oFbWEoqjEWy+Gb+R2i9mjVep1MoE/GfEZJCf3WMgqXzzqjfUryjpYPm?=
 =?us-ascii?Q?FE7LEZhcsZyIQTzmCBzRW2fgjB+g1+a48vyRb9EYfx8Da+FmQ+XYJ2G6KsVJ?=
 =?us-ascii?Q?7kCMzOlM4NGcRvXVjGGE//5lpE7YoHFB9a4gM+bUzaIkriRxm0DDxpSQoUV8?=
 =?us-ascii?Q?rQtwNMW1kb5KeFUTdVR9hYGY6OTiiYTz0VF9+YqE9bZPJl/cxuczrycCrqlz?=
 =?us-ascii?Q?tu6Ke0bkrzACrGp8uqbNjM4DjbOageiEA9L9X2C0VMHBtpUGI/6N6FXPEI/C?=
 =?us-ascii?Q?Xks1Rdndb0a5IDC0AGCiiA0/HhgJY2/zif9fIr2/rxK4nJ3En43o7PXTVE2e?=
 =?us-ascii?Q?+J1wCnpDVxLEMp4led/eNn2Wo5YzMAICkmtZeR0+GQc+jQ3V5mihn+y6/I1u?=
 =?us-ascii?Q?Pbb3R/aHnNwvJMADmglHk73odBfTWl92+2af4nSJh7nL6GxXUEqat8IhhEdJ?=
 =?us-ascii?Q?VU/bOqO+r2EWlqRXg0XXFMMuKmCbJJ2vDltKz3+WeRhduCP/ro1hi1LjZDJG?=
 =?us-ascii?Q?f4yKFzHdegucL9eWZnk0GVJHuEWtmmg3klIKI4nNPMI/ztDyvnBxveE7mo5l?=
 =?us-ascii?Q?sYGpuAuDiSEkj1Je+odX4sVgETHRINiMYjzeCRbSVPrY8K1VH94sHj5HTMAj?=
 =?us-ascii?Q?kaDjpN1vawiEicD7iuVDoo75Rd85Wj9lKmpI8wUzjX1nr/VCsN2UNGqYLIrz?=
 =?us-ascii?Q?decKkOzkqO4qMqqH7Ffz11BsAcM5yhzPVHmpLtbSTPnyejIRKhxzzTe9hVnN?=
 =?us-ascii?Q?BkTVrYg/wFLgZ/4yY1ZY2oDFzmerxBhoq5a7J87opaFqu24G4W5Sr0M9VVYV?=
 =?us-ascii?Q?qZFuveBXIA84+0wJ/p9V/nB2pmtsOEvuuCnd8NfL/iwEkqZWlEaGb7i6alPx?=
 =?us-ascii?Q?yQ=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 695cf257-7195-467d-9c58-08de37fc3933
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 14:55:56.5494
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: deUZC4U7r5u8MtCI5iDO2WD4lRZJNev8uN/tyLtcJU/qzdvgYhgx3ZB7Zmk28Gye3vnB2xY/Z5Ns75WDZdlsbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5901
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 000814000E
X-Rspamd-Server: rspam10
X-Stat-Signature: 4uqgrq1ej1nwkmmeig98phnfnfsy7sgi
X-HE-Tag: 1765378564-349377
X-HE-Meta: U2FsdGVkX1+9+hhaz4lrOJABiKD/yZIfE+P10pjOIwmmsWmMMWAUHnqOxt7ChmEG5x/vFIqmC4nRz7RZny1joGPki35U0PdnyGYT4YFVJmU7LUd6tmY+GHHV2QqXOSPNRuZAova1PWz5m3vf7I8AFScMD1IQ9o6cU+u1I141CcAEXjJ/94nJ4ccUabME4vRYf2KRyjWn/wUTki2MGA8d3UfVw+vmpKw+kj/NDVY5DSoS5+mxLzNUzci+SI+jAT+k+AlNHI489X4h1mYzLL86R2rCYRFd349x3OhbikXmGzdR3onO6nkLHFE9HWVLVVX7eGXdyGFMe4o5SL0/k5gPgpV8xQeyHTZB48umeRIpvAwSuc0Q/LKfYcNbRAmCP+OMQiEzFir9AAP7nLsckEnkQE5VOCke1BoOBNyiAtHWjFGyp6sPnyPE9t2TwEJG3Wt6QnRuGBdJd/RQKEdCsGc5oNgy4WKNuUodQehMKMaWilcfG9McbZAi5zu3dzhzzVsvcL/HBbDeG4sNXxUJvnMiysPuCdJUrsPXDZ7z1BrECMfllDTk2Qxoc/p+yQX/zqBEcHL/j2m2ue02KNAUMJAo/IazdFc3Mx6TwQBv0z8gMdMMGpTtw+R8sFB+4UTjbo3xCsTO2nmcfmkRWi6phkkDiH0mJCrl1DbADYzyT3kpwFbsFGHjd/UYDYWrWKMF3eIMTOIVk5ggTF4pLULc3mU5OPIs+hKFYRLw16qf1OXeaKTk0twLhAzkbZV9M0rQ47bWqDKyoNm36KxmruGbCBC0DHhcUNh0iZqJjjJjmRMpMe0g6mtx+blneeoFIg2gEAwUgbAAcibspiEU4/mTw8Gc921a4Zhf0MhTo9iIrENwFP6C8QKbwzhpTZStDWwd5cnEGf+PhBIz8LcQnEop11dtTiaRH2IWkC0hXhB3OkXPa+K3rC4Vjugb/pBGODYliVqJJwM6p1ZWmW7MZF3YyCS
 Fx8lXT1u
 CJVwNO4n1DByZADuF2UFgMYMTCMZlLPamKjmAFReX/Hb9e1t2LjeIoAg+JpIwb108X2fRAT1AkNo+DFT+/gUWw036sd/0miNytNFYNlJVoKCzPBiAjD+TUhuuqi3ZwXChx2r7uNojlyge//4X75OzsdDlQvw6nacTUzlzvcjw1DTQ+wZRAzzMY8GU/wWzeuFPsWBYtTy+Pjug4fPDtiCYXAKW8FZP2Z6JY2Lv+jroNQcmaU1YGABWSfXlFABhMvBIHtd7ul1cynqQWteuLGjT0mh8mX44MR/EJPcfAxl9aSR5DdKX5hmuy5jfUYnUDQiD7zUyq1Lcw9YGf1jW8Tk/FxVIPzoAQ7jj4T6botNUxAGs9MmBaCoGdcYkLEDGhB8xn4BTr7nl36Xp4C7kPs7BNaNU2/fiL3J5LkKqq/Ka8f3ivpILhjp3pPIiR0heaZjMMqnqI0DwkIQX3LPZLqqPOHG5xaM6/yVhs4MVSIXMVBdGeFAH39svgYXY4WeV1ny9w8Mlq/Db0MHVfj1ww0M2MhS0I0QjpHNYs4l2n79jObYm0sB3s4ng7jOqBoPDEadb4zvxU+5ONXMQyPLMsoEYYaoy1q5nvM69rrUNcXb+TsYe7ZGODAu1G4AcS5HHBC7lZMq/hUaX0/NM9Ra1CrrL6qFsQqQTbm1hf8AkAXl+ogaFdJqB0OvLZ5vGjTGw03ftPRP76JzKndk6Q2+8FjL1bh12hA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "WARNING:at_mm/mmu_gather.c:#tlb_finish_mmu" on:

commit: 0e1ad0324aabb5aef3ef409de9a395cda7ee6098 ("mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables using mmu_gather")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

in testcase: boot

config: x86_64-randconfig-004-20251209
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+--------------------------------------------+------------+------------+
|                                            | ef8ae3fc3a | 0e1ad0324a |
+--------------------------------------------+------------+------------+
| WARNING:at_mm/mmu_gather.c:#tlb_finish_mmu | 0          | 12         |
| RIP:tlb_finish_mmu                         | 0          | 12         |
+--------------------------------------------+------------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202512102246.ee3d6d07-lkp@intel.com


[    5.210750][   T44] ------------[ cut here ]------------
[    5.211469][   T44] WARNING: CPU: 0 PID: 44 at mm/mmu_gather.c:475 tlb_finish_mmu (mm/mmu_gather.c:475)
[    5.212311][   T44] Modules linked in:
[    5.212737][   T44] CPU: 0 UID: 0 PID: 44 Comm: modprobe Tainted: G                T   6.18.0-rc5-00395-g0e1ad0324aab #1 PREEMPT
[    5.214003][   T44] Tainted: [T]=RANDSTRUCT
[    5.214515][   T44] RIP: 0010:tlb_finish_mmu (mm/mmu_gather.c:475)
[    5.215083][   T44] Code: 66 89 47 20 e8 90 fb ff ff ff 86 dc 00 00 00 5d c3 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 53 48 89 fb f6 47 21 10 74 04 90 <0f> 0b 90 48 8b 03 8b 80 dc 00 00 00 ff c8 7e 10 80 4b 20 01 48 89
All code
========
   0:	66 89 47 20          	mov    %ax,0x20(%rdi)
   4:	e8 90 fb ff ff       	call   0xfffffffffffffb99
   9:	ff 86 dc 00 00 00    	incl   0xdc(%rsi)
   f:	5d                   	pop    %rbp
  10:	c3                   	ret
  11:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  18:	00 
  19:	55                   	push   %rbp
  1a:	48 89 e5             	mov    %rsp,%rbp
  1d:	41 54                	push   %r12
  1f:	53                   	push   %rbx
  20:	48 89 fb             	mov    %rdi,%rbx
  23:	f6 47 21 10          	testb  $0x10,0x21(%rdi)
  27:	74 04                	je     0x2d
  29:	90                   	nop
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	90                   	nop
  2d:	48 8b 03             	mov    (%rbx),%rax
  30:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
  36:	ff c8                	dec    %eax
  38:	7e 10                	jle    0x4a
  3a:	80 4b 20 01          	orb    $0x1,0x20(%rbx)
  3e:	48                   	rex.W
  3f:	89                   	.byte 0x89

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	90                   	nop
   3:	48 8b 03             	mov    (%rbx),%rax
   6:	8b 80 dc 00 00 00    	mov    0xdc(%rax),%eax
   c:	ff c8                	dec    %eax
   e:	7e 10                	jle    0x20
  10:	80 4b 20 01          	orb    $0x1,0x20(%rbx)
  14:	48                   	rex.W
  15:	89                   	.byte 0x89
[    5.217110][   T44] RSP: 0000:ffff888103fc7c28 EFLAGS: 00010202
[    5.217747][   T44] RAX: 0000000000000000 RBX: ffff888103fc7cc8 RCX: ffff888103fc7c68
[    5.218585][   T44] RDX: ffff888102b85000 RSI: ffff888103fc7cc8 RDI: ffff888103fc7cc8
[    5.219466][   T44] RBP: ffff888103fc7c38 R08: 00007fffffffe000 R09: 00007ffffffff000
[    5.220295][   T44] R10: 0000000094692512 R11: ffff888101b54948 R12: 00007ffeaa1ad000
[    5.221108][   T44] R13: 0000000000000000 R14: ffff888103f70a00 R15: ffff888102b85000
[    5.221923][   T44] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[    5.222854][   T44] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.223545][   T44] CR2: ffff88883ffff000 CR3: 000000010172b000 CR4: 00000000000406b0
[    5.224429][   T44] Call Trace:
[    5.224782][   T44]  <TASK>
[    5.225096][   T44]  setup_arg_pages (fs/exec.c:674)
[    5.225621][   T44]  load_elf_binary (fs/binfmt_elf.c:1028 (discriminator 1))
[    5.226127][   T44]  ? exec_binprm (fs/exec.c:1670 fs/exec.c:1702)
[    5.226612][   T44]  ? __lock_release+0x4e/0x120
[    5.227188][   T44]  ? exec_binprm (fs/exec.c:1670 fs/exec.c:1702)
[    5.227678][   T44]  ? __this_cpu_preempt_check (lib/smp_processor_id.c:65)
[    5.228270][   T44]  exec_binprm (fs/exec.c:1672 fs/exec.c:1702)
[    5.228746][   T44]  bprm_execve (fs/exec.c:1754)
[    5.229212][   T44]  kernel_execve (fs/exec.c:1922)
[    5.229754][   T44]  call_usermodehelper_exec_async (kernel/umh.c:109)
[    5.230368][   T44]  ? umh_complete (kernel/umh.c:64)
[    5.230867][   T44]  ret_from_fork (arch/x86/kernel/process.c:164)
[    5.231341][   T44]  ? umh_complete (kernel/umh.c:64)
[    5.231813][   T44]  ret_from_fork_asm (arch/x86/entry/entry_64.S:258)
[    5.232321][   T44]  </TASK>
[    5.232643][   T44] irq event stamp: 469
[    5.233065][   T44] hardirqs last  enabled at (477): __up_console_sem (arch/x86/include/asm/irqflags.h:26 arch/x86/include/asm/irqflags.h:109 arch/x86/include/asm/irqflags.h:151 kernel/printk/printk.c:345)
[    5.234028][   T44] hardirqs last disabled at (484): __up_console_sem (kernel/printk/printk.c:343 (discriminator 3))
[    5.235062][   T44] softirqs last  enabled at (504): handle_softirqs (kernel/softirq.c:469 (discriminator 2) kernel/softirq.c:650 (discriminator 2))
[    5.236041][   T44] softirqs last disabled at (493): __do_softirq (kernel/softirq.c:657)
[    5.236959][   T44] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251210/202512102246.ee3d6d07-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


