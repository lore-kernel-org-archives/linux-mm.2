Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6852AC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8B6A6B00A1; Wed,  5 Aug 2026 15:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62776B00A3; Wed,  5 Aug 2026 15:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A016B00A4; Wed,  5 Aug 2026 15:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 874B76B00A1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:56:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0501E120591
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:30 +0000 (UTC)
X-FDA: 85068272982.02.5B70D98
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4A536180005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=J6ITFWY2;
	spf=pass (imf06.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785959787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=y+BfWbg4EzsGN71TWNdu3TBzuVjEkXiqTByHFzwkeIo=;
	b=yZBMZbd+HaknKLHbLC0nWgZajh+5NyT/ojiPFIRWGuWxMyeEM6/gs5bVzI0oDVm/mffIF4
	xMcGdMfLqT4ncyKMXtUfElgJCLjZI3WlNNHI5DFM5ZtLYqA+vbVFQ7Q/KOGnBEmHNfKeNm
	7jJe3vLk03F1LS9Yfg0HskMlpevjZpQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785959787;
	b=1Bk+g6klnK/6R8pOWfv2aKVfHW1Cr2iSzzQCYeurcftaa66vE7x9ZMAVLGQ0s8ZzdKoXQ5
	/D257Q2uKrhu6mURggFbFqgUdwnF0JmceMZn7Dwgsybuyzx0/jl8D49JdUUMSBF2qOADaF
	lHPI5SPmj9IdawG1laf8v4bKVDprHVg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=J6ITFWY2;
	spf=pass (imf06.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1785959787; x=1817495787;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to;
  bh=y+BfWbg4EzsGN71TWNdu3TBzuVjEkXiqTByHFzwkeIo=;
  b=J6ITFWY21FBtDNAzTuLYvzCgA+pXHoQM2z5vwiAbwqgXruu6jdFHCt2p
   j1g5r1Wbc3ykbBQ5e8XthTArCrG85yTdrjdgAXTA8vRUmaN+aPGOzdCBZ
   xNffVK35NEO0ZAy4z8xEsp3Lkt3FpBuAhI+8aKoa+shPYEO7wTxxg6Xre
   0mhOgwPvjByr9BScNGn7XR2gYlpnGTXsQ57Eh+lPrgwEjG90Doj1+L/Ry
   2h5OkXAZ4gczX7KYnU7jFkCvXtR8O0tzOBhlXXUiKmwBjxESv8rz8nVRh
   EtTnlEc31Pp+3RNy+tlti8i50QQxge2vmoE2KRkjGWPSYkkjnarrC4PFm
   Q==;
X-CSE-ConnectionGUID: lZe6ARn/QeeARiJz29t+cA==
X-CSE-MsgGUID: SRIc2TJLQdO3EoE2wdcpuQ==
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.25,207,1779148800"; 
   d="p7s'346?scan'346,208,346";a="17320365"
Content-Type: multipart/mixed; boundary="===============3918090059069971927=="
MIME-Version: 1.0
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 19:56:17 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:5813]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.0:2525] with esmtp (Farcaster)
 id eea6d8a9-e951-4547-aad4-9d6cb6f45b52; Wed, 5 Aug 2026 19:56:17 +0000 (UTC)
X-Farcaster-Flow-ID: eea6d8a9-e951-4547-aad4-9d6cb6f45b52
Received: from EX19EXOEUC001.ant.amazon.com (10.252.51.133) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:56:17 +0000
Received: from LO0P265CU003.outbound.protection.outlook.com (10.252.51.199) by
 EX19EXOEUC001.ant.amazon.com (10.252.51.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Wed, 5 Aug 2026 19:56:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=u1WzIiWSDKOrmNslAexPu9kSEQBArB6q4ZDVR0OwmSXNNvvlVeU8o1QJ25es0FDtXLaf6YjAYYwPjFhHUi7DdUSF0rijmiNI7IkkGFQJXmqBU6Z6MfTVY70X6bExkYjE4t83aoaKERZKU1XJi0uGTxiVstG897YW5oma6Nab2IuKoq/RbVe4Z+xGENVFe0ofBMidNHb/4YgGarN9GeVeeUCFtot8WSIpLQTeXkjDg98ru4EY4hiqZjczfU5y1SyfFsptxUIU1Quki4C0qob6gCept6ASSBcoxZ2OnuxkKwVs5UDhIeBiOhZD1Ml6dvyE55HnfaBSW0JSl3Rz425bmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=buYeC+GGkpdiPS2l/VIVx5kvxcJqerXRl31l8JZPK1Q=;
 b=D7BqEKfrPoPHo2Q/5dTac36T/JsmNO/09WQqRbpI5ODEcUsWT4ywUVxeQf5fIBiZgAX8DRn60mpYof5awLUmXsPFKlD34Ye9Lfn5kS1VQl7wZqo7HpewcXFMvCs2b9KMBHxoSwkj2Prua3F8MMPrdD1uE4mJ3iA+ezw+Bq1T0kbaezDiH4AUv8GXwBelvFuzFzGrWZ1b9Og1ASHQHVWlB9JSiRXZxmFWS1Vkpf3EXwm9DzQJbhSSCajNlyYpj8OHJho4ox28myxrRj/gDwOMi/IRJBWR1689Du28yf2NVuKNL+GfjifEoqYy0wqtNDiiotvLBcbbzICj8vEnuTYb9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.co.uk; dmarc=pass action=none header.from=amazon.co.uk;
 dkim=pass header.d=amazon.co.uk; arc=none
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4b4::12)
 by LO0P123MB7404.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:334::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 19:56:08 +0000
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6]) by LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 19:56:08 +0000
From: "Woodhouse, David" <dwmw@amazon.co.uk>
To: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>
CC: "bigeasy@linutronix.de" <bigeasy@linutronix.de>, "peterz@infradead.org"
	<peterz@infradead.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"will@kernel.org" <will@kernel.org>, "longman@redhat.com"
	<longman@redhat.com>, "boqun@kernel.org" <boqun@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "paul@xen.org" <paul@xen.org>,
	"Stollmaier, Carsten" <stollmc@amazon.de>, "dwmw2@infradead.org"
	<dwmw2@infradead.org>, "Woodhouse, David" <dwmw@amazon.co.uk>,
	"daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>, "mhocko@suse.com"
	<mhocko@suse.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
	"christian.koenig@amd.com" <christian.koenig@amd.com>, "jglisse@redhat.com"
	<jglisse@redhat.com>, "david@kernel.org" <david@kernel.org>, "ljs@kernel.org"
	<ljs@kernel.org>, "liam@infradead.org" <liam@infradead.org>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 6/7] KVM: x86/xen: Don't dirty track "vCPU info" page
Thread-Topic: [PATCH v3 6/7] KVM: x86/xen: Don't dirty track "vCPU info" page
Thread-Index: AQHdJRR093nvpCORp0KtkoCqn5brJg==
Date: Wed, 5 Aug 2026 19:56:07 +0000
Message-ID: <20260805195528.3853473-7-dwmw@amazon.co.uk>
References: <20260805195528.3853473-1-dwmw@amazon.co.uk>
In-Reply-To: <20260805195528.3853473-1-dwmw@amazon.co.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LOZP123MB8516:EE_|LO0P123MB7404:EE_
x-ms-office365-filtering-correlation-id: 201cf124-5e75-4bc7-14a9-08def32b9741
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|6049299003|1800799024|376014|7416014|23010399003|22082099003|18002099003|11063799006|56012099006|4053099003|38070700021|10067099003;
x-microsoft-antispam-message-info: VYxp/zL0oXjJck84BMA/PiNb47ekWkG76SiGcQ58YZp2zj95Rf3kbMxmyZQl2RI1TtzKguyXIfNd2xGZHPnFLcloo7MacPVftOyux7ntXvH5x4ql/DcqBNnIgb52lNbkqdP87CKNEVOpucrNW6kjeJy2aIhLWzc96JPbjotYdFvT5H77ox+vYDQNgK6+SHobry98C7+r2W130rY8cmJPaf63ai7m5e6F326H0hhZtGdWnp6Ep6GYS01zgUSZnssFQ9EmFTjyX7c4hCe24iUCLSbeDZ4oswxdIglSlfAhNclFT7Wp+fMff3dPm0jWrm9rzDpo9BCOHMlPe7y2HbKh0xYz0bC4nMhhXpQDkaJYKOMCWWy18drQIJhjhTtlkNZ2D8yZPT7hO/9ArbX5IrhKHPbrL2Hr8RYqwP6rNbkcQpq30/fLqY6XEl5MzZKR1LoI1rDQ7bvLtierWzHZfcS3fI6VNqM0RwiO+p9f7rvD//i1p1Rro4xeFfakEfoK7OJeqCrj2VOPB43/oxRpWxojNU2Z2ZWau8ouOBfRdBje36so1zviy0SD79ODVjnOyf1PvvELA5qmfQQFa4/DSrivCOD9cPxESAcjU28LEUpSTiU7nHXeXAXq2ZObWTaMsgbYgd2ouQTsDFZt/GibIHknbFVNqgkYR/nWdUGEet9k+ipiUu+YKhbXcV/fMTxA3LbBWvIt/my1wE2C1pu+ox4M2H6/eDyGv/fB0rfHwMPi0SU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(6049299003)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(4053099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?g2sg66XvXh+ed1NAgh55FlJbd8tiLtVrqoQ0cFSbVpNPQ33NIv1z0QZ7Ov?=
 =?iso-8859-1?Q?97DxJ6GJ8+M//D1n46YWx2WD5Wm5h22kHXR9B3FpAwGeCp3DnGhhh66cei?=
 =?iso-8859-1?Q?/WKcx+6vnjWzK3syJpGba9RfA+KKVzHF/5vrP0EG4I+zAOUpA0d3pCoqYo?=
 =?iso-8859-1?Q?Lq3nPcpMUNDn2vtVKxQRJJGoVet95XpVJbuNMIg5bBPnVB5SrBVgi7618M?=
 =?iso-8859-1?Q?mGxqKbN5pWIQLmvmPVBGAS+AYksbLF9JMAP9+W/MSGBFZqu3BlVxI8YzMr?=
 =?iso-8859-1?Q?b9v0Aib8Tseop2o6eyoEMd0b06ZUBfKcPXY+LmyExZAZsE7as7M4ulMrt/?=
 =?iso-8859-1?Q?QUjACZ/iTtQWjvfaC1f5XUATE2HqU3yS9RHBQ3UfuX+Ce7nJvU6C/FP9bI?=
 =?iso-8859-1?Q?tja9wnGDPb5EpmPdIEUOhreEilKXPsXXa9lM9xBItFzapR3MB3LiLW9of1?=
 =?iso-8859-1?Q?zuHPaOnAj47V0bpG7xlw1K74aC8/QUsLSDEKONqwXj6Bp8NMnWfYfTMuEA?=
 =?iso-8859-1?Q?KixuKbgzvPGrmmBd4rRuRqd3zSPY7lMPgo7YtBuXlIP/UvRzgyLfPuzjLQ?=
 =?iso-8859-1?Q?NpuA24YaxADCQ2UKJwCXL6U0ADddKjhw9U9jcXjMx0LtOpviJJ14DB1dRj?=
 =?iso-8859-1?Q?MJW8CC9iNLk5XeXvd1bH7VaYQju2gvcDAYVaJPDHirpCRtg/x20UAaVt4m?=
 =?iso-8859-1?Q?ijqP1PlJySQ/+DSaRV8kJf/hPWE6uvr///lSDcYndhSjNym9kR2TzrQGrg?=
 =?iso-8859-1?Q?YhEIKQ1iXIUPXhLN0tO2Gj4zmP4E/wE5FkPsKbeq9+vOC1qER1c9SUTOAw?=
 =?iso-8859-1?Q?mI/SpTYjb9h/unD/7Txr1xPtQgqGhwurzt3eG+YForE3Xq9w4YLTYXK6UZ?=
 =?iso-8859-1?Q?XroMfa9GbQRXUNw/bHnqvhlDbCa4M1AAEvjKxcQ64Lc2qtmlet0oGYnta6?=
 =?iso-8859-1?Q?5VwsOuxCgeAyXwb+f4q3lsdEAfqsQRuPvZ24TYePHrRy1Z3qFlBqJe4czW?=
 =?iso-8859-1?Q?J5fpMrq7RF3Qt/9+WS4U8moz7qlKdDwI/co4tjut5O4X+OQE6VBbPfdDbg?=
 =?iso-8859-1?Q?i6kBECVZk78AyeLMVwXWGSRfjpUUq7ewnNGz1m19i3MPHoxK7a+kzORy4F?=
 =?iso-8859-1?Q?8NsRhsFWmJOvChw6jwDrQUMWKqJ96Aw6NwLVkVAv2fabut+Xb9ZBbjwZ05?=
 =?iso-8859-1?Q?9MABT3gDqxsDX851vxczp0idQYPPaDcnVxl+GHplDE0nhi5V0PM3fBUPrk?=
 =?iso-8859-1?Q?Nfb08FGV3BDIXuEfqYN6gbJz2sw4QUXUzPXDye9kDvlNXCuaaURrvGaEsi?=
 =?iso-8859-1?Q?Y29uhvm6laeXy+CSkOilzYf0ZHJ2k4h/68j5Dtvr0/fA7USSRwF7qFM7yd?=
 =?iso-8859-1?Q?FzlwEjnu0+Sbt1mXhSFE5roK2VL1LIAQsqWWgA1DHihmEJqItO+7iy3pI7?=
 =?iso-8859-1?Q?s+q9UMSu/6BZehfM9yAB/pOT8rw3ePDp726DXlz9i8vCReldofQU1nQTDO?=
 =?iso-8859-1?Q?lqiL2aVoGrZncbDkV/Ai/i2FeGXAKW7T9uxiOiq1J2QOBo7q5qTo8Bvqyu?=
 =?iso-8859-1?Q?fhfX9/RB/O+Xba5ChH1v9UsWxsqNkAxJ+tlJub9VbDm01kappdI1vGEQs4?=
 =?iso-8859-1?Q?kJNRla0AsfJZnxAvFH9SwCT8yHOOUh2+8WNQN3d49utSOLhFjSrdm8xIfi?=
 =?iso-8859-1?Q?65T9ib3ump8SyEPHhCmsdHm+02ibd3PHJprEN9IoM8ni6rERSYpKuzRrjx?=
 =?iso-8859-1?Q?WnFz+WzdT+1vQSJRmdeCaqBpdwnB9xovvX9i4YEG+w/K1J?=
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ltlx6a4QO2JNchTReHGlzQz43NZ1Wp/OOUmGfI+crLij4I4o1HQtHpqGE9zyN7PgdHJR18mA+6TLlgrMliMKOCVcTdYpf19gnS/iDTFK8ypGXM1OgZ6sWN1D0G0xVB//s5ojaIx8JgOvpsPSPMJf42GOOlda15n79Y3ZJbR+Uobjik8T/ZLngxJYjK6BCt3fBwoY0khYvCZkSz0ZcRofZAcUDlr6bDDBmTYUam0nNoQ4QObQK2gtAUvbS1dWFrjEvCi5Zpw+AeF7TbhNyAeUTDLgdlBftMT/01kAv39OaPwRv7WwdMgPbqNlDskEwj/WDaHEtf6Mc6mT43CGB8jMRg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 201cf124-5e75-4bc7-14a9-08def32b9741
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 19:56:07.9518
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aGeuxBvrxd3l//Nuj7uplc8smOAOJATiPtGqpmFp7b8LBYQEuN1JGfZvIWd8Rm4YAfOUHMZGmDLlzqXf1S9hmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7404
X-OriginatorOrg: amazon.co.uk
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A536180005
X-Rspam-User: 
X-Stat-Signature: b8fiskcm4cikwbp8dpuyy7pre8fo1rf6
X-HE-Tag: 1785959787-3943
X-HE-Meta: U2FsdGVkX1+7iGrcoy0neqxGy4fsiZADMxDLlqiErLK6/anKY2JF9Y7gNQgZgsLb7JNMmVnN92P49ViYVtvp6ecULGD7vwpfN+RCgWawtn45U5dFldrQDymfB3VEq0DI0XkNm6RQsgqlJnSw9szKlSHL6XovPHr+6xCCDwbBAOYfQ18vAhoQJE0Q+HID+ioy6cDFykkn6MtCYa4EP8pSwSWkNjUEYfcdb6lQq9I/5lmbyyk7iL+tGoUxyK3F1jStlOmJ8zv6OR4VXuJBheZFf7x4rNF4XbM/BLNkIS0LeUbT7f0Oz4KIr4OmjnWM23JO3E4vDTKD3cQfIQfrlRYJN7iuH4VhqwVejOO2i6yghOFLFxOqTzlYNxDItaxDk3xYfGtyk43ZNo8qzhAbCJ+3zIY8Bnf90xbMi1G3WSGC6hSgfSLUZG26YB2UUq9vP1EWHEDojLcNURQpKRyVTJjPhGK0cTHBzrWiTIEohTGwC6VdwU4Keo2COakEk5XKwBJWtDfHyp8vXPQXX5WdCSrRLkza1cElAghQE8EJoWSd6YxtalVUpu+66pu9TSfvXIz2A6FD4olpoajfY7mbSn+AIIFPdab8arcuOgQ5JzoTxNjccarWMzEv5WPyCI/CRCLn4tJq831tVifkH1HtMcskwya27HueWndruIwqr9uqIGBFZruiWpWQdL1UxgHDnVzwJf0DBGNDFmg7zeb/9PBxyTYDGtH1psClLETFRIoKdNSFK5b5vVgH1fLcD7i8B0g86VcmtOS49VaW6BBbQtSPkCubd9jHR1yjB2kb3W9Z3Y3pRFY+unplSM695eWAXHQ1KFS1y10Rl9nUkgFCuoc1DVAc0HZWj7ziJcsagzZJdBrfaZ0EkMVHyOo/lWNC6KbN8BZHyTvD7DtJcjn1k1jnESSwAf/v70MTAnpG4+Ri8wJxanMZNetSTmF/Tub86xVNHFxIJg/EKrSrsDrsyB6
 wXqcLUYH
 8AG5bbl+gU+yWADIs/j7yVII1CnbzTaIpStgjiVbRbyE+e+In0LXLsXU6vzv3uNXK2MfGKKl8TgHpklOcIXS80hPJjtWtDcmQkrHL36JtTuk2ddYNBKJgwPFvNjsuzRu+vtioHadKqAOaa1+AOSDNso40KpkCGzAg9cXAoypAR5Wf1Otj1jPyYZRkULM2ldhaHo3f3XkgqZL14N3rsQK0OC6oiK9oJe8JWnOtCM6ked7XMscP3ra4fHJq1FMjNBMQh2NrhjAm78Kaj3vKkk3qyc2Jbk0MdA0Meh9u6RUChmCz0x3VGJoWbKeMW/EbyKB8hx7fxVBvYXxROKeOB7DdL2sd+j3Y/XfRpPurnLFTzn0J6mTb4snvDwLO3ZMgVEnYolSoFKXngkfMZYNGyOM8NfTanb967fl6G9A06Tmfb9Qfiq/6QPlKH3bB5qLk6J6fltT/lTZymx9W0dhTrOmwshtIJ+PVo2Pf6KT7eEoRZ1rkS72VlRhKC1EWOea7OA/9oE5AqqakrG+EzXLutLJ9Nw5bWdPRG+IczGCZBUHGdQ+HBVw8quC3UtNXEuC+wccxOvOOK7P8WyaUzJoplh30widrasorCKcCzMwjfd2AZquqwDJu1sOs4cAIiXMuGFCEHCzqnxS9GPavHkC1ZUqVLrBOnphn8zRuuSVLqVryJH10q7lAV2Bw/rzZYXP+/m2qG0xwqxdrrX//bQxG8hdWXTp9QL35CBHYjPdkRpZigstYOUnFnwpINUzninH/prASBGgjr4jAY/Tyo69smiNvB4eZ/sKbsx/s/dvNs5siP0yzIj/0NbTWg3IKchEAFw1MO5cvL4zUX9jqPIkncM1FofI2kKT9wtF4qDjB+k/OJZbubwnUZGdEGaZUk06+aLQKKu6r0tYu4zKkOhGCYfRWEThfIy+c3EeEWV7uCo6lZm6Lrm6Y4F/N/D7cWDczKk0RIEn7Wi7H/gISB9ExcO/fAqbjTPbh
 LLqTidJI
 c7K9Y55SLGC5LV/6P2mvtdattf6oY9KUv9nCUNGWHxOjzFwAybjifECcZj9pph4Bng8CcbnN5+oezm/s0qPQBVEL8s0/9rbK9DtG2jfdIAnp0DCEGgT56ijbwofIg+fl1JBMK4nCC/wj1XTrO0FxsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============3918090059069971927==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha-256; boundary="----3D7B6D40694C13434FF46B489C2A9DE7"

------3D7B6D40694C13434FF46B489C2A9DE7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

Give the Xen per-vCPU info page the same treatment as the per-VM shared
info page, and never mark it dirty, as KVM clearly relies on userspace to
assume the page is always dirty.  While the page is marked dirty on writes
via kvm_xen_inject_pending_events(), it's not marked dirty when written by
__kvm_xen_set_evtchn_fast().

Furthermore, as was the case with the shared info page, writes in the event
channel fastpath may be done without an active vCPU, e.g. when called via
timer callback or irqfd injection.  I.e. attempting to fix the fastpath
would run afoul of the same issue that was fixed by commit 55749769fe60
("KVM: x86: Fix wall clock writes in Xen shared_info not to mark page
dirty").

Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
---
 arch/x86/kvm/xen.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index ff18d888ed47..9f1a9c93442d 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -659,7 +659,6 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 		WRITE_ONCE(vi->evtchn_upcall_pending, 1);
 	}
 
-	kvm_gpc_mark_dirty_in_slot(gpc);
 	rcu_read_unlock();
 
 	/* For the per-vCPU lapic vector, deliver it as MSI. */
@@ -2308,7 +2307,7 @@ void kvm_xen_init_vcpu(struct kvm_vcpu *vcpu)
 
 	kvm_gpc_init(&vcpu->arch.xen.runstate_cache, vcpu->kvm);
 	kvm_gpc_init(&vcpu->arch.xen.runstate2_cache, vcpu->kvm);
-	kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm);
+	__kvm_gpc_init(&vcpu->arch.xen.vcpu_info_cache, vcpu->kvm, true);
 	kvm_gpc_init(&vcpu->arch.xen.vcpu_time_info_cache, vcpu->kvm);
 }
 
-- 
2.43.0


------3D7B6D40694C13434FF46B489C2A9DE7
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"

MII+PgYJKoZIhvcNAQcCoII+LzCCPisCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gjpEMIIGEDCCA/igAwIBAgIQTZQsENQ74JQJxYEtOisGTzANBgkqhkiG9w0BAQwFADCBiDELMAkG
A1UEBhMCVVMxEzARBgNVBAgTCk5ldyBKZXJzZXkxFDASBgNVBAcTC0plcnNleSBDaXR5MR4wHAYD
VQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsxLjAsBgNVBAMTJVVTRVJUcnVzdCBSU0EgQ2VydGlm
aWNhdGlvbiBBdXRob3JpdHkwHhcNMTgxMTAyMDAwMDAwWhcNMzAxMjMxMjM1OTU5WjCBljELMAkG
A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEY
MBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJTQSBDbGllbnQgQXV0
aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCC
AQoCggEBAMo87ZQKQf/e+Ua56NY75tqSvysQTqoavIK9viYcKSoq0s2cUIE/bZQu85eoZ9X140qO
TKl1HyLTJbazGl6nBEibivHbSuejQkq6uIgymiqvTcTlxZql19szfBxxo0Nm9l79L9S+TZNTEDyg
NfcXlkHKRhBhVFHdJDfqB6Mfi/Wlda43zYgo92yZOpCWjj2mz4tudN55/yE1+XvFnz5xsOFbme/S
oY9WAa39uJORHtbC0x7C7aYivToxuIkEQXaumf05Vcf4RgHs+Yd+mwSTManRy6XcCFJE6k/LHt3n
dD3sA3If/JBz6OX2ZebtQdHnKav7Azf+bAhudg7PkFOTuRMCAwEAAaOCAWQwggFgMB8GA1UdIwQY
MBaAFFN5v1qqK0rPVIDh2JvAnfKyA2bLMB0GA1UdDgQWBBQJwPL8C9qU21/+K9+omULPyeCtADAO
BgNVHQ8BAf8EBAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYI
KwYBBQUHAwQwEQYDVR0gBAowCDAGBgRVHSAAMFAGA1UdHwRJMEcwRaBDoEGGP2h0dHA6Ly9jcmwu
dXNlcnRydXN0LmNvbS9VU0VSVHJ1c3RSU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDB2Bggr
BgEFBQcBAQRqMGgwPwYIKwYBBQUHMAKGM2h0dHA6Ly9jcnQudXNlcnRydXN0LmNvbS9VU0VSVHJ1
c3RSU0FBZGRUcnVzdENBLmNydDAlBggrBgEFBQcwAYYZaHR0cDovL29jc3AudXNlcnRydXN0LmNv
bTANBgkqhkiG9w0BAQwFAAOCAgEAQUR1AKs5whX13o6VbTJxaIwA3RfXehwQOJDI47G9FzGR87bj
grShfsbMIYdhqpFuSUKzPM1ZVPgNlT+9istp5UQNRsJiD4KLu+E2f102qxxvM3TEoGg65FWM89YN
5yFTvSB5PelcLGnCLwRfCX6iLPvGlh9j30lKzcT+mLO1NLGWMeK1w+vnKhav2VuQVHwpTf64ZNnX
UF8p+5JJpGtkUG/XfdJ5jR3YCq8H0OPZkNoVkDQ5CSSF8Co2AOlVEf32VBXglIrHQ3v9AAS0yPo4
Xl1FdXqGFe5TcDQSqXh3TbjugGnG+d9yZX3lB8bwc/Tn2FlIl7tPbDAL4jNdUNA7jGee+tAnTtlZ
6bFz+CsWmCIb6j6lDFqkXVsp+3KyLTZGXq6F2nnBtN4t5jO3ZIj2gpIKHAYNBAWLG2Q2fG7Bt2tP
C8BLC9WIM90gbMhAmtMGquITn/2fORdsNmaV3z/sPKuIn8DvdEhmWVfh0fyYeqxGlTw0RfwhBlak
dYYrkDmdWC+XszE19GUi8K8plBNKcIvyg2omAdebrMIHiAHAOiczxX/aS5ABRVrNUDcjfvp4hYbD
OO6qHcfzy/uY0fO5ssebmHQREJJA3PpSgdVnLernF6pthJrGkNDPeUI05svqw1o5A2HcNzLOpklh
NwZ+4uWYLcAi14ACHuVvJsmzNicwggXeMIIDxqADAgECAhAB/W0w/KPKUagbvGQONQMtMA0GCSqG
SIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxML
SmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNF
UlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTAeFw0xMDAyMDEwMDAwMDBaFw0zODAx
MTgyMzU5NTlaMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxML
SmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNF
UlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIP
ADCCAgoCggIBAIASZRc2DsPbCLPQrFcNdu3NJ9NMrVCDYeKqIE0JLWQJ3M6Jn8w9qez2z8Hc8dOx
1ns3KBErR9o5xrw6GbRfpr19naNjQrZ28qk7K5H44m/Q7BYgkAk+4uh0yRi0kdRiZNt/owbxiBhq
kCI8vP4T8IcUe/bkH47U5FHGEWdGCFHLhhRUP7wz/n5snP8WnRi9UY41pqdmyHJn2yFmsdSbeAPA
UDrozPDcvJ5M/q8FljUfV1q3/875PbcstvZU3cjnEjpNrkyKt1yatLcgPcp/IjSufjtoZgFE5wFO
RlObM2D3lL5TN5BzQ/Myw1Pv26r+dE5px2uMYJPexMcM3+EyrsyTO1F4lWeL7j1W/gzQaQ8bD/Ml
JmszbfduR/pzQ+V+DqVmsSl8MoRjVYnEDcGTVDAZE6zTfTen6106bDVc20HXEtqpSQvf2ICKCZNi
jrVmzyWIzYS4sT+kOQ/ZAp7rEkyVfPNrBaleFoPMuGfi6BOdzFuC00yz7Vv/3uVzrCM7LQC/NVV0
CUnYSVgaf5I25lGSDvMmfRxNF7zJ7EMm0L9BX0CpRET0medXh55QH1dUqD79dGMvsVBlCeZYQi5D
Gky08CVHWfoEHpPUJkZKUIGy3r54t/xnFeHJV4QeD2PW6WK61l9VLupcxigIBCU5uA4rqfJMlxwH
Pw1S9e3vL4IPAgMBAAGjQjBAMB0GA1UdDgQWBBRTeb9aqitKz1SA4dibwJ3ysgNmyzAOBgNVHQ8B
Af8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zANBgkqhkiG9w0BAQwFAAOCAgEAXNR8Dc/3AX1BmWUM
c8VSn8v4z5kGfxvaQxWfngJVV5YU8VI8J4eUKO0fOgE3onb8U1DAhJvGa066jCFPoo5VYpHzaRXY
vIjjxKoL/e+o6UtVKgYgbVV4KRnuXzBcSyQRVf8kmm5eKivuC02ff/cBOJQUlUMHCftgqe4cqxKM
oJpep5hqWW2LPwj7yNFFrxgVZJASD3MoLsXiJE78WOzw9EX+IrPrL47S2UVhBcGXb6h2co+LjDav
vw0FznGN5qZvH2ymcWLF2NCDcgzxZxGJDJwTTHI037zVcd+qcd3huWyMPBJdZdq9VxK2Q2v/5d5N
ZhFRz5mu7Be26HGRjN5J/t01caIVJ5Qcz2HjJrtvo2clIV3m3R0LLmgbO4Kv7INnhdSYUXSxuZmA
if9/eBlceUpgLpJArkw3KizJx2LIDl33NlvK4CUlAbTdGgecdwA/0NzV7D3U+rs/zIXWb3+pLd+5
Avf1l5q1NdrDZ7CHSqkoniOO/1wna+GwT/MH7gAu1FmHy1JBler0R9fuZEFVfI1ZApXdYp3Cue5a
KHSEpZu3kMcMB9/1iTZ0MtYowbCwC+CcTMMc1vzjabVHRoEvooKr02NEcMSN/y0zuq2Pe7VwiK4+
Gc9AKNj8yJC7XZki9VLmWMUfiDFD7ogd18aOPENqHacY3n09FvFi+cqQqP0wggYQMIID+KADAgEC
AhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UE
CBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJV
U1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UE
CBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdv
IExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQg
U2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyjztlApB/975
Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUfItMltrMaXqcESJuK
8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeWQcpGEGFUUd0kN+oH
ox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YBrf24k5Ee1sLTHsLt
piK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewDch/8kHPo5fZl5u1B
0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAUU3m/WqorSs9UgOHY
m8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1UdDwEB/wQEAwIBhjAS
BgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDARBgNVHSAE
CjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2VydHJ1c3QuY29tL1VT
RVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUFBwEBBGowaDA/Bggr
BgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJTQUFkZFRydXN0Q0Eu
Y3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0GCSqGSIb3DQEBDAUA
A4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+xswhh2GqkW5JQrM8
zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9IHk96VwsacIvBF8J
fqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7kkmka2RQb9d90nmN
HdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1eoYV7lNwNBKpeHdN
uO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4KxaYIhvqPqUMWqRd
Wyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL1Ygz3SBsyECa0waq
4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQOZ1YL5ezMTX0ZSLw
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
DTI4MDEwOTIzNTk1OVowgZcxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0
ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMT0wOwYDVQQD
EzRDT01PRE8gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAvrOeV6wodnVAFsc4A5jTxhh2IVDzJXkLTLWg
0X06WD6cpzEup/Y0dtmEatrQPTRI5Or1u6zf+bGBSyD9aH95dDSmeny1nxdlYCeXIoymMv6pQHJG
NcIDpFDIMypVpVSRsivlJTRENf+RKwrB6vcfWlP8dSsE3Rfywq09N0ZfxcBa39V0wsGtkGWC+eQK
iz4pBZYKjrc5NOpG9qrxpZxyb4o4yNNwTqzaaPpGRqXB7IMjtf7tTmU2jqPMLxFNe1VXj9XB1rHv
bRikw8lBoNoSWY66nJN/VCJv5ym6Q0mdCbDKCMPybTjoNCQuelc0IAaO4nLUXk0BOSxSxt8kCvsU
tQIDAQABo4IBPDCCATgwHwYDVR0jBBgwFoAUu69+Aj36pvE8hI6t7jiY7NkyMtQwHQYDVR0OBBYE
FIKvbIz4xf6WYXzoHz0rcUhexIvAMA4GA1UdDwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEA
MBEGA1UdIAQKMAgwBgYEVR0gADBMBgNVHR8ERTBDMEGgP6A9hjtodHRwOi8vY3JsLmNvbW9kb2Nh
LmNvbS9DT01PRE9SU0FDZXJ0aWZpY2F0aW9uQXV0aG9yaXR5LmNybDBxBggrBgEFBQcBAQRlMGMw
OwYIKwYBBQUHMAKGL2h0dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUFkZFRydXN0Q0Eu
Y3J0MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wDQYJKoZIhvcNAQEMBQAD
ggIBAHhcsoEoNE887l9Wzp+XVuyPomsX9vP2SQgG1NgvNc3fQP7TcePo7EIMERoh42awGGsma65u
/ITse2hKZHzT0CBxhuhb6txM1n/y78e/4ZOs0j8CGpfb+SJA3GaBQ+394k+z3ZByWPQedXLL1OdK
8aRINTsjk/H5Ns77zwbjOKkDamxlpZ4TKSDMKVmU/PUWNMKSTvtlenlxBhh7ETrN543j/Q6qqgCW
gWuMAXijnRglp9fyadqGOncjZjaaSOGTTFB+E2pvOUtY+hPebuPtTbq7vODqzCM6ryEhNhzf+enm
0zlpXK7q332nXttNtjv7VFNYG+I31gnMrwfHM5tdhYF/8v5UY5g2xANPECTQdu9vWPoqNSGDt87b
3gXb1AiGGaI06vzgkejL580ul+9hz9D0S0U4jkhJiA7EuTecP/CFtR72uYRBcunwwH3fciPjviDD
AI9SnC/2aPY8ydehzuZutLbZdRJ5PDEJM/1tyZR2niOYihZ+FCbtf3D9mB12D4ln9icgc7CwaxpN
SCPt8i/GqK2HsOgkL3VYnwtx7cJUmpvVdZ4ognzgXtgtdk3ShrtOS1iAN2ZBXFiRmjVzmehoMof0
6r1xub+85hFQzVxZx5/bRaTKTlL8YXLI8nAbR9HWdFqzcOoB/hxfEyIQpx9/s81rgzdEZOofSlZH
ynoSMIIF2DCCA8CgAwIBAgIQTKr5yttjb+Af907YWwOGnTANBgkqhkiG9w0BAQwFADCBhTELMAkG
A1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEa
MBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNh
dGlvbiBBdXRob3JpdHkwHhcNMTAwMTE5MDAwMDAwWhcNMzgwMTE4MjM1OTU5WjCBhTELMAkGA1UE
BhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgG
A1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlv
biBBdXRob3JpdHkwggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCR6FSS0gpWsawNJN3F
z0RndJkrN6N9I3AAcbxT38T6KhKPS38QVr2fcHK3YX/JSw8Xpz3jsARh7v8Rl8f0hj4K+j5c+ZPm
NHrZFGvnnLOFoIJ6dq9xkNfs/Q36nGz637CC9BR++b7Epi9Pf5l/tfxnQ3K9DADWietrLNPtj5gc
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
TU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEBBGUwYzA7BggrBgEF
BQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRkVHJ1c3RDQS5jcnQwJAYI
KwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkqhkiG9w0BAQwFAAOCAgEAeFyy
gSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+jsQgwRGiHjZrAYayZrrm78hOx7aEpk
fNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD7f3iT7PdkHJY9B51csvU50rxpEg1OyOT
8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOd
GCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurf
fade2022O/tUU1gb4jfWCcyvB8czm12FgX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZ
ojTq/OCR6MvnzS6X72HP0PRLRTiOSEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo
9jzJ16HO5m60ttl1Enk8MQkz/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8ao
rYew6CQvdVifC3HtwlSam9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zm
EVDNXFnHn9tFpMpOUvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIwggXY
MIIDwKADAgECAhBMqvnK22Nv4B/3TthbA4adMA0GCSqGSIb3DQEBDAUAMIGFMQswCQYDVQQGEwJH
QjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQK
ExFDT01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9uIEF1
dGhvcml0eTAeFw0xMDAxMTkwMDAwMDBaFw0zODAxMTgyMzU5NTlaMIGFMQswCQYDVQQGEwJHQjEb
MBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFD
T01PRE8gQ0EgTGltaXRlZDErMCkGA1UEAxMiQ09NT0RPIFJTQSBDZXJ0aWZpY2F0aW9uIEF1dGhv
cml0eTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJHoVJLSClaxrA0k3cXPRGd0mSs3
o30jcABxvFPfxPoqEo9LfxBWvZ9wcrdhf8lLDxenPeOwBGHu/xGXx/SGPgr6Plz5k+Y0etkUa+ec
s4Wggnp2r3GQ1+z9DfqcbPrfsIL0FH75vsSmL09/mX+1/GdDcr0MANaJ62ss0+2PmBwUq37l4278
2KjkkiTaQ2tiuFX96sG8bLaL8w6NmuSbbGmZ+HhIMEXVreENPEVg/DKWUSe8Z8PKLrZr6kbHxyCg
sR9l3kgIuqROqfKDRjeE6+jMgUhDZ05yKptcvUwbKIpcInu0q5jZ7uBRg8MJRk5tPpn6lRfafDNX
QTyNUe0LtlyvLGMa31fIP7zpXcSbr0WZ4qNaJLS6qVY9z2+q/0lYvvCo//S4rek3+7q49As6+ehD
Qh6J2ITLE/HZu+GJYLiMKFasFB2cCudx688O3T2plqFIvTz3r7UNIkzAEYHsVjv206LiW7eyBCJS
lYCTaeiOTGXxkQMtcHQC6otnFSlpUgK7199QalVGv6CjKGF/cNDDoqosIapHziicBkV2v4IYJ7TV
rrTLUOZr9EyGcTDppt8WhuDY/0Dd+9BCiH+jMzouXB5BEYFjzhhxayvspoq3MVw6akfgw3lZ1iAa
r/JqmKpyvFdK0kuduxD8sExB5e0dPV4onZzMv7NR2qdH5YRTAgMBAAGjQjBAMB0GA1UdDgQWBBS7
r34CPfqm8TyEjq3uOJjs2TIy1DAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQwFAAOCAgEACvHVRoS3rlG7bLJNQRQAk0ycy+XAVM+gJY4C+f2wog31IJg8Ey2sVqKw
1n4Rkukuup4umnKxvRlEbGE1opq0FhJpWozh1z6kGugvA/SuYR0QGyqki3rF/gWm4cDWyP6ero8r
uj2Z+NhzCVhGbqac9Ncn05XaN4NyHNNz4KJHmQM4XdVJeQApHMfsmyAcByRpV3iyOfw6hKC1nHyN
vy6TYie3OdoXGK69PAlo/4SbPNXWCwPjV54U99HrT8i9hyO3tklDeYVcuuuSC6HG6GioTBaxGpkK
6FMskruhCRh1DGWoe8sjtxrCKIXDG//QK2LvpHsJkZhnjBQBzWgGamMhdQOAiIpugcaF8qmkLef0
pSQQR4PKzfSNeVixBpvnGirZnQHXlH3tA0rK8NvoqQE+9VaZyR6OST275Qm54E9Jkj0WgkDMzFnG
5jrtEi5pPGyVsf2qHXt/hr4eDjJG+/sTj3V/TItLRmP+ADRAcMHDuaHdpnDiBLNBvOmAkepknHrh
IgOpnG5vDmVPbIeHXvNuoPl1pZtA6FOyJ51KucB3IY3/h/LevIzvF9+3SQvR8m4wCxoOTnbtEfz1
6Vayfb/HbQqTjKXQwLYdvjpOlKLXbmwLwop8+iDzxOTlzQ2oy5GSsXyF7LUUaWYOgufNzsgtplF/
IcE1U4UGSl2frbsbX3QwggSvMIIDl6ADAgECAhEA4CPLFRKDU4mtYW56VGdrITANBgkqhkiG9w0B
AQsFADBvMQswCQYDVQQGEwJTRTEUMBIGA1UEChMLQWRkVHJ1c3QgQUIxJjAkBgNVBAsTHUFkZFRy
dXN0IEV4dGVybmFsIFRUUCBOZXR3b3JrMSIwIAYDVQQDExlBZGRUcnVzdCBFeHRlcm5hbCBDQSBS
b290MB4XDTE0MTIyMjAwMDAwMFoXDTIwMDUzMDEwNDgzOFowgZsxCzAJBgNVBAYTAkdCMRswGQYD
VQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9E
TyBDQSBMaW1pdGVkMUEwPwYDVQQDEzhDT01PRE8gU0hBLTI1NiBDbGllbnQgQXV0aGVudGljYXRp
b24gYW5kIFNlY3VyZSBFbWFpbCBDQTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAImx
Ddp6UxlOcFIdvFamBia3uEngludRq/HwWhNJFaO0jBtgvHpRQqd5jKQi3xdhTpHVdiMKFNNKAn+2
HQmAbqUEPdm6uxb+oYepLkNSQxZ8rzJQyKZPWukI2M+TJZx7iOgwZOak+FaA/SokFDMXmaxE5WmL
o0YGS8Iz1OlAnwawsayTQLm1CJM6nCpToxDbPSBhPFUDjtlOdiUCISn6o3xxdk/u4V+B6ftUgNvD
ezVSt4TeIj0sMC0xf1m9UjewM2ktQ+v61qXxl3dnUYzZ7ifrvKUHOHaMpKk4/9+M9QOsSb7K93OZ
Og8yq5yVOhM9DkY6V3RhUL7GQD/L5OKfoiECAwEAAaOCARcwggETMB8GA1UdIwQYMBaAFK29mHo0
tCb3+sQmVO8DveAky1QaMB0GA1UdDgQWBBSSYWuC4aKgqk/sZ/HCo/e0gADB7DAOBgNVHQ8BAf8E
BAMCAYYwEgYDVR0TAQH/BAgwBgEB/wIBADAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQw
EQYDVR0gBAowCDAGBgRVHSAAMEQGA1UdHwQ9MDswOaA3oDWGM2h0dHA6Ly9jcmwudXNlcnRydXN0
LmNvbS9BZGRUcnVzdEV4dGVybmFsQ0FSb290LmNybDA1BggrBgEFBQcBAQQpMCcwJQYIKwYBBQUH
MAGGGWh0dHA6Ly9vY3NwLnVzZXJ0cnVzdC5jb20wDQYJKoZIhvcNAQELBQADggEBABsqbqxVwTqr
iMXY7c1V86prYSvACRAjmQ/FZmpvsfW0tXdeDwJhAN99Bf4Ss6SAgAD8+x1banICCkG8BbrBWNUm
wurVTYT7/oKYz1gb4yJjnFL4uwU2q31Ypd6rO2Pl2tVz7+zg+3vio//wQiOcyraNTT7kSxgDsqgt
1Ni7QkuQaYUQ26Y3NOh74AEQpZzKOsefT4g0bopl0BqKu6ncyso20fT8wmQpNa/WsadxEdIDQ7GP
PprsnjJT9HaSyoY0B7ksyuYcStiZDcGG4pCS+1pCaiMhEOllx/XVu37qjIUgAmLq0ToHLFnFmTPy
OInltukWeh95FPZKEBom+nyK+5swggYVMIIE/aADAgECAhBUK7v3iZFOwcXku0+rFipmMA0GCSqG
SIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
DgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3Rp
Z28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTI0MTIx
NTAwMDAwMFoXDTI2MTIxNTIzNTk1OVowIjEgMB4GCSqGSIb3DQEJARYRZHdtd0BhbWF6b24uY28u
dWswggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDYY7Ok+LSdJXMOPurGsBJ9haMJobp1
AbJ0lXHAfmgO7N2XfT2VeOglOqYQJQlqSpNchVXA9UZ3OLsde6OC21IBV4iqzkUtI4hf+TmtK1xt
xSEhtV3Y7fKDyiKvvWdbNnuyKYuVlo+ABv8ZZB/2DDHLS/TvAgkR0q4YgoWxP4Eee8fTwJ7eWnmW
dmFs2hjjnnHmmXvrurxwhyE0ZpJ0gJwF/2jaDSTbEAhnH6xPN8vYh5j/ARa0kWamowSpSqvLciXe
RZ0sDx95ElHEJRzsIiHwkRVz+K6V0me5yjhGa90lx9OgA2PYGba0qcAW7sylgzxljEbkZ8/KII/2
Og3lONswf2QCIuW9Ac1n+LtKwREA+cbaTgsWB3Np10GhUlrt+pD9SWjahJROdTkPdhMlSn1tzeqm
XCoga1Yo12NhLUfv+VvYsURZxLOJyHm/eEn/dlDBHhvXsNslb3GF1zT2onBp65BEjQtff2vGF8UB
GX65gXgD0/b4kCYZ9zvrA+KT9ErN0o1WXOhDu736D9O27dp/WBNPF0j5MXMm9Sf+Lf/gLJJCnmBQ
RnaY4MXfoixcY0sAcrWbod/uw7h1H4PO+lgOOInkA64R0o7r7gGdVm/FlLK6c63C6GI6hZm/23+v
8sqMZbd9ZnYDwvhS3PmLtQUMFwtyTG672xQVU7Z+V9hCgwIDAQABo4IB0DCCAcwwHwYDVR0jBBgw
FoAUCcDy/AvalNtf/ivfqJlCz8ngrQAwHQYDVR0OBBYEFFr7QNV7ElfMY4HxUC/w1EzSGybuMA4G
A1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMEMFAGA1UdIARJ
MEcwOgYMKwYBBAGyMQECAQoCMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vc2VjdGlnby5jb20vU01J
TUVDUFMwCQYHZ4EMAQUBAzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLnNlY3RpZ28uY29t
L1NlY3RpZ29SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGKBggr
BgEFBQcBAQR+MHwwVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1JT
QUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwIwYIKwYBBQUHMAGGF2h0
dHA6Ly9vY3NwLnNlY3RpZ28uY29tMBwGA1UdEQQVMBOBEWR3bXdAYW1hem9uLmNvLnVrMA0GCSqG
SIb3DQEBCwUAA4IBAQBA+k/q3z9lz3S3x6AneZ9YhiHGGrlnzx0XWTdk8O2uzRFyJJtsmTYszkqa
dzazIljgTdd14Kp2C7KnacSYW48CnMyl+dP6n4YZDh7a0NBkZLnMmyuOOwGrpfNHGU/E91hvVPXY
ZdwrfzLsigVkINzGJW1E+ruJAvT5PK3fnEdeLbWEVFgyk0tgay+3vI6TZrQqBGpA5DGODK6aDMDN
X+ADVamfHJw57cF6uaK5mSJLDdg6sbCi5qxclQDjYakkk+9iJgXyFVoRUUwhfbU3COcBP9EpJduR
WZkrAQdi1IHnICuzGcsPQ6P29LGEvvGJgP7o1AqjW9HzyQRPwfbwaJobMYIDvjCCA7oCAQEwgasw
gZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1Nh
bGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+MDwGA1UEAxM1U2VjdGlnbyBSU0EgQ2xp
ZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEFQru/eJkU7BxeS7T6sWKmYw
DQYJYIZIAWUDBAIBBQCggeQwGAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUx
DxcNMjYwODA1MTk1NjE0WjAvBgkqhkiG9w0BCQQxIgQgszjCI0j4ZhupBsCGW5UP2NGhYFwa34TJ
84ZbETBGw+4weQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggIAfl2+jIwsY1Yxq051L9aVGF7iGJjz
nke9cztgg7tMxqAwwr6MLii0ffNEEJbiay0jN/EtIpbrk/TwaMzo2igdMYHjw1Lc2PpJtPMZfHGM
ufkVSns+BCndp0CWhGEtniIgaoRzyyQBuHQJDnwRoziRwm1BgM0V0JMmXL118GcyLTcSoi2fnQ6q
NGpUUhHodf3D/BS9u7IzFHnBbc9lqNItOeHhySX7ipENNFXFj8qvYLm0whY7piXhYE2oMFLLGGu9
pP8c1gplSiPzV5j2FZt84lPlZTLDK6x8Uei+MCLcerzueO+MeU2jE1dB2ds15Na50mEGomWKhP+A
k2zzNH5IIebH6qpwRW822SFsdsndChsFJLQ/pCaS/HYUJUL411gBHq4a+PkLTLKOGDjK0tzu0AdS
knSvoK+C6zEebd+AtekvJOiGAi3cxP8DRyoct0vF4hBuH95xnSM2OG7+SlVZfGMiQXSm//39wlEY
xNxAiEU8rwnyYKrAPyNM5e2bzDF47rXVhrSNAHMX+Mj+wG53cAf5PePU7+eC6sdz8fx2iOYiPGKz
7NZszvPGPUCSHTpyj8wNJoous29yuuZhYjwaOiDdMNjULBCOsiOt2g4zMc2peMyf9di2YwTHy1Se
5/jUM2Wt8WUQtrZrB9S6Kqjdz437KNwlzFi5IJpv7l2oYTc=

------3D7B6D40694C13434FF46B489C2A9DE7--

--===============3918090059069971927==
Content-Type: multipart/alternative; boundary="===============7568282101387364103=="
MIME-Version: 1.0
Content-Disposition: inline

--===============7568282101387364103==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============7568282101387364103==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============7568282101387364103==--
--===============3918090059069971927==--

