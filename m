Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCD3CD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F9E6B0088; Thu, 30 Apr 2026 15:26:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA3C6B008A; Thu, 30 Apr 2026 15:26:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C486B008C; Thu, 30 Apr 2026 15:26:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AEBC6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:26:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B6CC5C017E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:26:13 +0000 (UTC)
X-FDA: 84716203026.12.250853F
Received: from aer-iport-6.cisco.com (aer-iport-6.cisco.com [173.38.203.68])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5A5A2140004
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:26:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=cisco.com header.s=iport01 header.b=iGu5eYbN;
	spf=pass (imf26.hostedemail.com: domain of danielwa@cisco.com designates 173.38.203.68 as permitted sender) smtp.mailfrom=danielwa@cisco.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=cisco.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777577169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6U/fSsX15DqbGbwK1Wo2gYJTEcR8Bx0Mq6XHMjIP9I=;
	b=0Ps5Maz/RJAAJJ+igw+nImbs2gas8xrWx+QyzfEVOsSIH5qXnKn1tAR5M3vXH6+0R7zPV9
	xpZnv8zLoZ4/CYjm5EaAh75R5kUTOvmlJQW2qme/YSpleeZ1YrQhERtGQbai9GTcvd7ryx
	4w56iV2nZ8vx1t3EsG7HLnK1dZ3Mskk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777577169; a=rsa-sha256;
	cv=fail;
	b=u2SUBy+yRjMOsdVgMZUh2Iw4UGelaGlLEUNeX8d7+AVsi3MzR/B8dVDhswgugYtWwnQjRT
	pllSk47LTySjRrKuo/ckQ/PXYIbujtRdYd4GQXu5kxHZQ82GazDc6tDsH7k5ULRhtu0nPd
	zA/Yjy9a9HKLF+tD8tv8UrjIoMi8A8I=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=cisco.com header.s=iport01 header.b=iGu5eYbN;
	spf=pass (imf26.hostedemail.com: domain of danielwa@cisco.com designates 173.38.203.68 as permitted sender) smtp.mailfrom=danielwa@cisco.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	dmarc=pass (policy=reject) header.from=cisco.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=2694; q=dns/txt;
  s=iport01; t=1777577169; x=1778786769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=n6U/fSsX15DqbGbwK1Wo2gYJTEcR8Bx0Mq6XHMjIP9I=;
  b=iGu5eYbNuKvRydaCNAUovJ1S1KyiplSK7jTaa6GV+Z8F2RNwg/QPo2LV
   cSQ+DnAWuJniynZxqNfxhiDiTcujcAaBNp+POPhowfaDIxbQ7E1LX2+c2
   xr93BNWkItSSGZoCFbAlHB0CFtz0datFrVjtglg4S5CblC7bAl2cbha/M
   QZu3f/o4wKqtg8k7T/NEsgU8zVE57zeUOfPt6FjXgD0allC7C4kfBcktN
   SgIn1CkKjDI0Hqbmbo+0fQQfxbxVzLjttzdmoMn/I9aonAcE5NqU9ETcx
   gKtIYp9xMyIaiKB47MmpuShuc7L2+eMup2gxoJ3+P53RLaVL+rAZUITNk
   g==;
X-CSE-ConnectionGUID: o/lOsYHSRxuY6+1UZ9w0BA==
X-CSE-MsgGUID: yuUISwnDRJ6hKc4amURByw==
X-IPAS-Result: =?us-ascii?q?A0BpBQDpq/Np/9RK/pBaHgEBCxIMZYMZKimCKEmEV4NMA?=
 =?us-ascii?q?4UshliCIQOFeoxxjS4PAQEBDQJRBAEBghKCdAIWjRsCJjgTAQIEAQEBAQMCA?=
 =?us-ascii?q?wEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGXIZbAQEBAxIREUUQAgEIGAICJ?=
 =?us-ascii?q?gICAg4hFRACBA4FIoVUAwECqCgBgT0Ciip6gTKBAeAwFQWBBS6IWAGBcIkAJ?=
 =?us-ascii?q?xuBSUSEPz6EQ4NbgmkEgiKBDoMNjBYJSXgcA1ksAUsKNQwzLkJDA4EpDzwFN?=
 =?us-ascii?q?2USPyEdLB85AjgHBRIhERlugRR0IQtcGg4hJBE0BCFCOFQFgXACdoEmGV8jL?=
 =?us-ascii?q?wNObwN4PTcUGwQ9i2EeD4MqDgWBbwJtk2qCc0mPfZ9ZCoQcojiDcZQVklIum?=
 =?us-ascii?q?FikAIUWAgQCBAUCEAEBBoF/JYFZcBWDIlMZD44tFoEUAQ7GfXg9AgcCBw0DC?=
 =?us-ascii?q?5NlAQE?=
IronPort-PHdr: A9a23:JszqBBPbE9EYTLglcn0l6nc2WUAX0o4cdiYP4ZYhzrVWfbvmpdLpP
 VfU4rNmi1qaFYnY6vcRk+PNqOigQm0P55+drWoPOIJBTR4LiMga3kQgDceJBFe9LavCZC0hF
 8MEX1hgl0w=
IronPort-Data: A9a23:0D8n+K0igrl4fLgn//bD5ZNwkn2cJEfYwER7XKvMYLTBsI5bpzABy
 GQaXTqFM6qLNmenKtxxYNiz9UMFuZ+Ez9Q1TAI43Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX4
 rsen+WFYAX7g2IvajpNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGCwYyGpYp2t1NEXx/q
 79BFQJccUiprrfjqF67YrEEasULJcTxeYdasXZ6wHSAVLAtQIvIROPB4towMDUY35wSW6yDO
 4xGNXw1NU6ojx5nYj/7DLoyleGpi33gehVTqUmeouw85G27IAlZjeOza4SEKoTiqcN9j1ulh
 1nZ+UjDIE8aF9fDwD+4yFi9mbqa9c/8cMdIfFGizdZugVuO1ikWDTUVS1Kwor++kEHWZj5EA
 0UZ4G8q6KM17kHuF4C7VByjq3nCtRkZMzZNL9AHBMi24vO8yy6SB3MPSXhKb9lOiSP8bWVCO
 oOh9z8xOQFSjQ==
IronPort-HdrOrdr: A9a23:7nayo63G8xQsoDBEog2AbgqjBY5xeYIsimQD101hICG9Lfbo9P
 xGzc566farslcssSkb6K690cm7LU819fZOkO8s1S/LZniphILaFvAS0WKE+UygJ8SezJ8T6U
 4OSdkFNDSdNykfsS++2njGLz9C+qjGzEnLv5ai854Fd2gDAM8QjXYdNu/YKDwLeOAsP+tBKH
 Po3Ls9m9PWQwVuUi3UPAhjYwHrnay5qLvWJTQ9K1oM7g6IgTm06Lj8PSS5834lOQ9n8PMJy0
 SAtxb2yJmCnpiApyP05iv+/p5WkNzuxp95AtCQis8aEzPoigy5ToVsUb+PsVkO0aKSAVAR/+
 XkklMFBYBe+nnRdma6rV/GwA/7ygsj7Hfk1BuxnWbjidaRfkN+N+NxwaZiNjfJ4Uspu99xlI
 hR2XiCipZRBRTc2Azg+tnzUQ1wnEbcmwtnrQdTtQ0ZbWItUs4JkWUtxjIMLH7GJlOg1GkTKp
 gpMCgb3ocNTbrVVQGFgoAl+q3dYp16JGb1fqFFgL3W7xFm2FZk0kAf2MsT2l0E9J47Vt14wt
 6sCNU1qFmLJfVmM56Uw4w6MJSKI32IThTWPG2IJ1P7UKkBJnLWspbypK44/eewZfUzvdEPcb
 n6IRtlXFQJCgnTINzL2IcO/gHGQW27UziowsZC54Jhsrm5QLbwKyWMRF0njsPl+pwkc4Hmcu
 f2PIgTD+7oLGPoF4oM1wriW4NKIX1bVMEOoN40V1+Hv8qOIIz3se7QdurVOdPWYHsZc3K6Bm
 FGUCn4Jc1G4EzuUnjkgALJU3eoYUD79YIYKtmSwwHS8vl6CmRhiHljtb3i3LD/FdRriN1DQH
 dD
X-Talos-CUID: 9a23:b3s6kW7cZAOF1Lf6Z9ss8wkQPdsUUkbn3GrhfQzhNFQ4V+W/YArF
X-Talos-MUID: 9a23:7GT40QurCrkynCTlss2nlSxfFfx35YiUKh4Nsp5assy5DwZhJGLI
X-IronPort-Anti-Spam-Filtered: true
Received: from aer-l-core-11.cisco.com ([144.254.74.212])
  by aer-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 30 Apr 2026 19:26:07 +0000
Received: from rcdn-opgw-2.cisco.com (rcdn-opgw-2.cisco.com [72.163.7.163])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-11.cisco.com (Postfix) with ESMTPS id DE8FB180007C4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:26:06 +0000 (GMT)
X-CSE-ConnectionGUID: PKjPus/PQqKZCKywQt3YaQ==
X-CSE-MsgGUID: B85EaPBjQ3yjILdvOz2cpg==
X-IronPort-AV: E=Sophos;i="6.23,208,1770595200"; 
   d="scan'208";a="59850953"
Received: from mail-bl2pr08cu00102.outbound.protection.outlook.com (HELO BL2PR08CU001.outbound.protection.outlook.com) ([40.93.4.10])
  by rcdn-opgw-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 30 Apr 2026 19:26:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b3l/S2DeJ4LYIXoFvXWFeTV+x8nJ4xUIzV1cT/KzMnWROq3Yfp1NnS1sdvHLHGuMPNnQu2KxHqCQdwVRmhKtbfCx5mLnZAnrKH9ifDwFteMr6ImDk2gtiuXRHrYVKaU2twzlvy8z/LisfgLDg/HjwbIQmUxwNHTi6lzU4Q48o0kEHxyA6JldISyY5b5pCbyu0jehSoULEPcO8qvUorZoilsPwJkXDrrdrsx4PiQ6+Ck1ChJhSI9i6Xyqg9rY9ahaisUDCGgG8aQfFPVzIZy8jKR92Ix1rUJLuCmys5W5By/MpxMQ7oqB2XhklhwXpTZmS5kc3skwRrPLFihT1YbPfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n6U/fSsX15DqbGbwK1Wo2gYJTEcR8Bx0Mq6XHMjIP9I=;
 b=H0yAp0WcWlhRqCrU2KYHQc8G4oxiMwaM2jTGU+5DzmjTXavlY88IYAOCpHIHa05nCd2hyhgNw7O7yUTr2h/M5a5qeF4fCyU2KPjeu5x5tEq6qFrt12ajvfc+IwXpI37UbJsbib4goWAoH9ffYk7CpRf3Al2xOoLp/NEMIIJvv5KsoC1dGpv+C063Htr49O8576htoa8OFZ7M2NAEpkVGHFv2kdv+SJDXkQ4v3VpEWZChd6L9KVF4Z39jRbLcwr2MiddFEfmkuYlanntJZizJrGhLp1GdNYrmKB/o/sQDHt3Bo15FNUITCjeq67qHKomHGBb4OnrS8So1pJyUOsDNPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
Received: from CH3PR11MB8775.namprd11.prod.outlook.com (2603:10b6:610:1c7::5)
 by SJ0PR11MB5199.namprd11.prod.outlook.com (2603:10b6:a03:2dd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9846.22; Thu, 30 Apr
 2026 19:25:59 +0000
Received: from CH3PR11MB8775.namprd11.prod.outlook.com
 ([fe80::abf2:ab63:49c7:e31b]) by CH3PR11MB8775.namprd11.prod.outlook.com
 ([fe80::abf2:ab63:49c7:e31b%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 19:25:59 +0000
From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
To: Jann Horn <jannh@google.com>
CC: Oleg Nesterov <oleg@redhat.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>, "Darko Tominac -X (dtominac - GLOBALLOGIC INC at Cisco)"
	<dtominac@cisco.com>, Masami Hiramatsu <mhiramat@kernel.org>, Peter Zijlstra
	<peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de
 Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, Mark Rutland
	<mark.rutland@arm.com>, Alexander Shishkin
	<alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, Ian
 Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, James
 Clark <james.clark@linaro.org>, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
	<ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
	"xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Thread-Topic: [PATCH] mm/madvise: preserve uprobe breakpoints across
 MADV_DONTNEED
Thread-Index: AQHc2ByyZsE/4mJZnUC+JXPldUxtUA==
Date: Thu, 30 Apr 2026 19:25:58 +0000
Message-ID: <afOsxsC6MKhkuqKD@goliath>
References: <20260429131522.4049054-1-dtominac@cisco.com>
 <889e4186-9f75-45d3-bd9a-1c90b218a635@kernel.org>
 <afIiqR5CqYRId0N0@redhat.com> <afJz3l6435DHLorn@goliath>
 <CAG48ez0mwkHz=4+PoLv_VmYrQiPqkSQqCSo=3R-ztrQ2zAHUwQ@mail.gmail.com>
In-Reply-To:
 <CAG48ez0mwkHz=4+PoLv_VmYrQiPqkSQqCSo=3R-ztrQ2zAHUwQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-Auto-Response-Suppress: DR, OOF, AutoReply
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CH3PR11MB8775:EE_|SJ0PR11MB5199:EE_
x-ms-office365-filtering-correlation-id: 79f59276-4fc6-41b3-16d0-08dea6ee4f04
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|376014|7416014|18002099003|38070700021|56012099003|22082099003;
x-microsoft-antispam-message-info:
 JOgewtNN5WPq8hyx/5cjOo56zI9CGIiUVVrZX7s/7/MhvBi0FKAFHb3OZ/A6vQqqXGTIbn75N9bFthN6xUbz5XOOJerzG43GVPVrj6xms/bJd9vdhz9FU2qi94KRfVW6l17XpF83BZC+9TpwAqymRFT5vlP/0zDHsE2TL539dDTfhXDftM3/FKZPAeC5NPdKvXinH5CPyPKkGQEzYsjDSOuXP8/9TSSqoKMsfX455/HerG6KHFlckykErKyTtrXIIZWORh3Y+9ZiIkP9OstcmFzENqoujo8BGmA5RVD/GosJOxaViLv38qWs7bdTTjvDmA5dc1SpOudznroE98pKHPlW9G+k7mQja/J1V4Rrjhi3W0LnZAFF4/UyUZ/vBist9LY3NQJ9H52sQnyz/UgYUi8UfjX8m/WyVaon2e+/0sbTGEP1nFKxqBOAG3vjrss8H1d6+HoIjsOIE1LJwsFHheiObrjMgAdd7C8G7/6BC3CfsSgFhHRi53cTm47TBro/zEegnKp/4qBMt0zegfsODnobhYTYCrm4d2IGIrclUU2EpZqEbNjuuYmkz7XkM/PM+xxjFBtKAal2ZrxhG5WXwks9v1RQL9t3eL1Ncys/nVCpS6xwVHadkFsk3mFrF2FUNBH+gLQHnjXa+dwUHta/9dnBSx8D+xHloVkxw6mNJEdhdYQUSmtEIaFDzSfExT5TX+E/q71eWdmunb2yU1cmuTDuyRfjqzdsizNh3Aelzv4e75fCfCVJXrv8k9RYOvlE
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(18002099003)(38070700021)(56012099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?cXZlYmp6N2szK1ZwUzMyMFFwRWE5NXhRSnpuVHhHeEhIZ0V2TzN5N3Q4SHFy?=
 =?utf-8?B?TVY0MnRNWlJPNHNLQjJrVUN3SVBlbmpoeEUrYUJDR0NkR011TjduN1VKN2RY?=
 =?utf-8?B?TW16T3JMUE0vL2dscGZsZHhwMzdSUlZYWmwvVVhBK2U4R3VxZ1BxYzExbzJz?=
 =?utf-8?B?dkZ5WlBOdGF0NzR6TFZmRGZEMEhPdHlmekJRWDE2bUlrc2dSYWw1akdKRWdF?=
 =?utf-8?B?TFh6ZmxoaTVWaHUxemorYnh6MnJzV05IbjNPc05ublRjSWJLTHJpUFhRUHN5?=
 =?utf-8?B?SHkvL2NTSElsTFZpR1I5YjhNTXVvdGFQVU85RnpqU3dvRXRkcDEvY2l0bG01?=
 =?utf-8?B?STFwQUhqSFd4MHEvaC9POUxkbWN1VFFJTExTSThDQ3k3bit1Mm9DT0RISnc4?=
 =?utf-8?B?ZTZCa01XVHA3WUJ5Q3V6VUYvVExiYUZVMkdHVld0NDlLZDFnclZ2U2FBaUhj?=
 =?utf-8?B?L2hKMVRnOC82MXlmclM5NGJzdG40NmNtRk1zOVZzRStqYWN6VDN2UU5aelpn?=
 =?utf-8?B?b0U4TDcySm1DaHlPUUJONGVKMk5ycFB0Qy8zeWd6V2p0c2tWOGU2RjAyOW5K?=
 =?utf-8?B?Tzd5TVFBa2N6bTV1OWgzUWpJZFhrckE2SmpwNkh4NFZsZ0cvM3pYRlZxWjly?=
 =?utf-8?B?UklSKzRQUTRTeElZb3VOQW5FNVcvYWpZcEV4NVF5WDNoamtuaCtOQ2hTN2Rj?=
 =?utf-8?B?dnkvVmpERXEvWkE4RVhNQmQwQm5wZ2s3T2pCQTRnVzdrNEtBVUo5SndwTnRK?=
 =?utf-8?B?TlN5cy9VMHNyOXBKSWZ3SlVDcmZ0R212aHcySmlwM2VsdzEzVmdXdmZYdjFa?=
 =?utf-8?B?SzQ4ZWJlK2pxa1IvREtVN2l3a0daV3gza3JPK3drVEF0ZWNkeXQ0MWNTZXRS?=
 =?utf-8?B?NzJkYllBZktxSmNDR1hDeFJxOW5RbXk0OE12UFp3Q2gvc3lWdlFac3F1NUdr?=
 =?utf-8?B?WWVQKzRZR3pNaytSMHd6OHIreEtmSkowZ0lnRjZaU0w1bXZ6bFU3VTRwQnFp?=
 =?utf-8?B?YmoxWFZvOFF5Q1NEMzRab2NXTCszRDQ3d3hINFNaWm9hTGtpb1lKMll1K3Ew?=
 =?utf-8?B?N0NvK0Z4UHl3TXh6bG5XUy8vVHdPenFMVHUzMnFHbDEyZ21JazFzM083SHE5?=
 =?utf-8?B?R2VUQi9aZ0w1aGdLSU5IM0VIL2FvbVZWU2dRaEQwd3p0MFZFZE5WMEh2TG1F?=
 =?utf-8?B?SnhBazhSbVdqR2VoclN0Yi96OVhzcFJhNHlrU21uTkZXRFM0WVc5bTQ1Mkph?=
 =?utf-8?B?OGZBdHkyOE9pK1FUdGJHd3ZsY1lmQ1IwTXVRaXEwaTFwTlhKd3BFWStEQVov?=
 =?utf-8?B?ajM2YlU1bjd4RWZKT29ZL25sdmJuSUpoY1BIRGhKYzUrYXhoNmNlUFc5RFBT?=
 =?utf-8?B?NTdpZlk0cjlMTDhrM3ZsZm9KWlUwMzRBdDJvVTJLN050YnpQZ3pIaUcwS2Zs?=
 =?utf-8?B?SHorZjVCc0l4bUdQNGpqcFNFZ2QraFprSTdzN3JXNGRJVlc5VVpXa1NXRTFR?=
 =?utf-8?B?Nms0c2VPSlA4R3pUdmp2KzNFTUsrT2lQQmxwQ1BOQkFQSzUxc3VBYWVQZmVx?=
 =?utf-8?B?UCt4ZndCeHdwOHNkaXpZNlRNOGJadDh3M0xTUHlzWWRCZ2hTcXAzQndIbGdp?=
 =?utf-8?B?Rld5WVRESXJ3OElEZTh1dGl4MitPZ2dFOVdrY0NTOE1waUZ5MWxQWmsvc0pt?=
 =?utf-8?B?RlRlMGFJaitTRFVWTmM4THdhZU5WRGNvb1dtS1FFQkQrZGpHbHViNGp4N2Iz?=
 =?utf-8?B?dkRZQjFEUWNJM2NBWHlLQ1Z6T1lXTmxNaHdBZ1ZpbFNENFlSS1grYWtiUkta?=
 =?utf-8?B?K3dmc0hHRytaeTQyRzRPV3U4M00wUmtpVk1zdjd5VSs0NElXT3I3OHpONEVG?=
 =?utf-8?B?a0MvSGloSlhiaS9FZ3ZGNzh2QmFIQVg0L2x1OGtwbVQvSWVUT2tXZGZxS1JK?=
 =?utf-8?B?dTRtU2lrZzMyT0ZaMFZ1MGltYy90RlFMcEwxWDBteTBBK0l2ZU82dHB4NEtC?=
 =?utf-8?B?d0ZYNGpMYWxDWmFGUVpFa0hsNDcxZ2JkUWFlNS94aHF2eWU1aDNsZDlmcmI2?=
 =?utf-8?B?azlsK255SE05eC9INzJ4TFF2b1BOTTJUeHZjR24yellvdnRwcEhLdUwzdkFi?=
 =?utf-8?B?cTBMRk1ZTXdnb2RLSFAwbDN0US8yWDU5bjc5cWd0N3plWU1RcWdGSHlIdU1I?=
 =?utf-8?B?bncyZEZKeHluUmRhZ2t6RnZOdFFxZ2JMRWk2WkhxYjBCeWFadzk1UEtreHhn?=
 =?utf-8?B?d2QrQUtpMG8yOW1zMnVuajVKUlJLb2t4UXBEMDlMTjcwNkI3Smk3eGNjOEI3?=
 =?utf-8?B?dkY5VUhhT3dob2VzTTRIcnEzQlVwVDlXTWdjWGdEM3JSOXBNa3dPQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C2DE3CE4DEE6BD47A8B85467DC713DEA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	mfoo1DEhVrTVbLa+ACa0m6hJr1yoF22dEnYXrhV2K4PziuhjvplFIOUFKk+4HHu4GGpvmB/QKk7h5xgqmN1oCkn/QPrZH+POmj+WyilcGD75JOtB1/T/qf8oP7C5OFrjGwukeMbg4++4ikfQYB5pYAFRwC7Gk3fRKYxhapeFnAbu0lPnN+4ng8j7upLUGuMyROFgv3jkIL85n2DTlS6Qkl5RBqHQbXI8ZGd9MSTooRxy0oKbfLBlN2MhvkBQ73urnX2WARLNWE37dDRGvD4ZVac2Uq3j7tEJP7aPTSgdDGIT5UkzJkwoNEFtgn1rjMLeoTTLn8ga5LG7E2SScxb70w==
X-OriginatorOrg: cisco.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8775.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79f59276-4fc6-41b3-16d0-08dea6ee4f04
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2026 19:25:59.0855
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JaEDY0YgcLewGPmDAudzlmAyd9JLQnY/qzyLbqrOAA8NHIW5GjU6wcJfh0uQF53wmwuEBNJfUAI019I30T674A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5199
X-Outbound-Client-TLS: ANONYMOUS;rcdn-opgw-2.cisco.com [72.163.7.163];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 72.163.7.163, rcdn-opgw-2.cisco.com
X-Outbound-Node: aer-l-core-11.cisco.com
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5A5A2140004
X-Rspam-User: 
X-Stat-Signature: 7cnyozjq4kt3xe5mgsa66xwueh6whab1
X-HE-Tag: 1777577169-787808
X-HE-Meta: U2FsdGVkX19cIjRoMi0GctzZdJISPnw5CdyIxz5Dh1AUYAiL5eTzqL4DlDgH1ow74ql2YE7FPVt69hBcnNSQIAC+jkIAZrjVzcaLkB/r2h7fOkWND7BfYKhsL3EXdIQKunOzyMbwk26IbII4ZuVgJkrq5adYygdiblXeyqVf31atNU6kk7jDDVPeRSwQEIZaYr4+BHJjnEEaE9u8O1cY0UJm9A5FuV80Ua3mq4jiGT8IPq3KIjruyS0bLaen9uN0o7XxSNQ5cZNQR0n0qy+n0r8yKxSrja2vRRsRhe0deF3ak2ltJ++0XnVdz+GDg8IMyXT22sD2Owzqxu/KQuwmPb9jvsRqCm/1YcZG+PFoF/x11YtvshTRgXzCaoBYIbpLOzbDsBlItLDfn0is2ZdlJwp9SlA00pd/+mtAJ9X2luzZpQud2ZeBjkTrpIO80T2OsIblpn+sIfhcE+Bx0eApZY1BdVaKe1S3SNDYmhQ/cMG2E2pmAiMhe7c0F+Rf3Hi1zhrqpli4fXxWQjQ/CyH2UcGdnunPm2PY2c1+4D444dMBr4GTORtucnLsDusyOpagst45M8qU2B59qsxJkvz8LD4jmsbwTZerItp9IL5UiszvwNhUd8Agh/UcqIlmHbccVjZ+jKtE3m7uYwPkoq/iXArTdt8W8uFl6v/gkKrCu54mFtRO0bzFQiNtSqtsnJC5o/G8JdeQOm7y5x9Vbb7XuGDyz/3c6DSV2/mbRm5NIW9rTt6abs8eo6zuQ9Z7K5XMFb+o4WgdJz94WSlg+cDciO2OTwAqqr3EFWeWBBAOGPznua5C2Nnjwfhf4eeiut+e9wFcybXIk4GLIkEdbK1mqFmE3R/WyCGLosj3x+PNRdBHWTwn7SX6bvZ5DF9s+NWNFv9VG+GODME8+yh9xrf/VcJKJbaXa/cGW7QGRizvQ87z8+3SRqjVvKsHarHC/KZuKEGlTRmdwb56d19rF1t
 PFYVm+6q
 G2Tod5DtCzIdZcvomaqvfXsae+Lcljw9LEoUwwW40RYkvFJ5j1Mo5Qt4jw9xDk0LboxRIsNG+h9Wur30bfKm+IA+U4WhVi9+ro4FN3pQarfn6w6uCbEQfqG71DwURDYH6qNvgUlFR8e0BfyHiD0ldE1JQ02YicUrL6UPzLdn3v4GE7vZCbKoT9o7W0jJmAta7OLsH3nVh2o0CvLjUq+CX+oUqAw2+3UxI4UvWkkVEiFyRTjCNTpXRnegoU1k6tWAAqHlBwp4vsYgq5R/vO5euLMkuivqvhZwzM0KIY6tLiw+7TrEHfs60X4jgvTiW/+uR6TG3tMsaD1OyFpXH/TZmSsUY9GhaSmDNB5bzAEKGqoXdZQA3xJ1h2RIpDhCggT5xAb9aafkpWCwA36wAM5VNMjYDJjWjGlavrfsyog32iojjOW1GrBf7zII8hRImbxUKQ7/Yc8UQoXajVIlJQ6H5zJVx94cduHR2KY2d2tdOpmRci9WY7hHq1SORtu/xs1r1zGMIxZBVd+D1G0dvbe1pQTpC/QJ5s30aGjHBolLcOgoDbw7T0rE6SSk83QvXajOcJQZUT8qYyjM8197KB5uoLXD0O6QUxNiXHts1owdIJtXqAcT1rX7z8y88mYoIKZUbDCFApUDuMA9cAes=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCBBcHIgMzAsIDIwMjYgYXQgMDU6MjI6MThQTSArMDIwMCwgSmFubiBIb3JuIHdyb3Rl
Og0KPiBPbiBXZWQsIEFwciAyOSwgMjAyNiBhdCAxMToxMeKAr1BNIERhbmllbCBXYWxrZXIgKGRh
bmllbHdhKQ0KPiA8ZGFuaWVsd2FAY2lzY28uY29tPiB3cm90ZToNCj4gPiBPbiBXZWQsIEFwciAy
OSwgMjAyNiBhdCAwNToyNDoyNVBNICswMjAwLCBPbGVnIE5lc3Rlcm92IHdyb3RlOg0KPiA+ID4g
T24gMDQvMjksIERhdmlkIEhpbGRlbmJyYW5kIChBcm0pIHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4g
PiBPbiA0LzI5LzI2IDE1OjE1LCBEYXJrbyBUb21pbmFjIHdyb3RlOg0KPiA+ID4gPg0KPiA+ID4g
PiA+IHVwcm9iZSBpbmZyYXN0cnVjdHVyZSBkb2VzIG5vdCByZS1pbnN0cnVtZW50IHBhZ2VzIG9u
IGluZGl2aWR1YWwgcGFnZQ0KPiA+ID4gPiA+IGZhdWx0cyAodXByb2JlX21tYXAoKSBpcyBvbmx5
IGNhbGxlZCBkdXJpbmcgVk1BIGNyZWF0aW9uLCBub3Qgb24NCj4gPiA+ID4gPiBwYWdlLWluKSwg
dGhlIGJyZWFrcG9pbnRzIGFyZSBzaWxlbnRseSBsb3N0IG9uY2UgdGhlIGRpc2NhcmRlZCBwYWdl
cyBhcmUNCj4gPiA+ID4gPiByZS1yZWFkIGZyb20gdGhlIGJhY2tpbmcgZmlsZS4gIFRoZSBwcm9i
ZXMgc3RvcCBmaXJpbmcgd2l0aCBubyBlcnJvcg0KPiA+ID4gPiA+IGluZGljYXRpb24sIGFuZCB0
aGUgb25seSByZWNvdmVyeSBpcyB0byB1bnJlZ2lzdGVyIGFuZCByZS1yZWdpc3RlciB0aGUNCj4g
PiA+ID4gPiBhZmZlY3RlZCB1cHJvYmVzLg0KPiA+ID4gPg0KPiA+ID4gPiBSaWdodC4gRG9uJ3Qg
TUFEVl9ET05UTkVFRCB1cHJvYmVzLCBqdXN0IGxpa2UgeW91IGFyZSBub3Qgc3VwcG9zZWQgdG8N
Cj4gPiA+ID4gTUFEVl9ET05UTkVFRCBkZWJ1Z2dlciBicmVha3BvaW50cy9zZXQgZGF0YSBldGMu
IDopDQo+ID4gPg0KPiA+ID4gQWdyZWVkLCB0aGFua3MuDQo+ID4NCj4gPg0KPiA+IFNob3VsZG4n
dCB0aGVyZSBiZSBzb21lIHNvcnQgb2YgY29tcGVuc2F0aW9uIG9yIG5vdGlmaWNhdGlvbiBmb3Ig
dGhpcywgb3IgaXMgZWFjaCBwZXJzb24gdGhhdA0KPiA+IGhpdHMgdGhpcyBzdXBwb3NlIHRvIGp1
c3Qgc2NyYXRjaCB0aGVpciBoZWFkIGFuZCBzZW5kIGEgcGF0Y2ggdGhhdCdzIHJlamVjdGVkPw0K
PiANCj4gSSBndWVzcyB3ZSBjb3VsZCBhZGQgYSBwcl93YXJuX29uY2UoKSB0aGF0IHdhcm5zIHdo
ZW4NCj4gbWFkdmlzZShNQURWX0RPTlRORUVEKSBpcyBjYWxsZWQgb24gYSByZWFkK2V4ZWN1dGUg
ZmlsZSBtYXBwaW5nLA0KPiBhbmQvb3IgKGFzIERhdmlkIHNhaWQpIGFkZCBhbiBleHBsaWNpdCBu
b3RlIGluIHRoZSBtYWR2aXNlKCkgbWFucGFnZQ0KPiBhYm91dCBob3cgdGhhdCBjYW4gaW50ZXJm
ZXJlIHdpdGggc29mdHdhcmUgYnJlYWtwb2ludHMgYW5kIHVwcm9iZXM/DQoNCkl0IGRvZXMgZmVl
bCBsaWtlIGl0J3MgdGhlIGRlYnVnZ2VycyBwcm9ibGVtLiBUaGUgYXBwbGljYXRpb24gZG9lc24n
dCBrbm93IGl0J3MNCmdldHRpbmcgZGVidWdnZWQuIFNvIHRoZSBhcHBsaWNhdGlvbiBkb2VzIHdo
YXRldmVyIGl0IGRvZXMuIElmIEdEQiBpcyBkZWJ1Z2dpbmcNCmFuIGFwcGxpY2F0aW9uIGl0IHNo
b3VsZCBhc3N1bWUgdGhlcmUncyBhIHByb2JsZW1hdGljIG1hZHZpc2UoKSBjYWxsIHdoaWNoIHdp
bGwNCmh1cnQvc3RvcCB0aGUgZGVidWdnaW5nIGZyb20gaGFwcGVuaW5nLiBJdCBzaG91bGQgZW5k
ZWF2b3IgdG8gcHJldmVudCB0aGF0DQpmcm9tIGhhcHBlbmluZy4gVGhlcmUgYXJlIG9wdGlvbnMg
aW4gdXNlcnNwYWNlIHRvIHByZXZlbnQgaXQgZnJvbSBoYXBwZW5pbmcuIEknbQ0Kc3VyZSBtYWR2
aXNlKCkgaXMgbm90IHRoZSBvbmx5IHRoaW5nIEdEQiBoYXMgdG8gd29ycnkgYWJvdXQgdy5yLnQu
IHNjcmV3aW5nIHVwDQp0aGUgZGVidWdnaW5nLg0KDQpOb3RpbmcgaXQgaW4gdGhlIG1hbiBwYWdl
IHNlZW1zIHJlYXNvbmFibGUuDQoNCkRhbmllbA==

