Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C321CFD352
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 925826B0031; Mon, 24 Nov 2025 14:28:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D5F96B008A; Mon, 24 Nov 2025 14:28:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBA06B0092; Mon, 24 Nov 2025 14:28:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3E96B0031
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:28:16 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CD2371A0510
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:28:13 +0000 (UTC)
X-FDA: 84146486466.27.2C76726
Received: from BYAPR05CU005.outbound.protection.outlook.com (mail-westusazon11010055.outbound.protection.outlook.com [52.101.85.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 25A908000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:28:10 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LPwQL+XC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.55 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764012491; a=rsa-sha256;
	cv=pass;
	b=YwzUB1AKQehfGwQEEqCU6M9Wbo9jXqermKtJVCmP1ZvMSLp3Lk6y4jpEuE61a2E6c3BfeD
	Sylg47ZUmFBE8+GQ+uUJlnsDAjJsYlLsCRSKmf0JEg7GKWG6XvMZzY5yn3pwiMuYxJ6w44
	2VRA13ac0FUmP8VPH1fh8CVTPjXee+M=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=LPwQL+XC;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf30.hostedemail.com: domain of jgg@nvidia.com designates 52.101.85.55 as permitted sender) smtp.mailfrom=jgg@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764012491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NkFcf7kj/zkqIBkD56iBpPmA2X0HgDFYOtca7FK1QaA=;
	b=CaxvOPMVfUUnqZaE8RzbihK4q9Z8AIHBw+PxumUyStn7ySyvB4pwkYjZ6kpmZvIGivz0Tq
	E7kfNr2axJKjQtbIcpfPRDl55IS8HmCoYOkKAxNJqGlRH/YmFXrpa+hzT9qmMVioxAfqSo
	hrZwZr2j0YAFUJn2tOWbGcHorpoIoIM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v06rrhRBmKJkfA7w8OeLh8iLVSUSpRJNONqeIe+XG49MxsFLLF6GJ+S6kZVNZaHjJJxWD2TZPLdz8jtWzYtu19d27hHwNz8zE+7+wsBq+B8STFdI+mV2eUJi4DS31j7vmVFZjsjnjzidvtOCE4o4uxy88AOaTFMdvTvUFzdl/VSFDlQMBwa3QaYyhHAGV6Lhra+qVlz9IqYWE014FZjF98jAnzhS9y/H28IZp0X4QEi/CnOhVmeQZmIP+YoKm1FEdzIOHGqHZ4P6h5zvVJTK/BpJPla9v5E3QgFki/RkVpRTEyuOqT4WRofx9JHcVJs1NrELv1z4f3TceDBU++Z/5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NkFcf7kj/zkqIBkD56iBpPmA2X0HgDFYOtca7FK1QaA=;
 b=CneteAcmoQn7rL/xw/NARDphDMhZHL8uj489m18BQF1aQX5VTSqla+jj6T/a/EZ0LzekOfYymtu0ZQlQWlSBIuKi+7vmRJSF6AzTd3rLAyrxfkA52zoILkL9FrfpN//FpbK/ZEJBjnvj1VwOaQctWVhvaXiRxO0Ap/DblG6zgAR/HPHMF+U8xCmDgGDOPJYBwjMuXNWIk1A08+A5ZaT9K6lhlGL4svspwQSeahSoW9f79cn5tCvv5dUdKkwWALyon9ZMDuoEw8ne4vkXatX/1fxHTyEGM6KW3uX2oQato6ZMWiWPufeMBJ1sWEA4i6HS8ORxVk/6ixtMY1bshOiJyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NkFcf7kj/zkqIBkD56iBpPmA2X0HgDFYOtca7FK1QaA=;
 b=LPwQL+XCQkuw4AZxGlNoYwNsIi5NzADWfJxSEsygmCM10lJI1Y/QA3AzNRGwe5LXqWEQ+MXCLKRBm0eY/UwvSP6+D2n5u3cJfM4+fvhijI0oLX1My5IJsWMIpROOwPIM0lg3S8oVX9cqunCR2Pu2yhqhYlKf6rsAFS3UH35rgiAA1xvw6NQ9YlV6GDSS7eH6FDhg1eYSrFiNhusiqjYD9P7mRz+PR9+fHlmXLEEFgqcD4vF2aXC2Rvmug6g8lJfAaM0zdH44wSaA0iJH5W6eAm/b8ESipyju68dwEpt3S1aMrZLfG88B9HpYDVum6tH+KzKjrqQXriOyntorHrJohg==
Received: from MN2PR12MB3613.namprd12.prod.outlook.com (2603:10b6:208:c1::17)
 by CY5PR12MB6525.namprd12.prod.outlook.com (2603:10b6:930:32::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 19:28:04 +0000
Received: from MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b]) by MN2PR12MB3613.namprd12.prod.outlook.com
 ([fe80::1b3b:64f5:9211:608b%4]) with mapi id 15.20.9343.009; Mon, 24 Nov 2025
 19:28:04 +0000
Date: Mon, 24 Nov 2025 15:28:03 -0400
From: Jason Gunthorpe <jgg@nvidia.com>
To: Shameer Kolothum <skolothumtho@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, muchun.song@linux.dev,
	osalvador@suse.de, vivek.kasireddy@intel.com,
	joshua.hahnjy@gmail.com, nicolinc@nvidia.com, nathanc@nvidia.com,
	mochs@nvidia.com
Subject: Re: [PATCH v2] mm/hugetlb: Fix incorrect error return from
 hugetlb_reserve_pages()
Message-ID: <20251124192803.GK153257@nvidia.com>
References: <20251024094240.337630-1-skolothumtho@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024094240.337630-1-skolothumtho@nvidia.com>
X-ClientProxiedBy: BLAPR03CA0065.namprd03.prod.outlook.com
 (2603:10b6:208:329::10) To MN2PR12MB3613.namprd12.prod.outlook.com
 (2603:10b6:208:c1::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB3613:EE_|CY5PR12MB6525:EE_
X-MS-Office365-Filtering-Correlation-Id: cebca1c4-9876-4ffb-9ebb-08de2b8f96e3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MIGRm4l35urzs/yE7bNy1DxPNkaeSnPeorAl3I6CK6rpzmN5uvsPnNAPHAMH?=
 =?us-ascii?Q?YseYSkdctpPbXNIOkzj+25SVimxE6FpojO0unpWN/0uUcj2kXS0vFVFu+ulj?=
 =?us-ascii?Q?5n4preX2SJGxa9qcimx09h1DVAlQE9fvKC7eZuBpejpjw4NbVNL/ANY1VtsX?=
 =?us-ascii?Q?T3eGAQtT/xttrNkLqCe+dPTtsBaEesoeWKwZxPvrMjKte6Q4EOsNZd5CWqCq?=
 =?us-ascii?Q?uPaAndm1o8V2Z/9qD3ohYFEWWPpOr/QBk4OBJC1gxHJz1/tMkP0jUD8TlIcW?=
 =?us-ascii?Q?mEvRCs1EUmQ/pYJOpeXs+fLbpp/ofidfdJYcP2L76weUUmxnH88J55nA+FLG?=
 =?us-ascii?Q?HMEATuPWZ9Gg5ZdQj7gTkBilGULJqOjCEXFlPdoaRKUdeTqgdfGBuYt0DVmr?=
 =?us-ascii?Q?SDTruxIBr5rdf+IX1nY4Ddh1VaPDtSCrUT/fKmFqjAq3Hsp1vDXdyuRHMB9Y?=
 =?us-ascii?Q?MkqiX115aWwfaOa087lsmBxRPPCi7XYSjJfXhs0OKscBFj4I8pmreeSr9Blo?=
 =?us-ascii?Q?mUTJaoNvphSJPNZ8WZTqvpItOOmfYj1pU26fbY6LzXPjaQ1JEnTlvI68Ru5O?=
 =?us-ascii?Q?NR1VyudMQ+lZ0WaAucos+AsTMeRp7rBrCswvWlI3fQFgyvMrVgDm6GE/q+Ki?=
 =?us-ascii?Q?sc85w58TXLtHGZ/xSzMkZN55Dt7dc0RHuDPLgK883XOC1V4tMm+AvcH1FTf0?=
 =?us-ascii?Q?AKRBnJWVKfgdHZjcd4BoqsaP1BMw8+riS1CXmcY+P0rQ84+q2GMVyKegWR2K?=
 =?us-ascii?Q?nUuc6aprbs7i6oDUSqsgENAK5qESr9OvLXmCXSFL2S6ElaEGiXj94hQlcJQ9?=
 =?us-ascii?Q?WNdPJCf4/Bq1uHLods0do696VFsgjwS9LnJAOGrXBQgBDi5BxnjHuoViMpXq?=
 =?us-ascii?Q?a2o1h0VvPDfO2YWcmwfs/RBa5wBNmdsqY40fzYAr8eb58gMP2xaOzoQ6uvLi?=
 =?us-ascii?Q?CFlOof3lOM1sLSen7vMt1nc2c/fSAyfEuZmShOg73+Y/tOE0QLIq3QMJHMgx?=
 =?us-ascii?Q?YvgNMN0fe2V7r/KWHs517HcX1MjLGoTozcdiXlMu1KRfJh7EmolHZrhCmoiK?=
 =?us-ascii?Q?dSSyOTMDfWsYrkCmwfAjXemNSSDubqynGSXHbXh8ebA8Jd17WLXMaCEzbZ7V?=
 =?us-ascii?Q?CdLcjCnVKIIkPWCr0SAhRMyDZekuSgkBwWro/OakrRF9YWv6q7Q1b1GJwvfO?=
 =?us-ascii?Q?Sdboci3jNgw7khWBWaasAK3cOh04Vqgn9bYAae3T5+WSybWvsEXLK25y1jNV?=
 =?us-ascii?Q?hhnsHq8dC+O1Px4RW+UXbH1rn1B7xTOxq+jlU2hD8z50qbOdTT7K1tueb5Sa?=
 =?us-ascii?Q?7LiGVvPQUXf9LONix7kQldIl0qnC/xi+hygm97bMxbyR2rGmdmRljF/9S0aA?=
 =?us-ascii?Q?T7bKtnN+AViMbslEWdSLjSI+uLzxXERge76EO8Y2cx5TZUHIOS8epVDehQtf?=
 =?us-ascii?Q?CTuny1EU01VEXgfh7cL/B6CfF1kBxPWe3UozPgdwR2X04dzOomv80Q=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB3613.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?f409fIjsx9E5ylCucGIf/Rn5uOPcCznVNx772gBnzY6BsAF46AuycGD5XAzU?=
 =?us-ascii?Q?mS3XzWSTI4pgeqw50ml60rZBpVtRkvdm57h/oMP9sSCy8NaXrmf7YgolmJsk?=
 =?us-ascii?Q?mJQYq1PE/RdjKIEnffpeo+6V6xsNe8BrdIG0ykVxvI6sruurh9Wk9tyUK41b?=
 =?us-ascii?Q?WA/uXM1dV7nZnPToQxxFJeEzT2R+1AfmvoZH2rAimfOQbtmgkxUia0WBXFXp?=
 =?us-ascii?Q?CL0Ly3B8QkXTXJt+QnH6mRlrn0lxQD9hdd1GcIiK1i8VvVLaWLR9PQXCLrA2?=
 =?us-ascii?Q?0MYK+LiIYBYZo1hnEmKRy4JXBm54jUzCfvjWzZilsoC08kf7WfgI3HosOCSm?=
 =?us-ascii?Q?QwfF7HV64Gar7oEE+qmpNCIsHhEqYXnUFw0NiuHf7Sy2MUxlpgxFS/oOtH4X?=
 =?us-ascii?Q?P1jfxT1T3LYlaq94zCMn4cgu9ZlDsgDJ4ihxOZpMj8fGwNq8v0UqcO/eU7iN?=
 =?us-ascii?Q?cjhvx17yNvNc60Ew9z+4oDETUlCFr1PirsSShXsAYrg5Rm25QouTb7LH6q/1?=
 =?us-ascii?Q?2h66mqNzAm+k31kBjTPQAdw5sns7L4d6B8uIlqbuKojQ0AGB7yzXZPB2UUxW?=
 =?us-ascii?Q?n1h73HX/3k69HNkcEDMSTKBkL+f3ezymEAf/Bb2G/cmXWQfUjX3Nq8jmtfWE?=
 =?us-ascii?Q?FtWih+rSU6N6etHWO6eFKoZe5rxF8FEZoKahvLp1jvMkOP/MhtEvn60rnsE8?=
 =?us-ascii?Q?b58OV1vfuZK0APMUk+Xb6Xp8gpSFomupWZO6S+pj7NGB5umXNkLPamGNqFOC?=
 =?us-ascii?Q?C1vBsd9VNXp/A4eUqTamAHaS3V03jRoTtVykTLAd/NE8LjIpWA3fkCI6cuHK?=
 =?us-ascii?Q?ZRNrPtMTP8W90Qtc2MGtXQUiiOM3CltCdyi0kA9Hk4hCbByEoxscj77/ZdUb?=
 =?us-ascii?Q?vN3OkJ3GMKuTH6XqiA322lWZ6TSkCSeLw5pi8PavErpNo9jFSNPfti0OsgD1?=
 =?us-ascii?Q?DoGSRe0n74Hggpaxs5Lzf/YnuSui+JAYTeRRSjli2ucgk7MyebOnkN9LPAHw?=
 =?us-ascii?Q?Z07jvLz9rhizG/+GRqq3MFnJPehfBqD6y2HObgSNSD0jNEjnLeTmeNvPD7TV?=
 =?us-ascii?Q?/TLRm6s1JK4HmWKHoCf6kldkQLk558sS/kPUaBrLxJuVkKoO5b009p67ORa7?=
 =?us-ascii?Q?YAk979B814e4XcGJHypvhQevjFeLaaxyivxJYPdj0HB4MB/Eb0+W/3OKwD0Z?=
 =?us-ascii?Q?u0pKiFgQekOQTFk3xSrxDsXJbZByShqIWkVK2eV1yTtGCBHYDOFdINWauJFA?=
 =?us-ascii?Q?xpNXvAw7LykaU9cQwnaMEctKUYoHemISmo9+hJYXS7XOYoliK6+6Z0zm94dH?=
 =?us-ascii?Q?xtryfsY8VGBjS9f5HJA3klKUCIzdgu12v5Ubpj5qA5ReyEET9FV6Om89cQre?=
 =?us-ascii?Q?QQSrabW5OW2Miamb1hdYest+WfA5dih1D2I0PMzEvltzMHe1AS95mQSPvu6x?=
 =?us-ascii?Q?7raXlVvuvjTbhyE7jmHTseMVsSGgQIiIPrHf1iNmT/uEOBrI95RmNGX68I3+?=
 =?us-ascii?Q?hg89C5rQPlmDmp24gEgRh6GpsiUSwMNm5OgDOOugSPzHc5DTKcX5vtWYkOBz?=
 =?us-ascii?Q?PKlxSt2RDAKoe48u6mo=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cebca1c4-9876-4ffb-9ebb-08de2b8f96e3
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB3613.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 19:28:04.7706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ij5p3qXThVUkXr7GXEyTNJYMt2DJb1LKFVzfgUwORq2mSCJmmY52col/OlOUSMzW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6525
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25A908000F
X-Stat-Signature: wpqmj376ninonpjjb4iyetcuirq5ahxp
X-HE-Tag: 1764012490-277876
X-HE-Meta: U2FsdGVkX18Emb7BNMCTscoRffK0FTW4yzT1bmhzHCh3n/A+HxKhKKp4qnk1Cj2+NVc+Q+Tp5yZIVVvTXc2tLJbwbSMemhVNwUMiGGSUnRufFiECJNc/UTqHAlKOVhAUw+B8WoNGLZ0l5miFonRAlQmYyoDQM+jP3OsS2zB2J32dHA7MrZ7eao7lk2H1FB+UVRILnpAtFOH03V7ySkXixeNuGRM7wj/1XZb9Jgq/vQSgSCUb5VD6u5NRb2sZc+d+xrDlaqhLIhJxK6+yY6tt3WXox+9Fwyzx+ppvr6TctQCO1/XUEqlqvizh+lbRU4k850C6nrXSjAGFYJzPGY3AglJE2WBcbHNQop3bqfc6HCBtKwlDMXNLBuKyW+0MbGimArXC2F67gCJ70FaXA6YhojdHd6WJwM6gAWsNWzT66CPdixtjEvSN4843M9wyCMwoLBqUPNsPlAZVMEFwpJz1E5gsQ+bdtJzx9MQaQjMg/eOtPMAEF8hsERzu3eUBg0VmwUJQW4a3UwDrOzWuBkPYCjMYLj/V1sFellfgkrVeyXS8E9Wplg6DYzouskjPtLaWugQWusZql/iCsumKRH1F8AbCjiE0ojBMq/tSMOmOI9hQQMHb1n37YTiV4jdEtU+pU9oQZs0+25DGRrND1Tyi7/NOUlynkY67vkjQ7gAS2AXOVrML8ImpztFby15n7nt3g8kS0OOKLl/QQnY2EeXqASGDh96bI/X5uQzoecpA2tzObPvEICpGM1mLGj9NzgA9fNxlskLrhqEVIn9ViAqQ7Tav7jATtr6m3mJH3v91lx5piV0I6Cvu3sCL9BPCMblhdBfQnSJVQgJqn88kEARFlADRnyBGlH5p5gDapsUeUKN3q8v48+fJCllDW3I3XdVU+CSeBNNOdagD1XLTbzYCUFxt+Uti0+yE5IuovpVIQ9vEXtx7VRicOuaBweaJWrg/J+Ce8qCclWHfHjMGLMp
 AhXAZmL3
 ln7JiW7/8g4I2SdxmBZuBsc51pydbYv9ketLokr9Lg4bxKcbLLDM5tdHVAt93m1DqBAk5aELOM8NwMkTfM/ISAbBxSBDlfBPNW20gqSDXho94LXtKcDJtjox/OYsC4/d0J1ONqlwlFAy3UDhsqtJDsdmnGCkp+urd3yuytqXRrIZSwILvDuiXmsKG9YELCcCNRYr8JqlI/uZg2kdLBRMdRJOV08TaY59F1roRIVDBCjqIOFJgJq5tETbMKcijGnGt6PHNCq7v0X+Zh7ivyFUHEoP5B8PNUB1vo6Q/dHMrpBKL9yEe0/3l7TjL2jJTqSEyJfd74hljZyKbrzROv3HyV6UfsWTjsfYiF9ZcR8p03IApFg9s3jxU2y8s/ClXBelRlx09rk/S3YN0ymFlIj5Ru46MihjPmFq1twIs6NMpBXoe9sZB35ze5V1D69aPslHSq59tjIMAK8h8ul+xU6MqSXUXB8ZbEuhxeU5ux/oXkjOMFRjOXuexC+O02zPUK1qedkIlrinO+F7fsB7TVwQV/8fwfVh+ZEBXG1wopq+Yy75RMD+JkX+aJVwUtvC+PUrQfsGc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:42:40AM +0100, Shameer Kolothum wrote:
> The function hugetlb_reserve_pages() returns the number of pages added
> to the reservation map on success and a negative error code on failure
> (e.g. -EINVAL, -ENOMEM). However, in some error paths, it may return -1
> directly.
> 
> For example, a failure at:
> 
>     if (hugetlb_acct_memory(h, gbl_reserve) < 0)
>         goto out_put_pages;
> 
> results in returning -1 (since add = -1), which may be misinterpreted
> in userspace as -EPERM.
> 
> Fix this by explicitly capturing and propagating the return values from
> helper functions, and using -EINVAL for all other failure cases.
> 
> Fixes: 986f5f2b4be3 ("mm/hugetlb: make hugetlb_reserve_pages() return nr of entries updated")
> Signed-off-by: Shameer Kolothum <skolothumtho@nvidia.com>
> ---
>  Addressed commenst from v1. Thanks!
>  https://lore.kernel.org/linux-mm/20251022102956.245736-1-skolothumtho@nvidia.com/
> ---
>  mm/hugetlb.c | 25 ++++++++++++++++++-------
>  1 file changed, 18 insertions(+), 7 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason

