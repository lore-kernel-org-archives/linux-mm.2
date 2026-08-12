Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0771C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 19:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7577C6B024F; Wed, 12 Aug 2026 15:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708CF6B030B; Wed, 12 Aug 2026 15:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CFC16B030C; Wed, 12 Aug 2026 15:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15C7C6B024F
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 15:55:08 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA0151A0499
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:55:07 +0000 (UTC)
X-FDA: 85093671054.08.8789B0A
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013058.outbound.protection.outlook.com [40.93.201.58])
	by imf23.hostedemail.com (Postfix) with ESMTP id AE5A3140003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 19:55:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ar3RaPY8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786564504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qH8XOw/3VOew747SPM4l8MACIp16F45L9dCTjXbSkAA=;
	b=6LjEwHUA232+YPtxXMBcSLv8ktMKFCfXG5pThyH0XZ0WVtESjGfFKCXAelQcO1s+YAkwQF
	e3I0CWuXVCLkpWOGId4gzoEhJIfmUhH/CKjAu1fG/X8W4R8BVFXjdmjkkfcZGJ3MtXE5fc
	u7FcfWc4mDcFa6sDSOCf421GpgQpsGA=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Ar3RaPY8;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of ziy@nvidia.com designates 40.93.201.58 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786564504;
	b=Ym5R9XSEDz3TxSo5UssWJTDqVfteSHWiLwkgRzBhsuY4IKBpIkeHnRWYOWa2EhwItd14SB
	uTP2k9gR5n9LKkW8/KBXp8LDrCEspjSdoECJHvaHwvuKPBDMTu/jSqd4MUzxJEerpJg+M2
	xP/KOWEP6SxhwVo9pUnE8JSkwjlsowQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVTaokpvlRmb/pe5nN9+RtofKU9Foh9dexl42n2UvSSLbRyXOCl7vjlwQOl+lAAjm5z15jrvFXFbrVjHmsxF7g+v3kjuCZ/wIc4NaIZ7WVcHiZGIgNd2eIpTYNUqE3j3ZtfP+dMc8sx2iKJLdzW5eSqQtuCeAEuM+P0UGAKXeC/u3Lo6QkvASOuxEStRzXc05MY3vNnwVoWU6AVE5F7rFOPUXiLocjv3NxJXQX0ZdqT5NeT5UykxPDkbpRl1T1ch4XxvI9Qh/ZEVI/RQgfiW6IDYrnLwFn8YPzQ5naraoSjnTLCELdhbUpJFa1bD1jI0uJI+ut6lo139Z+z7MWTq6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qH8XOw/3VOew747SPM4l8MACIp16F45L9dCTjXbSkAA=;
 b=u1oUC+z7dQRR+74qg2DtYEgXd5DVPb+a16KN+R7g63V/fb6hmcRVmVvRy5spQh1bq+fT1vomn9AWfVHlk9o5ugf64Ls0rVI8hQmwpJPd46Cf6nWYmo15S8/J2opAH7RGcewdAHJzojji93xAPuVPduPQVSFgNsIk7V4vccpQl3mw+cxQvE+BQCDMw0hyzpXCtJrk4+gqYSZgYXkYUHkJZ3GPk7cXTDuS2MIYFmhbttLTPfRWyrjrtA5vwZEwGYXV4M/w2z7f+TfQsnJE3v7xs6YXLf5YwFN5mP01PY8KCLwbUrev8bPSVJwl9VuXbrFP1tp/vDuafwulUBExAX6QEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qH8XOw/3VOew747SPM4l8MACIp16F45L9dCTjXbSkAA=;
 b=Ar3RaPY8bdmdS/HlbheQsJYwcD6ktEn5MKkd0N5RYT1b1SPDf4m+G3dOodo3xZbdMA9qoxrMtbdOwuDEFYfpEZ2jUElFVW2jdKJcLul2QaAiYJyrYSUn4kcjYb0MCWkynOjblvLse3/iyviSbsYQ50JUZ9gdW6nQ9oCwMEnmZYIC7IKxg/h3TyfijfEn6Jbchug3cLvKDOGjYRO97nV9X+00aLh2K7MlGUZEgKCVwxKTr13lQV5wn2vakrWAHrosSyAYlPhERDxdAnYm1ee++FgagAi5pWTTlVFiN/RZqK2zgNZmJekYgbZbWGOFOzwoWTUHZf12MMejfY3tmOzQJw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by PH0PR12MB5632.namprd12.prod.outlook.com (2603:10b6:510:14c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.14; Wed, 12 Aug
 2026 19:54:55 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0315.014; Wed, 12 Aug 2026
 19:54:55 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 12 Aug 2026 15:54:52 -0400
Message-Id: <DKN899JTB0XD.LS24C11HEWIJ@nvidia.com>
Subject: Re: [PATCH RFC 09/14] mm/page-flags: check page/folio->private
 instead of PG_private
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, "Zi Yan"
 <ziy@nvidia.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Jan Kara" <jack@suse.cz>, "Mathieu
 Desnoyers" <mathieu.desnoyers@efficios.com>, "Matthew Brost"
 <matthew.brost@intel.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Byungchul Park" <byungchul@sk.com>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>,
 "Wei Xu" <weixugc@google.com>, <linux-fsdevel@vger.kernel.org>,
 <linux-trace-kernel@vger.kernel.org>
To: "David Hildenbrand" <david@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Muchun
 Song" <muchun.song@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Gregory Price" <gourry@gourry.net>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, "Alistair Popple"
 <apopple@nvidia.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>
From: "Zi Yan" <ziy@nvidia.com>
X-Mailer: aerc 0.21.0
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-9-142c97ba3562@nvidia.com>
In-Reply-To: <20260731-remove-pg_private-v1-9-142c97ba3562@nvidia.com>
X-ClientProxiedBy: YQBPR01CA0168.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::21) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|PH0PR12MB5632:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c5e0d9-3253-4f00-e942-08def8ab94ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|23010399003|366016|376014|1800799024|921020|56012099006|10067099003|4143699003|11063799006|6133799003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	iOIJIdlHQmNT60qraA4OCwbIiVQcElMu2sN5xKF89+kxMl2e8TlnVgDzbAtsy1RqNx4cQkIv+9gdi5/YXqr6SAS2SgBEzpIsiHzkZ/kZrEcXEj8IM91sM/TYqRUdIZkgrDyd6t5RJyMGByFj3oVEapVYS9MQe9l6dShUdNyJkj9XYwCSKidYih8iQQFUXk/PnHfFjJ1YErPK/bE7ojcQIxcpG9qcagXD170y0fqdbvvv02VaRpb+8RngPJ96NFFKOPEQXdOr/kqMBAFK8bp1vG44EMEwTW8UhIpewmiKx3dirTfzE48vyHC8MGUwLxp2WKY0BnV3/BECNk2Q1qP6Bi3gFTrJuTZSQcZb7cU8EzA/c2rAyhGREurQHw296QT5Bn7e9GDWwU2DTag8Rhm8B9nW7/o7fG91g8d7c2sLFkjiqTzyF+7CSnzMItnJTmzZaxldLEdFciFSFqZCopRPs+uh5CpqRLnt+zvOSL3hPd3jt7EACrVPNEvj7TkSgBQnTIMD3eZNXuR/9/uLYiAkQuV1WNnN0zHWJmVjHIwN6uDlb13hNOrA8o2sDTzErg1AFgF1LuGfDUY+5BHWJdSd0ofyn3p1K0NhssAP5mcaDDfd1QDn506rxRnMCERchW/YwGjCWGIg9ewNI/aV3W3aNbcHyn+Rp2WiLEGsYmDXpLJxdUV9UcuPzH7GuCOzZpwWyyrj116OcsrsJJ1lBzVDAQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(23010399003)(366016)(376014)(1800799024)(921020)(56012099006)(10067099003)(4143699003)(11063799006)(6133799003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dGZadVhURVFwcGowOS95eWUwYnhLR2M2a3ViU3JvSTFXZ3NRZ0FCY1BpaHBZ?=
 =?utf-8?B?MjdNbWdRdWtaSktVdThVNUN3aUVCN2tLWXQyckhPNUtHbFRuOG5nbHZWSmJZ?=
 =?utf-8?B?dDlBZHY3WGtZSWlsZDZQeElRNGtBazQ3VkY3V0UxUlZiZCtON1IyYmhMWmNS?=
 =?utf-8?B?YWF4ZnZWcHZhZWN1L0toaEx2N2VrdzM5bVptYlFTK0laR0JYWFYrN253Y2g2?=
 =?utf-8?B?VS9HK0xyTlFma1B4NHVNMC9uS2tMZ0lWeFZoY01DeTJ3cGs2YkdkMVNrSEls?=
 =?utf-8?B?TkRrdlNqWVdsUFBBVkF3QkY1TkQyQXMvQzRHczlEdndMYUNGVjBaTTZ6YzVS?=
 =?utf-8?B?T0dNN0IzYVI5Vkh0ayt2VXN5TFhyUUlkODNyVDFhaU9DeGpyQzgzK1ZRV1Bj?=
 =?utf-8?B?a013ZkVxTGh0UjhRazUyZlVlK3pEMmpBKzN4QjZ2Mk5HK2xmN3orRk12TGdH?=
 =?utf-8?B?a1lXUVZKaXBFRGEycHdoZkdiYWJvRHowSGpNUkpUekw3a3VyekVTUWozNWZS?=
 =?utf-8?B?OGVVclJsaTlFVGU2UE1RTWVvK2lIUGc3cjh5NE5NOHBOQzlqYjV4TkU4ZE5w?=
 =?utf-8?B?eloyWHNRbGlwZ25VcGtGTkcwR2dvSnZYOVF2dzQ2Qlg3Rm9ZRlE4b3Z4QVJN?=
 =?utf-8?B?SWtPbVBBNlpuWFRjVElyWUhzWUs5czFaamZaVkRvNXVCR3l0TXJqc2F1bytW?=
 =?utf-8?B?MllOeWh6YWRacFAzYlNvdXZUdERTM0FjWVBwU1BRTlFHV0FoditxeG1TNTlr?=
 =?utf-8?B?bmhEc3YzcENKVEVFbGxUTFJkVGVsNWlwQXFXWERMYVBRcVVJYndQeUFwUldS?=
 =?utf-8?B?U1ZJSVJoU3I5SHhzQ1J2UEQxVVRiYVkxd0s5b0RpT2dpNFpBNThnUVJmVnp1?=
 =?utf-8?B?Nm5pRmhnQWh2Z1dpcWNiVldVMzZHOC9wUFhaR2JOTnNMc0tzbHJsUEYzN3NP?=
 =?utf-8?B?SDVNaUsrMzd1K25UM3lpQkI5RzN2WWV3aFJkaEd4UHZUVEhyNGVnVk40TFFI?=
 =?utf-8?B?aFd2TU9WbEpyOEtSL2FzOURreDVmV0JGN0wwQXNFb29uSmlrV3kxc2xVV0lZ?=
 =?utf-8?B?QkUxbzZhVTh3WEJCa2JvRGJLREJQS1FZUERjSUxQdXF2WVBGQlYwVVpaeVBY?=
 =?utf-8?B?ODdINXlEMWhIamswMWFPTjRPUnlzL0pYdUF4YXVrOVVOdFN3TjNzSXRKZE5a?=
 =?utf-8?B?R2pQcTV0THJwdFZqUzVFcnI4YlBDa1VyYjMzRjFlK1RISE9rQUFlYXMyQ05Y?=
 =?utf-8?B?eGFTZDVSOEtmTW9KcXNvY1Y4OGlUV0RncFJ6UDlONGxJeS96alBqVDRiR2lO?=
 =?utf-8?B?TlBFaTVFeEhFZlFYanJuUEZEbTR2dUdobzFmWXpLc2J0RW84L21kUUV1Tmdj?=
 =?utf-8?B?dEVLOE1JUjFxZUpkOXAxbi9ITDYrbTNvaGY1TVpCSkpLTytSOEVsbUVvVHR3?=
 =?utf-8?B?OFJYZU0zNkJ6RjJtU0ZueDhVY3VjUUpiK1pBVGhPR1FwSVcwcjlWaXk3TVRh?=
 =?utf-8?B?TzgyTUxmZ1cwMnljR1ZkazdlaXA4V0NzUDBoWDZQSE54VnBwKytsNDA3aUpJ?=
 =?utf-8?B?S1JieEVNVXdSdkpxVHlORmsyMldkTnpEcmRDUnV0Tk1HRzdqS1FGRmh0Y0xv?=
 =?utf-8?B?LzJZUE5XYmJmWTdTdHRlZTRpQ28yWGg2dGJ2STVwOXFWZjEwaHRCczZlblZP?=
 =?utf-8?B?NXk1azBsMStvYWpTb0JOWlMxRVNVVEtJalVvNE4vRU91M29hRndOOENLNlFx?=
 =?utf-8?B?QklEa3ZMTCtDNnBhNUdoOE5FYjEvNmZpT1l4cHBYYWZDSFljdlgrK1Z2T3VQ?=
 =?utf-8?B?L3NaN1gwZmZlV0lNdXhuZmpjVGJqRVRWZWVWNmVBbktZVlRWYUlVZjg2TkNa?=
 =?utf-8?B?bk9CbFZWSGhoR2s2RFNnanUzWFdtOS9OTUFUeEtSektOVmNqajZjSFNMWEpX?=
 =?utf-8?B?RkdXNTcxWlRka3VzNWk2MDhnd2lUaFVqM3N2MDd1N0hrc2t0ZHhlVDRzQkNG?=
 =?utf-8?B?dVl6OVZ1cWhhU09zdTJ0VGprVmFaamR1NGtYTDkvT0lsRGQxcjQzTWFPQzc2?=
 =?utf-8?B?ODExUDBwMGpaaEROT0hDRVVGT1E3MnpIVTBVbE5BRERQTG0yZ3dXTVpZcGZs?=
 =?utf-8?B?SzhsTW9wd0MvdklGYS9sUFMyT01aWUlmM2xQOGlORE5SL3RCUU5nRWdURDlV?=
 =?utf-8?B?bkdQa2UyMEV4dXFicW0vY1dJVnErNzVRNEtzbzM2cWp4L1BwazlVVW9zVlRs?=
 =?utf-8?B?L2J3NWNpL1ZIMERwSkpldUVHcERVL3JVQ2phcVVsTlpFaUthUHpma25jOEdI?=
 =?utf-8?Q?Mb2NXT8sqV2pnfRpWF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c5e0d9-3253-4f00-e942-08def8ab94ca
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Aug 2026 19:54:55.4394
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vz4z8VfwFJgIKo4SYVEq2iw3PCf3uG1LhWHTDpJFRtb4/P3x3Z4CsCcgEojZSbc5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5632
X-Rspam-User: 
X-Rspamd-Queue-Id: AE5A3140003
X-Rspamd-Server: rspam07
X-Stat-Signature: cb6hdn9rqao7npog6e8jydcjicb414h6
X-HE-Tag: 1786564504-993329
X-HE-Meta: U2FsdGVkX1/8EtbCBJHopga/7icriue9dK/OYwFnid3PKrQ8pVRKRzIb2LImfRcOpV1TjKmYhxqYNl3/+bF+otcrqfd1RuffHQlWIwsmxcjnkHUihgh/zaKKH4FajUCuJkMdPs4SliYYifsOLDGUo8xfNnizcyANpksfD/rPYLjlGuTYLg/fTJzSKWpRvq8Nzhw1R4+t8eWh7Yu1lfUP8ZJKvl0+W5qv13dGVtqaQeC2bxcql4FJEu1ZecSLXTuHc+7SdviCV+oLcT2/qqCexXoe5WY2/mMtNK7OZ5FajT9Xm+S9KfUVo54x/DD5u1zip9/A7X5gmWfOZclpSbLOakF2wDr1aKaag0g+0zCahamJzqGXD4cJEehWyHg16/LQlVnUwMou7ztG+TdoFLgYyJexNxXHDatCXbk5qdtrhU3XM97dy1zBnTG0GvuBmMcJ1npSoDC+bCPGPDm4FLdlwg10BGmtwwFFOD5Q8BBuSIjLlQnpR/QG6GMCxW12rN3Hg+tGYg5SjpBAm8rR2m8X4maYB4HHB0cwbRo1L45hh/qa3GzX8iSZ6gxWkdUNFspChSeHE33kEHatGTBrtjY24NenovXmP7dnqsOc3cru2RCc7OgoaVttBPS0SlLbmiWBK+khaO3BDXbt6Wb0t7s4k1IqTjzcrh0P20uhJLRNjPmafUFSOCCefLoKnq7NT2QZPuqwmXXAEP7wNIJl7r0kl9dnnL65u4uVMn/ZcPUtQ1UGueX5cXbCO64QTcpVZR8c5cBTncTKOLSEph62t39ZPWdcwiZUqSyVnGE3/NTgoojv2lrvu+sWSzAXgfeOxg3yuF9+J+yrdBtdkI7yQivSV9jg6cFStriMTjcKw4LDco8ad9efpk+Kj9/v/dj4mjSWDNtmHzLg1YEtbviFdnuuYMtCzMiydvXUw+YAg+V9POlFgp9ELRrGRjpmidnCzudNsmar01kK685iC2nstxo
 fOON0aFQ
 ddF7ybccgCy0WIzuguyXTCMDZLBF+IdSp4WJXTsqV5SU4EAocnyubveBJUyLeycm0gM4dm6xZAd23VFCNBrM8CY1k/9Ov4x0O+UC4XqN5Ony0tp6Zsyirdj4w1qnmoftsVisK6Dy8kLC7lIYj7J3zvJWOTNOrq5unfqCDnSB/GLvHneeYGtbnBDmQ8yFZQsAsiA+qNW7y/IBdaORq1twYL3asxfZcQG1W4XvrnsoSTJBcykV1O7SztnpisFWW4tv4M594dijdB5OliBuq7+ykMuaveJ4SPQLedMiNbu0/MOdWgKtjtKS+/PHLNTQM6q6HdMic+c3yB2K+aT75iPo1Ixf3WLtbQDnMKBJg8E26bBuKqbwUFapxzj7UHPe1KWW6UQIJx4TUT6YQDR8FXqga/8KO8yFtP2B0GUl1ynEm1KWWoQ/RvSzshO1QoBKlvOOq/IjdziMIMDq6yx1E2+yY1njWlexTWTWToxzdXr94ymJtJGvCZUfdWlUwRjZdAL5QLza/F/8GGDiBd3agotYgvys0EBdpSXX7Xmiizd40dsoFKa5t6iUqMwP+0+ic346XHj2avI5FnhadDNYOBoAxPdJPpYo0I02qMm/fSmIo3234FSfap+zmV58jVDdshsAGZAEghGCsBmnP6S7HOJKt5wRndMQk8IO9nIMIHza4HL1s/pm0mDgL4yn3dAAyam5Ueidxbf9bzz2dFIZzwpFgIlfuusMekeOMiHpbHp5/EtSAg9fuefb/LCc6Gw0t/GsxPsdTJ9lKOf3+9nuPQu75wv25W0K4hyfwg8AwTXRQ5pZlYkUbt2tjcDl972rvlM9LtD2UcCkYCytUt5bgs1utdItaYr6LzmDbqbw0ByhVJBJH03DxRDCwpAIMfCg9+ppHhVuEN7bvTB0/6AbZjmyzYy3oFl+KZDoKhbiY21C2M0cMqPyL+11oIiXI2TBexSj6VWHabl2Heu3B8V9qy8/ieqQcnF3Y
 eHQAJEo/
 TLHB+ZO10CSBhgbQmZTwRRoe/NgzNmE5//ujg2hzUFBs9RKcsKA5sMPIH/IvraDuHzgdiqE7BRO2EdTOQQNkIGX70ZzEWSVf4LZX3frAGLstNviKLj39Ze2sM2EQIEmGh8QfNYUoTzflIL7QdCwQ1frm3UlcU9gNoDIhLy2dEhUUJ1ALfouzoNwE6OQa+8Gv7lBDfgQAMWqnlE4AHBYyHTtDwH7Oui6a3yu1cMfm8eEh+z1OFjl3H0yqDUqOUEQpQhNN8YbwdIG9N7Qv1NGUjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jul 31, 2026 at 10:13 PM EDT, Zi Yan wrote:
> After the changes of the prior commits, page/folio->private !=3D NULL is =
now
> equivalent to checking PG_private.
>
> Stop checking PG_private on pages and folios and use page/folio->private
> instead, except swapcache and hugetlb folios, because the former uses a
> field (swp_entry_t swap) overlapping with ->private and the latter sets i=
ts
> flags in ->private. Exclude swapcache and hugetlb when the code is meant =
to
> check PG_private only.
>
> folio_set/clear_private() and Set/ClearPagePrivate() become no-ops.
> PG_private is no longer checked at page free time.
>
> KPF_PRIVATE exposes PG_private to userspace. Change its code logic to che=
ck
> folio->private !=3D NULL and exclude non-pagecache, swapcache, hugetlb, a=
nd
> anon folios. One minor semantic change, for orphaned pagecache folios
> (mapping =3D=3D NULL) with fs-private data will no longer have KPF_PRIVAT=
E.
>
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: David Hildenbrand <david@kernel.org>
> To: Steven Rostedt <rostedt@goodmis.org>
> To: Masami Hiramatsu <mhiramat@kernel.org>
> To: Lorenzo Stoakes <ljs@kernel.org>
> To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> To: Jan Kara <jack@suse.cz>
> To: Johannes Weiner <hannes@cmpxchg.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <nico.pache@linux.dev>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Usama Arif <usama.arif@linux.dev>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
> Cc: Rakie Kim <rakie.kim@sk.com>
> Cc: Byungchul Park <byungchul@sk.com>
> Cc: Gregory Price <gourry@gourry.net>
> Cc: Ying Huang <ying.huang@linux.alibaba.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Qi Zheng <qi.zheng@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Kairui Song <kasong@tencent.com>
> Cc: Axel Rasmussen <axelrasmussen@google.com>
> Cc: Yuanchu Xie <yuanchu@google.com>
> Cc: Wei Xu <weixugc@google.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: linux-trace-kernel@vger.kernel.org
> ---
>  fs/proc/page.c                 |  6 +++++-
>  include/linux/mm.h             | 11 ++++++-----
>  include/linux/page-flags.h     | 26 +++++++++++++++++++++-----
>  include/trace/events/pagemap.h |  4 +++-
>  mm/huge_memory.c               |  4 +++-
>  mm/migrate.c                   |  3 ++-
>  mm/page-writeback.c            |  5 ++++-
>  mm/vmscan.c                    |  3 ++-
>  8 files changed, 46 insertions(+), 16 deletions(-)
>
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 260772b20bd99..abfa6f7d890cc 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -232,7 +232,11 @@ u64 stable_page_flags(const struct page *page)
> =20
>  	u |=3D kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
>  	u |=3D kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
> -	u |=3D kpf_copy_bit(k, KPF_PRIVATE,	PG_private);
> +	/* preserve the original KPF_PRIVATE semantics by excluding non pagecac=
he folios */
> +	if (folio->mapping && !folio_test_anon(folio) &&
> +	    (folio_get_private(folio) && !folio_test_swapcache(folio) &&
> +	     !folio_test_hugetlb(folio)))
> +		u |=3D BIT_ULL(KPF_PRIVATE);

Based on the discussion in THP cabal meeting, KPF_PRIVATE will be
removed in v2, since kernel page flags are not stable.

>  	u |=3D kpf_copy_bit(k, KPF_PRIVATE_2,	PG_private_2);
>  	u |=3D kpf_copy_bit(k, KPF_OWNER_PRIVATE,	PG_owner_priv_1);
>  	u |=3D kpf_copy_bit(k, KPF_ARCH,		PG_arch_1);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7fabe6c66b4b7..ebc035ac26ccc 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2961,9 +2961,9 @@ static inline bool folio_maybe_mapped_shared(struct=
 folio *folio)
>   * @folio: the folio
>   *
>   * Calculate the expected folio refcount, taking references from the pag=
ecache,
> - * swapcache, PG_private and page table mappings into account. Useful in
> - * combination with folio_ref_count() to detect unexpected references (e=
.g.,
> - * GUP or other temporary references).
> + * swapcache, private data (folio->private !=3D NULL) and page table map=
pings into
> + * account. Useful in combination with folio_ref_count() to detect unexp=
ected
> + * references (e.g., GUP or other temporary references).
>   *
>   * Does currently not consider references from the LRU cache. If the fol=
io
>   * was isolated from the LRU (which is the case during migration or spli=
t),
> @@ -3003,8 +3003,9 @@ static inline int folio_expected_ref_count(const st=
ruct folio *folio)
>  	if (!folio_test_anon(folio)) {
>  		/* One reference per page from the pagecache. */
>  		ref_count +=3D !!folio->mapping << order;
> -		/* One reference from PG_private. */
> -		ref_count +=3D folio_test_private(folio);
> +		/* One reference from filesystem private data. */
> +		ref_count +=3D !!folio->private && !folio_test_hugetlb(folio) &&
> +			     !folio_test_swapcache(folio);
>  	}

Sashiko asked:

folio_expected_ref_count() can be called in lockless contexts, does
reading folio->private directly introduce a data race? And whether a
READ_ONCE() should be used for folio->private.


Answer:

Yes, we expect that and caller should recheck refcount after they hold
the folio lock. Use data_race() for folio->private reading. While at it,
add data_race() for folio->mapping too.




--=20
Best Regards,
Yan, Zi


