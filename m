Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 468FED3EE62
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:02:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0CAF6B01A4; Thu, 22 Jan 2026 08:02:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C031E6B01A6; Thu, 22 Jan 2026 08:02:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6CD6B01A5; Thu, 22 Jan 2026 08:02:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828946B01A2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:02:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CD981A031C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:40 +0000 (UTC)
X-FDA: 84359614080.07.31ABC6B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id A693310000C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OU3KZTis;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PXZcfruy;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769086956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epiW399uMP9UrhW9YvtPSyVYi6MdQHkk0nA39PwbWHM=;
	b=AOztnz2hkgb2crJv5ZfLdIBHP6RmG8VWazHR179qwI9+brRF96O1SpU6rp2e6f47l5go3T
	SLjsfI5YX7fBnKqq66oiDpvLeOhXGb3UN8QE2ISXjSAsw6cjqSU0mqgTC4u42CEDYnQ/Je
	/eYBxt5aH5uBIBJxeZq4ULfvmEsAAlw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OU3KZTis;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=PXZcfruy;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769086956; a=rsa-sha256;
	cv=pass;
	b=ZWqkjyESLB3hKuMvw51PTnuzaWXwyYWI9jIGOusYXOlsPDxRKAErVXgFVGAKB0z8tcjYHG
	jGFrz5M8VsimEl4l4uZkNXoCbEaL8RHVCc8KJAc+FFhzyB5Ia4oBbsgU5RZa8IFmpMpmp/
	0/iyL5AtmH8jV5oJf8yWAP8/fxYSSPY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60M0wk613031717;
	Thu, 22 Jan 2026 13:02:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=epiW399uMP9UrhW9YvtPSyVYi6MdQHkk0nA39PwbWHM=; b=
	OU3KZTismdKhSEMAMZbt4v1dZFlt+CwJ44y5O91zRfikl/eaDYH6+uLckvjkfAkB
	W3nhvpmVbubJfppqluDXsPsFK3iB8uLXnnG4vEcfwuMQyY2Yz944W9J2mryuGck5
	pSZfTdcjOiacIAzqzYbQ1a/LDnTpbnhG5EY4HAUjFBDoJL6n9LfARs7f1uM2Fpi5
	hg/uXNEBblrmMAjj1/z3k9dyUc0aPYgr8bLhPvhuSakCXNzK6M5ghdvdm3yOXfui
	NzrWBofpK91DLDqJ+FPGbXnZHCLXTv1yvpaAc4osJf787UQ2OssHMUv94lFHD63N
	FUHFvgHl6pXJ0Pg4n++3Wg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2ypyjfs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60MCrUcg038783;
	Thu, 22 Jan 2026 13:02:23 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013003.outbound.protection.outlook.com [40.107.201.3])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vcrwd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 Jan 2026 13:02:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gC+OfX77qyBxuDe7OJqQ9t7F0nYgY3NOvGWQFu2AdX7AA89FOrpVSsDyoJEsJmw1WnuBjxBiIM4hXy1cM7x5IGviK25glAxa6GNnaerVT0fCNDqloJwvtenzIRU2k320EP+xB3cJ0Xg9ju/MhpPYO978jE5r/VHrS0I1fUoaa2IAm+qaEI/DmLzf7tL/BFEIhb2EFfIdgVSgrqmhcibN3h6hIf9gYMtHEHaCRVVXs9o8AOY3F5/Sf864OHhbqmu20lY7tkRINCx9I8sme9ivpXcqyGwnR0kMmoHY+H3P9A5dL7EXNkdKg6JkcCR7Zyn6pg+iYrR7t8f7gu/2BpkKTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epiW399uMP9UrhW9YvtPSyVYi6MdQHkk0nA39PwbWHM=;
 b=d9K/hfZ0pKG+ZHfeY6uZIrUbwwrb/NC653G+Ez79jlQ1Fy/k4Zi1bDmTAJrsNUGicBLARLntZi2lUhrJINyQekbIxIdLotVVU2eZx5CZnlHsptUAGx9uBdY3NE8MyB5YPehE57wJekKDZvVCuP0Q66maeCayLj559Y6KR6ttDWeY5srnZBgPpPohjYKXr9WohQiLZzZbRqsfSkiH/h950uiYFQtDXBWn4fesG5L+DnfMPVnk6q7GHtYaVj3sCeNSpj0vsINGIzr1kj23go3Dbh12ZgPUIyxhkqn/FDF206xaBByYKTSC8ifNfq8He/5Ga788POCDB/1657/SQ8lNdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epiW399uMP9UrhW9YvtPSyVYi6MdQHkk0nA39PwbWHM=;
 b=PXZcfruy0sYNjaGOImUZoGp6DBy4LpsQy/oXiZF8Y+M752k+UQTgtxkbXrvG05XwGIDlJ1S1YnrkZ8kghWoCphn8Isqg4CV4g7qYtK5IjMOpsrtRnQyK7/r/2xIGYuL/tW83fnTepV0e+nSfanxNQilLPHfPmLQMX/H932a6R30=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS0PR10MB8198.namprd10.prod.outlook.com (2603:10b6:8:1f4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Thu, 22 Jan
 2026 13:02:19 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 22 Jan 2026
 13:02:19 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH RESEND v3 09/10] mm/vma: update vma_assert_locked() to use lockdep
Date: Thu, 22 Jan 2026 13:02:01 +0000
Message-ID: <fbaa0ab025c1f345e559df2b1045b223663806ef.1769086312.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0035.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::11) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS0PR10MB8198:EE_
X-MS-Office365-Filtering-Correlation-Id: 2632035a-f873-41b2-c8de-08de59b679d8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5x2Mw6vmHPeSqLmi903GCuZaYNxz8EK6+6vFt4skI+8HQS7TEnrNY2lw6iNq?=
 =?us-ascii?Q?thZMrsaoLDGz3hRnOcJEdjXVfwIc2Z4lSJqbXqwxNOz4PhWJEuzM82oq+k66?=
 =?us-ascii?Q?IxjUvPIFD6MEDyeFIrjD/DRbcagh1X8u5NERSRMzoNrB4LDCbxzwjG9/sqRX?=
 =?us-ascii?Q?ybMpMlgKH1RfPWRLr5DO5AM7ZFaqDvNKJISRG6ywkREuuqkVV9DK+1jZI8VE?=
 =?us-ascii?Q?W2ryZeKbLFg9BL3wmDhGIcg44PiwijeZI5hjU0zPwHtP1bEzgl4PtLqHnQPP?=
 =?us-ascii?Q?SRrylj6nuftYYaSRt0WFLxHv89t7krcTka3BuZXTgB5QdduV6ZGGoqKbTJ+g?=
 =?us-ascii?Q?pOl2hOxr3q2w3HMTpV4hi8k0Nlp68GYdte2VpNJnCTQYVxd4otsEH4sPreEM?=
 =?us-ascii?Q?0vGjS/8WnU4jtgw+Qr1IJdrlzbh3u3zMwisbiBCQVavOqecyzKejHhr2fR++?=
 =?us-ascii?Q?jMEdEA9VAvyr18smgjwsbqLWbwW7IjDWIGBddZnBX6aaysFh2aPXEQhLuPqn?=
 =?us-ascii?Q?DZY4xfvfjAzill+Qe9nFSRV9r89LlHNbB01P6tv3G5ADJjxI61Sfb1fKq4A4?=
 =?us-ascii?Q?NysZ7FsrKSmxBhZajJCrSpHulGatQGKqouK+n0oez8Ioa59086cGsgrL5Q81?=
 =?us-ascii?Q?lIHjCDwZ7V5jFycUxXmZLI+WCBX0ZjoFXAzgZROhkV3SVfQHinQN1uYV+ugo?=
 =?us-ascii?Q?hRkk8+ueDETNRktJYIRn6LdnG/IjKOUdr3t0jDd0DHeRDf2UF2eISkKJkI+K?=
 =?us-ascii?Q?MP/1RI9+fInU81AFxAWecJ/XGVH+CHKiPMjaGyHZZqmPAOtai0RKT3PGAD65?=
 =?us-ascii?Q?acsawe0UAtltkL2yV3un/aR7uRoczRJc0LA7Sbagnz9aixPK4SNAYcP0MNCP?=
 =?us-ascii?Q?cuQq5w0dKEFcjCnROqBdNgL4IrpuaL+9kRGb9/7Id5gtDFFZD7Bg1TUDCkzZ?=
 =?us-ascii?Q?ssHfpzV9/D36hG79oQGUBl15W7c1inC9Zstkd/0rQA/hLK+ohPcnTLI7yFCv?=
 =?us-ascii?Q?MoSCJIqYKW985BL9dHv4iI19A1qPAw3hT8jniTa1UuGc1/MG7KjdVTjCXF+0?=
 =?us-ascii?Q?AyLoJ0gTaaKhweXnFawNxQhkihX3HJhEOhMMFjDgUToBtnqIXTczWXrnLTqF?=
 =?us-ascii?Q?fAaEMp9J/KuBrJdSvZv9krhK1/JhJELBVJDUyOtNRdZPYQDtq9ikxnON8aO3?=
 =?us-ascii?Q?RDqDszuQlrYILo7JZMA50ROVSl99VDBXDrOOAJ/FNHPi0yEOkir7V9DJ+LEV?=
 =?us-ascii?Q?RgC3tfahukQQvH5anfC3xmNSYs4ke8b4wI35fauh1l611CSk6sfM4mSJrHFA?=
 =?us-ascii?Q?w5Mu9QwygCX6uKBhMbqi7VGIFE9FxtbwGeHad9YMBQfpQI3G1QBrPp+RU/1h?=
 =?us-ascii?Q?u+tXOnbP9sIH2KxtkvI37f1lifMIfAkbuPN/qaG73UZTPxZ6sfwnH5N9yG8Y?=
 =?us-ascii?Q?v3bfWfldEvsJKmO9QTdB4oNqs3mXbeyOPwylXf8KiwHEl8aJSKG3Oo094dCE?=
 =?us-ascii?Q?jCkUG7qoEKorKbH4LCM02PkrLE+cF1t4TRf7zEatexJjTynppOa+L5wkf1jS?=
 =?us-ascii?Q?kywfxbc1QEcwWfg161o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?IVvYASPSv1mz8rP62nvEH1/8RZxkX4C9NUdyh/DUlhuBQuuh6A9xNk/pme3D?=
 =?us-ascii?Q?q2O2+CmUFWbAj08W6gFmxyQVIuJowcMhkiKrBGmn/zEvIl1gb4rM1aejc1T3?=
 =?us-ascii?Q?BdV/0/NPl7niBpcVZUsNfvdzfcc4laeLsc8WgDtqcb76+EV35WAGMA8IiSiX?=
 =?us-ascii?Q?mrll7yRgxf6QHLTc74dcHZB8gxnzzWHzYoEPf/CJoGd6Idb3eXtrqa5EIu+Q?=
 =?us-ascii?Q?UtWKlg+XjtZbBVmqqcDaVcXx+pjPpbHRmBCHGOncxYMSx4V0adfn9b/UXXMs?=
 =?us-ascii?Q?6lOVSWaXvluKrtJ7/M1ZpqxupwnX8XUweGlGq/NV3PdumvAw9JXSYq8BKy1D?=
 =?us-ascii?Q?Rz/61nRt6DMNmbAXI3mLSkhEClOxb6miUWUYuzCtlfgHH0o9FidcgNHDMMuD?=
 =?us-ascii?Q?VJsMkL3yKRcFF74cXzI9fIHLeAJvmMYE78A8GHMePLTGjYSD/e/GEslJaML2?=
 =?us-ascii?Q?fQ6DT5TDMbuS/lUh+EH+skEn6Z7rgDeH6YPA5zzHXVjShS0HE9JUKOYEmAhP?=
 =?us-ascii?Q?8rJKWn9WCINO78TDPjF4RurEBOvup5rDQOe1uB1I1MzsQ2Qc9ygKvRFp52z+?=
 =?us-ascii?Q?ZVEPpQpkEhfWGn8hScxGIQNpmHXfCG5oawYDcHEjPM/Wmn2fnaGrJ6kAIkFQ?=
 =?us-ascii?Q?Qih3qYBolUda1GzB+rJwCCV3nROGN3JDVflt6y4wy/e/u/1YI79N2OY2EAzV?=
 =?us-ascii?Q?9dAa+rA8VhWlr0uYlbDtOnLmNl/VJj+jMcWUX2KOQwXHNAHczP3iNhuD0Eau?=
 =?us-ascii?Q?NmnNN5FkoeHzeuV9TAkormf+D8odr29//fq2dIDHlaQXDxOSBKRIKuLgmips?=
 =?us-ascii?Q?qE/XxnpMMvDXEjz28wamzps72Ar5vZYEgxpF3L4jO1vJanVSsnFPa1njOjFE?=
 =?us-ascii?Q?prMKYr4TJQ85w0PDPzo5pCw4G2qkXiqMohu05zAAxnxUOPRaGY9XODWZqQSM?=
 =?us-ascii?Q?7t8LOg8An6Jq+5znI9Nh64bqo7rBbV+VrMTpt0z7ccvirPK/+vkZKj6exk+K?=
 =?us-ascii?Q?U9FLZLSWClQLditpKwidnB/N+HraMTmvrq3g2aFNFt2jMXP/0nla6rpcad7J?=
 =?us-ascii?Q?8/WvSimYkueMlMb9Xv5Fm/GzUf+PsmIaCpuxH+WC7ZBv2Si73UdeF/B1XK0B?=
 =?us-ascii?Q?9hjCiwLFGopvjVuz15a1FNWJLGJUKKkcTlT3tIf1nThq9UcmC3799+SoYuIu?=
 =?us-ascii?Q?uMht17s3oDhmbZRqRjs2Ms87L1/pqVx58m6YzkzEnkGF5aeZFHyKsWGTGRLh?=
 =?us-ascii?Q?y/LPE12aTK/MDsSGnUNdG4xJXZ03sCsTY+Y9O/6oauz/v8JrXlvjczudf2E5?=
 =?us-ascii?Q?03EEbbjMWB2JbZDlqM6IpFAUwhM8jMZYq1pUsEHSVLQwSTN+K6kESjqNUM37?=
 =?us-ascii?Q?nBRQn4+a7LT7wr3HlriXVV1dTfCLcU+0jvf7CPR8lNIBQaXiqL3IDouDLkfA?=
 =?us-ascii?Q?G5RqVdEYIxzIHXuRi3GxKKW/j+VsRMfl7XSxYcscawRffxaFq7CSzYQywQ9j?=
 =?us-ascii?Q?IuAygWffRHGdvnc5ntR57QQqPtylGhaZLhsb80Gl+lvRARcsb52pNnu5IdgM?=
 =?us-ascii?Q?Dqft7rm22PiLDw5Re6PI0UxANPQ28v7XYXW9VNb4lvOOr2rLAv6768426HK8?=
 =?us-ascii?Q?wijboe2bROquKM7Yh8Su11zf0dcVYQplXuTfXmRSJW7R5UBElYW5y5lejCjn?=
 =?us-ascii?Q?hzGVfszVnaEEH8lfczVNFJkhvjaUyXqEmeHMRLcth/FSsSsMz0hYjI5whZ12?=
 =?us-ascii?Q?/oo62INFtxAtTv976Y75yZz7jisjdeg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	KYJELRsazWAlvSJQJyB9UqG9+Z7U9nlNMd+Oj9vYkREZClRq/I3x3Ua4wG6/FM/DSHDdCS+3bzQHVeA/9GyvOcV6805wLGsXjJTgnkyvg/z9nR60vhzNdA71/fo6HlgEalpeCfeQARzT+RrML1THaTxN2peimyN5iObnESiYEjbkdd5qeXrUMPg72AHKzuAxOB4zaDH76mfzxJEiE9NSGnpKBLZd+T2w/dnXwMbVG+VrVWq0RsrcVW5OrJ+4+Wry/6F1DQm1mzm3i0bbXKqSAUhPvHPr9MGukfu3WBBNGyTQNR+kXGG+kgDIgRtWWNWZxspVwx+VfjGjT8mK+/IUK2RlANwbvrP2oEQ+NZSc5A1F8yX7PyVoLvP8rdB1QJEbXrFNoGqnCARbfVGnCeh5o4l0l065uRy3kpiTLi7TrkDiS3Np1vaIsuxEfYsoMKo9zay1gbRAtXFx+wJfA3pLBNQP2K79ewLn371Ovu39/ViuvobcB5Iq+6muGiLiDDd+W4zXSXpg7ufdzJC4UaVFx9TBkZOuV+76DrTpk7qPrdl4kTf0YLpeH7nWPwGH9PuyT1fnWRA+kn8uAGecVMGbg0BVUloocGuevPtg0tqinRc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2632035a-f873-41b2-c8de-08de59b679d8
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jan 2026 13:02:19.7422
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Mjp2yiUXr9psNyQPUZS8AV/1j7UuFjkFoSTRi+ZzdPztu+A0zBBoJgBFITCNT/5iYAh/9bQnsfgL2Zpx2QbhkKg96EHVioGnRwnwmAZbWDE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8198
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-22_01,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 malwarescore=0 adultscore=0 mlxlogscore=999 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601220097
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIyMDA5NiBTYWx0ZWRfX+6aUfpqUaDdG
 WS+m3z4TXv37S6eT+bpH6LYDpATfklrj2GaDPliuw2IdGgw45FsHj38io+f4+pl/dzk3dhGAOIl
 dXbhtviOaJvig+f9hcNwExMgI43XuDwhmiNuQi6uyYlkUoTCm8WEonbjkPvLhRugjAybs9ake+V
 IG08Jp76J7XmaLA/KjWeRClFcq6uTll7mI2AjLzzQalhIc2lWr8ghVqTSqVgAWcNn+QQRWMr5Sk
 CtAnh7v224+cSb9YwzClOY8lShZTeNBNsqPcuS4iDVKYRII/VHJnN3J6c/MtAbDcNH1tXVzsqlv
 dHC0HyjlkV15EB6m5BwHDr974O4DiMaUmygn1SEc0fJlcFrqAfriJPCwdxiF8lDSV1ZjXsMKEj0
 HdqhzkrxTL3o65WrX8tUD9PZOAe4nyM3t206Ix8fh5IWF9Z8SftJ/qEEXj7RI4Vw1ci5WEv4Znt
 Xk9MhnauDSNWAFpSMJQ==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=69721fdf b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=UGbfwpFX44Y6iY_wFi8A:9
X-Proofpoint-ORIG-GUID: I01NnlHAF5Kk5a8SUQaQlCQ59gnsFUg-
X-Proofpoint-GUID: I01NnlHAF5Kk5a8SUQaQlCQ59gnsFUg-
X-Rspamd-Server: rspam11
X-Stat-Signature: hsg94cebwitn6ets5x91p1aksjwuedxi
X-Rspam-User: 
X-Rspamd-Queue-Id: A693310000C
X-HE-Tag: 1769086956-579343
X-HE-Meta: U2FsdGVkX1+FyK5UGJRPuMP+TZJSOf+oiBktnJxbOUGVCAFwNKzFC7rKf2b2lec78pEJK87ek4jgCJ66ETVQDFy31LATUZAFaDIfpjzRbPJpXe2D2JwevxiEl6wBhKYgQR7d+D2fxxP/MkNIozF4LmfweLmYQ24elF7ZHtsUH6baIeHK3btX+bkM48vQBPf2H7U8/weiDjfwVllOYdKESUsy75sTGojRFTNiEKBgYX0gZzNqEuB58UfdzhgEE6nfF0Je0YEcz473SU2oBCvl1jYEd7jPdxRWM1aEY/fjEbByq/CFc/OhXajmif2H7vkTF5xg9aWsMSfzcqwcaAQUZnwfIQiwYX2PFCObSxilaeK6XCZrReMFuFNvxhUXWKYhm50WkXfghyAMkVaFSQnYfRZsY7Z2Eca/dPHLP5pSZoxyKAsBVkrF/IKrLqFIDJOezBFTyyqge+yDduAoFV9QNdjbi4tXAL/RUyoYX7X7/DjAy8EnbJeryCgsYuShfmrgjdelSoEVYE1d3bqQoDmZSieRAdqbn54XUu1Ed1etz1HspwroK6kh4zgRIFHIWLUPre74ErSH337W6Se76Alotr9ElqhJmvNT42X5OX+vAJyXXPSxkEGmm+SkjetxkgfQ1iDIKtuUrDMuXWI7/TYHBrsglDaB/2AQ5ZgGHy+GqDFF3g7HAZxBecr0VrN0zgHA6crn6qYw1MhDP1RjBJq3Zl/1b5fbvPFsNwHJGmS/tc6aGYejWr7iP7D0DXJL2Ik3/OEeSpwW16Ap2CWSt+FMPt8JsJZPTrqiYKPZXrg3+jpT+IRaWN5O0RmYeMb57pzC2aIvFaeplKI53w1VHpXfs9DEcjvwArs9orNI2N3Uhl8kxOEXLsu+p3ofFTYw71+dTe+OlVcDU0JoCqVLRivyfR4tgTUT5kc0fHJV4RLI8eJrg9yDtT+iIAaXqwcK6GUSild47yzNytnCMGknIqb
 m8l72KJw
 p7I1m1Y92bd7WHeHOCloytRq5o6RCc9WFD7LSqdpW/CyGS63LNFSpJRvOh6JzAzbwTY6fQUsphh5uX636SbAN01mx5YNxt9lIf7tGzsebFnTXoEB82L3W6PF5qjYCm6FvwC7CNvqJr1oca/pTqrI3haV9Ebk0Ocu9p2ugucBVa/GqXuE0iH944JwHuXaNSgxDxJyifTm96GF7erX19bT97L6jlg0pGFsNCJFuCmbOiIE90QmgxK5ZWwgPVfo+S9zfOkGhWaHH8ws7CTlGMyJ1zO3fW5ebnK6BK+Yw0ffV+aZgEDmUdyOMI5ekEm63qdYr8I+QjbYWVkURf2EHc8y3b5p4gUE64KscEj4fq1UcKaEuDYpUQ4LeHYNJrn1b66r/f6sWvTjE0kqy/LGSbas2BmHS9ip1FbJI6r1uiXXcxlkxlNjc+j8fFQDXGw50az0gPXKBXxaiS/KahKyMYKaH/ZDJeY6JPrehumUOPOTTYpEpbM3h00HFtWnG+fqPjseks6+c4Knyb3VHAd+z11eqWIvA9aUyphLq2F23GyvanKASf5E48Ar4JOhBNziyg4QKqW3stgwtpuWJWdtvmPTRnoli55EmCX8HhppcfxLyGZfhu9pDjDYAjklhE1R+wWkWsXORFgLC4uitx+HARqV9BB6GFfYFC+efdd/EtXBZrVf6+i/Pudh6/tihxVxQ2XJC69uUV4BKQ5V0gVzVk+MBb0HYJCSYDGaLC82ZPeP0+ZcSxgXJPsrLJ20DvekC54y2gUoP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We can use lockdep to avoid unnecessary work here, otherwise update the
code to logically evaluate all pertinent cases and share code with
vma_assert_write_locked().

Make it clear here that we treat the VMA being detached at this point as a
bug, this was only implicit before.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 42 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index b00d34b5ad10..92ea07f0da4e 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -319,6 +319,10 @@ int vma_start_write_killable(struct vm_area_struct *vma)
 	return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
 }

+/**
+ * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
+ * @vma: The VMA to assert.
+ */
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 {
 	unsigned int mm_lock_seq;
@@ -326,16 +330,48 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 	VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
 }

+/**
+ * vma_assert_locked() - assert that @vma holds either a VMA read or a VMA write
+ * lock and is not detached.
+ * @vma: The VMA to assert.
+ */
 static inline void vma_assert_locked(struct vm_area_struct *vma)
 {
-	unsigned int mm_lock_seq;
+	unsigned int refs;

 	/*
 	 * See the comment describing the vm_area_struct->vm_refcnt field for
 	 * details of possible refcnt values.
 	 */
-	VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <= 1 &&
-		      !__is_vma_write_locked(vma, &mm_lock_seq), vma);
+
+	/*
+	 * If read-locked or currently excluding readers, then the VMA is
+	 * locked.
+	 */
+#ifdef CONFIG_LOCKDEP
+	if (lock_is_held(&vma->vmlock_dep_map))
+		return;
+#endif
+
+	refs = refcount_read(&vma->vm_refcnt);
+
+	/*
+	 * In this case we're either read-locked, write-locked with temporary
+	 * readers, or in the midst of excluding readers, all of which means
+	 * we're locked.
+	 */
+	if (refs > 1)
+		return;
+
+	/* It is a bug for the VMA to be detached here. */
+	VM_BUG_ON_VMA(!refs, vma);
+
+	/*
+	 * OK, the VMA has a reference count of 1 which means it is either
+	 * unlocked and attached or write-locked, so assert that it is
+	 * write-locked.
+	 */
+	vma_assert_write_locked(vma);
 }

 static inline bool vma_is_attached(struct vm_area_struct *vma)
--
2.52.0

