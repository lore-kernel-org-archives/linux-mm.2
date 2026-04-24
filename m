Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13869F34C45
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 02:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E6016B008C; Thu, 23 Apr 2026 22:55:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 798BF6B0095; Thu, 23 Apr 2026 22:55:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65F4F6B009E; Thu, 23 Apr 2026 22:55:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F9A36B008C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 22:55:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F37104081B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:55:55 +0000 (UTC)
X-FDA: 84691934670.19.596A878
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013027.outbound.protection.outlook.com [40.107.201.27])
	by imf02.hostedemail.com (Postfix) with ESMTP id 415D580006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 02:55:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XSzJBZI8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776999353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ixtAgzXNpJV/VknDXObdr3L/OBFI6Ve7R+MCpJgoAo=;
	b=AaWUNQq52gL3Q4DGWwuMVJIYp46WGXM0+47Wd5PnAkRWFPogba63tQfLA8fFlYR+ajshf9
	b3xlzhu26uPn1E4w/sSbvjSEU8eS7ouuYiTdAqUzt0Tu7MhbaAaO35Gbe5xztEhtZUgBfH
	wERD56lDxelMBPoec9E8/rF1F8CGDWs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=XSzJBZI8;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com;
	spf=pass (imf02.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.27 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776999353; a=rsa-sha256;
	cv=pass;
	b=GD2cqtM5VmHV+kQ9ZgDN0w3WaO5FGc+Y/BkDBDFeAs0byA9neBh3g1+RI3as6RMlqZjImE
	bIV4DyKV7NUiYwZTYauxNtESan/DCtgwFywp/w734vCpUSu3Vs2Hq7HV/VDi563WOYrRFL
	qqCeYLT/otZjn+WvHYCOBfCqGPDEK0s=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y8hykBRWVtl8Fm0A0mf+4UIbKrHrO1Lq/s2OGFfYygkuQpnCLRXcO/nbnPxhNVCB6tgSDhpHhX1xwp3JGJyxg2XfCO4QRqtMNjzMkGfjgkAyRdfAt1iXiyO5AgLsL5toO5/8ja8DxSPPAGlddBmbrDdrhEcQhDm6l9VXKaxPdHSm2V7D0w9Ra5KjA0wosOghFzBMJpJbkZx3uzBAtbE8hfWYSjZsDHw3XJzOfjlauSZa7EpFPUMIrHtQfXz1qBUG5BDwuqYXsOxRljjiEiDkMSk1BWZ+EZZFjH9G1JQnOL5CLKXUm5U6dyufOfGvvAbgprRW3fub/6wOICrqWgbt6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ixtAgzXNpJV/VknDXObdr3L/OBFI6Ve7R+MCpJgoAo=;
 b=gMSQo1LConB8dFdXfO6+t9On22xdlTMZEwV0a6/G+C3qkdm/j3WfoQBRpFiKTDB7d4Ox3h3Qc3hkDaRyKC8nro1Xno07VMcFiPrjSD1sw3dopeY/WgGwamVkL0qO0dgcvTkkYEDEGAsUj/0AK7hvYCxgaRmWuCez2bhNnHP4K4V6PJBjIDv1cO3HklAs5QA9Ia023k8S5vwvycEZpXuqT8pUVm+5+rVXux6edo4MUYmuY2oshTvqe7zs77F00+G2dSr9pJlJ21GEG+QRLN5bXcgDJrxJnpY8jNxxvuS2RN5v+mg41BQEbBK8RNcFvAtB2oF5PBqr/sD8RFtLus7LYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ixtAgzXNpJV/VknDXObdr3L/OBFI6Ve7R+MCpJgoAo=;
 b=XSzJBZI8Wv0LpGjyRhJd8abYuh/b4lDzNYhyVgLQ6/lIEhAYyzToOaOVbcsBPogB7pJjm2OdvDlnlYbSSoUfxO4YUnCr7StaXgYrYcziD+R5HVLeD0V9erpcVqC0VnGc1WpGVPrQWkIJWYCr1tOynrqyxC6bAxKkTw24Tnv143cOJEB/o9UX0hgaPKO9TtibU6nopQCxFqfxWFvzMem8yWjWaySfQyKhphgMem9hMQ6T0OVVoDoRHtJbw0KNGRlnQ7CmcsNmaYxApdemy2giGiVqxt+Bh/7V9T/ODegoqAoONY/N9NVna6viwOqdjv69HxG2uXpx0bqldkueTgUPcg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS4PR12MB9588.namprd12.prod.outlook.com (2603:10b6:8:282::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9846.16; Fri, 24 Apr 2026 02:52:18 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9846.021; Fri, 24 Apr 2026
 02:52:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
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
	linux-kselftest@vger.kernel.org
Subject: [PATCH 7.2 v4 07/12] fs: remove nr_thps from struct address_space
Date: Thu, 23 Apr 2026 22:49:10 -0400
Message-ID: <20260424024915.28758-8-ziy@nvidia.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260424024915.28758-1-ziy@nvidia.com>
References: <20260424024915.28758-1-ziy@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0080.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::25) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS4PR12MB9588:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f769b62-603b-4fca-1841-08dea1ac7f7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|7416014|376014|366016|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
 s5X21W1kLu8poq0+Zf6aUSMtGuZF85HtBRKOzVTGys43muGY600SO0NBqAkBvw7JSstP4dKpsiBfe30kXX9ezY57CGt0gA1OwKEBQhi1tvcvUa6wiGITeWzmxR1BlgAe2g7yzO+UIgLmrT6Fz0+zwRQ4PpdHEuNi434oxH3EhmGm3TLg1/Z2Czzvq8gfuIr8SUy87a2DQerNLaPNs76YEeTbaXq7XKUy42GjlyoaUbfC5ud67CK88lp3c8tCKPyJqbkqT37QpIFtNa6cRvHPqrrdmF4V+dE5HeJQ/iW/L+E9ABtIIetwjICV7D7csLRGRsiseWfK8V5DFjOYafsE5snoq9jXBgIyE4JHflV7FoCovi4afdT7/3iewcQkXwu4Zdb9J7cddiYykLua18S4jf+yq6oFsoFqtqXm1bLi8LDnJfzu5MySgcJn6DRnsORMWtBcnKf0iOIX9ZVGWsvfWJYjdpEcL624eNOvNLOfIR2Ue4Sf4UZAejk/TDOAmBN+uOQM3g3lOsn2mdlpmiES+A4uF26jZPxGorvTP5QVvGoB7zIk8h5s82HuJ1kuM9NMm09SM5+ZhuVv0BvgMK7UYFTaDkyNshSL7R+DlBB4OoEJzgh6n9/I1HS8t2l9GQIOufz0rIyLB0tVYR51AXpj4uw7S6sz5xGQTdB+Keqa53H1MWv9LmvzqzlIjqo+4l0nOsUUl854uRy94Sm3JEumX51gmsvqW8oz5nqMC9nUqdA=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?mzeq/0k2ZOrpF+bjgMlftSgg1RulDgHJ/+qhGd20Ho9EFcb1IIrswzW8Gpvt?=
 =?us-ascii?Q?nNsV5gm0tE+JqJCseJvvJp5e2C2Hk1Ob6nm2gJbjgxSezZA/NfIXb7AcY6sR?=
 =?us-ascii?Q?sUHgrp57sYkhRT9QQ4Stw89H2ZEO8ZVevNs7E4gPO4CJrhz9cTPZ0m01YfwS?=
 =?us-ascii?Q?8QBnKVUkihs12HMLKnjxjloLZtA8UMM5P0CmscfGrg1DVSQqbIdDTOI3v2ZD?=
 =?us-ascii?Q?zFxRga3xsODn33ZT5ArMY0wS7MiE9L6uzGghMFoBhaws3tsRhOVAmpKMHiGw?=
 =?us-ascii?Q?gOdWIPKwyyvZHHAkUaJaUXWNwjYMZ/G/PvH2ITIjYOS6hiekSOG/2fsrM1nE?=
 =?us-ascii?Q?6dHIJnkGKWZohM+tt+bH4x2wAXfFj/AvXHWE3xjdU8VHkMHd7sbkWv2XQird?=
 =?us-ascii?Q?s76lEbQOLtxdm5CUFKF56HTMd5lOCBV56BAYZfLNZgUDk2yDGLxBJjCcixEN?=
 =?us-ascii?Q?0VArzc39yu5IssSrWnj2ksjjhdG9WeznCXQzZ9qv7wR52x2Bq90HPZjV8rv3?=
 =?us-ascii?Q?4mrWE3mdr79lzptVEEL8jVYkoFpJWGCWOhD2a5w/yeqthYqHN6Zx74ujWH3Q?=
 =?us-ascii?Q?5patK2WB4xNXFkAXq6cWz+9DRu+N5j40xUe3RaOz1/BfA5T9vYZmq6PiRQxW?=
 =?us-ascii?Q?5AFgb7ATBreVltkyS34wl+vj4BwwBHJrMQ+/1UB94aSGWA53pVchbfgUE0A2?=
 =?us-ascii?Q?4WC8zF7iMhgJ8TckRRNdDelTmAWq1oxzx0W9nB3Od98wsqselcNVARbz1I1i?=
 =?us-ascii?Q?ABoDG06ewsIG63K1zMwdNL3K/NcVos8LI1JeObivyEq8nZHKFDPcFOflEKrb?=
 =?us-ascii?Q?9tMUMk0I+qcCqomV6/0RB7bklzifnUEqidjhW+dYvOvhImVGKGe8YgPDPzxk?=
 =?us-ascii?Q?jgxKVgfG5yHGt7J09sr21w/6kphx82lWs3CxBKFMLwzpi2C9xmxdFnlTamLD?=
 =?us-ascii?Q?p9f5awnFPBUfbkPRSOHU+ifD0Nz67qR/iN4018iQPj2teBwo2NI79REglO/1?=
 =?us-ascii?Q?nbpP0C5lBQQ8xsM+8/qZKvS1DBA+Dr24dWNcKgC7DO5LuJiMqahmpxgKbLjk?=
 =?us-ascii?Q?f34u9LNFDdrfhaVU0jl28cke5DOU5zkLyRtBapEUS+p1XigTe0XWPSW9BwoY?=
 =?us-ascii?Q?CeptETv3Rh+dNV96rDYsHddtrY/++F1ZCKw2hanV/P6/PxisL1Tvf4vo/9jT?=
 =?us-ascii?Q?RqKthBPOYLyjkUxl9CZq1sB9IuX9euZcZtdUZI1JpCzRED5v0Wj8NZK6BQzR?=
 =?us-ascii?Q?bVUuenHZVh0pNB5vlp3CvCK48Tq6B/xGW+PoZPhFV4JmAGkqD7wE5+XkxQbp?=
 =?us-ascii?Q?GG6A9krLZzu9NGb+HdMtXbaZJKKQ7XETBNRqff4lXOgSueP46tqnHhKa/GEE?=
 =?us-ascii?Q?yEJrghhIT9Q+1QbPzoG+Cv5Vbva3H0L9Kx4Qqu3JT4Smb/8DdIvNYTymJUgn?=
 =?us-ascii?Q?BkxWlxUf7sMRROJXy2IRCMD5YAjBRtNNNl5jsjIwQtIHx2j1VDu/iFIRsWSu?=
 =?us-ascii?Q?Y6yjQzdDmt7l2v2EzaJQtcAhWZesc7eSiZ7wo65S88Exa9nmDvhfIeEPkiPi?=
 =?us-ascii?Q?7tH9VKTybasmSwnMdzbJ7/49/BzBgmGswT9aA1HBuh+zQ/QMPw5ib5u/5Ltp?=
 =?us-ascii?Q?IRLwkqXXNp9NbtQMKvW1FYbOl/U5D7I9nLrlShdInKv4Z5nEvngVzsGeZiCo?=
 =?us-ascii?Q?if1P/LpVcZ2iXgQaFZVwzFA9/yFXNfm/0ec4tTtFhHPotXO5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f769b62-603b-4fca-1841-08dea1ac7f7c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2026 02:52:17.9435
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6B7QaNEHMYUirwpq4BO+p+TVf98FyHGzCqh+twyKwVEVU0uQTffWulNJGRWNxzoS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PR12MB9588
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 415D580006
X-Stat-Signature: 19c3tkgrjg4rpjx1iek8ga5be5tgcixy
X-HE-Tag: 1776999353-179061
X-HE-Meta: U2FsdGVkX1+c/njMp5bS9mugKONEVa0GFL0WdD/0YCSkK3NcFAsht4wb7UPJinPWUL1c7G2SAAU1NbVAfIdDN2PTP/VVoBDPgTmqOztoreXNQ5LIcjlxCXGvMQfryUQakcffp+McKqQkIG60Gqp0Ef8XNAeoyKb/6rINGR+1Wz5pOQ4r+6qao/eT4MP48tx/O7pro/QuLpw6HSh646yGf6s8bpR7eXMg4YpzraS1k9Mu+k2YL37nao6eW71eDLSp5v2qr2b02IpnMfPweVxPsHgWsnmt1NLQ28XGrR4ejEnr3gCQ4YkQDzIWf7y0XdQvgkUjie6QzRi8d+lqPJexAbA44CQ16EblAgnOZ32dGR0GIDBk5PHTvwZWH+y8ke6vEXc09mmeZb56y9SDWP9xkaLzcXTuJ1eW0J7BhrY8yoM8cMRxUF3Zy3XWRd49OJ5FoXvE06gnDwqz1WlZdcbdeyTgcp7+ZqC5O4saoSDtrAI22mXKaxTcp0W3BnU74QPGANOM9FzpSZP0Z7YJVSCPN8xu78qtAxNMRVLAxEpsZZJGs0RAbhIdTnaiBSvlKCNowCRsv4VUHtyt1H3renCGlzlI3lICSbALwx5czkj6cClatjRBmmoKbNzt1SzzY/l4fFGkxLx6AGPzYQ8E8pnHTPfHGG/s+2VqwcXs6LXTif1YjvmQTvBU4akhIITaqrB2/PZVAkq0tP8+/05KVxr398tRJEfRUrTBeWEb43s4zdBgyhFw/b5uE7Cer9xJ3rmxzXyLMTwBH7B3WkC87VwVGlkO7cZMNd0QjxJ8TZVeUu7Riu5zcqlEMfOUUuEQ1OePuOOl0uoj7LhFvjkN2EfExODSEyxQULdplZM+DRaU9Gcdpqhp7xD5hpoHRVZNXyOsghWBKqFTfNjjV+jlE/bQM5lR8muZI3i/ScwAfm5yKNrxTSOXCZFqaSrKHGmkRQPPVS8zeYNiVY3c1tNlBBB
 KROSrZNo
 zkipbSc0EJz+U4fY0/tEzslE5QJ7+wHfvZjugpYJWJ+W4SDWG4PVssp+4o+TQ6iyi+ex5dV+38aW7Wi0e5GXq4X9Xp85zXOB9FSLYn/s32nNPe6gycyL1mQOjY43DA/Rt2gVi79wqfSBxuZRTe6q7BPKTJB1TRNUWHGnPKKKyEtcu6RgRFSx4ffRKxz7SOrVgn0WKGkqODl7RpKRo7lwMqVT3iJ+vWU99N4Dy5LdBgyPhkjtq5oOeOuFTn/GJIFnuAk/uxiTeH6DQcdAG+W+CIAt+cMRLxlHvVFuXkUKMXycev24LCt1hCtmM7KIgvBO7zzxHJYokXMRxRpUycgEcp2DuVNlc8gpbhXO39OcbMRISdx2DhCpRuksbQypEnJQoSWVqlFkN0fbEmzU9U5pk5kreYWqLjcbHEVKYmk+D/wf8xREmEBkOoIYrBza0QYrODYYQqFgLa6B6DpN2rozODPGG/ujJXbsbynK6UUJJC24FbmhZ5Y06JyYc8zyxuLSxx/iBQK/P5OZR+092T1Ncctx1R8vny4591JyG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

filemap_nr_thps*() are removed, the related field, address_space->nr_thps,
is no longer needed. Remove it. This shrinks struct address_space by 8
bytes on 64-bit systems which may increase the number of inodes we can
cache.

Signed-off-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 fs/inode.c         | 3 ---
 include/linux/fs.h | 5 -----
 2 files changed, 8 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 69e219f0cfcb..35399f60718e 100644
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
index 11559c513dfb..bb9cc4f7207c 100644
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
2.43.0


