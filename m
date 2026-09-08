Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937F6C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A1B6B0099; Mon,  7 Sep 2026 22:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F90A6B009B; Mon,  7 Sep 2026 22:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84DCB6B009D; Mon,  7 Sep 2026 22:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3566B0099
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:56:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C8EF51A0351
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:47 +0000 (UTC)
X-FDA: 85189082454.13.64C07B6
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010044.outbound.protection.outlook.com [52.101.61.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 04F1D1C0003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:56:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O7zqGrJi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788836205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=0/+loFgTpB5WI64K9N4RnP70y5sRGMjPtenQs1tbBDA=;
	b=EmNu+ukNIi//LzaAewX6sg/Zmga3cC9bExdDBhJ+RBF5OS1p09PDUuAEDThgJKsD3w9kxt
	xatWIBSQb+rBXHmCXWOA+KPJE/U5ABvLFJzk+t/iFtHBo+Qg0gUwN9gHIjkeocXJrgW718
	uY1vgd9yJsUe2bHhRVntZwUzP7LUmo0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=O7zqGrJi;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf21.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788836205;
	b=CEJ+V0P1Zc6upME2zRTCFd/N3KvSIr1ifts19Nu9DEMTbr7vYA0ZhXjoTsPkCxMwQ4m3Xg
	0XraRXpZYAaknbSFE3R04r809HmmnSxCRirip/6GA85p0qyE6bw1Utg43US0BZz7SMOctj
	WWv6QhMUGiPLPP8/8SFX388Xwpd57zs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FNLKY/TL9ihjVf2a51ONNvLPuDvfAHEdEwlp53OPvKoYISnQQCA1Pe3CuSbYICUW75wUwpeq4vqynBY714801xJh2vGx0V302o5ftHSglYgVDCUyLqlubRlMBRt3M/du4b95mEDv/WmKdIeRZxufODQNX0K/jxby0sWLM/+kSf4LndFxaTIVE44HayniZ9TespyJWKuOrV1dkjkGd7Binj3Nb2Y38hxDZwCAAoabkSD6wvnhgSwv0K2NlbS4hrf/ZCHMNqQsdvJd89lIjHxEUEbqG7xOR7CQ89JaQNBRfuM6GY33kpv5qRbsasVCoNQa5C7mihcg97TM+rEAj2xsxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/+loFgTpB5WI64K9N4RnP70y5sRGMjPtenQs1tbBDA=;
 b=lTeeySTtb4b/YkEw9x3cLjYc0qImguU9uDMHWRKpgl+r3iioTtN2l5VS0TPf2FqB82Zw8VfxqaA8LnUnUMnEJEOXI40UVp7lobphhdoFnRRsTwiakI8PrpUn4VefNlAvMYTCK8vH4qXM5c3XxfuXO4zQor7tF/YNB2N8H2eZnH+Var5a6JLgL173TsC2Z8d7LBC3Pq1+VqdlkR3g62QHWBruGh7IkdaubyHRPPXGjl5d/TJnpodOEJToSHKRn4hJcOzAp9VdD6n+g7MtGBn6EhgLMKakXPsJzxrdCtTNzU1GfwdSWmnpxGJqfpJqwMIy1OPonfEY9IPzys26aoA3nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/+loFgTpB5WI64K9N4RnP70y5sRGMjPtenQs1tbBDA=;
 b=O7zqGrJipndOZP+iH4uMuHVRC/jFfGog+WpzDfJc48qIu1XEmMioqbdt1soIAjrJi9tD2laD1hutZUAdLf6QmmC8EWG8ZPJSGgIXVl/5ZzLy+XnpQJ4FXR6k+8e35lfIafxsS4BC/tKH/fwqoaWpcREealRy0eT0Ij2bKudWYOXRyl/wKtFIdQNhegY+kjBoCKrd7uYIJ87o5ts0MnRt2YEsUJ+RtX2KPa/+wz9rHaBBOpye4ptOGIkLndknWWTy2+oCBMqu1uC0rgV2A5hG4gm+HWonFtSV8vddbrmU/bBfTmLQ269DUCpZ8nZ592kK3WNDA6sPi/FZ5M0e/YMbgg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM6PR12MB4435.namprd12.prod.outlook.com (2603:10b6:5:2a6::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.382.15; Tue, 8 Sep
 2026 02:56:27 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0382.014; Tue, 8 Sep 2026
 02:56:27 +0000
From: Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 00/14] Remove PG_private by using page/folio->private
 checks instead
Date: Mon, 07 Sep 2026 22:56:07 -0400
Message-Id: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23N0QqCMBTG8VeRXbdwZzm3rnqPiFjzqOciJ5uMQ
 nz3pgQRePn/4PzOzCIGwsjOxcwCJorkhxzyUDDX26FDTk1uBiWosgbNAz59Qj529zFQshNy16I
 B5epWS8fy3RiwpddmXm+5e4qTD+/tRRLr+tWk2NGS4CUXJ3CmflhZKbgMiRqyR+efbOUS/Ai9T
 0AmpFJaVMY1BvUfsSzLB/oTPbj2AAAA
X-Change-ID: 20260728-remove-pg_private-cfe926c7f83c
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>, Minchan Kim <minchan@kernel.org>, 
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
 Gao Xiang <xiang@kernel.org>, Jan Kara <jack@suse.cz>, 
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
 Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, 
 linux-fsdevel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, linux-trace-kernel@vger.kernel.org, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 linux-nfs@vger.kernel.org, Song Liu <song@kernel.org>, 
 Yu Kuai <yukuai@fygo.io>, Ilya Dryomov <idryomov@gmail.com>, 
 Alex Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
 linux-raid@vger.kernel.org, ceph-devel@vger.kernel.org, 
 Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>, 
 linux-mtd@lists.infradead.org, Baoquan He <baoquan.he@linux.dev>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Dave Young <ruirui.yang@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
 kexec@lists.infradead.org, linux-doc@vger.kernel.org
X-Mailer: b4 0.15.2
X-ClientProxiedBy: BL1PR13CA0376.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM6PR12MB4435:EE_
X-MS-Office365-Filtering-Correlation-Id: f5a43f69-1177-4e40-a343-08df0d54c6aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|23010399003|1800799024|921020|6133799003|5023799004|10067099003|56012099006|11063799006|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	DFa4PsxrZxBeb2/5wrXjfZDIHi2Fxy5+95qvY6K4FHW1tGYNOuTnl0W80trBtV+yMqR20GMCuTgFr7jFXcNEmVzhUYPAo027yju8Vx8gRqUcB+HEeQIptn/BNF1M2gTahlQnDAjgZ1/7THy+UX6nw2ejea5UInnMW5HhPRVMTAOyfICe/ya5H/gVoTCIMTledsODGZHVBYq7eNHD25KQ2GLYI0p/4QzIptdrvqJ89u4P/Cmg2sYCOS44wtcqJFMO3E4+Gc0QNeSm6FmDKV9HuhPkcOGKidN2Uk3xf/LGljecrN4+ePb0TJHhNXaEzTYCJjHU2sh5N5IJEZKT9DyaF5FLJcUiXZ+Vu5pvTGykaT0fVMnLXB2ykNEDDChCUP/P5gPd+UWNCnPVmW+wG3jY1tjDAJDQZ8Y4Tw9WQ4N3Za69ZGQEHPcoKgWN8EdXlh6QFhDag1F4I13DZvFbkNJDd0wTgp3uAE9sXC9BdB0R6wjKihtaEqmWZlXl+Apul6nfDUVeSp9cnZGCmobaPmOm6VphOHAn+wqKtQvCDuQ/4LvGuWIDl29E9xye9CdVGd8AonXkh3hIaL5KTr72yUqyS4+cD6kawxp5eavsy7pDA09skWDfYkGrCQuWjrwgZazW3JQXALmF24ITJylhDA244hv+dhXgFOM5ftIrMEpncTy1cE49CJOt5h8rABb1CEKW3lf4jTlhiR8tLDtRPWDFFw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(23010399003)(1800799024)(921020)(6133799003)(5023799004)(10067099003)(56012099006)(11063799006)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?c0ZkUmxZZjFYTzVXbExEWUhiMGkyWk9VWjc2aE1yTUl4UnVURW1lZWY2RGNW?=
 =?utf-8?B?S3ozbW9vV20xazBDUVFzNlFTRkRYVlJSQUhFS3pDTWVLZGNLQ0prd1M3R2k5?=
 =?utf-8?B?MlZoc0c3ZHFXMGRkSUFaejlWQTNLZm4xYUp5TjZPNGZEczRzUy9CdkdOa3o3?=
 =?utf-8?B?bStheEdaSGlQNnIxTjdZOXU5em0wekVoTjcyR2Q3TStmNWVWZldQSGRVRXRP?=
 =?utf-8?B?VkNHWHdMZFU2ZFBzOEpQNURzYm13dXVBQU5wSmtQQXc4dHBmc0lTeVJKbGJo?=
 =?utf-8?B?TkxMYW5uNnZRUWlweDFORE5sUERQeUtlcTdLeGEyU0RNbTltWndwR3l4L2ZO?=
 =?utf-8?B?V1MybllhMUtlYlY4Z2ZlT0VtOHpkTktwLzJEaFdnVE1lMVdtR3BMT0dlaGly?=
 =?utf-8?B?NXdGWUl0cHR1anRVcy9MV3M4dWNVSWx0QmtmSVZ6NEdYcmVCbUJQaDY4QmRk?=
 =?utf-8?B?alRQOUZYU09PZ2pva2c4YW1FeXhBSDVGMFRzM0ZyYnVtQ2dWemx0bCs5dW5u?=
 =?utf-8?B?eEorTENjbnRKU3ZIWDZKcldBR0p1R2dTV3ZZTVdPUHJuWjZRUUUxWXNlRXJj?=
 =?utf-8?B?eTA2VzFtRjFSMGk0OEZLcDc4QTJIa21hZmJTNUoxZlpzQ1d5V3FvQWxxWWVO?=
 =?utf-8?B?Qi9sczVsU2Z5K0p1TW5GTnJldUtjc0hEOWdSbWtWcGV3RnhtSGlaOUdQWW9x?=
 =?utf-8?B?enhzRWsrMU04bDJzSlUvNm5HY1M0OE1GY29VRjk1Z1FsNDZscVJIMFIyVHBr?=
 =?utf-8?B?bloxSUNCRXJLWnVQMHduZVdEZ2EvVzVvUDJva3Z3UXhaSmpUU1hsZG53aG1D?=
 =?utf-8?B?Tmt0ZmNJQjY4WkpMdng4TWt1MmFHZG1QQi9Wa2dXNzc5NEdWdnNqY09QbUw4?=
 =?utf-8?B?SzJPbUcycVpvQmtiS1c1QmlWRUEzMGM0OGhJVWR6RDh2ZTZNbWppSjlBWGdi?=
 =?utf-8?B?dTkrdmFja25tekpnYXROSFJRK3FtNWU2WFA4TkE2MFBPeTZsak5ZTVkvS0h5?=
 =?utf-8?B?dVZheFRqSUxJSXZSSHc0dG95RXVVVnMyYytBUTNoQ1QrZUZ4M2xuRVZ6Y2F3?=
 =?utf-8?B?T0VGcFprY3lmbkNVSksrUEVBSDkrNTdzS21MSzB2VEVRUFNQNTgzcVQ4S2Nl?=
 =?utf-8?B?Q0VGUEVOTk9MZS9Ebk02azhaQkNrQTM2ZVFWazNBUjBtS3gzdlovR1lGMk1r?=
 =?utf-8?B?V0NKaytEQzMvNlE1UGJJTEFnK01GQ0J0d2lCNkxRM3ZGRWJFUGw0UERDdVEx?=
 =?utf-8?B?UVFMaWV4NERCU1MvZlhIbEJuN1psWXBvSWJvNGIrdW9ZRXlhemZuckltOFVr?=
 =?utf-8?B?NHUvSGp6Y2psbWRhcVdZTkFsSDhWMkJHNEc0eUtESldzRkNmb3NiSFR6akk5?=
 =?utf-8?B?UGRzcHNTaGpFRVMzVUlnSmJ1dzRuL0NkaHVTWk1OSC9qNU5IVk9CQWhvQ3dZ?=
 =?utf-8?B?Sy9aUHJRNWtxWlkza0RqSFVOL0FYRTVINXF1YS9vVTRyM2l4RkZBVXFpSzlk?=
 =?utf-8?B?c0pNTGtVOGRobTBkWHZCeUc0YTFybUt6U3c3UlpObWpoRWlKd3k5MzVXdjZM?=
 =?utf-8?B?cHNFSzFRL0JpV0ZOUzlRY09ldE94Vkg2RzJOZFJ3Y2IyTUVjNURyRzZMNlNw?=
 =?utf-8?B?MStzSG1nZHIvdEZLdVJVQ25FYi8yTkRKaFF1OTVQUlNINXJOVXZJM0JuczhN?=
 =?utf-8?B?SjRIVFJNUEpqNFlsc3FlTWUvaVBodTN0ZVZBb01zYk5YdkJzUDdGNVVtd3RV?=
 =?utf-8?B?eFpKY0g5MTN4NkhxM2ZnZUlpeTBvMTQ1WTg0emFadi9heTRORGF3Y2pqU2do?=
 =?utf-8?B?US9PaTN3VnJTYSt3MHA4R3FsN1JYS0dqTWRpdFdwU0ozNEJKUHd3djNVMzlt?=
 =?utf-8?B?cmRjN2htTDRTajVxc3JhYi9xeHg1WTlzeXc1SU9jWmxTeTNoRW1IWjRRMVBR?=
 =?utf-8?B?VVJCYVRaSVdiL3JYaVplWnJmNjFFUW5zclArN3J4WTF6YUx6WFdDYmdrNlVt?=
 =?utf-8?B?c1krOGFHcVlNblRFUkFESDBEb2tHc2VXNTBVTUY5eTh4dmZieHJpUGQ2K01n?=
 =?utf-8?B?UVlRUWdUOUVSNmhiRmYyU3dLSnJIZ05vRjVCM0RpZWtPRTUwT3NaRHFQQXJL?=
 =?utf-8?B?cGQ4MzAxQ0tPRVhBa3A4dC85bVlNRElEd1JMUUJObkNqRStQeHdzMm1uNThS?=
 =?utf-8?B?c3pQTXNIUCtxS3lKRURaUU9BUDV3TlBhVGxXZHNmZzZHUFczVWFGMjdUN1R3?=
 =?utf-8?B?MDRBZzd4T1VsM0wrTzY1M0hUem5zR0pJRDE2SU1IcS8wVG81TUkzNS9aYzhx?=
 =?utf-8?Q?tqOmrccOv/+NYgACkW?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5a43f69-1177-4e40-a343-08df0d54c6aa
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2026 02:56:27.2502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: INmokXrarh8Yoor8WTq7CLfba+LlxdubfXkWLLcIL40rtSGcfkO9FCQhfhZ4OJUH
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4435
X-Stat-Signature: c1o7fd7fdrwoak38p53rxhpuj6mbkep4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 04F1D1C0003
X-Rspam-User: 
X-HE-Tag: 1788836204-896205
X-HE-Meta: U2FsdGVkX1/M3ceLFvR5J7A+sxlrFKewhPNjfLGeNzsQaiDW2l7dChpF7L5aQy407bkSXfjD2sVp6TRFzDr1e31swQ41a/9vS1ot72VOkTJ7k2AxHrcYfc45xPD17JbMf6npuo+SboscDbi3mjF8Zf6aiusCBczBMN7h98AeJ2ZF1SZq2rZRNulvL/sAP4uJLiUV9FEqUgcFd2XWqqSakZMic3bsMiC9xCeiDeOC+4IVtmBwDLAcEyf6gvCPGzFcB6QLTtc5ppTCWgIaCmS3krjDw0gZg/8hNRQ97vslF2vOSBm89WgTg/dZK8kKEyuIE9X481iS5YcdhoZAg0Z7Ig2DhJ42QjuW+/5x7DXi6iy9Kb/y1JQCI3cZzchhQOnJ2vVssOTv4BttKBP4evdlWpY345Dx2+xn2Vgs3K0ZWtjV3hS+MD/QD5MYAuP86kpCBvB7wLSJ5GrC/cuFcy+BJYSKu6Yg5C6JLoKUVFkv8MTSrnxHF3xBiFbAe+oBG3PnzRzWU77eU1/UrnI0JVulMbPSd0I5FIxe4G0RNps9HRS3e1cvC2vNXwpIHoSFzURv+abg+LuGgQsgro08hBjcU0aCZ9L35rxP69FtDxBIvkSIQVHmJ63xUbclO5oe6q+HoAt1IDOnpilIY963GB1wVpLsiTuQAWr7h+bwEXg+krhjytd7svXdAlCIisQIvdIsllcrr3F3Dn1f7wGipSK0RxxQYqktYpy1tM0tvXQSaIVYZ2HyqKTOotGK9kacUuOIGY8uhtMHILlZjbA4qtYLBHUQHTZiWZQs3M0csrGVaaX0gM9ItPupwrg+5X+wXRu41UWriMrrPGYlJRJ0bs/ljbgChQvFR36sARANoURxe4XG/+v14niE3uE0QalH/I1Lhif+owq9YDe0Hpct0niQDv9SE11hLv2MtHiZ28Obpd6NyHNMyDdlBUnWouUvP8VI6CBRH0okLqf0yTR6Dtk
 o9zqMNuI
 d0sQ4N4QXmP8WapnacgmTOIijPksmyX0v5dL/YrhqKsN0ofZIJtXiZYey8949ebq+1pRalxpYwS6SoO154G/rwMW2sFklFSaAadnCuz8+qOZN12TxqPPv65rJoUbkrY6rfar1j22I5msifCkx5CJXtwZskpa/So2KvVYqhMVK+j8LdRk5kJSUdkxapQ4Z4QaZ1UjgCr41v9M9Pu5Qr93RUjEGcbcKNVN6T7QDgPzHChRHrA6TcxDRKIoEWKtBeIa+reB81v5pxIlD+j8fFa9ibd10CWLDHDhZpH9RrAWxrUHsCU1n54h8VM29PkxECEdnNg5ETWLNyKsaTxi1eLZrZNJBLcY/AvjrY4mcxYPgFkNHcKlLlTKdFENuKqzherbcnNjQTcJ70AHeJdwfEtzmLDuUFN15uCAi6KdRqe+1lkvVm3qb2gzBHJ4EFkO7I3EiFI7fZrJMv+elpywrkKnmuePHpuo9TT8u0ZkB1c+fbiJ/euOt0kXaX7KJD/1MSN+BTtlXQdCXxajzN/jA1NrXBXCkBZpMx6wFKwJ4Od20rPiWUx8xKi9udLfGMUao67zYdb0MjUOjAdWo/X/DI+LqLwb9Rwk8BGlkCHh2X28/+hQhW5uT4B6NY2FWwlKo494fnRuYzVAvHrj7S+psMX3UOppSjL823eCy92Xr0juNi9w/2rnLzaBes8yjHQH/p0gt/fCACUzs72/HRhfL/AoNj2sgaNp1E/wuGk6vsiT86yoDq3cYa3ZN/xFPGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

This patchset removes PG_private to make space for upcoming PG_folio
(reserved as __PG_folio) for identifying pages from a folio (more details
in Note below). Instead of checking PG_private, all code is changed to
check page/folio->private != NULL instead.

MM people are cc'd on all patches and subsystem people are cc'd on the
cover letter and corresponding patches.

Patch 6 is picked up separately in f2fs tree, but since mm-new does not
have it yet, it is sent for MM testing.

Overview
===
Most code uses folio_attach/detach/change_private() functions, so folio
refcount is increased and decreased when folio->private is set and reset,
respectively. There is no need to change them.

Changes are needed for exceptional users:
1. zsmalloc uses PG_private to indicate first component zpdesc page and
   page->private is used to store zspage in zpdesc. To remove PG_private,
   is_first_zpdesc() is replaced by pointer comparison.

2. kernel/events/ring_buffer.c stores page order in page->private.
   Replacing PG_private with page->private != NULL works.

3. drivers/xen/grant-table.c stores xen_page_foreign in page->private,
   where on 32-bit, a pointer to xen_page_foreign is stored; on 64-bit,
   page->private is used as xen_page_foreign. PG_private check is replaced
   by page->private != NULL on 32-bit for xen_page_foreign deallocation.
   On 64-bit, page->private is cleared unconditionally since {domid=0,
   gref=0} (xen_page_foreign can be 0) is valid.

4. fs/crypto/crypto.c stores a folio pointer in page->private, PG_private
   checks are replaced by page->private != NULL.

5. fs/erofs has two different uses:

    5a. folio->private is used to form a reversed list of
    the outputs of readahead_folio(). readahead_folio_last() is added to
    output folios in reversed order, so that ->private is no longer needed.

    5b. folio->private is used as an in-flight I/O counter. Convert the
    code to use folio_attach/detach/get_private() and add bias==1 to the
    counter to avoid folio->private being zero.

6. fs/nfs/write.c: folio refcount maintenance is in a bigger scope than
   folio->private. So folio_attach/detach/get_private() is not used.
   Nothing to change.

7. fs/f2fs uses attach_page_private() to first reset folio->private then
   immediately sets PAGE_PRIVATE_NOT_POINTER bit on it. Change it to use
   attach_page_private() to set PAGE_PRIVATE_NOT_POINTER bit directly to
   avoid folio->private == NULL gap inside set_page_private_##name().

8. hugetlb uses folio_change_private(folio, NULL) without folio refcount
   maintenance. Change it to folio->private = NULL.

After the above changes, PG_private ops are converted to
page/folio->private ops.

folio_test_fs_private() is added to check filesystem-only private data by
excluding swapcache and hugetlb folios, because swapcache folios overlap
swp_entry_t swap with ->private and hugetlb sets its own flags in
->private.

Note
===
1. KPF_PRIVATE is removed after PG_private is removed.

2. Documentation/mm/hugetlbfs_reserv.rst is outdated, so I did not remove
   PG_private related text. It should be rewritten.

3. PG_folio is planned to be set on every page from a folio in
   page_rmappable_folio(), so folios with any order (currently
   PG_large_rmappable is used to identify >0 order folios, but not order-0
   folios) can be identified. Then vm_insert_*() can correctly reject all
   folios and rmap code will only see folios. Eventually, page_folio()
   will return NULL for non-folio pages by checking PG_folio, but before
   that all existing users that treat compound pages as folios will need
   to be converted.

Tests
===
1. allmodconfig build passed.

2. zsmalloc is tested using ext4 on a 1GB lz4 zram:
    2a. zram load + zsmalloc compaction;
    2b. concurrent zspage migration via memory compaction;
    2c. confirmed that multi-page zspages actually formed.

    Details: https://github.com/x-y-z/linux-dev/blob/b4/remove-pg_private/test_zsmalloc.md

3. erofs is tested on images created with -C4096 and lz4hc, lzma,
   deflate, and zstd algorithms:
   3a. cold read of all files, verify checksums match source;
   3b. readahead + reclaim/migration race.

   Details: https://github.com/x-y-z/linux-dev/blob/b4/remove-pg_private/test_erofs.md

4. fscrypt is tested on software-encrypted ext4 with writes to exercise
   bounce pages.

   Details: https://github.com/x-y-z/linux-dev/blob/b4/remove-pg_private/test_fscrypt.md

5. f2fs is tested on an image with inline_data,compress_algorithm=lz4:
    5a. INLINE_INODE — lots of tiny files;
    5b. REF_RESOURCE + general writeback — buffered write churn with fsync;
    5c. ONGOING_MIGRATION — force GC / page migration;
    5d. ATOMIC_WRITE — atomic-write ioctl path.

    Details: https://github.com/x-y-z/linux-dev/blob/b4/remove-pg_private/test_f2fs.md
    (I did not run xfstests)

6. MM selftests passed.

LLM use
===
Claude was used to form a concrete plan on what code needs to be changed
and how to change them. The plan was reviewed by Codex until no issue was
spotted.

Plan is at: https://github.com/x-y-z/linux-dev/blob/b4/remove-pg_private/plan.md

I then followed the plan to make code changes. I did bounce ideas with
Claude how to change fs/erofs, since I did not like the original idea.
After each change, I asked Claude to review my code and git commit message.
I also asked Claude to give me test plans (see above).

At last, Codex was used to review all patches.

Comments and suggestions are welcome. Thanks.

Assisted-by: Claude:claude-opus-4-8
Assisted-by: Codex:gpt-5
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
Changes in v3:
1. changed folio_test_fs_private() to check PG_swapbacked instead of
   PG_swapcache for excluding swapcache folios. Because folio->private and
   PG_swapcache are not set as a whole, making folio_test_fs_private() give
   false positive, whereas PG_swapbacked is always set for swapcache
   folios.
2. added __DEF_PAGEFLAG_NAME() to show __PG_folio instead of open code.
3. f2fs change is picked up at
   https://git.kernel.org/jaegeuk/f2fs/c/5ad9409a9533, mm-new currently
   does not have it, so the patch is sent for MM testing purpose.
- Link to v2: https://patch.msgid.link/20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com

Changes in v2:
1. removed is_first_zpdesc() in patch 1 and open coded the checks.
2. fixed wording in patch 2's commit message and clarified page_private()
   also works when ring buffer's AUX page order is 0.
3. removed the empty loop in 64-bit gnttab_pages_set_private().
4. clarified folio->private will be reset to NULL by
   fscrypt_free_bounce_page() in the commit message.
5. clarified why hugetlb needs to restore hugetlb_vmemmap_optimized.
6. renamed readahead_folio_reverse() readahead_folio_last() and
   reimplemented readahead_folio_last() by adding a new readahead_control
   private member, _forward, and a new helper __readahead_advance().
7. added a bias, 1, to erofs I/O counter, so that folio->private stays non
   NULL between folio_attach_private() and folio_detach_private().
8. converted more call sites to use folio_test_fs_private().
- Link to v1: https://lore.kernel.org/r/20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com

---
Zi Yan (14):
      mm/zsmalloc: replace PG_private with pointer comparison
      perf/ring_buffer: stop using PG_private as AUX page high-order marker
      xen/grant-table: stop setting PG_private on pages for grant mapping
      fscrypt: stop setting PG_private on bounce page
      mm/hugetlb: use direct assignment instead of folio_change_private()
      f2fs: stop using PG_private
      erofs: mm/pagemap: add readahead_folio_last() to avoid folio->private
      erofs: use folio_attach/detach_private() instead of direct assignment
      mm/page-flags: check page/folio->private instead of PG_private
      mm/page-flags: introduce folio_test_fs_private()
      treewide: remove folio_set/clear_private()
      treewide: replace PagePrivate() with page_private()
      treewide: adjust comments on PagePrivate and PG_private
      mm/page-flags: remove PG_private

 Documentation/admin-guide/kdump/vmcoreinfo.rst |  2 +-
 Documentation/filesystems/vfs.rst              |  6 +--
 arch/x86/events/intel/bts.c                    |  3 --
 arch/x86/events/intel/pt.c                     |  6 +--
 drivers/md/md-bitmap.c                         |  6 +--
 drivers/xen/balloon.c                          |  5 +++
 drivers/xen/grant-table.c                      | 11 +++--
 fs/ceph/addr.c                                 |  8 ++--
 fs/crypto/crypto.c                             |  2 -
 fs/erofs/data.c                                | 16 ++++---
 fs/erofs/zdata.c                               | 13 ++----
 fs/f2fs/f2fs.h                                 |  8 ++--
 fs/nfs/file.c                                  |  4 +-
 fs/nfs/write.c                                 |  2 -
 fs/proc/page.c                                 |  1 -
 fs/ubifs/file.c                                |  8 ++--
 include/linux/buffer_head.h                    |  6 ---
 include/linux/kernel-page-flags.h              |  1 -
 include/linux/mm.h                             | 35 +++++++++------
 include/linux/mm_types.h                       |  4 +-
 include/linux/page-flags.h                     | 43 +++++++++++++-----
 include/linux/pagemap.h                        | 60 +++++++++++++++++++++-----
 include/trace/events/mmflags.h                 |  3 +-
 include/trace/events/pagemap.h                 |  3 +-
 kernel/events/ring_buffer.c                    |  7 ++-
 kernel/vmcore_info.c                           |  1 -
 mm/huge_memory.c                               |  3 +-
 mm/hugetlb.c                                   |  6 +--
 mm/migrate.c                                   |  3 +-
 mm/page-writeback.c                            |  3 +-
 mm/vmscan.c                                    |  2 +-
 mm/zpdesc.h                                    |  2 +-
 mm/zsmalloc.c                                  | 24 +++--------
 tools/mm/page-types.c                          |  2 -
 34 files changed, 172 insertions(+), 137 deletions(-)
---
base-commit: 5f4c0999b2bde1fbbba3c499208b415447ca4c7a
change-id: 20260728-remove-pg_private-cfe926c7f83c

Best regards,
--  
Yan, Zi


