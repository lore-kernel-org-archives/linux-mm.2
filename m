Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C12CC982E8
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 18:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA1F6B0089; Fri, 16 Jan 2026 13:10:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498376B008A; Fri, 16 Jan 2026 13:10:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FAB06B008C; Fri, 16 Jan 2026 13:10:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C2286B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:10:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C98041ADDD3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:10:15 +0000 (UTC)
X-FDA: 84338616390.13.C6B5CDD
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4032780015
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:10:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xz0Krovn;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768587012; a=rsa-sha256;
	cv=pass;
	b=uIc81wgut+7Bvijx23eu9ZIkzkj3kQwDBc42D1kpI8x3BmSzA6Y7ihJxbZwQZ2d9Ebc0lK
	9MrnOi3Lb8o0eqNNl/BmEXmWrT1qCxJFCzt7Ndc/ZdDiChhme5hGahbfLRxf3duRiJR2hx
	QbVkrpoTAe7mHgnWwkxE3AGDYi6v8VQ=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=Xz0Krovn;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of rick.p.edgecombe@intel.com designates 198.175.65.14 as permitted sender) smtp.mailfrom=rick.p.edgecombe@intel.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768587012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+j8Jb7pzzZTaNKwufFIRcPIsc3hxN0HZQChve3xxi0=;
	b=TUIM+S2XP6SFIeeV7FfagHwk/RNAQzW+1QMW32t2Ej4OnFkDk7sIH2KT38erOF0NkGqme2
	MW2h9pE7crOBPbAKMAhYHGztor0lTQdZ+fG6hbJVc7v+lqIZHAz6EeIEA6zUBnPCwpcRKV
	6bgkeI7fIpCrHsEfhCcT8MoM/2dBvnI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768587011; x=1800123011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=n+j8Jb7pzzZTaNKwufFIRcPIsc3hxN0HZQChve3xxi0=;
  b=Xz0KrovnK9639A4GkFpxvxobEaRMLjEhGuIT1Og014Z0YH9jp+2CoEUF
   uhWYbrYqy9PWucRvFx80rgCGhlVc+1lCUVrIPpQLL6Lrq/aFsz9Fo+StG
   vGUxNO7rlRedh8pWveG0dIqK0Y3gRb6CkkjGJfibj/n1PShGdWEM2lYSU
   rZlsyCyOMEJvFU0a4iN8SsNb6jtoQhAqEm6EB70tcyV0yKoLq+xP8xZkX
   I8oNgsxVzPdLrNFYG1D8hTU+Amfi3v5tBF6RAEzZ1vudAQoQHGHkxFWWe
   ovuEUEOeAD3zWLx8O1lqnGk2zruW/B0KWSEBC8Jrou2tmBlJx8qQ/1hfz
   w==;
X-CSE-ConnectionGUID: smco0lBsQwKGJFRAoUDjiw==
X-CSE-MsgGUID: cr+4GZrMQ6ej40RE6ds8Kw==
X-IronPort-AV: E=McAfee;i="6800,10657,11673"; a="73750861"
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="73750861"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 10:10:09 -0800
X-CSE-ConnectionGUID: /Cbh8zH/T36C/4PSGw+yFQ==
X-CSE-MsgGUID: M3RZpiiKTlyeyd6rQEjLqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,231,1763452800"; 
   d="scan'208";a="205335177"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 10:10:09 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 10:10:08 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Fri, 16 Jan 2026 10:10:08 -0800
Received: from CH5PR02CU005.outbound.protection.outlook.com (40.107.200.5) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Jan 2026 10:10:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ToMsq0IpEcLVEtpuSWAMccUgWE2/YI+nEPKpAxRfgmxZ/8jPP4WY1YRR7ZwrLlyPnXWTa3xjWv/lEvPgOs8igKAcUTq2PNoZtganQBDj/ZGSCn788O+OOG8YNfT5FaQYdCqaNrhio5fpeHSLDPLpWrCBOYP0rDiFV8HqNMvK8uMpPaWzwXY2H/OHpCAxABHIaMRzP0dINIeeKMu5qHEgvwZRtupylI8/5Ld9aW2X81PkxfOdel9Oox9+jB3dF8xghlw10rCg84GWcJnTV3da87FxQlm5GXPc3gSGzuqRoKqfht+4SkKFTCvMbqSgwIH6x3LYsMiSVza/4Qd9zLgcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n+j8Jb7pzzZTaNKwufFIRcPIsc3hxN0HZQChve3xxi0=;
 b=KV6B2tl7Ky3mbRB22+2u9zXG3/zO9TAP0Js47AdOlQSHzd1u5L9DWLoJ5hQ4rmLEH8YKbxngG00Hz0yP0aJG5KCGMu1sSowN4n289QUz+P5Js85FeEaurUkAFgFrt3cwNaHmg+EuTXhJsPweRV9/hx4zM5H1b5CEHcq9LNTd33QTZLG0fazjxHZ97/uQvfphxctlIVNi+0LWzYMvgHsGDGpXPyokaQIrjtqQm5bpbCy7F75zXlQxyN8pue1T/zX+oWUxVHKRgGFqf7CnoUqxmavdMqIRNKlVNj1ZZY3h6MIumRK1mdJ9gcsITfDlkMXyIXbyuo9VjSajCdJJ+hLcWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6168.namprd11.prod.outlook.com (2603:10b6:8:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.8; Fri, 16 Jan
 2026 18:10:03 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::3ad:5845:3ab9:5b65%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 18:10:03 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kalyazin@amazon.com" <kalyazin@amazon.com>, "kalyazin@amazon.co.uk"
	<kalyazin@amazon.co.uk>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
CC: "david@kernel.org" <david@kernel.org>, "svens@linux.ibm.com"
	<svens@linux.ibm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de"
	<pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org"
	<maz@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org"
	<ast@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>,
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>,
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org"
	<luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "peterz@infradead.org" <peterz@infradead.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jthoughton@google.com"
	<jthoughton@google.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"itazur@amazon.co.uk" <itazur@amazon.co.uk>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"andrii@kernel.org" <andrii@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com"
	<derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "jannh@google.com"
	<jannh@google.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
Thread-Topic: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHchnGR8zlgd593vU675Y8ML/1Q0bVT6T2AgAD7kQCAAAm5AIAAH4kAgAACwQCAAAPBAIAABX0A
Date: Fri, 16 Jan 2026 18:10:02 +0000
Message-ID: <a84835708eb92d99ba524149bde819c4ba944cb9.camel@intel.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
	 <20260114134510.1835-8-kalyazin@amazon.com>
	 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
	 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
	 <bb58a21f91113ca39f8888d718d4450a5fd72808.camel@intel.com>
	 <318407ba-ecb6-4691-8911-645fb8c20250@amazon.com>
	 <c42cc00f3902673b1a964c3d098b8c3f236cf9a1.camel@intel.com>
	 <98b8ea1e-3bdd-4987-8acc-58112076d451@amazon.com>
In-Reply-To: <98b8ea1e-3bdd-4987-8acc-58112076d451@amazon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3-0ubuntu1.1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6168:EE_
x-ms-office365-filtering-correlation-id: 06345658-b1ce-4312-60b7-08de552a7867
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700021|921020;
x-microsoft-antispam-message-info: =?utf-8?B?Qmw0Q3BGQTErWTF6ZWJTZ0RZSlluR0lKQmJRa2M1U2psenZISitBdThlUnNW?=
 =?utf-8?B?dXJTdmY1Z0pwQTRXOG5UOGNad1hFalVIOGQ5dDNvWW1CVXdLK3BrdzJkcjJl?=
 =?utf-8?B?bDNNL0xEcmtIdFZFeTdIMVIyaGtTRi9MYzdpWXBZMStWQWd4dStQNUVQRnpM?=
 =?utf-8?B?OEZGbTM4MDFKZ0dKTDBwS2dlRC9YQkRMZDdpUXYvejZrazdrVkNSTk5UODRB?=
 =?utf-8?B?N2RGT1NBUkt0TnNjN2RRSElqbVp2U2ZtRGRwdWxOeVZYcHdKVGFpei9DWFYw?=
 =?utf-8?B?TXNCYXZqNXBlV1dMNE5SeUNZS3JaOE9MOE5aT25IM3RiV0I5WldhVGNtK0Nq?=
 =?utf-8?B?REZrd0VHN2M3TDJWbHZRbHNIOHVNZDI4cDVMSGRHQTNxSjNZVStuYzZoc0RU?=
 =?utf-8?B?U1RQdlBMUlBIR2hUS3NaWERHM2hHZ3FSb0JSaDFLbjVTL24vNnlMMjdkQm45?=
 =?utf-8?B?enBBOW5WY2FNZUJEQ1Z3TlFxQ0pYVFlGZkVZTGVuQ3IrNElOS1o3U2xnTGdk?=
 =?utf-8?B?eWVzUy9qdnQ0UjZmM0tjU2dvZVp4eklpZUZ3WHdZL1FVRHlXSlNqUmtNd2VQ?=
 =?utf-8?B?RnZPR1MvOENEdGVFLzJXRU1zQmh1b3VmbEhuSTRpUDRDZTNyaDloVHJmeFdP?=
 =?utf-8?B?RTZDeGRaRWNPVFpVS2o0MkFkQWZjSW5RYTBpN3NPY0NRRTh1ZzZwTnZjYk5n?=
 =?utf-8?B?aTQybUprb0dWY0hFbStjajRBblVIUWZpK2lEcU1BWG5RRThnVjlFSWZMWnI5?=
 =?utf-8?B?d2k4cFJ6MTJWamw5L0QvbTd4elFRRkJTYWk3dmtMMWxIT1gzejJtT1lEaTNr?=
 =?utf-8?B?Q24yZzJPVjN1OGVyVEU0U3ZEUlZpeXJsRkFCK3M0Wk11RURWeGMrdTFSYlRL?=
 =?utf-8?B?TzMzcUpMaU9kcjBQdGxoU1Q3aTFCKy9venZzY01QWGFTN0xhODlSTUtHOXJY?=
 =?utf-8?B?YksvT0VpeDZ1WkJEODJQMS82UFl4MWNHL2tEa2V2b2V0bTV2ZlU0L2NpZnBq?=
 =?utf-8?B?eFRyNzhoTE5xNnNRVERPT1dZWU1FMEFnTzVtQlBNYndLazl5Rzc2cHE5TlhL?=
 =?utf-8?B?eHJxRTd4N1hwblpnVC9ja2RJWUdwaEdESHF4NTZGL0N3cVpudU9FQi9BQ0tP?=
 =?utf-8?B?cVAyOG1NeGtTU0tCNXU4amFtL1BKY21MWnRCZzQ5ay95dmJFdDd4UmpRUXFn?=
 =?utf-8?B?c001b3dFTXJWcGFwSUpWU2ZWU3d6dk9zZ0l6c0xpY3loNG85cGNsQ1lpcUlO?=
 =?utf-8?B?WTcxZTg0MVFDbXhXOTMzU3d2c0VoZnZ6Umx5akcyQ21VbWJIN3ZCSXhzdVpW?=
 =?utf-8?B?TXkyc1BONVRwZmMraFVCekVPTnhCaWZVR2lTb0ZvQjRheVFxTzhtRTh2djA3?=
 =?utf-8?B?cVkyUmlIWVhyU2p0WkpPWEl3TXlxVGJJSktuemZtNHc3MWk2NHgwT3R6U210?=
 =?utf-8?B?UzN3V2l1TkNQVjBhYzI2UjlsaGhRWHh2OEx0b0o0ak5JRng1NUdlNElMbW4y?=
 =?utf-8?B?Y3ZpT0FzaTBDNHFtRFpndzZ3OXBrbXR3UWVqVmErVCszVGNScUpDY2oyMnk5?=
 =?utf-8?B?MVZKTXMrdUZqbXppMHMrSjhld0hUOUc2UkRIV3c0NmJySllZdEI3ZEVxMXFB?=
 =?utf-8?B?YnJpRzVJSkY3V0V0dzhwV3hVRHpKTElEUzgwL2FHK2diRlJNVUE4WnpkS1RB?=
 =?utf-8?B?ODlBMk5kL2tOL1hkSjVRZ2dUbkVTd1NSNnZaSnR2U0NFajBrOGQxdVFiZDhS?=
 =?utf-8?B?K1JJZzJWM0tRTnZmSkdHSWhjSWRXRERSWmtoTStRWXF2Q3FGRnRQbTAxM1NF?=
 =?utf-8?B?aE5qR0k2T0FqOWhXS1BZelJ2UmVwL1FTTDJqd05rYllZcXVBalB5cnhOOHBr?=
 =?utf-8?B?NmNEeG1ReG9BU0J2SlUrZlZXNFB1WnppakMwSGY1Y21LVEtHOWV5MUZmZnpX?=
 =?utf-8?B?SC9FSzZGL0ZJOUJSc2lIVHplQlRJTW1hVDIzZWIzY1JZZ0dIQnpaZVN2RWtn?=
 =?utf-8?B?R0dIdUl5d2JSbVFCTHJaZTJyQnlPVThTTmFLL0ZLRUJMMU4wcmp4SGZDYW0r?=
 =?utf-8?B?S0RFbW43c1FDTSs3bnJYdVRaWmZLakdlUHdleEJ5Z3paY3VOZDNqdVAwcSt4?=
 =?utf-8?B?ZVRkRHhRSkpOc1ZyZFRJcHhRR3pQN3NsSUNFdzMzTjlOTTRmSnh3NU9SZUtR?=
 =?utf-8?Q?Dnt9sK81MLA2iSOkLTwolFFTbnKL1WnfeMnxyMElWfYl?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700021)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K1BlOWg3MXpkNWtIU0picm9rRU5hQUxpZWd3alV6c3NKaFBXQVN0Wi96U2Z2?=
 =?utf-8?B?WjBSVjBZZlZkeXZiSjhzMXBuNTZ5NWxOK3lpczVzaURMUmIrdnFwMmxTOGwr?=
 =?utf-8?B?MTJXczBVOXhaK29veXpPYXA3aVg2dEdRQXVKTXI4dkNpOURQc0NqR29YbmhZ?=
 =?utf-8?B?YnhMMDVTbG5PQzlmd25BWDFINnVIcGZxQVV4YU1SN2t3a3h5ZjVad25pWHZn?=
 =?utf-8?B?UmJEa2hpNFU5VFA1d1VVN0lnZGlkbDkwMURMZ2ZOVmx4T2hFN1JBSlVGQVM3?=
 =?utf-8?B?VzZDR3phemdXTkZGbVhZYW45aU0zZ3hpUXB2U25oY1AxYUNYVnNlejJ4QzRU?=
 =?utf-8?B?d252V08wV3RiTDhjdjZuRmViZnRlelppNm9qaDFMc1dzdWJZUWpWeFc5Zmx2?=
 =?utf-8?B?cm03NnpUS1M3b3o0M0Q5djd5VnFCZzR3Ykp4Vkc5YWMyQTZMZUM5N3l4NXBj?=
 =?utf-8?B?bnBhajJ2cXJlSkJPZjVpUlJCMFZ3blJFMm5sYytqK0lRYUR3bG1uRkRpWmJ3?=
 =?utf-8?B?ZXNzL0NtR2RlbFNrNkVseWpKeDVVcVV5a3FpcnhaZFFWRXRFZkRFSkg3Tlg4?=
 =?utf-8?B?UUkvc05HWlJucmRSRzE5UXF3SHZ4WWFKcGcyOGNyMjlobWo2WVcyNVEyOWNy?=
 =?utf-8?B?ZmVVc1phZEhKTmVSbFlqSXN2d01CY0FvRk51MjdZcFhOY0xvSXhCY3VEc2dK?=
 =?utf-8?B?K1o0VVRvb1dtdjZ3NjBEMnI5aTcrNkx1cTRxckFyUk1QZGtBMU53eFRPSC9a?=
 =?utf-8?B?ajQ1WmlQcHFFaG0va2ZwSXNMem1mZWg5U05NZnhmOG01TXUrZ3pkV2VMMlFu?=
 =?utf-8?B?cmFSL29odkcvYUV6Z00vZ0RRcDU1YXNaUFgwNnpXK3pKM0Vob2xpLzVOcFpv?=
 =?utf-8?B?c1p1TFgzNVJncE1kb29pMFVCaDlTYnNVOHZ3UTNqbTlNZGNuOVRZSTBkZENC?=
 =?utf-8?B?c281SGVKUVVxVXBkTVMwYVpZWTgyOUlPYVdqUmpRKzA5M3IrWmdJaFZnbklB?=
 =?utf-8?B?cVc0bGhKU3pVVExMa2dTT1F5WFFMcGVnTmdzckw3UWw0YVpQRlJBdE9UZ0tn?=
 =?utf-8?B?OE9DZ1VvaE9yRTFIQU1NMC9QNVQyVWVDby9KRG9vRXVZZVByWjB2a1hlcGZ2?=
 =?utf-8?B?SzNJMWVRUWN5WXMwL0E0M0FPNGlGdTRsQmhYWVN4d21TNklXNFRNb0ZWMzc4?=
 =?utf-8?B?SzZKN29yMW9hMHlSaTI0V1JsVnAxb2h4djVqWXNGOFlPMUhQcnhOaHlPbGls?=
 =?utf-8?B?Y0E4cWhUd0M4aHd3d3BFL1RtTDdKdVg1M29PbG5sVXR3R0p3VVNSZ1RrbDNS?=
 =?utf-8?B?Z1JaYWlPWlZwY2NOUEk2eW5ZMlM3VlZwVVFlMk9hUGlMUVpPbEZDRWRlT2dT?=
 =?utf-8?B?ejlZdzJtWjRJWXJDNlZhOGh6TWhQRmhmWGxzTyt3dFcyWDVlVG1GSTlBSVcx?=
 =?utf-8?B?R2dhbVA4eTJjK21aQlZEQ2s4U2Iycmo0cjR0OC9zaTBrUUsrd052eUdibUVq?=
 =?utf-8?B?cVYveDFOOHNob3NzVytJQkJHdWZPdDJyazRDaGZnRXBaVkJYU1M4blYrOENx?=
 =?utf-8?B?UGVtZmJuMXdSTVhRZXg2WitZeS9NWXpXZDBYbE55UFo1VGZIQk56Q3VNZjVW?=
 =?utf-8?B?N2owN0dyVjFqdFAvVHBjMXNCaGlKSGV5dW8yRjgxaU8vM1M2QUo2d2dqcXhL?=
 =?utf-8?B?ZDl3NDBGeFlGTzZLZUs3QndwNDlPbzRGS25jei90TElBby93K2czVEdiOWhy?=
 =?utf-8?B?eUFvandtNG9HSTN3Rm14K1RrM1BtWHdzZDE3WElsbGppWTMydzZEbE0zSEtr?=
 =?utf-8?B?NnYvNGpKdmNrQkkwZC9iNDBtQTV3QmhCZWpDU2JwdENnMU01R1dUbHdsUU8y?=
 =?utf-8?B?RENDcTIxd1VESXJYYUhHT2FjdCtxZ0xsb1FzSVg1em9HQjFiQ29IQTB0QTBo?=
 =?utf-8?B?TERmNjNiT3hzZDF2eWc0Si8yZTcxSXRtVmpmTXR2bTY2ZUpmKzk0MUQwMyt2?=
 =?utf-8?B?dVk5QUttQUJiVGVUMTdmVmJqUVpQdzFXZXpEZzZVaFdTbjQ3VEJkZldpa01N?=
 =?utf-8?B?dG0yRzVpbnE3RDlrOFVGV1BVSmVNV0FpRmRyOGs4Q3dSQkp5WGxONjN6czVS?=
 =?utf-8?B?QjcydWhGK0FET2tLMEduZlVUQUI3SW9iUGJOVTdGc1RwSnhUb1ZOM3lzREoy?=
 =?utf-8?B?WkhPdGszS3h3VEE3Y0VsaW9Ya3p2WHQ4Nldrd1BBSTdwclNIdDN2aTNFcnRS?=
 =?utf-8?B?anJlbTk5cmM3L2R2M0xiUm9ROUdCN3A5Z1cwR3NMckp5VlljeERvRVJ5YTNQ?=
 =?utf-8?B?cE5GVFJQT21Bc0s1VjJ2OEJNaVFmcnVuUGgzTWF3T1lTM2t0cTltdktqZUZQ?=
 =?utf-8?Q?xIXNIj8wnFGh9mE4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70AB1C6FD4E1964A95109CC6645278CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06345658-b1ce-4312-60b7-08de552a7867
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2026 18:10:03.0086
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o05B0u0QMLBshbYhauBBP2lNZYgxEPpUsUAIka//Rapb7dWLN9hFUJy4wpuJ1wwU1wBQSw+M9nCQdxqwL+rYk/NsL89TxECWx1+nIeabeB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6168
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4032780015
X-Stat-Signature: 1jcx5j9udqgju3p3fakijumx8yfh89pp
X-Rspam-User: 
X-HE-Tag: 1768587011-24746
X-HE-Meta: U2FsdGVkX1+TtqoCCKIJLn+QPvrcrtA0/vIXkRaZAXBNjiAgna5L8Ig6CjaVb6mdsqYQm2n/6DpNfuW4yO12jlbHMyGD6YyWS8bOVYZlxh+L3HGyoyvzTh+z3MhuJwo6BpsfQsTpoFhWDO6nVWuu4ilpXza7nTPuqpksx6wKExLSWY4n8lpSCID0orNZl7GdhthAk5Drg6fAbnduqHco+1Nd3YLGFKtOhS9yxFqw2fsPBrkG+ivJU222vASXZqkf3KXBr4rOh9xeMg7CJyi252xqFORqH6VRGpPttjBf+lOk0tm9sNBuk29zlB6VXI3m+b5f7uXh0n1FB1cUtj95e54LWONak3G1xEwsbIV7Bq/qxVt82ShKWCj9Ki3SQ8t4gS8inqPRUXqeW2ozFPI7WsIbN56pkp4CDJLnyh5leFb6ORY79MhIG9105oWLoIVZ+KuHOywxBwURvJkZOgI/5s3A3kToKj0Yg6uLIBIf5G5J8Cf3U0WjOVaoM7TIW4aHRsVjtqDgfnSDckFs9Ut6rGCLdcdEMzFZwRnW/G8eUu1AoTe8Qti8wqPOVYXB1kFXo76ZrVjUdeZwIjYRedcSv64YfznFHDe1/CnsVb4RSFr3cVZPgeMhJuhOJgaKm2eit29Fi08eP9b6AkggYYPiPsleipOSG1SvNe+BBzCBKW9MYSrRSnizme+AtjwX2iTbC6SDpQuFHihJZnDR7sZPMu0JdEueZaA+Di824Dkbq2DrGI3rnKDiiNN0T9zqWabn6zgcZY4e5qJDcTqqaELLNinx2OioU0gSkd+xilLfUFOswNSMMTE33riLxFQN9b3oVh4gq8HjIUwq5OFwWdBZR6PWb315kvrbvzPlnjVAbCMWZaH9ZY2+ApotBc/Q0Sq2FIFZEm0VRHL/hHHPvhgl/LD4NWh9QpIIQlV3QN6w3AVUOCaDRV3SI+PiJ72YZBXtaPNeuUxxMiuuUQw28wF
 IyGxpOal
 3/IJ5A1j6tUYPSz1QKiCtHPuxo5pnp75sXs/pRS5tvMtR7ndrlDyc38x/97Jb41rwSOfh8tGLSEXPleufk3m2aCuaKLOso+6Ho22PgH/LgmGsDEeXD9lk4eqA8KAnSXpGSAgwGfbW8ieHGzpssNW5GW2PN/UVOr4A0P9BNrOCo6JY5Y59TBpU5aFRPiHBw8/zXJCENeJS4yrfAVzBhQBwTKftSgaf6J8tz97QvXyIpX/uKKPVBGOPocpGsunp2nTTy+398Y4cktlHfViNzISHlPhOCskjCYGa1cpMxN9aCa/kLCV3Qfr2Xa50vscgSRTLu776xzb9vmziNR6hFkgy5Z6LbzRVDb+S9dlGhS6gdbNfV7a/MyI2CBGL7ftNl/A5cTQ4yNYqGz5B2bbZWllCyK0XwwVhopcaCiLOIOfolaamJsTtkRSkKXzv911EnNNFL5Tzgr40t8HPkN6wcT6T5hIgtydME4l+c+2wKxNJy9wlgsIftut3U0A11DN2HazPGRxAo3J3FuK0CVFhTTt9i5SkX9h67jlolq+pJR4NSwSEnkTQii1TOnuKRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gRnJpLCAyMDI2LTAxLTE2IGF0IDE3OjUxICswMDAwLCBOaWtpdGEgS2FseWF6aW4gd3JvdGU6
DQo+IFllcywgdGhpcyBpcyBhIHByb2JsZW0gdGhhdCB3ZSdkIGxpa2UgdG8gYWRkcmVzcy7CoCBX
ZSBoYXZlIGJlZW4gDQo+IGRpc2N1c3NpbmcgaXQgaW4gWzFdLsKgIFRoZSBlZmZlY3Qgb2YgZmx1
c2hpbmcgb24gbWVtb3J5IHBvcHVsYXRpb24NCj4gdGhhdCB3ZSBzZWUgb24geDg2IGlzIDUtN3gg
ZWxvbmdhdGlvbi7CoCBXZSBhcmUgdGhpbmtpbmcgb2YgbWFraW5nIHVzZQ0KPiBvZiB0aGUgbm8t
ZGlyZWN0LW1hcCBtZW1vcnkgYWxsb2NhdG9yIHRoYXQgQnJlbmRhbiBpcyB3b3JraW5nIG9uIFsy
XS4NCg0KQWgsIG1ha2VzIHNlbnNlLg0KDQpEbyB5b3UgcGxhbiB0byBtZXJnZSB0aGlzIGJlZm9y
ZSB0aGUgcGVyZm9ybWFuY2UgcHJvYmxlbXMgYXJlDQphZGRyZXNzZWQ/IEkgZ3Vlc3MgdGhpcyBz
ZXJpZXMgZm9jdXNlcyBvbiBzYWZldHkgYW5kIGZ1bmN0aW9uYWxpdHkNCmZpcnN0Lg0KDQo=

