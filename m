Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578D5C87FDB
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 11:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03BF8E0047; Mon, 11 Aug 2025 07:47:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3D88E0045; Mon, 11 Aug 2025 07:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54D68E0047; Mon, 11 Aug 2025 07:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1EA48E0045
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 07:47:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 46E9A5259C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:47:07 +0000 (UTC)
X-FDA: 83764300494.12.8A53521
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id EE1DEA0011
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 11:47:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cIVEit4C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vT6naoK9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754912824; a=rsa-sha256;
	cv=pass;
	b=JofUhZNEDh4LMi5OU1nOB8B8jIAxxfZC1XsIAt7xuQZ8HjP3LyOMh70zK/HwT+C6DZoNsZ
	ZcQQ8z8aWuXkEH4vCsRY3ETqXb94/103cM6ttXwPCLy0ec0lrNur3E6E6AVmr8wat9SuzI
	M1aZzGapbG8E1qFOLlt6whc2Anbk9TU=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cIVEit4C;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=vT6naoK9;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754912824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1r4F5qjZ93uTVNgi5AR8F7s4Ljvr7Yc6kpXYv9MVjXc=;
	b=QDfhLDB0pUFbaG8iNDR6+YxyrvCFkmdB6sAuRqKMojbAlst+Y2mnFLVZCrgROFMT60BBGk
	QQewXqkVAc02bktRaRVJ9VdHmQRXpgX+WTKcoruBCNiQh+QAlNLYZ5HbAowkF5xhX0jboA
	G0b8kc5Sjcpp4RklyDkOh4cqBTTTdIU=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57B5uFTw010716;
	Mon, 11 Aug 2025 11:46:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1r4F5qjZ93uTVNgi5A
	R8F7s4Ljvr7Yc6kpXYv9MVjXc=; b=cIVEit4CiR1Leu5g3xcq6+ruZ2X6g4BqlI
	qxTsHaOAKsWNt+ovW2g9UMBk53DMCXzW8NVgZla5JGVUm712sUwxaXHA0DSlO7yc
	MUWntddsbU65JXL0a28Wrt+NZqS+c5oB71q8p+SdVmHiX7ztTmV6S/n+Mvb21D0D
	JxMCCUdOZnhDWLux/aKnx7mtgGI4nFCZB48COhiFMqebQ455kvz8ShPvkAiXeggc
	KU5ZOcFWaxIPEiu2b7A4eiMF+hbnxFowMw+qd9/vH/oaQcHttRzVUY2pzXvq8CAh
	t8qgzwaFZNfmzrTtcjyvPiABke6uaRzZ5SaWfgberC3eSNa+5SYQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrfta6x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 11:46:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57BAYV25030268;
	Mon, 11 Aug 2025 11:46:39 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvs8hhxa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 11:46:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Fj1SSXG8TSNrlPfCIXUSF+YjU0rorhhky+EvAdzfHyP2BohZDZzFTE1AoL4gi1+ygfrKk0eIm7B+9DldxNUa29nBBkQj7gCh67ZLXits5UPK32j10bpSpK5nsgW46FKPfYbpNnX0SNkBebhhB9gbeYFLgj8sSUtvyWqEti4ZGxZN8GoMSUuO+/phNdyoNXcqbrc9zYO7eWKBqXp/4Cz0yURdmAWL3906WgIp7Dh8Vb6R87tE1u1X7AL6axRg7rg7dWa52Iul/YbOx4IAPKZ1DCe866uVF0hv2wCEH/xo1njkDMLhW3OVMGsroBvQrB0/8OgjdwNkRPFSdoDsmfl7pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1r4F5qjZ93uTVNgi5AR8F7s4Ljvr7Yc6kpXYv9MVjXc=;
 b=L1tWlE50DPbEMYf9rjNyI6vq4UJPGbQRvhOSkYVx8Y035b93BZ+MG7jd9IhdLQdz9x66kD2dxJ8h9o8ylRZel/gV9ZZOiemkhEBVSdZMHjfOPb162qO27reFEhF/oJti7GvWZVUpHOIB2YAAfYJ9SsX/DtcdbWR1Wwej1QkD/sWufxNxEQkEGEtT7cdSX18Gf6omVF6bURySXMN7GNgZDbJE02LpqbeHCggjlo5RoJmgMDFmnm7rQC3wKI61H31ZuchfEG2I/a3v/+3atmAXuDNe1cEZXWsUgFTpPvoE8FiNGVzyAjyOPpewKnsuTR4XdRQy8uiM5dxEAEkG9hFwMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1r4F5qjZ93uTVNgi5AR8F7s4Ljvr7Yc6kpXYv9MVjXc=;
 b=vT6naoK9TGj5RG7WARhwO2FZVYXTs5Qg8mcgrdGNIYDRkFUCaUzl8qigsE3Ym+zkOFao+7fcJAHYxqe/Kw0D9f2WZvx27QNbbamrZ9on8NfLZxeiX2toiAIu65J3OpbdJ3WPyVb2y4YExE0D8krjWDny2hwWGSVpZ7cqCjSDdhY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8323.namprd10.prod.outlook.com (2603:10b6:208:583::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 11:46:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 11:46:36 +0000
Date: Mon, 11 Aug 2025 12:46:32 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Dennis Zhou <dennis@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Hildenbrand <david@redhat.com>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, kasan-dev@googlegroups.com,
        Mike Rapoport <rppt@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Thomas Huth <thuth@redhat.com>,
        John Hubbard <jhubbard@nvidia.com>, Michal Hocko <mhocko@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org,
        "Kirill A. Shutemov" <kas@kernel.org>,
        Oscar Salvador <osalvador@suse.de>, Jane Chu <jane.chu@oracle.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, Alistair Popple <apopple@nvidia.com>,
        Joao Martins <joao.m.martins@oracle.com>, linux-arch@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V4 mm-hotfixes 3/3] x86/mm/64: define
 ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings()
Message-ID: <9b57f325-2dc7-48a4-b2f0-d7daa2192925@lucifer.local>
References: <20250811053420.10721-1-harry.yoo@oracle.com>
 <20250811053420.10721-4-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811053420.10721-4-harry.yoo@oracle.com>
X-ClientProxiedBy: MM0P280CA0042.SWEP280.PROD.OUTLOOK.COM (2603:10a6:190:b::7)
 To DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8323:EE_
X-MS-Office365-Filtering-Correlation-Id: 490af8a8-13ea-413e-afa8-08ddd8ccba24
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RrAi+Voej7foU7JUDni179VemFNWWukHObgp2JdD0C66M7U1LtHq5dLGmHPN?=
 =?us-ascii?Q?vmA/wZ5Ax//yxblktyonxt+vTm1IxttI9ccyAe5qY61C/z08OBAHTm7KSmDm?=
 =?us-ascii?Q?j++5ii0T4m9Nkp5R+WwAXmEw3DauA0fp+tLuhHFEljGCfuBwq6D0wkEMiZzy?=
 =?us-ascii?Q?Tl3IDLNHKjbF4iNUz8VjOPAJ2gr1hNlx9WLy++f82Pp579eSmPui5urJCxTj?=
 =?us-ascii?Q?A/frOYX0cuSSdcGIru9XA+InASrQdl9BWWNUepg+vtNNr2S2rlQtYMJqSAli?=
 =?us-ascii?Q?C1VOZBbxwbODirb6/QpyZZ93FliabClrTpkTwz1YFZTAuEyEvmiH3qaDwgIU?=
 =?us-ascii?Q?PboFMkVw0742w/7GqA5BkulQVMlo75/kuisKjH5LYwLJiostWSiuLwDz2ehl?=
 =?us-ascii?Q?zxbIB9KpgT7JBs30e8CTVavfgn42xZkimRSam0J4zVJINCRw69qGiYWtReTF?=
 =?us-ascii?Q?alMAiPVYEs0uHALjLobcqCF1rTdNsro17Q782iPv5nth3hfvGJFp5BzH9clj?=
 =?us-ascii?Q?P6KDF5X+VcWvUJvKmQwlS7yXYpnR4KluVPlpT7WBwUYZAaiqWMOhxFL9SNNl?=
 =?us-ascii?Q?zgno/08c8nABEuctR5SZIyJKDDhwXXQ51/iqk6Qib8AWPvluzVLREe4OkEVJ?=
 =?us-ascii?Q?IFB2Q4VVwHuKKB9q73Gec3rrAbsXP6MzjNEdhoASkv6NfKOkT30m4a56n6YH?=
 =?us-ascii?Q?RU4Jq0NcEnM6foosEoeJkcukYQfT0uDehT3Nzz9P7xHNBgGNjyoiKG/aojLg?=
 =?us-ascii?Q?SAfHphtx0ot2mrk3JvwvnIsaRA1uYK5tl0i/ucFrsO3duOUBB+msBxixzwqH?=
 =?us-ascii?Q?WDzSgdZ7fdaZA3GLD5OPKbu/8I1Yt/ylLqmVJuCVRgz/VmkUaXwBNbr9ord0?=
 =?us-ascii?Q?0M2Ua34+XAMgKWjBvTFtGYAiQwKtiVLLFZLRlzBdUsBRU+087g2yyOYbtccu?=
 =?us-ascii?Q?K+U/Xc/DIZl0UI+ObvWLUdfRVckIklScOgU+S50daLUaZrzpc9msK0skTLn4?=
 =?us-ascii?Q?zCsnGVoMFMZA7lk3S8Mld0NP8rdSYbHQYL/A5oZ2H8PUM2JjNTCLMxdPK8MM?=
 =?us-ascii?Q?TRSKiqbYIHreM3cpY5iZ4trbfQsBwdqOR+rGxoh4ZFQy8L/oHKqfNsZC8tEQ?=
 =?us-ascii?Q?S75gCTai5FC3HJTCj6Lz0pLXUjWs41fijcWf9xqwy86PCU0SHyGYMkygwhiR?=
 =?us-ascii?Q?EfYCvaH4mG1MrMiS+7a9QtI0mNNsFNIGC7Mb7u2QkznOJcX2/tonx3kBf6fg?=
 =?us-ascii?Q?35MnW6bi9Qk4wQwF2Ju5yInAe4RKdV6os+D+B6/tUhtOEWk5RRy1ygQ4yDrK?=
 =?us-ascii?Q?98Nyo+zF0v26lmPvbIPi5mZO0ugoDNiVcu1JKb8WB3ndT/dLhpxLfhrFpn3s?=
 =?us-ascii?Q?W9jdAKUg3syZx/fkQwz4P/Gz8kXUzCm4tAiku9szSWi0OmShDPmIYzIL47xY?=
 =?us-ascii?Q?q/IZoggqgrs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?O9o7mO7mvMvpew/GHhm9ttULFIc0akFdDbBWngLAQj4rhL3eKHRvwRXAH3hP?=
 =?us-ascii?Q?HEaq2NUBgsjHHSWly5ACKlywvs6M+D8p+1QHYUUIeItoLRXZA40QfZHTO5fo?=
 =?us-ascii?Q?Pg9UxZaI0jv0CLLxy+xSIeoJDJ/8B88K12EEJX59SBgVUTeR5uRmmRYZCbGZ?=
 =?us-ascii?Q?5U7UF5r2zPfwPt3ZNmUw5xxQ4OqZ/3N9j4ItM7Qh2WCndWJMKr/X4CYdpSr4?=
 =?us-ascii?Q?6jLg53MejiCJAmEk5rernjq19vvCzDOHGldLhFxlfuOQ3kZexqw0NzL+fV3L?=
 =?us-ascii?Q?aoAr3diXt42hp6cA1mSnuXG56Oo7CXT6iVle5Qe1Is8UIsTyTFzdEBVt1a0e?=
 =?us-ascii?Q?UVZmIUa77ShNImsLygW/E+ijd9ImBFWYdfg+CKt3FaX67EFVnwlut2JT4CG3?=
 =?us-ascii?Q?kPNu4XJ7ElmU2g8reLi9UvzsGBgxlzTklOzVbmiruuOHk6g7iAnpYwrb5BSx?=
 =?us-ascii?Q?loiS6OyeSZ9EfKrgxT7fYNkVFUzOUAQTWfKvbW23hFYatZjKuT1WSoUgk3oM?=
 =?us-ascii?Q?0OotV6P/FTrV3Rk/IZP66p4ombWvHhQ5zIQMWoTl3KBvAWn093QRAcI1nlU2?=
 =?us-ascii?Q?bFhWxkhjhKhdOAxbfAEAnZ5FvRXeFRroNsjBaGvBpMbx4Xxnvnerk31g52Qu?=
 =?us-ascii?Q?uvFByLHTGcRFSWtwDj8OQYsIiklsR7GfuL65SilA2lVlMZz5utwvKW/HEbBj?=
 =?us-ascii?Q?UMfbY+AsBF/GMO8srf285COfESYO/UD6x4PC13+NI++CiTC9SgtFaJljlX8U?=
 =?us-ascii?Q?c/u+HGJpC+gaQiIek3MIO0KpcoQ5KRwe4yHDCjogt8LDqGlqJFK0ICfy8CWJ?=
 =?us-ascii?Q?wUqrAdq82uLpY2SCIMJpL0UdHx1K2g/8ZLAhoZqiIeAuIa9R3fv+Q2/JKJRL?=
 =?us-ascii?Q?gqyNhc1R/5J7u7R0FHW2AtFd45O5farGog5loV9OefK57MfJ7dIO6EMRRkyb?=
 =?us-ascii?Q?4hLLMIwnFlmTEP9LnWj50R9rN1MBS7H2nXFPfKxvUU8U+NKg6dtd02ESbVKp?=
 =?us-ascii?Q?a5YFoLXtly1RR738Iw6aTqZVNAAmgK9Pob0qQa+UwdI8SFwhXMle4sGOeTIr?=
 =?us-ascii?Q?pZt6NElDLxkI4MO45AK6NI6qRx8eRFN72SVXuuIcHZikaD2CG74LaBSZ/TOf?=
 =?us-ascii?Q?xhxSd9Z3uJH6FG6BMztYccEY+8hCZoCf5bTxzUEYeuPRBikSIMuFJyD8ENWM?=
 =?us-ascii?Q?L+50EcATvmQeTBj/1PxWg5hxXF0AhZNSmi+F3BmJTK8AaZnGxfbxmTWe9odD?=
 =?us-ascii?Q?mC8YXSwxgn00NOI16qPHz6zIoadST+kMH+hRv1B3ee1YnmsOpolR6JujPM3Z?=
 =?us-ascii?Q?squI/IvMQXUFOyQvQtZoy4jt2V/Wr4NKwFslcf4n1DNxUHd0aUtAjYOjQBWB?=
 =?us-ascii?Q?wVN0TLQqpYXgUCWD+gkZyT8hib7jWIgn2oWVgvUsjHRsQzcrkYzsg2YIZlc3?=
 =?us-ascii?Q?5eqaJaA0mT/i4qpT8zW3VNr4z0XEGM3KNOBvTlwNN2q2HjjvpoXHZaRM/7Lu?=
 =?us-ascii?Q?efHXJd6Wnd6IWLOKmJ7Z6JQ6+qkQ8HeuZ4mo7OPUiEa/rFgVR/HVgTrbdgfP?=
 =?us-ascii?Q?ww1lf3L/2a4Wu9FTkVGQ6ycM23xVykjYt0cc8WhYZKuzAONmvk2sXEcFZdlT?=
 =?us-ascii?Q?Eg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ep5Kjy8chcUWLrPwhNy8X8lr9L5atycCY6cmU/uuO6sb2pHlf6s0lOGw/3aWT6ZitTRlfIT6z+numksP3Ta2RqpbuNpYRPaIf8cRSgv5SpNXFpaCBIP/+xzHgZoFXYtjEFo7X+GadKZXrsnnc+NPFls8cHeezd5D84MHnoSjqxd7eGzcUkAVP40RyZRaeLeJlCEPZsMJKrhBjbQQEpsB1N0CImOYkpdvDwTX1LoDezozaCWkkLoixoxYSwr9SF+LGUQ96dILd4+LXfWYCEv0HWpayI2BffcHzYz71WFB//PtZhpEA65APOusOk19MownFqwbqHopyUN5vNlqmUW9hRaEv06nqWf0cOop5kUJdnRSA0tknqT5yJHnGj2f/6tdOKLkRBRMkdfwbVPvV+5n/jEdIBS1/vYBkW3vdxMB3mz2ACDAAhP3zSJ8F8gawSFbQmDZDpbgFZdsfe/cA9kTvEPWc4BVilsIxVk80tJgOTRSDPVxufmoJ1PJ729UEcJO8dmLIOSdHUfOos9YI7BmANLyqfpMvJoktNfLwbNxzTS8L/SIUI2fh1OrU2rUwhko59fx5++S/SKNFidPdrYcJK2NXlHQ9bx9AiJO12MeAHk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 490af8a8-13ea-413e-afa8-08ddd8ccba24
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 11:46:36.5291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3OiD01GAExE+1k8vKnkWxdgpypeygn57HdddKsSFWFWKNHS/5BqvwAT18dNpjz9Vk0XRZRtISwXcviyNWaZvk8IB3BAiESw6HqpbOuF27Kw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8323
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-11_02,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508110078
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=6899d820 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8
 a=yPCof4ZbAAAA:8 a=C4ixpjuKCqOEZgFS_6UA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: TMSp2gF_VnUSn-7NDYt4wbDAkyj0_J7W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDA3OCBTYWx0ZWRfX3g2TFTJyd5Ju
 haPmtsytKomlCB+4FMGLz6Jk1N6tGGfQ1+QyirRmz0O6C0xs5J9fgCwcmqXv2rwznYUiM5pZhlS
 0z8LDcsdOMB3WiIYNCzdFmWe43S00GbdGGt6VVo9XbFdkEU4H6t0298OlgJXpNZ0Z8tfvttdNtz
 /K4+LWsvqW7tXcTAK0lVudnBiBHacBNS/K6qh9WvBrejt6HIRbOUwFVb6QM3YUNwRkT9vrZzevl
 nPLlPqFCWwyADx+stz1AxriJxV2cz7HL+AMr1ePregqda6dTd6WxY2UauMN6GCtcBhXsfUlxEs0
 Di0hIAZXl2aR4+2njl02EUTjJnh1MdE3AmiHBHuyuc9IP08B9AcW41Xi6cOriZvb1hAZ4QH2hq8
 6pJ1RoPknMGvO6vkK2/3rYjzpmnHKi4ZC1LcpyLNWZqk6UH+mMOPCPLzwUJBLjsywji3HrTJ
X-Proofpoint-GUID: TMSp2gF_VnUSn-7NDYt4wbDAkyj0_J7W
X-Stat-Signature: p7hf5g3py7ra859g91k8phjwz8n7f9pn
X-Rspam-User: 
X-Rspamd-Queue-Id: EE1DEA0011
X-Rspamd-Server: rspam02
X-HE-Tag: 1754912823-216009
X-HE-Meta: U2FsdGVkX1/+NQBf3K9ZQpw2rxoNhllRPM6UEokI2qZSIXr1HMWyH5T6FCZ5vFskJV2eA5GV56+wDTrZvPbOySrHXAjHRo1ilNhwZ/5VTf8cedDJgz+AasmuBt8y1x9lPpgMoEXr9MgrM+6vyyzJo69ycXGp1uPfrvN/RxY4i/YviISydkFfmucqy30rDoN+y79Mo/jxnn9XE5zsnnePKZ3wvlvj2TuZDa771jVpgBdW7r3qCSU6Fy7ChB7/ZuDj6fiYcbyp7JhSiMkeYujOSqgxY8NoTmBiZDyCPhodqRJTGrPw+fFztkmVgNXt65WHHypRFrNsQJUqpHr7QkTjXOVcrZ2plTXEX46WxXNaypYpW50wIAjbhMhot9CAIX/A/mFesfn8hjJmBaWW10JJrCFFbMaiupQTE4YiGI/c90jmX0R58uAkik4CPj5atBCqHEf3nb5i/hX9v5c3ABj3J0oSiq9TkWk9y5Il5yg9lxaQc7cPgj57wFRjerGkwwjny3q2EHzhf1vWIPBLO2uZJGJI2nyl1AdvZSGfrOCcmY61/pmo/MSEpsZEO18aAVx4sQe32dch4VntHDhQ8kH8W9htk4db0TO2Zs/aAaouS/7psYZqRUMWvd3yNKk7RpnmLE64PdvOVq86mprBcwzRPbulXJxjppngolfZAqoR2xeMbxTKmFnrp/Nxaatm58yUNvX3pfv9d8xWTe2ArVura1FL58pcZ/hk8k6E5SoTZrdRAspmNoLyA4Y5rHEarJlW5b0fmLDTxK149tYypdyY7tYOInrbzwdI1W4SoLowS1pEiJ6rSs995FKOrdfb8JXDEZNrAWiDZS/nslHjrokvq3npY7fRmFBH+BHjEdFk5gGytFgrrfaxhXI8hDobpgVOFPTv4BsFwB+9dlsf+pmHuHRlR90pYMkTqT9I6ywFSAOsxD9AeD+vKbloB1D6aREY3aEYOT5/pLv0meYowPD
 QeLgQoey
 iBi12YQSuEyKqki7DBHzDatG0DKpUtcUcpdwtRmFXBjtaxEz2E1kHvSdtNx0BEoWsVZCRRXWa2XRP4JB6PgBzbh5EQDFPhWeMvlD28WNamsOSEHjrQFCtENxa1wknVrLze9IJgj6YhCPTkdEVEX8/vpjAIxF+cWztE8VQ0V4/hh+D+D9FEhwavmY3fw2td27IrqA3EG3pAotyl19C4fCFBs6sMDDA1mH0/BRMZUZUrW4ZWfOGBm8Lcw/KmrRVDKEVJYiv7Enl/p0aEuDYmINovOI3wJPORJwZfbhqa4cnTtA34tWEauA0bAtfQdxzjvEl6+QHwwdT3J+CiKsMVtqYUwyPmwtu3wS3Lqq7iullej4Si0LL4RRpyxWclXru/hjce7y45l8aIV5u3zmZrGcI9JNhIKde/nrJJV98mpzwjDc50q9v7r+2VXw6nzV+izbbESg2gjkLb6QboyRuE1pvt4Ri0F9yQP6Wi+6AXCuBOO8eimhx0l9GzL3uBfX3s1B52i6i9f804LH6DG+Wv7ImHh3LA0g2A8bK2dmfhuRGGwKxiOO+8r0nN/c5p0TUs01njCmw4stDBwkzYMOwBznL5fBHZEICl7S1L5/+US2OjauhquolAdCNc2GTtWqHAjXfmW8A/wCRr/n/wZeUuLx2uBH27A29cFvfOUsGtYTcGmQpLYwusP9OzTyGwblV+4eAdP4/I7837SJR1xlkZzHJFmGbI3vH+a6NHw1G8fr4ZTV16Kw1lJKsptEFDchA9pheevHhk/7H7HmGSWG0jpsAyVdc8aLj9xthY/Euvq4hvjyc8lKDz4n9KkOFHjp8IrUBXMsujSM7F9B13Kju4tJguMpWcMMr+alcVmJoQLoW1lL6nUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 02:34:20PM +0900, Harry Yoo wrote:
> Define ARCH_PAGE_TABLE_SYNC_MASK and arch_sync_kernel_mappings() to ensure
> page tables are properly synchronized when calling p*d_populate_kernel().
> It is inteneded to synchronize page tables via pgd_pouplate_kernel() when
> 5-level paging is in use and via p4d_pouplate_kernel() when 4-level paging
> is used.
>

I think it's worth mentioning here that pgd_populate() is a no-op in 4-level
systems, so the sychronisation must occur at the P4D level, just to make this
clear.

> This fixes intermittent boot failures on systems using 4-level paging
> and a large amount of persistent memory:
>
>   BUG: unable to handle page fault for address: ffffe70000000034
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 0 P4D 0
>   Oops: 0002 [#1] SMP NOPTI
>   RIP: 0010:__init_single_page+0x9/0x6d
>   Call Trace:
>    <TASK>
>    __init_zone_device_page+0x17/0x5d
>    memmap_init_zone_device+0x154/0x1bb
>    pagemap_range+0x2e0/0x40f
>    memremap_pages+0x10b/0x2f0
>    devm_memremap_pages+0x1e/0x60
>    dev_dax_probe+0xce/0x2ec [device_dax]
>    dax_bus_probe+0x6d/0xc9
>    [... snip ...]
>    </TASK>
>
> It also fixes a crash in vmemmap_set_pmd() caused by accessing vmemmap
> before sync_global_pgds() [1]:
>
>   BUG: unable to handle page fault for address: ffffeb3ff1200000
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0002) - not-present page
>   PGD 0 P4D 0
>   Oops: Oops: 0002 [#1] PREEMPT SMP NOPTI
>   Tainted: [W]=WARN
>   RIP: 0010:vmemmap_set_pmd+0xff/0x230
>    <TASK>
>    vmemmap_populate_hugepages+0x176/0x180
>    vmemmap_populate+0x34/0x80
>    __populate_section_memmap+0x41/0x90
>    sparse_add_section+0x121/0x3e0
>    __add_pages+0xba/0x150
>    add_pages+0x1d/0x70
>    memremap_pages+0x3dc/0x810
>    devm_memremap_pages+0x1c/0x60
>    xe_devm_add+0x8b/0x100 [xe]
>    xe_tile_init_noalloc+0x6a/0x70 [xe]
>    xe_device_probe+0x48c/0x740 [xe]
>    [... snip ...]
>
> Cc: <stable@vger.kernel.org>
> Fixes: 8d400913c231 ("x86/vmemmap: handle unpopulated sub-pmd ranges")
> Closes: https://lore.kernel.org/linux-mm/20250311114420.240341-1-gwan-gyeong.mun@intel.com [1]
> Suggested-by: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

Other than nitty comments, this looks good to me, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  arch/x86/include/asm/pgtable_64_types.h | 3 +++
>  arch/x86/mm/init_64.c                   | 5 +++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
> index 4604f924d8b8..7eb61ef6a185 100644
> --- a/arch/x86/include/asm/pgtable_64_types.h
> +++ b/arch/x86/include/asm/pgtable_64_types.h
> @@ -36,6 +36,9 @@ static inline bool pgtable_l5_enabled(void)
>  #define pgtable_l5_enabled() cpu_feature_enabled(X86_FEATURE_LA57)
>  #endif /* USE_EARLY_PGTABLE_L5 */
>
> +#define ARCH_PAGE_TABLE_SYNC_MASK \
> +	(pgtable_l5_enabled() ? PGTBL_PGD_MODIFIED : PGTBL_P4D_MODIFIED)
> +
>  extern unsigned int pgdir_shift;
>  extern unsigned int ptrs_per_p4d;
>
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 76e33bd7c556..a78b498c0dc3 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -223,6 +223,11 @@ static void sync_global_pgds(unsigned long start, unsigned long end)
>  		sync_global_pgds_l4(start, end);
>  }
>

Worth a comment to say 'if 4-level, then we synchronise at P4D level by
convention, however the same sync_global_pgds() applies'?

> +void arch_sync_kernel_mappings(unsigned long start, unsigned long end)
> +{
> +	sync_global_pgds(start, end);
> +}
> +
>  /*
>   * NOTE: This function is marked __ref because it calls __init function
>   * (alloc_bootmem_pages). It's safe to do it ONLY when after_bootmem == 0.
> --
> 2.43.0
>

