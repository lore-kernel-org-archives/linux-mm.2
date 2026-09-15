Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BE7C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367AD6B0095; Tue, 15 Sep 2026 13:16:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342176B0096; Tue, 15 Sep 2026 13:16:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22EAD6B0098; Tue, 15 Sep 2026 13:16:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B8F6B0095
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:16:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C07B1C1EE0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:16:43 +0000 (UTC)
X-FDA: 85216651086.25.B641DCC
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011029.outbound.protection.outlook.com [40.93.194.29])
	by imf04.hostedemail.com (Postfix) with ESMTP id A12BA40009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:16:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qdjnEuZm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789492600;
	b=T7Qin6TABSEdQ0gd7qZFhaXqehK1q4D08Y3Cthc7h6yvIqcBhT8V+i8Agsa6wYN44Ik5iA
	egPsm8lK85dM/x+69e8bBXsyVBpF9zznWRRAVphxyGJyzpQvGUIQLMKHMTaokpDsssUVCk
	a1X0G+OgxoG0mrurPHNe5MsLblptYlE=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=qdjnEuZm;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.29 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789492600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gm4A0dC/cSIZYi95VVuBQCnE1WnlU3ZJPlPGzxqmmdc=;
	b=JYVWz1IBlhjta6MpyFPZyC2a3E46GM+v2+OuK+YT1SeJVsojhYW8wcXvcNNrNRsDuU0WSF
	zdeFJNw1fm5+NttZeDlYxXanlSLF+yI6vHP5zP4w6/VsVKKGDMRVA1indJtIOycB7c+o4K
	DDdqde2QcPA+5EujrQhlwu1uXpf1f84=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iwwFsvFOloHx4altECsYutAjbApJwPPXiD6QFXUizuENJtzyIE8exaKrZDcNq5I7j1CLZzN3u3ISD6WbMfmpsUQmCJN4RckcRofY0QshFZrbmhoHbkvQRop+h5YKS4kEBvdfiak61L/wb9hjmyJeZtvcGY5jTfRGI+aULIZfGXZZgbhOIgFJ3Jo0saNgmRlfEd7RZFz3v9ZPsHti4brKICSnAb8UPjO1ocO8ZFz49Dd2j8K+ZJviXuuGfO78cqEl0vyoC0pMRQ0iUke1SRVEdlfpkGjgpoL5TUmVYOmDQUI/Rod8n93gL5h8XE6gRHEW1s66fNlcnu8KTVQAGxqagQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gm4A0dC/cSIZYi95VVuBQCnE1WnlU3ZJPlPGzxqmmdc=;
 b=izs3jKvQd2SPtIHCbqSzFGoF/iXmI728U1Xlv4NuvE2aWCWp99y+/8UF7Z4R9btCS7XEV6S7MzB5QgrnbKYyDjDw4I22mF0e9yYLUWo6LsxQeAotR+60Ij38OCq8+Xxs9bPppAHUMkXoVgQtJLufv3wqxE/Q1NhsjkzA/WYubFdA+bGMA3TPA64vVgRIvjsPkXsQ4+qsoih20yCJz5VqC5FsmYVrVMuzBh42bO6fXBfbrwwwx5Vbn9AOUQ8vukhRFj86KXZuvZ5X3d85hIbyOAHQVN14MjH1edvzJfPG0QWrkK4uKQP3TT+UFB9yeLBGWXmT7WGnN2xRkrx9vaAV5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gm4A0dC/cSIZYi95VVuBQCnE1WnlU3ZJPlPGzxqmmdc=;
 b=qdjnEuZm+PoCkspfNOFNWfGpWz5qPUaQuoTEkOpTbi+fqdQpJTQt+C4lxiilcFDnbfSiq+FGTV+fRSmCE/TCUpCLM6y/p2UBuSMu0zsZ3TVemN8SDX3CAV2s4+WZnt7LA6f2dTjX2Cyu/P/qopUr95wEH9C9IV+34J9UMfEdRrJ6BVu2Nuxo524O9pQxU/y5dJDMca7N0gyUn0b+XTcLZfM0vuag7Io98Q0jH5Ll6bqWVefpOdaDuKZvyIJkomyuTSTVq/N2StADM738facGw9b6wKIZeOjGvklwX1BS5eUtzGbKAADcRCCRvX30ruvmlVg4sgMNeiqiuzwDIZ++Lg==
Received: from DS7PR12MB8371.namprd12.prod.outlook.com (2603:10b6:8:e9::18) by
 PH7PR12MB9102.namprd12.prod.outlook.com (2603:10b6:510:2f8::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Tue, 15 Sep
 2026 17:16:14 +0000
Received: from DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a]) by DS7PR12MB8371.namprd12.prod.outlook.com
 ([fe80::23d7:9e07:1de8:d80a%3]) with mapi id 15.21.0406.007; Tue, 15 Sep 2026
 17:16:14 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 James Clark <james.clark@linaro.org>, "H. Peter Anvin" <hpa@zytor.com>,
 linux-perf-users@vger.kernel.org, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org, Eric Biggers <ebiggers@kernel.org>,
 "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
 linux-fscrypt@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Chao Yu <chao@kernel.org>, linux-f2fs-devel@lists.sourceforge.net,
 Tal Zussman <tz2294@columbia.edu>, Gao Xiang <xiang@kernel.org>,
 Jan Kara <jack@suse.cz>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
 Hongbo Li <hongbohbli@tencent.com>, Chunhai Guo <guochunhai@vivo.com>,
 linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-trace-kernel@vger.kernel.org, Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org,
 Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org, Richard Weinberger <richard@nod.at>,
 Zhihao Cheng <chengzhihao1@huawei.com>, linux-mtd@lists.infradead.org,
 Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Dave Young <ruirui.yang@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 00/16] Remove PG_private by using page/folio->private
 checks instead
Date: Tue, 15 Sep 2026 13:16:07 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <C87F746D-D3CD-4FB9-A50F-A2835DB750DF@nvidia.com>
In-Reply-To: <20260913203959.6b46b0b5a052aec818a7f267@linux-foundation.org>
References: <20260913-remove-pg_private-v4-0-848550f7574e@nvidia.com>
 <20260913203959.6b46b0b5a052aec818a7f267@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::29) To DS7PR12MB8371.namprd12.prod.outlook.com
 (2603:10b6:8:e9::18)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB8371:EE_|PH7PR12MB9102:EE_
X-MS-Office365-Filtering-Correlation-Id: 040b751e-5a2a-4578-d517-08df134d0be6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|23010399003|376014|7416014|10067099003|4143699003|22082099003|18002099003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	EdmOT4SZggvXel11Uhh1H9mF8pJyToiZ4vo+EaL4dQpqpSiRPlv1r32Dgz69iVxRKeRQA2Ast0fMgp+dtSul+ssZ/kJs2D95hmspE8OQmcfALuUDnDqNeKbNVO83v2iXLX1TgKyRNG512daoHu/3lsvC7YFuT9syyAMKYcc8Cj7sRTVCwf7hiclEtUz9K+WYpQE60SsB9HMKu1aGNd+rOH4FuYpR0yN0pEZ9QMKTScul+Ork7mxnVj5Reie3mU3RZve/Igx+fzCyG74c/PU8IYeO3UC6228cv7SfuZEYjtTK3KsezbygJexMLYcjShKX3igAX2GXZzGSorl7Mi9BPwIm77+Sj1aax9f/Sy8vPMzVa8cLugoy5vYsGLC2OtrPq6Qpg8JuCZ2tbHicv6TteAmWCBgMe4ITXR/1Q2OTVdMrlua3hQfyZvShF0+Lt/pkcoExAwGghOwaNgsKpt68C3YDegf81smiqhANEWkXKOR/pLOE7NVTzz6IGCHYv0NPj0srvj9cGTgi+w88gmqAg0OWELisn+6fTDEmj3nFvk2ZKGneX4EdIAGOAHWtDBQTiEdFxiiQtE+G0uXNbgHPDiyTqEXJ97gGwJGOZSqGQ3tTkLHMw6dlf647AS9ptFS1i40d0Stx1d8ifCCWC48sIvnPF7yU5MgpaGtihLIlJP8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB8371.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(23010399003)(376014)(7416014)(10067099003)(4143699003)(22082099003)(18002099003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V3VZVW84WlRLMThCTE10TGpMWXpHUEFQclpFRGgwYjJRQ1luV1BrS0dOcFRZ?=
 =?utf-8?B?a3ZtdnQ1YUNNdXJPSFZyOHY4UHhpRktvOUpXZEVqVVN6c1BoOU95RElsY1Iw?=
 =?utf-8?B?RGpRQXVCZy9Pd01tWDIrdXZnMlB2WEFYRDYvb01QRnViQW9nTmRtYUYvbDM2?=
 =?utf-8?B?dm11N2tIeGVTaFRpMk4xdzlnMFJpUjdoc2lCRlBVK29zdHBFbVNmekhXWHg2?=
 =?utf-8?B?cXRDbi9odVA4cTFWdjFHSURLWDhsamU3NWxtVmNFeUFvc3dNUGsrNHpVWjgy?=
 =?utf-8?B?bVRkWHFQTWdWVGQ4VTRTQTY5MG9reUpLU1RndEg1b0wyNW5aM1NnNVhicmJu?=
 =?utf-8?B?RWVQTytCNmZYSlYzVXkwcm85UDFMSnZrdmRMS2k2QWxIc1dkN2ovd2swNG5E?=
 =?utf-8?B?c01GRVRUcmdCWFhXRHo3UjlyN2Q1K0xLdTdkOFRocUpmMWRFdE5tcU5Tczho?=
 =?utf-8?B?QlNmYXVJd3NFeHliRjlZS3dQUDJYeGpEbk4xUmc5ZTZyb0tRWkVJNElJbHNa?=
 =?utf-8?B?UTZoa1YxWitOOS9lMFZoM0ErZS9ZQ0RjdU9tRHdadVZ6a2h2WVBqNVZudFhX?=
 =?utf-8?B?WEFiZkRsdVpuTStVT0J3bVZRcmt2OVdZa0JMQTY5cm5Yam9ObnVIVG14Tm5m?=
 =?utf-8?B?T05uLzBrQitWWElDdFViR0NiZkhUTExhZzBuV1R0MUVIdEVIY3dKclR0WmpU?=
 =?utf-8?B?SUlYUG1ZNnpMejRZUlVvQTZ2V2tqK0hxSTZFT25kdE5FaFdNZDNsS0dQZXlB?=
 =?utf-8?B?Z0hZeldiNzZDdDhoeWg2OXVUMHI2UWh3dmpmZC81c2hJcmdybHFTbk1PaFh6?=
 =?utf-8?B?elBuMm5LK2Zka0RoUnQraGdMb0hVN0JGUkRsU1RxdVJpWG1OU2VQemU0eTFC?=
 =?utf-8?B?V2pBYWJnSjQ3WlVMMnphQVN1ekQ2RmtuY3NZUWVpcytGSUMwUm5NeFAra2tC?=
 =?utf-8?B?eTcrZG9qVmlLbFM0SnVUdjc1WGIrMGZKVUlhNmg5U0N6ZkZuVzJpbktjSitk?=
 =?utf-8?B?ZWlXU1BKNE1OcDVySWFzcTRmY0pZak1JTWVMak13dzBCRjBuSGMzM3U1WDNM?=
 =?utf-8?B?ZENLQnlPVno1ZUpEMFRmRnh5a1YvMGFQc1E1Q1dTTEZ1QlUxSzI5d2dKM0Np?=
 =?utf-8?B?S3JrcnRpRTVKeDllbVhEK3h2U0Q0OGN1ZUQxOHZGWlcyZ2NFMHA4N0xJM0pm?=
 =?utf-8?B?empNendDUkI3d3J0TXQ2WnJBQm40dEw4dmFpMWNYd09RUXJ6MU9iZjBOOS9S?=
 =?utf-8?B?VHpCQXFVUE9iWXRnVW9ibDdRdDNBTGRncExmNjFBdkdrT3NOdGtDMUs5dzc1?=
 =?utf-8?B?SktIN0dhWXl3cGt3ejl6S2lST1I5KzVpNHlvSFZLaDlQa1NyWHhvS2NoQ1k1?=
 =?utf-8?B?ajVVUzNpcUpPZ0FGdlNSTXk1Y20rNmU5QjNFN1pzT1FuSzBycnhreGJpbmdJ?=
 =?utf-8?B?QVMzbnZ3anExa3J5aVJLK2RGYVFwUEZEUHE0aFJlQlpDYlZ6aWxCd2IreWYz?=
 =?utf-8?B?MnJxOTJsc21naEJjaG8wcWR1U2NJdUg3UERBZEpZbmlTS25TWlhaeExwTU5J?=
 =?utf-8?B?Ti94c2ZEa2VIWTNQS3dpck1zeGhRajlKQnNCSnhRS2Y1Vmo4SmVnd3FUNmcz?=
 =?utf-8?B?d3VZR3VtbFFRbU5JdTkycCtrMTc3SkEyc2tzSWhuYjh3ei9FWllkRUtKcUZj?=
 =?utf-8?B?VkVHRnBpZkprbTB6Q0Y5OWJsUThJcUg4b3hmejhoWkN2ZWFXK1FkM3V2djN4?=
 =?utf-8?B?SDN0bUdvd2h1NWVHZFgraU5leFVVMXR6UGxPVjA1ZzdjRGxycXNqTDQ3MlB6?=
 =?utf-8?B?MVBMWGxyTFF6RTk3SDBySmdvZ2dHRDBKK2lROWF0cGJYZnlteFpwOWIxVEtG?=
 =?utf-8?B?MWEydVdIc2hOLzlxaWQzTzhjck5zajVaSVhpcVU4QmtzV1VZb081Q0lUK2ht?=
 =?utf-8?B?Y0ozMnAzTDFMeWJzWDhwK2QwL1JjNkZONExrY2RFM3VpQkwzRzlYTG94amx4?=
 =?utf-8?B?RXhGZ3R3SzBFeGs1Z2F4dE5FZlh5WXIwQzJYNEw1L2JXU3FCYUQ2MkV4ODNl?=
 =?utf-8?B?cGkyWmxnbHh6R1B3K0krbzgvVHVWbHVwbXZDQzNWKy9TWjVacERyZjRxc0J0?=
 =?utf-8?B?VHBFUW9kNVFhUVZOTWVldlFkVjRQZjNVUjZBam9YM3dBKzViSGFmVEFkOTFs?=
 =?utf-8?B?QmlIZHVFdXcreUdIeWwrT0hma0oxOE1VNjVHeXFMMTJRYXlQUWJ1UStNOFdD?=
 =?utf-8?B?ek1Rd1YzbGxvM1lneHJWaC9UOEcxV0xjS1l5TUJ4V1hmTHM2d0lEUWNWMlMx?=
 =?utf-8?Q?1XlVQwkgpA6kYbW734?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 040b751e-5a2a-4578-d517-08df134d0be6
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB8371.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2026 17:16:14.4277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yP9mlXsqTt1fzeF09feTD+wBnvQ4TzeslAIXm2l/hTA0PyUaCtr/LSo5CBpsWAAX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9102
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A12BA40009
X-Stat-Signature: asxym8c8ygzgzbbgbrftzhgruwnrstw6
X-HE-Tag: 1789492600-319949
X-HE-Meta: U2FsdGVkX1/+DvmXbovODJC7n+y2sLq7g9gUT8ps7ZqGi4/6toE3ahVV25vFAkrt+rzhmkUdjSJCWe8/1/ATE5tuPAyTczJLMLt3sTQu2VrGaaOPQu23EerSWZWVbafLAolVMTUvhn7t+9/kGH1RMf7ljve2Zr48mdsOLXwazQkbHxqI43y4dYEXgybE4W2fNjClWls+l2w/dhs71J1cNwTsujv3u5/WPYi/wmsAWc2Q6q3DnYHQxGKbM4go56fQEOiWqWDDAXUYKlkJySQWN6h3arlAHT2O9YJGQzOHaCGBIGeimcoNADccwD1YFW90uqBSGR0MNYxjxru3sRncEu4uld7hQDfY04S8w0I77sEK64lwIKgIhhiFf/+j+6f9Rt3zaVH6wqk7V2/DMDzXTvoUxRdk6hnlj5hyevN2K+PGongea7Xc0RpS9FXrFpmcNRD4s5oJwuM4IBXbCGQ0a9s8ABpJC+U9DDFQMxBeiFQywON1O5SS6vtz0ddBk+dVW+DipFfDxuv3OGNYRZjPKAaqzYuPCzLP2MZfOMozbFAbCFTAZWo+SEiRcjVlrwYv3sMF2p82xU1+PAKmEc6cHw82MHOx8Y4B+N6V8iyeEW8mU/pXcR9zj10RQotDTIfLWxaoxUtU59z/ETERMXqPoOqJfU8l+/bRwPLeYo+vvAHHs52AY/riy44364EduklyaP8U/IZTN7TnjZsPXRwmN+Nxwfq8Lz0LDxot56BoadX2vFRWASlKLycHGcwPUe0yeINO2EP+pJDL02fQbKDlIyKKxREpsfnoWTh13ewXIal2sfKGwmdSAhiah5J0KTiiC79QI+megncRUdHeVX1aV3l1zIuiZ7U+zW1GcMfAKlQ/cZyRzBlFtjGeTW9cmXNEq9BUBOmf+QKqcUSDKXCy+2/gSNkFDI9Laxl+wdBlKVEA8dEZzHI58SyQWI1tWnh25omBJ7IpnpAwquOVfnD
 Wc98/Xup
 TB9epi/xprvZRkDUMY6+FuuDMn/9OKViapyUc6imyZ5z7aK/rODDLPE0h68NozOuNoYZFvWvEFDGTAoXYwqVTmJICJcHKSdi7ZOo/ii/0H4754tvK4NjpbPad3dQ2g8VKoTh0ShwKsuDIhGGfZIFNWPd2/u24MSQ5b4rDCEAR+tvRp9flihUgwBlWW2fHMKBmMlUKUYTIsof9OS+0IFyI7s/iPgX9j8nFPmDvuVEASSAfNvwlRN/wH0AesxBsyAt1XuC2U+qPRu8ieOiC+Go9pRLUwyYgwmnP+1OlHLVpRkpwO2qPvPMhzKw+lmmXb6cB1U9N981oO1zH8Aq372L4iHqHp64/zDND6RJ/bsK3GFioc+4/CUL98gv1/bA2VOsWfyx17mZVwPlqN14KOZ+ARLitnXoQe/hfGCiXv6IgHqSK+m4XcahBAwD9w9tS5u7aSbXDZSWmNrZoyq1QFZDOosRKgSbXBeWqmWDDcrNl46tgxYMPU3/LAvl3LUn40Pfyqj68Ut7+Z2mS05PpEvz6/Jge5SqNdqyk2fNUqqQ4rBzT3Jb8VprY2av0XEE1sxLjkS0W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13 Sep 2026, at 23:39, Andrew Morton wrote:

> On Sun, 13 Sep 2026 22:23:58 -0400 Zi Yan <ziy@nvidia.com> wrote:
>
>> This patchset removes PG_private to make space for upcoming PG_folio for
>> identifying pages from a folio (more details in Note below). Instead of
>> checking PG_private, all code is changed to check page/folio->private !=
=3D
>> NULL instead.
>>
>> MM people are cc'd on all patches and subsystem people are cc'd on the
>> cover letter and corresponding patches.
>>
>> Patch 6 is picked up separately in f2fs tree, but since mm-new does not
>> have it yet, it is sent for MM testing.
>
> AI review claims to have found a pre-existing critical level deadlock
> in f2fs:
>
> 	https://sashiko.dev/#/patchset/20260913-remove-pg_private-v4-0-848550f75=
74e@nvidia.com
>
> it also had a few things to say about this patchset and, as always,
> hugetlb.c.

It seems that Sashiko overwrote my patch reviews with the reviews to
Matthew=E2=80=99s md patches. :/ I wonder if there is a way of recovering t=
hem.

>
>
> Thanks, The MM bits appear adequately reviewed and review of the non-MM
> bits are, as usual:
>
>   Great to have but I won't permit lack of other-than-MM review to
>   block MM improvements.
>
> So I'll queue it all up and shall push it into -next after a few days.
>
> Acks from non-MM maintainers are appreciated.
>
> If a non-MM patch appears in linux-next I'll autodrop the mm.git copy
> of that patch.

Thanks.

Best Regards,
Yan, Zi

