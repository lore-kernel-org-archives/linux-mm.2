Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DB53E6B261
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 05:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456196B0005; Tue, 23 Dec 2025 00:14:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 403E06B0089; Tue, 23 Dec 2025 00:14:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2911C6B008A; Tue, 23 Dec 2025 00:14:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 14D246B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 00:14:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4BA9B9AA5
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:14:56 +0000 (UTC)
X-FDA: 84249571392.18.264362D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3F56A40003
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 05:14:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X1CGOQzK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V0KmDR+a;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766466893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZskPGepbhZubl9nYIiCm/re4tcLZFj5/HuMuAXGvN4=;
	b=U+ART5qCUUsV9lyyYC27Ql+4zABf+Hdhqf8nyRTK8fGSYDA6UbIWmzzrqgp+yQMzXMfeSU
	akMat4aKp/i/fl+U25OE+K/kpcgG3Ng/YVcEBW99Hotn5dLvPUbnVvRHQdTwQvRwH/f6XA
	h7WEkpivjmrQueFDzcX2HSpFQIlOKq0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766466893; a=rsa-sha256;
	cv=pass;
	b=d+EncCl403xhBYuuPTLZmOX1h/nATVd0H8fesV1eBq9t2v2E9M+f25gh8WownTS+QfsquJ
	IPP5mhzzZjEZ+J7mZorVKJW8lYHSgOZ5rFq6Z1PfISjv41PWFH6zqmYQLMUUz2Wv9TpGTJ
	BaYOWGxILYgPNbnfPn4IPncBTHMMfZ4=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=X1CGOQzK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=V0KmDR+a;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5BN4AVK63603259;
	Tue, 23 Dec 2025 05:14:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TZskPGepbhZubl9nYI
	iCm/re4tcLZFj5/HuMuAXGvN4=; b=X1CGOQzKmsiGCntZA6bXc/0zVnIHK2WlAU
	OFeVJj82lGU+3RwJql5VwkrZEoErdevdAYw10yZ7wHqb4Sw1M2XKUeZQPYREJxhR
	0ktNVm8e8/Wa07cLaLiM4w2JxGb5zgpdEdctf12BQazBnkNF62XLpMmJGdrWlBKA
	n45+Er2qKOy88sZfWmjbsu8lyciKJyxDESUM3Y3DD8JZ1ERLQ6te0O2vz6MrlVLz
	FdxN6q9MG8iVtX5JcYTBFYu2V4tNkTsFPQN1QkIEEA036L5boXEtCcH4XIy8yZdC
	tLdHki3jiC+m5AD/6CwKE6j2V6CvK9Ix/jkRSM2MywhbzSJsorDw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4b7ktcg159-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 05:14:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5BN3e3n2016556;
	Tue, 23 Dec 2025 05:14:18 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011021.outbound.protection.outlook.com [40.93.194.21])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4b5j8j2tam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Dec 2025 05:14:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BQWjzqlnsX3z8x4/UX+Fta8nteVWW/hxJJyGjt3IRbbYv2j0Y2sW6ShT69ZdNMrOw7OqhJ9iba+9arxJQmTucDVQJrUiyLEBC191m95NZkpRndqN2XImfKdBhAlEjCrLI1f8xf7L0nDIfZF9xO2MiiYbUmDTIwGuZlFYtHEe386FnP5aIeLvXVcYgAUgWrmLha4nKUJXPIzL775gsFF2bQbnBgfMGv1PaaNyMaqgRAe1UxmVFoMgbo3iO9D6ByryA5/jSysD7zj/Z1ydtOVBYZvl2UJOuWV0b7pmhchW682YlJ2v3DfovL49wZHG9k8voQ6ecaWMfGkrUTaodjgIfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TZskPGepbhZubl9nYIiCm/re4tcLZFj5/HuMuAXGvN4=;
 b=LuEh/g6qbBeDWkmNgu6QMjz765V+afIfYb4Be+4W0Q24cnJjiqOxRE5Hyl7r31XzJNZ3Z9ReWZt/JUbDaUTOyF4QpZIDSQJYBPEc5i0GMF75rqnvn6P0r5JfeT0C8BiAZbdmFOn+f98kpuii+y/FI7fmAYyL6RbqGYotEI+qTNOgmq+XeiZyTqVmi1OV6EFOwyYvaGx2+J5YbAbMCMQkv7PpNVZUmUwFC99tHYCbuVuMHZaLqb42uohH/UlYxz+iNES7ngYXGCbrbUS0A6HyG2hxDtVtIES1Q8jhbzm7JNNcF5/b5IQ2P5Nd6/XBVPaYI+kKriU3kfAvrPJViv1MFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TZskPGepbhZubl9nYIiCm/re4tcLZFj5/HuMuAXGvN4=;
 b=V0KmDR+acpLjpELqQYrLgkXQ2HoIoJHHl+h0DVpcsCGC0yf9Tmujdd4grBT89CmGIjd8Wz6KpOK1/S2Mx7ayQZrh7TdAZsbeEOPexKalbdYac+Yho7DWzw/OUTR48Jd6KMzZlfbbT49HuhvRDCeolHal3jNzp5Hsw2DMNHdcrbE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8640.namprd10.prod.outlook.com (2603:10b6:208:583::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.11; Tue, 23 Dec
 2025 05:14:13 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9434.009; Tue, 23 Dec 2025
 05:14:13 +0000
Date: Tue, 23 Dec 2025 14:14:00 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
        ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com,
        david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com,
        tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com,
        akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
        rientjes@google.com, duenwen@google.com, jthoughton@google.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
Message-ID: <aUolGHkJQwKi0A8A@hyeyoo>
References: <20251219183346.3627510-1-jiaqiyan@google.com>
 <20251219183346.3627510-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219183346.3627510-3-jiaqiyan@google.com>
X-ClientProxiedBy: SE2P216CA0032.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:116::9) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8640:EE_
X-MS-Office365-Filtering-Correlation-Id: 598a1302-adca-4397-b103-08de41e21c3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?2dAXx7AB4N0Zi/kJH9CrvWOCGsR9nJsGqr7PafT47NwL2supGD5Kud0f7Jpq?=
 =?us-ascii?Q?39pJjiq7+yIn8P0hxszheU+AtV4LXHDlLgJaBP+cNGphiAYr038CngArWk7w?=
 =?us-ascii?Q?nIli5wpj5jQ80auoU635Drhfs3QcLwNulI11K0JQNN3Esx3t3iO2Inz8mWxp?=
 =?us-ascii?Q?OA6s+1t963uiUjvUECqnIgQoYDBbwvvtDEvap/OlCMBW9+U6ScJfMquxrXgB?=
 =?us-ascii?Q?3Ax89Godska8nseUZoFvQRH3k2VBu5NvBpVC6YNO6m8O6t4hGIdTJN13sSl1?=
 =?us-ascii?Q?a0lFQXyNqFT2AiDHcP5suNcsui+qxNMSyzWUGG1XDs/SYEUt4AN28+r4laDq?=
 =?us-ascii?Q?BFFkVH+OQyEZiVFZXD5Pr9u0LtSoMiPlsF9PSImaapibxXedNDrqbO/MQzmB?=
 =?us-ascii?Q?9rUiXFlH4Q6cEjoiRKz0/HaoW7jfvMW0iCoJZjToQqI/YvlTdfmZybbIMwSU?=
 =?us-ascii?Q?0yH7Z+qKKCwuXPGwUEbr4huZIa5beYIUGw+bxrS/if/+6cumTFfSJg8GTLta?=
 =?us-ascii?Q?6e9AGsry6LtRzVgZIpPBw9TdGJjfoz5ULp8VNH1o1wSh60L9+NV8NxmDN45d?=
 =?us-ascii?Q?nZNUaMqzxE+0PesM2guUL6eueXZ6fhOjqVYEZA3z9zDYGaC3/rmdxOrf9NyY?=
 =?us-ascii?Q?bPpnZhdo0z3R6ar1Bmt0iZnuKNu5ZOO27lWiqqhtQvlOlOgqJUrt4mgFNrhU?=
 =?us-ascii?Q?wM2ZjDsb51GNk9VfUaFC1EefbnUo/LWiYCTcZvJ4rXNyjG5ocOat2TkpeCeS?=
 =?us-ascii?Q?IzaCXyq8Ho3yJ9zptgYVB9oDU/73TJVMMrhoBY2N7AZSq/8rwQ55HlUN8bUr?=
 =?us-ascii?Q?t4up92XeBxHgrFsn3cnoMQsyC3W36v+CO5n6837aaOx0SJIOKdCGr7yveERe?=
 =?us-ascii?Q?RC6ThSxawYdfWJgTlyZClgb4wFKjx3LdFkKhyBQRzXg8DnT4FADEaBP/OgdQ?=
 =?us-ascii?Q?4SJi38eEDq8J8Jk0YNSfWl+phs9skcXoq55yw9EF/14ntP187nqhNu/ajMO/?=
 =?us-ascii?Q?mGPtWibKh7fQDhhHbwXrUV43ZrM6DF0hC4G86yp4Zh4nt7JIk/P43W7DyldF?=
 =?us-ascii?Q?ZEjd6HreNUTfjVDujVZDjUtnD8jai+O+JiU8no1wh5kZxroeoOnydL2r/wmI?=
 =?us-ascii?Q?arG5JBFVbn+R0C+XvsPwlzAIEQYMFg1BcXAnCn1VQ0smGD5GzfmTYbw15dPQ?=
 =?us-ascii?Q?9jqXooS73ERZ+7u60oA/Z7Q17c14agkEDgI56ATMJ1jBagvHis4GhiiZYBEq?=
 =?us-ascii?Q?PdBMVFQdDm9CNmlVtTL9ejLPtBwwsstMw0fmJ/LyMl7xGWRG0YzjWtwEycnT?=
 =?us-ascii?Q?mxgkagJYD6WkdwIhQY54isWzbu8CzFu0q8FiO/NPrK7tkMVrSGdbfc+IdOEQ?=
 =?us-ascii?Q?HdGJbK0s7zk2cEvX2uSuwI5Jqf274N4Up9otEqdePTSwb2G3I8HagxX97pJK?=
 =?us-ascii?Q?TrTeT1naKWWoTBU2Houerw9EvtO3hw19RsCEeIXONwG1TllC5ULL8Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?YhPOhfPJRZ1Zah+wrXSztKnjSF6kbknDqK1Rp1c4fLhdQCX+edMUQ9F+heM7?=
 =?us-ascii?Q?GjDaxzsKvGFYBnaFumTEwl4queWseAlxwOPjIO4tEhzpXMQvrd9qE2th1t+j?=
 =?us-ascii?Q?WcFOADEH2OAzVs3CTn9i+oqGvJRijAqJYtuAteK0ChcouBgrxvUmY9RIIgi/?=
 =?us-ascii?Q?zFTDgt462MwCwSMMv5BM11QLbUnJ4tKMAdj/LVwsiTV0V/1Vq+DnRZ4bBBqS?=
 =?us-ascii?Q?QO8RZwcZCyKtklGU7JYCA7TJeoXZ8zrr75OXUv9P74ON3HNRgiKttGqUh/OU?=
 =?us-ascii?Q?EX0C6QGBEDKdpFGvg+oW8FqZrFJH/EiR/uWjdv/G+KxPCGk9716bisq+QNnT?=
 =?us-ascii?Q?bxKaP+khUCkJxkZCU1OXOE7gvZ3yoXiTRnP5zb4L8v/0XRthA04V477hwr0p?=
 =?us-ascii?Q?nv3VCteqtULtL2pI/Elnf73+wWozEonTgwwZyCZJhAZS9yHhYsCNsjRxPRCh?=
 =?us-ascii?Q?eq6XYAy/tE+gPrNJWTTrZx1NRsEzfnTH0ztz69c1mQd3nLCXaABMVTtSfaKS?=
 =?us-ascii?Q?AnmeDjiV/8SmPj6NsqM7XZvOhc8WDcpwivtg0snnoDgvfQcWUNOihH12BdNJ?=
 =?us-ascii?Q?4gKAyOMUlt8weg0Fdt25/aX9tM8Gb2CSH3D2vAYrBnjnCuXMV2QITmI3jpuZ?=
 =?us-ascii?Q?95BpPdF+imqoglLKfkQSrPME9GBUUfk0majbsagr3EbeeZGyUejm41yFP76A?=
 =?us-ascii?Q?qcSvrqR6oQe6x8wKF+gFO8joQGKGBv4z6Ty0xalM0LNFbF839O+PNn7OnSvY?=
 =?us-ascii?Q?43yMdn/dauco7nW9Q+KCNQLoqe/fDkbJa+i2zJ/PaYzusJ729BydtgAN1GQH?=
 =?us-ascii?Q?7qBDNg+FASMp6ZfNKB8/IDcmjOyfu6qZkMoy9VFzfVfRL/pyPWgxskuay9ib?=
 =?us-ascii?Q?Lb43+5AL0OVhAOtnMlFnkh+9BrVXCcRR7Rkw6mnJciyDwicE7KpACTNeJoWL?=
 =?us-ascii?Q?cn5Cte6Kff8jp9nmriaDBPT6uVqAVZH939jFHWKT9iqHN6aZHt47LW6smjaK?=
 =?us-ascii?Q?aO53MPIpppmouUxZwGA+W2t0BoPtzgaH1JXGFbv+HnNQeUAqhFlpYFY/KPiz?=
 =?us-ascii?Q?ABfZK0EyFTtaYDRaCxP8qJIPWxyiANHvTkPaTAMHZ2T/OeYfQyfAT8SwUHdC?=
 =?us-ascii?Q?pLcT/J4pjeJPoAZszA4biUeHiYWH2mfsmQ3Sgw/clvbjmGYWNznXMcAfPlA0?=
 =?us-ascii?Q?9CyhZpUakZILBmcF0+CQH8RY4f22EdKSJnV4ZyeRa8KXh2hhGGiXTXB6mVfR?=
 =?us-ascii?Q?WgrJxYWkLxSZV/wMBMV1x05bamiwaXF2nGTWhT9HWF3Ue2ymvpvP2PKUt556?=
 =?us-ascii?Q?ziYzh/u2HIkLshdu49hADj66icjtTiD7cxz6RfiL+NBhWRuJ+m8VAEYq4F1X?=
 =?us-ascii?Q?gBYyKv47ZqwehSPDIi6tVmrOqn3uGl/H0nfGuKKb1GFPpuT3GoZ6sINBAM9g?=
 =?us-ascii?Q?3wo9cQblvn/QE6eKfZWkPFT4ZqwKOXFxZvtNWjMf3LNlaexRRm6qhqwCKG8o?=
 =?us-ascii?Q?gF6wpPBuiqvC+eRYGioef9brmBEuEz9FKOATN2pPWD47xQGlXqfx6jcsdfES?=
 =?us-ascii?Q?VollbO9MuEJ3qzdDYyKbFMEH/J5eX4vBgVUgc6kzcJJu3ttPZdgEkalmr4SK?=
 =?us-ascii?Q?NNbt6nnOS6oBH1FHOJWeH24SWpvkKFU4Xc/ct6/K+hrfk9mjdjdtJvbbNsOl?=
 =?us-ascii?Q?l64f94qphV5MQ9hWVzkdLs3HV1h75dgeJfibA1E90ESI4iPenPPfwp9h7eH1?=
 =?us-ascii?Q?nPcpujPcjQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	x1MC7j8dlvkU26+/FUz70CkceWDm9sIYJcS+nninizH6kJnWjjAM6lSRI22s4y7K8N5Nkan/joPnP6ER57D55Jgc/njDQStRJ4H7/EidWK51gwfTdZ9Hf9NG+bgApKFpKKu4DLB0briu4hAiKqg/ZwP6jCEDi6Cet3N7/1AUeJ7wqLtNajbXXxe1P0tpQpg9kCLAk+q46SkjN/zW/fZuwq/xAaBxBP/+skYDTg20+qCIiWcsHeOoKHWXqT0GQW2vIyJI8SM+pENYchcgBOObN3edTaj9t1YSqRPGCnjOpTmEpFVeb+gRboNjlweqYKg+pEeTBpsc72W0/lY2S5kf11SHz7rpPfJarzZh1pilLeuAhZzH+w1UIOFfwDd8fZXHEwgtfXfSQMCieByvVLGhbchlA2WbtYMRjmlcMcryxN1Iwt2ExaRpH2PB9dmSUU6av0WBqAPFbvOwngM5t1XI2WhFB30qbDcm1EJhA6HnN0Zb58PtD8QC0BGhj0d7M300uvH++80FLFxf6j4Y1Ky72yy3LTCv23zo2L1luPD8NUy0aRU6lKGIOW5UAv0MtIeTpd5YDXmg5Eiuy0ikMiv/gBGJ2PdpbyoexA+KADPfHlk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 598a1302-adca-4397-b103-08de41e21c3b
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2025 05:14:13.0606
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AwMuR+QKcqCTOARvbxPCfhHRCSfwsdCorAXtg6Z+q6B1KBnONaHBnR4Ex8LWtZtB1kTVjgfLv3R0/V4UocbOhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8640
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-12-23_01,2025-12-22_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2512230042
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMjIzMDA0MSBTYWx0ZWRfXyKfnpHCUWaku
 S5HXeG89CtaSkTOF7csh/ZEmet1ayib8n2TBjVul7qY1okxfZO54sxWGNcf8SIsuxs2moxfwLdY
 wI69giHSe2rmtzEEXexQhqzVH7zkj1CKdC2I1Q7iRVxU7HwUxzQpP6fCT1F0WlURvPHRS1rVW2i
 Qa+ADqujY9JhomdPKWN9NqQwD5D6I8hapcL+I1cjkPMND8Do5yL/Ece5c/+Vqbm5guQo1N3iUSI
 8AI+abdjWN8Ut8GJKzeG2Yb4etxBs6CVkfhMMKRWGs7ypg2bQeU3yOrm+6Z8lZPhlNE5sAG+D5Q
 venP88KF0Y37sK+xLlYv1oqSEOAfIqdwzJ6PqSUxKcKXVc3Yjj4Ikmd8Vje0aWW3UCtEmG4alFZ
 fbR2YmPdeAvxEnKaNY849swKr8d9pSgbXwxHpr7nkWrjXrFq2bGjoTi84yCqcSPmoaGVauk9X6v
 6j0TZZdyhXlPwoHGV5RcZ3+Rl8XxpGFVoJueEgCs=
X-Proofpoint-GUID: vaCX-pC_fMtPfjNdHDLH2qNsgwEsARtj
X-Proofpoint-ORIG-GUID: vaCX-pC_fMtPfjNdHDLH2qNsgwEsARtj
X-Authority-Analysis: v=2.4 cv=ONQqHCaB c=1 sm=1 tr=0 ts=694a252b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=wP3pNCr1ah4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=R_Myd5XaAAAA:8 a=1XWaLZrsAAAA:8 a=Q5I-b3xSWx7GxrG_ZasA:9
 a=CjuIK1q_8ugA:10 a=L2g4Dz8VuBQ37YGmWQah:22 cc=ntf awl=host:12109
X-Stat-Signature: om55y7mnjyjjzbk3u85fn9cp17px1qd7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3F56A40003
X-Rspam-User: 
X-HE-Tag: 1766466893-371341
X-HE-Meta: U2FsdGVkX1+JBgaCC+7pCiBmojTTblIZz0bJRJ4BQYkDKWCLiyW2dDm9RoKZnQOzPVn9FDz23tvee7Yl7ctgpEPBWYnJmiMiY1FaFpGMLYAb1UuibiVab3nmJvYjGVGFnUEwfC8xHzh0Exq6dlzIwK/rhoM5v9kwDQ6iNqvF/rKRY2UllHQP4/vFvheRe8xJZJyNA+9N8FlRZ1tU2Xv56p34IuQlbKnTx0uZOTVZOx56+ASmwjguJaUK1CXmOIzo/bbAdaNiXVTxX+8+KKyjV2GWT7L0XKzlId8+RU+/EXsb0ZLAcMcY+P8K7X9+wze5B8tYpTBE3zxzsUOlECOKvQj7YHW2OrNeiD1oS/qUAOFGXYvxZciPMY9dg4riCK6/IHVi7FwjX3DEPh3r2bStipeAGqDp0woXsePAFutooOS8m1r9kHDpZhnKabNg5cp23dHA2yw9mpq9JPDJTCbo7WyW+C/UwzuzzzUDDOsKIOyGQJnB1r6wa6dEsrxUjKL69HmfqYmIW/yu06ZTWumN11oeOpzkbMb/cZMJtaPR+jqFRhujymLtXoH47lUMV1N+z6VtPfODG30vgoeCR+szd8yt/Wvq6JwSv/XSI+CQefv6GFWLNb3fUKaxEXOxPOBhAbcYLlOQvAGnQU0vNzEoVGqPQV3da+8l2nDup1nrFPH37rLWDZbTDM8nTBb/MMJQiPLdl5P4RxP4YNLcV+fJyrRz+AW9Bnfy0FiSnlqn8biaitPhSYbUMxLu4iIzW9K+P+nIhMxB6hbuRfHEUIjxK2IMlQ7vdGVi1+hQPP8eJ6AaFjSA+hbrQf1QoN7K4RL3S43yy5r502v3tU8uQ2vixdToFNK1N6UermOLIagCx0w3Oglack/h6Na6XXU/Sf2LVfw/Mum7P+uwdSFFpJeWkaYyDHp/zo+KlL1vADnjryNipvNxyby90/bu9Lw6A5Bx7E9E3YpVuUQRFN7pHab
 Xe0BPWuh
 +/NtE7i2xwNOdr67nLUlPa9mFJ7hAaVxEjp7YthlobHnl6JrdHQ/xEHwnBg2801T5VehRk4f1UomuqxcscA1mK9PAEnHn8Qurokt/KtZmze1ONawrE1YjboUna5vaLzBaeEwQqmpkFyMa8Jo/BH8P9BnhNUalTw3WzfoeJpTmAOWMm9O9cfjCir2HKKzfIksiXL3TFl/EH5jfY/6q0wgFMPEhmluaz71Q8YckTYEi2vhLu1jthmLV0amlKPDdFfd3/CqJYdSxctA6nZQk6lKme1oD7B1F+vpAGCeY1cwmpAfBhKwWIrIX79qf1+XHEA5YxUBKpBGz7tTBfIHbt3EPvpa30U6Z8EAX0PHCxq4OU5Tx31X//IarnNl4gZW44gm5WxFGMsqSgG7SC6vx+945Xanc11dexSbz3w0VLFwn3i6ZTBRfLsphCmqxEShlt/XXbIzS82WhnO3bSEl8iPUG6zsQ4g+nHhKLkBtJfNDsPxCt3PDJW5rqm9nQWNQHOJkCaKqNRo4gm4vYhJr+r9V4LT/+zoowJWb/lfVwhvqM4CfJIwToYHwyieJxYmaL4SDGWItsJLvLa4WhyCteFgG4FNM3SWk0orZcNmAhVY1hpTONFRGdhwKW9wWWtF0WBEdTQ8Vo/S8FuO7u4qPaqOVXp/hK94Ch8Y38q0rmGopXcfimyXlWwNHZ+EZQwxVjy0h4N43+MuIep5UzW34JOLbTsvaMFNqwcgzhGPmbhSZeK30bzoCFkmUn2cHiaix+PqRgB8+5kcqWtnnD/X1iBsoOtaQlpVi0W3Vw/ig5Xx4I3teOdJTBSqwJfyXoDbrshfd32+SOxMpvdb5MX3x7nvlFmXI6IxacyRtZPcjaBztvJpXaJPV0Ifwlkl5EQtMCm9QUOQne
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> folio becomes non-HugeTLB, it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
> 
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio. However, there is always a time
> window between dissolve_free_hugetlb_folio frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.
> 
> One obvious way to avoid this problem is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce free_has_hwpoison_pages to only free the healthy
> pages and excludes the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, decompose healthy ranges into the largest
> possible blocks. Each block meets the requirements to be freed
> to buddy allocator (__free_frozen_pages).
> 
> free_has_hwpoison_pages has linear time complexity O(N) wrt the
> number of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison defines the
> overall time complexity.

Hi Jiaqi, thanks for the patch!

Have you tried measuring the latency of free_has_hwpoison_pages() when
a few pages in a 1GB folio are hwpoisoned?

Just wanted to make sure we don't introduce a possible soft lockup...
Or am I worrying too much?

> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 101 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a9646..20c8862ce594e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
>  	}
>  }
>  
> +static void prepare_compound_page_to_free(struct page *new_head,
> +					  unsigned int order,
> +					  unsigned long flags)
> +{
> +	new_head->flags.f = flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> +	new_head->mapping = NULL;
> +	new_head->private = 0;
> +
> +	clear_compound_head(new_head);
> +	if (order)
> +		prep_compound_page(new_head, order);
> +}

Not sure why it's building compound pages, just to decompose them
when freeing via __free_frozen_pages()?

If you intended to reset compound head & tails, I think it's more
readable to decompose the whole compound page at once and not build
compound pages when freeing it?

> +/*
> + * Given a range of pages physically contiguous physical, efficiently
> + * free them in blocks that meet __free_frozen_pages's requirements.
> + */
> +static void free_contiguous_pages(struct page *curr, struct page *next,
> +				  unsigned long flags)
> +{
> +	unsigned int order;
> +	unsigned int align_order;
> +	unsigned int size_order;
> +	unsigned long pfn;
> +	unsigned long end_pfn = page_to_pfn(next);
> +	unsigned long remaining;
> +
> +	/*
> +	 * This decomposition algorithm at every iteration chooses the
> +	 * order to be the minimum of two constraints:
> +	 * - Alignment: the largest power-of-two that divides current pfn.
> +	 * - Size: the largest power-of-two that fits in the
> +	 *   current remaining number of pages.
> +	 */
> +	while (curr < next) {
> +		pfn = page_to_pfn(curr);
> +		remaining = end_pfn - pfn;
> +
> +		align_order = ffs(pfn) - 1;
> +		size_order = fls_long(remaining) - 1;
> +		order = min(align_order, size_order);
> +
> +		prepare_compound_page_to_free(curr, order, flags);
> +		__free_frozen_pages(curr, order, FPI_NONE);
> +		curr += (1UL << order);
> +	}
> +
> +	VM_WARN_ON(curr != next);
> +}
> +
> +/*
> + * Given a high-order compound page containing certain number of HWPoison
> + * pages, free only the healthy ones to buddy allocator.
> + *
> + * It calls __free_frozen_pages O(2^order) times and cause nontrivial
> + * overhead. So only use this when compound page really contains HWPoison.
> + *
> + * This implementation doesn't work in memdesc world.
> + */
> +static void free_has_hwpoison_pages(struct page *page, unsigned int order)
> +{
> +	struct page *curr = page;
> +	struct page *end = page + (1 << order);
> +	struct page *next;
> +	unsigned long flags = page->flags.f;
> +	unsigned long nr_pages;
> +	unsigned long total_freed = 0;
> +	unsigned long total_hwp = 0;
> +
> +	VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> +
> +	while (curr < end) {
> +		next = curr;
> +		nr_pages = 0;
> +
> +		while (next < end && !PageHWPoison(next)) {
> +			++next;
> +			++nr_pages;
> +		}
> +
> +		if (PageHWPoison(next))
> +			++total_hwp;
> +
> +		free_contiguous_pages(curr, next, flags);

page_owner, memory profiling (anything else?) will be confused
because it was allocated as a larger size, but we're freeing only
some portion of it.

Perhaps we need to run some portion of this code snippet
(from free_pages_prepare()), before freeing portions of it:

        page_cpupid_reset_last(page);
        page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
        reset_page_owner(page, order);
        page_table_check_free(page, order);
        pgalloc_tag_sub(page, 1 << order);

> +		total_freed += nr_pages;
> +		curr = PageHWPoison(next) ? next + 1 : next;
> +	}
> +
> +	pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp);
> +	pr_info("Freed %#lx pages from folio\n", total_freed);
> +}
> +
>  void free_frozen_pages(struct page *page, unsigned int order)
>  {
> +	struct folio *folio = page_folio(page);
> +
> +	if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) {
> +		folio_clear_has_hwpoisoned(folio);
> +		free_has_hwpoison_pages(page, order);
> +		return;
> +	}
> +

It feels like it's a bit random place to do has_hwpoisoned check.
Can we move this to free_pages_prepare() where we have some
sanity checks (and also order-0 hwpoison page handling)?

>  	__free_frozen_pages(page, order, FPI_NONE);
>  }
>  
> -- 
> 2.52.0.322.g1dd061c0dc-goog

-- 
Cheers,
Harry / Hyeonggon

