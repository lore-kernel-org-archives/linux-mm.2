Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9114CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 11:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5546B8E007B; Fri, 24 Oct 2025 07:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 504688E0042; Fri, 24 Oct 2025 07:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD458E007B; Fri, 24 Oct 2025 07:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A6CD8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:31:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CF3455D97A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:31:13 +0000 (UTC)
X-FDA: 84032791626.06.B09C249
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id 638E440012
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:31:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lHdOP+l8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nZYLWWPb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761305469; a=rsa-sha256;
	cv=pass;
	b=WqdOKCdD4RP5xyoOF2Rqc2hAJPgwDsRyC8G5m3BAokKPjBMuw423+cOx9bVMjOOjCH3vwD
	G0p8RDBFYuruXG+9dAKIp5XVMOLcrvKVx0fbz2If3+Kyd5UniuC582TXEAuTJQhVbmTyp4
	bv0O6EyRfVl0u4U/iRMB3rpDE0YSk9s=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lHdOP+l8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=nZYLWWPb;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761305469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=czekmiBp0lfrz89d7lvOk6cTTr7YHH9/r72D82g/k5Y=;
	b=q/78TzE/SWUd1oFmNRSQGW0jMo1pXWLKhUMzqb+PNlicrqGyvO2AGIO/5A3YOjSL+Kc7IU
	KD4o11Vpf9Fg12u0qvLomc8GWLYL2x2TnG0adfc9d0M3nQddG3n/3MFE5QyubgEiqC61uz
	KOhWVu14oRQfX6m3b83DTbnLq0Vx5eg=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59O3NKos019038;
	Fri, 24 Oct 2025 11:31:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=czekmiBp0lfrz89d7lvOk6cTTr7YHH9/r72D82g/k5Y=; b=
	lHdOP+l8wfukaX3h8wBmAYOMNRVrGZwaQaxGpqHoU/CBZTJ4rgg129KyfM6BjpT3
	XvGzrndU8jFNwoqBIS0s1fZ32LhkfkZHH5LJx8PgbKYW65hkBDTNeJV1Q/5/mhPq
	NdIqP+2qInAccnVHQmMBRWXUZ4h0ZI1iA9RwwEwV74nKmcTlCWU/zeKOB4Xtk8x6
	iwddfPOzJvfVkeC9zGY9bAY9x3H2s+o1uqyfCyXVNddU3EXqsb56R9p+yF1ZtkOs
	uiJaVUE4H695H6iWYV+262xzkn864v3Mp4OtQSNhpgNYUie1TXMexsDaBh5XZ8Xu
	rmRCZflF/WJgbhAyUhaH+g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vw3pft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 11:31:05 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O9TmGE027789;
	Fri, 24 Oct 2025 11:31:04 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011063.outbound.protection.outlook.com [40.107.208.63])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bfssh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 11:31:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mGycGwK/DKHhzQwlnG7icSWxVsm7COOIFD+hwUdPDGxFbv9qMfuiuG7JGeGAbpS+RyU/Z3sMA9df0GPiisoIt3Iq/pjZOk9hpBo9OasWcF1Im1yB2Dtu8TwNDkcooS6slNdTK/Q/+H1UMdcRB3qhFZQmiVxogBJS9+T7PD9ChmpAk3VQ/nfia29p4GbnKwf0VCctJdmeKhP5wHOIsquE/Q1oiTWRXXM1eRGGozFgXBLzL/hpyL8WQmise22hMAedXn4PqA7Rt7b4Bzauox7+3kE202HrihKXaX17oszVmFHwbWKf8yLiymLE2SNGv5sKc7abWocQjdbamlPYD3iWIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=czekmiBp0lfrz89d7lvOk6cTTr7YHH9/r72D82g/k5Y=;
 b=TYn6/gxmTqViy3p8RH6BkkRRxTvBkc8/Ub3qUYv01Y3Pluh1jVVNigVmypeDW8u+xasWMgvK0DYrVRRbCWKUehnNqbarPqO3Py0F4Pxb975u9nrS6MyEZz5ioAQSrKXlB3Zdzu+mD3gJ2IelIGTL4Za6oktmmSMzxTF8mDHy44uAagKWVoBLQ0ph7/TvIBOOIpd8yaCdyFN1VgbPLTn+ekrGYTzHGD8yXhMQ7x/MJ6equ+Uy4CsJ0XT9KPzOY/QgBwtd0BLYWrxI+SExSqjm2GQpi/n+vtzZMnaycWx4p8O3kzmWZis74qo2uvI+/HHbfglwfUTKIjv04Kp93AnB3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=czekmiBp0lfrz89d7lvOk6cTTr7YHH9/r72D82g/k5Y=;
 b=nZYLWWPbT0e4Uymb80jgBLcNz/bPZlJfRMyRjb1gKr7vshYQNr2sRcb5bJTIQseUrI1xCYkIWj/+/9ZZRZhfC2uIOKEjeB5ViqDAZyc+IYm9jB8Pej1kEGr1F4YVnNnbpLop6OzMtcv30VeZldUrLw28iIQFGTFqoKnkUIXkIhU=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by SJ5PPF972B28679.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 11:31:01 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 11:31:01 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>,
        SeongJae Park <sj@kernel.org>
Subject: [PATCH V2 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
Date: Fri, 24 Oct 2025 20:30:46 +0900
Message-ID: <20251024113047.119058-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251024113047.119058-1-harry.yoo@oracle.com>
References: <20251024113047.119058-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0117.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b9::15) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|SJ5PPF972B28679:EE_
X-MS-Office365-Filtering-Correlation-Id: d4914f15-b593-473c-e309-08de12f0cf6f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?tGh8Xx3ymCKIFsDMEuEc6QXitBaNjjvjfUNpHnMWKamt7BnFN3qTVYy2PQcR?=
 =?us-ascii?Q?p4v8izGoBbSJzYxVGVTErxtG9hp3frhanQK3UFuG4Q4/Xa7JU/q6R1JMuDYk?=
 =?us-ascii?Q?FGDng6+iB6UTHP7w63hv3FaycvAp1F7DUDQ4KX2xbPQ3M7ydWw7K2iztgWLe?=
 =?us-ascii?Q?FIqheVdTYLfev9Y9vYpWcK+yDE0hGQk+OMilPzPisYdIBdKmGc7ypYvqdJlI?=
 =?us-ascii?Q?UA7L4Wf6FE4RZxDrpgQaEkHW4zPC8aW99QxWz3aQSJ9YWLKKkO7sg41/1Jcr?=
 =?us-ascii?Q?3M0QMnzu+UlB9lg7X8/yQUKmf+tI4PNgeByAxDJLmZd0WQsdy32Lq/A5Ev0J?=
 =?us-ascii?Q?DYEcEJyXuo+rjCQamcoJF6TwEt6TTDIBxxv7ABTDVgg787Y+lDBwCOsEwbXp?=
 =?us-ascii?Q?rI7By2OT82QTfniA9rx5lSudfP+F/YscwVmTdWPp2QYs66G4j7uKjsj/w7Rl?=
 =?us-ascii?Q?wNFeWBr3PQ49cUmjI72lCN8m553oGNhtkwBzDr3Rx8Q4RKpA8xikVrlju8Cs?=
 =?us-ascii?Q?GG0XQPQRIEobR2ttz5K25OQs0ojcywS3mOhcA65NOQqTOzmhLJ+vCoXhegB/?=
 =?us-ascii?Q?LCDI2O154ZKsH0g9q+3Xb7NH7PHIVAkzqYZKgGDdKXIDsK/OGyqVFrUBiaJy?=
 =?us-ascii?Q?nfr5bVyuzxnGoNMT+uLAVqn8NCbbn3Csu5gbfGBPulPNMqtrOv0laRl40nKR?=
 =?us-ascii?Q?LwR6T+IHjnjNeTbTw0/IWOZXosVuPTPFvJyip7J5k3OnjRqUvslN0m91x3nV?=
 =?us-ascii?Q?+V8l56JE9pGOIDuSrxZLa4JM0g62SAoUCkNcvna4MANhJWskYddtbWwjcqg0?=
 =?us-ascii?Q?Q4iXxpcgfbVhsFtMhFSwgs8rLBc4kpLy6wMfJ5JHFgC5dMAp2X4g3YMjajRc?=
 =?us-ascii?Q?Yvhvj7IVUjUu6JeEPegy0Mb35VtnFzPqs1ITuZ94P+B78mDKAoDHWuqapCJ3?=
 =?us-ascii?Q?NZJBifayASjNwm6RZeI66c3T3M1SbPlQ8Ft2rSdVcEaeMe3gqdHqB6Y2hD1D?=
 =?us-ascii?Q?1akKaQiOqE2A6oV5byTTPN6Xeu3tlpMdDZoLKeMnzcezmP4Mck/up7sB7R77?=
 =?us-ascii?Q?1MS9tNSvcsLwEszFq/GqlrajjFD2F0p0ZYUj/MshlMFDfEV3zdkGNpPBUZIn?=
 =?us-ascii?Q?1Rzhi9fA0TgO6BS7E71N2T2qEfImDCTjI3hbDE5H89bAZlm3YIMTa9OrMxmn?=
 =?us-ascii?Q?uO6kVxGNVhaK4pF48DUNI3mqvF0eEuboG2PHCDu5ad+KQoP15Vp78J5ZJ1Cf?=
 =?us-ascii?Q?TymuU27sy7V/V0/RfrQ9BxedFsra/GeYcwkmgGkw1e2qpf6pjNs4oDuikyoR?=
 =?us-ascii?Q?C8piT1rdzkJ1wNOzQKfA+NNyc/HM5Rj8PnFah/8p6pD5MT9yIYkChPVwsR9p?=
 =?us-ascii?Q?BW49pkypyUS6XIuwEpEM9g4XbRR/hVJbyfIShdRn8IpDlwuHJqycUyjpPmZB?=
 =?us-ascii?Q?8BnHnwFc2B8XYYKMixet/6rXhdq6/tqz?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?l/By3SkZx/9wmN/ugH7B80NS+GQRbszMmkJeKRLGScFQCPlvwf6yIM1AaxQ4?=
 =?us-ascii?Q?lz8FjdMXL23DZRb19huXqGvYBeQpj+xfmr+JdmHyFLn0w/892JDXQCV77rKO?=
 =?us-ascii?Q?Sf13I541mEnPNPckqVBQtoe4OpfR/xhQRWu1YIipcKCPQ8NCTGnRpY7CeofN?=
 =?us-ascii?Q?dF6FkJMecNHoWiestOpA5WGlKagWQ6x2bjOvLhiJrgQSuYQy0T0qH8ZBoWDc?=
 =?us-ascii?Q?ry6vZ0p7xKRwf7OythD8E69NdGjHdfNK9PyxtRD3q3883FGVN56+7LyzW8YJ?=
 =?us-ascii?Q?i0Orp9jBm2Nv3d845lUowFZLqZIYHQMAxZwbKjzuLzuzUkoJis0Rhephz/S1?=
 =?us-ascii?Q?GmLL1H8lBddciC96RvsnegGrs9vxmYtQC/Orv7tzonbP3M5YuWusMt9yaiNg?=
 =?us-ascii?Q?JIYJIK+xrmejP+KWKvbR0d8nr9jaHeP8uVXL9iqYwkx5jVmCaLU+nAioOOiv?=
 =?us-ascii?Q?AOjVoTggoFzRbMGV06kQdMgEkg4R9uXBX5n7KCtlqlrdO2KVzLFZyxHFXZOi?=
 =?us-ascii?Q?qgyL2uG/Qlc8auT5DYBJj1s/2Ss99qfGHdOu3hUU4yEOOvp5/roCEkT+23+o?=
 =?us-ascii?Q?4ZNhblZeWOhJD+kl96K8hY6NL6sexLKL5w+xoFEo5ajJnDWH5+6/R1ALkMSs?=
 =?us-ascii?Q?lf5OctpfXR9oi9Eh8LKLWImiKpfP+EkC86LOKweQdfKkJTZKSZQMo4Jg0WfN?=
 =?us-ascii?Q?x0Sduk8vLi+310lFNbBKBuBRlKMKWGSG7S7HizIr5YwJAsEvUjNpgQ69tfGu?=
 =?us-ascii?Q?YxoATsr2Dywqv1OmnRzjz5KiebY4TjUv/VaZjgnH67ud0klJTG/rDAXojNUV?=
 =?us-ascii?Q?fnKnveKelKme2pC18L09hemk7aCgnS+6J3Rf6Pnvja/UftJ8a/ddLvu34LHt?=
 =?us-ascii?Q?vlYvJmXZ8Vd6WSPUxuNfHaDWasoSS7jDMlbgaveg4F97T2Sef5jaUzati5fp?=
 =?us-ascii?Q?3hqmiNsS4Z8BW7woMReYzT6GYub4r49c0ZMvX+edaKh+z8wha045CYUwFIVX?=
 =?us-ascii?Q?rf+lyqrr3shNFKrnwFyoiZqCylGIUMtYdxZPYZ8uhEJVHBMeY688Y2z5AlrX?=
 =?us-ascii?Q?b/0optLaflDCscmOLHkALZ3MUfB7gMvnRN0smAHNf5RL2RkKVLmJTf6wXI0C?=
 =?us-ascii?Q?bNQB51VEnWlsHEX7PCgo7tmY9R6MmRcjIILwi0V6nYO1VLHCqqkn/DMjhpwE?=
 =?us-ascii?Q?jBbEJYYcPHE19o3/2R/OcljGQm8pjDXRN/776bPEJkQCkXUuBN/6CclJzQp4?=
 =?us-ascii?Q?EosWcMpJH0VQ7rI4VmwZgp83RvST14jkhfgbbRM6/lf0pk8y4r7y+iy6ls6J?=
 =?us-ascii?Q?1k5Ausx/DNrhZ3spB6jPou+2Eh0T0MHGejHuEr93nvPok7sVlv44Jg7egn9l?=
 =?us-ascii?Q?31L9ASr6bHI/Ou8nAENMfaRqzGqRmq1ls6iTLTikU+3XdfDuJ1yfj2B1C2XA?=
 =?us-ascii?Q?6haL0FkecIqzAaDAgXz2S1gdIKUt7Mx63IR2NfskMnNvP1FJzVmUuYqq1li3?=
 =?us-ascii?Q?zODTES0fKdo8nDKNDUi+h3whcNMyqM/4VdF33gxZ6gn+fk79eKfE+J3UVU/p?=
 =?us-ascii?Q?xqjRpbThZFX+VV7DETfmi4uHNyx4b+GQB1m8X0qZ?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Mlc6dJXaZC8r6Ypeiudh0m3h8uSXa1kYteZTURLk5KBWUicl79y7VE8BwtOugXlXmYJpfGgx+XaXsWFQBaiFqo6L+jXKlw2TUxGWw+kl0MJdeE++9j8kzyO44oDteYYHCxbUJUK6LviXN+k42V73l1KRkHGo0XxKq40rW9NGzOfNpxG86z34YoRuHRtN/zV3rXTtBofBZkSnQRMf/yrUvDsYHvcZrC+lh07r67cBlAXDHj1ceFjnnJhM5o6zWA4490McnL1OgsAqOIHh0Z9Q3EN8kD0Lw0iEsUr/0aO9rZiHBXoz+Yfq3smSPmTj2LrtMVroaGaCzDoMSf0DoMe/UMoXInA/+yYEb84MG7t4HCu/P2x/MWqTIY/v8jFKhmO0CSt8WcnbP2oCbUmk7hnQQwzdsK9K+bzbNZk5REFxoiJ6ZSOSzUMT7HNIdkmaWmKkLf7ArDlbSH0UpZVjgOfW6MzNleYNvnLqVltelR1S6wj7wbHwrw4h9Zfm+WSneJAZZ2+LQVQZj+exHEoVh9T4i99zP22fufhQZAWpEjY3u/cJ39aXxXkxWGE/boh5lDsueCZaft9yhBBfiAG2aINmAef8+lU/cSOJbcB9k2TjX0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4914f15-b593-473c-e309-08de12f0cf6f
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 11:31:01.6521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BH7kkBnN9jsnC4T3gjMQ0s/N7HKGzYFUAK9mxpNHIuDPu9wI2vDTFyG3YSOFipjol/9ZxfiTll2rFHJzeg562g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF972B28679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_01,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240102
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX/sMZq9hwe7Uq
 bY0QyZEKdUF25NT1t+HHbDL6Y+VgmbipYjAS91wymjuIMe0op54ZDy7WktcwWBrBdPw6vk5Ks+3
 Am2rqEplI5lX0O+fJX6B6528Y5mru6FT0pCp4EUym6LgP/Op3oE0zMzNw2kc0MliesIYgOQMn3y
 SaKp9p/B4UEbp1lpxQkdgNSqRpklcrzuc2lHW8nAlb8pOb5YUhKu94vsEgi7mq0zJYOaTg3CRTl
 Cf/J3uqkpzcs6CyI2gQyl7oE9LA5fyxPcLrMzdVgMKaesgtzPWFHDyTvqKdTiU1daOlOn8+GEnj
 Id2ipIEfnK4UvA3GtAbcq8gRUkw3YdNiyZYO9BYUpFrp2yh23VCHbC11cmQsF+YfrEBlonFRj0+
 0A5CLfzZSWdKg8jLF2iZmF7Kxpe26Q==
X-Proofpoint-ORIG-GUID: 5UttGKJS4ngiv1WTnsozGgmLEhWPt-jR
X-Proofpoint-GUID: 5UttGKJS4ngiv1WTnsozGgmLEhWPt-jR
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68fb6379 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8
 a=20KFwNOVAAAA:8 a=qA3cscbue6hW3SdqInAA:9 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 638E440012
X-Stat-Signature: skgg7hzbxh4188e7163w8am4p6953exi
X-HE-Tag: 1761305469-605204
X-HE-Meta: U2FsdGVkX18J61GmtbjdcbYuxnW9OQRn1bDqKR6PODxVTkvSADHRewdB9R035ne/Frc9k52Ig+B06jF0y0+dmvhsJhORWvSQ8VNT+QPkN3xHbv1widmaUeMeyClsZHpo7CZ2bQ8l2jCm2baUlNSOhOoqU4FmdxBZtE38zdQGBC7PbulAQiujyaa1YJU+7qS22umQBRDE2hHscuUwXnMiBDmXwumQhOwmM+sVWHw6sk+o7PZ0NPlrC1pEkNHlXiggZv78FCkbO0hSO0rIKGE/PLETH/SITmP6gZ/QiKX84cTliSfSIBPzqNHivNbdcjC9XNS247Ft4dvl+0l3EDhW6+jOabzPdJPxDR81wcozaakqIqibtBQSIzqGCwzkKuwz7OJ34sQDdzjnGf0GJMO05anIZG9/a6dc+yCWMOdJb8f9v749LUDMpLOwmw16JP7Mfzq81bpyQwNnU6HsBvJAKqZFM4QwySc4QSqMRhyz4FstoOmyDvqr+M8IpssE7Cs2Hv/gCboN5ZANjPl6xW7hoz1oR0mrna9oknjnh9zH4hTQ6h60tORD6pTzXdQDS/hvKOuIkbBa1ir3e924oXo+AqtBDECUfOYtrBLUyKmUDQUnY90R9zax9A7+HuJMQSzwLXm2zAnFxPeF/5wwtyFayglDq+HmdIa3lXXpJydLLU1otBxOssdm/TEitRnm0B/DjRS2QA5XGNOQRjCT/TXThuHbOvGr1aviiQyMxzJEVuVSSWTbYJJ9bmFnQteBVATfvhoy5Pin0hIVrZJatgYjYJYYRc4yJ36G/AGOwMtoirV9T0Q3BgGYLV6SzVLPYY2HjQmuBTnwbPIrDUpXV8Kyy5I6QRyibwpaKWh0Jj04DiV/IIbclmLLtsVgleR3LiQlIo2SGFZdlnfkDyozSNpIJDkBMSx6s+khDNVo631mRsFW0TgJArf3QfUjbB2NRGHXj9gWmLvPc8xYYBauUNZ
 oprTmRkQ
 uKIIISCHTLctnTsLb6wlbwWHUMKRO5k5Hn6QUjeQtzbsqZxrvwwcJzK2h7/jQxcDi+NNe29uPdurDePibe7KPyY0MlYhlM/FRTSPJQTL+8BtCWAbPOEhbIrwKTeEzc/9qW3oxJ3N9+SJ6COJjBDjcOmgsjKabx4bk68WWLtD5hPW/SUPdPR+EDQzjmTm4LD7pFFrmU3mUsAFPl63gotWiHxR7hjYQ3veX2aidP67MLyx8WAXe7Nc06vbb7ileJ15mtC+RwnBUBduv31g/23kgA18eHL7lIe3Nonv66kqCreOZ/zXnASEhdMEMGxnbIBYDcJL80uSWUQ5nOcKl7Ui0bp/tZUh/kXDhdiXZxDQ++y64doISOT9rry0pL/Ve03wYVzRowCzYS2ImFqLDEjBsbtgPFMcVZi/oKxIY8MjEO6pB797r/KtKRHIMZQuml5iC1vznJh3czUTys4+8afsnb+w9ZQP3QajpmzUjWsAg4/R3emELGf3kBhBhSIzAeAezGfwUkvF3PY8Q4ZNsPWWTkVfXqttVaExCr65JlfIs2xlluwJ9JuDFDqwooTzPDbmdVntkY36tRBlF0B2Dbu130iYnxlXoDEdQSKFz46PmGGOjRj4gP5SYXthBecadpf8hwxpYIpT2ahSD7hE4ADebOWMNJpsWsu2dNKhDasw8VTEthD2KwwY8Nj7TYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since include/linux/pgtable.h is already listed in the MM CORE section,
add it to the section as well to keep it maintained by the appropriate
maintainers.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: SeongJae Park <sj@kernel.org>
Acked-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c1a1732df7b1..1fa907151c6f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16249,6 +16249,7 @@ F:	include/linux/mmzone.h
 F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
+F:	include/linux/pgalloc.h
 F:	include/linux/pgtable.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
-- 
2.43.0


