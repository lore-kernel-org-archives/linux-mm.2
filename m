Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6545CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 12:00:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0405C6B0088; Thu,  7 May 2026 08:00:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33916B008A; Thu,  7 May 2026 08:00:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB5E6B008C; Thu,  7 May 2026 08:00:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB4916B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:00:26 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F4A11C0C99
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:00:26 +0000 (UTC)
X-FDA: 84740481252.04.B99A3E9
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013003.outbound.protection.outlook.com [52.101.83.3])
	by imf09.hostedemail.com (Postfix) with ESMTP id B7950140022
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:00:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KZCrlYdC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KZCrlYdC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.3 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778155222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1vkFQeRVwl6E89p7vebk2n35xNMqE06puQU4y7nDlX0=;
	b=b/Vrr8KvkNnyyqUNER8cJ1czCiNKfH+pACBn3L3NRlt1pMWV4KxjIzsdPoi07AKJ3cnteQ
	peHVwvbW/DshokUfRpwo2MkA4KtI51pP9LVN0/0wUBPgVruwfBqKyEVXY4yHd/WNzKJpZb
	KvYjszcyTjB0Nnq/v5Ipvc2vZAPp2S8=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1778155222; a=rsa-sha256;
	cv=pass;
	b=xcJ8CZDVbZhAJAAXk65e1dL45J6V04quHtpbDNks8am7bJSW90AsRvGKixCfKzLvp6gBtC
	dSM9MjvVFIpzhTRjDjrP1xkgQ7Go+CE32ht9k4C+/CM1CN6HM1H0XwXK8aR7JU2/JI0BAV
	SPIBARxNrQVbFfoHOmY1hZfB9AhBytM=
ARC-Authentication-Results: i=3;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KZCrlYdC;
	dkim=pass header.d=arm.com header.s=selector1 header.b=KZCrlYdC;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.3 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=T8z85rXesTIMv9MFpvIv3IcpvaHm/FHZIZqRB1j42mPbkedK03Sdv+VP4YT9qWxpyPpL5tCYwUjUgfQIEfmuD2F8zs3Ww7ldcAmLKBUguQHVxxh6R8el7iJvmQ+gKyksJYa7bJkHR2PzYxA5cUNq4oWhAwiH8Bhc5zco8Mr9CM1ActR/iUOI7Trz08/Au2P6IGk1ZRL6WOAcBT0JDGlV+INn8HkmewnaP0Mq+JlfOYoUnKVcCsiuifvUmKnb14ldRE3erMT9kbFEjC2HrYri5Tlx8eo3shtJHH1YR8KZ6GS6scq4+dZKeEwLetieR9KNIRVQ0mvpjojMOk7uRQpQuQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vkFQeRVwl6E89p7vebk2n35xNMqE06puQU4y7nDlX0=;
 b=Q3Tv6pG2q+vxdjBFHO3HqiO10pZycivvbnsTLrR7FapKnU2kwU6KR5Qbi6IxnmpcexVebQpq9qxK8zAzn4VfyTauZFTOUWzWyqWIYWlTEEg9aoW51RADfkc7Jvyr4z2lIdd9XOx7zV1xNZqIj92fLw0lIfFZCxiZQi/6hxDM7BJcZRsTOb5TK2l2ZdlcNwmzwZ0PD8+WN+GLmsjn2F7Ib08OdbY1/1yZrEu741xYGEXHljAuIXAPjtuLDrCn/qILS0ARXsS0PIGSo5yzP+GJDANl/O/AQ3Qvc3dj6hA9f4N6AmJ8b7fqxcJkLzmnh4B3Acb5EDTlgIV3GaP+wg6gmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vkFQeRVwl6E89p7vebk2n35xNMqE06puQU4y7nDlX0=;
 b=KZCrlYdC14gM8ocB5ft0J8ycmU7cxzar1zbVHBZRUIK5x/zlEbKfp6wg0fxvpTOpL2DxNdbp+WQWybQ0WrFn8Vx0efeHYBYBnQ+ptn36o+yfKQw5wwnmv5Qm2FxOjSbOJX0uFNDTqChHHWYjCvcArWMgBJcJXkg9fcWh5z+GZpU=
Received: from DUZPR01CA0002.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:3c3::8) by DU0PR08MB8164.eurprd08.prod.outlook.com
 (2603:10a6:10:3ef::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.17; Thu, 7 May
 2026 12:00:15 +0000
Received: from DU2PEPF00028D11.eurprd03.prod.outlook.com
 (2603:10a6:10:3c3:cafe::6f) by DUZPR01CA0002.outlook.office365.com
 (2603:10a6:10:3c3::8) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.17 via Frontend Transport; Thu,
 7 May 2026 12:00:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D11.mail.protection.outlook.com (10.167.242.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9891.9
 via Frontend Transport; Thu, 7 May 2026 12:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vPbmMoXvYfjmoawjCr221XQuHJA6rs4ZFRzyNAbR9oQGnEc73d2k22cWF+C1dZ1YaGjIxFID+VyMQkBsIzaM/KrOQ53OryUbmgzckRp7GVfZqT4PJsSGjpDFd0NgLKseRs1ppalfm5Td00naapQDWVoUD9KGZRsfs0yKXMADWCXGZIxXCa0APGUSFMmw+EX+4CIwaxPe7fKCh0t27SYNLDcCojWuORqFV78osa2b5dZsAyBppfjuoa3P6fkWJrm+ibHLAjh49CmCSFHLkYNPbNoIHs3EX4iQHUlv+DEAjyaWK3iI+8hv73aS8pkzVqMZGTU/x+gGoAb/MqvebrLNjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1vkFQeRVwl6E89p7vebk2n35xNMqE06puQU4y7nDlX0=;
 b=GayKv/j1zItR9IV7UteQUgc+1XBoODvIb6uEFB4HhIosKXXEudq63t8CO+Z/0mI/VrPVN8By63P+i+2KBr+y13VT3ZxQ4Rx0TsFvNcio7Iqdk0bUonuw8P3AlPUlxg+7+qWnx+Jly4L5GPDel6x8mTi7HpXmfQWlctAJIzCg1zsKO/2uD0TdLiN6vimNvrAA3Zdyc0ncF+hb+SDZ/x6Oc7/6PsB9hyW6jaJ83Jh9iPkR4f53pjsOXV2NFvLs+4HU0v0ahqyKvwiV69t/xrqapO9gGT6C2YIFqtZPJQYyT12LsHMPe/79UJX5POanF+KciBOxVjbZvoE4WYJW2/4D9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1vkFQeRVwl6E89p7vebk2n35xNMqE06puQU4y7nDlX0=;
 b=KZCrlYdC14gM8ocB5ft0J8ycmU7cxzar1zbVHBZRUIK5x/zlEbKfp6wg0fxvpTOpL2DxNdbp+WQWybQ0WrFn8Vx0efeHYBYBnQ+ptn36o+yfKQw5wwnmv5Qm2FxOjSbOJX0uFNDTqChHHWYjCvcArWMgBJcJXkg9fcWh5z+GZpU=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by GVXPR08MB10667.eurprd08.prod.outlook.com (2603:10a6:150:15a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9891.15; Thu, 7 May
 2026 11:59:07 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9891.008; Thu, 7 May 2026
 11:59:06 +0000
Message-ID: <45b6fb2e-3a24-4346-9d8b-158967c88ffb@arm.com>
Date: Thu, 7 May 2026 17:28:57 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 48/54] selftests/mm: uffd-stress: use hugetlb_save and
 alloc huge pages
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Donet Tom <donettom@linux.ibm.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lance Yang <lance.yang@linux.dev>,
 Leon Romanovsky <leon@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Luiz Capitulino <luizcap@redhat.com>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260428204240.1924129-1-rppt@kernel.org>
 <20260428204240.1924129-49-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260428204240.1924129-49-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0118.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1d0::11) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|GVXPR08MB10667:EE_|DU2PEPF00028D11:EE_|DU0PR08MB8164:EE_
X-MS-Office365-Filtering-Correlation-Id: 330d2f12-82c5-4ecb-6e97-08deac30331c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|1800799024|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 7A5Zl6Fi6tj3cs23pFnAUPycRf76Vri7w6RLrY/9Z6LAOevVyNdp8LkJ5Ns2L9VlfyT0wh4ribIM19N7j6dihLF1RFYISYVBlSaEp70d0udgYaMqw9PFOttN/dlVVIpk0S40ajuTFv2nMNw0NQLbCA8y+HjQF+hQuYvlAvuIvrSEJhuDcgOJjwb0qlISiHGeePGmGQDDjmutPGH0SY90j6gmuY5EJYHJ1Grsjs3PbRE/KieiiW6vYW584w0r7Zn2JV/dSzZ8+KDEAvsXnCjDw8sC+I9GrfNa0XcCtBJ+lbUrPoO7HfrFiJ78MqIKVHRJHCeCzGvB3MLVudcuTCDKv+oWczE/3+k6/by4M+Uo0uQUifq4B3TUcCYwP4DARf8gkX0MNWxiLuBzpcIBYg7o7RZIi50psZh6LuW8Fgh5fCr4k/mN3NW92NuIo1MHCWO/RolzoJyrIDhaShz2Va3Zxu49r7jNAmNAgjQhFpcV0g9QCqYxyWvbntlchh2eXC8MZY3a5QKuxkKuqP9/CIfVec1f9A7uk0TnGNjJ6OaRd/1z5YS3kFS0O5wMq+vGkB55+Th0sSndZmJlvWrx84II+w9sTeFg3VMMhSp5a3smtkNqzx4y3qZ7D4mKUnUsGR/Au/SIanAJl8ZSHwd1/cPa0IdUIt2jhE1QqSlelMouxbDLtKu3LG6RLinxYnTdp1vr
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 vppU6q3Y3qKe/huSUU3Hg8ek/rQJHApsJgO2OFdu3QDXeTcdH53ARX/Rax/4e22vq1pixCVSxDqFzibn8smnkguolOSHILafAvzYIktTnWfGtFOIoveBmW/XyRAVV6M4Z8iTMoOAgM2zhrNISqQxC9tnNV4GLWI9hKjBNjjYKRNi6N2KvH60BsYuE9lvZCy8AiZGMXw4kXUdLbi1UTgFOTQQn0ZMlOgviV/XaoHim4AxvFXzuMmIPKSM7k4xMcsSUgqVcgtNt0pwF6SwckyGBKTiBQEWZkQyVCh0nAuuGg7ahZC6Fz/LRMXjZquU2WuC/d7736zMlHTD6s9haxuRAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10667
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	8b573098-d4ea-4a5e-bdbc-08deac300a56
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700016|1800799024|14060799003|82310400026|35042699022|7416014|376014|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	77+gy74U6wT/d4xzTjLZviTm6nrOiXNfye/nYN6Cq6WEO8IOJAiiVU80klbEEoSHGmwyfZrapn0GCYAFgraav+V2+HasDc5uRUXQdt8YanXh1w/5TvaKQ6VPP8YsaCbW0tj8syZQBKomo4Wkv5e6vuAriplpasCiuXndlM9pJ5OTcgmqtYBL4q9CweQ+8Ftdi8uXCn4iIw7FSGJvYohQiS1CcAVlxpjgOBslfTNtwylAlvYrdwFS5cHvT2RDoeSEddvQNaLvF4xcD+QPheUjVQGV201zuPL/5n5DEuDSLk0vJiPUuvT8HNFQYu3qOqmpyXo3Vix6zTUCxXvNQtxXDN7sVAwS0Sj+w8hunDSwbSKyUVc+bweKdfV2EaGK7HmXPG3ApgqzEzCz539g7fwj2JXLFWCDp64mxRdWu2MDLl9/GooqjVlKDxgPynBSzSvzrx/ku21IsK8Fz0vhDmwDc0ON++LbIGmry36OmPnTlJqivYdGpWalNsb/iVS+cImADm18/IpSM1nIxSBGpmqgC/NTLtMM1XkvLsZPuqM1S5vL6ffav1I5T5g9NXobFfw1D8QR2ZOMk3RSYHE/Pux7WRaPhm0f3Hk1fOmd849+LKIGJcUCl9b69l2WInQCpUNvAxZgV8UGroeu3iSGp9cKNdqyC7a7zupjG+ucdy+XH4XbhHQ5Dh9n8vhkj03xsc+uNNjU+S249f0UOjh8VFBqDpeD7xG4wMDkw06m0QFsY9A=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700016)(1800799024)(14060799003)(82310400026)(35042699022)(7416014)(376014)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	/vnHWO22dhMZ5xsiSEvIMxvbd7/6+9SCLBGvGslj8rxBZekJRgrktMkxuUqlxjXMETux/RIkCTE8tifHrrb8AWBlwquf25Nk35kaPtQjRakKhvNBGJ74HDVcIEs7rb8JRmd0VAhcpRA2OaAA/QMqAClcAvcRTJX1WGG09nMj1VNGN76Rv1y73vFmLH7yXEvLtyAPBjm4wfTUlnZ25OS64SaJNfkKdv5kEFPKmrDSQKGE7nAVrIDj/bVNRjF5mOOHIgKVtxi5MfdBDaNCDHr1HXIfVKZFhM8rubbwlss5zRzuzcw9V4VQHrcJaHU+gUMVNZxAfE8PMrT6gK443UCmUjjGkhiR3n/6gbJB2X9qBKL/0LxPZbV287waDwO0Q++HB6f8R1Xj+4+M9/XJ3yjcceRk+hxbyVlKPpUMAafpbzOBj0bzzxEyapDuXlf4PIUg
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2026 12:00:14.8034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 330d2f12-82c5-4ecb-6e97-08deac30331c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D11.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8164
X-Rspam-User: 
X-Rspamd-Queue-Id: B7950140022
X-Rspamd-Server: rspam04
X-Stat-Signature: qr3k8s7n4tgenh5qh8yf13944wkewi4i
X-HE-Tag: 1778155222-98835
X-HE-Meta: U2FsdGVkX19+zDPBw5+xAwuu5tzwg2JjYPwC4hwp4G8mzX4ESawm1/lmDEr8aRw0YqnAN4iOlxTMRItzJZMi6xtjktRfQ9mVIS/byB4cv1ZMogSJgPTdgvdY9NMjfLxKcewxRhM3hr9HGElSMioqeXvTahlsBPZ/dcrD3VEAqzRAiQS7MWWKfFIBeT6E68jbRIAd1WmF4UveLFP4Ixa2ij2N9RacgpGh56CgJ2kaYhwAZatDFVwNXMfUeFmRmx3Sewx2xLIZPf1elWRGv4vbJKIBd//qG3w1Ih9e73YMz65rTTZZvPA0Wx1BN31l8rZjrJcdeYCXi+sYaeO7lhaARhlwpxDW6UrDtAVIOkF9vlBisOc4bf/Gn/+mKVcn79F4jj7SoscKnXo2q8PBm5EEmPN4WKOsACyJZ5SL/TncGgBvKK8eDAf93eA8Bfta8EJ3m2O9PJwLk7WWu3FIlXPbj+Max6OXj/GYIai3IHwGnqrHxp2HFmqvIjfjMy3XRc0Pu6WdQbzph+urPjok5kN0gzjQvPnkxbyRM11xZqZhmD7Jyv26lQgNRYZW79x5n2L9K3BbwlYUgPmpfoUR18o1705urSacZJtfDpaUhHPknOu3KXszh0Rs3jgMIcPWw3Dnmhqx9hC7DsS/QAv/+M7uiDcmtEf+vYbSWNZcat/pveNtL4jpS8HZlaeapEGdEghurFjL3gn7fIB9JyZGVCow57mhM6XbR6QdWGdc2HAW2fNU/WfBKI+m9O7IxlSMuLIxoxXFrfY3gJDnor5zRjnAInY6uH9I/E0wZ5Xa15enIofo4VBm+qMANKDGxZWWcciRPldwbubCiXlDR6Tueoq74UjNBzxI3T669O6pMecx6dgzkSX+gxs8LVc7D+7JpSF34cwEIZjVbMxmD3WNJIHPQvyHzrNx034/hVmWQkMseVMg2LkNZVc+azOVamvz1d7PHwQCQTyCGR07Bipo4KX
 H6+qYmXc
 Rzg5VfCyIozX7H0Y07ALEMfrRAxR/v2ych5lsgXnd3PZt02sqq1Tixmjf6OpjpsDa/fAB/QyDonZ737OWDqSemRYbDXzzzNMWaIPaL5ZNkG7laGYvRR9EcM9KHn5H7himVyvQDVruuuAoW9Z1TX5lG/Z4zt6qBIXhWMpMFIEgFlgPju5lI77Var9Yjj03nsua+DHlCdoVaprIsu3MZaShDlpEM79nM+99Gmkx7n2avtq/XXtmtsfz81B7N90n3OsHlG8DWZ0eBmgMNJPEs6rCj6zDFUvyGjDzfISZakRe/hMLI+Rg5SUm1R19opa+2L2DCe/j1BoQJ5+L7/f54Af5IV97LUr1f1mJIAphR8HEhRZhTL41UxLlWP4IIDBx08UTjBCoJZ+jqmSiQW5uIYHdKrPsnV9QufdGEgMzyiY5yyxrKNnzajs9dA4HTZeFVXVUcwVHgW6mJT7TZ+vLocfWaQFYZBPTZhsJxAC3ssDw3nftc5IqX5jm8jkEYDXg9PB3oukdqIO+sOlg9TaNVx0z9SmoCRRxhQ4wzCBONFRIU+WLUTdLCwfcXXJmuha0zWUtVYjKUJkZnSkw74sdKVEcliku5Plv1vOom9e+yvdHnCziwsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/29/26 2:12 AM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> uffd-stress skips HugeTLB tests if there are no free huge pages prepared
> by a wrapper script.
> 
> Add setup of HugeTLB pages to the test and make sure that the original
> settings are restored on the test exit.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

I ran the test using ./uffd-stress hugetlb 16 20

Before the patch, the test skipped with "not enough hugepages". After
the patch, the test correctly allocates the required hugepages and
passes successfully, restoring the original settings at exit.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

> ---
>  tools/testing/selftests/mm/uffd-stress.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/uffd-stress.c b/tools/testing/selftests/mm/uffd-stress.c
> index 7e37cf3d27f6..9693d042f16f 100644
> --- a/tools/testing/selftests/mm/uffd-stress.c
> +++ b/tools/testing/selftests/mm/uffd-stress.c
> @@ -479,9 +479,12 @@ int main(int argc, char **argv)
>  	 * Ensure nr_parallel - 1 hugepages on top of that to account
>  	 * for racy extra reservation of hugepages.
>  	 */
> -	if (gopts->test_type == TEST_HUGETLB &&
> -	   hugetlb_free_default_pages() < 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1)
> -		ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
> +	if (gopts->test_type == TEST_HUGETLB) {
> +		unsigned long nr = 2 * (bytes / gopts->page_size) + gopts->nr_parallel - 1;
> +
> +		if (!hugetlb_setup_default(nr))
> +			ksft_exit_skip("Skipping userfaultfd... not enough hugepages\n");
> +	}
>  
>  	gopts->nr_pages_per_cpu = bytes / gopts->page_size / gopts->nr_parallel;
>  	if (!gopts->nr_pages_per_cpu) {


