Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBE92FB5180
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 02:43:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 390C46B0088; Mon,  6 Apr 2026 22:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340A06B0089; Mon,  6 Apr 2026 22:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209196B008A; Mon,  6 Apr 2026 22:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09C836B0088
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 22:43:02 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A80F3C2125
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:43:01 +0000 (UTC)
X-FDA: 84630212562.28.7893CE2
Received: from CH4PR04CU002.outbound.protection.outlook.com (mail-northcentralusazon11013008.outbound.protection.outlook.com [40.107.201.8])
	by imf12.hostedemail.com (Postfix) with ESMTP id BE5A340005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:42:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lP9qfH2x;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775529779; a=rsa-sha256;
	cv=pass;
	b=0CN1KMvWC0q+sRPYqMzBv1sz9b2MbFqaRqJ32cextfokIm+cmudccTLCDArUhXTYlht5O9
	2bx/gdlMANuGDncw6Ux4yrw9Hzz6udzYs5VQhSSkEdCub+t7iCQbkkAYZfryb+JPgrJyfo
	bhMKHwdf2HVE7xJKNxRY8N0ast92Zao=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775529779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wd+MVOdhHp9JnPxjvE1whER0EW5SLJ1nifyFLwP4ZgY=;
	b=hL4ZXPWDnNr8kHnDPqdtTso9twxzaGAGdaPqEjFAl1yQI/r3HsnvsWE99lgIgVNbbDsURK
	6xCKez7oWkVMzVXPQ7V39WZxwNCm1bnd8/w628JZEZr7CBp6v7RbyKC7HIQDgN8AqL7OLS
	AtRZfWm+8LjD1AiIKcUlX/gPOfCJQzo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lP9qfH2x;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of ziy@nvidia.com designates 40.107.201.8 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ojHEgZQ6ibuAsJS3zAnhMsy/84UGvJso7LNWu9jccUmoonOXPibTYnpFpSR4w+Yk28qrkjBjloZ6/ZaEuGKM+ycs90PzEWnnAOZO/dvhjqBN5lWV96EP9rNrO8NSwPS7n9KaCVk2EAIRK30lw9LYzr/1yz1K3rmZ8j/3vNpY+eszfEBVuIEK3y5KGhRynY60StEOu1JzflPdFZXcZk5BgtTtbt3hwSJHXDm7Eq6zt3dY6oRiXKe8Sq1oPg5Cnag24glL0kYv6Lw5rNfiWbssOL8f6KPmjbRACymtMVYF3eH2KbxZVx4B++NEz26ZGw23SF0B0nSkGM+AuSTbyXA6TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wd+MVOdhHp9JnPxjvE1whER0EW5SLJ1nifyFLwP4ZgY=;
 b=F+vqptwIsItVrrSBGOHvHcBphBF12m/KPi4HCR0LoX7Lrai57bd5Q2huIOi7bkhhiHPc7Z2OrTXVw0SbtxwYu+EuBaz44zgPDGYkvy8hsoqWtouQiPy6OoL/JGZx3MiuVSIJnemVzwlR3ivI3oMZvBdbSSzy1toZ4izmK7c4OQ67xIsz2Bfa3hdku2pKTf3NykMxBchkw4FMdOE6/J11tVIJeZLqEAcc+HsMjWFTUQeTJUDepohyjYbeokXZe/gPhANwzQuk10wh+1QClnBlTLCHuPJnN45EaMA3u/4QUMj80NKSx2KT3744rKzuTaWynHk7/3kdJLtHVvM55d5GRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wd+MVOdhHp9JnPxjvE1whER0EW5SLJ1nifyFLwP4ZgY=;
 b=lP9qfH2xGXgB3RbXN/oekU4oAPrwJ1fWdyqjPjTz7NFfGRv+0Q/DidszDQfSwTx0ZmBdocQfnCTGgHdEtSTmrOkQa4HAfD6Yqu/pmjwFspjCSvoYgyN747qX7QHJNdJsxQ8Jcp9kYm2u4A+vZuZ2xD7r50kf/JL9qjVb1hCcqimTXwt9i75MVCgcggnFSd9RRCkdJ9zHnkZ3grY9FMCkihKI/eLkujIrKC2IyTtfNB2tqWtsULmlFzODpbNQJPY5dQGX4GN/E5Eckpny2GSyRk+tqFTJC69nzselK0quspHpWUfYAUVuX1Uisk63nHrPdi6VBVdtPP0A1KgpGH6MOg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH0PR12MB8532.namprd12.prod.outlook.com (2603:10b6:610:191::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9769.18; Tue, 7 Apr
 2026 02:42:54 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9769.014; Tue, 7 Apr 2026
 02:42:53 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Rik van Riel <riel@surriel.com>,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] mm: page_alloc: pcp buddy allocator
Date: Mon, 06 Apr 2026 22:42:50 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <E057A972-42B4-4EA5-B46E-3663FB676A9C@nvidia.com>
In-Reply-To: <adPQJfmbpYr3-uzX@cmpxchg.org>
References: <20260403194526.477775-1-hannes@cmpxchg.org>
 <1C961B84-522F-43AB-ADCB-014B3A4ACD21@nvidia.com>
 <adPQJfmbpYr3-uzX@cmpxchg.org>
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0305.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::10) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH0PR12MB8532:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d8e5b34-c4eb-444d-54cb-08de944f5e34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	zdse4QHl2R+kjbOJdGLfshHRSbpjiHbieOL9Hu2A1v33aVqed81PlHyR9go8ILgFmllnCN9pHxUwRktawdX5rZ6oe2WovKpwGyMwff2aaX+Wz9wn9YZ0aML9vnaXK2OGygEBkDn50LqPWXxLnCbuTNdzmBu/llY1oBWxtn8H1HiWIQz19/iTaClrAiWtHOn79K1HD2EfEiyv9MBuxdInZe/PKFizyEWEgCYTaeRizi2pHOly2fNMQXIjA8+SUAopxOmEfVAO/EjXALeADzUx8C0tAp3MDN6UFAI/nMsspwEq2i7678g+uyfwUOa0nZvj5cowu5jBJbQuCSrXsqhLsIl7Laeh3S/Sk5cvuabCXnjq7gNxC16l6DCwwiHsyYluOTOuPc4i/qy3DTNxgjy5xrsCD1A2IffsXp8esh50WKPnXP0QQ2qFzqXk1K5HACwuCRuUkdLq1GsURbJk2tanZ4pRqqIHAMRUwDnuej8tztjbHiifrFpvT/IVZaqFVUpd6SxWXu2Ouur9FHD7DHcDiQWxad2/X66+2E9CnHejK2lP9U36QM1SJWfEw1ZzlWpWx0abBqlvUdDaqkn/TmncsB/WTZUoDzqrfN7SI9B/7mZrr6w4AaWQ5EHpwa1gHEfb+HlhoHQgzvQlyXTN8N3R+bYb71qC4gThWsENi3u1j66BLICNQP1254r6gCAK6Ag7U+6ay3RhmPc5lMezwmjzn9FRT97j0ZwolW7NksGsSeM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fUiZrH4kbxjDp/Dz6sGw0VU1a31T4Zeo6ooXMMe5yhfnPP0MXNYu7vKB7GRh?=
 =?us-ascii?Q?MN6VlYIgSI5CU/muhxnGycWVIhFQyqMkvrShy0gmNvn8wSYPeCpRIoH8wh1/?=
 =?us-ascii?Q?GMd6Qg8TpHPrVCYWi/S6xf3PCmSzhE0qCb1rqY31MW/E5BxVYMA3s/7mlBg3?=
 =?us-ascii?Q?0+SjshXhaZEgg7nxeLu1APsR1vg+ZCwaygSY1PQT8ER2/rAnTkIf37Cy4PKY?=
 =?us-ascii?Q?x6n8jhBwGRLUWb2CSFXMwtsy6t3cg+NpEZFa2H6OVoeCQo+8NOur7kNpGHY+?=
 =?us-ascii?Q?oPby//9+HimfrJV0zOChuIBZu9a50J7WiA3ljI6ha7/CTRS6U9dBMTaRjFqx?=
 =?us-ascii?Q?opj5jSOoKNL7WCEMcygxg4XBC0iu7PGYht9D+77SgjlGolsOGokfVyBZ/A6c?=
 =?us-ascii?Q?7oVK2PVekTIS985EWyQ+Drw1ZkB1BDN3fwTMJHV5M5KnxVA6Et+Wb7qmSFvS?=
 =?us-ascii?Q?4N+CsJkG7qFyk9j+SOEEogFPf5wax2PvPGCLtv4VODN8nGwpX5un2rw4JJ7m?=
 =?us-ascii?Q?/ZXri1hS1QhfNCxvfvVsQAUXjhtLVRTZ/eDrIv7kDqSfP3FuPB0SY0UGYjBI?=
 =?us-ascii?Q?m7cDJD9R44RT1tnUv7RbP6qv8l8Kn3o69hQLuSZdQU7iAryUg0mDTq/K5Pko?=
 =?us-ascii?Q?5tbY76S+ijePuLsG8SLpAqn8PSAU6pmwFtJpyF68kwLSBA5mbPfRXRpcnDnX?=
 =?us-ascii?Q?exfo9DZZpBE3sL9MYFN6D0EJ3KopB6Px4eTztbON6iIrsZU10KsGQiNaK+T6?=
 =?us-ascii?Q?Q/pbDSC6Dv6vJjXjtPbyIGzv+pXDquXdEzA8I0KNii9Q798rZa4s/6i5etaW?=
 =?us-ascii?Q?FRSAb/xwi070lGOdKY+1lydcGvNQP3wzqfS5CSHzBA85uJIadXgD9V6RJYA3?=
 =?us-ascii?Q?ROs10A+8AlAKhU66/PG5Wd2vEpDcEw268A6fRXJcED8JnkT0vnMJ9kKJTl64?=
 =?us-ascii?Q?rgF6bIezD8fr1DqmRgHvFfkr3yJu+UOibMrCIywYyiQSh/r/yoUf2dnCfnLN?=
 =?us-ascii?Q?7EqCaOeElbBM/DbCMbR5px36o3Uyv6YFNLUUZVI5xOnEPjmc+p31X5HrwTlV?=
 =?us-ascii?Q?eC3Wefqe3sDuRXWMsDcv4xikoA6ho3IVgpZIW54U0n7NTtNzXtcq+M6NvMap?=
 =?us-ascii?Q?lKMIZBo/RbReQIt6/Msi9decArFcDGiXMq0qfKJ5IiydJlcwL5R4uGR16L8X?=
 =?us-ascii?Q?C43ULhlZzfu6y/I1ME8rqjw3JpJM4zq2YpqtPyRxCKoDfKsRLXzH+8z0I/e7?=
 =?us-ascii?Q?ArZgMK5QN9lATeuPX6OFVHvmM18myV+vuQAFwC5IcxSADHVocZ894Eg+8KGr?=
 =?us-ascii?Q?VfACppPviH2yQJ8AahcJnV2Xr/yt3Q4fW+j9W8PvhgW637tfUz/03w6dKPob?=
 =?us-ascii?Q?0aFDtWThuozFZEpLqHX1V517YfLzdy99SnLORqOs333y89w+0QTksiu1btln?=
 =?us-ascii?Q?z/sJVNKPIzElRx29/I6orIYx4dX/irZ6zA8XJBbMkiA8bLnHUiJB5u9jFlSy?=
 =?us-ascii?Q?pHb4A55c7jxlCO1ecj94XDpdwzV883teVJHXhpiMl7dsw1gVyjhScytFsaCB?=
 =?us-ascii?Q?4od3P8sbvVB/8IAcd9QCvUWSsgDgQqQsbm+MoVmjnnoorMIsH6fnmKWAkzAh?=
 =?us-ascii?Q?m1svmntw0AQC3eLwD1pvciybS2JQypJYOaksaCBmEr/8Fvu8/lQfHlVXrRrr?=
 =?us-ascii?Q?p20ti6+kKJfWx/THJZugsWYFQV/iEqOsoFU9syV/IZK2QK0d?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8e5b34-c4eb-444d-54cb-08de944f5e34
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2026 02:42:53.8436
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EBRtlmFpRcnl/oLmk+kYDW69DrCN+uaya91OgAmm0dhPf8JZlPN9UkPZXAvOznJN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8532
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BE5A340005
X-Stat-Signature: cteaskjo84fef1jfekx1xrr4d8aiyehc
X-HE-Tag: 1775529778-292940
X-HE-Meta: U2FsdGVkX1/n+f2TMRJaL5HxDso+oxB9HQBlQ/8r+x7ci8p9mFFK6N585V4ZbK69nOLYCE/063hfGEE3Get7nDYRatS91t5qxX97VyJepESh6LR0o8RnFlT9mzLeOC/VNwP5ZR4EanQGJ/0QQtSnzwa+TPVn2decBlYeDVOLeazwq8nvNkqPD4082LVQS/CjCH2hI4RWFdG9IaZJZc5V+NqwH/eIDNRj/2eQnubOsG/fUnQ8ZhLPf4fBu9klcAEnzXZmTkNx4HRbNuOn6lQI4ocSJ0KmWlVRR9haxxlt6R6Yfx+cPdBdArEoSiMosjz6NDGQgTwIoTFOXR1ChHPNzO8UEr2EDHQnGTZ8cihwfrh0p4PMeeTawtXztiOpMYqY6gDExW01liww+f72ECkfzN7GzgxGTMoVab8FuBxILOgBx0DtgBL7Az/RR1pSInxJO0OiTLBWfCqc1tmQHJamDQNOCdz78lxzDw4ofLwff1zyo7TmkMB4bx+QA3y97zLLRc3LUOz2tyYRZT6060e2bQS+44EUvkiqC2p668RYU1KrbUogKuQRZINkgbtohI0dhdzuFY1ODtu7QHyRRehTktlZn9HlMvgEtHjZDAm6fgnZYMDfcP1eo/AxtlxcS00nDXN2qu42qllGov1pfsgAvQHKMPzEAY14oIud1TXDA4934U0QB25hBI3s25IgYPOWV7UWX6Y9ctpK92dQ8YRl1dSCd6uCaATWfHUkOn84mn3wvJqnAUNiE2lPzt8J8i3PtfBbb1SnewlpzEuI7rrXk8fVhdw8r16AZxbfdWyBeKUZunTTP3zqhr50yc8zBMQcdbTm2KHFdo8WWHJHrr+fY/l9yLXBGxney1G8C8Bmg0fKgHDA/U2M37Gn/LHx/lHUML6/dYL/izI7+eMvb6zd8T7idUAv3UybLbMSnSxfzfYrxKlVbDKXv1L0OEnaL31P+ZHGzXrJNVOmj8BHO1t
 IaW3EqK4
 hI9ypXFJCrbbAuxsfZtEo3605nRV3qOkpX+xzHg78dImsryC7INi/Bt5TzuCjsm4zckvl6l9NYz4vnLn0mCtmGV2E0mW/mO6Jbw8dN/LvW56nmYJlAwYGfJv+F/HADSkarTGiBqk9ghgHN//JbGbMZ4OWPtO5ehjypMRdCzsD9kVpMOFGab0/cL7Y5HpaSPpwAGt1lVMfP+vmMI08LgoQXZk198nECy8Yqsqjj6E45hXOMoHXyLyYcB4+0CF0t5c4Wn6A6V8p7VF0Y3uO28hTH6eEiqnRYAB1y4hB5OWpoH5lbC+hVtSCv/bIpH3COxd8uPWvPC8A+DZKIdWoD3Tkbth7KxWUGZ/uh4eRepItqW6rhr6FbjKG5W8x5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6 Apr 2026, at 11:24, Johannes Weiner wrote:

> On Fri, Apr 03, 2026 at 10:27:36PM -0400, Zi Yan wrote:
>> On 3 Apr 2026, at 15:40, Johannes Weiner wrote:
>>> this is an RFC for making the page allocator scale better with higher
>>> thread counts and larger memory quantities.
>>>
>>> In Meta production, we're seeing increasing zone->lock contention that
>>> was traced back to a few different paths. A prominent one is the
>>> userspace allocator, jemalloc. Allocations happen from page faults on
>>> all CPUs running the workload. Frees are cached for reuse, but the
>>> caches are periodically purged back to the kernel from a handful of
>>> purger threads. This breaks affinity between allocations and frees:
>>> Both sides use their own PCPs - one side depletes them, the other one
>>> overfills them. Both sides routinely hit the zone->locked slowpath.
>>>
>>> My understanding is that tcmalloc has a similar architecture.
>>>
>>> Another contributor to contention is process exits, where large
>>> numbers of pages are freed at once. The current PCP can only reduce
>>> lock time when pages are reused. Reuse is unlikely because it's an
>>> avalanche of free pages on a CPU busy walking page tables. Every time
>>> the PCP overflows, the drain acquires the zone->lock and frees pages
>>> one by one, trying to merge buddies together.
>>
>> IIUC, zone->lock held time is mostly spent on free page merging.
>> Have you tried to let PCP do the free page merging before holding
>> zone->lock and returning free pages to buddy? That is a much smaller
>> change than what you proposed. This method might not work if
>> physically contiguous free pages are allocated by separate CPUs,
>> so that PCP merging cannot be done. But this might be rare?
>
> On my 32G system, pcp->high_min for zone Normal is 988. That's one
> block and a half. The rmqueue_smallest policy means the next CPU will
> prefer the remainder of that partial block. So if there is
> concurrency, every other block is shared. Not exactly uncommon. The
> effect lessens the larger the machine is, of course.
>
> But let's assume it's not an issue. How do you know you can safely
> merge with a buddy pfn? You need to establish that it's on that same
> PCP's list. Short of *scanning* the list, it seems something like
> PagePCPBuddy() and page->pcp_cpu is inevitably needed. But of course a
> per-page cpu field is tough to come by.
>
> So the block ownership is more natural, and then you might as well use
> that for affinity routing to increase the odds of merges.
>
> IOW, I'm having a hard time seeing what could be taken away and still
> have it work.

You are right. I was assuming that pages that can be merged are freed
via the same CPU. That rarely happens.

>
>>> The idea proposed here is this: instead of single pages, make the PCP
>>> grab entire pageblocks, split them outside the zone->lock. That CPU
>>> then takes ownership of the block, and all frees route back to that
>>> PCP instead of the freeing CPU's local one.
>>
>> This is basically distributed buddy allocators, right? Instead of
>> relying on a single zone->lock, PCP locks are used. The worst case
>> it can face is that physically contiguous free pages are allocated
>> across all CPUs, so that all CPUs are competing a single PCP lock.
>
> The worst case is one CPU allocating for everybody else in the system,
> so that all freers route to that PCP.
>
> I've played with microbenchmarks to provoke this, but it looks mostly
> neutral over baseline, at least at the scale of this machine.
>
> In this scenario, baseline will have the affinity mismatch problem:
> the allocating CPU routinely hits zone->lock to refill, and the
> freeing CPUs routinely hit zone->lock to drain and merge.
>
> In the new scheme, they would hit the pcp->lock instead of the
> zone->lock. So not necessarily an improvement in lock breaking. BUT
> because freers refill the allocator's cache, merging is deferred;
> that's a net reduction of work performed under the contended lock.

This makes sense to me.

>
>> It seems that you have not hit this. So I wonder if what I proposed
>> above might work as a simpler approach. Let me know if I miss anything.
>>
>> I wonder how this distributed buddy allocators would work if anyone
>> wants to allocate >pageblock free pages, like alloc_contig_range().
>> Multiple PCP locks need to be taken one by one. Maybe it is better
>> than taking and dropping zone->lock repeatedly. Have you benchmarked
>> alloc_contig_range(), like hugetlb allocation?
>
> I didn't change that aspect.
>
> The PCPs are still the same size, and PCP pages are still skipped by
> the isolation code.
>
> IOW it's not a purely distributed buddy allocator. It's still just a
> per-cpu cache of limited size. The only thing I'm doing is provide a
> mechanism for splitting and pre-merging at the cache level, and
> setting up affinity/routing rules to increase the chances of
> success. But the impact on alloc_contig should be the same.

Got it. Thanks for the explanation.

>
>>> This has several benefits:
>>>
>>> 1. It's right away coarser/fewer allocations transactions under the
>>>    zone->lock.
>>>
>>> 1a. Even if no full free blocks are available (memory pressure or
>>>     small zone), with splitting available at the PCP level means the
>>>     PCP can still grab chunks larger than the requested order from the
>>>     zone->lock freelists, and dole them out on its own time.
>>>
>>> 2. The pages free back to where the allocations happen, increasing the
>>>    odds of reuse and reducing the chances of zone->lock slowpaths.
>>>
>>> 3. The page buddies come back into one place, allowing upfront merging
>>>    under the local pcp->lock. This makes coarser/fewer freeing
>>>    transactions under the zone->lock.
>>
>> I wonder if we could go more radical by moving buddy allocator out of
>> zone->lock completely to PCP lock. If one PCP runs out of free pages,
>> it can steal another PCP's whole pageblock. I probably should do some
>> literature investigation on this. Some research must have been done
>> on this.
>
> This is an interesting idea. Make the zone buddy a pure block economy
> and remove all buddy code from it. Slowpath allocs and frees would
> always be in whole blocks.
>
> You'd have to come up with a natural stealing order. If one CPU needs
> something it doesn't have, which CPUs, and which order, do you look at
> for stealing.

One naive idea is to make zone buddy keep track of PCP free lists
for stealing.

>
> I think you'd still have to route back frees to the nominal owner of
> the block, or stealing could scatter pages all over the place and we'd
> never be able to merge them back up.

Basically, we want to keep free pages to be merged as much as possible.
Something like free page compaction across all PCPs.

>
> I think you'd also need to pull accounting (NR_FREE_PAGES) to the
> per-cpu level, and inform compaction/isolation to deal with these
> pages, since the majority default is now distributed.
>
> But the scenario where one CPU needs what another one has is an
> interesting one. I didn't invent anything new for this for now, but
> rather rely on how we have been handling this through the zone
> freelists. But I do think it's a little silly: right now, if a CPU
> needs something another CPU might have, we ask EVERY CPU in the system
> to drain their cache into the shared pool - simultaneously - running
> the full buddy merge algorithm on everything that comes in. The CPU
> grabs a small handful of these pages, most likely having to split
> again. All other CPUs are now cache cold on the next request.

Yes, a better way might be that when a CPU wants something, it should be
able to ask the other CPUs to drain the minimal amount of free pages.
But I do not have a good idea on how to do that yet.

It sounds to me that your current approach is a good first step towards
distributed buddy allocator. I will check the code and think about it
more and ask questions later.

Thank you for the explanation.

Best Regards,
Yan, Zi

