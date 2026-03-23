Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09B86F46139
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:25:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E286B0088; Mon, 23 Mar 2026 11:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E55A6B00A1; Mon, 23 Mar 2026 11:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ADBC6B00A2; Mon, 23 Mar 2026 11:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 285E66B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:25:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1EE113C121
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:25:11 +0000 (UTC)
X-FDA: 84577701222.06.ACF4551
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010067.outbound.protection.outlook.com [52.101.85.67])
	by imf20.hostedemail.com (Postfix) with ESMTP id C8C531C0002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:25:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y8sD5dx1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xnz888UTfqGTZxC09YaXCxdeSxQ1prmwFIP5TKbo7G4=;
	b=LUVV+GxJNL3fSrNSMcGCcYGvzoIsuUbRcUX+/W4QHMj22aP1RW42wTIzjo3sbSUPCW0D6R
	mp9ap8Iu+D/fdXRNpvkqvObABU9Hml5UWJsyFWxo7sRvavQadJoeCwFpuo/VM+5bFsV94E
	Xk15tya5EE+YNnYjmeUCCK0361D9z4w=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774279509; a=rsa-sha256;
	cv=pass;
	b=5vkkdHZx+XdNLS5cG+YWJNaKaKiVRH8mY66oTzOA3BnZifg8Ar+cSFaUAnckgIM/E7UzVD
	hDRjWz3JvD1KI74QUmIPJe1GHBUG7YqBfG4U+y704ZTS+rAduaA8JT8VU+sJDHLcVKtp70
	ezA1tRPCpKFdg4Wuvz6DQwjRUVywihk=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=Y8sD5dx1;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of ziy@nvidia.com designates 52.101.85.67 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NuXYm3X8dddky3arqJeDyWJuBOLQO7zsFpHTYRU9HF/OXCb1Nm7tnzAgCXJrLK7A2OXULXHERkr56cuidB/8Cs/JktsKvqIE+8WhUNl7wkKvtsyzYheb59UAFhGF3uU5nmyT+a0SNqk8PbMsQZuVAqRJrvvXso1r3H7qTfciA5ABW+13lTc4vtYabJiyDNTcyCiB/UAev1k2zkQbMFHW7QUQP3ivmUkKUa0ZlYkujXDfeBZ6LkOQb36Q0JptsAbDrLi9tnjqxyOsAEMWbVk2RR95fou8X7iGC//4HV0gpUGJU3+HEWn8BVTZQDF/R5+i7gZlslWQC4Ie0kFQFg2SuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xnz888UTfqGTZxC09YaXCxdeSxQ1prmwFIP5TKbo7G4=;
 b=Vude7oid7eTk7/ClfydPNl11JD70WGl7jyk8RAWEimFycRiamElnjAX2pqmIzxWJQ12uYqiCbe3tfyD2lY2e+/7K5cZGXsjkUDGHHLA6icpIu1LxbPOOylz9ULUblgY2K5aGlBpe3Y6nvKl/N8+lgP8QXByHebeh33z0LUPeFgzHrsmkHhTvKp0joNBwvLsj0LDfKwHLuWoeCSMm4MJyMlkt3pTFhUr3JkYkOzEnqicAJA/NBmytJiScl+uQegaIRd/XOXbDoIoQmkPjbqoWjreWDQHSxwxsBWgi33NPFow3NC6A5VXeB4nOqsBnvJNr5DQCWCRimmNxA9kJZCebKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xnz888UTfqGTZxC09YaXCxdeSxQ1prmwFIP5TKbo7G4=;
 b=Y8sD5dx1hfkpiBlJL7vqGEz/R0zSpcY7moUm+LBpNWLutKm4ahTZTTJhKojsZNPj7Cpq0qsAcj44I/FT9k4TlbXn1XZtH6km1mQvTNgLKz+3sOlQoHM0PHsBLxfaAFXeatpWnaXq0ou3L0w5aSb9jm0Khl3jL02RCGB/yV9eFxQCsX9bG0Zj7jKjRhj4quhiD5QumIXuDRw1lvdabAQRS6BoQ+UMOMl4lpOQvcOOUj9AJVfuye/pepUiluF2w7zJCXojnghffUkEnWxK8Gc/n44TSQ93ekGJB3pK6AhJrsoe5Ov2Y4cwSPmVsRm1d1U27z5kEnRtB7TqwXTo7+Wuvg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CYXPR12MB9428.namprd12.prod.outlook.com (2603:10b6:930:d5::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.20; Mon, 23 Mar 2026 15:25:01 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9745.007; Mon, 23 Mar 2026
 15:25:01 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Matthew Wilcox <willy@infradead.org>, Bas van Dijk <bas@dfinity.org>,
 Eero Kelly <eero.kelly@dfinity.org>,
 Andrew Battat <andrew.battat@dfinity.org>,
 Adam Bratschi-Kaye <adam.bratschikaye@dfinity.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v4] selftests/mm: add folio_split() and
 filemap_get_entry() race test
Date: Mon, 23 Mar 2026 11:24:56 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <31D74909-FE90-40B1-AAEA-91FE11DB88FF@nvidia.com>
In-Reply-To: <d509c511-6ec6-4eda-9803-bc74c193a0c7@kernel.org>
References: <20260320142219.375118-1-ziy@nvidia.com>
 <d509c511-6ec6-4eda-9803-bc74c193a0c7@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BLAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:208:32b::8) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CYXPR12MB9428:EE_
X-MS-Office365-Filtering-Correlation-Id: f27be001-6467-4997-d0ad-08de88f05998
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|18002099003|22082099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	acHZZ5vmomq52T9r0qxk96znyloBkUa9dokfjKZ1pPopvTYHouSBouIBXVEf/CKc6uJUG3I0RaJv4H3p73Dbrw6kWnxRzIPB9BSvi8b3HBlDGQZf4h43PvaOrTIBfCb+IywDbYJragXNTCKYxHF1FCYiSWj1gzxugOhlArfTE2+2kZSYGqYa45OWQDiml2MG4phVL2zm2iIHh+/8RDDwJ5a5vOElM3wclHPRmMI6nY/7ehfY74WbnNB2CcnjnChBobuNdTi+va/+qt+ozix7VFo3tBfB6XeqD16DU/xqKB9coU8jFSGjTH1prUSMyjDxrE2xFXH4RiU4UDUw4AkThL876+ILary9WB1N9z5ZE3sIHqOrumCD5P+kAWGTskATBj6cjSqaiHluEMskRv0UoZOS1/gvLmFBoyF+cdczLLpHk9B8ZhcWImV4zNZlIBtNFZ9eFhOwFUbMUmXzexQC0W5AtXm2NqwLwgG+7OvYsyXnfdORe2IvW22yWQZYKew76/fZH8lvrydb746lvf60XlhlxsGAdBY3LQH3blRaPxaK19QmosCDocy/gsBayqqQWR0uHyp4+5ZzLtrlmsmP+MGwq9gVTEBYYSUmhJDjSgu7l/fYVdtc3ZaXo5ydPATL5mFwQPVxAmmjRHjGa7OvRQbeGggy2myLtfv0vJWGSE05qh0yGhjwqC1wpfIZRgB7wlsNA6cuxn6Qq79g3JB+LkNFf6YKlKr3pW+JiFm1abnEfSTKzd1ke1CNyJRX6fKi
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(18002099003)(22082099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?onaBv14Tgx/W2xaErk7e1te4p1T1978CF0KjBIzVeiF+mnCmmndvCdv1bTef?=
 =?us-ascii?Q?COdn1RtNMeesH7G5Qb8oUrc8AUZ/TNqBhQj5h4DLyod3WNFL6Hi23OAOBsPh?=
 =?us-ascii?Q?6vWNtKGzsaNCPdKO6/VFEVGyDDGMdgG6XPFlBOxHkYFg9AQFp8kPrJHQjlx5?=
 =?us-ascii?Q?GFTu3NiaVJLYfHK2kR7U+AwH75p8jCnrGQpyl6Rt91Yb+a8C4zLUczP6s1GL?=
 =?us-ascii?Q?NxRVDhbPI0i5hSNAEWVlYL28zSp4C02dgZXS8cdyYdeaXCmCbbm2U/6KGWxh?=
 =?us-ascii?Q?yhAlvvKU/m+3UEryg0+iCn0wbVt1WczX4fP6bNUkD4EopE+/5oBIEKhb/Wxv?=
 =?us-ascii?Q?/bVNjaquoXwHYceteE//vHHkYdn42vOUj6O2NMgv77V8+IAC77x2lehLFsmt?=
 =?us-ascii?Q?XsmvWOQcKpIcjhQZbCjUPA4irg5Cuk08OLxHaDMBpDaUzWQc6c/f4yxK75jS?=
 =?us-ascii?Q?wsmotpl5vXSg2d+todpt49J5YSHQH154LbTlBnZ1qaQJmccR5AkGRe3C3QeA?=
 =?us-ascii?Q?n9jL4pJQc/5Z40Hle1DGVT7SEsnaJS8ADCNCQ0CO7D/Bo4VRFQoDRo/Qr09A?=
 =?us-ascii?Q?y6ZlrcxRUXihVQkXjREwOXmfgBbe9TWsof5H+U9/WTGA4aOBcI2gJl80kRql?=
 =?us-ascii?Q?ogNh2dxmLnqAc1YbDHBd7+38tcKqf0pfn8EKwo0vy8/druk2zYRgaPK1sHdB?=
 =?us-ascii?Q?Fusk+YKVHa+rTQow5kq8ZYktoyadsn1PWz/yYBKxS3rVRy8SkS0Dhy6M84r7?=
 =?us-ascii?Q?kRundYQt/ndo6/EalGf95HidfLL8iaWlKl7+jpMpdLXAWTCUPzyT8KeAkIdk?=
 =?us-ascii?Q?8JMps6tvfPG3yUe+WapOZVBbrph0M/OU2aahshMUqedLN6btb6iH1CDu7JdP?=
 =?us-ascii?Q?rq0I0m8dJpY6y0oCke9+OlWHjzQRVumpjdaarj1ra+oLathIEqo0i0aVsFWE?=
 =?us-ascii?Q?wMqJYCpqBNTqvSeD6gZj3/RIJPpgi8JxJ0fg9wNXF0/dyrpVH3u26FaJ6686?=
 =?us-ascii?Q?usBpjy7+sd93L7qrJp3E4pVBa1YkVqa3ORgV5SgLZXbpkflFOl0Ss6J1wcHK?=
 =?us-ascii?Q?oTvaT44nsFKjHPPlfJn+FFPW8jUu9XldGuDMmPWF/nBp3hOG5suUPk83PcIh?=
 =?us-ascii?Q?pdowfqiPz25E5O6J5pYXX7ucBc5K8oT4UnXdN7GqAtNChxDeKvMRwHFlkVb8?=
 =?us-ascii?Q?wKC6kiuPwiF29mIbAsI8EeTo6WH9ycAqWEmREmg0r238zrc859i8LUfbuf5x?=
 =?us-ascii?Q?+z/v2Yly6jo0BtNhf3YBCfPhaJBlDJjcRyNctNScnCMHP2Lqa2YDJ2tzFhCR?=
 =?us-ascii?Q?gTeFVPKPA1RssseoWtvYoH+Kg6OwikiBD6kjKdmpy499bqzHg8OyGfJFu6s7?=
 =?us-ascii?Q?VB1+YyhtdsXu0XKnsbDGqnqLKl3bJUSozMdGKwWdvdYGOE5K3kYiirApH+Xy?=
 =?us-ascii?Q?osFOH3Qor8OBDx9vae4vuPcF609iS4Y3MnxNTbf0W9AAJiZZcphQMf0EFUh0?=
 =?us-ascii?Q?UTIaVhM4a/pfPoksYKhFU1tKM7k8tkuu94vsYiwR3jlfqaS4w0kruYWFgNbI?=
 =?us-ascii?Q?qyM3Au6FVFbx1ftYopOjs/lfVVvnqYa69EA/aE2qbPqPcj0umLnCibSN9yRd?=
 =?us-ascii?Q?Vxg0I4KYhjBni1bKHYf7xZZtObezrjlAVfJ+AlU58M/lw3ecC3/cPXBVkEAx?=
 =?us-ascii?Q?9GM/HE3llch1fewLd6zvF/RqE3klxrD/N1dL4HfsoW1iPPtO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f27be001-6467-4997-d0ad-08de88f05998
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2026 15:25:01.2123
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PT4RoghP4CcQ3amq3CCZvWY1ZxF9lOqZFrL5ihWb/h3VbpvCtTB57AKraF93cOGt
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR12MB9428
X-Rspamd-Server: rspam12
X-Stat-Signature: oqmnc85p6bj39j9eu74ndf1eqigmx3f7
X-Rspamd-Queue-Id: C8C531C0002
X-Rspam-User: 
X-HE-Tag: 1774279508-986514
X-HE-Meta: U2FsdGVkX1/sOBrFXyFXtf3/8wQ8qyWfhRM7agkzqTmiYjusvP9DGFL589JfJ/lrXUjKWJuul8xCODMuHJWk6WwszGCfkiNsCOcXa36291a5nnSf52gJukzfrERX52vhBZ2JVJ8Yyiyldwp2Q4Rvvkd0+xyUoiVFBJxXACs3x4fZK4PcOz0s90Hutj63H1asn8YvtmMuTko2e9gyuQHq2RdjybTPHUzyAVaiqCDuqWYeumcXt56Banm0EddXGiFo5iodS589pYIOxeab45EAGltpepghQMSwOJKRsItD4Ji326grbkNCC/XPLOwYGXEJWhCCNSg7OeE7GwrTKvxZypZ793CnQEZNOlm3qO4e7MyEoERfDQRFHdPjhGgo7lUBs0WvIdaE5oD40xysLD81YTsqydJUTmgLKrn/eDBcSX6UjpgTubeyMx2kw5PA83nS4FP76f+DjWgxRj7dIUjaaxOl8+j+B2SG4hyCiDFvCpm7ldvGnoKA9AJUglOQF5y0L+wGx91IBkbj+CTlpPX4VnVJpnoPijNtlMIm7Rc9Xy5CxACHhV7FFbd3EVxi6WLOf10QAz7MuGVXzq9EUgtlzSIqMUwfU1rAdS63IBklzCx/PvpNKy+GML2HOzSCqN5YxHmiUaLZND1WG6JKcU2EKC2XPCzE4FthZfha3DfF7CGSPv99P3Hl0TvpZR9q/l4nrPjQ/cmNB36NBr2zqR7kJDpCfzGbywpqo1oAtA+nOrk4pulp1oQA/3BbsfWZj0UMaIKCN5zIlzYR7H9krMz8IL+P6ndpsbdsrj/ehG56O9Kvd0Nb0FWHuH66lPowgiAh7NjhzNdtZILypiRo+vee74sRVR2AbltNMn7cOuXPeAMOvYY67MKcXTPawDVEhlN7PI80wIhiQ8FWLh+B0wn0MuBHNmrAtvrdUbBE08SYM/snCIXzEeN9Itr/R5e872VXlCP+av1th9SSFuzJ4MZ
 eiEz7S4k
 WNpdfaJ6UvHv2gFjBibGS6kz5bhtk7SXyZAbCFeIGRe4yUM311crCrxQnMXZ71DYcj+KhJ1OXd7XZ58/e8ef+GIb/zYupGBhFytvzYwCCXH7Kby0jI1cs6/oOT5AGOGqFA7XGP96aoAJhcF739FI2BQAT4k6LuAtdQ96iOgZ7cKV3LStHoyOMvb5oIoU6WhYg8J3WRS3MM3q6YlS2pDFKHaHPQxYR1WS1+JlxEclTYYDB2GYaiSqFFR4kcRLfAvOAjHzWJoQWtrsx3roeg7PLLeejwp0gnCNLA/O4YMLHTqKovWX4Gs1Vc/vombTssDCEM5SknG6FoOY1VUn9Us6ITkTUNhLr9AtZt3Y06W7f4gvbVuANdjWcIt5rsHmaxKJBrlyZkCMQOCq2Ke8cCI8KFxGvfckX2jmsvbRujNnWAd2e7lQ8mCEOgF10eZuSdmCzGOPKU2Xv+Cu/yyKmCiOtYmqapvYURJMFjZbmgD/CKn45a9/fpWdWOddRe21e8xfnfyzBOA3sw4HMGQtZw/XjWdPzoo9+ieSUnm91nALXeLqy+Y0StmoUNnjs4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 23 Mar 2026, at 8:48, David Hildenbrand (Arm) wrote:

> On 3/20/26 15:22, Zi Yan wrote:
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
>
> You are likely missing two Co-developed-by.
>
> See Documentation/process/submitting-patches.rst on how to handle such
> SOBs.

Will add them.

>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>> From V3:
>> 1. fixed for loop stepping issue
>> 2. used PRIu64 instead of %zu for uint64_t.
>>
>> From V2:
>> 1. simplied the program by removing fork.
>>
>> From V1:
>> 1. added prctl(PR_SET_PDEATHSIG, SIGTERM) to avoid child looping
>>    forever.
>> 2. removed page_idx % PUNCH_INTERVAL >=3D 0, since it is a nop. Added =
a
>>    comment.
>> 3. added a child process status check to prevent parent looping foreve=
r
>>    and record that as a failure.
>> 4. used ksft_exit_skip() instead of ksft_finished() when the program i=
s
>>    not running as root.
>> 5. restored THP settings properly when the program exits abnormally.
>>  tools/testing/selftests/mm/Makefile           |   1 +
>>  .../selftests/mm/folio_split_race_test.c      | 293 +++++++++++++++++=
+
>>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +
>>  3 files changed, 296 insertions(+)
>>  create mode 100644 tools/testing/selftests/mm/folio_split_race_test.c=

>>
>> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selft=
ests/mm/Makefile
>> index 7a5de4e9bf520..cd24596cdd27e 100644
>> --- a/tools/testing/selftests/mm/Makefile
>> +++ b/tools/testing/selftests/mm/Makefile
>> @@ -105,6 +105,7 @@ TEST_GEN_FILES +=3D droppable
>>  TEST_GEN_FILES +=3D guard-regions
>>  TEST_GEN_FILES +=3D merge
>>  TEST_GEN_FILES +=3D rmap
>> +TEST_GEN_FILES +=3D folio_split_race_test
>>
>>  ifneq ($(ARCH),arm64)
>>  TEST_GEN_FILES +=3D soft-dirty
>> diff --git a/tools/testing/selftests/mm/folio_split_race_test.c b/tool=
s/testing/selftests/mm/folio_split_race_test.c
>> new file mode 100644
>> index 0000000000000..c264cc625a7cb
>> --- /dev/null
>> +++ b/tools/testing/selftests/mm/folio_split_race_test.c
>> @@ -0,0 +1,293 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * The test creates shmem PMD huge pages, fills all pages with known =
patterns,
>> + * then continuously verifies non-punched pages with 16 threads. Mean=
while, the
>> + * main thread punches holes via MADV_REMOVE on the shmem.
>> + *
>> + * It tests the race condition between folio_split() and filemap_get_=
entry(),
>> + * where the hole punches on shmem lead to folio_split() and reading =
the shmem
>> + * lead to filemap_get_entry().
>> + */
>> +
>> +#define _GNU_SOURCE
>> +#include <errno.h>
>> +#include <inttypes.h>
>> +#include <linux/mman.h>
>> +#include <pthread.h>
>> +#include <stdatomic.h>
>> +#include <stdbool.h>
>> +#include <stdint.h>
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <sys/mman.h>
>> +#include <signal.h>
>> +#include <unistd.h>
>> +#include "vm_util.h"
>> +#include "kselftest.h"
>> +#include "thp_settings.h"
>
>
> [...] some comment son the main() part :)
>
>> +int main(void)
>> +{
>> +	struct thp_settings current_settings;
>> +	bool failed =3D false;
>> +	size_t failures;
>> +	size_t iter;
>
> Why are iterations a "size_t" ? Similarly for "failures". Just use int =
/ unsigned long?

Will change them.

>
>> +
>> +	ksft_print_header();
>> +
>> +	if (!thp_is_enabled())
>> +		ksft_exit_skip("Transparent Hugepages not available\n");
>
> Is checking thp_is_enabled() the right thing to do when you perform you=
r own setup below either way?
>
> I think you should just use thp_available(). Then, configure THP accord=
ingly below?

OK, will use thp_available().

>
>> +
>> +	if (geteuid() !=3D 0)
>> +		ksft_exit_skip("Please run the test as root\n");
>> +
>> +	thp_save_settings();
>> +	/* make sure thp settings are restored */
>> +	if (atexit(thp_settings_cleanup) !=3D 0)
>> +		ksft_exit_fail_msg("atexit failed\n");
>> +
>> +	signal(SIGINT, thp_cleanup_handler);
>> +	signal(SIGTERM, thp_cleanup_handler);
>> +
>> +	thp_read_settings(&current_settings);
>> +	current_settings.shmem_enabled =3D SHMEM_ADVISE;
>> +	thp_write_settings(&current_settings);
>> +
>> +	ksft_set_plan(1);
>> +
>> +	page_size =3D getpagesize();
>> +	pmd_pagesize =3D read_pmd_pagesize();
>
> I wonder whether we should check for 0 here and skip the test (older ke=
rnels?).

OK, will take care of that.

>
>> +
>> +	ksft_print_msg("folio split race test\n");
>> +	ksft_print_msg("=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D\n");
>> +	ksft_print_msg("Shmem size:       %" PRIu64 " MiB\n", FILE_SIZE / 10=
24 / 1024);
>> +	ksft_print_msg("Total pages:     %" PRIu64 "\n", TOTAL_PAGES);
>> +	ksft_print_msg("Child readers:   %d\n", NUM_READER_THREADS);
>> +	ksft_print_msg("Punching every %dth to %dth page\n", PUNCH_INTERVAL,=

>> +		       PUNCH_INTERVAL + PUNCH_SIZE_FACTOR);
>> +	ksft_print_msg("Iterations:      %d\n", NUM_ITERATIONS);
>
>
> I don't think printing static test information is that helpful.
> Do we need all that at all?

To provide some information on what this test is doing? I am OK with
removing them, but one will need to check the source code to get an idea.=


>
>
>> +
>> +	for (iter =3D 1; iter <=3D NUM_ITERATIONS; iter++) {
>
> Why not start at 0? You know, to confuse less people :)
>
> 	for (iter =3D 0; iter < NUM_ITERATIONS; iter++) {

Will change it.

>
>> +		failures =3D run_iteration();
>
> "corrupted_pages" ?
>
>> +		if (failures > 0) {
>> +			failed =3D true;
>
> Do you really need that variable?
>
>> +			ksft_print_msg(
>> +				"FAILED on iteration %zu: %zu pages corrupted by MADV_REMOVE!\n",=

>> +				iter, failures);
>
> Can that simply be printed below?
>
> Like
>
> if (iter < NUM_ITERATIONS) {
> 	ksft_test_result_fail("Test failed on iterations %zu: %zu pages ...\n"=
,
> 			      iter + 1, corrupted_pages);
> } else {
> 	ksft_test_result_pass ...
> }
>

Sure, will simplify it. Thanks for the feedback.

>> +			break;
>> +		}
>> +	}
>> +
>> +	if (failed) {
>> +		ksft_test_result_fail("Test failed\n");
>> +		ksft_exit_fail();
>> +	} else {
>> +		ksft_test_result_pass("All %d iterations passed\n",
>> +				      NUM_ITERATIONS);
>> +		ksft_exit_pass();
>> +	}
>> +
>> +	return 0;
> -- =

> Cheers,
>
> David


Best Regards,
Yan, Zi

