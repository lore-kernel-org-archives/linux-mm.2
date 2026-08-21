Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E55FC5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3D26B00A0; Fri, 21 Aug 2026 08:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AA766B00A1; Fri, 21 Aug 2026 08:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A796B00A2; Fri, 21 Aug 2026 08:34:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E88296B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:34:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 72A28120435
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:34:46 +0000 (UTC)
X-FDA: 85125220572.20.FD36130
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010045.outbound.protection.outlook.com [40.93.198.45])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5BCE71A000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:34:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ppDS4erd;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.45 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787315683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKgSjbXeNGA6rw0vEhHD4FSWYZ+7XBA6f1A4MuvcERg=;
	b=naHADIMEKcA3c0M9NQRCn4F2gY/WDA1IYsTKCLSdYQRXxdmgsolo/Mu7TNASh3cYPfStNS
	TeUM76MAusSKGV0XrOgYzjWo88bPzzuGKB6DJYqVqgyUhvwWBpoyjcBgpSC/l3mGir0Gji
	iNZR/fF+2qgMPSuUxTgaU84Viuz7J0o=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=ppDS4erd;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of shivankg@amd.com designates 40.93.198.45 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787315683;
	b=8imqAVRezsHNB9y7CrZAR9dlxrRXlJncnXNtV5KAxNGOXcFDgGgn/HNZf6iriHWPPVet1S
	IyLlMqukLQu9qQMBxpOQxt4OKcSOgjrbexmm7wSFmpkJfcMkJ3+iirz/Cie+vFQO8C3OA3
	cBGl5pO2o9jiz+2teQeIxia+nQXWJ78=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YrTDMikzj/L1VUVfMR+Cmx5AXIwUC7KaQGeVJ2l+NNp82+2LZGHecJXLM1XTOgwVXc+Sdms+V4TAdl85sidtRj3B1drn7OPzU7HzwADBmoNoNX46i9xDZsjUF7ngoW+T6xFzTo9g4HR3sDXrljLHTX7kGa1/U25h7rXTLHhOZmqKpX2Vuqw+pm8hRZtlXmHI4z2F2dNCeXDBFFMpXrbtvBKDq1rDZzaDv4plTCWX7jCc8Xf8cyCq891JtyqVSULRQ8e9Ux2JswaSAz8hcbnYf+p5dyx48EzrkmJuLQAxDD7cd/ccTc2ssVtbmRKDzHWbkec7+rnmZDc+AYUkU6ej8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yKgSjbXeNGA6rw0vEhHD4FSWYZ+7XBA6f1A4MuvcERg=;
 b=kfStPNkFRkCpnZFonzcxH3EFJdEXFlzZvuCB4mDPMRSnas2GfFol5BpRyr5E06cagft6EEuH8bVBgdN+iUrYLQ6eF/ewibePh8G4BOPxi1GAvNgq8jKLynzNJyoFGC7atJJ3mDyvhaFXI9MMJasNWlBlTXltKY6rHEjqwFJlV8MGIgZLgTlP2PWKgWayWI/D/pu8K3LcOs5rOETB6j1j05W7s+skauqdo7X85AD0mG4fcAlk/L5neM/XAHW0rmyQFXvC/uTJmQQ5picu/aLiKLxRVaRaYg7gjINffQ8eAJSVrLBFoYmiLDC7A3buidQkYEKWbsO6dpIeSnULsK5orw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yKgSjbXeNGA6rw0vEhHD4FSWYZ+7XBA6f1A4MuvcERg=;
 b=ppDS4erdqOGkCuyCwPXoIUjzIGRJbWAsG1iBTonFh0ZBHwU5sNnaTRVVEK4nmeoSZ2sh6BrsV6fDl9sk6eQJLtLmxMAo0yte3/wQ+Q1lnYYNNQmHt+r9bXRBAk/y3GRaYlId4McShj3oQlSat2sqSDlhfyitOFedvXVBu7ouHW4=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by DS0PR12MB8576.namprd12.prod.outlook.com (2603:10b6:8:165::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.339.8; Fri, 21 Aug
 2026 12:34:36 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0339.010; Fri, 21 Aug 2026
 12:34:36 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "Gupta, Pankaj" <Pankaj.Gupta@amd.com>, "Sampat, Pratik Rajesh"
	<PratikRajesh.Sampat@amd.com>, "nikita.kalyazin@linux.dev"
	<nikita.kalyazin@linux.dev>, "ying.huang@linux.alibaba.com"
	<ying.huang@linux.alibaba.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "joshua.hahnjy@gmail.com" <joshua.hahnjy@gmail.com>,
	"david@kernel.org" <david@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "jack@suse.cz" <jack@suse.cz>,
	"tglx@kernel.org" <tglx@kernel.org>, "Dadhania, Nikunj"
	<nikunj.dadhania@amd.com>, "Roth, Michael" <Michael.Roth@amd.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "mhocko@suse.com" <mhocko@suse.com>,
	"gourry@gourry.net" <gourry@gourry.net>, "iweiny@kernel.org"
	<iweiny@kernel.org>, "chao.p.peng@linux.intel.com"
	<chao.p.peng@linux.intel.com>, "byungchul@sk.com" <byungchul@sk.com>,
	"x86@kernel.org" <x86@kernel.org>, "bp@alien8.de" <bp@alien8.de>,
	"ricarkol@google.com" <ricarkol@google.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "Kalra, Ashish" <Ashish.Kalra@amd.com>,
	"willy@infradead.org" <willy@infradead.org>, "surenb@google.com"
	<surenb@google.com>, "pshier@google.com" <pshier@google.com>,
	"matthew.brost@intel.com" <matthew.brost@intel.com>, "fuad.tabba@linux.dev"
	<fuad.tabba@linux.dev>, "skhan@linuxfoundation.org"
	<skhan@linuxfoundation.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "rakie.kim@sk.com" <rakie.kim@sk.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "apopple@nvidia.com"
	<apopple@nvidia.com>, "ziy@nvidia.com" <ziy@nvidia.com>, "vbabka@kernel.org"
	<vbabka@kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"sashiko-bot@kernel.org" <sashiko-bot@kernel.org>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v3 0/9] KVM: guest_memfd: folio migration for
 non-confidential VMs
Thread-Topic: [PATCH v3 0/9] KVM: guest_memfd: folio migration for
 non-confidential VMs
Thread-Index: AQHdJKVsctSiOu4P3kmuA1se5lvKxraoiYwA
Date: Fri, 21 Aug 2026 12:34:36 +0000
Message-ID: <0a02a6c4f0ee50ca596c4a2673b2ae6c80d4569b.camel@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
In-Reply-To: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|DS0PR12MB8576:EE_
x-ms-office365-filtering-correlation-id: 728408c4-f02c-4c15-4464-08deff808f8c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|7416014|376014|23010399003|1800799024|366016|38070700021|921020|56012099006|10067099003|11063799006|18002099003|22082099003;
x-microsoft-antispam-message-info:
 aYRroITIYz+wHRnltUavyYpt6sY1Hb+5WZ9kX7UT9rufq+9FVwj3dHeMRdA90tdJEHsbFtwo/HRlxQxtmJLmplW9assUN4lwuUvqDxLhYmZlzuse3QE/uncZjqrwdQoQ+/FaGgvTe5QAxRo3b1cr/nWEZi9GGT0xpEEDVvoAwhHRsRcGBkcvOzZRbKifcPBItjDkHoD6tfo+J/35/Wa6IHoxz9QpUhEk+x1ohdxPcE4cRrBjaWo8ZRWKb6pNBQhhT1wt6ZXswTIFLlyjKde/rYm4/cO0T1+xsaC24EHcQ3tjsXVPlwmjFaeohWD1Z4kbVG+e0wjScbsFDQQrVTOo7l77tva6PrcoaGD4XKMoPc6otBSIrAQi4RA1FFvJCA0qkOqk68r3gv5CvJH8yahL9k3x50abReQvdfvAaSYAPzfmB2/SApljrVDOFVIt4Bw4zlSsQCvUXTXBqUhNlDhVtxstWDWgqu3saGbOBt4/amAFljrMBLGZkgRRCRpRGp2e+/kvwFvovcGYHg7kfOWbVzrHJbWE2XEL0CpCYojYb3rEn61E2rDbDW8569mWZReH1afQSTcuMHGcxeqJuWbLVafgNuDTyn8qIWTN7fbcKksS4VSikggoCa6J2aacJkqaYf2TnDoGc0Aj7vx/6lvjPvTHYdsmhhfV52JLUbrl9VlYzw/Q8PkivJlIQBUZuJq9
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(1800799024)(366016)(38070700021)(921020)(56012099006)(10067099003)(11063799006)(18002099003)(22082099003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?QjFjYXBXVHgrdVRMMzg0SStpYnV3VlpLbUdOSUNyMHlTQmNHMGRXTE5GSkZi?=
 =?utf-8?B?VU5aM1FaN1cydGs4cU5HcVMvVTNYcU9tS2pUN3pRdDdkVzZvNVVTTDhjd1R4?=
 =?utf-8?B?dVlSWGtZRmQxemhmbWpqQ1pIVWtHOXNKQnBzT0JIL1RZWXpxSmUrUWoralZn?=
 =?utf-8?B?RUJ3a0RkcStYYkprRkVoaWtKd0YrZVVYWGJHdzBNREpnTzVJTStSQVdsTUYy?=
 =?utf-8?B?eU9uV3pHdWdVSVZRck5EWVpuNXlXaUp3VTlzVjhhMk84azRsMkpVakxPdTV2?=
 =?utf-8?B?UWF6Y2IxcC9hWk5WZUp1YkVHcGxOREJ0UUhCTFEyK25IbXZrRnpxVFNuYTlE?=
 =?utf-8?B?UzFUZFA0b0FPVStMTTNrMXZGbi9sYUtMbzBxMUdHRXRlUWlIVmtsaFFjcTlB?=
 =?utf-8?B?MXY4bHpqMlZDZXB0aVJNOEVyVDI4MVZNanh2anNDbXNiSTQ3ckFiNWlKYlRj?=
 =?utf-8?B?REoyb0dVVVprbEZWdGpGUWdDTFg2RHp5M2FFTEk1bnFZQzZNUGhVNXd4VE1t?=
 =?utf-8?B?T2MwTjBrN2FTSi9YTG9JSGgzcnI3YXlSQnYwbWt1L3RGZkNFN1RUWmhFbWRj?=
 =?utf-8?B?TWwvVy9DSGFRRlE5Z1JXdmpOeFdZOG93K0ZBcE8xL2xReVViMDBXa2RkR2pF?=
 =?utf-8?B?REZjSVJxY0xaSmFqME5HNFU0THBHZW01Q1c1SjFUL3l3MmpMcXAyODB3M3Zo?=
 =?utf-8?B?TElTajZBNGJzdWRPTi9jRXJET21JaTQ0aTczWmh3S1YvOWZZcG8yQWt0aWxT?=
 =?utf-8?B?eU0yL0dUTVhJTzZCSTBQbEt2azN2aUxJQVpmVm0wR2QxTU9ySExGZ01za2RU?=
 =?utf-8?B?bWR1dWl1cW5TeGkrL0hXdjFrMjFpdnVQUFIzQm5YNFpwdjVmRzdKR3VkV3BY?=
 =?utf-8?B?U3lodDR6K05jbGJ6eGg2cU9YMjJOTEcyL1ZGVDNkV21yVkJkWWxvWHBQUkw1?=
 =?utf-8?B?T2krTGZsUXUzdFVBUVJlMHFzYmtqQk1GemFCVWRxb2x5QXJtM2JmV0pVR3o5?=
 =?utf-8?B?cFVBM1JPUlk4R2daeG9uY0FoYnBPVGUxeHBMdUlEc0J3N25uWUlKaGZnMHRq?=
 =?utf-8?B?WnNEK1o3dEFzUUo0dk90eXJrdk9ZRCtlVFM2R1BqM01LSERkTjZWU3licXI5?=
 =?utf-8?B?YUptU2V4Mm4rVVRRR1I1cmJXY2p3SUsvcUNJR24rVEJzZW5SLzFjWUZ6aEh6?=
 =?utf-8?B?aW1kWDBneEVHS0JhSXRSNmNreGRjVTIvSTJ4QlBnTjRhZFFuMWxPSEN5dldn?=
 =?utf-8?B?N1NlbEV6TkVydTZDMWVuOHExQ1d4NVJYb3RiUjJxMHBueDF6QjBNazRwenc3?=
 =?utf-8?B?VjMvMWdHU3MxWURYQ1RwUHZobFhIM3orbDd2UDJNK3UxVHFkeUZxMm11MFJV?=
 =?utf-8?B?Um9kVVI1aERhUUlVbHF2bkQ1QkZtYzh1TForMG9YVnBIRlAvSkFLSHVUSGZN?=
 =?utf-8?B?ZEdaL3BRamNUQU8vaVQ5cFhGZ0U5STQ1NXNoODVjaXorQVo3TitrQjBqTjUz?=
 =?utf-8?B?QWhydmNZME8xV1o3cWMvS0xyM0U3WFhIZGh3eGd0WWdZYzUvR3A3cDdRT2Er?=
 =?utf-8?B?Z3pFY3A0K05aRmtIN1VMQ2FKeDd6TVE4TzNlWmYrWVcwVlVXLy94cThTTlZY?=
 =?utf-8?B?Qlh1dzA0YmpQVzJmM3o0Ulc2d2hYdXU0ZS9MR2grZXJROTNWTWs1VHBnWWJl?=
 =?utf-8?B?T05NYWRaaDdQVXZWNzlmQ0UvbVNkc3BDbTB0RlNrN09LVUg4V2lwNXYvYzRt?=
 =?utf-8?B?UTNUaEhiaDBHcXhkMzhMVmRWbHN5NGxSMVNMK3pPVExVVGd5TWRZNHRxYzgw?=
 =?utf-8?B?MTVwdEZkbGVsU3c5VUFGWlFFYU5WeXRMZkdYSUFIWTlZOHVZa2pvc0trbEhU?=
 =?utf-8?B?TTB4aDl0ZDdHOVU2YzNkaEdWSGFpMEtCaU9nZm9RbFA3YytIL0R2VE9IRlBV?=
 =?utf-8?B?MlhEaEUzZWZ6dU1vNXRnNWJCMnVVNFhLUWhwakROenFEWDBpaHl4KzNLOVZY?=
 =?utf-8?B?S2hOUENjbzlpdWRkQzhRRm9ycjMwNXZEN2R5bUFqczk4RjFQcU5RaitHK1lt?=
 =?utf-8?B?NzRFdFE0dEpGV1NHTy9qUGJTRXdpRUZFVjlEanVYZUpBTWxlSDUyR1JwRVZn?=
 =?utf-8?B?K0FGSGU4bUh0RjdIcXJlL014WEtIOTU2RkNndGY5YWxpbUtsL1lRY2dFOERK?=
 =?utf-8?B?QUJnUHp1bWxKY3BERHdtVHhVVFZtdDU5Z1A4UVNIRTRoeUE0VE43WGdNZ1lP?=
 =?utf-8?B?NlJHSTZHYkNZQk9nK3pqdTBtYTJlRUxwVVh6Wk10Q0xibkk0WTAwbGU1aEdG?=
 =?utf-8?B?VGJ3Zkt1OThiZ09DcDA5ZzFBcjdyRHVoVlNBeGJxMU9yWDhhZHRFUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <56B1080A0234354CBB0627112FFCC072@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 728408c4-f02c-4c15-4464-08deff808f8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2026 12:34:36.2266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bCriQPxQvQh+Wuf2O5bP5fukGUWU92/C0B3rGHnQt8rm7abhWEZvJYYVBTZqkgo+EFWUu/ZY+Ye2vI+cMxsGYA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8576
X-Rspam-User: 
X-Rspamd-Queue-Id: 5BCE71A000C
X-Rspamd-Server: rspam07
X-Stat-Signature: j8f1uux9j49p8caowayhqz3c59p3yju4
X-HE-Tag: 1787315683-815569
X-HE-Meta: U2FsdGVkX1+RN44ciROpgWgOjd2Y1TAL13KQerMsbyrOTqPLQbXPA5Igc2nSzcRaheUCR1rmbL5q/xdf213l/xBBCUv8n3dHW1KPh3nRRcFy7s6Dcoc0w16WepYzfSOGb+Bc7lkw30uCmqHGkAVPgHtdQrmQO8cB/spwe+Iu4efTVrqUuYp8WFpArZLjDTBhzFMR9yLw57XEdGFPeWGT1xUDvDdjsASRePFSLsNy1soKwXjaKOJE5Xc/wPhiZjii5hiUBB0+zT3oaDaBghDXBNIvR3xnei0yWLqcprcxmLN5K/5rV2pCxpT6q60o3ccKDKGRLdGM/k0Y3A/+xrZ/4QfD+K1UJM0RDTMQqnwfcyBEZkS+CeyajtYWlx2JvInjg7r1YISR0PxDX5oOEnm+QtVH/9x+Z8rZI4BnY103wpGITBLvKlN63DzNYaV07rL1hNrgPklzu/zltil/fZYSwOzbR5l6ZXGJvnQ5geZuDRaztrNabWdl6hYBpUZCBW3PQY9ks7oafie5VZe7X5yOQZzBrv942ZTCRSE96XMulTykko5xzWKmJiucpLKJQCnINf1IKwRLYJzc8+WF4Tb8SvTW9pvEq5kVlRYL3vRIPAjqoWDk9/Fv3Bfk3OtbTnv83RMeKfW/42zoEs+aOjl6vVe6ZifQDkDvv/BJ+ag/a09+4mWqK68SfdlSgIHFn4e+7Y6l3Xr2RvJ3YyuSpB/F/O9LPKgm3WLgdyn0SL+3nQd0W1Vv7iflTOlGKcgGiFVPhWM+D1XTKrnitEZvBV4L5ZSHp95K1BZ4bSoBBLQx0sCZKyGzLIZXEG3B8X/o0r5wOKtFVb6A/l+MUx28Y2TOglJd2gifOca5oAH+fuoPiBz+xJRDBcEb57e+KSOpxhQuwaHb6Iap10N/k+UsEn68LWijQH55vN0sBI0VQli75zlm9Gwg3Co5qd2AOTZzNsU4ZCupziHpHiAXKsKWTDs
 uDGA4+R+
 HUOTxKH3LsTHvxMBluXADdULXedAa4U7iTBeEJKcxNibhMd38ykJgguHIY5avpOpWHxWXVcxESSazjUr5ypKVTbKDm2Y7bsuy5nbSUacdpJ6ketXX2QlEAV/AoTbCbY5jYiy9ZQA8GM01Tw1e2W8coMQbVFAXM42GpVgKcc59NJyuvcpmskxcm+xalUGo13+8IPCdG4xzBJozoveKcO9m/f7FPb/BxQtDJ26ZnRQBRTomeow6Sx8CCsWHwidvL4bCv7EPUS630rl5n+ozvh5wr56pcrdkIffB4QtlENc09lIIfcR7nfiDgrMkIt2XMqOeig2EB9ysPdkeSnZzGvqWck1R2lH9qvnYFqceX95fneqRZUGe35otUTCPmJ5feKv4KiAAb7ehXMY9DmRTTlvcU8uGY7LJjMf0c4jiGyLJ5tiKCcCWW+VMhwohA9Sh/e1rJUXzPtDaPo5fgm1Jp4YvFJTB8udmy5DDyZRKDtDCCbW1QnLBD5Ix25B/IiIFS8w3ohGuYJKKEISOK2AFB+e0/npIsvoaUvFxX2947RS6OuQ0kVNEgQFaYKuhvomhjvM5IKvNqRTc+1/+2j/o5Z2KgZ6aiczC5irHT+ljCB+ZzCH7D7NMnXwXziBzygnKPJrl0nzTqudowseDhWvONs68iaExtl5alV36z74A0H5twp+bJ63Atcj6pBnPU2U7eSbVO3b8oqphuxGBuc2Zl6C6B8mT9Jmr/KwmROy6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTA4LTA1IGF0IDA2OjQwICswMDAwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+
IGd1ZXN0X21lbWZkIGZvbGlvcyBhcmUgY3VycmVudGx5IGFsd2F5cyBtYXJrZWQgdW5tb3ZhYmxl
LCBzbyB0aGUga2VybmVsIGNhbm5vdA0KPiBwZXJmb3JtIG1lbW9yeSBjb21wYWN0aW9uLCBvZmZs
aW5pbmcsIGV0Yy4gVGhpcyBpcyB1bmF2b2lkYWJsZSBmb3INCj4gY29uZmlkZW50aWFsIFZNcyAo
U0VWLVNOUCwgVERYKSwgc2luY2UgbWVtb3J5IGlzIGVuY3J5cHRlZCBhbmQgY29weWluZyBpdA0K
PiBuZWVkcyBmaXJtd2FyZSBhc3Npc3RhbmNlLiBIb3dldmVyLCBmb3Igbm9uLWNvbmZpZGVudGlh
bCBWTXMgKGxpa2UNCj4gRmlyZWNyYWNrZXIpLCB3ZSBjYW4gbWlncmF0ZSB0aGUgZm9saW9zLg0K
PiANCj4gVGhpcyBzZXJpZXMgZW5hYmxlcyBmb2xpbyBtaWdyYXRpb24gZm9yIG5vbi1jb25maWRl
bnRpYWwgZ3Vlc3RfbWVtZmQgYW5kDQo+IGFsc28gbGF5cyB0aGUgZ3JvdW5kd29yayBmb3IgbWln
cmF0aW5nIGNvbmZpZGVudGlhbCBndWVzdF9tZW1mZCBsYXRlci4NCj4gT25jZSBmaXJtd2FyZS1h
c3Npc3RlZCBjb3B5aW5nIHN1cHBvcnQgaXMgYXZhaWxhYmxlLCB0aG9zZSBWTXMgY2FuIGJlDQo+
IG1hZGUgbW92YWJsZSwgdGhlIGNvbmZpZGVudGlhbCBmb2xpbyBjb250ZW50IGNhbiBiZSBjb3Bp
ZWQgc2VwYXJhdGVseSwNCj4gYW5kIHRoZSBkZXN0aW5hdGlvbiBmb2xpbyBtYXJrZWQgd2l0aCBG
T0xJT19DT05URU5UX0NPUElFRFs0XSBzbw0KPiBfX21pZ3JhdGVfZm9saW8oKSBza2lwcyB0aGUg
aG9zdC1zaWRlIGZvbGlvX21jX2NvcHkoKS4NCj4gDQo+IFRlc3RpbmcNCj4gLS0tLS0tLQ0KPiBI
b3N0OiA3LjItcmM2KyhjMjFiYjQxOTM4NikgKyB0aGlzLCBBTUQgRVBZQyBaRU4gMywgMiBOVU1B
IG5vZGVzDQo+IA0KPiAtIEtWTSBzZWxmdGVzdDogYWxsb2NhdGUgZm9saW9zIG9uIG5vZGUgMCwg
bWlncmF0ZSB0aGVtIHRvIG5vZGUgMSBhbmQNCj4gICBiYWNrIGFuZCB2ZXJpZnkgcmVzdWx0aW5n
IE5VTUEgbm9kZSBhbmQgdGhlIGZvbGlvIGNvbnRlbnRzIGF0IGVhY2gNCj4gICBzdGVwLg0KPiAN
Cj4gLSBGaXJlY3JhY2tlciBbMV06IGJvb3RlZCBhIG1pY3JvVk0gYmFja2VkIGJ5IGd1ZXN0X21l
bWZkLiBXaGlsZSB0aGUNCj4gICBndWVzdCB3YXMgcnVubmluZywgZm9yY2VkIGhvc3Qtc2lkZSBt
aWdyYXRpb24gb2YgaXRzIGZvbGlvcyB2aWENCj4gICBtaWdyYXRlcGFnZXMoOCkgYW5kIGV4cGxp
Y2l0IG1vdmVfcGFnZXMoMikgb2YgZ3Vlc3RfbWVtZmQNCj4gICBwYWdlcy4gVmVyaWZ5IHdpdGgg
L3Byb2MvZmlyZWNyYWNrZXJfcGlkL251bWFfbWFwcy4NCj4gDQo+IE5vdGVzDQo+IC0tLS0tDQo+
IC0gU2FzaGlrbyBwb2ludGVkIG91dCBhIHByZS1leGlzdGluZyBBQkJBIGRlYWRsb2NrIGJldHdl
ZW4NCj4gICBrdm1fZ21lbV9lcnJvcl9mb2xpbygpIGFuZCB0cnVuY2F0aW9uLiBJdCdzIGJlaW5n
IGFkZHJlc3NlZCBzZXBhcmF0ZWx5DQo+ICAgYnkgSGFvIFpoYW5nLiBbMl1bM10NCj4gDQo+IFsx
XSBodHRwczovL2dpdGh1Yi5jb20vZmlyZWNyYWNrZXItbWljcm92bS9maXJlY3JhY2tlci90cmVl
L2ZlYXR1cmUvc2VjcmV0LWhpZGluZw0KPiAgICAgSW4gYnVpbGRlci5ycywgYWRkIEdVRVNUX01F
TUZEX0ZMQUdfTUlHUkFUQUJMRSB0byBiaXQtMiBhbmQgcGFzcyBpdCBpbnN0ZWFkDQo+ICAgICBv
ZiBHVUVTVF9NRU1GRF9GTEFHX05PX0RJUkVDVF9NQVAgdG8gdm0uY3JlYXRlX2d1ZXN0X21lbWZk
KCkuDQo+IFsyXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvYW1iRWRTUGplclpJVk4wYkAx
OTIuMTY4LjEuMjE1Lw0KPiBbM10gaHR0cHM6Ly9zYXNoaWtvLmRldi8jL3BhdGNoc2V0LzIwMjYw
NjExLXNoaXZhbmstZ21lbS1taWdyYXRlLXYxLTAtMmQyNjZiZmM2Zjk1JTQwYW1kLmNvbQ0KPiBb
NF0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjYwNjMwLXNoaXZhbmstYmF0Y2gtbWln
cmF0ZS1vZmZsb2FkLXY2LTEtZGE5NWQ3ZThiOGEyQGFtZC5jb20NCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFNoaXZhbmsgR2FyZyA8c2hpdmFua2dAYW1kLmNvbT4NCj4gLS0tDQo+IENoYW5nZXMgaW4g
djM6DQo+IC0gRml4IHVuYmFsYW5jZWQgbW11X2ludmFsaWRhdGVfaW5fcHJvZ3Jlc3MgY291bnQg
dW5iaW5kaW5nIGR5aW5nIGd1ZXN0X21lbWZkLiAoU2FzaGlrbykNCj4gLSBGaXggbWF4bm9kZSBo
YW5kbGluZyBpbiB4YXBpY19pcGlfdGVzdCBzZWxmdGVzdC4NCj4gLSBBZGQgR1VFU1RfTUVNRkRf
RkxBR19NSUdSQVRBQkxFIGRvY3VtZW50YXRpb24NCj4gLSBSZXBsYWNlIG9wZW4tY29kZWQgc2l6
ZW9mKCkgKiA4IGNhbGN1bGF0aW9uIHdpdGggQklUU19QRVJfVFlQRSgpDQo+IC0gQWRkIGdldF9u
dW1hX21lbV9ub2RlcygpIGFuZCB1c2UgIE1QT0xfRl9NRU1TX0FMTE9XRUQgZm9yIGFsbG93ZWQg
TlVNQSBuZG9lcw0KPiAgIGluc3RlYWQgb2YgaGFyZGNvZGVkIE5VTUEgbm9kZSBJRHMuIChTYXNo
aWtvKQ0KPiAtIEV4dGVuZCBtaWdyYXRpb24gc2VsZnRlc3QgdG8gdmVyaWZ5IHJlamVjdGlvbiB3
aXRob3V0IE1JR1JBVEFCTEUgZmxhZyBhbmQNCj4gICBtb3ZlIHJlcGVhdGVkIGNoZWNrcyBpbnRv
IGNvbW1vbiBoZWxwZXJzLg0KPiAtIERyb3AgUkZDIHRhZy4NCj4gLSBMaW5rIHRvIHYyOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9yLzIwMjYwNzI4LXNoaXZhbmstZ21lbS1taWdyYXRlLXYyLTAt
MjY5YWMxZjg0ZTJiQGFtZC5jb20NCj4gDQo+IENoYW5nZXMgaW4gdjI6DQo+IC0gTWFrZSBmb2xp
byBtaWdyYXRpb24gb3B0LWluIHRocm91Z2ggR1VFU1RfTUVNRkRfRkxBR19NSUdSQVRBQkxFLA0K
PiAgIHByZXNlcnZpbmcgdW5tb3ZhYmxlIGJlaGF2aW9yIGlmIHVzZXJzcGFjZSBkb24ndCBleHBs
aWN0bHkgYXNrLiAoQWxleGFuZHJ1LCBEYXZpZCwgU2VhbikNCj4gLSBBZGQga3ZtX2FyY2hfc3Vw
cG9ydHNfZ21lbV9taWdyYXRpb24oKSBzbyBhcmNoIGNhbiBjb250cm9sIHdoZXRoZXINCj4gICBH
VUVTVF9NRU1GRF9GTEFHX01JR1JBVEFCTEUgaXMgYWR2ZXJ0aXNlZC4NCj4gLSBBbGxvY2F0ZSBt
b3ZhYmxlIGZvbGlvcyB3aXRoIEdGUF9ISUdIVVNFUl9NT1ZBQkxFLiAoRGF2aWQpDQo+IC0gS2Vl
cCBndWVzdF9tZW1mZCB1bmV2aWN0YWJsZS4gKERhdmlkLCBTYXNoaWtvLCBTZWFuKQ0KPiAtIFNw
bGl0IG1pZ3JhdGVfZm9saW8oKSBpbXBsZW1lbnRhdGlvbiBhbmQgZW5hYmxlbWVudCBhcyBzZXBh
cmF0ZSBwYXRjaGVzLg0KPiAtIFVwZGF0ZSBzZWxmdGVzdCB3aXRoIG5ldyBmbGFnLg0KPiAtIExp
bmsgdG8gdjE6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyNjA2MTEtc2hpdmFuay1nbWVt
LW1pZ3JhdGUtdjEtMC0yZDI2NmJmYzZmOTVAYW1kLmNvbQ0KPiANCj4gLS0tDQo+IFNoaXZhbmsg
R2FyZyAoOSk6DQo+ICAgICAgIEtWTTogZ3Vlc3RfbWVtZmQ6IHRha2UgdGhlIGludmFsaWRhdGUg
bG9jayB3aGVuIHVuYmluZGluZyBhIGR5aW5nIGZpbGUNCj4gICAgICAgbW06IHNwbGl0IEFTX1VO
TU9WQUJMRSBiYWNrIG91dCBvZiBBU19JTkFDQ0VTU0lCTEUNCj4gICAgICAgS1ZNOiBndWVzdF9t
ZW1mZDogaW1wbGVtZW50IGZvbGlvIG1pZ3JhdGlvbiBmb3Igbm9uLWNvbmZpZGVudGlhbCBWTXMN
Cj4gICAgICAgS1ZNOiBndWVzdF9tZW1mZDogYWRkIEdVRVNUX01FTUZEX0ZMQUdfTUlHUkFUQUJM
RQ0KPiAgICAgICBLVk06IHNlbGZ0ZXN0czogZml4IG1heG5vZGUgYXJndW1lbnRzIGluIHhhcGlj
X2lwaV90ZXN0DQo+ICAgICAgIEtWTTogc2VsZnRlc3RzOiB1c2UgQklUU19QRVJfVFlQRSgpIGZv
ciBOVU1BIG1hc2tzDQo+ICAgICAgIEtWTTogc2VsZnRlc3RzOiBhZGQgZ2V0X251bWFfbWVtX25v
ZGVzKCkNCj4gICAgICAgS1ZNOiBzZWxmdGVzdHM6IHVzZSBhbGxvd2VkIE5VTUEgbm9kZXMgaW4g
Z3Vlc3RfbWVtZmRfdGVzdA0KPiAgICAgICBLVk06IHNlbGZ0ZXN0czogZXhlcmNpc2UgZ3Vlc3Rf
bWVtZmQgZm9saW8gbWlncmF0aW9uDQo+IA0KPiANCg0KU2hvdWxkIEkgc3BpbiB0aGUgaW5kZXBl
bmRlbnQgcGF0Y2hlcyBvdXQgb2YgdGhpcyBzZXJpZXMgZm9yIG5leHQgY3ljbGU/DQpQYXRjaCAx
IGlzIFNhc2hpa28gcmVwb3J0ZWQgZml4IGFuZCBwYXRjaGVzIDUtOCBhcmUgc2VsZnRlc3QgZml4
ZXMgYW5kDQpjbGVhbnVwcy4gTWlncmF0aW9uIHBhdGNoZXMgY2FuIHdhaXQgdW50aWwgaXRzIHNl
dHRpbmcgZGVzaWduIGRpc2N1c3Npb24NCmlzIHNldHRsZWQuDQoNClRoYW5rcywNClNoaXZhbmsN
Cg==

