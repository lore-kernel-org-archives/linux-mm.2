Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A7BEEA4FBA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0246B0088; Mon, 23 Feb 2026 09:01:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69DEA6B0089; Mon, 23 Feb 2026 09:01:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57F966B008A; Mon, 23 Feb 2026 09:01:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 417596B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:01:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D11ECC06FA
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:01:14 +0000 (UTC)
X-FDA: 84475883268.14.1B005B8
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011019.outbound.protection.outlook.com [40.93.194.19])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1D08140008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:01:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gXteH5jG;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771855271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RA0zjoYNmFL0OWZ7cWw4nReeVyWY0E1FWcoKzhPQyxo=;
	b=b1iXY+zWoWSAfQcqo2uRqP8ff1MraM28pinGL+s8mn4LMhy2dE/QHpr6tEu6AgsvJmLNyg
	M2qtBv47qA07hELVe6/qgwa8DMj+sb/F4RBhPb6UgBmx36DIN50O8od+bBVNXFL1q+xrsq
	+Cw+3ZJYQ5JP3tPxLBmiWzxjIfozmhw=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=gXteH5jG;
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 40.93.194.19 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771855271; a=rsa-sha256;
	cv=pass;
	b=l3Yny6qdubp/Cpmj2RpBozLr9B3GU1tB18W5upT9/KmsMmGXQoMcjzForiZuFOdHd/92Lm
	3kAZofAoxEyxVnGhUQtoHp8nKOvkvG891W2mNq0B8UfZr/4hx01BruUJ2NKivz+5lB9CRf
	kl8HKEMcBz9J0Ppkyx7d7Td2qY9IflQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LeKmC0LsmfPem+R1TS5bhrYGWd89iYe2z0ZLVI+f4+OGnU8wu6xd4AuuL9jymIN2MiLURg9uw1KHrScXy8Ju5Pk6eVDZ5LaNIsyEGT28ax2BPlNb+OH1lJo3mUaSAuTFN4ER5DbHNAgN1rxLzmUxI5dtVChZtgDIbA79N+FUpPU0Cr4JgcBHFu2H6JBMSEhXBokvzE3P5kj3bWd68bmHySY5l0H6vEeyvFVtX6f8MHlvjkoQuKsk7cfosRQDx8ugoOJ7FJkf5i4+EB4hFLVNgRE71Cz/UM9hjpGy7RiDxtDk0LNDS9MqYXxx5qtGZMyT1P6/McjEkv9rtKtcgVeznA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RA0zjoYNmFL0OWZ7cWw4nReeVyWY0E1FWcoKzhPQyxo=;
 b=SegrqeCNGoFxuAgYAivYxhhmQwL2+MshOoEILVTWdn46uqpTVSeAJodUq6hDIwWNJQVy6j+6SRps1mNCPXyjUosCFwDgMfm9qakXkFLIhPIezJqwpCUnuHMZdbVc4DsKGNa1gEpK3fciWou/i/7zu43YjW0xtKdLBqWKhzC6V5D7GW27cae4dS3JUUg8TERE0kbGPXm5DkgmK9u8DwzwRsZpcu2uVXqe5bpDPVoHe9VfTKAX88y4k4WdQkJWaKjkhaSgiNua7Msr6EnkLVJUTcLUUUzKot76yR+iq/UG490d0DWQO8Y8Z7WSkrn3WgcHnIR5Sg5DmV1QKoBPT8vKdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RA0zjoYNmFL0OWZ7cWw4nReeVyWY0E1FWcoKzhPQyxo=;
 b=gXteH5jG7D+nbBorVFs4r1vl5SdOu01pzrdOQYyoxpv1Pnh/Bf2cZ3N5+rfEC7UK482vWmw317W6K7Y2qNHZV/y+vQmY8BxEBHC8JCI8wqLIKcZ5Us2y2lT/tIZGEwXmwL3c9lIXm6ghdEl9u8m9t5r8NoUPEbFfiHhCqL4tTIH+a2seqJZ9vrSMY55p4TjEvxUJcLBP/w2dTO1YjOn8CuarCmaXCHTPH8jdeEgTL5nQVcYBKMK17cSGD3K12R+lvZ/pUfSCIAgr6Z7GZvuLQeUAud6jiQ40r1nt7woLUVMzQa3dfqHBACwCBbOGA++0UiZ/IX5QLWaOIKXHnqDJew==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SJ0PR12MB6807.namprd12.prod.outlook.com (2603:10b6:a03:479::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.17; Mon, 23 Feb
 2026 14:01:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 14:01:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org,
 linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jason Xing <kernelxing@tencent.com>, Yushan Zhou <katrinzhou@tencent.com>,
 "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Davidlohr Bueso <dave@stgolabs.net>, Eric Sandeen <sandeen@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 =?utf-8?b?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
 Todd Kjos <tkjos@android.com>, Carlos Llamas <cmllamas@google.com>,
 Alice Ryhl <aliceryhl@google.com>, Damien Le Moal <dlemoal@kernel.org>,
 Johannes Thumshirn <johannes.thumshirn@wdc.com>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Gao Xiang <xiang@kernel.org>, Yue Hu <zbestahu@gmail.com>,
 Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>,
 Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>
Subject: Re: [PATCH v1 00/11] Zero page->private when freeing pages
Date: Mon, 23 Feb 2026 09:00:57 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F1307EF8-7054-4135-B61A-62141A113394@nvidia.com>
In-Reply-To: <aZxaIEFZr2NvO2eQ@infradead.org>
References: <20260223032641.1859381-1-ziy@nvidia.com>
 <aZxaIEFZr2NvO2eQ@infradead.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0223.namprd13.prod.outlook.com
 (2603:10b6:208:2bf::18) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SJ0PR12MB6807:EE_
X-MS-Office365-Filtering-Correlation-Id: e2b9a761-ad77-48de-f16a-08de72e3fa90
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/thS8mhRNm18QJW8/IZN2O3S28wZ/DdEI0s8acVH5KaHGT3NoZvu+Hru1wSt?=
 =?us-ascii?Q?XvpBprr30tGyF9BzdPu1W/Xw21k92TlqGJ0sonpFt95fft5amCThQCIqBb/2?=
 =?us-ascii?Q?V3D5ClS2EMBVNWRlkETNQx8XRh9VgL461lAs4D1Bs87LLkh83sRGBVAUu7sA?=
 =?us-ascii?Q?E72GXPnQxb9/ysH0ugG4Gek2dqT8du9HifJPJrysWg8Hb9fKE6jgj9LCr1FA?=
 =?us-ascii?Q?OOclwBgIpdYgCzF/psOgeT/nrTIkQBOYV9idcZAaJzT2UNfctjoP1YXEGQd6?=
 =?us-ascii?Q?ahOvggH/96LRXgSRqYCAdnU3EhztGt3i1CP7QMm0ryJ7mdq3sEnXVyPyIFQ+?=
 =?us-ascii?Q?0YMPV6XczzBO7F1GQ1xpfVdGGTLLaWvfoPzj9cDoheLukAteiXUE2yPiozzz?=
 =?us-ascii?Q?IgngKPrWTGEjH084aXdhF6pqWxB7PYl0FMdTQJVdyBYL1gfEwscQCDJmn+Qi?=
 =?us-ascii?Q?HgHpui4xeVjZgg4LFJEcKYV9JfJN+zU5xsdBfZ1v8uol4x5EajNyBK2/wFbD?=
 =?us-ascii?Q?W+fr31SVlfc6pjVh0/RNIxMu1K+0bS1+PZp/C0PeVd4nwI2jOR1UvkpI7Z0u?=
 =?us-ascii?Q?p/opc0iTef7clco4wTQ0PtsioJYykrFPrS6orp9VToAp7XOCuZnZ8sS4NwYk?=
 =?us-ascii?Q?gDnoRfCZI11wkh5dTtOVH1iKSRpUFI7m0a9im97liSEZ1M9+CQB/8fJn5a6A?=
 =?us-ascii?Q?9mwAcnP8dbdYiPD9mKYzU3vo26qjD8ys9bMmzK0krQkUesNjXEIyaXc2vtKg?=
 =?us-ascii?Q?F7T1Hzpka7YLH/zwpu0E7hukJKb1k88TQvh0HxAkJrmHDxOYJxK3akow5uI6?=
 =?us-ascii?Q?IyTBm6uqza9UbPRGFIy6zDYBBx4aYxWOkiME8SVAMdlXw/3btaGhzt4sK5ig?=
 =?us-ascii?Q?syHk71CF6F+5vCuVp/BoRu/TW6LXwxNXjhVB8mIOCs+WRX9JKbzDETBgH7UA?=
 =?us-ascii?Q?MRabzVvArws8742Ld+up4frFfiKdgMqZzgTmqirwTmInIJSbtropWj6k5VLz?=
 =?us-ascii?Q?5IwiofyKne76/De+QAxy0APZwlzHVTTaoJwf/T6nebEJ1RgrFCD1e9IO4t9g?=
 =?us-ascii?Q?lW5VWlAqUmRwx1BUzoV2xtOuVJ7+ynvp4+8k2lkzFNHVqd9RHMfJO+RZFF0B?=
 =?us-ascii?Q?11yi81u0+fk3zyTAkpLNph1Jx88PZPYHsxfD65pCWOYdWMbkQ3KmYSGUL8Jm?=
 =?us-ascii?Q?R7rztdFVLAd4LKv5hkZ+wQI6MZGGCmvKefDdg8y1AWkBY5W04i2nafIPGxox?=
 =?us-ascii?Q?U8G4M/LoLIe7t27ihaFeIXjriotL1Xw/a4RunidPgIblCoaKfBBsHOdoUIyz?=
 =?us-ascii?Q?Lv3I8mhoYVxtNevGlJxDPMpiKlRYn9pBM6YE9LPnd1LLU/qYy3G4J1rORnoA?=
 =?us-ascii?Q?FQ6Q6FsPd4g4hQkLO1X8kF4MSwWo0m6+nFHRJkaW7Dki3mqsjhBtCrsSZ6eR?=
 =?us-ascii?Q?uqYRFYmaN21fWS6jt6PAuyGcYEwqQRbvW/W2k3Ggz/skfridRal1s6MJrN4x?=
 =?us-ascii?Q?5xwKh8sv1wZrwovHU46O8WLQHFk4GR/vo2WFX0v0faWyVT/gHE5W+7l7Ow7o?=
 =?us-ascii?Q?To1Djfk5b5+LzxX+Rz4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TapTRA6JpK9ULa41+EUoKA4MKoowlrKAMchpRUZyHCE7fsUtWim1T4apCd3H?=
 =?us-ascii?Q?g6HeXR8RSb020JpIA36zqvNL8tNMNukNgBxA+HoN2sPxVplJ1eTA5e8Nsr9O?=
 =?us-ascii?Q?s50nvmrLHYr+8bGBAIuqmr7jZry9+gBhlZmfOmZXyTPRrDCinbuqQpKJv679?=
 =?us-ascii?Q?GAGABuSIBgHBAIX9afsrnmKOipPQdqbWAUIQ40R+wfQZAttJQ+7kh1kTZIqc?=
 =?us-ascii?Q?q8z6/aKtZ57CslT6JpBq1KINR/PZIW3UzIWY/dEzXwIMzmBuYFrVThC0Ip1l?=
 =?us-ascii?Q?1+JSsvWSl8+PbHVTw/enkOXPYfYN2Wyo0h/4hq9OmUa/q9lEmld2Cg9ftaBK?=
 =?us-ascii?Q?oTVGc2skOmgMFVOuVbaz23a5CxiIvKj1lFVijVXaPz1PePOQpVht1TiTZyuQ?=
 =?us-ascii?Q?Jg9yVwndGIn0HOx6Th/bZvtRtB82I0T9HzugEwL/1Ji/IlDqHIMXFpqDOrrP?=
 =?us-ascii?Q?JT7gx8coF/iCDxHh3L2zyiCadPnpgM+x3jjXtzcBSJg9gofirFioreBcWyb9?=
 =?us-ascii?Q?jho5YxuNAc+VuquWkZy5Yh0UA/7x1YMjoTDtF12mdBj7u7tYKB/daBAQG0U/?=
 =?us-ascii?Q?ilywI8BiAi3Tm1DjQBB+Zjy5aKPvumi2+GQGxfnaQKKI5Ipy8XSts1nixIOJ?=
 =?us-ascii?Q?jsM1Pgi6XTqyP1qdMx/F/DfykL7UU2783Z0MHUGrvT+wp9priT/nq0++nxWN?=
 =?us-ascii?Q?SLyiiEsDJBogUZZJTGxgPL2Hpn8YZJt6zJKiR3/2tweL1l6fID+84vxMbH/G?=
 =?us-ascii?Q?NEnYl2T7BLZx8PQWsPXWlEjY+Bs1jK6i6J2a8k/Ku9dtAYQGArn0efs7HT7f?=
 =?us-ascii?Q?GxLpBTimU8bemXFOkaeGS/HitjygDHuyGR1tNAh5jV8hDChpCnB0x66P6OH4?=
 =?us-ascii?Q?8pmE0Wr1nQbudJ3soyG42LUNKLhyFhsKjP/ylDswVXrbtsFko0cQSHL0ogRA?=
 =?us-ascii?Q?91w66ynDKaIy7Ac6qACfHva15gPeTyAEecuifKuGVF0zigpMo0EUwG99zCut?=
 =?us-ascii?Q?5z2KLle2p/NRGRLoPMcphLlqFTA2JXPdq+c+w9zY/wmgv7MhENTDZdlEZWaN?=
 =?us-ascii?Q?4C3NgyD4THB7fwK1NmJDutqyidx6hSOgiW/ExAb/JNI+U331WBAsfSn8Fe0G?=
 =?us-ascii?Q?Ft/GmVqhrrGJCIzzm5l6GQNB1gwfTleVaLhaVXfCnQpZaNsB7Ai28w+X0Lm5?=
 =?us-ascii?Q?WSETwI44Bs+jFzrDCJRP66IX0gSc/L++GkEg0iRfxqca+8y9TZ93V7/7QdCn?=
 =?us-ascii?Q?+9dzir2/ToD0lKOrAIlvRb911bZsl2w4Z3lsvWi19qhSNlCPmRXVybBb7rKB?=
 =?us-ascii?Q?qAIKUTr5aI8gEer+kHEt+fG7g2fnRYoZa4CmTzhqMtyJR7lJwNz5gEGNqM/+?=
 =?us-ascii?Q?QdmtPVPGzMCUZayfoxVz2L5c4TU/Be4px3xztVqNfqtInRVVsFT+mjXcJqFu?=
 =?us-ascii?Q?0AOVQ1SZcGcSveOpH3o18XnLqfFI41ulcibZac7SYpsho9Qzjw0mhK4kEFRN?=
 =?us-ascii?Q?1oi343+efuda/DID8lJibvT8lH56ddtOkHYMbvjRUh8w/QavHU9W3vr3CeTC?=
 =?us-ascii?Q?pYZ4U1y+i1sxVuFkty2Se27I2OxaD3wcO3gowpfJUr5HB09fWZGqZRIjVNo9?=
 =?us-ascii?Q?HI5H+JSQ3qD0dCuWbTF/YuPJOdNJ4xXlI7mckjHNMt9mO6SmnD1AdPUeB7OQ?=
 =?us-ascii?Q?A66SzaPbTmgIM0Ca8ijASKjXEnfkm0ZPgf4SDzMhJuZTE8bb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2b9a761-ad77-48de-f16a-08de72e3fa90
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 14:01:02.2262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WU7/IpqlyyKJ9F4bofkIQpzWWJ/mparFy/Zu8Qyav6rAt/aa9c/2T0Dcl2oAn3O/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6807
X-Stat-Signature: 4ggnq5rfds8xrmsyjeeyqy7u319y5nsi
X-Rspam-User: 
X-Rspamd-Queue-Id: A1D08140008
X-Rspamd-Server: rspam01
X-HE-Tag: 1771855271-205709
X-HE-Meta: U2FsdGVkX1+otVvLB8Akxb4PgvmDZgjaeN0avvZSlb2bTrJCJixp1cTaB4spG1v9xHsBaKbYFAdlGNQFWEScLio39xCPNwm9hzpyJjAKtB8XbwX69bxDPrA9HGIiZPRd2E5hJjFKXvQWcdNQHOmF1WNWtPix6lbit954xkMoMjygBObcD66KmwxAAp3styB+xvoLQpv7Q/ZEfIzSGHFAqq+xpKc/wacdlz7kTG5PEsfw66XjkUjk9EnOOH2bzQ73Li5+9k8/UNVUVWfHMLAwGVpV2qWp9bI1qsDXhDIl7ifDnDW0xEvQWIFfyIFkE8T2igGdjf8XNV1gmn8S7BLD9ayFK8hu1xdjm+CemrBLpZdGT3HIQUO07RGUeR/TZgMLR3KU/xgfZIoarR4qzaV6S1CiiCK5itOWVYO1lo6WOxE5LwFB6Oeahos/3eCKzUy6okh/KfWoBIa0pvW1lokBEeX/TTGi0ehhlH/x/Ds6jEbCIeJMUt7GmMzVTmVFy9tDjOwyVWTnbapDrTqRNMB0ngFEnq079+8LF6UBX/8omYVPdgWlxOPuEFIwHMrpMr6ZxL3QZCx0LDWRgeHVS2zfm8wxN4ZbgRmJFeiukKtydnl/g7lgh3bAtUPMN9bWgF0Kwly+rRRd6j4lOcqwmZc2AcdxWkKsLZKqjpo7IgH+EGo+VRoyCZaCDRtMlct4vDYjnT5VfVpdjN7xh14iwGNYbkMe/iljlR8so+T7McrXOBXaIN035ryR1TGOroR2gHLHj9oEYy9/NYB0rfI4rsCnq8kJtKVZzwqN6HPUBW4pDi4/xF216Z7aCQhX4Uz3Grs20ENPLSOue79XG4iF4O+4x23jGNW9POk/byE/+kSJLdAyRXC3Kde4vNu/wwSkkIJNARso32PIegMdtnBr61nSFHj0kVGgRR0geOISGRQrFTgHnJp+ngthn+yck+YYDWiyZ4i5QoxNueQfiKbwOhc
 sbgNny0v
 1NbJdTbfOdvMFXKCI75MpeJhLqJ06hI7L+oeAqxmg4uMqSRWCpxmknNRaalgk2Eyf8a77VyN+w62V6ykxEqoKxjOmi6aNlcBytazwleCm6utoEdg2VQCyXulJ6/RMAR2rL9QLl044Uebb7z7IUu+RpZqGbpbuoMoP9k3nU6wezR3SxKcY84w/c+rnb8TRKJ+ANPlmwqEmxCG8+yN0trQMhQygmvNd9t9fHyRlyYFAHzgy/e6qeJzEK2rzL9nPxy/p72Z7hkd0/i5+TIqr3zCmY8aOYJWmaUbh0GCpWXfzd0tFoy4W/GvGgBo2Z4PLh3qdU1bp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Feb 2026, at 8:46, Christoph Hellwig wrote:

> On Sun, Feb 22, 2026 at 10:26:30PM -0500, Zi Yan wrote:
>> Hi all,
>>
>> Based on a recent discussion with David Hildenbrand on page->private
>> is not zero when a page is freed[1], this patchset is trying to fix all
>> users do not zero ->private when freeing a page and add checks to make
>> sure all freed pages have ->private set to zero. For compound pages,
>> both head page and tail pages need to have ->private set to zero.
>
> Requiring the user to clear a field before freeing is just a way to
> awkward interface.  Don't do that.

Page allocator hands the user a zero ->private. I think it is reasonable
to require the user to return a zero ->private. Restoring things back
to their original states is a common standard, isn't it? And most of
users do that.

Do you have any example that shows doing such a thing is difficult,
if not impossible?


--
Best Regards,
Yan, Zi

