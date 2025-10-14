Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D4E1CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01E7A8E0136; Tue, 14 Oct 2025 10:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37E38E010A; Tue, 14 Oct 2025 10:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E000C8E0136; Tue, 14 Oct 2025 10:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF4958E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:43:43 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8403888909
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:43:43 +0000 (UTC)
X-FDA: 83996988726.21.A8053D4
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2BC1640009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:43:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i3DuV2fs;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tzXqGwQR;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760453020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozFsefoUL55wzHEcZ79+4t7af+ZFDCO48ihl3iaMutA=;
	b=r6PBlhbDWze1M4G7KHjJSKsmg4ZqoExt8WN524XP841Zef9GFUzWAf+vNPNr99SN6IOk/t
	GL1FZWzCkqqCjiP6lFXaHMFMehN9h97MIEYfNr7tPH1ksu0E/fKiTdMHWNkAB4yGDO0BFV
	ECU277LLiZZEKKyuS5t06gSyaq3Ygcc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760453020; a=rsa-sha256;
	cv=fail;
	b=0XEv9XWu0Zwu4PAyneNjp/9F4isdga6nVzXxR7qt3p/fHn7mCzo8LERLYwG7Nwqe++/YUw
	KVjOoZZL8FgJcZCYb6hG4SwY0NA7I+BVerNQKTSnBBrtdmSHQDqETyjP3M7Ejkyr9FJaVG
	KK0bQVZKxfEhISdX2h8iRxGBgC00XzY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=i3DuV2fs;
	dkim=fail ("body hash did not verify") header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=tzXqGwQR;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}");
	spf=pass (imf04.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59EEfKRo003762;
	Tue, 14 Oct 2025 14:43:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ozFsefoUL55wzHEcZ79+4t7af+ZFDCO48ihl3iaMutA=; b=
	i3DuV2fs0EjNh6iNihLefNinNOGjKTl/6RBvMYl+Obd0+ROu6+vAl305MeCnYjQ0
	iZLZHq9uu0qVKBh3wkSnN/gDbitcDSKRfVHbk6KaX2LYWUTTE3iOVsthXVz8YbxI
	SzrdxRfQkGNp2wHS5fWMrt9REaEB15hBzlW7JXS03ajK7MmzKi2qyIjQxft/eRM8
	VyOnal9qAc5Nv9auTs6ZeHK3+5khASlR6l811uixPbYIFZvRaia+tMAAhBVjHpGz
	6SsqF5BdwhkldPqd5dMC3iOwmDGcWWAUh+m/NSsACF1KeaF06DLZHnN7vumTnqop
	Ggi41Po/5sD0dyIrex9emQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59chnc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:43:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59EDt2n9037124;
	Tue, 14 Oct 2025 14:43:31 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011060.outbound.protection.outlook.com [52.101.62.60])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49qdp91mcf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Oct 2025 14:43:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xR6agHgHozSHfn701cDUIsPOw5oHYqzQ5oVTPpuJeik8AOyfBIgQG4lwlwwwC5etKjpo5oVliRrHvyzJ31EdRMhVhxgRgbPUu/YyNDVTOrmz5J/2WsRFxkRkuk7bYAjtHxfmLbzPXwx6WyEijPgcL/Z9DZZcnlxkL/woDKT5Wo3MiE2i1hbsH6vWOCml1U/p9/TdpZv6zDRMK4G2hsqlyavixuBuXsf/7aezL0er6No86xzAnwkMxc9ovVqvSnf9mLkIu4lHrSqVP0RHz87Cn667C1CRup6bHPG1cz0dEiQgtTRKdP/3XbXahgrg1MqQjpDwULoXgidoq9ZS6R/THA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2DxiJFqwfpqFT/tkjAja2omU+LHSfKU/dWIxBB5rvNk=;
 b=SzKjXtXi1hiMIYyobqLj+3vroGqwULfyFHqTv+UtcKh16aXqX2zBkUyHvEB5MkD536ybZvi2+p7IfzlizEYafqoYEX0kNTlqd7b2NKt1aMbLXUcCAVZRl/Dgs1Mcazltvyt8o4vzeoaIN5xwhMoQaqWTRag8Nnn92qWo2SVW10MODFzYlfJn7daXh+88sKQOJP0mPySwZa41MLaF0/Rf0Kje1KfAVgGq59ou0oN5PJXeUoyZ0NymdZ0XdXMQ/zFM89grH4Zr8u5nIePVTEPRlOP3yE0zBG2E7bltk1n2bqc5fTWHZEvZvy1IKynJDd56QlzPiZ4noe2ixSOXplaBNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2DxiJFqwfpqFT/tkjAja2omU+LHSfKU/dWIxBB5rvNk=;
 b=tzXqGwQR/CK5OkAjQgokhoMyGb37XUkrCSe+9fQUzoX1z+S4CiVuInvKDEBQ6Mo6eZuGXmasMq/9TTHc9wng+qq/9t+ShuhZpiqwEeZjI7Ws3QNdJhArxBDAsz7tlkIUmKR+88rnV0UkDW6taMqxkjINczB5dv+7A826a/818G0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF972B28679.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7ba) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.10; Tue, 14 Oct
 2025 14:43:26 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9203.009; Tue, 14 Oct 2025
 14:43:26 +0000
Date: Tue, 14 Oct 2025 15:43:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
        Liam.Howlett@oracle.com, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
        ioworker0@gmail.com, kirill@shutemov.name,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
        npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
        richard.weiyang@gmail.com
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Message-ID: <3b6f0c03-9f1b-4213-8364-be4c84723803@lucifer.local>
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <6f448506-677f-4e0c-aa9c-d5da061e57ee@redhat.com>
 <2e22cff1-fad7-45a6-bdd4-d5921d12c5e2@linux.dev>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2e22cff1-fad7-45a6-bdd4-d5921d12c5e2@linux.dev>
X-ClientProxiedBy: LO4P123CA0356.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18d::19) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF972B28679:EE_
X-MS-Office365-Filtering-Correlation-Id: d93146aa-a3f8-4836-969e-08de0b3008d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?L31ZTj/kWWIdMR+WVjV6SPig4TqMe12dIp0gXxviDP1vicycdjS85hYvs2?=
 =?iso-8859-1?Q?jMBFXpMT4VD31xhGknffDY06TXJoU/wf+6fLlDXQNHX+aqd1jkB1BZGx1s?=
 =?iso-8859-1?Q?H2dPYAIwPMXhTASfV0JJLy2LA7KJaVjZqQz2sGopsJaJmwE79iJdNErxT+?=
 =?iso-8859-1?Q?59wfRUXTimVHJbElorLZip63PaQAxTm/pDhteumzdzmE7qtesxDOyEbaMc?=
 =?iso-8859-1?Q?cr+wpi1S8D2fgCYWEf06KPIPi6OsaqVl5Wvl64KooKNTuJqrRyWTlgmZvm?=
 =?iso-8859-1?Q?fNfb3g2/+6Vk3uLlMS2cKaw9jg39KO8ATJe/0hgvs7QoSCz/rFn5Jbpzx9?=
 =?iso-8859-1?Q?HEufBV+9FRho2+fB+T+HyVyPwtei9FFsD670PJZR586MPy2bLBPZsdbyqg?=
 =?iso-8859-1?Q?EMmGiqwv/9C4D3tg3QBLDYMXFsWyHMj/Kp+6OY2TSooqN/Ek6WS0NivDnt?=
 =?iso-8859-1?Q?nwTYWY0XByn1dgkDZSdl4uL5PTvSn2WRu5bwHvpaxZiKjvLXtcVOTxaxT1?=
 =?iso-8859-1?Q?2+RuBPCpzhqw9jayjNa52bYcjs0IykkoCyJKyLfhq1fV053RIZs4NAgmir?=
 =?iso-8859-1?Q?yqoLWuydfeG8UYuDhZ9lw0km54bMddZWKkAJpEPJZPF2zN9Mu0lP/+jc/T?=
 =?iso-8859-1?Q?cvPFhbbimbmIxNxCfWqAxnxPoUw1wQEcE7RxNV+5ZfpTyIgCRlKbPYLttf?=
 =?iso-8859-1?Q?uEEzdEkThSRct/6ozsxYu0Sa/Ami9e5uSY2RvDsBtfsrPYt++YFt2FtzrY?=
 =?iso-8859-1?Q?6kc6+u7afcSnkLOE3opZ26p6AXAHRyIytSSxMlHCauA8JKXthGtbY0+RBo?=
 =?iso-8859-1?Q?jQMg4p2ecnOHsRvHXc5OzS25pxuG3ybAX+f7eBEx/GXo4UJSA4amIELQ1E?=
 =?iso-8859-1?Q?dHWiqh/f+Bo50hYrS5zQ6vsmqCZjw/sCtKEgJKEFZG/QP+MjAnjMkSCfrR?=
 =?iso-8859-1?Q?UMCYQ2eiClAoOGXwL+UCV3twLeRbdAsKvIAFQHLiUBS6/s+h6NuyjmNyvh?=
 =?iso-8859-1?Q?JX+DZ9acidIpRxuqK7SLWp01cOja4lBtSXpFhfYNkDx2vUm9O7OKpyGQWB?=
 =?iso-8859-1?Q?TAM1SAa5Uz/c6W/oXZOkEQ6p49zq0eOHfpHubzFrJ/WrM+V7jUwLsXegte?=
 =?iso-8859-1?Q?d5Gbu5mF26cCt/r6PhklNi8fN30Vh5tvWpU2VpA03AGJ1GUGD8REmKNUiT?=
 =?iso-8859-1?Q?Axzc4A4nLGKA7Ct99z+x8H2SzwCrhAYHVmaF+Zn+LX0hhwiJT5Agv4EsyP?=
 =?iso-8859-1?Q?hWHm6iEqeLKx6dY1/0JJHFLdmMLm9+deGWsc4u3gpDXA+23mp2lEyfp9Gu?=
 =?iso-8859-1?Q?cHw36Xz31emVj5j3MekQ67BbldqhaECeUvWy7cmgrNNVY6J2dIq+rgdT9T?=
 =?iso-8859-1?Q?pRop9vVmdXx6ZvINn3cPCxAtFEBb66Rp37QDXKjfbKRp+0KUA56LvQamNC?=
 =?iso-8859-1?Q?3v2Ee6bR68iVyYP5o/xKj4IstabKRtY0Nuq4yLw3hBp4/3xfqXvQL4MmjV?=
 =?iso-8859-1?Q?dAtQoZefctKeNWLbZLtxgp?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?HTMsrdSLRcVNrsEZiFulyQlZtG5muFONhBfqHzwwmGhaEg5hKzYLUpabPZ?=
 =?iso-8859-1?Q?zbkyJNeQN2yFdnAuRjyikd/k4EWWv81wULhb52tHwyhBrj81DmMNDZOUFt?=
 =?iso-8859-1?Q?V/zhc21BGwbHDXKxqyAAalG6arng6k8/opzKaj76HSKl71h52WERjE2518?=
 =?iso-8859-1?Q?r/bOwpX5bqlj1lDUW6NQn6xP2JVL4z5NodqPhTQRDCQm/McNDmbd7lMKBI?=
 =?iso-8859-1?Q?EugBR1vwMLauLqEi/DU3CQyJwhCwFY1ADZ3u68vU4aZo63s2KDxOzTNSIU?=
 =?iso-8859-1?Q?JHSEqY/Ja1/Gxyet8/RNBntiae4/HqA9Bj5hVjTKgSLaKL1pqFPZ3DzzdF?=
 =?iso-8859-1?Q?qklrC8gz6ptRUZ9yRhNsT4phP3MsjO9U1J0zSHzmft/Lw6kK/fHWervYwh?=
 =?iso-8859-1?Q?9qZjIQTx0pdu7ptkkYStb4rNtsXYslhAFB/OxL6mQNYB9weLjLHgM5Emg7?=
 =?iso-8859-1?Q?mUTwxlOGp9I7Dir2+JktN8X7B3Ethx13GJimdo8uidD8mKjY6R7AFUCMeJ?=
 =?iso-8859-1?Q?y6Sr/PVyS3+41Vcwl2QA8MkT0SgtZWRB6WwhZU/2GmxqX44WkwE2jMGzEG?=
 =?iso-8859-1?Q?fgTdDpKqMDctCuSKvg8xU9gDHznRYe1wzIZX6Y3TIvwDvlnVf0ljvzwQcQ?=
 =?iso-8859-1?Q?aG+8JxH8H52cd6JM45+rHcZ6mNa4fornB93IujyA9jQdU8Zj2FZLgSU3E1?=
 =?iso-8859-1?Q?TRO9Gx/jB0c34oXSksbOxheiDg8FWXWFugEdwZNdFta89EbrUkRV4S/TCL?=
 =?iso-8859-1?Q?vJrxYAoo8W/vn1rXI+sDVG7uCVM4ssJY6VzFk5griG8bcQWxx2HzlsdKVh?=
 =?iso-8859-1?Q?nvO3IPI84Ts7F6/dL95zNoTnhneBJNPDOW07GOz2uWvkR/x4g01kFG8dZQ?=
 =?iso-8859-1?Q?c1gsv7jaDjwx94GQjX4UsS5/Z/GDakbq9k7rm9aCUpwP8IgaOMzL5PUE2F?=
 =?iso-8859-1?Q?EMUeW9RtWQdzy3+bmeRMkjqIBpJFe9/8qQEDo4gKjUFtu5fMv4Jp92chmw?=
 =?iso-8859-1?Q?y32fPasIA9UrrwQTAFVLkFdVrvXWuUxufSblCJPzEfrfLMqMKeD1YF2Gls?=
 =?iso-8859-1?Q?uUvaO8KWOvMctUMCutsYNaQAOuNMo5MgBs2x/fIN2u64joco3J5Ri384II?=
 =?iso-8859-1?Q?eK2MJO9Tmr/areOBcwQXp2Hjq5egRjuNkGMChf5M4M2KRONuKEuRWsFQX6?=
 =?iso-8859-1?Q?ZRqaGvkraH3ny4MFM7KD+tHSZOqfZaIwoeR06TJ9SbnwPPQWVXkS8lTPdD?=
 =?iso-8859-1?Q?+o9AoiaT6/P7RKcZzeVOSFBhJZf56mrf/f2dloE6KbrZV/xjXrpi64Ns3o?=
 =?iso-8859-1?Q?9G2Uu8zSq2Zx8C4oUbL5JGJMF6MvMCl12nWqd4A/WaPZLBJlxOfnjoMOoB?=
 =?iso-8859-1?Q?jBNCUv4+LcLtYdGGj1mneBTb6QywYGCAaTRuJl6YlR6j0BkbTrrBR6Ztdp?=
 =?iso-8859-1?Q?dqPc2LdBLZGPFjmLCd1l5YiCymSOsZuibx07CbhbwYW8UNf9ZRoDtiS6ht?=
 =?iso-8859-1?Q?iRxcWEEwlPXIO+hGpY9r9vPL180ZcTA3DMsb7N1KDo/oQnkayvuX16nPgx?=
 =?iso-8859-1?Q?+XgMf/D2Bzlun4hAE0p0et4uU++TFUeL75DztdGLlif7W4f273+vqRde0P?=
 =?iso-8859-1?Q?h8sX/x/4M/JVWks6i6zuzpq77l7KdAYoXPq/OlxkLAZbEQm0QCircrPg?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PPBBCeKK999eAiigi70YFBl8Bt4a8Yk157CfyZdzzZWZtBdC810vQQ3ouixxHl1vgoaATGEGleep/fDpzGzJWja2jzxao+jJW3Nh0lR8iDlSDLDEboKhS1r8Ne4Xq85p640p4RZRovyHtAYmIdpmLgZHgaC7jv0ZDm3mj5jXKHafjXUcgFnw1OD2nEDg1xQ3ICvpcKfMsmoSywmLOWsYIHHKfnmrl/X7/EU4YZaHHnJe3HnLu5+c6zLUuuA+DHI/GtjRoO1a/YwaHcRdtoVpaXUCG2W0DanNvzcd/OA/lHoCKJelgCysYe1LJcgKZ6Xc5on/X17BqZWoNzDVSbpWl0x9e4ULkkveH5YnYQbUD+a3TPGR9iwZFi8I+R7PTje4GIRj7oFDVLB+Dwiwr5c3GR67JroYJXlXRPl6bT78Js2UWGydVdKhegA9DiSLa1W7qbuf+u45Eb1ZNParL8GWEqPn194/+AaGZe2J9soM0AUQ2xYzfDo+uxCmivXuJVNbjtrZduH+1m7XEDhR4NnU5zWcMkKr38dSz9kLr/fjoYVd6Hg/B1JQGAWD/9rs4sMIaX3/hTkyPvH7IxFVytUWw0+Q/ndaFrpkDt8C67LPwU4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d93146aa-a3f8-4836-969e-08de0b3008d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 14:43:26.8097
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fseAezxzr8hVO58lHO4Deky9E4lHRYUCZr25AGBCtonKU/95UfTSaqwdgf9MZHZFd7RipSoneOLryQQY9dlvbKais1JWgSj0+QTtnKIJqSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF972B28679
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-14_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=523 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510140111
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfXzH4gBHr0P2IX
 WJ6+AlPwK2GcxUYgsJeEz95/YgAtxmLJSsLr2YkLh1a1RVdi3I+zfkImP4uK51T7ns+xis7CAi1
 GwNv3Q7/IWCT3G/3GGw17Lqbh1qprxuDBqrdcDgArqfA9sPvYmoUxO195m7twE8KZZ3YFmnqyfe
 q/O2T41MyoD+SudkedwVMjUdNclT8tkCSOOtGPlnfR6Mk00fphh9pJzxlaFynpbbRcYtkpy7PNl
 w8IdrhPQtyOZyQcI09xEVXphZaISlpNNk5R267v8OA+zIbCCKxnlnDP3blAi/2cMSqhDg7egOrw
 vdFTazZDOfTGXu+6Uu0x/6WNEG4x/Y+6KYVaalAxvHSo3dQMc5iv538l5yHk6bcsX2abtLG3xDg
 KeN51COj++fQWPirD0/5r3H+GN4r7g==
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68ee6194 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=6GQVgXKNE7rO_wOiiJAA:9 a=3ZKOabzyN94A:10 a=wPNLvfGTeEIA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: w2-xuyRqfyjpkUldHwo_QOcZNUjAUrHi
X-Proofpoint-GUID: w2-xuyRqfyjpkUldHwo_QOcZNUjAUrHi
X-Rspamd-Server: rspam05
X-Stat-Signature: dxac3insmbxk86wjsscq9ok84kzyw7ir
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BC1640009
X-HE-Tag: 1760453019-858125
X-HE-Meta: U2FsdGVkX18YmI+UiuPupllv18WqdZZWwwa6b3Psojn5iYIOS/heUTMVQ/b7KCyeav3nOJ/6GhdP4DoNlb69ZkfrKFfynos0UqYYQd924W2qNZbncc3oMwzKKr3LrRcYwdGe02LfEIuWkg4TW1X5mcqgW+SlEyr/Q+NrmUc4v7EPglSZ8EOb4bqEL809/iRgWGUfA5kEEtrDd5s8bFsG9Nr37x0jfPRIxEmE6or8T4HbZv3S+pc377fJncvBVTT+78YlGG7v3G7b0jpXRtui6XA7vrjkvW1NhHpGs+dWa4lT5ZRwAw5svMfrM2NJdbXGcB3j21HuBp/x03nojqlkfrAnp2jmClZ84qDZU3CgEjd/rxasWPODHmw2Vdz4TV+Grq+lejAGIYx3Y9g8G2EasEH+uNDttoeTl1jhmIAlD8Rud7vHadtAfzrS3gjXB35/Hs1xVX8TJTyqVt27EIxXniAWaJxf/eJQQ325cpCDCw8vlhc9GP+xEbXUr+HtHFerEqOJvMpo0exNH0NyNyimfnLyrlAA5gHtwMuLxfPgIUgE5qaN3DMP/09pmkX6dv8DtlO72ackwMYxjEX0jQbm0a4uTv6ua+y8VBdNa9qGbjjHO/PVBwVpyXkaczM4cJpvj2cEiMiIqiocTT09ZrV/12/5e1T1w1yXG9F/mPC1llFMCcH7g32svsvRemcrrxVWGx4rTQq2TFzEDemBQeBErep57msDalZWAcnobJlK6I1aqlZnEiSPrXw706pEKrRJ+zr1aCUYcFhczKf4ZYMwOMzK4iKJeRjSMHjDgq+H7EH7dfKliSAfALr6trAw1cQMMkUoryJCJptevl7x3OLS/+zrUif+LV1L3wddqgl92JHS0+A1Lr6tYEneDzp9m57e1aG91lsHeHLkOmOQrbPApox5l+H8wqAfDBXMm+Wr/7oJLkVTEFJ7P3WQeOL6XNucZr9jpVB8ebJhwgVgrk2
 wnKhh+8n
 2EZEF61xdkCpqeSa3Jq6ftfhJNiBg8OUe3yYjepNgsLHRoq5JXpnYRNOxosqrBYESTgvG7LkMgwNYBV1JoN/x7+AKibZjuEfzNoS2rMJEc7UydbUPR9Udukkt6PyiGHT1EJcwuNxmAQU8jL0MrpkVIbzgD3bxb4bLMzlSGngziJldespXJCdo8x/e6GmkqP/mfUAc2/kC4AiA9cmDK+x/ikbxf8UQlVc8PwR5sW5klT/NIUzvWVgw8l5tMhx5S0/db+sklU3MWajT/JM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 10:37:28PM +0800, Lance Yang wrote:
>
>
> On 2025/10/14 22:32, David Hildenbrand wrote:
> >
> > > static inline int pte_protnone(pte_t pte)
> > > {
> > >     return (pte_flags(pte) & (_PAGE_PROTNONE | _PAGE_PRESENT))
> > >         == _PAGE_PROTNONE;
> > > }
> > >
> > > static inline int pte_present(pte_t a)
> > > {
> > >     return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
> > > }
> > > ```
> > >
> > > On x86, pte_present() returns true for a protnone pte. And I'd assume
> > > other archs behave similarly ...
> >
> > Applies to all architecture. prot-none entries must be present,
> > otherwise we'd have a lot of other issues :)
>
> Thanks for confirming, David! That's good to know ;p
>
> So @Lorenzo, looks like we're good here on the protnone front. Does
> that clear up your concern?
>

No absolutely not, I go into detail as to why in my reply. I don't want
that upstreamed.

