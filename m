Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B06CD37AC
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4806B0005; Sun, 17 May 2026 11:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465816B0088; Sun, 17 May 2026 11:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3543A6B008C; Sun, 17 May 2026 11:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 283B96B0005
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:28:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A979F12060C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:28:14 +0000 (UTC)
X-FDA: 84777292908.24.F7F49C9
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013015.outbound.protection.outlook.com [40.93.201.15])
	by imf19.hostedemail.com (Postfix) with ESMTP id B21A41A0004
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:28:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eeRCnWdq;
	spf=pass (imf19.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779031691;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QL3nbw+sqmSbkFoQvIbjxA3KvC7yKdARRB3Qh/b5R8=;
	b=U430pzrMAOK60Qu3n9SAx+rM14oG2pT4gnWpkW8PX1Xh//Z1twdJqvU8dd2MUL6EHkKrGZ
	uNV8t/PB0mT4SXB9TVUNq21xUkhmSzVSgIqlnlLhjGFO+WjNbmmACCtYgQjDdlDq8SMqcF
	y/VySKbksh28JB5G1YdublgX3g6iRFM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779031691; a=rsa-sha256;
	cv=fail;
	b=ZbFgb9kyF60UQhOlaKjgSDN/5Igj9fskAmCtCM2teT3WJO7LOSTxkWw944+JZHfdkEViM7
	EYqqAH5VpCY+3BydGod3Xbrp8zdwry0YWOchyMMDY8oKHYtUPB1kyur3pS6b3r98Kq6NBc
	uzUb6YP7+olz8YLIICqyu70Oa9viBrY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=eeRCnWdq;
	spf=pass (imf19.hostedemail.com: domain of ynorov@nvidia.com designates 40.93.201.15 as permitted sender) smtp.mailfrom=ynorov@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dCESnU75T7q/v8Pre9+rJpYCjZ5DLfZ13lAV9TyUUCz58xRJ7k5TCYAP0/WHeuNBIGX54OnrAgfa6G8DakuFbB9VwbR5lm5iH2rP2rUKmE/FESP84JaDAr3X+VySLgFEKKY7pK256Cm5oQMsh71Gfxk674eC/89IPBlRwRpjCRBUPcOVsfDGVoyQqBGFphiCrYbD3hDiBLR7ejCklymLg3M0QwXMr6jnPn77egyXv/evnJf9fZVkhDYBTbQl4jaXbHrgP0+IKk8xAMTJct4Wo257BtBOymefqPOG8H/8Q0rRxC5QFAb1p84BFwGf+0GreBrtNe+WvUOp97bE0Uhyrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4QL3nbw+sqmSbkFoQvIbjxA3KvC7yKdARRB3Qh/b5R8=;
 b=AZ6ROoHEKpbgglo5CY6bz+XYaTJgPTRuD85gFHaNqhhb+bcyEzAr16P5Kb2g6R9P32KnuVBQTvge9GfbCtuAs3yuk01C7RnvfU4y26Co6rXOAG1q4lKQfAWZ/dAH6hY/IPYh9/SMNzFki7RkkxVEklN5zs+UITWp6MaJk8h9r0jDvFuWEgwxlvuU8z+Z28SdzmAIBZ8oFLdGjUBxdE1ywj8oHhKV86hBl15hWI2lBnFlSyyxFvcQjN7deMjwCAwzQgZyIa0xYbx0SXW70oZBt87eRoh2lrpVAQ7QRDrLCH2l+hLDIVcpjBFglFjtnyMmZuqIKjjhdCrr85X2E6Xn0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4QL3nbw+sqmSbkFoQvIbjxA3KvC7yKdARRB3Qh/b5R8=;
 b=eeRCnWdqAhI9m3CscDklCMgxLsrsmY3LZhl0r6H8uG4rZDQieq7WY2WPodneOlKN5uU3a5tuEVWGXQIc4nPZrqJSYs+vxn8mTtsGWRnfm7gFabvJcZqEBECmB5YrTa3UqKiL9noH5xlCpiD6emb5B6+OvrhPaL8uzjsz6yPxZBUU5XBXrwAxIgrSj22SQltSHwhif32ebRSlW975fBdHnjktcl/zYi4ZmFOKm4OI5oZaw8CuuFsz1tbv+6LlWHaWhIYB4TJusXRwMRxSeN2YLYMMXvK9BN8ORRrVvzxVjc6hr3ga+VXUhi2K54JchTALQPVyeOGwoLpyXwPxm5RclQ==
Received: from CY8PR12MB8300.namprd12.prod.outlook.com (2603:10b6:930:7d::16)
 by PH8PR12MB7445.namprd12.prod.outlook.com (2603:10b6:510:217::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.25.21; Sun, 17 May
 2026 15:28:07 +0000
Received: from CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de]) by CY8PR12MB8300.namprd12.prod.outlook.com
 ([fe80::ce75:8187:3ac3:c5de%3]) with mapi id 15.21.0025.022; Sun, 17 May 2026
 15:28:07 +0000
Date: Sun, 17 May 2026 11:28:05 -0400
From: Yury Norov <ynorov@nvidia.com>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] mm: add bytes_to_page_end() helper
Message-ID: <agnehRPd6SeoO9ie@yury>
References: <20260517123428.1181981-4-thorsten.blum@linux.dev>
 <20260517123428.1181981-5-thorsten.blum@linux.dev>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260517123428.1181981-5-thorsten.blum@linux.dev>
X-ClientProxiedBy: BN9PR03CA0066.namprd03.prod.outlook.com
 (2603:10b6:408:fc::11) To CY8PR12MB8300.namprd12.prod.outlook.com
 (2603:10b6:930:7d::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR12MB8300:EE_|PH8PR12MB7445:EE_
X-MS-Office365-Filtering-Correlation-Id: d477193f-4fc3-467a-c3e7-08deb428e547
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|7416014|1800799024|10070799003|56012099003|22082099003|18002099003|4143699003|11063799003;
X-Microsoft-Antispam-Message-Info:
	bFD7H8wAZIeE1iYFSiJ1Q5YlGUjxQusByrLRrtq2uNGHxqcaJTC4SYIUzmFdW6l0seyZIYcvyjEnXkO+gicQbzH/nPgU9xC4sn64tCJKPLHIUEAd5dLpTCuVawrwj0O7/o5/AuDtWebwTEpX33IaHDtjL58InfuSB7w4n9VfA1BJt0vo5iqWpCR4qTLQkK9Fez97inYlpt7ZNZ2uS23qZVQO1v2Ygn2+LinWDXfX4UqhsB6wKOB+NWxlb0Un+qAeTIA+RQmxmoDp1foCRACG3R90GkE5oH2KUuLxoVYig+m8C/IoSKhCz56P7vvuVdoK4bxxYPdKIDr+hK6TTOS66tpafSlUivdpWvZSJvefwib8mp8lgXB1o8v+HFs2p37B+z7htWawwqpK8WRSajr3tGMC/z3nd/jXpuHgSThVGCJ4o1oDf4iyCBDh4IBxoURtDLgHOZMnUvluDQC1+5jNH9ye6VSZMclhwx+3Wtu0PpXU1QdIoOXfmm6QOHDDfllahpI8KZk+/etHESsHFkAKzDaG2hI0f6e2z8HsIpKMQKxgs+IEtnhBX4UAj/zByfWeaN6tsYXPVP7rEFM2MpA00blhnzYyhDdC4s4ykNtlIVPOFmRca21dlHSBq5outpF8xcQhlfnlDPJ+kLgmv3Y+RLh+T95BaQV+L+KKJ99uDP/2cA/NZkI7LOtjsNDqNcP/nxzMrV/7XHeAx2ZpzdhrSA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR12MB8300.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(10070799003)(56012099003)(22082099003)(18002099003)(4143699003)(11063799003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+XTKlMSEF84kmxfIkLJL33hL3E5McnBfjpkvAov5OzJX+LJKpQUdxJz4OlSF?=
 =?us-ascii?Q?W9OYweFG4mM5uUGaSud7Qoji6Tz2RkZfPk+VIsGpz1Ai3x2W2Skj9HpQJRZl?=
 =?us-ascii?Q?H50c/ZWBfk0S4spbz+D3oUlu+VSBzCZajWAjXgdimG70q2wr22HrLc4sXuQ9?=
 =?us-ascii?Q?8Mb/MHX/FLxolpRy8NuTkwfqjsEuscJ4L9upIz0GEHQW51JRbF5ysMRc2whX?=
 =?us-ascii?Q?T/9oirtyP/dsYjNAPRjTahNQrGVfL0m6F+0x0bYGb926dn51kPlzfIsr6Nkq?=
 =?us-ascii?Q?6IZw9/N5HOvaNszrooDdM7oKTOCLuOYWciKd9vxL3Um0TZX9+i+D1LzYdzWd?=
 =?us-ascii?Q?6PeMqcH2vGumwwvjY+4mUKZlsAXWUqB/oQkRI7CRK4bzH+fhMdVNOZ7iBIFr?=
 =?us-ascii?Q?lu922fKeIBePMe1RdsD/NG2lFOMAB1QUpf7pd+ZS9N37vzPMEou2CxifAUSL?=
 =?us-ascii?Q?/pMu+eyaokqzL9CwBcd46VVa1p6cRKMtNL2VJ/JF6WJCvzzrWHjFEQM2uYvG?=
 =?us-ascii?Q?6IslGU4a1AYqJpvITmdS+e9KwA/rXrjJDrQ0Jisofa+SNMzPcIRLpD/juwoH?=
 =?us-ascii?Q?p9w6LtA8vgemISRqlT2qCQskdLzOJRbkcQ9poqsFPYoCmcM4oYxSTRsrZgpf?=
 =?us-ascii?Q?thz3K00u6NMJOVo+uQSnE8wWmSYFLMXMGUM+TtX/sl+WC8CJup4GqL/N6pLO?=
 =?us-ascii?Q?ncMnmZSVYA1A8dJzKv0tp/RLAVlxsp4P5ZvbM3E8EiD2vE7jWFy/GiMikSB+?=
 =?us-ascii?Q?8E77fs3mIe97tqSl8HoD1mpTXKe03rCJbHDGwTfOivNw5QwjpaEDPeqAIIGI?=
 =?us-ascii?Q?O8GMZbwcsF7FwFfVfO3f5l3mgniPhlfC3061mw2I8i9sMKl+6JUdgIGsuNb4?=
 =?us-ascii?Q?25cZuBV1ZsnI592aUGagUTxLcQuX803Whe+D2lpoWZ6UpmAxeYNT2iMsUimP?=
 =?us-ascii?Q?BXWm0pgwl+YL+sEwk7xR5TTVaoiN0wFEKgaPbw4xAnVDSI4FdCvQJSOgsi/D?=
 =?us-ascii?Q?iBBs7F7PvvKSrtMy2Pa/p7peLlE6pz2FNDlCirp94G+RI8UmWs3jp88kT7sV?=
 =?us-ascii?Q?K9XZ5Lnlpo4ERxAc+ynyBZd5kbcwJ239NTkfqC0a3xgcHIecoKn5j0RnwWlE?=
 =?us-ascii?Q?rBNqUoXLOyNw5HDDKY2Ex2djfH57wY+lay5Zjx0gIozCTsfA2BePYNZpxsiL?=
 =?us-ascii?Q?IXqMzmkIkvotBALr6laQXM0Ab9+e2mh/FhvVAydsomfKxSJXKinAI+7wi71O?=
 =?us-ascii?Q?rzGRTe9t17465XVMvDHDtTBXhddMvcWXlpri7TzIxhNFEh/CzvjF+LkI7ZQt?=
 =?us-ascii?Q?K01uEu5/rs19rcYKVbiqsy+i5j0FmnbrF7wfP8SJdwortnl9nLlMS7PtYtRu?=
 =?us-ascii?Q?CtSfzm0yVjURkM5cviYOSPY7LCrZAsRdOh9Gov4mDmIgbU8w9ryRgQMjYtX4?=
 =?us-ascii?Q?eHb3MZWWXEBcMYSYcsXulHSi2oerZWmo+IZk62WuvMBvLATkKMJG0mJ8J8NZ?=
 =?us-ascii?Q?nVxe2YAeHLLTQMV2Oa1Kjb6ELxAZW7QVJnuVCFpV/5T4YMUeMImtRhuFZIvf?=
 =?us-ascii?Q?5g9CYRAAKcZ6D0FPg2pDLYaS473vOgRyp5BCSoyAnWqZoxnjLUsiKnY4e0tm?=
 =?us-ascii?Q?8a6NKImIWiqfSpnMw4MwRNE2AsJR9DHNxJJ+JNpGGxN8N1NHwIPa6AM1pCoG?=
 =?us-ascii?Q?yAHz8n6kBC5F6j75/Lu2egKWkjOaFrBCFGKevsWQLUL0pXNhxTRMNLlxwBPy?=
 =?us-ascii?Q?xxwSRILqfLntbI1ILCn+G5Rh28DJeI68oCVqzWsLd7YaNiuzKWad?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d477193f-4fc3-467a-c3e7-08deb428e547
X-MS-Exchange-CrossTenant-AuthSource: CY8PR12MB8300.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2026 15:28:07.3825
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjsoiyAL35yqpgaaaZq8uHKfEmlQYCxXNhKmt7o9URoFX+jKNl+v+P6VbuCinGG4OynTdGsmu2KZKyATQfqV6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7445
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B21A41A0004
X-Stat-Signature: fc8r9rdkkk3y1mcrbira4pwg89sbe9sk
X-Rspam-User: 
X-HE-Tag: 1779031691-151876
X-HE-Meta: U2FsdGVkX1/Epr5QaY2YTCZ1Yh7sW2U1/uqNHdUxGp3vzXDu7S/Un+43agZby8ul77UM/EH4ccdlWkgeao7H50KOsEVPiH14Dse+wB+KBUs0U1vYV9gxailYWAXXFQ96VT+3uw8/KLwElUmVVdwWtlgwxglMmD/3783Vvzsa7cxx654ap+Gyhv9T82mKv5sklgZ4RbU5d7j6HtFhQDoSvS86s3lN1FG0WoqR6kG0ZSdD2DJqv8K2Paaeonm30huvwPQkWFQ5tkhE0AXzT4MVp39I7gJj2rYjRIqEdQVncZeqG/bqGRQpdWAIL+qCOZ65ISImC/n/RzeZaPbpSg2b/dMZbv2o1woNOmZYAgruAOvh6Qf8HYFkdD4X9jYDonu/Xei5Bwt6kq3zaVjZYg73GYzg9bF60v+HBvRC6+dYCrkvScukZVryPPtIB4DbUSMFspA5BZ6GlMg6cnNzkIDcpuEzaFda/U5y1tBcMwcQvx4PJGWSUCVJHflUR5c7zswoFhYRycGSqnVAgu+AwvKWpojQXlfIpDj3mKg4N4ZMaJTc9iKAYthY1CJqHWm02IxnJz07cqCbRjj5bgD83XzQpVR0GuliyzNiuZkgSrCzeCrxsgvOmZbtz5DEH5yBL2tbFHA3y5iaNsdvweR6CQTeGV7I/ABtL/4nyUDOvrndd7PiJMkvlNLwkHSpAUcnELOhRh9+O0wmaCkqdRZKi2ASluvk0xB+naeAXozFeEjWyb2jHKxY3NI1ZhL/Ehq4lB2SYfI8FBPK1xWVEFkvqqFU/dEvzJakyINWVtccQb20ZTpTmk6I6XhQpiZfs2ebKr3KWQW/mD7Xz2ayJo6rHdim9CdHEp9a5taeyex7a+u4pEHlUG18uDqHFbjyekl7aPHDYBzWrEBWRf2qfG8atXf4w8XegeI9ozOixzS7i43ors2gEzxzLZwJBnAMNbr5/UHjSTIIVFR6yDTvzPOk/uU
 aIz7LRYG
 qBhBm8cVgC7/0q2VyL7z2N0WC/OLWpS4hfB+hmuOME7JiNc/eiaSiSuQFo+spV5xvEZ7qm8JL85SFZtXFRJcA3sKP2EMr6bLXbCKhUWrj5GRir5rCfpPusVb4s3nCwJaRnZ8sGO1PGgjhPVeFvlaUh8jJAb/6CfdMeNOqAQqWj93magRx4wZe6kmh72AtptGDNGwDFT26Wf1t4bIsOc6370QfP3dB1g0mnzcDxvOqlTEcETituIM+O6jGYrjed2BWG+vM+3+Mn39J4l8ObQgGQFMjNnuPjA0zxyXJNhvmvBkT24ZYbemOwWGbmje7DVf3RUwv1f2t/DbHdeucD27UqzviHoMFbH25uZme0S2feMcJFHVVRjCKC0moa8owovSIUt/yYYDx9gSCgARl+YE0QXHULP3ifIb5/iCeE1QXGaTY6SZ/oUTy9NzUtXJu+Z6JKdE7X/vD6iScnJ5XHNXwE/ncSUH57N8RoOzPGiUSzLX4QjG1Ull8RYhUzASH4vBED2b2nuGP40n2oqxit9fnAocKNDDcQHJbtIqlaBLITRbVBw9WVQzL68s4q6C5pMzxHRo4IRU7rGLPxtUD/pQPci5ohbXFZLKt/T3n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 02:34:30PM +0200, Thorsten Blum wrote:
> Add bytes_to_page_end() for the common PAGE_SIZE - offset_in_page()
> calculation.
> 
> Suggested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/linux/page_helpers.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/page_helpers.h b/include/linux/page_helpers.h
> index 102a4f3c3868..981731faa1fc 100644
> --- a/include/linux/page_helpers.h
> +++ b/include/linux/page_helpers.h
> @@ -6,5 +6,6 @@
>  #include <asm/page.h>
>  
>  #define offset_in_page(p)	((unsigned long)(p) & ~PAGE_MASK)
> +#define bytes_to_page_end(p)	(PAGE_SIZE - offset_in_page(p))
>  
>  #endif /* _LINUX_PAGE_HELPERS_H */

I've got a series for this

https://lore.kernel.org/all/20260303182845.250bb2de@kernel.org/

The feedback is surprisingly negative. Please add people from that
thread. Maybe you'll be more successful convincing them.

Thanks,
Yury

