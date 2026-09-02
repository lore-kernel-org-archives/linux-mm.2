Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D467FC624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 21:52:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96FD06B008A; Wed,  2 Sep 2026 17:52:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9480B6B008C; Wed,  2 Sep 2026 17:52:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837926B0092; Wed,  2 Sep 2026 17:52:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52CD76B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:52:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CC99A1403B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:52:16 +0000 (UTC)
X-FDA: 85170171072.20.E61C13C
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	by imf24.hostedemail.com (Postfix) with ESMTP id 51750180003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:52:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l29DnoXR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788385933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S20D7Atf1dukFTTNUIGQeDknyipx/ZQB4ibHAq5BrwQ=;
	b=WAA87Jz/zbcXsb59H/W3/VhM2r8y01fPk9dwAabuLT8qOQDBFS4KcduxoULbc7Iz1YxdUp
	mymOah6I7OkXVjnH5v7P065RTmi8zwMAw2yf1QFfkULkIOZ5v8TOE8XuoVYRJvdZsrjbP5
	S2gcgZxPcKFWfjivw1XIXMgYHCcDf9k=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=l29DnoXR;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf24.hostedemail.com: domain of ehab.ababneh@intel.com designates 192.198.163.19 as permitted sender) smtp.mailfrom=ehab.ababneh@intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788385933;
	b=ZEQmGC+z7KUrW1DUfi0qOKBQAyVknPO6KVosjZDjwrA0/9t5KmGDrdhJhIUqVEHHLVFsgU
	0wFfy2TCoW/yVRTEezWgMtJG0VXLCKXE9MlZDcOQcD4yU24ovHXr/3mgPGhJjfgTZdNl7g
	JJucsuAvNuNVyHPnQiWfCAeJjiCvzaI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788385932; x=1819921932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=S20D7Atf1dukFTTNUIGQeDknyipx/ZQB4ibHAq5BrwQ=;
  b=l29DnoXRtwXBIRxGq7wuIe+l2U9thj3qdJuxSic2LpxmKP6RqmM4v538
   BturZ6mah4pPYb4rgUFHRNu/q+OnE+wBz4VOME5viYUSY2231Rf1R/HwE
   CvrV4O6Pk7RSu3OWQ9bWk/EpQr/3btFAdby5dP33w/FBszCnO7v7wfBA/
   7NAnG+CqwplxKjiKD4KzchZqOfTtl5bNMz/dDVgWBhfvg1NkeIMYtuY+4
   QgRUdAIwYyaGVSLKN1+vNEPUx6QLakYMisWvRQR10ZG3OshoYqyzxD6Bb
   qJ+cH877zSCDjVV1/2yR6ZcJapGu14WiE/kHXymRfHl0qIgymBM+muEwC
   w==;
X-CSE-ConnectionGUID: ase5U9ZqTLKQ+AqUccCf7w==
X-CSE-MsgGUID: e/yx3SPnRLW+oecPUGzZVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11894"; a="87794527"
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="87794527"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 14:52:10 -0700
X-CSE-ConnectionGUID: ioBvgVvxRomGog5lWoaBLg==
X-CSE-MsgGUID: nkxB6+0MRI+/BV1UNsCsKg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,258,1779174000"; 
   d="scan'208";a="293036776"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 14:52:10 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 14:52:09 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46 via Frontend Transport; Wed, 2 Sep 2026 14:52:09 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 2 Sep 2026 14:52:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kperdv16HGDcl2Fkqm3Pb12kRCQlP1a/QKa9n010DfZysR63VPP0uRjaPbTZN4kJG2PjT6aGMyy6w6rpbcxlHEt7eF7kLwgyXilP7oCjbCWMCpdZG7JQ1iCIXc+k0cIWeLTOdRaVqDGksinsIP8ZayQw01dEpuHjZxjYTB2AGRDZrxUj/RuDwOnSMwhpmTUvonUZSA8EW5+L40+1uCOc7onjqiIMtpVxPJLOT4UUGLN9pdD7wHWCUuTbkdhmwKoGBPH/FKQRTQHkd/l3urXWMnd6tPQk6NgfCnwZSaWq3XqJ8BtEvmzNTyAwhY3MX25RxUbhyiif3s9zwqk0UPLv6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S20D7Atf1dukFTTNUIGQeDknyipx/ZQB4ibHAq5BrwQ=;
 b=ewqpm9qDRP6fWO1BcSKVUOHhKuuFbtrXFq565AYbqwDLdAd60YSGyPJ5zGNQNzr6aYH1f/ZP0xO9+i7NwPNhSPkcTH9a+E5lXW39S/+wFtGLC8ufHUq89LFAyaEjpfp3KHTTSNWyuI+3lpsg0CJMMul+MtyLXq9gme0Q9TAw0sBAGbVndDSyP0g3B4UROn1KHhON/gBJExiM+6kOYVNEtNWtxpz3LynoKzvj3ulJSu6BJLNJp8YG6LUEKcUrvufsfanLrWD6ECd46qGhQJ4rKxx12QWibFQnJDHuhVGgIQwP3WcwEf5tS3MW9kvUbLLhfAetnJqXc/WQbZAkCkxKUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com (2603:10b6:a03:48c::21)
 by DM4PR11MB6333.namprd11.prod.outlook.com (2603:10b6:8:b4::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.360.13; Wed, 2 Sep 2026 21:52:05 +0000
Received: from SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d]) by SJ1PR11MB6105.namprd11.prod.outlook.com
 ([fe80::28d9:5273:4572:320d%5]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 21:52:05 +0000
From: "Ababneh, Ehab" <ehab.ababneh@intel.com>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, "ryncsn@gmail.com"
	<ryncsn@gmail.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "qi.zheng@linux.dev"
	<qi.zheng@linux.dev>, "shakeel.butt@linux.dev" <shakeel.butt@linux.dev>,
	"weixugc@google.com" <weixugc@google.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "yuzhao@google.com" <yuzhao@google.com>
Subject: RE: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Topic: [RFC PATCH] mm/mglru: dynamically protect readahead fault folios
 under refault pressure
Thread-Index: AQHdOjxqaRSPWT3KQUCvH7lHJPZvdLa6CN8AgAA+YQCAAYnQ0A==
Date: Wed, 2 Sep 2026 21:52:05 +0000
Message-ID: <SJ1PR11MB61051CC2791B67C97BEB2D4B8CB72@SJ1PR11MB6105.namprd11.prod.outlook.com>
References: <apcVhWzEwkwHYjB1@KASONG-MC4>
 <20260901220430.79810-1-baohua@kernel.org>
In-Reply-To: <20260901220430.79810-1-baohua@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SJ1PR11MB6105:EE_|DM4PR11MB6333:EE_
x-ms-office365-filtering-correlation-id: c9f4999e-d904-4fa7-e498-08df093c6dbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|23010399003|56012099006|10067099003|4143699003|11063799006|22082099003|18002099003|38070700021;
x-microsoft-antispam-message-info: vYO3guHDzQz6GNh8twB+8tBgTE52dCVZdXpC1hpN0jYONx9DaJyI8r5h+JwqaX01V+CZfqLdL/BGZY4K3HlzJYATnpA0PNUGu/wOCgHUCu5Hh+ld/ATXwVFAnR4BdvVmjPeH8l5aEXA5GInYY2Cjbt6lzmHufaq6mA8gd9/F1DHP0Lvj3ZTcUHh252It361/tOjS7SaVDKboGpQ6hsyi3LBlCc1DvQG6nrTM5NYDm8aLlI03MsZhhVuHLTZ1KbgfFAHmoJDD3BIvffyUOuKQTrjDpHzIoK8DFFT02JzENndvbNb1HvCakXahmW9IsggpDBrYXOpnIFLh8zrL/tRtP9aTIs9ef6aUnv+W5nsSiqgLPk933xvcYqAE5XE7uBMV6TmaBcNTrBcyjUriaocmCdhm9aw2gBy1G+1oTpICSCnNNHOVsEzfd6zm/iIOWGu4Rj5LqsAs3IWjpHynsAZjQxh7UoFrZDI0JIB2SD+f6iZ1MhuZDJ5/Ykv3GR/XqYBJyINyP2Y4AN7v0jGaV36aNsLowSawXQbuhCw+MLtjPiAtoP1IOLf0p8FfZNqvcjUm6IKgT/g2kkqMKFIvYqJcJ32Ep69uozrCW4FzyDhFcTQ0v8Fy9rKzeDc3qyxKAGc/hky9mW/6Djm/g5TKa2SNrymVLc4vxN1DUfsYZPIJePKecCOkh+jZLCr9jdQ+NpMeya0CfCPkms94cwLDLi+xdqvbCGMKye+JKK51cu3vEyo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6105.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(23010399003)(56012099006)(10067099003)(4143699003)(11063799006)(22082099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVh6cjhuTXFWQWV6ejhxSWVYdFRGV1N0SDFaODhXOUJpclJIMzl6ZXpEeTAw?=
 =?utf-8?B?VjcxcFozZVI5QzA1S0pYd0x0UEFSMGdUK2xqOWowbGc0MU9sMmNISzVEZ0xn?=
 =?utf-8?B?VFFBL2p6Tmp6NEF0TkFEYUE1elZ1Tmg0MVA4dVJVWEQ3WUJFdmVVUFRRMHJ6?=
 =?utf-8?B?ZlV5NlpPSWtnRk0yb1lyVHdLZytuYUdnUWp6Rnh3YzZ4aDhFOGhINzRaQWhO?=
 =?utf-8?B?cVBKQkUrZlRWd0lBbTZEUytRaHhhWnFFeFEycUVDc0RSbkd4elJuaVdCSGtv?=
 =?utf-8?B?Y0IwdDV5S1c4ckFOV3R4UmROaVl4TDJuNGhMekUxYjJjTWpjM2ZDQlB5ZG9w?=
 =?utf-8?B?NHJ4QUFTaEtOQmxZMDh6SkJxWFliM2w3UmVQNkNiR3dPWXhTbnNRdis5b1Q5?=
 =?utf-8?B?dGpjL0g1L1l3S0QzNkpCYUNPbFJBZk1ncGI3VFRlUzRmNkNSSUxvSitpQ0Jq?=
 =?utf-8?B?SWt1eWFqOUlXWmU4NWs3dFRGRE9DaEhUV3dqVngyNmZqSnRTRm1NaUFmRW1k?=
 =?utf-8?B?WjlKN1pMSHp6LzRwT1ErR1diNy8zamVRV3hodlpaU0l1YkZyU0FTQlpSaG0x?=
 =?utf-8?B?TExNZWlnakhXMFFNUWFsSzFqbjhaWVhRdjQyeFR1QWlCUWRUNXhTYXorbFUv?=
 =?utf-8?B?elEzUkhFS2tSd2oybHMyV2R4RnFFdnE3cUxiaUJKVkNWZTlwK0xYVGlaY1c4?=
 =?utf-8?B?V0ZMSDh1K05TYkJieXJQcGViTTVQaDNIR0RJZGVNUEZ4WmhPL2JiOWZaWlJu?=
 =?utf-8?B?a3NlTDl3cEdmTnRmUzBTdUs2SzJ0UW9LNk5wTWUyZFBOUVZJTGFuYkdlc09l?=
 =?utf-8?B?TFpERHB2bHZMcGNQNWRuWStaVlVxckV2QTBUTkF3SUJ6V2JGZ3ducjlvdk9j?=
 =?utf-8?B?YjU0M1lCQzhHNkt6UGJsR0I5QTFid0lrd2x1VEgrZEZsNHF6YXhkMzZqOVVs?=
 =?utf-8?B?czVqTUZ4SEEzVmh6OGczaWxoU2N1V3JObWhNbWhBeXc4TUpXTnVrMHByeVFD?=
 =?utf-8?B?VGZXOFBHd2JHRzljK0p4V25VaDJMekU0U0VjdnJ5eWI1akZYcFVad3VHeDlR?=
 =?utf-8?B?Y1VPbTJFUzBpSXh0WXRRb2hDbHAvNEFMeEtPL2NIazlZMXN5a29ZVlNJSVBU?=
 =?utf-8?B?T29YZDhueHRIV3J4TUw1NmZZY2wxck9oUzl1YTlZaFRtNk1oQXlCclRkMnBz?=
 =?utf-8?B?VjgzMWpDd0l5Q2YzSTJNNHE0L0I5UDJtNjJDM1Y4dG5HbEdzN2VmRWFiR3pv?=
 =?utf-8?B?bUduMnY5cWphVDdzOWtMb0grVm05RXBvRGhFUENnMUYzaFBqaXNEZkdEenFt?=
 =?utf-8?B?MFNoRDBKRnB1QkY0MVdYaXh2bFBoaS84UVFuUHdZZ09KV0ErRzFmdE55UXJs?=
 =?utf-8?B?OG1UcFBNWFUzZmMrTDJZdmNxVzErMVlDa0tCZE5pc3gvUFR6NVk5c294KzQ5?=
 =?utf-8?B?NjdCMlhQV0cvckVteTBFaGRlUFRBZUQzTStERGV2RzNWUFpycUZ0aU5YWlEx?=
 =?utf-8?B?YWM2cDl6ZHB6UEFTY0dGVHZ0NUZnaGZjSTd0U3YrdStFQmZDcDh5UHAzejZG?=
 =?utf-8?B?bFJMN3ZwcTRNdWF2a3RRTU4weTJES1I1SHh4alpWd25ROVV5YVdRT1lCNHRO?=
 =?utf-8?B?dEtLWDhxUHd5ZmpwK0VpQWdGZEl5MzdOUFN0dnU4SzVtMzZhQk1qaFpGN3Rw?=
 =?utf-8?B?QTdPSkU2RlRwSVpBcHhQNUl3TUJRbWQxZ3EwaW9EeVkySmY3ZTd2KzJyaW4z?=
 =?utf-8?B?M1cwaTk5NDcxekxnc21iUmxJWG9ieU5GdnhxelZPT3AwSEJqRnlRdG9ReGRN?=
 =?utf-8?B?S0NRbnl6L2Myayt6R2tNdWIzeHRQQnZnZk1MeU1UKzdLZlJBaGlWdFEyaGdr?=
 =?utf-8?B?MUp5d3J6U3FrOSt5bFpTNENGdFNYeTVURlFLMlZYa2NpcG9iYS9lUDhnamRh?=
 =?utf-8?B?d000cXpxbFBIK3ZTV1hlVnNOV3A1RlJXN1czdmNqZmlEU3JhS3o4Yy9JQUJQ?=
 =?utf-8?B?OGRKS0UxellHT3dqUlc0ajVnSm5SZDNXVFM5M0pIOUs1eUJtRnNWS1V5ZmlW?=
 =?utf-8?B?KzJhUkx3VlVXQmtER1JqUTFSNmpkSDZLMyt5M3g3K01YbGdyOVh5VVZyU3dH?=
 =?utf-8?B?WnkwQ3VyZ1BiV2p6Ni93MVdIQUtnUUdsN2FZQS8zV2gvdHBueXpOc3hyL3dN?=
 =?utf-8?B?WitzNWkxejBPVG5tWWlSQW1FZHBVdEJzRXQwN2FXUFlRNjZnVGZ6YVhWb3dm?=
 =?utf-8?B?U0dsc1JEbXpVa0EzTXBnUTk5NjFCdzAvM0tZMkN2bEwxdDhMWElRbWlkSU5F?=
 =?utf-8?B?K3NLRGpMMFc3NEZ6VGdRTXBEMkRoZVNKODFLY0pzTjhHbEFIdlJOQT09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Tblx0U4p5iDyBaoLZOZWQ/RYZnCe82gVbYkkL/CJ15DolJ/vevACrAwj3Ps4uEUUff8A6LRBkZY6RT1DMxd11y4f1PGd8l4ptUGFCaLC7miVlA7ozSMMrIi32juV8N0dQUd1JhEeCeT73l1PJF/nUlOf0+0u8WxPsFxRZpB9Oc5imVFFkBbHqD6fJfcdtrZ4RJYuhCwaANKGsVhcSSv0vMZ41wI2wmF+l6DDi+ECIiEIWcnasFc/o9xqqPAQqXSKVH2AvO3nDNgFIRaC2v3FGMMoer13itwuahou/9hi+Erhgn8Wm7wfNssflVFZ4qhLBY5oTF0WiEoTGXiDMubWDQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6105.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f4999e-d904-4fa7-e498-08df093c6dbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2026 21:52:05.3318
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dHARKQl85hI9nZj1Yf5j+flVAiI1XibwSKJqVXSqwbKiZgovnKIEMAp4rU19IZOnMIFlo4XUM0O5t8GL5Qbe0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6333
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: b8xbhbh9gku8wpbwzfx1ub3jok4se8ix
X-Rspamd-Queue-Id: 51750180003
X-HE-Tag: 1788385932-282966
X-HE-Meta: U2FsdGVkX180NuOJEpFcgQ2hCMl0ZdA6taJ0AMPJzce7Jii0CGVijD7UTVFe4ZRQEEp1ocvK+1MbZEIbsFE9p1IifF7Jk+KKKDRMdpamI8vBe//jOaHmPeek9N4yYJq0XBZ//EDM3QAlyAI5lQPqlBwoiPCvdMaPj/itWz81v7oe6ZPp4EtY8W0ldEVOTndTZ6CE7P0t1tXtx/jMcEfVhaX3A0yop3K03PCkQZdNXL2gQwmwHS6knzR/PdQ7B/gJ0aq3Rd8icHqmOotAxjsAuew9Wc6JtVyWvAg9/TedQb+QEMzrthwvko1KZIjFLSmWMP6R0L0jMRlcxzyRXY11kvr4JYBpq+buSEwNDyXXTGaOnGMj/N+GLTQXJp9o8ECoUVclF3frNyIMLWZkN/RPI429KDKJk9cYiNADwcuZXQHKzeIfYhl7eel03dtf+6LhJ3EgklpQUwQWVhrB2y3cD+q2n3wlXX3lj4mvZP+UxK67qFROV9RP3hpVlSWMowfgZq4bxQK86IfkCrFjH9Yek90a1LJrU2kMBv69f6UgOqtZnri4C9XCnUM6MUgw1lvudEZFOGksOeBq4cqafRQoDu50ij9wIRkgPtOD9ZHcejzu+D4w69UEb6dPkpFk/0W9RMRZq+a0nQ8JJP0UO1AemuolGoSzsk1+R2sQw2sWX4XymqMmQ8TxhVzAMKncjV8XqVywPMXfYzYyRwWU5bV/gf5xzgQX6R+QFAFRAU4BmynPmfeB/ZeCiz2USYurLsEaW4KewQEKFcbA4QRjN7kt6/2mZL75gUeCB8Udt4rxx1D2+r5Oe9iIsEGqTb/4g9JKk0sZ0swkXIgnRnW6qluc6/N66cmG3RC0uU+g+WYWssaiFC6OxHAq557IIVyd4qiZoZvLphhQMxtsMMJaIp2yCgMURtSvCR6lLDSmZa9Q97zEiI8iclrQ+cGKH6dV0Bu405PDR2r+lpDZ6zxobTJ
 GrrutGEx
 Wk6/33e2kdcDUE1ds0lk7ci1/QLvmqJvoKUBQHz9I1NXXYMcGq67QZznynoSWhSMoB3qCUR+2CEIUORbJ+BU7pq7kPIikW16/v+UaAddxSsgjGhNe7tcRK16PT3RvJ6leM1oRMFjY22JHMX/g+e58xADHFb2CHhd5kP06W7xGo0VNuW78CoNO8BnotkLSK3CfbSuUcg3e/v5qooYfhOtG4GKLtbXONMJ469yP//3DBb6oaBsmeWTyrUoqbggTSvv+kNVVSGV+dZdy1b2T8k/lA9iroMPJq2BaVn8m3qOKoLkrd4cXaDrWc1zgm1Qj/vGdsYg5gEcNPBJNEOPOsQ+JqMeB2epBZRduO1MSE3J+9NOfKGYp7p1sV5oI8wqUDOmMQdklEgtRbYJYox7RhRhXmysPpkFfqQIS0T25Y2mR9clq0362cmbd4XsaDK6A96jEF6LyEYAqHKpLp+N2+BDsEZ7yjM/NroevENSfKQsmoAYZaHLl58DIGS59vyCES2htlLXFtniiZ/tJmcoMSL/abuUwIaorI3W+X6TqkrOVZfHYv2z6W8pTPwR953qgyqVM2e8WJZ2TmU8gylDYsu2nSaAUZpIgZDW/6oIk2OIipjN1l5CzwTsAkRyn+FuTEcRVO/kplhj0uTkJ/Ag2fSiEpOtQCJ2FUXDEzqekupTIWm+o3mNUp+fCdFY/fYHzmbdMCg8v7lYUJwwf2+X59c2ZMrbGOBtTzBun+UXlb7PI56i5faHQY+ExNim2ZKa3FispXw1w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

SGkgQmFycnksIEthaXJ1aSwNCg0KVGhhbmtzIGZvciB0aGUgZmVlZGJhY2sgYW5kIHN1Z2dlc3Rp
b25zLg0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEJhcnJ5IFNvbmcg
KFhpYW9taSkgPGJhb2h1YUBrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBTZXB0ZW1iZXIg
MSwgMjAyNiAzOjA1IFBNDQo+IFRvOiByeW5jc25AZ21haWwuY29tOyBBYmFibmVoLCBFaGFiIDxl
aGFiLmFiYWJuZWhAaW50ZWwuY29tPg0KPiBDYzogYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsg
YXhlbHJhc211c3NlbkBnb29nbGUuY29tOw0KPiBiYW9odWFAa2VybmVsLm9yZzsga2Fzb25nQHRl
bmNlbnQuY29tOyBsYW5jZS55YW5nQGxpbnV4LmRldjsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7IGxpbnV4LW1tQGt2YWNrLm9yZzsgcWkuemhlbmdAbGludXguZGV2Ow0KPiBzaGFr
ZWVsLmJ1dHRAbGludXguZGV2OyB3ZWl4dWdjQGdvb2dsZS5jb207IHl1YW5jaHVAZ29vZ2xlLmNv
bTsNCj4geXV6aGFvQGdvb2dsZS5jb20NCj4gU3ViamVjdDogUmU6IFtSRkMgUEFUQ0hdIG1tL21n
bHJ1OiBkeW5hbWljYWxseSBwcm90ZWN0IHJlYWRhaGVhZCBmYXVsdA0KPiBmb2xpb3MgdW5kZXIg
cmVmYXVsdCBwcmVzc3VyZQ0KPiANCj4gT24gV2VkLCBTZXAgMiwgMjAyNiBhdCAyOjIx4oCvQU0g
S2FpcnVpIFNvbmcgPHJ5bmNzbkBnbWFpbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gT24gVHVlLCBT
ZXAgMDEsIDIwMjYgYXQgMTE6MDY6NDNBTSArMDgwMCwgRWhhYiBBYmFibmVoIHdyb3RlOg0KPiA+
ID4gQ29tbWl0IDZjYmRkOTcyNmZiNSAoIm1tL21nbHJ1OiB1c2UgZm9saW9fbWFya19hY2Nlc3Nl
ZCB0byByZXBsYWNlDQo+ID4gPiBmb2xpb19zZXRfYWN0aXZlIikgaW50cm9kdWNlZCBhIHJlZ3Jl
c3Npb24gZm9yIHdvcmtsb2FkcyB0aGF0IHJlbHkNCj4gPiA+IG9uIHJlYWRhaGVhZCB0byBrZWVw
IHNlcXVlbnRpYWwgZmlsZSBhY2Nlc3MgZWZmaWNpZW50Lg0KPiA+ID4NCj4gPiA+IFRoZSBwcm9i
bGVtIGlzIHRoYXQgTUdMUlUgY2FuIHBsYWNlIGZhdWx0LXBhdGggZmlsZSBmb2xpb3MgaW4gb2xk
ZXINCj4gPiA+IGdlbmVyYXRpb25zLCBzbyBtZW1vcnkgcHJlc3N1cmUgY2FuIHJlY2xhaW0gcmVh
ZGFoZWFkIGZvbGlvcyBiZWZvcmUNCj4gPiA+IHRoZSB3b3JrbG9hZCB0b3VjaGVzIHRoZW0uIElu
IG91ciBDYXNzYW5kcmEgcmVhZCBiZW5jaG1hcmssIHRoaXMNCj4gPiA+IHJhaXNlZCBwOTkgbGF0
ZW5jeSB0byBhYm91dCA5LjItOS41IG1zIGFuZCBjdXQgdGhyb3VnaHB1dCB0byByb3VnaGx5DQo+
ID4gPiA0MS44ay00My42ayBvcC9zOyB0aGUgcmV2ZXJ0IHJlc3RvcmVkIHRoZSB3b3JrbG9hZCB0
byBhYm91dCA1LjUtNS42DQo+ID4gPiBtcyBhbmQgNTEuOWstNTMuMWsgb3Avcy4NCj4gPiA+DQo+
ID4gPiBSZWFkYWhlYWQgaXMgaW1wb3J0YW50IGZvciBzZXF1ZW50aWFsIEkvTyBhbmQgbW1hcCBz
Y2FucywgYnV0IGl0DQo+ID4gPiBzaG91bGQgbm90IGJlIHJldGFpbmVkIHdoZW4gdGhlIHdvcmts
b2FkIGRvZXMgbm90IGJlbmVmaXQgZnJvbSBpdC4NCj4gPiA+IFRoZSBnb2FsIGlzIHRvIGtlZXAg
dGhlIG9wdGltaXphdGlvbiB3aXRob3V0IGtlZXBpbmcgcmVhZGFoZWFkIHBhZ2VzIGFsaXZlDQo+
IGZvcmV2ZXIuDQo+ID4gPg0KPiA+ID4gVGhpcyBwYXRjaCBwcm92aWRlcyBhIG1pZGRsZSBncm91
bmQ6IGtlZXAgdGhlIG9yaWdpbmFsIGJlaGF2aW9yIGJ5DQo+ID4gPiBkZWZhdWx0LCBidXQgdGVt
cG9yYXJpbHkgcHJvdGVjdCBmYXVsdC1wYXRoIGZpbGUgZm9saW9zIHdoZW4NCj4gPiA+IHJlcGVh
dGVkIGZpbGUgcmVmYXVsdHMgc2hvdyB0aGF0IHJlYWRhaGVhZCBpcyBhY3R1YWxseSBoZWxwaW5n
Lg0KPiA+ID4NCj4gPiA+IFRoZSBtZWNoYW5pc20gaXMgZHluYW1pYyBhbmQgc2VsZi10dW5pbmc6
DQo+ID4gPg0KPiA+ID4gLSBhZGQgYSBwZXItbHJ1dmVjIHJlYWRhaGVhZC9yZWZhdWx0IGNyZWRp
dA0KPiA+ID4gLSBhY2N1bXVsYXRlIGNyZWRpdCBvbiBmaWxlIHJlZmF1bHRzIGluIHRoZSBNR0xS
VSByZWZhdWx0IHBhdGgNCj4gPiA+IC0gY29uc3VtZSBjcmVkaXQgaW4gZm9saW9fYWRkX2xydSgp
IGZvciBmYXVsdC1wYXRoIGZpbGUgZm9saW9zDQo+ID4gPiAtIGtlZXAgdGhlIGZvbGlvIGFjdGl2
ZSB3aGlsZSBjcmVkaXQgaXMgYXZhaWxhYmxlLCBhbmQgb3RoZXJ3aXNlIGxldA0KPiA+ID4gdGhl
DQo+ID4gPiDCoCBvcmlnaW5hbCBiZWhhdmlvciBzdGFuZA0KPiA+ID4gLSBkZWNheS9yZXNldCB0
aGUgY3JlZGl0IGFzIGdlbmVyYXRpb25zIGFkdmFuY2UgYW5kIHdoZW4gYW4gbHJ1dmVjDQo+ID4g
PiBpcw0KPiA+ID4gwqAgaW5pdGlhbGl6ZWQNCj4gPiA+DQo+ID4gPiBUaGlzIG1lYW5zIHdlIG9u
bHkgcHJvdGVjdCBmYXVsdC1wYXRoIGZpbGUgZm9saW9zIHdoZW4gcmVmYXVsdA0KPiA+ID4gcHJl
c3N1cmUgc2hvd3MgdGhhdCB0aGUgd29ya2xvYWQgaXMgYWN0aXZlbHkgYmVuZWZpdGluZyBmcm9t
DQo+ID4gPiByZWFkYWhlYWQuIElmIHRoZSB3b3JrbG9hZCBkb2VzIG5vdCBuZWVkIHRoYXQgcHJv
dGVjdGlvbiwgdGhlDQo+ID4gPiBvcmlnaW5hbCBvcHRpbWl6YXRpb24gcmVtYWlucyBpbnRhY3Qg
YW5kIHdlIGRvIG5vdCBrZWVwIHJlYWRhaGVhZCBwYWdlcw0KPiBhcm91bmQgdW5uZWNlc3Nhcmls
eS4NCj4gPiA+DQo+ID4gPiBCZW5jaG1hcmsgcmVzdWx0cyBmb3IgdGhlIENhc3NhbmRyYSByZWFk
IHdvcmtsb2FkDQo+ID4gPiAoNCBub2RlcywgNzIwcywgMTAwIHJlYWRlcnMpOg0KPiA+ID4NCj4g
PiA+IC0gd2l0aCBjb21taXQgNmNiZGQ5NzI2ZmI1ICgibW0vbWdscnU6IHVzZSBmb2xpb19tYXJr
X2FjY2Vzc2VkIHRvDQo+ID4gPiDCoCByZXBsYWNlIGZvbGlvX3NldF9hY3RpdmUiKToNCj4gPiA+
IMKgIHA5OSB+OS4yLTkuNSBtcywgdGhyb3VnaHB1dCB+NDEuOGstNDMuNmsgb3Avcw0KPiA+ID4g
LSB3aXRoIHJldmVydCBvZiBjb21taXQgNmNiZGQ5NzI2ZmI1ICgibW0vbWdscnU6IHVzZQ0KPiA+
ID4gZm9saW9fbWFya19hY2Nlc3NlZCB0bw0KPiA+ID4gwqAgcmVwbGFjZSBmb2xpb19zZXRfYWN0
aXZlIik6DQo+ID4gPiDCoCBwOTkgfjUuNS01LjYgbXMsIHRocm91Z2hwdXQgfjUxLjlrLTUzLjFr
IG9wL3MNCj4gPiA+IC0gd2l0aCB0aGlzIGZpeDogcDk5IH41LjggbXMsIHRocm91Z2hwdXQgfjUx
LjlrLTUyLjdrIG9wL3MNCj4gPg0KPiBbLi4uXQ0KPiA+DQo+ID4gSnVzdCBhbiBpZGVhLiBGb3Ig
YW4gc2hvcnQgdGVybSBhbmQgZWFzeSBmaXgsIHdoYXQgaWYgd2Ugc2ltcGx5IHJldmVydA0KPiA+
IHRoYW4sIHRoZW4gb25seSBwcm90ZWN0IGluX2ZhdWx0ICYmIGZvbGlvX3Rlc3Rfc3dhcGJhY2tl
ZCBmb2xpb3Mgd2l0aA0KPiA+IFBHX2FjdGl2ZT8NCj4gDQo+IEhpIEVoYWIgYW5kIEthaXJ1aSwN
Cj4gDQo+IFRoYW5rcyB2ZXJ5IG11Y2ggZm9yIHlvdXIgcmVwb3J0cyBhbmQgZGlzY3Vzc2lvbi4N
Cj4gDQo+IEknbSBub3QgcXVpdGUgc3VyZSB3ZSB3YW50IHRvIHJldmVydCBpdCBlbnRpcmVseSwg
YXMgdGhhdCB3b3VsZCBpbW1lZGlhdGVseQ0KPiByZWdyZXNzIHRoZSB3b3JrbG9hZHMgaW1wcm92
ZWQgYnkgdGhlIGNvbW1pdCwgc3VjaCBhcyB0aGUga2VybmVsIGJ1aWxkLg0KPiBBbHNvLCBmb3Ig
ZXhhbXBsZSwgS2FpcnVpJ3MgY292ZXIgbGV0dGVyIG1lbnRpb25lZCB0aGUgTGV2ZWxEQiBiZW5j
aG1hcms6DQo+IMKgIkkgYWxzbyByZXRlc3RlZCB0aGUgTGV2ZWxEQiBiZW5jaG1hcmsgZnJvbSB0
aGUgY2FjaGVfZXh0IHBhcGVyIFs1XS4NCj4gSW50ZXJlc3RpbmdseSwgbWFpbmxpbmUgTUdMUlUg
YWxyZWFkeSBiZWF0cyBDTFJVIG9uIHRoaXMgb25lIGFmdGVyIGEgcmVjZW50DQo+IGNoYW5nZSBp
biBscnVfZ2VuX2ZvbGlvX3NlcSB0aGF0IGJ1bXBzIG5ldyBmb2xpb3Mgd2l0aCByZWZzID09IDEg
dG8gdGhlDQo+IHNlY29uZC1vbGRlc3QgZ2VuZXJhdGlvbi4iDQo+IA0KPiBJIGd1ZXNzIHdlIGNv
dWxkIGluc3RlYWQgdHJ5IHRvIG1pdGlnYXRlIHRoZSBjYXNlcyB3aGVyZSBzb21lIHdvcmtsb2Fk
cyBhcmUNCj4gbmVnYXRpdmVseSBhZmZlY3RlZCB3aGlsZSBwcmVzZXJ2aW5nIHRoZSBvcmlnaW5h
bCBpbnRlbnRpb24uIERvZXMgdGhlIGZpeCBiZWxvdw0KPiBhZGRyZXNzIGJvdGggb2YgeW91ciBj
YXNlcywgb3IgaXMgRWhhYidzIGNhc2UgYWN0dWFsbHkgZGlmZmVyZW50IGZyb20gS2FpcnVpJ3M/
DQo+IChUaGUga2VybmVsLWJ1aWxkIHRlc3Qgb24gbXkgbWFjaGluZSBsb29rcyBxdWl0ZSBwb3Np
dGl2ZS4gSXQgbm90IG9ubHkNCj4gcHJlc2VydmVzIHRoZSBvcmlnaW5hbCBvcHRpbWl6YXRpb24s
IGJ1dCBldmVuIHByb3ZpZGVzIGZ1cnRoZXIgZ2FpbnMuKQ0KPiANCg0KSSBhZ3JlZSB0aGF0IHJl
dmVydGluZyB0aGUgY29tbWl0IHRoYXQgY2F1c2VkIHRoZSByZWdyZXNzaW9uIGlzIG5vdCB0aGUN
Cm9wdGltYWwgcGF0aC4gSSBleHBlY3QgdGhlcmUgYXJlIG1hbnkgd29ya2xvYWRzIGFuZCBzY2Vu
YXJpb3MgdGhhdA0KYmVuZWZpdCBmcm9tIHRoZSBiZWhhdmlvciBpbnRyb2R1Y2VkIGJ5IHRoYXQg
Y29tbWl0LCBzbyByZXZlcnRpbmcgaXQNCmNvdWxkIHVubmVjZXNzYXJpbHkgcmVncmVzcyB0aG9z
ZSB3b3JrbG9hZHMuDQoNCkkgd2lsbCBydW4gdGhlIENhc3NhbmRyYSBiZW5jaG1hcmsgd2l0aCBL
YWlydWkncyBNR0xSVS1GRyBwYXRjaGVzIHRvIHNlZQ0Kd2hldGhlciB0aGV5IGFkZHJlc3MgdGhl
IGlzc3VlIEkgYW0gc2VlaW5nLiBJIHdpbGwgc2VuZCB0aGUgcmVzdWx0cyB3aGVuDQp0aGV5IGFy
ZSByZWFkeS4NCg0KVGhhbmtzLA0KRWhhYg0KDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L21tX2lubGluZS5oIGIvaW5jbHVkZS9saW51eC9tbV9pbmxpbmUuaCBpbmRleA0KPiA2MjFjODY1
M2Q4ZjcuLjkxMzk2Yzc5NmEzNCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9tbV9pbmxp
bmUuaA0KPiArKysgYi9pbmNsdWRlL2xpbnV4L21tX2lubGluZS5oDQo+IEBAIC0yMzksNyArMjM5
LDggQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGxydV9nZW5fZm9saW9fc2VxKGNvbnN0
DQo+IHN0cnVjdCBscnV2ZWMgKmxydXZlYywNCj4gIAkgKiB8PC0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0gTUFYX05SX0dFTlMgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLT58DQo+ICAJ
ICovDQo+ICAJaWYgKGZvbGlvX3Rlc3RfYWN0aXZlKGZvbGlvKSkNCj4gLQkJZ2VuID0gTUlOX05S
X0dFTlMgLSBmb2xpb190ZXN0X3dvcmtpbmdzZXQoZm9saW8pOw0KPiArCQlnZW4gPSBNSU5fTlJf
R0VOUyAtIGZvbGlvX3Rlc3Rfd29ya2luZ3NldChmb2xpbykgKw0KPiArCQkgICAgICAodHlwZSA/
ICFmb2xpb190ZXN0X3dvcmtpbmdzZXQoZm9saW8pIDogMCk7DQo+ICAJZWxzZSBpZiAocmVjbGFp
bWluZykNCj4gIAkJZ2VuID0gTUFYX05SX0dFTlM7DQo+ICAJZWxzZSBpZiAoKCFmb2xpb19pc19m
aWxlX2xydShmb2xpbykgJiYgIWZvbGlvX3Rlc3Rfc3dhcGNhY2hlKGZvbGlvKSkgfHwNCj4gQEAg
LTI0Nyw3ICsyNDgsNyBAQCBzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGxvbmcgbHJ1X2dlbl9mb2xp
b19zZXEoY29uc3QNCj4gc3RydWN0IGxydXZlYyAqbHJ1dmVjLA0KPiAgCQkgIChmb2xpb190ZXN0
X2RpcnR5KGZvbGlvKSB8fCBmb2xpb190ZXN0X3dyaXRlYmFjayhmb2xpbykpKSkNCj4gIAkJZ2Vu
ID0gTUlOX05SX0dFTlM7DQo+ICAJZWxzZQ0KPiAtCQlnZW4gPSBNQVhfTlJfR0VOUyAtIChmb2xp
b190ZXN0X3dvcmtpbmdzZXQoZm9saW8pIHx8DQo+IGZvbGlvX3Rlc3RfcmVmZXJlbmNlZChmb2xp
bykpOw0KPiArCQlnZW4gPSBNQVhfTlJfR0VOUyAtIGZvbGlvX3Rlc3Rfd29ya2luZ3NldChmb2xp
byk7DQo+IA0KPiAgCXJldHVybiBtYXgoUkVBRF9PTkNFKGxydWdlbi0+bWF4X3NlcSkgLSBnZW4g
KyAxLA0KPiBSRUFEX09OQ0UobHJ1Z2VuLT5taW5fc2VxW3R5cGVdKSk7DQo+ICB9DQo+IGRpZmYg
LS1naXQgYS9tbS9mb2xpby5jIGIvbW0vZm9saW8uYw0KPiBpbmRleCBjMDJkY2VhOWMwM2MuLjJm
ZDgzNWIzYjUwYyAxMDA2NDQNCj4gLS0tIGEvbW0vZm9saW8uYw0KPiArKysgYi9tbS9mb2xpby5j
DQo+IEBAIC00NzAsMjAgKzQ3MCwxMCBAQCB2b2lkIGZvbGlvX2FkZF9scnUoc3RydWN0IGZvbGlv
ICpmb2xpbykNCj4gIAkJCWZvbGlvX3Rlc3RfdW5ldmljdGFibGUoZm9saW8pLCBmb2xpbyk7DQo+
ICAJVk1fQlVHX09OX0ZPTElPKGZvbGlvX3Rlc3RfbHJ1KGZvbGlvKSwgZm9saW8pOw0KPiANCj4g
LQkvKg0KPiAtCSAqIEZvciByZWZhdWx0ZWQgd29ya2luZ3NldCBmb2xpb3MsIHNldCBQR19hY3Rp
dmUgc28gdGhleQ0KPiAtCSAqIGNhbiBiZSBhZGRlZCB0byBhY3RpdmUgZ2VuZXJhdGlvbnMuDQo+
IC0JICogRm9yIHByZWZhdWx0ZWQgZmlsZSBmb2xpb3MsIGZvbGlvX21hcmtfYWNjZXNzZWQoKSBz
ZXRzDQo+IC0JICogUEdfcmVmZXJlbmNlZCBzbyBscnVfZ2VuX2ZvbGlvX3NlcSgpIHBsYWNlcyB0
aGVtIGludG8NCj4gLQkgKiB0aGUgc2Vjb25kIG9sZGVzdCBnZW5lcmF0aW9uLg0KPiAtCSAqLw0K
PiArCS8qIHNlZSB0aGUgY29tbWVudCBpbiBscnVfZ2VuX2ZvbGlvX3NlcSgpICovDQo+ICAJaWYg
KGxydV9nZW5fZW5hYmxlZCgpICYmICFmb2xpb190ZXN0X3VuZXZpY3RhYmxlKGZvbGlvKSAmJg0K
PiAtCSAgICBscnVfZ2VuX2luX2ZhdWx0KCkgJiYgIShjdXJyZW50LT5mbGFncyAmIFBGX01FTUFM
TE9DKSkgew0KPiAtCQlpZiAoZm9saW9fdGVzdF93b3JraW5nc2V0KGZvbGlvKSkNCj4gLQkJCWZv
bGlvX3NldF9hY3RpdmUoZm9saW8pOw0KPiAtCQllbHNlIGlmICghZm9saW9fdGVzdF9yZWZlcmVu
Y2VkKGZvbGlvKSkNCj4gLQkJCWZvbGlvX21hcmtfYWNjZXNzZWQoZm9saW8pOw0KPiAtCX0NCj4g
KwkgICAgbHJ1X2dlbl9pbl9mYXVsdCgpICYmICEoY3VycmVudC0+ZmxhZ3MgJiBQRl9NRU1BTExP
QykpDQo+ICsJCWZvbGlvX3NldF9hY3RpdmUoZm9saW8pOw0KPiANCj4gIAlmb2xpb19iYXRjaF9h
ZGRfYW5kX21vdmUoZm9saW8sIGxydV9hZGQpOyAgfSBkaWZmIC0tZ2l0DQo+IGEvbW0vdm1zY2Fu
LmMgYi9tbS92bXNjYW4uYyBpbmRleCBmMTE0OTFlZTllZDUuLmFhNTAwYWU5MzcxYQ0KPiAxMDA2
NDQNCj4gLS0tIGEvbW0vdm1zY2FuLmMNCj4gKysrIGIvbW0vdm1zY2FuLmMNCj4gQEAgLTg1MSwx
MSArODUxLDcgQEAgc3RhdGljIGJvb2wgbHJ1X2dlbl9zZXRfcmVmcyhzdHJ1Y3QgZm9saW8gKmZv
bGlvLCBjb25zdA0KPiB2bWFfZmxhZ3NfdCAqdm1hX2ZsYWdzKQ0KPiAgCQlyZXR1cm4gZmFsc2U7
DQo+ICAJfQ0KPiANCj4gLQkvKiBQcm9tb3RlIG9uIHNlY29uZCBhY2Nlc3MgKi8NCj4gLQlpZiAo
Zm9saW9fbHJ1X3JlZnMoZm9saW8pID4gMSkNCj4gLQkJc2V0X21hc2tfYml0cygmZm9saW8tPmZs
YWdzLmYsIExSVV9SRUZTX0ZMQUdTLA0KPiBCSVQoUEdfd29ya2luZ3NldCkpOw0KPiAtCWVsc2UN
Cj4gLQkJZm9saW9fbWFya19hY2Nlc3NlZChmb2xpbyk7DQo+ICsJc2V0X21hc2tfYml0cygmZm9s
aW8tPmZsYWdzLmYsIExSVV9SRUZTX0ZMQUdTLCBCSVQoUEdfd29ya2luZ3NldCkpOw0KPiAgCXJl
dHVybiB0cnVlOw0KPiAgfQ0KPiAgI2Vsc2UNCj4gZGlmZiAtLWdpdCBhL21tL3dvcmtpbmdzZXQu
YyBiL21tL3dvcmtpbmdzZXQuYyBpbmRleA0KPiA3YWMyYjg4YzgwYWUuLmE3OWI3M2VlOTc2MiAx
MDA2NDQNCj4gLS0tIGEvbW0vd29ya2luZ3NldC5jDQo+ICsrKyBiL21tL3dvcmtpbmdzZXQuYw0K
PiBAQCAtMzE5LDEzICszMTksMTEgQEAgc3RhdGljIHZvaWQgbHJ1X2dlbl9yZWZhdWx0KHN0cnVj
dCBmb2xpbyAqZm9saW8sIHZvaWQNCj4gKnNoYWRvdykNCj4gDQo+ICAJYXRvbWljX2xvbmdfYWRk
KGRlbHRhLCAmbHJ1Z2VuLT5yZWZhdWx0ZWRbaGlzdF1bdHlwZV1bdGllcl0pOw0KPiANCj4gKwkv
KiBzZWUgZm9saW9fYWRkX2xydSgpIHdoZXJlIGZvbGlvX3NldF9hY3RpdmUoKSB3aWxsIGJlIGNh
bGxlZCAqLw0KPiArCWlmIChscnVfZ2VuX2luX2ZhdWx0KCkpDQo+ICsJCW1vZF9scnV2ZWNfc3Rh
dGUobHJ1dmVjLCBXT1JLSU5HU0VUX0FDVElWQVRFX0JBU0UgKw0KPiB0eXBlLCBkZWx0YSk7DQo+
ICsNCj4gIAlpZiAod29ya2luZ3NldCkgew0KPiAtCQkvKg0KPiAtCQkgKiBzZWUgZm9saW9fYWRk
X2xydSgpLCB3aGVyZSBmb2xpb19zZXRfYWN0aXZlKCkgaXMNCj4gLQkJICogY2FsbGVkIGZvciB3
b3JraW5nc2V0IGZvbGlvcw0KPiAtCQkgKi8NCj4gLQkJaWYgKGxydV9nZW5faW5fZmF1bHQoKSkN
Cj4gLQkJCW1vZF9scnV2ZWNfc3RhdGUobHJ1dmVjLA0KPiBXT1JLSU5HU0VUX0FDVElWQVRFX0JB
U0UgKyB0eXBlLCBkZWx0YSk7DQo+ICAJCWZvbGlvX3NldF93b3JraW5nc2V0KGZvbGlvKTsNCj4g
IAkJbW9kX2xydXZlY19zdGF0ZShscnV2ZWMsIFdPUktJTkdTRVRfUkVTVE9SRV9CQVNFICsNCj4g
dHlwZSwgZGVsdGEpOw0KPiAgCX0gZWxzZQ0KPiAtLQ0KPiAyLjM0LjENCg==

