Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C845CF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 07:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FB456B0088; Wed,  7 Jan 2026 02:27:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3B56B0092; Wed,  7 Jan 2026 02:27:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD7D6B0093; Wed,  7 Jan 2026 02:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D7F1D6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:27:56 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 834C61392C3
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:27:56 +0000 (UTC)
X-FDA: 84304338552.05.7E65EAA
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E06C40002
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 07:27:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IO93mUND;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sXKukkTd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767770873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ELCC6Q63pKmVdkFyExftbzFcFFpPI4eTJB9Po95odE=;
	b=ADID8pkLYnLzifQdhDNn4b/sdiU/MV52DqLKDv0W+stiqsbqXy0KMxe5em8iTQGibHZ3M5
	j58GYmcXjCX/bfB5X1kvkgXDWfwaaeFX2XkrdHp/cvMn5SuLwUSQcikzNfwopnI3UwjWRb
	1eLF2vPnc883BqtpEbZ9Cp7B8zsEif4=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=IO93mUND;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=sXKukkTd;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf27.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767770873; a=rsa-sha256;
	cv=pass;
	b=1fS6g2Fo2w51ttuYzCLyW16G58bAAU9O7pUIQmwt4E3d1BvPVD2pczcvSl0c6XruXQZ3XF
	8anqJ/caLX5jGUDAHW3ZDXCTnpot22vL0rdo0Kkyz+a5m9wcz/gykzV/rXyDZiEDa7PQGx
	Wvpklhy5jkoSQ/B1pwXSmXtNS8ZQoCQ=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6077ARtK1392634;
	Wed, 7 Jan 2026 07:27:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/ELCC6Q63pKmVdkFyExftbzFcFFpPI4eTJB9Po95odE=; b=
	IO93mUNDiAErGoABEUYNFzuKe82+gxvGGqQLXJ9jESvz1kRxa25b2OyRcENo+bZu
	cHR4B282NqQegPQpNAZdKCQY9TGeoa9BkDOY2RuPHkQYtF2lMo+oBZp/dmb9E+Ab
	Yz4TMGKK6YUCqEbvo+Kq6WRFQlQG/VyJL08ljX8As+nHxJtbXcIL6egPh+PTpN7g
	wFTtzi2bB7TJhS9jPJGE6y1927PBqcXl8QmJRnmj+X/g7FP9ZXeRhezD4ZrlYtep
	1opYFgf2HrV7pW2/fWQGPqy/bPTi96RZD47sfXEZltkJ/b/zjyk2Jr/pJsftSlJI
	KoGqreFiaioSHQf1QNIEDA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhjv780cw-3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:27:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60765tMU026351;
	Wed, 7 Jan 2026 07:20:23 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010052.outbound.protection.outlook.com [52.101.56.52])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjkt18d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 07:20:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Yenjyorie2wqTSXEvjHfxxXMe/7ZT0EnLy9WoLJA0JlNELXgbH8IBfYVixCStaMPYSSJLd5ApiMyXvfYh21Hhjqwc9AbQSDT1KmvN0GLch15HDk8yOPN5kZymF3AEFRR9yh8WeGdSvZ7XWzdTy4hm0bZywtdO/Tr/ydMWI4PRL3xPsmFlmJReW3NOBpCZj4rK7bmfkWqRJhDE8pVTtn1696iZrwZuJuO7dzDxu6fXLS6ym7NkON+b3ycQZVfl4Bwf500ymycPPCvqxb+Qn2UKE/nh1dm66gxwtNDgLzmTqe+phDxM0nGtH5u9ao+xz7kkTjJMb8WBOsMM4OHCZJ+XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/ELCC6Q63pKmVdkFyExftbzFcFFpPI4eTJB9Po95odE=;
 b=K9qJlTK+Ikg7a2k6x53DWqmtiXYtG0OUY9dEgxX2xQu6CUnhCkW8oMVDuVKbRpWAYJ2m0wRe3Rf5D7w4kSdvC98VOSeSq2yWd1TOXmz7M8IrdWkla5QHBAIi7GnwlOIfBZRYNGZ+/c7F/psa+LIF+CnyhE2UvG6f8wXEkDx8frwVrUYv5+OMnLphl/oMeS/bEcyZmXTZGHyRY8iYk+EL1OgLIawTP+F4ZoMNV6qE2cb1i4K7w6Go/jGZx9L+KaY9tq1EvhP5gdKDTYnoDt5+6RGWfMfyJW+PeCbdqgb9iPqVUBNoTAYXX3ASI3gHTUALcOzlB8pvLXoZ7YqAbVgXMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/ELCC6Q63pKmVdkFyExftbzFcFFpPI4eTJB9Po95odE=;
 b=sXKukkTdLCCv+XYN+N8SMm0iXXXYEqVBHPj+QEdJY8hHCTwZuEOjVlB6apZOs0WqSnqP3PCEOkbNaFRV1Rh1gDhkDHt9GWTJ8ieUp3a1fCZek1e3I2nHIGBXLi9u+E7msFm81I1vFp1D7idgO7n8M75JwG20RZPnnAI3497HVs4=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by LV8PR10MB7750.namprd10.prod.outlook.com (2603:10b6:408:1ed::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 07:20:20 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9478.004; Wed, 7 Jan 2026
 07:20:19 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        chleroy@kernel.org, ioworker0@gmail.com, lizhe.67@bytedance.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v11 3/8] highmem: introduce clear_user_highpages()
Date: Tue,  6 Jan 2026 23:20:04 -0800
Message-Id: <20260107072009.1615991-4-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P223CA0013.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:303:80::18) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|LV8PR10MB7750:EE_
X-MS-Office365-Filtering-Correlation-Id: de92d0b3-961e-4f23-9c1f-08de4dbd36cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ohjkz+JgvJcqmthQhxPx0QWsKXr2KbxIzhjvkkO1rJeoP5EFkmWUXJyA9sB3?=
 =?us-ascii?Q?7th5qY0Z/C/+T0v3R7igeDgijFvuSN4gngYkFq9chFN4dJBsKbwVPb+Bveso?=
 =?us-ascii?Q?Jc9vPT2cWaioX1iWRdyxRK1dWrOelIE0StzvO4gaShrBni3ffA6pLqoG4Hxl?=
 =?us-ascii?Q?yMy9dki5UU80WWmHv30+Vx0/GFM3xFg3R9KwoY2XbpxPv/nzG4lStahEuO6P?=
 =?us-ascii?Q?5wi3qWMvEVsR2SWfAqdwKiI9KVdDeU4NvN68PObxQ/x7MCu3geAka9QPFfYy?=
 =?us-ascii?Q?sOMT83Wc3O5D7pSzx/xjimOXVuZ3/q9MrQv0MVzj98hG30oEdcjNv1wRgTLi?=
 =?us-ascii?Q?ZvNhQ0pbwdb9p1ZeR55ri++zmQmQNlZfhPYI4HD3hnITUfeYR5D0/zAElDjg?=
 =?us-ascii?Q?/0cEO2XrWLVwpWWIUk4BO8ySUYjfeFTgwukyc7CKJfZhixMNp9fSh4bY4Z6d?=
 =?us-ascii?Q?gSUcUFoCdm5zV5V+3bcYhYrD6siUkLhf5Jo/FPrawo3DJ/4Q6oLSL9XWhPoN?=
 =?us-ascii?Q?YLNl10sW30h7VSOmiL1RisnydH+kwkOTCsChaE4aWtfEd/7rM3XMsTnCg6qr?=
 =?us-ascii?Q?E039j4em7p+RFx7Ch2yNVViVxEbCYnAyJQIWE+0nODp+BWPrM5s811LOKhVM?=
 =?us-ascii?Q?iFMZH7AM3FFCbmQEnWb9/GWF48355OtawwbsAcImwX9IewySxd3Qm7kmFIlK?=
 =?us-ascii?Q?/QiZO+zHo9rozQhWPlOgR9qAnxDSPq3NmPjGP4/qVc+igfW6cqzaMr/vlWUw?=
 =?us-ascii?Q?uKVALl5VW8PsuiePjRDAY/1i9ALExqNn8JGwgy45FPNyl5ujNcCTwFQfDKsB?=
 =?us-ascii?Q?uU6LayJiFgy7Jv/NQJXcAjUShRjBC874ElMppCpp+y79wZcjzBQ/BUFB1+xr?=
 =?us-ascii?Q?bHWuh4jF9QS6/zgBua1t+sSExaRUD8ryA4zcUYEIk4Ih8MpOgmm7YXIeSTAC?=
 =?us-ascii?Q?zkHyFZdcU/41dovNKC6BU38l4QPWXPk045Ue3xpE/KjlfiEi0qVmv2F3qBB6?=
 =?us-ascii?Q?QlSk7vb16JpfqGAVQwQT/0naA7XqqKZ9pvg4U5NlSspGr2QYLbdwkKqtsv0e?=
 =?us-ascii?Q?7qBkSYgwzxW0GsczwkaB1CPdwKFkmNZ9IxgseuzJmlM5CSmGi3uXt4tVV7if?=
 =?us-ascii?Q?2Wa6EIHyboHWOyoYNFd7Opcn0dltSSVkzsLXoYhGV7lpNhqus3bmJ+1UITuK?=
 =?us-ascii?Q?TDpmBHG2PcsGuYu+VIo7lBc21oaWG68sQdhhnn433dXZA2nGCL356y4Syd+i?=
 =?us-ascii?Q?1Ma7QadWfxcq6j+Kz6hJZ3PbCC7e1YwteG9HBkqv7nDWp2PKgMzeYlCsah5c?=
 =?us-ascii?Q?4zYZAxVCeZbEQpkgbW77Hn4fBu+C3xiwuxMWn3tw5pKYpfoBB4jtV1HCCz53?=
 =?us-ascii?Q?kCUWtyy5agua0MRs/CFiAjtGzWc/Md7TbBPnV86O7QU+uj0Ax3lkQqwImUj6?=
 =?us-ascii?Q?iSKK9Aom/v7SkXP/wky7fVXhabELEeXP?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?280GgMVNqSCMEaMhdKzjj9Dx7rn643EG4cDNTRg8xLqav9TqtBIb9x5jjufj?=
 =?us-ascii?Q?cHqL6lVV8904VgR0BvF0Mxp9rdzD8EOulRGwURFnFzkDIIplThMNbw2hMT2Q?=
 =?us-ascii?Q?0IJWv3jI7N1zqpkKEBw2qYGkErAT3ykjUfL8SV/DoKUZ/a5hK96doJnvxZE1?=
 =?us-ascii?Q?37unyKtIntjvUjidZFekDZE8rYii4SjlYpHXsVwnfXxASirP5WbbULpG21rl?=
 =?us-ascii?Q?PUNDA9XiUGg5cyXgJxRJ2egbkSKHwo0hpY1WzUqbscbI3bhFESma1gn+1RdX?=
 =?us-ascii?Q?j5KTl+/4aZ3/djDkOQAZTgbVZTIpScSdAgs6NJalful8EPzTRUA4LTy95x20?=
 =?us-ascii?Q?rlsxce9tFUujzfQpTMqGLsA51oqNNAkopipF9EIlF79d3PJryAZZCH7b5V6S?=
 =?us-ascii?Q?8Z7Vvb7gUEu2hRKBz5nmb1sNFdHQja//hzcaFbcdWwHnV3iSDz+Q+RAiHdQf?=
 =?us-ascii?Q?wQ3uRtg5qub/ssD63HXHb38lTHupL9AeVlR5KJ0nIXySi9+lQUADmJoz2pgS?=
 =?us-ascii?Q?PnPswSHQovRfYpd0XUW6FVADlMdl4IDTBxKMaWR+pMlQm0XPD3uJwSSn0fJL?=
 =?us-ascii?Q?30QOmfqFRCPiUL27se65ftVaiYT6AEweTIP7gdDeb+JLpvib/7pEOCIEXQQ0?=
 =?us-ascii?Q?3OsrVPeW0ksVSjWQfjt5/l0BXIcp6Sf1ZcFDvYZuCDCsX0/i0yvZTeGT9C3p?=
 =?us-ascii?Q?+by8XeUt9VI2YzWFQEYqZGdJuM3dzNSlXafI0FA7A7R9ko6gnMA4k3dkbDHY?=
 =?us-ascii?Q?2aPfXFS7RPp47N3Y2nrX5oq4KTwltUobSFCYHoo7nGkeYTJv+3YIHTS+Avv6?=
 =?us-ascii?Q?mm6U3bQ7ud1bF7aLLBAMWET8YQgxaEeBJ75C8zYgM3sSIPEXFPxzhbjiF1h2?=
 =?us-ascii?Q?LNt6Fvw6e5WrX86mrScnneDRypkWEqH1syUpXuNcHlbvJ4ZJqQdDl3ooZFTj?=
 =?us-ascii?Q?e7u6YVYiq/Jy8t85WUmO7tzaDhOm/BYFesY546YsIn1XbTfYBx2q8QXAy0W6?=
 =?us-ascii?Q?GN2Nu/kYX7GB44R5Fc5miEIV66Dobrqe1NDYSyd3qVX6Z3pRpjwJ5OTWiWEY?=
 =?us-ascii?Q?X1A5Lt+LUKOPTjkTYdoaYnZtHsCk2zzE/Nv+O6Q3CZFziiaH0s5HZAYsW0gD?=
 =?us-ascii?Q?Qa4YvlToNL6FM8g0JRxTem/jxj5O4gba0fsvGik+N0NccOwlL0gGzSpCSz/V?=
 =?us-ascii?Q?c7G/37wetBo8TzO2565Ina+gcXapZemp6PAhj2z+jNwVRR87vAZZj5K+eNc9?=
 =?us-ascii?Q?QClnz27NwoCZ7q8AmsgJVgZa86KsU6hV09FbAgOlBaN5mbD5d75cS5AnXWcs?=
 =?us-ascii?Q?6/heK2MZ+H/GblJ476cTlYHakWQdI3L6BTnDIPJwHWIo8+tT2vB0BkjmztM2?=
 =?us-ascii?Q?n+2IJT1nkl+e11T5Gn7yhd86IS2gM6WBcFd2O9LqqPvtKzp0gaRhUbeNrt28?=
 =?us-ascii?Q?aJ/IukQJPQF8kkAHMh1EK8rsppcIQWIbzl6WxEPWeN8XUvhfBbkWGLFt75dp?=
 =?us-ascii?Q?b8iNfHnZ7/XwalQao2k8Bwj19K+2CEkLONqoALE7uzEbZvb0Nu7Aj0mOnamJ?=
 =?us-ascii?Q?9IV0i6anaTaf8vvqw2H4uaEpyiyxvJUFbNf9sTmyHnRMEFzf1nqzmaFAWihu?=
 =?us-ascii?Q?7G/pYBq9+7w7/gdGJApVhxmDPCTf3r2LdjmjKHFVOntGnpgt205Ar43MZIdD?=
 =?us-ascii?Q?zEGH49D0qlBR3muru2Npc0MkLhQ9YuttlQIBC2L0yf1c52WnuPyc9akv7lWv?=
 =?us-ascii?Q?pISs160wOLPT4ts+k7G/CPkL4WerPlM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Ze0i6iqsXgnEbbEZA6SyY6LY1lzEa2ndd3yQ54D7eOhSaq3ETJCSB/Q11YahNwBQ/0qfd3rp7YQWbhl+8bmpi7ccntRmCrwGBexBuyoxkLjEaJwI7rDeboI+L9eqU1VVHLM9ZA6YLdJZNrzSJWVkcsGMlzoPOhOfpguOVKmAXFNJ/Yht2tgac9GdT/h6n87yUTS7nr1WykNzYbBaH2Gc9G42OogZiuZSbbPF6IMjGVJVYMz0ME9OaUczBSMZ+vRRyi3F4vQm6MVsoF1kzWvL4NXnvf1GTeFqZrL83aJ6XAQCgseJaSxRcCwLOpOly3igjOwmjarWjrkMTTbVxuIAvk4t7qb0MyVeVn7oh+Cj2kat7SXC66+aa23tw6eEzIzMxGb31s1WNFPf2ScXHn8ImxEDQYavaSBFyx7Kbc5MQ/EYDgGWoGui4uNbPENnsSYdizQDo1hGH+LPWH4wsjl+HRLH5eRKL+sH6U90DX1dELff4t8a+uhkCsqyz7gffVoRCL2ctJN6hpFvWjbbmDN16CS/1SvlCLhqlcg9IRx5ap87WoooTXwyt0dlnRdVtHbYmAW0UNYYMgWdlKw22S01ueDZziIkxQIfbOUqBKHqP2k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de92d0b3-961e-4f23-9c1f-08de4dbd36cf
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 07:20:19.7984
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y1PwrDu6WMQ5b1RU2V0v6DlleVi5a3QgGVImfoe1TqM6tSIDP/Qv8lxFO6bPC/t23UbE1Jt0isjKqpC05ORdq2tmAcZKtRgpuGt/5RYuytE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7750
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070058
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1OSBTYWx0ZWRfX7vS2VIOHCkCF
 isvmWWnCa2RGmCo4qWjSyVxjLplw+u5eSOKD+47Cufi0KuHwiQi9gS45fkH+50wSuLJJ5BnR0VM
 mgi5Txu7Tnp2e6su/b76rdcASnok5x6xBqGlyB7MPU7QBzorwi5juu+e7Xy7jrvirWR5WLIWqt+
 g//kf4j6o/VTFVEJIZoyec7zGjEwkBZ9z/eQCnCnFBFwjSFOPyV6n/vF1Cvwv89EAmpeICf3bke
 rYT3wIhi4H/e8G030gcZONW02WQTWS9zwPHueqCby2fiVtUkHxRiPX9eX2fXIU1MPvymM40jMsI
 1CxUV/2nY/h2D4G7qoj4FfDMqR6H66h5DHAi0wAjdoTFZnP6FHlVzFcI2vmlxoRRL12hF+ai/ys
 RFLaq8HltZRVbh1pBp9tKyc7X72KU4JH09hxjmbE+uHeYUmJGo/KvL1gCAt027jIC2haIilPmtE
 jcNTetiMfHJCv2Tft9C9OY7gVmI5LtEUTbrRz4/s=
X-Proofpoint-GUID: tdRMOpxuKxkzcsI2AgCRSJ19Me9mFfSC
X-Authority-Analysis: v=2.4 cv=aLj9aL9m c=1 sm=1 tr=0 ts=695e0adc b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=bUlQXxcD_ynEEFdnt4UA:9 cc=ntf awl=host:12110
X-Proofpoint-ORIG-GUID: tdRMOpxuKxkzcsI2AgCRSJ19Me9mFfSC
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1E06C40002
X-Stat-Signature: u7c4yfy9npi6fciddoerjtophgdkhdq8
X-Rspam-User: 
X-HE-Tag: 1767770872-664464
X-HE-Meta: U2FsdGVkX1906MVIJKe2xOoMSm1sCeSl13A8bBYpYDFaPcOttS0fy3MwlGwPywgs8PiaAbIh4bE2R4sF7ZZXXjxs+ww8WWMsP8T96k2MAcC3nBQDR3bHasuQYVAj8JAWESANOWIk+7n+ZDJPvIOMaBfM40Q0Swo6mH4HmpkmvLyy4+I+Urb+VpmnvQUDjynwGBh3uvSj/4sn+fwC7ROM6y0hhIB0LAU4Jq8Qnw0U4zK1PdqjUXP+qMlvXYhvetV8oW8mZWgu0BQKOLI9F8LmoCxEYzGZcjr8jcxcZ23x7MJuTPLMIVXfi4RRQyH3UzDFfw5znoWyFKCp6lJZz6JXhXfS0HnQGflqrzdudyqYQa/+Ru1JopGYYb/pKAKVaRSAEY74zWGijtujoCh4toqBKE8b+vK7Gezy1/cUNw+mxISU0nH1uBkdT5f20caqS0APJlqJEE8HXx7e5k8VzIB/0+miKm4NoHlM0I/D3/VQRgBSGV7yYy595QTHDYP0u/1i50vk3bbb4zUN7fnbwfRmkanL0Eb/vYi4ib/898zgw34u24VPU3V79TDRxY5evapQqSNE/xu1mGH6uVSR+bBqbBMEHIzekuOpyDSAubdyjoKCq/oikBpEy5NpD+wiAIRT8sRVzLVxzmTFfZefmmxcQ+Eh2ZlvgTz8ZDGnqWA9IddpJz3gecqbpa0JtSTXqSFHZFCf7THorn4ys23aD2tl0HoZCGYtqQ3XvBgWsfvQoiowInhBo0VMedVBpEWGuqSIlCATuY+sYsBJdaRiEVagdBNUsrRTzEmX851OxCpvdoKVkn/Rxb3rlk6Cy2l2rxJj1hAHTitJkkKRh+0yGeQ5Q+hjsaaT+AjeRE/lCWVjaQYLMY52A7FHmDGpAZTkkS3Z75wvI16xedB/8QvlWTFJ1z82CotJ0DXRqAixZ6mxvvmdn/4oHzJVuDzyCg/Pp7ocEv7Ns+lsqzji+ZKIpk6
 ZLnG15a/
 0rmjFaHFv8RWSjj12FPplKwnQeq75Wm/fBhI7+anZmPjd3vHrrLPqISpA02/uaTQmc6rELeDaBfkmcHYbM3ks7spX90BxsxyxmtHf0g/9lWzzw27hQd7MrRcsUL76blkVOuzuw2OjqquveEoOAeRm7EMCTnokpBsNKN72wjT7k7sbX+FehcnPquQ+6NO22sk/SfWUimv50+RUNqBYwVyy3jk4mtSQKvmP15/rXOvQEelEbTsRJuz0fPOFSxzsM5LHKm5HFkw4ZuPI3UUR/EXvjmxpFvCYPwl5EFMGb4nzhWiin4xHmUhFfIOvPEK2sn7tYnqvfXgv+GxDKEYRWFa8dKZ6CNziCYnb779lpWMypczmW5amo/nrcmVNtJ7ndk2oSENSoOkqqfHrWAzUS0z6e5dT+NCLEuh9vYp7pfWCUdNLaWI+qa4A6zMquqjwr9DISGiJmsZJNO2PqQl6N3f5dB/DWRQ9rsQ2ZnGuKDv3wyCxLrrUYS6IiZAPgWzjuXYrOWHxqfC0ORwYuEC3aWFoOixNAYt7zVqf3wbNq7KOLvchss3LRwYmoSkev2gg1Y1hOhsHsM9gfG6OpCnanQ4x4x/bTJ0BHn5CMRBcA4kuIpGqvcKpSDjcCNdVGEl1IlvPU7T/oD2ptp9DVQYxssxp1stcpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Define clear_user_highpages() which uses the range clearing primitive,
clear_user_pages(). We can safely use this when CONFIG_HIGHMEM is
disabled and if the architecture does not have clear_user_highpage.

The first is needed to ensure that contiguous page ranges stay
contiguous which precludes intermediate maps via HIGMEM.
The second, because if the architecture has clear_user_highpage(),
it likely needs flushing magic when clearing the page, magic that
we aren't privy to.

For both of those cases, just fallback to a loop around
clear_user_highpage().

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
---
 include/linux/highmem.h | 45 ++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 44 insertions(+), 1 deletion(-)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index 019ab7d8c841..af03db851a1d 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -251,7 +251,14 @@ static inline void clear_user_pages(void *addr, unsigned long vaddr,
 #endif
 }
 
-/* when CONFIG_HIGHMEM is not set these will be plain clear/copy_page */
+/**
+ * clear_user_highpage() - clear a page to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ *
+ * With !CONFIG_HIGHMEM this (and the copy_user_highpage() below) will
+ * be plain clear_user_page() (and copy_user_page()).
+ */
 static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 {
 	void *addr = kmap_local_page(page);
@@ -260,6 +267,42 @@ static inline void clear_user_highpage(struct page *page, unsigned long vaddr)
 }
 #endif /* clear_user_highpage */
 
+/**
+ * clear_user_highpages() - clear a page range to be mapped to user space
+ * @page: start page
+ * @vaddr: start address of the user mapping
+ * @npages: number of pages
+ *
+ * Assumes that all the pages in the region (@page, +@npages) are valid
+ * so this does no exception handling.
+ */
+static inline void clear_user_highpages(struct page *page, unsigned long vaddr,
+					unsigned int npages)
+{
+
+#if defined(clear_user_highpage) || defined(CONFIG_HIGHMEM)
+	/*
+	 * An architecture defined clear_user_highpage() implies special
+	 * handling is needed.
+	 *
+	 * So we use that or, the generic variant if CONFIG_HIGHMEM is
+	 * enabled.
+	 */
+	do {
+		clear_user_highpage(page, vaddr);
+		vaddr += PAGE_SIZE;
+		page++;
+	} while (--npages);
+#else
+
+	/*
+	 * Prefer clear_user_pages() to allow for architectural optimizations
+	 * when operating on contiguous page ranges.
+	 */
+	clear_user_pages(page_address(page), vaddr, page, npages);
+#endif
+}
+
 #ifndef vma_alloc_zeroed_movable_folio
 /**
  * vma_alloc_zeroed_movable_folio - Allocate a zeroed page for a VMA.
-- 
2.31.1


