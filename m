Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03129C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 18:13:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8D66B008A; Mon,  3 Aug 2026 14:13:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E42EC6B0092; Mon,  3 Aug 2026 14:13:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4C46B0093; Mon,  3 Aug 2026 14:13:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 962066B008A
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 14:13:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 08B3B1407E3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:13:31 +0000 (UTC)
X-FDA: 85060755822.30.5516124
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012056.outbound.protection.outlook.com [40.93.195.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id 21CBEC0009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 18:13:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gxRy5BNS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785780808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRjbsBRIUTAFpugKKLOjSbZ6YnFTaZPMTTSy9l9apTE=;
	b=Lmm1yagFEOS+AWTJKv1ZTszD75Kf0P2MgRWAAqHiwvw/omMoJh9CAAcrYHj38hFwaYuUle
	cQriKcf7AgZk4EPaM6PkueQgyjYNwL/uf4Wl4GRlz5qd4TKyEGV/bXjny3KwRJacpnveax
	P9G9a+WJHcu+imm9dUcC/RNs114xSyc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gxRy5BNS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.56 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785780808;
	b=7rXePdcTcSgQVCuEunTsbEadNLBzH9gUenwI/loJrgclECwZaLcRAE/yu84HivZ0aF6hX6
	C/NguS8NqDU8nq77GVTDd6g3XdkBWwvfb0WUt+zR9ZIpqgHgNeoWX+44KG6uRf5wkMBhtI
	AuNwAoUDYV6RbqJmXGDpkY+LzXF6Aak=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WD6ZOUp+WnBpKUL/Z/T7kHJS3gdbMiHPaDWLnG+FW2Ughc5kivpbHAl9m7v4kZtUlwne3dtTcxUKM7WrJyBjIzNunVwJE8YCw5xf460FYDTOx6lI06pdu9THT47XqNLtDLCdzux8qTLf/nbRDsOOv/8gNbNU4E2T2QAuULs2fA5qQHbM4xHgZv2o0OOWsIgB9IrcShazm0DicLCB2r0EQKH4D6YFHM6X6V09ySI5OEc6n7D3GLeeZQVOXqxWW+VbyMV7HL3rN70ZTujV0k0q4aAXFKUkqMGPn1t6bGDJN5lRp550zxCce4yQxpsqpaiJjD8UiJnfV95Vbq8C+ISS6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eRjbsBRIUTAFpugKKLOjSbZ6YnFTaZPMTTSy9l9apTE=;
 b=axI4QwD0gDNm37sbZwPepJqFwCIiAQLsRb16JqMJC18kzIbTrEGCymZhb+s+VT3do6EhX/NunZoNzoqNMzdrVPiKGAHzZxXxgE3R9xuo+1Gti7a03F9fRjGK5P50Lt8AxaBXztxd5r9zFCY/UqUcakRm4oUcNJdIAnG/3xc01xoOvlR1WiMD7tpFinSy/n/j8hqvWefCeMnzCgHYzYcPJ8uU/jJoPnMGHd/+YZPkn0JJ2U3O95hflOwGfyepG+2jZsgsMfbSa132CavPOtTL6zLMDpd6I+fzR/hlKcTK94MwK5Xl/bUCYD9mr9kjrEYXGsa4Ph7cigPFSjEaaRhp/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eRjbsBRIUTAFpugKKLOjSbZ6YnFTaZPMTTSy9l9apTE=;
 b=gxRy5BNSr6u+YqAfadGamez0ES69ulGmVjdQ7wL80choytSsnxQAlwikJcKnY7d7Uw564V87JyMSSqEMqm6I3eyQ8hHwQgGFREoi4hLHlGzS9JCT9FEDSrgt5yoHWS9vKZEID6DWzvgO/uM68mWZ19n7kvMB+gzmij0pdwS5RPmRbSJIRi0JMJdUya8s9PYMz1a0gliFwwRvb7ymFruUVGm7IrQhIxbKxZt2k3pI13FRQ2A68aYiDbfeVVWpfh3Mmt76rm/50mIM4i03A/9AFOI/h98bANBM9Ic5xWGJvoXq7pwmi/JlRG0WcTtM7QctGHIP3ZNoYVG8sNcqXB0SMA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH7PR12MB6935.namprd12.prod.outlook.com (2603:10b6:510:1b9::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Mon, 3 Aug
 2026 18:13:18 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0270.017; Mon, 3 Aug 2026
 18:13:18 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Aug 2026 14:13:13 -0400
Message-Id: <DKFIGJBRSDB1.O204NIB7HZMR@nvidia.com>
Subject: Re: [PATCH RFC 00/14] Remove PG_private by using
 page/folio->private checks instead
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Minchan Kim"
 <minchan@kernel.org>, "Sergey Senozhatsky" <senozhatsky@chromium.org>,
 "Peter Zijlstra" <peterz@infradead.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Arnaldo Carvalho de Melo" <acme@kernel.org>, "Namhyung Kim"
 <namhyung@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>, "Borislav
 Petkov" <bp@alien8.de>, "Dave Hansen" <dave.hansen@linux.intel.com>,
 <x86@kernel.org>, "Mark Rutland" <mark.rutland@arm.com>, "Alexander
 Shishkin" <alexander.shishkin@linux.intel.com>, "Jiri Olsa"
 <jolsa@kernel.org>, "Ian Rogers" <irogers@google.com>, "Adrian Hunter"
 <adrian.hunter@intel.com>, "James Clark" <james.clark@linaro.org>, "H.
 Peter Anvin" <hpa@zytor.com>, <linux-perf-users@vger.kernel.org>, "Stefano
 Stabellini" <sstabellini@kernel.org>, "Oleksandr Tyshchenko"
 <oleksandr_tyshchenko@epam.com>, <xen-devel@lists.xenproject.org>, "Eric
 Biggers" <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>,
 "Jaegeuk Kim" <jaegeuk@kernel.org>, <linux-fscrypt@vger.kernel.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Chao Yu" <chao@kernel.org>,
 <linux-f2fs-devel@lists.sourceforge.net>, "Gao Xiang" <xiang@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Yue Hu" <zbestahu@gmail.com>, "Jeffle Xu"
 <jefflexu@linux.alibaba.com>, "Sandeep Dhavale" <dhavale@google.com>,
 "Hongbo Li" <hongbohbli@tencent.com>, "Chunhai Guo" <guochunhai@vivo.com>,
 <linux-erofs@lists.ozlabs.org>, <linux-fsdevel@vger.kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Masami Hiramatsu" <mhiramat@kernel.org>,
 "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>,
 "Wei Xu" <weixugc@google.com>, <linux-trace-kernel@vger.kernel.org>, "Trond
 Myklebust" <trondmy@kernel.org>, "Anna Schumaker" <anna@kernel.org>,
 <linux-nfs@vger.kernel.org>, "Song Liu" <song@kernel.org>, "Yu Kuai"
 <yukuai@fygo.io>, "Ilya Dryomov" <idryomov@gmail.com>, "Alex Markuze"
 <amarkuze@redhat.com>, "Viacheslav Dubeyko" <slava@dubeyko.com>, "Li Nan"
 <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>,
 <linux-raid@vger.kernel.org>, <ceph-devel@vger.kernel.org>, "Richard
 Weinberger" <richard@nod.at>, "Zhihao Cheng" <chengzhihao1@huawei.com>,
 <linux-mtd@lists.infradead.org>, "Baoquan He" <baoquan.he@linux.dev>,
 "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav"
 <pratyush@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Dave Young"
 <ruirui.yang@linux.dev>, "Shuah Khan" <skhan@linuxfoundation.org>,
 <kexec@lists.infradead.org>, <linux-doc@vger.kernel.org>
To: =?utf-8?q?J=C3=BCrgen_Gro=C3=9F?= <jgross@suse.com>, "David Hildenbrand"
 <david@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Muchun Song"
 <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <5ca4d0e4-1747-45a7-a916-a7516bb1692b@suse.com>
In-Reply-To: <5ca4d0e4-1747-45a7-a916-a7516bb1692b@suse.com>
X-ClientProxiedBy: BN1PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:408:e2::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH7PR12MB6935:EE_
X-MS-Office365-Filtering-Correlation-Id: 22480e3c-b594-45b3-2d38-08def18ae4af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003|921020;
X-Microsoft-Antispam-Message-Info:
	FGtzsi0Ff3pxghP3lc/P1ddrXZKj3w8+yJGJxor6kKDLvhXg+qE0BqULU2Yo4OHklIfrWOBiiWaCcUZnd8ysXvfpjMQVyqBTVvH/b0Q17IDGUvQ8gt4J4mT1pT8nL+gY1FWLJGaajKiB9bLXL2OjTnlzpUnhjYKRFUTTC7RGTKyqFnabJILfF0z8AU4m783vOuMWi1tH6BS67AbjJ4dVCwGPtnKldp5SDaCm2TxXxeP2ZK6wfMDiS18Gr47k19fmlmm0ZUGj0jp67G22umHBdhIuM/sszkroYKwIza/1o1owYO9aVUG8Kv5LLxa3I2WUu8Ak6QcEoCd3A2d3jHYGJW/+RNZgWm8LAjH1uSwDiuMBOFm3gYnB13ZB1YWOVqPwQNKUBqw2XePEUHqKE4fOH9Olf52EBU/o/jip+pXcqLAnmKr38c1u8C6/5d3be9P/UcA7qVZ6LQVHh1HhK+V2a0F4TWz2ERZK7VcaT0nO+9jiux83RgoLv9ibtvBSCrNZX0SkURZ0XZaQ0oYH8g5uGiBx9GzWnhS4/uZIqjBS3kSthtIogVRo5UtaDQmHcm2QBw0H8x81CRrgqFRLK1h46fKWbpTQB7QQyeITnN19I+9mhcOVt1PKHVji0hhO+J6TgRKcsFzS5/DlUr/Fqyiazhpd1b+TgYpo1iieuX06GMveH1pyl1ECk5P3tuqWv1WNYZcGmnoPQLT79hKI5uGaSg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TXNoMVUva1pWRkd1aHNpSk54cGxMMXZJTnFmUUFPbkhLbnlRdVFGRC9Ueks3?=
 =?utf-8?B?aUZnZGZMSDNWdS96ZWJFRUNiQzRtejhxdjRJKzRyaGxHUVcwMy82UDRMWUhm?=
 =?utf-8?B?Q1VCeGJNT1YrbjFDa3pMRFp3WE9VekNKMG5TbXBaejhIK05pbXZwcEVjZjdr?=
 =?utf-8?B?TlRyV2JuRFZ6QVlaSm9iRWlPUjBTN1ZsTkwrcVcvdURjSXFlcXVHdm5rYVBy?=
 =?utf-8?B?cTYxazVUcVFFR3NvZU5jQUdjUEhHWVoyQzFvUTRUZDZJdjhRL0hPQ0llVnoy?=
 =?utf-8?B?ZXRCMzBQbWNteVRPemNMQ3hyTDNzN3UxU3ZkM3h3Rk9BQ1N3TTl1Zzl3NzE5?=
 =?utf-8?B?SHNIcDZ2S0RVRzNjVENoUVdWZzVXUDJpNzRockZoZjhzT1ROWXhxQjJtc0Nj?=
 =?utf-8?B?QTRHTTh4a1E5eGJuMWpwLzY3cko0bSs2WUlTQklTekE1Tm9qRVA3dFRmbmRS?=
 =?utf-8?B?d1Z1eUtZNmJ6aWlJbDBGNVVOb0JNMXdqbEg5eVZlYmJyakxzenB6cEt1OVA5?=
 =?utf-8?B?SFVBYTllZkhOQXlwU3JZend2NjNLVGxVWmt6b3FlandDdHJrZ3R1Y3N4RVNt?=
 =?utf-8?B?MHdCTmpsNTc3b3lLYnkySXlhZDVaQVZZQmZFTElscUdhakFGd2xibS9NajVV?=
 =?utf-8?B?TmxCYzk2bmIwLzZXWnF6NFhsMUFHTUZMMGN0R25vaFllczhkVXFaSVdtZyt3?=
 =?utf-8?B?MlJ4NXA4VFVaWUw5c1FvMXg0UWdLUkxKUk8vMWlBeUJ1M2k2NjlFcGc2RDc3?=
 =?utf-8?B?aGk1em1DbnFlSUN4b3Z0S2p0UlQ2dEdhRXJaZ0FhLzVkN2MxQS9tekRKS1ZR?=
 =?utf-8?B?Vy9tRkpMWmdaZ3hUcGtDL2lPTHN5YUFpa1JJY0N1Q2RCWVUvSXlCRFJpOEEy?=
 =?utf-8?B?YVFkb1RHaVVCcm9oNU1wTmp0ZHZDazQ3QkRoTDRwR2gvT1gwUW1VUzd1MTR3?=
 =?utf-8?B?dHBzZXdWOTkrck81QXRjUDVHOFo2ZUUvazRpc0xYSDd3MUg3V1FGZjV6dVA2?=
 =?utf-8?B?VlhRUHRaOGJ5SnlTT1d6WUV2TG5VdHA2R296TW5KZ2pnWGtxbFpqSTZDeC9p?=
 =?utf-8?B?TDE4TFRzMkwrMmhrR2h6dTZwb3hXYkxTMkl0Z0dtRmE1RFNtZDZ3eHpGdDVG?=
 =?utf-8?B?N1Q1SWRvQlZEQzhlUHhzSFMvc3JkaVliZG5OZlZySGkrYXl2UVlJZENtR2NX?=
 =?utf-8?B?dUc1cWNRYjhidlNzN0VOTFBwYUpwMytFRmJQejc4MXUxNnNWaTA0MytrYm1W?=
 =?utf-8?B?U0NCM0gxSlNZd0tiTnJoeTIzZGlxYmdVajdqeTFOYVdKcEYxQXhqdU9aVVVK?=
 =?utf-8?B?NDM0U0xSaTdBT3NrTWpxdTFldTdJblVLbGFvanBSTW92cVhBYmhINnFlNDY2?=
 =?utf-8?B?WWRPSGIrVUh6Mm5sY1RBS2huYkwxZlJnMkNmQ3pFUitwYUg5K2drOGhMZEJH?=
 =?utf-8?B?VFpldlFLdzN3NXJYNDVWa0hSaGxiaHpQWjJlTFcwNTVxbG1uWXdlcm1HS3dj?=
 =?utf-8?B?RXhNdkRSTGNxdUVhSENVeHB4eGZZeWFRbnZFczdZbFNNMkl6b3pjT2tiK01u?=
 =?utf-8?B?TGtwQXlxN3lIWitmTUpiL3Vyckw5cHdHQTZwT3NrR0t5ZEYxRERQZVZqd0hX?=
 =?utf-8?B?MlFiUTFCNkJ1UTJPTTl5MEkrS1d3U2hTQnN0TExUdUxodVVvelJ2VFFDb1ZH?=
 =?utf-8?B?cEJ2YnhIZGtRSVVSZjRoWFU3V1o3NytYOW5COXJ2dVR2aUNQMmVoaHg4ZEFy?=
 =?utf-8?B?TDhGTXpYUEZTVUM3dHA4SzhKYjR0ZVVVbEROa3BrR3VHYmRVRlVHYS9yU0xl?=
 =?utf-8?B?dzc5bUlPWjM2R0Yvdm4rc0xLRnZZd3hYbnFDVG9BeEN6b2dqa3dQVDlHV3g1?=
 =?utf-8?B?dTBhWGpyVStjODlOYmJlUkJjVVM3WS8yaUtpaGhDN2M5UjhlR01qZGdVdmRZ?=
 =?utf-8?B?RHVuZHB2K2FFQ0tPSXFLdW10cVZsQ3ljSGNIbm9GaGlzb0lETi9WcmZ0ZHZC?=
 =?utf-8?B?cGJpQnpFUmpLc3UrRDNMVi9kaHloUUVhdjhTb2I5dUNWVFc3MlZkbmk0Z012?=
 =?utf-8?B?MmtxVUJOSnRBTElMVGNQeUJaOXhDbGNrSElrdFQ5VnAycDRrS1c5QVZ3VXF2?=
 =?utf-8?B?NGd2TXhnK25kNFhtdUwzU3RoWE1BaHpnNzYwVW9nek93dXJNaHhNMEo1QlFz?=
 =?utf-8?B?Q3haWDFpZkhkL0FXRlpsQzFLUzZiSHRYYTlvUWRXbmRVY0tpRDFORG9CaDBj?=
 =?utf-8?B?OE9CVlZrcFRhWDhTQlZ6c0Fnc3BRdmRZeHZQcWhDbFJaZlFrcUxFZTRtVVJl?=
 =?utf-8?Q?vOMDLuS+uZ6B+uZb7U?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22480e3c-b594-45b3-2d38-08def18ae4af
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2026 18:13:17.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P4jLnqIwTNmEW1LtTpM+2MhjKsFG8QpvIYdQ6DM5UZU3RRUlEMTS746tqky9GXuA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6935
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 21CBEC0009
X-Stat-Signature: w1gqwkxr3fzncx6rz4xmz8wd8ted6j98
X-HE-Tag: 1785780808-152455
X-HE-Meta: U2FsdGVkX19pngCL3LdgqBmV9nFJU0KT4IFZ/hM6kwBYLa6JNzggcjb3OFWXa8a1roWrFH0uNslagg3/Dun1FAiCQkQXxyY038/pZ3JYsXoiVlYpD8ZVd4fKiqzQtI33gGXQmS4rfAuybbyOkX+pNTV4kSrKNQ1V0uuVKkQwglTc/wJkFUOc5gZ0fV/ckp2vEbGZmK8+p8Wc93ewYHrRblh0yY4OfJ12Rkk9VpRmq+U55bxoGyQ+4tf5LPiXoTLIJ2abe8FsxrifumSiaa8OZoyzXVroyKvi28a9PUM2LIKjMhq28Sq5sEHzhiWlxgQaT8UIbs5IOuq1njjOz0ndwgUXhgAGmvqyWXL5ioVlsNjXH2AG+aS8OjliRXHea96FKXiQsuZOM2jLuuC87Ia4Ml+4R0zWjOgMjw/OgY//vLaddqO73lyGXSh8wrthh1wi1yafopzrnedGpZlzoM1dLNmVa7N4+Mgfs9a4O1tuybWzShuVHMLxJPH26l+RtPw+uVdbFauatzNiG1U4HMEQPZGIaC8yYphJ4Pr8QVvwINRwHoMXS2y8T+tMjBVUcw9+iJS2om6c1AxG1O6Tsg40WHyn1Wso17GztilkMz96R1wRJx3cHhL6DBHi4TeS/qnwaA7zfSkwbBbUAQ9aBZTggp055D5AygkKf0gLUk1v+/E55qChcvCn+zSeooKWnGgy2iaiqxtia1cuq1M22r0w5zVeM0J3gJAS4jLU8EKFlXfc14EdsosHpSpd0U1wJbMHWiwFaTl1VRNVrJJEO/hbKkigwiXJTZeM0raBl/sH/t17QC8uWQT8DOR0VI3FocUx9tbfvMWIGUUsw02ueI2lz7U/s9MVDVTrdUJk44tKMfWk8NaRaoaAmept0H8jEjn3wIKe1/WN3/ADW75N2I180FnoiRLXHYc1U7RATWSCjwRM+ICuT7Gy0mN9mdKyhS7nvipgpiXTec9pgMlZPMO
 BkiAH8XB
 N8lZ36oxzRAx+QjRvf35fpoQkyFgLcvLpQ5q9rDcDuWmG5oKjGhwKr0gCUiad6jWxCDUfPL6j4fpXacBV0Uo/gHsDN00bV5uWwgxalEO2TN7wjybbS7dOBVumZn1gCoulPMAEEO4dGlNEs2SMxIIUQkOwCZOgaSHWWOdWm4mIrjWAcy1oAzNI66Bq/QQwWzfJzPrUWBfdQl0fwHj9eAI/vs/LxXqwDf8tkMe4UjG7O/GYt1laEZm1ZitrR7pv/sar/H6VZzi7+Z4yIUArb15igXN/a76JU0SCSM5Q+J+rrg6a6/ENuNNn0MUV1ylm5OHzTrQmCOti+cvcapLEejd3jPrjDXTkwaJ/DDsfMDslDzeGYbsYVQYp5UdE3PpTbGhHFo3WdaBFDLjToaX1Kc+SHDkisxNekby9wtGGMeU00+Z0ru3NBfq2fphvCEAb47qlbnI5RHrNEtKQfYCdqgk/ME4IJQ9O9NYpNlKLNFJmJrAxUxTNalyhFxNbGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Aug 3, 2026 at 5:07 AM EDT, J=C3=BCrgen Gro=C3=9F wrote:
> On 01.08.26 04:13, Zi Yan wrote:
>> Hi all,
>>=20
>> This patchset removes PG_private to make space for upcoming PG_folio
>> (reserved as __PG_folio) for identifying pages from a folio (more detail=
s
>> in Note below). Instead of checking PG_private, all code is changed to
>> check page/folio->private !=3D NULL instead.
>
> I'm a little bit worried that page/folio->private is in a union, so today
> it could (in theory) be !=3D NULL while PG_private isn't set.
>
> Is it really not possible to enter a path where PG_private is tested whil=
e
> page/folio->private !=3D NULL due to the union being used otherwise (PG_p=
rivate
> not set)?

Yes, it is possible. See: #5 in the exceptional users: erofs uses
->private for reverse linked list and in-flight counters without setting
PG_private. I get rid of the first one and converted the second one to
use folio_attach/detach/get_private() to follow the general ->private
use pattern..

For non file system folios, anon swapcache puts swap_entry_t in
->private and hugetlb puts its flags in ->private. I added
folio_test_fs_private() to exclude them, but this helper is planned to
be used by core MM, since filesystem code should not encounter these
two.


--=20
Best Regards,
Yan, Zi


