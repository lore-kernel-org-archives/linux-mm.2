Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DEDFCCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 09:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FBCD8E0006; Fri,  7 Nov 2025 04:44:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3508E0002; Fri,  7 Nov 2025 04:44:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B828E0006; Fri,  7 Nov 2025 04:44:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54D048E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 04:44:41 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0600358CA2
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:44:41 +0000 (UTC)
X-FDA: 84083326362.26.718008B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf15.hostedemail.com (Postfix) with ESMTP id A8081A0007
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 09:44:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OVkN/oHw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="r5xZpc/n";
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762508677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKXD5AWRKx2uUP2Szn60nCfknCcXCU+opxBR+Cvcdjg=;
	b=u0TJac9eVe7Y4+kkc/FoEjUjzbLQYqPEdlCXIdx0AF8RTXc0VwIyPbB++Vn4cu1CzgrZdM
	+6Oed6S95qHW26/W7Um4ZmNq8ajJtXi7/vJPzEHR8moM5WZrV8Bsb9UA5JsYr8wWv927BR
	cet6niiQhvosjvTk6l4WTynlCY4SVJI=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="OVkN/oHw";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="r5xZpc/n";
	spf=pass (imf15.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762508677; a=rsa-sha256;
	cv=pass;
	b=f2VvinH0ULkPH5xBYqowQyet211fIR5AcdC5gxFItdJqY8lWmlIbu+g9a54S5xs/UWKh+D
	Z4JwUS4eejwhMTjqLGe5qlANb8pnlf1qmK7hHhhDmiDC2EzS5GLSXWwn10/HT53mNnmfc4
	szJsjwQ+LQbEqhZDXjcvX2ZS+/wJRVE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A78ubso029920;
	Fri, 7 Nov 2025 09:44:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dKXD5AWRKx2uUP2Szn
	60nCfknCcXCU+opxBR+Cvcdjg=; b=OVkN/oHwAZTx4u5ZY63YCyNZF44PQ5azoB
	4XMNv+l9UMOZjYxFoTujWwFNq85AKBS0nJrEOJ6KjxduTEGScCknwSU+vuWAxWcJ
	6GQZOHSd0pT1v6rlN8zkwYf3/xiswA0S0TieUljZeEC4slzUyfRS0KqupsUSUSFF
	rE2jOIPV1blU79+6n1RpldQ4WSGSwVRhKGR+qxrZFTR5ad/PJMafHlt0HNSRXBKw
	Hj7PCfQqqaPDG0uzA4M/AxLzihCjKFaLoKrWHpCFw1/ETe8iVLOxErPlZ+vpSOau
	C/KHXssSrIwJ2Z8vADbBS9cDhgfZ6e49WDai5rvIDoF/02KYpfYQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a8yhj1j04-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 09:44:29 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A79Mwl9014876;
	Fri, 7 Nov 2025 09:44:29 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012066.outbound.protection.outlook.com [40.107.209.66])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a58ndahhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Nov 2025 09:44:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q8d3dPHIk/TYP6IaaPSBXiRH1xOM5rFFnBI42pnY6wa1awQPovu8DUgYA17Rk0qEqzi01TaTuuJYNY8buGXueUsIedZtJqNcqKEGlYh4fQj1tkY+wCRCxNzh6Bw91y6ejC0a2NdHr3rLVqsFjPe3uxy8/VIAY53sRKIQSFhIheNphHo2hmLgluJxqmaD+fF/5no6uxymqgbrt9vy/htXkGXMGbXpQjvrtfChcvAzL9e06Plja+ZuvWli3kPaYUTgO5ben0OeXXB+o5fPoiQ3uqj8lmunGyqmsRrADdsyaVSB0PYgxLw+1lbjaT4LQoFLeqclEZZP05LbtP36uKuFcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dKXD5AWRKx2uUP2Szn60nCfknCcXCU+opxBR+Cvcdjg=;
 b=KgjOYqM0aaQVqY8xROKrlz+SJFLFSnyKGFMJqugWOeV8xO8bVuUPSVbnn7ubFFtXKl2N10Zr8apfFr2WwPmJDkJmQvzB/FKQ1pNXM+udcdq+Y6+rjqz0KZ05MENdqZhm0NqK6jRk6grPOE00lcQS/DrrllG26ddEek8+ZrSNDPCrKP6Cyqj+XNNmcwPT42Tiuhwle4sDVv19/fr2SUVlSuEGxjhg9DLPz0Y7ieoSwjetO7+H1LC8Z/qmMe5kPKuVkmVmzv9Wz5ZUyUac6i8Zdcq33U/YoDKjJT+djYhlXoxGEBwTYf4HQ0pa1TRbm8ku0779px2P49KsWa3Spsw93Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKXD5AWRKx2uUP2Szn60nCfknCcXCU+opxBR+Cvcdjg=;
 b=r5xZpc/n0BRv0w7Sf7A6PwxU20BgpXzbNQ8azbGpLy7n8ls6TaQqOQSNpJ/B2pbQwglS/B6t7hpzr0SdtOjqSQ3Ze3O5eOQ4QKzqnU1RL2GQ+dHkCD21eWb85mLSev7v1ohVjb482QDCdRhSpS8lk8nkAvot2OqkI2hWe9JF4UQ=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV8PR10MB7966.namprd10.prod.outlook.com (2603:10b6:408:202::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.12; Fri, 7 Nov
 2025 09:44:24 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Fri, 7 Nov 2025
 09:44:24 +0000
Date: Fri, 7 Nov 2025 09:44:22 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v2 1/5] mm: introduce VM_MAYBE_GUARD and make visible in
 /proc/$pid/smaps
Message-ID: <0f7186b3-16bd-44b7-a3fe-637af9d25dd3@lucifer.local>
References: <cover.1762422915.git.lorenzo.stoakes@oracle.com>
 <fe38b1a43364f72d1ce7a6217e53a33c9c0bb0c5.1762422915.git.lorenzo.stoakes@oracle.com>
 <yja2mhwa4bzatbthjjq5rolqlkfgcbmppic3caaiwi6jc63rbc@cims6rqnotvj>
 <043dcbdb-e069-46e7-8f79-8fdaf354fb44@lucifer.local>
 <aQ24HAAxYLhIvV5U@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ24HAAxYLhIvV5U@google.com>
X-ClientProxiedBy: LO4P123CA0047.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:152::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV8PR10MB7966:EE_
X-MS-Office365-Filtering-Correlation-Id: 3715ad52-d153-483a-2b80-08de1de23c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QgrgS8WM5YdVqwxWJ1YMBRZw2Ru/X5fzsv4Io+Ds04yrqLXTn8peyLW93Q+a?=
 =?us-ascii?Q?aVq6JTLo4meEjPa29ax0kNBu3TihKOUNkfYam8znhhKNMs0QHdoAfAyuUKIv?=
 =?us-ascii?Q?h0iI7/1DtfgacWC3owyY6X8AMZ6JtxC4bmzOy/tYpzmypFBXCmqX9I1TFRVo?=
 =?us-ascii?Q?HYtkwIEGXrYchnKpk3lSGo/VmoE90aRXu+SJY6hw9Pj1VyXFCp9FXhhGSFB3?=
 =?us-ascii?Q?17L+tAF0oBdCHJlFx1EAvYxmJFessQNEEVFbm62SMbx/Upim0y2zkYyCyKX2?=
 =?us-ascii?Q?1SRCYAPMDdNtqDCgvwKqSDOgFJSe0Ztz364CDB+xjVXjt19sS02XbHM0wCro?=
 =?us-ascii?Q?aireHSTuMBfa2g6kvSz7uocHfAqUOFhKY9dsx5QjCtLUbWm5oKs60KgsvgKh?=
 =?us-ascii?Q?qVZvN2rddZiaXaEbwvxasYoOqIv8QptfxLm5ZP/RJk7Y7utJN4ugHcCQqtj9?=
 =?us-ascii?Q?2IF0aaSdPARJIZLwO7V28+QvvvBUcxn97Q63dL4d6+JahE3YWU4wH0Lfyxw4?=
 =?us-ascii?Q?GwqCCSAC2N6YoyXYBO3P2Y3hWZIs3KsURhhTCjZTOe3RI9Jm3vQ5sWR2SlPr?=
 =?us-ascii?Q?YzYHlm8WnAF7gHrRrP+ktPZk3AWh9wFyMAMpY8qxhvYvzDwM07tAkMWtWxRO?=
 =?us-ascii?Q?IiYFwAztg3VoOp7KOKcPFxGRhaAtfRsbhawi8PxIFSoRPWhGR+LB3tTonNM2?=
 =?us-ascii?Q?Jd7mdYx4qso8GQ+gCeKd6ZAxf1s75Lmis3cvK4UC0yEEON+qT94ZIdBAyn9q?=
 =?us-ascii?Q?ux+NyCnydGhH74DHRyaL9tAhJtrxk/ZWg7a0vViQjwFuic1hOskdDeOkU0P6?=
 =?us-ascii?Q?7iKWNhsDEKbL4GJUbfVKL7FY9fQwg7hzZW91b86Ug+LAxwmfse71/J/BdDS9?=
 =?us-ascii?Q?cFNym4BdGSc2tGhFZBZnARCgnegSWrXVUXIiD+jQiw5FHqveAgAvep5OsfZX?=
 =?us-ascii?Q?j7B7MgWrfAyGkfBRc7y3u1wkrTudozqScNx0w59hGZqv2P3CBGzNQfDhmvTL?=
 =?us-ascii?Q?lf+WqvDAECm9vcNxnxF4bUD02jALO+TacyQYEtq4L8dp7CJcd/LSVh6Z+GqG?=
 =?us-ascii?Q?zH3VuE8hz4kpK3kMzF9gB8ROHE+luoJpkzfuvTY7tRHxyQDjm+NxuO8gBEMm?=
 =?us-ascii?Q?wJhxmuFWyQTKXCKYCskLa6SuGXCyYeNcvdlLb/tAX63wfe+LshSSr+z01GXu?=
 =?us-ascii?Q?HbI2StfRRMJTLmGD27wpqYSHcjKzClEbTdPJuUGMSsRPOrCCZdkoHAltiif3?=
 =?us-ascii?Q?aFY1oSQtEFE++UZQX+8wj9lA5o2iLzJ9bSGNjOWFeeoAQIylIxafWBi98dew?=
 =?us-ascii?Q?EfSsMnC/gWbMtbr+BiVYYP8tu+Zx9jhGp0Df7Ws3NSiV+ZTEqBLvZCyh8uER?=
 =?us-ascii?Q?sf+icDAG8g6GNJg+3gw6gpR1TGzlSPnY0WuN8/iCumyq2TrrnGCbT9YrtzNL?=
 =?us-ascii?Q?6BsToG/7D3Sw8Pp9qpaLNvwXa4IT+yIIPzADsc6ZYom0F5pFeBjYzg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kmmi7c/lB2p2lSLW6J6qUaATNQHKwTBztbGF1n0KQ8mRLd4kMYC+bZRz9+60?=
 =?us-ascii?Q?BJx7miNIOmqL4zgjdaxpTpfEG0s0nPGJ+zl9gqTcZ09cIhfxuMBpG37ptjWI?=
 =?us-ascii?Q?+sar9ta59iVOEiN0k/c/XzmCsJ1MHpmDdPVZS+pLKIACgo7+DlJhcUxlFOQi?=
 =?us-ascii?Q?47xmY/v2bV1JEZyFXYfrTE0bhcRpd5Iniyi96CPZh1UUDwKzRRIh4iZ7dKIB?=
 =?us-ascii?Q?4qU28bkBxxdluo++P1FVfXgSCIbz9fAwJ+b5noxTh/mPIYWBfcwbErGVbqA4?=
 =?us-ascii?Q?NEQhG3GwHAHopGZ87qHcKqglyljEDFXz6GQGDg5YJQjttwpcvpTXn6N9RLsO?=
 =?us-ascii?Q?jf8OCl6B8wc7HiDOM18Kp77O8gHt4cfbn1lb/bGwtcF3lyek1XrFoTMVaS3V?=
 =?us-ascii?Q?w0XLThuRidSRK/sO7gX1hE9c3pFppt+ECCJrOeImX38BErRYTe7fIXK3GwQY?=
 =?us-ascii?Q?zar0dDkkoUQdTGakZRZTQnv4Pj3jXPRfK/NYzKnVY1Da5YyavO8Dz+xnpFeA?=
 =?us-ascii?Q?ZJJ6DTZGLYmyMLMJyiDc0089IGyXrE+8pXt8qghwNunWf8SRJsh8fh1I9maJ?=
 =?us-ascii?Q?Xt4S58AgA8nwZ8JpQnE3QjkKglcoWQb/5c49ntmiKyWjnFLCd0WDKVRlEXaD?=
 =?us-ascii?Q?MBpualL5H/J2T9uJX46yRYS7LIyYz3oSdHIElrkpiJDVTK2bqtCtLGnNzVVj?=
 =?us-ascii?Q?KNnaLnMuWTjwcOw6dZVHRiodPM+7Lw79VuBUnoVklED6ZIZAgea5xffVeFj8?=
 =?us-ascii?Q?87K7bB2hugiELt20ahyXKot/xzDAWnK23w+FWKJXlyRj68Vk481anxSlmdJ8?=
 =?us-ascii?Q?X/fIrw55zd0dG77oxZ2JZZHgpX1sKY5YK4mzkbxGbDAuTL6mrdoEO+pCZEcu?=
 =?us-ascii?Q?Ro9n3eCI4SSasWen531uUzxjUgO0pz67PaTOgaqjMIA5cK/KMNwyuCoJR7L3?=
 =?us-ascii?Q?cViy9fExvqtvEOfCBveuavu1CXk/qB2s1hnt19algN2XAzHIDtXj9TcEdwMk?=
 =?us-ascii?Q?cXzKhOIcIdI/poF/QbELjQNC0iaStgZow4GklM8vyKscLAn/MvGGwEmrcKpd?=
 =?us-ascii?Q?JOHURl/yjqGxUnSzPXFg5s+hMczxaNMx3xTZy5CnBRXcU5MJB5bcKHl79f2D?=
 =?us-ascii?Q?RmJ8mLkUt6SRi7lcmm/HH7Ka2tgiIOeMbz3jUPBWhVr4z9twIqazmr6TS84M?=
 =?us-ascii?Q?+MHGwG5HyFD4Yy4NHXPDWxIahSvgiTUSihz2cK9w2RIdIqSOeEP5FmKvJLZi?=
 =?us-ascii?Q?9wC4+QWilq+SROvg1vUjIOQdWfddk3PXWj7PMF44xXn1fZ5sySp7NLgDLPSg?=
 =?us-ascii?Q?X5U1E2GgALZ5N0yfZq2nt2ekSeCXY7Zz0NgnTS7ffvI+IhvUNuvgLMFR1fU7?=
 =?us-ascii?Q?Fetdrg/+0etjeX0yIcgPC+iQcup0rOZ+YUDoAtvnV3OBDr7lqlLjxSz2qp71?=
 =?us-ascii?Q?XqcJSzJ/v/Gxkyt7kTBNNnB8AXSp2CMHMuYZX1dG6nnEoBlkPA/xgmxn3Blj?=
 =?us-ascii?Q?u/6cS56pKVSlDlrQaP2eUJXE8SoYNbJTg+gbwoVz8lzUlY+08cSfDk7pmAVS?=
 =?us-ascii?Q?EwPddcxx4WDFAErX4hfFp9V6c7qpu2SrmwTrrZuJdcVSBQ5mH0B6HGq25Pc8?=
 =?us-ascii?Q?pA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	rSx9Ialzyi4KSDbOuJ9qGOU84+Nr34h/JzbtjPRCLRcE0Z7FtxsVRkgwHKBml9VrC87fRobJRdIkQDB1KeKrgSD25h4Yik9Thll9ZRWlhF05rmx5rEqOncdjnEFlus6AirfXdPo9mSmuZowiInnk3CtYkPxXS88+Fuvc9Tm5kClP9Fr/4c3iB35UGgal/DAbmpNzACiMv0BOcWofEOPXazKWb58N0729PiKQrSSlU3mz7xNM0p7R0JKl2W7LXfgOnGzneOVDz/fFBC/RsiRcBoG2g15TtPxYn45VAbOjsNPKGc4FTVsuw7DxUxH0sskldemjDoaYiykxc3T3tUJ05KW9mS61HQUcQavgJ5NDfAXQ/r7R7AE4JiXjf/VXHA8051PqK0Gsi+UvrM6O49d0jVmcaJVnCDcVo+NCsUP54wMzOoGm7KPrauntTSCfNtO3LUYFv7jVPknozPJIvMihYWRKancz8gZpFbZcj//XB3MMDKqlV0aSfv11GVb5LBT1ioT/u2wLSbtl7q3b9COtbjxCFwNCHCuLD9pNNREVA1CC9vs9dfhTHG8CJ0uossvFl3DGDR+fznIjSiavvtenw7YzgYPFo0z1Vs8BgjfPgSE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3715ad52-d153-483a-2b80-08de1de23c6d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2025 09:44:24.8750
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DzcRBkfmuv1aUzvXE+HBTZac2dTAtts/PowkwMeBu3ZCYEq9fOgTrMlU8VrpM8JPCDRprIfqedMWWmgcc21UF0slyN90oMCFNSYJBLZcQcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-07_02,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511070078
X-Authority-Analysis: v=2.4 cv=BdrVE7t2 c=1 sm=1 tr=0 ts=690dbf7e b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=yPCof4ZbAAAA:8 a=oHvQr4N-xIuw19cP40IA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA2MDEzMyBTYWx0ZWRfX4J6o58+zLxM+
 h4sVEi6JykKTb829IZb+RKUzIlrgv5MpOJLyG8jSp9JiP4VA44HeBangfD0LlT3KaK85/+Fm7/z
 xOQOsZVeTF5/0rOnte9PwZyXmgleWXsqq3Ot2zp/LYafmX+AdcxpDvfng2JVT74O0stjv8+akUK
 2Tn9ZWHRbAAteUZF19ZY510NHOzdsDoo4HSO0QkAig/spOJUFC8ZH6VonRxGZLXw+nVpYvvD6U5
 RlPa3ToODxLscs7fjz2o35iMsgZCFX62DEqpi2oWtaEjCwdW3aQrbsXGPVyeEK0eg7DTtKk1orr
 1P9ueXiKqGUjtvfPbhhgCMN11aImqHBrjgTQTRi8QIeLfvnQUEWLay7Zqfz4S90SVaIcIkn4dwj
 w89hwLE0FsxFAuQOUCAep2brqk+Xmg==
X-Proofpoint-ORIG-GUID: eEvPNJxhxeNun3f4CI1pOZ32GL__VPRi
X-Proofpoint-GUID: eEvPNJxhxeNun3f4CI1pOZ32GL__VPRi
X-Rspamd-Queue-Id: A8081A0007
X-Stat-Signature: f9xhmbnu5nypmcewhjmjkkesyb4jo7dx
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762508677-146580
X-HE-Meta: U2FsdGVkX1+xIkDZYGU1Vtgo7tkYk4mwIUM59OrnFO94lcE2sCT1Axwpp1DSI5XkkInNSD7VyaJdt5U6DCUYRLdLXUCDOeOzGNBmi9zcDPL3zKZiTh5xIw3gQ5HyEaFOWsGKjh8btW5bqITnBThwkUgwBWnE2hxFVOLLNHd5+hyPStrLaBLXW+rwSDyVoGNFCj6dmfR4BO2sQ9mqzWFLsrCu5LOoYoPCSGLE0hjbbq3HvR8OMrxs62IzZWjXtUFIw6DrMMCNGAsqi3c7HMNjLwfldwws9Si1/hlgqbPWfofMn89OLd1Wt4/hyk4YFknwrRbhIyC6gUTmJ0RRe3BpDlaHGJXcS+ygA0yuKGYKxn+tH9oNpWo8b+2t2E2XUv1W1wxlc59cZsMBm6F+ekWKmCEh26o3XSI9ITCKjsVPOCuMS2knwPDWowYCOlrABHKNc3bMEWuHA69qC/B4Btzw2YB0DbkGCtNiqYiRMh+Hu5YlZhsiaXkqcuvG7zmG3xlK1RN9iLHl3GPj0nrgkkcijfbGUVt1KJj/ZAOt/2Zq6LAyOY9DZvoymlRLPZo0Cgn7tHIwz6eSkzQHSLAdj/J5cS5Jq4kT0jN/QCj2k/9wjaOOz1mC3+IAjEDRt9gEDWUXE3rb5LCkuBmsGhQcO/jUYTCdyrn4o8YrI1d5S1U4kg5ho9RaI4gbFS1bOJ8tswgqiZsUIpriLn9zs2gNc1e4AzlFK8hJ1QXe25wFtpU8HThTkxns9J4ouvd+kJ7kluDvujsAMpsiIDsgdn65nbSFa0oCLfFf0SzzkS6QleXF/rzY6l4O0Ge4/aCzLYF/McXaavyUw3nUVQus7IFd6XQJrLobrY91SrM4J8wfZYnJb3CXUzaHISbzoV+j3zDovMDOf56P7hlZGOobpWUe2852AlB+BGnirMp+Rl2uq7hn50bJ2XRwHo+Bl8mfLSzGH7xHFiIf8OyiPoJ32l8HxSA
 3lm1EEIS
 6NfmUM2iRCeyzQwFqlypZaNDCm44+RM/WaVQaxMDB2wVAouvt3pyV0qh/UQue5+Givz39uwrmChcUDStdb5N1hl5vpizMOub0+QB9VgCk1TJEjPY0lLwE1E9pcI49p7MnbgCQN+LiQG8lyrjVLAMjRYpVQvAAD5R4rN3Fp9/2lQHFleFFFrB8NKVxS/FOU+8ao3e+2A7SjLI9zqagZes5zjphHun84MKpbm5XMrbsz8JPsg+fexX2KO739Y8X1l3PBOZUymzaK0KKQyGR07uViU9FBVxXMo3TrpePBdcXZ7GOMKl12cNVgd3dG0WvkzEBeS24ldTRe9ivV7/2tdmYaAN4XLFmhgWhTyjIQ3Jp72eSrgJhULFmjC67Yrzrntjxc9xWI1WDcBX74m0hfBYggl7MHL/MJlmzcXg3fl8Xk0U/BaLJ3VFj5UXtM2ezl0VbSxXD0N8byCgpyYXUysM4vavzDIR/ttprF0PzEM0LLtIC9+EBighdJyhyK3BeduPsqreyPsgTCrbd+2vybkl1PChWkbq0DRt+/1xJ3MeQfiUaKegFxwLhqC2s4WTXFiQf+Kib2oaVs7UxZbkSpgEPRRy6w9Z++ikvRMSsTu3u5ODncM8zhnM4cFtxm25gpxbtsTw+9Il81xY6kQFEFYHoR7FebHQzhKpyiKbCIgGat21bxtSzjFoBH3R8IlLbacPXj6PqPy1oSHzJTlgP7gr4cPC3rqB1Gqyzu6ULOFOTvwRqtYI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 09:13:00AM +0000, Alice Ryhl wrote:
> On Thu, Nov 06, 2025 at 02:54:33PM +0000, Lorenzo Stoakes wrote:
> > +cc Alice for rust stuff
> >
> > On Thu, Nov 06, 2025 at 02:27:56PM +0000, Pedro Falcato wrote:
> > > On Thu, Nov 06, 2025 at 10:46:12AM +0000, Lorenzo Stoakes wrote:
> > > > Currently, if a user needs to determine if guard regions are present in a
> > > > range, they have to scan all VMAs (or have knowledge of which ones might
> > > > have guard regions).
> > > >
> > > > Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
> > > > pagemap") and the related commit a516403787e0 ("fs/proc: extend the
> > > > PAGEMAP_SCAN ioctl to report guard regions"), users can use either
> > > > /proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
> > > > operation at a virtual address level.
> > > >
> > > > This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
> > > > that guard regions exist in ranges.
> > > >
> > > > This patch remedies the situation by establishing a new VMA flag,
> > > > VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
> > > > uncertain because we cannot reasonably determine whether a
> > > > MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
> > > > additionally VMAs may change across merge/split).
> > > >
> > > > We utilise 0x800 for this flag which makes it available to 32-bit
> > > > architectures also, a flag that was previously used by VM_DENYWRITE, which
> > > > was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
> > > > bee reused yet.
> > > >
> > > > We also update the smaps logic and documentation to identify these VMAs.
> > > >
> > > > Another major use of this functionality is that we can use it to identify
> > > > that we ought to copy page tables on fork.
> > > >
> > > > We do not actually implement usage of this flag in mm/madvise.c yet as we
> > > > need to allow some VMA flags to be applied atomically under mmap/VMA read
> > > > lock in order to avoid the need to acquire a write lock for this purpose.
> > > >
> > > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > ---
> > > >  Documentation/filesystems/proc.rst | 1 +
> > > >  fs/proc/task_mmu.c                 | 1 +
> > > >  include/linux/mm.h                 | 3 +++
> > > >  include/trace/events/mmflags.h     | 1 +
> > > >  mm/memory.c                        | 4 ++++
> > > >  tools/testing/vma/vma_internal.h   | 3 +++
> > > >  6 files changed, 13 insertions(+)
> > > >
> > > > diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> > > > index 0b86a8022fa1..b8a423ca590a 100644
> > > > --- a/Documentation/filesystems/proc.rst
> > > > +++ b/Documentation/filesystems/proc.rst
> > > > @@ -591,6 +591,7 @@ encoded manner. The codes are the following:
> > > >      sl    sealed
> > > >      lf    lock on fault pages
> > > >      dp    always lazily freeable mapping
> > > > +    gu    maybe contains guard regions (if not set, definitely doesn't)
> > > >      ==    =======================================
> > >
> > > The nittiest
> > > of nits:     =============================================================
> >
> > Sigh :) OK will fix.
> >
> > >
> > >
> > > >
> > > >  Note that there is no guarantee that every flag and associated mnemonic will
> > > > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > > > index 8a9894aefbca..a420dcf9ffbb 100644
> > > > --- a/fs/proc/task_mmu.c
> > > > +++ b/fs/proc/task_mmu.c
> > > > @@ -1147,6 +1147,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> > > >  		[ilog2(VM_MAYSHARE)]	= "ms",
> > > >  		[ilog2(VM_GROWSDOWN)]	= "gd",
> > > >  		[ilog2(VM_PFNMAP)]	= "pf",
> > > > +		[ilog2(VM_MAYBE_GUARD)]	= "gu",
> > > >  		[ilog2(VM_LOCKED)]	= "lo",
> > > >  		[ilog2(VM_IO)]		= "io",
> > > >  		[ilog2(VM_SEQ_READ)]	= "sr",
> > > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > > index 6e5ca5287e21..2a5516bff75a 100644
> > > > --- a/include/linux/mm.h
> > > > +++ b/include/linux/mm.h
> > > > @@ -271,6 +271,8 @@ extern struct rw_semaphore nommu_region_sem;
> > > >  extern unsigned int kobjsize(const void *objp);
> > > >  #endif
> > > >
> > > > +#define VM_MAYBE_GUARD_BIT 11
> > > > +
> > > >  /*
> > > >   * vm_flags in vm_area_struct, see mm_types.h.
> > > >   * When changing, update also include/trace/events/mmflags.h
> > > > @@ -296,6 +298,7 @@ extern unsigned int kobjsize(const void *objp);
> > > >  #define VM_UFFD_MISSING	0
> > > >  #endif /* CONFIG_MMU */
> > > >  #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
> > > > +#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
> > >
> > > Don't we also need an adjustment on the rust side for this BIT()? Like we
> > > for f04aad36a07c ("mm/ksm: fix flag-dropping behavior in ksm_madvise").
> >
> > That's a bit unhelpful if rust can't cope with extremely basic assignments like
> > that and we just have to know to add helpers :/
> >
> > We do BIT() stuff for e.g. VM_HIGH_ARCH_n, VM_UFFD_MINOR_BIT,
> > VM_ALLOW_ANY_UNCACHED_BIT, VM_DROPPABLE_BIT and VM_SEALED_BIT too and no such
> > helpers there, So not sure if this is required?
> >
> > Alice - why is it these 'non-trivial' defines were fine but VM_MERGEABLE was
> > problematic? That seems strange.
> >
> > I see [0], so let me build rust here and see if it moans, if it moans I'll add
> > it.
> >
> > [0]:https://lore.kernel.org/oe-kbuild-all/CANiq72kOhRdGtQe2UVYmDLdbw6VNkiMtdFzkQizsfQV0gLY1Hg@mail.gmail.com/
>
> When you use #define to declare a constant whose right-hand-side
> contains a function-like macro such as BIT(), bindgen does not define a
> Rust version of that constant. However, VM_MAYBE_GUARD is not referenced
> in Rust anywhere, so that isn't a problem.
>
> It was a problem with VM_MERGEABLE because rust/kernel/mm/virt.rs
> references it.
>
> Note that it's only the combination of #define and function-like macro
> that triggers this condition. If the constant is defined using another
> mechanism such as enum {}, then bindgen will generate the constant no
> matter how complex the right-hand-side is. The problem is that bindgen
> can't tell whether a #define is just a constant or not.
>
> Alice

Thanks, I guess we can update as we go as rust needs. Or I can do a big update
as part of my VMA flag series respin?

