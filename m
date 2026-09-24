Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A94D0C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 15:50:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6439B6B008C; Thu, 24 Sep 2026 11:50:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BD76B0092; Thu, 24 Sep 2026 11:50:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3246B0093; Thu, 24 Sep 2026 11:50:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF64A6B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 11:50:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDB6A1A03E2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:50:38 +0000 (UTC)
X-FDA: 85249093356.03.5855ABB
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011001.outbound.protection.outlook.com [52.101.52.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC45780009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:50:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IF6Z6NTA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790265036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xiYwQEGkKM+tsHhc5VwTwt7K0S2UtKAK9YfSG0KXgVg=;
	b=3/HawJIBka+3fZ+E1nFXTRRs34nBmt92jBLgwTuXNkNdBm6XOgLWUE8eLy5wGosKVpDQke
	ZwYE9jcbNK9qQla+By1Hu97oU2B/wRfwBar6Q54stqAVU5h4692cUVJRm6d9tQXEiJptHG
	tlaZJARp/R/T5cnqeJj9yxS6fxKjRWQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=IF6Z6NTA;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.1 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790265036;
	b=Wmt9HsuoyAXkqSgkxG1kgC2IRTuQYBm7A4c2f+mMTD2+Ah3SMPHRYXB1WHMRAfeoHVn7PI
	FEdyZDPtE3Blhq+J6GL6lFno3PlriO9UpEk/4T9UV1BC0S+nlX0skV8bkyboWee6Fwm+z+
	9LTDysnYFJ2KhHn7KbbY/ftP4VF4PdY=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=V0m6eg89kopQFl3u4IGUBlxCnRazbDM7W04AjUEYr82pv8x3G4EpPCeTJFTnq9Z3QRmF5PXWl55elFHrnYrWUn4x5FE12iIiO6F9A11TvvNhobLjyHxWiEU8biVfMLJHjaUZfYMiPQG9Tjbu3uZGBc/a1ulAl7XApQL/xa77nCyvqRRPPrCSxI27K8aewe8Q06odz3SUDH4abSX3Uv9yIJ2GcjQiQvjWGNT9gOuoa9rYWRzqHKthceT7n+BjEvtY0s+MlDIQulvEGA4DWoKN6n2l2paRfjj9tf1Hams1uPpHxnc1a4GsvHQNkMF3OK6h58qYgat5rnU5xII5t6dUYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xiYwQEGkKM+tsHhc5VwTwt7K0S2UtKAK9YfSG0KXgVg=;
 b=Gf3FvOtghUQBfr7F4QG4XyIMI6foJRQhNGdy256hkHEMKvApKl/Of58X25Zuuuzy3BEVB2afSZGGqyJqyr1C/R2ODJioj14x1TKCZ5Qb6o0sD40/IppygmWTsZt89iHlxYLmMoFxiZz66TNpkEJPZara/pzNkKCbXhofbpNOxybxN7+EHTKRSupSl9SE5TsvNrVMH4CdZ2H+NEor58jKQo+fTWTMQfUnb0ZZxMqRAgRmAVcn5GNG8yOpEQHS9DA0gordDSezG/XdQTJB2OxIdp/FAvbD3YwsetFAhId3D11+o+2yVzckZMpgi0gI0ZckCxVxultg+HkeNXlzgeCRow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xiYwQEGkKM+tsHhc5VwTwt7K0S2UtKAK9YfSG0KXgVg=;
 b=IF6Z6NTAI6zMdc80b8hHyu7XZ5ItC6YPpawMOAVwcEXXe/HtfKdW/gsVcwLD+HrX36GiVCpcWjLZi/UStlcuKnjO0ZGkxW9pqUjtKCYYykoW0RRZg8+DnC9YkFnYrMSy5sCZiq7DBPrQPnl8EofbQbCdDniNBexe5pkQUwe6nsLpvFCPRHs+u4GHzd36hLuuGS2IGhtOi5ilhY4PerGPsLd8mMnp/gdjmjKCO/IE+eMh5dQbSfJypmCakvvDzVi4IO6nerwHidZSF1SABPm0pOtAApXStVwUTsOSzqdGm5SvNctqL0x556wcEN/PDxWUMOjN/iwxYkT8tZxciJlx0Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW6PR12MB8916.namprd12.prod.outlook.com (2603:10b6:303:24b::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.451.18; Thu, 24 Sep
 2026 15:50:20 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0451.014; Thu, 24 Sep 2026
 15:50:20 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Doug Gilbert <dgilbert@interlog.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, Jaya Kumar <jayalk@intworks.biz>,
 Simona Vetter <simona@ffwll.ch>, Helge Deller <deller@gmx.de>,
 Sebastian Reichel <sre@kernel.org>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Anup Patel <anup@brainfault.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>,
 Xu Xin <xu.xin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-usb@vger.kernel.org,
 linux-rdma@vger.kernel.org, selinux@vger.kernel.org,
 linux-sound@vger.kernel.org, bpf@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 24/40] mm/mlock: eliminate weird VMA_IO_BIT abuse and
 simplify
Date: Thu, 24 Sep 2026 11:50:14 -0400
X-Mailer: MailMate (3.0r7032)
Message-ID: <CBD619D6-8717-4C81-B5EA-D1D0771BDA3A@nvidia.com>
In-Reply-To: <arT3K71l86fUVldk@gremlin>
References:
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-24-4583d8a23bca@kernel.org>
 <93672B94-BB0C-4713-8F8A-3619D81DB7BB@nvidia.com> <arT3K71l86fUVldk@gremlin>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-MS-Reactions: disallow
X-ClientProxiedBy: BN9PR03CA0293.namprd03.prod.outlook.com
 (2603:10b6:408:f5::28) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW6PR12MB8916:EE_
X-MS-Office365-Filtering-Correlation-Id: 3951ee8a-f586-4cea-8c7e-08df1a538978
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|23010399003|366016|1800799024|4143699003|11063799006|56012099006|10067099003|18002099003|22082099003|3023799007;
X-Microsoft-Antispam-Message-Info:
	/DYJt0aMJ6rftIKDZrc71LKGQ4W8+lcZLcsIYkbZGdwY2zccTnAXJPeDfYA+Nziv5GZkLnvQvTmx1APX7yJ3Z0fM+V/7rX4pRa1ELWppgvJS/vG9tUooAjm7RWGR7HIdd0fcLYEG+/l3W162rN6m82GQSKUzJJe0duMhzZpruk33ZhmtId0c59DpSkdTmwVwC7/EWHgvCrExEXpc1Wp0I9Yn/uWNm7PUK+B2F7BKf6VjN1ye91ceps1/+oKvvFFzACjuuiRwo/gatru1OqVKDO3Kw8dQlO/I5gV1eOxQRErokp0seL+Cr2Xu/yNCTbSDW3xrNqUzxXfA9QtQheVpGMMcdElcfVoYBNVYyWrdLEPIq2FySzJ8Lt98mN4Zl7/CuafIDohKB+7KDJuqFf4h2bI/92aGToe+hrIIbvaXOtTcqWziVak3sSDBxhLv+eTzciaUZCg0Fdqs5PCgy+8107nhabOQpkmMYDtABZhWaTFtsTvILoUSJfnOL0Pgol1NQrb3cSe5L3Nokxc7mf6OhuEi8lLzCUzOF2g6a6iWcbNIfeAtS42t/GmePumu8JZUjyDTvdhBrF8zUIrYov9hPRmGQnPFRWxf2BIHY48qxD0KAo0giYL6nCSgM5SUFXYSb8SQqPqIwTUM9jAX+BuUHU/esSPwNYZhC91uhPadmSI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(23010399003)(366016)(1800799024)(4143699003)(11063799006)(56012099006)(10067099003)(18002099003)(22082099003)(3023799007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JeJopQ5lfzE2bWSt/Rmd4DJiBX+xQ19R2cjS+3FNRB+VOfKsUyKVeiFNfFto?=
 =?us-ascii?Q?T1itSYQafYF82gHn8U/jUnW67ukMkUbFi8Vu9CYzq1vn+3bWo4drKKtbALjw?=
 =?us-ascii?Q?KhfgmQ6QO49d4xP6qbULxYFHNd3rJfmlsPDTynTfcj3eYuHBpbNZ/FHpvuuW?=
 =?us-ascii?Q?jx8R/J8gwSksEqNxwNHHWqCRJaSqzpQUvQD1uYeRxCuMVwhnaGTmmmhXaJ8B?=
 =?us-ascii?Q?GpnPmHPbShhZt0cD5onLQVoSD2RQxTcZ1wtiUfDNMoZkjWs9HeIHSCdM8LnT?=
 =?us-ascii?Q?bWk9ZSa8RsOPzvBbh6t++9lCMFGWE+lxd7KOgmnhH+Z/e2pyIGslV/2XCH3p?=
 =?us-ascii?Q?10qTuQyYf46q1PWd+O+DpXx/OiPIRgz8QgCI3xAU2KoZuG7E4sFdIdAuU/YK?=
 =?us-ascii?Q?of8TmfHniOwk4udbD+3+WEpEZ1jAgLASY3Mn2rq+ax5W2mti4qKiv76ax1Bi?=
 =?us-ascii?Q?9xh15nVXYneJTZbzYrXbmQyLdMe11FsPqUrdO/WrifsHtJjJzU1wKLK6Qu+Q?=
 =?us-ascii?Q?mCbA9fO5wRlkM0KBUwsrjpfAQOy3JmuuXU+wlQ+YGtVN7DzGQHfEohi19cpz?=
 =?us-ascii?Q?zwCeZvmO3V2UlMi5Jz0Kou33OUISZfBL5F7BWfZnl0b0K4/9KKFF2TQOiXv9?=
 =?us-ascii?Q?+QnbqDy+2Tr2KB8Ecsi5gbY3Kf8g2fyyN7Q7w99XI8HcacYOsvIwckOjl/IJ?=
 =?us-ascii?Q?os5jKc40ERkR5sbb3+ESbwM0hYcqv5xoqEZfQrGWfsW3ohtHKPgjXK7KIR/Y?=
 =?us-ascii?Q?RZL1hmRqnyloks/PznSICTu+x1FzulX1U/OrjHJyVHTUVRzb+dmI8vhrZq+/?=
 =?us-ascii?Q?iRX9w0H6ioRV//gYIFyrlLEu8TnyFPGUJzFyq7dU72ahIq9qwYCOyfbbXXH4?=
 =?us-ascii?Q?WnzHlO2Yut+2wTg1HvNOFxR56rQzcUVaMUov+qmIs8g5RD6E4JduQR2l/MHP?=
 =?us-ascii?Q?rtQCOcvitugM8YnO2pvWw+csx8n6oAWxf9rShnPLlbtiy6nzSeKh1JJnUVEX?=
 =?us-ascii?Q?BKu/1bACk6Pv2yK1ULFYmtgqUn4blD14c6U/LyvB90zdqt+2OO4K0xUO7plR?=
 =?us-ascii?Q?Y+AANLdWHtQcQWlsnzy8uZP3hAfZAbukv/aeu8Vd9pjWHQp4Q4/uGoL1MO3B?=
 =?us-ascii?Q?J3AvVrB0dcjCT1Oq/Y7YjXUFsfneZZLLzzjqZCXFv1GlspsxXGS9JT8PfVam?=
 =?us-ascii?Q?X50c5hH2anHbHVX65jlJqPa4y8jQbciLyrW5LjjfTVo8jTBUXqd0B4nRNySH?=
 =?us-ascii?Q?H5W37HtIv9R9zRrkAy3Y2WlUgHG/Ar0b76YR/gKmiPEBSoTYakyg8J8W1IyU?=
 =?us-ascii?Q?lDrhzr0q5X4PqS6vEhYdqHU85i+knwTMxAko+Py+Yvjt+ZBmipxC3Tytglqa?=
 =?us-ascii?Q?RcdCNcGHT55EDiB6IUqUL5/j/Xt80zy+FaNXnuuojKXc6xQjwhynj9qHW68z?=
 =?us-ascii?Q?+wQ2KlVlj8zp+J7MEpam2sp4fniY1miJYDZnd80O5AJO0Zo1a4P+YCCZg9uq?=
 =?us-ascii?Q?iNW5w23JZ7nokJfdxTTPHyo1W6+E2TYT3XtDWlY0JD0IUxmjduxz3jS9y4oX?=
 =?us-ascii?Q?blHc8YtDIVKjGyNgi7wOCpytbjdw2TN3Du5S93jmTOTFHq8xmrbOPTcnrcOc?=
 =?us-ascii?Q?aKBYmVL0VeNadD7HwwdJJMzUEHIrCihidb0S2x3tUv/NsceCCg5RfuIeFfd0?=
 =?us-ascii?Q?7Vy3JTwd09vU9/v86yNsbGr1jdC72MzbQfSI1ldMp2FAgNAFWSfgJddGaviK?=
 =?us-ascii?Q?PZRpuHwfVA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3951ee8a-f586-4cea-8c7e-08df1a538978
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Sep 2026 15:50:20.2851
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zN/2ejWQwO24ocq4CdeF4UkGV6z628t5mCXiPUme/B7EMRlZTdImbbwwAf3STLlS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8916
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC45780009
X-Stat-Signature: oiwu7w4do48m7jjtkqr6jgnxj53br3ue
X-Rspam-User: 
X-HE-Tag: 1790265035-978799
X-HE-Meta: U2FsdGVkX1+myCpbD262twb0Sh+Uu9nt8E9jJ26mT6Qk1NAU3rg4GzGjTjWS/ip4STEpdu4NAv8lWDihPvQ0nMVx3xxgxgdoDaBmuyrVm7uHviGsu1tZsZcPkdbCYlbOANX976+BCDLvq/xtqZLW6P9CZKCgCc8RGGvmRWFlOigfXT7ouu7t6RXG64/AB9b1b4/+djqF1bq6RC+yJLfyV/OyIHuhpVgLlmv/R0W9wNNqp5Ikdbg5z3DX1kv81TsQDccdw5TCXSwHX7tA78sPDYROMtwVmAsjML3Xtd6rn2V8P5JARO9MnsGLaykSWTKm1hsRXlUHFZ5nbYk+S8VOwVsy/tSdHK6ivdWm90bzrTN1oSJuJPC6G4svYFt04fZQjZ2pcgqh58y7U9q8oc1Ygj6vSXoHkTNi10urFm7mrurr1h1Hc/lQhCdO0c/bRyzhsnrxAKyHaXmOPauuWnACZNJknQ5V8Y2O3Bq/DpK9vEIuTkjA74pBtXdZrIve9HhZKu2+cNn3QNIvN3r9plTxBSr3qAMqjVUpBOAmg4I5XcivHnVZUMBujKlqMdhuokXnJB9MGbAT+UexWgiJr4VCEBEYSav713W3SacKWKilD0HWIi9S1OJqbMPfn8pv2Lyi6XTY4/rw9vgHmnwHeCNm7+HeDB/Sg7uRlElU2uKdheD+J0XFJQugX8U9UxY2RJcU9GR7/eyqMlTcsX4GVziwH0OTJR5Jn+gLlk0vrMJCUpaSCPVCGaTql5FX0J+lYUPXLghhM4uflHSfmhLNl57gswg8ZJARPzqBRNaXaYCWQj2RQtZXoCdjzio0oyryfVqxdelzmBtmp2KFsUGb5nvWG9Vyt/G3gQlkuFhrbYj1sO3v+xMAKj1bm+I/RnCKeQjR5Vt4vlTie8xgv57CZl9Fyb9A8RV8RAI0d/avpAPkH/I5WKT6CdXrKnhxmdhxd8jRriDubvxOerLvI/SnJ78
 EU0vAH/r
 evotP7wddT3PRVwfdOLlR//J3rdibPafwewbPCpVec8ZmFAOEDtosZUbEXOKfCSL1YdRPyBGlt/TPLoFKDJOYyCIY8Y2DPMLLLXrgpY/2p1tiwF3vQ9TlwnNp6tTPeCY5SK3Bdsyh4xdY+l8nWUNVcUNos39lSEUGFa5AbZ2g0L96OiB1gdad0TVyDZiYyD0lFZHzCrMmwGC/hz7jJgSMpKrnJz8NXLTxZ6oVaztpmfC6uOmvCGsjA4X9f0FYC6UGaqF5nPSDDZwsPGwmRw1n8lZrXOvQSFVr1n12aLY4I9GVsP587MhSey828saZAIsuXtrPjiCGbPNRC24TwffRExCFYtlwu3vRbYEdkFIaYo44SWrJtchfyC0C8aE73FqGBW2jFzRvIDTRkTi0mp47WPQftiW/dXwP9/hkXQLcNVemtSiJ5OL9iK6Fr7e2NUS6Bn7k5IKUFLhXCrIU2KqnnoaZ2LX//Z6dqzrHWTbW2zZq/ez4AkCUygfza/h3LsgacMxm54A7zqUjkg9WueYbXV8H37v4KzvNWT/viYRikOojghhbTmPjacJKKBUA9UWt/g6AmdetoTm7y7xgUzM2S8fKJcHV9ZTya7KreQ3IenEYX0mXKx/1EkxqyuZPPg5C0fBSm3hu6K030cX1VMAvnYTLII/rMX0Y8cg+oUMrndYJZVIjpyeS4epPAUUkFQhTSyDxHxAnVu05OukV9HmJOgfx8cP8sus2XODXq7lzZLSL+tzMEhKtVmZXZswvrVteKCudCGeybuaJTBseO7BSda7vavlazgg3vdoJe8QfY2jq6ZB90oxCwOg4mtxWScAJYuWPEaXz4XD+wVERmsh4NxNLbjZ1CT7nM/P5uC84xUBqGINzXlGPEKe7is2e6ex7SvoxNrtI7ldYfCkWjOLjoFIEGy4tt7rXMiIKfMQEGxn1+IFtgs/gpHGJNlxMEiTb0E3mnb/WletiZ3UK5kQffnSWzr6B
 cgH89/Rz
 FR35+ssBbqsfihkn58uEt2LyxNaHBKC0oiFpseAKQpIida59yVHLW4NdSKtdCW9Z3BxyM8+hPZ370slh68+KNTXagCvJRi8SQW6DARNc2CRrHAoIJ8zxzDKrM0+LrEmg1SsTShQLjSTrq5jPseYgNJuRQph+Pgx13E7JQbxzrLIM/6n01oDkaKaNWu1vZJ/CC1Y5ZQdLzyInxVrGtK0gCVJzsG+72r8dv1n52B4ivRp8ejZzmh8GPJ1tJcvGpdcc8IFrV201PU4rU6EwuV4sDONeU8J01Vlz7bmXguENihl0fShlILOb6Qn1ZlY3mHGV4iXXxBmAIgat3kaxHsVKo+eQcFTnV7Aq4bTHrb6/ixeBYkDZng8f3g6h/qi+mJkWuleuBvNTpmGY4FXhi8uCi8ue89xthJz6kBcsrAB8bogCd0iaKCqwZDizHCNTnUvURoVS3+938IqpGC3TssYdpZstkf20lG5lInM9a98tOQe1QgEzl3cIFn+HcPRygxWXllG/DGEMfzMlKk84Lqjak2lKQEqm0tHGMb08M0T0RMcIo45VOWqVeNfMMUQYWWf7Cxsx82iGjxpnbAifBzOgL9fncETdB026xaVQ+jyaS0PuPO4Kzb5Wqy0HCFieAdP4Almq8H66rps1B7vZKsW6Hl/ghRxW2s9brQ0z8QW91oG4LvIrODOuDkru4XvHeA0IyTQciWi/0j4pI9sDTht1Tmi3ilW2WCyqnzY20z8KsVd6OQ88BASRoOttwJTXw1U34K7YlAahReRaKP0xXr6dOTrmtWKy7VNdHD8/LLF9+JxqlPggC3XEartwCWh00cZRza7ELLKRbFu09CxqdqfmFSt7mrM/RLU/FT1qoxlPrN1R9HVonPfMOedzV8y1l5FIbNsvFGaIY3mdAZbIZQWRIuKrRaOwwxt3NbSHxokUyYXIGclHnkPr9aqeLuqJEIHzqEIj+5NJBDW8gRwxHQJbBX/gy5oCS
 PBMTqi/i
 rpjWRsC2Hqer7KM0CnD4tvz0fLm9F6lmqbDNjmE70jZxWPdy4xfmGN1ZRg9NLKmN64PNU+R8lfE/OAOdWqHCsNthggCU+VJG4QCYOb9MpcAQ/FGnRKufOHoIE7R88CaPJHwrvex8U/lghocv507N6uWikyyW2Sf8WT3uUkGHqCkJcQL6CVLQOP24qZDEgghDGy7+eaIPNnk5zysPTz0uPIuYKQE2oDZpWGwbueftiGi920B8JGeJ03RFHbP+yY0oqxItS6vGriRgWjuLtY8wHMIM884H0g7vGie5jRdBFfIhsThNrytOOYA2vZE7yV2BOQawKc7/1egBLgYwl/uQLcYgnlu0Rr0DkMCZXu2OKO7yaZx95y/0tkdV/dM1WbMQdOWWkgFli0UjM18oJAreqyeYm7ED1b7Gh8j3Q6vlIA2aFH0dNgMo+2XBfoCcMd6F0gl9Tfo/En4IolCKblLLE5RwF8zrnuZdbmcpXwg/YOnlQruFSMoN5WjN/JqfmQCAfIRTlwX7Xrqx1X0wIuLR3jrwd9cHmWX5zRtJYBrUKK5pTdGA155K+Sb+gtA37lBbeK73kvt5uE8En9mosUBMR8SeymKfBAe+siyYXBcZc1fdYwHBwgorKBzZk6Bgxg9uJJXgwnnnjJM5u/FINBUSBQz2UbrgXsBfKp7TMUuT/MynnaC+PW5RGNTjnfCERmtoF7BZAm/VTCmL9om9Nzp8g32SULjnL+CTIwu3/2PjMCOlCoOwEWgGqI9vu8dakNE53wLQOouttmCLW72cI0T/+WrvUlPvtwGPPaKRZam0tmET2aai/MaGByV+Gxv9ZiIxmCCv2ReyNaUp4sOv+NSmHxwM7Hcr96loi8/DWrv5zb1OFFLlMG1Z65u+175r9WsUfS3Kd3yaMKumWWHfiPrv86NHNIQfHdZDpBaIZyFI1rmoziuoEgYq01VGK4qT0VpH1Pk0dzxi89Ir5+ARfOPk4NCWrHave
 xdGmM9u1
 NpjfnfxUOJyC3QDSM22P8cgbaKkPQz/aZMGHG6OiJj6pr3nNWpzGZQ47qNO+6TnwHA75Z0F83HvFfwLGFsvEFfFoERU+4DRkTNgkr3AUlSfgGsZ6sFNr2ol9shxo0iZCEyAiosAW4DzHXjYeN4Vitwkx7yK26CMshtY6VgXpAJSmFlWUZN/fXJK9VgLJ5wEFbq0kKg3Oqtco76QFt7HEAWHjZvirus58daj+o8b9YNHrh6czbPWemD0f7ln613SbRIdvMzgNQ6UOCuR/nuIAJGuJ4xTm2g1YpmSLFRWEUp2V7xHR5MpolX5lYC4jxGVDQz4olQSeXnmC9z9ppy5TKR7hr52f88sAo66+mNqsXOgzyHbCfuYVIrJbHM8aD89URXkvZ6Xe70Qb2IueYYvslaFXUQHvSocBXD0vyYTEGG6Bv7PNABu2PBlC8lN33NHx5AlmVvcTBGsgmkLDNOFvSicpYu1w3m0gwCa0CA0PDGkfn5hyZc9X+s4RqashwcFBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24 Sep 2026, at 6:21, Lorenzo Stoakes (ARM) wrote:

> On Wed, Sep 23, 2026 at 04:06:14PM -0400, Zi Yan wrote:
>> On 17 Sep 2026, at 12:22, Lorenzo Stoakes (ARM) wrote:
>>
>>> When performing mlock() or munlock() otherwise normal VMAs have VMA_I=
O_BIT
>>> solely to fix a race with migration which might otherwise double-coun=
t
>>> mlock VMAs.
>>>
>>> This is unnecessary - at the point of applying folio mlock state, whe=
ther
>>> setting or clearing PG_mlocked, we know whether or not we are locking=
=2E
>>>
>>> Solve this in two ways - thread a boolean through the page table walk=

>>> indicating whether a lock or unlock is being performed, and run a loc=
king
>>> walk with VMA_LOCKONFAULT_BIT set and VMA_LOCKED_BIT cleared.
>>>
>>> This state never occurs otherwise, as VMA_LOCKONFAULT_BIT always impl=
ies
>>> VMA_LOCKED_BIT. These are also always cleared together.
>>>
>>> Then, update folio_add_lru_vma() and mlock_folio() to check only for
>>> VMA_LOCKED_BIT, and update try_to_unmap_one() to check for VMA_LOCKED=
_MASK
>>> instead.
>>>
>>> Also remove the useless invocation of allow_mlock_munlock() which sim=
ply
>>> returns true if unlocking and instead rename it to allow_mlock() and =
only
>>> call it when locking.
>>>
>>> Finally, with the other mlock abuse of VMA_IO_BIT addressed, update
>>> mlock_vma_folio() and folio_add_lru_vma() to simply test for
>>> VMA_LOCKED_BIT. munlock_vma_folio() tests VMA_LOCKED_MASK instead, as=
 an
>>> unmap racing with the locking walk must still munlock folios the walk=
 has
>>> already counted.
>>>
>>> While here, also replace some deprecated VMA flag predicates.
>>>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>>  mm/folio.c    |  2 +-
>>>  mm/internal.h | 10 +++++++---
>>>  mm/mlock.c    | 51 +++++++++++++++++++------------------------------=
--
>>>  mm/rmap.c     |  4 +++-
>>>  4 files changed, 30 insertions(+), 37 deletions(-)
>>>
>>> diff --git a/mm/folio.c b/mm/folio.c
>>> index 47a437e0f7fd..35e242b48870 100644
>>> --- a/mm/folio.c
>>> +++ b/mm/folio.c
>>> @@ -505,7 +505,7 @@ void folio_add_lru_vma(struct folio *folio, struc=
t vm_area_struct *vma)
>>>  {
>>>  	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
>>>
>>> -	if (unlikely((vma->vm_flags & (VM_LOCKED | VM_SPECIAL)) =3D=3D VM_L=
OCKED))
>>> +	if (vma_test(vma, VMA_LOCKED_BIT))
>>
>> I think it is worth documenting VMA_LOCKONFAULT_BIT alone means mlock =
in
>> progress, like you did in munlock_vma_folio(). Just to keep the protoc=
ol
>> explicit for all the readers.
>
> Well I'm not sure it's necessary here honestly, because this never chec=
ked
> VMA_LOCKED_MASK anyway, and VMA_LOCKONFAULT_BIT never made a difference=
=2E
>
> So the meaning of VMA_LOCKED_BIT here is strictly 'is it locked' and it=
's
> correctly handled.
>
> And I fear that it becomes whack-a-mole - the neat thing about this cha=
nge is
> that you no longer have to special case the stupid VM_SPECIAL thing, an=
d can in
> fact do the 'normal' thing of _just checking_ VMA_LOCKED_BIT :)
>
> So I think it's better not to.

Your reasoning makes sense to me.

>
>>
>>>  		mlock_new_folio(folio);
>>>  	else
>>>  		folio_add_lru(folio);
>>> diff --git a/mm/internal.h b/mm/internal.h
>>> index b2c6c9435021..84aa3e6c8bac 100644
>>> --- a/mm/internal.h
>>> +++ b/mm/internal.h
>>> @@ -971,8 +971,7 @@ void mlock_folio(struct folio *folio);
>>>  static inline void mlock_vma_folio(struct folio *folio,
>>>  				struct vm_area_struct *vma)
>>>  {
>>> -	/* The VM_IO check prevents migration from double-counting during m=
lock. */
>>> -	if (unlikely((vma->vm_flags & (VM_LOCKED|VM_SPECIAL)) =3D=3D VM_LOC=
KED))
>>> +	if (vma_test(vma, VMA_LOCKED_BIT))
>>
>> Ditto.
>
> Similar reasoning to above.
>
>>
>>>  		mlock_folio(folio);
>>>  }
>>>
>>> @@ -989,7 +988,12 @@ static inline void munlock_vma_folio(struct foli=
o *folio,
>>>  	 * always munlock the folio and page reclaim will correct it
>>>  	 * if it's wrong.
>>>  	 */
>>> -	if (unlikely(vma->vm_flags & VM_LOCKED))
>>> +	/*
>>> +	 * VMA_LOCKONFAULT_BIT alone marks an mlock walk in progress, see
>>> +	 * mlock_vma_pages_range(). An unmap racing with the walk must stil=
l
>>> +	 * munlock folios the walk has already counted.
>>> +	 */
>
> Here it's worth mentioning, as it's specifically relying on the new
> behaviour. Although it's neatly using the VMA_LOCKED_MASK to handle bot=
h the
> locked case and the 'being locked' case :)
>
>>> +	if (unlikely(vma_test_any_mask(vma, VMA_LOCKED_MASK)))
>>>  		munlock_folio(folio);
>>>  }
>>>
>>
>> Why I am commenting in the middle of the series? Because I am taking
>> a quiz given by LLM based on this series to get myself enough backgrou=
nd
>> knowledge to review this series. This mlock part came up at part E
>> and I only have part F left before I can do the full review. :)
>
> Thanks! :) I really appreciate you taking the time to look at this! Sor=
ry it's
> so large.

Sure. It is great learning material for me. Thank you for the patches.

>
> I held this series back from last cycle to help with review load, then =
spent
> some time fixing various AI-discovered things, and all the patches are =
necessary
> (well for the most part) to get where the series needs to go.
>
> I think the change is worth it though!

Of course, great to see hacky code being removed by this series.

For this patch, feel free to add

Reviewed-by: Zi Yan <ziy@nvidia.com>



Best Regards,
Yan, Zi

