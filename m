Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D6FCCFC29F
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 20:24:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83846B0098; Fri, 21 Nov 2025 15:24:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34506B0099; Fri, 21 Nov 2025 15:24:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95E4F6B009B; Fri, 21 Nov 2025 15:24:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 713276B0098
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 15:24:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3381E140736
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:34 +0000 (UTC)
X-FDA: 84135742068.27.0C383E8
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id D33131C000E
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 20:24:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="j6roCcV/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VsZNV+Wq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763756670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5A4XZVvlhypTkioS7UOXOIryE5lsxiWEFTa+OltK3vA=;
	b=q3zN0+i59V0Dij+daIfgHzouaLiZFi/oHrKbufHr9OzshQcuz7k+zYsBL+hra9xNLzE+5N
	iquhaf+r+9/PGRh66iSTUggmd5zgcpGgyZgRKZNRcge8oU90mW0j7sRd75Z/F1CdAEKREV
	CPSi0vTR24mf+oYe8eE+tXe6O6SLVA4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763756670; a=rsa-sha256;
	cv=pass;
	b=l5pkWKz8Y+Rk7qU40QivdMJMoK8neYEMrZyt8UUQiy/mGiN46AycMQqtA9tPWHXrNAzqmi
	eNkpJn7zi0O0oWGMoIqv4HAiZ8JmIf2D96uFnxcp5fw17BA+6R0pC6pfrCmEc2+l6PR3yv
	a1/9QtugzDuyTamwSCasnZrf9RpBIwg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="j6roCcV/";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VsZNV+Wq;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ankur.a.arora@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=ankur.a.arora@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALKJpxM008282;
	Fri, 21 Nov 2025 20:24:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=5A4XZVvlhypTkioS7UOXOIryE5lsxiWEFTa+OltK3vA=; b=
	j6roCcV/O7XVCLD4b9B7owIeUnu4YnV+lzr+2Pw+js1DA/BHfUR+ALqwglRo1B2d
	GzPpQdv39DVP7iouU6Hfosz+9rU4YyownzYFeQ2J4q6uOd9/juI6ZGTDjb0RsmtV
	iJy5paj62hUOB6ci05dhPm/H7nqGcqE8AeaeCh2SfFDwctzkUe9CBzdSRUESCsmD
	qR8+P8NNjW8IF6lZ7wP3Edosf3HfIe3uYJtldM7jvjNZPceS2Kzxq7dEJtmjzvuz
	EjpAX7DDExmltpW3Ow6MAANb+4BtPx93+vqvvTB32pyweha5/mGfbLlph4GADdbg
	0imAELmBg843TtNn13sWWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aj5dtu7ub-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ALJcl0Z004333;
	Fri, 21 Nov 2025 20:24:14 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012004.outbound.protection.outlook.com [40.107.209.4])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefydufsc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Nov 2025 20:24:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wKNJvMuVLBJunSAIT6gPmEN9TSZdG0mqEIkGKcFGYHPLbrsyhGZ+8MLh8h+1fCo2pqb13a0haVwN0zgaDS+hfZXPgQh9RA8cJgJJSXvbl3ugw9nuC+3bh0orJbtbl1obcJ4FDfn6blAEhRFxFWjM1GSjlTWOQuM2cjv2KW0mNddQfIOgiqHd8AvasU6P+yJ9RyzKIEkWqVTEYwQv4kGDrBmzREliTCiEbnBpmziihc/J+opetvxIjmAkfabo9dPQBTpN2qUtkpyR+Gxf2BbA8A13ANk18Ctz9qD2KV1Jqz/pFvEe5/AMdYR+b75AB/SF3SIhMdWzJzUZ+oS6XFwQqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5A4XZVvlhypTkioS7UOXOIryE5lsxiWEFTa+OltK3vA=;
 b=FqYr2s70fILEQS45SONKE8JuWYfGOsXYAcoURCZMyzPFmCpaJOTpnasuDDyy4HT2leVa127GGanHMqh9F8WcrU9V9YMi+n7i1D2QTtnPFG3rluUUmaGaNL7Ee3gL7uF3s2elHCV5OknBPfpLqqgvvTwk0sOdxQXZbtmeBkNO73xwTjJX+BwgfHHAMBhnVPYb/BsHfqx5mvUhcDbGdkAkssaaTBgLoVNmP4bftJiBIp82eaIGhInjCZPeCeuUJnZaZRmPBUqlFZkjFqDyrQLAHXv6Ia+zKUFKETF94K6r+dWrwWhM3ggDyeYgYuwox5btaOceC6hF8P+NO8x2qwKczQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5A4XZVvlhypTkioS7UOXOIryE5lsxiWEFTa+OltK3vA=;
 b=VsZNV+Wq/fjd7kYZyS0TmZtQnZJBoB//R8rVlsok1E9JCwZSVHznzTgC8KJRjjCKkP5V3/1JT29fB5iwM2AtaVY+K8lYmNPF56IGbAm0+buo28uAAS3DstmiycmNlRGVobJBo7+02zq5kXr48l27hh2mC39darqYBkdZ/ILIeKo=
Received: from CO6PR10MB5409.namprd10.prod.outlook.com (2603:10b6:5:357::14)
 by DM4PR10MB7451.namprd10.prod.outlook.com (2603:10b6:8:18e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Fri, 21 Nov
 2025 20:24:10 +0000
Received: from CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574]) by CO6PR10MB5409.namprd10.prod.outlook.com
 ([fe80::3c92:21f3:96a:b574%4]) with mapi id 15.20.9320.021; Fri, 21 Nov 2025
 20:24:10 +0000
From: Ankur Arora <ankur.a.arora@oracle.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, mingo@redhat.com,
        mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
        tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        ankur.a.arora@oracle.com
Subject: [PATCH v9 7/7] mm: folio_zero_user: cache neighbouring pages
Date: Fri, 21 Nov 2025 12:23:52 -0800
Message-Id: <20251121202352.494700-8-ankur.a.arora@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20251121202352.494700-1-ankur.a.arora@oracle.com>
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:303:16d::26) To CO6PR10MB5409.namprd10.prod.outlook.com
 (2603:10b6:5:357::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR10MB5409:EE_|DM4PR10MB7451:EE_
X-MS-Office365-Filtering-Correlation-Id: 62248834-f5ee-4de2-457a-08de293bedb3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?y9MSfvHhJdMEqpUFSaBOmafHBK12mmQk+pG/TbESQCbVF8NiFf4yEC5kJ4AK?=
 =?us-ascii?Q?KhfTOGM0Nl4yN3YkoC6YKGJmcBzQTl4vb7ra2T//qfNBWHu4QLiVemma1hMI?=
 =?us-ascii?Q?wV/3jbwjFVj7jm/rl4QIJXdC7DYKb3dlcsFCTv7KWB4GDI/PnH0aajDCM1Yi?=
 =?us-ascii?Q?gGFTg0iOf27v/1ZEuGFEj98laXhr6MWUiTtV4dnlfyxbX09fY4avfRBBBrP1?=
 =?us-ascii?Q?CZaCql0RyxwypsY1TTqpO74dkLW5hIGeR78qLqfW72ydLQhSsVBVg8tKToVu?=
 =?us-ascii?Q?uNwemr/rNchtbQyN7a6zDyVAH2lW4SkPpBtk/g6Jl5mmf5lY87aGnCTJE9X2?=
 =?us-ascii?Q?yI9cJqm2INr5RtJNy9v2gXd/0gpM8mdtyCfT3a3qrFHKLzn+UeK4gbTHZ99C?=
 =?us-ascii?Q?pr0Mhqq4liwJn/V1I0dzZT3CwHz4kr8jlxW8LmJi55uODClMUuG3oT2BNcQU?=
 =?us-ascii?Q?Athw4or1iWoMcdUTQQUzOILq84VdtTo1q9I2yqsMzvipoOm9M2BO1LoGlj9x?=
 =?us-ascii?Q?5cwj1QlnhKkmEyO8o+gkgTpYrYUEd0+LOlR8YAeFWoQkkZnpJAwyJQqL+4bY?=
 =?us-ascii?Q?9ZjK8uKJqBS9pF45qoNHCVMMSZcMtC5tiSCq4HQbqSWDfvn56Hjqp0n6B0L7?=
 =?us-ascii?Q?QFxXF3aSO8dsTEThf1ZFQKpNgS6H4S1Sbqt135G2amatbQ7z70xAoAYcIAjN?=
 =?us-ascii?Q?nDls8jBN4zqZIT4Wn7xneuJdvP6bZGwl9sGl+GV/7vVtyS0/Yei1XcMfdkWg?=
 =?us-ascii?Q?CMOWhZDa/fOSeL8n9bS2byluOtQfiTQ6i5xnuTdXnRd1gcsGymdrNKLy1DAm?=
 =?us-ascii?Q?1yI3SX1r6mDp6p2L8dbmFmVE2lzaaEqos9JkhUgBHl0J2xG4CI1o2x57bSL4?=
 =?us-ascii?Q?xPOnCQ0wWjcTk2xDrNXn4XaHLnD5x7Djh6cvKLk0d+UOqhQQ+qvas9tt7Nuo?=
 =?us-ascii?Q?Mk8k6wzp/UxIOKep/LuGXdPckTlLQL6RBCd91wr/9jDpZlXt/pgXCRf0I1a9?=
 =?us-ascii?Q?Ib/kBphMXLcn58/dEYOg0N/pJpwB8iMuv9mtazhLiVAdr71KJ5xJPqrv/Ae7?=
 =?us-ascii?Q?GPMO4Ck64UFbY+rMI8xJvXARpN9FX2QYtuvcHOFYYawtZ+w0RADegjnVuMbU?=
 =?us-ascii?Q?1PYnJQAUKCR6//oqZT/q88ztaYsPzYGHEDc+n4HpRJKJCBCSVFVA8Hxatx/N?=
 =?us-ascii?Q?nx+HhYAB/lO7MWpc2p3feC86x8tO+YQwg3xmjn7xtyR34424etSZWE7avGhi?=
 =?us-ascii?Q?u1W6tX8u+m4RfUvTRgrtNqySGFLM8JHCHKisQxTSYR6NyuuxjmO/GtQkj6ir?=
 =?us-ascii?Q?r2RZcwjOpUlTaV5LwsoLH+M6HLI1dd5rLmHfhXdDachZIf5CizWt0jJR91FI?=
 =?us-ascii?Q?ddXiFgOeHJAgIp7Y9EWa8/58HRtH2XdJPlFP22uAaLA7CjTXNGOVHcLZpHy9?=
 =?us-ascii?Q?wFbVum5+EM2tArYj4yQ8O793e01ztYRH?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR10MB5409.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?na5JntkBIocFws7oWeU2BN/986EaHZqFoy33Tx2XarkTf/eRg6EgfImkCeCk?=
 =?us-ascii?Q?cqd1RPdikXuONRUwgTZTS/fhomvTzKgA/vIKFMIUzHQVOeypTprvG/qeFCrZ?=
 =?us-ascii?Q?brgt3TAoPtwVGsqEZMtNB5HMjc/KWtSU9gYfUz+/ryl46s4O8GxIOQ/ncCgb?=
 =?us-ascii?Q?7X/3o71xjDv4FgUNpAbTBPjcVtVkX50W+ZCYiiOi3lldQ/p4dxNIlzg0qXOy?=
 =?us-ascii?Q?F/RHAF0JBLX04vzFDCOKlJy9yrPQs7OPcNLlMFB3eWEgZcn8Ihwz5dqaEc6s?=
 =?us-ascii?Q?XYAEDfwzeJVFFIJ399eFgKXOD2dz70NHWJNocB9Xo3go5g6XdtG4+PNQ6RL0?=
 =?us-ascii?Q?BGRR1JZc+FafZsbkSGpphPUX/G/OXiS/RSf9kf3T6CFrZu1bP1mUR3vtMRL0?=
 =?us-ascii?Q?nKwdYdzgG7/4c21JRBIUfpztiwSgfzFonk6ozAMLOCNJAVbRScXctE3bTjPx?=
 =?us-ascii?Q?tSTkR69jjnTThDQ3VQsLLkxZpsvj0nZAS9UiP24IARZS+uA59hdwQahyrQ9Q?=
 =?us-ascii?Q?ZWTf5H7m7mIBifLWJyXpw9CkIAJ85r78+LCM+QlmXB4vNo/bfF/5OsjmrGrC?=
 =?us-ascii?Q?TffTQ16X3G1Wchkr6S46MnGpUjr0jHZ7p912EvTSWIVOwDENsX8LqPj/G+XI?=
 =?us-ascii?Q?uctOhkMK+sKAZjpkEoOX6VGNUwqvQg/PFLECdgbV1mMGr+zBEiSI5eZsHr4D?=
 =?us-ascii?Q?SHxzCLdMr5hXIiE95ygBNZn1EcZ4wYLw4Q8lCdnKLnWCglNy2pLer+W5Ggrw?=
 =?us-ascii?Q?/0QfanGhBreynf/YM9XNFvM8/v9iTuZjo2J8h80qNQ3q9mPlueD+0HynzQOY?=
 =?us-ascii?Q?5L7Bx7Ym8U/4VXTrPv4bz7YIf6oLA9PNX3D5xHKjf3+z3l2tVEdydQ4jM1vO?=
 =?us-ascii?Q?0FlogIyo8I8F1HJLaNn8DJTGDTJ3cEKCw4iOfoXRvQqs1zYswOuFiBB4XB3/?=
 =?us-ascii?Q?MYuXxbvR5Usp00dEgGsEp8+KNp2Lr9+Xb2bHLZlye9fUsEvZ7ikJgdkYLr1L?=
 =?us-ascii?Q?u+u+hk4ORywPgqNw7LRxemoI40kLCq/4DKaOyTnp5FQA7rkORIZ/QzhSm0nf?=
 =?us-ascii?Q?USvYKkDVQTHKxc7CVAF+Vb+fIyGtH7b8QGiruYtd6ecZDB6WU7XuYBJMWXCV?=
 =?us-ascii?Q?l9otVPN7jLANkFUp/dzDFoDMML4Vmxx9uoNnXC3UpDKm+M/ByDvQRzItyWeG?=
 =?us-ascii?Q?KNV687hkmsG1zrXlT8zfBtzwrXLY2BgRn7dPPrvcFZMEQkFH5jZ0K3GAm2KE?=
 =?us-ascii?Q?tIvlIys8HSxw9eOr4bm9T5gPIQUERoPztknd2j3RaP4/VX8e5Ul2muttGQLA?=
 =?us-ascii?Q?8b3rIQW2T4k36xwHqslxJzKuJi7CuVEn2mqyf1UZ9akMCKA4YsBQ4/Q2eWw4?=
 =?us-ascii?Q?1fuBVtVaVKmvLYSl8dp9XKiW0hVHnvfMs1Ch0+owBc48vE9nXEVb6c0+4iV1?=
 =?us-ascii?Q?9fDIgPeXyeY4+hQJoGUgeppIW/YwH9KgK8dfq697i0eosPrJ8S4NecPQ4jZT?=
 =?us-ascii?Q?bRiDzSfw6cRbk+vyV5McSsy6Jw6rAfkn31fQIaSuYL/HVdrMG+l07nvdvMma?=
 =?us-ascii?Q?7nt4Rbjn98bgpoQ8iNiqSQerd6r0HrCpdym2ApGkdTKRZ3A7Qj2QeXAVWOSF?=
 =?us-ascii?Q?bw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	sWYIxpnKQntqRV5ciIBEREkPxmU4AN+5+AnDSTKY9aElsog9qfiJtohGzMS0ZVgzwqt9w8V4cxvrM62m7F4QVv12yAkedMC9zUAMc4Je0Ts1/d3CyNE7DYnZoeui0o/lIdhZV6QA0w543spPJp4MRHxs67b0tvKCXmQuu/p5XbvhaqoF0RdmZBs9QrbKWBt6LGsVWcaRtD9eZHcWkQ5oilwA4tTqb+RlDfSMHlyWmiiZcDWQoD2k4WuepS6amDT7J/IFn+1qFJNeNAf6vYk2wClkhMASvZnoGyY5O66fCDG3SdSisDN1uaT6rcWGBVTcjPA4U0zWIpvoe2pyDrIC7yOpDlXd5zbbw45DN68yVaAggF83W44eKmLL53V8W6dZ1tXlR6O2qLMaaNvTSImd20z6ANB/oeuvz2pFqCgTuNCyqNtOp3lFlCUa+2hjEmzEBouRI54OVvflr7XklFZCWJc5libA/nXs4sPt3r+QVixdl+l6lVD5+Hvfkx0uB0HKWhgMqsg9oe5cbih4tTd2SsWhZ+oZga++d5GBPI9sTXtp2PxMkfwmljeYDH3zRuMRfp4I0XnJwwhK/qFurKXZBb/nfKyxYQT1Ajflw5GTn14=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62248834-f5ee-4de2-457a-08de293bedb3
X-MS-Exchange-CrossTenant-AuthSource: CO6PR10MB5409.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2025 20:24:10.2723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IGNaiP+NG3IdbWJ5C06GiXJpc08KayA05sLxX3nIdTxwP9ll8Xws72k0jsB3Z7rR6ACCM9a9XQc2XPD6gmNxzfP0VM3FHQUSn7JIuh+7mrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7451
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-21_06,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 malwarescore=0 mlxscore=0 bulkscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511210155
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIwMDA5OSBTYWx0ZWRfX+eCVFNg9Lycb
 rnRXRDFwddnU3GGShVKKac55bb6hZGkPmAKIuQpXEEuPRKw1kgCY+XB3JeiytPxO9HghqNNKIac
 B+Cszj7pmSGDrrz6nOj4lAGaUAQoC6s9CJLX91Eqr39prnBMYSDgKYJZsxBQlH/e0IY0aQasWmQ
 yfieTTbc1SEsaQsxFikHeLeSbZcDqc6fm6j+jdgGAQy6aJqJ1hbzrsliUND0Tb0swdtpnkckfsh
 MxGaNrLZT5XwdG+m+pODyT5kNI8lJGvGhBQnjzafbAzVixDwcaEwFcXipL/vZPg1amec/7Z5lRV
 nkFCLeYrivJmrQFcwK3k1jq8vRMOjE4Ya2t6t7a7WBugv7YKauEtdRoF4FG2Vjc4lqZ9QAMuL41
 c2/MqG/561qzntsAJ8xNej1curfmVA==
X-Authority-Analysis: v=2.4 cv=Dckaa/tW c=1 sm=1 tr=0 ts=6920ca6f cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8 a=zd2uoN0lAAAA:8
 a=EaYD0BI2-7KjZKhOlH0A:9
X-Proofpoint-GUID: qqkKbyJ4bWN2Q1ggYJf4_YhdhB5kPSaB
X-Proofpoint-ORIG-GUID: qqkKbyJ4bWN2Q1ggYJf4_YhdhB5kPSaB
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: D33131C000E
X-Stat-Signature: aypnwhc4j835oxkcibqeisp97yye5shn
X-HE-Tag: 1763756670-998701
X-HE-Meta: U2FsdGVkX1/dNmjHpJx15BESXYkqyD6Xwu/2tCGh9RdX9hQc9r4rxM8UYs/GK7pdDrOA9opaGZ9h9TySx3sg0wt0F9lHg77yagRPbIaYbiUUieFo43wLO+V+GubVJfcFFIxfVlpNN2RY6hDsEBQDxJkB7RmehUIu75Cr9spuTa58byAnB0GGfcIKKA8z27h2ZhkYkfs4KUuNIO2FrLot/S0P1aakilSmPWaWmyecRL0FU4RyA7bMLvnkDfxUDLL7MZgGFgB3Z13hRPvYToQUtNRQvdCHK2oZT+/95va0uRLUPztLP8G+XZL8aD8ymSYI6mv7T+HOLoZknB5ZF98HIFEN6fBIkPx5g3JOulTFIkOPXd5xgRxxCE+oQbA145FEo5eGTlwkDrbulNA7KkctLmqBDJaj2lsxa5WEZcxSn0Jp5FrDPxLAXpRwqxsB7rBQ1tBlHg0VcZOX1+3I422K5Wvp+4oNRky9IYoJz9Ai4HuuxIZNC5XoQWJaSEdnGjMShPhFoZr3wY8gGTeSQo34FLZYG3wmUczGxjPSA2xUNmEz9ovEPnVSWU+0CucDoeMxO/Pr2Z6+qWUr22B3h1eDEPPse5eXaBnQrc4xfvYbGROEms7SKjgMeQk9LAxdqwLJFl7l5ls3Zyivbb1LU0+gUwdkfUZsowgulQEbTkenFaI4sQo6tEvlLvAZpxSkX60DSnAJD4msdY/YwFTyhkJuQOLHES1T98S4VDo6A521gfG01OfC0A+ZOJgdek7udFQ3dxwesxOYzubXJuDsUeFZQ83Kb8dS4ZU+8yNnqUGsmlt1RrHkb1jSu6MVguM7yr3gkPto+debvvqiGe8lSMZuLsb/Y80JTG2YSiDXqoz3VyEj10RhgPrL+knVvZ4VHkqOWrCLS+TziS8MshtORVhjfY0fsO16UCwFz65gkHlW753IKRqvhSJaIMCR1+LepIW5lZvUFWH0fO0OYL0SCBq
 nHjfdqGw
 owu3xZPgzoJLzrk3tYAcZHyv9pD4NQ4yJYCjebjD9PQi0irGg1j/fYXFH3ikSdcRug2dEhhc7rjk86+6I9WFrujq97Xg83ig8iN7Al8FfcWOLxc3+5fwVaVYEJrb3L4YbPxBoCthABjpmLI+hfruTb6WjFCeUMyYd4nIIxI+lXhf3fV/iztvwCQ5PbMAyy2Egi3n0J90fYASqpyX4/Y9lLh7aYlwQGmRW7VKMc6UqvNHTvp1CJEJsJLGfITcPnF8dtm9XRd1d/eaiWcasWeGPxM8/o9n6Lj8X4qZKpVxNrlOKNBPpiKOqC5Op6iyj5+hHstfiJAfhWSt5A61l5TKixiM6fZdCw8hpsTKOKMuzYp0my4Sliadh+HSGD3amW5HpZX4DW4S7l+E5jsraU1h30Ozueyeb1qQBouXmNCZPAiRj3Z0pMYZvRUBuhxkDDKkf+LQD6G4O9brKqxXk5xdA3T71v18urokXeVRz7nk2srLy3dNT+ktopXqH3XdJXxK6UH+pwcYdT7pqYqnc/etmBGrLseV7NFSXtQmZ/nvIEyu3Jv4dFYwmaa2ZwqVaUA/1lWdct9omuItvWJI6sCnC0RkpTldhH5BinxJ1lxKVotYTi0RRLSP8qipbYuhRkpq1we61GkK2wESIStA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_zero_user() does straight zeroing without caring about
temporal locality for caches.

This replaced commit c6ddfb6c5890 ("mm, clear_huge_page: move order
algorithm into a separate function") where we cleared a page at a
time converging to the faulting page from the left and the right.

To retain limited temporal locality, split the clearing in three
parts: the faulting page and its immediate neighbourhood, and, the
remaining regions on the left and the right. The local neighbourhood
will be cleared last.
Do this only when zeroing small folios (< MAX_ORDER_NR_PAGES) since
there isn't much expectation of cache locality for large folios.

Performance
===

AMD Genoa (EPYC 9J14, cpus=2 sockets * 96 cores * 2 threads,
  memory=2.2 TB, L1d= 16K/thread, L2=512K/thread, L3=2MB/thread)

anon-w-seq (vm-scalability):
                            stime                  utime

  page-at-a-time      1654.63 ( +- 3.84% )     811.00 ( +- 3.84% )
  contiguous clearing 1602.86 ( +- 3.00% )     970.75 ( +- 4.68% )
  neighbourhood-last  1630.32 ( +- 2.73% )     886.37 ( +- 5.19% )

Both stime and utime respond in expected ways. stime drops for both
contiguous clearing (-3.14%) and neighbourhood-last (-1.46%)
approaches. However, utime increases for both contiguous clearing
(+19.7%) and neighbourhood-last (+9.28%).

In part this is because anon-w-seq runs with 384 processes zeroing
anonymously mapped memory which they then access sequentially. As
such this is likely an uncommon pattern where the memory bandwidth
is saturated while also being cache limited because we access the
entire region.

Kernel make workload (make -j 12 bzImage):

                            stime                  utime

  page-at-a-time       138.16 ( +- 0.31% )    1015.11 ( +- 0.05% )
  contiguous clearing  133.42 ( +- 0.90% )    1013.49 ( +- 0.05% )
  neighbourhood-last   131.20 ( +- 0.76% )    1011.36 ( +- 0.07% )

For make the utime stays relatively flat with an up to 4.9% improvement
in the stime.

Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
---
 mm/memory.c | 44 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5e78af316647..05bc9fc7289d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7193,13 +7193,53 @@ static void clear_contig_highpages(struct page *page, unsigned long addr,
  * @addr_hint: The address accessed by the user or the base address.
  *
  * Uses architectural support to clear page ranges.
+ *
+ * Clearing of small folios (< MAX_ORDER_NR_PAGES) is split in three parts:
+ * pages in the immediate locality of the faulting page, and its left, right
+ * regions; the local neighbourhood is cleared last in order to keep cache
+ * lines of the faulting region hot.
+ *
+ * For larger folios we assume that there is no expectation of cache locality
+ * and just do a straight zero.
  */
 void folio_zero_user(struct folio *folio, unsigned long addr_hint)
 {
 	unsigned long base_addr = ALIGN_DOWN(addr_hint, folio_size(folio));
+	const long fault_idx = (addr_hint - base_addr) / PAGE_SIZE;
+	const struct range pg = DEFINE_RANGE(0, folio_nr_pages(folio) - 1);
+	const int width = 2; /* number of pages cleared last on either side */
+	struct range r[3];
+	int i;
 
-	clear_contig_highpages(folio_page(folio, 0),
-				base_addr, folio_nr_pages(folio));
+	if (folio_nr_pages(folio) > MAX_ORDER_NR_PAGES) {
+		clear_contig_highpages(folio_page(folio, 0),
+				       base_addr, folio_nr_pages(folio));
+		return;
+	}
+
+	/*
+	 * Faulting page and its immediate neighbourhood. Cleared at the end to
+	 * ensure it sticks around in the cache.
+	 */
+	r[2] = DEFINE_RANGE(clamp_t(s64, fault_idx - width, pg.start, pg.end),
+			    clamp_t(s64, fault_idx + width, pg.start, pg.end));
+
+	/* Region to the left of the fault */
+	r[1] = DEFINE_RANGE(pg.start,
+			    clamp_t(s64, r[2].start-1, pg.start-1, r[2].start));
+
+	/* Region to the right of the fault: always valid for the common fault_idx=0 case. */
+	r[0] = DEFINE_RANGE(clamp_t(s64, r[2].end+1, r[2].end, pg.end+1),
+			    pg.end);
+
+	for (i = 0; i <= 2; i++) {
+		unsigned int npages = range_len(&r[i]);
+		struct page *page = folio_page(folio, r[i].start);
+		unsigned long addr = base_addr + folio_page_idx(folio, page) * PAGE_SIZE;
+
+		if (npages > 0)
+			clear_contig_highpages(page, addr, npages);
+	}
 }
 
 static int copy_user_gigantic_page(struct folio *dst, struct folio *src,
-- 
2.31.1


