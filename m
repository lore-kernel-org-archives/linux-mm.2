Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51AA2CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 14:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A01206B0022; Thu, 21 Aug 2025 10:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D90F6B0024; Thu, 21 Aug 2025 10:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0216B0025; Thu, 21 Aug 2025 10:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73D866B0022
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:19:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24552C0455
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:19:39 +0000 (UTC)
X-FDA: 83800972878.01.B8F8E18
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf25.hostedemail.com (Postfix) with ESMTP id BDC63A0008
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:19:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MAy52KAP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hJIEEwWL;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755785975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wITmrnVhVIQy9Wm4RCRi5mjtxjBAtY7olrRoyPxKONo=;
	b=VXuOW4n/m9ShEDNYQr+xCnWbxHvCMC1UhTGDBKMdjVxgUpN754pFw8gvxJlJHFlGJFUJ7G
	ooz+5E5/Mn/HKTLnIG6+7EhNROTkRiuVOIVcjoX97wz2MBjF9acwTZIj6om7tInkHLsDmb
	756Ls15PPeLCGWKoDwzy1iMdIQEMBco=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MAy52KAP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=hJIEEwWL;
	spf=pass (imf25.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755785975; a=rsa-sha256;
	cv=pass;
	b=R11OG8fhZTJx+9iv0D/8hKGYAbjtnIxshTUiViFh07yyTnVbLPyccE43JdPg5g3l+0u7id
	+IvZLQWe8J4Xddtbu7wgJdf3fGhLtyA0aluS1bhy5gXyiwz+nVrwMBp0dInJ7cvfIFiZUD
	VDU1roYwrA4oUyylUkezez3LquRraaQ=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57LDQv39031278;
	Thu, 21 Aug 2025 14:18:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wITmrnVhVIQy9Wm4RC
	Ri5mjtxjBAtY7olrRoyPxKONo=; b=MAy52KAPV6DkXFLhj+rE6gcSYCgBn2F9Jr
	LhP8lOk+BSl1yLvi6GvD/CvoyGR0Q9fe/4l4z7RY+j4Db2JYMqKe/46sxEfXgrhk
	thZdK20KA3A2LYQTAkOXZHgPumOV0B0lm0MluG4ZJFTc80bIxWR2zGNDhNhYD6Mm
	zlEt+rR0WDIKRFV/j403x32ak79ysdXZfw4jNRHL/CVJ9WPoPg7NVjD6HFAGn1uB
	M+DW4VhpmBIgbwKt9VB3LaMx3MEe0rtv/sLONPP9lhcHQP0dNhQnhDDZvoCF7vkL
	diliLBcgfzlbBBgEWuz6wbFOdoDzKlbdrUWsp4IUPWDmiY9Viq0w==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0tqupxf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:18:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57LDeGZa039458;
	Thu, 21 Aug 2025 14:18:46 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12on2081.outbound.protection.outlook.com [40.107.244.81])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3s5dhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Aug 2025 14:18:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fuMHJhWJMCDo8EJirBU3vCMBgqDIinVq38r2oFR97CSxO08kOkP+1rc6MALPIWdogIQZAZClDMiWIfdUhenVFIN3X40Rha/RpxlZNThZmpuMF499wKkLxJukr0y71GvTPMLVkIwvnloVanmHVxRXUofCMhMQdMTd07YCkykhGDHtq8Qha2QO7lKvtthmKYRwsSd7hTyhTLjXxvC4SLTTLGX3k2YvntU3RFxWKFTjjAkkXqZ7NhvnVW+C/T5n+foItbkrDPxTf63pA649eU2a6YHjGWL1MS097vuQm0mqL2m/zCz2X0Cj+FfC9ouYoUbLKcnylHoB9BrdhD44acb4lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wITmrnVhVIQy9Wm4RCRi5mjtxjBAtY7olrRoyPxKONo=;
 b=hWLVGA3BJD+rWHEs38tgZm5g1pU6FbgHi8dANeCePNWX9XfdKBrTHl2ypXxi/QXEptNGPWy9wkirVJyn+5bJsbet9bUwNOBxoyK0E5PnVrUEMf8R8lWycb5umrJRUM5S/ToSX3qFEkh+6dig8wFn+JVGNPXLJGCr+6pQgflubSVnv8mR3Y5nj24PxrBFJCc2EtMQsirs3wAsZ9GgLl2iHbUfnhqGW6FOur0fb3KUWfdJ5OYtxfUU9fVYiWaMkHQjpC67lAdqxrRu1FgajKrcyz+KQH5hoM7wYDBWTButfZv5Z2sSkNURVqHgxLz0YMWsE26zpbUserf9AYX1KQPJxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wITmrnVhVIQy9Wm4RCRi5mjtxjBAtY7olrRoyPxKONo=;
 b=hJIEEwWLQ6MaStFH8kSj+uw8AqEs8OXtnkgW5prDi1etObAU9FrMGM9tcBuIG5Nen+nWCaQQPdLpWPpY1SvPt12Ssap45E/3SOHZs1vOaexfw6YfP/n4rmurCrhGgtrpao6e9xBpZp6sM7sBfoXqLdLESIfBxUvF/OhA/1RDU1A=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB6368.namprd10.prod.outlook.com (2603:10b6:806:258::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Thu, 21 Aug
 2025 14:18:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.024; Thu, 21 Aug 2025
 14:18:41 +0000
Date: Thu, 21 Aug 2025 15:18:37 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
        corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kirill.shutemov@linux.intel.com, aarcange@redhat.com,
        raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
        tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com,
        jack@suse.cz, cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
Subject: Re: [PATCH v10 10/13] khugepaged: kick khugepaged for enabling
 none-PMD-sized mTHPs
Message-ID: <d9a02ed5-0d6e-41e6-985d-23f5a2de093d@lucifer.local>
References: <20250819134205.622806-1-npache@redhat.com>
 <20250819134205.622806-11-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819134205.622806-11-npache@redhat.com>
X-ClientProxiedBy: MM0P280CA0012.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:a::31) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB6368:EE_
X-MS-Office365-Filtering-Correlation-Id: 1f6647df-7164-42fc-6274-08dde0bda123
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HxHNltsMnabDuSC6m3yNKUEkjbFXxZsbDLCH7g9AL07rynrVWk9JGfylYk8a?=
 =?us-ascii?Q?prIdchVO9rSMqBf1m3+0towZySFREhHb+yj4ihquFI+FnYiou7xKePpDuDG1?=
 =?us-ascii?Q?YrH3Am4JGxqM71Zq90/fa09ocN6Fm9dwyuCzt26/3gCsf1iQFH/N8oDc4j/+?=
 =?us-ascii?Q?+OEHD/N/Pq5CVHaWanGVMd/CdmXQsZGJb/I5qAMlt0YTeFL8utUDmgh19HU0?=
 =?us-ascii?Q?KQwUG1GkzMjm03uVlb9aQRSZH/Th6jyRBzX/hVAMOE9plsB9UjV31LKMZNCV?=
 =?us-ascii?Q?SGinc793lluECL4WgQTvOYwUdAeXyaUBy29HIsEXC7taq1KB6k6n+5inwARx?=
 =?us-ascii?Q?KG+4ml9ZfBPNgkLZHMue1MH2pFXcono2lB2QeKoMFJl1HhBgNuMYLotu7pOu?=
 =?us-ascii?Q?lZrtHCXUO0OneYPAdLMj9YtNoCcttLMD5n3ArBbyq9JDlKEUzSvfPaVPnnrM?=
 =?us-ascii?Q?E907WTGqW4f8sEGdChNMznaT+5asAkiqVkrvw0t4rZRhhfmUPOw8ycO/XUiw?=
 =?us-ascii?Q?iEHHwXH79Xv4r+KuZGfvABu+QMHzxFn2B+ZtmsCSRrCQhYnLw9lID09Cieq/?=
 =?us-ascii?Q?a+acEEF7PBaJWPgjJcURqw5gM5RAJCPZcEatZSIMMGC6oaCfftRS0xPa65DB?=
 =?us-ascii?Q?IIk5DmnQLh4uwNPeqavl8TWCD7+SanMuQwPwrRRAxEm1iLcSyydAYzyGlpQx?=
 =?us-ascii?Q?s31CtskH8kuqdokKzC0OF1AamoLwfZSvQ7FdjjgwZ85Pgt+O6ayNI0wo+L6n?=
 =?us-ascii?Q?4A1MF7KaYyyVu+FlQ0MPiuxBKw/eWFCIf6Pzfi7aY1I9kd+k4e5ChB1PzxK9?=
 =?us-ascii?Q?+e1zqye4qw5X1qM53lUueFU/gk93IzkZhfdfb2gErmTvwYyM5B3OkAxqdmIi?=
 =?us-ascii?Q?/iNQgwKIMoP9Zzqv8eD7mQnW2zYxKDat+wMD0rXeg894b8zrOVy7VB7ZnW4F?=
 =?us-ascii?Q?XF88Gbf8Xpswf0HyFAJ8fOrs89NexGTC52oTlTgfU8OXq86MMrAChRJsawlV?=
 =?us-ascii?Q?1Pdpmxh8rL2greOk7D/3RqEqXDjsob/suM0ZsOlHNkilF9kB4FgS8X9WcthQ?=
 =?us-ascii?Q?KHGNaXK1flATf2ZdLr3VF9k61HNmkXnjT/duDQoENMXzvrN4lv+QwAJotivM?=
 =?us-ascii?Q?+8pEBxCuxNPZ5lKngW12ZvqTiuYoXmqvHg68mB/G1RRBsIqfER/RyCxWs3zz?=
 =?us-ascii?Q?Zp+jrCnHu6AW6YhRN0dhDlwpSSEaI3Ofo7PaMgTACCXGernrudSrDBejBNEG?=
 =?us-ascii?Q?Rugh7YmtPnY7L8LSxeClxLJ4xntr73w4LckxqEU/bECmvLsZoMY10YeTI2G+?=
 =?us-ascii?Q?gE8TtTP2nqkkJE9o0dnIhzAYYBrhShXUIr/rkUYX+WeWHoFx5IqJWQh9Grab?=
 =?us-ascii?Q?1jIuaO/L3rcZTJhU/HXd0Pzq6GjTKQnfouqAF1X6Ue11ym+AMViR9C5vwbLl?=
 =?us-ascii?Q?Dwh3MZ3KvzU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AMW9Ukp/57mOX/U86vhJqAChBOz0HfrQrQ3khjdp6uEET4ruUyvAqAsj0V8u?=
 =?us-ascii?Q?GMZpsd8uLs6rbaojL2cjRWTe77dEUJMb9ElGRAeh3e22GcvhgsJbAoukPDy9?=
 =?us-ascii?Q?9662QNzpSPoZcTxwosUqV9HoeC0REuwphpSV8mZRCSlIfIb3nK5dxtNnHmsq?=
 =?us-ascii?Q?fe7JiY9cu2OSvftM/FF/aPI22LJGZS/gqL+I1bPunUk0llIwPoU6W5hkS8Fj?=
 =?us-ascii?Q?oN8xagDdHL2Po8lYBdTeRrVddcAb8LAq/PkpgUC1XI6bjyfB+jWq1Mj8+/av?=
 =?us-ascii?Q?4AxQr0H+DbA8fFUC8PGiuD6I75p+ad1NfUf5QMg8Yg90P/oVCSR8nl1vtirT?=
 =?us-ascii?Q?Q5nttIr0jgiwQLKyAS6cablQw4RvuEWtDcYNWTdgY2uHEpSHPQyM8qtlJXId?=
 =?us-ascii?Q?OkXhKxSNSUtRh10qw8ggjE84CfjLKmUuzn8jlxeZ2GZbqtKrsEwTeBTAC+ne?=
 =?us-ascii?Q?3T1lu/C2Aj8ZubppQ+XJbqHNac/iZBu/CkZkp34Gjgv9kAL3JmJv6xs5GY8+?=
 =?us-ascii?Q?ikhL6EkT+2KWA6j/V3tZt5viCTPDjr25ohmmto6tF0RqdHj1pF+qSXDEOAy7?=
 =?us-ascii?Q?OzX9E3JqhM9rfKXEEjgf/m3O4J+0v/eCKs+row9gmfNmENS2O93x+SMyJ0aC?=
 =?us-ascii?Q?YRLBVD6XaiMy5SrwhKSdcw223HbyYNsQLhEczfFPDPf3SDDbgJbjPKdSLpI6?=
 =?us-ascii?Q?9+ZuN27LSNfcuA3fOB7UKU++Uyxq37S8oEYieH/XoG5LXKRvk7KVZzd0c+9e?=
 =?us-ascii?Q?HaxiLkuA8R+BF8aY3vfVI94Z6C9E+73C8iw+3HB5UPqQJiDMz8rj6E/P1qgZ?=
 =?us-ascii?Q?VIMAUOK+dMT8Amv82mgTIXGoRhzxkGsgd/TYsulrOtcOl/1Uw0bkOb5XHVkS?=
 =?us-ascii?Q?JRbBY36dbQnv4HNTkdcFosEwctnt/BXgyxBRi6sn2AD56Kj2WPSFkAStn23G?=
 =?us-ascii?Q?FQQXKyKmqOcMkjvMajeoHp76Mm8BGf/HlXP8T4eqwmAWKPhV6C7DGJZFA28U?=
 =?us-ascii?Q?4/763wmw1qBtFiUeU4WAmY1sJsd9PLScwbQaoaFjsQKmxIbkUIp+M3jM4TNs?=
 =?us-ascii?Q?YZ7VL5LqGjE0b9E4Q6lM/TKd6rFgD3JxhPYQp9YUf00ZesfPcMH2cx2malJF?=
 =?us-ascii?Q?trS5aWpw5QJYhKi4phUH/rE4uxJMRGdVbo2OfbiVMm+joBGd1E3flLAVHli1?=
 =?us-ascii?Q?6i5AbOG11qAVWqYrTyaER0QP2bTaMyhrpt6opA8/Pf0RSmm1Erie+eDannVH?=
 =?us-ascii?Q?OoYBqL2c8S1UTxUGFi9ao5mkQGPhDkoEd8pE540qKuBz7SSX7ewpYDh8Yhtk?=
 =?us-ascii?Q?WTIXkRZ+K/GF0vXANwEwnU7IjyaARDiEOKYpg/ypMruu7pYd+OhpJ9KdZi7o?=
 =?us-ascii?Q?mUa5z02hy7ckO2fcyaGcHGnmrmIx+hKCvFZrvNTuB54mxrws8C+MfT+zmaNH?=
 =?us-ascii?Q?T9oAQ09y4FRbefgXnqSlgQYdx0JvvFQtxmYJQPr2NOFYfGssypFT8OAy7jWr?=
 =?us-ascii?Q?zabXoXZ+o2dRtjGrIdAOWsYhRvFopTBmwAvnp0RFMnD4yJYBmCuQu7hb76iM?=
 =?us-ascii?Q?LOg2u8HE+Ha1faN4YXApX8kAHRuowZ2Se0ewzWUT9ImXVVRyj9IiUAmTtK0n?=
 =?us-ascii?Q?jA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	JaBpE87bepTVvTkofOLr7zzd0D95aaB1qTXQPOgLUSB/T+ZmRciLJrIUEqMdmX9TdtVI1k039vPXoxGbLH2RSbXeGC31oP1iPDFFe8pxqmYPnXJkF0LxbB2hnndimUgkkIT2WhJuwZj7BLfHOfcxkPwvxFVBmxqp3s9yjX/QXdoFEl80HCLYwP0LMyt3wZ8sRFkpRoUt88QY5WxrT2D0tEP+LcfMIQrnkouQKSY6XW1NjHtTav1ZXyxV5LgWLO4UqB14EFNs0qeCKD5tHoIs3EHgY/zcky6cXAIlN1a1tCl/pPjiM4F7MmyI/rUHHlOlxOD2FADMaphQnND8y/7l7b6we+7ec8o3pC4iV8ijpxTIymdGEr2VVwP5b3CLufJlznGqscM9QkXMT9j0d3SljY47+00KJq49W1lm9Vgfl5vGdU8VlmOLkkYZUS12caSYBJ3BLd85vBKBZ12gLT4ut8kEcRlnpq9JNzSdxAbM5g/tXCSinh2igLBk49j3oEzFu0oZdzH8nH0H0SduVIXSnj+19qpkLeoJ4dYzPZrtQu137LCAUZhlR0STJQqneWJYE+VJIAhpGJnQXSp5h4iTH8gJwPEHJb5GvXIn5vI20HY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6647df-7164-42fc-6274-08dde0bda123
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2025 14:18:41.4213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lMIfcycAOt3KU0TiQNFB715Hzo4Mh+pP5AEHAtgWuRZ+oEfaVpM+oAanUBGw2ElUGXRNq+c4aLkPF1oERFp5bCnySzWREKHQpMBTpnHUZT8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6368
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-21_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508210116
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXx9fGLQ63o7ko
 DwVXEaaBIvtfz7MBrHl6367V8csBzOtR65MpiBlPq0cWyfpt6XJV7HzOQV/bdjO6UqCZ6Ctq5BS
 bChBbPiNLPSqedfTfVIETKy0Fl1wdPsH00ZfYtgh6eh+d4khydQfpNLq5+2JHbDVYgqEuVQfyoC
 qroGlz+8x548+clz5DBN56VLL1EzizjW9gIKLCkMW3N1sLsEilM7N+iMn8OzrQ1QRtqW+FhLmuB
 ZFm21lk9UWoJx30BCggw+PPqCav5JQYyW2C7Ph/b41Y6XhgwKGzPAvZufP2c021ezF1P6jEoRYc
 L3ESD6ipXD4d8zqJA6NMd/2RWJAlLpADl4HgB0CikUavblLj9NUEi3Y4x+lKM/CMKgYuFMBP9pC
 M3B+xAvFyI/E0tUOl0a5TLjlNm6doA==
X-Proofpoint-ORIG-GUID: qMncFPoCB0z6Sw8qO-FIORadMlTt5s_4
X-Proofpoint-GUID: qMncFPoCB0z6Sw8qO-FIORadMlTt5s_4
X-Authority-Analysis: v=2.4 cv=K/p73yWI c=1 sm=1 tr=0 ts=68a72ac7 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8
 a=Gvo8xAbTcxgIiMVzJmYA:9 a=CjuIK1q_8ugA:10
X-Rspamd-Queue-Id: BDC63A0008
X-Rspam-User: 
X-Stat-Signature: aqriemna311cmi6jseqc5mgquyo69zw3
X-Rspamd-Server: rspam09
X-HE-Tag: 1755785975-635330
X-HE-Meta: U2FsdGVkX1/F3Cwsj21Vtol+1aYOWt9P1msNwHkwsaGEzf+W4xp6d3/MeH1TOh7uzI3rPriI6P4Xp6ek1g2YhXAYvTDptevW+F1cUSzylSjkCWwnH0UR7gqdWeOXpFgUQVxCk3Fwj3E+2aXJw+6W12gqP4XJgErQGTGgrKKEduw9s0QXer3kPprB/9RIhionhaatV1i0wGcCvWcD0I/VNftrZ0IsJGVex7QIU6uW+zh06S6cyCR3sjsQLlt01YohIpQgU+5R7gIOGf4vfJPkpamsPTm7lxn6TX9eQJ2lCXI9KNOs+JrUFH26FSDBI3FYeqOpiD+af2rLZX4kaIo5yGW4W6bSTE8SX0ned63KIGrgcTRL9PEUzMfoiuxJuHziNLJ665bXEMl966rEh5yGcQAfTaSzma9rSWi1c3br2S6BrvCQf5ggE6THeJpJbja/EEEjSWxF8wi8Lhl8mViaK6vAj6PriMZRns/aNRywuYea+fJvK8TcYwF3N2EIHMvFfwngrq16ejwzR+drJTUruVNbppHhfZNBDgDyvKhRKm6dwYHgStxMyXD2jBZ5YSlEgPRr9QwiFnfv/9JPeThYD6iKKQwCF53GucLqGX+/JAtDqo7xnRC/ncIoYl812Gjpdn5Tc42XETv25p3rqOS8TL9xfiStooCJR2Q4L3B7iRZDVVeOBqRDfopDntpkrWrWBvJ0f4YHKXLpAouQmm5Ew38hiaGXxRdxa0dVq2JRIXzx5q/Bamfd8LSuw79u+PjYyjS02TpRei2FUya5MWoZAXzIQDpXeFtqqEkI9SrJHs0x9clR2k964GWTJV+h2EXt5JA9uXwiWac5D7A81RmZBCIN+ZOTU+iguyHSbBiBIXFjH5KfkT60t2zMfYbYZx/c4XGIC8uEF3d6AKZ9RVHoCeSdj2ObWcCac38iUIJwLjz3Np6506WG0B+YQXVnPPrND2TqcRnRTg6JWGIRAet
 kVQ9a84R
 ZDMX6NM5+i0G53sXXzeLgPQljH2bEYZB+mxZqR3HQxOk/HMRYiBDclcyOue1mCUUlt9lyTDV6os26qpzNIeugTYeA4u9cWKIdWS/jQAYEp+mVPFObNb6O4GWTEKTMTfEMSgLlyf7R+I0DqTigE80Nc8u6IJtmvY4zFnJeE91eWraPG+YZzCWn34y0KhvzuVcXJMiXFyJZ1AKdFlBe4CHR+/LhAWD7UtOGWfAcAX+ZCbgcjX3dOlBCXp0oJ13wRSZbq9wx2AWUPO6oXHeAwPKe1Y1VUcsvsDO1haqWava7hWyEug/fgNSRaDhNHxmV+qvu4/DbRsNhL36SRVQ+v7KC7QP3PL758fxYgSs405OsjlTf+z5UsQXsDtsq4UxmcfD+VHoE5r0UbNFlBOC/o7fmncBCjA5m0qpAyhEV3cqsK+6hB84EDCwjxXjXFM1uZLYpISUFAcIaBps5qPmyxaH4dKL8EH723PzUuaVmPGkYcDxn0tcBMHs5m/c5efULsoXnHuRtlIZgS9e9fu4HE4ZaG5L61yO1Y+dESb0RTNqiQ6cCIZFJWs2Cm/dmI9ktBBNpeZHqRJ95/ATqvj2mZdUu3I/+ktiCBhUTbCQ01GHspq15ystfGumhRebo6O/MNRqux6hm2O7aOuOPcXlvCBylelZwTRvnXn26ob0ZgROtY9oxLk9tWj8t6VxamhCueOv26YKi7wMRJ6p77UqZ+QozIxyU+5ORCurbmST1EmHD7pMmeGRidUSmybh1u7HKjqemYF0+wDmQ6AFL/sl01Ug5vLNTa5u2OLtIzlSdCLdoNJuQmQqW5sR9qlWiLn6kJIjMg5Qdl5b0XdQgZcQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 07:42:02AM -0600, Nico Pache wrote:
> From: Baolin Wang <baolin.wang@linux.alibaba.com>
>
> When only non-PMD-sized mTHP is enabled (such as only 64K mTHP enabled),

I don't think this example is very useful, probably just remove it.

Also 'non-PMD-sized mTHP' implies there is such a thing as PMD-sized mTP :)

> we should also allow kicking khugepaged to attempt scanning and collapsing

What is kicking? I think this should be rephrased to something like 'we should
also allow khugepaged to attempt scanning...'

> 64K mTHP. Modify hugepage_pmd_enabled() to support mTHP collapse, and

64K mTHP -> "of mTHP ranges". Put the 'Modify...' bit in a new paragraph to
be clear.

> while we are at it, rename it to make the function name more clear.

To make this clearer let me suggest:

	In order for khugepaged to operate when only mTHP sizes are
	specified in sysfs, we must modify the predicate function that
	determines whether it ought to run to do so.

	This function is currently called hugepage_pmd_enabled(), this
	patch renames it to hugepage_enabled() and updates the logic to
	check to determine whether any valid orders may exist which would
	justify khugepaged running.

>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

> ---
>  mm/khugepaged.c | 20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2cadd07341de..81d2ffd56ab9 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -430,7 +430,7 @@ static inline int collapse_test_exit_or_disable(struct mm_struct *mm)
>  		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
>  }
>
> -static bool hugepage_pmd_enabled(void)
> +static bool hugepage_enabled(void)
>  {
>  	/*
>  	 * We cover the anon, shmem and the file-backed case here; file-backed
> @@ -442,11 +442,11 @@ static bool hugepage_pmd_enabled(void)

The comment above this still references PMD-sized, please make sure to update
comments when you change the described behaviour, as it is now incorrect:

	/*
	 * We cover the anon, shmem and the file-backed case here; file-backed
	 * hugepages, when configured in, are determined by the global control.
	 * Anon pmd-sized hugepages are determined by the pmd-size control.
	 * Shmem pmd-sized hugepages are also determined by its pmd-size control,
	 * except when the global shmem_huge is set to SHMEM_HUGE_DENY.
	 */

Please correct this.

>  	if (IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) &&
>  	    hugepage_global_enabled())
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_always))
> +	if (READ_ONCE(huge_anon_orders_always))
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_madvise))
> +	if (READ_ONCE(huge_anon_orders_madvise))
>  		return true;
> -	if (test_bit(PMD_ORDER, &huge_anon_orders_inherit) &&
> +	if (READ_ONCE(huge_anon_orders_inherit) &&
>  	    hugepage_global_enabled())

I guess READ_ONCE() is probably sufficient here as memory ordering isn't
important here, right?

>  		return true;
>  	if (IS_ENABLED(CONFIG_SHMEM) && shmem_hpage_pmd_enabled())
> @@ -490,7 +490,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>  			  vm_flags_t vm_flags)
>  {
>  	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
> -	    hugepage_pmd_enabled()) {
> +	    hugepage_enabled()) {
>  		unsigned long orders = vma_is_anonymous(vma) ?
>  					THP_ORDERS_ALL_ANON : BIT(PMD_ORDER);
>
> @@ -2762,7 +2762,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>
>  static int khugepaged_has_work(void)
>  {
> -	return !list_empty(&khugepaged_scan.mm_head) && hugepage_pmd_enabled();
> +	return !list_empty(&khugepaged_scan.mm_head) && hugepage_enabled();
>  }
>
>  static int khugepaged_wait_event(void)
> @@ -2835,7 +2835,7 @@ static void khugepaged_wait_work(void)
>  		return;
>  	}
>
> -	if (hugepage_pmd_enabled())
> +	if (hugepage_enabled())
>  		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
>  }
>
> @@ -2866,7 +2866,7 @@ static void set_recommended_min_free_kbytes(void)
>  	int nr_zones = 0;
>  	unsigned long recommended_min;
>
> -	if (!hugepage_pmd_enabled()) {
> +	if (!hugepage_enabled()) {
>  		calculate_min_free_kbytes();
>  		goto update_wmarks;
>  	}
> @@ -2916,7 +2916,7 @@ int start_stop_khugepaged(void)
>  	int err = 0;
>
>  	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled()) {
> +	if (hugepage_enabled()) {
>  		if (!khugepaged_thread)
>  			khugepaged_thread = kthread_run(khugepaged, NULL,
>  							"khugepaged");
> @@ -2942,7 +2942,7 @@ int start_stop_khugepaged(void)
>  void khugepaged_min_free_kbytes_update(void)
>  {
>  	mutex_lock(&khugepaged_mutex);
> -	if (hugepage_pmd_enabled() && khugepaged_thread)
> +	if (hugepage_enabled() && khugepaged_thread)
>  		set_recommended_min_free_kbytes();
>  	mutex_unlock(&khugepaged_mutex);
>  }
> --
> 2.50.1
>

