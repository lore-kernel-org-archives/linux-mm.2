Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A2B3CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49268E000A; Mon, 15 Sep 2025 09:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20528E0008; Mon, 15 Sep 2025 09:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8738E000A; Mon, 15 Sep 2025 09:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95FE28E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:54:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 47DDD16045F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:54:44 +0000 (UTC)
X-FDA: 83891630088.17.0111B55
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF39640009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:54:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ehLvQ+dw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CqFnhJkx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kaANthgi0qBJCKSJC/6Ry0eJOpJz+Mfa3cEe18dSodc=;
	b=gIG6lb8NQ1RMIWbgKz9nyPB7nh5GUAciH+iBtqsmzj2ErnZDsB47FevKYOLvQlAS/4x9bf
	U9N++sb51Qvknig1enLZDU0XOnJGYWt0bdSc4tIcAPpBVVXqU6bO2LX1UltfD8Wma1vhWv
	JcQZnBplU1MuXngFKbVr8JeCr+UeDOo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ehLvQ+dw;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=CqFnhJkx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf17.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757944481; a=rsa-sha256;
	cv=pass;
	b=U5Lj5JGhhKFXoAT3PGLX2cgoLDANh8wPstUDtp7QzNv6wAt/rf1zU/fe9mlf8NyyKxBu43
	WVL+52NM/Hmp7lbSJFxT3iabMKwyW/epouez9u/KG2fh1Ea95uc1GZ/ffzyh1mZPYme8g4
	OImMGnG+oemHQZe0HoTjnCYenzvefTk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDC9lU010634;
	Mon, 15 Sep 2025 13:54:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kaANthgi0qBJCKSJC/
	6Ry0eJOpJz+Mfa3cEe18dSodc=; b=ehLvQ+dwOBKKaRFYlhT7dGXYlvAOe1rN/L
	RyGtI1UcwfP4Rs8gg9cQF9Ek5XRXBuwh5LdGy/L5dhwLhayA3mbRhliFeDld+Hv2
	hf9OTmyzfK/dP/JcdNb4UPVjVKr8DP2zD10hbgZF1HTnT7oyNEDs85sMEIsOWdhY
	4fqxRTm++R2M3he0gYBrsDNF0QVN8+9B7fPeQ/vWmryKLThy8/KKazSdCtksuaFc
	iKL0v1MW9i60nwbkr+6i9fu8WS8aJHxVDB8Qaj/A1v+3nSoZ9QVzMpAXnISpxpHo
	qHKCsqRiOSEky8EDvOZWro/xHkcvqgX+FD0Tq3m13cUsEg/5Mm2g==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4950gbje1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 13:54:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDnc3t015433;
	Mon, 15 Sep 2025 13:54:33 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011003.outbound.protection.outlook.com [40.107.208.3])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b30aw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 13:54:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QT2Z6j1YyBZ4BM0OE31+ITAwwNrmG0DD5H1KziPd9vLppP1TH7uN+IbE6lroYL3UT/DwVK3Wf+6Vzkp2EJF/uG6HBHCnv/7g+t0hgGzFCdqurSRD9oyYF4hwq4ETmeDYqfD/6su8RUKyygMnHrS5Zv47BCiWLV+Mem4VUGU1J1ESUfCM1zf03Av2v6b0DU1r4q2PLaWxS3dkPd4eKdYCTItaZOUQXbaGUFAmGJANszn8HEoJ6St61XHw3LkDfOtkeJH6qp7u+RflnfBXpQYkmB8OwBQ6xyadcmBN7beXKKTWaWGtgHvCjwLrbowmBwMJOqPdlyZPAWHr4YywAYhgEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kaANthgi0qBJCKSJC/6Ry0eJOpJz+Mfa3cEe18dSodc=;
 b=Fs6K7UydKJRqruQEHTfavGpRcLjYb1WyHbVvSmP+wlum0zIwmqyh9x5yceV6SruKHUVGOFjENRBtE7YPDpk3l56y/Kcq8P5VLPPzJ9fUe2xnrtKQdESt+UgKLl+nA0efcCcXZEDMF0ixpkwfwrqza5NVWeTBrWJqioLZ8z/ZHCk0AvYgTysGMYb7tASe9ppEK1R3vuzzRPGNBnfsJOY2uXFGBP++TddeSKLU1CGpWe85iaoWskRdT4E/Z5uV/Z5VQ4LPSMSgQb8fklxpJSM8eyaLYPDDycYZC1TeHmJ5p3HEmyWOlQnnESNLyVxyhLBUDI7+M24e8bcvBshSYhuUDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kaANthgi0qBJCKSJC/6Ry0eJOpJz+Mfa3cEe18dSodc=;
 b=CqFnhJkxmvVJ8rsUjMfb3pWTofQecklKS2I+HwChVVoBRb9wMsFZVmYefANueE3kPEVBLn9KRZ6xGjWNRXjhWXiNN2QG6KG+9uDNv92XixkIbMJSscCIaiHRCWkhUnWCwCDjKdL3nam9bs0kwEK4Pq4LKAZjFffhj6du3BUckOA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CH3PR10MB6764.namprd10.prod.outlook.com (2603:10b6:610:144::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 13:54:30 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 13:54:30 +0000
Date: Mon, 15 Sep 2025 14:54:25 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
        baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH mm-new 2/3] mm: clean up and expose is_guard_pte_marker()
Message-ID: <a0133269-82dc-4249-bb78-202b44a4a25e@lucifer.local>
References: <20250914143547.27687-1-lance.yang@linux.dev>
 <20250914143547.27687-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250914143547.27687-3-lance.yang@linux.dev>
X-ClientProxiedBy: LO4P265CA0164.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CH3PR10MB6764:EE_
X-MS-Office365-Filtering-Correlation-Id: 6abe3f90-7391-436f-fdd3-08ddf45f649e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0JFuDfVnII+TPzhQ6fb3Ek4d20QDI7jJpx6cn+QryIOQJSI8tzUlcd6QyhW/?=
 =?us-ascii?Q?kah+67O0ubnhToLS/6MJLwBYgBZOb4+pct52lnTtJ2QQ1BVlSM7DICah5nKr?=
 =?us-ascii?Q?d53QKxvi41CgM9TxxxOeX0TTWCSNzR/ghv/m35vJQ0Hz/7anCO3jmmSpOTen?=
 =?us-ascii?Q?iTOPhaRYIdl4ICvZADiqIvPOXbSlef//8BrRRB5L9kMO4gUJ7fDEMKmeAYbq?=
 =?us-ascii?Q?xJlDXKzNL78Naysm6QBlIOM2DRfygJbegFQFwv/ucquiQ3/oOhjA8LPBQpl5?=
 =?us-ascii?Q?jWkw819pRxlFmAeQkPYgzIshp6dVqwufdQcIDjqNfZ3N+T1NH0hH89T/50P0?=
 =?us-ascii?Q?ycR+iXWOvtB86kHQJR6rJEmdsY0iBCfdP+nSWWuviavwTsFyJ4O2sMlZLDkl?=
 =?us-ascii?Q?Y7TSJDXsyWWLsaPe+KZE5gFlhJqWtHRIo0Tz1vQpeBA+DN+eQj6+BehZM+UX?=
 =?us-ascii?Q?14KuLQH/wCOYfDKuMc1EJHYY4UYoXIxj8TFQQoudPu4Odz0QXct2zn2YlOtD?=
 =?us-ascii?Q?6bi6GGWBI5JYGZupTCUii1kmh96uL7+hsX2dlbpISo2la43WGWxi4bGQPUUN?=
 =?us-ascii?Q?Bc1F7QeGRLdkTAV3QFfO4Gd6MAxaJbQwX1ZN0wI+Jyt/LhSH9V+zbzPIxAnj?=
 =?us-ascii?Q?vGjiU1pDqwZLp5TjxNuNRvq7ncn/osRfZPoXjnyDEH9c/U4pS68k7GFOLFYE?=
 =?us-ascii?Q?89HzwkFiywuLLKX7+/GinLxQ3YmcElqdgm7vUqMT3lSItDmsdRUyY9mf7zXr?=
 =?us-ascii?Q?wphDIiCdPtHHEQvmQC2GvZZ0ep9Zym7+V7IBBadCbaUqazJ/APduDpQU4K4A?=
 =?us-ascii?Q?36RxCOn3LvzW+S1+0KGDkXsKQkssPnpAbBP/gQZCEeJOSdBDLX9R2R3jTcaO?=
 =?us-ascii?Q?EypEpYdbEj5fVkEglpQ4tJUSeqTf6GIe5mYHjCe7MxJyoA/6kvgC1i8NbzuN?=
 =?us-ascii?Q?5dH70r4KDY/yxtISiAygf7JsTJ6EtTpb5+uuVsb7eNjOFHCX1ypgLOtEowJB?=
 =?us-ascii?Q?gHiV3dzfrOXIwh1RCnBvFppOPkUYE7eFq2v72tT3/RefW65SSJ920aj16xLI?=
 =?us-ascii?Q?CySTfOUtuaTaP4m//sJ/HuODeC2FDemDpAY8xsXYckb3w6lSMQ1TvmFh1g2K?=
 =?us-ascii?Q?2sN1M+fasq9D16GStzdSJPk9L6iSeoD341KI0gYwnMa3GqkURmg5is/i1mkY?=
 =?us-ascii?Q?mzXnRyyH/krcncG6hf6Z+gh7WoRVnm0sMCly9M3868e8h0ahjqv2QWdfcplC?=
 =?us-ascii?Q?D1PB9PVtd3OKqcF7RnJq4e+pE7yfPHwskpq1RYh1UWZLPBTK4WHOR2iFob9p?=
 =?us-ascii?Q?xIaCPrc2wB3nw5vCXwLh53Aazoz5Log+bfrDd0SuBK10gOng8KyEW0yT6L3i?=
 =?us-ascii?Q?0MIKGT2SDLKT7A+ySaoBiR2BIn0P7g0ox4I0WXfuhiTiWdd56P/LTAi4GSku?=
 =?us-ascii?Q?p8V4y2ELR4Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ohYUg2bn8GZ5a24xfQKmmWZ+6jGcAVTBscki96eSNJVQpuRZDbhpWXLCfvc5?=
 =?us-ascii?Q?UYTmyBckCUgrK3QFtHW8WgncVxSp0DcUPsyuHuwVWmf+6WGGTifcl4V2Y+KL?=
 =?us-ascii?Q?Cg5vb/nDAQlQGw/pkuYqG7Z0SM05bDWsUq5ZLjjSzrQn3JsasYOancu91c4w?=
 =?us-ascii?Q?tT4NIqgH/2mFVOnCPwhLwE+Nz7R4oEHJ8BG/Q/VqqHgogoCy1WyZDj9YF4px?=
 =?us-ascii?Q?Sy1VfLrf08/vaQnHohFrhuHLbyNb/GNUTX3Z1XHcyhq6lo2omKYVnxp/aGTc?=
 =?us-ascii?Q?E5EaFVhfhqz1f0WF3eGL/V+RQVKVjFtuP6E5h80qoqzLi+SaM7KDBh4O+ozt?=
 =?us-ascii?Q?+lZ5e207FHMMw0XOLLRpXZDvz9YUTdzzN9WPUGz28PF22A8SgWjcobd5v/ni?=
 =?us-ascii?Q?D5y2NukmfEkcvlkI5d5q9rrSlBSVhkeuTE7kBt38fmw7xY3aQET+GgyhPWDr?=
 =?us-ascii?Q?aa+XfY/JUgnVx1SlqdKIp2BWKCN+bAnzhRogNtxuWD6siREmNOVDEg4G5vv4?=
 =?us-ascii?Q?yghK7xTlVYVVa/9v+PaJPa9O9R/FA8kv87vHTP772FKa+gAEDqOYpGELeBNE?=
 =?us-ascii?Q?Q8c2rIBHA5nNb3VbBou7mpa++End4mWYxUdZLKV6Vt05ejuiZ4xZv0bow7Sz?=
 =?us-ascii?Q?D2vYJNSjgx/eO0c++A9depcHoae7HEDGrw49s1yvcSoD41frqMIiZ1z3C4aK?=
 =?us-ascii?Q?QDJvqY6WQOTyjrFQ2RAx46o5LXwngwA7Q4gA2YH7I3UEkAFG7ICAnEH++Gdy?=
 =?us-ascii?Q?JmmfVbeQi0s/omypmSQIdn7Sbm/vpV6aDHikowKj2YJBbHEevllizYOOEz1p?=
 =?us-ascii?Q?MnXT4aKkLdrK6WPmCuxlICZEJAOcHe0YSMK1wHlZdsmVghYIJcXPmr27N1lY?=
 =?us-ascii?Q?DcDX2nA11hIcRa3v95hHlrtSpB2IDqoOEBBSsHBZf7i/9FWK4F3CrtUAiD2h?=
 =?us-ascii?Q?6EVf/WKfpz01O8VBNrU4PA2BX5ORSsUTgYnosbo7JB4HSoLLIQ7v9s4HWOR9?=
 =?us-ascii?Q?d6lcXwThkdW3/4e2BUQUMf+XMYgxjOWbLCerT3ppBgSP9STS5UHZu9NWQ8GJ?=
 =?us-ascii?Q?w0csMSBa9vsPUuMWCyWOTQs1Ec39NIlQ1+eYfvDxX6O8WmUMEZXCFaNQD3rr?=
 =?us-ascii?Q?I//nb9TPw14cx85Ri5cdJ7eQ5nQwEyMsDztmxeRV4+Bwn+Csmhc0DtUJug66?=
 =?us-ascii?Q?TY35GeWrsfhT6YSPZcRDAxdzE4K1JWlocjJVaMGx2ZRoDCuAVuumuaQITb7V?=
 =?us-ascii?Q?8Mi19iUkWRfdqgmDlMGKlCU74ANOmmRiq15sDaQMX0QhK/ES6YsJDFEPYGmE?=
 =?us-ascii?Q?DbLaoR4CpddlXAedQLo94EWQaImt9EX9AILIlJmmMsMA3mdvMgfelRHtH14o?=
 =?us-ascii?Q?sKmqLPJ11pkANKrQGxYjBLVK4ddXc7OkRubtGeJT9m6Dxmk018iUXq4o3lvx?=
 =?us-ascii?Q?hmAPx878gBwuhWHCRM7pprZ1hfrd+plmdPEgwuuXOhCqpZOihIb7O6JRC+4Z?=
 =?us-ascii?Q?XT4NKcgp1jkuNX8aSXoZ23d5D0B5l22XqOg6phnweBM/V5rIagp6zQ7x7XkK?=
 =?us-ascii?Q?U+R77KVmwZVMhmIh4Qb8FTByueezBjCjnvQ59Gj/UqoIrZ8vca57/50r3g7j?=
 =?us-ascii?Q?Jw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sVsLh41uAHEr6GZfPNfj5w9uiuGk8gnOjy08rFIa1Pyv8s9yOBUTOEuPLcgu8h5PpgsQPoPjyG3CP4yrwaERUNcoWe+nn6NMGuCT/VD0t++mpn1E/rTtZDAPvjJj0InB0cz4OQHP0daReVQK0qXkcHF1LPqLq6DDb51coVsBXXG4ERPC7Q26UktGhH9EQxtYru++hRP31JRhs/nqTswwTy3VAFwiPH2LQYiHZs3b+bMexRiNMJHvSlQz9za1djD0mCJe2ZhZ0ACmbizf6C4iUcw4s6fq7aOeNqh3Q2mbFqmW8GQ+U7YgzB3nSoafB3krOY5ZRIvrTY09l0k0djFKcj77Mr1rThmK2pDvFHawm0i41sgV3qnOWK7c9lPJ+S0TjCM1rK/5aniYczbzVn3+XTi66A8PEj7+eUjTGTXFVkK8+nSfEHDv3FuZhuC6AgsKOGnXgIC23q3NDRM46xKkLb5SMtT1i1vPljLS4aDdPG6qPR3HrZttptx+sJqDqV3SKOoAcudSWD8LzSL1B4oL/B3jlhppsfQSfUPH2vwA564Aq7BGgXSjkcfxqhYGJVV52j33rFUPfOjKmgTgsYHjyDotZ4eBWrBF2NxgbvnG4hw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6abe3f90-7391-436f-fdd3-08ddf45f649e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:54:30.4312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XpY4YGvQJ/LA9TdZUEPHjdPQWxgM/LkEnSFL1EpDbFta6miZAqP8kk0pxFdMRJDQgnD/jLIC68FgiFHZz3f5cVipKrIIE/gVM3ff0h9uHnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6764
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150132
X-Proofpoint-GUID: aF43V91_baVotkv_wcVcsFZ01LE_5kmu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAyNyBTYWx0ZWRfX+pU+i4ZbRDpD
 zTdmZtEkWt7hvOEi4Tn2DgvnrwH1ZVfVFICnBbNuffZUIebJvCJUU+Tyzf2uuhkkX6zZfED8pRG
 xujPAXMDjiTHZsCXfEBm/Mq/2DPuo2qq3WVn5UghDP2cYz6DjAjfhdSE+HhfjMDH3uJy6wnCkDA
 NctrtjUv6fkz+A2fQHmzuA5AWagkGbJxsphpOmkZJhoAG6nL8KEEe0zHUzCY8PA9n9Ymm0Wknmx
 lMLxS9oz0xq4Ks205lhwgck+QIsKDF7QLyK9tMzGt/257rp+DNn2KnSDu8dcd2yQWvj9RuVumGA
 QBbcTQjZ3M0EmLZs7WAxSj3F7sOx4Edgc+R0ur+kt510vqBbFf8QwZ/MdlD6BTiOzVOpMnBVx9j
 mw+ZuWTXQzHAKNf+zh/FJ9l3to4u3g==
X-Authority-Analysis: v=2.4 cv=QIloRhLL c=1 sm=1 tr=0 ts=68c81a9a b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=GvQkQWPkAAAA:8 a=yPCof4ZbAAAA:8
 a=zOmnDA9TMDQ0jyjWjDoA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12084
X-Proofpoint-ORIG-GUID: aF43V91_baVotkv_wcVcsFZ01LE_5kmu
X-Rspamd-Queue-Id: BF39640009
X-Rspamd-Server: rspam05
X-Stat-Signature: qfrp4iywzbqfihjzcwm83umyxg59q8yi
X-Rspam-User: 
X-HE-Tag: 1757944480-546087
X-HE-Meta: U2FsdGVkX19eXRfFM+HKAlYQdDsi3VMq4U38W+loVGSZ/0DK3wWx2d6i3oRsIstpN74oGxQhx786nA4TwPDbOhfI7gwb9qH8saOk3tTV3ywphYVQfaH50n+AA43bruCGxEpRCI41nO4H68ak7uKXvj1nHUTLRvr356dkD+C8c1BafZfdYa0XyHIHfdzxmJndAxcJ4OV3y4n6hME+VobJofkL4A4s9rtFprKBtLcD2esdimeD4B/1fqQbyoga4H4qBQ1mf5DSxFfIJIrPbGibyjiuVbCPWmdq6nQNjI64UV23JEkCd7BNy5cn9WWaxXlDbfb1R79KAqBMwjrE8LmezrR44XqjpLmBAel24n5qWPQk0FBOp8CdwtYVpsYspyElpR/1RdPqHPrxBlD3C30NMuzudIdMZf5RgxMuKfJ84HWIXgxeyVOiP96CVOxa0IcrYxuOE2jgOABu7YzN85rV/Ldkw1/Vxs2/wXSATC/J8vq1YLG6uXV0nN63pOhgD9O+DR7cQlwIEsl33qRSTipeaWUu7H+w1jrVanWE7h+3ZNb2ashU5+AbpUG2WCKy4TuORSTog6g9999Runzf1aDaAfYrXzf7RnEWY3uDEKgxNaNutHM1WgYOpYZm1QrPJUINJ1kWTwuYq40XqlBNfUw17xuWQ+ekSjjYVsuGWeeo7bz3D3EVxEB0L9m900lr5m5GYxIOl5Ye3DIGPlG58w2t3S693oWLsU1io4GkqaFT1cH9aSaaa0+CSby+n7NfRFOYylg3H5iVIy3Az4o/kRASxa0mChqLy6tBPXpfAokWZBeMj+qW/deQelbewzdS73mrJ/N12FrBkkZ9pb4t8mNwPuGgf8TqDVhhDZqQ24Jg5kfhsdcOBXjc1K3gTO1a1GLdPv4IQdaopAI87yGYVKjRufZ0Fy/471yRynoh/0j1Mc+b5lScLQ0oj6P2cIO/qfdfQRQ0Zr/SsnYSlg+14gf
 v+LZ3KPC
 gS5RkCEAyhIQkkeHZtybyQx8EuGjn2pkWm9WmtQqZO53vF/OTTP00KYfe0EsbDuhq+1VnXzbzxGcqN1dAdptRDTapo0wSRMjIPr/LiTkCgIasFES18LeYrECmFMWfCwHzDr6chUCfdFxZ/Uy1r7mkh+EqsPW/BoYFvfZccbeQDSgTdtVAJ6UQ4hiWYZu0Hm6XESGqE/BLcDBE1f76M4LYcjbtNQ1ykBkJAbW4r0HCWB4lZwXcfjnjx4ttdEuLUSaltG/FQ+rTxG6kjwYz3cFxbSm7e0srjVTiniBezsI3Lqx6nzu6NjHqHnJQYo7klJNmZpy97XpvDsMgXQfdG/nvDRxV1rT0+MHwfheheGtYzK2x6hu0me8z2iXbUOdYS55yFVLE+G5ipaPV6Yn/o8iv8fCbjSP1ywSw6iNN8iUN4eCwzequ3abGa5aMhofF1fAqfP1uM1QcqqrC/IJsrPYIhSxjVYgO4IYqeFirJTZ5K0jQt7HcHZRrUDKF8VRBfFRwSUU4Oay9mRGYLT37OLv26Js5mY4dFsEJxbovg9lYukZggeE69plfhrmGQv7BjGz8If6ePxyLpeOMH6WAHjyvPkLsINpj/twvh599zefAFlWvtvlrA5F8nB4kwT4oPUsaS8331djV/VcarTTW3+Yea152skw3SGoXrsT+LOsD2c2K+aOvUKtqFMuytB9+VjYgHLd6/lX5Wb1utQNxqdybNljq7W/CMAWVjSRxkUH2bceBZKjZ5SxPPecIS8Ri4KUxePvKRgEnWIwdmRs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 14, 2025 at 10:35:46PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> is_guard_pte_marker() performs a redundant check because it calls both
> is_pte_marker() and is_guard_swp_entry(), both of which internally check
> for a PTE marker.
>
> is_guard_pte_marker()
>  |- is_pte_marker()
>  |   `- is_pte_marker_entry()  // First check
>  `- is_guard_swp_entry()
>      `- is_pte_marker_entry()  // Second, redundant check
>

I mean, it expands to:

is_swap_pte(pte) && is_pte_marker_entry(pte_to_swp_entry(pte)) &&
is_pte_marker_entry(pte_to_swp_entry(pte))

So I don't think it's really unreasonable to expect compiler magic here...

But you're right that I should have just used is_swap_pte() really, it's a bit
silly not to, so this is fine :)

> While a modern compiler could likely optimize this away, let's have clean
> code and not rely on it ;)

Please don't put smileys in commit messages :) as cute as they are, this is
going on the permanent kernel record and while we all love them, it's
probably not the best place to put them :P

>
> Also, make it available for hugepage collapsing code.

Nit but put a newline after this.

I think probably if I'm really really nitty I'd say that you should put
this bit first, as it's the primary motivation for the change, and put the
refactoring stuff after.

> Cc: Kairui Song <kasong@tencent.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

This seems fine to me, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/swapops.h | 6 ++++++
>  mm/madvise.c            | 6 ------
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 59c5889a4d54..7f5684fa043b 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -469,6 +469,12 @@ static inline int is_guard_swp_entry(swp_entry_t entry)
>  		(pte_marker_get(entry) & PTE_MARKER_GUARD);
>  }
>
> +static inline bool is_guard_pte_marker(pte_t ptent)
> +{
> +	return is_swap_pte(ptent) &&
> +	       is_guard_swp_entry(pte_to_swp_entry(ptent));
> +}
> +
>  /*
>   * This is a special version to check pte_none() just to cover the case when
>   * the pte is a pte marker.  It existed because in many cases the pte marker
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 35ed4ab0d7c5..bd46e6788fac 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -1069,12 +1069,6 @@ static bool is_valid_guard_vma(struct vm_area_struct *vma, bool allow_locked)
>  	return !(vma->vm_flags & disallowed);
>  }
>
> -static bool is_guard_pte_marker(pte_t ptent)
> -{
> -	return is_pte_marker(ptent) &&
> -		is_guard_swp_entry(pte_to_swp_entry(ptent));
> -}
> -
>  static int guard_install_pud_entry(pud_t *pud, unsigned long addr,
>  				   unsigned long next, struct mm_walk *walk)
>  {
> --
> 2.49.0
>

