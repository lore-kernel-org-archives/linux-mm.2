Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8B95D46604
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121326B00A4; Thu, 15 Jan 2026 13:28:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0772A6B00A6; Thu, 15 Jan 2026 13:28:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDDD6B00A8; Thu, 15 Jan 2026 13:28:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B5E106B00A4
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:28:04 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 783FE16040C
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:28:04 +0000 (UTC)
X-FDA: 84335032488.03.1BB77F7
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3388C0010
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:28:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ic1wOEjt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FKqX5NQU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768501681; a=rsa-sha256;
	cv=pass;
	b=n1zzdu06rCDmXJ6+T29S71/+sn/aRNGDoQfjOmBFueWeq2irhYJk1VRAyrcZKVNL/3iN+L
	kk+JyIaYMBBHXUpfZwBBpDH82fqGFPMRMtp3xccjpTlWsUP1nmmB/O4wvhtZqyA/cmUojk
	yZ9VlKFqbqGmoj7wyYj4vYtO6wdvSW4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ic1wOEjt;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=FKqX5NQU;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=;
	b=ubdRF8U+L9oihlRu03cMwV8fxN4vtrxcbUU7zONayI7OU+P2iq6s+OeDIjbgyAeTtlGYc9
	s+kl6zOrXa+cKj0l2dnuna1FGv88Zjnmf/IvfrGlk/ISHXo47TEjR2Z5nIYhXEF6qaZU3D
	N49Rrag6A/dD0MHXpPs7jutmsBnHtAw=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FGVtlp2753003;
	Thu, 15 Jan 2026 18:27:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=; b=
	ic1wOEjtWSTrIq3kgrnhoMWx4G+Dllj9OUnQ3cHXOFq4YjvR83iJqBWN0sHPxaxV
	S5w3VcIGwULd0dj8+nFUM+QXkvGTZ8SV8lYftZj44gCt7q7QbHoIsBEVG6byEWWm
	iPem8Ehm6i6F26dT0oKB1/A5gzvwNpt/H0j1OxGCOiDkiEt4mOlA/aq3YWB1JnKO
	Xe/NhjAmRSEGrNygV1aUlNZTYGcbfXIuuRt9Lfpc1RSOP/ZK635kgqGmFIrfinnj
	47hDwJXTP2FTE3n2upXPokLysbPJ5as9f0QITYvlWPWnOoJtb1oYikfSO1F3Xzdy
	sFSMEfgrU1kShZ4HD8IhQA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgrc9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FI44wP035388;
	Thu, 15 Jan 2026 18:27:47 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010025.outbound.protection.outlook.com [52.101.56.25])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7bn9n7-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 18:27:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y5j69fLOGq9pACqOYaK40o0gPus/dEsipyU8huiQ9N/HfauGPvou26ZekwhJAoFZQBmRpvUhTfQEXyvCp60nqFxTVhWoRjeB0OAdWyzRGj1IrJxOwB4df/2pKkR0RLwl/JOy3fjZ7cPSEMpuDV3pdgYq7zxIq1GZUXdpkmnn3s6Jja5jlzQR3MvoYEM6BOg4VLQxh6zKQZsg1UVDvNlTt5P3iZWIG8P0eBK4Cwatpn86qLjLE/XSAlLFKXX9oZJkJldpgybF71LmdZHHNmLfdaTNTjfSZMHhyClkvy7iwMNK/Fqo9e1SHIkLuswmQvN39XmOgoFz1QXVsxHUqw7l0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=;
 b=U2LyX/yzMSFpvsl1CvWJGYFZt0g3pF6bRhph45SuzLOjiibbTZdm44z3zLRyRUd6xGdywzJmHrINeTzfia3z354mLLQ3R1k0gFcVlG8R4oE21570EustO871aMqFrDw5WIlEWhBKxY2b5ISGmP+9b/KO6cz1c/qcIGJbpfoPkBFBiHj9YKU9JJdv4ix+KZP0QOhCBtwG08AXkYI5hd7QBn6Rw+z/M7jZDx2QNw4ItdoHjn9RymEZ04SqULUvz10QZycQoqaUjRTTZ+SD39QXmbf9nrtQ6beQsAKoro8hYUDqDGiBuBrukOFaZ9LSRn50Et2v/k0t1y3VT+RqEOU7HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gy/gNtftho/pBCoUcELF9QaGj7k4/VSmefuiZMFqGo8=;
 b=FKqX5NQUaECjm2CFpd6p+EyzwKjblAhisBg0vSXJAHYxykefVp6LEW92f1TkUXiRBX44rGB5ZpNHgY8fYfLtLuVVARfd9jUvaK+DfHtilpM0PZo1vnfXorjpQ2UXDjYMoHREtuPLgCXXZSZeCzGtwwHwSYqB7qjEziPZHidk810=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SJ5PPF0BB87A13E.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::78a) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Thu, 15 Jan
 2026 18:27:43 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.003; Thu, 15 Jan 2026
 18:27:43 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, shikemeng@huaweicloud.com,
        kasong@tencent.com, nphamcs@gmail.com, bhe@redhat.com,
        baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 08/10] mm/vma: Use unmap_desc in exit_mmap() and vms_clear_ptes()
Date: Thu, 15 Jan 2026 13:27:18 -0500
Message-ID: <20260115182720.1691130-9-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
References: <20260115182720.1691130-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0030.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d3::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SJ5PPF0BB87A13E:EE_
X-MS-Office365-Filtering-Correlation-Id: 9903c8dd-3ab8-40b9-fd68-08de5463c588
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?7d0f0DERdvFQ85QJP20LWmfwF4UDqp45wK100jaNI+/UiWsb8LmyBejOpZ56?=
 =?us-ascii?Q?hxrOFLvSnCye0HF4r5Sw5RfxyaF+khJhFKHjhUP56qy7zwAO1RQ+yaAx0Pwj?=
 =?us-ascii?Q?s55th3odbnQGcbmgkz+4BbGaDUmiLf5dQ1ijnaEZFX9KlmdrT7hXyxmWOT0G?=
 =?us-ascii?Q?aJId11H4j3OtqFqTjpcHyLv2AUz0XW/DjbGBJVqd8GWGcZUC9om2X1DOmk3j?=
 =?us-ascii?Q?xwQhO7LqrbhVgpC3N49QsI8PXvqYPhbMzBqpbRE8J25P+utM6aQ6vT5fycn1?=
 =?us-ascii?Q?3ogkOpFJPQFg8akYCP5vIhUMaUBqWpagE0j+vKWKtfqaoli69q6uXjYrvfDY?=
 =?us-ascii?Q?fNh/SFSdA/5YfBTkAb3RCOOja3GZivhrFdeLm4FLv2kT5pYVPo4M/QR5COqL?=
 =?us-ascii?Q?OrNyR/QWPH57J1QetGt0VssgYOlyqrh5vWkOSBXIfIF7jG6c1FkTx7figB9L?=
 =?us-ascii?Q?7GUy8ElvLT9rFj3QI7CoY3Y2OfAajm/y2bJRZ13CSoOdnkOySlbmuCXovCMq?=
 =?us-ascii?Q?ekrDYFEExfNmk1UgBDg2p9emti/M8skgVEE8h8/Y/s8gQQbqLdE/lFWtmP35?=
 =?us-ascii?Q?66aBmpPzzWVrQVX3SU2a/PKjz84QR0RdK7OblVn2+2yrfFw/7LgrQPzYqQH5?=
 =?us-ascii?Q?VfePGBNbHpDH1QdV5wXVyNBuY84gTAkkQwcC99asIEbIiW8Czd/G+R/Tk9Pr?=
 =?us-ascii?Q?mXUJ0GPaJV/WkdouQwB7lkhN50IzaQxGt1HSsBNLEQP6g8+p32ozosQB1FGQ?=
 =?us-ascii?Q?jXZG1zIP+n54Hdb0mSOuWLl6Pj5RiVExB6yVRSAL5qwLeRlVsUJs3JoWD7Vk?=
 =?us-ascii?Q?WL+3h2MS8xYCMBgWB67kfwXczlle6Kq1oO4PXsRUB+8ejr5x/GOJYDuVl2jJ?=
 =?us-ascii?Q?eqRWXrWhADIVWUoYjPymEJTtYNC0wVIVPi7ytlEz/dFThFTg+85t9mggcTBw?=
 =?us-ascii?Q?h02GWF5n1H9sSHi/9/Wr3WBu0mMBLtMnEq8UwqdAQwKdYErOIv8ZP97U6vun?=
 =?us-ascii?Q?hXUp+lLrTCLuGqYplipesCuzI6vbZCjJuecmOV2P3Jbc7Wl5RNga/6WJAOow?=
 =?us-ascii?Q?JOJ5e782P+pFQSNzNuNaPkPRXxuC4/R5DBwJPT7Jr6dbw8uw7+jmaZ5uQKvc?=
 =?us-ascii?Q?YAA8x2Ip/4tZz3L2+/1mVy67lCEL5WOMr7GoOEtvYQZ5v5HAGMuI1JSrm24l?=
 =?us-ascii?Q?ncBdEPdET1AZtR2s5CCkLsYfn7g4u4YFKHouxK3BeAJ55ziwelDtkdZP6RcI?=
 =?us-ascii?Q?KC7Tj9UZ1r/z2o4ifQydiKvQ0pxDI2n9uOMcS1fw+OM8V8mikbwjUi74HLQ3?=
 =?us-ascii?Q?hSgBJXrrdoaYju6wgO1B6wSUBhcXI+X3nrpfSP1JPUIjcRRGQ+jZOhT/egPf?=
 =?us-ascii?Q?c238sCnjQaln/rfhKitNX8WPoJfW2ec8tyl99jTj5a9+5v8Z6dezKvqQhLzw?=
 =?us-ascii?Q?0tqwaG5mjDh1YjfkPHfd0eokTWV3vF2zNMZPZokuKUsBXbsJU3vZtZvoF9Hc?=
 =?us-ascii?Q?snaYWS1GwQspjFZM7T6cwd5Zho99pt4370vFkNEPMsByE7jGaEgSqfnP5FXi?=
 =?us-ascii?Q?uq/DGbm5MeA9ZcqBEFM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?sQlEQFwalnfn2xX+LusAwW3+Vuz9NCbslxZ7Jk6lk3fipPZjJ3rPDgkPuqjT?=
 =?us-ascii?Q?JQ5tIOghPxrRfytI9F9PG8Iu/9Qe4WR9gQzG675yjBfj6CYFkQY7GWQnl11L?=
 =?us-ascii?Q?Hrn+d7XknOHdRr0dAnBA+bt5WhR4lHGxJMccZjxWMhreALY5a9HdlN88W/s6?=
 =?us-ascii?Q?2c74yl/+0yKv49M4LXvfpuWcWxVuxyh5j68THZrcYefPotqP3chvwe7OnWLE?=
 =?us-ascii?Q?gIeeBVope1jHQFLH7iLRBZi2rvS5GimpO2aipQEgzNNtqTJup65PZB2rSGva?=
 =?us-ascii?Q?BojzMjxUzuas3RX6kc61rv/MKlMnb2+dKV3+z3FEMPt5bkmchq1RT/bkz28f?=
 =?us-ascii?Q?hHEOE93K4YKNSbGyZ3Z1gMs993PB8ljkZF7wtud3nW8k/vVlxQZRbGPVkMVm?=
 =?us-ascii?Q?ZeC1Oe/QQcrjwRjZhvJBkYfJh+0Bx7WQy5CyzHww0DOTmuK4XAxSRxUDnRB2?=
 =?us-ascii?Q?oQs0yXMHZHCpdrMxX4rs+LfLqGhANSOqaUXI3bUhTewMgvZ+R2joFQqS+zzc?=
 =?us-ascii?Q?yb8anJpr6bM0KnFj4PovvQWbjV0tWrsC3h9B8k/hbQqo9DEsdz5TTzmp4eDE?=
 =?us-ascii?Q?NOoEmG8stDfNvGyL1oIaDADHvw0jsglJGO90oqG3CXKAsmZ2dADHAY5coZIJ?=
 =?us-ascii?Q?PoPeTGhCUJJBK+bA38FDOdJrn1vkLBspgY6uf+UNpWZ0fCWaLAlTUMM6QJSN?=
 =?us-ascii?Q?gwir2B+O9ZqPPL5KGtCFd1MqrFgmjdanxgFzmFezIICNqr8UXQTFJbSt2pBl?=
 =?us-ascii?Q?GuMH9hil7QtOPU2Gfm4uFFHrf80DrWV42adHptODG4pMVbuHW6lgDJP1Ziee?=
 =?us-ascii?Q?JBBay9Oj5hQLebnp6kY2V07hRPuzn3cZ0ozRuElM3RxcD5DzwKlJ7PjA0YIO?=
 =?us-ascii?Q?8VBAnNEFmyefbovgnudKquiwFxclOCPOkiDwFjV/rC33LhLpwrshUm8nrF+u?=
 =?us-ascii?Q?zdRpg8lk7veQx2gqB8gf190W8ssZ8UG+3Yj35oA6X2TVlcdsaiaBzwQ8HsS3?=
 =?us-ascii?Q?AfeoXw+pyMkI2Mnfh5qVmd7nf7UES1sXi+eZ4NFJBTIKdk8VVF5gXM1Dj1D/?=
 =?us-ascii?Q?/OPgvcW4EHno2UpGfWMmeobJn4l2UpIcQJyCWqulbFLrGAOOXaMMmLyW2fE9?=
 =?us-ascii?Q?iKqq02Omk1bX4+6KP71Ec5A1B0zwSDF3ywLa894hzctfLfNGVetxzxJk2CxB?=
 =?us-ascii?Q?HNhSrtZMeWBUGpUuNgPTpt3Dg3XZPR3Uru4rhVXUOSdcv6CRYJYh0zmMQY3p?=
 =?us-ascii?Q?5btouHLOBI3UO4/huCDG44qvcMzb/D+rLt1I/e3Rg6KfeaBprRexzr35OWOK?=
 =?us-ascii?Q?98dnbtjZIHv1hwnLrrMUsejjm49DcUiRtI5/7TWPu1eZakqioG8fvepbke6a?=
 =?us-ascii?Q?EH/fY4lJuAkb6j5u4iZWknPYCza7cq7AW9yu/IOfkGOo8zEO4LQG4jEIm0vi?=
 =?us-ascii?Q?nJPvRochS3PQNEkye7xBmb+ClIyP1ImNi2QY/ihpeo3zHtGNv7k0cs45HH6C?=
 =?us-ascii?Q?H2kBUBJdf8h5cVvCTJKf70pW2FClPf6FAP/Lrzf0JQbTaz+C+Xl0jwzgMlP0?=
 =?us-ascii?Q?trz+crCEgAIKFE6Dsm69WbFyUmbYmCmDip6pm1QRvLn4ag1MJO6WsTSg/w8S?=
 =?us-ascii?Q?E/Qu0seBazp5cgx8VUD4wCS2rWKZar+tvAbRoa/nL4oDSFkFnv2+n/8ctvFS?=
 =?us-ascii?Q?bTMubRTic/k5I5Q1I6vLXx96sNONpB0Kc3SWG2W8f11SkgsoAPG2OPT9Qjos?=
 =?us-ascii?Q?VWwDsSavJQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	O6SSewP65hs1w6RjoE99MzX2Vpc5R8qIHPRDlw7HcLzy7lxPSiYZgTKvcUBta0/XIwT9r9GUgs2xs8Gbr0Qvkwr1RqJ46DD7yO4/EDKSn8KR1KW38Ang9jWTWJ0TRRvrAEN8Iuu7zdQBzGFvCB4JojPWAmIR0moIN87zElixQNmmEdKErXjcOi7K9jRVt7q3jobZMorRvd857Jvsjl7PVB0/UbfXKr9F05YEB177EbVclPzOA3wKoyztozTsgPkkA+103RxwDvD4o3yLi6OmnWsKlJR6ZteqyW1bM/Rnk+F1IbbDVQTdx+kSU40HmU3LCSVtB9plWQDriSHdAqCoPwDlphr2COZiPTM/6NvVJYFAM5Z4pXun5EdMPO7ofpg3o9tpPULEQPAi9UXSgVP0tLfzjSmgs+ZspBGhvJlCc0SR/gUG85BnawEDqzQNbdyOQwXSp1XpU1flAFRzZrZFOMFMu5eqfjPD+LNWTcTCd0EFtjlSPalUtxCECo5d+YlHLcrGhK7/Ac6KHV+BAlIlIBzJ+T67lS0jd9BF6QJP+/seHN62wdgmZX4FC+Le/iU0x8QpBhnILNpCJP7yF5iACycPFGEXAkY84GA12PucKdM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9903c8dd-3ab8-40b9-fd68-08de5463c588
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 18:27:42.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8GweFU2ocMnyTjrZ5XRMGUGhMbuXyjURcyHyMNNN6YH4UhpUmZOQd3y3vMspTGkVG2oOpebzS+VIjTa6KeKlpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF0BB87A13E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_05,2026-01-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 phishscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601150142
X-Proofpoint-GUID: 3vJN_bAv86Rg4GTwT685dKytVlm2bN-a
X-Proofpoint-ORIG-GUID: 3vJN_bAv86Rg4GTwT685dKytVlm2bN-a
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=696931a4 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=yCtcxbmM08XVNiOCcoQA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDE0MiBTYWx0ZWRfX5AlrbWCEK85B
 4GiId1qppLTgHj92DwbK1AMnVVzg7fJ8u/EcvV6gbokj/Y/WBHSSDvAgO4vevHGPqCRSCLhYxvg
 CfAHBRHJlbvAhfTx/NesmWr4LADD4TVB3q++64uWbEQpM8FWRzxHcUHfemToKO8aC6EqzVik7So
 m1h9wuwypFK5ADA5yI5gXMZ5zJyUqQCXYdXiokH39vaPlclmGOWFNqegexI+uZUzmT+CKu9aNul
 P0j9psWdTCXNMcCE2e0QaXtLQ5HAKDRFCSn2MujTHoG+j7FQaWJmQH54P2H6okOM8sEABrWiLOh
 JLMJmkb3G3rXq3elxjuqjhxQOH/KWs7wKa/Vm/RMnf4jcsKtnJAj1kVbZIDwoTb3Wmd/TXZugKG
 +E7ON3senx/z8C29kAOK/pLBA/sd7Lr8L7/Hra49o8hY8YwcxwfuIMeo9Mg+G62rhvgoDx5clqA
 QlZa9oeX5Wq4PmvNJZA==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3388C0010
X-Stat-Signature: ot67a6p3j8fiihzkb786aesyrewz87tz
X-Rspam-User: 
X-HE-Tag: 1768501680-303047
X-HE-Meta: U2FsdGVkX19oECmO/eDrC91MtQxvgKqz3qj9yZubf3zSYOfBtpC9wjDhTXLbNzTUl7Sfpxhj0OXzyK2PhQkYE1ukc+30T41W9RtqfFo8AyFxyOLkuI9oM9UqUCAbL/N9PiCMRtbo9/Wb/lDeepOfYIH5nBtq7kQ+MogCwo2qYBTMQXEi5WgECrctG7NxsUeiFFvOSN58bKGgWmbfxBUOtLzI70LwTjGwllpivHfyUmVocasUd95Zwv+pDFMGwtMkM21yB61nzeNWIXMLPkJcW5+5GC9Rkgu4tmnSFIHwHq5DQdJPI6ha6eplF0i6RuQgyKy6SUJkPY5E/7DXZ9GjPzAeTd7wHI0yAlgkrIf/dD1GH4XLVIsezYmJVisrVL71iujOBS1PyjYc7k8prPSWh4zddHSL4sXeNiSr9aSYuZzBEli/sO14SgWi+L+EmlcR6Se0TWhjlsNmvBHfht7Gm2kW/XFmHjlpuACtzKS+QA/NK2Yo633TY7V8sZ4GfYPKufuNgqxxM8gRH/iQ9HPm4LjNy5yseIhQZ+cB4/BY6R5+M6yXAbXvTmo7bb41qHumoIO6BzHqEO+C8ieL1dbAAUl3lm+pJR4QBecWwW4tgBoI/ZKDJXGSYjLXUOuQRXngN4CyfY3MgDEmyzpY9iDXcsugAO/lXugTnUAOWsnS8oWYq7aFe/4lNh1DrY6Kpfr1RocKI5oYvk6ELt4wQ+7xW6pj8KN9NApejs9ZtRc66hcKfWdsrTplT808T82rJAtxmooYxJghhHGPreuz3k66P8fQS7nrZNY3xnKn4J0ZtoF3uBjrDkWMt81nbCa4yuN6Vs6JbWcohBsfoD+9rqOdU7kvletRPvyFtjt0cIX3pd/IzcI2XS3XbfObbLZf1MHo3uUCmdx9r7BxHQ0UPGRKLfhHSl3xRyekTovNbNrhN5UBKy1VEq/7uPvnZt7ZGf83usqJytYId0YkPhFZks0
 ub25SUyg
 l4oaD6yy43q/uMBmGbLHALQAZurkJQXOE1o92KEilG/M92IJ79wBMKLKvQNBQF7ltpXbfQsOmrX/q10++BOvyV75IH2XzKEgUFmtq2BwWz1WsMRcJOmCauH9IclnPVjVQyX7PfksKpCkIAiEjAfJQtBWoThvFVYjQDSUB0L3odO3W25GKUyQU1Xna+fwcRzNfxkXBb97lKI0ScG7ni7HGLBy2eVGwvMIJk1dMAhxul2mzst6b95TSENDFulM04V0IgP9Xf1eXVO06pl3IngS3KVbsKZID43BieDzr83RqteOOB4i7WT3lxdaUuT1/B9ADhbg+S93LqBpVpcCpU7Ymg6F5Z62URswrXKJNPoqb2bb5SJqJlONl+xYqKe0GGiXGEFDqmYCMo/zW6xLnopj8V4HMS5z3EVZeqDjpe89IRScHfz0rwJ5awHWIK+71OXQ5w1ErFNrAxS68zrLPsA9ffhruSLfCrAGDkvNpV4pijq85JdOZfgf3GFG8W4k4nmDRbWqbM0KU540sM748EOQ5h4K9N5wcqqmvkqLeOKx4T5LxNV0uX9QBiLikSJhVq0fPOPlpE3ZDr/Q/WMrzcLwCoEXBH9OxkoSfDnicfuTEyeFJ/oeYIRngYyxL7MlkWIU5iMNsEiE0uAflXn8FeiCCuHvk0BuerYtXYcA6knGENwqFVb3LsaLwFowJL52pUmSi5QVyHk7WrOnvqPg5PgfBRw1ThsoQPejfPYFi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert vms_clear_ptes() to use unmap_desc to call unmap_vmas() instead
of the large argument list.  The UNMAP_STATE() cannot be used because
the vma iterator in the vms does not point to the correct maple state
(mas_detach), and the tree_end will be set incorrectly.  Setting up the
arguments manually avoids setting the struct up incorrectly and doing
extra work to get the correct pagetable range.

exit_mmap() also calls unmap_vmas() with many arguments.  Using the
unmap_all_init() function to set the unmap descriptor for all vmas makes
this a bit easier to read.

Update to the vma test code is necessary to ensure testing continues to
function.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/mm.h               |  4 ----
 mm/internal.h                    |  3 +++
 mm/memory.c                      | 20 ++++++++------------
 mm/mmap.c                        |  4 +++-
 mm/vma.c                         | 27 ++++++++++++++++++++++-----
 mm/vma.h                         | 14 ++++++++++++++
 tools/testing/vma/vma_internal.h |  6 +++---
 7 files changed, 53 insertions(+), 25 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index cb3de0c73d030..3164b897283f1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2624,10 +2624,6 @@ static inline void zap_vma_pages(struct vm_area_struct *vma)
 	zap_page_range_single(vma, vma->vm_start,
 			      vma->vm_end - vma->vm_start, NULL);
 }
-void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		struct vm_area_struct *start_vma, unsigned long start,
-		unsigned long end, unsigned long tree_end);
-
 struct mmu_notifier_range;
 
 void free_pgd_range(struct mmu_gather *tlb, unsigned long addr,
diff --git a/mm/internal.h b/mm/internal.h
index 2cdc5c9396f10..25a17eea550b8 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -197,6 +197,9 @@ static inline void vma_close(struct vm_area_struct *vma)
 	}
 }
 
+/* unmap_vmas is in mm/memory.c */
+void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap);
+
 #ifdef CONFIG_MMU
 
 static inline void get_anon_vma(struct anon_vma *anon_vma)
diff --git a/mm/memory.c b/mm/memory.c
index 4331a6abe3e4c..6fd6decc139e9 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2083,11 +2083,7 @@ static void unmap_single_vma(struct mmu_gather *tlb,
 /**
  * unmap_vmas - unmap a range of memory covered by a list of vma's
  * @tlb: address of the caller's struct mmu_gather
- * @mas: the maple state
- * @vma: the starting vma
- * @start_addr: virtual address at which to start unmapping
- * @end_addr: virtual address at which to end unmapping
- * @tree_end: The maximum index to check
+ * @unmap: The unmap_desc
  *
  * Unmap all pages in the vma list.
  *
@@ -2100,10 +2096,9 @@ static void unmap_single_vma(struct mmu_gather *tlb,
  * ensure that any thus-far unmapped pages are flushed before unmap_vmas()
  * drops the lock and schedules.
  */
-void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		struct vm_area_struct *vma, unsigned long start_addr,
-		unsigned long end_addr, unsigned long tree_end)
+void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
+	struct vm_area_struct *vma;
 	struct mmu_notifier_range range;
 	struct zap_details details = {
 		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
@@ -2111,16 +2106,17 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
 		.even_cows = true,
 	};
 
+	vma = unmap->first;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma->vm_mm,
-				start_addr, end_addr);
+				unmap->vma_start, unmap->vma_end);
 	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unsigned long start = start_addr;
-		unsigned long end = end_addr;
+		unsigned long start = unmap->vma_start;
+		unsigned long end = unmap->vma_end;
 		hugetlb_zap_begin(vma, &start, &end);
 		unmap_single_vma(tlb, vma, start, end, &details);
 		hugetlb_zap_end(vma, &details);
-		vma = mas_find(mas, tree_end - 1);
+		vma = mas_find(unmap->mas, unmap->tree_end - 1);
 	} while (vma);
 	mmu_notifier_invalidate_range_end(&range);
 }
diff --git a/mm/mmap.c b/mm/mmap.c
index 4500e61a0d5e4..042b6b4b6ab86 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1277,6 +1277,7 @@ void exit_mmap(struct mm_struct *mm)
 	struct vm_area_struct *vma;
 	unsigned long nr_accounted = 0;
 	VMA_ITERATOR(vmi, mm, 0);
+	struct unmap_desc unmap;
 
 	/* mm's last user has gone, and its about to be pulled down */
 	mmu_notifier_release(mm);
@@ -1292,11 +1293,12 @@ void exit_mmap(struct mm_struct *mm)
 		goto destroy;
 	}
 
+	unmap_all_init(&unmap, &vmi, vma);
 	flush_cache_mm(mm);
 	tlb_gather_mmu_fullmm(&tlb, mm);
 	/* update_hiwater_rss(mm) here? but nobody should be looking */
 	/* Use ULONG_MAX here to ensure all VMAs in the mm are unmapped */
-	unmap_vmas(&tlb, &vmi.mas, vma, 0, ULONG_MAX, ULONG_MAX);
+	unmap_vmas(&tlb, &unmap);
 	mmap_read_unlock(mm);
 
 	/*
diff --git a/mm/vma.c b/mm/vma.c
index 75c68c74c062e..b46c869d4bb07 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -480,8 +480,7 @@ void unmap_region(struct unmap_desc *unmap)
 
 	tlb_gather_mmu(&tlb, mm);
 	update_hiwater_rss(mm);
-	unmap_vmas(&tlb, mas, unmap->first, unmap->vma_start, unmap->vma_end,
-		   unmap->vma_end);
+	unmap_vmas(&tlb, unmap);
 	mas_set(mas, unmap->tree_reset);
 	free_pgtables(&tlb, mas, unmap->first, unmap->pg_start, unmap->pg_end,
 		      unmap->tree_end, unmap->mm_wr_locked);
@@ -1257,6 +1256,26 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 		    struct ma_state *mas_detach, bool mm_wr_locked)
 {
 	struct mmu_gather tlb;
+	struct unmap_desc unmap = {
+		.mas = mas_detach,
+		.first = vms->vma,
+		/* start and end may be different if there is no prev or next vma. */
+		.pg_start = vms->unmap_start,
+		.pg_end = vms->unmap_end,
+		.vma_start = vms->start,
+		.vma_end = vms->end,
+		/*
+		 * The tree limits and reset differ from the normal case since it's a
+		 * side-tree
+		 */
+		.tree_reset = 1,
+		.tree_end = vms->vma_count,
+		/*
+		 * We can free page tables without write-locking mmap_lock because VMAs
+		 * were isolated before we downgraded mmap_lock.
+		 */
+		.mm_wr_locked = mm_wr_locked,
+	};
 
 	if (!vms->clear_ptes) /* Nothing to do */
 		return;
@@ -1268,9 +1287,7 @@ static inline void vms_clear_ptes(struct vma_munmap_struct *vms,
 	mas_set(mas_detach, 1);
 	tlb_gather_mmu(&tlb, vms->vma->vm_mm);
 	update_hiwater_rss(vms->vma->vm_mm);
-	unmap_vmas(&tlb, mas_detach, vms->vma, vms->start, vms->end,
-		   vms->vma_count);
-
+	unmap_vmas(&tlb, &unmap);
 	mas_set(mas_detach, 1);
 	/* start and end may be different if there is no prev or next vma. */
 	free_pgtables(&tlb, mas_detach, vms->vma, vms->unmap_start,
diff --git a/mm/vma.h b/mm/vma.h
index cca7553c7d641..bb7fa5d2bde25 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -167,6 +167,20 @@ struct unmap_desc {
 	bool mm_wr_locked;            /* If the mmap write lock is held */
 };
 
+static inline void unmap_all_init(struct unmap_desc *unmap,
+		struct vma_iterator *vmi, struct vm_area_struct *vma)
+{
+	unmap->mas = &vmi->mas;
+	unmap->first = vma;
+	unmap->pg_start = FIRST_USER_ADDRESS;
+	unmap->pg_end = USER_PGTABLES_CEILING;
+	unmap->vma_start = 0;
+	unmap->vma_end = ULONG_MAX;
+	unmap->tree_end = ULONG_MAX;
+	unmap->tree_reset = vma->vm_end;
+	unmap->mm_wr_locked = false;
+}
+
 #define UNMAP_STATE(name, _vmi, _vma, _vma_start, _vma_end, _prev, _next)      \
 	struct unmap_desc name = {                                             \
 		.mas = &(_vmi)->mas,                                           \
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index f50b8ddee6120..0b4918aac8d6d 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1131,9 +1131,9 @@ static inline void update_hiwater_vm(struct mm_struct *mm)
 {
 }
 
-static inline void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
-		      struct vm_area_struct *vma, unsigned long start_addr,
-		      unsigned long end_addr, unsigned long tree_end)
+struct unmap_desc;
+
+static inline void unmap_vmas(struct mmu_gather *tlb, struct unmap_desc *unmap)
 {
 }
 
-- 
2.47.3


