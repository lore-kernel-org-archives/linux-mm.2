Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65941CAC58E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 08:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29BC8E000F; Mon, 15 Sep 2025 04:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01968E0001; Mon, 15 Sep 2025 04:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA178E000F; Mon, 15 Sep 2025 04:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94D698E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:12:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5153DB9B86
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:12:14 +0000 (UTC)
X-FDA: 83890766988.27.B8B78E9
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013043.outbound.protection.outlook.com [40.107.162.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 47C4EA0012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:12:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rS58LnFb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rS58LnFb;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.43 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757923930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7z40f/ynlctXh+s09ACjAYO7kTTbcaTnpLWEVSAJKwM=;
	b=nyJgzE06GkgmJ7+/Wa0sN2ZMmYMmuBh362fRzr0f04acb0CYECKLVnTpAuqfQxi/x8G0DV
	UYSLFC4wCTrx+o8nGbv6sBDeaafEMJydkwSBPKr5KC4Xn6b4fkdUu245bkFymkAgClkH7Q
	sfTxsL3YoXn3N3AIMjjpRP8Zo5HXg2s=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757923930; a=rsa-sha256;
	cv=pass;
	b=an2Zawv9brDJtaF9v/6xvqQgVQFTuQYjD5mCe5luY5a1alMFHAJaPvaHBVOWY4wW0lm2aV
	u2wqadbmPVoBXVz8e2KNu79oKVZ285Erpl4/FrZ4aTPSAxyqwbQU8DEVSLsDEKhX3BGYoa
	YU0ZhEXi6YzxW2JSOsONoemUbB+wdj4=
ARC-Authentication-Results: i=3;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rS58LnFb;
	dkim=pass header.d=arm.com header.s=selector1 header.b=rS58LnFb;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	spf=pass (imf15.hostedemail.com: domain of Dev.Jain@arm.com designates 40.107.162.43 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=FEnQIUKGwMaF+j6q8Lcd2fgNYN0vm/+AdGDpMzGoXCwIyc9bNG4kuKOc9Bb44WRrFlH6wwwHEqkJcL0jPFNcqGnZUg9yetZVGoybavEb7Cpk+D8NL2NBOzWu8iLF/zr4ohujWu6QeXnG/JwKXcyQ1/cGCmOT3G7eAzftyYWoksD9qrRPureM5twSKjyHndjT+XNeALYNq2ZqmSQcbjKxVNvum2IHWDJ17kNXjh+Hfe68XKDHGmulbQKvke2+gQ5RRcvzzlkFCav+K1hhOCN7oQ8UZJ3v5glrtN3v7RkYITDHb9LdHwE+SJZBdKbFiJVBTKW6ENvYMVh99lg1vAsnZA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7z40f/ynlctXh+s09ACjAYO7kTTbcaTnpLWEVSAJKwM=;
 b=h73l7itXeiSSbyFcB1PvMz9as35IBSx822XFpJ3o4ZZiqzmAesYD59X7fRseLUA0jbcVYd3uwEZrSTZiSd2V43OClN7E1wDIvk5ADX0aOKxwi6SUWLiFZNT7vO63gAlaskAzit/7xHTPTmchofc2NezoTIWKfQXYACCq6cdR0H63j2IAMEGvzC1n6FHDokulLSm2OLx49Wl2XKbmrh8v+84NaqsQLdDoGPltDnO2SXAhLXGbCIm+F4QuBAXHRPDq3ZTIHJIO0WQtC5yqXtvTeQto3wZJpBh4z68OfGL4znjo22xrpy0ClFMg/i+m8YEx2aKlQ7pjsOGJEO3NeZyOqQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7z40f/ynlctXh+s09ACjAYO7kTTbcaTnpLWEVSAJKwM=;
 b=rS58LnFbuiJiksCg0Uewhc+bB9p5ZlHd4tCGzec52GBsDOVIcHgE3MKNfp0v4QJp09vngKiLmHm8IHmjwbk5S0Xkgf0wAkpF2iYUdB7z8QrSj/sJR1B9SNHvbwZ+CwPIA90q5cE7WPK2AWKXkTHGyBcJM8Q8DJ8a2KP9k/KcEjA=
Received: from DU2PR04CA0025.eurprd04.prod.outlook.com (2603:10a6:10:3b::30)
 by GVXPR08MB11494.eurprd08.prod.outlook.com (2603:10a6:150:2e3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.21; Mon, 15 Sep
 2025 08:12:06 +0000
Received: from DU2PEPF00028D0D.eurprd03.prod.outlook.com
 (2603:10a6:10:3b:cafe::af) by DU2PR04CA0025.outlook.office365.com
 (2603:10a6:10:3b::30) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.21 via Frontend Transport; Mon,
 15 Sep 2025 08:12:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DU2PEPF00028D0D.mail.protection.outlook.com (10.167.242.21) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 15 Sep 2025 08:12:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=DXt6pPIrz2fgWvJQsT8gwOzO71+bJd/Mb3VdMAlzRMGrq5IjCQAQhhd40XvLqNxoguktZhLLujbj/8LwCF/bhn4NKtyTcVjc6e1f3i/4AhjFs2PizZof0DAYkEft8/MrHT2hfApJdM2pdrC7WOFPqE4meDwD02TOuYwGYTGHB4toE5+tVp/E7Jic2q0EWXov7Sy7JrJ9N7hwvEUQ8UdM7NuTcB2i4WbPorbgxQEKfZ5sa6HTOo6c28Hoobt9eGH5g2nW5wf7mIbfjtrQ8pTOVHmBfv2bNUPJowWT8ITSlPQTPcl4vrBGdv0rY6golBuDuj0oBlfSjCsKKsZhNPEnjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7z40f/ynlctXh+s09ACjAYO7kTTbcaTnpLWEVSAJKwM=;
 b=HqG9B+LA4b+fRyyLcgrCOWT1YGrfssqP8yQiDRNzdB+D+MtstFnUmIFiIxPwrEJJvlecPjNVsZKQxpZNVTRiYYcVdXoTPJvtxPnRc2tJz6Y2/QzOCdcDg76c07H3Nf7jttNTgW1awa07ckiDQNuBHJ10Sp2gGrQcChkFlTapaD06l8I5zZza2FJZ8Y8twRfnmePB5kDUI6uhkjg7N9mIs8OOh3+EVntVHwIZ4izo1pwosWlTw0VyzgxlgFAC1p2lLFXthSsrhD4NfPQ1s1MkmxbtiGNY+zeJlMls4A3XR0LnDMFV7KjrqQhVKDJSljxy4EaCcVuHnHN8c0YFMTuTlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7z40f/ynlctXh+s09ACjAYO7kTTbcaTnpLWEVSAJKwM=;
 b=rS58LnFbuiJiksCg0Uewhc+bB9p5ZlHd4tCGzec52GBsDOVIcHgE3MKNfp0v4QJp09vngKiLmHm8IHmjwbk5S0Xkgf0wAkpF2iYUdB7z8QrSj/sJR1B9SNHvbwZ+CwPIA90q5cE7WPK2AWKXkTHGyBcJM8Q8DJ8a2KP9k/KcEjA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by GVXPR08MB7678.eurprd08.prod.outlook.com (2603:10a6:150:3e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 08:11:30 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 08:11:30 +0000
Message-ID: <220cb3d6-d095-4656-bede-9fb8624f4e12@arm.com>
Date: Mon, 15 Sep 2025 13:41:23 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mm_slot: make sure slot is the first element of its
 wrapper structure
To: David Hildenbrand <david@redhat.com>, Lance Yang <lance.yang@linux.dev>,
 Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, chengming.zhou@linux.dev, npache@redhat.com,
 ryan.roberts@arm.com, xu.xin16@zte.com.cn, baohua@kernel.org,
 Liam.Howlett@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
References: <20250914000026.17986-1-richard.weiyang@gmail.com>
 <ae30fc02-c573-46bc-a5f6-935f256149e2@arm.com>
 <cf5d6ff7-faa4-469e-9e32-b90c75b8194f@linux.dev>
 <463716f5-be12-4d78-9432-779e3f11460c@arm.com>
 <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <62680957-e9aa-40ad-893d-885bd01e1117@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SI2PR01CA0043.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::12) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|GVXPR08MB7678:EE_|DU2PEPF00028D0D:EE_|GVXPR08MB11494:EE_
X-MS-Office365-Filtering-Correlation-Id: 98560ecf-d98b-4e68-80a9-08ddf42f8f3a
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?VHhDbnV6WW80emNZQXV6Q1N3M0xrL3BQT1FubVJnYURLVzRHTjZrelBQcFVq?=
 =?utf-8?B?dXpsS3ZTREZ1MXc2MFpEcTNwdjN5VFg0ejNTSkNiK3FTZS94WlRGSmFJOU1y?=
 =?utf-8?B?TjVjR25PNS9IRDJ0OHZEdWU1cGtzWVV2a0UvUmpnVjM3c3czU1NUNFBJQmRl?=
 =?utf-8?B?d2g1N3ZaZDdFcUN2dVBNdkdmaDFXallXVG0zamxuQ3BBSVJpN1VFK2tqYmkv?=
 =?utf-8?B?MkxIRVVhRDdObU5oR0d4Q1F4TGdCUlkxYTByY1JTcUNsS1VDNExndmtlRDBY?=
 =?utf-8?B?eXpwSjNDNXJxbFFXV2hNQkhGY25TWXR1TWxNcTNOOGx2N2FMY3h5NTVDQTRY?=
 =?utf-8?B?azlTWkg5Q3pjUURuWFVWYjZucGhQWEF6Z0c1YSs4Um1tMDl1RXlhUzZEZXNp?=
 =?utf-8?B?am1GR3VDM1FRbW5nRFJMV1Z4MmJHcGJKd3JOODB3WXhqZE51UlJlQWpjVjE0?=
 =?utf-8?B?TVRab1ZlWFVOWSt5THpzYlNYY3psN3B0VEUwVTMyVStQVzgwMWNRUFRZdnpu?=
 =?utf-8?B?U1J3TmJBRlFjLyt4MUhMYUszTUNaR2dkelkza1dGMEdna2l5RmxRcWVFcCtM?=
 =?utf-8?B?QzFFalpxRm5tZWRmbGNCaGVrWGFiOTNvamhnVXV5akE1NlMwblVhTDZEbk0v?=
 =?utf-8?B?Mjh1STBTUndTeW5ycnZSK2h4MVI0aUQ5THM4VG9XanlqMFViUUg1VEpCY1Nu?=
 =?utf-8?B?TndkN09sckhWWWhYU2EzSXhTMnBoejNob2ppUVpCZGFYOHFlZjR4SFN3Q0Fy?=
 =?utf-8?B?UVdxa3lEc3NnR3JZdG1sMDJ3bmxHL3dZUXBMQmJOWEhFTWtPVjdxZHhpaHJ6?=
 =?utf-8?B?Z29qaWJxTXM0ODZ3OSsrV0Nwc055bkEwaHgvdnR2THpVdnBjeUdhcklJNFZX?=
 =?utf-8?B?Nk5GdXBBeWZQNlpqTVplV2NCVGdVMXFNWEQ0ZzVlVC8wUXA3VXpUM2lmZytQ?=
 =?utf-8?B?UGZ3cUdWb0dXdFl0bnNkQW9aN09vcmlCN2lnK001VmFGQUFSNktENVRpenpC?=
 =?utf-8?B?bFBOeDB5c1Y0NllSREorRGRuRGcrTExUODNyaGJrY2l2YUpIRi9BeUVhZDdj?=
 =?utf-8?B?T3dOTW5rSDBKMnRNclNndkVjVnZQSzVDMzdBbE1rMk56RDZZZ0xRNVdHOU1n?=
 =?utf-8?B?bXJIcjhiVUVxS1FSTHRJSDN5S2FRWXRFMGZ4SURkbUk2SUtmSFM3V2hJbUJB?=
 =?utf-8?B?UGpQaTg0SnpPa3BXT1F5NUNKOHdZMk5pNWtibE50eVptOXZyay9lQmdtaDhL?=
 =?utf-8?B?RDZuMnM4d2pJU1ZqY3JkK0Erek5TWUxLQktWQWJnQnI5MEpyRTN4QjVwbzZT?=
 =?utf-8?B?d3BoZnhJVGxrNHhUZzgxRldOWStCaHVhOVNEbkhwMnFpNkxJQmlvdzV5SG1y?=
 =?utf-8?B?V28xSHpoN2N6RlBCbkpUeEFGMTFacXF1UXdhRXFkL3BZRmNVWVRlT3dXMEF3?=
 =?utf-8?B?ak5lTDhkRHMwYW9WaVJnRVUyYWpzUzg2ekxaV3owcXZVczl1bm4xV2pXNmds?=
 =?utf-8?B?WHlITFJucVAyeUQ5NmhoeXgzYUpaWnJNbEF5V00wbWNsQW1EbjZ1ODhYcC9B?=
 =?utf-8?B?K1V5ZDE4TW81SUJOR3ZocndVZk11a2tOY1VkMlpZbkhzOUh0WitXZDdxUElS?=
 =?utf-8?B?U2J5bW82TnVHb3haMmxjRGtpRWdST0VJTGxHVy8xZStOUmNwK3hibDd2MDhF?=
 =?utf-8?B?NmhKNkxta2RyU2VmTk9nVjlYU0RnK2VNUVdZZ0JrQ1ZMN2EzSUhQVkpiM2E0?=
 =?utf-8?B?TXJXL2RGeDBwZWNLRCtZQ3hKM2lxdWlhM2ZXTm1XdGNOSTE2SDl2eW9EM1dl?=
 =?utf-8?B?NWxjSVF6UndKOG9ia0dMa0xoUllBSWNVdjhCazk4azlwd3I0OW9HNTJnWHlQ?=
 =?utf-8?B?QmswVGNWSXp1M3RxQ0ZRWVV5UEtPcFh6ZTV5cmhOeWR6clZwMUxoZ0EzOWRV?=
 =?utf-8?Q?02T4FoslGZI=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB7678
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	2ba263f8-f456-4f25-bd9c-08ddf42f79b9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|7416014|14060799003|35042699022|82310400026|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aDBLeENwRkoxcEFYQXkvUk8zcUUvRlcwUytib2hJcHROK2pNYVV6aHRxanZB?=
 =?utf-8?B?ejBWNlA0djVFNlFkZ1ZacDJSYVkrYzZKcEI2Q1ltS0VQNDZaWXo0cWtuMVo4?=
 =?utf-8?B?bUVXOHRadnEwOU1QK1N5VE1kcy9rVFlHMFBzU0c4WVc2SnF6UUFKbU91R2VJ?=
 =?utf-8?B?aURCQTA0ZDkzbnJRRXFzbS81ais3ZW9KUkpBQXI5RTNlQmpsOURxVG1lSE42?=
 =?utf-8?B?bDY3cEZCQUk3SFZ5SUN1ZU5JRlVVaGN2eEUzY3dyU3AvTmZWRSt0eHhDNTNM?=
 =?utf-8?B?WWsyZzlPanozU00zSGozeE9QNUJTOVNXTVk4NWJ3QjJUWmtaQ3dLemlPTXhn?=
 =?utf-8?B?c3RvOUc2eFVXY3M4Uko0Z2RFWldRZ24xdW0xZ2ZMVUtOdnc4MGpFTWc5SmZn?=
 =?utf-8?B?ejdtbEFKR3M4ZEN2VlN5SEdrcjh5MFdXc3JBL0RDQWkydllrZG5TTENyM0JE?=
 =?utf-8?B?cE94cGlOSldETWNjTmxiYS9JVm9ENFhCTXBvekFvOUIxTzhJb0FPZlo3RmdR?=
 =?utf-8?B?MkpLVXhxMVRFWUdFemdTMTUxTWgvWkp6cWtnTG1RbkdFYzY2UW1kUHdNNExy?=
 =?utf-8?B?ZnZtQjFFb3c3c3VOa2UySU01NWlWdUprajRxZi9Lakc2ZFh6NGZVL1ZmaWNQ?=
 =?utf-8?B?anh0S3pPUVRhRDNWTldQS0U2YytzUUZwNGpvY0xGQkoxWjVWcTVLNmRvMjI5?=
 =?utf-8?B?bm1rWGwzNDBCdWlzNmUrbkcrMlF3NDhuamIvMG83Zk5rMFExeldLT3M1VTlo?=
 =?utf-8?B?a1Mxck41TTZDbHhRdEJJMkJiU1RRUlJ0SzNxUGdaK1hNZjAyV0hLRTNxY0VP?=
 =?utf-8?B?YTcvMkJpVXE3Ym9RUHYzRWdQeWpzUGRDc01INmpFdDZiUmljYnBNZWtNT3FH?=
 =?utf-8?B?Z25GcHNKZE42QmhrR2t1a0ppQ2doRTJYMHI2bHY5Y0RwTURKVWF6SGxOL0tw?=
 =?utf-8?B?YWJzdWYxT25naEtaaE80akJFT25PcGhVaDc3WGtEM1RZSUhtbWQyTmVKV3pI?=
 =?utf-8?B?Ym1TUDJhYkFGazVkQVp1K2FMYmhvUXY3K1NOQ2xWNW9HMFdSRmZJZEFtcnBl?=
 =?utf-8?B?NDY4RjV1SFpOblI2dUhhOFcvaUxrdXpKK09kRFUrb3FvZjhweVZzYVhPWXp4?=
 =?utf-8?B?N0lUK21maEdRVTA0VUEyTkthRTZ0elVkZDZFWlRUenQ3d1RoMmo5cEppSFAw?=
 =?utf-8?B?MXptZ1BIei9XRnJWeTZPYzNza0hqVytVWFNUWHh2TGsreXU5WXl6d1ZDaWFz?=
 =?utf-8?B?UmdXQ3FjNDVCc2FVZEMzbzVmVTd5V3YrZ3EwRHNjMWYvaWZUV3haN2d1OEtN?=
 =?utf-8?B?V3BDNkpoYXhScWhlekYydjZyVzZsZTJaZVFLVTE1cHFBQUs2cDgrSmpKQldS?=
 =?utf-8?B?aGxhL1NDTmZjcVRsdE4vMTU2SmJwRmtad25uRTlPZ3ArSmdCbXgyelp4aU80?=
 =?utf-8?B?Mkd4OElJRlBzUEFCWFZaM0ZnWlJ5ZUxEelJKT2x0MEZwUmk3QVdXdGtWdmUv?=
 =?utf-8?B?WEZnWXNtamdLc3pmVmdYQm5QWFVMcGhOSE82MW1sSDBHSVVUY3VnclhIbXMy?=
 =?utf-8?B?Z1RDSEpiTmJaYXlBbGx3TENMZDlaS3FRa3h4aHpUUklKWWhiS2ZIOERSbkUv?=
 =?utf-8?B?VWNpSjA4d3hhR3l1SVlkS3dXeFQ5UlByU1liWVd3ZVhVS3lkR3M0SXZnbFVU?=
 =?utf-8?B?NnFCV01rTnBkelR5WXh6cWxpQTI5TFBmY01LOURPS1pOTDR2VTNVOFhhTW5r?=
 =?utf-8?B?YjNQbnhhQm1zdmN3RjJtKzVPZmN5dWJDK0F3ZC9yMzIxSURQUy9GanJ3NSti?=
 =?utf-8?B?b2FhZDRQc1JrQldEb2VCVHlsWUp2RUZGL3NNQTVUaVlHb2lmV2U5Y0FlTDFD?=
 =?utf-8?B?Sm5rdVhpVDhtN21hWkg4T2tObDFkekJrMGFiTXpBeDJqWlA1Y1YyYVR0cTNs?=
 =?utf-8?B?TnBzWktCNklLNGR6V1FUOEdkODB2dXlhanpSUGRkcmdTSURlRzI2czNsWEJa?=
 =?utf-8?B?d3JTdldaM1p3MjFpT09SdysrYnhtcFhFZjQ2QWpJTW1Gc3RFK1BqUVBEQU5H?=
 =?utf-8?Q?qUtgPQ?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(376014)(7416014)(14060799003)(35042699022)(82310400026)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 08:12:05.9102
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 98560ecf-d98b-4e68-80a9-08ddf42f8f3a
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DU2PEPF00028D0D.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11494
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 47C4EA0012
X-Stat-Signature: 5oagdnuquptgfmoq4gsgqfm48cy1an7b
X-Rspam-User: 
X-HE-Tag: 1757923930-642673
X-HE-Meta: U2FsdGVkX18kyS+Aca3UK2RRCu/3xZoZQhbDsFILcbobnqe7Z8LIBDxjAzdmxRspy9UL0e12MVG7JLz4wpfuOLgebx6pOQAXuYgziVWRPAADRdRpAjSm+oySLbTWbdYoFZTjfN2aBXDLvozO5JN53k4qAj8XMiik5vxDQQXX7vZZFgtUCJ0U+FFLp7nmtneq5Z1AEb345k0OVsMs08ypNFDRb1v0tSa5hiD0e5J7F4RvaR+BKTqE0GyGYrZ0if58Anf5E9vb1JGvt+70At7qEx51EyDeXmMiG9/UJrq2H+dQD2DBaibk74HXmoLlpEcEyM+Oh0lsJjwVKU5t6QhnLa2fu8Q7MUMx5XzoDQQIvfHbtm86w0FLUYyKJzJCUdyXyaRN/gk6bb8vEfiWLH72j5M9x7WYqod1zxbVF7ZbyK4rfBlwUhe12/GQAGZH0h1zwXLqLZe/5DIyJhfiBKbrlSeKN5FDwcjaC+STHoZBGl450pKVWGasXGBTHSwYFCoQOihyrSTIiPKjaOUnKKDPUumZoykgSEWCFXAYJhRNIs+GNOUKzfkhRrugvtXtCYtV5Yk9UyvFtQA0L6jBgoL1Ruh9Y6poe6XjxgHp043m9j/YVFUCwgP/afdmJORMFqIpZcVX0Hl/duNDkb5IPwB57yJsSmeyTPiifgAsEA5yNUq7TeRREfV4/heAZAdkaZ07JhJRyJG5DCbI2je6nV6rUDyUCt7SZVSAuo2L3/oFGjQLKxpqB2jWm/QqiSEdfFhJmZGoeScpJgZT9qIHRSjDiQ/LMpO1AIs3+HStfBP6dChrw+nXJ350g5IOcYgmEtQbXsLhxrGvnRo5NQFU2nbqGAqaqIfXiuirl1mbhD5LIIT21Kidt/fuYbglhO/5a0bG5BTYAAvs0twOs8HiRPSuURYJn/aygWunX2izdUJuAb9HgGaTdcnP096zzkmcSXvxxAuHeFzhr7SI/w3SLb7
 x8yqc7gc
 /d2dHVtDG1rDZV+90TNJ/TRY/a8S/ToYEO9O98R/4vnaWImnin7bqDkEI6T0jZMQ/LRTmZrnkedwblZoSQFGSxVA7/sTJERckxnAktRWXDWnK7lSqrZZNKiVMqKYqnYs9juZw4IIcr6AP4DC1dGZ9vulFUk3ma5n1KpqPMck5ThUPri3tMkV1KndhJcnch9au+HFE3BNIQaKFklUZKyLoQeozcGLNzJl0kGTOnus4jCTxXvWx6/Agno0nUz+5fblWb/+8jmddr1UxkHPFxuokMnGLMx719tRRiprD1fjAVsZXSV4Ja4VT6pe3DKcmjw2FGlz0Srl1mAc+w+DFzA8fEtBwjkcwcu/TaHX2e48i5wZDFivv1PtGEusliNHnhyBt3jA1cmYmU+Fu3bo/EKrh0sdruePKbINg3IuxXjAsUaDSasSuYvkL9BPEpDI9M6/Z7OGxiR9K1sNgPv83fCmDAf0/GrgIJ0plXq6nr3zlwLHp1SicfAj0LQo+txOCseQEyu5SbI9wZ7q+t7zYwaoWpiIHCdgBB37o2/uirF8/V8MOK7RkN0YyGTx3YBf7vlkgwo7l7f2vYVU3vApO7c9MIiXHJoJwHk4yjdzWa4G/qeXqqrSKyDs7ETbrSDc+Hv0MThDaMA3lAgPRLBH5cHir8LPOBnhDLRWadsaxpkVPLTfI/CzycNt7EWUPcR4XMFpz991d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/09/25 1:26 pm, David Hildenbrand wrote:
> On 14.09.25 09:29, Dev Jain wrote:
>>
>> On 14/09/25 12:33 pm, Lance Yang wrote:
>>>
>>>
>>> On 2025/9/14 14:21, Dev Jain wrote:
>>>>
>>>> On 14/09/25 5:30 am, Wei Yang wrote:
>>>>> When using mm_slot in ksm/khugepaged, there is code snip like:
>>>>>
>>>>>        slot =3D mm_slot_lookup(mm_slots_hash, mm);
>>>>>        mm_slot =3D mm_slot_entry(slot, struct ksm_mm_slot, slot);
>>>>>        if (mm_slot && ..) {
>>>>>        }
>>>>>
>>>>> This is only valid when mm_slot is the first element of its wrapper
>>>>> structure, otherwise a NULL slot would converted to a mm_slot with
>>>>> negative value. And current code thinks it is valid and continue.
>>>>
>>>> Shouldn't you fix the code for the case when you can't find the slot
>>>> in the hashtable, i.e slot =3D=3D NULL? Like, if (!slot) return.
>>>
>>> Right. For khugepaged specifically, the slot =3D=3D NULL case in
>>> __khugepaged_exit() (only user of mm_slot_lookup) should probably
>>> be treated as a kernel BUG for new.
>>>
>>> But I'm not sure if the same logic applies to KSM ;)
>>
>> I haven't seen the KSM analogue, but restricting the position of an
>> element
>>
>> in a struct to make the code work should imply that the code is wrong in
>>
>> the first place :)
>
> I agree. If mm_slot_lookup() returns NULL we just just handle that
> cleanly like
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6b40bdfd224c3..70a32d59d7d2f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -488,11 +488,13 @@ void __khugepaged_exit(struct mm_struct *mm)
>
>         spin_lock(&khugepaged_mm_lock);
>         slot =3D mm_slot_lookup(mm_slots_hash, mm);
> -       mm_slot =3D mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
> -       if (mm_slot && khugepaged_scan.mm_slot !=3D mm_slot) {
> -               hash_del(&slot->hash);
> -               list_del(&slot->mm_node);
> -               free =3D 1;
> +       if (slot) {
> +               mm_slot =3D mm_slot_entry(slot, struct
> khugepaged_mm_slot, slot);
> +               if (mm_slot && khugepaged_scan.mm_slot !=3D mm_slot) {
> +                       hash_del(&slot->hash);
> +                       list_del(&slot->mm_node);
> +                       free =3D 1;
> +               }
>         }
>         spin_unlock(&khugepaged_mm_lock);
>
>
> If mm_slot_lookup() is not expected to ever return NULL, then a
> VM_WARN_ON_ONCE
> might be sufficient to document that this is guaranteed.
>
> IIUC, MMF_VM_HUGEPAGE might be set in __khugepaged_enter() in case
>
> (a) test_and_set_bit() succeeds
>
> but
>
> (b) mm_slot_alloc() fails
>
> In that case we could get NULL.
>
>
> It is rather weird to leave the flag set in case mm_slot_alloc()
> failed ...

Good spot! We should move the slot allocation line before the test_and_set.


IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.

