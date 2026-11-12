Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22278606A338
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=rwzPwmKI
Received: by kanga.kvack.org (Postfix)
	id 2D69E6B00EF; Thu, 12 Nov 2026 07:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 239E86B05B1; Thu, 12 Nov 2026 07:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA946B05B5; Thu, 12 Nov 2026 07:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1CBC6B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:53:28 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7004A1C3DBC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:53:28 +0000 (UTC)
X-FDA: 85426458096.11.E2FCB59
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf17.hostedemail.com (Postfix) with ESMTP id CECFD40003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:53:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rwzPwmKI;
	spf=pass (imf17.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794488005;
	b=2xDVbWTBNcBFl6ngzP6D18U/9tGofD89ROw8GqW30WvduxqYqDPUJnaR8FTHMuk+0lzJTd
	P4lGeJxcboz75cStT9cfLFZN80Ls0hWoV0p88AzNsQHGFP089G95b3+OwApgcuzmnoNBMU
	tSTfITJVAO7PZ2axmnNB0KV0J9Le1gc=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=rwzPwmKI;
	spf=pass (imf17.hostedemail.com: domain of "prvs=76985aab9=farbere@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=76985aab9=farbere@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794488005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKf/Yo74oUjRTXaddGbnrtxpkMkYjz230OHU5VH5YsE=;
	b=dv+JVtA6QeekPB5rVrQBB5ClD7AtTJc/FtfphMOHgR0tGllbMEYREqdZuu5ltySLb3W5yo
	ekg2vR5uLHndxcMElJIctD8xvuiDkaUASoO9YF2chTk9i9/n3aufNj56oZp53qMdRE6FOK
	2lf1Csdig0ENiu7BCfhm9MS6WS+Cy7U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794488004; x=1826024004;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tKf/Yo74oUjRTXaddGbnrtxpkMkYjz230OHU5VH5YsE=;
  b=rwzPwmKIHop4cu2jwIUU7cpQzWnNkU8I0TSoXokfW0aFjuiKUL2hVWTc
   huIy84BEiLjdamiKYpcc6FXSZ7yPAAPFeJghhzAscwr6MuztNEu78Ysow
   xJX5AQDVBPTddeVS1bhJM9pv877k8oiVVG3q10PaQN+u/eajzi5eGc0b7
   NrD/37yXzY+xLwbEmYrtgMAm3lmUnGLyohVTWR+QOuCm5rvJ+XGEw4D9f
   Fqv0ODAnsXyZY2Bu2mxLxqKAxwB7tWLY6zPoDlMOVFBgVshgPW+ydffHx
   qHAhb5dsnh6HfGGTalkJLt4emottus9rjXB9pvC9AKpGSe2XNYpFTuRB2
   Q==;
X-CSE-ConnectionGUID: YAF0ZwZ0Q+qSB1ZZ5RcXKg==
X-CSE-MsgGUID: 9jbAWJypQIm9jAI7YKXs9w==
X-IronPort-AV: E=Sophos;i="6.27,209,1787011200"; 
   d="scan'208";a="33589278"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 12:53:20 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:2987]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.5.141:2525] with esmtp (Farcaster)
 id 6051b07e-eb99-4536-b92f-478617cdecba; Thu, 12 Nov 2026 12:53:20 +0000 (UTC)
X-Farcaster-Flow-ID: 6051b07e-eb99-4536-b92f-478617cdecba
Received: from EX19EXOUWB001.ant.amazon.com (10.250.64.229) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:53:20 +0000
Received: from EX19EXOUWA001.ant.amazon.com (10.250.64.209) by
 EX19EXOUWB001.ant.amazon.com (10.250.64.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Thu, 12 Nov 2026 12:53:20 +0000
Received: from BYAPR08CU003.outbound.protection.outlook.com (10.250.64.238) by
 EX19EXOUWA001.ant.amazon.com (10.250.64.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56
 via Frontend Transport; Thu, 12 Nov 2026 12:53:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=W6rMTgzP4OSDUaQKILbygp5SSP4wbSH5mAwt/4GNonY1V1KbsnFe4Nai47J3m0hDrKuXAf4RzXUmzT8xRt0jKfVqIvkSHQmXOH7gHobQ0EmAzVCXNwr76QOEv6ZhYgpK+d0Ig+a1FIMu3zxlEC8VBK6VM4EM5SCz4aqIYvN4+1JY3Aw8OhZ22gfSY7Hr4Nyy8UX/fO0Yu3Z9cBUqVg+XCPuecMncr6YkOlXQhnc4MBvljhYvfBub9QQ3xSCN9VKQjuuxcdcj8ciyE+DzYF2JAiXFwmSeomBT4fKHv17P5Dp4bUVV8Vgop5mAVteB2weX3JXRxy61gE6sVpaF3dFQGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKf/Yo74oUjRTXaddGbnrtxpkMkYjz230OHU5VH5YsE=;
 b=H4Es3PD+CV0l1rJCo8FM61VxAx6qwZOJsaMhZ3a7zVlRX4jAfCtCxCuHffi2IDeyTGz9S5tOWb7ogvh7jTTLxh7LD3+ujNnve5qATmDjZHiZfDcQJKZhK49WhohydSmRxZntZW7CNKHXWat0quSBTV6Kw4I1zk1tExsBXfqugcbZXKJ/epGlordSwMplnL0mqwzbJTdKHdwj12cRVNTOaPqy4GOI8Yt6iEw9j8AnkWQ+/8R7mSuqDMbv7JSzuTHxFLTFpEazTRVyMrnatYpbvDhR4eiCS4Ui6L5+fVcjaAK4SlbPn8cuZuBN2smY+FpSy8RmLLALPz1jI4NiqIu48g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.com; dmarc=pass action=none header.from=amazon.com;
 dkim=pass header.d=amazon.com; arc=none
Received: from BY3PR18MB4722.namprd18.prod.outlook.com (2603:10b6:a03:3c9::19)
 by DSAPR18MB502825.namprd18.prod.outlook.com (2603:10b6:8:519::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.615.9; Thu, 12 Nov
 2026 12:53:17 +0000
Received: from BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219]) by BY3PR18MB4722.namprd18.prod.outlook.com
 ([fe80::e307:5f61:2694:b219%4]) with mapi id 15.21.0592.009; Thu, 12 Nov 2026
 12:53:17 +0000
From: "Farber, Eliav" <farbere@amazon.com>
To: "sashiko-reviews@lists.linux.dev" <sashiko-reviews@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>
CC: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: RE: [PATCH 2/4] mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok()
 helpers
Thread-Topic: [PATCH 2/4] mm: add vmf_insert_pfn_order() and
 vmf_pfn_order_ok() helpers
Thread-Index: AQHdcqTJW91ATHw22EGKOL1LwREUbQ==
Date: Thu, 12 Nov 2026 12:53:17 +0000
Message-ID: <BY3PR18MB47226FDD9A957C4935B7B6F4C6702@BY3PR18MB4722.namprd18.prod.outlook.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
 <sashiko-outbox-209831@kernel.org>
In-Reply-To: <sashiko-outbox-209831@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY3PR18MB4722:EE_|DSAPR18MB502825:EE_
x-ms-office365-filtering-correlation-id: 4c38b51d-69bd-4b87-bcc4-08df40bbebfb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014|23010399003|22082099003|18002099003|261022075727099003|261022105027099003|261021121427099003|261102123227099003|261028144727099003|261026121527099003|261026140227099003|56012099006|10067099003|11063799006|4143699003|38070700021;
x-microsoft-antispam-message-info: 9LK0SiGptIMK318SxZTvbZ+sgPokSli6JR5QesOk1eqL46jB8f388GeYg4IAVp4NRZJEZ+jDuZlc17n3z6/oAJfTPxAma7scztRYhAbvrnLuDCd9cVy8rhfL2EgDMLDZBqi4Wh/p/PzhEuwAfqmFxxQkTe0uGkIQU2KfiO1B8z/VQMJrbkXXBSdmzWOYalWVsO/mihLP0b8VOxSDH3YGtdxvxJPUXhmc2vkEmi0pz1txe0/n42TzCWJbQJ03TGoBGUpH13taXCUog8K8wOGuxrbzPVGkuqHl+0EW0wOMIz2jGisn0unU3rvbtOEPy/JbA/pOSFjM/eRtVEKvP53Kw4s0IdRDlPeurBu2r9aaBICEe9iRxBmU2yL4zuJTi+AcJw9X8FbKZuuY3QEoxzAjNC2SaUeHxoSp+JQlOplmYkKebwa1jknaxxMY3UHG4YG9eBK9bXt7DSEZX/1rV1Q5ru1r3yRQWMs+Q6cN8T2F63OrLrRaBwtYOXsFvInN5iqASg1GKqRdGSDKDjOmAu5Q6SwJjMz7WRwDnh8xTsKLrJyz1SnbgW+XIqAewCixvC/1lhc5Vo6yh7YUEGGH8VEYAp0Xss7Hgqz8+QfOQX5N4hDI+dEtmXp4a7CncTin6l6tkICofle/NB1thOYMs8aGZqv1TkFigObH202zf++GX+ZRyrPCM+LDiF7z+QGmmGc3e/i9ixBdWALBOQfMrNSHi4dWVs9/fvNb8upfpQ1biCQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR18MB4722.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(261022075727099003)(261022105027099003)(261021121427099003)(261102123227099003)(261028144727099003)(261026121527099003)(261026140227099003)(56012099006)(10067099003)(11063799006)(4143699003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N3BpdWU0dG5QdjgwdVNZekFVU3pZS2REckVpTGhtay9RUlJmWGZFNzhNWGpl?=
 =?utf-8?B?V2t3Y3hnT0JKSmxPZGp1R3VtUTh4OTJmdnA3QWdtMVN0UGtER3dmK3hiNmFT?=
 =?utf-8?B?TVQzRkhxNFc4dnJyNWo3UHg3UXNjemlibUhPWHVSejUvejJGRTRybUc5Y0Nj?=
 =?utf-8?B?aVpPTmJhaHBiakl5VVBRdVVldjlLWDdnSXhvUnY4dGZBK2hwMjh4VGw0NTVo?=
 =?utf-8?B?R3k4aEtMSG5rVHQrdlZ5VTFBSnVueWtTdzQyS3o0M0s2ZHI3Z3dhQ1d5U1Bs?=
 =?utf-8?B?RHRiUE50NE12R1hqaFBaV3ZEM2pBcHFDNDRHbFNJeEFHWFhUem5kbFlGMzdB?=
 =?utf-8?B?Nk45ZE84elI3RDREWm9KcklFbzJHNDJnSW1EN1NubUtOZzB1TTJBWHZidktW?=
 =?utf-8?B?YTE0S3pPUXJoTU51TlV0NUorNERFTFB4NnV4Yk1sQXNQRlkvUUx5TVYybUtt?=
 =?utf-8?B?cWVzVDUyeFdMQktndHhlV0prbTl5RkpSSitaZGV4WThuMEFvYWNqaWpVU1Zi?=
 =?utf-8?B?d2NIR2dtVzlIMWpNSFU1bkMzTFF2RUNVY3MzSXYyUmR0cytQNlBGbmxRMUZj?=
 =?utf-8?B?alhUdStoUExzY2w1eVdrcHZFQjYxdTdkcXRHWVhMakdhNjIweDRDL250dzNi?=
 =?utf-8?B?OXdneE4zMjQ0L0taYU5LZUhDTnFWZ0ZyaXZ1aEJCekZ1UFZ4bGladFBubGR4?=
 =?utf-8?B?eDVQUE13VUFhcWJSR3VwTmdndmhIeStWa3BCbGpDNnlLUFJwT1lmbitwQWZX?=
 =?utf-8?B?QU5DR1djMVluRWFDQXNiL1Y5Q2JQeFpjN2xFVEU4L2NWZ3Q2ZGgzT1dBbGJL?=
 =?utf-8?B?T1FjQkVpR2pScUg3T3VtWDVCbE1oYWkzRUpoWFROWEtqd2tMTDV5a1JOdTVy?=
 =?utf-8?B?MjU2QVVIanE1SE9PNUVTazFTVFFWNUZRNzRCS2F4QjV4Vm43SFN2Z0FKdElv?=
 =?utf-8?B?aWRBa3IvUjM1dzBKN0ZNM3VGbUhvZHk0ZFI4WWlkSnhicHl1SFdQQUZnWS9w?=
 =?utf-8?B?aWY4T1pTWVcrNUlBWUJxYTJiUy9ncm1NK1pJUHI1bEU2SnNHL1ZibkI5aHJQ?=
 =?utf-8?B?elhFamVSMFAra0F1QmJEZXRpckZ1MFRsVHFlaHhxakIzNHhqaHdGeEFNZFpm?=
 =?utf-8?B?NXlLUFhyZG4waGlnVURmMm1BWG55OTVuTGNOTWdnOFdlSmxLQ1k5dWxxTWhj?=
 =?utf-8?B?RDNJdFJVREFWdWtyQ1YvaHhyZHpqenFzbyt3UDdxY0hyUnVQZ3I5MzBJUXli?=
 =?utf-8?B?V1NaVWd0dmc0SVcrc2luZDNYcDN0aG04UG1RMDJFY1F0RUlBeFUxc0lDQWxD?=
 =?utf-8?B?S2NuWGdCUENEczRlMjdHKy9Ga0x6TVIzT2tUZlVwN2R3MUI5aUVteHRMb2xX?=
 =?utf-8?B?OEcreC8zRk5YZm0wcG5JZ0JmUkJaSUpDTkl6QXhDZXo4WXYwK1pzVjZNdmZl?=
 =?utf-8?B?Q3lJazBuUTljVDFlLzRmRUZHS1dXUGpWWmdWSEMrY0xmSFNtbTZITFkxY3BG?=
 =?utf-8?B?cmRJNTN6cEVBTnBNa1Z3UEJTOXZqdzBjU25ESy9zVW5NMGRzcTAxVTlmTFVr?=
 =?utf-8?B?eHBxS1FDQzZ5bjIwTXkrWExCcXEvT0l1b0hvQ2Z6UVl3WVA1bWhwZkxiMmF2?=
 =?utf-8?B?NFkwaUVwYkRQeDgrb1NkY0FuVTMreVgzN2gxWnZEK1N0SUJSd1dpUjEvZGZl?=
 =?utf-8?B?WEhIS2lVVEpSaEV1VzFHVFNyT3JBME5RN2pkV0FIS2tLRDYrVjRRdUk2cndF?=
 =?utf-8?B?UTRzM2dBMlkyUVM5SG81Q0ZaWlVYQytJbHhYTTJOTURYVW5JeWFxdTVhSG1V?=
 =?utf-8?B?QVhRd2IwY0pTa0J0N2RFWXl6Qlc4NjJVTEZ0QmJ1U1JSWEhGRUk3d1NuYito?=
 =?utf-8?B?eGhWTXc5TVJ0b3JESXN5TmtoakNzcUkxdmsxOGxvVmRaR1NzZGFOZGgvN3pj?=
 =?utf-8?B?U2tRUm1rVzFINDlveFZ3R2VoMlZmdnVucEpPdThnaTY0ZEJsL1dBVmNiSWJj?=
 =?utf-8?B?eVVwS3E2QXJtYzE0SW1qSjNOdHFqQjhEeDdva1BEcWM3NUZLWFR5d3JyL1ZI?=
 =?utf-8?B?UXVCckEzKzZSbUF6U2JnMUZlVFBWRWRLa2p2Vy9xazh3Wm9IdVhxdjlOZU5l?=
 =?utf-8?B?THVRMkhCdm5uT0QrUC85eGt6cWpjNWpKcndZaldQVHZRZ0lCR3hyNnhLaGoy?=
 =?utf-8?B?MHZFQ2pPOWlMVWkwM0MrM2paZHBUcFNTSDRCYnlqS3lZd0J3dkY0RndjbVZl?=
 =?utf-8?B?T1FUbW53ejNBZE5NcnpROFNvYVpXZFAxSW56aWpkejI3dC9HNXNjWjRBSXY0?=
 =?utf-8?Q?XFrxZI88OjPW9xRlzO?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: FuED+JdrOFxiQqgKfGel5XdmqpavikUvtUgzDCeFwmj5UTZIfPaafCz6BtQL3WzZGhQx1WpTxDH75n3IDGyrNeCSTrhZyPBfoxy5yqiScGaWrvH9Eoyrru3AAafij81ygytpWix/gWWCp97p8gCqBL0PfBTtva/peHAkPOVQgiETA94E4dc2qgsh6U6XMoWVcOGwjHIftTzkD6wyFgFspt4grFOjQImd8NRLX3QE8hNo6oJBJLSr0QCNea4BnU65eCIQ35EfwAfBD9fZl4n2HN5qJZoUsI/4CW/fa+VVwhvctmO2QDc7/0oyixjnMCULXKW/bSsYjsGWN7JlSatttw==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR18MB4722.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c38b51d-69bd-4b87-bcc4-08df40bbebfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2026 12:53:17.1820
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZelAui7vMGxZhCLLtmfT02NcJYQaArM0WLPCc9j4bu3u722uvhDDcaDaOLcnqhRV5VzMfdMdk5kLaz3BtmIF0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DSAPR18MB502825
X-OriginatorOrg: amazon.com
X-Stat-Signature: 93dm9axjynr6saobpj95gzbrrbfju986
X-Rspamd-Queue-Id: CECFD40003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794488004-2047
X-HE-Meta: U2FsdGVkX1/9bb4WnzeRfu1gE/i9y4qrnYZkbRqoCkNMK8EzvAtM6Qte7cEVuVmsSn2H26x7v+p1X4qRhtwofamq+w1yMTRzS11HFT0KfASyEMSWZgxMJTSGNesmhWRej3EaVPpiJp8q0PAX7TkA/PDT/PLHPr/9FkqeOPyNAoLzYoLMEJgbesAecD0Y1xhVZX7/atC49j8eztmR+6RqprJxMZ5YPfqxX7rl9RfybsMYCMhwi+EhUFiwTRVMnDHG4uvw0p5ZCCbNDO7Ue/ib/PePezZxeMS18ZoygP5k+u/Wl00lOhCq3AMLo8jxtHRSieS9bMh7U7dqr8ZMLvMfHwRv4tYXMHOHq3bDd3u5MbUMRn1Rn8H+umqYJFMsvL9eBipO1E7lrg3aVYASMy1oPUYpqJXWTe+9KdpiBrJ082v8KLlNoiFv7eAk5AXrjmqsoWiJZqicWK1ll/XQSaTGiBPCCbpwAW9+tUeLUdmBZngOKnpcbC24Sa+I7aqQZz73uvfKqYjKzDPmnd46itvuWqcqZwUoprjQKkQhpGOStkXQIrgtPQovE/Hd0LfqtuzyZ9CHiEFF1WPJuwMnlDWOQGkUyQX4+7Khbyt+z8kuUDFr8822mjkZg62q0IThm8sVsmEEt26E9ln+LIah8eIdIfjc5DqNlnHnIvTcupKugOP96OFi9z1IinFWj2eBiO09HyLSEYKEHtXWN0oBLFrTcUt/gBtuYBGnePWl18I/GW3LgBoqUL4cih15A96URr0UoUkEZpn3NkFNBLAuAPxkzjkAGI6GzA8IZ/HapLuPbK4d0rb1B25PNKsc3/RwK83WggwXixvziSzzg4ttEdXyeHt/twkK5zYs0q5C5KXFOXu0bO8yB5Fn2XAu9o1L91mhRpBHtdVICR+O6ao0dKh3dwbHfsuBwcp9l+ErnwU8IDQZPeIZoM16+U+ceKTjgQ3rL2oJtJ4mAXIGFQHzDy/
 +osB6V0p
 LsPB79k8mO0nAq5a9Qh76ywMLNM890EE7mrbrAUZS/e2pR/Z6bqh7gZXTV1hTaSlISx+scytuig3/OENbSiAz5fZh1WzfR9jB8YNcoxhM5yYJAsTD2050iNBQGGELucIRkTPeZ9AHfhEVgs1nnAtPvmvTeWeZVa+/PRaCK26EK4O8EUC/La+p1BNXw59jmyML1XMovRVzbT6bOe4yWsOj5wgHkuPDP8NHtPnhhXxediOg7Lu4FmenaQ7EDvDedJE1N71gH6TfuMok4Dng53vkLzB7RGfj6kXqsvUzWMZtTsqWSU3DBIfAS5yz7cBwC/YqiD+a51REVohlC/aW2a1b0ktyACCpXLnkEcXBLSvp7TOpcO6pLjyghbZ0Qir+xiXNzL7zCTMvysYQxreWQ+D8mrLrrFHt33UWdOduoHpEhUQVA3sPIheJx/lN2eLD6dkJGZgOR5vU0Biz0jKRh+ZKvbQLB0h39ZVQ+mLcCzeiF25i+R0oyH3cOEDQdJSvX8R+0HT/9jUxhtYoZ1SGlvtL5Ufz81aHbli1T1w8rrKClZ6xQ6tY2YFjH00sy6pRXqT4+2GgJeo/1+QjQ+Ki16Oawvs5iBRNiGQoFpNCRSVA157qD7ApyThGXzyjrXyLPkXoiVPtpaqAyFrJ4GsZMRsGqepco38xdvUD5wAJZTHJ+Nelzb2NvsoMeyLxgKLPJhkXhsHwUM1aYww25P3jw1rLLZielMJngcOocaXtCLljSYKtK01Y1f72fVcuGGQ8iqS1k21xDzQxLwEhNP36oRYOrfgmSFp88Bjv2cPeZ3UVCpyhqQ7E2rWFrQIFwQWvxr3Mw/erWJGz5VZ2K/hBYiVHna/TQEJG64yq3xntliO8yfuobhuRD6i0yv6cSOZO3dE1i4dwmH8vR0kjc1dirrF0hQ4B6ssyvEZ245AZuUwbxAj1d+W+7quaekww6kIm6X3ovoPreypj5sIfkXt3HKK0C/LzoxQM
 3D2jrIjT
 AXSg7d8xKULP2PSLY2yO5/LpMoDYU9Y+QzYUSo45oZ/jgknAxiGsGn5n9w4qlzUn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

T24gMTEvMTEvMjYsIFNhc2hpa28gQUkgcmV2aWV3IHdyb3RlOg0KPiBbU2V2ZXJpdHk6IENyaXRp
Y2FsXQ0KPiBUaGlzIHByb2JsZW0gd2Fzbid0IGludHJvZHVjZWQgYnkgdGhpcyBwYXRjaCwgYnV0
IGNhbiBmYWxsaW5nIGJhY2sgdG8NCj4gb3JkZXItMCBoZXJlIG9yIGRpc3BhdGNoaW5nIHRvIHZt
Zl9pbnNlcnRfcGZuX3BtZCgpIGFuZA0KPiB2bWZfaW5zZXJ0X3Bmbl9wdWQoKSBiZWxvdyBieXBh
c3MgemVyb3BhZ2UgY2hlY2tzIGFjcm9zcyBncmFudWxhcml0aWVzDQo+IFsxXT8NCg0KWWVzLCB0
aGUgYXN5bW1ldHJ5IGlzIHJlYWw6IF9fdm1mX2luc2VydF9wZm5fcHJvdCgpIGNoZWNrcyBpc196
ZXJvX3BmbigpDQpidXQgbm90IGlzX2h1Z2VfemVyb19wZm4oKSwgdm1mX2luc2VydF9wZm5fcG1k
KCkgdGhlIHJldmVyc2UsIGFuZA0Kdm1mX2luc2VydF9wZm5fcHVkKCkgbmVpdGhlci4NCg0KSSBs
ZWZ0IGl0IGFsb25lIGJlY2F1c2UgdGhpcyBzZXJpZXMgZG9lcyBub3QgcmVhY2ggaXQuIFVJTyB0
YWtlcyB0aGUgcGZuDQpmcm9tIG1lbS0+YWRkciwgc28gdXNlcnNwYWNlIHBpY2tzIGEgbWFwIGlu
ZGV4IHJhdGhlciB0aGFuIGFuIGFkZHJlc3MuDQovZGV2L21lbSBkb2VzIGxldCB1c2Vyc3BhY2Ug
bmFtZSB0aGUgYWRkcmVzcywgYnV0IGJvdGggemVybyBwYWdlcyBhcmUNClN5c3RlbSBSQU0sIHdo
aWNoIHJhbmdlX2lzX2FsbG93ZWQoKSByZWZ1c2VzIHVuZGVyIENPTkZJR19TVFJJQ1RfREVWTUVN
Lg0KQW5kIHJlbWFwX3Bmbl9yYW5nZSgpLCB3aGljaCB0aGVzZSBwYXRjaGVzIHJlcGxhY2UsIGhh
cyBubyB6ZXJvcGFnZQ0KY2hlY2sgYXQgYWxsLCBzbyB0aGUgbmV3IG9yZGVyLTAgcGF0aCBpcyB0
aGUgc3RyaWN0ZXIgb2YgdGhlIHR3by4NCg0KVGhlIHZtZl9pbnNlcnRfcGZuX3B1ZCgpIGdhcCBs
b29rcyB3b3J0aCBhIHBhdGNoIG9mIGl0cyBvd24uIElmIHlvdQ0Kd291bGQgcmF0aGVyIHZtZl9p
bnNlcnRfcGZuX29yZGVyKCkgZGVjbGluZWQgYm90aCBhdCBodWdlIG9yZGVyLCBhZGRpbmcNCmlz
X3plcm9fcGZuKCkgYmVzaWRlIHRoZSBpc19odWdlX3plcm9fcGZuKCkgdGVzdCBpcyBhIG9uZS1s
aW5lci4NCg0KVGhhbmtzLA0KRWxpYXYNCg==

