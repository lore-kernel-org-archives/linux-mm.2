Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E8CBC44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15CF76B00C1; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10AEC6B00C2; Wed, 21 Jan 2026 11:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAFB46B00C3; Wed, 21 Jan 2026 11:57:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA42B6B00C1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 83D18D3650
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:20 +0000 (UTC)
X-FDA: 84356576640.07.DCE3871
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF01914000F
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="R6/7daGk";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mu9bUC1G;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=;
	b=JJKqzkgBpmn1SBpZBmTS3g1URNlS+znSGumcXrSypIMLuZYAbXnY7CANJMp4btshUuTUaG
	1fu0lY2Ouw9HGldAT9f3Q8AYBy4vNhcxq6oKxMVN7F067pAmyuoSWPjU4mKWK+TceyQwFR
	y6j5laQw9N13Gkls/72ucZYzHoIhZC0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014637; a=rsa-sha256;
	cv=pass;
	b=kOuC/IwC8l+W2tSTo0NFVDWqchGIlvrLfqEPMsKvmrukAvmI73UJtKIYlKgHG2puLI+kbA
	Bv0FYTN+dUP8O7uqr1NVTrD46U/8V70pYecdRclbOeINB+7piCXg5+JsScyvbwPDB3M6MZ
	Qidl+1Ai3BDanTYFJc/oySjYneMqQ9E=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="R6/7daGk";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Mu9bUC1G;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf23.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LFSt3g3430913;
	Wed, 21 Jan 2026 16:57:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=; b=
	R6/7daGkBcmSTALki3x9ciKCR/tf+7dwfVu9N8AZ8vAogNUx6Id+LLdZeZm6pEOl
	E3i5JYxbO7+HRqWgLoY1SDmnU5MWe691/gUeGc0kNI3uqVj4dC3K8akB5K9M9IfC
	8O2Yvj5BYftmXMtAWWrcRFt9Z7MfmEyBhxpPztT9SbQaQH2Ys8dF/2Vh7b9UE98M
	q4gAkcqGTqBT0h65/ZjGSw73Ww4mcHc+JjSnCNJnJTwSPwrUYeAH2sO2/bO9ghlx
	sGDne5owOXtYT967pZM7unyq7XAaX4OHIGPnTd9bH90GjgEGeZTGZBINmD5yusWd
	miy7x+xzThmuJidHDzJ2YQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5p60h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:06 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LFW2Rq032121;
	Wed, 21 Jan 2026 16:57:05 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011021.outbound.protection.outlook.com [52.101.62.21])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vfamcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Z4QKmhxclWEuQieU7Ht0exDMScaTFSN+UxykMeS7z5y+zOduaOJb1uJlDNa5GQsqUKs0pJsYnpqkmeU4RkrLoBTeJfR6uARyKSTMZd0eFRKeZuPEbFgWq8aWyTVbm0O2lv2rPNRPUD/kF0b5TTT/2f8IivfMVamEMmz6cJpK1SJ+5r+l4xpl9HBNFdyGHIZTgNiStFoQb7cV9fwEOXoj4h0c2NpccGFf9SlRKOJjFQ/U/zu1p6dZu0e4NWk7Gh9c/7eJeyZqXFFM4EZ/VX9x955M6PwQNK4ViRzu2db53otYC9Lc/i1UAbHyerJe83yBgZTePFEC3WGwKUtPystZIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=;
 b=ZuyyTjo23Gjab13Js0SYTOSiQrbfN9F3940qghKc6WVdR4yJDBs2/jxy9bEHeNhACgnFNxVRUXO5HA2XjeNhdu+dZQl4bh1IkqnU8pxdzKH3xtmhfp5gYtyhsUcAIsOI6Jz8x23BC/1iEi8Z20eczmDARP9wnt7qLQmiSU2GdWAbigS2AeKu9JdADVnampFqxIuylDSR6ypaRJ/eR5BNkcqwJp/w1VjBHUbscSY+A0yyWXy4Biw3Y3bgani8faFeOJtoLjtsnXrcbGHIAvtQ18TSqdL5qmdhKdmd8XeyCOISWEefU5N9PfamPjqzwzWr/2LDZttz+YuJI9h/gThETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8vg59wYyGp9OYEKC17r9gTc+r9ahrfGb7yHqJ+IgVs=;
 b=Mu9bUC1GpB3NVg3lmyO5+FQ2e/vz86wNxnqIHlPkl+FzVbztkHhCGthqK8TqUQlN9eMaYq/BYFZrZyrxVFk3Ac9Q4KZkD5+jeZ2CXd/Pwuw29BYks0AW9hm62LatMoWKHc9O4MRBpmc44/DuPFggQ8rnM8grXzHcZHJ4MHgySKE=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7712.namprd10.prod.outlook.com (2603:10b6:806:3a3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:56:57 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:56:57 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 07/29] maple_tree: Remove l_wr_mas from mas_wr_spanning_rebalance
Date: Wed, 21 Jan 2026 11:45:04 -0500
Message-ID: <20260121164526.2093265-8-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0024.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::25) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7712:EE_
X-MS-Office365-Filtering-Correlation-Id: df3634bc-d64a-46ca-a0a0-08de590e166d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?kWarI3E8ZHLghd9HeiZsfdNQ62s8Papl+CwdgmNyD6pEBxh0bGqIJTRJHQ6x?=
 =?us-ascii?Q?wNWWh+a+n59JrGHt7MWlck+ejIIRs3+SRIBo+VU48VBLUXJ0XFoY9cqSJx6c?=
 =?us-ascii?Q?bUzxk4pucr1psAAXPy8k6saww3XCY7HI6Q8u0vY+zRgogaO2Rfi+aiqhBMRo?=
 =?us-ascii?Q?EGHF5f3PsCVTVSbJVnSGrJe5U6Vyr7dAB9EJaw/np0G0h/5xJDGTtFTtVKwK?=
 =?us-ascii?Q?3dsXqV5HwEKqRY+/2y6PyC0dmwIJwsMc6rXhg8iYsGxO9fuehq9Pa+BIZ9Fx?=
 =?us-ascii?Q?v7S6AoPqWC8fhQYpidG1r90H9BP7lWT1D61VqK84G3zTzNfjYQKL5j//itSr?=
 =?us-ascii?Q?DeA1A5+Zw9CxhPyHaX1W7A0Cv31KTf1ZGgvB64pW2wIyMCneIoKNL3OiyiJ/?=
 =?us-ascii?Q?l6N8UzBS9xIDtjrvYjezxk2q2VQyUH7uiX7rOpDfrwI2BcjjWstvkYo3nbmz?=
 =?us-ascii?Q?IepfONsjjoyH+2rL3A+MDx5lFt1v5ccvhH210xZ7rEQfha/vMBrJ+dwv6Vqg?=
 =?us-ascii?Q?eps5RYkPE6MD9717aXg4weqqkk5H75NaCW3XPFShp6eAlyLtoxSsCBSHWW0H?=
 =?us-ascii?Q?uA8btn0N4fD8MClMd7/bIV2QxSz465fuyA6qTwaJF/+J5la/QlgMBb7idH5q?=
 =?us-ascii?Q?pY9mP+OmVR6QOFWZ8fTtPbohZslzSe0E0tjYcQY3EhJn0OWjW5n/9EXLrpBY?=
 =?us-ascii?Q?eA5TI7QMrlJe4p0FMFmvAGqZRSzGRpaCOo8bt+PgElHixpIzz29F258W/7Hp?=
 =?us-ascii?Q?5TiaomE61TFVVylWskSICkTQa5KPlnrGEp2jMdN0o0v7DQ4W+jjWJ0K4h7UL?=
 =?us-ascii?Q?MGUsXK+3xM0pLR1aP7ojsErF5ouJIu9kn4zlizidOc/nrPcG98FAPg/TMqMM?=
 =?us-ascii?Q?mGhC8Jfn+fkoB+FDivV26X4u8p+qRkUSlVnchwvAnrUpaVH6Xn0nHEnc/aED?=
 =?us-ascii?Q?R+YozYFXLTcg9ZZWr4JHGYW8wFy/hReGb8lhWfEKWn2pFRZOoIuyrM3iaFWo?=
 =?us-ascii?Q?vm0igG87utgpXrDfrrgAUPaQwD3X0GwuC+QQLpV2W24rieGo9IQNyKvyf6aN?=
 =?us-ascii?Q?FwmFMV+BMu/A+w/SFin/8GYAIguCm1DX0gTjAEK5QugtuUhiNhUrQPr/lvMY?=
 =?us-ascii?Q?3bEk3KwVRxGzVU6stbW5/wpqrWm74DMe9gYaJBsvLUX5HWIF3ckXEeM9clwd?=
 =?us-ascii?Q?PDMXEsdaRUzCWOfy+leq9923drHJK+Cutvy7O+s3N9vGv17Pns2V8efJHbLO?=
 =?us-ascii?Q?jIRjjZ5iuZQGKg7cFvpUbOghqccujNpoYyGT2mogIxXzjF93mUXP/ZBVlwXO?=
 =?us-ascii?Q?28ZIIxsSYvzNfVRX7R8NSg4nXL7tUoRJLJqcfbhhVjGIjpprB/srkSsfOlCQ?=
 =?us-ascii?Q?WL71L2sR0+uk6rRE4iQsnH7LXfZaUHA+mK4y++NfIUNrLCV6VyG0Yqcxoxau?=
 =?us-ascii?Q?4ayMjTVNOucbGWI/ZXC1sTL0ykynYcCrhtDOaGcOtA00/EWlRLRMbTGNnC4I?=
 =?us-ascii?Q?tz43VOTItEo8hgEwKLR4Xq3J1IvpVcIujAa+1+aMTwQR8XPHIhvdZKCmJavN?=
 =?us-ascii?Q?dKLh4BVzvxmMGvqJSRw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xbw0M1OidUSe1bMCwaMjPr39VwP4nGxwCovMZ1eT5AvuzGQ/uYOUd2vC6dM7?=
 =?us-ascii?Q?eVnrxxu2Oc3oD1KyvsWMBdRpASjYSxl4tKjTTL5rU99nB5ZWCJuvn0SEiS4O?=
 =?us-ascii?Q?dKUQCPvbpruneNrs39mHi4xe2B5X1fVKPyyUq+Gh7l1qVQOzH3Wqb9Paga+a?=
 =?us-ascii?Q?NClqY4beZBpFzs/iI8Q5CGrc3IU1EPM22r8SB3WxQ2HFNtxCZ/Dhlp7/Xsga?=
 =?us-ascii?Q?PrH2N1uwDAunSayKQtB89C0qwdBAk9gXiorepTcX14nlXAyu7guS2bi7oGk6?=
 =?us-ascii?Q?lUMwrPNgwhLcXxacumwH6yljpnK+NjSvW3dM0xTv4SFMCmViHlz6gkPtfwOM?=
 =?us-ascii?Q?KwkCylmAnJM0o71+ezDGgVInKdT7Uulc7w+M1sMS4wpF+/Nf/fDXHHvLGAMP?=
 =?us-ascii?Q?y3ZkJi3wPr2C+lB57+NeH7HGwEuN8H1cg5n4e6fVsziuqS0HTEbhvK1/3dwV?=
 =?us-ascii?Q?cpqAGr80OpDOsA3RWS66ZUDT+ZoUJOrX2X27ROXFSr9vUZnRxM+TWz5iNGlG?=
 =?us-ascii?Q?vUOtWHqStGq6yWSukaRevLn38GmcZXGM36Ew3CgopGMscyKIofEcdYHQdVk+?=
 =?us-ascii?Q?JO8LuervSqaoGOZoENv0yLfI2i+ZhuZVN9XPzcfQAiupFqHB3spbj1ytjd8S?=
 =?us-ascii?Q?zr2xsyyHu6azaaGWAbx+tj0sL6ptJZxhWtNTGy3dC1r1oUOZFw3EVGbb08or?=
 =?us-ascii?Q?MTvRzZToXwfZBCJ9ojVYsjDs+LpnGWCuYrOyr8mwOuYtwQK275mVt96e7X/k?=
 =?us-ascii?Q?PD6+6h2RnCRp1+ax/ChB2Ld/TRgVhhdik4x/3twHn85+/uTsWfdZpykTycaQ?=
 =?us-ascii?Q?8lcbX0Sw9cTC4sRi/LeeXdtQ+6eyKTctHtcKC72BHLAi/qlXBhsuC+mXkta1?=
 =?us-ascii?Q?GoR8kkZ7ZB4TgY4moD9PkLtDBarCg974KfhsSwx6Eexzakr08y+hauQoili7?=
 =?us-ascii?Q?9FFJofGZUCzUFhwQNW8MW3pg056q6dQWen+Y90XwJmTj5ancmU0I5AqAIu2D?=
 =?us-ascii?Q?kRK3bx5wTC4ghV6tQ4Qhno5Sc/+gVB8KFD+oN5zXc4rFWIE/Voe9U2esPanw?=
 =?us-ascii?Q?FQPYP/id8R5wq1zUSo3iePwkwkyTP5Dy1Wn7/pZL6/wC4nxVv/nIOvaCOwUj?=
 =?us-ascii?Q?nruFF3GKhvHtbdvtVbMqZBYDtlRE7VwV8vM8f1MlPbGdPwELwPHs6x+2/66q?=
 =?us-ascii?Q?gZzcrijFB8mDwjG8pbkMENzFhBfpeUXVSejzdteaXGLhA0bS4/ekCsOxF9J9?=
 =?us-ascii?Q?86HLB8aF7SfadTIIcRioO1EyjzRDV0K0yJuXEjdQbLGRqBFRmyeOErsJDy31?=
 =?us-ascii?Q?GY3Ig8y0IuMd+pFmuapjixMqfzWPY2TMkGz9VxmOhkHixjsXtQ3PiVMj3/of?=
 =?us-ascii?Q?ARl0l4Wq6sGTN761AJpbvgjrdjoABIkHsOYaIm7EQ2NUf3b0mDrmpwApMX9J?=
 =?us-ascii?Q?vx7/cf4ZBkx5eFR9yhozBN1z/6QDiF7SHQT/kawkRtooFf9dtZPmCBIbdPAs?=
 =?us-ascii?Q?EGEacnxv/dgFN+j0w6N7TyQTMlYPIENJMugPHw6p2Km0Xgv8F+KSMmZTAfVt?=
 =?us-ascii?Q?84Qkkaxnb2e8nogGGgeuuwC61c8todeKxmKX2G3ck71HdIJjwmXUXvsnOSwv?=
 =?us-ascii?Q?zoPkASAHDxGvJ/hEDpxdyshFOAmXkbnNOJKOXLtdSYEZF8WTfCgfkIxrPA7d?=
 =?us-ascii?Q?CSsTQGisyH327uhJtqDsQtkxQzCJqAyJ8Xi4Nxx5AzwH9GhQ5wbESTCvTXTT?=
 =?us-ascii?Q?p6wkNKdtVA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YiPicmQFt4g69vm+a/al3tXCNl/j1M6eSCBfp/Xcmkn4Obb3DIq33UVoaXttFRkc4Hq5QTytvOJMbcirjzM5F8y36mIe7LNx/wiQibYW1rUzG8lU8ycMfixbUQhEh48nbb3EEOsgUYjgcjr1ym6hsrGVhNjVhqZmnz6s0mCrjw4Q3QWmEuw1vPhdFTH5ZnmLMfmkJuvvYK/rM1j5OATtHoBMLa2mcB05nFJWn2HYotm5YUn1xdqnRVp6CRnNCZVBvLAATTs8tb3OL9HfO74pjpkRdd4jtmJQlTrVv1+8y1q1d3/2ASZn+1UT8z/Ab5oIO1KG27k1joHW3txmIl9JV6a0ISLgeR+K2ADUgXFi41vFRxfoENjDeL1Hn0eNPBZH9/qg51kBoepcJPnh0iku40BTu7lI9RN2bh+wQheXfTxSdPnM1YKiGUkzkjlVbOD8nZFFsn7RxfTECaIiiUdqz0rWUR1bPWUeuWfMhYvjCltEXOn2emdS5kXW9wDxsWmXAx1uOfkGCN/7XdZi6R+WvVi9Bz8tJzVtz/GqVH/dNxyYBST4V6apMz3PU2ebsZXOrIJftL16Ug0vZsj3cw2cfeBfD3YtCGAFkw+eSXjaQMc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df3634bc-d64a-46ca-a0a0-08de590e166d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:56:57.4688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jHtskPzYPippHVV2j4UvwQIXy/0n6fnCROR+7DXTlkAvqV43DPjkZeu5G9DxFDVzSbk/J/Q6yiKKQyfoUlFfdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7712
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0 adultscore=0
 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX9rNHiJGAlG6i
 uFKgidZsHeWZsgbEac2zYc/8osD/M9M/tr7X6Me8NQO3+sVTdChpTbDhhB1CnQ9bzF9Hmm6p57e
 tcxTK+Q4F45e8EszrlcxghXVyeqPpde3Xue/YsEF3HCBQvANATx0/F/70HCJBDePN15/T+AY3DZ
 EO8L5B6+PGlgSM7WiwIXvVaM8mtjp6S65kZjxLOSNBTUeUcPLrcNp+BvB5AfMQdXyBje8lUKppn
 UwR5cF4y+4bdxKzpukiaNolkRhkPXfI+uagNXSSLBW9QLPldTKj5Gi7V2yyx7lFfvH6BXBJFv/j
 5tvYtVLnp3gaAhPBzqPSgFVqNc5MZVlPwwgwWjzpHtq7MMuGrGgqr8JSg/jtg4PJhvBK2rov+tZ
 n0TxXLLk24zKS5ZN2XKgWmYMrhAJR3zun0qVZRoL62AASZ2F0UPcYDCbkmiGzeiRmWFJUhdVZHi
 8rEmAouMn+OkTcVYuP7Q6yFg6wTydK27byEK9gbA=
X-Proofpoint-GUID: 6KneKyfjjow2CUj7LSBSJmK3LR1_Rr2f
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=69710562 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=3hMZsP_xGy9I1FFZ5EkA:9 cc=ntf awl=host:13644
X-Proofpoint-ORIG-GUID: 6KneKyfjjow2CUj7LSBSJmK3LR1_Rr2f
X-Rspamd-Queue-Id: EF01914000F
X-Stat-Signature: 3mwwzzwe9mdfg5mda4oo68cfsgwwy56g
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769014636-726780
X-HE-Meta: U2FsdGVkX1/9e8EVXGWfNrIZnJ8set9Nf2QXZ5S2Nc2FNJ8HMu9p0V/3+/ZjaHrJldh1VBCk/PlCW/5POpVrvPeAD7hYpcjXj7GyYZgsh0FsFsRvS8tIQUKviSHSTliStUo1AK46W9tGoMxnpnS/gYJbPWnzjIS+V5y6gbGkaVfRajSbBSUOVbEMra4Lm27xDTniSVByd5T+4oWLML+oWrhXGzQom4ngm1NxuBcKY/zqsk3bBaKmP3yfMDGXiqlOP99y4ogqWqWA3vMJAa68bC3fCYs52og8EYS1otJ3m+i3JxsmZB5vXZ0/AIjT68vCUcBXrngY6RWYEdTGYUzTU8AC5gsdeYTxUxkMDA/Qp9atuZ4V6qw3sDpY3O8r76fyEItukOhXm6Or8olRuTlEj7Oxi9QCj28urxD1rcqSedMaddHEjLfMcTmKlsnhImwnKTE1zEpga2PU70iEkqtGqSxoLUcpDbO2q38NJ07VMq0LuI6iDWUmU/pp8oYs/eEg4KU/EGcZ718r9TG2Ju1Q5buv/5GgGnDbA8NQrABQfGxoZk7qS1yqHH5pxF1fu1vj1mbxDtQifI0FDVt4eawOJ+6A2P8OzC6kSzVv7YYEZtQWWCNPeL2g9ySL/UZx8WPN5rJp+J13cpR54J9cpk0puCPGGW5Kk1hmj1gnr4T6HTke3TlhhIpBLentaznfMlJ0dCzQEbwoPg9kbiYLktv+UfpRcxNstvVorQvLP/uSKjeC+qS5Gwe2RdJ2E3m2mtsGC6o5IjPxwGKlikmW+NIDO/wvVmgzQ+dNwfI3Dixyl7UEQTOfhNDFNcu6qwGD+JAIMx4XQzLPkU1iFHFSnm9G50TyR9c976bYQVIadLaHt1YghshXbVdP65Eu6EZOBCOQ6o0VREmMzqNXsUTE0drT9qYSe9PAhVdmxdU+6Flei2p9X0c5iMqBeo5D8EV/0GnXbz5KQCD2sqBvlymZ1rE
 DcQPc4B3
 fm6E53/aMw15R3AW5yr4nJiPL1eNUW0shSmZbD8l+v7qBlBRtK4CKLIIVn9masggKWr2Hx9DkDzBo7d32avk8o2D10zeNGfW3jigHz0htriVZp4dl04jnTHk20m9tWYB0bhK4JIPQKIWQ7uOd9ULGfk5UugrKKxPCQhr2XIBXkFqEm1IafXhXkIkmHjwudQBswqGN7pSe8ujhAIsEvMZop/b7jP5IhSxcVCvHE2lWkbmgE4J5iuCPtNrrmY/X78/D5wcSu6HimwGV+5Oe5FTer3INoiXwfUO3xZHUkLXZOsr3B9I/mGiUnVFnG42ntKh8wXfcL4sjz9IxTpJ8WRghcGZLsnxehfhaC0N9ZL365bHxA8ZMFtaXdZWdhTW8f955xI2PX4QhWyWG5eFdYqHOt7QN1gjU2hfH4kLBcHkx+C0Sq+z/o48WQcCcmLwL3dDhy6N2rElasAteqYgYqtTSouUOYD4cE4T8JnOmwIU27jDYBXdR6CUBJqE8izSeD4ypB0uVWMlzOjc5RMjcoo+kdvSmziY1IhWIsNZsmFTlx2p0eExfSLkSTu/BUgAFGytsjmhRgvxB6d8bxUlh/01pg1cgIg9CRY1vAU65EAsO0Qyy7VqNxJfOulSlp1848s7MqDpl01VAYw9IDNAd8Ptez+QCfCkDkBLFrB9gWQeuI2UQ8fy+tuBSzffkwMrjgfD9D4O9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the wr_mas instead of creating another variable on the stack.  Take
the opportunity to remove l_mas from being used anywhere but in the
maple_subtree_state.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index ab14876bebf7c..afa39bbd687c0 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2751,7 +2751,7 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char height,
-		struct ma_wr_state *l_wr_mas)
+		struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
@@ -2760,7 +2760,7 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	mas_store_b_node(wr_mas, &b_node, mast->orig_l->end);
 	/* Copy r_mas into b_node if there is anything to copy. */
 	if (mast->orig_r->max > mast->orig_r->last)
 		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
@@ -3454,7 +3454,6 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	MA_STATE(l_mas, NULL, 0, 0);
 	MA_STATE(r_mas, NULL, 0, 0);
 	MA_WR_STATE(r_wr_mas, &r_mas, wr_mas->entry);
-	MA_WR_STATE(l_wr_mas, &l_mas, wr_mas->entry);
 
 	/*
 	 * A store operation that spans multiple nodes is called a spanning
@@ -3494,25 +3493,23 @@ static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 	r_mas.last = r_mas.index = mas->last;
 
 	/* Set up left side. */
-	l_mas = *mas;
-	mas_wr_walk_index(&l_wr_mas);
+	mas_wr_walk_index(wr_mas);
 
 	if (!wr_mas->entry) {
-		mas_extend_spanning_null(&l_wr_mas, &r_wr_mas);
-		mas->offset = l_mas.offset;
-		mas->index = l_mas.index;
-		mas->last = l_mas.last = r_mas.last;
+		mas_extend_spanning_null(wr_mas, &r_wr_mas);
+		mas->last = r_mas.last;
 	}
 
 	/* expanding NULLs may make this cover the entire range */
-	if (!l_mas.index && r_mas.last == ULONG_MAX) {
+	if (!mas->index && r_mas.last == ULONG_MAX) {
 		mas_set_range(mas, 0, ULONG_MAX);
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
+	l_mas = *mas;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, wr_mas);
 }
 
 /*
-- 
2.47.3


