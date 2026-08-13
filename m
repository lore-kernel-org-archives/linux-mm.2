Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 306E3C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:44:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230A66B026A; Thu, 13 Aug 2026 06:44:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2084E6B026C; Thu, 13 Aug 2026 06:44:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F70F6B0271; Thu, 13 Aug 2026 06:44:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D96526B026A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:44:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 839491A0545
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:44:29 +0000 (UTC)
X-FDA: 85095912258.11.9B50A11
Received: from MRWPR03CU001.outbound.protection.outlook.com (mail-francesouthazon11011006.outbound.protection.outlook.com [40.107.130.6])
	by imf07.hostedemail.com (Postfix) with ESMTP id 84E1240004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:44:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IxCfzg2Y;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IxCfzg2Y;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786617865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7NGU72pZ0s5r1qcjijZtDl4FSLI23k7K1vDP25CfZs=;
	b=g1EK/SLvOEAePTzPZX5HfBHghvKy/DFwK5qhi6N3xVhJbIUAIDjuHzRmLyHaAHNqhwr/dd
	NH5A7etz/l42+P9X22oSwFUIUlOlxFHBP6T6+qK8dW64Nh8DRqM5yaM28mcxAAJxJC9IW/
	ohgm3FvfC9/xPpRjjOdsnKJ9bYLWuy4=
ARC-Authentication-Results: i=3;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IxCfzg2Y;
	dkim=pass header.d=arm.com header.s=selector1 header.b=IxCfzg2Y;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of Usama.Anjum@arm.com designates 40.107.130.6 as permitted sender) smtp.mailfrom=Usama.Anjum@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786617865;
	b=hnwd+JVAwlNgfuDAvVPA9cK2vyPnKd4+QDOzUZc/B0LzSVkmA3yJJfy9a4JyfyUudGizVF
	S2phshtiZsI9k3CjO46SzdJUsQEDBE+99UW5cH6EIPqmx2W6Pq5WtLbvROWNwix6TEdd79
	Jp1E5cfqD9uxi/WCeJ0QjqO63DKG4EE=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=nxzewx+IUsP+XewHKuDcBb0GbJksHLfFor9Qq6GgXiS5UiDnWFY+2AshHh+z9SgkT0QtMkV8sUMEy9wPIthrViMavOL7k9z3PhdBg5kzuhSNU4AtxMVT3zTN7jncqGUVqdSKhiL8Mu/dbHyDmHA1l/VbtrzYQg35V8lEubkZupu/nsxwdJyx1PmoZ/7C9u+wUVRJDr7E4bMuuCILoDrzRj1pm0DBWtrjZBwr9AOxm4qMWzIClhC2xeEUMn51ligkwf7hOkPnKy5r8gan0AgLFpjC+NjAi9lLUlAAqc/e/o4tRdUKIiwKiQQNauADRBTmczidhydiAU6Xj/tWIXzp/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7NGU72pZ0s5r1qcjijZtDl4FSLI23k7K1vDP25CfZs=;
 b=JKvxhuEAvedqpaSXnh6SqN3++pSU6Umy718cjz/wnDG76WPZBe4FUeYJZnFw3FpCKDFw6vE4p37GHprrQweQZSOnMHzuWe3Y4qvcREvyEpDzcBqcFjW+b5gEsH4rPpJ3fcaVg0aquGDbpXa07XA8zwjlRKwoFA4khX4j7AdevxjBgDlPuVWdJmTaZ8/Ybopdh+GOQqKo08BK11ns9ddQLAq2q+1uAT2Q1Jm7ENUkP9isRni+GQd9MMICNHOPNBlnQkh6uoPtVYhN4axUhnN7BWysy5rO474hWivdkTm2Opx7SKDvJfU8kpMzGsOYn6zUhkUsqD1bVN+a6Ghd4bte8w==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kernel.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7NGU72pZ0s5r1qcjijZtDl4FSLI23k7K1vDP25CfZs=;
 b=IxCfzg2YSXWofdGXA/L88ijG6/cLjyy75hGDFPa+DJQLiCXNp9/ndlu1jMkvirWp92Xgy6ebhOmSfQuoK0ruLzOr5GT8uS93Jxxy3uA7mzrTKTFJrZ/IndJuD2rgd1gew6YhsA0yK4l4FI/nHtcRj3b84CdEjjprBKAOzywQEJ8=
Received: from AS9PR05CA0204.eurprd05.prod.outlook.com (2603:10a6:20b:495::25)
 by AS8PR08MB8681.eurprd08.prod.outlook.com (2603:10a6:20b:565::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.12; Thu, 13 Aug
 2026 10:44:19 +0000
Received: from AM3PEPF00009B9D.eurprd04.prod.outlook.com
 (2603:10a6:20b:495:cafe::4f) by AS9PR05CA0204.outlook.office365.com
 (2603:10a6:20b:495::25) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.315.14 via Frontend Transport; Thu,
 13 Aug 2026 10:44:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF00009B9D.mail.protection.outlook.com (10.167.16.22) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.339.3
 via Frontend Transport; Thu, 13 Aug 2026 10:44:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vEOm/07r8Zj3FGT+V/goMPF8/I2dzaHEq4QqsdgA7curqVJvuklfe/Xt71ZZK3zm5nezOeoqW1yvvbXJhQLJgowMl3xRxanzMzrKUx7EoVLG1W3/mzmbW7xW4bWxbo1UMViMHp6b5B7E/PLRGeQVV4rWjSnGSklq/ctiDQljweSBZQirKB9HJuszRniD7riaeWpvMgIqhtzXmedGaOpi4m7rHMXGJltAof/FrdiTs2hfwsWMC1ifpUBEgrHM9HiDyigzh9KqulcAMI7tjrOL5O1vELJ4IYhghz7u8HcDZsFl+kaD3/GK1Fk9ky74JjWY3+y/hxS56gWO0NYafsZv5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y7NGU72pZ0s5r1qcjijZtDl4FSLI23k7K1vDP25CfZs=;
 b=waO1UiRpQaXOAa5CdVE4h89+Xjlx0DxcmRfcLQdQugsOVnCLuHFsJSUSkj7MFb8zIp/cC7upmgK5+5DsgPB0k7zeAWDSXghTjrl2KIUoke7DyoYYnmwNUk8nV5lInWbxyGMeFemOaLeK64uUEjpGAFU5yNKfJWXEbWmFyRcA/cwwZ+Az+HLMylLtMcsTBBigJF6jBWmZMK1kox/VmtZdJYm8qakiI3186SB/9rT6RgfW0Ge6f/rSj+OjdeAgZROOJYrg4KEPfN3fImrINetL9d3fg+7nVCXcyptzJNOnVZs1FqKQ7MHVt6PzhDwWWMsO7rKqTRfxkbpIgcCo3WXing==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y7NGU72pZ0s5r1qcjijZtDl4FSLI23k7K1vDP25CfZs=;
 b=IxCfzg2YSXWofdGXA/L88ijG6/cLjyy75hGDFPa+DJQLiCXNp9/ndlu1jMkvirWp92Xgy6ebhOmSfQuoK0ruLzOr5GT8uS93Jxxy3uA7mzrTKTFJrZ/IndJuD2rgd1gew6YhsA0yK4l4FI/nHtcRj3b84CdEjjprBKAOzywQEJ8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com (2603:10a6:803:80::16)
 by GV2PR08MB8416.eurprd08.prod.outlook.com (2603:10a6:150:b4::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.13; Thu, 13 Aug
 2026 10:43:46 +0000
Received: from VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4]) by VI1PR08MB3421.eurprd08.prod.outlook.com
 ([fe80::e079:6bd:fbe0:89b4%3]) with mapi id 15.21.0315.014; Thu, 13 Aug 2026
 10:43:45 +0000
Message-ID: <1bea357f-33ab-4684-8ef1-dfb2038938e4@arm.com>
Date: Thu, 13 Aug 2026 11:43:43 +0100
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/5] selftests/mm: skip COW tmpfile cases when
 fallocate() is unsupported
To: "David Hildenbrand (Arm)" <david@kernel.org>
References: <20260727095225.372655-1-usama.anjum@arm.com>
 <20260727095225.372655-2-usama.anjum@arm.com>
 <82530a53-b4c8-4671-b55a-c7ef95e06dda@kernel.org>
From: Muhammad Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <82530a53-b4c8-4671-b55a-c7ef95e06dda@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0484.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a8::21) To VI1PR08MB3421.eurprd08.prod.outlook.com
 (2603:10a6:803:80::16)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	VI1PR08MB3421:EE_|GV2PR08MB8416:EE_|AM3PEPF00009B9D:EE_|AS8PR08MB8681:EE_
X-MS-Office365-Filtering-Correlation-Id: d23c9987-ba27-4266-6d8c-08def927d47f
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|23010399003|376014|7416014|1800799024|366016|10067099003|56012099006|11063799006|4143699003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info-Original:
 5bE61nI0HUUgGzJuO/S+oOSBBn/qlo342pe2/qjAG2psziFLYQmQKeBV+RXWej4krHHrwnQ833d71ih+6O9CXZ+J0eYrE6zy/GZI5/Jxx/+U5S3EMi/TpXi0zxhuMu+Bu3PLgEGHUN8sLXjFreYkE90Sb45q2t2sUlvHhctaOoanqNJpPeHon8bj7VLeEzl6oxAHNZec5H9vt1VTuNfAcWrlWjXL1Pg71gU15UxnK8883PF5isMhV9GraG8NoklSv8fpyt8UTReZTGxS7VZ8N6kVkObNyDQWUNVqxX18OcOT5yR1xPPp92gZ6/xypXm3WQshN+aouWNwTY7vJt4lNwDIOcHzg/Ocxry0OziHgX28yB0Hw0N47mX6udz6aatWtmXVBeCMxB+LoK5yKYiYoVMaggJ4PqdX6xZQZGpHA7Q0HeRliNu3C/V/X+ZHkm/VW1CvA6hgvLnsxnN/xYIjkUauEGBaVg7QYj0uxfpPUAXhdaqox269WV47Kf+XlmsO/6mmhxYKu5VjSwgi5NOl1L6HFgoToQcAAiq1PS9K1adhnGxOf9DoywHWtqvaQq/aNyCBw517pS+nYgmyL6vwE6f+cQMKQt0gpx26n810FY/frqoEwWV1ukb0wYbAr30k6UZElI8Kk63HI9z/3cTwKmh17NhrIf/sCsOXsD2ITDU=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3421.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(376014)(7416014)(1800799024)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 e2h/FZ4x3Vw29sM7AxDqjunCiLkj3vFZxLH27m9KAwPlurrB4B5JnDsi85C1zho/Uqn14FjM1OeYwQ2sqplTK1b2i5zOAmPmEFOIKdvKjJoAHvjoRWMWWX7eFVR54SFi3uH26nktitAOultCfxH3RKazo2gQTEVO0Wnu2SN3zIpgg3/Gwwgsx2X8IL/Ai6apxufbhgGQo9i2UpFJI4SRjdohCEZp8MyhTWtAOKJGqWWCa6ppZRO+l8bFy5irOgMiBMnB4kpzZpt3sihimfgUdDgtU7vnM8xEW7L1v0tvLknWbAKLdHF4VluVBPCm8GhbjHzke1fz/kLtEY4vJPxpDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR08MB8416
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	65b1b1cc-bc4a-466d-86a3-08def927c00d
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|82310400026|23010399003|1800799024|35042699022|36860700016|14060799003|11063799006|4143699003|56012099006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	KAUgKWSOK9stahHGES6g2LVjmozkxly0VGS8kl19ytui3X+1Y/D3wCzI6oosemyFLfM5MywcqB4ldb/KXQ58z9bLkfjdTFkxJYnf8lPAd3wrZ+4F5Rul+vOrV5Zmhi5R5PVJYFIIIqjMDM6Ss+U8tItBz/pBe3L65lf11cJhms4ea8ZANf5NERlf/mQQ0Cj9fRiGQiAhH7jk4m4RwDUKxFOHq4tGOkm6eyPWH5BXx3gP/Ne0kvVpApWObKUvyF1zndPNgkDfOUEeFgFD/h4rhIdWtVjng2/KnXOdgw3MhHHridrNQk3bZecQistpA54s8WHrSeURfwS6W+Hz81bNnKuDtlxNfETbk6fKbXymKQhRcNF8mpGQl93We+KwJjOeBJ+2sfsFYV4N6gAAKlqN2tufeOi8WECIh2xsdQUBnPcSvDYu4PUqDFPUwnhYTlZZ0j9YAO3hhzTJzH+GMCviBFSAVqlpCB4gomEuT/rMupH4Vf06Nw8dp5g0OplV+HiopXtIWFkcGZWojL1r06fxRNoJ0MR3QWoYkNzbzNzmbrFvCQXLTD5tJ1DIB8TkhSH459ApJnTDJw7u15JyHJsClxmI8gKXC9RqcC1aouBWuL32453dflVKJbLeDlCIMxISdkWzjhUxRTZ0i7nPLIBSo23aa+FDQ/drOO94NRRyQExlJXww2LDaYk5f1MRkYSX4aIlf+pnOQLi1EBV56iTpCA==
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(7416014)(376014)(82310400026)(23010399003)(1800799024)(35042699022)(36860700016)(14060799003)(11063799006)(4143699003)(56012099006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	ayExkWy5SrzPHTHyNDrmPsDOq/eMic2RxRoHNK5MK/yP/k2u4ylr80idIfErLyYIjV7U/AFK5m7kc2s+I2qD/JReHhWQ5+8WPpcG8JlfApSmjHYH1G7Z+V2GprPgK3Vfc2Y9sVvlodTNneqtRlIvRWW/EM/UBDdL3VADDFVBx84fcjrFNv83gz1jdUc/B76UfW16JxCxyxoXgJMdoGW+GOMQR25aj1F/uN8KEv2YVlrfhQA4MNXXja3ROvPb3I+dLR3mVYbbfw+w4Yx5BWnyEB2WRnsO8A+ldTVoFoMFoldVtmQTKl85gdOPCeFRDmbeW6hq63aVmO7La7p1k3CrjpQ5hsaemwifmdUuCTbCX/Ti3tXYwTOd92ncZBscJBbgfxQutaEw8DEl8T9VniQ1sBPxKFTiKUDUArrIYnju1/LfnE+unwMq0vR/kYpgUB6C
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2026 10:44:19.6419
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d23c9987-ba27-4266-6d8c-08def927d47f
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF00009B9D.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8681
X-Rspam-User: 
X-Stat-Signature: mnsse9iwe16qxew9x8m8kq3nzqot8nei
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 84E1240004
X-HE-Tag: 1786617865-254445
X-HE-Meta: U2FsdGVkX1/kKVLLeHJjUHgT/9vXjd96N+pffW/kItCbPF3OW6cEs2QqimhhN0jRv+/T+dpA6blggMVfDPlQKVZJMhfrvAPhzTPU1JjWcBk3S92QkpuRDovN7703BKvT/pOTvwPQXGYwW+N5toTZapn2POH+X4B8S2jUy1hL7IW334k+KF7ksDTXJcVFapC2h7OTMhc+hjJKejQ1xpJGERaLBYcRmVQZmhSSKC995phoHGlNqjM3/tZ8zVLt2NVLSm0HcFaYMi5DzOZhkS10FwU/7mlowEIwSG01/dJS4pEXn7NLqOBg7RkeOIfMJo7r3L5iWamNAFWRwJfgqICRdljMx8MehgrCRRGcFn0x4JD9IbR6ub1/R5Nrbi+VRm5lqUAzM5O6j5gPHS/6pBEVhJVC93V1lFFfLyHGzKF7qMxVLrojtL5wKyEgsKsT7r5iRXknFmVMnDcTRoXaLp6rWTVp+SEAth7UYod/BtHrNwTIeWSQJbXst277+twpd0I8b/YukopmIwROefL2tGVQlKUkWfScNsxO4noilRBZQGieK+KXzG60ioADn0JB0/IOrzGH3+sZWkjtYwl+OyA+KHWjNE3OEDQ3L8IRanUoRGcZHzTtr8PKk8LWsaaCckDl74WBlAgnwnFZZ++NZwuE+9xOTc83rjs2PE5A3QKldbDar4DmqRVKmU021pXaGbzmebtZr6WE3LPGlv+fKgP6/8HPxR0wblW3Th8ESOCi2TMGtQ1vIc5QqSTGR17DnKrz8kXHnnM6Pa7wBx6q3838nRDE03pgL0w5OJ6gIGkQc1F+rEArl/h47DMol2iP7uwBnhXU30aT1raFbEPJR8O5dzsWo2sdy6FOetgDlQwKvtWLtkyf8TW0r1fTCTjnpO2VveD0xGWpD1US1nczJvAuGHEt58iGcvIG6p7039CxwpaPHGeWGM1OC0By4eLTdbDfTyix84tpZbnx/O9CKCX
 PnuNVtaa
 6QXRgwXtrmVJykvihGCLgKnF4vMomH3aCHjRnllMKGK3Ehko7WDudcdbGOv/2Z3T3N8YJeM9AT4MXpd4ASqQV7Rl41BgQA/UHYgKTNV2qVPIWydT5u1HrfUWRxnjmWWSdsQlAkXLwJipNqfe9+DnddwVPu2/32x/73smuUQksgL11XTjCQI3O/4wWo54PEeWgncjFs8+R0+DFWQtPcF7HOIEA65iTk2VKKmTOrCGnVX9J2C7CssprDYdOXIfcM94NQ+vN8bS9ZA5c9eyhE8dTJvjo4B8kBe25bbpNHz6hHKLt4H5OgqS1KWefl5cZz3Z2cKzJXYq6rs7wMWLS9r/4lTa15l6SKmtT4zSgVb8jHlXQn/UCCQL8qdOCr1jZxlUw2hoGPBi3gi119vOxHH2ZWtsU642uPEmuicLfsVB2S55PBJavF18TD590ZjEEpoeduElry9x61Cv0wiZuWMddwdgUswU1k2F/49ezVr83tl45BfX8CCY+8nod3PbAa1N2ue8gAAPWBE+72waLrZG/8CArkjLYmqQxRSF+AvoSvbFH7q21uaC4dsQA4hUR50IlnCpvfJKzrH/2KvHF9PrnQFMfBSt6rzv1hCdsanICN4DienrP0IUH64aH339TczMawknq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/08/2026 11:20 am, David Hildenbrand (Arm) wrote:
> On 7/27/26 11:52, Muhammad Usama Anjum wrote:
>> The tmpfile-backed COW cases allocate a one-page file with fallocate()
>> before exercising private and shared mappings.  When the filesystem
>> backing tmpfile() does not implement fallocate(), setup fails with
>> EOPNOTSUPP and no COW behavior is exercised.
>>
>> This occurs when the temporary directory resides on a filesystem with
>> limited allocation support, such as NFSv3.  Reporting a failure adds
>> noise because the test prerequisite is absent rather than the COW
>> implementation being broken.
>>
>> Report EOPNOTSUPP as a skip.  Continue treating every other fallocate()
>> error as a failure so unexpected setup regressions remain visible.
>>
>> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
> 
> Worth a Fixes: ? I think so.

Thanks for reviewing!

Fixes: f8664f3c4a08 ("selftests/vm: cow: basic COW tests for non-anonymous pages")

> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>



-- 
Thanks,
Usama


