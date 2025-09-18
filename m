Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A89C0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 07:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC758E00C3; Thu, 18 Sep 2025 03:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4398E0093; Thu, 18 Sep 2025 03:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6D18E00C3; Thu, 18 Sep 2025 03:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5D038E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 03:04:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AF79BB620
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:04:34 +0000 (UTC)
X-FDA: 83901482868.22.2616644
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id A701440009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:04:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AA7bM1KV;
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758179071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5zh6aB8plFzw/wx1LzNSEb4VGz0y+C7ZzF8MiN5oYkw=;
	b=VqGjRebEDIXoveE6FzQkfTSjptAHvdDYpecPajJJ5qJbY3wdu+pXsQBD9sXHdnz9cq5RM6
	cef7LOh4/tRRy054w+bGAysyAZpZB2kW6JyIau0fKs/JSz2X0KW0r+8gh9ZDFpgshfcK/+
	mRYtALgl8DmX6T+63jyKq7ULc60WPQI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=AA7bM1KV;
	spf=pass (imf12.hostedemail.com: domain of oliver.sang@intel.com designates 198.175.65.18 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758179071; a=rsa-sha256;
	cv=fail;
	b=F4qN0DFpTKiVL+9nl9PZnBs13G3CJBj5SmD4lfFZFCnxfGiPXUnvAqEOnTGCM7/tPRvAVK
	+uehHcXdA1v+334pri3FcXhT1D6fAgu+D+hR8L8X6UQtq9s/rEyzNzm0fyxjo0t4RNRNmo
	bKqTCBKYBgsfc/Yy9W81gGYVPdRVJAk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758179070; x=1789715070;
  h=date:from:to:cc:subject:message-id:
   content-transfer-encoding:mime-version;
  bh=Ay583AvU8QJDkHyXik72TPIZPJr01Uw9a4XXWPyoITs=;
  b=AA7bM1KVTJmrZMUt06YpOTXf0HcZXiDvpj5DdITaRnOCn79d9crIukd3
   GkTc6Z2XjPM7jhshMmcu6a4D1lnUv9lwuTrIqd01EpX2QN16wL87jWOuB
   MEiB/HfVrXr73lfPHLzgO/70MPKyTsF4Isy01NRvk+RFymjNmb1Z5Jd0h
   AR6AbGMLPII3X7QtTmYAxF+RTVfW/3Ym7ssvmP/hUZiR4y0RrCMXY59v9
   SlCDEf2wwL//yVBUKoELpLU6zV/www50aH24SWyW+7BbqO7uMoKb6FMEM
   TPC93C3O0fxgnlojOmH211af1Qwbh8tycJ6HOEIcX1G1p6g22ojJx3P0a
   w==;
X-CSE-ConnectionGUID: Bw95yzzuQQyycaRpbCfWww==
X-CSE-MsgGUID: M5klOTXvTSyV3+GB08BtAA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="60553652"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="60553652"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 00:04:29 -0700
X-CSE-ConnectionGUID: xao1ij2HQsewaye3jtP9kQ==
X-CSE-MsgGUID: 28Z1q+JSRO2QljIJvUh6gw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,274,1751266800"; 
   d="scan'208";a="180582312"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 00:04:29 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 00:04:28 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Thu, 18 Sep 2025 00:04:28 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.44) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 18 Sep 2025 00:04:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QoJJD32x7iRaxNVK+TYlUI9shUzMFhcS+knMCgI69Wyn3+IPq+xQvv6fCIW0iRdMSJBN/TcPt1dw0gsWm2FuAdMPhxL7fRb4JUivaMj7h0VrIY98T6RaCsADBV1AOv1WCTblMulcrBKGqqR5nR1jYWuwhZjyU4YV1WdZQKPwZTsBGl7WzUYbuBbmxl4l6w5hK8upQ1jgZkWXWNkUno9k0GL8tuKyRQ31IupHTrIkY1EVce2LfvEbPzDX7ovwwian8YU5GGLYkQMr3TceL+zPbXeZt6PKb2IJxVfM7ab37g6bWUTPU6c5Hp/m58udCy+1Bd2m1DkMi3mmwIaCDpVMgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xixEd7xtTcHDF1SRI/x2snweSlLeVvA5f9c+G6PGzu8=;
 b=lzmyzjByk7BOXaX0TC7mqFUWXD1XNXJuVsRzTXv3RNHWrznfbJqCQY8kc8rPjpts9wd5KoeI9ZU/OXQP0J/TYrhzzNIUeeqill2yobaW9gPS6Lf7qx0rSWHzOn0qYe+aEs9FhnsFretxTviH/77+XSD3Yty+bfNMBg2r4DkS4nyu0gORIAzvywmUsEPdgMwfw21xsP8j3343ZF/P0AirKUIVnsowFIeqLY+1gMbDhq8cOqWylroFSMg22IKZgjxXlwr/YMyhM6Sxn1h+1bW33+rgbaFgimTSZBt57rtBzfi27BATLHhrvMjK2zeKmWnznq20m53DrxR9XuANUuPCzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 07:04:25 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 07:04:23 +0000
Date: Thu, 18 Sep 2025 15:04:14 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Pedro Falcato <pfalcato@suse.de>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, Vlastimil Babka
	<vbabka@suse.cz>, <maple-tree@lists.infradead.org>, <linux-mm@kvack.org>,
	<oliver.sang@intel.com>
Subject: [vbabka:slub-percpu-sheaves-v8r1] [maple_tree]  d446df8076:
 stress-ng.memfd.ops_per_sec 4.4% improvement
Message-ID: <202509180858.9aff849c-lkp@intel.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0017.apcprd06.prod.outlook.com
 (2603:1096:4:186::15) To LV3PR11MB8603.namprd11.prod.outlook.com
 (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|MW3PR11MB4587:EE_
X-MS-Office365-Filtering-Correlation-Id: 5ae6d9ec-b251-42ec-b921-08ddf68198ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?iso-8859-1?Q?yilbfTnoR8H6g8tCZVB4YXcBOs+2u9rHOjtQ+P8xro/d7Bf14XJXUMX4F1?=
 =?iso-8859-1?Q?5p3c+Uvj7ZRlao7+UwU0uZSpagMkKftlEfoMABNrBYY5IPnZYkxiD0Uq6q?=
 =?iso-8859-1?Q?zCO7fKhHMRRu0sp7Atheb3Fx8G7FtbIYRMOjA9+9sYWnG/beLFknyJiL6c?=
 =?iso-8859-1?Q?d8nm8FfFJfumUYXYs3NrT4H1JQC7VbEA7lCuOyZTYIVYbBOEKFyDijPW38?=
 =?iso-8859-1?Q?wqZBiNGrV6eDv79MyVmAQaNYHuW9IszG1UuNHPKKijOX1wJVTuImG/i0FW?=
 =?iso-8859-1?Q?/b6CoqRdMabpppP6MX//XmyyMC8tqxrZrviG5CmdDjCta3VWjxnisR4nPg?=
 =?iso-8859-1?Q?NkBNg7wwmrO9euwwnKvqMFipsa3Ppe2gbPqH+mfVDVq0fD3x4S3jBMnmA/?=
 =?iso-8859-1?Q?KtqGSMb4wrPsOcBLDRuL5StCe7rAWPdXxAIDOcnx7e7/lyNVwRKmsUI8ch?=
 =?iso-8859-1?Q?+XVTwU5s2+lwDXy5Ezqs8lMoVdJP78XwFBGI92FXcSQXrYm0EcrX+Uvz9j?=
 =?iso-8859-1?Q?N2W+vJfydH8Tz/Ev54dFrJHSNnJdM4xke5dWnK+QVQy5kIE2BIA1msq3h7?=
 =?iso-8859-1?Q?D1z4HaagDNXDkze/n3K3udUMIJCtMfzxouVt0A0Nkx+ujxfSZZZkNgSBfJ?=
 =?iso-8859-1?Q?0eCNyIiNlihCDvbzny6rG/zRwoxjqfscwe9jMBT2FY2Sy0qq3ckRkejpX8?=
 =?iso-8859-1?Q?grN6LCYtNxsSl8+0iUzTfYM1UJtpj4v774D2OiB1DaSvxoTxxp/yScq56t?=
 =?iso-8859-1?Q?D1vYiI2vMe4gJqJpUeCV3H4YqA6wYjprrBfTR5BiRcL90/F4yaC0Me/oJM?=
 =?iso-8859-1?Q?uWM41KOXucN8j0aP1GsD7IisIzId9lKhnpHWWNM07WDNx2XgDAXXO0StCg?=
 =?iso-8859-1?Q?9Zedo57rx6nMjjHGcNajzfxX05CU/4ZLgamHIhp8Q4Wsp2k2bFAcPjb5UC?=
 =?iso-8859-1?Q?qsGqDNkKI8n862vdNdzzbW3rK4DQgGJghDanfPb4TjEDbJFPAdXM7R0Jdt?=
 =?iso-8859-1?Q?M8k/BoXNBQ56M++Z5N14XfoQ+S7pMEbCyaA8T4le4DTOc8N8t8F12fgSb1?=
 =?iso-8859-1?Q?ZywfYuFVNdHKyKz3bifZpnhXQ4Q3FiPW53XR0Jm4JOL2j1/cs5u+0ksjNu?=
 =?iso-8859-1?Q?9guPmIe7MszrXIS8v+xPGGJum4cEKehNNy/patdtSOXkHlYahPd50M6DF6?=
 =?iso-8859-1?Q?MBmPPcwC2zNb90KoCbV8P+XjUVlAZ4xsbkUws3iqXb8Imtv2IAO19oYNRY?=
 =?iso-8859-1?Q?R0xlO7VvdXgp5+HHR2GFORZZkb/eJAAs5E5n8kH9dYIPn2Un2HfVIxRylR?=
 =?iso-8859-1?Q?m48mmPrqnre7Znb0vVaIgzI9qoEAUxOpJqIfFYa6OVbN04aWvXuy6PFZ7U?=
 =?iso-8859-1?Q?E+X6FchD1yIy1/9iRi0DioD61c5txLFuE5PQQ757J4mHMHXMRxIX1FHxZe?=
 =?iso-8859-1?Q?Pmz+6danMsUVSp0T?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?KYXHyW5iOFi/3SA5DrzhAFNDcWd5E3cXPrGvYyuKk644kTlVR7aw0ekhUx?=
 =?iso-8859-1?Q?z1bfNj/ASHjAJ+CtOaulc5w4A1Il79PbrRUTIYcesvk/tvUdXrGrEqDo/W?=
 =?iso-8859-1?Q?KCrHTJxyEzRRvVCugxWdtgVTp3PAhOzUjEQx1eUxNtRy5TRAv5GUgR1fbk?=
 =?iso-8859-1?Q?IfV/91JBdrBXNXXI2JPlrsJuN9kVpbQ/Ykl8T/4cteM+tg+D6FC7HW05WD?=
 =?iso-8859-1?Q?fT6/eWfPNgrNE4dGGgtfua6jfJ2Gw2VFOrembiZLejsuJqUZTqdryih/9f?=
 =?iso-8859-1?Q?pBsIikpkEJYoC3/5Q0jwjMU1HjXZedis0I9dSFydlF3UA91HKCWkuuyRGh?=
 =?iso-8859-1?Q?rHERfNIs0mJhXZMFtuIXFsGx1TUzF6ucaKq0I/di+Xw0d5RfGNx5PHLutO?=
 =?iso-8859-1?Q?pLHsSCgB42doT+Seha8rwbbs/0mK3xEJmEt548q8F7suIuM385sDe6pQwQ?=
 =?iso-8859-1?Q?gCxo2nUXZs8/O+sEFwZzoEqqxAHHQ+s6mhfH5xVK0yIsS+qqSButW0X4/4?=
 =?iso-8859-1?Q?x16X3zM41t6KvDHuqiOhqlWssjbtPSzJb2RAYVy/JdAZoP/GfSG4ozxRMl?=
 =?iso-8859-1?Q?VS3tPxV71K/4by4KcvteIWXGbu+L88SlpbrdmnDpSMWNOfMiXw2NK1KtkM?=
 =?iso-8859-1?Q?OBt5mm59TEu4YT0qv6RLCP9ddksIxuj4lffbwCC7i/gjt6aPOCY7nve17j?=
 =?iso-8859-1?Q?xx/onOBbLuo3EVIs3zS699HXkJRgSUqPkowhETwqvvSXmsuNzJNYT+WaxY?=
 =?iso-8859-1?Q?l68+cCb4VQvZhL4T8ApOxhxrroIgrJ/p9kVgqmWj/HFdSLEe0DQX43m5OX?=
 =?iso-8859-1?Q?aMgUhbaug7k1uPiSiauzJu4Pli+N8LU1Yxiu46YsZrICxfPpKzuQ7/8E3P?=
 =?iso-8859-1?Q?VlZHcGO3Wg8+lQMMZtiRC3bN2FoxhRaslbu6j/ZEkHPKxytfTZ+Uc6x9M+?=
 =?iso-8859-1?Q?tch8khNypWULFFHPt/Dup11zEtFeRlUtIF72yjnHV0Jt/HPdny9YQFpfXH?=
 =?iso-8859-1?Q?WQzsQw6Ke8NQa/HgRJ0zMlgXuqJEFHAKmewO6AmLqiS+dbeUXWtiCcFRlE?=
 =?iso-8859-1?Q?k2MTQbNfgS5Vyu6PsprznaqaaACRxEfYzGO0aUFEEDvjfOC+KMKztCevuX?=
 =?iso-8859-1?Q?8IFWYGYfOn8daq/Xavsrwv8iE7grcjsxv+krYZdDdGAl3mgI9XMu16Ojd5?=
 =?iso-8859-1?Q?g0b8O7SW2EecSFUGZFIGs3VS8y6ZFCzLYdEPMMEegs3EJi77nrvJgM+6QH?=
 =?iso-8859-1?Q?7sGoLhDIo8reMb0atk4ZITcv8YOss8EJe/KmNHS2/TYeUpQoMm6ePJWLCH?=
 =?iso-8859-1?Q?jp7mgSUjlfVOe60jfMf+I5GylzckcamtXKer/k5qJEEu0fzleLWFtRC8Oj?=
 =?iso-8859-1?Q?W9IXivBaxhN2aPDCEoMXQTmVxgcmyuzEeoHJxD7v0WwuqGAT64p4Bzy0Ys?=
 =?iso-8859-1?Q?7DyOG9Ow7C46D8fcpRsyJCg31Mib9+J2zvAo9yX9H0CAzwteSjdSsXkg6d?=
 =?iso-8859-1?Q?n7PJ2thDtH23Qom7pXYQeB2aPdSgqL4RRyRZb6c1Lq+pn6pBxYLRW7lplW?=
 =?iso-8859-1?Q?SFS+rO/+ENcJy5r/mbp6qOGFtyXozzpJWWNXhOmGHeT9Uq2eFl8jgBfe/1?=
 =?iso-8859-1?Q?/kNIxAvCQViRyfK5LBgjfLx0nlSuknVWhVJmSwjWGJE8FYnD5vHHHJjw?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ae6d9ec-b251-42ec-b921-08ddf68198ed
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 07:04:23.9284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RKtUWc0OSGwCbzhC8Ao7EQgY8DJvmYeuEDx4Re138MXtAQ6UasDbJQyRq8b4u1sLjCBjQUlW/VaTY0cmuQ0r7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: A701440009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: dwczir8gswrp6t4163emhcpzmsin1ypj
X-HE-Tag: 1758179070-607214
X-HE-Meta: U2FsdGVkX1+kizjnJHNehKfOge+0JJ8BQxJLF6EtAQoZPj1ZEJDRvtQ+BT8jE8wWL47ckW61YN0okTvmBNH8vRuqz9K2focwDvFabrzuurhdC8Lh/LuTl60xrVSfzM7XXLFPA3uMZHBhKuRSG6GOiVcppyZgqkxiDsNdqgzWhIXl8tiInw1zqjT5ZaGle6Bp7Xk7Gz6aJTnGtMv1FxB8WA1vRoarmCmm0K0oijmubHDWB7Lcsu7Sgc0e6moVOJvVLYvZO/FiEUTpmNCE7oTjxJMKDEn4uHZFPvBHVdVOQgcbzWQc6w+SeqhY3vnG/+lno0HtOcmCHD65RrGK6mF4ycTn59d1sYkWk68H9Aq10mMZT/PLXr+n4kPng5GR0Ofijjw5/hG0dEwTCjPQjwALEhegRXkKV5Ss/HmbX5bwBPxUlmdzMokn2TKmW9Bk9sEniNEO6S8TY9RtWnOIH6KLzY/k/ZseGE5AnY2BDQU82JGq+8RgVTOigHVpayjP0zGlYD+P6kk+bAkFFWvdbV7x18H3zB9nn5OeiQsnqhwONZTWMBetw6UwYalyUB9vJJG03cZJI3UAmkpFwDDczlgYcffR/rTwc24cx4jHuY0mZoIZLLdrFftcDy4ctaNt/BimCFDhXf7CbBtfQF0eiwuUtH+p7jT6ZhF+vqjw5e5Zikagi/TbT8xtPrHjtKGM1h+rayMTCckAf7am1o0xqVDYpVADdHMMT74NDslzvfYXxnYI7e4EWzddM3CFYyWnJy+jKLraOKsQn/+0/vui4F+VjtK5Y+BnoFWRJMYfUBzI2097gyhqkiibSd3NX1VFsOr2JVEhUKKEq5ofBeP3WKfSDXy5y6fdSIFasE7MLNQqQgzFC+aXY3NrN8OtPY24qaHFrugrOTKZEOq3asS0bFQnh+xWNS9sjDabN1r02mmAecTZNBNPlbYsDmSYsSM0YDYNw/1K9SZ/FIO7CrxG0pD
 StzWM7z0
 jQN0omOdmaxhwRkJLUBF5G4fHeY5qXtQj8YrowANDbrb6SeDg1RBRXQjOq/eDxUpQ8Q9svpRA+Nt2IgdEFkWe5sVftKV/pyFS5OHsPFmseU2KxRcIMqTbLwVdoxPqTq8pVMH+Fm8G62kP5fj6JoiqvSAO7ki5l+mkQHr2ohqq7LdkLJtsdl8SSVKs0LnGkGFFLQylG4tj8o5NlHHCDFgfovcbcBz2CZQPcsdQjOcChA3ZfV+yIhuqk4QLgdOgl4+taSKp5QCXcyr4X1Kz8TtcPRGY3+200WLqbmkNQhAg4uN0ZNpu7y537K2IfWG4OO3zu+DNGS+fB61auke8YaYH6fMa31xRAOGyPPGlqPRzEur8WRd7sJwn1nHFBRZ9bPKnma+kbasmlNWt0/kB4RS0qmF9lSvQ36nqpN0tSYv5v0ofAnjxCnfKr1/o0BJ7fe9qtO9lLZ2kVKoPZ6VJdEXqDr319yy4iaL4vLSweWm/L3DDYPvC1sSQkKCNbWfaHUB8SFfooN4GqYmOugaZMfwb4ZmGOaydp/gjbO6daE+/vh+GjOcKv7mCakKUp/hdqcdowtQZTxrfGQmnfsVwN2f9gRUMLFm8NxXHe0D82EAxNnS1PAXg54hkPThbFAsGC6OwSK6UYs2WsvMYsiCQKPtjIzATf3n6+mQW6I/ozxVTu8Nm70YJfaKiwm/V+nVUEO5Rb9R1UsB9+LJS5nECYqsxdH+jJ3Q1Z+AjDl3hZ665Pf56erg81WYFEzEHj7QZzJODlqj3QjwmEOI5YK4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed a 4.4% improvement of stress-ng.memfd.ops_per_sec on:


commit: d446df8076dc9c96a7b6d484789da814c19915ec ("maple_tree: Use kfree_rcu in ma_free_rcu")
https://git.kernel.org/cgit/linux/kernel/git/vbabka/linux.git slub-percpu-sheaves-v8r1

testcase: stress-ng
config: x86_64-rhel-9.4
compiler: gcc-14
test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
parameters:

	nr_threads: 100%
	testtime: 60s
	test: memfd
	cpufreq_governor: performance


Details are as below:
-------------------------------------------------------------------------------------------------->


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250918/202509180858.9aff849c-lkp@intel.com

=========================================================================================
compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
  gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/igk-spr-2sp2/memfd/stress-ng/60s

commit: 
  eb8b293b99 ("testing/radix-tree/maple: Hack around kfree_rcu not existing")
  d446df8076 ("maple_tree: Use kfree_rcu in ma_free_rcu")

eb8b293b995be7f2 d446df8076dc9c96a7b6d484789 
---------------- --------------------------- 
         %stddev     %change         %stddev
             \          |                \  
     85615            +6.6%      91242        stress-ng.memfd.nanosecs_per_memfd_create_call
    216252            +4.4%     225722        stress-ng.memfd.ops
      3604            +4.4%       3762        stress-ng.memfd.ops_per_sec
     49.85            -0.6%      49.53        kmsg.timestamp:LKP:stdout:#:Kernel_tests:Boot_OK
      3.41            -0.2%       3.41        kmsg.timestamp:T0#cpu:SGX_disabled_or_unsupported_by_BIOS
      4.81 ±264%    +199.6%      14.42 ±129%  kmsg.timestamp:T11]#xxx#:#b:#:Failed_to_load_MMP_firmware_qat_4xxx_mmp.bin
      4.81 ±264%    +199.7%      14.43 ±129%  kmsg.timestamp:T11]#xxx#:#b:#:Failed_to_load_acceleration_FW
      0.00       +4.8e+102%       4.79 ±264%  kmsg.timestamp:T9]#xxx#:#b:#:Failed_to_load_MMP_firmware_qat_4xxx_mmp.bin
      0.00       +4.8e+102%       4.79 ±264%  kmsg.timestamp:T9]#xxx#:#b:#:Failed_to_load_acceleration_FW
     38.71            -0.4%      38.56        kmsg.timestamp:ice###:Fail_during_requesting_FW
     38.69            -0.4%      38.54        kmsg.timestamp:ice###:The_DDP_package_file_was_not_found_or_could_not_be_read.Entering_Safe_Mode
     99.48            -0.5%      99.02        kmsg.timestamp:last
     38.77            -0.4%      38.63        kmsg.timestamp:xxx###:Failed_to_load_MMP_firmware_qat_4xxx_mmp.bin
     38.78            -0.4%      38.65        kmsg.timestamp:xxx###:Failed_to_load_acceleration_FW
     33.73 ± 37%     -43.0%      19.22 ±100%  kmsg.timestamp:xxx#:#b:#:Failed_to_load_MMP_firmware_qat_4xxx_mmp.bin
     33.74 ± 37%     -43.0%      19.22 ±100%  kmsg.timestamp:xxx#:#b:#:Failed_to_load_acceleration_FW
     99.48            -0.5%      99.02        dmesg.timestamp:last
     48.70            -0.4%      48.49        boot-time.boot
      8629            -0.4%       8593        boot-time.idle
 3.091e+08 ±  6%      +3.5%    3.2e+08 ±  4%  cpuidle..time
     97898 ±  6%      -1.5%      96387 ±  7%  cpuidle..usage
    111.32            -0.2%     111.11        uptime.boot
      9125            -0.4%       9088        uptime.idle
  56649987            +4.8%   59352433        numa-numastat.node0.local_node
  56752404            +4.8%   59458171        numa-numastat.node0.numa_hit
     99218 ± 64%      +3.3%     102454 ± 77%  numa-numastat.node0.other_node
  57106292            +4.5%   59671441        numa-numastat.node1.local_node
  57211560            +4.5%   59770935        numa-numastat.node1.numa_hit
     99387 ± 64%      -3.2%      96240 ± 81%  numa-numastat.node1.other_node
      0.85 ±  4%     -40.5%       0.50 ±  3%  perf-sched.sch_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     24.82 ± 39%     +98.5%      49.26 ± 88%  perf-sched.sch_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      0.85 ±  4%     -40.5%       0.50 ±  3%  perf-sched.total_sch_delay.average.ms
     24.82 ± 39%     +98.5%      49.26 ± 88%  perf-sched.total_sch_delay.max.ms
    106.45 ±  7%     -28.8%      75.76 ±  2%  perf-sched.total_wait_and_delay.average.ms
     20529 ± 13%     +78.5%      36649 ±  2%  perf-sched.total_wait_and_delay.count.ms
      3941 ±  8%      -6.2%       3695 ±  6%  perf-sched.total_wait_and_delay.max.ms
    105.60 ±  8%     -28.7%      75.26 ±  2%  perf-sched.total_wait_time.average.ms
      3940 ±  8%      -6.3%       3693 ±  6%  perf-sched.total_wait_time.max.ms
    106.45 ±  7%     -28.8%      75.76 ±  2%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
     20529 ± 13%     +78.5%      36649 ±  2%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
      3941 ±  8%      -6.2%       3695 ±  6%  perf-sched.wait_and_delay.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
    105.60 ±  8%     -28.7%      75.26 ±  2%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
      3940 ±  8%      -6.3%       3693 ±  6%  perf-sched.wait_time.max.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
   1224398 ±  7%      -4.7%    1166533        meminfo.Active
   1224382 ±  7%      -4.7%    1166517        meminfo.Active(anon)
     16.31            +0.3%      16.36        meminfo.Active(file)
     50010 ± 15%      +6.5%      53276 ± 13%  meminfo.AnonHugePages
    711203            +0.2%     712524        meminfo.AnonPages
      4.15 ±  4%      -1.2%       4.10 ±  4%  meminfo.Buffers
   4328057 ±  2%      -1.4%    4269024        meminfo.Cached
 1.979e+08            +0.0%  1.979e+08        meminfo.CommitLimit
   4645104 ±  2%      -1.3%    4582942        meminfo.Committed_AS
 3.954e+08            -0.1%  3.949e+08        meminfo.DirectMap1G
   9654784 ± 20%      +6.9%   10318080 ± 14%  meminfo.DirectMap2M
    170664 ±  3%      -4.7%     162728 ±  7%  meminfo.DirectMap4k
     14.35 ±129%     -33.7%       9.52 ±173%  meminfo.Dirty
      2048            +0.0%       2048        meminfo.Hugepagesize
    435.15 ±  5%      -1.1%     430.48 ±  4%  meminfo.Inactive
    435.15 ±  5%      -1.1%     430.48 ±  4%  meminfo.Inactive(file)
    308772            -2.6%     300749        meminfo.KReclaimable
     40882            -0.1%      40837        meminfo.KernelStack
    156270 ± 12%      -2.3%     152694 ± 10%  meminfo.Mapped
 3.853e+08            +0.0%  3.854e+08        meminfo.MemAvailable
 3.868e+08            +0.0%  3.869e+08        meminfo.MemFree
 3.958e+08            +0.0%  3.958e+08        meminfo.MemTotal
   9011343            -0.9%    8931416        meminfo.Memused
     15.42            +0.2%      15.45        meminfo.Mlocked
     48551 ±  3%      +2.3%      49657 ±  3%  meminfo.PageTables
     85054            -0.3%      84768        meminfo.Percpu
    308772            -2.6%     300749        meminfo.SReclaimable
   1120534 ±  8%      +6.2%    1189775 ±  3%  meminfo.SUnreclaim
     20640            +0.0%      20640        meminfo.SecPageTables
    515962 ± 18%     -11.4%     456931 ±  2%  meminfo.Shmem
   1429306 ±  6%      +4.3%    1490525 ±  2%  meminfo.Slab
   3814747            -0.0%    3814744        meminfo.Unevictable
 1.374e+13            +0.0%  1.374e+13        meminfo.VmallocTotal
    287600            -0.0%     287511        meminfo.VmallocUsed
   9302056            -0.6%    9243159        meminfo.max_used_kB
      1.90            -2.2%       1.86        perf-stat.i.MPKI
 1.894e+10            +1.5%  1.922e+10        perf-stat.i.branch-instructions
      0.51 ±  2%      -0.0        0.50        perf-stat.i.branch-miss-rate%
  91284450 ±  2%      +0.6%   91827325        perf-stat.i.branch-misses
     43.38            +1.0       44.41        perf-stat.i.cache-miss-rate%
 1.634e+08            -0.5%  1.626e+08        perf-stat.i.cache-misses
  3.82e+08 ±  2%      -2.9%   3.71e+08        perf-stat.i.cache-references
      4610 ±  6%     +65.0%       7607        perf-stat.i.context-switches
      6.32            -1.7%       6.22        perf-stat.i.cpi
 1.921e+11            +0.0%  1.921e+11        perf-stat.i.cpu-clock
 5.479e+11            +0.1%  5.482e+11        perf-stat.i.cpu-cycles
    302.49 ±  2%      +6.8%     322.98        perf-stat.i.cpu-migrations
      3331            +0.5%       3349        perf-stat.i.cycles-between-cache-misses
 8.614e+10            +1.7%  8.763e+10        perf-stat.i.instructions
      0.16            +1.8%       0.16        perf-stat.i.ipc
      0.05 ± 65%     -54.7%       0.02 ± 62%  perf-stat.i.major-faults
     19.01            +4.4%      19.84        perf-stat.i.metric.K/sec
   1825035            +4.4%    1905175        perf-stat.i.minor-faults
   1825035            +4.4%    1905175        perf-stat.i.page-faults
 1.921e+11            +0.0%  1.921e+11        perf-stat.i.task-clock
      1.90            -2.2%       1.86        perf-stat.overall.MPKI
      0.48            -0.0        0.48        perf-stat.overall.branch-miss-rate%
     42.78            +1.1       43.84        perf-stat.overall.cache-miss-rate%
      6.36            -1.7%       6.26        perf-stat.overall.cpi
      3352            +0.6%       3371        perf-stat.overall.cycles-between-cache-misses
      0.16            +1.7%       0.16        perf-stat.overall.ipc
 1.857e+10            +1.8%   1.89e+10        perf-stat.ps.branch-instructions
  88831156            +1.4%   90109350        perf-stat.ps.branch-misses
 1.603e+08            -0.3%  1.599e+08        perf-stat.ps.cache-misses
  3.75e+08 ±  3%      -2.7%  3.648e+08        perf-stat.ps.cache-references
      4502 ±  6%     +66.0%       7475        perf-stat.ps.context-switches
 1.883e+11            +0.3%  1.888e+11        perf-stat.ps.cpu-clock
 5.375e+11            +0.3%  5.391e+11        perf-stat.ps.cpu-cycles
    295.46 ±  3%      +7.3%     317.16        perf-stat.ps.cpu-migrations
 8.447e+10            +2.0%  8.617e+10        perf-stat.ps.instructions
      0.05 ± 66%     -54.3%       0.02 ± 62%  perf-stat.ps.major-faults
   1790235            +4.6%    1873425        perf-stat.ps.minor-faults
   1790235            +4.6%    1873425        perf-stat.ps.page-faults
 1.883e+11            +0.3%  1.888e+11        perf-stat.ps.task-clock
 5.124e+12            +2.4%  5.245e+12        perf-stat.total.instructions
    561023 ± 42%     -42.9%     320294 ± 51%  numa-meminfo.node0.Active
    561013 ± 42%     -42.9%     320283 ± 51%  numa-meminfo.node0.Active(anon)
      9.65 ± 50%     +15.9%      11.18 ± 46%  numa-meminfo.node0.Active(file)
     36983 ± 43%     -31.0%      25528 ± 88%  numa-meminfo.node0.AnonHugePages
    448115 ± 43%     -47.8%     234001 ± 73%  numa-meminfo.node0.AnonPages
    473848 ± 40%     -47.4%     249438 ± 68%  numa-meminfo.node0.AnonPages.max
      9.71 ±173%     -50.2%       4.84 ±264%  numa-meminfo.node0.Dirty
   1077003 ±138%    +124.9%    2422692 ± 71%  numa-meminfo.node0.FilePages
    165.74 ±115%      +1.2%     167.68 ±116%  numa-meminfo.node0.Inactive
    165.74 ±115%      +1.2%     167.68 ±116%  numa-meminfo.node0.Inactive(file)
    137669 ± 14%      +8.4%     149177 ± 18%  numa-meminfo.node0.KReclaimable
     20933 ± 10%      +2.4%      21428 ±  6%  numa-meminfo.node0.KernelStack
     36471 ±106%     -35.1%      23658 ± 62%  numa-meminfo.node0.Mapped
 1.941e+08            -0.6%  1.929e+08        numa-meminfo.node0.MemFree
 1.977e+08            +0.0%  1.977e+08        numa-meminfo.node0.MemTotal
   3551800 ± 41%     +35.4%    4810308 ± 35%  numa-meminfo.node0.MemUsed
      3.84 ±173%    +152.1%       9.68 ± 77%  numa-meminfo.node0.Mlocked
     24380 ± 45%      +3.2%      25156 ± 40%  numa-meminfo.node0.PageTables
    137669 ± 14%      +8.4%     149177 ± 18%  numa-meminfo.node0.SReclaimable
    627399 ± 24%     +23.2%     772697 ±  6%  numa-meminfo.node0.SUnreclaim
     10320            +0.0%      10320        numa-meminfo.node0.SecPageTables
    115703 ± 82%     -23.0%      89066 ± 43%  numa-meminfo.node0.Shmem
    765069 ± 18%     +20.5%     921875 ±  8%  numa-meminfo.node0.Slab
    964208 ±152%    +142.3%    2336527 ± 74%  numa-meminfo.node0.Unevictable
    667037 ± 44%     +26.6%     844571 ± 19%  numa-meminfo.node1.Active
    667030 ± 44%     +26.6%     844565 ± 19%  numa-meminfo.node1.Active(anon)
      6.67 ± 73%     -22.5%       5.17 ± 99%  numa-meminfo.node1.Active(file)
     13072 ± 96%    +112.4%      27772 ± 77%  numa-meminfo.node1.AnonHugePages
    263798 ± 73%     +81.3%     478363 ± 35%  numa-meminfo.node1.AnonPages
    473428 ± 37%     +41.8%     671200 ± 24%  numa-meminfo.node1.AnonPages.max
      4.68 ±264%      +3.4%       4.84 ±264%  numa-meminfo.node1.Dirty
   3253707 ± 46%     -43.3%    1844595 ± 93%  numa-meminfo.node1.FilePages
    269.44 ± 71%      -2.4%     262.96 ± 77%  numa-meminfo.node1.Inactive
    269.44 ± 71%      -2.4%     262.96 ± 77%  numa-meminfo.node1.Inactive(file)
    171088 ± 12%     -11.3%     151793 ± 18%  numa-meminfo.node1.KReclaimable
     19948 ± 11%      -2.6%      19439 ±  6%  numa-meminfo.node1.KernelStack
    119520 ± 37%      +7.7%     128781 ± 17%  numa-meminfo.node1.Mapped
 1.926e+08            +0.7%   1.94e+08        numa-meminfo.node1.MemFree
 1.981e+08            -0.0%  1.981e+08        numa-meminfo.node1.MemTotal
   5463778 ± 27%     -24.6%    4120509 ± 40%  numa-meminfo.node1.MemUsed
     11.58 ± 57%     -50.2%       5.77 ±129%  numa-meminfo.node1.Mlocked
     24165 ± 47%      +2.1%      24662 ± 43%  numa-meminfo.node1.PageTables
    171088 ± 12%     -11.3%     151793 ± 18%  numa-meminfo.node1.SReclaimable
    494648 ± 18%     -15.6%     417516 ±  2%  numa-meminfo.node1.SUnreclaim
     10320            +0.0%      10320        numa-meminfo.node1.SecPageTables
    402897 ± 33%      -9.1%     366108 ± 11%  numa-meminfo.node1.Shmem
    665737 ± 11%     -14.5%     569309 ±  5%  numa-meminfo.node1.Slab
   2850540 ± 51%     -48.1%    1478215 ±117%  numa-meminfo.node1.Unevictable
     69.38 ±  4%      -6.1%      65.12 ±  8%  proc-vmstat.direct_map_level2_splits
      4.75 ± 39%     +13.2%       5.38 ± 26%  proc-vmstat.direct_map_level3_splits
    306122 ±  8%      -4.7%     291692        proc-vmstat.nr_active_anon
      4.08            +0.3%       4.09        proc-vmstat.nr_active_file
    177825            +0.2%     178172        proc-vmstat.nr_anon_pages
     24.42 ± 15%      +6.7%      26.05 ± 13%  proc-vmstat.nr_anon_transparent_hugepages
     16.50 ±129%     -30.3%      11.50 ±173%  proc-vmstat.nr_dirtied
      3.59 ±129%     -33.7%       2.38 ±173%  proc-vmstat.nr_dirty
   9614010            +0.0%    9616077        proc-vmstat.nr_dirty_background_threshold
  19251527            +0.0%   19255667        proc-vmstat.nr_dirty_threshold
   1082006 ±  2%      -1.4%    1067246        proc-vmstat.nr_file_pages
  96696183            +0.0%   96716889        proc-vmstat.nr_free_pages
  96587674            +0.0%   96591486        proc-vmstat.nr_free_pages_blocks
    108.79 ±  5%      -1.1%     107.62 ±  4%  proc-vmstat.nr_inactive_file
      5160            +0.0%       5160        proc-vmstat.nr_iommu_pages
      0.00          +4e+99%       0.00 ±173%  proc-vmstat.nr_isolated_anon
     40882            -0.1%      40836        proc-vmstat.nr_kernel_stack
     38804 ± 13%      -1.5%      38224 ± 10%  proc-vmstat.nr_mapped
   1571840            +0.0%    1571840        proc-vmstat.nr_memmap_boot_pages
      3.85            +0.2%       3.86        proc-vmstat.nr_mlock
     12136 ±  3%      +2.2%      12409 ±  3%  proc-vmstat.nr_page_table_pages
      5160            +0.0%       5160        proc-vmstat.nr_sec_page_table_pages
    128975 ± 19%     -11.4%     114219 ±  2%  proc-vmstat.nr_shmem
     77176            -2.7%      75106        proc-vmstat.nr_slab_reclaimable
    280110 ±  8%      +6.1%     297296 ±  3%  proc-vmstat.nr_slab_unreclaimable
    953686            -0.0%     953686        proc-vmstat.nr_unevictable
     16.50 ±129%     -30.3%      11.50 ±173%  proc-vmstat.nr_written
    306122 ±  8%      -4.7%     291692        proc-vmstat.nr_zone_active_anon
      4.08            +0.3%       4.09        proc-vmstat.nr_zone_active_file
    108.79 ±  5%      -1.1%     107.62 ±  4%  proc-vmstat.nr_zone_inactive_file
    953686            -0.0%     953686        proc-vmstat.nr_zone_unevictable
      3.59 ±129%     -33.7%       2.38 ±173%  proc-vmstat.nr_zone_write_pending
    123885 ± 19%      +2.1%     126487 ± 17%  proc-vmstat.numa_hint_faults
    114821 ± 16%      +5.2%     120838 ± 17%  proc-vmstat.numa_hint_faults_local
  1.14e+08            +4.7%  1.193e+08        proc-vmstat.numa_hit
     20.62 ±139%     +70.9%      35.25 ± 51%  proc-vmstat.numa_huge_pte_updates
 1.138e+08            +4.7%  1.191e+08        proc-vmstat.numa_local
    198605            +0.0%     198694        proc-vmstat.numa_other
     13219 ± 64%     -19.2%      10676 ±100%  proc-vmstat.numa_pages_migrated
    197242 ± 28%      -2.1%     193036 ± 23%  proc-vmstat.numa_pte_updates
 1.217e+08            +6.4%  1.295e+08        proc-vmstat.pgalloc_normal
 1.114e+08            +4.4%  1.162e+08        proc-vmstat.pgfault
 1.211e+08            +6.5%   1.29e+08        proc-vmstat.pgfree
     13219 ± 64%     -19.2%      10676 ±100%  proc-vmstat.pgmigrate_success
     18.00 ±136%     -22.2%      14.00 ±175%  proc-vmstat.pgpgin
    136.50 ±129%     -30.4%      95.00 ±173%  proc-vmstat.pgpgout
     29018 ±  3%      -2.7%      28248 ±  2%  proc-vmstat.pgreuse
     31.75 ± 35%     +18.5%      37.62 ± 28%  proc-vmstat.thp_collapse_alloc
      0.38 ±129%     -66.7%       0.12 ±264%  proc-vmstat.thp_deferred_split_page
      8.38 ±160%     +17.9%       9.88 ±130%  proc-vmstat.thp_migration_success
    798.00            -0.0%     797.75        proc-vmstat.unevictable_pgs_culled
      4.00            +0.0%       4.00        proc-vmstat.unevictable_pgs_mlocked
      1.00 ±173%    -100.0%       0.00        proc-vmstat.unevictable_pgs_munlocked
    140267 ± 41%     -42.8%      80195 ± 51%  numa-vmstat.node0.nr_active_anon
      2.41 ± 50%     +15.8%       2.79 ± 46%  numa-vmstat.node0.nr_active_file
    112035 ± 43%     -47.7%      58542 ± 73%  numa-vmstat.node0.nr_anon_pages
     18.07 ± 43%     -31.6%      12.36 ± 87%  numa-vmstat.node0.nr_anon_transparent_hugepages
     10.50 ±173%     -47.6%       5.50 ±264%  numa-vmstat.node0.nr_dirtied
      2.39 ±173%     -48.5%       1.23 ±264%  numa-vmstat.node0.nr_dirty
    269249 ±138%    +125.0%     605717 ± 71%  numa-vmstat.node0.nr_file_pages
  48535760            -0.6%   48221056        numa-vmstat.node0.nr_free_pages
  48476817            -0.7%   48156334        numa-vmstat.node0.nr_free_pages_blocks
     41.51 ±115%      +0.7%      41.82 ±116%  numa-vmstat.node0.nr_inactive_file
      2580            +0.0%       2580        numa-vmstat.node0.nr_iommu_pages
      0.00          +2e+99%       0.00 ±264%  numa-vmstat.node0.nr_isolated_anon
     20932 ± 10%      +2.6%      21467 ±  6%  numa-vmstat.node0.nr_kernel_stack
      9113 ±106%     -34.9%       5929 ± 62%  numa-vmstat.node0.nr_mapped
      0.96 ±173%    +152.0%       2.42 ± 77%  numa-vmstat.node0.nr_mlock
      6095 ± 45%      +4.2%       6349 ± 40%  numa-vmstat.node0.nr_page_table_pages
      2580            +0.0%       2580        numa-vmstat.node0.nr_sec_page_table_pages
     28921 ± 82%     -22.9%      22312 ± 44%  numa-vmstat.node0.nr_shmem
     34405 ± 14%      +8.6%      37362 ± 18%  numa-vmstat.node0.nr_slab_reclaimable
    156893 ± 24%     +22.7%     192446 ±  6%  numa-vmstat.node0.nr_slab_unreclaimable
    241052 ±152%    +142.3%     584131 ± 74%  numa-vmstat.node0.nr_unevictable
     10.50 ±173%     -47.6%       5.50 ±264%  numa-vmstat.node0.nr_written
    140280 ± 41%     -42.8%      80191 ± 51%  numa-vmstat.node0.nr_zone_active_anon
      2.41 ± 50%     +15.8%       2.79 ± 46%  numa-vmstat.node0.nr_zone_active_file
     41.51 ±115%      +0.7%      41.82 ±116%  numa-vmstat.node0.nr_zone_inactive_file
    241052 ±152%    +142.3%     584131 ± 74%  numa-vmstat.node0.nr_zone_unevictable
      2.39 ±173%     -48.5%       1.23 ±264%  numa-vmstat.node0.nr_zone_write_pending
  56752707            +4.3%   59196927        numa-vmstat.node0.numa_hit
  56650290            +4.3%   59091188        numa-vmstat.node0.numa_local
     99218 ± 64%      +3.3%     102454 ± 77%  numa-vmstat.node0.numa_other
    166637 ± 44%     +25.8%     209680 ± 19%  numa-vmstat.node1.nr_active_anon
      1.67 ± 73%     -22.6%       1.29 ± 99%  numa-vmstat.node1.nr_active_file
     65991 ± 73%     +80.6%     119160 ± 36%  numa-vmstat.node1.nr_anon_pages
      6.37 ± 96%    +111.4%      13.47 ± 77%  numa-vmstat.node1.nr_anon_transparent_hugepages
      6.00 ±264%      +0.0%       6.00 ±264%  numa-vmstat.node1.nr_dirtied
      1.17 ±264%      +5.1%       1.23 ±264%  numa-vmstat.node1.nr_dirty
    813249 ± 46%     -43.4%     460096 ± 93%  numa-vmstat.node1.nr_file_pages
  48158852            +0.7%   48495377        numa-vmstat.node1.nr_free_pages
  48110347            +0.7%   48436077        numa-vmstat.node1.nr_free_pages_blocks
     67.36 ± 71%      -2.6%      65.63 ± 77%  numa-vmstat.node1.nr_inactive_file
      2580            +0.0%       2580        numa-vmstat.node1.nr_iommu_pages
      0.00          +2e+99%       0.00 ±264%  numa-vmstat.node1.nr_isolated_anon
     19947 ± 11%      -2.4%      19466 ±  6%  numa-vmstat.node1.nr_kernel_stack
     29927 ± 37%      +7.7%      32231 ± 17%  numa-vmstat.node1.nr_mapped
      2.90 ± 57%     -50.2%       1.44 ±129%  numa-vmstat.node1.nr_mlock
      6042 ± 47%      +2.8%       6214 ± 43%  numa-vmstat.node1.nr_page_table_pages
      2580            +0.0%       2580        numa-vmstat.node1.nr_sec_page_table_pages
    100545 ± 34%     -10.0%      90476 ± 11%  numa-vmstat.node1.nr_shmem
     42772 ± 12%     -11.1%      38034 ± 18%  numa-vmstat.node1.nr_slab_reclaimable
    123737 ± 18%     -15.6%     104446 ±  2%  numa-vmstat.node1.nr_slab_unreclaimable
    712634 ± 51%     -48.1%     369553 ±117%  numa-vmstat.node1.nr_unevictable
      6.00 ±264%      +0.0%       6.00 ±264%  numa-vmstat.node1.nr_written
    166631 ± 44%     +25.8%     209683 ± 19%  numa-vmstat.node1.nr_zone_active_anon
      1.67 ± 73%     -22.6%       1.29 ± 99%  numa-vmstat.node1.nr_zone_active_file
     67.36 ± 71%      -2.6%      65.63 ± 77%  numa-vmstat.node1.nr_zone_inactive_file
    712634 ± 51%     -48.1%     369553 ±117%  numa-vmstat.node1.nr_zone_unevictable
      1.17 ±264%      +5.1%       1.23 ±264%  numa-vmstat.node1.nr_zone_write_pending
  57211551            +4.0%   59511604        numa-vmstat.node1.numa_hit
  57106283            +4.0%   59412110        numa-vmstat.node1.numa_local
     99387 ± 64%      -3.2%      96240 ± 81%  numa-vmstat.node1.numa_other
   5867348            -0.1%    5861257        sched_debug.cfs_rq:/.avg_vruntime.avg
   5956538            -0.2%    5942404        sched_debug.cfs_rq:/.avg_vruntime.max
   5386265 ±  9%      +2.8%    5535354 ±  2%  sched_debug.cfs_rq:/.avg_vruntime.min
     64630 ± 46%      -9.1%      58726 ± 14%  sched_debug.cfs_rq:/.avg_vruntime.stddev
      0.54 ±  2%      +1.4%       0.55        sched_debug.cfs_rq:/.h_nr_queued.avg
      1.69 ± 14%     +25.9%       2.12 ± 10%  sched_debug.cfs_rq:/.h_nr_queued.max
      0.50            +0.0%       0.50        sched_debug.cfs_rq:/.h_nr_queued.min
      0.19 ± 17%     +17.0%       0.22 ±  9%  sched_debug.cfs_rq:/.h_nr_queued.stddev
      0.54 ±  2%      +0.9%       0.54        sched_debug.cfs_rq:/.h_nr_runnable.avg
      1.69 ± 14%     +22.2%       2.06 ±  8%  sched_debug.cfs_rq:/.h_nr_runnable.max
      0.50            +0.0%       0.50        sched_debug.cfs_rq:/.h_nr_runnable.min
      0.19 ± 17%     +13.1%       0.21 ±  6%  sched_debug.cfs_rq:/.h_nr_runnable.stddev
     60057 ±159%     +14.5%      68780 ± 98%  sched_debug.cfs_rq:/.left_deadline.avg
   3456228 ± 79%     +27.6%    4408987 ± 57%  sched_debug.cfs_rq:/.left_deadline.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.left_deadline.min
    402169 ±103%     +27.6%     513361 ± 70%  sched_debug.cfs_rq:/.left_deadline.stddev
     60056 ±159%     +14.5%      68779 ± 98%  sched_debug.cfs_rq:/.left_vruntime.avg
   3456191 ± 79%     +27.6%    4408921 ± 57%  sched_debug.cfs_rq:/.left_vruntime.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.left_vruntime.min
    402167 ±103%     +27.6%     513350 ± 70%  sched_debug.cfs_rq:/.left_vruntime.stddev
      8634 ± 99%     +16.9%      10093 ± 66%  sched_debug.cfs_rq:/.load.avg
    342965 ± 73%     +57.5%     540080 ± 67%  sched_debug.cfs_rq:/.load.max
      2625 ±  4%      +1.9%       2676        sched_debug.cfs_rq:/.load.min
     39369 ± 93%     +45.3%      57212 ± 71%  sched_debug.cfs_rq:/.load.stddev
     31.94 ± 21%      -0.2%      31.86 ± 22%  sched_debug.cfs_rq:/.load_avg.avg
    778.38 ± 33%     -27.5%     564.44 ±  3%  sched_debug.cfs_rq:/.load_avg.max
      2.44 ±  6%      +2.6%       2.50        sched_debug.cfs_rq:/.load_avg.min
    115.08 ± 15%     -14.3%      98.57 ± 13%  sched_debug.cfs_rq:/.load_avg.stddev
   5867354            -0.1%    5861258        sched_debug.cfs_rq:/.min_vruntime.avg
   5956538            -0.2%    5942404        sched_debug.cfs_rq:/.min_vruntime.max
   5386265 ±  9%      +2.8%    5535354 ±  2%  sched_debug.cfs_rq:/.min_vruntime.min
     64632 ± 46%      -9.1%      58726 ± 14%  sched_debug.cfs_rq:/.min_vruntime.stddev
      0.53            +1.0%       0.54        sched_debug.cfs_rq:/.nr_queued.avg
      1.31 ± 18%     +14.3%       1.50 ± 23%  sched_debug.cfs_rq:/.nr_queued.max
      0.50            +0.0%       0.50        sched_debug.cfs_rq:/.nr_queued.min
      0.14 ± 26%     +13.8%       0.16 ± 23%  sched_debug.cfs_rq:/.nr_queued.stddev
     15.94 ± 45%      -5.0%      15.15 ± 35%  sched_debug.cfs_rq:/.removed.load_avg.avg
    512.00            +0.0%     512.00        sched_debug.cfs_rq:/.removed.load_avg.max
     86.73 ± 20%      -2.3%      84.74 ± 17%  sched_debug.cfs_rq:/.removed.load_avg.stddev
      7.49 ± 46%      +0.5%       7.53 ± 36%  sched_debug.cfs_rq:/.removed.runnable_avg.avg
    260.38            +0.3%     261.19        sched_debug.cfs_rq:/.removed.runnable_avg.max
     41.38 ± 20%      +2.1%      42.24 ± 18%  sched_debug.cfs_rq:/.removed.runnable_avg.stddev
      7.49 ± 46%      +0.5%       7.53 ± 36%  sched_debug.cfs_rq:/.removed.util_avg.avg
    260.38            +0.3%     261.12        sched_debug.cfs_rq:/.removed.util_avg.max
     41.38 ± 20%      +2.1%      42.23 ± 18%  sched_debug.cfs_rq:/.removed.util_avg.stddev
     60056 ±159%     +14.5%      68779 ± 98%  sched_debug.cfs_rq:/.right_vruntime.avg
   3456191 ± 79%     +27.6%    4408921 ± 57%  sched_debug.cfs_rq:/.right_vruntime.max
      0.00            +0.0%       0.00        sched_debug.cfs_rq:/.right_vruntime.min
    402167 ±103%     +27.6%     513350 ± 70%  sched_debug.cfs_rq:/.right_vruntime.stddev
    599.15            +0.2%     600.49        sched_debug.cfs_rq:/.runnable_avg.avg
      1504 ±  6%      +2.5%       1542 ±  9%  sched_debug.cfs_rq:/.runnable_avg.max
    510.25            +0.3%     512.00        sched_debug.cfs_rq:/.runnable_avg.min
    161.25 ±  9%      +1.3%     163.34 ± 11%  sched_debug.cfs_rq:/.runnable_avg.stddev
    587.54            +0.1%     587.96        sched_debug.cfs_rq:/.util_avg.avg
      1096 ±  5%      +2.2%       1120 ±  7%  sched_debug.cfs_rq:/.util_avg.max
    393.06 ± 39%     +18.2%     464.44 ± 12%  sched_debug.cfs_rq:/.util_avg.min
    128.19 ± 10%      -2.8%     124.61 ±  3%  sched_debug.cfs_rq:/.util_avg.stddev
     12.29 ± 26%      +3.5%      12.73 ± 23%  sched_debug.cfs_rq:/.util_est.avg
    974.50 ±  9%      +5.1%       1023        sched_debug.cfs_rq:/.util_est.max
     92.43 ± 16%      +4.9%      96.94 ± 11%  sched_debug.cfs_rq:/.util_est.stddev
   1186407 ±  5%      -0.1%    1185208 ±  5%  sched_debug.cpu.avg_idle.avg
   2925176 ±  3%      -2.7%    2846682 ±  5%  sched_debug.cpu.avg_idle.max
    294241 ± 26%     -27.6%     212924 ± 30%  sched_debug.cpu.avg_idle.min
    482686 ±  9%      +0.5%     485288 ± 12%  sched_debug.cpu.avg_idle.stddev
     80740            -0.3%      80525        sched_debug.cpu.clock.avg
     80766            -0.3%      80555        sched_debug.cpu.clock.max
     80713            -0.3%      80492        sched_debug.cpu.clock.min
     15.55 ± 12%     +14.4%      17.78 ± 10%  sched_debug.cpu.clock.stddev
     80052            -0.2%      79873        sched_debug.cpu.clock_task.avg
     80347            -0.3%      80077        sched_debug.cpu.clock_task.max
     65765            -0.0%      65765        sched_debug.cpu.clock_task.min
      1043            -1.6%       1026        sched_debug.cpu.clock_task.stddev
      5032            +0.1%       5034        sched_debug.cpu.curr->pid.avg
      9236 ±  2%      +1.0%       9326        sched_debug.cpu.curr->pid.max
      2399 ± 64%     -21.2%       1891 ± 90%  sched_debug.cpu.curr->pid.min
    914.85 ± 18%     +16.6%       1066 ± 23%  sched_debug.cpu.curr->pid.stddev
    591468 ±  3%      -0.3%     589731 ±  3%  sched_debug.cpu.max_idle_balance_cost.avg
   1297017 ±  4%      -1.9%    1272169 ±  2%  sched_debug.cpu.max_idle_balance_cost.max
    500000            +0.0%     500000        sched_debug.cpu.max_idle_balance_cost.min
    170705 ± 12%      -1.8%     167551 ± 13%  sched_debug.cpu.max_idle_balance_cost.stddev
      4294            -0.0%       4294        sched_debug.cpu.next_balance.avg
      4294            -0.0%       4294        sched_debug.cpu.next_balance.max
      4294            -0.0%       4294        sched_debug.cpu.next_balance.min
      0.00 ± 61%     -14.1%       0.00 ±  6%  sched_debug.cpu.next_balance.stddev
      0.54            +1.0%       0.54        sched_debug.cpu.nr_running.avg
      1.75 ± 14%     +17.9%       2.06 ±  8%  sched_debug.cpu.nr_running.max
      0.50            +0.0%       0.50        sched_debug.cpu.nr_running.min
      0.19 ± 16%     +12.3%       0.21 ± 10%  sched_debug.cpu.nr_running.stddev
      1980 ±  2%     +26.2%       2498 ±  2%  sched_debug.cpu.nr_switches.avg
     46888 ±  8%      -1.2%      46330 ±  6%  sched_debug.cpu.nr_switches.max
    481.50 ± 13%    +122.3%       1070 ±  4%  sched_debug.cpu.nr_switches.min
      3646 ±  7%      +0.4%       3661 ±  6%  sched_debug.cpu.nr_switches.stddev
      0.01 ± 36%     -11.1%       0.01 ± 25%  sched_debug.cpu.nr_uninterruptible.avg
     33.44 ± 19%     +12.9%      37.75 ± 24%  sched_debug.cpu.nr_uninterruptible.max
    -15.62            +9.2%     -17.06        sched_debug.cpu.nr_uninterruptible.min
      5.26 ± 12%     +16.3%       6.12 ± 14%  sched_debug.cpu.nr_uninterruptible.stddev
     80713            -0.3%      80494        sched_debug.cpu_clk
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.avg
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.max
    996147            +0.0%     996147        sched_debug.dl_rq:.dl_bw->bw.min
  10066176            +0.0%   10066176        sched_debug.dl_rq:.dl_bw->total_bw.avg
  10066176            +0.0%   10066176        sched_debug.dl_rq:.dl_bw->total_bw.max
  10066176            +0.0%   10066176        sched_debug.dl_rq:.dl_bw->total_bw.min
 4.295e+09            -0.0%  4.295e+09        sched_debug.jiffies
     79668            -0.3%      79450        sched_debug.ktime
      0.00 ±264%    -100.0%       0.00        sched_debug.rt_rq:.rt_nr_running.avg
      0.06 ±264%    -100.0%       0.00        sched_debug.rt_rq:.rt_nr_running.max
      0.00 ±264%    -100.0%       0.00        sched_debug.rt_rq:.rt_nr_running.stddev
     81956            -0.2%      81765        sched_debug.sched_clk
      1.00            +0.0%       1.00        sched_debug.sched_clock_stable()
      2.80            +0.0%       2.80        sched_debug.sysctl_sched.sysctl_sched_base_slice
  32696287            +0.0%   32696287        sched_debug.sysctl_sched.sysctl_sched_features
      1.00            +0.0%       1.00        sched_debug.sysctl_sched.sysctl_sched_tunable_scaling
      5.44 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.close_range
      5.44 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.close_range
      5.44 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.close_range
      5.43 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.close_range
      5.43 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.task_work_run.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe.close_range
      5.43 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.__fput.task_work_run.exit_to_user_mode_loop.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.42 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.dput.__fput.task_work_run.exit_to_user_mode_loop.do_syscall_64
      5.42 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.__dentry_kill.dput.__fput.task_work_run.exit_to_user_mode_loop
      5.38 ±264%      -5.4        0.00        perf-profile.calltrace.cycles-pp.evict.__dentry_kill.dput.__fput.task_work_run
      5.26 ±264%      -5.3        0.00        perf-profile.calltrace.cycles-pp.memfd_create
      5.26 ±264%      -5.3        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.memfd_create
      5.26 ±264%      -5.3        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.memfd_create
      5.26 ±264%      -5.3        0.00        perf-profile.calltrace.cycles-pp.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe.memfd_create
      5.25 ±264%      -5.3        0.00        perf-profile.calltrace.cycles-pp.__shmem_file_setup.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe.memfd_create
      5.20 ±264%      -5.2        0.00        perf-profile.calltrace.cycles-pp.__shmem_get_inode.__shmem_file_setup.__do_sys_memfd_create.do_syscall_64.entry_SYSCALL_64_after_hwframe
      5.18 ±264%      -5.2        0.00        perf-profile.calltrace.cycles-pp.new_inode.__shmem_get_inode.__shmem_file_setup.__do_sys_memfd_create.do_syscall_64
      5.14 ±264%      -5.1        0.00        perf-profile.calltrace.cycles-pp.inode_sb_list_add.new_inode.__shmem_get_inode.__shmem_file_setup.__do_sys_memfd_create
      5.13 ±264%      -5.1        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.inode_sb_list_add.new_inode.__shmem_get_inode.__shmem_file_setup
      5.12 ±264%      -5.1        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.inode_sb_list_add.new_inode.__shmem_get_inode
      5.05 ±264%      -5.1        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.evict.__dentry_kill.dput.__fput
      5.03 ±264%      -5.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.evict.__dentry_kill.dput
      1.19 ±264%      -1.2        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
      1.18 ±264%      -1.2        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.13 ±264%      -1.1        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_fallocate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.12 ±264%      -1.1        0.00        perf-profile.calltrace.cycles-pp.vfs_fallocate.__x64_sys_fallocate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.12 ±264%      -1.1        0.00        perf-profile.calltrace.cycles-pp.shmem_fallocate.vfs_fallocate.__x64_sys_fallocate.do_syscall_64.entry_SYSCALL_64_after_hwframe
      1.08 ±264%      -1.1        0.00        perf-profile.calltrace.cycles-pp.shmem_undo_range.shmem_fallocate.vfs_fallocate.__x64_sys_fallocate.do_syscall_64
      0.75 ±264%      -0.7        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.shmem_undo_range
      0.74 ±264%      -0.7        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs
      0.54 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.folios_put_refs.shmem_undo_range.shmem_fallocate.vfs_fallocate.__x64_sys_fallocate
      0.53 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.__folio_batch_release.shmem_undo_range.shmem_fallocate.vfs_fallocate.__x64_sys_fallocate
      0.53 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.folio_batch_move_lru.lru_add_drain_cpu.__folio_batch_release.shmem_undo_range.shmem_fallocate
      0.53 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.lru_add_drain_cpu.__folio_batch_release.shmem_undo_range.shmem_fallocate.vfs_fallocate
      0.51 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.shmem_undo_range.shmem_fallocate.vfs_fallocate
      0.50 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.shmem_undo_range.shmem_fallocate
      0.50 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.lru_add_drain_cpu.__folio_batch_release
      0.50 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.folio_batch_move_lru.lru_add_drain_cpu.__folio_batch_release.shmem_undo_range
      0.49 ±264%      -0.5        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock_irqsave.folio_lruvec_lock_irqsave.folio_batch_move_lru.lru_add_drain_cpu
      0.32 ±264%      -0.3        0.00        perf-profile.calltrace.cycles-pp.shmem_evict_inode.evict.__dentry_kill.dput.__fput
      0.32 ±264%      -0.3        0.00        perf-profile.calltrace.cycles-pp.shmem_undo_range.shmem_evict_inode.evict.__dentry_kill.dput
      0.28 ±264%      -0.3        0.00        perf-profile.calltrace.cycles-pp.folios_put_refs.shmem_undo_range.shmem_evict_inode.evict.__dentry_kill
      0.26 ±264%      -0.3        0.00        perf-profile.calltrace.cycles-pp.__page_cache_release.folios_put_refs.shmem_undo_range.shmem_evict_inode.evict
      0.25 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.folio_lruvec_lock_irqsave.__page_cache_release.folios_put_refs.shmem_undo_range.shmem_evict_inode
      0.19 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.stress_memfd_child
      0.18 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.__mmap
      0.18 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.asm_exc_page_fault.stress_memfd_child
      0.16 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__mmap
      0.16 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.16 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.16 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe.__mmap
      0.15 ±264%      -0.2        0.00        perf-profile.calltrace.cycles-pp.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.15 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.stress_memfd_child
      0.15 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.exc_page_fault.asm_exc_page_fault.stress_memfd_child
      0.14 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault.stress_memfd_child
      0.13 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault.asm_exc_page_fault
      0.13 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff.do_syscall_64
      0.13 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__mmap_region.mmap_region.do_mmap.vm_mmap_pgoff.ksys_mmap_pgoff
      0.12 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.do_pte_missing.__handle_mm_fault.handle_mm_fault.do_user_addr_fault.exc_page_fault
      0.12 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.do_shared_fault.do_pte_missing.__handle_mm_fault.handle_mm_fault.do_user_addr_fault
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__do_fault.do_shared_fault.do_pte_missing.__handle_mm_fault.handle_mm_fault
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.shmem_fault.__do_fault.do_shared_fault.do_pte_missing.__handle_mm_fault
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.shmem_get_folio_gfp.shmem_fault.__do_fault.do_shared_fault.do_pte_missing
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__munmap
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__mmap_new_vma.__mmap_region.mmap_region.do_mmap.vm_mmap_pgoff
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__munmap
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.10 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe.__munmap
      0.09 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64.entry_SYSCALL_64_after_hwframe
      0.09 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.native_queued_spin_lock_slowpath._raw_spin_lock.inode_sb_list_add.new_inode
      0.09 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.native_queued_spin_lock_slowpath._raw_spin_lock.inode_sb_list_add
      0.09 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.do_vmi_align_munmap.do_vmi_munmap.__vm_munmap.__x64_sys_munmap.do_syscall_64
      0.09 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.asm_sysvec_apic_timer_interrupt.native_queued_spin_lock_slowpath._raw_spin_lock.evict.__dentry_kill
      0.09 ±264%      -0.1        0.00        perf-profile.calltrace.cycles-pp.sysvec_apic_timer_interrupt.asm_sysvec_apic_timer_interrupt.native_queued_spin_lock_slowpath._raw_spin_lock.evict
     12.21 ±264%     -12.2        0.00        perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
     12.20 ±264%     -12.2        0.00        perf-profile.children.cycles-pp.do_syscall_64
     11.46 ±264%     -11.5        0.00        perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
     10.28 ±264%     -10.3        0.00        perf-profile.children.cycles-pp._raw_spin_lock
      5.48 ±264%      -5.5        0.00        perf-profile.children.cycles-pp.__fput
      5.48 ±264%      -5.5        0.00        perf-profile.children.cycles-pp.dput
      5.47 ±264%      -5.5        0.00        perf-profile.children.cycles-pp.__dentry_kill
      5.44 ±264%      -5.4        0.00        perf-profile.children.cycles-pp.close_range
      5.43 ±264%      -5.4        0.00        perf-profile.children.cycles-pp.exit_to_user_mode_loop
      5.43 ±264%      -5.4        0.00        perf-profile.children.cycles-pp.task_work_run
      5.43 ±264%      -5.4        0.00        perf-profile.children.cycles-pp.evict
      5.26 ±264%      -5.3        0.00        perf-profile.children.cycles-pp.memfd_create
      5.26 ±264%      -5.3        0.00        perf-profile.children.cycles-pp.__do_sys_memfd_create
      5.25 ±264%      -5.3        0.00        perf-profile.children.cycles-pp.__shmem_file_setup
      5.20 ±264%      -5.2        0.00        perf-profile.children.cycles-pp.__shmem_get_inode
      5.18 ±264%      -5.2        0.00        perf-profile.children.cycles-pp.new_inode
      5.14 ±264%      -5.1        0.00        perf-profile.children.cycles-pp.inode_sb_list_add
      1.40 ±264%      -1.4        0.00        perf-profile.children.cycles-pp.shmem_undo_range
      1.25 ±264%      -1.3        0.00        perf-profile.children.cycles-pp._raw_spin_lock_irqsave
      1.24 ±264%      -1.2        0.00        perf-profile.children.cycles-pp.folio_lruvec_lock_irqsave
      1.13 ±264%      -1.1        0.00        perf-profile.children.cycles-pp.__x64_sys_fallocate
      1.12 ±264%      -1.1        0.00        perf-profile.children.cycles-pp.vfs_fallocate
      1.12 ±264%      -1.1        0.00        perf-profile.children.cycles-pp.shmem_fallocate
      0.82 ±264%      -0.8        0.00        perf-profile.children.cycles-pp.folios_put_refs
      0.77 ±264%      -0.8        0.00        perf-profile.children.cycles-pp.__page_cache_release
      0.53 ±264%      -0.5        0.00        perf-profile.children.cycles-pp.__folio_batch_release
      0.53 ±264%      -0.5        0.00        perf-profile.children.cycles-pp.lru_add_drain_cpu
      0.53 ±264%      -0.5        0.00        perf-profile.children.cycles-pp.folio_batch_move_lru
      0.32 ±264%      -0.3        0.00        perf-profile.children.cycles-pp.shmem_evict_inode
      0.22 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.stress_memfd_child
      0.22 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
      0.21 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.sysvec_apic_timer_interrupt
      0.20 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.asm_exc_page_fault
      0.18 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.__mmap
      0.16 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.ksys_mmap_pgoff
      0.16 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.vm_mmap_pgoff
      0.15 ±264%      -0.2        0.00        perf-profile.children.cycles-pp.do_mmap
      0.15 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.exc_page_fault
      0.15 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.do_user_addr_fault
      0.14 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.handle_mm_fault
      0.13 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
      0.13 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.hrtimer_interrupt
      0.13 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__handle_mm_fault
      0.13 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.mmap_region
      0.13 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__mmap_region
      0.12 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.do_pte_missing
      0.12 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.do_shared_fault
      0.12 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__hrtimer_run_queues
      0.12 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.tick_nohz_handler
      0.11 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.update_process_times
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__do_fault
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.handle_softirqs
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.rcu_core
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.rcu_do_batch
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.shmem_fault
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.shmem_get_folio_gfp
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__munmap
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__mmap_new_vma
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__vm_munmap
      0.10 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__x64_sys_munmap
      0.09 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.do_vmi_munmap
      0.09 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.do_vmi_align_munmap
      0.08 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__irq_exit_rcu
      0.08 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.sched_tick
      0.07 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.kmem_cache_free
      0.06 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.shmem_alloc_and_add_folio
      0.06 ±264%      -0.1        0.00        perf-profile.children.cycles-pp.__x64_sys_close
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.llseek
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_mmap
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.touch_atime
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.unmap_page_range
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.vms_complete_munmap_vmas
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.zap_pmd_range
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.zap_pte_range
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.ftruncate64
      0.04 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.alloc_inode
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__slab_free
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.kmem_cache_alloc_lru_noprof
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_store_gfp
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.rcu_cblist_dequeue
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.alloc_file_pseudo
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.vms_clear_ptes
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__mem_cgroup_uncharge_folios
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.generic_update_time
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.update_rq_clock_task
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__mark_inode_dirty
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__x64_sys_ftruncate
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.do_sys_ftruncate
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.page_counter_uncharge
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.uncharge_batch
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.do_ftruncate
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.task_tick_fair
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.kmem_cache_alloc_noprof
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.kthread
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.ret_from_fork
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.ret_from_fork_asm
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_add_to_page_cache
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.locked_inode_to_wb_and_lock_list
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.run_ksoftirqd
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.smpboot_thread_fn
      0.03 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.unmap_mapping_range
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.destroy_inode
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.unmap_vmas
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.update_curr
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__destroy_inode
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.do_truncate
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.truncate_inode_folio
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.zap_page_range_single
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_alloc_nodes
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_store_prealloc
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_store
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__get_unmapped_area
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_get_unmapped_area
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.zap_page_range_single_batched
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__lruvec_stat_mod_folio
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.arch_get_unmapped_area_topdown
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.filemap_remove_folio
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.lru_add
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.___slab_alloc
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.unmapped_area_topdown
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.vm_unmapped_area
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.clear_nlink
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.entry_SYSCALL_64
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.find_lock_entries
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.get_jiffies_update
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.inode_init_always_gfp
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.ksys_lseek
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.lru_gen_del_folio
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mod_memcg_lruvec_state
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.notify_change
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.tmigr_requires_handle_remote
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__filemap_remove_folio
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__memcg_slab_free_hook
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_preallocate
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_alloc_inode
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__call_rcu_common
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__kmem_cache_alloc_bulk
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__kmem_cache_free_bulk
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__pcs_replace_full_main
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.flush_tlb_mm_range
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_wr_node_store
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.native_irq_return_iret
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.perf_event_mmap
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.perf_event_mmap_event
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_alloc_folio
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.sync_regs
      0.02 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.update_se
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.alloc_pages_mpol
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.folio_alloc_mpol_noprof
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.lru_gen_add_folio
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_empty_area_rev
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_file_llseek
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.vms_gather_munmap_vmas
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_create
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_find
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__alloc_frozen_pages_noprof
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__cond_resched
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.clear_page_erms
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.flush_tlb_func
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_wr_spanning_store
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.allocate_slab
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.atime_needs_update
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.clockevents_program_event
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.file_init_path
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.finish_fault
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.inode_set_ctime_current
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.ktime_get
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_find
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_rev_awalk
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_split
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_wr_bnode
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shuffle_freelist
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__pcs_replace_empty_main
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.errseq_sample
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.get_page_from_freelist
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_spanning_rebalance
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.native_flush_tlb_one_user
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.setup_object
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_expand
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__d_alloc
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.d_alloc_pseudo
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.inode_init_owner
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.kmem_cache_alloc_bulk_noprof
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_walk
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.simple_inode_init_ts
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.vm_area_alloc
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_alloc
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_load
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__account_obj_stock
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__put_partials
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.__vfs_getxattr
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.cap_inode_need_killpriv
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.fault_dirty_shared_page
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.filemap_unaccount_folio
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mapping_seek_hole_data
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_prev_slot
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.obj_cgroup_charge_account
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.rcu_all_qs
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.security_inode_need_killpriv
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_inode_acct_blocks
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_recalc_inode
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.zap_present_ptes
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.alloc_empty_file
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.cmd_record
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.down_write
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.free_pgtables
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.inode_init_once
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.lock_vma_under_rcu
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.mas_topiary_replace
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.memcg_list_lru_alloc
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.perf_iterate_sb
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.rcu_sched_clock_irq
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.rcu_segcblist_enqueue
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.refill_obj_stock
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.rmqueue
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.rmqueue_pcplist
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.shmem_free_in_core_inode
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.tlb_flush_rmap_batch
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.tlb_flush_rmaps
      0.01 ±264%      -0.0        0.00        perf-profile.children.cycles-pp.xas_start
     11.28 ±264%     -11.3        0.00        perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
      0.06 ±264%      -0.1        0.00        perf-profile.self.cycles-pp._raw_spin_lock
      0.04 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.stress_memfd_child
      0.03 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.rcu_cblist_dequeue
      0.03 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.__slab_free
      0.03 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.update_rq_clock_task
      0.03 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.page_counter_uncharge
      0.03 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.shmem_get_folio_gfp
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp._raw_spin_lock_irqsave
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.__destroy_inode
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.clear_nlink
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.get_jiffies_update
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.lru_gen_del_folio
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.native_irq_return_iret
      0.02 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.sync_regs
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.do_syscall_64
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.mod_memcg_lruvec_state
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.clear_page_erms
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.kmem_cache_free
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.lru_gen_add_folio
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.__kmem_cache_alloc_bulk
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.inode_init_always_gfp
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.ktime_get
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.mas_rev_awalk
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.notify_change
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.update_se
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.atime_needs_update
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.entry_SYSRETQ_unsafe_stack
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.errseq_sample
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.native_flush_tlb_one_user
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.__call_rcu_common
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.__memcg_slab_post_alloc_hook
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.inode_init_owner
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.inode_set_ctime_current
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.kmem_cache_alloc_noprof
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.xas_find
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.__memcg_slab_free_hook
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.folios_put_refs
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.inode_sb_list_add
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.llseek
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.mas_walk
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.find_lock_entries
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.inode_init_once
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.rcu_segcblist_enqueue
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.shmem_free_in_core_inode
      0.01 ±264%      -0.0        0.00        perf-profile.self.cycles-pp.update_curr



Disclaimer:
Results have been estimated based on internal Intel analysis and are provided
for informational purposes only. Any difference in system hardware or software
design or configuration may affect actual performance.


-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


