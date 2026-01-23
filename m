Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E38D6CFDF
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 06:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E2DF6B03DD; Fri, 23 Jan 2026 01:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AD816B03DE; Fri, 23 Jan 2026 01:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8A96B03DF; Fri, 23 Jan 2026 01:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31EF36B03DD
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 01:24:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01F481A02FA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:17 +0000 (UTC)
X-FDA: 84362238996.23.3E1B36F
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3089CC0008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 06:24:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uSnOeLoy;
	spf=pass (imf28.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.198.8 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769149455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ME3Zsw4WxxYj5k+L8A81RYvg4/TRZvXP0NaSpRQ39Yo=;
	b=lL4VrTlhWZm+UlHMUc+PyxC/CVRXnzt2C/3f3EWCxnOqunzjCqA7mh00lJYjb8IqBI2E0H
	HeYvZFe6H7PpDEN2OAehZ0GIYMkFy6f45UBX27v7JdpDHBjXYqTx101CZ7nzEq7xG0gv8h
	rq4RgSLXa4jCHCHMy3lXjJeJYOppb8M=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=uSnOeLoy;
	spf=pass (imf28.hostedemail.com: domain of jniethe@nvidia.com designates 40.93.198.8 as permitted sender) smtp.mailfrom=jniethe@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769149455; a=rsa-sha256;
	cv=pass;
	b=G5UgetSyrjeoyluyW2ocQz8yhBq5x/sJXjR6sedZ/nylWdjfSKlw6zPbSrpweavVQvNNNu
	zrAPUi4+nVR0CEJPw7RpnyxQyApesMTl946LOLv97R6yoR7L1skErPRoO5aAjjxs8TZghb
	ZXBLYgC9ip68sQyo71O71WAK0Kegzwk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Lvsypvc8nowcYKv7X8QJDoFjzjxSXVEQyqtNPgwPj63x8aTpPKGRHQnxLEmp3kFm5D1I15W0rhe+qnUQ4pCV2IE2fQImw+66xeZ91keDEVDhPqqhc+9AA5WSNKP868IUySdmoCyLLLklQF7G+R58tPjwwklMc1Nin4u1P32lWboZr4EsX68+PmszOZOxEuqZE8TgQ7RtcbjZOnwKMcJuWazkUtuOI1ifW7MdTiSGwVCKGmW+6ghJnFzWBOSWVn0eEJ+6UXI9u7/qwHHjUhl8FeojstijNWVDjg4GBEs8xTFZRzFnut668D/xFsexrLPOvrNRWgVoBLAWIgWOPtJK+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ME3Zsw4WxxYj5k+L8A81RYvg4/TRZvXP0NaSpRQ39Yo=;
 b=CtHZiYFTGybjJ1aE+LOI1OjTLI5VvduNAB705jSeAqXp/X2IlzdA5IoYOoPEM9Fr+epgxmynlVvf1XH0rfe9YXbHmQELd29QC4R86Dr7CGOs4ynS5vtFMbw1BDxSgqn0B3v77muSn5WShmKaLwme6srreL/kqrHPX75dY+W8E0yNaLFssApwRSVAT1XuKv9nOdGwvrI0CLF5p6KUh0vQys9D9f1ubfxB7Fke9Zw/bJlNTWw9Kv8lHq/PlpdHSUOIuOv0ilgzpOFR9NSoYYEEMIqGObZ/PEUfHG5QPP9leatSVytOXB/9PbrLQ5v2eAFqKbMAmrh4yqIf+WZFmvi+gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ME3Zsw4WxxYj5k+L8A81RYvg4/TRZvXP0NaSpRQ39Yo=;
 b=uSnOeLoyHIeMNF8wLuql6NfMA2x4QzUdRRr/6D7FBZ03JMkKHZUMRSvSPSXIR8jhVnqRTU9FObED1ZPnagNItheJKBHatGVSk0SNxtKq6hsqehMGX+39mItVjnDkJoXcjrhAxfg8vUzzAoTiFGMpPuerWhScHLEhsAYDEjfmbPzQzgYeX4z02cy8pHEg/NnOWZhY6Z2A6iPeeMu81pKAtHnJwAErptd+I/6xDxDj6NoTEeyeiD70nZ2Ic+knwSTOC34l7o0KXyx3jNzomxTaafwgtgFpUKqZRDd7TRgLlieBs4PGrtQsjCDeTud9WaI+OrmKnkNdoyStHNcieknzOQ==
Received: from DM4PR12MB9072.namprd12.prod.outlook.com (2603:10b6:8:be::6) by
 DS0PR12MB8020.namprd12.prod.outlook.com (2603:10b6:8:14f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9542.11; Fri, 23 Jan 2026 06:24:11 +0000
Received: from DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1]) by DM4PR12MB9072.namprd12.prod.outlook.com
 ([fe80::9e49:782:8e98:1ff1%5]) with mapi id 15.20.9542.010; Fri, 23 Jan 2026
 06:24:11 +0000
From: Jordan Niethe <jniethe@nvidia.com>
To: linux-mm@kvack.org
Cc: balbirs@nvidia.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	david@redhat.com,
	ziy@nvidia.com,
	apopple@nvidia.com,
	lorenzo.stoakes@oracle.com,
	lyude@redhat.com,
	dakr@kernel.org,
	airlied@gmail.com,
	simona@ffwll.ch,
	rcampbell@nvidia.com,
	mpenttil@redhat.com,
	jgg@nvidia.com,
	willy@infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	intel-xe@lists.freedesktop.org,
	jgg@ziepe.ca,
	Felix.Kuehling@amd.com,
	jniethe@nvidia.com,
	jhubbard@nvidia.com
Subject: [PATCH v3 07/13] mm: Add a new swap type for migration entries of device private pages
Date: Fri, 23 Jan 2026 17:23:03 +1100
Message-Id: <20260123062309.23090-8-jniethe@nvidia.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123062309.23090-1-jniethe@nvidia.com>
References: <20260123062309.23090-1-jniethe@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To DM4PR12MB9072.namprd12.prod.outlook.com
 (2603:10b6:8:be::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB9072:EE_|DS0PR12MB8020:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c84482-c884-4f6b-79d2-08de5a480540
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RQY70CwuLXA26sKJIH0rWWTPYOrT34Z+CnrIxLbnlTXbT+Ky5dxIRQrkig2Z?=
 =?us-ascii?Q?lVs0DC0IP2JI5iO34aAN08FvumxBeJCQFkT4F8bmWdBP+XITYNGAbwUx6r4Z?=
 =?us-ascii?Q?quCWjEgjn2qm1WKninVRdLnKGBnV9+eE33IrzP5rejhA60AWptVUptZa9RQ4?=
 =?us-ascii?Q?vr2u1MBNiSiMBlvKVKOrVbwXHqTnx6ylADeMfktNFDfU8rgWhn4T1T23kmhY?=
 =?us-ascii?Q?JacDylFkJ6SUACIBEnzmdXHDBIYhBCKIsw9v6eRleFRwfGPX48oyQHEVQeHo?=
 =?us-ascii?Q?KBHkiGhp3obW4WOkUujtJMnLKBLZk7oC1t/8+y3JB18Fpt1FsMo5nn/H2g2q?=
 =?us-ascii?Q?FNVOA9h2ODceqFWWGtEGx7x++ZAwPddZo+XJPqlRH2TSwvA7Dz506NSr35xA?=
 =?us-ascii?Q?/mGaoBATvNr2s1mY5/0/QR6XKqO4vw2V37gagWvvwV2n5jR8h384st3Y4GS+?=
 =?us-ascii?Q?pzajezNkzp8QLcGi0fwil2Zcp2iN+DtauO+/VIEGgXtXhoplsZ7AtUw6IRNO?=
 =?us-ascii?Q?s3kYEkTxcVY5Bfg2VfgITlFlYv4uIz3GWq+NIgZ3paUabCfceTm+cKmDt7Bm?=
 =?us-ascii?Q?RMVOPvbFGFbz8lgsN+/Uv8vjAozWtNy1M/mB0OVXzA7UQxogR+6w7WIK2sAt?=
 =?us-ascii?Q?StrzeRlUkL/k/ef7dOKZ/Akn60sG3tgfdoTVG/nDLCoI8TZK4K/TNMH0/8Ez?=
 =?us-ascii?Q?tO6QEDTHrIk6zwSb3DaxArSjhwlihxLIRXKUrBb7AgukxKrxXEbIJWDjR8so?=
 =?us-ascii?Q?7wnpSpCH04QLnooG7bpvytd/yBlRnvXog4IYNzCMa3GkfiJG8VBH13hJwyWL?=
 =?us-ascii?Q?T/ocqPD4JPUKaNE9NOk+SvWQ7NtjjRnxuE6FzJlTioLzuLC2WGyzhFNHu3dZ?=
 =?us-ascii?Q?i8Sea8mquL2eVvohSHcF5aYDG6i/87pu+EYkO2PViGnR2ukAghKmz/s1p2kA?=
 =?us-ascii?Q?xOei43QL1ZN0QmycrSmw1/5zY8LOrJNmduivYoE3fh6E9+sPn0gOuh45jgSJ?=
 =?us-ascii?Q?3JClyckVe7yM883AYXPvrJa9208sY1mDYJEOHtXst/ulCB5U9h9DOs/lvv3v?=
 =?us-ascii?Q?S6/bL5KUpGZ4fYaeQD4Q55qk+hT3PzXU6lIYS663QrNgcm4eHZRbUTwIem+k?=
 =?us-ascii?Q?m18nnpQWTHTVOjLabXbAl0YFkYGtRvQ03y+7Xt7nOVTRrRo+lLcZQgYlndXZ?=
 =?us-ascii?Q?m18XtBc963LKZVWPVrffRFjuODhfZMRbcKeAUDPwkMZVLKcZr7pjhVq/wUmr?=
 =?us-ascii?Q?it31/T9n69LN8CSINn2ouvLw2J6ApRZi1ZCtfbKSVzMvBJQZdjiHlcMAYxID?=
 =?us-ascii?Q?MxU3nr0uZpC1Hullh7TltO0ZsFoE/LBTD3C6ZOcDyf7MYDxx9ud4itNmpCYC?=
 =?us-ascii?Q?Xdo5sZlx0ZvWpRqSynkbE+B4ccjL090w5K91OsgLVGU/4UZK0fMI7T1DHaw/?=
 =?us-ascii?Q?HJYzCJjvMBzFGUW6lYX7BMsOBlfHX9zSEWRRZhlW9In3Ku++2O6UGIf1FECF?=
 =?us-ascii?Q?OEgCC4ykke36Dsgwzr4DK9BPSbqC1i8E8IAW9PCjUFSbDnuVLYtQnOcOSKuM?=
 =?us-ascii?Q?WdveSf+e8/HZe6rdVm4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB9072.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FKN4UvSVOz8VehuvcKwsXCpVtTvUzUfDKAlroKFnAlSRcpzl09CKr5dcC+OZ?=
 =?us-ascii?Q?mWVrV43eBjcI/UmDCYietJ9XJ/FAhb+pv/WlmRpdLtqNM+oS8VkFvLyVWh+r?=
 =?us-ascii?Q?JW46W7mU2ymHp7OuF/e4k4K9aIb6wKYmCUnz/zRt/p5nhIyroZZGbHCrcnYj?=
 =?us-ascii?Q?DAcuMZFMcqfMLuTeTEo5/0KTXg3E3MiXG3ezQNEMD7eLYJlzriTW4Z90Bygz?=
 =?us-ascii?Q?EYOtLY4Ie2BQqD6q3jnqwZX4s1l77APEkP5UUt3z5vBTjs8zLA1gpZ5hpXwJ?=
 =?us-ascii?Q?CmKAH5087bfbntZeRnpxtu7Lsdy4eku8bsICucJjA79CoBM4ZN06G3SwBZw0?=
 =?us-ascii?Q?zLgxxJfSDdfS95Zn9wFu+3YjPkQKeclSa4tSm7EWjaqUzwrzmQh//KMaTMG5?=
 =?us-ascii?Q?kRmLp90LyAZdPvx18yOw18rChKsFAIpyzMmpa/S3kw75D875Wzrgbo7uo/s4?=
 =?us-ascii?Q?wMfg1jJmPZozWdLWJNDQs3NqAWVvqfpOZS8Fb5a1SghOCQLzZRybDwxRh/fk?=
 =?us-ascii?Q?f472tP0k/1iJn1hnzTtqxr4PvvVvcHM9OcJw+IsG8JOcZN+UTmvJcw0SjbzM?=
 =?us-ascii?Q?ThUeQ9+Ngvf+vYmv/qWZbh6SIYsXzTVSRBhWcMeXzY3t4BRlHS5EQ8jH/N6y?=
 =?us-ascii?Q?zHbZD5ULdg3L0hoso+9gcu49JihlDL2qaU4C3XAtg+anQbTlXyta9GbQZpSt?=
 =?us-ascii?Q?iNS2m26rzrT+RqLflsoPHhZuZXnwXZ1FFIqjC/9jwLKWr6FA8HzT+pF7MM7L?=
 =?us-ascii?Q?pZNOujuJTENqwbhcMLz5/OM8AwaPjjK3Ed5Dy1lMR0FKx5CmTii5a5EsDdCN?=
 =?us-ascii?Q?G+ZrIvFFr7fXD7qVG1UTpm+0chcH7B6DYxhiMyzhMkztT4Tux+5O3qRE6C9Q?=
 =?us-ascii?Q?UILNRITFQm15xttzgPJ9sq8/3EarP6GcN3K3B32wJlGgfoEplcPe2qE9AIcb?=
 =?us-ascii?Q?eQiwsXzoLr5i8D+XHyGigr2G72IcmHG3AKJ1YiV8eZtvmOhBio9aOO9gxEjF?=
 =?us-ascii?Q?1+LFITprIs13qBqzVN+/Ag8HOI48yfd7/u6Oi1RhFp9HXghlnEHP7ruOqM8x?=
 =?us-ascii?Q?jrWtYvIfCRv/y/NuoKWdsEE4a4iXUQs0duA4AZMZC2KUslXkxU5JntEW4SJe?=
 =?us-ascii?Q?VAyoabYsMrvwrWy0CQv+/ue4u7zQNv8+TuTqpLbvfRRys4YIVnQ2oQeYvh5a?=
 =?us-ascii?Q?P6hiX8yZLkJs16TopxHUhexyofG2lqUt6dnyJ2EMRwbnvW7NuAWPJCbMtgi6?=
 =?us-ascii?Q?crTmfeXQA+v9wJNkCqpIDRrQhBoVvfhZ9vpy8AozoFdSWSUG9jGQwFbHt7Ys?=
 =?us-ascii?Q?QPGX6v8Ozge1t+aGCVKa7y8zh3dFknk+Wsm1168YlTKyXXtM8R/kY5kYccMm?=
 =?us-ascii?Q?ZOprbO5wrhAxJkL9rMJTxgG2s26z+6FK7lSEZz684shSU9wOpy7/7k7uyuLC?=
 =?us-ascii?Q?lVHr6FpWw22A8Mbz8WsHOFq5MVrRBsqKcI6VCN+A7YDDUNqh0vgK0FOIh1PE?=
 =?us-ascii?Q?yvNvvuU+BdyRT0GCpbwNQZn5RUXX8l5SdB97yKiC2bcry2DDv1N7PNqedQwU?=
 =?us-ascii?Q?UIkMXn44lAbPfYbhgJonWi/qEnFebEENDD6grp06hlVCzZd/+lDew3Wi+36D?=
 =?us-ascii?Q?tlD5TFdt5H2qt9ueHqvlkR2yZDgR4E6BNHpneUWCaOp98vxKF6lKBPpRoH+6?=
 =?us-ascii?Q?LSSnOvDMF6lumzZzZKds4ILjduCgoPn7/nM2e8j7Zsakwj/dITmG8uAziPHp?=
 =?us-ascii?Q?Th17GwWkQw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c84482-c884-4f6b-79d2-08de5a480540
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB9072.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 06:24:10.9047
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gbBt+7uk92GBhVvtm/mY+HSKAHax5SR0T9+u+6Du8YFa9fsYfLP0QfTm1UN9tHQy2VL+NVILII3WBuBmS0mUQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8020
X-Rspamd-Server: rspam12
X-Stat-Signature: tdsn9wpj77yxukph6ktjbinjs4bryow6
X-Rspamd-Queue-Id: 3089CC0008
X-Rspam-User: 
X-HE-Tag: 1769149454-364029
X-HE-Meta: U2FsdGVkX19mKxNX3lWhQW731owiIuSwXK+Tgw/HaRI7cXeEtYAisvlmjXwr73pZJgl9QM+Ml9UH79zvCnwGWlpRTBGkzOwjUXbZDO9t+qVxAjhakRzk3nsahiR9LnWLh9MYSE+w8cShWeD0YWtSumCxvuSHQ1WpXiqJhEa+OUz1Pp32JZQ44Lja+fxS5CgHaIp9k1s5+EJ8FLUpCCUYxVQnyPTF7yBSx5r3lJ/CDxJ0XEQyU1njz8Jd9tAOqS1fvthJjKkKAuwlxHIsHMAUspDeyBCAntSh5VMaLTVGSJP1feM9K8wDZZi+7LIi7a82aDVW+8kDsoaNRnIE/tNeY9PbGHEb/jo9fHHzxk3blTkxTVNFI9mR10ZnKcJwZe6aecxqCJaVTpeDgL0KkbDI/jdDSjfnA88pmbccaq3iQstQBjzvWpJ8KUC211+b5371uiSIP/kpzi/lcSK77Qqynqz+x05FoyUNnAv36IV3cEEKTK9FM3ZA6TIwEYn+SNH+gaaL8EgXDkkJCSldN9HPoPgHVL226CXNpKlEWwX5cynYjtPXFMltzRzL1xSXyDTOx3jpNZU4k7m4SXMY0SCD0nhg4lQYtkTp5rqOx4VCsc7+lEc30cL+T1r2YeQSAJZaXFm3YqbCKLxxpL9dgzLZuSkvGzp6IUiZOVPeMNqCPmYuY/fkh06wqXcmI6oAvVkpXm6j04lZlz60QrEMXfi8DI4LMpSXW16kQUCITsjtfm8Mc/ob8SxyDrSUmftqyK/Eu94rYck5bYcW5PCSeh4GJVzNxQ35n3RADuxXcf3ewuNJGk6k2BEZiYgjSBB2eSNp3+2Rx/OAknY/WmIHLPda516AknecppHHvDPio+XV1JqfitRyPoHIey6UOrXXQMTzi/pJtOaMSVSDMHBmjdrkvTw8K1QMQOY9byFRQ9Gz40FMrrgdTC0Hkvt3vjCrAgI+suuNtMO01h97dihdxIp
 i9RARITB
 1uZt6tX5wokQmQhJtgIhL1iWgufalkG/QPkC/IExRU0oYM2ZSpjUau8whLgMN4/ZUxm20mlMSh5fIObJTkoctdKmTlSd8uYKLZcVjFHnbmyT2DbmjfmiAR2NqowcdSqso9weSQ7HoU2yAKDB50feguT8ZIdYasFNWMsdEgYKP/S1TphqmanX/LO9lcqVRFqC/0hZ2yWEK0p8PNq1onAHjxrOeItn+At+wXz/o5uCMXqVYjnuOC1A4aImjXvdHtAlZ2E+Agq70xdSx8bae3okWa/Vuvh1mupe23vLWzFr0+MQklL/TKK1pNTzYqWKBo8V8IPjNYihXCET9t3foktWrW+iRYw0sTe4vAkUI++1t3lzoHbQyI4KWPTin/WNfb26fa6vAiopBXHKU3MZrk4cIIaSW6X3I+Zp6oETV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A future change will remove device private pages from the physical
address space. This will mean that device private pages no longer have
pfns and must be handled separately.

When migrating a device private page a migration entry is created for
that page. This includes the pfn for that page. Once device private
pages begin using device memory offsets instead of pfns we will need to
be able to determine which kind of value is in the entry so we can
associate it with the correct page.

Introduce new swap types that correspond to the existing migration
entries:

  - SWP_MIGRATION_DEVICE_READ -> SWP_MIGRATION_READ
  - SWP_MIGRATION_DEVICE_WRITE -> SWP_MIGRATION_WRITE
  - SWP_MIGRATION_DEVICE_READ_EXCLUSIVE -> SWP_MIGRATION_READ_EXCLUSIVE

The SWP_MIGRATION_DEVICE swap types are meant as specializations of the
SWP_MIGRATION types - they are equivalent except the new entries
contain device private offsets.

Forgo creating new predicates for these new types in favour of new
softleaf predicates that will be introduced in a subsequent patch.
Currently the softleaf infrastructure does not have the means for
creating new entries so provide swap entry helpers to that end.

Actually using these creation helpers is deferred until a later patch
when the softleaf predicates have been updated, otherwise the existing
checks for migration entries would be broken.

Note that SWP_DEVICE_NUM is increasing from 3 to 6. This reduces the
maximum number of swap files in the worst case (i.e.
CONFIG_DEVICE_PRIVATE, CONFIG_MIGRATION, CONFIG_MEMORY_FAILURE) from 24
to 21.

Signed-off-by: Jordan Niethe <jniethe@nvidia.com>
Signed-off-by: Alistair Popple <apopple@nvidia.com>
---
v1:
  - Update for softleaf infrastructure
  - Handle make_readable_migration_entry_from_page() and friends
  - s/make_device_migration_readable_exclusive_migration_entry/make_readable_exclusive_migration_device_private_entry
  - s/is_device_migration_readable_exclusive_entry/is_readable_exclusive_device_private_migration_entry/
v2:
  - Add softleaf_is_migration_device_private_read()
v3:
  - Move softleaf changes to new patch
  - Update commit message to explain the change reduces the number of
    swap files.
  - Move creating the device private migration changes to a separate
    patch
  - Remove predicates - we'll rely on softleaf predicates entirely
---
 include/linux/swap.h    |  8 +++++++-
 include/linux/swapops.h | 30 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 38ca3df68716..c15e3b3067cd 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -74,12 +74,18 @@ static inline int current_is_kswapd(void)
  *
  * When a page is mapped by the device for exclusive access we set the CPU page
  * table entries to a special SWP_DEVICE_EXCLUSIVE entry.
+ *
+ * Because device private pages do not use regular PFNs, special migration
+ * entries are also needed.
  */
 #ifdef CONFIG_DEVICE_PRIVATE
-#define SWP_DEVICE_NUM 3
+#define SWP_DEVICE_NUM 6
 #define SWP_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM)
 #define SWP_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+1)
 #define SWP_DEVICE_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+2)
+#define SWP_MIGRATION_DEVICE_READ (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+3)
+#define SWP_MIGRATION_DEVICE_READ_EXCLUSIVE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+4)
+#define SWP_MIGRATION_DEVICE_WRITE (MAX_SWAPFILES+SWP_HWPOISON_NUM+SWP_MIGRATION_NUM+5)
 #else
 #define SWP_DEVICE_NUM 0
 #endif
diff --git a/include/linux/swapops.h b/include/linux/swapops.h
index a9ad997bd5ec..a70a6809e9c6 100644
--- a/include/linux/swapops.h
+++ b/include/linux/swapops.h
@@ -148,6 +148,21 @@ static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 	return swp_entry(SWP_DEVICE_EXCLUSIVE, offset);
 }
 
+static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_READ, offset);
+}
+
+static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_WRITE, offset);
+}
+
+static inline swp_entry_t make_readable_exclusive_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(SWP_MIGRATION_DEVICE_READ_EXCLUSIVE, offset);
+}
+
 #else /* CONFIG_DEVICE_PRIVATE */
 static inline swp_entry_t make_readable_device_private_entry(pgoff_t offset)
 {
@@ -164,6 +179,21 @@ static inline swp_entry_t make_device_exclusive_entry(pgoff_t offset)
 	return swp_entry(0, 0);
 }
 
+static inline swp_entry_t make_readable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_writable_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
+static inline swp_entry_t make_readable_exclusive_migration_device_private_entry(pgoff_t offset)
+{
+	return swp_entry(0, 0);
+}
+
 #endif /* CONFIG_DEVICE_PRIVATE */
 
 #ifdef CONFIG_MIGRATION
-- 
2.34.1


