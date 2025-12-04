Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13B7D2168B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F9326B007B; Thu,  4 Dec 2025 10:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0816B00D6; Thu,  4 Dec 2025 10:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF326B00D7; Thu,  4 Dec 2025 10:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 195D16B007B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:20:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E983812ADC
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:20:09 +0000 (UTC)
X-FDA: 84182149338.03.C4DFC4A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf10.hostedemail.com (Postfix) with ESMTP id B22EDC000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:20:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UdrZ+W8K;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28Khn9w5ufXYzjll8WqLV4IgXPs6hGDjeWtWQJw++zk=;
	b=F4T+nzY5qpnA7Y4o6wd6Xz+/zBaVuqQJJhdaMb7jaPYQTbxbjOvaSbuGvJmV6NGYndcCHA
	k74UcUdwgFuyAjB+9nlNJPat16h8rlF8uiiNOdLAOzNOe5bVG++/geSNEJ+9ZOhSPJSiyn
	khenO+6DcfuRoUyoYjSyy+z/HCPLsN0=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=UdrZ+W8K;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf10.hostedemail.com: domain of maciej.wieczor-retman@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=maciej.wieczor-retman@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764861606; a=rsa-sha256;
	cv=fail;
	b=xz5Tb9YkV2sG1Jx0HIZIBsn5Rwgqn1Tb4Gc4Vm++I0/Udd0EsN15J7xgAeEgKhapQ9Pk0P
	9C9voOqvQDq4EEVFzc6fUSr4WUWV3MsJfK4X/EbsDjoU2u8xD2oGy+7u21WHdxsFHO3nyx
	j8zrFA3HeTRdn630jEXvzqgTjlq7FfQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764861606; x=1796397606;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=rE2RJqbPHueVEsX8ZZgodjH4YwAtGot6ra3+7/wP+EY=;
  b=UdrZ+W8KCauN/q/RnhRuGbXjTwZBP97sr32kU9mS5kYZdMZ7wSHyMFy+
   kIoyAhyA+l/XgeKNc82jES1zJEx7lwT61nCGbhGhow6SXqXaVruGSpkto
   jZC0vgLCe+FJVfxNBb2SkfJElGXz0+b6BoJlSsNnn25zk63h/Hk+0L1Lv
   NSRNVm0rEcLm7dxMVj3ixrKpa0mDH/g9tvM69Qdwv8DeJyplY0cH7efF6
   d8jESzSg5ZidFay7y7DgGlmBZQTqu0bEjRZfFQmS7EsnuJj+1bfmzsv7t
   o4fAvmd7V9frQqWZnt30K9mxnq1A1lZY8l6XY3jDDFvBTdEcRwKTYxD9o
   g==;
X-CSE-ConnectionGUID: xU2GohQ3SDaqsP5S0gpaNw==
X-CSE-MsgGUID: p5hUZXKCSSebx66KqFkIcg==
X-IronPort-AV: E=McAfee;i="6800,10657,11632"; a="65881475"
X-IronPort-AV: E=Sophos;i="6.20,249,1758610800"; 
   d="scan'208";a="65881475"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 07:19:53 -0800
X-CSE-ConnectionGUID: hLYUHxEDQbWi4LjJuGUgXQ==
X-CSE-MsgGUID: WSaNca4tQVWUznX0u52pnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,249,1758610800"; 
   d="scan'208";a="232346817"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 07:19:53 -0800
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 07:19:51 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 4 Dec 2025 07:19:51 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.12) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 07:19:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=a5tNp2OI+yR1CkP788tViZGrcb8mm5HdSW8M8TnpXAwoe4Vm2fieLkjTUL/wc1nocOnmHdSS4n2QDervyrhtepS+0gB+RVNhOtUclEVnoFrFvwBD5zF/kh12u9tfHTbEp8SiD9t5qMVQoQFZeY7ApVqnH8Rb8EdeCpCtD3yPt2vLwoPQp1CYscrQ3KPADmrU5kTdYxKYt7cd8N3geq0oITdEo6JiYmV5wxmFGbsBwkJu3aDzjhFBoUCZE7TTMO84EFQt96dsXX9g6P+EZcFBzD/DJl5ntufyTI1/3XBj/BjrQ1C5S6pkcbg9ubsDQYzmSGUI0odt9CYtHEpL9Z3Zcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rSnNiXkXFcSHefeMIiGZiuGLSX9u3caeyPTWyqQhMgE=;
 b=SFiyzmmBFYVAIkbkuiOn4r4CntmPfXDmhCO7+kUHL+d9MwoexgGszeE3+bbIdVv0Li1kjbFy97Asbu2lmtefvx81gRoYs+RofDMa9TNdnqsPIdairodZL6BZiaoLdzRE5NjMD9K4m5DpOU5b2yRrmKuWEpxBiRlBfFxaAZFyQ9aM8HbVJeyXE1xINtSs2CKgvYm+ZROddq/cDtTm7I/fc8O38dG+jUHp8cHlUg6cEBJmYDvrvUEZhd8BN68faEW7s/hPXMatBtOP3gs7Kx57TAgse/1AyIQ+n7GPuTLsrVEYbBxmrKgigURKqskCIiEpMgaxaBQ8/3g7I+33uYmS+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3282.namprd11.prod.outlook.com (2603:10b6:208:6a::32)
 by IA1PR11MB8863.namprd11.prod.outlook.com (2603:10b6:208:598::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9388.9; Thu, 4 Dec
 2025 15:19:48 +0000
Received: from BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19]) by BL0PR11MB3282.namprd11.prod.outlook.com
 ([fe80::5050:537c:f8b:6a19%4]) with mapi id 15.20.9388.009; Thu, 4 Dec 2025
 15:19:48 +0000
Date: Thu, 4 Dec 2025 16:19:41 +0100
From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
CC: Maciej Wieczor-Retman <m.wieczorretman@pm.me>, <linux-mm@kvack.org>,
	<syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com>, Andrey Ryabinin
	<ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton
	<akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, "Danilo
 Krummrich" <dakr@kernel.org>, Kees Cook <kees@kernel.org>,
	<kasan-dev@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] mm/kasan: Fix incorrect unpoisoning in vrealloc for
 KASAN
Message-ID: <7tpdpvjdcfcujdlkartvbx5m3ngqanwa5brclxnytsrzcvqc2a@n2mnvjtmpzuv>
References: <5o7owlr4ap5fridqlkerrnuvwwlgldr35gvkcf6df4fufatrr6@yn5rmfn54i62>
 <0FXl31cx1KiP0tp1scQSFD7bD_qTnsT7aWdk0JBsUiAkvTgsHfSfAwcqihepAd5R7TweJ1ClN8daEGlJzS8UCQ==@protonmail.internalid>
 <ef40d7bb8d28a5cde0547945a0a44e05b56d0e76@linux.dev>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef40d7bb8d28a5cde0547945a0a44e05b56d0e76@linux.dev>
X-ClientProxiedBy: DUZP191CA0009.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:10:4f9::17) To BL0PR11MB3282.namprd11.prod.outlook.com
 (2603:10b6:208:6a::32)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR11MB3282:EE_|IA1PR11MB8863:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d603882-5125-48d3-dd2e-08de33489014
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?l4Pua/1oXtlO3+fbYyo0rxmc8sErfGuvF4VxpjlMvkctVG5QDDi+Ul2miI?=
 =?iso-8859-1?Q?YXzZYRQkdRJ8PRkGyhcIekjVq6aooa/se0o76pzIHftbGXYc5bHX1WHgHt?=
 =?iso-8859-1?Q?tCRrHqY95ArQr2/Hv7haKGkOdPCsXJW+ZGQlQrJd884PPogvtzz4ykxKli?=
 =?iso-8859-1?Q?GypCQi4MxVQXchfOVO/+R7jNDkg1/EyTrenTSo901WSKhJI/TEdyzSaXue?=
 =?iso-8859-1?Q?eWJjnPH5VBem9RmIGMUaW9dsSete/a9dLpXQzTGtJHUNmhY7GS/jWpo+Lw?=
 =?iso-8859-1?Q?3N4il+oyvZ+o4CCHpR1Tk+CYXKAJNfSbhUHrr26zFE5RjHmq0eqTrOMPgx?=
 =?iso-8859-1?Q?jjEVPuQWnXlSP7g0hauXt7q2BwAABajze3lN1BiVueG9alsDTdQd3P+QYN?=
 =?iso-8859-1?Q?Sau/QTQ9AXH+7Yf6BLhNR4jyraZh9JjrQvqWiSp/PSxs8eKdjaROWKATvo?=
 =?iso-8859-1?Q?L3PrerYHHh+ljEJLOBTYbhsFWeOZQWOeBE+uZgIp2uqwVsL+hS9kzWm5Xf?=
 =?iso-8859-1?Q?fNmFU8EpXRrkBs/NENzhDym6F+y0an5wMgI56I2DBDzsetJ8o8dxK0S4qW?=
 =?iso-8859-1?Q?zOKLAM/iMYB81THdejnwhBzWA1MV/aJCSsF1VjBw+PGtsgE0/dTfd8mr3T?=
 =?iso-8859-1?Q?UE54+1HjAMta6TJjD3UNPgplEq6UpN7jVBDSC4beBNLXRMcd8iNnRYX38+?=
 =?iso-8859-1?Q?pAbUHdKKD9qz0Vkwc62HxuKL/pul4CbHZOrVAL8I9dJ5i9QqoKgRtPJZul?=
 =?iso-8859-1?Q?n9tO8zRJqaLKi0uawrFcfJbm/v+DtKyRo+4cpIw+DjvnliQ7BLHW8QLy3C?=
 =?iso-8859-1?Q?UBlomF0eFaHNoHZ5ySkXbuJ0zQr6G7lu+pQFSVWjsp/8hAH5GzJkNUgvMO?=
 =?iso-8859-1?Q?G2hfxFIL49scOgmhx9LQYp2A7JZACWuFQZZTDthJ1R68pdvy5b+e0H9wwH?=
 =?iso-8859-1?Q?OR9Q/pnnMijZXlrbykFzITISI/2nw8GzTOUTMvKMxUuLtRXB+TGnikelPR?=
 =?iso-8859-1?Q?cwnZ6ktPo8TQuEVMzZEyo7ZgTPKWvIxizPZIW25Lvf5dF/0DwDsV7KuPXC?=
 =?iso-8859-1?Q?yPJ4FUOzm0NwZWyE/NSDkv6OY9G0oYhJ9M97IAFdMa8dsss9PzeYHD02Ck?=
 =?iso-8859-1?Q?v6oIrkArnmjUTgGC2mQR7cnU8xBdQ6CEFHl8JM+6kYghm6bvkyiYDdPNY2?=
 =?iso-8859-1?Q?2ZFpS2t4kgMhaBvl2jiWE3CcJcG69rHysCIVurMHJ8v/odnqxbCjK2kOTd?=
 =?iso-8859-1?Q?lmOuyIRL3I/YSetgl8WCDCsXCxgK9Zv+FZx7AbHsfsXw+iHd+5KV5SlUVW?=
 =?iso-8859-1?Q?GMDrfjEooc4GfEERPHuN8Xkus1eJjyBDNchCcjVcpbfL2efE6wvZMWLs1/?=
 =?iso-8859-1?Q?XvHN+II0JOg6rRUqX7yYK+U9lrFPODgAPMojyblLv7BelXEqbbXjFK5yqy?=
 =?iso-8859-1?Q?xkbwmh8VIN4rOicN6Gf1MPTpwaa8fs1LztqtBg=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3282.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?CVtoohbERnyoqZcM+gCn9kx4INjPp7hRnBtlVP0/vlGxh5tO+0B+KuG/bQ?=
 =?iso-8859-1?Q?ORdJ2KX08NeUJl3Jb5QYKD+Kf8JdJ1zKYuR8MClf+sac6nZat1XuTIAb7N?=
 =?iso-8859-1?Q?d+/VExGTRMgd4U0dfZ86atLR5FVc6qamVJl07uHcbC7PXNz0IdniBGKNMQ?=
 =?iso-8859-1?Q?OmFkWGn8+NqSWe5xmDJdEcjfAuj9kPenhCK5WuY/FyvRsd76ofUyeYdNaQ?=
 =?iso-8859-1?Q?zsvnB91FgD4VyuGnx03fTtiIWGJWT5qivKwtHkVGZdC64F2I6EcW3N4MNP?=
 =?iso-8859-1?Q?B19rmiNBB1w723zZk4kzozRRyn7DIYpLybAgU67cXAGIjQBAIAi5purLMt?=
 =?iso-8859-1?Q?AM8UKP0QgokV2BywSgB9SyNQ+0tJihQc5Z3TGZ6C/nCqQBO1rD2ygD8MDb?=
 =?iso-8859-1?Q?VHO0yAq6EzdACfNlcOKiqovZvodNF6hguV9LC+2bh7MTop6trdsZ1gVrfc?=
 =?iso-8859-1?Q?WcbqaWv3dhDYRqV0kGVvsPtIT3weHcVu3vxsrfE6Y7UL7ex/47I4J+uf1e?=
 =?iso-8859-1?Q?dWdDEkKiAzFubkkfeCn0MpDRdp0aCpdNOnMYCKhmOfMDpZOy/4WqtkMEtg?=
 =?iso-8859-1?Q?KNgNGjvLe02oAkXJooMHE12ATmoJa2vJ/Gz2DVtsGBFs7zCWP0FNXGtOfj?=
 =?iso-8859-1?Q?zUAF2jdSsdpsXMWNcvaXxNuQppxC+y7fyVQik7xRcTMoX4xNJg5XXrzwPw?=
 =?iso-8859-1?Q?bseYvJZkyTGTg2rf7lPp5J1na2Z2fmYhCONbFKOqv0iQ0uZmhkuZk0ECO7?=
 =?iso-8859-1?Q?ePb++4q0m8sELLOs74xeI0wcW7YkfoMjCKm0VZXi3lsVKpOYlqusTBDf9V?=
 =?iso-8859-1?Q?R+hTvpDLw++tquo/d0gwljXiWyiV/xzvpXIMrVBZe5Cb9Do6/B/82wLfWy?=
 =?iso-8859-1?Q?ifOqJAsTh69ckZPhbhWuxkb8t0bIfWItVBvDqNovM4qxZZw9eqn8nct2A2?=
 =?iso-8859-1?Q?89D0uomuTpPnYiggNELtHFaXghjSZ2wDyRFlmpWXpyFB/lfzrccVvILSUl?=
 =?iso-8859-1?Q?j8ZlRbuS6GyI8LkOMRJPoXJdaaTZumU+GHdjdXTYUXmrNnQ65vvkdISTLy?=
 =?iso-8859-1?Q?uK1653RdD60cB3DiaCSaZzOWAV4SYjbd1Lp8q01E/edPM1NCKLZ6j1DPA+?=
 =?iso-8859-1?Q?LrGFg7qqpKCfFNr0R5MpJkXvldgieJ1p17CmB136CgBYUZf8xou3z95hmX?=
 =?iso-8859-1?Q?y0jtMqZyKBfHfqHmtlnz0YvIcIbVs7J/Xe4v5qYqZN/fPXXJzxP9W/b+cD?=
 =?iso-8859-1?Q?p7cNstr9q6Xu0vNof3On7Pc8GFYyj+hb3JzDsxk4LWE1g8LrBOHod2p+8G?=
 =?iso-8859-1?Q?+QeRBHXn2mA+h8Nax6voCjXzk54leHjwiaFJnlotv2V9gYDBhGHQBng1oE?=
 =?iso-8859-1?Q?THUPuzD4kn+DPU54aQ+pvpqVtFJSgHA/PiU0l9SPgFwpovcppus9SUz9Pu?=
 =?iso-8859-1?Q?9P6dpcyASYolGeP7Sjqg5KDevjgA9BiYMz7If75VKPBntEsKGOA7naqt0F?=
 =?iso-8859-1?Q?WS6DTbwaUZW90fNOf4mGZmUNWAoZIzCG+kiMOdPscC4uf1IWp43vFr8aoW?=
 =?iso-8859-1?Q?OwbpKCjWQIyNUXXW4Aqd8apGhzy/KJqonN1enyI+zyYYIXUSt6Xgm1wKmY?=
 =?iso-8859-1?Q?eKcUtQPRhk2DKrG3PX8sgtkfdIALpPLzcYISatj4LU2Wn7d1Bt0qHd/U/g?=
 =?iso-8859-1?Q?FJBXi4rE7bwdZbC1N2s=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d603882-5125-48d3-dd2e-08de33489014
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3282.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 15:19:48.3214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mZwfaBh1tOet3hB12DhVGSKeqhROKFI/1QEdnbjDe5l8kQVr5xb1NIVZy32+Qi5CbKor79K8r6H71AR+qjOJTnvani1oP+hUoknZHKtWdkQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8863
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: B22EDC000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3yws9ir3jkxmh1in7tf1e58rp4nxecom
X-HE-Tag: 1764861605-4576
X-HE-Meta: U2FsdGVkX18Owuk1/GTg5RQ/ZBqkBY8KxbSmhkpToqM+xOwyK0UGt7TcmXYUinrhfnBs31i+0Ra7rBrYeElrDWGwzaCLfwTUf7K/RstV9ddZerdShqjqBaG1axgVDAtferI1DhUD+qnJyUGiNQQ5olOlMilnxMXwleSsA3rPFKulWTrIDvUFlu79UeuhmgG/FhqyIDODYlLRpdy+fT8AsUUaY8OUNSBpKFabOz/TKnxhg8qabj5KTw6yBgxHSs2kZ5Y5aJeV5MwAWJZ4PVPrlLDtmR6hYcRHguP2LqmKt4SFRGTk9vjZalPZApKq6l+ml5sKzlfWsKvRuBdiIkmkQMWfkTCy0h0KE9KOpsoamaN1WdGFsys4gw/DtkBjsNMyihe+Fmd0IBfAzoCvjOihFwGtcCjsIyTS5NOu0G/c8K+P8A3UO4kUlEF/R7Iean90s1V4Bo+eBYVE54Df6f9aVRwOYk92Xag32SepZ951T75SwBcqXjDD+UQ+meXuWO/Bk4YNF6h/W3bQCNV7FED2zGWjPEMy4c2zUyWEs/Fhi48672LKv1GFAP7j5X14FL1jakV0TFmU6KZZvwVeY/wj0hkrxXaJhVQutWHYhcgN0d3aFnhbhFgJqNCUd5ttHE5vU9CAnL2DZ40S6wJtG2Cg784Ex/2UHfYmN2G8YRhIyQtCDVtvgIafjr6j+KLswk4mPvLSLfFJ1nmVu0J9Za10Hlat3kld2fECg5Pnmt4I4wSrz5Kv2pFhPH1aYhSTr7g2pOHDLOKzmo2CVhKhRsF98WwgnT7QpStpqsgsffCfo2DqeSOeQFIZMO4XA59FL8UKXgq05ZCh3LZm1phX+GiPgXxZ1VKluFGV5Qh0gz83z34vEFgVai+ulu9DsGNiv9EvKxmc1PzoDxsJPtwJd+lHDqLshVHDHmkUuFLx7uDD2fyDcx3NY/6uubeosUerJbpqTszvcyUlzP4eTet7Ky5
 5/Cxq7lI
 1qSAPKomcEKZV/keEDJgWxNfkKFHdNWPcpNxME64nXt+QIMUOnTFLNV/eKVM1nQRKy70vqUEc/8kNzcNQBHHbnPFKPDrjnVYAiMWYHA0cJS6A2LI/5l2gsgPPHzSRJSuZs94vZmHeNLx0Q26O/Rn35hYg8Yfl4toWea7Zkc9cgNwSHvwGcYufaqQ/zkh9BKV4ifVxqebvqPOosNTLvqP+W1V+IPHhOPU3fBYp/MsbxsYn+dBvGOv+RQU8fpLu4zqJlSE62adGZL62nK+WLIPZqjAPNY+ToH8cj1JKI6pbIypmVhPbn8hW/klx5v5yhZAY7LrxdiQJ3gwwkkGunFsdWHXK8TKvTERJTXJ29FijTkEhV6KhOyU+CCW9NylddJ7MtcK90NxL6UUGBzNXjusBn2gNh7rt92OSxZ22G0QYVRwmYh2iTf/wb/hAMiT7Uoek5K4dWvr2TAbuuSjSzK5Kmj96Ortz1+iLrMEmNgtdqiu54JGblN3xzDmy7anj3gDILmEx7EkfaYDUC0MQeEpaHIQ/NRix+cNQwiJ0llR3R46AshacOeNKZj3v4Yl4UaDq1RByAIgeXHwlHFbJ0gvwH2l445YBUBIuOLl+QyPrdvQZVwkcSTEjC+XJfcouyH8lPsx548OdOrMEFzQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-12-04 at 14:38:12 +0000, Jiayuan Chen wrote:
>December 4, 2025 at 21:55, "Maciej Wieczor-Retman" <m.wieczorretman@pm.me mailto:m.wieczorretman@pm.me?to=%22Maciej%20Wieczor-Retman%22%20%3Cm.wieczorretman%40pm.me%3E > wrote:
>
>
>>
>> On 2025-12-03 at 02:05:11 +0000, Jiayuan Chen wrote:
>>
>> >
>> > December 3, 2025 at 04:48, "Maciej Wieczor-Retman" <maciej.wieczor-retman@intel.com mailto:maciej.wieczor-retman@intel.com?to=%22Maciej%20Wieczor-Retman%22%20%3Cmaciej.wieczor-retman%40intel.com%3E > wrote:
>> >
>> > >
>> > > Hi, I'm working on [1]. As Andrew pointed out to me the patches are quite
>> > >  similar. I was wondering if you mind if the reuse_tag was an actual tag value?
>> > >  Instead of just bool toggling the usage of kasan_random_tag()?
>> > >
>> > >  I tested the problem I'm seeing, with your patch and the tags end up being reset.
>> > >  That's because the vms[area] pointers that I want to unpoison don't have a tag
>> > >  set, but generating a different random tag for each vms[] pointer crashes the
>> > >  kernel down the line. So __kasan_unpoison_vmalloc() needs to be called on each
>> > >  one but with the same tag.
>> > >
>> > >  Arguably I noticed my series also just resets the tags right now, but I'm
>> > >  working to correct it at the moment. I can send a fixed version tomorrow. Just
>> > >  wanted to ask if having __kasan_unpoison_vmalloc() set an actual predefined tag
>> > >  is a problem from your point of view?
>> > >
>> > >  [1] https://lore.kernel.org/all/cover.1764685296.git.m.wieczorretman@pm.me/
>> > >
>> > Hi Maciej,
>> >
>> > It seems we're focusing on different issues, but feel free to reuse or modify the 'reuse_tag'.
>> > It's intended to preserve the tag in one 'vma'.
>> >
>> > I'd also be happy to help reproduce and test your changes to ensure the issue I encountered
>> > isn't regressed once you send a patch based on mine.
>> >
>> > Thanks.
>> >
>> After reading Andrey's comments on your patches and mine I tried applying all
>> the changes to test the flag approach. Now my patches don't modify any vrealloc
>> related code. I came up with something like this below from your patch. Just
>> tested it and it works fine on my end, does it look okay to you?
>>
...

Thanks for letting me know, glad it's working :)

In that case I'll go ahead and post my two patches with the vmalloc flag
addition. And thanks for pasting your code here, I suppose mine won't conflict
with yours but I'll check before sending.

kind regards
Maciej Wieczór-Retman

>I think I don't need KEEP_TAG flag anymore, following patch works well and all kasan tests run successfully
>with CONFIG_KASAN_SW_TAGS/CONFIG_KASAN_HW_TAGS/CONFIG_KASAN_GENERIC
>
>
>diff --git a/mm/kasan/hw_tags.c b/mm/kasan/hw_tags.c
>index 1c373cc4b3fa..8b819a9b2a27 100644
>--- a/mm/kasan/hw_tags.c
>+++ b/mm/kasan/hw_tags.c
>@@ -394,6 +394,11 @@ void __kasan_poison_vmalloc(const void *start, unsigned long size)
> 	 * The physical pages backing the vmalloc() allocation are poisoned
> 	 * through the usual page_alloc paths.
> 	 */
>+	if (!is_vmalloc_or_module_addr(start))
>+		return;
>+
>+	size = round_up(size, KASAN_GRANULE_SIZE);
>+	kasan_poison(start, size, KASAN_VMALLOC_INVALID, false);
> }
>
> #endif
>diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
>index 2cafca31b092..a5f683c3abde 100644
>--- a/mm/kasan/kasan_test_c.c
>+++ b/mm/kasan/kasan_test_c.c
>@@ -1840,6 +1840,84 @@ static void vmalloc_helpers_tags(struct kunit *test)
> 	vfree(ptr);
> }
>
>+
>+static void vrealloc_helpers(struct kunit *test, bool tags)
>+{
>+	char *ptr;
>+	size_t size = PAGE_SIZE / 2 - KASAN_GRANULE_SIZE - 5;
>+
>+	if (!kasan_vmalloc_enabled())
>+		kunit_skip(test, "Test requires kasan.vmalloc=on");
>+
>+	ptr = (char *)vmalloc(size);
>+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
>+
>+	OPTIMIZER_HIDE_VAR(ptr);
>+
>+	size += PAGE_SIZE / 2;
>+	ptr = vrealloc(ptr, size, GFP_KERNEL);
>+	/* Check that the returned pointer is tagged. */
>+	if (tags) {
>+		KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
>+		KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
>+	}
>+	/* Make sure in-bounds accesses are valid. */
>+	ptr[0] = 0;
>+	ptr[size - 1] = 0;
>+
>+	/* Make sure exported vmalloc helpers handle tagged pointers. */
>+	KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
>+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
>+
>+	size -= PAGE_SIZE / 2;
>+	ptr = vrealloc(ptr, size, GFP_KERNEL);
>+
>+	/* Check that the returned pointer is tagged. */
>+	KUNIT_EXPECT_GE(test, (u8)get_tag(ptr), (u8)KASAN_TAG_MIN);
>+	KUNIT_EXPECT_LT(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
>+
>+	/* Make sure exported vmalloc helpers handle tagged pointers. */
>+	KUNIT_ASSERT_TRUE(test, is_vmalloc_addr(ptr));
>+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vmalloc_to_page(ptr));
>+
>+
>+	/* This access must cause a KASAN report. */
>+	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[size + 5]);
>+
>+
>+#if !IS_MODULE(CONFIG_KASAN_KUNIT_TEST)
>+	{
>+		int rv;
>+
>+		/* Make sure vrealloc'ed memory permissions can be changed. */
>+		rv = set_memory_ro((unsigned long)ptr, 1);
>+		KUNIT_ASSERT_GE(test, rv, 0);
>+		rv = set_memory_rw((unsigned long)ptr, 1);
>+		KUNIT_ASSERT_GE(test, rv, 0);
>+	}
>+#endif
>+
>+	vfree(ptr);
>+}
>+
>+static void vrealloc_helpers_tags(struct kunit *test)
>+{
>+	/* This test is intended for tag-based modes. */
>+	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_KASAN_GENERIC);
>+
>+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
>+	vrealloc_helpers(test, true);
>+}
>+
>+static void vrealloc_helpers_generic(struct kunit *test)
>+{
>+	/* This test is intended for tag-based modes. */
>+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_GENERIC);
>+
>+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_VMALLOC);
>+	vrealloc_helpers(test, false);
>+}
>+
> static void vmalloc_oob(struct kunit *test)
> {
> 	char *v_ptr, *p_ptr;
>@@ -2241,6 +2319,8 @@ static struct kunit_case kasan_kunit_test_cases[] = {
> 	KUNIT_CASE_SLOW(kasan_atomics),
> 	KUNIT_CASE(vmalloc_helpers_tags),
> 	KUNIT_CASE(vmalloc_oob),
>+	KUNIT_CASE(vrealloc_helpers_tags),
>+	KUNIT_CASE(vrealloc_helpers_generic),
> 	KUNIT_CASE(vmap_tags),
> 	KUNIT_CASE(vm_map_ram_tags),
> 	KUNIT_CASE(match_all_not_assigned),
>diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>index 798b2ed21e46..9ba2e8a346d6 100644
>--- a/mm/vmalloc.c
>+++ b/mm/vmalloc.c
>@@ -4128,6 +4128,7 @@ EXPORT_SYMBOL(vzalloc_node_noprof);
> void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align,
> 				 gfp_t flags, int nid)
> {
>+	asan_vmalloc_flags_t flags;
> 	struct vm_struct *vm = NULL;
> 	size_t alloced_size = 0;
> 	size_t old_size = 0;
>@@ -4158,25 +4159,26 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
> 			goto need_realloc;
> 	}
>
>+	flags = KASAN_VMALLOC_PROT_NORMAL | KASAN_VMALLOC_VM_ALLOC;
> 	/*
> 	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
> 	 * would be a good heuristic for when to shrink the vm_area?
> 	 */
>-	if (size <= old_size) {
>+	if (p && size <= old_size) {
> 		/* Zero out "freed" memory, potentially for future realloc. */
> 		if (want_init_on_free() || want_init_on_alloc(flags))
> 			memset((void *)p + size, 0, old_size - size);
> 		vm->requested_size = size;
>-		kasan_poison_vmalloc(p + size, old_size - size);
>+		kasan_poison_vmalloc(p, alloced_size);
>+		p = kasan_unpoison_vmalloc(p, size, flags);
> 		return (void *)p;
> 	}
>
> 	/*
> 	 * We already have the bytes available in the allocation; use them.
> 	 */
>-	if (size <= alloced_size) {
>-		kasan_unpoison_vmalloc(p + old_size, size - old_size,
>-				       KASAN_VMALLOC_PROT_NORMAL);
>+	if (p && size <= alloced_size) {
>+		p = kasan_unpoison_vmalloc(p, size, flags);
> 		/*
> 		 * No need to zero memory here, as unused memory will have
> 		 * already been zeroed at initial allocation time or during

