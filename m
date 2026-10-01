Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4005DCA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 15:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286AC6B0092; Thu,  1 Oct 2026 11:22:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210AC6B0093; Thu,  1 Oct 2026 11:22:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B9F6B0095; Thu,  1 Oct 2026 11:22:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C69956B0092
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:22:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 492C1C03A0
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:22:19 +0000 (UTC)
X-FDA: 85274423598.26.7926193
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010044.outbound.protection.outlook.com [52.101.85.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 60C33180002
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 15:22:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="bIyj/F37";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790868136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSwwpTZuzMlIJHzWNmmO7R5gKL24+gVaJCqRRWqtY/8=;
	b=rxf+bWoodMaO+pMOMBM5ptB8i0TpbTaqwsKiub5ne6qpQA+03yzjz+IKsX5UBZW7RLnkn8
	BRXF6UWnSSYyJS/MGX/xm6iF90wbmPadc6yuM7WJ/GVnrpBC2JCbVKYvks1VXK4IOjeyPH
	YhUOZvQrUCEfOBdsEKkdb2dyEe+g/20=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="bIyj/F37";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.44 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790868136;
	b=vhiuG7D/Dy6t4ENJMHQ1bo1dsvDSpFkwZdt5jBMCL7pU/gEJaAzn6ynYfMBo6SV8HJvKQc
	7GOgtc7ZfY3drO5r2u6OwcFrTjd0YQNAZ73WpLryNjRtMbyTrRcXJAN+45Ccz/oLYOvLpz
	DG7eQ0vxaOZ/6rGsBZONM2ZBLJriYfQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lqdJapunN2FX8UbpSLZggxsOfUM+QM7vNwJNz0mRY+ZQHYVeylVU1IiA/xFrFGzZYPfw2DRv9y4CqYtv83i2g1ymR7H/HXKdEWRtCWyy/3kXHN50yuUn2TsVe/l/hc4qXeNR67VNyqCE177jAKC35qot4ybIBeUrqhrNUK7OkbiOMghUXIIAkyzYAHkVpAmOmG5pOAn/rJvrMU5FNsRVkGUmVZN2bKoS69vMlpWbWeNPHh9Xri7JnRr4GxoPnFDQe6sOsx3Oz3UgRlf5o8QeliSgSoFi3iX7TSEfQg4Y4uYgaU6AWAT7DLspaFrL7WH9PQ5uwb+YxmLbult87HD0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dSwwpTZuzMlIJHzWNmmO7R5gKL24+gVaJCqRRWqtY/8=;
 b=Z3BuHdfAnJbm87d2/HDEfXiEXh73tdpUYP4f0vSURD3zdMwcwgXFAglgq3F2cdsYTyi3xDB60ahCdRsSO1tiAAOlzC4axdGy0acfV12fYx3PF/aIL+iKA+lmLumeRhuIzlEqCYnOczVw1yhLtxkcCm2UAm9CxwOvVHPFSfw8c0RgFe/I+Hckz3Yr54kHkUcbR38Tl7o4olCfk730b6hZnQlT1D2z/T9GzxbXy3B04g7MotcKMDfzmD1QBMYBqIjLe9E68qmNVyO1VzeeJLWd34YlOJohG7JC6OvddKQgY+yyeg6jPbxxxY/0RxhJW9wZZlqvTZonyIBrUQai5LueNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dSwwpTZuzMlIJHzWNmmO7R5gKL24+gVaJCqRRWqtY/8=;
 b=bIyj/F37aw0qUuKxX5ezMXqJpQue1pyVPXKKjv1XJqD9Pn3OI+WiQOdIvNjON40rrPz0G7VTwSRECCv+QvIikvhkjPgCG6C1r07iC4RkV0/Jseb+T8OuQRKfQTXMrnykI/PntgaJFip9ZX01u79THuMNSVj1LqgQfXwLMsvnRAljFYJYDqhdOOjah1Trk1IsvXC+Mck+V+go6nKGcDto0sCiTD4duRKpu6tdIbE1eAu1K2P2g5ELowBE4/QMKcTz+j6ZxAfjk/Hjw7TmbIYEAHDwcHa5ifGLEXkkfONg86xJuzAoNwCmjnkEBCQUCzswhTMlT+KZALl/f5eEVDEyMQ==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SN7PR12MB7345.namprd12.prod.outlook.com (2603:10b6:806:298::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.25; Thu, 1 Oct
 2026 15:22:00 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0472.016; Thu, 1 Oct 2026
 15:22:00 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 01 Oct 2026 11:21:53 -0400
Message-Id: <DLTLRHUTDN0Q.3VYIR7MGPL5H5@nvidia.com>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 39/40] mm/huge_memory: remove vma_is_special_huge()
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-doc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
 <linux-rdma@vger.kernel.org>, <selinux@vger.kernel.org>,
 <linux-sound@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-scsi@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
 <dri-devel@lists.freedesktop.org>, <linux-trace-kernel@vger.kernel.org>,
 <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
 <kvm@vger.kernel.org>, <kvm-riscv@lists.infradead.org>,
 <linux-riscv@lists.infradead.org>, <linux-s390@vger.kernel.org>,
 <sparclinux@vger.kernel.org>, <fuse-devel@lists.linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 "Vlastimil Babka" <vbabka@kernel.org>, "Jann Horn" <jannh@google.com>,
 "Pedro Falcato" <pfalcato@suse.de>, "David Hildenbrand" <david@kernel.org>,
 "Mike Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan"
 <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Jonathan Corbet"
 <corbet@lwn.net>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Dennis Dalessandro" <dennis.dalessandro@cornelisnetworks.com>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>, "Paul
 Moore" <paul@paul-moore.com>, "Stephen Smalley"
 <stephen.smalley.work@gmail.com>, "Jaroslav Kysela" <perex@perex.cz>,
 "Takashi Iwai" <tiwai@suse.com>, "Alexei Starovoitov" <ast@kernel.org>,
 "Daniel Borkmann" <daniel@iogearbox.net>, "Andrii Nakryiko"
 <andrii@kernel.org>, "Eduard Zingerman" <eddyz87@gmail.com>, "Kumar
 Kartikeya Dwivedi" <memxor@gmail.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Doug
 Gilbert" <dgilbert@interlog.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <mkp@kernel.org>, "Jaya Kumar" <jayalk@intworks.biz>, "Simona Vetter"
 <simona@ffwll.ch>, "Helge Deller" <deller@gmx.de>, "Sebastian Reichel"
 <sre@kernel.org>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu"
 <peterx@redhat.com>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Oleg
 Nesterov" <oleg@redhat.com>, "Peter Zijlstra" <peterz@infradead.org>,
 "Thomas Gleixner" <tglx@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "Dave Hansen"
 <dave.hansen@linux.intel.com>, <x86@kernel.org>, "Arnaldo Carvalho de Melo"
 <acme@kernel.org>, "Namhyung Kim" <namhyung@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, "Rik van Riel" <riel@surriel.com>, "Harry Yoo"
 <harry@kernel.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent Guittot"
 <vincent.guittot@linaro.org>, "Maarten Lankhorst"
 <maarten.lankhorst@linux.intel.com>, "Maxime Ripard" <mripard@kernel.org>,
 "Thomas Zimmermann" <tzimmermann@suse.de>, "David Airlie"
 <airlied@gmail.com>, "Will Deacon" <will@kernel.org>, "Aneesh Kumar K.V"
 <aneesh.kumar@kernel.org>, "Nick Piggin" <npiggin@gmail.com>, "Arnd
 Bergmann" <arnd@arndb.de>, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Marc Zyngier"
 <maz@kernel.org>, "Oliver Upton" <oupton@kernel.org>, "Catalin Marinas"
 <catalin.marinas@arm.com>, "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Anup Patel" <anup@brainfault.org>, "Paul Walmsley" <pjw@kernel.org>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Janosch Frank"
 <frankja@linux.ibm.com>, "Claudio Imbrenda" <imbrenda@linux.ibm.com>,
 "Alexander Gordeev" <agordeev@linux.ibm.com>, "Gerald Schaefer"
 <gerald.schaefer@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>,
 "Vasily Gorbik" <gor@linux.ibm.com>, "David S. Miller"
 <davem@davemloft.net>, "Andreas Larsson" <andreas@gaisler.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Christian Brauner" <brauner@kernel.org>,
 "Matthew Brost" <matthew.brost@intel.com>, "Joshua Hahn"
 <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Byungchul Park"
 <byungchul@sk.com>, "Gregory Price" <gourry@gourry.net>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Youngjun Park" <youngjun.park@lge.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng" <qi.zheng@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Michal
 Hocko" <mhocko@kernel.org>, "Miklos Szeredi" <miklos@szeredi.hu>, "Xu Xin"
 <xu.xin@linux.dev>
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-39-4583d8a23bca@kernel.org>
X-ClientProxiedBy: YQZPR01CA0192.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::13) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SN7PR12MB7345:EE_
X-MS-Office365-Filtering-Correlation-Id: f1249e57-63b5-45e4-1d8d-08df1fcfbd17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|366016|7416014|376014|18002099003|22082099003|10067099003|921020|4143699003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	/kGu3lWCHo6GIad4ug2wW/YQCtqSB6c2MsqyUVDe7Dpvc0kYJt5V+eUIv1TwIsrO4aNYRGStsm38Uks2qPpqxFNcaIc73sp+ih5Kf4+rJg4Avy5DideA2hffKXULhvc5lnFk/wEb38uqX9CbHNOlzeMmdwCFqUZvmK7lkRPW6uui8ZfcPAPp6NwT/MfRSQlN7DN5TjeHiNiLUY5tvBc08JuNhZG95zbDoDVEomqsAvmDgFLin6JZHNMGX/zvf/2qtWH45jXI0MbWSFPtwV3xpjp8QKqdyDsSHhHBxSLXWmMXhvvY1EPfuuDyxAaXdRjV1ubTkjatWPQRfpjhLnbDXk1s4KwxG8C/TjUPgJrae7oySW+w3tqgAhFFlXxuUJwqYKSZJOSlEjtSh3Iv1ix73VEvFlO5PLS5QZ7wiRffHjToCZI2oC/nkoVWBa632jyEPCuiXrdUZnvJvmoOyWCytXascfqKrSs3m+MLRhB+WXWxcA/+1S7+ogGlC/q9i7qjSyQPALnPSVMghO/pbrYcBasJVHKom7H79YX/0Ati4LW9IifVai9OteRNyTRKtVUyaWc3KCNFJIdNRB/J4LgYBY7BnilmpL1f6g5h8CVx5pgA1gG1fX6ZZShBknY0pPnoxa5vnsb276nlGBilQyuJYh/3pFVa0G9S9bAu85cn/fRVU5ARC1DVU7YQ6+rWbi/jKKYDhB8atyl5JquTPPN5ew==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(366016)(7416014)(376014)(18002099003)(22082099003)(10067099003)(921020)(4143699003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WkdVNXB0dDZCZWxhckNxYkVic2M3c3E3RzFuU3l1ZFFNZ09BSENSd2g3Qnpz?=
 =?utf-8?B?L3dNY21VaFhWZnM3ZE10Z001cTdqSTRDSVQyMDdOMzhDOUoreTdKNXVJT2hZ?=
 =?utf-8?B?bU9LSUpoMWdkZUc2WFdtQU4zU2M2T2paUkpucWI3TlVzZ1R2ZmxMVjkraDJs?=
 =?utf-8?B?bGg4enBod3JhNTBzMzJXdTArc2s0bXNzS1VYUHBMemdsK2dmSWlWWXRGZU1n?=
 =?utf-8?B?RlZtbmN1cEJ1ajI5d3BKWjNsWHNkV2xsRFBCZnlvTEpOYmpkZ3B3aWlFcVZD?=
 =?utf-8?B?cnZFcnF4VWE4d1lSNnBuZTE5WFQvclc1MmRDbWFNUGxrTkppc2haTG1CWnVP?=
 =?utf-8?B?ampPdlZGZEdHQml5NWl5TEFmSytlb1lnb0w5aUtMbWl1aGhERUtlQjZFTVNF?=
 =?utf-8?B?b1BwcmZIMmp0bU1Xek1tQ21ZeVFiUERxcDhEUEw0OHQza2lkS1VLMW1scGI5?=
 =?utf-8?B?VWRUa3hSODlMckxkQ2tmRWxyQ29uRjF4dFBkUEJ2clJsZ2FmQnMzcjkwSXZR?=
 =?utf-8?B?NEZZUEVJeHp1WVRCWnpKUmNNQXVrNWw5blJFdlhtdDkvQ0QwSWxYRVBGWkxo?=
 =?utf-8?B?WEU2REVDZmR3eHJjZjdsdlV2MW9ITnpobDJRWm9oTTRSM0NPb2xLc3IzQmJk?=
 =?utf-8?B?OERIRSs0d0F4RXkwOS9tLzFEKzRueS9WOW9MUkoyVk5jNUZGT29BWGlBZ3Bo?=
 =?utf-8?B?Wnc4NXQ1eDEyY3FXMTBSVzdUSlhCNFhST1JIU3I5WG01dCtYLzJSa3FnZzJo?=
 =?utf-8?B?cFZ2QVloVkFYWG9MM1psdlV6OUpqYVYwN0FYYzV6Qy9xL3FiUHB0cFBkSXJS?=
 =?utf-8?B?bkM3QU1UWEFycHhZYlp4NFZ1Nmh6ZVVESi85cmxCbU9HWHBpQTFsb0huUEdR?=
 =?utf-8?B?c0ZncFF2RkUzOTRRQ1BSNDVyUTBpTmN3UGROSHBJeU9YUGdtdi8rZHlYeUtK?=
 =?utf-8?B?T3RtbGhkQ2FiSStSMC9oK2o4UkxRTzBadG5kUFNqOWZlRjQvT3RxQ0tYUnZ6?=
 =?utf-8?B?M3IzcjhBb29zZjRPZEhPdmtkZmNERFJaVUNRRmE3QkpPQ1BzRmRIUGdVUUFq?=
 =?utf-8?B?Qi9iT3lrclYxNEtaWTNlS1N2Z3NTMlhWbjVmYTdoRTRlOEtaKzRiUVpQYnMr?=
 =?utf-8?B?OWN4RzhRYXF1MU14bFpwN3Y0NW9NUENXQjNudGkwcmM5UWYxYTc4TGwydGhQ?=
 =?utf-8?B?dmFmVGkyK0RZMEFWbTNqRjhPUzR5bGV5enRQSnpMTXVSNjk5RDgrN2RiWStV?=
 =?utf-8?B?VlpjMGZRTy82RWV3czZ4VUFPYW9YcUE4RGxOWUpFWTVPRFVDa3RQSmVwYVBp?=
 =?utf-8?B?dHhFdFFHOGNydDdaditIdElvdjBVWVRIK1lkMmZLVHNxQ2JkUHJ0K0tJVVdQ?=
 =?utf-8?B?TG5KV2MzQktjRG1CTHRnYndHekxCZmt3K1BpdE1oVDd6ZllXSUFmYTdTR0ty?=
 =?utf-8?B?OVluTUVRcGQ2d0VqSkQrZU1IckswemZEUjZUd2FnMFBSeGlFc2RhV1RROHZJ?=
 =?utf-8?B?R2twTGd6V1U3Z1V1czlKV0dlZVBDRkEzUVpUb1MyWWwzMkN6YVNKclFvTW9t?=
 =?utf-8?B?bHhOZHhyUE5LTnlqZGJtWlV1bkVDRzZLQytHN2NFVGIzSHVGamxJUkR3ak1u?=
 =?utf-8?B?SGZ6UzZTNjdheHpzNTN6SjdpWFRYTDdYVFp6QzNYWEcrUGlBcHp0VjkwQUpD?=
 =?utf-8?B?NTZSRklhZ2RJSEp4UG5WZmlXcEhHK1czMXBlZWh6dU9ZZUdJMHg2SDhCRXl0?=
 =?utf-8?B?SWt2bmxWWEFlNjA0eHhLc3hETVFjbnVibkhZcVpTdnI1T0UrNnlGY3k4Y2Nh?=
 =?utf-8?B?WW15VkRyTThXQTd5c1dCdU9GZmNjVDFTT2t6RmZubmxkWlVkUTlrWnFqSE5Z?=
 =?utf-8?B?Q1V3Z2NvKzBIS0VaMERlRytnaEhaTEszWGs2SXh5UFoxWlRLUnk1b2dtNC9G?=
 =?utf-8?B?STVCNXkwdmhVZ2hWVkFNc3RqdWRacjVxRHo1UVllcFdnb1FucG4rVnNZWlBk?=
 =?utf-8?B?TU0vTDJWSlV1QTRmM0Y4UUsraW9RdjJKZG0zRnJFWUVHTnVtaWNHUjVmWUVa?=
 =?utf-8?B?SWh2NjBzR0tUemJjV05CeU9YNjZ6UnFGdmsxYjgxcGdwZmVicDI1eWN0Z3pp?=
 =?utf-8?B?L01lWFJtRW9HbnZjTjJCWHdWb1ZiWG9FbkorZ2VCVW9vcUozckVEb1NraGRE?=
 =?utf-8?B?ZEJid3A3TDlycGtmc28vQ0tNUWhtQ1lhU205VEN6ZWhNUlpSL3pGUCtqQklG?=
 =?utf-8?B?VFFLRE5TZktwT3doQmVtSEtYbkd2MW1HcVVoOTZQMlV5TTJvbHV1Y1NSdU03?=
 =?utf-8?Q?g+VokNu3Ag0hbksNlc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1249e57-63b5-45e4-1d8d-08df1fcfbd17
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Oct 2026 15:22:00.3629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VlDX1pjxR80vhPOtJ1dfpIVvnpjOO0NWNKHr18EgeN8YZ2KRVngTm/tv7x59BwIc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7345
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 60C33180002
X-Stat-Signature: tmrp4joxda5wmwukho563ufoeek5c6dz
X-HE-Tag: 1790868136-820077
X-HE-Meta: U2FsdGVkX19sLNkaZI4rfAKIV7DoYxdD5bC6vJKgwLkkeqVRzhncfkcZUeU+QYBJWYcpdPRh4JRxKJvmtyVLuMtN5NqokZfEtuUsch/mYHqDHMUMVS17YEZcLIIpNy7YWG/Zr9b5r8SC1fcsKDbaiekffTjRIjd9kwQ5HFrOvOapPOlBWLSKA/scPqCcxFz+yetHue+UQs1SLk6bCG4GaEskluwk2IcjZqzKX/J173eIPxVGCmihmgCZQuLwCM7jVI2o/Czubk3MaRfCNc3Yg+dSI6KTsMrED8iLYmDwcAkSNWNZZsvjNfsgVkhPgW+9/NoXyharMvyvfE1uJ1OxJQw9CVeJXQAugJ1eK26bO7EsNOpGB+Y0Vd7zWv4MUvXkvU765YvWZxSICq3ErH8YY9IEqORKzNfO7AAiBuxpaRp7PsVS8I9dfHf4a1cvoUh825Wvs7ISHuWLe+JD290viWk3OnygCysAQpw1Qeb7HoljE8jApyDAB6eMTNyiE/sdJMB9BpsSZ9qrTJnam67UlhUOyE5stATpUSHkQzpiw8q2u1kQAuKV68cPSqvO2qJiBIU+zE0+NGSX8vvAegTqMURp8vQKMthVgax/JTEREjSwqM3ipBytNUK7t6YU20ZkereFMQ1anpwVc84iXeWnejqFUTqNIKgupgybbla8+UZphCOZnVr8q7TQv7eGFa3H80YfZ23qeJiql4A+8P5oC56iLSV3l4S3ux6R6PKAGH8W/GsnR/1XKGk+7VZyKOAs9JDYKZYplWUDu+Ft0wrcPJH+EW1OKtb9OLsUF3osIMaYQ7au7YqaIgtQAZ9njPsmXKeQo7SHf7FdPLdjdY36McauX2n2FUX5ATAkKuUaWPaejvebA8HB8QZMmGAMzqX7+ebT3TIitlzfUQBeHd8pNRA203RzBMRNlJ8s9AobnPlhjWpnVX/5dxHDC2mR6AvuKJIROunwVykaSL1RVsu
 uLPMC5N7
 /OsL3JiO/2/kUdIz4KxraN/1YO3ugX3tSyehuOU8hOwru9yyO4Jev72r0B0ifYkddwDYUYW/RAYaLctZRTmBxJWUle7ymrVO7kSSErDDozelYlsJURMlN8fo2AHWw0sLt/bxe8pKiSkBktJUF8219PXPXeLgJ56B+tKBWmvfEhXeNjq063KZm8uH6sbi2ui7Jp0nJTVkdl+fDdWYyZZTWOIZMoJhNn/b+GjuSf+qM1JVeqSW+7wnvRg3GWLKbuMEvCnSggOLHP9qUJKiMIuz3pyQbcAyI8VLodKuhUV+f4qRUNSYlNU5bXi04YRZbbc2oeQGheWECb4bu/BmR33vUA6+DvonDFY3P/LDsjAFxdDnEd4Japq6N/Gg+ou3SVuS141Qir3n9JcdHqDgjAyDhIPywY+LGXBkD7r+wrEqX2BCn2Km4AIBhyfHplq4JrZxiZiqBX9cWjn4aZJmnd+cPJRVtLY/p0T+Tpfv557PxJRu4p5lvMaUSS6RtirwQhONg116h084nY47PC+KB20bnL/dByQyKow6mJltT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> vma_is_special_huge() tests whether either the VMA_PFNMAP_BIT or
> VMA_MIXEDMAP_BIT is set (i.e. whether the VMA is a kernel-owned mapping),
> but with a DAX carve-out.
>
> DAX however no longer sets VMA_MIXEDMAP_BIT, so this carve-out is no long=
er
> required.
>
> Therefore test for vma_is_kernel_owned() instead and also drop the
> VMA_IO_BIT check, as it is now redundant since it is enforced that only
> kernel-owned mappings can set this flag.
>
> This also eliminates another overloaded use of 'special' within mm.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 18 ++++--------------
>  1 file changed, 4 insertions(+), 14 deletions(-)
>
Acked-by: Zi Yan <ziy@nvidia.com>


--=20
Best Regards,
Yan, Zi


