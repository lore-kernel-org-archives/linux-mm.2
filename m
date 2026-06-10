Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC12FCD98C7
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 08:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC3C76B0005; Wed, 10 Jun 2026 04:19:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C116B0088; Wed, 10 Jun 2026 04:19:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3BA26B008A; Wed, 10 Jun 2026 04:19:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEFB66B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 04:19:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57B75165311
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:19:25 +0000 (UTC)
X-FDA: 84863303490.05.2A4F536
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id D4B1040004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:19:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rf59QwTa;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781079562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y2Xx84hXhgxKA/DL98E0b29EFy25cM6Bw3i/8CnhaTE=;
	b=c9W5vsMQqAz5WoeoV1Km9+i9OrYJ3LvjvKNFSNRI2vyL6D+n84m7uHVvJQqBwoANBVMLdA
	nWNjrpfaNTXao9dPwO2+rM7MQ9om/Xx70GYeHiRB90O1nahZyZknfaL6T+WRwoFBoaT6Vx
	zTwHlQ0oktFVKkOCDLzM8RAZjUYxWmE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Rf59QwTa;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1781079562;
	b=cwaa73lbsUr3S0UmYoUxkJ8baoFgjQNQdXQXMPHaG4K3wZzpOjejhvy+28hsIsjHVFEzj9
	UW9ja58jN0uu8Y85KkbUvCGcWL6yF5pFdcozW0eu2efh1oJjjBOZnfe31SwuH651PC6Eer
	G6ZDs8CyEk9JT1VRQRQVAUqqClaJ/Oo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781079561; x=1812615561;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=tR/qaVREKK8+xaVzjBq/dbYPy95OmRFmRhlXJKCgjVg=;
  b=Rf59QwTauQxEd3pQI8JYA++mFt52/vmYkRE8N1TGCVYxErXOtZxfwZ/F
   pGM8yQ5D/QywLZoIbxAY87OVjT5QKx++Ezxbl39+bOXLijwI4vb5HIHHJ
   s5m4lgOo5UNXN46CyrGviuaIMbFd+TKG58HMndx/2Fytnc5A/4jibvlvx
   7IIdMoTaM85PLz+Q/1wiZgT6qm5XWo/H9CpTz2WTDrclkIqtQwZvWWFsZ
   LdjtJvudb6g/ftjaks7qVW3bVcDal2+vDrXNs4XQNgvVefsKVybehLQSh
   bPQHqShc+o1BZALis57uh4cDLXX4X6lvs8rcuoaByG8YE1Rv3oiU+IMtY
   g==;
X-CSE-ConnectionGUID: SaeesEU0StOLwYNydrFnnA==
X-CSE-MsgGUID: 83DMIGQpQj2SCm5bzIsgXg==
X-IronPort-AV: E=McAfee;i="6800,10657,11812"; a="93254106"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="93254106"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 01:19:19 -0700
X-CSE-ConnectionGUID: aw5W9IMgRtCu16cS4CjqJQ==
X-CSE-MsgGUID: GkYfnCekRFO19Tdw59zOPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="276294430"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 01:19:19 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 01:19:18 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 10 Jun 2026 01:19:18 -0700
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.7) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 10 Jun 2026 01:19:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y57VbT2r0znkdqtQl3wxv6Rir5GOwr1uoIfYkvMZ3BB8XM6x+jpP5FKF+d+O1dwy3iUvLtUpXkdRdYXTHPEZoQHY1hfud7itK1GSfvA5YuCfOdOMWKxbdsc7w72C+sEvUhZ1P5olNkc/0JYQfYKO1O9SkGu0wc0wq4AHB2BIkXztLqPETZHFKnil0WvpqDpGQd4l1mN6div7xS9D2et9nP06z0fd/RRBlmL1BLEgExpAGiIbxhIYld1ADl0W5WL9j70AMHMQp0aaCj3l8eKxv1RikKXga08ROhrFgJc/kV70CZBXYXIEz+Qt4BtonRJpdlRgrv6VSGbcu5B2Ex9IDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DtOqms8Ju+OUP1sCS8VnK1HitUGjnur8h4AToqflYTE=;
 b=RmM8GDryJXixRG04CcVrdzGQPVW/edR8XvY4FX+5ISrGLNWQsVQJHt4x+mr2vbBomooPRwGWda/P+4qJS29eeEBrr5KlMv812iFuBD27RAd8QLQzkk8mBN1QmiVbmPTbPL9Nl4EVkdayPSuJckNDwfSyqsxpGllKFbvnxBLgqo41kDT55xByx3xJXOEx0nJbFoCQL6htZkgv/3rEK3ZHA8x8iaBRpV80rnACZM/pmzjSuJKcXkHXq6Bw8XP/kCPSJDt+7CujQTukBL7WuzfT7sAwmQ+N09lsZ+C1KyZjyoJF4Ilv7q2dtGbLRLNJ2Jr+I8pmspG/hyzUsrAJ+HmG/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB5832.namprd11.prod.outlook.com (2603:10b6:510:141::7)
 by IA4PR11MB9442.namprd11.prod.outlook.com (2603:10b6:208:55f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.92.12; Wed, 10 Jun
 2026 08:19:15 +0000
Received: from PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707]) by PH0PR11MB5832.namprd11.prod.outlook.com
 ([fe80::106e:78dd:4c96:d707%5]) with mapi id 15.21.0092.011; Wed, 10 Jun 2026
 08:19:15 +0000
Date: Wed, 10 Jun 2026 16:19:05 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Hao Li <hao.li@linux.dev>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [mm/slub]  0fc52deec1:
 will-it-scale.per_process_ops 6.9% improvement
Message-ID: <202606101634.f786b0f9-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: s-nail v14.9.25
X-ClientProxiedBy: SI2PR02CA0017.apcprd02.prod.outlook.com
 (2603:1096:4:194::17) To PH0PR11MB5832.namprd11.prod.outlook.com
 (2603:10b6:510:141::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5832:EE_|IA4PR11MB9442:EE_
X-MS-Office365-Filtering-Correlation-Id: 10b720f2-3717-4fe2-1d0a-08dec6c8f539
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|23010399003|1800799024|366016|376014|6133799003|18002099003|3023799007|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info: zMnpKqv0bjY1NCB55PyaFUwM5HCWOwc9BW+jt4sb/Pzy9M6EMYIghQDZxbH7toEfbDA0ytXuf/e44Q/SHDCNTUN7a3Luj6z9qmK3FBynhvehloqXyDFJ0oNEOB6rf6VDmnSREm14pcmxoe+0/W6OaJuvVKRwRHIkY0Rd8CCL5VI+CntXxlTc+atEgkrRlPc4zIVmksCP/r30hA6Rs7I7naJ8p5QELku/x8mvKCMGbHGhOvnMuC4k0VYyLuFMaI0KIUhhvSNeCYbByM9Mcqe4ND91jfrU4S/RlbloBeJ0m+LtceTxFSIHxXXfR3twV7l+k/yeVtJ430WbA0foYV2LIIV5rFle5OQ37wJNBHtTar9FGHmj+OCgTPB313R4Ae9C7FM/wNxNSaWYxUnoDvLfm5eC7VIu743c+YE40V1OjsdxRA3ACnj5uTKDfZxY/9NXsLbuuw3+Cl44nZ6uZLn4ZwsBH+/ZHmoLg5NoSuTrE61wcIruc2xc9CF7ifA13x9GchcYUneUv7VlCIQv/vX+NcZsb1Zi7C/PxOzz5asfj4j69QLy4/wWN5lPXPicjFEaJlSg+q5Nj9ziRB9eC7ORbhdp/fkYhvJSK0eRnUb9nGaFnaFPIW/u9kbZG1ouDrviDfjrvmo3XCvca86tvrfjVshAyYuksDpKNcOFayqz0YNRsQ43r6qYPlFDFTgyFTYdS6luVwgcuyXvmAACZbT7oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5832.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(376014)(6133799003)(18002099003)(3023799007)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?TFahvv6blydYXDZAmcIcplyoF0GxmVN6baiAH0Lmsfx1FTnJisGmNyPAh9?=
 =?iso-8859-1?Q?aqPp/668r5bd0LBFmlNbNy37UL4ATavx4d0dP1zCC24mZiTsE6R0VIIh6y?=
 =?iso-8859-1?Q?cSnsGeMeJR3GQIVlrSDVtCyEgAym8Q19LXPU6K4OgED6VZTzJaswrPnUDG?=
 =?iso-8859-1?Q?TeKikdfKVcGwmc9tulwKV63IYB3fjdQWqciWInfQAvQxLZdPobL2PmiyGI?=
 =?iso-8859-1?Q?t7zDlsysy0H3fhGDs5Hc1k8KedmZdHEdjp/Y71rV5xqXL9SM4eurs3ZG7F?=
 =?iso-8859-1?Q?VP+weZiAJgePadWj86vZ1vBuMgcNKFKbqFhQE3jlMS3B0O6VFBTGY+CkcH?=
 =?iso-8859-1?Q?R0ue+nFRyVjiHcFJMZ/BWA+1CTNNzTjJOIxFfqtoULQm7pT++TYzVoUt2q?=
 =?iso-8859-1?Q?940vGVzn9P/CvNnAWC/NoXXU1nWO6S23fLUCTj2Rw9ggLzZ4/uIe5mlzJe?=
 =?iso-8859-1?Q?CKAqjyCpKsUmiabb1lEQUteZP3PEFaQWd9tg7rQBK4Rk95mwj545/B7iGD?=
 =?iso-8859-1?Q?0VHSmvC9VQZ2Ifsa2tciWaKOt4UraJybb37IWRN+39gthXVZpQNT19tBTS?=
 =?iso-8859-1?Q?33drhHx8RLsnVjvjnU4VyxWtp6fxbk/f2eMi76+mV9hjXqWi95gktemKBK?=
 =?iso-8859-1?Q?zKBnwFRxnkEkMTYRvOILPG+0VWSISGJ0Jc+4MIHnpQeQ+d08crURbhSqn9?=
 =?iso-8859-1?Q?SUGN0avwDME/j2qxQSKR2q7qbuYdbPW1BdPg0XLT2dG7ugXR2PRDz/c+Io?=
 =?iso-8859-1?Q?V9FuYF/OF8DoqDKxUZhBjJdIktsuulyJvEjqjaa27EJSplzIQPh47TaKTV?=
 =?iso-8859-1?Q?umzuVTwhyy3NodBe8tZUQS4eFzlvs/2jhPpkWM/qk048Sr6j6+q3nublXF?=
 =?iso-8859-1?Q?Y83yel4bZsx2D09PgwaISqxaeMFrj7/CNmk1NvWwf8HwxrL35l1dXD1nXE?=
 =?iso-8859-1?Q?MW0ZSvrJM72I67Wa+lGyz5fOh+A5U3HuxWqWIPIFNWwnEAEzJpm7PNKQ3k?=
 =?iso-8859-1?Q?+TxHG3pRKcyBwmpd+51SgodAgfWYozE+ztKh4jlT25T26TRTN03WNfymSO?=
 =?iso-8859-1?Q?JPLTDWlH/4jVZYEMM7uDjv1ZAGWs4BTq0hiGpIlYVWPgJL8wVY92oO3T0x?=
 =?iso-8859-1?Q?NWJ96iBOiEEh744bM6U/KW6gquCzC3uVmxpl8BwZqHEkZ8EYTmoxLR8T0Z?=
 =?iso-8859-1?Q?z9kyXln2HVEZho3qG5dhT+hHWtrTVs7FgoGlJqXTwF96Sr2iUJGm79HbbR?=
 =?iso-8859-1?Q?VehFmCOEnNTcagKOVFWJpdq4MAKzpGmj6pyYX+HC7VbDWrvy9g7dUh92+L?=
 =?iso-8859-1?Q?Sy5htYdyU6xaINdfm5LzU74a/KbeoNeSHUGwfcxv96yTsjy52ymoWHTtUR?=
 =?iso-8859-1?Q?dI4j58+BYTThgXKW4C/UPw6CfRJDuZdPDJ9XOMzXqfkjBAMSF4ZDUEzCTJ?=
 =?iso-8859-1?Q?oVSR3WDWQj5sr3WFepozr/UEXLyaZ/SfqhCHNhHlixrzBN7hNGQSbFz4G/?=
 =?iso-8859-1?Q?Ho6/NdgD/pmKYxwVcAKkaTybNn1yOCoa7cAxXMThi32qDcmC80j8rsrH+E?=
 =?iso-8859-1?Q?roV0RkbQVKJ0WAopToOhIAoAhLCWgkUCO43DlAyCgES2z54ZRB1ysIdnH5?=
 =?iso-8859-1?Q?6Bke/SAIdmq+l+tQvKoQ7G+nMyTUJpJYtUZ5wrlnh/Gmhebqle1tOD1GUb?=
 =?iso-8859-1?Q?6U4nk0qEQvSZXSnICZJ/RGpHzJGmfzzI8QgKHXc0mHGCLXeDB8SsAqrXcF?=
 =?iso-8859-1?Q?nVvyzJ8WGEMfMVnE//UzBIRGsfcfTGKkw1bDikZ+u9y2UKbP69eT+OQpGG?=
 =?iso-8859-1?Q?Rf+B365bhw=3D=3D?=
X-Exchange-RoutingPolicyChecked: NtxR/woe70SP3YnCiodopk8cmuiIc3gr09FYbuR/ykqF+eGjjOPG6VNHXi9LVNnAN1BpPoZ61iki/iP6jJs62PHKeHTI6j6EU0pcbp1/DghnfGfZkMFATSme8sLd6GHZYexhZJ8gADr3Aa1pT/RtrckgBE1KG7+SzskoXK9jCOFoDo2XKEvHdOecx686OjYutZ7CIYewftNoSZcBmQk/y4elIuPNAfDUjmja7lqdFGonmHssz+eQ4LqNANlAwIBu3bwQ/sPSuhAlZfLw3vCUMGlaCuUcDX1x6OolQMK0PZSZa4LDHTwKmvAPmH/6naZkYzuKQdUZmuLXFQ9bZApwWg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 10b720f2-3717-4fe2-1d0a-08dec6c8f539
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5832.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2026 08:19:14.7333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0+9eHf7jSm5q5gA9CViYBlJyjHbHR7rz3RnRg04gDxP1LoELxS+9+S+XhhkjoCChYUDGZZPIeTpO84ES8PjIGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9442
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: D4B1040004
X-Stat-Signature: kgu1djwgea8ptzmrj1ge67fbz7xag19p
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781079560-617996
X-HE-Meta: U2FsdGVkX1+HeEe+2ugLZ0/pDFCseevhnzxmSJj1bpi6ShtX2qSX3Rz/3/3auTbM/zYZVmdquCArM7WG5JN5Tmqxrh6kTkL8r1BfyqyGW2aeBTDhQMb7t50Jnnu6Uw334PT3JPtI0KI2UrvtzLycJIdqnMox6T6+XW3Abex9cKjpXkeIRiG7kSHKbDxC6v1LjEKo+BrFXdzAcqPuPM/odOyoNNdWqOX4kesOG6eCSzE3MeZhkqaTgqCN8S9DpKUM2OmqBSvs2JkI9lqkGD9hccgieia2YtEuVSfhlwPJYiO6lcwkL30mvqhOi8BnM0VbIRNH6iG8bCf96/T/S+6p/fBY+NFi2poGNbxWQ30MRHTqCnx77RqzFAlOzzvDmq9B1Ej+JtGXu6Fu1hgA60CWCT2jGKm1FgMAqIKlLUPF9VkOCM37690YHErACvUvnkHmcFPLB6KojkWpeLsmzx1z7v0A6GqPjX37VL1krXFXT9kmvvV7Q6FLB/m2cKdqt0ls0VHT29j3OffTdQEwe7As+CPMi9sOIfva3fgUL9K2rDGaG87k8XE3dzDYiXRF7TkQjjssoyKMCX7ksbj24yHQe4TiYhblpfY8o+uUhdZFjRwtb5ez2wMkd0SYd2T7AR4EGkZew1BvaNV/2TzVK05Olad05ORXghOxjjZoGFlaB3vlKoRixdpIIv5dAwQX+HjSl90ElvGbDVxNKN/HHuRyEM1hJzJuwA3vvHJ+wQ/+pBkjm1Z+oBaPU5fDDKxvqB94pVm+aof97C5k5tNR2ZHgRtrVaZY7vGQjgWbkOCvo9fSHoDACjOV5pdLkopHA1+YdNUhy1/gzMFDtH1n6aAsUl009QVEEE8+GsKQwOllsmRnfIOoNPpe6HU2mERIkXX0ObL3YWdGEzliZLl9Tu22ZLILA7rVaEO/BDCqlu5ucwy0XKTj9wNlYTDiuxYfkrlD5eKPwONh5J3Dj3jFvY6j
 vdsqbNSs
 kzsq8+CipbNrNwjF4FdZshSIM5mhr8u/lHvWjGdtIoAZLcDoBC+eB4hCkPwTOwtEWXC88baPgkXl6wLSDdm9uxopsYC8wsxZ/d7/wqWuvU3byS3D2cHS6IE7ldXNEcc6b9IMSZL082UC5SGjyGZsYn2BIdUZ0+eH9cuEEG8B8oTIRFtSw1XJ4i+/Wp+PVnEe+ZoIf1feNqnryoHESDxdRXA/hYfCFerIrvJV3UZjhnqHT3+zORX6hdQ5XtaGSyPinu6iTptulrwSP633AztnzdAb7MlLEpTPDf7GE2aearFIRy4O7luoqG9YPFu4FFhXCv/hY2CblFYwrb9KdrSfP153xpMZg+hULKgPFIbEtAW5vbidMriTBPDXTpFrPOiPvFsAaavRo7KI2zDn3vQl2+rktqD3XC60DLsy/9pycyZb1I7nEPCulQujDFf+E1TZycrdEaukArw+pJB44FUPWEfh5zweO8o92TX/fu86neiKdGj2TYYPrTKAUVnMnEX3kkqChgpVjg6JaaZNll9E9SkNy0bNeOx4Zt/XM0rWN8azd24Wt7t3ZU+w92d187AgG1c5dipUtbRk7sN4walBbaUFMDzV+S5Um23pUDQclc9CImfadfSTrzJvWnNw6E2Y9icktMz68alnlCSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 6.9% improvement of will-it-scale.per_process_ops on:


commit: 0fc52deec1068ea3cc8eaa6e045c96fbf73f20e2 ("mm/slub: detach and reattach partial slabs in batch")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master


testcase: will-it-scale
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_task: 100%
	mode: process
	test: mmap1
	cpufreq_governor: performance



Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20260610/202606101634.f786b0f9-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/mode/nr_task/rootfs/tbox_group/test/testcase:
  gcc-14/performance/x86_64-rhel-9.4/process/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp2/mmap1/will-it-scale

commit: 
  7e23073874 ("mm/slub: introduce helpers for node partial slab state")
  0fc52deec1 ("mm/slub: detach and reattach partial slabs in batch")

7e230738746ce9a7 0fc52deec1068ea3cc8eaa6e045 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
  35949149            +6.9%   38424030        will-it-scale.192.processes
    187234            +6.9%     200124        will-it-scale.per_process_ops
  35949149            +6.9%   38424030        will-it-scale.workload
   1130464 ± 14%     -15.9%     951025 ±  6%  numa-meminfo.node1.Mapped
    765203            +6.8%     817048        meminfo.SUnreclaim
    916508            +5.7%     968444        meminfo.Slab
     21415 ±  2%     +35.9%      29105        vmstat.system.cs
    254768            +1.3%     258105        vmstat.system.in
      0.13 ±  3%      +0.0        0.14 ±  2%  mpstat.cpu.all.irq%
     18.10            +2.1       20.23        mpstat.cpu.all.soft%
      1.73            +0.2        1.91        mpstat.cpu.all.usr%
   4375386           -50.0%    2186988 ±  6%  numa-numastat.node0.local_node
   4460280           -49.9%    2236714 ±  5%  numa-numastat.node0.numa_hit
   5597529 ±  2%     -42.1%    3243169 ±  3%  numa-numastat.node1.local_node
   5712900 ±  2%     -40.6%    3393053 ±  3%  numa-numastat.node1.numa_hit
     21530           +35.8%      29239        perf-stat.i.context-switches
    263.83            +2.2%     269.76        perf-stat.i.cpu-migrations
     21371 ±  2%     +36.1%      29093        perf-stat.ps.context-switches
    261.10            +2.2%     266.90        perf-stat.ps.cpu-migrations
   4460290           -49.9%    2236236 ±  5%  numa-vmstat.node0.numa_hit
   4375396           -50.0%    2186510 ±  6%  numa-vmstat.node0.numa_local
    282371 ± 14%     -16.0%     237208 ±  6%  numa-vmstat.node1.nr_mapped
   5712955 ±  2%     -40.6%    3392995 ±  3%  numa-vmstat.node1.numa_hit
   5597585 ±  2%     -42.1%    3243112 ±  3%  numa-vmstat.node1.numa_local
    191228            +6.9%     204459        proc-vmstat.nr_slab_unreclaimable
  10177434           -44.7%    5632836 ±  3%  proc-vmstat.numa_hit
   9977167           -45.5%    5433226 ±  3%  proc-vmstat.numa_local
  33527355           -54.2%   15349765 ±  5%  proc-vmstat.pgalloc_normal
  32033712           -56.8%   13845940 ±  6%  proc-vmstat.pgfree
      0.21           +36.6%       0.29        perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.21           +36.6%       0.29        perf-sched.total_sch_delay.average.ms
     26.08 ±  3%     -25.9%      19.32 ±  2%  perf-sched.total_wait_and_delay.average.ms
    110198 ±  2%     +34.6%     148367        perf-sched.total_wait_and_delay.count.ms
     25.87 ±  3%     -26.4%      19.03 ±  2%  perf-sched.total_wait_time.average.ms
     26.08 ±  3%     -25.9%      19.32 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    110198 ±  2%     +34.6%     148367        perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
     25.87 ±  3%     -26.4%      19.03 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.21 ±  6%     +18.6%       0.25 ±  5%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.21 ±  5%     +14.6%       0.24 ±  2%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
   3324769 ± 12%     +28.7%    4277348 ± 10%  sched_debug.cfs_rq:/.left_deadline.stddev
   3324734 ± 12%     +28.7%    4277309 ± 10%  sched_debug.cfs_rq:/.left_vruntime.stddev
     27152 ± 13%     +57.1%      42666 ± 16%  sched_debug.cfs_rq:/.load.avg
    127543 ±  9%     +38.2%     176277 ±  9%  sched_debug.cfs_rq:/.load.stddev
      6.75 ± 11%     +91.8%      12.94 ± 14%  sched_debug.cfs_rq:/.load_avg.min
      0.15 ±  7%     +29.3%       0.20 ±  7%  sched_debug.cfs_rq:/.nr_queued.stddev
   3324735 ± 12%     +28.7%    4277309 ± 10%  sched_debug.cfs_rq:/.right_vruntime.stddev
      3746 ± 36%    +147.1%       9256 ± 41%  sched_debug.cfs_rq:/.sum_weight.avg
     39887 ± 41%     +90.1%      75816 ± 21%  sched_debug.cfs_rq:/.sum_weight.stddev
      1195 ±  9%     +24.2%       1483 ±  5%  sched_debug.cpu.curr->pid.stddev
      0.00 ±  3%     +13.8%       0.00 ±  5%  sched_debug.cpu.next_balance.stddev
      0.21 ±  7%     +18.7%       0.25 ±  5%  sched_debug.cpu.nr_running.stddev
     18361 ±  2%     +32.9%      24405        sched_debug.cpu.nr_switches.avg
     15708 ±  2%     +38.1%      21687 ±  2%  sched_debug.cpu.nr_switches.min
     34.64           -21.3       13.38        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     34.48           -21.2       13.29        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.24            -6.8        5.47        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects
     12.24            -6.8        5.48        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main
     12.24            -6.8        5.48        perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     12.20            -6.7        5.46        perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.__refill_objects_node
     26.52 ±  3%      -5.4       21.08 ±  7%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap
     26.02 ±  3%      -5.2       20.87 ±  7%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
     31.47 ±  3%      -4.9       26.54 ±  7%  perf-profile.calltrace.cycles-pp.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
     31.67 ±  3%      -4.9       26.75 ±  7%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
     37.72 ±  2%      -3.5       34.26 ±  6%  perf-profile.calltrace.cycles-pp.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
     23.32 ±  3%      -2.6       20.73 ±  8%  perf-profile.calltrace.cycles-pp.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
     22.88 ±  3%      -2.4       20.52 ±  8%  perf-profile.calltrace.cycles-pp.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.02            -1.5        0.54 ±  4%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu
      2.51            -1.1        1.40 ± 14%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core
      2.54            -1.0        1.50 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      0.77            -0.1        0.67        perf-profile.calltrace.cycles-pp.perf_iterate_sb.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region
      1.87            -0.1        1.81        perf-profile.calltrace.cycles-pp.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.22            -0.0        1.18        perf-profile.calltrace.cycles-pp.perf_event_mmap_event.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap
      1.62            +0.0        1.65        perf-profile.calltrace.cycles-pp.perf_event_mmap.__mmap_complete.__mmap_region.do_mmap.vm_mmap_pgoff
      0.62            +0.0        0.66        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__munmap
      0.62            +0.0        0.67        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64.__mmap
      0.53            +0.1        0.59        perf-profile.calltrace.cycles-pp.mas_store_gfp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.65            +0.1        0.72        perf-profile.calltrace.cycles-pp.mas_empty_area_rev.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags
      0.59            +0.1        0.68        perf-profile.calltrace.cycles-pp.__memcg_slab_post_alloc_hook.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region
      1.41            +0.1        1.51        perf-profile.calltrace.cycles-pp.unmapped_area_topdown.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area
      0.74            +0.1        0.84        perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap
      1.43            +0.1        1.54        perf-profile.calltrace.cycles-pp.vm_unmapped_area.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap
      1.75            +0.1        1.87        perf-profile.calltrace.cycles-pp.arch_get_unmapped_area_topdown.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff
      0.54            +0.1        0.66        perf-profile.calltrace.cycles-pp.kmem_cache_free.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      1.11            +0.1        1.25        perf-profile.calltrace.cycles-pp.vm_area_alloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      1.92            +0.2        2.07        perf-profile.calltrace.cycles-pp.thp_get_unmapped_area_vmflags.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64
      1.25 ±  4%      +0.2        1.42 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      1.98            +0.2        2.15        perf-profile.calltrace.cycles-pp.__get_unmapped_area.do_mmap.vm_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      2.65            +0.2        2.84 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.26            +0.2        2.44        perf-profile.calltrace.cycles-pp.free_p4d_range.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas
      2.03            +0.2        2.22        perf-profile.calltrace.cycles-pp.free_pud_range.free_p4d_range.free_pgd_range.free_pgtables.unmap_region
      2.39            +0.2        2.58        perf-profile.calltrace.cycles-pp.free_pgd_range.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.38            +0.2        2.62        perf-profile.calltrace.cycles-pp.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      2.62            +0.2        2.86        perf-profile.calltrace.cycles-pp.free_pgtables.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      1.45 ±  3%      +0.2        1.69 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      2.85            +0.2        3.10        perf-profile.calltrace.cycles-pp.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap
      2.63            +0.2        2.88        perf-profile.calltrace.cycles-pp.zap_pmd_range.__zap_vma_range.unmap_vmas.unmap_region.vms_complete_munmap_vmas
      3.01            +0.3        3.26        perf-profile.calltrace.cycles-pp.unmap_vmas.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap
      2.29 ±  3%      +0.4        2.68 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc
      1.58            +0.4        1.98        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      2.47 ±  2%      +0.4        2.88 ±  6%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma
      1.53            +0.4        1.94        perf-profile.calltrace.cycles-pp.__pi_memcpy.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.55 ±  2%      +0.4        0.98 ±  2%  perf-profile.calltrace.cycles-pp.barn_put_full_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      2.34 ±  3%      +0.5        2.81 ±  8%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.71 ±  2%      +0.5        3.18 ±  5%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
      0.00            +0.5        0.52 ±  2%  perf-profile.calltrace.cycles-pp.mas_update_gap.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region
      6.19            +0.5        6.72        perf-profile.calltrace.cycles-pp.unmap_region.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.00            +0.5        0.53        perf-profile.calltrace.cycles-pp.__vma_start_write.vms_gather_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      0.17 ±141%      +0.6        0.73 ±  9%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_store_gfp
      3.62            +0.6        4.19 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      3.59            +0.6        4.16 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      7.68            +0.6        8.31        perf-profile.calltrace.cycles-pp.vms_complete_munmap_vmas.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap
      4.96            +0.6        5.61 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      2.19            +0.7        2.91 ±  7%  perf-profile.calltrace.cycles-pp.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp
      0.00            +0.7        0.73 ±  7%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate
      2.37            +0.7        3.11 ±  7%  perf-profile.calltrace.cycles-pp.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap
      2.86 ±  3%      +0.8        3.64 ±  8%  perf-profile.calltrace.cycles-pp.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof.mas_preallocate.__mmap_new_vma
      2.59            +0.8        3.38 ±  6%  perf-profile.calltrace.cycles-pp.kvfree_call_rcu.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap
     10.48            +1.0       11.49 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf
     10.61            +1.0       11.64 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch
      5.37            +1.0        6.40 ±  2%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap
     10.96            +1.0       12.00 ±  2%  perf-profile.calltrace.cycles-pp.__slab_free.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core
     11.04            +1.0       12.08 ±  2%  perf-profile.calltrace.cycles-pp.__kmem_cache_free_bulk.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs
      5.92            +1.1        7.02 ±  2%  perf-profile.calltrace.cycles-pp.mas_store_prealloc.__mmap_new_vma.__mmap_region.do_mmap.vm_mmap_pgoff
      0.00            +1.2        1.23 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf
      0.00            +1.2        1.24 ±  3%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu.mas_wr_node_store
      0.00            +1.2        1.24 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf.kvfree_call_rcu
      0.00            +1.2        1.24 ±  3%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_get_empty_sheaf.__kfree_rcu_sheaf
      0.17 ±141%      +1.3        1.46 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main
      0.17 ±141%      +1.3        1.46 ±  3%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf.__pcs_replace_empty_main.kmem_cache_alloc_noprof
      1.53 ±  3%      +1.3        2.82        perf-profile.calltrace.cycles-pp.rcu_free_sheaf.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd
      0.08 ±223%      +1.4        1.45 ±  3%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.barn_replace_empty_sheaf
      5.27            +1.4        6.66 ±  3%  perf-profile.calltrace.cycles-pp.mas_wr_node_store.mas_store_gfp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.run_ksoftirqd.smpboot_thread_fn.kthread
      2.16 ±  3%      +1.8        3.95        perf-profile.calltrace.cycles-pp.run_ksoftirqd.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
      2.18 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
      2.18 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
      2.18 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.ret_from_fork_asm
      2.17 ±  3%      +1.8        3.96        perf-profile.calltrace.cycles-pp.smpboot_thread_fn.kthread.ret_from_fork.ret_from_fork_asm
     12.27 ±  2%      +2.2       14.47        perf-profile.calltrace.cycles-pp.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt
     12.26 ±  2%      +2.2       14.46        perf-profile.calltrace.cycles-pp.rcu_do_batch.rcu_core.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt
     12.28 ±  2%      +2.2       14.48        perf-profile.calltrace.cycles-pp.handle_softirqs.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore
      0.00            +6.3        6.34 ±  2%  perf-profile.calltrace.cycles-pp.__irq_exit_rcu.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk
      0.00            +6.4        6.36 ±  2%  perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node
      0.00            +6.4        6.36 ±  2%  perf-profile.calltrace.cycles-pp._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00            +6.4        6.36 ±  2%  perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt._raw_spin_unlock_irqrestore.get_partial_node_bulk.__refill_objects_node.refill_objects
      0.00           +14.1       14.13        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.get_partial_node_bulk.__refill_objects_node.refill_objects
      0.00           +14.2       14.21        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main
      0.00           +20.9       20.94        perf-profile.calltrace.cycles-pp.get_partial_node_bulk.__refill_objects_node.refill_objects.__pcs_replace_empty_main.kmem_cache_alloc_noprof
     49.86            -8.0       41.83        perf-profile.children.cycles-pp.refill_objects
     48.92            -7.5       41.41        perf-profile.children.cycles-pp.__refill_objects_node
     59.17            -6.5       52.68        perf-profile.children.cycles-pp.__pcs_replace_empty_main
     60.32            -6.3       53.98        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
     38.28 ±  2%      -3.4       34.87 ±  5%  perf-profile.children.cycles-pp.mas_store_gfp
     64.39            -2.9       61.51        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     64.91            -2.8       62.08        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     94.44            -2.0       92.40        perf-profile.children.cycles-pp.do_syscall_64
     94.59            -2.0       92.55        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.92 ±  2%      -0.5        0.40 ±  7%  perf-profile.children.cycles-pp.alloc_from_new_slab
      0.81            -0.1        0.70        perf-profile.children.cycles-pp.perf_iterate_sb
      0.38            -0.1        0.30        perf-profile.children.cycles-pp.up_read
      1.88            -0.1        1.81        perf-profile.children.cycles-pp.__mmap_complete
      0.15 ±  3%      -0.0        0.13        perf-profile.children.cycles-pp.percpu_counter_add_batch
      0.20            +0.0        0.21        perf-profile.children.cycles-pp.tlb_finish_mmu
      0.07            +0.0        0.08        perf-profile.children.cycles-pp.prandom_u32_state
      0.17            +0.0        0.18        perf-profile.children.cycles-pp.entry_SYSCALL_64_safe_stack
      0.09            +0.0        0.10        perf-profile.children.cycles-pp.mas_wr_store_entry
      0.11 ±  3%      +0.0        0.12        perf-profile.children.cycles-pp.testcase
      0.08 ±  4%      +0.0        0.09        perf-profile.children.cycles-pp.userfaultfd_unmap_complete
      0.06 ±  6%      +0.0        0.07        perf-profile.children.cycles-pp.__call_rcu_common
      0.14 ±  2%      +0.0        0.15 ±  2%  perf-profile.children.cycles-pp.mas_prev
      0.14            +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.syscall_return_via_sysret
      0.14            +0.0        0.15 ±  3%  perf-profile.children.cycles-pp.up_write
      0.10            +0.0        0.12        perf-profile.children.cycles-pp.x64_sys_call
      0.07            +0.0        0.09        perf-profile.children.cycles-pp.unlink_file_vma_batch_final
      0.06            +0.0        0.08        perf-profile.children.cycles-pp.vm_get_page_prot
      0.16            +0.0        0.18        perf-profile.children.cycles-pp.may_expand_vm
      0.13 ±  2%      +0.0        0.15        perf-profile.children.cycles-pp.mas_prev_range
      0.24            +0.0        0.26        perf-profile.children.cycles-pp.security_vm_enough_memory_mm
      1.64            +0.0        1.66        perf-profile.children.cycles-pp.perf_event_mmap
      0.24            +0.0        0.27        perf-profile.children.cycles-pp.downgrade_write
      0.36            +0.0        0.39        perf-profile.children.cycles-pp.__vma_start_exclude_readers
      0.29            +0.0        0.32        perf-profile.children.cycles-pp.down_write_killable
      0.32            +0.0        0.35        perf-profile.children.cycles-pp.vma_set_page_prot
      0.46            +0.0        0.50        perf-profile.children.cycles-pp.vma_merge_new_range
      0.53            +0.0        0.58        perf-profile.children.cycles-pp.mas_wr_store_type
      0.46            +0.0        0.50        perf-profile.children.cycles-pp.mas_rev_awalk
      0.70            +0.0        0.74        perf-profile.children.cycles-pp.mas_prev_slot
      0.30            +0.0        0.34        perf-profile.children.cycles-pp.__rcu_free_sheaf_prepare
      0.07            +0.0        0.12 ±  4%  perf-profile.children.cycles-pp.kfree
      0.53            +0.0        0.58        perf-profile.children.cycles-pp.mas_walk
      0.00            +0.1        0.05 ±  7%  perf-profile.children.cycles-pp.mm_get_unmapped_area_vmflags
      0.54            +0.1        0.59        perf-profile.children.cycles-pp.__vma_start_write
      0.45            +0.1        0.52 ±  3%  perf-profile.children.cycles-pp.barn_put_empty_sheaf
      0.00            +0.1        0.07 ±  5%  perf-profile.children.cycles-pp.mmap_region
      0.65            +0.1        0.72        perf-profile.children.cycles-pp.mas_empty_area_rev
      1.00            +0.1        1.07        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.00            +0.1        0.09 ±  5%  perf-profile.children.cycles-pp.strlen
      0.01 ±223%      +0.1        0.10        perf-profile.children.cycles-pp.vm_area_free
      0.59            +0.1        0.68        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      1.28            +0.1        1.37        perf-profile.children.cycles-pp.entry_SYSCALL_64
      1.42            +0.1        1.52        perf-profile.children.cycles-pp.unmapped_area_topdown
      1.44            +0.1        1.54        perf-profile.children.cycles-pp.vm_unmapped_area
      0.54            +0.1        0.66        perf-profile.children.cycles-pp.kmem_cache_free
      1.76            +0.1        1.88        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      1.11            +0.1        1.25        perf-profile.children.cycles-pp.vm_area_alloc
      1.92            +0.2        2.07        perf-profile.children.cycles-pp.thp_get_unmapped_area_vmflags
      1.99            +0.2        2.16        perf-profile.children.cycles-pp.__get_unmapped_area
      2.27            +0.2        2.45        perf-profile.children.cycles-pp.free_p4d_range
      2.04            +0.2        2.22        perf-profile.children.cycles-pp.free_pud_range
      2.40            +0.2        2.59        perf-profile.children.cycles-pp.free_pgd_range
      0.82 ±  2%      +0.2        1.04 ±  2%  perf-profile.children.cycles-pp.mas_update_gap
      2.40            +0.2        2.64        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      2.87            +0.2        3.11        perf-profile.children.cycles-pp.__zap_vma_range
      2.70            +0.2        2.94        perf-profile.children.cycles-pp.free_pgtables
      2.64            +0.2        2.89        perf-profile.children.cycles-pp.zap_pmd_range
      3.02            +0.3        3.27        perf-profile.children.cycles-pp.unmap_vmas
     14.89            +0.5       15.36        perf-profile.children.cycles-pp._raw_spin_unlock_irqrestore
      6.20            +0.5        6.72        perf-profile.children.cycles-pp.unmap_region
      7.86            +0.5        8.41        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      4.10            +0.7        4.83 ±  2%  perf-profile.children.cycles-pp.barn_put_full_sheaf
      3.13            +0.8        3.96        perf-profile.children.cycles-pp.__pi_memcpy
      5.92            +1.1        7.02 ±  2%  perf-profile.children.cycles-pp.mas_store_prealloc
      4.84            +1.2        6.00 ±  2%  perf-profile.children.cycles-pp.__kfree_rcu_sheaf
      6.11            +1.2        7.34 ±  2%  perf-profile.children.cycles-pp.barn_replace_empty_sheaf
      5.31            +1.3        6.58 ±  2%  perf-profile.children.cycles-pp.kvfree_call_rcu
     17.71            +1.3       19.06        perf-profile.children.cycles-pp.__irq_exit_rcu
     17.83            +1.4       19.18        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
     17.85            +1.4       19.21        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      7.59            +1.4        9.01 ±  2%  perf-profile.children.cycles-pp.barn_get_empty_sheaf
      2.16 ±  3%      +1.8        3.95        perf-profile.children.cycles-pp.run_ksoftirqd
      2.18 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.kthread
      2.18 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.ret_from_fork
      2.18 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.ret_from_fork_asm
      2.17 ±  3%      +1.8        3.96        perf-profile.children.cycles-pp.smpboot_thread_fn
     14.64            +2.2       16.86        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
     14.66            +2.3       16.93        perf-profile.children.cycles-pp.__slab_free
     15.25            +2.3       17.57        perf-profile.children.cycles-pp.rcu_free_sheaf
     10.75            +2.5       13.20        perf-profile.children.cycles-pp.mas_wr_node_store
     19.86            +3.1       22.99        perf-profile.children.cycles-pp.rcu_core
     19.87            +3.1       23.00        perf-profile.children.cycles-pp.handle_softirqs
     19.84            +3.1       22.98        perf-profile.children.cycles-pp.rcu_do_batch
      0.00           +20.9       20.94        perf-profile.children.cycles-pp.get_partial_node_bulk
     64.39            -2.9       61.51        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      1.90            -0.4        1.48 ±  2%  perf-profile.self.cycles-pp.__refill_objects_node
      0.27            -0.1        0.17        perf-profile.self.cycles-pp.vms_complete_munmap_vmas
      0.58            -0.1        0.49        perf-profile.self.cycles-pp.perf_iterate_sb
      0.34            -0.1        0.26        perf-profile.self.cycles-pp.up_read
      0.25 ±  3%      -0.0        0.23 ±  4%  perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.12            -0.0        0.11        perf-profile.self.cycles-pp.vm_mmap_pgoff
      0.14            +0.0        0.15        perf-profile.self.cycles-pp.syscall_return_via_sysret
      0.05            +0.0        0.06        perf-profile.self.cycles-pp.do_vmi_munmap
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.mas_prev
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.testcase
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.unmap_region
      0.07            +0.0        0.08        perf-profile.self.cycles-pp.unmap_vmas
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.entry_SYSCALL_64_after_hwframe
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.entry_SYSCALL_64_safe_stack
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.prandom_u32_state
      0.13            +0.0        0.14        perf-profile.self.cycles-pp.up_write
      0.06            +0.0        0.07        perf-profile.self.cycles-pp.userfaultfd_unmap_complete
      0.14 ±  3%      +0.0        0.16        perf-profile.self.cycles-pp.may_expand_vm
      0.11            +0.0        0.13 ±  3%  perf-profile.self.cycles-pp.thp_get_unmapped_area_vmflags
      0.17            +0.0        0.19        perf-profile.self.cycles-pp.__vma_start_write
      0.17            +0.0        0.19        perf-profile.self.cycles-pp.barn_get_empty_sheaf
      0.18            +0.0        0.20        perf-profile.self.cycles-pp.mas_empty_area_rev
      0.09            +0.0        0.11 ±  3%  perf-profile.self.cycles-pp.x64_sys_call
      0.40            +0.0        0.42        perf-profile.self.cycles-pp.__vm_munmap
      0.27            +0.0        0.29        perf-profile.self.cycles-pp.__kfree_rcu_sheaf
      0.20            +0.0        0.22        perf-profile.self.cycles-pp.barn_replace_empty_sheaf
      0.40            +0.0        0.42        perf-profile.self.cycles-pp.unmapped_area_topdown
      0.20 ±  2%      +0.0        0.22        perf-profile.self.cycles-pp.free_pgtables
      0.33            +0.0        0.35        perf-profile.self.cycles-pp.vma_merge_new_range
      0.27            +0.0        0.29        perf-profile.self.cycles-pp.down_write_killable
      0.22            +0.0        0.24        perf-profile.self.cycles-pp.downgrade_write
      0.30            +0.0        0.33        perf-profile.self.cycles-pp.__vma_start_exclude_readers
      0.47            +0.0        0.50        perf-profile.self.cycles-pp.__mmap
      0.33            +0.0        0.36        perf-profile.self.cycles-pp.vm_area_alloc
      0.11 ±  3%      +0.0        0.14        perf-profile.self.cycles-pp.do_mmap
      0.64            +0.0        0.66        perf-profile.self.cycles-pp.mas_prev_slot
      0.37            +0.0        0.40        perf-profile.self.cycles-pp.perf_event_mmap
      0.05            +0.0        0.08        perf-profile.self.cycles-pp.vma_set_page_prot
      0.38            +0.0        0.41        perf-profile.self.cycles-pp.vms_gather_munmap_vmas
      0.30            +0.0        0.33        perf-profile.self.cycles-pp.mas_wr_store_type
      0.43            +0.0        0.46        perf-profile.self.cycles-pp.__munmap
      0.37            +0.0        0.40        perf-profile.self.cycles-pp.mas_preallocate
      0.42            +0.0        0.45        perf-profile.self.cycles-pp.mas_rev_awalk
      0.48            +0.0        0.51        perf-profile.self.cycles-pp.mas_walk
      0.06 ±  9%      +0.0        0.09        perf-profile.self.cycles-pp.kfree
      0.40            +0.0        0.44        perf-profile.self.cycles-pp.mas_store_prealloc
      0.22            +0.0        0.26        perf-profile.self.cycles-pp.perf_event_mmap_event
      0.52            +0.0        0.56        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.30            +0.0        0.34        perf-profile.self.cycles-pp.__rcu_free_sheaf_prepare
      0.57            +0.0        0.61        perf-profile.self.cycles-pp.do_vmi_align_munmap
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.__get_unmapped_area
      0.00            +0.1        0.05        perf-profile.self.cycles-pp.mmap_region
      0.63            +0.1        0.68        perf-profile.self.cycles-pp.entry_SYSCALL_64
      0.52            +0.1        0.57        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.87            +0.1        0.92        perf-profile.self.cycles-pp.mas_store_gfp
      0.48            +0.1        0.54        perf-profile.self.cycles-pp.__slab_free
      0.50            +0.1        0.57        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.99            +0.1        1.07        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.42            +0.1        0.51        perf-profile.self.cycles-pp.kvfree_call_rcu
      0.19            +0.1        0.30        perf-profile.self.cycles-pp.kmem_cache_free
      1.48            +0.1        1.61        perf-profile.self.cycles-pp.mas_wr_node_store
      1.86            +0.1        2.00        perf-profile.self.cycles-pp.free_pud_range
      1.76            +0.1        1.90        perf-profile.self.cycles-pp.__mmap_region
      2.42            +0.2        2.60        perf-profile.self.cycles-pp.zap_pmd_range
      0.75            +0.2        0.94 ±  2%  perf-profile.self.cycles-pp.mas_update_gap
      0.00            +0.3        0.34        perf-profile.self.cycles-pp.get_partial_node_bulk
      2.77            +0.7        3.44        perf-profile.self.cycles-pp.__pi_memcpy




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


