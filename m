Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A220CC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 04:14:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39F86B0095; Fri, 28 Aug 2026 00:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9BF6B0096; Fri, 28 Aug 2026 00:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 963826B0098; Fri, 28 Aug 2026 00:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC526B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 00:14:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54EE440374
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:14:04 +0000 (UTC)
X-FDA: 85149360408.07.8C67120
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf15.hostedemail.com (Postfix) with ESMTP id 50D89A0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:14:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DxE1yYJg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787890441;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+dHdI54XzcPT2OwvHE/lTVY8CtEdKNX/FoWcyI+yUs=;
	b=j4U4QtCgbjFIB4lNa6AJsAJmn1A79ofwrvVqrW9j/2/VCf3Sh25ft/45n2vgVv8HHUIlz8
	23NCR9+mkmaxjYcLFAkml69D3IJAs6sqY0vkCjM4axS96mBfut0S1LywXGELilRL4IkVkp
	DjK0G7nxbgcSvi2nN1db69Yf6DsunZs=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DxE1yYJg;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of matthew.brost@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=matthew.brost@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1787890441;
	b=XS3fVe5PY3h6dqQKAf42N/Qydc4P74byXjK8rpEwqHDsqvVadr4NXH3PBNhuse8rJBeVYJ
	jcgPWhZ1rZNGHH5NML+AOOFeNUG7wQm7xkx6EGzTtISjzBxoRq2SsGhBF0LHx+PitAQL+B
	0ZzJC+gK9SYUA9UHnB9WU3Si29Szutk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1787890440; x=1819426440;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=1FhQtySutwphfwCexlorJPPrLoGxvemWYD9Jdnbe+2Q=;
  b=DxE1yYJgGfFZQLenKrzz3upuXZuv/H1oRryNl5kqI44nMrDi8VfE0Ijq
   lyKQClIwS3k7yOkVsTHh4zBHmsWKEhVSn4B+xa4WN3aG/yp4Bl1gXrCQl
   kHSCzmx5VtsttTtLQDYtL65C1/TByTuX6nlY483MUt8anemA5xeshU31L
   lVypu4D773fN14FOmTW8ESr7r24+1BqzKYS9gors1Ba7Dh1/KZd/ijkaf
   9nVG28woSjY29wPqgyiUc9q4HFz5v8L9u0lh4EI2Jx+PUBPGz1C2dhwY/
   5EQ6lVNZwpZ0enL3APvFRoHCoPkP9npRUrJU50SDqXqzxT7878R1fGbKn
   w==;
X-CSE-ConnectionGUID: XVfTBmsdRq+vb/lNysvrlg==
X-CSE-MsgGUID: m1oLCV0BQvaCiKd5pOKAIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11888"; a="99747333"
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="99747333"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 21:13:59 -0700
X-CSE-ConnectionGUID: sBj976P4RdCAC2wIzFNxWA==
X-CSE-MsgGUID: UVLR0VUoQ2uhddE4JLKbmw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,247,1779174000"; 
   d="scan'208";a="267459632"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2026 21:13:59 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 21:13:58 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Thu, 27 Aug 2026 21:13:58 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.25) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Thu, 27 Aug 2026 21:13:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LXPRkTqDi3GqIoTdKGN0+m07VFjq+91//rpmNQ9bL9RL3TTin9rfgjVGqDuirIN8O4fDK18KZwqYS9Psdpryl060Qj305Ap4Vrl34ilxTO4pQj4ttduHAwgO3BguoqQ/b5yaeiWPuADugK5FIMhheL+cgwYvOb+i/irFrfLfayunKaXMwB9+ISQASZvRquAlXHO8sLnh9Xmyunl2iXTuwuUBld0DyXEisC3uVQ2J1fBLpneLd8N9OLJQECkDbtNeDL8wHjiTFt6LnY9GysMLJvndT2K0HaG6VgfPRrzifEeDmQXbHnR5OOitVoV4M8r9+7BYoxUni9wf19XxMYBRYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+dHdI54XzcPT2OwvHE/lTVY8CtEdKNX/FoWcyI+yUs=;
 b=rbFAZROTIZxwsoM1nQDLOkEAlFWtmHLEoNwi7sNYF8f40B8Bzdz0cXVH04cEhPovKi18C7IoPc4oYznHNWwCTCQCOcw1hkc1+wDBlPHaxItrEI4jtRmMNa02oFAaZ99eevLGXh6OtWHgsB7cpW9cPl/+S+w7qBZC15nEbbSQz599lFzyZWm0RqBARAJ42ucq03lHHx2fUWtqyEQn3N9ezTYWMk7b+xEHKxa+NcCCJrsDKy3A8LLcK564hW3QiqIMHKOt4pF4prtRtAJdRN34XE+WJrxDEMUSvkvuA71Kzo3OWj7Fg/VhcRGXJezF5aEQqbDFzKB5ThxaudjNldw9Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH7PR11MB6522.namprd11.prod.outlook.com (2603:10b6:510:212::12)
 by DS7PR11MB8781.namprd11.prod.outlook.com (2603:10b6:8:256::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Fri, 28 Aug
 2026 04:13:53 +0000
Received: from PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c]) by PH7PR11MB6522.namprd11.prod.outlook.com
 ([fe80::e0c5:6cd8:6e67:dc0c%4]) with mapi id 15.21.0360.008; Fri, 28 Aug 2026
 04:13:53 +0000
Date: Thu, 27 Aug 2026 21:13:50 -0700
From: Matthew Brost <matthew.brost@intel.com>
To: Balbir Singh <balbirs@nvidia.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, Steven Rostedt
	<rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim
	<rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price
	<gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, "Alistair
 Popple" <apopple@nvidia.com>
Subject: Re: [PATCH v2] mm/migrate_device: add class-based migration trace
 events
Message-ID: <apEK/oZhWHsJ+kas@gsse-cloud1.jf.intel.com>
References: <20260828040817.1504092-1-balbirs@nvidia.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260828040817.1504092-1-balbirs@nvidia.com>
X-ClientProxiedBy: SJ0P220CA0001.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:a03:41b::7) To PH7PR11MB6522.namprd11.prod.outlook.com
 (2603:10b6:510:212::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR11MB6522:EE_|DS7PR11MB8781:EE_
X-MS-Office365-Filtering-Correlation-Id: 5de45558-653e-4fcd-21a0-08df04bac596
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|7416014|18002099003|56012099006|22082099003|6133799003|11063799006|10067099003;
X-Microsoft-Antispam-Message-Info: krgo7qyJYjzPNy+eLBU8QCaMvS83+1m9RlqjPwJckSdV7/EQBPAwiRUtow4rDT5a1+G1DwHmnHNu73qhZytObV59FTm8cjiYR8aGGiZkMgNOvfAcKpgjcRwGkEEK1N3qjs7mdAlz8GWkpKLgk+OJFQiw+asLRnVFXJy2I2KgFQ7qeK0aD0xXFOFjQJwrmGTzi/qLMEfIonC9Yxb6IViOzj7J0nAS5+G/6q9HhYF2r3vZXOTVYB5/FCbLpRab6E/P1OUNzpTL/oOHZ0JYyiWSqkrn8VAnF+esz6dyo+ZvlGO2vsvucOgArv7HXsrNwyH/t+hWHjmaU3RxBWMPg7YCe5IpopAfvtFkzxGkHCsPH90gDX6SDP8kZwoAh6E6HFzjuf+tQe6qnq+twahylu+p6vrb4bwZuIgVlsIV8ywoSoLaxYQN48YBr9iJhZmOu2tH38sLe8sX3/l+6POSpu1FQKWQwE3dGOA3twIpJkJzyNf53/MIH2lyzZQsWWLUQWuaEEx0UWsJJc1r7/A1cQw9xTQOhcUlK5fkj5E01+TXPD5MfnwAkB2zq2n1I0lS5q68hhQYaNvJz7f/3A2ulIVnXqlgjWI8/4RxV5WJCtis9SYpO/qY/XTS+VE57WH4O6qNYL0ecdoMMqeMItwq/PLUPc2966jD2tGqOjEjjfhxYMY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR11MB6522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(7416014)(18002099003)(56012099006)(22082099003)(6133799003)(11063799006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gkaf83gj6Dmxby2H1NVjtdo/1CPqaKTZBCnJhEm235V79P+Gocw/lKFoVYWe?=
 =?us-ascii?Q?/7ixqhV+28mKwwZJxiz65opnR7eW1l7AzaBCmS46nyc1hibbm0koUSpP/f3r?=
 =?us-ascii?Q?nIU1jGRy73zQuRmZEueODNiNJpcnoWeK1+YjBWtybyrwVEHbrXD0nE81eWyI?=
 =?us-ascii?Q?heaKvXwWt98vLE/fkNoP9XTXUClirRdUG948wrPEswSAQ/BplilyQ8b6jLtt?=
 =?us-ascii?Q?wtUeMTBSKhz6zYUp1gXwWktpwR6JcOZaCuArvXvxy1c/hztn0NKBmhwsFpcF?=
 =?us-ascii?Q?RBtU7H/B0k6X1AD2t7gZyOHDhnDs7/Q+6Rid8fnAmXZiMorl86iETplZ1bAZ?=
 =?us-ascii?Q?e1GSkcvjhqCi+wxz/QD4PCyMlxDxBaLn5n86X8aVgzJOdMLAnbvt0TCrmrnY?=
 =?us-ascii?Q?OMQftO69uE+AbSS6Sl48VYR9cEBWSC1inlCeFHcX2HrviRLTGIuDH5BSSgeJ?=
 =?us-ascii?Q?n3ElC2ukPn6pMLvDmbvNRNjL+K4D2+xAu4WqmATT6xN6GqqG853kiudMEX3w?=
 =?us-ascii?Q?OeUykchoSVehD8pVcLRAxx1IGuud2j3CFM9lixe36psicQhKXyQIXfSeAjsZ?=
 =?us-ascii?Q?IaDnRbokM3/n/d6Reu4aSh85SyGKN311BPrS3xUNcssaX0fKoG3GRlNLs1Lb?=
 =?us-ascii?Q?RTomOg23Q4ySwUA/3p4m9hTYqBiBNLP+6iD2qIyHKUYxS9llrybX+/7TlWa8?=
 =?us-ascii?Q?ZL/3V4/PD2P0+Uapp4bU+dVlBfZK6mddGRcpfKEyX4K0rlRzD0ciHEKXrdRm?=
 =?us-ascii?Q?ol2e0T9HiC6IgInbkQ4/gxBmr/TdMQ2vYb+4FTI3W48VByvHNMooIuyzzNxo?=
 =?us-ascii?Q?J8FnF+yWZx4+1l3ViSan+8M1/O41sb1DYC8XYord7B+WE4ubtise6gMBf1ge?=
 =?us-ascii?Q?egnfMSscUqVkYDjR5caXmoPRaCA3off2fwwLq+uSs3eV+volMrYe6S9biDhC?=
 =?us-ascii?Q?NPDULGthwPPXFz0Fs3HAfNr8/g+4lPU9JoI0wHWCmFBJowOhtuduxlSfBtiS?=
 =?us-ascii?Q?LjBdiVa4tW9XESeK38UCIoO+L8Y5OXam4Hs+XPhI30D0m0oJ9NhE/Mnr+Fc7?=
 =?us-ascii?Q?bUKDG9zwD0sUyj4yMfnNc9rRBv2mknXnBEFYEbkIFqepA8F9HxLK9QrjpfsF?=
 =?us-ascii?Q?/IppRwkw03+zkCP2xqThnDqWWC3S25FgL/43cHsC2O04pCTIxVgL+Cl1WMnL?=
 =?us-ascii?Q?VXHcuRni6SkLw3nh6lEEGSigcj1jPu9YE5rdKYfccZc2dsWEtJLIwkJhXhR6?=
 =?us-ascii?Q?RQz1KfmbvNUPYEP8NbdjXAv26/kUj7prz/SQfh+r7rq+Bk0FlzR0ClkDZNyM?=
 =?us-ascii?Q?6RG1Eqtc9m9jJH2TjVmztUUYCmYJmM7QsrxNM5GPO/8/o2qTpn8v2NRI/b/K?=
 =?us-ascii?Q?a651sWc48K8FirukllNJGcisDuqVaknngK2IrDnjXWqD+D/F0cgW0Ez2IOWL?=
 =?us-ascii?Q?8lJBCbHvbSwDduacAzDQXvKaypaPApcV78yIPxqas6pmRAusTQxPqy6b/AUE?=
 =?us-ascii?Q?IXjPsAZr3Bg8lHEwxXzzi+F/iA022p9NkDtrZRKuhATcDWffv/06W9IN9a/O?=
 =?us-ascii?Q?1G0nuzF0wy53dt92luVEXUAzAs5o7ebbgXfivSruoQuA03EN731kLKX5oURE?=
 =?us-ascii?Q?KXXTelnTFRk3kSnXfV7dOz0MnjllJfqaafUDOBVEt6UQALvi9qGCpePZ6sPy?=
 =?us-ascii?Q?Pi9TV5iu28wmtj8SWI/A2fckR2detlM2wto4riLgRVk66Zq/cWFd33x6wNf5?=
 =?us-ascii?Q?zAcCHwpv6S042xzwkx9Wh4DdRMlc+cw=3D?=
X-Exchange-RoutingPolicyChecked: egqR5NEyGlZjnwrI1Qo0EQonX+hBhsvPJ/plKfXwpOInYhXJ/svg62s7O/99qzfaKZH5GmaGgCyyKIkR9KH45FOuoIGodW2HtKVgvhigA7mH45mHVFl7VxQ0qUsMHAVUs17p9BnKavL9fED08bSkVUngpeBv9ylKCo43dG1rj+GXqT/o1N0HTvNbVOc8xh/BUc8uRjZiy7FpwsVxliZPv0e3uG55ZJB7BcHX/Woen41RpGXZXSbieo+98R+DfKknvZC9EjMmYcCFSo6MsrqTYlrHldhYiOzMoqt31ipXn/LV4eeFu7P+vYbKPGKQQC6yx5L3zg3BFuqQaofolCRAlg==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5de45558-653e-4fcd-21a0-08df04bac596
X-MS-Exchange-CrossTenant-AuthSource: PH7PR11MB6522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2026 04:13:53.7164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pdrDig4+U/L9t9+MwcizBeIHx3MU+peeJ9SyN46wQ5jNeOr7ruak841SLEhhepJJiXC+CRDm5y61MXktrIbJbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8781
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wn9w8nc5f9men8ekaq5eqeq9f6fufd4g
X-Rspamd-Queue-Id: 50D89A0003
X-HE-Tag: 1787890440-6348
X-HE-Meta: U2FsdGVkX19zcKEYju9kEdwRIQurmkp8+IlauBKQz9+GwmbYx2LagZHKluiX0xiy461JwlcPX3aPLa1iaOopnbpX5DVxQlsSdZpA2TEi2M2AzpsNhX9Mk/mITiH0zbpUcFCcS30gq01Ggj4kz3w3flXw5Bd/W2mAC9zOZ7C5Cl2tIQwVUIw0Sfqn6N4W2EePKq4tsBltagGxJvdMG/2h0YdlUrbnkCUqf3XFNU8MS5NL5yVmBgE/BxMlnH9GLDwHswukiyjT3LJMyvHC59C8uY8aP48yQNN++UJ7trkB8urXFn+T9kwrIFCQOfaNrPw3Rwe5CJ+9gqM5/waX8OX9UBGdl23Z48eqbNDoVlTqeuhdb875U04IpISjj0OW5CcZrltXfBWdHihJk71orLqVqjtOo5zbKf8WqBfUM9Kg3BAAqmU8OwZtQEHNXfc05HUp4u7wz4epKDWc0xGI7w6Sz31h8wjvGmXjgaxYkYWAOs7iDx5VGD/XhvvPO5GKj59nTRBzU7ICEwchL8va7BBlsdd41Zcx1nyjJ9fxSyySehG0Y9j9LyWtCOWittKWkDjA+J97c1mqe2bH+znIS0pAzSnwnDupz6Phu/DuTKrueOFDKTAg/sDrYM/KsJZmPxaK5w7obh3sElwYTd1MnoyeFdsE3/DMYUkUOfGZ1LstBxl2jyXeMAYYPAmCoSjja/RD+MTiYLd4ojzpkyRwDvA83E6yYs7lt1BdGN6GklSaILluoK8rhEyaz4+Ib925Z4tynjskwnDj9Deyr2YmWJmrPyNkeSfPRpCHAZ8f9jvHGU/daMjYmBqYdi6P+bRCmycmWzyudLi9/TJR5ANIaZGE6jpP7IvZ0nlaXrwVDc8bbivm+LB4lgc0Dht8NecW4BmT8NU8+r/w1glNiNAjrD8k1HAJ9U2p6uxeMJuSYjGcmGYJ7jVhvYuWhjgMQ/Tna/VivL5XKoMJTBahu2B6h3V
 +6GfN/ub
 KicXHRsNHjeZTHd8wp1F9/Tne3VVPU1S1wIfDu4HzOHw5DE4N2+oCKCkWDvGMC2RcCl7Y/sOs1IUM+wikd8PCoYS7YdpD18SDoPbPa2OFlEd2doPY6qYfAlCHkANZ8vtfgX/0WBkY/TVArf44qyc3rTDAQZ9Kjik3JFsAbHiBXSDeYtj7B14lDFIQiRpvnSIouGDUpCwY+O1HaBZKxzHeDJnaoOI4gSRNdZjjQUqeM5cLFfSfwdrUhUqEZfTeBm6ZjqynufrTlzFTRaILFnw/VVCthy7GV1ep87fs+jYzarombTX3fmH/f1+qfUpqW0FzmHuMETAqOEN8a1jAWOFq31e3QjOKBuSQwt2gq49gEju0jOUP7d+odNfhxJX1Kv994UhVIrL9ZZxEuVi86/kBJk94x6D+760r9MKkCpGOBPMOo2tsYv4rCypOfnD6ciwzU9PN7qTfyHCgnA4hmoqVd4ghubCBQa7H4an11LxD5NdPu9xr5JJw0DP9y6PCs684z+G9VXQ21dW8v/3d/2uap8yJXwjXaUmHhpgVZTPf94nV+v1UKZ0AbunTmk4bmkUclptrxitx+B5qs0Bba/yeWJwMQpgtFEhLnGrb/FfEqeg6fVONklrlcXUYvO34vFj9DZagJS8+jGzY7siwKM8CYfqvUqb0FEEze0ZB/kfZI2FcBjaJC8kfyhrtgLLm1CkdG2eZMovQwVcRfFlw6SJqtuxAUF1QmeGK1Mqx738ZKQfKHiuyYsn6dzh5N9SKGX3IVbRjzeYdzXJpzqUZRamsIbDvFA32i4U5WFnUoZzYWDjwY3mrF4wU89+0p6T3WDbVfuz+E6yx3SxTRdYjqz9jv8y+zudy5ifCZ3SyU4PMQb+kRAXeyZs3VotbdmnKtGQbQv30DPzj0ClxIAMyT2tx4pGelfwkRutu8S0aPItmzhYT+qzLtqM/qEcCrwGiWXS+JXG03IYJ36/B6+8s8DAb11HCw8ch
 YZIo2nS1
 DKU20Oo006I8ZUyIuweRPQhbScn63zBycej7k4N5LNXP2ur//N482BhWvDCFikbS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 02:08:17PM +1000, Balbir Singh wrote:
> Device-private migrations currently require ad-hoc instrumentation to
> understand selection, unmap, copy, and finalization behavior.
> 
> Add reusable ftrace event classes for migrate_vma ranges, device
> batches, and individual folios. Emit start, done traces with
> ranges, flags, page counts, success/failure summaries, PFNs,
> and migrate flags.
> 
> Enabling all traces can make the migration traces verbose, when used
> they can also help debug issues with device migration.
> 
> Signed-off-by: Balbir Singh <balbirs@nvidia.com>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>

This seems like a pretty good adding tracepoints - anytime I've had to
debug issues in migrate_device.c it has basically start adding printks to
figure out what is going on. Hopefully witth the right tracepoints, this
would now be turn on ftrace.

So +1 on the idea.

In the middle of a few other things, but will circle back with an in
depth look at individual tracepoints added here when a bit more time.

Matt  

> Assisted-by: Codex:gpt-5.6-sol
> Link: https://lore.kernel.org/linux-mm/20251110161954.47d88433@gandalf.local.home/
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> CC: Masami Hiramatsu <mhiramat@kernel.org>
> CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: David Hildenbrand <david@kernel.org>
> CC: Zi Yan <ziy@nvidia.com>
> CC: Matthew Brost <matthew.brost@intel.com>
> CC: Joshua Hahn <joshua.hahnjy@gmail.com>
> CC: Rakie Kim <rakie.kim@sk.com>
> CC: Byungchul Park <byungchul@sk.com>
> CC: Gregory Price <gourry@gourry.net>
> CC: Ying Huang <ying.huang@linux.alibaba.com>
> CC: Alistair Popple <apopple@nvidia.com>
> ---
>  include/trace/events/migrate_device.h | 324 ++++++++++++++++++++++++++
>  mm/migrate_device.c                   |  79 ++++++-
>  2 files changed, 391 insertions(+), 12 deletions(-)
>  create mode 100644 include/trace/events/migrate_device.h
> 
> diff --git a/include/trace/events/migrate_device.h b/include/trace/events/migrate_device.h
> new file mode 100644
> index 000000000000..46582c919dc2
> --- /dev/null
> +++ b/include/trace/events/migrate_device.h
> @@ -0,0 +1,324 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2023 NVIDIA CORPORATION & AFFILIATES. All rights reserved.
> + */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM migrate_device
> +
> +#if !defined(_TRACE_MIGRATE_DEVICE_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_MIGRATE_DEVICE_H
> +
> +#include <linux/migrate.h>
> +#include <linux/tracepoint.h>
> +
> +/*
> + * Define enums for tracing information.
> + */
> +#ifndef __MIGRATE_DEVICE_DECLARE_TRACE_ENUMS_ONCE_ONLY
> +#define __MIGRATE_DEVICE_DECLARE_TRACE_ENUMS_ONCE_ONLY
> +
> +/*
> + * Why a page table walk callback classified the range the way it did.
> + * Several call sites collect the same kind of range, so the reason is
> + * what distinguishes them in a trace.
> + */
> +enum migrate_vma_walk_reason {
> +	MIGRATE_VMA_WALK_HOLE,
> +	MIGRATE_VMA_WALK_HOLE_COMPOUND,
> +	MIGRATE_VMA_WALK_HUGE_PMD,
> +	MIGRATE_VMA_WALK_SKIP_NOT_ANON,
> +	MIGRATE_VMA_WALK_SKIP_NOT_SELECTED,
> +	MIGRATE_VMA_WALK_SKIP_OWNER_MISMATCH,
> +	MIGRATE_VMA_WALK_SKIP_LOCK_CONTENDED,
> +	MIGRATE_VMA_WALK_SKIP_COMPOUND_TAIL,
> +	MIGRATE_VMA_WALK_SKIP_SPLIT_FAILED,
> +};
> +
> +#endif /* __MIGRATE_DEVICE_DECLARE_TRACE_ENUMS_ONCE_ONLY */
> +
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_SELECT_SYSTEM);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_SELECT_DEVICE_PRIVATE);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_SELECT_DEVICE_COHERENT);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_SELECT_COMPOUND);
> +
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_HOLE);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_HOLE_COMPOUND);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_HUGE_PMD);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_SKIP_NOT_ANON);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_SKIP_NOT_SELECTED);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_SKIP_OWNER_MISMATCH);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_SKIP_LOCK_CONTENDED);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_SKIP_COMPOUND_TAIL);
> +TRACE_DEFINE_ENUM(MIGRATE_VMA_WALK_SKIP_SPLIT_FAILED);
> +
> +#define show_walk_reason(reason)					\
> +	__print_symbolic(reason,					\
> +		{ MIGRATE_VMA_WALK_HOLE,		"HOLE" },	\
> +		{ MIGRATE_VMA_WALK_HOLE_COMPOUND,	"HOLE_COMPOUND" }, \
> +		{ MIGRATE_VMA_WALK_HUGE_PMD,		"HUGE_PMD" },	\
> +		{ MIGRATE_VMA_WALK_SKIP_NOT_ANON,	"NOT_ANON" },	\
> +		{ MIGRATE_VMA_WALK_SKIP_NOT_SELECTED,	"NOT_SELECTED" }, \
> +		{ MIGRATE_VMA_WALK_SKIP_OWNER_MISMATCH,	"OWNER_MISMATCH" }, \
> +		{ MIGRATE_VMA_WALK_SKIP_LOCK_CONTENDED,	"LOCK_CONTENDED" }, \
> +		{ MIGRATE_VMA_WALK_SKIP_COMPOUND_TAIL,	"COMPOUND_TAIL" }, \
> +		{ MIGRATE_VMA_WALK_SKIP_SPLIT_FAILED,	"SPLIT_FAILED" })
> +
> +#define show_migrate_vma_flags(flags)					\
> +	__print_flags(flags, "|",					\
> +		{ MIGRATE_VMA_SELECT_SYSTEM,		"SYSTEM" },	\
> +		{ MIGRATE_VMA_SELECT_DEVICE_PRIVATE,	"DEVICE_PRIVATE" }, \
> +		{ MIGRATE_VMA_SELECT_DEVICE_COHERENT,	"DEVICE_COHERENT" }, \
> +		{ MIGRATE_VMA_SELECT_COMPOUND,		"COMPOUND" })
> +
> +DECLARE_EVENT_CLASS(migrate_vma_range_class,
> +
> +	TP_PROTO(const struct migrate_vma *migrate),
> +
> +	TP_ARGS(migrate),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, vma)
> +		__field(void *, mm)
> +		__field(void *, src)
> +		__field(void *, dst)
> +		__field(void *, pgmap_owner)
> +		__field(void *, fault_page)
> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +		__field(unsigned long, npages)
> +		__field(unsigned long, cpages)
> +		__field(unsigned long, flags)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vma = migrate->vma;
> +		__entry->mm = migrate->vma ? migrate->vma->vm_mm : NULL;
> +		__entry->src = migrate->src;
> +		__entry->dst = migrate->dst;
> +		__entry->pgmap_owner = migrate->pgmap_owner;
> +		__entry->fault_page = migrate->fault_page;
> +		__entry->start = migrate->start;
> +		__entry->end = migrate->end;
> +		__entry->npages = migrate->npages;
> +		__entry->cpages = migrate->cpages;
> +		__entry->flags = migrate->flags;
> +	),
> +
> +	TP_printk("mm=%p vma=%p range=%#lx-%#lx bytes=%lu npages=%lu cpages=%lu flags=%s src=%p dst=%p owner=%p fault_page=%p",
> +		__entry->mm, __entry->vma, __entry->start, __entry->end,
> +		__entry->end - __entry->start, __entry->npages,
> +		__entry->cpages,
> +		show_migrate_vma_flags(__entry->flags),
> +		__entry->src, __entry->dst, __entry->pgmap_owner,
> +		__entry->fault_page)
> +);
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_setup_start,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_setup_done,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_collect_start,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_collect_done,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_pages_start,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_pages_done,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_finalize_start,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +DEFINE_EVENT(migrate_vma_range_class, migrate_vma_finalize_done,
> +	TP_PROTO(const struct migrate_vma *migrate),
> +	TP_ARGS(migrate));
> +
> +/*
> + * Page table walk callbacks act on a sub-range of the migration and can be
> + * reached from several call sites, so they report the range they were handed
> + * and why, in addition to the migrate-wide state.
> + */
> +DECLARE_EVENT_CLASS(migrate_vma_walk_class,
> +
> +	TP_PROTO(const struct migrate_vma *migrate, unsigned long start,
> +		 unsigned long end, enum migrate_vma_walk_reason reason),
> +
> +	TP_ARGS(migrate, start, end, reason),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, vma)
> +		__field(void *, mm)
> +		__field(void *, src)
> +		__field(void *, dst)
> +		__field(void *, pgmap_owner)
> +		__field(void *, fault_page)
> +		__field(unsigned long, walk_start)
> +		__field(unsigned long, walk_end)
> +		__field(unsigned long, start)
> +		__field(unsigned long, end)
> +		__field(unsigned long, npages)
> +		__field(unsigned long, cpages)
> +		__field(unsigned long, flags)
> +		__field(unsigned int, reason)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->vma = migrate->vma;
> +		__entry->mm = migrate->vma ? migrate->vma->vm_mm : NULL;
> +		__entry->src = migrate->src;
> +		__entry->dst = migrate->dst;
> +		__entry->pgmap_owner = migrate->pgmap_owner;
> +		__entry->fault_page = migrate->fault_page;
> +		__entry->walk_start = start;
> +		__entry->walk_end = end;
> +		__entry->start = migrate->start;
> +		__entry->end = migrate->end;
> +		__entry->npages = migrate->npages;
> +		__entry->cpages = migrate->cpages;
> +		__entry->flags = migrate->flags;
> +		__entry->reason = reason;
> +	),
> +
> +	TP_printk("mm=%p vma=%p walk=%#lx-%#lx bytes=%lu reason=%s range=%#lx-%#lx npages=%lu cpages=%lu flags=%s src=%p dst=%p owner=%p fault_page=%p",
> +		__entry->mm, __entry->vma,
> +		__entry->walk_start, __entry->walk_end,
> +		__entry->walk_end - __entry->walk_start,
> +		show_walk_reason(__entry->reason),
> +		__entry->start, __entry->end, __entry->npages,
> +		__entry->cpages,
> +		show_migrate_vma_flags(__entry->flags),
> +		__entry->src, __entry->dst, __entry->pgmap_owner,
> +		__entry->fault_page)
> +);
> +
> +DEFINE_EVENT(migrate_vma_walk_class, migrate_vma_collect_skip,
> +	TP_PROTO(const struct migrate_vma *migrate, unsigned long start,
> +		 unsigned long end, enum migrate_vma_walk_reason reason),
> +	TP_ARGS(migrate, start, end, reason));
> +
> +DEFINE_EVENT(migrate_vma_walk_class, migrate_vma_collect_hole,
> +	TP_PROTO(const struct migrate_vma *migrate, unsigned long start,
> +		 unsigned long end, enum migrate_vma_walk_reason reason),
> +	TP_ARGS(migrate, start, end, reason));
> +
> +DEFINE_EVENT(migrate_vma_walk_class, migrate_vma_collect_huge_pmd,
> +	TP_PROTO(const struct migrate_vma *migrate, unsigned long start,
> +		 unsigned long end, enum migrate_vma_walk_reason reason),
> +	TP_ARGS(migrate, start, end, reason));
> +
> +DECLARE_EVENT_CLASS(migrate_device_batch_class,
> +
> +	TP_PROTO(const unsigned long *src, const unsigned long *dst,
> +		 unsigned long npages),
> +
> +	TP_ARGS(src, dst, npages),
> +
> +	TP_STRUCT__entry(
> +		__field(void *, src)
> +		__field(void *, dst)
> +		__field(unsigned long, src_head)
> +		__field(unsigned long, dst_head)
> +		__field(unsigned long, npages)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->src = (void *)src;
> +		__entry->dst = (void *)dst;
> +		__entry->src_head = npages && src ? src[0] : 0;
> +		__entry->dst_head = npages && dst ? dst[0] : 0;
> +		__entry->npages = npages;
> +	),
> +
> +	TP_printk("src=%p dst=%p npages=%lu src_head=%#lx dst_head=%#lx",
> +		__entry->src, __entry->dst, __entry->npages,
> +		__entry->src_head, __entry->dst_head)
> +);
> +
> +DEFINE_EVENT(migrate_device_batch_class, migrate_device_unmap_done,
> +	TP_PROTO(const unsigned long *src, const unsigned long *dst,
> +		 unsigned long npages),
> +	TP_ARGS(src, dst, npages));
> +
> +DEFINE_EVENT(migrate_device_batch_class, migrate_device_pages_start,
> +	TP_PROTO(const unsigned long *src, const unsigned long *dst,
> +		 unsigned long npages),
> +	TP_ARGS(src, dst, npages));
> +
> +DEFINE_EVENT(migrate_device_batch_class, migrate_device_pages_done,
> +	TP_PROTO(const unsigned long *src, const unsigned long *dst,
> +		 unsigned long npages),
> +	TP_ARGS(src, dst, npages));
> +
> +DEFINE_EVENT(migrate_device_batch_class, migrate_device_finalize_start,
> +	TP_PROTO(const unsigned long *src, const unsigned long *dst,
> +		 unsigned long npages),
> +	TP_ARGS(src, dst, npages));
> +
> +DEFINE_EVENT(migrate_device_batch_class, migrate_device_finalize_done,
> +	TP_PROTO(const unsigned long *src, const unsigned long *dst,
> +		 unsigned long npages),
> +	TP_ARGS(src, dst, npages));
> +
> +DECLARE_EVENT_CLASS(migrate_device_folio_class,
> +
> +	TP_PROTO(unsigned long index, unsigned long nr_pages,
> +		 unsigned long src, unsigned long dst),
> +
> +	TP_ARGS(index, nr_pages, src, dst),
> +
> +	TP_STRUCT__entry(
> +		__field(unsigned long, index)
> +		__field(unsigned long, nr_pages)
> +		__field(unsigned long, src)
> +		__field(unsigned long, dst)
> +		__field(unsigned long, src_pfn)
> +		__field(unsigned long, dst_pfn)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->index = index;
> +		__entry->nr_pages = nr_pages;
> +		__entry->src = src;
> +		__entry->dst = dst;
> +		__entry->src_pfn = src >> MIGRATE_PFN_SHIFT;
> +		__entry->dst_pfn = dst >> MIGRATE_PFN_SHIFT;
> +	),
> +
> +	TP_printk("index=%lu nr_pages=%lu src=%#lx src_pfn=%#lx src_flags=%s dst=%#lx dst_pfn=%#lx dst_flags=%s",
> +		__entry->index, __entry->nr_pages, __entry->src,
> +		__entry->src_pfn,
> +		__print_flags(__entry->src & ((1UL << MIGRATE_PFN_SHIFT) - 1),
> +			"|",
> +			{ MIGRATE_PFN_VALID, "VALID" },
> +			{ MIGRATE_PFN_MIGRATE, "MIGRATE" },
> +			{ MIGRATE_PFN_WRITE, "WRITE" },
> +			{ MIGRATE_PFN_COMPOUND, "COMPOUND" }),
> +		__entry->dst, __entry->dst_pfn,
> +		__print_flags(__entry->dst & ((1UL << MIGRATE_PFN_SHIFT) - 1),
> +			"|",
> +			{ MIGRATE_PFN_VALID, "VALID" },
> +			{ MIGRATE_PFN_MIGRATE, "MIGRATE" },
> +			{ MIGRATE_PFN_WRITE, "WRITE" },
> +			{ MIGRATE_PFN_COMPOUND, "COMPOUND" }))
> +);
> +
> +DEFINE_EVENT(migrate_device_folio_class, migrate_device_folio_finalize,
> +	TP_PROTO(unsigned long index, unsigned long nr_pages,
> +		 unsigned long src, unsigned long dst),
> +	TP_ARGS(index, nr_pages, src, dst));
> +
> +#endif /* _TRACE_MIGRATE_DEVICE_H */
> +
> +#include <trace/define_trace.h>
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 009bfa8b212d..cf2a78d2e18e 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -16,11 +16,16 @@
>  #include <linux/leafops.h>
>  #include <linux/pgalloc.h>
>  #include <asm/tlbflush.h>
> +
> +#define CREATE_TRACE_POINTS
> +#include <trace/events/migrate_device.h>
> +
>  #include "internal.h"
>  
>  static int migrate_vma_collect_skip(unsigned long start,
>  				    unsigned long end,
> -				    struct mm_walk *walk)
> +				    struct mm_walk *walk,
> +				    enum migrate_vma_walk_reason reason)
>  {
>  	struct migrate_vma *migrate = walk->private;
>  	unsigned long addr;
> @@ -30,6 +35,7 @@ static int migrate_vma_collect_skip(unsigned long start,
>  		migrate->src[migrate->npages++] = 0;
>  	}
>  
> +	trace_migrate_vma_collect_skip(migrate, start, end, reason);
>  	return 0;
>  }
>  
> @@ -43,7 +49,8 @@ static int migrate_vma_collect_hole(unsigned long start,
>  
>  	/* Only allow populating anonymous memory. */
>  	if (!vma_is_anonymous(walk->vma))
> -		return migrate_vma_collect_skip(start, end, walk);
> +		return migrate_vma_collect_skip(start, end, walk,
> +						MIGRATE_VMA_WALK_SKIP_NOT_ANON);
>  
>  	if (thp_migration_supported() &&
>  		(migrate->flags & MIGRATE_VMA_SELECT_COMPOUND) &&
> @@ -55,11 +62,15 @@ static int migrate_vma_collect_hole(unsigned long start,
>  		migrate->npages++;
>  		migrate->cpages++;
>  
> +		trace_migrate_vma_collect_hole(migrate, start, end,
> +					       MIGRATE_VMA_WALK_HOLE_COMPOUND);
> +
>  		/*
>  		 * Collect the remaining entries as holes, in case we
>  		 * need to split later
>  		 */
> -		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> +		return migrate_vma_collect_skip(start + PAGE_SIZE, end, walk,
> +						MIGRATE_VMA_WALK_SKIP_COMPOUND_TAIL);
>  	}
>  
>  	for (addr = start; addr < end; addr += PAGE_SIZE) {
> @@ -69,6 +80,8 @@ static int migrate_vma_collect_hole(unsigned long start,
>  		migrate->cpages++;
>  	}
>  
> +	trace_migrate_vma_collect_hole(migrate, start, end,
> +				       MIGRATE_VMA_WALK_HOLE);
>  	return 0;
>  }
>  
> @@ -154,7 +167,8 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  	if (pmd_trans_huge(*pmdp)) {
>  		if (!(migrate->flags & MIGRATE_VMA_SELECT_SYSTEM)) {
>  			spin_unlock(ptl);
> -			return migrate_vma_collect_skip(start, end, walk);
> +			return migrate_vma_collect_skip(start, end, walk,
> +					MIGRATE_VMA_WALK_SKIP_NOT_SELECTED);
>  		}
>  
>  		folio = pmd_folio(*pmdp);
> @@ -170,13 +184,15 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  		if (!softleaf_is_device_private(entry) ||
>  		    !(migrate->flags & MIGRATE_VMA_SELECT_DEVICE_PRIVATE)) {
>  			spin_unlock(ptl);
> -			return migrate_vma_collect_skip(start, end, walk);
> +			return migrate_vma_collect_skip(start, end, walk,
> +					MIGRATE_VMA_WALK_SKIP_NOT_SELECTED);
>  		}
>  
>  		folio = softleaf_to_folio(entry);
>  		if (folio->pgmap->owner != migrate->pgmap_owner) {
>  			spin_unlock(ptl);
> -			return migrate_vma_collect_skip(start, end, walk);
> +			return migrate_vma_collect_skip(start, end, walk,
> +					MIGRATE_VMA_WALK_SKIP_OWNER_MISMATCH);
>  		}
>  
>  		if (softleaf_is_device_private_write(entry))
> @@ -190,7 +206,8 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  	if (folio != fault_folio && unlikely(!folio_trylock(folio))) {
>  		spin_unlock(ptl);
>  		folio_put(folio);
> -		return migrate_vma_collect_skip(start, end, walk);
> +		return migrate_vma_collect_skip(start, end, walk,
> +					MIGRATE_VMA_WALK_SKIP_LOCK_CONTENDED);
>  	}
>  
>  	if (thp_migration_supported() &&
> @@ -220,8 +237,12 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  			migrate->dst[migrate->npages] = 0;
>  			goto fallback;
>  		}
> -		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk);
> +		migrate_vma_collect_skip(start + PAGE_SIZE, end, walk,
> +					 MIGRATE_VMA_WALK_SKIP_COMPOUND_TAIL);
>  		spin_unlock(ptl);
> +
> +		trace_migrate_vma_collect_huge_pmd(migrate, start, end,
> +						   MIGRATE_VMA_WALK_HUGE_PMD);
>  		return 0;
>  	}
>  
> @@ -234,7 +255,8 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
>  		folio_unlock(folio);
>  	folio_put(folio);
>  	if (ret)
> -		return migrate_vma_collect_skip(start, end, walk);
> +		return migrate_vma_collect_skip(start, end, walk,
> +					MIGRATE_VMA_WALK_SKIP_SPLIT_FAILED);
>  	if (pmd_none(pmdp_get_lockless(pmdp)))
>  		return migrate_vma_collect_hole(start, end, -1, walk);
>  
> @@ -323,7 +345,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  					if (unmapped)
>  						flush_tlb_range(walk->vma, start, end);
>  
> -					return migrate_vma_collect_skip(addr, end, walk);
> +					return migrate_vma_collect_skip(addr,
> +						end, walk,
> +						MIGRATE_VMA_WALK_SKIP_SPLIT_FAILED);
>  				}
>  
>  				goto again;
> @@ -369,7 +393,9 @@ static int migrate_vma_collect_pmd(pmd_t *pmdp,
>  					if (unmapped)
>  						flush_tlb_range(walk->vma, start, end);
>  
> -					return migrate_vma_collect_skip(addr, end, walk);
> +					return migrate_vma_collect_skip(addr,
> +						end, walk,
> +						MIGRATE_VMA_WALK_SKIP_SPLIT_FAILED);
>  				}
>  
>  				goto again;
> @@ -514,6 +540,8 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
>  {
>  	struct mmu_notifier_range range;
>  
> +	trace_migrate_vma_collect_start(migrate);
> +
>  	/*
>  	 * Note that the pgmap_owner is passed to the mmu notifier callback so
>  	 * that the registered device driver can skip invalidating device
> @@ -529,6 +557,7 @@ static void migrate_vma_collect(struct migrate_vma *migrate)
>  
>  	mmu_notifier_invalidate_range_end(&range);
>  	migrate->end = migrate->start + (migrate->npages << PAGE_SHIFT);
> +	trace_migrate_vma_collect_done(migrate);
>  }
>  
>  /*
> @@ -653,6 +682,7 @@ static unsigned long migrate_device_unmap(unsigned long *src_pfns,
>  		restore--;
>  	}
>  
> +	trace_migrate_device_unmap_done(src_pfns, NULL, npages);
>  	return unmapped;
>  }
>  
> @@ -763,11 +793,13 @@ int migrate_vma_setup(struct migrate_vma *args)
>  	memset(args->src, 0, sizeof(*args->src) * nr_pages);
>  	args->cpages = 0;
>  	args->npages = 0;
> +	trace_migrate_vma_setup_start(args);
>  
>  	migrate_vma_collect(args);
>  
>  	if (args->cpages)
>  		migrate_vma_unmap(args);
> +	trace_migrate_vma_setup_done(args);
>  
>  	/*
>  	 * At this point pages are locked and unmapped, and thus they have
> @@ -1115,7 +1147,9 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  	bool notified = false;
>  	unsigned long addr;
>  
> -	for (i = 0; i < npages; ) {
> +	trace_migrate_device_pages_start(src_pfns, dst_pfns, npages);
> +
> +	for (i = 0; i < npages;) {
>  		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
>  		struct page *page = migrate_pfn_to_page(src_pfns[i]);
>  		struct address_space *mapping;
> @@ -1257,6 +1291,8 @@ static void __migrate_device_pages(unsigned long *src_pfns,
>  
>  	if (notified)
>  		mmu_notifier_invalidate_range_end(&range);
> +
> +	trace_migrate_device_pages_done(src_pfns, dst_pfns, npages);
>  }
>  
>  /**
> @@ -1285,7 +1321,9 @@ EXPORT_SYMBOL(migrate_device_pages);
>   */
>  void migrate_vma_pages(struct migrate_vma *migrate)
>  {
> +	trace_migrate_vma_pages_start(migrate);
>  	__migrate_device_pages(migrate->src, migrate->dst, migrate->npages, migrate);
> +	trace_migrate_vma_pages_done(migrate);
>  }
>  EXPORT_SYMBOL(migrate_vma_pages);
>  
> @@ -1298,11 +1336,24 @@ static void __migrate_device_finalize(unsigned long *src_pfns,
>  		page_folio(fault_page) : NULL;
>  	unsigned long i;
>  
> +	trace_migrate_device_finalize_start(src_pfns, dst_pfns, npages);
> +
>  	for (i = 0; i < npages; i++) {
>  		struct folio *dst = NULL, *src = NULL;
>  		struct page *newpage = migrate_pfn_to_page(dst_pfns[i]);
>  		struct page *page = migrate_pfn_to_page(src_pfns[i]);
>  
> +		if (trace_migrate_device_folio_finalize_enabled() &&
> +		    (page || newpage)) {
> +			unsigned long nr_pages = page ?
> +						 folio_nr_pages(page_folio(page)) :
> +						 folio_nr_pages(page_folio(newpage));
> +
> +			trace_migrate_device_folio_finalize(i, nr_pages,
> +							    src_pfns[i],
> +							    dst_pfns[i]);
> +		}
> +
>  		if (newpage)
>  			dst = page_folio(newpage);
>  
> @@ -1339,6 +1390,8 @@ static void __migrate_device_finalize(unsigned long *src_pfns,
>  			folio_put(dst);
>  		}
>  	}
> +
> +	trace_migrate_device_finalize_done(src_pfns, dst_pfns, npages);
>  }
>  
>  /*
> @@ -1371,8 +1424,10 @@ EXPORT_SYMBOL(migrate_device_finalize);
>   */
>  void migrate_vma_finalize(struct migrate_vma *migrate)
>  {
> +	trace_migrate_vma_finalize_start(migrate);
>  	__migrate_device_finalize(migrate->src, migrate->dst, migrate->npages,
>  				  migrate->fault_page);
> +	trace_migrate_vma_finalize_done(migrate);
>  }
>  EXPORT_SYMBOL(migrate_vma_finalize);
>  
> -- 
> 2.55.0
> 

