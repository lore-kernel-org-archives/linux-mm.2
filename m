Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FD881091910
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 19:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851706B0586; Thu, 19 Mar 2026 15:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 829016B0587; Thu, 19 Mar 2026 15:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EE36B058A; Thu, 19 Mar 2026 15:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3E96B0586
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:06:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DD26A1B884C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:06:34 +0000 (UTC)
X-FDA: 84563743908.25.D4F2DE5
Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012049.outbound.protection.outlook.com [40.93.195.49])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3935EC000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 19:06:31 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FHSGDgCi;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773947192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwB+MIlWwJ/xPrgOztbkBHJ5muX26k6ZDR6g1pkbHRM=;
	b=GluzBulOWOOaydP5tEWpXYr7IhkUhuymlJIQbkRqZ+xaAMds+vr2rAPl16zN68l0YHlBM6
	gb34fP4mRoY/jEY4xH1ZYvbBO4xQn86dX4fXsaqA9d8bhifcQkf5NAH6XxlhuW3ashIW7L
	30UOVh4dwolB6KYoUhmlalmWnUmauFM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=FHSGDgCi;
	spf=pass (imf10.hostedemail.com: domain of ziy@nvidia.com designates 40.93.195.49 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773947192; a=rsa-sha256;
	cv=pass;
	b=3c80QfbGUsVbI9te/WFekvF/GTVRZlTTuhL0DZ3/7hDAr+QOdPHFPIVpen7yria4aZkPd5
	pqzG+YuJkEnL/kmTcjuT6kkAV892QsSrKIrdJiRY9d7aBiZBhAqKR2KPh3gCHcbwF2fyQ2
	bPmUXx64pmoXgcqMcaXOCr9QIHym6HQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPELFjnnF7FiA19CDynLEOAb9SUMhsvaHzysnuzQzjbnqQEFrvMzKxRLZ9rWixgxhv2c8HrOsXIUApVA2k1iTE9Je5TRG/tbbpqc6aCPQaVIbf23dBXF9l5yeZU/jtC3Cmpr4etzPxzaEajdxk9C7eXSI/Alh+j6/pOZvRUcifVujAsTXkW08F9SPrDn9fthNQ8bfWJZozyHoXFiUJdh6pOmYkLPfTNvGF9Gr11CBxUsXI36hW/N6XrmNiBk1PrXMnW7EaDPIV4tJPM6aMKTHuSvZ+bN6XeIKyL2MU4sEDrdShCkX0VuJffkzaQCMbE9c6fmfvhOUEdiLblCjCF7UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VwB+MIlWwJ/xPrgOztbkBHJ5muX26k6ZDR6g1pkbHRM=;
 b=dYIEumx6D2MrVZ94rvQXYpOawhpfvIlvtD38XdJrW1KcYgSGUa7Wy8t7pCzpLveeRE5ZHFHvH9M8bm273gZe/4naDRKfRVDkM/Cxv9ju+3GkXKyZa9I3eI0yWxNU6vJ7B1KEyGXewilqkIzfozvlYVRZY6zHZ+r1UPqQnBlg/iKhG2+Zww1dY5NZhr5HJ1WpHVvmcU/xGr77zi1Suw+rwlCoHnLuLj8Bz8oDHoXtgTL9IIlzee3Sq2WS2wODs/Q6YiyrjWUtqcQ/Rqg94X68gn8lizhAS4KCqjZpovB2l6eA8pdzUBBI6LqNHgeNfeTAkIuE26FwWspuRLCOxIruyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VwB+MIlWwJ/xPrgOztbkBHJ5muX26k6ZDR6g1pkbHRM=;
 b=FHSGDgCi7sAuwEhR47wCr/5Ev9cNW81frnTsR1kSMucoRNXV8x6gVrwQYoICgsMAOPGd2E3N1t/Tb/ojoF597lISOKhk2tCZqtNztadGRI3wXtTuipdsa8wp4WC67fJSR0i4n6EcedKSmbgEM0UcwaZGHkVziRSrzN9YKU3MlUdKZ62APZwLxSb9F8VXCHzgUfeSj6wcn58We/IQFmqsAsOhduFo4dHbtOvnxZv7P8+WKYiDX+PrxAJDh4ss6/AAskMs1el21yMocJb/fQ5/aM9RqhnVovCxVSnmBnFEkgQF7V9CkpTQaQpTwrPvtIWihdNXTb0YdCsVwKjnd/HUVg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 DS7PR12MB6120.namprd12.prod.outlook.com (2603:10b6:8:98::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9745.9; Thu, 19 Mar 2026 19:06:26 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Thu, 19 Mar 2026
 19:06:25 +0000
From: Zi Yan <ziy@nvidia.com>
To: Chunyu Hu <chuhu@redhat.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org,
 linux-mm@kvack.org, ljs@kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
Subject: Re: [PATCH v4 3/5] selftests/mm: move write_file helper to vm_util
Date: Thu, 19 Mar 2026 15:06:20 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <D83ADD8E-23B3-484E-8D8D-8F133050547D@nvidia.com>
In-Reply-To: <20260319160656.1480279-4-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
 <20260319160656.1480279-4-chuhu@redhat.com>
Content-Type: text/plain
X-ClientProxiedBy: BYAPR21CA0006.namprd21.prod.outlook.com
 (2603:10b6:a03:114::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|DS7PR12MB6120:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a37bf26-016e-4d4f-e827-08de85ea9e44
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|17002099007|22082099003|56012099003|18002099003|7053199007;
X-Microsoft-Antispam-Message-Info:
	tc8MCeWa3TX7MTUprRSg9QPp3TrjmJF/pMUkL0ItbHQckrfzhA+cO/eQNzd3pn7OabwXluuHPxYr5406QE4EXqU6k4JuGmF8GQv+6S0JZnhay5vX6L2pmjk3OP6OFqjC4ZSH4jnRxAlBG58S3YMU+fguBQ3XaeDGEba8l/AfqB3Xv9S/8czBEjdS+Cotp3z1/VS/d2k1fRW8vCzaWUeCorutG9uMitfHeBBORxD1iWE/jtLihWZQHYHeDJTmVGFBDQZfJJSK38FiZLpZIdXUvuMciRU23fFWuZ6IJSN83pkhXrmEgnTgaS3K5lPDzZXxLF1rVGva57Py8uGWd0mlmM8YzLzC4dWdcCZz5fiHehOrYIKz3ZniG2sP1GyVkOUGda7r9MXHgy73uljqwlFEXBuzk4/5sIFHFE8bq5EasjjGq+U3s0onjk0CseLe5tkMULvAb6xXvDLYLDILW0loNvrAztFvPXWdVGu182djLpIjW1WpyzrKBNB7cRanRGIXiaTWfngyRrUspSMRM+0TUcNcPZYg9jcSGNCIBtAUwzxL8bpOIJ0lFxGe+6nNTQ9BW4aHhTp6yTVJNALMd6X49gL4AyqTev5Hw8Fek4iAnQHBBEIkkQELDv0SGJk71H/8AgpanRMDuhQ9cE5d2+ti7I9T6nVrAT3LRtuaohY0C6mzDZ7nrBjn8L7SXnajRpSqEi6HUgEPZ1x7Qq7SGPngS5nk8DZtKcoq1Oua21XopbI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(17002099007)(22082099003)(56012099003)(18002099003)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MLlEmtTVj6qA+cqzLPU/rcZDFR7jRpU8OFoYarA8pVsSi2krTglxsNKtElBB?=
 =?us-ascii?Q?8XfG0WLg4ShkES8+EyQpc2vfavzbsUNVt12dZdRM3+2P6dnD5RRQxiuDw2YA?=
 =?us-ascii?Q?CWKaxT9PdUPfg8yhSNf4CdAGAEjjV9WapjQoV47F6SiVhC4/3fZZqkvdzDES?=
 =?us-ascii?Q?VsFNY9F+o5GdiVFllEaVykeMvjvEnBlxviBb22QZB/VriMJyxzFh6fdk/x45?=
 =?us-ascii?Q?rsLrGYyi0aMQ+Ep0YnhnspW1/Bupd0+LTzy6ZHVgWqypmMGjzPROETRY8S4O?=
 =?us-ascii?Q?wC+YlR3hB9KlpHmM88cGkxsLu0JYWlEGWf1pB6qSU7WFS/gGdNbcahAt8DXn?=
 =?us-ascii?Q?93WevD7cdu8Hh2hyr8vpUu7cSsAyt1/do5MH0RB55BX7QtTBixJpkJz+04tb?=
 =?us-ascii?Q?sMGO8xCX1xduTT54qhH6aUGRhM54KEztkgd5AJx8MwwXQZneZGpe/vVdUl0S?=
 =?us-ascii?Q?S+Fcphb7KgrQNBZf9BWOwOLJorrqeoC8v26Zj2M1cbDNrh7+3W8ORr1JqwWL?=
 =?us-ascii?Q?zAi4CUm452RB17+HH0D0PNW45sGw7TX49UY/IvMO0El7Pp2SCOdgSFayfhRo?=
 =?us-ascii?Q?9to9uZ0rDWGuflLsDlELZ3FzRIVqsqzrqMZuqZB7IFXC5uhhnUaS2Zkx0OfK?=
 =?us-ascii?Q?tozU+RGNhgki4G3aZtCKc4VL0l9UH+Rvj5RwQLk07FuZT4IG1NzwO2XTkvxD?=
 =?us-ascii?Q?r6WIadLu31d2u/x9T9khtSKawPzLlFeKtsGM0ZFw6eeYccrRk5yNu/Z6RkqR?=
 =?us-ascii?Q?sl0UFDOA6JdE81dVxFD3Th4i3VFETWbCI7aPj3nY+rBg7WrnpjX2iubuuYat?=
 =?us-ascii?Q?3a01tJafmhi1GUsmtXCOVo0CK8EoAt+4bKwdSwPrIC7P1rx8APHL9UIpt/VQ?=
 =?us-ascii?Q?mc/qOet1f2SdZLh8EQYdxa9hU8OyxVaefiQlfIIxxcTAx7mepraaRQbmYW2a?=
 =?us-ascii?Q?f9OSUn/u6CGafIk7MwL1biDYQHOYAXg8ix+aMYULHNHT6ToVCBzkTw+e13hG?=
 =?us-ascii?Q?3WyuKb5Csgvju92n5tYzx/8yZJ0W5al0c96a5ay+xyDXCF0k5ZzjjpDEdZ3B?=
 =?us-ascii?Q?IrXh6/m2JGQyb95L8Sjp8aR9MEIeyj9sHk0J1ofJRQEON2B/VjpX3rjugnoc?=
 =?us-ascii?Q?iAo98O44iAgTVKM+1hb3JT363mUsdH1c/+z1gOP3E4QDFZhdF1JK4HvYAXmE?=
 =?us-ascii?Q?PJZ4C8GSL4p7gQHfj71mwC+nUTYXD/TbzyO6uCBMhnVeGg0OXq8DbMDn83PC?=
 =?us-ascii?Q?fHGrhaVdbzhuWBuL/evY3MxgyQGYoRr9NGEPqfvmndIwbkvcyfZ7L8uSv9YR?=
 =?us-ascii?Q?kNLAuEMBuwx3Pl7eL5GGJ6eZJfwZmmPm/JtQLcpwBgkLsLI4vguJhXxbZtc+?=
 =?us-ascii?Q?ehf5riAvF9IqRTwQ4JE3VlLku4a//XSy2m2MXto1KjYRFR3CjeuVCuAAjHld?=
 =?us-ascii?Q?CnTpD8MzLPZdTJ/mCWOZRFrOBIwydp9yxCReZSaTmdUPe7blseIU8cPVLs1z?=
 =?us-ascii?Q?J0eJWhBxffxcOAgIEvTrAhPs+Dm5wdtwERHSprR/eMFxNxNyjGQBkrn3274/?=
 =?us-ascii?Q?QnF9KXbFZYQmmvZUgw0+WhzvdYFjT9cofYLgsxTSPvrAiDMJKW6ghJeN7gXL?=
 =?us-ascii?Q?OkYB2B3ahc4uHxGGc7sk3DmzulJct14rmF/RMRMAxQzXv7sOgcjtnYCUQEGy?=
 =?us-ascii?Q?FhLOI0Yf4TgHUzOtdJ/9tp5YqQSUhdFo+o8wuW9lT8ELsl0oQhEbJLyagbtB?=
 =?us-ascii?Q?e7q05PALPw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a37bf26-016e-4d4f-e827-08de85ea9e44
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2026 19:06:25.8589
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iVeRz6W9B96OxL7xycWJTObkgdfXBGOXM/q+TjM+PyOR+9+P1VIGAiLs+5m0fAAq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6120
X-Rspam-User: 
X-Rspamd-Queue-Id: 3935EC000E
X-Rspamd-Server: rspam08
X-Stat-Signature: 7z1yxrb3oqgrk7pdrihqdkwm6qazibnx
X-HE-Tag: 1773947191-519243
X-HE-Meta: U2FsdGVkX1+S/pZbnyYIBjKe8/1fIXrC1C1ashl4m7l+0UJSQ+/7EplpaLhqHva1ddhI+F59nLm9XodTLxzgZlJNNT1ymLglNlerh5d5C2r4dF15tG0qX/NLukwgYFsJ/6KsOLm2iYcG47pvy6+TA0q/4df/ZiqV0h8sBEIa91f4axp2Y0BjHjcGYH5ZG/KidPkwZkdObD+ZOkTquy55NalAypRveK7aKlWypF0X9yxm3jyCDWjhUlBIKAIY1TfDsQcgp2aplAO2CSTAAoiAqgDM9AazXzs/hQqf4eUNF1D6yRHTXFcE0GyirWKa7AXL03DGLzVMxHrvEnP9SUk0pdadr5pXtgndIpuqm48AXMpN7sgqPSMxWSBvzwxYIeshHRRnoEiThL1lWpBqgafqIPDIQ7OZWMx7ib6iXqO4Svr1xYK4GrHkDoFIDRii5nrHG9zWmYPvkrqLm1CvFkUmSGJkdcwRGu92hen/J6923feiWttwcRDVWTP+X3n3fpOxgHcmiyjNTBCCQpPKsJPRXIfCB+eumXSA7gD917JaHCCqaZRLKNWvwVx2lpx9uaz8PmaW6HbRqP3HdiIuyYReH2/hqwmKKIEGnB5RylEpPEkYhcx7942qb19QzCXivCY4wEsKDvWiJn0RMKirnX/X3fz/5cD5VwE/zzmJAGQUqormXokiFRYZg0q+SSZglHxuizYlzOc5dBUe8WyOQwhlF55oDZ+mPko0YMWjeem1vLAUYd3Vv/iMLG/9BMZDDSYjpQ2joAc4WASWDA55+bUA+PC7wNLFY/Gzm9EaDVyRXpSyfll4fC43dqKSNgg4lhhWy5tncqs569/PBQnHxgF3g+mHf6hXPwPrPVi+YvK8Lhosf24LvVhGVjQ1G2RFg3JEntGZdYLPP0XyXOApf3cUwj2rWepM7mC/FBuX2zc7/c4/VE3NDYsbyfRZKh7ks9eJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19 Mar 2026, at 12:06, Chunyu Hu wrote:

> thp_settings provides write_file() helper for safely writing to a file and
> exit when write failure happens. It's a very low level helper and many sub
> tests need such a helper, not only thp tests.
>
> split_huge_page_test also defines a write_file locally. The two have minior
> differences in return type and used exit api. And there would be conflicts
> if split_huge_page_test wanted to include thp_settings.h because of
> different prototype, making it less convenient.
>
> It's possisble to merge the two, although some tests don't use the
> kselftest infrastrucutre for testing. It would also work when using the
> ksft_exit_msg() to exit in my test, as the counters are all zero. Output
> will be like:
>
>   TAP version 13
>   1..62
>   Bail out! /proc/sys/vm/drop_caches1 open failed: No such file or directory
>   # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>
> So here we just keep the version in split_huge_page_test, and move it into
> the vm_util. This makes it easy to maitain and user could just include one
> vm_util.h when they don't need thp setting helpers. Keep the prototype of
> void return as the function will exit on any error, return value is not
> necessary, and will simply the callers like write_num() and write_string().
>
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Chunyu Hu <chuhu@redhat.com>
> ---
> Changes in v3:
>   - make the write_file void return
> Changes in v2:
>   new patch from v2
> ---
>  .../selftests/mm/split_huge_page_test.c       | 15 --------
>  tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
>  tools/testing/selftests/mm/thp_settings.h     |  1 -
>  tools/testing/selftests/mm/vm_util.c          | 15 ++++++++
>  tools/testing/selftests/mm/vm_util.h          |  2 ++
>  5 files changed, 20 insertions(+), 48 deletions(-)
>
LGTM.

Reviewed-by: Zi Yan <ziy@nvidia.com>

Best Regards,
Yan, Zi

