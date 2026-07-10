Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 924C8C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D796B0088; Thu,  9 Jul 2026 23:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E58C6B008A; Thu,  9 Jul 2026 23:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D39A6B008C; Thu,  9 Jul 2026 23:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2766A6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:20:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96D6F4036D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:20:00 +0000 (UTC)
X-FDA: 84971412960.05.0C1CD76
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf31.hostedemail.com (Postfix) with ESMTP id 269A920002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:19:55 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VMoZ7Jzu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783653597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/qP49Fn+nfmoQ0St4BbKTnu9Or+QnDFaArZNbMEmfg=;
	b=nDDWqu+UDqNQEKczntBPJBNOl1pFuN8VhyZyHuQI+ykcZD6ue7gXymhJeCsj2wUczwQvQu
	euF7kLEy4jFTWCOdE8PRRYu/3ip0kXDMqit8ELa8DOUrrgOH6Curv+L7s2fArWu35hPHuw
	BKZiGCH6AMUyPNYM2n42o5S9qsRay+o=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=VMoZ7Jzu;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf31.hostedemail.com: domain of yuan1.liu@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=yuan1.liu@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783653597;
	b=q5Pt4PKA5a0M66uGopTPi6HjleRbcny3r6XD2uDg20LABLZ2ac2D0DTjU6FdtQ4dXwGtbo
	Gt9cxilXtt5sii0LppRz13RZ1mMUWY+buwMAd7rFTa5w07PI4BdVYEbPdEjLzlp8QTWkve
	iEnbSRDxYXzGpIXoXtjKvXvu/etXjbA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783653596; x=1815189596;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1/qP49Fn+nfmoQ0St4BbKTnu9Or+QnDFaArZNbMEmfg=;
  b=VMoZ7JzuT/6wKmneOHdshNTXRmQVBS/dxJj18wA6Uwb2mxS/MJup99rx
   5CTVdhd4vWzV56wPEdBDkmF0oIAw+oo5Wv/hRV4l8005egS4p3htu0hxU
   +O06Zaui2d1Iv2z+IvCC4dd4PbaT400qJp3EXoohQXe+gCmMJ/YL3pV9c
   Y1aMqRNRpOl0skGh8507UDtcOo5MRpgvg9s+oa5C58cWV4qL3MmEfg3+8
   0sQgF0etsSHPbETZMoXuGI4m+Z4Bc/VuGNp9QKyaGqAF8XgMHwEsWTiWq
   sOn5XTgmWw3ccHZBaD+r5RkFuXxx/llOFDfrgJyIOQf48pToE3KEef+OR
   g==;
X-CSE-ConnectionGUID: 6Dpi5z6TTumIUVrviEbH2w==
X-CSE-MsgGUID: JiIglLKmQNGdgEcbRjEbKA==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="109895901"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="109895901"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 20:19:55 -0700
X-CSE-ConnectionGUID: jaVWNOyAQPG9AVBx9A/BLA==
X-CSE-MsgGUID: hmgiGmivQW2byoZ6kUXjqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="259674613"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 20:19:54 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 20:19:53 -0700
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Thu, 9 Jul 2026 20:19:53 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.24) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 9 Jul 2026 20:19:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AnUbXavKHVa69tEumtDwyZhx/AjPE9iNl8q/8/YEfvDgBkJf39L2t9Pp1Ch96SaXu4J/CtqZNzn1cFQDGmAvp8/h10RnmTLdekwI/JOxiDETUD409o7X+oBbnQAX1Gzq1LywlIIepSEyEhIs9pQYAPS0XYPApj563yu6kQQynauOG73IQVfx/Nbrdn3jVCvLe7wazbPc/FT09nT5MtnugKkfDmfGV/3orgQBCl7rj+FkHBKnFkILjPHLf15Wzsr2x5z87CYIl1ep6kCCkVOJK9GmoktI6fKr/jGOtKtQqqDf1r9WT+QA0OYghEHUtxdzbhOd5MPnHr31Z7YfavONoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1/qP49Fn+nfmoQ0St4BbKTnu9Or+QnDFaArZNbMEmfg=;
 b=kWULvlSsG+1TS4nztmfCEId3RKnv0KvPBCVhven63VXNNbA+fDEvuo2VkxjDaGU+YaWoJYpZQLAqSZf1JL53W/1ldEQT4u+l+1O0H/vQr0/4VfsL5OsSqYlGLxh6QxbSG1gBiFRc53jW56lE9PXcPzifHJIFR6TxI9o9B5EbbBlcZjSZ1WV2rroMn8wyJqMBqYuTcUOvAnQPej9gFGss43YlfheC/8viAMF6DPLrdwrylVm9gs1c0a6petmaT9y/ROgldT1C2RT8J++qBbimYP/k9qNgU0lvehSPwOifl1/iIr9MbafNR/PuPzspbdVkNK3G+WkwGs989bhsBX4cEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB6936.namprd11.prod.outlook.com (2603:10b6:303:226::16)
 by BL3PR11MB6409.namprd11.prod.outlook.com (2603:10b6:208:3b8::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Fri, 10 Jul
 2026 03:19:49 +0000
Received: from MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04]) by MW4PR11MB6936.namprd11.prod.outlook.com
 ([fe80::96dc:12ef:f56f:dd04%3]) with mapi id 15.21.0159.018; Fri, 10 Jul 2026
 03:19:49 +0000
From: "Liu, Yuan1" <yuan1.liu@intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Oscar Salvador
	<osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, Wei Yang
	<richard.weiyang@gmail.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
	"Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
	"Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>, "Chen
 Zhang" <zhangchen.kidd@jd.com>, "Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Topic: [PATCH v5 1/5] mm: move mirrored memory overlap checking to the
 outer loop
Thread-Index: AQHc6DwJDfX3zlWKz0C/zOkb6gw/RLZPZSYAgAFR+hCACcNZgIAL53Eg
Date: Fri, 10 Jul 2026 03:19:49 +0000
Message-ID: <MW4PR11MB6936DF78B0004839601C91B4A3FD2@MW4PR11MB6936.namprd11.prod.outlook.com>
References: <20260520093457.3719960-1-yuan1.liu@intel.com>
 <20260520093457.3719960-2-yuan1.liu@intel.com>
 <fc62528f-99a8-4759-9880-d56077a0f6ec@kernel.org>
 <MW4PR11MB69365DA722268E4CF7C8D0CAA3EB2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <1b6b2074-4575-4c54-a950-fda4b9154169@kernel.org>
In-Reply-To: <1b6b2074-4575-4c54-a950-fda4b9154169@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB6936:EE_|BL3PR11MB6409:EE_
x-ms-office365-filtering-correlation-id: d5055027-f441-4997-5463-08dede3219b2
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|23010399003|376014|366016|11063799006|56012099006|4143699003|6133799003|18002099003|22082099003|38070700021;
x-microsoft-antispam-message-info: rmQtePnyMDbn0ZF4JwIp2zha6rXOyNyP3Rh13q0BSdZKoTr+CsTbWUZ2n6+tiWFuap5w1BqBfiMuCgAM6MJiPOs+f51Ua+GCbWQIHNawKuyZSXOdsJ0rhihDMBFBKp1KLHpglwHGxuwWxP4pNxI/15x0fQaAuYBzAmIvxKMnmpRP6Oet7Mx8hzZNlcpS7S88HewtVics6TtweBrzjByQw0AlUOfFCQhIkiSKwGgMezzm+h10bXj72pnYL/4Ly2DRqTftg8qulFKwyj4k1BKoRi4A6Imay/hW+42o2P5eyaQczrqneH66qK4lBtT8W6IpIx5UDW5i4E1nw3DLcigXyoHRCustJ0/c0SDC96uEsOedaaD/UQws6IRXgS+JuEUO29oecqsnag6rK7NtBLZQqUd5cIpt/L6a6q177rWE/sgrtGOUsj96veIeQovPJ99ope7hl3xUVI5NHO1RFOObWPzkBiVGopivS89PE14CjuXZxc2BbJm8M19lvuBvmE/Keh1fsgtq43+EwFAAJER/5BeucYLPcx411lrYAALIt1FDEffgPSdQXwO8g8/KUHpLHfv0aSSK/Ny6yBrwZ9K8+tcMz/VY1KfT0Ix89kL/ZFO9l2qM6IPZBxn/5+TJ16K9nYE3/vV4XFgBoXGBwaBymZ98irBHJHTA5j6bHIt411kJMimT9nXNKXHMvP22cQgyrAmSJYSp1neaVIrF6xlRYgbDkdDbLav1QQr7oZMZY+c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB6936.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(23010399003)(376014)(366016)(11063799006)(56012099006)(4143699003)(6133799003)(18002099003)(22082099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUN1V004V1RCZWlrVG54cjlSZlJGSCtvWnRNWWVIWTd5bkRKNjJsajlFUDc1?=
 =?utf-8?B?V082Q0NsRjJUNnJwdGxOU1gybGc1TW15UlQ3WWNudTRuU1ZVT04xNGJPNUpv?=
 =?utf-8?B?Y3NFWTZjMngzUUxJQ3ZuYTRac2xpVHM1L3JqaXBtZFk5T29KbC80TlVwK2Ex?=
 =?utf-8?B?MVJVRXVRLzZEY0dKc1gwK0JwdUxUbkFjc3ZCREt1RWo1amE1Mm9QVndxSHAz?=
 =?utf-8?B?R2pWd0dhcFR4dUczUWZPMkVwUlQxWXphK2ZWcUNaaWpHeHJ2RHJFODVRSTg3?=
 =?utf-8?B?anBRRmh6R2t1eFJIWEFya01uOWZhT085S2hmM1lESHBmNjBBa1hUQy9CNUtz?=
 =?utf-8?B?em5YcGFvZVpsSUhoK1B6Qm45NjM4U1BjbGwyUTc2WE1YdmErSitCdDVhUnQw?=
 =?utf-8?B?eEhjUjhqOU9DdWRGeXdQRjZ6ZVJaUG9rMmlpMU5sRElVblJ6NVJ0SUN6cmVI?=
 =?utf-8?B?Z2M3NGtkcVh6Y0JsTDRpYjFiMUxVV1FHZ05Xbk1BZ244ZE9xNkJ6T1RFNVJQ?=
 =?utf-8?B?T0p3S0tWYlZ4Uk5rc1U0MWpRVFVRL3o5dUk2TmpmRlYxSU5BZHpzREJFcmpR?=
 =?utf-8?B?YmpNV29maW0zN2VkMjBkRFVtSlV5bU1iTHAyaTRoRkNyR3JaNCtwSjlpa2ps?=
 =?utf-8?B?cDFOM1gyeUFGcTVzMEF2VExxUTdGR2xscFVUeGVDcllHMEowOXk0NXNEOXJB?=
 =?utf-8?B?eUtTTStjRUpvVm1BaThnZ2ZtQ3pDV3kxVi9ZQU5peHZUTjBkejFKVTN1SDVx?=
 =?utf-8?B?MWR4K291cDVUMXFtSEJZY1V6M0g4bTR2WUttbVovT1BGZnlxKzFjOGkyVWVv?=
 =?utf-8?B?OGNHRGxuRzZDQXg0Y3Z3SHRZOHVHanBIdUNtcEc3bldYenFXbzlMYnM3cFhU?=
 =?utf-8?B?M1p1aXdWMjRXckdVZDg4dkZmUE1UZS9wek5MSUtzVkVvRFBkazk5YlF5cmtO?=
 =?utf-8?B?Y1JWNU5Rekl2SFcxL0pnUzZkL2hIamppdGw3bnNjYW5JTngwQmhyVnJjMitt?=
 =?utf-8?B?UTNQeE9oZndwTlVqUzA0ejRzWXJzbE5EZmxjVXFiKzhvNllxYVJkekdTL2Qv?=
 =?utf-8?B?aHNjd1BUdWNFSTAxUkNrbEoyVGxqcUVXOXdKRWU5OVpHalJtdnIvQnRkRHBy?=
 =?utf-8?B?UzlQcGwvN1pSanhsQXhSSXNTOW8zVWZXaEJZd0ZTYjdSaGdjdVQ0eUgwb2pW?=
 =?utf-8?B?UUJCRGZyVUljT3l5d2pIRlVMU1Zta1NIcmZEZ0REcDhYL0tUTWVIV1lXaVEz?=
 =?utf-8?B?cHg5RUJSbHlGcWJBOHBRNFdLT0tRZGYxcDNSUi9NU3ZpSFBqSFlFVXNtUEto?=
 =?utf-8?B?WGhmK3hTcmE0YWRpSzFjRitXRzRFaHdQVm54K29TWTQrUGE3c3VRczFGRER5?=
 =?utf-8?B?TXMyTkFZSTVzL04rakJiZWpGQTlIMEh2T0hIUGFwSzZRaUZsa29ZRTlSNm9w?=
 =?utf-8?B?WE9zNGdwbmpIa3pPMkpYanI2MVQvUzNTK0ZFWitFVmhDd0ZqMkllb3B4M0tF?=
 =?utf-8?B?Q2pJcWhBRWFLZ0tHNDdDL3llcGx6c2lrUmI1cEN5OUhwWjhzN3pHRjJJbFZp?=
 =?utf-8?B?SmJ0dGQ1RW10Ukw1bi9oQ3ZoM3NJaFplZURMbzJ4OWx6QTA4RXNuUEVnNFly?=
 =?utf-8?B?Y2k0Q0VJT2loR1pRQmwxblAvcm0vRGlkajE2ZnJCMEtvTDhMQS9oeFZ3a0hw?=
 =?utf-8?B?blZEUHRabkdIM01Dak42enYybVhadEV1Q3hMWEh1dzNUa2UyVkxaVmlodHl6?=
 =?utf-8?B?VVJZSjRXR1BRbkFSV3ZSd1F2VUVCSjY3UzNJUTlMQzY0TmJmL2VJamFmWHRR?=
 =?utf-8?B?VlJKMmxwYjYzOUVQRFErTkdRK29NdHdoNW1iemV6YzVvTzZPTVZOaHRONTAz?=
 =?utf-8?B?ODRXdlZQSDNTSmhhdHhRNktIMTZaMk52SER4OGNNZUxiM3dKdE9ITFhuWWxu?=
 =?utf-8?B?eEtLc0VKK2ZuaHNyWnVSYy9teHNlbjFDbGJSYWExMU15MEpNLy9rV3VnMkhN?=
 =?utf-8?B?RkZHemZCbU8xNGNUZnYzbndQZUZJV1QzeUNoTTdjTUpxRnIvNGU2eDBlMXNI?=
 =?utf-8?B?d0xXeTRTUVBkWDF6RG5OQ0dDRE11QUZ5c0UxekxvaWwzTStBblNGM0xPekhG?=
 =?utf-8?B?M0dKdmwvT1JsUmNIUkpGbE9VTjE4SjVSM01wYnRQUkpOWUxZa0w1YnExL3Ri?=
 =?utf-8?B?RVZaVmhwa3IyUnpiZWlOY2ZtNmVaU0VEZkNrM2g5eFJFQ2U3VktNbkZwaGY4?=
 =?utf-8?B?eWFqSmgzZUVPV29qZEZiOWo2TEhJNWF1NjJPbk5vOUxiR2lXZjV1S3RtcGdv?=
 =?utf-8?Q?qXWorklIvw2/mrPf5U?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: PVjpoiuEIdpptnYXIkkdITYzD7D3aGd3F5WenZFdnc93B5613DoQV8BqNBZI0DHCYKxaZ7yMFA8M6AvuyO6Rz79p3c/Okp2H6eeMg9UR0UbxHSPMI1XmwglTkwaJPMaiOHMqkD2rFyzcKzSGNNcsb8BvBSLlWCZETfE5cuAp3vsoEiTDbltEQfhUrFmIvYeUzhRfbIRE3FmuoCTGoD1URJj5vwcXfnvFhcRphHLFsCNLqPvLHoKAbk+QqZShAflQPVWqnuddHJt8pVpb3acxG+ncOxN6BVmL9qvWL+xSMl/X+wm7FGRMuXwTCHjm71f+ISW/WcMsOtcOblOclAD/cw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB6936.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5055027-f441-4997-5463-08dede3219b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jul 2026 03:19:49.3941
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hLpPLpiSOCHgbcH1KqUfpessy4kK2Qalu+ZXeX7cy4r9a4c6ibO4tysE8Mmf97CUhybzGFnUw3LiIK9BEKVMTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR11MB6409
X-OriginatorOrg: intel.com
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 269A920002
X-Stat-Signature: cokibiscgmdn1cda9ukqogz9bmbe94jx
X-HE-Tag: 1783653595-467070
X-HE-Meta: U2FsdGVkX18V50+B5pWrSTFM7ipgbzDCULwXCnK5+53NZsvXKaAxQWL/3eRkPLWsPDHmHPjZcNTUiP7iaz/yEC7zWj270sFhmQj2QYSBMz6Pzie2NIA4qfZzUtRy3ZL6UPTjhvoDKGtTOeG9758hyOfm0j/yvUO6e4CF3Gfd/h4wxEShsKmN1eJjgK6N6R2b+bpT+uOdutfkNYeH4NvH6Dpw6SXhixlVxWBmPv/uNI4BwWzkRI5oMiLtgMZR0tTfuO5wVoHPzYfE0i6Q21fasFuAt16SWk2WCaFY1xnyPjBgF5xhnHT3w2cK/oUAZkAAIEyuSKix7ZjQSRldu9qAKkI+gES5SUxO9tiRoXz6X0mtIzFs+dl4q3OXi8uE0HD7mCTMc6p+NtTssTXJnBZgSmP92E2Ih1mY65L9sqQfxUgdsi5ttJPda17vxfAi9N/9VkfBBjtWORvoiQXQ7MOHAp4cvvU/KM6CDWOC8u3YAY2wJXvC/8g19X6Xy1yHadyxwxvBZdfk/qZzAdGJ5f5f5FU6Tv28383Q3D7nopChM6+78Q2P9hB+q9d/vh71HMwAYh36smjR0ALfwyV0vM/QDrXyCjAobJRIIHIdZyxBG+i9Zlx+tp4SFjzholhqMyaywEf3S0DNB9s56mKUQ8E9rPiUAlZ46R/Oq1dYWParYaCecTCTqt0lezhs+F1I6gaGkp3hs+156LaZQirhjyXu4d38KN7I4Q91MyPqJXjtmgUZdTsdXWnq14chuqntT3eAvuhi77YoRWJa8FKv403lOxud4RKbrjQ6WhsDiFYhdhC5pmm2I2ACXmla2QqEArRzU+jNuv9exiLErGR972mXwYrfl8ikSX49gmVCvyOVs99zzbFozFrr973Qvv45zun49FK+tIdNZu2HaP5xPmBW0KPusdn/ODiYLLM1obqndbouU+zlqyIEXrIxIW8mkg0aL8BwTmd1GoEmyzHJbXd
 nUGBysT9
 cMMIPURIpP/5BGpWrRbd9SQ9vtDPGH+zJZo+H0oDV5JvrxEhzZVkchJVHRUNEDK5YQKeyI1IZ7JAQgGQZJCWhrCMgGSa1n7KcpLNAARo81NXfaJjUXaYPWeYWnTvFtIhKiQCwRuxb88mWk4RYhYlC7SRD0h4JYdhGAIw5EBRZsd3KVWGokpwbYw59/nEjUTtKF8R2cfa0oqgD2CfOO+GpkwDlIc4ZVJ2zjvKTQUPnn0qEOZiuSyqEOiSQpExxkVv95qOkJpW3H288KVME3PxBG4obeBlIi8k8GsHSP++rBFTgbjwIpEYav42cmYut3l0ml+m0FvnAG+lg6b6MsWed4/jewfC7LIsFywIvUsvp8RdwEn3zFAFiXw0H4H4zRnTArDn/zsLKuRrPedp90PWH02nS5+2gTnuW6K96/FpdVykSTAFlZu+FvV7V9YcGDo00IUxaT2FSBmjCv01VGw0LNZh74v3EMvkwL50+P22klIYs6ovExEJOEgMUsNwdx6GkYpctgVEw6lBYp7FvdhVn8j+lhOhD6+rHkcEOOShr2EBMVCXBfzTd5yf0oOQanQ09qhobZIp8+PccvfOCGmxIQg7fEVrJ9FtBZ+IIjR3p4uEx4zxgUY8XQ9JV3Qs3B3tfZp/QF9OdtjdL6b7zcK9nwMR4g7XDH+Gafl86gDMo+iBOcpH2XsCbNIgErBaHCZra7MfhgiTfJND2oK/E6d89UPiaXR8xm6NmUT3JKvMTiNLCjQVnkc4oKWPmhboOaLyzrQ/Vo81ZXchLGPKJBgaZAbQTMaNJqiJG+V11YOZxBJ/m7J0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBEYXZpZCBIaWxkZW5i
cmFuZCAoQXJtKSA8ZGF2aWRAa2VybmVsLm9yZz4NCj4gPj4gU2VudDogVGh1cnNkYXksIEp1bmUg
MjUsIDIwMjYgODowNSBQTQ0KPiA+PiBUbzogTGl1LCBZdWFuMSA8eXVhbjEubGl1QGludGVsLmNv
bT47IE9zY2FyIFNhbHZhZG9yDQo+IDxvc2FsdmFkb3JAc3VzZS5kZT47DQo+ID4+IE1pa2UgUmFw
b3BvcnQgPHJwcHRAa2VybmVsLm9yZz47IFdlaSBZYW5nIDxyaWNoYXJkLndlaXlhbmdAZ21haWwu
Y29tPg0KPiA+PiBDYzogbGludXgtbW1Aa3ZhY2sub3JnOyBIdSwgWW9uZyA8eW9uZy5odUBpbnRl
bC5jb20+OyBab3UsIE5hbmhhaQ0KPiA+PiA8bmFuaGFpLnpvdUBpbnRlbC5jb20+OyBUaW0gQ2hl
biA8dGltLmMuY2hlbkBsaW51eC5pbnRlbC5jb20+OyBaaHVvLA0KPiBRaXV4dQ0KPiA+PiA8cWl1
eHUuemh1b0BpbnRlbC5jb20+OyBDaGVuLCBZdSBDIDx5dS5jLmNoZW5AaW50ZWwuY29tPjsgRGVu
ZywgUGFuDQo+ID4+IDxwYW4uZGVuZ0BpbnRlbC5jb20+OyBMaSwgVGlhbnlvdSA8dGlhbnlvdS5s
aUBpbnRlbC5jb20+OyBDaGVuIFpoYW5nDQo+ID4+IDx6aGFuZ2NoZW4ua2lkZEBqZC5jb20+OyBa
ZW5nLCBKYXNvbiA8amFzb24uemVuZ0BpbnRlbC5jb20+OyBsaW51eC0NCj4gPj4ga2VybmVsQHZn
ZXIua2VybmVsLm9yZw0KPiA+PiBTdWJqZWN0OiBSZTogW1BBVENIIHY1IDEvNV0gbW06IG1vdmUg
bWlycm9yZWQgbWVtb3J5IG92ZXJsYXAgY2hlY2tpbmcNCj4gdG8NCj4gPj4gdGhlIG91dGVyIGxv
b3ANCj4gPj4NCj4gPj4gT24gNS8yMC8yNiAxMTozNCwgWXVhbiBMaXUgd3JvdGU6DQo+ID4+PiBN
b3ZlIHRoZSBvdmVybGFwIG1lbW1hcCBpbml0aWFsaXphdGlvbiBjaGVjayBmcm9tIG1lbW1hcF9p
bml0X3JhbmdlKCkNCj4gPj4+IHRvIG1lbW1hcF9pbml0KCksIGFuZCByZXBsYWNlIHRoZSBwZXIt
UEZOIGNoZWNrIHdpdGggYSBtZW1ibG9jay1iYXNlZA0KPiA+Pj4gY2hlY2suDQo+ID4+Pg0KPiA+
Pj4gUmV2aWV3ZWQtYnk6IFdlaSBZYW5nIDxyaWNoYXJkLndlaXlhbmdAZ21haWwuY29tPg0KPiA+
Pj4gUmV2aWV3ZWQtYnk6IEphc29uIFplbmcgPGphc29uLnplbmdAaW50ZWwuY29tPg0KPiA+Pj4g
U2lnbmVkLW9mZi1ieTogWXVhbiBMaXUgPHl1YW4xLmxpdUBpbnRlbC5jb20+DQo+ID4+PiAtLS0N
Cj4gPj4NCj4gPj4gSUlSQywgd2l0aCB0aGUgcGF0Y2ggZnJvbSBNaWtlK1dlaSB0aGlzIHBhdGNo
IGhlcmUgc2hvdWxkIG5vIGxvbmdlciBiZQ0KPiA+PiByZXF1aXJlZCwNCj4gPj4gcmlnaHQ/DQo+
ID4+DQo+ID4+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNjA2MjUwNzM5NDEuMTQ1MDE0
LTEtcnBwdEBrZXJuZWwub3JnDQo+ID4NCj4gPiBIaSBEYXZpZA0KPiA+DQo+ID4gWWVzLCB3ZSBk
b24ndCBuZWVkIHRoZSBvdmVybGFwLXJlbGF0ZWQgcGF0Y2ggYW55bW9yZS4gVGhlIHpvbmUNCj4g
Y29udGlndWl0eSBvcHRpbWl6YXRpb24gd2lsbCBidWlsZCBvbiB0b3Agb2YgTWlrZSdzIGFuZCBX
ZWkncyBjaGFuZ2VzLCBhbmQNCj4gSSdsbCB1cGRhdGUgdGhlIHBhdGNoZXMgYWNjb3JkaW5nbHku
DQo+ID4NCj4gPiBUaGVzZSBkYXlzIEkndmUgYmVlbiByZXZpc2l0aW5nIHRoZSBpc3N1ZSB3aGVy
ZSBwYWdlc193aXRoX29ubGluZV9tZW1tYXANCj4gb3ZlcmNvdW50cyBzdWJzZWN0aW9uIGhvbGUg
cGFnZXMgaW4gZWFybHkgc2VjdGlvbnMuDQo+ID4NCj4gPiBXZSBwcmV2aW91c2x5IGF0dGVtcHRl
ZCB0byBhZGRyZXNzIHRoaXMgd2l0aCBhIHBhdGNoIFsxXSwgYnV0IEkgdGhpbmsNCj4gdGhlIGNv
bmNlcm4gcmFpc2VkIGJ5IFNhc2hpa28gWzJdIGlzIHZhbGlkLCBzbyB3ZSBtYXkgbm90IGJlIGFi
bGUgdG8gdXNlDQo+IHBhdGNoIFsxXS4NCj4gPg0KPiA+IEkgY2FuIHRoaW5rIG9mIHRoZSBmb2xs
b3dpbmcgYWx0ZXJuYXRpdmUgYXBwcm9hY2gsIHdoaWNoIGNhbiBhdm9pZA0KPiBjaGFuZ2luZyBz
ZW1hbnRpY3Mgb2YgcGZuX3ZhbGlkKCkgb3IgZmlyc3RfdmFsaWRfcGZuKCk6DQo+ID4NCj4gPiBC
YXNpY2FsbHkgd2UgY2FsY3VsYXRlIHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcCBieSBpdGVyYXRp
bmcgb3Zlcg0KPiBzdWJzZWN0aW9ucyBpbiBlYWNoIHpvbmUgZHVyaW5nIG1lbW1hcF9pbml0KCks
IHRvIHNlZQ0KPiBwZm5fdG9fb25saW5lX3BhZ2Uoc3RhcnRfcGZuKSBpcyB0cnVlIG9yIG5vdC4N
Cj4gPiBJZiBpdCBpcyB0cnVlLCB0aGVuIHRoZSB3aG9sZSBzdWJzZWN0aW9uIHdpbGwgYmUgY291
bnRlZCBpbnRvDQo+IHBhZ2VzX3dpdGhfb25saW5lX21lbW1hcC4NCj4gDQo+IFdlIHJlYWxseSBz
aG91bGQgc3RyaXZlIGZvciBhIHNvbHV0aW9uIHRoYXQgZG9lc24ndCB3YWxrIGFueSBQRk4gcmFu
Z2VzIHRvDQo+IHBlcmZvcm0gYSBwZm5fdG9fb25saW5lX3BhZ2UoKS4NCg0KSGkgRGF2aWQNCg0K
WWVzLCBJIGFncmVlIHdpdGggeW91ciBwb2ludC4gU28gSSBhbSB0aGlua2luZyBhIHNsaWdodGx5
IGNoYW5nZWQgYXBwcm9hY2guDQoNClNpbmNlIGV2ZXJ5IFBGTiB3aXRoaW4gYSBtZW1ibG9jayBz
YXRpc2ZpZXMgcGZuX3RvX29ubGluZV9wYWdlKCksIHdlIGp1c3QgbmVlZCB0byBhbGlnbiBib3Ro
IGJvdW5kYXJ5IHNpZGVzIG9mIGEgbWVtYmxvY2sgdG8gc3Vic2VjdGlvbiBzaXplLCBhbmQgY291
bnQgcGFnZXMgaW4gdGhlc2UgbWVtYmxvY2sgc3Vic2VjdGlvbnMuDQoNCkEgYml0IGRldGFpbGVk
IGRlc2NyaXB0aW9uIG9mIHRoZSBuZXcgYXBwcm9hY2g6DQoxLiBBbGlnbiB0aGUgbWVtYmxvY2sg
Ym91bmRhcmllcyB0byBQQUdFU19QRVJfU1VCU0VDVElPTiB3aGVuIGNhbGN1bGF0aW5nIGhvdyBt
YW55IG9ubGluZSBwYWdlcyBhcmUgYWN0dWFsbHkgY292ZXJlZCBieSBlYWNoIG1lbWJsb2NrLg0K
Mi4gSWYgdGhlIGJvdW5kYXJpZXMgb2YgdHdvIGFkamFjZW50IG1lbWJsb2NrcyBmYWxsIHdpdGhp
biB0aGUgc2FtZSBzdWJzZWN0aW9uLCBleGNsdWRlIHRoZSBvdmVybGFwcGluZyBwYWdlcyB0byBh
dm9pZCBkb3VibGUgY291bnRpbmcuDQozLiBLZWVwIHRoZSBQRk4gcmFuZ2UgcGFzc2VkIHRvIGlu
aXRfdW5hdmFpbGFibGVfcmFuZ2UoKSB1bmNoYW5nZWQsIHNvIHRoYXQgYWxsIHZhbGlkIFBGTnMg
Y29udGludWUgdG8gYmUgaW5pdGlhbGl6ZWQuDQoNCkknZCBsaWtlIHRvIGhlYXIgeW91ciB0aG91
Z2h0cyBvbiB0aGlzIGFwcHJvYWNoIGZpcnN0LiBJZiB5b3UgYWdyZWUsIEknbGwgcHJlcGFyZSB0
aGUgbmV4dCByZXZpc2lvbiBhY2NvcmRpbmdseSBiYXNlZCBvbiBbMV0gY2hhbmdlcw0KDQpbMV0g
Im1tL21tX2luaXQ6IGRvbid0IG92ZXJsYXAgem9uZXMgd2l0aCBrZXJuZWxjb3JlPW1pcnJvciIN
Cmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0L3JwcHQvbWVt
YmxvY2suZ2l0L2NvbW1pdC8/aD1rZXJuZWxjb3JlLW1pcnJvciZpZD1iNjljMmExZmE5YmViNGMz
ZGIyNGI0MDEzZTA3ZjVjYjdlNzI2MGFhDQoNClRoZSByZWxldmFudCBjb2RlIGlzIGFzIGZvbGxv
d3M6DQorc3RhdGljIHZvaWQgX19pbml0IHVwZGF0ZV96b25lX29ubGluZV9tZW1tYXBfcGFnZXMo
c3RydWN0IHpvbmUgKnpvbmUsDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQg
bG9uZyBzdGFydF9wZm4sDQorICAgICAgICAgICAgICAgICAgICAgICAgICAgdW5zaWduZWQgbG9u
ZyBlbmRfcGZuLA0KKyAgICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgKmhv
bGVfcGZuKQ0KK3sNCisjaWZkZWYgQ09ORklHX1NQQVJTRU1FTV9WTUVNTUFQDQorICAgIHVuc2ln
bmVkIGxvbmcgem9uZV9zdGFydF9wZm4gPSB6b25lLT56b25lX3N0YXJ0X3BmbjsNCisgICAgdW5z
aWduZWQgbG9uZyB6b25lX2VuZF9wZm4gPSB6b25lX3N0YXJ0X3BmbiArIHpvbmUtPnNwYW5uZWRf
cGFnZXM7DQorICAgIHVuc2lnbmVkIGxvbmcgc3ViX3N0YXJ0LCBzdWJfZW5kOw0KKw0KKyAgICBz
dWJfc3RhcnQgPSBtYXgoQUxJR05fRE9XTihzdGFydF9wZm4sIFBBR0VTX1BFUl9TVUJTRUNUSU9O
KSwgem9uZV9zdGFydF9wZm4pOw0KKyAgICBzdWJfZW5kID0gbWluKEFMSUdOKGVuZF9wZm4sIFBB
R0VTX1BFUl9TVUJTRUNUSU9OKSwgem9uZV9lbmRfcGZuKTsNCisNCisgICAgLyoNCisgICAgICog
Rm9yIGFuIGluLXpvbmUgaG9sZSBzbWFsbGVyIHRoYW4gYSBzdWJzZWN0aW9uLCB0aGUgYWRqYWNl
bnQNCisgICAgICogbWVtYmxvY2sgcmFuZ2VzIHNoYXJlIGEgc3Vic2VjdGlvbi4gQXZvaWQgY291
bnRpbmcgdGhlIHNhbWUNCisgICAgICogc3Vic2VjdGlvbidzIHBhZ2VzIHR3aWNlLg0KKyAgICAg
Ki8NCisgICAgaWYgKCpob2xlX3BmbiA+IHpvbmVfc3RhcnRfcGZuKSB7DQorICAgICAgICB1bnNp
Z25lZCBsb25nIHByZXZfc3ViX2VuZCA9IG1pbihBTElHTigqaG9sZV9wZm4sIFBBR0VTX1BFUl9T
VUJTRUNUSU9OKSwNCisgICAgICAgICAgICAgICAgICAgICAgICAgem9uZV9lbmRfcGZuKTsNCisg
ICAgICAgIHN1Yl9zdGFydCA9IG1heChzdWJfc3RhcnQsIHByZXZfc3ViX2VuZCk7DQorICAgIH0N
CisNCisgICAgaWYgKHN1Yl9zdGFydCA8IHN1Yl9lbmQpDQorICAgICAgICB6b25lLT5wYWdlc193
aXRoX29ubGluZV9tZW1tYXAgKz0gc3ViX2VuZCAtIHN1Yl9zdGFydDsNCisjZWxzZQ0KKyAgICB6
b25lLT5wYWdlc193aXRoX29ubGluZV9tZW1tYXAgKz0gZW5kX3BmbiAtIHN0YXJ0X3BmbjsNCisj
ZW5kaWYNCit9DQorDQogc3RhdGljIHZvaWQgX19pbml0IG1lbW1hcF9pbml0X3pvbmVfcmFuZ2Uo
c3RydWN0IHpvbmUgKnpvbmUsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB1bnNpZ25lZCBsb25nIHN0YXJ0X3BmbiwNCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgZW5kX3BmbiwNCkBAIC05MzIsNiArOTYzLDgg
QEAgc3RhdGljIHZvaWQgX19pbml0IG1lbW1hcF9pbml0X3pvbmVfcmFuZ2Uoc3RydWN0IHpvbmUg
KnpvbmUsDQogICAgICAgIGlmIChzdGFydF9wZm4gPj0gZW5kX3BmbikNCiAgICAgICAgICAgICAg
ICByZXR1cm47DQoNCisgICAgICAgdXBkYXRlX3pvbmVfb25saW5lX21lbW1hcF9wYWdlcyh6b25l
LCBzdGFydF9wZm4sIGVuZF9wZm4sIGhvbGVfcGZuKTsNCisNCiAgICAgICAgbWVtbWFwX2luaXRf
cmFuZ2UoZW5kX3BmbiAtIHN0YXJ0X3BmbiwgbmlkLCB6b25lX2lkLCBzdGFydF9wZm4sDQogICAg
ICAgICAgICAgICAgICAgICAgICAgIHpvbmVfZW5kX3BmbiwgTUVNSU5JVF9FQVJMWSwgTlVMTCwg
bXQsIGZhbHNlKTsNCg0KPiAtLQ0KPiBDaGVlcnMsDQo+IA0KPiBEYXZpZA0K

