Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D853CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 19:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E37DE8E000A; Tue,  9 Sep 2025 15:10:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3168E0001; Tue,  9 Sep 2025 15:10:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63468E000A; Tue,  9 Sep 2025 15:10:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFF9C8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 15:10:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 807D513B5FF
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:15 +0000 (UTC)
X-FDA: 83870652390.29.141E1F0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 411A5C000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:10:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aDAu6MFt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lJBWdho4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757445012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/E2/LAEFPySGG0MqUvDz22sPq3nPf8RspI/RhBVnStM=;
	b=06aJC3MDC/j8bsT7lM+IC1YfqHHMjjGXBHIcRcHCtzVi88zORgEPtgzXmsZrjqJcjJm2Jo
	31bKzQbD9vxWo13/TXWufSoeHHPjqb4Gmy0D7LhR+MZ1H7sFrZVmNvFTq2dCR8qR9LFYqC
	GZZ1vd0rt7sIO+5CD1mAdL0nuGyh+hw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=aDAu6MFt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=lJBWdho4;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757445012; a=rsa-sha256;
	cv=pass;
	b=OIVA8NI8SGB+4qa0h0gA+hZiXCLKirwfl4gvLGFi8V2TjW9RBBD1iNljLRy9v9iztknFQX
	uzdtBzLs4PAwDZB29PZyvYU4PQX9Jc/gNcAXbc42cBl+LEGNsGB0f8/Z8sezAVSnF5Uap3
	+WmcDO4NIVVQ6ZdF9JjcNoXtIxsWbtY=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589FtfFZ017646;
	Tue, 9 Sep 2025 19:10:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/E2/LAEFPySGG0MqUvDz22sPq3nPf8RspI/RhBVnStM=; b=
	aDAu6MFtjQTBs2wApElikHTxBO4f9/+ncY8owQGC1f6Ep8HpZ2ZxQ9xfOR4JuJ0o
	TXh28RVQrDYuTgn7kxYceKuQTZ2L4Kr/fGwSbmw4vQ8GJceTix7RA95bdGyf1l8g
	HtWgu/3nRW4bhsea1fSI+HKxCL2z2inRvlC4lHhXLH7Cm+ennhKv50lj9S//L8cW
	gi1BoimnqkuWfrNXrDlxs6zQ0GdDlgyFiTlg+gg5Nxlh5AxiaJ6SEqrZVDqKaEA3
	c/8eI/SfgWDt6EtpmaP+1Fqp+WEGx4+jezv7dh1lhvUDJQrhya+Lz93g6jx7/Wg8
	iONQoBji/Oad6bhWB4ekZg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2tr2e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 589Iw12f030651;
	Tue, 9 Sep 2025 19:10:02 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2042.outbound.protection.outlook.com [40.107.100.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bda0pxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 19:10:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ePPN8wNb1i0gWbnKPFS2uTwiYPfsULZVmxVWZC5KB1R7iFFXVW0T2SsNw2KotlSxep4FSvCch/ul9VUdlDrvxZgT8TwmOOgbKrFu6/OqGqWqg1/oatD9ErCR2lmAWDV+MtUMJ4IwyhHtbruqWtR54FhUiStAhAIy8Iatr0Wpkse36zNkACi+KyVhTrzhI9ZeI0OIm+gYFeCKSiwN2+c07jrSscGnxl0NnIZDkc6N9+E30VjFVJiWoF6TYflxdK++hjgbZmXSIbs4QUDgFOg8DOCN1mmoKt1RwBjfd0oIrrvo3NNS5k8BpkIDq783fTXotOALFzzK/ZeqJ5T4GOraxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/E2/LAEFPySGG0MqUvDz22sPq3nPf8RspI/RhBVnStM=;
 b=ED0RLSxSgt8jhEHcvn+IYFYDNrq7KM22PHuMz6TdtLsPAaSvJ+Jxyj6Bw2WwUoTqylLbH/eMpBT5+iUDhYCoTOyXB0ICRwWG0pB5UdOTLNNStVASxFsBngJ97qT7nPqizeF10EUSRl7FuxT9piP+9HZ8F3KiF+1+roDIL2UqsMByFvKhK2Er3NRf6t336PokoCy9ClPvsIr547jcva+Bl7GgsiGPxzImrR5UY1RF3RHSGDRTMe4i3MuRm08N2Uxyd075D8+2EBoyvjTtaodU3c2f4lOCF6V1IUqJkqNROu1BngOHoakgZnC4+xTyEDwobMoh2l35uNmqrMERnRiMfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/E2/LAEFPySGG0MqUvDz22sPq3nPf8RspI/RhBVnStM=;
 b=lJBWdho4HXTh5wHn4IrkXJjgNgRiJc1mi2kkcuGMYLgCwz0qRnOZijC94UjXRhm5TmbfcNUQp4fC09Hr8If1PjAGnR7irfd/kQumZC+T7u1zD+WvOYwjLV5Uneo4bVsiDb9qMczi+BQ0h64NNychsDvPFKHTBjd0xLbeFK/aclc=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7052.namprd10.prod.outlook.com (2603:10b6:8:14c::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Tue, 9 Sep
 2025 19:09:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 19:09:56 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v1 3/9] mm/vma: Add limits to unmap_region() for vmas
Date: Tue,  9 Sep 2025 15:09:39 -0400
Message-ID: <20250909190945.1030905-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0376.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fd::7) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7052:EE_
X-MS-Office365-Filtering-Correlation-Id: deab7179-8770-4870-2d1a-08ddefd476a2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Dlv0Ik4kkloYkHlhqS5j4bt54DPV2Wv+rB4L3glebWU6Gr+KbZPshhi0I+qR?=
 =?us-ascii?Q?1Z+W5pkAzjaAcEDYuxXxTxfcDsDdNeN7Rxtk2kdtgsC+/tTAWHrmyxYG9Nu9?=
 =?us-ascii?Q?vyRu/Rf22LLnYQOKew33A7fyJlpzQ0Sc/egQ8DMXoXwd0fqU7a+6swYp1kwS?=
 =?us-ascii?Q?MFRtVtjCBvbZqW0WJPJIe1z36iEX597ouL6dnqwueBo8dacahEtk1OpIBf2c?=
 =?us-ascii?Q?+/ITVSWJ1dm3zPLLQFKGQLzBJOKFqPw/G66WIyaHf7MLD+wixYOskbogYTTa?=
 =?us-ascii?Q?dtS8kEJl8eGg7Aq1f0hwOkN0LK2pCTg4STAKkRJxeN0j8qIKgbqMIA+m/Yhf?=
 =?us-ascii?Q?yvN3dSWF62VlltPOQ9SrXWwKSEFGxlIMlJW31qioy96BRZksd4XCUfdt97nI?=
 =?us-ascii?Q?i7lYncu++QEB/tryAapS9EsF1VIPR+mevWWNKbobR7ts+BueiXM336dYdcYq?=
 =?us-ascii?Q?nr9PfapMIqL0204206EBS8WJEWAtXRIOctRHfEL/LMwzPkDgPG85x4FvfVkK?=
 =?us-ascii?Q?ueY+2pW5VTDyTE4V4+Af6o+cGGSPR+Eg02MeqROgyxV50MMDJ1vlH4azOFPD?=
 =?us-ascii?Q?zzfxzAv/WnDJJ6THQC89s92WQ1cwA9tirVkyxcYidF11K09JB8/YQGxGEkVt?=
 =?us-ascii?Q?l0ye+GemFow5L+FaDzStKkcTWji/79RLJDNA6XKwnldvNKtBQ3OwcS1xFe9F?=
 =?us-ascii?Q?/WBBxi/QTKsBvgoqrSQF5C9AFELEvw0dMP+7Bk51k5khZx6Mq00QVD1BbvXW?=
 =?us-ascii?Q?9g5YdrZCjU7QCRC449QaYNl3S5f4hitIOcIetSiQIfaMv8FE/QMwaiQq1b17?=
 =?us-ascii?Q?XS4oHEAdwiQLF4h20gDVSaL7lgvxgreCOqh/bc6X7uAjyO3/07SrMW0er+rx?=
 =?us-ascii?Q?umGoFNA5QoVz5QP2BlFmb7ttJ2JQg/+hFCpz8YIX4nghLDD3yWLryFBjgvlk?=
 =?us-ascii?Q?04Q74I4l8CGatyrgEH35mgn0KNkBXoo2xg3ABkKAEfGIZPi97CGJR8ULqXH/?=
 =?us-ascii?Q?nN3nsGTmkMx9hNY5VT0qTYHb319a/ZQP1nwM91VkDEGVezPXnpLxs6nvDTaa?=
 =?us-ascii?Q?6/6y3hNhrR4xDnzLC3t76jtze2JtN3Xe0zP0PFvOZT6qFeBQfRUwdLJgP0YC?=
 =?us-ascii?Q?nz+jBn66qLshMQeGCOFH+MFCEh3dJE+ZhnoDTcwmlW+YGj8+NS0f54axSO/z?=
 =?us-ascii?Q?hC3H9psww+tMTtV7Dh9Rad4vRO15vKTU/wxgLnHJowRS2JV7p4X7QJBf0YP4?=
 =?us-ascii?Q?zPqJpYdzEyC4KQ1UOoGjYp9gEkRf4CNT9h5Aewt9u5EULWXR6BrbPKHYFhtn?=
 =?us-ascii?Q?uLUhXPGdUcz8FMi+O5Yl3e2/q4pGg09HkNf/v9IMwJeEAvu766p9PaSaHuSl?=
 =?us-ascii?Q?7dFPsU46lk9Z56Id8kqRiwxOioERhrQ4mhPDkfw+F8iEvvVE97XnYgy6llTz?=
 =?us-ascii?Q?0rd7pDW2QPk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?qQQeNjw/EgXlziAXn6njEvAO41S9xSFYedMRXr0309IoZ5kYpL7KCsmW7Doj?=
 =?us-ascii?Q?JXoJPVxafsh5ov4U1o77qVTFphSJjF0uy2EAD9fAzfATK2TbmL9ItPEU9ZGx?=
 =?us-ascii?Q?wbPILKd5fG9PkPSanyr8LOxtvEMoo64kIzinlevlEy98a7YEHpmhC2D3fRMO?=
 =?us-ascii?Q?O91mHX9YDFi2O5PiNqJuiYSLwg1q3U+d9Lm4qvpucCGxZb0OCRTp1wbKrg7q?=
 =?us-ascii?Q?zz+hbGRbkliGlsbHguGi16SIuBpMwlGwlkrgOdZOcd5iQVe+i2VXYbQsdhcw?=
 =?us-ascii?Q?qYYpTtYUPq/V4SwIdo9DR8t3WHcQmso1vfAgH8YGWSp+QMpKpZN7e1NJklkv?=
 =?us-ascii?Q?9Sjr3aYDyCyJqypVqtKoeq8e/DRTA/gzm3TAqeZxWoxOB0LN4JIsMtByMj+X?=
 =?us-ascii?Q?ltA8Wal59FAcxBSNBfyGIajMvrA5bLAxzvbFBYeYxqNHLeTDgbQ5101psqSZ?=
 =?us-ascii?Q?sSaokk3Vjyf2FHDoTuiJni8R9CAfa4xK6eLH2WG6V5q2fLXVQHCBPNLY5EYG?=
 =?us-ascii?Q?ukt8r8yQlC0UyyTd5eMVncb8i9L6rgRp7OUZD1QnMeS8IR3b2a5GfRsfIUEM?=
 =?us-ascii?Q?flF9q9rF1RhljHiM+cJpQVqxfY7/KeROkFH6NAK0i1S8gtRe2wSJ7uPx1UZc?=
 =?us-ascii?Q?I1tVXMKkWoW6KLXZx59E4rJnlqogBvme5yqdZfbZsa0BiyRKQmEVwcPzKWpf?=
 =?us-ascii?Q?AdEostY/OAg1T7yCGJV3eePcpGTjEwKBWZyhxu2ODWHXurX2rz3W/hnpEwak?=
 =?us-ascii?Q?7hon9JQN+fbP4dqRdCMgRxtautHW7vgM5CBsFgD7puDlb0xHPea6NL1KMCnB?=
 =?us-ascii?Q?8QQ4aZBJtSfEOagdq/hzVzuiQS7QrW9zw9c8vhzWUNhCznBvRRJUJGiG/Dk5?=
 =?us-ascii?Q?5Kp7sPhudYldScRecdwV8CtApQuYTQVkZKtQGx73AOWa8kCYJJnpXV5ULS+y?=
 =?us-ascii?Q?s8GNj3XGxSAISAOwnT9UmYbd11in27VlEX5cxw85HeAlBK6z6bJXypcFeJfD?=
 =?us-ascii?Q?23VueOK9PoOg5oHnGX/EVyNUMST2ASLZC6vTfKntdFEfoi7zpItRlYJKrGSm?=
 =?us-ascii?Q?zXcHP6J+p81OPPhtD3dyJdQydsS9zAB2q0OL8vGqK+++VUIrMdbjjDtIjmmc?=
 =?us-ascii?Q?/N8lPbOEiZwio4s9XWUuOasMLUfZKFA8YIKQybiKgUgeKVDKbPCZuS9qILCf?=
 =?us-ascii?Q?53+IY/3mYgJY1oEuPvX370gyvcT9n8fhxhgAQd8aKSzwxJnrOhpid4PKZ9vn?=
 =?us-ascii?Q?UymID259sIHg9lec61cGLhCLGN6fKSZoL/M93oYfdB3JrrPGhExkpG3BXrAU?=
 =?us-ascii?Q?YqKDIWV65rUvhhqZis1HPLkeWdN3sF276gaNwqTp/Y8rDoMFSq42TH202e8r?=
 =?us-ascii?Q?ndvP1o7DHx9uHTTKNGfb7kKnc9+R+SGjk/DMmWcfPFKBLLMOA+MwP9iLvuta?=
 =?us-ascii?Q?djnqZS2YvCx5vt87N3YGY8Knb9nbgwkYBN8dZKqlijvibkeVs+EBDBvtQMj8?=
 =?us-ascii?Q?D9je31uFZ9BA5uxTG+hOqK19zr0k/lL+OMXkS5uAIlUHpwHQr4lA/JKTtUsf?=
 =?us-ascii?Q?Rp2Om8xMeErCmR5b73vYS07JgAv/MJnojt1KELQ/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	FOMg67UFbuh7YEmHhy9DhtNLLBg4fU3UX67iRcPFPmcebPjEs2/PHHNRVDBo2uv0OqnZHre5QgSTuLq38Hg3DdAwlcFIYwrP4vbnFpKxqtq8UbhcQpzjCQ3RQWRhuwpi5sRLGEsxE0AOfKzEnpZpmWPczWjVB8cno3SSx4w25Y6ELSbSSxFZjvvShFsfoXK9iMIz5J0mI49gVNJy8/+Mi7GsXpmefHO+A/A6oHxEj0WFEVcRY/IjC02t5NwlLBIS4fcgkFReqf3Ft1Inma2mDh/1UO/gn5e5TyYZOGtby3Bj5lGcvvGLHusRtcsGSnCVCAHxV3s2IiqUviteUhq5oF0aOh/KZxn+46mU8/NjmGuQ3xr8pu5d5Tb6EERIZ87YjXzysTMB5H4bCh1ILt1gLBqs5NIJpYgtszzdWXe9q1byNIZXNsz5i7wfUwi3kIXZlzjuJa5XvQktZXrHgJYiqAFzeiwsmRNAPBgsm3xBOmHXJ+4GIMqxHycU2kI6bTJkl9wp6gDPQ3EPK5Z4u3Mmj1gbYtrlbi5jkxqOYp3G3F0I3wX/6absouFbcjZDpaYAC8+GX7y9btCXnFQ2ZpN7gh5UGw+jCVTLbNmGKw+7UDI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deab7179-8770-4870-2d1a-08ddefd476a2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 19:09:56.0417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1GEz7GtCGC9+gPGpRGf/LHxAKHmNKQvyZ4lL45ClV36+DacQpTL6/wBKWuh1N4f+mtl3TphimYg/bKr/3uo+Dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7052
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=839 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509090188
X-Proofpoint-GUID: Cz-7P2lEUtPYMgIvVM6RfaDZVImQXN3P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfXyzItNkvyOzuk
 gO4dyRI9yY4j/meD9qEgh46fW12i3d7SuN4ZRUrz2oBYCKVDgrgWW33LZQYInChLCu2tUWr18af
 +PTGf9HaUl1De4HimDpvpYgy7hAFIkUTaeI3C9WB8ulGm7D462HzD7TfVWhZmp7K9aO4mrBPLeD
 gpOwED90EcqyXfgCgP7zanQOJ/LeH4ZnxnP1QumgehJszEnZxVhCkdBtP/IeC1p3ew5V/FwDhcL
 yFnFOsW2xZGpWOva7i2u5psHWr+Zn0vSrNOhNlnRmJCk11dEOrQPJXK7M31IlJ9teBOWk3/ETpt
 rjFXJgLd1WbOzQCfn8cBhblE17sa7HcExoLGucPiwqJrqG/jR4gqui0eTm6hSgZVzzV0x8/TsO5
 y1JEDEAo
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c07b8b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=vRAc46Nucz-5yIst6M8A:9
X-Proofpoint-ORIG-GUID: Cz-7P2lEUtPYMgIvVM6RfaDZVImQXN3P
X-Rspamd-Queue-Id: 411A5C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: amn17rsx7j3bbi9kf18mkgnqepftsy1b
X-Rspam-User: 
X-HE-Tag: 1757445012-341951
X-HE-Meta: U2FsdGVkX1+ieAEh5VDqdVlsjuiEQVq9NfwYKO+rOLyLwJnHP0kY2whuudvlLGMCf6BmoHPKwTqKOdKpYQQCjyAsoRG1A7jySdN9ytGuTpQPimJi/OihtUSVZ7tJuY+RoLwczg9/z3CQ40v69ibL9n/WzF0aYuCQDRnpo4sSwN1X5MAMr/fmBY7+qzjBvcX7elbTYZJWK1w5DOXZ3tH8JHmd1qVk4t+0qHCq8R3wjngnKPOBhx0iYTHqxe4dia/kvB5nL+D9uOgC8ZwSrI43VDTlsiwwgZqS16tZtum0BuzO73xLn5RE/m6BCcDnq46m6bSqDk2Vvg6svr0xD81gkcpqyi0ExWITMYVH3Bu1TvUaKnC+Bln1AvB/gn9MTJR7GmibCZaLa3+lwBMrwmo34RShax0eFpH5bhgtKLCmtzcwCL+lulDTxVupfGk9vWcHVPlBIalMJsNjPvZ7ZqS6/zQBxgkAXjbw3lVA4FCKoZGfDXnhPL8KDsMMm3rbIoN03959vANrwFePzlRzLSlfAIBI89LxkM3TUo4AYUEjH0EutbW+DpOBbncjxvYbQHXbIHglkPTUiapHCGGwg4E/SBwGetPv5McGWyE2IWnEiDL1/0r/GCGvu8xgS1iHQnXFi2I1HCKMBzQ4w0XcRXpP1P+6L59ayu5SJIb2PqWfpJ3OMvw76QthuvW7UpN9IT+WrH7nbxIitjkpE52uVooZ5Ja3G9rt85dNRWgMjOgEBQZFS6Xi639yTJ+8MAqmUjUuwNAycBS5tC06NbNzD4HMHVUwGDGvZxWCg0ujxVQA5HB08ql9RkOmYI16FytRjMUUqt644HfFXEruJwUbenGH0gqi4Ib1snr/K2AfwyWUSw8inSEUa1t/acHO48l3HaWxtoLIIns3hwKYAz9PtgZ4/Hy/AAX4e+QVj/705xgqneWw0/6tJgmUF5YkxP5zZYSywoPd1YzH4ptCpOZmhER
 BZ/mWHwP
 bnLG2U0B230jfQ1YAAJM1vukjldu9h8LfKmjjDn0DVHlCoomyK/ZbT3Nxdenizt2t1T6beh/6k99tC70joz01JZQTr6X/S5O2Cw1uNb4pOStSjxDtKVd/4lDROKMqJMu6uI0cRTdxcMMGP6B6aSUwkSURWIExXKo3XhRarL5lwOPxBUo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a limit to the vma search instead of using the start and end of the
one passed in.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 mm/vma.c | 6 ++++--
 mm/vma.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index abe0da33c8446..a648e0555c873 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -474,6 +474,7 @@ void remove_vma(struct vm_area_struct *vma)
  * Called with the mm semaphore held.
  */
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long vma_min, unsigned long vma_max,
 		struct vm_area_struct *prev, struct vm_area_struct *next)
 {
 	struct mm_struct *mm = vma->vm_mm;
@@ -481,7 +482,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, vma, vma->vm_start, vma->vm_end, vma->vm_end,
+	unmap_vmas(&tlb, mas, vma, vma_min, vma_max, vma_max,
 		   /* mm_wr_locked = */ true);
 	mas_set(mas, vma->vm_end);
 	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
@@ -2417,7 +2418,8 @@ static int __mmap_new_file_vma(struct mmap_state *map,
 
 		vma_iter_set(vmi, vma->vm_end);
 		/* Undo any partial mapping done by a device driver. */
-		unmap_region(&vmi->mas, vma, map->prev, map->next);
+		unmap_region(&vmi->mas, vma, vma->vm_start, vma->vm_end,
+			     map->prev, map->next);
 
 		return error;
 	}
diff --git a/mm/vma.h b/mm/vma.h
index 9183fe5490090..a9d0cef684ddb 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -261,6 +261,7 @@ int do_vmi_munmap(struct vma_iterator *vmi, struct mm_struct *mm,
 void remove_vma(struct vm_area_struct *vma);
 
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
+		unsigned long min, unsigned long max,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
 /* We are about to modify the VMA's flags. */
-- 
2.47.2


