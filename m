Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C72B5D2ECEF
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186F16B0341; Mon, 19 Jan 2026 18:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D816B0343; Mon, 19 Jan 2026 18:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15B46B0341; Mon, 19 Jan 2026 18:14:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEF116B033E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:14:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8537B7FB7
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:14:51 +0000 (UTC)
X-FDA: 84350270382.30.C1C56B1
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010036.outbound.protection.outlook.com [52.101.85.36])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E246A000D;
	Mon, 19 Jan 2026 23:14:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TtjvlLGm;
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.36 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768864488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0S8O1hiHlQ4m25SuE6tEjrKZ/RCiI+pmncwMyOxQetM=;
	b=f6Av1A1tep/s/NmijzBy3CbVoroQqVhBn+4MeFrb73k0TOGymjxHze9qMR+N6/3wdcIdga
	QT49hnRAOu1olbYCa+yYpSo+0IwoHmUYDp8tQRNMnFWwhWBiTXXpacTuBMBuJTlrwbdE7L
	Mj1J5knZDGHcHjNJcft7ROIGrlk2oQA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=TtjvlLGm;
	spf=pass (imf25.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.36 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768864488; a=rsa-sha256;
	cv=pass;
	b=5O1kJTypJeVx8HDLMKUXZWsZ+M06m7+sPZYB/wvKwjTHQq90YjhbV9y1/JxNqVCkVD0ZN1
	fz6ia6lhYJEvO4h9TNUez3kOAOxZw7bMj7HQJ2WXCCZABMjg8hxX2E6jsSIEBUMQ7vxCod
	WNpU10pjBX/yyqyhOfJaU5OCj9Bggtc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=f0eZfFMM1jrMWSW9YoVhpzCjLDQ/o95Kui+dfY+7ZNHKKZlZQF9wdTSAfJ6jVrZkf1FXswKG8hTS4XrJygDBJgM4vQtWX4gaNIfPnKs2khu+LGYc4xFzIbKXrQqPK3cJdd1A5V8jkUQEzu/0WVp2q6RMKSIU+8dRR/2lQc3UecOKL+yW5VHJclJbhTVZbes0mjsDr+/ESkDteZGGz0vHYMt3Obciig1nI7RPXu00fA7rO1zKCIiX7ryIqxocIe56d71FGyT3Kc+L57OH09xbZ+N6EhyvGPscM5WNGUud5GEPOT2tefKyRHfk+1hUjJvoglpvZs0mtSq35lBBlKml6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0S8O1hiHlQ4m25SuE6tEjrKZ/RCiI+pmncwMyOxQetM=;
 b=SeO5ZCLGvdbCPNb/A7JVPvAoKBQR+MEje5VM5WGnZlBcLOy8EZRGooDI//0P4mBljz4QR3ECCKPvN3deC8k1FGVEXwQLu6V5CjAKOfm5fFWkwonzYzL8vnfYz20awDIlhE6BJ58wvnWF2VN1rK/qi1gcuH81BMg3qGmVddBfnBB0HPpQ8XpZvH5+T4gAt/mL7+0kpvVdVTPeFHbMewpjrzL3HyOr1H4fSATGnqdkoXOduyDVb6pIopHNswr6yCTORdS1UTgEsjjbU6UYtnT0V3qQCcMsXZMqBLVjDg6SiuTnMfBroLFyFR/wzfl092s8UW8bVPRt22uJSMTSwc8bew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0S8O1hiHlQ4m25SuE6tEjrKZ/RCiI+pmncwMyOxQetM=;
 b=TtjvlLGmpy3u+yC2gCrf1KMi2b4Bh6HfgOso6ZcaGaJ9ymKuhIfG8OZE2dWBkpFbgED68rejYWbigauF+fO3BT5jh8oEzbfnWIi4k/NJogvbTysgV2F36HOzHDliNIZGEQuG+lJrjrFXY6S9M8RnJXkbMn92URU/si6cxGfRXzgEcl35AXDl2GyLv9Ci2E/lSKnq7dcsJPM69ajPdJstLdDmeggLkdaNgxGjye54d2vNRn/TkgVyHbs9BL1Hk5hfNLCZOehCjcZ9sIV4ySLz4E2AVw+WLCB/Fn6oqM9RwVfVTg0LEzJ3pL00uNNZsjw9T/jlj9/orOZwu77LIpJJ4g==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by PH7PR12MB7116.namprd12.prod.outlook.com (2603:10b6:510:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 23:14:44 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::1b59:c8a2:4c00:8a2c%3]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 23:14:44 +0000
Date: Mon, 19 Jan 2026 19:14:43 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Benjamin LaHaise <bcrl@kvack.org>, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	David Howells <dhowells@redhat.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-sgx@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-mm@kvack.org, ntfs3@lists.linux.dev, devel@lists.orangefs.org,
	linux-xfs@vger.kernel.org, keyrings@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH RESEND 00/12] mm: add bitmap VMA flag helpers and convert
 all mmap_prepare to use them
Message-ID: <20260119231443.GT1134360@nvidia.com>
References: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1768857200.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: MN2PR17CA0008.namprd17.prod.outlook.com
 (2603:10b6:208:15e::21) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|PH7PR12MB7116:EE_
X-MS-Office365-Filtering-Correlation-Id: 6456cf91-f409-460b-1fec-08de57b08802
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tSplX4pOJ8CmO18rSXCqTCkufV0sadsiAhorP8Vb+UsIHmWt8lzctSzYV0CG?=
 =?us-ascii?Q?5UYsfYrg8BvFUCKC3tfnAwdtsS3hveUfnhmAZQ3rqwzAaEXV1Hd/bGBjKxQ0?=
 =?us-ascii?Q?3UPmDHFyQ8gj3/QtCK/5UNz5SBHZhcowyNGnx5cWbyS5A2NvfM/2ILanzMu8?=
 =?us-ascii?Q?6Ey5Zv7GtNYM1z9k7Racn9Njt8bJ8RXAvaP9R6mZmEbNeTEffLZ+da7zAHTr?=
 =?us-ascii?Q?4u0Z+nO67rG4ec8wZh/DvfUPZU7tWuimLC0N3f0/noJdIfoUHUV9QvIr3xW9?=
 =?us-ascii?Q?oiwuENwtN3DPXBtX4O1Ta9/me/5sFubn8L8KTOZv+HoTtVd/KcYH+fPtLc/F?=
 =?us-ascii?Q?4yTU2UncOhSE7AGon97RQMQctIAOaehtRP7k//9zsRJFZOXHqGionhP4TMmE?=
 =?us-ascii?Q?pXZ5f+f78xSu2YOo3tTaLDiPjy2C+ik36c+c9Fd91hcWES9GubrIAVMJnzos?=
 =?us-ascii?Q?kbBVtF6WJQm2raa19BaVS9W2faObyQUyXmy9RLyoMd4DeRgiArBpN/7aOubS?=
 =?us-ascii?Q?cO3AJR6QsyaPLbE1xPR/tiF5lLPP8jvJ8WP6Q2wOeMtdUEktwtg9yCNm+eIO?=
 =?us-ascii?Q?ljCZCdpXBxryqz1gENxKo1K+mGEBgUwaSt+2p/C2c21wJuNE1B+76hFS2Lrv?=
 =?us-ascii?Q?SAdYvoTVARzUCDYgwuMoWIq6FyxdGHZza88w7LLpY7P4uJurgSMFa4LvFiLr?=
 =?us-ascii?Q?3vHkABBbnhELGPg591UF5o3NsXa6cW+OeDpVVQ4QmkrO2oq40UCwQfHY7ihZ?=
 =?us-ascii?Q?yhBliPB2raNgUlTtbp45N8Fp3cf8lJOlYWreyUFfp/GDIfm9ywFhvUCgd6Vd?=
 =?us-ascii?Q?kuL/lgQFwoZj7YSFiXQ4PL+muSmdZWVnhv5Yz3gmxfqNiCvn8pEEn+L6Mt19?=
 =?us-ascii?Q?3mGaDTsgLexaL/79LgiJkiG/lEu31mpdvjQuWwMI6VObMzPNlS2RqHdHh37y?=
 =?us-ascii?Q?YHDYYWOodqFWN5ttfkWsp94RnPivtB9zeXzuVy3w2ctDlG+ihb8R18Cdd14p?=
 =?us-ascii?Q?f+8o+t/wkVmpuiBmOT/m+kNmemNwakvDV2qYwTAfq39f2LGwxVqAvR6OKGtg?=
 =?us-ascii?Q?zxTsT5huRTBsziV6NMBz587f1m4RMqSdKjSF4CiFr3geCtAhZ2zpGTsq4Xe3?=
 =?us-ascii?Q?suEcCXU/l2oFoNg+ROti2gmgcHiYa5obqhDCx6dFbhy6WCZqaS+WKDoXKK6T?=
 =?us-ascii?Q?2qeiU6UHDz857E33ibG0jkktJwTU74F5iKOEPbDqkjy3rDmgwpunr8IL8gkM?=
 =?us-ascii?Q?z67Cic0qHCvJgbju2/JBM2tiC/OP2SKJUnkz1gIPOkZSCMjIdShCfmus8x+j?=
 =?us-ascii?Q?QoPNm4nmBv3HTdfXcx535QFvgXfGvnlKiMO6O9QyZP51rRmnKN8Vpwidneb+?=
 =?us-ascii?Q?fIRWJsHS4ed3wjCmgIMcVpBdNpNyWbiC2AiBF1PWzUOTYMcOB3iZpsyQpoWH?=
 =?us-ascii?Q?pMJpxXWXwI+cV4rtuB7G32ueEK3GPG0zrdq/N9lf9XMAWAVpSMTY5/DeYHrf?=
 =?us-ascii?Q?oTgok96huMQ8CEQOCyJFduDUFGimhw0dA89xQhIQCUjBOmvqbCzCJ69PCNsY?=
 =?us-ascii?Q?8366SGuvwSO6A5j5v0Q=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TOHMVlVDrrTvXiIYN2+I5cimEGsEGbRgC3X1N2FgfdirFY2nZ1xkoy7pZdky?=
 =?us-ascii?Q?dgooqNqG9nGppKOMCMZ9jP66PTVGXzJQHbIeouRni72LjDAvPpLy2qDzL3wo?=
 =?us-ascii?Q?uMYXcqKzGntioMUdEmJnfb7KtYk/FLrep6rlV5yZlYdsfXrLZcZsrYJhN0SV?=
 =?us-ascii?Q?EoRluN08AQvBZxbknVPI/o8TK69yFl62QDx0xuHqEK+xr2jkFaoAx4vJXhg0?=
 =?us-ascii?Q?IvCUeTFMYK4PWSr841C5MJh+KLRgBNl5s8qyKrnP3OveODG+RfyKUZVsfqLV?=
 =?us-ascii?Q?s3cneyyctZGObC56r0iUdXCdoJu+oAybeBjjQ1Xn9TVGX+ZilJF8MIV4ZIEF?=
 =?us-ascii?Q?z6MsOAUdMUdEKnA8tki4nqJAw4BOUPuDhTUy8rDr8LeyKCUYJGTpg2XLSn85?=
 =?us-ascii?Q?deX3bBN1z5kjpU4ullUZWHNoN+T3TxPJ2wumVCG/s6JbGvZDfGBTRtJfsMda?=
 =?us-ascii?Q?Scxj0qpyrAjPx0X/iZoUM9XeQLEZCAHvH6CXwAXNtBzVNalhUQMUWtCPhH+1?=
 =?us-ascii?Q?DNl5xaPZSTHE0zNS2/cXwO2T7nDtT3WnG1zzXACP5jcZX8ktMh+lK7zGwAjn?=
 =?us-ascii?Q?MHB2k5H8p6UMTaD3F0jj5DAmlzPqUARKoI4DZhvWRHJWmgGiGRNy+Ehr6JSB?=
 =?us-ascii?Q?T1489eEMKK5kDN/vPjPT3zBGXPSinXJMH18m7Fq5HL18RGLtY43atzuPvAyO?=
 =?us-ascii?Q?/b0MSgloMQY8UtigHEguklCjmbb4Elx81uRQVQcy5/r8XSB8yOWRs8dbm9KL?=
 =?us-ascii?Q?znm+T2lqmWd/Nfv49uGTIo+ieeDCPb+JGXtdtYCGZZsBf5X4hBsxElH/LW5G?=
 =?us-ascii?Q?RI9+uLVYl3d+jKYGRNiZlMthDXkkn5QTmR/6g5MWfAODcQ9dPJ0MLnn5P7J1?=
 =?us-ascii?Q?PUPNXmt9z5GyERkpwSWo4Nc9Kq/znamNgz7epXh4irtZC2JoPZIn+YoCE30N?=
 =?us-ascii?Q?zt/Z8gEdKd1sslOPI/MJOCzLlut9H/b+R7MQrhUZWCwGR5lThNsWCfTKhXz8?=
 =?us-ascii?Q?28YGzY9m9qy3oS/D9NMQ+g9n3PSvxaDXy8lnULlNwqAsv+P96ta3QTb9yPcO?=
 =?us-ascii?Q?EdjCUqd8l5fnhtdmA0wNtch2CGls0pbQBFVjp6NWRfxxXFeZXEtK+3AtACbn?=
 =?us-ascii?Q?25HtRXz7M6f3IP1NvCF5riQV8oCPyBodRMC+zQpfQA7MEiL+Pg1OmcSPUJNk?=
 =?us-ascii?Q?L74SUweakrZf3f33iDeuJUtDGlmWmirlMn6x0baexD2H5FpiUW9w2BhlbyDP?=
 =?us-ascii?Q?PdEJnh8imD/embnx57mCSRQMPdsJjxTJ7eCiwEen086N5XVIKvT/W5wctDxY?=
 =?us-ascii?Q?OlPtWP9yvkH8WGjxiShvzCZa76sByLU6cbh9PQj81Z+ShE4TLFdIigbG/hIH?=
 =?us-ascii?Q?T/GBVAUXm8pXlSfMLS77eJgVzvago8ouxS7n0XMazZhHNiBmJ1kazydjQNPi?=
 =?us-ascii?Q?4BXHNl3T5CatY/zvw+MW66Ice6flpYgysgrTQGT2kHUfmdAUYbALEFI/9YsV?=
 =?us-ascii?Q?Ba+ZL/+VWPBopQNFOcRMlNlAc7tdBa2M+bauVYwuEifm4z0+zp+bhKYU5lNn?=
 =?us-ascii?Q?yHpY2cIdt1jv6E7umHvNBT+Y4zbMu7T3aGifRjMuCq1yPLYNiktnrEtcOKm4?=
 =?us-ascii?Q?sIQCfxi+VPUYv+IYdSbJ12iuQJU5YKI5CfkAh40nB/CAoG5ezJ4qp7VFg03S?=
 =?us-ascii?Q?NcEWjqrEnjlo4gkcecT/YSGgYnLHocknvsDCvcGBs+MeXfYKONwcCbve7Irm?=
 =?us-ascii?Q?lfoEg+cBsQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6456cf91-f409-460b-1fec-08de57b08802
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 23:14:44.2173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zwk2joAm/V7SnpJ0UEnUaOsAV6uczrKchITot2iVGb92xsSkJWrPBZ2oVYFKsVZ8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7116
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4E246A000D
X-Stat-Signature: 44bb54ug5ch6emo5gj9qag8gdfbj4i1d
X-HE-Tag: 1768864488-33719
X-HE-Meta: U2FsdGVkX1/5Cg4Tca4spQpdwLmKRpXIvv9EA2lJ3GVsIATuihEunwEHGe86xF7yqWYiP0h8UOLHr2vQ/3dJgcuXSBW5451cEYVzUkKBBSOnjER3HHcV4wLNK2ZgoEZxdlf1YcUdw6z55OpO1dqHKdFwFQd+KFtYVJC1A6InS2hrujgqh9eJf6e6Bpm/PJ622B3k6gF6ZCF+0GtTM7Xn24n/j2aLt0W5YFhUSTvETNO12KYwiVRD1HvK53nghM6FP1uYfCL8KuBMZBBzPMB5qiPkG4R+ZmokDmVpTWd16foapLXN6SPtJAH9IEeLU9BrK+VpVgmhrj9I8MCJCRiTHyPLB/EkY+GkECqM5Ad3cca//DysgY1ZYM39jxX3R5+rjRzR/GobKkfr9Fp9aLM6Y+/orxzmPbsp4uvsG+OWAs9KGhxf6wr5hdwhPOm5u9m3n1myfCWiK+V9IOEqEDDPCP8y9AVJz1hZ48xs9nZWENYXNeedMTHN0G3gOHAsqX0waQjtiAnGa2nz69CRMgmarc5E+it2JVjCHOGzC4AMBfn8z2Ue0sdoBUeVbH7hl0otKa/yYlGhkI7+e/BkWZgLi7U2er4MS7UvQApRFHYTO6WtRw8Veh36Bp2OiEnvnaK5LXGIafQ0wuk1K4gINCQIqhCzic5HEAVUmQBRABkNfkAzF1jr1jYy8ypFtAxdlwNBAoJNxLiZ1i4saEKvaUJPlHKCF/q5tdcYPwLQ+tE9r6k0g9IWYW5Uk2oKWSNnCRUpSovQgwg+TqCPAiSDlaaKPQeR6D1sshtuhEpV/0XC7pFa8QYKLNH3YicHA6x/nOu+scDWJ3bEoyzSBw9Gc4tTJgWYbWk6C6JdC7/3nghEyyXPGuTqJASG5CAEVVfDC5tdFrK9xVO4HIfKOpl2sPXaXD5MI2CJcfG5UEEXf9Ds1v1CYhG5p/M5N+ybHeKO16H/a+UST7KmG1uuiehDYby
 lP1tEpBn
 A0uuyHCZ1fpKi+dIE6JTvqGmzD2xfCBdKBQDmTeaUxA6cvRW+fPUoOtUJKsUCfM+N88BI/RVGZn3NcGYW/kdAM8mMp30Hu9nWgLphwactT2iXlzBWYUjhBjz7GH5Tn1nVI2mD9y3yCKtt0wgOow5TbH8otKicFHvbL3z/FCFPLP78JWHcWocnsLzHcftqniMvXuX+/IT5Gp5B8rnfCKSoa4XcSwnPWrnMjn2lwv+g2+V1J0lz1EKfjZaW8bFpuW7ifjTVGoCJ07l0koaW820ksWuq8wNXBLrWLjK6esqy2Sxrjtgzx+gXah/0InC71OxPXQBsLDN/LhWNYcSfTgC/BQ/o9bPv8sy8e/ovmQhcFMmqmgS7jpKGH+I4u6ulkDhZn/E2BXeWxGLZyQLk1gOhyLRZ/tuAWP+dBMs38Zu52VhYBxU7KPpt/yCo5534bD3XrFKwezN8SnKrd9Rx86rXo35ihR+Igw/BZVGtMTSU/QdeY1Np20Cr+RdVPM1f9dPaj7Nhp90dOT/bCos=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 09:19:02PM +0000, Lorenzo Stoakes wrote:
> We introduced the bitmap VMA type vma_flags_t in the aptly named commit
> 9ea35a25d51b ("mm: introduce VMA flags bitmap type") in order to permit
> future growth in VMA flags and to prevent the asinine requirement that VMA
> flags be available to 64-bit kernels only if they happened to use a bit
> number about 32-bits.
> 
> This is a long-term project as there are very many users of VMA flags
> within the kernel that need to be updated in order to utilise this new
> type.
> 
> In order to further this aim, this series adds a number of helper functions
> to enable ordinary interactions with VMA flags - that is testing, setting
> and clearing them.
> 
> In order to make working with VMA bit numbers less cumbersome this series
> introduces the mk_vma_flags() helper macro which generates a vma_flags_t
> from a variadic parameter list, e.g.:
> 
> 	vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
> 					 VMA_EXEC_BIT);

I didn't try to check every conversion, but the whole approach looks
nice to me and I think this design is ergonomic!

Jason

