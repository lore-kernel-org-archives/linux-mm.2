Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6401FCD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 06:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C7896B0088; Thu, 30 Apr 2026 02:16:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6516A6B008A; Thu, 30 Apr 2026 02:16:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2616B008C; Thu, 30 Apr 2026 02:16:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 346AD6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 02:16:56 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D44071204C7
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:16:55 +0000 (UTC)
X-FDA: 84714213990.09.A974230
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id DC901100002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 06:16:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PPDrlHaA;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777529812; a=rsa-sha256;
	cv=fail;
	b=DTEg5ow+hnUJP2qEQmlT2UQPp4DH9Ho65tUD+Tatdf9h0mHIsOcfT7ipWkoXZSBdcsg7s6
	/l7Kly0qtJBDqRHSN0Hh4UhSWTRCTkrt/QNjA4lTyIqNseILihKc3QAki/iWq1P9zzpWdd
	tdO1t+msD1c6mbF3k0ZKscHEgM/7fl4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=PPDrlHaA;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf14.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777529812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nunu3Zghgq6rOjOjUR862Nm67qacyq7uMyqoLzMswQY=;
	b=WVGJVO2Fdumhe5xTsm2keXLpMEWAQr7QSmtMNvr7b+EtW3h0P1rdMJFGfcZjgNHkXqiWq9
	Q2Eo9NJ7nwGu72g9bSIcN20e/rmmGZpKJ0195baOy7EzYzk/uQtcECrZDFsDDTwoGTWe7L
	uMWK7luR3ViPP5wOi91CK8oYcwIy9fI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777529812; x=1809065812;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=jGIIDJaCLmho0A0E6Dq/H4Mz4G1Fb600u91LXdMWaGU=;
  b=PPDrlHaAHQ2PuobfgGV16hibZtQrUCIkTk9LWcysvMc+2k0f92OTDLyJ
   +39DWHc0dQzn2Tiuibj/bRmuWqSAaqHiYOaXduv1EegO8tb9HFdRnPOFf
   wFrMJTv8brheyLW9N6WpXwMoOCYN4klspiFVti+wmFUPmd1rG7VBmUKQf
   pxAVyrDjtAHf6DBJYcjondzQpmoaRfqe/UUVytZzpd5PUTbfqt9j0ynyC
   NWu7uxU7d8d2juQ8a1S6U1H2VI4kZ/v1IatZoXqlXxXikLjfmtdx+sBfv
   Z5fz9v4I8Oa0FCnVzzQ5QH1FAy0WBmbL9D15LaFYqgQ6/oNJsrpwH9M+i
   A==;
X-CSE-ConnectionGUID: 4w/xh0qSQEiqElsd4bB/Vw==
X-CSE-MsgGUID: neyTbTSzTwqn7sgCbCf4pA==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="77636107"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="77636107"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 23:16:50 -0700
X-CSE-ConnectionGUID: lLEZ69uKQO+IyVjPnrBhoQ==
X-CSE-MsgGUID: tEL+lIdfQmCqyJu2eSjHiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="239470505"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 23:16:49 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 23:16:49 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 29 Apr 2026 23:16:49 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.0) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 29 Apr 2026 23:16:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S6pXI3I8FsmOwwint5aHNliPex37BHRauyAKcPPtMXGcpPEaSsdjWEd0765MBxnRpKrjMmza56k/5uF3J3O35xoi8+qCYXrASUFcDCdWxHX90iJ9PK5ArlS96lYEV1nqVgOg77ht6JvcqieWyexrWOLHW3hoGFJYv0uJkreuiQZ5hpoi79fbJhd1rWxiNZMV7yx9JCWiK2pntIIL1aRMrNpCoY6YI7yz/tbzdTfETw+DIPW6zO+jRqBx/a2wVVNUMVmma3GiCiOE86Hct5FW53nYFu44KUf3qXSkIZNVBbEjDGnAPsMWbQM0Sl3w6gg8jvcNESOwUABBF3heU/94jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nunu3Zghgq6rOjOjUR862Nm67qacyq7uMyqoLzMswQY=;
 b=isZ+rDBIkTsfcWE3FfCN16J2r5p7wQA+GjxXw3h2NfZtPsJ7MB/dibr6g/kite8kXE6L9rOXCGvTBkiFIcIGk5oK4kKZ7NUtYGpCEAEdx5piiZMZd9FXNC43sUOtgFi26AD/YKUF4nABmBa35ml2ybrqcJ0WItAkaCAjJnWta7p2kmuXBJsczkoGAGYCaoNdlTQKfNP4+OfrULE5mPJ8m/dcUAhfqKtENTdA54rkcpE8b6hhue74c2xR+1siLSC4dtIZQrZU3VyiIgr1NEinzJu1mYM9tVjprucgA3GPykr2KloWlKqE7cdgcVDpQt4lE1DNMRDyz6XplLt4DGJRLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by DS4PPFC60125F65.namprd11.prod.outlook.com (2603:10b6:f:fc02::4b) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 06:16:45 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%3]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 06:16:45 +0000
Date: Thu, 30 Apr 2026 14:16:37 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Shengming Hu <hu.shengming@zte.com.cn>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
	<linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linux-next:master] [mm/slub]  8952728641:
 BUG_kmem_cache:Freepointer_corrupt
Message-ID: <202604301428.e2b8d3dd-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR01CA0016.apcprd01.prod.exchangelabs.com
 (2603:1096:4:191::20) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|DS4PPFC60125F65:EE_
X-MS-Office365-Filtering-Correlation-Id: 71c9c452-6da0-4c50-5638-08dea6800dd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info: J42xMF3VAx+KLFTfuyEZQmC2haUQ5OBgA4Wa5eGHXtHAyELE8UPqZWPum2Wz+r0cw74zdZ6GC6fGl8zMh+x/mo/aH+AmRBYWJS56rxmU4Qy80HdHeLs7a9GRoXpp3OaV8gdg1cgf/ek7IilIH4SFu06vxNBMAOHIbXmJWsd1EV0/dZp99wfVU4blUtzq6/Uch5eQjSFNxalJyyBjMz1xP5Feh7qwhX0aPV8XhehxRExDvFp1lGJFtM6zXpGVpBlHGiniyt4gogYMb0xrMD5E9Y8cQUkxD6cWih0+qlGREJtt3FkhqvYrDOI/WYD5aVsHkxmBTWHWnLHhNhpnE3lt/XK2OLDQLOeMrq2ig+y9z3xKmsoXbUXcMdz7r2FuUNSnnQ071KeQcJjr2pKZ6Gt77i/wACDxvpDsbBUcBkDXrP65TrDGANLxrgAmaJD9kRSlywoU4nWsXm+j4ln9NH3+pxmxWnDzbG9LQgfujNi/hBYrcZUbItcwzIuBtCN58G8qu44BjDoOVy8xLr4xk1UYGRGwvlfg56n5UtCi1PCiTNvVTD2s/rQCkXeeRTxcGVHgvBWJJwyjlrSo8QpBfvN/YtHD9jsSI1m7VtudSDsfy5fO0Vz6lN16rDZY++G+fnjiUtLBZQk6LcizXBMqopvwakAIco0ZegteFl2ZU5PlLuvrbl8DIxFLgbYtvwaOv4d1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?La/MGTSsN2SidrMQWysV8L9JLG5OhL0MWigRUW0BJPfpIjS6yifG6lf26BTa?=
 =?us-ascii?Q?s3DtZ+fbqIzLIJ0/CURjWmVQgTXvAnFllfqiMIxFQb8NialzCbsfo0XOJb1a?=
 =?us-ascii?Q?/hY7T2Ly06JGkMtx292yuRtXh4H9fjWJzTb86GUAyF2RD/FsmXSKYdBhw3ZO?=
 =?us-ascii?Q?PqaFi2eIF1rt/MkWpR29I2lY1MUh06U17k9HWqxBlOYbqFJqc+Sw2KrqpA4s?=
 =?us-ascii?Q?AZBDjAisYhbJiKC3g4xZfqJe04m5J1ksbkCp96kSxk6BTzCL1QOjIfWI/6dg?=
 =?us-ascii?Q?UtnZU4dloHLR52bGXZ3na4a6EDpo5vIsfe6jtGfoFOMKLs9QaaiKcW5Qu8oP?=
 =?us-ascii?Q?xnzmZfcCO8+ros9CXiTUYdPMzdue+4krTsjXlhbSnRTcmflYskUdc/zGW49R?=
 =?us-ascii?Q?Cao3Uftyo7ztIuyNU9euP/LBmjoq5tBEMRMrEciSscH7Tq56hkHPRvRE5L0u?=
 =?us-ascii?Q?+oID1PLkK6rljTZviJUow989CIvRFeYPHOG/7UDnG3ZlzddPpPUy+PTE+5Vp?=
 =?us-ascii?Q?QowfvQkI3Nh8jBks1Cv2hnU6sWcVgZ6OoyNlS9+a2aYhmalV+bfAMPE0cBVK?=
 =?us-ascii?Q?xOY6/G6X5nLMKFnrocOy0sJEgDQg0R2VBQC2UkzlwMZ8BMhh84QQe6/lcgNX?=
 =?us-ascii?Q?nergqjnJb6btHnLfM/LKxAYC21wGZAo6jxncVTT6EVXkktIBiv98NB1pfhpY?=
 =?us-ascii?Q?n0bEmUFywEFBsmKnh2s5kMnztn8jQej/cxv1qQxtrxcDhOs1EbcEkZIrAhkU?=
 =?us-ascii?Q?PT5iB+bfS4kGZvyDZSc15X77K0Jk51QH7vleR/Fzomigot392fGZVbEtwIae?=
 =?us-ascii?Q?iNKFLR/qhu7BDqvzbhLauS5x401zNsoe/itl98MLwe60lNVYmXvvYYazlwab?=
 =?us-ascii?Q?MxQQNOueuFQXpyJkpwAIcP009Aw4vQHWLkw4cWqHy/N3WQZaaGDmc7N3d+Wy?=
 =?us-ascii?Q?4m5ylUyi9WcbyizAj0GORrhP177d8IR38ihvbHoOOdg5hG3SQOEKUU67iXLm?=
 =?us-ascii?Q?pjt0lmax0a077l6KvLipR4zIHSevw5SBeVSQ2zP0fmZImlI1mrEUfoRXkZrI?=
 =?us-ascii?Q?+UcKCSg43lgh1HfLpTzXSfmBkaP3GtBXEzAuB7KS3CcOAxR4ISNMh7FSOhLi?=
 =?us-ascii?Q?vwrW4w6lvkgDHVEqFPUGA9hHc2bH8GyCfVE2AbqldCkQm4dS7D0xRCfoSz6E?=
 =?us-ascii?Q?hTTwMt1q7A9CEJD4q8SW92G/gqmr3TzkFzYIBN1Rra4C2pdeeqMoPPEihUTU?=
 =?us-ascii?Q?NBGeoC3ZtuFJKuGwPw2zZMOO6a7i+6DN0qAvyz3pOqp0woDDJYQqWvqn38V6?=
 =?us-ascii?Q?wIg89W9sDOP8XE5sBWtbuaxOOxAbhCEwleYqKsXM3lob5bwGi8+N2eqI8Yl+?=
 =?us-ascii?Q?8/BotI89vmNd307i2P63xu0OGiP0HkCz0DIVG5D0spkp9dLTCsb/o8bQgRuf?=
 =?us-ascii?Q?umQdmhpbk31VIJXHTbicAsSWJ0Yo1pvetWN+F38MCye1C1yBjugstbCTX1ZJ?=
 =?us-ascii?Q?5tO9vNZMxu8QP9xrwcA95lqThpUtIJy/35svy9eG57uUAdMxvph4Wkc52BCc?=
 =?us-ascii?Q?dmuZlJnj7ErmPg58n5e1q2YhAJuZYU83dzuEKLzyEf0xpcpdSmDtEMxoOMI3?=
 =?us-ascii?Q?VgD7SY1RDJEW86LShST9PmXeuEAV7tRTAV84vyfOV8nH5wSpiQ/rpqP9ToWU?=
 =?us-ascii?Q?JXUQ5ap/B6AjmZr91Wu03PEj7ju/8m39n9nFJx78Kels7c32D7Ay/wCDq73M?=
 =?us-ascii?Q?oxh/n/rAgw=3D=3D?=
X-Exchange-RoutingPolicyChecked: jlHoL+gz+2HjTCaRkniqGlrSynw8KINKXjS+dwgKWNf0MhdcaUIFNLjZSsASsIsq8pxyZCSAeBifdFBSKXenm0AfCF+4s3+L9oIHGaX4vZaUz7OhTil6i4n7ZC2NLMceuV1V9s6MEzQAFNY37YKzMfUzr97q//s+K6wxH3YPAGfYvvDhsD/nZ/ytPj/Po203Vm7xhtQfce/p4a90/8W4nyU2nMDlLTmdbNishH9aMLRpkAWQ8zxcG1dBmJmqzBTPQvWEk++FDebe5iZIZZn4FtucdViNWAd0f0a5hvqDluzp4Mxvss3oaM9WrgKygp/4LNeSXBhDoCHdNB8DcCKlJA==
X-MS-Exchange-CrossTenant-Network-Message-Id: 71c9c452-6da0-4c50-5638-08dea6800dd3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 06:16:45.4139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9ijk37V+eQJm/yVWt27v8OZsqNa1eIT23SZFtYhPXZrVac/MYZ8r6Ebbpq85CfH2KEd589rfDjnrygR9HaCJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPFC60125F65
X-OriginatorOrg: intel.com
X-Stat-Signature: dfpkiia1dwartwhn3tdq1f6ap4az7d8n
X-Rspam-User: 
X-Rspamd-Queue-Id: DC901100002
X-Rspamd-Server: rspam07
X-HE-Tag: 1777529811-13724
X-HE-Meta: U2FsdGVkX1/9vzlJhABrquvfHQhaE/qGXksuihKFEv+RLCFHOFKHHE3XXhuZHNiFNLucBYhZ0B6KNTDZ6ZVJ+O+zdYlTzz3qWXlnjU6FcbOlruQUbxze9r/dP43qtFrRqX4mg4Wsn/ti2npT/UHQsIs3seq+GrVP0RwxB3lJoc6vsxbALFVZ2BTdOFIG0Ipaaq0Mx6VqH1J5iazaUcNC/CZPs3ZFNg5+L5pnPtKKDFOJwWueiViSj9qPBqBvJl/79yhFVtDQZQ+0GWykfHRd/CXSk65hMN7Y+NmFUaJCaDqeGJbIiKcevjjkzmdWWowTlE39yz9K/W8E91ASgB5Tw74f0REbNj6Qori8vUDVptX6sMBxjiaE7wwPRJ2R19G8+edSjtjpGLELpcEWR/IjaftJM8YXU4+hYCV21hftf4hlyiRwgYjh3k2YxvQZQ13TvZOiDwvzrTzYbeftT5Tu2IxvcBPRbfRbSL37OuGubyAeXytulye8l+qgmUZ7zaoamToCaF5DGdSo9st5er4EJF17BLb4GGiZn4eo0DPHlrVLOQkB41Gs3aLsD/ix5rWCY4f5+rX5Q/2rOcNzNkFLZV4HSZJbeK8GxjGhXQvdcmDTBtfVWs9/yW2E/nAUqr+Y9/dZxn0zfgqQFJOyOzoZHseev6vhbfxYaOzqHR3hraHkh2xOQ6GXIY4p5tpL9/ueSzMcqACXMYaT4C4+NyFy2QSFFZ7RUnIQNSzcdGEKFopH+h/XjjrBYrYZgXv/D4syZWBInyHaLmwu3rKPjS2C7B6Wirb4MHnpNZA85hzMb9r6ZW5gklXR5EB6biH1s/dVNg6ftsnPCrxCA2h4wNpOAXNJyT3sWUzGZszpoTBOrIusbCzbYSs/zdQ5mnAiTEm6qLbEK5MUp9exT95qbbPKkEw2T3Xqby4j2TSvXavCZgo3uDxXxKWMyzVTfGaJCq94Bvhd+xNAFGyx+l3z/2C
 v/G/qQ+4
 Q0jD6LRnj6Xcvy7B2/LZsiHXHBKTwEEbY7RHz2mwzArM4Fd+J24v+714aBGhHzsVGFJWi5WcPodl+Kodijc3Lg65t8qgtHUMO8TzvtpAg6wy2RiXeJILuVDlUvG0Yjf0M1eulUglrIjlf8rZ6Mslzn3uxHrUtE8kxYScWqaYXIa2n6rQXrb9iqktDj2KIIBUQ61Lo95OnbW6+lkfaQw3bry+RbsOILYrGWJQWjqxzOZxlYYhRPwlqAi0vCUlN2H9doRbe7/oKWtUOvaMvKVmK4Ys+p85fVFWp8tTn4D9diWZx8g1XHmenxTe6fJyI1fRqz3pdGT7DWAqZiO1mIvpHNRN8mjFiC9m15bfzg1YY3tlGjnDmefF4Rbj1sa/JwxWH6AEAEFODojliFmTNR10CGRG/Zz0XSWZRhkudjC8GM4ZM6FXQ7twC5mxUAkj75fjP4Yk6g7cRNyoL/7+wvKg4u0E1fLCaLg8jG1ZFblBvOwTqmcmCxBMQ7cRqbtYa+3iyzbjnwe6Hi4sQkR0L3mSPZO+hCcIc7Lsw46eHVx+PbjmkP+jiBcLK2pYU+4h9jsKOBWGJ2LuzMzrsyDAcAgWeF4qsF8z5Isik6OVCXUF33RhZ+oQN+WJSO5Z+UkILWPcIGe9Tvc9mKvQ7Bgn9eRjFIpVS2krCaKZ9G+bnMywPc2X0Ric=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG_kmem_cache:Freepointer_corrupt" on:

commit: 8952728641305ebcd03e80f79b8d31bb41d6d95f ("mm/slub: defer freelist construction until after bulk allocation from a new slab")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[test failed on linux-next/master 9974969c14031a097d6b45bcb7a06bb4aa525c40]

in testcase: boot

config: x86_64-randconfig-001-20251114
compiler: gcc-14
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202604301428.e2b8d3dd-lkp@intel.com



[   53.929047][    T0] =============================================================================
[   53.931786][    T0] BUG kmem_cache (Tainted: G                T  ): Freepointer corrupt
[   53.934858][    T0] -----------------------------------------------------------------------------
[   53.934858][    T0] 
[   53.934858][    T0] -----------------------------------------------------------------------------
[   53.934858][    T0] 
[   53.939608][    T0] Slab 0xffffea0004001040 objects=9 used=1 fp=0xffff888100041200 flags=0x4000000000000000(zone=2)
[   53.944008][    T0] Object 0xffff888100041040 @offset=64 fp=0x64ae22a70baa83ae
[   53.944008][    T0] 
[   53.944008][    T0] Object 0xffff888100041040 @offset=64 fp=0x64ae22a70baa83ae
[   53.944008][    T0] 
[   53.950913][    T0] Redzone  ffff888100041000: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   53.954703][    T0] Redzone  ffff888100041010: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   53.957662][    T0] Redzone  ffff888100041020: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   53.960527][    T0] Redzone  ffff888100041030: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   53.963607][    T0] Object   ffff888100041040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.966785][    T0] Object   ffff888100041050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.969753][    T0] Object   ffff888100041060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.972621][    T0] Object   ffff888100041070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.975559][    T0] Object   ffff888100041080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.978756][    T0] Object   ffff888100041090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.981898][    T0] Object   ffff8881000410a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.985140][    T0] Object   ffff8881000410b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.988289][    T0] Object   ffff8881000410c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.991279][    T0] Object   ffff8881000410d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.993987][    T0] Object   ffff8881000410e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.996539][    T0] Object   ffff8881000410f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   53.999493][    T0] Object   ffff888100041100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.002253][    T0] Object   ffff888100041110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[   54.005170][    T0] Redzone  ffff888100041120: bb bb bb bb bb bb bb bb                          ........
[   54.007879][    T0] Padding  ffff888100041180: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.010661][    T0] Padding  ffff888100041190: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.013403][    T0] Padding  ffff8881000411a0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.016151][    T0] Padding  ffff8881000411b0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.019282][    T0] Disabling lock debugging due to kernel taint
[   54.021208][    T0] ------------[ cut here ]------------
[   54.022797][    T0] WARNING: mm/slub.c:1231 at object_err+0x6c/0x7f, CPU#0: swapper/0
[   54.025237][    T0] Modules linked in:
[   54.026745][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G    B           T   7.1.0-rc1-00001-g895272864130 #1 PREEMPT(undef) 
[   54.030461][    T0] Tainted: [B]=BAD_PAGE, [T]=RANDSTRUCT
[   54.032017][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   54.036374][    T0] RIP: 0010:object_err+0x6c/0x7f
[   54.039295][    T0] Code: c7 c7 1f 95 42 85 e8 b3 1a fe ff eb 0e 48 89 da 4c 89 ee 4c 89 e7 e8 13 fe ff ff be 01 00 00 00 bf 05 00 00 00 e8 c4 f7 2f 00 <0f> 0b 5b 41 5c 41 5d 5d 31 c0 31 d2 31 c9 31 f6 31 ff c3 be 00 10
[   54.049629][    T0] RSP: 0000:ffffffff85607c40 EFLAGS: 00010046
[   54.051811][    T0] RAX: 0000000000000000 RBX: ffff888100041040 RCX: 0000000000000000
[   54.054369][    T0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   54.056862][    T0] RBP: ffffffff85607c58 R08: 0000000000000000 R09: 0000000000000000
[   54.059766][    T0] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff86ad8f20
[   54.062963][    T0] R13: ffffea0004001040 R14: 00000000000000bb R15: 0000000000000001
[   54.066945][    T0] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[   54.070095][    T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.072475][    T0] CR2: ffff88883ffff000 CR3: 00000000056ba000 CR4: 00000000000000b0
[   54.076829][    T0] Call Trace:
[   54.077963][    T0]  <TASK>
[   54.079139][    T0]  check_object.cold+0x4b/0x50
[   54.080583][    T0]  alloc_debug_processing+0x9b/0x180
[   54.082495][    T0]  alloc_single_from_new_slab+0x82/0x200
[   54.084323][    T0]  ? alloc_slab_obj_exts_early+0x5/0x2c0
[   54.086455][    T0]  ? allocate_slab+0x11b/0x380
[   54.087892][    T0]  ___slab_alloc+0x1ad/0x340
[   54.089129][    T0]  ? bootstrap+0x20/0xb0
[   54.090520][    T0]  kmem_cache_alloc_noprof+0x30b/0x540
[   54.092010][    T0]  ? bootstrap+0x20/0xb0
[   54.093328][    T0]  bootstrap+0x20/0xb0
[   54.094484][    T0]  kmem_cache_init+0xbb/0x330
[   54.095786][    T0]  ? preallocate_vmalloc_pages+0x1a4/0x2b0
[   54.097485][    T0]  mm_core_init+0x12b/0x170
[   54.098935][    T0]  start_kernel+0x173/0x370
[   54.100291][    T0]  x86_64_start_reservations+0x28/0x30
[   54.101912][    T0]  x86_64_start_kernel+0x131/0x140
[   54.103325][    T0]  common_startup_64+0xbd/0xc8
[   54.104692][    T0] RIP: 2e66:0x841f0f
[   54.105837][    T0] Code: Unable to access opcode bytes at 0x841ee5.
[   54.107636][    T0] RSP: 0084:1f0f2e6600000000 EFLAGS: 841f0f2e660000 ORIG_RAX: 2e66000000000084
[   54.110294][    T0] RAX: 2e66000000000084 RBX: 2e66000000000084 RCX: 0000000000841f0f
[   54.112621][    T0] RDX: 000000841f0f2e66 RSI: 00841f0f2e660000 RDI: 1f0f2e6600000000
[   54.114700][    T0] RBP: 1f0f2e6600000000 R08: 1f0f2e6600000000 R09: 00841f0f2e660000
[   54.117100][    T0] R10: 000000841f0f2e66 R11: 0000000000841f0f R12: 00841f0f2e660000
[   54.119233][    T0] R13: 000000841f0f2e66 R14: 0000000000841f0f R15: 2e66000000000084
[   54.121210][    T0]  </TASK>
[   54.122004][    T0] irq event stamp: 0
[   54.122967][    T0] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   54.124748][    T0] hardirqs last disabled at (0): [<0000000000000000>] 0x0
[   54.126760][    T0] softirqs last  enabled at (0): [<0000000000000000>] 0x0
[   54.128589][    T0] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   54.130515][    T0] ---[ end trace 0000000000000000 ]---
[   54.131853][    T0] FIX kmem_cache: Marking all objects used
[   54.137998][    T0] =============================================================================
[   54.164966][    T0] BUG kmem_cache (Tainted: G    B   W       T  ): Freepointer corrupt
[   54.168591][    T0] -----------------------------------------------------------------------------
[   54.168591][    T0] 
[   54.168591][    T0] -----------------------------------------------------------------------------
[   54.168591][    T0] 
[   54.172896][    T0] Slab 0xffffea0004001080 objects=9 used=1 fp=0xffff888100042200 flags=0x4000000000000000(zone=2)
[   54.176176][    T0] Object 0xffff888100042040 @offset=64 fp=0x649e22a70baa83ae
[   54.176176][    T0] 
[   54.176176][    T0] Object 0xffff888100042040 @offset=64 fp=0x649e22a70baa83ae
[   54.176176][    T0] 
[   54.179185][    T0] Redzone  ffff888100042000: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   54.182194][    T0] Redzone  ffff888100042010: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   54.185079][    T0] Redzone  ffff888100042020: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   54.188065][    T0] Redzone  ffff888100042030: bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb bb  ................
[   54.191066][    T0] Object   ffff888100042040: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.194179][    T0] Object   ffff888100042050: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.197272][    T0] Object   ffff888100042060: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.200275][    T0] Object   ffff888100042070: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.203121][    T0] Object   ffff888100042080: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.206273][    T0] Object   ffff888100042090: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.209183][    T0] Object   ffff8881000420a0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.211956][    T0] Object   ffff8881000420b0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.215170][    T0] Object   ffff8881000420c0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.218051][    T0] Object   ffff8881000420d0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.220882][    T0] Object   ffff8881000420e0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.223739][    T0] Object   ffff8881000420f0: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.226475][    T0] Object   ffff888100042100: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[   54.229268][    T0] Object   ffff888100042110: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  kkkkkkkkkkkkkkk.
[   54.232081][    T0] Redzone  ffff888100042120: bb bb bb bb bb bb bb bb                          ........
[   54.240289][    T0] Padding  ffff888100042180: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.244580][    T0] Padding  ffff888100042190: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.248946][    T0] Padding  ffff8881000421a0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.252300][    T0] Padding  ffff8881000421b0: 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
[   54.255423][    T0] ------------[ cut here ]------------
[   54.256910][    T0] WARNING: mm/slub.c:1231 at object_err+0x6c/0x7f, CPU#0: swapper/0
[   54.259466][    T0] Modules linked in:
[   54.260739][    T0] CPU: 0 UID: 0 PID: 0 Comm: swapper Tainted: G    B   W       T   7.1.0-rc1-00001-g895272864130 #1 PREEMPT(undef) 
[   54.264411][    T0] Tainted: [B]=BAD_PAGE, [W]=WARN, [T]=RANDSTRUCT
[   54.266719][    T0] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   54.271041][    T0] RIP: 0010:object_err+0x6c/0x7f
[   54.272617][    T0] Code: c7 c7 1f 95 42 85 e8 b3 1a fe ff eb 0e 48 89 da 4c 89 ee 4c 89 e7 e8 13 fe ff ff be 01 00 00 00 bf 05 00 00 00 e8 c4 f7 2f 00 <0f> 0b 5b 41 5c 41 5d 5d 31 c0 31 d2 31 c9 31 f6 31 ff c3 be 00 10
[   54.278858][    T0] RSP: 0000:ffffffff85607c40 EFLAGS: 00010046
[   54.280701][    T0] RAX: 0000000000000000 RBX: ffff888100042040 RCX: 0000000000000000
[   54.282917][    T0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[   54.285854][    T0] RBP: ffffffff85607c58 R08: 0000000000000000 R09: 0000000000000000
[   54.288711][    T0] R10: 0000000000000000 R11: 0000000000000000 R12: ffffffff86ad8f20
[   54.291194][    T0] R13: ffffea0004001080 R14: 00000000000000bb R15: 0000000000000001
[   54.293497][    T0] FS:  0000000000000000(0000) GS:0000000000000000(0000) knlGS:0000000000000000
[   54.296100][    T0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   54.298178][    T0] CR2: ffff88883ffff000 CR3: 00000000056ba000 CR4: 00000000000000b0
[   54.300578][    T0] Call Trace:
[   54.301701][    T0]  <TASK>
[   54.302556][    T0]  check_object.cold+0x4b/0x50
[   54.304075][    T0]  alloc_debug_processing+0x9b/0x180
[   54.305771][    T0]  alloc_single_from_new_slab+0x82/0x200
[   54.307575][    T0]  ? alloc_slab_obj_exts_early+0x5/0x2c0
[   54.309885][    T0]  ? allocate_slab+0x11b/0x380
[   54.311397][    T0]  ___slab_alloc+0x1ad/0x340
[   54.312978][    T0]  ? bootstrap+0x20/0xb0
[   54.314381][    T0]  kmem_cache_alloc_noprof+0x30b/0x540
[   54.316375][    T0]  ? bootstrap+0x20/0xb0
[   54.317924][    T0]  bootstrap+0x20/0xb0
[   54.319165][    T0]  kmem_cache_init+0xbb/0x330
[   54.320577][    T0]  ? preallocate_vmalloc_pages+0x1a4/0x2b0
[   54.322318][    T0]  mm_core_init+0x12b/0x170
[   54.323813][    T0]  start_kernel+0x173/0x370
[   54.325087][    T0]  x86_64_start_reservations+0x28/0x30
[   54.326828][    T0]  x86_64_start_kernel+0x131/0x140
[   54.328433][    T0]  common_startup_64+0xbd/0xc8
[   54.329884][    T0] RIP: 2e66:0x841f0f
[   54.331003][    T0] Code: Unable to access opcode bytes at 0x841ee5.
[   54.333204][    T0] RSP: 0084:1f0f2e6600000000 EFLAGS: 841f0f2e660000 ORIG_RAX: 2e66000000000084
[   54.341141][    T0] RAX: 2e66000000000084 RBX: 2e66000000000084 RCX: 0000000000841f0f
[   54.344540][    T0] RDX: 000000841f0f2e66 RSI: 00841f0f2e660000 RDI: 1f0f2e6600000000
[   54.348106][    T0] RBP: 1f0f2e6600000000 R08: 1f0f2e6600000000 R09: 00841f0f2e660000
[   54.350959][    T0] R10: 000000841f0f2e66 R11: 0000000000841f0f R12: 00841f0f2e660000
[   54.353348][    T0] R13: 000000841f0f2e66 R14: 0000000000841f0f R15: 2e66000000000084
[   54.355758][    T0]  </TASK>
[   54.356638][    T0] irq event stamp: 0
[   54.357904][    T0] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
[   54.360403][    T0] hardirqs last disabled at (0): [<0000000000000000>] 0x0
[   54.362935][    T0] softirqs last  enabled at (0): [<0000000000000000>] 0x0
[   54.365496][    T0] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   54.367816][    T0] ---[ end trace 0000000000000000 ]---


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260430/202604301428.e2b8d3dd-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


