Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E65C7D489A3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8116B0089; Fri, 16 Jan 2026 08:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B7626B008A; Fri, 16 Jan 2026 08:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2810B6B008C; Fri, 16 Jan 2026 08:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 165F26B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:37:10 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E01671A78C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:09 +0000 (UTC)
X-FDA: 84337928178.29.5BFDA90
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8A667180004
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2hBpJ33;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OQuIyNCZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768570626; a=rsa-sha256;
	cv=pass;
	b=gXHpxWCFhSzRd0ic+vn0gaEOvf57HZeuNd8cg04TfowdYTumXfAe7iUFmmqIRuhmD1wYr0
	zjGQ2uQDAujllBXvFfU/DQ6ZMkZAihTxOJLTU6gG+dzzPIgbeZR+Ujb9Yk2NIvsomnUM67
	o3qr1N2PP3SCPvMXfQn1RD/WL2XZ0Gs=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r2hBpJ33;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=OQuIyNCZ;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=MOTcX00IrivK1iGTQkKIM0pj9ueXfocPrNw0hIuwGKU=;
	b=VqVDBY//F7BC+Tm25rrZwVrJqK/+lClTd7PQa7H8JnG+RdFVaVYXi8eXJYpGsFSHlsc+wc
	JwQmSExfMyuFkQlYkRn44UNVefyRHy77mTMAuAKNfC+oaBOpkKVbpy+H4A+reM1sYRm3r5
	sS3Q84HeL8d7kHGZWgi1tWIaxcA3DVs=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60GCoEsk1909898;
	Fri, 16 Jan 2026 13:36:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=MOTcX00IrivK1iGT
	QkKIM0pj9ueXfocPrNw0hIuwGKU=; b=r2hBpJ33StgtxGN1TUIdlukSRdbQk3lh
	HDIBMX2+kHAcFugNwpOBbohkpTkO8bbsvVYw7rR0R+w4kslJ513DL2o9CzAUsqMd
	AeJi606XrxpQ+/UPgmhkg8gdkG7kMwE1YOg2gGqrS3XlY2uNhxLiTynG2MRaDwTD
	eAnQptPeb+jgzCykm8jD72uENJNULu66DmkDWpRO1JqLY4C9s1+QkYWuCZcTozbk
	wb3MYrWNOeNvZRFHMciT0WBo/91zzEST2R5I2jQsEuXcox2Y8kohoTNL6rOwYEUi
	CTQnk6yKFRe0OYWHL3FlU8lgkG4TrrKGnX5SK5DkSa0H3Vy+j8C9NA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nt2k2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:36:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GDL0Su029434;
	Fri, 16 Jan 2026 13:36:54 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012016.outbound.protection.outlook.com [40.107.209.16])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ppbag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:36:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xX1z6xaYMM3kXXAyD+jLA5r/+3p4cSYI8Lx/IW6hiuGJsMDmqiJQnVlt0i5EBRXolglu8gG+PnO0h+CbiwHgh5paGfnQQL/WV4f2DPuY5ogkUKtXVXlXKKHDU2aC9cZgbaZFUxfrKp2BfCLoN6l+nCzIryYabN5ZQ/GX06c80bsP1OU1HuxcCf7inwSg4B7CIKlk8NruNkL4vmJ1hueVHDkan3/YGX9uKtxKloABVr2QtGGC9Zrzxy7tobgo1ckvA9kBVxBVC5g91bcGKwgTpuuBHP06gixO+qWof/vAQWnIGbIx2VjfgueMYMpc2v/dtjg24MxWf89gpSieCkissQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MOTcX00IrivK1iGTQkKIM0pj9ueXfocPrNw0hIuwGKU=;
 b=kYrMzj/VJyEUYGxSkGZSfH+SGpEnJBy8BiFkEdYW+ssaNP4DDXyvEi4Kmt2WadSpqgGQgqJkjQ1ERu/34wzCwGbfM5tqctTHlKOy+3BH6dN6c3G0DE0zJtGE6PYPFPcL6lflKH0F1O2o/L1pB7XwSPakHylZR51nA2X5LM6s8QnBVIUsD4N0HplAb/J/oBNkx7VirTDRy8UCQGkaCZi7uETkdsNODqIU25Y8qjoHVopzpiRTJg5Dg8j6GD1XL5NgQ7/kxT7bGUW9b61CxIBbolLtn+LHSSwcZwdqjkj/SVjkGxODXGgR1T5z+2gw2/BT3d8DlCPorooQTJqApKcA/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MOTcX00IrivK1iGTQkKIM0pj9ueXfocPrNw0hIuwGKU=;
 b=OQuIyNCZrmmIm+FMUse2FgHQAeUdshwX4twyCnGRIhDMatpur2Othb3wve6ZThlAeQ1i5cADwMRmEDdnWaZaUu5K8JlyUibTP5/q3aiJtcSrt0Oi69Hts3zTzVjeU2yoA/SfNy7KV/IxYDdX5+1s3gqoWa2a/y6OrD6N+3XcfDE=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB5659.namprd10.prod.outlook.com (2603:10b6:510:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 13:36:50 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 13:36:49 +0000
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
Subject: [PATCH RESEND 0/3] add and use vma_assert_stabilised() helper
Date: Fri, 16 Jan 2026 13:36:44 +0000
Message-ID: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0282.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:195::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: 6fd7673c-6846-4d9d-1181-08de55044cbc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?bIfI56tYa0OY9jrfgXsWmMphACmyHq5HnSVk+VdvAm5ZNdPwxGQHVBirBz7y?=
 =?us-ascii?Q?a3IXZwxwkiI9pUaiwWBiHdahvPHlP86HKY//qhW5YVnPGgFx+opQEcsyrLZB?=
 =?us-ascii?Q?jiOL69bSPVtloktDkj5Rc+/47oxRwVUVo+2TOD7otcGoRx9WnCppKsEfT9Fj?=
 =?us-ascii?Q?jV8WnRNfFPBCi6S1jq7KQ7gMUMRloyGuM6DBecGGCojU0tryZl9Ku9Q6glMs?=
 =?us-ascii?Q?inGaqyvoBMZhzRdL8MPUBIFfFAp68V2XpM8jckrL35qTvE7vR10gCPyLTjX4?=
 =?us-ascii?Q?ZmbkDx+RzgXFUXp3q+nX90RvQO1hw+IFuG4RDcQS5nWkU1Y1XFmHoOYSlCDJ?=
 =?us-ascii?Q?O2i5vMekjnZS+3MH3pMaG6ckCzF4FFLwUmTGc52mXiKlLURVSd75Md9Xj9Ao?=
 =?us-ascii?Q?MdqpWg5QWSKx5/IgIrYyZ5W+35EHPH7MB442/0CwMzYIUk8P9BB+K9Ac4Vue?=
 =?us-ascii?Q?uResM3MoUFXc81Kq20epMF4CIeWdDKV3MOB7bPHej5PNtArcB2+/qJqJJ1Eu?=
 =?us-ascii?Q?rmg7qCS376Au6WvljlvlMBHKNrJUoIkf/v7wwwNZZ0OwwD5Rcbe8ML1FUVOm?=
 =?us-ascii?Q?0gx1bM17po9NONJvqwjGH7ONi6Sp1zXKTq3hJzPRGHrmdEcgrQ/mia8pieit?=
 =?us-ascii?Q?61v4za7gPv5nqGMAhGaSeop7yq7JMF9sDbLPk3L0hNW7yw+LXgtzqfr/9YwX?=
 =?us-ascii?Q?EdpC0b1dmhgc/KCYOfuKuRrpLelO6btt1QCYSrzcsK7h4bYIvNZXsJeeGHRH?=
 =?us-ascii?Q?Cfeus/IXwUZVUXCSbj/WWgtYvCdLFl/9RwVciZ6OSmKa8ZJNctdzIa3ARsnY?=
 =?us-ascii?Q?L9AzksfMlbPdkm1aEvDsRDtpgejdI/K339GJaIoAhr+n6CRuIyOgwxzi0MO3?=
 =?us-ascii?Q?eLoW4QHpT+ReqIlvVOr3KMLMDXss3uHsNDobyBxzd2J4cRJFhesYiLy7ePD0?=
 =?us-ascii?Q?IHyTyV8MzAf+pfDoePi2qdnS97cA9g0YHP4+uYm9sTbGWmik6+eiaygaK9Fd?=
 =?us-ascii?Q?c0fT52KJe+wEsYQZYUM3KaQV9abA7ngSSzTXRQIYwYLjAfrDcAPr2WzqDydz?=
 =?us-ascii?Q?qUMeyDmy/lv0f4bb3T2Xfb6tqctDtlsgvzHIyD1cNQYERg63FtMScKLJBzKU?=
 =?us-ascii?Q?YZECeGn8pvIdOhOmA7SyVUXPcOFpERg5c0fEtbeNpmfBHTdh5uTMi1Yo9ac+?=
 =?us-ascii?Q?AIY71U7KJ63ExTlohpa7tNJSVbV4IKKcZIe3ibW93/UrTVbhE2Qa9QgMgnPM?=
 =?us-ascii?Q?kSOd6re9MSMnKfdLizdNR80mb1Frq4KHN0BjBYrkyMHV9g8HkPbXuV5sqHKz?=
 =?us-ascii?Q?xxGL0gkxt2qT0Qe0MfLzsD4yTqvVgerLa71urTcCRC0k+XqBr2Kxlcn7nalc?=
 =?us-ascii?Q?bzdIQZXcNvEJm/imPe5V2b6V5y/c0AMSiwLcjn3qFSPxZ8uI1SFmF+FEfGic?=
 =?us-ascii?Q?fFMtolayakdo3AeJvBmrxQllFRYkevErUYQlZCA5KE6U7WoRYAncPioxUsRo?=
 =?us-ascii?Q?4LuWiILzTdnppF0OIVOsDNGBD6LE5KvcKSFp8Kiod4vcpjhGPq3dPhvlHE3H?=
 =?us-ascii?Q?xoIQ/owJDQ4ivEp11Fk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oVwGRAEqamlbqlHhh9FhkQXbISfV+6JBJkQAN7qipPwPctwfUub7MdeTx9mi?=
 =?us-ascii?Q?ffhvFdG0VEip4Ri83LbzGG+gTbt+sY050NHV7bQT33+aLTDK+ufCTmozR96s?=
 =?us-ascii?Q?MWALfQUjMad/6jIaVZH+VjwfJ5yvhg86dPOjVBEKxL9vz+R58K/Cw/YK0jtd?=
 =?us-ascii?Q?hOMXoZ/DzmrqPiI/3NB34BbCcQdYRN6V0TPkQuPhVQcdtNhTQ9/ePfPp/JxF?=
 =?us-ascii?Q?nTRYSo12MMdwvGtkB0b7zsSzy/fcD7YW3Ck0Sb7OqLHfHqsD7u9wvF1IbIDP?=
 =?us-ascii?Q?cRuGlyL0I0sb+OnFisigwW9PAZfTQCDAaOtj7sBsMj60XdnJWN+erjeUfHAl?=
 =?us-ascii?Q?iI30JUjximwrED6bhMuqmF2aH9c8y+EZ4JkopkRb/vKwMZyypz89roW3KDqj?=
 =?us-ascii?Q?JxEVd3mc8CbsKFTpN84AnON1l4VEmiY1pGB94+l+9IM/bw+zwefhgnsRTDXE?=
 =?us-ascii?Q?e5JF47M9gphZ5P/upBxsw7BN+9CQ1e/hPr79iIK4uqaitXKGIscWS5nHSK51?=
 =?us-ascii?Q?ub1ssU/ODCJv+vLosm6Si5tZKs584oKLrqW3UZyitgpAy6Knt0ckvwEzhbYj?=
 =?us-ascii?Q?+zF2qnKgwrUGnMuSTyy8fnIF/uL763kx33T6NjJvoCn2JAUxobOmwAg2lpmf?=
 =?us-ascii?Q?heOXulCeffP2OPCiPX2V6C32oCT/wnQIV0bsmntvrf3ad+tNMjD9/fgyHaJ4?=
 =?us-ascii?Q?MAA2/9me+8/o+kjEuBrOpb1xAS/uC7CRiLpw1Zs8Aj9byCFtgR3tDjQmfKC5?=
 =?us-ascii?Q?ASU4cjBap/Ossix+LJQVEDUYHHZ8Q8Y6ViyNeY2ahfq1G0iT3xPpTqgke9pE?=
 =?us-ascii?Q?sAwm5C3TnmFMhwHzVQIgauG+Q1+BKbksDjN8OrxtYsmZWV94t/DEsyWJDptx?=
 =?us-ascii?Q?IBTuQc6UHv3kLJCymfD/5MUtWwtDEkD3H/2GuzZnNis4/J+fPtUuW4wCIqeM?=
 =?us-ascii?Q?1RBc5hUu4PCY4h/+MoEz3gelR4HKYWKsDTrIDqT2afWb5obTWFnH/STOJR+U?=
 =?us-ascii?Q?HOc3hWggXO1lWrwYgQ0r9AECVrRJv8aRLQSW7CtZSO/Z5W/ldwQoPOlluSRe?=
 =?us-ascii?Q?szFKsU76YVigGteEGIUYbL8jcLZFpm8hIQqrC253XlsCiWqGVexTgslbVO2Q?=
 =?us-ascii?Q?C8+6oUVfUCbFAyV12hc76sRcsmVVjIh3zNCd1oWnmJXJ0hB1jGXoYHMzH++3?=
 =?us-ascii?Q?l7/VYVjWQekY9jcAleb7lBTLlvmEG/MsIXQzP0uM0hmKvxmNCtixLb2NsBhl?=
 =?us-ascii?Q?foOOQFWj0Evf5BcL5bfexg9uLqJLWAasLzS1K7E2FfVbpmpGsqqt64Wn6XRh?=
 =?us-ascii?Q?SwnRZokJ1uaA/XKVblrZIJpQ/6o/k8SqXlqMYfLNeMULZ1VplGUo68nqTSCx?=
 =?us-ascii?Q?NTafG9TPZybuNsmTSBMjElLvlMhxCiqtu4sI0SBuYsgsXsWwd/x76/Qrvqr6?=
 =?us-ascii?Q?T3EJWWvHCxq5GIsUmaVEmwrOmkVVcN9pgENKmYce5W1frvUAZKqpzEAIu9Jq?=
 =?us-ascii?Q?2i3ihrtLG4RAj82QxOwqc/kPoaDBU0hW9FsT7LIGu3mYYJgSrGPf64tj9ARU?=
 =?us-ascii?Q?NHYI+AQm6XpwCYe5UJuPKKdoDO8nLdGN7XOhUXT2TQboZt4QyAWXfC8GttMV?=
 =?us-ascii?Q?mlOmWp4AfJ47AkCycWFT1I2TnHXRQmusgmvvOmsnlsulp/7B36BEnNDpXLIx?=
 =?us-ascii?Q?nYdMK24jy9SEcxZu5609x8ooMzKmIBBBkdwRNDXENmFUls2b/EbaL0XPmtK9?=
 =?us-ascii?Q?aLXXv3CGd1EwZPtlLNblxaCexheCluc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HAXQL0fTQUHpxnxEeUDx0A7RwgWmyGyT1Hv5yE1GpPrvWAcZ4et8vJTGnw8vC4Oen2IPuwftwv7fTwmLyKtk3VRH0swq9OIx88O/LQrNwkwwcttk6wdllssmPzslRkeqhdpXotxIDLjZQ62mWndVEO3Krn7jFS97lr94JTHV+2JbVqfuvNsC3JwBz3l2yqWe/NGK+YRZgjOdt2FR5DBg9NZvioJRtAl1cAulaT08okp/xRew83wNI28XVlF2R1CxteCQKHZG/gRT6ooCKzqTAzS8IUIE3SggmdszSDv80O8wBZ6Y3YzVGVAvcaoabPaMuQmlV6QnygbUIRkykxIXJT65iYpTxkHAt6HBW8RdLyDD09j6lskFvAsuy5TwgKgEj9wai60G3Wg+zfMJ6ySlULvAr5AWG/Wj1K3jcvwmds5wE/rTgr9R/LRnRrDatL7jZwbsaAL/6NO7WBHEvUaY2XdyQsKnjlrWRkAxHcEWQjvXzmyT0WBurD14sUp2+5EulyHh17HxrayfAtYLpnCtadJBw9yHks1rL85m8yDBn9CJPWlAlbJDcMY/gcnKa9zYec08XSZBXvGqAtCgjI7ejGts3Q5j9yOHn+jUN0k5Ci4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fd7673c-6846-4d9d-1181-08de55044cbc
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 13:36:48.9487
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+EndH7BaKadm7vmHh7k06L2zwK+M1MpVp/U0zlsfokRbS4LbJwrMvamzoD+F6D9dxZSkHDeGpMP4I4ZHm10/pEMSU2CsbxzgBlOPbowZeo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_05,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=726 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160095
X-Proofpoint-GUID: W20kZZsHlzYbA-EpsPfvTGyJTUNdqfuU
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=696a3ef7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=3hpcEApNCGNIUVcqPkQA:9 cc=ntf
 awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA5NiBTYWx0ZWRfXwGIChaWSoSKb
 //LVLBbMD+zLfNEVy60i4Kfj6Z0HU/J99dE4fzR9kx4h4R0WvlIqOEOZYcadZzWJHoMrQTwqy6h
 igxN/B+fxLNW4at4qwukuqYmiUbsSibefFV/G+8VoYLIJZdSd6OOWuabELF7BddcwrUAH/ArqCz
 kJRuOBNmq8NsrShBNg1NqlO5vdVfEd4xyq3wf5kVYjVrieUoKCOpiDHpG5IRefsJNBTALOzsJ2U
 HiRCiCFLm2lHIHKHBCLj7GczX5W2LnIfvmlolXNHxmBvUo2pj3dKM+uJ2VLIiFjD87xvy85+oos
 kdZ3fxe3T7zvc2gBapJFv7qRnqg7UrqzE5UW9EMgSVroHCvEbYzRiNeblId0P9UaAqJVNfpQLMK
 CIKBXPr36VIoESdGi/HnLl5zQNY6tT0bi4ZzXq9Mqu3im8bRnLAwHh8ycAKYCcPaPZciqjrlWQ6
 Gy0kWBxkWjwz+RgakzgZSZTIMg7JJNupshYn1RyU=
X-Proofpoint-ORIG-GUID: W20kZZsHlzYbA-EpsPfvTGyJTUNdqfuU
X-Rspamd-Queue-Id: 8A667180004
X-Rspamd-Server: rspam06
X-Stat-Signature: xshnrgongawsujy8o3ysg6kbhaacb4no
X-Rspam-User: 
X-HE-Tag: 1768570626-982747
X-HE-Meta: U2FsdGVkX18ckaeuiTvrjv917CoFIXY6AqZmFNV+G6WSl22IAnABpSToLGVtfHnsc6o8nVc5CTN8vbwQXWOaExoK9+IaGesc9YOF2dHp1bhyr/O6x/lDCMga433gUbo3kg3xgzzgyJgVRJ4buuw9U6ZIXwOwtLm5MHZikdbCiOFLueaabu/+O34sa2WrlDwz5mZaOdF+T7EAC79I07EuhwkUw99TGKfBElyiqUkeZ6u3mpZLZ2co5T01oORpesD858Jp1G89Ug2YhLc0PLd7R4YqT3aCz6Cz/jwcbEXIzEoJ7XB8pxFSXYlTbIUnHtjwILDyn88ChBtKSw0eD9g/FCc1pqDNX9DLSyOCzuQhwfgeO9GxFH8MOd8mN4aV5KfurKh+2/nEIZdOY1KPnvpxESEil+aK7gr1jtg2LXDkPA/0Vw0lNBY9Vl95283dd2/C1Y5klFecVrrP73+LYE6Va/9u1mto3xcg/Kcfdf67+9epqKihHhlrNfubVxde37+Ky0Q0mzRBxYNVQOpjgkH65kfxVScxhKR9YKhbev9qL5ey52kRI4UADVGdCg+QwItS985Ep0Jtsiv+ZrgB5Uzn0LXlxEfuV5zCFReNn+aDA4nxVeisyzXfrwK4AodtBphpEgshh1IaUV1DVS918PO9tsnj5AHulr5lgPqQ1TGcPoFbstZuRZB56FO0pAVbkM+jxHeQVq1D3MbTNj5ybz7JxinqSdKcO23o/5u9ZBGtapGDEqtY0Dtzl0r60ZZC+pFt1KNCGsc7IlROpHz+v06DnbI2SUU5lRVpLfHHv+wv18/grpXDXN8dRpqAOFqXmB89xgruFUeJYrVNHyh1lMWSk2VzZ6EpBAkLA68hbS7R5zDOMC7pR7Y/lbZbnDJXv5OVGES3nX9LOKPaU8iZlDdCPhhW2sUK6gRLVkKDyLvR0W31a5HwiGMvdjp5y8Jdcz/UTY/vDffpsjAOosK94cf
 jhSdDZR9
 FZM5HAykO08EboVkYKdowyXU5XImYAXyihXCeYfBKE1N2Fav2K89iDELgBKQnEL2ObdojaAGJWkuLyVc+0o9ZE2MrpyXWVZHEW/S8JTAe1nVXi5eU0FsmXMG+WV6hgnc1XxNnSkV79oXNsQ9k2kQ0p4t2pOg09pwGM9pUW3XhJAQHK++ItMh4zmdLVkeCHTHZYOVCFIJxfyc4gI9NWMxOjsg09tZmRgqIpdK8gL+RqUpxHpEfA22wekPA+btS0IYrfAW9bU1K3IK9CMUdjJCeOPecMKtVN9+7DmJZxcA9TGzetPMm8j+PJ8QpuN0ygPEtamRuPQqEsmw6rLJcfhiBWdhxWFTNXLw5bQaJzAUYcSXRSlngAhBGNN4sldTqmwznKPLDqU+GBiGAZe/MZ9dfsYpDNGkUf/LAKVstOZGjiRWaZpAVsDMe0HPkxIDBzDcY6Q7SfcyafArnP8kTpT3OIUAyvVZ/6Bxn0Xjoc+Jrpuf0nPj60ojuoxuYR53jCv8G2IA+D2irOu3PXaTwZWbseuEEJ92LHRnllwJqq2agV1dl6ZZu4u1/xdvpvqxEhwRTV6bD4TERg/51lk5Gtc3ER1ydi4a62GyvYHUbTRetv23SMusRufo9C9BFBmxh66w5s8dQ/JIhTN1wyp06udidE97Ky8+JtBGhS+e6h4AIC7AB5wK8CWEHwYhkUUs/ylMUjXZy3vC9BzruJ3jgDyBD1bjYYdbHGFx/ft9EuMAmthV6pnU82XoD7gBWnCOWCW+YgivmFCRgoLNzWl8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes we wish to assert that a VMA is stable, that is - the VMA cannot
be changed underneath us. This will be the case if EITHER the VMA lock or
the mmap lock is held.

We already open-code this in two places - anon_vma_name() in mm/madvise.c
and vma_flag_set_atomic() in include/linux/mm.h.

This series adds a number of pre-requisite predicates and adds
vma_assert_stablisied() which can be used in these callsites instead.

However the asserts implemented there subtly wrong - if CONFIG_PER_VMA_LOCK
is not implemented and the mmap lock is not held, then we don't actually
assert anything.

Since this is an assert that only fires when CONFIG_DEBUG_VM is set and the
test bots will largely be running with CONFIG_PER_VMA_LOCK set, this is
likely in practice not a real-world issue.

In any case, this series additionally fixes this issue.

As part of this change we also reduce duplication of code in VMA lock
asserts.

This change also lays the foundation for future series to add this assert
in further appropriate places to account for us now living in a world where
a VMA may be stablised by either lock.


REVIEWER NOTE: The prior-to-resend version of the series was sent with
insufficient caffeination + my having inevitably got seasonally unwell so
isn't worth looking at :) Treat this one as the only version of the series!

Lorenzo Stoakes (3):
  locking: add rwsem_is_write_locked(), update non-lockdep asserts
  mm/vma: add vma_is_*_locked() helpers
  mm: add + use vma_is_stabilised(), vma_assert_stabilised() helpers

 include/linux/mm.h        |  4 +--
 include/linux/mmap_lock.h | 65 +++++++++++++++++++++++++++++++++------
 include/linux/rwsem.h     | 20 +++++++++---
 mm/madvise.c              |  4 +--
 4 files changed, 73 insertions(+), 20 deletions(-)

--
2.52.0

