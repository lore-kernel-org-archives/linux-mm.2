Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF70E7E362
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 10:16:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC006B0005; Fri,  3 Apr 2026 06:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B53D6B0089; Fri,  3 Apr 2026 06:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0106B008A; Fri,  3 Apr 2026 06:16:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8BD76B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 06:16:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 738D9E1582
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:16:12 +0000 (UTC)
X-FDA: 84616839384.13.6C286F3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	by imf15.hostedemail.com (Postfix) with ESMTP id D4D76A0011
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 10:16:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CaOamJtP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775211368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lFa9sRNpTXXpITU5hoUzfldzNs+XJIEZR9R5QkMDFs=;
	b=q2jy0oznXcf/Sjn1S8pvQikx4qN+YZPEWyTMbAZlqRmL0bd+pNTNSB4ALw4XYe40eE+d8F
	H3eh1qr5vXKs2CjWLBzTpwPsgAW/qMf6XsNNYP74Wxw/BQ7VFRleTA1upAWfyqgsDoZStH
	SMeuuUArhJk1lSWhF2JSOgwmfw2bQVk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775211369; a=rsa-sha256;
	cv=fail;
	b=ozurbB7hcGHM6k1NKl4YL4BkPEnWKXm0xGzQHguTU6yQtJn9ZC3E/rpg9d7DEzpBmNVjXH
	fwPYvVQR31kMCui2G9iC9DOyyE4fICFXykgAaP4r10dp4tR2GLIhzbuzrRgaGpkt3uuLaE
	fRK8oWN+0HRR1Oefq2ggZ3/uGsGtZWE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=CaOamJtP;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.16 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1775211368; x=1806747368;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9lFa9sRNpTXXpITU5hoUzfldzNs+XJIEZR9R5QkMDFs=;
  b=CaOamJtPU0O31NIAwMtiVykwj4tFmBSgVwn453CE2lWGPewSd6Hl0yNs
   K7JwqzZwvAVGmcovtLKTKqOEhVd1Ab9vOikAiy2ashahs1FMYZGyEttBw
   AFHYC1pgzPLSzExYlMvvsbS9E52AMeLPpJz6ZKPzwf0lpaBiPIY+5BwFM
   ht7/+uaI3dNXud/nhR30H/Dph+XT4lME67r7cZm68Zo3Mb1toVa7s0ytV
   xXPuHqDRo9bhD5jaLeKNvU6IhIAin/zALk5yvNOhgX41fn15jYbtmCjxd
   qMngGOmZeWce0N4tAOPEUtHijk2Q+SOiDBn20KZ5bQOKyJ6V+oaclpxlJ
   w==;
X-CSE-ConnectionGUID: IroBz4hDRN6BJobXdm5abw==
X-CSE-MsgGUID: /gLFQevcTgehRcOiZJvRDA==
X-IronPort-AV: E=McAfee;i="6800,10657,11747"; a="63823998"
X-IronPort-AV: E=Sophos;i="6.23,157,1770624000"; 
   d="scan'208";a="63823998"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 03:16:06 -0700
X-CSE-ConnectionGUID: L/mzv1CRTi6I6q7kDMWivQ==
X-CSE-MsgGUID: m0v2e77BTH2tEdJ51aUIPQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,157,1770624000"; 
   d="scan'208";a="222372572"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2026 03:16:05 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 03:16:04 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 3 Apr 2026 03:16:04 -0700
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.42) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 3 Apr 2026 03:16:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cbYLbMZgmlZszBio8651cbbbV5whTLDjzZoJvZYcqh/QSPs0on8vUBCpV1zb3vdrB6HRPj2SuKHhN042TH62eAWviOw5fc+NnxOrnKWTqHSoi1HvGuWtcWD53G9dkwwYUsyUIPH0FaTvmb3h1hZpJWP+v+8S5VFjyzQ1TmJXvLT9009MPLhB2QLMRyOBTwW7YKqQ/lq+6tV1RSJzn57+jdgt7EW8vwTlXjb0uLW7S1O00YxjftYJzcqvsY3BFr7gn1ZLZ9gt0HciSKmyIzgvqjDA/8K6XkjHGKqIeky7+aUvYPg1VpWKS7tc9UpjR2jEh/WQmLr49CrDj+81ACyRtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9lFa9sRNpTXXpITU5hoUzfldzNs+XJIEZR9R5QkMDFs=;
 b=HNl1SmciC/HGEwGAdzR8jfVfwGqeI/mc8HWoSDItRfly2C101M3svBXB8V5BI62YjWcFv3GKi8/86FksVxl4JQJRbsJGy+kJXbx8F8AprniFkcX3hQhW0ONrp+Z3QyO/OijXivCqwTe5QEIUghQ/sX5wRiFj08ljFMssg2FyJAB4sHdePP/r/Iq87E/AGKGOEuqjyr9h0WkQZZbfyZiV6MGzTQ6dOwuHpoIaa4wD5Wv4craQWU7eB3VlMbHD4TRyPROWSrwDuYpJw0ckQFeRivHDZzW1RXp8a9khcCvs91QIZTtKwsuQfBN7ZHrFNbwMFWpXkyJuT5qJ3g9Nb6q4kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA3PR11MB9014.namprd11.prod.outlook.com (2603:10b6:208:583::17)
 by LV1PR11MB8791.namprd11.prod.outlook.com (2603:10b6:408:2b2::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.17; Fri, 3 Apr
 2026 10:15:55 +0000
Received: from IA3PR11MB9014.namprd11.prod.outlook.com
 ([fe80::13c0:2f12:94a2:8dc8]) by IA3PR11MB9014.namprd11.prod.outlook.com
 ([fe80::13c0:2f12:94a2:8dc8%5]) with mapi id 15.20.9769.014; Fri, 3 Apr 2026
 10:15:55 +0000
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
Subject: RE: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Topic: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
Thread-Index: AQHcwaVq/SNiFgNFUk2W6EN+QH1DjbXL3rUAgAE/TAA=
Date: Fri, 3 Apr 2026 10:15:55 +0000
Message-ID: <IA3PR11MB9014A4AF49C44A57C5FE44FCA35EA@IA3PR11MB9014.namprd11.prod.outlook.com>
References: <20260401070155.1420929-1-yuan1.liu@intel.com>
 <a761a39b-3907-4d88-831f-f9c979802171@kernel.org>
In-Reply-To: <a761a39b-3907-4d88-831f-f9c979802171@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA3PR11MB9014:EE_|LV1PR11MB8791:EE_
x-ms-office365-filtering-correlation-id: 2d56ed66-082f-45fc-bc2d-08de9169fe2d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021|56012099003|22082099003|18002099003;
x-microsoft-antispam-message-info: t1xFpwbspTEUbxNSg0pdg3JcUQludzq/yatGu7gQa9heaXrE7shCm81YP/O/tmZBimCkH9sEW+9aiv89VrcSNj6Y/uqJSeDTaMuxI70JHJIJ6XgF2nCq25Ot0lBUJVesnL8+Uhp+HhLRdzq9BOY8BMqLyhQX+qikASV23pXjy4Uttu98lUIUjsZMV0AWM6+g5uuYeeNgGYsOLdayXpe6zmLP+NLJzxXpSa5tCGWua4IVfsm4GeBoYeaCTbmxtcpzW7F++ncQOHZuOE+PkHAY6Ne3BQFvjGQRhZzuQSAPa+BZyXrjYOW+SZ2w7xSGQDVoMp1kcR05Ar+Alx7drwa0VhtAZJ04qzra9LBF1VDz2b1JeY3vj7A6VdUyFlT5NXHPM/9BYY5dVDlNR5fb3TBLEoPWmBASS0Ydy4JmqhKlynZvTDCuJ+H5gEtSl64exkj2GEtJq07H5URXCzqPpcC69ohk+iXENkaJinz3OE5l6E3jHhEJ6qJRvN2aEsjn3hz1ZDPhh+ny8obBoWF8uN0MJu9cfvHM94yVmWBdEWWJBDl8qTezNJyaWkDiZy4kkNFOYsZ7qCBR7Qwj0R6TFhsu7Ui5qLJue2Y3b3IEGzF2SBOsKbNUBqVfajTa5+JrzVc3u92VJpMz6TXfJ4qVlHh+itYjLGOfJeFHJxIpfFdaL4tmklzIdMUqpZ4T4gs7Bq0J/+l2D8pGLcbMtHombcCjYy3n9HXZIcZ3XAWuj8/rZA07MqFLgtMtcTF9nCMmaAtYLChXfp/9EUDiK5a1ssHKvYJ3uc8PY9RKtuF4R9Iv0zY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA3PR11MB9014.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SHVwQlAySGNGaGhHTThGdEp1ZDQ0Q0tZS0d1ZDZ3Yml4dG9JaVBRUkZscS9o?=
 =?utf-8?B?MU04anRtcnhCb3E5ckg3YWphb0RkMGh2aGp3bndQK3NqZlNrbjRHcUdGbEZR?=
 =?utf-8?B?ckZ1ZWlRREllZE5wbzl3UVFYWS9TRHBHVktBU1d3bGJNNnZoR2RqS1BqSmxy?=
 =?utf-8?B?YVByQXZqYzdIRG5BWFhOeXloZVZ0bURGbHpwL25GYzg3MHVwb1ZqdkN0YVhk?=
 =?utf-8?B?UjRBTjY0cDZzSSttS3ltVUh0WGRyMlBLYjZaVXkwVGNtWGhreWRmNW5BeDE3?=
 =?utf-8?B?UkZURUxCZlBXRkR6Zm1YUmhyam1aU1FXN2NYZWZmc29Qc0p5TlRoZk9JS3Fa?=
 =?utf-8?B?cHhMM0gzbHp2OGV4VTFQbVBNWllGSnZBQjBqZWZQV3Vzd0lCSUFpTDlGUjZO?=
 =?utf-8?B?TGVsSjRXZ0hkTG9JVzlLUnZLdlpES1hQK0N2M3BvNThobERnczhSejYvTWRM?=
 =?utf-8?B?V29rc09XZ2xxVEplZmN5Tnp5c1JRYnBSc3BmZGVMOUl3MDVZaTQ3a3RuTE16?=
 =?utf-8?B?eU02TU9LcG8vU2U2T0p0UWVqMkJGN2YxU0xOWGpXMWx2RHBONFZRNUNTQWlw?=
 =?utf-8?B?dXdKZU81TlVyNytwS1RWdXlaYnhIUnNOalVHZzJZbzlrd0w1RTNIZWltcjNV?=
 =?utf-8?B?WDBJSzRNUGRUdzF4TVBQNnFRWG5nVjVnaEVZNWd1N3BZVGdVSENsRXJTQVB4?=
 =?utf-8?B?TUkvdkdITXBocnFnM25sUGxRN1VlbjZSSVVkbUpYbjFEV09OUm5vVW5SbFk5?=
 =?utf-8?B?U1V4KzJXWk5kOUt0UlNuNHkxOU9BU3RVRFVlV0JFVW15YmRKNS9RN2QxeHNW?=
 =?utf-8?B?SitkRjVHb0ZxS2QvODFyb2FXM0g0alJUWlFLS2lUVDE5bDZ4VW16L2NEY201?=
 =?utf-8?B?enhNWWlNWVVhWEQydlFaTmdEVTRvbE5uRndtL2tnallQSFdDNWErQ2ZPM1d2?=
 =?utf-8?B?VFNUQVZvaXlnTTlidFVxMVV5R05DNys1TTc0eFVQMTRkQlBMM2xKRVF0b1J6?=
 =?utf-8?B?ak9mWHdiblZFa2RWVEpERFpHUWxGdWRzNitDUEoxcEY1MnIyL1l0L2lNMEdl?=
 =?utf-8?B?VDBsRVZ4Mnoxek1KS2t3cTUzYnlYVUtVbE56TEIyeUkrL05DNS82TVJmeEFu?=
 =?utf-8?B?NXJQL2ZaZE1BYWJXMHlzL3ZxL3pVc0hjSW5kRkFxeGkyejdxd1d2TmYxM2VL?=
 =?utf-8?B?TDlwdENRZnFVRVFKM2ZJeGFsenozbUtva1JXTC9jWVBadUl3YWs5TEoxeVBX?=
 =?utf-8?B?YllPbWs4REQwOWphcmNkS3hvZy9Vc09XblJTWkIxU2lCYk41K091ZUJVV0kw?=
 =?utf-8?B?UmJPUEQ4dkVPSXZlUjJ6NFdBRDJTMGtrcUp5NEpaSjdmZmdWRzM2WnNKNk9O?=
 =?utf-8?B?NjZaZWx4NzR5Q0IwTlpBeUZNMUp4L1ZKcG5Qc0JMNmFUMURMd1hFQjhqenVw?=
 =?utf-8?B?NjZPeHloYVJ0MldTYU9uaFdzTzJHTDl2ZERIMFZ6YlJWMG9NbFlGbkRzZTBx?=
 =?utf-8?B?aDc1Ym96NFJ2UlNmcDErekl3NmJnWjJxaEZoMWFGeDNWV051T3QrTEZyTVVY?=
 =?utf-8?B?emN0V3E4WTgzN0Y5VGFLUzlxODVJNmtQWlgwdzFBbDlEVlpPczg5aTM3VEM0?=
 =?utf-8?B?TjVMaHZaNTVmZFZSYWw0Vkh3c3EvaEp3cVhjRkFVMjN4Tk4vbXNvdVF1UHRz?=
 =?utf-8?B?cUNtVytMVlpnc3NxbUVJUWJrV0JHZXJVRG4ybEVkQ1AxaklNNlg0aDQ5NjQr?=
 =?utf-8?B?cDBrOFZzcGM0T0IvRGpCaERWZ3YvS2Jha05vNVI0Sk5uT2UrVlFEN1FEVUEv?=
 =?utf-8?B?a202NStJZ2I2QkRmNEc5aU5PSjVVQzltTjY5VkZLeVhyUlJIaGVTb3RaZ0dQ?=
 =?utf-8?B?RS9iVitaelRVcUFaUTRFRThTN1dMdXR3blZOeFh0dTlwdThwOWwwaDF4VnNM?=
 =?utf-8?B?eVpZcXZ4NzFlUTVjakVUa2tFYStaRm16VTRzVkwzTVQ2V2lZTFlPeEFnMXpR?=
 =?utf-8?B?aGdTWlhVZ1c2NlY5L1R0T1JoVzNjUVNmTGNEYVpGSTFBdlpEUVNYdGFNblhC?=
 =?utf-8?B?bytRdFZuSVJPUWYyZ0p2aEpTaHRiV2N2bnhmalZTOWlVUjZZV0wvWk1IL0dn?=
 =?utf-8?B?VXZqTXl5OFB2UmFXZG1aNm83bEE2a1o5NlI5UmNlazdFNDN5Q1dNNU92T2VJ?=
 =?utf-8?B?cXNrL0RmeGU2NG4rdS9hTHpWZndmZ1hCOVFOZ1pXNnlUekVCTGZ1VW9MeE5L?=
 =?utf-8?B?c08xRFdGbndUTVZXbWpvdDF5bkJpcTY0UVlzclpFZEtBb2xPL2xpUk5mbVds?=
 =?utf-8?Q?u5UqjhirUpx6dT1XLX?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: hpcK5XfCxLqRv6CRMiyO25jWGrbsynH889OqGHHiOLFVov9i5p+uFUYpHMQSGz3vE82XeHfh7kZxyVuFkBCbVy5xRiIideW5SjQIZuGvSXn8NVECjgXsjQPu1IprgPSqPNJ3n6f8TkrWZcHI4hguxANe9xTcWU9LweneTC1SgfMrQtI/JngHIC2uFtAxI6z/aymMHDBJ2fT6S65hmSI0GdAs/nX8xfvV3tRxkpmY1zm8i7s8ciyDY8mIiEF4ADRTut1FDZ+Vw9WyqJhirvpQh/nQhCOavhnwX/djz4WAM9ydc1jsfD1A5KBN5f5NFIahDsxxryg4ullZJkr2JE0Ulw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA3PR11MB9014.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d56ed66-082f-45fc-bc2d-08de9169fe2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Apr 2026 10:15:55.4831
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5kWo8ha8idfqPR32KpDk5dn6bgJEcMFKL8ORbIKwXZrJvGW4G3Nd09Q1uZ8Y9poeafsT8QCtWfIhLOTn1PYd6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV1PR11MB8791
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: D4D76A0011
X-Stat-Signature: wqioc8sqkht17so6mjx19g5wd71tu65u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775211367-167961
X-HE-Meta: U2FsdGVkX192LTywQ5f7PjIV+yCf/+0Lt0nDuSDCsXLHoJvHjgHYw/ShpLw27KnNquKlT0RogDphvWAaf2qosW0BLeftx1GEkkNCN5ZEmDnM9dg1sY4TwzC0EHIE9K2RNx5XDDL3sDxLhY1OzOBrYBwH78ODQ1WgYt4zfehVXCzGKymox0p3BJWomra22dD2ePMUZFq7J/EYdKJ/GqT8MuZyadtpJmZ5ReCPgGuTBLXdD6J689+9Q9hf03ImFPDIRx+dE1SH3X04ZbBbp9Xe8v2Da1/30SwS49sbzPCiX3TsIKrweokwKEYUg2m2/amNjqAjiytui6Va+Yozpc/rcVnwM9AySDGYIFIZROqLy68J6+wTfqN4BILkFeT5zRK0BIYSAVj4lzgFavb7GszVhb5hytmasAKIlCE8cSxXS3fs/VCdowPApjnl1W6Tc0oWNVoQGKqm55NdkYVw+zzE0c6xFHXqTuTID5lQS+L6gygjytvYrUjlndx7mfzQr4Je0u3jEVR5I/rMz7JbOsxDA+kqyL2Ui30wzDe1YHCmcSUvJK5Rn0vI+ggRjkIs1WotufQssDII30YQteObL2D8xFdR1Yzue1Yd52MJBq0lL/6fsl1kisSASb+FNVVv6P3vEvTAnZkICgbUtC7X6xqMKXRF2wazkQw2+5g6dl0LMmTM9ORSNHrWn5hexspomRnUdV4J9MbIVmDxrNVaNng9VjDwqfDuXqHGdqZB1Su5flYLbv0vykEI9EouajIG6veCJMMh42G75a7GabSWKyQhXB14PiQJxyVgd4pAP/9UZbhJnc0zRDDTF7/lI896q/Gd8m95GhNStXtOIYhh8wEQ1HNFT9RBngynRGI6Kza5thN7wQwM8N7rCthAsoXEOyvYxombxKeqzjPB/5jKUnPPs6ob6jsD+W14cWcLLGZz3BK1NJlCBw0SqeA4Fsh5lxibfqysSNRDBHWlvA5Nh8i
 wbEcOqL8
 jEA0oaRC7CD6KjIBIaZZ6oQ78JAUF3NIRUPrrqXGnNTsO3DHzsUh0rBEfqdjmUPR0ECHZevomF25gBnA5wVspuNvZ1zoEmdxHFp+sBgS3FnVivanbE8JTDAhH38yAdRRfS+aTtadMYlhIEAFGOijMilMyAkD3FcU5gbMveaUVUBtv/WD1+3fvuNRm4b4PWZ9GytiRoj5gxCZNutKuVpGy0pmLOzT6u30E6SN+OQfDbzMIbZF2kwk79FCrcDkeq6YFO5fPpEXMNxOeuhDVcd5h168NThdZJD3Jke4jMYx5Df9xb5zG7YoE/W7P6GO9fBFKp9pB9WbM52Dm+LQ+saS7GleFGFRzDABQiFU44NEwXPoj3r5FS8hj+drq98PR8odByrbgLenEsp6Rs7qD07b8URYh36Jj2cg9Ygy5CbsPI2HURkKLKz561o9mkOyo9NwK3UFVcflpAVNwUZUchQvlLDtVJ24tCyPw7bGIy+j7uP/IRBJUeEqUECdifUtM4ORcAHjLpnpuHkdklIXjoJ/AroRP1atxxpVt5rPEh7WkROG/omT3AxYg4xSL6ajXRZq+tfusVbgxj+jUgMSTIq8Fntw+B/LAlpZ3aBQ8lQAJemCURvTQJaFIRoXWzxC7SNg0YoxXU+/JjoE8n+Y6onZweXAXUOYKSIWnxYhhsP1u8joHQAe7zpM/3rw3BGlQvL6AslYCCecBFR2q2LvCFOv6AFdDXNmYQqaCo/N6QGnVZjM1TaCQsyZa1j0UxupL2hhYtp10JEj13TTHURyneaL0jhgzWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBEYXZpZCBIaWxkZW5icmFuZCAo
QXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDIsIDIwMjYg
MTA6NTcgUE0NCj4gVG86IExpdSwgWXVhbjEgPHl1YW4xLmxpdUBpbnRlbC5jb20+OyBPc2NhciBT
YWx2YWRvciA8b3NhbHZhZG9yQHN1c2UuZGU+Ow0KPiBNaWtlIFJhcG9wb3J0IDxycHB0QGtlcm5l
bC5vcmc+OyBXZWkgWWFuZyA8cmljaGFyZC53ZWl5YW5nQGdtYWlsLmNvbT4NCj4gQ2M6IGxpbnV4
LW1tQGt2YWNrLm9yZzsgSHUsIFlvbmcgPHlvbmcuaHVAaW50ZWwuY29tPjsgWm91LCBOYW5oYWkN
Cj4gPG5hbmhhaS56b3VAaW50ZWwuY29tPjsgVGltIENoZW4gPHRpbS5jLmNoZW5AbGludXguaW50
ZWwuY29tPjsgWmh1bywgUWl1eHUNCj4gPHFpdXh1LnpodW9AaW50ZWwuY29tPjsgQ2hlbiwgWXUg
QyA8eXUuYy5jaGVuQGludGVsLmNvbT47IERlbmcsIFBhbg0KPiA8cGFuLmRlbmdAaW50ZWwuY29t
PjsgTGksIFRpYW55b3UgPHRpYW55b3UubGlAaW50ZWwuY29tPjsgQ2hlbiBaaGFuZw0KPiA8emhh
bmdjaGVuLmtpZGRAamQuY29tPjsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJq
ZWN0OiBSZTogW1BBVENIIHYyXSBtbS9tZW1vcnkgaG90cGx1Zy91bnBsdWc6IE9wdGltaXplIHpv
bmUgY29udGlndW91cw0KPiBjaGVjayB3aGVuIGNoYW5naW5nIHBmbiByYW5nZQ0KPiANCj4gT24g
NC8xLzI2IDA5OjAxLCBZdWFuIExpdSB3cm90ZToNCj4gPiBXaGVuIG1vdmVfcGZuX3JhbmdlX3Rv
X3pvbmUoKSBvciByZW1vdmVfcGZuX3JhbmdlX2Zyb21fem9uZSgpIHVwZGF0ZXMgYQ0KPiA+IHpv
bmUsIHNldF96b25lX2NvbnRpZ3VvdXMoKSByZXNjYW5zIHRoZSBlbnRpcmUgem9uZSBwYWdlYmxv
Y2stYnktDQo+IHBhZ2VibG9jaw0KPiA+IHRvIHJlYnVpbGQgem9uZS0+Y29udGlndW91cy4gRm9y
IGxhcmdlIHpvbmVzIHRoaXMgaXMgYSBzaWduaWZpY2FudCBjb3N0DQo+ID4gZHVyaW5nIG1lbW9y
eSBob3RwbHVnIGFuZCBob3QtdW5wbHVnLg0KPiA+DQo+ID4gQWRkIGEgbmV3IHpvbmUgbWVtYmVy
IHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCB0aGF0IHRyYWNrcyB0aGUgbnVtYmVyIG9mDQo+ID4g
cGFnZXMgd2l0aGluIHRoZSB6b25lIHNwYW4gdGhhdCBoYXZlIGFuIG9ubGluZSBtZW1tYXAgKGlu
Y2x1ZGluZyBwcmVzZW50DQo+ID4gcGFnZXMgYW5kIG1lbW9yeSBob2xlcyB3aG9zZSBtZW1tYXAg
aGFzIGJlZW4gaW5pdGlhbGl6ZWQpLiBXaGVuDQo+ID4gc3Bhbm5lZF9wYWdlcyA9PSBwYWdlc193
aXRoX29ubGluZV9tZW1tYXAgdGhlIHpvbmUgaXMgY29udGlndW91cyBhbmQNCj4gPiBwZm5fdG9f
cGFnZSgpIGNhbiBiZSBjYWxsZWQgb24gYW55IFBGTiBpbiB0aGUgem9uZSBzcGFuIHdpdGhvdXQg
ZnVydGhlcg0KPiA+IHBmbl92YWxpZCgpIGNoZWNrcy4NCj4gPg0KPiA+IE9ubHkgcGFnZXMgdGhh
dCBmYWxsIHdpdGhpbiB0aGUgY3VycmVudCB6b25lIHNwYW4gYXJlIGFjY291bnRlZCB0b3dhcmRz
DQo+ID4gcGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwLiBBICJ0b28gc21hbGwiIHZhbHVlIGlzIHNh
ZmUsIGl0IG1lcmVseQ0KPiBwcmV2ZW50cw0KPiA+IGRldGVjdGluZyBhIGNvbnRpZ3VvdXMgem9u
ZS4NCj4gPg0KPiA+IFRoZSBmb2xsb3dpbmcgdGVzdCBjYXNlcyBvZiBtZW1vcnkgaG90cGx1ZyBm
b3IgYSBWTSBbMV0sIHRlc3RlZCBpbiB0aGUNCj4gPiBlbnZpcm9ubWVudCBbMl0sIHNob3cgdGhh
dCB0aGlzIG9wdGltaXphdGlvbiBjYW4gc2lnbmlmaWNhbnRseSByZWR1Y2UNCj4gdGhlDQo+ID4g
bWVtb3J5IGhvdHBsdWcgdGltZSBbM10uDQo+ID4NCj4gPiArLS0tLS0tLS0tLS0tLS0tLSstLS0t
LS0rLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0NCj4gKw0K
PiA+IHwgICAgICAgICAgICAgICAgfCBTaXplIHwgVGltZSAoYmVmb3JlKSB8IFRpbWUgKGFmdGVy
KSB8IFRpbWUgUmVkdWN0aW9uDQo+IHwNCj4gPiB8ICAgICAgICAgICAgICAgICstLS0tLS0rLS0t
LS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0NCj4gKw0KPiA+IHwg
UGx1ZyBNZW1vcnkgICAgfCAyNTZHIHwgICAgICAxMHMgICAgICB8ICAgICAgM3MgICAgICB8ICAg
ICAgIDcwJQ0KPiB8DQo+ID4gfCAgICAgICAgICAgICAgICArLS0tLS0tKy0tLS0tLS0tLS0tLS0t
LSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tDQo+ICsNCj4gPiB8ICAgICAgICAgICAg
ICAgIHwgNTEyRyB8ICAgICAgMzZzICAgICAgfCAgICAgIDdzICAgICAgfCAgICAgICA4MSUNCj4g
fA0KPiA+ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0tLS0t
LS0tLS0rLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ID4NCj4gPiArLS0tLS0tLS0tLS0tLS0tLSst
LS0tLS0rLS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0NCj4g
Kw0KPiA+IHwgICAgICAgICAgICAgICAgfCBTaXplIHwgVGltZSAoYmVmb3JlKSB8IFRpbWUgKGFm
dGVyKSB8IFRpbWUgUmVkdWN0aW9uDQo+IHwNCj4gPiB8ICAgICAgICAgICAgICAgICstLS0tLS0r
LS0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tKy0tLS0tLS0tLS0tLS0tLS0NCj4gKw0KPiA+
IHwgVW5wbHVnIE1lbW9yeSAgfCAyNTZHIHwgICAgICAxMXMgICAgICB8ICAgICAgNHMgICAgICB8
ICAgICAgIDY0JQ0KPiB8DQo+ID4gfCAgICAgICAgICAgICAgICArLS0tLS0tKy0tLS0tLS0tLS0t
LS0tLSstLS0tLS0tLS0tLS0tLSstLS0tLS0tLS0tLS0tLS0tDQo+ICsNCj4gPiB8ICAgICAgICAg
ICAgICAgIHwgNTEyRyB8ICAgICAgMzZzICAgICAgfCAgICAgIDlzICAgICAgfCAgICAgICA3NSUN
Cj4gfA0KPiA+ICstLS0tLS0tLS0tLS0tLS0tKy0tLS0tLSstLS0tLS0tLS0tLS0tLS0rLS0tLS0t
LS0tLS0tLS0rLS0tLS0tLS0tLS0tLS0tLQ0KPiArDQo+ID4NCj4gPiBbMV0gUWVtdSBjb21tYW5k
cyB0byBob3RwbHVnIDI1NkcvNTEyRyBtZW1vcnkgZm9yIGEgVk06DQo+ID4gICAgIG9iamVjdF9h
ZGQgbWVtb3J5LWJhY2tlbmQtcmFtLGlkPWhvdG1lbTAsc2l6ZT0yNTZHLzUxMkcsc2hhcmU9b24N
Cj4gPiAgICAgZGV2aWNlX2FkZCB2aXJ0aW8tbWVtLXBjaSxpZD12bWVtMSxtZW1kZXY9aG90bWVt
MCxidXM9cG9ydDENCj4gPiAgICAgcW9tLXNldCB2bWVtMSByZXF1ZXN0ZWQtc2l6ZSAyNTZHLzUx
MkcgKFBsdWcgTWVtb3J5KQ0KPiA+ICAgICBxb20tc2V0IHZtZW0xIHJlcXVlc3RlZC1zaXplIDBH
IChVbnBsdWcgTWVtb3J5KQ0KPiA+DQo+ID4gWzJdIEhhcmR3YXJlICAgICA6IEludGVsIEljZWxh
a2Ugc2VydmVyDQo+ID4gICAgIEd1ZXN0IEtlcm5lbCA6IHY3LjAtcmM0DQo+ID4gICAgIFFlbXUg
ICAgICAgICA6IHY5LjAuMA0KPiA+DQo+ID4gICAgIExhdW5jaCBWTSAgICA6DQo+ID4gICAgIHFl
bXUtc3lzdGVtLXg4Nl82NCAtYWNjZWwga3ZtIC1jcHUgaG9zdCBcDQo+ID4gICAgIC1kcml2ZSBm
aWxlPS4vQ2VudG9zMTBfY2xvdWQucWNvdzIsZm9ybWF0PXFjb3cyLGlmPXZpcnRpbyBcDQo+ID4g
ICAgIC1kcml2ZSBmaWxlPS4vc2VlZC5pbWcsZm9ybWF0PXJhdyxpZj12aXJ0aW8gXA0KPiA+ICAg
ICAtc21wIDMsY29yZXM9Myx0aHJlYWRzPTEsc29ja2V0cz0xLG1heGNwdXM9MyBcDQo+ID4gICAg
IC1tIDJHLHNsb3RzPTEwLG1heG1lbT0yMDUyNDcyTSBcDQo+ID4gICAgIC1kZXZpY2UgcGNpZS1y
b290LXBvcnQsaWQ9cG9ydDEsYnVzPXBjaWUuMCxzbG90PTEsbXVsdGlmdW5jdGlvbj1vbiBcDQo+
ID4gICAgIC1kZXZpY2UgcGNpZS1yb290LXBvcnQsaWQ9cG9ydDIsYnVzPXBjaWUuMCxzbG90PTIg
XA0KPiA+ICAgICAtbm9ncmFwaGljIC1tYWNoaW5lIHEzNSBcDQo+ID4gICAgIC1uaWMgdXNlcixo
b3N0ZndkPXRjcDo6MzAwMC06MjINCj4gPg0KPiA+ICAgICBHdWVzdCBrZXJuZWwgYXV0by1vbmxp
bmVzIG5ld2x5IGFkZGVkIG1lbW9yeSBibG9ja3M6DQo+ID4gICAgIGVjaG8gb25saW5lID4gL3N5
cy9kZXZpY2VzL3N5c3RlbS9tZW1vcnkvYXV0b19vbmxpbmVfYmxvY2tzDQo+ID4NCj4gPiBbM10g
VGhlIHRpbWUgZnJvbSB0eXBpbmcgdGhlIFFFTVUgY29tbWFuZHMgaW4gWzFdIHRvIHdoZW4gdGhl
IG91dHB1dCBvZg0KPiA+ICAgICAnZ3JlcCBNZW1Ub3RhbCAvcHJvYy9tZW1pbmZvJyBvbiBHdWVz
dCByZWZsZWN0cyB0aGF0IGFsbCBob3RwbHVnZ2VkDQo+ID4gICAgIG1lbW9yeSBpcyByZWNvZ25p
emVkLg0KPiA+DQo+ID4gUmVwb3J0ZWQtYnk6IE5hbmhhaSBab3UgPG5hbmhhaS56b3VAaW50ZWwu
Y29tPg0KPiA+IFJlcG9ydGVkLWJ5OiBDaGVuIFpoYW5nIDx6aGFuZ2NoZW4ua2lkZEBqZC5jb20+
DQo+ID4gVGVzdGVkLWJ5OiBZdWFuIExpdSA8eXVhbjEubGl1QGludGVsLmNvbT4NCj4gPiBSZXZp
ZXdlZC1ieTogVGltIENoZW4gPHRpbS5jLmNoZW5AbGludXguaW50ZWwuY29tPg0KPiA+IFJldmll
d2VkLWJ5OiBRaXV4dSBaaHVvIDxxaXV4dS56aHVvQGludGVsLmNvbT4NCj4gPiBSZXZpZXdlZC1i
eTogWXUgQyBDaGVuIDx5dS5jLmNoZW5AaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBQYW4g
RGVuZyA8cGFuLmRlbmdAaW50ZWwuY29tPg0KPiA+IFJldmlld2VkLWJ5OiBOYW5oYWkgWm91IDxu
YW5oYWkuem91QGludGVsLmNvbT4NCj4gPiBDby1kZXZlbG9wZWQtYnk6IFRpYW55b3UgTGkgPHRp
YW55b3UubGlAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFRpYW55b3UgTGkgPHRpYW55
b3UubGlAaW50ZWwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFl1YW4gTGl1IDx5dWFuMS5saXVA
aW50ZWwuY29tPg0KPiA+IC0tLQ0KPiA+ICBEb2N1bWVudGF0aW9uL21tL3BoeXNpY2FsX21lbW9y
eS5yc3QgfCAxMSArKysrKw0KPiA+ICBkcml2ZXJzL2Jhc2UvbWVtb3J5LmMgICAgICAgICAgICAg
ICAgfCAgNiArKysNCj4gPiAgaW5jbHVkZS9saW51eC9tbXpvbmUuaCAgICAgICAgICAgICAgIHwg
NDQgKysrKysrKysrKysrKysrKysrKw0KPiA+ICBtbS9pbnRlcm5hbC5oICAgICAgICAgICAgICAg
ICAgICAgICAgfCAgOCArLS0tDQo+ID4gIG1tL21lbW9yeV9ob3RwbHVnLmMgICAgICAgICAgICAg
ICAgICB8IDEyICstLS0tLQ0KPiA+ICBtbS9tbV9pbml0LmMgICAgICAgICAgICAgICAgICAgICAg
ICAgfCA2NCArKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tDQo+ID4gIDYgZmlsZXMgY2hhbmdl
ZCwgMTAyIGluc2VydGlvbnMoKyksIDQzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL0RvY3VtZW50YXRpb24vbW0vcGh5c2ljYWxfbWVtb3J5LnJzdA0KPiBiL0RvY3VtZW50YXRp
b24vbW0vcGh5c2ljYWxfbWVtb3J5LnJzdA0KPiA+IGluZGV4IGI3NjE4MzU0NWU1Yi4uZTQ3ZTk2
ZWY2YTZkIDEwMDY0NA0KPiA+IC0tLSBhL0RvY3VtZW50YXRpb24vbW0vcGh5c2ljYWxfbWVtb3J5
LnJzdA0KPiA+ICsrKyBiL0RvY3VtZW50YXRpb24vbW0vcGh5c2ljYWxfbWVtb3J5LnJzdA0KPiA+
IEBAIC00ODMsNiArNDgzLDE3IEBAIEdlbmVyYWwNCj4gPiAgICBgYHByZXNlbnRfcGFnZXNgYCBz
aG91bGQgdXNlIGBgZ2V0X29ubGluZV9tZW1zKClgYCB0byBnZXQgYSBzdGFibGUNCj4gdmFsdWUu
IEl0DQo+ID4gICAgaXMgaW5pdGlhbGl6ZWQgYnkgYGBjYWxjdWxhdGVfbm9kZV90b3RhbHBhZ2Vz
KClgYC4NCj4gPg0KPiA+ICtgYHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcGBgDQo+ID4gKyAgVHJh
Y2tzIHBhZ2VzIHdpdGhpbiB0aGUgem9uZSB0aGF0IGhhdmUgYW4gb25saW5lIG1lbW1hcCAocHJl
c2VudA0KPiBwYWdlcyBhbmQNCj4gPiArICBtZW1vcnkgaG9sZXMgd2hvc2UgbWVtbWFwIGhhcyBi
ZWVuIGluaXRpYWxpemVkKS4gV2hlbg0KPiBgYHNwYW5uZWRfcGFnZXNgYCA9PQ0KPiA+ICsgIGBg
cGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwYGAsIGBgcGZuX3RvX3BhZ2UoKWBgIGNhbiBiZSBwZXJm
b3JtZWQNCj4gd2l0aG91dA0KPiA+ICsgIGZ1cnRoZXIgY2hlY2tzIG9uIGFueSBQRk4gd2l0aGlu
IHRoZSB6b25lIHNwYW4uDQo+ID4gKw0KPiA+ICsgIE5vdGU6IHRoaXMgY291bnRlciBtYXkgdGVt
cG9yYXJpbHkgdW5kZXJjb3VudCB3aGVuIHBhZ2VzIHdpdGggYW4NCj4gb25saW5lDQo+ID4gKyAg
bWVtbWFwIGV4aXN0IG91dHNpZGUgdGhlIGN1cnJlbnQgem9uZSBzcGFuLiBHcm93aW5nIHRoZSB6
b25lIHRvIGNvdmVyDQo+IHN1Y2gNCj4gDQo+IE1heWJlIGFkZCBoZXJlICJUaGlzIGNhbiBvbmx5
IGhhcHBlbiBkdXJpbmcgYm9vdCwgd2hlbiBpbml0aWFsaXppbmcgdGhlDQo+IG1lbW1hcCBvZiBw
YWdlcyB0aGF0IGRvIG5vdCBmYWxsIGludG8gYW55IHpvbmUgc3Bhbi4iDQoNCkkgd2lsbCBhZGQg
aXQgaW50byB0aGUgbmV4dCB2ZXJzaW9uLg0KDQo+IA0KPiA+ICsJICogd2Ugd2lsbCBub3QgdHJ5
IHRvIHNocmluayB0aGUgem9uZXMuDQo+IA0KPiBzL3pvbmUvaXQvID8NCj4gWy4uLl0NCg0KU3Vy
ZQ0KDQo+ID4gKw0KPiA+ICsvKg0KPiA+ICsgKiBJbml0aWFsaXplIHVuYXZhaWxhYmxlIHJhbmdl
IFtzcGZuLCBlcGZuKSB3aGlsZSBhY2NvdW50aW5nIG9ubHkgdGhlDQo+IHBhZ2VzDQo+ID4gKyAq
IHRoYXQgZmFsbCB3aXRoaW4gdGhlIHpvbmUgc3BhbiB0b3dhcmRzIHBhZ2VzX3dpdGhfb25saW5l
X21lbW1hcC4NCj4gUGFnZXMNCj4gPiArICogb3V0c2lkZSB0aGUgem9uZSBzcGFuIGFyZSBzdGls
bCBpbml0aWFsaXplZCBidXQgbm90IGFjY291bnRlZC4NCj4gPiArICovDQo+ID4gK3N0YXRpYyB2
b2lkIF9faW5pdCBpbml0X3VuYXZhaWxhYmxlX3JhbmdlX2Zvcl96b25lKHN0cnVjdCB6b25lICp6
b25lLA0KPiA+ICsJCQkJCQkgICB1bnNpZ25lZCBsb25nIHNwZm4sDQo+ID4gKwkJCQkJCSAgIHVu
c2lnbmVkIGxvbmcgZXBmbikNCj4gDQo+IEJlc3QgdG8gdXNlIGRvdWJsZSB0YWIgdG8gZml0IHRo
aXMgaW50byBhIHNpbmdsZSBsaW5lDQo+IA0KPiAJCXVuc2lnbmVkIGxvbmcgc3BmbiwgdW5zaWdu
ZWQgbG9uZyBlcGZuKQ0KPiANCj4gCQleIHR3byB0YWJzDQoNClRoYW5rcywgSSB3aWxsIHJlZmlu
ZSB0aGUgY29kaW5nIHN0eWxlIGhlcmUuDQogDQo+ID4gK3sNCj4gPiArCWludCBuaWQgPSB6b25l
X3RvX25pZCh6b25lKTsNCj4gPiArCWludCB6aWQgPSB6b25lX2lkeCh6b25lKTsNCj4gDQo+IEJv
dGggY2FuIGJlIGNvbnN0Lg0KDQpZZXMsIEkgd2lsbCBmaXggdGhpcyBuZXh0IHZlcnNpb24uDQog
DQo+ID4gKwl1bnNpZ25lZCBsb25nIGluX3pvbmVfc3RhcnQ7DQo+ID4gKwl1bnNpZ25lZCBsb25n
IGluX3pvbmVfZW5kOw0KPiA+ICsNCj4gPiArCWluX3pvbmVfc3RhcnQgPSBjbGFtcChzcGZuLCB6
b25lLT56b25lX3N0YXJ0X3BmbiwNCj4gem9uZV9lbmRfcGZuKHpvbmUpKTsNCj4gPiArCWluX3pv
bmVfZW5kID0gY2xhbXAoZXBmbiwgem9uZS0+em9uZV9zdGFydF9wZm4sIHpvbmVfZW5kX3Bmbih6
b25lKSk7DQo+ID4gKw0KPiA+ICsJaWYgKHNwZm4gPCBpbl96b25lX3N0YXJ0KQ0KPiA+ICsJCWlu
aXRfdW5hdmFpbGFibGVfcmFuZ2Uoc3BmbiwgaW5fem9uZV9zdGFydCwgemlkLCBuaWQpOw0KPiA+
ICsNCj4gPiArCWlmIChpbl96b25lX3N0YXJ0IDwgaW5fem9uZV9lbmQpDQo+ID4gKwkJem9uZS0+
cGFnZXNfd2l0aF9vbmxpbmVfbWVtbWFwICs9DQo+ID4gKwkJCWluaXRfdW5hdmFpbGFibGVfcmFu
Z2UoaW5fem9uZV9zdGFydCwgaW5fem9uZV9lbmQsDQo+ID4gKwkJCQkJICAgICAgIHppZCwgbmlk
KTsNCj4gDQo+IEJlc3QgdG8gdXNlIGEgdGVtcG9yYXJ5IHZhcmlhYmxlIHRvIG1ha2UgdGhpcyBl
YXNpZXIgdG8gcmVhZC4NCj4gDQo+IAkJcGdjbnQgPSBpbml0X3VuYXZhaWxhYmxlX3JhbmdlKGlu
X3pvbmVfc3RhcnQsIC4uLg0KPiANCj4gWW91IGNhbiBhbHNvIGV4Y2VlZCA4MGMgYSBiaXQgaWYg
aXQgYWlkcyByZWFkYWJpbGl0eS4NCg0KSW5kZWVkLCB0aGF0IGlzIGEgYmV0dGVyIHdheS4NCg0K
PiA+ICsNCj4gPiArCWlmIChpbl96b25lX2VuZCA8IGVwZm4pDQo+ID4gKwkJaW5pdF91bmF2YWls
YWJsZV9yYW5nZShpbl96b25lX2VuZCwgZXBmbiwgemlkLCBuaWQpOw0KPiA+ICB9DQo+IA0KPiAN
Cj4gT25seSBuaXRzLCBob3Bpbmcgd2UgZG9uJ3QgbWlzcyBhbnl0aGluZyBvYnZpb3VzIChvciBh
bnkgY29ybmVyIGNhc2UgOikgKS4NCj4gDQo+IElmIE1pa2UgdGVsbHMgdXMgdGhhdCB3ZSBhcmUg
cHJvY2Vzc2luZyBhbGwgcGFnZXMgZHVyaW5nIGJvb3QNCj4gYXBwcm9wcmlhdGVseSwgdGhpcyBz
aG91bGQgd29yay4NCg0KT2theSwgSSB3aWxsIHVwZGF0ZSB0aGUgbmV4dCB2ZXJzaW9uIGFmdGVy
IE1pa2XigJlzIHJldmlldywgYW5kIEkgcmVhbGx5IGFwcHJlY2lhdGUgeW91ciBjb21tZW50cy4N
Cg0KPiBUaGFua3MhDQo+IA0KPiBBY2tlZC1ieTogRGF2aWQgSGlsZGVuYnJhbmQgKEFybSkgPGRh
dmlkQGtlcm5lbC5vcmc+DQo+IA0KPiAtLQ0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

