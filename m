Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F72CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96966B00A5; Thu, 25 Jun 2026 07:00:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F466B00A7; Thu, 25 Jun 2026 07:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36696B00A9; Thu, 25 Jun 2026 07:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A47146B00A5
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24EB71C340E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:00:35 +0000 (UTC)
X-FDA: 84918141630.12.CCBF9D6
Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012069.outbound.protection.outlook.com [52.103.72.69])
	by imf17.hostedemail.com (Postfix) with ESMTP id 23B8840002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:00:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=aVizIMNR;
	spf=pass (imf17.hostedemail.com: domain of jytscientist@hotmail.com designates 52.103.72.69 as permitted sender) smtp.mailfrom=jytscientist@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782385232;
	b=v5B5rWW8281lSv0zZd5tzbLATCrKkSsvY/bvkYToKnXXAJdXpc2+g7fCb83hl9T5M+znOC
	WkoNti+ndkAWt78EUJE/FmN+0ZZ0pjsMiP1Fe6uSPDYCNpluHcJH6s7u0Ad+mv2cEmpgoW
	YY1/GWBPMUO3JMTyC0o8who5gYIvTPs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782385232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plP1Mpcw8Xprc2kCb50fb6i+G2ud9L4zxpNqy85Ru2s=;
	b=cJ9CHfIp72B8Z7Izrwc9iwkwe0SZySLgzaX4HizVShZQf26m/8FvSRQ4c3o8OJcHtY/pWr
	JwXIWmQcIFXcVmnO3PjvhzNRCpuf1/ybEZFEbWd8RrPXVVwLw/2Qb2a9msDBrsWTpI4Pza
	k1FMpBKlgI9gPcLdv8FXTEViujpbnaI=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=aVizIMNR;
	spf=pass (imf17.hostedemail.com: domain of jytscientist@hotmail.com designates 52.103.72.69 as permitted sender) smtp.mailfrom=jytscientist@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YEO7EncGJYNZSnRs5y91M6C3aWGgC3F6WWGKnJsyJ/Fektq0SJunmJBtkVvs9jhOkYYISwAt56A7LEdW2VYrtwhRM4ReX/B4uAZ6U3+dELpj2gYt7NNVX7e+ygdUfLh4y4vBxkP7UIyeM+oUrxLvZugV/3S8qI9H20YnFwZhfPl1kwlMIBstYjv4G2nbh4ABt2Rk162J2vukqdomnBPnhcS0TiY6dpclcF0sbun0Z4mApEr4uXJwZ0ztxHc1AYHd31wy0hxON8Mh+YJkZW8zH9l87EDtxjfsJqs+PTBMt006PvgXxTPfHOM3IxYgVZxSrPEMGoaq4wfErbPcyJHXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=plP1Mpcw8Xprc2kCb50fb6i+G2ud9L4zxpNqy85Ru2s=;
 b=bmI15q5Ma9kr68pgxUBY6ugCC3SOgdiOIJNK7nEHknVxWepx/3W5FLt6BnGViG5sDulN5OKRR2L7hc0Mnqxr02tle7yjOPh9Shgbsf/5xIB8QnMmNFS3adTp19XAcC0Vqj/TGhhDeTxXF4LkCPCPEE62qdCeCLZ5TBp6m+UGfO3AbL1wULGiaZHTTyRe4R1zhxvTfIxT3U2exmm3fXNEyhdFw88NPCzCKrrb+Q6o+3eKPrNuRLwwd3/L0P8Dsn9B729Q7UeucjqvBq0xmlWJUfrkxmiQOhjv83pgod+BEJ+4KK0CfHfDSOrGIq4X2yifIzgyt3LOuJDhUOCMLcJx9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=plP1Mpcw8Xprc2kCb50fb6i+G2ud9L4zxpNqy85Ru2s=;
 b=aVizIMNRA35D2OumtdZLWb57RZvrAcBUVu2m7Q6ZOk7Y+AD6J6VkXYZAW7ZEN0xfBHqZ+ICKYyUqC0JpSoZD81bOHkN+Qi3S4k00qjfLSs4YaMjY9R1PnLtQi5uM14NpNet6i4qq6kuz7W5lQH4zYb6S6kEiJ+DTOvWtev2rXrVdPC8uxUJqbh2VAa0LYoqyTakdiPg27jHHT7NxCpAZJAI6KUsa+p+RP2i0ISU1TI6hXR4pdR3yUPQ2p9AJuCiNUo0h3RHOBehANMjwPMqqqB5eRYYtrrWFXPNS9Ac1iJ1H7PRAy4VAGLxjdANj9v2PGFXye+oYn8MWFrfcPYrOjQ==
Received: from SY1PR01MB10596.ausprd01.prod.outlook.com (2603:10c6:10:31a::15)
 by ME5PR01MB10091.ausprd01.prod.outlook.com (2603:10c6:220:24c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Thu, 25 Jun
 2026 11:00:22 +0000
Received: from SY1PR01MB10596.ausprd01.prod.outlook.com
 ([fe80::7ab4:1f80:a8a0:7d3f]) by SY1PR01MB10596.ausprd01.prod.outlook.com
 ([fe80::7ab4:1f80:a8a0:7d3f%6]) with mapi id 15.21.0159.012; Thu, 25 Jun 2026
 11:00:22 +0000
From: Yitao Jiang <jytscientist@hotmail.com>
To: Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Yitao Jiang <jytscientist@hotmail.com>
Subject: [PATCH 2/3] drm/amdgpu: block THP for HSA userptr notifiers
Date: Thu, 25 Jun 2026 18:59:52 +0800
Message-ID:
 <SY1PR01MB1059636EEFF3E5C5156F899B8C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0028.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::8)
 To SY1PR01MB10596.ausprd01.prod.outlook.com (2603:10c6:10:31a::15)
X-Microsoft-Original-Message-ID:
 <20260625105953.70647-3-jytscientist@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY1PR01MB10596:EE_|ME5PR01MB10091:EE_
X-MS-Office365-Filtering-Correlation-Id: e1ae0c4e-dede-4a14-b197-08ded2a8f402
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|51005399006|23021999003|24021099003|16051099003|19110799012|41001999006|25010399006|5072599009|15080799012|40105399003|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fP0jNFORvB7y/LSRAH20Wxj20lQdoZBmRv/v/OFwrObdWUWoxE9DPudQJQH+?=
 =?us-ascii?Q?CtrHwYycoI8K7BuL83ZugdhoZ3R0PhtsbWnrdt5HZt04XcRlS/FnsrnoalXy?=
 =?us-ascii?Q?TsrRylve53IWqkTpKa+aHiWECU7opPkaWRk48/K73aldh3pKte/CQSAvHTda?=
 =?us-ascii?Q?CTQKuzPnw3X2Jlrb+kUGU2V8aG8xzkVakANMYFMz3MAIy6DIJqx2uTYknI9u?=
 =?us-ascii?Q?8QLqYf/f7QNSOM2YGelaQ6/1zL0H0sVCRC8wulR6HgyBWIpqkyzCA7aYY4Zh?=
 =?us-ascii?Q?0n79BVvQy7SUmXnwZkqrbA56DxqQSYnuebtwfV1+zPUhD9o08pH4CH+eIcWm?=
 =?us-ascii?Q?e7UEPcFTmzawXk6WjhQtOb/dNBhir40H+FP4hyhRlV+7H4fISuO8SpgMADtK?=
 =?us-ascii?Q?q+nsnyJQqrKouCq5CNZFMPeu2+dXiwAdHqFDCtfxYF4nxRDtVgtYG9yjRBH+?=
 =?us-ascii?Q?83tqzSQrNfHB6n4bUt6DFDxBf0+KbNKrbGxlaQuB2ebN3IBHJ994Sp8gGf7B?=
 =?us-ascii?Q?Vpc2Pcd8r3aeiYn32yaHs89oUKumk+jv1wo7062bHVmdcBOv4IbKkmcsIyoR?=
 =?us-ascii?Q?8uKEeozh6FSn481Ak7+rILvAN5N66IaeB75vtD0F3I3QgSskunnoV9sMLwHq?=
 =?us-ascii?Q?oh4155LO8ppZ8SydfwH5Ob9/fhxH3XvpJYz2UkdvmeRyrWc+3ZioNPPQXax1?=
 =?us-ascii?Q?cX10uja44qlrovGHQK1g7FMNYNrRbTJ5LMj9Gzf/IWCe/794piLvZPIiN8iC?=
 =?us-ascii?Q?zxe6GxKoLPTqTRTMHa/loD6Uq6A4umXqaGRAwp10cik3OPEaunO5AIXNpEEQ?=
 =?us-ascii?Q?PgBxii4hfE4+478ARhQC1mJpOCATHBIU9xmW/Kdj4lCooBQp/BjSA2KjPwbL?=
 =?us-ascii?Q?CghJHsk/ASefXGpd8cAHwgUGBBxFSQ0LCUNDagfzgLwT6ZFyyq2Ov4fXByaD?=
 =?us-ascii?Q?4uFvfbWxM5xUHbbGq4v8MoK+RuwBp6g2S541I+F2PAgtcNbNqY++nkw4w7GO?=
 =?us-ascii?Q?Z3JpbAU6sUdpkn9Qxr6ssfJ/ug=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XCWtRY+TcNXCqXQf/tnak73lP8IG4xRteO4xFB+Vcf5UCDAestnIAJlRwHyw?=
 =?us-ascii?Q?Uu8brPtVLnShsRqwiND3PSNeZff2COCduYxHds0+NCNF/5s11daHMBJRrEUV?=
 =?us-ascii?Q?UHc/aoEXUrxmCkxwDX5RZpDI33yNDnaivvI4HMtX2jl718VzRhj1NOmWriFg?=
 =?us-ascii?Q?Z+9lOmfe9V/PX1ab+VnVo3WIPQNcovhJcE89z/Sb9gJ/l4w4lAURi3PM5wD9?=
 =?us-ascii?Q?S9gmVxOnD+huCOM9YvJU56XOPKtD5+1oNlVcJVg0CRIDBPBy9D7zAh2+3FJZ?=
 =?us-ascii?Q?faKz9Pyz0tdnGp8Uic7TMZGQidrWtEMIYjO7fTtbulerS7tKeMBFYPiFGOM6?=
 =?us-ascii?Q?eCOhdA7S3Q6bYYR8D8zdcCglX+L3KmjDHk4BZKv2poVUoVWJ3Krng8aLFxVH?=
 =?us-ascii?Q?gACYzhoq0bPl4d+hTjnSAc3+wdhHCBakdt/NTlWZrqdcZ2ALA1KNfITXxr/Y?=
 =?us-ascii?Q?ZZjaR/6yOelAsncHzTcgx49TlXc5ARFGT+r69XeSXwe+0DveKVitQJfkb/Os?=
 =?us-ascii?Q?nWENhc2pcEAJ58vF7PoKMS47R+n/bxHy+9cpgpKuGKixpDsNxL/HIBFhr2vN?=
 =?us-ascii?Q?9j/SGJZgO6m+kYa+QzY8qKzclJLW19H4eKYOTnPb/48JpS1nJVVOkjF7uXpw?=
 =?us-ascii?Q?5CAiYqXCJVsDqj+BFLU9lrDmN5yA7GwhMwV6pnoD6zQgAfzaMwRHiSYzBlqp?=
 =?us-ascii?Q?rL38bZ5ke/P8T0WBUAbe6yiVuXH4GnzwYGqd/fJGrogHH+fnBHuLvxUcROnI?=
 =?us-ascii?Q?SFg/iSTWclodq1qQFQJv1oWfLHKlcBDMEIAF5EJlJyM/7gjJLv1N9l4pVs7o?=
 =?us-ascii?Q?eG4kRpaTZl+k3drssPZ1trYTNsCokm3T+EmlvEUJ0JSdZ7LcPiaqRmQVy7JS?=
 =?us-ascii?Q?079qkRAMm6YTTh5UqVAznKh6y9WlDC4OPPaEKV0PuXi/o3kH+e56FRTDxpOF?=
 =?us-ascii?Q?W6z6Y3SmG2ZEx8HOE/hjAJldWYhFlXXjweLE7zSoRQGyz+/2C00EvtHd5Z2/?=
 =?us-ascii?Q?P5sm9PLw9aVrYz4hIXEVQbEfW5ubk8P0lGAWYA71KFjY0HWkkUcE82C02ZBP?=
 =?us-ascii?Q?LvJLEzcYzfdBf86TDn7TSP4Iy7UdI4co0tSxmLcxBqd7B/a9J3f+qzfwdfFR?=
 =?us-ascii?Q?9da3zGRktHbShpIL03xxn+5Ie6w2m1+8CxrgwqltMtOlmC8mkyraELtANjU8?=
 =?us-ascii?Q?BFZCt9sT2EkShB0ZDVqdiX8HbdAFcTXtF7Hkph4hkfMmWnmbNrvCjOr2On+4?=
 =?us-ascii?Q?v5FqINWq4bgd5BobcdGgw88mWuFeWVEapL41VO/r/8srgNJQJIQFBGoDPhFw?=
 =?us-ascii?Q?jp/8/D8Kwq8WF5Ugs5Z5F6oR70aBKWdXeGqzyPbhFK3ECrFcceYNob8oBuuY?=
 =?us-ascii?Q?32rvUyNwiqbyco0gakm6vFxNlUB07MJB7MChntq2OwGivd6TseDWFGCrUY/R?=
 =?us-ascii?Q?4WSykx4ANOXa+iqgmaBydz5lqyOJrqkyYXrisiUB+nfl+JOT5QrZ0Q=3D=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-feddd.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ae0c4e-dede-4a14-b197-08ded2a8f402
X-MS-Exchange-CrossTenant-AuthSource: SY1PR01MB10596.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 11:00:22.5044
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME5PR01MB10091
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 23B8840002
X-Rspam-User: 
X-Stat-Signature: yrf5u9oba896ghfoquxfws6puzromtww
X-HE-Tag: 1782385231-187203
X-HE-Meta: U2FsdGVkX19ocODBVOc8auOi4W4IQAT7StEwvVxTKyfj630gYi4lqgdJD+C0XUAaotb5YM5hzfOaoMVJV+uqkc+SFns4sIUzKfhIKbLOkk8ZMfZyhQwZV8h67EaLCZs1Aj9QYKBfEXx9UkzuxkHWQDGdElyXLULMNTx2VfhG30twhPUWcxRUWlu5TIowyXba26wrkjuMcjtPenscektr42VwThGEGTqyZl6PySwfO+8WokVpaifCFZXZnlh1EJoSuXiMG+DravLK3rVbhTaT9nIl029N8lZ6FpRpd1hKLV18IhDYU1S/MfgGVfGz/hDqXtpoLnFF1VRa81HE/mpq+Hk/9OqAbfuzsd7Oc4OqIC3gY7ZUdXiwjy+9FhZjiE5Gk2PN94UgKEnhA1moCde4skZooNqLG4LakQEj5dsCbBt3qiQm3wHfCu/NqgbECkg4iiMD6f9GcPLHw+kIMm+EwMyNLdIo65vrEYwHVPL4a66WyUdJs0UNc0qFpUpryOmkPR7JG5IVcUdZyhjp19Jh2AGiGs+p4KgaglwQHQQPdtgHXV3l8+Cr8lLg3XFXElLWY/x+FHyWmQP0dgjaFfsSmvGzPXRH3J47FW5wQ/WDZFV5UVSPaI8hZE73YrLTXkf9AlsdGG10eYrVWZzYxkFSbxOocaQFLYkR3HKkVFHxkHhxlbhCbWZLxHozmx/oooxndjEbiNFg24SrsLk/BJcMKa4S18u1T2EcT7X/0OET77ASDZ+t7Tyh++CxsyEWVTgRWRCA4a2BI76vfwNOZrh6w7Lm27r8pHDQrnivn7mO/Ef5bd42ldFZJ/fvcvfAdZdHVpCrhb2wJ2XyNOIeXexbYoQwpaPBhoDkRjUgyBdjpAf2O93tSLt8wKb+3qPNXJC/fXO5rztDhWv3FtkWpDlCJGKFMd5NBrT2C7ODbf/vuCiIKqi4iSWDRkGv/KGL+ao/+gC5jWmOfoVY8neiaVV
 QSLN8Xkb
 ZKSb6tEJZ38frQhe2p+3c4yoTO4RUp8s8EmTMVGh7jv6pIlHGe7CugbyA2o2wJLLts77kPNEc+pzMaoonDVaP6O/GKJmRPyy6YT+48ILkP0xhETl/Rk0ccMYqI41JLjjTKwr+f0H6xQZjSFjdLQPiNMv8gvgDNg9aigOlKmzss0BYPigeW7SMzJ7QnDB9+O6OT0noqS6cNw20I9EFuR5DGQx/CuNtZFww8oo/4mP/JPHT+Ml84OXu6+MHxlmM6fYrBQ4m8P2+H+nWYIikyHXeZsxRV6qVpa62fFIyHBdJKeYgAEjIq+SCg9M8AdXYLlftTYMLlTb4MiAUGYZ/yQMW4wmn+Vf2FpXZN35R2n/JfEyAYiFdU+9FMu4dZVhU18D6vqI0vLSDNGya6FBlhmEHdB6fVsqBn+4h5xdfxi37yvmdQd6jNV6HZC7OjHYvFscEHwPJWq5ygd6z42fOHg8alo59QJYDTuK+1tUGwB42GaOrRBfW2wDSd5s1fVY7MxrM4Dyen9zZPJin5ulQ79ormIx0WE9jEMfXxSsBrc2Htb7QjVQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HSA userptr buffer objects are used by KFD compute queues. On systems
where the GPU cannot reliably tolerate a CPU THP remap of an active
userptr range, allowing khugepaged or MADV_COLLAPSE to replace PTE
mappings with a PMD mapping can leave later GPU work failing
asynchronously.

Register HSA userptr interval notifiers with
MMU_INTERVAL_NOTIFIER_BLOCK_THP. GFX userptrs keep the existing
notifier path and do not opt in.

Assisted-by: OpenAI-Codex:GPT-5.5
Signed-off-by: Yitao Jiang <jytscientist@hotmail.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
index 99bc9ad67..c0b36164c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_hmm.c
@@ -44,6 +44,7 @@
  */
 
 #include <linux/firmware.h>
+#include <linux/mm.h>
 #include <linux/module.h>
 #include <drm/drm.h>
 
@@ -130,16 +131,24 @@ static const struct mmu_interval_notifier_ops amdgpu_hmm_hsa_ops = {
  */
 int amdgpu_hmm_register(struct amdgpu_bo *bo, unsigned long addr)
 {
+	struct mm_struct *mm = current->mm;
+	unsigned long size = amdgpu_bo_size(bo);
 	int r;
 
-	if (bo->kfd_bo)
-		r = mmu_interval_notifier_insert(&bo->notifier, current->mm,
-						    addr, amdgpu_bo_size(bo),
-						    &amdgpu_hmm_hsa_ops);
-	else
-		r = mmu_interval_notifier_insert(&bo->notifier, current->mm, addr,
-							amdgpu_bo_size(bo),
-							&amdgpu_hmm_gfx_ops);
+	if (unlikely(!mm))
+		return -ESRCH;
+
+	if (bo->kfd_bo) {
+		mmap_write_lock(mm);
+		r = mmu_interval_notifier_insert_locked_flags(&bo->notifier, mm,
+							      addr, size,
+							      &amdgpu_hmm_hsa_ops,
+							      MMU_INTERVAL_NOTIFIER_BLOCK_THP);
+		mmap_write_unlock(mm);
+	} else {
+		r = mmu_interval_notifier_insert(&bo->notifier, mm, addr, size,
+						 &amdgpu_hmm_gfx_ops);
+	}
 	if (r)
 		/*
 		 * Make sure amdgpu_hmm_unregister() doesn't call
-- 
2.53.0


