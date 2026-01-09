Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E47ED1A63C
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 14:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973A56B0088; Fri,  9 Jan 2026 09:44:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FA56B0089; Fri,  9 Jan 2026 09:44:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 816DB6B008A; Fri,  9 Jan 2026 09:44:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AEE46B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:44:38 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFCADC30AC
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:44:37 +0000 (UTC)
X-FDA: 84312696594.04.FEB2721
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8241B40006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 14:44:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=exccl8dy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvNcBURs;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767969874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FnwA43lx7ZflL8pGtXos8ETAOk3AY4lGS6C8xPR6Kkw=;
	b=3dkHhURFhRmirBFFVTWLC4hNfoo33/2FpEr5GY6tB+2neeC172yhnToMlSV0GSjv6KiHRI
	DeIbCiy6+wZcIkJMZJWlGEP8ZJjTw8oxRIabMu/Xg0sUbYk0VtvuKz9zyhi+/GbjTYvKou
	9QrfWdUVQn/vveMDWFF+6bFq6r+rqhU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=exccl8dy;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wvNcBURs;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767969874; a=rsa-sha256;
	cv=pass;
	b=NrJrzs7O1hd0kwK89oOc2k+sVx0/OSzgjZl2B1zBssR1UvGaMA9DzWmOrQXRiJsgfR/+3Y
	di7bgDqYaKJrAMNwGiVyxOwS5cd5vhfVQ8kwq2Fp9VJva3MH5oZWwKb6kLtG6GzoElikbQ
	rjb5qi/GxakixSRo2L+TExvWKqsFvaY=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 609E5pXT2794656;
	Fri, 9 Jan 2026 14:44:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FnwA43lx7ZflL8pGtX
	os8ETAOk3AY4lGS6C8xPR6Kkw=; b=exccl8dyeDoloOPrsMPujzRLXr5f2oV0rw
	LLTo/RkGtxs0H42HxSS+EOylHDFyiY//rliXJ1A+FNCrrEpkn4hO6rlutaWQIsE3
	2WUT8MRc7LYhkpMtmOEFky0gewSS3NhgVxXLhaipSoR2D1siFL6FyvbP506yJjj0
	e4GXV0HWkRI0Jx/y18mPupN0cxk78DFjPfclx1NWInEuS+H4i7YlOHJHhyFWXkOT
	D3Q3Nee/4JMPdchKtK0f5lTWzxKud7zNckUMgbpn4iAzupjNp11lv6X6HB0Lt3Xk
	g6joE5AefhA+WNk8SU1EkZMeaRCumoeAWQVEr1UtX0zx9Avx60SQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bk34pr28v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:44:24 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 609EOpf8033891;
	Fri, 9 Jan 2026 14:44:22 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012019.outbound.protection.outlook.com [52.101.48.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjcdy1p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 09 Jan 2026 14:44:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ljGmNOWxvUisvIHbxapyEkPdMBZZszg4wR9sbtPakb2S0DO5/4WB0KFZm3Pd0a1diVe0uRBbBnfbVf8NqseweaiPWlyBs9sQmHk7Hji4QFM80DeD/YGS5Opk1+M0Xx8PIzUJ/8MhqeZHAZZ/L94BUlG7BZQruuXfksAhU44BDU3aJSphrlh0yOb7DblvL9SYauuNwpo4w573NiNWXvEA9qKU0tBzr+qL+kZQjPeoO597oR2bprqtoWfCTv2Pq2Q4qsdJw/lx8bN/HQnKn1WqdDDLTUGV7Htr9IJsD9RlIyTTq7VdmT0GK/M+R+2j0K9U7ZHyU9DxkPCW4fATCe+9Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FnwA43lx7ZflL8pGtXos8ETAOk3AY4lGS6C8xPR6Kkw=;
 b=ExFfSzSP2jxKEdPjs7QwWGso95gwmLagSFWv82DF1erNuwQMApXsY1zIfAs45gsAYeO71+raMYHGO7IiEyka5SXkcDZvSlAzO/HzAdvn5jMbo1/3ejkukJyReTEuWFAQuGcILVJeqsF9ifobdklYFcpDZ+ToSyljMH7+eDXpKY0M9rQtXsd5aXYFquRlz9zsuhyQalPJ0tSJqOdboF16bWgYKP7fF01Oh2PQNaUCNDaRh0+3FvkkVZ3jXFRwh09Aa8T+eKAL1l+GqVYyL99u3pLZs09NIlW0HjeNofJmtmpUqE6gzhSRCL2GC37Eq2aS9O7NtZ+x+SVWRktbSdeLOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FnwA43lx7ZflL8pGtXos8ETAOk3AY4lGS6C8xPR6Kkw=;
 b=wvNcBURsxZQQw6lkV43UDjsmdiJ/4AkXL9P46x7+XlRo47eIMHGNen740Ly4uj5581YWrkeIXqS43f0PwuSY9DBnDE4MOrR8I3H/g6ol6jbP50gchCCzCjT7WTKvBy/qbKgLTKckJ9sScSjI9YcKgfb7s8P+Dmf8APQTwzw+/bY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB7217.namprd10.prod.outlook.com (2603:10b6:930:71::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Fri, 9 Jan
 2026 14:44:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.004; Fri, 9 Jan 2026
 14:44:17 +0000
Date: Fri, 9 Jan 2026 14:44:20 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
        Jann Horn <jannh@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] migrate: Replace RMP_ flags with TTU_ flags
Message-ID: <4b5b29ec-0629-4141-8022-8304e990bc64@lucifer.local>
References: <20260109041345.3863089-1-willy@infradead.org>
 <20260109041345.3863089-3-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109041345.3863089-3-willy@infradead.org>
X-ClientProxiedBy: LO4P265CA0212.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: f2c82ad6-c42e-4e98-1a82-08de4f8d90d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ML86h8JclSqqB6fCvsVjgdt2FkaP48IHyhfmt/RvhuqdFb/EFk0RUIwydb/B?=
 =?us-ascii?Q?GAGBp+k+LY1gg+lJTnw3gMYu0cOo9j63jkf6ptNr/IgMGd/UFHTZkJiJusIN?=
 =?us-ascii?Q?XMP/gqsl88o+v7PojjPW9bj6OjCmfgwpFjtbHuS8NmWokjgKaUQg+FAJX2hq?=
 =?us-ascii?Q?ZpWFjylOGm5l6jJyzttvHcnZdGK9rO7EdYqsYwFOw2Wb3RD5OWGhBey/1kN9?=
 =?us-ascii?Q?JVNtLPy7MEq4g1rZJqb2dav/OtEnvi3VEE03JZjVRFSj2tVLlpGJ6TLKgony?=
 =?us-ascii?Q?ZkdHG9Z7Yien6I5hAWOXDQFACV7biMY46cbqDXGtyY10xcLSFd5Z/ymREGHC?=
 =?us-ascii?Q?3rI7+ZEgrH1PREwlxgKKLYMGYzmp52ZJogabL9SOi0uy9WELKqb+g1fvWFeK?=
 =?us-ascii?Q?Qtl10AXjLUUgpRhxF33IVlSQ7lewmcIH9rr6NaDqUg+dH7EydvJ23k9Y1xrq?=
 =?us-ascii?Q?ZOUAWPJJUNVO6E1WMbUVs8NO1uez1TfeCEcNj+eBC5mU8tHiw/r7PgC9eqee?=
 =?us-ascii?Q?dRk1rN8Bq/nPhoTzTYa+3ArlRbSGj45kxwW79dpVtPCtryoq0blcMr3qGrKq?=
 =?us-ascii?Q?r3xzWcyP28n3eDQvislgevlUQ43pCQgXpvaP7Sar/j+xp+V7FJOnfshvBphM?=
 =?us-ascii?Q?l1xW5nsUxQTazD/84OShCaeEJ+mgfNIHplBL+Wj3V0V6ssyA89JJOQSTqLSw?=
 =?us-ascii?Q?Iy1QxrjnTheRUTLi17rGelbXubC/W0y2lE/lzlAR4VJm2NVKqdekod8PFwmU?=
 =?us-ascii?Q?BwtPGqgn8Zl/EB3wtLQuL/Ym8r53YB9hfBt2ppjuEPeRrlIXCXnlpsa1mRx5?=
 =?us-ascii?Q?KJLhGRuAo//3mIdq/WEiJWy9KhpkyYQv28wpCwxpj95OUDlXhplS10gE+unk?=
 =?us-ascii?Q?TlV0VXvKr77++BEw4s83CbLrhunq1gArj1tkpyRaETovfSh1MonKXEOulUnG?=
 =?us-ascii?Q?uWJYvB1wZEgssl6gssVNg87vOtDwgQLrxwZRwTcr21CR7z5ZfnqQEehdNVie?=
 =?us-ascii?Q?mHoB1Pot/umAlz8AF4J2Y4YFLvZldVjjprZy2bQcJEjvg9T6l/0WERa3wWqu?=
 =?us-ascii?Q?ut1l+wbrS0T0Iwp0X0dfMEkoKHrmcXpIoaOq3N+62Sgrdukt1Bas78u8vZ8x?=
 =?us-ascii?Q?f68jjSpRNvTs3r7jvt3cMT85iY2Eh3WNNx/0ojN/lsNErpLbI+TIKWXJMk35?=
 =?us-ascii?Q?wuUUKwvLXG1UDABCmNVP/Bg0nVxFtIBmG1FAB8jP6iNH1JCI+DZnwd8VWLPu?=
 =?us-ascii?Q?8DkzYaY3Ws42MPpou4/kjmibwJWi8xFbtoJoqy77yA9IMiKIVwz5nfd5+Ad3?=
 =?us-ascii?Q?RIw7DGIbu/lyVZNwgS0ZYYxwdVROoUiJDC1UH69ste9ZBbp/V33nG4jcise9?=
 =?us-ascii?Q?NAB0bYhgoCqc1zr6AvnHCsmBqKj8aWPqAeqdYeDecySoSnwGM8oGLnx9W8Sw?=
 =?us-ascii?Q?yH16HWdZzVqyZYcSbSbeuFeEPFk17f3v?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KPMh2IauW6sxY8zw0LH8zpwVl9r9Q5pAf/3/+KVQ+AgQdyQKr4dv3+HEgIBj?=
 =?us-ascii?Q?nKFMgdMK5NfX5g9YTJxlh1ra/qrV0vb2sirtTo5WcW/gzDh/oumvHsbqFKaB?=
 =?us-ascii?Q?aIkR+NUBkjRYkZ1E+51Naxiv+PdKVdJk44QXygsCcCkiS7T2dDeoK4MxYHWd?=
 =?us-ascii?Q?yBKyI5i3zPwuHDIvfIJG1NIlkXEKwY82JDMZDXZjpWRXHGzDoBzQdNXYRa1L?=
 =?us-ascii?Q?ckC9Ki+XbcnV05gcDmlHLQ+fD808gE5ZK1w3VP/QMd+b3+91S5vXbA00pwy8?=
 =?us-ascii?Q?/Ht8JpBZyQbtcadWTzrXJQT8sQOQapBaATN6V+sUXkKJuHd123QiMpMTibPL?=
 =?us-ascii?Q?ffaqU/aMLv5ymjUV7inU3VENOOZ/TpZ2I3CWC/c8LTl6aS2B9AIVWJpV++jK?=
 =?us-ascii?Q?MJPJ1fUkLJRl153+zbYhTu6H7SSw0Q3jXcshV6Kcc95frsOjuw3iTvXTyY0t?=
 =?us-ascii?Q?docnyyhgVHTobz09XiN89GHB7uitTEJIvQ5hkcvxiRBesWxnW2YkdIoYKBVl?=
 =?us-ascii?Q?TubaNGTX+S/c6L4BADRXctb8XtdI+6jgz6sigC2TFaiPB68M0X0IPS85g1iM?=
 =?us-ascii?Q?6fTO8MkZg8Q1eBcfQoerdHFI5VXXgHBaQMY1Iwdg9JI3+rSLGHal8laq4LXN?=
 =?us-ascii?Q?tvBqNHE+8hLcpGp6TCD/0LvTFI5Ymrh2InR4F/pswBWnerlaJLYeRRuExCUB?=
 =?us-ascii?Q?MICHcbkp/Mdh/Zi1MYXgHzP796rMj5qTHnu+Kpus86zn17rhryYSwDipXO9c?=
 =?us-ascii?Q?LhDyT3UL5peMVtoMHvrl9uq2uo24f+fclzfi8SdTwyzMgco5wcKVpxUKvRt4?=
 =?us-ascii?Q?D7wAqhDfuLPO+JgBbCNOJfReV2AlN++Cm5gT/tc+YzIpd4eHDQjayaiuBecR?=
 =?us-ascii?Q?nw5dznVr5lIbTDdvYxPXawtH0WPrzjraxQBLr0NgnGxhNAdgDXho/yqaO+g7?=
 =?us-ascii?Q?x5Xaseo5Z4pkoOf7sFvniNfKHAi98YdQAHimIxbgLH2ZFiILoXY/S+7eQgxs?=
 =?us-ascii?Q?LFO8ANfL9/30TNlWhw+LjT5hkxXM28Ux/VMdTZW4RkL+vLikv2Mop3Kd7Url?=
 =?us-ascii?Q?9dlFFQMI/puGN1yzFanBBXe+On9yKUJhLjTQbOkOS7Cbm1DIqAxdOZFmgJPv?=
 =?us-ascii?Q?XUIinoiFjZZ5xOdvYatNdH/XSyMkfMUArMHWArXGxTfR7ByAZzNoIELQHlS2?=
 =?us-ascii?Q?KcGP2uiSM+j8A3QJUyZ7a8PsxrVt8x23c7AysptlullV2H62a90+FG0ZP4+y?=
 =?us-ascii?Q?UnYi6keu/8v5P7xhcodKT+p834GNXLS1brVDWfHk92yU0vyNXPJhqGlX+o1N?=
 =?us-ascii?Q?P/XZYsPzLKh3IvvLzfWNjiqRBhoVEutrRvbAuM75Lb+t8x53LhQ6xXbXV149?=
 =?us-ascii?Q?cDz8IWzY1PJ8HYshElKC1UbjzezYCwQJKdvs/HdoOHINRomT0FqIZJXh2WKg?=
 =?us-ascii?Q?VwmFnqjH47oHtwuHPYoobPMgz5EI0O+oH01qrn89CEVVZAKG1esfpxYTHuJ2?=
 =?us-ascii?Q?PFmoroXLCwUJPg0E4sKdakCP3nd8bDJ20ztkSe+plr9R9y8WUBY5AbqdPTv8?=
 =?us-ascii?Q?xz38JR2ML0PbV/+/VwVkuDDoov8bvHXQ2RRy5NDOMT84wzrqQnd5Uj/hBabU?=
 =?us-ascii?Q?6zi7J0zMmLvFirUgObYS0GRSux98aUb/UVanX5jTz1enDGF2V2F16uVgAqE5?=
 =?us-ascii?Q?+Efrw4JmRUyS++zygrLql8WeNdh72D4KKvWdeXTaeqxPJ3hHQtB27hKtyI13?=
 =?us-ascii?Q?COCzKLAbfKl2nMApOyNbplIITpc1MVE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iEFdy8fPrkLi+Ep4EmFVARqWShAx56U12unWTxi72MlnnxVfq6sjbO3bG7JqP16QDhPXYels4+yBiWWCB5rHLusiG5MaoIcxscej/nSGm8twDU8O021xX8SS2Kmy59zyK3gS2j4svoG1Iff4OZaPf9cga2Z03Fi9UgdG47pFDWCuq8vqnzybxUdKyPZ/5hQiKVgFYECxxPv8TQTmm8ZewHNSmlyvMTDcA3q5nDoqoYSqbfgZKGq3CiC20jUbYsUeUPiBsTLKmxhlHDEmF0n0uj7Of2mTcqtLlZkiGRCJxkdlIBIudt0kF5yGVkcgzBgY8bqWbZTD2LQkbo/X3R6Y1zFAnvdrJOr6n1VlWmMNu2cb/iNkBc0rep5zVaGMy3NmU5pPtCB+XfLEYNTOlmBUk/lka2MV+Ic8LrrYDQ/GVnSJS1xZGue8qRuvzdpu2tcPD+Cu7xs1x2Twg4auKSRCZLHaPRSCIV/SZfvG7xsnhVdVBAU6k3T5eHtNVmHohZvlbzI+ESdDaAkB03DGqZEy8oc33MZaTjy3wEOjEgOToSQxZfAINXF9gq2yCo88yghdX8G3tUE58v8dRP9oNoAHK25QSw4/N2z4E02t5MbqwSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2c82ad6-c42e-4e98-1a82-08de4f8d90d2
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jan 2026 14:44:17.4071
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cldwVdluXyRnoB4OwaxTGSPCwQ+DP+gDOWTLHyo1vWwiEmeSWItKrirZgY/oh0pdg5dfoIuRhq88/s8I51fFbSkEO756YaJob1vlDoERWAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7217
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-09_04,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=847 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601090110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA5MDEwOSBTYWx0ZWRfX79MgwDsXhfU0
 vNQqRaozH8eaLrEODdbWsbKi+ENSM7Sahjvlz2uYPD2ALiz89abC/UNnSyYzj3FtHWHRRN6Z0co
 hExKF5kjoDBkpbgEgujl3ZLc/CAa7Xx/XQTpwjjx1OIXgA2cFVA+6EufwGiGE4waGU/yFcPm3Xf
 PNqlZtUbLdCKAW7Labdib+ReR42M+HuVD1yAN5q0fhmatxV5ZDaQvS+AvVHHdtJyCMeOyaypB07
 mfZmVPWdKXWxkH/TxLAXXl1hQ3DD4iJ4c47wjHg7RFtyi+RIr3OY+bP8FfD+Ug32kv003maGRA4
 w9ZMAQ96d2mtQnmhXnZs1NJzHCCO/3NV5Bw8eSmvFVPw0yXY39+bPxrBDtYujYfQj9oK9yg0eHU
 PPBnbx99OMtoqVLs8t0GpVWaPOzREmWhsdUkOkfuKGdgOlgs9+nqtev35PCT+oHSVMFGprvheLk
 U1ehnUQqDLCeFZ6XNVw==
X-Authority-Analysis: v=2.4 cv=RIa+3oi+ c=1 sm=1 tr=0 ts=69611448 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=ajp99gycuL4MihPIcn8A:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-ORIG-GUID: _NglLDhAoWpQZ1k-PhJzZemDwfr_pCb_
X-Proofpoint-GUID: _NglLDhAoWpQZ1k-PhJzZemDwfr_pCb_
X-Stat-Signature: wf9tgh191xxupjk9py1p1rt8sb95u4yj
X-Rspamd-Queue-Id: 8241B40006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767969874-259694
X-HE-Meta: U2FsdGVkX1+0q1jBJn3y+Ex3qOeK0s1APV28u0Lig9K3FYDRwFIe5jKonhnjRkfa0cmn85XIwVKAghUSCKWg9ZaRf5PKmDeVQjlOtWbp26OdJkYIRdGqGCNcChvGV1THG/yG+pd6VVHchAoW8Qx0ksUfdM0bCkTC5UfJrg0psxsvkvmPB+8yutvj2zedvb7LDJTCvKH0sZaotgQiIvEzzTZVwhtGWVCaO9OKvO/ryQx7xm1OX9QpyvbNQwXOJ1jvg8B9tqz38GjfaWTdUrQcMcLoDJegd7OzMkmw/FkmNRV6vLxhWorYqng+NWw+hNjfdcCKCyCM0X9I13u9xOOqAgSxs4flrRpDbrPvp7nE/4FqNkhsrj4xjkDbeKVxmCfFUpRKhyJZ9aeVS2LMVb2bf9TWxYYVhyYpGDCbMO+r11sOJO3WOep1DcDB02I1Loh11Mq4OiCI4CKfUpvO/xM5O0b4OJVrzndrqNRr5vwPMWbWw7Sca1pYRf8njbUc/Vmwn7cDRKpvfnKFL8mVQZnhFNVMfHa7pY0+55zPT2kLqUV/F6EWmzKxmUYCWj7xElhXtbaLVxY2hqA5D5qmtWmVnaurFHvmZAhxV+cDC5h0C9rurYbGdb0KXCIvXh9Xxxxcpts3guL6iDeWEknUTmc4dkAk0knPaOYGxzJRh2B0yQzihuXk4eXdTigrywj+Ag1YhH7iYJ9XFf9N1fVQi7EjpXeEAysrCIDtl9SHfyk6qD9W7ay06r/6iQy6txJRXkrsKeHOn3OQTN4Mb1WVTO+V48Pvz/4uVnTcNxOl0rnZqdUf4b0LPY3CgAFCYqenrYm6WhYw6r4A9+ja2/XV0JcES5iyKG/sbtFSZhCokz3b6K/cEFjwkKgTHh4pTRs/jaRIWYIWMIFBc5qbRNAt7Tj5Ilxt6YVd114Th21ZuqWdSpdX/gXr79SNIG+qCKYzDnaDffgSYl/5Krynlp9r5yS
 yqbN7Lj8
 W5kxQRZIkfg9VQnHDN9neHDq/F02UuhiiiLM5hBhMkmxmZfb+GbE5zbj1pWtyFNO39Q0Um3jbXCBDcPjnKq8agUsXJa0TbXX2ENiot18VzS+ci8x0sUIwz8/x9oh9OnncXdYj62RYk6KS63YcYFuHdCsRN6oD3/dQPX/BChG86Swue9F1d2Kb9ibbyZSLVaBOhMzOBPNgxVWfOfh75394UwnMyHW1am16WvMm5qYQC0+Tn9yCBfbP/073fEr6g5n5h9OXxZCO2F3BVfp/BX/sffaHTX+k+TWmElAAjdwpvH8qxSu4pBw0R0mdGABTMftcN7uDvOKfymMBxwRkWjCVPX3uQZAJHr35Wuk3NKsVHRY3fldoAqockX3Z2WcobqqiiFiKcV8dpqZaO/PEJGqRnrR4QOBHV58f4PkHRtz4yCJOZQ1oPW1AknQ1A95C1UZBcQbRa8mCSWsnGss90rvrZqjVQocC0vqcL1t3c1orkH+3xMrkIpcR57ufMsW514HU9UOMNyh0DMcrkwXjBv4YgIyTW1RpMqAd4t/Z11MoTY0t9yq2ej471BIe7rgfDKzyf8IvcNqwlrI2M1u9JqZCBXsJCUIOuXmZRm/UXTg4xZyg1EqpQFyeo05I6mUvTNSszEEu2tmm/zyBV5oxB9aEVeW1cj0vsfyZ9AY4yuZIVhE+4UhWVjZfgIkl9TcirCV9FbFD/suleXjLRQLl3fmgK1R3rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:13:43AM +0000, Matthew Wilcox (Oracle) wrote:
> Instead of translating between RMP_ and TTU_ flags, remove the RMP_
> flags and just use the TTU_ flag space; there's plenty available.
>
> Possibly we should rename these to RMAP_ flags, and maybe even pass them
> in through rmap_walk_arg, but that can be done later.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

LGTM to me, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  include/linux/rmap.h |  9 +++------
>  mm/huge_memory.c     |  8 ++++----
>  mm/migrate.c         | 12 ++++++------
>  3 files changed, 13 insertions(+), 16 deletions(-)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index daa92a58585d..7afc6abe1c23 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -92,6 +92,7 @@ struct anon_vma_chain {
>  };
>
>  enum ttu_flags {
> +	TTU_USE_SHARED_ZEROPAGE	= 0x2,	/* for unused pages of large folios */

Kinda weird we had 0x2 free :) I wonder why? Did we have flags here we removed I
guess?

>  	TTU_SPLIT_HUGE_PMD	= 0x4,	/* split huge PMD if any */
>  	TTU_IGNORE_MLOCK	= 0x8,	/* ignore mlock */
>  	TTU_SYNC		= 0x10,	/* avoid racy checks with PVMW_SYNC */
> @@ -1000,12 +1001,8 @@ int mapping_wrprotect_range(struct address_space *mapping, pgoff_t pgoff,
>  int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
>  		      struct vm_area_struct *vma);
>
> -enum rmp_flags {
> -	RMP_LOCKED		= 1 << 0,
> -	RMP_USE_SHARED_ZEROPAGE	= 1 << 1,
> -};
> -
> -void remove_migration_ptes(struct folio *src, struct folio *dst, int flags);
> +void remove_migration_ptes(struct folio *src, struct folio *dst,
> +		enum ttu_flags flags);
>
>  /*
>   * rmap_walk_control: To control rmap traversing for specific needs
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 40cf59301c21..44ff8a648afd 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3431,7 +3431,7 @@ static void remap_page(struct folio *folio, unsigned long nr, int flags)
>  	if (!folio_test_anon(folio))
>  		return;
>  	for (;;) {
> -		remove_migration_ptes(folio, folio, RMP_LOCKED | flags);
> +		remove_migration_ptes(folio, folio, TTU_RMAP_LOCKED | flags);
>  		i += folio_nr_pages(folio);
>  		if (i >= nr)
>  			break;
> @@ -3944,7 +3944,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  	int old_order = folio_order(folio);
>  	struct folio *new_folio, *next;
>  	int nr_shmem_dropped = 0;
> -	int remap_flags = 0;
> +	enum ttu_flags ttu_flags = 0;
>  	int ret;
>  	pgoff_t end = 0;
>
> @@ -4064,9 +4064,9 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  		shmem_uncharge(mapping->host, nr_shmem_dropped);
>
>  	if (!ret && is_anon && !folio_is_device_private(folio))
> -		remap_flags = RMP_USE_SHARED_ZEROPAGE;
> +		ttu_flags = TTU_USE_SHARED_ZEROPAGE;
>
> -	remap_page(folio, 1 << old_order, remap_flags);
> +	remap_page(folio, 1 << old_order, ttu_flags);
>
>  	/*
>  	 * Unlock all after-split folios except the one containing
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 4688b9e38cd2..4750a2ba15fe 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -452,11 +452,12 @@ static bool remove_migration_pte(struct folio *folio,
>   * Get rid of all migration entries and replace them by
>   * references to the indicated page.
>   */
> -void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
> +void remove_migration_ptes(struct folio *src, struct folio *dst,
> +		enum ttu_flags flags)
>  {
>  	struct rmap_walk_arg rmap_walk_arg = {
>  		.folio = src,
> -		.map_unused_to_zeropage = flags & RMP_USE_SHARED_ZEROPAGE,
> +		.map_unused_to_zeropage = flags & TTU_USE_SHARED_ZEROPAGE,
>  	};
>
>  	struct rmap_walk_control rwc = {
> @@ -464,9 +465,9 @@ void remove_migration_ptes(struct folio *src, struct folio *dst, int flags)
>  		.arg = &rmap_walk_arg,
>  	};
>
> -	VM_BUG_ON_FOLIO((flags & RMP_USE_SHARED_ZEROPAGE) && (src != dst), src);
> +	VM_BUG_ON_FOLIO((flags & TTU_USE_SHARED_ZEROPAGE) && (src != dst), src);
>
> -	if (flags & RMP_LOCKED)
> +	if (flags & TTU_RMAP_LOCKED)
>  		rmap_walk_locked(dst, &rwc);
>  	else
>  		rmap_walk(dst, &rwc);
> @@ -1521,8 +1522,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
>  		rc = move_to_new_folio(dst, src, mode);
>
>  	if (page_was_mapped)
> -		remove_migration_ptes(src, !rc ? dst : src,
> -				ttu ? RMP_LOCKED : 0);
> +		remove_migration_ptes(src, !rc ? dst : src, ttu);
>
>  	if (ttu & TTU_RMAP_LOCKED)
>  		i_mmap_unlock_write(mapping);
> --
> 2.47.3
>
>

