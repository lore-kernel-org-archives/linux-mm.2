Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 735A4C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6006B007B; Wed,  5 Aug 2026 15:55:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39D376B0088; Wed,  5 Aug 2026 15:55:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 217326B008A; Wed,  5 Aug 2026 15:55:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2E1D6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:55:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E7F81405A9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:55:44 +0000 (UTC)
X-FDA: 85068271008.06.6F51F67
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id 34A8220010
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:55:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Vh8w3UNH;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf13.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785959740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=ib9XZUYPKL69VvlKK2Q18vB3ZA9x3GXCszzFCjcNnpI=;
	b=77bYFV+imJWQxkQJffTNg4HKxN5irbbLKTFyyDc48po0S/MZkT4vq3X2x3ysZ6F4MGqKgy
	8RWim4zfbCq4qd4fv0JyTkE09SUH7FI/ssX2bibeHBbAW/yz1XHSq9QjvVDY167n4O0F8l
	FvBvwXQrRplgNs/NunbHEJ7PmbTMp7k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Vh8w3UNH;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf13.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785959740;
	b=JytfmzxoYnckW/OmXYyaJaz8wgHQwj49mS2F0Y4aQnj6ziQJQsfXWvpsIrwouyGP67GxVN
	Gi/HMexeo36Uq8mhxQZUBBJcpiP1xi3DHRP7kcT7HWgb2QQdM3uIVNyBMqu0h1LkLU9HBk
	cHleeOXo2A4duvVSZfj2eUtl1Q1Tn1E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1785959740; x=1817495740;
  h=from:to:cc:subject:date:message-id;
  bh=ib9XZUYPKL69VvlKK2Q18vB3ZA9x3GXCszzFCjcNnpI=;
  b=Vh8w3UNHAaotTwdw4jAkuL0XCBRKFAPbOUv3smR2hmgfxjpZEIDew98C
   E+XpDz18tU9HIHHG3VoGemj4DX2WBMS7E7Yi10LsL7jcdlHYJlN22/fZD
   KY6pe0egsAD8gHUxW+cXQzT8nzhE6nZFkDunh8jP9n5fWtLWto7GJzaFX
   l4BF6u28KCy1TfhSgGzgQvtafUy0yu4aJB6muecTmMSzRj9dLdOsC6gT6
   I1uNWBV06EI//ORYiXYR6ybVd5kw8vQWUaUsK7YYV7z/BYmTf2n8qCFRm
   WJvliSazxjCRH3cSvZgMD2fdJ6ShL1RpW1Kst9KnLvWQQUiTsbTKEaJce
   w==;
X-CSE-ConnectionGUID: SAg5WtbYQz+NokcCImAEdw==
X-CSE-MsgGUID: ZVQ1dOpZRV+gaTeodgjfNw==
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.25,207,1779148800"; 
   d="p7s'346?scan'346,208,346";a="17457505"
Content-Type: multipart/mixed; boundary="===============1236519062373414265=="
MIME-Version: 1.0
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 19:55:36 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:3904]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.19.18:2525] with esmtp (Farcaster)
 id 11fc8daf-2bba-4520-b3e9-88d637455400; Wed, 5 Aug 2026 19:55:36 +0000 (UTC)
X-Farcaster-Flow-ID: 11fc8daf-2bba-4520-b3e9-88d637455400
Received: from EX19EXOEUB002.ant.amazon.com (10.252.51.83) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:55:35 +0000
Received: from LO2P265CU024.outbound.protection.outlook.com (10.252.51.94) by
 EX19EXOEUB002.ant.amazon.com (10.252.51.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Wed, 5 Aug 2026 19:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CPAFoJEIC7n/JcpvIcMYT41TJCI5qq9uQ7bIXZXSCWCzMe4j1Lm+zxsTIQJ0Wj8jcQeoPFbAijsLV0XP47MKhw3qLvvz0Aa6cOpelII5C1qnhKfo3P6CUgdVaO3fuQGmYSiyYyXN+8fGRjIYrqCnomzRJPM8Rr4IEM7iD720MoXFnVosp2qlK461LeR84Er8vcbX+Vq4JERpPjfdx5ZQp1dzecjjBSQfkELMhmKW6QmfVAWB40Wvqt3qqNVHDXvRocHiNbPvfnuuQ+sBuaw3k69O5mIWGJL7oS4GCmr22X4V2LzYYik9NKap2SgNZbQeF4TxdO1mk2fzQepEWDQ/Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=ngxgziKwOT7eIcLhAUyAi8m4wUG3EYeZMgkNjiI0GS8=;
 b=adx9z0TGJJghYrGX/x1LnDaYxN8ZFCZ6oXPQDLvEKjLcOWk9y4h835UIxdY4lTPyzTAINE19MXyinCX7IbtrZB84368aRJsyIvB0NeW1DVJKHCfBqJxFq6ww0dsvO+gxNfAd0B62iaUTdnGffbOESx/4QsGdd8xzpVEloWpTZglUI7hhBCqAo3irvUUPmBLHg8H+wxlID7enCOhVlZdWCabqDQob73AQUz+EOL9VBMJCw/m2iz0pKDdyt5WzDDjpb4Q7OLMYCvBEsB1Bz4K7rLW27j/1As050Lu02o2FczyFCWdA5HPTnQTJ3WSFT8409zTSXM59JH6W/229b07IFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.co.uk; dmarc=pass action=none header.from=amazon.co.uk;
 dkim=pass header.d=amazon.co.uk; arc=none
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4b4::12)
 by LO3P123MB3417.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:bd::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 19:55:30 +0000
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6]) by LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 19:55:30 +0000
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
Subject: [PATCH v3 0/7] KVM: x86/xen: Fix Xen/GPC/PREEMPT_RT issues with
 rwlock_t
Thread-Topic: [PATCH v3 0/7] KVM: x86/xen: Fix Xen/GPC/PREEMPT_RT issues with
 rwlock_t
Thread-Index: AQHdJRReCr1kXMmN9Em16L81wB4+3w==
Date: Wed, 5 Aug 2026 19:55:30 +0000
Message-ID: <20260805195528.3853473-1-dwmw@amazon.co.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LOZP123MB8516:EE_|LO3P123MB3417:EE_
x-ms-office365-filtering-correlation-id: e7347f33-4f2e-43ec-e9d5-08def32b80cc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|6049299003|7416014|23010399003|376014|366016|1800799024|38070700021|4053099003|6133799003|10067099003|11063799006|56012099006|5023799004|18002099003;
x-microsoft-antispam-message-info: BpuV+X7sF/tteLGjGmHOOtml1HOo6hhzut9nUs2D1578R+/fqkOLguagEeSStPUtDIoGxHImEZdgxfXTgBtIDyytA3AruHOWd4b7AsKC05Pg60nmvdvLOuJogIjq+ZpW/2zzACMXVhgS2AFI5YX5/yiuWlh/QgBRHuz7Dcyq96jTl2lX3iIQSLUsLH07z4MXueTLG58VDNhWggfds69OlofS341Oov9WtqQS36HJN0KNdcoHK87u88PaZWdehHJV6UPWkFpKN/HDIaTNnn74LfjsUSxOVQEjNCWJNMEGeawsNvvkMnnjKJ+sBfEOSl0wX9ooZAGT2+JwVRqNzQxfkTr0zk293xkiH9tjHqBaBEzTlnWigySMk/n3NUaUO5piZq1VadHXhK4ww+NWfhlGnmpwTxu4nyNnQkAKMEYdai7IYxd7LPktPPp8ae7oBnZ7F/G8mVle90as7b3+1xdcHUtg1Fg44d5C7Jmh0XdmAXX/xZkdU4qc5M9UIr7YoNv8/uQtkgW6G0cIOSzL9MAyH+vyImCQuLjqA5PgdNodhm2mGIAs/vpApHYzCt7FS+8mI8AUShEDJDz4DjSAcaMMF1E2pK1zK3Lfzdjn9OyFrihnhr7c2SUw3q8zudqt5OQpjVjdIo3DNqwvo+A00bf7+hqQod3ceJPmkJn+py7d+/by12TSE3Zni6wQ3rsCb7agLlVJW+HjDi2id93LE4e8I3iY+o7Ase//ifhZfP+SGXU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(6049299003)(7416014)(23010399003)(376014)(366016)(1800799024)(38070700021)(4053099003)(6133799003)(10067099003)(11063799006)(56012099006)(5023799004)(18002099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZkpmR3JNcmVqR2lsMHBOTWxPUlFBK0luRzI4T1l6VmdQa040NVRpWXo1T1Mx?=
 =?utf-8?B?OFdRWnB5cS9hT0dVK2JVRlN2L0hmQnhoRzBXOU1FV1FzM1NWOGNncEpCUWtF?=
 =?utf-8?B?ZnB0VldXcmE1TGRCT09HekdSVy9Ed2lBNnhjcXVRR2tIbVZRVWpwc2U2L2Zw?=
 =?utf-8?B?MGFaNm9Ld29HRURBeW9zM0w1UGxVc1l4OEtmSkFrSTY3ZXYzMURDYy8yaWZC?=
 =?utf-8?B?M0hjVU5VOTNZSEpodCsxcVI4RC9WdVltSjY0M2VTcFNUdGlYVDc0NDlqajFz?=
 =?utf-8?B?Qm5Zems0eUtYbnJ1a3JTOXhESEpCaXhkVEZQNGtjSVhLNXBkNitlTkNXUmp3?=
 =?utf-8?B?N05CaFk3VnVoa1ZOQXdQdlNEdnUyUUpGSTFPMzFiRkNtYnNJNHFqdkYzT29y?=
 =?utf-8?B?WGRUdkplREFQTlpJd0hWSnpxUmlsYVA5enUrSlBJYzRtRHh2YWtKczcwNlBk?=
 =?utf-8?B?djIvcmZ2b09sWEY2N0s4MzNaU0ZaM3lYd1JIM3FPUjhYSEhMVEpRZEF3eVE4?=
 =?utf-8?B?UlBCYTV1T0JHSVlQVGJZYldqc0d2aS82WlIxRkZLeFVQNEdTM0VHVkZrN0xN?=
 =?utf-8?B?L1VDcFFJNjRhbExhRzgvN3ZyOTFoNHJNK0lPcXM3Y3luNG1BQmJwOWVaRzd0?=
 =?utf-8?B?S3VVN29sdHhZUGk2YUx6Sk4wMnR2aHdzRWk3ekh0NW96Q0I2M1pHMDNTS3Ji?=
 =?utf-8?B?NnNCSGZKT0pXS0dKbUpFTW9NOStZTVpyM0VKRm1oNUkyc3k2T1o3S1hua1Qx?=
 =?utf-8?B?RFFTSnFZaXVEMENDVFNQTHluM3pweGxzaS9sZkZnVndqZ1U2bjV0VFBVdU82?=
 =?utf-8?B?K0V1dFE3WmlZc1FmQUdlL3Ywam5SUFcvY0QzakZuR0pnVWViOTNqVmxyMmt1?=
 =?utf-8?B?d0tNSUVRU3RvT2pBSVA0MFQ2YkhFb3N0a3JBeWQ3aFF1YzFod1hYWHhHV3Uv?=
 =?utf-8?B?Tm02OTJRRUYrM3JxLzlqMHV0VFpiRDNRTXdPZ3pTdytQUTV2RmUwSkFSZnhp?=
 =?utf-8?B?Q0wySDU0YXF2Y1drYXdOckd1MFVLVHhpNERaZE14dFFCY1c1RVY4QXdqQnZy?=
 =?utf-8?B?dVR2R3NNMDlFMWNZWWVuT1lOSkN3MEJsWUgwN2xGZFRDeUl1a0xzbHlwV0VK?=
 =?utf-8?B?cExYSWVEWERPUnhyZ1NFLzFnaitxbGIrWk5TUEhnaXJMTElKN1hMb3pxN1dN?=
 =?utf-8?B?ZEF1QWNUbTRueGFhOGxHM0wxWXJIMHdxMFF0dVFrYlVGZE4rb1JWSEU1Q0hZ?=
 =?utf-8?B?a010cHorb1NQWmZPTUljUHF6MHJDVWdvT3ZSN2FaZmJ1cGw0VWdvZEhWUDNj?=
 =?utf-8?B?bVFCMDZNL0E4UUVuYU9RQUhnK1hyVzlPOGVzRUZYU2VNSi9CR0RIdEhTSlpl?=
 =?utf-8?B?d0trUkJuL3Y5OUh2U0xleU9wdGhnWWJUS3l1eHBmTWNBZlpIVnJscEZMNE83?=
 =?utf-8?B?YTdZMDlJMHZFYUw3a2N2a3kyNnlxWXZzUys4Y0xPMW10amF5czZuMi9xYnRl?=
 =?utf-8?B?aVI2N2g5RURvRE5RVVdKdkNtY0xCVWRBNVpnV0NZTmhEb2Rwa2Fzei9RV0p0?=
 =?utf-8?B?amFBTWw1Nzdud1R2MFFQRkxKNGg3R1hPVzQyVHpPTlhPVjFMWFljNjIxM0k1?=
 =?utf-8?B?K2NQOVM0VFpTL2JMN0paMVRIV3NxUVFYU3l3L2JLOEVxQ1lkaFNML01jVW8r?=
 =?utf-8?B?dS9qK0ZZZ2ZDS3dOR3QwR09BS2V1TTlWcFFGWnVITEJwSFRQaUVkZEFrdHdt?=
 =?utf-8?B?WW9nNC9lTHJxbzhaNWwrbjBUS3lxR0U1MlpwdWFjOGxKdUxhYkovVHhiaDVY?=
 =?utf-8?B?NGlSM1FIc3BocWhqalJMR0FmaFM1V2VuNFBRZUErclpLRStINnhIRDd0Y1JM?=
 =?utf-8?B?SGtzTHByME5taDZyNm4zWjBuaDhHMzh2V09mS0tWUGxJeGFUVTc1dnZVNmRq?=
 =?utf-8?B?VlBGSjFsWFI1NVpFVTF2SXlCOUJJOVo2Z0xHdVI1NUU1YWtTRVdDRW9iUVoy?=
 =?utf-8?B?d0pQMk4zNGVVNTdYUFE0U1dEL2U5SXJJSCsycExuUmJJK0lNMEpRY0pDdGpC?=
 =?utf-8?B?dGlzdGkyRWZNVDhvQmhXcnE3YVB0V3Fqdy9MSXlwL0wrMVFCVmVaLzhlK0pK?=
 =?utf-8?B?am1kQ09nTzJheXlOckU4cUw0N2czNG9KaG5pQTM5T3JHYy9Fc2ZQMDRDZmtt?=
 =?utf-8?B?bmkvaGM0b0F1cVJQMzdJRE1KMFFCdnhmRXVLS2Y4L3VsWHZ2T3k2bCtXUEx0?=
 =?utf-8?B?RWMzMlNWUnRtemlWSjg1TTZXQkd1SDBKa0dMUkE1RjVjWnRvck9JY1RRUTJZ?=
 =?utf-8?Q?r/A5rjWUd30I61JByu?=
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: XM39vONzxy1y+wwcswC5DGzJPuoJhn7AQQXrT78MpZQlVjTzxzqafCQXqXnBsYGcGUwaMAN6/+BZsE/cUT5PPWz5DlAi8KGwGtHdddfhB/MtcPJdPGOc/vvyIXFeu0HXxSzZjCrt7oHCSwDHhiHwaf5JiDAjBD+2iqaEU7WTu1bwaL/nMQr7rAeCl9ZWTNIr2EvIt3uptXriDTBuAmsl58MJJhDlR/nk1rKhuvnjtToBmRiwtqTGVetS3u1OQZawFumAETrApn6y+AI7SBdhl/7HQpvPdgqOgI5371JmBumGoeVX+wO32i28KHrOb08LyyvKojqFikvF/Wo8bUB6HQ==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e7347f33-4f2e-43ec-e9d5-08def32b80cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 19:55:30.2410
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Opeviyj+RSNSgJxariK+qHxe5EUpscei8hWA2dfx5xw9B1oWJ79GQQo3BjLNIcNqdnP2SefaZ2cTf3hbkfnoEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO3P123MB3417
X-OriginatorOrg: amazon.co.uk
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ceaddimwgpsnn3qit5anpmouto6o5i5k
X-Rspamd-Queue-Id: 34A8220010
X-HE-Tag: 1785959739-375276
X-HE-Meta: U2FsdGVkX19ysGkqx78onVCzNrioYmvXsRnJmHFGFOtic0zUtRLkO3gAMamswmvGK49ESlq7OufjIzWruZfQtSWfWOqU6U/mTY5CDMYGo0cs7JwyNNM0/jTFwCrayYe/JWpFUFVZtl88tMc1qNo6D4vja7Kokj7Gr1IR9WiAemyUcLSzzd4UZXoXFK/UodYr4GcWd1V/TxVWnekxYNT50b33InZwqMCYGf+X3mJgzUGbopqIaqyFHiLv47uYtKRFzSyY73+VOOVjoIJXPWH+h9dQzu+yaGIV1/jSL2mIkKLAKvS7lu5zg/WHaQNpM52FIzMciG2UMtIsTeMIAtydAbdTVxIh4CabFae0dxoarHqNWnAjqHNZtv6c3Z4plUpEd3TmFDswCBPZdkJuBT3u1nAFZ2Age3lIfZVpPaRoMr32qZzjCLrWsLlHF+q9MQzrO9w/CoNjM/JD+4TyXjSjD8qbvLmVe328VOa2nrKia64wuV6hdIKUfgeRQZeNJhsh4b7t8olFf67rPBhXekrDVodB2dBdwRbldNBSYgwO9l6kviYdEI/+x3LChGM/9Syft7BiReN3E5GJgcRUwPvXrQhFh/ys2/OSNVtOYj4GqcN8ZEx86I3PS1utmLGENeasc9KnP4zwqrX4ybndTeI3RLOG8ylg57V8MaX+l7zGjCSDLXX3cjIKLDuBNLVYDos59UHHaxFxd1TReSzlw7cxqt9eBaE88f9kUha1rioqZkLqV2m14ELGJ893hwnU+AGUosYzailJMIp1HahFttm1leJKDYpsLEGTztcRTj8VzF/OUso+uITSlvwjZ7ABBzp73tdxdgDntGZw7ibWNCEC+TNykEoNFxYIpVo8sZrlfM2yWVh3oR7krmkNqBnQ4j6Pa41BKRoqqBYwgL0mY4s+BVYmswy0BERQwjatzc3NRNr2ml7+zaEtjC4LxGGLKxPrVyciCxbHZM25rn24/K4
 YSzvJg/A
 +7S00X1W2EaeNe6SEtmXio4IPB2tch/chp+ASNPsp5oh6cV9TuL7L24qLg08KKHYU6XXHM7sbsKrkZMrWztMtQ4Oz915WwqnGg618r5m3mw8/q0+l9pR+IB35csonAl6A2U7aDVLfxerlBZXXlAuWNVlriqj365gsgwrAuepAn1RctjvLPVH7Qi7tOpeq2+KXf3aO2GQb7/x8rBkTF9KOyHc9A4go1TxuJeKxz+uSK09LAjiRZRXfthUD5U3LNzbBisJkowO4nJ0BiUyXl3OYbvLORyrgbDDSiuzXiGnHn4h4J22C5CLOMj0nXPOiHualNwuRY5BP34ve3Ago446w9igzHfmoPNAHnj9PjrCfNPaO4sPr+LEbBDPJKz82ue1fd0bIOLFbbK8t0P/2eSw/oMMCKIVFJXqk4XOekzWTW+RdSWfPMW+D+4PLE67us46TO4rPfWbFj/YGscQaicJro79y5BGSq02CcLY8vCZQPL0OyF19AnIq1XaYrbT16udVvl5ffZB5GmxtYmsfKGREdkN9zirXROhsHIJ2aYR7iFdQpOI+Hl3X/+kcamYe/8flALsZUwrnec7MARhHBVjIUsPUPyp4C5RMTcbw0dQxiH5msJ1c7cTsCT/GOnOkc17wbP3eUpYrh0WDCbvpZDjI0/L4h0lWI5A61i1t+OQGVsUY6H3a6ADmZUovumQEGee26LLw5+w5dYz0l/ek637XHS4BpjWz/vXwDdMs5LhFX+33fKcwqaQrVK0IgmUJKKwcAKsyVB02VK1CNwquuQFayZvOtdet8w0s+O+T21uIZWlpMHMVcmproIZWUXI4xQB8sXJ5FmMiv3r5Zhpl66RgG/xNb+AaBjX61rd1Fgp2hdIex6trVYhz06q+iI979OQhbnPO3nbYP4nLhKB1YLA3m9HXN9F44KegrRSMgsHYqDswcNY5Ts05vt/dIU2EcXiUVezSZ8eHJUfhT6vhuvjzvd+ejuzF
 D5TwwoAk
 BqqXfkRIqE3YH99Pm2M9Yrl1YN0XCBmdNxFqKtZ8YZdLfGOcdc4qsNw7CeNaHA1nOUeev/Gf8wpt+V7D62aoavXPAdFH55XD6yxYAyEOvDxAgrrce2b4YYvG7ftTrK5wHlUoMiOU5WaRSB/9b14nftrsAxvyVlRET1qQqyIXd4DMR6xcE01pw36DMadjhjhsJAYylDYQ2TDlfmhv6RuDgemW00HcF8tYo6ybM6/UR8pMJjBy8U450aL+B9h6TTSMENJUplavl/R+5qOAgBf42w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============1236519062373414265==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha-256; boundary="----C358ADDD16088E5A01AC7B1B9F53896F"

------C358ADDD16088E5A01AC7B1B9F53896F
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The gfn_to_pfn_cache read side is currently protected by a per-GPC
rwlock_t. That is a problem on PREEMPT_RT, which turns rwlock_t into a
sleeping lock, when the GPC is read from hardirq context (the Xen timer
callback and kvm_arch_set_irq_inatomic()) and from the scheduler path
(kvm_xen_runstate_set_preempted() via kvm_sched_out()).

v1 and v2 worked around that with read_trylock() and a pile of related
cleanups: dropping the now-unnecessary IRQ disabling, and adding CLASS()
constructs to make the lock-and-check dance less error-prone. That series
stalled, partly on the observation that a trylock which callers must be
prepared to fail is an awkward contract to build on.

This version takes the locking away instead. Readers run under
rcu_read_lock() alone, which is legal in every context a GPC is read
from, never fails, and never spins. Mutators clear gpc->valid, wait for
a grace period, and only then touch anything a reader might be looking
at — exactly the pattern of a TLB shootdown, and for the same reason.
That deletes the trylock contortions, the double-lock dance with its
lockdep subclass hack in the runstate update, and the CLASS() machinery
along with them: 15 of the 20 patches in v2 simply become unnecessary
once there is no lock object left to manage.

The only complexity is that the OOM reaper path currently calls
non_block_start(), which is a little overzealous and makes the RCU
grace period sad too. So we rip that out in patch 2.

Patch 1 is the standalone fix for two syzbot reports, already posted
separately¹ and verified by syzbot against the published branch. It
is Cc: stable and stands alone; the rest of the series is cleanup and
consolidation on top.

Patch 2 removes the non_block_start()/end() annotation from the
!blockable mmu_notifier walk. This is a prerequisite, because the
invalidation path now waits for an RCU grace period. That wait is safe
even for the OOM reaper: the actual requirement, per the commit which
added non_block_start() in the first place, is that the caller must not
"have an indirect dependency upon the page allocator and hence close the
loop with the oom reaper", and a grace period has no such dependency —
GPC readers never allocate, never take mmap_lock and never sleep. The
annotation is coarser than the requirement, though, and forbids *any*
voluntary schedule, so it would splat regardless. It is already known to
fire spuriously on PREEMPT_RT, where a plain spinlock becomes sleepable;
all of this was gone over at some length on v2². Cc'ing everyone
involved in the original code.

Patches 4-6 are Sean's from v2, unchanged in substance. Patch 7 is
Carsten's steal-time conversion, which Sean explicitly did not want to
take in v2 without more confidence that it would not regress setups
running NUMA autobalancing and KSM, on the grounds that steal time is
updated on every vCPU load rather than rarely like KVM_REQ_CLOCK_UPDATE.
That concern was well founded, and measuring it turned up a real problem
(now fixed) in this series — see below.

Numbers
=======

Booting a Xen HVM guest (QEMU -accel kvm,xen-version=0x4000a, 4 vCPUs)
on a KASAN + PROVE_LOCKING kernel, timed to the login prompt:

  rwlock (patch 1 only, pre-RCU)  45.562 s
  RCU, this series               45.551 s
  RCU, without the fast path     51.73  s   (1400+ grace periods, 5.9 s)

The middle row is the point: the RCU conversion is performance-neutral
against the code it replaces. Getting there required keeping the
optimisation the rwlock version already had — a refresh which resolves
to the same uHVA, in the same memslot, for the same gPA does not need to
invalidate anything, because the gPA => uHVA translation has not changed
and gpc->valid already asserts the uHVA => PFN mapping is good.

Testing
=======

 - syzbot's C reproducer for the shared_info UAF: fires on the first run
   without patch 1; clean over 12 runs with the series. syzbot has also
   tested patch 1 directly and issued a Tested-by.
 - Targeted reproducers for both syzbot reports (xen_shinfo_race,
   vcpu_info_race) and one for the steal-time cache, soaked 10 minutes
   each under KASAN: clean. Instrumentation showed vcpu_info_race only
   refreshing the cache 16 times over the whole soak, so treat that one
   as weak evidence; the other two drove 4.2M and 147k refreshes
   respectively.
 - xen_shinfo_test, steal_time: pass.
 - The reproducers cover both sides of the fast path: syzbot's alternates
   between two HVAs, so the fast path correctly declines 2506/2506 times
   and takes a grace period each time; a single-HVA reproducer takes it
   4.07M times out of 4.2M refreshes.

Not addressed
=============

Range-based invalidation, and the needs_invalidation flag from earlier
drafts, are both still absent. With the fast path in place the
motivation largely evaporates: a cache which is invalidated but whose
page returns at the same address costs nothing to "refresh", so making
the invalidation itself more precise buys little. I would rather not add
that complexity without a workload which demonstrates it is needed.

  ¹ https://lore.kernel.org/all/6a734239.d1b4d54b.5552d.001c.GAE@google.com/
  ² https://lore.kernel.org/all/20260601134008.rllwJtn-@linutronix.de/

v3:
 - Use RCU for the read side instead of read_trylock(), dropping the
   CLASS() APIs, the irqsave removal patches and the locking/rt patch
   (15 of v2's 20 patches) as no longer applicable.
 - Remove non_block_start()/end() from the !blockable notifier walk.
 - Keep the same-uHVA refresh shortcut, without which the conversion
   costs a grace period per mmu_notifier invalidation.
 - Restore the KVM_REQ_STEAL_UPDATE early-out on the MSR disable path,
   which v2's steal time patch had inadvertently made unconditional.
 - Rebase onto kvm-x86/next, where the MSR handling has moved to msrs.c.

v2: https://lore.kernel.org/all/20260529165114.748639-1-seanjc@google.com
 - Add the CLASS() APIs.
 - Move the steal time change to the very end.
 - "Fix" a dirty logging inconsistency with the Xen vCPU info page.

v1: https://lore.kernel.org/all/20260508181717.3230988-1-dwmw2@infradead.org


Carsten Stollmaier (1):
      KVM: x86: Use gfn_to_pfn_cache for steal time / preempted status

David Woodhouse (3):
      KVM: pfncache: use a dedicated invalidation sequence for cache refresh
      mm/mmu_notifier: Remove non_block_start/end() from notifier invocation
      KVM: pfncache: Use RCU for readers instead of a rwlock

Sean Christopherson (3):
      KVM: x86/xen: Extract delivery of event to vCPU into a separate helper
      KVM: x86/xen: Explicitly tag "shared info" page as never being dirty tracked
      KVM: x86/xen: Don't dirty track "vCPU info" page

 arch/x86/include/asm/kvm_host.h |   2 +-
 arch/x86/kvm/msrs.c             |   7 +-
 arch/x86/kvm/x86.c              | 128 +++++++++---------
 arch/x86/kvm/xen.c              | 200 ++++++++++++++--------------
 include/linux/kvm_host.h        |  28 ++--
 include/linux/kvm_types.h       |   2 +-
 mm/mmu_notifier.c               |  11 +-
 virt/kvm/kvm_main.c             |  10 ++
 virt/kvm/pfncache.c             | 282 +++++++++++++++++++++++++---------------
 9 files changed, 369 insertions(+), 301 deletions(-)


------C358ADDD16088E5A01AC7B1B9F53896F
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
DxcNMjYwODA1MTk1NTM2WjAvBgkqhkiG9w0BCQQxIgQgKJcxGrHtxa+goy6LHBsjVFihajdv6I2A
K1iD5g2FO7wweQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggIAOC4fv54LUV6njjj1G49KpJ/bR7AU
Arde+/AzvB9ogIDclCzOrAFyImM+OIiyh0Bt92VYufTusrGAxHP34Jbra192araUhDeA9JezKTv1
M5IbzY+cV+bPUaJwUlYq1ueK+IHWQEnpBYw+rM+iA2dbp7dbT+TQ3vGauosEilqxSiE3SiE/lGQN
QmIAE62MontiLA7rarZD3r1qhcds8JzBfphsDfIE/xm42nX5JJ5tRo4aaUZoYQijwpDuFPJDZnA0
A8kMhaa3QDGGXMYTCTx0KkN2WF7MefH4ReVUQoEkPqyXa9FCV86uUyTAkeHXywpO9PxoJHEy3XZA
NH+ferYx9qJTingHvQiQKCZlh2JluVulm/Z/zxNnOEv6jRDhmOW1ZowYRWTtoslkGGqAZzab3+Cb
n82kRsqUNU2tGZ/q9tBhHY7xuHsM3VUuTy9jzYIbYSDvBoMmSSbt/otOnmoNK4kTSj2T8ArMJzHh
et0HCkMVbrCm/ItpG6P7zEolTu1cCTSImEhDY9eu9FZCXBQZILlVn2LuKDcjbt8un1OiLQy6fLqr
UjVU9+dHVeCeDWGPIV5k8KmaJSCOjAEYxlvQuHvz39bg5c1ZVjw+owLU8hu3NuNKZHEB0oXZvCIr
5ofddzcS96tEl2HcVNAI2zS2jnTL2DTONLGsW3wj4DWMl0U=

------C358ADDD16088E5A01AC7B1B9F53896F--

--===============1236519062373414265==
Content-Type: multipart/alternative; boundary="===============5444179671685952833=="
MIME-Version: 1.0
Content-Disposition: inline

--===============5444179671685952833==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============5444179671685952833==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============5444179671685952833==--
--===============1236519062373414265==--

