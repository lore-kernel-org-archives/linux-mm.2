Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9750D46600
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 16:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDB96B008A; Thu, 15 Jan 2026 11:57:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59E2C6B008C; Thu, 15 Jan 2026 11:57:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475D06B0092; Thu, 15 Jan 2026 11:57:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 342516B008A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:57:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E88941403EB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:57:28 +0000 (UTC)
X-FDA: 84334804176.18.F6D2635
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7C8E54000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 16:57:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZugF8kLE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MQVTpzT+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768496245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yCNFL/Cm/gpyG9IQ7u0F5InAOToVJZPrFgQms+WOxac=;
	b=3RO11khqKPdwXSXbK3sr4efJU23cwYNzKFYJp0QhcHdyoeTzEa7EbxopJ7+YVZjOWe23Kh
	uIhxh2l4IISZq76k2dciQZqhcPf7T7oSaRojK9t1QhTLY0mzJsw7yFY2BaSe84XxgpimN1
	QRhRtdYjl3DuBV4FCchirkH0DQA04Fg=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZugF8kLE;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MQVTpzT+;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768496245; a=rsa-sha256;
	cv=pass;
	b=w/T3eETxtNyZ4YQg9u5lLbFPdmIYTqFNWoweONEU2Lekp0OzpT2IPEpBgjIYnkwYcxunsj
	EpMxbl0PD+TXEfkmgeT1wKwswm+RwR2xmKTWk2bwh7bRCkrefIhYD0GFm17hZC79KgAw5i
	qSkoSw2+Faqu1sJr29sCupP8Hxh44MU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FENjCF2418908;
	Thu, 15 Jan 2026 16:57:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=yCNFL/Cm/gpyG9IQ7u
	0F5InAOToVJZPrFgQms+WOxac=; b=ZugF8kLEJxvrNSpMZ7b4MQyptEhBOYX9VF
	OTTKdHzMgu5HZJWnBi041k80j3R6TkT7C6PB8LQaBjpyGXAhMSePIAH7ly8GUJKy
	XymE+frKTRLr8W6kZCLOTRfhcM2henQwJf56cb+qTuCUSUYX82ZSvpE6SFTMSe99
	i19RUkImypvrkRYn2Q1rTJHLWd0w+TwpBUROUPMRgDia3q5Gc3hhHChgaqKejWMq
	v3yqGf8CDDq7YLPlHnvEIRZ91DFqyjQ2B78RWwa0pHzGDJN7GrSk1womgsr/r5+y
	4bLMGj9235/9/3OVSlEIn3x6EczwwC4ONMPmwJsZkeAghxeKITSQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre408q7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 16:57:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FGCfPe005727;
	Thu, 15 Jan 2026 16:57:07 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010070.outbound.protection.outlook.com [52.101.56.70])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b9sj4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 16:57:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Wt/5NjOIyLqFpBDiXMmXDqFxpXB8AWo3mKrdNgSaLvTfDE72304LJ/O3nioUNmuhQgKu748OpyWnvkvvNMZCNt6Ir7dYylI80xgWLDuyH3SLEwOgtS4cg7sdLf1njHjs+5I+HvTGxDseNJQq7feZyl5KAzxgjtnSUZ0coqN6ExqCCX8mONzbIm8Tqdkz4lNdjb8BZhkcsX0TcKhgGCHO3XCTRYXI9i8+KePlgCY/tpUa0WKKzfCqO0DpfhUe3sm3IAOQp0jeiYbBe8qDC/F8VmjkAJlya3C7ZIoKS8MTir4kDuvvMMoyBzxCYKvR+dyHxNa5rKIMwMv9qDin79AqLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yCNFL/Cm/gpyG9IQ7u0F5InAOToVJZPrFgQms+WOxac=;
 b=UYgBB/t2hFZF/5at6uW+VQCFJML80vVYCEL82r4knxNun4qb9ozBr11BgxqAYz8zB7jfkty1TltB9S8UU/P+5/A7pXYnHISyzVxGz0G9bylRNaLBjpxYArzPQg0aBQGKhlruF4l6Q57CYmwB37NwCwIf7xT+rUbDUR1UMm4pOlX9JHi0wOanTwI364pR8qhaFLjXcY7U/ShPKKCrNIv1di3zaScnj0RoeLG8SjMHEHiX9YDAZjw/uHsZMnA7KnR2Fxkd7nlYoabldatp+i5ot8YEYEy1sk7fSBhwsZGDnFuP4n2vQ9WSe1rKU2agR+JyVD9hPgmjrTsRbTCwai3ISQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yCNFL/Cm/gpyG9IQ7u0F5InAOToVJZPrFgQms+WOxac=;
 b=MQVTpzT+uvr/7Cnj3iFhYDnF6l5l7NjfPly+YSbrYAi7OrTKP2wMfumnXmjGOCfmfZYigblGqPAy4DEBAulX+a9b6ddFKjGZatC82OmsrGwqrqZuWwRqbsgXHKApSEjHZ0D/Q7q6WZ/sNHIOX97ON8obPS7o/Ui6Te9aGgrJAzM=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA6PR10MB8015.namprd10.prod.outlook.com (2603:10b6:806:438::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.6; Thu, 15 Jan
 2026 16:56:59 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 16:56:58 +0000
Date: Thu, 15 Jan 2026 16:57:01 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 22/23] mm: rename CONFIG_MEMORY_BALLOON ->
 CONFIG_BALLOON
Message-ID: <8dc368cf-255f-4d27-8340-9b6d12131b0a@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-23-david@kernel.org>
 <219f7be4-8355-4376-bf97-3410c6e23867@lucifer.local>
 <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37fdb994-59d1-4196-b377-f3f749148b19@kernel.org>
X-ClientProxiedBy: LO6P123CA0041.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::12) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA6PR10MB8015:EE_
X-MS-Office365-Filtering-Correlation-Id: 361df552-40ec-4e05-68fe-08de545718c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+tZjQVQb5fniihOVq9hTc4OX82hlHCJaHUJUGZ+MeHlUczlEBSTdf1/FHZXR?=
 =?us-ascii?Q?Pcnkm8NSPBOIbYYa65LnYPu1BVT1Lo/T/6WrQo0HSaainWV8rpEZb1ojLrdc?=
 =?us-ascii?Q?XG6hzWicXwM/pV1mQmHb/htn+3XuMn3frcmilCKNpqTxvEFYvTtLN77k22MT?=
 =?us-ascii?Q?Tmlp3IxBKB02RWB+Ij7pm2XEuueMnyw8Z7oBwI3YEYhwtsvxw8cHi6FG8Wz4?=
 =?us-ascii?Q?nmsb3BdbzgojknRRLxkuKdFYlSvmI5JPEj9Jp3NACFmlEXjQ4mn83zpjwrrh?=
 =?us-ascii?Q?uoOMAkJy7KPGNvmrRXGUgjUk8O5tJ5uKvfA6yylV4OjPImJOdpNiNU9ctSzL?=
 =?us-ascii?Q?2JjBoBLaixeUuFMeqqtJYJ4KZwpd5p2y0hxfsaPH3fA/QM4ssz2TMtRR1uGg?=
 =?us-ascii?Q?WReankhPcVKMnFoxby+FBqRyqHop/u71s97t3G+3y0NTLEp1D2UR1D2FDgGn?=
 =?us-ascii?Q?GJMxo17QH4O+dR724WUfXjRv83sMkE/fCqxqYpA6eyhSCC8nn6q5JToBvQBd?=
 =?us-ascii?Q?mFEdn5Ua0ZmE49nLGhLUt5P8I1WEruYWxM4Z116FQkGv9HvGsaPiQzuOrpds?=
 =?us-ascii?Q?rlbtuiOhT3WQTKbw+iDyl/j8o+rGVScrCU3stYUxZ02sbov2/cb7YqlDhTcQ?=
 =?us-ascii?Q?j/nohyHhPzHBg7ej7dg854BGBCgDFDrO9Ya1IrlDMc8ZnHvvv4nsPs2VShbg?=
 =?us-ascii?Q?017hVO7rWVjxAW9SA1I3gAVSTwa35bR/GyZxev42cUpZ3nuZB7LI5lfwfWR9?=
 =?us-ascii?Q?g35jSD0Dltx9CMx7u6X8Q+GrcaiNWyKcgZuwpsoSwVNFwjMewE0SeoWIjwVw?=
 =?us-ascii?Q?J+4wbzksfGK0NFjG+lJfaPhMxxrqUCCh/OZQ1VcoUE1NPRYpHu99tSea8D2r?=
 =?us-ascii?Q?vLI7dbk5X2u2rBCO6gCMhzLxqB6i35EaTpo35HqsF2jJ3zACZt3O/HWEOGcu?=
 =?us-ascii?Q?U812FqAN2Oq1nOYessbOvBJmv/ctmk+6d9SOQFpamL1a2YiK2eCmWAS/xqLn?=
 =?us-ascii?Q?aVPIxCWZrpJ+GWVhSBCoXZ9k0irOHKq/GJR+BcblruBdiRUaF4HyXX1nRxWt?=
 =?us-ascii?Q?5YFkosm+r8kpoL+AGzlnP1VM5ju6gyYMIFhpUCDDXyvWjFUkcDdIITyhPdrM?=
 =?us-ascii?Q?uum9ZR2Ibx6I4qMVyE3rfBkjoKF8QqKnzLgzmeX6zGVQzlsgpjDipGTqQMq8?=
 =?us-ascii?Q?rMzRty14gW2WBqdt6a7npNq5eaWYSKgma+zVjocZcdAmiYvTqoAxjDQt9B3y?=
 =?us-ascii?Q?l7Ddkhaz3RlEnqT+gh7RXdqN3g/ci8HBDcWGGxw7wyc18tJb886b4YVl8trN?=
 =?us-ascii?Q?QqxYKPezXhkgiQBAqfG0U6mB541hstbes1tWwO0MAojpw+fobWOYnln1+/Zw?=
 =?us-ascii?Q?z4VNeFcRu10J2Q52N6x7FvXek8c9JlUsXxor7xKuaK7arzBgJBi1Humi0e6j?=
 =?us-ascii?Q?3YEH9rBwNUO0hCFvCWhSp3rMdLOgh+NqEQ4wrVpmg4jKhbkiXmPJtEyZNU21?=
 =?us-ascii?Q?oLwlUcG/mdDZhfn/a3fR49TW7PX0UjBb0H+C?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?s5nt3I7W0nrhh6OThr64k00Ecz9QTqR1uyQC4YHbZHM+R4Sj7dX6O6tr+jeI?=
 =?us-ascii?Q?9edQryzwSIfoujY/dDKlLW6RGmiW1SBr5qnbHJCG1dIwra2zA/rLWTPE+ORC?=
 =?us-ascii?Q?si16q67e2w/s1H9sWeI/hxOoVQTooyTpGa9YbRJEiOPwPqbaqgewt19sZaNt?=
 =?us-ascii?Q?QLKWXyoXNAD7mFJuvHh27azUN+B+/k5pMC7ZFC8IuMU7xBYT1n4m9rSqQ7GX?=
 =?us-ascii?Q?/AC7+lPPlO9n1hgY3MGvmxEmTZZBUefFegtWOXGu6r9VuA1LRHqtzl5RDlME?=
 =?us-ascii?Q?qmJZzP3NqWzJ39kvCKE7ID88dMCCaQYWCJqHjFNLO0wL8KQrQrB5WjpL7NCI?=
 =?us-ascii?Q?gmjtEZQvV87ququU39tq/sFqg2Itb5uKbMzdEnb3/bgDHe8K9v3Nk719qMJX?=
 =?us-ascii?Q?Oh01BkXHPJzbkdPqqeV4trGmpPKehTQZB8+nNOiPXDYCdo2Vg4MnQkRFmIce?=
 =?us-ascii?Q?AHYSRVKoavR758sMRNwV9OMUewiJnB56EwXxbpaSb4hoF6m3tpQoa72VhF2E?=
 =?us-ascii?Q?O/Fa91hw5LWRzCGwZGL0W7IsqKyL5Uw6Is9nxToKeaPmkTMuAmsXPfXxsyp3?=
 =?us-ascii?Q?2Zh15w6xbke8n/CUxrcXyD2+4Rnzf4RfaY6AcoKgRs3nCtzyp4jMdvQnDHJh?=
 =?us-ascii?Q?p1JES92MIWBQ5In4n1Co9Bc9jvbbR19X2GPsyuKPK35Oj37hWVibFTHTilXe?=
 =?us-ascii?Q?38/t/WW+QZeET4blw6fwhdVYDq1ervCaCX/7CEDvIEn9ZlftkwN8EYQKvvEm?=
 =?us-ascii?Q?ePT/7oUdBIgzA64kh/n9OT5rZ0gdLeslBmbUPnyi6Zl4rRbVr8tPa/4aYn8c?=
 =?us-ascii?Q?H3ut6oJk5WBgPXwDqie2YZ84viAIw4XE6S6obqd6ggF3JEZAkwKrZTjcBTSf?=
 =?us-ascii?Q?c9qKI7XWpyU6ERR4KZPM/X2vGMtXZUhkgL+mp2IjSEZU2iqJz5BdzaNqCxAD?=
 =?us-ascii?Q?uOfM7xFpeY6AI7+lMU7WCz6xI7kMSq3w9tJIwUhcXo2bpgjMy1qoCWIfEkOf?=
 =?us-ascii?Q?bCvJP9Hu1OlJyTfn8VXGqL5QoSgsxlmfJaAPhpRfK2zgVuCFqHTL6vBbonuC?=
 =?us-ascii?Q?O3icJeMY99NnHpWWdxLjLy8lZiWf9Twih+lT0Akft/wjkbib3LBp1zKVfeG8?=
 =?us-ascii?Q?fWEV7q75mB2CDWhVNqOmqBBrxdgxKGH1DlyXPQ5QT4m8HlJ8K59MGwmAVdpr?=
 =?us-ascii?Q?iqogtEpbHvYk9gWJlqFDsNNCoKtyZx8ohbNNH99l6gor8DHRsKuMKFt/v1eJ?=
 =?us-ascii?Q?uMiitd83FYEr9z/4M7uUrFDiqksenRgUBOaGbSQgrt9sEMzIx8+VtXih8yRi?=
 =?us-ascii?Q?cmEGfvH9elA544eQNdx9cu7fPBzJRlFr3xb1TDr2MJAfNEIp4zIddwmJ1E94?=
 =?us-ascii?Q?68UTdG7+ylS3hutkctcRHEzBGeNOLOTZfyE/ppY4Is3xM7eJPdPnDYTeavNS?=
 =?us-ascii?Q?XSqq1n2PVguIHeJqYgHBawWREc7ZJps+Fvzx26h4jngt837pQLHmo8FzWVEQ?=
 =?us-ascii?Q?QSK8jQTRvO3FGmrLtA6UU3VSWACbhOcV48rN5G+VkWiQK0KYFnAlrM/4Hi+A?=
 =?us-ascii?Q?3njmEslb4fFA2eEVzQrkItO3i0c04LaD7ioAgaSogcGSrTccKMoSfrdb4MuA?=
 =?us-ascii?Q?AHzjN8dodSVcWnjuThkfHvS1J6Wv+MRcyO7D60lfv06lhMfn9tG/BctQnRGA?=
 =?us-ascii?Q?QHj8q9qiBZUjmQNc1AHcVM5Bk+KkYXXuU2Dpl2dnBJ/1GbJ/CJ3iUvNA5v20?=
 =?us-ascii?Q?39TiGOhDwFxzibxFAFP5jJTjp9tYW8k=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QXKRa323IpZ0GmwUF5hul78KvH1xyXt+FpIns69ih8tOMLBublxrq44ozcPV+7c8+8YV+MM2O6Dexa2msADdBDBcL0A5zvxuz+hdF7Ew0Uf7hsO0tBc4BfYMgFEuNvwdDJWqSLBLCEjabVNTQoCh4b9e1NLLTnp1zXMMG8DYiyN6qqB1vIZ652v46amA0gpRtmst+IITUvBjdanpGJyNrNO3Oj/PwAgYU1Lw6YLHnUjYv2ehVusbcsblyNE2y17IHKwHmHZ4cxv9wwinq2OhZJ/7iTOQO9l2MTyxWh0UeUnbokbT4dfXjT83+2H6VqXhDp5qncW6U7wPCEJmN+hXEXwzDGiDRwXbptrBWncuIJHHQPDryRV6ivci78wUitR0kTlTC2kq0QmF9NMLQ8nLv5EOh1jnzCFG77NiUM/9itH6Fc/0B27hZI5Wy4aQ43xXa6/WLa/RtLX3OSDaTExbR4xDXkOj1BwFdz8ws+Rje4Q7ATmVU7mZ9bJ7rGRqyHG6rPY/IBwEs52yIEpyof9pgs11Te2+FUUxwJ6Dl+5E8gFChcV4NBvvhTmaWTmE+lzo1s+McWzXoy5EDVlfAGk/nz00Tyy9Zb3RAodkKf5NJ8E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 361df552-40ec-4e05-68fe-08de545718c5
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 16:56:58.8689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t1PFhlRjDTI78FylWNywZWAPtKQq3tIElt9GhsxpWk7wLi/YKnwWIcWPDz7dJfQ16/xI1f3bt4xRza4XWaoLYngq4s6e3KPTRrAJN+mtzaQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8015
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150129
X-Proofpoint-ORIG-GUID: 6sAEKObOB_X0ioX2gGQDB_a5mRTZW9Xy
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=69691c63 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=mkMtH7XpAAAA:8 a=pFTM4td21WQB4RPan1gA:9 a=CjuIK1q_8ugA:10 a=wnpVdvLWcqIA:10
 a=I9Slk6e--tAXHahELIuT:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDEyOSBTYWx0ZWRfXxGEP5dC0f65J
 DDKpMgi5bTJHlQ6WVQGtMsVaFh9ORBMNoyDFmeAqPuBZZyxLPSCsINAjWBbBOBhSNsj/4AO28rF
 ZXDt+XcaB/OQpYT3LJshp5acfON6IYTU+mtODHvVom9GwFHgGV53/ht/EQBl6TE4MSb2omxmRzX
 KTM1ItMF8qWdyEO06pEeihK+1s5jCc3Dsw6/Z7tWzFE6g9jWoB/Hz5DpW13z99cgTRW+Za5DRW6
 982rULKlHcbxrAUvlT8nGcSOKxzmtzVgNAYSwGpJsYfrYhkFGPgPVK0gUvp6u93B5D2f1WegfVQ
 Lx6AzsLJbi5rp26tXJ5UfABe51pFzjpeyZczYPoHX4WZs5OjAhCy6DmrJF0Mkxp4fWjF0Gd/mqk
 QbZZe8qXPQdvlcYfufpeORRMQihU4WDfrZCcS4+cU8CEO+6BcxIccnaj8RaLuyvQvnzrU+F/8Dj
 Hc0BBqGJ+8l4V7bheJw==
X-Proofpoint-GUID: 6sAEKObOB_X0ioX2gGQDB_a5mRTZW9Xy
X-Rspam-User: 
X-Stat-Signature: ddjw9tj3rf35dgc1yj558uwpt7fpqt5y
X-Rspamd-Queue-Id: 7C8E54000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768496245-798767
X-HE-Meta: U2FsdGVkX1/NVQ0vAaVPHG9wlP/x5uNPzJGO24/qx59r7CzZnPT4W1Ve70gzaoRlpOhhulKJ25RgojZdWSB5ce7AWJaz9qd+MtYA1Q4SUihErzTgfnvWypK+pGlgCUfaLrZM0+1V0TFSGEBQGVMrtSHGjo3xVegiETL5yYyaZdP4Sw+51JQ5S7B54BMOA5S0iaeCaMn98SJ2zu+NFcI4ftekPEoxn0I0dj7L2avVbp2JZaoCvkBGDB52kw4Zk0g4Lea2fErZ5xnCRd+WZGyiCKS/vsYbdwvHfX3hF5C8bbkgBoMR9psGNapVjwT5Zuvxz1ANQPScrPw364An1kTUOpgffkBKSVkd7mILy2EXxHQJUexx9eT/Dryh51KtM8Fw8TsGBUNaoTGZ5qUgx9hfU5EzowvOOV7aqncZMPLWd7Wm0PH4c0yJ5i4eENRgl1DBgjQUp0QLwwTMfEaXkV84fd02i5jTdVXvji4GrFGew+9MXObYhkpeapst+ztxAoKTGp3xqUzav8TrkyTSDbnQJ1xApRI7wz8adyzLtBJ/YNeVAAoGxypCqOMQrIlgKOKSaLGacQ/0i4Sxcs08ACdgr7yvTa3f7+oDAMZsHSV/0mWrNYcJrTtFn/zUxSK+M3UjPBTDMDMRvzXMml2SEGkwfmJ/dkzVwLQdBYY7YzSr6zbPOxNX3GBwaj1oQ3ozI8E9zetAsNoQketufb/4po7KSAbvQsxzyzq5l5KtWcPbETh/5ZnGpXL+NebGsRpA8vok6cRb9D5ypJ5/+cbobHlJjJuA0kFDTioIMeQjl9+FBsrgtqP9HS6DX4m2611gDlmzGjXwuwGhIlZ0cHhR0iJZuT+PdFNXqKtl8oITBiEgHdzLcSZXdJmV4pUKaex4RiHeM/D3LBKVaRRen1SLBxjNecJHm97efmn68uMHZDK9jBUWSqwrarN0Unl5B0K0Hw4SgR0xek7oD3hE6Mytp5I
 m1J6Z3HB
 fZf4/1G6N/0Do8iJ+Dk3wqAItOjn+p9eeIqBMECkrwad4lZ2S7lJAUur3Tb/gDORFIlPxnifqXQlQLwSFwIsATMf2+gU6UqpRikqHd6SxRVDzSvvzuGyWDvLU6Lbge/LuOcRmRcApt722tj9c35DQtGrNxuVLmnDHr2niL2F+P/JFq9bIfhNzx7/R3OJJE6WLVZCqkpXNKFp6X2Ihs/ITNUPPeizsArm9+UEjh4xXyvJbYYZFlCuhq9JkWWpLtQBz7X5JV5fNxYH2IxJEYQZ4R3ELqFbLQy+LlLufya0mi2YsocjIE4nfQFkE1Twxox1n2tPbOGWQwCtfAEgdz0AWthV2m/wo71p7jeb4WrlckAfgkj592VQTCPr6WVGtvJ9GLWoiSiASFkHNKUhj1n4IiPl7XYz3n8VinSzSRP4PeZRadNoPDLc3EEuiqTTheI7Qq3Qn4GnjQ1HHNCGXFv0r11gXvGvuZ7XhlhSMpx7ozQ6LAds5RqhAnDi4cjY/aJTWp9mVGm1AQ4nj1tWaOPOtSX28E6KI+TA3w3Vn4GM4KqQyx671S7HzYjDgj9AiGK+SYzzjzUh9gpKOx5dvt4K28Rim9PGzy7smCY2iug2A47XH3cWB6iKw3Xh3uD2uJbvctrlBndoqxTRKxT1HVirMwV5HGZAZbkmkkFxSoJTvQHt5865iQlNTwySI3LFc05KuoYxPTbbFORSk8/KYYwtrRg2/nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:33:56PM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/15/26 14:55, Lorenzo Stoakes wrote:
> > On Thu, Jan 15, 2026 at 10:20:12AM +0100, David Hildenbrand (Red Hat) wrote:
> > > Let's make it consistent with the naming of the files but also with the
> > > naming of CONFIG_BALLOON_MIGRATION.
> > >
> > > While at it, add a "/* CONFIG_BALLOON */".
> >
> > Probably not relevant but cheap for me to share :) so grepped for
> > 'memory_balloon' and saw:
> >
> > include/uapi/linux/virtio_ids.h
> > 44:#define VIRTIO_ID_MEMORY_BALLOON	13 /* virtio memory balloon */
> >
> > This maybe relevant (I guess this isn't actually used anywhere?) though
> > interesting there is also VIRTIO_ID_BALLOON... hmm :)
>
> Yeah, we want to leave the virtio stuff alone.
>
> Now you'll learn something you probably wish you wouldn't know:
>
> As you spotted, there is
>
> 	#define VIRTIO_ID_BALLOON               5 /* virtio balloon */
>
> And
>
> 	#define VIRTIO_ID_MEMORY_BALLOON        13 /* virtio memory balloon */
>
>
> The virtio-spec [1] defines ID 5 to be the "Traditional Memory Balloon Device".
>
> And in there, we document that
>
> "This is the traditional balloon device. The device number 13 is reserved for
> a new memory balloon interface, with different semantics, which is expected
> in a future version of the standard. "
>
> That's in the spec already like, forever. Likely, at some point someone wanted to implement a
> new version (for whatever reason) and defined ID 13. But that never happened.
>
> So now we have these beautiful two device IDs.
>
> I'll note that the spec also defines a "DEVICE ID of Virtio Cpu balloon device as 47". But
> no changes really happened in the spec with that for the last two years (only the
> id is reserved).
>
>
> [1] https://docs.oasis-open.org/virtio/virtio/v1.4/virtio-v1.4.html#x1-4260001
>

Lord haha well that explains that ;)

> --
> Cheers
>
> David

Cheers, Lorenzo

