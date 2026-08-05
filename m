Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57259C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 19:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B4FB6B0095; Wed,  5 Aug 2026 15:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C026B0096; Wed,  5 Aug 2026 15:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1064C6B0098; Wed,  5 Aug 2026 15:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B93FD6B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 15:56:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 159C1A060E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:56:04 +0000 (UTC)
X-FDA: 85068271848.28.041C261
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf30.hostedemail.com (Postfix) with ESMTP id 237D48000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 19:55:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=aSglA1cl;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf30.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785959760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=A6YRrOHe0n07eDhyujNLz0NzuZtgx5NtiK+tf0cV4ZA=;
	b=1pqinkdvXjhQPxxrVsYKoViRkuoGYYzqh7yK9vu40TCwgAKwRpU1f06bwrQ3QwrZzgvEEa
	to19wGbwbcyCCCBenCPj5TPYgu1fu6Fy8i+ZxIHq04ZEtKKNRvkkcfeD7DMqSLhsCqwC9m
	inGIjcRk9QYL8xQJQiwtN6Jb15xv4qI=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=aSglA1cl;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf30.hostedemail.com: domain of "prvs=670a93ad5=dwmw@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=670a93ad5=dwmw@amazon.co.uk";
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1785959760;
	b=OkkIwk2oWwJxWFFkesnBa/gMJfYyC8rnugURsUDgcYlSkSqkAkvfs+dfBjPQG39ou5Hrxl
	xqFAJHzvGGHv3fHCnnfPIk/akJlVJX/UkStqXtVnaDbqErL3t0rbk3AFk/OvEKGKtNJZqU
	0HirFn+4q+KVeEwxrqavE1DWa/FxFFM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1785959760; x=1817495760;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to;
  bh=A6YRrOHe0n07eDhyujNLz0NzuZtgx5NtiK+tf0cV4ZA=;
  b=aSglA1clCYPZ4mNMsqq2KZ6mMLHUVFAgRd02qeisyNxFZHQocbM7gWPT
   Drz+NWaCzKWtDCLyWvrEo64VapwG21uzTCEaKlqqRgAkzSTt455B0DHv7
   jCCn+IKGcjFyVj0k4nKRUqW2nev1AcGoDS02o1Qp92+9C8vXfVbl7yFKv
   IlMkB54esCzqXCWmK1PQF4aFOaqvwkvLAB8Q57DTNDqu67lDiiEM+QdUI
   DTkvrefLFsjr9PK/Ynl2583y19eN/g1NoMnCO5lOF3YBKPw7cPHTPNGT0
   dKEydb3H1Pr3+eZRgxNFKCF003cKg/3I5QYnsqLZ7XPI8g1JdSb/lMYrx
   g==;
X-CSE-ConnectionGUID: Aw0cB8VaQKOBCPwmI26GuA==
X-CSE-MsgGUID: WTJxQZOBRbWeVNNBIKZKJw==
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.25,207,1779148800"; 
   d="p7s'346?scan'346,208,346";a="17446053"
Content-Type: multipart/mixed; boundary="===============0447233886121387104=="
MIME-Version: 1.0
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Aug 2026 19:55:56 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:29451]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.0:2525] with esmtp (Farcaster)
 id 85377bc1-e35f-4d8b-87d0-c3c4a5bc5575; Wed, 5 Aug 2026 19:55:55 +0000 (UTC)
X-Farcaster-Flow-ID: 85377bc1-e35f-4d8b-87d0-c3c4a5bc5575
Received: from EX19EXOEUA002.ant.amazon.com (10.252.50.139) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:55:55 +0000
Received: from EX19EXOEUB001.ant.amazon.com (10.252.51.80) by
 EX19EXOEUA002.ant.amazon.com (10.252.50.139) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 5 Aug 2026 19:55:55 +0000
Received: from LO2P265CU024.outbound.protection.outlook.com (10.252.51.199) by
 EX19EXOEUB001.ant.amazon.com (10.252.51.80) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45
 via Frontend Transport; Wed, 5 Aug 2026 19:55:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X+mhMP09kOgSKKQOMgxDniqlWFqWigbhSfgaHjfRPxxbwFWmcy0MCk9J3fBWEvVHcZA3/yiNDurL9EWIajUEYSgU/2YgHdjDh9yyec64bDm2jDlcsvCBvFvwtf9yehuJBNVV7BRfl6XnKWW+tWwd+yBJYW03DyW4ZcVXTYik10HhRxbDqgqmwJvqbgNUQZ9GVGILBk/03QfTVs7aZ3jcg58ViqifY+5enzZlQVPGZpmDlYsQgrDng5nFNp+5mfF+sPviBvB2eIaU+ZxvhYEvCNhCBvkxVc/GR8+5XFN59YhMtH2rrP3VfIFD9iXivCvWeyzkrD78yQC//42n6bZ0TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001; h=From:Date:Subject:Message-ID:MIME-Version;
 bh=u5dLiskRACBoTNi8Nai0ORlxzMpznAZ/JGXzS/6pEIU=;
 b=EdtiYR8eKRQy182CwoYDMqfU4mVS4qGG5/Gka0+PwKfODLZ+Mkg2shVqOQKKnfS2cArU5Xa15zkYacgsfDgpMCZ7vCXDDur5l2sKuzEXyvFmLcjd2Rnpp9nffxKMrgB84tDfLjZmSmWhLXs5Rb77rxmGGojdcehs7C/79MtqXUvJTkHN08R7XCzY5ivKaDIzAEWKJk4mvgxGuF48PWrwNnkbmvNWDBHbHXLYmipgU92DY0BXdQTTpBYWWNlpcAZ55gcZBy25ZMu4JhVJ8r+Cq+VSxgvz5r8+HLUYxocITOSt4laa1Lh4v1qG7D532F+6cFNrxFL1BhDhROtvZxFzjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amazon.co.uk; dmarc=pass action=none header.from=amazon.co.uk;
 dkim=pass header.d=amazon.co.uk; arc=none
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:4b4::12)
 by LO0P123MB7404.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:334::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.19; Wed, 5 Aug
 2026 19:55:49 +0000
Received: from LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6]) by LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
 ([fe80::c7e3:476c:6170:8f6%6]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 19:55:49 +0000
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
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"syzbot+208f7f3e5f59c11aeb90@syzkaller.appspotmail.com"
	<syzbot+208f7f3e5f59c11aeb90@syzkaller.appspotmail.com>
Subject: [PATCH v3 3/7] KVM: pfncache: Use RCU for readers instead of a rwlock
Thread-Topic: [PATCH v3 3/7] KVM: pfncache: Use RCU for readers instead of a
 rwlock
Thread-Index: AQHdJRRpFlpkWk3u/UiNo2AE00Ua3A==
Date: Wed, 5 Aug 2026 19:55:49 +0000
Message-ID: <20260805195528.3853473-4-dwmw@amazon.co.uk>
References: <20260805195528.3853473-1-dwmw@amazon.co.uk>
In-Reply-To: <20260805195528.3853473-1-dwmw@amazon.co.uk>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LOZP123MB8516:EE_|LO0P123MB7404:EE_
x-ms-office365-filtering-correlation-id: e8b6d328-80f9-40f9-b264-08def32b8c22
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|6049299003|1800799024|376014|7416014|23010399003|22082099003|18002099003|11063799006|5023799004|56012099006|3023799007|4053099003|38070700021|6133799003|10067099003;
x-microsoft-antispam-message-info: T+J9MdTO9lY0V6ZeylXVr39zQ/K6ddnpWPQJ8DlKa/OA/ubWSBCiRmbGLMD/06H5asq+rWtQ2TUYZEGT+KEjBSWyBmegqZmJotbIiwuJS8S003GgB49L42Ow0O123gSLoQ6SijKXgmX9PZGMsUJHbhAJOXfmRnmJcIQvC1MU0iRVlIatcW4E9y1KtARzVxki4tvH7assekOEH+X8r6TmUvfzbg/C9Zd+Tva8qHBEHcUU7kAaS91Aa7Pg5jMW8faW7+Je8W/lYkC9fNQgkY5cfZDhuWHGF+b2K6FF8sE1qMYzr9Wi3RmtGNzdTfSgvQGDEXAnf2yvnnbGxeDpgwgLW/rR3MGdgcx0TdhJd9BF2pDTjP/s4/eI0RHqgN/ZFJFs/IhFjph5g1AhcxuevyvGw2khvAdsQuzBUKnhfiK3iuCutTTgXKSSF5KWUIlULjkbBBqqeK6vQip1Nq0I8sKv9lcVIihl1FgUwP5XS0MgRZWT7R4EwWxG0DbHuCm9Xe3MC1Hwp9KhXpBrJgLLVMgB/q4GRwHiQPloX2yOV+RiB+5lNFozwM7xoUQhMLtkdTjD1jWIhfqTE2HmuYTI14ols0XSgn5GOnExEg8h5v5iDGhoMo1s17HzSvOG9Oui6D6ddb/gaPussYLD6QYV9BAtulIS7VGULCjTcSzyIfld/PEMRDWOriQ4nOxNQqw1zPah0whlzjNfA9IXBd8Ma/6nAz/P7Qx18NXdwfyKUYp24C4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(366016)(6049299003)(1800799024)(376014)(7416014)(23010399003)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(3023799007)(4053099003)(38070700021)(6133799003)(10067099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEplcHgwbllQVmdJc2tIa3BWUHBWM3pMTUFKa2ZRdTVtbVh5Nm5ENC9tVXY1?=
 =?utf-8?B?NjhwdTBROFgxck9rZG1sS3dEVXVQMFRVM2g1YStqaWtVR3JJc2FiM2ZQcHNI?=
 =?utf-8?B?M1pHcTNwWHluUFV2b0NlOHlMVkFkcmRzKzVURlNsajF0cUdRM3Fpc1RXZm5U?=
 =?utf-8?B?bzgrMVdVL3d5bHFpTjhrbkFZa2kraE85ZWRZUURoNGRrQUl1RGc5VGMrRTQw?=
 =?utf-8?B?S0dQcnBoRnZtaGxjUmM3dTc2QXBlc1MzYnBMNjNNamx5SC9zeVF5TDFYQkJL?=
 =?utf-8?B?aVpaNFBPUUdlemtoaGxnRVdIK0dRK0x6dXRxNktSZUZIb2VxK01IUlpITlN3?=
 =?utf-8?B?WjJzWDZ5aXcrV0lkZnJqb3ZSc21ObHFhdW9BSHZNZ1JJWWxxbDhVbWZxV3lP?=
 =?utf-8?B?aHlyODE1Ykg5NkptcTd6cDlJdEpzWmdvYzFya3kwYUNqYnpJYk1BbUZyN2pW?=
 =?utf-8?B?RmtlencrQm1aSFlrbVd5R2V6ZXRidGN5QmI5aHdveHRTd04wSzRsWm8yWUJl?=
 =?utf-8?B?eEFZaWdkZnc1ZG9makl0VmJ3WjBFRGtCRFNpc0VIOWJhMldiYUcxbVo2bTNN?=
 =?utf-8?B?QkxWSngxSkpVNklYWE9FZTYxRDEvK2FxaWJ0Y0tzRERNYTF1VVd5Ri9CMkc5?=
 =?utf-8?B?Q011bDJzY1YwVStwKzFBcnMxMDcwVkduTWphSlpIZko4MWJUL0JnamVnL0h0?=
 =?utf-8?B?d2dzdlhxbGhvSDUxeDNVc0w1UjlDOWNXQVZBdzVrQnQ0aDdQYUtCeXA4SXBq?=
 =?utf-8?B?VElZUVZWR0ZTNDg4N2JkK1dsRVBLazZucmRsNTZYc21leDZKQllnVEFxaStL?=
 =?utf-8?B?a2ZPK2pOUVVvT05ZMC9YR0pZT3VXT1pPcGdreEcwN1NaaENOMG9CK2JCS0pj?=
 =?utf-8?B?RDdOUkZTS2VvbzNva0hnWkFzSG9EUW9zUjljTU1BczRqZWZjdTkrY3M0TEkz?=
 =?utf-8?B?aXIzbWkxbEMwUWRKeXlFc2NqQy9pMGI3NU8xa2hJVjNJU3BaS2g0VVFVcGlC?=
 =?utf-8?B?SUxvcmJjOWpmV243by93Rm9zTUw2c1plemVPaVFaRGVFZVBiNFNIYWtSM3Jj?=
 =?utf-8?B?Rk1GT1BIQ1NiakZnTjl1NFFweVEvRnZIT1NKRDlYZXQ1WERFZ0l2anl3MHY3?=
 =?utf-8?B?ODFaVTNTL1JsZTVldzBCZ3VBNmtaOXd6Z1M4VEdvK3FFQStQeEQwVWhJMUZ1?=
 =?utf-8?B?SGlzTlFkbmNwTU1Ec2pFYzJuT21yYjFMMHNsVEt5YWIxb08yTTlWc3pVSE94?=
 =?utf-8?B?RmRwRk9KL20rK1FzbXNtTmg3eW9KN1UvQStlYnU0ckZSNTlzaGJEWDFUWGto?=
 =?utf-8?B?cnNPYmc2NSsxZm5jdFZ4R2MvNmkwb2huWmNoOUF4OVYvTm9VUVdpeFc2UUJU?=
 =?utf-8?B?YVd2Z05UYjF2R0FOSmE3TVQ3SDN6NGRGeGdpcnErVThuK0l6bnVqc3U4cHVQ?=
 =?utf-8?B?SFlMSUxVa2hDUFV0MVlKRkJyME1EWk9QQlE1c2VzdnU1elJJdXRYOWNUaTBt?=
 =?utf-8?B?ZEcxcldyYUlIT0xiS2QvTmlVM0d3TG52RThkTVlxYkNjOE1zQ3hPUHZ4ZG5J?=
 =?utf-8?B?SHVIS216Qm5ibFdXUEJ2QXJhZks3NFFwWnVFUldTY1FwRHMxT21SUzJHMW1y?=
 =?utf-8?B?aDNxOFVVTFhoSXVHVE5PVkM3R2xyRXRNS0hSTEhMSDhEQ3h5RDdsMDRQMmVO?=
 =?utf-8?B?K1Y0TVJiUFpqcVFKVWIzUGd5aU4rOG5qWWdvK2ZQRHc1Z2ZTSWw4ZGFCV1Fz?=
 =?utf-8?B?NVBYeFhGV1poRWIzKzJ1TC9lMjh4STlxUUJXeDh5U296aW1CQ04wbUdNQVZU?=
 =?utf-8?B?LzNRbkJveEVENUxwR0R6M1hlTkpVSHhSUkFZbE95M0d0K1BaajJJR2xuR0p6?=
 =?utf-8?B?L3o0SEZQTC9Cbm1kS0lJYlE4OTlIWXJETWYxN0NTU0Zzak9BZmVIMG1ibnF6?=
 =?utf-8?B?ZThERFdPaFFlUkMraFd3K0VndEU3YWhobkJtN3NFUGVPRVRNcS9yaWNtcnc5?=
 =?utf-8?B?am4wV092ZGlESEVvcGg2djhSbExoRFBKVzZubVlKOVdXR1VxWXBPbldWOGJY?=
 =?utf-8?B?WHRmYUpYZ28vY1dJbG5CeHZWVTBwYUV1dngxQm05dllvL0tmVzdZNnFZRVhL?=
 =?utf-8?B?QWhrS0dNZytROEVFbzhLaU1SUFZyTmJJaCtNaGVGU3JoUHBuTVhBTTRmdHlC?=
 =?utf-8?B?UjlKc1dnamZWK1lQaElLWVFRb1NmVFZZVG8rZ3hWS3dYam8zZkxyOHRlQjVy?=
 =?utf-8?B?TG9XbnlNK2lTQXN1ZGNEakFLYU4wK1U3V0FLZ1htUjV3dzRybTlVT3ZtSEpR?=
 =?utf-8?Q?Lkg7z5hGeQH44okkUL?=
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: ihu7BnxtnJsOINsVKvAdWwWaBcubwG5IENGuBeFot/MUVEfQMV49Pzs8q1BX0xssmUINSSrSvbGcLZhtya8Kb4fdN8MnJXTjhfFDLIEMArtkVA1+FHslgd1IeTGLedtV84Td/NRX9znz3UsQd2/nqbBmNUetMHeY9mtofk32QCvOA24SMH9njyBGUmA+wcErZxCLITfL7Y/hLLUW78e11SmPBBrNqgJjsb3XlHpcu9kX323FJ5l3pJ1qNVl8QwkZPsysMweWBVKMHdgnPWUx06fk1U4wuLZxy6a33LMXHlTR8LoN94vMVGieFtc4MUfgNsBbKDel8STiTh5q+WNiig==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LOZP123MB8516.GBRP123.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: e8b6d328-80f9-40f9-b264-08def32b8c22
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2026 19:55:49.3212
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5280104a-472d-4538-9ccf-1e1d0efe8b1b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L8/EjAGolOaL26TINbO7t82pWhekNjRUKkGSE8nE267sePqNm61xZXcUu6M2PpOmzrdIAywI87SXXri1RzxIgg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LO0P123MB7404
X-OriginatorOrg: amazon.co.uk
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: orkg5izgj8ursw7kcj6fgt8ejtacj9xx
X-Rspamd-Queue-Id: 237D48000F
X-HE-Tag: 1785959759-485315
X-HE-Meta: U2FsdGVkX1/fNX6Hr7iyvnDXoBjVqvz9FarnDR1j+Fz2rwPjN0ClZFFvpJe5IaBKhSI2C2AFT3Vpzwy6V9GEEiBBFd5tLgWsKlvPhUJAY1jKMdz66KHUb2112VRc7IVTAlq2gcQX0qGa9TCO7d7MGodXUo4ee4RH0orBN8l6OIT7XBRXQj60B+U7BTV6uRG2GtkJcf4ti98gB1TxElKQV5gnwvD6xotfl0a9az1Okh7GOB7zYsHVCT4By4HnOy6aDRUNGsuRln/NLWYQhO0j6tVFUZq8wgcwvW5WuJmS1n86UDEmqndsKtwimwjybvkqORu5ZpwOSdgjDma+10Wu8LJ2K+hFSNeuC/ZsaamnBjW1uABPBA3jUES6KlWlxBJsvcQsWVSxpIbercO/qG3FA/YDWfeTC6VAIDhARs/mtmZrJSrSI6+zC0Y+Lyh/RlUYAEsAfW8fKmzUkKfOjb+xtHdR+HgLdv9YlmRNgKKczy8xx4UPGZiLNv+uxaGU0QBIdjyo3/R/FC2vxztDFvuevjJVj5PHroRgdBXvVoieCBOl8yG86E1gWIV24ZwQgeowbB+khMG6j29DAgz1hCntYlH+QPI32veTiKDnQuEDBxzBeUVHZOp4B7dKPz5i22Hr9IC6J/6QLHY9MbBq35dbjsQH3YZA0gS5jqtQDF6QEvUy5fy+q09rfIkOf5zcZ21qzCFUmenOAtEUNZQCltKTHZ2NjAsgl2qXGsROMoQl5c8mN2Kwpaaf9rbSjCqbWnS2gWrbMCrVXeXxFk6oPjZibeb8z3XxOz9PPTitQjKe9dEcUjc0hUmdh0EhHvRVRrnPQnqoKAGrkhP3+v/64ATMpwCad6KIDiMVvmjRmY2YfVzWcXCI6jMK/TllGNvN8SbMPWHUjP+cs6WKhItaKvkJwxe3pLZDVn5sY99kccw8tOaBzrhsp9x69DoDXD77v9wihHcJ37M2YBtK2XG0fze
 wmGW859g
 b/obUF4KrP6o3w8ZTTFqHlEQBh2v/z3GQCHe7rivRRkA2xQxHxmcbaQkf1f3Dv4fhMeBRv/qdZrFbRsUie8f9ODRcCk6lHwFcEFcipG9GzZGs81Z0C6hJC8TdtupRTs5tTGlYLHX+M7xMeF8gDu2sWqHR2vQN2Fu5Ds86fxm4CO7fznOoIv39JmsX9hTYY8eh9WNFnS5llztNlO++2kmhIhvuoo5HrsXs11ypKLhFh3c99t2kjr2EW1sxpPZilu3C1mvGf80AZi2cwaT5z+t5Od/4Dag8ps6SR9mYNPnOwliJ9S4C5j1ri2zAIBPMM568xMq4+OoJ3TnubiLHJlwS+rpm9l+eMBNk52LqufbjiZdJW86Uosw43Az52dZ81kR/oNI/aNKmYDQZmeYdmI+xjRJ3QdHB6XUc3vTnRs6sk8lTvdjk5WC/B80QiZk8uopf7w+xnbK1YSyaSkq2/K7m95BdWdMFJt8r+e/G2JL75ZKxwenDHfFyNPx9ppezlp5wsU0TID9LpQy7jXSYEBWznj8+KdjxQXke0HDwOOl1MYlL2bk2ZeOahuh3bVZOcTRfolYbzp6JDn3CXq+dQlVp40RYXZQcKx4fXhvmNqKFNCHeb0hNIGAR4PBMxyhjjlmKBUOwwZLJBy8iFXbXQbJNLEIZmnhLu+Njjlcvr3Tt0E3p2tXeUEB3hYeVVoT85D7TUKywSVLpZy4vViLwG9hrn1bYxDlemg4x4Qs6owjCc8/ncT077jlRRJdDC7jRXtLXsnneiIlDBfxoCsYSU+n15lVh+vf9i/gBpIjjp0tSfDRzZP5xSzdnD/No7usgnxEg8iNK2l7ZRPZFew8RwyY+1oIzGJKOhdyX8pjhjL2LUsABAjVZf3Ujq+w9Xh2D8Zmxo1tqfZNJqoqwQIgY9Pe8vu6tPCDXAgHLwtRu54VxAZreJHsMUFurXqilb3IO8dDgSWzVL43REOKYtDv3qZCTXDrCzrvn
 13q77afH
 1Mh6424uDuy1dh0XxfZZyiJxQKDb47HPAbYFwCKIO9mK52HVdIw80mX1vRex3xtIcgGXtKWpm4oA8nYfc1kZgol12AOti6HRDxvEIARaUWQSRyt1kgcVDrHo17duUyNve0JiyL+3EKXeoaLSrBcO1nGdeNwkIVpq9FuO9DbSOF20ZkgU/Tip11u3lsxJlY7bpy0LF4hXbzJ/9sWt+EKfg4P1lPb2je8egtkmhPkdJ+sWtEFwySx8imiVPrO/tdeexwL/KLDR5lfgkJJR5NIYWsw269ZzYeEwCQxrPXZt+iMBAtt4f6coFad9LYYSrIXSGIQcX4nR0U67mpj/jwlz3C8K2kpL77/NDilw4pza7rrwrHELdkWVxHpxWhJMEIFNNsxTRuLn0H35vVTWfJ7vww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============0447233886121387104==
Content-Language: en-US
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature";
	micalg=sha-256; boundary="----EF41DE7C369FEE6126A3D401734EB001"

------EF41DE7C369FEE6126A3D401734EB001
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Replace the per-cache rwlock with RCU for the read side. Readers now
run under rcu_read_lock() alone, which works in any context (including
hardirq and sched-out paths) and never fails or spins — eliminating the
read_trylock() contortions in the atomic paths, the double-lock dance
with the lockdep subclass hack in the runstate update, and the
PREEMPT_RT problems inherent to taking an rwlock in those contexts.
In particular, kvm_xen_set_evtchn_fast() is called from hardirq
context (timer callback, kvm_arch_set_irq_inatomic()), where taking
gpc->lock is a sleeping-lock-in-atomic-context bug on PREEMPT_RT.

The invariant is that a cache's fields (pfn, khva, uhva, gpa) are only
ever mutated after clearing gpc->valid and waiting for a full grace
period, so any reader which observed ->valid == true (with an acquire
load, paired with the release store publishing the fields) has stable
values for its entire RCU read-side critical section — including
writes through khva, which are guaranteed to land before the backing
page can be unmapped, exactly as with a TLB shootdown.

The mmu_notifier invalidation path clears ->valid on any overlapping
cache and then does synchronize_rcu() before returning, so the primary
MMU cannot proceed to zap the page tables until all readers of the
stale mapping have drained. This wait happens even on unblockable
(OOM reaper) ranges: the actual constraint on those is not "no
sleeping" but "no blocking on anything which may itself depend on
memory allocation to make progress", and an RCU grace period has no
such dependency — GPC readers never allocate, never take mmap_lock,
and never sleep. The previous patch removed the over-broad
non_block_start() debug annotation which would have splatted on any
voluntary schedule regardless.

As with the rwlock version, a refresh which resolves to the same uHVA,
in the same memslot, for the same gPA does not need to invalidate the
cache at all: the gPA => uHVA translation has not changed, and
gpc->valid already asserts that the uHVA => PFN mapping is good. Such a
refresh updates only the memslot generation and returns, leaving
concurrent readers undisturbed and skipping the grace period entirely.
This matters because the mmu_notifier invalidates caches on any host
memory management activity (page migration, NUMA balancing, KSM), and
the affected pages usually come straight back at the same uHVA; making
each of those cost a full RCU grace period in the reader's refresh path
would add seconds to a guest boot.

Refreshes are serialized by the existing refresh_lock mutex, and the
gpc_invalidate_seq mechanism continues to catch invalidations which
race with the (lockless) HVA->PFN lookup.

Fixes: 14243b387137 ("KVM: x86/xen: Add KVM_IRQ_ROUTING_XEN_EVTCHN and event channel delivery")
Reported-by: syzbot+208f7f3e5f59c11aeb90@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=208f7f3e5f59c11aeb90
Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
Assisted-by: Claude:claude-mythos-5
---
 arch/x86/kvm/x86.c        |   9 +-
 arch/x86/kvm/xen.c        |  91 +++++--------
 include/linux/kvm_host.h  |  16 +--
 include/linux/kvm_types.h |   1 -
 virt/kvm/pfncache.c       | 260 ++++++++++++++++++++++++--------------
 5 files changed, 206 insertions(+), 171 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d94b59140c45..09425f72f4a5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1719,18 +1719,17 @@ static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 {
 	struct pvclock_vcpu_time_info *guest_hv_clock;
 	struct pvclock_vcpu_time_info hv_clock;
-	unsigned long flags;
 
 	memcpy(&hv_clock, ref_hv_clock, sizeof(hv_clock));
 
-	read_lock_irqsave(&gpc->lock, flags);
+	rcu_read_lock();
 	while (!kvm_gpc_check(gpc, offset + sizeof(*guest_hv_clock))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		rcu_read_unlock();
 
 		if (kvm_gpc_refresh(gpc, offset + sizeof(*guest_hv_clock)))
 			return;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		rcu_read_lock();
 	}
 
 	guest_hv_clock = (void *)(gpc->khva + offset);
@@ -1755,7 +1754,7 @@ static void kvm_setup_guest_pvclock(struct pvclock_vcpu_time_info *ref_hv_clock,
 	guest_hv_clock->version = ++hv_clock.version;
 
 	kvm_gpc_mark_dirty_in_slot(gpc);
-	read_unlock_irqrestore(&gpc->lock, flags);
+	rcu_read_unlock();
 
 	trace_kvm_pvclock_update(vcpu->vcpu_id, &hv_clock);
 }
diff --git a/arch/x86/kvm/xen.c b/arch/x86/kvm/xen.c
index f2c6757fc1fa..6bcece2439f5 100644
--- a/arch/x86/kvm/xen.c
+++ b/arch/x86/kvm/xen.c
@@ -46,15 +46,15 @@ static int kvm_xen_shared_info_init(struct kvm *kvm)
 	int ret = 0;
 	int idx = srcu_read_lock(&kvm->srcu);
 
-	read_lock_irq(&gpc->lock);
+	rcu_read_lock();
 	while (!kvm_gpc_check(gpc, PAGE_SIZE)) {
-		read_unlock_irq(&gpc->lock);
+		rcu_read_unlock();
 
 		ret = kvm_gpc_refresh(gpc, PAGE_SIZE);
 		if (ret)
 			goto out;
 
-		read_lock_irq(&gpc->lock);
+		rcu_read_lock();
 	}
 
 	/*
@@ -97,7 +97,7 @@ static int kvm_xen_shared_info_init(struct kvm *kvm)
 	smp_wmb();
 
 	wc->version = wc_version + 1;
-	read_unlock_irq(&gpc->lock);
+	rcu_read_unlock();
 
 out:
 	srcu_read_unlock(&kvm->srcu, idx);
@@ -154,22 +154,21 @@ static int xen_get_guest_pvclock(struct kvm_vcpu *vcpu,
 				 struct gfn_to_pfn_cache *gpc,
 				 unsigned int offset)
 {
-	unsigned long flags;
 	int r;
 
-	read_lock_irqsave(&gpc->lock, flags);
+	rcu_read_lock();
 	while (!kvm_gpc_check(gpc, offset + sizeof(*hv_clock))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		rcu_read_unlock();
 
 		r = kvm_gpc_refresh(gpc, offset + sizeof(*hv_clock));
 		if (r)
 			return r;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		rcu_read_lock();
 	}
 
 	memcpy(hv_clock, gpc->khva + offset, sizeof(*hv_clock));
-	read_unlock_irqrestore(&gpc->lock, flags);
+	rcu_read_unlock();
 
 	/*
 	 * Sanity check TSC shift+multiplier to verify the guest's view of time
@@ -324,7 +323,6 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	struct gfn_to_pfn_cache *gpc2 = &vx->runstate2_cache;
 	size_t user_len, user_len1, user_len2;
 	struct vcpu_runstate_info rs;
-	unsigned long flags;
 	size_t times_ofs;
 	uint8_t *update_bit = NULL;
 	uint64_t entry_time;
@@ -416,20 +414,12 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 
  retry:
 	/*
-	 * Attempt to obtain the GPC lock on *both* (if there are two)
-	 * gfn_to_pfn caches that cover the region.
+	 * Check *both* (if there are two) gfn_to_pfn caches that cover
+	 * the region, under a single RCU read-side critical section.
 	 */
-	if (atomic) {
-		local_irq_save(flags);
-		if (!read_trylock(&gpc1->lock)) {
-			local_irq_restore(flags);
-			return;
-		}
-	} else {
-		read_lock_irqsave(&gpc1->lock, flags);
-	}
+	rcu_read_lock();
 	while (!kvm_gpc_check(gpc1, user_len1)) {
-		read_unlock_irqrestore(&gpc1->lock, flags);
+		rcu_read_unlock();
 
 		/* When invoked from kvm_sched_out() we cannot sleep */
 		if (atomic)
@@ -438,7 +428,7 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		if (kvm_gpc_refresh(gpc1, user_len1))
 			return;
 
-		read_lock_irqsave(&gpc1->lock, flags);
+		rcu_read_lock();
 	}
 
 	if (likely(!user_len2)) {
@@ -458,24 +448,11 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 	} else {
 		/*
 		 * The guest's runstate_info is split across two pages and we
-		 * need to hold and validate both GPCs simultaneously. We can
-		 * declare a lock ordering GPC1 > GPC2 because nothing else
-		 * takes them more than one at a time. Set a subclass on the
-		 * gpc1 lock to make lockdep shut up about it.
+		 * need to validate both GPCs simultaneously. They are both
+		 * covered by the single RCU read-side critical section above.
 		 */
-		lock_set_subclass(&gpc1->lock.dep_map, 1, _THIS_IP_);
-		if (atomic) {
-			if (!read_trylock(&gpc2->lock)) {
-				read_unlock_irqrestore(&gpc1->lock, flags);
-				return;
-			}
-		} else {
-			read_lock(&gpc2->lock);
-		}
-
 		if (!kvm_gpc_check(gpc2, user_len2)) {
-			read_unlock(&gpc2->lock);
-			read_unlock_irqrestore(&gpc1->lock, flags);
+			rcu_read_unlock();
 
 			/* When invoked from kvm_sched_out() we cannot sleep */
 			if (atomic)
@@ -574,13 +551,11 @@ static void kvm_xen_update_runstate_guest(struct kvm_vcpu *v, bool atomic)
 		smp_wmb();
 	}
 
-	if (user_len2) {
+	if (user_len2)
 		kvm_gpc_mark_dirty_in_slot(gpc2);
-		read_unlock(&gpc2->lock);
-	}
 
 	kvm_gpc_mark_dirty_in_slot(gpc1);
-	read_unlock_irqrestore(&gpc1->lock, flags);
+	rcu_read_unlock();
 }
 
 void kvm_xen_update_runstate(struct kvm_vcpu *v, int state)
@@ -639,7 +614,6 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 {
 	unsigned long evtchn_pending_sel = READ_ONCE(v->arch.xen.evtchn_pending_sel);
 	struct gfn_to_pfn_cache *gpc = &v->arch.xen.vcpu_info_cache;
-	unsigned long flags;
 
 	if (!evtchn_pending_sel)
 		return;
@@ -649,14 +623,14 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	 * does anyway. Page it in and retry the instruction. We're just a
 	 * little more honest about it.
 	 */
-	read_lock_irqsave(&gpc->lock, flags);
+	rcu_read_lock();
 	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		rcu_read_unlock();
 
 		if (kvm_gpc_refresh(gpc, sizeof(struct vcpu_info)))
 			return;
 
-		read_lock_irqsave(&gpc->lock, flags);
+		rcu_read_lock();
 	}
 
 	/* Now gpc->khva is a valid kernel address for the vcpu_info */
@@ -686,7 +660,7 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 	}
 
 	kvm_gpc_mark_dirty_in_slot(gpc);
-	read_unlock_irqrestore(&gpc->lock, flags);
+	rcu_read_unlock();
 
 	/* For the per-vCPU lapic vector, deliver it as MSI. */
 	if (v->arch.xen.upcall_vector)
@@ -696,7 +670,6 @@ void kvm_xen_inject_pending_events(struct kvm_vcpu *v)
 int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 {
 	struct gfn_to_pfn_cache *gpc = &v->arch.xen.vcpu_info_cache;
-	unsigned long flags;
 	u8 rc = 0;
 
 	/*
@@ -712,9 +685,9 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 	BUILD_BUG_ON(sizeof(rc) !=
 		     sizeof_field(struct compat_vcpu_info, evtchn_upcall_pending));
 
-	read_lock_irqsave(&gpc->lock, flags);
+	rcu_read_lock();
 	while (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
-		read_unlock_irqrestore(&gpc->lock, flags);
+		rcu_read_unlock();
 
 		/*
 		 * This function gets called from kvm_vcpu_block() after setting the
@@ -734,11 +707,11 @@ int __kvm_xen_has_interrupt(struct kvm_vcpu *v)
 			 */
 			return 0;
 		}
-		read_lock_irqsave(&gpc->lock, flags);
+		rcu_read_lock();
 	}
 
 	rc = ((struct vcpu_info *)gpc->khva)->evtchn_upcall_pending;
-	read_unlock_irqrestore(&gpc->lock, flags);
+	rcu_read_unlock();
 	return rc;
 }
 
@@ -1437,12 +1410,11 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 	struct kvm *kvm = vcpu->kvm;
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	unsigned long *pending_bits;
-	unsigned long flags;
 	bool ret = true;
 	int idx, i;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	read_lock_irqsave(&gpc->lock, flags);
+	rcu_read_lock();
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
 		goto out_rcu;
 
@@ -1463,7 +1435,7 @@ static bool wait_pending_event(struct kvm_vcpu *vcpu, int nr_ports,
 	}
 
  out_rcu:
-	read_unlock_irqrestore(&gpc->lock, flags);
+	rcu_read_unlock();
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	return ret;
@@ -1802,7 +1774,6 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	struct gfn_to_pfn_cache *gpc = &kvm->arch.xen.shinfo_cache;
 	struct kvm_vcpu *vcpu;
 	unsigned long *pending_bits, *mask_bits;
-	unsigned long flags;
 	int port_word_bit;
 	bool kick_vcpu = false;
 	int vcpu_idx, idx, rc;
@@ -1824,7 +1795,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 
 	idx = srcu_read_lock(&kvm->srcu);
 
-	read_lock_irqsave(&gpc->lock, flags);
+	rcu_read_lock();
 	if (!kvm_gpc_check(gpc, PAGE_SIZE))
 		goto out_rcu;
 
@@ -1855,10 +1826,8 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	} else {
 		rc = 1; /* Delivered to the bitmap in shared_info. */
 		/* Now switch to the vCPU's vcpu_info to set the index and pending_sel */
-		read_unlock_irqrestore(&gpc->lock, flags);
 		gpc = &vcpu->arch.xen.vcpu_info_cache;
 
-		read_lock_irqsave(&gpc->lock, flags);
 		if (!kvm_gpc_check(gpc, sizeof(struct vcpu_info))) {
 			/*
 			 * Could not access the vcpu_info. Set the bit in-kernel
@@ -1892,7 +1861,7 @@ int kvm_xen_set_evtchn_fast(struct kvm_xen_evtchn *xe, struct kvm *kvm)
 	}
 
  out_rcu:
-	read_unlock_irqrestore(&gpc->lock, flags);
+	rcu_read_unlock();
 	srcu_read_unlock(&kvm->srcu, idx);
 
 	if (kick_vcpu) {
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 3dd04605f2e5..da0b3669f1a3 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1510,12 +1510,9 @@ int kvm_gpc_activate_hva(struct gfn_to_pfn_cache *gpc, unsigned long hva, unsign
  * @return:	   %true if the cache is still valid and the address matches.
  *		   %false if the cache is not valid.
  *
- * Callers outside IN_GUEST_MODE context should hold a read lock on @gpc->lock
- * while calling this function, and then continue to hold the lock until the
- * access is complete.
- *
- * Callers in IN_GUEST_MODE may do so without locking, although they should
- * still hold a read lock on kvm->scru for the memslot checks.
+ * Callers must hold the RCU read lock across this function and any
+ * subsequent access to the target page, and must hold a read lock on
+ * kvm->srcu for the memslot checks.
  */
 bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len);
 
@@ -1532,8 +1529,8 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len);
  * This will attempt to refresh a gfn_to_pfn_cache. Note that a successful
  * return from this function does not mean the page can be immediately
  * accessed because it may have raced with an invalidation. Callers must
- * still lock and check the cache status, as this function does not return
- * with the lock still held to permit access.
+ * still check the cache status under the RCU read lock, via
+ * kvm_gpc_check(), before accessing the target page.
  */
 int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len);
 
@@ -1974,7 +1971,8 @@ static inline bool kvm_is_gpa_in_memslot(struct kvm *kvm, gpa_t gpa)
 
 static inline void kvm_gpc_mark_dirty_in_slot(struct gfn_to_pfn_cache *gpc)
 {
-	lockdep_assert_held(&gpc->lock);
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "kvm_gpc_mark_dirty_in_slot() without RCU read lock");
 
 	if (!gpc->memslot)
 		return;
diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
index a568d8e6f4e8..fdf7d2273298 100644
--- a/include/linux/kvm_types.h
+++ b/include/linux/kvm_types.h
@@ -88,7 +88,6 @@ struct gfn_to_pfn_cache {
 	struct kvm_memory_slot *memslot;
 	struct kvm *kvm;
 	struct list_head list;
-	rwlock_t lock;
 	struct mutex refresh_lock;
 	void *khva;
 	kvm_pfn_t pfn;
diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index 3659686b97c2..3bae4df49165 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -26,35 +26,49 @@ void gfn_to_pfn_cache_invalidate_start(struct kvm *kvm, unsigned long start,
 				       unsigned long end)
 {
 	struct gfn_to_pfn_cache *gpc;
+	bool cleared = false;
 
 	spin_lock(&kvm->gpc_lock);
 	list_for_each_entry(gpc, &kvm->gpc_list, list) {
-		read_lock_irq(&gpc->lock);
-
-		/* Only a single page so no need to care about length */
-		if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
+		/*
+		 * Only a single page so no need to care about length.
+		 * A cache whose refresh is in flight has valid == false
+		 * and is caught by the gpc_invalidate_seq check in
+		 * hva_to_pfn_retry() instead.
+		 */
+		/*
+		 * The acquire pairs with the release-publish of valid in
+		 * hva_to_pfn_retry(): if valid is seen true, the uhva read
+		 * below is guaranteed to see the value which was stored
+		 * before valid was published, not a stale one. (A stale
+		 * uhva paired with a fresh valid could otherwise cause a
+		 * cache whose new uhva is in the invalidated range to be
+		 * skipped.)
+		 */
+		if (smp_load_acquire(&gpc->valid) &&
 		    gpc->uhva >= start && gpc->uhva < end) {
-			read_unlock_irq(&gpc->lock);
-
-			/*
-			 * There is a small window here where the cache could
-			 * be modified, and invalidation would no longer be
-			 * necessary. Hence check again whether invalidation
-			 * is still necessary once the write lock has been
-			 * acquired.
-			 */
-
-			write_lock_irq(&gpc->lock);
-			if (gpc->valid && !is_error_noslot_pfn(gpc->pfn) &&
-			    gpc->uhva >= start && gpc->uhva < end)
-				gpc->valid = false;
-			write_unlock_irq(&gpc->lock);
-			continue;
+			WRITE_ONCE(gpc->valid, false);
+			cleared = true;
 		}
-
-		read_unlock_irq(&gpc->lock);
 	}
 	spin_unlock(&kvm->gpc_lock);
+
+	/*
+	 * Readers may still be using the old mapping, having sampled
+	 * gpc->valid before it was cleared. Wait for them all to drain
+	 * before the caller proceeds to zap the page tables; like a TLB
+	 * shootdown, this guarantees no access via the stale mapping
+	 * once the invalidation completes.
+	 *
+	 * This wait is safe even on unblockable ranges (the OOM reaper):
+	 * the constraint there is not "no sleeping" but "no blocking on
+	 * anything which may itself depend on memory allocation to make
+	 * progress" (see the reasoning in commit 312364f3534c and its
+	 * discussion). An RCU grace period has no such dependency: GPC
+	 * readers never allocate, never take mmap_lock, and never sleep.
+	 */
+	if (cleared)
+		synchronize_rcu();
 }
 
 static bool kvm_gpc_is_valid_len(gpa_t gpa, unsigned long uhva,
@@ -74,6 +88,22 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 {
 	struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
+	RCU_LOCKDEP_WARN(!rcu_read_lock_held(),
+			 "kvm_gpc_check() without RCU read lock");
+
+	/*
+	 * Check valid *first*. The acquire pairs with the release-publish
+	 * in hva_to_pfn_retry(), so every field read below — and any use
+	 * of gpc->khva by the caller — is guaranteed to be from the
+	 * published generation, not a stale value reordered from before
+	 * the publish. The fields are then stable for the remainder of
+	 * the RCU read-side critical section, because every mutator
+	 * clears valid and waits a full grace period before changing
+	 * anything.
+	 */
+	if (!smp_load_acquire(&gpc->valid))
+		return false;
+
 	if (!gpc->active)
 		return false;
 
@@ -90,9 +120,6 @@ bool kvm_gpc_check(struct gfn_to_pfn_cache *gpc, unsigned long len)
 	if (!kvm_gpc_is_valid_len(gpc->gpa, gpc->uhva, len))
 		return false;
 
-	if (!gpc->valid)
-		return false;
-
 	return true;
 }
 
@@ -134,8 +161,8 @@ static inline bool mmu_notifier_retry_cache(struct kvm *kvm, unsigned long gpc_s
 	 * is elevated.
 	 *
 	 * Note, it does not matter that mn_active_invalidate_count
-	 * is not protected by gpc->lock.  It is guaranteed to
-	 * be elevated before the mmu_notifier acquires gpc->lock, and
+	 * is not protected by any lock the refresher holds.  It is
+	 * guaranteed to be elevated before the mmu_notifier walk, and
 	 * isn't dropped until after gpc_invalidate_seq is updated.
 	 */
 	if (kvm->mn_active_invalidate_count)
@@ -171,21 +198,12 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
-	lockdep_assert_held_write(&gpc->lock);
-
-	/*
-	 * Invalidate the cache prior to dropping gpc->lock, the gpa=>uhva
-	 * assets have already been updated and so a concurrent check() from a
-	 * different task may not fail the gpa/uhva/generation checks.
-	 */
-	gpc->valid = false;
+	WARN_ON_ONCE(gpc->valid);
 
 	do {
 		gpc_seq = gpc->kvm->gpc_invalidate_seq;
 		smp_rmb();
 
-		write_unlock_irq(&gpc->lock);
-
 		/*
 		 * If the previous iteration "failed" due to an mmu_notifier
 		 * event, release the pfn and unmap the kernel virtual address
@@ -213,7 +231,7 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 		/*
 		 * Obtain a new kernel mapping if KVM itself will access the
 		 * pfn.  Note, kmap() and memremap() can both sleep, so this
-		 * too must be done outside of gpc->lock!
+		 * can sleep, which is fine: this path holds no spinning locks.
 		 */
 		if (new_pfn == gpc->pfn)
 			new_khva = old_khva;
@@ -224,20 +242,17 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 			kvm_release_page_unused(page);
 			goto out_error;
 		}
-
-		write_lock_irq(&gpc->lock);
-
-		/*
-		 * Other tasks must wait for _this_ refresh to complete before
-		 * attempting to refresh.
-		 */
-		WARN_ON_ONCE(gpc->valid);
 	} while (mmu_notifier_retry_cache(gpc->kvm, gpc_seq));
 
-	gpc->valid = true;
 	gpc->pfn = new_pfn;
 	gpc->khva = new_khva + offset_in_page(gpc->uhva);
 
+	/*
+	 * Publish. Pairs with the smp_load_acquire() in kvm_gpc_check();
+	 * the pfn/khva stores above must be visible before valid is.
+	 */
+	smp_store_release(&gpc->valid, true);
+
 	/*
 	 * Put the reference to the _new_ page.  The page is now tracked by the
 	 * cache and can be safely migrated, swapped, etc... as the cache will
@@ -248,8 +263,6 @@ static kvm_pfn_t hva_to_pfn_retry(struct gfn_to_pfn_cache *gpc)
 	return 0;
 
 out_error:
-	write_lock_irq(&gpc->lock);
-
 	return -EFAULT;
 }
 
@@ -259,7 +272,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	bool unmap_old = false;
 	unsigned long old_uhva;
 	kvm_pfn_t old_pfn;
-	bool hva_change = false;
+	bool was_valid;
 	void *old_khva;
 	int ret;
 
@@ -269,11 +282,85 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 
 	lockdep_assert_held(&gpc->refresh_lock);
 
-	write_lock_irq(&gpc->lock);
+	if (!gpc->active)
+		return -EINVAL;
 
-	if (!gpc->active) {
-		ret = -EINVAL;
-		goto out_unlock;
+	/*
+	 * Resolve the target uHVA (and memslot, for a GPA-based cache) before
+	 * deciding whether anything needs to be invalidated at all.
+	 *
+	 * If the cache is still valid and this refresh resolves to exactly the
+	 * same uHVA, in the same memslot, for the same GPA, then nothing which
+	 * a reader can observe is changing: the gPA => uHVA translation is
+	 * unchanged, and gpc->valid being set is precisely the assertion that
+	 * the second stage (uHVA => PFN, and the kernel mapping of it) is
+	 * still good. No mapping is retired, so there is nothing for a grace
+	 * period to wait for. At most the memslot generation needs updating,
+	 * which no reader consults except via kvm_gpc_check() itself.
+	 *
+	 * All of the following must hold to take this shortcut:
+	 *
+	 *  - gpc->valid: the PFN and its kernel mapping are still good.
+	 *  - the resolved uHVA is unchanged. kvm_gpc_check() validates
+	 *    'offset + len <= PAGE_SIZE' from gpc->uhva/gpa on the reader's
+	 *    behalf, and the reader then accesses gpc->khva for 'len' bytes
+	 *    with no recheck; moving the offset under a live reader would let
+	 *    it run off the end of the page.
+	 *  - the memslot is unchanged. kvm_gpc_mark_dirty_in_slot() uses
+	 *    gpc->memslot, so replacing it under a reader could mark the wrong
+	 *    slot dirty and thus lose a dirty page for live migration.
+	 *  - the gPA is unchanged, as it provides the gfn for dirty tracking.
+	 */
+	if (READ_ONCE(gpc->valid)) {
+		struct kvm_memory_slot *new_slot = gpc->memslot;
+		unsigned long new_uhva = KVM_HVA_ERR_BAD;
+		u64 new_generation = gpc->generation;
+
+		if (kvm_is_error_gpa(gpa)) {
+			new_uhva = uhva;
+		} else {
+			struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
+			gfn_t gfn = gpa_to_gfn(gpa);
+
+			new_generation = slots->generation;
+			new_slot = __gfn_to_memslot(slots, gfn);
+			if (new_slot)
+				new_uhva = gfn_to_hva_memslot(new_slot, gfn) +
+					   offset_in_page(gpa);
+		}
+
+		if (!kvm_is_error_hva(new_uhva) && new_uhva == gpc->uhva &&
+		    new_slot == gpc->memslot && gpa == gpc->gpa) {
+			/*
+			 * Nothing to invalidate. A concurrent reader may be
+			 * using the cache right now and can safely continue
+			 * to do so; only the memslot generation, which is
+			 * read solely by kvm_gpc_check(), may need updating.
+			 */
+			if (new_generation != gpc->generation)
+				WRITE_ONCE(gpc->generation, new_generation);
+
+			return 0;
+		}
+	}
+
+	/*
+	 * Take the cache invalid and wait for all current readers to
+	 * drain before mutating anything they might be looking at. Once
+	 * the grace period has elapsed, this task (serialized by
+	 * refresh_lock) owns all the cache fields exclusively: readers
+	 * check valid (with an acquire load) inside their RCU read-side
+	 * critical sections and back off. This mirrors what a TLB
+	 * shootdown does for the hardware page tables.
+	 *
+	 * If the cache wasn't valid, concurrent readers were already
+	 * backing off, and any concurrent invalidation is handled by the
+	 * gpc_invalidate_seq check in hva_to_pfn_retry().
+	 */
+	was_valid = READ_ONCE(gpc->valid);
+	if (was_valid) {
+		WRITE_ONCE(gpc->valid, false);
+		synchronize_rcu();
 	}
 
 	old_pfn = gpc->pfn;
@@ -286,9 +373,6 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 		gpc->gpa = INVALID_GPA;
 		gpc->memslot = NULL;
 		gpc->uhva = PAGE_ALIGN_DOWN(uhva);
-
-		if (gpc->uhva != old_uhva)
-			hva_change = true;
 	} else {
 		struct kvm_memslots *slots = kvm_memslots(gpc->kvm);
 
@@ -308,12 +392,7 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 				goto out;
 			}
 
-			/*
-			 * Even if the GPA and/or the memslot generation changed, the
-			 * HVA may still be the same.
-			 */
-			if (gpc->uhva != old_uhva)
-				hva_change = true;
+
 		} else {
 			gpc->uhva = old_uhva;
 		}
@@ -323,21 +402,16 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	gpc->uhva += page_offset;
 
 	/*
-	 * If the userspace HVA changed or the PFN was already invalid,
-	 * drop the lock and do the HVA to PFN lookup again.
+	 * Always redo the HVA to PFN lookup: an invalidation of our uhva
+	 * may have raced with (or followed) the valid-clearing above, in
+	 * which case the notifier walk skipped this cache (valid was
+	 * already false) and the old pfn may already be stale. The
+	 * gpc_invalidate_seq check in hva_to_pfn_retry() is what detects
+	 * that race, so the lookup path is the only safe way to publish.
+	 * If the mapping is in fact unchanged, hva_to_pfn_retry() reuses
+	 * the existing kernel mapping for the same pfn.
 	 */
-	if (!gpc->valid || hva_change) {
-		ret = hva_to_pfn_retry(gpc);
-	} else {
-		/*
-		 * If the HVA→PFN mapping was already valid, don't unmap it.
-		 * But do update gpc->khva because the offset within the page
-		 * may have changed.
-		 */
-		gpc->khva = old_khva + page_offset;
-		ret = 0;
-		goto out_unlock;
-	}
+	ret = hva_to_pfn_retry(gpc);
 
  out:
 	/*
@@ -346,17 +420,12 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned l
 	 * valid, leave it as is.
 	 */
 	if (ret) {
-		gpc->valid = false;
+		WARN_ON_ONCE(gpc->valid);
 		gpc->pfn = KVM_PFN_ERR_FAULT;
 		gpc->khva = NULL;
 	}
 
-	/* Detect a pfn change before dropping the lock! */
 	unmap_old = (old_pfn != gpc->pfn);
-
-out_unlock:
-	write_unlock_irq(&gpc->lock);
-
 	if (unmap_old)
 		gpc_unmap(old_pfn, old_khva);
 
@@ -384,7 +453,6 @@ int kvm_gpc_refresh(struct gfn_to_pfn_cache *gpc, unsigned long len)
 
 void kvm_gpc_init(struct gfn_to_pfn_cache *gpc, struct kvm *kvm)
 {
-	rwlock_init(&gpc->lock);
 	mutex_init(&gpc->refresh_lock);
 
 	gpc->kvm = kvm;
@@ -415,11 +483,11 @@ static int __kvm_gpc_activate(struct gfn_to_pfn_cache *gpc, gpa_t gpa, unsigned
 		/*
 		 * Activate the cache after adding it to the list, a concurrent
 		 * refresh must not establish a mapping until the cache is
-		 * reachable by mmu_notifier events.
+		 * reachable by mmu_notifier events. (Refreshes are serialized
+		 * by refresh_lock, which we hold; the store ordering matters
+		 * only against the notifier walk, which holds gpc_lock.)
 		 */
-		write_lock_irq(&gpc->lock);
-		gpc->active = true;
-		write_unlock_irq(&gpc->lock);
+		WRITE_ONCE(gpc->active, true);
 	}
 	return __kvm_gpc_refresh(gpc, gpa, uhva);
 }
@@ -454,13 +522,16 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 
 	if (gpc->active) {
 		/*
-		 * Deactivate the cache before removing it from the list, KVM
-		 * must stall mmu_notifier events until all users go away, i.e.
-		 * until gpc->lock is dropped and refresh is guaranteed to fail.
+		 * Mark the cache inactive and invalid, and wait for all
+		 * current readers to drain, before tearing down the mapping
+		 * they may have been using. Refreshes are excluded by
+		 * refresh_lock, which we hold.
 		 */
-		write_lock_irq(&gpc->lock);
-		gpc->active = false;
-		gpc->valid = false;
+		WRITE_ONCE(gpc->active, false);
+		if (READ_ONCE(gpc->valid)) {
+			WRITE_ONCE(gpc->valid, false);
+			synchronize_rcu();
+		}
 
 		/*
 		 * Leave the GPA => uHVA cache intact, it's protected by the
@@ -473,7 +544,6 @@ void kvm_gpc_deactivate(struct gfn_to_pfn_cache *gpc)
 
 		old_pfn = gpc->pfn;
 		gpc->pfn = KVM_PFN_ERR_FAULT;
-		write_unlock_irq(&gpc->lock);
 
 		spin_lock(&kvm->gpc_lock);
 		list_del(&gpc->list);
-- 
2.43.0


------EF41DE7C369FEE6126A3D401734EB001
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
FKt+5eNu/Nio5JIk2kNrYrhV/erBvGy2i/MOjZrkm2xpmfh4SDBF1a3hDTxFYPwyllEnvGfDyi62
a+pGx8cgoLEfZd5ICLqkTqnyg0Y3hOvozIFIQ2dOciqbXL1MGyiKXCJ7tKuY2e7gUYPDCUZObT6Z
+pUX2nwzV0E8jVHtC7ZcryxjGt9XyD+86V3Em69FmeKjWiS0uqlWPc9vqv9JWL7wqP/0uK3pN/u6
uPQLOvnoQ0IeidiEyxPx2bvhiWC4jChWrBQdnArncevPDt09qZahSL0896+1DSJMwBGB7FY79tOi
4lu3sgQiUpWAk2nojkxl8ZEDLXB0AuqLZxUpaVICu9ffUGpVRr+goyhhf3DQw6KqLCGqR84onAZF
dr+CGCe01a60y1Dma/RMhnEw6abfFobg2P9A3fvQQoh/ozM6LlweQRGBY84YcWsr7KaKtzFcOmpH
4MN5WdYgGq/yapiqcrxXStJLnbsQ/LBMQeXtHT1eKJ2czL+zUdqnR+WEUwIDAQABo0IwQDAdBgNV
HQ4EFgQUu69+Aj36pvE8hI6t7jiY7NkyMtQwDgYDVR0PAQH/BAQDAgEGMA8GA1UdEwEB/wQFMAMB
Af8wDQYJKoZIhvcNAQEMBQADggIBAArx1UaEt65Ru2yyTUEUAJNMnMvlwFTPoCWOAvn9sKIN9SCY
PBMtrFaisNZ+EZLpLrqeLppysb0ZRGxhNaKatBYSaVqM4dc+pBroLwP0rmEdEBsqpIt6xf4FpuHA
1sj+nq6PK7o9mfjYcwlYRm6mnPTXJ9OV2jeDchzTc+CiR5kDOF3VSXkAKRzH7JsgHAckaVd4sjn8
OoSgtZx8jb8uk2IntznaFxiuvTwJaP+EmzzV1gsD41eeFPfR60/IvYcjt7ZJQ3mFXLrrkguhxuho
qEwWsRqZCuhTLJK7oQkYdQxlqHvLI7cawiiFwxv/0Cti76R7CZGYZ4wUAc1oBmpjIXUDgIiKboHG
hfKppC3n9KUkEEeDys30jXlYsQab5xoq2Z0B15R97QNKyvDb6KkBPvVWmckejkk9u+UJueBPSZI9
FoJAzMxZxuY67RIuaTxslbH9qh17f4a+Hg4yRvv7E491f0yLS0Zj/gA0QHDBw7mh3aZw4gSzQbzp
gJHqZJx64SIDqZxubw5lT2yHh17zbqD5daWbQOhTsiedSrnAdyGN/4fy3ryM7xfft0kL0fJuMAsa
Dk527RH89elWsn2/x20Kk4yl0MC2Hb46TpSi125sC8KKfPog88Tk5c0NqMuRkrF8hey1FGlmDoLn
zc7ILaZRfyHBNVOFBkpdn627G190MIIF5jCCA86gAwIBAgIQapvhODv/K2ufAdXZuKdSVjANBgkq
hkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQ
MA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNP
TU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5
MjM1OTU5WjCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpyn
MS6n9jR22YRq2tA9NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgz
KlWlVJGyK+UlNEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqO
tzk06kb2qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg
2hJZjrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGj
ggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9sjPjF
/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEQYDVR0g
BAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NP
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
DxcNMjYwODA1MTk1NTU1WjAvBgkqhkiG9w0BCQQxIgQglTvrgwAoPPesWsMCemOm2pmeqYkZwbTr
UKMheLOSwXEweQYJKoZIhvcNAQkPMWwwajALBglghkgBZQMEASowCwYJYIZIAWUDBAEWMAsGCWCG
SAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4D
AgcwDQYIKoZIhvcNAwICASgwDQYJKoZIhvcNAQEBBQAEggIAkBGKjhNhZGfdN6/7RJy18Z7CHtRc
RbqRTycXkEnhJ0OUj1B48IdC1cn+EchqZf2UKm/+yWLTjG8pHhNIlS3bdKo2RVkn13HhJdPb2HQg
uK1FNVtKmclfGmbRb55I0pKKV/UAEObo0wK/cZ7dLdRATOCDdZPsWKsaFdvshPq5mFgxbZoWLGQ1
vw+FZ1RDjrm0JehPOUssKgv8isyB0/5OFmpkcRmI5KNGRsfSgb1c+2O0ofgSYXNX7m6525gCHNke
eo8dWrSqOFJ7F9IebG2gkMrrLtNpJmJF8f8Edj6oX/6rv58U5isBmrNRrp1KYQuJ6ylda35ZSTF6
jzZoqZxxlSrtzOKgzEEtnYZ6j0rGQrf+ZIU9llqCaLqKHsDBT9ps6Vn9uAB8/N0nZJqpAg0l0Prj
FvGvL3Zn91ftwuZmY5VeHfuki/q64cR0Hi+haR7pPovmRQDgNsUcRNFXrE3lRVBXnTMFD6ndW4Ow
YBeJvTLncoAEovBNVGPhQc82jZ+j1yJLrfuA90Z6LT5fAxUqNLYIY1u+Ma/QxWRjXtJ36wBOL2AU
nc2W07FQss8Ql9Hmh2qQW+OK79LCYP+dA/OihS9ZjTIojztbQ3iEWe4zGgryNguELVN4J0UIcZwe
MU6fV4xf6R/cyg4TNSWgFzobH9jOT+s7g4PGiv/V2Amtvsg=

------EF41DE7C369FEE6126A3D401734EB001--

--===============0447233886121387104==
Content-Type: multipart/alternative; boundary="===============0707045358344018747=="
MIME-Version: 1.0
Content-Disposition: inline

--===============0707045358344018747==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============0707045358344018747==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============0707045358344018747==--
--===============0447233886121387104==--

