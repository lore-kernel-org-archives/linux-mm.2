Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92A5DD3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 06:10:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E26536B0006; Wed, 10 Dec 2025 01:10:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7316B0007; Wed, 10 Dec 2025 01:10:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EB56B0008; Wed, 10 Dec 2025 01:10:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B32106B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:10:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30F4458B22
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 06:10:56 +0000 (UTC)
X-FDA: 84202538112.10.15C583D
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id BD18B140005
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 06:10:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VDywFdQp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765347053; a=rsa-sha256;
	cv=fail;
	b=cIxjjPCOVgXaJOEtqhHRudcH1XaGfWIONFUuSco2MVP/TzUhUaBQrkyj90VN6Qn4JSLFxv
	2GGpa43iW8GTGLTg2qCPABhdrPOGRRXl2TjszBmiMPJtpKBUKDaPIG8pfiSjuXtkxOviIP
	R2ilcUtm+90CjAvjDJ0KmO133hlJ+B0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VDywFdQp;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf26.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765347053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ejm+h/CRTKwNmVVeC8pjCn07J9rcTEzXWXHFaZQDid0=;
	b=Oi+Xmg1qEU8Nb+DlF5HlgQ1Hn1kxXi4hJSsfdhKdWzol1997Ain/eD6NtbjyrZs6YjTgr7
	oMeTPG9kJHZKPDFtsvj5cF9OqYLxALt2rIZWscCGi8OSOTjP6hTsmREXd29oJzv2TPgTMB
	LZGuMqMvwxCc0o5StCImt/n3FiQOgWI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1765347052; x=1796883052;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=e3x8XhHwAgA8UqIc2OpkzMGNBGz68ik5iq71J8ywaLg=;
  b=VDywFdQpoquo2mLuWhcwEv8ROZQ6IsLBfnuiE9Mzj8I0zOP8rSzg/XLw
   5O1nbDtfm1bW+QpFynSYnJJmBnOy8qCKao4T1RarOOpsR3g88wBrjmE56
   +PDqyB+wiZJNjlcMrfg8I0Mjnv6sV2STtT+9wxps1dprK74HPqzwhsltY
   XXloSk2BUIzwlleicehk9V0hPpPhuEAeQybEU4QOQTA7rGbJvLWfRivKO
   1kzY/KG3iSfLjaEpE4q2kplH+wrELaY7kcOP6gcpyBVDrvVz/SnPFupX0
   tZMXsvIlznjdUl9KaTMldW7PzTHqH1QRIyexCK1Bej04vzEb3+gRGmTBj
   g==;
X-CSE-ConnectionGUID: o/jQ4MlmQiyxEKkNiHjczw==
X-CSE-MsgGUID: oyVlqSNPQgOC9bysR50BqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11637"; a="78779314"
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="78779314"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 22:10:50 -0800
X-CSE-ConnectionGUID: 4JIfCr4sTuSehCI6HC/c3g==
X-CSE-MsgGUID: M+BwzAbvRXOlt5PWTRZNMQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,263,1758610800"; 
   d="scan'208";a="233828316"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2025 22:10:45 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 22:10:44 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 9 Dec 2025 22:10:44 -0800
Received: from CH4PR04CU002.outbound.protection.outlook.com (40.107.201.58) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 9 Dec 2025 22:10:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JLU/mITqIm/hA5dQtTWCpxno/AQVwFlQxkNDjVCJ9A1kIjFNb2bn4dAG2ucqGhyxyvDB8/7apsaYQf/7ZQ6y35KKBo0tTM7+fnywmvZ5JWYhMq+6uCa8eNh8SakOqg8G2qAxEsd7WqaE+rlI95Il/KlvoGu2DS7c50n9qLXgSWAq/JuE8VcCRnLz8bx4uolxynuMOVe5t3Z0sXTyQl+Fk8F8hFmo3G5/66tF7ZrIR4bAjn9DqbQ5pebgfM/CuSXeHyjFDlx/ldSmFAQrcgITTK/vbyuC4sDDoB++ozl0JOEgc8VBKgGYM1XdLsenTXC1l5+6O0LxRunPOd/Vf9Phdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ejm+h/CRTKwNmVVeC8pjCn07J9rcTEzXWXHFaZQDid0=;
 b=kZcIW099xJ0lTY8JhMyQO1Y54lsPI2pFofzpr88a7uC3+bAOd534FeLKTZ+K3uDWirIGhIn7rbplAEnp5UTev22LFxBVWsYlSgNoDTBvJcTb9AOuCKPeO12G+puzGRQw233MuEdFvy/Y52HA4REfCUznoU8g/6VAVn+gnGdZHu2Mlko1LcqYzLnQXaS/ZE0wIpFhe/acsVGsJerCBrjIOOgTv5ohEEgZaoy/qJAUk+/afpfu1+pyW6Zlxk3FCp6W7vGRWNrBLZ878bAdnO7MnG7gqESGzDsfhOUh/q8FQe11xbgdjj9CUAfSZrqq2/z1t1rev15GtQCV9+OQAoXwzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by CH3PR11MB7179.namprd11.prod.outlook.com (2603:10b6:610:142::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9412.8; Wed, 10 Dec
 2025 06:10:36 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9412.005; Wed, 10 Dec 2025
 06:10:36 +0000
Date: Wed, 10 Dec 2025 14:10:28 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Vishal Moola <vishal.moola@gmail.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki
	<urezki@gmail.com>, <linux-mm@kvack.org>, <oliver.sang@intel.com>
Subject: [linus:master] [mm/vmalloc]  a061578043:
 BUG:spinlock_trylock_failure_on_UP_on_CPU
Message-ID: <202512101320.e2f2dd6f-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: TPYP295CA0059.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:8::20) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|CH3PR11MB7179:EE_
X-MS-Office365-Filtering-Correlation-Id: e77d7ad8-a075-4f87-4ce7-08de37b2d59c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TW6DMxkKyTGpt+qnj7xAGAUhURPqiLoP2byVARwugswd/W1nGwlLYF1v8EnS?=
 =?us-ascii?Q?7D1KUv9gFd2N0cwuilAUH/7GGdOH+dEyxupMA8QgfzFg1qJC2DRclZgK6gfp?=
 =?us-ascii?Q?NqU507sVzVK+VwTS73L4WmUU2C/rZy1WB2sOYGZ2EajVxH8jL1yDDwC11tE0?=
 =?us-ascii?Q?KoY/icOVz5RebyXlgvgwGXkkCQeAtRFYeu+7QYgXdDlWpMpx0aGc5f471hYV?=
 =?us-ascii?Q?w44DbB69FlckESh4US6TqCiMZYSGiQjuOKLSMx82d4fEmW1X9JGzJJtb+xET?=
 =?us-ascii?Q?ra3YGbDIaHYAiYJC7wf8xetzIJvdX4RoqdKsmS/l8aJYWZ5FDAQuf0BTEk75?=
 =?us-ascii?Q?7ycqexP4LhFkAZFmdbYVhYJp3x7fzrCkgU3tG8NNdtvSebCpfo4dKtuERhxe?=
 =?us-ascii?Q?OZevlhmTHNXnZtrBp1k10xe3gYUKtW/r4TfZzN4Ui4KpdfWVCI4zTVfeghMA?=
 =?us-ascii?Q?a+m8o0FXYhfowbKcBue9MmuWCFFCYuPB+jwjb6tcNPGi+uGxAHFxVm40Lkiw?=
 =?us-ascii?Q?mqhtDryXjg8uqPoATKM6YOhrn9m/PQuTEJceDHGAgluzAzawnmVWbvmKBw8o?=
 =?us-ascii?Q?CUlxDUlKJBlY5wMEXVnSJ3o8Gq1kcbaXllnsOcIZjvQgsy+yvForHH5lbuLT?=
 =?us-ascii?Q?ViP4NcVSoQboxfSGmZjsmwj3nkqXECA9bF1pb1hYUExf3P2e4uqyMcT8k+ug?=
 =?us-ascii?Q?FxphHb4mkye5nQn/RFwGsBOQEj6HTK2fwZjjvOEP394h/XsOSUbZzkUHeYqR?=
 =?us-ascii?Q?twfXm7Xqpj+GjTi4Wg+JBQzw8wJ1X3jMQOL1ihRGKoiCxgJJ4YtBA/QLmHkn?=
 =?us-ascii?Q?mp/3Hw9SjYdX6Mn+pyYj+S4dTdf4XfQH/w0GWS9gtEUqKBeK62F+uGiTQsvj?=
 =?us-ascii?Q?y4/7J1sKBGvRf4TLBf3hVVHX9Q9XdXYNl25qny5zlq+Xnd6xwvANKTmZeenw?=
 =?us-ascii?Q?BXf8CDhNZsO4Eve86clGUSB9ZPuyouECtf9iywb2TRBubP6UBiy3ior+1iak?=
 =?us-ascii?Q?nvw4dy5sfO3HHucjPN7ciZte/belm5qCzxy8S7/oZZ6MwFDShDUnbvIGBqlx?=
 =?us-ascii?Q?RaumNK02Xoj3yHBiKE/b4xSyrNf+m+RSgwPmpivzdDlEefjfoQsk7ziNl9Gn?=
 =?us-ascii?Q?e+TVwkwMhIX5uoG6jvBw8ZFiSHudlacT1dAdh84ae5YPk7OT2/kSUcZJOOPC?=
 =?us-ascii?Q?cRHcgPDdflr1JZUeNqi1u0aVkQw+usgkBquiHeRPUCutK166TwPntF4qerCn?=
 =?us-ascii?Q?ZF4KVVLBLaWKHOV8GnKskGFa1L8Gj/eyXz2wYP8EL8tIo09+Hrya42q66C7M?=
 =?us-ascii?Q?OUQg+rY1dJQi9VCXlJG6VeY7H7jCqP+yCOUEbygr4z1Yq9POtTxJqFubi4L/?=
 =?us-ascii?Q?SfQ1NkiJAX0kdAdK5ZsGqCE0cWcyjlDf3QtgOBoPV3crtsk0rxjFGL3nGOqm?=
 =?us-ascii?Q?SOxm6zWxNQ5WNUFIuhMOf8dhRI1Tk/fvCqTOqpFMF/LW8vQMMWeZVw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?4q4plfjyWPheqWpv65h4YItWP7kSu/w2oUaRpgbrfA8nICkW4EqfLxMIxwzz?=
 =?us-ascii?Q?Hq7SKAkVVRRs47wfK1eAdnfJLhREWU88ltp3WW8byRgVXBhpnkaf6qLijcje?=
 =?us-ascii?Q?/VvMIslUzqyTd7oovmzQnDoYQq6xL2gjGUsUN4eJq9aReuI6IQJFqIUh7kOt?=
 =?us-ascii?Q?1+vRe+w0L+5yorxVowZsB2DdeHlQ14S2D9Zn2/TQLxas/JwzXtvTtsTWrwcq?=
 =?us-ascii?Q?f5cjL4ZNl71U1//xRmSbD68derP6Ssb4MndZlmMSKuct90fixY0C9OnuvWzd?=
 =?us-ascii?Q?ZDE+fbsANK3TST3hYdqGptbJBVwiLqXOJUfstg47H92LjM6BIbxDquGV5C6I?=
 =?us-ascii?Q?GP3b7lh6PO/rz4uig8bLql6rjhPPkdXKMOPQrwwQvG7miU4s52RHGcAo/89L?=
 =?us-ascii?Q?QksGX25ji9Z7h834zxa8w4H4PhRXjaAyIDG6LUh89NnPy7+jH0JQW8WwWm9A?=
 =?us-ascii?Q?U6mQtrgP+B0X/14aPpgLPcOek4pWE9pj3nlrmmbnhIiIAjuc65+X0KPq7L5L?=
 =?us-ascii?Q?I4Qb541tP+rEjPjoC9dfMjVNzmqtbNx+6JQ9nUZNN+hVN9VoRB5D3gmLdKVv?=
 =?us-ascii?Q?/wjxp9AUh7xvixSb5u0AuABw+5sQPNtwzAbceobVz+VmacDg7irKqoahs5yy?=
 =?us-ascii?Q?pGUtFYkodOspZxurbba0XcdPP5iC3ivgfW4CiQo0KfTiETXiVOBxzVZbahKR?=
 =?us-ascii?Q?ppS04iintbsk0bw9GiNifZoH4OqR963d+fIiutv5yVHB7vM+B/8HTHNK/dI+?=
 =?us-ascii?Q?GfabEJsFnBt+2W4CD9OoVoyOerahWfQrNNleIs5PttdD9RLxZTZgQPhSd215?=
 =?us-ascii?Q?u/zLbizUjSHmm7IqBOjOVvQNu+wOGEf4KFC9fQxFziNFsjWlw1LyYq1Diclq?=
 =?us-ascii?Q?hYswuA/vvRd6ig4/WltXrYOh5pg2R3w0ODoJwkxc5W9yc/FD4KoguREQeFdW?=
 =?us-ascii?Q?zk2FMya5M8rTWnc5NeI8rIen9ali1PTikiNmrzgxe4/siAV2AVVj5hbOSs3X?=
 =?us-ascii?Q?DyaWM2DIeUrCzA0A2HczYM/sgv8pY9lCNRsbln5mUKfdtIMBs2dWRHW5GDGW?=
 =?us-ascii?Q?sDaD5KjjB1PaV+mKOxC2RgiegZmRLS661H0MlFBNuUSPph6u3Wd9u/k3kS2R?=
 =?us-ascii?Q?zc57W1V9d88zGxTG1tnU1ta7ynHiAUQyExMR5QmH1Ul3Cl/ijsbZ9meOH23f?=
 =?us-ascii?Q?XtUDdaE2HksYnio1Ma24yAQN+pxEiPA2hGKo87D0VbJOFK7PNrYZL6czqlEn?=
 =?us-ascii?Q?BSpGAHC0BeHBewO5bBDbYMYqMsZe4vvuqWqhBUx17ukv4sjBGXgH1XcuezKy?=
 =?us-ascii?Q?cGj591hgqZzlS0E5MM3Cjpecauqh16olPG8pJu6XV6bPilsW+px6wWeqFN1c?=
 =?us-ascii?Q?5dTSRHkm6rtrjxqNUVOMSMWJyxO+SyRKCpkOyNh5+eRkxTfYcn41s/PL5hZE?=
 =?us-ascii?Q?cNjkmP0oV5eM2h1hcDiX26reF3NIf3EhpIiWNVvkqdJ+QZxmadRuxqmbSNde?=
 =?us-ascii?Q?aqOOsz+3AbRixbCWl8wV6a/ehI/Truv/tWqQn8CklfnqU5IgewG43vpJaPjY?=
 =?us-ascii?Q?kGaxWB5nyEOHeFa7LXuZ/bRkFHBiRCceIN//rCr4GKpvdG210i0jt91RfIch?=
 =?us-ascii?Q?ng=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e77d7ad8-a075-4f87-4ce7-08de37b2d59c
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2025 06:10:36.1581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wr6Bi2THiqgmhScTSNNxudkEsr3nzqSXwQMYItAQ+JBCnUcNxEr6o6eKQdsrqAUpl/aop+HuluswBviJlQc7LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7179
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: BD18B140005
X-Stat-Signature: e814btytfg4oynm6rp9his9dystk4xg4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765347051-953810
X-HE-Meta: U2FsdGVkX1+L8oGrh7opt+Hp3ruqHiiqcbCXen6num6e0vtx1jrd2+A3EH7IGmB1wYhVqU1A11A3ZHYAVeh9zgCeGpJRJi89Yh7u/H0OuRg9KKGzsmHBDgG2mqi9L8NmW4MWa4aAc0i+ZwRapO3hhdV4Q8yw8dTsoIifSIpjj0wlmwg+z7OfOadd0i/PZBVrQ7BZg5reZvYAeqUL/fFX+poQE15Oi3wm/ejHZ0vDv/x2LfqAeKmfef9LOK4u86T1z4rRf+snZLHFYDUpYAFYaK94f9qhHCOmKaspiZbp+ytswsx+8nVXVLYK22jROmvXiUwd2g43tPYG2BZ1c48cX1BWovZLwUCUSl8857Gkj/M8q6PEbHw8dZaeusP1+wg6GTCn7IhznZiSIt60CB5gdFqJstYtnTN4Bs8u6HLGjxXY+hEGyiUuCVE3ffOQUHo3jghTSjOG7SMA3vfruly/iEKCU/sreQGf3rAyYjVqG2nQi8he1Xa9fVLLiMW+yFgbJewgkbTt6JIJZqEo8oBeZtx8j8jK7ga40Zn2k92wypdACEEDlA5fgCvcY2/MGnrQsHiBXfRrgK5xjVsktQVtVCPvxZwy2AzhnwrKHAjfIWQfbSC2TPvfj+ABC7Z8lS3hb6vNIysIQVlJv/ZD6KPrfcO1yV4b5kXG2vfctcVF0hhUUpKPDf7JdM+bJPMALjtGWp8cxmcq88ZaTzg3pTpfKsgSToyv9ZkAAwuQRERGvhxKbviaym77fV4tpNOSkQZzW6SutK2O/FAFpSjDvbMABg+kCO2OD8/Jx7aL5cqraNgryW4cT8k1BdPFZr4fQXvdt8/B4lA8y17HSJjRRNYl7EzZRyfysDb6Hl7nSAtQlremJDRQd8mfi+n/2zQnHAJDAS+GTHoXwCu3QbrDdC9jLeGLAnS0YI9iAxktGOC3b46R+Ui8jzvAkJOXoofH5siA75Wd3Px9f4Wy7TpCBsC
 UFk7tbp4
 RzjAJYHzIrxh0SbSnCDo5Ygf7Dzw894HKMUW2313ikFJ3JSMMW8MNkTdmnrowahxl7LzhNusrkROfMexxL9XPOKsPewHHJ95u/c4bXYATpj5gV9+vLfusr2xG9fCgqt/luDDYttHOkpsPa+pPIPJHvHl5pKX5dg+IRhR7T6x+QtvwLVWCmbOCndJvFS9TgJC6sDYpgcYQ91x5rGla2tcZLFRZ4T8BMhqcDLStEUmQI3IMfqekL3RQfCd0lYRivWICoAcpaLqKYcJpeiQttMNfh6cyU6tWjSqO4NCT3ryLnlBIf8GNhCLsdY5OxIDJc2V8uvn1huMeovQjNP+u/kpM0wirWBBIfY0HsdUAaHTGoGw4X5YMDDVUfREnzbcKxzcPbieLL4SJmkD3CI54iILnNVU3MOC1O+HHh/v7ATcosvat1nrEXYvWfYkn0x5TJdZDbeeavsaYBOeupyyC1skMFD+ILTv6Cl7kyF9jseMPLb1nnDvdsIQNIkA5+ydCTQKPxVOV2H0YKgvnPJmxndyQis8PZbU+2GeAdr/LJWGI9CIQeKLuB97flmgeP4VYAVYEi1ZzTR3RxjrvVhAaBN6KXzLVyY8NjsfJcAfQoPdLnIBRUe17k8bBH8J7BHFmwn/GH+6jgXC7l2RHfZmfv3JsnpNMVaq/vdPVrVRSTfCi3rR2OstWMzGSgZQ3s8+vmEEl6bRXRgjFYHpkoSS583duNkmf6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "BUG:spinlock_trylock_failure_on_UP_on_CPU" on:

commit: a0615780439938e8e61343f1f92a4c54a71dc6a5 ("mm/vmalloc: request large order pages from buddy allocator")
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

[test failed on linus/master      cb015814f8b6eebcbb8e46e111d108892c5e6821]
[test failed on linux-next/master c75caf76ed86bbc15a72808f48f8df1608a0886c]

in testcase: trinity
version: 
with following parameters:

	runtime: 300s
	group: group-03
	nr_groups: 5



config: x86_64-randconfig-011-20251207
compiler: clang-20
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 32G

(please refer to attached dmesg/kmsg for entire log/backtrace)


the issue show randomly (~50%) in tests.

645a3c4243473d5c a0615780439938e8e61343f1f92
---------------- ---------------------------
       fail:runs  %reproduction    fail:runs
           |             |             |
           :60         50%           29:60   dmesg.BUG:spinlock_trylock_failure_on_UP_on_CPU
           :60         50%           29:60   dmesg.RIP:_raw_spin_unlock_irqrestore



If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202512101320.e2f2dd6f-lkp@intel.com


[ 1046.632156][    C0] BUG: spinlock trylock failure on UP on CPU#0, kcompactd0/28
[ 1046.633368][    C0]  lock: 0xffff888807e35ef0, .magic: dead4ead, .owner: kcompactd0/28, .owner_cpu: 0
[ 1046.634872][    C0] CPU: 0 UID: 0 PID: 28 Comm: kcompactd0 Not tainted 6.18.0-rc5-00127-ga06157804399 #1 PREEMPT  8cc09ef94dcec767faa911515ce9e609c45db470
[ 1046.637019][    C0] Call Trace:
[ 1046.637563][    C0]  <IRQ>
[ 1046.638038][    C0]  __dump_stack (lib/dump_stack.c:95)
[ 1046.638781][    C0]  dump_stack_lvl (lib/dump_stack.c:123)
[ 1046.639512][    C0]  dump_stack (lib/dump_stack.c:130)
[ 1046.640168][    C0]  spin_dump (kernel/locking/spinlock_debug.c:71)
[ 1046.640853][    C0]  do_raw_spin_trylock (kernel/locking/spinlock_debug.c:?)
[ 1046.641678][    C0]  _raw_spin_trylock (include/linux/spinlock_api_smp.h:89 kernel/locking/spinlock.c:138)
[ 1046.642473][    C0]  __free_frozen_pages (mm/page_alloc.c:2973)
[ 1046.643279][    C0]  ___free_pages (mm/page_alloc.c:5295)
[ 1046.643956][    C0]  __free_pages (mm/page_alloc.c:5334)
[ 1046.644624][    C0]  tlb_remove_table_rcu (include/linux/mm.h:? include/linux/mm.h:3122 include/asm-generic/tlb.h:220 mm/mmu_gather.c:227 mm/mmu_gather.c:290)
[ 1046.645520][    C0]  ? __cfi_tlb_remove_table_rcu (mm/mmu_gather.c:289)
[ 1046.646384][    C0]  ? rcu_core (kernel/rcu/tree.c:?)
[ 1046.647092][    C0]  rcu_core (include/linux/rcupdate.h:341 kernel/rcu/tree.c:2607 kernel/rcu/tree.c:2861)
[ 1046.647774][    C0]  rcu_core_si (kernel/rcu/tree.c:2879)
[ 1046.648439][    C0]  handle_softirqs (arch/x86/include/asm/jump_label.h:36 include/trace/events/irq.h:142 kernel/softirq.c:623)
[ 1046.649202][    C0]  __irq_exit_rcu (arch/x86/include/asm/jump_label.h:36 kernel/softirq.c:725)
[ 1046.649919][    C0]  irq_exit_rcu (kernel/softirq.c:741)
[ 1046.650593][    C0]  sysvec_apic_timer_interrupt (arch/x86/kernel/apic/apic.c:1052)
[ 1046.651520][    C0]  </IRQ>
[ 1046.651984][    C0]  <TASK>
[ 1046.652466][    C0]  asm_sysvec_apic_timer_interrupt (arch/x86/include/asm/idtentry.h:697)
[ 1046.653389][    C0] RIP: 0010:_raw_spin_unlock_irqrestore (arch/x86/include/asm/preempt.h:95 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:194)
[ 1046.654391][    C0] Code: 00 44 89 f6 c1 ee 09 48 c7 c7 e0 f2 7e 86 31 d2 31 c9 e8 e8 dd 80 fd 4d 85 f6 74 05 e8 de e5 fd ff 0f ba e3 09 73 01 fb 31 f6 <ff> 0d 2f dc 6f 01 0f 95 c3 40 0f 94 c6 48 c7 c7 10 f3 7e 86 31 d2
All code
========
   0:	00 44 89 f6          	add    %al,-0xa(%rcx,%rcx,4)
   4:	c1 ee 09             	shr    $0x9,%esi
   7:	48 c7 c7 e0 f2 7e 86 	mov    $0xffffffff867ef2e0,%rdi
   e:	31 d2                	xor    %edx,%edx
  10:	31 c9                	xor    %ecx,%ecx
  12:	e8 e8 dd 80 fd       	call   0xfffffffffd80ddff
  17:	4d 85 f6             	test   %r14,%r14
  1a:	74 05                	je     0x21
  1c:	e8 de e5 fd ff       	call   0xfffffffffffde5ff
  21:	0f ba e3 09          	bt     $0x9,%ebx
  25:	73 01                	jae    0x28
  27:	fb                   	sti
  28:	31 f6                	xor    %esi,%esi
  2a:*	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc5f		<-- trapping instruction
  30:	0f 95 c3             	setne  %bl
  33:	40 0f 94 c6          	sete   %sil
  37:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
  3e:	31 d2                	xor    %edx,%edx

Code starting with the faulting instruction
===========================================
   0:	ff 0d 2f dc 6f 01    	decl   0x16fdc2f(%rip)        # 0x16fdc35
   6:	0f 95 c3             	setne  %bl
   9:	40 0f 94 c6          	sete   %sil
   d:	48 c7 c7 10 f3 7e 86 	mov    $0xffffffff867ef310,%rdi
  14:	31 d2                	xor    %edx,%edx
[ 1046.657511][    C0] RSP: 0000:ffffc900001cfb50 EFLAGS: 00000246
[ 1046.658482][    C0] RAX: 0000000000000000 RBX: 0000000000000206 RCX: 0000000000000000
[ 1046.659740][    C0] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[ 1046.660979][    C0] RBP: ffffc900001cfb68 R08: 0000000000000000 R09: 0000000000000000
[ 1046.662239][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: ffff888807e35f50
[ 1046.663505][    C0] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[ 1046.664741][    C0]  free_pcppages_bulk (mm/page_alloc.c:1494)
[ 1046.665618][    C0]  drain_pages_zone (include/linux/spinlock.h:391 mm/page_alloc.c:2632)
[ 1046.666374][    C0]  __drain_all_pages (mm/page_alloc.c:2731)
[ 1046.667171][    C0]  drain_all_pages (mm/page_alloc.c:2747)
[ 1046.667908][    C0]  kcompactd (mm/compaction.c:3115)
[ 1046.668625][    C0]  kthread (kernel/kthread.c:465)
[ 1046.669299][    C0]  ? __cfi_kcompactd (mm/compaction.c:3166)
[ 1046.670046][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
[ 1046.670764][    C0]  ret_from_fork (arch/x86/kernel/process.c:164)
[ 1046.671483][    C0]  ? __cfi_kthread (kernel/kthread.c:412)
[ 1046.672174][    C0]  ret_from_fork_asm (arch/x86/entry/entry_64.S:255)
[ 1046.672936][    C0]  </TASK>



The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251210/202512101320.e2f2dd6f-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


