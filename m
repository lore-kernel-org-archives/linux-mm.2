Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF13CDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:00:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B3D16B00A4; Thu, 25 Jun 2026 07:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08BF26B00A5; Thu, 25 Jun 2026 07:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD396B00A7; Thu, 25 Jun 2026 07:00:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B4AC16B00A4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:00:28 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0842C2C4E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:00:27 +0000 (UTC)
X-FDA: 84918141294.19.DE84DC1
Received: from SY5PR01CU010.outbound.protection.outlook.com (mail-australiaeastazolkn19012066.outbound.protection.outlook.com [52.103.72.66])
	by imf30.hostedemail.com (Postfix) with ESMTP id A2CB580009
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:00:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=nex6zWBo;
	spf=pass (imf30.hostedemail.com: domain of jytscientist@hotmail.com designates 52.103.72.66 as permitted sender) smtp.mailfrom=jytscientist@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782385225;
	b=kgncAA6ztIGOPY0TsNeLpcE8r2YllM8zgk0Nm0jQJIPYSynPR200ZJCjgTnK+qcfj9ZANP
	xWxZKNgr+ZYQgRApZ+WK86TaF2GBUGK6Up/e0iZS86i9c53w6sKuFmYUbWU9bHxS5Uc/Ap
	xpWuFR9uSUeHCoSCDM/cEN4bO2mQARs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782385225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVTmeTxHiegFhlV/zbgQO+KuD+NdJGCyEKzeWEW1y7o=;
	b=lkgMVzt+nhHu6jliyWM+VfuzrefOxu2V9lqmdm3UYyErU4WQoS0hyKN0b3q5KRmL3+aqWf
	IFNk0EGeoWKrDuEQwoofM2gX0sQ1ofeSNOLwCtKLUqElr5iCUoNNMgHxHnU65jJI2QTdoN
	1OMl23JmaIkIWHzbfMunNavh6nBPzDU=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=hotmail.com header.s=selector1 header.b=nex6zWBo;
	spf=pass (imf30.hostedemail.com: domain of jytscientist@hotmail.com designates 52.103.72.66 as permitted sender) smtp.mailfrom=jytscientist@hotmail.com;
	dmarc=pass (policy=none) header.from=hotmail.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czJG21nxbuEqRDjMKpwvaz2Pw3olRrpv0g5JQzCZ+kgYROMIRIxkWgyZH+g+epIdANVVpx02mTwpkBeAweqMXQHEz3Y4N6DfUkc/uKYyFdroD+g/BdyRItIC013xoPyW69o0u7obuvXNOtchl4GoCKmJ4YUyFoWwa3+I26wWicvf7bPis1AFsdDQqOaW7wGGqq9Hia9KGTD7HDVV/2newX77ccGNFn81sIudcHHYxVgXLJoAyOZxnXGeuNuBefGUMFXkbgg81CK1CnUyQg8uYx1WPL3GFKuAsOmtOKYqTPK5NoMZLeJw6JRHVsYs+eBVdY1Xwm2JifMs9jIgwMSQZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sVTmeTxHiegFhlV/zbgQO+KuD+NdJGCyEKzeWEW1y7o=;
 b=Vc+wPtRWWD/IgvwRbJrkavSgiz2LnM2PB6NBatnyhfdIM4+sTU+jy2H8vEWVMrzblOb31LOKHMGCM7Wjree22GMdJVIDBTbHlSj5lXzz/Y53Jr8alMxBWRPvn2u6QnTp3vku/TQwCJlqnYpr7u0DorE2Mj7TqrOD1SMo8jUwwMJQzqVC8k5BnQwz13CRDEUqn+CuP5y3ZbS7pwLyC1udDkhFcbZFdVLXDEfQXzHQrgGszUjRPpcUQHUXrsyVgVSlM0pRZmXp9AcOjwzrOx7AiLAiJb7cFrvJVZbz4UMXzfqzgpDcprCN6dbdBQhI9gLpSboJowLshXZLYBF81pdrYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sVTmeTxHiegFhlV/zbgQO+KuD+NdJGCyEKzeWEW1y7o=;
 b=nex6zWBoKqn2RXar9PSpHiQxKReOpTFAFd9dVUrzsydOKNMiQ+z0z0MtfdoCWpV3PfoAti6/KLvyAhPNqNchAo87uQl3Kg9gmG9Bn6qZGwNQn82u/hTUh9KRbC/y9ufZtCACiWZbQlE7IgbDu8CniAMxke9EPchAyYc7eELNSljaeA7A58VnpUv7BGw0H/OraXxBd4733AeRPTBni0N39I3026Urkm9Cbx7JCrFp+sy/iAls8dbl+rpo1ozdNfdAP3MU0Qwo2gbhAWR7Nm2gtPBs4VALwyOs7DzGNbZQRsUIT6aeNhRZ0pKaJyouuQ6naqHKlndaD6r1dzMlupExaw==
Received: from SY1PR01MB10596.ausprd01.prod.outlook.com (2603:10c6:10:31a::15)
 by ME5PR01MB10091.ausprd01.prod.outlook.com (2603:10c6:220:24c::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.159.17; Thu, 25 Jun
 2026 11:00:15 +0000
Received: from SY1PR01MB10596.ausprd01.prod.outlook.com
 ([fe80::7ab4:1f80:a8a0:7d3f]) by SY1PR01MB10596.ausprd01.prod.outlook.com
 ([fe80::7ab4:1f80:a8a0:7d3f%6]) with mapi id 15.21.0159.012; Thu, 25 Jun 2026
 11:00:15 +0000
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
Subject: [PATCH 1/3] mm/mmu_notifier: let interval notifiers block THP
Date: Thu, 25 Jun 2026 18:59:51 +0800
Message-ID:
 <SY1PR01MB1059616E59F213B6FB4F4E3C5C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TP0P295CA0028.TWNP295.PROD.OUTLOOK.COM (2603:1096:910:5::8)
 To SY1PR01MB10596.ausprd01.prod.outlook.com (2603:10c6:10:31a::15)
X-Microsoft-Original-Message-ID:
 <20260625105953.70647-2-jytscientist@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SY1PR01MB10596:EE_|ME5PR01MB10091:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cfdcb8f-e8e5-4d6f-997f-08ded2a8efd1
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|8060799015|51005399006|23021999003|12121999013|24021099003|19110799012|41001999006|25010399006|5072599009|15080799012|40105399003|12091999003|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rtr/33E4Tlga1SP3euEJEbI/qQsQTdSFHxQrnl6C9zBYDSzd+3KZeeKDMfNO?=
 =?us-ascii?Q?x8xw1LIqiQ31kZ2kVqyDfkgKFd1pyiEQizT20WcOObGGNfdaP/2RAOtUw6xM?=
 =?us-ascii?Q?70DwTDMmwsOeWbgjJ/oGGvUwWwXuUHWBYT6rLlPLMtEscD1vR+Nx7P3LXxZQ?=
 =?us-ascii?Q?mMUUCKe9PyDAS61+ksKS2QMB65iykTzJCWd+pLJN6JKTFj0uJHoXD0Hp2F9i?=
 =?us-ascii?Q?9l+G10qzNptsP/HGtVKtr05DrFYdHowoieeBV5YxVxlmyGNQ8FiJ5gLV+Q+e?=
 =?us-ascii?Q?dO3Byc53674lgu7+gr9MdoGYLiLgcd4nt1y75yvE4Nue5ac6zdV9eQVlI4vg?=
 =?us-ascii?Q?pF7HXYZN3hg87zwoG40dcWySAYmPbbCdPQhdpUzQW1mcihA1kN1LLwHYWATC?=
 =?us-ascii?Q?KV8Tzvh63Ln7RLzkmxkEiTmmYXuPAGEHt6/YXLRBo/Fm2VbnpkohntEWhg4k?=
 =?us-ascii?Q?F2aGzqC3FWvB4w3BtIVSZAS8agDWiY1Zjlk+s4sPmzdBNJ5Oo2AxgJkaZTZO?=
 =?us-ascii?Q?WFvdOwcnTdvpnWzp8b2kxPfa5jFYr4hAS+dwusqiP82TulUYnUw7rHJutt0n?=
 =?us-ascii?Q?064RCvsIYARz3Wd7Sjk3gUer78Ua9rRgrxwClqp2P5i7qf9ns3+HIlFZQNNG?=
 =?us-ascii?Q?Iky6PRrzpypv3NV3/bZWnq11rHOpDiVun76nz6aAb6/jpa90zC0bnpg7VAao?=
 =?us-ascii?Q?3BYzGtXGPdrgJ3lcNh745UeqQMgZmM8aejGVlC9P0BIkYbpyAo8LMt65H+QD?=
 =?us-ascii?Q?V83mT2ve8oZOLE2/sLaCqftGu+Ae9GcU9ak8oAuuORS1MortyCEHnL267Fl/?=
 =?us-ascii?Q?PZE6tS4c+A889sNx1nz0Q8HGpYJbn3JAbosy+eBV3qa6E5H5DNJngenllEG3?=
 =?us-ascii?Q?lPf4umKLWoIsshyqk/Ney79NIjPICdTSlZbEVqWQOHuY6HtHeIZCOhG9Nzk8?=
 =?us-ascii?Q?z2SugfYXOhExMQji8lNBzPiAtojk0cb4t5oZJfWantJpOxRudk+AFo6gKWJF?=
 =?us-ascii?Q?fZWfgTxlhaXxWspeVXXruHAtAqsBH+9XkhiidLFaLX0RBcC00QPP+40qPzQ/?=
 =?us-ascii?Q?l8GXmInL?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?PQ6cpxrd9p10o1ZdCDnb4lptrPPllEjmGj6Ppa7Nq81qIos3kdEmXSE2Hgn/?=
 =?us-ascii?Q?gOFObMW2fTXIFEq8VKg7GoG/2ObUBlFVar2XjZ6c2Fpi+JMtqGV6vop96P8v?=
 =?us-ascii?Q?kBwJaqlKdsVmf5UQ6f/j6rKeFNuVVbZyQCApPWCVK5KdZ7SkQIgiwUmDS5z7?=
 =?us-ascii?Q?Kom0owwiomcuTo9ByN0WRp3QGro5uQW5wXQOsjgyqCDzeD1DJovRGrVYBd3N?=
 =?us-ascii?Q?KdiQ0H5Ts/hQBjIl8FOr5AD7bnxEjIhuwgqsf2mfgV90G6GKCUrysKc46y7k?=
 =?us-ascii?Q?4qI9J+y3mbb+TAOgrxJDyGGsoyMTMnrPS99KuYm5wpnNmecJCVQjWYXT/7NM?=
 =?us-ascii?Q?PXjp/tk4qCDGNEIvO1pgJmQ32xyotuKwC6mf4ZsjQm+NdN0T+mtHCSj7mHTM?=
 =?us-ascii?Q?sIPAbA3CmkQnympgF8NipA+pxVk2X01kFSZhkttpER9rTlCCZv3qQR3c3OEL?=
 =?us-ascii?Q?TC8Z5tUQyyKlRWsfNuJZPJ7nCkmle68cQJo4t0dET5+nNdjhBwKvdz8g0QYS?=
 =?us-ascii?Q?tDC2x1rUQyWlTqnjD6v8uEDU2Xb1b5dJC2b0BcQPJV7mck14r2adlBk6WMji?=
 =?us-ascii?Q?pn/KkAYNQ9cC6EcRuNPgFIUWRb0jXD83UqMziIWJClNpBgmgzCHiwCfxKN3S?=
 =?us-ascii?Q?doxtbBG9d0xfyOeocCFpcrYQblc3LVHXFaDNtFO3A5H3btgJ+F9NB+iNj2A8?=
 =?us-ascii?Q?Yknr1izbnrKFo5xmL/N7n02kJb8ePguo09j6UUHuHtbrski1gaoNlW797d7p?=
 =?us-ascii?Q?cHv0fIweUMpf30DpxPo47xqSfnA6Zr7Mh/p4Md+LRGtcuzGWh5OIu6rWnrZs?=
 =?us-ascii?Q?hao8h8Db6fBSzjqfiSxKZ56mcXJr8/04yT5dBDMxmjdWWOpvG3D/nWia0lc6?=
 =?us-ascii?Q?3hSkruiXVEY6xwVnR/+1iiEhz5K9IkR7GnPm/EMK1c+z8aaNGIYHBfa+oSHz?=
 =?us-ascii?Q?m3dynDfs4ZrNtHAwA7IlDcJeOxBhPzp262urPL4NhZBikYJyDdK+5wZ6zYCT?=
 =?us-ascii?Q?FPkdRE2V95JHa6aHF+aMnocqNBYSXnG54sgQ99zTjsSj1pcE87MsoQMiL/hX?=
 =?us-ascii?Q?R6Kt5A0dkSRwQacq1yWsz+1+z81PTtmf4iJ5isxshvop320BFcYctPi9PMSg?=
 =?us-ascii?Q?F8r3/0LOEYEaW/Mj0VnHS2IU2gvhZilxdoit8UtHnwDGLslurpYI0bvbJA3E?=
 =?us-ascii?Q?EUWuQBAmVX7n2mDW9A6m9nWFvWY4WmyQc1cMxQSZ4lP7A9VRoeWutFTDB3Cg?=
 =?us-ascii?Q?R9tHSzdmxdaS9eYVSDP5b3rwIjsV1Kbmjlr9TZhbBChRILboa/2fGqIkn6fp?=
 =?us-ascii?Q?mbhaZ+l9VnvXAxL4A5q08YOhza7E4hcZhQC2ryf9bA5LBgw7oJaECC1Bp6Vu?=
 =?us-ascii?Q?2UcWu9ZNu9ELQGGWLeNPQrtAcyirEnpeqRfaujbWGIn93od7B0n5sZ6H0gY6?=
 =?us-ascii?Q?vmeMMWJEMvm25dmouzdPQnpeVAz/NHA6gx28CK1BTF/gxqiFGMzuiw=3D=3D?=
X-OriginatorOrg: sct-15-20-9412-4-msonline-outlook-feddd.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cfdcb8f-e8e5-4d6f-997f-08ded2a8efd1
X-MS-Exchange-CrossTenant-AuthSource: SY1PR01MB10596.ausprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2026 11:00:15.4497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME5PR01MB10091
X-Rspam-User: 
X-Stat-Signature: e5wc9mut3r4c1r9tmbpkhe76sgcracwm
X-Rspamd-Queue-Id: A2CB580009
X-Rspamd-Server: rspam06
X-HE-Tag: 1782385224-532338
X-HE-Meta: U2FsdGVkX19aEXmaAf4qq/l7RLjeRJBJwWMcce/+CiZjwhbUxPyflbqJ9NLJHGtJ3+hi5zyExkajAByHm9SeSyNIW6IQzO/FOi76+o/UJjkyxp29UfIQigIXpTNrGdxi0te86u8R5u7R4pOVcpCHVyzHAr/CVhNQnz8zoXxfQSvsaewByZ3+uy1uKmRncLWRGot1OKkZpn3IDMq3IclOQ+qkqoi9bm3vtOsSDMHuAb2kLH+dPUzwk6kjxTYpNX6JbI6DtSTfqahaWcwifdw2brm+SgYfGdFXKR+rkxQmNyg1064la9fNH8rDLmcgv8N7nKvJlx1M+IqJ9iq0QPa1ip7b+zQ2zTdXvBkshGOz7nSNVdvk8Mp1B+NXxrEimuON/0RiZyS0QOmHArSMDnKbwiRzLFF0ErCa0GGmt8Zjgu4d9Tizx86FO1XXXwo/lbQ0wTZyysDzfN61XtkD0HtrXEumtPXksOHsrnlA+8sHFOImkNUqY8hoCjxMr6qpaR3HTyUDKf3+VRoWdWRblm/0wtCVFdOE7jhomNX+HIfgy+kMX+ehqCEgxeXHNhbGeixDFaQcUMkpqNVrBrIC7BFBTSIzjbU2pAYtTlrp/Z5rab9quF9GoG+tz/7EXyLLS6v6WfoMgxIwGNbP4FDgcjuDBw9zWFsm5MdTIpeCAny5msRA/YcvWdC7pW3qHktdt4pyVa2ET5PEwG4HSKR6O2aNa4GmU5c34dYqKM8Pzf1aspiQ+epsWYuqbD5e+0MKNkzxJbBt3B/A8fejYHBStMhT6SzQbvzKMjkhd0B8+Dp3R3mTxHk75rt+kneDjqG5QU8f+53pfx99YX+Vkh8npG0Q66zV3TxW/QRn2VXzRNFShC11w6l1bIf/82RB6Ff11OA6TWJ7beY01uo/kiQ4sz6ZBgXPBD0iBKyOSl/9uw4U4+UKyYToTzoJtOdUtyzcvnpm8HaU8eAjbuxoboJNaEK
 JNvuPhjb
 Bz8WBybVz5xU1CUZ5efQ8pPlfY7XHHE/xTccd81mTkLu6sslFD2ezFHraGCBAsF3k3fKxqDPnIrliNOP9U/pU7ceEOZpmRakOSdd/buXtDRkoLe9mrxK8M7f129jKKrdGW3gfl/rZY8Vt2MuElFfr83kDNS02UaqflFSULFeW6vXp+33i9ZNGYacEfJIJJ5WUgCBaBY+eX4P3YKDorLt18TE7Q1/NI1neZDS55MJ+dCRyngXEPGbqJL8tXvmhYvb2fdZqGP2SoPGHELplQLhPJwfRHzKz0wLfyaNMblNgZRuV711ds6GSTFSVzUtja3QeDa6bHqAbYnKerKcx/skTDgLe4HNmO5GT34UWfKUgzaBHiegVUR0PPV9YXAQMNM7I2ijy7cpzqkHnX7HFgj9R7oPXUkYMef+i+KuI6bq0XLF+qGQiq48ua2pRkUcDzxDj9ZPUC0wKS2cMwT4rgfhDNoK1d6c+U4FTJhwaDJ4RUyyaRFF++7JlvsDhJNKyu2LS5nJ/BJg7NePEuEdYghmsOGQ86jMpem6ClV7tJQqfL85zwvB/3seP8ji4VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some secondary MMUs cannot safely tolerate a user VMA becoming backed
by transparent huge pages after the range has been registered with an
interval notifier. Drivers can observe the page-table layout change
through invalidations, but devices without replayable faults, or ranges
that must stay mapped, cannot necessarily re-establish coherent device
mappings before later device access.

Add MMU_INTERVAL_NOTIFIER_BLOCK_THP so a driver can declare this
property when registering an interval notifier. The MM core then marks
the covered VMA range VM_NOHUGEPAGE and clears VM_HUGEPAGE while
holding mmap_lock for write. A later MADV_HUGEPAGE on the same active
range is treated as an ignored hint, leaving the MM-owned nohuge
policy intact. MADV_COLLAPSE already rejects VM_NOHUGEPAGE VMAs.

This keeps the policy in MM code instead of requiring device drivers
to edit VMA THP flags directly, and it only affects opt-in notifier
ranges at registration or flag-transition time.

Assisted-by: OpenAI-Codex:GPT-5.5
Signed-off-by: Yitao Jiang <jytscientist@hotmail.com>
---
 include/linux/huge_mm.h      |   5 +-
 include/linux/mmu_notifier.h |  28 +++++
 mm/khugepaged.c              |   9 +-
 mm/madvise.c                 |   3 +-
 mm/mmu_notifier.c            | 204 +++++++++++++++++++++++++++++++++--
 5 files changed, 237 insertions(+), 12 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c..3dae515ff 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -489,8 +489,8 @@ change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 			__split_huge_pud(__vma, __pud, __address);	\
 	}  while (0)
 
-int hugepage_madvise(struct vm_area_struct *vma, vm_flags_t *vm_flags,
-		     int advice);
+int hugepage_madvise(struct vm_area_struct *vma, unsigned long start,
+		     unsigned long end, vm_flags_t *vm_flags, int advice);
 int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		     unsigned long end, bool *lock_dropped);
 void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
@@ -694,6 +694,7 @@ static inline bool unmap_huge_pmd_locked(struct vm_area_struct *vma,
 	do { } while (0)
 
 static inline int hugepage_madvise(struct vm_area_struct *vma,
+				   unsigned long start, unsigned long end,
 				   vm_flags_t *vm_flags, int advice)
 {
 	return -EINVAL;
diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a11a44eef..4accfb65f 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -293,8 +293,16 @@ struct mmu_interval_notifier {
 	struct mm_struct *mm;
 	struct hlist_node deferred_item;
 	unsigned long invalidate_seq;
+	unsigned int flags;
 };
 
+/*
+ * The interval range cannot safely be backed by transparent huge pages while
+ * the notifier is active. The MM core owns the VMA policy change so drivers
+ * do not have to manipulate VM_HUGEPAGE/VM_NOHUGEPAGE directly.
+ */
+#define MMU_INTERVAL_NOTIFIER_BLOCK_THP BIT(0)
+
 #ifdef CONFIG_MMU_NOTIFIER
 
 #ifdef CONFIG_LOCKDEP
@@ -347,7 +355,20 @@ int mmu_interval_notifier_insert_locked(
 	struct mmu_interval_notifier *interval_sub, struct mm_struct *mm,
 	unsigned long start, unsigned long length,
 	const struct mmu_interval_notifier_ops *ops);
+int
+mmu_interval_notifier_insert_locked_flags(struct mmu_interval_notifier *interval_sub,
+					  struct mm_struct *mm,
+					  unsigned long start,
+					  unsigned long length,
+					  const struct mmu_interval_notifier_ops *ops,
+					  unsigned int flags);
+int
+mmu_interval_notifier_set_flags_locked(struct mmu_interval_notifier *interval_sub,
+				       unsigned int flags);
 void mmu_interval_notifier_remove(struct mmu_interval_notifier *interval_sub);
+bool mmu_interval_notifier_range_block_thp(struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long end);
 
 /**
  * mmu_interval_set_seq - Save the invalidation sequence
@@ -637,6 +658,13 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
 {
 }
 
+static inline bool mmu_interval_notifier_range_block_thp(struct mm_struct *mm,
+							 unsigned long start,
+							 unsigned long end)
+{
+	return false;
+}
+
 #define mmu_notifier_range_update_to_read_only(r) false
 
 static inline void mmu_notifier_synchronize(void)
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 617bca76d..a9b05e716 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -445,11 +445,16 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 	return khugepaged_max_ptes_swap;
 }
 
-int hugepage_madvise(struct vm_area_struct *vma,
-		     vm_flags_t *vm_flags, int advice)
+int hugepage_madvise(struct vm_area_struct *vma, unsigned long start,
+		     unsigned long end, vm_flags_t *vm_flags, int advice)
 {
 	switch (advice) {
 	case MADV_HUGEPAGE:
+		if ((*vm_flags & VM_NOHUGEPAGE) &&
+		    mmu_interval_notifier_range_block_thp(vma->vm_mm,
+							  start, end))
+			return 0;
+
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
diff --git a/mm/madvise.c b/mm/madvise.c
index cd9bb0770..c7cee4fcf 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1416,7 +1416,8 @@ static int madvise_vma_behavior(struct madvise_behavior *madv_behavior)
 		break;
 	case MADV_HUGEPAGE:
 	case MADV_NOHUGEPAGE:
-		error = hugepage_madvise(vma, &new_flags, behavior);
+		error = hugepage_madvise(vma, range->start, range->end,
+					 &new_flags, behavior);
 		if (error)
 			goto out;
 		break;
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 245b74f39..852a5682b 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -581,6 +581,49 @@ int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *range)
 	return 0;
 }
 
+/**
+ * mmu_interval_notifier_range_block_thp - check if a range must not use THP
+ * @mm: mm_struct to check
+ * @start: start address
+ * @end: end address
+ *
+ * Return true if an active interval notifier covering the range requested
+ * MMU_INTERVAL_NOTIFIER_BLOCK_THP.
+ */
+bool mmu_interval_notifier_range_block_thp(struct mm_struct *mm,
+					   unsigned long start,
+					   unsigned long end)
+{
+	struct mmu_notifier_subscriptions *subscriptions;
+	struct mmu_interval_notifier *interval_sub;
+	struct interval_tree_node *node;
+	bool block_thp = false;
+
+	if (start >= end)
+		return false;
+
+	/* Pairs with the store in mmu_notifier_register(). */
+	subscriptions = smp_load_acquire(&mm->notifier_subscriptions);
+	if (!subscriptions || !subscriptions->has_itree)
+		return false;
+
+	spin_lock(&subscriptions->lock);
+	for (node = interval_tree_iter_first(&subscriptions->itree, start,
+					     end - 1);
+	     node;
+	     node = interval_tree_iter_next(node, start, end - 1)) {
+		interval_sub = container_of(node, struct mmu_interval_notifier,
+					    interval_tree);
+		if (interval_sub->flags & MMU_INTERVAL_NOTIFIER_BLOCK_THP) {
+			block_thp = true;
+			break;
+		}
+	}
+	spin_unlock(&subscriptions->lock);
+
+	return block_thp;
+}
+
 static void
 mn_hlist_invalidate_end(struct mmu_notifier_subscriptions *subscriptions,
 			struct mmu_notifier_range *range)
@@ -933,13 +976,69 @@ void mmu_notifier_put(struct mmu_notifier *subscription)
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_put);
 
+#define MMU_INTERVAL_NOTIFIER_KNOWN_FLAGS \
+	(MMU_INTERVAL_NOTIFIER_BLOCK_THP)
+
+static int mmu_interval_notifier_check_flags(unsigned int flags)
+{
+	if (flags & ~MMU_INTERVAL_NOTIFIER_KNOWN_FLAGS)
+		return -EINVAL;
+	return 0;
+}
+
+static int
+mmu_interval_notifier_block_thp_locked(struct mm_struct *mm,
+				       unsigned long start,
+				       unsigned long end)
+{
+	struct vm_area_struct *vma, *prev;
+	struct vma_iterator vmi;
+
+	mmap_assert_write_locked(mm);
+
+	vma_iter_init(&vmi, mm, start);
+	vma = vma_iter_load(&vmi);
+	prev = vma_prev(&vmi);
+	if (vma && start > vma->vm_start)
+		prev = vma;
+
+	for_each_vma_range(vmi, vma, end) {
+		const unsigned long curr_start = max(vma->vm_start, start);
+		const unsigned long curr_end = min(vma->vm_end, end);
+		vma_flags_t new_flags;
+
+		if (vma->vm_flags & VM_NO_KHUGEPAGED)
+			goto next;
+
+		new_flags = vma->flags;
+		vma_flags_set(&new_flags, VMA_NOHUGEPAGE_BIT);
+		vma_flags_clear(&new_flags, VMA_HUGEPAGE_BIT);
+		if (vma_flags_same_pair(&new_flags, &vma->flags))
+			goto next;
+
+		vma = vma_modify_flags(&vmi, prev, vma, curr_start,
+				       curr_end, &new_flags);
+		if (IS_ERR(vma))
+			return PTR_ERR(vma);
+
+		vma_start_write(vma);
+		vma->flags = new_flags;
+next:
+		prev = vma;
+	}
+
+	return 0;
+}
+
 static int __mmu_interval_notifier_insert(
 	struct mmu_interval_notifier *interval_sub, struct mm_struct *mm,
 	struct mmu_notifier_subscriptions *subscriptions, unsigned long start,
-	unsigned long length, const struct mmu_interval_notifier_ops *ops)
+	unsigned long length, const struct mmu_interval_notifier_ops *ops,
+	unsigned int flags)
 {
 	interval_sub->mm = mm;
 	interval_sub->ops = ops;
+	interval_sub->flags = flags;
 	RB_CLEAR_NODE(&interval_sub->interval_tree.rb);
 	interval_sub->interval_tree.start = start;
 	/*
@@ -1034,32 +1133,123 @@ int mmu_interval_notifier_insert(struct mmu_interval_notifier *interval_sub,
 		subscriptions = mm->notifier_subscriptions;
 	}
 	return __mmu_interval_notifier_insert(interval_sub, mm, subscriptions,
-					      start, length, ops);
+					      start, length, ops, 0);
 }
 EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert);
 
-int mmu_interval_notifier_insert_locked(
-	struct mmu_interval_notifier *interval_sub, struct mm_struct *mm,
-	unsigned long start, unsigned long length,
-	const struct mmu_interval_notifier_ops *ops)
+/**
+ * mmu_interval_notifier_insert_locked_flags - Insert an interval notifier
+ * @interval_sub: Interval subscription to register
+ * @mm: mm_struct to attach to
+ * @start: Starting virtual address to monitor
+ * @length: Length of the range to monitor
+ * @ops: Interval notifier operations to be called on matching events
+ * @flags: MMU_INTERVAL_NOTIFIER_* flags
+ *
+ * Like mmu_interval_notifier_insert_locked(), but lets callers request
+ * additional MM-owned policy for the interval while holding mmap_lock for
+ * write.
+ */
+int
+mmu_interval_notifier_insert_locked_flags(struct mmu_interval_notifier *interval_sub,
+					  struct mm_struct *mm,
+					  unsigned long start,
+					  unsigned long length,
+					  const struct mmu_interval_notifier_ops *ops,
+					  unsigned int flags)
 {
 	struct mmu_notifier_subscriptions *subscriptions =
 		mm->notifier_subscriptions;
+	unsigned long end;
 	int ret;
 
 	mmap_assert_write_locked(mm);
 
+	ret = mmu_interval_notifier_check_flags(flags);
+	if (ret)
+		return ret;
+
+	if (flags & MMU_INTERVAL_NOTIFIER_BLOCK_THP) {
+		if (length == 0 || check_add_overflow(start, length, &end))
+			return -EOVERFLOW;
+	}
+
 	if (!subscriptions || !subscriptions->has_itree) {
 		ret = __mmu_notifier_register(NULL, mm);
 		if (ret)
 			return ret;
 		subscriptions = mm->notifier_subscriptions;
 	}
+
+	if (flags & MMU_INTERVAL_NOTIFIER_BLOCK_THP) {
+		ret = mmu_interval_notifier_block_thp_locked(mm, start, end);
+		if (ret)
+			return ret;
+	}
+
 	return __mmu_interval_notifier_insert(interval_sub, mm, subscriptions,
-					      start, length, ops);
+					      start, length, ops, flags);
+}
+EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert_locked_flags);
+
+int mmu_interval_notifier_insert_locked(struct mmu_interval_notifier *interval_sub,
+					struct mm_struct *mm,
+					unsigned long start,
+					unsigned long length,
+					const struct mmu_interval_notifier_ops *ops)
+{
+	return mmu_interval_notifier_insert_locked_flags(interval_sub, mm,
+							 start, length,
+							 ops, 0);
 }
 EXPORT_SYMBOL_GPL(mmu_interval_notifier_insert_locked);
 
+/**
+ * mmu_interval_notifier_set_flags_locked - update an interval notifier's flags
+ * @interval_sub: Interval subscription to update
+ * @flags: MMU_INTERVAL_NOTIFIER_* flags
+ *
+ * Update MMU interval notifier flags while holding mmap_lock for write. When
+ * enabling MMU_INTERVAL_NOTIFIER_BLOCK_THP, the MM core first updates the VMA
+ * THP policy for the notifier's address range.
+ */
+int
+mmu_interval_notifier_set_flags_locked(struct mmu_interval_notifier *interval_sub,
+				       unsigned int flags)
+{
+	struct mm_struct *mm = interval_sub->mm;
+	unsigned long start = interval_sub->interval_tree.start;
+	unsigned long end;
+	int ret;
+
+	ret = mmu_interval_notifier_check_flags(flags);
+	if (ret)
+		return ret;
+
+	if (WARN_ON_ONCE(!mm))
+		return -EINVAL;
+
+	mmap_assert_write_locked(mm);
+
+	if ((flags & MMU_INTERVAL_NOTIFIER_BLOCK_THP) &&
+	    !(interval_sub->flags & MMU_INTERVAL_NOTIFIER_BLOCK_THP)) {
+		if (interval_sub->interval_tree.last == ULONG_MAX)
+			return -EOVERFLOW;
+		end = interval_sub->interval_tree.last + 1;
+
+		ret = mmu_interval_notifier_block_thp_locked(mm, start, end);
+		if (ret)
+			return ret;
+	}
+
+	spin_lock(&mm->notifier_subscriptions->lock);
+	interval_sub->flags = flags;
+	spin_unlock(&mm->notifier_subscriptions->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mmu_interval_notifier_set_flags_locked);
+
 static bool
 mmu_interval_seq_released(struct mmu_notifier_subscriptions *subscriptions,
 			  unsigned long seq)
-- 
2.53.0


