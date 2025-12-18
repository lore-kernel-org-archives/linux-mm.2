Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B58D6D232
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 15:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDAE56B0098; Thu, 18 Dec 2025 10:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAB586B009D; Thu, 18 Dec 2025 10:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A236B009E; Thu, 18 Dec 2025 10:54:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5E0E6B0098
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:54:39 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B28C57744
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:54:39 +0000 (UTC)
X-FDA: 84233039478.28.23B5FAD
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012045.outbound.protection.outlook.com [52.101.43.45])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB4DC100007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 15:54:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=geUy1JgY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766073276; a=rsa-sha256;
	cv=pass;
	b=Dk4jeUzyddffTPIkAHjftW4gbI0HHkaIBANVa9UHOnkHZx4RtlVgD1xalFm22QnDpxk6Cd
	Uk13mSKxBq5jA7PbSmlUEMEAKHT45kTdtaa8bbiEJv6H9x0dxHZvFsqqgeSTBsPK/eERyB
	DBB1xmIM+LirSoXfcTj9kIEPiH4pWcY=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=geUy1JgY;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf05.hostedemail.com: domain of ziy@nvidia.com designates 52.101.43.45 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766073276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ubOI3RAdhIpJWqIrFgi+2kr5PF4dCzie2rZziYOzxKY=;
	b=lAJXCBxS87dFYdLR1P83/i7dUGsYzIiWR8ofvl3yqxddaHYvcdmwf3ci9IhJz92iLt9Xsf
	E6IN1hNldSgpW1i8fKfqII61R0qqzAPzdepUNfm/kpzm9PdKnffuqZTACkN2aKs28ytxga
	D1222bhZPRLrCow5LVGLMrG6e9X+s3g=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=q1uLEaINZDa4m7L5fSPTTwJgUUqZLgfy3xElPQcwr8gnBQt7UZFGRvXqjcDr/PQjvyloB+5qFhBjP/toT9ugaGUFW3ft0bZOxg7d5cVjCytiwnOyKZsZNpfndZwrMw3zx2VlYzn1jBbu05FK59aTmaHXtSyVYRlMA5TqdfKP+D6OSRg6wGQqRXHmpsIsVQGdAjRByGJl9Zc1Eej/CrwJA++Rhg28nGHn8DYicuDq449nbkiEK1eROfgFvM215pDfGmOOe6TfUwoVPoff/suMQ4ILYlAXQVYow8J9dVw7kTypgSsYuJhVGU9dTN4TOuIpdXe7H3MX0+WJJpTd4eoCBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ubOI3RAdhIpJWqIrFgi+2kr5PF4dCzie2rZziYOzxKY=;
 b=Is+e/s8oZnhxWWPV8FVKdQNo1tOVESRGd2Y2iJqgRRRLdNkrcgN11eVrztbyrwJBTL2dLcxW67x7bEdlc5ZtzMxGb9qxRaS6HuozOxu0fVWemeJMHtQ9gRiCHXo+dGa9cPKOwOAtQ2TDM38MYyhLTK1NWDBoVgS6E1i9wJU3s+FYsN5kkqfCklX9EstiZfiJ+4wpvAwL+tSBGYVSP/4c/Tb4kDYs2vhDmezSBN9immIhQZgOi0zVhv1UEheNExWXrqpkpP0W1oufStT1nTNYIptmadoeh06hzzl+QcJeD2qqVWxMwUaHW1VL0v2a3l6KTVeugVuJaaYrDGoEgXgR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ubOI3RAdhIpJWqIrFgi+2kr5PF4dCzie2rZziYOzxKY=;
 b=geUy1JgYEgRiUKc95Sn3rnCqVEi1lvwVl10IGEhfxmIZnRtq5+fSHR7ajZJOvilZ8njQA/Xo3LG67iQpcpZ/N3/mgMag0hD8C3Cp1tTbyhxfMMTkuo7FYCPaVm0OK+d1fUm0NUE59PFjuro+Ra4vIuv6MarOg80xEXeVdC/R19Nt1L6b4mmjHn6I01Vmua7swLcCAYqjE+Xa4IbxlPt96Pij6leaaqHlok0LbY6gbjKhcM5C1bpdt1zJ7xd0hiNOT/LjdcVDAX8m9QcsGOkTd4KZQGZjdlN/IRuo8V6LywGyFf1JnO9HvkPmLuCpi9RDmmJ5dpgiWSOv2gzBuJUYZQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9434.8; Thu, 18 Dec
 2025 15:54:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9434.001; Thu, 18 Dec 2025
 15:54:32 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: "Garg, Shivank" <shivankg@amd.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/khugepaged: use enum scan_result for result
 variables
Date: Thu, 18 Dec 2025 10:54:30 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B6AB9DAB-7985-44F0-A0D0-9FE77D3853B5@nvidia.com>
In-Reply-To: <b75674c4-2439-4515-9b4c-bc3d40f76fc9@kernel.org>
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-6-shivankg@amd.com>
 <D9E6B402-528B-46F2-B4B0-9CD9549A449F@nvidia.com>
 <79fb5cb2-8a24-4260-a9e9-bdf2c5ef602f@amd.com>
 <b75674c4-2439-4515-9b4c-bc3d40f76fc9@kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL6PEPF00013DF7.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:9) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BL1PR12MB5825:EE_
X-MS-Office365-Filtering-Correlation-Id: 46a4d51b-83d1-4441-359e-08de3e4dbc1c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gFBASXaZy4kK5UCUYQMDtRIQEcDGeunysB1d4uTu9r26LG5nMnP6iOBHpLK7?=
 =?us-ascii?Q?dDKAffloZOtMNLDjekNYu7Ox1MsCy+rN4bLW27ZEB9laocB7KrT/y/7PniTF?=
 =?us-ascii?Q?ZCfP2THbikb+YLpiHqCMHzwwOuOqtNQcoxUPnMYhc5vSljJpmtIwE/9UI0sx?=
 =?us-ascii?Q?NYSSywTcz0h+vV1pWQSWIII4NTJdkF7HWUBOHhboIX35i7SzwwqM05GS7IC1?=
 =?us-ascii?Q?dFwNTVzbec8xHWexBOYcul7xkqfScbQsbGi+OJiTD/6hG2oDp3GjBcAKRw5z?=
 =?us-ascii?Q?89KIEzNoTLaDv7tyNsXgk6JpNsK3NG4TtAIL6NVnDTRjUZenK6fEakHK53t2?=
 =?us-ascii?Q?UKyGRJ+38HNXScQzqhtFl8nPz6oryIFWfF+Rdl3o7i7LZMxeAAdHKvu8LfDz?=
 =?us-ascii?Q?bZnaHCSOP41NeHa1UTO4aPhtxYHx7woWKqIrKgLIKN/I8RGx9NJL4Wtdv6Yu?=
 =?us-ascii?Q?C/iBdWVG7X55pTqjTVFEm9KR82TVkJ9l7VcaxvqAkx/nEV8IveizNGamV8s6?=
 =?us-ascii?Q?uVJ2qx1Gngtl9vNMqUupzpidNvwwjHpMixFu9ZGE3Y8IxsaBkJ4bkWYsQqho?=
 =?us-ascii?Q?eEQVED2QPsqr9s3z/ciFERDqZw+Qz0oW6lSL68dWmVvt+66fIimu51sEj7ir?=
 =?us-ascii?Q?gIlvxeFuB5SLTlk3c+/dfAvqvhY3+7v+hilvPDY5qvWEFOyoTI1eIRXA3DrB?=
 =?us-ascii?Q?BbeVrACoB6JnHKJWx9wVYODTUr7gAslHzOZEpLN80Z7E9WGIuTCypUM9zNsz?=
 =?us-ascii?Q?6PTeTJVmhKC5UTYxpJ1TIn5l1QKdu1tcdgqZhWTczPZtDcJp+FCiMHWCEjE5?=
 =?us-ascii?Q?iZ6/ImChvx264TBDlFzmMheP2azktHuZCmpMk5kQrmWQilNUDs7lHVJ+bNa+?=
 =?us-ascii?Q?0uRMpWaKk0HT0HheG+dzHv6NfTd2jFRD2JZj0joS2yLpEy3meEBjkAeQhGDJ?=
 =?us-ascii?Q?NM3aUCBBkHwNmmvZv+oH0HLwZZjZU94DnGVyEz33tv6RzVXiZ7bLMnPWASXV?=
 =?us-ascii?Q?tN4e/zCxarH4Eb8V6TLTgxpazelCtNYmGPNZr0N7azvPOzLGl7b/rtEPt/Xp?=
 =?us-ascii?Q?uZaYBN9p7eTEMg1v5FEpT1aDrlNBkQA3YQvu1iKFf9m4o6l7if8FKKkpbMar?=
 =?us-ascii?Q?JfjwI/xgj1QeonHmJSFAHE2bIhMRp07FZfKHoXiGfv4HU9rgnWseEYzOzIU8?=
 =?us-ascii?Q?OV+hfiXt9EtpXWeDmY5EtHWtHwl8XgJZu7CKRIrn1HQyXwSgX08GpHwg+6UO?=
 =?us-ascii?Q?4cCqE/IU7Ud+KkNOGMcKqew5D58e8oVVld9+tfKkEn3m7X/RKJzJHLjgmSe3?=
 =?us-ascii?Q?K+3WstL97Ws9SbKM/Udqbv2TyZ2u7br2VdpJIBeHer1AOLYOpmWQbsjTpn3s?=
 =?us-ascii?Q?I4YBhTP83keUgzvGbOouPn0ULzECqj40ZGuQT4FZ5mgTnkcH1IsLo6eWnmex?=
 =?us-ascii?Q?yWQMIUP2dfuTpt5jtKmyH/1p47ZPF1+Q?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xjiDR07+fOEt90gqgFQVeSAZsn8rhSzfH64q95ymUdemWRkChnfAWL4qB54X?=
 =?us-ascii?Q?CFbWujgJY6SA7vdGaAPE86/mMVeHg0UZah4LKzcAi8FJM3oodCsX4YSIDiBc?=
 =?us-ascii?Q?+TinKkpnq/FsDP5ktw6V9TNnjb25LTEiVXKhygOQluCR8NCOnypwXOisU1Xf?=
 =?us-ascii?Q?FM1X3+SfboppWKpR4pvTxBJKUhXthTK/N88FWy3Bv0gCffWnXh5pKEs2kDoq?=
 =?us-ascii?Q?rBEKrMU1pCKMHwjLV9Sd/IqXhMR591nrdtw43P0FvMMpswMevtqO4+VhqC4f?=
 =?us-ascii?Q?KAEvkZ+6zhyxYvbl/ml2VeslyebcSQOe9HRQg39kt8xNnwFxBfX9sahJGZc3?=
 =?us-ascii?Q?IVjP8zGSg2Ju7+Nlhkw3N0o4ZlBQbSB/QHzXnDPXv44WM2LDoq3pQZaLQNCn?=
 =?us-ascii?Q?O7C1O/fe2nrsZkw4qTWazAmyH68gvnYZv/fMqDvNqdakRsb8iQY0iJ7ywM+i?=
 =?us-ascii?Q?mCRd3tPeHiQiQjTRZhgpAvn29YVp4M3gcviPHNHg0azB3OPoGTZ0Ph2TE4Sw?=
 =?us-ascii?Q?uMNZ74ehMSxyALZ3HCDPCcisWuHTN/gCx90Om4mHUWOY4xlci711Yw1yHWmq?=
 =?us-ascii?Q?aJGxLX4Kb3Tfbkl1QpcIRcF36zm2NLK+nC1NGzWNe6RDjDA8oy2tOltwIRe0?=
 =?us-ascii?Q?eXNVYF3RWGJalv7rj7X+CFzSMkw6ltQT2n+ZZwcUL0hC55nKEDOoO17f2unm?=
 =?us-ascii?Q?U6jTpRSFFPAUx0j2QoIdlfU9Rtl1z1JsLqraquuZVzEta9dKkRh7BaEnXrxb?=
 =?us-ascii?Q?FDGdwi8mgb9lgkh9iijbmlhOuW+4UIvKdninEKsE+kdij94R8L/6lae/Tc5G?=
 =?us-ascii?Q?TV2LOSNSNaatm2qhGD15Wq2mr0Jdnd6M+F6HRa9aiV/+rjDsb6IBxcK6ItBO?=
 =?us-ascii?Q?uR91POAsofLeI3/m9Cv+vDIH9Q641dJ2lRMUbB7SXaPoAB5DRtSZB6kPO60X?=
 =?us-ascii?Q?aUn6iecAcdmj6PAL+qTvYdg9YDjsVRXHOkT0xtLcfARPhYNgxCuTgKMHci/G?=
 =?us-ascii?Q?eeI8aq3bL52LFdjrGJggVZhLtE7iJB9ndm2JzdnWi139b9pweSb84rBWCJWB?=
 =?us-ascii?Q?xkKev9Z+cpND9BIaPDfrVXjGKQiG5hKY8UXOBniwjtmGe6Uq6I47PymNb7wL?=
 =?us-ascii?Q?EzTAtyfDwAY0aKgxXrekDY+C5IjDc2e0+bTBi4EfNpgCSpFOIOJSZtPgX6k9?=
 =?us-ascii?Q?lKm76KaLZb1DOq7nRZW1WQf/FLcRzS2LS0jrDknA1SWv1L4nNMquaLkY8NXc?=
 =?us-ascii?Q?zED7C1Vvkwu1PGhCS5y1+hV6bocnfgCr/KB0CvZT3eRH0iaoz6MIzNR+hmbJ?=
 =?us-ascii?Q?Z1rdtYZOQOMyNwoyfuJELMvQicSy2sKIm7pQZpUrmqhVb+AyR87fpPR0rUdM?=
 =?us-ascii?Q?Etw5T78NyvgVW66f99LgKzW99rCxmaMqIcHvabK0W93bOLNOnBfdiH7lcUEF?=
 =?us-ascii?Q?Ed8v6Lgr0+sJwLxUgnAW7BNLLKkT7moLcLVHkNKsVkfOTJuzaNPZu5DDD2RE?=
 =?us-ascii?Q?B1Emsgz4EmX2ov016MBbBMOyyb23qdb2pMgPrRBUc4wXYBbS05jTG4J6Z3ei?=
 =?us-ascii?Q?vCLGKmYGyTIeU1OYWXtB2u07xby/kL/BMAKNMChd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46a4d51b-83d1-4441-359e-08de3e4dbc1c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Dec 2025 15:54:32.3853
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FPV8I/yqJG3vF3iPVkR1Svnk6IosSyEJtqnG6MSyjrLGU8RXR6iw6MMJfRLOqSTO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5825
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB4DC100007
X-Stat-Signature: b16oae31zgmqimzyuqunwthizd4oq7ha
X-HE-Tag: 1766073276-35243
X-HE-Meta: U2FsdGVkX187Iwf5fSaZv6PsymDR8Qrk7BJ/1RqW8YRxfTtVkQbYoNGqIpf7I3iIJ9oZTD4JpG6F/aGvvk52Oxh3Lv8v5OUU6krIrECUpJiUZ4Y5Xpgb3V8x9chrZBobNdoQ2jSAPu+hAQdkI623403wkopLHna+iT8jDPoJUIGgFSidusB1tGQR1Cvin9DKppSTA9L1VVHVnbh/jbZAnEjqOKKWKw9TQo/n1c1sX/o8TvkihAn4M6npNRO6Cq7V6C5RN9t8/giHI6kS9S42EyY6sNhg8CkptyQbijR+NcDL2Z4fPlDggn3n/JdbmcIKrsSILJwRsTeiLpMbinulI8oy5gSD3qMFMkr6/pRo2hz9L9eQqr/gwYwS6D/r/S6K8ECsg2pGfK/fuHbNxyexKAeQ7v+jY9vIXm67mWtRudAztJ5/cCn8efTVjNVYEp4YAUw4pSjvfoLstzyfT5ZPF1nDKPw6Ff3vMshU7b4z2DZL+leKJFQTXcI8OGuWdVLoD1BbZR/ZAtSTzn/MLsqmZ+pciGdi+If/iNn2d/OF127Ed9ymSPm5NEqAnjnUItS73s3yD1cn4dLtnancKfDrNSq0FXfMVqw2sDuigJ9g7t6PddEym6p41hRVerPadfdtQZV2vEeEWrnnR7adAaWqEUvB50CEGEnuHNged3d5tFFFCJmlD84MmOEZk56Jc0+prGXSzVamZ8mQKxjEwTyVFRBlqIoEe5g9FxCWYY6Dj/j4DNY+LmOYM82OrBa3K2iq+6zvMMFMctVyNMbKCw4nJZMO36hszDiWSH5Xw8AJJyrYXEVDHZl1O94pDBBJCHZnZPBczbi0ry32ieuJR/0ogMNYtYKwm5K6X9NgkkcfXT5+Irea5fKLJCEkm0U/k33tXa5W/OvUldd8uhVqtOb3nueCFiYTsEtq9d4XRiYwHTv+/jG/lkDhy6urrv/wRQ1tycc5Yr/YJgrEMRrDmBw
 V5/H6MYI
 WzeHPx3V/Y0Rm0E0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Dec 2025, at 4:17, David Hildenbrand (Red Hat) wrote:

> On 12/18/25 06:40, Garg, Shivank wrote:
>>
>>
>> On 12/16/2025 9:08 PM, Zi Yan wrote:
>>> On 16 Dec 2025, at 6:11, Shivank Garg wrote:
>>>
>>
>>>
>>>>   int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long ad=
dr,
>>>>   			    bool install_pmd)
>>>>   {
>>>
>>> And here.
>> Since this function is declared in khugepaged.h, I need to
>> move the enum definition to that header. I see two options for handlin=
g
>> the CONFIG_TRANSPARENT_HUGEPAGE check:
>>
>> 1. Define enum OUTSIDE the ifdef: This allows the static inline stub
>>     to also return enum scan_result, keeping the API consistent.
>> 2. Define enum INSIDE the ifdef: The enum is hidden when THP is disabl=
ed,
>>     forcing the stub to return int 0 instead.
>>
>> The only external caller (uprobes.c) of collapse_pte_mapped_thp curren=
tly
>> ignores the return value.
>
> Probably best to not expose that enum (especially when nobody cares ...=
) and instead expose a new void function for uprobe purposes.
>
> Maybe
>
> void collapse_pte_mapped_thp(...)
> {
> 	try_collapse_pte_mapped_thp();
> }
>
> Maybe something like that?

Sounds good to me.

Best Regards,
Yan, Zi

