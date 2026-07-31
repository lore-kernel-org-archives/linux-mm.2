Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E728C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 10:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 600256B0088; Fri, 31 Jul 2026 06:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0B66B0098; Fri, 31 Jul 2026 06:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4785D6B0099; Fri, 31 Jul 2026 06:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 216D66B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 06:20:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0E35A1654
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:20:54 +0000 (UTC)
X-FDA: 85048678428.06.71692E9
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013068.outbound.protection.outlook.com [40.107.162.68])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0B9C7C0007
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 10:20:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cB5r1Whn;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cB5r1Whn;
	spf=pass (imf22.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785493251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9bGte8eqdxuMMzc6Sl3gDguhLqQI6GBUeVCbvVeu8A=;
	b=CFWgLt7NkegNTQ2dtEZpuzwS/lpntLomp/ZNbkELXmLFzPqMHybFJO7a5KYNAQTzOhV/kw
	QuN5U+XSEIhitOfsXf1fc+34bPi4ie5yM4IFfIx0qEdeMkHEZ0ljLNoxvVtN4sphWF+9Tg
	CYgB6ezFOuqmEq+96H/JaDN7N/zscZE=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785493251;
	b=gdV0MetiksCnHciVxDsdymJgny5fornqIxRb3fMuGBTktO4BxJ/bm9KjpxWPStEJ7QFpVa
	p5MQ9T/qx3zns9ZuqzlOEB0iKzwRaUB0rHJEbHbNQ0nLK3QLSKEf4BgMiLQ680Wcu6Y/Fw
	Dq72sGADvckwdBGv83P1OMTrmbl7JhQ=
ARC-Authentication-Results: i=3;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cB5r1Whn;
	dkim=pass header.d=arm.com header.s=selector1 header.b=cB5r1Whn;
	spf=pass (imf22.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.162.68 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=tfvxCysufYP2/Aj3rVfYlV7QM0IRfSDedX6Nae2AXjuVqubo/fX49ecMAZMlOqYh6nAqbPlpyWFYfJ6Xe/wr2IQBQ4t18+oiY2ak5dVmQCr7CGcHYr7gpW8pMpps5C1itk+U84qnS3ZVx3dBnkkTHTPi6PzVxv8fwY4n51ZFZm1SzGNmUChbia3+AbT6aZwe8o/3fHUVFk47H/40wPo8BopKtw807TAEp2z2wKVP2JKL3Yy18UBT4oh2HbB59Ak7qufDzfCAS0QEwbh8KLm1cNh3yBrXoQaQuxocVrTmacM7RayClBb2TLPBqt39M4dGRsu6HPkIiDQEXsObcrjsWw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9bGte8eqdxuMMzc6Sl3gDguhLqQI6GBUeVCbvVeu8A=;
 b=mNVZB9SyaxZ6Xj3wn+Uvbe34FtEqty4UzniTgmvDHVr9e45fZgqPwaAFPghqIw14E3asWrQiCwDRS+BBwXiGVYYh0qmh2cuXkIUy3oFKPbeQ6+OIpVJbUdGj6kOth9oftC+QcdGgOD4Br4SwQCoAReXhRmyhDqHHszC2ySV7Wv7GMwtkwVbzAbLX/p5hHn0Gsg0/7Qctu2XiVyKYXf8X65hTZ4+k+cWUFnN3H+W2aB+PWkI5YxQaUw007litHRpBC9qT+02G9Up2v0Kryz5Rir3ei0bym9uVKBkM4XQHkJGPdaLBw6YAro1ya6MC+FhBsWw28QTKhKcwzKPmV373+w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=suse.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9bGte8eqdxuMMzc6Sl3gDguhLqQI6GBUeVCbvVeu8A=;
 b=cB5r1Whn7zm4IjrU8ljCV0Q7/8waXW+Snz5qDVSFDT6iJQDf0Zs6ZV0KTsHR/rkcn4OBTHXCurcfBr79XtPVWA0L5Wdq7yzDThpWX+1uv0kvDXKB+/ZRMO+e2OcLAUCpFyIKwzCRYSTg/RxY/sHXEpuGqUrl+r5LTCe6RAf2ans=
Received: from DU2PR04CA0220.eurprd04.prod.outlook.com (2603:10a6:10:2b1::15)
 by DU4PR08MB11717.eurprd08.prod.outlook.com (2603:10a6:10:643::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:20:42 +0000
Received: from DU2PEPF00028D04.eurprd03.prod.outlook.com
 (2603:10a6:10:2b1:cafe::62) by DU2PR04CA0220.outlook.office365.com
 (2603:10a6:10:2b1::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.15 via Frontend Transport; Fri,
 31 Jul 2026 10:20:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D04.mail.protection.outlook.com (10.167.242.164) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 31 Jul 2026 10:20:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RA36WTR3u3SMRbdo4Q+GY9qftlofBtyl26SpHhVA1QL3wPiNHvi7neI8BbiGFjcNhz1+h1QDKcE0ZH29no90uYmqtrLrQnwRJD280YKRU7/gqA0+0tIUTJFKURvMSdpBS7eVPTouH84B16YiKeL88sietYvZ7XOa71dlK+ScH4hQhGonkDNwW4F/HaN4Nyh4duISMR/oBfVW6+GEH+aluV/FbgSsThnzenNYe2xxWAHtZIGyfkN7TPij1BBo+UJtNXsts1wyxh1TmDRLjnx5oc+i/7JjfOgPTZwDIaMTQt6vUTHSC5NoadpfnbkxWOFTla/gP6QR0jbh50pkYvcHGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/9bGte8eqdxuMMzc6Sl3gDguhLqQI6GBUeVCbvVeu8A=;
 b=g05P1/GLRVOKiLbD7Hb/VMYlyYCDfmaEF5OIYvGINkGPWcIpqHcFwbqMc0/AWM6+ODDDSdiJpDyVHnpd0FgL5QoOLa4CXqhA66pWz1YIkKejm8m0xccvKH5Uf2JK2DOaHrqRyEuyXM/tSe6/2ajwLwYxrWeEAzDI60Z1jX6CtU0kSJzN1NDxpWBMqJfRS4KJG6uG36/NayfVcXgpDfQZ0uiyJynnKgLdvaqB8OMJbDhMLUfxgeKSCY1pf/MDs5FtIpO0SH5u3N668OxAR5xp4xyyRMpEpZ+kXYeUJ1kqePf0+jMbrTuI7OlNQsxC6CaqVaoszEtJ6wUT2nO3X0+cmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/9bGte8eqdxuMMzc6Sl3gDguhLqQI6GBUeVCbvVeu8A=;
 b=cB5r1Whn7zm4IjrU8ljCV0Q7/8waXW+Snz5qDVSFDT6iJQDf0Zs6ZV0KTsHR/rkcn4OBTHXCurcfBr79XtPVWA0L5Wdq7yzDThpWX+1uv0kvDXKB+/ZRMO+e2OcLAUCpFyIKwzCRYSTg/RxY/sHXEpuGqUrl+r5LTCe6RAf2ans=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM0PR08MB3410.eurprd08.prod.outlook.com (2603:10a6:208:df::33)
 by GV2PR08MB11278.eurprd08.prod.outlook.com (2603:10a6:150:2f9::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.15; Fri, 31 Jul
 2026 10:19:34 +0000
Received: from AM0PR08MB3410.eurprd08.prod.outlook.com
 ([fe80::b6cc:973e:a807:c3d3]) by AM0PR08MB3410.eurprd08.prod.outlook.com
 ([fe80::b6cc:973e:a807:c3d3%6]) with mapi id 15.21.0270.009; Fri, 31 Jul 2026
 10:19:33 +0000
Message-ID: <9ac33752-b587-4901-b5f2-473e573d7ede@arm.com>
Date: Fri, 31 Jul 2026 11:19:32 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Dimitri Sivanich
 <dimitri.sivanich@hpe.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Juergen Gross <jgross@suse.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Will Deacon <will@kernel.org>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Uladzislau Rezki <urezki@gmail.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>,
 Eduard Zingerman <eddyz87@gmail.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, SJ Park <sj@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Mike Rapoport <rppt@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 ziy@nvidia.com, pfalcato@suse.de, agordeev@linux.ibm.com,
 ryan.roberts@arm.com, linux-kernel@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-parisc@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, kasan-dev@googlegroups.com,
 linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH RFC 01/11] mm: introduce hw_pte_t for PTE table storage
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <20260727164715.2866609-2-usama.anjum@arm.com>
 <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <6xah74eadjmo2bozyr62wcxo4hhpsiufx2mshh7tztyy2dzzps@63m327m7pl5u>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0321.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:390::12) To AM0PR08MB3410.eurprd08.prod.outlook.com
 (2603:10a6:208:df::33)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM0PR08MB3410:EE_|GV2PR08MB11278:EE_|DU2PEPF00028D04:EE_|DU4PR08MB11717:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a6f79d-2568-4a69-150e-08deeeed5fa6
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|366016|23010399003|1800799024|7416014|376014|18002099003|22082099003|4143699003|11063799006|10067099003|56012099006|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 N2wlK7+ZRozJGmK0N2Kg0R4yJ5wOgZ0BD8bcmN9ckzK3UKJ2F4czXbrv7jZaWgvVUj2tZLGIy6TXZHVj8n7cCBGjmutqs1o22knL3OyEpVQm205U7W840n0BzB93Ls3ya0MZ3n6q0MiN1ZCHJEdhHH4FmcCqbn8amDqXdOS2JFy534KAR6w8Hode3mZKdiNOi4XHA4EMm4R4NmgNqv8BTHU1o1mrdwRGbDcLLTL/Uhcr5Zj2H23tyNGUWdzcb9/6Z+9bMpCyFaPdcHduC8sbRRNlTmKgEgaDWxAsRtFcZniZDxYHOO0wMLuvu/FIbZEpfc9mggB79qJPf78hwUaK6sCBMcFbFO1lIgj/xFLfWAMPLe5iSzSFLg+eGHiNLL7zlhllC5XRJ7sba3tAP1A5lpnMKQQ5InaimxmgfYr2EcWK5+6aNVUYhSXkZdPq7CHlTQ18QsDrrhmDdOi8MKesiDc4vc9VxGb/uuv4aw5rgyKAM7jO0sO/zN+AdxTpB9Vtc10PElC4ddyBnsaMt+zoJSiIhtu0ZzbyjOzgxOvSTZh9hr8fCJVH9BN7z4kFR0HmSW0uqGKEUsWoW1c6OA7FbV3EauzK0vM4jQZyqMS9znmYSKnSFtSl9lnT1Aih3rkG/pMOiNT7X9Xk05Vfb8Gxfo07Avde+ZzbUlyDqgQmWys=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB3410.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(23010399003)(1800799024)(7416014)(376014)(18002099003)(22082099003)(4143699003)(11063799006)(10067099003)(56012099006)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 jppYn+MrAjPlJcJEzGfQ1jvETR90CuL564Cvd3s5pQpSXb3FjdEezsTcu1l7Aw7vpXIhIhpPA4Fvjw06egzld5SxxNDODfBO3WGFQpssEDJnL8PWJRIWECUYo7TnCKu253Ngg+5ToeXKLgfCk4brktdsgrj7zk4W1crtnbpBsYC4BT30W2CElHRbMGQdk/8tVzUPeMqdRQtqQ59xKrgLxPMc3xsyjg/9StkRA3HpzyMoGJG+NEI4gVuZt6ij1C/0H9fj2NUUWGDqXiOrjsESkwvO2Ls29lOKFjcW8bSAMO3Y/NNJVoKjg8ty9x9AJ/wLhzWBu8NL0DMS7x6LKw8FeQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB11278
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D04.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8eb83e79-85e5-447e-8f2c-08deeeed372f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|36860700016|35042699022|376014|23010399003|14060799003|82310400026|1800799024|13003099007|6133799003|56012099006|10067099003|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	+cxUqkDAVXwJfo0/J+Unmn/UU7Qxuv/kG8jo/E6OUUholiIyLeeBG1dyUMGC+JTI9/jnKsgcOlSVUIBuMMp3/3ikCCv2hJ/V2g5yI1OLgpVuMK+GMlXGoJtSKO1RMevMxcrfaMZou7AdqgeW2JMX0/XGmyl0uMrkiB9oKgwkc3A63dlnJXUhvlQVXVNxDZt6eywKtDPuF8dUfhX0VF+bXa6O9rbSBVEymm+otUnW1knYJyYfyibDgoQMKcfmIdMEqSoJLQ11wplggq5TvNEDSxz7teq6AUCxWxMBBZVFyaP8PVD/04Yh2ME91ljkkyWMpDlxBIUY8opxOs0RLDbXZ/Ja2cbme9xQ6tbxbWQTrGqorky5G2ImsDl1F6GCBMknxiouThBH4HDrLiPURJtdyNY6JOepeeZyOQHOBLfmJQRMsh1O5L+y5ZUFHC50EF1Z54PU4auvrz9v3uu+cShBKToUDud39c30jHhrAI6XYaXolrZLzMmJtESd9+1DR1bQfg+V5fekbrMwodajnxapLGRksztZgQPm2BJ76/syx7w3iVWoZLJ8ARJhmzWnsmgyCPKnMtkFO67yBs+G2E2F5gRyAouK63Bt/OYPIAx8k+XFNslT0pGZeinwIQ0zoPsizMRGODBD4XgLp8hD2elCKAETHGbAIZ/Zq8dWJhpohwnTgqc8vFEGqKUnXtJIV7qEN5eKWDEvXQBX6SXujBOsug==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(36860700016)(35042699022)(376014)(23010399003)(14060799003)(82310400026)(1800799024)(13003099007)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	RBLROo5LiXS9uRgF34qTjim0wy19yK/eljpxXW0xvMggAoapFBz7lMXDw5Mwvqv2Fs3OGn1gD5anpvnhGf58NYa1Tk+IDYCnJ5kwjQkQ/koCnaFQp4JHJ9KgOIXnbj5bHJd+BEzgzzkuKX7a/5n9xPS7GbQDLZN62PaLbQxFVXUgYRkJR9ggJeHL3xiLcIJ5MzT62aKAKva3MI16Rc6y9uurr7Hsm9UGFdmC+GR9lCISR21RBLN+na/snbZrYb57C6grujG9yUHTbBopj+KIB10zX8OWI0IunkHd2NFpteTKd8WUZ0arTedwGYlI5/dETTMvtV+hj+hCWxB8C2Xb4PMbgL5u7ZD4CkT12KrJecNDeC0MEdggInAVlZv2peDghr0BwJQEFld88znFQL2v8a1OF8pRuyTqfhrvVZTPQUIL4KlUpwX8uk7u5PiNHSSD
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2026 10:20:41.1870
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a6f79d-2568-4a69-150e-08deeeed5fa6
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D04.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU4PR08MB11717
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0B9C7C0007
X-Stat-Signature: tng3pi377rynkniqjruxod3ni7eyf7hm
X-HE-Tag: 1785493248-796297
X-HE-Meta: U2FsdGVkX19HqpewzAQUpXRmt8M2s6chDKfwa8G/nhEJEMV0xi32d5vlc65DpkKV7LODWiLPTRYzJatyRyLGNMyJFO89WFMo0cveIaeiwTFIbPAx1+VqELrZQcQQZIUmYts3wk+Q/2hh/+AmevGrDScL8S83PItL2E/qjitO9A0sW0Yxqg+6lkt347yGJBAneuVHBUHp9NkDplXSmLf366eCLt4f7mffd/Bq3FmiPXFdDMXpQE0vNSHVHw+lLakZCxpMMQ06EGHO6RQs8Es0ekarVejwDOjZ50oe5uM5u+Hc5GEAddAA6twRKjjI4qKS6I5PrIqwyOOg+/3aoLBBEycjc264nQqvcuQmXsqklxs1TkmXRrexZuJvomCsxsTbLT8M8D7eCAqlv/0TEuYPYWP+SLHDrcNJ8cJjmrr8VlWFS1YseZZ2/fulRByuK1+Dp4ItgQMqhoJht86wuuZl57Dm2Iu0Skf7dQTgwhf6nTpK+AgeOWZVbawfuICfBLEuEPg908uh6PQ/+uCyNVpn4rROa6A05SCYWfe9WyKOYYT9dOSvHCsKlyyzWIRWSL9ik4jsQhFPGvs6qvBsIUMqqoDJRQnDlpRtd8x7TJAr/JxS2cgsp66w8lHlviiX592gNJQf56/KQ/ATbX5Ca4AH4Qcej9OlVSlh03KrjbVbXsUqaF6VgdH5ktr6TCOohAVBVl9vbhClgqT5iagoz6GKWGBZHCh7rYIjhwybqJKORdSfIad0xlWq0zg8tPQHZpHeEXh1rF5x0MVnaSuwlh9fWnL1DNqFBS5ZJ5ZIlTOlaTtdJLwovtgHJFJH/5Hsv4E2hIEhfOw2j5cnmrZb5Mzke9p6U97tBevbOiglsP/PK6RQ486pyxTxhVbDaqGJGpAT3glfr8lCQuFQtoCD73OcU81uMA+n8XEg7fOS4YM7IwF2YpI0Mtt6fcoTbvtom8eYcEvXXgwL+CuhM1TaDd5
 ddnRD03/
 zDgtk3iiINLHTTrqERKxhf+Sm/tIyRmN8+9WJji+g/as0PJTVXH2p3SM/Kkeyv7gh34D4am5TLaDrAK1muXfscb2f8jEvIJ5mZLstaEzhZCAYKafaJxbCoffNoOAD1UDFruFlNYw166TGvGX+3jkC8HPXHxiD/8sUMOwUTF1Dj71UlaUyt42jDJnCKHF047Oi9/MA3atP4AWyODSQURCFqtUAeuUNMDggP5hwEqdlbxuCPFARxk+OX6NHbIZZUc3GQvTCnEDc5F/UsHmhFVAVqh4BN0X6OVJuZJZ/rToVtfY2+AzIBj32xzuUh5/f2Yt49N9MdAi4bODvW7+WI8BOIZZ9w5yGeyer4xfB45akiOhjU+XX2Mq4aatISof0jGsoJsc+6m0YT2Yqm/Y9cvsHXyPnNUdv4HESICie3q6Z1ZRaRyrxTYS6z2Lr1C5kSeCcAwau9zbaNISG6zS/aVhNzMqP2msxi1FqmjBn6Tq7EYsgzVVOkSX5ROkHBbQpXnq2PvMtFqJKvHzFxRXGuwzLin5JENQ17cJkYMZ3KeZpGn1Z8pBfvpJGVbnPO9yUGtyUZgJY7Us7K7vPaY8oIYG7iRyJKzBmSTBD2rFGNRH2lyR3ENVo06RffsW0Ix/s0E9MoC2r+gk8GeGec+IpLHNwx9u0Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31/07/2026 6:49 am, Anshuman Khandual wrote:
> On Mon, Jul 27, 2026 at 05:46:52PM +0100, Muhammad Usama Anjum wrote:
>> pte_t is used both for logical PTE values and for entries stored in a PTE
>> table, so pte_t * does not distinguish a pointer to a copied value from a
>> pointer to table storage.
> 
> Should we rather call them as "Linux PTE" and "HW PTE" instead ?
> 
> Some like "Logical PTE" does not really sound very clear on what it represents.
Yeah, I should make distinction more visible in the cover letter.

> 
>>
>> Introduce hw_pte_t as the generic name for a PTE table element. Define it
>> as an alias of pte_t by default so architectures retain their existing
>> representation and behavior until they opt in to a distinct storage type.
> 
> Makes sense.
> 
>>
>> Include asm/page.h so pte_t is defined before the generic alias.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>>  MAINTAINERS                   |  1 +
>>  include/linux/pgtable_types.h | 11 +++++++++++
>>  2 files changed, 12 insertions(+)
>>  create mode 100644 include/linux/pgtable_types.h
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 15dd00c7ffec5..78aac05949829 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16981,6 +16981,7 @@ F:	include/linux/mmu_notifier.h
>>  F:	include/linux/pagewalk.h
>>  F:	include/linux/pgalloc.h
>>  F:	include/linux/pgtable.h
>> +F:	include/linux/pgtable_types.h
> 
> s/pgtable_types.h/pgtable_hw_types.h ?
I prefer shorter file names.

> 
>>  F:	include/linux/ptdump.h
>>  F:	include/linux/vmpressure.h
>>  F:	include/linux/vmstat.h
>> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
>> new file mode 100644
>> index 0000000000000..ed5dba42a4f8c
>> --- /dev/null
>> +++ b/include/linux/pgtable_types.h
>> @@ -0,0 +1,11 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef _LINUX_PGTABLE_TYPES_H
>> +#define _LINUX_PGTABLE_TYPES_H
>> +
>> +#include <asm/page.h>
>> +
>> +#ifndef __HAVE_ARCH_HW_PTE_T
> 
> __HAVE_ARCH_HW_PTE_T macro is a better approach here or a config ARCH_HAS_HW_PTE_T
> based selective platform subscription should be introduced instead ?
Moving to CONFIG_ARCH_HAS_PTE_T from the next version as suggested here [1].

[1] https://lore.kernel.org/all/78a0402d-5436-4aab-a704-90fab56eec50@kernel.org 

-- 
Thanks,
Usama


