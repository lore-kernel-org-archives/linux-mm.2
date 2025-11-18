Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E950CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:46:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D9F16B000C; Tue, 18 Nov 2025 01:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FDE8E000A; Tue, 18 Nov 2025 01:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B8B8E0005; Tue, 18 Nov 2025 01:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7C26B000C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:46:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B413D12E9F8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:46:19 +0000 (UTC)
X-FDA: 84122793678.29.E8949EE
Received: from OSPPR02CU001.outbound.protection.outlook.com (mail-norwayeastazon11023087.outbound.protection.outlook.com [40.107.159.87])
	by imf29.hostedemail.com (Postfix) with ESMTP id E4558120007
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:46:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=kagRegjO;
	spf=pass (imf29.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.87 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763448377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kUhtmoYvMpmeQaNMKSaB/RZBvFwl2SXShJwcX8oH71I=;
	b=uloc2FM3D95DzzeoTU4X8t3e5n+sWtMJC2CYqqmXrveWMRCuZ1ZcseSSMCTYZ6s8PfMNJ+
	N2em+xIcVjAhsKvDfHiQublIkrKiIQTcHSWL3Jum4N295GRMRSYp07zSnmzvJ9+QyYjK36
	eHinB1Z+/V9+tX9wuh23IW3EAZxVWkg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=selector2 header.b=kagRegjO;
	spf=pass (imf29.hostedemail.com: domain of ptikhomirov@virtuozzo.com designates 40.107.159.87 as permitted sender) smtp.mailfrom=ptikhomirov@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763448377; a=rsa-sha256;
	cv=pass;
	b=mj73fDLZlAbIdgmheZuuI9UpG2YHO44NLJ2Yvwud2AdU/6GZmidTm98jmNjKYjxhDD3d1v
	RCjJVEE0/rF+SdQAwtkn13ALSwwDv8+J3tEdRCTQ4FtP3j5C1SXw1qf0uWy+TrMLpYXB9p
	wvavRW0T5s7dd67v8oD7vBHhNMmn0hk=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ALpZi8w0Yo9+A0WKjiMI6er29x7LiIh7jpATUSrVxASBTepBJi2h1qtGjCiX3Gy65CH1nJzG0kIt2nZk9TyveGF7bT41uqr9ZboBDtDE16BSqiWbiJhZVmkv7VtMDrfA0O5Iaw0uae1PUKJDInm698W32bnrvEAZ0+lI+uPlLnGpqsSHAVGdxonEQialOB37OaYNpOylJMLg+0jLgwOvKy2GqE1DmMcOme1MexG30tuLd53XOEGCfhGZYu5X6O1OVablmALfIca4FUtF/reRvVdVZof81+aKdFLghL/Kp04ZiJua7G2YUMUAp4+kdd3vy0/rw6wZCeTGy2jbD9z/lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kUhtmoYvMpmeQaNMKSaB/RZBvFwl2SXShJwcX8oH71I=;
 b=Ozc4FF90daB9op3YJyfc7Lq4/BxhgftKWHm1lAx4chUuGdUN8tobHM1f50uRAD4oi3FYQMxsYb8p2hw0HZ0iUf7vn6bu8JKtfuNlhu3u4NLOm+ihJVc2BLG18RaJ0GzIXp3cnbH/jU8utLVG3NlCmWANR74Lyuh/IRIYy7HN4Pl6CSBfR26oV7/X8UUTkOwaYdrUP9uDZPq8l1CQo2+Q5i2ewIv7+2Ow0BqKSZBL3HF7t92TOM9wC1jf6ml7i0pthVzCw6FICMvHPFjw3xIm5v5oeOxofYuF8oCAY1Ka/oYMnq8Odg9n1wziM30VDAOg1hHbMGi/IVczZfRlwKrTEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kUhtmoYvMpmeQaNMKSaB/RZBvFwl2SXShJwcX8oH71I=;
 b=kagRegjOSqbU34t3jWjRWgkSY9nW++6BJJWKEh1ULXJjS08vqNLJ4W0R2uFM7Cu7Ia+eO3PGYLVE8zYagkelnT9OONuXT/s82z8ncsJRfjEtTIasniB7pjht63ZqF66+BLPwEOR68XzrkOKSPVRg5dFQesg5q8pHfoDNzvFqAdr0teZNjqZJVbN+JD5pnlnZyXsE7q/s5aFrUAuiK5xo/6jmt78zvK6sUfiX2uXe6aTKqEvGzMBa3xK1p1LDCHRl/8HHvmBER82MwQ/vqUNtiN119esw5d9Geid9nReFoPAxZApfcZnNyNR9oX0O3kRO/okpyAwclnoUuq3J/L+uUw==
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com (2603:10a6:10:471::13)
 by AS8PR08MB8417.eurprd08.prod.outlook.com (2603:10a6:20b:569::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.21; Tue, 18 Nov
 2025 06:46:12 +0000
Received: from DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::7261:fca8:8c2e:29ce]) by DU0PR08MB9003.eurprd08.prod.outlook.com
 ([fe80::7261:fca8:8c2e:29ce%6]) with mapi id 15.20.9320.021; Tue, 18 Nov 2025
 06:46:12 +0000
From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
To: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Alexey Gladkov <legion@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: [PATCH] unshare: Fix nsproxy leak on set_cred_ucounts() error path
Date: Tue, 18 Nov 2025 14:45:50 +0800
Message-ID: <20251118064552.936962-1-ptikhomirov@virtuozzo.com>
X-Mailer: git-send-email 2.51.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: KU2P306CA0011.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:14::12) To DU0PR08MB9003.eurprd08.prod.outlook.com
 (2603:10a6:10:471::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DU0PR08MB9003:EE_|AS8PR08MB8417:EE_
X-MS-Office365-Filtering-Correlation-Id: 82278f8a-bde3-4291-ceed-08de266e297b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|52116014|10070799003|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?eD5nOcMIXwh2iOJqCbwey6y4mUMzkWy3FPof63VLM4zuFL4X0Vnbj24moxUw?=
 =?us-ascii?Q?qhA3lntIzlrMQTOTK04hWB0iTYNwFci3b+Degl4bWUXgMDqZ77JVAe4kj/xv?=
 =?us-ascii?Q?7ugy0Epiyrxl+YPADEH593m+pipPg9jQQEt3rH+umCJ8rKyYfCwjRQoThtbO?=
 =?us-ascii?Q?0uOw0b35kNfSXBOohRiMVsC6s1Y7tZX4tckB6aUnf8lFKorO1HCROwiQD/u1?=
 =?us-ascii?Q?X4iOtEriwHfAsTJ2CHqn5ljahyw4HEypAsZrYYxP23d1PibgBQogwT0Gb9iQ?=
 =?us-ascii?Q?w2TO192mAT5ILnsN3kGzCpODOyW6WjNklNmgmyiSDYHkEPwbMvbUoueuhkjS?=
 =?us-ascii?Q?nsSoJvHBYtRuNw/7aXgOJ9hwil6AdZfqE64mjdKR0lo8HXStzb+Q1691f3Na?=
 =?us-ascii?Q?kkSSvlvBiKIbyaFNCuWR+9b12xYx5kwQf0AEJ1emaJgy47qdLdT13+Iylm7L?=
 =?us-ascii?Q?Y/j983r5pARjUOJmLDA9uOq0lF3s5aM4bDLeOEll5sHGtPKR7ZkaNLBu3vFl?=
 =?us-ascii?Q?5yRUeVY3OfHKuAqzO+OdLzD+cR9z4vNDkAXAzaOeLO95NHwie8Ify7axN/c5?=
 =?us-ascii?Q?xIftXCln59ypQfPEEedkc/oQLLd4HklymLopIYFZ1BufxzPj2RVoNiUPpMo6?=
 =?us-ascii?Q?vfD3bvPpULZT91d/6l0wDWbLozhQ4c4HgWxcu9HrNINdMhSfX056ZH34G8Q7?=
 =?us-ascii?Q?JMayrJLN9iUCAZ1r/D7rof7pjxF9o7buhD/Yuri7G6VjWao0xHUJQA5pJFr6?=
 =?us-ascii?Q?eGnm238nvbFOJXngWv8eVSoMLkEkhfmnukJ3x4GOEc/SKhBzuodx5MFVi39e?=
 =?us-ascii?Q?8FtiokT/CWUNVAn9G6KQTx8OrTPMePNTtl9lBabNxhi5vYVY/b4wFpM37Hty?=
 =?us-ascii?Q?wSO9LR7eI0ehzlR8Z/isHh4aVlCArltucAKeiwcXpJ1l43EbnXj6yTWugNOD?=
 =?us-ascii?Q?r/ZJQM0vllUHI4nyeYbqqL1TIlrCRb2kg0P/uxmeKmsYn2fSYzUOKcqw9yxS?=
 =?us-ascii?Q?CfrNGaCvREQCG5nL4qbDLvgToC7joOd/Kg1YXFG4INlsVRm3sgH56WO9AI4F?=
 =?us-ascii?Q?zu04jmgIWKbWOYvQvQqajm8hHH1akUvWERLmLwwt8B49/5Co3KNIqFaAFIGp?=
 =?us-ascii?Q?LwoDJIYr13BYbJui9yVY3bTZchmJB7Z3aY8mcPHyvZqpyBYD3DrZVvsFJTec?=
 =?us-ascii?Q?1vUxTA3WcskdBsO1zyAtR7WNmvNb4wjwmXZUP3M891C3BWLOnFR9LR+lQmYw?=
 =?us-ascii?Q?bfLCsGV3kaI+cax9AfAoE7l3dWquh0Hgx5MOCa1GnoDhpSn8VslgJZYt5kmc?=
 =?us-ascii?Q?uAWhp2TgjBGHgJm+VyiDuYJAXamRrAOIP3mcJNIQ2ioWuQ81qoTA86dRJJlD?=
 =?us-ascii?Q?S0jherFrqJlpnrcArEvoEF4HTyFZRyhcEYySHRjDjAfkkqs2chqIf/SMmy9S?=
 =?us-ascii?Q?vR4mETBWpOt8YFO+axG1JcGmooNo3LNQ?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU0PR08MB9003.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(52116014)(10070799003)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UXmuAnjRNx4tslrxAfMNmT238Xo9s3BD+WjthLlesbgKLb5S0iZkICYopAk4?=
 =?us-ascii?Q?tSbsJBzpinzyktHJbqz2RXFx3f9mZeQzcgLjmvpMGSSIh0JRLZ1k1rJQL+xh?=
 =?us-ascii?Q?SHtg2bUXp4NnR05Pp74lwEvwrJZw1A1jLYSajq/krv43rBzT1SvYIhFibu7M?=
 =?us-ascii?Q?cTCJKP/MAZeDSU28dkiX2WM3VnkhXM/AJAV+yjBI1a7xgcG6lKEheEEmbMwg?=
 =?us-ascii?Q?T77XuSJQ2FPOs4vEbUb0LiAInSMiUfn+BqVxiNZVFhPlp6RScr6QDD+0PA+H?=
 =?us-ascii?Q?MLe+oShkLtipve8lTnwG3jQB+vATtKmfc9RU3/62hIPaBk/ZDckrT9MTG7Bw?=
 =?us-ascii?Q?iNeT7Ge+9M/dWRQfGHZVGi2ok36tSfDXqVO486XebdXui0xFPxH5hrCr8S/j?=
 =?us-ascii?Q?Dz2DsNtkzA/5JXcV4pEZlZCXub0jOndaaHCVwSpwd3UXQYjnWrvH1wnPAfN4?=
 =?us-ascii?Q?95rBJFC8Yx8O7+EIr/bWBjX/lAOQ30P9hndTEQacynNESB78TijjTWM+0vO4?=
 =?us-ascii?Q?4koTZbwYCkrsy5qHLtL+MvnuSeR6JWMtCX4uXHSQ2V8MhUpwzOhw04qZKBJh?=
 =?us-ascii?Q?awvLPqVdGpqtwIvNyKIsnK5SFu6AK85x56jhdrWoLQ4nOCoCGMGIDFZBfycx?=
 =?us-ascii?Q?PfiN6hHB+eMkZPe/1aGwt8F8jPgxDcNp5EmmD3PodiVvkWJvlrv1g78DuoEe?=
 =?us-ascii?Q?3UiCiJOZTT/mghY/6aQ0EX9cWAezApKCgiuy6yvEKNw4xQGmVefTeSc1fBA0?=
 =?us-ascii?Q?KCBt+qynBURY7Cbt3Z6OJasWkgOIBBT50VRqgAjXz8Xs/UblqCthQTpmeav6?=
 =?us-ascii?Q?96Muz76d4FjPE1XL+GplmK9mCTWRE+Ioz7HYy84/hnHsJFqmV6KaqVkB7hff?=
 =?us-ascii?Q?6KUUjFCek4A1nHIeRji5qPURElPJYu+islp+rC8wQ9+r2mshAyQP2pga4m5Z?=
 =?us-ascii?Q?A4e70KOkOjMbTKoMDc6+MvwVcZkhfr9O82/B3uLgs8Tnq3fdFQP6l4Jtelpy?=
 =?us-ascii?Q?jih2WpuTJJ1EXYNGF/Q6NgcOHJNPMlhoQxx5088vHOWBDOFwnqa6/x0SJMl0?=
 =?us-ascii?Q?R5483EUIRQvhsc9dr28y5lOAJVb9nhnNjfNO9kSLHA1WQcOc0bJX6c7Txt3l?=
 =?us-ascii?Q?mSRJKh+8HyZcHhegylGN0vfscfmRFVWenA1o4gGzdJZcGcx9cOv4U1EbOXdE?=
 =?us-ascii?Q?Gq2ARDdBLGr0h8NVHt9fAFpct8mD+YOObeu4RKelTrKVGSF/5kzt5ZXr4cT0?=
 =?us-ascii?Q?l45aHgzfKv1rAXTyAIh/JnIiwbZ1K7O7A83WVYqNowGsYavzas+xdwY20bft?=
 =?us-ascii?Q?mlqLtk2gQiLiJy9gizw9o4Z78yaUYBibiUq2Eh9JhE4xaKutj0KxnPc1N1Vn?=
 =?us-ascii?Q?83fTs4WoNdFPfY9O5cvSglGBopEifmaKa8hNKhRrxysAZkblKg0aAjJeQzn3?=
 =?us-ascii?Q?yMofV6ZLnEeEU6Tb1REgb8mnl1D4/T88CQGwOEAeDL2NZ5UlvrQX8j4A9BVd?=
 =?us-ascii?Q?0zay4O99MF23DiAyoDuisvuYwThUX8TYZoAwaUvJQfxvvoNVKUf5VUhZ+59b?=
 =?us-ascii?Q?Wi+CDL/0miMNxGsUSBh+WGIBHtu5eV80BXM2G1oIVtxu5qEpYpvFuoKEyfDK?=
 =?us-ascii?Q?tUE8PijVsTKiJeBIBg8szqAPxdaLSc7BvGWkjPZ+5BFpZgRxt+Q3JtV4cSUP?=
 =?us-ascii?Q?PPcvyQ=3D=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82278f8a-bde3-4291-ceed-08de266e297b
X-MS-Exchange-CrossTenant-AuthSource: DU0PR08MB9003.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2025 06:46:12.1151
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1hXM2P2YAuHPBDV35wv2O85TtIX4gMQXHqHb1H67FR1L+Mp1LG/ZnoCLk8XRzRmXV1X/DLs+lj19E6IXOf6ot6YhWgp6BdIIzxPQ5f4u8Pg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB8417
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4558120007
X-Stat-Signature: o837zidatzt3h81sb1rp8qyc9cu7db5q
X-Rspam-User: 
X-HE-Tag: 1763448376-669841
X-HE-Meta: U2FsdGVkX195i1S+hItGU+YevpxCWlvvqBS/iGdGNLsqSsit2GVoBWSoGeLk1eXtgSEcnYUQ0iwkpDZ7rpz9KhMKXhoBoiUC9OVkuxLSZClJl/SRbLRi1RseutVd+BbGLX+35xBk1L18polnJrKOKuBcF/0kdk6pq4uLuO12cL5T4OEsMHCCyO2NIl6HvxuQ8sshfaKqqbuHecH52S6eiD+zYyv1QS09tjSBUVa81+4t1CephgGmQJ44FnqNGBZsM9pCeM9iW3d72JFp/zI/oeUM6U5dZj1/1qKY00p70Sutdb0p2ZdZEgUJb0x7/onW/DeNkONGrVCVcUDOsPE8mUdN+0BXzfhzuNzFRuLus8pO3TLuMqUVcQpYIZ1KWpPXxBTlBeTBzkrwB4Mw1ma4A+PXIqfwjr5miejWaxTiVt6UwZ8LjHuO82V3s/i1o/YZXel92V1YJpFBZPjhaTAmZ+sR8qDxKd9OGjR4KvCglS8JgUAnc964XJMNxhK/fnWfoP+Vxt0WUK4d/dOiiw5JOdySeR+u+N/gqpMoD35j/jgiLGMiiXGtjbGzcAKmlTUwsoFlrJk6Vkv/x6QeStSHKjiJSClLQ8919YWhHDZSBJBmbxVVHEeotu3rgXiwGzc0z1Ej1kA8CYDmo4SVZF+ycTnOFI9XM3+fOMvZppX8qhpO8ey9FsME8Dzc8JQRX/jEtRGb7SUaP68+DapprT3hGNL7QGBVr/lyr3z8BfvCWLK/8YJf1h6MGKyV8tHy+K65qPyC7jhBt3xfu5O/1gdzf4e1zCJ6Wm7TLDTb6YHhkgEwuUqqbEay59dH5yxFg39FPW//Z32n+4uCKCcMYgPCAou7qaPgTbakSZP7HvPgN7RuRkMJzF1afR8OsUZhEdJerXNIYjCuZlQuXWzSni6rjPxww0v465D9EA7mwpRSAVP8TquARpI/rJ2AREedqOvLPVWHrU/XrjDmLUZH1nc
 BYhdrbpx
 YoOzgVt0pv2KTke4S2cTpWWAYwpD4Zol6UTUozB36PsI9aowAus30uBCv57UC7IVTfUKmQnHj6ewgBy1ImRiXYGAPmmEqmwjW1ZKZv7Sp2WxtVdw+oaVfawrbR9XddAIenP4hLA0CARc+E7BpAhxyApKKTZh5XFlPVHDggfD5UPt48F1w25qrO6RNKpG8ZE/iaG5205hwOnXn0lTjBV+c9vQ9cYF1hEdk3cFIWPmIrvJ7+D2xIoiHxymGOgBIyabtOCdCsjY/BLlTXpbUFKUSxHfbXhPKL0vWyrtB/17eJ/5IP8IaDIvBckSYstkk2EGrLVHFu33BHvjDq1903a66X/KuMon/MWUnAGQ+OaVtsjQf87vmZmGIiUELv37rIxzhPuSL589gW7kO8nEHx7Z/ErnXeyF/5U29zO+udzcDDR0nHTtnADHmTQyH0U2c8dC3mQbwiwNr+RoQ7eavr3gU2W5AlZbFMYXQLYwI2Ow7s16P3MF+1ZUMNLZBWcjAdg0V9v/z6mmEHrPN9iIeYLFV3ChfS1QKwI/mpzuGxBVNPfaTfOvdWAxsmvTa+FEjz1J6AkqryYK4KidiU4OriBCM7C+PBFaEBEoPmpOp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If unshare_nsproxy_namespaces() successfully creates the new_nsproxy,
but then set_cred_ucounts() fails, on its error path there is no cleanup
for new_nsproxy, so it is leaked. Let's fix that by freeing new_nsproxy
if it's not NULL on this error path.

Fixes: 905ae01c4ae2a ("Add a reference to ucounts for each cred")
Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
---
 kernel/fork.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a95..6f7332e3e0c8c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -3133,8 +3133,11 @@ int ksys_unshare(unsigned long unshare_flags)
 
 	if (new_cred) {
 		err = set_cred_ucounts(new_cred);
-		if (err)
+		if (err) {
+			if (new_nsproxy)
+				free_nsproxy(new_nsproxy);
 			goto bad_unshare_cleanup_cred;
+		}
 	}
 
 	if (new_fs || new_fd || do_sysvsem || new_cred || new_nsproxy) {
-- 
2.51.1


