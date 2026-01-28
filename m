Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB7FD3F06A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 14:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B3AE6B00AC; Wed, 28 Jan 2026 09:12:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 437B96B00AD; Wed, 28 Jan 2026 09:12:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6A46B00AE; Wed, 28 Jan 2026 09:12:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 183546B00AC
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 09:12:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBD861405C7
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:12:06 +0000 (UTC)
X-FDA: 84381561852.05.33E5C8A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf01.hostedemail.com (Postfix) with ESMTP id B5C474000D
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:12:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GaUO6wRu;
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769609523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r7kCJVVlgnGslYOU61CShHcRNJHd9IJnD7E01i0gwbs=;
	b=Idn31/bfQzdYLzyDTyQ2rsPk9G6uk9r9bHpfvIuuWptEWwQh8AR0QAxzvo8GKFcQTPKQp9
	DIpVo0LiJaM13t2JrzKLo9QoaA41W3/9vPx5azbphotoASNhoHUfE6gHv+ZWAJ11yIdDbQ
	nJ7lZ8eHn0jOjbq1l6p57vR6J/BLc74=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GaUO6wRu;
	spf=pass (imf01.hostedemail.com: domain of tianyou.li@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=tianyou.li@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769609523; a=rsa-sha256;
	cv=fail;
	b=MwfazLEzXtZBHwdA22BFa1w62pNQJ+NJkCbiVnUFmbg7PpAFhT2Jw/W0nHJqSrCfAirlb7
	A/7a4EGynbE+cJI/Q3wqe25bLdA4U419syYfpX9tXM68PXHewJloPs4cDgWkpuphVW0Vm6
	YIURIuis6VnWGDNVtHYxSF2YDCHEq9E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769609523; x=1801145523;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GUETNZR+scz7Gqsuh5PMkqukItudrz9laD7fK+uVirU=;
  b=GaUO6wRuMglujnMidIkkUyj3v7F+jbhFzy/V7cdBLm+XGvlgHuDH3Hm7
   3FrLUH7Jk1SzWgDKScKsSBrvBLy4hXGTcHc5lgOjSe/d9M0hsVuvaIdND
   gh3iMjLkdM1pRK1f1uCRnjl49J020+35XLrGIdt6yoIk84pcQKzyQzZuX
   Y6wcW7oX69n9OsA1lXKgnw/zHUGT12ICadn1vj8DtHis3+ZQV82UJcvg/
   Pu0miaQWBhBZXRlalNNM9U6Z68/PyZW/VyoXmr0q0Edz8t1bJZxRK6vcR
   SvrY2LdKuJAl9y0JWmydWYIt694ZHcqYzVkXphmyYsDTmrt0M1DyHhOZc
   A==;
X-CSE-ConnectionGUID: QkD42/58Sp2eHPe0o0XZlQ==
X-CSE-MsgGUID: r64SvrV6R32fmkFrU9MT7g==
X-IronPort-AV: E=McAfee;i="6800,10657,11684"; a="82189696"
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="82189696"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 06:12:01 -0800
X-CSE-ConnectionGUID: e7nfbyE7TDu52jCHjY46mg==
X-CSE-MsgGUID: al7zUhZLS9iFO448sGx9pw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,258,1763452800"; 
   d="scan'208";a="239530100"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jan 2026 06:12:01 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 06:12:00 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 28 Jan 2026 06:12:00 -0800
Received: from SN4PR0501CU005.outbound.protection.outlook.com (40.93.194.51)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 28 Jan 2026 06:12:00 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=whqLNsvwPVMH1UJHOZVQ8XXxpoTUjcOWVIQP1BfS2leYw+qqeGSD0zfpHEvHMHGAxmj7LoE8g8bjREf+lag6ptDu6j2jx9Cj3d2kbh3cPzg75Mhzgjf51bIpz0dbEjD9q6iu5YICjLunWBnbSYJ2P5ip2pBRSBaeNizkmErCGnmc83JZv5jRXqa96cQV/+s2iHAyfPUV1PJ4FETwmsaU+y3U08WTkhB60XDdCKAwuASHR815xopFnU+gbtxj0kVDj6FI5I2ZSXrO3wKHjAsfezVZoOM0E5DfHsreL7I9GiADgB4yQGjUjLrmexLibT/WuFLAbdvdYbzFWRXMSP2+Aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r7kCJVVlgnGslYOU61CShHcRNJHd9IJnD7E01i0gwbs=;
 b=fyS2vfj6Fa8le0C5HVlH2f4qpz6OnWU9fO6ogih6uyBdWdNDFxsXLzZ3teSFeaiBlzFqq/RtEv/xMVcZcNMlVjKXY23J4YEsE63spp3ILoMCs2v/Oj1LWZAeCeFAOdsEb0eSwVTbLdImoLpheGR9rcr5FgZBqzLF4OWXwrWHgU1HQKu1WnCjMtWa6ACt8+0THWhotgXe2MP+ESqc8FxqVFvEmwFWiTfhSOHMZGFu8xJXHgG9rfPGlD87h8oEjMy+Oojr0kUKqCxUWCeBXbkpTbKD8TpN9JXqRYlG70Obj4qn9lcriD9/ZmoN2Vv84eoGSgcc7D1IE4q1xe2P0EUpRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB8289.namprd11.prod.outlook.com (2603:10b6:303:1e8::9)
 by DS0PR11MB8685.namprd11.prod.outlook.com (2603:10b6:8:193::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Wed, 28 Jan
 2026 14:11:57 +0000
Received: from MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1]) by MW4PR11MB8289.namprd11.prod.outlook.com
 ([fe80::e4be:8608:3d70:c1a1%3]) with mapi id 15.20.9542.010; Wed, 28 Jan 2026
 14:11:55 +0000
Message-ID: <0c649fb2-cbcc-48a8-8d6d-9d7f8a58858d@intel.com>
Date: Wed, 28 Jan 2026 22:11:47 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/3] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Mike Rapoport <rppt@kernel.org>
CC: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
	<linux-mm@kvack.org>, Yong Hu <yong.hu@intel.com>, Nanhai Zou
	<nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>, Tim Chen
	<tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen
	<yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>, Chen Zhang
	<zhangchen.kidd@jd.com>, <linux-kernel@vger.kernel.org>
References: <20260120143346.1427837-1-tianyou.li@intel.com>
 <20260120143346.1427837-4-tianyou.li@intel.com> <aXINUc0ZJSJusel2@kernel.org>
 <0f679956-fd29-4165-a136-18f68e517fb5@intel.com>
 <aXhk2F3gSXHnCo5s@kernel.org>
Content-Language: en-US
From: "Li, Tianyou" <tianyou.li@intel.com>
In-Reply-To: <aXhk2F3gSXHnCo5s@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2P153CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::12) To MW4PR11MB8289.namprd11.prod.outlook.com
 (2603:10b6:303:1e8::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW4PR11MB8289:EE_|DS0PR11MB8685:EE_
X-MS-Office365-Filtering-Correlation-Id: 478a6ce9-17ee-4e56-15fa-08de5e773187
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?WXIrQVhxTGNmaXFtZnBXNEo5VGxuU2c2VmxQQjlFb0tFRGhpZnVLb1B5NFVH?=
 =?utf-8?B?M2dRd3B1WmhVRTJTVmpKbnVkNGhHTWdMTTF2SEhPZ3hiU21WWFVTdmJTMVky?=
 =?utf-8?B?cEs5Q3ljQWRKY1lJYlBFeUdqVEpxRGkyTE5HOWRrUEx0SG4zbW9QK3VvSllE?=
 =?utf-8?B?L2JKUXNuU1J5NjNyRlMvR2dCeHlHVTZ3NU53dDdrQytXS3Ztc2Era1VKWGMx?=
 =?utf-8?B?VVQvd041a3JKdXpVUGV5M0lvaFNqYkNhRGY5VW8xS3d3ZVVhTzBycmZ1T1N6?=
 =?utf-8?B?bDJ1aHlJMW5hRXdsWlFWOTA5SEtNN0ZCeDVkczNLZ0V2ZTl5ZmJaRElpRzl0?=
 =?utf-8?B?NitDdFUzTlY4aWJGWEZlVTYxdWl5UTlidVpsWng0cGUvQUJBQWRjNXpCN0ZC?=
 =?utf-8?B?Wk1xaTRKeHdWdzFMcnVlSndOM2ZzOVl3OTFTZ1U1T0Z0aTlBYjJERmtvTkJp?=
 =?utf-8?B?VEg4WmcyM3FUT3Q4WHNYWU5xYXhZVy9GdjZFL2RneG14cXpCR0ZGelRGOG53?=
 =?utf-8?B?K0NHZEY5ZU9JQlJOcTAvUDN2SkNXUElSdFlRSExjOE56M0pGdWNuckFmYW94?=
 =?utf-8?B?QlpmMUdSdzAxbTVXSCtaWHlKOHhJcTQzU2xtWDNNUjk1aUVuZVAwKytHWTJW?=
 =?utf-8?B?SUJkalFDMnlUaWcxUG9NKy9zeW1KUHAyb0NXRjB6QktveUIxTE1wTTJiclFj?=
 =?utf-8?B?UGtwMjJoZ2pkMGFQWHl0RkhqK296L2ZoNnFMeEx0NEtJYk9pSFg2amF1b3dC?=
 =?utf-8?B?Ui9CYzdWMm1Kc2FSekN0MytKb2d2ZGZYcElSa0JCRlBBUEE2Y3hIbWhaaGtH?=
 =?utf-8?B?Y29sc294N0NMbUFPeFE3cm41aHFrU0c3Z05KeHl6b2N3ZUVlS0RITVRmbkht?=
 =?utf-8?B?ZDhGQjZ5N0d3VHNKcGx0aTU2dlRld0xKQXpoNHlXSVBVME44cHJzM01GMVdu?=
 =?utf-8?B?MDFyNTdqZ2pMdzRtOFJTeHNiOWFoaUZXUGw1ZUp0bkdwZGpwMkpheVBlOHNr?=
 =?utf-8?B?cjJTdlFESzlJOTlBaHBROHIySzk5cU1IY2o4bFlzYlMrejhtTm1QRHZmN29y?=
 =?utf-8?B?K21MRFNSSzJXZzdaU0dGVXBsYUFMa1o0RnUybnkrTGM5ei9lcERDTzJhdGpE?=
 =?utf-8?B?SlMycWJldnRKeWtIYUt1UDVNcERXNWVoSW9oUU55M3dBSnUzK3BrSzQ1MGcv?=
 =?utf-8?B?YVQwWDkrNmxVN09nTXRab25iTFRnS2p4OUt2U0NvVzkrWVdXQWUrMWs1Zkhl?=
 =?utf-8?B?aDVpdmgrMWxYTk9EUGNlbXBMYkFYUm1Sb2hyRXIxNHZ4TTZ4VEF4a2FQcmdS?=
 =?utf-8?B?V1lPYUFvcGxDeTRZSlZ2ZHVCbWNLb1dVdHREdHQzbHNRVTU4R0d4NGFJZGp0?=
 =?utf-8?B?YXo4ekhVVGRiRUpLMlIybTRZendXbkRpYmd2ZC8rVEN5U0VDRTJuZk8vWmMw?=
 =?utf-8?B?cDFDNndScC9meGhPb1pnWGtQdWgwUTM4QldONzVFcVhpRmI5TW56cTRZTjI0?=
 =?utf-8?B?aWxqVHQwRE1sZmhtVWJPK25wcFRvU0VHWjkzd0NkRUhzOENKQXAybXl5VnhY?=
 =?utf-8?B?ODRWbkFWcmliaUloTXYwY0J2aHV1dHkxQjZBVUJKSDBHUGVFUURLWG96cHM1?=
 =?utf-8?B?Qm55ZXBseG1qbTFQLzZ2VXVQUzduaXQ4UndaREc1bkxBYnhXbTBISUZEUXdE?=
 =?utf-8?B?M2YrZitaS1dENUtlSWVyTnVZLzlPRmZ1NXJrRmh6Y0ptZ3pqTXVVaGFzVTZp?=
 =?utf-8?B?WnQxRTFIRDFSQ3RWTkVrcm4ycE81My90Y1pIbEtqaHNRbVdwRDZGS29aNTNn?=
 =?utf-8?B?ckd2T2RUYnVuMWVuVjBOTk1kalM2WVJadEpsdDhtK2poaSs4NjJ5UE8xdURB?=
 =?utf-8?B?V2hLQXI0eXB6NjMySGlTb0VRSWQrSDJTVi9oV1FoN2FBWUlZZW9RZTNhZE55?=
 =?utf-8?B?Rk5OOTc4YXBXM0t1SG5qUlc1L24yVnFQTVhjWm5oUEJlUzRjbkovay85K3VL?=
 =?utf-8?B?Y1VDSDZCZHhmNUFuTGM4TWRFa2xYeXlVUFZQeHNNNlJzc2cyNUYwNHo5VXFn?=
 =?utf-8?B?UzY1TE9HUFpYUFZaaUlCK0gzQks3QnB2STAzd3BZOGJabGZzOXgrS29iRURU?=
 =?utf-8?Q?Xk2E=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB8289.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UlQ1cUp5TE9oRTNYTjBWa0pUZjlyVDR5S1orQVROQVY1N24rNWMxaUZsMFlG?=
 =?utf-8?B?OUJJWDVydXhMaXErQ2RJZnhrL2VxVzJkQ1llbXVnSktBN0xCNFZyU3VGa21s?=
 =?utf-8?B?RVpTanF1U0hUNWxTczNVWkJPU25kK0xoZURiT2QwYVU2N29Mc0NzakloLzU0?=
 =?utf-8?B?Rk1zTUVTWHdTS1lzVjZ4dDluckZIMXVVdGZQV25rYTBjYituVXBKK0RReW8w?=
 =?utf-8?B?MUExYkJMQ3dSYTc2M3dvV3VQa2QvNzI0YURtUFFmSG9oRnVHVXlJZEpObTQv?=
 =?utf-8?B?UWtjSnBoQVJwMExqR0dhOFVobWxDbHlmVFc1ejY4aFVucUVXeE9OazFZU1li?=
 =?utf-8?B?Nm5QSVQrcC93b29McnpBOFkvQnY5S2E0UVBqZEdKeGc0eFFRSU52VnMxUUpx?=
 =?utf-8?B?SjhWYTFmTHN1OWF3TGVPdEtWaktBeEJVbk9ublhRUDZwWGZoaEJidDhpR0Vw?=
 =?utf-8?B?RTdlbjB1WVpOcElXVUhkdmJ2bG8wcFcrQkdTTVVsSmcwS1JnSFM0N050bXBQ?=
 =?utf-8?B?RmppZk5FYW1DU2FPamwwSTN5VGpWZmFaajNRY0dHejFQUWVRcGdpbGtiMU9Z?=
 =?utf-8?B?ejlDbVFZWVQ3OWlva1p3c2p3S0VqcG9YeTF0T3ZnY09MZXdrRDFYdW5sczh0?=
 =?utf-8?B?anl0eHh4WFVXUm51ZFJuRXZuTEtmdlZDTEpFUFE1WDFSd3VXZFVVVC9HUElm?=
 =?utf-8?B?dFBsMkNTQTF0c1FNYkluSXpsMzNRNmJYT2F1VFo3Y21WMElYcXdrVXUza1hS?=
 =?utf-8?B?Z2hiMDRnQTltVG1xc05aNWhSMXhzZnRsTlhmMWNrVVBVN0NUMlhkaDd0QjBP?=
 =?utf-8?B?a3crdVhjTndqT3pqRUlnMkwwZllNOWJaV0c1dWpOVUNyb0RBb0g5NFhReFFm?=
 =?utf-8?B?em04d3loRzdrWmRram9TRUNIcEtBT0p2UStkTW80TlRqbE5ZRFNEVlUxQTlX?=
 =?utf-8?B?anRuRUtkdEpIMk5rV0I2U0NYT0NPNmpScndrc0l3TElKbVNkbSt1N210NnEy?=
 =?utf-8?B?cTFSQnVXOTl6QnBNeURBblExOHlPa0o3ZlludXRKRjR5VTk0MWdxaXR2N2JK?=
 =?utf-8?B?aE1pL3VGWjlOUi8wL3A5WWVUQVNCbmRHV2c0a0I1TGN3MHBnUFMwMENzQ3Bo?=
 =?utf-8?B?OExSdG42bnVVZ0RhbUJwZjlZeFpySUVCWFBrZE8xblpKc1JZK0tVS3pWWVVs?=
 =?utf-8?B?dWMyclhlWGM0YUkvMjV0eEo1ZThIaGRiaGJqdUxCUnFib1laNUxLc0xzOWN1?=
 =?utf-8?B?ZnloVmFlVVdUWmpNUEFRdmliWi80KzNUV0FjODVBeHFjTUZhNnlLbmo5SEhO?=
 =?utf-8?B?UG4zNFBWUzdyOVo3V0lRQVd0Y0pzZFRWd3NMZVFhVzNhY3NBdmN0L2ppN2Mv?=
 =?utf-8?B?Rjlzek5mVzRVWUcvanhFSGxEek85Ri9QQ2pFdXR3aVJOdUd6K0tYZUVsSTlH?=
 =?utf-8?B?SmxlVzBwVGJROFlRUGFNeGhSUy9uKyszQVJMa0czUWQzNklFRU96ZFdMdS8z?=
 =?utf-8?B?N09JVzIxOE9vdGZVYkVoblppejFWK2dRUk5SMUg4SGhjQkFmQU9La3ZxeFAw?=
 =?utf-8?B?TVY5cmVYK05FVUZFdGJnTkFMM0ZqL2FEOWM0dkJueFhGZDlnczRQMlhyYlVw?=
 =?utf-8?B?YjRpNk9pMVZibG1kUjBYblN1VExxWFdUdzR1b2t2OXEyVE9WMUhLblhWUGwx?=
 =?utf-8?B?bzhHSWV1N2VUbzRLN3VrSWlVbHhtaUIyUWl3UGNUR2ZxYUR5azIySXVaM2Fa?=
 =?utf-8?B?UlFiZi82NVFwZzkyaHhLYy9yS0luRXpySTNUSVdQMkhqTGRHdW16clc2ZkN3?=
 =?utf-8?B?Rk9wK09pd3l3OERKOTMxNnpYNUFtUXhuek1iTTlmZDE4Wk9oVnNpVTFqcDFE?=
 =?utf-8?B?UlZYOUE5WXQvV3VNSXFkRXhKaUZtQlUxTWFHZ0pZYVdKT0duZk1rSWVEZFli?=
 =?utf-8?B?c3lMOVdHWlZFbElBUkczZis3UEtFSWg0L2xsb2xNTm15QTUzczVkUGJxdEhl?=
 =?utf-8?B?ckZlY1VyemZmTTFDdGROeXIzc01zanNpUlRiM0s3ZER6RHVEZ3V5SkN0RGli?=
 =?utf-8?B?NWFzRi9lSVVqVHN2SmtCd0lOSk1WVnkvdVl2SURCYVZYQ3djdkN2Q1JvQWxk?=
 =?utf-8?B?UisvaWVoNmdHSGFPdC82Wkh5cEoxc1grTkdyK1ROdzZwTkUxZVc0UTF4Y1JN?=
 =?utf-8?B?OTJ2NVAvVGFUN01DTFZUSGJSWFlHZHppbUdtSDB0bVRhclVjdmY1V1pjT1VC?=
 =?utf-8?B?cDdraUZ5dDZ0V0VZV0paUmFuVGZPYlZtbUdUUjF6RXdIb2VzWlZRNkxKY0hC?=
 =?utf-8?B?dkIwaHFsY09VZkQ5ZVJiR3BkS2s0TDVTS21OZm1RTlJnQmVQSW03dz09?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 478a6ce9-17ee-4e56-15fa-08de5e773187
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB8289.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2026 14:11:55.9356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LNMqVmrHgF0A7QOuEeA7nva/N1SjS2smgnGefovxEJ+BsnhG1+kjMmV41o5DkQm2R+4NcSvx9EgBBTHukwX+mw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB8685
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B5C474000D
X-Rspamd-Server: rspam07
X-Stat-Signature: hzcgcf41dy7urmdy3qh7judhu8zqdje4
X-HE-Tag: 1769609522-762412
X-HE-Meta: U2FsdGVkX19LNiUAcm1uZY1qrhvbY258l3BKHdPtJYZtyAUPR8O4Ilz0GFXJvSnsluByringzsq4sUv4i3jvxZyRSryzQsEseyFjmZ288hHUVGEXqTCpwZ28332ldPgIZbj5xkXQ/uyA03Ag+ay78p1xm0LV2Drk/GDyBSynr/mX5RyAoeqmQUjCR+Mv4gegZe/gDtWVB2lkPzqrPFQ56GTO8a11cia8vlpestOMMjEiWFQoK+dbWFaEhPcp+1X2U4lZhkt7fl/oUUmCcAMb3IXqp57QWswaCqIzcnCRbRKew3b8Ze9MDRtM+T7aWdbjucYluzZaJg6kENYH1oSQMpuGlPdFs6ecS+iVpQOoHq7SKjzF0/1l2qn1+N6S0IPK2BB/NzB0iyanlBQaY4NL0Jkn9g7mUdEIkd8+z4A3Adgblv9KjyvVqSF7/OHq1p18uoF5iD4AjXGGFfpz6MsfuneQYo4V1ptCKxKXd63LJEXiNhX+8xfW2sMXDa3q8GB6ZnSig2r2VrFaUbwuBdrqZxxlj7Jj8Koz4EbNCgn23SsP07HSmDkeS1A1zU8HiO2yyw9LA8f6jbAnqUf8pt0U/iD44r+yJWpkO2WdSKwNf2HGxQWpPfAFuGyKnkQYRZm1O27l6KQBVJhqe9MGYEcjxxMK5NV1UErG7HE6DN16NSQTzKCqb0x9OR75HANF/bgzhpgfI2D2nzJCQFjnGKiD/osayrWNrxK4jhUDUTIhJdubQIsbi8g1QjskmONV0vbFkYFAc9JjhVzsVjLARDi4aZFnxY5lCyk3ezixKY5TCDr0CrztI7R5jocfkHGHeh9QouNOF3pL5HkKwcgB6x+nrF2PcGUXBGF7CmMedNNcSWFOzWFv//ZlAyc38Ki8o94h7tcIVDPfS/7jTO17lVAN8fIqgyJJepBTFi10VOXjRwlTKFuiubeiamrD+qQnF2qlkNI8u86wLPS1HBdmp1G
 hCUHfnga
 NSp8CJH5KC66suyqR7qesOEFy91n8MHeFoLtkcrR2XQxH7jMuw7R32hGPyNVLt5A+ObzF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/27/2026 3:10 PM, Mike Rapoport wrote:
> Hi,
>
> On Sat, Jan 24, 2026 at 08:43:51PM +0800, Li, Tianyou wrote:
>> On 1/22/2026 7:43 PM, Mike Rapoport wrote:
>>
>>>> +int online_memory_block_pages(unsigned long start_pfn, unsigned long nr_pages,
>>>> +			unsigned long nr_vmemmap_pages, struct zone *zone,
>>>> +			struct memory_group *group)
>>>>    {
>>>> +	const bool contiguous = zone->contiguous;
>>>> +	enum zone_contig_state new_contiguous_state;
>>>>    	int ret;
>>>> +	/*
>>>> +	 * Calculate the new zone contig state before move_pfn_range_to_zone()
>>>> +	 * sets the zone temporarily to non-contiguous.
>>>> +	 */
>>>> +	new_contiguous_state = zone_contig_state_after_growing(zone, start_pfn,
>>>> +							       nr_pages);
>>>> +
>>>>    	if (nr_vmemmap_pages) {
>>>>    		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>>>>    		if (ret)
>>>> -			return ret;
>>>> +			goto restore_zone_contig;
>>> But zone_contig_state_after_growing() does not change zone->contiguous. Why
>>> do we need to save and restore it?
>> Move_pfn_range_to_zone() will clear the zone contiguous state and it was
>> invoked by online_pages(). If error occurs after
>> move_pfn_range_to_zone() called like in online_pages(), I think we'd better
>> to restore the original value if previous zone contiguous state is true.
>   
> But after move_pfn_range_to_zone() the added pages are still offline, so I
> think the zone remains contiguous and the call to
> clear_zone_contiguous(zone) should not be there.

Since move_pfn_range_to_zone() may change the zone contiguous state, 
clear_zone_contiguous() should be invoked. If we did not 
clear_zone_contiguous() properly, especially keep the zone contiguous 
state as true but actually the zone is non contiguous after resize the 
zone, the code path rely on the contiguous state potentially may fail?

I am not sure if we need to handle the clear_zone_contiguous() in or out 
of move_pfn_range_to_zone() in this patch series.

> BTW, as we have set_zone_contiguous(ZONE_CONTIG_NO) I think we can use it
> instead if clear_zone_contiguous() and remove the latter.
>   

Yes we can. I am hesitate to do so because clear_zone_contiguous() has a 
name that explain itself. The pair of clear/set seems a pattern should 
be preserved? I am OK to change the code, let's hear from other comments 
if feasible? Thanks.


Regards,

Tianyou


