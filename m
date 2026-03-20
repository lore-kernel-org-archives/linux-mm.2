Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF131099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 17:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4DF6B00B7; Fri, 20 Mar 2026 13:58:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B5A6B00CB; Fri, 20 Mar 2026 13:58:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B0D46B00CD; Fri, 20 Mar 2026 13:58:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D0936B00B7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:58:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C0FAAB7FB7
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:58:35 +0000 (UTC)
X-FDA: 84567201390.27.18C992B
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id DB794C0008
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 17:58:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eo5eDyhg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774029513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6QG9zd7Q/rBDOMchkce76DkwPL4OZVWmXbO7OvcHzQ=;
	b=Yop/xoxfl1CxWZF+Iy+/y3VTxqpE1MMnqYI0LDEOlGUzt09AMU36/hFkWvpMwolF+tfFPd
	8SSQpYbKN4njm/fV4TLXeaI+IgfR2uBAKuRb60QyLb72BWUYy4OX0sTLF4zRqhvxGw0gFu
	2IgcrZ+N8UcEBLtBDP7Oz7Oh8ZL3Xlw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774029513; a=rsa-sha256;
	cv=pass;
	b=xehcNXLMjw23Erkus0UdPwZfGax2XokG65jN0ik0S42iNhj6RWSmMsN0JGHERkJ3zmBfb8
	ZeSBFUfKQVuUtxmACx2Bt7141jkK445O/mrBW8EyduU2sVzfAS899gqOdso6l/4dVXDih6
	hhrXDTlFqFACoEuhAj569ePR1xrQcKc=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eo5eDyhg;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.50 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jXWta5vqLq0Ymi63V44aj76abW2YAZJEs5r6g2RLhrgu6RYGJtE7MnV2/YTmhULWKlPJK4mchwO+GOw4N8wjMR7cZwBf2dgAJQ3nARIgNFSh8P6rhEdESMIg6p8qENDaHXpR8SdoNGviMPGynY/TkH8kC45zr0OjsEcpByxAEELZSBRJ/MtUdOPHFHEGS4xh8sZXyd0J39CjAg0vv3wGxjFEX21Vs8G8R8xfoCW3C0OjyjspSrY90+mkMS9Da61u7wWtXxhEV5bMCC6KEKCdNJpBHsERYYi6rv/64Wk9eu95JQ6hLhz/7bx6vWkHYN0yGQzg+7OVB+yzBWsgQ3w6GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C6QG9zd7Q/rBDOMchkce76DkwPL4OZVWmXbO7OvcHzQ=;
 b=p9IAtVnzTYS1rjvwUZRj5ioik4u7w+lUq0kA7vESlYPLuVTO7n6LLWwEwBuhxJjKqTDEnSvQV1kHfPY27yPu0wRktHEl5kBeRh7k8SXWZkMvzji374BOjMoAigkaCZQGB0gv29n1mOIr78zixN8FK2p/NhYkLIGb8vVm/DFf4vCJDYWR5ujkc/6Ql0YfnDHXoAAPpn+UCE3g6DQHTRXyRawiM1Dwlc8xAKxGNwK3PFFKhAG1Z/CAM3LqGKLKGKeNVfFJxTo6BK3thbNhcDlGhdcKQHbr5vvNuhqFLO26E72GQhRqJe0Ec1wk+bz2f2lg5dnuF+fXNUD8JP10v0JRlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C6QG9zd7Q/rBDOMchkce76DkwPL4OZVWmXbO7OvcHzQ=;
 b=eo5eDyhgoFSasd/XEvCc70Pa20bxhsXVfUUxPYGTg2C14qWyTnqxFvNojWa0bP/1SA4Q25yDY+Y4W1RAq5+LVAQ8WJRgugcU/+Cxp0qhtGxWfyLN+haNDKzRKj9aG3HbMCRyfQAyJhct75BO/+S5e0xFdB3dlZAJUlKLEXbRp3LsJoFj0mLWiJCA/PE/PRlIruYuhUkiF3eVNp5n8IJmW19C2YuEHjjb33Y4W6lUfkHJ2i3Qeos7DhafAoJMVPQ10B9IfY2sHVGFaV1H5BUNn1FkPq76mwcs35BElc+eFr4Y8AlJ+JTvRdohiUeJqQCCtvv/hNriuQoKH35yAe05aA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 SA1PR12MB6993.namprd12.prod.outlook.com (2603:10b6:806:24c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9745.9; Fri, 20 Mar
 2026 17:58:24 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Fri, 20 Mar 2026
 17:58:24 +0000
From: Zi Yan <ziy@nvidia.com>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v3] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Fri, 20 Mar 2026 13:58:18 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D60C0C65-11E3-4060-9295-B67F90E9D774@nvidia.com>
In-Reply-To: <6b087c27-a5d5-4f49-81e6-1204209b0c89@lucifer.local>
References: <20260319190409.294523-1-ziy@nvidia.com>
 <6b087c27-a5d5-4f49-81e6-1204209b0c89@lucifer.local>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: SJ0PR13CA0126.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::11) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|SA1PR12MB6993:EE_
X-MS-Office365-Filtering-Correlation-Id: 93c0c8b3-04a5-49aa-8716-08de86aa47b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|7416014|366016|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	tkVrHk1sqFBkNISEhIqvibTMHFoy4pNt7NDw2u/EqCZAHtc6q4u8V27MOCiac4EFf/bVbvlD+wVvmihm9xUGCaRztWzX7ChbnzDodzcEcTMD13pIYSwRI9lCgOuuructWogNQ1X7VVCWpBaQEFVAIexmjjjXjkJY8NbODno50KXBnRiXKQQ/HlEYvQq29xy7icBOl8StSzxFMzROqsqSefgWd012yzxEw+qatgTLHcLth/y/Vi69Q9HV/bwH93iprTXxzmQFU+ua9TKTDGZWXOxulYRzARERIS2XGHtgVNzxrMKci9Br2LgtbadPriXpGz/e7hniZfrsla8F5uYwfvEB/72h63LMBYZdaStTy9nKu5/8Vprb3r4gYhU0IjtxJnCSPbn86ZLGra8RkGqq3WiQ98VxelDn++mppOfs+OkRtOQzIMHXDNEf9jJiC4Pb8UfMEEMgmYsP6ud+d5UFF0iFO1CHDKM2dFcfL235e0kOXyWmG8X7rsVrdtLFJmDOEs/JgI4wfN+JlTCTfsBbQBD0406zaDXX607wY9fwQpi4ykSnXORIAUnP1YJ8pMfsXNZG+cAsTSr2KSB1UISmJ3da/EM77KmZf7SQhi35PcSGtbhDyEvL7PdeMdiDflNxnzObG8rbjUkOzipXJXZRWyKi/MsaHyCqr5YoaxKaAKNB6zpq9/h8h8hH6oStbWOyG+ZTQBLKUeSxv6eBZIDNr8lXML8KPY9oRtyUslKrk2Bx+my2DihC2HTZTBUGy4N2
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wBVjC4BuPZ1KX/E/JsLKRnUz0xOukUHwndAoEflPnKmmLVMujIj1Hssdy/GQ?=
 =?us-ascii?Q?jOsJJ0JxIQ3nhVG5P1scjkAMfqBD30QnwIclsKi464ds5jhLSkj78wJULTMb?=
 =?us-ascii?Q?weVdU7O2wFeShPjx8q1rQoUrdsMJgDsYBVTF4wR5uKEKCa2Sc/ONLuaivmSy?=
 =?us-ascii?Q?YWgZm8aPQzs7gIY0A3M9b6EAOXhmE+CGhIjK1kQCoxA7a1E2h5C5S1wBnHYp?=
 =?us-ascii?Q?Q93wPxIcSIXkL6s7wXid1YbFdDoQicJVR4iiyGjMOO2S9zxFc2uH8nxxzcU9?=
 =?us-ascii?Q?GjejdIHc+i+M7rNFWmL2L1awDLcQaTABXd8lKlKchLPiIgS4xBYHDses06vh?=
 =?us-ascii?Q?5J5ZuROio8WOVszrGVitJ8OCFgAB5AnnzBY7Yq3w1fkvbHjhFQ+Xiqut+I+B?=
 =?us-ascii?Q?h+Lmeiw7jLLyfMeoUUPMTf6aPSUDaG5aR17Cdr/TwYYHiQlu/vC2tC9+849E?=
 =?us-ascii?Q?N2uYT+VeY2wSS+bPLRFqlKozhp1wnZUB5mPJIlB4SMn4TqGjqYGeIhYCn30r?=
 =?us-ascii?Q?yRYCGxFJEWO9Q3icnHF/omdVcQ2IhmcoANQtcLp25z1j//Cfqbq5hY09Xbav?=
 =?us-ascii?Q?fxgc7ct2xmJSRQ3OQgdkVtq5rR4nsPCcxathr4C3hjMafse1hhy7RgV7TK43?=
 =?us-ascii?Q?6OkOp4WMEeB3IiL8fVtWHUVUGoR1A1eWPWdaLTL3Aju1m5krDlhYDWUP6BZy?=
 =?us-ascii?Q?XEDjU5T6dODnJl6Y2gHG7kdvWdJ+cCTboiLXEoXnYE/d61j0uyGlklWbgTCt?=
 =?us-ascii?Q?EEsoMysoDqWHxogst9pcn3ulYJ+VFW5M1YgiA8UKaCwjxGMTtJk2rMRZhnsL?=
 =?us-ascii?Q?lziOaPsOLfuUGrf5/33Q6IeBFSlZQVgN2HeAIoPKA+k8OIHI6+Q88s12aWQQ?=
 =?us-ascii?Q?IBvDC7n/ssbDiA5O32OphqFlH7LuwI2k4pHoolPMawgKXAW/LkHeq1HmT6Jk?=
 =?us-ascii?Q?3RJ9OfqhfvMDdCOmatnJmCnZXbaZ/rBYewWiBRQLVjb0Ak3Rt6XvLhiJJ+UY?=
 =?us-ascii?Q?PwoOVDSGOROaZ9rN6whq+0hpN5bF2RuPVA0VEO+DpsJm+Md3u1h8dDqQM9lB?=
 =?us-ascii?Q?rQb7MYDVoB1rmURg5Lj45e/LcEtJNEjvsuf5pxeMVtEsiVNem1gCmXNGiQHj?=
 =?us-ascii?Q?yREif48/9mJrbiXSE5Q4sYaTsW2LolJd6iVXM5UeguqhoZDzBxu7fG24EIzp?=
 =?us-ascii?Q?Ky8ZtGaA8i2f5nVaYDwfIVGFrSXywUI9FmYB90/ghB8p+Si+e3G1WDAOzS81?=
 =?us-ascii?Q?hLZLmIi9LSE4xEvsR2iifT1zWKvPlWaRM4j472LFr8TxqDUBfK1gL4NTgdzP?=
 =?us-ascii?Q?UDxW7CwVigD3xahVFv4nxdsM+lTqGI7nETM4vlPyeu+0/haVfPIrEmTaRhd2?=
 =?us-ascii?Q?1zWtY2WixxJZJzKMzgQQvAw/XPkFEAPgGOwRAnKYuA4oOaviVg4cG2awfSmE?=
 =?us-ascii?Q?lFLES7YGXMD73ZTqdZ4JapGtrzVgf+H8EkwiUVAwUSH/yCngK4nZqr3rBOmE?=
 =?us-ascii?Q?jheD+TgmK4d0nJ0SPxAnPEiEYI96wlAL9PvG0AUh0tDD3mLrEm5oObbF/nE8?=
 =?us-ascii?Q?dcQCTFo3oBFBVa3cWxqeW5u8dg6qOr0wAHHBbZpUgvQQmxHMWekNRaSppuyX?=
 =?us-ascii?Q?TBut+BtBB2QCTL4bqAGp8Cs0AmrKvLjkct+7G/mXt+2ARYhDPicnY+N35/Pn?=
 =?us-ascii?Q?f0rkHwVnHqTs7QM73Ph+pLQcYPewMhz7PGw5j8J394+8uElQ121xjjoxqEtU?=
 =?us-ascii?Q?/GyJyAtQag=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 93c0c8b3-04a5-49aa-8716-08de86aa47b3
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2026 17:58:24.0525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffTkfVYLdCKwnjoC0jg3fjqvZDe32a1n/HrLj535zxRIN9vblftlQePs3BSgIoCk
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB6993
X-Rspam-User: 
X-Stat-Signature: xkjccwwmqfxcpexa683yyhewjh3dyiur
X-Rspamd-Queue-Id: DB794C0008
X-Rspamd-Server: rspam03
X-HE-Tag: 1774029512-975846
X-HE-Meta: U2FsdGVkX19SaXio0mJn2ayajCcYi5752IB0zsRDGvwhMBz26EYn9FgMzXwmW/N+8BHo5FNwHCCDwtqgIueUBTORQyezqyHQAbkpGRzPnOpvD9wQnrUSEpk4unCI0LSEq7wsKISXNzRvy4YW21d5mUV3T5bjYZW4ENrWrnjdcIHocbFJeQ4le1avbysHPkT3SqGD1yVY8jsVGk3e7K1oU/aodE2qbaNS+QHQZf0KS33sA0W38f1QzfWWSbgD5OgToFB1KjGpa+eqTne8vbT9PyhMH/obbpRhZF19xka1jjlNtIUJrKjPqXWqKAH0q8nLzlOfLyp7g4EalMSwXuFx24leDj4NaNrd/214trlUF9q3ipLrumnHWz5Typ8dCXGOXub54U4l/CTH6oXUPrUn7hmljrXoQmRU1VJPaHglfHIhMXFt0aCzoVvuVpFSa9+Z+3QKkolx7DhF5RqyWnSOeyWuV5kDJFr6bO0U2+PAPmEogeIYGVSApSddI4DsSbA2dhmOD4CVAe/PqcoTX527T35rq0IInzwltVAcfABuDKxZSOsb7lIXKmMU+K2FMNqx88ubz+23gaotB5Om3Y5Yl8l1IYonv4os8oYs7R1DCPyXinS+RfftOgCIKJhZ3E7rDKrrY4j1uYCaaWFieGfJLUF+CmRG10OqRtejzjKqG2HozC1TIRRp/ZlyAmomXQJlRyUCMfFsIrn3ZMd+9DpoRMbhMhQLEGZQmg22vAKAoNMHyYnRmCEUDUzorj7+Px95EzIVqJPTmSzUCsgmbiK19U4MT4IwkbLqWm+eemv9x8K7Bak7rUDwFq+6QB4C1YTey3KZIs965MmTztmuSQUfHtGsy89y3zh6PR/TLVFrshBgg1/aEqLzvuOWkrHTJzfmGJ1B5XQx/Dpxb1ap37X1EhEbKqQvEK4UiqxSam3opob8lUCWnq+BLVlzQKRuIfIhEhwpDCK2sGnzttB/A0P
 kS5CXwPH
 jNkSdfQxIrMDD37lvpcF2BvwO6PpISX1cIjbDdW+4s0uZ6mreVGv0d4TbGcohwQFN2UnLlp4GyPw3aCQpDLVg4B6hqgXxCsfmknHvcPxCxRos1EU5Q86BLl+ReH4PbTh5JgZgrZ1Qrl0uo4tI5sClgpELBWYxA5YWJNIobZv25l5jktRJpU4kVtZ458hN3r3+o+aRv/brxgUBpcFC+F1i9cr8pMYEXNLtHzs013KdSAuGTRQGcb9dgvB4sY7Rk/i94fYyrOEturbXgr0wv44x3HPMRQRHP3Cl/lq0y6d5QlA3FXQyLOD1WQYsnrlyr5EqBjdMvRPPY7pKDpiKmBbee5Eid4d2sVZ0WsMNDcroi/AZTuFkTJJX6yt9jhY3rs641pdNEg6GVm5hAxP0Ta9XivDNaJcE+BHpz5nYrsKXughdkRDdKAP8VylHscCq/Kbgaislxv/36hZAdxruF/y4xM+Pfk5/7KFnf/6W8BpmoVFwaYuadlQ02HybeLC5CKYeq9JBWYZ6dPi/jcaJE+oaDCEKXiUubTpf87P72LsCv6rgGqb2tzkwzvxmeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20 Mar 2026, at 13:53, Lorenzo Stoakes (Oracle) wrote:

> (-cc old email)
>
> On Thu, Mar 19, 2026 at 03:04:08PM -0400, Zi Yan wrote:
>> The added folio_split_race_test is a modified C port of the race condi=
tion
>> test from [1]. The test creates shmem huge pages, where the main threa=
d
>> punches holes in the shmem to cause folio_split() in the kernel and
>> a set of 16 threads reads the shmem to cause filemap_get_entry() in th=
e
>> kernel. filemap_get_entry() reads the folio and xarray split by
>> folio_split() locklessly. The original test[2] is written in rust and =
uses
>> memfd (shmem backed). This C port uses shmem directly and use a single=

>> process.
>>
>> Note: the initial rust to C conversion is done by Cursor.
>>
>> Link: https://lore.kernel.org/all/CAKNNEtw5_kZomhkugedKMPOG-sxs5Q5OLum=
WJdiWXv+C9Yct0w@mail.gmail.com/ [1]
>> Link: https://github.com/dfinity/thp-madv-remove-test [2]
>> Signed-off-by: Bas van Dijk <bas@dfinity.org>
>> Signed-off-by: Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>
> No .gitignore entry? :)
>
> (Just saw it flag up locally in git status)
>
> Linus says don't remove, but he doesn't say don't add :P

I did not know about that. The fixup is below. Thank you for pointing it =
out.

=46rom bd164a7090c0e8b6e3013502c64c161214e38714 Mon Sep 17 00:00:00 2001
From: Zi Yan <ziy@nvidia.com>
Date: Fri, 20 Mar 2026 13:56:04 -0400
Subject: [PATCH] git: add generated binary into gitignore

Signed-off-by: Zi Yan <ziy@nvidia.com>
---
 tools/testing/selftests/mm/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/.gitignore b/tools/testing/selfte=
sts/mm/.gitignore
index 83ad9454dd9d1..b0c30c5ee9e30 100644
--- a/tools/testing/selftests/mm/.gitignore
+++ b/tools/testing/selftests/mm/.gitignore
@@ -61,3 +61,4 @@ guard-regions
 merge
 prctl_thp_disable
 rmap
+folio_split_race_test
-- =

2.51.0



Best Regards,
Yan, Zi

