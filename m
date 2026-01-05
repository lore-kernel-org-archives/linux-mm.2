Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F73EC79F8A
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 12:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFEB16B0144; Mon,  5 Jan 2026 07:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6676B014A; Mon,  5 Jan 2026 07:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D496B014B; Mon,  5 Jan 2026 07:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B55076B0144
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 07:53:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 618A516188E
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:53:36 +0000 (UTC)
X-FDA: 84297901632.28.5A6283D
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0E39920005
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 12:53:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Osv2Fs6D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Egic+5k3;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767617613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1zmpHVj/OIY74nSCy60vtUlFgsiQre4VIvzqZhbNGg=;
	b=lr4M4msPd/qv2g2IunFv30VszxlmOgcvfs8u3c+znQZihdvf9vI8raTzt1RV1bJi2KuCUu
	mWVld0HaxyFvSmFui1A4gf0DnhN/q+YJd8yC7PRxsuAHm1zgXIQT4jY0h0p6zTu8GwCcce
	Vv8AWVza1pBztvAI23zBjoBIx4lHd2s=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Osv2Fs6D;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Egic+5k3;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767617613; a=rsa-sha256;
	cv=pass;
	b=ZtPGkQ2J6K8hHpCojVAAU7heCUIl7mPQrIPHPin2OkSTS/1AL2+u7r+4lyJVrqm3Vv7/o+
	dVnJXa87xkxlnzfN4WJIvl1zuEcYl1431IDkbwhiVcrZsPKT08jDoL1uanzRxwP6el9pEe
	d/do3kE9QwZNzCVubbKpJbAmkGMK2XQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6051YPmx340095;
	Mon, 5 Jan 2026 12:53:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=R1zmpHVj/OIY74nSCy
	60vtUlFgsiQre4VIvzqZhbNGg=; b=Osv2Fs6DW2W45Z0clqpEFHdbJ4kOfDgn03
	NC1mYrFYPV01DAl4E1OY7Q6PwOroOSwJ91NNVNV5cmyubcimvtyPFVJegaVadX4q
	R8VjgioDIb51A0+EhsjNJlLaI+oOfkzIL+1BA/lemlqfwnV83uSh1SiL+nhChNed
	LFrXu5MvFAXNw+K2kwu10WpdMJehD/i2XM86TrpNTGLCDRJqwnKUezORNNrJxk+z
	wAxFM1mNiCnx6NaiTSnKnDECjMBUULRRJ6CnOLxHMsYnpci2FgwkWIBMcukjs9PJ
	sZjWL6oMfVIiCG2iz62AoaGGsWSonD2dufbb2McugvODPS9tgHpg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bev37sp0u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 12:53:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 605CjrmH015545;
	Mon, 5 Jan 2026 12:53:25 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010017.outbound.protection.outlook.com [40.93.198.17])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj73amx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 05 Jan 2026 12:53:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=H3FN4agc1FBHcbnvESLYQy97eZlacquqpQUbNOAalcdi56QYuFc6ZmsP0v0dAytlZKXT5QnNxycW0ZFQ+6hucDy1j1DSps4Q+r8az7YoGpOqAjYhfoHpi/a86GcPTBt8MBmPkWar+dPXpI+DtoSgSkPO1wRYBDHcEGoxTkJ3WjIDR1ypO1xiR/XmbAtHWnZoTvvlxozj1A7VeK+MCgOGugwtdgdcELbjIjchmmVEHSf//nJ9YknNYtYTFv3WOBfPt8sBwebv3gmcyjGTtUUZEuyfPtkoW7PUOwPT76oQxYOKrz7lr232ddww9OBDFXju/roNClEnukVJb+1jpqpH6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R1zmpHVj/OIY74nSCy60vtUlFgsiQre4VIvzqZhbNGg=;
 b=k/9u3wfHDhKIM57TvbZYy6/K7Pe0plg1b0TQ+22VI7BmBkKZ6kCvOPR8IpkmmgSjmKzoH7iTVubn5gBz95VqwzlS6Zj+GR8u8hWOr+gZjAHHDcDvoAGcQ5A78B4xWMM3R47IVMI7o4u//yKstMfQ3mj9jdkqZhmmN0YvegeULAZn43TM5HTp3XW4AxZ5bXtLhgt4cc07kstwufqgNBrOTi8vlU6kyhr6QN1SvSdSbkW5ersdzXdKeWh7jAVI4aTLUEo93fHNan2rjRUZWfRqUIFajqilHL5FfyxctafwF4c94japHozBbwoSySZ0BjVPcualF1cFzJ86m5w5zmlLVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R1zmpHVj/OIY74nSCy60vtUlFgsiQre4VIvzqZhbNGg=;
 b=Egic+5k3SSPMEKZJxlDtsUEzT9jeJ2nDm5Pk27E2hAIi50CyT7k20BSJcajdGhsfLmAWMvxUpbpDh9wpi9Uq+fomcTmz5XL+xt2jR7udC+Vf4QsT5oJ1CPtyRybWPybtEpnh07UrxEIHJV3uObduh3z5i2Inobm5MJkOokMsUo4=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB6773.namprd10.prod.outlook.com (2603:10b6:8:13d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Mon, 5 Jan
 2026 12:53:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Mon, 5 Jan 2026
 12:53:17 +0000
Date: Mon, 5 Jan 2026 12:53:18 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, Yeoreum Yun <yeoreum.yun@arm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Jeongjun Park <aha310510@gmail.com>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>
Subject: Re: [PATCH] mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted
 merge
Message-ID: <6ec35ba9-1829-4e40-ae5e-25d189397e26@lucifer.local>
References: <20260102205520.986725-1-lorenzo.stoakes@oracle.com>
 <dc6a1474-70b4-47d5-b07d-a012b2c37b95@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc6a1474-70b4-47d5-b07d-a012b2c37b95@kernel.org>
X-ClientProxiedBy: LO2P265CA0441.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:e::21) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB6773:EE_
X-MS-Office365-Filtering-Correlation-Id: dced3726-84a7-4f5e-b040-08de4c596531
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AFwkB/ertOhGhsy6+cq1ePoQDcwGgT1tsEBFd5DcyI+9I8fZfN2W9bpqCKJb?=
 =?us-ascii?Q?enyEDSQzVMT7u2L9bU3KjGTRgxCVdvB144p6S2aS5IsSz/lNknd/nNnD+a/A?=
 =?us-ascii?Q?t40amoIJ7+F9OwcxRzCPrFzgV0dBMA5kboyyrNQZGoUwYpoLu3xwnN5ds6ZT?=
 =?us-ascii?Q?zybECz3+IJ9yi4gdKJWkqEstNB0iP3c3xrnNtllp2yFff6ZfmEwgYoguMkxr?=
 =?us-ascii?Q?MTC0m9NVnR8GVyJqPB2RDGEvWT7yaR6xkMyl6ej0mqtOWbmtHMZ17QjGMVpG?=
 =?us-ascii?Q?3cWgy29M9F5UZT7pkHi0kDfRTmrVav1xurXqCMngRACWTSj4JGy6DNM22Fdm?=
 =?us-ascii?Q?9uFKkRw5PYFYWifvTLOFoP+PLlH/cVarSbXKg3VMkEDK1Vn2xItEvsPXUZ59?=
 =?us-ascii?Q?VZ4zT6/x50AAqbfQHcdxY0z446iK58h/zZ+oJO0K9IphJyNZlttAlE06Ccdp?=
 =?us-ascii?Q?epLMwyFU1KaZ65a2qTN3Xq6bOxvbAujnM25/2wqsZAz9V9QJhOpSX+neYmVL?=
 =?us-ascii?Q?gWqCJf5TZrhbsCGu7Lxgtbf/CPsPsLS71OPQIZcWKY1qAn2EXYu4imM6dmfd?=
 =?us-ascii?Q?hvArwjLuOIBC/e3sapfMXWiGhESY8nVpruqFgOSukl9CJXuzW6XMXVSFqFl+?=
 =?us-ascii?Q?HXA5XdSp1BvZYyvsByog1B1OwIqAaqN5s3EbNUItZ+v30Ay7fD+kXNuX7+9X?=
 =?us-ascii?Q?ZyMh8719umBTDSiOq8bkgo0tADyVplXNI48RcEy1qXmk3AZ2MiTqOSyyxr97?=
 =?us-ascii?Q?VZ9cP98tH3fz7XTm42Gy9C4QebgW9zpRyBgTfeIRH0DumNIj2mRB40cQNoEY?=
 =?us-ascii?Q?0f9nWpSOaSAuXak+QXilAKSEKcg2reVn5B6dy5ScqaWObmvnwb+OO3si9zho?=
 =?us-ascii?Q?52ecCzqQyarhmcu+SmOv0UOcE9Y7qCooXfoIOogZJeZ7UjxPvTUmFoq3P0yb?=
 =?us-ascii?Q?8KBsZGjO0u3hkOHQPmei08oQNcNPUrcMMwOYw3GNQAlIEPRmCIqWMM9FLrZo?=
 =?us-ascii?Q?wTLalk/6QgPOQg7DdY/bfyApQffwwbAV0e5xwqLdOQjqWYvJduz9tL4M9/CI?=
 =?us-ascii?Q?QM4BZJUUNHD9N9FfDb6SYIeEehQWWJnbghpGKSenzrFIJ+qfXUHu6TwmEyBP?=
 =?us-ascii?Q?5dqmV3emrWOPVpITp/kCueckZYuTuknFMsLdkHJ0Z4Afopp+M8S78OLGrZxZ?=
 =?us-ascii?Q?cSVX7vl4u5HM0Culqpigq8w+RSEmTSsbSwZgapYVKzEiGkAZDOIeCw5wQUXG?=
 =?us-ascii?Q?Xf8ScRLkClBiWjq2L163cEGJRO2/jHYX9EkbDlDxszALgwKZCiV7JWWMlEHJ?=
 =?us-ascii?Q?heog25/miWm13pMX2LIutjQTH9uhC0EIJo95rH1tXjbGn+aoAN3gTfJNwE9X?=
 =?us-ascii?Q?V/jXeGfeJkKtzmhaPqgQAODDRKus5JYYMhroDVMlhfiS4GNGM0ck20P7JDNf?=
 =?us-ascii?Q?ZIeCx5P0TIAe2sE9OO8r565mtKhmhI9xEiJAPHl2mWzDpZ+9Am2ELw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Avko2EVzuMAMOnCGckxdPmSTHcxQpYbUfDLT0tqME+/3Qz3LyARnErvWdtfd?=
 =?us-ascii?Q?rks+Zze+QyuCVwQJpJUdWrkxYzbVxAf4Pc1HJUHQhsz2LiR3990cg038MPXM?=
 =?us-ascii?Q?FgJ3y/MPAQY1+weo/dpGEsPPXIdD6Eet8VY+qaRr29uGQ4HeXdeTBLrvLhXE?=
 =?us-ascii?Q?5ZffCqCUjWQVOOOoqX2uEBMAzE2UD9Z8NChqDImmbRyDrIRWiSDlysaDYwXs?=
 =?us-ascii?Q?prHKwXze7Yy/uMSjmPPgC6L4xgoltjf4NJTgf5BiU3JgCfwlyJZ9vKlHYPMH?=
 =?us-ascii?Q?3Tr0xxQSicrFEcIY2O1CCYd9uuZ3RlQ82bq3LDhfsClZu+5l7Vr2c62nSUmK?=
 =?us-ascii?Q?2Ls8YHO79ESuRQ20SU68A3p5YIKp/pPbPvF0gstiiHltAdpV9D2ze25TL1es?=
 =?us-ascii?Q?Dozl8z1kSJAp8rOOOe/mR3fHYXW83fmc5OMnzYSutk8nEOItySqUwazepzrw?=
 =?us-ascii?Q?l7HYr41KigEXI8ulSTYQzcO6Rt4Yze4Xg6KNR4bRT/TiDJWYSAO600Gr8h4d?=
 =?us-ascii?Q?Drqc4qDpdBPIw7gJfixemIzML+4Nedzak2OU3dxlg3gAVUkf9bWWOcGCef3i?=
 =?us-ascii?Q?skuvfNHovEyCpT0Bu8hxZ6sXf/7orUhiVbbNMmPAH/zEDyPrdEWZkGrNBK6U?=
 =?us-ascii?Q?yCDtXhCS4oQ5Fu2GcgZ5tr8UfJATcKaS4JdwB2qjQodm7QvhFj6tFsbN0hl1?=
 =?us-ascii?Q?NrXfK5zGQWmMe92YpfBEH6rt120sVn49tC10Uhbj8u0FBb7U53jGyscuygj6?=
 =?us-ascii?Q?cSGl0oWOGo4+HQXmDetnUpg3AWUrTIt4D7YABBFoCM8viMZRUC/XQ27wQn2f?=
 =?us-ascii?Q?oykzUmjInui0vLHPRQ4O65+z6M6uYZpZZXZmz0Uf9SktBF4mNmkBRJrIbXjV?=
 =?us-ascii?Q?896aCstsPz6P+TwmA+roDwTzF+p7OXjng4Cf5ZjCjBuBKKBd0YSO2WemijFs?=
 =?us-ascii?Q?b71NKlN9RQxPhlFvhaTivKz8bupiRaNmOjYkZyAQb+vWAgKs7V11tDEz7tUE?=
 =?us-ascii?Q?b/CR7RTSpA/f9W3NeoOxeK7HVf05dAhB5kcq3i9jj9e/+ubsZfpEzBnCmbhC?=
 =?us-ascii?Q?QZ0g26tx7gy0OQ73SjnQCxcwOgGFS96Vg0VYtaEzp8kGpcGGifqc4W9feOR8?=
 =?us-ascii?Q?VsIXJi0FqbnU8Gcfk2RJP+ZZ5Oun1MBaZxbE+oeywp4dd+sS7Pz4cCugGZV2?=
 =?us-ascii?Q?+coTzwa95sxzUjpMoXwv/4ke1s5w3T5IOJL0/x47UvF9Wmfo/ID3Hvyfriq8?=
 =?us-ascii?Q?Uw9hEN1tJJeP4+Eji/z+PHP8Jtg6zFeqSEoysa8O/LVi67E0fIS1r8YqpMcM?=
 =?us-ascii?Q?fvKFNcIlJimqtFrtSjKfiQaJIMEEBy8cMSLlPL5iBUHl12HQBKNvsY7kiqmo?=
 =?us-ascii?Q?K0qbT0v6+rbx27qSUkkMpYHY0C1t8KptLW74dVBmy7N7DArVo9D8AvnKqUVc?=
 =?us-ascii?Q?mESpUgfTTIgVXONUPbyC8JqNFY4Kq56/y4gzFPnUbfNYM+s0iWBlWcboKrCx?=
 =?us-ascii?Q?E77D3OybplVr2bG/h8fHS2E2hNDpnVGGd86uwh5Mu+2A7Sk4Kgn5zCPmYOTP?=
 =?us-ascii?Q?ep27ArIOd+3ubUijKTynTNZHrgKVH6f6UssQdGl8WcyH6VgmG5SnAGFoxlK4?=
 =?us-ascii?Q?lPC8RE1Ap7lgDuvrrqS2Jrj9TyPqY7BE7h+IE8qaiAro85SNKKEMIkYdWrTb?=
 =?us-ascii?Q?XYPYcWkPaKiPm7i+CE8YxSR1LTrSRwScxYYsUfJ3H9LgTpQkgtqwTG9EJn+Q?=
 =?us-ascii?Q?JZ3ccizi9VXtod11VQLRWRNAccLz8Zc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	NtsNBdZIRGAu3MqTfaxO/oUJVDqeYxaII7tjJBbfKIhdyaEKILzFjlIfVvZIBrTMmUD5wIKu8BX38NJK991ChVvKAXLuO7lSr1hHNTUlYwL6SCU6RCJEdINRyWNbRUpIicqeOwFrtzZJSbH1eXQBkvW1p//nHO4Z6Xiku3VCxhN2+Ln9txRfThsOfRekD5ruHVsdBZFTYhyTVjb34ZDu7Jpwdw8gJieQaW37tdtz6pOHPC0RSTl+Wy7dEctxYIlC1A8CrdWJwrskw4NNnOo6Cqoa1IJH1tduyHF+Hbpaepz0x9HvNaBWHtm6Xldrbo3YigoI+agCL2hywex7nnpJ2X05KZer0fw07ioolZeaAunL+9iEgrz+lLMHLKstB2vY6jC9P/Pz9xJMxsbORCHc1tp+mVRB9dzOAd6ABfb0ueC7OOF4B99DDBB6VtXdfqP6M4+BEhiAH/LzZdQfLI8yYsjNbjQKkgHJwphQ6Qx5Q6kTGqnFA4F1WwgTJxiz6H/VZo0oBchZOwHPwMrG9126YtJiPIB4a+PZUMK7131gEo4P+tltwI6Yqm+L5QgHd+GaiF3VUbZIeasIacKaguZSLBEw1suwZrtEc9LRVqvLQHU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dced3726-84a7-4f5e-b040-08de4c596531
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2026 12:53:17.0516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DVBV0kqXD+X2Elrtkt/iSx9mkgce+YNlqGdqj44t4Hpe1l9iBZHCMfQ0TKKFeKmGzOnYi//T42CERf7aLkoRh4hIvpJ7ccv3Xq4oTVUs924=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6773
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601050113
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDExMyBTYWx0ZWRfX24UupLvb7lm2
 txFKbsl4LalnXPzFe25Dwbi+McM8m+neTviSpPYfJQ4xfikve6LAEwbr1vNDxvInQhBZyyncmu1
 PyheMHdNXjIpTXchTCgHPsiu/tr3dF8nDmIkcmhL0B/et3Z750xfQYRLmroaQ1djebNLBR4hjUS
 tYeTWoQrBPWGV+lQwTBIJee578RYVWah0OTVpXqtHsSuhwYZtlWidr3ihKYccJozt3s8SulP6Ht
 br+bHvaZUFZod6pW3OFJI7Cmk8naAATf0PwF/6WG176fMCiaNm29dLiXU0wPogLFGBW00zytZnK
 ktLb9/gCyx7wlKWiaS+Piaug9mpEi/BOOwI5BvaKaso9bznPtH7llkXPI5wB7GRWykvmVKZKH4p
 SWlAO2lOzeDvg9PXI2JrGya0S03JwX/ARntedDhqXVIFCPg1IQDFGvijFOp8ytmU7SBhBYwqOrW
 oPzEWdMuuen3GOG2ysg==
X-Proofpoint-GUID: aT9dq907vIWJYqp_NKxLd9Dn6xd_nlbj
X-Proofpoint-ORIG-GUID: aT9dq907vIWJYqp_NKxLd9Dn6xd_nlbj
X-Authority-Analysis: v=2.4 cv=F89at6hN c=1 sm=1 tr=0 ts=695bb446 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=30gMTTpvy7pQ1TylIlIA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
X-Stat-Signature: a38mt7fnhxbwjwatp5g1e4mi8ij4678b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E39920005
X-HE-Tag: 1767617612-573380
X-HE-Meta: U2FsdGVkX19IAAfTAMLDPqClnCZa0U0UXHFcj9ynb4emeVnaxyYnNx05mLXNxfxYhQnZpaujrZtR6tX1UXJR5x3P+qhdEyjv9yHtMWnkh5GcNGDpnJKkK7k+8T5NTrR2CzXy3vXu9DVx5s5WCjN3RTkaiF3Ro/ezBvd2RKvZGBMywSkTPTph5pEr8kuLArRSzYKHUG0Pe6no/sJGP4SGSRCQi259cdEtGTVEM7FZ+PottlxFYD1nsOMqb+NsXBzQ6hC4Yw73MXZzlnFXCrTeyV3OB6MuiIwi/sCJ6k3B+V2t/86g6u5mmV0L0wAhqZ4CMZa/xlxHvRAQM+b2SpHRTx+RNhAPSkqQjfGn76K2IJ5yP9ph1HezQCOeJLvYZHFS61D1N0a5bVsTjVZm78M446E0TZxXg90AwzpzCkw10WS3AzPOUnyIHt9vTuaoXU9ya+dR77pQ2kFHmr6KzFkpusUV2NdDEQwB75bDr0oFue5IRkSEEaGXuIl1PAFHIpCba5JIctGj3jsM2gUWuNq+qip+h1UFLJcHD0CKJvsqXVqlihqyaSdJC/ekFcCPUAllS01yVsbStrG36veH3sFLhDcyzjLEEmrOfL2QC+n9AtC+Xs7AQt/4NGM9f8Nl5EdjRgztOPkSYcknFEriAAzJ5N4an+exT9bS1qmOpK3fwMo2GJgQz/sA47t1CTFKBc2wRuvGKgO17PLHRC+dzuxBSgDWw+iydwInWdhZbUfudNTN4d6uq73iuE0JgLbdlOGVcczI0G0jKEeF32NsKrTFSxXubCIKSIFqJUXWndRNdpl5uAn8qn+J1qjKS5SUa5yKpgU+AviPYyab8zCtGmn7DTPH3U/e2Q5QMciM4z66UDyAA6I+dt32Iaijh1c1WMHcdXvbJU0C1qv6BWQaZUXy7aKu/dvZil5IeHZGsrON+mVjnwWfpOMLRp9kCFTVUZI3xk/VZP/9EOE+LecDJOw
 5NuYW2RC
 5DmhM4NSCidbpXqLvqR0yaLeEQPwI4UfQRbfz22qYwjNHIm1ZRi+vFTtDNzIzZ4ApfuKei4wXM1sTvePWmqBCf8ZYmDpfoqTdpnRg8Y7EmdWcwZm294ALZZUwjYvoCcRfcHq+gp9oyGjoURuHwLPZvlIJiHs5mfOhAg38WsKBvck+BceM9PQQQ2sW+4sKzwL5h9IBFBVlsa7C/JVRt8NKegk1kYlFtvLveNrtzvSTXI4Bmo5Ecg4ms3L2CQfTd68QDFQ0TiVGvtIBndIQ/Nv60daoX4qFvA7zYInSixUx1VPuQtx4HHas1Zmpwg62gvz0oqM8IiDsErzjAGbTCkMJ04t7jnMSa+SvHrn70wp6h1Ig6g7VW14aWgA9ZNKqykKeqc/0DCYbWdeu4fDL+nyOfSJCCPIlagzXnkMQPMsaxG3TJRZQAZMjy0X7x9cqVkQHqpVHkus7Zb09M9dYlERvl1+4ANOROdbx03N1nJrwTxnxJvyMGsHhV9nVXdm0dhfRbOFVBM4ZpCdi9lkDjvCXMSP4tfUeBm2Tp6En9zvMY8/ZPDNiw5cgdciXenCwNyXB0NcNaImNG4rg6rrV3XCZcsK1BFZFRznwAILvXu/Qo8gne+iY8ViL7d845mAm7SYgTuWqMeZBKc07l/Y+2FPWh7eInGYLEHDCtc4dSo1QCwpaRuNbEL6Kof9D59bC1F2p7oe/n/zQQQAUKtmYdFLcdkkZBf+1X2REF1XsgBkAojmAOQtV3SAI3xm7hZYLhd4+YR03CnaPzaOB648=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jan 04, 2026 at 08:25:08PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/2/26 21:55, Lorenzo Stoakes wrote:
> > Commit 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA
> > merges") introduced the ability to merge previously unavailable VMA merge
> > scenarios.
> >
> > The key piece of logic introduced was the ability to merge a faulted VMA
> > immediately next to an unfaulted VMA, which relies upon dup_anon_vma() to
> > correctly handle anon_vma state.
> >
> > In the case of the merge of an existing VMA (that is changing properties of
> > a VMA and then merging if those properties are shared by adjacent VMAs),
> > dup_anon_vma() is invoked correctly.
> >
> > However in the case of the merge of a new VMA, a corner case peculiar to
> > mremap() was missed.
> >
> > The issue is that vma_expand() only performs dup_anon_vma() if the target
> > (the VMA that will ultimately become the merged VMA): is not the next VMA,
> > i.e. the one that appears after the range in which the new VMA is to be
> > established.
> >
> > A key insight here is that in all other cases other than mremap(), a new
> > VMA merge either expands an existing VMA, meaning that the target VMA will
> > be that VMA, or would have anon_vma be NULL.
> >
> > Specifically:
> >
> > * __mmap_region() - no anon_vma in place, initial mapping.
> > * do_brk_flags() - expanding an existing VMA.
> > * vma_merge_extend() - expanding an existing VMA.
> > * relocate_vma_down() - no anon_vma in place, initial mapping.
> >
> > In addition, we are in the unique situation of needing to duplicate
> > anon_vma state from a VMA that is neither the previous or next VMA being
> > merged with.
> >
> > To account for this, introduce a new field in struct vma_merge_struct
> > specifically for the mremap() case, and update vma_expand() to explicitly
> > check for this case and invoke dup_anon_vma() to ensure anon_vma state is
> > correctly propagated.
> >
> > This issue can be observed most directly by invoked mremap() to move around
> > a VMA and cause this kind of merge with the MREMAP_DONTUNMAP flag
> > specified.
> >
> > This will result in unlink_anon_vmas() being called after failing to
> > duplicate anon_vma state to the target VMA, which results in the anon_vma
> > itself being freed with folios still possessing dangling pointers to the
> > anon_vma and thus a use-after-free bug.
>
> Makes sense to me.
>
> >
> > This bug was discovered via a syzbot report, which this patch resolves.
> >
> > The following program reproduces the issue (and is fixed by this patch):
> >
> > #define _GNU_SOURCE
> > #include <stdio.h>
> > #include <stdlib.h>
> > #include <unistd.h>
> > #include <sys/mman.h>
> >
> > #define RESERVED_PGS	(100)
> > #define VMA_A_PGS	(10)
> > #define VMA_B_PGS	(10)
> > #define NUM_ITERS	(1000)
> >
> > static void trigger_bug(void)
> > {
> > 	unsigned long page_size = sysconf(_SC_PAGE_SIZE);
> > 	char *reserved, *ptr_a, *ptr_b;
> >
> > 	/*
> > 	 * The goal here is to achieve:
> > 	 *
> > 	 * mremap() with MREMAP_DONTUNMAP such that A and B merge:
> > 	 *
> > 	 *      |-------------------------|
> > 	 *      |                         |
> > 	 *      |    |-----------|   |---------|
> > 	 *      v    | unfaulted |   | faulted |
> > 	 *           |-----------|   |---------|
> > 	 *                 B              A
> > 	 *
> > 	 * Then unmap VMA A to trigger the bug.
> > 	 */
> >
> > 	/* Reserve a region of memory to operate in. */
> > 	reserved = mmap(NULL, RESERVED_PGS * page_size, PROT_NONE,
> > 			MAP_PRIVATE | MAP_ANON, -1, 0);
> > 	if (reserved == MAP_FAILED) {
> > 		perror("mmap reserved");
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	/* Map VMA A into place. */
> > 	ptr_a = mmap(&reserved[page_size], VMA_A_PGS * page_size,
> > 		     PROT_READ | PROT_WRITE,
> > 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> > 	if (ptr_a == MAP_FAILED) {
> > 		perror("mmap VMA A");
> > 		exit(EXIT_FAILURE);
> > 	}
> > 	/* Fault it in. */
> > 	ptr_a[0] = 'x';
> >
> > 	/*
> > 	 * Now move it out of the way so we can place VMA B in position,
> > 	 * unfaulted.
> > 	 */
> > 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> > 		       MREMAP_FIXED | MREMAP_MAYMOVE, &reserved[50 * page_size]);
> > 	if (ptr_a == MAP_FAILED) {
> > 		perror("mremap VMA A out of the way");
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	/* Map VMA B into place. */
> > 	ptr_b = mmap(&reserved[page_size + VMA_A_PGS * page_size],
> > 		     VMA_B_PGS * page_size, PROT_READ | PROT_WRITE,
> > 		     MAP_PRIVATE | MAP_ANON | MAP_FIXED, -1, 0);
> > 	if (ptr_b == MAP_FAILED) {
> > 		perror("mmap VMA B");
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	/* Now move VMA A into position w/MREMAP_DONTUNMAP + free anon_vma. */
> > 	ptr_a = mremap(ptr_a, VMA_A_PGS * page_size, VMA_A_PGS * page_size,
> > 		       MREMAP_FIXED | MREMAP_MAYMOVE | MREMAP_DONTUNMAP,
> > 		       &reserved[page_size]);
> > 	if (ptr_a == MAP_FAILED) {
> > 		perror("mremap VMA A with MREMAP_DONTUNMAP");
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	/* Finally, unmap VMA A which should trigger the bug. */
> > 	munmap(ptr_a, VMA_A_PGS * page_size);
> >
> > 	/* Cleanup in case bug didn't trigger sufficiently visibly... */
> > 	munmap(reserved, RESERVED_PGS * page_size);
> > }
> >
> > int main(void)
> > {
> > 	int i;
> >
> > 	for (i = 0; i < NUM_ITERS; i++)
> > 		trigger_bug();
>
> Just wondering, why do we have to loop, I would have thought that this would
> trigger deterministically.
>
> >
> > 	return EXIT_SUCCESS;
> > }
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Fixes: 879bca0a2c4f ("mm/vma: fix incorrectly disallowed anonymous VMA merges")
> > Reported-by: syzbot+b165fc2e11771c66d8ba@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/694a2745.050a0220.19928e.0017.GAE@google.com/
> > Cc: stable@kernel.org
>
> I was wondering whether this commit actually fixes older reports that Jann
> mentioned in his commit a222439e1e27 ("mm/rmap: add anon_vma lifetime debug check").
>
>     [1] https://lore.kernel.org/r/67abaeaf.050a0220.110943.0041.GAE@google.com
>     [2] https://lore.kernel.org/r/67a76f33.050a0220.3d72c.0028.GAE@google.com

They feel similar given the splats.

So what we had before was:

static inline bool is_mergeable_anon_vma(struct anon_vma *anon_vma1,
		 struct anon_vma *anon_vma2, struct vm_area_struct *vma)
{
	/*
	 * The list_is_singular() test is to avoid merging VMA cloned from
	 * parents. This can improve scalability caused by anon_vma lock.
	 */
	if ((!anon_vma1 || !anon_vma2) && (!vma ||
		list_is_singular(&vma->anon_vma_chain)))
		return true;
	return anon_vma1 == anon_vma2;
}


static bool can_vma_merge_before(struct vma_merge_struct *vmg)
{
	pgoff_t pglen = PHYS_PFN(vmg->end - vmg->start);

	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
	    is_mergeable_anon_vma(vmg->anon_vma, vmg->next->anon_vma, vmg->next)) {
		if (vmg->next->vm_pgoff == vmg->pgoff + pglen)
			return true;
	}

	return false;
}

So we'd disallow this kind of merge as vma == next and vmg->anon_vma = the
faulted-in VMA's anon_vma.


And after 6.16:

static bool is_mergeable_anon_vma(struct vma_merge_struct *vmg, bool merge_next)
{
	struct vm_area_struct *tgt = merge_next ? vmg->next : vmg->prev;
	struct vm_area_struct *src = vmg->middle; /* exisitng merge case. */
	struct anon_vma *tgt_anon = tgt->anon_vma;
	struct anon_vma *src_anon = vmg->anon_vma;

	/*
	 * We _can_ have !src, vmg->anon_vma via copy_vma(). In this instance we
	 * will remove the existing VMA's anon_vma's so there's no scalability
	 * concerns.
	 */
	VM_WARN_ON(src && src_anon != src->anon_vma);

	/* Case 1 - we will dup_anon_vma() from src into tgt. */
	if (!tgt_anon && src_anon)
		return !vma_had_uncowed_parents(src);
	/* Case 2 - we will simply use tgt's anon_vma. */
	if (tgt_anon && !src_anon)
		return !vma_had_uncowed_parents(tgt);
	/* Case 3 - the anon_vma's are already shared. */
	return src_anon == tgt_anon;
}

Where we _will_ allow this merge.

So I don't think this can be the same case.

That is bizarre.

By the way this also makes me think we should do something like:

&& !vma_had_uncowed_parents(vmg->copied_from)

For case 1... as otherwise we're making this case different from merging with
the VMA already moved.

Really using vma_merge_new_range() in copy_vma() is a hack as we're not merging
a _new_ VMA.

Hm maybe clearer to add vma_merge_copied_range() and just put all this horrid
stuff in one single place. Let me play around with this.

I will be adding tests.

>
>
> But 879bca0a2c4f went into v6.16, but [1] and [2] are against v6.14.
>
> So naturally I wonder, could it be that we had a bug even before 879bca0a2c4f that
> resulted in similar symptoms?
>
> Option (1): [1] and [2] are already fixed
>
> Option (2): [1] and [2] are still broken

Probably this.

>
> Option (3): [1] and [2] would be fixed by your patch as well
>
> But we don't even have reproducers, so [1] and [2] could just be a side-effect of
> another bug, maybe.

Yeah... so good idea to keep this assert here :)

>
>
>
> > ---
> >   mm/vma.c | 58 ++++++++++++++++++++++++++++++++++++++++++--------------
> >   mm/vma.h |  3 +++
> >   2 files changed, 47 insertions(+), 14 deletions(-)
> >
> > diff --git a/mm/vma.c b/mm/vma.c
> > index 6377aa290a27..2268f518a89b 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -1130,26 +1130,50 @@ int vma_expand(struct vma_merge_struct *vmg)
> >   	mmap_assert_write_locked(vmg->mm);
> >
> >   	vma_start_write(target);
> > -	if (next && (target != next) && (vmg->end == next->vm_end)) {
> > +	if (next && vmg->end == next->vm_end) {
> > +		struct vm_area_struct *copied_from = vmg->copied_from;
> >   		int ret;
> >
> > -		sticky_flags |= next->vm_flags & VM_STICKY;
> > -		remove_next = true;
> > -		/* This should already have been checked by this point. */
> > -		VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> > -		vma_start_write(next);
> > -		/*
> > -		 * In this case we don't report OOM, so vmg->give_up_on_mm is
> > -		 * safe.
> > -		 */
> > -		ret = dup_anon_vma(target, next, &anon_dup);
> > -		if (ret)
> > -			return ret;
> > +		if (target != next) {
> > +			sticky_flags |= next->vm_flags & VM_STICKY;
> > +			remove_next = true;
> > +			/* This should already have been checked by this point. */
> > +			VM_WARN_ON_VMG(!can_merge_remove_vma(next), vmg);
> > +			vma_start_write(next);
> > +			/*
> > +			 * In this case we don't report OOM, so vmg->give_up_on_mm is
> > +			 * safe.
> > +			 */
> > +			ret = dup_anon_vma(target, next, &anon_dup);
> > +			if (ret)
> > +				return ret;
> > +		} else if (copied_from) {
> > +			vma_start_write(next);
> > +
> > +			/*
> > +			 * We are copying from a VMA (i.e. mremap()'ing) to
> > +			 * next, and thus must ensure that either anon_vma's are
> > +			 * already compatible (in which case this call is a nop)
> > +			 * or all anon_vma state is propagated to next
> > +			 */
> > +			ret = dup_anon_vma(next, copied_from, &anon_dup);
> > +			if (ret)
> > +				return ret;
> > +		} else {
> > +			/* In no other case may the anon_vma differ. */
> > +			VM_WARN_ON_VMG(target->anon_vma != next->anon_vma, vmg);
> > +		}
>
>
> No expert on that code, but looks reasonable to me.
>
> Wondering whether we want to pull the  vma_start_write(next) before the loop
> (for the warn we certainly don't care).

Actually I think we don't need vma_start_write(next) after all, since we're not
removing next in this case.

>
> --
> Cheers
>
> David

v2 incoming...

Thanks, Lorenzo

