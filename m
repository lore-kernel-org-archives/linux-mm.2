Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3F2CCD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 13:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4196B0095; Sun, 17 May 2026 09:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFFC36B0096; Sun, 17 May 2026 09:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEFB46B0098; Sun, 17 May 2026 09:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF9F56B0095
	for <linux-mm@kvack.org>; Sun, 17 May 2026 09:55:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4D4E4160F36
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:26 +0000 (UTC)
X-FDA: 84777059052.07.C8AF44C
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazon11012022.outbound.protection.outlook.com [52.101.53.22])
	by imf13.hostedemail.com (Postfix) with ESMTP id 652A220009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 13:55:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="aoopv5t/";
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779026123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGhu152eXpSF2WeSNS5Vm5FfHzQLndJ/Oc2KEFw00/g=;
	b=lGcBm4s5Zd7d+bU8DeZCgADQBzaCgD1qyk1Wd7TTK8YploRGH/KWhUUNvxZL3/EoSCQIs5
	QwImry9wD8CvJzQzuqUvQNcEatjfpR1vIxxbvkW8MPU7v4B05gbMQbnQCBcmKtbPrhDusW
	C1nTfpiFmq7256Eq1vh1pTd6aFWlTAc=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="aoopv5t/";
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.53.22 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779026123; a=rsa-sha256;
	cv=fail;
	b=4KOyo4HNxImmuvBOxtY2yvT+4WLntw6I97tWSPhr3TilnynQzBuplXPwagT306dU9sjoaO
	Aa6rs5pyMXntI6d9jht6fW95AXX+c2htAysWxYzOpyCO7/hj7R7pGqISdfo3taBOrorn07
	E+ugOplwS6Ad4ajnji7xvaHaY80m1xQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CFvdmu4jXYa7GmTPqJTSMgOdUvphv8c0r9kx+/ahHICHFKSJoaO5HOJHXbBbky84oroRji8g0n6yXQPTF6RxnKg11R8EEj9rBqXpQg3w0lzlZ5PSDuCB/FI9D9g4XgKSaE7qZ3XO8ZXRFcRafRdaYLHEdFNxiYDFh9ZSZzz8v9MGpEMHEaG1Nn9ZcPk+zHF1xxBqR06w01vmq1uXzRwlAyQDs4LcIB/J3IhUobexQAxT+6XCSPhQa2ZHoQ7FZ0ZnV0LhnWG0DxQULim9QCoCkpjAOHnZfEzeLtnxblz1aEloufikhB5q6TIAYAucNEswtIN51RtdTezwGwMmSBZ7hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GGhu152eXpSF2WeSNS5Vm5FfHzQLndJ/Oc2KEFw00/g=;
 b=NYhHXdbJDZGwYfjEMLqxjVooB9hOhdqRkvrE+WiEDy/v8Ne7GltqTB6Xnfx/CEul5UIM3Hd0I1/A12AdCGVmJBy4uhIzv/qS7q0XYw4oWb/MuBfnuMM3oplZN+o412zs6IlZdb274qyaxiANba2yZYUlkPm8NRAk//8qsMzcwt6ciZL6o8UxD0AECU7jmPOii0NykVGTNAxZI/Vs6xUV6yqiMO4rB7jCJ/sKwJkzF3W1sd5x7VaWzWTVHinYqaolIO2bLnS6xFa6sOlAmbVW0dCxu+DZm+YrQtZA+koCrYWMrb5xQb4sI4RgYyD4ouzj8M5YIJYkQabv7H+n9/aUPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GGhu152eXpSF2WeSNS5Vm5FfHzQLndJ/Oc2KEFw00/g=;
 b=aoopv5t/6sgpjAdvmiB5VAOsaenf9u8YCV9f6Ritg6rVX3owS3GR1UeZVWI/2FkFq3wOIrz1u+PpWv+w5v5nyPxcsA0wrqpi//8t3OOato7qilUD7JMG27AKLg9bE/5dhf4pPSLBh1tvwLdQmqMP/JtDBJmEIkhpniFQr4Pp6J9yrK5rhqG00d0+PFymptkxLY++FA6EGywNpfNx+HN6sYFVHKrFL/y4MXMjLLrzR1XP2Ru2pMrBC1XItdwPeSOUgpNtcyJIeJeiAWQ33VexjIhkzFaOyQiuEg9e9Hbg4Us9kEk5U59WUJ1A0lthtWGthiy6X4BF85PUFDiloCxd/w==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CY5PR12MB6322.namprd12.prod.outlook.com (2603:10b6:930:21::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.25.23; Sun, 17 May 2026 13:55:07 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%5]) with mapi id 15.21.0025.016; Sun, 17 May 2026
 13:55:06 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Liam Howlett <liam@infradead.org>
Subject: [PATCH v6 07/14] fs: remove nr_thps from struct address_space
Date: Sun, 17 May 2026 09:54:09 -0400
Message-ID: <20260517135416.1434539-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260517135416.1434539-1-ziy@nvidia.com>
References: <20260517135416.1434539-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0227.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:66::9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CY5PR12MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: dbd5c735-ca65-421b-55bc-08deb41be727
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|11063799003|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	arJ6o6KjoW501i23FMiOlP3RGeU6vgRTk/d46tT3qxrtiniFtBTBZloRXz2VYYjSzMMy0xSGqzRm5hJKG45oLkSf5GYgYch2Aul+D0IdbrRe+X+p/DbqoDuUmWExVO9vPZYulJetCWVbk2LdpWaGLPYaMAzw4JpXYA3tlbm4Te2aeMxFuZTtYynhtkbIpsNTwDYZV3I3w6wGIPXtIa0fgfyBmfFkU7hX24BeRfBeVYh2o11SnxcSttgNWdQ9iHMcGqafuzOySZHGtwKIGfwoTDF5QlL7tq3R4msSJw1xFJ603WrsKtS/DSOmPLt5/ToqtF/bHQZv9tz5NqK84OBz9AR/AcH4yhMrOcrhv/sHJRhhETSZqo6H/GskRZmMEJtjWc8N8RSUD9j3kWNVkmE4AQRc7NIKmyez2LdVhDkf8vTXzAUtzmGYDmm428jKw1tQQqCaEMot/zA8TPKzOKJPyvTaEV6rL5lD59WwEhZaRw4kM2mUicOLSYbQAWUagWd4+a+Sg+lU7hjVZDwk6fHJNnz8SwQJDu52d6AyUOM45Z/cIabeTUQoOvknhPQ9Mkj5lLYXLqT4NQHmB2K4nm6sIj2FSGa85DFy2XTXsHfagMIlNJ4igCuT6GWfkK1fT9XF9vrHd6n9bo7zXN/EnV8vQlkDOkFxCSu9YKBDm2Y+iVVEe1SbQ3xjRPcRuEVM8V03
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(11063799003)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IW7N13aZYgC5w3LJZx3HA6NISP+00vObsUGcMhXIr//LndfPdG9u+y/wFXYP?=
 =?us-ascii?Q?QZyCcgGFutF+xsaHlHK49XidUWE2vZTQDbF817RC9g1XaeC4WBNYKjJ/WviZ?=
 =?us-ascii?Q?qpNirMYouMEFIy5UTm7OsBYwZinZx/AkBDbX97dvSqKx8y8Sj6mY6M4jle61?=
 =?us-ascii?Q?FrRUm9tY1vV/2cpPVIrUbhrIR9xyqqYBX0Sle+/gbYQIebLmNh+tQW+Fw/Qg?=
 =?us-ascii?Q?7ahFrE97Uax+8SC7Qwn+106CVZDK9Ww1OGDAejnT7eyt+0IL/zHzvceYpE0P?=
 =?us-ascii?Q?FT5MpfDOQL5Eg8NXLC5YQ24mo3bC1FuYMIcDv7KWEalKUP+ILM39EHSBGThM?=
 =?us-ascii?Q?8eWnbDXUv/LcGejoBZTw6N7qerBvEkOrbFNuymS7FMoYbiUDwhRqVXYf0UfZ?=
 =?us-ascii?Q?YPvAwHg4YWLJ0jYDQAP4znGPbVzHEAAMkPzYawU8oR6ylDwjMc1VofVkRc+X?=
 =?us-ascii?Q?t1hcI5VGGuVeyl0zANHq2oouziVbmrhnJVy7neO8KuPf9Ce0veXR9IVl75Gn?=
 =?us-ascii?Q?amMOqdTHVIySGbpEmk3ZVUPRfgUrGQ9wgUmGMrrAycaz/FA32/QLXC1l4Dps?=
 =?us-ascii?Q?9J8gpwzleYEImRI4BfivJjWLvVHwcZIfqJM6o+9gFNtslZmJOvkSJ5ZmaU9s?=
 =?us-ascii?Q?V22WRmO+mnJDtEcLJqfQEUY3nznyADeVHyigKzuQhwhbhz35azridBoYi1+A?=
 =?us-ascii?Q?CZiuZb674IqdQz1KuVCRWi91S5lei1sV18lJtwaAYwWZSgYSESC7noTvHlxx?=
 =?us-ascii?Q?9CtYTkEJodrEEWb0Q9m1zJaWciqDGpfbkiNP/w8q/YL+2ysT7Nq77xOXkQCt?=
 =?us-ascii?Q?CiIf6dBQ5kLsCIvq48P/7Fsl8/9K42UGq2KhzPt98ON54WWe+x+mJddckXtS?=
 =?us-ascii?Q?OXl67zCoep6bIVuPystNoUkyxbDyuU+weL9W5XQOG9T1fTg9yzpyJqo5U4C8?=
 =?us-ascii?Q?+bRnXsjZHkwR3PQ4q+dzh+Jemb00MatU85EglCXbhD3pi1VlXzpffMysjzcc?=
 =?us-ascii?Q?QGTkRU4KHtSELaaERgEKmqoKafG5WGPp692gQ1hXhChxYcQWelJ0xi82dHj5?=
 =?us-ascii?Q?41B+jseffnI52lRyFed1++fTpTNtArzM1DTeRPw3Kxqs3XgoESBPLdiBco4L?=
 =?us-ascii?Q?uc+j56EHWSfl44AC3KCdOh9LlwWnv23VXKGEhWR+0Lozfgzz37OquqCWI0m/?=
 =?us-ascii?Q?Vg0OWasYV8LKBKYsPmv4vIR5LZiek/evbBk3oVgUBjfI3hSe+h6ddm5G0DZD?=
 =?us-ascii?Q?XbeKx46pIgMEVA1cZxT1tyaQPmdn6R7xo4+el9x2K5lZRSlY3eEXmDZYVLIe?=
 =?us-ascii?Q?+U6Vh3FUEaQwYP2PRUdJIEmM+K/A669un+EixWier2J4Y2Z3KZpahZ1G+PCo?=
 =?us-ascii?Q?FM2zVUy8Iq/5aiJyZ3Bb/qFz6ww4MK4OT0SNRggqcvhe8WNWnq8saHliin1l?=
 =?us-ascii?Q?8LaCOhMPDwPYnaui4b8DXRuPWubFcoKeAKWHhTWzQ6oxGandSkn4wZAWELdU?=
 =?us-ascii?Q?Qfehi1ibY7SBsh0EeBjjpm/9hLV5JOrcFC++TGcFyBA+QjxT9KZu+x/8AMKS?=
 =?us-ascii?Q?kAO+zRR0ItEpe7dNqI3vvpi+f52CQnaY4V7tluZKGOt0Pq0meYzgJtF6Qaav?=
 =?us-ascii?Q?gHGBhFTaFIdMzfqPD2KULiLX4FuMr5UJRDjgcx1Jx8/KVnj8mo3jR2xxDaLY?=
 =?us-ascii?Q?mlUQ7AXLRVxnK4M4qXwTMfstyfuPQJus8Rn+ObZU5RWKXczK?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbd5c735-ca65-421b-55bc-08deb41be727
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 13:55:06.9149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Au3/KZ3un4tJZC0URaJiQqXCfE5iOpxN4C8w6HvYe1gydkh2ZJyK3pDHD+LlLbT8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6322
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 652A220009
X-Stat-Signature: w347skiy8j4hmgdnx5geakhgh8rmoztj
X-HE-Tag: 1779026123-79154
X-HE-Meta: U2FsdGVkX1/6udpgXbbAzSPz8ci6xj0sz2IgBkbQ4tw2bPxt+93ebqPfviwe4ghBbCCRYL8Lvj4E8PWvU4aarN2fRomzZVFkxxDhJsXbja+HioxWkEwANFJDMyeZqzTTSPaTKmUfFad+mxp1840BTAgxvhe2JJJT/m37YzZZc+zEyaW9iZzXmbXrtgqLjA6VVilatu9usdFwqu1FPR59ppelI6EbxWMjLZpdPMQCx+7NS+vwwYKbHQPZh+3ygBM54wexGyhyzMkWp4omug6gWZiNNDTYw79PIFmbtv+uiLZTq8GOfj1GqUnr41eoGplxET1iClF7+yhDv3bscQzlrRMpk5dtMGW2EXc42jZxwMCk3GzWDTXSTGGL1buwUF7kxHbDNkjDPvDUrLMfQcUihVSyyQIW6Hs8KJjXtkkDtacnYkDxsZHQBk3AY0zfhehf12uBHEYr631eWY5sM+G+UT+bypk1M8gQuwipv2YEE+kgnbzf2wyVg3CGbEjVlhbuqKtZl+Xy0y2FqGXjwmIRtDISQqDQ+WZ0jyfSWM4h8hlOeDCzkPHV+6bJ3cjFk/J2UF9hV/jMuxpxN6T+VqxJYqhnF/Tyj/jouw82uNJpaASvUsvyXRMLr4BdF6TZB7SJitlvB7eyYYJ6Nw97JfgSn9qJdBg9lq63Df7aB86ZXFSWK5A23fl+LK75g87AR/ApSUlemL40h0Idbbep5w2IGDbfLxHiOUvsi94DyLVlNYwwpDJjzxltb+DaUweOiM8iCqDGK+lkimTI531C4fXa9SkPTEm1/HPZhq5fkzNfBaSu/bBvoBoV6y1VgDLBlbgTpusXN6LYVEQ+l3OYB6F3togS0tOWlPYM+waNEIUWPOdQdlTp/9U0rOqi3w9PxLgQTKjlsCN0Oc6QD2IHUDK9T5lf/3aO/Xr/HfBSs2ag00+NdqFMglx5GBCpeM1uteRZ0mXhnfpqwRGEBFbbfrq
 A4EJ/mBk
 48gBPO826AtnGuXjyb5OBds3zUNrMI+g9IWOF7hwnoiLackcLQT4a0MqHjLXwKWvMfcwXlM7I5qplSbJoTHZ5FjjUtMNF4NpiIAddRPPAIknGOjgmd/8L7TkZP3TYsWHtNDo9dBH7HTMqGCnsElPWtIvsALgF37aDC6pizatFnq8Hu9JLdbYpyqjHvuIOMMPWG+1oV1MvKB4wV2bfX1xQDOYmtCqXTv2tmK+UHa413BBaLEfjZKIqJ+RmYa+wmlzKyiue35xg4EFrKQi3s6W6CWgmS4kQUYx39N9MiwwZoFwusfMznVX5dK08UDbiC8IlOe+PQE6dWWHkGBYk849qjUkLZQ2L0VdP9yyvKW3BPWJ+OCx1VVbPjqRWMRM/Q51OdUpgNh+xjAy8VwDktUeKOwO1EN9BO/Ito4VqRhHp8iujUbu6VFYVYYLdCnDMVv7zj8xdK4Dvj0qZpK6mtfj2svkmSHKF5PmotY+dmiSP+R0kX4YUFEzPs8XTzMkx+zy7cei88ACdflMScKIm1d1USr1Nye4Nmklh3IwwLi93DtNqy8m31qKJtJ7zlbzMZbtl17DenROukyTrUDqcW05zg2C+uMYAfFi7vEtXHV1OPwyvmBeL48BwJC+vChesG7S38VeO0qP54TKxO5/TkI1mBQNlIzcZ00qPSHVIsdx4O809XwZBzzwIZtui/wgRJPks+uzTNdZ0eaVhIzzrSXHKxTwd3tRUi/97wNcivKAI7RxczAvs0oODgbKf/hE/a2V80ZjYUyuLCs2Rh48T5td+h97xn7AaVthKb2OcsTHk9tTbMmVNtRi84w/g3IELIH+EV4ct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed.  Remove it.  This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Nico Pache <npache@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Barry Song <baohua@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: David Sterba <dsterba@suse.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---
 fs/inode.c         | 3 ---
 include/linux/fs.h | 5 -----
 2 files changed, 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 6a3cbc7dcd28c..d8a6d6266c3c3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -279,9 +279,6 @@ int inode_init_always_gfp(struct super_block *sb, struct inode *inode, gfp_t gfp
 	mapping->flags = 0;
 	mapping->wb_err = 0;
 	atomic_set(&mapping->i_mmap_writable, 0);
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	atomic_set(&mapping->nr_thps, 0);
-#endif
 	mapping_set_gfp_mask(mapping, GFP_HIGHUSER_MOVABLE);
 	mapping->writeback_index = 0;
 	init_rwsem(&mapping->invalidate_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11559c513dfbb..bb9cc4f7207c1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -460,7 +460,6 @@ struct mapping_metadata_bhs {
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
  * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
- * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
  * @nrpages: Number of page entries, protected by the i_pages lock.
@@ -476,10 +475,6 @@ struct address_space {
 	struct rw_semaphore	invalidate_lock;
 	gfp_t			gfp_mask;
 	atomic_t		i_mmap_writable;
-#ifdef CONFIG_READ_ONLY_THP_FOR_FS
-	/* number of thp, only for non-shmem files */
-	atomic_t		nr_thps;
-#endif
 	struct rb_root_cached	i_mmap;
 	unsigned long		nrpages;
 	pgoff_t			writeback_index;
-- 
2.53.0


