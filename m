Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFE1ACA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B33C16B0093; Mon, 28 Sep 2026 22:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0B2B6B0095; Mon, 28 Sep 2026 22:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFE66B0096; Mon, 28 Sep 2026 22:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 697CA6B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:13:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E00D4C0376
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:13:46 +0000 (UTC)
X-FDA: 85265178852.18.284F966
Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011030.outbound.protection.outlook.com [52.101.57.30])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1A7C940008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:13:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gK0HlgOE;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEB4tNONA3VNJjsg5URbR6nEereDrePFKYJqV1Jy6p0=;
	b=0iHoAF3A1aJn2NrWC96uBPXfdmC95IpaEkInuI5HImvArmSWlU1roEJsL6TpHojAZxa+uq
	CYM5pDSnkQGrlWZf6bhu5DX2ah2CJ6Xq5R0vOXilnjnswP839rFGOFtKDo6XjQS5bx0I9+
	jXTHWy0PqBi9Qm3kJ1xoGF7OMGwKv3E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790648024;
	b=3ltXwZ7Adrcw3USfLpJr5rQdzkVHgDnsL/As50Q4qyO0nbioNeL+b1EifwIonYRV+Pn3Zh
	2OMgJB6cgZ06hy0bOy8kGYdzd3QXE7a3I41pfg1mUKpHOza7B/dFZX/JoGnJctoXibfOmC
	hj5C7fjNkISMVy8KdgLUHGzr2NXyL0A=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gK0HlgOE;
	spf=pass (imf27.hostedemail.com: domain of ziy@nvidia.com designates 52.101.57.30 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Kndv6K/gkpHHcqqbKJNg4MobTOUk8eXMpQSh5Jwq/FtbCP/UCZ03QQN7KTGYvVMsSUmZVSyC/hsEepiMb69COGam2ByIXWKikCakjKV3SF5he8NHTb2v2n3kfWPv+1bk4NkbMv3HKF/EfiUzCiE5xTnAe3Oj5+dX3GN4eMCwO63nmr9OSf54ia/hbjS5kwkB3pIo5WyHvrtvc6RAWymjaKUnXXepfQfQ2qvis0t+G0ecMPqute+GYEnHBu2vs7HALMB9nJZBnUOK+sxC6zqmmeQqoaF5b0Sr2Zbpx/Av3DXHpTvOZUCBv2SjvEtchJt5hPY0zqsfpKsCl1Ykg52rlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BEB4tNONA3VNJjsg5URbR6nEereDrePFKYJqV1Jy6p0=;
 b=gqkLtD/oSvpRuGB6Fi5MeFx4GG2IprroanvLC5r0W30LL5bIYpR4yKcv4EpGYXgjY2MOpPc8ifo3lCWm9l+oC4gbGKZ05/MijYZlUqt+aVkECVmhm9+70svHIHOnKjgDcJo9G18u2xq6Oodm3xP+0Ww/AcXpEnn7oVySJUSBzYM2T5lyJWf2MC3ZBT6Yk+UCegl+sO8N8FdfOtShiGRCAN5s4QyfVhPTmLa/4hbtpv+kr6PprOIfbOpHQ2Jqhych74JXdessrEd9b31oTqJ8Od19NGDz4AXJ2qz7r9JwNZFrwi7ajLmjkw862yiPD+yKHl5GyRUCQSi8nMiSQXF6qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BEB4tNONA3VNJjsg5URbR6nEereDrePFKYJqV1Jy6p0=;
 b=gK0HlgOE/vt3kvQlVm3aYAWALkWE7GV4N5vYEDSyU9vSAqXc15HITdFyB6TymZ8ujroAR3xAf7r2maYXL3dNcx8sQGblMex2LGy2vqzi6rQL1NvC8B8ak2DJKODzc+INhcYTmqyffP01B8YncchNW/T5id+994y/C/NfvCEh/zVkF4SrDOpnrd5iTx99iyAmK9Eb7w6o/SxUzHKcWz0CPq1pshlba1KvOSJfEJxv8W3gxBsC/kiKHdfzW50wT7aR93eR56S/HtSX55TNOAu3mLf6wneadOsl6j65beIJN+HTVdCHIME7MTZNWiW7OOX8uOe9UyhEygpz7gaj3k45Aw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by SA1PR12MB8161.namprd12.prod.outlook.com (2603:10b6:806:330::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.24; Tue, 29 Sep
 2026 02:13:35 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.022; Tue, 29 Sep 2026
 02:13:34 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 28 Sep 2026 22:13:32 -0400
Message-Id: <DLRFQSFTXWCQ.23VDJM6S7C2DG@nvidia.com>
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
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v3 27/40] mm: remove hugetlb_inline.h
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
X-Mailer: aerc 0.22.0
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org> <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-27-4583d8a23bca@kernel.org>
X-ClientProxiedBy: BL1PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::6) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|SA1PR12MB8161:EE_
X-MS-Office365-Filtering-Correlation-Id: 9d718503-ba0a-45a6-3484-08df1dcf4411
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|23010399003|376014|7416014|921020|10067099003|4143699003|11063799006|5023799004|56012099006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	chHGoarCm/pYiGB+1058Tl/Wypu4cHG1dGQTOvPCKbFVpmLIR1aJ3cryuGrBFBiiwFsRcCK/h1PGrSvO4rvggq1zujbHL2haj8BUz0cI2cnfCu4lWAlEzMeqZe8sRTFzVH4c3XgSw0Q7EZ+0uVq8bdN5zVwx8laCMYGPN52n/+Liv8MCe1+tJX31a2U0O7fxAOD+AEojoCjD5QOUmw0JjsPGfQhKxIwyQM3UFph3fw4mLTtriMze9acDVus8iibaGKQeVL9YXm6dQlJ7htXgWzviy55Ng/pXW3gKlVGuQv742vD+QseXre1V6+D+w4qA37r/fkZoFPrKpPUdjni8PHZ8o72VJdpB6D8hn1DufooUFYmo0EoA0zDB51h2BPxU112lGd2pszJQmKzsT/T/wGCrcavd4kZu0uv/RIFyFymNqvzoyXE3DlNrm0xHUvMN5TemecpqCUdM73nzu9x61L/XS5VWjG/H2vUxAVuduCSJI6vcvWWVt1SOgFJ9+t0PARz7BZaqXnWup2TV/6Bm6fmUfMsD0xTgwKY2ID/OL2lqBKhDbhKXP+ujVhD3N6o7YxsAhmCmwIz3ycp4eK1pl5INace+do60UrrNYG5rn9YJt+MZ3FvPDECrK7GMe8+yBc6fRESxjaDzzqJyXx3eLxxJDDQZ5orq5T9AD8uPAo/T4xgW82iIHim3spgk50JTmivi2BpS0rEjwWPr09Y+Tg==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(23010399003)(376014)(7416014)(921020)(10067099003)(4143699003)(11063799006)(5023799004)(56012099006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eXU3M1FPSGQySU5iTzg5TmQ1bVFjVzVmUHpqZW5ZU1NnT1dvZXgrOVlpSjBs?=
 =?utf-8?B?dmZkVTB5c2c2bEhpVEhOSFhjRzBMTkFOeVBvcEtvSXliLzl3MnJoQ0RLOTJU?=
 =?utf-8?B?T1lxQVFsQUdTcUMwTUFtcVNCN0RaZWdwQTEwa2xHS1ZhbmhqT3hldmdnOVVo?=
 =?utf-8?B?bnAvNDVpQXNPT3FnYUVPME9lNno3RFdIQ3NOaTZacEpQTVYvQUVLYVk2YThP?=
 =?utf-8?B?dHV1dkhRZFhyVTNFVnd6YlVtQmJONktGdUhENUpCN25SdUZZR0FoR0Voc1Bq?=
 =?utf-8?B?QWxWalRvbVFobWxjYXpxcWF3MHBMdWFvSEVhK1dlZVZIajQ3SlpjckNLQnA0?=
 =?utf-8?B?K3FpSk1walRvZ1QvdjhmSkd5V3lpeWFLU2JIZmxTRm5QUXRqaWFieVpiMjlq?=
 =?utf-8?B?Rk45YW9jTndPVE5ySCtxWnVuc0E3V3ozUkw4ZllEa3BGZytySkl1eiszYjk4?=
 =?utf-8?B?QWxlN09wVnJhZUpzKytldHRJTlNrZzFPaHlaWVJ2QTd6djg3WXk0ZCtkaHlh?=
 =?utf-8?B?TFFYQjlKWjBXMnNhdjVuUVFXclc5R2tsaGR6Y0VjUEo0eU0zNyt2MHFiQWpj?=
 =?utf-8?B?Y3lhU0FGUUFjUWx3YVQ1ZU96eW5GUTdFaXNGRFhzcnRMTVZGK3J5MlhSUmZH?=
 =?utf-8?B?UXRtbS9VeE1zZFM3MFh4Z0duRXNEL3dkMnI5RHV4Q3h2bTM1d2ZSb3BXaGFK?=
 =?utf-8?B?bXE3WWNHR1paSklYaXhZWUl5SFJheGJVNjl5NHJJQ1U3cVU2czRjSngrWXdP?=
 =?utf-8?B?UU1leXFJNWZxZ0c5K2hTcCtoSzlWWi9mQ0c1S2hwNEkvZWJkWlBEYURxSlJs?=
 =?utf-8?B?SUhpTndmOW9QZ1FlNmI5RkxkZHcvWmFJbVVNS0EwMGpETWxobFo5S0phTWJM?=
 =?utf-8?B?cCtrTTl0Q1BDMFhFTHBCT2dLdDlFRTR5eDR4T1N1c3pjajU1S21IR09aL2JC?=
 =?utf-8?B?TWZaZlFkcEdGMVUzcXZ1OVZyN3ZuVi9Qb1JHWDRMMzVXSVNpZzc5V01PZzRn?=
 =?utf-8?B?T1ViczBHc0k2bTRoUGQ1K3BkdHpmOERTekcrM2dNRUVwWk9rNk9vQWNEVTkr?=
 =?utf-8?B?cXFIUGIxS1pGdHBCdEdBWDJZVFFZcHJWbUZhNy8zbFVObmpickFEa2FmbkhW?=
 =?utf-8?B?SFRNNEw2S085VlJTYUVtRnBkVStlenV2MWdrOXdGZFpqR096MG1iN0IrMjBT?=
 =?utf-8?B?dUhyemJoRWt3akdXdTJ1UTZGTUFpT1NuQ3hRelZFTVUwS1pQV0pwd3hVTGdw?=
 =?utf-8?B?TjEyS056ZEV1Q3NscEQzaG8ydHpHRU1iNTJ2WUlqNHJKa0l2R0tKYVJmWmRs?=
 =?utf-8?B?Y252ZFl0V0FlTzBSTHdLbGloSC9aM1JxcDRuZHdZN2JZeXZhT2wxbG9uWlR1?=
 =?utf-8?B?aGxHcm1HS1JMYytJa1NVWi93aEhOanIzSDhQd2dBODh5ZzBwRGMxOU90am1J?=
 =?utf-8?B?anBFYzNhQnh3UGhFdU00V011emo2MFhleDBrTm1QNG9yTFI3cjVjazgzY1Ju?=
 =?utf-8?B?NWNxRzhvMjJZRWx1MWV1KzNDMWRzL0ZPdUNPZ2hJUVJJSW5XL08ySkMvcTIv?=
 =?utf-8?B?b1krK0h4L2NiOVlSNjdmU1BGOTVqb2pNL2lrK2hoR1ppVXNKSXVuZ3lCd1Zt?=
 =?utf-8?B?T2h6OVhhNmVhVnlhMFREek9PTEZTWk43bWtSMzhLTlRPSEpsUlFmVjFYbUtk?=
 =?utf-8?B?ZG9SMFh4UDI1RTRZTHQ4QmtjbXNGYTJYTFJML0J3bG42Y2J3NytIR2RRYnlp?=
 =?utf-8?B?cUl2NFh3Ri9qK3JqK1JLdHpOell3RHRFVFF1Q2gyWFBEd2l1NUc1M2NCVFdU?=
 =?utf-8?B?ZHZYU3lhd2pvdG4zRnZ4ZDZKTDNXWTBvNEFTeTF2bWN6R3Q1Wk0wdTYzdFpM?=
 =?utf-8?B?ZUpoY0NkYlc5c1I4SU1tQkRQZDVsYkg1RlUySHduMUZsblVjOUZCK3FlNFdE?=
 =?utf-8?B?MHFzSTJpVkVjQ1FUNFZaZGVueEVkTEJXaHFtNm1TVUhXdnBQUE1lVjRVQjBh?=
 =?utf-8?B?MzUzU3pxZXg3ZlV4YU9iM1hXVTU4SXcxMVZ6TWxqbFZZc2cyQmY5bEtpN1VX?=
 =?utf-8?B?bVd6Z0tjMmwrT2JURkRrV1U5TDN4cE1lNFBsei9WdnhNY2JJSmI2OEdERDNC?=
 =?utf-8?B?Ym9Hd2ovTWdORU1vbzNKaTZmenN2bmhRbGFyQk9IeTZiN1VnZjExS3Y5bWhi?=
 =?utf-8?B?WVBjdjJLRlFNZk1XcTVROFMwZ2UyVWVPcHZaNVVtT3V5bHNsUS9WYXZFdWVN?=
 =?utf-8?B?Q0pwcmlQK1YveVZvNGxmQXJXeEFkVmxYVU5LYTRrUGdPMWdZWmsxZStpSUZn?=
 =?utf-8?Q?B+lUt+DpAE+3aQcGsc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d718503-ba0a-45a6-3484-08df1dcf4411
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2026 02:13:34.8534
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZSNEaHvYjabxjlqImkT3CknL2VDfsZnCv+Vukcww20/Z+DHdro0NFQK+V16BIdvc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8161
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1A7C940008
X-Stat-Signature: rxf8coriid89cj1winsy4u1bp8h4eh64
X-HE-Tag: 1790648023-704858
X-HE-Meta: U2FsdGVkX19TRB1xZROfBYlBfzV5MNTmWADfBmtLKrKuJrTEHdB6HwGLaKUyShzm8xUh/wT9984HBrP/8gRwEThPeaA5qCXV4ZVgb5txj9xVugRL+RPEmfeRpw5jUS7F9iT9oMs7Bhw8el9bUSpKJ2E6NmEL9NbLDNYR2492W85KYTtBdHEc7vZYGny5/07QfnTDYTNF+w9a0jnYaaEs6S1wTlZD5u6QvW88HCvoTqv5NUXxDnAmKMC0C8zHg7Yd9oB/Bbl60hnM21li2f1s4LBG2o/iTfLdEzVYI43C3T5uI1FO1ITxlWs/UwcJxscnJQ1WJv38YvIYa8TFae54AsJvSiNReh0oz70rR+D5TEUJRj0r1oNVLADNVgRDQTJHLACvPZSgRts/XBuELaAgZ8wTUOSrNG/XuBUlvskjJsSaicCqPcbNW7NuB8uh8khYuI+hlotUgWSpMiXCxxMvbn52PgbAGIU5QNuRMoCzY65ceMB/pMeBwoeo+a6W8U+3qvZKVGNjk6b8LG92S0b00+7KuCdQAcF/cb5OLoVOyAWu9hmigKqOrl63ufi09Ukvt63hGyqzplHgkc6VYoQBtzGnhwya5SzfOBod6LNSwc6yb/KFEHIIcUPkw05AUp6fjutQq+JxlKxaudtNeeE60258l6AqE9IOY3uMUxkNZGIaYJ6LZ0aepl1yPf4mQ7xAiZzGExHt2FRT/YKd/M5ibnIw6zp/Ur+iTbr2q6CWNg1k5V62j3a9skSzG+XWVv68VpaO9JDe3Yz5H1Bfl2jkIdnjW9utvFtodqlsA814LWE1BgzOBz09CeYW6lSmZvMchgOKKa8BQpLe8gh33d5zn2wStuLn75XU/CEiDJuf0qsvsK1Htg9mvx4z8j8y37ilVX1EFE47/ApUP40/PMlkGAhyFBHepTppPrUo16Hh6y+sopWkxS0gawSe7ZZ/cvq1HSXU49yQJPY2vV0b1fb
 BrmiuCE0
 sQSP9w4REX6BBa2GkCLw0oY9CUXyGSyieURG2HYErJx5gW9jgtYR3owfOtD+Dll1v3qAL77oJgJz6QDgdU831odJfA45IY7L7ae7q2ddfOGXF3PdfTrPC7JUCknW9nyuSQr4PqbdOtUhg+UI+rBxBvewStQmnrpPfC2dH4O2vpC7z3yryfrPA/GQ0jMo5+osG7n/di4fYqoGlanB3exCW/p+JldsDxeX6IPsHlnAT30I8SZSOFzUVaLQMUlZdvGUWY3VTFeXlUJvf3fG+FKsObZ3GETFzkMwit1i1GNpQViyFF6j11FO62CFUYPCOgMDLUQzrcWGrrdKB5RAlZJGe0CciUFCRm4lzCdEw2inh3w0xW9HAyfXoa1e2NUjDc7Mr9thfmOv6Zs+pMflySkAkG5J0JLQiCpTkzHi8cZyY1kpFIaaCttQJ5Kf3FfOymPwdQkQvTMPVi9/Lu/Z57UcQftLZHg2qWkLau4AwUYgNPOiSBP3BX5JqqPnFJOuPNUCMYcZtQ37orz8A476sH56zbhQsipHbTlymtaG1kXgK2zUL+gBo5kFytylfKZHfqOr8d77UX0LrL8edLd1HGDUmVzkkBHa71hvj9THBwLPPRdZ6g5NzQOUifr91fyUtCTg+CXd7JLy//BdF0ozdrfOf6i5CrDmXIT+wgVjEA8QI9JC9FM2Q+c8JGQZk+XHKPuLAtxrhZioZvESpi8RZjvDLGUqk2tAgjRYMM22mC6/t8xSRPDGYg89EEI5hLcO45soiWzAeHoDXw9dFsIoeSnYMturyxF1j9wsb/bRAHlmaSnvV6y5hYUZGqGtbiIfhjxR+nZeKE2qwC0KuemDinIWr6Rvz9qRw4uN2cb0Phst2bYC7IldWk8+ODBLAX9dz82mb3GUN2YLYBrcvz01V6Tg6eSwaMyGg0EHPtR2YhXtn97XJRZcV0CKBJ7LavToo4RvMHyRnxdyD35mSl5PL+B0pWUz3ke35
 xkHoApL5
 6xqbMeIY/EQqF+yKmNZeikyfPJ1/U3Qe7sL+iZDj5Bkw9zCmWe9GsZOcRr1lNtcXJPk+yNx+M366TVksNJBWcFQRMftS5DrJSn8ymTp0FOZgKyp8w3FuCC9Mz/fhP3oNSHDiRaQAqLKSLFy+KEnkNx/eKW4t/Xv1gVz1Tx3bhxs9DgJV4Z/b30Sk6mkbV4kyqLThJBcW3Yg3AzDB9aJ7ZHtF1L4Dnm5EnN5KUFSs3+qJkkuznqxoqD6aHqxxnf0xy5AuRNZSKvD7PRf78JB06bT2G7cHS60Iw+Fn/sAVqn9krTmgUkmNotm8GexHbHBNf/31o5S/CKRLqvYt7gjppOJyo1bH+AC5/O8LfYHgfz13VUtHmuFelHpzp4GnPePvBL7Cdbxm1FWSF24jwaS0vdHuR/2/cDp1YAV6sKWYN0TJJs74ECpy47EZrRQD4RRcXz+ukuc8JQ59Kgh9ZTiYp3G/YDrMk8STnxhf7YrBS+WvnqZa+hgv49qmOgD59dxFs8ZZ3GfV/LbRRJ93gj6CkNsTASPptGuQuDT+SaTLLmsT7u55VPV3H/qBHzwbBpKFfPwYtf8tQF1uxJ+P4Cw9oS+FPpq1zois96/JJXGC//JCQD2f4Hl05ID+xcU6wXO+029JBcYTxm6rVhaY9Up/Aio3N8su/6tKF0U027yf9+zG5ZssbzR+SqvKYYtNGLdtcl0fmMcj/4PQKFrF2VGl8aUjNmc6HZVMxhX7VuJVhrVk89UzvnHeIJSP9fvsFzHgIhrzyRmXUmiTbKnRbfanMnhhJmuJB7H5p2yoF6MNNpEvfa13cMUwC3UbpZ8itNRf0+iaM4AK/MnRBGwbtiE3flhbJrh39VhoUjKHCaqjGy3A7JWzIR2IbadipVdR45VZyvlNfXottLz7C9QKAcWmjqEa0K0JII5IVyI8jjXkJlE2sOOcE5Jvpvzo8A5+1LmLQyuMrEl4OLwP/moQ93k+0ZpgfEkuO
 ZjFnZFTW
 UfQPV1QvuuhFCKf2lpdVifaK7ydRIFooXA9lTyr+MqF0689bg9kyrs4nR2LtGCSPKWr8cCrqIVqrrgkwOPgR9AXvvozSzC8Wrj+IRYkvOX8ocv3XyMb5IRSjzOgUKpjRkO9mnTMDC4/K17nFN2ZfXhDZqSrz3+xlGDPAqqem6vyvXtJkRQWjG4lDLZdFfcAPtOJvcp5sQw+pIkZ1VyifFy/pYWw/pN3Eg99UBBGftc/H6Ng6AsfJmxVrF/6GhkAv7excTWyqUXqQPcl+5I66KUm9/GDH3WV/9r2SVtqf5cYs8xRKOO/w+yp44nO0WDV0Q51O3lQFqTW5HY2+bwD1KfCvSTuzrRKXpf9/ACH9AIAwuHPrLR0i3lRfqo01SlCG1AU/Wyonwb1V8TGBuY3ED5I5L1HQfItyLcG0Ra0XrV8ukjvw6TMFk44u5LZ8krmQ8SBPB3FDH4PKapGyxuRf19ix3gKpj1yIf1eM8dPf9Cu3kwju5Qka3gcvMLei6kwwFWmFrv88cjMnv6BANztvT5K0BPfv85UvkQjIcQ4qoG1dPkv/QZyx7An4iaZk4IU+Bb7uUVH29DUvLCrOFwFSX/3Gj8pBWR2488aYdQY/wqB5yA/uNcwISFU9S6QhnPo75XRyu6ZTKnkUQiuV1ZaXVbX3JLFrZyMAF4S22z+iH3nDdyW2uB8H8CC6xk+5oDm1V9SexyVTtcIxzm+fuI2I7N/ncfKiMfYvYB+i2hysPjxkCTj3nPv8LRSs6a7XZOsE/5k+Pd5q9Orma+07gQKpCU/l5/JHZhUlpJWEqjuFRviQUbaEEGAzLRcPKuEZPwx706fW8yYbj7TLn3495v3KD9RCBFAePK+ijsdz4EhQwugDo1/Sv8Bj2QHAWsyL0dBul+jKZokkoMs4pAUSA959FZNibw0Ikc46vG87VcaKIvyNqENTAlffDmv3EDHQTXgVwU3OFs2vc6UwBUEuWfvqvhLLNCgof
 K2cBj+rx
 F6nWb/p8s4flmJSVkRoyUV0vHk2S/JTb7y65yK+vk69VTJmzsgzKmz5ciSxYtIGob5ECTk8jqXix7drp2w7Z2+v8vqUPgHqamA0wvnyhNc1Dt6mZdIPRhrBDgfEOOl7Lgfruj/aK2WyC8a7l/MXRzJF2DtLJTp7vj6gjsb6U5hXEebB6Ebjj1c1yY60OxZ+eLNQB0hTnH3y8PpxuYR2ti8Ahf761FWyTRaswTR7U0CsHeiXBjMqhzYv5/UqzYtv8MzzuuGsv3gtamd8FIlcAs/zRRoyq2Gaiq5bc5Owa1FCqeHCNdPRYtgLsqETcidXiTXFcDbum/ckdCEOM2T8QB0tcRjt7p+zN1rH9yJ0ll/0jMyF4IZrcVXDfDccQu+CbtBxpuT8nbI9DKxs810HFnHWuP+rOuf9LJSFgLBKlPocDDkHVgxEhK09RrmNnV8IR7eL8f1Oov/eevqSsOSH8C4YiVK0Dip4d2ikVMWJjPY7tfzIzIS4DLvoXFNcFSBILx95vdzyCwq9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Sep 17, 2026 at 12:22 PM EDT, Lorenzo Stoakes (ARM) wrote:
> This header really makes little sense - every place it is included mm.h i=
s
> also included, and the header itself includes mm.h, so it does nothing to
> reduce header size.
>
> It also oddly does an #ifdef around checking VMA_HUGETLB_BIT, however
> VMA_HUGETLB_BIT is unconditionally available, and will never be set if
> hugetlb is not enabled.
>
> Simply remove the header, eliminate the odd ifdeffery and place the
> predicates in mm.h.
>
> The naming of these predicates is odd, but to keep changes separate, we
> will address this in a separate patch.
>
> The file was never put into MAINTAINERS so there's no change required
> there.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  drivers/gpu/drm/drm_gpusvm.c   |  2 +-
>  include/asm-generic/tlb.h      |  2 +-
>  include/linux/hugetlb.h        |  1 -
>  include/linux/hugetlb_inline.h | 28 ----------------------------
>  include/linux/mm.h             | 11 +++++++++++
>  include/linux/pagemap.h        |  1 -
>  include/linux/userfaultfd_k.h  |  1 -
>  kernel/sched/fair.c            |  1 -
>  mm/vma_internal.h              |  1 -
>  9 files changed, 13 insertions(+), 35 deletions(-)
>
Makes sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

--=20
Best Regards,
Yan, Zi


