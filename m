Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFF01105F7A6
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 14:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F5616B0089; Fri, 13 Mar 2026 10:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2836B008A; Fri, 13 Mar 2026 10:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15ADB6B008C; Fri, 13 Mar 2026 10:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0098D6B0089
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 10:48:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 36BDD1A01A2
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:48:09 +0000 (UTC)
X-FDA: 84541319898.16.A281128
Received: from BL2PR02CU003.outbound.protection.outlook.com (mail-eastusazon11011063.outbound.protection.outlook.com [52.101.52.63])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6DFA2140007
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 14:48:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hdTeKSM6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773413286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vTsn/sGxy3VhvyNFRDl2s/shBd/Rh8rS7DndZaULMTg=;
	b=udIsYT2H7uMGUKTzAaxr1wcDb1Hza7424jHuD9KzkX5Dm+VB7YcyKhz9Uv+IiXr7rnqLwV
	bWnOO5O0zzXeT/RATSYk9qawL+p+dZ9CW9W3tVbHwqL2C8dkVHfgPgcQREzAFfqJVqF2Fh
	2YOMRrybxwfcry4vt3wp8/RTB5c6EZA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773413286; a=rsa-sha256;
	cv=pass;
	b=xvZBe5NrOLUY1P/28wCxuyjqOLhYB3mQaUbb4Ex4u1jBoafSr3SUeDM2w0pCmzEitUMsdh
	nPyyLxSnCGl0d1DHfIYTIOf2s0kiWBVVSJ8+aDZiDvLcixSxDyu223J1AJ0OLfU9mQoezk
	dwC4+5OV6zU0jK7LEIKmNKMR1QEFq3c=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=hdTeKSM6;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of ziy@nvidia.com designates 52.101.52.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RbXv+indq5mPcHZGszIF7GZMqcsgd1jKSZmZsnHvbFSMUgyHvLpOjswPxa+9+JRSJ1E92HNDTUI1Ec+XJ0qSbxy6mYsnxN3MKt03AQBmpq3istpiShzhtpoSzTKNfcw3LcGzoNTkXzoMqbMRAQtXtbNEhWL03srCTFPnrL5ntOPPw9bEFmzeuknHdJiq9YQXlRof5PUne/o+NglFY+cXVtqtgnbOLNOiAIHJCnWTE9LUHh8SJLXTJsP1I1MF8aRGG5OpbTPVCTjGSoriKjiLD0H9SO7i2rA57j/03DVwegovR/8L+mPNc9zEiG7t+iDU8GxzfkpM1liF4jrqOEjCxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vTsn/sGxy3VhvyNFRDl2s/shBd/Rh8rS7DndZaULMTg=;
 b=UB7HHWMHWFuY5ibaOCO9k8HgdU8Rg3G9aUjKMDfRjnLJQ4jwkvfEiQw7uYXCHe5Xhjo/WMyHgtWV/sAzJ2f6zBxOj3k1CYz3HfMPAVtohdY4PZptSw1COiOZvoPtXF1X+LITt7kEtaGWJY+8v0jHWiygxY/AriY6bsihO1xjSyr0I36Qq+o6gpzGmMwwhcmgWK05bpadUJlZzf/wrfSdEbf8c4z510zeOEyYCV/LUC+63BLWjXkDw3GHkSWBZEEg8bi5Om/gZURdptuSho5Za/CF3Bptkogwq40/czx7GH67Yaa9Sek/zv5BlDe9OPDGmL3o8aR7MG11R+UEBP7lqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vTsn/sGxy3VhvyNFRDl2s/shBd/Rh8rS7DndZaULMTg=;
 b=hdTeKSM6/BUa9GW/LdVvRP8wfJZVzcCB/ki69F0yU0F+J4oLf0/4Hfq785FH+T6HgFTmNbErRPNVs+2mBYibEHH7rln+IdmfDHhOFyUpukdk4geJWV4jpKKkWh6pPAEubS/xE8sROPQcSmPugfIJMuoUpkkKOCp4WG+9qj4mbe3QwNKaH1KlU6YbGP3+5wj5Bv2j6G8CrMJRnX5oTnkSfg9+GWhAClfG3d/iQ0y47/0oYCzxJAnyxWUqs+RC5EKWnvJDxyu5+5aQ/bUnEs0CqUexL0OYgJCN0f8/AluQ1J7lRkM6uk1IgcoywMM54Za/Jvg3DqDHU3ofgLqWsy3sKg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5778.namprd12.prod.outlook.com (2603:10b6:208:391::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.8; Fri, 13 Mar
 2026 14:47:58 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.000; Fri, 13 Mar 2026
 14:47:58 +0000
From: Zi Yan <ziy@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	Bas van Dijk <bas@dfinity.org>,
	Eero Kelly <eero.kelly@dfinity.org>,
	Andrew Battat <andrew.battat@dfinity.org>,
	Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] selftests/mm: add folio_split() and filemap_get_entry() race test
Date: Fri, 13 Mar 2026 07:40:37 -0400
Message-ID: <20260313114037.3593642-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0685.namprd03.prod.outlook.com
 (2603:10b6:408:10e::30) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5778:EE_
X-MS-Office365-Filtering-Correlation-Id: 876ab29e-f9cb-4a48-6250-08de810f8477
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	3C0i9w1lKwONWVDxt5/COZ0Xmhs/L2AiZS7liPpmsKnP9jXNFX8G9i0BnPugXLrExEjDRI6E6vo+o9SfM/3vc/nwUze64RSYqRamIfy3ZYdZcJbPrymj9sap7qITR7FnVmlyfIvPnFyTntRNE4swG1XQjRWnrnssj/Kl1sWm3rddD+tnoil9vQrRsn66vC8S2QyXzwBGl73khvZtW5nhOGTTrqAeDBcJ4EY7gF35X+fQl9MvHe2kiSeLCUYSUjUQ+8Bbo0OT+hwxL0CG8TdWkXl5Uh+QIoeQlS1S/i1ISYYejpwV8Dh2eC9NzomB/fgqack28BfB7zgrZmqQ8fUkax+U+KtBpQvGuong7x5aqhxZbXBLIR7y6+ftXji0hvwSiEGgxaEzLOi5HvvKrG7cSqsmwpOI73lUt6+Qed/ARvTrEs83Ifm2KXVuXiw1qW6wlv9uF9K95PWGxZVLWZa9yd0znBCbe1RWfPv/XpyjaqmIUZK8zmMj9/OvVpYKah0C3DDUHk2wbbUbnubGWR4Un8oezwAtIwETCRshZzuqSBAk+2JDCJ5h+A8U/vIdF/SLj6NfgJCzMDeG9gWFpr/LG4H4ipIThXVrwTPuy36g2a2U0QHwDqPW3QClQ676yMK+GhHw3EUrOmhbbirKFfl0ln63cLtYcvIfpzbvRfplBCKn4qTDATH/lGHGu7TICUlf70ZECu1LkLrJRJCVsZE/dJZpKfDe3Bi5K8BPi0hb3DzhdHiQITF67hxuMydiWxNV
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wbS4vfCXHlXcK/HcCQULzImBmp4KynYKPqXMttapETWvZaE6p7/eVivh50Eh?=
 =?us-ascii?Q?wP0kWG2TcuPwhEYSkF+wrX47IpZT4dhH2krNuv+jowB4jUkOBGodIwW4HJYD?=
 =?us-ascii?Q?c5tGzT1GNJdobNyHFVC0BEYpvEXleyIpr0+LIg1sFOerkHkcyn/DIL0oEqdO?=
 =?us-ascii?Q?q9vehCq5K4Yc1dYOtJAfBkl+9FSGzyKfKdMHb2QyR1bruaYgxymZyrXN/p7x?=
 =?us-ascii?Q?Dy1PxRWu0Axn8uHRqktQc9X+6EOG7WfdEmcw8ZmU9Nonj8LrOP7iZs+BGrtx?=
 =?us-ascii?Q?blivTCOeoQiPWhR2MTHrLdFabca/xLocvl4EWAEEgS/Fjr2V9vfD8GXU/JIN?=
 =?us-ascii?Q?tRuIC/jyOqIqEHVEUEmoGffFZK/BPVaYSBjZyc3pZn5NQr1AbFqNs3W1sJ6c?=
 =?us-ascii?Q?HnedxyDcTYEKroQUjdwVAJDHB3a5fdpCnGfvlFWpYNy1gldvwaCOeiO0UqPs?=
 =?us-ascii?Q?ML1mtS7s3c2LKCObd1a/sRZmtO4fpmRH59AUvSeqkGKvGTzfa2+8OXQTHonT?=
 =?us-ascii?Q?QAEL2hpc8HSecIrVVwyWMxYTgsEOjkyLVSlAICOwaVJ87vryyWN2OFaFbM0x?=
 =?us-ascii?Q?oO2qp86R+u7Hvcl8U7g+AW5w0HzIq4Qw2NkkuZhbL9lPpMWEUZMYcU213YGM?=
 =?us-ascii?Q?QQiPhBmKpifuSZCIWlJBQChDn9+/zrtN5X3o+Uq4pRMTrEci16psDS1KULyG?=
 =?us-ascii?Q?29CnSV/2Rs4WsBWeunVuQa9uAzYQTyeaqepPC8xxyeqX2AHZm1b2YC/o0/SA?=
 =?us-ascii?Q?UAOUUSKTvd0kKV08TzVpBBM66v4ptwYb5dQDOO8AP0bdfpFkjbXgnsFA0SJ/?=
 =?us-ascii?Q?U/Pth2mE3xpxnpQaRUQ7fFh4IdV28g0PB0whLNArulCE3aLZNWzbwt4XIU2a?=
 =?us-ascii?Q?Rcy8AKmwwMcG4gDMzG11afoAp3Etyt8jvPSbRii9Qc9CuIZG55WOsb34yHEs?=
 =?us-ascii?Q?40raSbvAUXwGScr3rlJqBsOZnLj66gBAYtefAJKOOcWfUrEuUsw5hf8zeaf1?=
 =?us-ascii?Q?ZV984E5XCon9/UObMy53qCm2q5Hjn11xwiwUHcC8EisGER2jw+Qhd7MnY1Z1?=
 =?us-ascii?Q?HLv0cq0n1MLko4X1PuQLg4ZwZAJFLpU5v9O9TNAZ6Vhvagasb/RCUzqjWEkx?=
 =?us-ascii?Q?R3+9dBP8vO6oR1bTWOhsToGMqXP4w0JBkiTvPD1O99m70usJjEUdhSNn9HZA?=
 =?us-ascii?Q?FYPxle6IpS5HznNppnPLOCKQRbL8WHhC8Z+hnv00TrcxBEUuW2Kdg/9zK8w9?=
 =?us-ascii?Q?m1zNPX/pf7DAydAAitXT9xgaiOEni/7cRl12+xirr3xeiuBCm/mJXeSebbY1?=
 =?us-ascii?Q?Dk5YWq2S6ZQMpLNx2mZ0BkX9fuBhBQ8NW3iXqmoi5mUMRTSmGpDm4O6YjkOb?=
 =?us-ascii?Q?X2bECb+b5BYjZQFX09La5tuoTkUVEFjt2ESSFDcDrSyw0eMjKCIjvrfk8NjK?=
 =?us-ascii?Q?2B8a3zmP42LwpEDgefjn6ua7o+49vRXqQEEZk3alK+WskVofpg1ldcKqw+5i?=
 =?us-ascii?Q?pR7jMwNm+y+pxUOxUSshESmUJA7z/b10NOXn3V/90sIaGfM3m+/LD8NA9zmv?=
 =?us-ascii?Q?65K6H9rRCxgHncEaWy+iO4o5dXjerak8vB+xWIOgX/Vb3yq+u+TeeyVL4fE6?=
 =?us-ascii?Q?ezzlKwUdXA8G2D6u9gZaHhl4fwPlShaAhjwP8kbb0GGZLgNMyxI18EL41sSx?=
 =?us-ascii?Q?6S6effuBN0fX2cy76raaFxZ3cgD8F43SXsBcl8z6HwmSqkSg?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 876ab29e-f9cb-4a48-6250-08de810f8477
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2026 14:47:58.1641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +LL6O8EXyglEgTH4z16lyZ43+XMmhxd/M2bseiuYSIPBh3jTQGbvYxcwiVX1xhse
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5778
X-Rspam-User: 
X-Stat-Signature: 9jth7qc53m13hfheezdu5emdkromygkr
X-Rspamd-Queue-Id: 6DFA2140007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773413286-959228
X-HE-Meta: U2FsdGVkX1/y9b683sYG17cEGZLTinbDev0+JW/frfvPHl4Lo00b8IbrcqBTJcAbryvdVD0JLtVzxq4QEyBsAOJf+BEvMIyso8MpKI1SqoNkJR0pIMK4OurkdLEnyY5fs8D8zHtH9RO9xYDvltvKSASZ4BuxVjXEtoG4Sy88t2V6UoM/OL240ikrBm7hxn9CCIDQLw/xNtPLFy51G5g6yI8czmqr3y+5GmqLDBJRDjchIT77DZU+j2FC/CgVvMu8G7hTwd8Z/cCw0+7rin+Q8GBxevJBBiTwBqhqL0zaM4byJeUanvzPjhC1XSZyT1Qk+jKBFSEN5HSrGLrSz0ztHyxnthUcK93+HBX+uG0AuR1j9l6TOerGIuugIYn3v3V/N2E7z/ViT9ycNeJPWH2Sk0WuKNxQ/7rC3nOeeaZrV9IXWovxINQ7f84/iyIz9LQc6XgzjswWfgjGf2DtvqBlpcdsKFwC0Cna5IyZelduh9zvFOZWbzj6Zt4Aaxsv1LD2+0p/0IPuF8fQ8e8HTSbSZIm+z7A33eyg7BOeShOBeAQyRDHkTfouy4h5U2V4uBcGepvy1Wt2HNltvI1XX2UNpPDml7AIn9IK0EU2J9zYa41LCZJrExPNBbIJYI6wUR2SK8QrSAsmJ7BZl1RNjWpX2FjaHW/ltW95/9YKoPBai8T4xq6y/KhBDDYNMwq6Ci/vYcXAOdwAfqlqmqS+c0nTPuAWMoWbrc5PUoezdGKi/mDOWfjvrUFkxyDSVHYzBXsm5aguuSFSz9eHJrOJwBWorr3bSSrAlkF2H7ZpOmcF1dxfiE3fkCcUpSFdQKG7ZtEEnVITrw1X3Spoz+1N25yPhLNtpxNjLD/ESlIouI10Mj5h9ziX7FJb51ny7DW6G8b8+dAlh5MtHMGdwHmIXz1AUBaMprTCvv/epQVCA1iG/h74MN/eBjUYsBM9zlsyUnVy7ANbiZ7WPko5ETL6Jak
 UdUnQ+8Z
 JY1Y9eNkuVgvRe0gJkuvDlATdJha36OHm0pnuu8qnieH75T09wUgiepM2N7BSwZyityAD1sjZ7omWQwu45Yic3/JLmpF8gcCK4h8Eo499f2M5vebK7YwRtFPK/CxX+4s/qb4XAyGvfWYrtqaZjLtASeOuf+fdJDIVgPCnEj0PVYHiSS/FvE9n8VJKXWSzMZOSNFz9E/DDL4phuMUBnrb3Ho3UvwSCYqWfeD6qOn74PU5pTSPBZycmzhKnXeBRd0zF4C31m+mn2q0neVPcIPRSmZEO9lTH4p6GnfScyIa7Zp9A2VH0kouL00P8UFzgmvwxwfd+UdXisX67ZSk04ceNik7lnkaJnXM4/Cjtq5fXD/SIAKVKoehKNGOMxpGH5ckjnHIQuByYHs1EP/8qr/Tyxhu5e6uMTHukosjLuxOJfG24sTsUhv1aF1pG6wrRtg5GIoVmzfjt4eREisaYvyEHBu5Qw3pkl8aDMdxgYuKQWvMf2LocIHwqqkMxu4rBd6Rviw7Irt9rAlX51NrgM/vZSm/9ZAgvwu+DXW4b9N4NDVd6RiFSu2hrwT1+6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The added folio_split_race_test is a modified C port of the race condition
test from [1]. The test creates shmem huge pages shared by both a parent
and a child processes, where the parent process punches holes in the shmem
to cause folio_split() in the kernel and the child process reads the shmem
in 16 threads to cause filemap_get_entry() in the kernel.
filemap_get_entry() reads the folio and xarray split by folio_split()
locklessly. The original test[2] is written in rust and uses memfd (shmem
backed). This C port uses shmem directly.

Note: the initial rust to C conversion is done by Cursor.

Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLumWJdiWXv+C9Yct0w@mail.gmail.com/ [1]
Link: https://github.com/dfinity/thp-madv-remove-test [2]
Signed-off-by: Zi Yan <ziy@nvidia.com>
Cc: Bas van Dijk <bas@dfinity.org>
Cc: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
---
 tools/testing/selftests/mm/Makefile           |   1 +
 .../selftests/mm/folio_split_race_test.c      | 380 ++++++++++++++++++
 tools/testing/selftests/mm/run_vmtests.sh     |   2 +
 3 files changed, 383 insertions(+)
 create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c

diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
index 90fcca53a561b..3316d8a3b7e82 100644
--- a/tools/testing/selftests/mm/Makefile
+++ b/tools/testing/selftests/mm/Makefile
@@ -105,6 +105,7 @@ TEST_GEN_FILES += droppable
 TEST_GEN_FILES += guard-regions
 TEST_GEN_FILES += merge
 TEST_GEN_FILES += rmap
+TEST_GEN_FILES += folio_split_race_test
 
 ifneq ($(ARCH),arm64)
 TEST_GEN_FILES += soft-dirty
diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tools/testing/selftests/mm/folio_split_race_test.c
new file mode 100644
index 0000000000000..cf5a5666bab77
--- /dev/null
+++ b/tools/testing/selftests/mm/folio_split_race_test.c
@@ -0,0 +1,380 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * The parent process creates a shmem and forks. The child creates a THP on the
+ * mapping, fills all pages with known patterns, and then continuously verifies
+ * non-punched pages. The parent punches holes via MADV_REMOVE on the shmem
+ * while the child reads.
+ *
+ * It tests the race condition between folio_split() and filemap_get_entry(),
+ * where the hole punches on shmem lead to folio_split() and reading the shmem
+ * lead to filemap_get_entry().
+ */
+
+#define _GNU_SOURCE
+#include <assert.h>
+#include <errno.h>
+#include <linux/mman.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <stdbool.h>
+#include <stdint.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+#include <unistd.h>
+#include "vm_util.h"
+#include "kselftest.h"
+#include "thp_settings.h"
+
+uint64_t page_size;
+uint64_t pmd_pagesize;
+#define NR_PMD_PAGE 5
+#define FILE_SIZE (pmd_pagesize * NR_PMD_PAGE)
+#define TOTAL_PAGES (FILE_SIZE / page_size)
+
+/* Every N-th to N+M-th pages are punched; not aligned with huge page boundaries. */
+#define PUNCH_INTERVAL 50 /* N */
+#define PUNCH_SIZE_FACTOR 3 /* M */
+
+#define NUM_READER_THREADS 16
+#define FILL_BYTE 0xAF
+#define NUM_ITERATIONS 100
+
+#define CHILD_READY 1
+#define CHILD_FAILED 2
+/* Shared control block: MAP_SHARED anonymous so parent and child see same values. */
+struct SharedCtl {
+	atomic_uint_fast32_t ready;
+	atomic_uint_fast32_t stop;
+	atomic_size_t child_failures;
+	atomic_size_t child_verified;
+};
+
+static int get_errno(void)
+{
+	return errno;
+}
+
+static void fill_page(unsigned char *base, size_t page_idx)
+{
+	unsigned char *page_ptr = base + page_idx * page_size;
+	uint64_t idx = (uint64_t)page_idx;
+
+	memset(page_ptr, FILL_BYTE, page_size);
+	memcpy(page_ptr, &idx, sizeof(idx));
+}
+
+/* Returns true if valid, false if corrupted. */
+static bool check_page(unsigned char *base, size_t page_idx)
+{
+	unsigned char *page_ptr = base + page_idx * page_size;
+	uint64_t expected_idx = (uint64_t)page_idx;
+	uint64_t got_idx;
+
+	memcpy(&got_idx, page_ptr, 8);
+
+	if (got_idx != expected_idx) {
+		size_t off;
+		int all_zero = 1;
+
+		for (off = 0; off < page_size; off++) {
+			if (page_ptr[off] != 0) {
+				all_zero = 0;
+				break;
+			}
+		}
+		if (all_zero) {
+			ksft_print_msg(
+				"CORRUPTED: page %zu (huge page %zu) is ALL ZEROS\n",
+				page_idx,
+				(page_idx * page_size) / pmd_pagesize);
+		} else {
+			ksft_print_msg(
+				"CORRUPTED: page %zu (huge page %zu): expected idx %zu, got %lu\n",
+				page_idx, (page_idx * page_size) / pmd_pagesize,
+				page_idx, (unsigned long)got_idx);
+		}
+		return false;
+	}
+	return true;
+}
+
+struct reader_arg {
+	unsigned char *base;
+	struct SharedCtl *ctl;
+	int tid;
+	atomic_size_t *failures;
+	atomic_size_t *verified;
+};
+
+static void *reader_thread(void *arg)
+{
+	struct reader_arg *ra = (struct reader_arg *)arg;
+	unsigned char *base = ra->base;
+	struct SharedCtl *ctl = ra->ctl;
+	int tid = ra->tid;
+	atomic_size_t *failures = ra->failures;
+	atomic_size_t *verified = ra->verified;
+	size_t page_idx;
+
+	while (atomic_load_explicit(&ctl->stop, memory_order_acquire) == 0) {
+		for (page_idx = (size_t)tid; page_idx < TOTAL_PAGES;
+		     page_idx += NUM_READER_THREADS) {
+			if (page_idx % PUNCH_INTERVAL >= 0 &&
+			    page_idx % PUNCH_INTERVAL < PUNCH_SIZE_FACTOR)
+				continue;
+			if (check_page(base, page_idx))
+				atomic_fetch_add_explicit(verified, 1,
+							  memory_order_relaxed);
+			else
+				atomic_fetch_add_explicit(failures, 1,
+							  memory_order_relaxed);
+		}
+		if (atomic_load_explicit(failures, memory_order_relaxed) > 0)
+			break;
+	}
+
+	return NULL;
+}
+
+static void child_reader_loop(unsigned char *base, struct SharedCtl *ctl)
+{
+	pthread_t threads[NUM_READER_THREADS];
+	struct reader_arg args[NUM_READER_THREADS];
+	atomic_size_t failures = 0;
+	atomic_size_t verified = 0;
+	size_t page_idx;
+	size_t recheck = 0;
+	int i;
+
+	for (i = 0; i < NUM_READER_THREADS; i++) {
+		args[i].base = base;
+		args[i].ctl = ctl;
+		args[i].tid = i;
+		args[i].failures = &failures;
+		args[i].verified = &verified;
+		if (pthread_create(&threads[i], NULL, reader_thread,
+				   &args[i]) != 0)
+			ksft_exit_fail_msg("pthread_create failed\n");
+	}
+
+	for (i = 0; i < NUM_READER_THREADS; i++)
+		pthread_join(threads[i], NULL);
+
+	/* Post-sleep recheck */
+	usleep(1000); /* 1 ms */
+
+	for (page_idx = 0; page_idx < TOTAL_PAGES; page_idx++) {
+		if (page_idx % PUNCH_INTERVAL >= 0 &&
+		    page_idx % PUNCH_INTERVAL < PUNCH_SIZE_FACTOR)
+			continue;
+		if (!check_page(base, page_idx))
+			recheck++;
+	}
+	if (recheck)
+		ksft_print_msg("post-sleep failures: %zu\n", recheck);
+
+	atomic_store_explicit(&ctl->child_failures,
+			      atomic_load_explicit(&failures,
+						   memory_order_relaxed),
+			      memory_order_release);
+	atomic_store_explicit(&ctl->child_verified,
+			      atomic_load_explicit(&verified,
+						   memory_order_relaxed),
+			      memory_order_release);
+}
+
+/* Returns number of corrupted pages. */
+static size_t verify_pages(unsigned char *base, const bool *is_punched)
+{
+	size_t failures = 0;
+	size_t page_idx;
+	size_t non_punched = 0;
+
+	for (page_idx = 0; page_idx < TOTAL_PAGES; page_idx++) {
+		if (is_punched[page_idx])
+			continue;
+		if (!check_page(base, page_idx)) {
+			failures++;
+			if (failures >= 100)
+				return failures;
+		}
+		non_punched++;
+	}
+	if (failures)
+		ksft_print_msg("  %zu non-punched pages are corrupted!\n",
+			failures);
+	return failures;
+}
+
+/* Run a single iteration. Returns total number of corrupted pages. */
+static size_t run_iteration(void)
+{
+	struct SharedCtl *ctl;
+	pid_t pid;
+	unsigned char *parent_base;
+	bool *is_punched;
+	size_t i;
+	size_t child_failures, child_verified, parent_failures;
+	int status;
+	size_t n_punched = 0;
+
+	ctl = (struct SharedCtl *)mmap(NULL, sizeof(struct SharedCtl), PROT_READ | PROT_WRITE,
+				MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (ctl == MAP_FAILED)
+		ksft_exit_fail_msg("mmap ctl failed: %d\n", get_errno());
+
+	memset(ctl, 0, sizeof(struct SharedCtl));
+
+	parent_base = mmap(NULL, FILE_SIZE, PROT_READ | PROT_WRITE,
+			   MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+
+	if (parent_base == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed: %d\n", get_errno());
+
+	pid = fork();
+	if (pid < 0)
+		ksft_exit_fail_msg("fork failed: %d\n", get_errno());
+
+	if (pid == 0) {
+		/* ---- Child process ---- */
+		unsigned char *child_base = parent_base;
+
+		if (madvise(child_base, FILE_SIZE, MADV_HUGEPAGE) != 0)
+			ksft_exit_fail_msg("madvise(MADV_HUGEPAGE) failed: %d\n",
+				get_errno());
+
+		for (i = 0; i < TOTAL_PAGES; i++)
+			fill_page(child_base, i);
+
+		if (!check_huge_shmem(child_base, NR_PMD_PAGE, pmd_pagesize)) {
+			atomic_store_explicit(&ctl->ready, CHILD_FAILED, memory_order_release);
+			ksft_print_msg("No shmem THP is allocated\n");
+			_exit(0);
+		}
+
+		atomic_store_explicit(&ctl->ready, CHILD_READY, memory_order_release);
+		child_reader_loop(child_base, ctl);
+
+		munmap(child_base, FILE_SIZE);
+		_exit(0);
+	}
+
+	/* ---- Parent process ---- */
+	while (atomic_load_explicit(&ctl->ready, memory_order_acquire) == 0)
+		usleep(1000);
+
+	if (ctl->ready == CHILD_FAILED)
+		ksft_exit_fail_msg("Child process error\n");
+
+	is_punched = calloc(TOTAL_PAGES, sizeof(bool));
+	if (!is_punched)
+		ksft_exit_fail_msg("calloc is_punched failed\n");
+
+	for (i = 0; i < TOTAL_PAGES; i++) {
+		int j;
+
+		if (i % PUNCH_INTERVAL != 0)
+			continue;
+		if (madvise(parent_base + i * page_size,
+			    PUNCH_SIZE_FACTOR * page_size, MADV_REMOVE) != 0) {
+			ksft_exit_fail_msg(
+				"madvise(MADV_REMOVE) failed on page %zu: %d\n",
+				i, get_errno());
+		}
+		for (j = 0; j < PUNCH_SIZE_FACTOR && i + j < TOTAL_PAGES; j++)
+			is_punched[i + j] = true;
+
+		i += PUNCH_SIZE_FACTOR;
+
+		n_punched += PUNCH_SIZE_FACTOR;
+	}
+
+	atomic_store_explicit(&ctl->stop, 1, memory_order_release);
+
+	if (waitpid(pid, &status, 0) != pid)
+		ksft_exit_fail_msg("waitpid failed\n");
+
+	child_failures = atomic_load_explicit(&ctl->child_failures,
+					      memory_order_acquire);
+	child_verified = atomic_load_explicit(&ctl->child_verified,
+					      memory_order_acquire);
+	if (child_failures)
+		ksft_print_msg("Child: %zu pages verified, %zu failures\n",
+			child_verified, child_failures);
+
+	parent_failures = verify_pages(parent_base, is_punched);
+	if (parent_failures)
+		ksft_print_msg("Parent verification failures: %zu\n",
+			parent_failures);
+
+	munmap(parent_base, FILE_SIZE);
+	munmap(ctl, sizeof(struct SharedCtl));
+	free(is_punched);
+
+	(void)n_punched;
+	return child_failures + parent_failures;
+}
+
+int main(void)
+{
+	size_t iter;
+	size_t failures;
+	struct thp_settings current_settings;
+	bool failed = false;
+
+	ksft_print_header();
+
+	if (!thp_is_enabled())
+		ksft_exit_skip("Transparent Hugepages not available\n");
+
+	if (geteuid() != 0) {
+		ksft_print_msg("Please run the benchmark as root\n");
+		ksft_finished();
+	}
+
+	thp_save_settings();
+	thp_read_settings(&current_settings);
+	current_settings.shmem_enabled = SHMEM_ADVISE;
+	thp_write_settings(&current_settings);
+
+	ksft_set_plan(1);
+
+	page_size = getpagesize();
+	pmd_pagesize = read_pmd_pagesize();
+
+	ksft_print_msg("folio split race test\n");
+	ksft_print_msg("=======================================================\n");
+	ksft_print_msg("Shmem size:       %zu MiB\n", FILE_SIZE / 1024 / 1024);
+	ksft_print_msg("Total pages:     %zu\n", TOTAL_PAGES);
+	ksft_print_msg("Child readers:   %d\n", NUM_READER_THREADS);
+	ksft_print_msg("Punching every %dth to %dth page\n", PUNCH_INTERVAL,
+	       PUNCH_INTERVAL + PUNCH_SIZE_FACTOR);
+	ksft_print_msg("Iterations:      %d\n", NUM_ITERATIONS);
+
+	for (iter = 1; iter <= NUM_ITERATIONS; iter++) {
+		failures = run_iteration();
+		if (failures > 0) {
+			failed = true;
+			ksft_print_msg(
+				"FAILED on iteration %zu: %zu pages corrupted by cross-process MADV_REMOVE!\n",
+				iter, failures);
+			break;
+		}
+	}
+
+	thp_restore_settings();
+
+	if (failed) {
+		ksft_test_result_fail("Test failed\n");
+		ksft_exit_fail();
+	} else {
+		ksft_test_result_pass("All %d iterations passed\n", NUM_ITERATIONS);
+		ksft_exit_pass();
+	}
+
+	return 0;
+}
diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index a0b4d8a52980b..f54ec9d0edb8b 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -555,6 +555,8 @@ if [ -n "${MOUNTED_XFS}" ]; then
     rm -f ${XFS_IMG}
 fi
 
+CATEGORY="thp" run_test ./folio_split_race_test
+
 CATEGORY="migration" run_test ./migration
 
 CATEGORY="mkdirty" run_test ./mkdirty
-- 
2.51.0


