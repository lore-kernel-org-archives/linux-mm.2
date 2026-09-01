Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCCA5C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03B76B028A; Tue,  1 Sep 2026 12:01:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB40C6B028B; Tue,  1 Sep 2026 12:01:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C706B028C; Tue,  1 Sep 2026 12:01:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A71B16B028A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:01:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 373D9A42AA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:01:38 +0000 (UTC)
X-FDA: 85165658676.22.C643C0F
Received: from SA9PR02CU001.outbound.protection.outlook.com (mail-southcentralusazon11013037.outbound.protection.outlook.com [40.93.196.37])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4E8744000C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:01:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="VizP/y1C";
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P/DmEx5/WB+Em+la+QvOgrNoPkDRmGyHQEe65bVuto4=;
	b=5ZJAUmKTnjA9hbDeSZeg+8w/5Uc2IfKOjdDEYKgYBGRHf4k2Up8sTPBjXGOrSESh4WpWsy
	cY/0jw5qz8EqCM1zIO6XstPFhXOFpNNbMTDV1f7EAcwz2h9ySZbjVPhzuGeDyC+EF2JX5V
	Bw/IgmSK9goVTEr2EuHMdscT+d+1TQk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788278495;
	b=vrwT0LTvWO82eo9fjjlLvk5b+Av7V2WE8Z677hw75gxl0Y9XLNjdYzkFULPRZkCm0MJQyE
	pVBAjU5DXKlT3zTtNBVPtL3xkVudkcURzdueVLxkUjfLdpYD0UjdpfjQiUvTGV9hjHEFK6
	jZguFklYLLG1VQgkXYun1dwl1Qdy4NI=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="VizP/y1C";
	spf=pass (imf04.hostedemail.com: domain of ziy@nvidia.com designates 40.93.196.37 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ShKMCidC2wy+6sr7PW47Lce/KOLSEddwCJhYU72dfyITQAsyS8M8K9VtWXwgSLcMWRgY1H+gNtDGYB/u2GqFsuqMF+yRgvs/wjjg0VUXhEubO71tDKQ8qfA62hYosKx6DFRpiUSd5hUIE+EDklyypIni2jaTIxiXzSX4+Jn54lMuw4BZJQY5Ou3R4o5dBLkDK9fSQQH/+ADvg19arSPxmwv+CO2KbyG+JDzWzSPau0CtgNZa4oSFZvOt4evNKEXGQ6zu/6bJJGpHZtBdx7CV7f51UPtmHOFZDagv7C1JYfkhu9G/KAu+7+s2EvNjDUGFr7n4yVSX8bY8XNC2aFWfFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/DmEx5/WB+Em+la+QvOgrNoPkDRmGyHQEe65bVuto4=;
 b=ucX/QHL4qyM/SoVfcaQcwezdc8oXLE0hP1RxaozVSeVLuKQHXmNT4mktSHeZWumxGt3l454nbZr5tZcnOfeCqp3CsPc9lPc9ikWOeMFrrC1UB9/NZO4Sq5LhZeWGhlLogNng76iWdx+9+7TAA0kqKjUgXuzEyf8pNgEmpfX67HFZJooeKylAGPM4VaD3eSaKmuGTb/tFbhjYYbHF6qwOu4Uk2Gd1/rVUoNZ7NbLtzxy2whLdMcIL2PK2he4imqImnDUK+SHuMZN0a/GvrBhu3Mel6FOMCx8Bo98ekfMIYGkdXDCObeiwOXlrpaE+Anwo80qjUl18LYX1ZvrQr/xugA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/DmEx5/WB+Em+la+QvOgrNoPkDRmGyHQEe65bVuto4=;
 b=VizP/y1CgmX73m0Lq94U7/1U6fsRqLVhWPgHvWvn+2L1/aFTX7ZbKfd9xOolFFj7TWg9OCnJbmZ/TQqlCn/+TFgof5QkzoPbfg8lzVU/jMhhN+0bzWQLtC6cdMWzrogMvwyh2vV4JNkienJbA94saYUriydLB5Q5t/7UsEEJrtmjGk8zFxxPaE98FhuSnUpUPgK+sSKI3G/2JDHEIWrUIwqXcnxHNgrJGtNNPk9NEHW1ibLky0gA41dgskYJN3hLWyK0oZ4G2MiZgF2SLapkMkyjYkNz3vT/4fn6c9Ob/ibA/n1PSqpU+weGfl1gpGSD5lx0QPHxV6DkzyVQMa+8WA==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by MW9PR12MB999209.namprd12.prod.outlook.com (2603:10b6:303:301::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.360.13; Tue, 1 Sep
 2026 16:01:29 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0360.008; Tue, 1 Sep 2026
 16:01:29 +0000
From: Zi Yan <ziy@nvidia.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Baoquan He <baoquan.he@linux.dev>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jan Kara <jack@suse.cz>, Masami Hiramatsu <mhiramat@kernel.org>,
 Dave Young <ruirui.yang@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 kexec@lists.infradead.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v2 14/14] mm/page-flags: remove PG_private
Date: Tue, 01 Sep 2026 12:01:24 -0400
X-Mailer: MailMate (3.0r7024)
Message-ID: <21998471-74B7-4799-9E8C-D75003D1A4CB@nvidia.com>
In-Reply-To: <20260901115542.35cf337f@gandalf.local.home>
References: <20260831-remove-pg_private-v2-0-3668159cd9e8@nvidia.com>
 <20260831-remove-pg_private-v2-14-3668159cd9e8@nvidia.com>
 <20260901115542.35cf337f@gandalf.local.home>
Content-Type: text/plain
X-MS-Reactions: disallow
X-ClientProxiedBy: YT1PR01CA0084.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:2d::23) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|MW9PR12MB999209:EE_
X-MS-Office365-Filtering-Correlation-Id: e301290c-ad93-4ea3-d08b-08df08424887
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	NaOquSOHq3qDfgJ4uRqzvyhAEdS5CRdYU36kpuxOOEelZNDgEW9b78+O5Q4eP3YaVlrr4UijSIn9owZgLgT13yH0mOEPUpeuMGsbtSiW7MBS8CcAbF9WLiEUNNvfnk1XcQQnN7zaU1WPLHbDXfUMUww6Gw0ewM0W07WNNYGt3wK4FnEbREYB7jw+BAFpWA4ZJQNd1ivvZ4aSFSND2w5zig2bJzP78+R73LLdDdFvNNxZRGrSAfiYC+EAhlb4MDYP7OGQFDKkpFUUct2i8dgxJ94TGVW486qlkGrOsFUVmQ1PTK2Tt2K6lqsJMkPTqvl3dGf56vlWqsoQtDoIe1H/vaKFCIQhj7464ZGJ3zrCFnqd8uB5fA2v13ZeXllMirxXzffl/wUYrHTeb937swoKXf1gLmrJH5klSQuzCX4qxcDX+exEWteLX5GYO7DYrusZOofsKoPoSfSU6qSqvvC0pT6v8ZlPls4maoEz6d0i/G328LHwE9qUkBnWsoQ/UxGOLh0iPUZ0iNYAbSMXCiXRQkZMeaDbFOlDQ73THkmJtqPBd6FV16w8cBfNCV2F+zYBFDZf7Xd+utiCs50AF5NMT7mg2Ezikgnl9J55IIO7gomPdHzzaO8eKkgFJou4QzhjkGlRIoclioAZpe/v1pwaAhokSU5+v8O7FYQjEx73fIg=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?pFAuO+J1iPlAakgGdD5klVJlZts7suOogn9xWqtT4tEv5sRqMe4jea4yELVV?=
 =?us-ascii?Q?2XCG0TLtN2z3dKFmdVAw0cwpsyMHA7JyTUpalLZPN9URyXAT+Sq9Htd2yRdD?=
 =?us-ascii?Q?xLnH2LoBorsh5yE4xcKgP78YLlqbrw6/hVrAKs5w6ga+60SFYggBfosImMMh?=
 =?us-ascii?Q?iUxIHppr1fhRcorKw/q5Jid4jL+pBGeATq8aXP3+6mf399d+wTJf3nBrGE5o?=
 =?us-ascii?Q?MTDVO7yQYkzeebDuKSmeJhFpKJiiyeZcVTrO/MidZJK7O4gKSZAn1q4vGH4K?=
 =?us-ascii?Q?/6I1IOeYgbHQqME6hNajy+oL0A5b8d4l+tT6zTcfHGFQEAL/J3RWcn1gq02O?=
 =?us-ascii?Q?bnDycIYAOgjTOMqLICm5s7DbhRmwc88Dh1LjYAnf6JZaI1TIg2bCLYf4+aW9?=
 =?us-ascii?Q?2aSrY/OQg33/fQwSrMUJR6sbBHM5WYjyheLJAvOuQe96H3iYKbSv8Wpl2QKb?=
 =?us-ascii?Q?bqGvLJxy1WstPxPLitsbn+JZJpm7OPbT1jqodN/LnTT869B4dwgvCwnbPrF0?=
 =?us-ascii?Q?E1YtfmaiqEI3fTKQtY2/0lI7IFuWIdhLuSgGisAlF0KFME3kEIRFI2WN7Vwb?=
 =?us-ascii?Q?zKYA5DLV1qwj2/HdvQ5GBVGlKcGeMlbdWqDsKNAYJxexKmHn0yJQJucJBV8s?=
 =?us-ascii?Q?aiZMmDg6gyeSTz02VuucwAFIhyeN9n1wOoNcs72ruE/Boa/BzQx+nzr+LdL/?=
 =?us-ascii?Q?XV79XAIyzCkcgbccjpr43AVpTaMtloahcS26bHyfqDTTT3OW4BY+0a+biEkX?=
 =?us-ascii?Q?UVInBiO65jKNDUmk09z442u/dL5mBkikJ87xQXq1SeO4HWVmXTLHYSwQhhqZ?=
 =?us-ascii?Q?U9luAlD5W1dliexKBFNpNNPUnDeOXrjeCKGHk4HFNs8qddXCUXkBRm/cG8/E?=
 =?us-ascii?Q?jptNWU1T8Hdd+OjZFmyZQIx6T8WJI545beb5rtBmTW5BYl1uIl0AEiU76+yV?=
 =?us-ascii?Q?8m6GsWgbOaCwONaOEgs5f0j4Xvjpfas3L5nmJZrjMN3AeDjqSm52eaHS0CTp?=
 =?us-ascii?Q?HaiNuILZ7moaWkfqyQ1Bil8+oVCs/SN+IrY7/o661BAcZsYHOCMUxvQlE5LT?=
 =?us-ascii?Q?3tJYzRsYuMg6nnQi0rgXCMyfJG4NMCFx4/9GIJwAr33adJ4M+wvJogEB9JDM?=
 =?us-ascii?Q?P5jGP7chR9KcQYYNk0lsnuyqIfnzh9xfsJW8pC1R8UyEhFUP29wOYJghnsNo?=
 =?us-ascii?Q?xtmXDkOcGoLGuUDw9xK5G2RAa3NZMhc9d9GOvslyEBL4uKwW/pfbhS+2ijXQ?=
 =?us-ascii?Q?acrq7HmKMhnQy2cJjLHvj+WmeNmhj2qHnqo+NkTJ/AQBbYrQ6GadoQ8u66iN?=
 =?us-ascii?Q?LXZ3+zNm+mqnXTSdOhT8DT98/F+3RFQj0sEQ9GQR95Hm+cuA8qrhIJNZ0QNk?=
 =?us-ascii?Q?vRG6/2XGBrSrOZoHmiqgip7A9giL44Mon4yO7Jb8i5HmRYXN/xCSAo/S+Iqe?=
 =?us-ascii?Q?6TKiHY7PCvgitl9Laxiu6UJmAe63KuTfgYsiODHufwEUE2wIstqt4581v3dB?=
 =?us-ascii?Q?Y7/vngztCBSpeC3vgVUfGiuY+/7Eqjbs80uLYNVt7D9IQpbXBsdQdy6e2mCi?=
 =?us-ascii?Q?LfLXSjzWKkTu5xTLf0L0Xw9kkSsTYGEmlY2MqhvTeaEK20Iz/6rH2/YHJkjz?=
 =?us-ascii?Q?6tLghKF2Di0woEWUlNJCT/41cqJZX8ypgjiw3BH2GnnJlXz+OWbczUQiemPL?=
 =?us-ascii?Q?C7LrNuZNxCaQ8qsdw8TWqm7yGWPfmdFXzSd6n96DeI5xGp02gY3dslzXqgqL?=
 =?us-ascii?Q?pFUGEZNkiQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e301290c-ad93-4ea3-d08b-08df08424887
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2026 16:01:28.9236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SocWdsEStq/hi7+wWZgc8NKX8mfja0+VxYrL/7DQYtXuMM3cscPluo0NUnrEDe8F
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW9PR12MB999209
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4E8744000C
X-Stat-Signature: cummx4a8m6cp4iq9uiujb9r5956ajnen
X-HE-Tag: 1788278495-381800
X-HE-Meta: U2FsdGVkX1+SvqGjoQNlVjFyVPZfyZy/D7YnCMGdiEerbDsflPoTOyKmk09WffTmVFDiwfi+A85QetHrt/MnSaOl5/+JbRUUZ/PTQ27jAf1BGehSEeQmarshFKsuSitbvRTWgJIUq6jOOwHvoTI4me8tCW9k1fuBRhkuLj9J6SFz0jivBGAsbNM4OOn63Q+rzOJXuYW+ap6kBS5P4hQu+gRpWL8OO+duwY+upiMzxLDG79YjlbI+3ikclDye1NNXRv+57mGCzmhtalaROhRF9nYdaOY9oaZ7IAfOUpDxfWCMEx96DkmYgT6FN4J8ioEPcGKla8wx1M68tU9yI6PNzvaHAWfayByE1gnUHl/t3CoS3h5ZnqUWdfGyHaYQgJ178o1Wwenm/61bKTqSgeZN+/hwnHqtEalXQ82Z/u6paYOxacLD93Ah2Ojs6hbBYfpnLn9Pum2yGo2ooCsyBQFxZRMyQdc34AVx2yXiV9cQbIwrAGJ2sBvyLO1W5je8jPqwnjXdoL5BpjOvd0v/wcNqhL12hyfhvxTF8vbROXRwddF7jTPA8BvHUpAVFrwJgUgJ4QfiG5OW2MTBVDrsEaGMYLjvS2pPNLimb37qng3JdW3at38wccIfTT6DoCXh4svm5QYYeYCUbmDesLoXNLJ052ZvrLg3AdwEsoiUPUv2tC6ghu98tLs+asjbAaOtr8zLtxXMVVtKwZw2MwwsZj4oNgiYoXMu0iHaW35Fdsn+IiyaGefHWuPBFjDJ49Ol+sGkO70T+IGmfRW9sw/zVySorGJDSWFJvol+JoVSwxSVxBx0c92+cJhoH2eVxETN4mdMqAgEy6Un5lAwCWugksZ1KkXUfhaTTfqEDnQw/RJxDnI+1yaZJmYxIUrCttXr0oL1gYXr661lyPwXm91VrJHKk+Nfib1OxJwmvk2SueYZxG3S0nrGjqC1rm5zVqDk/YekES1pcoA80FQucGJ9tjL
 tQnP+Zrr
 +BCZFWznFtztlXl0+cEkXA2Jky+V8WrvrTXUZTvd+GI2DO641P6OqXlQ54RPZDxhwkwXTAIgNfY2DbGGJ+zV72l3p1lgU8u+j9O53HksYX2N4ezxim2vCxtvoBQThPbkWX0R9B8AdlzaqBnwd0lNyrF7GJOzbxhrFVZLU1GV96P3LDmROonlZ3wXnrn6Ej7HjcejBMWLsO6DPO9XQRqq3y/hlL+XnwN8DOj7tD0WCyj2Se+0mqjJO/z7lcghjdj08gdzyzGwbES7FgLP/k8FpIMMgSyJb03cSOILkhJENaL+iB9J/XmQIZ4c0apbQSaheg+lav9t1oTK6p6gPUsvshy6FYhc1MWCuklJ+DAv+I7Dpr9xoFtulO7aA9+wmUzr0Adi7dnb3gEkHIsDF5jJUJoQhOyjN64ckOg3d3NJMkF3m2HIXo0Xht1bMZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1 Sep 2026, at 11:55, Steven Rostedt wrote:

> On Mon, 31 Aug 2026 15:25:37 -0400
> Zi Yan <ziy@nvidia.com> wrote:
>
>> diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
>> index 935893e5ea53b..caf090cd6f85e 100644
>> --- a/include/trace/events/mmflags.h
>> +++ b/include/trace/events/mmflags.h
>> @@ -144,7 +144,7 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
>>  	DEF_PAGEFLAG_NAME(owner_2),					\
>>  	DEF_PAGEFLAG_NAME(arch_1),					\
>>  	DEF_PAGEFLAG_NAME(reserved),					\
>> -	DEF_PAGEFLAG_NAME(private),					\
>> +	{ 1UL << __PG_folio, "folio" },					\
>>  	DEF_PAGEFLAG_NAME(private_2),					\
>>  	DEF_PAGEFLAG_NAME(writeback),					\
>>  	DEF_PAGEFLAG_NAME(head),					\
>
> Hmm, just for consistency sake, can we create a:
>
>  #define __DEF_PAGEFLAG_NAME(_name) { 1UL <<  __PG_##_name, __stringify(_name) }
>
> Which is similar to:
>
>  #define DEF_PAGEFLAG_NAME(_name) { 1UL <<  PG_##_name, __stringify(_name) }
>
> But adds the "__" to the name. Then the above would look like:
>
> 	DEF_PAGEFLAG_NAME(reserved),					\
> 	__DEF_PAGEFLAG_NAME(folio),					\
> 	DEF_PAGEFLAG_NAME(private_2),					\
> 	DEF_PAGEFLAG_NAME(writeback),					\
>
> Where the __DEF_PAGEFLAG_NAME() with the "__" still stands out, but the
> code looks better than open coding it in the middle and making one wonder
> why it was open coded. (It took me a bit to noticed the "__" difference.)
>

No problem.

BTW, the plan is to add PG_folio after this series is picked up by Andrew/David.
So the new __DEF_PAGEFLAG_NAME() will have no user then and can be deleted.
It should be fine, right?

Best Regards,
Yan, Zi

