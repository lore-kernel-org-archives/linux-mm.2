Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EBD8F45A12
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 23:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E376B0089; Fri, 10 Apr 2026 19:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E5E6B008A; Fri, 10 Apr 2026 19:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFD516B0092; Fri, 10 Apr 2026 19:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F9276B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 19:26:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 515FBC209C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:26:31 +0000 (UTC)
X-FDA: 84644232582.24.B98B432
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4D00C12000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 23:26:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eovTnmZ9;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775863588; a=rsa-sha256;
	cv=fail;
	b=dULkcudV5dVFbD8cyA8hpQRS+QCRw7psSJM4DhtozdvDiNSu/KiqBgVjRsjllXlzXQI95V
	DVGfbdrsgU/pZdMTNPDc89uXEEfHvzL/B+zU8eofnG5DmzY+1G+AqhasoW/hHiINaJa8xM
	UPHCB9wjbOCG6EzZ6nWLkqQjjZaLK+k=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775863588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKJLnEGn75U4tTaJx6HzjJ+7mNAq7BQxIDiCkJNGIXA=;
	b=zplRaonYUzwYVz9cnQvNJmUWbLB1oz14JuoyMH8z0OWDXJr+yy4sI4r2rlfx4cbddGuPmf
	PlxDuwizyRmgXDNfLLU1LEyt/nYd79uBz4sEnMMmo1ywevUdYOWP4qwwKM14LV6wwWXbo7
	66k7CDMs1qHb/s70VZvwC0eEAqte5+4=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=eovTnmZ9;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf29.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.14 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775863587; x=1807399587;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=HPebPFh30WAAB7vh4dUtQ80kJh+Qg8SpvmUcPHHMA5g=;
  b=eovTnmZ9lSjNEsCwo0EmDDG+xA2TdWb9tZmXALKWCzHMmHQK5F572A4/
   Q/zJDi4myAkMK4unqVzHSHtPH5fmhGvLnllkE87CqpC9J1ODvIg8qhNxe
   l8MFXJuznkn9w3XSiZfiQFPmqtR+QnVKIa8/x/hK0yYldM8hgduh8Xo7e
   UAXI3IaL9RkLv30brftBaESqaBIAbDJKmTw2Kijgqd7BJY1fiCVRv8WBE
   L6zzc1Gy+RqclFvNAEuNNqJnCRK//SKBTempgTBRmkBUrDxyu+bdXpQsf
   iCzovaobugxbt+klTXU33O/CjiLqc5FItYWoDQ3D1C3Dr6v7rK0l15E6c
   A==;
X-CSE-ConnectionGUID: bj6gk3eFRyGtk/VS5w4cHQ==
X-CSE-MsgGUID: 8zbyytIkSEKi7eGin3ht0Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11755"; a="76960845"
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="76960845"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:26:26 -0700
X-CSE-ConnectionGUID: BXZfgEo/Q3eoZc3nrIpnQA==
X-CSE-MsgGUID: XkoHWcf7S7mnc4wniTMTPA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,172,1770624000"; 
   d="scan'208";a="233294896"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa003.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 16:26:26 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 16:26:25 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 10 Apr 2026 16:26:25 -0700
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.10) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 10 Apr 2026 16:26:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tn2pa9an0e8UqCAohdgi0RC44xjVbHhaE0xNu7TpuRonOUHaR6AS6ePUu+fR5f8BcR9yIT0/CPXbdXMVxawefPXJkoUQDLZXXz4Mjyp7ip2Jy/2P+UDlN+B60sYYIWMB8FG8QuN7cvqdSNast/w4Ft2BrPmpXJ29t58C7JGXYx6uSyDiD9Yr872P+WNXDLUqZ1Yseo5WsKiKJirURz+ED8K6O4J9luLeuM1gbZy5IftK7R/80Vddba+2sevFgCLQO02hHDCLV35c01W5Bf/1IztwZMo+kpH0vqnRTA3J+JyRd66csvA/1uoAZ+sq0kLkCCh4OXjWcFLRA/9gpEGEIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKJLnEGn75U4tTaJx6HzjJ+7mNAq7BQxIDiCkJNGIXA=;
 b=JWsp6MtBZiMAWjmkPo6MJpPWPdAzoGplbPR1yrZsju8DkqjCiLsr7PdGtGn/f/OMD3bt/VMafppfDzgL2zABdpcE5FxdIDmHomAUX31f6MayeUGZ6RGzunTOYif6K0YLkkTUCCiIJTkfIAlaKzQo42WIO/5EC5C6HZAM8IkSSqEtLWmve1mdv/4+foDWyGfpvT3pMKKe4a1B1lFNcz2g1wXydocQGXz0eGErucUsOpHu+8fVKXG1VSz8l+5sqFP9dNiJ/8uBCSnWW8dX26tdVGJCdCgUmXicZDPH9b8PXvVPJ0HccZUrkxJAaLn1n17ISgPL1cL3fXkPBBOFrB0qrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL3PR11MB6508.namprd11.prod.outlook.com (2603:10b6:208:38f::5)
 by PH7PR11MB7002.namprd11.prod.outlook.com (2603:10b6:510:209::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.15; Fri, 10 Apr
 2026 23:26:19 +0000
Received: from BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5]) by BL3PR11MB6508.namprd11.prod.outlook.com
 ([fe80::53c9:f6c2:ffa5:3cb5%7]) with mapi id 15.20.9769.016; Fri, 10 Apr 2026
 23:26:18 +0000
Date: Fri, 10 Apr 2026 16:26:14 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: <intel-xe@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>,
	<linux-mm@kvack.org>, <linux-cxl@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zone_device: Do not touch device folio after calling
 ->folio_free()
Message-ID: <admHFtANBj9nTtKw@gsse-cloud1.jf.intel.com>
References: <20260410230346.4009855-1-matthew.brost@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260410230346.4009855-1-matthew.brost@intel.com>
X-ClientProxiedBy: MW4PR03CA0208.namprd03.prod.outlook.com
 (2603:10b6:303:b8::33) To BL3PR11MB6508.namprd11.prod.outlook.com
 (2603:10b6:208:38f::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL3PR11MB6508:EE_|PH7PR11MB7002:EE_
X-MS-Office365-Filtering-Correlation-Id: 14733355-a2d3-4b17-63e6-08de97589135
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info: 5jbgmVvs+MFqptK0H4LcTGzeNNx0/ORZWB0K4B+ornrf8al8ZlrfHF9LQvWKoYKvO23HkJ1cxZTP96vj8w1KjfCh+w8BjWL+V1aZl6WCq3oHqY26qa/qDKsPdfduKQnkQYr/jDQBx59A613PBwKUQI2Jc2CYto96L+VIQdlgxEUiEOWlnWdR+vNbev8o1nCQ9GvBeEpNEvc7rQOX7bGGZs9bUvxxjCY7J9xwLB7edHcI5PZLCKBDH2HyAuxfcU7KzxsKMfRMobiuaxbGsgeqT+Nc2e9ecisyOvfQcaXFggVasodsL7rv06R1/G1vtvhFRMUCFeUjB4UAsldYdJHqwIx5KM/zOsePJnDvgnhW5PRrbWtQuCnJkSqfwefwW8lFZhINyDpn2OKIAmwLS2EzH/uyGTTkm6X+WFhL0nS5dIrVLC4OJEj+hLbSS3xAfVkuo68gy8sWCk4V5x817616c2RjwX0tww9UZy6atd6erUXtmqnHloVN9lS1VijXNy/SK2yN2bahVtySOK8Xo6G/58ygTaMp2+DshinBOozTsXQYXjUzdhv6GzV3+ZQ5+Ipqs2fB4psdpaWqQs1AHc+PC7YLSCv2j6LcYK/UB8Maq4mQU6pnmuNndrJsb6T8MI/6LLYaxc9zXlLo+oK9KcZDtgzCPDzGoOuGDGnU02bZ9FfspgiFlMvlg9t0POEcbmAHaFBb8CKp2WEqEYHTGdxAMxBr1onlWqR7TS9w3T7LA00=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6508.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SNVY/FHjEf4h1b6R+xiDIy8W1Vw+zAZ0zFWsHIESdvYN22J2TpnSCBOKW6hX?=
 =?us-ascii?Q?fXycy0MzWwyuNDvXUdpXiMZlFOokqp/Cs50NZU/MvHqoVdsiUg8e3RwCtev5?=
 =?us-ascii?Q?EZLqLNX5tEnHnd5XM2PEtwPmNk7ws3dy24BbLramMByH960Ks+74oMS9Acj2?=
 =?us-ascii?Q?qb5Exd8dtIXBHcHveWxNSElEZmqpDBfYvpwFervmwq8prQyVhfVmGRWxl+e9?=
 =?us-ascii?Q?q62tqZHZe94DOxgVY5N7YkW+R9TAuUUaijTAF89EhxD6qETQ65BU/MuyBSxp?=
 =?us-ascii?Q?BAH5/zHCOwdLAYQlxOLpZgR1jP94HT3IIU/XqlKlDjVCh8AiQZlRx6tDmSXT?=
 =?us-ascii?Q?mkFpSTdQK07Xf7WgOmMKoNYnnYUHuGmfEgwrw1erH6wZjYdarCfq2F3NVc7S?=
 =?us-ascii?Q?sKZhh0t2XxGDZJa+wXocO+Xm2JtNPhUqAawWi81CESVK1A4hfroQTwu4W8FC?=
 =?us-ascii?Q?RjDTbHm3zH9WWIltvWD/4blW2vwp8iQRig0+O1wERHO/vrrMLT50VP/T0SeH?=
 =?us-ascii?Q?wIUJiT6bqqzCk0ClzY0PsO6LU2mo9AUnTBmVmQDjOINa8EuT3K7qisd/pTNG?=
 =?us-ascii?Q?4s1Zbrv37CBuy7ddn1u5HRlwclvMvHJxxHi14xHTDNCs8NPZJdtD1zuQ9XFz?=
 =?us-ascii?Q?WXIgY4k1Fte/QGe54e5r3/p/eQ85bmIJC6QR4je8E6SKhdB6cltUsEadHAW7?=
 =?us-ascii?Q?/B60qdN+014nRfHIXShnBAVk5PTKy0bAk8ezWCtAyzAbfzOyMQnAsA++39Lo?=
 =?us-ascii?Q?ECAxELEE7G3brBra/kCbEOpPsbEY5DpPIeFhstUMPQ259eeo8GD8N++YWUXg?=
 =?us-ascii?Q?x+aBpiVgHlZmJu29kE3M1E0lCDQYbHU9yxilbta4N7AsuPdmNHun2jU1UexS?=
 =?us-ascii?Q?KFTbvkKsKfZOWNIgaD038GM7fPUIWhCmOSWHazMzPqbrVW4QQGv8AnZb/2tx?=
 =?us-ascii?Q?RGt0z+MJUthPhKrEK55oYMltuk40H4LTtpukYVBqtGPfifBK2rdrtstAyETi?=
 =?us-ascii?Q?mEV0v4xfwODu1tBYLgOvZN0byxXSH3gkmIEs9pOdY4/vq+yUEQwd2MbWZJUV?=
 =?us-ascii?Q?mDlPJXNddMvBY5mi3kEFc4sc9iX25ddQIB01BLfOMvY0/nMerT+9cSlzY2kr?=
 =?us-ascii?Q?zuN34KLL5CNUw7BqN6wN/+0UeqbTIr16Xlz6ApdkGK7nPh1S79OU6w76/1Rm?=
 =?us-ascii?Q?XFH3PKJufNMpnQpT2HhUZcmxqw3x4RY/nSAbH/zjd3fQb5rsbzbYx5cgTD6m?=
 =?us-ascii?Q?3ZX467uvyv8fruQ7eiaTp26ucNJ0yqke+B3gWn6s0mWYBOH80oPNJwIcyFiF?=
 =?us-ascii?Q?xTBsBEkTbPO5Vt6TUHP2w7I3qgq6WGPlTK6y3jdn4n5nIUr+0BlTJuBQAXic?=
 =?us-ascii?Q?Ig97pvBSCM0t+hxyL46jLKfFS3oMm356sF3VOLVTbXoBXX+dpj29QKw9c1fC?=
 =?us-ascii?Q?7E+HgfuwyYudFq4JqKRnaUlzcqx16r4jf7r8CkjHVQTt6he3fLs0sYKW/Xa2?=
 =?us-ascii?Q?zPdd9tuJKBTG+QQ0JH9mqPZa6ozHmFWeJkjVkTkfdR3O+YlffRYYaAgU3LNt?=
 =?us-ascii?Q?dMsMIsb7urq1dJ3tvhDXYJncNnwh+a38ULhDM3wTiNxa9xpaYqYGCczFXMq0?=
 =?us-ascii?Q?5f/kwNIxrG5QAq9Rn26FJpua/5iWJOJEBXc2NznX/BfYcQboj6Admnbw+0ds?=
 =?us-ascii?Q?Z8WDiZHX21zclSM2+Fr36jzclhWD1EJNWyVzaSdOiSzI5gvo3biN7+WCv3tg?=
 =?us-ascii?Q?PVL0raIH3mfXZKLK9d5+ec1S1TvXUPY=3D?=
X-Exchange-RoutingPolicyChecked: N/jcxJcTThFXMbPlewnIRll0suWVfdTA4dx4lsxmDNC0SZTzjpxxW0fsF7YJTtO+3jCZV8Z8TmR/coEg7n3vvc9ItRZisXC/XnpfSQrLl031qWArCZAtaFxYnFKN8kKlm7Z2vlsArOWSntNddyxg+zID2kJFDfgDgkvd9AO0ohhy8t52o6a0IN8E/aynIctawkhmxF+vmjQEcVfOk6YKMyTDbydOtCfklDia3JO401gy4Djf98LXWitGGarKos0B3HF5iHoO65EUTFVVQxiXsFuiNXCj/zR3Hd0SnqjMtV5PQbDEnzYpBCJUfWnZq9Q6yqB6X0nOZn6CoVHHje3Wug==
X-MS-Exchange-CrossTenant-Network-Message-Id: 14733355-a2d3-4b17-63e6-08de97589135
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6508.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2026 23:26:18.7992
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tvx1gmtvgEwEFVBz6RR7wRrL+qbRLwUklzN0YPU3VVhlhXSuGlIKxmlHjrpGNNfC+7D5Xxro1xB2POUxNfxXYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7002
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D00C12000B
X-Stat-Signature: 59drwspm7c71m3oiaxo5xmh9bbh8n15b
X-HE-Tag: 1775863587-780641
X-HE-Meta: U2FsdGVkX1/TXO5iwbEi46rBgT+kOG3b+kGiMuniG4V7WigYuPOtoy7libfuPlxcYK2yrG6SSxvk9YkTZ+Pfq3ZX+JIhowVBIFecSlSoG70JlaWp3lglt3WZWKzfArhtgNZ0aHEUNZrSU5dqiNKagZOjKHtYk9BGSq+AFQawF+7wRZ6bqy+DpQM4uFclByaKNJrkGBU5L3MRyexsmAOEjpLzlZn3B42J16FHZXsCPRVhjnZqHDGnDlzLNNS+pu0lrw6TbZyJogQK0fN3zViQ4op/KhDGh+WkNIhyZqA//UxQFnpnXBpO7fy6sAzzX54r0Ybgxgzpc0StAnLwxa8ABRs4AXKqyEze+vQITGUS0ZpBT9fojUsZ8QJRyF1UMgQCaKxVjjbFC2VoBtQBmZa2zrEvstPEMjokkJ39kU5Q0NWSd1LFpqC/RrMKl9rZq3kGAmx3H9+/OJD0UX/QkK4xDk2W7YmovNGZoZFFl9ofucF6L7Fole0m1QdHYmA6Mchv4tMMKHnRNSIiWOJ/KWW8P8IqqbzToALpIKskQfe9nssRsYJaPgodYwUYw6t1756uwR2BKl8tCYEfy1gvCMwRPpFn2R5tvDpPd/uuagtmXLXElSEsUdsU8TDE5m3cghaqie9WeZdW/PAHhn0iJz1GmZr+19weRFP34R4hRkOrRKN1FNVWmLk90j+onQ+SWiXlM4nrE3gkPoZCjX9qzdCevHwlwiN+Cl2PHmc0TlKFXrsETGJaZ1I7lFU1Pmv5PewzAQg15sq+2s6jLMGDIt12i8XpS6m7DThTn1nuEi4OczEFEUCxr8aOcE4/Krp6/T9nutToAcl7iPFsPB+cpJFyQ16aNG8lscm1gkAeJARLhpgCrVGz+ytQUHSCMAMEWpYuxsqyFGHiSodg8zRAuWxHJSqHg0//Pmx9/jvFyWM8QXetj8oRNCmCmnGQpgAPqU2cls489ueRhpWwluPz0Yc
 eoniXv5V
 5rpIleFoaD9m6ny4URLYPdwmLskPLPVlMMuWmlOSl7BYMHNj1T6E85ZqLO8Ge4paPfo1bhrhMGaf6g7wO+KaoO0Rd/PzMgfri3NM53tqEfcM/PbhzZgpGhys8e9BzlDtMPAMv5IDMfVf8nW2/EOP5gu65fdu0rDq8/a1GS0NqdMF1GQsfrt8zPa/+aw+MkHnEcE5wdSi0BYT6OcOeXPqfuItSjrrqljyvwlTSLHJAVmoqGV9e+7/w3krlA9PPixb8VFEp+yjySv33r2K7pYMAqvwRglPRsRQWTu7ZAi7mPn+mfPDAzBhGAuQKlH/ZnBrsUbp7fJgsmCnOahA8MzFxu4QC21zQd+SxLhqeaX/fVmVnE66ly5SkuRedYVAgMz7v6X/SABmZdZGAErt4z7goe9YfQVHqEFLF+Q5nmHcxoSlFeLn6198EqJhJLqZhT7f+oE05T60njbltFDRfHEHbG4hNFKvR+TQoq6WLtnu9mCNvI+XM2+G73qaqhmsB5yI8N66mm5vqJmY748tzCXlZFrpJr9JYrK47Bug/eKwk3jqhYq3JtTgy4sF0ioTJcHeHSKZ5MFO18nzti/UkyvvfhCALfgm4QWyzTpWlMUHXMGFsDAZ+u8ol89VpwoIHrLSwekXUQafFlAqF1U+d7/KtqU4kTq4KHkF7M00Dvd51P9fvGJcBLQKudeP41jQx/5QHCGUgSzKRxDM9TAt/MzFAiaj1eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 04:03:46PM -0700, Matthew Brost wrote:
> The contents of a device folio can immediately change after calling
> ->folio_free(), as the folio may be reallocated by a driver with a
> different order. Instead of touching the folio again to extract the
> pgmap, use the local stack variable when calling percpu_ref_put_many().
> 
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Balbir Singh <balbirs@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: linux-cxl@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org

Cc: <stable@vger.kernel.org>

> Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
> Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> 
> ---
> Stack trace:
> 
> [  631.875165] [IGT] xe_exec_system_allocator: starting subtest threads-many-new-prefetch
> [  632.282992] Oops: general protection fault, probably for non-canonical address 0x900000000000000: 0000 [#1] SMP NOPTI
> [  632.293469] CPU: 8 UID: 0 PID: 59267 Comm: xe_exec_system_ Not tainted 7.0.0-rc7-xe+ #281 PREEMPT(full)
> [  632.316023] RIP: 0010:free_zone_device_folio+0x149/0x240
> [  632.339782] RSP: 0000:ffffc90023d1fd00 EFLAGS: 00010206
> [  632.344947] RAX: 0900000000000000 RBX: 0000000000000001 RCX: 0000000094472d4d
> [  632.351991] RDX: ffffffff8155c76f RSI: 000000006f2213bf RDI: 000000008e84943a
> [  632.359042] RBP: ffffea0ff4030001 R08: 0000000000000000 R09: 0000000000000001
> [  632.366094] R10: 0000000000000028 R11: 0000000000000000 R12: ffff88811828e400
> [  632.373145] R13: 0000000000000000 R14: 000fffffc0000000 R15: 0000000000100073
> [  632.380194] FS:  00007f2f0fdfe6c0(0000) GS:ffff88890a7e7000(0000) knlGS:0000000000000000
> [  632.388186] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  632.393870] CR2: 00007f2f002e90f8 CR3: 0000000106708002 CR4: 0000000000f70ef0
> [  632.400919] PKRU: 55555554
> [  632.403605] Call Trace:
> [  632.406039]  <TASK>
> [  632.408131]  do_swap_page+0x146d/0x18c0
> [  632.411938]  ? __pte_offset_map+0x3e/0x190
> [  632.415994]  __handle_mm_fault+0x6e8/0x8d0
> [  632.420053]  handle_mm_fault+0xbf/0x250
> [  632.423855]  ? lock_mm_and_find_vma+0x41/0x6f0
> [  632.428256]  do_user_addr_fault+0x168/0x690
> [  632.432399]  exc_page_fault+0x74/0x200
> [  632.436117]  asm_exc_page_fault+0x26/0x30
> [  632.440092] RIP: 0033:0x5587554ff70d
> [  632.462142] RSP: 002b:00007f2f0fdfc970 EFLAGS: 00010246
> [  632.467308] RAX: 0000000000003fc0 RBX: 00007f2f082e1fc0 RCX: 00007f2f12b3287d
> [  632.474355] RDX: 0000000000000000 RSI: 00000000c048644a RDI: 0000000000000003
> [  632.481404] RBP: 00007f2f082e1fc0 R08: 00007f2f0fdfc958 R09: 0000000000000066
> [  632.488450] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
> [  632.495495] R13: 00007f2f082de000 R14: 0000000000c00002 R15: 00007f2f1319e000
> [  632.502547]  </TASK>
> ---
>  mm/memremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/memremap.c b/mm/memremap.c
> index ac7be07e3361..053842d45cb1 100644
> --- a/mm/memremap.c
> +++ b/mm/memremap.c
> @@ -454,7 +454,7 @@ void free_zone_device_folio(struct folio *folio)
>  		if (WARN_ON_ONCE(!pgmap->ops || !pgmap->ops->folio_free))
>  			break;
>  		pgmap->ops->folio_free(folio);
> -		percpu_ref_put_many(&folio->pgmap->ref, nr);
> +		percpu_ref_put_many(&pgmap->ref, nr);
>  		break;
>  
>  	case MEMORY_DEVICE_GENERIC:
> -- 
> 2.34.1
> 

