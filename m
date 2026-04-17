Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF38F43697
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 12:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE956B00FA; Fri, 17 Apr 2026 08:47:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5C36B00FB; Fri, 17 Apr 2026 08:47:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC58F6B00FC; Fri, 17 Apr 2026 08:47:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97D176B00FA
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 08:47:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 445691387DC
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:47:36 +0000 (UTC)
X-FDA: 84668024112.12.480DC9A
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11013033.outbound.protection.outlook.com [52.101.83.33])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0B3F7A0004
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 12:47:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NgyBUidG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NgyBUidG;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf25.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.33 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776430052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZiZIKHOLkFCbkTGGyUQubhZJfXm4yHB+s9NpsSXu9LQ=;
	b=cdB9IXNfDRbVbNuoShcwa6TrbxGprB52/HoQTKsYVKkFBPPRlFRtvn+hDodTtqQ1sQinKz
	8UNxq9HALbetiwZYSppy8tcq3HjC3A4rht5nXOxt0vHQpv+axMNAYlanESSSxgyix1+TuS
	T7lvwcNgeRyVGAD0EviQrMoAQWC3mqU=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1776430052; a=rsa-sha256;
	cv=pass;
	b=zTbY/xe62sMtwmLCbGlEDz0mQmWh60/QNoFpYSiSOZvniOMOHFdYyWdByN1ZaJvQJL5UF/
	fHDPLWGfONl1FwSmACrt1h8LCWBoQXSNuS5W/AlCobkWAKRVtn6lC87WptwGOj4gIa9hub
	fs3kgkUQvC8CiqoNzRgVMKEx3pYR58I=
ARC-Authentication-Results: i=3;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NgyBUidG;
	dkim=pass header.d=arm.com header.s=selector1 header.b=NgyBUidG;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf25.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.83.33 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=NB1wH6fF3KQs2UG/rx2e/DDqBdWUINqOkvme0LUIYB+ociTdboyWEkwEZEzWG9/qrPfwCTjWJZiH0HxUf/0Lfc2qYrTOGs8zqZ0w+EGZvQ30itn/Eib+U+DwbJfHB0OrspBrab0UQepkIHGKNEuHowVCGzYrUfeLLbw3rn1TjKU+6Ccs3naF1HoRrYj4OoF84z1q7Lw9MZtEm1WzM9gkDIZi/cyYjkyQ7zTx9VLRBjWyCpy4GiLNkRuxnNRVy8L5WabA1nhUATiN+8jKzE2uNpuoR5mZ56P9ThVhnaaP4ctjLGgPzsn/g2qccM18HiRWmn0CQkKlQPm8NJfN2M2o0Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiZIKHOLkFCbkTGGyUQubhZJfXm4yHB+s9NpsSXu9LQ=;
 b=YxJyZp7VXXo9yf3MVkzLPRUJ4HA4ee1aR+V5vHiy1gfpitfMwDt3qIpP56LATQl+6f+E4TJeJtNBZsbg72YtfqQnhCj7X62M9DklWw0tt2z9N2x1VTNtRSu2jS+1JowZ5wMd8wui/8sr5h4bjgW4xYb2sX4c2WpYg0ykUhGGzMwjcXyBy0x8TonehRCJ/r4xozAw6f/oV+fTnprNuCrnopE2LRdd10smLnC7JlHzotr3Ty18Iu0O7o+ou8xRD9On5gzX8D5ld1JZpYVt+6Bg5rVtihBbusP5VHfB6GU8qbSE/JdEV8u8zNpntVJpL0jPcNj3sINpspS1VVw7oQpGmA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiZIKHOLkFCbkTGGyUQubhZJfXm4yHB+s9NpsSXu9LQ=;
 b=NgyBUidG57muSjdLFQn2VJHAsiFV3wPPf8yT3DUtOARR7lkloKNH9ew3hElmpDhhJ+G6zpyod6A3tPZxHvG+z265vhh+IBL+Pwsf7Oq/wdKd7Thgh9lKfSvEPsucC7Du4IjmJ4gso42z4cTcNRgVPmOWKVU/t+eW4aoPJaTRFDc=
Received: from CWLP265CA0460.GBRP265.PROD.OUTLOOK.COM (2603:10a6:400:1d4::20)
 by AS4PR08MB7656.eurprd08.prod.outlook.com (2603:10a6:20b:4f2::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 12:47:25 +0000
Received: from AM3PEPF0000A792.eurprd04.prod.outlook.com
 (2603:10a6:400:1d4:cafe::e) by CWLP265CA0460.outlook.office365.com
 (2603:10a6:400:1d4::20) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.52 via Frontend Transport; Fri,
 17 Apr 2026 12:47:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A792.mail.protection.outlook.com (10.167.16.121) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9769.17
 via Frontend Transport; Fri, 17 Apr 2026 12:47:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KGJ5Vq68vSW/Qh7CkZAr59UtLNVzGTzGA58tgO6aYNiDLi5frNHH5p9VM5zgrjgjuOYW1yn2AGAY37DS/Ed5DfLD9wBL5T978rs2KxRp9SeDbSEe1iBi0NhqpByNpcOq9re6WfUhc6YUZ5km4Fw62rLeVpQhPglh/h5kaCJBnDNajh+rZsyfoQABkKqU5VMNE+NvLME5y/4aTWoG1me1jex15sTWG7RnNyQ0Y/7VyZH88gg+dT31qXojqZFbrWAnZJn6ndkEdToTaLAjzv9vs5zGVqDbGFttwUf2iZrUNv9FUovYqgUdsswCaoX4c900/qKyyTVdjQCJ/NaK0EaqZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZiZIKHOLkFCbkTGGyUQubhZJfXm4yHB+s9NpsSXu9LQ=;
 b=JOxMLJxfEX6lGMabnNBADtKqXTND/3kBB6Bt9jt/nEixuOxYT/3ZbffPJwQ4rl8WIySoHY+EhUcxfByf3S/NgyBGAU7RYUr5JD6X51xXfjNdfPgfKvR/un7kQMQkg89u7zNMbrxOC9MtHzkI8DSJdmLTN+AxRiAtMPQzRzjBYQJQKzhgd+fuTlI9k5CdM0qvnUAhqOxiOXv7gbOu0hzy4bR+eFJZyOGBTW+rKDpvYevOXXivHe+cCo+jaDPOt0ndZAnAY3x58Ku8FVAmW5ctfXaCZEFT93KcWF0miWYG5TVXTsgPwTrpvmpuVLhbAMAOsXxH3TKXgc4iP5yOypu1Lg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZiZIKHOLkFCbkTGGyUQubhZJfXm4yHB+s9NpsSXu9LQ=;
 b=NgyBUidG57muSjdLFQn2VJHAsiFV3wPPf8yT3DUtOARR7lkloKNH9ew3hElmpDhhJ+G6zpyod6A3tPZxHvG+z265vhh+IBL+Pwsf7Oq/wdKd7Thgh9lKfSvEPsucC7Du4IjmJ4gso42z4cTcNRgVPmOWKVU/t+eW4aoPJaTRFDc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by PA6PR08MB10661.eurprd08.prod.outlook.com (2603:10a6:102:3ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 12:46:18 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%2]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 12:46:18 +0000
Message-ID: <a40c3365-ea4b-4158-afd7-59c6175762d9@arm.com>
Date: Fri, 17 Apr 2026 18:16:09 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/53] selftests/mm: hugetlb-read-hwpoison: add SIGBUS
 handler
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lance Yang <lance.yang@linux.dev>, Leon Romanovsky <leon@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mark Brown <broonie@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Nico Pache <npache@redhat.com>,
 Peter Xu <peterx@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mm@kvack.org
References: <20260406141735.2179309-1-rppt@kernel.org>
 <20260406141735.2179309-2-rppt@kernel.org>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260406141735.2179309-2-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0164.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:1ba::16) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|PA6PR08MB10661:EE_|AM3PEPF0000A792:EE_|AS4PR08MB7656:EE_
X-MS-Office365-Filtering-Correlation-Id: 15c2029c-ef28-4b9f-6fa5-08de9c7f7a10
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|56012099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info-Original:
 Gglb9RWZ/Hwd4Ga9butL8AizZ5fCm3NUPGuIvYjaoi8AD7rz6jNg20wV+WgATyqKQFpF/zpn9V/cOgOPq/AgYMSve3C3STlV4Bu8/jJouXlT+YGDFZggpOR8/HpXGuCg7fVU407maHOHWbzAR/W/2xErSEENyJ/2Z8Yj4ynKEnDUujSDmtqZkm+UaQVDbEgwA69imXZGfQ/Qh/ZMHgo/l6RPllvamQ+Q66hBJv3IqfwDZXk1x2XeJLJXztAftNUOMMwTpEfBrzJw7qQO2RNpjfAa6VuPlBZAwM2hlCKXVKavCJHzdgHgnj7OBDnxEyl3clexFa3p3KTYlP+SU9yONZc0jFIJ1H9nUae7FyxyUqGNvEceDEqcjzZxcCW8u5ekag9CO+ftYLcEbNt25Wy0CsyEW1kIxaoRK2ut5ckTiwxAseaafxugSXijNtdnpiTQkM8ecA4ro12fhmI/sMjhUp7imWow2CrEDRf/Q/D+Ep2SCVBoV84DbmYPaHtghPM0CeLc0p4Rfn/uQV81Bd5pSBxtO9N9wLUHDxY0sByryGY/ysVMaSq3dgowYH+t8N+azgeeKrPU8SuV5WetCX2qBasdnLCMtHyrE+dljUVHO83nzyzA2qvbuWbSfLkRkRdNd+FKQ5BdDltStpeXRhNvbyF3CemIHGvuB/eaPBKDvQxsPrrNoaVdTbnGn9GqG8pPzpMTQOXFkVqUUfSDW1n5lHZ1ceZ8AQHtCVIh5F/qBGY=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(56012099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 VCawgOH1IlJoALwXNQjnCw0bT3RGSMj07CLSHUnIX6EQzDgmO9kaDzKEp/jLBTAUPIA5+VhMkrlQa3Bj54xqK6Fdm0gqDue6kSG0sNNQWyCQ4rk3iwZ7luIah7is3Bi0dQ8BBt3n0qUb2+3Mf2YGp/VXne+vtib3FDRZJcVlr8XQQ+pbtQmwFuC8Mj2rkX8xbcNJFmH7u6tdye/E6BhIxqNVAJdiqHKH47Yjt8RsRXCD5GWbsX1zFM7a32UrzJtmKAbHljZRUi+2iAW4dOaL4tAYY70wEpj+s6i5BFIQYI7gIxufFCcHr05JWAbX5XZIZIP7W70obRV8JQW9s5QXCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA6PR08MB10661
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A792.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	13e0f524-d440-4275-65cc-08de9c7f51f5
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|1800799024|7416014|82310400026|376014|35042699022|36860700016|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	TrKOhfnpOPcBFMGswNw47nM0HDb4V9fCapivL7AhByLPq0KYHBUh1OFENEAwPVregHtafLrM7f1UMS3CTTdDOXyynXhmZlQ4XZ3XXuI17W4DYat1pQ0wPTZRkdjY3GRtzDHx0V8sYlLpEULlHTRhGDjM+13DC/QW7KcvbwZDjIC04difVnU00ThfBolO8nl3IZ2rWp+3jf84oKrB+rGkIG9zVSYF48wIl1p4prx5atH/YD2pgZJhA1U/Ezr5Jzbiejs0D9eaNqgYkZh1vu2yRhfjZwESyrbWIwhSo0LBiQdUQn9R+so1jIWV4Tpxtj3B4Gqs9GI+3Vkd4BZfiBVoyLUCtlxJ1L+SgPvYjuQidNGTyY/llEkMldoTZ2I4TgX68qRW6qzCkQmWVq7g1p1Y2Cy++mvC+a9n6w7xITKZS0GOKWL4CGRJM7rI6ADEiwNXkNXT5W8aMyCiWD8BhHV1P8gbX0pnLOb+qWRA40lZ+ssEUu6iX1lj9kfTd0pJx6IIhd9PHf7SkqDlX+Hd9zORHQk8qzXsX9QiYV9AB/mxYMOEMZOlUJ6tnGTpPBiZVnyKjjz1nJpYxyTREGn8kBvTtvbXphlVujKGNwgW5MexHAIfL7Y2AXYfbV28YYXc9LVXbJvgSz+Xq3IYwjG6iVzfgCscpwyYWv33HXeHUMQPNeI1Xn7kJEo/hlI4q9LR+qyuifbK38KRilISx7PLDg1aax6zJz07qNKVsFy1TwupYyoxDWFFso27jlIalDjCiaVGBv6T9jHbycJWHvy4ONCxsw==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(1800799024)(7416014)(82310400026)(376014)(35042699022)(36860700016)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	LvGGsISfXAMnmaHbggXzBM4ccll325yGWlpNBIhfe2U2ZA9ENI7hkHsfiLOfVeVb1wWyOjCJgWujxhKUYrxTwgY/ElbNtUMSR1A7IIqstZSNRgsozjFXCNIwNWfd5VvjuFW6GnGKrIevrDQ4KCnNkFWwUCaFVdKC94FoAlGIEgQw++M50M2lcLi9311LW56mTLzth5h9Rj1SBhAMyk/3pgd6573jD14R8PFtdC3Rpro04IkxvxOZEiLf9xEqw8B6hsqMUVfxANOoCpN3cTnCD5jEbFocAJg5uIJ5VcpS6bQjc9NGvWXXj5jAkiQRzCKhQX+8NgzJYZVUSbk3y3uelEMiiHvVCKUMT60ElhPwfREta4b8wfI7ZhmQ0OpaL1fK2j5Ghz1rJx4Z2DEaxCsVx/iuyZvQt9+YgiHIb5GiU9gFyI9MdsA28jY+mvvNJySj
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 12:47:25.4906
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15c2029c-ef28-4b9f-6fa5-08de9c7f7a10
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A792.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS4PR08MB7656
X-Stat-Signature: pd83eetdefb3ornss71nmtqhgz9e8qsi
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0B3F7A0004
X-Rspam-User: 
X-HE-Tag: 1776430051-804824
X-HE-Meta: U2FsdGVkX1/6nb7OE9bR2sQyyogzFUtXvy7JphOPgFjvddaoA2L+lWCVsn/8rT/7IRC6nMe/yIth3If0/ibTd+elkzj30qAabp/iMDtqMR8PhYRftN0id01ujmFj1kDoZWCvmQyw4zAH4pvv++HmA8TW0H6l0uA5AYG+gWypRAQTFXByZFvZJdCV2iG51lZeOcAk5ODF2o33LkrBN7tXjEeAyKmNAbbaGA3CcbW6zU/Sn+xLeaE4Hu2vlbUWLKdEgl5+0PL6QQCsoCV6rS37B5VkjE0QMjPo657oHGnZqEtemTZbJek1I4KuGgxG4z2HgA2RQVpaghKFJaLzywvyDMtgdvSP22HAL44rPSBTz2jPUi+Jzu0709xiM81h8l53arJRh73LHDaKCBDd3aiKQZlVUBz+IgrOVlk8V5mkM0Pvn2aFjgd9uNTwzciGYwBbRpQXUjZCWMrAV+Dx8o5KO9v+PH9LVQmgY7O3nlO7Nf8HPiZvDTdb2wtMKDOsF+RvGbIdSn9EGBbZzz5Kiav6hUE21Ii3QBFfsmpEloYnzGGZt1NVBPNs+kUG83slrF0dbPOBb5N0Z3LOmpWqx9vX58ZS1+IUjlpIdljFCEl7NdR98njYOTMFPafVibPjA7Bg/B8nig7DGVWmLfIsI54lsSSJjhkO7goOtIe4WOGnkX3Dm2PMFy4uVqkulInaPCh4sHu1UN9i45a+RAfB9BOE8gM1bMd/nDVfgFI1m99q+zc5kq0BZ1EsDwOyTkHhhhX/2uQruYnceNUtJpTHR2KUd/TaELYXSenD2hDhz8qEKuiqJJuR3YN892tG+hOxfPzA8dwJbkYBiT9rQAP5EFqBVQTW0CaKHwNWCrp2ANEKX7iTuDGklwQ6+SZk/loz2yFyByDeE9eBMvV+WZRx0nLqvZ9zc43dntCUDWOSzABVkT5lMiMVOt4ojLi1e0Qu28VHcNt5zQlmpSCQvGY/0kv
 teuVRucS
 BR2fnczxU/mEcecdAAw4T3O2klaRMHGNQzAJvgkFR2NynWssd67I8v007xPVQdihLcq1NRICwaP0UwElKdV10z0vdp7uG2Sk+pXQBq6zf3m2jArxkkGtdLzMclUYNXVOtAFpmgJcPARrWUYgspw0QuNSCT6CghieLTBYLGCglQj/ndX4YGwyLLiuHuN4jmYtGfhy0i2yNkOrU9/foCmKqpGoZVd3Ez1m8sDeQKpC2ThXdzD2DFM+spdVlIDwFjFvQbU6bMd08eFwmkXHNcwc+D6zklol6qKbGBivPcr2J0L8QvbEIrFM9vH1KrXmZh8tZampZPMlQq2UFJNzkeayY6PD1q+vAD6Z44ySyPiMNbUvNO7l2IFMXUpnjh7oXso0EPZm2+mBzgCBBgrrua0csNpneimS62SQwCkMJGYGBTPOBtXKLD5D0ir0nSJFc/oMp5BAQ4hYFSmqCFkvjeTjnpxLcCxfKendSEo3hfXOwcpW99QGyCwZjQuRi5K++2+2BGW7aaOj+jketxNs+1Xnh4BZbOAEr1bxauZGXAuithSyzP769xv9MzxZSQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/6/26 7:46 PM, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Access of poisoned memory causes SIGBUS, which terminates the
> hugetlb-read-hwpoison test prematurely.
> 
> Add a dummy SIGBUS handler to allow the test to continue regardless of
> SIGBUS.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

I have tested this patch and it behaves as intended.

Before applying the patch, the HWPOISON test terminated with a Bus error
when accessing poisoned memory. After applying the patch, the test
catches SIGBUS, reports it and continues execution without terminating
prematurely.

Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>

>  tools/testing/selftests/mm/hugetlb-read-hwpoison.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> index 46230462ad48..6bbf15f78061 100644
> --- a/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> +++ b/tools/testing/selftests/mm/hugetlb-read-hwpoison.c
> @@ -10,6 +10,7 @@
>  #include <sys/statfs.h>
>  #include <errno.h>
>  #include <stdbool.h>
> +#include <signal.h>
>  
>  #include "kselftest.h"
>  
> @@ -261,6 +262,11 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>  	return -1;
>  }
>  
> +static void sigbus_handler(int sig)
> +{
> +	printf(PREFIX "received SIGBUS\n");
> +}
> +
>  int main(void)
>  {
>  	int fd;
> @@ -273,6 +279,7 @@ int main(void)
>  	};
>  	size_t i;
>  
> +	signal(SIGBUS, sigbus_handler);
>  	for (i = 0; i < ARRAY_SIZE(wr_chunk_sizes); ++i) {
>  		printf("Write/read chunk size=0x%lx\n",
>  		       wr_chunk_sizes[i]);


