Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7584CC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:07:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BA88E0002; Thu,  7 Aug 2025 12:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FAC28E0001; Thu,  7 Aug 2025 12:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB6CB8E0002; Thu,  7 Aug 2025 12:07:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D50178E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:07:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 75CE45904A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:07:27 +0000 (UTC)
X-FDA: 83750441334.29.5C8A927
Received: from DU2PR03CU002.outbound.protection.outlook.com (mail-northeuropeazon11011056.outbound.protection.outlook.com [52.101.65.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 589F240013
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:07:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="YTWZ/DoR";
	dkim=pass header.d=arm.com header.s=selector1 header.b="YTWZ/DoR";
	spf=pass (imf01.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.65.56 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754582843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwEzOa4T1ieSq6lg7gigg+PoEo9lpc+RwKlTIjvvFQY=;
	b=MvS6+BCqTqvCzkqaLrZngJ01/Zwr9YISi6EJByVNmwBZn8ObOObGmNsixYNkV79PObbi7U
	2sD5HTu6NkOfjlr6O4qdL36BDSuYkzB4MoDxhieIBklzYjYg6oTI5HQ7PPBe6hhJWoW1Lz
	+JeKITNkyI5Pm54vEqF9+NGFk/saRSo=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1754582843; a=rsa-sha256;
	cv=pass;
	b=8Z1MEixoWunD5LLbsHB8Cg8O0lOVzf5H7A5pIyigq8eoSBKu2lVBkQMax5RQBsG2HSSrqA
	xIY4QMnD/VmtvNNcR17ezuTXrFBRg/vTYiWP9TOo3PvyJktN/jXzaUi9SV3OQzNvNg9Xfw
	VImMHoiXUbwvs4MGO60um3BgkTzw2Zo=
ARC-Authentication-Results: i=3;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b="YTWZ/DoR";
	dkim=pass header.d=arm.com header.s=selector1 header.b="YTWZ/DoR";
	spf=pass (imf01.hostedemail.com: domain of Dev.Jain@arm.com designates 52.101.65.56 as permitted sender) smtp.mailfrom=Dev.Jain@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=kZfsJZgrlLAybb9SLBDeAu3zRpIrempQq2zkkgXbsDvBkGT6Vn7c3nCxFlIO52y5FYkGNgogBUID5SIXdiET1/1zyODuIDPTSsxHBgfouHdCk+IfoU4V9l0M6tySe4AGrYq3ivVFMlMEwRfrIhQw5yyPD/Bvhq0VJ5B91R7eWe5gwwLn5/h3fZpzeCNPtkUG+QXLMOCuX3+tRN6LVVEMATDcHpubr/w65Aj+ixisx4HF23aVMbbxvpIxM1tHG27tUj2XlV5+Gsak4cM26LbZ9zo7Wqc4ppovwJrjfAuO+zQUvfkzEK/MP0Go5CFSq0c4djy4OkqlkEmAEcrSBuQR/g==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwEzOa4T1ieSq6lg7gigg+PoEo9lpc+RwKlTIjvvFQY=;
 b=QoxTopxUQFhuY23V8nz8vMIX2ScBjbD62ygFNM938VzVff98ItcJOkG1Yx5SuNSYCX9g9AAaFwMFRS+gU95ZUd2x90utbJtfi9sDadGQBRVJit+VRFKblmj7hrrZ4AV8rSnf1OOKwLzRYTUd3x4YSQ2ZKQ0eqe0snCeiJ1OsB/Aan4VEUq+dnMMubh+H4+Idi5rODibYESmAAqfylupzEjx3Ls1qCDA2jnaDAKTY6ObLJsiCNq8v8y7Q05ISbrgpng8Ehh3LR/L+zFmdnKxwMlnyFEcbFVAqheF77AOgh30oZLbhby1UGxLooX/8+itO894JxVyW8D7s+d4R9HBekA==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=redhat.com smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwEzOa4T1ieSq6lg7gigg+PoEo9lpc+RwKlTIjvvFQY=;
 b=YTWZ/DoRqfQ4oMrfi3C4NmRANg+ReFTYMSo3OBKLqmNvt6lAw2ZcxRH1LvF9hte+dy9iVRpcmnAAJ4JCrPodeTvyDJIWxJeJERVzQTEaIxu6c9bY114ZFFXeUaa3YdFvfnqz635sq3Z4f8L6fyXUjBZGSywyA9GRDu8YCmL86yA=
Received: from DU2PR04CA0288.eurprd04.prod.outlook.com (2603:10a6:10:28c::23)
 by AM9PR08MB6706.eurprd08.prod.outlook.com (2603:10a6:20b:303::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.17; Thu, 7 Aug
 2025 16:07:19 +0000
Received: from DB3PEPF00008859.eurprd02.prod.outlook.com
 (2603:10a6:10:28c:cafe::17) by DU2PR04CA0288.outlook.office365.com
 (2603:10a6:10:28c::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.21 via Frontend Transport; Thu,
 7 Aug 2025 16:07:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 DB3PEPF00008859.mail.protection.outlook.com (10.167.242.4) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9009.8
 via Frontend Transport; Thu, 7 Aug 2025 16:07:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vRKN6bhZix3XaWXMVOYn8B66DxgwIVzigCooYEg0UF16qkyrDBuj6TpApbacxx0mgAh145vdf9BbZY/C+76JFUAYh29x5zARzQkGB9i1KxnHEIqf1xayhK8XrKVWDIsnUhdbZj4gefEPTQ+flod8eTA/AVhXXilAq6nCmt2PnG/iUOqIHEaC1kM8P46tDvNKUA8cxfi1UKA4G6OnQcRKy7HEIFyDoXKRHTRCWG+dxGqJf1l9mqXE6SLJS8sn/hSEdSAg/6ihyLColYwB/85S83ZntyfUng5fVjpKVbAU7CbtUo6UtHnAYQwrrIX6UuP0WuqTCGGt9E7muoXRQZcaiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CwEzOa4T1ieSq6lg7gigg+PoEo9lpc+RwKlTIjvvFQY=;
 b=QF7lLLI4lSBgoyk3zev1VLXnphrYI2sk5rukJnkjIZiZinX415pSfo5SiLH9biaoPZJSNkvjROS/qqlcP6LhaAoxLBDXkpBChRLVe2lgzjJZCs7tgra678jtobBnXT1ymJsQumhopUv6bKpRCr5B7yBAY125OVjXY9kuN1UR1eWSCUrYzFUdUOqJ/HDLxzl9cY4WbFZ02j0D/jYPlmUgBSST84x0IH26tW+fgNoT05/Zk/g8fRZqWcIMLI6PXwA5XewuhltBZz94MsgsFhZTHSVoGS7K5304LgGEpbZizqpy1fBpV9oJ2r3LtSmJevL1v+Fcm5NfQE6aqxZHL9+yIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CwEzOa4T1ieSq6lg7gigg+PoEo9lpc+RwKlTIjvvFQY=;
 b=YTWZ/DoRqfQ4oMrfi3C4NmRANg+ReFTYMSo3OBKLqmNvt6lAw2ZcxRH1LvF9hte+dy9iVRpcmnAAJ4JCrPodeTvyDJIWxJeJERVzQTEaIxu6c9bY114ZFFXeUaa3YdFvfnqz635sq3Z4f8L6fyXUjBZGSywyA9GRDu8YCmL86yA=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com (2603:10a6:20b:3dc::22)
 by DB8PR08MB5418.eurprd08.prod.outlook.com (2603:10a6:10:116::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.16; Thu, 7 Aug
 2025 16:06:47 +0000
Received: from AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e]) by AM9PR08MB7120.eurprd08.prod.outlook.com
 ([fe80::2933:29aa:2693:d12e%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 16:06:46 +0000
Message-ID: <96e931a6-c70e-4a11-9e8c-c5a08da7f512@arm.com>
Date: Thu, 7 Aug 2025 21:36:38 +0530
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [mm] f822a9a81a:
 stress-ng.bigheap.realloc_calls_per_sec 37.3% regression
To: David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Bang Li <libang.li@antgroup.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, bibo mao <maobibo@loongson.cn>,
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <ioworker0@gmail.com>,
 Liam Howlett <liam.howlett@oracle.com>, Matthew Wilcox
 <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Vlastimil Babka <vbabka@suse.cz>, Yang Shi <yang@os.amperecomputing.com>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org
References: <202508071609.4e743d7c-lkp@intel.com>
 <9e3a59b2-11c0-43ca-aff3-414091f04aa4@lucifer.local>
 <97419aca-af5f-4328-84dc-c97bb73ca1ac@redhat.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <97419aca-af5f-4328-84dc-c97bb73ca1ac@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA0P287CA0005.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:d9::17) To AM9PR08MB7120.eurprd08.prod.outlook.com
 (2603:10a6:20b:3dc::22)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	AM9PR08MB7120:EE_|DB8PR08MB5418:EE_|DB3PEPF00008859:EE_|AM9PR08MB6706:EE_
X-MS-Office365-Filtering-Correlation-Id: 01042c0b-1f90-481e-726b-08ddd5cc7c18
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?utf-8?B?amhlRW1za1FPQ2hxeHZTc1FIZDE1eUVsZ0FScHJCYkVSaEUwbG10dGM5ano2?=
 =?utf-8?B?T1YzZEo2M2w0ZVZWa1BwK3E0QXd0dEc0ZC9wVXo3R0NKZ1RFZVkxVjFUNnFQ?=
 =?utf-8?B?RHNhVHNHTVVVT0ZzamowSlVGMVMya2xYSDV5NkFPdi9McmVJRVZwbEwrb1ZK?=
 =?utf-8?B?WlpZb21ha2JTYmZqM3AyTCtDcmdHd0ZqdW5jQ3U5aDZvZHY2Vi9pZTFQbjMv?=
 =?utf-8?B?RnBjTngzTzBGRlArbExHR0YvU1RIYU9xeHJlcWZOTHpKWWY2OU1OMStyOUoy?=
 =?utf-8?B?YnQ0UENRenpDOGxMVVc0Q1lHcW1QRGsvUHJYQjJQNy9JS0cwdjdrTEVGbnRV?=
 =?utf-8?B?NXVENlJIQUhjNmNoSGlIZnFqaUJHYlkzcjhmdzI0a2V3akl3aTZFdE5zbE44?=
 =?utf-8?B?RUpDM3VZY1J1L0RuQktYaUxNbmdNbGZhM0pFQUZBd2tGY3A5RFZ5enR6bVJL?=
 =?utf-8?B?NFdZQ0pWUWp3QWFLMkJsWm5VUzNzRE9SRyt6dUlOV2Evc3pxQW00NEhlajZ4?=
 =?utf-8?B?OVhMaCtGb3Rad1Z6b2diRVF4ZXd2UDA0RmNQcENYLzBFWTVDZEozRURLVk4x?=
 =?utf-8?B?Q3FSZXlMTnI3N3B2dGZiSWVyZ0I0Q0ZjSkhiTDBwcFpNZHEyaUw4QzlWOWJq?=
 =?utf-8?B?Q2tvSTBvRm1YRWNxV0dGdnRDdDd6b0U5dExRR0tqNnQ0TWVIZ0hzZ01EZXc5?=
 =?utf-8?B?ZHlvSGlQUFB4S1NvalkrVkJ6TUo1Mm5rRjZsbUVPcUVWbjhkb0gzTUdIWTNK?=
 =?utf-8?B?SDN1eERWWmdLdHlKQjVLRGJEQlBrS0NpeWdReS9vMFdmOE4ycjc0eS9GSkNv?=
 =?utf-8?B?Vk5KN04wTDc2WGVyb1ZUQzhWTFNpenZGOWJOUXhQN3FFK1dUUmdTTU1SRGpz?=
 =?utf-8?B?Z2hrOWdvL3BxSlBPVnJ5bzNXVUFsaTYrSHBpeGtiY1F4SEFWTHpxS3pESVlj?=
 =?utf-8?B?dXRaY2pyQmtJRE1DSkx4OTdEamNRTVFzME1jaXg4djF1V1J0YlRYVTNCalJV?=
 =?utf-8?B?WFNTMDd3UFV6TFdZK1d1YWNPZUVhS0UwSTlKYVM3S3lSSFg5Z0o5Wjh6TVZV?=
 =?utf-8?B?QjBxN0JyY1BKc0NVck1JVVN3ZmR3SVdxekswVEh6NEVEZ1I2RU1wSUpIM05n?=
 =?utf-8?B?VlVTWWcrSzJSekFkWjRxOEFHaUtLN2VsSU5BL3IzN2U3dERWZXJXVlkxK0JI?=
 =?utf-8?B?Vlc2ZU43c3R0d1FyTGl2K3VmN09VNTFBOGtqUVc3akk2QlRiZnBXVlRCdWt2?=
 =?utf-8?B?VWZhUzB1NUhOSlBEd2wvUEtGVWtaUXB4ZXBJT1QxVHI1UFZSYnlkdjl1VDlI?=
 =?utf-8?B?WVBJOEN2K1BBYWJEelRCOFFIUVlWakZpQmxBRlVXdjJicGErdzd6NENEMzdw?=
 =?utf-8?B?NDZZWHdzZXlTYVZtMm9HTENPWGxVQjNCc0ZGUEt6bXYzUFBacFJoRGQwNmEy?=
 =?utf-8?B?UmNLUjl6UFZHdlVadGdmVUVySm1oL0NQdU9qV3RnYzd2aTZWUkZtdmRWdXZq?=
 =?utf-8?B?eXVQU1JGTjBtZ0U5N0pERTMxeWtYVy9kSnV3QzkxN2JqeDJBK2Y4Q1VhdTM3?=
 =?utf-8?B?bW9hWkpkRk85Wkh4Q1dwS01odkUxNGFOUllUaGtsMUhISHRFTmlrR2U1UDNq?=
 =?utf-8?B?bGZDRnZkeVE4R0V4ell4cGhjVkpDdTNJSGFod3c0MUtLUEl0eVU1RkdtNDVw?=
 =?utf-8?B?b3NoNGkrYXZaakRtTWM4Wjh5MDdocmhSYmVuQ01mQkFuYU5EUCtKNTkyL0xI?=
 =?utf-8?B?cS93ajhwVmJ2cWs1aG5rL0lKOURUZ1ZPWlBsdjZUYUNWenVJZEFiODVLSEF5?=
 =?utf-8?B?ZW1uQ3VyYnFpbGVOVnBlcjNJT29mQm5neldjU1I4eTdjVCtiaHJZRnhPMnBI?=
 =?utf-8?Q?kNSz8C00hf6jK?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR08MB7120.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR08MB5418
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	4dd76ab2-5af3-423a-189e-08ddd5cc68ba
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|14060799003|36860700013|35042699022|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?QUx3dmZOTWlWZTlrb2dYcG4xTmJIYXlGWTJaa3BqU05vdlFRZGpZQW5NNW0w?=
 =?utf-8?B?UzA4eHdra0oyY09vTkdyTmxkU3YrSFZlclVvMGorQThTMjFsTVFuek52UFYy?=
 =?utf-8?B?VW85bWllWGp6ang2ZEVDNWlGeS96MkVtUnQxN0hUc2tzV2JYbm9PSnFKVGp0?=
 =?utf-8?B?bE1PT2NiTTRSYktHNWRQZW9WVDNIeWd0OUZHTlR4eGRQdURtNU84NVZtaSs5?=
 =?utf-8?B?ay9PellXUEt1RGQwdGFjWTZYeUZaWjZLWGlTRXZHeTM3WGwxUnpVcFlOSmZL?=
 =?utf-8?B?cUJEcE9LUGJnb2JoYm1jVk5VbTUwQmtHVEd3b05wOGZHT3lsQjIwOTdDYXl3?=
 =?utf-8?B?R2FwK1hIY255UVNFY1RyTm1mQWRKKzBWbFYrNGdHdG5XcnRuR3QvcHYrQ01C?=
 =?utf-8?B?cFpDcnVnNkFLMWVLMmt1bjVOQlpzKzNMMVBZdnFBWWlNa2grME95ZEFJSnFZ?=
 =?utf-8?B?R3A3eW1McE00OHRLdmJlNUNXbmdaREdkNk43ZUFJMUV1bEpOd0p1YXFrd3VL?=
 =?utf-8?B?YzZNQ05oR3dPMmt0d2poNGE5WHdNa1J1L1RXUHl2MGRoY0pFWGsvMGtubHpN?=
 =?utf-8?B?aWp4SSsvbkczcFg5ZE9iWWxoT2tEZXZ5VU9PbUV1L1lZemg4N0YyYnl5L0lJ?=
 =?utf-8?B?YWp3bmVybGFkYTFZY1M1ZXRQMkc0Vmt4TDRubEgrNXROOXVJYzFYZnZ6b0tE?=
 =?utf-8?B?N0o2MVZYc3lNZVl3aHpuRHJYaFBGRnROalVkakx2aHdsSWczYVFRajhjQjJr?=
 =?utf-8?B?YnNaZ3Y4ZElHMWhIbTQ0V2lkcStDTUFwam9DOHBFcHl4cDIrQzRnSExabUxY?=
 =?utf-8?B?S2Fkc2RTYlU3Wnc3R05sL0FhVjl1U0ZiYkJvV2xjZkVCaFhJTnZ4bDlySmxs?=
 =?utf-8?B?WEZEVS82ZXh5NkhuSkkvdW9xSnBSZlpJalovZXo0WHNZNkwzRWhIZ3pJbWpF?=
 =?utf-8?B?OEZoUHFrTjlxazk2QjR4VGRTMDJwR2ZaT3NlQStmK3dkaUF2dHhZUW90dFBT?=
 =?utf-8?B?akVEWVhINTViMXlUTCtBQXJWQlpLSVhZdSt2Z25mNHNXSFArQVRkazJCbGRZ?=
 =?utf-8?B?TnNISS96dkVlZEVtU1VJdjNiWGdXSDcyMzN5S0RUeGo0NkVPRkNNdU1MblZK?=
 =?utf-8?B?dW5za0Q2MWNvbFBFMHU3VWJGNHNvaUdVaFdNYldWUm1qcDNPalFUZzQ2NFVX?=
 =?utf-8?B?MjZOM3o0VmhodHdCamZSRTVCUXhnMm5YZHRvaDhVSVg5NUJJZm55QW81aE54?=
 =?utf-8?B?elF0ZENJcXI3YU53N1pOdkJBcmlXdXF5R2J6OE5qaFIzQ0lJZkVXOEo3bU1y?=
 =?utf-8?B?c2ZQY1BCc01EdGxHd2xpZGE0WXJ0aG1GcGtET2F0N0dGVlYvTzdCTUpqUGxX?=
 =?utf-8?B?WnBLYXNockR2U3orREM1YndTdWRrbS9JM3ZOSGRSWHJOYjZwYXpSdEVVbUNS?=
 =?utf-8?B?U1V4OWZ2bGI4U0RBR0FtUGgyeitWRVhaSFQ0RUJyYkRoMnZZOVRITFNOenFt?=
 =?utf-8?B?dkNVQVVtd1k3d1lkanV6K1d2UFJ6QmxQOHBqaFh6RTRONGVUV2JiR0RRMGhT?=
 =?utf-8?B?em0zRFJpUGVMK25zZVJjRmNPUUd0YlA2cHJEV0hkSE5CMkUvaWdaM1J5ZnNN?=
 =?utf-8?B?STVGZ0VmRWpaNnE1Wi9uRXJKYTVjZk1YZVpxU2pObXAxRkJSczVxSDUxMWdV?=
 =?utf-8?B?YzNOR3NFMW9tUytmNFlyU25JUGo5YzRJYlRQTmlVclgxbTZUR2h1aVVRNGpT?=
 =?utf-8?B?VmVqenUzTTNqNmxrMlFaUk5pOCtVMnZTUXRZclIrVXMyc3pVOHZHTjhJUGhs?=
 =?utf-8?B?Y0c5eXhkWGtyRVZqWkRCNHV4cDJ1elJpSTBQa0hnK3dabTFLUUpIWlVCd3JQ?=
 =?utf-8?B?SXhlSW5vYzQvUDgxTEQ2UUxNbkNPM1dURG5mdTdtYmRkWHM5TFM4ZGlhSDAz?=
 =?utf-8?B?T0Q3K2xlWUI0eDd0TktGYiszWkE2VFJLdklGaVpmTlpiL0NIS09zSGJsRWdI?=
 =?utf-8?Q?IrnJfZRgGetGc79B727LQ2E7OXPPAM=3D?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(14060799003)(36860700013)(35042699022)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:07:18.7321
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 01042c0b-1f90-481e-726b-08ddd5cc7c18
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DB3PEPF00008859.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR08MB6706
X-Rspamd-Queue-Id: 589F240013
X-Stat-Signature: a4zramu9fsmid8oon8wboc39io9kt96g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754582843-229872
X-HE-Meta: U2FsdGVkX1/ODzjzZlstMIQrgGejsuEB4vY2mEKZmi+OHz2/hKpif7hZB+59a3tEbHdhJLNg/FX0yJoyulQMFFzjoYSkUX2Jf9ECBO0sAqGcpfQuDBKQVLPIQy2dOy9F5dFBBItyAC9nWov2Iy4qljFY8Ty1Ne6GYVk7xOuwJOIFwmocDbW+HMy1equEocV5R2JZWT1LVzZ8xANlFtTIJIzU45t8rZmwBe34IaSp/c4J7yMxG6qBkZr+KqU7FkW3GZ+eCiN6twOJHTeA/XJP+jB50+YAaWL5dHy53JuTEYMjpZ29mAMe6VBRDby52ubgtSbIAe3VGUdIT3nf78T5h5dSYtBHmGo4VP8k2jC0AuHYClbuJSvYitcMyy30MpdisBQbQemoVODa2NgLTafPWfpxBGFEzgSTkGYucaGIhVY2EH99eSBP5FRphlNoRjZ5ykok3Pr/7CGuYJ9qXY2bV7nD6Or3FObWtvR1zU6oI8QbERhM48K6pVxmcnL2EuDjDO7HghyJs6azP/5iVn8RqPuvSbQOlEGMSVSXXIoSagvJI42au6jtNUG6c0mreazCg413rCjgnQUh+Cccx/R4R2Nv1O1kGp0s/5iDziAlvFQD07HA8ZeP58Sjmpz8Y+ZjaaHEN6JBdXq7cxJFaTrtB7cvmIrp8x6TSW86dJlqvV3MlY3rjNa5gt8sHtw2RtA+99lyfbKw4vNKjclcaP78a8WnKbwpfT+djP4QwibAFpGG4/bVJLQvYglyKZNuiqryLC8PXvi6CeEjp/LyOPpkYEqwZZrOcTHB3IR41zRt7fbd8OVQzJbt7cWw229Yo344db1T6Qbytx+ra4DdThV6c4/Vf3s0q2V5Zrb1lt64y6BNkTvbJvQRe9sdlezIDwZg5zc9vf/11QmaHegYZoexal5pjYTcADfFx1hCujL3DMujci5M7jVZSS1pySgp6K34c//C+2UclBW8XGWFdY5
 sBamU1ov
 EYiZwBjF1dQdgBCEEDnmnJqWyWDy7b2ZTiV1EKcODNTUPp9y/7XGIzssZGMUpUlg0xNctBtn2a2uCUIqzkPyDMWbq7CAJt7vXOaYbWw79ogVmT05GU2e8OWa+KnnTKc0+3XJqyJbN5lJs61TTo1jTIX2C35cgVdXnh6RoX0itSZ5SAdrvIPVhC5xUdY/j4mUnZH8zCyIFykyvPDqHPUy9myHA6VRgSzOezSqk6xCFMSD5uLI0jx5NmUJDp4QAzAZCYC7Lyu8KlR8iOAbcq05d2vGQ0baunvzAgour1AXgfMC1YUPBI3Nz+FOSDN09q1GI5rvdS0MI8Cdjh/vk4784zf0N+DrjQ0KgvKTTceXpfsMdcltfKWddXPtvnmHbiUJ6a7VCV0F5rFJyPAhLDutx9dIUtQY5rFYlDEnWtKEEQ1AbUcuI4NqOw7Nd36ulendNzMygLmuGThxf4VDSTjCl/Z1rxYiZfNf5fBRDL6pPm15PhMyiDCfsbyc3mRytnULKxBPsRN0beLMb3eEpxp1BCzPQRZec5lppTqQr79fRCO/SyEDThWgbzTVyNaynZhnRAQbW6YTsoa/2oto0f5tGoIPEu0GzkWE4G8RfiQIgiV+fl6Ryb3WykZwZnLUpM6UWuKY0P3Tsf65oKBIxZKaNT8s110pFeLMry9CsB4CdhQmskWbjZMR8i1MdGXzUTZP8EuQr0qpf/1fc6Q2qPljIiUhJcIE61YJHaEnA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/08/25 3:51 pm, David Hildenbrand wrote:
> On 07.08.25 10:27, Lorenzo Stoakes wrote:
>> On Thu, Aug 07, 2025 at 04:17:09PM +0800, kernel test robot wrote:
>>>
>>>
>>> Hello,
>>>
>>> kernel test robot noticed a 37.3% regression of 
>>> stress-ng.bigheap.realloc_calls_per_sec on:
>>>
>>
>> Dev - could you please investigate and provide a fix for this as a
>> priority? As these numbers are quite scary (unless they're somehow super
>> synthetic or not meaningful or something).
>>
>>>
>>> commit: f822a9a81a31311d67f260aea96005540b18ab07 ("mm: optimize 
>>> mremap() by PTE batching")
>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
>>>
>>> [still regression on      linus/master 
>>> 186f3edfdd41f2ae87fc40a9ccba52a3bf930994]
>>> [still regression on linux-next/master 
>>> b9ddaa95fd283bce7041550ddbbe7e764c477110]
>>>
>>> testcase: stress-ng
>>> config: x86_64-rhel-9.4
>>> compiler: gcc-12
>>> test machine: 192 threads 2 sockets Intel(R) Xeon(R) Platinum 8468V  
>>> CPU @ 2.4GHz (Sapphire Rapids) with 384G memory
>>> parameters:
>>>
>>>     nr_threads: 100%
>>>     testtime: 60s
>>>     test: bigheap
>>>     cpufreq_governor: performance
>>>
>>>
>>>
>>>
>>> If you fix the issue in a separate patch/commit (i.e. not just a new 
>>> version of
>>> the same patch/commit), kindly add following tags
>>> | Reported-by: kernel test robot <oliver.sang@intel.com>
>>> | Closes: 
>>> https://lore.kernel.org/oe-lkp/202508071609.4e743d7c-lkp@intel.com
>>>
>>>
>>> Details are as below:
>>> --------------------------------------------------------------------------------------------------> 
>>>
>>>
>>>
>>> The kernel config and materials to reproduce are available at:
>>> https://download.01.org/0day-ci/archive/20250807/202508071609.4e743d7c-lkp@intel.com 
>>>
>>>
>>> ========================================================================================= 
>>>
>>> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime: 
>>>
>>> gcc-12/performance/x86_64-rhel-9.4/100%/debian-12-x86_64-20240206.cgz/igk-spr-2sp1/bigheap/stress-ng/60s
>>>
>>> commit:
>>>    94dab12d86 ("mm: call pointers to ptes as ptep")
>>>    f822a9a81a ("mm: optimize mremap() by PTE batching")
>>>
>>> 94dab12d86cf77ff f822a9a81a31311d67f260aea96
>>> ---------------- ---------------------------
>>>           %stddev     %change         %stddev
>>>               \          |                \
>>>       13777 ± 37%     +45.0%      19979 ± 27% 
>>> numa-vmstat.node1.nr_slab_reclaimable
>>>      367205            +2.3%     375703 vmstat.system.in
>>>       55106 ± 37%     +45.1%      79971 ± 27% 
>>> numa-meminfo.node1.KReclaimable
>>>       55106 ± 37%     +45.1%      79971 ± 27% 
>>> numa-meminfo.node1.SReclaimable
>>>      559381           -37.3%     350757 
>>> stress-ng.bigheap.realloc_calls_per_sec
>>>       11468            +1.2%      11603 stress-ng.time.system_time
>>>      296.25            +4.5%     309.70 stress-ng.time.user_time
>>>        0.81 ±187%    -100.0%       0.00 
>>> perf-sched.sch_delay.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>        9.36 ±165%    -100.0%       0.00 
>>> perf-sched.sch_delay.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>        0.81 ±187%    -100.0%       0.00 
>>> perf-sched.wait_time.avg.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>        9.36 ±165%    -100.0%       0.00 
>>> perf-sched.wait_time.max.ms.__cond_resched.zap_pte_range.zap_pmd_range.isra.0
>>>        5.50 ± 17%    +390.9%      27.00 ± 56% perf-c2c.DRAM.local
>>>      388.50 ± 10%    +114.7%     834.17 ± 33% perf-c2c.DRAM.remote
>>>        1214 ± 13%    +107.3%       2517 ± 31% perf-c2c.HITM.local
>>>      135.00 ± 19%    +130.9%     311.67 ± 32% perf-c2c.HITM.remote
>>>        1349 ± 13%    +109.6%       2829 ± 31% perf-c2c.HITM.total
>>
>> Yeah this also looks pretty consistent too...
>
> It almost looks like some kind of NUMA effects?
>
> I would have expected that it's the overhead of the vm_normal_folio(), 
> but not sure how that corresponds to the SLAB + local vs. remote 
> stats. Maybe they are just noise?
Is there any way of making the robot test again? As you said, the only 
suspect is vm_normal_folio(), nothing seems to pop up...


