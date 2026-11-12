Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB742606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=oD2dUYJE
Received: by kanga.kvack.org (Postfix)
	id 1EEBC6B05B6; Thu, 12 Nov 2026 07:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EC86B05B7; Thu, 12 Nov 2026 07:54:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F076B05B8; Thu, 12 Nov 2026 07:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D46646B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:54:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81C514056E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:54:14 +0000 (UTC)
X-FDA: 85426460028.17.0BBF4D4
Received: from iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com [107.22.191.150])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26DFC180007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:54:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=oD2dUYJE;
	spf=pass (imf06.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+O/L43N0rD1OIIJdNlF4sFYtNeBllPcPMsQbrfew0dc=;
	b=kpHLj8cs8MvAu1c/AIpxwcN23WpySlYTyACzPV/HKpFKmWCEXW3DFDYkITnumTmPygqRcq
	n9z5GECPcx/X2zsKFYXp1kczvJTSTjVQb314t6Shy+RsCix8RJAjmDpjolzn02rG4+DI9d
	wDL7iQO8WuyH7rPIlYFboyfrM5iX1UU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794488051;
	b=aC7EF11uvNLH3FsbWkMH4xOqj46+QidNU+EDFWQ19g/wCN1b4R/c9QCyr4v9aM93fkgFfv
	+8vF4F2toRBe3864WOtqQs2vvgLXbKo34OWCX3yJBUndaUnYjCU/ZA+BIluyd+nfyQC+Jc
	cKjeybrCuDaNrE/BL26bV+pXRw5ZSgw=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=oD2dUYJE;
	spf=pass (imf06.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488051; x=1826024051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+O/L43N0rD1OIIJdNlF4sFYtNeBllPcPMsQbrfew0dc=;
  b=oD2dUYJE7Y+fC5vRQ6LDN2vwbppmy6IVmTB8cckfsWUWlojqqxohlWwK
   3sSnKPWrxpSLkCvoZNcbIIsZTKlw9H+5KIhvHnU2nxQ3QrcBVMVcbZEzF
   1MnAUc30dASvsSWxid4Paypn1u6h5Q5UyglGS6AN88MigcvFhER3QPqDU
   zmONKYVgoWqiISRpw+irgocVLh1xbgnTWjAcjf6IzOjorm76LU4/yCtsb
   yCnllUDbdFUEFJkHCIZLUItckvxvAqU/rEGNBZR50Z9w987NusdUro7s1
   5sn72tPJ9i2wMBrSRUSGiBnOndbM/P5TC79FqJICnynkgIsyKX5YmR5Eb
   Q==;
X-CSE-ConnectionGUID: VYL+hnjNQMW5mWzJMbMx0Q==
X-CSE-MsgGUID: 2bpywTg2S8G3oaKe77Y6GA==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="31286637"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:54:07 +0000
Received: from EX19MTAUEC002.ant.amazon.com [52.94.133.130:7192]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.92.155:2525] with esmtp (Farcaster)
 id 3425b678-3405-4ef4-9f8b-721cf8dfdf67; Thu, 12 Nov 2026 12:54:07 +0000 (UTC)
X-Farcaster-Flow-ID: 3425b678-3405-4ef4-9f8b-721cf8dfdf67
Received: from EX19EXOUEC001.ant.amazon.com (10.252.135.173) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:54:07 +0000
Received: from BL2PR08CU001.outbound.protection.outlook.com (10.252.134.239)
 by EX19EXOUEC001.ant.amazon.com (10.252.135.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Thu, 12 Nov 2026 12:54:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uXnepA5s8NluPyPi7Kpayp/8tD4VNDqzj4PVYy6kOkAdL6OfG9n8x3kjXgPRb+pV+2sC8PW13glXLbB0elsTzZ3Y7LCx42kTJt8N5Bq0VKikgmVfcYXtgXekMMpfZGAREu8jj+ED/Ka/9iIOoCs37EdL5xYNCL/VjUPoVZLSf94TvojbuN3wvkyl+5/0PSEpVxL1ZcdtCqBkYqL562/Q4/WQa3X9WpRBHjAoo7y6peWosofM4LWpIctyUHvTdENEGDiNxr/RXK522LK3DsV9gEjJMPzXCvwYu7s/yGqwbZVX4ipK0+DJPenjxlSWdOVRaDFeL3Pz/10xmE1va32YBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+O/L43N0rD1OIIJdNlF4sFYtNeBllPcPMsQbrfew0dc=;
 b=NPfpggf4NcUtV3I/u7uGvR7cAQ8oVEm/QDugxUxLX3NxJDhsdsQfOgeJpxBQ7USnn0miw7aEZO2fZ5ShQNhDG+p3+DN+j2cc+nbDTDXsTQdt8WhC9ZLHdExhx6zKO0vxdW3dfqJK6J6u7uCXQ8K7Cbmf4+CxAMhxj8MznxBFmX1lTSe0zHFF3gLpDcpg0D9BdY4dFqKHWbm87q3t/I+YEdWSH4qjrhlqaTAUI7DoN0hV+8NQj0oI+ILssPX0QqHzG3eVgJb+a4WOMefw+qwbYLBPzWTHc1s9hB+KJbNa8P6ungS68kF6OjVrOD4FA5dlr9ydhML8ubB5TY6EiAiSdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from BY3PR18MB4722.namprd18.prod.outlook.com (2603:10b6:a03:3c9::19)
 by DSAPR18MB502825.namprd18.prod.outlook.com (2603:10b6:8:519::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 12:54:04 +0000
Received: from BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219]) by BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219%4]) with mapi id 15.21.0592.009; Thu, 12 Nov 2026
 12:54:04 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 3/4] mm/char-mem: implement huge_fault support for
 /dev/mem
Thread-Topic: [PATCH 3/4] mm/char-mem: implement huge_fault support for
 /dev/mem
Thread-Index: AQHdcqTle0WtQwKpWU+rMc20xa1fmA==
Date: Thu, 12 Nov 2026 12:54:04 +0000
Message-ID: <BY3PR18MB472221C08BB0D4A09763122CC6702@BY3PR18MB4722.namprd18.prod.outlook.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-4-farbere@amazon.com>
 <sashiko-outbox-209832@kernel.org>
In-Reply-To: <sashiko-outbox-209832@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4722:EE_|DSAPR18MB502825:EE_
x-ms-office365-filtering-correlation-id: ac920519-43af-41cf-3dba-08df40bc0821
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|261022075727099003|261022105027099003|261021121427099003|261102123227099003|261028144727099003|261026140227099003|56012099006|10067099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info: fAv/lhRcfpaHhAiI7Cr16vP9iDkIiyOtsotpAWVj1lKNU1ObapMYFM7pRsjYqQ63pFqUBsKQRPEkiz6s81ZZBIbDeeeW828wlq0wOXI70YCpMCDO3e4JR/HygZEP+sDxN0ZoMdnxmdRXSuw/BYrO9mHB/Xx3fQ4+sRO+F1RkiaKL0HcwvoN8+4aXW1ODtsqWCArbbTHEIbOWyxR7eziNz4pgpd6LndsKa6XGW39USHCfOIWH4RLyDsst/9Xbp9NpTbmr+ZXKCmqW1ujM7R0o17IQQhs4kKEK1gVJqS8HjsRv3tgYbjqzf5RlTMY59ztWLkIWr3m9gBMKKeAomY8wHfNP480lHVCPz43py2bf+nCg/haWz6JgqeRMnLsy2sU0n9tKBNnsLDJtmdJGiJpADoRgkyWH/Oj+w/mTKVkancQTUC130hhEfxbWltWaLJDahztxMY0FqyNSzHusn7coWnZCpR3Fal1hzpzaT1D3ltRCVIugysBlC5LvSH4dc7bFfkZnG3l4qoFjPujuXDvsW1xk8HT6Hc554Y2ynGgfK+Za4XAj+wYMOzqQlNCxPhc309GwyMHIpAUJzCcgxSXmqoJpFGv/yKbSpXwBxKftQ8r14O0C9EBkYfbcCxpmaczLg9o3/qXv8lMXEFfwwDgNEiufFAzl4wyJqgVrfBBNAnEwg/hSTjCwcswuLPaoAsi2+Y0q8l91L4ANUOH0DTAG2w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4722.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261026140227099003)(56012099006)(10067099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MnBFeTJGcGRkOHR6eVZOSVJvOTcwT2lSdk1RV3UwaUVFa0JtOURvTmE3eXI4?=
 =?utf-8?B?bG4wYlRiQ1B2c0ttSHplVkxYSWYxZTlGNEIxdTNGaW1aTGVOMW5ZbUE3anRv?=
 =?utf-8?B?U21iZzBqeWYwWlJ6T2hZejRqZldPUmxpN3J4UTYyYUZmVGVLWldrenVSRHFV?=
 =?utf-8?B?SWRkcEN0NTZMSkhVQmFQcUZnRmd2OW8yUG0wVzlYM1NQcTNBY2NYZGY0aksv?=
 =?utf-8?B?VEtWQXI0NDVGb01DNU9yZkhSWURpaHYwMjBYbVNraHhNMUJjenc4a3ViYVBF?=
 =?utf-8?B?cHVoUFdPckY5VCt6TG9VNndCR3hxSU9NSEFmbFVTNVV0cjF1dkEwVExRems3?=
 =?utf-8?B?WjNXM1FmbDM2dCthUmRQNTh4SWRPMmJkU2hnamY3NWwyam1TUzlMSm5rWGtY?=
 =?utf-8?B?OGMrMzRrcjFHRG92Q202ZisvT2JyeUgwSXVjYlJOaGRKRkZEQ043bGdsc0lU?=
 =?utf-8?B?MFlPQXNCR0JnTWlSaWxzck1DSjJ0d2hCQ1pHZVk5VEhrYVdGYjk2MXpJSnB3?=
 =?utf-8?B?cTNjeTBWR1FHUGJzTjNSSWJxNzNPUUk0SndNeWFNampiSTI5T1B4TUxWdDli?=
 =?utf-8?B?dURmWU1jMUQyb3E2dHYxaEdKRHpWaVllT0VsZi9IaWlqcFY2bnFoTnNYMEtU?=
 =?utf-8?B?UlVocEszQnZRTm9udnRURlJDN3BYMUNreHF6VjBtY3kyLzJ6bUZSOUJ5Tll3?=
 =?utf-8?B?UWFVT0dJQXBaRFpnTG1oekxqSXVNVHRFdXJGUlJGa09Odk1PeWFyWFZMLzRQ?=
 =?utf-8?B?cERVNG1NV0tpN0pPSDFFNE5vd0JFZVMzcTd6ZCtyK3lsQnRDODRXZDFWME9j?=
 =?utf-8?B?dEZRSS9wZG85OHFIMTREQ3NUeEFyTCtWVGdKNU5ienZ1Umt1U0lidGxSR3hG?=
 =?utf-8?B?QktnTGNRdUtFUzBmR3A2YnVYbEFjdzh5S0dWRU1OOFd2NmtsbTVwdmtyTE94?=
 =?utf-8?B?UTM2ck01TUlGSnRHczFwSlY1eW5Ud3VFOEhqdTBxNkM4UjNQN2FhTENnMDRj?=
 =?utf-8?B?RkpnSlFPRStqd3RIUC9mdHhhUG1EUjIrTWtxN1ZMblRMKytVZmhBVXRSMlV3?=
 =?utf-8?B?TVhoSFNjMnUwSFNiS2kyZitqaUYzaCtTTXgzMlpsRUNwTUtZMmYyV2hPcXc3?=
 =?utf-8?B?NWxxanZFTW9qVVFieUxQd2VpbjNOYVRuYWJHcHpTSXpxWVhXWVBScVB2YkNT?=
 =?utf-8?B?UUFHNlVYZUpMWEdISW83VVJLaktqVU91TURubm1TMlYxQkRId3JTVWdhcTlC?=
 =?utf-8?B?T3VMUXF3K2NzMHVBWTRSaEdodEZ6bEtGVk9vdTQ5djc3d0NFZ0E1U0xNY010?=
 =?utf-8?B?VzdaV3NSRDRnY3diU0RZNkhmLzhBUDUxOHlPRGwrYVpBNTFlYk9KM0hkcmR3?=
 =?utf-8?B?TFhtc2xQVzVUMzJJZ1hiUFMzQjcvdEZ4SmpnY1p5eUU1dXcxNURXVnIzeFZJ?=
 =?utf-8?B?N1pxQVVSOEM1YlRJU0FtOENsMXA2VmhHTURuVmc1SHE5WXBScVVYLzdWRnhD?=
 =?utf-8?B?cHBMUG5IcmsyTWR5M3ZnUStTM0xhNWJUMzBiTkhCTTNFdis1KzF2ZGNHbmZz?=
 =?utf-8?B?VjFQNzVmR0swYVZGTFVPbGlXZFE5M3VrcCtIY0ZheFNSeU0zUWdHSjNIRGpz?=
 =?utf-8?B?a3dJUmZQdkZRaVluU1BBSnh5dFV1aE9UUFdSdnExZ3JEMW1kby9qR0EvenpS?=
 =?utf-8?B?dkJNSisyZTRTUW1oY2NURFBxVStZcVlBNjB1eW1RejVBaFovcmJrNFVjdHQ3?=
 =?utf-8?B?b014ekd4Ylppbnlic1dUQlJ0TFJkQWVrUEZHazJYeSt0OEZwWTMySWRVeTJ2?=
 =?utf-8?B?cWtHSHMxUFBvUjFnS05FekVlNC8vbzFOZXdKL1d2bHdyU2VzWjd4OWpJMUM3?=
 =?utf-8?B?Vm14R2JQSUR5OVh5dm5WUWg1dGFnaW1IM0NwOUFEaC90ZmxzbVRWd0cvSWRR?=
 =?utf-8?B?UjhhZGVMLzBLZHlaWVNlQU1IWnp6MG5lQTZuZlNqQ2F3aUttSFpRL1NpaURU?=
 =?utf-8?B?QTFnY25SSUxSTVcxSzZtd3lSY1NOMnV4aGRZQVZ5RDRMdENjV3pTdEZTVzZH?=
 =?utf-8?B?cjVtMnNIWGdOWEIvdVBnU0s2d0trbnJkc2hqTDlxY0syVEFGWVMrWml1Z0pY?=
 =?utf-8?B?czVSQjJzSDBqZ0V2QkJNUlZZOGdKRVY4UjljMVMrcnhHaFFXNm41RXpFVmpj?=
 =?utf-8?B?WC9Ick5qaWo3dUtRZFBjVW0rbmtVdVlXUXNrUXBMVU43cGlxOWlxVzNneVcv?=
 =?utf-8?B?dnY4RVY4WUJ4YUMzaUhDRGNubXBkVGoyc2R4VFJWUnlsbFlTRWxkeURnV09I?=
 =?utf-8?Q?th1J/0oLdEsEBB7y/5?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: M9gqJtopTPuKWpvFGUKN9pBxDchy4lY7j6YewQ6aKf5UT/4jVh6sAed0VJEK0DRMTBc/8Ocb4APGeuULy+rSpeMmYSQMm625ixd8XipuRedCyO9RW98J7oq4hcW99DJtGJ0DVc1bPEpRhmQ3MQ2lPBxxZkTGyuhnPtYbd8Uuq4KeKmc6Df36/4I1QS0+dvqlaB1Z+3aFbNTxHBt6sz7wQCQE36tftWNQjkpO8E3OPyOoNXQSst8WWjBEku0dPwz4Is50Lf2jZ3YcWS7FpEKmg/GFNpsadVbrXsmIr6HSv5T5ze50mjDbOlw99n1Dt3GVFp8tZhBRx2QqlymQZ7yCuQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4722.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac920519-43af-41cf-3dba-08df40bc0821
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2026 12:54:04.3967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fg/7JkinOUGyqw8kswGahVDlP42YjvhG+L2g92liebztj24JLODp/vUdhSu46f2StiZxMGMO7/yrSMmxdpuJ6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSAPR18MB502825
X-OriginatorOrg: amazon.com
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ktju48wopt91cb59kwrshqnqg596eayq
X-Rspamd-Queue-Id: 26DFC180007
X-Rspam-User: 
X-HE-Tag: 1794488050-332108
X-HE-Meta: U2FsdGVkX1/l4/1Ets5Cj1Dan9SWBPeNNSvVU8WLXE1rHB4xtKhHHbCoV98nFO96cAC+jU0Vj5lHWRM+VTDIjhP9UPOjTA55H1jcAZOZsL+R925C6xG1nOmjY27CU6gTwTvrfky8XuSUxBGZ1dWvRAhjXLvXJhZp4wxZhHGN0dus+7u5gk/Elx7wZsKLZ9ETMvxh4PxZcuhnmduvACbYtudgbPx/NszzTdcUzowkXkTZo+VloZQ+H9uN5J4+BQTaN8N+AHcvEqoEMqBo8DRF4GrnT4+ZDg3h0zTCIXD1xPZmGZ03uORL745ew33u8p1QRaHI2Wuze08EscBEEr7ALvJ1EKZlBJ5R4HRdvTN2hqkz/lWO895lJN8KVkGcu3GValm6XlCz5otdOQhom6eSWi8futay1IVw5mnE2YkZ6ghW902LAAHSqfSeqJ3hdt6gjeEb1dd8kHvT1JTQRbjm0LOtaLrMWz/2EpbWh5CDp2JGE5DYqy/pGBJNPdetlv6aKbsYsXXbGPkEtske9eUTmQfzO19z5h86g6RYzlUANhyqrmYY6BNo1cWh0uNXHi3xrvOMOO7r8RDqLlBqaD1rRPSB44qlQDFbuBuTJ/9rjzaqWp+Ap/LY/oSBjxwJGtjzNw0hR3R6jIdro4MwF5tKAbN9LT+XONkPJL/hOIR/nsQcbtb7t6vtropcc4nVb1AZKkqxbRLQF0ZNp+hPNgkbBZXkkqsmNppvWl3Yu60HAxoUEbudBJFErMiQ43Dz7lyRwmZrYc3+edd3G8pzyIk+zQxFnCFjJJhJicvr3Pe1PwtMg3g1E4iLrq9cK4K+JeILMbvjzLLo7dH5yGGtNSA959f/7unKY+dtt1pa0lE5XZVLXhKak/ebCUmKWpkXaNx96pG/XfsMjR3ovjxmVmX/n4UV5ySG2JOcaojLjEohVvSDNaFbzV6rtqwkgxEfU84IJdKxkv+9KUC0+Yz9s4Z
 xisYV3qr
 g2r1w8acfOyjc5WH6mQWAzzqAe1Wc3iLk96Eu684c9NMbGzlNcgehCUdaWSDx6Y81HTz44lkazL8FdzJiQlWHbHm/uYW2548edQI1zfEo8oXtSIvVq80gDX3xTj4eiO+bdhsllAWuPdstoGspVIkcEoMkYILqL1wU1KfL6NVzwOogO4neCF4RgPA6I/pTGbvjUQISbO7Rc9WleBhGD5a832VqPGJJGGGVvqx+DqHzYFeeKLF74GV3Gs8fkNwb1rR/yj8lsKJd+upr8exgXhyH+dNxEgZ/eRLipRMkANn5PFp7EkulwJVuKT7qU2ABVVM5Ny6GkfPbWzzuksUIA9K1qC9E6LEneGwufxf8bxt/2yb/U5nl6D3xf+5FakQ/B9KxRzNpDrfmdJpRexTXJ59ldjM8qjv3XoERRDL0+MLyLuEYauZ86GFcy/nb7RA74iz7BNFcjXWlZsuquXKsmKJTq5bwP+VTKpW9Mw0K0fah/mw+6/OT6AYOYiBcSDjPtT3FLIrPoK8W8PV9bUPYQ9JsH7iSVzNp11DpQVFZdpRm3x43dhKBQaCzd8giwBs8gQ+olo02TCxvmz5H0NXOb/nAWg0BIHx/wijAR9jZCR1RV+VIoS1wGBirTsKFHpB0yMc2b234BhHY6cykDQ7J9y93Bd8Rqv0qoGcYL23jnj9N6VhX3z0+RstJ2/gpHxXeBvKvfA52komcIuYMEtbYLCmuGMYBeY5obAjD4VaAfUwfjCbrR4XdMF/C6V6ySmjDW0FRgNabJpQAidQyw447RI6Rrxw/KsNm7wf+ZGUs+stqt1ZXBR39ISrLKU1RiddrIJDYWjaBRLMKw+ddQaRYhK7R94TQPiEvNkHdgMNgAua+nZErXiSJzZECKl4bvONB+9MlgFHHY+9M6c2akHWAvOxI/LWG5+Zau+eXuKGUfCF2WfEgMD01ESQ6wgJnm4vUc4GHGSx6eFvKtpnFjWK+5YQcirouS3oM
 nuuy0Jbm
 TQJu6wTSom+TvPnuEYy81UNP7IGGkMuag7Gg1nqxFNRFS7mWzzWmKsM/VO1jWy4F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gMTEvMTEvMjYsIFNhc2hpa28gQUkgcmV2aWV3IHdyb3RlOg0KPiBbU2V2ZXJpdHk6IE1lZGl1
bV0NCj4gQ2FuIGEgcmVtb3RlIHdyaXRlIHRvIGFuIHVudG91Y2hlZCBvcmRlci0wIHBhZ2UgZmFp
bCB3aXRoIC1FSU5WQUwgd2hlbg0KPiBzb2Z0LWRpcnR5IHRyYWNraW5nIGlzIGFybWVkIG9uIHRo
ZSBWTUE/DQoNCkZpeGVkIGluIHYyOiB2bWZfaW5zZXJ0X3Bmbl9vcmRlcigpIG5vdyBwYXNzZXMg
dGhlIGZhdWx0J3Mgd3JpdGUgZmxhZyBvbg0KdGhlIG9yZGVyLTAgcGF0aCB0b28sIHNvIHRoZSBm
aXJzdCByZW1vdGUgd3JpdGUgaW5zdGFsbHMgYSB3cml0YWJsZSBwdGUNCnJhdGhlciB0aGFuIHJl
bHlpbmcgb24gYSBzZWNvbmQgZmF1bHQgdGhhdCBmaXh1cF91c2VyX2ZhdWx0KCkgbmV2ZXINCnRh
a2VzLiB2bWZfaW5zZXJ0X3Bmbl9wcm90KCkga2VlcHMgaXRzIHNpZ25hdHVyZTsgaXRzIGJvZHkg
bW92ZWQgaW50byBhDQpzdGF0aWMgaGVscGVyIHRha2luZyBta3dyaXRlLg0KDQpJIGNvdWxkIG5v
dCByZXByb2R1Y2UgdGhlIC1FSU5WQUwgaXRzZWxmLCBvbiAvZGV2L21lbSBvciBvbiBlaXRoZXIg
VUlPDQptZW10eXBlLCB3aXRoIGEgdGVzdCB0aGF0IGFybXMgY2xlYXJfcmVmcyA0IGFuZCB0aGVu
IHdyaXRlcyBhbiB1bnRvdWNoZWQNCnBhZ2UgdGhyb3VnaCAvcHJvYy9waWQvbWVtLiBUaGUgY29t
bWl0IG1lc3NhZ2UgdGhlcmVmb3JlIHByZXNlbnRzIHRoZQ0KY2hhbmdlIGFzIGNvbnNpc3RlbmN5
IGJldHdlZW4gdGhlIG9yZGVycyByYXRoZXIgdGhhbiBhIGZpeCBmb3IgYSBmYWlsdXJlDQpJIG9i
c2VydmVkLg0KDQpUaGFua3MsDQpFbGlhdg0K

