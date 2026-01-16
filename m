Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26F77D489A4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 13:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA086B008A; Fri, 16 Jan 2026 08:37:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B17A6B008C; Fri, 16 Jan 2026 08:37:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D7B56B0092; Fri, 16 Jan 2026 08:37:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54E1E6B008A
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 08:37:11 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 222F9B4825
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:11 +0000 (UTC)
X-FDA: 84337928262.12.8A7A6A8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id B04E04000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:37:07 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bcTPI7m1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lXAJjNBe;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768570627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HrRoSjFkjhff7jjCvc3wIHd09e2mFQC+m7LhhWkUeDk=;
	b=Lky8Jnv0R1On/JVgD/ol2IOYGEZDyzPOD6SShNVmesSJAyxCb7ATsgiPsSYuWHJjKSgyVX
	Gqz5yTpEgNdeq548fZCMCM0fXRTatEYV/iQNSdEQ7BoyMTvGNDBR1xPf1Z+U9lWYeFPRFf
	/GDG78K/W5rzGzx8Eq70Do2/oyqummo=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bcTPI7m1;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lXAJjNBe;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768570627; a=rsa-sha256;
	cv=pass;
	b=pNYxRLDR1859e2MmCua9AgARGfKQX719U2NQPEdjDNaNxTJQBmjMHYKhf2Svg/ZcU/6sqS
	Pe3gPdcnscmnRADmFLroFWiuVN8VcuoFPmydb1WESdlo1/TmkD0NpGZS3xSto60AQi+RQ8
	Fou2MLk5G82b2FGk0s1UuA8EOy81H2U=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60G1fd6K1971956;
	Fri, 16 Jan 2026 13:36:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HrRoSjFkjhff7jjCvc3wIHd09e2mFQC+m7LhhWkUeDk=; b=
	bcTPI7m1buxwhuV+l4HwBz5/bykgkT9md0nMOK/0z2BfYlB5HKLteB8HYApkj1sX
	DB1uBspGhg/WnEUiFkG0fXpvHfqeDx8vyN09plPAl0AaZ5jj4Nd992fsgkXQZBEi
	Q4unuSKuWXmfF2VX8NrLUPb73b716O6TJEnw9KKcHk/LpGh8suVNwcW8Z53Ds7ck
	ZGg3eRZ4xuW7PcTrqdy2WoYfmMFBwqprroiajpWCxbSIRBmZg7gFuf7pPYlCVWxr
	+V/LNg84dU8Zr82TSVLglkMy5RNH4pGNZMgoaS0XC6tw1iFVP74lK0yHgNaal7BB
	37bJumBh+k36OaQ9e91lYQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb9xhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:36:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60GDL0Sx029434;
	Fri, 16 Jan 2026 13:36:55 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012016.outbound.protection.outlook.com [40.107.209.16])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7ppbag-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 13:36:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k7Wsr3LWeGkIGYKRTXdXE6MSXtlaNyQimD9n72xtfORKUUow/lxh3iX2no+rGe+njaxSd63OXJK+i4gv9lNE63SDE98qVVkHbMu5X2HEnoB9qWrjjJ+4AgUAWdxZefbTukgGCSvFGp/oSRdyb6czZeTQBB1dOLLbGyx6WFt8jvtDn8mKTIUsoqTaAN5Y3MjcQ8HvJIZiOoVFv7gAP0j/Xmfdg4+zdiP47H9rnkng/Ux85NdIMIjX/Ihqp/3qSYh3CkY6yMwVqtQcd4QkgzIe6l1pVFDMyMw7pyBie/RbrYKkiIJHR3dR07AE3edkBRkYt0bM6j0kSCqh8RWJsOhHTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HrRoSjFkjhff7jjCvc3wIHd09e2mFQC+m7LhhWkUeDk=;
 b=MeTHvTQdkLQPLCQOJ1cI3wO5gBitlRDrjWIxg3Rl3oaRk/xTu4hRuYnFgyteuOqL1HjfBEw5peupFpGxi+dxKYUzOWjoPhqJSkvdH72ER8/cjHGxtp6zp5tRxGngMoqDisNJpBLoyAvHpRlM67kyALl29DkvhwiQxWJ2JL90B0usl5yEZye9B1WYiykqfbO4eHNn1GcYr8uT2JWgBqDJSyeuh6gDujCwXfdkZU2Lbi0O4HmxFzPzi2u9mljiE/FXW8n4bw1p93RalA/X7ZV5JGWNMsq2u0QSFUTcn1biDi9CvEnxc9sAxHwG5L2nSwWfGb+ny9Q+kVw25XvpXBU5Ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HrRoSjFkjhff7jjCvc3wIHd09e2mFQC+m7LhhWkUeDk=;
 b=lXAJjNBerK9qpUrp2KEqRCCuKXHSJ97RNYi3EeYkhm4al2fyl+Hp5S4pfxTd+kGYa2CZ/VwH6r9BxgVHkrFruKldFdmVdQD/lZSdHx1ormcDoMhgH9qQ7fOWC06b5R2ukOEgLGbw/RY/veFGUepUT9ASBoSOmfPBd0C9y6QjZD0=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by PH0PR10MB5659.namprd10.prod.outlook.com (2603:10b6:510:fe::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 13:36:51 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 13:36:51 +0000
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
Subject: [PATCH RESEND 1/3] locking: add rwsem_is_write_locked(), update non-lockdep asserts
Date: Fri, 16 Jan 2026 13:36:45 +0000
Message-ID: <8e343ccb9319433364f5949a69519f1bb521fc8a.1768569863.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
References: <cover.1768569863.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO0P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|PH0PR10MB5659:EE_
X-MS-Office365-Filtering-Correlation-Id: abe3e258-46e0-4480-24a9-08de55044ddf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HgsF2ebUy4JNbNketzCvysTtiAgCnfmn93LrXkj+RShMWOyiMOMb24E8z7W5?=
 =?us-ascii?Q?Cch+TRuM/x2M0q566dSdaNROo3Up1Sh8jiArEkTh0gVrFsvFMlR5ctQfC4Eo?=
 =?us-ascii?Q?FSnzqoR7CRRzqyJQPCsuKsACHsgXidRJlprLV+tFU87/BBXKZim0Tez52jMN?=
 =?us-ascii?Q?Y55X/FkfHmLToRC34GfK05NoDflXYEL/CLFGgAdVEaYQi651ASal5np+Qbaa?=
 =?us-ascii?Q?QLquZ8pszSgI71ixiWzQQc99EAvJ6MkbAhCyxKYBIxwdNo/aFTR8gEzDL1Yd?=
 =?us-ascii?Q?9g23c0XXaCJW06SJY/dLSCEho5iDjmbnF1PwqZyeYCp/lL99hQR2WQy3IcqF?=
 =?us-ascii?Q?McTXgPv1+uI6UpnKj0Qf4Qubg0LT0/0/+MUrwODevwOvPipNcT0NT2zfTO7v?=
 =?us-ascii?Q?XQ+J1REu+EopwMcICjTFzN6gDbpJ+CaQ28K2nLtqW+z4M8jyBWippaZ085JO?=
 =?us-ascii?Q?n9F2FVg88bqqg53/lGVRwEZkwUF4Zp9VPrkXTVEkOq3qd+D2XFs6kVDBB6NQ?=
 =?us-ascii?Q?4YjkgCNHEuB4eMzTGZ1WmdL8inAO1J5WK3qH2AMGm2XQJP9FZTPlkoSVGefv?=
 =?us-ascii?Q?MWTc5G8ZB3q3egJ5Rma4QuCD+t/CEQBYkDmCXozJeNyAGObPy9e0gDEXpRN+?=
 =?us-ascii?Q?mFPBC85dX/2UrqJ19wD5cLor6DYrbdPwkDHGXav8yqR0fc0G6Sx59ptKuMIG?=
 =?us-ascii?Q?txnp4FjpBpGbvd5g9HItzZue9zCv57Ur6y1Kjz4gCAHJjFzdgc2sdjtEj9A2?=
 =?us-ascii?Q?bkf5MFyoExKSWxrWX9DmJVDspXHNwILEM4uKzuyQYqCnfipdUI2VkKCY3nxb?=
 =?us-ascii?Q?Zj/tZWYB0/j9TXklLAerEqcjjEo9F4Ib4uRqFYyf1YdwkXIfg+ja8kXAV8JO?=
 =?us-ascii?Q?4J3eRWN79eyg437tbAwB6MiU9d6EgxY5PiLbrEzIL8IsZF0CM4EinqK5sETO?=
 =?us-ascii?Q?n2enHZJrbbhinyXZIHl8H89wT9TL7E3ynW6TVSORBSDHcJMaX8mL1SHnR5sG?=
 =?us-ascii?Q?IsLG27ZpdfjbzKZZ5pZiq7q5lFJzC1Kb/cJgvjFY4FbSBjzOXd39nuAHUZRA?=
 =?us-ascii?Q?LB1wKid7VQO7xeIEc+q1c3nELTkQ5cj+OGm5WO4gCGYM6pwNGru4JkMhyAmk?=
 =?us-ascii?Q?r2TsYxTp3q7AgHSIlJp164XS6D5S8iUYpNtPpwJCDa+dS7OigzlgLVv4oj98?=
 =?us-ascii?Q?akDYjrKtrdkiBtz21XyakF7iUiTSbhKBCScODucOfrwaKa13wYk6HH2T0JSW?=
 =?us-ascii?Q?YRPnwqY/ySUiw0X/NoGekcuT5bZbZ7z3saf6ad+K16AlV4LzQJrN2rVgLOS3?=
 =?us-ascii?Q?0QcH2M2Qf5rd6peJk0RLPzXv4p9W4dLgUKNaXjwTff9E9otSFNGMTG1jx596?=
 =?us-ascii?Q?f3c/dpY/xpyfIM+hXg+j5manhk8Bk0FvdZDHcqM/f3LWzaSVcqBzy3tea3hI?=
 =?us-ascii?Q?rendODix8MROlA8YB5tXZsS370IDV2445/lqx/GqPa2NMMRNZ4WO1pAzerqS?=
 =?us-ascii?Q?x5ZZ1/6XB6uEN/Z3Ag41J76kkO3toFB8et+UbxuGKNdQFEMMhi9uL5TBKumF?=
 =?us-ascii?Q?US6VcpRRNFEuB8+d7oo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+0Ndt2eNqCLkAqn0P2niXgcZ8rIcW3Od9PGVmQG58awb6WmYxGHtK+hMM4/Z?=
 =?us-ascii?Q?thbFx7u+2MVnQ2Pd4uhSHVva/pnPXEp7ljfUxVmSqjbmG88t4DMrvtOX6VB+?=
 =?us-ascii?Q?MDICgW6/qIZbZ4ep9sE2qf9TA7JTpldNYFJUmMlayE3fTkhx2soDvXDm0sO1?=
 =?us-ascii?Q?EggMGMDWz5zaXxOanUTrhg7lZEdc+ksmkYr1QEAcHPUTf1Jm7qTZzXv/V0He?=
 =?us-ascii?Q?KAkpjYaLaYcGPr8SF/ohAYjgq25NeWzgOP/5vFA0yHkG0SXy7L4W507JNv3M?=
 =?us-ascii?Q?7QQJQx6wdbIGF4Ttu9Z/cIQQNfrIo3RtxeqdMF0GIje8xZcm9a5vTvHce9af?=
 =?us-ascii?Q?UX1gML/y9P55p8vVJfYiKz7HHH6cNgfFXQ/ScS8Q3oj5gY1oFmIlkQnuTdWz?=
 =?us-ascii?Q?Ey6QxJ8FR574fepWTviqlO3UGNMzojbdfWyqicUghsG/vDEFT/fYc5n6W0Fq?=
 =?us-ascii?Q?3AV/bJKDVX6/MzgkGsVI8knjOchy3PH+Lst4hdiNZYgNd0lICsDetorzV7S2?=
 =?us-ascii?Q?lh/J0bNXkKI/b1irleIjsTAjciiwThLtmtc0QKuREVYuFmxk2Od7ghnUzTfr?=
 =?us-ascii?Q?b0cYA35F6i0KuA5sRdZFDI690fmtwrnnbIMZ1L2+99Q3BSXOHUpVh7YAcron?=
 =?us-ascii?Q?MiG9UtPQmlzrOr4CyUt44wRelBu/DVE2465bKUjGWg/BzJ/hBX7R3JcHY66O?=
 =?us-ascii?Q?0ZG+UIw6KHmQoyrQMyzpRyrRPSWM2n0H2FcM3uvQAF2hY0PPQasi653HR/0x?=
 =?us-ascii?Q?XrQHKXkYM6eskExjbMQX2NdGrWStz7dMWus0lP5HxZa3JIZK+xAK1j7t3wIC?=
 =?us-ascii?Q?5OY+RnZpZ7mG1/goYXINV1oQGxYnDw6s2bvuBA2qs4LPxVcTOotCX2W6T75v?=
 =?us-ascii?Q?YtVUDu8/opxgNsrmZBuSgjWflLLm4myZNq30ijRReFvJeeNwp8LSQkRfAV5N?=
 =?us-ascii?Q?fhitR+kEbngAzB4piUFNbfnd6hHvnrZ9yok5fDLENmvLmVjeGUAd8ksH3uWA?=
 =?us-ascii?Q?QQ4dqeKgIMwHKWFDPK7qcl7Oh0D0punzRzQSlO4ltPApbAIUF8cawgq3B0VV?=
 =?us-ascii?Q?Lz+GZPPXej/xD2pSzYPDQRPjUybZDaqbLqiMwBDNQCUhp2wJLCN0oBFPZSDZ?=
 =?us-ascii?Q?g+BX2R+ols0UOzPikkEQjPlfKuUQGAG34xuqiw5Y+gDd8nF2+KqLlKB4CtWX?=
 =?us-ascii?Q?UcLOBJ6giKXjW8lRhfOcshwGQUoutdz8qsSvSD7PA5QiPEgg1nA9kx+dOLf7?=
 =?us-ascii?Q?Msaj+KCH+UVTJHGv6XK20L6dL3xi7Hmiplr9TTzI/X3UjhxVA9mO9F7axchO?=
 =?us-ascii?Q?486eX3JJId8gkSqU7LTETZRDSrr7Iw4wnOufuuBT8HIz7T4J24uu293YVSmP?=
 =?us-ascii?Q?6EDSlCHWtFWcM/X5W3E0o3oN6Np3zQXYk2VI0EpBe0faJKVbSy+2a+yW6CAm?=
 =?us-ascii?Q?2p1BTFr8wCZPMjepX/KuyWJONRQb9MM/eVI5Z38ozK7VMpPsOi+ZZDAZ2vXq?=
 =?us-ascii?Q?mbtPEnrOHVzEpN7Y1/AYYZgZeQrFOwkeBdlBi/MGMRxSP7Td31D54YYVcEXl?=
 =?us-ascii?Q?xYbjz9cX+jOMQaUTlgCcMTpr+sRlEit8QH5jaIuNL+lwA5oq29mfn5wnSdvf?=
 =?us-ascii?Q?1gjDdJEcK7/J7cIzV8c655KC8F79GYuiMUQga7Kl3wv5J9UOX2uW+rqE+Epq?=
 =?us-ascii?Q?p7uRIOGYUAcyFDxchKBuv3mHga4xezm4Hz2rQ8pQBsxRQTdhSYA0OXnGVU2V?=
 =?us-ascii?Q?GPipwFg6gpIXOKXNGx25Um8j/6aPwoQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Q5AqH9Flo6EQkQHUcNvk3uCShYsqtxm/hj40wUhiNIPhOWmwP3ozZ1XzKvyNWQd8sHLnqhBxFgVA1xina2Bd1AUbqpXMuzWqe2NdsnEGwjLuiua5/oapQhyhR7MXgg2P6kIeTXoMn3OZjuKMnV1ERDT3pbTq3AgyJQL8Uie0YKipDekTNJSRt4VgqdTQwuo+D1cIfkebqIDiTc5ExXZLOKFXTdpp0IN/F8FffYH+4DG0WrOYtjFfaCDBHZBXaqFqBO55STLSdTkFyNiL5P3n/qo++PuWPP796gASdDzvOy74LlVfM0LLf4Csj13Vb8QFt9aGA+Gz5giJ4dbPcwf9vfRzCUP0eYY3jebdKVnVf2bGMTicoaNKVHaul5aORZPjTQO5OWoTcJX/In0FbPeXdiFKQ6oLEal5AF8X5DLvLt8HYo0DIUcMqEw/RQLfrLVId8b9Igso9kuZzRcWcu4IGsC0zte18KbRc1939niYEfdYTJK807zO86zyySUG0j3R2zXFGify38KIy4ueCWWu/Uiac4ZALA7zEWRanvsfRdW6tXxYgSE4oLkb5EjlwSSygbCAgBNj8N3k/T+b89aupkwkWCdTf11b3VNUUr/iDoM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe3e258-46e0-4480-24a9-08de55044ddf
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 13:36:50.9895
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LG1q9EjX0MVdf9uVD759EsdYFNTikZhuQ3Si9J0BrZmSDq4U5OUL1HmeoX2wXD6mvXj0TQ+b9vpR+ObShKKRLtSO+3UAi1JYNCvL736MTwM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5659
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_05,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160095
X-Proofpoint-GUID: 6lA6yrVXdsy53GoO6DAf4vHL-EhSvc_n
X-Proofpoint-ORIG-GUID: 6lA6yrVXdsy53GoO6DAf4vHL-EhSvc_n
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA5NiBTYWx0ZWRfX1plGMXwkCcus
 Zh0VWdT6lyYgSMkluJXgmo8yW3/Hw8HkblA3CDULiLZuoHchbMJWaQPsuqlMvTbrelsO8XpLfCz
 B+tBow1NftU6zRH0OsJlqyw3tbe5JVay1vWVTOwdEa0fw+HmUhv8Z6BiK+JZPay9Oi8I4bnxigs
 AIFBnjhlVwuPnJMalmZVlN+CWXmhvlMWr0/fKqBCn9aubxyAnZMvN5/YKQ+zueoYhPMVjDao+ks
 xuDGrMivrAaTwS0La9oUQYfPowYo/pabTB87ELFQwR5V87RuIGnpD9McA77eYgdgsGjM7dLZYg1
 2b7Pz0D5RzoGqeol4/So0UzZqoJQFOEWmMgXkRWtW9rECLBY1cCh+OXV6bkh/J7WE/wgE/XKo0U
 XJNhwWSX67KJPf8UoTjmPx3rb/7vWwXZlv0XRAE0OglGbHOfDoHYw7iNThQ35cuTVDko5pnYAGT
 OIUC6ihwjCl8tqD6jaXvTKrINtoxlvaO+9XRp8vI=
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=696a3ef8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=8lXeI3z0JR6vcHFVmzMA:9 cc=ntf awl=host:12109
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B04E04000E
X-Stat-Signature: osag9bxtgxz1bkda6b1mxxdccod3cc1f
X-HE-Tag: 1768570627-345196
X-HE-Meta: U2FsdGVkX1/ncMxaksjXbNIxEr/AsIHkpz9EyG/b1MvceXsr5uxdLa0zxtfS3EM1ZguAm65TZbHEnbGLPNyP0Gyyz2io2HCbl1HwI9zosqKYXncZLQ76CGP0WZHw8HU+3KZKgcqX96DpfQBwWxy5+H6SOT2TR6MnakxQbjWWJDVy0cXpE47YdPIs+JXCmViFJOC6W5Tg6TttKQexPPOXOPIrKCS/lw16KXr95akwOo99vqQjsSdHFw2DJZSHOowqVOngLqpG9Ps3WozaanKPhqgD7gHDvWtYdShL0r79IByrK825VmSV0XhzNoU0MAnK9gIdu28gQb2IZuQhEHkwDNrEIGXheA6pZNjVRb0egTURQmvM3X6KRsx0DQWP+79CTtUvNxcvZz6J6xpAoRGMcvCxZcWDwHQd2+DZKUFEJ7J6AQnD10eECwJqCxpw06DYFFrhNKug9N0JSQsHR7WEhN6wygrfuHBCE9yCQHm9ZYAQYcT/BTHUihgOfXdpPkTSTAGBXT9aRwwQIpbpBmyUnAmLCltzEPZ1wVYwwKJJYjyrR+lru6t9SzsrSsxwwRrNtpjZOvQBF4btcEiD4iyJrfm9/bqaUWJwJd6T/h9q6+e+zrmY11iNx8UA0S30I9Z2UGOYg+vHcINHFZ1xWJ9tBVgmIq8BPkDaZnj0LquDaUOZCbxG60IbK++MpbnXZZm+BM/6TfSItZshA51+sZ2KIQwybmd8+FaKwAb3KynPyNZsJKXxWI5OHF2EvhxSBBbmVU8+cbBwbD7HU08Z3+6zraxqwljBSiyZszEOnrT9dUpHhP1UDXHoBQqqieT5IL3Nnh9QmMedUmVdkrJNKRnuxMIrqkTTaGiFIFxkWQIlb0L7n34OiW0fpEEF/CP3ccoSqZkoE2ocUI7AM6HKin0KOR+cuUV7oPqwJX6SmU4h4xOFfCpxt4tS7g88dnXhFyiuStZnT1WX8hAvb/zBky4
 IrmNaMjX
 XYhbqEbWuTJq+BkHy2gQAv/v1cgM2azRGBlW8itFontrkmUY53EdXQulwaZJaWZDwlywR78O0gh8uPts3aIpu1pxCZRDPs0JUQx7Biqsf6rJiJxIFPPSdkvR6Ziyu7rm2W22bd+R+NJc4Ae9BICrBx78E1A/kJ8oN9kEAHD/RTxlJ4u2Uj0dg8SioFr4JA6e0fkT3oRQO6I6tYvVwuyv8laNy0qn5BtgD32Klrssstt5NrjWN0o4ftZ/yzlSbFRWdsaKn/X31fgHwl0dC2RRVMmtR42q7l3aMOruxCe9WKyMco+ijxemQc1B06pE3CbYMwMo+ZPyierhUXJd7cpdXsrskw6KpNXaY+ZbMl7A3Smj/H8KIZaZ8E4ErNzWDeZ6tK5TVbCwCYHJLOWfdbIgfX2UYo/CnBwzHEIL355zcq40AtRatnTa5sev6s9O++OjCSfJxjT3SvafogV0NnhgYzsPPLyDqp/ZaTe/7pv6gDIwd0m6eFEN1XS1CLIKrJkHbshncATNWLDNc/YW/rFiZc2T9aUubciQCwerKO2ZfP/lyzKLcf7muWalruptGxp6L7c+WUxQa3KO9WcOiAtvFBQdxi3OKWfWKEyZI9aygl9QycbRZy5m2PUfUBbMFN12Of2TcR8qarypLYN5hbzbljnliVWYYCKYRpZDmLURqHvka7+nsUbrVJ7oP1t+X44pOMk4+iqAg98bdGSEICkdjqlTN4cBJyhSGfgPpwI8kPvG2pgHbH6oPJda4gMm8DImCagzD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of adding some additional lock asserts in mm, we wish to be able to
determine if a read/write semaphore is write-locked, so add
rwsem_is_write_locked() to do the write-lock equivalent of
rwsem_is_locked().

While we're here, update rwsem_assert_[write_]held_nolockdep() to utilise
the rwsem_is_[write_]locked() helpers directly to reduce code duplication,
and also update rwsem_is_locked() to take a const rwsem and return a
boolean.

This patch also updates the CONFIG_PREEMPT_RT helpers to do the same thing
there.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/rwsem.h | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/rwsem.h b/include/linux/rwsem.h
index f1aaf676a874..b25b7944ad99 100644
--- a/include/linux/rwsem.h
+++ b/include/linux/rwsem.h
@@ -70,19 +70,24 @@ struct rw_semaphore {
 #define RWSEM_WRITER_LOCKED		(1UL << 0)
 #define __RWSEM_COUNT_INIT(name)	.count = ATOMIC_LONG_INIT(RWSEM_UNLOCKED_VALUE)

-static inline int rwsem_is_locked(struct rw_semaphore *sem)
+static inline bool rwsem_is_locked(const struct rw_semaphore *sem)
 {
 	return atomic_long_read(&sem->count) != RWSEM_UNLOCKED_VALUE;
 }

+static inline bool rwsem_is_write_locked(const struct rw_semaphore *sem)
+{
+	return atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED;
+}
+
 static inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
 {
-	WARN_ON(atomic_long_read(&sem->count) == RWSEM_UNLOCKED_VALUE);
+	WARN_ON(!rwsem_is_locked(sem));
 }

 static inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
 {
-	WARN_ON(!(atomic_long_read(&sem->count) & RWSEM_WRITER_LOCKED));
+	WARN_ON(!rwsem_is_write_locked(sem));
 }

 /* Common initializer macros and functions */
@@ -174,11 +179,16 @@ do {								\
 	__init_rwsem((sem), #sem, &__key);			\
 } while (0)

-static __always_inline int rwsem_is_locked(const struct rw_semaphore *sem)
+static __always_inline bool rwsem_is_locked(const struct rw_semaphore *sem)
 {
 	return rw_base_is_locked(&sem->rwbase);
 }

+static __always_inline bool rwsem_is_write_locked(const struct rw_semaphore *sem)
+{
+	return rw_base_is_write_locked(&sem->rwbase);
+}
+
 static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphore *sem)
 {
 	WARN_ON(!rwsem_is_locked(sem));
@@ -186,7 +196,7 @@ static __always_inline void rwsem_assert_held_nolockdep(const struct rw_semaphor

 static __always_inline void rwsem_assert_held_write_nolockdep(const struct rw_semaphore *sem)
 {
-	WARN_ON(!rw_base_is_write_locked(&sem->rwbase));
+	WARN_ON(!rwsem_is_write_locked(sem));
 }

 static __always_inline int rwsem_is_contended(struct rw_semaphore *sem)
--
2.52.0

