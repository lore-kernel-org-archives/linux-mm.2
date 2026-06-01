Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33B6CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 06:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADE56B0276; Mon,  1 Jun 2026 02:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EA46B0277; Mon,  1 Jun 2026 02:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126FA6B0278; Mon,  1 Jun 2026 02:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F19956B0276
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:12:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88CCC1204E1
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:12:16 +0000 (UTC)
X-FDA: 84830323872.24.1443A4F
Received: from DB3PR0202CU003.outbound.protection.outlook.com (mail-northeuropeazon11010019.outbound.protection.outlook.com [52.101.84.19])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6710B20002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 06:12:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="mO/M/LZV";
	dkim=pass header.d=arm.com header.s=selector1 header.b="mO/M/LZV";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf13.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.19 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780294332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FIFhD1Pm/OLK1rocMnaCyE20TqXRGC+76pWX/JIJ7gc=;
	b=zN/fJx13b3rJsQATtn32gOATn04I095dFebdeyNEAqiqvNfdeEluin3GdH/JgveB6NrCWT
	FGsOxQ3/V8EE6m+Qe7ApRpzpYiymyaWZhD5TxLDaaHbPAC7t2TKtX6UAbCtXRGmrRIBU+7
	ZUxgo+kB0wTC4d3rf/XvXyCgtKssXjs=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1780294332; a=rsa-sha256;
	cv=pass;
	b=SkFp3saRJK87qtpT5tSU2DTUUvGmcPNtv4eCS7eeISzsuHr8BVXVnODTdEPOHbU8fR7lTZ
	zHp8mNadad/DmaonDRTgSC2hZW9OJwae+wVUm5Sdf8v2LcYMesNCFyQw9dKPQWp/FZmse8
	JdcTYa7AFX5gcW0wMPqeUJNAxH/H+mI=
ARC-Authentication-Results: i=3;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="mO/M/LZV";
	dkim=pass header.d=arm.com header.s=selector1 header.b="mO/M/LZV";
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf13.hostedemail.com: domain of Sarthak.Sharma@arm.com designates 52.101.84.19 as permitted sender) smtp.mailfrom=Sarthak.Sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=m5ctUeBQwhdCiQs4ZmWfyRo/ZG98dRMSkwESgFZIWE4UtrzFHjGgwN8X/1efh4oh71uaYHXeLvu9MYMrBykIkmvm9U1xRARYKdsg85QgY2WVLTj6SUrusa9ynSbHV2kyrtcrCVQYEYsaiYg8iM7bHSPsivxtmhH/B/mTTeuFUsTeZ5ItHwcIIQmcCJOAGxkAMLZnJyTXTis0EJQg0TkUau6wuqZfbgYfA9QdtGzIIw8jpeUWUE+3TLtNAWW8rObMnxHQZVFp0jChCSkWS7LjbJHWU4GpaKmtG/yH008x1TbDUY2ls2JpNO7si9YBIGYpo4wKo5iP+1UPNgfkaC2GAA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIFhD1Pm/OLK1rocMnaCyE20TqXRGC+76pWX/JIJ7gc=;
 b=FIZMaYI1jX6EpOmT+oJFbqNWHVJ23auT+WxI6iWo3sbU1siY87XYKhqyAXRkvZgQzTbxF6GuL3+IRRuSNBfJy5SsklEhTk/fbDbzpbZqr2muCKl1Tai5x8mgZunUNzU+R9r1MkeEkkmVEV4lH326wjsA+4LOy6Ij0nRjfpapVk+MV+zWFKupYBZsN+rnX3JNY61YblpxmQLjITiHCgJ0SsWlMeFsp3Ce8x1wE55MxWwp2SyF45EH27iCTchvUvpdXQhuMTZ3TQTd15cvtIMBddW/KA3p2A77QnU4gVTebgVNt2/2UHxvgCiYXxu0i947TRHyvp5pOpoctqeu7wPaww==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linux-foundation.org smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIFhD1Pm/OLK1rocMnaCyE20TqXRGC+76pWX/JIJ7gc=;
 b=mO/M/LZVg3610UbyTWFmR6/cS1Ho87YcTkReDyYr+tcoa+GZOwu1OdhLIeVjMqU2wLx7rN9CnBvAqBrnpncJ9/kuqMl2yYk/6CsliX/MoYihECaSrCGfCWS5EAlfMuYexZl8iCa1cu9i+tTvigiGttJHaGqwAb+fciuo1hMOb2s=
Received: from AM9P250CA0021.EURP250.PROD.OUTLOOK.COM (2603:10a6:20b:21c::26)
 by DU0PR08MB9935.eurprd08.prod.outlook.com (2603:10a6:10:401::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 06:12:05 +0000
Received: from AM3PEPF0000A791.eurprd04.prod.outlook.com
 (2603:10a6:20b:21c:cafe::1b) by AM9P250CA0021.outlook.office365.com
 (2603:10a6:20b:21c::26) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.71.15 via Frontend Transport; Mon, 1
 Jun 2026 06:12:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM3PEPF0000A791.mail.protection.outlook.com (10.167.16.120) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.21.92.5 via
 Frontend Transport; Mon, 1 Jun 2026 06:12:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cl4wGNi9ch596tvr8UzLKGkHjjCnGPpANBsKSY5yd+Ggf8Vbl7Vtcnf7EHtjCAd/YD3Sw6Wx7Ca6DIhyhxv+rUPbBCW7zNZAkm1+gNIGhLuS6ahetmT9O4Jv/rLhpOipEAZfXvxfLKBRgNb63Sr8m/pAIHtdx3vxH+Ch+UlPGvjy3++luhQIIQ1TbZ0TOP1OKh2i+YWlT2YCpn2XmhqzZ4YB1a6y4S2oOM7Q7i3e/gNHonQYVfZD6FiINv6kdF9f8KUJZ6M7hNr/wdVllS2DvnqpxdcZ/CBQCej+dnR1c+pv9uMJ66kiprJmHWL4elPkOTYT2MoRQB1ZN1QV+0+fjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FIFhD1Pm/OLK1rocMnaCyE20TqXRGC+76pWX/JIJ7gc=;
 b=iu9MXVOYNtz+V3vQwcBLg5TFqmSq0Bh3InPc0C/7mEgYjVijvewJ+5/iSjybsOPEUd+g7mmPQypNKDrK+AnkviYhDC/0satfRcSd+yqew5i/yZz62PPGa6ggDOvnIRqL89lmRGi2nECm34ezLODmsmw6bplMhHZ+FdlrGyrzoSDrWZC99jBp7ushwvokXLmnJmDufJjUMbnigbpBfx7ADxUVfpWGISkqwkFu5EZaX9QM4K4St37jAgsTgca1U5sILzLVKaU5Tv8myQosLgDqCC3wn4m5+mFehRyQwzwP9JsfJ+FE6q4BxnC9TVdcFbNF8bH7QE1cNA9DKPN2HGPDmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FIFhD1Pm/OLK1rocMnaCyE20TqXRGC+76pWX/JIJ7gc=;
 b=mO/M/LZVg3610UbyTWFmR6/cS1Ho87YcTkReDyYr+tcoa+GZOwu1OdhLIeVjMqU2wLx7rN9CnBvAqBrnpncJ9/kuqMl2yYk/6CsliX/MoYihECaSrCGfCWS5EAlfMuYexZl8iCa1cu9i+tTvigiGttJHaGqwAb+fciuo1hMOb2s=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com (2603:10a6:10:417::12)
 by DB9PR08MB11363.eurprd08.prod.outlook.com (2603:10a6:10:60f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.71.16; Mon, 1 Jun 2026
 06:11:02 +0000
Received: from DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047]) by DU0PR08MB9203.eurprd08.prod.outlook.com
 ([fe80::f1e:73f2:57df:4047%5]) with mapi id 15.21.0071.014; Mon, 1 Jun 2026
 06:11:02 +0000
Message-ID: <2fb753d0-a9cd-48f3-a24d-ea0b54330279@arm.com>
Date: Mon, 1 Jun 2026 11:40:52 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/5] tools/lib/mm: add shared file helpers
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260527142432.230127-1-sarthak.sharma@arm.com>
 <20260527142432.230127-3-sarthak.sharma@arm.com>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20260527142432.230127-3-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA5P287CA0045.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:175::11) To DU0PR08MB9203.eurprd08.prod.outlook.com
 (2603:10a6:10:417::12)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	DU0PR08MB9203:EE_|DB9PR08MB11363:EE_|AM3PEPF0000A791:EE_|DU0PR08MB9935:EE_
X-MS-Office365-Filtering-Correlation-Id: b9a64851-84b2-4b41-64ff-08debfa4b422
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|376014|7416014|366016|1800799024|56012099006|4143699003|3023799007|11063799006|17002099007|18002099003|22082099003|6133799003;
X-Microsoft-Antispam-Message-Info-Original:
 a36pfYYh0XPhCeoYTbqoS+1wk7/XtN49ty+t6fJSCaT3elZDR0AiEVHRZ8vu9cEJRqXn7GoszrS1G//bHvqBACyw5v9TH243QYeFywnlykER/9/ckmxxf5JvcrJeUB1UUncN52j2zhn7lND02Kj7OFbqgUXEvD62HFuRWROX0m8CvH+UI58ky4iWcHW9K8zcB7Nmyyc/GTiRmoqPgiRkmYTQGhJpRfXG8JK4G4zmFUFJh7SL5TVTSRCcKI19tuOLHAfF1wGKx2/kBQF+PVnWtOr2Jvq4RZroZ0Wg6mLY+OK8QJew//L31R6Z0FrF2ywN7MvJijbaKygsY/WCvhRNvPA5q+t3Cn/mIW+PBcq7ESjhuJOdSj1EFLF9Z8Q5lfmrTJWVw9HAmpZOhAeZlpKV7fQ9xrrm40b51dEM+1p2bTRETMfbbS91qbkPrM8P30MpWJ49C0NQgGeHoQQOx4lOrY04JvmUc73g71FS7cLHN3iY3CW3LWoXrVMAhhRf/FVR4K7RgAQg52g/DG1SOeHyGq3kr7LP8gEDD0W46Jo3CPFv+OptRbOH5HCA35S22HCV2Hf+5ZWcjWy7mrJOL9rRmzylhkGOFna77S+DIRnKhqnY3Wf6V4myl+EyTGPSFfQ2T4PtxqN1bEIRNrnzwtdUp5fmTS4vBlhHAJvof54JVPnbCpa4/xBwTUz9ohxvI+d4mDKxk4z87kz1cc4OGwVEFw==
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9203.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(56012099006)(4143699003)(3023799007)(11063799006)(17002099007)(18002099003)(22082099003)(6133799003);DIR:OUT;SFP:1101;
X-Exchange-RoutingPolicyChecked:
 dIRZKOiOxbe85rM8VGbc4aJAmjNiV//KVrvf/6lo9eC00DMEVrr0kvhlXL34LjITw3r1Xdu7DXrxirT7UxpsByrq19AO/rjlVgS/1dMNCFSNZ+fM56O6qZ17h0hh3OKwelZznHg5NDdgLEg8lWmdOk6RVswX66pEImxVgBD14elupiY+KLof1rEvWyd4X7mHJ3AeLHnqRqaY7fq81ovMEbinhaUwJd3Bak8Y5Lwju5I7w55n96G4qf9klvQ2bMgVDtMr9Z/OeU1bK1nJ7BzdDWyd2lQnOjpVT2auP8wi+JNY0djldJSpdxwgXxiDe6jQCcmBeEMKv6KrnF/HwG0o0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR08MB11363
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	0bfe7390-c4bc-4071-9481-08debfa48e45
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700016|82310400026|376014|7416014|14060799003|35042699022|6133799003|3023799007|4143699003|17002099007|22082099003|18002099003|56012099006|11063799006;
X-Microsoft-Antispam-Message-Info:
	CF7ZzBKUnYZZdYUe9aThuV+IFi9OQAFFYWIHRGUIROvEwYP2GnVi6fwWDq7wrpb02c65K4UeSJcmYe9h10rRYHKGUsoUCm9MbjOW0EUhaMLwG0XRKfi2SuVuN3VfWBKFaXkjesJqKc7dooZGUWjxqEWAEvK2MItET/h3Sjj3+euDXE9lvcflrc86aQrT9OxHAlTfD4DtAXfK8BAGrsMsjUB2s4JzfpaA0pilu5jXsinLA8D59QBMEHOYwlqU4vsW2amoCZ2/1Yqpb07lDJRQPIVGbwF3Lmh5ukXMm5xDO4A+lmVmLgCaQzvARqpkhqoUb72kEhUPGCRghTMvns6G3Ji5rVnGizWE/D4c1R3igUQCFOHadny/3v7u7ElUyTS9QAzpIuhGfetSsKmVZwpUc25BKgyEWi6+wLXIcBfe6KL75tid5ue0ERuEAa06zg1Ggeor+StJt1a1eQMTaPtSXJ6cWP6OUx5Je+8sQlzNuRQ/94D7DqHkTNbad0tnLj9c8dn/xyN5WseiWUxvE9CML72nTrWIZSqsvKi/Awzezw/psIJMAig1+jJnAgI2/7Z6/BclcBGkZKanr+sXhayb+YRwudNtZpzoqxHGq+322vgjs0SaSHERJzZuMRPkWhXuS1EI/DlaU1AvjKXLagLuNk97odZBymus9H3CsmmvJpSFDcZPsSlAaur5zXj49yk7bfHexTL9MHysrLCyCzWR2n8ldKC8l5sBgKRM8v89y5U=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700016)(82310400026)(376014)(7416014)(14060799003)(35042699022)(6133799003)(3023799007)(4143699003)(17002099007)(22082099003)(18002099003)(56012099006)(11063799006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	mxdGSnasUTpn49XO42gW8UwCet5uioM3nrL8qXAJzXJTu4dSYc2XJ0FtaI5ei6Y45Em8QAL842eb42zj+MmoOEQ5XufXz9QWVOw07OVo+WmkwVV/qlRCy0VfG6qo36RsPC6pJq6md6/P5yF5LyHwx1NgE+CjjP4f040OpeJvXKC88eheAF3lgLZTa7uwH9CfKkIg9LVags8iwO5BQowhxmVE41Xf8CGR/QgiWyG9YHF49IBIRkftiHgWiNX/WTUIZs8AfuXjfhS68Bi9QzcExv6SXVLmN1r33X33tsROp2hgeQeJ+MHzyOc+z3cF5ymoDbDmrX+0ctlDGXWZsG62T0TyhH9C99yAMNchRUb8R+vU2OE9WZkApui7lykEZdyuyTOCkbm9Iy1RsJIhNUqSwyFeY5UzkWL8SQKr50PNC6DpaPTop1O8HYAlfXCn0hip
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2026 06:12:04.9974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b9a64851-84b2-4b41-64ff-08debfa4b422
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM3PEPF0000A791.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9935
X-Rspamd-Server: rspam11
X-Stat-Signature: 3nyyq3jwf4n1i1th465qkni57auwmba5
X-Rspamd-Queue-Id: 6710B20002
X-Rspam-User: 
X-HE-Tag: 1780294332-578291
X-HE-Meta: U2FsdGVkX18cMcREX8Mzxt8kkvJpD8grKeZIRSG1PIiBm99c5eXBAUH0xw2iP4fFYia9d6F5tXKy2LQ7bIALeVSkN1EEeWa8H9WCI3LCnpGVDsqd4/c67lm+PNS3OAA89sSyPzKpiPjNhWdW66R3uaGECPs9q/VHChqfUe6hUoTCKKJhoB8O38DF1/4aDEhLgi8sDqIQfNS9J7lrMr0HqF/N5q9neSbZJ9ifrFTzz/npNQIR3pA/Rqfj2Sc9FCXMpGzMlhLXY7ji/PN+WVGLNGhvYdhpWkK+m2a7q+THg1D4TUNTyGMtmgOv4gtmtbKTo/V0dQRQAb5+k0GbPaumvCqKHna6XstkZEVpNzI6AP9ERGMw/Hk1ZE+cG81VbQgaV/FpKBkLkHyq6FPshaN5A0uv+gQ6QMH0i+uqdnkdSBo7ZZQr6ZksE8hZI1TY2WHisMyNdxlCFnDcXF7fIJ/N2UdZhBQwmI0hpvWutbywP8WMR+akZTAJOiOypJd04LuCdjjz6u9h2Xvlnw/8qGPfK+U2/+Ln/aIFyCp+bbmVmgcbZxvDGkk+RPxJsZYxjQ5EEmOfsefxRuMbM9V/9v6+U7Zx35OWENHNOB+JiM0dbabFJKIQ1KZb/9KFUAeiMWbDSdR3iL+yzOMUDES1LMVRbrnWq3CNtDizk0XGUo2J6NZeuqxAL+AbUaQaepiRCunaGTSlBHLQGZP1FtZMR7T5RAi3ajau7nLSJ7Dz0yAfolz/ZYY3IDD8jr+z9TnGMY4rTN+24lDJKHWvUsbGE7nflphUEF2KWToYaTGC5KmBEat8HuYWs4kN3691inDUtOg9ouJ33Wn2LfKjgUi67X0CTo+/Gn1GHDCnY71nftM3EfeIz4nu5baXJ3Cx2qI5TDrDd5CKec4vppBbL8wkEKoir1OnP4KVi5Q8wrz7gcnXKUkkZ5ByeznXtC89Op/OgXnLSkfmz4xOC4ZDjKCTjNE
 Vb1CV+pq
 U5tReM6QcwvStPPQgdeHTKvPxyjpHcQ5oy9L5fS8FLxG1Yr+M13CM3jLakhMys7i+f46tA8eRfkU6BUzZTjxYOxNHZzQPWlavPBybkKVxn9Cp06vbSF0JIji//yMbGSJ4YMuSzPXBhNnfviN6gjv45Id2gOUqglOhGA/G1I/Nkt8zkdUrw+PkobQSRCyoZ8DJ7DIkmW064HuHx9guI32j5C/8dcxE3RCqg0H4aHyNqqrvf0/9Tr63z9ZMGeQ+2mWQo7+7q8mPJJLFZV3WBUFcxFArtU5yGiX7Ig7ooBUiFH7fQMIJLlyVfaVBeXDRc3z/a4DRwKowmYZSCoENiWOJNGz9HHiB8BX4kJg41iJJfTHnkBT/5lK4cNqjjnwSZAmrolf65iNHfQHBm6Pp5HJj43Cvq8BPcwB/MIKerGAJkcb/4K8fS3mkDfs638/rwQqZkMvL3xXplB3twqbNKugEJQDJkjZqU4mNd+Q/Yudhj8KiPQt9kdDP8Fuxw+n/ydnQR+I2iRuOk6cAqXXSweQLPRHCAVR47r2Xk64P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/27/26 7:54 PM, Sarthak Sharma wrote:
> Move read_file(), write_file(), read_num(), and write_num() out of
> tools/testing/selftests/mm/vm_util.c into a new shared helper under
> tools/lib/mm/.
> 
> These helpers are used by mm selftests today and will also be needed by
> shared hugepage helpers in subsequent patches. Move them to a generic
> location so they can be reused outside selftests as well.
> 
> Keep the helpers exposed to mm selftests through vm_util.h by including
> the new shared header there, and link the new helper into the
> selftests/mm build.
> 
> Add tools/lib/mm/ to the MEMORY MANAGEMENT - MISC entry in MAINTAINERS.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Hi Andrew!

Can you please fold the below fixlet into patch 2, as suggested by
Sashiko.

This moves the x86 Makefile prerequisite path fix earlier in the series,
so patch 2 remains buildable on its own. The same hunk is already
present in patch 3 of v4, so if this is folded into patch 2, the
duplicate hunk and the corresponding commit message sentence should be
dropped from patch 3.

If a larger respin is needed after reviewer feedback, I will fold this
into patch 2 in v5 myself.

---
From 1ce0654749f17ae55d7fefefe86bbc55eb3c06d5 Mon Sep 17 00:00:00 2001
From: Sarthak Sharma <sarthak.sharma@arm.com>
Date: Mon, 1 Jun 2026 05:03:53 +0000
Subject: [PATCH v4 fix] selftests/mm: preserve prerequisite paths in x86
build rules

Patch 2 adds tools/lib/mm/file_utils.c as a prerequisite using its full
path. The explicit x86 protection_keys build rules still use $(notdir
$^), which strips that path and makes the compiler look for file_utils.c
in tools/testing/selftests/mm/.

Use $^ instead so pathful prerequisites are preserved.

This fixes the patch 2 bisectability issue reported by Sashiko. The same
hunk is already present in patch 3 of v4. If this is folded into patch
2, that duplicate hunk should be dropped from patch 3.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/Makefile
b/tools/testing/selftests/mm/Makefile
index b5fb4b6ab31b..4254200d1cef 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -217,7 +217,7 @@ $(BINARIES_32): CFLAGS += -m32 -mxsave
 $(BINARIES_32): LDLIBS += -lrt -ldl -lm
 $(BINARIES_32): $(OUTPUT)/%_32: %.c
 	$(call msg,CC,,$@)
-	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $^ $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-32,$(t))))
 endif

@@ -226,7 +226,7 @@ $(BINARIES_64): CFLAGS += -m64 -mxsave
 $(BINARIES_64): LDLIBS += -lrt -ldl
 $(BINARIES_64): $(OUTPUT)/%_64: %.c
 	$(call msg,CC,,$@)
-	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $(notdir $^) $(LDLIBS) -o $@
+	$(Q)$(CC) $(CFLAGS) $(EXTRA_CFLAGS) $^ $(LDLIBS) -o $@
 $(foreach t,$(VMTARGETS),$(eval $(call gen-target-rule-64,$(t))))
 endif

--
2.39.5

