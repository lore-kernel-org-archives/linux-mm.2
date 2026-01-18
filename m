Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61508C9832F
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72496B0096; Sun, 18 Jan 2026 09:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C225C6B0098; Sun, 18 Jan 2026 09:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC24B6B0099; Sun, 18 Jan 2026 09:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 931256B0096
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:52:16 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 609001AEAFC
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:16 +0000 (UTC)
X-FDA: 84345375072.07.6B0125C
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7801100005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SncjvCqh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FCbKLa6X;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RRtLxpEFT9jympsIAA1Rl7ra4eGnV5oVhGI9KAE0bI0=;
	b=58LWM3askCGB2rfsvk2EqqeoMbi3NbTK9CKOFn4GhIyi3SWVD44NEFNoV44O2pjm4R/vkX
	798ANtk6eRGXeP4oKaGuOdFRUblLWz8RuEq7cbQL812YAN55/w/KTFRtuKzJtHfbQ3Rd16
	QABgh9mAFSxri9I8Bh9ZxLFMrJHNAFM=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SncjvCqh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FCbKLa6X;
	spf=pass (imf05.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747933; a=rsa-sha256;
	cv=pass;
	b=INR1WZp5i8/RWtRDo/0p8kiNJeV2EG1+qjE0m6ApVhcy3yy0S2hfk0snmFIpSB++/S/WQX
	DapbbWMMY/PZi7XHSqZNIoqDtvWqYLafsE5MBHm5e0O08fZEGrhrDW1EfGBb1la4sbZaUU
	1c9u+T/nuPQ5neJPj9JmQE1ykwIn7I4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEeXXQ3292761;
	Sun, 18 Jan 2026 14:52:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=RRtLxpEFT9jympsIAA1Rl7ra4eGnV5oVhGI9KAE0bI0=; b=
	SncjvCqhsBcSKntrs6E/3W76QepJHjswCQhR4urE3kJLQmUjDchaMSOwpDryNF5i
	wmbBmas3DhEYopN32FrLq/c4aOutTG1fbM5BKDiyrXd5giHAjxkl+7eyubPnhJ58
	WvYe5KPzxMJgSfzqTlWsqLhrpLVCZRFLGE3ugJamL6OsvPm7nUvIW8SbJWGfThnJ
	kpKix5VfBWzo35NIoi9auIYuAFuRhLBJUFnoetAe8wbIETONXz2muNQLVrUkikP4
	sQHTCN8rUkGfZHHoki/gM+SzbpoQJPHl/v+40ojvKj2cSkT+wXhJFJOM4hbgYQ9x
	V3qLjmH1b/49HI4xtz0riw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2yps8re-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:52:06 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60ICGZIk018066;
	Sun, 18 Jan 2026 14:52:05 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011042.outbound.protection.outlook.com [40.107.208.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v7exnf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:52:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xio6HYvDFvOq4tPez+ikG3JgwSV3qC8WnWf3iMhj0UyekjKEBz80AZ2e4/0Y1P8umlKyRfsz26ZYkOuzqe7/WOmzYYyitH0fm2iYpsmkRuB82Md61THjoGjp7AQ/hD7c2G7RaYFf4cYmgM/L07iAU+CpWSpX4tUkSL3Cx4c+MbFkm4cavQ2nsCLaw38cjYnCJsL/DyDxaEEbbgrAHxhuDoolU280GrKCNp3x+zqM85BWtYVK/j7QVuIRcNsv9GRqFzsIqmJVgFBCkiLKUCG4pzBek1dRxcRPlZfP0HF7adPoeILlBrXaGEMxzcuHxKMdm6ra6QEGEallljvr83cJFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RRtLxpEFT9jympsIAA1Rl7ra4eGnV5oVhGI9KAE0bI0=;
 b=KPDdyuaw/KXvLh8BLzWKjgfxvamqtrnWlNFXvPGSSKXsi188pPho4nMjDVZMT52Pp7q3XHHmkFaIZlP03UJvP/tUIMtlaPTGl0/yPGTiFv8mFOUBJ9XfguOZXTD91K5w6vMGdLpmh6xJWZ4SZ7UxKbYlRld/S3Vjjag1rZVE0psGQV/2a9+ELAwN5KF085lk4uQtc5nSFfq/HV+PShdOJsKuMa6rnzF+W10CN6VPAVLRY9ic5CmiEZao8H/MbYpDpGT1g6+ARBOBL5KNnzndam4tndZY25gOn9UmPJnO6nM9way3uXx8AM8ilfulX1551XsvZh78PYcjESP2JALKBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RRtLxpEFT9jympsIAA1Rl7ra4eGnV5oVhGI9KAE0bI0=;
 b=FCbKLa6XFIgifg6z2JvFa1p+mnyB3xyLSpnzmu7WdT+j7E05lI8tFLm/YEsfk453du7rcVFDIiLmO61QCASFb6uL68Ocw323kCzZc/wKvGw8xMznad0mjeta/bYPryp8Grs38/wDgnpYcrq71VxAIQlkbpgYZs6xYld0xywXp7Y=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DM4PR10MB6792.namprd10.prod.outlook.com (2603:10b6:8:108::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:52:02 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:52:01 +0000
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
Subject: [PATCH v3 9/9] mm/rmap: separate out fork-only logic on anon_vma_clone()
Date: Sun, 18 Jan 2026 14:50:45 +0000
Message-ID: <cf7da7a2d973cdc72a1b80dd9a73260519e8fa9f.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0233.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DM4PR10MB6792:EE_
X-MS-Office365-Filtering-Correlation-Id: 472bd1c6-315e-44a7-6da0-08de56a1235b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vaJ/samRAnmuJUraX+d5kp2oAD5ofMeJ7QdxK7j/vVIrCcVh/OKzid6/ywAV?=
 =?us-ascii?Q?o4Xevr01xKlYZutwT6ct5/6kCsFhSkvp9K773rKnfeRBzcmmWjman1Dnolwz?=
 =?us-ascii?Q?E0bn88OZ3LD3NdfpoGbe9Vp6+3GnAL5sJkAhPbWzcnZvH1CRJogwMHttTB8d?=
 =?us-ascii?Q?y85CNNPBYM6yL7pzQU09J8oPiDa7206m6rQfK9jEPaTn8hoywD56WWndtgaO?=
 =?us-ascii?Q?MgJyblkeCUncwVZZpRXUlaAdvGKqcE6gcJ2hTG0/c6LpqZXEmcs0hACE/2Sj?=
 =?us-ascii?Q?6rAzloDzeiMx2x51X/8Y9apxjmgLYH/6g+xFRQhbb+dATjRp6Qwn2niqjTrk?=
 =?us-ascii?Q?/Q9uYiTUQD6YBbtnbCk/fUjBJWbz/H7hHSIg3NCKqe8hXKfJnwQFlhHP6P4u?=
 =?us-ascii?Q?O03KrNSSSDDKFReRNqVDcT+OpwGiU8w7/thCusF8Mv4Caxp20DgXJ1PzwPvv?=
 =?us-ascii?Q?WfxfVZ9KvP6AIRBc9Sw0xbse4gXhIc50sFQRz0K4ZeWwF5cC96uCBqRW7o4Y?=
 =?us-ascii?Q?hMMF1PxL/Tb599LYM89KRq1dQmrPrQo5o3m/nEHGuqy9Tn4GXmHcFs+u19Fi?=
 =?us-ascii?Q?OHnoGQeWwLBL2yaZfy7ytU11YqeXfACfPD/ya1k5EXraznuZuHmWToTaShVF?=
 =?us-ascii?Q?V859d4trUdYHqcmNB/50IUydvaLfMqu1nq6NJuc2pP0uGAIEAIe9ZQN1bFAZ?=
 =?us-ascii?Q?G56bssuaSzQ4BUsTBTqFffvN7RuqriE6HsgqkEBYLALVFLoU7hfOWPAyRWnk?=
 =?us-ascii?Q?3KSshAJXORZDaVWeBzFQZ084RVCQ4Ww9xCqIqpx+oc24IO/bXiwRdsacxH1P?=
 =?us-ascii?Q?Cq9mUiOZJ+bfiglHww2FsMwdZAHuumxoGVLVFOlbH8+1p3lB7LgiyG/5kIc6?=
 =?us-ascii?Q?qXrTOzhMW7xCXPF1uzbIOEzn3KhIZvXWGeMGQiMZ6xExZ2y+JzkYEw1WU8fG?=
 =?us-ascii?Q?Kb3g23vkkcqmAgSYvUBBtoA5Wp74k443iA6LRn51yht8krfYUuD/rG0FhcOL?=
 =?us-ascii?Q?x+P9zWzOiETFpJkQuXVr9OP33zc2xeyXazWvA8fthOVl6tc5HGcJBXfUByTk?=
 =?us-ascii?Q?yaVRlZrn2SQod6VvRixsTKGqyP84Zmbga6egmKlxwfnBITGmHrvnupZYVRiq?=
 =?us-ascii?Q?+RyTthdQkFonI7ShwnVtAo/WjXttCGpJ2SvjQdo0JxtIiVSC5nZa5QxB0izn?=
 =?us-ascii?Q?MxqRmM8iwEtuaH07Dw0u2iFo/MZLKXEFRu/Mod4VFbYl4nbA7qrvfQX1C9jt?=
 =?us-ascii?Q?2wP2YLBUq8XH9AdHKeMfJ9roUzswL2kRhn9IbXXP61W1CABb5iKapxO/R/Lt?=
 =?us-ascii?Q?CdWEsY94qR/DdMOsu07gKQ72SThoV+eFZrZzRTNfhw06IBw0cbMLmS3vOf4f?=
 =?us-ascii?Q?YiLFnB7ys7aMccfyzxdiDaXvwsrOE+CFu+qA0yrNGwDDLCPmyHc29lh9lId1?=
 =?us-ascii?Q?bnao3hpp1GffUcB7fnPWg9FtuNc4Lw09BrabHKc+PCF6/P+FgqMoAwvaFDX8?=
 =?us-ascii?Q?XmgDK3Hm53O4rcX51b8whLBPVYMvnJiJihDc03kmiuGwruZpPFMWOhD/CQtN?=
 =?us-ascii?Q?F9ogjFFajBvXLMfj694=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?fVjZiKQXjOLjUtnyEV377TvNWOn6hSdkX91/HdDj5Ng8KCgRyK3Tm0B7Jtuw?=
 =?us-ascii?Q?EVk6vck+aS9XcVkexYDdz2e4uZY7SeAnPgWaEFaB3ClehCFxNgcXsnpoIahX?=
 =?us-ascii?Q?9yP2qdQyfGp4xBqyjDW8Wdtt/FBm+yP8kFiW2ar4jOvyiSpyzBL7MiSCI5UW?=
 =?us-ascii?Q?1mfRcCF77PR/zvdg0NhcW8UUhalIDcE7TmFm5cD+kMghH12lgM+DUSELSmoD?=
 =?us-ascii?Q?zTpo2M1e29I6MYdykoZr9GpQiYdewUUSVR0KvfAQxFQCS/+DoiTYSkj+D/Mk?=
 =?us-ascii?Q?i8JR9YbEdVN+FTL7ufj6sm/FQ5WLiyOOmtlm7akxz6+hf6plPn6FEvv+fHiD?=
 =?us-ascii?Q?xRSUwvCsUu0ty4lVnU7c92z5taDkFTxF2WBFibfH4Kdz/eYIF2d38PQD45M7?=
 =?us-ascii?Q?SNs4y/YYZuOSUkl9UKtKuUN6zuIjmaIV7pjPiElq98m/ULnDVhRVtnaNcfnB?=
 =?us-ascii?Q?j3E3umU7yH9s58anFYBsEw8ZbbTxAEq1fs6zq9QMgzAjeHKEJaZcZjuQW5Ut?=
 =?us-ascii?Q?LCJec42sJVeLilrkvsoTQd12UWq5BkjThHsG9Pg3v5sYXMul90DJo0MFvXB6?=
 =?us-ascii?Q?Vs4iPjGN44vFKdpRiDs1rtPvPA5KDWyR+G09eMAVU/3tRBv4zNpODh6ksM1+?=
 =?us-ascii?Q?mDAq7C5vIew9HDOocxFzuWHmui5tcb/Tn+GIY9PDxVtFg0SWH70gvdyTSB5A?=
 =?us-ascii?Q?FokKOd+nx1FpJwZMzm+8RPvBwweumPpMzJKE4T5jg+Y5cLwgBAm+6OmphjNf?=
 =?us-ascii?Q?feJS22Wp/BxqzWTaGuZF04vUhMVDQuLSBC2r2itm6WNn9/6n+jTguj3Wz71Q?=
 =?us-ascii?Q?L9pr/JGhh7t+Lfl23NQ+8joMu83aSF/08EecBKXsjBdiziiUsTRHX9Y4yMMi?=
 =?us-ascii?Q?exQbrq1mKMFBgzC4yhKt/xnPKW9pMhsYRlCP0ReguovEwg3IbzxVdzh611oA?=
 =?us-ascii?Q?Dmy6BCX+fpLyc+/ZQOZGELn8eFsq9hbIf60itNhubGvE6yJR/j7Y6EV1rkTC?=
 =?us-ascii?Q?Wrolu5JBOdtFvtek5HTQ/KaOjAS8VjaACPTyFbJEf4N+rNZIV2U5kt9R1OYN?=
 =?us-ascii?Q?fwzbLl7VE9gjiRuhFnf5Sf2WJvym1zx2NGHsFLFMIum0TuX571J5B9QjrrRp?=
 =?us-ascii?Q?M9Y2vnokPAppVsHUR4CMbvpD4terULxI/TKyBPEk8kUrrSvQ9uCwCu1c4I2P?=
 =?us-ascii?Q?6bnsrzCU0ZaAaV8V504WiSsLihSzsFLSyGJEmzvSm/I166mtlfkxtldHf+6I?=
 =?us-ascii?Q?eDY7Na7xipEt3PQ28mYBNMvBSkQU0v9FuBkmGHcbSC+TYbnWcKDeksq6yYML?=
 =?us-ascii?Q?a2g0cRBx6Tpgwp/Nuxf5H+tqbOyEj9XYUzPbTKN6csOKNdrsMhZV1rw3D+ja?=
 =?us-ascii?Q?YVfPlVoF0EeF58J9T3GQ5MwFLGoh5m2g+KXfbwmynScPy5RsWYklL1oOYvA1?=
 =?us-ascii?Q?/IBgOwhYXHS3n9A32CAfWlQMpOAxy2v797DeEFr+Fos3SCCl0llK0QRPGYa9?=
 =?us-ascii?Q?OnjpyHyPd4YmaukKeF3ZbbQuaa8xGdC2lzD4EdwgqLb3taAlYsjRHUm/sguI?=
 =?us-ascii?Q?8WhzQ5FEtFcaXEO06HJ9iP6Sd0L7q5vwv/n9izMxHGnLDy9sRuIdx2blAorx?=
 =?us-ascii?Q?Tlgubnvqa9PcPsqzroGymg2qsHStf1kFS6OEdmD5cqSoDPWYwUMY67g+1r3b?=
 =?us-ascii?Q?5a0iv6ow8NZIQ2t0+wgXBZAmdhenuDb7ATRRBOy+CreM2VPOFOA3MkKtMuoC?=
 =?us-ascii?Q?KTr7F5Q+EW3sCCEew3qnZdXQw5Y67SA=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	0DmdjWXsMv2f318T74xUhUQBgTyB+CPpp1S7PJ9SoOF/RJI0/MvMG+ZQeb7adhYRURPKIKiVDhYxzy1rLbHbPv3SjOqk04BLLFC/aGEqS3hvaLiZUQsgMlT8q60iPI9vv0BXDssF7NwxBYagQZKOpGEW27RiFObaMO6tPX5f55bFumnpRneGfLQkJspVG4Zg6ghQ8js/EByYcpgxfiCjFxYKuWREG0S992m11Eyj9gxQMRCewmZyXt1NkslbL9FLQOL239NRjAx452G8ENiDBY+Dv89zlTuACXOWyyh0wVO5LuQkAl8JM8auc8wwCec85Ma4XyE9yK8sW7Dd1o+6+C6rwmAtvrdMoysvZcNfOojZcdVF4UQ0rJ8VxQuwqGkwwdabm62XgBPOPjGff+UdXYqlGJr1hFwEDpT/UOnckRD7N7hWgcD8gEBXQ/eRIrqcmktbBPTQpAZ8gtA1XkHMto5kX6fjUi4tG0y2LFMMMl5mCZyvf80Auw39W7+FYmvasgDW7HN51jijQUPihTR89qBa7ndwNEd1u5eerJjjNgskNgAafv/JkkELxK++H0UWmHl3A6ZtzjenmBMBLr+HjNwCtIbAN97WZ+DC/Ye5kD4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 472bd1c6-315e-44a7-6da0-08de56a1235b
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:52:01.6912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CqTz0/M02a0QGXT8ZqgQHlao+M1l7xV38X7gz5bYcvCea+A7E+/CqW/HlW+ie+iZJmxF7Y30XTxaCqeoIY72ZMqKP3jd2K0uAh0cqHajpU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX5qB5IQCzlxS3
 q6nsHvfDxKH0kCDZAr3dirz/KdplRVT8PsS1jUxsflsjKSgpTbUYw+ep/W0+Y1uW1rKF3IPINYu
 Q9T50gKJupskFRYEGrrZVOo/dXdxrSfSzrQ/d8ojZ1Q0TqvPB06wN4LDewiB/JwJbMOjoMZm/o6
 YyeA8E/Dz44D4kbFi8fNYl8uMmDjyRaGp9F2f+T2T0PpxInUxgdTG3X4JIsz1t7zE2UD7l7OVD9
 +K/myu8/VXkS/uYATqCcd5BOeCs8t/D+lzw2Hsh7S79sHaonGjHGN3KiboOjoJok8740i+ygueD
 onPlAFAUBdUbb5pPIbsoaXcQS+GolIrCz6D7vHEbuO0qV8ax5dSnfOPktssqBqTothnMFBJITJF
 RILY1HVmPejwvzyRNNHhZt6Pi28j2rXiBItqQMLl4RH1PtLjt9phBRmY8AhJsUPmZF4kfQQte8Z
 vuMy+mGOi/vz8NoBkbw==
X-Authority-Analysis: v=2.4 cv=de6NHHXe c=1 sm=1 tr=0 ts=696cf396 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=jhzElPvkwTWLxKQ5pZcA:9
X-Proofpoint-ORIG-GUID: 7RIEzbCqlYZWbNxJmuNit_34BxNaHJgR
X-Proofpoint-GUID: 7RIEzbCqlYZWbNxJmuNit_34BxNaHJgR
X-Rspamd-Queue-Id: D7801100005
X-Stat-Signature: nuqxuq1ycaqfjme4fup88hj1wxqqdn6p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768747932-581246
X-HE-Meta: U2FsdGVkX18m2EILRJbFbZ/FLJbRWeqP9+bZEgUK6NRtNIJx/gc0VXFUv9UQwzYU7eCIpvxeHkmh5pCGEU41yjB9nKj5gn6jh4DAAFjVyyFx5JAx2pYZWRtP0kSyOoVer7/LZmLOE4P/FyxjuZROsl1f3Ou+HhoYvdmvgAJvJLWRyT3MiNllzyy7SulTrQokYreOqwYgKrnP00mKi/Ydzqek5JGJOdslmCWKNR8mq5GKEr90RDPC22Ph3MQuaDoe/J9sfk8oka6pWyLML8GAgUKVsPkIPNBSYUvd2oxPsJxq9/uJ3P4+UjqECkkZ2NfTPLN7dTZTpebl3iJzL4sH7AB3UsJDcSvudCYfJ6sEYkSDVJdrC6NeEKdNbGDmhcuxhtUo75zY9Z63/TEZiqCa+X7k8HH0EZLEuhejL/yE7hmlggKkrytSJnIlgiXRMViHqVVaNKpfThI7+JUXEhjbsDv+IM2+9IGkfHRCJslQckTeTYuIWBSKJnwhhwJ1Z829k9OiO7aCUmQ+dDmask76Xu54OyklEUkOEHmZrWUx1bMwP9VSSX89fbzNw2ANlmLlgxVux9ScTJQgvImoCfq8G9JkGXg+a5fDi86Az+oXWdP4OvkL41M542tVkE/QHZFkhOdZn4lPT3ZS0+XjaxP3QJmlRBupq4j0XSr8THNZogSB+SklsWpsHqNx8HDOkFpk8mkKxSidqu/1pXjT85QwIFnsBgHfMqvuED/zXItlXoXD9mEPdNdFCAuALJCEXH6rpiYUsojDxUHyGcnKrbsNfg25Sl6ok+osvELSTgnGdaFQs7DT4FT9R64ghNUzVPWLtPLd97LblMr3uHeVG8ysOzffuHGfaQQYb4aLUj6zd4hV2Xtvd5VNeCmTjILLli9mL125ODcDp1VxRWMp9omgpBnwYb/lpsnGI5JQby7Ss9ACh4P8zC1N/7+dkVkholtCt/Ve9nTfy9XYtq2C0oa
 7T/G+MXY
 H/2EDh2rLiNVZhFoyyFyJ04vqdKXTKgAHVTWHV7FFwLBiagJd7uuWza9ESUekd1X6K+1PrvdMREiekzyFYz+FhphFpxgYrLA9x/LGyzR9PidE559OXXeBa/cD/JKKJzWeHwnwhp8Xgki04Zj4odtOxX7m55bfSET26EtZCsI3WOI9IZuIGRUiu0W379Y2PM4+I0x4xjuwOnkGxwQPVJ9hfnCMc50g+dHNAmppBtywN5F4hw6k91QufnntkJpTUrD6vz3tBtAg82idTRrqNEVlyLsjuY8qPBaPRKUUK29lcvNgY5jxOi/ZpvoTyW3diqV40Scql8+C3NeiBOzBAwZ8V0Uf2a8/eBB2aTPQKjnrXU8bZorxHrKEcWN6HbLd0rc5pLH+viir86XsQiGyg7aGC902P36ZR+C+lBki+e0rwiD2IYSF0HrzqgdJzU1HWXWnV95Tgr6KaxGHixqNDuNn0/BpC3BNBKnXW3aGa51ZPamrcPAAWNJT3p0GgsLrcUTAGGLpyj7TPc6CoL4iPhm8HeDrS+TcISo5c2B7al3NUuDFfj+GC1zH1D7/TvWyihg9IwTdUPzWciqzF2DkL5k6xWiJiNbsgveYJ4DRX0iitYnQOYWV3DnON7+KsaNlIGPkhLSc1VwwqdBc+EDoKmwPH8pGLo1uSPROI0u99uMG7Jamxz4=
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
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 mm/internal.h                    | 11 ++++-
 mm/rmap.c                        | 74 ++++++++++++++++++++++----------
 mm/vma.c                         |  6 +--
 tools/testing/vma/vma_internal.h | 11 ++++-
 4 files changed, 74 insertions(+), 28 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index aac4ec53fe15..5585059f0209 100644
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
index b07e709284a2..c1ba88763102 100644
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
+static void maybe_reuse_anon_vma(struct vm_area_struct *dst,
+		struct anon_vma *anon_vma)
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
@@ -319,22 +355,14 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
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
+			maybe_reuse_anon_vma(dst, anon_vma);
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
@@ -373,7 +401,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	 * First, attach the new VMA to the parent VMA's anon_vmas,
 	 * so rmap can find non-COWed pages in child processes.
 	 */
-	rc = anon_vma_clone(vma, pvma);
+	rc = anon_vma_clone(vma, pvma, VMA_OP_FORK);
 	/* An error arose or an existing anon_vma was reused, all done then. */
 	if (rc || vma->anon_vma) {
 		put_anon_vma(anon_vma);
diff --git a/mm/vma.c b/mm/vma.c
index 6c458c8656b8..3dbe414eff89 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -530,7 +530,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (err)
 		goto out_free_vmi;
 
-	err = anon_vma_clone(new, vma);
+	err = anon_vma_clone(new, vma, VMA_OP_SPLIT);
 	if (err)
 		goto out_free_mpol;
 
@@ -628,7 +628,7 @@ static int dup_anon_vma(struct vm_area_struct *dst,
 
 		vma_assert_write_locked(dst);
 		dst->anon_vma = src->anon_vma;
-		ret = anon_vma_clone(dst, src);
+		ret = anon_vma_clone(dst, src, VMA_OP_MERGE_UNFAULTED);
 		if (ret)
 			return ret;
 
@@ -1901,7 +1901,7 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
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


