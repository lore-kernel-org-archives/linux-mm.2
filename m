Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D7F4C5AE5D
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 11:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E6FD6B008C; Mon, 10 Aug 2026 07:07:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 297476B0092; Mon, 10 Aug 2026 07:07:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1395B6B0093; Mon, 10 Aug 2026 07:07:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D18256B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:07:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 54546140123
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:07:35 +0000 (UTC)
X-FDA: 85085084070.29.7724DC5
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012065.outbound.protection.outlook.com [52.101.66.65])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3BF1B40003
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:07:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kPqHrKjb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kPqHrKjb;
	spf=pass (imf07.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.65 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786360051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnQqdXX1ZyOUKKU4li9Bc+RBJzrUk6RyawcfqsSj/Eo=;
	b=6BU6wOP/JyVlXbep5GhmEZs4X3mAPpwMduxQ2dIWd6Mqo7AJJ2ClifB2ugFmLohUsj5mGM
	siz7W5F2VEINMh0Rgs206lS5lgEM70r5QzXoRRebcoiQvRGKB27SLNCTTSAp27hKO+hJuP
	A0E4eW15Cvvdcj341wvK5RksFMNCVTI=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786360051;
	b=grC4hfbmqhtgAOOSum3Z63LldNuVKV7S7t6iA/uFypDiEJyHv7NvWJMgJT3Qxcx0BsXtmf
	XowscZKxCdhhNDSbTisZI6uq88uuZseTO9HvpmOzRH2hRV4QGnVK9a/EPb8MSqAiQIBim0
	8SqWPKViED+gr2+xzNQ9CflLK5zx9GA=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kPqHrKjb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=kPqHrKjb;
	spf=pass (imf07.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.65 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NpfveSg/8h0SZbLFOQkd9a23PTo9LDt9y+bWfMh9J2+KQ80xwXGIx2B+WmDxkOTlFdPMn9r3AUQrASz7wbWOVso69P75Ftpp2ZuW0uadEWi3ULKuuNCXT3UDo/MlPmBHD6+nR7vThRvrHpmX+XfcH+okPBXjn2EiHm3DLtJnSfZL2kRK5ebWvkwJi6y0+oXilnoS04k+uqH5AqQkrBGxKTXh1lN22oU0gb8TQWEFHM6utJA105mYrmHpMHos1igY/vRJWkOSMz7+fibMeeAWrhjRc178ZFOCB5MVEONnWquzfdhZi8u9jPDAQg+YggpyzOJUC0oGgLg509lWVZrHZw==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnQqdXX1ZyOUKKU4li9Bc+RBJzrUk6RyawcfqsSj/Eo=;
 b=G+FkAECJjVw0S0GHsHYBzilgEhx+mh3nMjHEmm3/QIsdHJuFaqOpe7EWTpH/cIUsAcDUJe5YGHTq9H0Mv6vxDe4cUXZ/lxFnlfuCyYwf14o1x20iWGXYw8co5Qtoa7sTdmQfm+dg0efhWdP8B/tltGRDVog1K04qF7Ba2EewOo/Oqezxs9Jss462e6DuhRO1JjRFbNeISoIdqmM6wO8n/tWoMivh28F7lDgxxSGQfgLXNBPImvDgGR/zOB3tPl2CRDbR8juQv3PiO0bH0xi4lMtTwizYvC6VGayanrxr+pVY+Y8Dz2UgpZOnoQeDPdv1LMgmNGjqO+C9rdorbSqtIQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux.ibm.com smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnQqdXX1ZyOUKKU4li9Bc+RBJzrUk6RyawcfqsSj/Eo=;
 b=kPqHrKjbFDa0OLbzp0kgLoxHv44vUa1iZaGhbeDApeXGB9si5HckD9jCUzXFUvjwQ6ya/WFbbblYxXJlQHpxAODd9pB0y6zyz/xt54rLMTBPk10MHoPyHEicMGmUNuP6ZNCcHkdYwPp2GXqM5wrurn9J2iWj+66UzgYkF/HfI7U=
Received: from DU6P191CA0014.EURP191.PROD.OUTLOOK.COM (2603:10a6:10:540::15)
 by AM0PR08MB5473.eurprd08.prod.outlook.com (2603:10a6:208:180::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 11:07:23 +0000
Received: from DB1PEPF0003922F.eurprd03.prod.outlook.com
 (2603:10a6:10:540:cafe::48) by DU6P191CA0014.outlook.office365.com
 (2603:10a6:10:540::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.25 via Frontend Transport; Mon,
 10 Aug 2026 11:07:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB1PEPF0003922F.mail.protection.outlook.com (10.167.8.102) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.292.8
 via Frontend Transport; Mon, 10 Aug 2026 11:07:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ziuome5/djtyBQzLEzz0klmAysoiBI5ZAwdG5vnb3nMr09jdV9VGv97x/PZogNuexDHgr5Xo5nw3XjHMCCjfiOoa3inGpsNMEfFzlW8yKZg8LiwfBlpVURriB1zGsB2mAyZBoQUt4prjIke7q/FWySr+Ygo8QBVmuE6d+O/0OjpAKTIxOIjcOkraqFpDsBHE4rCU647hc4e0D6FVP0Kv4noUVajpvIWXLH9litFTkeZXuLKIJYC12llbrMGJ4d2Dt8a8LFKPaUChAGM6/FefuJTy4GvU/zRGIvq3uWLhj4xlGe29JKudC2FebNsOezbu0guaNOMNCGQI/DuWebZESA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BnQqdXX1ZyOUKKU4li9Bc+RBJzrUk6RyawcfqsSj/Eo=;
 b=GdzwAUCegwRfCxVii+ZLGkAHtO3xXp4tzYPyF0iDSnfrKkoUNGEAMGhyDAQb39r1zcUcsMnxah9Xs/c0/bOPAN64IsYrxlHANrH0uiSvjthio3zxLLdIAClSLHTCk/a2+wLIy/0MPUkjKdt2o8mrBSwHvXehtjU2VwCbcamMxE5XsWs9w1H5IV6kNrcPdqkbq5Q6QOTzInJZbqCCym37I5EOnc2q7D/bPp1USuGxXPCX3As3bQ2IIjG6tgAGC81jJJmeoYrKOCrspJs2VC20PJ0vlwKKSWXEZu3j4/LNx5lQiLcRbzue4l6uOentjCiBOvApUlYxv4u6XBCNs2j9Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnQqdXX1ZyOUKKU4li9Bc+RBJzrUk6RyawcfqsSj/Eo=;
 b=kPqHrKjbFDa0OLbzp0kgLoxHv44vUa1iZaGhbeDApeXGB9si5HckD9jCUzXFUvjwQ6ya/WFbbblYxXJlQHpxAODd9pB0y6zyz/xt54rLMTBPk10MHoPyHEicMGmUNuP6ZNCcHkdYwPp2GXqM5wrurn9J2iWj+66UzgYkF/HfI7U=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com (2603:10a6:20b:49::10)
 by VI0PR08MB10485.eurprd08.prod.outlook.com (2603:10a6:800:1b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.25; Mon, 10 Aug
 2026 11:06:41 +0000
Received: from AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2]) by AM6PR08MB3414.eurprd08.prod.outlook.com
 ([fe80::dde8:bf0b:1dc:2a2%2]) with mapi id 15.21.0292.024; Mon, 10 Aug 2026
 11:06:41 +0000
Message-ID: <f0b0dacb-fb83-4402-b0ea-30072727dfd7@arm.com>
Date: Mon, 10 Aug 2026 12:06:39 +0100
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
 ziy@nvidia.com, pfalcato@suse.de, ryan.roberts@arm.com,
 linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-parisc@vger.kernel.org,
 xen-devel@lists.xenproject.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-trace-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-perf-users@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH 6/9] mm: convert PTE table entry to pte
To: Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260806083926.1807279-1-usama.anjum@arm.com>
 <20260806083926.1807279-7-usama.anjum@arm.com>
 <fab9fc78-1e1d-4d5b-a9ca-92f3ebd04108-agordeev@linux.ibm.com>
 <5c329236-7761-4e42-a549-b822e43b4358@arm.com>
 <2599c5b3-e8ac-4865-993b-d41e6f060d52-agordeev@linux.ibm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <2599c5b3-e8ac-4865-993b-d41e6f060d52-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0240.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a7::11) To AM6PR08MB3414.eurprd08.prod.outlook.com
 (2603:10a6:20b:49::10)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM6PR08MB3414:EE_|VI0PR08MB10485:EE_|DB1PEPF0003922F:EE_|AM0PR08MB5473:EE_
X-MS-Office365-Filtering-Correlation-Id: a953ce51-28e1-48aa-165f-08def6cf8d94
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|6133799003|10067099003|4143699003|56012099006|11063799006|22082099003|18002099003|3023799007;
X-Microsoft-Antispam-Message-Info-Original:
 lQ0hyfxi02b4F9VwRxN8Znn5OAewgjlyPjRZcVcEUaWc/2czU2/V4NIVgJiRy5t4QbhGiEJ0KwtaSe7jPvxwE+NAtXM/byDqA7dfUzahbycT7I25PzR5jhkw4frdVt9oxMHTuT5akKF8RzZ33dyxm3YumgOMNPXleL3/6dgR5gVsXlm7rW/4NEmneY9iocIiXc9AJnfTRej+kH5hV/eFNjczN84h/tHRt+GWHZjzpSAoJPL9JYvhN2uJY/S+VrzqF+CWj+0w5yWDWDTqJ2PBgzAAUUUZs2kukSyhTiklg5Og1PLgZuW6iLLN9l3sFHSU2tcSI9gz7kEmj/CGBr9gAEUkaYQ39JJiiB4jvVQCheZ+7eOV/F/NBXKAzFVSt5gbfbkSknaem3qoa0pI/BVUw5qogKsLivyhv9KJhur+AwUg3Hgnw5miP0aiKhBTfaPE0nfqcrLZgmGWMPvil7+FlI8U60XhaDqEly8cC0jIpSQvVcvtGMEalbBtDiQFFCEDkDZUFQgjRdmfVg8KexBPyscLIZeZnbQZrbdecvE8TcK0E/1c/PBQ2CN+jz7B3aX/bKPp9LZqOK57affgO+aFBh9J1aTXDH4Sj/DOUdJRckS46M4BPeWnU89+1GK6l1c08XjUtoEwa9L+S8w73BiSAlNMsrmS1vmLGiUwtdwZAdU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB3414.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(6133799003)(10067099003)(4143699003)(56012099006)(11063799006)(22082099003)(18002099003)(3023799007);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 cPVi6hN5aavRhhAswfgv28wAXtZ6qeLTlP8q/AgWsrYcs7+vK+svJwSvC9NxV7RCHctlS0aIjO7/jx28wsEyjQwzfPGHOGPv1O1cSupSolWeBAX4rw+U98JrzgQTU06aoDW97oqwj+5onDZpDRYSBHwBov2+hRwPNJzrr2UbtXUdSOHd+PD4+E88nTrZSLjZV/sS2M1LGA2uVyfjDBfSo+DAoVyrKGPcprIh6Cee/RdcDdxZjE1/fY7YTLbnfllaV7GL+zNTiE62tYtPGYGbhMmEk7fG0EHHuqShM2REU2EwVZP0Wify25HFm73akjgX+cx6WziW0ou0CWTB9iKpKA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10485
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ca79a833-59da-449f-a5ec-08def6cf7495
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|14060799003|35042699022|1800799024|23010399003|82310400026|36860700016|6133799003|56012099006|10067099003|11063799006|4143699003|3023799007|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	aB9doTRqRN7kd9TfOrTQxmun2zbzD4oTTuD1y4OqC14UyKyJNSMCGw36kf1xi38PqJ9Rtp0jlNKym4r2OvGN7Mdrix8L0sWVy1R3t6kLJaHIHqtZQGtm9crMkpQLwvqLi2JgPsgruMFGtOnAnNv3RQ3jd0sHJDccJkUb6R1CgSG5NjxGfKwCzdTVzH0f7NMXHC32MDDQrfjyaYntV5Z6MTlqnp74aBu1/Vfz2aUWF1CyaM76flGKf/iR3DBVz4zXlZ8gFMj5t7TWKAJYlfH2RHQyl1+ejF9TEC0M1d3EUUSKNIcAXS2+B6uwgaDjBF9YYZPsBe3x+8jsnEctfOzx5+LgWISUO8YhGuEFvPM/zwSeQ/ZhMN9x2dHjXnduF7LZAfeeCdXdli081Iv3yl6OxpFpBdzWQzTDA8t3zPUqrfsxQqi4pJn9BIAcFetfFrc1SZhlCQIvXZF5riUG97QLoOgJ5jTFlh2d6z5sTdXhjEujrl1WgCaQb26YYn0WAFkV5x7f+IKzUmVPkdVDWwLvrqlJA5wR2gYDNc+HKbuzIcI1SMN0BthkYebkD7uyDh23PB+OSWYO5+W8R7TMXcL4WzHNl8Ib05dzPcPnUmL6C1ZLD8qMzrvGTZ2v73Td3vbzSktxFDUeAgTLYg7gm00imt20iVjJbxchyo81jYXSiun4qm4IeZsyVNCM67/xrcFUHwajnV6IM3mpC+M3quGFmg==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(14060799003)(35042699022)(1800799024)(23010399003)(82310400026)(36860700016)(6133799003)(56012099006)(10067099003)(11063799006)(4143699003)(3023799007)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	BtLaHivFG2MjBv8/s8qRcGiJDKiPENYB+2PYjmVYu+THljKaOqxVe40MzKEcSJKsZWVaiKFtOKgq9S7joX+TrjW4CONkg8omF1hSH5KQcXcggLJulUwFxWbo+WyIVRRnie8RGxdM8oI9wId9eGQEVsIa2lyk7lpRNcmJSduk+6bTsON6zLC1kFnHFKOPdQWuDJ+5gvPtkQH4gI0OcploDbbXUEAvdfQjGSf1ocLCBOu97QcYTPG0/hDWOR8EDViud7W10iQ+bgqduvXMyNwOhAmdDEZ01OiYXqqsUfO2i2bLso0Pv0p/qqXtnpvfSJ2dA7uAlOKWN9wQfclNiV893SiPpDWiKNOkuyLlnRCSZuEXEGiiQknPj+wo2iq8eG6Smx9xZv6RYcEamsBsfgmbep0Y20LINnYyBgOzRLzRtRNvmy3fgDmgtJD0KNuUHASX
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2026 11:07:22.6360
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a953ce51-28e1-48aa-165f-08def6cf8d94
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB1PEPF0003922F.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB5473
X-Rspamd-Queue-Id: 3BF1B40003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: j491w38xi5su6ijstudsruq6wksbz55c
X-HE-Tag: 1786360051-425299
X-HE-Meta: U2FsdGVkX18HvUoUU/oOelD8Qnj3vOM8VaUCXKOQfOCR8zb7sg9OIyKl4KFY0us/aRI2wzaIezX+pfk0qL+cICnSd9RGGv7jPhAS1pXvyNHUP1mfFJhsau0PVBS1xnUPfXdhaQGbXP4w2YRiR8MV97yte9gdRHYbOqveflQmWwzytHNyXp8CXskg5tERPaexJsR+5Lsy2PxfzDoZvy4Xpe1h97MonKhqp8fP3zG/W26Qjgrn0/cBsvRL2tyt/PgPHUh1O33vq7w/t7KZ0mvoCRrWFMSWeOSOUb3Tcl5+lQLUKsHAth34y+D9jvfH4+1/zaMXooHo+x20IwXCGkkyuaC4x/tigTWqWoXKMqfXtXWrUPUskWYxZ2fXhZJypvTnrN2/1JGxYYOQJYWNMY1vah+pnzXZq0hqi2oONNQPZQNATP07fwSKIH7v4oV0DRnqXhVnG0F1ss1NQMdu/RnNMTtduuCj9JZkdeyGE8GsFce7reBpQuqMu4Jonj7VUzYLOaGlYfzOKKQFj8y4GyrcA57o/SOT8Xa2yEVfTppZXWWCeCtmea+Z6hXU+dF2aiFoC5D346MJhDljapALxDh35MECQhp8e3nmqEzgm22KTJzL/ZQF72oRprXIdwKxH/KK40b2tjrk9iqYgpSpo5GO4lPmjort95rl/IMOUhrtmaR7cBUIOwd1B6rVQCho9UL1qFWENY/DLIQunFxpaGco0DmmLGtYS+C7CO42qKg5/EDUze0qkkAzZXE5i2i2nN+g0hcaSeyNpz7BmUMYIEPlHZ8ivCXNTD8FAqNeeKiIfi2OrnjMIE6P89/9i+fZ7mZkBwSOP7ipcgNp5kOlKJBko/oBvsnOodLWjbZZj2E00Ss4zGF9t9UyXBLExfi8uQXeAmn8Bf8w2ue/UB3RaLEyuLt2CFcoGX+rXS4mY8Pqu3QBRAk5r+PoiSLwoPC+OZcJRRVXaLCLR/JzOJE+bG6
 UXXHcHle
 nQaH0xdniygA03Z6Ctv1EBynj9469juCd89KSEwXYJIQnGOfzTfFneLEmkGYs5HRIsLt6SmmawQee0FhO307ZwYPIPPvEuMvKZ8fTzGs0kBO91FRipx9U4lWoHI+f/STJ53KreYly9x6eMXAEBUY0xNST5vWVu8aNpp9e2hnWGeE5MBMfkxdZhFYIAGBegb/JJyiSOdKEEjha6UC2wXbF4AMzCeAFxfVkR92IF9+T4BCs10JsVtDE3kzSyYEOAxeHAkM06sNrp1QYtQKDYQT4PmypSo/HbmkAQtI3bnIiKtG89CkKqXbwYDzwJOZz9IWHxBfJUGYo41tnAAb5/gjs5iVgwEGN52lEHJTnpT/6zA4O6OFSgYZm6VHT+dbvhriJrZ/4WDOAZtoYUVrFUA3aRrQMgc3IE9y3UFfMx6TptxpAYQrOkv7yGP5MNx38ipLAS1MNOeip8lhx+i4wn5eExLOKCpzk74qKRcs6FH/7tpurrD5Eq94RO3Uqu1cx14lAzuSlqRjnjkWvpr9V07y2+UgTgltDl3oborBGljlQblNdsDIktX4vCNVpFnuONvcc/fT3lHx6X3fQbARAjGTGzmJJ9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/08/2026 7:44 am, Alexander Gordeev wrote:
> On Fri, Aug 07, 2026 at 05:26:04PM +0100, Muhammad Usama Anjum wrote:
>> On 07/08/2026 7:58 am, Alexander Gordeev wrote:
>>> On Thu, Aug 06, 2026 at 09:38:44AM +0100, Muhammad Usama Anjum wrote:
>>>> The non-MMU stub receives hw_pte_t but returns a logical pte_t
>>>> value. Convert the stored entry through __pte_from_hw() before
>>>> returning.
>>>>
>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>> ---
>>>>  include/linux/hugetlb.h | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>>> index bc0b9c65aa1d0..9e8b391aa4bc9 100644
>>>> --- a/include/linux/hugetlb.h
>>>> +++ b/include/linux/hugetlb.h
>>>> @@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
>>>>  #ifdef CONFIG_MMU
>>>>  	return ptep_get(ptep);
>>>>  #else
>>>> -	return *ptep;
>>>> +	return __pte_from_hw(*ptep);
>>>
>>> But this is a direct dereferencing, which breaks the whole point, isn't it?
>> Yes, this is particular line is for non MMU. In this case, CONIFG_ARCH_HAS_HW_PTE
>> would never be defined. Hence hw_pte_t is just pte_t and direct dereference is
>> allowed. I'd thought a lot about it; is better to leave direct dereference here
>> or use some helper. Then used __pte_from_hw() was already being used in generic
>> ptep_get().
> 
> But in case CONIFG_ARCH_HAS_HW_PTE=n __pte_from_hw() is still gets called.
> That looks inconsistent to me. Why not just call ptep_deref() (see below)?

Agreed. Calling __pte_from_hw() directly exposes the representation
conversion at the call site. I will introduce ptep_deref() and use it
here.

> 
>> There are only two users of __pte_from_hw() at this time. 
>>
>>>
>>> What about introducing something like pte_t ptep_get_sw(hw_pte_t *ptep)
>>> to be used in exactly situations like this? With that the semantics of
>>> hw_pte_t pointers becomes straightforward and closes the still ongoing
>>> "storage vs lifetime" discussion:
>>>
>>> hw_pte_t*     points to HW-formatted page table entries
>>>
>>> ptep_get()    is used to obtain HW-linked/attached entries, and may wire
>>>               extra code like [1] or [2]
>>>
>>> ptep_get_sw() is used to obtain HW-unlinked/unattached entries and in
>>>               most cases is just a direct dereference
>> ptep_get_sw() or ptep_get_deref() is better name here?
> 
> ptep_deref() would be it.
> 
> Do you agree to the suggested API requirements?

Yes. hw_pte_t * identifies storage containing hardware-formatted PTEs,
regardless of whether it is attached. ptep_get() is used for attached
entries and may provide additional architecture-specific handling.
ptep_deref() is used for unattached entries and performs only the raw
storage-to-value conversion.

For review, this patch would become:

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index bc0b9c65aa1d0..ce900d2652d91 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1283,7 +1283,7 @@ static inline pte_t huge_ptep_clear_flush(struct vm_area_struct *vma,
 #ifdef CONFIG_MMU
 	return ptep_get(ptep);
 #else
-	return *ptep;
+	return ptep_deref(ptep);
 #endif
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 1768421755a9c..08613593f3320 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -490,6 +490,13 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
+#ifndef ptep_deref
+static inline pte_t ptep_deref(hw_pte_t *ptep)
+{
+	return __pte_from_hw(*ptep);
+}
+#endif
+
 #ifndef ptep_get
 static inline pte_t ptep_get(hw_pte_t *ptep)
 {

-- 
Thanks,
Usama


