Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F864C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7FE6B00AD; Mon, 29 Jun 2026 22:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8FD6B00AF; Mon, 29 Jun 2026 22:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A426B00B1; Mon, 29 Jun 2026 22:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CC996B00AD
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:21:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A73E1C16E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:21:34 +0000 (UTC)
X-FDA: 84934977708.13.86B3500
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8F16140002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:21:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ABSg7hHF;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=fail;
	t=1782786091;
	b=4jf8sotlKzAG7i8BnZyGQhsSIB5eYVP1hjv9urweJ9K/3aDLEiQvqQIMj96uXKDJBy7pIT
	MIohFn9GJAXOJ7fRTqbwe3BQ++zV3JYybrk2N0VffYtLXxKx4XQpHX/gXvI6k7/qFqmvqJ
	fVT3YgyI7+CbZNFGjjNVNAn9B2l5hSI=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782786091;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r2RjIIIuo9a+iMDxS0z4pQaj1HZQRRRauX+nbGaNtSk=;
	b=uV3qMOuSLhrRgu5x39ZO6B1/rK4RGgHPrKt88MOKv4Jj0U+H9psAqwBEUJGWZ++9Pal6fq
	H3xYjmsipgl4LCznogVhEuTA+1BzfVE4xtaBlVffSeDn0fW92WsfNLLEvCDYxUWoesjVnj
	k9Md/5xLcHZp8+/5uWTEjH8kTdSXiyY=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=ABSg7hHF;
	dmarc=pass (policy=none) header.from=intel.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf07.hostedemail.com: domain of yan.y.zhao@intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=yan.y.zhao@intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1782786091; x=1814322091;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   in-reply-to:mime-version;
  bh=OeXFCOpxuYVdmjKJWctR5cT5Y83hW2sOiocKJmETyw0=;
  b=ABSg7hHFtCNO3oY+iW3HgibPrOOENehKW/IjlrkV/6y5ZMydzAN6Wdvt
   VC1dHK7W2w/U2TxJW01YmssZRULDNLmOnfFsvedCFwiLPuYi/LTuDhVVQ
   qI1C5r5iXpOGFFSPXxBoceeEA4AHnxTCVy/PpXCVbCxwJOvZRNXQOqG/g
   XFOn/2RpYzxB5UrFf3GROhfjU9db6CtmJH2FhfE3EzwQZ/Ly6WQXkrn5p
   cg22mB4KTow39Sx4h5PtQZhXy4aFuzyFE9jp7g5HOluwOe2UNlQOfQ+f9
   fjoYVuyl4VaERVHI7WjQIERoqNHfvKmFJCvLu2mM10EphNdBr0x/IkXA6
   Q==;
X-CSE-ConnectionGUID: YMNWbhwbSbWWDffIVOd9Kg==
X-CSE-MsgGUID: pQkIHx+hT16FZYFKaLZ2nA==
X-IronPort-AV: E=McAfee;i="6800,10657,11832"; a="82602064"
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="82602064"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 19:21:29 -0700
X-CSE-ConnectionGUID: yQmuN8J/QeGCoCoBiJbCEg==
X-CSE-MsgGUID: 1B4GDCdvS/ibCJ/h4w0HrQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,233,1774335600"; 
   d="scan'208";a="254030383"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2026 19:21:27 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 19:21:26 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43 via Frontend Transport; Mon, 29 Jun 2026 19:21:26 -0700
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.63) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 29 Jun 2026 19:21:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wnwIa4zoVRjFX7spqpzQwfbd0MqRWsH9ttSwvgFkUwaOfz9bZMRe2tsL84rvQ6WW9A8o46s4VbjegFPlxK5zgN/tTgD1PzrvUYWilU/skASftUF1jwH6KcK2dU4F3CNqwVAh43MnjwIkps90QfiS8pCWeDejC4TEb7QMb1lv4cUBDzV8a1IHbExtS0yg8DY3TqZaZlgAVVrakgIloIgr6JxJ5eSNnBDxjX61oRFlv7QcAysDn090fe42Ao92PmfCT89jy/Q1aCwdRtQLRXGHr4K26y/RpkQRHMs20eNammxUb5ySjVCg79A1ViMtbBJJ5/P9TEt35HITOIoIKtIMEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r2RjIIIuo9a+iMDxS0z4pQaj1HZQRRRauX+nbGaNtSk=;
 b=sxvLC3uJhK+aKqFMToZ0H4EoqakZVnxylxViwKqG4bTTBEB6Z1xtW5VZKgHZEbo24fXmD3hSf4PEn20L+41fxe/93AuI3+iQnMTxYOZZJ/n+ydvqX+1c9K+BPboaN7qHQu7LZWeHr3Ilf0+DudDrI7/+NKnxoRMJu5r9kdAAIqTWzxPEMmb+mxCIEtjBqVdjAyNDuVMGXz7pVv36uF2PIr4MVaKQO3n9q30oo5nd88cLNb/JV1ebAkeDlkSE+Ty1XbDu/ePA10N7Qg9qzgXGUDdY5Ke3VTJmtWhINk7ITRZDRWz85vR83QS3k6geriu1LFfn+WgZ8F/sTDTd+WHdTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from PH0PR11MB7472.namprd11.prod.outlook.com (2603:10b6:510:28c::12)
 by DM4PR11MB5245.namprd11.prod.outlook.com (2603:10b6:5:388::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.18; Tue, 30 Jun
 2026 02:21:21 +0000
Received: from PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475]) by PH0PR11MB7472.namprd11.prod.outlook.com
 ([fe80::1bad:44dd:4e60:6475%5]) with mapi id 15.21.0159.018; Tue, 30 Jun 2026
 02:21:21 +0000
Date: Tue, 30 Jun 2026 10:21:10 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: Ackerley Tng <ackerleytng@google.com>, "aik@amd.com" <aik@amd.com>,
	"andrew.jones@linux.dev" <andrew.jones@linux.dev>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "brauner@kernel.org"
	<brauner@kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "david@kernel.org" <david@kernel.org>,
	"jmattson@google.com" <jmattson@google.com>, "jthoughton@google.com"
	<jthoughton@google.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"oupton@kernel.org" <oupton@kernel.org>, "pankaj.gupta@amd.com"
	<pankaj.gupta@amd.com>, "qperret@google.com" <qperret@google.com>,
	"Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "rientjes@google.com"
	<rientjes@google.com>, "shivankg@amd.com" <shivankg@amd.com>,
	"steven.price@arm.com" <steven.price@arm.com>, "tabba@google.com"
	<tabba@google.com>, "willy@infradead.org" <willy@infradead.org>,
	"wyihan@google.com" <wyihan@google.com>, "forkloop@google.com"
	<forkloop@google.com>, "pratyush@kernel.org" <pratyush@kernel.org>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "liam@infradead.org" <liam@infradead.org>, "Paolo
 Bonzini" <pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "H. Peter
 Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, Mathieu Desnoyers
	<mathieu.desnoyers@efficios.com>, Jonathan Corbet <corbet@lwn.net>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, "Annapurve,
 Vishal" <vannapurve@google.com>, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	<shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Barry Song
	<baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
	<yuanchu@google.com>, Wei Xu <weixugc@google.com>, Youngjun Park
	<youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
	<shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Baoquan He
	<baoquan.he@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka
	<vbabka@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>
Subject: Re: [PATCH v8 23/46] KVM: TDX: Make source page optional for
 KVM_TDX_INIT_MEM_REGION
Message-ID: <akMoFqj/8Af2i/Al@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <ajoWngKaZ+wfIyR+@yzhao56-desk.sh.intel.com>
 <ajpGxu2uQys+S2F8@yzhao56-desk.sh.intel.com>
 <ajxasFBzp_9KnQLq@google.com>
 <CAEvNRgG1nHipzw4=eBgwhvyXi8xYo7FQD_sy9Ax6FDf7YDu3Og@mail.gmail.com>
 <ajyRg3BwGu5dCfOn@yzhao56-desk.sh.intel.com>
 <CAEvNRgH5KOHoemnC9QOn_oK97=KeAH1XuX3ps36-pJ0Fn0aBHQ@mail.gmail.com>
 <aj3TGLGWT1kMFIVH@yzhao56-desk.sh.intel.com>
 <CAEvNRgHb6WmOha6Pct_Tn8Ucuov95L=fj5=2R9gcHfx=b2V_+A@mail.gmail.com>
 <akI9m02jgKAdi4gX@yzhao56-desk.sh.intel.com>
 <akMPZePBdwQlD74H@google.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <akMPZePBdwQlD74H@google.com>
X-ClientProxiedBy: PS2PR02CA0029.apcprd02.prod.outlook.com
 (2603:1096:300:59::17) To PH0PR11MB7472.namprd11.prod.outlook.com
 (2603:10b6:510:28c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB7472:EE_|DM4PR11MB5245:EE_
X-MS-Office365-Filtering-Correlation-Id: 5618e017-2c11-4a84-4b18-08ded64e4685
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|11063799006|22082099003|18002099003|4143699003|56012099006;
X-Microsoft-Antispam-Message-Info: RaJ2BUiKKzMaA623CrrMKqT4CSSbx3B3DKXpkE+O8HVdh5gQXds/F5HyBA/YJ9z231F0+aKH/JEe7psPcBUuRT91S0ixntUZoXPPuy/mJJ5K3CrxIG0thItMUuncumCH9YL4vq8hoCi5b8EBiPmXNGl+DC/eMa5+Z7GCb6NhHBhVeRuJdo8hFow1Pq8CrxD6Tn+Eg2TjxQ3q3a/NcAeWU2loX37fLpfD6/Q5/9XkpaXWEQnMYw9iMxOqqdogJgLEusvL4DnayfEa7SEOajctjSUbbbMB7EvEPlyq7Ucx4nw3oCO9FngLLuKFWYCu4JlRzIP7QFf0uBb7nWODAggHS1npadtC6VLnfHI0w2mUtX8dzpnruQJ3sAw6/wH8yCTJvCVAaWWfx6NdWrh9bu3r7s3P8y/wJjJt8a/aJ3E/2LB+oBUnVgJDKZVh8To10ux5ZBhax6ab7O8Dp/lcNH0EyXOmFlr9fNPIZunEFs1uPraI4PqKnftzQTSKVHBlPB7+SJFp07qyrQudy9bObqWHw9d1/LBjOdm8buxXhA0TttNPVX8WvUYxZNRbA4/W1KcUYFvcZfTFWe+mSn653iix/GA5c7r0qaJkcVb1ZCVQ67c0ri0hS3YXco/+ZkwNzh2Ou9RS3nmdXbnJMJGh1Y3BNeHYRGwd98X5jsdjHOatnA8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB7472.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(11063799006)(22082099003)(18002099003)(4143699003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OtBL3Ojn+se11+1OLUU3K8ftRCpghdGdnfzL1dTqkvMDXgTz4RiXdMuZn+Pg?=
 =?us-ascii?Q?jHn8fypjSPM3bp5SeMNc89WHaSrvAHGsMengj3dyamR5kcGyDHWebSsaE/qH?=
 =?us-ascii?Q?iij0GJ1zoD5e+ipI3YuqGSebf08NT3nF4z+P9y/8Ie8FI94o/MoZ1a4E9Xu8?=
 =?us-ascii?Q?vV7He6quPvwx9ysWa1lm3n4AZ6S3LcAO3+OzLl+0n2wHF69XPtDXc8ZV5lyd?=
 =?us-ascii?Q?JvcxuK1l7kr5gEqWmLHOEDRKnMf8QtkIMdn5FPMhGRkr/hyPl9BJKlJKOFag?=
 =?us-ascii?Q?6JPxTu6kwhagfgruom18+Zxdn8t6pMn1tOYTKKAoezHVeFKxYLkqDtwF+ThA?=
 =?us-ascii?Q?/yqI5MIwr9V1WKWnjFyx8v6yuTEhJHbVZqF6jLpbD11hcP6tpRVYm8jJ7ssy?=
 =?us-ascii?Q?Dvw1OXrj6J2xPvFLZfUQg8BA9+UTh3mCAsheuSAIQqDIRHtZfAfwaDM83X3I?=
 =?us-ascii?Q?YbXPtUmbbW3Ro4zyfZQR/u8h5EiY8chq+pOgAOX9pErVxe1zdy7ckVndcDVI?=
 =?us-ascii?Q?EQP/BRax/yBBZK/XFFEntMye3mlY8O+s5X08h7lrBjCC+doMUbF3oaD3wk61?=
 =?us-ascii?Q?TFcAQuWTYBhjKIUE+0w/7HTFxCQAai+WWhc5scWU1uUGNry5/wy6S5logjFe?=
 =?us-ascii?Q?1vj1ie5kM5cQKtigBrssMQBE9Q+zS+jG6UBM3aNCgBnjQSl0vH//qEFaJXmS?=
 =?us-ascii?Q?fUumy4JkSVvUFP6lcZ9E/9aXBEq5T6G1uoouH70e7RKjlOhGUWb3Fpql9GTh?=
 =?us-ascii?Q?gi6FxlHn7ky4qUS34SCerNOZKiDPvCSvbycToQdrn0kKXbbZXeVz4nxshMfR?=
 =?us-ascii?Q?GR5G42gGJ0FT8TbLOfbQ3anj3Asoe/4lnpGMIX9RlxpHTB9fbeZ2kq+JgsRw?=
 =?us-ascii?Q?2OPL/yq+EDGc9Syn5wirQQE+wrtpUy2IsjggpYPMnvXnPuE5F/HSNUhni7E/?=
 =?us-ascii?Q?j4P+vtVqK31D69tKm4hMBxMcPmrlS1dqNsuQO56Omv/bn+2qf4fp6ZRJBuFW?=
 =?us-ascii?Q?8DwABSwBDUxT6pCS8hwbECo+GX0kgUxrO1jFY98+XxPS82bvr55Q1eF2GoHB?=
 =?us-ascii?Q?9W9NgGcAgnZmK9BXgfvU84eNI6n+u9BD8Bo5fHSSXUvgo2n8FILJP1iOzu5k?=
 =?us-ascii?Q?TA41TrMJqmwDebK1NUKpost/sB9p2OKXH66YPGYftvOnGCQiVzE1yaNM5aIt?=
 =?us-ascii?Q?rtPTWV5RUHSJMEOg7oL3AYvTt/+UTF3GkJnBmX5HwOmlYF0tBpbFixyIQ609?=
 =?us-ascii?Q?xIQVJU+mbnLZ/Z+DF6wLPeTr21NWfZSUpiy4+HU0vVtROxTpNtcazpD0nfBd?=
 =?us-ascii?Q?VjblrQv0W9tee5PTwjO0KWLl01Pkm4w02S92fIHQuTmLs2P2pdFCkfeakAoT?=
 =?us-ascii?Q?Uh9W8/Kb4dud6sa4OzJ8znyunRhXrCQPa4foUazJu62q3XxcAhPxB/m1x1D+?=
 =?us-ascii?Q?HM3Z1v8fmUdCQmCai+jBoBZbGzXQUAUmplxmqhj711eU4gpMW0faIzr99sp+?=
 =?us-ascii?Q?4LowItEC2n7cknFzaAN6WTN7PbW8aIYjsa/xAVaSKP/Fcodb3n5kKuYJk8yE?=
 =?us-ascii?Q?o5eTZWICOBXegvTppJ9Xa9EObxXf+xByshZnftUhfTLr6frdb0C8VH2bXbw6?=
 =?us-ascii?Q?KQgnBIXHDO9EwqDbMzLSLe03Ez4h3QSpL/TBmKdQjuR1jCmGCGi39onEykV+?=
 =?us-ascii?Q?sFHs6iDer+SFGZcCnqB1tJaOzXPrgRv70rFCuc2/6v1uO29LthKhyaAANsUe?=
 =?us-ascii?Q?ory66W5e4Q=3D=3D?=
X-Exchange-RoutingPolicyChecked: i4zSehp2cGyE/9XTjyMc0iNJhaGVwhqBTcEPF87fHLp/jQlIZ4iBjE9koRWmmApUbt00giHL2lQZP6n2W1woi/aUSwRY4BMkdcU37r6kFi/5WL0q5vbmKj0Snd45TGvh3+fr7r7vPVGUaW6Mun5yP4Yv8LPyc1qdjVF4Pyok2CC176i7Q+QSrmdn7jpC+/pXGScznipB1dBk0k/kmbd3PYEvNv7mscAMLlW8yXjvIPNvsM0/soPHg9vUF/Q9D8Wt0nmsWm+4gH3DpegDv6CjH7FT76fZyXmLqD+Wq6dBem4HLGoYHK3uTI7M7dYr0qElTq0XiFNuSUnxnoHI8OTJKQ==
X-MS-Exchange-CrossTenant-Network-Message-Id: 5618e017-2c11-4a84-4b18-08ded64e4685
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB7472.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2026 02:21:21.3458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lmB9Fjrp36SKpRzxKOQPH88BWUGNQEL3HOBO67Mgmf7SNoeOoyPUhCQMHLa5SAnAUa28cnfol6HacBqoUF5PPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5245
X-OriginatorOrg: intel.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8F16140002
X-Rspam-User: 
X-Stat-Signature: gd9f9f93fe9ewfmpgrtatpfr9owq5ros
X-HE-Tag: 1782786090-648786
X-HE-Meta: U2FsdGVkX18FPXaUVlxWwgkrh+5bNmr9TtEIwaULwP74ZPtvjvAoS6syp2rfgGKR4uo1jTep7F4RHSfiHQWnOpApzxeUKtwKATMX25NTM3EmuHz87BbGmwXU1E7dOvhJ0FBFmM1EaggGpL3FE6XWF7B2ZraIZT8epN5SVL+IGySMWB2TnmDHwoSEw6tU05LibptigzsjQfsPG7o7ZUbpNMKhISPaEmCHRp+zOYj2PQn02EOSmMW8tMKNNGJIKy4DzrJq1TaYP2CetEEw/96YdL4a18U3RB/thVeVRob5L1fBXAGwvebj2zHdWWX1OT7RjVjunQDj0kIqAT0V9twNjW1qpg+ffK3fI2ZOYz0/PpbETMIfE269FOj1oOwuVteiiMAtV/qb0BtGk6H4TdZXaCDgSipXBgLo9mosst7UxuWF1aCzL2wO/BpJ5x126cR7Iz/DAK2iwH9s0IaGBm6TKZJ6K7ttAtU89L4Q8RLxk4EpxGNYaky+XNjucihYoAuh8ZmPysS/vrG9c4IhxAMe3bMFfjULq3uf3BgZ95zpNr2antx/RbU1n9d3DGc+rjhbSHbp6tY9Ej6qHmWX0kTP30NBvemhUKWIQnAdV0+HbVVTMd+WV/ZsDKvBiD5BV1af/vD9bJjziMI6lVA15LQeMDf+sYSKZDREhFYNuLxrKPfAP4e1F+31ieda7aI1fIWVxkhqIT1CloQSvbu6PsvXdp3EWsjXiaKE6+WOA6rzAzU8sL8QsNC3Ow9w9b+Aac9WISzvG6dERTDylJ4wdpV9PyTn1gCHatbhMFA0/8K0+pyMrKmdX/xTyWTxXAiIHpxLAe8lzoUfiiv5BTlKnHDZrYMb8/1nuBuGgBdNYtKJnxbYXHnDoM+m6LD/414UrnI+ZwqamA6yOwirAaBOVT6X18Fr5SJS/qvnA/EWAaNNgo3j+7WqRWCMm56sFLO9StsC3CW1/Sgo8X5hTnKDfgq
 9efAbYiP
 Ma3GdE25lE/tbHfpxCMunXsMnMI1wqcWqaQ/JNnKqDC7pbsE8xSCzVFhwxFmqkN9MqhWRcfELXdQmCBus6OW6jJ2L1gwmMoi7gZmwZri+fzcex7Hi/dnhdmgcWHX12khFXgyopxOsR9HEtuDLm8rUPxOB/pVIeMG7Yz/rN4HnqCW4YfF45EagJL/DuIErgy+dSl9uiyrlF4TVfsNCON5fMwgr7Nb6kwvWEyGCOPz5rG5fAPH6gabBOBVGUnFq3aMjPYCyFGpQFy+r4j2zMnkoNooMBcLEjn/aGqL/zVqjNI9gHaRzdClHqaCyBOE5HBGZzxuMM8bzCtC37HWVIvl3ms3kl7T19eLhMLzbXqsPdlPtW/blAQ3fbgLHwnjNWBSthP73qBHec9CySwgbrea2tsYK5cDks/2WU3kIbOzRIxtYD1SVvB3aj7rEhhEcYUMlzkuxa2OyyaazOMi8KV8PPKAb21URaMf903qUBjJ9De83Lskr66Y7hk/8Rd0Bdnxe1oP7uKq5Z+8P1KoC+o6dHvdtmSKb64tg5zUOKpJpneN294q53sxfcIN7VGeQjxVMgKbKlmJA7hcR/UTqUiLHd1sVlh5bpOCVrkJxOhpLycVrK5/A33CKdup7hk10YLbGDHHIZvS9o5boh8Yr+wk4tD1c9NyJJ9eHejb0MpEyUxMRzzR6RlDZoYdMaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 08:35:49AM +0800, Sean Christopherson wrote:
> Gah, I thought I had sent this out this morning, long before Ackerley's response.
> But I got distracted by a meeting and forgot to get back to this... *sigh*
> 
> Sending what I already wrote, even though there's a lot of overlap with Ackerley's
> mail.
> 
> On Mon, Jun 29, 2026, Yan Zhao wrote:
> > On Fri, Jun 26, 2026 at 08:28:32AM -0700, Ackerley Tng wrote:
> > > Yan Zhao <yan.y.zhao@intel.com> writes:
> > > > But if a user configures 0 uaddr as valid, writes to it, and then passes 0 as
> > > > source_addr(not from gmem), I'm not sure if it's good for the kernel to silently
> > > > treat 0 uaddr as an identifier for in-place copy from the private PFN in gmem.
> > > >
> > > 
> > > I'd say the original uAPI perhaps just didn't document 0 as an
> > > unsupported uaddr. Given that commit 2a62345b3052 already merged, uAPI
> > > was perhaps accidentally changed and no customer complained, I think we
> > > can move forward with 0 as an invalid src_address? I wouldn't think
> > > anyone relies on 0 intentionally being a valid address.
> > > 
> > > I could document that, if it helps?
> > What about just documenting that 0 is an unsupported uaddr which will be
> > re-purposed as an indicator to use the target pfn as the source, regardless of
> > whether gmem_in_place_conversion is true? i.e.,
> > 
> > if (!src_page) 
> > 	src_page = pfn_to_page(pfn);
> 
> Because KVM can't generally use the target page as the source without in-place
> conversion, it's not supported today, and out-of-place conversion is being
> deprecated.
By "out-of-place conversion", do you mean using per-VM memory attribute
conversion?

> > I don't get why the two scenarios should be treated differently:
> > 1. gmem_in_place_conversion==true, shared memory is not from gmem 
> > 2. gmem_in_place_conversion==false, shared memory is not from gmem
> > 
> > In both case, a 0 uaddr could be mapped to a valid page not from gmem.
> 
> That's immaterial.  KVM's ABI (that we're solidifying) is that an address of '0'
> for the source means NULL.  The fact that userspace could have a valid mapping
> at virtual address '0' is irrelevant.
So, I'm wondering if we can document that 0 uaddr could always mean using target
PFN.
i.e., for both scenarios 1 and 2, al long as 0 uaddr is specified, we always
use target PFN as source for in-place add.

> Again, just because something is technically possible doesn't mean it needs to
> be supported by every piece of KVM's uAPI.
> 
> > So why not update the uAPI to handle both cases consistently? :)
> 
> Because retroactively adding support for out-of-place conversion is pointless
> (requires a userspace update for a feature that's being deprecated), KVM can't
> generally support using the source for out-of-place conversion (it's effectively
> an obscure zero-page optimization), and IMO rejecting the out-of-place conversion
> scenario is valuable for KVM developers, e.g. to help newcomers understand what
> exactly is and isn't possible.
Ok. You mean per-VM memory attribute is deprecating, and source page from !gmem
backend is also deprecating, so we don't want to change uAPI for scenarios under
gmem_in_place_conversion==false. Right?

> Side topic, isn't TDX broken if target page has already been added to the TD?
> IIUC, kvm_tdp_mmu_map_private_pfn() will be a glorified nop due to the page
> already having a valid S-EPT mapping, and so KVM will incorrectly allow a double
Not sure if my understand out-of-place conversion correctly.
Given target PFNs and GFNs are not duplicated, what would cause double add? :)

> add.  Ahhh, no, because KVM will return RET_PF_SPURIOUS and
> kvm_tdp_mmu_map_private_pfn() will then return -EIO.
My asking was if we could document uaddr always means using target PFN, since
TDX's in-place add does not rely on gmem in-place conversion.





