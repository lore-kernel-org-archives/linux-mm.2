Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 822E7CA5FD1
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6AFB6B0478; Tue, 20 Jan 2026 12:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CD56B047A; Tue, 20 Jan 2026 12:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97AC36B047B; Tue, 20 Jan 2026 12:55:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70DAA6B0478
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:55:19 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 282278C1EF
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:55:19 +0000 (UTC)
X-FDA: 84353093958.25.B632270
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6682340005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:55:15 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r8KYvUvs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jTh163Pp;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931715;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyIwCg5p/+lM3Onxs/6iuX3ggn6XNAjr/B7/iyjQvbU=;
	b=JYHd9A3dZQZUSmxq5Nh6fPa/9MHrrEXcLhEl5QcTLqXvaGDolXKv9IGOYnv8/qrfK9YCzO
	OU6Qqr0cYCQSSOteTHwhn44hvI0M1XfDPaCunY14uThETyULBXMAoJOrztTEuMsOeWXxZy
	O2WLqeglA167fyhtfoWGe0Rx9d1GuRk=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=r8KYvUvs;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jTh163Pp;
	spf=pass (imf07.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768931715; a=rsa-sha256;
	cv=pass;
	b=Ix7CkzsyAaAVjaYwoJu5ZBk7REB/uPEeqo6iSTUCIvsj9zybGNgxUfDOdVr5WvP6nNHPPX
	viTEFh45hT3huGZiV0wkaGGNLgXSLAtIA7wQUhWmn0EFPGD4cgvWk65N0jEaozu6t6cCc1
	S/tyPHTh18Vl74c4cem17Ir9R8rkmyg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60KDK2dK3867731;
	Tue, 20 Jan 2026 17:55:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LyIwCg5p/+lM3Onxs/
	6iuX3ggn6XNAjr/B7/iyjQvbU=; b=r8KYvUvs9UvgFdRph6QpMjEzdd58WUVixs
	LP9Y1KTdsZNwMCli/4bzYJ8Sfiq8idlSAuVMKavot11K9pZsDxpzlBW4LX2ilEkD
	xKHm1QMyqk5zHuqaaC2hfaeaWvZvL7bCwezqcJW2A72DkY1xsKDzmMkeH5+7xcjH
	IjASlKGry4Fsvg/FiLcKGFTryShl1th4TMg0gc0E3f9JFMH/PR6XaZjZ3y4AKmGk
	L3Vc04gDtONovqvNsk7tXHu1G0nb+NMDb3KglUoi0N1rXxnyXk0r1SeAiDFzNzqS
	EGxa25/utcA80jIBiOE02k4qSm0m+F5fKuio0UAGbnuWOD72pLmQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4btagd0gym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:55:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60KGtbbx016227;
	Tue, 20 Jan 2026 17:55:02 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010007.outbound.protection.outlook.com [52.101.46.7])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0va0sea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 20 Jan 2026 17:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Co+wpIiHvl2CSJ6DLw4Wi+sIiTp9YC/RKHk/bQ8DxC0cjHz4X1MyDR0UEcMNrNCRRKYiAcIv6OnCeDrbuuDF5QU2s7Vi6pGvuFloIyKYJmIOoc5pe+giuJaU9n2rALG+n69GX/RRC+zutG+YnhkC0EoqEB6cTWbk58h3WDl4JRDll9lk8dIOhaTROZKUaj+jQdCXeL96AeeLdmR2zoXdnNZwNXaXv6CO9sgM1r7f0d28JaMn4cH9ektP7YUyPfFCzauKVgvvRrrOuGixv7jGY4W9HFNojzJyxIH2dDAJxvJ040IwGRZO2RuF8SEnw3qZcCEeqmOf21MSVfXZp8Q3Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LyIwCg5p/+lM3Onxs/6iuX3ggn6XNAjr/B7/iyjQvbU=;
 b=x5ku1JA0yQVCeYA9d9VtOoDcGwUW6ZMF8nktxxIjXqnf4gx5O6u1AwdHJ+w1K8cGuSQDF3yKwFGkESd3QKbOSpdiBkvV7iEjKLhPT9AuqwdF8XXyGrIs2n4mc1OIRAhS2MxOTrdbxIH0o7a0xxJykK+fkQcDX18KHwCKemCwgIkxx1M0swv74GRIn9ihThASkkZdJqTJhxNZCci6MhdXkwpAy/y8rkVbBqNEvhtNt8I3qwRLM0+LLEI5p0AYrdI/Nm5EkdYcaDdGZfJq5DuxjBrIxZP9KTj8a1a+6ZPqLL/Idd9epRoTnS+IPVlKwh1OtM2estEXvQP9eLJXNMgPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LyIwCg5p/+lM3Onxs/6iuX3ggn6XNAjr/B7/iyjQvbU=;
 b=jTh163Ppw9Vzgzxo+awGrYC1inijBUKwCRKHsmy9LCEY1iooaugafCIGLYzjjW8stcURZLtA/Na9qgoQikFogbizm1z4dTtMIlVnDTzSwE0phrTEKrxLC67J94t6pP+DPCgRgjiaZfXDAzAglGbPQ9Id5XS65CJoY5pKjjvJaH0=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA1PR10MB7556.namprd10.prod.outlook.com (2603:10b6:806:378::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Tue, 20 Jan
 2026 17:54:58 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.011; Tue, 20 Jan 2026
 17:54:58 +0000
Date: Tue, 20 Jan 2026 12:54:47 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maple_tree: update mas_next[_range] docs
Message-ID: <tal36hph2g5azjk33h564bllr2n6bz2xhdw4vcvizkhptedfuq@56chjersnkfe>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, maple-tree@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
References: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118-mas-next-doc-v1-1-827d9f4924ce@google.com>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0078.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d0::11) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA1PR10MB7556:EE_
X-MS-Office365-Filtering-Correlation-Id: 8df500bb-0955-40e6-8f87-08de584d06ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?cQklqAUZP8CyO2w0aUMqLT+D++Vs+WkoEdoi4/7Srm87I6uXfbjFetY1/Alq?=
 =?us-ascii?Q?H61I5vO5sODV0XC9m2kZ3a091mN0ufJnbw8sheOKit9R+agSVFY8vge2AIwo?=
 =?us-ascii?Q?62Kmr3acB6qSsWTpzT1yXJOq+2EnpPkQDl0muBTKG10SGHVQFB4NvD3ULjaL?=
 =?us-ascii?Q?AEkTEZzLB3snYCmFmna5T8JXCUhzLhbYZx4nQYrZMAMDDLDO0LP7LxLTCx2k?=
 =?us-ascii?Q?xbboEBTqAbx63iW5+rss1h7ZlZdgmsN3N+3DNyvAlci+DGZQ/2ueZWvLx+oJ?=
 =?us-ascii?Q?XyPn+XIZfFswwjU1TWYKWSlK87a6GS2ihv9jeqQ/R4I/TqQi9iweKQd/iUm2?=
 =?us-ascii?Q?NWwnWHTev2AUt3ffMJMsbwy+5sKpHPfwb2BVW1NMoptX+yEwd4y32ccS4hlE?=
 =?us-ascii?Q?KVudqfcfl8g/d5BNaK459wx8CZWv1s6BS9vwvNOo0pZNwf79pcK2QPt0ulz4?=
 =?us-ascii?Q?ayeFyjPl+M3SEAh1Uf5CTlKh5pwwAmfY/BJyr1hhYRLkkSRb3tAWZe6WadOV?=
 =?us-ascii?Q?FGl6kP8UkTr9u+wf2L7oVpacPshlzqr3GONdiOqN+gs/RQuAya9bFSHcsgh1?=
 =?us-ascii?Q?rypZM6vlwLC9Tm6TDEYAYIlwgYtpVe+EcyzEsZVeyE4GQi10P3IQXhIKxkDu?=
 =?us-ascii?Q?dhjVY3q6N8casgghIxf4woMz+NezfFvCJfAtE/8oz8KCG8IIat0wDp7sJSgM?=
 =?us-ascii?Q?j5Q9os1wuIhsM0OrpE354zJgoqdaOZUDbosUcPx2meA2KSWxil6QRi6EKCl3?=
 =?us-ascii?Q?iR3w8tJtVZ6RB2+/K/u4NLwVXTjw98bXaqw/UowQthHN8+FP/G69NPtJun9/?=
 =?us-ascii?Q?m8pUBSOSJDB95ayRN/xwJZc4jNJ5g6qTk8vn8MSsjyL12loMAg0KGApLCVJs?=
 =?us-ascii?Q?1nrvVRQcNvffN+xLCSRrrnHYzoYK5VSOPacMb2cIetr//22s6Oq2mp8Ssatd?=
 =?us-ascii?Q?MyeRZSQERg5O6K7TqXIT4szfCkhoqV1s07eMYzbprD0YRQwuvVOkW3jjiizN?=
 =?us-ascii?Q?vz6S8WIoz+SWZCxh8k2thNtNQhGDhHCK4PdkbKeM5tEWzm7o+Q1WZGMFqG+u?=
 =?us-ascii?Q?c6p2ObyuRMKYmIbKwDuxGU3hsUvu8CiOdj0qSaZaVgeVMyuHU1dTKVs6UNg8?=
 =?us-ascii?Q?FzRxtCq1gcrCyf9a/pAKbEv8hTcGoMSqbCV0YW2K9TB8S+CcDRY6JpZh88Ab?=
 =?us-ascii?Q?9v1JWx7t6EQDGqD+LGZMccjSDUG+sAFNCO313jdVDI4HpHqng+YlA46AAm8m?=
 =?us-ascii?Q?qgdCSTOoWrhwTBP7Oh52Z5tqu/Eb0g2Gotvw7+Ftzzu8pR86hw4TZui1Fyp0?=
 =?us-ascii?Q?EE9uV2fd+UKG07ZHZoX3Urg+Hj0nBd84NWKZ8LP3UQTdCEh0KQR/NbKBhlzE?=
 =?us-ascii?Q?wi8T1/4aTZC7tr0hVNdEDtlGaBkoQoJUlbr+FbQ3QMvRUzoYcrck+jl7UZUk?=
 =?us-ascii?Q?edI4n0KbCjVMhN2+Xhv0Rfy159XEcXUQyMZB4AHsFl4L4SuwI8ppAldPUqkU?=
 =?us-ascii?Q?0U1AGiQgyVpyRVpBf9hBJch9YGYcu1tXHYHX31Clb5ZDGVt7fZ0uVmCkacm/?=
 =?us-ascii?Q?/yHMSI7+rBZ6WoZJy2U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?z/at9hOTtKW9ql89qf0pYnO1ccBEfHQOQA0uXjyfyMGDbXBU8x17zWjPbeeW?=
 =?us-ascii?Q?miLOwo3JUqgmj6M/AcXIOwJKT6XoOQdt7p2YbeY6WI6XWjAX3cr3apt9Opfs?=
 =?us-ascii?Q?l9+U5NSSydNKUykEoVSt0AQgbEUC6j03WLwu4L3MKhag0lCPOHjyKynevk4m?=
 =?us-ascii?Q?PgsncqC/J0qIfzwzH7vRPcxFxEPyHhwDcRFpBbso6Q6ELlqHfGfBjxWA+S6f?=
 =?us-ascii?Q?cBeWQDrEr19F3KyP2891SluwX7gVQ5C0IzwALdtKuA9th+aDXc3LUUY9XfBe?=
 =?us-ascii?Q?Z9TPOcPaeYMuoG6QNgdviwkw7kbgYnlMyt/zKIH8dKM6b8QWkvIo1B2UykTV?=
 =?us-ascii?Q?ASNA5sJNVB28B9iuO6h1WWr7mIgXbJH73Ivlx2CJHePBzj+g23UCfp/s64qK?=
 =?us-ascii?Q?uME7leivJyPEeYmtiq0Mua1NZQnE+FxOLln7/edTexR+gIKDshxhoO3X/7YZ?=
 =?us-ascii?Q?6W5yv/i7URprbXCskzAJDh/ZHSgI3aSWbOQ0NnJdjWT1WrW/YszGC/nbTRUR?=
 =?us-ascii?Q?1ms8jSz6ww1fEMD7AFe7J9+jy6adt30NW672w3p7ssMmMYyu9UyyWr9XjPse?=
 =?us-ascii?Q?WcA1t7l1njO6pozduzN3GTcvzh0I2k6fv40HRfyfP3/gLfudvFF5PhC2ZESR?=
 =?us-ascii?Q?RHKBleyboJ6fhJJ5WCdbKyDw87tP7YP0GVlTtU+LQzmQQn2DwZdfGdnbJZ7Z?=
 =?us-ascii?Q?5dfBHt4Brv6iS15GWx4m1dv8u3og36JqB/9EdabJMe44QvzrRTZxtGR/cNr+?=
 =?us-ascii?Q?QsgWSFzVxQ6FHHuNZiM2J/rMHWW85Y3bLulzJKzNNC7VvzvrpqUbwrobJCe0?=
 =?us-ascii?Q?qMRmuzlb028+G0tv1fpHvj8rnjKj1zr6I70JLrsDG36pdJxE1PLK1nnqjrPE?=
 =?us-ascii?Q?QeEebTbbESbgl8HEnp91uP0BQ3jpg0A+D3L40t01N5usKSJe6inTC8jRQHDZ?=
 =?us-ascii?Q?wjHhXTITw/q8aa9hfgCxAExHUQL1dLqRxEe65cyygyngjxbrbrQ6uTE0bYy2?=
 =?us-ascii?Q?LYgwKA+DyPfDr5lMQI26pIC2LIdsShxwN+GX4o6LJjvrsnA4ep3g5qdPe32G?=
 =?us-ascii?Q?ZscZvDLJVKihi9Ni9PSavNxixbNRcdSplWjUfrHZ4vxskD0kTqkqAvzD6VtM?=
 =?us-ascii?Q?J/RwSAOwN5oaUsXjGEFXFfq7dDraewIWh0FnHwM9MHPkUPAzOzh5GAJm9CnF?=
 =?us-ascii?Q?kP3/CkXkuJLqWdEjhZTlBNvqLSuVfwGQsB9H+H0nv0EkgXQTqG9hEgXYexOv?=
 =?us-ascii?Q?wVXgXSGoHaykeMVaTzgc992iwqHUgzO2DSe089TPDgQHTyDcg4XVG+aXgjl4?=
 =?us-ascii?Q?ojOBq2wBMFlcNwL9i+6kXcTnG2gBllaJ04xkAtZtqS9EhJY8h1Kmg8PfiE7D?=
 =?us-ascii?Q?JJ0JjfVkaG3PFo3pHrEuOPF1YqnvMSFva1MH3vKeKaBDSHHkjXfb8Wtj8QhQ?=
 =?us-ascii?Q?IAFTKk0jZgkdUTsoRs/MQuXf7+1JT7Mb5wOlNXAkd4PXOXbe+0w4yE0aVhN3?=
 =?us-ascii?Q?C5mbE3qSBt84zl6oKfsjf0zXMwqu7B5jkRp30yDJKdMI3X6DfwbQPLwKHIGo?=
 =?us-ascii?Q?VnY6pOWGDm7TG4Ky3EB1VEPxdCnyYT7/cckQvIAJtrqowRTQcvffhlQtfEyU?=
 =?us-ascii?Q?xrdthTCScJjNNRItGJqYgeBapxWcBx4mYuhSfH6bWBHcuNxcJngsOt1ZnTLV?=
 =?us-ascii?Q?W/QC1rlUcRPT8r0ONITz0/XHH314Uj38b10F8SwLwKjQqQX2jpih0fdkMABG?=
 =?us-ascii?Q?8BNObFw1ZQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	HeuTbJRaL/5K+YBk18RgN06wofcV62L2KgNKsePw064Jg45LhtGc5nvcvlXH9lRLqBE8a196lGhZ9BowxcB8WWtQI5FxJXuynFaf5v5v2OASDfn2RLwY3aytOt1sQVC7wY3KfctXjZ/KEKb9VD57gr1LA7PdqEOE6GhwqLJeIY5fd6hCR4h+U3lPEhU3sUkR/kW0Z8L5R17anNtxtNVuemGBKv00EVlYISG0nDSfCMToXB0AEo3hREyuakd46UKrJ5fu8raOS0h5HUMomvprMOf6F8mohLv8SkhhGk7tZFHp2mLsuTCLjVwt1nUU2iFJJFejg/76iyzQ7ehCSGpv2Diva43BAnBR1UCqegQ55qty5d2dOBirGYvdPQKKNFVXWtl6KvU/AyQEVfIW/Yq63CeGDcbs6nhehWRT9/MvkrcQThkDWO8XZwd2E/Jb17OpF9e/q+pr2pS5c4Jp71DkDtNshG0O1G1PulgphpzmWUJe4BsOcSQ208x9cWcvPiIytzEdlK0VpSobwbF1ROiVZ+Sp7HaiidnNhUWUoVnhFReqMNfW4hyCSlCF5IBC3IZIGBuBncKrk4AvzI67Jx7UbCInX8hphnAo4dkmxaTmhDM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8df500bb-0955-40e6-8f87-08de584d06ee
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2026 17:54:58.7122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U770UIprERKBEWOe+9hWAOI1TCUI3BHf+vqXeKV1XzfnOqhLBB95ijxLo9W7tQAnUpH0AZGGX9K2bX6y84OGcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7556
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-20_05,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601200149
X-Authority-Analysis: v=2.4 cv=PqqergM3 c=1 sm=1 tr=0 ts=696fc177 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=1XWaLZrsAAAA:8 a=PMdLvMOQuH6fsFwBsmsA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: df-bAJIB2j9OtlCIfJkuIO1yWbRlXod0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIwMDE0OSBTYWx0ZWRfX3QoQh6Iam+L0
 wJUlKDqniM+6/mWzE9jCwofzlboZaqsdor8Sb7fxZCYE/qKfkFF7OL3jUpJQYcKLq4alozY9eCo
 Enscv0ojZoeOBAqcwKbB8TY1RmpffSjrtlAr98HUfIb//RVG7jpqYX+OfOhyvBcefSF5whsgK2W
 FWGtVv6sRlroZ0ubwOLAD3VLYx1PQ5sE06T5u8hxterpsUnIWDh4LwQ9k9yssFr8NS71/yFTfNm
 PUGP0CiM7jTG90VZ+jTnzyYcrFPayviKbTas+QNDqfOyVlSoylpNqqfv8Pd9+0yPlA+CSHBLxma
 5jIvsVV0oS/bxgeUlr/y3tHbg7GnhL78OsKBApsIWTfZFxqY3jduZ9+goD4ciD58Klqe9/aV+dn
 ur1UyrRPaFql3HqEbAoxbjDmsN7yBeccR8agQTUmBa6vm4z09tgvtQN6W0Y3F8j+DKW+2SD+BKO
 nnAxo4GJ7V2yzW3E7gA==
X-Proofpoint-GUID: df-bAJIB2j9OtlCIfJkuIO1yWbRlXod0
X-Rspamd-Queue-Id: 6682340005
X-Stat-Signature: 1b4ndum5n7mqt515bdp6w75kd5bamzgn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768931715-370108
X-HE-Meta: U2FsdGVkX19m1d6I8EyDLaPKCHr9L6fR7kGOdDK6WLLEBwTLetcSpEXWaZ4nTzD1Q3n6sBp5LkaZZdnl6hYIcr1Xm5pd1k5634ySOaI69gKHhblP7zMiVyHmBNHQYZ5InYdRqlyYg9xUMftpp0fNeI3PloxanXSIWJHQKlJEpv6w98UJzpkcmFR7AT/1UcoVH+DRAp0y7kWYKlZWQNsfT/vfAF0IQj8fG569f8HBtZqTggMKsLpMevQjs7RwCCyn4DVzJ/E0kNE/tVscS3AKW3Wgu+8Xv20Rnj/CXfyqItl+kSuudOZ+9sTJQXrvKzvk3QUfYp0N6Xfrn+f5F3P596U0gjUB3oTZdMxMHeXeyvvHImvu+qNH18vJxI341XL00eSpW75KLqyEwZhAZwNAEkBcuLg8ynUvtlty2i16jg2Sb2imomPqztyIlGlz50Nu7xJ/tSzq26/iEOG7SixRRheSBmIX6rmPW/X4Q8U3mZXCLrKXM43YQOoe1FqSCwQ01CZbtxx28+//AyhTN/aF4IJlQItqJC1mMMOIzy96SbHbIODeXIFbQGjpQ56IikT3Np7rHyLSsTcd3DMH/yz8hMKlUXp4VsEnAM/jwfgCWPtUjtP2uMNoG/qUtwpT59KxcZUgsD4O8kMI780rf1kyRjpshzaj3D9+tZ8N24os4Ao4iaC8bYigXrwyAgUF+0JRuoyULv2iV9BIjg/wEBNn7tM8qU+Vurs0QeXLw+JS9CNTtHW2Fju60RvPfRVfJnT5HhX8y9iz2V9klAQSshqtx+72M4Fq3X9/7WH5VGCgNPmRf7bjK8mQ3o+aeHtBehlu4u3n6xvhkk0PwYWgj+lsy01Drh0buPpfkQIzIFr4ZctIzbWtv4Xe8rtZ7awkW8ltBsvhxR+Hz6D/yKEg6+kfIHq77EX6izCWM+Z1ehumKcQs2hidixPAV5fV+15VTIIuXwp9xInJek7glkEBErt
 4bn9y7za
 kp4nsiQhakCrxXz99UWLoZgLrrkWssT7S0OeB6Ozq4fpm5gNhcuezrvynMme1KqEky35TvXKSECP9Zrq2EDzTXGaIuf66vjxMn+PCEm7FXE3W8ubJiHU9AQ+IsAHrDHC4Xg6SYhB/M4n6pX1AWtszE7v+1d52oqwOToCT6/Z6YWMD+Y03aOComQ/mr2mQ8RpGrf6AZc86QMb5jP7pxCJpDp4UmLDLd/etHNT1HAS+DwPEcAhMs3T6UhhWpuNG3pX9JXmSXMThP4PXF3Xoe+iq4U9uS3+MsgJriT5HGyBXj/U89gloXLH3fJOY8lW5Q48I4qOB48N3InZcbBAXTo8yanNYVRkgjf9c0iEKQuoIMfIx5syaLsZRbq3Nb8C9/Z6qG09QvsApnH77+laf01zXeUyOnHIQGJV6bnvPeAkQm1kE/AQTaZ0gIH6kfVWKBTnHhAb8972n/cvhouhi+ErtjyuWfqkbk7RNFVrGpSSE9pbYzJwuO1wDT+RCR2mdSNce3GTtM+1d+XTC/8ZEFAXrNsEWgVYwSMvJFE39yTqwxLwQyA+iirIjI690b+JJutQdPaJIQGS7LWk+u9lcAZKQPts/CP1wOy3/9u8+XTNw8sDCvvFxwl4K3PhCGm+Jrlb+sfXjEH7cxHDHEh2UrRtJjM09Am6XTOupWiO+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [260118 06:00]:
> If you read the docs, it sounds like the difference between these
> functions is whether mas->index and mas->last are updated. However, if
> you read the implementation, you will instead find that the difference
> is whether NULL entries are skipped.

This is not the intent.

mas_ should return special values including the XA_ZERO_ENTRY.

mas_next() should get the next non-NULL value.

mas_next_range() should advance the maple state to the next range,
regardless of what is in the range (NULL, special, or a regular entry).

Both should update the mas->index and mas->last values, if it moves
(ie, no error state is encountered).

> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  lib/maple_tree.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 5aa4c95000188d3ba461418e09445be78098578e..fe0f0440cd84e7a0fe946d5371e651d153f40d21 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -5293,13 +5293,14 @@ static bool mas_next_setup(struct ma_state *mas, unsigned long max,
>  }
>  
>  /**
> - * mas_next() - Get the next entry.
> + * mas_next() - Advance the maple state to the next range, skipping zero entries.
>   * @mas: The maple state
>   * @max: The maximum index to check.
>   *
>   * Returns the next entry after @mas->index.
> + * Updates @mas->index and @mas->last to the range.
>   * Must hold rcu_read_lock or the write lock.
> - * Can return the zero entry.
> + * Skips entries reserved with XA_ZERO_ENTRY.
>   *
>   * Return: The next entry or %NULL
>   */
> @@ -5316,11 +5317,12 @@ void *mas_next(struct ma_state *mas, unsigned long max)
>  EXPORT_SYMBOL_GPL(mas_next);
>  
>  /**
> - * mas_next_range() - Advance the maple state to the next range
> + * mas_next_range() - Advance the maple state to the next range.
>   * @mas: The maple state
>   * @max: The maximum index to check.
>   *
> - * Sets @mas->index and @mas->last to the range.
> + * Returns the next entry after @mas->index.
> + * Updates @mas->index and @mas->last to the range.
>   * Must hold rcu_read_lock or the write lock.
>   * Can return the zero entry.
>   *
> 
> ---
> base-commit: 8f0b4cce4481fb22653697cced8d0d04027cb1e8
> change-id: 20260118-mas-next-doc-20171df817bd
> 
> Best regards,
> -- 
> Alice Ryhl <aliceryhl@google.com>
> 

