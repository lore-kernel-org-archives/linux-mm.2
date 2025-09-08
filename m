Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 206E7CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F398E0011; Mon,  8 Sep 2025 10:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74F228E0007; Mon,  8 Sep 2025 10:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F0078E0011; Mon,  8 Sep 2025 10:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44DC78E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:47:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC4C98487F
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:47:34 +0000 (UTC)
X-FDA: 83866361628.09.75F3E56
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4D5958000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:47:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I49nTKwD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l9l8d+46;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757342851; a=rsa-sha256;
	cv=pass;
	b=IhMZb1BeDtQOJyNK+A81AEm9hvZseDQ8AAYSDd1fSrPtaCeqjhjeoHAmvi0+sNNza9gBYg
	A21jR9EXNTuj3oCatc3Uu9Xv4d9rO+Dab57dj9cmpg28YMWn9BN+VK8Hgpwnwq5eFTma9u
	GV1iO7azgu48cFAHr4kzmoW67G9wOkk=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=I49nTKwD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=l9l8d+46;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757342851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XweWgPQTT1QT8FQpVjPvoqjBRP52ykOAWzAUmw5RybI=;
	b=Jfz0fD6QoCnPjWSgi3mL+STD+WeSQl2OqZYYmHbJDwqX0z/HiKuhfrUrNEIoritR2Oxh2U
	TeP3xdkyD7Q5mrHF+K851hneEPo4V3HTS4dfhxNduwayK+G6lceMF4setPVnqeHD8M8y5o
	6Hae+Nl5bVM2BNLSR7uko8GKkyLNOrU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588E1ucC005787;
	Mon, 8 Sep 2025 14:47:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=XweWgPQTT1QT8FQpVj
	PvoqjBRP52ykOAWzAUmw5RybI=; b=I49nTKwDbVs81ZVTxzxVlmCvBEjj9Q9CUw
	bF71ZdPjAwEP/vlSVJXB1NkAXZtBOKs+hFAnosttyV9UQXTq7qZLb8QZ/8+kr3aE
	pXt3+SvfpSJGvMAGOpKTkQdHYc23XNzKMgrp3eSDwNqEp+2EXh6yQxlmWNIXGYq2
	hGg8wAIRi8peyFYcZ+4qwTwgF2lIANIfRvhb70Dgat0KjuQ47e9Fp7IdEs6KBCvX
	yByrISc5w8GcfDymCo0eV6+kaiCQ/4aAF9LiiNCbifPPe76X+bdXUqhCeOYbVpQ5
	ga+2OMDRSJJ8hRXmxpT7PTg8i4oV3a4RDnrPuYmqPf2zsIGOmqqw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 491y4bra9m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 14:47:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588DcsuC032847;
	Mon, 8 Sep 2025 14:47:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2073.outbound.protection.outlook.com [40.107.237.73])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9a1ab-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 14:47:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yL5rEnFQgzjGonMjP2ySTDOEAjvJy5cZWgLXE+WcjwhJiw0nKCO5wi24Rqpc1nel5tL9eBz9MFvHpYtnD5pxlZr5qIuq/odL0n7Vp7QQxUWOWWjw6U5U/WkzqJuPReAI7FXUBQbxQ3hhYM2i6cmNrhiUvGbliUByUkQYt4FIMhAZChi6QnHAMdzv1vzE3vxEhiXI67sx7nN+vdm5srhfHXUd0L+PrCTOEgdSCGzlyA0dYXLdUFirybxorc9+kYU8v4AvfLXV8S0fiNeKI9/rzW2feq6eLc5annyV+ys2WL23tMQixcjCfJ1zxF+W84HoKGYQlvjtzJzzC9Vw5l4CCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XweWgPQTT1QT8FQpVjPvoqjBRP52ykOAWzAUmw5RybI=;
 b=JA+f3pxdIJ4a8dfj9Sl5bJ59pddFW1EpH4dILCrADYA5yKTyVPEYu5gqWoE6j5zOYwWORsa/34AQAhcyYOvCQiRKfYmcwQULVLTwyQeiEAf5n0AO3I3Sp4Xfq95ewKp8cQAVvL1rLIff20R1CTvbWkySu4MwliQQkz6fx01Sngky/i/keCwCHC2OP/WvZ4JZFVhSfJML3qlDcPDkLjLy6+zv9gT/3w5iA6kQZnLYRLdnabARlAc05fepe7kKIpajZ5A2gejRg+ADxu9wVvXLtVBo4x4uSHidlzMN63Zcips5ncn4lHMzFJZeHHgD2LJw5se18K3a3G3sFmXx074cdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XweWgPQTT1QT8FQpVjPvoqjBRP52ykOAWzAUmw5RybI=;
 b=l9l8d+469OvOpredEa3WCfBYuc/TQ0y3B7oKTnypEeDjmWJmVXiv1JL9s+sbKc4zyfX+3Gl4grB00NRkDsnLpq0CupgvvRvI1Ej6S/FMo4Zg++9OHl338CRYjaztW3s4RofcJcZDUbplpqsKItYjFjbv8zFlDG9DdFRBKapB6Ao=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 14:47:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 14:47:23 +0000
Date: Mon, 8 Sep 2025 10:47:19 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Yajun Deng <yajun.deng@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
        vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
        riel@surriel.com, harry.yoo@oracle.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] mm/rmap: make num_children and num_active_vmas
 update in internally
Message-ID: <xoj5ndzlm3ovvw5kkawnmcnhbqur6c3nmqldhmhzt5vnxodad3@e34ocizuiywc>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Yajun Deng <yajun.deng@linux.dev>, akpm@linux-foundation.org, david@redhat.com, 
	lorenzo.stoakes@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20250908140505.26237-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908140505.26237-1-yajun.deng@linux.dev>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT3PR01CA0017.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c5202a-0aec-4995-3596-08ddeee69eb8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UD5ZS3neGj2nTOQWo8ZaDfvR083y0zZL4aVTEm5HjkFUWQ4PQtp5eBS7EfBz?=
 =?us-ascii?Q?7zr+PDJSQUs5dTsO3gYAOWy6xdQ6E78fgqsfj3VjhrAJJw1phjwOH6y+/lCW?=
 =?us-ascii?Q?F+i3qR3V3yPuHtXuKmWfTiZdRWOJsB0zoF2gXMQ/sKsy5CuvjnGPgltHDHIQ?=
 =?us-ascii?Q?2m/8LJEjJ/Nb+0zGO+y8KDe/iTxG5OmVFEHCwYZjzudSutecwIJtAEhUOqlJ?=
 =?us-ascii?Q?xK0QECcm8K5KWpWEmSj5zf4yo2rM4Nn8RCIxhPAJp8V+fEyLHzlgxpdWSvqQ?=
 =?us-ascii?Q?83E/QZMp3/Qw/JgpBUmIBuEpsFwmjdrqc8R4sWCYDaG4uNVM0Inzp3HCRVrm?=
 =?us-ascii?Q?UzK5Z8cNb3k758Xz0E2fenihRPmAwdsLrDvxTUc64qDFIVKNyTzYrlRD3aSL?=
 =?us-ascii?Q?+QJSxvjtspnq2sF6/NVPWpi8MFpt0wUQaa8/MLdWBqS6VQVlyzQnD4xKcSLK?=
 =?us-ascii?Q?SDfuV1NZj6DxRZ5z8vbF2jyV6HuACm3HN+ceuso6PDCxNlw+dwggUmg2zd78?=
 =?us-ascii?Q?x3hCo14Z4CkQYIIIB+0HUX9NH1cMjjnHJAckGyCH3A5HwYdVa6TmMDKN1Zth?=
 =?us-ascii?Q?l3E1ORdozCO6tcGzFkbQMUfLbhn2sfH4vJbhwQJAVn/tLgwxGUD2fW+U+6qT?=
 =?us-ascii?Q?FXKYDiICtJXgP5JpBJaMbBu+kVfXydsa6qqcofxwCQYZggh1LbyrsTPAKE93?=
 =?us-ascii?Q?JNAbO4hHlZIzLBJiOkoWrLNjsTTeDtznQxGStsa3W9497JrJuKPjkVPRjmMS?=
 =?us-ascii?Q?TCwDq057Mo5h5Sh9xQ9hFv+5jNfOfvehfqAFO9hd2zuxmbfE9vcrs5dNpeMD?=
 =?us-ascii?Q?re8VcOFweYzTvRejbA1+X1uulcXNXzQPRBCUOw3aX58F1GumgV8yZRO9SJ3o?=
 =?us-ascii?Q?bM/zOijNIVyZj3a90NUxanIWoaIPYsRbiADHM1dgi96nA4ODIHA48Qj2afuG?=
 =?us-ascii?Q?cJniQQ8Eoc69G33dIAQfGYYPQ8FzHo3LYZiJfCRtmjYG/A1n+TY5hMzScmC8?=
 =?us-ascii?Q?Pl1MqdMasMRHApWgJtKAVZzodsLzNoCd9JXrAMBvntjnz5xQoUIQsWjFp/KJ?=
 =?us-ascii?Q?6+zv1x4XvIp2HVdkdgmcwBS5YBGsoTGesnqV9mH90EysAV4UeWQCw42HlvgO?=
 =?us-ascii?Q?242rLG2ufQMGg3Hs7ENHuMm40D32eNuIxThnEOJYa6cqyhQ/4Ki5N9zWkqmX?=
 =?us-ascii?Q?MmOHy4km4psbdQlXUXNkjQaqOfbesAQOA+iP7NRmFvOh1cg4RFnbMMmaNJlz?=
 =?us-ascii?Q?aNNsM0uWd00EtEm7Ir0muE96ClzOyBzY6oYJ4i2RrlW8qI4R2ZM06xRWm1QC?=
 =?us-ascii?Q?aMZiu0rQL/pH0H/XCiExZs0U4oaxin996GpTQJvFMzNXLoU8n4Oy59P2CI9N?=
 =?us-ascii?Q?JMUuYQdZ8g40F/fDYxIK/fSsEa76ITqd3Lolkcp69bIrL65ykvq2J66IYC5m?=
 =?us-ascii?Q?PMsntZRprlk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4LXhsIpTD5pgO+PmqFGx3laXKWisEX2KE8hGy7VyRn3xZ3lKHsSgH1qbMElo?=
 =?us-ascii?Q?+haESlNl9kerssXUewx2i7DPyYc26AuK/8MAZqCLG4790TCrfnJDg/fXrJ8v?=
 =?us-ascii?Q?eMuY4lMZobwM41u6MyjYVm1/l3nJ5ltetCFEebL2h+HWAIC5nMQeet7xS2L4?=
 =?us-ascii?Q?7fqHOg4R0XwUKWj2RGcMa4ch+O5a6Ing7mEzecUpQhskUzVwolQpfHP9cwlc?=
 =?us-ascii?Q?rd40ZNbmMkQ7Lol75oC01guGXfCF4IwCmEJ4lvdZyMQ/dBkTV3/MSk/ksVY5?=
 =?us-ascii?Q?q+OdWnYTLiwU8JDCF8huBGnBLQsD7nsquQhHLM310jLm+kEwjvX4qhaTI8vf?=
 =?us-ascii?Q?bbhi/earM2TJN171t1k5naqqdzfOT3lXrZZSqqda/n4Rtry6/aCvHeU5YGAH?=
 =?us-ascii?Q?44nBDCK6dnBBZ41T8oGVUXHnM9eiYHlCVPV5WyDYfAfawKBgSF2UxBYYX17U?=
 =?us-ascii?Q?McdnxUTYxNk8pRNH8Zryb85DiDBCDLtnaq4zNyD3vT5JfmM2BtjQ1K5AsDXr?=
 =?us-ascii?Q?P9Wro1sNiKg+ld8myWLFBCA2wbFcJDTINrQiep035CMREnKRmMqOdcXlnVYF?=
 =?us-ascii?Q?NlIyde+QojIPtRVeBm0q9daK/Yj3wzvPevdQVJ8DOprOfXvuNJbumz7syqHn?=
 =?us-ascii?Q?sxuYgZyfqDEF7gt5I8M0kGUf+kNnCxyl3Gmyad4DIE8dilOkuoioLDqAu0xS?=
 =?us-ascii?Q?Q2bG1Y/AVNOhwzir2ZokAT2PnXuLWTfI8LlIxFHvZh50F5EPlpxOFbWgoAOh?=
 =?us-ascii?Q?5eVZL6g0Cudxosd4Rm4ka/xF+6cHdgymNTwpiZbcYrUqLYxmeVU91+MRp1DQ?=
 =?us-ascii?Q?rEBaLJTiMExacT5vYViwetxV/ONMrAJrtt9cVRqOpqoJVOCwGYyo1ZLrSnDJ?=
 =?us-ascii?Q?brEVeI3PZ33Rir50MmDFPC4phWzOQ78eLE6QOyeBNG0XIQqPk1/ycS4MO3Km?=
 =?us-ascii?Q?WgR0hIDGH7Tifc8dR7afZpcdDr7DS2otkPF1PEWCNkgGABP28YTv31QH+ro7?=
 =?us-ascii?Q?nvNTEWVhDXqPRI6voRRnGof5IrKdDNRRvTXfiNFf+5lHm0gDJpAnd8gGQEAw?=
 =?us-ascii?Q?exbn8MRCWvJEvLJxCfKDZbMl1NJHpuGqlzp8DNoYs1XPlJweCPwDxJfMp4mX?=
 =?us-ascii?Q?RyVoFKJaJbFDZUyFO2g7D4jvCM9ZYbbHq1FjO+l6sog1fJdgxgqDva6IIqB2?=
 =?us-ascii?Q?PyJfz59QP7LLdz7GVKUsA7qmtmGBSoWS60xUUrw28/SX868xdlZC6sHQjEG2?=
 =?us-ascii?Q?Ar5qwVF9m0OSaSLsioEHvGdcHrJCH86lVmBRnxxBBvkSamOaziHxK9u+42c0?=
 =?us-ascii?Q?Z67z4QzHVA4ndw5f4N7jFHUPlw5mNj6BLEL5xk0sj+wRy3RuI5fS0GHYji7H?=
 =?us-ascii?Q?HIWj9aE4G26hHmqyVp0IobAxA34G7rB5wrgL9/f0LSYE5GRwNNC2+f3qFBSN?=
 =?us-ascii?Q?rjU1uTPSvWzHZ3C/KfDBJtGp1ov/mBVgYGkmb4yKtszF/pnHUzYV2atElmBD?=
 =?us-ascii?Q?AMkxj5hTPW5fKu4GYB1DfF+g3aBV23LrKlqExOqwelPMTsqlDSAvK3jLN8sY?=
 =?us-ascii?Q?jL3su2+6uZ3CJATfkwPvnT3ocAo+SY7xfghmyNVI?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	cpjq9peTF3lfs07lKx0tjTjBKqfOQxa4gQdiQ+AGaWg0eMCqeo6fYucAJCvc95cGXHyNT5RDOLoSdOYXy8zwmaRDon9qz5YqnybUCI2FmmSWxG6TQn1CU9mJdLoDnkeB21nCFkcn5+1vfukh6x+iAWdd6YgEm17HTq4cRmgdpeSqToZHPCtDEc1tqJr6uk7OnMW0OOPBdNQA/RGLdv6bzDIBCfqQzqg19nHFlocFdO992YQ2JR4TYsi0jQSizPCouLOtNIPMqNdCwxfY3cm2FDp3K+hkoRIjxvUIWUK6z57RDAsIE8BAh4rdpjVIWzWK7Ii6kOnHdWhQJErCVGAs120OAANZAvGrlo3UHuC5Nao2wC0awuNgoTi8ij6/Lf5B68+bGhENQl5+ar+OoClWPyGyrMDhkLdYqp7OudJLJL9D1LyRwQtvTyEJAgj9+I7WguNSfYcerTkPgNb1MSoF7jR/9A9LmVtPt7dvZbnQkQ/HHJxgQpY2SfCkHxVsgq8lImlAifpEh0M4jtfdJrb3AWjdZ2UNnYj1fFgpBSx54RNl7CX8OJHE8DNn4eHmqL2VTvFogLVGrDu6Wvyh1Gbk+VB+BVVvkwVxfuYg0K4amt8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c5202a-0aec-4995-3596-08ddeee69eb8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 14:47:23.1545
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: njFIleSu5i+m7qpnas+227UIotViKA8GgrqiY7lA1hMg6bbgWamzKZUXzHItQDC2+2r8AcCXFAAFYSwNnx8e/A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_05,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=905 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080148
X-Proofpoint-ORIG-GUID: 2WC82P-SqBHKbG6t-xZppjATVRx0FcXE
X-Authority-Analysis: v=2.4 cv=ILACChvG c=1 sm=1 tr=0 ts=68beec7e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=Hrko_yQyW2PJZ5I6pXoA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDEyNCBTYWx0ZWRfX8Iy6nQiNAiSv
 NIFl7KH4NE5iLEn3lj/TGM8LhxFr3ZUGGTHnfAgj26j81vjS0H5dnxf8uwyJfy0Q/AaXl6tgVti
 gGPYWQOELtwV5JATBofCBVCWA7DvqvrDM+ao14ktDI8jSTLgrKYx63Ar40FlIroMfdFzzNevyHs
 bOvgFft5fczneqTIPXoQUXQVYxIK82EwmXyaLXXE3bnGGXYMZgZyZ4yoXWZN+I0T/9j3qFb2wrm
 9rxJLqssZ4uGFextJgkx2tsXXh6Z3nrXL8/K3YupFGG21enClhqEoH3uzj7DmGBnkeVAwLh1QVm
 /nZlN/ueW8AA56PJEygRM+Yi4qCjCqSQWpkTXtLzDoNkvHHI7Qz59ew2C7HKRpn2Kd7wDw0bbqE
 89PiVJsv
X-Proofpoint-GUID: 2WC82P-SqBHKbG6t-xZppjATVRx0FcXE
X-Rspamd-Queue-Id: 4D5958000D
X-Stat-Signature: pf6nac43nnx63rxsfa78a66bn1dapcmy
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1757342851-870871
X-HE-Meta: U2FsdGVkX1/xHJ3YL/LTVzzHXj/uACtg3AnOdiqxC6Skgzq7O8s8lTUZr5rxncxiSxxXtvdYZCvP2hKtDWf0LCkoZWECzhmlIQXXYHfXs1cZuo79g4DANmla3ZPbioxNSSIomci8/g8JJYuN6I4lmMPJxpteorc89p34UiMHL2y/3pH+b+VmtLW0beFp/xKCVp2RgBPpdBAaiuj6whHL+y7HOsAUO3djyjN43M+dFbA/TV+bxFjpZ76+WcmloNNbswMgVa55Tlh6XkjlXGR+t2bAV8C+qB85P/F992yqILbG1Ie8WBvsNihB4hf3L7RtMtZR0X/eBs1wqJcXqsO+HcQlF7jSVVSD/sj+gdLb+OBImuLAdRhHft/eGUEgqbORhHEJGIvUZqlzBRBShRSALOFueWXbX54+jv+FGxLAKwSuRv2HuQqD5+C1HKt2L6YQCaBZtR1b9Icm3PN3HR8MLD4+tlfgkG8DUm7lD6+XZoTG36IvNoVrf3nzrFOEZK3mpREfszueznAbBIrPfvEN9636tWDDL7P01a+YMZ53eKOApcBpgra+iAnBlSqfuRu0Q+SdOiPKAe0ZKz05fMNVP2fKShaumGfFg+QngfSTDRbhUrRTUZtDF8J5EE7U+XPdHRuoEaOrqUgMPBXJM81cb9a2wTuYDz9IFgvLfexigHuan8cTpMqIS/a+BBQuS5JAHBBmXcD6mSWpa74fbxU4LUeuuYUnsjAD72A7s1adzaD9yReXP9RcVq8qxCOBQFDbyIdTEhncR6kyz3dEfld1Jgdpqc43jSEKc/HB/oyxDKJwQkPZwCPKtGvZ58rPXMrCYA3UtaPn3GcBHOKrlcs/ZKXLej1qW0Ye9sYYDddZ7mKrSsPNbnVO33uxamZuOMg/dC/jX7HZzkGfADB2l/E2kOcPNdhQqC8bn/DX91FdQMKF0I7t4HUE4w+Hg5iV69HXYoHUf62c2gtqW9VlQN7
 S69oa+tx
 G78KrJKd1Q54+hNEz57JyOp5rdQ9kOS9kMVkKbSA5KerZceH18gG4QPWHnsxIiUDm98HT9v3COy1oJbumTTOOWAYFo0pDL3OHCkKmn4WS9Z32w7rf/JUQ5bCPN3AFyI9iaHMZZ8ALbRXY2QkJmIL+LnqMzQeqztlYS4yGjCOSJpARdt0ibHPflFghPvpofXvKvJ4srI5NxIavrm2DCJnu+9jD51hUcEphNB7glgR1LRdTTz6JVjlCRiXTHchfG5wGYg+KZRHjU+qufec8BEA8wbyR8OOOEAr/sMTux4Ej49BhXSS/eUPK9NofonqY4gzW+w2U/YSVI4e6L5Q1U6H4B8j0blKWhAo9nX9ohulpk+Mk3FDcmVFW3YF1Q1m4KJASYeTmr7ZNIl6+CqbypwhLkk6+WDeTALLeb4B8WSffX6xql2zT6hHKKS0VfqmZLB7/MrLLQEkOCIy0+wWILZWXPOBgrL8ZUXSD60G9jyo/j0ObYn92ywl3/LPsdE9xGz91uYjbh6N/WLbzh6U5/6NxxC65vHzsWWqCV9z0LGcxqsp1TQ9fMZW6PDAE4LlWdsnxlYuokBIjLXRCyDGbBSJR7CqYe8FlIJOMKblaPOLozfE92/VdjTvQmzpHlk8jH+BGPrydGoZxGxhjl5FjfBnx91KZcxRQvraW5jaTzC4lWxEsnQpC1oE5lLyHQ7Y8Wbd9rdFRGUB510AeCwKuI5wAOCSaReuQ8fQqyfSn4TWLMAybgtLN0m8ZuVPJ8kskJk97snd4VPGqsAIiDgbvnZmNR04NAoVB10DWH9cN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Yajun Deng <yajun.deng@linux.dev> [250908 10:06]:
> If the anon_vma_alloc() is called, the num_children of the parent of
> the anon_vma will be updated. But this operation occurs outside of
> anon_vma_alloc(). There are two callers, one has itself as its parent,
> while another has a real parent. That means they have the same logic.
> 
> The update of num_active_vmas and vma->anon_vma are not performed
> together. These operations should be performed under a function.
> 
> Add an __anon_vma_alloc() function that implements anon_vma_alloc().
> If the caller has a real parent, called __anon_vma_alloc() and pass
> the parent to it. If it not, called anon_vma_alloc() directly. It will
> set the parent and root of the anon_vma and also updates the num_children
> of its parent anon_vma.
> 
> Introduce vma_attach_anon() and vma_detach_anon() to update
> num_active_vmas with vma->anon_vma together.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
> v2: fix a WARNING in unlink_anon_vmas and optimize the code

Fixed all the bugs I found in v1?
Tested this patch this time?

What about the parent fields without the lock?

> v1: https://lore.kernel.org/all/20250905132019.18915-1-yajun.deng@linux.dev/
> ---
>  mm/internal.h | 17 ++++++++++++++
>  mm/rmap.c     | 64 +++++++++++++++++++++++++++++----------------------
>  2 files changed, 53 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 9b0129531d00..12bc71bb2304 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -953,6 +953,23 @@ static inline bool free_area_empty(struct free_area *area, int migratetype)
>  	return list_empty(&area->free_list[migratetype]);
>  }
>  
> +static inline void vma_attach_anon(struct vm_area_struct *vma,
> +				   struct anon_vma *anon_vma)

Function names are still confusing.

> +{
> +	mmap_assert_locked(vma->vm_mm);
> +	lockdep_assert_held_write(&anon_vma->root->rwsem);
> +	vma->anon_vma = anon_vma;
> +	vma->anon_vma->num_active_vmas++;
> +}
> +
> +static inline void vma_detach_anon(struct vm_area_struct *vma)
> +{
> +	mmap_assert_locked(vma->vm_mm);
> +	lockdep_assert_held_write(&vma->anon_vma->root->rwsem);
> +	vma->anon_vma->num_active_vmas--;
> +	vma->anon_vma = NULL;
> +}
> +
>  /* mm/util.c */
>  struct anon_vma *folio_anon_vma(const struct folio *folio);
>  
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 34333ae3bd80..de557707c34a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -86,15 +86,25 @@
>  static struct kmem_cache *anon_vma_cachep;
>  static struct kmem_cache *anon_vma_chain_cachep;
>  
> -static inline struct anon_vma *anon_vma_alloc(void)
> +static inline struct anon_vma *__anon_vma_alloc(struct anon_vma *parent)
>  {
>  	struct anon_vma *anon_vma;
>  
>  	anon_vma = kmem_cache_alloc(anon_vma_cachep, GFP_KERNEL);
> -	if (anon_vma) {
> -		atomic_set(&anon_vma->refcount, 1);
> -		anon_vma->num_children = 0;
> -		anon_vma->num_active_vmas = 0;
> +	if (!anon_vma)
> +		return NULL;
> +
> +	atomic_set(&anon_vma->refcount, 1);
> +	anon_vma->num_children = 0;
> +	anon_vma->num_active_vmas = 0;
> +	if (parent) {
> +		/*
> +		 * The root anon_vma's rwsem is the lock actually used when we
> +		 * lock any of the anon_vmas in this anon_vma tree.
> +		 */
> +		anon_vma->parent = parent;
> +		anon_vma->root = parent->root;
> +	} else {

None of this is worth doing in this function.  A wrapper only makes the
code harder to follow.

>  		anon_vma->parent = anon_vma;
>  		/*
>  		 * Initialise the anon_vma root to point to itself. If called
> @@ -102,10 +112,18 @@ static inline struct anon_vma *anon_vma_alloc(void)
>  		 */
>  		anon_vma->root = anon_vma;
>  	}
> +	anon_vma_lock_write(anon_vma);
> +	anon_vma->parent->num_children++;
> +	anon_vma_unlock_write(anon_vma);
>  
>  	return anon_vma;
>  }
>  
> +static inline struct anon_vma *anon_vma_alloc(void)
> +{
> +	return __anon_vma_alloc(NULL);
> +}
> +
>  static inline void anon_vma_free(struct anon_vma *anon_vma)
>  {
>  	VM_BUG_ON(atomic_read(&anon_vma->refcount));
> @@ -201,7 +219,6 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  		anon_vma = anon_vma_alloc();
>  		if (unlikely(!anon_vma))
>  			goto out_enomem_free_avc;
> -		anon_vma->num_children++; /* self-parent link for new root */
>  		allocated = anon_vma;
>  	}
>  
> @@ -209,9 +226,8 @@ int __anon_vma_prepare(struct vm_area_struct *vma)
>  	/* page_table_lock to protect against threads */
>  	spin_lock(&mm->page_table_lock);
>  	if (likely(!vma->anon_vma)) {
> -		vma->anon_vma = anon_vma;
> +		vma_attach_anon(vma, anon_vma);
>  		anon_vma_chain_link(vma, avc, anon_vma);
> -		anon_vma->num_active_vmas++;
>  		allocated = NULL;
>  		avc = NULL;
>  	}
> @@ -355,38 +371,31 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
>  	if (vma->anon_vma)
>  		return 0;
>  
> -	/* Then add our own anon_vma. */
> -	anon_vma = anon_vma_alloc();
> -	if (!anon_vma)
> -		goto out_error;
> -	anon_vma->num_active_vmas++;
>  	avc = anon_vma_chain_alloc(GFP_KERNEL);
>  	if (!avc)
> -		goto out_error_free_anon_vma;
> +		goto out_error;
> +
> +	/* Then add our own anon_vma. */
> +	anon_vma = __anon_vma_alloc(pvma->anon_vma);
> +	if (!anon_vma)
> +		goto out_error_free_avc;
>  
> -	/*
> -	 * The root anon_vma's rwsem is the lock actually used when we
> -	 * lock any of the anon_vmas in this anon_vma tree.
> -	 */
> -	anon_vma->root = pvma->anon_vma->root;
> -	anon_vma->parent = pvma->anon_vma;
>  	/*
>  	 * With refcounts, an anon_vma can stay around longer than the
>  	 * process it belongs to. The root anon_vma needs to be pinned until
>  	 * this anon_vma is freed, because the lock lives in the root.
>  	 */
>  	get_anon_vma(anon_vma->root);
> -	/* Mark this anon_vma as the one where our new (COWed) pages go. */
> -	vma->anon_vma = anon_vma;
>  	anon_vma_lock_write(anon_vma);
> +	/* Mark this anon_vma as the one where our new (COWed) pages go. */
> +	vma_attach_anon(vma, anon_vma);
>  	anon_vma_chain_link(vma, avc, anon_vma);
> -	anon_vma->parent->num_children++;
>  	anon_vma_unlock_write(anon_vma);
>  
>  	return 0;
>  
> - out_error_free_anon_vma:
> -	put_anon_vma(anon_vma);
> + out_error_free_avc:
> +	anon_vma_chain_free(avc);
>   out_error:
>  	unlink_anon_vmas(vma);
>  	return -ENOMEM;

Your plan was to reduce the complexity of the code by isolating
duplicate code in a function.  This hasn't panned out in this case as
the code is much harder to follow.  For instance, the parent logic was
spelled out before while now it's in __anon_vma_alloc(), which seems
unexpected.  It is being initialized in the alloc function..

You had to add two functions for the two call sites, which is a hint
things are not going to work out here.

Reversing the logic above resulted in a different but similar undo steps
while hiding what has happened with the anon_vma->parent.

This isn't simplifying anything so I think you should move on.

> @@ -420,14 +429,13 @@ void unlink_anon_vmas(struct vm_area_struct *vma)
>  		anon_vma_chain_free(avc);
>  	}
>  	if (vma->anon_vma) {
> -		vma->anon_vma->num_active_vmas--;
> -
>  		/*
>  		 * vma would still be needed after unlink, and anon_vma will be prepared
>  		 * when handle fault.
>  		 */
> -		vma->anon_vma = NULL;
> +		vma_detach_anon(vma);
>  	}
> +
>  	unlock_anon_vma_root(root);
>  
>  	/*
> -- 
> 2.25.1
> 
> 

