Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 915FAD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 14:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64D736B0098; Sun, 18 Jan 2026 09:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5591A6B0099; Sun, 18 Jan 2026 09:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3486B009B; Sun, 18 Jan 2026 09:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228C46B0098
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 09:52:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF2098BFD5
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:16 +0000 (UTC)
X-FDA: 84345375072.14.5FF6172
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id 69809140007
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 14:52:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bEFw+AX8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wayLXtEi;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768747933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qm+LwJ7c3lV4/R5I5WnT3/pKvvST50N0NJr6UQ2UFT4=;
	b=uKJ2AzzQwIDk7Q+oZx4PtzuBKoQt9Ky0cMOCm26TP3xZUfzRzd8ElU0UhxCBsQf6zUhekP
	cdkMZtU5h58lW+DU38cbiHrQmSAZDfTudXVzF6zAg1UTfDZ5ahvFMKKyvi7ObmWYb+KXuB
	e4X6fj8bRGgF8wgL+VFuh2vlw1+16YY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=bEFw+AX8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wayLXtEi;
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768747933; a=rsa-sha256;
	cv=pass;
	b=6yDkSJ3p5TG/I/Jos/iNDc1G4l7+kI0eI29gRSg8CrXR9CWEdqG4slBRL7xcNni/v+7tXp
	gZEUtxel9dyfxXEF8xD56Rez+mnPboMGft71UR63ncLhjE2UcZ45xtsfelZhhch+JiKPtK
	+XsBuYk/kkFN+btkPvI3f8M0b5sew0o=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60IEk3sf3532421;
	Sun, 18 Jan 2026 14:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=qm+LwJ7c3lV4/R5I5WnT3/pKvvST50N0NJr6UQ2UFT4=; b=
	bEFw+AX8VeH53MaUKvxb76na/1VbW6ZjXyURrDThIyF8BiH799oNhVrWeQ0Be5jl
	kHYfSMRAEgScxVOI7zJJq74r6YAbRZLAOYT/uKy6LAKpj6SxHH2GSWlBusjF9mkA
	YmpFsEzTI4w56MclnTAA0NVL2SSVHRqY5wQE2R6RmNdCCnyezYCWkGtMGJfBfwka
	uJ3Ffc5b2zgwXlklAgpIKTEXDecq8Dzi8AAlK4aTTFgono+WnKuPHx6Jp0V/Ulo9
	igNaqMU8LQarTq/1oflOR63ghV/mU5UkzGzW5og+AGGusISRa9gQg7yoLQLK6Opy
	xnu1VC+cphpyD55OGV67Pw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b89bs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:52:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60IBSRui022500;
	Sun, 18 Jan 2026 14:52:02 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010013.outbound.protection.outlook.com [40.93.198.13])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vb7b2k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 18 Jan 2026 14:52:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Tr/ba4Y+MGz11mg15hFfvR2UUgDbNdCWtUF43GUbte9d97xMgLcwRKL6+sEotyruveOznnK+z0P6uJ3BwNzmj8m8h1VDZJx64/VvFeFDM4dZ7vwcfqwXlxH734fb/NaleydUC4hBt5BIxNfabjvgogbCKRFiyUOaBVndb1GP6lOFpbt5vYH+Kkc36kyLKdTiG4FKNrwHomfktY0kOs3IOnizQgHN4tJe8a8oTaJ/ddD8ofNrusdRutMCw4Q1oS6LuXtpl065IBTYgdPqD45RQlugyDP05f2Lp/tzgT6yCt5vRSbJB7YowLcNSTGfy0p3Io+9fapmC8FwOsAw3cCIZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qm+LwJ7c3lV4/R5I5WnT3/pKvvST50N0NJr6UQ2UFT4=;
 b=GmkmF6yclx86wjz/lGkMkpVr1ueyVFM75sCHdWU2eM2OgtvT7V46sQSQVE0vEmwoeu1GwXuh4NhUNrBtEMY+TZ2LbMv0Uby2TP7Quvvkf+R/ZlhhqIzbBOpdEKLOFQH6xS1dUSiNK/TxOwDgcOoCAlkvS07Co5AB4Hdh6WXOR8e5Guo2qzelGo0HLkjSEMKmvMRQjAoJlpggo4GN5atq7yvKiirp5n1BlalS3sq+uffc8wnk5oNPFXuo46aX0HRRiA//4iIAPmoRPipzlfTU3o/hG5Tc5jQuBAKOVdU5KErzZ9LK1oZz7VoSpTc7aTyUKIQor6e0EEv+18qmgECC3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qm+LwJ7c3lV4/R5I5WnT3/pKvvST50N0NJr6UQ2UFT4=;
 b=wayLXtEiY0eRCGTTuMVUt9tbfF70cE50YqCLBsvGOTqVXLCWi/TJhbQmnMUK/9JelQhe3pPGWrfAe3N7KCopy4o4A5g5HDQ++G3ae4phkZZDs5bbCUvSERey/vtWo5Dt4897DWitSaWNEGxRxSQhNCPPAd1ThlhB+kutt+OXSe4=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by IA0PR10MB6723.namprd10.prod.outlook.com (2603:10b6:208:43f::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.11; Sun, 18 Jan
 2026 14:51:59 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Sun, 18 Jan 2026
 14:51:59 +0000
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
Subject: [PATCH v3 8/9] mm/rmap: allocate anon_vma_chain objects unlocked when possible
Date: Sun, 18 Jan 2026 14:50:44 +0000
Message-ID: <624bf1ac0bde4871fcfca2c8c8e294b6d8f7ae7b.1768746221.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
References: <cover.1768746221.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P123CA0554.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:33b::9) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|IA0PR10MB6723:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cfc8807-2356-4659-da9a-08de56a12244
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+lYRBHLmNgOqVr9o6TNihYZpkULh+4fKmS0LHG5evNEDQf9bJxzI9Hmd4dH1?=
 =?us-ascii?Q?uS6E+Liscm3F0hss9V8pAUtT6VBw2fqeMyZCWFf7BzB7uOIbOzicJKiDHR4n?=
 =?us-ascii?Q?AXtShSSIza9J2sr12vOdw+i0Q4khWsLxSEHQ7Ip0Q6Tu0gtLCuVpTz5llN7o?=
 =?us-ascii?Q?lgI39t/L1UXCKembtGxe5Jx6h6m8JkQMRp7tIwyDzxEHqRiOWOBQqpKgE5ah?=
 =?us-ascii?Q?BrQ5YoLtq9iiLYoow734YP9X6dAUpFG6mjCmMsxbVrXMYzmN2nc32RVyznvA?=
 =?us-ascii?Q?yGz6TI+u2JfSzTAR4UNfow7Dc6t+RKswfUDpOKF1yiP4hoRsFcDFAuMhveKs?=
 =?us-ascii?Q?uySXQwtSnOBo2c5nj9CX57MoZ9k3HSVdZ+ZslZ/JtshaBwkHoOmt2S7D8vEN?=
 =?us-ascii?Q?bC6apF1noABX/nIKQKJQModVfW9qvpYpt48STRh4vdMf2dWwsCojbxtHmW6i?=
 =?us-ascii?Q?0M0d3XQxQQdL73AZBoEn2Ph8DwIQDrJouPPtKCxDIGkgO20ZHn8U5CFCS/y0?=
 =?us-ascii?Q?ujc7wivXtp7vFiypMyf2VVuxfNX3CIAwNkhsOqF26ibcRX5vOPCTNNKfwcgA?=
 =?us-ascii?Q?4eLMHgYIUxrEL18dFP7jPcxFkQLXrgz++enfeJH2od/5FbV6PTYk5u0RLIib?=
 =?us-ascii?Q?yaxj2JiHiY5KlMsjpwceSmPTTv3lJHBz9WFM9ysRQsIZ97+t9dg9Hz+GM2oN?=
 =?us-ascii?Q?my25LRhDoO6Q8vfwyzL/x2unPokXbA6un6T0oIR1+zj1VQPw71k11wSeX30r?=
 =?us-ascii?Q?Eih1xR7UTxD/RxSMAozc8rK/+kru5qjMTHh8Ewjc2LcjFuU2dpv0eOjY1ktA?=
 =?us-ascii?Q?QjyVtzQAyxOvEZojo5k4rnVA5NZFJsYkvMwSWuwmk94zl7DB5U2jKKM4/dPh?=
 =?us-ascii?Q?kimJy1EmlQ5gpg8jUuJBCL+29dEkXEJTXGyglzk3+ieQWoLd4KyiovEDrA2E?=
 =?us-ascii?Q?V1rN8yV9/fLc3RdoTeNRPgKtdsORDVyYu3ne7UWD0sgOZVbEslKrEIgUb0Fo?=
 =?us-ascii?Q?f4y0X7MRS7aRuG4uDf14tan7GJtYfNUmcxB4WZM6Ci1P2d2xLwBbZ/SjkmtX?=
 =?us-ascii?Q?7UkKqP/kEAS3moFHJmYibBac+cRGEsQ5qSvAv8RikXGNPhH0bU8/FrYmUXUs?=
 =?us-ascii?Q?q/8tewlOsTSOX2/MfvwcDHQDMDAf1Vq6f54rv9FcOj8sCD9peyoC3W3iwi7b?=
 =?us-ascii?Q?tk5hwmBIUzr6R+0oqkbYMEDNr1+C/ejFe1GWNXrISKV7fIZ3OvBW09zlgH4a?=
 =?us-ascii?Q?gaJQSUEbzxKIxB9gB6AS2WkU1qQFf+Zahsj8Ga/dLEl4mGNzWvnK8TaQ/KJ+?=
 =?us-ascii?Q?oCIMgZ+nudkddzDTKqmpmdwBRUJ1cshNPnE4NzfpOoV9oAUxYkKyvAF3Nhym?=
 =?us-ascii?Q?reXJB/KCNOf72rJoKvSgwo4AE9rDeDnHuA96m4/Lf3of8pFJViOXtwqdR0HE?=
 =?us-ascii?Q?BbajRQcyTiqQQ0vKyX+flHB7QdEP00NbmSYbyHj0+gc1zqiS7J4ZxXlx7HvD?=
 =?us-ascii?Q?l/wrYbpTLXOAsmM/XEZ7GRCOg1rAeDsdbpXAqMPesY2i3YSeGurEtCKSggnz?=
 =?us-ascii?Q?1U5MNPZ1DMPphWaEI+k=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/ou7SJQgF80UfjveHbXosUpmzsTLvqRAKnt0tJ0AXa0FkUSSbzDcOkcakWFA?=
 =?us-ascii?Q?swYeBuX/LfJPigR5vJ3INEKNVw7gQrCdLBoDGQcj806bjpnyDqH+2NrPKolP?=
 =?us-ascii?Q?bY4htC48EDZ9wDlRQSGzV1xalrSik0cxIk64U6ycHqvsj9zYOzQBeRDOAyxV?=
 =?us-ascii?Q?jw8egTqW3NIHhl7aERw1BYpaVMO1JkdncRKCfP917XW2x7QY/6sbI2lnhJSQ?=
 =?us-ascii?Q?OPgYpBjzzH0nXmyqskVnk1MC1IOUYyOoOMrHS3VQD2N8wmzU1Ek2ZiAHvXEY?=
 =?us-ascii?Q?FzAov1qSvmjsF8tFW/l9IdtgpyLF/+TlD1NhPYEUE3i4kR0uH5Lj9p5Vi6T7?=
 =?us-ascii?Q?h7ZFbnh/wqmrXa69kFEZZv3/1/vtURJrNF12YewQI1UsuqZRAN9NYJH5m6WZ?=
 =?us-ascii?Q?rqD/fH6eEwvRpf5O64bs3fnrXyTTWrIns0x6fXL1ZJ7pE5nGhpefn4nwI1V7?=
 =?us-ascii?Q?Yziu688uV8MIhxFQindPhM+xw+82wCzHxY0yMkspf8KPL5P+675TY1DDQXge?=
 =?us-ascii?Q?0QnfbrWgLqMh0pbmNEEdSgudE0qgzrkYiIfa29iBeTu0qeteNg2EnJhHfDS9?=
 =?us-ascii?Q?/9/q5XHErIwHORA/96kAmX0RF//FHOScm5kV2c4vhyKXyty0bmRKv9WL7iTq?=
 =?us-ascii?Q?W5tdWvKow2yoQ62HShdqQCraDdsZLHONQ3+raLRwi4jf26uSi9Us+ih5dNTR?=
 =?us-ascii?Q?mCWA+BtubWsDPRBRh6NOKuJr/vk22aYH0QX6VpH9CdvgQOCd/na8+my7cRdD?=
 =?us-ascii?Q?BTXS9BhFD2coTCOaG/NG14x6XZesdnSA3M4rDUQMll5Q1N7Zs2713fc6tLsG?=
 =?us-ascii?Q?hs4bhx7gSz0ljDAm++q/XpaVUuganNjAE77QzsUTwfx/4DsNm/bcJSlCfZxp?=
 =?us-ascii?Q?xJDkUb7hfvkvT0rVgFdQC1aJODktHMLD3wkGFItM8DC8Gc/J7KlISN7IkOZc?=
 =?us-ascii?Q?xyhY2aOWFUuHohsfLj7PnoqgEU8BFqTm6+7fgqKxeENkatwTh2d5UD5YbqgC?=
 =?us-ascii?Q?RjkHYpc9ax6R74GmagpEWMWdedqvedGRJYAeOTpwZawX6V8Vw1tWM9oc53dC?=
 =?us-ascii?Q?0LWaVll+HgLqU+sv75FGg/Xw4A9TUDS+seOCauf6/M0Kt0Nc8gZP36H0LJdA?=
 =?us-ascii?Q?jBPaGRwYzKYPuDeIa2prcI38Am9nJY6YGWJ0yzRz30fUOGIxe8tzsEIZgP0s?=
 =?us-ascii?Q?8ytAhNUFfjSaFEc7UrpJc2Nu76p4krMGlsS+MXOF5wUVVBeoAI/9ZwB9zNbw?=
 =?us-ascii?Q?A9zo1E7T3xSEwldqWSPNhkywz+nZWWX0P0G6DHV7Exo/DJvm2oG0Idc7haVh?=
 =?us-ascii?Q?ndCQq74S6cYPCMnfGF29/PRwZkQ17wykfev+DndbHwsZmb1q67chn7+Kvs86?=
 =?us-ascii?Q?b9BXTRjCDu2McPoVmWkNk1BRAdG5S8vx6fziAyxfJOE9Kv+AGeoIUbgnICTL?=
 =?us-ascii?Q?3Eiuw8mVOP+Co3yoMmIPEIUjYqWndQ52SbUEyLMMg+bX7uLZ++kOqjpLiTiS?=
 =?us-ascii?Q?3BTE7OaT3o9xnjyoUTf6qrG0pnbIWuvmm5hTFQ0uth8WMWcak6+cehRd4x+D?=
 =?us-ascii?Q?/G7ZD/QSCw3AVjIs70jRviVRb+Q9EodYCST1lxgeMPrGWxk8wv6mjRLBze4m?=
 =?us-ascii?Q?+p0cDhiodTgtF41mXC8Zxtu1VrtQ5uGLg3GvQ8dF2w0/bOZl94on+jnA7x0a?=
 =?us-ascii?Q?8sH4qWLM9EoT1kvyFz1/lSRJgEx3OInqyzDd8FPSZnHPfnXcbLJGXgjZOrkx?=
 =?us-ascii?Q?7Jr8CEmdCfuqX4vrAkh9uEccBbEp934=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	TUKCN0X5uUFT4Vq/c1ge271bVPZuxVUZKaOQlN/fXTL9yctJVNuKlQUm3vdmlWbD6CcjfM+xnFxz87ymKpLBzhNAdjpHn6yfbF8rmmn1mlTn/eUAH35gPEdf/PkpZuWO+Znt+0XY4s7GlxSpFQ/xCNQH9FXoKqXdudQU1bji5Y08QdgFYP0AU00U7YOUJjbzm1beg5npBaOGeDsOGRR7IprNuzWMGeZQEeIANl72Ug+mkNUn94rJkCuxQc2pULQssXc/i6IS4/aZrp3+WvL5JyFObD1MT4CtMG+E9QIIxnA5hawSRlknMyGBWBd9fRJ/uNS15bKWa/pAAq5fP043qVNQmmLn5qDr/zNmcsTvGjTCuyAs91YAL6ebfWNbJDperArp3JTU1ivlh/Nkm8Wa8CdnMfw2jcbeC64LR+sE764tplonM+sIoMRadPPUdcAmA5zZty6dcrA/jJwascLL1gagY+v8v9opnkx+YlGEqoxNOlNuIBK7pxFVmXKyiFbF713OwzdW+hqwsry3FBcnOTfhgvuNHjTXxhvLUKj00gtMa5wgr44DMzknCbbAsjqldW+XBZMGGIV5JeoIBAAMNimrgOMVntnMyp+t3H5s/AI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cfc8807-2356-4659-da9a-08de56a12244
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jan 2026 14:51:59.8478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGcPgGuETftlgS905pfUdR2C89a45bZVEB2NGAgpljf661xKwO/Bt3fPTDOKDjwOy8TW9gGjP6dBOmXMEcx/ttMhGxQt3AlJsf6mTzXAXSQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6723
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-17_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601180130
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=696cf394 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8
 a=Pkv_mcax0HlRMdS3UDEA:9 cc=ntf awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE4MDEzMSBTYWx0ZWRfX9TKZOhULNXyE
 +49n+SQ8WvrtKzdo7Z+HnQ9wO1ImpZiwpK3wxTLqyk+gwNusF632iC2/4NxZl9M/B8zwduAsW0p
 CT45qQbCXFo6qEzQ2GbZC7exz2/jIFYLeFJd+77Oj1lxUOgzeF/DAj0rRdIo3hVs8gRYyuxJtm7
 8zXlA+5niULTWy4aQPjn2DLCnYSMXJJs4CTV6cKcrrGiJUdElyS+qVC+2X5W7d5o6KpCS0C3e9X
 QxV1rWLBE698PumxdTFe63MvT5r3W73WK70ZzvdxqCTFnrMYeNXH03cRJHReKTSr5YZ9cWqtGPi
 dsMxCGc/KFnEi8REqHd4IkaBo0qHwvsO/2w3qqnxJwKIFBjsoX8TR5DGWXDhvUcM4vEymmCRBRt
 iAM3IIbpvXACXayQeL049nTIihwJ+Wssix+oPF2yJrFjqvw10dWo7ISKBP04OMtf/ZT+et5Zpl3
 JPBA7zOqkeSUC/0s2APZdZ9uR4TOJ6MaDOco1kjI=
X-Proofpoint-ORIG-GUID: sE9BQTL556L9wJObkSwIa2CTJq8RIakW
X-Proofpoint-GUID: sE9BQTL556L9wJObkSwIa2CTJq8RIakW
X-Stat-Signature: rpq6pugrfjw7w8m8hbzfzoedcyqp6kga
X-Rspam-User: 
X-Rspamd-Queue-Id: 69809140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768747933-348438
X-HE-Meta: U2FsdGVkX1/72eDaU2Y39z91/SBxhjqod45EJa87+bfnfNUbaezEm+Nw/8XbAg5YOZyqv0BSef6tja19CRhjvsa3u98Hcs0D8D1JMrYpRpWDxUr8zROtamecg3lXfRopVdODvtSIk/cIpo/LkVJ8Dm4tr1K2Tk8s/XI15soGenTjIVlGor0WGpZUaD5kxoHprMJ1gWOhdEZZVvfBMuBSIW6upGeXJdSFtEMnrdyFqRYhp8qpz8tJ7dN7oWN3iDAYJUUtWQHPogAG21xS5OskeJQRFsEPlpj2SIQ2iTmtrbfuvX2n5YvZjEuZ5nKcoDg7vS2JNggeVeSGQbSlJypg4ptzAvWWJxhyl2R5kf3RbsNVj4P924hacYYBQL5d73EnDXo17msK82ohDI35gwM18kM/gUDy0C+m19SLRbWlH+DjuPM/vE4yvruOafqqi+JYg61tBfcm6yAaCHpCqJVaGKuUD9KNOw+aCycfnBs6VPAAoeUgfhoYzEXf1Mh8fBcdMrQPwzruW891Vga+L2IxpleuCu6CRCmaVgSNS7kEwmaNwziajjNJeIdLkzkvqhkFWERt3DXZP3pXLex0/BlaPG0rOZer2Dt22mxsGzUfzXyCvxXZhfS7YPwwghrfA46aNtV8EjGjpTMm0PBsBmdCN0e+FBXwKB1mk+EzlJY6jef4zSa//o9IPl6VQOfhswGmZoCOtlC699mgaDwS9zAdPXq+Wbr1YplSPgQDcrC6PLBFCA9aUMFV0weKnsY9WlVu25uijFzFOqqhDExunGmHGJZX7ifBMYJ1OBAZ+9bAcl6/tsJV7K8xnYBisctjPvvz4Bz+n390HYxTFUSV4PGtpTaEA4G33xuruu2162faeohf/SFeVg4/dQHvcwJS/4XsuTV+TvgJjEuwEi7gQXdeT5P+rdiNMqYW15FIFcagr68L1TGlCJl5cwzmUvIN4oxLJ4j4tZkeS+ZGNnkVEyW
 TIMSyzOu
 ONRdZoAJGCku83WLO7LbRO+ikutFIXQVpOXlMuK51fNDTumy/2n0DP804S51B9Nj1+2o/N56ExB2naxtVpH1eU4PZTIe0yWk6FKWu8TX6H+t+WN2sVfRkpO/RlrtNxBZ28M5RBk3xM1bZu6dvep3ois48lnmNEvhCMrpOjnOsGqT/aEGBi3aPxJCY1H65t5pkcfBLXXviof9rCWDHwgbH5Oktk54c3obBK6S1W60pQPWF4IdiSZuVkyBezO4zQG4z7spVV1mt8fcP8ViYHpWqs7NBZqG9X5UZpSeFWCMtYEsbC4sBQc0kjD55YA7nzHlty8zl0A2ZAxPd/6j10XNCDwbg213K3R/dB10iVazcq4Z3ysi05N/GnDOWVYaqeHz6N4HZi+vx4mdlLbiZkRy9GXtqGVE2MuzoxRWQi11eKt/qE0NMQilOmcEXoiNCh298bfxG+2yPGRGEqPi/8i6w1KEoS5TFTLnJaN3I0cJEKy2zeAq8e1VKi1D14WTrsvxg9tTTLsPI1rVZGxyVh7zRGCvffyw6Rz32w7alec6Mb59tOjdX8UIgPaGZ6LGMo2HNb7KAcWXZ/VxYfHUWGYGt5TFGMUnjgptebUI71xvttqp0MvkAtkgHBR8gZfmc3iZeSRx2+9U5/8IN4PUN/g0tAEB8hQvc5s0RYhJ3kNH5/HgBQCsvOOSgCsOmYWmh+PqVWCyuraZijisdikNThgE9tHyvXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no reason to allocate the anon_vma_chain under the anon_vma write
lock when cloning - we can in fact assign these to the destination VMA
safely as we hold the exclusive mmap lock and therefore preclude anybody
else accessing these fields.

We only need take the anon_vma write lock when we link rbtree edges from
the anon_vma to the newly established AVCs.

This also allows us to eliminate the weird GFP_NOWAIT, GFP_KERNEL dance
introduced in commit dd34739c03f2 ("mm: avoid anon_vma_chain allocation
under anon_vma lock"), further simplifying this logic.

This should reduce lock anon_vma contention, and clarifies exactly where
the anon_vma lock is required.

We cannot adjust __anon_vma_prepare() in the same way as this is only
protected by VMA read lock, so we have to perform the allocation here
under the anon_vma write lock and page_table_lock (to protect against
racing threads), and we wish to retain the lock ordering.

With this change we can simplify cleanup_partial_anon_vmas() even further
- since we allocate AVC's without any lock taken and do not insert
anything into the interval tree until after the allocations are tried, we
can remove all logic pertaining to this and just free up AVC's only.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/rmap.c | 83 +++++++++++++++++++++++++------------------------------
 1 file changed, 37 insertions(+), 46 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index d4e41a02a8da..b07e709284a2 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -147,14 +147,13 @@ static void anon_vma_chain_free(struct anon_vma_chain *anon_vma_chain)
 	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
 }
 
-static void anon_vma_chain_link(struct vm_area_struct *vma,
-				struct anon_vma_chain *avc,
-				struct anon_vma *anon_vma)
+static void anon_vma_chain_assign(struct vm_area_struct *vma,
+				  struct anon_vma_chain *avc,
+				  struct anon_vma *anon_vma)
 {
 	avc->vma = vma;
 	avc->anon_vma = anon_vma;
 	list_add(&avc->same_vma, &vma->anon_vma_chain);
-	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 }
 
 /**
@@ -211,7 +210,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
 	spin_lock(&mm->page_table_lock);
 	if (likely(!vma->anon_vma)) {
 		vma->anon_vma = anon_vma;
-		anon_vma_chain_link(vma, avc, anon_vma);
+		anon_vma_chain_assign(vma, avc, anon_vma);
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 		anon_vma->num_active_vmas++;
 		allocated = NULL;
 		avc = NULL;
@@ -292,21 +292,33 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 
 	check_anon_vma_clone(dst, src);
 
-	/* All anon_vma's share the same root. */
+	/*
+	 * Allocate AVCs. We don't need an anon_vma lock for this as we
+	 * are not updating the anon_vma rbtree nor are we changing
+	 * anon_vma statistics.
+	 *
+	 * Either src, dst have the same mm for which we hold an exclusive mmap
+	 * write lock, or we are forking and we hold it on src->vm_mm and dst is
+	 * not yet accessible to other threads so there's no possibliity of the
+	 * unlinked AVC's being observed yet.
+	 */
+	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
+		avc = anon_vma_chain_alloc(GFP_KERNEL);
+		if (!avc)
+			goto enomem_failure;
+
+		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
+	}
+
+	/*
+	 * Now link the anon_vma's back to the newly inserted AVCs.
+	 * Note that all anon_vma's share the same root.
+	 */
 	anon_vma_lock_write(src->anon_vma);
-	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma;
-
-		avc = anon_vma_chain_alloc(GFP_NOWAIT);
-		if (unlikely(!avc)) {
-			anon_vma_unlock_write(src->anon_vma);
-			avc = anon_vma_chain_alloc(GFP_KERNEL);
-			if (!avc)
-				goto enomem_failure;
-			anon_vma_lock_write(src->anon_vma);
-		}
-		anon_vma = pavc->anon_vma;
-		anon_vma_chain_link(dst, avc, anon_vma);
+	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
+		struct anon_vma *anon_vma = avc->anon_vma;
+
+		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 
 		/*
 		 * Reuse existing anon_vma if it has no vma and only one
@@ -322,7 +334,6 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 	}
 	if (dst->anon_vma)
 		dst->anon_vma->num_active_vmas++;
-
 	anon_vma_unlock_write(src->anon_vma);
 	return 0;
 
@@ -392,8 +403,10 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
 	get_anon_vma(anon_vma->root);
 	/* Mark this anon_vma as the one where our new (COWed) pages go. */
 	vma->anon_vma = anon_vma;
+	anon_vma_chain_assign(vma, avc, anon_vma);
+	/* Now let rmap see it. */
 	anon_vma_lock_write(anon_vma);
-	anon_vma_chain_link(vma, avc, anon_vma);
+	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
 	anon_vma->parent->num_children++;
 	anon_vma_unlock_write(anon_vma);
 
@@ -404,40 +417,18 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
  * In the unfortunate case of anon_vma_clone() failing to allocate memory we
  * have to clean things up.
  *
- * On clone we hold the exclusive mmap write lock, so we can't race
- * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
- * anon_vma's, since existing anon_vma's are what we're cloning from.
- *
- * So this function needs only traverse the anon_vma_chain and free each
- * allocated anon_vma_chain.
+ * Since we allocate anon_vma_chain's before we insert them into the interval
+ * trees, we simply have to free up the AVC's and remove the entries from the
+ * VMA's anon_vma_chain.
  */
 static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
 {
 	struct anon_vma_chain *avc, *next;
-	struct anon_vma *root = NULL;
-
-	/*
-	 * We exclude everybody else from being able to modify anon_vma's
-	 * underneath us.
-	 */
-	mmap_assert_locked(vma->vm_mm);
 
 	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
-		struct anon_vma *anon_vma = avc->anon_vma;
-
-		/* All anon_vma's share the same root. */
-		if (!root) {
-			root = anon_vma->root;
-			anon_vma_lock_write(root);
-		}
-
-		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
 		list_del(&avc->same_vma);
 		anon_vma_chain_free(avc);
 	}
-
-	if (root)
-		anon_vma_unlock_write(root);
 }
 
 /**
-- 
2.52.0


