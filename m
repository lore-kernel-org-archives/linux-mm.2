Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0949CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 07:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA50B6B0095; Wed, 14 Oct 2026 03:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55FB6B0098; Wed, 14 Oct 2026 03:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC606B0095; Wed, 14 Oct 2026 03:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67C7F6B0095
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 03:29:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 296E780454
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:29:37 +0000 (UTC)
X-FDA: 85320406794.03.ECD54D5
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf06.hostedemail.com (Postfix) with ESMTP id D250A18000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:29:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Kq1T11gs;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791962973;
	b=tWcsc9UDaQzmLWI+3vBtwnuC039kDSfGgnK/3pgBOOhfx3eWyTv8JQ+gUIDzhVQT5En37z
	lzsUUoBCzLYM07odzSG69gn6+i5Fh/aTE8IdooI9/cErMZkx30qrcXXNKi4p4+pOF0CHnK
	PGdtrMddLMUi/X3s1Af9jbAOawzpRx8=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Kq1T11gs;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ehab.ababneh@intel.com designates 198.175.65.19 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791962973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqGterWmUygMunQ3ws6VOxVQhdu40k5g6r60nX/fe20=;
	b=MQgeTt18mcZD0mXG27WzmvYKBVrALADHFY/lzzM1y0WmtVVt/eXDcBmCSZKIHfgvAZsQuZ
	gFmQRGYvndKuiSJqxqADYTbBH+d8SSOoSLKBgPLjtcLqYvmErazytWqiLYqaikADpFX8/E
	w2Y/39s5tLee5xYQIFGnRQoJOussw28=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791962973; x=1823498973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KqGterWmUygMunQ3ws6VOxVQhdu40k5g6r60nX/fe20=;
  b=Kq1T11gsS6CZCkjfIabdh0BI8nSL0pE60zNre9wZ7SrIBEb89IZrQraW
   B0VCOsJUAgAhhTlgn7XDI9ksJskWKC37JwM2LjsEx37/5aNnUR/BXeVWZ
   xAI3n1Jp1TT7e9nJmoNGERU3MWr+7Q6IPoYgpKL0IGbUryRxuSNHd8Oqf
   7CYY/i13YmEjuuCmfJ9HfT2S2dm2Hq7Ym+aMBcfA88tCC+Pok6+HvOAKA
   nvkZnL0a1mtWFjMyIPdKVXEWz9XdNHWB59om3L0zWZPOgYlC+kihxsHgG
   GaBmEfOliAMsyfE3dC/25Vz4nj7GdJyTnr+4R/D5Z+FVhAAKB0F6+gZTW
   w==;
X-CSE-ConnectionGUID: uF+o1AF4Q8+E8Cxo0mANsA==
X-CSE-MsgGUID: zzGB3k55QWmSTIjAxegE6Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11934"; a="732014"
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="732014"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 00:29:31 -0700
X-CSE-ConnectionGUID: xKA6tqrmTReptplmHRZzpg==
X-CSE-MsgGUID: WnmeWOJpSpeOy+h3ktRvKQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,157,1787036400"; 
   d="scan'208";a="1255980"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2026 00:29:31 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 00:29:29 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49 via Frontend Transport; Wed, 14 Oct 2026 00:29:29 -0700
Received: from SJ2PR03CU001.outbound.protection.outlook.com (52.101.43.37) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 14 Oct 2026 00:29:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mfo/snQ7mvezabudwJ6QaWzQe7iN1AsqUcSvkPfIXalgLBp02ulwUXi0aFc6hQUnF2GDRFUbzeBd8yDVCkOClaHjjimaILSniklCS++XYCyC/4124Y302CZu7MdKG1T333nEFj7Iyv4coKZZ3cPBV7JTHkp6VGTBDl3ZW5HvCm27bSn1FhaDSjG9ArY4KkF1gKZNjShGlg4cV3bAulrDg4LePeKJQnBS2giIeHniebN3Wg/IXWcBoDRqEY1PIIkdI0B1xk64TrNbkXU0lspFPEmKM+Iy7VvvAe5/BH232vrF8TFnzIZc3LscVjpZXWUJupAOhi4B92E9HQ/YkBrUNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KqGterWmUygMunQ3ws6VOxVQhdu40k5g6r60nX/fe20=;
 b=wnP/XjvcDzdSSaqLauncxo6SsrScA64pWucFqcbC8z0ZSbMF6ttJp+5oAW02cYh/z8aD30b2IN5thBORbINEpNCDkOg0ewV+Yf3mrrfk57duMEwFtOgov694m+8+T1HA7oaTCWfv+fkYICZ3yw4HN6HtObDFouoe4BOHmWbLZRXSU8h1btLn5WkDuTfAZDbkSoVLb1WJmEihC1QOGVFi2fxM4QQjPqga4qKCMSpF8f2Aw7wmzqqTAVSjba51htYEApdHhNXGdPMIEPMSGtgmGjeCNtRC3I/deh8af7Ry83BU+0vA4gK7j/TE7kDftch0nDcrYKazRIz/9KleuKQWBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by DS0PR11MB6376.namprd11.prod.outlook.com (2603:10b6:8:c8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.12; Wed, 14 Oct
 2026 07:29:17 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0496.021; Wed, 14 Oct 2026
 07:29:16 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: Barry Song <baohua@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
CC: "ziy@nvidia.com" <ziy@nvidia.com>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "buddy.lumpkin@oracle.com"
	<buddy.lumpkin@oracle.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "kasong@tencent.com" <kasong@tencent.com>,
	"qi.zheng@linux.dev" <qi.zheng@linux.dev>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>, "david@kernel.org"
	<david@kernel.org>, "ljs@kernel.org" <ljs@kernel.org>, "liam@infradead.org"
	<liam@infradead.org>, "vbabka@kernel.org" <vbabka@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"baoquan.he@linux.dev" <baoquan.he@linux.dev>,
	"baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>
Subject: RE: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Thread-Topic: [RFC PATCH v2 0/5] mm/vmscan: adaptive multi-threaded kswapd for
 NUMA-aware reclaim
Thread-Index: AQHdWC0d+qXJ7nBgaUO4tsT9hgjACrb2b7AAgAYjP8A=
Date: Wed, 14 Oct 2026 07:29:16 +0000
Message-ID: <SJ1PR11MB6105E839E55E9B0BDE183E9D8C9D2@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <SJ1PR11MB6105E073723CFEEE8C8EDBF48C832@SJ1PR11MB6105.namprd11.prod.outlook.com>
 <cover.1791577417.git.ehab.ababneh@intel.com>
 <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
In-Reply-To: <CAGsJ_4wmSL7i4EPLWLKhDD6J=1TywBi5EYYDxp=SvOuXdmLGjg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|DS0PR11MB6376:EE_
x-ms-office365-filtering-correlation-id: ea8c1e4c-ffcd-454e-4a26-08df29c4daa5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024|23010399003|22082099003|18002099003|10067099003|38070700021|4143699003|261009223027099003|11063799006|56012099006;
x-microsoft-antispam-message-info: YoLm8e5x4xRpkseaLaslZffX1D4i126Y1BElQ7w/7mVWnNXUDLf1f8BLWZs77D+mHkWj0ESS12isSs6KsVryLt+A7xzO1mz266SIfPIxto53vTnN13qELEDHiwA3ClxHjPYY7DndnzMbWj6dggTTOknhDeB79n5igb6tBfHWu2DuQXERP7h5CbN08u81I3hMPlHPtSrkzDR/virB01tXwQRQyCoX4kyc7Lh6V8XS10k93tYVFXfpIrhe1xvefYKZ/oA2XaEH+bPFVW1zDdFABEiwCykBwPE5ypgv7gPjmrd3LOyyQ4hq/eG6ljC8CYw7KnlMj1NXlcwi/nXrTx+1jYkS/hPhQ4gs1CZ387jto9WWMKCU4z3WSGHpBMkrXQaemZyyVCKGPJkttW+uDAVUie23iW2dOlVKpyJBUulqWYmTUGNJemVANMAYid40t8fGBrERT7ZSeNNSZg0+q94dT2LM9DyY/dnUTLk2hhfNsn5jQs4JkDnhvr5xBb4FkTdQxqmV2Isy6q/iKkS5tr5P8Ve95o0zZAoaH+p7BjKGaoS8e52paWIs10YG/z5JVvBoMJqfnyvaXqkNf9UVakgWavgxYaePBmOmYKqMeppg28WKiGCpBUlRi0+WRb3SdZRhrkmAgihuKo0qMooKtSvDEE20DubIbHjvctk/FHtluuQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(23010399003)(22082099003)(18002099003)(10067099003)(38070700021)(4143699003)(261009223027099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aENrNmwveVByeU1uS0phOGFnOStpSXNSOUQ2emdjcUpmaG1nZUpBTHNvTkhN?=
 =?utf-8?B?QUNMNmVJMTZNcnM1ZHhKeTVaRWVJKzVEYkE2OVdPM01TbGlyOGxuSFRnTlZS?=
 =?utf-8?B?SjUwQzNHRThRVmJrcTI5NmVTR011K0s1b3hKK3UxNERaZ1JLd0c4MXVveG9U?=
 =?utf-8?B?Tk5xSlM3bHQ4Znc3aERsUW0xZzZPV1ZxaDUxd0NLQ1hYRkY4WTUxazNtZEhw?=
 =?utf-8?B?UHFxejQwUWlUYzVCYTY4WUNrRTI4UGp0eTdiVHVMVW9JUXN5WkE2WGRIcUJI?=
 =?utf-8?B?T0RnTnN6dy9XM2lqdkpVblRCbll0ZjFPL1kwY3NwVXBjbElJMlRaVGpGeUJL?=
 =?utf-8?B?UmVqL2xyV0hsT0RUdEF3bkRJYUxObUdwK0R3RUtTWGl4M1RpTCtaTVhsTmV6?=
 =?utf-8?B?eGcyRDVpUDQvd2RieW42clk0Q2NLc3ZtUFFNQXlYNzBwUkpON0NrYkFlcnFl?=
 =?utf-8?B?Rk5QOWpiaStlU1NmZGNCNlRZbm11elhsV0Y4SDcydW5aNnhEN3JxdW5rMmg5?=
 =?utf-8?B?UEVLWDR6QnBDVjgwOExGUC9ZNmxZWUVIT1UzcW9Vbk5XcjE4NHM2SVVySHJ2?=
 =?utf-8?B?NmtTL0VPQkJQVzJWUjZyVFA4dVNSbGRjYjZla2E2dERrNVhTQ1JWR2xyRFVO?=
 =?utf-8?B?S3hRYWtNckNueWNaeE9PWlV1TFdhZ3RjVTN0OEN6bjNDRUZVQ25Va2hHVVZu?=
 =?utf-8?B?UWZ5UVRwWGFtVk1FdW90V040VnZXQmc3a2RONm5NUGFDK2tWQVk2MHlWbjdH?=
 =?utf-8?B?eG9jUGNESTQxNXBNWWZ2cUUrbmt3OXptUktsZkFiSFVxQlJMVEVmV1BtYUJr?=
 =?utf-8?B?RWx3R1hXSTB1R3BRYllUUnpobHk3RnlNYnNiVzBiay84M203Nmc0UVZFK3BO?=
 =?utf-8?B?STBtbUpZT09FbjlIZklrQVltc1gwK1lGSWRkbzB2dmVtci94TTVxRVFCdzR6?=
 =?utf-8?B?NmluZzZFZXl2SXNsckRiTGpnZ28yTEYrMmlwRVVKbHNSOGIrWklQNkc0VC9J?=
 =?utf-8?B?RzZpLzVzMXZjcHJsUnAxZmI2OExnbGxkbEp3b3dUTjQxZDQ3SFpQNlNEOTRC?=
 =?utf-8?B?elZ1VE9zQjhjWFNiaXZ4NURFaXFSTFNWbUtYSmRKUjgrWTVxYU9JVnNuTzlT?=
 =?utf-8?B?SmdWbTZwc0hvVFdlUjBWS0lmcmQ3MEpRc3ZxMEFmbW5heitGQmpGbEhldDBu?=
 =?utf-8?B?c1B0aHppYk1JaERsQTFOaHFuY3BudzI1WTNlSnkxUWY0RUU3WVdMS20zWVpO?=
 =?utf-8?B?SkVsVWwxMnVpMjJqenBGUkJYVGY5ZGErdXZlbjdQWVBHbXBaNGFlWTgxS0ty?=
 =?utf-8?B?ZTVERmtHZXN5cmJhQlNLVWtQYlNHRytDa2ViMUJZSng1UnhrV1NGaUxCblQ1?=
 =?utf-8?B?ZHRjRThidjNLRU5POTlHZmZnZFFaVFRLYmxvK1VmUEhBNThZdjUvek4xNlJ6?=
 =?utf-8?B?TzhoaE9mU3NRY0ExZEFmSG9xcytkRU8xRGZWSnhUNHcwbThRandhQ3VHVTdn?=
 =?utf-8?B?SVo2M1BTTmVIY3dod29WS3hibk0wMm1pc0JWV2dSeExkRmRKMHN5Q0ZaSEpE?=
 =?utf-8?B?K3pkbmE2MFhWaHl4U0ZIR2M5b2pTVDRtSUgweE5uZG5BdFpscE1qTE1hUzdM?=
 =?utf-8?B?TXZSaDVRL2hXNFdSOVNWczZwS3pvKzlQZ0pWdHNCWGRrRkVCWDFHMXJhMTlV?=
 =?utf-8?B?bVJFcFgxcW9YY3lPdXd0SW1nWGxGTGIrREgzZElyOEZ1VzA0RjNBY2pCWW1k?=
 =?utf-8?B?Y3RrZVdvWmZ6UjBpdkNEcmliM1IxbnV4dnIzWldFd2loc0h6UkVpSzYrQ1Nk?=
 =?utf-8?B?OWxJRExtTDV2cTh3THhYUGlBMFhrVFNob1NzaHZ0TkxKMWRmT1ZTMzRUZURB?=
 =?utf-8?B?aXZxL2pHSlJKcHE2bDk0cXZiVVU2dHdoVDdkWEFDaUZIRU81Sms0T09XZ3NQ?=
 =?utf-8?B?Vk52ci9uZWVqRHZ6M1I5aXgwUXBvdWl2QXg1MzE0a05wZGNDeFhidlVkWXBX?=
 =?utf-8?B?Q3JBMHAxRmdpbUhBUytHUTVBTVk2N0svRTJibUNYaGRqNHRqTlJwbThjSk1V?=
 =?utf-8?B?cmxZckpZdm9LSmVoSnpQZTZnOUNJUDdNTHRaVTdGK1loTGdIa1hDeC83MFl0?=
 =?utf-8?B?R0dxdFBNQXNjeWtKWndiME5qUTlHeWFqTFdUaExCYWs1QkMxUlJGREVmTG1L?=
 =?utf-8?B?UDNQRFFZSVdiSGRPekloa0FRVDNIU3V4TU5kL0wzNVhScGZUMmVSWGREVWhr?=
 =?utf-8?B?a1R6b21UdzhLazhxWUZaYUkxRmt3Rm52R2JpRlBTWXVvS21NaHhnWEg3MHFB?=
 =?utf-8?Q?Ul14OQWVBZ+IwHkXdv?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: CSj4YW+23JUuQTG4aHBTnMCoydyjGFiaZ/YP/HH5Sv5KSUGktolv4uNeiZuMbUlMYm66z6YTfMgD77tsFvr8QIgVkEQET1cowL1jlnYmyjcpFoNt9hfVV6+vkHjou4UTXjtvNMj2oU6BT/cLAGv1mCQ3xU/u9S47VL2wizMMX6PcQ8PpqvI+DKMf6ncjzn1Gw14LLn3qa8eriq5Rzc5qAY0c+WRdGvqZFN0/l90n8a6scq5h4v7M0LuUEDpm7FgmDvTwWwKIPJkzKuxsepqbVNpPCuPgI2H7q3iFo5x1zTgklm0/ETU6wuTt5IqGRL15207uC/p6o+pYz1YQAEbDdg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea8c1e4c-ffcd-454e-4a26-08df29c4daa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2026 07:29:16.8452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iCHlAu0MyrYU7SxOWjRzPzNkjqwcjY54H9qrSjYB//H8s6N//nw2I/8O2s/OIyKt0hFtWxc82QAxIsCcChJ1Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6376
X-OriginatorOrg: intel.com
X-Stat-Signature: ocy1qxw9ibsjr3oahzs1auas5gm1wzo3
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D250A18000A
X-HE-Tag: 1791962972-206594
X-HE-Meta: U2FsdGVkX18nhqnry3k9Cvwll5SbANgB+IQjiLitlHeddX6H5YUProkm0hdnblHqxoQgfSehUZuGVVjpIljJjpYd48tG9yPhhDiEfF+esGqOUH53aO9Lmjekbo73u61pVvf64OiZkJPaAiOrG+KTu7kt7qKQxj4TLTg/u5UmceK4I36N2QN1Z8AX++y8Qe1EKv59Fwua3XD1bEfdO5lOMNVVAShLcBDV1XZzmzG/46QRbEqMTMCvP8hfgolg8Rl2L0lBXyEyQID2zJu0yhkmRPwajz0UuWdF/ZTZVDdRgiD83hkt6ArB9mFD5LHr56UYawvZxIfG3K5QlbQVKILkuuF9IqECLoq9k856iwGRDfncQaUZy7YIPLfliipwWcdD2kCEuxx2STU5st4DG8zYIZUGFc5DV6KfoTUzw6Xw++J7oXXLdKhYso06GTO3lRMLrbnLRumx6j3vR3nP0S6S4fZALY2L1iPLRTiK3wK3XZa8SOhAaWDF0doysrC3HPYFXpSdzgGOo3+VV1isvaaF42FXV+3+i4wV99UV9ybUsuttzN/hBpZLvr7nD7nCPZUF/1ZOsJH9UuMFddnNN+Uh8aPkRBf+NQRz60igp/IzNtchhlSXfonc+EIOvSP8NvMInbPbVG/DlN1+uKwLnPIbcOnsqarSupUO9Ry89TvCCJ8IhUvSGcWfQRZpOMUOwBXybZfcunnbDF2SyC6gN+h784QtBYu1oAvHw+jBP3JXWS8PNX30hK9EwtDwUxaCBUyvR/TkO/igADx17CBggmBVFi0TQqyaS5HJp12ieVo15uFIWse5v/lpyZFLx5GB4ZvtT7IKrKk57oyoXfILsPdYdue6lrfakb0ordzVeFz59BWQql4Sm8raPtaQl+pZsBa2g3S8X8oh1g6YtVxj2k00LoID3+36st4SQ2KAZnjXRYbh23Z/a/1OSr7Hw5G1gAjcR9lphIMF4pf8QQ3XnsE
 o45P+kWu
 1HkQjYpWzrEFdtMV0FFvi5oUpV/9ljLroBqf8pgbRCxLu79lsgnbNkudocV4z2dO6h3OlUUZdongRFsbKSe3KCFJIHMN4aTu68MY9FsJMCiDDsnnInBmCOqAcptGA1VSv9Au0gLWXATLI6HAGKzK4OXxl44GglWspypkcVXbDcIwpZYrEvwnTh39W9aof8bobkF/NFYbSzOwdL0dWoNJXjdXFpXOAnymjNURfwIxKTH9l4c5LSOrJ9zNuqcAnRw5NQ/2ILINNL6XBWyGR0qL14AqXIw/mKzb5RXq+7gaEgdsDMoWjE7rkEPH5pUbNUOyIDSFA84Gv2Xlyv5TXW5sFJy5ETGAKe0E6KTdoIpJGtiuv1kxV52bCcwvStz0+wwlU6czFdnaoRUomKJU6Yv1hhssU/Pi1N/tIO9WVOGu40sEQN2esn59yOvbdQitlbOB3qefFt3WLvSZZk2s8HRd0nq/neGBu8Ox2I/r3fu5giCSn0/LwEaetdZWIB7aWeBAxEcLLsg7k6dnkvt7Xx47mVaCpDIgpYoYs097IK/9OmMtbX+PDqxLoXp8PaPVcQuF9X8+GPAn0SxzcP1Biw3j2wf0aCeJf2HXC6K3vVTKUt8tg6rMKYzlhk4hDBHv3eY8/ZS6ivH0o/dN2Hg8rjHa2R7nalHRwjZOdqvKf/AvnsPqMVCzGyVO6vOcUKdlBqXSjVmC46bjnaA/2hci34WjrbTTCKS1FiyrHHoGxuHECOJF8gMijOfuze8tQ3vLefUMVesAR/iekwQ2duEU94S054RpZVxRegSrIjUjS6ISeBZf25L2GLGPHrzfuB757Z1LeXnkjjLRApqozwgR5F9al6CzeCXNsLeKXwlar7PdH3SJhRcHPUVg8M+uCa/bywQn63WpafTSm12OpSMdHPKHjPpDNVr94eHJNEgHagDa8l2yJkSG7pvs642cN9QJMU0MqMpKiTKffOWX6R/RJ3mek5aBRx69N
 TusPPO6Z
 mU8ZneL89/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksIEFsbCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBC
YXJyeSBTb25nIDxiYW9odWFAa2VybmVsLm9yZz4NCj4gU2VudDogU2F0dXJkYXksIE9jdG9iZXIg
MTAsIDIwMjYgMToxOSBBTQ0KPiBUbzogQWJhYm5laCwgRWhhYiA8ZWhhYi5hYmFibmVoQGludGVs
LmNvbT4NCj4gQ2M6IHppeUBudmlkaWEuY29tOyBsaW51eC1tbUBrdmFjay5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7DQo+IGJ1ZGR5Lmx1bXBraW5Ab3JhY2xlLmNvbTsgYWtwbUBs
aW51eC1mb3VuZGF0aW9uLm9yZzsNCj4ga2Fzb25nQHRlbmNlbnQuY29tOyBxaS56aGVuZ0BsaW51
eC5kZXY7IHNoYWtlZWwuYnV0dEBsaW51eC5kZXY7DQo+IGF4ZWxyYXNtdXNzZW5AZ29vZ2xlLmNv
bTsgeXVhbmNodUBnb29nbGUuY29tOyB3ZWl4dWdjQGdvb2dsZS5jb207DQo+IGRhdmlkQGtlcm5l
bC5vcmc7IGxqc0BrZXJuZWwub3JnOyBsaWFtQGluZnJhZGVhZC5vcmc7IHZiYWJrYUBrZXJuZWwu
b3JnOw0KPiBycHB0QGtlcm5lbC5vcmc7IHN1cmVuYkBnb29nbGUuY29tOyBtaG9ja29Ac3VzZS5j
b207DQo+IGphY2ttYW5iQGdvb2dsZS5jb207IGhhbm5lc0BjbXB4Y2hnLm9yZzsgYmFvcXVhbi5o
ZUBsaW51eC5kZXY7DQo+IGJhb2xpbi53YW5nQGxpbnV4LmFsaWJhYmEuY29tDQo+IFN1YmplY3Q6
IFJlOiBbUkZDIFBBVENIIHYyIDAvNV0gbW0vdm1zY2FuOiBhZGFwdGl2ZSBtdWx0aS10aHJlYWRl
ZCBrc3dhcGQNCj4gZm9yIE5VTUEtYXdhcmUgcmVjbGFpbQ0KPiANCj4gT24gU2F0LCBPY3QgMTAs
IDIwMjYgYXQgNDozMOKAr0FNIEVoYWIgQWJhYm5laCA8ZWhhYi5hYmFibmVoQGludGVsLmNvbT4N
Cj4gd3JvdGU6DQo+ID4NCj4gPiBUaGlzIGlzIGEgZm9sbG93LXVwIHRvIHRoZSBSRkMgZm9yIGFk
YXB0aXZlIG11bHRpLXRocmVhZGVkIGtzd2FwZCBvbg0KPiA+IE5VTUEuIEl0IGhhbmRsZXMgY29u
Y3VycmVudCBNR0xSVSBhZ2luZywgYWRqdXN0cyB3YWtldXBzIHRvIG5vZGUgQ1BVDQo+ID4gbG9h
ZCwgYW5kIHNjYWxlcyB0aGUgaG9wZWxlc3MgdGhyZXNob2xkIGZvciBtdWx0aXBsZSB3b3JrZXJz
Lg0KPiA+DQo+ID4gVW5kZXIgbWVtb3J5IHByZXNzdXJlLCBhbiBscnV2ZWMgY2FuIGVuZCB1cCB3
aXRoIG9ubHkgdHdvIE1HTFJVDQo+ID4gZ2VuZXJhdGlvbnMuIFRoYXQgbGVhdmVzIGFuIG9sZGVy
IGFuZCBhIHlvdW5nZXIgY29ob3J0LCBhIGJpdCBsaWtlDQo+ID4gaW5hY3RpdmUgYW5kIGFjdGl2
ZSBMUlUgbGlzdHMsIHRob3VnaCBNR0xSVSB0cmFja3MgYWdlIGRpZmZlcmVudGx5Lg0KPiA+DQo+
ID4gUmVnYXJkaW5nIHRoZSBjb25jZXJucyByYWlzZWQgaW4gcmV2aWV3Og0KPiA+IC0gSW4gdGhl
IHVwZGF0ZWQgQ2Fzc2FuZHJhIGNvbXBhcmlzb24sIGZvdXIga3N3YXBkIHRocmVhZHMgcmVkdWNl
ZCBwOTkNCj4gPiAgIGxhdGVuY3kgZnJvbSA2LjUgbXMgdG8gMy4zNSBtcyAoYWJvdXQgNDklKSBh
bmQgaW5jcmVhc2VkIHRocm91Z2hwdXQgYnkNCj4gPiAgIDEwLjMlLiBXZSBiZWxpZXZlIHRoZSBs
YXRlbmN5IGdhaW4gY29tZXMgZnJvbSB0aGUgcmVjbGFpbSBkZXNpZ24sDQo+ID4gICBub3QgZnJv
bSBjaGFuZ2VzIHRvIExSVSBsb2NraW5nLg0KPiA+IC0gVGhpcyBuZXdlciByZXN1bHQgY29tcGFy
ZXMgZm91ciBrc3dhcGQgdGhyZWFkcyB3aXRoIG9uZS4gVGhlIGVhcmxpZXINCj4gPiAgIDcuMyUg
dGhyb3VnaHB1dCByZXN1bHQgd2FzIG1lYXN1cmVkIHdpdGggZWlnaHQgdGhyZWFkcy4NCj4gPg0K
PiA+IFdlIGFsc28gc2F3IHBlcmlvZHMgd2l0aCB6ZXJvIGZpbGUgc2NhbnMuIFRoZSBNSU5fTlJf
R0VOUyBndWFyZCBtYXkNCj4gPiBjb250cmlidXRlOiB3aGVuIG9ubHkgdHdvIGdlbmVyYXRpb25z
IHJlbWFpbiwgaXQgbWFrZXMgc2Nhbl9mb2xpb3MoKQ0KPiA+IHJldHVybiB3aXRob3V0IHNjYW5u
aW5nIHRoZSBvbGRlc3Qgb25lLiBUaGlzIHBhdGNoIHRlc3RzIHdoZXRoZXINCj4gPiBsZXR0aW5n
IGtzd2FwZCBzY2FuIHRoYXQgZ2VuZXJhdGlvbiBoZWxwcyByZWNsYWltIHByb2dyZXNzLiBUaGUN
Cj4gPiBjdXJyZW50IHRyYWNlcyBkbyBub3QgdGllIHRoZSB6ZXJvLXNjYW4gZXZlbnRzIHRvIHRo
ZSBzYW1lIGxydXZlYywgc28NCj4gPiB0aGlzIHJlbWFpbnMgYSBoeXBvdGhlc2lzOyBtb3JlIHBl
ci1scnV2ZWMgdHJhY2luZyBpcyBuZWVkZWQgdG8NCj4gPiBjb21wYXJlIGl0IHdpdGggbG9jayBj
b250ZW50aW9uLg0KPiANCj4gSGkgRWhhYiwNCj4gDQo+IFRoZXJlIGlzIGEgcGF0Y2hzZXQgdW5k
ZXIgZGV2ZWxvcG1lbnQgYnkgS2FpcnVpLCBtZSBhbmQgZ2FvZmVpOg0KPiANCj4gaHR0cHM6Ly9n
aXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvYmFvaHVhL2xpbnV4LmdpdC9s
b2cvP2g9a2FpcnUNCj4gaV9zY2FuYmFsYW5jZV8wLjMNCj4gDQo+IHdoaWNoIGFsbG93cyByZWNs
YW1hdGlvbiBhZnRlciB3ZSBhcnJpdmUgTUlOX05SX0dFTlMuDQo+IA0KPiBUaGlzIG1pZ2h0IGZp
eCB5b3VyIHByb2JsZW0uIEhvcGVmdWxseSwgd2UgY2FuIGZpbmQgc29tZSB0aW1lIG5leHQgd2Vl
ayB0bw0KPiBzZW5kIGl0IG91dC4NCj4gDQpUaGFuayB5b3UgZm9yIHRoZSBpbmZvcm1hdGlvbi4N
Cg0KSSBjb21wYXJlZCB0aGUgdHdvIHBhdGNoIHNldHMgYW5kIGhlcmUgaXMgYSBzdW1tYXJ5IG9m
IHRoZSByZXN1bHRzOg0KDQpCYXNlbGluZTogTGludXggdjcuMy1yYzcgcGx1cyB0aGUgcmV2ZXJ0
IG9mIDZjYmRkOTcyNmZiNS4NCg0KTXkgYXBwcm9hY2g6IEFkYXB0aXZlIG11bHRpLXRocmVhZGVk
IGtzd2FwZCAoNCB0aHJlYWRzL25vZGUpLCBwbHVzIGEgcGF0Y2ggdGhhdCBhbGxvd3Mgc2Nhbm5p
bmcgcGFnZXMgd2hlbiBvbmx5IHR3byBnZW5lcmF0aW9ucyByZW1haW4uDQoNCkNvbXBhcmVkIGFn
YWluc3Q6IEthaXJ1aeKAmXMgc2Nhbi1iYWxhbmNlIHBhdGNoZXMsIGJhc2VkIG9uIHRoZSBzYW1l
IGJhc2VsaW5lOg0KaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9n
aXQvYmFvaHVhL2xpbnV4LmdpdC9sb2cvP2g9a2FpcnVpX3NjYW5iYWxhbmNlXzAuMw0KDQpCb3Ro
IGJlbmNobWFya3MgdXNlZCB0aGUgc2FtZSAxMi1taW51dGUgQ2Fzc2FuZHJhIHdvcmtsb2FkIHdp
dGggMTAwIGNsaWVudCB0aHJlYWRzLiBDb21wYXJlZCB3aXRoIHRoZSBzY2FuLWJhbGFuY2UgcnVu
LCBteSBhcHByb2FjaCBwcm9kdWNlZDoNCg0KVGhyb3VnaHB1dDogNzEsNTc3IHZzLiA2NiwyNDYg
b3AvcywgYW4gOC4wJSBpbmNyZWFzZS4NCnA5OSBsYXRlbmN5OiAzLjYgdnMuIDYuMyBtcywgYSA0
Mi45JSByZWR1Y3Rpb24uDQpQU0kgc29tZTogNDEuOSB2cy4gMTA5LjYgcywgYSA2MS44JSByZWR1
Y3Rpb24uDQpQU0kgZnVsbDogMzkuMCB2cy4gOTcuOSBzLCBhIDYwLjIlIHJlZHVjdGlvbi4NCg0K
SSBhbHNvIHN1Ym1pdHRlZCBhbiBSRkMgcmVsYXRlZCB0byByZWdyZXNzaW9uIGludHJvZHVjZSBi
eSA2Y2JkZDk3MjZmYjU6DQpodHRwczovL2xvcmUua2VybmVsLm9yZy9saW51eC1tbS8yMDI2MDkw
MTE4MDcwNC4xNjgxMDYtMS1laGFiLmFiYWJuZWhAaW50ZWwuY29tLw0KDQpJZiBwb3NzaWJsZSwg
SSB3b3VsZCBsaWtlIHRvIGdldCBzb21lIHRpcHMgZnJvbSBTaGFrZWVsIG9yIEpvaGFubmVzLg0K
DQpTaGFrZWVsIGFuZCBKb2hhbm5lcywgd2hlbiB5b3UgaGF2ZSBhIGNoYW5jZSwgSeKAmWQgYXBw
cmVjaWF0ZSB5b3VyIHRob3VnaHRzIG9uIHRoZSBwcm9wb3NlZCBwYXRjaCBzZXQuDQoNCkJlc3Qs
DQpFaGFiDQoNCj4gVGhhbmtzDQo+IEJhcnJ5DQo=

