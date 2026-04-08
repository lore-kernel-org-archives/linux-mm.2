Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE4B11073CA8
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 12:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 591C76B008A; Wed,  8 Apr 2026 08:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5433B6B008C; Wed,  8 Apr 2026 08:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3DA6B0095; Wed,  8 Apr 2026 08:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A4446B008A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 08:38:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C73BEBA102
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:38:08 +0000 (UTC)
X-FDA: 84635341056.28.4844EDD
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf20.hostedemail.com (Postfix) with ESMTP id B044D1C000E
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 12:38:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MHgR9FHX;
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775651885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKMh2sYnSRhzWg6Zr/PH9e8aLjx7fNWxJNKmUvcoVGU=;
	b=NzUyWuhqIQmBVZqvrU+emAY9oLD8hOq/cokCaxgLVWxj1NVfoGRlSIy4K8jScDRDDkEXxx
	V40W0P96dz3YvYWLyCfBke43RE9POHNTg8eT/Js4K33G4JCifRNmHfW1ArjYzqgKjsK0kA
	ECbBCZ5Hd/HeAChhGUaQEO3H5uxx7xY=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=MHgR9FHX;
	spf=pass (imf20.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775651885; a=rsa-sha256;
	cv=fail;
	b=8NDCXA5vEEtEBWufko8NHgBDO9NYYGWgToVeoSZtlATm6RJBIZwS8yuC97b58HHfnAYKTj
	jPopg3cqgAYQ5bED7oi/SvzoWRr0spz+V3XYJ8DkMYOmogJsFWIlwHOdcsvEV2wjxFBLmD
	/PR9vfleKuKlMGGkHYvehdARP2UdK40=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775651885; x=1807187885;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mKMh2sYnSRhzWg6Zr/PH9e8aLjx7fNWxJNKmUvcoVGU=;
  b=MHgR9FHXmIEy7lbUhg8tRf3alpVPMrehKEmo/DCLtnwL43a950U0rivC
   YzFhXnIHLWv2cb0Cq0FLai5NduAwYVrMsbXG50i5EZsZTj7pHbdLtlLec
   ZVZkLqnsI3KXR+a+Lpl+j5mYx5y0MyIRDUgf042hhJ1ksuL9GfnOXHXCC
   l+sM/hLNcliU/mVxtv6yhw2DErPu80nbSDFX/jmVLOInZZRbeUlRBKhFT
   D/fKjBakWbVSUlrFn3lZ28SwcBZR7xK2M/TmJX9oxHcwbepngLmwTZVlY
   kSZfwyk60ciadMVPKZ4GCfn1sR2dTOheyHZ6cgeCwZGCsYwHOAPbzV/VW
   Q==;
X-CSE-ConnectionGUID: SUQZMiMXQ+ONOvC7XE7udQ==
X-CSE-MsgGUID: 2o7+K4zzSJuAPeU2GSFQog==
X-IronPort-AV: E=McAfee;i="6800,10657,11752"; a="88017635"
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="88017635"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 05:37:58 -0700
X-CSE-ConnectionGUID: z5w49ypzTjKnUE/bcs6iBA==
X-CSE-MsgGUID: LXnoNoxPTYO0CtkAirXkYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,167,1770624000"; 
   d="scan'208";a="224160963"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2026 05:37:58 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 05:37:57 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 8 Apr 2026 05:37:57 -0700
Received: from DM5PR21CU001.outbound.protection.outlook.com (52.101.62.60) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 8 Apr 2026 05:37:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KzMAH2zI3OP7Fah/4Uub4epXTxBCMMrKhtF2cqDvTS8BVaYt41CjF245kSzP4OJUBBEnOfZT3OjjwqwHL9djdpOuU28Iheebae/MvthbB995HvFquHJftZ4PVN1NNzqY+cEUGml9G2cZ8KQGkOrZaKahsgd3ILX8jv4UfcbW5ZzgqeVtZNoHQSTC9iEPCNxIHz9E6Ka+It50Zujir7W2xqGuDpYuTlQCTWV8DS4yYXAdY0oZjdlGnd5iTEBIxnvfjfd+4bjpNlK2TRjJxp/ev5JZIsjaLm3GIrdUMihYXNaxloZZK3d1lSHtKOf7rjVCmFz4GSsL5N00uO+OcrSdIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKMh2sYnSRhzWg6Zr/PH9e8aLjx7fNWxJNKmUvcoVGU=;
 b=k0zlIh32C0cpwy3gj+E0d42QfYrzRLmogEDW4c/ysF28viGkqReDHZQlqxhllsXn5SJ19X9R5mE4ctB+zM5Mm6cPoMsV14aOHVCscfr5c2iGTcapZHrCM+ozK8xTGfaLKvShM2yzEoHEiiqFQzItBkGRalgR4pYj+jSU8uqHLoCGfDQM2PmHy4Sv/7e1QidGPP2hPfS9X8LXDhO0j/0j5cPRTya4s9L8sCLPcfJRKvrxnKY3qfmsWG5vnfjqpEjRBejZvUQKp6qRfvv5AE9vVsYfm9GsW3uQCtPn98stt7fvCcI6xdns/GO530gyZL9SvmchMYyV+qDpaG/TrRci/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA4PR11MB9009.namprd11.prod.outlook.com (2603:10b6:208:56f::21)
 by CHXPR11MB9651.namprd11.prod.outlook.com (2603:10b6:610:2fb::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.41; Wed, 8 Apr
 2026 12:37:55 +0000
Received: from IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541]) by IA4PR11MB9009.namprd11.prod.outlook.com
 ([fe80::eaae:cab2:868e:4541%4]) with mapi id 15.20.9745.035; Wed, 8 Apr 2026
 12:37:55 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcxwYPPar5wabLkEWQfiO/Xde9s7XUxrUAgABPwPCAAAKfgIAAAFcQ
Date: Wed, 8 Apr 2026 12:37:55 +0000
Message-ID: <IA4PR11MB90090E43BD442AE17EFD3705A35BA@IA4PR11MB9009.namprd11.prod.outlook.com>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <IA4PR11MB90099CF424CDD1E88A30504EA35BA@IA4PR11MB9009.namprd11.prod.outlook.com>
 <6e770522-0138-49dd-8f7f-3833b1a2a120@kernel.org>
In-Reply-To: <6e770522-0138-49dd-8f7f-3833b1a2a120@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA4PR11MB9009:EE_|CHXPR11MB9651:EE_
x-ms-office365-filtering-correlation-id: c4e6b850-dbf8-41ab-b4d7-08de956ba876
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|18002099003|22082099003|56012099003|38070700021;
x-microsoft-antispam-message-info: PxOqbq6EWA0ij/2fEfpbWsyiqH+yMDuho5tVqqDBmfJWf5jWg6YkstsNxb/wDSI9mwkXxA3qbrK2WIDGHEfMXLOYtgGzIXo3oDz6UzvKE2OCCe5vea9uT0UMvQ2eJpR0VqdV4syKV6LFH6+CMzyO1uiBHNCSeAc6oT6Gsza8emm+UxJAEr13nNmVMjWtN4tfi2opsrVZdYM0mdX2dFO4DkShK7ooNgZr0mgJKkFaZCc7efsjLhlViGV8ACcvixXMZ6T0eEKm7ovJq5NwCOhcLcf2itmpHxe5scmI0GYIA82RlS+W/sS8PrER2nkvB3TgydAOoXTGhWG6ZF2VWzkGh9qhUX1b3BBi1Jtkh8oUSxEQGjV5hzOkVAvG58eVxaeLKPnLEpWe/Npuzr8xbVBNPKagJUYuvPxIQsWOq/O4Gm/GcFLO1i3ofIx2M/zMm5UHXKtmY310pIVCPk3OSxT0k6p/7tZcsC8Y9nZn8gJ7NV3nFQZ+WvC8z0ykJUuEqdqvh4US/flH+e5LKfMpVhjUlj5OeGc/CC5kUEzprX3uBDmS4EtTgvmH/H6QbvM32vAA7j4H01O7EBCyMMuxAmtgYXRQPRHi5ftsBeaqnJa5t13C4FWPQR1yqITBWAe11QFQb8bdj2DgRVShhqyFav4Xj24l62APN1Jj13N1RWUaIoI0yl+gFTJuUSGcb23O5ohZpYCBCU6DMjHuFwpXdHLgc/Mr/pTc+KWFny9lpKu8iMY2QSWmCmE7khue/GiB+wqw+YHD7BfzjPGu6nZS5FjQZoDKRVQdW7CaAVo5lt9k/EE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA4PR11MB9009.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(18002099003)(22082099003)(56012099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZVV5SzlQVUhVUHlqbWIvWHFZRnU1UUFTK0tqSTNybDdOZ3RXaGpVM3VWSTd2?=
 =?utf-8?B?dFhPdVAyZG5ZN3ZHSFk0aVMvU3RWbExIK0JIVjF6WG5IN0lnOFR3NXB2SEZj?=
 =?utf-8?B?aklyZXhWVnE5WUlOd3dTOTNzaXZwbkE1cmdLQm4raGtxZ2pBNmVrWkxwS2c4?=
 =?utf-8?B?UGphOHJjRnhwZGJKY0ZUelRtZ0lwb1pXamNqbnlTL2J5cjNtaVlMUzVLRVBI?=
 =?utf-8?B?T1ZyWU15K3JHU29NL3RYcUg5UDZrMmJsMm1QZFVkYTdkZGszZFpQNTRiS2cx?=
 =?utf-8?B?UHRXY3hEeTh2UWgrQnpHVUQ1UWFLcGJma3h0bjUzRndJc241b3hocmRUaEpO?=
 =?utf-8?B?S0s0US8wOFk4QU5yRTI1YmovMHZsZFpHTGxKYWR6Zk1XdkZSSFMrM0plZXpn?=
 =?utf-8?B?Ri9ld1c2c0pFVXdNK0VySE5NSmdlZW1rUHpuWkllSk1hdWp1VFZzRy9DNjA2?=
 =?utf-8?B?MnoyOW9YTjJKeGQ5aGI0MGoxNG5YOVRHMFVYSUs5SENjOXEwOW8rWXFxaVBO?=
 =?utf-8?B?MmROdHpVNFoyTWJWT0F1cGFnblM3TEhFemxXOXNCUG9hMytUeFk4NHBSQTlp?=
 =?utf-8?B?U21hTVdnMk5MWmljRTh5VXZXUzNyY3pLVjFLZCtLMmxURTBMZkVUYmF2ZnZi?=
 =?utf-8?B?dGFiSjV4eCtqSUp3Z3lRaytYOFBFWk10eXltWVdGRURIS1hCUnExM2FrbEZl?=
 =?utf-8?B?UVhRRkRob0g2dGJEQmkweWx2djBKVllBT0dWU0FqbFUzYks3RWgxMEtqOTFZ?=
 =?utf-8?B?TVZsalB4Vkg2ZWZYZzlrSmFCS1ZwS2o2UmxycWdQQm8yL3lrMnFqcElhRUl1?=
 =?utf-8?B?dGNqNVVOZi9vVW9qR0dCWmc5ZFQ3MUM3T0RjSU5RM1N4RzFsQ0x0TkYvQ0ZT?=
 =?utf-8?B?VXFYRUJOQ2I2ZkppN3o5NHB0dHE0amJ6YmFTbEhQZXE5Y29wWDhjT2tuUmlu?=
 =?utf-8?B?U0pZaWJ2WWsxRjNiTmpOaUhnMjNEZTlabm12R2I3NmdkSXJyOG5lSHNOQnlS?=
 =?utf-8?B?TkMwbHdvQWJVbzZ5RGVtNUh6UTZ0OHUvNysvYmwxdXZESVhxTzZmdm80Rk9i?=
 =?utf-8?B?U2VnbXo2d2Iyc1lud2hkKzU5RkpUNjRjS0JGczdtMEY0TnZVUVhjaFB0blZ5?=
 =?utf-8?B?T1NNZVlTL0MxUmlOVVpoOU1Id3pPNUk2Ym9FT2l3WWxleUhaQzVILzNveFRV?=
 =?utf-8?B?eHU5a2E2eWpxUUU0dDZxcEpzajZIbUF0VVBjbzkyYnBWNjMyQzVLSnFURWpn?=
 =?utf-8?B?TURjUmhhN3pQWkxGdkpnVU9BK29hVEduYlBkZzd4SHZiVFhicSsxYmdBQmxX?=
 =?utf-8?B?dkVaYjBqTkhkQ0QvT3EvSG9nS2xQblBnOUF6dUM0d25CVXVyRjQzb2k0dGtY?=
 =?utf-8?B?blNwaW1tYkFpWXdubGlLbTlhQm1McVNjMnRzejFNR2VxY1J1dCtpOVFHOTZx?=
 =?utf-8?B?S3FmajIxRk9SNVVOdTFVSDIrRURzRnRrRHZMYVB6Mk0xWXR4Y0hoTmlmU3FX?=
 =?utf-8?B?dzljS2QwTkRJMkJxbVEvcTJNTnY1ZDJEallQcG5QUkFCeXA2Uit2T2RTSks2?=
 =?utf-8?B?cUt3SXMzUzA5Z0txVmJDRmJGZ2VuWGQvUFNiR0FjUmF6czB2SWF4VHpBT3pr?=
 =?utf-8?B?T1FIWnlvSFJ1RFlhRGE5OU81Y2JZbUpqQ2tURmtsaEUvVTNJUTQxaTU5NUpN?=
 =?utf-8?B?V0pMUmFvQUV2cjNrb3R4NmFPN1hLTFNKNXFqc0d1cldKWkFBbmo2ZXcyM2xv?=
 =?utf-8?B?cy9EMjdwc3ZTczE2MWNLd1gvejM1TVJrUmRWbGU4eHBoZWd5ZnJ5NnlIcUg5?=
 =?utf-8?B?VVVtU3FWdXVlcVRiSVlId2R3QUY3eDBzN2lJQnV5VHJUNGZ4Yi94MFN6Wlc4?=
 =?utf-8?B?RVBReDd6anJlSjFWd2NGVTErazF6bE9GK0FucGRrd0s4NUVFS0xEVk45ejVr?=
 =?utf-8?B?bExoYkpGb3ljb0srRFhrUE80dVc3ZnlUalA5b2YzN2h4SE5GcFUvRnpkTDIr?=
 =?utf-8?B?ZVRCRzlSeDlOZ2NHZUVoMGVyNG11ZnJveENjMDNUUnM4VTRTYkU2eWRvNkZ3?=
 =?utf-8?B?ZkNVdU5LMW9YcC9EOC9Gd1E5ei9FZGdJYWRMak51cUVFUkloczdlT1FYV0dY?=
 =?utf-8?B?cWc0QUdMRWpVU2RDK2ExbEUwUW00UGpsd2JTbGFsOU9tdnJJSFkvVTNDUDRX?=
 =?utf-8?B?b2NuWnA5cXB1eHZrOVJwaDViWnRkemlGclR2ckdIbTBaNzlUaVBlN3FtZWcy?=
 =?utf-8?B?K2l1bzBWYTFSVzJSYjluVGM2NFpMaWpGYk1Ld1pwQWJvU2JjSFVCdG4vWFUy?=
 =?utf-8?Q?VGPW+Kzc4PvsGY7J2x?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: sGtfXAVPoAQDrZYB83/yvIQM4oSfPHr778MAXRKpo/hATPaNe3sZKqxXNA9obbsQ9vu2Gq1mUtUiMKjG9Iil7gJeCmjPufX1hff9YfMojuaYmBRERJkHvnMsSzLxqFd4ZYXQN0BentMuHdjeY0lxpE3FxoyKdeOItgG7sw3EFk1j5q0zO4mJOvi6eI+X2QDq25ssbQYjylmdry0d/2PCBg46f2pstUk0G61FWuh3U5Dq/yhW9ZrGWQdICOJECQUK9ivG728YrON3hrnbY8LjsSoo+RkOr+I3apY/IJ48qCPsRgB8JTjROAi1kWRpfx073e3uJ/0UsGjeN7ynJmVjnw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA4PR11MB9009.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c4e6b850-dbf8-41ab-b4d7-08de956ba876
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2026 12:37:55.3333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8kqfnMw80vWrVR6nDI/NxOOX+skm4kQIPaoEkXnxx2Vmt3L9TreoEEZHdRlPhPkBSnb25DFFkojtmue1xYnE4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHXPR11MB9651
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Queue-Id: B044D1C000E
X-Stat-Signature: p6idu4c7bc1uzazoicqnhn6qorbrmcax
X-Rspamd-Server: rspam06
X-HE-Tag: 1775651884-177344
X-HE-Meta: U2FsdGVkX1++6h52r63R/0+WY4IoCHCNs0CJ9lsAR8Gcf/203om9jngN0yRYuiMBo8cLbA46pgu0/GJw31tUzvqbCmFUXjUMg3UL2ahN0W3TlPqNnynL2msvqMWQLeLV47eODLmFICt8OXooFlZqGVJHngbe42Yp+PTSiuzFSIJAOjAqN+5o8hxFlxpOAGr+04BkSFGCuxRuHMRVhudPN8KIvny8nwh0vw2ZDD9bX3wy2OGfV1hbzvI2aiDsPTMbT7q3wSUM0esPgFUxA1Di/NrCVyd9ks09uRzdDaF0VKSsmeG1l22yR0Cx+WVnjw4Xctp/Wo24MeCYW7F8Gwxo+Qxk7GPyfTE2PKT31xrM9u23J2GKc1ywiKKKupd0Y+5IUUNvDgK6LaN1dwbl+tqRRM+CrBwY4uCQgpKP1dgJ1dwX9phPiAREa4CU7LaodKx4XKq1+8D8VS1ciye25panqw6La/6Wye4KWEYE0rxaNVqcxY+UkYYmrRaf4IS+7D9yAu74LJGsoon6n7yxQfDOrUjpedYNFZBQWhaT2+I+X1kLwpd3/qdVRTPrcMhfSIyIsOnkJxdDWzSs+iy/CsxlPwWdk1nkGtUCRfS9lk7FrUjCA9e6DEDq9N35zvEyRcmoQDI2u8oRz9a3I3JcpMv122J3PJBGPdiCjNrCeNapTQiJRzZh/ApCNmOunn7BBGPmg2L1vASzz3TZDh6fClFvlalEog670A+XPjlY2TUHc4H+D7RDQdjDZlAqsceogCjsa8E0JVQEnvXKAH1LPNc9M4NNEZ6/TpPC7RVTwazxv+El2UWIm/GVwaWPVyadk9wyPn+rre1AJmDMsHnw5rSlYAwCgAzgr0Nmzz4d70GAFICYXnjK8biigFprfDEu2J7JSklq07qQXMhgolJxsishVnrBiEGGNVHFmtUzsZrWC7Jy8HirYt92O31nqC3PT/+Ql8LgW3lMnIakGpNefO0
 29a7bK0S
 8P7fDcWJt24rAUmO5fznNxDOBC9mTurESUcLsp0LONUp88qt0Alk1iz/NcGWnXyEfxyk+/COgV+rK685DmHBnAdQocKvYKnaZHhNh+2GHaikGT00KgTPbuxE3lQGj0xUpk62uYcEy+39CQ/5Q8CjqaarkrIF4AJMMH4xfI5vb1yVWak9kL2BvUbfH3iVElusz3LM+yOBnmQZ91qWXirEKy/60MtNZfQAp6OWcjpF1JQ6FiC0KxK0/wpGcxRqIX0+B2oxc583TC6BSfQOjjY5dHDJF34UEf9YvMJ7nPy/U8yU8hi1j8fwILsnr0tbDnXGVkpX8F/puKADyuFa2MDdceZ6kn9oqX4kSsrEdRUfVMzDhwtMvghucOMUew6KIUefnPSkmFjuHQ/LWW5BiCc15cY+niRUUqPrJx0yQy4w108EqJ4rPtaUrO1Do+aCnavltInfUMLOvqwuDH+b0WHa/IfLSDEjg5x33eZ4hUUDawLDcNQteVM1CgZm3lx9E1AqnCECKANvSGpzoDEAHtFw5MlMF0h7cE6GZq9meWkjOWcODqA3YJ69SuBahZ8hdVzyOaOCyauIvrzIke/VRMZAVwzgpi1hz0qBDceDkGBRJeH51AM36vS1PpDWMBzSFiPx3hbnH7SEljAYFfdEvTjA/0Jb7yrGtC4Xkv1D+YuR5C1SInZ3TaUhNOLKIqmHYDjMTw8CqmdW8PC9l+u8zAqOLYHYsKKap+Kf+1AceQaHH2gUKr/kBQyUGAjItYz1eqRU8HC+fs6TNiMy+Si6OB4X7Lsu4gL+nhO06zEh13KIQcnLEktQgo6VavtyQ6PTR3GTRgSTg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCA4LCAyMDI2
IDg6MzEgUE0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBT
YWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgSHUsIFlvbmcgPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5oYWkN
Cj4gPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgVGltIENoZW4gPHRpbS5jLmNoZW5AbGludXguaW50
ZWwuY29tPjsgWmh1bywgUWl1eHUNCj4gPHFpdXh1LnpodW9AaW50ZWwuY29tPjsgQ2hlbiwgWXUg
QyA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcsIFBhbg0KPiA8cGFuLmRlbmdAaW50ZWwuY29t
PjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA8emhh
bmdjaGVuLmtpZGRAamQuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYzXSBtbS9tZW1vcnkgaG90cGx1Zy91bnBsdWc6IE9wdGltaXplIHpv
bmUgY29udGlndW91cw0KPiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiANCj4gDQo+
ID4+DQo+ID4+IE1heWJlIHNvbWV0aGluZyBsaWtlIHRoZSBmb2xsb3dpbmcgY291bGQgbWFrZSBp
dCBuaWNlciB0byByZWFkLCBqdXN0IGENCj4gPj4gdGhvdWdodC4NCj4gPj4NCj4gPj4gdW5zaWdu
ZWQgbG9uZyBob2xlX3N0YXJ0X3BmbiA9ICpob2xlX3BmbjsNCj4gPj4NCj4gPj4gaWYgKGhvbGVf
c3RhcnRfcGZuIDwgem9uZV9zdGFydF9wZm4pIHsNCj4gPj4gCWluaXRfdW5hdmFpbGFibGVfcmFu
Z2UoaG9sZV9zdGFydF9wZm4sIHpvbmVfc3RhcnRfcGZuLA0KPiA+PiAJCQkgICAgICAgem9uZV9p
ZCwgbmlkKTsNCj4gPj4gCWhvbGVfc3RhcnRfcGZuID0gem9uZV9zdGFydF9wZm47DQo+ID4+IH0N
Cj4gPj4gcGdjbnQgPSBpbml0X3VuYXZhaWxhYmxlX3JhbmdlKGhvbGVfc3RhcnRfcGZuLCBzdGFy
dF9wZm4sDQo+ID4+IAkJCSAgICAgICB6b25lX2lkLCBuaWQpOw0KPiA+DQo+ID4gWWVzLCB0aGlz
IGxvb2tzIGJldHRlci4gSSdsbCBhcHBseSB5b3VyIHN1Z2dlc3Rpb24NCj4gDQo+IEJlc3QgdG8g
d2FpdCBmb3IgTWlrZSdzIGNvbW1lbnRzIGZpcnN0ISA6KQ0KDQpTdXJlLCBJJ2xsIHdhaXQgZm9y
IE1pa2UncyBjb21tZW50cyBiZWZvcmUgc2VuZGluZyB0aGUgbmV4dCB2ZXJzaW9uLg0KDQo+IC0t
DQo+IENoZWVycywNCj4gDQo+IERhdmlkDQo=

