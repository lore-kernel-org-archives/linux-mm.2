Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C3A1C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 02:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6846E6B007B; Thu,  6 Aug 2026 22:43:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60E916B0088; Thu,  6 Aug 2026 22:43:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4606D6B008A; Thu,  6 Aug 2026 22:43:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E58C6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:43:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBD091A01F8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:43:51 +0000 (UTC)
X-FDA: 85072928262.08.F027627
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf31.hostedemail.com (Postfix) with ESMTP id 26FBF20003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 02:43:47 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=FKpWIJCH;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf31.hostedemail.com: domain of "prvs=672924bdb=graf@amazon.de" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=672924bdb=graf@amazon.de";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786070628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3ojny2LFkqiWICBFF5/RLe7dnMYtrPfAHdh0CKXufE=;
	b=OMvJgq9E3G0h4QzfTRVV38W1ZneqWrLCoC+wyl94y/fSAjZgEoKp3d/9MiijELKGZgV0e1
	ebCqFxM1eSyE7KTs6/QdURv8G1iMJqo9ZMchOHHlwpzSdoL8H+YuOxA8cvpkuDRfK742ep
	v+BTO1rQl0umCDI+vIsVIT2cxH7I28E=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=FKpWIJCH;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf31.hostedemail.com: domain of "prvs=672924bdb=graf@amazon.de" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=672924bdb=graf@amazon.de";
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786070628;
	b=MSuR84B/dilwcs7qE9lf6NiLmj/0DMR/VR7AojIIaKFM4TzBUyKaFLTBLGh+VTHPAZ0VnL
	k6vhICMmU8SkLR+ZemZr4BKrzZO6/8r005GiYaSu4WhEnYQKqXdKVnHSvsrGWmm9n+39CN
	jusiOevqEqLRhzIQxVZY1Qujce8kmds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1786070628; x=1817606628;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Q3ojny2LFkqiWICBFF5/RLe7dnMYtrPfAHdh0CKXufE=;
  b=FKpWIJCHPoLgLysQ5CmJJGxDSY23ajz7Z+iKn1U4sD5xRUTKxNOCNLES
   6zeqpX3vK62aGqSfRONTviAiJDbOE1IcTG47MztL4xWwj87YIC/axk9OO
   Xdg/oWUCmTSFSOO8ull5rQDwFHF1rFAULOD3O0qWrROONy0HR4BzrT3H6
   ciyk2K9ru1D1kMYId+xGSLV+DMwBv+rY+RA+SD4YFmJnI5CbmL78ksQ55
   LOPxpaUEiWxiZNrfr71PzaJT490z54F2HPwa5zuSrZ4R6Dp5vj3Fj5HGu
   rAncSNcAXj4tENGcr6MCIXytJKNJ4hrPO44EP+LinVjM2rqdH/O/SGGRN
   A==;
X-CSE-ConnectionGUID: jz2nefeaSeGAIrQPi60syg==
X-CSE-MsgGUID: a7sty2JKTcKy4NmUswQ7DQ==
X-IronPort-AV: E=Sophos;i="6.25,209,1779148800"; 
   d="scan'208";a="17391947"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2026 02:43:44 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:24619]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.13.91:2525] with esmtp (Farcaster)
 id 383c0c13-db1a-4062-8476-0cbddfda8925; Fri, 7 Aug 2026 02:43:44 +0000 (UTC)
X-Farcaster-Flow-ID: 383c0c13-db1a-4062-8476-0cbddfda8925
Received: from EX19EXOEUA002.ant.amazon.com (10.252.50.139) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 7 Aug 2026 02:43:43 +0000
Received: from EX19EXOEUA001.ant.amazon.com (10.252.50.110) by
 EX19EXOEUA002.ant.amazon.com (10.252.50.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Fri, 7 Aug 2026 02:43:43 +0000
Received: from FR5P281CU006.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUA001.ant.amazon.com (10.252.50.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Fri, 7 Aug 2026 02:43:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v/Jj76lf6LjC0AIlhokbLGNjMzJHpUYh1CPywfaDB6eC/n5MfL03PB4bxHcutOhr1xFUYcvhwH/7wzfGBVK7iqUBO4XjtQ41GsJ9KnbTiBj6RQ5LPwVL/v7+iEPic+UNqIV42VUCcGBi45fVFaORXZh5cxJ4kMQjqEA2TYKw++DmFAW7jDrtM3oNP2GqqCEW+3srVDsXvFIcEj0xbLnohsPC8tlw9zbICEODrZ0c4naulX1jZKH2BOYETprz2HZZqs/4JXYCsiwLl45gAlKUayC4C6IpKvsb0MbcX4aNXBdoeS6538yyFIBfbUNuUIMAkScMeGmgjCaYYKCtNZDrvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q3ojny2LFkqiWICBFF5/RLe7dnMYtrPfAHdh0CKXufE=;
 b=a+6kLJAEzVNChwQay/eQTy6BejsWGONEJhKFjO8co18kT5zTWTPqPVKPCb90gepHNmnAjEal04ftuSmsCk6vjw1NQIHlxvHU1SwXaZGg4RlajgGsuKdDe/eFQS9xx3bOswFaBKmy2Mk/j415o++sz5PTi8hCB82CkjMY3nk/gy5a6AtBktYRmFlW+kNJ5ww4VRSRd+LW6wZt1vASs3YW2YRDdTUHLw1zd6hNeNgMo98SZn2dzr2RuEeuHm8X/TLSPsrCb2i4XZ7jUtkxsGjRim+efp3TH7kPdysuVPlfUec1sbhjUqe3yF+o/PbdljWAKFpyU7qBYE88+lcn6mcbBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:103::21)
 by FR3PPF22F263B2B.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d18:2::11d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 02:43:35 +0000
Received: from BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6854:a8a7:80a6:2c71]) by BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
 ([fe80::6854:a8a7:80a6:2c71%6]) with mapi id 15.21.0292.021; Fri, 7 Aug 2026
 02:43:35 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: Mike Rapoport <rppt@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Wei Yang <richard.weiyang@gmail.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>
Subject: Re: [PATCH] mm/mm_init: fix out-of-range first_deferred_pfn
Thread-Topic: [PATCH] mm/mm_init: fix out-of-range first_deferred_pfn
Thread-Index: AQHdJhaKgRGUHcJxNEq8gYrdYIUqBg==
Date: Fri, 7 Aug 2026 02:43:35 +0000
Message-ID: <cd2f3dbb-8a2e-4a5d-8705-e670aecb0762@amazon.com>
References: <20260805224421.15794-1-graf@amazon.com>
 <anQf2kFzA63_3ayh@kernel.org>
In-Reply-To: <anQf2kFzA63_3ayh@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BE3P281MB6244:EE_|FR3PPF22F263B2B:EE_
x-ms-office365-filtering-correlation-id: fbd16d43-16d1-4d0a-cff2-08def42dad4a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|38070700021|18002099003|22082099003|56012099006|4143699003|11063799006|5023799004|10067099003|6133799003;
x-microsoft-antispam-message-info: vMEaQf0j8Dzhs52rRc0uNZ0CpoApidltjjlRzjFmB42IFsZ6L+MKjXdvo7itrTO1MdQ/pXBu5qKQKEd+STOTYVmGVvUSfy/ttlo9KrH1h0iMx5N4HI5t+SNHVk2fNZSwf9i6zpiSfYhHUUIi3o/5+stwlZkZdGaHpoEx82Ki5m5ugPb07+yfn5mAmTwCngukJTtwJVC9M0TxTbZlGBANtvmcM0OzwjAQpMvxKUmO42ZILTSFF3XfHiOSBvsK1raFEYGkT8sT3GbNHbYlUegFTcZbY0EUQDFf8UUq34a4JnbO4Z8mZ6Mo+TtHCgmawo5SCFy0g0epR+FxKemYYByhJdEXqk07+bwUdLp/0pt7f7WH0Bt3HiJ44S4Y68b2ozPdSWuYpW2uLnla0kNY4Ubvxb3Vp36ojEyVjL+9v/B1NnK3P5SnyrVHUh4YWh26gQ+BcUwmgQBdlXhgLvKcacah2vGbmExei+26MKewaQdueojN4u1sRqUHlW+Ic5axEhFQOjbs97vBypaEy7TszqhsdvDmeZqdFs7MsZ5p8qD3MMYQl67qdZmwYoJMQptpA1AZCRAevTivjbpFq/IDEf4fn6UlgoorpUs6oQkvAbF51WljC+lSbLDTiI3xuc/FZtk+nwDW516jpOZVsJLZiln66uOeexAP+duwmjBsOS+Z4nzr9wLszVKi4pDHG9+UEYTdDEFRJBZICkAwn17VbPwdLA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(38070700021)(18002099003)(22082099003)(56012099006)(4143699003)(11063799006)(5023799004)(10067099003)(6133799003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDlpNnFkcHo3K3lHaU5TenpGK0h1SUJLSnNNZDlySjBEUFZlTzJWUzhRK29G?=
 =?utf-8?B?K0JNem1WSGlnTzF6T0lpUHN4QU5ZVjNHQW5aeS94eFF2Smt5RGxJTHpNV0RD?=
 =?utf-8?B?VzY0dkpEOFhJQnVIZFJTa0xzVi9POVVRWjJiTmVrZ1BseGVnNjZoUkp0RmlK?=
 =?utf-8?B?Q2tiOHc0UzJGQ3ZVcjMvbUl5Vkh4Q2Z6U051czFCZmExTVVkN3lGSDY5ZGdq?=
 =?utf-8?B?QmNPMDJJRVpmMzdIVFBocHlPSStzb3BJTW1HeGRKK1lnWk1zeWtuTVFCU0N3?=
 =?utf-8?B?dGQzSm15dVM4WHV0YUUzK0NFeFV4SmwvWU01Rmd1WkJSVmpJNDg0UDFkamVS?=
 =?utf-8?B?ZXN6cEhTNHpadVYxRjJtQUVmL0VrYlZwVWRsbVJ5bFdKSXdLdTFJOEV1WGh3?=
 =?utf-8?B?bTM5T1NNR0NpS1VFSHpVa094dUovRmpaangvaGZGVU00a21SaUtmdGd1d0xq?=
 =?utf-8?B?citZRWg2aDFhQjdmU1grdFJUeVRqY2kzeFMxV0xOZ2Q2KzVSMWl2OFRUaDM0?=
 =?utf-8?B?QUcvNnpSOGUxSk4wQzZncG9qYWtUTm1wNmFkdlNQTEhnT1dYUjZnaUZGcml3?=
 =?utf-8?B?WjBVR2V1cmpocW5CWFNkaHd4Nkx6Uk5JOFc5N0tjWEdDM3JkMVdZTXNvREU2?=
 =?utf-8?B?RElsWkVmNzkwckprdHpVeEZTRm8rL05RSmlCRFZZTW9acHB3WHpBckp2ejlL?=
 =?utf-8?B?TjUyNkRMK2xDTEF4aU5ZSlNycWR3S3hwQ1E0azJqcGtKZWJlTWtGYlIvVTJy?=
 =?utf-8?B?U1BkV0lZRzJOeGxyZWRNcmJvVFpnN2I4OHNLTE5ubWRwWUhGay9nUWxRU3Yy?=
 =?utf-8?B?VCtwMTEzMzdmSkQyQU9rdTRkRmpXMjFod1ptUmFTTGZwTzg4bEorVlplbU1q?=
 =?utf-8?B?NmI5ZHJvRWNqSXN0REd3bm9kdG8xYVo1eGdsMlhEaktvUHNKcHZYWXpJZFFn?=
 =?utf-8?B?ZlF6clVWQXBoQ1RtOHluOU94cUVVbzVsYW1MRTRuU2NCNHZjWWZzSFdkMHF5?=
 =?utf-8?B?cGxjeFczK0IxS3NvV0M3S1NaVzZScHJBTWxsbkViRGRmaytBNVBmTWsxY0pq?=
 =?utf-8?B?Vk52VzVZdk5JZ2EyT21qTCt2N2ZNcWZORWNDTkE2bGZYUVBpYjl4K0s4d0sz?=
 =?utf-8?B?MXpFZ0dyTmowUzZCVCs3M0h1SUYvTWNZQTJ6cVFzOEFjSG9Nc1F6NVU2OW5W?=
 =?utf-8?B?dHVUL2xDcTVaeUFVNDRPTGQrM2pTMzh2ZVVBTUswNWUyZUpyNVZKOEdJTWJJ?=
 =?utf-8?B?VVpUK0E4UVc0Y2E1Mm9OOEpBVmw2ZEpPUjNtYnpGL2dBZ3dDRmlZODNDWHNp?=
 =?utf-8?B?UGEwMVg4Ym1NZEN6dUtSN2V0L21jK0ZWazJUM0xEeW00ZUdpZXdRWVExeksw?=
 =?utf-8?B?c3N1WmxKM0JiOFA4ZzN0MjRXUE84bFA3dDlQVFgvS0czZHBKazUwRlFOQitI?=
 =?utf-8?B?di9vZGk1QnJBUHF0cUQyaHZIY0ZMQ0dTVmlBeTZUbXBXMG1kRHlURm1GTGhY?=
 =?utf-8?B?UllGOFpXN2hjRmdwZmJoNHNUa3MrdkRqa2VwOFMrcGJBZ05ocGs2d0ZBRGVK?=
 =?utf-8?B?eFRRSUxFOTkyL2pYenVJeFZZN0ljV2UxWHFPbDhYRFpEbWdlak5ZekVoN2tD?=
 =?utf-8?B?SGhWaGZ6eHE5d0E0UFg2V0tqbmFmMkVWWEt5UEYzeGIyZnBtWlZOeHJCNmFK?=
 =?utf-8?B?OURBbVUvVnIvcGY3RHpxU2cxOGZjZnFzazFLTUszN3pIbk9Dcmt1bm1KUy80?=
 =?utf-8?B?S3BCenlhU1NGdlBVeXpQcENEN0dNYWlkaVdGSW1SeHRZQUh6VURTdWk2Y2VQ?=
 =?utf-8?B?eFdkalBBck0rMEUyMTAvWGRHcWx0S2JOQWVWMWd3ekppYnpNLzJTYnFneW5K?=
 =?utf-8?B?Nkoyc0QyOE43d1Q5VVZxNFh2VlRaV1VQZWRZYSs1UGNqMTRUNkd1V1JweWlR?=
 =?utf-8?B?WGtHZjRIa2VJd21Jd20yRVRNelBidkNjVEEyMVZHNnV0TVhSNnZoeUtXczI5?=
 =?utf-8?B?dE1HV1UybWFLUm1HdjFHaTZpY3Rnblo4Tlgrb25oNU9FTzVwYnh0clBvdU1s?=
 =?utf-8?B?WHYrOEhhVXpScWZBMWJvYVJvUHZ1ajJ4RGhBQUxsRTByUVA4dUIzUlhTd0RP?=
 =?utf-8?B?bnlleHZWN0lwWDIreFZMejlnZ2hkRk15YnM5dmUwTnJPNEtvZUJQTDJseEFE?=
 =?utf-8?B?aS9TTUxTQ25yRHRjZk1UelZjMlFNNFBMVUdTb1F2V1YxYWRLRGwxSWVVemxB?=
 =?utf-8?B?ZHRDVzd4eHlWMVdmY1liTVhEbXh4QUJaVjAwYkxhTUxDcnNpVUJIYmVLbSsx?=
 =?utf-8?Q?iQNtjp2ZT3delulwm5?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F49DB38408BDB459DF0D8B8E32DC22F@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: SHdtf1b68/4vDc/G2kbmdiYVOVFfciuUZIjqrqd1mbJv6Vpqorph7qGUaCBmikP5Nodz0aUGcxDjeja6juunLMwRpzf+nm5YSJk8up4xe6cvJek4coAslJV8FdSj64fLEBVkVfuzGL6ekHCn3jFAXFtAojUF9Un8uNW7LfbbljqIOGlIRfEf6CEi5jIs3oxMn6tl4hfWAQfrmJSsau6Qvm14FemChiPstZqhwmPKYi+OBgMcsnR+L/UBUVC7E3GLHv5v5Mt5PCV4BFNS+5zcc6ZXiqExIGLVzk5fkSpMw/4vXwpGrUgLErDjOyTyhXy9OAXVeMKtXOGYYakqzRotlA==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BE3P281MB6244.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd16d43-16d1-4d0a-cff2-08def42dad4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2026 02:43:35.1051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v8o6Ws8oZDCRuqG+tZU/GArs7SU6gGtamPMRq7zWhwfg4nAOvf7a0h4EpZQaySRU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3PPF22F263B2B
X-OriginatorOrg: amazon.de
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: co8fy1wz4c8grm31w9w6zfm9x99g6wuw
X-Rspamd-Queue-Id: 26FBF20003
X-HE-Tag: 1786070627-263660
X-HE-Meta: U2FsdGVkX1/Nx0nSX7Yvps07myIXGAPixSekdnrzjw610LKYVwg6+eVfg59MZWOjmf3T9dOSG96O+qByzkfFfKcuCf52kF4Cevi5F5waFN5QLu5rvu2WpdsDp3ysA8gco4YuJ0FPjDGD+B7ynaxpCrXlDf+IjdL6DU6HR+RaJ+k7JK2qmmxCUEv1rIc6TsRlI58Qz/QTe6PUQgSytbi6mjww5K9aGU+1vAm8nZBmXbSywtYDEKNWKZ8uc1lRMqt8F30JWMnqIpXrL8Wv/vFTE1O3otWfhpZJQolUpbLlXD7b9SUYerBcQaDREUpzbZqZ6+kHvGZ2JMRvOYxVY2PbJYhIBrqwdjKSyo5DVdocYwPutRmTr1HBZJb4DSgWdz5RuITeB/xHup0/rAOg1hC/jPUdFyV/kMi+y1Dsbmom3LLMrXsQrnoPjOwN4tdnzWuJSXQujVdDCWkhJvj/24HSw/5hD0H50WLC/w1JoiTjGk7WRaFeeqsdDUA0Rx+KWljrYrL0epH3xXigjLg0zpcKqx46LfRkbF4VMnX1eAtZkZ3T9BvV/59ucMqT7ROI7Qiq9q2qEw/YJLwyMW/rMHGA804dj8pgNIqvpVUBdYrAVSatIgaOY2lDsRaAMeKwW94gIRP6HAfqrJsXvZl28oR3fW9mHwuRhZENj5kt1WkG+TrCDshzcMwDq5MR/s+tOy9Cxgak9kQqxtodPp/Bb9z9LIwEuu+tOFpLrHgY5FjZKrtzPsz5NnlUNEDP8IYzAIGYGo6HTsq5ca84ZIHpmrOk3ofIeN1uXY18A8gTqS2xF5vYTLD4QZs4gveaeBM/do3lP+MwB744isYHCFArHT7UONKHx7UBjihjgdlmK+eVJbEq4YMShwiA0s96gNkSyAd+cjNdngv+eF1i5+EvxRdwHao9bxMdxMNRbHeoUGIgifijivpWp3GkJtQaedNZQLL1AG6ymBX4+ct2gGOXXl9
 GRrU7/UL
 wS8i9HsjnVZxU83sfF+FGhyu8n3cP32FlIMIxUu887QGogNm6g7dWMiZBysnKPZwkqCfuRt5Kb98TVFDK008JfqZSevL/JsqY7uI8kKpfLssyVKyeUMgCx6Q0GmslBCN0GyALFHTMf3SxK94fWQ8l8eHd6MDstDIcb9NQC3JjY6SeNlHyj/Zm+hkfdownOIbdNmVtiKv9am4ET81Hd27Nlrp8kE3SCQjujs2HhUZdnge1NTYiUgbmUYm4O/D4ZUP6Vo5l1DJEZb4uiw6u+0gDJWfPUbIow4usBkvRJHJoXPeJxw9kqJmGJeHu41VHfKTFHqui3Q79v6qpDiq5xSRzUlT+H33XyWHUxEWdSpm10y/8ehCpeXog7VKf2dlg2Zl/a3uie+UMUfU207E1QULFe7bMSZooafDbYJPQnS9bY/FtcV46KDSO5TuLKl2B6ydg8aKVjn0itdr0UdaQByatIiIr/kjWvviTpa67KFWkjlWqU0n9avYnoElH/uYmegiiI+ubwROiQVpwFCB+/8YclPJIAlMQ4CjSyl5XLljnWCbu3V2XjuP26ZwNfwu22WX4x8/WOXcbkk+NxpzZn6GDhGWINLVeY/Wn6o2HTPvMgtgIEBEH6yxbEdcmhasmCujwJ1jqnGaEVspAitPsO1Is/PS3wI8N+ziejiz2QYK2Sr9Dj3yZpvfMh1tpRVIiQI2NL1aISE3vDQfRyCmwqAWoDT/S4qG7OWrSPyocEkNUOQzj65iLZnIe5m1IS7IrDZL88MQysBufXOU6NEIXUyv6EJPajeFFn3CswA2/ACW0gI1phluesfz9aLmiE7HdIR19xkCbA3BzddQJ763ykaquNu4j8kmWK7uXOt/vYhNuY0N5VVG96UJMeJi9Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DQpPbiAwNi4wOC4yNiAwNzo0NywgTWlrZSBSYXBvcG9ydCB3cm90ZToNCj4gSGkgQWxleCwNCj4N
Cj4gT24gV2VkLCBBdWcgMDUsIDIwMjYgYXQgMTA6NDQ6MjFQTSArMDAwMCwgQWxleGFuZGVyIEdy
YWYgd3JvdGU6DQo+PiBkZWZlcnJlZF9ncm93X3pvbmUoKSBpbml0aWFsaXplcyBkZWZlcnJlZCBz
dHJ1Y3QgcGFnZXMgYSBzZWN0aW9uIGF0IGENCj4+IHRpbWUgdW50aWwgdGhlIGFsbG9jYXRpb24g
dGhhdCBjYWxsZWQgaW50byBpdCBjYW4gYmUgc2F0aXNmaWVkLCBhbmQNCj4+IHJlY29yZHMgd2hl
cmUgdG8gcmVzdW1lIGluIHBnZGF0LT5maXJzdF9kZWZlcnJlZF9wZm4uICBSZXNlcnZlIG1vc3Qg
b2YNCj4+IHRoZSB0b3Agem9uZSBlYXJseSAoYSBsYXJnZSBDTUEgcmVzZXJ2YXRpb24gaXMgdGhl
IGVhc3kgd2F5KSBhbmQgYSBzaW5nbGUNCj4+IGVhcmx5IGFsbG9jYXRpb24gaGFzIHRvIHdhbGsg
dGhlIHdob2xlIHpvbmUgaW5zdGVhZCBvZiBzdG9wcGluZyBpbiBpdHMNCj4+IGZpcnN0IGZyZWUg
c2VjdGlvbi4gIElmIHRoYXQgem9uZSBkb2VzIG5vdCBlbmQgb24gYSBzZWN0aW9uIGJvdW5kYXJ5
LCB0aGUNCj4+IHBnZGF0aW5pdCBrdGhyZWFkIHRoZW4gZGllczoNCj4+DQo+PiAgICBrZXJuZWwg
QlVHIGF0IG1tL21tX2luaXQuYzoyMTMxIQ0KPj4gICAgT29wczogaW52YWxpZCBvcGNvZGU6IDAw
MDAgWyMxXSBTTVAgTk9QVEkNCj4+ICAgIENQVTogMyBVSUQ6IDAgUElEOiAzNiBDb21tOiBwZ2Rh
dGluaXQwIE5vdCB0YWludGVkIDcuMi4wLXJjNiAjMQ0KPj4gICAgUklQOiAwMDEwOmRlZmVycmVk
X2luaXRfbWVtbWFwKzB4MWI4LzB4MWMwDQo+PiAgICBSQVg6IDAwMDAwMDAwMDAyMzYwMDAgUjEz
OiAwMDAwMDAwMDAwMjM4MDAwDQo+PiAgICBDYWxsIFRyYWNlOg0KPj4gICAgIGt0aHJlYWQrMHhk
Zi8weDEyMA0KPj4gICAgIHJldF9mcm9tX2ZvcmsrMHgxODcvMHgyNTANCj4+DQo+PiBSQVggaXMg
cGdkYXRfZW5kX3BmbigpLCBSMTMgdGhlIHBmbiB0aGF0IHdhcyBzdG9yZWQuICBUaGUgbG9vcCBh
ZHZhbmNlcw0KPj4gc3BmbiBpbiB3aG9sZSBQQUdFU19QRVJfU0VDVElPTiBzdGVwcyBhbmQgb25s
eSB0ZXN0cyBpdCBiZWZvcmUgZW50ZXJpbmcNCj4+IGFuIGl0ZXJhdGlvbiwgc28gb25jZSB0aGUg
d2FsayByZWFjaGVzIHRoZSBlbmQgb2YgYSB6b25lIHRoYXQgZW5kcw0KPj4gbWlkLXNlY3Rpb24g
dGhlIGVzY2FwaW5nIHNwZm4gaXMgU0VDVElPTl9BTElHTl9VUCh6b25lX2VuZF9wZm4oKSkuDQo+
PiBDb21taXQgM2FjYjkxM2M5ZDViICgibW0vbW1faW5pdDogdXNlIGRlZmVycmVkX2luaXRfbWVt
bWFwX2NodW5rKCkgaW4NCj4+IGRlZmVycmVkX2dyb3dfem9uZSgpIikgZHJvcHBlZCB0aGUgY2xh
bXAgdGhhdCB1c2VkIHRvIHByZXZlbnQgdGhhdDogZXBmbg0KPj4gY2FtZSBmcm9tIF9fbmV4dF9t
ZW1fcGZuX3JhbmdlX2luX3pvbmUoKSwgc2luY2UgcmVtb3ZlZCwgd2hpY2ggY2FwcGVkIGl0DQo+
PiB3aXRoIG1pbih6b25lX2VuZF9wZm4oem9uZSksIGVwZm4pLCBzbyBzcGZuIGNvdWxkIHJlYWNo
IHpvbmVfZW5kX3BmbiBidXQNCj4+IG5ldmVyIHBhc3MgaXQuICBUaGUgYXNzZXJ0IGlzIGZhdGFs
IGVpdGhlciB3YXksIHBhbmlja2luZyB1bmRlcg0KPj4gcGFuaWNfb25fb29wcyBhbmQgb3RoZXJ3
aXNlIGxlYXZpbmcgcGFnZV9hbGxvY19pbml0X2xhdGUoKSB3YWl0aW5nDQo+PiBmb3JldmVyIGZv
ciBhIGNvbXBsZXRpb24gdGhlIGRlYWQga3RocmVhZCBuZXZlciByZXBvcnRzLg0KPj4NCj4+IFN0
b3JlIFVMT05HX01BWCBvbmNlIHNwZm4gaGFzIGxlZnQgdGhlIHpvbmUuICBOb3RoaW5nIGlzIGxl
ZnQNCj4+IHVuaW5pdGlhbGl6ZWQ6IHRoZSBsb29wIGNvdmVycyBhIHNpbmdsZSBnYXAtZnJlZSBp
bnRlcnZhbCwgYW5kIGJlY2F1c2UgaXQNCj4+IG9ubHkgZW50ZXJzIHdpdGggc3BmbiA8IHpvbmVf
ZW5kX3BmbigpIHRoZSBlc2NhcGluZyB2YWx1ZSBpcyBleGFjdGx5DQo+PiBTRUNUSU9OX0FMSUdO
X1VQKHpvbmVfZW5kX3BmbigpKSwgd2hpY2ggaXMgdGhlIGxhc3RfcGZuIHRoYXQNCj4+IGRlZmVy
cmVkX2luaXRfbWVtbWFwKCkgd291bGQgaGF2ZSB1c2VkIGZvciB0aGUgc2FtZSBwZm4gcmFuZ2Uu
ICBBIHpvbmUNCj4+IHRoYXQgZG9lcyBlbmQgc2VjdGlvbi1hbGlnbmVkIG5vdyB0YWtlcyB0aGlz
IHBhdGggdG9vIGFuZCBsb3NlcyBpdHMNCj4+IHplcm8td29yayBwYWRhdGEgam9iIGFsb25nIHdp
dGggdGhhdCBub2RlJ3MgcHJfaW5mbygpIGFuZCB0aGUgV0FSTl9PTigpDQo+PiBvbiB0aGUgbmV4
dCB6b25lLg0KPj4NCj4+IFRvIHJlcHJvZHVjZSB3aXRoIENPTkZJR19ERUZFUlJFRF9TVFJVQ1Rf
UEFHRV9JTklUPXkgYW5kIENPTkZJR19DTUE9eToNCj4+DQo+PiAgICBxZW11LXN5c3RlbS14ODZf
NjQgLWVuYWJsZS1rdm0gLW0gODAzMk0gLWtlcm5lbCBiekltYWdlIFwNCj4+ICAgICAgICAtYXBw
ZW5kICJub2thc2xyIGNtYT00NzY4TUAweDEwMDAwMDAwMCINCj4gVGhlIG9ubHkgdHdvIHBhcmFn
cmFwaHMgSSB1bmRlcnN0b29kIGlzIHRoaXMgYW5kIHRoZSBCVUcgc3BsYXQgOy1QDQo+DQo+IENh
biB3ZSBwbGVhc2UgaGF2ZSBhIGxvdCBtb3JlIG9mIGh1bWFuIHRvdWNoIG9uIHRoZSBjaGFuZ2Vs
b2c/DQoNCg0KRmFpciBjYWxsb3V0LiBUaGUgcGF0Y2ggZGVzY3JpcHRpb24gaXMgdHJ1bHkgYXdm
dWwgOiguIFBsZWFzZSBleGN1c2UgdGhlIA0Kc2xvcC4gSSB3YW50ZWQgdG8gc2VuZCB0aGlzIG91
dCBxdWlja2x5IGJlZm9yZSBpdCBrZWVwcyBjb2xsZWN0aW5nIGR1c3QgOikuDQoNClRoZSBwcm9i
bGVtIGlzIHRoYXQgd2l0aCBDT05GSUdfREVGRVJSRURfU1RSVUNUX1BBR0VfSU5JVCBlbmFibGVk
LCB3ZSANCnVuZGVmZXIgc29tZSBzdHJ1Y3QgcGFnZSByYW5nZXMgZWFybHkgaW4gYm9vdCBpbiBk
ZWZlcnJlZF9ncm93X3pvbmUoKS4gDQpXaXRoIGEgbGFyZ2UgQ01BIGFsbG9jYXRpb24gaW4gcGxh
Y2UsIHRoZSBlYXJseSBhbGxvY2F0aW9uIHdlIGNhbiANCnNhdGlzZnkgbWF5IG5vdCBzcGFuIHRo
ZSBmdWxsIGRlc2lyZWQgYWxsb2NhdGlvbiBhbmQgd2UgZW5kIHVwIA0KdW5kZWZlcnJpbmcgYWxs
IGF2YWlsYWJsZSBSQU0gYW5kIHN0aWxsIG5vdCBzYXRpc2Z5IHRoZSBmdWxseSB0YXJnZXRlZCAN
CmFsbG9jYXRpb24uIFRoYXQgaXMgcGVyZmVjdGx5IGZpbmU6IFRoZSBmdW5jdGlvbiBhY2NvdW50
cyBmb3IgdGhhdCBjYXNlIA0KYW5kIGxlYXZlcyBpdCB0byB0aGUgY2FsbGVyIHRvIGRldGVybWlu
ZSB3aGV0aGVyIGl0IG5vdyBoYXMgc3VmZmljaWVudCANCmF2YWlsYWJsZSBtZW1vcnkuDQoNCkhv
d2V2ZXIsIHRoZSBmdW5jdGlvbiAqYWxzbyogcmVtZW1iZXJzIHdoZXJlIGRlZmVycmVkIGFsbG9j
YXRpb24gc3RhcnRzIA0KbmV4dCAocGdkYXQtPmZpcnN0X2RlZmVycmVkX3BmbikuIEFuZCBpdCBk
b2VzIHNvIGJhc2VkIG9uIA0KUEFHRVNfUEVSX1NFQ1RJT04gKDEyOE0pIGNodW5rcy4gSWYgdGhl
IG5vZGUncyBSQU0gZW5kIGlzIG5vdCAxMjhNIA0KYWxpZ25lZCBhbmQgd2UgdW5kZWZlcnJlZCBl
dmVyeXRoaW5nLCB0aGVuIHRoYXQgIm5leHQiIHBvaW50cyBwYXN0IGVuZCANCm9mIHRoZSBub2Rl
J3MgUkFNIGVuZC4NCg0KV2hlbiBsYXRlciBkZWZlcnJlZF9pbml0X21lbW1hcCgpIHRyaWVzIHRv
IHBpY2sgdXAgZnJvbSANCmZpcnN0X2RlZmVycmVkX3BmbiwgaXQgcnVucyBpbnRvIGEgQlVHX09O
IGJlY2F1c2UgaXQgZXhwZWN0cyB0aGUgcGZuIHRvIA0KYmUgd2l0aGluIGl0cyBub2RlJ3MgUkFN
IHJhbmdlLiBUaGUgY2FuYXJ5IGZvciAiZXZlcnl0aGluZyBpcyBhbHJlYWR5IA0KaW5pdGlhbGl6
ZWQiIGlzIFVMT05HX01BWC4NCg0KSGVuY2UgdGhpcyBwYXRjaCBtb2RpZmllcyB0aGUgY2hlY2sg
aW4gZGVmZXJyZWRfZ3Jvd196b25lKCkgdG8gYWxyZWFkeSANCnByb3Blcmx5IGRldGVjdCBlbmQg
b2YgUkFNLiBJbnN0ZWFkIG9mIGFzc3VtaW5nIHRoYXQgdGhlcmUgaXMgYWx3YXlzIA0KbW9yZSBk
ZWZlcnJhbCBhdmFpbGFibGUsIHdlIGNhcCBpdCBhdCBlbmQgb2Ygem9uZSAod2hpY2ggaXMgZXF1
aXZhbGVudCANCnRvIGVuZCBvZiB0aGlzIG5vZGUncyBlbmQgb2YgUkFNKS4NCg0KDQpMZXQgbWUg
c2VuZCBhIHYyIHdpdGggdGhlIGRlc2NyaXB0aW9uIGFib3ZlLg0KDQpBbGV4DQoNCg==

