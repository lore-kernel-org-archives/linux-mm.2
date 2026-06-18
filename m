Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAD0CD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7CB06B008C; Thu, 18 Jun 2026 04:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D596B0092; Thu, 18 Jun 2026 04:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6056B0093; Thu, 18 Jun 2026 04:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 969D96B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:16:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EBA6090884
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:00:59 +0000 (UTC)
X-FDA: 84892287438.23.FAB1539
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5FCFF14000F
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:00:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="DBzX/hje";
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781769656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6wuU3hzXs9smcS6800aYo4owBicl0bkRUgsYGedSq0w=;
	b=PXoUdEsqsi1LAXvD6hCCc3aA0m+weQaY+X3+5zZdiSclyreN3tQhcDmPASkSQpmBjGjySx
	qBOeEjwrq+eiHn0WhZDuGCB1vwz9Jmo7h8cTAJOcPy24lg2GtFRm9+pVwowuuAgU2NKdA6
	Ih25MmwlKUatwdz8lLgw/jMDxAiMoiY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1781769656;
	b=KFbV6tCnBlD9dAN6JqDwSXS3spGBPgBjt7FFmKjlDUJDtP9YC+U4v50pz6dpFzU7Hruji7
	7Zg6JQrMk6SttaXT+ZA0Dx27ShtNbC1+DdFKIRcbvbNknypcXVeWfQdLCo0VSYlRWQ+1kQ
	WhEJHVJlZkNFEMAocV6KjM4ZAdHjziE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="DBzX/hje";
	spf=pass (imf23.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781769655; x=1813305655;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=XpsrF2vSt1ytzHoQwacw9Oz60JvelzxcTocnPuvNtg0=;
  b=DBzX/hjeVOF0Ri/mXBTQ2L2nSIqhkcVxpfajWz54u18TOrPlLT24gx5b
   okUEwwed/qHlwDhpRSbn6QG9t06y5OGw1eJD0hIfDHMjA0aN9oPej/FSs
   HpHQAV7nPzcRbCYIe7yiVfqYg0fOdMyHoGWxBOzuZL9gHB5t5l+OtZy/s
   PdschUKx1Ks8naO0Y35Q5xwI26RgatUYftdSXfAUXPZc9q34puBsWy7qy
   UeMsjcx/GCco3O9qgkpas2qT99/mpIABdXmG8MQCs0Tox++BMgQA9hAI4
   f3/hMMFtc4AHtucpPz37Oc8AWnSTVXnZ+/scpALdzfZcXc0NAtOXCesJH
   w==;
X-CSE-ConnectionGUID: F6AY4lApRjaPxErqWhFuXQ==
X-CSE-MsgGUID: 7u5XzSk3RFOSWL/ngH+p+w==
X-IronPort-AV: E=McAfee;i="6800,10657,11820"; a="108142208"
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="108142208"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 01:00:54 -0700
X-CSE-ConnectionGUID: Xt+yO0fXSpu177hON6DUeQ==
X-CSE-MsgGUID: 8Cr3tHQPSv6quig9c96p7w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,211,1774335600"; 
   d="scan'208";a="243938711"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2026 01:00:54 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 01:00:53 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Thu, 18 Jun 2026 01:00:53 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Thu, 18 Jun 2026 01:00:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=F68bam2BF9ZLWhRKa3oaDW1aKFoDT+pRqy3BD/U0JPQAD4e8kZXM4em40SCtbt8EjS0LIO4C/epjiSkmd8o7pVDT42C5x/tq9nXLY0oOL2WbFqjKIWs2ES5QeavhUNVUa4SRki3chQFUGAVNVuDJOCus/GzJM4eVkaxumJ9oiK8KtcJxiTkiNRDLDejmLPUdFnbRy8klD1uKT/Lzhys5IMzXz/pIuJ0ZtB1KU/khkD+L7VETtgS+yuh15wsdnqKJtsDJJVOVUPbeDwAOm+q2plqB5XNQMDR/e6xIft74GIHLE+NvFLRJZ0JDx6bbYHMN6nLbhMkHRs5WhGW0LKHb3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bWLwesj1+Swx0X+E8cGeMPjGExEznvA92M/rFIZHH2M=;
 b=wJR9JvBtcmM1RlfjHqyq4gwKo+iPNptkbFCEZzc0XvI25g54ayIuBKXCAZuF3yNgoFLICyYsMaiPbK9lRM2OtFZgroTeA4p/tLDh5AB9T2xxdG+Y/bRRwP1BPb9mW6ikKslIf6pg8eN3nluqBxf0T5ZA1VlRba22UYFHB7pCQZHvIbAQapaXl1Db8IU960TtQVZ/W29iFofESxjMLy+sOr/u/ygzWkEXcLosJyHSL/DKY9ib1Z0YUqEqO6s84Lms/ZL5PO4QhLUIMfy6/NwsP96zr5UW04riotvBD6ksBjBLg4k1SDthVr/Q33/EiHhoq8GXh9sQfJ069x2WGT+L/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.139.11; Thu, 18 Jun
 2026 08:00:49 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0113.015; Thu, 18 Jun 2026
 08:00:49 +0000
Date: Thu, 18 Jun 2026 16:00:42 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Frederick Mayle <fmayle@google.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>, Kalesh Singh
	<kaleshsingh@google.com>, David Hildenbrand <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Matthew Wilcox <willy@infradead.org>, "Suren
 Baghdasaryan" <surenb@google.com>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm]  7b32f64bc5:
 pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Message-ID: <202606181547.617a6967-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: TP0P295CA0057.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:3::16) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|MW3PR11MB4634:EE_
X-MS-Office365-Filtering-Correlation-Id: 73d0885d-7e58-4c79-4536-08decd0fb614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|56012099006|11063799006|6133799003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info: ufOaINgWNzZ+NRpTrB1+hvEIuJSlGR+9yBI14sjBecz9D5uqMyjRAd1TnFnSyO1SfHZ5EfmzeIbvE+VYlV2mQqzMPdCFtd5+rAkLMbi/CVrlqqKTw8J1ofMUM9BbtPSuj9lJB6swYy209HDyTEplR4hYVjAhfr6n1ATeKEirHARSC0m02vfmz6hkKvFkOMIpHtbD/czum4yh8BxAGEVPyVifFe4rJ0wLZbEMf6hXUCf0ThGvmmTdta3XkBgm9CAv0cSSr8cLHwJkuqKSI5mvbVmEPNrHAwuPX4T4L3HGOox10mFhYUcDN6bmwRNUF/Z5uOOaqJkOWE8e1eDeG87MhBXyttWYlNV7SMAOHKIL/9dnhi+2xSqekoNHsRugC+semwxEmfwxCzkBW0q7MYGV1IbIvNcBhTUoN1XdXVkME9n3bEANOXxvt0Ko8XMpKvb5BEjcHT9ws3Rv/Xo8neyFhtuaG8Z2PIBXjRCjVRExmhEn0U50ZwKZZGWHS6OgOCfUaQJ7vhBGMbp8XIWxwyaHapBDjHzWkMAhmSG5c/bWKDN/et3Dz5mTX2uudt+Z8zRXtN5KSzFEoOv2mQ/u6zy+cJYGCObj8rW0P7fJgnkMMUF2nmkOyu0BFukR0yGiYDSO1E+Jx3vLphmt/xYYtwvaJlNVZ3wbcfeHRuRSIt2WWgbiebRbOO3JmpfBTIU4GvVaedjptgMkl2Qy7zSU1FGYFQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(56012099006)(11063799006)(6133799003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?3QQTuXWymK/UqkjhT/m3jiZj6kA00W9YT7aIfTIOpZY9KLnhILzL0iHefe?=
 =?iso-8859-1?Q?OZIYKbCrkQ7CUNxhsCEBEXwHG71gIlhgvtx5LKbJRlLhAvUbqYc6bW6+Pv?=
 =?iso-8859-1?Q?U4PkwmHdjVKou0o/aKkshc3vrrdCpwadXJP03t+IW9H+9y+fVCGxG62Kai?=
 =?iso-8859-1?Q?nehYfjE+xGoMtFDQ3wLoG1vBfOCH2HjPdlYmSiwVebhOPreNczJpY6Ub3o?=
 =?iso-8859-1?Q?flKUnIg8xwwR3KBWuzINGjXPieKBo+KzBy+aDJzvXcJAlvIJdykQcMemXp?=
 =?iso-8859-1?Q?9WoAkcLhv6smv+scfWR7axFfIVcd95owkF+0PM53bO7brFL9g/6wwc2NPR?=
 =?iso-8859-1?Q?EqebgUPyNmL5SwQ21SetpW/yVJqRIec/6uGBJFYtUrHM9YhiF1Bn56/1/Y?=
 =?iso-8859-1?Q?/bvWpzC8D2W70XQPuJ8U8BTp8cCpw9hybLjIHtZgbkt1ndBbACgC42Pvft?=
 =?iso-8859-1?Q?gJh5YQMYLyArKb7/ODS8fIddP8XgKZxzIlAS9DGfTiRb4N8DPRmrwUJ5xt?=
 =?iso-8859-1?Q?LBouxXf9lkpA71ZgcqyarfwETQ+pNBK0Mf/sV9DWHFS7tgW669eIg9tgaE?=
 =?iso-8859-1?Q?cx6KZJt3H32/2U6oKrq93xweCjwGhpdD5xMx7ny0hOROJ9MC5iJWsWkde5?=
 =?iso-8859-1?Q?CP+Q7jlRN8YrmKG7pxIKVCwa49Xz+hRg45Q059InXETO+eRuCE3puZGpU7?=
 =?iso-8859-1?Q?7TNpStDrSGmvjMli1gv9PxNpD3Dotde2pBh+3tr3I8fyogPgEhEVSmlDm2?=
 =?iso-8859-1?Q?k0Pkbgs0pmlbRXVwNvjoXewzFRzGYe0PBzPdLHECkURzwI2YAWHocsSGho?=
 =?iso-8859-1?Q?38vSQy/K/smB5qAcPa3b35PIbw+8J2CTk4btWhJLiTBxwMgMOlJV9tmXaS?=
 =?iso-8859-1?Q?XVM/c8rjgjKcvp4BjZrJwCP1KEvX0QxuFq9pVLQJkhCtDHB7pUL2KfRXR3?=
 =?iso-8859-1?Q?tQHUpYnww2HTUfq0FqJ4YECKXV4o7qIg45YXLIWu54Vw2AJ00n9JRTBk7y?=
 =?iso-8859-1?Q?KPu/ixyzJUxQ4mdEhBtrZZq98RHLRr9jYpwrTCZUuXWO8Gmi8mGjoahbIU?=
 =?iso-8859-1?Q?NEOLbO6nmulR0iQzQjneBv60DKHyzhkgZ6kBay6PyUQIK5NatDEf9YaBsy?=
 =?iso-8859-1?Q?C8V0AArN/808captCJ6u9l3gYqX6NuolNz3ZhHLiSvrNdzikY0sr52N00x?=
 =?iso-8859-1?Q?8ohyvHXFO007ejwuAEKjOzptRlLGgM4v+F7z1SZe1CZP/wrevilNCcf5bd?=
 =?iso-8859-1?Q?ST3MGD0rCJDaWB3RHy78suCKqfdMZbxv1W7TtjpMUc/FeLCsQ3i0p23iHv?=
 =?iso-8859-1?Q?ETzRxD7TMDaLnrT773ue4p6oFRuUYAgGQwdABEOCHKHEOi8bO5MIe4Mt/O?=
 =?iso-8859-1?Q?ggm3IKX1puQMtHhF0zTzuM6gmskVVHy0MxPGAveEBa7rudJ3hV5bAO+cmB?=
 =?iso-8859-1?Q?HhAozOtHdUi0omLPfMQDSkmGX//45y7FqwV1xliSTtJBPQJuyaMjzJFxp0?=
 =?iso-8859-1?Q?jIm1lKF7U8FxssdSWVBO/0AfTj8UfGRxW6ogMq671dmA5cUE7XB0QrrT6b?=
 =?iso-8859-1?Q?Biidk547Zu3mnL5S9V8icONi5xhOknwH0+JZ0WskJuZgrGOwBtFSYLpXR9?=
 =?iso-8859-1?Q?RPpkOMWN477SlcPE93UepKogXTzJJDH0cOYaIw3/TYapNxsibkzlYtG4Jl?=
 =?iso-8859-1?Q?2It8lb7o/QHETlijzGRWw8oQyC3YV+yvHYtMkzZskss6HefrLoX3pBY25Y?=
 =?iso-8859-1?Q?8Vm3rT+w1/4/Z2O06NhtZlC6gx8psLuS6rJ0X3WJX2arnZmfMaykTApYvM?=
 =?iso-8859-1?Q?AkqjQ6JYdQ=3D=3D?=
X-Exchange-RoutingPolicyChecked: hh2+sEo0jwE5zEaLOmtEVuXcDMEO9174tkm+whl0EiPe/9CZoSy6jPU3bTPG9gwxAfRrz8g72UdK2+gBZtbnQe0F1z2rzS5wHcP/hvQtYx7XiPHDAMCByZrktQWIrjQ1BABoOpkFoyvjUOhVoyIBdj+jBsGtmldylfvPm4SQgrktcXb7jSaSw/BQjdO8vKYh5fkYskHn45rw3LoNq2Ar5VRwf4ihqRN9lsRwIHKJTvXRo7N3HZgN0iR8G9dRo8t4omMnkLaSRtvnmUWIYDhOUSgSLzaaCQJ3wFt53mkuk0tTEKw50Eq27rqPWS+0dsdz6QNHeddOgXDbKqCV4NBNcA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 73d0885d-7e58-4c79-4536-08decd0fb614
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2026 08:00:49.7128
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oCvnffrfMJWQP7G9hlLUyOUX45r4RzAILTKG9SXAhphjs7tJrXvmNdqIIOepr0OTuKE+Yq8/FYIxMqEL9vC+2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5FCFF14000F
X-Stat-Signature: fmadk43pr55khjtbo35xbngfjjgn66qm
X-HE-Tag: 1781769655-515354
X-HE-Meta: U2FsdGVkX1/kw6X4ze0neBzuF8k69lWRmpfb56UfnRl2ALdDZ6O1HRiq3Zukd6sXpkERgJdD7jyGWp7JMKXINjvDba+Fs+McfPzZqOWcL3gJpwOx/PeeuAnoAECPUHI5/6dF2k/MqHGWvOXcTvvZlatDZ0u+VFDSHECps7tezjZv4D2Eg8D+rCQzYV49LyBuwBHS1X1ShKDggEKm50RT7+mf88wBAzB5dqbk/jWm+BNytjCEgRdUgXkLFCQnWMc0mx6ZNzLuqHO8L5/04dSWt6quqRge9z5EnsDVveQjmYX7ZV4c8c3cnv85zLaMYqUZC8xSVIz8Cs8epkn0lrzOl+cd6zOCgMzj+oQwcVdljDw/p9DYhCywtrljbZwHcjOwNbfrc4C7cwKcU3lIMCbgfZGADPEDdMhMRAB5WXn1AmC7dXHWnSjtheHoLr5edYBfIEMZYzGvZwiamPYqznxcxoVYVYF+1dtguud07UGOpzCVpb0pTzIYGkGmg6cehF3GKpaXbl+NZDpwpNHQ8zi57sNOVgNmq3bFOGD990wr4XbQOs5t7e6PHZzXSre2Q+GaQvYfHrjBgPDNCKTTjY4xVausiWmQ6XhbEwfS4Lek68OTCfywuKzMSMrBK34W76VKI/SYL7MW6NHcXba5QESi+cLrj/lRk6/wOzmpv6gQCtrJxcMdUbnCRTspAf2g3FNTANkFc5gMNI1PJp4L5ls1Iznl90tFXGGrLFaWcRLCiQFTl5MdcepLTNTttnMUR70WmFmcokXPEAcbHkwBC6vHqJ8tU3M1fQAex5z/cOec4Lhc7JJIKiX0513jvLfXsjT0NVIlgOmOWZPhGRDSWwsxl5OPIxeHwmfK+INKIyfaliefopfSCBrL3R+JLm81ffW70HVw59InCW/NmNODEeW+wne1sI2s41H0N0dcMFW1FgmdBl1PAoD8glibDxEIx1XFmyB7RhzZqUIvsXYDSVS
 JVQDyVu1
 F7qQ8sG7ffanDVn2AcQTJwQT74zmJ5sdTbSvM1btTbrZ3w+PyktZo71qvpD0mNsYyFD6aYBW/fc+BMRHPeeBSkm0WYuxYiBfjyiaDyQxEJPKteivXBRx8p14b+QaF5MM8l5MqHVdXjESmR0SMwtIJIKPO/ROBlUvXT5MvtxCqjvzgC5eU+vyWCzpnRjBG9nD8fwcVft+KI1IEg0VFBlHdLLMzZjRgCJy3UDoFhtFTBW80sOrMIy7y6faKTkkhR1isT0KuuwT/jaKX9r1omrQcZ18gTT11dvngTwZ8z4sT4xO522aQfhdNjmoVi19YCsClmoh6yJnZWJW0cZIs0SaLbnmy/1F3/zktfbVh/nYLK6E08Sg14BjLNL9xowHqHGyV8DtjHlYjqrckk8PqQgoOIk4WApmOEhuxs/AMVLMPkqjp8pirX2Kzu9b5LeBQ8Q4C4+NUNv9pb7CsrCm0d46F1iuz5RKyuM+cbJdkSmuKSj+mb5M9ykzs675KIXS0TwIRlCLeei9BlwMQouP8dc9ibrzC0AwqxRR/yovfQMXNXqb94fzERxK+eFhoPioYfhVb5MJTZ9ky+G0IUwoYsPMSW1qhhT4JwAPp4BO6qPKbBVgclR54WFNmFxnTQ5vxi7QMT9AoMu0AaZugFlg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 45.8% regression of pts.svt-av1.Preset13.Bosphorus4K.frames_per_second on:


commit: 7b32f64bc512b40b268776c5ac4d354b325b3197 ("mm: limit filemap_fault readahead to VMA boundaries")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master ec039126b7fac4e3af35ebccaa7c6f9b6875ba81]

testcase: pts
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
parameters:

	test: svt-av1-2.11.1
	option_a: 1
	option_b: Bosphorus 4K
	cpufreq_governor: performance



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202606181547.617a6967-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260618/202606181547.617a6967-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/option_a/option_b/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/1/Bosphorus 4K/debian-12-x86_64-phoronix/lkp-gnr-2sp3/svt-av1-2.11.1/pts

commit: 
  0b20c36c11 ("mm/madvise: reject invalid process_madvise() advice for zero-length vectors")
  7b32f64bc5 ("mm: limit filemap_fault readahead to VMA boundaries")

0b20c36c118d2122 7b32f64bc512b40b268776c5ac4 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
    169.95 ±  6%     -45.8%      92.15 ± 10%  pts.svt-av1.Preset13.Bosphorus4K.frames_per_second
    220.57 ±  3%    +870.9%       2141        pts.time.major_page_faults
   5898121            -3.7%    5682645        pts.time.maximum_resident_set_size
   1408522            -1.3%    1390537        pts.time.minor_page_faults
    370.43 ±  3%     -12.1%     325.57 ±  6%  pts.time.percent_of_cpu_this_job_got
    645228 ±  2%      +7.6%     694407 ±  3%  pts.time.voluntary_context_switches
    162542 ±  7%     +22.4%     198946 ±  8%  sched_debug.cpu.avg_idle.stddev
    274573 ±  3%      -9.3%     249101 ±  3%  vmstat.io.bi
 6.779e+09 ±  3%     +11.3%  7.545e+09 ±  4%  cpuidle..time
   7639156 ±  3%     +10.5%    8439210 ±  3%  cpuidle..usage
      3.73 ± 39%      -2.2        1.52 ± 52%  perf-profile.calltrace.cycles-pp.pv_native_safe_halt.acpi_safe_halt.acpi_idle_do_entry.acpi_idle_enter.cpuidle_enter_state
      0.65 ± 87%      +1.8        2.47 ± 60%  perf-profile.children.cycles-pp.link_path_walk
      0.24 ± 46%     -80.9%       0.05 ±143%  perf-sched.sch_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.65 ± 18%     -33.7%       0.43 ± 17%  perf-sched.wait_and_delay.avg.ms.perf_trace_sched_switch.do_wait.kernel_wait4.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.02 ±  7%      +0.0        0.06 ±  8%  mpstat.cpu.all.iowait%
      1.08 ±  4%      -0.2        0.93 ±  6%  mpstat.cpu.all.usr%
     22.00 ±  2%     +14.3%      25.14 ±  2%  mpstat.max_utilization.seconds
     10.00 ±  3%     -40.5%       5.94 ±  2%  mpstat.max_utilization_pct
   5916248            +6.9%    6324576        meminfo.Active
   3659476 ±  2%     +11.4%    4078190 ±  2%  meminfo.Active(anon)
    760816 ±  3%     +16.9%     889730 ±  3%  meminfo.AnonHugePages
   2263661 ±  4%     +18.5%    2682180 ±  3%  meminfo.AnonPages
   6611024           +11.9%    7400589 ±  2%  meminfo.Committed_AS
  11386404            +5.1%   11964152        meminfo.Memused
     21554            +5.6%      22770 ±  2%  meminfo.PageTables
    916081 ±  2%     +11.4%    1020691 ±  2%  proc-vmstat.nr_active_anon
    567129 ±  3%     +18.4%     671694 ±  3%  proc-vmstat.nr_anon_pages
    370.88 ±  3%     +17.2%     434.57 ±  3%  proc-vmstat.nr_anon_transparent_hugepages
     48477            +1.6%      49272        proc-vmstat.nr_kernel_stack
      5399            +5.4%       5691 ±  2%  proc-vmstat.nr_page_table_pages
    916081 ±  2%     +11.4%    1020691 ±  2%  proc-vmstat.nr_zone_active_anon
   4614742            -1.5%    4547741        proc-vmstat.pgalloc_normal
   1667517            -1.0%    1650517        proc-vmstat.pgfault
   2150014            -2.9%    2087812        proc-vmstat.pgfree
    224.57 ±  3%    +862.1%       2160        proc-vmstat.pgmajfault
      1021            -7.2%     948.14        proc-vmstat.thp_fault_alloc
 2.679e+09 ±  3%      -7.5%  2.477e+09 ±  2%  perf-stat.i.branch-instructions
      0.80            +0.1        0.86        perf-stat.i.branch-miss-rate%
  27722463 ±  3%      -8.0%   25498433 ±  2%  perf-stat.i.branch-misses
  47056892 ±  6%     -11.2%   41804370 ±  6%  perf-stat.i.cache-misses
    397.43 ±  3%      -7.4%     368.14 ±  2%  perf-stat.i.cpu-migrations
      0.03 ±  4%      +0.0        0.03 ±  4%  perf-stat.i.dTLB-load-miss-rate%
   3146082 ±  5%     -13.9%    2707716 ±  5%  perf-stat.i.dTLB-load-misses
   1739613 ±  5%     -12.5%    1521663 ±  4%  perf-stat.i.dTLB-store-misses
      9.97 ±  5%    +712.5%      81.01 ±  3%  perf-stat.i.major-faults
     40.27 ±  4%      -8.2%      36.99 ±  3%  perf-stat.i.metric.M/sec
     58347 ±  4%     -11.5%      51627 ±  3%  perf-stat.i.minor-faults
     63.09 ±  6%      -5.8       57.29 ±  8%  perf-stat.i.node-load-miss-rate%
   6474191 ±  5%     -14.1%    5560267 ±  5%  perf-stat.i.node-loads
     58356 ±  4%     -11.4%      51708 ±  3%  perf-stat.i.page-faults
      0.98            -0.0        0.96        perf-stat.overall.branch-miss-rate%
    435.13 ±  3%     +10.0%     478.43 ±  4%  perf-stat.overall.cycles-between-cache-misses
      0.06 ±  2%      -0.0        0.06 ±  4%  perf-stat.overall.dTLB-load-miss-rate%
      0.08 ±  2%      -0.0        0.07 ±  2%  perf-stat.overall.dTLB-store-miss-rate%
 2.646e+09 ±  3%      -8.7%  2.415e+09 ±  2%  perf-stat.ps.branch-instructions
  25808992 ±  3%     -10.2%   23188954 ±  2%  perf-stat.ps.branch-misses
  45057464 ±  5%     -14.4%   38574053 ±  6%  perf-stat.ps.cache-misses
 1.428e+08 ±  3%      -9.7%  1.289e+08 ±  2%  perf-stat.ps.cache-references
    367.11 ±  2%      -7.4%     339.78 ±  2%  perf-stat.ps.cpu-migrations
   2972584 ±  5%     -17.3%    2458144 ±  5%  perf-stat.ps.dTLB-load-misses
 4.801e+09 ±  3%      -9.2%  4.359e+09 ±  2%  perf-stat.ps.dTLB-loads
   1715051 ±  5%     -14.7%    1462728 ±  4%  perf-stat.ps.dTLB-store-misses
 2.193e+09 ±  3%      -9.2%  1.992e+09 ±  2%  perf-stat.ps.dTLB-stores
  2.06e+10 ±  3%      -9.2%  1.871e+10 ±  2%  perf-stat.ps.instructions
      8.54 ±  4%    +768.3%      74.19 ±  2%  perf-stat.ps.major-faults
     59802 ±  3%     -11.0%      53218 ±  3%  perf-stat.ps.minor-faults
   6145046 ±  4%     -17.9%    5046537 ±  4%  perf-stat.ps.node-loads
     59810 ±  3%     -10.9%      53292 ±  3%  perf-stat.ps.page-faults




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


