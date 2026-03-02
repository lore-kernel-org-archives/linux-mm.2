Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E56EA4E22
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:25:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39FE6B0096; Mon,  2 Mar 2026 10:25:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11566B0098; Mon,  2 Mar 2026 10:25:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2BB6B0099; Mon,  2 Mar 2026 10:25:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8849A6B0096
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:25:39 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3228A1601B7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:25:39 +0000 (UTC)
X-FDA: 84501497598.08.39CE604
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7FECA2000C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:25:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eLSQ5iWK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="uJf/FZiN";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772465135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LeQer900DaREbQuJR8TRJLVt+VDBieTDy4p7RWpMOXQ=;
	b=gU8Y16+pfpiItkgjY7J9is4PExZBz85Sryoezbc4qBiN7zcmuuWle9DOS1IC4KbMoeshk+
	uZdmDGtAiz1VQ54ipzgd1eTv9nIECfNMhKxHgOf8f0y1JYEcdtx66jiPylmaIK5nddfkxo
	7c4lWX6H84AeaDHGZd0ao7B302eNypA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772465135; a=rsa-sha256;
	cv=pass;
	b=L/lN+E1avCVTN3cLINxBKJy5+ORH59jj/nyHKMWBNriKdOkPSPiKsCIPHVzmCL+QfwToYg
	lxFjpi4qUQBcZVBKFvIVhE7PDbgrN/mDAqKEJwbK6r8H2V/hOvxrcdkKo5SiS+QzJjpnKc
	IyOpCsKeSBcj38KNEK8dB4kKXx94Ke4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=eLSQ5iWK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="uJf/FZiN";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 622EWobp1250166;
	Mon, 2 Mar 2026 15:25:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LeQer900DaREbQuJR8
	TRJLVt+VDBieTDy4p7RWpMOXQ=; b=eLSQ5iWKC4BzMSJa2NQOBwXhneewGjno33
	JUoQ32BjChpfcZkd3lb4r6zSMEDsl/vFAgjCXD3tfIydfC9YpsDn3KY0vQ0X9GKM
	F3pDfqHMVlWy7xdXq5hsvNEe8lJn2U9j3IdFSAHrk4iOCWmhSNJFVpzaHLhJA2Fs
	dI6DoaO4ql4rZ3HT9sISVDsYW1y9I60ckl8nsw0PbiAiWailnFi0k5G3jr2z2aIi
	BCavfPJ+gOgbY3j357AieMM1G1hcUXOaur2QMcLhmOXSi9GyUa7nvTApDifiNabU
	NvdX8N2S1H6wByPRLUF05gxXrnOttVuQ94tXB0tqtnWjyfhhRdbQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cncdc0304-4
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:25:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 622E1Con035398;
	Mon, 2 Mar 2026 15:19:33 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011068.outbound.protection.outlook.com [52.101.62.68])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ckptd30qv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Mar 2026 15:19:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CSddOaeGtxOFW57ELesOq73KFWdSY7fl+lFSDBQy/+FArlB2AZZWIWac7YaG7SSAT5Rrwp3ugF5w9s/3FB/gMQPS9Z+5uqYCqKT+6FfgelIjnrb1IxOMjs5xaW4JeDaZDvxeLtB27GGCNsBIgnsZLxcFqWFAufirvl7Ey5OLjYr7smZZm0q0d2aFbaCQrDgBxP9uS6zlIL1LvblYJI3ks1mHL+DlUZlcS/+yQp97qlFVt+K/fAEHEP7rkHP0IgZ5kmR//8HzcbR/T5TUDOLVMX+3754rLO0L1CHkmFdLIJVZOGN78+jM/XKAuojga89iDzK6gpLUZGLYY6BS+k9GOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LeQer900DaREbQuJR8TRJLVt+VDBieTDy4p7RWpMOXQ=;
 b=Y/dhZopZBD1/iB+R7dAwwcEZ9nO9OGJeBs48a1oizePy4ez94OyEP/cG/R+D8DqZD703b7pUtaZE9+gOwuQXrdRKwQBD3kBNnCdcNlEbhSTg0FzO993PIIEi1GTxbLLBe0ywRPbTRmp9NYRUmTm/DYQ4auTTW5w0kOTGdGkH6PLBE+o3i7uHaLfKXBJx0UeR98WlSgLCp2Q/XW0hGUuUc7GDO+qz7mOjYjZMc2Zv9L51H+f6Ptjhf2cX/rEmUpO4JLHi4k+L0ODkw2P9gIjzt+/cNpY6gLyRmObF/h0bP9ZojiDRyKKn7LM3PtFVokCV+jf4Rcyw6KDs5jKbnjv9YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LeQer900DaREbQuJR8TRJLVt+VDBieTDy4p7RWpMOXQ=;
 b=uJf/FZiNvaVysjwyTWIL0MjykUnsK28LwY+27thr1hbaK33MIYhU7qVA3BaeWF7f/2XCciWYo8A9SM6y8km+8KsblNBe10RAjNJJjX2VZnwXD4r8A/HZDrzPJoGRDdSnzil04svDsm9aSqUsbGlnCf35C4xk6GmaWXrMnaXTaq4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB4943.namprd10.prod.outlook.com (2603:10b6:5:3ac::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.21; Mon, 2 Mar
 2026 15:19:29 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%4]) with mapi id 15.20.9632.010; Mon, 2 Mar 2026
 15:19:29 +0000
Date: Mon, 2 Mar 2026 15:19:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org,
        ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
        rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
        ying.huang@linux.alibaba.com, apopple@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz,
        jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de,
        kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com,
        mpe@ellerman.id.au, chleroy@kernel.org, borntraeger@linux.ibm.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <72ff2fc0-07fe-4964-9a1e-eccf8c7ed6a7@lucifer.local>
References: <20260226070609.3072570-1-surenb@google.com>
 <20260226070609.3072570-4-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226070609.3072570-4-surenb@google.com>
X-ClientProxiedBy: AM6P191CA0062.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:209:7f::39) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB4943:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b3e26ec-1a4f-4541-abf9-08de786f18ff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	Ou+V1pno7jOHAUJk20QkBNoaAOtSfIYtBEHmNdT6ubJe6yE/w8GoW4NvnTCvTErm/JbreM95TxuS0VGu4aJMb8I8aDyyHPTy6A+Bua0BNDktO2YczSYX7Xmknr661EvYZiBFuSoYzx7VzvPuSKCYdzPtr5UBFvDjOYqI6fFuhaNum+kk51yHQ4KqTGW/KnPR5zS8GS6p7KVDO6jbfDi9iAqjxzb0aVl7JfP5ILLxXEy9tKugIMvBStODTDyCHa7TAQ/oFsZEptMQA+uewGKm0YdMMG0L/VWwmfWGdce/Zo/pmZ7VXbF86oyBagNejRANpFubuIbB4htst+AdoXRucSfy9EDOEyp7ZOcGFI6ifz3UUaDAXj6b0sPpMy6M19EDCwoD5TCtJcBIIuU+/hEFD49OkUg4Vvjhmw3MZ3KYbU+Pf9y856H5KNJBNKQFV10QKni+UwQZIHPXK76JOZsmPddkJJyfq64auAyn+vxjZAJpnvk1O9UNEKcinIrkX7+aFw+e3CnyuG7qXAvPbBMXwVpqv2B2n6bebxE88sgfcX1cpJfRnT1PFnFRSLaC2kHyoM1BYQbFlS/x0IwgyPqtnTp2qjet30gQ3z3BUr5VBGRoubRH+YQ+L5UhcrbEmPvst+bIwfERHN0jE8fLeC6uH0zCa8FDIY6FYyJi+9PsscxVi0UXPzKn1N67HKpiTzguTzQDceJS9PHgbLgu26kU/GW3D4lCXKtQnSN8VirW5sM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TJKjmz+O3ocfk703QhwrmXnLipX1dpet22vVgXKcI73AKKnPDAvj4LwX/nJu?=
 =?us-ascii?Q?dDkQONDUMbN/vSAkVOkTSX8/ER+o38tTcb5KyPzOlhqRrL8HabdptlmH+/G5?=
 =?us-ascii?Q?0P0TPnRTROp6Wwtl4gg21Ep++36MbWVsET97gnqbJSWFTb78jOvN7By737mO?=
 =?us-ascii?Q?Orw+eyGo6V6viuUCuVt5gosw08NpPKLoCD3z1nxkZSxc4HQQ1XH4leHgFU6g?=
 =?us-ascii?Q?5HK07eJtCgiU9gZL+8s+MiQGyaC4DgQlY2HxhhLTJ4j0JKmRDWvLenSb192J?=
 =?us-ascii?Q?DKFvd4vAjMcuLd98dMptl27M78iy94Pa0OLkwhl9VyOmTMw+EA3+y9pP4WPt?=
 =?us-ascii?Q?A9MtVeOmmdg3AsUqIWqfJgYCv944pxWSILnFDaMYgCXXqfFhllwWtCBtR9nD?=
 =?us-ascii?Q?+hsB70SKb8E2keqPpx7FuelSLPxqIdcUBmjkLUSfEP97DAmTajMdFI1qY368?=
 =?us-ascii?Q?AuWJOopPC0FQSFXxnozX0qbDPw5gYYMKL1PxmEZD+3VqWtnYvolQ7f1NGcHj?=
 =?us-ascii?Q?jwH921OP+M6/QcOPQyqhSJeLmTEU5/RU+hncaYW+Zg6TzkeEAeLlWIAZSNQv?=
 =?us-ascii?Q?cLdTAN5hsu9CLdzA0iRZMW1IgnfIZzqPV6EWF3OIPiLOvHl3jtQRUj4errk/?=
 =?us-ascii?Q?7YPPHB2DohjdGuygRUSTPqpP2wYlMDkVRiRf1Vv8b4l5xUFg43PxRU4m0fMZ?=
 =?us-ascii?Q?byzBin90b4yc+zcw1QJpIPtyWfRklUdQ8xQjylMzewQFWyfl+0v6QDtfa0SS?=
 =?us-ascii?Q?Kw9vliGnnF5/gUVSjeMa5QaGtycmL/2m4/0OzXPff9OnoRhdlRDQY5pNpAn4?=
 =?us-ascii?Q?ctYofMZFXTZjg2Ck1RtqI4VRltit8AV25I/0pzDQhZuWwxcSfgCYjQ5O6jbV?=
 =?us-ascii?Q?T+eXakP2OqCPD9nbMVOOmQk74yazjSxnYqgaxgW/ZSC8gQEJVtK731X577wY?=
 =?us-ascii?Q?TQZxXgqkJddqXwna+xPcIlVqJAXMAwmX2ehTv7JUfkjOb9o9NniIImdfdNht?=
 =?us-ascii?Q?Ja9EyFsCFpJj43QLugmfqn7dbefNVfnywPjDeGVLgv8//X/yI4stkAxGtBpV?=
 =?us-ascii?Q?RDIl2qZompoub/OhhQGfOM/HmGIZI+kAD+ZLVFQ5Brw+it3W5g4zE6YbGn8I?=
 =?us-ascii?Q?cmUk2de1t7TTkB20YQumRxKALy7DhZlYepTTUsAhhHAdVHYyOeyb7cVivVXJ?=
 =?us-ascii?Q?GIcBN3GEMAUQrKpDe+xEa6H+UzCWzDyoWMxDlqvXhbU5663NK3ZGgUUkbAGY?=
 =?us-ascii?Q?RuvSkPcWpRKxBMj+k9VTKf8qRHQmwCeYQEPFNAdKjx4krmHvU3qgMPzmc0X3?=
 =?us-ascii?Q?D/piTDol3o0GTZB0Gv9iIwnXDy49Q7PeYPpLev3HEulp27S/7Qk/1RaeWqF5?=
 =?us-ascii?Q?DIhGOnmlAzOlSDEQuerQowc/tJUOFI4SUiddNVnOTvbKqW5KHmDDqmFQc6w4?=
 =?us-ascii?Q?pmC9No/VT6gl4Ql0gJf2gN0VAqLhHBClqWfwDpmS3HyPIJLPYvkrj44ZzNKQ?=
 =?us-ascii?Q?R7TvBY7yPEEb+C+XG7eJQD/PULzLIOsth1wmKp33R5UePYYbscmjhjG2+ADC?=
 =?us-ascii?Q?w1abolGZyrDZ25MknkshILmeRjEFAN1ojJDil6cWiFu1M0VeTeX0ozOhyABC?=
 =?us-ascii?Q?JC7LhcBZBXZ/Rf6t8k/b3dRKnxZP3dH1+eOLStErmbLbA3piJPTT4/DT9BvH?=
 =?us-ascii?Q?yLmrD2fIrlJQqmhSUNwwKk4CrUuzGJeWCNd0cXDg75AbMXjqvKqOm1EyoVsj?=
 =?us-ascii?Q?QUnsvuS9GC8RL2h8ffbSCf+/o7GsS0E=3D?=
X-Exchange-RoutingPolicyChecked:
	p1cXQo5wDLlU/LeQ0Jjv1E52pLLeJk+aVxgKm/7dhMofX+qtK+nvl87tzIskVwgtpzR2UJLeQbogkr0x23jSxlS2WxBUwnyewdYJtg7E9wvP8xoVyPkEQ3gme2mvuWM+XgsdjYZ8I/lSBJWmPgeunULCL+GQ2iXYr/YaCPgRwIFr4XqDIYxTleiHGTzl7eFfMqZbfyS/sstGHY//yhzXMXxLqCqZxNaFg17Cj3i4aXHxpLkDj6BlDm8ajQNL/whoxlYs1jRpWpo5agg3k7bSeiX6kF5n2KhChrlCBg0c5tJrvmgHCGdiJv3w7eS4NTyfSMJXU4BEKzeg3H2xGnHPtQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	COm2yThpGv/P39S4PsmkjIg3BDmnUdv9gTc0m3jPOy1HiIt7hRFjzj6XtSzzJ7b0gZul4nFcUn8jxdnWoddUcpkjB5WXRgrKZUPQzgww2ynLlNFwULUBhbG2ZG8LvWLPdNe22OruEVRSRimqICp824aRLwXzLQYm7ljLJ/uiapYhigT/IGpcK669SuW4gB/dl4UnCscdQYHAy+eiVeV6B/dKR9eUfjyFk3uXmQNbCF81LtWg8PiGH6LOgcUWAAvxOR/kqX1AOUooAQc/x73l+IYSukNCmZ7VaTimKybUoj5GEasrqzQKw5KV5cRCLPIslySziHvVwXKGI/ajETf7bfzOb5afUn9q0duIf0EYVTKbom4GJkuZBh+LVFhdn59Sdy1hCb5eKQqHrFH9HGz6VWGlUfgF1JFhDGc//qhubRBo3eI/HdcgBRP04LqDUGvisSYCku6wQJCgJyVUBmusELAnGy1WLxQgQw+QWYrX4ax2QSGzsNHvj0MqiR4KCha1moI19gUp0vTFYzmY3XDSk4z5QmrxlYHa29S1GJCsrMMGsMmtHpT0fqM9A/DcKHNSjAEdlhigmHZwskHxhmw85b66XCqA9SD1uzFWI9BMeO0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b3e26ec-1a4f-4541-abf9-08de786f18ff
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2026 15:19:29.1849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LMYUG37+ph60ahzddoHoLfRnvj0nw0QnfLaWrVnwlq1tSyP4Ru+bJwNigcq3z0ZfUKCGytm7YGalgde+QxhTkEOR+CE98bhtnBV7TmoijIg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4943
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-02_03,2026-03-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2602130000 definitions=main-2603020128
X-Authority-Analysis: v=2.4 cv=R6kO2NRX c=1 sm=1 tr=0 ts=69a5abd7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=Yq5XynenixoA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=1XWaLZrsAAAA:8
 a=Z0nbYNfEsf-Ief7VEgcA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12261
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzAyMDEyOSBTYWx0ZWRfX7VtQwywX6ooG
 0D8bP/ZDRgsCclQ5GjffQHPxrLvOG5+XbdvszRaob+PwdUvt1Q168qWv/IqPk688WQxZ+Hn1qZy
 lKAZv2f9pBL1ova7C6Z5y27STvHtyfAPWRqMmfZkr7j/YJ9H8dVIMD96W/Df/NasqcVJJmnt0Kn
 OCuWyy8SPKgx2VgPCfZCuj/A2z1erHGSpI5WYgkkYzdqXd3Z8rt04457oMd0hWN/nH8vjFgTAgk
 2SF7yxHyjDX9GHAOmkkx0zpFKo6DrRQRgJ2FNwmGXqUeY1FkUWBlhyLumQeeQhmdAhVqkMnXvuu
 J4Ej2fLIL0GnzWpscnE7uYuOaDYPf44nM0ygW7OnVJv4RJVhaUlpO3E7XTcZLpxQBQa7MPYtQ4V
 hsq8EiFeuKvipUL21qXE60x7Qd6ZmMo5wexpWGK7pNTKfrS4SeIV3ifP8mkcKQIc6uusumkVDPa
 QpF+uabU6DuvH50DJICbNLLxeqd49NEOD//+5WDg=
X-Proofpoint-GUID: JKBFqk39Tp4k2wQxlpi03gJq46iLIQ_q
X-Proofpoint-ORIG-GUID: JKBFqk39Tp4k2wQxlpi03gJq46iLIQ_q
X-Rspam-User: 
X-Stat-Signature: y4k1shdtruy96bejssgnnzt8wz5mhdd4
X-Rspamd-Queue-Id: 7FECA2000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1772465135-913987
X-HE-Meta: U2FsdGVkX1+3aTBFQzru/z/K53qyHEpnUvU7JYWogKXNNXyAJJq+kSDnw70z62OY33j29mf7hyDJdC7Hg0tXlQMnUQLUhH1dd2C4Pgn7koNczjojpXibEhmpQe2lhRczhw3mBNNQq4NWCKMM7m+6dRJJ2PGPuw7ZhLJ7ZK73sb0C/Hwp0sTJGVbb8GjpPeWQdsQm1Gyk9kDCyitXMIOt/1YiI0HrSV2kHHxtTa1Bg978yIdGRv2QMAOHsSFQdXDPAJoagoKAdj2upmbM45QIgl52z0imx2WC3JGTGQqbMr/2TY558j6F0WmvRUrYhpmGgjiv9nwI00goOawACModGs7T+2sDuNDyTsHy1YMRBTWA2Y/qzLxdcsutLJimfNxBw8zR2UwDG0zQbJLeZ6xFh1+m7bs/+P3KXPk8tIYmqiy7bSyVZTWyfwDjy5EDsaM69nG2PsANJo/vdtS3lt8r710tLQDKYJsB6a3IG5nQcKpC0XcNXu3GJuXDWJSjQ41WUVUZCBGOIpXVW/ELLvideIgao2vEBYSYgjFtf647ZqCyPfHrpifUMBvUlTerWGimt0GOxFc3weSNHYnkM11OqGAFII4PM+ffvp0LHsOf8tsbyDS0QM1i9rPzbY0J3ZmtE0KXIrW7T7gwopqwKDiLxELInP5a/VbIWWotWQb39MUnLyhnTcKREvgMrV2LAmz+kD6sNtITIspPFO9UYuQ0GJDv3pI12/pjB6ZVvNec5oY6/yomG3hBeewXz95rWuEd/hOqmG6meLcgJnT4gWGam4/Bao6XKRAezNx1HB/KqgRdF6bo6Eo3KIoUlC5jKV1A+W7jkJWgNpN9bEdnEsVBecPQWpjKD1GhK3DIjlX3djztKjq03RnAkxjwAgC32kDwcf1ltPePPZPHic2SbKSHk1zXru/slVmt45n14qrZanlSa7BOYnVCbECv/2i3kSDlNZipfuFQQC87vwBefrx
 aMe77X5x
 BCxmJex6mOxUJWtMlKN/Zy+6yTTxkerBVJI+q9PKFVDps++wzSn6CGlPMlTHjVqhOx0g2ilRdZ1eqN3qPpTHDPUYUFSOL9z4LU2pX6P6H3W7I/Ygyl9gbf6LJa1lfLWkwoIMH7DGF/X1xD03A6k1KTYhjhfbB2lXki6Zpzd4Vbk258p3MhO8bXiSKxy597AsUiNQVSbnpzH1BDgSGWR7MK+KBmftsxEZuSAXN0sZFstb4z19kQfGjZ2kgLIbFSFlF6frPptkNIZyyIL0ueuKsH0/GO/2xgHYMq2T/2mhbn1/4ML6ioiDWtwllabw0KhtU/j/BCRouopUmhe+wGuwQkPP4Hy866TGkc3IEgIdpZStEimr+0eKO44n2Czn6QQoDBhsxheAnnrsdQTrpN9shy5Z+KT8rSXFepYfJgDvqnMKoCNlRYnwrWMZfzIWl7Re11grPtaK69gE5sUMfYW6ck7WKKJDrwe6D/4iVrIMQw2F4QKev3U19ny3fHB/Ap2UvGXwN3uXC1g8VOw3E0fs9i1f0znYK1XhwqInMvVsFUhDa5dZe3TYxjhqmC/u0GHiW3UA9qgP94D0p4qZNtVlooFhrDI9/9qQAUpaIpLAWBzbMVLMPqeuh14WLujf17XoYe39SeN9hNMRm+bn70cbWXo70FlaNyNyORIq3KJWpujOb5MUvg+XrmP8BEUentYcOZXXdanPcZg97CwyXLsOkdmOwBwFlfbXp4T7DEea8XQcWYRS+2+PwcNwQ7sxCtGuUpx5O+jqUNevas6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 11:06:09PM -0800, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it. Ensure users handle EINTR correctly and do not ignore
> it.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Have raised concerns below but also this feels like you're trying to do a bit
too much in one patch here, probably worth splitting out based on the different
parts you changed.

> ---
>  arch/s390/kvm/kvm-s390.c |  2 +-
>  fs/proc/task_mmu.c       |  5 ++++-
>  mm/mempolicy.c           | 14 +++++++++++---
>  mm/pagewalk.c            | 20 ++++++++++++++------
>  mm/vma.c                 | 22 ++++++++++++++--------
>  mm/vma.h                 |  6 ++++++
>  6 files changed, 50 insertions(+), 19 deletions(-)
>
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 7a175d86cef0..337e4f7db63a 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2948,7 +2948,7 @@ int kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  		}
>  		/* must be called without kvm->lock */
>  		r = kvm_s390_handle_pv(kvm, &args);
> -		if (copy_to_user(argp, &args, sizeof(args))) {
> +		if (r != -EINTR && copy_to_user(argp, &args, sizeof(args))) {

This is horribly ugly, and if we were already filtering any other instance of
-EINTR (if they're even possible from copy_to_user()) why is -EINTR being
treated in a special way?

I honestly _hate_ this if (errcode != -EINTR) { ... } pattern in general, I'd
really rather we didn't.

It's going to bitrot and people are going to assume it's for some _very good
reason_ and nobody will understand why it's getting special treatment...

Surely a fatal signal would have previously resulted in -EFAULT before which is
a similar situation so most consistent would be to keep filtering no?

>  			r = -EFAULT;
>  			break;
>  		}
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e091931d7ca1..1238a2988eb6 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1797,6 +1797,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  		struct clear_refs_private cp = {
>  			.type = type,
>  		};
> +		int err;
>
>  		if (mmap_write_lock_killable(mm)) {
>  			count = -EINTR;
> @@ -1824,7 +1825,9 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
>  						0, mm, 0, -1UL);
>  			mmu_notifier_invalidate_range_start(&range);
>  		}
> -		walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> +		err = walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> +		if (err < 0)

Again with this < 0 :) let's be consistent, if (err).

> +			count = err;
>  		if (type == CLEAR_REFS_SOFT_DIRTY) {
>  			mmu_notifier_invalidate_range_end(&range);
>  			flush_tlb_mm(mm);
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 90939f5bde02..3c8b3dfc9c56 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -988,6 +988,8 @@ queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned long end,
>  			&queue_pages_lock_vma_walk_ops : &queue_pages_walk_ops;

There's a comment above:

 * queue_pages_range() may return:
 * 0 - all pages already on the right node, or successfully queued for moving
 *     (or neither strict checking nor moving requested: only range checking).
 * >0 - this number of misplaced folios could not be queued for moving
 *      (a hugetlbfs page or a transparent huge page being counted as 1).
 * -EIO - a misplaced page found, when MPOL_MF_STRICT specified without MOVEs.
 * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK unspecified.
 */

You should add the -EINTR to it.

>
>  	err = walk_page_range(mm, start, end, ops, &qp);
> +	if (err == -EINTR)
> +		return err;

Again, you're special casing without really any justification here. Let's please
not special case -EINTR unless you have a _really good_ reason to.

And also - if we fail to walk the page range because we couldn't get a VMA write
lock, that's ok. The walk failed. There's nothing to unlock, because we didn't
even get the write lock in the first place, so there's no broken state, it's as
if we failed at some other point right?

So I don't see why we're special casing this _at all_.

>
>  	if (!qp.first)
>  		/* whole range in hole */
> @@ -1309,9 +1311,14 @@ static long migrate_to_node(struct mm_struct *mm, int source, int dest,
>  				      flags | MPOL_MF_DISCONTIG_OK, &pagelist);
>  	mmap_read_unlock(mm);


>
> +	if (nr_failed == -EINTR)
> +		err = nr_failed;

Ugh please don't, that's REALLY horrible.

Actually the only way you'd get a write lock happening in the walk_page_range()
is if flags & MPOL_MF_WRLOCK, menaing queue_pages_lock_vma_walk_ops are used
which specifies .walk_lock = PGWALK_WRLOCK.

And this flag is only set in do_mbind(), not in migrate_to_node().

So this check is actually totally unnecessary. You'll never get -EINTR here.

Maybe this code needs some refactoring though in general... yikes.

> +
>  	if (!list_empty(&pagelist)) {
> -		err = migrate_pages(&pagelist, alloc_migration_target, NULL,
> -			(unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL);
> +		if (!err)
> +			err = migrate_pages(&pagelist, alloc_migration_target,
> +					    NULL, (unsigned long)&mtc,
> +					    MIGRATE_SYNC, MR_SYSCALL, NULL);

Given the above, this is unnecessary too.

>  		if (err)
>  			putback_movable_pages(&pagelist);
>  	}
> @@ -1611,7 +1618,8 @@ static long do_mbind(unsigned long start, unsigned long len,
>  				MR_MEMPOLICY_MBIND, NULL);
>  	}
>
> -	if (nr_failed && (flags & MPOL_MF_STRICT))
> +	/* Do not mask EINTR */

Useless comment... You're not explaining why, and it's obvious what you're doing.

> +	if ((err != -EINTR) && (nr_failed && (flags & MPOL_MF_STRICT)))

Weird use of parens...

And again why are we treating -EINTR in a special way?

>  		err = -EIO;
>  	if (!list_empty(&pagelist))
>  		putback_movable_pages(&pagelist);
> diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> index a94c401ab2cf..dc9f7a7709c6 100644
> --- a/mm/pagewalk.c
> +++ b/mm/pagewalk.c
> @@ -425,14 +425,13 @@ static inline void process_mm_walk_lock(struct mm_struct *mm,
>  		mmap_assert_write_locked(mm);
>  }
>
> -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> +static inline int process_vma_walk_lock(struct vm_area_struct *vma,
>  					 enum page_walk_lock walk_lock)
>  {
>  #ifdef CONFIG_PER_VMA_LOCK
>  	switch (walk_lock) {
>  	case PGWALK_WRLOCK:
> -		vma_start_write(vma);
> -		break;
> +		return vma_start_write_killable(vma);
>  	case PGWALK_WRLOCK_VERIFY:
>  		vma_assert_write_locked(vma);
>  		break;
> @@ -444,6 +443,7 @@ static inline void process_vma_walk_lock(struct vm_area_struct *vma,
>  		break;
>  	}
>  #endif
> +	return 0;
>  }
>
>  /*
> @@ -487,7 +487,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm, unsigned long start,
>  			if (ops->pte_hole)
>  				err = ops->pte_hole(start, next, -1, &walk);
>  		} else { /* inside vma */
> -			process_vma_walk_lock(vma, ops->walk_lock);
> +			err = process_vma_walk_lock(vma, ops->walk_lock);
> +			if (err)
> +				break;
>  			walk.vma = vma;
>  			next = min(end, vma->vm_end);
>  			vma = find_vma(mm, vma->vm_end);
> @@ -704,6 +706,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
>  		.vma		= vma,
>  		.private	= private,
>  	};
> +	int err;
>
>  	if (start >= end || !walk.mm)
>  		return -EINVAL;
> @@ -711,7 +714,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struct *vma, unsigned long start,
>  		return -EINVAL;
>
>  	process_mm_walk_lock(walk.mm, ops->walk_lock);
> -	process_vma_walk_lock(vma, ops->walk_lock);
> +	err = process_vma_walk_lock(vma, ops->walk_lock);
> +	if (err)
> +		return err;
>  	return __walk_page_range(start, end, &walk);
>  }
>
> @@ -734,6 +739,7 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
>  		.vma		= vma,
>  		.private	= private,
>  	};
> +	int err;
>
>  	if (!walk.mm)
>  		return -EINVAL;
> @@ -741,7 +747,9 @@ int walk_page_vma(struct vm_area_struct *vma, const struct mm_walk_ops *ops,
>  		return -EINVAL;
>
>  	process_mm_walk_lock(walk.mm, ops->walk_lock);
> -	process_vma_walk_lock(vma, ops->walk_lock);
> +	err = process_vma_walk_lock(vma, ops->walk_lock);
> +	if (err)
> +		return err;
>  	return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
>  }
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 9f2664f1d078..46bbad6e64a4 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -998,14 +998,18 @@ static __must_check struct vm_area_struct *vma_merge_existing_range(
>  	if (anon_dup)
>  		unlink_anon_vmas(anon_dup);
>
> -	/*
> -	 * This means we have failed to clone anon_vma's correctly, but no
> -	 * actual changes to VMAs have occurred, so no harm no foul - if the
> -	 * user doesn't want this reported and instead just wants to give up on
> -	 * the merge, allow it.
> -	 */
> -	if (!vmg->give_up_on_oom)
> -		vmg->state = VMA_MERGE_ERROR_NOMEM;
> +	if (err == -EINTR) {
> +		vmg->state = VMA_MERGE_ERROR_INTR;

Yeah this is incorrect. You seem adament in passing through -EINTR _no
matter what_ :)

There are callers that don't care at all if the merge failed, whether through
oom or VMA write lock not being acquired.

There's really no benefit in exiting early here I don't think, the subsequent
split will call vma_start_write_killable() anyway.

So I think this adds a lot of complexity and mess for nothing.

So can we drop all this change to the merge logic please?

> +	} else {
> +		/*
> +		 * This means we have failed to clone anon_vma's correctly,
> +		 * but no actual changes to VMAs have occurred, so no harm no
> +		 * foul - if the user doesn't want this reported and instead
> +		 * just wants to give up on the merge, allow it.
> +		 */
> +		if (!vmg->give_up_on_oom)
> +			vmg->state = VMA_MERGE_ERROR_NOMEM;
> +	}
>  	return NULL;
>  }
>
> @@ -1681,6 +1685,8 @@ static struct vm_area_struct *vma_modify(struct vma_merge_struct *vmg)
>  	merged = vma_merge_existing_range(vmg);
>  	if (merged)
>  		return merged;
> +	if (vmg_intr(vmg))
> +		return ERR_PTR(-EINTR);
>  	if (vmg_nomem(vmg))
>  		return ERR_PTR(-ENOMEM);
>
> diff --git a/mm/vma.h b/mm/vma.h
> index eba388c61ef4..fe4560f81f4f 100644
> --- a/mm/vma.h
> +++ b/mm/vma.h
> @@ -56,6 +56,7 @@ struct vma_munmap_struct {
>  enum vma_merge_state {
>  	VMA_MERGE_START,
>  	VMA_MERGE_ERROR_NOMEM,
> +	VMA_MERGE_ERROR_INTR,
>  	VMA_MERGE_NOMERGE,
>  	VMA_MERGE_SUCCESS,
>  };
> @@ -226,6 +227,11 @@ static inline bool vmg_nomem(struct vma_merge_struct *vmg)
>  	return vmg->state == VMA_MERGE_ERROR_NOMEM;
>  }
>
> +static inline bool vmg_intr(struct vma_merge_struct *vmg)
> +{
> +	return vmg->state == VMA_MERGE_ERROR_INTR;
> +}
> +
>  /* Assumes addr >= vma->vm_start. */
>  static inline pgoff_t vma_pgoff_offset(struct vm_area_struct *vma,
>  				       unsigned long addr)
> --
> 2.53.0.414.gf7e9f6c205-goog
>

