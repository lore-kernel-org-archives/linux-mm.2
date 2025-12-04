Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAFE1D21683
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2258F6B0062; Thu,  4 Dec 2025 09:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FD566B0093; Thu,  4 Dec 2025 09:49:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028886B00B9; Thu,  4 Dec 2025 09:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E2BD86B00B1
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:49:05 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A24681A01F2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:49:05 +0000 (UTC)
X-FDA: 84182071050.13.B5DB625
Received: from mail-edgeka24.fraunhofer.de (mail-edgeka24.fraunhofer.de [153.96.1.24])
	by imf04.hostedemail.com (Postfix) with ESMTP id 408A940004
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:49:00 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=aisec.fraunhofer.de header.s=emailbd1 header.b="WXhZmid/";
	dkim=pass header.d=fraunhofer.onmicrosoft.com header.s=selector2-fraunhofer-onmicrosoft-com header.b=hB1dSTFO;
	dmarc=pass (policy=quarantine) header.from=aisec.fraunhofer.de;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of andreas.korb@aisec.fraunhofer.de designates 153.96.1.24 as permitted sender) smtp.mailfrom=andreas.korb@aisec.fraunhofer.de
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764859741; a=rsa-sha256;
	cv=pass;
	b=DXMM4ajrin02pRQ67bcxRp9flgC88umxh1XxePoGbLALD8DGlwKFJVWLQ7HaSObXLFpTZU
	0lqor2wAkgoug8k01r2Nnnsg2RwHLcoCYshT6O+h4r+tfF1hPmfLHiqlWh15OMy+B4Y2WU
	X9Azgy/z1T+rgARhiV78Nlw/4Hr0l8g=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=aisec.fraunhofer.de header.s=emailbd1 header.b="WXhZmid/";
	dkim=pass header.d=fraunhofer.onmicrosoft.com header.s=selector2-fraunhofer-onmicrosoft-com header.b=hB1dSTFO;
	dmarc=pass (policy=quarantine) header.from=aisec.fraunhofer.de;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf04.hostedemail.com: domain of andreas.korb@aisec.fraunhofer.de designates 153.96.1.24 as permitted sender) smtp.mailfrom=andreas.korb@aisec.fraunhofer.de
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764859741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RLMriuCadsnJtGQYE3HzU9vrXSvvNC0CshUqifJncdw=;
	b=N/2rtkAuGIimvuVn4bjqmZ2J+KJtl//LKzDewy5qAPC+FlonY4uYp/gpGUCHMH09mGi7QM
	p9BelR8gdmvZkxPD1z3mW7fFP9D/ILyrT6U2pk7eKNFmtyjV5mqnYIusMUHcXHO6JfN6XQ
	CMH7sqDPM00tMhE3pPEnzy7qRz+eVCM=
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=aisec.fraunhofer.de; i=@aisec.fraunhofer.de;
  q=dns/txt; s=emailbd1; t=1764859741; x=1796395741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=RLMriuCadsnJtGQYE3HzU9vrXSvvNC0CshUqifJncdw=;
  b=WXhZmid/M/bHgUk64P4GBdz3YBlXavC7b9higCXqxODupsYLZ/tbLa/J
   Q+U/DHvQQQ40i/tcYqicbU/tWWtuQxAXbTWKDdEHM92M2YNAt1peKofqR
   RBEj8H0YaimiRs58ihqpHtMLc31nuP97JKP0di64s1+qgnyaGVeyQ880r
   Tn8/aRlaAWN09MuitGiskIIGic5VTjuhu8mAauaVxQsGzaDs0QCnW1HC5
   t6fVgNeg1kkE3/6+DRRXPFveMQ2IYRzSgDvv225/f0A/mJTAEkpxV6Gzj
   HiVyeCduH9D6bPW6CPL4E7mUjTpgBTraxFUKaMTKxkO/JhsHsCg58SUNZ
   g==;
X-CSE-ConnectionGUID: AN0oiS9bQCOVIxKvd/mw4w==
X-CSE-MsgGUID: VXYcgOLJQ1abCX28M8TnbA==
X-ThreatScanner-Verdict: Negative
X-IPAS-Result: =?us-ascii?q?A2F8BACQnjFp/26aZsBaglmCQEABgi+zO4JQA1cPAQEBA?=
 =?us-ascii?q?QEBAQEBCAFRBAEBAwSFAAKMaCc3Bg4BAQEBAwEBAQEBAgUBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQYBAgEBAQQIAQKBHYYJRg2CW4EsgSYBAQEBAQEBAQEBAQEdAjVWBjIBD?=
 =?us-ascii?q?QEBNwEPC0YxJQYOBYMCgiUEEgM2tEGBAYIMAQEG2ywYY4FkCQkBgUGDfIFyg?=
 =?us-ascii?q?mUBhH1xhHg2gVVEgUqCRDE+hFg4hXeDNJlZSAp4HANZLAFVEw0KCwcFgSBDA?=
 =?us-ascii?q?zUMCyoVIw88BS0dgSMhHRcTYD0XQINJGAZnDwaBERlJAgICBQJAOoFmBhwGH?=
 =?us-ascii?q?BICAwECAjpVDIF3AgIEghV9ggoPiAKBCAUueycDCxgNSBEsNxQbRG4HlB1Pn?=
 =?us-ascii?q?HoBr2s0B4I4gWeBXgYMn2caM4NxAZNukwuZBqkVAgQCBAUCEAiBfoIAMxokg?=
 =?us-ascii?q?zZSGQ+OX4NCvFZ3AjoCBwsBAQMJkh6BSwEB?=
IronPort-PHdr: A9a23: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
X-Talos-CUID: 9a23:KjLVjm+C/v0D8VgpSkiVv2cyQsckSSzX9Vz3HW6oKnhlD7iKFUDFrQ==
X-Talos-MUID: 9a23:9cyZfwVhyTwEW3fq/AHctTptE+NK2v2nAms9y8Uj6/WCPwUlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.20,249,1758578400"; 
   d="scan'208";a="35871884"
Received: from mail-mtamuc110.fraunhofer.de ([192.102.154.110])
  by mail-edgeka24.fraunhofer.de with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 04 Dec 2025 15:48:58 +0100
X-CSE-ConnectionGUID: R2ey6dyKTG6r5WO8t5qLvQ==
X-CSE-MsgGUID: N7rred/aQQGpEMFPjRjtbg==
IronPort-SDR: 69319f57_RvHhPWIKeXjDMJ9SPWJ2DmC3z4A6GdwOaWmMVtG0e+cCZC2
 0cgXZJ52i76GHhFffTbS4TNPD5W0xJNIt4u/ekw==
X-IPAS-Result: =?us-ascii?q?A0DYBQBT7aZo/3+zYZlaHgEBCxIMZYMcUkABgRyBCYghA?=
 =?us-ascii?q?QGFLKVoglADVw8BAwEBAQEBCAFRBAEBhQcCjCUnOBMBAgEBAgEBAQEDAgMBA?=
 =?us-ascii?q?QEBAQEBAQEBAQsBAQUBAQECAQEGBYEOE4ZPDYZbAgEDEiABDQEBNwEPC0YxJ?=
 =?us-ascii?q?QYOBSKCYIIlBBIDNQICAqcoAYFAAoxXgQGCDAEBBgQE2yEYY4FkCQkBgT+Df?=
 =?us-ascii?q?IFwgmQBhHxwhHc2gVVEgUqCRDE+hRCFd4M8mlBICngcA1ksAVUTDQoLBwWBI?=
 =?us-ascii?q?EMDNQwLLhUjDzwFLR2BJ32EGYQmK0+CInWBd0EZP4NTHgZrDwaBFRkdLgICA?=
 =?us-ascii?q?gUCQz6BXBcGHgYfEgIDAQICgRwaQAMLGA1IESw3FBtEbgeTVZ1zAa9rNAeCO?=
 =?us-ascii?q?IFngV4GDJ9nGjODcQGTbpMLmQapFgIEAgQFAhABAQaBfyWBWTMaJIM2TwMZD?=
 =?us-ascii?q?44hPoNCtztEMwI6AgcLAQEDCZNnAQE?=
IronPort-PHdr: A9a23:GlvtVRQ8jDuhEmGKkGBg30+fndpsouyeAWYlg6HP9ppQJ/3wt523J
 lfWoO5thQWUA9aT4Kdehu7fo63sHnYN5Z+RvXxRFf4EW0oLk8wLmQwnDsOfT0r9Kf/hdSshG
 8peElRi+iLzKh1OFcLzbEHVuCf34yQbBxP/MgR4PKHyHIvThN6wzOe859jYZAAb4Vj1YeZcN
 hKz/ynYqsREupZoKKs61knsr2BTcutbgEJEd3mUmQrx4Nv1wI97/nZ1mtcMsvBNS777eKJqf
 fl9N3ELI2s17cvkuFz4QA2D62E1fk4WnxFLUG2npBv6C63VlzH7q8F01DKcH9HZdIEZAhSw0
 vZ1Ui/TljkhHGYS62Hqk81+rqRQrA309Hkdi4SBYKvMOMFCUITXZfxHSmF/A8h+ByZgEoS6X
 qw0FNQrAflik439/WkrjSSsKVajJ+nLjTtI1yPK/agU1tx8MRzX3yUPP+9NjFD0te3JBosuD
 Mry0u6T4RXPTv1p4Q+++qflfgkjuuzSVpsvTJTT70MUSCXAj1SQs6XEJgzM5NUq6y/BzrVyb
 /6egVUWqD9YkymMn+QnqdHgiYcHx23l+XtAkLwzKtDgEBdYQfWFRcgYp2SbLYxwWsQ4XyRyt
 T0nzqFToZegZ3tiIPUPwhfeb7mCb4Gt3zm6Db7XLy1xmXRlf7yynVC+/Bvoxu79U5ys2U1R5
 mpek9bKv2wQzRGb9MWdS/V880vgkTaC3gze8KdFdGg6j6PGLZ4mzLMq0J0VtEXIBCjtn0vqy
 qSRcy0Z
IronPort-Data: A9a23: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
IronPort-HdrOrdr: A9a23:vN52uqjrIAk2tJX0SjrM0Ucqp3BQX1d13DAbv31ZSRFFG/FwyP
 rAoB1L73PJYWgqNU3IwerwQpVoMkmsiKKdgLNhdotKOTOJhILGFvAF0WKP+UyCJ8S6zJ8n6U
 4CSdk1NDSTNykCsS+S2mDReLxAoOVvsprY/ds2p00dCT2CAJsQijuRfzzrdXGeMzM2YabReq
 DshPZvln6FQzA6f867Dn4KU6zovNvQjq/rZhYAGloO9BSOpSnA0s+2LzGomjMlFx9fy7Yr9m
 bI1ybj4L+4jv29whjAk0fO8pVtnsf7wNcrPr3BtiFVEESitu+bXvUhZ1SwhkF0nAhp0idorD
 D4mWZvAy200QKSQoj6m2qp5+Cq6kdT15ar8y7mvZKkm72/eNtyMbs+uatJNhTe8EYup9d6ze
 ZC2H+YrYNeCVfakD36/MWgbWAdqqOYmwtXrQcotQ0pbaIOLLtK6YAP9kJcF5kNWCr89YA8Ce
 FrSMXR/uxff1+WZ23Q+jAH+q3lYl0jWhOdBkQSsM2c1DZb2Hh/0ksD3cQa2nMN7og0RZVI7/
 nNdq5oiLZNRMkLar8VPpZJfeKnTmjWBR7cOmObJlrqUKkBJnLWspbypK444em7EaZ4uafaWK
 6xIm+wmVRCCH4GU/f+raGj2iq9MFmAYQ==
X-Talos-CUID: =?us-ascii?q?9a23=3Ae8kg2mmxMziwJ9sF1YbXrsYNHkjXOUeHwWaOL16?=
 =?us-ascii?q?bNUk3UuCqbg+MpbpAjfM7zg=3D=3D?=
X-Talos-MUID: 9a23:tCdIxAtpTvLsTx4S6c2nom54LspkpK2XMW8VvLAog8u+NzB6NGLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.17,306,1747692000"; 
   d="scan'208";a="35797768"
Received: from exo-hybrid-bi.ads.fraunhofer.de (HELO smtp.exch.fraunhofer.de) ([153.97.179.127])
  by mail-mtaMUC110.fraunhofer.de with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2025 15:48:54 +0100
Received: from XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Thu, 4 Dec 2025 15:48:54 +0100
Received: from BEUP281CU002.outbound.protection.outlook.com (40.93.77.1) by
 XCH-HYBRID-04.ads.fraunhofer.de (10.225.9.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Thu, 4 Dec 2025 15:48:54 +0100
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gKSRFKwoE9t4KrStB2qoaiWu3oFbJmfZ2m6R5JwH8fARGKXoL+rYj2LF24mEMxpw3Ph8fHzQCOeqjN94xzL4OqgGqGKRmdAL4sOFKH2ugez8lQpUbmMgj6PtmTpdyMQf2waNS2x3OmYUPgR1vqsM3SlqLZSrehp4p2MFvzhgTc/jTW2Q9dPubJcABLxqZW3kHu0HawsK+gunsOVkr4IWUQ0p8RV0L9hijzyS8TVC58lZR8sRe7JdG0oauUBiI1C5y+0gzoPuxk7YvpWXdUw13iZ05ybpExUbYO6M5CV6G72qcPXSJAy9/JkMGmIOokmR9dlZofnvSyPnlutWhQBRNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RLMriuCadsnJtGQYE3HzU9vrXSvvNC0CshUqifJncdw=;
 b=oLZoV3K+AVXHwbGAnaldKGA0LbJWZ1IDIZkUaXd0lKF/RxnSJVCubVv3LmanTWqfIqOwmuMhHm58ZqAdMfrFPzmnT/ny1VwwYigHexYrpd0rg1+71evqY8g1awrN5KBUK32xhRAisoYFuaN8Rtmkkf47bPgnQ667Zlc9jJqLaI5QmStUzx3U0zNfziaQcuaRO3xywX/yZwkDAyuzQ1Jv4RBcBsp/16/1MUNI8rFn2fm7Pb+TS+bTK7Ihgacg+Y3k0m8dhKe7ErmCD0DPnIIKOHz0G56JofwbJ3DOthgNVi0yeQQ549qb+l3iG1TN4ZH033UatLFe65UG/epy2jjefQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aisec.fraunhofer.de; dmarc=pass action=none
 header.from=aisec.fraunhofer.de; dkim=pass header.d=aisec.fraunhofer.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fraunhofer.onmicrosoft.com; s=selector2-fraunhofer-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RLMriuCadsnJtGQYE3HzU9vrXSvvNC0CshUqifJncdw=;
 b=hB1dSTFObpG5gcV5fG8bIxonYOSsVBTwRTlh2ZMHWzD7gKbL/lh94THmFmP5HuykAGHU+TLHqPTZDT5B/v/3DHdIfWPP+zGEdqjsu6cA7U6jNbS7NmiihrAIqW1ZYO0/2I7zRtYbSYkVAYyK1KcK0AgmzeUId6Q8Rnge001KHCI=
Received: from BE1P281MB2435.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:43::5) by
 FR2P281MB0026.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9388.11; Thu, 4 Dec 2025 14:48:53 +0000
Received: from BE1P281MB2435.DEUP281.PROD.OUTLOOK.COM
 ([fe80::ae34:1ec2:9d34:a9fb]) by BE1P281MB2435.DEUP281.PROD.OUTLOOK.COM
 ([fe80::ae34:1ec2:9d34:a9fb%5]) with mapi id 15.20.9388.009; Thu, 4 Dec 2025
 14:48:53 +0000
From: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
To: <devnull+debug.rivosinc.com@kernel.org>
CC: <Liam.Howlett@oracle.com>, <a.hindborg@kernel.org>,
	<akpm@linux-foundation.org>, <alex.gaynor@gmail.com>,
	<alexghiti@rivosinc.com>, <aliceryhl@google.com>, <alistair.francis@wdc.com>,
	<andybnac@gmail.com>, <aou@eecs.berkeley.edu>, <arnd@arndb.de>,
	<atishp@rivosinc.com>, <bjorn3_gh@protonmail.com>, <boqun.feng@gmail.com>,
	<bp@alien8.de>, <brauner@kernel.org>, <broonie@kernel.org>,
	<charlie@rivosinc.com>, <cleger@rivosinc.com>, <conor+dt@kernel.org>,
	<conor@kernel.org>, <corbet@lwn.net>, <dave.hansen@linux.intel.com>,
	<debug@rivosinc.com>, <devicetree@vger.kernel.org>, <ebiederm@xmission.com>,
	<evan@rivosinc.com>, <gary@garyguo.net>, <hpa@zytor.com>, <jannh@google.com>,
	<jim.shu@sifive.com>, <kees@kernel.org>, <kito.cheng@sifive.com>,
	<krzk+dt@kernel.org>, <linux-arch@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-riscv@lists.infradead.org>,
	<lorenzo.stoakes@oracle.com>, <lossin@kernel.org>, <mingo@redhat.com>,
	<ojeda@kernel.org>, <oleg@redhat.com>, <palmer@dabbelt.com>,
	<paul.walmsley@sifive.com>, <peterz@infradead.org>,
	<richard.henderson@linaro.org>, <rick.p.edgecombe@intel.com>,
	<robh@kernel.org>, <rust-for-linux@vger.kernel.org>,
	<samitolvanen@google.com>, <shuah@kernel.org>, <tglx@linutronix.de>,
	<tmgross@umich.edu>, <vbabka@suse.cz>, <x86@kernel.org>,
	<zong.li@sifive.com>, Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Subject: Re: [PATCH v23 14/28] riscv: Implements arch agnostic indirect branch tracking prctls
Date: Thu,  4 Dec 2025 15:48:45 +0100
Message-ID: <20251204144845.11873-1-andreas.korb@aisec.fraunhofer.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251112-v5_user_cfi_series-v23-14-b55691eacf4f@rivosinc.com>
References: <20251112-v5_user_cfi_series-v23-14-b55691eacf4f@rivosinc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR4P281CA0188.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ca::13) To BE1P281MB2435.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:43::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BE1P281MB2435:EE_|FR2P281MB0026:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d5e79e3-dd44-4b3d-d303-08de33443e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?RAGfmZ84w7S4dImqEA+xQEqYkjteOGmWqWH+OdpAKCEnJUBz+fEivQTHqPRB?=
 =?us-ascii?Q?c1qF1JLzn8zkWF4eMHksh1gPgk/pz4NFRQ60/CaR2lFnGA3jPlHpKklVVfqY?=
 =?us-ascii?Q?9yUKQlGsjVZ4Nr70t3dQcTwU6CFuAoXnmyvMdw2rrmjnuPi6mq8l6u5fcpTj?=
 =?us-ascii?Q?eUp8AiH3i0nSVq6CcBMPX/IQOsASZ6klt93D6sALl3EaGU/hyv62UCkzueBg?=
 =?us-ascii?Q?YaE9jyawQ17VZdtDIMdniAFLkOlt4o345sgPCJrtcs0jA+pGjFRUTEPYTCoC?=
 =?us-ascii?Q?4VMCIU94leWlqzYaYFamYF6wNfDOOXJmsnpiFTM1z/UAH/oKmSae8SoNus+D?=
 =?us-ascii?Q?nZU7OQcgesjjZmIWG3D5T/Ek+3HjtVrGwoT5ar/CnIQ/nwiiIBGpG153yVZl?=
 =?us-ascii?Q?hwSB3ms000k61trLfh9/he9uEnGZBQkAQe0OZpk3fe6CkEMbURK7DotILvh3?=
 =?us-ascii?Q?RyY7aqTge3ZSk1Dnn1FA8WydZ2alyAiRXXpUyw+5OzZWHqPiwDVeYqD0ko5d?=
 =?us-ascii?Q?Yvv7E4tjKWaj6rO9s4yW63/m/lXmTgRDpHhbpfytb4BUgSf8d8lDOoYBNgxj?=
 =?us-ascii?Q?+NccjAWADr/tBD3IGbcjatkkpoCDAu4zrs9X0qbiG98JS2zpbQfrSTz4PfyT?=
 =?us-ascii?Q?Aytc+BVnqxIP0AYHi94s5GW2Y67OEG+2OQuLHwAx2qJYH8L/+A84dm7IPope?=
 =?us-ascii?Q?gVpUiAdZNnkjQu7eBEVjYqdXHu0Mu7cns47nWq13D+Snvr5BZpewCmB2QZfR?=
 =?us-ascii?Q?EigofS3n6y+b35Zp2pF68/CSShPHgJbnebWVqWLuHBiKjRsJyxKrDM5308en?=
 =?us-ascii?Q?0lg/d7E0ju/t2fLryWCTl/t76a8wVAryoKbqEjldATtI9enxAM5l/gIZ5FqM?=
 =?us-ascii?Q?CvkSV67yB9AiCyvCuoBm2rZVw3a99V4fc4D0M4jH18W5K8iJevJF1wb0bYZP?=
 =?us-ascii?Q?rPQaOdtrqnKaLpj8rw1SD8DsXsTOY2EktP2fdiF/xLGCZOgSwbKm9azGf/Cz?=
 =?us-ascii?Q?r7gahCbaXyRi3CupTlw6s6bUgZloeNMswhFejMAz+GXZ6gsTGxnFqqDvxWnu?=
 =?us-ascii?Q?/f3rfCrlmGXTL2Slf4ujWIk/V3VZgjGS586xSx7tV0u5SgJroX9upS5kCK+s?=
 =?us-ascii?Q?DQO/V7ZmZvgESrQUpTk8ZUw2hIewoc0FgapEGhpAo+Z+sZmGyfozAVVJoecy?=
 =?us-ascii?Q?0rKHGmxThaBZL2lqG5eLbI3hnCnONtPg+qUIU0Dunw7MpvJxsO13oqtXH8+y?=
 =?us-ascii?Q?CdsY6cy1OqyYZxhFaYdMO+c+8BJnyhBS2Vv8JfR7Z/XvUyPqzigZh8CQQGEB?=
 =?us-ascii?Q?SWp6Qr0CNK0mMvC20iE1ys2wXOf13Z7fDE5LBa+w41z/tVBnTF4uvkSNKDep?=
 =?us-ascii?Q?a4HNXswhzkBxmgAxUfPJuAryVivCUdMSOQzF3WTFFl/IVpZZAtF5Ef1zwKvC?=
 =?us-ascii?Q?PtQ3RmI58kKkFFGuKaM55xYXp39WXgON?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BE1P281MB2435.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DvGbRR5wwrG/SNsuJAZJEQuzPDB0SEeKaoPZ3iycNuOe3Z740O7bqyx2CWbO?=
 =?us-ascii?Q?t8rf9hE8k6PPq6jX/myFgyXghyeJ+Q7kmz91nNBqQzE+zICGSD4ZzL5oJRay?=
 =?us-ascii?Q?yt5juAVwTGXDgCvg4LQN3KuEyIRT9tuozl1ve1Rjs/6gXr1T1DxGNk4+gQQG?=
 =?us-ascii?Q?1eCSPEZz9USc3WCBXFBrc1wQWHs4gEUeCn8sZYMwcg5pyk5K/IFTdnpf+xGQ?=
 =?us-ascii?Q?gdTmTpu8gWML4+bJ67eNWqnJ78tOoX7+1hWnlvdb3aGMC2L1BkadmPb++/HN?=
 =?us-ascii?Q?0YXYV+JmopyaZMnKaYs8X+b7eZ21ILrggaCS3TfRY4ws2GOlo+CckFTa/WbC?=
 =?us-ascii?Q?psdBbSAYsvtoiKS8FOnDasNGna2AmODgvpSDISshtM5soLYd94cpjC1LbHR6?=
 =?us-ascii?Q?6Aq4V5qukncJfx9FHeYzs5Qo6zjDAvBJPZA6+6Z2AqMJfSc7NVhmHmb/y7Rd?=
 =?us-ascii?Q?Vr7PyTkWWlZyBGvfP7eTsp0sk05uAscABHCBkk5hJ1kriZZUlu5N1+oQpYho?=
 =?us-ascii?Q?HJ87iuiuRi45bfngPCxACG6n253qNvRABEHNV7muaMYAYoWs6Ms/P40clMnu?=
 =?us-ascii?Q?X6LC19DeXdLiRayPQPrKGAmjDx+t2j925+NqO95q8+56/owHOzQlVOX/8hKU?=
 =?us-ascii?Q?AbMmKoL2HcV5tcyQf7kr5QhunlxEqUESowWNQAhXbFgrAJssyUk5LN9FU22Q?=
 =?us-ascii?Q?wpfHbvh6djTzHWpA15lUCrEu6Js1aOWPmHmXvx0qDyVN2KD0+MHBfmLeyF3t?=
 =?us-ascii?Q?Xl5bVP8ux5RyQipAk+BIvWu8GSuOPIELAyUW13UOOU8mv0nxBFotihJf8WGl?=
 =?us-ascii?Q?Pawsg2wDiIWcj9fT23UJj8nOu8at156jgkqquxGoTNn8nu4rqdV6/6mCkBPU?=
 =?us-ascii?Q?37pqIVMHXFcL2XZd4yPiaBBQ39VilCIvW/686Q6Bpz0PT10xsxxUf/ew4pX2?=
 =?us-ascii?Q?3s72k1L8o05WG3kZ1iFA5hK22twn3t+/yDZqP3Bh5KAKu/WJwNuod5ctUyLy?=
 =?us-ascii?Q?+poJv3cXbnCBnj8KxysR3kcs9YaJg1iIJueFsbKo4SoRjTms5zb+rd6Iv8RZ?=
 =?us-ascii?Q?RCgjKmpYI8NWNCtkUeJi6xhh0WMi2UVxJSxUPkBBaSv9Cd6AxIF8ZbqxZ1X9?=
 =?us-ascii?Q?WTxfKIg5q0sA+KPSyzlCJj16MXN3RwTImAde1bjrpNE+6dNvpm7I/LeiZJJy?=
 =?us-ascii?Q?69drso/tYy5THiulTdUbhfgQSHkLgY31BWJBas7d7stcSlpw8mOSapQviilz?=
 =?us-ascii?Q?i0a7HIZElKvirYzTneAM5FcwVjh6ZvzdMTnVpA88ktSwKup3QlVoe/Xsd3Wl?=
 =?us-ascii?Q?x9Fhn9QgXdI2i1mwrhLqUAGNyz8CCQ2FWWD0UuZ912cR9rbc7Er74oV/uPEX?=
 =?us-ascii?Q?+JIrczc4qb/nLDotAVK0eh2B5MmP1soz7MIpIYxV7boyuwtLUXJzmC4cILBG?=
 =?us-ascii?Q?cWGhTDhl/kMaH/CQBxU26XXno0dabnelyPFgW5bpYtOyrgJ56XINe0OVCyYN?=
 =?us-ascii?Q?Wic4z1x9fGo6ujtaAp0I1nHIVZbVkT8tCv1nJrfdpjstLO031FyDc43tC09K?=
 =?us-ascii?Q?1mYPD1O7dtfWp5L04tn6VOfL+zlpPe0aP/UIZf4AjsoDw3VJkAUIs6ZLd4cl?=
 =?us-ascii?Q?AYnSCZQMb+0+Poh2+uqlJQs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d5e79e3-dd44-4b3d-d303-08de33443e42
X-MS-Exchange-CrossTenant-AuthSource: BE1P281MB2435.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2025 14:48:52.9857
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f930300c-c97d-4019-be03-add650a171c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zNBQUOmNyryDAJYAhU7xIoupGti77M9bBUXtHoBO8x5v0j83hOQ4WZDwyzoh/S8VoSvGcEqIr6C6Xv5b9DhENZB+Buzmy3q+dSO/4gT4jjNh705wgvKEWucBkcE4Ehzv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB0026
X-OriginatorOrg: aisec.fraunhofer.de
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 408A940004
X-Stat-Signature: ptthupmz1u8oeijr4um5g4j3i9a66su4
X-Rspam-User: 
X-HE-Tag: 1764859740-268398
X-HE-Meta: U2FsdGVkX1+DGBsXBabS4fNCn/yd93l4sgTjjPDgojawX9VTEFlH6Y3M5bspEs0sADNnBsd92eGe/AHIieJfOmp/PnGElJcysAiTmFExAUy06PzPXaRlDY/fZ8bpjeM/FwOZva32mKmXnFYFJ4HBz30KSJ4HIOqPfhEA2RAMHWCAr1glrE8e0TUatpUda9ExpLEXjmEu4fyHErEPreoxvmlbLr9PW+7y1cWt4+vo5pMk7hQ79Mi7v4MHT+9+8ZXHCAqMkPE75mAAQyPMEraia4Ue8d7qEln8LTWH6KlqoAFkhUMWSH+/jPMI+SRRE+VhF45dsGtIocsY3PCZEMBsmL07s43l6IuChqIttpcWibq2LEkkv9D2NztIrozo8QVi4XAAKuzqjp1B0479w3A7FsbfwW1wSkMd9C0AaGAd5rWkGdx/3yBpZ7fgeIdZi3tC2rrkwln66DWdD2Qn7jj2tJROnG+fLsBG1T9U7HGcuaCf5JaFhjlt9fXhzH2nEAgniYcFs/Hfd3arcxb6RYt3dl30dGhDifmY63Tv6uobGlr5RFRWxLM32RwRiKx0F/1c14b21E6STFxPzBpDaEwHrKS+facVrl3fh/zd+uEm3Q2YkMVmnXsPLOL1raOqpxreiHcqVeOXLqFYQw6D2UpYZHWFe41ySFk4Y8/g6tFaLbleAyZUEwkVsmkurTosjaCxU9XDvo6PCHm7xfOQeYk4oy7F0JQOsnRYaXxpoLNGlD5X19QeokeQLXpFqD+euVXJ7Q//SELj07ypP1xEndZmGIfxU/4qRBJUOZnYBy+TE0yVEmeCgohiWPg73dn3mYYcFVN38Wa+l79TH9B1KViMFGMTKsrGNlPgJXzdQKzbg3GcNPbUQv7VeALz1NSYmKyK6SqQ1Hkr7XNvsEhBKnsreKFJPtPT0kqpD2qVA/bqY08v4M44Z46Sl6cG3YeU8TPxYVttl6HjOKc7zek0hSK
 u0Lx572x
 EZCa3qMhh7L9PplZl+bBaMnvg9T0qEVVRIwemxDGzlW2zlERw8Qm5msgS/xp0VLobPQp0DP+1E2FzBR8No9MR7fj0hlpVyGs1ySlrw9RZ6nIXKrHHkWJL9elVxpMLAvvMtt6eWDPDuGSmfPxgOjkBF18jJMd+GvH0KVliRCwTYrwfrH5LMQgUj7h/bnuh3fOHQsoGtNgImqLa9JDc4SYngZ1JpMYdB+rwB3T8jglcuwhEVL1u/adb/hrM7G2V0kgkjqCKvO/7/26KOzuclgF+ddgidM5RST/B3BoB8KJoPx/d4B4zRLCfNnACzg6v0uRKqRfT0QIAv1qtsJiHXfFIVhjxtxhWlhlrp/Gt8ViYY5g3U8cwC6HMkUxdshu/ozM4wDL+gg0/Ebqgryjt2xy80nhH/jPJuzINiX2WyxHD8Cja/QSWVCDBRHFa7/TT3TR3dj1xp52FoWRbNVnDq/KzyBfnOd1IZYuBmv6mtzQ70chcwvWwvLziLbptFJ8Nz43Pe2pM8cxS/TqmWQHSNvHfAq1MnJPWrN6e7oFmXaRur/LQJXv2ZThXwFwXEiZK0790/L4YBeA1EwuQjtX7SYDLsHwH5yuowuvz91zo/alcVY14QeFJjzD8EdAdqWGZy7mCluzMW3Y4qdEdiyrCu/7mFlMgsoj8kvn6bWcUu3CLY76vVrV8rJOHhNa4NGamnJ702DII+0PKu1w1+GlN01ILhYFWXIVHbowPXAAHmc6JNM81UQW3R0T5B9j42KS3dZ4qoMpK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.060070, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tested on qemu and on a custom hardware implementation of zicfiss and zicfilp in the CVA6 core

Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>

