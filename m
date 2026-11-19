Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BB2E606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 12:27:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.de header.i=@amazon.de header.a=rsa-sha256 header.s=amazoncorp2 header.b=aWwdqsST
Received: by kanga.kvack.org (Postfix)
	id 487806B0639; Thu, 19 Nov 2026 07:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4389F6B063A; Thu, 19 Nov 2026 07:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300926B063B; Thu, 19 Nov 2026 07:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F07A26B0639
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:27:21 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BD05160A91
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:27:21 +0000 (UTC)
X-FDA: 85451793882.09.33F9F4A
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf26.hostedemail.com (Postfix) with ESMTP id CE753140003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:27:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=aWwdqsST;
	spf=pass (imf26.hostedemail.com: domain of "prvs=776723d4e=graf@amazon.de" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=776723d4e=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795091238;
	b=8bR9D4a+BVBoxA+OZBxeos39D6ciLDxKWlWGZLwHjzqn7of6f5QTUFUEFDGvmzkJffm4V+
	Ld0iM8cKnjWPVrU4OA4CpO+3qL4vlBZGeSmr4uVNZ3TlAuRhjAPmeshKYDeTGh2hVnq6fu
	L9KdfyVct3AusnHJQQV0Nzj7+bWLV68=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795091238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/R/VpeLN3pbU7BPC6gwoQbwCGvwbKwmvdLMCnVmc56w=;
	b=2VIGHUVVRXcbb6DNJOJIyMJhXtXkI7oP6sOvw5eGmAeplniKLJ7BkqfkIbZeG+yXoJd2WG
	aAfUaGLUJMXY0qkUH+IQch4wTMWqcEaVV0buwyJb4C/7envr+1ZX2Se8X+4xfle3YfuYCg
	5oDDFszupQz+I3M82gC8/ht6WaWIhuU=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=aWwdqsST;
	spf=pass (imf26.hostedemail.com: domain of "prvs=776723d4e=graf@amazon.de" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=776723d4e=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1795091237; x=1826627237;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/R/VpeLN3pbU7BPC6gwoQbwCGvwbKwmvdLMCnVmc56w=;
  b=aWwdqsSTuE8mwm5Lger0HyMFUKxs2WcYRopNRfJQFT+HGWUxik6evi19
   HmEd1sak2XBWZBWYJQEEf6cdGJL4rOznKiwEsK4kYoAxA3MNS8eaRiRPJ
   9+6IBmkOy27uSKJGgpGv6synV0kvZaV2AAAcfySLOpUlQTG5MzSM0r2GZ
   5AjfoNaRqyADaASmNkkXdmQ01y/EuxFNag+nnnfcKMTwMOtWFCqt6IJ1m
   MYwOkKzr+NrKfjZCII2VlE25jlB2I/pU/yA3jFtUCAHkTa71vIubARclA
   YN5hotM6eziLh3iqntYNYJ7My3OKIVoOSdQUUryG17KWCKunDkUDLV9/S
   A==;
X-CSE-ConnectionGUID: vEspxkZeS7eD9hkdah3mDw==
X-CSE-MsgGUID: McR4CrK8RWiy20gmsMAyTA==
X-IronPort-AV: E=Sophos;i="6.27,220,1787011200"; 
   d="scan'208";a="23095631"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 12:27:13 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:12439]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.156:2525] with esmtp (Farcaster)
 id c66ae11f-290e-4893-b10a-93a0a493fc7f; Thu, 19 Nov 2026 12:27:13 +0000 (UTC)
X-Farcaster-Flow-ID: c66ae11f-290e-4893-b10a-93a0a493fc7f
Received: from EX19EXOEUB002.ant.amazon.com (10.252.51.83) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 19 Nov 2026 12:27:13 +0000
Received: from FR4P281CU032.outbound.protection.outlook.com (10.252.50.44) by
 EX19EXOEUB002.ant.amazon.com (10.252.51.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Thu, 19 Nov 2026 12:27:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXIkiDqPjH1+vTonF+VgRkKb/MxTrWh/KFJB7xrllnqVlTjmkWUlf0jKZOguTcbfaIoayu8e7noG2j5ZqfQ+mhLad7AZaODihpqBre59vNkUKVUX3ztIcwQaDnd0rR00tA+LC/yehfU0WRrIVb4uFFaOtfJ7Rw+IVd0BGUhsI/hiwaRokpjpQTmpNihSk+hfPhb2CSbvrM9UVi7/1bz408gVUVlrXylSeZRrQ2Z58kOy++e7S8oMce0H/zEJIYjLfixCCo6NNHlln125mjTMOrhSWdS1NumB+Hc4Tb55rNddn6Z9upgnURMegBnCgTZRWy9BQwbZcT0TDE24DOx4cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/R/VpeLN3pbU7BPC6gwoQbwCGvwbKwmvdLMCnVmc56w=;
 b=na2evdTThiLce0qqMhYbGFXIKRFvrta3PCl+YL+61PO7agUu8hsKc+ufO84dR4L4c9hCx2Zs+/Y+vUWoFlemUNT1F49FGKY150CFu6H3w4SbtoGEZDxZsXLdYaG8y4ARhlgFBhb62lAZ9a2I1C+eBG2pQnD26pZswLA9WCiat+rSU7saeyboCbm4lDhts6LFJEma8A3NH/vdTa3kVscm2tr80b+nrYNSBFL5tQeRB567fFq4WuCz01cvZLSE4tmEOJCwM3IvReezAIxfdLz5HznLXwSXFS9Znhxd1J01qmkNbW0u6UuS73NYYuwkMYEZKIVHz4xaBhP6rZnh1xG6vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.de; dmarc=pass action=none header.from=amazon.de;
 dkim=pass header.d=amazon.de; arc=none
Received: from FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:20d::13) by FR3P281MB3069.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:5a::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.17; Thu, 19 Nov
 2026 12:27:08 +0000
Received: from FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7b1c:7a5d:c405:6c4d]) by FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
 ([fe80::7b1c:7a5d:c405:6c4d%5]) with mapi id 15.21.0615.017; Thu, 19 Nov 2026
 12:27:08 +0000
From: "Graf (AWS), Alexander" <graf@amazon.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "The
 AWS Nitro Enclaves Team" <aws-nitro-enclaves-devel@amazon.com>
Subject: Re: [PATCH v2] dma-contiguous: support percentage sizes in
 cma_pernuma= and numa_cma=
Thread-Topic: [PATCH v2] dma-contiguous: support percentage sizes in
 cma_pernuma= and numa_cma=
Thread-Index: AQHddEf7tYtxXLjQ9kue1WbqibxY3Lc1R0IAgAASw4A=
Date: Thu, 19 Nov 2026 12:27:08 +0000
Message-ID: <28a0f946-af4e-497f-a923-f11b79d94930@amazon.com>
References: <CGME20261114145340eucas1p2f7699b88eae34f7904cf68109dc3eb4f@eucas1p2.samsung.com>
 <20261114145328.1307-1-graf@amazon.com>
 <fa38a878-1735-4682-b208-5de1616f7e4f@samsung.com>
In-Reply-To: <fa38a878-1735-4682-b208-5de1616f7e4f@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: FRVP281MB744463:EE_|FR3P281MB3069:EE_
x-ms-office365-filtering-correlation-id: 6f687ec0-2f1e-422c-ddf8-08df46386ddc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|18002099003|22082099003|6133799003|3023799007|11063799006|5023799004|56012099006|4143699003|261022115727099003|261026140227099003|261028144727099003|261102123227099003|261026121527099003|261021121427099003|261022075727099003|261022105027099003|38070700021|10067099003;
x-microsoft-antispam-message-info: ySlmZE1g03SGnDSpzhD6nsD0dXqJTG1n2FBXrZ3ZzL6Cr0N2hD2Dp6zTwafQG5HwKpYF2ssaO56fc48LXwLD6sfNSuN1AvTxm+0hodmuCfWXFcCyU4Gb8H/IKZHPq342aUNTqTkZitXpwfKnnEr+KbtsxfBwAMa8ES2xbWRt/Yl0atHJ6xURhuh48r1DGvS9p6Fr5ezR25BNwuy5WKzoxth/bVl9C5oEBwrQ+xfVSljQODjgIOeY6PIrcnPwM3lgF6WM+C85OtjbF4PxH+jjyfBVsfCg5wl93BG3vNPa1ksYChJWJIjY4DmwQPu2iykY1GRQdL3xUZpDbYQ8EY0WH+a22HcJkWc0GrNuc8QfHLnwpZNh0hJuYojz9tZvMQR6WHoEn21PmfA816GcVPVZiWz8c2bdZFU7K32NMviGqPYxdUth1zVynqNe2MVYbYPl3sksp82Z10r15nfqoxa06/ustG2VeJSv6+AoGSGA0gWCN+drILYOq7vJ3leWXt2MfcbMlyn6Mo+Jxwtv/iD8oybch5ldqLozWq6cH6P9+/LxQcO1GXZwl9l61M3hPDvipZ+5gYMP8jBW3gI6aWmD8SIJw/fWyoTWDO+t0FU40FfrOX6DwiPKqE45Y8SnGBujDBVkHqri8dceA7tJLiyDlJc6/VsFaoZz8JTmA/NhXHFh2lEzOlfx43+2FE5ZPbEScmmHNmkNJ6UoYmf/fVtRq+LQsIrP7fC/0rGKKyHmNjs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(18002099003)(22082099003)(6133799003)(3023799007)(11063799006)(5023799004)(56012099006)(4143699003)(261022115727099003)(261026140227099003)(261028144727099003)(261102123227099003)(261026121527099003)(261021121427099003)(261022075727099003)(261022105027099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?alpuS3ZoekZjem1pNVM5dmdDNURxL0ZMY1BFQ0htOEhjdnN4dnBWekU5TTJ6?=
 =?utf-8?B?TWlPTFQyVlV1VkxVeHZyQjJlRUppNzBxRWh3YXl2R2d4QUZSU3VuVUVWOGZx?=
 =?utf-8?B?NFJLYS9FVndrTC9YNTArOG9OZlFPYk5NSkpDYVp2SS92Vmxob1NuV2s1ZmY1?=
 =?utf-8?B?bUVHVGJPVWpjRkRDVndOZTVSaEhnODBzOU9YRXFXMFpUbXRJOWVObGlsWXJa?=
 =?utf-8?B?OXRqdDFJNUdwRGJXSXFHam90T0ZYVGFjc1ZvUXJLRndYZ3FQRnFNUjZ1U3R2?=
 =?utf-8?B?OFlsQUdLWnZLdnh6Z1VUT01ZajNGemRDUHR3L1M0eCsyUThwd0tPeE5JYVhC?=
 =?utf-8?B?SDl2QUN1T2pQV1dOM1BYd1BXUjZmRm01Q1RNVTV3SnB5aDF3NTN1U05HeVpJ?=
 =?utf-8?B?WnRkNGUwL0pHa2lSN2hIcStuSk9iVEhMU3R6bEtpVC9tMHNFbEd6RzZoRS90?=
 =?utf-8?B?cC9yQmZ1MFVsZU9vTTBVdEcwYitaRDdCTzlrVnRFTDh0RE5UbFRGdWRoYm9m?=
 =?utf-8?B?RjFzTkZNN1B0TWllczhveFVsZzc0Vi9vNFovMVpNWDUwWnRMMUp0Z1B0TVVT?=
 =?utf-8?B?Yk9VbnVVMzh3UkVtM3Fzd0xvb1FndTNVZWxxZk1kR1NTTDhMY3NGUDZ5UkxW?=
 =?utf-8?B?UWEvYmd0QitCcFQ5ZUZxR3dvTUFhaXlLYTlLN3VETWJydHBmdUFSTVFZbVVD?=
 =?utf-8?B?UUgycHB4UTV2TU0rL0Y4cVppcVZzYWpzQ3RYNjVrRk5hUEZ4Z1c2WU9zaXpr?=
 =?utf-8?B?QUdIajlUTHhPTm9ESlZWaGhnaGJjZi9vc3ViMUZWVHdDYVR3VWlmak9RS0dJ?=
 =?utf-8?B?VnhUblNGS2E0eGJhVXdiSFhDQjZlMVZSYzZmdzcybC9DaG1xYWFwaWhycVpR?=
 =?utf-8?B?K0VtSm1UVnFKOEFiaTAzMlNGVG9sT1gxNzBqa2lGUzhUU2s3cVhIWXA1NmhW?=
 =?utf-8?B?Y0tXcUFjeGkxMjJwcTFzWks0RklaRFB1MWNLb0cyeHNJcWxFVWJFMit5Wngv?=
 =?utf-8?B?WFVpdk9PU2oweEtMMWpCME5ITyt2b1pUc29QV0luQmMxQjVRR1F0U3pxZHVw?=
 =?utf-8?B?L0x6c0Fpa2lQMGhqb1lOQVZidW52bU5WVHNRMXM0M21PTUZta1N2a3ZvUFpU?=
 =?utf-8?B?dXE4blZjRk9DdVNXZXdBSnhNOWplY1R4bkNtaVBxZEpRd3p0Y0JONDd5cjVL?=
 =?utf-8?B?Ni9QNUQ5Nmo1b3dseHR2NTFoMFBwY2lmSG9BamtaRlZET1U1Z1A1eEk4TFpS?=
 =?utf-8?B?bTdqeDZJeVJjaTZ6OW9ZUTIvT3ZlN0lTVVdvaHVZNEJHRW9PM1pjRTJDdjdL?=
 =?utf-8?B?ZjRoUW12QU8yNzdJd3dnd3QwYlQrOVdZR1FNQ282bkJMVUp0M0hZdmRaTG82?=
 =?utf-8?B?VThLazlmUHdzM2YzclpSL0FIcllodGMzMk9LdzFjZVA2d1FDUTMxRHdzZFUy?=
 =?utf-8?B?NzNIZitmdUxkTU5oWHhWeUt6ZFZrRHVHM0UxUUxQTGl0RHJ4WVlmd29RZFRw?=
 =?utf-8?B?VnY5Y1J4dlVsVk1FQVZXczVXVzY4ajZYRUlGZlVhWXU5ams4RGNlVG9wUHVz?=
 =?utf-8?B?ODgvYmtCdUc2UUMzb3UxNWlUNk8zRDE1cGNodkV3b3ltQ1hwWVZnT3JtTzQ1?=
 =?utf-8?B?S3JtV1hCVXBGWEFnczBpQlBsdTNxdVh2WkMzSVlDekQ1SXphWUROWERQcmlM?=
 =?utf-8?B?L2NtcUJEZTBTM0o2bEpueHlSY2ZzUC81WW9zdlNVRHIyRVVyWk1HWmI0d2hZ?=
 =?utf-8?B?enRWdFRMQjhxQ0kzSHlIQWZTRHV3WjY5RS81bVIxeGc1cFFFVEQwTGVJVHVE?=
 =?utf-8?B?b2tHWWx1VnhjeE9JemtXRzk5Um9aT1VMY2RVVXdNRFJZM3d1cEJxRXZmZHlO?=
 =?utf-8?B?REQxcnNQMFVNSXM1TlRCZWk3eVEvSnlIbGh2TjFEOXpZUnhXTEpPdjVIRXJm?=
 =?utf-8?B?b3Uzc3FBbWRwR1BXTHlTTDlGYWNTOG9qMGJKQXJsaEZNcmY0cEZSL0FtMUxo?=
 =?utf-8?B?Y1hBVElvKzVkRzh1WmoyaUl6YnJmRXhCM0VXbERMRWhhb2VGZklqTHhkZ2Ra?=
 =?utf-8?B?ZkRJcjRpdDN0T21SWEYrM0NLemNhSkpCdkxlTngzdjgwWG5XamR4TXk4c1o3?=
 =?utf-8?B?cTdoMDEwZ2Z6YWJKc3V0WllrbFoxOHcxQTRLaVI1ckxkRHpJWml0a1BMcW9m?=
 =?utf-8?B?anJrcDNqQVl4UENtRU9NcFVWNUhEbXJrOXNIakZIbjR1WkpiSFd1a1FpL29l?=
 =?utf-8?B?NDYxVC9NbnFFS0dHRysyYnF2SmZlS2k2a2ZXUEJvTzZCQysrbUhyUE5kOTY5?=
 =?utf-8?Q?AopLogUQNs8RRd6aOj?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <61F572A20EAE2A48A277F05116F90715@DEUP281.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ma88mklnTR6DumWOAc7/R8U5g80Iitm/QAr6D49pNgBp4F0SaTgqRDubWLhU8NNBkK22h1kapLoqTGCbStihyKl+RhgTTGQw4mRsDmEi8s0P1WzMxdLXToh1fIcsNcGOCr3aTZKvhJeWP51y91SZZrz8dKvXPpLvb4LKPRM7c842lo8G+XgYnP/KVuJ89sj+65YpZld6tWJSARa4C3qw73IjJti1h1bHQKIuvYSLCo8P6cz9o7HMqQELgTODwMp//bKOu6YHN6H6llPlugJVRhMQwS3+usuUdy0vWRBsWVfyBsRBtEBdqs8/GjP3v8AevgYBNqTqIXbHGsWoA3Zkgg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: FRVP281MB744463.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f687ec0-2f1e-422c-ddf8-08df46386ddc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2026 12:27:08.4559
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yDau6bClN6ft+IRm9Dtx6zZeqSoUY4MERdx25CYthqWsSgfqUIgf9+qYDbhkamdN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR3P281MB3069
X-OriginatorOrg: amazon.de
X-Rspam-User:
X-Stat-Signature: r1goyg3kt4bpt6xy3nauenzhjqh7neaf
X-Rspamd-Queue-Id: CE753140003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795091237-773862
X-HE-Meta: U2FsdGVkX1994qEZQh2j3syMChYEG3IzHuUSZJqAX/dLyKxoKO9YoAtnGyyPD+2NDKXYrKgwUiwJthOUakw/mw5+v4XauyvsE7EQDAfTAPOl7NauYOH+rj9eyGteNYA8f1m/vHapIPI0iUmTY2hNTteXa17rd/Vw8RdSNeMQQargMIQ558l0E/qFeW4vHui2skzGbWZbEQpo17d4RqsZhY5sVpCz8SBqwKtB8cm+v/jJunguUCys3NbqLAjQc0bHY4s1LRM8hfICLcF7MZFCf/jcXey8KVMAYtvNz+cb4oAWaGq0jG8ZfDAXWAuhsO0DDaTKOxSyM6cubk4jKbkU0aPDvNq8V+2JalM/GoupY2kIbiH06rWaqtqpeNzP4NISH94ai/j+Wz4xQZP2K21Y4bJKYJLoVVnghSQiijIEO4EueW/xq1zE0wCgnV8vf6FZ6GujmYAQtjSyAS6h/qR1G42pEi9AuAVdrUWbkvSwi6I7jBztydHh5rk0TJJgQwu1+C79UgZv/RpBVDpiEETQldx9DCuby7H1GTlCZQb1Rx9pltnb48U0IC3I/G/rKp3vGUKUOeWHxtkFrxZhHI5cLeGwYc3mfpsuPs7tidsF29XeWVMpphi6fIDI94yMhQZhno4+rRZj7noSvX2qhEqjpPGuM52IAZq4TrC2XuppzTopxdGX0bY++99Cv48GJBH4fHMMFXavnoyLK0cs7kyLe0YQ6ndV+gp/ieaAT1LsI/Oln+enbMxvymnvat4nsRKacx1+FbMX0z124s9l3yH7s1z7r0Rs1z45vOdnHULsiLE5YWC05BmvpUvQfW7f9KEYJgDZMMg4VKXQpEb2uWF6LQg22jV3j93NccbJ4bFEBdZjxm39y8BX9YkPE1CMBYTFJR0s9jJwhO4cYI1K+GAC15CE7bc5kLLGVzb0mvtCn7y0VMcZw/2lXWq/pbP04hAsP4MLZ70PqLLwE92cbc1
 QjtqPBPA
 uED//ES0De7oVQD1zvHaW0t5GzMtc9di0yHxZX6McRNSM0rcxFGXgFr6+Qyi3QPwJ/i9JPvYOOmxltiur+frREKkK9LCNvy2HlBiPsL9fMlPHKnoKa6gu72/6KNCm5gYsPrsTaLweHYqbt7LlllEgdqM57fMI+1qgNPGaAbBjyMtbH/R9wVeXNWw6vS3SoHxOK3+IBI9zNkjp8BeF86xIy+McIHqG7mmIT5FLGsi/KMUsbIJ0sjwEqLKzEHZeU6EnZTiAM4C3AM2SJWIg+SLUc4f/s0J0b7eVwI7n+KZf3kNZkcmQQAvp5bDa/S4JSt1FyLn8TaRLBaqYnnCDtYuftX5+qP3ClLa/v2SpECcrq2jhG+TzlnKbYxH7pLcNrguf2+WOBnTkTY2cf/MM5F9BvfB4lRT9NcfK+EnB/bS1gt3O6b71U/NBB30QtBxbLN1HcBmp3SHTleLSWYzHiFhJNs9TWup/5nryW5oEQuCkE/Y/kWwMkU7aKuqmNwcYlvzT6wQwjoeUbdhNy18CKLtPVLXaM/syht5G9uKG3ywoOzoAkI/cQEghJljO60+98mWDc1oNxIyi/3d7O+uGvGVIy7TxnyEj1+1Z1wohXrp29PiZzJE+Kb/JWJnlR0dWmEM1rl+t/jsxUnVnNaZdAoTmBzMW+F4jEF2wMHKycVTN5ByhaC3KHYbQ8yGl5fYaGZAS3WsdjDbsStNfzL9QR2Uyf+w7WbwH9a8v3hVcM1qdp61rwcetCVjOj1zmYwj3O2IsrTBxd0Maj107+5wMNuMbwnQbWIicanMz3WHBX8+hVY6/WzYlepCFdSfrtmw4sYjnKqX/23lZ8vHHfAE52v3ZLGZMhGqw90kf5zDngM3f/v36/HqFdT5qw/RxMGVZ7uL8vgxoOHij6g3DVZbQnFCHanxDTJeW8+kKgE39/FNqvblGyTsGoM7GSquQwWIkaRV4UsLPB0egntCYiFo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DQpPbiAxOS4xMS4yNiAxMjoxOSwgTWFyZWsgU3p5cHJvd3NraSB3cm90ZToNCj4gT24gMTQuMTEu
MjAyNiAxNTo1MywgQWxleGFuZGVyIEdyYWYgd3JvdGU6DQo+PiBXaGlsZSBDTUFfU0laRV9QRVJD
RU5UQUdFIHN1cHBvcnRzIHBlcmNlbnRhZ2VzIGZvciBidWlsdC1pbiBkZWZhdWx0cywgdGhlDQo+
PiBDTUEgYWxsb2NhdGlvbiBrZXJuZWwgcGFyYW1ldGVycyBjdXJyZW50bHkgb25seSB0YWtlIGEg
Zml4ZWQgc2l6ZSBhcmd1bWVudC4NCj4+IFRoYXQgbWFrZXMgaXQgZGlmZmljdWx0IHRvIGhhdmUg
YSBzaW5nbGUgc3lzdGVtIGltYWdlIHRoYXQgc2l6ZXMgaXRzIENNQQ0KPj4gYWxsb2NhdGlvbiBi
YXNlZCBvbiB0aGUgYXZhaWxhYmxlIG1lbW9yeS4gVG8gdXNlIENNQSBhcyBiYWNraW5nIHBvb2wg
Zm9yDQo+PiBsYXJnZSwgcGh5c2ljYWxseSBjb250aWd1b3VzIGd1ZXN0IG1lbW9yeSwgSSB3YW50
IHRvIGJlIGFibGUgdG8gc2F5DQo+PiAiYWxsb2NhdGUgOTAlIG9mIHN5c3RlbSBSQU0gbWludXMg
MSBHaUIgZm9yIENNQSIuIFBlciBOVU1BIG5vZGUuDQo+Pg0KPj4gRXh0ZW5kIHRoZSBDTUEgcGFy
c2VyIGxvZ2ljIHRvIGFjY2VwdCBjb21tYW5kIGxpbmUgb3B0aW9ucyBsaWtlIHRoaXM6DQo+Pg0K
Pj4gICAgY21hX3Blcm51bWE9ODAlIG51bWFfY21hPTA6OTUlLTFHLDE6NEcNCj4+DQo+PiBUbyBh
dm9pZCBpbmNvbXBsZXRlIGFsbG9jYXRpb25zIG9uIHBhcnNpbmcgZXJyb3JzLCBjaGVjayBmb3Ig
dGhlbQ0KPj4gYmVmb3JlIGFjdHVhbGx5IGFsbG9jYXRpbmcuDQo+DQo+IFRoaXMgbG9va3MgbGlr
ZSBhbiBvdmVyLWVuZ2luZWVyZWQgZmVhdHVyZS4gSSBkb3VidCB0aGF0IGtlcm5lbCBpcyB0aGUg
cmlnaHQNCj4gcGxhY2UgdG8gaW1wbGVtZW50IHN1Y2ggYWR2YW5jZWQgc2l6aW5nLiBJZiBZb3Ug
bmVlZCB0byBleHBsaWNpdGx5IGNvbnRyb2wNCj4gdGhlIGFtb3VudCBvZiBDTUEgb24gdGhlIHRh
cmdldCBtYWNoaW5lcywgbWF5YmUgWW91IGNvdWxkIGRvIGl0IGluIHNvbWUNCj4gc2NyaXB0cyBk
ZXBsb3lpbmcgdGhlIGtlcm5lbCBjb25maWd1cmF0aW9uPyBDYWxjdWxhdGluZyBpdCB0aGVyZSBz
aG91bGQgYmUNCj4gbXVjaCBtb3JlIGZsZXhpYmxlIGltaG8uLi4NCg0KDQpJdCBhbGxvd3MgdG8g
cHVzaCBtb3JlIHBvbGljeSBpbnRvIGEgZ2VuZXJpYyBib290IGltYWdlLCB5ZXMuIEkgc3VwcG9z
ZSANCndlIGNvdWxkIHB1c2ggdGhhdCBwb2xpY3kgaW50byBvdGhlciBiaXRzIG9mIHByZS1ib290
IGxvZ2ljLCBzdWNoIGFzIHRoZSANCkxpbnV4IEVGSSBsb2FkZXIsIGJ1dCBJJ20gbm90IGNvbnZp
bmNlZCBpdCdzIGEgbmV0IHdpbiBmb3Igc2ltcGxpY2l0eS4gDQpQdXNoaW5nIGl0IGludG8gYSBi
b290IGxvYWQgd291bGQgbWVhbiBwdXNoaW5nIGludG8gVUtJIGZvciBVS0ktYmFzZWQgDQpib290
IGZsb3dzLCB3aGljaCBtZWFucyBibG9hdGluZyBzeXN0ZW1kLWJvb3QuIEFnYWluLCBub3QgcmVh
bGx5IGdyZWF0Lg0KDQpJZGVhbGx5IGFsbCBvZiB0aGlzIHdvdWxkIGJlIHBvbGljeSB0aGF0IG9u
bHkgdGFrZXMgZWZmZWN0IGxhdGVyIGF0IA0KYm9vdCwgc28gdGhhdCB3ZSBkb24ndCByZXF1aXJl
IHByZS1ib290IGxvZ2ljIG9yIGEgcmVib290LiBGb3IgdGhpcyB0byANCndvcmssIHdlIHdvdWxk
IG5lZWQgdG8gaGF2ZSBMaW51eCByZXN0cmljdCBpdHMgbWVtb3J5IGFsbG9jYXRpb25zIHRvIGEg
DQpzbWFsbCdpc2ggcmVnaW9uIGluc3RlYWQgb2Ygc3ByZWFkaW5nIHRoZW0sIG1heWJlIHRvIHRo
ZSBLSE8gc2NyYXRjaCANCnJlZ2lvbiwgb3IgbWF5YmUgYnkgZmF2b3JpbmcgYWxsb2NhdGlvbnMg
aW4gcGh5cyBhZGRyIG9yZGVyLiBBdCBsZWFzdCANCnVudGlsIHRoZSBib290IGlzIGF0IGEgcG9p
bnQgd2hlcmUgeW91IGNvdWxkIHBlcmZvcm0gdGhlIGFsbG9jYXRpb24uIEFuZCANCnRoZW4gd2Ug
d291bGQgYWxzbyBoYXZlIGxhcmdlIHBoeXNpY2FsbHkgY29udGlndW91cyBibG9ja3MgYXZhaWxh
YmxlIHRvIA0KYWxsb2NhdGUgZnJvbSBhbmQgcG90ZW50aWFsbHkgY2hhbmdlIHRoZSB0YWcgdG8g
Q01BLg0KDQpBbnkgdGhvdWdodHMgb24gaG93IHdlIGNvdWxkIGJlc3QgZG8gdGhpcz8NCg0KDQpB
bGV4DQo=

