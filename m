Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414E7C982EA
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 02:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8616B00EC; Sun, 20 Sep 2026 22:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8532D6B00ED; Sun, 20 Sep 2026 22:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CC556B00EE; Sun, 20 Sep 2026 22:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD526B00EC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 22:28:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A82E41A04F6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:56 +0000 (UTC)
X-FDA: 85236186672.11.2F30AD8
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013012.outbound.protection.outlook.com [40.93.196.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id E4AFE1C0004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:28:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RErGXx2q;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789957734;
	b=GLq2P+VFsyH2Ygr9qwFKjvZ9H+6ZYHt38Y0GQv5H6S9FjLNi1vIt/ussSaqyWSk5TGnpiM
	1OkqZIxzHn3u3EPXw5y+airgD4tdZHYa1aHlkt+aZuZwi+M7ieSHhUymgo5PiS3w8nx19p
	PwgPraDbsTncIr9DovqCSUDRxXcOrv8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=RErGXx2q;
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.12 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789957734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epRe8Wb/VKepFvI1bc1QyHqXCP0x6YAf/z95FZzFzRI=;
	b=CLDyBehU9zt4WFtY6aP8Ri28rmvitx2Ip5kK8wNS5fEICxRKkukakG9EWyV78ytXkrQzz1
	J5hhGKWTLmHEiA3PFXjkx1WuEQCmAvS91gDKpaclJLCO9aDdckonz/vmURUuo1rY7KGZQN
	wzGGMx/sgsTSCL5mJvUByI/Ao1huq0A=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SpVpd2I7wcSkgDHVOHVdWMKFZTkOdXe4rxCJ2c4hK4zpM/1Qtx+Fl0pzoZ0F7fYp7t9AL0hDVRdOPtuRu+n+TwJq3og0zflsvow5uPI6Knf/yJBWrfNYT7URurGX+By+x9dwWvz8bmClCsZ3ZXZqXcZWWSlgFv88IURhLf97IHCggl6oOv0RzOVcKJtnrZIVo4iqGPJ6Fsy+kV/VkbbMjVlReLWlEPa1Zdd8IpPASStzwKxP/tjtvnus1rvjtjwKCc6NlvNA3U1Bx0+EmYZtoBL9/fyhL5dYSp5eymexRU8Vv2dlbRKuqrlMGYL4ejStBRxJDCoiUkijOHpg7yw1wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epRe8Wb/VKepFvI1bc1QyHqXCP0x6YAf/z95FZzFzRI=;
 b=HzfCaMFSY2hZKIhyWbbJCsCvxGNO3ag/QOVHns/O5mRGtk98clHe9/8Wf+M3XWGI4LuU4g/3XWw1EVPEWK9VmiNju0/lY9Kp4RMSnt1Y1oxCQIjtwNMxDok3RdQDWlGZ5voBgbRwBL+6jqooPaRnMNDXNtUssEQofYkwuWsVQz2+FxIxhQWyFIZqSJCkrLCfQioQQiexbleIY4yZf67vQi2d2725UCtjnZ76NQhrYXcCRvY2/3CK981zejD6JDsqYbQl9epWiG7nmB38ryRjHo6yUC1BYWB2ejuBjyjSLMbj03Uhi244eXP3qUMIca5o7r5lqTh/zhAILD9J31Y/hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epRe8Wb/VKepFvI1bc1QyHqXCP0x6YAf/z95FZzFzRI=;
 b=RErGXx2qUalIYpD7HDRz/Z1mAJMDhIEKVPLyUEeRnp9Io9+54tEync5I+8bdmffiAFSk6VFrNCuN+xsJB5DqqDmb4Uhv+b+FcG2LGnv3kntW4vgJCUocAAGfR2KQUt9R2HremSgj65U/I048U2Ir1Oujh54bNcFV8lyp01rK0XMl38+anFUqv2DT6ss2xtR3tbp+zCU9VR8g47VRKRBAwR+UpULwzTqeoxi9nURsoHKBrw6qK6PygA8HyiXbixRwHiaIMxWgbPHkCVMNe3NrlPEB0+ypbFlAG6D95l1XNgd3bBbkUVA53lEbe7Cm49H1PrnR/CrKiNACxGNgeHyTBg==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by DM4PR12MB7719.namprd12.prod.outlook.com (2603:10b6:8:101::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.428.16; Mon, 21 Sep
 2026 02:28:38 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%6]) with mapi id 15.21.0428.014; Mon, 21 Sep 2026
 02:28:38 +0000
From: Zi Yan <ziy@nvidia.com>
Date: Sun, 20 Sep 2026 22:28:09 -0400
Subject: [PATCH v5 13/17] md: Use folio_alloc_buffers()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-remove-pg_private-v5-13-bb68b6a21869@nvidia.com>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
In-Reply-To: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
To: David Hildenbrand <david@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zi Yan <ziy@nvidia.com>
X-Mailer: b4 0.16.0
X-ClientProxiedBy: YQZPR01CA0030.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:86::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|DM4PR12MB7719:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a4f9982-132c-4e80-ffae-08df17880b87
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|23010399003|366016|921020|10067099003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NeueTMIl+Tu+DUgRylNKhpUhVxRcc0i1fppg1RZdH9h7UY3AehifAZ2MMG0FNgPgT1r3878wja52/Bf7+ICeXzANkFBoy9XnfIVVnVyYlrqKCD6XA9Sb/thg2bF/NUyd6bNmX4MuyCqDnn+y2yRRFroYlmMyo39qra6h8lsS8QbssAsqijHgx7gQ3TH/T0Va/TC1m2QzR+EMCyc9ZKTNInivyQsQpsdPRERq4CkKfwI9aibdljVvvhE2E73wFVWy4GWwEfj357OLX392ZvKFndqyx8UZo3qg6sEPFsG0RyLqR46ZmIdjwIcOvrZkzHt/09Son7z2ujtVqQMkUyaN5EZg4G5DyM1ZVdNrp89lDyf5LUHQ3F/hNvFVgVC6MFDYXuT/6FtKhy/CsWW43KrPXxcT51RhJ4QutJp2WOgEnv2WNXm2RGsqDybjRSCklpaPccZJ/3cZpYX04gJ2BL3W4kziCc6c8F8dcsVjWP08NqzBFE/BYzKaDzarYNHQD/4VSNIjS6gVNsFmmDbMeTn3o+gZbvGHTAHv/yMivkWPMEzp2TRqna8qc4+DzopZrfTZrAucXehYTpVx7tBmge4YaYIQva25/QGs/ayreF/NtLIDskeXrrAj9EPMBqFxax4NG0RQtllPzmL0fRNxKAcKR45oiVbQaQFxoG++hJg3Iir3f3Np8Qlgv780z1OKqAx6q9fG20Qc2HHpSCDkfCLKPQ==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(23010399003)(366016)(921020)(10067099003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RHBXNDh6WHQ5TTgxT2VWa2Z4dWkwODFUYnNKa0tmWjRlOFlIWng2bnRPeEVz?=
 =?utf-8?B?Zlp0WHpkVmNMUzM3cG00VGxsbG5BdGNpV2ZPbmF0b2ZiTWJBNENibWlVNGE0?=
 =?utf-8?B?VGJFek1hN2h1SmY1MlNad1FBSHk1Z3JhMUJvTDNJMW5FTkR6VzQ5WmVuQXcw?=
 =?utf-8?B?ZUc3ZmNHbWxpSm04VUNxUGxYcHZCay9SbnlDbVd4Y3N5a3BwcHEzcWJYNUI5?=
 =?utf-8?B?SVdYQnFPcFg0RjkvcmtoMWwzZG5mc2dzSlVac1o0WUN0Y1pYUEgvL1p1RzVr?=
 =?utf-8?B?TStLN2xGbEM2LzRZMm1sNDNLZFFXS3FuZnlPTWpnZ0x4TEd4eUFsOVBqSlBX?=
 =?utf-8?B?NkRvTnE3M25SUzVialB4ME1udjd5VUhUeGJrVlZQVHVxQ25yam5yckRYYy9V?=
 =?utf-8?B?Z01vVTJETzRFcFpueEMzRmFraEtSaXNkRlhmQ1B4SkRXNk5UUHBCYVBLenhy?=
 =?utf-8?B?VW1pVnh5cmhmTjducFJJT1ZCVTA4RnFTTW1taUYvRGRFdm1WWFpLbVZ1Tzgw?=
 =?utf-8?B?TG5zZUFPT2ROd1lLOGJVQ0tGMGdwcS9CcUt0Y3k4aHBUTGtNNzBrV0p3cHBH?=
 =?utf-8?B?ZHJQQmF6WTRsNTNMcGY4MU5NWlJzMnNSTzlwOGlmWXVOMkxZQkdJT2RBWE8z?=
 =?utf-8?B?NWh2VU9qSHdSQlNTcDZEQ3R3ZTlUSXl1MnRncFFGa1c5QVVmRGRybGxnSkxq?=
 =?utf-8?B?bTJUS043Z0RneHpuM2dJdnM5Y0p0Znl0cFhicktGa3Z3RWJIOE14ZHVMSFEz?=
 =?utf-8?B?ajBEUXc1b0E0ZDRjb3N4aUpQMVRxaDNSSVYxd2NDZkZtRm0xUzNoS01Waytt?=
 =?utf-8?B?UGptMW4yS2s0VlJPMlNVUDBkZFBvWXBMbkU2a0dFYXdqUzRvNDlQVzlQYWhV?=
 =?utf-8?B?NkZxeGs3czBiN2wwVkNLUm5lSVFjUWlvbU9LcE9FdlJMV0hvRW5kcDB3NDRx?=
 =?utf-8?B?ZGlXZy9OTzJwQWEvaTFoSUNQRHRzbWQzR0xZSUxaN3Z4NmhZamw2ZzFpTnhz?=
 =?utf-8?B?L0Y1cVVLRDI2SGV3ODJoaU9rTDZIYkhZazQ4NmNSVktMcUxMekUwSVB6U2Uy?=
 =?utf-8?B?SFV4SkVwTHN4bXVHZjBBMnBwZk9LNStYT3Y5OFIrbFk5WTA1U3pkQTBwV2JZ?=
 =?utf-8?B?b2w2ajN3djRITTZkaWNuTFRPMXl6aWlUTUZnT1Q3R3YzQzNEZ0pZQU9GZFBt?=
 =?utf-8?B?UlByKyszVVpuS3J3Yzh1TjBhMmlINnJaQXNoTDJ0N3dOSElzdHhDMXdEUS9C?=
 =?utf-8?B?VGdXbit5b1JoVjVzMjJlVzREaGpuZXQwUlk4Y0h6RUVRZmRqZXUvSTgwVXhX?=
 =?utf-8?B?OVgySXp0YjU0UzQxVWFGSlJrRjV0Yy9LOWRDYm1pbFdraUQvTHhDd0VhKys3?=
 =?utf-8?B?aVFCNVJLdVU5V3ZUcnptM2s5dU13b3VqS21TT1lVdUcyYXFoMGlZai94TjRW?=
 =?utf-8?B?a1BIc0k1U012VnNPV0E5OGg4Z1FKakVKWkgreEsxVUd3cXpMWXI5VWJZR3ZH?=
 =?utf-8?B?LzZpSktCQnlXd2RVUmNzZlhOd0ZiZUt4elpYN3h6OVR4dU1QRFZ2SkU5dC9V?=
 =?utf-8?B?VjFtaEl6VTZaZDVJVHdwOThlcW1CYkxvejlHZUNEdmpodjBkblFNTzAxRUVP?=
 =?utf-8?B?dE1tSmcxUG91dkdGblRuYTZ1dVU4T1J0T3h5ZlFReldrbG53ZDZHdW1sL2ls?=
 =?utf-8?B?OTA4bFhQeWpTT1hXZGx5ZWxLeHBPVFZjWHZ0OGZZdklRZWVuRGVlckk1REk4?=
 =?utf-8?B?RGcxdWpSMTNwZjdDSFJYYnROTFJrWGh4VXlITHEzWTgzUUFBbGZRcHhoZCtG?=
 =?utf-8?B?cE9Gb3BBWnVBOVMwM0c1Z2pyeVJhU2hiN3Y4R0h1Y2ZLRU0xNEt1Nm9YbUZq?=
 =?utf-8?B?WEdER3Iwc3FhY3I0d0JyYXh3NGdzNndzeGxJcS9YbjhCSzBTOFBieWIzdC9w?=
 =?utf-8?B?OEgrR2ZMd3RDdWo0Y1dPOUdVSWY5SjFBUEo5bU16UTVkS2MycHdHRkFhZHhL?=
 =?utf-8?B?d0crU0pGZEhqS01ZaytCK2taRC9kYTFORFM5SVZ4Ymd4c0dNWTVjak1LdWtK?=
 =?utf-8?B?VDhYY1U2UURQQmQ4TDVNT0tTMEo0ZDBSalZNNW92NU5hWHFQd2xDaGowN1Mv?=
 =?utf-8?B?ZDNBWTVzTzQ4eFpuMTQ0UzBnR2RBais4WTVTYnNZcHA4NjJ4dUN4V0ViK0xt?=
 =?utf-8?B?bkh0Wngwc2NLbi9VYkptL0dwSTBnY0FBODZ3TXJpV1BoOFlHVTJSUW1Qb01O?=
 =?utf-8?B?TDZvdE1vS1RwaUxveWR6RFRMTDZ1dmZnSWw4OXg0bEdRb3hqeFVCdUdTSEc2?=
 =?utf-8?Q?pqv8VEcxAEaDk2ipjE?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a4f9982-132c-4e80-ffae-08df17880b87
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Sep 2026 02:28:38.7444
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jElr/b3a7eme6XyAqmEl+5Vef1Az2qPc/0WGM78loV3ZkvQCEhaO8Ljv824fWjRB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7719
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E4AFE1C0004
X-Rspam-User: 
X-Stat-Signature: r58ob16hjgrsmbkyifnii7cr9u6ec734
X-HE-Tag: 1789957733-337469
X-HE-Meta: U2FsdGVkX18Ux4qRc0W61Lm/VdeJD+n2SH4e/Jh1R+f9xsaPHh9ljI6MX3dEeRA8YkBTz/5sWUWbOsM1XFByPtWfgyOrx51p5FOyekXFh78+YJw3KiPvN5K02IiN80zQnybPrdEOyVs9GQJHDQjRTi3PmRh7m1ZsL33RcfGKwPYPnbpGk0sb6AUQnVz667KVz2RG8gM+bscojYd44kkhR7Xz1qT/q5xdxkBbIdDXnxKvpEt97IVd/LW7iw//FsNvUlrnrZ47bbJGZ2wyjHYiEcjVzJgMjxbgz/LJSLOND04G0HkOgxKMqYMbYiFteg4YBKFWLQbpGFStxF7kptKwFRvydALxByiILY7QA1P6h+n4AkzY8jMK0YNxJMhulK0tQwWWPbbzwh47tSvOKhvW79OCFTyniJ4PixW1mj/icEMXD0uYNrpIFQHTDvoV7vxYdcbN7HMkNENcN9o6FvvS35VjIDjPna8ZMqDS8sunOOgy0CQ28GT0MNsiDPIxqzu9E4/Mywnn/EclL14CeLDWtqVXstu1TwjpqUv45jO7LRtBL+nJV0HSiLMCVQdiZEKB5FbNQkWLnBk9ae6k3DjvBkc/io7SHt2ecBg/XFZ2ofNx/zMXHZ4ZQKFXvTLxIfaCLn3QPCRkClXtJ9vOzYcpG8jMGGHW63BA+1hCsHd2WpmfBvQHWyNnWBCDaMxbYG9NF9YGv+X0xzU3T4PGNvjkw+dFYTu+hOQHko8Ni0YlPdtp1LPDvj7fSoHJuxmGRsKybTf/NaRzEeCW+KKcs3+8OqYfwzgsI3W+sBLDOiSHZhCJLyMmIdCxpI4r7TOtRxMT8L25y+kjHcUDMWaJ29Qc7ossSmVIcQjAGQmhiKC7NVn6oYEa3PpWaZtqMvyzFhLH5SgHAeHLuKA5G1zh35HSDIuWkooZspfi96ZwiOl5SpoeLM+wagPPKzRK0yZmPOBgNgyjHsHMxvsj9PJPXqJ
 WCuv4g5e
 MbWAEfzR/szkjkoL+IDFFNtRNQhKrF/xgI7IG82AmVqVe5OpbA8fKR8M32UvSOvEzdVw51vXszkWCS7ziN5jz5S7VfXxDWudDK3lli878Pytr1atJD0GDvkhuAFQe8Vzosa1e0ywz2hweiN9OJBHI03OEu/qWXZbST8yYlO6ogGgrQMYUAZdIuL3dOKCbGw0cviiMc87/7s8kKOEGQCFErbGtmK10CNEQTND1Ue00zmOY4zi+E1gq1t1SgXgsIqv5Cn/oSyRRF8HU6Xnaqr4MDh/Gu2cAOXpF2c6qCtUNjtq5oN6l13DKnDRcJJdaNGaGj65fCVxrcze+cZAWTBMdMlH33demX39VBp2Q8NNffgiNbbzHMvXWtA/drOe89F2fCPOqca9SEuIvMSfofYX8LPsN+g84YFUy1tKXsNMnwIy7i0Xioszo1YogfN/O5jcDcLaaXE0Mb6HrzQXW74vp5TJCPLU5kU7sfsAW4p+oJrhHHpySeWVph9cmh2wj3JSS5MeZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Matthew Wilcox (Oracle)" <willy@infradead.org>

Remove the last user of alloc_page_buffers(). Use folio_alloc_buffers()
instead, since alloc_page_buffers() is a wrap over it. Although
the pages used in md-bitmap are not folios, as they are not mapped
into userspace nor enter the page cache, but they still have buffer heads
attached. Cleaning up the code to not use buffer heads is future work.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
[reworded the commit message]
Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 drivers/md/md-bitmap.c      | 5 +++--
 fs/buffer.c                 | 8 --------
 include/linux/buffer_head.h | 1 -
 3 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a371..5f1637f974c15 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -560,6 +560,7 @@ static int read_file_page(struct file *file, unsigned long index,
 {
 	int ret = 0;
 	struct inode *inode = file_inode(file);
+	struct folio *folio = page_folio(page);
 	struct buffer_head *bh;
 	sector_t block, blk_cur;
 	unsigned long blocksize = i_blocksize(inode);
@@ -567,12 +568,12 @@ static int read_file_page(struct file *file, unsigned long index,
 	pr_debug("read bitmap file (%dB @ %llu)\n", (int)PAGE_SIZE,
 		 (unsigned long long)index << PAGE_SHIFT);
 
-	bh = alloc_page_buffers(page, blocksize);
+	bh = folio_alloc_buffers(folio, blocksize, GFP_NOFS | __GFP_ACCOUNT);
 	if (!bh) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	attach_page_private(page, bh);
+	folio_attach_private(folio, bh);
 	blk_cur = index << (PAGE_SHIFT - inode->i_blkbits);
 	while (bh) {
 		block = blk_cur;
diff --git a/fs/buffer.c b/fs/buffer.c
index ed966fa73b1ba..020af5dbe2d05 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -773,14 +773,6 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 }
 EXPORT_SYMBOL_GPL(folio_alloc_buffers);
 
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size)
-{
-	gfp_t gfp = GFP_NOFS | __GFP_ACCOUNT;
-
-	return folio_alloc_buffers(page_folio(page), size, gfp);
-}
-EXPORT_SYMBOL_GPL(alloc_page_buffers);
-
 static inline void link_dev_buffers(struct folio *folio,
 		struct buffer_head *head)
 {
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index fd2c7115c0542..6ce2db05c60f3 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -197,7 +197,6 @@ void folio_set_bh(struct buffer_head *bh, struct folio *folio,
 		  unsigned long offset);
 struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 					gfp_t gfp);
-struct buffer_head *alloc_page_buffers(struct page *page, unsigned long size);
 struct buffer_head *create_empty_buffers(struct folio *folio,
 		unsigned long blocksize, unsigned long b_state);
 void end_buffer_read_sync(struct buffer_head *bh, int uptodate);

-- 
2.53.0


