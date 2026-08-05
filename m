Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A75EC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E08B6B009E; Wed,  5 Aug 2026 15:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B8496B009F; Wed,  5 Aug 2026 15:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9BA56B00A0; Wed,  5 Aug 2026 15:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9ED546B009E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:56:27 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2571E1C10B6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:27 +0000 (UTC)
X-FDA: 85068272814.25.B348F17
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3FE43180005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mn+2oNrZ;
	spf=pass (imf06.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785959783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=qBdxh1pw7N9rXrn+2FJuGWHK1mABD52a4L8iwmmjk+I=;
	b=ZR58Mbu/QcdtXiESqq+CkGHBoCAK8PAAa1DhHyC8otvETPBM8FwUuhgtLvkXM/HzWeoiPW
	/H4Roe9n11SYZMoTQhffza01BXV08sGvBdyWnU0bAQAbGjP9i70Wckp6W/i+mmp6GfUmK9
	HojU+LjqTMy5j0aWeAZUr11vVHmyTY8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785959783;
	b=hIjIh1oEAJLwVEv8f1Subo0e1eWG6yDnpePh/lOzLENwVkYB+0tVy6mXKm07H8aoz+0zJS
	MZ49SOesGQytsJGb9QHL0x0q5W8Ae38Lsu/w/7KoWBcLqZHCrhfMTon8Luqg4Pu7hlhfn/
	765gIxK281yuuafzdjie5Vj5RSBu4EM=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mn+2oNrZ;
	spf=pass (imf06.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1785959783; x=1817495783;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to;
  bh=qBdxh1pw7N9rXrn+2FJuGWHK1mABD52a4L8iwmmjk+I=;
  b=mn+2oNrZEDX5l1EBYj3lS/6Gae60FUs5e7/22ARS6fOgwaCX24q74/C/
   BWnGkhbpffGp2mMpu5hU1RgmSmXbQGhgOKYwzuIG9LGHDZX0EcP12GwBu
   DUDBWbQ8HayZTI/0OG9D1ZJjF3vmIVMlXMf6esK3fTGJoq9rA7UwBTI1y
   h+AyISElimO+JM9S82kfVpWNEMWd9zryNCXIT1ywRhqtUnTf+eMulICe0
   jkHWNcwv55FwqJftHRAM2RTuY/l8h5/y9+pbLnD7VmsGK0VCLCseXyke2
   TNF3h5dw2H1r8v8/Ek9uIdY5eTA4eSvwQwsqPaPojA0de0v6YPvgOZucC
   Q==;
X-CSE-ConnectionGUID: vCN0vWG2QcWpr1gCASpMaA==
X-CSE-MsgGUID: 41IB7jx2Tv2BjH9Sii9cHw==
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.25,207,1779148800"; 
   d="p7s'346?scan'346,208,346";a="17320367"
Content-Type: multipart/mixed; boundary="===============0649898463130662077=="
MIME-Version: 1.0
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 19:56:19 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:28260]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.18:2525] with esmtp (Farcaster)
 id d0f1916c-2317-4271-8878-aaf0ce637e08; Wed, 5 Aug 2026 19:56:19 +0000 (UTC)
X-Farcaster-Flow-ID: d0f1916c-2317-4271-8878-aaf0ce637e08
Received: from EX19EXOEUB001.ant.amazon.com (10.252.51.80) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:56:18 +0000
Received: from EX19EXOEUC001.ant.amazon.com (10.252.51.133) by
 EX19EXOEUB001.ant.amazon.com (10.252.51.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:56:18 +0000
Received: from LO3P265CU004.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUC001.ant.amazon.com (10.252.51.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Wed, 5 Aug 2026 19:56:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NDAFRbQyIJuSuMKV6lNP8s3rpQtTUfo5VnCW9RKWmdGDDiZB/WJ/wRUdWYts3fcivBTmPWdLpn2gP5+kv8EUOr3XiLHyl5+lGZ4dpUPb2CCERFJWXhK1a7sPhjPqaoyu9oFet/JWeOnIM4TNOK6MH+CoDJ+Q6z8tmF6Wo2b5Ya8wkCitZVP2omFQGh9D/KW+VZW960YXYhIhI87Ox0vOd9J9Uz80MLbn92xQxXyLvTTY0lz/gfC9TO/hEULvvoevCc44lm6Cp6tNVS8XZmVzVG+5CCJbHg+e2XWwlhn511NIh21EHH3od4lK3XJLHfVA6eFz5P2VluFo0dgqmVSwtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=wFIqWldwCXvdubJqOJhWZvw9UdVCcHVBifBgHlKXnCU=;
 b=c2OrS9TOsNr4OZZKWBUxQfEn0yj7MVnQnMbdauen6r44bcrj6HMimsrXNFvWVdQjdLBEpIXoBmq9HFcaCvx0Ur0LERSXx/CI+cSvcEFwsqXaMjV+xblCWr0fflsVZS2Us1lVtoWPK08sboeUN2mmI6oqwAY8UwbZMu4MDgOm9dFOX262N3yIkAXwsbOx5CKPQUuxiDs6S/evdA8zr5mbxoEulYf2SDhgwxKS9NJxGs0T8Ylr+NRBHZacZTXPKF5FUtwcYxbOvbg1+qQcWU7JOdJNTr3RRsg/LhdscEQJFCS0JuL3IBHT39Q2D+EoKLW+D6+lGqpP7nS+syT/FGWyKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.co.uk; dmarc=pass action=none header.from=amazon.co.uk;
 dkim=pass header.d=amazon.co.uk; arc=none
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4b4::12)
 by LO0P123MB7404.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:334::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 19:56:14 +0000
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6]) by LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 19:56:14 +0000
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
Subject: [PATCH v3 7/7] KVM: x86: Use gfn_to_pfn_cache for steal time /
 preempted status
Thread-Topic: [PATCH v3 7/7] KVM: x86: Use gfn_to_pfn_cache for steal time /
 preempted status
Thread-Index: AQHdJRR4KE7nFGkgtEqkDJuPyCIlUQ==
Date: Wed, 5 Aug 2026 19:56:14 +0000
Message-ID: <20260805195528.3853473-8-dwmw@amazon.co.uk>
References: <20260805195528.3853473-1-dwmw@amazon.co.uk>
In-Reply-To: <20260805195528.3853473-1-dwmw@amazon.co.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LOZP123MB8516:EE_|LO0P123MB7404:EE_
x-ms-office365-filtering-correlation-id: 57097e01-22a9-45a6-422d-08def32b9af7
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|6049299003|1800799024|376014|7416014|23010399003|22082099003|18002099003|11063799006|56012099006|4053099003|38070700021|10067099003;
x-microsoft-antispam-message-info: u5hWyI3B1q8M3LserOBBXnV6xZD/A1bljA/FHVodhuzqtSOQJ1IJE4D/P8rsOT01QDqxBnV0jkuB91kLFH2RkIhdsGjUYJKEtJpf/RIiy/HWA7nTFvFBbCDvneJ7G4LK9LvwmnlucJPFPpTvhKcOnMWtpMLB67OhVR3q8mDkzPVzhJTlIBPSJgoQIbh+qzBu+wWMENq3Fy6Z2MoXPPE89vzr8qx5b9u9X64y6BZidbtSGM56453i77LUfr/nBTk7AzUa3JY7gxKls8R8ZYZdYIFOn4l1CRflWq/6z1DHndsP7g96erUdHfeT2S/IB6p1sLgyyhYnJnay3y5uLq7TNHxAwBt35v5AKRyjaUctL0F8QvXj06iO2S67YoUvEftxGhb9OijXQdr4uiiW48JjWP4zb6bz+QaCSw1UJiB3TsGE2L7yr4dggvizRKM2Sdu6dsYm9HCQj22dKPwBZyuK7+dsChu05Nm8F6Yp5+ZRwWLHc/EKRItrRdmCChfbS33ivMI81EJ78VcPPjLreFDHZlaywtxZJfuNxA6mh3wNbiH1QgW5dN5nWWVsWDXuau73FzWQc/dFwVkK787q/IzORL3VYwSPC+ttJ7vPhXLqX6CRwOWM633KOX4m58R5vXbIElDpxWur5mDK2mbgKCMaKCfEZ8OgkD0idDda/zRruzYW0Yjv6dynNkdpYFJ8Eg6gm3FsglNPX979LeNmNb/ftA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(6049299003)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(4053099003)(38070700021)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a2VjcmhSeHoxVmVKeXJuSGRyb0dhV2RaRW9FOEpLTWRsSUc3Yk11NWVQQjBU?=
 =?utf-8?B?eHhoNWw2YUhYMmc4eExYUTBmQWlWRlBaRXMwNHRpTC9QbnRtaFY0OGFQUEFu?=
 =?utf-8?B?WjJEZHBzbkVmeUNUNC80czVXeUI0MVVBOTFaczNTaURERjlWQTlCckwvTVl1?=
 =?utf-8?B?R0tpdEZLK0dnQkdXK1V3VHlrSmpKQ0Q1bEpsRnRpdWVCMm1hTGtHZ2Zjako5?=
 =?utf-8?B?OWl1WnBQL0xMVXZmYXZtcFN0ZEFqMFI5dGQ5WnhTNmppWjdXQ2hONzhFM09U?=
 =?utf-8?B?SEwwNFQwRGUrV1RnYTdJUnJmbDdpTXROSXNkSWtzMFVOS3cyVXNyeHlGQ3pW?=
 =?utf-8?B?SlpzUmpWZm0wVFBsMzh6enRtN1pabzAwek9hUG4xTmxha0c2YzEyTlFIMFFI?=
 =?utf-8?B?SnFnOU1oSlNXWFFSRjROK2ZHQlN6ZXlyRVZIR1VKVmFDdkxUYUtOU0w5R0Jk?=
 =?utf-8?B?K3ByWmV6YzZLbHZjb0FoSVJnM3ZMWXgwa3hGT2NGc1U3MnVrTU1qRjFnRkJB?=
 =?utf-8?B?dWpxT3IxU0dDd0xpQ3VjUnR5Syt5QnBIVldqcGNhSUNJZXJvKyttdHh0NnE5?=
 =?utf-8?B?dmZhL3NSNE9nTFFsSEw5d3JGR3JhNmpkUUpaZ0Rmc0hGczViWW1oNTVMdkg0?=
 =?utf-8?B?VHBWak9WTTJVYUJDQWRqbTVuOS90bFdRbGs5TDMycitlZVNzampQVW5zT205?=
 =?utf-8?B?RlIyWHBPS1l3dDRCVmdJVmJPOXp2OWZ1OTJVYzdsYmo3bWgzVTBtelMzTzB6?=
 =?utf-8?B?ZGtQRnAwaGRyVDZRb3k5ejJHbW8ybVdWNnR1OFpia1lMejh0ZmxBaWJuRVhI?=
 =?utf-8?B?dHpETXAvVzJFdHFEbTdHb2FNMWNONlpBLzF0cC84VDhpK3puNjU3SkRvMFBo?=
 =?utf-8?B?MHJWMnIyOWJlUVArSDJScVN4Mm9kOEtPWEM1YVh0ejVPdU5wYTZUZ2NZT0du?=
 =?utf-8?B?REMvamdjVVVvbVNCQ1NpVklaMjBONWZodDlxb21HSmZQQkVnVkdlRHBYQkx6?=
 =?utf-8?B?djNJQzdsVkNwNDdwT0JjTzk0YytvWW9nNUZDbHdKalRwYlB3dW12NGErcVF4?=
 =?utf-8?B?NndZVEJ5MnJ2a1lkS3NML1lOcHFXRi9jRi9WdGJUblZOUjFUaEQrbjJGeGxC?=
 =?utf-8?B?WkJGWkZ4S1hBUVhSN21zUS80bEgvVUtjK3pNbW1kaHdYVkI0TldXSkZ0Nk45?=
 =?utf-8?B?c0czSkVGU0dzWVFFZjBibUtaNlA5UUl6QnBUcndZWGhCSEtmcHBDbmJueFFS?=
 =?utf-8?B?dWRkdzdjN0J0aC9JSHRFb3R1SHBBVm5vcUp3N25vUzJLZFVGSjZ0Zm5GOXov?=
 =?utf-8?B?TTBrazdUaUpBMXRJWkUwakZNa3FHVGowc0p3NTIyTmZieWxiV3hvYjMyekcr?=
 =?utf-8?B?eTQrdi9xZkYzaDFzVUlJNnhhb2pKSmh4d21CY2NFNWlITmNLRGxaT3h5SlUw?=
 =?utf-8?B?Nm53UlpaZmE1MjR0ZTZyc3IwYjY1UlB5ZkNqa21hbllwUXRUbGlZWTBHTnRQ?=
 =?utf-8?B?REY5ZkNoMHlxSnB4L2U0bFlBVXRScjExY1J0WDAwSTlQMTVBQTh1aUY1MGRl?=
 =?utf-8?B?NzBpQ1R5S09qZVlXT2NHOElDb2RhL3JvVzRtUERRdG5iOWlaTjdIVVRHWllB?=
 =?utf-8?B?V3VxZGJ1MDBkTjYvNTVNZWtISDJqSHowcHFmWnN3ZFVITHBpaTIxbmJRaVR6?=
 =?utf-8?B?aGxxTFR3eDg5NkFmdVNrNUNzM0VNc2J6bzFvWDhwenhSaFR5a1dnbGtzU0h6?=
 =?utf-8?B?QnNFZ2VkMkN0Y0N5c25HM0REd2xKNWVhTTFxaHc5KzE2aWhSNDJEVEw0WW9H?=
 =?utf-8?B?Ym1RdGhJVVR0YjRHb0I5cmgwSnJVVTRuWjkzZXFxYjNMNENaRXpnQXZuU3hC?=
 =?utf-8?B?RkxRSllSbE4zTWZuQU5oOExjc3FPNmRlWEFVekR1WFFSTVZZV0ZXQjIxYWlP?=
 =?utf-8?B?aUZXcE45L0p5Y2hRNFpFeXJLUllOYnFieVc1T3oxZWdobmNiQmpRMEM3TXRS?=
 =?utf-8?B?d3l5NGF3NWxrcGcvS0w1blQvc0JXQnJaSFdVTThDc0hZRkNwS0Y3eE00Yzds?=
 =?utf-8?B?MTdneFZKVm10Z0cxWUZyQVMrWTMzTUFYZ09HYnFsZmpBcXVyQVJiOUVXZHMy?=
 =?utf-8?B?b09ZUzBZam5lSnRFblI3UkVLajVWU1FlV3JCYjdXNlNJTWtaZWpmK1hPQzNF?=
 =?utf-8?B?OHBsS1BoNEthL2dnU1FJYUdwcm5qa3RhZ21pZFhVZGhYTjZBRVg5TmlaNEtU?=
 =?utf-8?B?dVVrL3d5dDJhWG0ydXlXSHRyanlZbGtsQnErYWdqVFAzNWZ5MkpMWFF6UVM5?=
 =?utf-8?Q?1zCV3KBfun6kRheRsc?=
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: f0fwnPFC+d2NyerfFy0NkfE335tnMIEFJ3k5YEnaHsaVH7mb1f8XBhxZI7LZgwLIV0LxwIw8yqUYIYfE/c+/PjVnmjr3hL7umAOB6OeNlTgYQFCuKf5lXBmyVHm6EUo9jaSsVsMaBWBm9BLVUc1CcD5azsl//+XfRviGsXEVDy/0huFlS8mU3+u/af/UR/6WKEw5qOm0n9jVFu4Hgr5jDvCiEWXllx0nJqELdbbIQleORwKAUit++NfVjbO/Js1UhebsMrufDGt0JqmXSk3j0cZp5lJeY7BhAumOG8sPeTuuYw/nbiur/qB6CloYkvkYgKVRxMdd643kgkXBXuHTFg==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 57097e01-22a9-45a6-422d-08def32b9af7
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 19:56:14.1647
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aofPNiqzUNhAsLUdvBoDzra0rF6hJ3iMitR1QF3+wbYKj8zu43UQgF3Q13MbljPZnseYcgQ8e00GI9l6TpcD3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7404
X-OriginatorOrg: amazon.co.uk
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3FE43180005
X-Rspam-User: 
X-Stat-Signature: 766bqugdmsqyjhpnyoiyke7gsuja1y17
X-HE-Tag: 1785959783-341233
X-HE-Meta: U2FsdGVkX18ZYnLz9deR/rmzxFI+N1e742uOaYjdcIG6Qr4o1JX9+zfY6G2QL+8rzZX2WWYWTT3EdOoHUFQC34l3s7NRBwaCMaGnH0bnvcrl/LVusDbgEfJPLWd2/qqr78wdIdefGQhKKPKECkaTERaGjo8y6BOmIRXTxvnR9+19uiyDh+duZyMRKlcCRghMpeZ2F3Z2mRFzqUJrPqGhSQ8pZx7TSjLsFeknkWgORRZCjVs37lEUo/ofyjOJrBbx3EfGqqzboZM3NbJ7YBMfUFpONeAFOtqHUtb5684FAFIDYTrvJ+rKJScvf4kEEqxwaUCEB7Bp2pjr487wfUtifjEt/R/orlgxwAViqJZqF9DnstDJu1N+Xcpbjd9xWiIwwkT5eJlTI6H4Tqp/n4qgFRe/AbTF2WvBvPq9rSM/rQpmEazD7Z0uLlyGG2vyLnCLgQLAk0f7VauPLA/DJhVTA3WulYP8EzjwbOg1NkOOxohipG34auwVMMrYMhW4sPbpltt8FtQUc/i7JWIeG5KGdUP4UXO9Sw0ez8TQZtMlLiI0/f/CoJad7dGgABElvvzZy1avvLRFtGEMrF76synIz3MciWBz5N7gol1IwCWWBJ2ePNUl7rlQ5gj62bML+QZumwsIebMoS7/W/+/AGk91DGa6S+UTSObqOToRUM7zhHlZrudPo+KZh8ee7sIz/JOz4Qsdw8t7rqqQpMFs8F9JH5DS/QjyYdY6LDZ+ZJ8hKWcwrLzPzsBY3pEbdUJhnntqKgn7t4gSZW53FFpPnkpV1LCiHz9s9/euEPXueNGUF/xvXZ5pcp612TbId4SnBUJWQXNPe6lP876LZdj50Tzc7jt4mJsCTu/19YIbM6sqGnSWipwwMsHK99hcTvNOTWi0fthrWvnk0aERO+92BxRMmCOeEDII7JeTCLcJx04zKAT2hGFvLtyDAb7omXtFhMPl/LKv2bKfLHxBLi1TOHy
 S32rXlWF
 Z0+IFSVfX3VC38Ct8+d7YBEeWdp7U7wZ+kyS/i6mzbSWIg2Jwm3om50XwZwPY2fvsoxmhBGYtnfuDkEPEelJczREEFFr7jqTK1l3Gn4QJ4/51SqwiOSvm9eIawvFvBJNElUjn+Ej/0yd1cwWKNiE1eYuP5bfqFjiZrEqfmOVDjT8jSmL7N/lm5lJ/VwdJl5nKFgsSV1zSQoTkNZgwX6eo1Aensi6FNPJlia0xsVGHh1qQQDLczP5jzIlmEuCKJJbRH/D72VHuiGFKn9O604uUklg730PGnlsbTEkqhI0OV+iXzi+dgOxIWav6QVP2MTu8Ww/NYzirtFr+U+4laJNsM0kwJolzlqy3Tzsgna8Ds7ZdDkPQCCgss34x6QUag/3ImgJpGlzlUkOlorsXwMOwSIctuQkBxRPxwsCXJKOijkD5mQBriYRPZRh3W3xPWiQiTJ8eFp42IJ2rYVX3zVAhuhncNFb7prgsNGwXdhOU0w8io69O5Ro8bkZplKsUOebSoucvZ3leySHC/gIIKTgZHHADnGp88pHpmngvqnVCuTshppWVXBM5UObWhu5Z1G6GDYTmbVuX3YeSUgfU4eKgN1KuqgI7fuclHyCrJP6kjWU3tjzR6iU8ryYfuR38c6gR2lJEhlFMhqo3leYOLMGzmOAPCruRXbi4+LStOwtEpyFmaEjw7DQB03QFBSvC+zX5NyGdfxVFyeLkOZiOq6sGC9lSU7fGXc0EuCzcjl7R7qMzkbpRlWUW5tyI+tw5ua09jbyk3qUx/XJZVq8b5hHXfboBnRBkq7/ZdCewT1z+AHJuK6KCKuCAPit1qpbnNCvw+ReaV94r9a81zcy0Cme2nRQDZ1nODoFkys16HvcdL9q2SR/Nua0JVkKQ7hb98+cC+PC9r/pMVD4C0mfzQ/ByaDrODjAR68t5TUvu3x7eH26T8gWaifl27GrYh5Wx/CbmuOMDGcXtX1FwlcqyZkDEXg2gdUWJ
 TqOgBJi4
 FkhXZYeoNWe2e7PCc0hokLcdbwiR1v4eoAN+iIwcqqoUi0bZjoAy2wFqi44Sk8IEdLd0ChN1FHolfpNPXnjbh3QN4QjeV4KPlBscVcB5r0Gdu9GbJ+ODPluKfmAD/kkVK91zp9nUWECEqauiGYZdyC4CRqrAwT/MG6LtQ4qEZxrVdQ+syBR5NazWcDlagukOhItdEQATZX3/Q97eA8xIkjzylVFhc9SQr1TUjwujX60fZqRYewB4wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0649898463130662077==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha-256; boundary="----BF4729FFF1CFF81C347E9D8664D1565B"

------BF4729FFF1CFF81C347E9D8664D1565B
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Carsten Stollmaier <stollmc@amazon.com>

This largely reverts commit 7e2175ebd695 ("KVM: x86: Fix recording of
guest steal time / preempted status"), which dropped the use of the
gfn_to_pfn_cache because it was not integrated with the MMU notifiers
at the time. That shortcoming has long since been addressed, making
the GPC work correctly for this use case.

Aside from cleaning up the last open-coded assembler access to user
addresses and associated explicit asm exception fixups, moving back
to the now-functional GPC also resolves an issue with contention on
the mmap_lock with userfaultfd. The contention issue is as follows:

On vcpu_run, before entering the guest, the update of the steal time
information causes a page-fault if the page is not present. In our
scenario, this gets handled by do_user_addr_fault() and successively
handle_userfault() because the region is registered to that.

Since handle_userfault() uses TASK_INTERRUPTIBLE, it is interruptible
by signals. But do_user_addr_fault() then busy-retries if the pending
signal is non-fatal, which leads to heavy contention of the mmap_lock.

By restoring the use of GPC for accessing the guest steal time, the
contention is avoided and refreshing the GPC happens when the vCPU is
next scheduled.

Since the gfn_to_pfn_cache gives a kernel mapping rather than a
userspace HVA, accesses are now plain C instead of unsafe_put_user()
et al. Use READ_ONCE()/WRITE_ONCE() to prevent the compiler from
reordering or tearing the accesses, and add an smp_wmb() before the
final version increment to ensure the data writes are ordered before
the seqcount update — the old unsafe_put_user() inline assembly acted
as an implicit compiler barrier.

In kvm_steal_time_set_preempted(), which is called from the scheduler
path via kvm_sched_out(), just take the RCU read lock and bail if the
cache is not currently valid. The cache cannot be refreshed from that
context, but setting the preempted flag is best-effort anyway — the
old HVA-based code used copy_to_user_nofault(), which could equally
silently fail — and kvm_arch_vcpu_load() unconditionally raises
KVM_REQ_STEAL_UPDATE, so record_steal_time() will refresh the cache
from task context before the vCPU next enters the guest.

[dwmw2: Port to RCU-protected GPC. The original was written against a
        gpc->lock rwlock and needed a read_trylock() dance to be safe
        from the scheduler path on PREEMPT_RT; rcu_read_lock() is
        unconditionally safe there, so all of that goes away.]

Signed-off-by: Carsten Stollmaier <stollmc@amazon.com>
Co-developed-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
---
 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/msrs.c             |   7 +-
 arch/x86/kvm/x86.c              | 119 +++++++++++++++-----------------
 3 files changed, 62 insertions(+), 66 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 283847619ff8..93514cb1f2f7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -873,7 +873,7 @@ struct kvm_vcpu_arch {
 		u8 preempted;
 		u64 msr_val;
 		u64 last_steal;
-		struct gfn_to_hva_cache cache;
+		struct gfn_to_pfn_cache cache;
 	} st;
 
 	u64 l1_tsc_offset;
diff --git a/arch/x86/kvm/msrs.c b/arch/x86/kvm/msrs.c
index 66fa7140d65d..37d79d84e2f8 100644
--- a/arch/x86/kvm/msrs.c
+++ b/arch/x86/kvm/msrs.c
@@ -1717,8 +1717,13 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		vcpu->arch.st.msr_val = data;
 
-		if (!(data & KVM_MSR_ENABLED))
+		if (!(data & KVM_MSR_ENABLED)) {
+			kvm_gpc_deactivate(&vcpu->arch.st.cache);
 			break;
+		}
+
+		kvm_gpc_activate(&vcpu->arch.st.cache, data & ~KVM_MSR_ENABLED,
+				 sizeof(struct kvm_steal_time));
 
 		kvm_make_request(KVM_REQ_STEAL_UPDATE, vcpu);
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 09425f72f4a5..4a5753623909 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2046,10 +2046,8 @@ EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_service_local_tlb_flush_requests);
 
 static void record_steal_time(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
-	struct kvm_steal_time __user *st;
-	struct kvm_memslots *slots;
-	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+	struct gfn_to_pfn_cache *gpc = &vcpu->arch.st.cache;
+	struct kvm_steal_time *st;
 	u64 steal;
 	u32 version;
 
@@ -2064,42 +2062,27 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(current->mm != vcpu->kvm->mm))
 		return;
 
-	slots = kvm_memslots(vcpu->kvm);
+	/* We rely on the fact that it fits in a single page. */
+	BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
 
-	if (unlikely(slots->generation != ghc->generation ||
-		     gpa != ghc->gpa ||
-		     kvm_is_error_hva(ghc->hva) || !ghc->memslot)) {
-		/* We rely on the fact that it fits in a single page. */
-		BUILD_BUG_ON((sizeof(*st) - 1) & KVM_STEAL_VALID_BITS);
+	rcu_read_lock();
+	while (!kvm_gpc_check(gpc, sizeof(*st))) {
+		rcu_read_unlock();
 
-		if (kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, gpa, sizeof(*st)) ||
-		    kvm_is_error_hva(ghc->hva) || !ghc->memslot)
+		if (kvm_gpc_refresh(gpc, sizeof(*st)))
 			return;
+
+		rcu_read_lock();
 	}
 
-	st = (struct kvm_steal_time __user *)ghc->hva;
+	st = gpc->khva;
+
 	/*
 	 * Doing a TLB flush here, on the guest's behalf, can avoid
 	 * expensive IPIs.
 	 */
 	if (guest_pv_has(vcpu, KVM_FEATURE_PV_TLB_FLUSH)) {
-		u8 st_preempted = 0;
-		int err = -EFAULT;
-
-		if (!user_access_begin(st, sizeof(*st)))
-			return;
-
-		asm volatile("1: xchgb %0, %2\n"
-			     "xor %1, %1\n"
-			     "2:\n"
-			     _ASM_EXTABLE_UA(1b, 2b)
-			     : "+q" (st_preempted),
-			       "+&r" (err),
-			       "+m" (st->preempted));
-		if (err)
-			goto out;
-
-		user_access_end();
+		u8 st_preempted = xchg(&st->preempted, 0);
 
 		vcpu->arch.st.preempted = 0;
 
@@ -2107,39 +2090,33 @@ static void record_steal_time(struct kvm_vcpu *vcpu)
 				       st_preempted & KVM_VCPU_FLUSH_TLB);
 		if (st_preempted & KVM_VCPU_FLUSH_TLB)
 			kvm_vcpu_flush_tlb_guest(vcpu);
-
-		if (!user_access_begin(st, sizeof(*st)))
-			goto dirty;
 	} else {
-		if (!user_access_begin(st, sizeof(*st)))
-			return;
-
-		unsafe_put_user(0, &st->preempted, out);
+		WRITE_ONCE(st->preempted, 0);
 		vcpu->arch.st.preempted = 0;
 	}
 
-	unsafe_get_user(version, &st->version, out);
+	version = READ_ONCE(st->version);
 	if (version & 1)
 		version += 1;  /* first time write, random junk */
 
 	version += 1;
-	unsafe_put_user(version, &st->version, out);
+	WRITE_ONCE(st->version, version);
 
 	smp_wmb();
 
-	unsafe_get_user(steal, &st->steal, out);
+	steal = READ_ONCE(st->steal);
 	steal += current->sched_info.run_delay -
 		vcpu->arch.st.last_steal;
 	vcpu->arch.st.last_steal = current->sched_info.run_delay;
-	unsafe_put_user(steal, &st->steal, out);
+	WRITE_ONCE(st->steal, steal);
+
+	smp_wmb();
 
 	version += 1;
-	unsafe_put_user(version, &st->version, out);
+	WRITE_ONCE(st->version, version);
 
- out:
-	user_access_end();
- dirty:
-	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+	kvm_gpc_mark_dirty_in_slot(gpc);
+	rcu_read_unlock();
 }
 
 static inline bool kvm_can_mwait_in_guest(void)
@@ -2613,11 +2590,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 {
-	struct gfn_to_hva_cache *ghc = &vcpu->arch.st.cache;
-	struct kvm_steal_time __user *st;
-	struct kvm_memslots *slots;
-	static const u8 preempted = KVM_VCPU_PREEMPTED;
-	gpa_t gpa = vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
+	struct gfn_to_pfn_cache *gpc = &vcpu->arch.st.cache;
+	struct kvm_steal_time *st;
 
 	/*
 	 * The vCPU can be marked preempted if and only if the VM-Exit was on
@@ -2642,20 +2616,32 @@ static void kvm_steal_time_set_preempted(struct kvm_vcpu *vcpu)
 	if (unlikely(current->mm != vcpu->kvm->mm))
 		return;
 
-	slots = kvm_memslots(vcpu->kvm);
-
-	if (unlikely(slots->generation != ghc->generation ||
-		     gpa != ghc->gpa ||
-		     kvm_is_error_hva(ghc->hva) || !ghc->memslot))
-		return;
-
-	st = (struct kvm_steal_time __user *)ghc->hva;
-	BUILD_BUG_ON(sizeof(st->preempted) != sizeof(preempted));
-
-	if (!copy_to_user_nofault(&st->preempted, &preempted, sizeof(preempted)))
+	/*
+	 * This is called from the scheduler path (via kvm_sched_out), so
+	 * the cache cannot be refreshed here.  Setting 'preempted' is
+	 * best-effort anyway; the old HVA-based code used
+	 * copy_to_user_nofault(), which could also silently fail.  If the
+	 * cache is invalid, it will be refreshed from task context by
+	 * record_steal_time() before the vCPU next enters the guest, since
+	 * kvm_arch_vcpu_load() unconditionally raises KVM_REQ_STEAL_UPDATE.
+	 */
+	rcu_read_lock();
+	if (kvm_gpc_check(gpc, sizeof(*st))) {
+		st = gpc->khva;
+		WRITE_ONCE(st->preempted, KVM_VCPU_PREEMPTED);
 		vcpu->arch.st.preempted = KVM_VCPU_PREEMPTED;
 
-	mark_page_dirty_in_slot(vcpu->kvm, ghc->memslot, gpa_to_gfn(ghc->gpa));
+		kvm_gpc_mark_dirty_in_slot(gpc);
+	}
+	rcu_read_unlock();
+}
+
+static void kvm_steal_time_reset(struct kvm_vcpu *vcpu)
+{
+	kvm_gpc_deactivate(&vcpu->arch.st.cache);
+	vcpu->arch.st.preempted = 0;
+	vcpu->arch.st.msr_val = 0;
+	vcpu->arch.st.last_steal = 0;
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
@@ -9347,6 +9333,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 
 	kvm_gpc_init(&vcpu->arch.pv_time, vcpu->kvm);
 
+	kvm_gpc_init(&vcpu->arch.st.cache, vcpu->kvm);
+
 	if (!irqchip_in_kernel(vcpu->kvm) || kvm_vcpu_is_reset_bsp(vcpu))
 		kvm_set_mp_state(vcpu, KVM_MP_STATE_RUNNABLE);
 	else
@@ -9454,6 +9442,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 	kvm_clear_async_pf_completion_queue(vcpu);
 	kvm_mmu_unload(vcpu);
 
+	kvm_steal_time_reset(vcpu);
+
 	kvmclock_reset(vcpu);
 
 	for_each_possible_cpu(cpu)
@@ -9574,7 +9564,8 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_make_request(KVM_REQ_EVENT, vcpu);
 	vcpu->arch.apf.msr_en_val = 0;
 	vcpu->arch.apf.msr_int_val = 0;
-	vcpu->arch.st.msr_val = 0;
+
+	kvm_steal_time_reset(vcpu);
 
 	kvmclock_reset(vcpu);
 
-- 
2.43.0


------BF4729FFF1CFF81C347E9D8664D1565B
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
DxcNMjYwODA1MTk1NjIwWjAvBgkqhkiG9w0BCQQxIgQgD5NMxLZcuvdCfsIhj4oG7u/Xsni8AfiX
c8GS+8WGkK4weQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggIAQy9jiisINJLunNXcTTnbgD1cg0LF
sBSrf0PMIVN5R4z0cbsUe4v9GiWTaYNXP20FQonp7sV6cyBbMI1p8ssqIQInLgSl3SkSTGQfK9q+
qXXH0s+34NHZMompV01tcALLdvF+CagwkuNmmXtsKa5xgaIqPWfiLeAECo0sZzeM+6d6ITLqfu1Y
oE5mGV92gC36asNi48v8l4NeaufSzPbTmP4NBwD9gXmkS93e1fhNQucbF5MNIy93WC4D+p/1X15d
GPqyza4IPs/eH/scZnqgMKlnwuKSb6MjE+yorK8DPHnP9KU5c1ZDzCFab6L+C+XTPRH4i1RS+rkY
Bfrvd70Prn3y188w7uBzEBawy7bP4CgeIcwJt6RS1/Qoigbkli/aJxjJ/Ay6r6E/5rOX19T3p38R
hrQ1Ag36P3f6Sss3nWsc9VHAUaOSSCy/lSgKOGbw5Wt+o0O2lBaKH6D4IHsZlXNcSPoS6lD4F2+U
OWbJxFIInZB3T421Th85oRGzDwF76jR4QOpOPLEpXJlHgtlKjOTiNxvlZ1HLlfQG4xA0ufCJdjTs
WSHJqfNBMKz6h/Kak0FL1wr4DAG5dV6NMqRcBEWqXudZkSKOmtZYsm+qKgLRRZ7aybPD+K2n2UZa
fLOzhcjmWGS1tsOihlRRgW1eQ0z3D8IUp7cwHtHvjH3MG28=

------BF4729FFF1CFF81C347E9D8664D1565B--

--===============0649898463130662077==
Content-Type: multipart/alternative; boundary="===============4487427444207769569=="
MIME-Version: 1.0
Content-Disposition: inline

--===============4487427444207769569==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============4487427444207769569==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============4487427444207769569==--
--===============0649898463130662077==--

