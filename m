Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59840D0E6C6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95BCE6B000E; Tue, 25 Nov 2025 09:46:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90B9B6B0012; Tue, 25 Nov 2025 09:46:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD146B0027; Tue, 25 Nov 2025 09:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 627996B000E
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:46:42 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02435C0195
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:46:41 +0000 (UTC)
X-FDA: 84149405844.05.75F9D73
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id D216440008
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:46:37 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="oLCYG/Eu";
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764081998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=+qR4Yo/KMXldibYCtJ3UzjUOgw514LwbszhHBzPYmPg=;
	b=lmm4N60knIulivKj+kRc9yToJ5wbIf4AsRKR/DODO8AmNUE+xnqL/+ws7Rw/4YE158N31f
	YKRYi0upYUwngiXRfxj+8L1UDjaCUINReBH39zAnloe7OdOyL5YrvaiEGEJM17stUcu8Ch
	3F3IiJSYBUX+MD7cplWtnawnoiwbKiw=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="oLCYG/Eu";
	spf=pass (imf17.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764081998; a=rsa-sha256;
	cv=fail;
	b=VYeGftq/kfYKlJSezSwUuLRg+gl89aCAv6EoDXTVp9/RtIj04lYaqVtvZGfIWMntbtp7bN
	2x6En0dFguzK6Z0Gb87Agd9CbsgBORWuqMBEWn0jjpSlXiA2msJxa7xAikI6c8Scj09wxg
	u4pxHXRv4qC3Bn6DpBx/lqFFPWR5N4U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764081998; x=1795617998;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=q/7Suzdfrbwr7zlw3ABcNNpJBt58JAWRkUSYxR9/Y8k=;
  b=oLCYG/EuUD29WzX2PPEzXoRIN7iCCgIt00EXzmmhctAOQRvShBlVp1W7
   11WOHBTgEBS0DdkacK/iq+Ko+R8E4Yo3PLJ5E3nchP895rc3zz7TTFToI
   nxT3WDzurXASZumXN+F0p2j51iE86RS9VanWxD7x7PDsLii8Rp0uknhHu
   ZtH6klOYLwWJ/Xpf8+CgoxudNLG3yEaIWcnumHS8Ux642OGWtRF5KLyMu
   eLfD+Fvj7QW1JjWfdgvlw6GZ0tCtDm9WKxSOQ1MhlbCipk9YN7EshU023
   8IVwSrKaZFZ/xx/a66Td/EaCUu6jyCSSv3lZXLQtJZzsDTw2S9g3fOHGB
   A==;
X-CSE-ConnectionGUID: SEnmY5ocSpiYvCZauISOBQ==
X-CSE-MsgGUID: Zf5Y9GyeQdKLLKWdZO/d1A==
X-IronPort-AV: E=McAfee;i="6800,10657,11624"; a="66136423"
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="66136423"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 06:46:36 -0800
X-CSE-ConnectionGUID: Orhvoxr/RWa+54xSPynrCw==
X-CSE-MsgGUID: E8hKjrP/SJ6v4Hrl/wTxmA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,225,1758610800"; 
   d="scan'208";a="229929828"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2025 06:46:36 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 06:46:35 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Tue, 25 Nov 2025 06:46:35 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.56) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 25 Nov 2025 06:46:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Rp03qALvF6FNj+KtASMt/a/1OBik40Ez2LEgVRMyyNtpn3PD5eE4VWHaUosBMeIRaBoPFzzASc23WUUzR5J4umUwkZHx/xGWLo+ciEp8I9AdR7CQW/neb/hB+XRr+Up865bbrPE10VhD/PbUB+oRe2rmidmLn0bQKrpsItzjHS+tC0LS5WQFrnzoLhkpe5mnj6F79iwqP1BWKQmEa9ZrR0jIvGCX4TfDjbXHanecRYVMZ8UIb/bwdacSCEAcWdhx1CFR9gtXzlGqbT5iuX+VnvYuHgsP2GsS+nBlnvt+92ertqENQjJ8AhPElOvo5Wa8DDJNhmrzC9euknXM/jgWSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=x+m5HZaOtxuAKuYGJ03GrJMImEzr2cGV5NKsSXVqITQ=;
 b=JL5VFGjFF4Mn5Gngc2N+xSxuUrlGPfemfzYe/1hI4zx6gszlSvXlN1n0BKY1AX4e1zqTHZppF4pwHTrT4V326aNg47//loAcSujWpSmU37Y6pdNWKMThsQdEiZ6aZOtGkBpS9pKdwZo7dwZV+7LvOUhQ70VaWWEqEfN36ZHuDiTR2vdWGmx4b/l7Q+gbHL96MHmL4S4Wdvq5dkvHmZALzC+jhFsbhfFuse8wH3LNqL8PxgtzOOiRD75HWexDhS+vOVknDAYvmb992Z93Z8V6eNMXXh97vyykSShDjpz7nqMLPF2rgZfXOHswR+emgWVCRaWsIFiZZoQqHcXKFUvSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by SJ0PR11MB4878.namprd11.prod.outlook.com (2603:10b6:a03:2d8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Tue, 25 Nov
 2025 14:46:27 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9366.009; Tue, 25 Nov 2025
 14:46:27 +0000
Date: Tue, 25 Nov 2025 22:46:15 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, "Sidhartha
 Kumar" <sidhartha.kumar@oracle.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang
	<lance.yang@linux.dev>, Liam Howlett <liam.howlett@oracle.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [linux-next:master] [mm]  f66e2727dd:  stress-ng.rawsock.ops_per_sec
 46.9% regression
Message-ID: <202511252236.33b899b3-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: TPYP295CA0015.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:9::10) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|SJ0PR11MB4878:EE_
X-MS-Office365-Filtering-Correlation-Id: 4aaa7acc-1fb9-4370-d0da-08de2c3169ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?BHyhozm6/0/6WNsgfdX9go06vtnSQUYAs7BBf3OT9iRjg3I22b+ZnAlvNy?=
 =?iso-8859-1?Q?Hy66LyG/+ZFgY4pFKb6YdsIEG87RL3XziIGtoEn3Bges4EoBtoXmu7RR4h?=
 =?iso-8859-1?Q?BA6kk63BzN0GnyHTsm9UykAhYvzOd1Sn5nW7Abu7g6B7lo9yDNAKftgaJf?=
 =?iso-8859-1?Q?xeXauxgMdEEMDGBB10Vx+R+Y3EJDtvK/RpH5tWqx9ngwZKvn4WrLkOxssE?=
 =?iso-8859-1?Q?msP1SmsC0xaWINISAfpOKnQJ/krhCuOoSnJPRa8ok0nCqn+rWvgERogGej?=
 =?iso-8859-1?Q?uZIEtgro63lWL5jzleReoA1o4GxjqZSXrecvH5F0C0bBbBfJkwf7jT64Pj?=
 =?iso-8859-1?Q?Mv+WSPmtqh9yyhovaBo0bDe4x7RJX6wOcfD4mfzsJB7SAM8wzFr5rT39GA?=
 =?iso-8859-1?Q?j/YnhZvhJdLU5PoBWYeJ9moqEZH2K/UTI7CcmtsJU74G/b5ix5+3YjqRQe?=
 =?iso-8859-1?Q?FFeDrVql1p0Gt3WMxnIle7KTlOkjP5xDc39ChiaKL7crWJ83z70VhFr2AB?=
 =?iso-8859-1?Q?2Vvt5fum0UJ9UM4sAr4KRUQOOAClgyJZrx69B9MzrPME59oP+XIGMqMpQw?=
 =?iso-8859-1?Q?2MEpZES7VWBwgLQQ3z0fZJuy4ClbSR9zxZ347zwox0hKPvvhMbF3Xb7Y6r?=
 =?iso-8859-1?Q?qeczNIZonSO4On/LZmoIplE6fMI16UQclHeni+/CcJKsFwcJ9eoDxL5a2W?=
 =?iso-8859-1?Q?KsDOIkmLFSvvgOMgkQ5wU45sz65Np0rtSwXNCYQAJABLLdhG8tIggSgnJC?=
 =?iso-8859-1?Q?wCbh/GolNmkZ4jUdJqb2hH8LZLk+BsysWS6HzEFW+huJsm35nwcQJlMQA0?=
 =?iso-8859-1?Q?IU3cFWK4mLXpD2e/cvi0o8LE/YgQ32AKXkjhrQ/Qfu1aB4aQMYhAhJg9oA?=
 =?iso-8859-1?Q?lMpBddkQ3aVoaeh8D5UYj+AWm1cZ7XR50ytmT9KDmLRegyKRHWM0mcTR7G?=
 =?iso-8859-1?Q?y2jF9a35LsEh2Dl+yTt8PBIvhSEOXqsgzcF0Y7OL+FPfKsp3hbhZ6epR0v?=
 =?iso-8859-1?Q?oB1ObUUAuyASlag+EVhz5fsRUFCTc47atLfboNbzZDolkN1dJfWkCIRgly?=
 =?iso-8859-1?Q?BqVA5S7BLZPLbrsw9x0Cn2/0APj6zs6+znQJnrfNUFHVCdp5pn/v60CfT6?=
 =?iso-8859-1?Q?05ybAUTE139FJ+itFQxo+6qdfjTCNSpn5mYA7AGmVq/XLVNkzBHWCwo2Vk?=
 =?iso-8859-1?Q?YZM7KEbRfCeU6ns2tcCe0OgrWfErqODqPZK7ofRUITLrtStdYQmwGIizEn?=
 =?iso-8859-1?Q?HEKcoCLR3drO4oqMGgw71BfHe629ydO/TsOB2RCunwsRYhVxfrkDPcfq+A?=
 =?iso-8859-1?Q?kQx7wte1EkPJ+w7ds3vL7ZvyTz7+ajFyNpq7nyF73nzsd+tBmyEqjAgo+H?=
 =?iso-8859-1?Q?rXNQSI7ayAJiEGBABGY0CxC9JgVtpgGWem20Jx6FYjTfXAi4E/wrJ47NTs?=
 =?iso-8859-1?Q?GwC+0TiCXfgpMZmfjoZfcL+2LDYRf5egkOYaH1vYQjLGOJRlULj3N0p5H2?=
 =?iso-8859-1?Q?ruXXwe74Y6Yutme+rt3JEWNMztiLJBghm6oe31Dcz3iw=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?HLgW6ZIPjx4FnQ5KgA/JRkit3/AcoO+NbdmnYRCwNzQ7VmXE84qoTbS5mC?=
 =?iso-8859-1?Q?HTC/0tKqcI7Pu+O2BSePL1Lj+6ADj5RCnOqEyLwcm+Xu1YaF1zFICinTR+?=
 =?iso-8859-1?Q?ngNOASHLDOn21JKz443iVtTHyxINeE1t7AnRsW+czgwG1FX/j/eavx2AKW?=
 =?iso-8859-1?Q?gShGYvoNXbmY2hrDI002StmDQJBHwPdQcGOMhZ58u6Xg6rBwE8RkLFLCQQ?=
 =?iso-8859-1?Q?vsoqWEPklevdXxwaZ7Jxap8UWwZRX0wV7kjyi4pMLRbTwsThUpibCp+STx?=
 =?iso-8859-1?Q?+g3RDnCSGKUnudPXh4rcKh9MaOTLa/g1ggB3kB+PLhFHT81kd59oQbpTO9?=
 =?iso-8859-1?Q?du5OiggCf13zcLeq0XIZC10KhEuDpeJ7D3wj+0SzTGSlWLHfg8ArDXRVgK?=
 =?iso-8859-1?Q?CSFcExseuH6F/183bUrDtxBKGDpUXP3njc399OzdgIj0Yix4DhzfBg8MSS?=
 =?iso-8859-1?Q?oRnnLOipkTsXDOEowxNvi9cJmN0On/VOqHwZ7ENR4DDwsUJzGO1RgGox6N?=
 =?iso-8859-1?Q?dBktNsSGzVnLg3xx/o3gBvVED3krtjOELJQsUK/E6I6DDKJ8mYYZKXImLF?=
 =?iso-8859-1?Q?Qg4BrFk2w9AcF/7q01hJqwwFwgEvJZILWfeNnim6cu0c7kfrGmwARr+J8N?=
 =?iso-8859-1?Q?Fa1lywugKTTzEtAT+KqX+Kj0GIpxN7g3MqIa8GEH4bfqKMP4jjfhuKazyA?=
 =?iso-8859-1?Q?hqS++5FKtnyCovm8TJewtQ27yoeHc2QIdXWp1CbhCZxEMQwXzWnQmda0fx?=
 =?iso-8859-1?Q?D+P3EpPbF3tOEGu/yf1BtOvIUf30mnDFY/6jJXr/PtEWmYE1G6AA/fh4E3?=
 =?iso-8859-1?Q?On3mWZVkHCTPivMsLrDvNsQ98zdkyeqz+oArB73PuLWRedpGItgcRtCKrq?=
 =?iso-8859-1?Q?G/TbBs5uSwj/NcWsmA6br2lbmByghAIX9BxK4eiQw8osxTfd7gTLNq3RXo?=
 =?iso-8859-1?Q?ovfa8C/LJwbv2GyiQx4oR9DRX+0F2dGxDbgWY6ZQMO8LvT8zumY/Zjai5J?=
 =?iso-8859-1?Q?bODhcNbn36E+b6/Hv/p0n45naIerHBwJece8AhMEB1HlcQrhHsks08VGpa?=
 =?iso-8859-1?Q?CWEzGMplLRhY0jzOnOTFIeRGhmq7VQTW11l9nGvCBtY8TefEzL5ADUTjN8?=
 =?iso-8859-1?Q?3Xxj1K4vE54a5nbS4sdYm4oiS8rl37rLIdFre/iG3n34B/p6BAS9eqH69W?=
 =?iso-8859-1?Q?kTGAMihqEMDW2Fm42h6ZsRS5MqBJyU5nt/t5XXtmeq6eYu+kKN6M9its2V?=
 =?iso-8859-1?Q?a1/ZCWJja206U7JRjHP3O83v9VTCDo8Xg/j5NG0nw/0lSl/DW0JbUQ8l2o?=
 =?iso-8859-1?Q?Xp9C/9UOfEZrS2eKg9AYgO9FIxcRw7bGKJn25HqIG97aJt+wUnKYHoLPth?=
 =?iso-8859-1?Q?iETHozH8eIQdQgmbmLK5huFUmyyemdV4wmPhQGqSWizK+dEj3nnNjNrKuR?=
 =?iso-8859-1?Q?TLCO4tCTjcnt/aK440gR7vGjbARI0vnLLzRpBYi6bJ2yzf7UcAGZ6kkp8H?=
 =?iso-8859-1?Q?7XLvXOxBFLXr/JgWMRYxrrOWw1xvHjgrq673RUudFI6OTYMRFee3CY1/kY?=
 =?iso-8859-1?Q?KLJL7v/L3/d4pCS3IN0vWjp6vqrhiJfWPc+q6LmM5aBqzO/RIocetA6rdH?=
 =?iso-8859-1?Q?gjTld3TWuqNIzWyBOnlUivv6ko1iSsMXajpabJKixEUXsXKB3g26/7WQ?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4aaa7acc-1fb9-4370-d0da-08de2c3169ac
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2025 14:46:27.3822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUxfSIONrYs/1510cmibDtJuoXWHaW5QPlC88Nc4ItUgGcEret09N1WXRyjUDF9FxSOqvBZ6V6hik/sSrKz6EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4878
X-OriginatorOrg: intel.com
X-Stat-Signature: m1m9he1w337mwtp3oknk94mourth5kup
X-Rspamd-Queue-Id: D216440008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1764081997-377151
X-HE-Meta: U2FsdGVkX1+KqNcXvshKNZpvtQBvuSp7HDXSiNrU70oi3BJFRcVxdziS79HtV+J0gvUgbgI0PnvLM3bvu5BxxNjBxfELU7Hf1RCzhB6wg1jXWp6zXIC0i3jl9RzY1r5O5N2LEV2CsUO0kCJZ4+5S19AaConbl1mmtAfrgCN0BhndpBT2BMxqrHQQSMHMxnnXQgVm9om5x5kpmGBhxfZ7OMB7XLxvbxmk16ljqMsNq7TLhootQsEBmHO9/mBNU/q9L//7UOYh1r9gpTAPX5O7bSSR0M77eB9P8poJdJwF8ecsumbGS8FllyRsxQajerGHvmJkVQxMbeSZfqPY04xSVbH3XpwT/qUUDoVqhyqnHr7SL2IANp2q9VGxeEHJiEAuSa7/KDeEzB+FAh4wXojCu/ngN7KzUrNfOwuKe4Al2AXYY4d1Cldv0HiLePcnVTVceAnimG2txeCyCnRyzWxWsSVz5NrY+2iXudJuwGFMgnj0061WCm03jEfqpgDDCtm2bzZZ0DS/sy2TVzeZUnHA7H10k5blMQb45XyobIivM/w8kNArt2OsMS1XS97TzjG6p4m7LuW1E6+4D0hbnQMSsip6o2t6jOguj2EuI9cY47X76umXAeX/ICjabH/LL7eW+2J9p2htQf+6wrdRmY/Wrt2W8KLpX+HRvKUnbfo0yqQxR1gX+CdsUCbd5jPFeBc/dLn1kZZ/7px8FN5yvD/wFzrLnIR2gaJlL2lgQ0/TDYrxwHGbkOa+GFVX/b8m1+myJp0umYnxrCboSWxUEFEU/uAzZ8m2W02VCRIJA2Fy1arDpi0mytfi8E4VWnY+8chBwtWmxI/+o+cKz9MDBoZuxLkaMydN0pIp8URPA5jtEMZ8toLjzzBLumsFh+JBdpGtDTTQqMhQIRqaBbDuwAc9VzIGD+FLiPRHVngEG+SwCYdAAuIroIq8c0cwB1CMGWPxnRYhl13M5Fw/fCE/5iB
 Pi91smxL
 EdMDBBfN7wnAHa04Q/9OkSDltRs4DVPHSXY92IdFjDPoBtZF+6dRo+iN6xNq7w6EuoE/uJi3fTibzbFyLF0c//KzsGMfWRLsw3M4d4s9X6HRp5sIgGbef/DqFykp8u8RoaZAl6qdE2wZobvPuVH7akdYOgXwjZh0v4ocAsoheQsIs+s/RzzUMzFy8A0j92nQ3zdsprZdPO5q86p5jvHMRqG65KZWXULnC3W7K+ps8wK0k8pCuhSM/BFxEHBCssRc89/ju1YqONTIV+v50KJtgD0WfsNfxR8uKJzRqQeDCooWFsliOlKTIldGuMqrLUylKk7QIKDHFUyL5TdU5z7WUgtJ6Hs6trR+J0G5XdP0TB0JSL/vXvttffRV4Rl5+WKWRblsgEdRxreaHYPg7hfMiw6PQTO3oC8pcd/i4IgpJC8wSnn59WOW86vKVLRllJuBRvd3dwVUXDuPTzndw2KT7ZkYQL4EDL6wWXRZsQO05CsKlJudWafzVRVgJpbFEqnRP1v0Uws8ouFdEcTFpfEpQCwvZKpH+g56K2RtbnzNj2SLEJMQnINXKyoD2KXbU2KMYjIEvbNCPkjZjcngJMscv28wcr7EgsrWi2S+LILNi9n+1iWwkxKnRJ0QrvsjTme4xwE5T0i9vDDQ7CPQgF82JzIg3t5QGTMV5i3AomJpGsx37CKo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 46.9% regression of stress-ng.rawsock.ops_per_sec on:


commit: f66e2727ddfcbbe3dbb459e809824f721a914464 ("mm: huge_memory: use folio_can_map_prot_numa() for pmd folio")
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git master

[still regression on linux-next/master d724c6f85e80a23ed46b7ebc6e38b527c09d64f5]

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) 6740E  CPU @ 2.4GHz (Sierra Forest) with 256G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: rawsock
	cpufreq_governor: performance




If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202511252236.33b899b3-lkp@intel.com


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20251125/202511252236.33b899b3-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-srf-2sp3/rawsock/stress-ng/60s

commit: 
  ca43034cdb ("mm: mprotect: convert to folio_can_map_prot_numa()")
  f66e2727dd ("mm: huge_memory: use folio_can_map_prot_numa() for pmd folio")

ca43034cdb224131 f66e2727ddfcbbe3dbb459e8098 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
   1569273 ±  5%     -10.8%    1399094 ±  6%  numa-numastat.node1.numa_hit
 5.156e+08 ±  9%     -27.6%  3.735e+08 ±  5%  cpuidle..time
    376420 ±  5%     -56.5%     163676 ±  5%  cpuidle..usage
    256283 ± 29%     -64.8%      90309 ± 60%  numa-meminfo.node1.Mapped
    774069 ± 15%     -58.8%     319020 ± 47%  numa-meminfo.node1.Shmem
     89117 ± 17%     -62.6%      33337 ± 50%  perf-c2c.DRAM.remote
     78134 ± 16%     -62.4%      29353 ± 50%  perf-c2c.HITM.remote
     78.45 ± 33%    -100.0%       0.01 ±141%  numa-vmstat.node0.nr_isolated_anon
     65056 ± 29%     -64.4%      23147 ± 59%  numa-vmstat.node1.nr_mapped
    197053 ± 15%     -59.0%      80737 ± 47%  numa-vmstat.node1.nr_shmem
   1568725 ±  5%     -10.3%    1407667 ±  6%  numa-vmstat.node1.numa_hit
   1608874 ±  2%     -30.7%    1115409 ±  6%  meminfo.Active
   1608858 ±  2%     -30.7%    1115393 ±  6%  meminfo.Active(anon)
   4549412           -10.4%    4076550        meminfo.Cached
    368664 ±  8%     -51.2%     179972 ± 36%  meminfo.Mapped
    870107 ±  4%     -54.4%     397179 ± 19%  meminfo.Shmem
      0.70 ±  4%      -0.7        0.00        mpstat.cpu.all.iowait%
      0.24            +0.0        0.28 ±  3%  mpstat.cpu.all.irq%
     72.55           +13.7       86.20        mpstat.cpu.all.soft%
     22.29           -11.8       10.51 ±  2%  mpstat.cpu.all.sys%
      0.88 ±  3%      -0.5        0.39 ±  3%  mpstat.cpu.all.usr%
     46.33 ± 14%     -78.8%       9.83 ± 21%  mpstat.max_utilization.seconds
     12.47 ±  5%     +41.6%      17.65 ±  5%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     12.47 ±  5%     +41.6%      17.65 ±  5%  perf-sched.total_sch_delay.average.ms
     59.96 ±  4%     +40.2%      84.05 ±  5%  perf-sched.total_wait_and_delay.average.ms
     47.50 ±  3%     +39.8%      66.40 ±  5%  perf-sched.total_wait_time.average.ms
     59.96 ±  4%     +40.2%      84.05 ±  5%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     47.50 ±  3%     +39.8%      66.40 ±  5%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      4.18 ±  9%      -1.2        2.97 ±  3%  turbostat.C1%
      4.16 ± 10%     -28.8%       2.96 ±  3%  turbostat.CPU%c1
      0.15           -20.0%       0.12        turbostat.IPC
  30643618 ±  6%     -33.8%   20273146 ±  3%  turbostat.IRQ
   9235121 ± 11%     -53.5%    4290976 ±  8%  turbostat.NMI
     20.28            -5.2%      19.23        turbostat.RAMWatt
      2.80 ±  2%     -84.0%       0.45 ± 12%  stress-ng.rawsock.MB_recv'd_per_sec
 1.263e+09 ±  2%     -46.9%  6.705e+08 ±  4%  stress-ng.rawsock.ops
  21068817 ±  2%     -46.9%   11184756 ±  4%  stress-ng.rawsock.ops_per_sec
    615583           -27.5%     446065 ±  9%  stress-ng.time.involuntary_context_switches
    168521           -52.0%      80837        stress-ng.time.minor_page_faults
      4458           -53.7%       2062 ±  3%  stress-ng.time.percent_of_cpu_this_job_got
      2605           -54.0%       1199 ±  3%  stress-ng.time.system_time
     73.90 ±  2%     -46.3%      39.67 ±  4%  stress-ng.time.user_time
    106021 ±  2%     -81.2%      19900 ±  7%  stress-ng.time.voluntary_context_switches
    404635 ±  3%     -31.0%     279044 ±  7%  proc-vmstat.nr_active_anon
    185837            -2.9%     180494        proc-vmstat.nr_anon_pages
   1139738           -10.6%    1019325        proc-vmstat.nr_file_pages
    153.81 ± 11%    -100.0%       0.01 ±152%  proc-vmstat.nr_isolated_anon
     92592 ±  8%     -51.0%      45333 ± 34%  proc-vmstat.nr_mapped
    219912 ±  5%     -54.8%      99481 ± 19%  proc-vmstat.nr_shmem
     38659            -2.0%      37872        proc-vmstat.nr_slab_reclaimable
    148828            +4.3%     155195        proc-vmstat.nr_slab_unreclaimable
    404635 ±  3%     -31.0%     279044 ±  7%  proc-vmstat.nr_zone_active_anon
     21570 ± 18%     -61.8%       8245 ± 47%  proc-vmstat.numa_hint_faults
     16919 ± 21%     -56.8%       7311 ± 51%  proc-vmstat.numa_hint_faults_local
    963.83 ±  7%    -100.0%       0.00        proc-vmstat.numa_huge_pte_updates
    111261 ±  3%     -99.2%     909.67 ± 20%  proc-vmstat.numa_pages_migrated
    526245 ±  7%     -97.7%      12122 ± 45%  proc-vmstat.numa_pte_updates
    535799           -22.9%     413207 ±  2%  proc-vmstat.pgfault
    111261 ±  3%     -99.2%     909.67 ± 20%  proc-vmstat.pgmigrate_success
     21679 ±  7%      -9.8%      19545 ±  2%  proc-vmstat.pgreuse
   1799808           -57.1%     772136 ±  9%  sched_debug.cfs_rq:/.avg_vruntime.avg
   2946020 ±  8%    +251.1%   10342560 ± 10%  sched_debug.cfs_rq:/.avg_vruntime.max
   1006872 ±  8%     -87.4%     126618 ± 18%  sched_debug.cfs_rq:/.avg_vruntime.min
    356117 ±  4%    +262.9%    1292236 ± 17%  sched_debug.cfs_rq:/.avg_vruntime.stddev
     64.34 ± 33%     +59.2%     102.44 ±  8%  sched_debug.cfs_rq:/.load_avg.avg
   1799808           -57.1%     772137 ±  9%  sched_debug.cfs_rq:/.min_vruntime.avg
   2946020 ±  8%    +251.1%   10342560 ± 10%  sched_debug.cfs_rq:/.min_vruntime.max
   1006872 ±  8%     -87.4%     126618 ± 18%  sched_debug.cfs_rq:/.min_vruntime.min
    356117 ±  4%    +262.9%    1292236 ± 17%  sched_debug.cfs_rq:/.min_vruntime.stddev
      1008 ±  8%     +15.7%       1166        sched_debug.cfs_rq:/.runnable_avg.avg
      3848 ± 74%     -67.7%       1243 ± 13%  sched_debug.cfs_rq:/.util_avg.max
      8.67 ±213%   +2513.5%     226.50 ± 32%  sched_debug.cfs_rq:/.util_avg.min
    431.22 ± 40%     -66.2%     145.58 ± 13%  sched_debug.cfs_rq:/.util_avg.stddev
    808.82 ± 11%     -52.0%     387.95 ±  6%  sched_debug.cfs_rq:/.util_est.avg
   1337827 ±  3%     -26.5%     983709 ±  2%  sched_debug.cpu.avg_idle.avg
    197988 ± 29%     -97.1%       5680 ± 16%  sched_debug.cpu.avg_idle.min
    483058 ±  8%     +27.5%     616103 ±  4%  sched_debug.cpu.avg_idle.stddev
      1721 ±  3%    +243.6%       5914 ±  9%  sched_debug.cpu.clock_task.stddev
   1029615           -42.2%     594917 ±  2%  sched_debug.cpu.max_idle_balance_cost.avg
   1448914 ±  2%     -11.7%    1279232 ±  6%  sched_debug.cpu.max_idle_balance_cost.max
    931867           -46.3%     500000        sched_debug.cpu.max_idle_balance_cost.min
     99448 ± 18%     +54.7%     153845 ±  9%  sched_debug.cpu.max_idle_balance_cost.stddev
      4446           -17.7%       3660 ±  5%  sched_debug.cpu.nr_switches.avg
     59305 ±  8%     +23.6%      73291 ± 17%  sched_debug.cpu.nr_switches.max
      2177 ±  3%     -47.3%       1147 ±  6%  sched_debug.cpu.nr_switches.min
      5185 ±  8%     +26.1%       6537 ± 13%  sched_debug.cpu.nr_switches.stddev
    -99.50           -70.2%     -29.67        sched_debug.cpu.nr_uninterruptible.min
     30.41 ±  6%     -54.1%      13.96 ± 30%  sched_debug.cpu.nr_uninterruptible.stddev
      0.18 ± 24%     +59.1%       0.29 ±  4%  sched_debug.dl_rq:.dl_nr_running.avg
      2.23           -30.8%       1.54 ±  2%  perf-stat.i.MPKI
 1.973e+10           -11.8%   1.74e+10        perf-stat.i.branch-instructions
      0.59            -0.2        0.41 ±  3%  perf-stat.i.branch-miss-rate%
 1.171e+08           -38.6%   71869487 ±  3%  perf-stat.i.branch-misses
     11.83 ±  2%      -5.6        6.24 ±  2%  perf-stat.i.cache-miss-rate%
 2.013e+08 ±  2%     -43.3%   1.14e+08 ±  3%  perf-stat.i.cache-misses
 1.706e+09           +10.7%  1.889e+09        perf-stat.i.cache-references
     17575           -32.4%      11879 ±  9%  perf-stat.i.context-switches
      6.69           +22.6%       8.21        perf-stat.i.cpi
      2421 ±  3%     -76.6%     567.43 ±  6%  perf-stat.i.cpu-migrations
      3014 ±  2%     +82.0%       5485 ±  4%  perf-stat.i.cycles-between-cache-misses
 9.022e+10           -18.1%  7.391e+10        perf-stat.i.instructions
      0.15           -17.9%       0.12        perf-stat.i.ipc
      7721 ±  4%     -34.5%       5055 ±  5%  perf-stat.i.minor-faults
      7724 ±  4%     -34.5%       5055 ±  5%  perf-stat.i.page-faults
      2.22           -30.4%       1.55 ±  2%  perf-stat.overall.MPKI
      0.59            -0.2        0.41 ±  3%  perf-stat.overall.branch-miss-rate%
     11.72 ±  2%      -5.7        6.05 ±  3%  perf-stat.overall.cache-miss-rate%
      6.69           +22.9%       8.21        perf-stat.overall.cpi
      3010 ±  2%     +76.8%       5321 ±  3%  perf-stat.overall.cycles-between-cache-misses
      0.15           -18.6%       0.12        perf-stat.overall.ipc
 1.911e+10           -11.6%  1.689e+10        perf-stat.ps.branch-instructions
 1.129e+08           -38.0%   69941891 ±  3%  perf-stat.ps.branch-misses
 1.939e+08           -42.8%  1.109e+08 ±  3%  perf-stat.ps.cache-misses
 1.655e+09           +10.7%  1.833e+09        perf-stat.ps.cache-references
     16423           -31.2%      11302 ± 10%  perf-stat.ps.context-switches
      2129           -77.4%     481.20 ±  4%  perf-stat.ps.cpu-migrations
 8.731e+10           -17.8%  7.177e+10        perf-stat.ps.instructions
      6585 ±  4%     -34.4%       4320 ±  5%  perf-stat.ps.minor-faults
      6587 ±  4%     -34.4%       4320 ±  5%  perf-stat.ps.page-faults
 5.348e+12           -19.0%  4.332e+12        perf-stat.total.instructions
     21.08 ±  3%     -13.2        7.92 ±  9%  perf-profile.calltrace.cycles-pp.raw_rcv.raw_v4_input.ip_protocol_deliver_rcu.ip_local_deliver_finish.ip_local_deliver
     20.80 ±  3%     -13.1        7.75 ± 10%  perf-profile.calltrace.cycles-pp.sock_queue_rcv_skb_reason.raw_rcv.raw_v4_input.ip_protocol_deliver_rcu.ip_local_deliver_finish
     18.41 ±  3%     -11.8        6.61 ± 10%  perf-profile.calltrace.cycles-pp.__sock_queue_rcv_skb.sock_queue_rcv_skb_reason.raw_rcv.raw_v4_input.ip_protocol_deliver_rcu
     13.19 ±  5%      -9.1        4.08 ± 11%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__sock_queue_rcv_skb.sock_queue_rcv_skb_reason.raw_rcv.raw_v4_input
     10.51 ±  6%      -7.5        2.98 ± 12%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__sock_queue_rcv_skb.sock_queue_rcv_skb_reason.raw_rcv
      7.69 ± 12%      -7.5        0.20 ±223%  perf-profile.calltrace.cycles-pp.__put_partials.kmem_cache_free.raw_recvmsg.inet_recvmsg.sock_recvmsg
      8.67 ± 10%      -7.4        1.30 ± 47%  perf-profile.calltrace.cycles-pp.kmem_cache_free.raw_recvmsg.inet_recvmsg.sock_recvmsg.__sys_recvfrom
      7.46 ± 12%      -7.3        0.15 ±223%  perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.raw_recvmsg.inet_recvmsg
      7.30 ± 12%      -7.2        0.13 ±223%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.__put_partials.kmem_cache_free.raw_recvmsg
      8.98 ±  4%      -6.8        2.19 ± 13%  perf-profile.calltrace.cycles-pp.skb_clone.raw_v4_input.ip_protocol_deliver_rcu.ip_local_deliver_finish.ip_local_deliver
      5.22 ±  8%      -4.7        0.56 ± 11%  perf-profile.calltrace.cycles-pp.kmem_cache_alloc_noprof.skb_clone.raw_v4_input.ip_protocol_deliver_rcu.ip_local_deliver_finish
      3.48 ±  2%      -2.0        1.46 ± 15%  perf-profile.calltrace.cycles-pp.__copy_skb_header.skb_clone.raw_v4_input.ip_protocol_deliver_rcu.ip_local_deliver_finish
      2.30            -1.3        1.03 ±  9%  perf-profile.calltrace.cycles-pp.sock_def_readable.__sock_queue_rcv_skb.sock_queue_rcv_skb_reason.raw_rcv.raw_v4_input
      2.36            -1.2        1.12 ±  8%  perf-profile.calltrace.cycles-pp.sk_filter_trim_cap.sock_queue_rcv_skb_reason.raw_rcv.raw_v4_input.ip_protocol_deliver_rcu
     29.52 ±  3%     -21.5        7.99 ± 18%  perf-profile.children.cycles-pp._raw_spin_lock_irqsave
     25.26 ±  3%     -19.8        5.47 ± 18%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     21.08 ±  3%     -13.2        7.92 ±  9%  perf-profile.children.cycles-pp.raw_rcv
     20.81 ±  3%     -13.1        7.75 ± 10%  perf-profile.children.cycles-pp.sock_queue_rcv_skb_reason
     18.42 ±  3%     -11.8        6.62 ± 10%  perf-profile.children.cycles-pp.__sock_queue_rcv_skb
      9.07 ± 10%      -8.4        0.66 ± 51%  perf-profile.children.cycles-pp.__put_partials
     10.74 ±  8%      -7.9        2.88 ± 39%  perf-profile.children.cycles-pp.kmem_cache_free
      8.99 ±  4%      -6.8        2.19 ± 13%  perf-profile.children.cycles-pp.skb_clone
      5.25 ±  8%      -4.6        0.61 ± 10%  perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      5.09 ±  8%      -4.5        0.58 ± 11%  perf-profile.children.cycles-pp.___slab_alloc
      4.58 ±  9%      -4.4        0.23 ± 22%  perf-profile.children.cycles-pp.get_partial_node
      3.48 ±  2%      -2.0        1.46 ± 15%  perf-profile.children.cycles-pp.__copy_skb_header
      2.30            -1.3        1.03 ±  9%  perf-profile.children.cycles-pp.sock_def_readable
      2.36            -1.2        1.12 ±  8%  perf-profile.children.cycles-pp.sk_filter_trim_cap
      0.11 ±  4%      -0.0        0.06 ± 11%  perf-profile.children.cycles-pp.ipv4_pktinfo_prepare
      0.12 ±  4%      -0.0        0.07 ±  8%  perf-profile.children.cycles-pp.dst_release
      0.13            +0.0        0.16 ±  5%  perf-profile.children.cycles-pp.update_process_times
      0.15 ±  2%      +0.0        0.19 ±  5%  perf-profile.children.cycles-pp.tick_nohz_handler
      0.15 ±  2%      +0.0        0.19 ±  3%  perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.18 ±  3%      +0.0        0.23 ±  6%  perf-profile.children.cycles-pp.skb_defer_free_flush
      0.21 ±  2%      +0.1        0.27 ±  4%  perf-profile.children.cycles-pp.hrtimer_interrupt
      0.22            +0.1        0.27 ±  4%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.13 ±  8%      +0.1        0.19 ±  9%  perf-profile.children.cycles-pp.kmalloc_reserve
      0.19 ±  5%      +0.1        0.27 ± 18%  perf-profile.children.cycles-pp.__ip_select_ident
      0.00            +0.1        0.10 ± 51%  perf-profile.children.cycles-pp.sk_skb_reason_drop
      0.00            +0.1        0.11 ± 67%  perf-profile.children.cycles-pp.inet_sock_destruct
      0.00            +0.1        0.11 ± 66%  perf-profile.children.cycles-pp.__sk_destruct
      0.23 ±  4%      +0.2        0.38 ±  3%  perf-profile.children.cycles-pp.run_ksoftirqd
      0.23 ±  4%      +0.2        0.38 ±  3%  perf-profile.children.cycles-pp.smpboot_thread_fn
      0.23 ±  3%      +0.2        0.43 ±  7%  perf-profile.children.cycles-pp.kthread
      0.23 ±  3%      +0.2        0.43 ±  7%  perf-profile.children.cycles-pp.ret_from_fork
      0.23 ±  3%      +0.2        0.43 ±  7%  perf-profile.children.cycles-pp.ret_from_fork_asm
      0.24 ±  3%      +0.2        0.44 ± 18%  perf-profile.children.cycles-pp.dst_destroy
      0.00            +0.2        0.21 ± 77%  perf-profile.children.cycles-pp.__mmput
      0.00            +0.2        0.21 ± 77%  perf-profile.children.cycles-pp.exit_mmap
      0.00            +0.2        0.22 ± 76%  perf-profile.children.cycles-pp.exit_mm
      0.00            +0.2        0.22 ± 80%  perf-profile.children.cycles-pp.__irq_exit_rcu
      0.00            +0.2        0.22 ± 76%  perf-profile.children.cycles-pp.__x64_sys_exit_group
      0.00            +0.2        0.22 ± 75%  perf-profile.children.cycles-pp.do_exit
      0.00            +0.2        0.22 ± 75%  perf-profile.children.cycles-pp.do_group_exit
      0.00            +0.2        0.23 ± 73%  perf-profile.children.cycles-pp.x64_sys_call
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.acpi_idle_do_entry
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.acpi_idle_enter
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.acpi_safe_halt
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.cpuidle_enter
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.cpuidle_enter_state
      0.00            +0.2        0.24 ± 79%  perf-profile.children.cycles-pp.pv_native_safe_halt
      0.00            +0.2        0.24 ± 78%  perf-profile.children.cycles-pp.cpuidle_idle_call
      0.00            +0.2        0.24 ± 78%  perf-profile.children.cycles-pp.start_secondary
      0.00            +0.2        0.24 ± 77%  perf-profile.children.cycles-pp.common_startup_64
      0.00            +0.2        0.24 ± 77%  perf-profile.children.cycles-pp.cpu_startup_entry
      0.00            +0.2        0.24 ± 77%  perf-profile.children.cycles-pp.do_idle
      0.23 ±  2%      +0.3        0.49 ± 37%  perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.25            +0.3        0.52 ± 36%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.24 ±  4%      +0.4        0.60 ± 29%  perf-profile.children.cycles-pp.rcu_do_batch
      0.24 ±  4%      +0.4        0.60 ± 29%  perf-profile.children.cycles-pp.rcu_core
      0.86 ±  3%      +0.7        1.52 ± 41%  perf-profile.children.cycles-pp.__slab_free
     25.25 ±  3%     -19.8        5.46 ± 18%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      3.47 ±  2%      -2.0        1.45 ± 15%  perf-profile.self.cycles-pp.__copy_skb_header
      4.26            -1.7        2.53 ± 18%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      2.87            -1.4        1.48 ±  8%  perf-profile.self.cycles-pp.__sock_queue_rcv_skb
      2.29            -1.3        1.03 ±  9%  perf-profile.self.cycles-pp.sock_def_readable
      2.34            -1.2        1.12 ±  8%  perf-profile.self.cycles-pp.sk_filter_trim_cap
      0.46 ±  2%      -0.3        0.16 ± 16%  perf-profile.self.cycles-pp.get_partial_node
      0.50 ±  2%      -0.2        0.34 ±  4%  perf-profile.self.cycles-pp.___slab_alloc
      0.31            -0.1        0.16 ± 11%  perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.28            -0.1        0.16 ±  8%  perf-profile.self.cycles-pp.skb_clone
      0.10 ±  4%      -0.0        0.06 ±  9%  perf-profile.self.cycles-pp.dst_release
      0.06            +0.0        0.08 ±  9%  perf-profile.self.cycles-pp.kmem_cache_alloc_node_noprof
      0.12 ±  3%      +0.0        0.15 ±  7%  perf-profile.self.cycles-pp.skb_defer_free_flush
      0.00            +0.1        0.05 ±  7%  perf-profile.self.cycles-pp.ktime_get
     44.51           +26.8       71.33 ±  8%  perf-profile.self.cycles-pp.raw_v4_input




Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


