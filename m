Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA48DC54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:04:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C242F6B0088; Wed, 29 Jul 2026 10:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD48B6B00D4; Wed, 29 Jul 2026 10:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75596B00D6; Wed, 29 Jul 2026 10:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B34B6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:04:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C15421606C6
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:35:19 +0000 (UTC)
X-FDA: 85041608358.07.859474D
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010051.outbound.protection.outlook.com [52.101.84.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id A805E1C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 11:35:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ksKtZWY2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ksKtZWY2;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.84.51 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785324916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tgo9GG3IRVIRLC+akaXKtPN8CAdRusLZrRKYCwTPvzE=;
	b=z5q7WYSz3HaxlOqjkIlpzyUQmRjhg/dmvhRhswqS+x2iMdS/ql60zByzbeEGihnobzdUCC
	hz1/bwtmT0WinWJBVtyNZU9y4elQv5tcUSq6OxCl56feFOd4PAr5Alosrj0kUPu3oftE/p
	Xk7t8I+qvNARbs60CW8+vKK9FQWMO2Q=
ARC-Authentication-Results: i=3;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ksKtZWY2;
	dkim=pass header.d=arm.com header.s=selector1 header.b=ksKtZWY2;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf18.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.84.51 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785324916;
	b=P71zmD+RvyOO/omEnNP5S+qAPbAq6C8i+Mhjc5kJSUdaep0A/A9oH4XRcN5fp5Bh9eclMG
	4XXNxkm7u3hMx4oRZa1sEnTl170vgbb0r3X9ara3rL80GGFrX6t7EoZXfgbcOO9DCgCzLb
	VSnAmlpvDlXkWfNkJCvvCn3MZE24zOY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=A0HR24kZDbdXI4a/j+W5uOS1BNTVcKv7x8tvSi2YHu8yMad/MsqwZGb/NJi8uFOBMrlNYmmWl2Rm1nKxAwKIJrtqlG0aWLHOo6JrHn9bcf4K3utuO71Nl9+1W+ekFP5rGPxQBBpx5HrbmNFZadcP0x9jySqIOAyqj6LdmM9kUkWd0qyyU802LfbuUMQ4tnfybtQMdwsuh8O9YkkFd6612CLEKxnn/+AQ7d99YwOO2BRdond9yAORF2pEENKAgd+jbsLLdNHoWuxoV0zj5fiWlhUQr3pJZp770MynLqO6+nBdD4UKAAaxLJwrii+NKwtA12sJdOVFPbmZZHECix5GRg==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tgo9GG3IRVIRLC+akaXKtPN8CAdRusLZrRKYCwTPvzE=;
 b=BFsgFfOFx+g1LqdbnsNcP9Mta+fH8KgKvQh9mG1wSSCsa4lSKu3Z0Po77OiEWXhXoJqeQ/W1T5x3erVAQMx1V9WFI48OgQZXz5DMx4DGUMPApsVUL7kc0HvyOQA2v1p//bKfPQ7isPHd8RP6mAVuXj5oLZvT2Q9WK0BF9UsDzEZv6VnIz69O2P2kc1OclYyN8aptYjCkwC7OVa05NdXu4XLXTmaYOL/n02y/oOAPD2l3e9mXOd8SJ6cT700tlmK+0W3akPngcdld/vEBMETeGU3TnG46jgeOWauj8uIj1qEt8THqHPb66Hirtn5aL02L5PKtjRz/z2UnF6YZmzGjww==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tgo9GG3IRVIRLC+akaXKtPN8CAdRusLZrRKYCwTPvzE=;
 b=ksKtZWY285/taAao6Zu94jYQ9CxkEq+fxreWsLvoSuuGlXnU8kVZuGWinZRmgHUqlXh2H8ehJfihGsewMVLpcP0p4NTP5TSWEBd1rlhEOE/htrE5Y72OIC3h18agAcY8Z7LmW4ODIa3lVlkSosdTORWVuiQa5ownc1NjI4R50Dw=
Received: from AS9PR06CA0536.eurprd06.prod.outlook.com (2603:10a6:20b:49d::35)
 by AMBPR08MB11653.eurprd08.prod.outlook.com (2603:10a6:20b:737::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 11:35:07 +0000
Received: from AM1PEPF000252DB.eurprd07.prod.outlook.com
 (2603:10a6:20b:49d:cafe::1a) by AS9PR06CA0536.outlook.office365.com
 (2603:10a6:20b:49d::35) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.12 via Frontend Transport; Wed,
 29 Jul 2026 11:35:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM1PEPF000252DB.mail.protection.outlook.com (10.167.16.53) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Wed, 29 Jul 2026 11:35:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LSnYCeslggQxQSwqDV21tCiTCB6yv8A+BS3ksQcSqchYF8y/ZNsAtgL0N35LiyfAZzzgu6CFfPr+4Z/jtZITRHUsUumNcy5zzVQAnPqM3VRufn9reQPjHWPaK8Pj7EDfD37hxf743LYKws4P1U7yZLiZhTQTebxZdAfvX0pxn8qBK/O59CWXr/vIup/HsaO52swjgJ3vZIVe6gEa8AZJVLfmK3gMj3QRTDNYKxJdKZkQvGnCTqjLIUS7CMlceliqGPUFH8bRlOqeuLnsULe/0Tj0P/2E4g0W9AMwkNBpIFShHrEEk41mfUoVPibG4ot/fWkN1/fW69dPWS3InikcOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tgo9GG3IRVIRLC+akaXKtPN8CAdRusLZrRKYCwTPvzE=;
 b=t0rDZriZ6OpjaJ3T+spCrkqxr0d5LZEkUqpA31+K0IeeP51GOkFxCAm2lAS5Q8F4u+dt4CDGHN+ySvjZ4FoheyMLxqAS+fzUEP5vxGEUC60TZkjJkpGBrEpiRHexoSmk49tdqfDRLFPFbhEaUy7T533Xf7eXs+VOcyrb3fPt/B9ApU1SwduBz3HHS2tK887X0YwWfuYfMY+/QuzU4kLdOyosqkubs/H7/w7YG+0PvbVto5HiaqcGCYxIHmgnJKvJwFzs/yQdDJzfyfMvIBGONVO9ZuXztwHAERguCkH3mp7H0xn/Vn9Usf3vRW8AcTTCAVVTyezLQTu4dQxTarwKcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tgo9GG3IRVIRLC+akaXKtPN8CAdRusLZrRKYCwTPvzE=;
 b=ksKtZWY285/taAao6Zu94jYQ9CxkEq+fxreWsLvoSuuGlXnU8kVZuGWinZRmgHUqlXh2H8ehJfihGsewMVLpcP0p4NTP5TSWEBd1rlhEOE/htrE5Y72OIC3h18agAcY8Z7LmW4ODIa3lVlkSosdTORWVuiQa5ownc1NjI4R50Dw=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV2PR08MB7955.eurprd08.prod.outlook.com (2603:10a6:150:7f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.12; Wed, 29 Jul
 2026 11:34:00 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0270.009; Wed, 29 Jul 2026
 11:34:00 +0000
Message-ID: <46319967-0338-4532-b953-dbea77084fe3@arm.com>
Date: Wed, 29 Jul 2026 12:33:57 +0100
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
Subject: Re: [PATCH RFC 00/11] mm: distinguish PTE table storage from PTE
 values
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Alexander Gordeev <agordeev@linux.ibm.com>
References: <20260727164715.2866609-1-usama.anjum@arm.com>
 <2c19247e-bee6-45f4-a353-2fcc60db26e6@kernel.org>
 <7813b5fe-e767-442c-a356-afc1a5c567ad-agordeev@linux.ibm.com>
 <6db0a8c0-b500-4364-be3d-d3a537c61258@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <6db0a8c0-b500-4364-be3d-d3a537c61258@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0161.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::22) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV2PR08MB7955:EE_|AM1PEPF000252DB:EE_|AMBPR08MB11653:EE_
X-MS-Office365-Filtering-Correlation-Id: 1cfd4d6e-e159-4f74-d058-08deed6570e2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|1800799024|7416014|366016|56012099006|4143699003|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 xfbEy9xFy2KjtgbtZQwVRo/4rDSmq7tan+BAO+pWdsGQt606AZahYR8QjfxNwepbtpCMtOOt+8wN6/aZUrVxGXdve9SNgmI8m3i49FVH1QvKzgN5iWDAyc/qG37Ap0G5Y97odKPEnoyFqd5WWCZrVDk5WcqlYn1UwCiLpvduHOQ4yKJHDxymZa3ezH7yIgpM65fy1J5UWO78alRqVRYlrkDOFWL2EaCUXoJxhmlAjJf/9UOgfdXHsNXdCO/znX3umbrqmhM0sQPcJ5r2VzRsoQeAv+i6QegXoExunECasQNkLXlSXuF1rfAjl27hyVJfWLP1kh6Wm1wg//SMzutnVr0XBV1zVP+5KkRjixIEliIfiHgPajlHGFEg0DSfY+ITRVfPTuzgauKHtZXF4IJPVHsDbIGz7qKh3qavST24XYL4oY8gg7unjuuFv0XeSHMU+/FxCkxzesBUNQBZN/20qiLgprM6KvcPUSbXs7HPQiJI0p45cXsivdzB+efiv0xLdN4ZMqtdCHKXfaRp/J6a1owLvwowpLkBOkJkar4nFaDFO7GgG4qvbOjtHKBP5iQNtpNOHdII6lgDMrPlunWF1g3wYJI2ezCDEC9O7KZd6Sf89Vm+sXMSJ5YifvkjccdnRSEDGI26zF05DhcTtdnoNfWBagvIF7AW8rx0Rv6l+2k=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(1800799024)(7416014)(366016)(56012099006)(4143699003)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 bfpSLQDM89AGYUqYoFAxdTSUxQeWzvqrXWN01Q8nSdOHv09YbMqZwEkh4De+S90bWZhKDnix564/0iluBMAaDBLsP/eTzmgwj8zSC8MqbERlfS0mpGodCyOiNyPtSf7Pe+nzMgJoUgaYugPoxE6pM543p0DW/yTGW6oZ7bODJ5DM1V+j55iRlovzyeqTGf9Sb2QjeloUSNBQhR4N/qRtUg106VYsNxb8LiTmvTM4/T7wuyg3rWvD8R0cLWaftev4/sKlE31/5RJ3yOUwg/+bPmqGyASd1WLyfVazwE4VmC1+AShpm0prYuFDu0FzTmqdeirtBDGb4Y/uPepsm/ldrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB7955
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	191f0cd4-83b2-41b7-9c2f-08deed6548c6
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|82310400026|35042699022|36860700016|376014|7416014|23010399003|22082099003|18002099003|4143699003|11063799006|56012099006|10067099003;
X-Microsoft-Antispam-Message-Info:
	z16m1iP5gJN11a0jHm2h5qPOvpYoNr0dsqnEGISR6jYEFwxRynbmbpuiqBvgMacxSIEx5YgZ1PwjI/B9Sb9qPESFT+ZKOzcpvp5wGg5c8wFb5VifVw9YxWu3jtI1X8Y0UKz7eDfqmnn4zZCjk9sUGyf8kW5nyjz3XUG3wcikRyU77msznLp6gKihMrp7u+N5DfYb/ZDcfjTyI7Rlr79hpWV2IcgXmQNbclHFb6Rq6JKpIdfruwnLVHkKlTWBUzeNugtyI3rXG4GiTCpREqnQ1bwnzXH3ZnCHuRsWA1Olns91kFs21geX+8loQjA3qKxaOU5s+fbSJhCwxoUhOT8ccWvQ69YVooyCBgyvKfCZHpy31IRO4xc33DWQzHXuNhS8Fl3qzZSyIjpOgukT90izO06tZEBoOeC2N2dPYJapJN+F+L4pTMNfznbH2+UtMKogru9eNptrEb+M8/uJKDP0mf7A03ZcH7pWmbm/a2H5kgRcDgkK8hcF5kjrjKAbvKNxkvHQqA0GpT1YZ0rl651rwF1U/tgwvIkXpDYm1PKALpA+velo2OYakXWZdXf9KYpJITaddu7xFyAb8yeSZB7/l5loYr/hKxTr/1/ItLgUkYm2YR/d4z5RRKPprkSOic3eWuDYHegrbt3MuncmtPR/bd5+17L8W730bwCGNTOzAyDzLqbC1ZA4nkYvfNni0/DwtNnIs7/ljjvCCXn5zPInpQ==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(82310400026)(35042699022)(36860700016)(376014)(7416014)(23010399003)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ENzrXljKBm6j88ocfFU+EglvTRz9gwEO2XclvPfJlM0SMYPml8qBN7VBr1UkWY8PlHkL84VSx17YuFpoNXHSN9TAEg+fpXudNoKAQuufrKipXBvCdefFXy/otThCc4mhQCcQIzvdSgFZ2/NXWMDasEHm6joFxEaxOzo0pcNvuM/aKekIYFDqxzwKJpVTyGnsVF72jogbVQ1JvzKGEjGbLVgAnhQkZkVN0pNBp+RVkEGrGe8Mf4yb60Ze8uXoz2VgXcZr3jpOAKd3Hk5uwBWM0yd1FD0l4DqE6NotxNQLr8TTkmipYeqe+WEdDNGs9SBaDTvggiqSszP5Ujwp8VFA7i5mZo1Dt63ktCIBR3GP7Di9PrmjkWf1b5iHgiGDuvKuGlAVCe9fHk8Kj9WPYVctHjkR3F3VoAIqJE/PdzZeunCxtniBF9CW0J/7gL7gFZC0
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2026 11:35:07.3851
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1cfd4d6e-e159-4f74-d058-08deed6570e2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM1PEPF000252DB.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AMBPR08MB11653
X-Rspam-User: 
X-Rspamd-Queue-Id: A805E1C0002
X-Rspamd-Server: rspam01
X-Stat-Signature: jhxap89b4hwapun7giitxo5egrgazq8r
X-HE-Tag: 1785324915-492127
X-HE-Meta: U2FsdGVkX192x5NoOVOCuaTz7I9pDTwei3DVKQGSH+t+FqGn0rbS3Nyee2d2KkDCttKddOjPnlJic1zhQQMZeP86gN3YEtxCaW3siBYB/tk1BLB/R7Nm3x/wrvz5qHyfgRQ9RSbmI80ICKeEsrMgXU21LgEkBWbBEMtell+voE4gJT/TfgNyG0GzoDly5qecOd/wsqQGiSFUTvqeBIxJEZNDg1rFzT2TQpx97dsSy0Fn4YVA96hZ9NGyG7uU2ouMvuSRB9JX32HzcZamdyg07AOLi/wq6vF+LW5h2HsIRCTxRYDhbgTXCZpb2s/IG7Pc8VGL8aWSpdXb2XMVozddTxmqvszipBmsLaxIb4oprGdw6trdNzgpajAQU+nemihPpjcEx3+CNrpeXvy0ZXNNnmMSs99//NMhdX4tcuy17UcPcFt6cdwAQ+hm4NZRArNBs1OvmGbMge0uk/j/jcY1Hp0lji1g6Y8/vuJkSXPIZjVpShfhAzsg5fK89vmkW1Osc/+lzZaeXgpNIPaOn0nmuY7+ElX7G2z3YVX+/2fNokqny5VWpmiJTNrEV4Qj6AaYmeVnr73qVWTqp6a0dCuMwEuKHPw1PXWxLquHlk8neqV/R7OM/6Dg4tuH71LiCZ4qrwtG8SB5nFnZFcZP0cGbOfOm1YknjHIFdexMK/MMvfMS6G5zOwWUH8Y+mgh0beujrtLRNGsWiAGK6bQScabiCiHNyO8ShOIy1xlPeL/uXyirPcuCHkWl7rPQxy2iNIqooHe2+uvGD4DQxvdoMEAEXQBsmsnDwb/ux1i9MPdE3Xm4HNZGR7Rez2PmLa5jWSiwttpCYDF5DJeb7aJgc0E9a/mfPw0xTdKHswkQWJQjrFFLLXlV4lz8+gt4k6vrUq3uwY8M3kCr41E1M/JjM0BIgZFWqZwFXfvvkueRHrROta5y7eGP0mOdu8opf7A2GlvNDk1l9sQq7t+BEHEGbJu
 2sR7k8cu
 noe6Uw1UqmtF/y6kKSdwGgWhAbGc/q64fU+/xtoRmdGOdnMu06OxUlTOaNGBXvd4uRSvb6wkqwBIpmOiuB+2aHNpQGFf4wS4u+kpbA23Ku5Pw2WKS8M+/3J3NMZ9N9v1A9PKBBPt017ixVrZmurtM1cN0WNAscTMXYB+HI4zB6GBvy/VuwmK/oiu4vtdfmDa/31IMpUkrUxxn3ss7pJhOa8guZs+mWMAZP6ur1OHrsESYN7EuRA5u3wSH95PPLJ3lVFdDdXfbuVT3YbmQ3G5Cznz/xasgd6Q4XOZr6MQnugUf6+vvVEAXRXpqMsvsF3SEbehPv2YT/g0qzd6AJC2poR75AakLervXKXLnyp3PvE7DIuyHTLck07T/UzNdC6TZq7QUadxXD5bSS8UMGi4mmTUbqbNrWa61bc0EJrM4ohjxY0ywWdguI6DL8Ld4KW22D7XfxuZF74KIfQGyuN3pGX9RsZJqWM9eV7vWNvL4ouzwCFbAtONqn0MfVKicxW8JVtQWqhZDAd94vSFoap5HlYaBdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 29/07/2026 12:05 pm, David Hildenbrand (Arm) wrote:
> On 7/29/26 12:13, Alexander Gordeev wrote:
>> On Tue, Jul 28, 2026 at 09:26:06PM +0200, David Hildenbrand (Arm) wrote:
>>>> The generic definition aliases hw_pte_t to pte_t, so this series preserves
>>>> the representation and behaviour of every architecture. ptep_get() keeps
>>>> its existing READ_ONCE() semantics and converts the stored element through
>>>> __pte_from_hw(). An architecture can later define a distinct hw_pte_t and
>>>> convert its PTE interfaces to make the distinction compiler-enforced.
>>>> Architecture PTE implementations and most architecture code are
>>>> deliberately left for those later opt-in conversions.
>> ...
>>> Do you have a pointer at the arm64 part, so people can get a feeling for how an
>>> actual hw_pte_t implementation can look like.
>>
>> May be we need the generic hw_pte_t implementation as { pte_t pte; }
>> right away?
> 
> Indeed, that makes sense. We just need a way for the architecture to opt-in that
> it did the conversion.
Yeah and architecture cannot opt-in until its converted. So we should leave
it to architecture to define hw_pte_t.

> 
>>
>> Also, can you envision a case when sizeof(pte_t) != sizeof(hw_pte_t)?
>> If not, the compile-time check is worth adding.
> 
> That wouldn't work as is. We'd have to intercept ptep++ and instead have a
> helper to advance the ptep pointer.
> 
> One idea for that would be to let the compiler catch that by marking hw_pte_t an
> undefined struct (unknown size), such that the compiler would indicate any usage
> of ptep++ properly.
> 
> That can be done when it would actually required, so as a first step having a
> generic hw_pte_t would just work.
> 

-- 
Thanks,
Usama


