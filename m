Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 396FBCAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 15:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9050A8E000B; Tue, 23 Sep 2025 11:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6038E0001; Tue, 23 Sep 2025 11:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DA88E000B; Tue, 23 Sep 2025 11:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6458A8E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 11:07:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3009FB9A0E
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:07:38 +0000 (UTC)
X-FDA: 83920844196.11.B7A2EC3
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012025.outbound.protection.outlook.com [40.93.195.25])
	by imf15.hostedemail.com (Postfix) with ESMTP id 63021A0020
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 15:07:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DFtwUstN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758640055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nd1hfAquzzqGYKShE5ht9v9tAdAEeTj+4NOPMBYHgbY=;
	b=Ezhh+zjFoLuvHtKV3DlRapp0iQRmF2u63GVVAHozP2giwMtQ1p0an8Sns1VtZHSzHyc/4r
	nh+GztGLdDmoEC6hrEUQMnsG3gEoaxNIxdkzOyFsGJPBlVf9y7aeYG2Nvz//xSXB4W3+Pn
	06Swtn/ZxvYJb/sOpbp+WSZEfH0nGOw=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=DFtwUstN;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.25 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758640055; a=rsa-sha256;
	cv=pass;
	b=quM5JWERbavYd7XyXgjUjz50rEk0v/SteledHHI/74ZJglXPbOX3w0Mqw2bFv4fvRK2CjK
	vIUUuj8E3027kHfb/3hXQ1T07LKKuWK0aDgl3ItcE0ZHYtpGmpG5Mcd7irgot/EGJ1DdKX
	Zu+zk5LMtHuJq6IJ1hGkdbkP2yBVnn8=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Iajbgv8gApGOx9jT830m5ECCdaROE2BQrvRzYJu4F4nqx65TxSVjUIY0guzp9816AqHXYb9E8N12p1m2wgFizdfF+u1HL9qVXqRuvxuc5hFnAheKNqLRqOSSAVZdzGMr4GlnQ/dNihacEMpJFk+S1qmaUDmmhFJZxS6myerr2m79SfzmO4fA7LBDgwIg9j+mZsUlNfijYCERGGcVaIOhH1U9PgqZflXKUIowpGu1Ofu9a+y6AqwLaXtZI1y1p17eTWjBoUI9nAjYEtjPT6IVNDj5fM4IOsM2HKFQ+vdZFV9v8IoSBe4eVsly5nXiHdo+SdWq5S9gu5zUbPF115jFrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Nd1hfAquzzqGYKShE5ht9v9tAdAEeTj+4NOPMBYHgbY=;
 b=suPCfrtr1PY3rW5ZDxQBqFc/jMSORxjjH5OHB6o+jlou+cyq1jzsAWkoXi/SMEElRnVRFkaveiZ+aSgpqVExmmiXzeNOnUKtn3B6WHTfE+WmmhqUliRnKaRi66y3tZQzHpgXE8+E/dEKfWrQ6wruGMJEZYfbne5F5alVvxDciCFdLOPOF1L/E9V2O0GAC7+6UKiyaguwFFc/V+Z7HBueWuRp4njuq1AFiwTf0neKzSli5AHOcJpSxg9Y8lENDRL2puO7KqujS6S7D78KpuorNxPDvEhkyzBg9eNxVkUtwmgDYCOX3cm/iIOBCtFNB6eW+ot0N16/7rtdKYcbcIh+oQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nd1hfAquzzqGYKShE5ht9v9tAdAEeTj+4NOPMBYHgbY=;
 b=DFtwUstNgaLkYN9XveEDS0zlMdcwbWtWgsMvpaKmb49QdEWteCrMhLiB2pGVvG+rGh45aW8xriV0J2ajobN6N4QdiZ3k5UQHP340Zj8B1ook1zFhdQ0SAmYiDJevK3UX0m6rPDDRy38UZDh3BPEJ2OPi+BXWDOaYxgPfmIdN4ElUpFEX7p520gNwCwjFlHkARJu8pOFX1E/1cUFFQMF6f4+109l/CNGKDfsOIwwmLiO34A3c4AjXzo8kPU8GDn7oTIM1KKj+Ta8S8lm60wZTdEijO1ust2nWOWslwZUYLyoeON/B3M7mLUoawSeyRJYNoY9yrZTu1aR5Yc+i8VM9Wg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DM6PR12MB4316.namprd12.prod.outlook.com (2603:10b6:5:21a::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9160.9; Tue, 23 Sep 2025 15:07:31 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9137.018; Tue, 23 Sep 2025
 15:07:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Dev Jain <dev.jain@arm.com>, Wei Yang <richard.weiyang@gmail.com>,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, linux-mm@kvack.org,
 Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/page_alloc: fix alignment for
 alloc_contig_pages_noprof()
Date: Tue, 23 Sep 2025 11:07:28 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <760C8EBD-9201-4680-8B9B-CAD7641A81C4@nvidia.com>
In-Reply-To: <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
References: <20250923001943.2479-1-richard.weiyang@gmail.com>
 <3BF1389C-4B8E-4F50-AB0B-F0D96833D387@nvidia.com>
 <5491dfda-862a-4c31-b64f-5339007a5302@arm.com>
 <09284390-5a1a-47e0-9929-0a5ba98c836e@redhat.com>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:208:32d::13) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DM6PR12MB4316:EE_
X-MS-Office365-Filtering-Correlation-Id: c0ca8e31-6b34-487b-b941-08ddfab2eb11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hrFzpnrASmieLg3iMo8jf8g1xMFdZahQyFavsWhZCzQkJEr9Xpcdaxn24Zqk?=
 =?us-ascii?Q?wNSxZY57uatw/8bCHSjBiTVxH5+tDdG1ISZwX8FGaS0SljDkGcrKVuKKehw6?=
 =?us-ascii?Q?KOA5Vn4O/RRXm+4Tilb9FOd6sikzl9Xi/6uaJ4p0Efcip2PU6SzE7m3bKQFi?=
 =?us-ascii?Q?pAu7Ch0ZG60KAxuNw99RHn7T+23G5IHrJo7cn7lcK5sfvMAIwyn+9hJ5ARu8?=
 =?us-ascii?Q?eyf5RKcMzwWBsJSCIqSoLb2zNzc8BF7WqWNXytmrx7jDU1eh/6F0k1CvMUW4?=
 =?us-ascii?Q?Z1F5vLdNSvIB6pbcRghBDUbt8ZbbqcTAyf51mlSqgBUF6ZRFwS88FjrIaha5?=
 =?us-ascii?Q?+1acqAyDPhaootS68FgKrqaOmERURK3faTAnwen7pSCOxV/PIoe4IH2zD9t4?=
 =?us-ascii?Q?lkT3uR1wKM8isJ5eGrmF/RYkLNNA44PwrWp0DGu87cbka4TRE1xp8RZl7F1K?=
 =?us-ascii?Q?ECSHI+0ANiRX6PwhMO1WWCZicWSBkFKJiDVfzI4Q/3vVx7WBMPFsongkEDkt?=
 =?us-ascii?Q?McwXFo8ODNnyC0rmx7nElnL0MSwZIZZ/8/GokMJabVxcnVkNObKQ81q4HPQl?=
 =?us-ascii?Q?1xPkj2GgogwkU/Z5NLn+V7mAsozwBD1gzkOlTSI0v8OIKlpF+NouNf2kSuw+?=
 =?us-ascii?Q?x0xSr0PGK0dgJIVBqqRyqNfay6Lt5Hld4yvQAT3RqKIeJnI6Oekdt8Ew9jiU?=
 =?us-ascii?Q?4vyrIK9n3LcrHDOzX2LyUmAXyo2bRgeqSUkufFUr/vfWZ54YhX1pbP2ggrvQ?=
 =?us-ascii?Q?Q0zX82w+Y7MrAaSVPkaqg26lg9GtA4ynbg0TEovVkiysOFWf56kuivVey+nx?=
 =?us-ascii?Q?GNKqcaihqm8BfTL9OQfbK0hEExO++7jM9+LliAYWYjWLHnHU8e07fEk5XCaj?=
 =?us-ascii?Q?7oluR5yL+Z+exdKkmW+siGV2uxCct0ICmB6HIdshfQv+e1OgoAH1KgKnnHtm?=
 =?us-ascii?Q?mfmkkuGu2F32E5KTwOA6kKBDcYegNpeIKj9T962bLzxFscGdE8Y9/kXhALKH?=
 =?us-ascii?Q?FTUoP6VX6PDueInaFgC7854SnGnfZ+RM99Xi7kH+z+e54Mfg7ZyecyWBTmMh?=
 =?us-ascii?Q?yXZuXVOH47ya3kEhkLrPl6nkNPI7a8ICnUtIOBFqMib5UogI7X42dg/KYWIg?=
 =?us-ascii?Q?JccI1k9nP4JEoKjKsi8mTJnDp1kCPfPOgXq0WqUvJs3rCQnP9HNTgvLjfjHT?=
 =?us-ascii?Q?vYADecDT2YTaXD3iEkUH7lVKJPYKa2N8sffnZpptQPu916I56GRe1hefRrAm?=
 =?us-ascii?Q?wXhnMDOUp67zumgTNTXki21XpyVkE0XT6f3FxisZtkYXnBUN0glgj19W4Ywv?=
 =?us-ascii?Q?sfxozyhQLI2ZUUTKdXhwZXqkYcDO7ZiW+AcvcMmIRq381q89o684P7jmfJNp?=
 =?us-ascii?Q?iMdnVvQiSuYTvc/nf8YvrcTXQI5ccRyRaz5+621wgD5PcmaNZA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cm8O0c6rYaqNEs6Kyi2bLwP8i1k+tXqo4pNSHOwinJ33Gw4BLklalMk70e4a?=
 =?us-ascii?Q?aSrKhsd2mJMf3aqnUIqTxs2DKisYOF3GTyhtvQn2iQsgPTPJMPIb6WU+ZpfG?=
 =?us-ascii?Q?88Tkn1VpMa2MxvbNFQIPTw4bEDzbv+BeigZKOR0rUNRemWlVaHLZOuO0CP5c?=
 =?us-ascii?Q?m6nyKJ1Nq+c/H5RPKgnp1O658J3xrXbBwyl6EMsEvaWd2O2ac/2OAki7/71E?=
 =?us-ascii?Q?mx0FlNLrFbyLJx13O4JrDH0j5JlXnvAoeCyPX/6lZzAcvj6kNlAZQztPXYvV?=
 =?us-ascii?Q?oeMPDBjn2PYGItn2dKTBQM6qk+rv4CE2wo8T4wTb1DTPPFUI0Nli3pECEQWe?=
 =?us-ascii?Q?DQwyom4ms406Mv+KQNI++l8WPDpRQ1Tw6WGJVqiUUoBc+V2FmfPQm40r2JKZ?=
 =?us-ascii?Q?fH24gNyt05qH0dJNHP0/aTdJsaDzA4fF8OL+J5Xi8fBtRlZG2am4mmZhl7Wk?=
 =?us-ascii?Q?QGtoeQNkBVghK+lMROO9HZWCbcUBvnFgEmjimkIITflRF8dw3Qq/5f3Ob/kp?=
 =?us-ascii?Q?VJ99do33E7w5frwg6TaocrPPq3pgcGQhngNqOy261bgGFRXiMzjph8o1ehfC?=
 =?us-ascii?Q?IBL7E8DUxLaA/cWWUPBAYCQpUOHfMvKQpxsY190hKJspiN2ut2iaxJ8mwqPm?=
 =?us-ascii?Q?iw9HjohyQJM9IamFEGu0CAAtS72tzk5vrl/TnPuGZsW8np9SB4csMWEWE3sL?=
 =?us-ascii?Q?Z1uCcD6xzzNW8IMxXnGei8JdK7lIEppmOUUPBKSmkPOQ/9KznQ2LoqkZozN3?=
 =?us-ascii?Q?YlEo4qwx4z79qQBHF8lFfsy5TkjfRkK1bk6/fK5fGkuH4ssR6AfmGHY5EEdJ?=
 =?us-ascii?Q?crhMopEL+OTX7pWfVFcBIRlCUumwm4TO60/1RBeTv9UVEnvIXJ/DhIwt25Tr?=
 =?us-ascii?Q?xTPVOapkBaQ7xqzzJyKSZebM6U+uhtWX4u2rO02U1Scqm5Ssbef8eXvdSTkY?=
 =?us-ascii?Q?4CeRTSnAa9bN+VVH/XPmhLwOWwOurkAURh/IyoSUPoPf/jWoh8thkiaiMq6S?=
 =?us-ascii?Q?D+xDaAqH113s1PYCHY5AzcpRx0kTdcPAM8tsA8vHHoW9fcYsYwVan4aibcsH?=
 =?us-ascii?Q?4nYsC9ZhB2a4A70u6JSpbncPy8BJKA2GDBGajAY8T40KiCOFPWpTvxfWqdrE?=
 =?us-ascii?Q?MT/eBpaSYXjlNqqfxbHWfACh7AUmunn2B9phn4S5um3X1pjQw/tj7d+rOmxs?=
 =?us-ascii?Q?CYmktx/+NjTcNYe5+LoAOwTOvXjvemmQ2CPEhQhAB0Tx56zVVeGtR4OQsJKo?=
 =?us-ascii?Q?YNW6DXY+cYFuEM9WnZwHU2QiI1AIX5YxBmjxIJ89L5sFDu/pyOTIuM+G7RNJ?=
 =?us-ascii?Q?mjVrZ0hBkZmyOi7FS8T1YnBR2H+SbhsYSDY9cKX1sORRCizF0ADmGHnCF39s?=
 =?us-ascii?Q?I0SELpBdQp3oaheBAn+jwi40BB70P0ePTn9ydZoOVs2iGK7rHHwG2QQc18gA?=
 =?us-ascii?Q?OZIqdi9VXzhZz4Er5JsxHqsKTRn9nTpsuy5G6rxXUTNfBxYxBt53ALj1tjLw?=
 =?us-ascii?Q?q/izKPoeSKbq0U/dIgF/W4JI0IWt/zmnn4FdupbenjmIqMF6MRZO4yq/s/k8?=
 =?us-ascii?Q?AOdLDHtMOw/0PHRMJzErPSmytgLKVyR8PfwelcjA?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0ca8e31-6b34-487b-b941-08ddfab2eb11
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Sep 2025 15:07:31.2665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLJzQJZ4ycMqVPr2OTx9Z7UegT1t5qKDiehc3VYsAXbEtXNxqXRA/x2YiDytIkvZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4316
X-Rspamd-Queue-Id: 63021A0020
X-Rspamd-Server: rspam05
X-Stat-Signature: yojxpss4d17qpnn3zhc18djmkdhjadsj
X-Rspam-User: 
X-HE-Tag: 1758640055-112466
X-HE-Meta: U2FsdGVkX19DHTsEgCuG2LCE7QGMhPbabEJ20j78yHnlLMa2iyDE9GiyE8ovqMWz5JXbqffMT/UynLV75Fw2lXb52GJc7WA1gd8z7g+ekUzKIq8J4WAW5ZcowHNiiSihAHxyBW4qMWQeYmQ1WLRoIINnlkZiRSRQpGlHQQ6liHlKr7dUI16K5xYVNruK3a4W0v3LIyGTObC0fWgi15BlPLPH0XnfPwfhRh5b8ENuT9rai0LhUXwjpvVtINlQAQiqogbO1rOxZJt7mACfqOueN9ISFl6jdgNHpCcy4phNEInXhbjIAjlbPbfMK1wkFwh432GzV0G2CCZ9Z+7uPkBWdXmie2PrkBuGhh5xQlUI+vMACyyxpdL78h4Uh1cjBP7Lm5ro4s3chi3vzrbRtuJNNDsG1aFRz73LJrMroTSjJAq2Gqh+ilkkBr9xcGmKip/YQSnNR2CQ4VSdjPbAvIXofLFOTYjcXgjl7cG416tBbMud1mWWkmMqayc28Or3wfmWYQcutJMk9fc4U5OQezSQc0YvlYwMEMsTZ32qH/2Ssj0fVhtMM46iPChY5O6eGtOfb+5X15ijlspxf7/51cKBUFGzdCs2vdC/oKL+kYb8XPNRSyLV/vGUnkmB+83nRzJayV1Ab6aftXrELsK/7kf23UBDXyzwu7D02+vDT/cztOAlITC1uGMUV0/7EGpFmHGfTzuRyrql7sBkPrb/Zk91gJT9FzDJmbCOVadI+2J0Q/OKymLOAbz3laNnRb56fabGOHmRYNlu9IuuVbEPaHfzpawzgL9FdLB+QuPBy4YiyXzpN71ggPhOr70R7eIy6WsaW6MAUVvIbncdAcv4FtZCbMw3WLHI6b7Gjb7eHYK1VIi3mlbQxeQLOnVAHNGWssoL7lIGJjBDKl98SmGS9Vwh3egHfBUEUIwJcuOR8zTRvazyMYi8QvwUjQjeUAhgWkZIDLp4tUIFkglqzRKKcSy
 9ejeEzuF
 2HTvE0fh9s8DTRvJPuLps3Id2IE+IkuVADMWhfxUx6Lv/f4drUIQTHpW1V1SjHxKF7RUrrVbSJUt+5aSdrvGezUobBoBDEdpOZvvQaDAho1twh3rrD99AsKKlwjuJIe1Fbwcaqr4qQqEb3yDFv1xkVAvZmjQx3WIcBf8YRkEjttZJ/dgJS4NPWn43RaoB8BcLyB9vfShUQkIDqdZkBTshNfSE/PgRf2rmAg5xW9n5LX7d6IcuVOXzHKxpuP1bYQP7ye6zQVJUBV+K782fl8Lj4tvEzYWGqO2TbIy9bYmvejz7SWuD9P3gT3DUR2toSEyrjRXeFnmGu3WK8ukcIe4Jak+z61P4ugEy5UIBC+5KoEykl9iMGbqYb0BPqe2H6Lp0Bw9CmenqdnqCkbywEwoMXT//cusGCn88pTGTVYDwEidfem0gdcH+quk0YCRnqPXoJog2Ar7MWSiGNC72oq4rdnsMMby2x9xuynUZjAaDwHRyY3IdR1fNi1MMjpaLeFzOYVgatjuNa7jGw+0TCOLi0e8CYUmSRhUTht/VbKqeZlLT2Hsbjv369cm2YwFIkr+/l4dd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Sep 2025, at 3:48, David Hildenbrand wrote:

> On 23.09.25 09:06, Anshuman Khandual wrote:
>> On 23/09/25 7:16 AM, Zi Yan wrote:
>>> On 22 Sep 2025, at 20:19, Wei Yang wrote:
>>>
>>>> Commit 5e27a2df03b8 ("mm/page_alloc: add alloc_contig_pages()")
>>>> introduced generic method for alloc_contig_pages(). But the alignmen=
t
>>>> calculation seems wrong.
>>>>
>>>> Since ALIGN() only accept power of two value, while nr_pages could b=
e
>>>> any positive one, the result is not defined.
>>>
>>> The result would not be any value lower than zone->zone_start_pfn,
>>> so the worst case is getting an unaligned PFN range. I guess
>>> most of the time nr_pages would be power of 2.
>>
>> Agreed.
>>
>> Also as Dev had pointed out earlier, this function gives no
>> guarantee on alignment of non-power-of-2 requests. Hence I
>> don't have a strong opinion either way, but does it really
>> qualify for a "Fixes:" tag ?
>
> I'd say if there is nothing to fix, then this patch is not required.
>
> What likely does make sense would be that a non-power-of-2 would be ali=
gned to the smallest contained power of 2.
>
> E.g., a 6 MiB request would be aligned to 2 MiB instead of multiples of=
 6 MiB.
>
> Not sure what the existing ALIGN would do with that ...

Something like the code below:

pfn =3D ALIGN(zone->zone_start_pfn, rounddown_pow_of_two(nr_pages));

Best Regards,
Yan, Zi

