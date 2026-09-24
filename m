Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3849EC9830D
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 03:44:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E9D6B008A; Wed, 23 Sep 2026 23:44:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910886B008C; Wed, 23 Sep 2026 23:44:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B12D6B0092; Wed, 23 Sep 2026 23:44:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43B286B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 23:44:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C950BA52CE
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:44:01 +0000 (UTC)
X-FDA: 85247262282.03.D7290FB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4C9A240004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 03:43:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LCCGzzQH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790221438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YQ8R5fleRSoczA/1Utx8tY10AnabJLwQLbrDG6eWi+0=;
	b=Jih/DfgilxqcI9roJup/ytpCxN4SVFOxGnJziPZab2ox0urCc6H5ZDY2p3LRlPJOqEksAK
	ZggIooIvfMHkweJHHsqZ+dIPavpAiLx6n+LQiA9I9n521SDIqqkrhZHUsb596UyPqdbW6I
	t0ZkcIExyP2vqb6k5cgf7t19jJCVrrc=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LCCGzzQH;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790221438;
	b=NJ8bh20cMA4hPiMmpYj+Qj/Rx9WQ9fjVLN0KXVt0DTQ4uvVgQOlZyZbVKYvvX/aMUH5LDH
	MzNyNmkfw7Tdab9fxoKTGklLQRooZEERl17xtqcu+msq2SajKQ/pOWlNOo7jlN4X6lTh9b
	YJnzfPhy32Lk0Cd12XxNz9UHHzASlzs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790221437; x=1821757437;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YQ8R5fleRSoczA/1Utx8tY10AnabJLwQLbrDG6eWi+0=;
  b=LCCGzzQHvWFWuc1VitHDHagLkxJE0yDKoyzTg9XRKrQ/3WgjgjXzDw0W
   jveCxjdHrG72MBEX2gPvSrYmOWx6TfXZytTR8aP/vbzMZcBOH7p6QKae+
   fHEqlH3Gj2k+cOESptC/FP7COfGDrTaM7AvaXhvu3uz64bS9i0msAOIim
   BUxAPHRcQzbSWKWBP6pJFn/IaR04xuqH1xQQ8QkTCVVWnMAhNOnwsSoiB
   dAPmNHFEXqFuLAnR283GdrNCSBTdRq51MG/gosAkq5rcMDYDodZHZVHmN
   e8Yrn8d8M92SXDtiG9BQv06MXm1JfVXEN0rfOnytvd1Dp4q4Es77GoY/9
   w==;
X-CSE-ConnectionGUID: 1nw7rjOYQL+mhpwh1/18Kw==
X-CSE-MsgGUID: QiILqlgaQGeT6/QZ7I8o3w==
X-IronPort-AV: E=McAfee;i="6800,10657,11914"; a="93479464"
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="93479464"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 20:43:56 -0700
X-CSE-ConnectionGUID: 6CraDU9DS4yLVC54U0kyXQ==
X-CSE-MsgGUID: CmFXyNklRy2G1DuNrKtd4A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,119,1787036400"; 
   d="scan'208";a="301846591"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2026 20:43:56 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 20:43:55 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 23 Sep 2026 20:43:55 -0700
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.65)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 23 Sep 2026 20:43:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kaUj/QLI0eKD3em/XTPEzZ5KLvMoywpUqiaaVa2E750d9igf3YCWHIHzmMFiyoa4KWXGE2HuAQu+5KFCtQLg0BBiws42qLSt2gocOZwhit76w46erQykMpAQNV3qztBqyQ6kYM1MH+orhc+o3kxkm3pbYcu6kwijx27dwn9A84X/cDvEm/pv93ohoQ4uMNx+11iJUY12Tqh46OvHBfhicbBPtXgb78xtS0YWbFhIX6YaY/UEC+aEzeB6hic4uVSqQt/rTyAkLGwP56AAusfq9Z5h6yafd/P7Dq8V7ox72ZNqAzzSq+ZFgLize24WRbREtGifayOS+ybkX07TmmWpwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YQ8R5fleRSoczA/1Utx8tY10AnabJLwQLbrDG6eWi+0=;
 b=EPufIsOAsNE34cuJVBJ3ikYG4CFCF7kovZfrZkgYjrfuughANoG14AonfAKzcnOn5HtjKaea9OAuLyvMTqMKJOMGmIaRQhcAp+YKMe+vctKdJw3TnlYQWUB1ztOaVI/XX4atMxcivRMxsiBAwpWH4d1/iPxYqrl5A8Ffx3aJF3sdq4txGIR4/6ssTXF1SP3nVZ2GXcu9V5D9uQGi6ZQXksAY8MYh7pen7CXbQEq8r0QhUdaMWigAUQ2cBW7NxF/nP7ZHQG42g/KuozPUAiCrGbmGqxuSyyeuf0EwWy+gKzuByLScPl5BHfu45KR9hN0DLzT9JIMVqW8NJ3+NukZV/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by CH9PR11MB9903.namprd11.prod.outlook.com (2603:10b6:610:341::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 03:43:52 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 03:43:51 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Barry Song <baohua@kernel.org>
CC: "ryncsn@gmail.com" <ryncsn@gmail.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "kasong@tencent.com" <kasong@tencent.com>,
	"lance.yang@linux.dev" <lance.yang@linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "weixugc@google.com" <weixugc@google.com>,
	"yuanchu@google.com" <yuanchu@google.com>, "yuzhao@google.com"
	<yuzhao@google.com>
Subject: RE: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Topic: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0IAABs2AgAAAX2CAIV5sIA==
Date: Thu, 24 Sep 2026 03:43:51 +0000
Message-ID: <SJ1PR11MB61057EF65B62E06E2C2049008C812@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
 <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <CAGsJ_4yRJnr4xXdokVHu85b7XPe0p6rZ+Lzv4sE_gCWdOF4YAw@mail.gmail.com>
 <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
In-Reply-To: <SJ1PR11MB6105505CAF620B23978FBEF18CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|CH9PR11MB9903:EE_
x-ms-office365-filtering-correlation-id: 09c34f6b-aca1-4330-a907-08df19ee0cdf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014|23010399003|10067099003|56012099006|18002099003|22082099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info: zL7VPd9CLSJ87gn7+6HQaumaq/fq/BXkBPCCjds/C/5m/FhnR5whn/QvguQRBGz132lAJPBNGzdUhawViNso8eS1WueFXfU37USFpa59Vratxq+79SfX13eKMrkc8Yz8jbQw/ysMUdx/gQYv5YHyTbeGN1qyporG4MObQf2/aP9tjxtzTLcUvFfWYP4x9NszjLqMnE05Gsn2xhbOVrAK/UMWjxiGoUzn0mnRSvKuqoutv3uP2dEMu2evHO4qZqhteyjg4HDJTEHmodgko5kCC8DWrmpgFKB+Tz8STtQDJRydeS/mwq8KfaoOViWZYVZwf6HZFdr3f0+mIo2CwjV7eIpJiSRdZ6PdE7Rcx8uONb0vK6PLKCC6jIA0PSIGjMiRwJvOUZLcVOjMaDUW0z0/ln6iJqBmkuoSo6DwyUYffbAR9NDVMlteWL+vok81hOs4uyepcIfhPLEUK+5Qlw2OnPJTYGKHv0Q0W0AhGS0wuTnY7BwNBFDoQstq9j44Rro2WKuKl22dngVr5owMkzq4wEKhM7jnpaJJ3zgqNNem4PjPe/YK6F4lmO/tfXP2EH9Xhv9Zzl1fVllJaq0RecaJajS3G6YEZPamqevCiixPIjxErNmDn2uK/3ExRcc7YdQ7mE808w+9R+Muv6yA4qX+5J3LkNLWsm/lPO+KnGgg/xgcsuASO6wjLVkKvME0ubpU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(23010399003)(10067099003)(56012099006)(18002099003)(22082099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0xvWWFIY2YwUE85KzRTSksyL0hVeVpUMVlTeWsrdjUxcU5qZDFJeFNySlNJ?=
 =?utf-8?B?eXVBMDBtWXlGTERYMU1FSEdiR2l2c3V2QTBWRFZ4K01LSWpRa3JxQ3JFZHU5?=
 =?utf-8?B?Tm5QZ2o4dWNNenpBdXhiUXZXQWlSUDl0WGxZUUZYQWhxU3lnRExRVGd0Ykxk?=
 =?utf-8?B?OEpBaUwrOGFWQUFmTVR4OTJ1TEtaLzJyLzhadFVRakVPaGdUQU04NEZmcnJ1?=
 =?utf-8?B?UGNkRjc1TnI5MHpndzZHTzFiUTRFc08vb0RzZW9hY2ZrY1dIVE00UGRGZjVs?=
 =?utf-8?B?K3FmSlZacUtOTUhINDE1Uk9DeUtpWDFXanBqNkdWRGJUaENKdUVpekZPUFJG?=
 =?utf-8?B?M3lETWxodURUTXV0dm1yY0pCOGpoM3hSWnpuMGkyT21lN083VmR3VzBnbXMv?=
 =?utf-8?B?OE5uVkRlcVljK2llb24rRk9PTjlWK0JsSkFHV0ZBVVZkaU8vNFEwYlFEaEl3?=
 =?utf-8?B?N2V2bU1hNDFqeTIydFoyWDVkRFlWdXRwbklwblUvTW5ZRWZKWEdaTC8yRnVY?=
 =?utf-8?B?ZkZlUjlvOWJybk5pM0s0UHNQWDF3L0dvWEdTcGRMZ1U3NElGWUttKzJTK1pa?=
 =?utf-8?B?eHR1dFZnU2RVK3d5U0wxTm5oRTk4MXlQY1ZlNGRyRXVYQlAxNCsxMzR5L0dD?=
 =?utf-8?B?aW83dWc3TG9sYU9Tc1RReWpldVBBWmhmN3RZbWJaRHhBRlB6VE82L2U5Yzlu?=
 =?utf-8?B?bGIwVmllY2NZZVE2THJ6Sm13MGhFck0wUTAyMHNyZUl4ZGpoZHJXK20vNVpV?=
 =?utf-8?B?TTFIMU82ZEU1ejlvcXJVdmNSS2RITXZjQnUvY3JHUUlzelZKejI2RG9CVERO?=
 =?utf-8?B?SW5JR2F0SjFpbFBKM2d2T01mRElKUkRLeC9FQ1BsQXU1bThMV0F5LzBkbXRM?=
 =?utf-8?B?ZUlHa2tBRFkxRVhEMDJBek43UjFJaWV4TjE0UmNIMnlSVkp0VVJVZjBzZnpy?=
 =?utf-8?B?b0ZLTVF0UmhDR0RIWEJhTHpTMENVNTFpTTkzTDdndlBDWDRuTkNkQ2RkYVZx?=
 =?utf-8?B?RU9RR0J5ek0rSWNLbFU4L1NTbVE2a0F4T0NrZ1hOMnFuQ3RtYW9OVmx3dTRj?=
 =?utf-8?B?K3IrSFlxTzJrbFBWWFVpVTBRdW9yU0VpV2NWcGk0UGJMa21kcHAwdnd2K1Jm?=
 =?utf-8?B?akhnejkza3E3UFpKWWQrQ0l1cVJ4RGxkZDlMQnNzbUpiTzN5ZUVpM01abGtF?=
 =?utf-8?B?SUJtREd5RlpId201YVF3UGdxRkpqMWdKYnRSV1lpOFNjd3JXYUZZTzFKSUxK?=
 =?utf-8?B?bk9rT2RBVEVzcjlzL243U09SNEFoZW1LZWI5QnczdUIzM1RqZnZLdmZWci9Q?=
 =?utf-8?B?em9KemhGcTN3Sks5UFpMVkxEQnQ4WEp5K2hjeWs3dXFCZWJpbUd4LzdvTU9Q?=
 =?utf-8?B?cVVoL3JpTk54QkN1MFkzVEx1dkVBYTg3M2ZZKzBaY21TU202Qnc2NGpzY2sz?=
 =?utf-8?B?L2Q2eGVPRXM3NGpKUTA0RFU4NlVwTVdKbFZ2Q3lpYU51M3N3ZUIxWlIvK3Vi?=
 =?utf-8?B?M0l2MUpnWUpZdmExM1IyQ3MxZlo5RHo0WXRNRU5nYllnaWhnZDNtc2wxaDNH?=
 =?utf-8?B?RC9EdVN4MFFmYlJTVlFJOUJCTFZCV2tnWWp3Yy9Sd2Y0K1gzSkVUMmdqdXZm?=
 =?utf-8?B?YTlvL2tWQ2xpcHdubjNFdEVLWnh1MGhEVU5Yd1JvaHA1bUVTR0JsUklhU1BR?=
 =?utf-8?B?V09LK1NIR2k3M3l1RlJaaG9BQlk2MHJkOFN3eHM0eDV2MFBvVk9xTGhKYW5h?=
 =?utf-8?B?WmlzNVFjYmlQVkdTQldSaWNDQW1oMjhKeWJpblVyY0JndHlKUW9rN0lRZkJQ?=
 =?utf-8?B?QVhnOENRcy9KcTdOZjlCWVdWbGpYZ1ZIK1E4Q1FNZWxPaC85dnJYMkNnMXlI?=
 =?utf-8?B?RTJqWmduOXlaRXNmY0NLQ055UEpQa3JWZ3NPV1Z5TjVHbE56enhBb2kyWGJU?=
 =?utf-8?B?ampSTTBGYUp4Y0JhcVF4cXB4OUZoZi9kdkprRiszZ1lHVkJoVHpqdENySG1R?=
 =?utf-8?B?OXpLa3k1VVNEeGFhbTYwNHE0ekc4NWk3Q3NkT3FZVmt6T2JJTy9UanJ4YmJr?=
 =?utf-8?B?TWIvUHlxYXd3b3o3MGJpSFJzWFVTNlhMRkRWcldEYVQ4cXMwOXVxSHpTOFgy?=
 =?utf-8?B?dkFTWVZEenp2UFd0UW56eWxCcDFHUlZTNFkzYzRIcnlBd3VKUk1TcTAraFJ4?=
 =?utf-8?B?aENPUWRlQ1NIQmZVd0xRSkZkVU0ycFB1bEdQN0hqaEpQcFM4eldIVEdiNnBh?=
 =?utf-8?B?TW5UV0pWdWRCeW80SWVuL0pLeU05em8wMUZjbDFhRmY0VzloTkJ2Y2hRTnZy?=
 =?utf-8?B?a0tzbVphNWxKOHBOOW1JSkd0Sm1oR042N2NrZngvNkdMdm5QS2JwUT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: wUk5YFZPGOCTzLuIYvW3zRm7w04O2vDqbMocG3319WkeNH+fPJUCCRxHwf1J3SdKXHu3jOnsR4BJT7RUUfdWNXypS6Y5nymSOTTaEHyw2jQSlL7lgSAOrbH7A51igOk4i/zwMZCPDlLSVJ3sBYicEc0KMnkCFqGV8S6SZJpYrRn7fj5IM4C2Uv1acL36e9G8maKXCyxIGhp2bH8QiAOYoNvzFqzogd7g8p4efNP30TSJexHPA2oAxnI+yzkSsVK6aM2GLQwUxVCPBerqztM0BJmRPKAwm33ID2dVPxBId3XI88qyyqTWWVOxDAqeUU5O08LBAUXIwsaehYaDaC3CpA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09c34f6b-aca1-4330-a907-08df19ee0cdf
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2026 03:43:51.8471
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kA8AHK3ASN/Ow33wift9+a1dd2pjMkTCLIuts7Qamc1KbvktEAHyMj36wgw5hI0V3DItzXi4WubOehZRmxTSQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR11MB9903
X-OriginatorOrg: intel.com
X-Stat-Signature: gmoa85jcft7ox4dkjnweu14uhxym9d38
X-Rspamd-Queue-Id: 4C9A240004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790221437-752488
X-HE-Meta: U2FsdGVkX1+Rm33lln9jPKeqmojyAEYMoF+3h7gy8MERcdlplk4/obb5PFPnN46xnwJUgMqDezJRKwjz2QEuSgLfVJMrob133KYExcqAO8dQSrWpzfChMsRPoy8hQCFwwBkGiIZdkqlHsnlCekfMP6RtHXBBgYcaYVvOh0x+IOpT1XNButSvrV7rXC68t48RzKPcLJ9EVLThhMcV7hDFZ5/1shCGmG976lPgM+jSF30xj420gvkf6z0YZ6SgOhG/uqEbZFEj7YobnFqm/7rzBii737aEh0TT3ed7qIfdjXCcORBiZkDG2nTg/IbgoqW+K2cFDz5/qDiBzqtoKUusbe29ldM/5Bkw2XgQ4ljKk6kp4Wk+emriirE5dxejgUpAdFj89/+o5nZmZ9IsgBmwhzlzlSYsNptgiY46Eixd6O+5ja9S7exdaJicKkDGF7OsbpTlf2z4xJr9TYdcONPuUBD/NPsfuDQlr52dO5NYqNOBaoEE54XuPjf2uT23/ig1PZtR5qEREi6BGy6mRIqcuTgdG3EAKlslPAdSRq6I8x32iFq2LL4psTqq8rb8k3Kddn+z6smECokGpA9wEa+5Vq8lU/4jk6b0r1YilvIM0lrQfiKWXyXkbHCrHpB/x12kWrChmCjZ5hyN87GEpzQgLexQWTYcJhE2Jh4gGjWZQZkMEEZ0yL4WpvhN+RGRRdtf4DV2UuCydGAX+Skfvlwk/3Q8LHovH6fIiqybJL4uCtgAckXe8V4jW2FiN9fcWLlI+eNzvPthhPY6/bbsoz0pcvs/S4y8Jx7X7A/+N5GChO+3VChErnP+FSitofB5Xcl9mzu8S2SrMPwJJ1kwJ6RuVfCc3e3Xt6AHgubHnFG2j844X0ZrwGeS3r8AiXVEwoqqSqSpiHwzY3W7utvSl7rx7EHJdRCk5SNVq2i9mh1ogOOi9jQ0oD4Q/ZuEG1osODAC0EZ2sDsiwsqe+ChrNXe
 V+lpClJC
 QObWErx4JYEfBDBUkOwOoXrmkZ0kDjnnsk9/cd+J+1trYmzoBCbZQAu7Bm1LUVXEvEPCof5OIAa9whXwmzdkx+FW+LW9GUKySvsHKsXIGaj/JtuTbkkV7ZFO0QxuYbFTLVZL2nfVKamDocURy0cxUvD0iEYhJNuGysnT5QNnoiPNsL1ot9iTI14UMlT34or/nNJzN662VRFThSqu8rATM1+cPrgeoIs3CwPs4novJof5Pp2zRj2/CgYQ3NxXq8HNZ4bFOMxkZtlGjNafUC126cgL17TbJQR+PTICKePZZImi8T0Vs+jZxnF2ybGEojpUNCbHzFjCd6zJc4w6loQfpMD95R7TVJKZ5pyX+OQQ7Z+tgRnzzKeEFRL7cqIm9p3kisw/zUct1a1nVlBTVHSeN0UKqOaKjsfEM3U09PwICcMN0PJ3zXJPgoSFah1Kz3XAo0fq2a7RbIrveXThRm5I31ZZ0VV8OyuNB+ilXuBhKW6N9HDKcOgPv4IdEGeVlcsq5FNlzDbCtkzx172zVuRhjDGk9GOgvYTZJph1BGwVwhER1/+4VUkwHbN5Kha8sYI4+ojH9GeCf9gBwkvNxu7IidJJ2WzIfIuzGXSaJCZBDCxrnpLVgUzEtQJ/xtw/mKENnRbyvZDehJwVo/FH8O92aZPMvkeeq9K3rVlMG413ePdBEmAxpMyhOWrQeDYxTbi7/VOu35E+qkQ/UclmnqiiPFdnt+mKYxGqLXX0x1xSc84bZNLO8gFZBCycLrVEWlAws1VNq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgS2FpcnVpLCBCYXJyeSwNCg0KQXBvbG9naWVzIGZvciB0aGUgZGVsYXkgaW4gZ2V0dGluZyBi
YWNrIHRvIHlvdSB3aXRoIHRoZXNlIHJlc3VsdHMg4oCUIG15DQp0ZXN0IGVudmlyb25tZW50IGdv
dCBjb3JydXB0ZWQgYW5kIEkgaGFkIHRvIHNwZW5kIHNvbWUgdGltZSByZWNvdmVyaW5nDQppdCBi
ZWZvcmUgSSBjb3VsZCByZS1ydW4gdGhlIGJlbmNobWFyay4NCg0KPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiBGcm9tOiBBYmFibmVoLCBFaGFiDQo+IFNlbnQ6IFdlZG5lc2RheSwgU2Vw
dGVtYmVyIDIsIDIwMjYgMzowMiBQTQ0KPiBUbzogJ0JhcnJ5IFNvbmcnIDxiYW9odWFAa2VybmVs
Lm9yZz4NCj4gQ2M6IHJ5bmNzbkBnbWFpbC5jb207IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7
DQo+IGF4ZWxyYXNtdXNzZW5AZ29vZ2xlLmNvbTsga2Fzb25nQHRlbmNlbnQuY29tOyBsYW5jZS55
YW5nQGxpbnV4LmRldjsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXgtbW1A
a3ZhY2sub3JnOyBxaS56aGVuZ0BsaW51eC5kZXY7DQo+IHNoYWtlZWwuYnV0dEBsaW51eC5kZXY7
IHdlaXh1Z2NAZ29vZ2xlLmNvbTsgeXVhbmNodUBnb29nbGUuY29tOw0KPiB5dXpoYW9AZ29vZ2xl
LmNvbQ0KPiBTdWJqZWN0OiBSRTogW1JGQyBQQVRDSF0gbW0vbWdscnU6IGR5bmFtaWNhbGx5IHBy
b3RlY3QgcmVhZGFoZWFkIGZhdWx0DQo+IGZvbGlvcyB1bmRlciByZWZhdWx0IHByZXNzdXJlDQo+
IA0KPiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBCYXJy
eSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz4NCj4gPiBTZW50OiBXZWRuZXNkYXksIFNlcHRlbWJl
ciAyLCAyMDI2IDI6NTggUE0NCj4gPiBUbzogQWJhYm5laCwgRWhhYiA8ZWhhYi5hYmFibmVoQGlu
dGVsLmNvbT4NCj4gPiBDYzogcnluY3NuQGdtYWlsLmNvbTsgYWtwbUBsaW51eC1mb3VuZGF0aW9u
Lm9yZzsNCj4gPiBheGVscmFzbXVzc2VuQGdvb2dsZS5jb207IGthc29uZ0B0ZW5jZW50LmNvbTsg
bGFuY2UueWFuZ0BsaW51eC5kZXY7DQo+ID4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsg
bGludXgtbW1Aa3ZhY2sub3JnOyBxaS56aGVuZ0BsaW51eC5kZXY7DQo+ID4gc2hha2VlbC5idXR0
QGxpbnV4LmRldjsgd2VpeHVnY0Bnb29nbGUuY29tOyB5dWFuY2h1QGdvb2dsZS5jb207DQo+ID4g
eXV6aGFvQGdvb2dsZS5jb20NCj4gPiBTdWJqZWN0OiBSZTogW1JGQyBQQVRDSF0gbW0vbWdscnU6
IGR5bmFtaWNhbGx5IHByb3RlY3QgcmVhZGFoZWFkIGZhdWx0DQo+ID4gZm9saW9zIHVuZGVyIHJl
ZmF1bHQgcHJlc3N1cmUNCj4gPg0KPiA+IE9uIFRodSwgU2VwIDMsIDIwMjYgYXQgNTo1MuKAr0FN
IEFiYWJuZWgsIEVoYWINCj4gPGVoYWIuYWJhYm5laEBpbnRlbC5jb20+DQo+ID4gd3JvdGU6DQo+
ID4gPg0KPiA+ID4gSGkgQmFycnksIEthaXJ1aSwNCj4gPiA+DQo+ID4gPiBUaGFua3MgZm9yIHRo
ZSBmZWVkYmFjayBhbmQgc3VnZ2VzdGlvbnMuDQo+ID4gPg0KPiA+ID4gPiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiA+ID4gPiBGcm9tOiBCYXJyeSBTb25nIChYaWFvbWkpIDxiYW9odWFA
a2VybmVsLm9yZz4NCj4gPiA+ID4gU2VudDogVHVlc2RheSwgU2VwdGVtYmVyIDEsIDIwMjYgMzow
NSBQTQ0KPiA+ID4gPiBUbzogcnluY3NuQGdtYWlsLmNvbTsgQWJhYm5laCwgRWhhYiA8ZWhhYi5h
YmFibmVoQGludGVsLmNvbT4NCj4gPiA+ID4gQ2M6IGFrcG1AbGludXgtZm91bmRhdGlvbi5vcmc7
IGF4ZWxyYXNtdXNzZW5AZ29vZ2xlLmNvbTsNCj4gPiA+ID4gYmFvaHVhQGtlcm5lbC5vcmc7IGth
c29uZ0B0ZW5jZW50LmNvbTsgbGFuY2UueWFuZ0BsaW51eC5kZXY7DQo+ID4gPiA+IGxpbnV4LSBr
ZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC1tbUBrdmFjay5vcmc7DQo+ID4gPiA+IHFpLnpo
ZW5nQGxpbnV4LmRldjsgc2hha2VlbC5idXR0QGxpbnV4LmRldjsgd2VpeHVnY0Bnb29nbGUuY29t
Ow0KPiA+ID4gPiB5dWFuY2h1QGdvb2dsZS5jb207IHl1emhhb0Bnb29nbGUuY29tDQo+ID4gPiA+
IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIXSBtbS9tZ2xydTogZHluYW1pY2FsbHkgcHJvdGVjdCBy
ZWFkYWhlYWQNCj4gPiA+ID4gZmF1bHQgZm9saW9zIHVuZGVyIHJlZmF1bHQgcHJlc3N1cmUNCj4g
PiA+ID4NCj4gPiA+ID4gT24gV2VkLCBTZXAgMiwgMjAyNiBhdCAyOjIx4oCvQU0gS2FpcnVpIFNv
bmcgPHJ5bmNzbkBnbWFpbC5jb20+DQo+IHdyb3RlOg0KPiA+ID4gPiA+DQo+ID4gPiA+ID4gT24g
VHVlLCBTZXAgMDEsIDIwMjYgYXQgMTE6MDY6NDNBTSArMDgwMCwgRWhhYiBBYmFibmVoIHdyb3Rl
Og0KPiA+ID4gPiA+ID4gQ29tbWl0IDZjYmRkOTcyNmZiNSAoIm1tL21nbHJ1OiB1c2UgZm9saW9f
bWFya19hY2Nlc3NlZCB0bw0KPiA+ID4gPiA+ID4gcmVwbGFjZQ0KPiA+ID4gPiA+ID4gZm9saW9f
c2V0X2FjdGl2ZSIpIGludHJvZHVjZWQgYSByZWdyZXNzaW9uIGZvciB3b3JrbG9hZHMgdGhhdA0K
PiA+ID4gPiA+ID4gcmVseSBvbiByZWFkYWhlYWQgdG8ga2VlcCBzZXF1ZW50aWFsIGZpbGUgYWNj
ZXNzIGVmZmljaWVudC4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBUaGUgcHJvYmxlbSBpcyB0
aGF0IE1HTFJVIGNhbiBwbGFjZSBmYXVsdC1wYXRoIGZpbGUgZm9saW9zIGluDQo+ID4gPiA+ID4g
PiBvbGRlciBnZW5lcmF0aW9ucywgc28gbWVtb3J5IHByZXNzdXJlIGNhbiByZWNsYWltIHJlYWRh
aGVhZA0KPiA+ID4gPiA+ID4gZm9saW9zIGJlZm9yZSB0aGUgd29ya2xvYWQgdG91Y2hlcyB0aGVt
LiBJbiBvdXIgQ2Fzc2FuZHJhIHJlYWQNCj4gPiA+ID4gPiA+IGJlbmNobWFyaywgdGhpcyByYWlz
ZWQgcDk5IGxhdGVuY3kgdG8gYWJvdXQgOS4yLTkuNSBtcyBhbmQgY3V0DQo+ID4gPiA+ID4gPiB0
aHJvdWdocHV0IHRvIHJvdWdobHkgNDEuOGstNDMuNmsgb3AvczsgdGhlIHJldmVydCByZXN0b3Jl
ZA0KPiA+ID4gPiA+ID4gdGhlIHdvcmtsb2FkIHRvIGFib3V0IDUuNS01LjYgbXMgYW5kIDUxLjlr
LTUzLjFrIG9wL3MuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gUmVhZGFoZWFkIGlzIGltcG9y
dGFudCBmb3Igc2VxdWVudGlhbCBJL08gYW5kIG1tYXAgc2NhbnMsIGJ1dA0KPiA+ID4gPiA+ID4g
aXQgc2hvdWxkIG5vdCBiZSByZXRhaW5lZCB3aGVuIHRoZSB3b3JrbG9hZCBkb2VzIG5vdCBiZW5l
Zml0IGZyb20NCj4gaXQuDQo+ID4gPiA+ID4gPiBUaGUgZ29hbCBpcyB0byBrZWVwIHRoZSBvcHRp
bWl6YXRpb24gd2l0aG91dCBrZWVwaW5nIHJlYWRhaGVhZA0KPiA+ID4gPiA+ID4gcGFnZXMgYWxp
dmUNCj4gPiA+ID4gZm9yZXZlci4NCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBUaGlzIHBhdGNo
IHByb3ZpZGVzIGEgbWlkZGxlIGdyb3VuZDoga2VlcCB0aGUgb3JpZ2luYWwNCj4gPiA+ID4gPiA+
IGJlaGF2aW9yIGJ5IGRlZmF1bHQsIGJ1dCB0ZW1wb3JhcmlseSBwcm90ZWN0IGZhdWx0LXBhdGgg
ZmlsZQ0KPiA+ID4gPiA+ID4gZm9saW9zIHdoZW4gcmVwZWF0ZWQgZmlsZSByZWZhdWx0cyBzaG93
IHRoYXQgcmVhZGFoZWFkIGlzIGFjdHVhbGx5DQo+IGhlbHBpbmcuDQo+ID4gPiA+ID4gPg0KPiA+
ID4gPiA+ID4gVGhlIG1lY2hhbmlzbSBpcyBkeW5hbWljIGFuZCBzZWxmLXR1bmluZzoNCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiAtIGFkZCBhIHBlci1scnV2ZWMgcmVhZGFoZWFkL3JlZmF1bHQg
Y3JlZGl0DQo+ID4gPiA+ID4gPiAtIGFjY3VtdWxhdGUgY3JlZGl0IG9uIGZpbGUgcmVmYXVsdHMg
aW4gdGhlIE1HTFJVIHJlZmF1bHQgcGF0aA0KPiA+ID4gPiA+ID4gLSBjb25zdW1lIGNyZWRpdCBp
biBmb2xpb19hZGRfbHJ1KCkgZm9yIGZhdWx0LXBhdGggZmlsZSBmb2xpb3MNCj4gPiA+ID4gPiA+
IC0ga2VlcCB0aGUgZm9saW8gYWN0aXZlIHdoaWxlIGNyZWRpdCBpcyBhdmFpbGFibGUsIGFuZA0K
PiA+ID4gPiA+ID4gb3RoZXJ3aXNlIGxldCB0aGUNCj4gPiA+ID4gPiA+ICAgb3JpZ2luYWwgYmVo
YXZpb3Igc3RhbmQNCj4gPiA+ID4gPiA+IC0gZGVjYXkvcmVzZXQgdGhlIGNyZWRpdCBhcyBnZW5l
cmF0aW9ucyBhZHZhbmNlIGFuZCB3aGVuIGFuDQo+ID4gPiA+ID4gPiBscnV2ZWMgaXMNCj4gPiA+
ID4gPiA+ICAgaW5pdGlhbGl6ZWQNCj4gPiA+ID4gPiA+DQo+ID4gPiA+ID4gPiBUaGlzIG1lYW5z
IHdlIG9ubHkgcHJvdGVjdCBmYXVsdC1wYXRoIGZpbGUgZm9saW9zIHdoZW4gcmVmYXVsdA0KPiA+
ID4gPiA+ID4gcHJlc3N1cmUgc2hvd3MgdGhhdCB0aGUgd29ya2xvYWQgaXMgYWN0aXZlbHkgYmVu
ZWZpdGluZyBmcm9tDQo+ID4gPiA+ID4gPiByZWFkYWhlYWQuIElmIHRoZSB3b3JrbG9hZCBkb2Vz
IG5vdCBuZWVkIHRoYXQgcHJvdGVjdGlvbiwgdGhlDQo+ID4gPiA+ID4gPiBvcmlnaW5hbCBvcHRp
bWl6YXRpb24gcmVtYWlucyBpbnRhY3QgYW5kIHdlIGRvIG5vdCBrZWVwDQo+ID4gPiA+ID4gPiBy
ZWFkYWhlYWQgcGFnZXMNCj4gPiA+ID4gYXJvdW5kIHVubmVjZXNzYXJpbHkuDQo+ID4gPiA+ID4g
Pg0KPiA+ID4gPiA+ID4gQmVuY2htYXJrIHJlc3VsdHMgZm9yIHRoZSBDYXNzYW5kcmEgcmVhZCB3
b3JrbG9hZA0KPiA+ID4gPiA+ID4gKDQgbm9kZXMsIDcyMHMsIDEwMCByZWFkZXJzKToNCj4gPiA+
ID4gPiA+DQo+ID4gPiA+ID4gPiAtIHdpdGggY29tbWl0IDZjYmRkOTcyNmZiNSAoIm1tL21nbHJ1
OiB1c2UgZm9saW9fbWFya19hY2Nlc3NlZA0KPiB0bw0KPiA+ID4gPiA+ID4gICByZXBsYWNlIGZv
bGlvX3NldF9hY3RpdmUiKToNCj4gPiA+ID4gPiA+ICAgcDk5IH45LjItOS41IG1zLCB0aHJvdWdo
cHV0IH40MS44ay00My42ayBvcC9zDQo+ID4gPiA+ID4gPiAtIHdpdGggcmV2ZXJ0IG9mIGNvbW1p
dCA2Y2JkZDk3MjZmYjUgKCJtbS9tZ2xydTogdXNlDQo+ID4gPiA+ID4gPiBmb2xpb19tYXJrX2Fj
Y2Vzc2VkIHRvDQo+ID4gPiA+ID4gPiAgIHJlcGxhY2UgZm9saW9fc2V0X2FjdGl2ZSIpOg0KPiA+
ID4gPiA+ID4gICBwOTkgfjUuNS01LjYgbXMsIHRocm91Z2hwdXQgfjUxLjlrLTUzLjFrIG9wL3MN
Cj4gPiA+ID4gPiA+IC0gd2l0aCB0aGlzIGZpeDogcDk5IH41LjggbXMsIHRocm91Z2hwdXQgfjUx
LjlrLTUyLjdrIG9wL3MNCj4gPiA+ID4gPg0KPiA+ID4gPiBbLi4uXQ0KPiA+ID4gPiA+DQo+ID4g
PiA+ID4gSnVzdCBhbiBpZGVhLiBGb3IgYW4gc2hvcnQgdGVybSBhbmQgZWFzeSBmaXgsIHdoYXQg
aWYgd2Ugc2ltcGx5DQo+ID4gPiA+ID4gcmV2ZXJ0IHRoYW4sIHRoZW4gb25seSBwcm90ZWN0IGlu
X2ZhdWx0ICYmIGZvbGlvX3Rlc3Rfc3dhcGJhY2tlZA0KPiA+ID4gPiA+IGZvbGlvcyB3aXRoIFBH
X2FjdGl2ZT8NCj4gPiA+ID4NCj4gPiA+ID4gSGkgRWhhYiBhbmQgS2FpcnVpLA0KPiA+ID4gPg0K
PiA+ID4gPiBUaGFua3MgdmVyeSBtdWNoIGZvciB5b3VyIHJlcG9ydHMgYW5kIGRpc2N1c3Npb24u
DQo+ID4gPiA+DQo+ID4gPiA+IEknbSBub3QgcXVpdGUgc3VyZSB3ZSB3YW50IHRvIHJldmVydCBp
dCBlbnRpcmVseSwgYXMgdGhhdCB3b3VsZA0KPiA+ID4gPiBpbW1lZGlhdGVseSByZWdyZXNzIHRo
ZSB3b3JrbG9hZHMgaW1wcm92ZWQgYnkgdGhlIGNvbW1pdCwgc3VjaCBhcw0KPiA+ID4gPiB0aGUN
Cj4gPiBrZXJuZWwgYnVpbGQuDQo+ID4gPiA+IEFsc28sIGZvciBleGFtcGxlLCBLYWlydWkncyBj
b3ZlciBsZXR0ZXIgbWVudGlvbmVkIHRoZSBMZXZlbERCDQo+IGJlbmNobWFyazoNCj4gPiA+ID4g
ICJJIGFsc28gcmV0ZXN0ZWQgdGhlIExldmVsREIgYmVuY2htYXJrIGZyb20gdGhlIGNhY2hlX2V4
dCBwYXBlciBbNV0uDQo+ID4gPiA+IEludGVyZXN0aW5nbHksIG1haW5saW5lIE1HTFJVIGFscmVh
ZHkgYmVhdHMgQ0xSVSBvbiB0aGlzIG9uZSBhZnRlcg0KPiA+ID4gPiBhIHJlY2VudCBjaGFuZ2Ug
aW4gbHJ1X2dlbl9mb2xpb19zZXEgdGhhdCBidW1wcyBuZXcgZm9saW9zIHdpdGgNCj4gPiA+ID4g
cmVmcyA9PSAxIHRvIHRoZSBzZWNvbmQtb2xkZXN0IGdlbmVyYXRpb24uIg0KPiA+ID4gPg0KPiA+
ID4gPiBJIGd1ZXNzIHdlIGNvdWxkIGluc3RlYWQgdHJ5IHRvIG1pdGlnYXRlIHRoZSBjYXNlcyB3
aGVyZSBzb21lDQo+ID4gPiA+IHdvcmtsb2FkcyBhcmUgbmVnYXRpdmVseSBhZmZlY3RlZCB3aGls
ZSBwcmVzZXJ2aW5nIHRoZSBvcmlnaW5hbA0KPiA+ID4gPiBpbnRlbnRpb24uIERvZXMgdGhlIGZp
eCBiZWxvdyBhZGRyZXNzIGJvdGggb2YgeW91ciBjYXNlcywgb3IgaXMNCj4gPiA+ID4gRWhhYidz
IGNhc2UNCj4gPiBhY3R1YWxseSBkaWZmZXJlbnQgZnJvbSBLYWlydWkncz8NCj4gPiA+ID4gKFRo
ZSBrZXJuZWwtYnVpbGQgdGVzdCBvbiBteSBtYWNoaW5lIGxvb2tzIHF1aXRlIHBvc2l0aXZlLiBJ
dCBub3QNCj4gPiA+ID4gb25seSBwcmVzZXJ2ZXMgdGhlIG9yaWdpbmFsIG9wdGltaXphdGlvbiwg
YnV0IGV2ZW4gcHJvdmlkZXMNCj4gPiA+ID4gZnVydGhlcg0KPiA+ID4gPiBnYWlucy4pDQo+ID4g
PiA+DQo+ID4gPg0KPiA+ID4gSSBhZ3JlZSB0aGF0IHJldmVydGluZyB0aGUgY29tbWl0IHRoYXQg
Y2F1c2VkIHRoZSByZWdyZXNzaW9uIGlzIG5vdA0KPiA+ID4gdGhlIG9wdGltYWwgcGF0aC4gSSBl
eHBlY3QgdGhlcmUgYXJlIG1hbnkgd29ya2xvYWRzIGFuZCBzY2VuYXJpb3MNCj4gPiA+IHRoYXQg
YmVuZWZpdCBmcm9tIHRoZSBiZWhhdmlvciBpbnRyb2R1Y2VkIGJ5IHRoYXQgY29tbWl0LCBzbw0K
PiA+ID4gcmV2ZXJ0aW5nIGl0IGNvdWxkIHVubmVjZXNzYXJpbHkgcmVncmVzcyB0aG9zZSB3b3Jr
bG9hZHMuDQo+ID4gPg0KPiA+ID4gSSB3aWxsIHJ1biB0aGUgQ2Fzc2FuZHJhIGJlbmNobWFyayB3
aXRoIEthaXJ1aSdzIE1HTFJVLUZHIHBhdGNoZXMgdG8NCj4gPiA+IHNlZSB3aGV0aGVyIHRoZXkg
YWRkcmVzcyB0aGUgaXNzdWUgSSBhbSBzZWVpbmcuIEkgd2lsbCBzZW5kIHRoZQ0KPiA+ID4gcmVz
dWx0cyB3aGVuIHRoZXkgYXJlIHJlYWR5Lg0KPiA+ID4NCg0KVGhhbmtzIGZvciB0aGUgcG9pbnRl
ciDigJQgSSBnYXZlIHlvdXIgTUdMUlUtRkcgZml4IGEgdHJ5IGFnYWluc3QgdGhlIHNhbWUNCkNh
c3NhbmRyYSByZWFkIGJlbmNobWFyayBJIHVzZWQgZm9yIG15IHBhdGNoICg0IG5vZGVzLCA3MjBz
LCAxMDAgcmVhZGVycykuDQoNClJlc3VsdHMgd2l0aCBNR0xSVS1GRzoNCiAgT3AgcmF0ZTogICAg
ICAgICAgICAgICAgICA1NS4wayAtIDU2LjVrIG9wL3MNCiAgTGF0ZW5jeSA5OXRoIHBlcmNlbnRp
bGU6ICA2LjggLSA2LjkgbXMNCg0KRm9yIHJlZmVyZW5jZSwgaGVyZSdzIHdoZXJlIHRoZSBvdGhl
ciB2YXJpYW50cyBsYW5kZWQgb24gdGhlIHNhbWUgc2V0dXA6DQoNCiAgUmVncmVzc2lvbiAoNmNi
ZGQ5NzI2ZmI1LCAibW0vbWdscnU6IHVzZSBmb2xpb19tYXJrX2FjY2Vzc2VkIHRvDQogIHJlcGxh
Y2UgZm9saW9fc2V0X2FjdGl2ZSIpOg0KICAgICAgcDk5IH45LjItOS41IG1zLCB0aHJvdWdocHV0
IH40MS44ay00My42ayBvcC9zDQoNCiAgUmV2ZXJ0IG9mIDZjYmRkOTcyNmZiNToNCiAgICAgIHA5
OSB+NS41LTUuNiBtcywgdGhyb3VnaHB1dCB+NTEuOWstNTMuMWsgb3Avcw0KDQogIE15IGR5bmFt
aWMgcmVhZGFoZWFkLWNyZWRpdCBmaXg6DQogICAgICBwOTkgfjUuOCBtcywgdGhyb3VnaHB1dCB+
NTEuOWstNTIuN2sgb3Avcw0KDQpTbyBNR0xSVS1GRyByZWNvdmVycyBtb3N0IG9mIHRoZSBsYXRl
bmN5IHJlZ3Jlc3Npb24sIGJ1dCB0aGUgcmV2ZXJ0DQphbmQgbXkgZml4IHN0aWxsIHJlY292ZXIg
bW9yZSBvZiBpdDogcDk5IHdpdGggTUdMUlUtRkcgaXMgbm90aWNlYWJseQ0KaGlnaGVyIHRoYW4g
d2l0aCB0aGUgcmV2ZXJ0IGFuZCBteSBmaXggKDYuOC02LjkgbXMgdnMgfjUuNS01LjggbXMpLA0K
dGhvdWdoIGl0J3Mgc3RpbGwgYSBiaWcgaW1wcm92ZW1lbnQgb3ZlciB0aGUgcmVncmVzc2lvbidz
IDkuMi05LjUgbXMuDQoNCkhhcHB5IHRvIGRpZyBmdXJ0aGVyIGlmIHVzZWZ1bCDigJQgbGV0IG1l
IGtub3cgaWYgeW91J2QgbGlrZSBtb3JlIGRldGFpbA0Kb24gdGhlIGxhdGVuY3kgZGlzdHJpYnV0
aW9uIG9yIGEgbG9uZ2VyIHJ1biB0byBjb25maXJtIHRoZXNlIG51bWJlcnMNCmFyZSBzdGFibGUu
DQoNClRoYW5rcywNCkVoYWINCg0KPiA+DQo+ID4gVGhhbmtzIHZlcnkgbXVjaCwgRWhhYi4gQ291
bGQgeW91IHBsZWFzZSBhbHNvIHJ1biBteSBwcm9wb3NlZCBxdWljayBmaXg6DQo+ID4NCj4gPiBo
dHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDI2MDkwMTIyMDQzMC43OTgxMC0xLQ0K
PiA+IGJhb2h1YUBrZXJuZWwub3JnLw0KPiA+DQo+IA0KPiBTdXJlLCBJIHdpbGwgZG8uIEkgd2ls
bCByZXBvcnQgYmFjayB3aGVuIEkgaGF2ZSB0aGUgcmVzdWx0cy4NCj4gDQo+IFRoYW5rcywNCj4g
RWhhYg0KPiANCj4gPiBCZXN0IFJlZ2FyZHMNCj4gPiBCYXJyeQ0K

