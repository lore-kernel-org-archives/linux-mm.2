Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94777D2FED2
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 18:31:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D226B0088; Tue, 27 Jan 2026 13:31:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0AA66B0089; Tue, 27 Jan 2026 13:31:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D926B008A; Tue, 27 Jan 2026 13:31:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2C676B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 13:31:15 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C44156FB8
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:31:15 +0000 (UTC)
X-FDA: 84378586110.04.DE87BBC
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id C553B40008
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 18:31:11 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zq4xDYE2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bzn7YJpv;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769538672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2/8dm5W9FrtsuLbIC5/UKPy4boFvXMPqDEXBuUp24PI=;
	b=V6TOx3gEZKactTtn37UOd9jsvgGuHAMCJk6hM4DRV7glc5eJmXEpYHsfaDlSEdE0KTZo8s
	8+5tV0vfcw6ZGerLDkBTrHAvd7bVV5PFFL73BCkUahRWd45XAKsFr+q6FSSv9frNAMjgTD
	ytTsljZc+pRgjhyIUJqVv2FjIuLDCg8=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Zq4xDYE2;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=bzn7YJpv;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769538672; a=rsa-sha256;
	cv=pass;
	b=o7lhP/PpgQ1BEA9o1lCGK/Odi+kwkai2DEECbG4evrhQyYbMxzX2ha8v+EUzZf2vQpStzo
	iAjTbzq8SQkgImin8NkEZ06IabXN7n6C3GekIVztgsqBEy3EBFNbwsKGHJxnUJ8/vr8Neh
	JATXVlcLU9XL7PT1xQ6s4GQ6xvoUrig=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60RBIHK73545592;
	Tue, 27 Jan 2026 18:31:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=2/8dm5W9FrtsuLbIC5
	/UKPy4boFvXMPqDEXBuUp24PI=; b=Zq4xDYE2F8WWqSO+ej+fx/H1xFczGmrpKt
	tx8mKuqHo4JU9RMuuMQkyahwoyoHmJVHAOtNiWmsx4oiJJqrq9Afi3Eb3pPUvR3q
	QVEAzuVpZTZnhIHpAXqK/eL/hlHbu0KY184f/BrUge0Qr9jVWqc4C3h3fDIUzads
	6IUsjnL2wzH4e48qvZZEhZpSUfqeS7mQtprUUBbsnU6J0OSuAhYm1WEY0FlFmZMy
	X1zuX2vTE5ONNsRBJogsDsppeXRw7Ug9Cb4sXe4VwEWpl0slzWfHp7QsHS0GSd8j
	yO7AiRHEfMRTIJjiYvLdrvG6LTAbZFd+3xl/RdXaodIg8Wd/+gqA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09mkub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 18:31:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60RI2gKo036020;
	Tue, 27 Jan 2026 18:30:59 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010010.outbound.protection.outlook.com [40.93.198.10])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhp393c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 18:30:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JuTLExDZPzw53oqNZUrFzskGmDdJxT7SGCNWOcB6Ok26v1U+d2iUbbpOjVRV4uNfQAjuXcpqZlzpyGJSikh0voz2gl1NcUM2ud1AHr03CDJUIsKc0Bop+LQXbbjH13337GHExJHOgNeeYCpotwQMPz/8I3LEjxOCUJmndG0E/rhmi8lDcp0qsJOXFHYa7ETMzjaMDZhdwwhLGqFMlhanBCl6K2ADWc2qnRb176zA6QLDlm/K4hwv6H9pKKgMZXSBteHoGtPA4JMI1EUzWjEKr4QledZdbP7ZyYWH8IfGZBeOYw5Y8cqfSXKGW5+z9Ly91i51nUBd0b8wR6gPwyWvlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2/8dm5W9FrtsuLbIC5/UKPy4boFvXMPqDEXBuUp24PI=;
 b=ih6zZu1oH/Fe5Ba1gF2SA/6oRF6LD9OD3wPGyathfSLjfOsC4UwyOCY5GcHIwh+phv5SIGcmcNtenT+zjDWeiykPxFZMsiRB7Ak+iA7253NemnUglk2GL169pEzjMO572dVrEAU/fq66ltuavC+RSEb17ZiimqEz30MztIqcV8VTkPzhpwQ9lJRPaXPPisA31jqxgyEFhvDZpn0Mknp0jVMTKBty4ISuKryu4ZhhjufT5iuW6wVLgnuflIJ82IyqDBDMepQy39t4G2wOCrk/BB1dckpgl/pO2J/gKRHwry9MMU0UF13nyfEbjFdDXacmRMsZg6VMsAsOOUQhJeLiPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2/8dm5W9FrtsuLbIC5/UKPy4boFvXMPqDEXBuUp24PI=;
 b=bzn7YJpvBbDq2ucUJk9GevYBQ1YFdiCl5uoFWqYU0H8wa60p2bGQWqc5nCicvk7UfeT6eXksbZPv+sGvm00IGpTn5/NwnMZ+V2RTIZHMg9vMWvpsCZlpRVVeOAJPsOedVTKJFMvkH4l/OxqWmo4PoLof8gTOUB32U0A9JiJHk+w=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CH4PR10MB8172.namprd10.prod.outlook.com (2603:10b6:610:239::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Tue, 27 Jan
 2026 18:30:56 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.015; Tue, 27 Jan 2026
 18:30:56 +0000
Date: Tue, 27 Jan 2026 13:30:52 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
        bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v4 09/22] slab: handle kmalloc sheaves bootstrap
Message-ID: <tm7yjp4phbf24quv5vdjw3juhusvzk7dyassrtrejqyhbieie7@ml5okfvozh6j>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-9-041323d506f7@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-9-041323d506f7@suse.cz>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0234.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::6) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CH4PR10MB8172:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a06c56b-8148-48f9-12d6-08de5dd235c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OJufz3IDmjNYb3PGA3P7OaHMlfEDST+/7o9qIOBjYjl9cVnBvxntD6c3xD6T?=
 =?us-ascii?Q?rZ9+PH9yCfCxOnb5mhTdz4W44W/d8WZeopQuVBpPjIGlSM1Mbdm69HCF6d9d?=
 =?us-ascii?Q?iwPdiA7aGCgJNR+3v44TVrM4aKV+Z0CAiyBJNVT58aetRU6W5wCn2yJJ1THp?=
 =?us-ascii?Q?6wVDoqD8ratArKP6ZnYhhgxHkbqD70IcgJQRTcD2SiFZQPTDREVjZobJIvdm?=
 =?us-ascii?Q?4KmCaOarnHrPAx06ko7zAUeAfrhLd6oMGtI++icO8SaF5yFpnE+t6fnRljPB?=
 =?us-ascii?Q?zAPpxMZqSk7JKnRAyhAdmXbjxJUQE6BtFkz/KoM/C8wjqqdovnVgJZReQUxl?=
 =?us-ascii?Q?nT3NlsOxyLjjItrK8MBEDjfR/nCnO1m/j1epf8tVrAKQ0b3Q5DxtQXJ4YvSV?=
 =?us-ascii?Q?0czXTbZoJDY6G9RtwkJ8Zrkn7Q8lFtNm8X/2Hpkh161IpoZ6RMloGfrfPzvP?=
 =?us-ascii?Q?IfIFGcJl2z9fLfFnAFnysqB0kF7sMQCJXLQIJF2Mxjw5rsquZwdkm75bClhn?=
 =?us-ascii?Q?cTHhmDYxaL1bVpBX3BPWu0GAiDsORrgnjrap/UGRzK77mWZFQZc0hEwAqLfw?=
 =?us-ascii?Q?0juB/U+zo81vgpueauSDoqyRPXXe/q/ws6t5UZPSyMrX2QgLRcQzT3UmrU9M?=
 =?us-ascii?Q?XO7PPkXVPV7U5ckGmmQVzBVz67QPfE6n0hlA5SGX77nROjykl86mcgf1+LLq?=
 =?us-ascii?Q?pSV0IU95GkiVNogTj+zhRsd/DwKYbaKDiOfyCp3nIZhJn5H1Ihif4sihxv8B?=
 =?us-ascii?Q?eM82jLpZXKvE8OcDoidt8mmTyGuNHJduwePzdlHPMK/wgmbg9L1JdSGPkL4+?=
 =?us-ascii?Q?pTXAmYnxrBdGeoUpUnrrpiCF1QtCHgztPECT2tdNpIxSzHOpKU/ZqZwndteq?=
 =?us-ascii?Q?ESQLLeCihpfhZxQmdOHaavoENxeUk6osZL9+GnQQtQDT8EMxrJ10fuGXrH1v?=
 =?us-ascii?Q?XMxXd+Xr8Wn4a1tw3oi/MoxsAmtZZkwPhsjxlKOiUMHuP0ihzqVm/Du1da94?=
 =?us-ascii?Q?Wj7MjyFyOAmsAc3Ee0/L3bmlv8iWfnHAFHd9VT6VRnuk5KWNKKvGDV5+8sIp?=
 =?us-ascii?Q?qQsBlnN4RfW+UjBUHo4+dquTy5XouE+rDAhB1ID9KvB6CW+M+79U6dUwd0ty?=
 =?us-ascii?Q?eHMWeKT9KHB3ZzKG9AAV8mxcRALiofBUNQ+wtVrU6GFpAoZELDRd9ZnB6Qf3?=
 =?us-ascii?Q?cnZ84aYGKGVNr+cPLX8xY4le2pZo66JAQZ25u3HD48dC4+KF4/UNS7pl5w2h?=
 =?us-ascii?Q?arO4HLJ3qJCZKYdEW65DIA+NHawjqQwePrNOKcA/6k+aCrVbiv1ExZcWxz0X?=
 =?us-ascii?Q?VnIl9edu6l06t2mlk1oSTWW46AiiPd5s2UrmsVyEBur+klynDV14v2BYw9jZ?=
 =?us-ascii?Q?TwI2R/8zo0lQfOKPGqfNLJREoEGT8oZ9KkV2hMJIp5uX5UEDu+hPS1fUkmSQ?=
 =?us-ascii?Q?r0Sk8OgMOHaBLGBSyzPHIbzNCcsRTrHewj4ZXE0TG2mBSV2Y2lUJ0wnZktB6?=
 =?us-ascii?Q?XqukILvRc73AX+VoQuBmiXinRqem6jqFn0Gyi6gd7EPOMRZItEahY2/4ILCk?=
 =?us-ascii?Q?GaRcaGceN9oS8JaBMWw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Uz+5Ktj9Xo/3+VuDG3T+4QndCCrbnfsvwh0tgpXBqil2aU38KdcZKEwJ5/tD?=
 =?us-ascii?Q?JHqG7DgMGx/t8tFnBWSEH2uDiYGB8sU+1HKZEmm26tIvA4MJhOz+bK/UrGsC?=
 =?us-ascii?Q?WMxn4sF4hi0FDJ0ZPu3WcBGtXjw49W1Ix/jEDTZomATEAONxDElY/QANq6bB?=
 =?us-ascii?Q?45IUQBMt0FFbZ9l3mr8+pylW85NGoxqbFLfnldrc3l0X2BS3TpCf3Sgfpx50?=
 =?us-ascii?Q?kpP1+Hrj6TUqvnBOfWG4AFpg1AOdma0tn+vK1bjWsPQNX1hN2rJT8GnqBM+R?=
 =?us-ascii?Q?1gPrzQlGICeaNZlLaGT5oaAfotFVAlG6ny0xUeLZ/D/qK67o21riXWGA/RLe?=
 =?us-ascii?Q?Ywi8+WKgJeKxfhm1tbvZzGCBciRvC4b6YvH9zFfh9ouz6a0fsbA3wpOGbdT0?=
 =?us-ascii?Q?E/rj38DlQbf8AU3yauh/xeoid7kwrQkOJA/AsW5J4D2SexdksfogX30UEB5k?=
 =?us-ascii?Q?mHngnvhGiVRA/dPQ1FKcMqkd9rx2Pd8EjmdfBbf2S+rVZmQ5jMA5YzNKxutM?=
 =?us-ascii?Q?cbZzH4V+HxKSQmbUyrE0YSmS1e3iZZ+rpUWgUOOwXbYqONJ4C5JcpjRnyRyv?=
 =?us-ascii?Q?I56KsYQ+HF9wWXCU4353gIKS56FV2IknraBxskZTYovrj+3KK708RqhJPZfm?=
 =?us-ascii?Q?Gnci2+yMM2OLkLJuWUqF+XEtjCIPRhOiXgpQyZ8W6iJIqklR+iZgHBq2c/qf?=
 =?us-ascii?Q?+GgbQNj1cEx/UaP6R6W6fz/MjdGw98HS/nM4NsX/jcKQ4YJvkWCIOPUyO3Qc?=
 =?us-ascii?Q?IGtE4f4M7/GZMTt6BdzuN3JqQaBHjw2wE2JGwl6oOqZIRPk0vxlgBvdr+qYr?=
 =?us-ascii?Q?b0U9h3cSlkSpm2woYWSERJxdIYR6+m2NNmBXSjihScpvMCv9Nh6zHtWmjZy/?=
 =?us-ascii?Q?aUo1HQLpg6L8JoDNTyVuslsMM5KFV4QXn20FmsGA1jhwv/xBwGK9dUu+GZL3?=
 =?us-ascii?Q?EpcUEmUAG3TpswNYR7w9Ur04irGl6aEVbhLPQ/khgcE90s61oLXsSdzHCyL/?=
 =?us-ascii?Q?wm1qrEtBdXWu51/u4c6PDSARqrAbscWY/xua2RWV89n+kMZEaCJFaZ8mJ0T4?=
 =?us-ascii?Q?CcyNo/q1s0gn3O8MVj+ehuB/A/TE2y4+LsZfRfBbTKhwhT1oc2cjPkc+l9ZF?=
 =?us-ascii?Q?XDP958RyS8fMAEMYHRxu0ykXj+jO7HopXB8iVK+j0MpNa7jRez/VE0IU6lgv?=
 =?us-ascii?Q?+8x5aXBRdSi2oIq0LevEu4E+4gf/uLUKrE4qxXxtOUHTx5VTJIA2cEOzgB+4?=
 =?us-ascii?Q?gA/dEsdxAdOqEhD9/98M+8DwBa9xp8l1swYp5uRAhE8OAOnvAKZzRr3RH09R?=
 =?us-ascii?Q?0XEbWP6hW/RLcDOSVurw1nHTDHW2QwjbrKvweqjHM4/yo353etkffwyI1vZ0?=
 =?us-ascii?Q?p4fNtTO/pQoc3d7LRXYra02w0LROSibseverdbEYX3RzNziVknjw4y3+sfSl?=
 =?us-ascii?Q?oM3vMsSXx743hfldIAn2HzlC0ThO/XtxCi8gfdaqxRmIr/LsQcC15+v+6zWS?=
 =?us-ascii?Q?/7S3FhEiPv3cJeBhvLbWQo6zyoBqd5hTmW8BSTb9y9CKgYU6t97oRpC4CQkB?=
 =?us-ascii?Q?hl97QTqFKp/1o/rjv686OXyVOf8Rg0NxM1yPrWrquacJQmFtM3gU5LZBBqIx?=
 =?us-ascii?Q?V/UiEunmkRMan/jkILMd5CsDOcHVsTqMxCTVqeWGrAemFfGzb0/AF0lPhg85?=
 =?us-ascii?Q?/cgyKEpVKPShxgPaCwrqO2xEtbANxvqrQt7nSysEjdyxIgNiXJa0whd9gXJ+?=
 =?us-ascii?Q?Gfuah6aiLw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Xb8sLvUSPiN8HFMk/Y7Wq7SrA+hp3WEHvs/TZF79xJscqJZtAGDkgnysbDmNf41CWTU+2Oj4rUcQSHKXF3DKmw9JMjEoZVGu3TDzZS16uV2JzwoiOnt9oazD1SDkdVSOfdTpAzU7wOGnJRdtyNojEpti75xZeN0AwB8YxAoiqQsu4VJ/tIwiXU0iJjbHb2RdzJo29o2CQVrXUY+J+HxJYWncSyl8iyl3vKh6jpUTKyZPZQ9kjhi9XZ2PmT7apZKF9WbQuI1CS7PWGyL42eFeNANqWuGYEHN+8wvqI1Ampd6CU5uNM+Uu+o/mu5EyV+NXHZT9BO8BZkmY7Pt53+sS56e8GmYfAgtfjW1kcOoDWzhtxDIcXPdsu7DTcgW9C30B9fVuGr+NUvRzbKq4aXfTYuG3IifCRcSSOvgEoBQ5l5x4X14/K2JwKYDfn93HxLra0J+FsewBXb/B0gIXJl7uqikgYhestz6cKAZvR6W6Gp6MoY8ovkvt+gJqNFlLkLjvju4o4zkYGha6co9XaOYe3VVxdEOqyRScCruPuFmAgjKSeGsDK1Hyg6obcZXYMU7BKEaE5P7D7sjJIZlQsE4rWDKyD2TrWx3DVQv7sIYA4cI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a06c56b-8148-48f9-12d6-08de5dd235c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2026 18:30:56.1283
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ou/SK34sTrUK/LQ10mzFEXEDhDqU3uyC8OPiylWuqzqTwyWC2GHEAdZgel7SsgtAtKlNCWaTtZ8u8E1zUloMUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH4PR10MB8172
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_04,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601270150
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDE1MSBTYWx0ZWRfXxpsE2lwQPc3D
 DPJOg0/ePLjPuw9wv+UCoOgCllMovcGOkvxKLqtdly10wdvp3iITmQpvETSs5+bcdeVYoDEfexy
 WAJw5K0Oc67cfEB4JMIScBYKcRIilfdXKEkarwhzXwbpaY+oySmd2Mjzb4gaj068DKbFgOHxq4a
 Q7KqJl1xPs9hiNEDBcy0sp1ZDdz/j5nYQJq63mgTivx3dDUYbsvKECg0UKDQw6CYWiHoiFbBazA
 3HTbI500Qn/PA1DhMC1N/egVoR4B6Ji28V8avd6amIASmw6UTZPs6l5vIADwl/kcq0E11h7B5FE
 jrR0+vpGba75TKMIQa+WsKRDzw1Ts5VeuY5roEOglJ1Z0Yhufk6h+HA3GggMCXzCV9M65rxReme
 58U4PQCWrfstXx8wH63pEdb+ZWf80Q5FTI05pYooTFPtZj8R9Gq1jNACKofdmAIVI+64admPUj/
 DXqxypvS/1/4boCI+ydOQo6cIUHyWykXCXFmy3Fg=
X-Proofpoint-ORIG-GUID: bq9MMIxTlz4wuLNKnBGZE86XYthXMhb9
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=69790464 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=dcaMh4N4r9lwndKBsE4A:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-GUID: bq9MMIxTlz4wuLNKnBGZE86XYthXMhb9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C553B40008
X-Stat-Signature: 86zeu5efaqafmq4uhw6rcda8cibzkrmd
X-Rspam-User: 
X-HE-Tag: 1769538671-706745
X-HE-Meta: U2FsdGVkX18vEwRj7xexBk19cDKIyK1AXt/KjC4qy/9V7CeL6DeXF7rxpYKEFf48ObmA4t4b5uKKnz0dz9SIUx0ovnlyQAnAzxhXY+j8r0vqZPzhPgmdlnYwsuoN8fM40zEqxyH1vEvNSJQfKZ8NG/1gEfv8OO3e5rErAJXL28U6xXSV5ALWC4sEso2MlXq9+7R3GegVNtnJfg1eHn4g1rmGUY0Cgl9D0BviH4GGZja1JlkRDnWRtQbT/eze+YO8mIVl1hSLP4zVPUzRDXsa3d5RgAe9CYbgvXlGiOJm3ZOIwfCIyh5JVj7x7rTDJGEquyjiWR1TcIY/JO4REIfCFMwVXQhNjx1IQCq73is63N7m8CFHU+JgQeUge/tDerOJCoTjttHp/vVpbjda89rzGIqe9nTZfO97z2LgLHMuikRd+jv9ZPYGfVYsLnegWb/JMedSZqqu78fxMO+0N7OZCwGx+MWnQuuXonwHXK5C5zBEWMdpneqnPCK2ZzAVxW2KIzDNNzUiWu7ufb493ELNxlgLo6Txpig2YYFrjTv7yYDSyN3ERJPYU+bAkGEnFNKDAv42RoVC+0Gi/7QUhbudj79kgfX3N/+WvwkqAcgc31D1fYQ41j+M888ADdImoUPuaL6ZpvtFZyNV4EDn1GxCqauFo3tcnVKAxxdbtvzmqfEr6jPqEHTJekvEERhShWPzN5AX+CYoa8QXj+83JR8B+TGJsCFSSW3b3vJGsv2xCjdFY/6VW5Y33GmQ+DSKDv+UO1M2FhBTPKjK6J2ujSmiQFVNtkAZlo4nx7yg5az+h3gAb8EQAwkm77DDwk3p+Q2gXHnFMAx/c4zc5HEZ+ACBVb1Ng34oqlsZqwZlkjKShXi2AkJIMVFAKwrcdP6sxLUV3UMqoRGB+rz2JFlB1U2dtVaX0k6gpWyg9F8XVvsiM8h2t+W9C8T+xawGIDU6q0CChirJeyLU0pa2Edyxuzp
 oWC+5285
 LhGKUzKqiogeXn9MQD9Jg5z8BcWDjd1Gfihc4bpNaLFY3J7Sa1Ntu0uwL3NZFguVEUoQnBLnedCalOnn0SjxNRmMYgFV+ZHAwd7R8H4sK/WhwQNoZsaYSAp//uH/Q9tCIQANJ7MB5FvzSh9Ag30iVtzgJHplirIA4pA/ckJmLZbkCPsRgdS4RP2ooUZ/q17Mcwfc3lkdqxKwIGjjVo+u/1cKOLhR7kBkOKpJMh/EdDoDEK0Ny0LMY1kOZLfKZt+BqZ9TW359qvSSuW0CY8UzayaWKEqvRl8orAATupI7k1pP4Z2h5iDOeich+RtTnapxQIWZ5yXZ3/XrueWZkVb3SveHhAU2J2rsTDQZwrPYPzyBULx5ApqEcUalUWd5hqD8WmOZocgzD2t6Bl0mCxrNiJQzlDHWTMZQVK3aA8PJNLSfdD3s06frog1f2KGK0m0vsUXcl4U4Iw4AaM+H6X52TO1eXYCXShug1suxpm63Fo346hxAPiIhTy0yKc5qRg79aEQcM2wuLbQDaDYIH9+jL9wyydA1xGmHn8gQkAvD8z1dRXqUh0tZFh+cDbo16/aEGOr9uWz13wgOI2tIoTdXYzxMnm5f1Pg8MzocqD9N3UJQabvUcvCo3Ak7cvBPRWlvBu7q4AF/qtcutsloeYcenlI1Jng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
> Enable sheaves for kmalloc caches. For other types than KMALLOC_NORMAL,
> we can simply allow them in calculate_sizes() as they are created later
> than KMALLOC_NORMAL caches and can allocate sheaves and barns from
> those.
> 
> For KMALLOC_NORMAL caches we perform additional step after first
> creating them without sheaves. Then bootstrap_cache_sheaves() simply
> allocates and initializes barns and sheaves and finally sets
> s->sheaf_capacity to make them actually used.
> 
> Afterwards the only caches left without sheaves (unless SLUB_TINY or
> debugging is enabled) are kmem_cache and kmem_cache_node. These are only
> used when creating or destroying other kmem_caches. Thus they are not
> performance critical and we can simply leave it that way.
> 
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

> ---
>  mm/slub.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 84 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 4ca6bd944854..22acc249f9c0 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2593,7 +2593,8 @@ static void *setup_object(struct kmem_cache *s, void *object)
>  	return object;
>  }
>  
> -static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
> +static struct slab_sheaf *__alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp,
> +					      unsigned int capacity)
>  {
>  	struct slab_sheaf *sheaf;
>  	size_t sheaf_size;
> @@ -2611,7 +2612,7 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
>  	if (s->flags & SLAB_KMALLOC)
>  		gfp |= __GFP_NO_OBJ_EXT;
>  
> -	sheaf_size = struct_size(sheaf, objects, s->sheaf_capacity);
> +	sheaf_size = struct_size(sheaf, objects, capacity);
>  	sheaf = kzalloc(sheaf_size, gfp);
>  
>  	if (unlikely(!sheaf))
> @@ -2624,6 +2625,12 @@ static struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s, gfp_t gfp)
>  	return sheaf;
>  }
>  
> +static inline struct slab_sheaf *alloc_empty_sheaf(struct kmem_cache *s,
> +						   gfp_t gfp)
> +{
> +	return __alloc_empty_sheaf(s, gfp, s->sheaf_capacity);
> +}
> +
>  static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
>  {
>  	kfree(sheaf);
> @@ -8144,8 +8151,11 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
>  	if (s->flags & SLAB_RECLAIM_ACCOUNT)
>  		s->allocflags |= __GFP_RECLAIMABLE;
>  
> -	/* kmalloc caches need extra care to support sheaves */
> -	if (!is_kmalloc_cache(s))
> +	/*
> +	 * For KMALLOC_NORMAL caches we enable sheaves later by
> +	 * bootstrap_kmalloc_sheaves() to avoid recursion
> +	 */
> +	if (!is_kmalloc_normal(s))
>  		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
>  
>  	/*
> @@ -8640,6 +8650,74 @@ static struct kmem_cache * __init bootstrap(struct kmem_cache *static_cache)
>  	return s;
>  }
>  
> +/*
> + * Finish the sheaves initialization done normally by init_percpu_sheaves() and
> + * init_kmem_cache_nodes(). For normal kmalloc caches we have to bootstrap it
> + * since sheaves and barns are allocated by kmalloc.
> + */
> +static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
> +{
> +	struct kmem_cache_args empty_args = {};
> +	unsigned int capacity;
> +	bool failed = false;
> +	int node, cpu;
> +
> +	capacity = calculate_sheaf_capacity(s, &empty_args);
> +
> +	/* capacity can be 0 due to debugging or SLUB_TINY */
> +	if (!capacity)
> +		return;
> +
> +	for_each_node_mask(node, slab_nodes) {
> +		struct node_barn *barn;
> +
> +		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, node);
> +
> +		if (!barn) {
> +			failed = true;
> +			goto out;
> +		}
> +
> +		barn_init(barn);
> +		get_node(s, node)->barn = barn;
> +	}
> +
> +	for_each_possible_cpu(cpu) {
> +		struct slub_percpu_sheaves *pcs;
> +
> +		pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
> +
> +		pcs->main = __alloc_empty_sheaf(s, GFP_KERNEL, capacity);
> +
> +		if (!pcs->main) {
> +			failed = true;
> +			break;
> +		}
> +	}
> +
> +out:
> +	/*
> +	 * It's still early in boot so treat this like same as a failure to
> +	 * create the kmalloc cache in the first place
> +	 */
> +	if (failed)
> +		panic("Out of memory when creating kmem_cache %s\n", s->name);
> +
> +	s->sheaf_capacity = capacity;
> +}
> +
> +static void __init bootstrap_kmalloc_sheaves(void)
> +{
> +	enum kmalloc_cache_type type;
> +
> +	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++) {
> +		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
> +			if (kmalloc_caches[type][idx])
> +				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
> +		}
> +	}
> +}
> +
>  void __init kmem_cache_init(void)
>  {
>  	static __initdata struct kmem_cache boot_kmem_cache,
> @@ -8683,6 +8761,8 @@ void __init kmem_cache_init(void)
>  	setup_kmalloc_cache_index_table();
>  	create_kmalloc_caches();
>  
> +	bootstrap_kmalloc_sheaves();
> +
>  	/* Setup random freelists for each cache */
>  	init_freelist_randomization();
>  
> 
> -- 
> 2.52.0
> 

