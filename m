Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5977DC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C391B6B00A6; Wed, 21 Jan 2026 11:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1BC16B00AD; Wed, 21 Jan 2026 11:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6846B00AE; Wed, 21 Jan 2026 11:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8C96B00A6
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:35:49 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41332C2958
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:35:49 +0000 (UTC)
X-FDA: 84356522418.03.F2D2D40
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010003.outbound.protection.outlook.com [52.101.61.3])
	by imf08.hostedemail.com (Postfix) with ESMTP id 80E4E160004
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:35:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kEDQOQZS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769013346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bR9zKqdn60Z4qB8Jyy34Feopgg7Q9qrnRRoj00n7Qwk=;
	b=vErIiTKVXnKYnM6oZnQEIQmVwTqfTZH5nROlY77j7VFwbeP+47D4VlSt2uG2LnnpD4HYNM
	4RPT5kdP9krJYkesdDTPhZ6MJ8OAPKhdCfxFkSS5dNN0wKSyi/gkKeelC9neLOzSwfdzvq
	B8t31YeIIqXgJ0egWPMZQWPzxEp3Kvk=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=kEDQOQZS;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf08.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.3 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769013346; a=rsa-sha256;
	cv=pass;
	b=4KngorjPjZ/Cuqmk3Fbco4KIx7nedcuWFM/2BJGohVujHuZXUn2yPlAxcCdS9EGpQoJMgc
	g8TMUo4qwSTibNt9bYWk2SePiPFse3SXoh4URcqGWaHdcGXCfL6vOcoKwM59YhReYAckzw
	yWjJSy5789CVrOh0nwkE15VeCutUXao=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hle3F+Y70yz6jFlOk7YbrTsMxf2NQJzVsVa4lboimNI7/PAjVfY/vUdJJoniDlheVr0MrW2veSpCWTMEm3qdRa4Fgj6U0gj8RUTgujnjaHUs8lY6O7+sPUVv8CWLnIYvitOmfu6L3QXwZC2eJMN4tAHBXDjl6dt1RVNYi13x14AcAgpnKFR2Qp1Iwa1cZmw7G9wG583iNTadkrZu5u+SXSCtZnTquWCnsfRMEhD/tl+TVvwGcSkRXuC3vf76k9G5Rc5q43x364LUSDLDcdq7nph1u9pQIqZMtqKNsCyzh9vJVjesQ9GfjU92mzKKSqItPswSGh1E2Crj8qjN6kPC9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bR9zKqdn60Z4qB8Jyy34Feopgg7Q9qrnRRoj00n7Qwk=;
 b=KyfRCAkEFaOBquX4na2/SRHhR/+/LaKf1y0hadeqzYbozjGlXLEXgEXQB6MGoAPIpXfijd9KxmnpwN70j3g4RfzhoF50q5wrpbfPfVICM/xGBbTOPWEpeQHTLP63Pti1og3qge6N6YU1/MtRrm2oTo2Vxbb5ZjgErwfuS2qXPdbabyZxGLdqet16LpXHHlFRY5/k761g6aCbYz3uDbFht66N/dOHiwgQpnsIIsA6INRy8MluSwFf+UQUcsxmJxFAQbGyPsHP4SwyGp0E3kPDs4YWUXvtYhuIVe/n2GLyZbJBLCPKQgoDa3TrawfkBJLajXDZGkSGxncIYL0pfdLBDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bR9zKqdn60Z4qB8Jyy34Feopgg7Q9qrnRRoj00n7Qwk=;
 b=kEDQOQZShRIVmQH/t+hAvYWRuYOugAetMXE3o/c+0mqQRotrapmGrim4uwP01y7LVWF0L3Xwg5yIOadvYKnItDDYXcq3pGEqmb2OzZbCQjag7SS1feSD0VNJmwTSyZCzGPjI9dHku2a7k6RhjjWOYACUvA+SWayE78ZqBtUdmZVA1G//Rvy2jg+bbxfENKkVyQH0sN7VMLvH8mOfMknc3Q1TQhEnOy7GJZxeCJYIRqV/DBOWdcsoBSJ+aak4mUhuwoMd7NL2JKQuuKaUMqYdnmWWFHFm80W23nSoXZd1rKnAA7n1EmyXtclnD4ZEmUlhMxVZmjcEca+mfMCHfNAx3A==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS5PPFEC0C6BDA1.namprd12.prod.outlook.com (2603:10b6:f:fc00::668) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:35:43 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:35:42 +0000
From: Zi Yan <ziy@nvidia.com>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baoquan He <bhe@redhat.com>,
 Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCHv4 04/14] mm: Move set/clear_compound_head() next to
 compound_head()
Date: Wed, 21 Jan 2026 11:35:37 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F8A12704-8573-4F9D-90A6-0D54B3EBEFDD@nvidia.com>
In-Reply-To: <20260121162253.2216580-5-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-5-kas@kernel.org>
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0029.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::39) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS5PPFEC0C6BDA1:EE_
X-MS-Office365-Filtering-Correlation-Id: c08cea46-0cd8-49b2-0cf5-08de590b1e9e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?T5iaKd4FsTJpLSaG1gw+3/+fLZV1J2imAxtqUBuCvrDhJnTzBYHdj5UWS8vA?=
 =?us-ascii?Q?sBIbdRkUa8ULB3MaCFp31pTOveok0mWuyzCCVfXFmWVolszYKJUq8lk0W8UY?=
 =?us-ascii?Q?Zrg3LoDxhkcO/cn96HoLx/K603N+sqv+nwN1dv1XqrMJ5xFRSYyQ3t6wT+Kf?=
 =?us-ascii?Q?bKqAXWTiQwA8sbNNKiouXJATMZ/qipBfUEI4nw0MtMasKzVQG5HnTonY8z4u?=
 =?us-ascii?Q?Vey7LDJPn7OhpMM9NsC4D4qQU6DVL9qixgLEYDc7lr0A/qMYT6USylKdMDZP?=
 =?us-ascii?Q?Zdou8OrL+IDBj/6aXk5tG5Ybxo0BOE/V1l/UOBdIXWD+Zt0sHWnwQUfeJFyg?=
 =?us-ascii?Q?PHAm63DKD1cNXBAaW9/NGcp2BBisVJfol0oXndhqElocxSvTvNm2ER1x4CDy?=
 =?us-ascii?Q?jKgJxAqoqi8DDnzhECMmwSoGozBdbnNQ2eaE/kCQPL7cG9UPWYu5zk9LU+uw?=
 =?us-ascii?Q?2lJEUx0TsOnGCxNkyWC+wqd9mwFxhUeim2YGaeHExlMjrNDN5cswccrLsrRC?=
 =?us-ascii?Q?N0t5F9VVuD2Bg63vtd8cF2+6yfVaqASgifp/nKi2CDxWuZt/u4a2nG7vFJZc?=
 =?us-ascii?Q?ZhptddDSnRZw945HOQqK7prqWqxzY4ZMZwuQm3a3RQEKcarLlI5MuiiI1FpD?=
 =?us-ascii?Q?GSJupe5v0vOIxwbpNxb8h7JK+cQ+9pEjpPTH/aBvlFYvkCRwsiLRqL7XQ8+U?=
 =?us-ascii?Q?5+B2c53uMsHydGqlGE2N+kpYT3WRBFJU1/+TDl2H/WJQ3dfjkzoj80MA8XWZ?=
 =?us-ascii?Q?GcLDfQsfEIdf8ADnezcPDw2wDiOH9I4vzeVvLrMq9U1gqEabOAJKHYOcaRSb?=
 =?us-ascii?Q?eeCxcP/8HW+INxDjE8AgfFMYiHM1PgV/QI/sqks17+8/+rV0Fzap1LthvQhm?=
 =?us-ascii?Q?ovMrYyuP+61gJAf1++1wGBxLZjYlrCXhcaLLsso18LfvriRV6yeIoXpWyy3L?=
 =?us-ascii?Q?uQ3YQnL6Q9JHYBeQaj3DYHI+tNO8ZqX3fsDMf45TcGZYt3/EDh1CGRGE9sav?=
 =?us-ascii?Q?SlnRvIs15fMX9YsxDyU7evjWhGXOeaqdyvNABHNNhimJamJBHD9UtjmOW0py?=
 =?us-ascii?Q?QsBf9/jINw3rQPGE2SX7ECXXrEGI0JZ+GxGRN224A8KjiXLZZNP4/nQfisji?=
 =?us-ascii?Q?+Kv9iL5wthG8/RkZ9RR9ddJqffKFQrl1I5INZ1QTj3X3G17RAMk69Ja1GUI3?=
 =?us-ascii?Q?HNiQ6AWq9f2VDJTJz1A4nJNo5QHgWEh7BjhQLM5w1KvHdEEIvD3o22E81MAJ?=
 =?us-ascii?Q?yXpkOVL6gGlGwbEzilRZgabEn0o6xKAjDWeeVynslH7b31bVBXrmPZbR/ap4?=
 =?us-ascii?Q?7LZUhQZAOK3XP5SncGvQX+T9kKEY7vFZxA7CIPwedTRWsaCpF9CGmx/2BuU5?=
 =?us-ascii?Q?h0zLbjna4kzs/GnWA67CdKlTAbgnoFNLbGj4cynUw14kil7iBVvFxe1RjtOH?=
 =?us-ascii?Q?ahcqUWl8oyuorzash0Ih7iUX/E+NJHoZwhIeWvmChM0Xx50yAPrr8lqdJTca?=
 =?us-ascii?Q?tzmupU/ZysuN54m7aFd4Z4iwX4oZwx9BQvSpWRCyh4/ufCsTII6Iwc4RMc7i?=
 =?us-ascii?Q?F+41UdwdBeWOJueeY1E=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9Cc77ZVYLn0FtIlD5ijfumyYgc83guSg4ViS5Oj1vJPtUhvZ34HlZnrrTjKJ?=
 =?us-ascii?Q?bu+DRCYK83A7sKvvmtshQzilzw6JsdD6MdFb6mIiVVd62slC4Pl58JXWnn2+?=
 =?us-ascii?Q?OAgV0/cU7fK4ctMC8G5onc/2GgTSmLuA0hsDs4ETGdFOETVKvYTY8qWOWUH1?=
 =?us-ascii?Q?3zHfspTFMTTe+ciuPr8t75So38jyXF6A3mDbHO0cx9Qb0GNz5uXYwgaX4r2Y?=
 =?us-ascii?Q?fAZjCfaJ6qPwR3oaHmHAcCwdTgMSDiqnNombxxMTeBdCeXNxpl8HOqpQYQei?=
 =?us-ascii?Q?jptgArwlZQKQYYheFG8E0QfprdZK1yN2WLZZmlPMhDeg3HJLHuc8F8LsINiQ?=
 =?us-ascii?Q?90Eh83ckSm7sZbpcMsdH+U5qSXMpyXJ7+hxRG9ZRHv1ssEyfC6NNbIPmAzdt?=
 =?us-ascii?Q?OX1oVrgjb+CCEs8YbKPdVHFStUuZprTt5tKM9sXaIdWSbsMlWnVlhG38OkfF?=
 =?us-ascii?Q?NMhalns9TNOyvSKxQs42MkAaN56BrwGp7guopcDoty58Zf3A97vytju9oSj0?=
 =?us-ascii?Q?wQ19UIjRTlZeCIgXzia7T9XEjpujgJ5nYnXaV3p6Q0+DUkbCKtF4TSRVuhpi?=
 =?us-ascii?Q?VGhmtJcTSGCwhf6M2zcl0mEgy46K9u2LCCXj2WZBbDra+M5x6AViWyQ9Gh+c?=
 =?us-ascii?Q?dX7YpETDkDod/iC8Xzj3Cc/I327shzmxirNi3FbrUUCDZjDQlWbYzbn+aCrv?=
 =?us-ascii?Q?6ywMPNZ+23ROOHfWD6KTaTqKZvUTkGImmhXKpCMRz9zxP87XKG3YdSztzlk8?=
 =?us-ascii?Q?NHHeoxCr+t+6oI9MS3r8zeC4+51J3XNZApV/VpEazkWHJejWvHIHkDPySV74?=
 =?us-ascii?Q?OtCIl6N8nYbeHP4MLmMQy4tiQ+S8jpf+ROgR8Z/SUiUMsy+VmOStv7MtnaH+?=
 =?us-ascii?Q?20npojhuaT/GOuoqp5SpprDTDDzjQEMzycUBxJtCHj80HjsGwzveL0gX0Dyf?=
 =?us-ascii?Q?7Khizvq1cD0RnpFlAkpHVI0eeqt/qTWO3ApRXJsl2/JDBAxMZewB/lVwEo4l?=
 =?us-ascii?Q?6AY/DUVJh7gFp0Gl38EoJ4yfJyxidV0EONWWx+e2i9XL4732npFG+waDR0sl?=
 =?us-ascii?Q?gmbQTcCA9rrHpSNeqCFivbOXYnifPPRl5BK+Fd9QQtxDRAmLFEvQLVFMbTY0?=
 =?us-ascii?Q?qWmhnUMhKnQd9z0t/B7rbci/RooL9kYZRKLntTpZ/lXSMrLTYHv6kPH0YF4K?=
 =?us-ascii?Q?iVWS1437Oi8fS79cfuxpLoIEP0c1AuiROAQz+btrB0tfvD5D6WX4c8o8sbXJ?=
 =?us-ascii?Q?htnTDGACnb5lRvPsjiKxlSJakwLo7yy2NxNj9ewm+Ix/8xCC20lZZy8EiqLf?=
 =?us-ascii?Q?6b8STPzYIatF7nOTliHGQkaCF8yDGYw3IX5yjVL0VOWwVMRFFmJyCO/BXRH6?=
 =?us-ascii?Q?P+22L90jS7q8+pGFwTolrswW6ksJyzjkc/iYWOuHxAFqnava6hxGMe+hjtoi?=
 =?us-ascii?Q?eixqiOrKxxeATDLSfI83/V6aALXe0jsxymWW61sh6UnETKji3Hzp2bVLmVBr?=
 =?us-ascii?Q?2rlyVHJq5eOKNy/tcHPyUsbsuLVc/oXXPWB73Mmnx68R2Dl23My/1vQlJWec?=
 =?us-ascii?Q?FvtX7VsYmjvPAoYsAfUarpsiDkKgBtm5MvxBM+wRDuJxerk7B+KdbPRmrOjp?=
 =?us-ascii?Q?QQ/oFEIUdhlmQtb36Cdv5JzuA95zR1tdMmqJImntvguhuGK0L1742RzJweUC?=
 =?us-ascii?Q?KdT452jIrkYay7n/5GfC8/8+0I+0Di39v+dTw3Q6QMMlE3bgpQ3iKPag2qpo?=
 =?us-ascii?Q?M6j9w7WE9A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c08cea46-0cd8-49b2-0cf5-08de590b1e9e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:35:42.7721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YP5m6chpij5vIVnCtbWM4qZPgoJENnQZ4QdzsxXNhRRphDS7d7SqVxPoPoLGCcn2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS5PPFEC0C6BDA1
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 80E4E160004
X-Stat-Signature: 1r7efo58tz9qcxtq8mfgh1fa3uc84dcz
X-Rspam-User: 
X-HE-Tag: 1769013346-56257
X-HE-Meta: U2FsdGVkX1/jd09HJYlifZUKgtV5lp2Uh2fCrkiS2XaFXLgodwSWjNEEcmDbbSN+WrxxvK7g5/Qic/YZsgzxR1tmfENeAhr0DZuGo/z9uPVZTJapv8ivcU/VgtFm9qiv7qoObQ1qibAhVDsk3cTGhwMDk7s+klVOqV69XCkcvhlFGf2m25pWm2Ahigmprt95AAEouuF/ceSk4Vd+i1cin0MXUNXW27jV/Uh4qVXVMbvQ57WcOw0sxZ7aE54YdINPQ9JxwGvarmbs5qaIv2uqfhhK9GE84LHG5d2AgHNqRkHCp9Sf7pccw+JQOgp67Ydli+PuJJC3TSdrQ9BqSuWygG9od+4Ack8asoXJwKWM4sglqzftpny1N0KzsvcSb/EZwBgkWvRP6fPWhZrUYQ+rji7E+8/f+DmmdpE6mtEsCPvZ3VrOdPbyd8vcKrpnfrShEGtNl7D/MDjb7v4Fd4WYVVzL2N7PCSyiq1k2SjfbJgs2C3c0ekSnx3HSQ3LHjG0uT17CqfL8VRzjImGPGZHBYWblS6dDIdrf3UjPksMBNMbju4VyuJdPfO8o0FxFErVBxQl4ymXB9irK22UeeeVxLdbc9K28HhXzizK0Y1EBLQPb0YMp0l6d7g3wPTXEaIWvSHd4luK6XDG38M/tpwD5ruJOCBQ/LJwDuGtK++9qnhrSFuU5o79EtUA9ZGzwF+EpyXjNyGuh3IJuJupLcRdGoHtBsludzx9Io6lZOBhWpiYDgy0NxYVQs0MbuNJMHGwbm2vt5YTsaR6PaL8Zswnp9HQR6lEUw8CnI1QLnf3sbFQeFqynFP/0p1F3hpdsw3rIhIPtI934kgpm1oQSwZnIUMS14tbNObc6RFo5CiaMmTkkjZWeiKqFCwq9/LRMc0Fu8FteJshJwz1SiPN/zoXY6KCNRdtXfXnxRJQCqKEtpwWi+5/vGNsTGBHqOcDbUW5QEOaUijU0VdyqcJ8OH5F
 4cI8/Kv8
 WTbvh30prpshA+LC+jWbHUNKCr2Oi7bH43rzko7v1j0eba6KD1NFVonbj37IWlCYitaDaI9CsiSsOKD9kNKA6IJckNT6t2irYmq2S6hICWf/IJQailU95bNwZQKTDR4DQbHr2fX79MMuwTd2SI/rWIYAaXcaPipb0LhPrrUa7ESZzVDn6Dh6s6NK8Yiinh357NFJHk83wh0mVem8RiLlIvRFItbUPUeBKVuIMYesJGzl8zLdo8AX4UXOFOW5ytiBUlmrQnJxIYYPFMmu7Zvw6JC3sBVaBeer9qyFViom2hjDIHCYVR4HKN0vhNcYe5agURK1DxfZ+SMnuAjLU4TUkuqM3BlcO1vRJVrpGFQGg0WH5GE1zufN9bD7ZA/i2Yv5VWrqvsz/odP/1UriQl2SDhRegdsZUlAauxJA60aB8VtkLqi7bu05Nc/3rBGlnHr3ybZ1k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21 Jan 2026, at 11:22, Kiryl Shutsemau wrote:

> Move set_compound_head() and clear_compound_head() to be adjacent to the
> compound_head() function in page-flags.h.
>
> These functions encode and decode the same compound_info field, so
> keeping them together makes it easier to verify their logic is
> consistent, especially when the encoding changes.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> ---
>  include/linux/page-flags.h | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
Make sense.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

