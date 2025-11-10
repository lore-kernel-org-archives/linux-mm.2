Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B635ACCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 013048E002B; Mon, 10 Nov 2025 11:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C028E0003; Mon, 10 Nov 2025 11:31:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4288E002B; Mon, 10 Nov 2025 11:31:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C6E8C8E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:31:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AEAB14019D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:31:03 +0000 (UTC)
X-FDA: 84095236806.18.F6DE927
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25E624001B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:30:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a70K6I8Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qKNhKPCc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762792260; a=rsa-sha256;
	cv=pass;
	b=1rUvGyP0W/w6VjONGXu77HxYpFc0UdulYmIcCYaAowgaHGy8flF8G9L5dWwaqK/BxD0fzY
	SfnKDlfC4BomlLcR5voE5MCze+cXaxeInjs6M7QL6CmY0q8P3rbqvGrVE3kNUmvKX2fAc5
	1UGYsB1SrJuxtKBhHs/9PGNJoqGrib4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=a70K6I8Z;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=qKNhKPCc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FWiXt+1CXFJwKQ6zsdP3bpQZuj2IrhcbQSbfXkJPmfA=;
	b=ULC8mgii364l32FFEbF74IVvqilxv+b+14bG30+zdMCWKBOO0SWMPz/0tvcJnugfs6WT1W
	prz0frYS83r7jbw79Mg0kqvA9UbhcKnPA173grtkfJM0G6jwALx4eNZ0bntfsnt1G5D3mz
	UCEEAs6hWCIrsY0FhscBJ9HiYAgR+o4=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAGAhL9029259;
	Mon, 10 Nov 2025 16:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FWiXt+1CXFJwKQ6zsd
	P3bpQZuj2IrhcbQSbfXkJPmfA=; b=a70K6I8ZsYX3W+Sjj1fWbdFav0oA7y5fZc
	TPjEM7FpUd7JwfdbjFRJ/TXpG9sGjzoTzOH0+oeuiqV0nYlDwv4fJDCGYlOOC5vp
	GuHCA/qgxr7K+zFjw0eyb8hotGEEIriPlNaK76DTbodeL9oT95VgCKcFQ+UEUKVa
	GAZqr215ksMrfW9KSwR0EwWUFNvj8kHnQ17jU+Uoz4vQiTeDgUNvX8P0+TvwJQsS
	7iFwrb9pTOCJD4omnyIEDxAJBv1/7TiZoaJ2SQ2xWj9K/Uhj0omSXrQX/yoBQcRV
	neLaRRIIGW+ppSVA5NVQwPPgFlNK9/EI9DbPSWXLSs2BXpENXSxQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abkb6g1pw-5
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:30:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAFKmqZ012658;
	Mon, 10 Nov 2025 16:06:45 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011018.outbound.protection.outlook.com [52.101.62.18])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vabu680-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 16:06:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r10nZRgex1qSdpqmPc2ynFpq0Y8Ryf+X7HQMAUgiDvsPxBRu9mK5J4XBML1E9DGQir140tFin9Tyo9mbm7IBP7X0M5voRtPs8yIenScS4BBYWUQJYoOZliQT+5dAC1GsO8HoS2mqWPAcLrARza72uvryNdxQY0YMtSqywm9eL6N1kbmBUxAGLMnjgOAd9+OYEuJI20tlxMLHoTDh1rhx3+mzoSqYTouM/IaSe67n2jali+xTA/Zhvy7qs514UkRH29znzD0d6J5xi73ll/DPRSOXycpBMWp+EhFq4rQBjphpOlF0+ERmWt4UCD6fBRQJAuM+LLZDuSDyQ0Jd2zGfmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FWiXt+1CXFJwKQ6zsdP3bpQZuj2IrhcbQSbfXkJPmfA=;
 b=VnDNIyR7lKOvo2lBS6sL0SKd7RI8NS2bVyUx7FXZ1qxA0q2uoDU1WXAV8FNkETNOlw8KhH+tEmVtJemodVa2O/QQ3VrLWQu4F8FkAGBQNRi9EA6aXYayJAfqG1sEpp0cEukH6g+VO5Bd/qdeEJgGFrxUxnxpHyrP06BV4EQTc4z6M7sid3LbGQzexQP1/rz0oX+jV6yxbnA5GAl+N3ctHYyDISBXcuTXVvQrBIGdvFZhoYfbXQ0HKRNw5i1/f+5KSioNyNXDzXD4j1k4DWZcpMDp7wPCZD6g1zQstC+BUHBAWXy6Ne++p9Nne8AE0axNBX0MWz2ChbvmIqI5mT6vPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FWiXt+1CXFJwKQ6zsdP3bpQZuj2IrhcbQSbfXkJPmfA=;
 b=qKNhKPCcTW4GLeQecDlcU/SqJSwFBilyVg4KfBwZbBszUvGfBWJ2Pty06mZNJvDkBgS7qXjCIXn8OEBuI5xeXEMxufrI2bkPghf1pF717g+8aljQrx6iIaOJU+INs4o1ryi7T1xlYbHRYT/s1MHOrPVcNEdEnvY50uYdlS7uoeA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by MW4PR10MB6371.namprd10.prod.outlook.com (2603:10b6:303:1ea::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 16:06:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 16:06:38 +0000
Date: Mon, 10 Nov 2025 16:06:36 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Garg, Shivank" <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Zach O'Keefe <zokeefe@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        Branden Moore <Branden.Moore@amd.com>
Subject: Re: [PATCH 1/2] mm/khugepaged: do synchronous writeback for
 MADV_COLLAPSE
Message-ID: <e9a0ec60-6e8c-474f-931e-2f97e5bb60c0@lucifer.local>
References: <20251110113254.77822-1-shivankg@amd.com>
 <f21b37bb-7a2b-412b-be76-e8968b4c375d@lucifer.local>
 <3b10d11a-3c75-4c37-8810-e238113ce75d@amd.com>
 <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc07aa10-d8d1-435f-9393-6c4ab63cc179@lucifer.local>
X-ClientProxiedBy: LO4P265CA0031.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|MW4PR10MB6371:EE_
X-MS-Office365-Filtering-Correlation-Id: c1b4778a-e8ff-48e1-985a-08de2073216d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?nGI6Lq+Sqw6W5YIpgC3e89tYdP0o0bbSaetzpGW2ho8ez7CHaswLtwZy15hF?=
 =?us-ascii?Q?1oJwUDSYv3MCBKoO79+jgC5OCWv99VSfhiVfI9G76NBZlOwbWwzM8Qu6fFDx?=
 =?us-ascii?Q?0bicjb8NbcTXvH2Ykr4rrwdPn41p2duBaRUGISW1ZdElIqDJPcRGEx8DaZ9R?=
 =?us-ascii?Q?n4PFdx7OACAR2fYYkmAlcSxK2UpUG3skZ4lGzam4ZvVN5kWQo3KVKnVaa5Sx?=
 =?us-ascii?Q?qarR7zTrpRvBW7CsSbn3Fga1mtob86Amoo4QXtdgfin3gKYF5mQ4B4Z9nEOO?=
 =?us-ascii?Q?rMlu4kN9VBzLThzTC3KtK2B3NaPlTBqDpAQ74B7vzaEpsJyUE4BHP1ueTNap?=
 =?us-ascii?Q?JwiCYuVSBsxNlVQpUyV2MX9MAwimJ6IvBc0rrjEKnmvB8xYWRDDnNqbSwVUJ?=
 =?us-ascii?Q?1v79u/+Vqb/BOyziYXkzMTMFMVu3UwwZdv+LfMo+ACYAf5nCw4Ft5F9+uPf5?=
 =?us-ascii?Q?t8RvhSPP8m/AXmcAm8+i8d+ETJZAKiuenNyPSdT/dzav4inrF1EXQo4Ekehh?=
 =?us-ascii?Q?JhXhy17hLsRoL7I+PFUs6OSG3POfvf/2Pcs7TabSqxyR64Gyu5p12kQBBW9u?=
 =?us-ascii?Q?MaFeZROGZ2C5/glP8AvxSPMEB2x1laSzlZGirjpNIkIcwt0e23b+4jQI43ud?=
 =?us-ascii?Q?LLpsTL/kTdMBnj7FttVkRsW3xcygy3cFteyDHKzHvZyF4S18P/CvMpemo2LR?=
 =?us-ascii?Q?hSNFg3TnCb1+fOCOxBk9acehkf+tkM+ZvEQQZLyfWIIJ1fSMNipFOXVzP8Oj?=
 =?us-ascii?Q?QoSks3LlGhnPIYikAU/ZVCQnZoTG7zRHZuG53APdpoyhaJGV2csDciE2mspq?=
 =?us-ascii?Q?zsC07/IzJP4KXXVDP7a8a2h5X731oi3wMSk86YubnxLlt1PCXcj1VJkZHpYK?=
 =?us-ascii?Q?rFcFVa1YzfJrBPm6t/Dbq7VLWeVu1J2Yw1Xz5pwns0MT2iR3sH0xhBOLbrJN?=
 =?us-ascii?Q?5z0Pnzpw9q49h7nZHRZXNpiM6iBh7ezSUQ42DGyMyYbXy/Nb8shviPqGPeqc?=
 =?us-ascii?Q?bZmkGWZ3pbYnUR+BqDqsRR7hKv2HWOdt/2BNXnOyc3T+fH4LXvZNeSG0gOXr?=
 =?us-ascii?Q?wexggFX6NCm04FeTt5po4WDv7UH0xm4rIVGwNa0tMAEHIl2QUuz3kgJpimzJ?=
 =?us-ascii?Q?oPZFzlLX9eJaWArMxYjI8OrDAtnvPjptg35oNjTbCXih2pyrEcdjv8wJ2e12?=
 =?us-ascii?Q?CxoBY0JhTZqVnxzLWcHAe+gsmpsrZTGxuRTFLL1kJNVx0ebJUfPxYMhRMH88?=
 =?us-ascii?Q?MPF7aG6yJFsMao5VErl164nqZPFE3OVr6Sp+ApXmIgffNnPmGuGMMyROR4jy?=
 =?us-ascii?Q?XiOuDgquStlcmyNlnpOAixnUHexIxJVeeY5iRk7o9Eo1Z4YFQqctHfn7LBjd?=
 =?us-ascii?Q?GMPGpGRBUCsYQi7IBCvPtOIAdA/uctEPLr1xb+jNk6XQxKWVpl+1ME+tWt6H?=
 =?us-ascii?Q?D955xJlK8eFug1YI6WBIyuqp0tpPCV90?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yoiYSRzXAujpl4D19Uamkgt0tP6P0VFeSMEnR5aZaZWffR6oTRN5pQsGF4ja?=
 =?us-ascii?Q?M4ptIVW9stkGgqa0SZ/9e0lP84astkl7JMl9bba6OZVaiioFH4zo2JmePbnu?=
 =?us-ascii?Q?OpNp12pkbn55/eT713bV+snN3p7RytgcsuAPa4AzNum/0lG8JfoHY4rJUwBt?=
 =?us-ascii?Q?BdW69IOmo7CG05+lYKQXAPBqiN8SFQSZOLeT+dd87GHEAxYSv74LxdRsF/Nj?=
 =?us-ascii?Q?1NkjnIHJ6YktzsJ6MekNIhLxKlxsFU2IxilsEiL4Sq49Su9xZnhIiC8uGRVW?=
 =?us-ascii?Q?Df/0/y5AzLgdrK+8Z+dfIijmI3Lq4yDFpycIVRoj8kqT+yc1T3sqiHUUF+dN?=
 =?us-ascii?Q?MI5rZgH32syN2DHwwEJyFj9LkuEMQd7I+7RDuREb/jaZIPNpxMIZZoY5G0yP?=
 =?us-ascii?Q?VsuGXeQ6ne6cjWEJhucKS1ZH+OEFE3lMwDRLA5UXapPIgESA3eIMbv67tJh/?=
 =?us-ascii?Q?v+k8AgkCFHnTdWyWpwGfUMABLZIbc+QvNdZPo8tDV6/GlDtc7XSbLgoMv5Bh?=
 =?us-ascii?Q?+1GvPJAhJMU+bt6jMy8X2ImZ8FXvESfgZRXS898cpcIo3XqdELLUJZcDCLNc?=
 =?us-ascii?Q?Xon5Wh39es+lZjR5Prn/ggxoEezwUVAVwqPBrsWLuSBaKQIfGy/9TwXS+/Rr?=
 =?us-ascii?Q?1hk/YfvApsdf9liZjEc6stpGlbAwk2kmYuVzdSMCxvw3JZUzbulUAHW6vsCw?=
 =?us-ascii?Q?zeoAay5cMf4yEg5iDHgrTXOVYytABblAEPVjh2voqOVUmypugqhXxNCHmpqI?=
 =?us-ascii?Q?0EFcc6KvsotugFpybEV6Zo0L1Q5F1ZFl3jiYxxA1kRtnftuj8Nvk+3NZf1vM?=
 =?us-ascii?Q?3zzU5UBy7jv9Fa7ROanFArXrkyTdkrFiWq9DefVGuRshJednxWqAxkjCt3Xp?=
 =?us-ascii?Q?ptxkqX/6+k9ir8k0AgeK1quBauURshuyWfhVpvk4DxwT8WL2JUgz/x2oSW1B?=
 =?us-ascii?Q?SCMV7g9OH19250mNkv6DnbLyKEoJXs24J/S2CWk0WexZYEbrvV8Ob59wQbYf?=
 =?us-ascii?Q?riwZZ1khX5338OdD+94f05WQfMKRqhvogR5UJQzinaw0a0A7GqabWT2eW/r1?=
 =?us-ascii?Q?CA9r4MXyQkKCYNL29RVfcnt+1j4Ldkx9qHRQZIe8w0hO+7au/7Fz46KCA9QY?=
 =?us-ascii?Q?UBTIyu9MtOkiMN9uLZW/HNdsQkb+l91CxTZHMLDv/2w7wFqmQPNeldZx1HIx?=
 =?us-ascii?Q?41ObQLAzC7gYYUCaE7YwaluIdpt88nADKeprC6yybTtqgEEg77e/S/3lPWi+?=
 =?us-ascii?Q?vxyXotpMK7lgPyDHi34nPpL/3yekhPS63qBrWhFmqnf+Ri4nEqKoKfDV4bph?=
 =?us-ascii?Q?P70RAYENelJ1QO/HjtM6mcseX3uXkcQYPD/vBFA2NcBCQCNws5uv2iuu3OHu?=
 =?us-ascii?Q?GmvEWoNIVHOI+cXrJ4Y7UVieBjtSF/Pyslyf0G0/jL4tMdrZvgLowQKmtp0z?=
 =?us-ascii?Q?mUL8itD4IN/7uSR8KnbbBKByAM7x+ShujypO5cy/YaHPWDXSJjCm4Q8Kx2Dm?=
 =?us-ascii?Q?SYidDWwxbAO9r6ubGCoQJnP1wVxXmSFpl5ECQcRB1dRUGB5Pr5Vb9Fqcjhvy?=
 =?us-ascii?Q?7eVdcMMbKaVyxZEfKul5ql3G/h7d/dTvWp1666lWWHLSZVParm68s6BAZL2C?=
 =?us-ascii?Q?hQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HQWZ4k1zb6L4jhhnCem++V0G5XxNrGiEasSCoEVC8QO30+4VPh+imRcZCXyVGS4vewBNGQN+GVbb14lgrdZZnjdxiZbgcif0fLCIAHREJFESvUdaMc/u3nTsLGeBtGPouTPM3ZNjhg2E0gfywPKqzS6NaYcwPD1U8k2arMQ1injG51d++bI7ACacoCXY6itReTLt5Qm0GGsqgys7UdRpUvj0XcH1ONlpnf/Bc5AP3O6KdpVoB3eYMOGz4UugsXD/zMU9PhL5sqLCqpr4pUVY3fHKHkMbqKWN2G4nHtfzdsJBAHiElFsDjae62B6F71UkkV/v8Gk2l1FKYnfHbDkL9tzOl535vFeH6XwXFE9YLYmVjD2JtN8IXFBI8+1eTJMf2WMdgYUkRmVNgeEXQce2T+mdRr3pvV3Pwb4cwE0gBnITb+eVz2Q2o5KL6DIuRWJqTuBUUtVub/KESVpV6/PwOS4eeIe5DYm/bKzt79Pk9bVBp4+qHeevXG9lb6B44E3W/n0EuXtQtliasvJB6c+4SZGn8a3rcJEJ3Nqn1YiKAT93LVGjCPkxVJB/YxtY/3Kq/MHlb8OCxS4pXXSbdaONqoYMTEXZMM5hanX6dLwa5lE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1b4778a-e8ff-48e1-985a-08de2073216d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 16:06:38.8075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7osOm7d8nrNhHIxd8BAYNhUcRv8QzpHGtVq4b9FamEjD1IXGDF6Qe/8iny3gOQf/hIEAeFA8t8Ys2LbumPkmlkrGG+znY+hoeEtNuHz8Mxo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6371
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_05,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 phishscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100135
X-Proofpoint-GUID: uwZTgltdUWl5igTLL1b790BBfhn9TFUB
X-Authority-Analysis: v=2.4 cv=ZLXaWH7b c=1 sm=1 tr=0 ts=6912133a b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=8wza7qE0RQA3soKfRpgA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12099
X-Proofpoint-ORIG-GUID: uwZTgltdUWl5igTLL1b790BBfhn9TFUB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDEzNiBTYWx0ZWRfX1ngWw0DCICmz
 C2Db1bm7gl0B0cAVaKj+RGCzkPur/f7js1rKaRYsVlNh4gN8RvGU0gHp7RDrXdTxTwi2wGH3mWO
 M24APHALlRlM2vJX+pFYE7Z/Nl8LfHuLF9DIw9TNiolVhOxCaJgs7icnIKdE7UDXdy5ojU8SFe7
 KKj57fzFt1yvKu5Q6jWVahfweapOtlxUiqBa2yTFqsx+cV6/il4OcT+ScD6ej2UDUfTZddl0W0M
 M4moAnBRawn1iRwGzpB3rkbhD6t3Xo8GkAjCB0egwnNeaOesYZkwOBejIveAPX8NEi9ee+6Wm4V
 v88fMfEQaakxVN7i3OUE6umMolqNY5wP2HjOxYZCASTK6Nlw5d6Avpdp9T/kyaC9C8YVaB4v/kz
 5qks5QyJ2rYA6n5vBzdMxKVGw3GXJhznxzE423K1DntIkySpIqk=
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25E624001B
X-Stat-Signature: 8qygagy1o5xb5zwsaxejrrjm478kyten
X-HE-Tag: 1762792259-704052
X-HE-Meta: U2FsdGVkX1971CWyTvB8Rqs/e32IAzPGTuN5AthZgDs3F9WA6wfMHZ1Srv7x/Q+vcfrI3454t7neVigFYblOVgO6ReVDX/+TLhbz212y9nM+/ee45DcAJuU+pn+dPP1n3uLqjIysYJS3qhcELZkYV2RgxdmUtLjS3VqC70hbL7XYByFRjoEjXwwf8ngL0+USpv44c6oFlYGH4EwAH1g6BB/mlHAT5LLSdtFcWtDzLGqvyTJT/bfHNVtnUe74WKQOZigvGGpEaSYELFFa4A5VPnntvx+kJcXDrr1Bz/N++dDFzNPkWVQHWPztojYt3/u7UgZ2+Sru6WvkiX8I9aBf7pwZPySKeNrKVWFwsHvyjP6ZMdhYyT+xKqcl0T9GLCSkD++07ZQGpL65/aT9CP+4Yx9fplmK6YldIi1SXMawHjcKbRhmC4wuvrX0vRtsTkNMq4sBqajH6mri3L9jSg8ENlsk116NYbaCybbl6gAEfCh9ExXq7zcsYohbC1uPT6vfnnq5H5nIEup9H/G9pyEFoRZz9nzU69twtc4QSl5iirewJ/QkhfYJUgsY5LHh9hKHWWuOLJCMFuoczSypFeE8AdwkTD16PTVRYQVaS5dkFxdAqEc+zT6XueC5z3gpsPiBNHbT9EBuXbYeWSicgId+lWokdfR35rObC0zZII7RO2dTRc12PFJkObhars8hxobPq1SBXbcNRYGkyLyEdZOmCCEcrG578ABEq6i/Kh/uS3DfoKU4/Ko34yX1UN6W7dTq86lrvgAPZ67g6AOOMa1KCgHIB/rWdvORnQfz1cYWrumUrY/iU3lp8luqKepYWTTnGbe9MYtnqrgGR2kpbzurhif/Q8fLKDRYC80RosDL6yBe80lbg7d6wSf69901UwNLNnFsp3W4j+APoUz6CyDsLsP06bGeERijzQr870wiNfg/N+yjb/CmWLQZJW51cXRB+dIBv8XMd5nyaVdGnwI
 5I2F9Utw
 m1QNvB5RvgRYuwSOfTLuq51e5wxMoaXK/AaC/AauHVvOfa19OIjHnwHSEUE+V6SSQKU7ql5eD0vGs9S+jgYlfeYVycZzec6vAkbNB43J7g6mqV+XIq0QK/o8vwa0WTnZCY17IjdeFKvU61Rpbp72tr2fOCYo7wXIV6hRr2oVYBsSHmNBVerxRHf0/ZlSs/hhADJTkhYGrfI66ZMWQLI05wLeONxlnoiMMlYG0lTtNL+z8BshZDUtESIV8tf9ObqUfFpttweRu7HaDY9C/OAVdzhN29uVj99O5tNe6nwTeI/S/XoCV+sFcgdXsvf7JBukJ/D5goGGccg3SNzB79Hi6b4LYKBwW49Co6BfxzWrOKE2UXfM9vT6sy5gq4VjrYINSLQvyOUihezqo0UJ8eZMiFPidpxjpgzcDOYCk+U7iFczRMtsd41KUoYkV4GfLFNoVOY8t3FihP5EyFO8jK4vjgWEKQiYAA/87KH6n2/PdnqIguEjBQ48hlXvn0FttQ7iG1JOSArXBCeJKas970IilhW4SccwMQ6ZbqfPCypD0vfcy8JUfdAQ0LZjxlZ9kInvAIeNa5s8kr7FtcNat9Jeib5qFpyVIQUqRWif8g7iAGd7io/57uw8g3MJuiIhBSYGmeypppM8B0fAWS/3kAtcgR40pH6uDi/Mz7aAKTCdyFFo0VqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:22:16PM +0000, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 06:37:58PM +0530, Garg, Shivank wrote:
> >
> >
> > On 11/10/2025 5:31 PM, Lorenzo Stoakes wrote:
> > > On Mon, Nov 10, 2025 at 11:32:53AM +0000, Shivank Garg wrote:
> > >> When MADV_COLLAPSE is called on file-backed mappings (e.g., executable
> >
> > >> ---
> > >> Applies cleanly on:
> > >> 6.18-rc5
> > >> mm-stable:e9a6fb0bc
> > >
> > > Please base on mm-unstable. mm-stable is usually out of date until very close to
> > > merge window.
> >
> > I'm observing issues when testing with kselftest on mm-unstable and mm-new branches that prevent
> > proper testing for my patches:
> >
> > On mm-unstable (without my patches):
> >
> > # # running ./transhuge-stress -d 20
> > # # --------------------------------
> > # # TAP version 13
> > # # 1..1
> > # # transhuge-stress: allocate 220271 transhuge pages, using 440543 MiB virtual memory and 1720 MiB of ram
> >
> >
> > [  367.225667] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
> > [  367.230635] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 5b 99 48 8b 78 60 48 01 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
> > [  367.249378] RSP: 0000:ffffcde32943fba8 EFLAGS: 00010282
> > [  367.254605] RAX: ffff8bd1668fdc00 RBX: 00007ffc15df5000 RCX: 00003fffffffffe0
> > [  367.261736] RDX: ffffffff995cb530 RSI: 0003ffffffffffff RDI: ffffcbd1560dffe0
> > [  367.268862] RBP: 0003ffffffffffff R08: ffffcde32943fc47 R09: 0000000000000000
> > [  367.275994] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
> > [  367.283129] R13: 0000000000000000 R14: ffff8bd1668fdc00 R15: 0000000000100cca
> > [  367.290260] FS:  00007ff600af5b80(0000) GS:ffff8c4e9ec7e000(0000) knlGS:0000000000000000
> > [  367.298344] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  367.304083] CR2: ffffcbd1560dffe8 CR3: 00000001280e9001 CR4: 0000000000770ef0
> > [  367.311216] PKRU: 55555554
> > [  367.313929] Call Trace:
> > [  367.316375]  <TASK>
> > [  367.318479]  __read_swap_cache_async+0x8e/0x1b0
> > [  367.323014]  swap_vma_readahead+0x23d/0x430
> > [  367.327198]  swapin_readahead+0xb0/0xc0
> > [  367.331039]  do_swap_page+0x5bc/0x1260
> > [  367.334789]  ? rseq_ip_fixup+0x6f/0x190
> > [  367.338631]  ? __pfx_default_wake_function+0x10/0x10
> > [  367.343596]  __handle_mm_fault+0x49a/0x760
> > [  367.347696]  handle_mm_fault+0x188/0x300
> > [  367.351620]  do_user_addr_fault+0x15b/0x6c0
> > [  367.355807]  exc_page_fault+0x60/0x100
> > [  367.359562]  asm_exc_page_fault+0x22/0x30
> > [  367.363574] RIP: 0033:0x7ff60091ba99
> > [  367.367153] Code: f7 d8 64 89 02 b8 ff ff ff ff eb bd e8 40 c4 01 00 f3 0f 1e fa 80 3d b5 f5 0e 00 00 74 13 31 c0 0f 05 48 3d 00 f0 ff ff 77 4f <c3> 66 0f 1f 44 00 00 55 48 89 e5 48 83 ec 20 48 89 55 e8 48 89 75
> > [  367.385897] RSP: 002b:00007ffc15df1118 EFLAGS: 00010203
> > [  367.391124] RAX: 0000000000000001 RBX: 000055941fb672a0 RCX: 00007ff60091ba91
> > [  367.398256] RDX: 0000000000000001 RSI: 000055941fb813e0 RDI: 0000000000000000
> > [  367.405387] RBP: 00007ffc15df21e0 R08: 0000000000000000 R09: 0000000000000007
> > [  367.412513] R10: 000055941fb97cb0 R11: 0000000000000246 R12: 000055941fb813e0
> > [  367.419646] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
> > [  367.426781]  </TASK>
> > [  367.428970] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd mgag200 rapl drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufreq i2c_piix4 ptdma k10temp i2c_smbus wmi acpi_power_meter ipmi_si acpi_ipmi ipmi_devintf ipmi_msghandler sg dm_multipath drm fuse dm_mod nfnetlink ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 kvm_amd sd_mod ahci nvme libahci kvm libata nvme_core tg3 ccp megaraid_sas irqbypass
> > [  367.497528] CR2: ffffcbd1560dffe8
> > [  367.500846] ---[ end trace 0000000000000000 ]---
>
> Yikes, oopsies!
>
> I'll try running tests locally on threadripper, but ran tests against yours
> previously and seemed fine, strange. Maybe fixed since but let me try, maybe
> because swap is not enabled locally for me?
>
> Likely this actually...

I have tried on swap-enabled setup and no issue with mm-unstable.

So this is odd, I know you have limited time (_totally sympathise_) but is it at
all possible if you get a moment to bisect against tip mm-unstable/mm-new?

Obviously we want to make sure buggy swap code doesn't get merged to mainline!

>
> >
> >
> >
> > -----------------
> > On mm-new (without my patches):
> >
> > [  394.144770] get_swap_device: Bad swap offset entry 3ffffffffffff
> >
> > dmesg | grep "get_swap_device: Bad swap offset entry" | wc -l
> > 359
> >
> >
> > Additionally, kexec triggers an oops and crash during swapoff:
> >
> >
> >          Deactivating swap   704.854238] BUG: unable to handle page fault for address: ffffcbe2de8dffe8
> > [  704.861524] #PF: supervisor read access in kernel mode
> > ;39mswap.img.swa[  704.866666] #PF: error_code(0x0000) - not-present page
> > [  704.873253] PGD 0 P4D 0
> > p - /swap.im[  704.875790] Oops: Oops: 0000 [#1] SMP NOPTI
> > g...
> > [  704.881354] CPU: 122 UID: 0 PID: 107680 Comm: swapoff Kdump: loaded Not tainted 6.18.0-rc5+ #11 NONE
> > [  704.891283] Hardware name: Dell Inc. PowerEdge R6525/024PW1, BIOS 2.16.2 07/09/2024
> > [  704.898930] RIP: 0010:swap_cache_get_folio+0x2d/0xc0
> > [  704.903907] Code: 00 00 48 89 f9 49 89 f9 48 89 fe 48 c1 e1 06 49 c1 e9 3a 48 c1 e9 0f 48 c1 e1 05 4a 8b 04 cd c0 2e 7b 95 48 8b 78 60 48 01 cf <48> 8b 47 08 48 85 c0 74 20 48 89 f2 81 e2 ff 01 00 00 48 8d 04 d0
> > [  704.922720] RSP: 0018:ffffcf1227b1fc08 EFLAGS: 00010282
> > [  704.928035] RAX: ffff8be2cefb3c00 RBX: 0000555c65a5c000 RCX: 00003fffffffffe0
> > [  704.928036] RDX: 0003ffffffffffff RSI: 0003ffffffffffff RDI: ffffcbe2de8dffe0
> > [  704.928037] RBP: 0000000000000000 R08: ffff8be2de8e0520 R09: 0000000000000000
> >          Unmount[  704.928038] R10: 000000000000ffff R11: ffffcf12236f4000 R12: ffff8be2d5b8d968
> > [  704.928039] R13: 0003ffffffffffff R14: fffff3eec85eb000 R15: 0000555c65a51000
> > [  704.928039] FS:  00007f41fcab3800(0000) GS:ffff8c602b6fe000(0000) knlGS:0000000000000000
> > [  704.928040] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  704.928041] CR2: ffffcbe2de8dffe8 CR3: 00000074981af004 CR4: 0000000000770ef0
> > [  704.928041] PKRU: 55555554
> > [  704.928042] Call Trace:
> > [  704.928043]  <TASK>
> > [  704.928044]  unuse_pte_range+0x10b/0x290
> > [  704.928047]  unuse_pud_range.isra.0+0x149/0x190
> > [  704.928048]  unuse_vma+0x1a6/0x220
> > [  704.928050]  unuse_mm+0x9b/0x110
> > [  704.928052]  try_to_unuse+0xc5/0x260
> > [  704.928053]  __do_sys_swapoff+0x244/0x670
> > ing boo[  705.016662]  do_syscall_64+0x67/0xc50
> > [  705.016667]  ? do_user_addr_fault+0x15b/0x6c0
> > t.mount - /b[  705.026100]  ? exc_page_fault+0x60/0x100
> > [  705.031498]  ? irqentry_exit_to_user_mode+0x20/0xe0
> > oot...
> > [  705.036377]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> > [  705.042200] RIP: 0033:0x7f41fc9271bb
> > [  705.045780] Code: 0f 1e fa 48 83 fe 01 48 8b 15 59 bc 0d 00 19 c0 83 e0 f0 83 c0 26 64 89 02 b8 ff ff ff ff c3 f3 0f 1e fa b8 a8 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 2d bc 0d 00 f7 d8 64 89 01 48
> > [  705.064807] RSP: 002b:00007ffd14b5b6e8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a8
> > [  705.064809] RAX: ffffffffffffffda RBX: 00007ffd14b5cf30 RCX: 00007f41fc9271bb
> > [  705.064810] RDX: 0000000000000001 RSI: 0000000000000c00 RDI: 000055d48f533a40
> > [  705.064810] RBP: 00007ffd14b5b750 R08: 00007f41fca03b20 R09: 0000000000000000
> > [  705.064811] R10: 0000000000000001 R11: 0000000000000202 R12: 0000000000000000
> > [  705.064811] R13: 0000000000000000 R14: 000055d4584f1479 R15: 000055d4584f2b20
> > [  705.064813]  </TASK>
> > [  705.064814] Modules linked in: xfrm_user xfrm_algo xt_addrtype xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_ipv4 nft_compat nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables overlay bridge stp llc cfg80211 rfkill binfmt_misc ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common wmi_bmof amd64_edac edac_mce_amd rapl mgag200 drm_client_lib i2c_algo_bit drm_shmem_helper drm_kms_helper acpi_cpufreq i2c_piix4 ptdma ipmi_si k10temp i2c_smbus acpi_power_meter wmi acpi_ipmi ipmi_msghandler sg dm_multipath fuse drm dm_mod nfnetlink ext4 crc16 mbcache jbd2 raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor xor async_tx raid6_pq raid1 raid0 sd_mod kvm_amd ahci libahci kvm nvme tg3 libata ccp irqbypass nvme_core megaraid_sas [last unloaded: ipmi_devintf]
> > [  705.180420] CR2: ffffcbe2de8dffe8
> > [  705.183852] ---[ end trace 0000000000000000 ]---
> >
> >
> > I haven't had cycles to dig into this yet and been swamped with other things.
>
> Fully understand, I'm _very_ familiar with this situation :)
>
> I need more cores... ;)

Oh it's nice to have more :) I am bankrupt now, but it's nice to have more ;)

Cheers, Lorenzo

