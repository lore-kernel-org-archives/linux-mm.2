Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F1CCFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 06:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ECB66B0005; Thu, 27 Nov 2025 01:27:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CE96B0011; Thu, 27 Nov 2025 01:27:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0169F6B0012; Thu, 27 Nov 2025 01:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DE3DC6B0005
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 01:27:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7CAA514095B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:27:11 +0000 (UTC)
X-FDA: 84155404662.01.47A092F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1021C40003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 06:27:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C7KcTMlZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="xs/2hA/m";
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764224828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9XI5q9Es5/LZSZ1i3iz3MYz5oc/PYQc1xtgKbCQ2vA=;
	b=4U04KDTPzew+yL/dF6z4S730zP4aH0MvTL2uSwINo7OAaYFz+f0ZlZPPDDEBr2M+GpoZii
	9nHEWn7r33Wj0ridT6U3fa/pyx/sdRElZJRSpOIPVY736hBT73r02wch4epPxZ3csZnYzF
	z/gf5bHBO7uNIYiE1eSQepA8MzXMzH4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C7KcTMlZ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="xs/2hA/m";
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764224828; a=rsa-sha256;
	cv=pass;
	b=ZuyYWZtgPjvyLvG+MXInbBv75eSS8o6WMRgBmN2IZE4Ru2IhOLx9mn6Q10nJzXKZsGiUaJ
	0f1q6CiJ95xGs5A/d8WFGnulz99MMCW69/207IvkFtxoXer4V6yjnMgCMZOF9mB+aMlpvI
	lAIrj7v7CjLd5V3QjhvC4WV7faffD9Y=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AR1N9Bg3676098;
	Thu, 27 Nov 2025 06:26:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l9XI5q9Es5/LZSZ1i3
	iz3MYz5oc/PYQc1xtgKbCQ2vA=; b=C7KcTMlZdqR9brTTug7mj033og7exE/jLI
	yocZVJ0aH75e7Y3PwoQu0KUCaFs6+TCmFWfMzRfHMDEG2BO5Jc1Wx4G44mJOfgZD
	Mn3xH/GHoVQliFj249I7JTAszElFGuQsBwZH90pYy42syKcRtnXGBxRs2OAhhAgD
	43hgKg0Q6JpWf9nFROhKKQWqAn1UKaIJid1kTc0zTlfcZkkZXGWlhkfv6rdnpSoa
	UQhwuZthIFmVZXSIBWs5pqw6AU5t6OqVtkHK1qJ3ijbdMDezHS7P9WkNOY44fQR0
	YIn0nuKaonO4Y9V9L0iTZ4K4ulbirgfc7mEQBa1PfuwVNH4SqJEA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak8ddq8h8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 06:26:55 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AR5BGiW019507;
	Thu, 27 Nov 2025 06:26:54 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011009.outbound.protection.outlook.com [52.101.52.9])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbwjfv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 27 Nov 2025 06:26:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oBuKmLU+COR8bvZKFY7Qsigp6WzqWfCqtNTHV2AOQVZAONlFdDduP5TB7cJFpvQLDVw7ZYlwhx37of6lvJHkJgg1GVxCzSsl04DxiNQ4W+L9zLRo5oTitv/fxNqLqUvl08wezckS8xTQpzKfeft2JoyeJDsA0Z4HUYKC4mmSg5fOxCL1y5fSFltFdKwR9zdf1exlle/ocSQXOSzOQUTfZG8FTyX7HfPNkgxdiFqsd19xzOsyeUrbkTSqcxRksHKLzkmRqwp8O7W12mXymcITp3PSjtMILtF+f2+vyxI6JmQGV1bgHCDAkALkSU09I0PDafc9baqBs4ysqXyt7Dg0bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l9XI5q9Es5/LZSZ1i3iz3MYz5oc/PYQc1xtgKbCQ2vA=;
 b=iOA8qAiOXYhNKD4ta9rC48xfReZWzJL3JdaAs1IFZZTo0rX9FfQaf81xRM9le+B69RQeLI2Fuelat/tj6X1n5R9rNvUBEmCzuPHkWJAy3lHb9/JwDxlG7nORYIETxHl8+XuMh94FlKKyD+fKYZ8C9JVKyeqDYYIueZf/KvOMVDf4vmTdzPXcPCDNnTC7HAMp86RMZ24xUQWz/A7mijoRTniMaMuwYzCDahtcb3lzTykfv8Rkl3sXE6w7fBAPWppx8d+bg5asqVTgx782rPVz9yxnjp3g/g4a8phLY7S4dDTld8j+jQoRLUh9nbOnQXsDxXa7yWvF+kZW6j5r1rbvEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l9XI5q9Es5/LZSZ1i3iz3MYz5oc/PYQc1xtgKbCQ2vA=;
 b=xs/2hA/mgX3lJ9UvYnhtTjIXbsgFTmeoOeXMBKAl/QcZO3Hi+Y/pZ8qRz44ijHxLxVEUq8fxIzr5H0dA0B21pN3l0axGxSlAjoTGwP5sR7AUXHW+ZIdpKxrTCdzMykQ/r8g8zKWiKdfz8krX3uyEpI5W6HwgMOIGlTtfJCzTz9E=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB5698.namprd10.prod.outlook.com (2603:10b6:510:126::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.12; Thu, 27 Nov
 2025 06:26:51 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Thu, 27 Nov 2025
 06:26:51 +0000
Date: Thu, 27 Nov 2025 06:26:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <60dca13b-3405-4137-a6bc-28a7d6795eaa@lucifer.local>
References: <20251126174500.2498895-1-willy@infradead.org>
 <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
 <aSdGvY2UzrXdR2e3@casper.infradead.org>
 <d70b3309-348c-4aa9-9b62-33b8191955fe@lucifer.local>
 <aSdYkYYAuATwYqbD@casper.infradead.org>
 <d8c2a266-fb2c-4374-ab14-4ac910db7ad2@lucifer.local>
 <aSd6oH29iELxxU5o@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aSd6oH29iELxxU5o@casper.infradead.org>
X-ClientProxiedBy: LO4P123CA0091.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:191::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB5698:EE_
X-MS-Office365-Filtering-Correlation-Id: dc728949-94a0-4915-83fe-08de2d7df379
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?rJ3gsz/ZeikSqZa4bi2Z+P0I2Guw+hyQY/KGHTb6mYTno1dngL9YCvyQp+fR?=
 =?us-ascii?Q?bKr+JtL7KAt0Bx0sH+ohghSY/nTyLlwKZM9dDZcRU2wLOLzXTFNIM6lyutzt?=
 =?us-ascii?Q?16xKjoyE/2rDM5aF/P4D5KMq6YPB0ins2J1l1qbdbGeCQmEVJW/VeShJLI2E?=
 =?us-ascii?Q?39LWCgMNeoYgKrbnws9AvgtIXWtQDm82dXz0QKZiCQ/F20B1wm9dJOigREwU?=
 =?us-ascii?Q?rFkn/tLSyfKTvgClMGr5Rz6AF83MyGXzRL6Ek8k6ZmSU55xI7WlINmH1/ZJo?=
 =?us-ascii?Q?o9PpXM2KiVX3kyHTH+a5VXzn2DnefHt3w7hzWc3bi02v41bl2mCa1rXD89Ng?=
 =?us-ascii?Q?i5wDGmOTl0oQ7g8uHAscSYk0uEE3q/S3exQjxLWbKaXktRi32xqBaNQiw4FY?=
 =?us-ascii?Q?3QxAiwrj4KYMztnZlxOfmL7KAaomccBZkI3xwL5BZ3HOxc48WB3CSi4+037v?=
 =?us-ascii?Q?XXES0SAaFo2C7A02MPisNiRoUIiw8yseK2SLNH3rhYAxD4IVGBHy1mtsc8lD?=
 =?us-ascii?Q?FGMHG42IoTaINKTySGY4kO8+jJERRgz8ACG8kh2qw3/ijTxBP7f6RYDvueDl?=
 =?us-ascii?Q?RtEubXTR9IplJA01wohJdl4sC9OYRpUX9Cm9O/+CP5GAgSGfkrPujz4bSJpS?=
 =?us-ascii?Q?CMj3ecR9tJKcjaOLtCGRC7/Q4UHQjp74oZ9PtHb+vLvBGVJynNDiEWf+arKT?=
 =?us-ascii?Q?yvy4Osielg6lrNVjnaOAggSy7QITHy+dYHbUC85SkEqSG5RHeYwXBbVxQ5cB?=
 =?us-ascii?Q?+zw5fPaelTnrgd6mKSJTlh33RbXblJqGAaujtERaa/GZ1TdHU7VC3kMU92l5?=
 =?us-ascii?Q?A5J9j9hOvWCbCsXmZySxk74zynwniXi6H6fIt7iSx5ytoaG+XTcdfGVsFI4f?=
 =?us-ascii?Q?rnT563D823hSooTakscQTVFbJmU4j7keWrQ2HFvX8eRnphuX4fee8QYhIQpy?=
 =?us-ascii?Q?jnQ6cPAmJYZ0/R8ENI4spiKjFURO+ARn9OJk1TM5EMGNOW8KJ+rGQpQLrDTF?=
 =?us-ascii?Q?yGTrjM2NZXKGO0q4PtQQxrBicye3gNYjplytqe0PeqpaOGRyyM0lN/Rf6FPs?=
 =?us-ascii?Q?BSfs6DenK1jFBhILCCoZmDKjW8HHZtbsVobVt/lMy9ugquK2p5V+QRxUfSnN?=
 =?us-ascii?Q?Fv2SWjmQaZ7ATalVkjpaHoyxdlZa9twH05E7omjmWMA50E59doiKiwX+zFuh?=
 =?us-ascii?Q?Bxw0ID8XFdPQZfIVU2aJ5xYBm34Gcx+kxAHQDCv+aVu2cRWzUVRaGJPz5+HD?=
 =?us-ascii?Q?kCS9xdycy5Sa348xbR+yJotzHriCr8aqdqeFoFoCF4nVgr2bPMfUI17Nfw7N?=
 =?us-ascii?Q?IMn5o+IOE6hy+CxJjeXArQgiLg5wDFHfvu6x/H7Slx2saHWcuiTl9qk+EbVG?=
 =?us-ascii?Q?bRYcqbYKdIDbi1vKpUM1k4GpDsubz8skkwRq8uqy6zB71fYcF3/6NURYObWa?=
 =?us-ascii?Q?l65YQ/kw9zezujKiGg3iqY47TsHuqu8TNcZE7VFFfJ8eIs7jCzTOvw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ObnDynABjutGGZA3Z52jiJfX07urB/Loio3Pbc6V4HHPQ5OgiL6WEQRL/dMi?=
 =?us-ascii?Q?BSXwFGqKqzQKYah4M27ZdjcJgd9I2UNK0Vo/kZPOUjn6qR2FIFoC3DinBMA+?=
 =?us-ascii?Q?ii+I7KNfXn5zdQTUEyfRnaI00RBeGKbum98ZpINZSLd11JbZ1ugAvh7XVvMl?=
 =?us-ascii?Q?nUdDnz6sXu5DmM538mLcPErdQvSYjfv7N/8Ruab02wtvG4ZsJ5d0RDexmQJq?=
 =?us-ascii?Q?dqX/D7F/CitM6q7mRZpd9itXsZ9IEtGvqngbAg508QMMK95a4tTX/77z7LSp?=
 =?us-ascii?Q?IGcrcQmNZQcPxS/SIYdNbsJsP5EASP9WvkXJ0p7hpg60DrX/Nr7ZGB3QD9bd?=
 =?us-ascii?Q?Snop3TRo6Ma3I9HGOquVxzDZBe0y4xJ16xynCRhVfTbvSO3yVLD28pH6r7Qz?=
 =?us-ascii?Q?3b6nEAXvoy+n+Eloml/18Gnhb4CBs1gP/rpk+hVMYNHM43iYBETwfquC5f4D?=
 =?us-ascii?Q?yIkNxKCWZp9DKD4LuTNSrK9OpzDCrfiGGQ8NPud76oyrkAlSs9rjrFn0dS0c?=
 =?us-ascii?Q?B/LJHFvFF3TnT9vRZ99kXc/mnuT2JrAfD0T35jkYOLuUgSqMTE1vWyjrigk7?=
 =?us-ascii?Q?JZ0ykP5PLPFkGte8vp7Jcj1J5CIGSLv8pzl7XlBWPvD01zWjyqwdFE4n0SGR?=
 =?us-ascii?Q?tgcoO8WLq+i0qkFy5IYi6z4Bcgb4OSLxGZtkN4T/uJ59aAAr8ApfpOCNyR02?=
 =?us-ascii?Q?zRi9zO1aXie2YobivY/c+twA2xjb377no/aRbDnUYdpW482rnJd24rEpvwfv?=
 =?us-ascii?Q?KxdVZE6GdR3uGJLtoQKVZ23Q/O9pw5ItKIil96p9OXZ36xX11vixFAaIzjpF?=
 =?us-ascii?Q?jSdMDj+o0qIlOgz5JQFUfoucz7EVJl93XcT2k0UgEYKAonp2Ki0vko1usCBe?=
 =?us-ascii?Q?kzcopgb3tkM/5mD1V5IqLc3HgGde3qb1NoGzlh+aY1+shGrE7LObJdXJ6U0e?=
 =?us-ascii?Q?n0aovkXL7Igcn2zYO5dLPg3X9Tt/rxRqXjOR8/1RpwYcTu6nt3ymhz8irwfc?=
 =?us-ascii?Q?zknH/BQzZFzDftRLI8R4R8qH10w9KPg8hpu1ACczGsWIkm5FafhLAvcbfpRf?=
 =?us-ascii?Q?1rARiiglYYExOihBx8TBG/P74v8h1WCd2Gmw+kcEI7Wo7AhvAXyQeSOQ8GUm?=
 =?us-ascii?Q?kYUOqsXHTJlbNAXh0g4D4GuxRi3PikmMcxvNSh1QWFgHeBq2ZW2mciSQyKD3?=
 =?us-ascii?Q?nOHn7gEhTogatZYd1pPeh1nLEZALgnSkQtlMj+lZwZdzyVHP0S2y1S/dRYXr?=
 =?us-ascii?Q?5yIORPihn4crwZ1uR02xpEIxmy7LSLei0dZ3Jyuie8zc7criRSUbxlJJExP+?=
 =?us-ascii?Q?Tk6AxOque6i9IaXo5FqrtHKeBLPZELRANkI4bQOEN4o+pX77ixxccn0NbA4R?=
 =?us-ascii?Q?MIFONh/S4tpkHx/RNANv9bBQNJqpS4tQt85P6uDYGlBT9zAIGrflIyY4ctPW?=
 =?us-ascii?Q?lL03gD1e/SA5lQGpNjgfwwyEe/ML+9yx6FQY9doKX8HMXTGlC4OXavRAqG8n?=
 =?us-ascii?Q?gP27gLTx50BxhVG+0ovi7hGIg35u60hyFjNL1j3VCfXKFwUu0zLSG+HwOZfR?=
 =?us-ascii?Q?nWEP7CbGW+jFRqcWWUr2XdUMwGXU6mRzxBZKRSOqMtywOtGdn1Yb0d5ByDOY?=
 =?us-ascii?Q?Ag=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	pq6H3zx9iq8gl9ZL7hRRipwB9g0zTFkuXCGz5vZmjtpg8yBroFNSeNg9PJB1FkEzTeGYLlcpQcGh6kkxSNIzNa0pV3q95wgEPsje5/yTHFOCQEHcEKBf1GLEYfE231OvwC+WdZeFwcFTcvUv1oJ94L/qd6Tr0UlWTuW/qrxLv3VfLUbCNk2I2s9gAIyiB8Xgo5EpE2Yc7CwfntQSm7iguMPkVl4G2tRzZjKPu4MqmY8q38XxsxyDLhYWJtPVICKuyLX6rTfWq8C+g0zP8CWSq8PqkV9SSckNy6jpRyA+HBE28YbSrWBV3fcQZxewhsQbpyE1nlyx7LxBvRO8rddB1/87bu2G8dKz10oH/ODAw0UeA71RA/7Nd4gue+M5T4NckE+0eqoyh6WFVtyAOy/9Gk/vCrsi/f6uJDrTsnQp19sPDBdA0BrYH+UwrhwUR2gBnLKjglNfcOEq5RsgRzFd8gGCA98iTZD5Sz6COsquDxr+bDj7QeaezKdtWnhXTnnS6lxKAstko+yI+LptbNwQRHlRiMS87ADGUNadFRQ80nhK8g25P7fkrsCaGIsN4zideccXXgSDZM38brLgSF9W1s4K6hx+s5oAY/H1XJDOhVg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc728949-94a0-4915-83fe-08de2d7df379
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2025 06:26:51.2952
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7JJ1ywFIFKEtpDHKTfTXmofXaVB1FwbLw5x55FhpAfZ4maS1sd6f7/YPsbKf4LRF4ZNkoX3GO8Q6h/v79BQbJMAqoX+YApiusfFDKeacWQs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5698
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511270048
X-Proofpoint-GUID: hXurZSY-LTtLFGBIMXryjX0HL9r-73rU
X-Authority-Analysis: v=2.4 cv=ObqVzxTY c=1 sm=1 tr=0 ts=6927ef2f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=tLbfr0ugGcRM8kMgEBkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI3MDA0OCBTYWx0ZWRfX/4xpKNrfZy/2
 NVrbOn/ALckkQRPvAvQaB0JAyUurP5OVX2wvjYWPIT4P9ebrA9HuhnS+5e+8gYJ41pnQnJlbWQP
 jnNCNi3N20J5iB6FT3PBfejqONt5WEl/ofERro0Hmv07CxiRRvdET8jWO394xLSRt258iItiDQN
 ETbvFZZCZU//iVh/o5irmV/+ek0GvxH84v6N/ac809xUXTiw3gH/ZaHALAmzg5fHgQ5rtySHh1P
 H8VR5HG5Iv8oBp/SbjRGDu1KLAOQL4KX2VaRj4QQlGT5euEsWcdBfY1g5t3LRewUtN32m/KkOoP
 nSq4UhytoDEZjWe9ws/NK8Gs07UtCGvNFz3rxbZW5HEQbbGGGT8CWB1L4dVGLtPkylc3H5Qb1B9
 J3Je4/iPX65UOZtzG1qCABTFiM36cw==
X-Proofpoint-ORIG-GUID: hXurZSY-LTtLFGBIMXryjX0HL9r-73rU
X-Stat-Signature: nbubsganjexciqdccjd8xgmky9qwm5de
X-Rspam-User: 
X-Rspamd-Queue-Id: 1021C40003
X-Rspamd-Server: rspam09
X-HE-Tag: 1764224827-40824
X-HE-Meta: U2FsdGVkX1+CgguAX7ppj+UGfLQfF2UBoydzUTS272xUykDh5xjc+XW9HsajnvKMTy11qCMAb2HgcMYj8fUhvaJFnDlaKrSqvAD8l1tcV5zNf3pNcPL64udaADTeumRAVxAgoRzrIb7PMFoQfxFTwlYIcn7qbNR5qI6aGK7oSc2u5foMYMt9Qk6eN+KOC6vq1hH0FaIdq39+vqRN++/8IH6rYcq1GEFSnw+qLvAEpHMSeFRPQCtBJbhC8rQs6SX3mlLh28LC1SKezZD2U97K+ZWxDD/3Ntbi1rdaluhUaQJ61bADj2sHV4ONJCoP0KhqxAbgt0oKqKnxVyLhWHig04OK50ePc0vH4MnmQUXeP/66DD+H7E2fzT1E4dXE3+WZxy4NcWrO0TelQRqTSEaFYCtaJINFuBdICfxGE3t6VqDZ+z9it33QPQvYj+QpVHCDDFtYZlyf2q4T/3iwiBIhzbc7BEYQfD5g7zA3b4jjxCTDAg5/+2EKBbf2ko/+DFxm8SKQd5qt5hN7WGsTJTdw3iLTlYNNUP5amGp3fw9cOPP/3KHfSscU1YhrJiSZrFfWN4EVE8T16TCMkGXKn94pHiKQ0+BD7m10C/KUtLzKuSk3yO19cksqyXVknDYIiFHVTnt5MCvIrzFANMJrFt/0LxSv3TdxKwAhyflbcto8tRQitiMB5yZD1fV/MZpvzFLHGiqfE1lUve5bQ1NhKH8WiYrm90ac/QnBavlql2PRdmvHWeqzEZMQMuHtD2lelAGdpksPkOPPT65IMZbPpvtbPzY+07tg9JYWWcX8CCWuVyQvtxAOEInXq8TJMSN858wuoWH1IDkxX1sIhI7vtv9ujSJDUW/0awsRjlrrO/w18M1w0owCnrPxt8pQTTYDPOofh7J5rnoYz/xmPJwka4i9yWIfI6wsZW0zrZVgqH3ItWDz9wiHGv4vBDc4KRa8FVG4YkMfMcgh2R78b0XHy0Z
 rWXJ5Ux8
 xwelHpOo6oyhQMg17vIi+jX265qiA9CR6lrflNGm/6HEEmF/Zll05yQBOHbtBjuAVEnq6bBpzWbC2o4UuJdwR6uE24IvbjpjczzSsu+nHPk82S2qpJAUSFZ2g6VhMVujhzS/BA2PW5PiPDngQL/IhVePFGKCL0DEOcjw4GS1fpqxYHqYdplYvQFdOSfw1gPJoSiXWfe9twGNDQ9+3DiFjR5VTFK1pnTEPTrb49tiToXN0qJ4wuC6a1EF+LfmLhXxdOJvZ/hO7xBMUTaWqK49JrAnrDJbv/n3JZzocoN1/N8UkzG/bmrmmwbsyDFM9iiC0hrPp0OccHjp3vrHmobdC4zusNPSYo18DXIdb6ff8TB80HZyXl6LGIFp5KQoIE+BjPIMorThoT4Y2FL03qclwkXqr7NYxm+0+ycTNTtlO9+GgHyyDsT4RWToT02gEzmYG+dxzMtJxrvU4UfIcrcjXg0Q1aPqVzqsGZ5ZHP+MqmX6Hy/7LwLc5qEjHpDqrrsKNXhVb2PdcYstTzmf6dzI8A3D6/mZLGSUuQzXa5u33p51Sp6LQYPuTyE0GzsbHCneHnnxAc9sClhjx6Xp06wVEYt85rrAWFfcR0O5F72DV2UsHW9mgnoK+uIAoEhi7pksycS/DaHQYKDKO0F8zY/3DmBknTkZOzvieyCvu8gyeDFW7lHwQqtvWbHiLcQiUBhtGc3Shmp2TMM/vK54iN5zz4oNw0icmjMg4jiOtuteuWwroKTyUTE8oiMapQmojSdA9fwf1BlPVh0Gdw3zpWhkuGWYgrw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Feel free to send what you have below and you can add:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

On Wed, Nov 26, 2025 at 10:09:36PM +0000, Matthew Wilcox wrote:
> On Wed, Nov 26, 2025 at 08:33:47PM +0000, Lorenzo Stoakes wrote:
> > On Wed, Nov 26, 2025 at 07:44:17PM +0000, Matthew Wilcox wrote:
> > > On Wed, Nov 26, 2025 at 06:55:52PM +0000, Lorenzo Stoakes wrote:
> > > > > It's only "impossible" currently due to some fairly esoteric reasoning.
> > > > > As far as _this_ function is concerned, it's entirely possible.
> > > > > I don't want to leave this trap for the next person who calls
> > > > > __vma_enter_locked(TASK_KILLABLE).
> > > >
> > > > Calls __vma_enter_locked(TASK_KILLABLE) _when detaching_, otherwise
> > > > refcount will always be >0.
> > > >
> > > > So we're only looking at us changing vma_mark_detached() to use
> > > > TASK_KILLABLE.
> > > >
> > > > As this is such a subtle corner case I still think it warrants a
> > > > warning. Or at least a VM_WARN_ON_ONCE(1).
> > > >
> > > > A killable detacher is, as Vlasta points out, kind of an unwise thing to do
> > > > anyway right?
> > >
> > > I missed where that was said?
> >
> > "Yeah I guess it's for the best to keep vma_mark_detached() use the
> > TASK_UNINTERRUPTIBLE variant, maybe document why. Aborting the detaching
> > would be counter productive."
> >
> > https://lore.kernel.org/all/058f5858-f508-40f8-adfe-e5de78621d64@suse.cz/
>
> I'm not entirely clear on why aborting a detach is always a bad idea,
> but that's part of the MM I don't really understand.

Ack insert moany waffle about this impl. being confusing for _everybody_ here :)

>
> > - A fatal signal arose (assuming nobody ever goes and changes
> >   rcuwait_wait_event() to add more errors - very likely, not entirely certain
> >   though, so perhaps 'an error that meant we couldn't wait'.)
>
> It actually doesn't matter why we got an error.  We got an error.
> But also the last reader went away.  So we're now in a state where we
> would not have needed to sleep had we got here half a nanosecond later
> than we did.

Right, sure.

>
> > Since you're concerned about the urgency, let me suggest a compromise:
> >
> > 	/*
> > 	 * We tried waiting on readers, but failed, likely due to a fatal
> >          * signal arising. Unlock the VMA and check whether the VMA is
> > 	 * detached.
> > 	 */
>
> I think the 'if (err)' is enough to tell the reader that we failed!

Yup, but not the unlocking... I can address that later in the series I'm
inevitably going to end up sending to improve this file :)

>
> > 	if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
> > 		/*
> > 		 * If the VMA is now detached which means we lost a race.
> > 		 * Let the caller know the VMA is detached.
> > 		 */
> > 		err = 0;
> > 	}
> >
> > That gives a _lot_ more information, keeps it relatively top-level, doesn't
> > make undue assumptions etc.
>
> Here's what I now have:
>
>         if (err) {
>                 if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {
>                         /*
>                          * The wait failed, but the last reader went away
>                          * as well.  Tell the caller the VMA is detached.
>                          */
>                         WARN_ON_ONCE(!detaching);
>                         err = 0;
>                 }

OK this is fine, respin or ask Andrew to fix-patch and have a tag :)

>
> > > Are you satisfied with the WARN_ON(!detaching)?
> > >
> >
> > It'd be super weird to reach that code when not detaching so sure, think it
> > should be VM_WARN_ON() though since the code would be horribly broken if
> > that was not the case already no?
>
> The other places in this file are WARN_ON_ONCE rather than VM_WARN*, so
> keep it consistent.
>

Fine, sure.

Cheers, Lorenzo

