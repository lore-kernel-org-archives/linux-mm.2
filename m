Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B33D41149
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 09:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56E226B008A; Thu, 15 Jan 2026 04:16:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558EC6B008C; Thu, 15 Jan 2026 04:16:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4063E6B0092; Thu, 15 Jan 2026 04:16:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2CFCD6B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 04:16:03 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9147140266
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:16:02 +0000 (UTC)
X-FDA: 84333641364.15.81C1F49
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6CD8C140007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 09:15:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KzyBTPkv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SPVlB74k;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768468559; a=rsa-sha256;
	cv=pass;
	b=ihkcLmRW3PSECCLlI+YIA8dHeuKzOAo3jmQ614D6d9O9fgm1MC+vUcJwfw7Xlx/4aHnZqP
	Uq5ZVyqIAu1k2GdkMJyWbNJ4ZtsLo8K12TXngUfi4cJDStCo4ao6sfV1ShXdvq7BEUzRWy
	YQRy2vy3Q7IcAhEaMG4nU8M0teBMePg=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KzyBTPkv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=SPVlB74k;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768468559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APWZZEJPNH0Uv5DnEuRoJkYmrIRctPL4dkAngW44s9Q=;
	b=JNQCQ6OTYyDnha3NoVdutmT96oUMhWqJPAsPoi/yiQaMXSHMgnR6mUPOanOXIK8xdxnrh8
	HyQLgivWmQQ+6veCtXMdoZ5gCXFiF3cROOpQa6qTvRDqeAjgxCdVVW+n4yFKAwgviH+gKZ
	cIP1gJOBQZhPjuTQzOLqiML0/IaZpeg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60F57hSV1940271;
	Thu, 15 Jan 2026 09:15:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=APWZZEJPNH0Uv5DnEu
	RoJkYmrIRctPL4dkAngW44s9Q=; b=KzyBTPkvXp6iwdauVlPhE7fbvNYXOpytya
	aFLnp6J5/BdHghBOV4Co+HSx3gGYjHPcfrZbBSsAcjTxlXdQybW4CZx7IVQX4OsQ
	+HBhgX4Ng99+BnH4Huc0psrpXdg5nUSCtuY9z71kBykI3mOu/g6+zTD6cYmYARAM
	9/xF3apHhHKfWXLg9HxW250Zckd93rYIIIRxs+lyZQ8WL6YPHIfk4Dry1gXcub+x
	U0diHesN3XxWIQ7FngBPk5AadAPC0hSz3sMt9/VvgoFD+t6/Lb42Evry0MCCCjey
	3RJ4FHEl4W4kJTp3dvyqiYb6IeQ5BoY/ArnMWqfiIU6xQv/iC3og==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bp5p3aevc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 09:15:54 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60F6a5mP008138;
	Thu, 15 Jan 2026 09:15:53 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013068.outbound.protection.outlook.com [40.107.201.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7avgkc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 09:15:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=guC8aj45lfESYe0fcRPfQFamYroRrZhgJCp88PogFAfpJHf+4Uc18ULs0brFw5vqN4eTzxylZ/FjowI61+FBfYknqC8sDF3V1w7Bqvupyig4PovTY3LIEXmnV1UJXjKVtZ8oGMsQprdZyOjMf7T6L2qT8oISk8HkpGlB94jaIbXlozghvfJ9NK0tECioPYrSZl9PKTOCxgIEODjIZQLSPy/C4HOVmueZPKSma6gnk8tzeSQ/olR0piT2VNqVGo6JNt4BGcurhirrgdD2ZpGik+rJ9mpEAlnd8e/gHcGID0GzIdm4w8udHF4FTe+nZv387p3/GeWESxTLBD+1cyHpuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=APWZZEJPNH0Uv5DnEuRoJkYmrIRctPL4dkAngW44s9Q=;
 b=eE53jR64HD6+nrtMRV1JdQMNquYz7Tqj70BXb480wXMTQuAo8zJghRRba+O8RNHqNIjJbPo4v18X04V7/i325Xl754b9YkTzsveC4EnmlkCn9PX9B5hpCATWiHAQzatYevsmSwPCrc9L1/25JpLFMdazava8+Pcn93MH5gVBQ5L4XV0LxnXmXq8JDysORMBGcrq1rNT/2R2SRS+bNgRsF/kb1DyCwe8lbAPgMB1lsdFm9D4awPJ/VCUPtaehhyKteDz0quU+EbbkloxWgiWN0Rkt9/K1raM9m/OTRDrKg60M6kZcKZ9i09Y1Qy2IQGz3bd4/O9jAQQKYWcUgEr10kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=APWZZEJPNH0Uv5DnEuRoJkYmrIRctPL4dkAngW44s9Q=;
 b=SPVlB74ko1ZxnhBihk0Rx/6OPrUcm4g0IRC9uh2Bi+p4nACr6qvzF4//AzTza2C2pWSV1/6KRzrRllXNo5YHensVsb7Riz9JyWSLmz5XtjV8b1U7BZKcezIuu3XOYsJh7ZJ2kXguAe597g5wxrNbFjletp0TAjIQ1zeyYgJ1X8M=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB5970.namprd10.prod.outlook.com (2603:10b6:208:3ee::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 09:15:48 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Thu, 15 Jan 2026
 09:15:48 +0000
Date: Thu, 15 Jan 2026 09:15:51 +0000
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
Subject: Re: [PATCH v2 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <b0890a74-96ab-478b-967c-31769a02e509@lucifer.local>
References: <cover.1767711638.git.lorenzo.stoakes@oracle.com>
 <5f55507a877028add5fdf8f207f5e333c7a3fc85.1767711638.git.lorenzo.stoakes@oracle.com>
 <6fb9d6b4-ad39-41de-8db0-aa41a6406378@lucifer.local>
 <20260114135911.ed54bc17bf1e467ad96f5b4f@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114135911.ed54bc17bf1e467ad96f5b4f@linux-foundation.org>
X-ClientProxiedBy: LO6P265CA0008.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:339::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB5970:EE_
X-MS-Office365-Filtering-Correlation-Id: e5a3c80f-b518-4ff2-c130-08de5416ac17
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Wvz6dvApoyKDW/5hLSwpkXc2wwSkojtrlJpUIT8vTjHUI/Fgi7K4P2PDeray?=
 =?us-ascii?Q?2ZL+e56wH4KBVznNf/3LuXab6Nh4VzcONxPTN4HQE6ZbUhAkrBkvdXaPWrhO?=
 =?us-ascii?Q?4sYeAUMAJoygZeYtG7jIDq7XwiQymMDvQ3M4hZ8w/W8jYbc7KpqvpdA0qfXI?=
 =?us-ascii?Q?A3In8dvA2biUE/eG3sSygGHELYMMdhQ7+e60Sf6xXTJBhn9JiKjs9AG6eSFe?=
 =?us-ascii?Q?MIclseF6WMy1YC497nz8iIaL4fYfX9BopfTyC2hIg4QSs5jKMKfTsj5HykvY?=
 =?us-ascii?Q?g3jLYB0oMNux9lc926xsR1LmLGGQ8kWt+1mXdH1n9CObpFcZ6N0x9Wpu+r3X?=
 =?us-ascii?Q?XEn5A67rWQd3Bu2XVi7VMruf/fJH0svBv5m7TYSEiXccEbnDLUYkOk8otT4+?=
 =?us-ascii?Q?3C80gwzIUweyIwiiAIDZHmx1uxg+Zmb98G0kD4QwwaFQrCowHIEBvsapK88f?=
 =?us-ascii?Q?5Ha1kGkDHCeOcDb3sSwzMSpKR+yesfv+9pQpg2+e16lXvAkA7lSHqtgJbqOe?=
 =?us-ascii?Q?RMrxlPVEAdggnNfzjM5a+7exIAfkoX501AmcQFqZR/NtEy8TP6KlEJPcAucB?=
 =?us-ascii?Q?EM/N1US9THLFRqkMj/aUIPbHTbqRCfN6iIQ0Yz1yWTPnf1TCbkql8hClDfxq?=
 =?us-ascii?Q?z43ZLr2iQVVgtliKhKvLVAbsfkZ2Xoo90+D+qS3iS4NvN8NgPWvQgj80Iar0?=
 =?us-ascii?Q?nRu82HzCUrB+hk3JKxAWKb5XYZQpkS+UEBObdM4enyUeD7UCURmueTo9WEtW?=
 =?us-ascii?Q?A6Rs0Gqo2+cELMXWS/Np2K6rFaq0/NLThFZDvVCO1KfMIKdMoufM27qQxamv?=
 =?us-ascii?Q?pFXaflfkjn9o2I9+aWQLnnxIVh3hWhmtXxy3ZR7vRf5ELr6OLgRJzqLBQDAE?=
 =?us-ascii?Q?nwAieVdC8pZF5vhn0uX5HV1JaUoLQMxRGhqn0usjYYWrPs1d24MUei6lAcmJ?=
 =?us-ascii?Q?aTrht98v1EJKxEChtGxmj1qL17XeNnxsuZdmB1GECWpAngc3pi+dH5La8LiC?=
 =?us-ascii?Q?oX+HzBuG9rrK/Eir0GzG9BxcGA61FdRmovZQWCBmVCm/PlB6Dnt+6DYmxSx7?=
 =?us-ascii?Q?F08dPWUeLbcCQmj1twOJCZ31tCGeFlYPF2wKtHTtCKlcDd6RnYx47IePKTY8?=
 =?us-ascii?Q?QG6ecXINj/qI2tOzApTjTk+Xuvjz29MkqmvZ/mP+R1FneDhjPcrav3uqU5tP?=
 =?us-ascii?Q?woxDN0jtXEFPU0Bzasay3fu2MNruKMmr8DkubY1lP+AspiYdBxfuMzewVRyr?=
 =?us-ascii?Q?a5bEuUqoEC0aFL7VRy7kxab1tWm5x9U9iDZNiODL3JraTq7k9/JVgUFOWDcn?=
 =?us-ascii?Q?+Q9nrf/XKk1HpUSLhQOh+V0RenvVxws3ueS+gzYTCLXIIwlYPNTDj+2yaF1R?=
 =?us-ascii?Q?/D98pMu6i8ANu5ebOD+ndpVFsLA7ZeGC4AzKHV7alkT+vjBoMRHABuuEU79E?=
 =?us-ascii?Q?nkbOlKRS2I/C++RQrNdFv9EU4Til/L2s8yKi4VsGect1PzX8VOh0ixKjvokY?=
 =?us-ascii?Q?9udcU2cgqha95Q83yBUp8do/EZnuk1hCUzWbXMAtzAf+2ilu57iKOh81QLiJ?=
 =?us-ascii?Q?1o6DlV+H2nDAUxmNQn4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2wlZUMVE6avPcWHvYyLApOQZfxN6vcNMA/efW3zOndWdbaOoysOrfghmNUCj?=
 =?us-ascii?Q?x6GPe7+OVU6oH4dcUQULD0lZGdasbr2Hi6sLCMDPhc1BcccccB+lic0vDzHi?=
 =?us-ascii?Q?hlrZdwTmOfuhb8zgNDSwNOooBtaGh1w2Yd3ndPHrHhCTIerSyWpnxXu+94Nw?=
 =?us-ascii?Q?OLPIbOYRgkSYBPp9WoJy+nDeKzWBmq9Ir6B7XWJ0kVqSOjmnBnVfMHwxUX/D?=
 =?us-ascii?Q?g5zQC5unNI7y5PIZIFJZv61zgqZj5jokhkSSV76H6kOPPHdFQMqJvFMiA0aI?=
 =?us-ascii?Q?U+L9LsdvltRCsNTScjt5ugDhsCPCZxSHPu4mVIYRsFIGnU6CFSoWyn8A3Nhy?=
 =?us-ascii?Q?jpmlVallT+vJVcygqehR49sPoWmFDB+ECXrvaBswwVbpcDM/WqB/F4pvpE2M?=
 =?us-ascii?Q?B9xD5mbiNPg1eRDtDDm83SAzogm57x5EtCqvFcWn4k2tdDZX8xQwbx4aphYd?=
 =?us-ascii?Q?fQ8PX/HkoyRLyUfsfrsJuzjT78i0VOjXxVvy4DK8hJRYgHs8DDAGx7CFtwR2?=
 =?us-ascii?Q?yj0PvzpNLRoksoRBkCz7zKoAs0UzQoUCiQwb1bHEmr5VmAJh1/46zQ79qJlb?=
 =?us-ascii?Q?kzv5D0f52LsYmB1GwdfRIPWDmlomugdu297wwESWz+m//HKK6RjaA4Mpcg19?=
 =?us-ascii?Q?+4+PkJHWxTXFMqATcVNoSjCgXUfJbwaCenEHwNvqVcmk4xRnHjFpzcFJFeYl?=
 =?us-ascii?Q?ut4hCw5wm5jUkXtx4bFSKTgb7Yrj2fsnB10qEbt270L0B/Y9ZA/MPDsHXekq?=
 =?us-ascii?Q?9rh/abGnFcmnquWkvjzusqt3cd885DY8PnwSht9JdMJIh9Q4N7dzTCIP3iWe?=
 =?us-ascii?Q?Mepabv8sWTE/6utcV0Jj3/TTPPWWOjpBpjLK8u6plsdTuN7jyqMdLd0aD2BK?=
 =?us-ascii?Q?vIfwX/UzGYQPSUjdik8g03Oejlz7vEiJU7jI2TdpyU6bVt9exEoHYq9HZatZ?=
 =?us-ascii?Q?LIBGZZSFERjXk18OzDi96sUTHn8KAkuzaK7SFeovQ7eMEpVtjVhDB0iJ2W6M?=
 =?us-ascii?Q?8Ocdt+clSMR55EuNAfCp65M4bUTrH15fD0O1Sj4S/6tAA8KrJEt+o37IZFZt?=
 =?us-ascii?Q?/UzJC/Fcx9dse4MyR9X3t8oAYfd804XuIanM+qHmK81isWcvC5rUsjY+BlxB?=
 =?us-ascii?Q?iRfkpOHX8qkBxkp81TEID3jksDlBsX3DqlTbps+AFzv6ZGKb46nFfe9suxkV?=
 =?us-ascii?Q?vfBiUr10LDDH+X3yzv7d1/PNGaZOh+4XpyiU2444yEjzK/boZjYao9DeO5aJ?=
 =?us-ascii?Q?1PPQI+vAYqTMkIkGrMJA6jgXqgmQIYP+TrNmUOpxxjPth/5P5tv4Xi2PLra0?=
 =?us-ascii?Q?xlWDBIgeELX1D0D+78gWKZcMfOrItKV+ziLqjJ/bQTX7XdKEu2iJ+dtdcUIe?=
 =?us-ascii?Q?1uYStUjRg7XWGtbcP1Mq5d2mXbMngdvZFHx26rymRdl/PrscPHu/MuzKFqT6?=
 =?us-ascii?Q?PRA2wpFIkEQ0mWB4L/aEXvhElJuaLhvCDZf0xviLyWr+rLdPHpB6iv3l/8vk?=
 =?us-ascii?Q?40tc9rklk9jkPlakdVwVcwKwLJ+TtgiGfOJD7lGcDYhOkIeN3809yiGZoxJh?=
 =?us-ascii?Q?/mhQIdLms+BqSmxHdi90Ru1eILwEbDmpWyPPljwxH7atFkvl8wdbCjFH50jV?=
 =?us-ascii?Q?ybG7PLbYD2ujXIC/AA6yUjjZMP+86TSEPQnp95FwkV+QAyEv5wyZuuY1TFfw?=
 =?us-ascii?Q?BBhjulA9DIXraS6O9+c+CR6+BzDeMOiPVfnnmSbpSU/leMGxGA7cGJCAsPE6?=
 =?us-ascii?Q?aiA94uVHbvR6471Bl3ur+KE0qU7uZP4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6zmXIsNVSRJh8yTI7XaRNxdvAlcW3p6oeWrRQDTsVEpJBA3q1D7SmFfdZrWFpSE4LkI93eCBZ8SvDbt27tHOSQVm92KvvC1NFP5p9wNxCMmYr2+XDfl0ZE5AeMuG9Yh6X2CSxK2rD2HnwisbPWsU/hFIyedH3EqqJ+3P9kSuFM6o56rV/5B3SG2CnEkck8Sq5O1W0ZzVaxC6iQUhCbSYMyA57oJQXgTvSMTzsTCtiH5fyqwA3sfjiKsi7agtWRh3S99VzFMd0ZY8dU6ASgq65/jjt8YmMD2rr71C8N/X4QkcvNJm2GF1QwBkZOCOqqazEpnTRyaCRfRoz0xbhCrHmPtJTPECTjT9iYwwN1stPzYFmKhGbfwSfrBDGEY6dK+p8vNRQIOpKRR9tJeUU+MAJTlDksA/aKJKjVA+04RoDEGEUWaNnQGngMu+iu1B72AKQ9T/ToLYW6BLimF7oZ6cQUwa4HZURNkP4MduoHAtL1YvjFCB6PHCeKirRTCAZMpgD264o8Dmxy/yIzRZHJ3BFWVfgfNuDwkLHkcAy43Z0AE4OvNwY6WgLjVOCVx9sECkTLYFxmrrrhxcGVi9dOq6zaFuTcZKL27iS9G2MIyo74A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e5a3c80f-b518-4ff2-c130-08de5416ac17
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 09:15:48.7247
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: usAc/Yc9yd2bA9tDEgN3Lub/P12Ba02LHVb3jb0Dpmd6ZYmDC2C6hlEiD7mazFx2LZkRayDZSfQUWDIKIch9Es9KepI7uLz+3nIDEVwVGbY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5970
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_02,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150064
X-Authority-Analysis: v=2.4 cv=OJUqHCaB c=1 sm=1 tr=0 ts=6968b04b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=P8sxb7NWH0uDY58xTVcA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: RZQ9zW0Uoggu26zpM6YjwCfPRcsx0baF
X-Proofpoint-GUID: RZQ9zW0Uoggu26zpM6YjwCfPRcsx0baF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA2NCBTYWx0ZWRfX3EJh0Kmf2quw
 6VCx0A1V4Che+7smDWihc7DjXSl7mQ5YGgcZaGmBmYWpnfyT5+Weiz/5KxrlYhnPiCXl+oYay9N
 LUV0XaaejfsDr8qvp1vR2VQEhEfw9nJj+0b8H0mKsVQ7PuoKeYO5+pibc0P2myoCxn2WBDpFKlv
 UxRpoDdC6i5dD9XitWfvw/ZJChsVKIZ+KGXJ3mGcgaE4YozX3Qn3ZrGI8MFN8pcp74O7rplZw8J
 fDPWUemo1/fgmgfiZQsnNICTra881Hx1NSHF8Rzz0MTVXEk/rfu4QJYdm5PDetG487LsjZ/bm3v
 PhfOLewMRVhYn4iUJmngj/HLZGBT21AXyIuyoWSxRgSFkiHk1ajhcaHnmeGLzNirXhw5JLABB6o
 BgREIkC++uj6cfKn2Q7LkArcV86KHHSXjtYDRj422B36P7c//2ttzMh9My79IzUAzeDMH9CsAZJ
 ANp2JeTg/3q4XTbAf9Q==
X-Rspam-User: 
X-Stat-Signature: 7z45n9khczn3tin6scmpmpa1to5daubd
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6CD8C140007
X-HE-Tag: 1768468559-423327
X-HE-Meta: U2FsdGVkX1/Xypop5YcdqqLGPvhrlkVU97VvfaZxf3D0Vq+DgRBSNP06oH1gS5sOc1c3XUw+FgJZyi45USnytg9MuHtOFwX/SQlxWzQ5DUqn0VKAcjkRUE6qUCfDXerknA4pm1gwboehs44prIrtiyzRIKhRvNQQg8tBR+GJnEjnmuZy0j9GKbyM1i7OCyRW07Ka6svGjIZVj3IZ+CZVcE5pl9V978gMo4pE8XCIgCmOusQTZ2phNDLYGKVuC6xhB/16KCMnUWAnr/RkybuLFA+nXDk9qvfmTMGCeacU2x9wSqC6W+nYscZuCJX2/6Nl2GwgNjMEL61IGsKmnizLmjHMS5VBqX//wmGjSJdJTxmirOLEOgAE19AE4P7t5M+eIv2vyIRwS34IIKJ4mB/gAalA/lkdWUZUIwoCiQBHso0u3Wor4Dmzr+YBooXdFIVI18aD+Q7NKAX9FGfdYO8ouBTHsYqTBDoucraAj2i+nUl5A96QX6QPVBpCczUSCreTAMCFYBmrAe92j/+xdpRNdV4N5AnmC3Gwxb8n0P+LJX6g17jIw8Y1u5a5y/7Nukj4OV9a7BbrD22W0nZzF1ittBJqAxC3jUs6d1p/2xtGCSX2Xhu/oWBrYU8aFFbBsb0PLv4zHNlbrkdv7KxoQi/d/qSvxReX8pZ4n9cosQ4KQXNe62VK2qhtjHJZy079PtvpPRh1uYdwTfESs01KHIyZMgX/yuv+xLLKa3dGSa72F1Jcc0bLihSSjQZz0e7qgCGVe7qg5N4n1Hpc66e6NWNokU1tccbk1P44Uk4xsRmCNh9rRJ5PLsJbomipZpY0ut8LF0x7JiG+/KWkID4Anj52fC8FtW/Fd4poRszYJAH7oIm2/HDi/GyhHu40Y7q64RvHm0ZxMrDLld7v/gPpPVxB0yPvgtbFXv3ywH65fC/Gqg8T3NYgS034a6HCEU+eaubqMYNHXB5xVt9sNuMspml
 xRLoghj5
 0GRawRcQCKK5a86aQy8C2wMQZP/ZgPeJn8uKol52N1RQWjyPYm7sYz9PQie3cUaTWwoQbc1KnlJxFysANDvM96egCiX5Oy8WxfPg9MixaJiU3qkcdlgS/x3VE8+Ip3QkUVIAlma/5kDU5tj7rW+0gOeUUpZvvMcCXMn6+raN9h8WKw3CfpQqslTHNhq4FOl1X5IN5B02CSzJDEhkozzk1vvO3unynlFmNYRDiziQbKEfPsjQeQXqbgF509VkURCYw6Fg7dSvPVvxrKInbMcd4xKqPCNwHwKejjU7Od0C7p8mRY5HjHqDdGojx82nrTM5YOtBwzSt2K9JKbHnab7QySkhnJF7h+npIevY99tfXlghRLrTe2Qs0HXpTSq7j9WTHqUgPDws8/D7whpL4DRqphRfzL+me0iAJ/kMMNy1KOdFbRjXC7tP1zWhSLyQLTRdnKs43KT0JC6V1X/5w5P/Z6bt9AUSdbZIFN7yj372ouSgwNnl7suEScTIUsIloPN7/ptv0E6eZD/6Pqdc08b8JVri/n321Kd+ejNJUQ16wKnRU0S+GDnmLOB23LgrUF1RP6j0y9AZ4h9q7yX1QdKcT/BUI62eeSyCfTxCEkEuhysA3i4WKN3lAdEoLqBcpWMZe1Gb8wi2i2lCGAYx8mDB/mVGf0RatOsWgLI1e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 01:59:11PM -0800, Andrew Morton wrote:
> On Wed, 14 Jan 2026 19:02:20 +0000 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:
>
> > Can you apply the below fix-patch to this to fix up a rather silly
> > failure-to-unlock mistake that Suren picked up on?
> >
> > Luckily this partial unmap function is unlikely to ever be triggerable in real
> > life, AND more to the point - a later patch completely eliminates the locking -
> > but to avoid bisection hazard let's fix this.
> >
> > Note that there is a conflict at 'mm/rmap: allocate anon_vma_chain objects
> > unlocked when possible', please resolve it by just taking that patch and
> > dropping _everything_ from this one _including_ the trailing 'if (root) ...'
> > code.
>
> No probs.
> mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible.patch is
> now

LGTM, appreciate it thanks! :)

Cheers, Lorenzo

>
> --- a/mm/rmap.c~mm-rmap-allocate-anon_vma_chain-objects-unlocked-when-possible
> +++ a/mm/rmap.c
> @@ -147,14 +147,13 @@ static void anon_vma_chain_free(struct a
>  	kmem_cache_free(anon_vma_chain_cachep, anon_vma_chain);
>  }
>
> -static void anon_vma_chain_link(struct vm_area_struct *vma,
> -				struct anon_vma_chain *avc,
> -				struct anon_vma *anon_vma)
> +static void anon_vma_chain_assign(struct vm_area_struct *vma,
> +				  struct anon_vma_chain *avc,
> +				  struct anon_vma *anon_vma)
>  {
>  	avc->vma = vma;
>  	avc->anon_vma = anon_vma;
>  	list_add(&avc->same_vma, &vma->anon_vma_chain);
> -	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  }
>
>  /**
> @@ -211,7 +210,8 @@ int __anon_vma_prepare(struct vm_area_st
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
>  		vma->anon_vma = anon_vma;
> -		anon_vma_chain_link(vma, avc, anon_vma);
> +		anon_vma_chain_assign(vma, avc, anon_vma);
> +		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  		anon_vma->num_active_vmas++;
>  		allocated = NULL;
>  		avc = NULL;
> @@ -292,21 +292,31 @@ int anon_vma_clone(struct vm_area_struct
>
>  	check_anon_vma_clone(dst, src);
>
> -	/* All anon_vma's share the same root. */
> +	/*
> +	 * Allocate AVCs. We don't need an anon_vma lock for this as we
> +	 * are not updating the anon_vma rbtree nor are we changing
> +	 * anon_vma statistics.
> +	 *
> +	 * We hold the exclusive mmap write lock so there's no possibliity of
> +	 * the unlinked AVC's being observed yet.
> +	 */
> +	list_for_each_entry(pavc, &src->anon_vma_chain, same_vma) {
> +		avc = anon_vma_chain_alloc(GFP_KERNEL);
> +		if (!avc)
> +			goto enomem_failure;
> +
> +		anon_vma_chain_assign(dst, avc, pavc->anon_vma);
> +	}
> +
> +	/*
> +	 * Now link the anon_vma's back to the newly inserted AVCs.
> +	 * Note that all anon_vma's share the same root.
> +	 */
>  	anon_vma_lock_write(src->anon_vma);
> -	list_for_each_entry_reverse(pavc, &src->anon_vma_chain, same_vma) {
> -		struct anon_vma *anon_vma;
> +	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
> +		struct anon_vma *anon_vma = avc->anon_vma;
>
> -		avc = anon_vma_chain_alloc(GFP_NOWAIT);
> -		if (unlikely(!avc)) {
> -			anon_vma_unlock_write(src->anon_vma);
> -			avc = anon_vma_chain_alloc(GFP_KERNEL);
> -			if (!avc)
> -				goto enomem_failure;
> -			anon_vma_lock_write(src->anon_vma);
> -		}
> -		anon_vma = pavc->anon_vma;
> -		anon_vma_chain_link(dst, avc, anon_vma);
> +		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>
>  		/*
>  		 * Reuse existing anon_vma if it has no vma and only one
> @@ -322,7 +332,6 @@ int anon_vma_clone(struct vm_area_struct
>  	}
>  	if (dst->anon_vma)
>  		dst->anon_vma->num_active_vmas++;
> -
>  	anon_vma_unlock_write(src->anon_vma);
>  	return 0;
>
> @@ -384,8 +393,10 @@ int anon_vma_fork(struct vm_area_struct
>  	get_anon_vma(anon_vma->root);
>  	/* Mark this anon_vma as the one where our new (COWed) pages go. */
>  	vma->anon_vma = anon_vma;
> +	anon_vma_chain_assign(vma, avc, anon_vma);
> +	/* Now let rmap see it. */
>  	anon_vma_lock_write(anon_vma);
> -	anon_vma_chain_link(vma, avc, anon_vma);
> +	anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
>  	anon_vma->parent->num_children++;
>  	anon_vma_unlock_write(anon_vma);
>
> @@ -402,40 +413,18 @@ int anon_vma_fork(struct vm_area_struct
>   * In the unfortunate case of anon_vma_clone() failing to allocate memory we
>   * have to clean things up.
>   *
> - * On clone we hold the exclusive mmap write lock, so we can't race
> - * unlink_anon_vmas(). Since we're cloning, we know we can't have empty
> - * anon_vma's, since existing anon_vma's are what we're cloning from.
> - *
> - * So this function needs only traverse the anon_vma_chain and free each
> - * allocated anon_vma_chain.
> + * Since we allocate anon_vma_chain's before we insert them into the interval
> + * trees, we simply have to free up the AVC's and remove the entries from the
> + * VMA's anon_vma_chain.
>   */
>  static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
>  {
>  	struct anon_vma_chain *avc, *next;
> -	struct anon_vma *root = NULL;
> -
> -	/*
> -	 * We exclude everybody else from being able to modify anon_vma's
> -	 * underneath us.
> -	 */
> -	mmap_assert_locked(vma->vm_mm);
>
>  	list_for_each_entry_safe(avc, next, &vma->anon_vma_chain, same_vma) {
> -		struct anon_vma *anon_vma = avc->anon_vma;
> -
> -		/* All anon_vma's share the same root. */
> -		if (!root) {
> -			root = anon_vma->root;
> -			anon_vma_lock_write(root);
> -		}
> -
> -		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> -
> -	if (root)
> -		anon_vma_unlock_write(root);
>  }
>
>  /**
> _
>

