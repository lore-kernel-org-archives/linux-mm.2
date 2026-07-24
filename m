Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8710DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 11:54:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31866B007B; Fri, 24 Jul 2026 07:54:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2D96B0088; Fri, 24 Jul 2026 07:54:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8864E6B008A; Fri, 24 Jul 2026 07:54:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A926B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:54:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9744A80392
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:54:40 +0000 (UTC)
X-FDA: 85023513120.12.64CA3EC
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11012009.outbound.protection.outlook.com [52.101.66.9])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3FB1D40002
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:54:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o4uQYjnN;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o4uQYjnN;
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.9 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784894076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iKjpBTCiMWcbj1+FdIsuEwN5aq6ahPUCYGLZl2Kf83U=;
	b=5mHj7KR4B13CKuK9BBRM5YIQk1NlGk+JVBowfDeIrG4D7kYKTjyF+rYFLqwUuVw+5+VGK4
	fYD6YKqO9TkclSmgJ2UgsaBKfXyDw7k18Ae5AESTUit35e8H8bCBJrNdPWihhVLwjuzneY
	c+s+meuzxvMf8NCO6jfnyOnGtWF0zCo=
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784894076;
	b=iGcatOG/BVg16jN+5nCjtA3cs1MJPycPPbXtbfz80vmuF9K9viO07xtN7O9QA8WjDp6Ajf
	RCL3SXvTbGil5UHzf4CTB+B/9j7tQ8HwOGaNDGsPNFxMRTdD5j0E/qNLM97eENWuifSeVK
	VeF8ugz8UymITBu5DaAtnQErVKWTQhI=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o4uQYjnN;
	dkim=pass header.d=arm.com header.s=selector1 header.b=o4uQYjnN;
	spf=pass (imf12.hostedemail.com: domain of Usama.Anjum@arm.com designates 52.101.66.9 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=bQ7wlM0xnoB8ikNSRsUhNjnU3iS3zBQ29vhqZt1kQumTvmkchEzZA9oTcbmz7goq2P/X3l5m+V3FVWjWd/uAtXhcShqfL49U92NR6WVQtVyfqAR9r640P1l5eVF4qr1/21mstU2S/zNNEk8vXPE42vKxXAyu51D7wy1eqcr2X2sDu0hg5zZ67ziElM3z+vza+6q5i7YeALNEUootJjte35oSJ1hDyb2LcLBxDAm1uhYHenu+Yr/UtsxkzB+z6cXeg/XcU+fK2bVeT29Cbmt525tda2PP6dtI6gYMNvIqFTza1yyKF0JXTidEtP5gDRu5987IUQCvz6ImDw8iLfSeFQ==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKjpBTCiMWcbj1+FdIsuEwN5aq6ahPUCYGLZl2Kf83U=;
 b=CN0/Iy16eZt7CZ+eXVRKYHK+AyX9udZBc5DwRgITvUiIRc1gRfRXEj5Mj7ESKOSOhen6itynZvRY5g1bkkniDjsKa09atxm3iO3K6+U56m0RzjJWbmd3GTNbSXLlrdP5dg7rXbMMMiAwVHOHAZ/DmWSOcUorIOXl3uacu5fjIBFZpwffz/5xe9Vy60nHFhdewUw8RJKimoLFTKojVu0pqRCE5oRhRVL+WH4GHZBsZ+OI2VHB6J71as1ikjbXxTtY2IZ7N1ddY+Y6RuFwrO6089WJK9d3lOUYbFqaOoG0uaTq/3XuabBoEr75sTXNrvIQ5UcEkXqZ2U5GKmkFLhj9+g==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKjpBTCiMWcbj1+FdIsuEwN5aq6ahPUCYGLZl2Kf83U=;
 b=o4uQYjnN1JhknLRW0veEPDSE5b21i+o7nmLlEMCVA1lXg73ANEq4yIbQg0qocEOeHY25CcyYnNOWd7r4aQOHvNSu3FXygSOOv7bB3ugFe7/IfdHRS9/sNvsp2GPJxve/cuRfhSZlvR1y2NVInPTETiZngz9TxMlS5bgRRGSt2Xc=
Received: from AS4PR09CA0029.eurprd09.prod.outlook.com (2603:10a6:20b:5d4::18)
 by AM8PR08MB6369.eurprd08.prod.outlook.com (2603:10a6:20b:354::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.11; Fri, 24 Jul
 2026 11:54:29 +0000
Received: from AM3PEPF00009BA0.eurprd04.prod.outlook.com
 (2603:10a6:20b:5d4:cafe::9e) by AS4PR09CA0029.outlook.office365.com
 (2603:10a6:20b:5d4::18) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.245.11 via Frontend Transport; Fri,
 24 Jul 2026 11:54:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009BA0.mail.protection.outlook.com (10.167.16.25) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.270.5
 via Frontend Transport; Fri, 24 Jul 2026 11:54:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=caDIsPDsqXl3Bk+1HwO9FMgc/sg/U+4SFsZRTQZXwJjdXI7OA/Y9PvoDE/0eUiX0Qo1QqBiLCVXyMv8nN2F2BzqiF7mLE/E1PWvziT5ShBnqLoecSygRucextjP2ib6MdrXehHOL1ebUKEY4drSvZ1Fm803kD2ShB7iWJrKch+lNoQVO2pz7MNCJEbv3iavd+qlHWJJdpzHoim/Rbq0oILszOq1Pr612xfj+OeoxYxf3KqzY43sLhc1FnTXRPJ1eEE+1zkj+y3AEju4DGZ4GexQ104GnJv7V4LzJvmCLNkjxytZ8LKilKwUGLgf2qWBA5aTk0MjFRzmSFgxDoU/BAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iKjpBTCiMWcbj1+FdIsuEwN5aq6ahPUCYGLZl2Kf83U=;
 b=W2sB5lYBWV8n7HT0oDJrvydLexNpnrH9TI4oxJ84n5LND53G7z7BLQ7u1j7a6cKMxAnhwxpSqE5MtVa4N7Ij0t4OudgdtYvjMRd1Ge5wkguB2WiB2UTRpvRWv8Q1M0SneCa/DQpSCLih4NHoT0Ptzd+6hoewtFD0dc8IfGqSmGYShwIaWP+PatgITrcTMkDQWnhfqYtYnElAvs5AsyK1EDZP4O9eORDbRI89hsf4GuAUZZpi4ZUH3gdYlwAOXIAK88pcagh+0qdsMK2l+KwT1iDQF7I694cex8sDVB8o2z0tHyk+ejN38ikgHIErrRAhfrwd492hs+bbY6GDiybtnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iKjpBTCiMWcbj1+FdIsuEwN5aq6ahPUCYGLZl2Kf83U=;
 b=o4uQYjnN1JhknLRW0veEPDSE5b21i+o7nmLlEMCVA1lXg73ANEq4yIbQg0qocEOeHY25CcyYnNOWd7r4aQOHvNSu3FXygSOOv7bB3ugFe7/IfdHRS9/sNvsp2GPJxve/cuRfhSZlvR1y2NVInPTETiZngz9TxMlS5bgRRGSt2Xc=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by VI0PR08MB10392.eurprd08.prod.outlook.com (2603:10a6:800:210::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.245.10; Fri, 24 Jul
 2026 11:53:24 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0245.009; Fri, 24 Jul 2026
 11:53:23 +0000
Message-ID: <a3ed6793-8285-4043-a0bb-10bd3890be19@arm.com>
Date: Fri, 24 Jul 2026 12:53:21 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com
Subject: Re: [PATCH v2 5/5] selftests/mm: retry migration failures for the
 full runtime
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 sarthak.sharma@arm.com
References: <20260724102431.1199519-1-usama.anjum@arm.com>
 <20260724102431.1199519-6-usama.anjum@arm.com>
 <15111e85-4143-476a-830e-9f7d47cc236e@arm.com>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <15111e85-4143-476a-830e-9f7d47cc236e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0493.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::12) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|VI0PR08MB10392:EE_|AM3PEPF00009BA0:EE_|AM8PR08MB6369:EE_
X-MS-Office365-Filtering-Correlation-Id: 92f5904a-d25b-4d02-9384-08dee97a515c
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|23010399003|1800799024|366016|921020|6133799003|56012099006|11063799006|10067099003|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 chaSi+wvlxxw9kbUH9Tn5XC4sQIOOOX3rKwCtQ07YtaFp/SRU9x30ilLvwtcyUkUlV9mLVMvnt/MUQT+MkJ20WRWMfvoNCx7vbewcdCYxkUV1NCk4Sucu4+Vls53Sw8eFbPK6aUCxKEhgRPFq/562e7CnnZKNUOT5eIB7vH0ZLQd6mhs7Go5QvOZ0C4XgFNb2bDToXl2M7towNGFtNHOr4K8OfznYnH5VbFNrOwhmkwPkbg+usFKrvsF8/jajwD0m8CoEKVNM1TACfZbaaJ+uC6IGZLP/3Ngc0+AOcxAx0JHshp+6E9yg7oYv6hl5m0aqynWRvNlXXZVtZa7GRJtP7tmSMmDhBphXRWG04H00luzCOyxiq2yZJxDKqaPGMXpNDIAW5B7lECEI0NIBPOgPFbR5+TBmSxuyrvF3m7LIa0kj3NnJJmaTzz+j9XDc9UAmjflsayavTiaWXP5yuD/BgxmL2qmUgrG5ueqRokDM4Ts8nZEYVb6+Z0z7Lc3l7OQ4uLYCWWm5CfI3KvOE52RILvpRbvxC5TURpETHw8sTwuiaLDVjZN+63FKUYHVYUPloQXWrw8iiNou2kU/tb9KerzTOoSMVEPdpVY+9YD8VWvGacH53QUBIn15uBo4hhZ/ABsT5hVZ9cUFgGI/Yn2Rk5YUCTiMvHgI4UInGn+Rt7rYrspFLmyjdo5awrjxn7ANN6Vp6CZyxP8aS2ZhO3gfZQ==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(23010399003)(1800799024)(366016)(921020)(6133799003)(56012099006)(11063799006)(10067099003)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 W7nlKkMFKkRipMaXEzKyKBUSa+U0JyJyH2EwcjlNPtskejn2mUcZtl0wOacc9S2RxriN4xddxCZW8hCiFomxGqHFCDMpWivFc6/kGDngMexy5EQPa6toT7AX3RhEoXdw7QUwxOlUx/pTOygIKwrXuEU0VEwt9Vd1XMnGRZigKEQurHp8oWR5eZuFZ8byerUyZI9H+1sfy4OG+IUF2DrXIchaDoAcwgjAMpRJpxi9ukeWl66DvV7plDxy0ddrdVm9cJF6Cw3/R6C3fbq1wIiY0kps0b4hM9wBK9OFOe1T2jK704RjTYBcZ+i9nGEUQLh5GebAZprik3+kgmv5gEqA9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI0PR08MB10392
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	708b95d9-c903-4d23-0148-08dee97a29c7
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|14060799003|35042699022|36860700016|23010399003|1800799024|7416014|376014|82310400026|921020|10067099003|11063799006|4143699003|56012099006|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	mbuRzaIh3pOLBm+2KboJd/kJ7V67fA1Owha8/clJ2Jp5bmOCxJOtYbl7OnXxdKYSg+0b8VMRa18gonOG0+atIQuLxlLhS1hTtRrLubOGpVbAmgKHj+Iv2VC82tNoT72MtiCitHVz2r/1+h6XWfA4o0991gXsppwnNvQBK59mPcK6VOgfVIeH83aS9g3XDFec0Yh4po+UxrXJQQ5+XMxNHN5ZaQVklPJFG57NyODh7GnsoVNlWb5cUio7QXUvJj4NnIcVtqUbKZVLEfROM0tCzhQ+DA+hi10H9ZyXuR9sqKk9/TaWv4ofZMki4w11yFi4hNtJvqT2fnJRx2Qvp+WT1xSz1kki9QKPkg//jsg65PTkAID9hhJ5ecLzrbq1/6Ryj9W3to8pz3f2wWXCgtSE9EZY3xP4SDyyoClzfE8BtfGpxmTH2Lz4Yeo2zEHKTAaXNpvB5dqfsv950U3U7GNFwVQaa3uoXdXvdVK+R7RLtcJhA/0X+EJR1T/40+meg9K3784o3xvC6TWAnd6m32F1kaZLqQ11+dFOF3TdDdLOvmO3XBeRGCE57iCOAp5ObydJ6Kfl6DfW/LQRWWPTTn5cPVxUvfPZco0+8BRYCkJ5WgfhZU+owq9JoPwakdTd7j+S74XTP4sIkyQIQkoz/m54G3hiJuBJBs7hJb5/9FLOPQQ6HBrBDqlu3a+bH5P+lFrcKw0WlAqhgWLR1z+90gAsgkUlFP8OjbOZEWsnxZohy9CpJ72FArLYpVHdlWjA9kDb
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(14060799003)(35042699022)(36860700016)(23010399003)(1800799024)(7416014)(376014)(82310400026)(921020)(10067099003)(11063799006)(4143699003)(56012099006)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	XOKiW4E4gU1Zs4zMp821pzrvrm68+Riw3aRLkeTPjehuF3/FM1tFwfu3nBfQfWTwmVooVzRpKGxHqsPwljSDhO4pSx1psDAriqRXExACrSyTWhIMD9fRx/qNQetW/aDNXrjOmqRAzXPkHJyVK+tL150RG29j/FYNIDNbkjwYJ5Yyg+bW2eBWQXjbiKIbIJGuXhybxSYH2Ng6Vf+z6U5ryAGTwIW0HdYNaYDl7vKzT1LVA2hLPg5Usjt6Dxvw5sjuTXzAYQ7Z7Fu3rbjvNjssIG6iuIqJEpnunHUY2pfpoxVqiBS+M+e+6yjbH+JE38NEju+dYCWouq13tUwIYVbK7HKnZ7blq2pt3Qx9axZxUhDxuahWX+YfiaGn9tEOKZayHTslp/VAYCAHFs55kTFe+VSAM7L0rt7RbD3bNPLusibUC9j+w6JbsoppF75v0enV
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jul 2026 11:54:29.2666
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92f5904a-d25b-4d02-9384-08dee97a515c
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009BA0.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR08MB6369
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3FB1D40002
X-Stat-Signature: cmrs9i4mehz7pubcj34g7eb3zspuhpb6
X-Rspam-User: 
X-HE-Tag: 1784894076-979602
X-HE-Meta: U2FsdGVkX1/OArhIY/LkJrQwXYNVBFoYEbPXNfWLLVuenFVC0GiCr8YfinPOE3n0BRZXXz+cLhSl+4lXlDVzMVzDQHCj1VJeZ51A/PnnKF70GJJf3KarR/yUPpiz7oNiU88hQfqVb//0wOwF4Rlay9KfKzfeEEuB9OkbUOw+fnrL2Cp0i+ptyzMQUqHaIT57r3IjTgBnDyx32cKGop039GpM/FjnS11Qq67shKNuvMgLwZxOo/8VPEJ2A0Yv6AUkWo9TC6VkPSwgQ7ye7cgGBuRZI+Zrrvjd89M2CHO9OcUNXUJDpBgTEzT027GcWZ+e06KRoCVCNrDf/lorbQWmcou6g+oaQh8TYmheQfeQWa8/OWTprA2fmN9hXO00ODEk//WeOKUTxGjofrVrg70Re0xSqGXGQ2ekmZKcwaEeEI7qkjei22MrDfu36nj171gcQ03we0SNvlZg07LFqOFQQ3vQIP3mGE47/7RLVuzES7i0oGAq2+AP6zOdLDvTtyuU3Cm/EHIj2u0mVuEE81jQITaGrEQWT90B39uqLuT8lU+8WVs9qcxuwKOZryMcUsMe+ZfvYAybxQ4gZ4+hZgTqbbiUyXdO/QvNBruUr0oYRiHFrKa33ucR0wwPoaEJHSYZgvM23Z80c0t+9MFu3XdpkL+a0zWEPuql1G2UYzREFtrCbXLhcBSr2bzcMoF544TJxxayT6sFG2hxWXkABxruw49nyxibcFV8bJLlrW3GD56L3E2n+nXsrCQ36XpQljWkaKA4fusCfMp/rlKaPdVF59Boh1P+iiHxKmE5JCJzjqDPpERZLIFZCgBR2uXoul57OTIfquG6b2FlPJhrpTZ8XcBOa84X/BOzWPutIPWqTBfZsucpkI/onW5Qu+jgmLwGf3Kt5HcZWE8YDXc7hZvqAcrfPGQSh5CvARgOrQbbLVUKlq0ddbpIOLHnKOzISDULAYoJzP6iq1gM1nWH4gP
 nfh3KUjd
 NUlXWDFbNvdlt9UePG0ETkgEcMNs164YQS9QS9BlDkRDRYwAu924PxUtG4omsSCOYZ42miZ+6J8RH9IK4bWOZ2JnpmtmizmXfIrdQlcmZy9e32hi/Fwcnv2rMzfwhswBTPA354J8eS1Dt4JQweZl/IlHMlfVtB7YsiVsvO3WzGgsIfYjwFE89XI+tWjPI0KvpFphvrMXxJZGQB3hUZjpY3ir/YMLZ2+5xEOTiliJEzfwVNhvkGpeJ32RyOQXjjuUabSs1WpOiH62bcvX/N6Um7w3cy4U9o3JZOfR+ye602tiRkFjE/NlSGyieI+nbnEreUSEVJDmmtCNhF8fH23bNWIiBC0ahfe2UNaFKjwUBd7peSA72rPiC6bnX3Ukoh8OVB7zYiSpaNNSRt9D0TD1zBnz1vx3tBCo/JGutYcdJU6ooAguU4liU/9rf7ieSAb1Clt2a3g+dMnefylhpCTttpqCobM7nMVZij22wVc3ObF4zDE0ejkDPmAN6NrNOWQidoYclHp5GtxJ2O1Vcw1MUNxjqaZwWxKv+BaUze9WcQh2an8dYxqfLqhm62fK0gNg3+4ZYOCU5yB07EC25qokgZ9WQoQseUmxStOXOkTw0jitaM2o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/07/2026 12:46 pm, Dev Jain wrote:
> 
> 
> On 24/07/26 3:54 pm, Muhammad Usama Anjum wrote:
>> move_pages() is best effort and can temporarily fail when concurrent
>> faults race with page unmapping. A busy shared-anon workload can exhaust
>> the current 100 retries long before the intended 20-second runtime and
>> produce a false failure.
>>
>> Use the full runtime as the retry window. Since the initial page location
>> is unknown, require it to reach both alternating NUMA targets to confirm
>> that cross-node migration made progress despite transient contention.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
> 
> Makes sense, but see below.
> 
> 
>> Changes since v1:
>> - Retry per-page failures for the full runtime
>> - Verify that both alternating NUMA targets are reached
>> ---
>>  tools/testing/selftests/mm/migration.c | 39 ++++++++++++++------------
>>  1 file changed, 21 insertions(+), 18 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
>> index 29f7492453d43..4d55a424058a9 100644
>> --- a/tools/testing/selftests/mm/migration.c
>> +++ b/tools/testing/selftests/mm/migration.c
>> @@ -7,7 +7,7 @@
>>  #include "kselftest_harness.h"
>>  #include "hugepage_settings.h"
>>  
>> -#include <strings.h>
>> +#include <string.h>
>>  #include <pthread.h>
>>  #include <numa.h>
>>  #include <numaif.h>
>> @@ -20,7 +20,6 @@
>>  
>>  #define TWOMEG		(2<<20)
>>  #define RUNTIME		(20)
>> -#define MAX_RETRIES	100
>>  #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>>  
>>  HUGETLB_SETUP_DEFAULT_PAGES(1)
>> @@ -110,7 +109,7 @@ int migrate(uint64_t *ptr, int n1, int n2)
>>  	int ret, tmp;
>>  	int status = 0;
>>  	struct timespec ts1, ts2;
>> -	int failures = 0;
>> +	int success = 0;
>>  
>>  	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
>>  		return -1;
>> @@ -119,29 +118,33 @@ int migrate(uint64_t *ptr, int n1, int n2)
>>  		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
>>  			return -1;
>>  
>> -		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
>> -			return 0;
>> +		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
>> +			/* Reaching both targets verifies a cross-node move. */
>> +			if (success >= 2)
>> +				return 0;
>> +			else
>> +				return -2;
>> +		}
>>  
>>  		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
>>  				MPOL_MF_MOVE_ALL);
>> -		if (ret) {
>> -			if (ret > 0) {
>> -				/* Migration is best effort; try again */
>> -				if (++failures < MAX_RETRIES)
>> -					continue;
>> -				printf("Didn't migrate %d pages\n", ret);
>> -			}
>> -			else
>> -				perror("Couldn't migrate pages");
>> -			return -2;
>> +		if (ret < 0) {
>> +			perror("Couldn't migrate pages");
>> +			return ret;
>>  		}
>> -		failures = 0;
>> +		/* Migration is best effort. Try again */
>> +		if (ret > 0 || status < 0)
> 
> old code wasn't using status, so why now?
The old code not using it does not mean we cannot use it now. ret gives the
aggregate result, while status gives the per-page result: the destination
node on success or a negative errno explaining the failure. In particular,
move_pages() can return 0 with a negative status, so checking it prevents a
failed move from being counted as successful.

> 
>> +			continue;
>> +		if (status != n2) {
>> +			printf("Page is on node %d instead of target node %d\n",
>> +			       status, n2);
>> +			return status;
>> +		}
>> +		success++;
>>  		tmp = n2;
>>  		n2 = n1;
>>  		n1 = tmp;
>>  	}
>> -
>> -	return 0;
>>  }
>>  
>>  void *access_mem(void *ptr)
> 

-- 
Thanks,
Usama


