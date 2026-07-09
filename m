Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4555C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 16:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97E286B0095; Thu,  9 Jul 2026 12:13:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954CA6B0096; Thu,  9 Jul 2026 12:13:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81FF26B0098; Thu,  9 Jul 2026 12:13:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 506C06B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 12:13:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7D0512022B
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:13:47 +0000 (UTC)
X-FDA: 84969734094.07.4ADCD51
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011050.outbound.protection.outlook.com [52.101.52.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0C55540009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:13:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lp1HS8SN;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783613625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wNX2K/og9RjFMa/HAei6CBqBXpzbMEmlhTjMZ0W5fsQ=;
	b=5Udsx1xQ3anAh07Yh8Ll1DUvhebkUwzVwtg2SLn363YJKCtEhBxfgXVpAlLryij21PmzdR
	iDJOD8+nx/u+2I7eJb6ZdrBZyXMe5kEhTVJVqQ4JOg9sKeVCYrnArpD/vreR8q8Py1rQ5h
	crRfcGH6SM79hnwyX9CGTgaO6ISN3uk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783613625;
	b=FwO7SO2yRy3X4GSv9k/k9IsXUaQtldr+b7LTd0+rLMPxkITvAOHvmP78y9qQ0A1/2ubKV+
	EIUP+XyQ+ZLWPExpR5w7UO40x0+7XHj7jJfSbYJS/qItqzD4GQ5x39yeCJ8GC98BdOD/rD
	0p6zS+vgNrnYHyDxPcmPYItyUdmlVpo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Lp1HS8SN;
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BPSZKczSUUXrYbCtI7ScKuzfBONreWzG76YMxQKYR3Ge6M8tdz2Lvz2jSQEV3+AsBVpgX6ALAD+4H0lBWFJW/vxsaO9oBdWSDPy0wDvr6Xkdq1+c1BdyTjNBM0dqOADSt7l20nLbOCwmiiV6ZMAnrQhoHnKIblLal1IesJxpaiJkQyFGM1Quv8E8kpUMRCjLLyCUusozPyYJIxTlWjWkxZVH5AkZA5++746viFwQLi0ydNDhEBQ+Q7jMzxVIgcrGdk0fuOoGQ8U4QxypbBZNOIR1z986MQBZqzfEv8HhVRWe+ccnU57VJlR5l7OJfYthdjGJehMOzWHHnuk7yccFpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wNX2K/og9RjFMa/HAei6CBqBXpzbMEmlhTjMZ0W5fsQ=;
 b=X7nyKjyzqRO1ZIY+BvsjaFj8pueEdhLNu2t4vmguYWmjNndKNsLi4Gzn4DAUcSBaNRv97dv4TdfXcS0E8kPGx7rGk9RoGzXAOJwrCohS7j3rIL4BmlE+CpXaGKC3pz1s9KHrY6JkglUmIviVCtpuUO0KcfHpqNEhh/H6AZpBaCsOS7LoXTEtj7O4NL4JRsyFGOoqHa2+ASVER49zGkXKJ3iXoixsoHamJXUap6tbQi20+udf9a4tgcmsODaBIHFGBBMPmMPnAZ0laK0YkaKFVNR4GI33vVtE0y+wtMuZC/qlq8UY0IHkAF9wFMDqnRzVCaYdICVQeQrMYeti8K87jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wNX2K/og9RjFMa/HAei6CBqBXpzbMEmlhTjMZ0W5fsQ=;
 b=Lp1HS8SNevW7UtP5uvQXq06VofIh5PDHeo4aNjzkEEzHmjDitnQuNMAD/0yQAx/kfRkfdtjtCIGmEAV+zm66hHQLOm886GEKavzuImW6K5joyvtMEDrKAl4kd3WNlaf7W/liiT9/yuqQ6vC1jXadhkKzxwNNnYtFW4lbsNtMjgLjc0u1E9BA+tcsnzL/UM2WiHYRLTDWWroeBUX4NuAhqq+4CB8gierkdSQf4O9DXYg3tQAX0F4l97Fu/fP1S3vbHN07gQh1Ko3XDYawG/UaT7K0Fy6NH9s+WcgsurJM6tJW9VOh5Pq0wB2pAfauz9GTa1zShBSnW5kAxXWIjVVa2Q==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CH3PR12MB8878.namprd12.prod.outlook.com (2603:10b6:610:17e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.8; Thu, 9 Jul 2026
 16:13:28 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 16:13:28 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm/page_alloc: make sure tail_page->private is
 zero at page free time
Date: Thu, 09 Jul 2026 12:13:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <4BFAE46A-2AA6-405E-8CA7-0802C25EC21F@nvidia.com>
In-Reply-To: <9fc67666-ac70-4d03-8836-5f8a9f5f1ff6@kernel.org>
References: <20260703-keep-subpage-private-zero-at-free-v2-0-2970fe777dd6@nvidia.com>
 <20260703-keep-subpage-private-zero-at-free-v2-4-2970fe777dd6@nvidia.com>
 <9fc67666-ac70-4d03-8836-5f8a9f5f1ff6@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0461.namprd03.prod.outlook.com
 (2603:10b6:408:139::16) To IA0PR12MB8374.namprd12.prod.outlook.com
 (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CH3PR12MB8878:EE_
X-MS-Office365-Filtering-Correlation-Id: ffeee1d3-b58f-4c5f-0de1-08deddd50302
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|23010399003|366016|22082099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	A5nTy8t1fu8ygtKHPn88I1WdmAA+r8/nAQ07UCYNnQJKPkw4jw0p4KQ/EZbKRMq8u04jplKq9lDJyUmRvjkkXiuZTJmEifVx3SluLcumBi75SYuez2XlayFQh4ldiYBGNlHfzsdps1jTwn5K4X7P3M5+gSGgpPUA4ZM7HWdKyeeJ5jJZmtnLrrDmE10KqhK7dJnOTEfLUsIMWN44K5qFjfAkwtIJqRrnmgY9+ROJ+lB6nMBgg0qa3f7TLdYwqhULLXFYtHXzqv+5EXe2Dj0IHgJZSpDjTnsQ+xSe+L4wmOmNibPQLyHVedFnmtFRktkloqKza3IhL5Y11Pby4CjHuUDJ6m6Osz7vzgPleHfXvjOG99I3QVs3fxpySZubotxOgokPtzqcAb5YMQESefS3RLILy+ulsiHRKeDmWVl5cqSz9dUOp5aYXMHPk98e5W0sZQye3/MlwZkVhrQ1bY9+8x9sv99CsOTlsgwA3fUi9YLJF1PxQpSpEhW3EZIJJSJNMf7lt9QdAqUYLsXw88vJLyGdp3hQUsVRfEFrb5Pak24qYE0bmAKtgGi/aadvdGnNL/HNqE/1vQCXVCt8yg8k66uSPNAF5269wkkk1r2LN6q0yKqZTx4nmmNVSmcJnWDuW/R6Uz9JZccm0WmqeNGja70wYXyZoU//gp5ILqUrocc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(23010399003)(366016)(22082099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?InYX8xXFiGulswRdTdWVXwBk8GS/MkFB4R90rgYR62DzLijlRlH+aYhCQQRD?=
 =?us-ascii?Q?V31PqWra2zuYretM5m0YkBaFcvd/hY6swl5NvKHM6UNp3s1xV/bA3k6gidDB?=
 =?us-ascii?Q?0Lnt/cH4VcuzaN8y3t2qPiMmvDJy221mpEuWRKgZubxKFi53WuFS6xyY73wk?=
 =?us-ascii?Q?w9mz9lOCLLyqorEGH6S8+lGVomxpNV0pLbC/g/wBdRd83fkPz33YcDVXU+U5?=
 =?us-ascii?Q?0aH3KMilj9pvVTNwd+c61eSp3hXBAvfGdoxLLfgqwyoKk9KLAIwNWxDrrMRm?=
 =?us-ascii?Q?2kuDYshkWVOTRitr5DDjFewgkseEEqvt1lSiH6X8WPvcNHxWotGVDxrJlVrY?=
 =?us-ascii?Q?6lTJ18INQBcGP5qThz8YtMv3C7Fzu5DI6ao96ZPrUyatKvmB7u3BAzz1FiZk?=
 =?us-ascii?Q?Apulx5FXdQD57HRbAn4m/C6WvSBIlfQhNYLsduGfFu26yrMbl1i4NbcDCB8E?=
 =?us-ascii?Q?tsNZjeE3+lScxwhXhi8F1OZgGtiAgCghSiCQE8Y/iDqxOEPObqCKzcosxY8l?=
 =?us-ascii?Q?PBL18FkrJo9IABqYXgj6/n/cqHxTzuam7iRzhUkRnF8LRISgO8DZSxFM02bB?=
 =?us-ascii?Q?dvLBeSGBevFioOiRMA5Gto8gPGJg/apr9KnD2OUUvN9hI6+LxX8X2UxdX7cc?=
 =?us-ascii?Q?2TuiQgzUxge7YZAL/Rfccr7UWpqvzlmcgOlWJcsgCA4LUIbzMJuoLYHbXQ8L?=
 =?us-ascii?Q?9ZQViko3i4fH+4ahu5ux4xD02BnWTvnF959tv2xGyS/oG7Kkny1M/XaYI4J1?=
 =?us-ascii?Q?gFoyZ6vkh9uVA3kTrVJJCywnurNyX8qIyOq2O7QuZKz9EWby2A4h2Ri/CWBA?=
 =?us-ascii?Q?CmJyFj5JkebGtZVHfyPCu+SpHk69IXxvRAErmt/7RdXpsgBJnhiiEKtNhijQ?=
 =?us-ascii?Q?PqM1W4NIjGii3FcNZiQDJf9wZncLvK5zP2ztZUUYdygeU/8NjEt7CDYjTMlT?=
 =?us-ascii?Q?mTKIqsDEckCb0fRm1GXOXAN2OLd4/UEUEllGS0MeqhiydbdNJpeSdl0aStEt?=
 =?us-ascii?Q?mIuBJjuMfQ7mdUP9w5dLyTRUYtjZNlAUXAIBbSA1yhHOh83eSyEBIBpsuMZA?=
 =?us-ascii?Q?LriKk8/4x6ZjvbdOhfRRyZJ+ZrXIVuEW2qy2ogzz+0H85kqoaKjDtbYWlAoF?=
 =?us-ascii?Q?lyhbUxho8klc0f+hmZUXz5Rv/JEDXnbxy80O5rHBP4qYiQqwqJ6JIyq0uTEU?=
 =?us-ascii?Q?9CBPRDGhB0j6uh2KqPEAzlCgOokW60Eoxmid7DEdVdV1TdD2rTbasaOjd6K4?=
 =?us-ascii?Q?JJmRS8CvNRI3lOF/uJONXVZPJU/RLwMQDkmbKqqlq2qvEFq+8MX9Yv5TT0Nr?=
 =?us-ascii?Q?idf55x+CGZtodiEzMdg8k0xBwChkPNhu8T5jxTQD5dbzKXjPh4iqrrqsQBZZ?=
 =?us-ascii?Q?7xRzH9xY+E1AE9yBAXZzxO8zbjn0w8TOeKYYHnlIA9ycxwbDHwnC8knE0IQL?=
 =?us-ascii?Q?L2SaX06ZGPUHpQv2hxf6NoS9FeCtD6j0MqSmAkt0+kIbbDRVmNIhD4K0Mla4?=
 =?us-ascii?Q?veaTIgVlQpsyGWaERYd0+irU+a6KAPLu7jXkoqDhYL2IKnGrNf6Uzbekgcvx?=
 =?us-ascii?Q?8Hh8yvBx1s32Cdub/lNwx5+wuG/DpZA9CtUjhllq9Av8dFWpxLkESFmF2xpQ?=
 =?us-ascii?Q?oBj76iFcopti8cN1tVzVWsdffz4hqzqIZX6adLpBmeiK5IOfkBd9rR0xxmfI?=
 =?us-ascii?Q?+Hxcfc9Db8aKX2IvIHxQDcpSMSX0nl8mmnQagfP5B8ewW6AC?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ffeee1d3-b58f-4c5f-0de1-08deddd50302
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 16:13:28.3021
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c8y3QAYgO+svtdRACJsXNn5yRqGs6kcNfRPUHpzmOSQlXkbT3KAOMA5aSB8nYGPI
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8878
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C55540009
X-Stat-Signature: pyeanomtjiryamyo9wt74wzdrxcuy9kg
X-HE-Tag: 1783613624-196498
X-HE-Meta: U2FsdGVkX1/nnTlyZAexSD7RR6RiH/plPNKeAEFo4Npc8U8XyUmav66oeqYcjUG2qgsyQSlsDp9VGE9CDypFlhBbYzAaWT4YAUCxfnyf3jluuYrb4MXvAyu8gMoe1eiVrHsAVRS5J0V6norwL4Wq+uEi2AxQwNeBb0fHP4qruQvJKvlhyUDEwQ5DDdDU8gXxTW0KUfuHpyrlN98gUD+WYKvwpn2mYIE52zqt6NfIgcQ8NWQ35UiFkLibXP9Vma+VGMdwMfoh/aUseu+b3ICKPz+4Fv5PgDNt+2v02IUh+bTGsWtjRFq70uKijaiW3ukBgl8bUZ3FlM16+akXzfecMzLjNXi7/Lc0mBjek6AACeZkGlRF5kaRPhPGnLXThbLCEzXTWcDWKbrt+rHxEfspfR3vk6T7Gc3pkO4oAMGZOJqrZAhrUmR7ZD6DBPPyLVT0OtgkegA65IdzDw0oLAE916/WywquHhOfhplrI6gE2Yr5kT+X9dh/NFf3+Yx13HMS3yRhVUx46po+5Z39Ud1un5hMCYDfX/aYu50NS7O5uGz8Tm6fhGnBUvKe2UwQLeZ1yNgGoPx65vBkT3JOI3v9aVMdEhewbEB0rqJQ5mF08zvwrjAXmpA3dePF/LakM3roD8TIlb7BO9NVKTbB0BTu3mDAE25smNms0zx3OO65GCUTXQwhGAw8ZlB8+jXO+DKD7BgnUv7z9MZqnZv6ZmuhS+MMKwLKrfJ10wyIqLcWYlAT/JVh36T46HDT9DMS/K4Ap5Oh9fpMZ8xHm8L/C8HZFv2lnyNhpfvADSLUzFhrNJuEt0fueIYW5/63wWKtzc30bPEKRLxhj75sPmpnQY0+DjyOqQg7ZfZg1wzaZ6+BW1uR578U8tUeNeCpikqwK2L1qMne4cQVA1BXy3qkpxJi064rIvqtJCEX5ev8nG6QO0haWyNDcevk5gcIcBYjWwGD1aj8Xdp35PVRsNpO/AH
 hTEiIgI5
 U/5mlsG1bb8q7TDy9cX0s8MySjZVxbUNt3vn+CpGZt9wQiQRNQZPJ7RNQbADFw852hyLX/18U8PkiVTnHuzmy5mCsiJexHQarYNAF87Axf2tUerF+lpy3MOlE0wS7pCsEDnPYXAD6co5JliTeGD+LPI9SmYh5Wh/ir6I4H5zQQZQVAhOJBZHo5Qv9f6+ijzP37l9f1NjyBVh3Wrhk8AFnulHDPwVS7v5WIK9dVdTGRj3z+VWLytTULw2keT/YdYOWwIqCH1TEthLprh/zfEPPzeLakAGSDpsn0Gug+NVF2ee56AVT8KBxmCBOjccOTlV94JpAduYA9H81tUSmb+YwExUPh0tTlWtzu8+SZY3mFP5RQdt9DlRyaNULO824R88vB5MTc9EtSQaDir6lmj8NChoC7ufR0tQkCg19/nPEmzD3J3cc5V9cyHk7euGTX89oPzsTbDHOOmSAo/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9 Jul 2026, at 4:24, Vlastimil Babka (SUSE) wrote:

> On 7/3/26 15:47, Zi Yan wrote:
>> Any code using tail_page->private of a folio, a compound page or a
>> high-order page is supposed to reset it after use, otherwise ->private=
 data
>> can leak to new page user and cause unexpected issues. Add a bad_page(=
)
>> check at page free path for it.
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>
> Nit:
>
>> ---
>>  mm/page_alloc.c | 13 ++++++++++---
>>  1 file changed, 10 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 762d9b6bc792f..723a52dfc80f6 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1376,15 +1376,22 @@ static __always_inline bool __free_pages_prepa=
re(struct page *page,
>>  #endif
>>  		}
>>  		for (i =3D 1; i < (1 << order); i++) {
>> +			struct page *tail_page =3D page + i;
>> +
>>  			if (compound)
>> -				bad +=3D free_tail_page_prepare(page, page + i);
>> +				bad +=3D free_tail_page_prepare(page, tail_page);
>>  			if (is_check_pages_enabled()) {
>> -				if (free_page_is_bad(page + i)) {
>> +				if (free_page_is_bad(tail_page)) {
>>  					bad++;
>>  					continue;
>>  				}
>>  			}
>> -			(page + i)->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +			tail_page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>> +			if (is_check_pages_enabled() && tail_page->private) {
>> +				bad_page(tail_page, "nonzero private");
>> +				bad++;
>> +				continue;
>
> It could be moved to the already existing is_check_pages_enabled() bloc=
k
> above. The flags reset doesn't need to happen before the check, no?
>

You are right. Will change it. Thanks.

>> +			}
>>  		}
>>  	}
>>  	if (folio_test_anon(folio)) {
>>


Best Regards,
Yan, Zi

