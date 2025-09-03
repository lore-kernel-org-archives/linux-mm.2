Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0CF9CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 20:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404DE8E000C; Wed,  3 Sep 2025 16:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B6CA8E0001; Wed,  3 Sep 2025 16:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22FA68E000C; Wed,  3 Sep 2025 16:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0AEA38E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:19:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A11695BA2A
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:19:40 +0000 (UTC)
X-FDA: 83849054520.05.D3246F0
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2B4982000B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:19:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RvINnDlj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MeLiN28m;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756930777; a=rsa-sha256;
	cv=pass;
	b=Z6w9QGNfqt4+/oa8lf8dW4rBW2qXBdkXndxSkWsymYbiyKVfQJM1AIQ9EK9da3ujQ9BOmu
	hkZNcDXBm12EUnkjKuSbuwLDDZO7c8LDxVn+BTB3lvTta2kn51/cE5F67ZjryrOiGd/giX
	L+J6IVpJL1XfHBGfq3qOjXfoLjep7ac=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=RvINnDlj;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=MeLiN28m;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756930777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egJ8eykTZ4Rr0EruhgOJaC2o2+VHZ7ozanKpalqnXpw=;
	b=cDp45bMEsqNI4XnUtNJJiPh1FLzoaODcAq8UVsDg8rW+UhhW1+++Sa8ZKkzhdiHifZ8yYL
	+kdmGLqpprTDPCM/EjqmVGksdwSZbwlSv/nmx850hHDUyl4Suj3k4aP0bYTXurGcphjDTr
	K4hCbYzq+FoPKfKOmyrcNMpvqKqHTeQ=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 583JweGM029733;
	Wed, 3 Sep 2025 20:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=egJ8eykTZ4Rr0Eruhg
	OJaC2o2+VHZ7ozanKpalqnXpw=; b=RvINnDljNJ62c3QRNH+afCinfwGWC6FNqh
	ve6Kmk8Y0lFjlNcNVKT9fT7bE5mF9rLR9EezGpZyabaF9DBt6IIVnxU0EtJ1ndRl
	89npJyWYNYipxkr9Bn+2NAUrc/SoLbveNzMrM6hmrp9bRLF303VekfKd/o58D4on
	L+FxAx3ieTbvVVbdlIc726+3pSyyfWq/NvIJGMgeIwKWgL099huxlRjhfv4pixge
	vvc1BXfeSpOSLi9PSsX8HPEQ8xxrG1lIVTzOtFIfzcnv51Q71WdTN2p7Q58bgxLi
	i1VVCfraHpI9oe1hccV6QuLJweFQ1O9IGP8aw8l3FBUOVGdf86uA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48xva3g13b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 20:19:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 583JEFPV015837;
	Wed, 3 Sep 2025 20:19:21 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2068.outbound.protection.outlook.com [40.107.237.68])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01q1q07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 03 Sep 2025 20:19:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wam/n0a88vEfWW8pBwSi0iMrLb4t3LqDQQ03PG/7vbuvn1M2QNvUqeqD/MBv3CYQT8cuIoYu7rTaSLyioNAXybXWW3t7DiEsDETw8ItkFJ5Oo7QAUfW76IJXIiP2w4sR+sFMFcFyOBlypLsYTB++8OY9YH0rAAQmw3ZUnWNyJaOU3ZPYvhhgDpvdcZ7ZKhAgolhl24MeiPQpyskAPq4zQQcr/e/E0yEVd5fLoh+ncvxO8w8AxyknC2lcAdUa6xUOytRgu+TDZq66JUj65lRDTKIxjolaKHHgpPqibxks0Q7aPqU8Kgkmtg4gMuPLCTKroB3Oyce5HL8TAIDI/vg6lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=egJ8eykTZ4Rr0EruhgOJaC2o2+VHZ7ozanKpalqnXpw=;
 b=EHRyiOmLKSGENDAblBtnPOzIIVd33xrRXbK/OueZ4Ni2DoowQuDrBdOVhqROkLj9qD7fSd5NTwfu0KuI0o8MqHSPAiUtK4AIIur3zWXYy1D7YC0V8oHNKXqGHDkIvnqIfZMsmhb6Ke7MCLNc0bmdB1VjCY2XWz0WNIZTTSAjTbXNc9tE+duvMsWlUqzEpSQSAMnWIInTHpk4F1dRVXACUZWEoytqK5T0NgqbrKmM3E4nP3Jir70lJfP1azwcXBlUIT//CMTE1fuUWbvOU3Eao+HHECxZuBjzx52kmWmve9Ymlqi5hRkYljCUMxAc45uTgJ2hjS8kmHkrpTh59V/GuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=egJ8eykTZ4Rr0EruhgOJaC2o2+VHZ7ozanKpalqnXpw=;
 b=MeLiN28m3SIOjZ8W7r6skqg0VCYvkxHG5Q+bA/3qCOSJ4FKKKbB5ExJGdC0aLOxnaqefnK8k5JFcWqgaYudKoPHImwdXfGG104ifL7qN6KEnae/cbhYfh7rq2GiEEx6UHR3VtE5oVZ0z3pkTylRSCAqY0DvzSqkCoiDfOh2ML24=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ2PR10MB6962.namprd10.prod.outlook.com (2603:10b6:a03:4d1::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Wed, 3 Sep
 2025 20:19:18 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9073.026; Wed, 3 Sep 2025
 20:19:17 +0000
Date: Wed, 3 Sep 2025 16:19:04 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH 4/6] mm/memory: Add tree limit to free_pgtables()
Message-ID: <hs5nuhqzqyt5mp3fzznuaiyyck6b6ovuxoxayvm5ofhoa5324m@gtmezuqareiq>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
References: <20250815191031.3769540-1-Liam.Howlett@oracle.com>
 <20250815191031.3769540-5-Liam.Howlett@oracle.com>
 <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39c46a52-f63a-4f3d-a276-6f59c55680ba@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: MW2PR16CA0070.namprd16.prod.outlook.com
 (2603:10b6:907:1::47) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ2PR10MB6962:EE_
X-MS-Office365-Filtering-Correlation-Id: 6dc2ebba-16bb-4dcf-1e2b-08ddeb2728b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|27256017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?smNRc4JsTJ8i7PPKwh58F2mRZQUY9Aqnbi0jb0/iuRaMyIsobTWqS1uMTZwh?=
 =?us-ascii?Q?kdCil7/ZXmLK12mPhXR6kvrgfCPJ9+2A1Ie5f/ZqwES1zIvVOhUimJZVqAHJ?=
 =?us-ascii?Q?5DQ/5voNHr+H49dpvspWh2+L+138OeqK7e6lCCpnlTF9O49UYbKRq6OSmEH2?=
 =?us-ascii?Q?uZcazISX/RfkMEXRl/fbGpJHWuDTPP8MP4Or9hIyB3csqfmEpBVuG6hhIABm?=
 =?us-ascii?Q?b9OIb/ctWB0Khdnmqh2PDi4eFlJ3C9z3ieYp6lpAAU1b19RUTG+WDFZeaLcM?=
 =?us-ascii?Q?lMZN890v2kckUGJEZnsBcahSAJUGvC9dwtGULzFVdoMd35fwSb5pXmEJ+ZTE?=
 =?us-ascii?Q?tVe/0DGLROSrAJwf5vPrfSQpwA/ba4KzgV802BEtAvAaaPSiFooAE8lq+3zk?=
 =?us-ascii?Q?Gi0xMWUiM/b124FnkSC0DgXwS51zg3tjoJGAuh9YduTjnKtJpGekMF06VkNa?=
 =?us-ascii?Q?KtjKfzTuMoC6FE1Loqjh8v/aJ9zRPx7kPud2poaPIRULHGorTDG0bGizXPfl?=
 =?us-ascii?Q?vE+HsYrY1sHgZdHONrm2gkjLSxoE99GzvBi7MGg+bol/PRu2k/xpMcPXrO6k?=
 =?us-ascii?Q?hG30B3f0S7KIrqHYtp/fQBAu7btPe0y0tzMNtqxNsJi2HHVbr/fBUMh+yAHF?=
 =?us-ascii?Q?IW9AwscMFgRLgLU18dJ5+32kp8PDEisIHaTSfi41B5T7OGcAnkDeqVBRwHnC?=
 =?us-ascii?Q?Cdx4UOuI7mjTE4nRr05MTjZulwuAe7C4/LP5L7ZjTBhfSbb1HKUesi8K95RR?=
 =?us-ascii?Q?ix+uxge9RQJzsFAOOp5hqhnIP17nPNmsxGE4+7KpKHnjeIlNttcmyJj0Gn4M?=
 =?us-ascii?Q?MJbxAgBhhpIzCVAc/2rB59RguHkIiM7atigK7WTFQYu0yj/a2wrTjKX9UP3p?=
 =?us-ascii?Q?dlTTZaITeqQE8ObvMqdnnvcQM9vINHTm0v1vk6zw5TsLaHB7zx77OeEVnZEV?=
 =?us-ascii?Q?0PZQJupIH8Vt0ObxJfu3HuTKFjfJWnr/hD/e4zI3uwtPxH+zamBeLRzVNc/7?=
 =?us-ascii?Q?mNpSkgzEskzhAmF6OT4FYfXi9rOsqEljPYlmwBAwb5xnwp4265HmhL9YkuZD?=
 =?us-ascii?Q?lnDKQBm001tyCIOygbprVrhuAdVJm75DrYF4KVdoImUXUsqNShjXB1mP8i3E?=
 =?us-ascii?Q?nCYBfwU80cJPBNn/z8CpRlaXhOPTN915yvTKOgB6XPzCDDG/WDr/s3hQaOm9?=
 =?us-ascii?Q?MoMk8gnc3WJgMClzoQc8F99dR5TQR8kI0F46vIjdwsn0HvxoAGlfBbegi8Rw?=
 =?us-ascii?Q?0JULHGvs7l2SnQmbwuQTHSEzkzDLzWt++VMcwL+QvOpvthlBvB26N9NoutJC?=
 =?us-ascii?Q?tLz8Y358TxK01XCQMrkODZQ84wNHc4xegfssMvgWcIKx+ZwRl7/1Z80Pqjel?=
 =?us-ascii?Q?cPrmpYGHMOlmH8MLwMUn4hMuZXwgluvhg4bN1Po/xQdt0lEWLtmbFbIfAWZD?=
 =?us-ascii?Q?WPKzlVbIz1L9ystskrnsCZs6YeNYPxfJGRZuwpUNIO9T+sajG7Oh6w=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(27256017);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W1mXIaDlQmDBXhBiTn30ereLTHox1i6XknK/fTkzUrB9r3gagK7xokDRgHG2?=
 =?us-ascii?Q?HMHwYLwYhWijQ43oHHWNM52WepKInw7L97ue6oQOR0ZTAjRGc7TkfRr6+98e?=
 =?us-ascii?Q?fhoq5mpa9WppmMQX/7iEsI6SM0afLpdAjxqi7uJdyjDyoQjnyNjtwqORXz/E?=
 =?us-ascii?Q?lTo+9fiSixEXU4o14LySzv4MD4bt+qKzy3yrZnNDSDYniy2fjsanCNNbo9C0?=
 =?us-ascii?Q?Iz0fWRqtxUVujVej98HIJna5MxUruNWNL1l5tvdyfKbHPH01X70WpWj9y3tX?=
 =?us-ascii?Q?iqTClbgC1rQtQrU+yP9UY5AmiGsy+3vK8oJWRNSk1I/kERmIt8WihWQpABa4?=
 =?us-ascii?Q?ry80fOfQp72EYLQM/rgEA3EabXjHQVIGWi3HLz2fGm2ok+zXhb8Rt/XGMTOf?=
 =?us-ascii?Q?oRgh+MipXJXE/QY0e4o35AXtR82mPB3oLo+raVk5IFJ2QHbuwF8+8Pwww9Ed?=
 =?us-ascii?Q?rTDsZI6nvMcDDZ5FV9NLGxc8mbox0V2MMSzqT5CDYrrO/2i5BDJQ2nz3UbA/?=
 =?us-ascii?Q?Hn/HfoZicYOi68+A7Cbf6F4yV7Zy54mGnxxz/E/DOqKPZbqoIW5eYEbnH+wK?=
 =?us-ascii?Q?9pPPk6Q1lxYHxg/O2kltnz/C6/GiiVTWc9qQ595ItWGw5mw+0nZHSt7b/Ajl?=
 =?us-ascii?Q?y5YQYE9wpbUhB1bro/NYJpDfoUggB5ugyrwLZMrV1lwZ24lbqFkvxrhMnNls?=
 =?us-ascii?Q?a8YTyyVcjpFtauSTpX7ti2RmAr7ok/Y5JBP35Ar5vCz0cJYblUpL/QqOc6h4?=
 =?us-ascii?Q?X0PPNkN7JV7rmo+cxDQl8PrTRxjbqQbfBY/M7PdZBWVoj4sUjH4jEXjnUDbH?=
 =?us-ascii?Q?dS5MrOzw9gHYGSxAeEgziGosUBV++DffvHwnVOwJF41g+iHkeEfnITW1UrhL?=
 =?us-ascii?Q?zNoW9J5KEzyyAZisCcpF4ReYFCHyEgDQuvSygkXt4yhBue2qD5MHY3IPfUIM?=
 =?us-ascii?Q?3OC25/eGb/ZlKVCq5LlTOFAyIoiA7IvqPa6CGhWlvs0H9/FDEaigk06F8fCY?=
 =?us-ascii?Q?4Z3JDlssBNP8blnHRtatQ7dKyVRZLk2sUhjBJlKG96Cm9UZaYBlL+L/RXOVp?=
 =?us-ascii?Q?wvWrEJWyixEyx5XwWodznbK1c72MDa6bfVLpiyHe8g45nGzN0ejyfy+FyYQk?=
 =?us-ascii?Q?N8XKRUlbGoaMHduuo9Gd1EXQE9JF8hNdL8FBrOF2VOAIdfTJO8iC+KFtO7LZ?=
 =?us-ascii?Q?qiumqWflMRNfVZOjr/ky1BL9IG4IuutA4EO9MYBhDu9opN1DD/821WCjXrDo?=
 =?us-ascii?Q?KPZsfwErkXc1g68zNvT+s1xK/PCKOi0Dcwg9CrGAZmNF8LfGL0YjrhhZ/kIP?=
 =?us-ascii?Q?O8tcr95nSXMDJutokFWVEVzqr2m+dvPEpFj/W1ZOxkpBKNUnPV0KsUU3HDGa?=
 =?us-ascii?Q?Y0jBHYbvLYXHlHtW8YRl5UwRLTb/Kv1+YfRRszdPBFvV77sOabSGNo0pYJiG?=
 =?us-ascii?Q?+ND7ROON2vtCXZHoHc5c4bAAexghUplWZ6kWeQNkeHjhtSTS5kLIch+xoym2?=
 =?us-ascii?Q?OWXqm8n8bIm5hN64what9MhP5lgQzoJ+Wdq/bqrgviM0bnWGB9pdLtm7jtMA?=
 =?us-ascii?Q?nat4f8uhGtNu1+ujmPyDa64sArZbvcAugPO5zrdB?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8gBq1CRz4xNAJSxXtacCvoCvR9RXSYoUZ+3maOnQigX6b+0pRWJH/FpOubWzbFtxPSKxRRkCq5qRfXu1qnWXrpxnQ200RwYRTr9o8YhZZu6X4sMvTOEvJ6Xfq8UjDBQq5AuZLcIjOFqX1AgsgA8sNhn7qp6CqT8+/TxQurGx5HcbPzV0r/UC7f/QfbS2nnVwQ2kv0JWAWCL9nH3UXNTNjIOmKepyJ2GlGhFcDmqq3cXsOXA5L7HQrkNPW05gKYdCjFW1JHoA/5XAwg17fHq4UNseisf13ndgW2ez8dIKDu+kQOpeoZZBqWRo/DIiASTeBQrj/LEs+oWMVGdKhFJA322HZHR48zGgZxX0SX/77WtftbSTKAgHYAI2g+pU9+F9UpECmHr615ckMzntW/9c2xJAMw7AK9+n5pBxcuzeiKWDB51szHGIJSc/y6ujsWr3Zj8LeTNwSaAf+CSADrYuI4UilSo50+nBtdcGa2sEqzD3cOqFC6hitt5NUVB+EkIKsuxuQdkIJezQTmAy43Dcymwd9CE/1/UmfNpf8drOJ1v9pf3xLDCt6xIKlBvw18UluFNV+iSRTENkAoQe5kZiBdOM1Lch/ukMIVfz/TyEBeQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc2ebba-16bb-4dcf-1e2b-08ddeb2728b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Sep 2025 20:19:17.7522
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /12HtVJWP3q5hgkUdbU9RGG0i/f99j31PNuTQIZzTAV8ua96U0oRyY/fXmTiAxA630CmOyPqGRvryuM7m5wyDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB6962
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-03_10,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509030204
X-Proofpoint-ORIG-GUID: T5Cz3YRsFzvRCufWOjtn4eVPJiE5ovgc
X-Proofpoint-GUID: T5Cz3YRsFzvRCufWOjtn4eVPJiE5ovgc
X-Authority-Analysis: v=2.4 cv=TJNFS0la c=1 sm=1 tr=0 ts=68b8a2ca cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=0SVIaHXMnj4LcPNKlMAA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTAzMDIwMCBTYWx0ZWRfXy7uetzQwJSJQ
 JHP7XoN7aSike6cHHZrGh/LpPu9NmVstxWf97ElJ8Vs8kTQekp7TMEEzn+a6gxSp8tCirJFh+ac
 JfgInG2+SlliWHPH8HyEIkHWm5kDF/qhVMAyb9+OlteHVtagRSRBhljoIfx3l+18XVWUJJNikLY
 OxDrYt90GMI5uq6HNtYguBjYUEZccp6J1NVPgJyRnPwZEbayWvS4RpaCgbDxJ3aX0HF5QqRZrwr
 Y3Yq5JQC1KR23/iIVgaD6nh7iv+lrZu/P54d6qchCA8UKUCWibXS/VKaMECbkl/fkCYC4wlsfr7
 +p6PudFAjXvcr2jN2XcZPF/CaU6/GX6TajWAJt/NzQsfiLjG6jZWZ4TPW8O8np0lZoJo2jxNjGL
 jim7m1RI
X-Rspamd-Queue-Id: 2B4982000B
X-Stat-Signature: teot4h15qyt119cax85kexw7oopd5tdp
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756930776-685441
X-HE-Meta: U2FsdGVkX184n5v1MsSqqX3Wz+ghxL1Ti63YMnFVnZpHYDCL665MvkiOgH/JeWvoA9mmTh0U8CJuZa9+uKg0xbHdgmLXhULoxsrah8r7hQ3P2RIbBwy+3ys1SI1MgAz291hxqyKZUjQveVs5pC8afEvVXH8itJggllKjzLOxuOPt84hRPBPjSilQtTAmlHqKZDLhIJtSZrqCajmwAT/npzIgkNzKi3M57aV2+2+l7pPDZf0IRZXE8MBhpNIFh8V81TJ6M4mgPDp2N5xcX5gMXDxwfdIQHNmKQ+yDutu4q2T7dt2Msc6FpXMMErT4aa8TJBOjFX/vEd0t6RPoK8jVMKwPdwU3b/jmIErfQNCJKr/k5liHhEWXIgn10U9a5mU8CN2B+ZMejc5KxVeebYE7QlpWohpo+/aB3thYtUkM7HzXb86PdLOlpzeQrW45JWSan73Yt6sa3YsUgo7k69RMAVZ2DugjdD56orZ/vOEaJLwUxT17f4izjxAbUgp1rwfYQsIaHTK/AXsiHc8YPJtxrxBE3/nAYsJUahEcrXf+SeO+VPPE8WC0Jf8YFpGmdhZFj7Q5zfWvJKRYx6AyXqtL9g6h9HYlx+RuAGw2Q49c4CRFK/QiLPAnY4ZaQ9ARamtzCu87ycFvqOw1fFGkjlZq2aQdIlhTFRmikzeS6ult8VU5IIdYxaCC6LrYq/99kPSVhspkB05nhT1fVKrbih68BgLGcubxc9OdsSBq0SOQQzR7TmiGk2zyR4dh46eoocDkvz3lHRgV2NEmnmBydKKN4FNHa94inx7ADYa7svclhjxt53vG7EsPuv0bJJ0r5JQpFWIP0dEuqOKfRZTwjyNMnDjfgO6rMe+4gIS3gI7kqzB6bnCeRFD66QSLYeWM9S0YOECjmwTQnO9dqBEMz3aiB5ciTLtGZESJvwx5/hinPegqcAfM3zu/beHHSwuuIi9vkigrQTeVIJAAF2fZZWe
 xSJ02gqk
 1pgXLq/PGEU4VzIcIOIE1u9fcyKHvsW/Wxfhtg/h4E53jffzfr0C8DjoRnAoFnDKll8CIuJpQvuFLRT88ggpiZ6IBoFP8e7VYKlb3rBvW0Ie5IvW15E8NDLgAUgQ1LPpb8y2aMdnRxnvTOYNO4LW3rnHzVufaOaw0gSLQNzEz9ELCZjfqdTDEbxTTUESH00CceubQB0k8DZAqy+q0IA53ULWSeciFX37FprYZKlXijBB+qsiO+QfxA3JvTUj3NXgHR1rV+WO000hfeEqEwVsO7brLdyhw9cn7wjGflyn9GM7GGF7j3P5m7/TA8lcJzaUePVEpCIzaEAkM2yQ10gvz0tn68+NT9l8Upw3vCSof4cPzHAegIw/ADOde+13ADPXjv+vngSWHm97JP02pf4VPB8/ox9/ZaqVaRsdAOONITbAreYqQOJL267Mpga2LwUIJhhPn9nVlhCcD1trSty1xOv/wzqHtXpO7D+kcnsNd/qMfPnDpyVyXyp0Bx80CMxCuyRtW+ugO6qVdAkM2TCPpClhzpwL4d7ZnabG6UCUik5lv4bjVbLZEi0tbo8Ums+7zVxHIA5ZLB1nkW7E/WNwVHUjoW5J6KkC8mewgvIz3o+LvDYmygIIXellXZJLpViBYn6CK9khCsgmgcnMHlIeR1szQSxHvfdey3ENE0L4gS/4aCkye/b67fMSiKIaypaz1gBQVF4I7zKcjOCvC6KLeboRtBybn9K4vh+MRpinNdXDRzc0Zkpt8qgn8aRmT0qUzIcdP3aloPu8eaQ9Y5l4Z7AcBAHOcwmowi77w/Nx00RESkXmdsXMVdW7YgyeTXmMemghu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [250819 15:14]:
> On Fri, Aug 15, 2025 at 03:10:29PM -0400, Liam R. Howlett wrote:
> > The ceiling and tree search limit need to be different arguments for the
> > future change in the failed fork attempt.
> >
> > No functional changes intended.
> >
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> 
> (Obv. in addition to comment about broken VMA tests :P)
> 
> I guess intent is that if we discover any page tables beyond tree_max then
> we ought to just wipe them all out so, in effect, we don't consider
> mappings at or past tree_max to be valid?

Actually... there are some archs that map outside the vma and they are
valid.. I think mips? and I think lower, but yeah.. it's needed.  This
is why prev->vm_end and next->vm_start are used as page table limits,
afaik.  This is a serious annoyance because it frequently adds walks
that are infrequently necessary to the vma tree.

> 
> I feel like we need a comment to this effect as this is confusing as it is.
> 
> Could we add a kerneldoc comment for free_pgtables() spelling this out?

I'll add a note here, but confusion will probably increase.  I'll add a
note about the tree max as well.

> 
> > ---
> >  mm/internal.h | 4 +++-
> >  mm/memory.c   | 7 ++++---
> >  mm/mmap.c     | 2 +-
> >  mm/vma.c      | 3 ++-
> >  4 files changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/internal.h b/mm/internal.h
> > index 45b725c3dc030..f9a278ac76d83 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -444,7 +444,9 @@ void folio_activate(struct folio *folio);
> >
> >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		   struct vm_area_struct *start_vma, unsigned long floor,
> > -		   unsigned long ceiling, bool mm_wr_locked);
> > +		   unsigned long ceiling, unsigned long tree_max,
> > +		   bool mm_wr_locked);
> > +
> >  void pmd_install(struct mm_struct *mm, pmd_t *pmd, pgtable_t *pte);
> >
> >  struct zap_details;
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0ba4f6b718471..3346514562bba 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -371,7 +371,8 @@ void free_pgd_range(struct mmu_gather *tlb,
> >
> >  void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		   struct vm_area_struct *vma, unsigned long floor,
> > -		   unsigned long ceiling, bool mm_wr_locked)
> > +		   unsigned long ceiling, unsigned long tree_max,
> > +		   bool mm_wr_locked)
> >  {
> >  	struct unlink_vma_file_batch vb;
> >
> > @@ -385,7 +386,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		 * Note: USER_PGTABLES_CEILING may be passed as ceiling and may
> >  		 * be 0.  This will underflow and is okay.
> >  		 */
> > -		next = mas_find(mas, ceiling - 1);
> > +		next = mas_find(mas, tree_max - 1);
> 
> Do we need to put some sort of sanity checks in to make sure tree_max <= ceiling
> (though this 0 case is a pain... so I guess tree_max - 1 <= ceiling - 1?)

Sure!

> 
> >  		if (unlikely(xa_is_zero(next)))
> >  			next = NULL;
> >
> > @@ -405,7 +406,7 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
> >  		 */
> >  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
> >  			vma = next;
> > -			next = mas_find(mas, ceiling - 1);
> > +			next = mas_find(mas, tree_max - 1);
> >  			if (unlikely(xa_is_zero(next)))
> >  				next = NULL;
> >  			if (mm_wr_locked)
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index 0995a48b46d59..eba2bc81bc749 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1311,7 +1311,7 @@ void exit_mmap(struct mm_struct *mm)
> >  	mt_clear_in_rcu(&mm->mm_mt);
> >  	vma_iter_set(&vmi, vma->vm_end);
> >  	free_pgtables(&tlb, &vmi.mas, vma, FIRST_USER_ADDRESS,
> > -		      USER_PGTABLES_CEILING, true);
> > +		      USER_PGTABLES_CEILING, USER_PGTABLES_CEILING, true);
> >  	tlb_finish_mmu(&tlb);
> >
> >  	/*
> > diff --git a/mm/vma.c b/mm/vma.c
> > index fd270345c25d3..aa75ca8618609 100644
> > --- a/mm/vma.c
> > +++ b/mm/vma.c
> > @@ -486,6 +486,7 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
> >  		   /* mm_wr_locked = */ true);
> >  	mas_set(mas, vma->vm_end);
> >  	free_pgtables(&tlb, mas, vma, prev ? prev->vm_end : FIRST_USER_ADDRESS,
> > +		      next ? next->vm_start : USER_PGTABLES_CEILING,
> >  		      next ? next->vm_start : USER_PGTABLES_CEILING,
> >  		      /* mm_wr_locked = */ true);
> >  	tlb_finish_mmu(&tlb);
> > @@ -1232,7 +1233,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
> >  	mas_set(mas_detach, 1);
> >  	/* start and end may be different if there is no prev or next vma. */
> >  	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
> > -		      vms->unmap_end, mm_wr_locked);
> > +		      vms->unmap_end, vms->unmap_end, mm_wr_locked);
> >  	tlb_finish_mmu(&tlb);
> >  	vms->clear_ptes = false;
> >  }
> > --
> > 2.47.2
> >

