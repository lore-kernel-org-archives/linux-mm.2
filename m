Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF34D41C36
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 13:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0856B0005; Thu, 11 Dec 2025 08:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069DC6B0007; Thu, 11 Dec 2025 08:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25416B0008; Thu, 11 Dec 2025 08:40:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8C8F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 08:40:27 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 756C21DD747
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:40:27 +0000 (UTC)
X-FDA: 84207299694.26.97414F8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC1641C0004
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 13:40:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I77pvgTJ;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765460424; a=rsa-sha256;
	cv=fail;
	b=L81Zo5Eja2lhcKwdWq1pq8hnzqCcbPWX8Qza/cTamuKtSorhEN2hd6ZmP1o4JUMv0quGKF
	SYeSW7iCetySAmAe2qdyLDtDFnjE6qATjEJGFRFE7kMp1APiS47V7uFlBuEg7HXyhMQ6st
	j7H1LBzfwv0YR3NfPgMZCU39JyjILHY=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=I77pvgTJ;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf21.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.21 as permitted sender) smtp.mailfrom=oliver.sang@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765460424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mrtaz6UCsINJNTTDNKfHbDHgHa9G5LAXAWUptfFMcYc=;
	b=Yjrq/GhQrgC4wyRCciTu+zobyFVX4rfcLYtog0dfhG4g0g270s0H+rUIGsl/9h4hfyduN5
	3mtGHZ0eAeyHLOGoOGSQ648SCvWZWMexB2T+R1dd7mDL7fxuXkB6Xoo+OMJFNZXO6BgvMg
	DcVNE7/FZFKHxrTc0oCVpfsdYurr8pI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765460424; x=1796996424;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=eJ+SgGwIF8/vppxpqJ+lGpty+ZezdOJQkTewH9I/3q8=;
  b=I77pvgTJ6wQAFIrCyEG8DbyCGQx233dYmB9v9qCiI1sUfJo8DeT3R4Pc
   WnsgzFLXG8qgT3juod8qGEYIVdUaph53ER+TYaKSoytvgmPszspvCknhJ
   m/z41FKZkwoiDWCV0Ei9X2NqKYyzwF4KfLqKPnwOvWqFLQ2BZu/oEq1ZK
   mL9exhwvAiktoxM8G09P4GsD1QtkyFBOc6GdW7EvcOtB5+eOf69OJs2P+
   z1JZ7JIm0Hr6UkUTwk1tLo4qH1CFsVo1Q90V318fq3oXQIV6Ct5UcFHpF
   otDBtZUEYsseRXHdgVG/CMD6HHmZ8SigknYvlTyuXEWEQnSgMCwd1ABe/
   Q==;
X-CSE-ConnectionGUID: H5dwTCjVR5iVHbUVhh1W+g==
X-CSE-MsgGUID: o1XCpGrfSgOyEg4dyPyhYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11635"; a="67375124"
X-IronPort-AV: E=Sophos;i="6.20,256,1758610800"; 
   d="xz'341?scan'341,208,341";a="67375124"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 05:40:22 -0800
X-CSE-ConnectionGUID: 9aymeWuiTYiXlK3N5mwnPA==
X-CSE-MsgGUID: qz2W6Oh1S7SiEdACe1fLzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,141,1763452800"; 
   d="xz'341?scan'341,208,341";a="196568988"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Dec 2025 05:40:21 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 05:40:20 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 11 Dec 2025 05:40:20 -0800
Received: from DM1PR04CU001.outbound.protection.outlook.com (52.101.61.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 11 Dec 2025 05:40:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sElInZ2AHurUJ2y6JOnm4a5rO1BIMZGq9tVzpNVejutoSwu2VxyDjTM3NJKDaferOC4ENTIuvd4iRwfPoR22t/OzmuADJFxk+XqqWVkX8IEu4iCqG7VaetbdtfGdgSqIiHi+LM8b0l927CSP16SX2rgPhDVju1pTSYoC1mPTacu9uipwKbuiFu1Tl1BwUX6+r8kHCXCGtD3z2k04jYTHzRphBUopIYTTSJFtV+V+p1pnXz5HCZBhG69r9lkJ1PT5yLYh49gsoEAqivsQ85+HGCR0tyMdMYgJGVBwoTrEwJoJV1j7eNMo/j0mP7+N2AhPbQiqXYYJWf1z6ly6SXw3eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p81io6vKc8Fk5wla8I21IOYecbAlIX1L8smdev7cljA=;
 b=YppnJepv7RixEiG4SfuySAcpBnocPpVqPzWZvFAruUow6vEKL48siCVa0nDsw5Mu8UUCYTr2yi3+F4F+d22GGlEG4jubdoHTVNNcNG0YqpubtV9NTUCFgePBZJKPPO2zgZCKTGuxla1ktAKlDzZtaVPJwzddGxTyMWFRxRO3qDs8a5E+UmWJz2b1UZZ04hRNSJYHHPo44fC9YnxGqD//99cf4f7J1rCfWWbR1ylxQpapiion8S0u2ckSnkcM23XiOC+H6ecuIkQYF0DDpw0D+XTxFCi9YjofE08uZY0tqG2v68h8Lm7A+pHaaDTmUoEvK3Duq0U+zqRVQlDsCmr/pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by PH7PR11MB8527.namprd11.prod.outlook.com (2603:10b6:510:2ff::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.9; Thu, 11 Dec
 2025 13:40:16 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Thu, 11 Dec 2025
 13:40:16 +0000
Date: Thu, 11 Dec 2025 21:40:07 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Uladzislau Rezki <urezki@gmail.com>
CC: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	<oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: Re: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <aTrJtyGbvO/Wt5nf@xsang-OptiPlex-9020>
References: <202512101320.e2f2dd6f-lkp@intel.com>
 <aToCq6XBybxAFopN@fedora>
 <aTqYZ7hearly5H6c@pc636>
Content-Type: multipart/mixed; boundary="mkTGuLlkwsdkdHXv"
Content-Disposition: inline
In-Reply-To: <aTqYZ7hearly5H6c@pc636>
X-ClientProxiedBy: TP0P295CA0036.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:910:4::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|PH7PR11MB8527:EE_
X-MS-Office365-Filtering-Correlation-Id: 3eed82b4-6ff5-4be7-fe89-08de38bad143
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|4053099003;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?MvWQ2sTKEehx93g32eHg4nkQgqjC5oAedz9UnnruEt0mY0td0QeXGUUveMDx?=
 =?us-ascii?Q?dKqSi9PscMHNLkZm7/hH0CNNg7asiwFmdrWAGxZUw7NO0OW0Vfrg8esWAMl4?=
 =?us-ascii?Q?jgQMO4ncrHyt3ty2pEWt3Ve5gmzpFpDkveaHN/98ASE5/92MzApnBNrlESTi?=
 =?us-ascii?Q?qgrXccpKBgFpStwxhBGBrcFFUmhgfvTTqQf9GyQ2nOB1DGGuxxW0xO2xSvDc?=
 =?us-ascii?Q?vtuzEacp9yFuVNozLI5hiZiIalLb2GzbsW0vSMZtSj6Up9If5klgjPviX+IT?=
 =?us-ascii?Q?87p8x2pz/JlABHWgmmHCI/BQwyQSJFBrYVHv/Fbk6tX+bnX/QichJS8EWkMO?=
 =?us-ascii?Q?PICCo26SO17ZV1+QyJA575j3cKPRqEV/q2YZ1ttoOEo0IxPXpK+sSgHqnkaQ?=
 =?us-ascii?Q?Aw/Or15KpmZBGrQs+XURKtobdit9qQj4iVs6l0nT7heQ07GNv4vKTk8HgumZ?=
 =?us-ascii?Q?cigtjTZ4PCEamt2Yda30OOkK9MAMScqppuOXN/2OW8JmnHVfDglzOQ8/jPY8?=
 =?us-ascii?Q?jn9EnOrO1FQ82eYkhJQa9o7Cz3jrDO19FFnm5lVyHH+QnWIUvTLhbKloSjtF?=
 =?us-ascii?Q?5BeFVJUN/b9pYqKQcro6ivhR4gXZOJHUfI4dTtspb+Ad9ZjR3XlE1TvlrgDA?=
 =?us-ascii?Q?ps3m1lVP0HqiW/ifTrpgQBDnyGTgliPJI/NQsPAFn6fAH0juyYVhPDczz3yP?=
 =?us-ascii?Q?GV65MtbIUFFA+3VCfm8ykgClZz5eS1/bTkqQGWfcbdbi9y8SF25V/OhmMeB6?=
 =?us-ascii?Q?NoicGMjl05y0UDcjnpbqzPAp9/oTxVQqYNCzqP/hsQte7V0S00q2PiKNeDUF?=
 =?us-ascii?Q?rj+k107OfyBNWAwP2REw+N9YjCUPqqRasGc+IAiySvNk/7Eeg+CdC6cGm5Jl?=
 =?us-ascii?Q?dKVrEOhj1D1E8aDgn8lO+AIMwlYwlRx53WqQmSuEE+chinWqTRkfXoqWvWLx?=
 =?us-ascii?Q?YCzh8F+TXyI/d3qrmGu8w4B2NGHWDAyWXa4/PTwhCXhbsMj07NKvOkkVua4H?=
 =?us-ascii?Q?ovQmnFrLWwXCg3njKV62zUl7/L7QsZhOQSlTS90nWt4PPi+M+UteLms/D2jz?=
 =?us-ascii?Q?y1v/9W2Ea27gfcLhhkK2R0lSR0SpvHT9YpuKP7IvhjGtcYTOfb4RpprN6Igy?=
 =?us-ascii?Q?5wNLpT/VnCY3ZxsacAbawDZW9wqefdqdU+OFLx2A8gNHjYjnFDQ2ETI+oL2j?=
 =?us-ascii?Q?MxcMdFA+cD5+HouIGGtv+tR2Pr/0txh9idxyqVYEaVwnMRQZyGeUdLKki9CF?=
 =?us-ascii?Q?94cR1c4EfRg8pffRxfoooKxZc0DVRlI+WjHAGcaM2wTStt/WSAK96TVjHcuS?=
 =?us-ascii?Q?iuuP6kw1YXkEo01vqHKRwIynYLijkQBmh2n1IslgLfG6D02DXxfv/YmiI9BF?=
 =?us-ascii?Q?dsbIYD4jssvtkWCwIUJxPySoxSDNUDH15J8pjFsjDM8tAcNw2/ghvBvUGjde?=
 =?us-ascii?Q?ciaGngpOPQcFidPzOwCLONYfdJEmPqa8+uVvrDr/IlpzOAST3iwKHQ=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(4053099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vdDuU/vEL+uGI3pu8UIaTyo4tnmV/I6+IEtfhEyNRZvZeDXWgKXxpcbDHyU0?=
 =?us-ascii?Q?lkDfHohE6F1QR3iNVInwSRrvBZ4FXcfv4HKzVvAKO/tTEzH9paZE7tVtXpG7?=
 =?us-ascii?Q?L82w9FuZgjbieX6cuRTPQQ6kcFQa96QzjNY5OtO+gExTOC4LlBzJdHxR2LII?=
 =?us-ascii?Q?29AsTNMLrksH7h8+t1U0Cn/JAjOyItOcje60mGJT9mdBE0mJavA/a1ULJwbI?=
 =?us-ascii?Q?E/58liEjmn1hUMvNOFetC79vZKgBa82jZTlo2S7tIZAjATt+pxhP9+aaPgXF?=
 =?us-ascii?Q?XaqUNuZLJkpWrXUbniNh8E9GAfDrvOaExMs6usnvfRkBbg3Y439yCFmJKKJ4?=
 =?us-ascii?Q?F9yXGyRKn8FXn9Swrs3QIY5JeOxhnaCPbQI8kg5o4/7d+bvZDagnpKPpMFmr?=
 =?us-ascii?Q?kstEnR+AGsJ5mM7/6FKO6h1kbAZeM1DsTS8zSLV4I1JMhx8hxmzYXyYjrRT5?=
 =?us-ascii?Q?sthES0u3gmyw5Pqn+Q77J6s/I2Ly8lRv9IpiOyMpjeS/3yw/kis+Hof0X0a/?=
 =?us-ascii?Q?qic64RUtp+Nq/iDwcLc5d88272snedgM3xZAbIVRl7tMl/031UhWtloW6KoX?=
 =?us-ascii?Q?YZsl8UZhbtJVdIqzz05k29E7aEZ70+7/t156kIrtsrF1XfxDvGQdRbxPl6uB?=
 =?us-ascii?Q?m5Uo56bgocNCWASd2jefVMHBYJPX3XvvSHEsnaoeIK/Awq4JDy+dM9OsTm4Z?=
 =?us-ascii?Q?djemvL7wb+OK9DKYDIx4tlkYwb7oqOodG45oB3xvfq3iEsxqfYSPtFpVRvUM?=
 =?us-ascii?Q?x4I7qWxFxS0oD3XXqkzX0SSFJ+0beF1phsMrJ9TI5XFPBDJC+JAyyNfACGSq?=
 =?us-ascii?Q?WzWLPNHf8mnU4AnGZgkMN782QrnlOX4WHHBbj8SdFuPfWm/aR4iNDORKMWku?=
 =?us-ascii?Q?+Ip5RyKXM+wmDXWmwQE0qzMrrDJmIc6jP/lWHWK2jaIBHanQqtvAAqvKugmo?=
 =?us-ascii?Q?xCSJDWwzesMHWkc0kv0/mtRkgz+sysftEybnWxlHrlO+NwNreUN2DLbMRsNg?=
 =?us-ascii?Q?COtsT8JqTFj9NwqSbJnhbGopLjRrY9qb79erDnnKxxBxsz7orx+Ssu2cFqaD?=
 =?us-ascii?Q?y/ki9QiIxmR9PwE5oTvhlQ46/lLw9lVgDU9fvSQFM7CLtUS2MoH2FN9DVzP9?=
 =?us-ascii?Q?UHin+6j9ooRbJYANVKyMFeXvSQN0vijy0MxT/5SLwlz2cuxqPYhT0OaEmKOv?=
 =?us-ascii?Q?j2MO7CtMKUNpJ7/mPXPsLcPKhMFsd5r2blOxOnkd/7c+g/HYQagkeCtWdnr6?=
 =?us-ascii?Q?EpxjlS92B1hfsqUBxXuGmtzguZjJeUyjVaoZk0hMmiN7fIxyeXBhB6itjN0d?=
 =?us-ascii?Q?RIP1PA3yzKPdiI8/nqFh6Bce6/d/L44mPFQXZO5KCjj2Mf1OXr3i1xjoNDhh?=
 =?us-ascii?Q?2CrOMtYv5zaPQTa9Mm/WrsxApdMrFVMbbShjE4ThfBODfLiNjddZpYBF7TGY?=
 =?us-ascii?Q?Bti7iPqZzFafMsd1XWcP+fDptVT1o2Scv++nAT3CV3s6v+aJ+OCwXOiAiWq9?=
 =?us-ascii?Q?uKUQFg/Hv/9h4qhTwGtVHLuaun7XTZ+aKAGP4KDWG2NX10Pt/fto5mXBwbHL?=
 =?us-ascii?Q?qmbhbbk1T5/405GveTwPJYvYgOS4J8rvsBTeTOZrT43RrHuCwHYeBoyQGaVB?=
 =?us-ascii?Q?9g=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eed82b4-6ff5-4be7-fe89-08de38bad143
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Dec 2025 13:40:16.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9MtPYlCD7t9CgooeDpUqobsixo+S4NVdBO9zqUMJnE+/gaQc9vk/2nc2FpFKX5U31pPElBsi9fQAzDQtVY7RJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8527
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EC1641C0004
X-Stat-Signature: mjn48pobusa1xw6cbqaewwmhugzqux51
X-Rspam-User: 
X-HE-Tag: 1765460422-837353
X-HE-Meta: U2FsdGVkX19jjYSZ8qnUOvfNC9B2+r19bCsGfCGlq9QJuJUJ6bC8D33V34e075FVoDVq/K2EqWKVbeQ5Ol9bQpnM9tHeAZvVhb652+Padw9ED6GySHobU0IuNlRZwvnBakRmvUqqFvgmCTERVKu55RgwandmWc7VUs26nbUsdTCbItIemOrqQWfkWongLZkfzhoSvfBn77lMzs9Wa4Z9K8pea/CiOxlMR78pCToUmYoVND0f9Kcr5cqufwzui7C3HfrdKVR7FB/nsql9dx41kxDQtePbGnV3KBNejyN94LVZgJAWsGh89fZP+z4z+o3nBLuLaFiQXs74h/rv7r/5AIbKg4MqE+T7Bp9KOQeWX/mgIRf3/q3Cl7V3bNv1WiNMCUPB4GaiCcAsHIYINzaXJ1z/6vjMLb8haY2n+DADn6jcazTpofAS2K9lh4hU7t6u1Ve5Ukwr9fsp3/VbjC2vkd0NyflR2LM1vzyJVZNGbUWwRH7FOhDrF1gvy1qcAGIb8Ef0nZDcYtUtYPpJ/ZcROY8h9AYZVOC608Ntt1MQwVlXxT4SaUaayLiS9hRpBQCsQAdw5zgXuuV9Z0zhjuCwdyxHHnCp8DvtcyY43ZPJaG9Ub21yZQw8qez678hHWAGHvJEEEKJ/d7duftzWyADSmHBOXz9ThRl3SgfR3B0u4hB98MJCvTCqKKIbI6YAsoxNXwCeZ6XhfJLs83Q5cAepRs4LkpJZ4CExfYJkvkNwZRK42xnugeP9IZg6ayaS4EIyZDWvyvuD+EcXYzH7XjkiQooWRYuGdLcwp+fIYG4Jn4qnKuXhCiGnlTDoveUYVQAeCSC1p4QDA6MEgBvr7U/lwZJsEWeAp8G16gVV6E11gC1eioeEQx2pSG48UQoBK1vw2OPTE5X+VLWJN4Uoki/ZY+zXo7f5lY6rRX994npmkwYKv4qF6+Pt9VWHJoRjgTFb56XISPHYs/UmofYceUr
 c9xRMURy
 q4I2HCjs3UyPMApMB2N0ATGPBq8u1dKQSDnzNzVftTHxjG/XnpTX6qi+Cv9b0lXnjWZlcjVvNqtMCvbSIWoEnbaH66yAN4Xht5m7DW7EtvmaUUPoPiQ6/u4AOQXHotsPeu/Cqr1W3WTEpwGA3TCG6FC5K8mG5fHD4Nvkt8OuYx/4Y+QyZzVegG3OjZQV6BgmojrgF6QTa4SmPNGderJW9sSl5pwkWwDMCODmZvw9r4n4AZ+MMAq5bQnsZksV/NJDvXckJU0yHuvhSzFlb6BGkF9EC8EQSo3hzS0W+cCZJ5vXUxdL3DXjKJ99TN72t7tKsCDbCPbUzJzN7qNvyLxGBe2WDFGp8dC7nr4iFj3c4B/Q7yPHYSnv/7/isXh/BYsor2Zwyv4sPgSQ5UahtlpQCXfBHoJTgDAB3OsmpnbUtKVwZlxfaibkHW+l8VW+LbVAOuxRP3/fxb0KA9ei45CzMNoeYH4CkQoQPgdYC14U7FU+vY3g34lu4amIKIo5zxLGpwwdd5mgIRPQtcfn7Z2rlMv0nurhRoOSyJ5yPZoMjaZObrtaw65cBq5CklQIGHSjJhGoUH3X/qYol4r8vzTeyFg53H5rnfQLPyb9FRyOJ/Gcf6bgrDioB5g8O7kk2gYQpGH0U4dWEALtrmzFVER0CWd9ZA/O4dAMZa1cH00PTplkaD4OBEO7tqWTsZEdSTulTOtaTfKk8nDx/MrCK3BSNP6pEiEI45z81xqjA9FWCAprRp4imgwUMCwuPQ/7xwLIt02Ft4gzXRBMuxgoEDHCEAwd262mZ5Kciz8sqin2U/OHRpObbLqKrNFe6X/vmMB6cHnlIBDP2LxrumXJrzJHjDm39NPGqeifV7N9RCdsYTu4bijw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--mkTGuLlkwsdkdHXv
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

hi, Uladzislau Rezki,

On Thu, Dec 11, 2025 at 11:09:43AM +0100, Uladzislau Rezki wrote:
> On Wed, Dec 10, 2025 at 03:30:51PM -0800, Vishal Moola (Oracle) wrote:
> > On Wed, Dec 10, 2025 at 02:10:28PM +0800, kernel test robot wrote:
> > > 
> > > 
> > > Hello,
> > > 
> > > kernel test robot noticed "BUG:spinlock_trylock_failure_on_UP_on_CPU" on:
> > > 
> > > commit: a0615780439938e8e61343f1f92a4c54a71dc6a5 ("mm/vmalloc: request large order pages from buddy allocator")
> > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > 
> > > [test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
> > > [test failed on linux-next/master c75caf76ed86bbc15a72808f48f8df1608a0886c]
> > > 
> > > in testcase: trinity
> > > version: 
> > > with following parameters:
> > > 
> > > 	runtime: 300s
> > > 	group: group-03
> > > 	nr_groups: 5
> > > 
> > > 
> > > 
> > > config: x86_64-randconfig-011-20251207
> > > compiler: clang-20
> > > test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G
> > > 
> > > (please refer to attached dmesg/kmsg for entire log/backtrace)
> > > 
> > > 
> > > the issue show randomly (~50%) in tests.
> > > 
> > > 645a3c4243473d5c a0615780439938e8e61343f1f92
> > > ---------------- ---------------------------
> > >        fail:runs  %reproduction    fail:runs
> > >            |             |             |
> > >            :60         50%           29:60   dmesg.BUG:spinlock_trylock_failure_on_UP_on_CPU
> > >            :60         50%           29:60   dmesg.RIP:_raw_spin_unlock_irqrestore
> > > 
> > > 
> > > 
> > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > the same patch/commit), kindly add following tags
> > > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > > | Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com
> > > 
> > > 
> > > [ 1046.632156][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
> > > [ 1046.633368][    C0]  lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
> > > [ 1046.634872][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
> > > [ 1046.637019][    C0] Call Trace:
> > > [ 1046.637563][    C0]  <IRQ>
> > > [ 1046.638038][    C0]  __dump_stack (lib/dump_stack.c:95)
> > > [ 1046.638781][    C0]  dump_stack_lvl (lib/dump_stack.c:123)
> > > [ 1046.639512][    C0]  dump_stack (lib/dump_stack.c:130)
> > > [ 1046.640168][    C0]  spin_dump (kernel/locking/spinlock_debug.c:71)
> > > [ 1046.640853][    C0]  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
> > > [ 1046.641678][    C0]  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
> > > [ 1046.642473][    C0]  __free_frozen_pages (mm/page_alloc.c:2973)
> > > [ 1046.643279][    C0]  ___free_pages (mm/page_alloc.c:5295)
> > > [ 1046.643956][    C0]  __free_pages (mm/page_alloc.c:5334)
> > > [ 1046.644624][    C0]  tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
> > > [ 1046.645520][    C0]  ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
> > > [ 1046.646384][    C0]  ? rcu_core (kernel/rcu/tree.c:?)
> > > [ 1046.647092][    C0]  rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
> > > [ 1046.647774][    C0]  rcu_core_si (kernel/rcu/tree.c:2879)
> > > [ 1046.648439][    C0]  handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
> > > [ 1046.649202][    C0]  __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
> > > [ 1046.649919][    C0]  irq_exit_rcu (kernel/softirq.c:741)
> > > [ 1046.650593][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
> > > [ 1046.651520][    C0]  </IRQ>
> > > [ 1046.651984][    C0]  <TASK>
> > > [ 1046.652466][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
> > > [ 1046.653389][    C0] RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
> > > [ 1046.654391][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 e0 f2 7e 86 31 d2 31 c9 e8 e8 dd 80 fd 4d 85 f6 74 05 e8 de e5 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d 2f dc 6f 01 0f 95 c3 40 0f 94 c6 48 c7 c7 10 f3 7e 86 31 d2
> > > All code
> > > ========
> > >    0:	00 44 89 f6          	add    %al,-0xa(%rcx,%rcx,4)
> > >    4:	c1 ee 09             	shr    $0x9,%esi
> > >    7:	48 c7 c7 e0 f2 7e 86 	mov    $0xffffffff867ef2e0,%rdi
> > >    e:	31 d2                	xor    %edx,%edx
> > >   10:	31 c9                	xor    %ecx,%ecx
> > >   12:	e8 e8 dd 80 fd       	call   0xfffffffffd80ddff
> > >   17:	4d 85 f6             	test   %r14,%r14
> > >   1a:	74 05                	je     0x21
> > >   1c:	e8 de e5 fd ff       	call   0xfffffffffffde5ff
> > >   21:	0f ba e3 09          	bt     $0x9,%ebx
> > >   25:	73 01                	jae    0x28
> > >   27:	fb                   	sti
> > >   28:	31 f6                	xor    %esi,%esi
> > >   2a:*	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc5f		<-- trapping instruction
> > >   30:	0f 95 c3             	setne  %bl
> > >   33:	40 0f 94 c6          	sete   %sil
> > >   37:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
> > >   3e:	31 d2                	xor    %edx,%edx
> > > 
> > > Code starting with the faulting instruction
> > > ===========================================
> > >    0:	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc35
> > >    6:	0f 95 c3             	setne  %bl
> > >    9:	40 0f 94 c6          	sete   %sil
> > >    d:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
> > >   14:	31 d2                	xor    %edx,%edx
> > > [ 1046.657511][    C0] RSP: 0000:ffffc900001cfb50 EFLAGS: 00000246
> > > [ 1046.658482][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
> > > [ 1046.659740][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > > [ 1046.660979][    C0] RBP: ffffc900001cfb68 R08: 0000000000000000 R09: 0000000000000000
> > > [ 1046.662239][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e35f50
> > > [ 1046.663505][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > > [ 1046.664741][    C0]  free_pcppages_bulk (mm/page_alloc.c:1494)
> > > [ 1046.665618][    C0]  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
> > > [ 1046.666374][    C0]  __drain_all_pages (mm/page_alloc.c:2731)
> > > [ 1046.667171][    C0]  drain_all_pages (mm/page_alloc.c:2747)
> > > [ 1046.667908][    C0]  kcompactd (mm/compaction.c:3115)
> > > [ 1046.668625][    C0]  kthread (kernel/kthread.c:465)
> > > [ 1046.669299][    C0]  ? __cfi_kcompactd (mm/compaction.c:3166)
> > > [ 1046.670046][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> > > [ 1046.670764][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
> > > [ 1046.671483][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
> > > [ 1046.672174][    C0]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
> > > [ 1046.672936][    C0]  </TASK>
> > > 
> > > 
> > > 
> > > The kernel config and materials to reproduce are available at:
> > > https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com
> > > 
> > 
> > Hmmm. This looks like a race condition tied to reclaim. I'm assuming
> > we fail to allocate a page and kick off kswapd. Then when we fall back
> > to the bulk allocator which tries to remove a pcp page at the same time as
> > kswapd tries to reclaim it. Maybe?
> > 
> > Does something like this fix it?

below patch is failed to applied upon a061578043.

since before reporting, we also tested on latest mainline tip at that time:
[test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
which still can reproduce the issue, we applied below patch upon this commit.


we found the issue still exists, though the rate seems drop, we only reproduced
the issue 4 times out of 100 runs.

one dmesg attached FYI.


[  448.229620][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
[  448.230037][    C0]  lock: 0xffff888807e75f08, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
[  448.230474][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-12693-g5c827f68ce27 #1 PREEMPT  b3721ff206516c93c37a896ae4d3df039c2d04c2
[  448.231106][    C0] Call Trace:
[  448.231264][    C0]  <IRQ>
[  448.231403][    C0]  __dump_stack+0x19/0x40
[  448.231627][    C0]  dump_stack_lvl+0x36/0xb8
[  448.231842][    C0]  dump_stack+0x10/0x38
[  448.232101][    C0]  spin_dump+0x11c/0x1c0
[  448.232404][    C0]  do_raw_spin_trylock+0xe4/0x138
[  448.232758][    C0]  _raw_spin_trylock+0x1a/0xb8
[  448.233104][    C0]  __free_frozen_pages+0x750/0xa80
[  448.233456][    C0]  ___free_pages+0x67/0x140
[  448.233765][    C0]  __free_pages+0x10/0x38
[  448.234066][    C0]  __tlb_remove_table+0x16a/0x200
[  448.234412][    C0]  tlb_remove_table_rcu+0x77/0xf8
[  448.234771][    C0]  ? __cfi_tlb_remove_table_rcu+0x8/0x8
[  448.235153][    C0]  ? rcu_core+0x8af/0x1740
[  448.235456][    C0]  rcu_core+0xa25/0x1740
[  448.235751][    C0]  rcu_core_si+0xe/0x38
[  448.236038][    C0]  handle_softirqs+0x1db/0x700
[  448.236371][    C0]  __irq_exit_rcu+0x44/0xc0
[  448.236678][    C0]  irq_exit_rcu+0xe/0x38
[  448.236968][    C0]  sysvec_apic_timer_interrupt+0x78/0xb8
[  448.237382][    C0]  </IRQ>
[  448.237588][    C0]  <TASK>
[  448.237798][    C0]  asm_sysvec_apic_timer_interrupt+0x1b/0x40
[  448.238214][    C0] RIP: 0010:_raw_spin_unlock_irqrestore+0x6b/0xb8
[  448.238575][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 60 91 80 86 31 d2 31 c9 e8 e8 b4 86 fd 4d 85 f6 74 05 e8 9e e9 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d ef b8 75 01 0f 95 c3 40 0f 94 c6 48 c7 c7 90 91 80 86 31 d2
[  448.239787][    C0] RSP: 0000:ffffc900001cfb48 EFLAGS: 00000246
[  448.240187][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
[  448.240700][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[  448.241230][    C0] RBP: ffffc900001cfb60 R08: 0000000000000000 R09: 0000000000000000
[  448.241758][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e75fc8
[  448.242289][    C0] R13: 0000000000000006 R14: 0000000000000000 R15: ffffea000cee6410
[  448.242840][    C0]  ? _raw_spin_unlock_irqrestore+0x58/0xb8
[  448.243241][    C0]  free_pcppages_bulk+0x4a2/0x500
[  448.243591][    C0]  drain_pages_zone+0xa5/0x140
[  448.243936][    C0]  __drain_all_pages+0x1ab/0x240
[  448.244277][    C0]  drain_all_pages+0x10/0x38
[  448.244587][    C0]  kcompactd+0x61f/0xaf8
[  448.244900][    C0]  kthread+0x586/0x678
[  448.245183][    C0]  ? __cfi_kcompactd+0x8/0x8
[  448.245504][    C0]  ? __cfi_kthread+0x8/0x8
[  448.245815][    C0]  ret_from_fork+0x24a/0x478
[  448.246138][    C0]  ? __cfi_kthread+0x8/0x8
[  448.246453][    C0]  ret_from_fork_asm+0x11/0x40
[  448.246795][    C0]  </TASK>
[  693.283069][  T328] hwclock: can't open '/dev/misc/rtc': No such file or directory
LKP: ttyS0: 289: LKP: tbox cant kexec and rebooting forcely
[  701.346273][  T289] sysrq: Emergency Sync
[  701.346778][   T10] Emergency Sync complete
[  701.347270][  T289] sysrq: Resetting


> > 
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index ecbac900c35f..0d1480723ddc 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -3634,7 +3634,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
> >  	struct page *page;
> >  	int i;
> >  	unsigned int large_order = ilog2(nr_remaining);
> > -	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_DIRECT_RECLAIM;
> > +	gfp_t large_gfp = vmalloc_gfp_adjust(gfp, large_order) & ~__GFP_RECLAIM;
> >  
> >  	large_order = min(max_attempt_order, large_order);
> >
> Some thoughts.
> 
> That trace is not easy to follow. As for this change, probably it
> is worth to go with anyway. Because, if we are under a low memory
> condition, it is quite common for Android devices, we do not want
> to kick frequently kswapd without good reason. We have a fallback
> to single page allocator.
> 
> --
> Uladzislau Rezki

--mkTGuLlkwsdkdHXv
Content-Type: application/x-xz
Content-Disposition: attachment; filename="dmesg.xz"
Content-Transfer-Encoding: base64

/Td6WFoAAATm1rRGBMDkeuTnAyEBFgAAAAAAAFxz29ng8+M9XF0AMphKq3yQpIRa8Bmjth2/+3P8
Am7Elnm8EXfRv/hgypFIqAaZhJaOsYovo4xB+ZYOZeEbq6rDokcDPfFpk69x/61MngRKODKxqbQ0
11RMejw3F1+ZmGhzP7orlO8ia7BEuta9Ojzn094zntmM+sQSBJYr6R1HfBCLKrn5KxeyfvBuyDgm
Ek0q7Vc+xJBM27rnsz4FChv1nuFi1KhatbhwPSdlWVw9Kn1WCoFHtqmKgCo1F1b9MFgNqS/fKamf
NPsT+YERi+4NFLG9qZN7Z6oEs4bJRFnPkxunIAPLpOtZXDBdoR3xH0KBSsWhyKzu9WY80cyNWPT0
F32kLPXNx7P7SNHIWyDOuoZZ/80aBCNfQ5Qxh5uhT1NFLAH7UFQo/dhavjWhGNkuf/Jl13t2Riw1
NEPt32/Jx9GBNXx8HxdWdcyDkMNhVruE1CyZsohLDKliFgmRi9Shw+BVIjvgMQ2f21U8u2spFcQw
lCN25/hQYAmySTnvSAz3eetgaJ1tnaEdnUFaNbYKxBDGoouMGl722JNkk5i7ZEh4XJPt19Yfq4z2
B4ZlKtF2Zr94jS1Rh+c2LWFuqPaQPV6xSwGTBiWscS/uN/Z9UZAJE8q9fGgDwP3C35LPDfHtCWMk
r0MWeq0/HNz5nLYSIVajjR2f3bGIg01ThIXcOP0ZX0ul5k+Re4xkN6txBFq0uPC/BhWVEAg+PZiR
CZha7xHeUB4RSEerSeuapGOnEq16Bv1vc+kNwKnxGc9uS4eki/sQnH9usmCVHITqL9q/jORJPN1e
blMXamJiG0GYzhM8HfHcYtlgtL9+62c0dQKn9AoA26BGZM5uSfP4WtDqUlQHNppDHaS5NraYhzly
qiKG17JBrRVr7knuhzNuiLPm98kvO53mao2aJQAPEl6q5gr1oE4hyxMbTDkb/t0z1N9lOxtyQ7hS
EQ/V3MmCx06lEvSC17ThMe+sDnnIe4FXNFW5rX9PUhE9fgruBJiT4MOim8NWNPhr/LnLNbOvSBsF
x7DC+6qlRQaBRoTpghCjfvOXCmgOVpC7xcQ2qGSRfqAaD8uPRZvo7/K6Yv6xgTlT4kFBu1OfpTb3
iGifdoje1ypQEqfOGf3qmUqbShvvRYy4ldJqdScrSLh2Wj84x3JrVJNBCFkGQWAXd/+gQsgaM+g8
bW5phxIA8yQeWpE/TkhPuAJSOR4qw3p5UDSL8NbsOaQ9geGB9SVF/S7AKIt0eAF31jPhUPUNgpMA
0AzD6kGH533Hh+NldTJEIFVzHL0BpOgVHPMFk1JzkrTmFl8Zlvg30DPcCTKNS0cdXDF9OLXiJK53
Q5C3EwrQNbjmVv+2PPyFBsHK/ZDPhhY/C1SFCqmlh0Ub7rbrOqCsBpoDT0TV6Vbloa3WJd48Z77P
1TUF2u4jvt0iIoNhx0UNSLRQaYXmsuqfLK41t7pycMSvqOopA0B+ZYET+dYx5GdwPKwtbFinmAWr
blDYDZLW+l3pQ8OuwEXgYS2PaiLy3UXo0zTXBl47qWKYluMHqo9yC0BurK3n9kw1c/P/Q3WXtOLp
/CPmCfM2X1NUl8UM+A3CWD4kmNBE9GV1z5L+V+X+y3v3eBSY5wWRb8syqyI3hF0gIn+hpCD3dObs
Kp3RRAAFwPxtW/4gn2I9faw7P/H/UATyy2WkX7FTAj3Oizk6WOHwV96MJc8H3zatsL21EcvL4L8u
wTyR2pjG8lpqvcmUHo6dQzSpM+GS0rYLbJIuji9yGcZVHDFRDCqTtmIjFRj/Nm68C1PBHXP/YCHl
YxBESIZa9j/JdMZzPrivP4j4UVvmc5Kn4DoB0TfMjkvVLBPZEdYicZ0vztDOJWN/e5fhTVsx4QVg
fyVufAXgGQCuWtQERvFoAa7VE5DlnfSQrPgXr3PxgpATlGA6ofen7UCKdq1Kmz0mv+AGvs6piSCV
3S4WV0JJ4yt3ImghL59m9aks7bqoZwjqcJsJOvBffXggP0SykQf9SxYH11DpEhbmvLVM6apNuTsM
4aNVuM+DzN48x8VBLuBbwBh7/MMMvZo7Q8lG7CLy1SKUWgeGiv/IenD7OVnNgs2Rt5MpVLX9ciCD
WqgqmjjkOTI0plFE1LeKezbsVrqQye4+RzTjRLAxvjRgkB9r12A0b+ogaKRRLai0JlKsbDV2cwc5
kFgSuHIpOtCfKLgL5mTOEO++UoK/fwf0gdF1JuCqDdP78F5Oa1ZGHmgUe85IjMf6q3I57o80W+io
y7pNQOH2ZWvziDkdBCCaeO6TaITM5m6wyBPgYgFqMm3wb6rA3adhOd59gYyzErNL/BPRchJwyEzX
63jhz/5Gp4RfuVni6LZd0N/1mpJu3N+Xp8GWYfPZ10zyoxJ9CVQHH0nrtTNZkpJjxTSZrr5+mYNf
c9WT/yTP+gSJjKpYGK2ytAUkhGFEIi9a5jrTf0w+OhKQP31hl9sR6StOqxkKwQ9utZ0hOVaBPoRj
ythf+DA+C2pxzbgpWZlb1YJPFJEPCDWof5sgsY+ZDaO3ucjXZXgB+hXYxFMBUiGC92icRzrXHYZP
Mm4Y7caNirCEzzp3caEh4eNVpXgGquxKr1H1biygunq3AWx/1NsMsilmEoBj1kdgxpKhcQbvVFdm
nHHyhhmCplF7gTUPHabMKPKylWF7ACz5VTyhpzZ1mVHsGme1aCtnDVboPZyPT9VINMz6qv6HPiBI
US+6ZvBiYQfvXO+u867//bqf4FQR9paehlFBG/cbcItLaEWIq7j70TOjnWA06f0ojtuJAF3jLmMk
aQ/PSMlz/A+1Ziq5c+lPYss5abdqdt0LNvlrvbnwPwjVRHS9O8BltVblYCtYP1HPbwCoTvjKcaXH
HnMAQe8FIkH6707QQT2fVJhbdo6YLDRyWFYW1RptCZ1zPqFxK8++YZZp8zcruCLD3GWL8kaV7Qim
RMmOY0WqNomHXPfZxy0wMuRDvf5pxGJCoMs4EmHlYtnApavYXF3/U/7ViaHKlVh3N0fQdvd5oV4C
NGg902FMsXKIgRetnXvYYVAE7Uits5OUf1LeTspc/FDIpsqpE9dsPxjh2ZP5sWJwB7q5FTkOl+a0
yv25msEm9YzgLmRb93913UynNYg9ITVACGehZ0nnR3dfjjryGq25hBEnTcij54UegaVp+1LthaoJ
XKrhhrJg+zD7q/qlLa4bcue+ijpqacIM77XiAfMyjxJgUlnZeP/GOdoDLDR/xn75V8Cm4szom/lM
P3l4YXYv0KNPgQXcoCm+1J1LwP3vFRMVoAcXC8HvGvp7Daqo/hpwvax5djYVbiKG/Cekd78ygR2U
BvcrfIEy5JZVIxBNdW/l6VA191hMqrf+IZzDFMnv6dXZlkiwLatT+CeTyNtWiVteLGroar8/j6Vz
ZiWyPUBQqrWMp52sgtfUi38PlO+wzL8YeuruKRid2LbwxL5IIym1F208urjNnnwMzO/6FGy0eaqd
weQTW3l309xYVjPpWAJOEqQyjsHIWIxp6hsMzBsYBkzR5jU1lZsdGSOEs2QXrSiaUoudUKG78Mq8
FfDCmc/27nVMUjU6DEGs6Eggg1afC1PQwjgD9/akaEVdpznyVgP0K7B0LxhmzI5H2R8vzGBhtG+a
/YNvVrxpXSj3N6RBJdbQ0VoCKXko2flYWu9amEwufpL0RFtgVs2UcBdYyaj5fWrSFqmv50TPkF6+
VoM6bi9KzzPCIaQajYUG6lhVeQOjGZe1RP8Nshn75cR6gqso+zDeFai/cLVQB8BT/ca9nzAXhXWK
Fl6Kdgtb/5WfLVyMRIebfRU2NPz1OlZAZlEEK8iwlPjnzKcWA3D4zL3k/LQlpQJdEeCXy+S6CqXc
WCNPV4ZTWMmTHzohygCSr4RJctgSdWR2kmYTahmzon0FdhkZcATnmE+8beSKFidRVFrNPP1yOuTr
VzBxczZpg72N2VVixh98a2RfBbNFWOuyMnWUxC+XBIN1ojOeDJwTduQlOrwmyaEXANL+qNRgW2Pt
hMaSkdjvhZz8JSgWjvovUZvdJk6R9Hcp/gLX+7ZWAK2GHRE7I4esR1YlFGSt733R52ZyQExrP4Xj
JG+zSCy/a5bEld0X+IS1uASXPrqd1P/LRtYp64Eu0g8n56QtOQG07bwHRYO98qGMQQqGuIQaLHkx
+zDw/Gda9DFQWFVgZ/GsEJzBOfWp2Xj/OVZssqk/SAD6FfzqM5S/Ev6QFshB41PCeHgz2eq3YNgs
6bEdxar50txlr9S9z14okpX76tq2GYRYoKCS6xIDlD99XGYTotJcmmaOOcNZEjblUF11MIsstLFn
YLTuKxBA2oujW1AizjRDz/FI8OGwFB//BZAuyfM1/BbFqBrgDqHgeINBswra5GYnP+knrUfgJV+P
oynNBYWO78knf/czR8i3hbNNKgfuM23MBo3TJcReH1DTRp5gm+E8lJSOAOCLsQIhbWBD5x5d465H
4wY5K207WQ3gcD8DKC4F9XAEBlmxbF2Py2ZFI16XXA18q7UQK4NEEEJY+Xo3gtrXGL4ZwKZ/hvl+
VRo5/wnCdpCVDmU6rLvgOcD0/f/JKtSBgYDV87UAmNECJithTYQrNXMe6pxfKI6JXXT53Me96HOj
4E4BudlYQKmtnz/FCMlRaG903MnxGbeZkYVaRPk80emMJDaymEqxhi3L9/FwR6Y/ys2pC3uEYX4W
owKW4VCFwRSGAU/f9ez8vqlR1SF1ltdpnwT8Rwj/NonWBmDoHlTqdmBXptqoNxqU9kKXNRWyUChw
CPI2RAQrpMp0Gl/LJmWdIS2pv33erY8VSiJEbG0r48AkqMDFhtx4XiUiO6Ac9nyiZhUBXlNoMv44
GsfTeITgqCQGTQDxY3fhXZkZjEJM6CsrVHSZuKYegNRPrgzhvxjQpWAE3mi0oM58eUIwaznkCO2S
tMJuowsiq2uPy2T7k0gGeWWGsrYq+B6/mp87/pugf7hs1FCXb3WA8wO7p2mTtbBGdnNwK0iktWOX
W+PwddxXzswGIKgwurgJIhZ48AmSpnM4CiSzOzpTYCl+DVGj6gK0r/Gwy+oJKZ1hYosdIb2lo6/V
Q8AJQHrvSuPxaVy/4ZqG81csYx2Tb2ryvjg5UuqCQV/2QTPpEnsofRVd1cih997Dk/YipPam9O16
MjatttWPhk/A0iM4CMD8g8dpjkUYLGwp4t4gd+PZIdh89NUSmZ0lodbz/YgkquxPyndJleFQ/LAf
tKy+7n+UCsTH6T62WFy6OLtbUAxPb2zwecEiOM3FLZykgG0j3+Oqll0074MNppJL0s7ldK049jsU
2bL4m9OaIIqd6vD5ciH5Ff4ICSmfDOTHMzoH1BUZGatvqrqqXWs4fp/FGLsZDZimymcd1LLHE0Ee
O3whm4GB8DDDw1YqHcAZgWQXccSnlnWhl4/GVktkAZnMwJajTeUr11q9cePA0aCU5RZcopg/2Z2/
OD0PI2Wt/g0O3JNclueSnnbE4y7fdFlsvgi0BXsxqcFajn2G8FqNRYBVnXoLx+XQUg2VOc3Vtplc
SmzEcnxZqSMIAVFUE8FdvJHKL2o+gN9a5rAtPmj1+C2dQZcbDTiRKN6mzqEhMq408wsrYRSw5IsN
aBH3NcDNQcotvY4/muLPOKypwLfyvt4YVRWoVnI8COvqBUZxhQ0Qhb/MWGpoJOt7HKMuyuKt3lmR
PML4NKrF5L/dLZrDjKKPSQMvnxd6KwpOK269NyKz28ZjMNSp8KvVroJJ15ITfnWYIP8WQ2Grqt7B
lHWv0uUPTQ6KJktcx6AxARFqvRQolYfQvcTD/70kvI1eDDmUgToktTeKHXIgNhK2ssqORhH0AAWB
xd7RwBcCmWe3FwHW/lQN1Sr4mWHLv/ZJi7GDniQ6lhgK748C5TzcFNmJjV7rabdV3T8N+zBKBYZj
udGVdDDc2eBHZDOQy4xYwYACnn81Wh3vJGRRqkysK7ztlmpLZUoNVnJc80wMXbpNO9urWLQ/uTui
dSLXtKn635OCEuYPJMun36urj5cQrZo7v0WZTJ9yF0GLLDUm2r21LWHy7NtUbTIrGQEKgUSkwRU+
nb+BqPtCPQeU8QoA1GRaZM0HLPokjNoKSDll3z6FGAuIAfRaDy3isCzsLSMnuq5S7klFIGQbr6Rs
/g8tiEPB9tm1bdc1HoayutWhLYxpHL1/+lZrrj5MGUzloEdZU57w1OpujbBF7MZxdSfVVfpbJIAA
7+/g+5x7UP/Blswq1AUje0sLQtQw36pB2Q+zTV3PNHXHU9ZEdtyr+KvicjKmOqVRI/FmvjGHISFn
h9Ndf92eyK3mC9PGWPIBT7hnNhP6tZWjNUYhpXWIM+ap+4ij1HoYdEorTfpIX1//KySv84lRyVLJ
kulnk1v4re9IgOQqSETK+a/BWRdbqH4EKnilf17fBdwqABkKjZkVTKc5dmC83CGn6L4EJ/hLJVkY
WF2TNdSCCs/Ym07i6YgT1pNfe7/gVjb3N6tTpCOeHSVz7TOHniVtX8ZCh3EOrDNEayg6uy/aym0R
3kfpXWNAbEleZH9t4FrDOJreQV1UGNpAr/aFzcD+QptYIBBW8sc3NxjO1p6hwV9DUC/KsdWLrBGS
d85aiKuZlaA4vRBYmpB54ql+SBNLgCL2bRnKd44n8xZhyrNdBh1lGW//aJA/h1jRyKP2BPq9TqX6
3YfDkP+Uw+PgY5H8lQrZsRf+zaTux12c84ZBdFWzhQWpXhR2ZQSwpq/2Jc8PkyXq9Z5zWvWznTP6
tLYNid8whj0g8YuCsy68qaWlifwDS1jxaX3bwXoUc/l2Ui3bboWyXifWT+VGHTl7BC3UAMDfbcF8
Muc8yrCiw2dcyhCtDuaun3OSIL0YFaNz6NEJ+c+oGgbSL9KF0cQm5gNqrvt9wWI4DYazuL6f2U/T
k4YLs5+ymEK6Ok+CjAQ3VXbBui/uiIvRSsVmN15KO39CUQIc1HlqzM1B7O4mqGrkbUHuBUQEWlSM
K4yC6fsmpIzelo0WrMDemY6l+Unb0SlmIwUMLlcFPa7M0xVBgso5wHYihWZzdSLrpL40jhM1071h
8H/5c7nCLBnUcwc1g8VlrhPDYf51b9PELx9eYir8b9qZBM72QceECBNcxs6+wOPcGBY1wjFgPXsc
Z9vtLEnAMoBb/ifVYLFxiiZvoNvUZHFwiJbiasgOq+Rovrs0skBHLeo2LkRtbzU0EK4768eVhwkF
UheuGB5u6hxZRehV0XV7RBDMx9yzwNTNKbA2na/ZtwoMlGlQplSpgVioM2IIYCwjtB8mxMd2rahm
pHPKojl5+B2fljChDv39fx/kyAysNzQbwlW3Qdvl9r9YIV7bG1PWTIAviJtuLXhGueqy13hw6XxH
6DOfG9ZyUJtvJKpKIPuehL5FoxGal0UwCRCVGaA0eRRy0O6gAed8+c3zcQDA8F/m50qauZevu9qH
ITU5xY6N4KultbYHRqkg+xfN43pItdix7t5m+ILrFQDLx7j0MNyVBCWdRaCYuKeoEjzWzD/G8uO5
0VxiyZOSH5r6Yhs/O2vZLkfE46fWW6Ipy68QfsKb7p5x25pKOXggSuNH4RVjKskJ9ZxDpspiXOHu
PcoaL+sq2ZuDKUqIK/xdCaF8l9yyRVWoZQAHekdSV9Z1AR1vhz0hDFQZwdrEx5o9q7tyBN2dVzAl
6h8PWdaz+H+oqeEpTUuhCagNChnJxabZILZFPUTjCaDXregS5GPGkZsBlhWYRbz71t4vY2Tugauo
BLBp1PVyQcvGw5R++t1uH52n3/SyY/UX8ebRr7rLM2JQHZSQo6Spaci34rkM5JJxhaIH7Godv7dW
XwQxRGbVBCQKoxxfaiNHrP4WjDndy3LlHJkS1fclYwgNZan93MxIVMVwkW+Wj20NOXguhPm3tHb8
GvYi4wXhADXBIXtRbJZPXp2UXIn1kbHIDBuCu5Gb4DBro5HsrSvwYFTz5BTvipMM/T3wnk29bNpE
FU8/tqh+KS7b2UohJW/KSRYpGm6zc0aCBdDYFcRaeomqZF9I8tfKCdmEn/C3ED5VT86htLCrDBkO
KPoe7qSu0ozvSkwXgIDDllmod5C7Rk0VkIev+d1r1zMCO0FTKrQg8oAmExn+ArptVeZu0Wwyo9Or
EHKIc5PSCiiI15/t8iCfYYTELdmiVI7S08hVhTS6+aHzIJgiGyytBqdIj1CvbaplSD8SIOBrCFeI
Ri4cEf1qHnYaW4sUCZxRORpOJcCgN3aAjVOCoGELDuqJInLkHQ+rfi6Zbf0ZgYMvrDENutGAHCaZ
tEXVP5FjnFYypJnCaJ5qP0qrNskK/86y3E8oFfH1/zNQinXiGFskA+4huhU4RWFNkSRPceqdMbTn
t/pkHmNhBJ39bPdPpV78lcdnXGGq7NxlyJJd5o7XlcRxtqR+r2Kb40uFzPNAWz/T2cfZe6w7HLhm
p2eiy6E+YRk7KzpNZ72/JbkE7IenZJdwQBYOMfws8cg8IL1NnFtnxkabYVf2lH6Yuuj5sM4uE7LG
x7qjzIq8thBpW9i98UxvuIEqrVG8UvfRJw7Hysij6rD1Y3JOKwuHhvLIpCUKzE8/yUzC0KOm51QN
jojwMs9aYK33oxySAfguauT8/YaIjqeiVxy6hZsUC+ShTfqwRLVENI61J/baguxU2m2VPJ9S7i/p
oAhBLjKIGBPPWyDgvLqj0TtzpGNsyBAzOIgUWY/ziSHpd8H/zxY3NFwofleo+Sn+bsyG3zqOkBr4
9W8wWNu8XbG9YTlUZG77/UKc17dVrAUN8uGrYCx1Au5p7iFPt4LP2iTRiUftI5GZeur7AOT+e9DT
SMfQe9ESia/R/9TMvYEnthXqjQSkcnsd/vnRm5ifB7iTensDg2s7VNK3e12y1lpKL/GHJZmTpPQ1
XBlG7xkklYnCsDB7jUEtMGXI8wYnFT/VlZ3b1uRyr4SEHH6hzfMFi9+5N0/zDEtj21ofnoCleAEB
Va6dZZRUHaEQvi9VWYpYG1MJkhl0skkJuLDCrDcM0hmUdZNXXrasB1JOBpi6JoOD377opJUBPtDj
IhJVaguBmR61A75YanojTwlcLOBqkM0ZvD2xUStCDoh0gu0HlY/yLWHvJhpuU33fU1udXWsf2a1R
I1f2lLU7sGWCaIism3Ag067Oho8kYM+Rv4Uf1pbi6r7G99nLPiwbMAkqrUvXZAuOAfrMypIP/9Ek
pPYqcSKWm5ZSPNFmxTstJQSN7zXhLreJb5+k7fi7m2cohkJG3hjVsdLH1cX33Vl9zF5aIF+7iu5n
ZhlpceuvxgkD0z1pqEyOVFdcULbo2aoL/swmR1Mv9i8opJStGPhaPdo+XUB9hx2Ey265KXvwNOBO
im/+BX83geiaxTd1IXC8NgxdkxkEre2brEmQmM/jk0ZSD2BPCYhRg6WfOxD70S4ehQmUqjvj6ZCf
n2U5PR59lIVidv6gdjgoebEuF9+R7vwjSQCjzlE0w/53t0nP4tOYQMs/DDu2+S/NKcEVzNScnRpR
jqztpifzjBEdCLtvIlKJx2jB4RNeMdmKDi/vjA+r3bpiF+SBlVnP031DfXUNy47nRQx5DGXY++h9
7bkK/qwYCaC1R2crDSL1P19+BEG5mtuLmWnqe05fiVIOpYa95WKzDJcptojQejuirC++E237+JZa
aQQNsLofIH39NZiZEYL4Jg5Qi87tOa6sL+DYnHCeU0Qf4sm54CFeYKAOlvhZ0gX+geLrb2qWWH2c
Rc8Z5J0U1AGQc2uxJj8+p8Fd2f0Sz3xngAlHYdbZ6AbOkMY/E0cmJ9S9CpvsMpV5B0bdfyVYnvNA
lD/4cnG03bbwq2KUulKWZawtIRkaPa+BMZlYQbZBZTQevjVviGwFazpBlyCAkwHBPRbMjlPnOjsm
CNKvGo9eHdVLd1i47fzMNUgO9nGouOGOVyP9XFDMSqpN/owxeFvLekAwYKFflQI8Ui+GBp6SBVZK
gQyOekm7EskU1ue+08ceZ1kAJvSNvn59InFC3iIIWACc9L+SLUZWhcbee1xZXLQzP5lvIQZlX8xp
USVNehYpwPcu8qR4IV16WYw7pNwrAdMWLfs4oM8+p+VlLI8+lnkCdpJqKsUOqQ7seOhswG4cLTQv
PVZcTy8yWOqd/VZp+g7DRBjRM85fLnf0OZzrPq0Ye8yRp3pja1y7d4pWtnF+GdFJ+qj+6CcQSkVV
czp5t80oSRlgNqAZUHuRqOBJqcnGSHbvy7A2PqDprNpStn6fclMAvCS+mBVgqjLck4XlrvrRBeAk
3dqpskWpP8Gq1lhQTAxzzc6xKnfC/IetEnLTs2RIGUgkmU7fEarv5i1n9IUcuhbxleoqMGY2b2Io
LP2dZFUtMFAvzLLNQDgKqf8yORUeV4GCK2cjaYOk+6ENmjH1rODyL1o99RsLll7O84jnKBu8ARYT
sPM5BneRp8IBorwo+rmbUaujL7qOjvAxMdHnBi1bFhNG5pnYWYRZmO+Pm46nb8OAegBHc9jOQCCL
1ZcLXCtJivI4L3ugyKp0EYsdhViYUt4TFY2delkfIMyzbIeWUFWcUOle8fMH4RqxyBw8BJ4TlDjl
n4CaYmHBt2FJK65HOp6RlMln6MFUfDWPoiabW5POMAOimlxvQiALJ9RPY2tENAhgXjp/ZYPxdrI/
rowRqVQIZ/xFjTz4TLO2pU2NMw3XaLO+yssspDn4/42IRaUprc6oK3CuS+dlyyKGLCP77LnT5F9Y
STDVE6bP/y26cGhCMxEQrKOE5nX6DMEJH4GQ9/vPKyWoEczLUdPVANDuz3zTMWZ9Od6GcgH6jgHU
7c5isiSDif2w8hWK2wRLD9RJPtLIWCZsJ78V1E9NuW+LjJ/KTiN9KSggmythbYLdyKcqa+d1f+95
4OJzZEODmaPoSdEwJexS/Ovy4bXp73AE/Gf8KXR/ROwlYXe5BzFpE8Ko8vFIVBnymQrrDaRNauWU
CU3V4aBd1IQuKfKsSTfm4jI+EofauOM9fiomcG60dmETxqn74PK/o4O27HxXQDQKRokomBQWn583
4UZK74L5z8HAAwyzePQtsSrXl2P2i3HCch3Atyl1ncLv8q40AslmtY9tu87tdaYSbiHzYmk+AeVq
eHGiB5puCUwGusHHJlUQJPpI+ECZlNJFt9k7PdPLAHsRUd/A3tQZNY58L9EO4Z7aKfLH9YP9pUI5
LQVsgF3Ikai4VI7FdJ5XsbNMKEVpTOzZswBXEefrkw+V10G6ouoV0uTLqcma3fBkRQX/xuXOEUWh
Ek+lr1cuC6gE8zb8I7MWTrfKOxi00Zh4TO7PP4fn8grZlVXm1TRV6iAnwMLzx3Dnu0an8o+mq0TK
woS7/+OdDu8r61Aefr5SeEV9rfbYTdhfUDtm+lahE1sFJ0Q4RXIJgpZaECCZCdYOn08bjl6Gi2Sm
ALIWYN13jAy3G7ZYAFbwVk7UCRMA+g2N2wfPY0mm1OJadvpF5ciXUHg68BI3FCVEsQUy3p4toWAk
s8KRfQxiZT3RYQCRplqdTSl5upud1aGTSFtxAD5x/oTs9/8E3rdrFQc18HxrXrsXhD2HaCKOg8Te
lHDvuUL14nPI7/9jvTp4JoOjWnlQIxcGjm/Lb7BaV0JaeNpgfALrwf2OLp8+E4at2aY/zKzLDeku
lnx6Lrs2BenUIWmcHv3oQ/QZPZN3zeVJ9L+gJXfcmb/6d0yoxJRJR805W8nXdOVJaw8GUruCruD4
hdyTrumZaMTstiriWRh4SypRIKvx7gDJ2Po0tiD9yh8g+GyRPdD6npERkrXtOpb4R6L00FtYwUrR
Y4xqG0juXTdngj9K6kChTE8nBL5wDK8I1ZICGa5oImaYUyW+ZhmgwdRGdYoVyyzo1gds3uXWNAod
7GqihdZ2LGbE7Y9xXf7YHN03bBEoPzYOuEptqZJmxC58KtwZuMeaYfScAkEP+3blqKC9j+VdARmv
fp9Pelmitq82pRc1HikP8+VWFeosNNDHkRO6H70jXiHdT4iCA72Yz5m2Sqk8N/HGWLIGD+ioqRak
djMMpCbnEZDFWys6DCX4c+FVSrNjBYT7VN13kPSoYJidlXJpd04uW6zvEPn6DLt7JXjSIkEj82SE
6wMZzMpKdTP992M5AVKgNnvFiF2QTsvNYRTBnNITLl4ye/Isjmx+eH7w795/1Hy/BD2MbOkJm4A2
EFHMU2KzMTjMHzKENgkp3EIFRMR9TW0jfrjhJKEe79SJbvEKgVt8yjy0c1LtM/+hFS4ek13Tmrb+
Q8fjq6PFouSBx5dmMvMhMr7kuYK4uBiZEH579YOS9n4Rhyuc5Zckxbmf9pxqNrwL5t2a7gilOjCI
oaH8dzC5So5OxuR/YhhCdy0pX+Cde2z/0IEr3Zem/QCXnyevkz0jU5rCWyi9x8wLZrhSXI6UDz9u
eK9CquAZYBoZbrWvTA9YJxjRhKFF4GCwnBshy4lIynBfbcUGvVTX08gUzsWyOjv2XNSGWEaO5+eE
FKZKw45bnil9S11PNHD7baQzJOg7kUbz3NKsoOwsF6Hr2PLKVjRnXqeWKADc7e6SL4QDxPA6aKGt
sFHE5+ryFR98MEnParpwsie/i4HIkreHfaF8VdVcJoEZ68V7zPOsOtzNwEeFWSiC1KSMuyB7/K2/
JIl/zRfhBCicfxAKd8NNP1hfVudljHs9DJCW2sdqpbiP+8YRLF6rAiIsN/R0S+d9HbTcMEOxUuAm
G0GjHlHrIyvBUx3DP9d72kwRxqDE2JrTAISnTgfHJSLBp99f2n6670leNjeOGsGnxf0KGEFw3s8o
IXRqLNer7PjGptshHnBtrjef3JvscYiTOJ1ri3vi+YxG+TzT/Sv3Y2h8iwUm9uGk6Zt1omedJaVr
rfMkn8nKo9+8FMDG3eKb7oUTOtPoW6WuRW3E7tKWwoFwn/w7R1KpOfPueAxXw0waA77kb/KaqD2K
aiS365BAbaLsOzACTjKO+vAtPEzbItnykcPIQpNPy5gWArZMMAR3M9w+JkV3DfboVwvv+pI2S0Tk
YGkCv9VoNdGPb+YxAQyMLTH2aoZcDLHjhYlqctdsHpxODH5+wRDggc8zQnuIGUabAGEjkKTFaIjU
KhEURJu2QmQJ6YjNwRVhL+sN+n2H7YVvUhgvG06X7HE9zSA918hjCTjc5EkF38FoRvYEtXW/DE8k
/HuQ83LrZ3VKcLOxDjrFukSP9BhJrN3lVFeZr1zN4OzbbDdALJctHXkBMcS0bSMxrpMcSJDN1frd
jDOkxZQCme5M+SG8b5bOJjVA5T8fXWSXdkpes2rHu+Ek0uzIqE84yD9kx3BnrRxOUdDQsZklqQli
xn/NT6WAxxkULAMEzO2efIis6mq27VseKoDRMU2KxT3gtfI73X4Vq9EDYdlJsfdkyVr19x8cvyCt
nuKnvNBp2opewdw+gYbzuc3NU7M3u3xL5ID/hL6eWFRUaOjv5wnEr3Abn0w7aLyVJHshrCM4JaPk
Qry/fGKox2CCIG29WkFdXMT7tMuG3VZHGkIqKrjuAg5B1I8tKa9JOqNMQju6SYyRvbWsE6h9fV2I
O0An5c9oG2Uj0rBwZM3NWk458dCuGvJb505UPKzVOLtsZ/y/FmCo6Pb1RbnbIb3fpfV6ngtX7z7E
hj1jKeqJaVQ2IdmtB0MGX6y+d7JVMIcT6XLLlZxT4VNDBouxCN5KCEHZXy1DJ49y7siEUt8WIoSw
wMhYw8+CTvFW9+DXsYDBsn0cfvYgqHtvkJXUJ8plkdO1znmRNkw8uXJfQZFw2wx0Rm3cIzwCfcm6
0MZO0mkgXNicSh5+ESSZfYl96STiS2M09qCPRnS+vBExneuR6r+W6N3qhXdRtSxEzNx3RmNuEcSO
weMjfX+ivwt+U0I+dbVYCQbYF+ksZ5uRJRAfspc9JPsDaNqH8jQGUOgk/ksNOFgHUvEQJnO4m+dG
wxrqEcqnuGGPgJfGJ5YYjB3cvHA25NDt1y/4O2ETrwdHEYB29qAkyTed5aCO8PWQvrghgj0ytfnT
b6sCTRdxgi1zvyaJbzo5o6aVdqcRtUad5lWcuMoiVEUWTjx45/kvVs9kHWqN/pX4Uru1ivSxW/Vj
t88/3v/zzhKh0vqKX01gi4NNPsxl9qfVBOwkfen0qZ5oI5v4mpwRDPmGTCFwNC/4Iu50qE5xSifB
q8s9o787SInygAVtyJr4iVrpZkyJ6TnhtEwSMYQzMhkupACurZXLwm3yZtJJSKqV9RRFWD8a2hhX
mrHMC7SmbqyrzHI5SLBNnzVFws1mO9owqLtvU+2IgRo/AFEB1/bM/+o5yhF9YIib5CDRqboA2oJc
U6Dkezz6i6O2BCkgjmSGpeuNcfApYaxKZIf4sAwAPHXZEEVjbCNvpxQIDviazbcz/TpPGVMODCsN
usmEkhSnPHLnCTnyemBfkGTolCnyKiJio04ClpWwqwSqngI9GWNZSuEA2Tb0GVNJ9GbJkMNptxhZ
7dNzvzHPdbO1WJB7L0FmZUnNkThtDy94uE8tovTaYreJ7Zvs+Mb5MWJ/p4jrWpLi8pKqQ0Ywhpm8
eHL1YS8Hkjtw38T20V9ym9MY2ZzhUyySTfCLDb/BltuvJaPSHceAp3WnFdmqbXK4PO0THOFJ48G1
qEWJK+FJhh8eHdkOtql7OAa4uCR7veWZhYg7SQw/AechSYyNqDnG1L5zf2uq64mRy2WWC2F8ueCo
z3erYhwJZZTqJFn+UApmb956jhtda08fSrlTuRR4bA4M1v7dOJScgS/gM56sgmi+5eSWBigS7s7Z
1kbszmPF4d11T0vIRqtzv2d8x6dxyFX54MWyLDNdiO65DU5sAmlKCzWurxeePnWXF4a3lKSrOHeH
2jvO6D1ETmu9X85Wfs7lvYM6E9AB0gSxYA1vXTA76j1slxHqi/RP+mhhbaGqNx2B89dD7MFbrWL5
/Ni2M8ZrvBOVnlaEDprotauwLt10pd92N3ql8nRlL9n23P6d7znLPMuAWsA+4rxpTtAAf+EeML/J
LU8BlQ+pHLuQZVEZHKMxv/4V9TxY6qIQlKFbm1B7LlXxIa+CnudP8YOtgaK1aKeI8gjuvCH8eDBl
FU68mWEz4RCYMErli9u49CK5twn7mHb9ZWQ6r4QLV7A6drK2k+uvF2/r7bMX60csW6Z06/Ui9hwp
EmBpQjE0ZJouTYxnzBHtuYf32gXddg0JlHHGQFhs7ba6rm2ynmsJlX0p4zWeJUTK9pJGmDffxmqT
SQHkWWFdqopXYndj6YgKz4Ot1JFhR/XwRG0FZZPNNbJknCTFM+7WU0wcU/gXkA4C1eE6RxVyy2wD
j4nOeVYiTos8NzjpY+VlBpby9TdktJyS0J+7JxvX7BbB8uuo6wut8G6OA+OzBpep5alyuDKBexEn
fGE4DGjnPHdyhIfh0IFlj8a12MHzN1NPliUoRIzuZVwj+3q/m5iLQB4adnQ3Zqx6xny/tJftloVP
u/6sPb5rRo5fHMiO/JmvgeQFj35MPa3g1Df81k/fxGBfTrPXABXfu7MB2fbGNi0Xqtgvsdcia4tc
DJO0Nxe5jElJS/i+ucX5RZDpmvEBD9uUhxQ3SPZH5/iaghV3kCBvQt9Bssda7MrucLBjiYDthZXs
0w8CQwzNSJZcRdabMqQGZl1kFWqIo9n9FI2hsvfNzmw4d1rm1gZ1stfRYVyxYt+eOZp6PK/BZAYL
8bHmnx11duXSmI5UqM+SVhNRCX61F0QZ4lV7/TFo6ybfPOjOmuOf+8+7uLDaoBqy3BPfD1zWxwjE
KBLh5EviIj2GdggJAUTGIgcP1HwDxUz1nb/h0Ts+ZnbCkBBp71p8tE8GRFjR63faeI0WKLiwXZNn
gKRXfWMv+UbKMAL0hJ4RPfxFiX2cSjLGI7UpT7U5VdLJMjQkA0hbaKc+QJjkQBtjSp+s/DwWtRfU
YwcVtC3YmayIZIX0WNZrAqPnEx+D+UpdVPXrXQfNVG9gy1Z/rjdSBZmqqlFH8C22IkPNA0Epibdp
/beAkAMCOT1G0skquqCzPiT1+mNvcmtGvryeBTeZ5tW/2aLzPn/2hFzUuZuYrDpo6cnoJFIfXwYF
PqYcogn6Av+ne5WhMfPzQkiu/RTgO0quKzZEN5dyESntpye3EfA7bx1td/66ujviihBMF1aa9ZIY
TfUxT+y93TNKRl22zV0MQxbjC3czNKy7GDjH8YIMtxhvmagBRuR4ANqTdaetGiCccKEb+7UHzzCt
t/31mg8F74Zyj2AHuYd79Ao/JnVNSueJ4h/kRyQ/8FdZTmP9fXk16nfPkmPK834JjkfCb4J/bEt1
rsZoYF9cNGDhUZj850Y5nXNBP7TsWH9oFIYdiRly7Z49XgKQUEdNiRMtKGqksZcFufXUAmj3Oyal
M96cRK5kjzcbzFpZ2bIEdm2N4im2pVfgPPW48lNOBEQ62jDWomiAaawM38v5JZZ2LMCR27nPuV+M
CI22tE/b7OzssdGV0JrjhdTa9IbJKmag5kbhX8kIJ7hPG2k38f25Trma+cu5blT1F4EwXrW/NOj+
tznVceDFNrC+16M766f49cPMfd3xumGulaC6xqSZ9Lt5rSF050Yy8LOzWJn2KddLbrEJdb0RCo5o
K0qsHODQmeat0gk2msyFZDIncI6jl8hF2ayaoqL3+rlZZpMipF7/6s3FRfCRnmx3csGqIOHTas1S
OtcYSU0pYZlWpuoqI6U3+PTbfZIezGWXImOb2RjGLgBJ/2XVLBScnfEKpWUi389Yns5596kKZUzB
FaN+N8meCggGUbudzV1iNQWXGovJCo5gZP/SyX3bdpK6UY2ssHjy5qprpImI4GPFukBUXltYOci/
X01fo1lZSG3opkx8Z9aF1xreIf5QoEMcc10wfEkA2Gp5szJbIGfB1c3kY6nB2W5YCj7sjMWhn/46
VwbLb7dZKxFYaezwrMN5txwFqcj/62Uq4+D27QM0u4ZempeWOsEnRc3Ykfu4E58uX6VYeiTL1atq
/bww2n93ROE1SOJTKNiw/s2ZmDr7m0qlAJRxb6IJ5IHBh4KgsY48oHNfL07ckWcf97nygkxqPE3P
OoZIGzxoUvTGWwVX3QIUnztT4MnzgXvfrrQaUoF46Bxf6pVvWW2d4O6gSVQQk1Xq1g/p4qeRHsN4
PJrlNUHFOcoJ4FESia4PhFI42JZWb/CNMOGObaF6zu7a8qfJsIiMlN/wTi2/4ageB5z1TzY/VzLb
YgvULbRLFypT73MQoepa21O/zfnmc8+GqEP2PPaTFkuBc1uM2A1fKdnhksSBBPSVORfGQQZhtjJn
p0qIWxCVWI33sgKcePH78Dmf2r3RbsBDD8m2WMlWC/HwfcOTZ8oHbFe9QPt3s+4BbmDWJEJYykNz
fwQGhaD8IwbsVqHEhT3VCWq6C2/IgjwUp/xwgX2M8zWucBHk19/iv77DK8yzVq2l/HWOm4uOiwF+
sjtRjJvC3Uxj6RkBOlVg1tzrRxuJH8D0YWqJsN4zzEqpqZZ93msPcfaxlCWwT0Jhj+GcEFU42RQb
5TzszD7bbvSHq8H46jYxWRHGOcUqzaspI/5Tn2VtA3PNRJvkK0ze3wB1c/HbxxjwKTCx+XzBRjus
LFO09awff3nUDFW4Y3pgzDGd+bdNtB8RSZ4uXnTLNmorwjYDUmKf/KDwQQUR+FRzqfINsOLj3A2w
KbKf24NitqyuKi1wGZaKe9AHxyO85LLpUYFYSo+jkoa1YNAPzqZ0eN6YAKOQ8Db++ChP5FkD1ch+
Dokc5B3AQRwuJ12Vam//FTYPzpMuiiIzT5dXRCCJwsy1gk+P9JwXupFwgbn01wOIdlFI96IELaN5
rce1+HZLpNa+k6Wmg64rVmUHASqQvPENIHcjDCTmEacvbbchS0yZxoDOsVSfEazZbsYrAUEmQbcc
LCGc7HjgEjWS1Bg5baCEZ2cM4SItWmv1QyxkIKDHneY6KdqjZDmdelVq1Ry8Z1pfnt7F9QoMEIKa
ufZo//q1vg3HwIvXpmbAkEgA3H4bckZphdaHEkS1yZ6yxK5Zf03uptNWCjKFef/sdudNa2wWVHCV
H8O5+bJS2H7lF1C5GztKImmQ1mTe0r7WB45m1uFi7qXOfgpPa1Vy3nDYcC/uEdfYY6bgaar72uQJ
XqlhxBjeIqjOZaI2iuQxS4rmbeCKGipVtJl6t2wHt2FcuXCkbgbpTbyJJn0jOBxg15HyyG+pMTH/
1mWV/6MnPTGoi3446woxovzXHMILPVA335XBS+KbXPyi7Id6gFQXwrN3hP6gTUA0c8SeFHoRoXef
f51uuiIozt4jP7bavCjPtB+zgNKAdgAMwLGgFwvG24LUBgFGqtwfSxWusUhOIWn4nwMETTJny+9Y
/vvTwrBDM74NVOXGjvWnEFkQPshlfypZqTg9FWf0m6vAO8C0dbFMh8cc+sZobjBAJ5HEZzEc7+dC
Zn8ACGvjSJXfj1RtAk1CW1fhUjhA1GNsAGRAf3bh6UyOheWlgI6TsLVo+H3YCc3HeUTOQYGoOCmM
bhIo1mN51Gktqve9Nh8qF/zSIa314RoSYoaagsvAlZC/D4iZ96eInx1iXnlsL8C3RCxysfscOdoY
ka9QFI+E77sQXB8FPjer+O+aRrT3zB9Su1mc94PzWuhyA1opBpqHmUM8SzVJQO7+lNpGWAtZhE3R
MhsGU4Jji7eatxaUYgHaUqJFXjLX09R1inqODzXANA0i8EcoKZ1adrmHeFysVJ+wEqn7L0XNRAIb
YUzXBbs8Bl3KdMQxeR7bgY3t3DJXOFF9+BohQI2sOmVwEOybcgQRapJIr35s9U+sM6Kz1svkN6AL
5Db9EhGuJKa1OM8Sm37s0sMCJjTDQRVH58VRh/Icg+RmF/2KnofK39gv4jEy7c3lGO7tX7I42qXB
fxUaBjIGDsz84Nu8Z8e5FNGn6F+SzX4EmLhEFqLezvH+Y93a8toPamktC3iPVaARwhOecwDCKtQ9
Gmfz9d1Z4yDMFtZEpvsXnjlQdQWbRqJvSmQd/DCfFwQgLBnS7vOtYOGs9HVaCoWZbtZ2pnVeLiFE
KyQD/Xz63mVyUCIg0wE+CFHA2hNBD78wlHB2w2h6VnMgA1DFZlPNpu8ugbbH1kga95wTAu1DCaVe
P9wdPH+VtI+O+JNCIWsR9k8uHQ4FgrOIVbVqNfWAsArH9OUJluuBkQxt+vGnjwTp7/a66CADFDpD
h9dZv5j+VWVqHnFG5Yr/IpLIX+UInNB+480dB4INOz6kjIQUMwGJfXLASPKFzJNpyi3bhKDw6mkQ
AnCNonlIw1PcURrwbpMIaCvQIl0ZOgb5KBS0F4dI8Q5rGjNvGl2jAyS7Ykjj1GrgtZ6103/58cGM
Gjjzw2M6pVrs90puMcw/uQEyTKbJBdRTIYYA0V6XHwXBYiLHnnSAhjva88dtNAqB0WMTc24UFUsW
79HrbUpHecWrlgA10HpFWhT+Ld4+DskCHGPfdL4zDxE4mQr0uFpCkeBywzGuT6vB6cUepD4LkXb9
NFyNSrVfd/4/nckzBguDGTj5qXvaNTM+26ea2oSR+f9CvXN5p0qj4MeVW+wfAluZNVifL1PNpPEh
7Rjmlpm2//8F+5lhPTPHvC69KKPmRiiBY+LOOgq2A79m6EblSiwaGx0UyfF4oXMgL/GZgJy/Sipb
BOlnDEcUga7RJJfBIPeQxxoUlZ58bxtlyUiWBMC72ZbIgrNV4gEzkVdB9VT2Zgu6vgNNDB7sYtzE
2G3T2nDv0NLZ0jbg+Lpj3NioKTicUaYemJ99ZKv/vz2vIQjwo7K6WAAEkgbja6zYU8BjSyjCjeEL
XSwpqrXNZNcA8M6rAI9375ax245UDSUZMV/wqrVRrpfQefhFqSm/YFBgMainOa7PiU1SsJzpJ6Z5
NVEhj2QcxD+cXXbD86jl0SWqUIR4pfjBlkSU0/LEV60+YC9x0PYpMz9Fu6ixaKCyTacKGUw+XLgY
fGkc2RAPe8w3xXr8dUCjB0afL8rVHNKc/RrdciWwUcuDDw+93909FnNpkDQG1z6pnFTuZ0K7TNdF
k0VH9X16HogaSCC2k8GFXWuwOUfa1s6lSZzArd3MW/PuxVHsTGLtTpHqjkJ9YExh2GSXOtCFTDzz
6CZYMpsWcbRXmKSDTsx3DMFLCrFW7OBTYOEXA2PynjSkjSEHc1k3gIO9ilcPdm3PRhoKHQoY2Wvs
N+gNwvDHGvBttszqVa1g9aQFg87+PZuyQ2I0JqqT/D9DjXvK2q3vQYQ7hi8gLBoxzzewqncAOHy7
Vm1brx8re45p1ZpEvhPjWaRzAj7Uk8HYURJqJdMaxYZF44XUpp72ORiajA5Ik87cb8dF9F99uR1h
lw9iw0c+G5Qk+OO72/afPwGpMsea7k/DAGzDafb59L1ndmcy3xfDKsWO8jpHscOdXDAglcLZ3FSm
5rAi7NpXW8jeYx4ISsKJSYvVvSg3mVncRDtNDem4rhI0kOwnC+9HnxPDBnk0kgXrtoMvpGL00FlC
6bf+AYGiZikmHevsyG4NtOKuTOCPnV54oaqnaJVRdBQVGlqnpp1IsGIwLFWSrhwlNvHqvkxHqKJl
KI261uVx4u3Iu8yJs4iXsNvgSJm5F/5RhVv4I751EcbycqPm4TlPYxIiOkr4RDujsLt+TmLQ9V9R
nTBg4Znna3kn/FZ9po2hwqELGSpRyJIdL1j1XkFmZrNvDOY19V09/1BuUXTl2rzM2CQmN/1hUNiw
sUcKbdaDMnOBA4KIwk7RSqHkyutN1Slal92yUMzIcHjw68VTtUWW42f62UcO06yAUPGBOVYRBtfF
cFL6aIy6vJo5Qy6X6NnF5Yk8c9sk1udHO8+tWpKcK1jL5XK9Ky/u8TmwUT5usmWgbFO+E11HAfTL
sRtNAI4++ccoOoRm2M65u9P9njb0ChA2JVwi8Jf23CucPFct9N3JdXg5PUGb0HOqzAL3WO3hdcGE
egDxsL+8XjfprswGx7Tc57YMsavqv4/8VwaXsZ8E9e4TIMHozcHL/kLgM02JGExp5vPKpeboDbrB
6LjvIftNEWX8B5S7MWEQAGSSHKhGNTzbAAGAe+TnAwBSUnqNscRn+wIAAAAABFla

--mkTGuLlkwsdkdHXv--

