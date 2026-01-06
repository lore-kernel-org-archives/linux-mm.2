Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51C6FCE9D47
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 15:12:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAAF96B0005; Tue,  6 Jan 2026 10:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B82556B0088; Tue,  6 Jan 2026 10:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B946B0096; Tue,  6 Jan 2026 10:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E5846B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:12:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2515657BB6
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:12:51 +0000 (UTC)
X-FDA: 84301881342.08.14CD003
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id BF6C6100003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:12:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KpsLJOM0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BmwN0lAD;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767712367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8gQaPnDRbdquczzpq+k+EmPWZyZ8tROV+YYkXiPUPE=;
	b=FlR0JaRL6xMbw5Z5QkdGt/m7jibjtFjpSfeQUEATTr0PWtMwfT0xhnQStZ6PMPUZNkFCiY
	mlG6kQh1NT5IkpyyoDnaWzlhaEH0oXVN6Ya8ooXhps1kOWQZRjgA257yySklTu9yw9guCG
	7J8JUSLRGn8dx40vdIvFBarQXiLVQsY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KpsLJOM0;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=BmwN0lAD;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767712367; a=rsa-sha256;
	cv=pass;
	b=VURQEcWChufdPq6bM38WQsyBkNbXXJ/vnt2mdHz4QbC/yyvCf7Cxy5285dK0Ss40hpeOtQ
	KDcrWZgkEcsspEYFEek0J6lHBagrNAIxqS6cuhkgwqW70+TSa7I0qo1KxqAzlYlvZFXgTz
	xX0KjjFVfS9ufsOVXzwgycrQUakXJ48=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606DEfjv166594;
	Tue, 6 Jan 2026 15:12:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=w8gQaPnDRbdquczzpq+k+EmPWZyZ8tROV+YYkXiPUPE=; b=
	KpsLJOM0vUXJwHdvG6llYUIQtrOcr+uqGc8zL7vfnyMiYtnX1Y8ARlC7mVql1ayO
	Y8KXSQApt+Ex6qO1sWK8XOw4Gg1r2yWeBWBU+Puph0VVuWzIve2m6PvxHB+c2lIe
	pelYLRH6itED03xPU5rkWlxyi0HMTojEayZk6iZyarXh7MFm50Ppe4oDBgSKiCjQ
	jdPgvp01BML0lRHerZ72Dpr7hQFuNOXxGeoC+C56Cx1t/RwcALH+OagxpTQ/3SX4
	HBzLv+HDsmjkUhD2JlzUddxkdhpLNOC2iGuk61SiE58QmJ6d+FM8JJunjzIGkPZP
	DgoPddgsrN16KzgacdVyrQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh33x065p-7
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:12:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606DBj7D013571;
	Tue, 6 Jan 2026 15:05:02 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010050.outbound.protection.outlook.com [52.101.85.50])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8em9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 15:05:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qUdO49ghxMFd8BOKu69as2mkWlC9JBrX0x7F3hhxuAiiUbhg3XMvBSeBbiS2XOEnz/mDri0RbA6jOgWDhLGKQsxgISvfMPvdN6us5Cc6iGlzWW4BQhpnUEQKF+PBcAOCV3gyGR/9+yr01ZnhPxIa4nsJLbXvOgTqhaq8dTpTuLgtL6I4OWOWZ4/d+olyz0HPDZ298B/EaHPqI8wgM63O4IaTwrD8fb5M6FtUOJ5vPu47zgR/95tt07y2CblJ5Pv5gCTjNqwcJgoGQLj4DWljQzvx22faMW5+igf91A6viANrjTGN5Y16Y4GMebvfkzu7FlJMqZKwVbmhtYqS9qQm7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w8gQaPnDRbdquczzpq+k+EmPWZyZ8tROV+YYkXiPUPE=;
 b=kpLwXtyBFKPvFOz84R8+WrVWGD81AFYG66I5xFqPrxTLTA9IPWH+LmGlHVMg8Xiwdi1dx/U2jYfN+/HO5JlyvqIBqV3U/ZpkBv47gu7Fqh0+7HzMiycTDo+LOzd1Tdmf9Xutxdzv1CXIc1hwmjPP+gWncaTbtw+6BoawDd7db+IhRxags6QVYUk6FPUxYrN1DMVRe7+qMycZtT+1WP94wZ3hUi9wcK3IJAeU+wYex8LkDhTvuMZaYaIJSssqqzC13hJR6i0MHlSrUahUJlVuXc8Ckrt+LF8egdlAkOFvN5qZVJpBmFS4D/doTm/TU1U53aI7/kZRRREuYuXtP13VuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w8gQaPnDRbdquczzpq+k+EmPWZyZ8tROV+YYkXiPUPE=;
 b=BmwN0lAD8+DQmTMMfL96vpbT83p2ubkXoT0hDJhFiUDMnDt/cGMUhg0L74xDK3gQJCMgYKpzTZ9lfCYQ1hR6mPuRLIEqJmRvaeCmZeqHCWueJmQz/dltcV7Mm9nWVvoWRj+qFrc6M8JVl/Ij3XccCM3zBcmL5nrbbe2++u3Tmq0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8083.namprd10.prod.outlook.com (2603:10b6:408:283::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Tue, 6 Jan
 2026 15:05:00 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 15:04:59 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 8/8] mm/rmap: separate out fork-only logic on anon_vma_clone()
Date: Tue,  6 Jan 2026 15:04:33 +0000
Message-ID: <a4f87ba914697a47419f12901a995759fd977fdd.1767711638.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0348.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::24) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8083:EE_
X-MS-Office365-Filtering-Correlation-Id: 481919ce-42af-4c16-5fb5-08de4d34f5f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HemoRqPvDCqhmRreCg5TOUyREKSiRDCfZAUF8NEmyMTsB2ZjPjJaV7AuOsgY?=
 =?us-ascii?Q?oBjJ2PnekRHpKRC7TMRos3rw7/8OAZ+Q1bUBRQRLuhyRrN9WXcY7qKzv7wF5?=
 =?us-ascii?Q?jRS7x0M4ZrUz26Snrk7sObtwbgVOYhlS80RZCmrcu9gAPxOH7jNF7iE9UWki?=
 =?us-ascii?Q?ZKK64EV8e2HGfROVF+0TBmQLLAKiJKU7jpf1bjPcZS5QIQKwh2umwZFEF8BU?=
 =?us-ascii?Q?6DcCwXN4LlQp+Jeci2ewSw9i/uJzXf0hreHvMWUYmHFnYcVJ1lM9wNqB7+ry?=
 =?us-ascii?Q?Qc2HVEs++owCSEsRNXhlc5aWKmCBp4iue9Vxvg8NG4RDmnx4CEt9WeH4V1Am?=
 =?us-ascii?Q?SVdtvBZP+yCrbWnGBFEzgVfJW5vVP4D3eL5/zFiBflEyF+MXCWar3YI1UBWL?=
 =?us-ascii?Q?2R/uftSVYDKWDgpWUHwsU+v+MW9Fq0JTV3SeTlhZnUv3XVLarDGwv9JMfE/t?=
 =?us-ascii?Q?ZkNQvy0grqRlG+gb1xGiB8zEBny0kw072cQ+LJmM5tazYWiNMwGHJKs3ixef?=
 =?us-ascii?Q?7fqs0Z8WAC3VzNPQBh3xcc93UPLOf3hEpWFxYf4nmMxC0mAq/FmHrOUneHuZ?=
 =?us-ascii?Q?pF3cK6KAxNuXDcQQjSmmuUpSm57L92qrw+q/P4+IvCOt3zigzTQ8hrok17wG?=
 =?us-ascii?Q?Q2AKqd8FMFINu8HkfWcmon3NK+uwf1BcgAxU1Te8m9J/WbLvKcs8zADdV/sy?=
 =?us-ascii?Q?jIvPKQxsogquPyzMxkm6V0dTIwTVVZBNoW1Jl9MCaUMI0eoOTLzoZrSejaMy?=
 =?us-ascii?Q?jU++vvtW5QS9cyNtrvouPk+/01xdRGycyxzynU2j2XnnpvRjGSeBo+Z0LEpH?=
 =?us-ascii?Q?6ICrjl3S6IKMZ9g8B0kWSWvYWY0LMov0+ldx0OHJnoHZG20+B6OK9VphnpAN?=
 =?us-ascii?Q?V0YxAnbnjHbUk536o0owSd23cP5DZX/teXvbjVy9ZlU2U2lnI6zaePydGacs?=
 =?us-ascii?Q?C1JX3iRsUtnBZjF4ep4Doo9BdLzHqAnVafsWXN9Ve2zqd4jy2CJPsuQyGhBx?=
 =?us-ascii?Q?Ei3hqWujKnf17wkHoPlmfaPtwsqftPXM7cC4ApoWovRsCmDrp6PaBBSCg+P8?=
 =?us-ascii?Q?yWKoU1a+VaySAsK9zOykP6zIFf4ZohVGS0ls8oAAgbdRQByxRDoNHVD5LoX7?=
 =?us-ascii?Q?jGqLgfh8BelJ7PRihPOPyDj7nvOg6qaYG4cJt1HhD4HIi+72d8NzON3K4//R?=
 =?us-ascii?Q?pefU+qiOTLZMtwLoqWIFwjFI9kedgjQBY4CyuojnmXx6Anz3pv4r3O6se034?=
 =?us-ascii?Q?wspEVvcy0iQqHafgiKGqeNWzhwpHOKm8mgngJFs7PGY4C5VXcPxFiZDjrZfa?=
 =?us-ascii?Q?vV3vm+0L1q+IKTPFKjoZZXbhsNpKUDimMLLIaOjQREh+Vo41Q4I7qwotvKYd?=
 =?us-ascii?Q?xxL2WqH+q/1ysJKaSkeMhU45N7QreJ9DGjYQ3vrxux0GHgxYTw79KHSSK1jr?=
 =?us-ascii?Q?Es5Nxmi7Vd3cuS9CwXPqDO2173oLft2D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OP8vUv4CW1cR1eBoK6OiqA8L2VLsrGVmRzAUI0O5+cpKnQ74ax5d4tumFmOY?=
 =?us-ascii?Q?DYW+99XEfuEEN/3ZuWMXAVrOXuurrWXVnzU19wIxEorTJ2yzduMIkbuotVCB?=
 =?us-ascii?Q?R8qRhlgaME0UDv8bS6g5SHyI8Xp84T+BHGJJQc72v631f2+DegP2rAKSqZst?=
 =?us-ascii?Q?hQUHpzD/sV0uKGFUivoUttX4w7yH+yh0E9Ox3ZlJxoeTchGB/NgnIJqDGcUA?=
 =?us-ascii?Q?CsjUqs8XKaBTL8UFvfv86qKESKPvQdwXkoN+ZVrnARnrjC8l+GVk3QeK4SEr?=
 =?us-ascii?Q?V8Q5C1rPlC0t3wrIXV7yjimWf0WqL26tPEhBqSd08E65jhQA42Yz21n3bcPY?=
 =?us-ascii?Q?uqHEarbZz6rzbzhY50b4lzPauyceA9hdYGHP6/hpCOe3I3w77ufIm0LVO55B?=
 =?us-ascii?Q?tnL9xeiMe+IC9JvpvcOx4HqJq+yt7hzrknmxLGK6h0onXVXYuO4kIJPlDkAp?=
 =?us-ascii?Q?GnEFxklwNJCGH5MFrCH1gtNnGJYBGBgcBUy7mp9+aHOMMDb4rnqM10fTk5mn?=
 =?us-ascii?Q?xHLiAEL6sP28FzP4mLYgLeSgqHryd8kHU/Mx7Vhu9qZJZsRIhPcAuOCPu3IY?=
 =?us-ascii?Q?z8OeIf6mJowQSalq0ZDC+csJWR6O8APqv4ecV/lqIiG7VrxJT42LaOUcFUOQ?=
 =?us-ascii?Q?cb2yLYeQd82aH8Oemwk+D/O4dPOFnQm7T4xE787IBWSadMpDn+/QKBmUZJza?=
 =?us-ascii?Q?Oin8koYRT6//hn0KZtGp6uw3xYBphQ0vrHLPcJV4NfnUwSmJI++QPvofVwQK?=
 =?us-ascii?Q?JgdqdqMlr3utu45UcnurkqdE5nnmX+lH05jO0WrqZMk6zd5tWtBPO4oG8Hfd?=
 =?us-ascii?Q?aAcpy4EdEIR8cfAw8l2phoAq+afGoe1f2TpFtdvaS57rjafzNZQdJpvibfBr?=
 =?us-ascii?Q?ZY405mA1pLUvaLv01s86B4+6jU8jpIJGJAwOHkh82rCLm2N+vt/LJ77onHeC?=
 =?us-ascii?Q?uFrKBvyebo8P5UW6cgRvJ0PvcFIxrY3G1Lo/nEF2WuiXcoxWBLJ7hl/4zhsJ?=
 =?us-ascii?Q?x9YS7Utoz7BVoHdZBvHw3b1RC97WjkKtJjDY+yU3rG7NJMV8KH5sG8+ob0fJ?=
 =?us-ascii?Q?+m90dwSUx7H7V0PfUfdI7sn3+eDw7gyLupjByQTtZPN8ZPVkkR5nDff0uSvb?=
 =?us-ascii?Q?xDP+C90uDkZgHwooWAexpWTOTjgVjvzdmNncs2+OozoN2QbOi4c+klEf32n1?=
 =?us-ascii?Q?FKWotxIBJu4rmRxntAivx4ZqsRrh06tc9LPs0vQYcES/9Fetjv+/zP0X5EoF?=
 =?us-ascii?Q?pm7X24T8DaIPjvYo+s8m6xhYDHLXWMaB0kbjOBS4Y/oufoQ6YG2ifQ9d2W+D?=
 =?us-ascii?Q?l6JG1RQ6VUOwusl68EuxQBuVNwrxUhAePjrMptzSbBKtFigK2Bi0QoEn7uLL?=
 =?us-ascii?Q?5nmA1a/Sas+cEMTvfpFn/ZC13JMDCLmGKFnYqE+11Y4EcAz7kx0enLEaBZ9/?=
 =?us-ascii?Q?+fScOs2MJQP5nPWAMCi3VH2NrdEJIdjK3S+hA+1YTjecSzZkGRHA3tCJzPUo?=
 =?us-ascii?Q?rKJOqKPty3ne4vNbB/Xm8mr2fuXxlabo+8r5ClwWDUMkhp0a2I9fnV/VhocE?=
 =?us-ascii?Q?D1ozjqhDkh/c9TH/HX4Pp3e1wxkcUy1eSJhvIByedFpX1ex6zjDXk56BeH3f?=
 =?us-ascii?Q?dPPUW3lWbtzW/mfPiVnyVqQrhFP15qHuMW9NZ3VdKVmxIgT/3xCtukgJhH+e?=
 =?us-ascii?Q?iTzbp93+tBRwL9WgBTAH4lEA6D/QXXTD2qKujlt0bAMyXZKdHXWFbMtodKaS?=
 =?us-ascii?Q?Ibvt58UhsSWgTZrx9qDsXehp0kdtFcA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kF3gSfgS0gHI5II/RzTi/AN+cPOZlbpNqR179RhUz/I2uF2Poo7gLm6awjfhNmCj7AToeuz1dhVq/enKbvW56LFv7w1PrZUoFDhCdZvKYXydV/KtkNt+wHOKebmwS9UKWV1LUChShGbrqvSHCpWZfi5BwbTyDtmdQsWQvYUVmcKFY39KejoHkaz2K3RVcFZoI7ZkZyY0509EJ+acDBo/vi4bCO6ILUMHF/6xSM74VF2T5hvebotMPpD6OkuAMH4uvx3KvG86/DX0NN+hLYaQKbj7MaI86tX0dpg7Go2R80VrSW3R2FJHpnCDjZS+Ff+40Kp15DJjsnvZviOSPxTDXf8XgPDkyR4O3olyYroxTEfz4Qza3DKGGz1ioPJh8MdSn03Rn4e3pWqaEQ9tRQPk7VBwmqosirdYi4rfrtyksyanSLJJcpOQuh2EjW5YUFcZXMQ4xbIcPplJ1yiwGVf59lhFoEEhL8whKcnXp1Fnv4rd2axjXfpTJp3ySyTOKT1bZuzh+P4gQEMvUy1tqOAUe7k7N+EC/ebP7KC3+a7FPtjMSID34ULhYgg0GtzkeOn/j23y6EnATJMeIAVplaA0OUkEwMNTsyilDRQFQvuqRi4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 481919ce-42af-4c16-5fb5-08de4d34f5f6
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 15:04:59.4317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g0HP656Xj+y1Nvh+UAAcQfSiBan9UT4r4rArHg3SWXzWZ9FvXGdkrLClGwxTlwDBYS2kZN27CV5CmWt2yxP/a1wOicdo5SpekaRWZn925Jo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8083
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060131
X-Proofpoint-GUID: ZSlV-LMzJS61PK911YtoPfbiw9pGj--K
X-Authority-Analysis: v=2.4 cv=Y4L1cxeN c=1 sm=1 tr=0 ts=695d266b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=jhzElPvkwTWLxKQ5pZcA:9
X-Proofpoint-ORIG-GUID: ZSlV-LMzJS61PK911YtoPfbiw9pGj--K
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEzMiBTYWx0ZWRfX0vBhgL/Gqkjk
 V6Cvzfs2qq+678YMPOJoCiwPAyCzGuvpsEMFVNUaUVRSLD8cBPwmzdo0PDnkB3M7PKJNt/Nd1zp
 D/6uQyjrXUju9KRk8fdI6HVL+u3FsHcsOaWsw2r0BJuMcZqmMR1mG8HumBM5IgRsG90tkHYe+JA
 7c1Ihe0sG43CcQci/ODXfK0dTTN8Kg13Pt1VaQx/61mGqgEuNQnRd3SXnjvx9ZkvJDDJ0UNAAIM
 qQLKEYIzlma/QSM0zaGXxHZQrDYSSl0H7o9WqOOJEFnaKcJa3Eev4SDQpK8k3BDSdhseXGl+KYb
 JNXqrjyX3TOx/ntweqbg8J+U3R45hHnIATB4yFHDv6YDsAiikOePqutOUL1s5FGlWr/UgADihXq
 KGOdNgQAymjfn2puhoapn1zLG4+IlDgK4UI+kMRp6prQ+BcV8kNTkm4LOfsgj0Mh30ZoPsHbK11
 8tt0WUlvXAci9/Li2Ow==
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BF6C6100003
X-Stat-Signature: mnicxjkn1btza4qtwch7w794479fy1cd
X-HE-Tag: 1767712367-944935
X-HE-Meta: U2FsdGVkX19tv2iam9Cc90xM+HCk8klVTnTBe7wogRqQoI/jKjyDcIwGkw+gKROXKTonLUVCjae60M+vZdgvqLX27YLupC6D3343JyHc6rP9pBGuErlS1RzfRN4rHCNrwZMLhCwFhnWSYFpdUL6Yuovyt/k4aXZvpeJPN7lbHMpSKeVHZSzjpGhNjrk3eTXWvzf4tCKN8TRnccaOCyUbs32Y/TG2LMTz8V6jf0uK8PB8mG7Q5JvYFhmDfflSAKX7N8A/gN95NbmnLqL94MZN/fhcdbY+xGto3qzJHw9fsgVVSmX4hhXw7wYE+Wgy4VgYknBgvC0fPVwAD1LXK3wDyGyfddSVKurBOHwJcgCWc9CrwmOP7V0aGwXtRmkyUXMcjsJY04jFEkgKMgEAwNlp21yP+KtsMYqhUYafW4uOWTWsAb+IWbLaNLlSAirzieg68RZ+gaPlcUhviE75WbK+5fhjscGS9DFljnbMHuZxBI2krvWcVk0NV8cwKYGEiz/Zv719QikGC7ZKWbwJ+tvlGspxkrnN+lYVdNZlz7ATEM3Im9aZe5FhEMhleEAmSNbfrtXr7roh+hlPJI4sARUGaLwlcb/Pyh290me5k/hdKqF5V7PLsngUdrwbiJ8YPcT0y2TeL6E6rnbUoRU5641nIZ/BeMrRzn4cAULy2fzffGf5rBXzVNVvW7BtI8CCqph2teAfFu6M8lKFw29MRVBJM6AoJ8c+SOafG8ZvU2HwYisUKPNlvLEtZBTLPP4TG669MvVA/4ydyZSAwu50LOsqYGbjEOWBYAweYX2fm+InWMyRVWOOY1quaG+KV/Ns+Rfy948EcyFwUQjGpG4vVNCEwthRLSAeh8t+e0grte/N/e9GLguLlT2yfPvYE7MRyZAlVFZaZAMdP8lkQNirHOD74sM+muN7t797uWhLnZuia1TlLkEo4PwqCD3x0hjxuzjGNJq7i11QYZRfv1GtrNx
 fL79PGFw
 xfj+ssJ/sOxYy9bDYh5ny3jdKJqGMgxlrcsNBWrTPVEMib45+h+uCcnbwNe0pVGIjHRswYCwWczda8kaSkD0rrEPhnS54QYi6U2f58srgS7b8WQ7PW2WDthCcZu/7DwooKAaFkyixJzpybI33rjq5Ili/TKIzkfqvAzlCfjpOy/8kj1MCxhvZyVQ6mPbkosOR8F0l9+wTOaXGRvCXBBErE5XTzqmNNouubKCxYHtXhhEVp39JClbXhaqKVEomzJfmvsQ9Ovc5jaxS508+P3gUv5YdYi+TdvSzlvcqNoWVLBhBko9vboB9fsBkakbUY2h2q/C8nWutxJx5Ew483zBwerlk0KJIpxMtEy+xDMSgsl7Vega50w15pCGPJ/P+JDd3/+g4rBrDZrlCbRt9HjqYM4B9SJuikaxgeWO1lc5Ytg9u3jRQwUuxH+7T1+ocy1K6jCEHmkKhrjGOX6ilEXWYhK3aVL/Ol+L2SXYs7p1/IFcL3C74tObiYRmAfkfyFkJdXzupCFCexbx76rB46ytMJ1DZe78IowPa2m1OA5VaSGR6oBkt27IeWQFqO5+vV9ujzwUbHfJpTz7qIZSXrFsDAvq+qpXOzK5AkH0TquPIguY/YtSWKwIzbZOWpdnq9v6RFBvWE/6FJ5pA8MHJeCCKur9NPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Specify which operation is being performed to anon_vma_clone(), which
allows us to do checks specific to each operation type, as well as to
separate out and make clear that the anon_vma reuse logic is absolutely
specific to fork only.

This opens the door to further refactorings and refinements later as we
have more information to work with.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/internal.h                    | 11 ++++-
 mm/rmap.c                        | 74 ++++++++++++++++++++++----------
 mm/vma.c                         |  6 +--
 tools/testing/vma/vma_internal.h | 11 ++++-
 4 files changed, 74 insertions(+), 28 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 4ba784023a9f..8baa7bd2b8f7 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -244,7 +244,16 @@ static inline void anon_vma_unlock_read(struct anon_vma *anon_vma)
 
 struct anon_vma *folio_get_anon_vma(const struct folio *folio);
 
-int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src);
+/* Operations which modify VMAs. */
+enum vma_operation {
+	VMA_OP_SPLIT,
+	VMA_OP_MERGE_UNFAULTED,
+	VMA_OP_REMAP,
+	VMA_OP_FORK,
+};
+
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+	enum vma_operation operation);
 int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma);
 int  __anon_vma_prepare(struct vm_area_struct *vma);
 void unlink_anon_vmas(struct vm_area_struct *vma);
diff --git a/mm/rmap.c b/mm/rmap.c
index 8f4393546bce..336b27e00238 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -233,12 +233,13 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 }
 
 static void check_anon_vma_clone(struct vm_area_struct *dst,
-				 struct vm_area_struct *src)
+				 struct vm_area_struct *src,
+				 enum vma_operation operation)
 {
 	/* The write lock must be held. */
 	mmap_assert_write_locked(src->vm_mm);
-	/* If not a fork (implied by dst->anon_vma) then must be on same mm. */
-	VM_WARN_ON_ONCE(dst->anon_vma && dst->vm_mm != src->vm_mm);
+	/* If not a fork then must be on same mm. */
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && dst->vm_mm != src->vm_mm);
 
 	/* If we have anything to do src->anon_vma must be provided. */
 	VM_WARN_ON_ONCE(!src->anon_vma && !list_empty(&src->anon_vma_chain));
@@ -250,6 +251,40 @@ static void check_anon_vma_clone(struct vm_area_struct *dst,
 	 * must be the same across dst and src.
 	 */
 	VM_WARN_ON_ONCE(dst->anon_vma && dst->anon_vma != src->anon_vma);
+	/*
+	 * Essentially equivalent to above - if not a no-op, we should expect
+	 * dst->anon_vma to be set for everything except a fork.
+	 */
+	VM_WARN_ON_ONCE(operation != VMA_OP_FORK && src->anon_vma &&
+			!dst->anon_vma);
+	/* For the anon_vma to be compatible, it can only be singular. */
+	VM_WARN_ON_ONCE(operation == VMA_OP_MERGE_UNFAULTED &&
+			!list_is_singular(&src->anon_vma_chain));
+#ifdef CONFIG_PER_VMA_LOCK
+	/* Only merging an unfaulted VMA leaves the destination attached. */
+	VM_WARN_ON_ONCE(operation != VMA_OP_MERGE_UNFAULTED &&
+			vma_is_attached(dst));
+#endif
+}
+
+static void try_to_reuse_anon_vma(struct vm_area_struct *dst,
+				  struct anon_vma *anon_vma)
+{
+	/* If already populated, nothing to do.*/
+	if (dst->anon_vma)
+		return;
+
+	/*
+	 * We reuse an anon_vma if any linking VMAs were unmapped and it has
+	 * only a single child at most.
+	 */
+	if (anon_vma->num_active_vmas > 0)
+		return;
+	if (anon_vma->num_children > 1)
+		return;
+
+	dst->anon_vma = anon_vma;
+	anon_vma->num_active_vmas++;
 }
 
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
@@ -259,6 +294,7 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
  * all of the anon_vma objects contained within @src anon_vma_chain's.
  * @dst: The destination VMA with an empty anon_vma_chain.
  * @src: The source VMA we wish to duplicate.
+ * @operation: The type of operation which resulted in the clone.
  *
  * This is the heart of the VMA side of the anon_vma implementation - we invoke
  * this function whenever we need to set up a new VMA's anon_vma state.
@@ -281,17 +317,17 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma);
  *
  * Returns: 0 on success, -ENOMEM on failure.
  */
-int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
+int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+		   enum vma_operation operation)
 {
 	struct anon_vma_chain *avc, *pavc;
+	struct anon_vma *active_anon_vma = src->anon_vma;
 
-	check_anon_vma_clone(dst, src);
+	check_anon_vma_clone(dst, src, operation);
 
-	if (!src->anon_vma)
+	if (!active_anon_vma)
 		return 0;
 
-	check_anon_vma_clone(dst, src);
-
 	/*
 	 * Allocate AVCs. We don't need an anon_vma lock for this as we
 	 * are not updating the anon_vma rbtree nor are we changing
@@ -317,22 +353,14 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 		struct anon_vma *anon_vma = avc->anon_vma;
 
 		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
-
-		/*
-		 * Reuse existing anon_vma if it has no vma and only one
-		 * anon_vma child.
-		 *
-		 * Root anon_vma is never reused:
-		 * it has self-parent reference and at least one child.
-		 */
-		if (!dst->anon_vma && src->anon_vma &&
-		    anon_vma->num_children < 2 &&
-		    anon_vma->num_active_vmas == 0)
-			dst->anon_vma = anon_vma;
+		if (operation == VMA_OP_FORK)
+			try_to_reuse_anon_vma(dst, anon_vma);
 	}
-	if (dst->anon_vma)
+
+	if (operation != VMA_OP_FORK)
 		dst->anon_vma->num_active_vmas++;
-	anon_vma_unlock_write(src->anon_vma);
+
+	anon_vma_unlock_write(active_anon_vma);
 	return 0;
 
  enomem_failure:
@@ -362,7 +390,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	error = anon_vma_clone(vma, pvma);
+	error = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	if (error)
 		return error;
 
diff --git a/mm/vma.c b/mm/vma.c
index 4294ecdc23a5..2a063d6568d9 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -528,7 +528,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (err)
 		goto out_free_vmi;
 
-	err = anon_vma_clone(new, vma);
+	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
 
@@ -626,7 +626,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
-		ret = anon_vma_clone(dst, src);
+		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
 		if (ret)
 			return ret;
 
@@ -1899,7 +1899,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
 		vma_set_range(new_vma, addr, addr + len, pgoff);
 		if (vma_dup_policy(vma, new_vma))
 			goto out_free_vma;
-		if (anon_vma_clone(new_vma, vma))
+		if (anon_vma_clone(new_vma, vma, VMA_OP_REMAP))
 			goto out_free_mempol;
 		if (new_vma->vm_file)
 			get_file(new_vma->vm_file);
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 93e5792306d9..7fa56dcc53a6 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -600,6 +600,14 @@ struct mmap_action {
 	bool hide_from_rmap_until_complete :1;
 };
 
+/* Operations which modify VMAs. */
+enum vma_operation {
+	VMA_OP_SPLIT,
+	VMA_OP_MERGE_UNFAULTED,
+	VMA_OP_REMAP,
+	VMA_OP_FORK,
+};
+
 /*
  * Describes a VMA that is about to be mmap()'ed. Drivers may choose to
  * manipulate mutable fields which will cause those fields to be updated in the
@@ -1157,7 +1165,8 @@ static inline int vma_dup_policy(struct vm_area_struct *src, struct vm_area_stru
 	return 0;
 }
 
-static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
+static inline int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
+				 enum vma_operation operation)
 {
 	/* For testing purposes. We indicate that an anon_vma has been cloned. */
 	if (src->anon_vma != NULL) {
-- 
2.52.0


