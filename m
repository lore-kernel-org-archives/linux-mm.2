Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2D2CC88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 13:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0CFB6B008A; Fri, 11 Sep 2026 09:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BDF06B008C; Fri, 11 Sep 2026 09:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8851D6B0092; Fri, 11 Sep 2026 09:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 637946B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:22:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92A60120201
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:22:42 +0000 (UTC)
X-FDA: 85201546164.10.2707214
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011069.outbound.protection.outlook.com [52.101.52.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 694341C000A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 13:22:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3Zy4Nz0H;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789132959;
	b=6wxAgCskTam9cArhH9fV5PpX4fe73DPxpYtPnChRzfcuavu+zkx0xiCLjcYRf2ah2hPMVO
	4Ee7cWgMFlsCXPJU6aY6Byt1i4xIEfRyFaBc4gDjdp/KKx/LNAOt2Ay8in36SSUBnjbpmg
	3MEYBFtd/XRo9Z2paURxW8NxqNPoHL4=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=3Zy4Nz0H;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	spf=pass (imf21.hostedemail.com: domain of shivankg@amd.com designates 52.101.52.69 as permitted sender) smtp.mailfrom=shivankg@amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789132959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uxjm5GzSOOuqpaMxqoJLkhQp6E7xr79gBCVz50z/Fd4=;
	b=hnwwxdvmER0z4APKmKjTLV1yG9BKTLFjsvzwFXpKdduT2KxNL7SWtBqKy7MzLum7dkuNsP
	TfNVUYcuo7LrBDK9BPkavrjSdVbC8V6bjfbhhDKr0vqj3bO10Y1IfmjoC6ZG6kjn2IdppT
	MCQ8uqId/z1raspzIWsdlQvy2HNx8ng=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iZ6a1D2CAPMpsCpD8MO40PlgDcO6oSzoAtfE53lVBsf1p94rrJL8L+HQF0RpB426FWy/KvhtK2ZtcDxqJs1oXeahSf27SnYGzVb24mVAPmEawLoptzQQYUtgiQ1AKlxwO51etBiAveyHyj54W3ERgktFcsggj3bKCORFPAdx9U3yNLwVElbGrPGagahfXXLxCW0Pf54M5IJOYVkjTO4e+rTQMjuf7tDLre6DzjuJ2oDu59pEqN4I6/IhDrOs54aEy0Y/MUcvlkUsO4KvwT1DkyL0VqqHSy1TJAXPpk2vnfCCgI1cR0mjBMxPYVHh7+exj9QpHHByl+N8phbhZZHtfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Uxjm5GzSOOuqpaMxqoJLkhQp6E7xr79gBCVz50z/Fd4=;
 b=n5xSMxbIg/ulpPkecw53fW/pXPVpmzmewrRIilj+lJf+2dZXV+lHLgTSJ59Ejnst83LQCqdfflbnNzPqjHj2VUS80ZlEEc2nIVRksM2YTcgP4IXZDjVgEFPffm4cJwMooEgrb4tNwLAab3jeh/IfdE4Mr5wQOKMpPzk5Tjd+Wey6qGokTT2f1bzL/1LdhPvXfpFDwB93r4iXNkAlZKi09JNj0xqI/RettQ41eTbWh/BSN1RcaqykIF53PVA1JLeMOUn5jjWpKM8DDTnc6ZYauoeLWR1M4bk3R84Lp+Xm8xhj0BYzCNw8VaVdBqbRVH4UsiPmNcBiB4nMPX60Qzj2Yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uxjm5GzSOOuqpaMxqoJLkhQp6E7xr79gBCVz50z/Fd4=;
 b=3Zy4Nz0HWJk0qLXt0qCR/Gfy1OVAhxyQMNTDltxlgU0//4jkMbtgtLekYcaymLeNpQ49wz7TQuWSGzwhp53RcI55EtCN0/tGt08kADpSL+UFSdaUQiEOrclPfZaWoTfmoRfL4zyj8wo2BPypR4KEO+aahiY1rst3NAswfQ3Ih7Y=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by CY5PR12MB6348.namprd12.prod.outlook.com (2603:10b6:930:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.10; Fri, 11 Sep
 2026 13:22:31 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0406.005; Fri, 11 Sep 2026
 13:22:31 +0000
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
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 2/9] mm: split AS_UNMOVABLE back out of AS_INACCESSIBLE
Thread-Topic: [PATCH v3 2/9] mm: split AS_UNMOVABLE back out of
 AS_INACCESSIBLE
Thread-Index: AQHdJKV4LwQ7dSCl906exVUG+A92dLbHzfUAgAHJ8IA=
Date: Fri, 11 Sep 2026 13:22:30 +0000
Message-ID: <40e6e4af230cf5dc6e6937d785ee507378482602.camel@amd.com>
References: <20260805-shivank-gmem-migrate-v3-0-00d8bdec4e1d@amd.com>
	 <20260805-shivank-gmem-migrate-v3-2-00d8bdec4e1d@amd.com>
	 <8fa1b403-99b0-4508-b705-f9e93c6bf0c8@kernel.org>
In-Reply-To: <8fa1b403-99b0-4508-b705-f9e93c6bf0c8@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|CY5PR12MB6348:EE_
x-ms-office365-filtering-correlation-id: b31c474f-42bb-4bde-cb66-08df1007bbb8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|23010399003|366016|7416014|376014|1800799024|10067099003|11063799006|4143699003|18002099003|22082099003|56012099006|921020|38070700021;
x-microsoft-antispam-message-info:
 amkPZNX3FX6INvYZC9o1yYUgXYJaT6elLvYHy3eUz3zLNqKNN3hlh//p8rwqXwPYCTitUyM18tKkxizj8XdcSjog5vprQRZ58OlfDuf7vMxJ9s+GoeIAPjvUdOXjvSl8uuU9SQagirJM808K1UrDqRIvh7/k/HtCkq/w6oLuI2GNS2FYHW2TcZixW8bKyUpgy0evaFVnlTnvAtw3zPQkqr7hj1XEDPNxR9MYe3gWbesWsojSs/IDgbUya7RIPQs2ZIxMjcZgFPXH9kAZokXVgSq1p+dT1uCeJMbz7CJRlUCzL21FmrnqJfopbif4AqxPk3DwslpCH4IXtW3ADuhkERsy6332bniefksBvnv8Wiw4XmKC+JOnP6WG1KuDmwGE0HjVw9ChFP67gKNjkoNVs1j4UXKZAmoiEtsJxBudzq9kB0V0AXPWzUjcwBDAAH50x9e8oDr8PlGLOolCFaUfnjlQYKTIzjoA/o8cldT8YZtcKQNRDd3j4aLQdCSiED3Op+NiL3UVB57TNJp1GraEgZeDnh1N8hEpR7UAqBi/F2XOhlNOovzzoAMt5J2rxHDfam0TZ8guqx+PpZZVIMa0FWkjc11rbOVXTz09KVby3VaBY3wR7rhntYtjQlJCgG4UidpoNx6TCLI7wQ0FgnFeNCJlihMs35BE4hai3FOg66TTKNp+KVoc0agCCi49JGwi5BqqkgCCfsdDfLE3f9aAagTMOkGccxs61ANakfNH8XdliRxg8wlsGKBqHovsnbE9
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(7416014)(376014)(1800799024)(10067099003)(11063799006)(4143699003)(18002099003)(22082099003)(56012099006)(921020)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OUV2T3dVNFNGQnhmaENjajZtVTNGaTcxU2NVZmxvNGlYVTVNMTh2bjZYWnNP?=
 =?utf-8?B?L3hXZXQ1YzBQZjY5YmJDNHY2VTJ1cC9KbW5JODkvTHpQQzJHaEN2WllFcmgv?=
 =?utf-8?B?Szc4NXg5Z25wQ0JwaWp5eHFVVGI3QkNpb1F3QnFKbDVWS0lSL2FLMGltNlVR?=
 =?utf-8?B?VE1Ua0lEaFU2SXkwaWRabE9rdkQxRWJUYWlUVS9mMEJWVDJvMFdnSnl6S0lo?=
 =?utf-8?B?V25PRS96SVgwQVV1cTg2RWRaNkQ3RzlIeEo2OXNrUFhnWk15akF6K3M4MDhG?=
 =?utf-8?B?eEl2K0FtUTZqd0JnYUJxbnBDUUROa0ZmTHk5YitCMGkwTExKRnpjalNZU2Mw?=
 =?utf-8?B?SlRuTVV4ZitOc09XME5jSm1BVklMUlhpd3dUR01IV0wwYVpySmtHdGxVY0FV?=
 =?utf-8?B?SlZUL2NYTytDZExjUXl0eGJlNUZSbU96WVBlQlh5MVhYOXdjb2lwKzJYRkxS?=
 =?utf-8?B?ZENFZjhBeVE3UklJVm5Wd3Q2TVMwKy9KYlVFVzI2ZEFSZmVtYkJMQ2Nid08z?=
 =?utf-8?B?emJ6WGlTaXFHbzMwVDY5STVESHJsbWxlVWQvZmk3VzRwNTRjbjZ1bmI3aEdQ?=
 =?utf-8?B?SjhLOTJzWGlRWUwzUWN2MGdLc21xM3dXc2pZSFBkT1hXS0plYTU3ZzA0bGlx?=
 =?utf-8?B?cWIxczErSU1aK3NYUkswRDlrYStON0JxczErYUx3S21KY0VpazF3Z0xncDJ1?=
 =?utf-8?B?cjFqK3RZWHpsWEp6VTFjbW9IS2UxRWlqSmJPQXpGdU9nYXhiYnJOcHZlSVc5?=
 =?utf-8?B?L1hoZGF0VlhLWGdaWDBLcG1WSDk5Tk83emM0VkF5bnc0RzZVbDRIb1h1SnUz?=
 =?utf-8?B?YmRQaDNxTjJXVDRaK2FYcklLNUlGQlZWT3o5Z2xPcDUxWVBoSm5PSUd0KzZR?=
 =?utf-8?B?RHVkNTVTSEt4djlZamVaZklsZlVUNlZUN0ZleDk5czluakt1ZmFLY1pvZDBQ?=
 =?utf-8?B?WFdVckpHS29wRW1UcmQya1FqUEZBLzNaTTJuUHBZZThxNHhYRG84NURoT3VI?=
 =?utf-8?B?MmRlc2dEei9CdVZCMXMyTUdsYzdoUmZlYm4xS3ZPWjNIbXZnT091dXJKMm1l?=
 =?utf-8?B?Y3R4ZVVxZlZ0amlScjNYOTM1ZTl0L0FtY2JQbDRQTUZJcXFlcU5JbUF6ejcw?=
 =?utf-8?B?azJsNXQyNEtiZ0JaODBGQ2QrL3g4eGZYNFVBTTRzaThyLzlhK3RuYm5nSysv?=
 =?utf-8?B?YXJsR0JqTys4WUx5Z1hWWGRwWHJPR3JWN1kyWE8wYnNzRXMxbDB0c2hPbVZn?=
 =?utf-8?B?TkltRjJLMEJMa3NhV01yaXFzZE5SbzFKUG44Q2t3UWNuVnhOQkhrQW1PcjBD?=
 =?utf-8?B?Q01oSzBadnBrMGNPQy9ESnl3OWdnb1V2V2s2OHlJR0xZNWJQMC95OHhlb1NQ?=
 =?utf-8?B?NnVEWitGdGJZUEV1K1hLbHczZENTU0hVSnNPcWRwUW1BcStIR2dWV3NPMWRY?=
 =?utf-8?B?VDcxL1JraWVVT2VUdHBXVE1MRnZxdDZlNGR1UEhuUllmT0dJYjIxeC9lbXB4?=
 =?utf-8?B?Sy8zTk1YTTlLZVdaalNHTStZODkrY2puOWxnOVBhZk5Sc25KMGdwVnY4L3VK?=
 =?utf-8?B?YjhIVlBkdlArblU4VHdtZ1owbnJzRUNZbjIzVS9kVWZjL0NLQmlQSkJyMzV6?=
 =?utf-8?B?QXdiSjAwVy9rVk5jZEJRelFBcWs0T0diUjlZREZUSEFBSTVjMmJ0TWRXZjVX?=
 =?utf-8?B?eFVoT3c1OFAzNVYzU0I3Y3d3cEFIZWtMSGlVdEFXNlR1enY1bU0wMXRlTHlx?=
 =?utf-8?B?SUdiWjJrQ3FuSEx4NGszR090M2p5dXhhWEk5UVpTTFpvRkVhNUtmSThFNit4?=
 =?utf-8?B?R0dQTStKS3NrVkVReXVVSUlBQTBjcVFNcWxPZlBpTjRQWktxOURmRnUwTjJu?=
 =?utf-8?B?eDQ1d3RyZm5vTHNUbGJMTURKNVV1OHRFZlNIcFZQL3pmMGRYR1NsaTV5cmhL?=
 =?utf-8?B?ZGZGN2d2NEgwa1YwNDlFRXR2M1hkUGV4c01HekJYbnErUUdoZWsrZHVXNFJV?=
 =?utf-8?B?QjBESndEUlRKbnpCZXB0VHFOSDIwL3RTT0ovODI4QThEckZnVmw1L1BnYzcy?=
 =?utf-8?B?S00yTVd5d1dscDlVR0puVU5HQzl2Y0VmQ1hXM0NJamg2Sjc5RytnVnRUa0VP?=
 =?utf-8?B?ZjZsOCtEYnozV2xUWm4yUDU3dU9Vb1E2WlZHWVRRSjgyUlFRUFBKdGFleW9Z?=
 =?utf-8?B?SHIrYUFDcTBUdXkxZmh3M21MTk5zWkVVdDZHaHl4K0hRVk9rVzFnMktPNE1t?=
 =?utf-8?B?VTlaQkpHSmVpVS9TY2NFdHBuOFhhNUEzNnlIQ29YaU9LWk9SZTRUend5OHBS?=
 =?utf-8?B?bXprWk94MktvMnZYQlZpLzdiWlNYUlEyU1FiMk14c1IrblRjRC81dz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <77869D26A535E9448384A3B33EE3EBA5@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b31c474f-42bb-4bde-cb66-08df1007bbb8
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2026 13:22:30.9545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gjEiNjucNebvisoHiTE5ipmAwVimTVBQBDO6nysaqSbCufjxRh3NbM6HJqBL4qE0zokCyjGgY8/WPIyuPDGXDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6348
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 694341C000A
X-Stat-Signature: nsteo3gazjyci3474f8zqjhf9yt9is5z
X-HE-Tag: 1789132959-284451
X-HE-Meta: U2FsdGVkX19WlNMBYyPzA/43FkLBkyEkKsRP4qm0UWBh9Y64sHQqCfUQIuhZ5XFb1hTOlYFwsjQVPjriJWhocSCz7eE+NY4Zj4H/oCVoOnxoM0hg16ocZop3928QXo/qud/xW82ncoSh/AObGfWnBdNdHglJdleO3lkaXrH5h0Qhd6RMMrjotAdHvYzb3CwMUYsRow5qkxSoB/AsRdnaVRwNPj/2v52K2ZJySEW+D4ngvIRvdzifNsNt2bdLxhzrRWP+GxqJgblieHn+kiIHee5nHQwcWTv0OrrYYJr/Q15ctNp5/+O7v5/qtPqkCobig1X5gsNGdMtbNcXCZU2j0nkJD7yXddR6qRgnpK3Q2RebYHYz6t9NoCC7EkEbAwxV4d90Sr+4lGPfgrxWMzTKX4Q8fa0fM8WhHYWS2VKpYJVXCCoe32a6MeY4eD+nVyVa6etlTw+rHuM13tYPcKKdPRSWlNTT8U/Oo7WHd7RFcG68RgED9/q8V6rzDEnGM1vy5yauVIdiZw2bv5Hq9wlOq2mG9i7c2T52Zvl8gsPatd4hSEVvSy6VCJRpiKRXTwP0n9Gal8vo22yZHaIzf6Wdi+/ggrj624pwi2sHYXRIX78Ww5H6oir8g2+BJ7tbQz5hGvim4CiNxs0v2fEn9GkM4r/nSdY8kHntlUzFs0RbveRpWM4VIIr13Y+H/CAJ+MTR/LbEhcmyVEXrEmvXkH7B4CSrgDspZbKiu3MMVev0ApGf/BRjhDTiQ/5roJ1Tt8n7QKCjgjrskP0CTKWWMKaRY8mpYiWI6IQkQjGYROURYY5z7bbgd5n9B3iWX1PdP7SNZKpLWFsOn+1lwRO5gFt1PYZkIFpE3gufH9cOMo1o1P6AmtEVLyJ6R88gs49Nr8vhGzf94k4efKAPsOE/jtrSjjZUcYyLgo3oIUypQF+VLaM6cAJtvcQh8l2Jgc7Qo+U4jSCFDHq3EpAKxAPKzno
 Tzn1/fjn
 HbztXl60LrAqHDHXe+htG6eTzCDrbB/s0ggHF2y0RN73PFnVKVuKbkdSwh46yJN6x2Ys5M3JOFUzx13uM+jKPDCXiRixB8hAjgqAJQBAqt/KaloKXciw3TaLdgTcN7GpUObg/eS0CLR7vzfhflC69JghoexB6Id4nAzBWhOw/Jixb9AoMvZk2doogLrT9XkZKFoirvxihquKH7WAeq/Kq8gi3vzXOHqzUW/nKAJo0gFj1s/iVXi+27d7qXZ89HP6uFLD4Li+TL/hzBLlRz3Oxr0WKiXl19GEQgAlpeUTh1l5SKIH/e/l/JyCaYS3C2IMmGr6heDN4+uFUsY8rPshwOG/Qv2JHuXC34zXun3Bb6lBb3RhDY0pPMsXhBdY3kL6v2PqVoLykeh0XAH8fT32qjCd/EKrpojEJNuyhHY9C3dBwPup51qGZ8unVu8eOBszD6bllVqIy31inyQl3ZxckkUTNy3lPJSs3v8RO/WDwPKMvBPYo7/94rP4mGVnjKEnTukxHrQV4Nao8JXLVYrXdxpQCWMWuBcH8ceyOFG2iMEgyYXH8ar79c7UdqNMX3d/yXTTqIM8NITCBT4uftjbjxIlBjLn7gKgXrxwzJLtI8Ir1a7Trn2hW5x0ocQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gVGh1LCAyMDI2LTA5LTEwIGF0IDEyOjAzICswMjAwLCBEYXZpZCBIaWxkZW5icmFuZCAoQXJt
KSB3cm90ZToNCj4gT24gOC81LzI2IDA4OjQwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+ID4gQ29t
bWl0IDI3ZTZhMjRhNGNmMyAoIm1tLCB2aXJ0OiBtZXJnZSBBU19VTk1PVkFCTEUgYW5kIEFTX0lO
QUNDRVNTSUJMRSIpDQo+ID4gZm9sZGVkIHRoZSB0d28gZmxhZ3MgaW50byBvbmUsIG9uIHRoZSBn
cm91bmRzIHRoYXQgZ3Vlc3RfbWVtZmQgd2FzIHRoZQ0KPiA+IG9ubHkgdXNlciBhbmQgYWx3YXlz
IHNldCBib3RoLiBCdXQgdGhlIHR3byBmbGFncyB3ZXJlIGFkZGVkIGZvcg0KPiA+IGRpZmZlcmVu
dCByZWFzb25zIGFuZCBndWFyZCBkaWZmZXJlbnQgdGhpbmdzOg0KPiA+IA0KPiA+ICAgQVNfVU5N
T1ZBQkxFICgwMDAzZTJhNDE0NjgpIG1hcmtzIGEgbWFwcGluZyB3aG9zZSBmb2xpb3MgY2Fubm90
IGJlDQo+ID4gICBtaWdyYXRlZC4NCj4gPiANCj4gPiAgIEFTX0lOQUNDRVNTSUJMRSAoYzcyY2Vh
ZmJkMTJjKSBtYXJrcyBhIG1hcHBpbmcgd2hvc2UgY29udGVudHMgbXVzdA0KPiA+ICAgbm90IGJl
IGRpcmVjdGx5IFIvVyBhY2Nlc3NlZC4gSXRzIG9ubHkgam9iIGlzIHRvIHN0b3ANCj4gPiAgIHRy
dW5jYXRlX2lub2RlX3BhcnRpYWxfZm9saW8oKSBmcm9tIHplcm9pbmcgdGhlIGZvbGlvLg0KPiA+
IA0KPiA+IFRoZSBtZXJnZSBhc3N1bWVkIHVubW92YWJsZSBhbmQgaW5hY2Nlc3NpYmxlIHdlcmUg
dGhlIHNhbWUgdGhpbmcuDQo+ID4gVGhpcyBjYW5ub3QgZXhwcmVzcyBhIG1hcHBpbmcgdGhhdCBp
cyBpbmFjY2Vzc2libGUgeWV0IHN0aWxsIG1vdmFibGUsDQo+ID4gd2hpY2ggaXMgZXhhY3RseSB3
aGF0IGd1ZXN0X21lbWZkIHdhbnRzLg0KPiA+IA0KPiA+IFJlaW50cm9kdWNlIEFTX1VOTU9WQUJM
RSBhbmQgcmVzdG9yZSB0aGUgb3JpZ2luYWwgc3BsaXQ6IHRydW5jYXRlIGtlZXBzDQo+ID4gY2hl
Y2tpbmcgQVNfSU5BQ0NFU1NJQkxFLCB3aGlsZSBtaWdyYXRpb24gYW5kIGNvbXBhY3Rpb24gZ28g
YmFjayB0bw0KPiA+IGNoZWNraW5nIEFTX1VOTU9WQUJMRS4NCj4gPiANCj4gPiBDdXJyZW50bHkg
Z3Vlc3RfbWVtZmQgc2V0cyBib3RoLCBzbyB0aGUgcmVzdWx0aW5nIGZsYWdzIGFuZCBiZWhhdmlv
dXINCj4gPiBhcmUgdW5jaGFuZ2VkLiBQcmVwYXJhdG9yeSBjaGFuZ2UgdG8gc3VwcG9ydCBmb2xp
byBtaWdyYXRpb24gZm9yDQo+ID4gbm9uLWNvbmZpZGVudGlhbCBndWVzdF9tZW1mZCBWTXMuDQo+
ID4gDQo+ID4gU2lnbmVkLW9mZi1ieTogU2hpdmFuayBHYXJnIDxzaGl2YW5rZ0BhbWQuY29tPg0K
PiA+IC0tLQ0KPiA+ICBpbmNsdWRlL2xpbnV4L3BhZ2VtYXAuaCB8IDI0ICsrKysrKysrKysrKysr
KysrKysrLS0tLQ0KPiA+ICBtbS9jb21wYWN0aW9uLmMgICAgICAgICB8IDEyICsrKysrKy0tLS0t
LQ0KPiA+ICBtbS9taWdyYXRlLmMgICAgICAgICAgICB8ICAyICstDQo+ID4gIHZpcnQva3ZtL2d1
ZXN0X21lbWZkLmMgIHwgIDEgKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDI4IGluc2VydGlvbnMo
KyksIDExIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4
L3BhZ2VtYXAuaCBiL2luY2x1ZGUvbGludXgvcGFnZW1hcC5oDQo+ID4gaW5kZXggMmMzNzE4ZDU5
MmQ2Li5hN2RjYWE2NmU0ZTMgMTAwNjQ0DQo+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9wYWdlbWFw
LmgNCj4gPiArKysgYi9pbmNsdWRlL2xpbnV4L3BhZ2VtYXAuaA0KPiA+IEBAIC0yMTAsNiArMjEw
LDcgQEAgZW51bSBtYXBwaW5nX2ZsYWdzIHsNCj4gPiAgCUFTX1dSSVRFQkFDS19NQVlfREVBRExP
Q0tfT05fUkVDTEFJTSA9IDksDQo+ID4gIAlBU19LRVJORUxfRklMRSA9IDEwLAkvKiBtYXBwaW5n
IGZvciBhIGZha2Uga2VybmVsIGZpbGUgdGhhdCBzaG91bGRuJ3QNCj4gPiAgCQkJCSAgIGFjY291
bnQgdXNhZ2UgdG8gdXNlciBjZ3JvdXBzICovDQo+ID4gKwlBU19VTk1PVkFCTEUgPSAxMSwJLyog
VGhlIG1hcHBpbmcgY2Fubm90IGJlIG1vdmVkLCBldmVyICovDQo+ID4gIAkvKiBCaXRzIDE2LTI1
IGFyZSB1c2VkIGZvciBGT0xJT19PUkRFUiAqLw0KPiA+ICAJQVNfRk9MSU9fT1JERVJfQklUUyA9
IDUsDQo+ID4gIAlBU19GT0xJT19PUkRFUl9NSU4gPSAxNiwNCj4gPiBAQCAtMzIyLDExICszMjMs
MTAgQEAgc3RhdGljIGlubGluZSB2b2lkIG1hcHBpbmdfY2xlYXJfc3RhYmxlX3dyaXRlcyhzdHJ1
Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZykNCj4gPiAgc3RhdGljIGlubGluZSB2b2lkIG1hcHBp
bmdfc2V0X2luYWNjZXNzaWJsZShzdHJ1Y3QgYWRkcmVzc19zcGFjZSAqbWFwcGluZykNCj4gPiAg
ew0KPiA+ICAJLyoNCj4gPiAtCSAqIEl0J3MgZXhwZWN0ZWQgaW5hY2Nlc3NpYmxlIG1hcHBpbmdz
IGFyZSBhbHNvIHVuZXZpY3RhYmxlLiBDb21wYWN0aW9uDQo+ID4gLQkgKiBtaWdyYXRlIHNjYW5u
ZXIgKGlzb2xhdGVfbWlncmF0ZXBhZ2VzX2Jsb2NrKCkpIHJlbGllcyBvbiB0aGlzIHRvDQo+ID4g
LQkgKiByZWR1Y2UgcGFnZSBsb2NraW5nLg0KPiA+ICsJICogVGhlIG1hcHBpbmcncyBjb250ZW50
cyBtdXN0IG5vdCBiZSBhY2Nlc3NlZCBieSB0aGUgQ1BVIHRocm91Z2gNCj4gPiArCSAqIHRoZSBr
ZXJuZWwgZGlyZWN0IG1hcCBvciBvdGhlciBpbnRlcm5hbCBwYXRocyAoZS5nLiB6ZXJvaW5nIG9m
DQo+ID4gKwkgKiBwYWdlcyBkdXJpbmcgdHJ1bmNhdGlvbikuDQo+ID4gIAkgKi8NCj4gPiAtCXNl
dF9iaXQoQVNfVU5FVklDVEFCTEUsICZtYXBwaW5nLT5mbGFncyk7DQo+ID4gIAlzZXRfYml0KEFT
X0lOQUNDRVNTSUJMRSwgJm1hcHBpbmctPmZsYWdzKTsNCj4gPiAgfQ0KPiA+ICANCj4gPiBAQCAt
MzM1LDYgKzMzNSwyMiBAQCBzdGF0aWMgaW5saW5lIGJvb2wgbWFwcGluZ19pbmFjY2Vzc2libGUo
Y29uc3Qgc3RydWN0IGFkZHJlc3Nfc3BhY2UgKm1hcHBpbmcpDQo+ID4gIAlyZXR1cm4gdGVzdF9i
aXQoQVNfSU5BQ0NFU1NJQkxFLCAmbWFwcGluZy0+ZmxhZ3MpOw0KPiA+ICB9DQo+ID4gIA0KPiA+
ICtzdGF0aWMgaW5saW5lIHZvaWQgbWFwcGluZ19zZXRfdW5tb3ZhYmxlKHN0cnVjdCBhZGRyZXNz
X3NwYWNlICptYXBwaW5nKQ0KPiA+ICt7DQo+ID4gKwkvKg0KPiA+ICsJICogSXQncyBleHBlY3Rl
ZCB1bm1vdmFibGUgbWFwcGluZ3MgYXJlIGFsc28gdW5ldmljdGFibGUuIENvbXBhY3Rpb24NCj4g
PiArCSAqIG1pZ3JhdGUgc2Nhbm5lciAoaXNvbGF0ZV9taWdyYXRlcGFnZXNfYmxvY2soKSkgcmVs
aWVzIG9uIHRoaXMgdG8NCj4gPiArCSAqIHJlZHVjZSBwYWdlIGxvY2tpbmcuDQo+ID4gKwkgKi8N
Cj4gPiArCXNldF9iaXQoQVNfVU5FVklDVEFCTEUsICZtYXBwaW5nLT5mbGFncyk7DQo+ID4gKwlz
ZXRfYml0KEFTX1VOTU9WQUJMRSwgJm1hcHBpbmctPmZsYWdzKTsNCj4gPiArfQ0KPiA+ICsNCj4g
PiArc3RhdGljIGlubGluZSBib29sIG1hcHBpbmdfdW5tb3ZhYmxlKGNvbnN0IHN0cnVjdCBhZGRy
ZXNzX3NwYWNlICptYXBwaW5nKQ0KPiA+ICt7DQo+ID4gKwlyZXR1cm4gdGVzdF9iaXQoQVNfVU5N
T1ZBQkxFLCAmbWFwcGluZy0+ZmxhZ3MpOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW5s
aW5lIHZvaWQgbWFwcGluZ19zZXRfd3JpdGViYWNrX21heV9kZWFkbG9ja19vbl9yZWNsYWltKHN0
cnVjdCBhZGRyZXNzX3NwYWNlICptYXBwaW5nKQ0KPiA+ICB7DQo+ID4gIAlzZXRfYml0KEFTX1dS
SVRFQkFDS19NQVlfREVBRExPQ0tfT05fUkVDTEFJTSwgJm1hcHBpbmctPmZsYWdzKTsNCj4gPiBk
aWZmIC0tZ2l0IGEvbW0vY29tcGFjdGlvbi5jIGIvbW0vY29tcGFjdGlvbi5jDQo+ID4gaW5kZXgg
ZjA4NzY1YWRlMDE0Li5lNmIwZmRmYWY3OWQgMTAwNjQ0DQo+ID4gLS0tIGEvbW0vY29tcGFjdGlv
bi5jDQo+ID4gKysrIGIvbW0vY29tcGFjdGlvbi5jDQo+ID4gQEAgLTExMzMsMjIgKzExMzMsMjIg
QEAgaXNvbGF0ZV9taWdyYXRlcGFnZXNfYmxvY2soc3RydWN0IGNvbXBhY3RfY29udHJvbCAqY2Ms
IHVuc2lnbmVkIGxvbmcgbG93X3BmbiwNCj4gPiAgCQlpZiAoKChtb2RlICYgSVNPTEFURV9BU1lO
Q19NSUdSQVRFKSAmJiBpc19kaXJ0eSkgfHwNCj4gPiAgCQkgICAgKG1hcHBpbmcgJiYgaXNfdW5l
dmljdGFibGUpKSB7DQo+ID4gIAkJCWJvb2wgbWlncmF0ZV9kaXJ0eSA9IHRydWU7DQo+ID4gLQkJ
CWJvb2wgaXNfaW5hY2Nlc3NpYmxlOw0KPiA+ICsJCQlib29sIGlzX3VubW92YWJsZTsNCj4gPiAg
DQo+ID4gIAkJCS8qDQo+ID4gIAkJCSAqIE9ubHkgZm9saW9zIHdpdGhvdXQgbWFwcGluZ3Mgb3Ig
dGhhdCBoYXZlDQo+ID4gIAkJCSAqIGEgLT5taWdyYXRlX2ZvbGlvIGNhbGxiYWNrIGFyZSBwb3Nz
aWJsZSB0byBtaWdyYXRlDQo+ID4gIAkJCSAqIHdpdGhvdXQgYmxvY2tpbmcuDQo+ID4gIAkJCSAq
DQo+ID4gLQkJCSAqIEZvbGlvcyBmcm9tIGluYWNjZXNzaWJsZSBtYXBwaW5ncyBhcmUgbm90IG1p
Z3JhdGFibGUuDQo+ID4gKwkJCSAqIEZvbGlvcyBmcm9tIHVubW92YWJsZSBtYXBwaW5ncyBhcmUg
bm90IG1pZ3JhdGFibGUuDQo+ID4gIAkJCSAqDQo+ID4gIAkJCSAqIEhvd2V2ZXIsIHdlIGNhbiBi
ZSByYWNpbmcgd2l0aCB0cnVuY2F0aW9uLCB3aGljaCBjYW4NCj4gPiAgCQkJICogZnJlZSB0aGUg
bWFwcGluZyB0aGF0IHdlIG5lZWQgdG8gY2hlY2suIFRydW5jYXRpb24NCj4gPiAgCQkJICogaG9s
ZHMgdGhlIGZvbGlvIGxvY2sgdW50aWwgYWZ0ZXIgdGhlIGZvbGlvIGlzIHJlbW92ZWQNCj4gPiAg
CQkJICogZnJvbSB0aGUgcGFnZSBzbyBob2xkaW5nIGl0IG91cnNlbHZlcyBpcyBzdWZmaWNpZW50
Lg0KPiA+ICAJCQkgKg0KPiA+IC0JCQkgKiBUbyBhdm9pZCBsb2NraW5nIHRoZSBmb2xpbyBqdXN0
IHRvIGNoZWNrIGluYWNjZXNzaWJsZSwNCj4gPiAtCQkJICogYXNzdW1lIGV2ZXJ5IGluYWNjZXNz
aWJsZSBmb2xpbyBpcyBhbHNvIHVuZXZpY3RhYmxlLA0KPiA+ICsJCQkgKiBUbyBhdm9pZCBsb2Nr
aW5nIHRoZSBmb2xpbyBqdXN0IHRvIGNoZWNrIHVubW92YWJsZSwNCj4gPiArCQkJICogYXNzdW1l
IGV2ZXJ5IHVubW92YWJsZSBmb2xpbyBpcyBhbHNvIHVuZXZpY3RhYmxlLA0KPiA+ICAJCQkgKiB3
aGljaCBpcyBhIGNoZWFwZXIgdGVzdC4gIElmIG91ciBhc3N1bXB0aW9uIGdvZXMNCj4gPiAgCQkJ
ICogd3JvbmcsIGl0J3Mgbm90IGEgY29ycmVjdG5lc3MgYnVnLCBqdXN0IHBvdGVudGlhbGx5DQo+
ID4gIAkJCSAqIHdhc3RlZCBjeWNsZXMuDQo+ID4gQEAgLTExNjEsOSArMTE2MSw5IEBAIGlzb2xh
dGVfbWlncmF0ZXBhZ2VzX2Jsb2NrKHN0cnVjdCBjb21wYWN0X2NvbnRyb2wgKmNjLCB1bnNpZ25l
ZCBsb25nIGxvd19wZm4sDQo+ID4gIAkJCQltaWdyYXRlX2RpcnR5ID0gIW1hcHBpbmcgfHwNCj4g
PiAgCQkJCQkJbWFwcGluZy0+YV9vcHMtPm1pZ3JhdGVfZm9saW87DQo+ID4gIAkJCX0NCj4gPiAt
CQkJaXNfaW5hY2Nlc3NpYmxlID0gbWFwcGluZyAmJiBtYXBwaW5nX2luYWNjZXNzaWJsZShtYXBw
aW5nKTsNCj4gPiArCQkJaXNfdW5tb3ZhYmxlID0gbWFwcGluZyAmJiBtYXBwaW5nX3VubW92YWJs
ZShtYXBwaW5nKTsNCj4gPiAgCQkJZm9saW9fdW5sb2NrKGZvbGlvKTsNCj4gPiAtCQkJaWYgKCFt
aWdyYXRlX2RpcnR5IHx8IGlzX2luYWNjZXNzaWJsZSkNCj4gPiArCQkJaWYgKCFtaWdyYXRlX2Rp
cnR5IHx8IGlzX3VubW92YWJsZSkNCj4gPiAgCQkJCWdvdG8gaXNvbGF0ZV9mYWlsX3B1dDsNCj4g
PiAgCQl9DQo+ID4gIA0KPiA+IGRpZmYgLS1naXQgYS9tbS9taWdyYXRlLmMgYi9tbS9taWdyYXRl
LmMNCj4gPiBpbmRleCBkZDE1YTg0YjJhNTIuLmQ0ZGNkN2YxNDJjZSAxMDA2NDQNCj4gPiAtLS0g
YS9tbS9taWdyYXRlLmMNCj4gPiArKysgYi9tbS9taWdyYXRlLmMNCj4gPiBAQCAtMTEwMSw3ICsx
MTAxLDcgQEAgc3RhdGljIGludCBtb3ZlX3RvX25ld19mb2xpbyhzdHJ1Y3QgZm9saW8gKmRzdCwg
c3RydWN0IGZvbGlvICpzcmMsDQo+ID4gIA0KPiA+ICAJaWYgKCFtYXBwaW5nKQ0KPiA+ICAJCXJj
ID0gbWlncmF0ZV9mb2xpbyhtYXBwaW5nLCBkc3QsIHNyYywgbW9kZSk7DQo+ID4gLQllbHNlIGlm
IChtYXBwaW5nX2luYWNjZXNzaWJsZShtYXBwaW5nKSkNCj4gPiArCWVsc2UgaWYgKG1hcHBpbmdf
dW5tb3ZhYmxlKG1hcHBpbmcpKQ0KPiA+ICAJCXJjID0gLUVPUE5PVFNVUFA7DQo+ID4gIAllbHNl
IGlmIChtYXBwaW5nLT5hX29wcy0+bWlncmF0ZV9mb2xpbykNCj4gPiAgCQkvKg0KPiA+IGRpZmYg
LS1naXQgYS92aXJ0L2t2bS9ndWVzdF9tZW1mZC5jIGIvdmlydC9rdm0vZ3Vlc3RfbWVtZmQuYw0K
PiA+IGluZGV4IDQ1Y2JkZjQ4MDFlYy4uMTY5Zjc1Zjk1NDMzIDEwMDY0NA0KPiA+IC0tLSBhL3Zp
cnQva3ZtL2d1ZXN0X21lbWZkLmMNCj4gPiArKysgYi92aXJ0L2t2bS9ndWVzdF9tZW1mZC5jDQo+
ID4gQEAgLTU5Myw2ICs1OTMsNyBAQCBzdGF0aWMgaW50IF9fa3ZtX2dtZW1fY3JlYXRlKHN0cnVj
dCBrdm0gKmt2bSwgbG9mZl90IHNpemUsIHU2NCBmbGFncykNCj4gPiAgCWlub2RlLT5pX3NpemUg
PSBzaXplOw0KPiA+ICAJbWFwcGluZ19zZXRfZ2ZwX21hc2soaW5vZGUtPmlfbWFwcGluZywgR0ZQ
X0hJR0hVU0VSKTsNCj4gPiAgCW1hcHBpbmdfc2V0X2luYWNjZXNzaWJsZShpbm9kZS0+aV9tYXBw
aW5nKTsNCj4gPiArCW1hcHBpbmdfc2V0X3VubW92YWJsZShpbm9kZS0+aV9tYXBwaW5nKTsNCj4g
DQo+IEZvciBzaGFyZWQtb25seSBndWVzdF9tZW1mZCwgaXMgdGhlcmUgZXZlbiBhIHJlYXNvbiB0
byBtYXJrIGl0IGFzDQo+IG1hcHBpbmdfc2V0X2luYWNjZXNzaWJsZSgpID8NCj4gDQo+IG1hcHBp
bmdfaW5hY2Nlc3NpYmxlKCkgaXMgb25seSB1c2VkIGluIHRydW5jYXRpb24gYW5kIGNvbXBhY3Rp
b24gbG9naWMuDQo+IA0KPiBXb3VsZG4ndCB3ZSB3YW50IGNvbXBhY3Rpb24gdG8gd29yayBoZXJl
Pw0KDQpDb21wYWN0aW9uIHdvdWxkIHdvcmsgaGVyZSBiZWNhdXNlIG1pZ3JhdGlvbiBhbmQgY29t
cGFjdGlvbiBub3cgY2hlY2tzIHRoZQ0KbWFwcGluZ191bm1vdmFibGUoKSwgd2hpbGUgdGhlIFRy
dW5jYXRpb24gc3RpbGwgY2hlY2tzDQptYXBwaW5nX2luYWNjZXNzaWJsZSgpIHRvIGF2b2lkIHdy
aXRlcyB0byBjb25maWRlbnRpYWwgbWVtb3J5Lg0KDQo+IA0KPiBJT1csIGZvciBzaGFyZWQtb25s
eSB3aXRoIG1pZ3JhdGlvbiBzdXBwb3J0LCBjYW4ndCB3ZSBqdXN0IG5vdCBkbw0KPiBtYXBwaW5n
X3NldF9pbmFjY2Vzc2libGUoKSA/DQoNCnllcywgSSdsbCBkbyB0aGlzLg0KDQpUaGFua3MsDQpT
aGl2YW5rDQo=

