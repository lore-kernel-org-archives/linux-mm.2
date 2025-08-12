Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B97B5CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 01:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51ED68E00AA; Mon, 11 Aug 2025 21:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6118E0045; Mon, 11 Aug 2025 21:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397CB8E00AA; Mon, 11 Aug 2025 21:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21BFC8E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:30:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C14471D92F8
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:30:26 +0000 (UTC)
X-FDA: 83766375252.27.6F12FDE
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	by imf22.hostedemail.com (Postfix) with ESMTP id 83222C0004
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:30:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z4FKGX0W;
	spf=pass (imf22.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754962223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=rJtMhxG0CC4esB6fCW7JlC0j1dcPXxerVyBTQqMG6dk=;
	b=KOMU8ccacfvKop0if0w4wd8JGs6W6CB0E4BhNbOv8uMZwJHeCz5nux0sc689RElTJXtZc4
	IbviAVnYaqCLsy0YdyA3EtiRy/tk5jNdHLnvSJz15rcQUHgtT5MiBuB+ZS3VcpkIdpc6YI
	+ztSf7szohEhiLyRHwAeGb/LVKBt1UU=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754962223; a=rsa-sha256;
	cv=fail;
	b=RqmMgqJhNY6dByCXHgvQdkshP5efLsViWvo/8apHQ+5GgVHWO7Bk9h+tTThHBmSFvg5SSM
	Qf7jj6/caKfr7e97duCEMZeSmpeiEXoKt2Z0WMj5t36yHQIMJn0qPXW8aJ4OErdfdO20B6
	xyPTzQTBEsluvLhWNW4Vjp/DA6+ZmYU=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Z4FKGX0W;
	spf=pass (imf22.hostedemail.com: domain of oliver.sang@intel.com designates 192.198.163.11 as permitted sender) smtp.mailfrom=oliver.sang@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754962222; x=1786498222;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   mime-version;
  bh=ZAD0fj6NNfjKTFw5a1QyYD5phnrJ9FchEdjbd0DPBLU=;
  b=Z4FKGX0W7LLyfJ7azxsN0d40U6qzMZqobXU+7L5yJ6KlVvRjnBMduKjj
   UJT/DOQ2cVKjuswqOrpABQMXzxLf/j0FHvIJasw8rh9B9vsj+6sv517DD
   ro1WF5uALhtMeTZMfjTsJh7cOwn6sIuPItIvjS8cJKjUq0P3170MO62vC
   bQWjITQ8r105pZKVhD6T0LqtRNpKsCe083wyTrcZ9KexYIB6bp+QrpFNh
   7xUu7/B+1qmK8DpRFH75ad1w0YEhur2jxwZ8RfxOq5W05GcqKrcD0VfCl
   EX2ekQMHodjWn539hvbTUxTGKc1NXbSN03IDf68ihjTSaau+9L3nt8fd7
   g==;
X-CSE-ConnectionGUID: CLwOmrmcQ6i73Rs6wuFzgA==
X-CSE-MsgGUID: BKATJMHwTdi01DZ3LzhmJQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11518"; a="67826740"
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="67826740"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 18:30:20 -0700
X-CSE-ConnectionGUID: RmdOkuKFQPCL/GkhpR4tgg==
X-CSE-MsgGUID: KBH5B7tLTTGJF4vcrW0hpQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,284,1747724400"; 
   d="scan'208";a="166416564"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa009.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Aug 2025 18:30:20 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 18:30:20 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26 via Frontend Transport; Mon, 11 Aug 2025 18:30:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.40) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.26; Mon, 11 Aug 2025 18:30:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=OLuA9ZlLhBZIN7MFXVQLdQUUhJxju4+o9PmHQj8rhWESX5KeJXSlnnD2YWpBTZTM+4/vPusa6AZs5Bg7ubr/EI3AEVf02MqCz5/htwg3qlwfHUac3mOKhHnfLUPHyiHzAQSb7tmQPmoYD5u3SrxkrT/+9FirBjkWIpqtZ5bJM4rXqBLSCcC0kC330GcqzWy+ipMIaBUQcpnXU9mJFiBQJ5I3Qda+bbBYYuFc3+PH/vZid0b35QvtHw2C4EOhW37U0qHZw67Kgzxf/Nn5xSOIVbJ207VO9CiADOcGsY6hItJIAe5baLRY+noRwQOVg0ewSqPolM+/Ft/J3xFnGJrCiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rJtMhxG0CC4esB6fCW7JlC0j1dcPXxerVyBTQqMG6dk=;
 b=DvYfYc0aKRUmFqDZB6GoxyxvzPMFT17+zOMOyjQr8p7MEWcWNjoPoCT22EThpXiuDp21mj2X+zOkOMGxNOJ3Nx7N5iCtG1yX2JZEO62bYl4V9rmaiI7ByJVFKfpcRHbRfOHtmtl7af87FoqwxID9/kp6PbPDYQurh1PZaYJZYY3M4ETprSPrKPp5kODmzg3wVDEk6LEEAH8wz2cguZkZEK/OGzRrfemmcAdi2Sgjzanh2LetK57SdKaxgl2yeMUi2A89FVWCAhyLT1VllxzLf7V8y21y0wQwsPP05Z6pWdLIgRbNvn8SDrgyuaKopHABbwVFl5hA8ScCbG/YYPn49A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
 by IA1PR11MB8830.namprd11.prod.outlook.com (2603:10b6:208:599::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Tue, 12 Aug
 2025 01:30:18 +0000
Received: from LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c]) by LV3PR11MB8603.namprd11.prod.outlook.com
 ([fe80::4622:29cf:32b:7e5c%5]) with mapi id 15.20.9009.018; Tue, 12 Aug 2025
 01:30:18 +0000
Date: Tue, 12 Aug 2025 09:30:01 +0800
From: kernel test robot <oliver.sang@intel.com>
To: Chen Yu <yu.c.chen@intel.com>
CC: <oe-lkp@lists.linux.dev>, <lkp@intel.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <aubrey.li@linux.intel.com>,
	<yu.c.chen@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
	<mingo@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, "Gautham R .
 Shenoy" <gautham.shenoy@amd.com>, Vincent Guittot
	<vincent.guittot@linaro.org>, Juri Lelli <juri.lelli@redhat.com>, "Dietmar
 Eggemann" <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, "Valentin
 Schneider" <vschneid@redhat.com>, Libo Chen <libo.chen@oracle.com>, "Madadi
 Vineeth Reddy" <vineethr@linux.ibm.com>, Hillf Danton <hdanton@sina.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>, Jianyong Wu
	<jianyong.wu@outlook.com>, Yangyu Chen <cyy@cyyself.name>, Tingyin Duan
	<tingyin.duan@gmail.com>, Vern Hao <vernhao@tencent.com>, Len Brown
	<len.brown@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Aubrey Li
	<aubrey.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Chen Yu
	<yu.chen.surf@gmail.com>, <oliver.sang@intel.com>
Subject: Re: [RFC PATCH v4 01/28] sched: Cache aware load-balancing
Message-ID: <202508111054.58c525c-lkp@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9157186cf9e3fd541f62c637579ff736b3704c51.1754712565.git.tim.c.chen@linux.intel.com>
X-ClientProxiedBy: SGBP274CA0016.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::28)
 To LV3PR11MB8603.namprd11.prod.outlook.com (2603:10b6:408:1b6::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV3PR11MB8603:EE_|IA1PR11MB8830:EE_
X-MS-Office365-Filtering-Correlation-Id: 39d74334-32a5-4aca-f5d7-08ddd93fcba9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?hnZozQAl2cOWe+LCFosupOudmXisr84lOMCVAu3ue6CEgiPxUo+B7ZhwTJrP?=
 =?us-ascii?Q?Jr2xlb+p2grg77rXtxokKxJXQbKm1eHDEv+/ZsN5uM9HSYSOkiSE5WpkOBST?=
 =?us-ascii?Q?moQwlLhuO/UCzGpoyaB6WUvzPU3bLK4mrbOp2YJgZ9w+rlLoiV8cmoXzF5/K?=
 =?us-ascii?Q?itvTGb8+JkNaqITC+AstZ05n7943XKCcHsASiDAOgylu6xOmiSHvo5qQ4Jjr?=
 =?us-ascii?Q?bAmnEnyf2Ru9QdMJJKYE3mGJzrL7kEnUBy4faV3m0xdkS9/op5H0QjorbNW8?=
 =?us-ascii?Q?U/a1n8RqnHun1YVODQGQI4Y0zfgN4sHGmHcYFFG5qHwEGO4LbC36BsKd1J7S?=
 =?us-ascii?Q?bPybPDyAlgv573OqddNd5C1yydDWnoYTWsS/xrf/DbSIzFZj5tu1oT9JODUk?=
 =?us-ascii?Q?7Y/43iyT0jOLtqBCyagAJcVC8Ni51RUt2MN9Onh490BFWbhPgTC0/tn8UWmW?=
 =?us-ascii?Q?nV6LSE0OnwHzbHCHRPCSQtm1JfKk1ixAgwsszVsygHb9AZJ9E8aexH8VXG04?=
 =?us-ascii?Q?K/DkEr6IJanqD8+b9uV1eju9zRbq2j5NrDSXb66ocJP3NFgs8p1V32w4nyRQ?=
 =?us-ascii?Q?Nx1TZtdnhMvJoEEdEK6xR11sUOTXYF6TmmidiOZRObqWTsgLkC1hPiqz69jG?=
 =?us-ascii?Q?rh1+fLlXIXAsPmHtsi4tRova8tbfQq76oUGVFuFUozgWn3r5GxSnoyg6lqBl?=
 =?us-ascii?Q?QaUzknaqGAFf50cLPBah+ZGNVSw6k76JqUUNIHyRGKNhNVaIzRhT7yD9Uqy4?=
 =?us-ascii?Q?WegwAyqQRmGnJJ1tn0kAdLqUH07ryknO3lj1NddJLXE9C+XvIo4WXeifQwY4?=
 =?us-ascii?Q?0xINW/4eWo411YlYsNYBdzoN59oFZy0jauwdC/wSppXUdi6OcAUudtXTD2tm?=
 =?us-ascii?Q?94PcqILlCtjGlK1srzPDgk/mbqiov++zx14W0tneBSdVDT0hptSxmoAXPA2R?=
 =?us-ascii?Q?V3lHBj/YxNYXFIkfhMBybBHC/q0CzyQC90ad3/YBX2IXilm/8t+hulw6S/ZF?=
 =?us-ascii?Q?VSB40RFQQ2o9MwPfFjJ526E13iRUGxc2eQypqba10+miWsyI3F99NJRlvyNc?=
 =?us-ascii?Q?b1FtKEnif2shYRi1sUA+H+lrTiydDhYnWj9dP0mA5f1ZFXt2UMFm5VMROxmS?=
 =?us-ascii?Q?9CwBsYULfzhvJhOH0dpNC42e+nWP7hRCNp+VU8Mg/d6cF/aCYRqRqTeSUXHh?=
 =?us-ascii?Q?WAKOGn3MFnVmdfcpiTjDvyKdrk6Wnd/sfoaUsnIr7w8J+7QPsW65ol6WyAAR?=
 =?us-ascii?Q?ygFkdDBuz7/Pt5omkqSsXQRJWhYCEBx/rnDstz7o1ak1CtjeppWU0NFwxKEl?=
 =?us-ascii?Q?THb6Fx1qfDeEKgXzCtuoW5By547+aZv6WZnZHhadoQhg05gNgygLGTwkmVgI?=
 =?us-ascii?Q?oZGJUhAdrbdAVIhPjRZ9+gfTR0ng?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV3PR11MB8603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9YasGHVwhrODohvVItMIPGPJxa8WyGNpnG8sbz+T3fheG3lQkMjPOjMJXtXq?=
 =?us-ascii?Q?dDKU3E7R8VWiV56XY1V0aM/yZ5zq67QZlvXR1WXJVCX2DBK555f2gLvTzph+?=
 =?us-ascii?Q?uFRro/WdaR4sqGipa+6PFGtpk7IPf0TKOul2TNV+h5He60Ex0FqS/nBGElUP?=
 =?us-ascii?Q?e6f0QsIjKGWll36POvJvtRuTLuiYAz52LXF+OXIc9d/47R7lr1gelFNclfik?=
 =?us-ascii?Q?g0vBC93ThmolTgr+irJpl29FmD19NW3azQl1quNsPCyAktgJEpK8q5d5js2c?=
 =?us-ascii?Q?fSN+KFUhX60mYMgQIKHo0uUMS20P0CJEYqY4lDB+S74GyIFicRIaGY6Fo7TZ?=
 =?us-ascii?Q?VWp4riiJz4FJwwZi1Hi+EKEBw7Wk7HTEz6pNvxiX5hkxNLvRzSUAEL+VvfUF?=
 =?us-ascii?Q?10QgxduGteRbXdvsLP6zJsTTziUFupnJyRikkPJ1Pw2I1v81Os2PShrfbGHO?=
 =?us-ascii?Q?uhJYWrrxyqQRRr28YdPnBC4aAHw9k6K9z1V0BBGb3qd5YY6DvXOP6Ndr0CTC?=
 =?us-ascii?Q?2uxD1mOpWwxI4raVcRPYLnOn9YqB4SedSLJXghUEiaIHsOUHEvQln7k3181H?=
 =?us-ascii?Q?RId9/g9hRT8t6DqTtBtDpDMPLlAC1qkOZzdnyte+mwuwQ9MFdFnVCdn+Fj3g?=
 =?us-ascii?Q?j23DFjVUbSynvhoNlJPtREHpfy3K9yFjX6O1ydUMHuSiGEJ8lr31W0Zaohsb?=
 =?us-ascii?Q?gOjmCe+E74V8BikskrakjM/aOGUVe+85dalF1L+zY5i2hctWtJaFx1wH7Kux?=
 =?us-ascii?Q?M9yxnUDbhYXcxsURqviiftD0G0iRUcDQahgaGSWQZGhm16LVfGNTdWdqnWQh?=
 =?us-ascii?Q?0NaeJFpR7a36B7HrVuudezg9qKMoEEW/+P3+Fg3hD+HZnCvL4DULldSDhmD2?=
 =?us-ascii?Q?9rENVGWzeVC6J+SB9w+pFNWkFVHXAHpDD60Rst3cjZhUlCQ3M/3pj7SZe7Y8?=
 =?us-ascii?Q?LTDfdNvwHABKgT3/XALH9zQ6FCWvJH7wgTNrDBjTweJKwUy/25p5rShedlBc?=
 =?us-ascii?Q?tc//+FFZWgObWzE2E8a/gjVW3pncXkQVDJMDGEkULQcs6Nv7ozd99Pns5Ozr?=
 =?us-ascii?Q?OYCkOdbI0vEOCRpP9CWXd0kx2Oky9Oj3c0e58LtcF8LDZf46/pf5uWmMMaKL?=
 =?us-ascii?Q?HM6BIppH0wXf3+/YjKndvylGVWYwUIxpZg3S8ekefVb73iHc9F2FfWouqZ7U?=
 =?us-ascii?Q?wxiiFiyRTMyGPYFLNWQtFHoqehFijAxU/DH2d1kgKnrpIWf3e+ID7ob7s2lI?=
 =?us-ascii?Q?cGevGiq8XgdrCHBkYJlFIqTnDqnfgH11GuqYX6q9SWflA8wZtSID3F+TJzVx?=
 =?us-ascii?Q?I76ax3BkwrIc831PGD4xuJKTIS05QCglgJCBgNVK99rFWyOKh31ue6zijh+Y?=
 =?us-ascii?Q?S3FMOCVGo8EXgi4JPw8OIw4DkimPRefsjYoquf47h4YIQDeboEEFeyVQwp7h?=
 =?us-ascii?Q?oYFzYApbNdPK9d2qOoUY0lWXs0vidoVEL+W0r8i9lWvEtmNQN3N0WvkbAlq+?=
 =?us-ascii?Q?rmGX/6p9VGk2Vz0n3JTMYoCawemzzMETD/G6lF/63ad0RO6oIJIHVdaXPFcE?=
 =?us-ascii?Q?TPCaPGWplb+2SJ0jbqWjQYg2xZ493NSSKyPcvReq9ve4FBe8MUnI78vLUrly?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39d74334-32a5-4aca-f5d7-08ddd93fcba9
X-MS-Exchange-CrossTenant-AuthSource: LV3PR11MB8603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2025 01:30:18.0797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TEdg42mbu3f2vxFyZBplHz1vGWTG34e++UimQdBkyrmgglh7M0cqGedAMjFoTF51vRmm93c8tqoVZdhHF9eSfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8830
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 83222C0004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7anbajfthcuhi7co9h6gx19a6msahe53
X-HE-Tag: 1754962222-381418
X-HE-Meta: U2FsdGVkX1+VPwqC/eyP2Jil4N5EIiHl3zYuwLW0JoY8uCPJIbIsnzJloUczyk0gg4aTI2W3cRQcyUu7ZDiHwLA38mNoQJUsJBGd5qfYApxLKIbs+nQshZU7UpeP/FckLq+spel3FxhooC8ftnOwFCdvdPhiFJOROkAIhh5KrSQ1c6aqul3HMULWpSlz0ZvsICTy/jRXxceoqAZ4eNQ0CTaAjTYCBa+BoW3y/AEr7KAcCdHYCencUzuv25LZdCW3boHkjLbZBOCr6lY4Me6ghAmnMr0CYcNt/jHL8WkxOZ9hfxZjAcpTgOOPrxhg93PLlb7TnUL2Goc9NzmjuTnq+X8yz+pPoiic6ogKArK4d6riRAk7EpNlYN6Pia+en2aWPPT1f38NI6eOqMQUNApdKoZ01WWKwajoDo+/kmiGfbs/gmuH1APtT17M7Vo+2gPo+wtruQowAiU8KWsnQS2uST+62GfHevOip7twkSoEtm6S1pG7r09yLgkVtZvGDAQDBs1w45b5Nsp7BsJiDfW+uB+ctdLzW31sWBEyPuXefQ8oTw9h0zO9eGVUDgdZxWYvw1dRYOZsa0pywF9CDUfsIJPzXCt9zOevwc5wgsuceVB7qZiPnnRik1C/8RbJS52BKQX5aNCRpWmKEQK58IKLjIUEFct+Q1q5HvW4redf4rZC4zNVo2GL7Iwlm5V/acmjz4syVQQGgLeFda6Wj3dAKBthqAn7u62o8ncqDxZA5pZWjXtVAfSSKQMBhZOi7DQw/HegqZUk2X68Leg6Poavr6zjKpds8TfaYbn4A+nWkf4+RW2WBQk+YJsgpul5plviaclfjxdC1NNTuDPcMpp4yult5OsLoDjdQOw+aIw3mYSPW83u29zsx8BLADuMtI9o4ZsRPlc5/eUmRNeYDT+wiAu5XV3VJnxtam0XDyd3p8ptV4Mwsxf+vAn4pceWknsdADlAB+g871SMJ2Qk2RQ
 YqpWkZfm
 dU3zzAvLn8iNarZbQGvqx2Ul2UhNpfbQaxK0JSqMV2rq8MCcvaKcBOktLsQ5xgyniYmOP0O1owqUD9Q6zO1IV6rRR9XfMOCRzyBhQogsEInfQg0mi+2Wn613rVDye4vjuXnT7hi2Q5Yf13kI4/GxxZHgieMNfMOi2nfncmKMBxwbegEfFPL/9PfSPXCy9HAQH0N/m5Ejw2kZXJyC29BlyD7V0EI500hU12aABrh8WkVJBptT3wcnI4Ze/Y3jsM0R1syuzPvBMOXM9Er5QLD6eFy/r/bOEWmWL4/3e6uh3y3XJtBSKlk/bIVoRejhxdMztu8/pABdYQ5FnVgSecYGwRF+CVOe7NqBu2V7YngjciZQZ7BX4FMqkInrdMtmBNjAlVKB8/hhH1PhbwXEz0g9Q1qxBlWed1FDZel3//LMEtbvr0ZKgyeUFh1QfoZY/ojUa2PesPB9NGUB4+VVLwoKPmiGYRB9qVGEwQ5jC7HWoNJ776DtEKsGBOzZjM1eyPSC+pp99eC6NFFe8zQupXPe0OyTZE70LhAWz2Estxpg2S0EvavJ7icITtx7Pxbc/rgrB8vq1xfGOXHD0p91+MUfAxylQA4Hda/QkKNoMUIz1QsdPaaVOjdFtwj9Hg19ronFqvmfDhJuTenpENIqq2usR8KbRuu4WHZOUBcEsrvCuptAzGCieNzBXyBxhC3KMkaI4MUooepkeWJrUEA+cZ0T7j8YXcaFaPp6S0F++dol3a/lBovrj9J9bZWRcSr4GcHwQ9Ij9QdAJ+tuXpy8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Hello,

kernel test robot noticed "Oops:general_protection_fault,probably_for_non-canonical_address#:#[##]SMP_KASAN" on:

commit: 2ae6ef14daceb295598846a328dd65fde6b16c99 ("[RFC PATCH v4 01/28] sched: Cache aware load-balancing")
url: https://github.com/intel-lab-lkp/linux/commits/Chen-Yu/sched-Cache-aware-load-balancing/20250809-131716
base: v6.16
patch link: https://lore.kernel.org/all/9157186cf9e3fd541f62c637579ff736b3704c51.1754712565.git.tim.c.chen@linux.intel.com/
patch subject: [RFC PATCH v4 01/28] sched: Cache aware load-balancing

in testcase: boot

config: x86_64-randconfig-103-20250810
compiler: gcc-12
test machine: qemu-system-x86_64 -enable-kvm -cpu SandyBridge -smp 2 -m 16G

(please refer to attached dmesg/kmsg for entire log/backtrace)


+----------------------------------------------------------------------------------+-------+------------+
|                                                                                  | v6.16 | 2ae6ef14da |
+----------------------------------------------------------------------------------+-------+------------+
| Oops:general_protection_fault,probably_for_non-canonical_address#:#[##]SMP_KASAN | 0     | 5          |
| KASAN:null-ptr-deref_in_range[#-#]                                               | 0     | 5          |
| RIP:_find_next_bit                                                               | 0     | 5          |
| Kernel_panic-not_syncing:Fatal_exception                                         | 0     | 5          |
+----------------------------------------------------------------------------------+-------+------------+


If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <oliver.sang@intel.com>
| Closes: https://lore.kernel.org/oe-lkp/202508111054.58c525c-lkp@intel.com


[   18.108061][    T1] usbcore: registered new interface driver i2c-diolan-u2c
[   18.111512][   T36] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[   18.113593][    T1] Driver for 1-wire Dallas network protocol.
[   18.119966][    T1] f71882fg: Not a Fintek device
[   18.120517][    T1] f71882fg: Not a Fintek device
[   18.142462][   T63] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000012: 0000 [#1] SMP KASAN
[   18.144289][   T63] KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
[   18.145594][   T63] CPU: 0 UID: 0 PID: 63 Comm: modprobe Not tainted 6.16.0-00001-g2ae6ef14dace #1 PREEMPT(none)
[   18.146207][   T63] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
[ 18.146207][ T63] RIP: 0010:_find_next_bit (kbuild/src/consumer/lib/find_bit.c:156 (discriminator 2)) 
[ 18.146207][ T63] Code: 48 89 d3 48 83 c8 ff 83 e2 3f 49 89 fe 48 c1 eb 06 c4 62 e9 f7 e8 b8 ff ff 37 00 4c 8d 3c df 48 c1 e0 2a 4c 89 fa 48 c1 ea 03 <80> 3c 02 00 74 08 4c 89 ff e8 cc 76 52 ff 49 8b 07 4c 21 e8 49 bd
All code
========
   0:	48 89 d3             	mov    %rdx,%rbx
   3:	48 83 c8 ff          	or     $0xffffffffffffffff,%rax
   7:	83 e2 3f             	and    $0x3f,%edx
   a:	49 89 fe             	mov    %rdi,%r14
   d:	48 c1 eb 06          	shr    $0x6,%rbx
  11:	c4 62 e9 f7 e8       	shlx   %rdx,%rax,%r13
  16:	b8 ff ff 37 00       	mov    $0x37ffff,%eax
  1b:	4c 8d 3c df          	lea    (%rdi,%rbx,8),%r15
  1f:	48 c1 e0 2a          	shl    $0x2a,%rax
  23:	4c 89 fa             	mov    %r15,%rdx
  26:	48 c1 ea 03          	shr    $0x3,%rdx
  2a:*	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)		<-- trapping instruction
  2e:	74 08                	je     0x38
  30:	4c 89 ff             	mov    %r15,%rdi
  33:	e8 cc 76 52 ff       	call   0xffffffffff527704
  38:	49 8b 07             	mov    (%r15),%rax
  3b:	4c 21 e8             	and    %r13,%rax
  3e:	49                   	rex.WB
  3f:	bd                   	.byte 0xbd

Code starting with the faulting instruction
===========================================
   0:	80 3c 02 00          	cmpb   $0x0,(%rdx,%rax,1)
   4:	74 08                	je     0xe
   6:	4c 89 ff             	mov    %r15,%rdi
   9:	e8 cc 76 52 ff       	call   0xffffffffff5276da
   e:	49 8b 07             	mov    (%r15),%rax
  11:	4c 21 e8             	and    %r13,%rax
  14:	49                   	rex.WB
  15:	bd                   	.byte 0xbd
[   18.146207][   T63] RSP: 0000:ffffc900001f7d28 EFLAGS: 00010206
[   18.146207][   T63] RAX: dffffc0000000000 RBX: 0000000000000000 RCX: fffffbfff0bdd81a
[   18.146207][   T63] RDX: 0000000000000012 RSI: 0000000000000002 RDI: 0000000000000090
[   18.146207][   T63] RBP: ffffc900001f7d50 R08: 0000000000000000 R09: 0000000000000003
[   18.146207][   T63] R10: ffffffff8145362f R11: ffffed103099ffd5 R12: 0000000000000002
[   18.146207][   T63] R13: ffffffffffffffff R14: 0000000000000090 R15: 0000000000000090
[   18.146207][   T63] FS:  0000000000000000(0000) GS:ffff888428798000(0000) knlGS:0000000000000000
[   18.146207][   T63] CS:  0010 DS: 002b ES: 002b CR0: 0000000080050033
[   18.146207][   T63] CR2: 00000000f7fc18c8 CR3: 0000000185368000 CR4: 00000000000406b0
[   18.146207][   T63] Call Trace:
[   18.146207][   T63]  <TASK>
[ 18.146207][ T63] task_cache_work (kbuild/src/consumer/include/linux/find.h:71 (discriminator 2) kbuild/src/consumer/kernel/sched/fair.c:1325 (discriminator 2)) 
[ 18.146207][ T63] ? _raw_spin_unlock_irq (kbuild/src/consumer/arch/x86/include/asm/paravirt.h:671 kbuild/src/consumer/include/linux/spinlock_api_smp.h:159 kbuild/src/consumer/kernel/locking/spinlock.c:202) 
[ 18.146207][ T63] ? __pfx_task_cache_work (kbuild/src/consumer/kernel/sched/fair.c:1299) 
[ 18.146207][ T63] ? __this_cpu_preempt_check (kbuild/src/consumer/lib/smp_processor_id.c:67) 


The kernel config and materials to reproduce are available at:
https://download.01.org/0day-ci/archive/20250811/202508111054.58c525c-lkp@intel.com



-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


