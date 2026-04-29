Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12980FF8873
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 21:11:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 677BC6B0088; Wed, 29 Apr 2026 17:11:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6285D6B008A; Wed, 29 Apr 2026 17:11:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0066B008C; Wed, 29 Apr 2026 17:11:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDF66B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 17:11:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B38D51A01B1
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:11:27 +0000 (UTC)
X-FDA: 84712839414.19.BB91AC5
Received: from aer-iport-1.cisco.com (aer-iport-1.cisco.com [173.38.203.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 232CB4000A
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:11:22 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cisco.com header.s=iport01 header.b=kV3SoTlH;
	dmarc=pass (policy=reject) header.from=cisco.com;
	spf=pass (imf12.hostedemail.com: domain of danielwa@cisco.com designates 173.38.203.51 as permitted sender) smtp.mailfrom=danielwa@cisco.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777497083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lz90VLojantPNg9Tng5YQ8XduYA787TGkRqKJZJDUrM=;
	b=CtiydiXdV+Eq+QjbCdn2sJxlAzNLIsO3nr4Q+x9wpksUom3jsHhKuti4OgIZq+ZATT+QS3
	qC+7577f7wEjL3GGlWCi0M/RJ7gSdJS0xFzfMKeAGMwaRHbcYLT9cCAnbjvt75aiJIj1ce
	eXZrYMwr7taaDJ7wijiz40bMu/e6C/4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777497083; a=rsa-sha256;
	cv=fail;
	b=ofO98w+QQ23s8J34Ok543HpJXxOPyeHmrVsRyK6N6FeHyqGgRvE1CxY+LJTG4tiwuLtPwH
	953+R5pLlN0zX6ZWoWWAm5BDKSsOsBvlOMR/v/5Yf2ApVEn3ty+brwt7LOAZiA7H1u4nxM
	Vb0QtVBlrxUn86OdiNOXB/hhExWi8W8=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=cisco.com header.s=iport01 header.b=kV3SoTlH;
	dmarc=pass (policy=reject) header.from=cisco.com;
	spf=pass (imf12.hostedemail.com: domain of danielwa@cisco.com designates 173.38.203.51 as permitted sender) smtp.mailfrom=danielwa@cisco.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=933; q=dns/txt;
  s=iport01; t=1777497083; x=1778706683;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lz90VLojantPNg9Tng5YQ8XduYA787TGkRqKJZJDUrM=;
  b=kV3SoTlH/fG865aUtKekPMLKTDVWfZId+6fhwajt+JEsHrbv326ouehu
   IUQcBYXH8WMtgQVtvAZUdPklY910uoFJtowaXJENU30CTKqBY9IvPptoh
   AOT3ZLntNND4K5NndityHsQ1DXXZ4GgnL6pyv9/w3npRIbc98Q5Mii4Zg
   q3trCBl2NTFT5cmVBigYkzzZoeD1uffGTk0emdtk2hk4+2wOFt/BpttNT
   Y9gaDeNKAvJm6m1Hdj1flfC6iiDaVPgd9wrCyHoY1Xe2uz73cax8z3pIJ
   Q4AOydtIfbj8JgU4zNzSk3fiv7CZBErbnjLksY9ai6xW8EaGLDBwtp661
   A==;
X-CSE-ConnectionGUID: LQJNSrZPRiqix2PjyGvwyA==
X-CSE-MsgGUID: sMe9hm4cQIu3ycDasIKdJA==
X-IPAS-Result: =?us-ascii?q?A0A0AQC7c/Jp/8xK/pBaHQEBAQEJARIBBQUBZYEaBQELA?=
 =?us-ascii?q?YFtU4IWEohsA4UshliCJIV6jHGNLg8BAQENAlEEAQGFBgKNMQImNwYOAQIEA?=
 =?us-ascii?q?QEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZbAQEBAxIoPxACA?=
 =?us-ascii?q?QgYHhAQISUCBA4nhVQDAQKrHgGBPQKKKniBNIEB4DAVBYEzAYhXAYpwJxuBS?=
 =?us-ascii?q?USEPz6EQ4ZEBIIigQ6DDYwJUngcA1ksAUsKNQwzcEMDgSkPPAU3ZRI/IR0sH?=
 =?us-ascii?q?zkCOAcFEiERGW6BFHQhC1waDiEkEVlDOFQFgXACdoEoGV8jLANOMQN4PTcUG?=
 =?us-ascii?q?wSPWhOCXpNqgnOQRp9ZCoQcojiDcZQVklIumFikAIUWAgQCBAUCEAEBBoF+J?=
 =?us-ascii?q?oFZcBWDI1IZD9Z6gTUCBwIHDQMLk2UBAQ?=
IronPort-PHdr: A9a23:m8vzrReCr4GqmwED42TTNwnYlGM/gIqcDmcuAtIPkblCdOGk55v9e
 RGZ7vR2h1iPVoLeuLpIiOvT5rjpQndIoY2Av3YLbIFWWlcbhN8XkQ0tDI/NCUDyIPPwKS1vN
 M9DT1RiuXq8NCBo
IronPort-Data: A9a23:ijaU8KkWDhtwLU6kjNn4+WHo5gzBJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIdUW3UMvvbYDPyKotyaomz/BxXvMfdmNRhQAE4rX8wH1tH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+Za31GONgWYubDpIsfPb8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05Fakh2MBMG1N2z
 /0BKSBXVhKSqPyp0ZvuH4GAhux7RCXqFIoSoDRkiDreF/tjGcuFSKTR7tge1zA17ixMNa+CO
 4xDNGYpM0iGOUUTUrsUIMpWcOOAinD5cjBct1u9rqss6G+Vxwt0uFToGIeLI4HaGJsL9qqej
 nnj8jX5B00RDf2CkiuO3nu3p8zDvwquDer+E5X9rJaGmma7wm0VFQ1TUF6TouewgU34XMhQQ
 3H44QInoLJ38AmgScPwGkXj5nWFpRUbHdFXFoXW9T2w90Yd2C7AbkAsRT9aY9tgv8gzLQHGH
 HfQ9z81LVSDaIGodE8=
IronPort-HdrOrdr: A9a23:uFaujq72ZQGjjnl9cAPXwfSCI+orL9Y04lQ7vn2ZFiYlEfBwxv
 rPoB1E737JYW4qKQ8dcLC7VJVpQRvnhPhICRF4B8btYOCUghrYEGgE1/qi/9SAIVywygcz79
 YbT0ETMqyVMbE+t7eE3ODaKadh/DDkytHUuQ629R4EJm8aCdAE0+46MHfmLqQcfng+OXNNLu
 vm2iMxnUvZRZ14VLXdOpAtZZmxm/T70LjdTVotARkh5AOSjTWuxoLbPnGjtCs2Yndk+5tn1X
 LKvTDYy8yY3s2T+1vxxmXT55NZlJ/bzMdfBMuDs84RKj/9oAelboZsVtS5zXMISeeUh2oCoZ
 3pmVMNLs5z43TeciWeuh32wTTt1z4o9jvL1UKYqWGLm729eBsKT+56wa5JeBrQ7EQt+Ptm1r
 hQ4m6fv51LSTvdgSXG4cTSXR0CrDvxnZNiq59Vs5Vsa/pGVFZjl/1GwKqTKuZaIMvO0vFgLA
 CpNrCH2B8ZSyLGU5mThBge/DXlZAVAIv7BeDlBhuWllx5LgXt+00wUgOYbnnsG6dYBbqMs3Z
 WZDkyt/4s+EPP/qslGdbg8aNryBWrXTR3WNmWOZVzhCaEcInrI74X6+bMv+YiRCdY1JbYJ6d
 z8uWljxCUPUlOrDdfL0IxA8xjLTmn4VTPxyttG75w8vrHnXrLkPSCKVVhryqKb0rkiK9yeX+
 z2NINdAvflI2erEYFV3xfmU50XLXUFSsUattsyRlrLqMPWLY/hsPDdbZ/oVffQOCdhXnm6Dm
 oIXTD1KskF5ke3WmXgiByUQH/pclyXx+M4LEEbxZlk9GEgDPw6juFOsyXN2iiiE0w3jpAL
X-Talos-CUID: 9a23:j/MIUGOPXIYLQO5DfBBF0nUOKPgfc2Tc3C3oIV6XF3l4YejA
X-Talos-MUID: 9a23:sAwcrwnyctbdHX7vPSxSdnp5Eco546HyA3ksjM4XsOWNLg1TNxW02WE=
X-IronPort-Anti-Spam-Filtered: true
Received: from aer-l-core-03.cisco.com ([144.254.74.204])
  by aer-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 21:11:21 +0000
Received: from rcdn-opgw-5.cisco.com (rcdn-opgw-5.cisco.com [72.163.7.169])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-03.cisco.com (Postfix) with ESMTPS id 9B3F218000201
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:11:20 +0000 (GMT)
X-CSE-ConnectionGUID: 4FrMuVk4TfSCrLwYXOxCKw==
X-CSE-MsgGUID: JRb56WxSTjyE+THCMNCHDg==
X-IronPort-AV: E=Sophos;i="6.23,206,1770595200"; 
   d="scan'208";a="54733073"
Received: from mail-dm2pr0701cu00104.outbound.protection.outlook.com (HELO DM2PR0701CU001.outbound.protection.outlook.com) ([40.93.13.68])
  by rcdn-opgw-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 21:11:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=L5gD/CVH3pfQNOfiHa4Knp6ov6PR2Xw8eDYuZhN0ZR5jsbYw0aWDt4clHRvtwCJWSDpXecib5h7t/oS7ZzWq8tvQnaF1PI1hidjmxRkwOH4FBaLfbRj64oHQAHDW3cy/dw9HAFY3X46yJkwsovwJMbx2JM0ZpnlJRkpbPzU/LPeMBmIZsvqho6vy1ITc2qDx1d0pBS6ETRwfyYw6Mp9lfMxM4of467VNQrox9h6nio2t2uK4r3Mupj/3Wtgx2w2vg4N2Nyw88oRN4t9DOAm4lg1r4zDTrwYSlq8IvcF49rP1wJ7DDvCRPlViK9vb4UTOfOIDdaTAzs5FQ9C96sRktA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lz90VLojantPNg9Tng5YQ8XduYA787TGkRqKJZJDUrM=;
 b=d0lEw3aZA9nDoGCSR4LWMCdDTmLFVQdPbzOIh5eXPk+bqUnggo6g+zHFpPrPpGiBmDunIFZsvD2nJYFelm7+g+sVKJi1q3ztISoA/8Ic6IoFex6wkAAljgKpUX3RsC8oZAYcDfutvYvVWGZRcu8jKoKym66NI0nYSNTsTSSvM/sJ7Bmk8jjpJbYQC0cATYANhNfXcKDbHPdpHuWAeW3gbkD1MituZ2GpaKIJVRRwbzUnn+gtAzJDW2nyQ1/WeYAnXz9LmqhA55xGUfwVtOjpXUhekkNUbxhlpOXtCMfuUm8ipiteUAgvMclhF44i1x5MkKdudjNdH8fgTKLVXKwTWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from CH3PR11MB8775.namprd11.prod.outlook.com (2603:10b6:610:1c7::5)
 by SA1PR11MB6917.namprd11.prod.outlook.com (2603:10b6:806:2bd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Wed, 29 Apr
 2026 21:11:09 +0000
Received: from CH3PR11MB8775.namprd11.prod.outlook.com
 ([fe80::abf2:ab63:49c7:e31b]) by CH3PR11MB8775.namprd11.prod.outlook.com
 ([fe80::abf2:ab63:49c7:e31b%6]) with mapi id 15.20.9870.016; Wed, 29 Apr 2026
 21:11:09 +0000
From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, "Darko Tominac -X (dtominac
 - GLOBALLOGIC INC at Cisco)" <dtominac@cisco.com>, Masami Hiramatsu
	<mhiramat@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar
	<mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim
	<namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Alexander
 Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>, Andrew Morton
	<akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann
 Horn <jannh@google.com>, "xe-linux-external(mailer list)"
	<xe-linux-external@cisco.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-trace-kernel@vger.kernel.org"
	<linux-trace-kernel@vger.kernel.org>, "linux-perf-users@vger.kernel.org"
	<linux-perf-users@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Thread-Topic: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Thread-Index: AQHc2ByyZsE/4mJZnUC+JXPldUxtUA==
Date: Wed, 29 Apr 2026 21:11:08 +0000
Message-ID: <afJz3l6435DHLorn@goliath>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com>
In-Reply-To: <afIiqR5CqYRId0N0@redhat.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB8775:EE_|SA1PR11MB6917:EE_
x-ms-office365-filtering-correlation-id: 873f1286-b8c8-4a67-6915-08dea633d58f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|22082099003|56012099003|18002099003|38070700021;
x-microsoft-antispam-message-info:
 EavewLdqqm1BmYhzRadeRe7wiHIh3M+lp9hGQ2uwNQhekzObUtSZ9cD6xJLIRBmcCoF6kcPcWT23sHIpv2i1Xpw3o1vuY8arWFcBQ2qoZtJhKKd6tR6XPcfvd1WsuK7GTPkZUmhYcfOEotdkbgNc4jpFWmUbywsRsZLEdQOUDR7XQjOFdQQrnGOV7ak1ghFd4YBXS+tRIcZTjXFrjz69I6rhnmFDHStIGjSxdkYodaGHqTspI8IYEWRdcgSPyvlkw60mqYny+si0DrYaw9LBhRmZq0AwAWFHWeBDzccIeVT1XQCN5FQpjJjhn6BJibQWBzzDqFXAtZmcxI7X89EuQrWU5cHp4tX7KVk1ypBh8rgR8X+vR3Nf9pLg0ZyWivC3oiQv+xI2HKgf6+Ab4kaFeYQy0SPW09DRYkhJ1DF8maX9vBohtYZmNnr953Kt2J4TV7YUhiQIqMeq8RECJ8MTJU2r0p6dvNMXSOszpPxxS6S3IL2vQ69/4kVdxEDLRsXWHDqMVS9HaxbdMbAUnIztWI2aQj1ctAq+IUOsuiYF7wSuSmoI4O/C45grO58NbW1zN/rXOleJKMtvwTNF7ZmUb5KRc+1+yJC2onZwCQ92nKKPKSM9QUkL8/23RjZTKgpVQTUCxnYMn1DBNSjx4bFwkjmjlkbQksNRk8t/EVVAbykVzHdi1F0jzVaeDPg5qJSg9RWvDSsZ2kN5wvQuJdkisRAzzUoWGyClIOkIUeOvDqVQcazgOHlxPSk7plp5LmfXJrcf2Qm6XcjBfZBnaf6iPaxIjVK9PRE5E21cFjxIJyQ=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(22082099003)(56012099003)(18002099003)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?uAquIR9/TEhU5iz9d/mZqDCdmj9B2ycPhIBVeEnhgy+5tkizmBI0Xp0Uv+to?=
 =?us-ascii?Q?m0Q0WCJY/9BRRMz1wrfLF2HCsEQYMJfC5ObEZEXcP9+ISlJdom+wY0kpoM6w?=
 =?us-ascii?Q?4Dqxqu5puTRGmIwvVv2RyGMJ0tySBD5WPQsEgcS82DPKjsLeMyQPTRKi84Ab?=
 =?us-ascii?Q?9cGrs9tdr6uuu2C36EhTfZDPTB1C4vbejeFRzmrtjB7f+CeG2mqjoAXKDdn4?=
 =?us-ascii?Q?qfXFUUd56kNJKXZB7mCqBeW/hyExFqqwnaYzmXPzGPh5eM2LTp56Wjj69LQa?=
 =?us-ascii?Q?4/y7uPJ/BtTm0qy+aRCJqqfRxfc84YhVfOshHzFdkAp+0hDpsVQBUiUnKemr?=
 =?us-ascii?Q?2fEV/XEsDptkWQHyWoR4m7AHPMgJb7Rcg2egz6Q3JyZIaPLzRfMZZ9f0n9hx?=
 =?us-ascii?Q?O42LlWIKjBybGY3OSqtCenox6cVtrObv/Je3lBIwqmtjGzN405LpjN+UMI3F?=
 =?us-ascii?Q?jBsJwuRqKus5DU1jpnoV1RNMe7pc1Q1+U1J48+1hGg8oj7aRZubBFXmeJDcG?=
 =?us-ascii?Q?Jo2ZxGGWvjU+xb/GHckm3r6d/lfcp4AYf6IG9Ibf5Ysn514c3dvzReEz3d1q?=
 =?us-ascii?Q?W7YscBGlVrX3JA2erdCOh6NtBDYavOo/YJA4Ao7YDQ3TmETLwX76ZWi6yfNF?=
 =?us-ascii?Q?4NvBySgMALHFv2EQkT2XoD5E913O24iBIMffHUF2WRhE5doqL6ddES4lTr78?=
 =?us-ascii?Q?wgHtIVPE8UX2FySqLWz5eG3vJB3PE49h18Edh4DLoWawSApE4wXhdYVeZZMc?=
 =?us-ascii?Q?sBrxy+LyrW7bJBneFUwEtmvOLNlne/Vw70pDhOzgME3JFFwLpyMuqTDYC4ko?=
 =?us-ascii?Q?diGbN+UVBzFekMR2wS5CeofiNUP5DVOmZJY9RNSxoLlWBXCutrIA1x5beHYN?=
 =?us-ascii?Q?xUbFpl2g5217L8FjskgEa1NlwCf2MJ9hGCbk6eM4i0sKfP2LuQc/4j03634w?=
 =?us-ascii?Q?GBKaVZwsz54CxSxS43yCVjvAAmLn449Pg9Noxxg+/ciAeaNfe6Vwigdpi7Bs?=
 =?us-ascii?Q?5brFwDM0QUNYRYX7hGkyeIzkwwab0OAwEWgeuOFIcMVSZrfcDzXbVHNHYza5?=
 =?us-ascii?Q?BX87hIMW9JjaPoGTYYKKG5dYBmO/evw6C5ZlmWCPtoTQxgqV7MN8O0YpEhU6?=
 =?us-ascii?Q?53x+okT9Yy/7gLDVcNoeZGC20MZBkobTWKr4ItFwt4/5rndZZ1NPUzDCMq9Z?=
 =?us-ascii?Q?m1dySyFoHDI/PVq0e7qbAkb9LxCzNRq2STgdvk0hvbZTEkRLFE1wvAApPJuF?=
 =?us-ascii?Q?5tDbmhq4P9n1KEVyg9I6r4sZ/Ad+KVmlX3DxjYEGllHMfAi3iZbHSmbBjxo/?=
 =?us-ascii?Q?hLII/EJ47rRKORUH+1Z4IfWbkGE3/DeX9F1x/b30wsSSEvetntoyZvBZu3cg?=
 =?us-ascii?Q?yq+7HGxzsJGa9MqF5QrpJ+r+zPgwmewHeJHTuqQapxDquh8A3okA8prBa9VS?=
 =?us-ascii?Q?pofk6tHzBBmAfrJXIBFy6nVBdyUwSFsNKMN5lRXF5BUf5EwLA+sBbT2L0sqL?=
 =?us-ascii?Q?UIX7l/hg4HLro7iVtm3MGJFPDuTsc4llr13NHkxqD1SE9/VNfHf7Wa2Vbqc3?=
 =?us-ascii?Q?wnTzni8jRdDRQ3sX90JR2///1M3R2mkmOZ1btEvs7gBncygmnOihsA7wljlw?=
 =?us-ascii?Q?Dbyi3vVR8L/nHYC4KyPwow830FsrUeUATlaVZgi1T5djBWbzd4JBVI/YGgDS?=
 =?us-ascii?Q?b9w1VYOa8vq9/c9E0zuk9MftnKuUgfIPK/sOE32c3dL7cuQqndcdkbW1993k?=
 =?us-ascii?Q?cKQE5MAXCw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0820FBFD37C13A40820F7C47397E2063@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	kJFGqiS7khpypLnDXSfk3K+3fdOMZW0wvZ6kFi2+tx0zIBpRlZPUg/VgwJXZpdiqJOUQJPVjid4sdZb9DiIa+NrXMsG//uygV8mNuyBEGOg5RJoBk8TJ/CcExAcj/+sx164f2ipFzPThQM9GzGyA154Bxd7zD+W2DTUwpnWDWMWc6Sye7SBJv6oe80hIiLaxRXpcj82BdOPb1gm1KR3pYrGETHEIjtw1Sdjcr7iySk928K9CmXcqtcND2Sz2B+FJ8RCFkRoFhKd1XuKJW0tGEEJ0in0ZACwmCen58v42bI5CG4H/Z9uJhkF41BK6ooSjTTt6LlsgFpeKwvtPZMSCwg==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8775.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 873f1286-b8c8-4a67-6915-08dea633d58f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2026 21:11:08.8962
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fB9g6yjsYkN3hu7UlU0QkcKLWDJ9FwItlWG9y+Aea2CR3m1+VDrGO3Apz6qA7aJcCgTA8xeDsG91tvTmExmRLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6917
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-5.cisco.com [72.163.7.169];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.169, rcdn-opgw-5.cisco.com
X-Outbound-Node: aer-l-core-03.cisco.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 232CB4000A
X-Rspamd-Server: rspam04
X-Stat-Signature: ruzft8hnnzhhfinjg1o9p893h8oa8o7t
X-HE-Tag: 1777497082-26496
X-HE-Meta: U2FsdGVkX1+BQepMhC2pl35VfcO6LyB9XKfNx/4mQuWXeQYAzz7ZkFMerBmBOc+sFSyyHbI5UBo1wFXlwV4sXlvAhjPi1fgkE1wPsZEl2NebdVwrGCxgR83Q3JvHx/taXgbasTqGOYz0UOlbKvnb0DCsO7mwoPQX5t3ib+ue/9g4GjFwjg6K80+q48hZkHX9NCi+/r4+HUVbfVnTBSMDyyW/4mJ98DwP3/MewKMMjC0vlO+GtU+AoOyg0umrsOERT+4ZzszJVJnjOMTcCCGkSy8I0+twcQC7X+3EsE+zIRl7SHhWYYT+UbQB3TILQBfPAaqlLq+AdDSZGeQbpbzJdj4agQjuiM66e18B24PuOvdl6n9mesZPf6nw0KOqSYGRGFlqZTlNcFx8GrP9Afsl21+1ZUVptzgzjMvUwXWL9LcuMArrZkmJyV8xXDu3DA5gXZ60L2EilzZhcuyN7p46ew3Fl5e6Skhv7dXWXUKS53D+7juqWe50+09hqDlHpJ9VU9p5gYNzJVKGjqs131GUygr6233v476kBRzcuRXwC5WXYrgOXpl30OE606RUBpNpiO6vONriwkrkL4AfwekypcraeMfzIrZo7VR5+R5n2tsZla2gCog6fljCTQqvM5+kBpiqd2ymXZGKJoVKw/n935aulzKwACUHjnioFvtlteGkl9I+CeXqsB/Z7zjT56gYY+k5O6hYKTkt6dfJfLGJXxxH/69IKC/tYKdNT4pjeO/dEif3AWgT61sBU9AOsdkANBUcM1txIKHcvC+aikJRcVr+Y6h+gpE2qJQrjGYf5Kw36EJ4y+M/ShYvuxZTblFuSLVkGS82FhIQjenCxiOfuyqMAYRqF+QVp8j82/z8ixLFn7NbJM8ra0THTKExEb3FWrh403EckXCHkNZoHaSsar6DKegSjUzIfWNCjK5vLjz/BI7tT08UWCgEEo8GzkYd4STODioivzocnpTVNwv
 nBUuQZo1
 UQZuGFgP6a6m2doXzsTl502wrfr8hNgmIe+IeJ0axqNhbRTyf137EsisPNYnBYSIxozuVxqau9IBER9gsX3+qZj2bgEfBJ6icGkqW+jh1OONybBnwWBnFssILjbqbQsAuumrwRAE2cv1wEforvCQe2kLKV6z65mH9dB0KLvc8VGNBHCwHaCOgmmShgNrZ+sJ1C/7O0LF6/rmHEeVIeQqR8PLqj7hgwAHxVP05pMFJIUqrgj3k3hzyQ4waUnJOZzt13pxIS9UCD/IhIBd5Fh5VS6n3v7wHuzdHNAwpqPAtHD2zpat9hXG63OvQHygL7oC2xW7WEEkIzKn1igTf0C6eL3pDvpDsJn1VKDxq75uy9EMn/z9SaMRw1r2UXWo2aaMA6YuMwMN75X4LXWDbjFI3w2tZTskcc+cgTewYyPhT2Bqt9Rp5Dy4eODLo+/xZKIiXvrECVc8Mk3k/NDlzfd8B/Os72BCeot4Sj3OzU8Kn1uhBWt6Gixiyp7rx2glD0LgefUcwLCL85Blz3o8O2oKyMrr70wlv8/Dotdr9BrvsYEYWHLBWCtPgkw6uhbyIv5bhFT/1HZgtqpbV35g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 05:24:25PM +0200, Oleg Nesterov wrote:
> On 04/29, David Hildenbrand (Arm) wrote:
> >
> > On 4/29/26 15:15, Darko Tominac wrote:
> >
> > > uprobe infrastructure does not re-instrument pages on individual page
> > > faults (uprobe_mmap() is only called during VMA creation, not on
> > > page-in), the breakpoints are silently lost once the discarded pages =
are
> > > re-read from the backing file.  The probes stop firing with no error
> > > indication, and the only recovery is to unregister and re-register th=
e
> > > affected uprobes.
> >
> > Right. Don't MADV_DONTNEED uprobes, just like you are not supposed to
> > MADV_DONTNEED debugger breakpoints/set data etc. :)
>=20
> Agreed, thanks.


Shouldn't there be some sort of compensation or notification for this, or i=
s each person that
hits this suppose to just scratch their head and send a patch that's reject=
ed?

Daniel=

