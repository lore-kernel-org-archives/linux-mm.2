Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CABCBC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C52476B00DD; Wed,  2 Sep 2026 07:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C291E6B00DF; Wed,  2 Sep 2026 07:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3906B00DD; Wed,  2 Sep 2026 07:19:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED4E6B00DE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:19:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A8EE40193
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:19:47 +0000 (UTC)
X-FDA: 85168577214.29.2096FD6
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012061.outbound.protection.outlook.com [40.93.195.61])
	by imf15.hostedemail.com (Postfix) with ESMTP id 701D8A000B;
	Wed,  2 Sep 2026 11:19:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JEVMkraW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788347984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lF2CjMtGkLotObvf148MSQxhKgfXFbAl0A/EfyUbpPM=;
	b=skKoCL8d/xKVm4W9qCMQh/09aVVc4g6uUKCfJARHGRWagQIB5r0vFc5a9+PtBjpWgaie6+
	yvsPEKRcLxUo2ulizxa9+7ko+mn7TM7I+jkAzJSrJwFteg2dEX2T2H6iuITX9dAOOWwHB7
	zh5s1brT2b8bht6kzac9s7+NLXShK7Q=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=amd.com header.s=selector1 header.b=JEVMkraW;
	dmarc=pass (policy=quarantine) header.from=amd.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of shivankg@amd.com designates 40.93.195.61 as permitted sender) smtp.mailfrom=shivankg@amd.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788347984;
	b=gL52Vp3qglLIGy3Tjbd9JTmwS+BywoANPI5Id/uqR7gUgiaJhercx5erclQfjilza5nZFf
	biWrev5XnUWucOUWZZQjM94kqmy7Hlaz/9sFg1/WZpb/TI6OhK/M2mXK6KrZRatpjmR3C/
	9IFXI8ELMMZ17PsQYLMMa+OtGyV9gDY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=aPz7I8sOGf1NyMjzrEGTZSXSA3XGgcittYVG4J0qhS1G175cQBEJ47Gb/YK/1oECZoVNEfE+r+ShjPKP8Z/4CGXcjwqso8hAf1fSdJvcQKVhFAFd2obbXwbH/SZSMWSgSDm+SQB94vKgMUC2bBBvGGQYG1RLzCxIdodX7Qcp/8kmN3oaBYA/SZu/+tLP7xKUX21ojPUUWwlcxR+pR/C2S7Gw6zfpT5DqZ6aujxrb3+OxxpyjLMzPCiCvzN2+z3TziF346V2wKeyqBDel3OyfhT3XpGHBzDc4RtmFfcty9TwS2PtBQXBRcg1AegoINpgPRlMw+KpaXekmnAjg8syuGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lF2CjMtGkLotObvf148MSQxhKgfXFbAl0A/EfyUbpPM=;
 b=h0OJCh5KRtHBJa9K0X1Te4Xbvvy9w5Em8OZLwwb7CPad3vpJtTzx5PoJsewVqKSeq9jiUrZHhtrCgienzY8FEto5AsZYO6XS9NKvdcPtrULVXvuSzlnqcvW3n3axVGwYakjeyACSG/NK0w2YlC7/TFF7kO6TXKwQl7BeKszwa9svfMDRLr6CN5hzkP7kLb4S6F6X5brCkQH2wafbYzoVzTNRShqgiJ9DUj3jxTYi3m8iKzQEoohXieO3wNWxtFda64F6NJ9ZdIw/ZB8s/pHa79JyMl1PYN734W8fwIAWB1N915FGSHu/GYBWZUcf5FoXxSq7ncHSh68Py4H7XGPuew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lF2CjMtGkLotObvf148MSQxhKgfXFbAl0A/EfyUbpPM=;
 b=JEVMkraWy6c4Rt8z3Co5cFcXrPwzge3nF+QYXzZR5SpRxzuhRqLF6bCVd2nuLj1oi9bB08Gp36f52vUC4D4VoZApFlv95jYxRYMuDBD4ezCydh5eYyMgv/9kADX9BaVdYxYDzFBhAvuUr0JSKKVsosOQkGQYzFn/viegJu4pvqo=
Received: from BN9PR12MB5259.namprd12.prod.outlook.com (2603:10b6:408:100::17)
 by MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Wed, 2 Sep
 2026 11:19:37 +0000
Received: from BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed]) by BN9PR12MB5259.namprd12.prod.outlook.com
 ([fe80::122c:cca7:c2b3:90ed%2]) with mapi id 15.21.0360.008; Wed, 2 Sep 2026
 11:19:37 +0000
From: "Garg, Shivank" <shivankg@amd.com>
To: "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>,
	"sj@kernel.org" <sj@kernel.org>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "joshua.hahnjy@gmail.com"
	<joshua.hahnjy@gmail.com>, "david@kernel.org" <david@kernel.org>,
	"mhocko@suse.com" <mhocko@suse.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
	"jack@suse.cz" <jack@suse.cz>, "kasong@tencent.com" <kasong@tencent.com>,
	"rientjes@google.com" <rientjes@google.com>, "anna@kernel.org"
	<anna@kernel.org>, "weixugc@google.com" <weixugc@google.com>, "jgg@ziepe.ca"
	<jgg@ziepe.ca>, "corbet@lwn.net" <corbet@lwn.net>, "gourry@gourry.net"
	<gourry@gourry.net>, "Rao, Bharata Bhasker" <bharata@amd.com>,
	"byungchul@sk.com" <byungchul@sk.com>, "yuanchu@google.com"
	<yuanchu@google.com>, "rdunlap@infradead.org" <rdunlap@infradead.org>,
	"axelrasmussen@google.com" <axelrasmussen@google.com>, "rppt@kernel.org"
	<rppt@kernel.org>, "seanjc@google.com" <seanjc@google.com>, "bcrl@kvack.org"
	<bcrl@kvack.org>, "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
	"willy@infradead.org" <willy@infradead.org>, "osalvador@suse.de"
	<osalvador@suse.de>, "surenb@google.com" <surenb@google.com>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "matthew.brost@intel.com"
	<matthew.brost@intel.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "brauner@kernel.org"
	<brauner@kernel.org>, "clm@fb.com" <clm@fb.com>, "qi.zheng@linux.dev"
	<qi.zheng@linux.dev>, "baohua@kernel.org" <baohua@kernel.org>,
	"rakie.kim@sk.com" <rakie.kim@sk.com>, "brendan.jackman@linux.dev"
	<brendan.jackman@linux.dev>, "dsterba@suse.com" <dsterba@suse.com>,
	"apopple@nvidia.com" <apopple@nvidia.com>, "ziy@nvidia.com" <ziy@nvidia.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "ljs@kernel.org" <ljs@kernel.org>,
	"linmiaohe@huawei.com" <linmiaohe@huawei.com>, "muchun.song@linux.dev"
	<muchun.song@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "yiannis@zptcorp.com" <yiannis@zptcorp.com>,
	"shaggy@kernel.org" <shaggy@kernel.org>, "trondmy@kernel.org"
	<trondmy@kernel.org>
CC: "jfs-discussion@lists.sourceforge.net"
	<jfs-discussion@lists.sourceforge.net>, "damon@lists.linux.dev"
	<damon@lists.linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [sos-linux-ext-patches] [PATCH RFC 09/11] mm/migrate: thread
 migration policy through a control struct
Thread-Topic: [sos-linux-ext-patches] [PATCH RFC 09/11] mm/migrate: thread
 migration policy through a control struct
Thread-Index: AQHdOsmT+W0LNheKIkurwO1qDEWLzLa7JEwA
Date: Wed, 2 Sep 2026 11:19:37 +0000
Message-ID: <1508939ba49c28e06b9cec344ec6a69ab57ce8ac.camel@amd.com>
References: <20260902-migrate-refactor-shivank-v1-0-9dcca87669c4@amd.com>
	 <20260902-migrate-refactor-shivank-v1-9-9dcca87669c4@amd.com>
In-Reply-To: <20260902-migrate-refactor-shivank-v1-9-9dcca87669c4@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR12MB5259:EE_|MN0PR12MB6031:EE_
x-ms-office365-filtering-correlation-id: 6dbeaf07-8e93-4a9d-4d97-08df08e41323
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|376014|1800799024|23010399003|7416014|38070700021|56012099006|921020|4143699003|6133799003|10067099003|22082099003|18002099003|11063799006;
x-microsoft-antispam-message-info:
 9MJApMCkHPveInhHy/FrmUSZyELPqKJ8H6hemBG8eH14jwWDo9g2mQpBVnpD06O29ttdWpNgJNW5cd1z50r7bRhatKvTN6xcjS2UcphxhWwxrR7aaw5Hyk9fvKhMIBIfvtbjSTMIBuB4ygY8Vc66cpkNhufYjx3OtvZJmagryfcVvDD9WUKHs/tVnzw5RU12DM17xTnUqj/CVJeoI+82H5MFyFG7LyOMPcNEuiRSHCC2PhCsE3ENHzP2GDqfaAYaJq1Cvlm7EpprNRVlzhniKpaRbcgLdpPokph6Wfj8YTW15vIG711hItbzCxttN92ccoT2hIHBziEd/zrseQuIm4W5Rakw8H7pD1+fc9WzIMqga8SA3VqkU8NpHMJQtNGOHjqe3Cyv3npElN6y7JiqxRj5aLbAm1u9tVZ0osd0aEBriwzhPo1VTkBxhRH9jwzsgLr93EZ4dTY9LmcZ91yXWQ/+CWTWK5m9/stPSzHl+z3y50uJnfSaQTEqr7wpEcREiw24pzFSdYCPEDJ1z7LBK5oCM6jCfaljdJ6/LtdsKpcsyAEtepvpzXHpnWTHerHHpSgLBfhEtw3q26MPK37sWmiz+Yc38sCYztKyC+5sMZVzLX448E2y4CJj6qsgonFYh0b3oSA9smYH/ijEev+3Ed9BEWYIfuGOzSt6+mFDd5c23+2gTb7asdVX1v6NWmBVh/KFx1FTS/C9Op9fpxvd4jLqGy2ZyVwitB2sj2UZurI=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5259.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(23010399003)(7416014)(38070700021)(56012099006)(921020)(4143699003)(6133799003)(10067099003)(22082099003)(18002099003)(11063799006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?K2ZscTh1Uyt4bm5oMzg0NnN0dFBtL0JRZFR4OXVWeDJ1ZWNKd0NIdmNJbGtr?=
 =?utf-8?B?RXZFU0NuVCt5endIdmdRVm51cmF6NUdjTWZvdjhQQW9xM2NLSG01SUM4UHNG?=
 =?utf-8?B?YnprT2xNWkJLTUdzS3NWV2JocnQ0MEhWcUFHakpkd3RCWGQySUZhNVczaXdH?=
 =?utf-8?B?UWx0VWJxVDZXakdyS0tGR3dCTW53TThoWFMzeG00SjgzVzlRS1dyOFpBbG42?=
 =?utf-8?B?VFlPVVRaNnczNTV4ZU5iMTA4NkJPTVpPak5nZFlNRlFRckFNTVFWbWFyalZI?=
 =?utf-8?B?aHdxcks5V2d1RXFaTHpNb0JVc1pjbTd1QUk5MkllYlU5bjVLSEZKY1RxM3dX?=
 =?utf-8?B?Zk1rOUxaTXJJSzZ6MjJPUExsZ0tibTFqZEg3eEdlWXlRTVBnU1h0YjAzQlN4?=
 =?utf-8?B?UElTWDNEeFY4TlBOa1hwVHE1K1Q4NFJIYXFPcEtTU0crVDBRa0N2RjJZVnRX?=
 =?utf-8?B?R3NNVExOTExOUS8yQUlzS1l4aWJuRUkydGxpSGl3RE14emU1SmVhQ084Zm5N?=
 =?utf-8?B?MDN0U1E5VVEzRzNhSG9Fc2d1ejFKMTFxTHpwdlQ5K2dZNkhnWmJ1WWkzTjNR?=
 =?utf-8?B?Uk1sU2ttdDhSYUZLenpUT1BGNkxkR2s2WE5KWGFrMEtNWS9BNG8zNUJjdllV?=
 =?utf-8?B?MzAzUisvOE01dlltS1JNTmFka2liais2cjdCUVROQXFwWHRMMzFTYkw0YVZ1?=
 =?utf-8?B?dlM3ZWRiR0RldDFRVHZic2NXbGZyZDRlV3BPWUFQN2svY0RQM2txNjQ5VjZ0?=
 =?utf-8?B?eWN5T2ZiS0pvblpGaUhuTitPY0tVamJsSndzWThaNTQzZUluQzR2d2NaRE00?=
 =?utf-8?B?dUJOWDBBSjFDVE5QbWhSdzBsV2pZQzFyTTUzRzNYbzRybmFFZk8xdkFnNlNw?=
 =?utf-8?B?TnNFcFpaRTV6RW43UVlJcTlDQjJ2TUhEYTRmSEliTEMxc1J1SS9lWUswMWxu?=
 =?utf-8?B?TEFqRFdQRjJJQTI2MS9ka3BibTFvYWRzMkpBeXI4YTB3a1pRaVNLcDkrNXhz?=
 =?utf-8?B?cW1VbE1RdjN1L2NDQ0hndWc3RndlMGI3cStWd2tqUHJDQ2JkT01pVUF1YmVU?=
 =?utf-8?B?aGZlZ2tqNGFNZ3djSlVSQUpvTVZKZEtZaCtRUEtjZjVrakhkbnNnZ2dBRGhj?=
 =?utf-8?B?SzBqRGxlUlFLVjJLc2ZTYXU3VHYwcDFiQjRNZ09TbXUxbkRQUFRRblRXOStr?=
 =?utf-8?B?SXVrSjF2MTJMcjMrVURKWUZvWExJNG9ISzdmVUhjeEZzVmNJWVdaN0MvWk00?=
 =?utf-8?B?Z2gvV0RURnp6ZzdWWWg5RzNiOFBwcVVFN0ZNL2Urejg0cmxabWl2emR3NFhP?=
 =?utf-8?B?M0V2cjFucXYwSElMTGI4c0R1OUlaOHVFYmtsZENHVzdtaGNNZ1JnaktPVWlB?=
 =?utf-8?B?SEs0em1NZ1NLRkJzMUdJZFNJeEpKRUNFQkh6VkZxc3hZSWpwQldUYzlRb05J?=
 =?utf-8?B?OVBjYU0yNVdaZVU5a2NTdzdUTlk3S3FudHRDa05lNHI5djJleTlZMkZ0Z2s4?=
 =?utf-8?B?T0VVMzlxaWUxaCtaY0NkM2c5SXp0VUoyb1NhN082eUEvQ1NLbGkza3RnWUY1?=
 =?utf-8?B?TGFFN0hxYlBIMk9RM2lPditoSXVqc1JaTC9JbmJ2dDNaRm5yU1M3S25jNlI1?=
 =?utf-8?B?SHgwNUxBalZuOFBjK2ZyOW1LeUNhSXQ0ZG5DU3pJTHRwVGE5RjBNbk9ZUHFu?=
 =?utf-8?B?N3J0V0YwYXNDZlBFNHBnUXdPR3RrTGlqdnFQeG50RFdhL0g1VWFuWHAySkRa?=
 =?utf-8?B?MEpqQzhCcUhDQmtXNVQ2dEtiMXlsUjBmd2RVb0lIdlBjTFhSVU0vbGJLenoy?=
 =?utf-8?B?NkZhdUFSZTJ2d3FtVlpDZXF2WVJYOXUxOXBRdWxSaVcyaHRvR0pwUzdoZ3VV?=
 =?utf-8?B?VkV6RUhnam8xbTN3QlFnbVFyMWt0UXRvdmNGOHFjcU9WNTI4WHo1Vi8xY2xl?=
 =?utf-8?B?WjlpSXhKVDlQWXpPQnUxbWFxSElSc0w2YjJ0by92Sjhya1BOaXhyOTBOUCsv?=
 =?utf-8?B?NzUwQ1lTekFoZm5SZHd3b2xUbkNacVdtMEc5UXJGRU9COGhPRktkUVQwT3d3?=
 =?utf-8?B?UElSQTVaT2xNNUNBVGV0Y05xRm1BSnNWZXVwRmo1WnJKVGNwUnI0OHNGa3VH?=
 =?utf-8?B?U0RiTGhGQm9XaEIvU3J3QU81VzNiTTFsWEJwUzRQTXRRZE5wY1FXREhSdndz?=
 =?utf-8?B?bU1ibXZISFBheXhZS1lLNnFKbE54QkphbzJpL2R0aElzTGd4d2gydzdGQ2hs?=
 =?utf-8?B?b1Q3REFtdTFQM0dLaHozdHhlNjA1VzhTWkZiRCtPTDN3T3VzclEyQXlhNWRG?=
 =?utf-8?B?VVNuV2IrOHAyRHY5b2JwY3pYUGVwRTI2V3BEbXc2SlRHazZkcGRVUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <217DE4CD07644847BDA0C6B26664D329@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5259.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dbeaf07-8e93-4a9d-4d97-08df08e41323
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2026 11:19:37.6233
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5Nvb0cIybsmkBU6v0uXZYTWszLIMxbAoAQK/H/MT8Lm/Ts7tp80wxSzfcLdJEEs8eKNyMNcRWe7TSXRSeEYvbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
X-Stat-Signature: 99a14wt9h7z5j8a9pruo4bhjxkznywrf
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 701D8A000B
X-Rspam-User: 
X-HE-Tag: 1788347983-295679
X-HE-Meta: U2FsdGVkX1/uMDQZnfjPr+1c5ZG8bOahdjRbUP6ierKFnv+UCEzrQagEKCKDqt3hUuXc1vzRBRLfi/G8zk/xlIPO7RLaZQMJiR+d4GYetOWgMEPRlQMadid4X6Dq1N3SlfXUxwZ3a/IOhp5zSxILZIGTW0UiaPm0BeF83JmqAFqV7KO47wMAoS+CKQc/ARI3QA2+kU+UUBHBEpD29C6BULZ5IdawNOHRFqoXRNH2sfMfX5zmLrujndIgp/LkWSXI4dOpvkMg8iB9ucbAt7Fp7n7XPfY5bCOxdAhK7icwmkCRK2YB79VHPqVa+Wq44V8P1E8el9EerKYQZ+Zr4LmLvkthf8aGPJRh3ePPk/nWiy2QhAHAh67XIitGnmDD4bUy7Fd/GD+CcCyNMrXXn7UdyfR0iRPZMPwdujTdQUAk/3PPlB6CbtQiZl5vmOCB6Na9Z13MrwQFEDV4ocDanxDUHITGNgas66lGAvXSRbuG9uFvVof3UiY3+ppHS8RrxYPtMsV3HNuFwrzblIvK2gsD29ma1+1SffgvQbFZ3a5QDxfGhVX9BdPCXRfiZrhVDC2Ku8ssCkvFarobptYbZwlgMV+agnEPUsm2KgSk16W2RhjhEVNXMJ8kFzhspQOWuAMPDerW6nVlz0Mj4R2bHc19Mpkuy1fzWCqJ1694RCF9nnAqx73EkgQbmLVHdhYJfgwYNQiv56VM+U1D5uPLacMAXboappfCNaVMUwyQCsCpq8bvYiFXxi4TOY0Kmm8bOSMwKKjks4nO65gJcm0lFjy52YGCmEUHQL2z8tIqULVdt/mI/xOrejDlfRSD44ZB+gheut2PLS5SbZnqLPUwWfxxcEtuf1d+WZcJ62xt3t0gDTGMqIE4EU+7cAyOClkUr0h5wjh2v0UcFOt0xVOkRlToZ/79+bkxwyK/VC1/mlCNxO4BiBOS34X8jzOeutfVwJbwwA3D7rd9iB+n0hrZ3x+
 wJ2vGyBG
 7prpyyXSfqzZa4X//uY9tU0L7a9SUZvyKVQ5LQw9dkNLCWwiAwDvycXc9x4VovyN3W5ZWBS/PW5pwjICOtkSpYKtYXF2fvYH0wLyjDGEr+92S8HxZa/oazDXEr+rn6kjIWY7y6IyKet4XY3ZmMZEgZICJLM2cyn515Fxf0Wa7jU5nLvhOBJHWafDdAgwGc39OvnUudPROzT0doI03Ky9938HO7aQk2uRz8u70VxrxYiYmmm3BE7st4ATJSA5you4JondQaCY5oCVMyQ0wSErXCASg5mF9uS8DYIldaVWWhyxEK+G1R2mlr3BWapVpgVYoDdtdm/5JgBoh80CJZXzrCwrDqkCoHBO9NY2T8pjwbMF5N9Sd2xwLdpgwmAVbiXbEy8RvsrvW5GOIvmKtCbcw3RuFd2mF7jYwkVU1bIbxDuN31trs6c4o3kbeXH+OB4oHqK/9C0XWGH1D0j6JCWTICbF2xBDcVjr+VeI2mXdrWhkGIy7ywD+Ux2Hbpe6OOfEbjGJa30yv3JS+QOifls2xTI8jZPZK+/FH4nL475IdU9a0hAg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

T24gV2VkLCAyMDI2LTA5LTAyIGF0IDEwOjUyICswMDAwLCBTaGl2YW5rIEdhcmcgd3JvdGU6DQo+
IE1pZ3JhdGlvbiBtb2RlIGFuZCByZWFzb24gZGVzY3JpYmUgb25lIG1pZ3JhdGlvbiBpbnZvY2F0
aW9uLCBidXQgYXJlIHBhc3NlZA0KPiANCg0KWy4uLl0NCg0KPiBAQCAtMjE4OSwyNyArMjE4OCwy
OSBAQCBzdGF0aWMgaW50IG1pZ3JhdGVfZm9saW9zX2JhdGNoKHN0cnVjdCBsaXN0X2hlYWQgKmZy
b20sDQo+ICAgKi8NCj4gIHN0YXRpYyBpbnQgX19taWdyYXRlX2xydV9mb2xpb3Moc3RydWN0IGxp
c3RfaGVhZCAqZnJvbSwgbmV3X2ZvbGlvX3QgZ2V0X25ld19mb2xpbywNCj4gIAkJZnJlZV9mb2xp
b190IHB1dF9uZXdfZm9saW8sIHVuc2lnbmVkIGxvbmcgcHJpdmF0ZSwNCj4gLQkJZW51bSBtaWdy
YXRlX21vZGUgbW9kZSwgZW51bSBtaWdyYXRlX3JlYXNvbiByZWFzb24sDQo+IC0JCXN0cnVjdCBs
aXN0X2hlYWQgKnJldF9mb2xpb3MsDQo+ICsJCWNvbnN0IHN0cnVjdCBtaWdyYXRlX2NvbnRyb2wg
KmN0bCwgc3RydWN0IGxpc3RfaGVhZCAqcmV0X2ZvbGlvcywNCj4gIAkJc3RydWN0IG1pZ3JhdGVf
cGFnZXNfc3RhdHMgKnN0YXRzKQ0KPiAgew0KPiAgCWludCByYywgbnJfZmFpbGVkID0gMDsNCj4g
IAlMSVNUX0hFQUQoZm9saW9zKTsNCj4gIAlMSVNUX0hFQUQoc3BsaXRfZm9saW9zKTsNCj4gIAlz
dHJ1Y3QgbWlncmF0ZV9wYWdlc19zdGF0cyBhc3RhdHM7DQo+ICsJc3RydWN0IG1pZ3JhdGVfY29u
dHJvbCBhc3luY19jdGw7DQo+ICANCj4gLQlpZiAobW9kZSA9PSBNSUdSQVRFX0FTWU5DKSB7DQo+
ICsJaWYgKGN0bC0+bW9kZSA9PSBNSUdSQVRFX0FTWU5DKSB7DQo+ICAJCXJjID0gbWlncmF0ZV9m
b2xpb3NfYmF0Y2goZnJvbSwgZ2V0X25ld19mb2xpbywgcHV0X25ld19mb2xpbywNCj4gLQkJCQlw
cml2YXRlLCBtb2RlLCByZWFzb24sIHJldF9mb2xpb3MsDQo+ICsJCQkJcHJpdmF0ZSwgY3RsLCBy
ZXRfZm9saW9zLA0KPiAgCQkJCSZzcGxpdF9mb2xpb3MsIHN0YXRzLA0KPiAgCQkJCU5SX01BWF9N
SUdSQVRFX1BBR0VTX1JFVFJZKTsNCj4gIAkJZ290byBvdXQ7DQo+ICAJfQ0KPiAgDQo+ICsJYXN5
bmNfY3RsID0gKmN0bDsNCj4gKwlhc3luY19jdGwubW9kZSA9IE1JR1JBVEVfQVNZTkM7DQo+ICAJ
bWVtc2V0KCZhc3RhdHMsIDAsIHNpemVvZihhc3RhdHMpKTsNCj4gIAkvKiBUcnkgdG8gbWlncmF0
ZSBpbiBiYXRjaCB3aXRoIE1JR1JBVEVfQVNZTkMgbW9kZSBmaXJzdGx5ICovDQoNCg0KDQpTYXNo
aWtvOg0KQ2FuIHRoaXMgbGVhZCB0byBhbiB1bmluaXRpYWxpemVkIHN0YWNrIHZhcmlhYmxlIGJl
aW5nIHVzZWQ/DQpJZiBfX21pZ3JhdGVfbHJ1X2ZvbGlvcygpIGlzIGNhbGxlZCB3aXRoIGN0bC0+
bW9kZSA9PSBNSUdSQVRFX0FTWU5DLCB0aGUNCmVhcmx5IGNoZWNrIGp1bXBzIGRpcmVjdGx5IHRv
IHRoZSBvdXQgbGFiZWwsIGJ5cGFzc2luZyB0aGUgaW5pdGlhbGl6YXRpb24NCm9mIGFzeW5jX2N0
bC4gSWYgbGFyZ2UgZm9saW9zIHdlcmUgc3BsaXQgZHVyaW5nIHRoYXQgZmlyc3QgcGFzcywgdGhl
DQohbGlzdF9lbXB0eSgmc3BsaXRfZm9saW9zKSBjaGVjayB3aWxsIGJlIHRydWUuDQpDb3VsZCB0
aGlzIGNhdXNlIG1pZ3JhdGVfZm9saW9zX2JhdGNoKCkgdG8gZXhlY3V0ZSB3aXRoIGdhcmJhZ2Ug
cG9saWN5PyBGb3INCmV4YW1wbGUsIGl0IG1pZ2h0IGludGVycHJldCB0aGUgdW5pbml0aWFsaXpl
ZCBhc3luY19jdGwubW9kZSBhcyBNSUdSQVRFX1NZTkMsDQpjYXVzaW5nIHVuaW50ZW5kZWQgYmxv
Y2tpbmcgYW5kIHNsZWVwaW5nIGR1cmluZyB3aGF0IHNob3VsZCBiZSBhbiBhc3luY2hyb25vdXMN
Cm1pZ3JhdGlvbi4NCi0tDQoNClllcywgdGhpcyBpcyB2YWxpZCBpc3N1ZS4gSSBzaG91bGQgaW5p
dGlhbGl6ZSBhc3luY19jdGwgZWFybHkgYmVmb3JlIGl0IG1ha2UNCmdvdG8ganVtcC4NCg0KLS0t
DQogbW0vbWlncmF0ZS5jIHwgNSArKy0tLQ0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMo
KyksIDMgZGVsZXRpb25zKC0pDQoNCmRpZmYgLS1naXQgYS9tbS9taWdyYXRlLmMgYi9tbS9taWdy
YXRlLmMNCmluZGV4IDczMTgzNjY2NGE4Ni4uYzc1MzAwZTAwMzg4IDEwMDY0NA0KLS0tIGEvbW0v
bWlncmF0ZS5jDQorKysgYi9tbS9taWdyYXRlLmMNCkBAIC0yMTk5LDggKzIxOTksOSBAQCBzdGF0
aWMgaW50IF9fbWlncmF0ZV9scnVfZm9saW9zKHN0cnVjdCBsaXN0X2hlYWQgKmZyb20sIG5ld19m
b2xpb190IGdldF9uZXdfZm9saQ0KIAlMSVNUX0hFQUQoZm9saW9zKTsNCiAJTElTVF9IRUFEKHNw
bGl0X2ZvbGlvcyk7DQogCXN0cnVjdCBtaWdyYXRlX3BhZ2VzX3N0YXRzIGFzdGF0czsNCi0Jc3Ry
dWN0IG1pZ3JhdGVfY29udHJvbCBhc3luY19jdGw7DQorCXN0cnVjdCBtaWdyYXRlX2NvbnRyb2wg
YXN5bmNfY3RsID0gKmN0bDsNCiANCisJYXN5bmNfY3RsLm1vZGUgPSBNSUdSQVRFX0FTWU5DOw0K
IAlpZiAoY3RsLT5tb2RlID09IE1JR1JBVEVfQVNZTkMpIHsNCiAJCXJjID0gbWlncmF0ZV9mb2xp
b3NfYmF0Y2goZnJvbSwgZ2V0X25ld19mb2xpbywgcHV0X25ld19mb2xpbywNCiAJCQkJcHJpdmF0
ZSwgY3RsLCByZXRfZm9saW9zLA0KQEAgLTIyMDksOCArMjIxMCw2IEBAIHN0YXRpYyBpbnQgX19t
aWdyYXRlX2xydV9mb2xpb3Moc3RydWN0IGxpc3RfaGVhZCAqZnJvbSwgbmV3X2ZvbGlvX3QgZ2V0
X25ld19mb2xpDQogCQlnb3RvIG91dDsNCiAJfQ0KIA0KLQlhc3luY19jdGwgPSAqY3RsOw0KLQlh
c3luY19jdGwubW9kZSA9IE1JR1JBVEVfQVNZTkM7DQogCW1lbXNldCgmYXN0YXRzLCAwLCBzaXpl
b2YoYXN0YXRzKSk7DQogCS8qIFRyeSB0byBtaWdyYXRlIGluIGJhdGNoIHdpdGggTUlHUkFURV9B
U1lOQyBtb2RlIGZpcnN0bHkgKi8NCiAJcmMgPSBtaWdyYXRlX2ZvbGlvc19iYXRjaChmcm9tLCBn
ZXRfbmV3X2ZvbGlvLCBwdXRfbmV3X2ZvbGlvLCBwcml2YXRlLA0KLS0gDQoyLjQzLjANCg0K

