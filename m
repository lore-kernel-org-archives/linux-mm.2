Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B0BD41179
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23F046B0088; Thu, 15 Jan 2026 07:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FF236B0089; Thu, 15 Jan 2026 07:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB236B008A; Thu, 15 Jan 2026 07:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE2D56B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:18:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9756813A7BB
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:18:49 +0000 (UTC)
X-FDA: 84334101978.13.71140F0
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4AF90140006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:18:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cpBmpsYI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UklLze31;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768479526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6UQjMYcSSfYtxpik1rGhFAg/leAU2gp5+vP7gbFbj3Y=;
	b=FWtyq2IycE5AeMpRFziIp1SQzcPOyM0JduUds0PykTzvJlTOnMOty4R/8V24M3Hfxy+I1c
	fzbfOeEVf5pB5O5GrtZrFG+mvuIGf07xwXfURzvPuZFKBKvK5CVqexujlBENSoPQo2dOO9
	VO4Gn3xwmZYwH4ucXimsxqF0JBdmj7k=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=cpBmpsYI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=UklLze31;
	spf=pass (imf26.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768479526; a=rsa-sha256;
	cv=pass;
	b=kbj0NeGZD6HXWBDnGISqC7v2TrT1ilgzLUBPOeRgn9B+i4K8bHaBuEgNnF7MonGVGl6uwx
	N65GGCdZUMOZxZrt/DQ2YSOLizqkQy/QafkvNr+FqIaxzgpdL5pz1qdjdYW7e4JZrerFE5
	6YNZ/SS3So42kUg24HpYtLT1Ux0zDw0=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FBqUgJ2753003;
	Thu, 15 Jan 2026 12:18:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6UQjMYcSSfYtxpik1r
	GhFAg/leAU2gp5+vP7gbFbj3Y=; b=cpBmpsYIODf7szikBswxNc5KVpJ9nBLdbS
	f4KmojMjt6GahVONlgYUtjfVEBjnVXBWSiHWzP4eDsJ8s25TM6rS4xrziP4DXsvf
	99ibZsSIVthJOS0C8tFwjF8ycHCIVDxaUXvu0FMZBRnilNdXcllu/Ieh4q6GHiNy
	I2YnqnzkGe9v63Ree3swJh+/1wYyz92FFSQYnpZp0Goe/OHB4sXWCDBjKrO06Osv
	OVbg7vXdxR7DlxYBs1qCjY0rrlpJwimVAM7fYLFavUxw2luXdy+6Sm6WRrlutz2R
	ojDhMRduY3pVYO+aPK/u8MSLhvQiyWfqadewCK2Lkd0+ds+w3xpg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkpwgqkmh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:18:27 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBQKRr008355;
	Thu, 15 Jan 2026 12:18:26 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011055.outbound.protection.outlook.com [40.93.194.55])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7b165a-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:18:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tohOKyDM+aSkX+tbw06FN0WAhJV17HhK1xQlnz4EN6novVLlOIiGtN2LW2ucECYW7SmejqPTtFQdIWBcG0+EGctmEQOgQC0N8zBfzQ2X+kU+h3bFeHAWBY4OXe5jb65pdMBqXnAwLX1WfhE8qpGERfBE76Jl5eXq9KJuLTe35E5GWUsEHGW9tF2UA0nSln0fBdJAniUDK5Kanvz2fKDLpRvzcTM98bAvIGZZI9ffDfN8x2whqMu8Jzbd538Na9bi/C+25OhiLlDB2OQ6z5S5zctvf4Eyalp7u7BYBfQGZNHo1JeE2ixbXomhzrw3Uw9kN/uyM1y5acXFvp3bariZvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UQjMYcSSfYtxpik1rGhFAg/leAU2gp5+vP7gbFbj3Y=;
 b=IXWgjOJPCU2AwDYsDebXvMdScdxJ3HWaS5fmuqwcnQgYIH1prE/mkQRUWNDon4HovcN/20gGjr+3C9MLa3snRZdg+W3ez5SsETuJTriV8/QBLv6lwYypd02dQ7GGtmU80LtIUpmGWSaNSYxCubpJCR7S7iMGH+BnMoZoCAAU/7SSuUEfilwjTEhG/K3Rl/iOVVmWFC4BsSgHpVp7d8wXkqXMQR8Tl6mUky0jfTFFcjE1WRqK7j8DrJCH106HerxRhwQ4pFlwTBaDYb146gslm/XsUe7jkABsU5KeJ2ruC3KVs6rhi009ubgDYuWhDYv78TtqJy24ngFabSdL1Qoo+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UQjMYcSSfYtxpik1rGhFAg/leAU2gp5+vP7gbFbj3Y=;
 b=UklLze31YLt46xnuKXIZOlVqidU+gSmKyguF0Nu54+ZP27D5SiZ7pn2mQNtD3TbPptK5I6xluqtk8iqtyDXpJZUlic4+YtXcCeQZqCSXXtIghpTHsP0E81rtszz3/NX9zJ5/LgQVKHrQeJf66N0IpFLeCncpBD6jvIoKMxZOfGc=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by DS4PPF509E676A9.namprd10.prod.outlook.com (2603:10b6:f:fc00::d1d) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Thu, 15 Jan
 2026 12:18:00 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Thu, 15 Jan 2026
 12:18:00 +0000
Date: Thu, 15 Jan 2026 12:18:02 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org,
        Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
        linux-doc@vger.kernel.org, virtualization@lists.linux.dev,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
        Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v2 04/23] mm/balloon_compaction: centralize basic page
 migration handling
Message-ID: <821926db-2cbd-41a6-bc40-bdc80a0e2499@lucifer.local>
References: <20260115092015.3928975-1-david@kernel.org>
 <20260115092015.3928975-5-david@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115092015.3928975-5-david@kernel.org>
X-ClientProxiedBy: LO4P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ae::22) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|DS4PPF509E676A9:EE_
X-MS-Office365-Filtering-Correlation-Id: e0cd608a-b7ee-43a8-2aa8-08de54301f75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VjDg2pJzrfqpbcnWIxEyFETAzXKYL2p6RHkgWJ16YSddfPlTsI2V7bWrrw7J?=
 =?us-ascii?Q?3KBUWpI0nJz0UJnQwVkny6xY5TfHkELy9LdvzIxVM1Kj2VbfL3uZYgJB1erl?=
 =?us-ascii?Q?VrjYlEpUPLqZATOBbZTk75uoRyTHRQmvkFcqbkAqCbm2W/kzenXNev2Fxyh3?=
 =?us-ascii?Q?cpFC8cYwqVEOA+Hl0GcWawGT3HvsjJUc8FlT3821uQOft6nHf4i8VrUGMTBa?=
 =?us-ascii?Q?N/q+kuziyU7NiPvuFCdIj4x5cr7fyTOcEXs7y2qXknb1VQnUk094/9Q1JP8C?=
 =?us-ascii?Q?lioM++QYAMn2xS+iJKw9XpPSSmy5pdcb4FRn9/Fvgv4T2RPXlpIf+khL4ZvS?=
 =?us-ascii?Q?ZjzJGChicZcnm5xfxpIyApEvcCU9wqEd1bBNmG6449JJpGekmdd1k8riKHSC?=
 =?us-ascii?Q?no+7zrgh5barHHr8lyzk2JHb5oOkAEWcE0ZyX70G+VkK5zhsS89TMqB4O1yC?=
 =?us-ascii?Q?WSzj8JiGNBCmgeRZOZqX9qsP+Rr7bd47ht5SQS1WRJUquHx1HIRRWEfL9xcL?=
 =?us-ascii?Q?d+sp3A9GZwx81UpyNc8DAihMcLfShJ0JV0aPRnAZ3e6mv8AC7gKWITjjL1iU?=
 =?us-ascii?Q?9pGafcDkKhv9MZmY4o6+2jPUCpv6NEp9mDBT7nPSOJKjKaVVlmu5vLQbYZh5?=
 =?us-ascii?Q?dzRdP5nEUlJySo4uAdSZk1myuqHYUxoCakBNFsYNs5LBCbdmg3wVO486gWrp?=
 =?us-ascii?Q?HxS0yzFSOZoInmp5de/LIUGyBtkpITHRwS84SsyuXn6gygofproDEOrC+eWQ?=
 =?us-ascii?Q?TmcHRpaPqyfu7GKWPp7M6O51vVrKdUly/pqWq5LO40Gyg/5EEFWSElH8cqze?=
 =?us-ascii?Q?PFrNnb4+FHJjX8S3VBgMGK6y8sa+4KYOeCCsiqOdFx8gOS2Lc8r3fFbEQT+R?=
 =?us-ascii?Q?8aNE179/t2dafynkv7Bqdj28vOCagQs4yqiDvvyrDcOEZg/l2tNoGhWKySMn?=
 =?us-ascii?Q?oTuYob3yX8F73Dil/qnXdNbUb5a2qtnyuldBA76r6CeHXDYgobQR7YnOGtEM?=
 =?us-ascii?Q?PEyzoCzVKQ24jbQYGCMrTW/KkV77oOtaIG7wJYEOJHrbh1aWXh+TUvbO7+qr?=
 =?us-ascii?Q?0D5a6H3A/0FGvf5s9wBcChxN/kmr3sgi/lemt25fCCP4289sOSlQVVjeZTbF?=
 =?us-ascii?Q?N0Pa4PMHLGQA1tyb3G0wTZ4QdhVeC65BtEffOqKRfDRgjVPS3V8z9Yl0V2ne?=
 =?us-ascii?Q?DBV3bOyNJFh944wkXDO+dZMWfPm050qL9TjfiQ5Flh8JelWF/8upgZqRoXYg?=
 =?us-ascii?Q?/ZVWI8Zkk72MMkiroYD3KoE7MeO63/9XZDArWnSfCCiqD1dwlWoA12WND1c8?=
 =?us-ascii?Q?pVcXFYDv8O4ZhmLaXauzyM6o7xVWZnPZ+p7owe039kYfA2RlZzFvgqi94hme?=
 =?us-ascii?Q?YT7wq0HRWWdqtX2TOCuODQK2tHtQuUSPiE+NKux7sWO3/A/KNNizOWLNt7ni?=
 =?us-ascii?Q?SVcGhpL6pF7VlYXCv258FDElcbOoUgUCaXs1FK8hcDw0myJu9WZX5YW/J1SF?=
 =?us-ascii?Q?xevCQEzHUY2GptFnYALqtYtrnyoUBfkqFeIUhCILKHnMoPVR8utnNDl6NBdD?=
 =?us-ascii?Q?E4wHCWwG1YGSM9STerc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?KuqN3U67k3hWYxnpKjg3BC3QCbBZ2eFzZzk9PZf4qyK6E05N6fp/zyopoHB8?=
 =?us-ascii?Q?Bq+svUq/bQ/QmKAcpsNAiGTFuKKafQwFt4GcjC7EdEgfP68W3R5pngpXSoKq?=
 =?us-ascii?Q?cUNjxkAGyVnAjpVNrXXCOWtgXafbmvIsqbwCJJ8XHsdu1gwkpsjE7XIWPxr9?=
 =?us-ascii?Q?uOJL0F6dP/myj2yEd2yh26ozUE3Z/eSD31DjE0CUBhv8xmcmdEby43ZKhf5H?=
 =?us-ascii?Q?vGaoljoPAvN2iIfviwbcn58kY/Ej3AJnOeAVgFcy0mbAImogkSC6Ipw3v7Ty?=
 =?us-ascii?Q?odlu5duCmE336ui/Vq96XHDuE2b7xUU+4CLV56zwH9zdY8UFI23baT8k6Bj2?=
 =?us-ascii?Q?fpX87Z0nXN52zJu2a4Yo9JxGfwkJSMlRfTpyw06Pq1tEQJa4zs9tj42rg5Xe?=
 =?us-ascii?Q?yDAbOxlZXmM5BPdt9iMOiSOQ6txj31eEHTpMOAXhvlYsRAx53idklY7qzO8r?=
 =?us-ascii?Q?OrO9sgVAGu6MJFvdxz3NvYEXsRpor+4WrbgZpwEjYZtNTxXk9R1jDpqqOz9b?=
 =?us-ascii?Q?KjEZC3GlFVkJGATiirudOsh2MmKQ+0AHzMdCkBwcUN8FyxsxfFy+B+Wist32?=
 =?us-ascii?Q?/dLpPNW3zXUPFOkDKmW+RoMQdlRKO/qFCJKsNl/xm5XWZ65xgmRnMG+KLsCQ?=
 =?us-ascii?Q?i9n3ynWJhmBoFbPGqdEC6/OITsCnyP3dYjxkFIOb/0Z7qvPI8tE9pRMSRkSZ?=
 =?us-ascii?Q?ybJrxcNL7WOK2WTcu61/TAfC8IOCfuW/fheyBUVCXMHDKmoSxCgACZCmvp3k?=
 =?us-ascii?Q?mD0eh1IuuAU8vx4R9h0yg4weZ8c2gYKHg7ZDxFoSVf18d09XX939F6CIhho3?=
 =?us-ascii?Q?0gMi+LvxKfZQjKPUk5lwaj0ZjoP9kWcQ0a1J9wcbU2QGwcnlhwtU9A8AcuDM?=
 =?us-ascii?Q?tN/xIoqvQG9RHt/w7TT7OzIASv6uHgPovRUZtFFJrKZflspXpiQJwubKz0G4?=
 =?us-ascii?Q?HAHr75WMd0Z6ab9I2MQlyG0MP04WxMrxcBjZofp6fJVWVXFOU6RTBWW4ySYW?=
 =?us-ascii?Q?mRZDQKDkYaZiOohzdO3HMSy7sK35ZCkyTkAbTc8cZYRnUJXNa7OqY8nfEwdx?=
 =?us-ascii?Q?tKkQAVGi99KGWJdL4mRMU1+gMdsIPebS+pBxsYrugCQ4vDjlQZPojAJEH5O6?=
 =?us-ascii?Q?SX3507R4grejwJUuiThCJnIDhLKRvWJVqKyprD8OMEpGIDUNuPMynTvGknWW?=
 =?us-ascii?Q?CeBGqCIFFMbFLR9B0bne3XOhMCBrqa1hkAJ92HGYzUI89vdxYLpyVOqN4Mj0?=
 =?us-ascii?Q?fR2mCdf8HerahZE093oy/93czELF0KY+1UHoVRYsORqbc1gr6sRHLoKCCmW8?=
 =?us-ascii?Q?Z3W/ghEkVkagG8hKUz3mmUH+8D7R6zDteudXVt9G2O4slMPtdALV/gGGVqjO?=
 =?us-ascii?Q?CPYJW1H6HGHJlxCtqBZnA/yYuglfoRZ7LXDfs38NJSTIZ4s38HwVY5FWCrlB?=
 =?us-ascii?Q?whA+ohJSYQmeXSF5H9CfY6KBWJJAMTi+R6f1COdPG72LOKw3bl8FkiotLR/H?=
 =?us-ascii?Q?TK+mMDO2hDSe23fNZ+6sdxQWII1r5vlQuuua36x1wNJ7dXmS7LbuMjT0N997?=
 =?us-ascii?Q?1FrCpPpHs6bfydbCnzCBhN0c9O2Xm+LB20r5dccz0GnfhWO428e9/w+xd6Og?=
 =?us-ascii?Q?ePCk9i9qbi7z6DlbOcwAbkeXly7OY/jQylhCX+Ps3wPJY/uY8FNmWbSUblED?=
 =?us-ascii?Q?yu94N+vDeIun93ioB/kh5bPi1wqqUUyFBUryabl9NxLNzKXEk5EXkRQvhVW0?=
 =?us-ascii?Q?Ta4bsR+22Gnn6186shqfI2HqNuXlsjs=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	W9p/P16MMsfOBQLDSf8YVQMohtKAkS3/cIznimsxxzuFg2aeBZL6GXJK1GzpInn1zdE4RgEoddQfeAOli0McH3FdjAetwYvQSyVKcZXfHq1uv8TALppEfa8vxpp3ScDEcP2aNZSoGlVEGeS9xBx+ApcBSEJ7yb1U8ApkJNMnzb4pMrm6zszvpOK8fvYjoY/58DAnloru05O/2/fjKenyDUSVAOGg4NcpQPIqOsPG7ETyz/a6mfbA4L59dlSGjSKvaQ9Rn+TOKzuE7+mkPzE4DUNnc/m0fsPI2TooT5l7eq1cshc8WreHfogaHzP8W3U7icekU/2+YDgf6m86tOT/Wu6VkoUw2CZyOwjHIVphergyCA2AisK7jPuCizWfC9VZJx5oqbwzG/h4nmxBcQu22wQxVrpDmRFK2LGe+znbWp3DEr4VG24ScE7jdIeINw1sOC2JXk1H05ph/gh38tYpC2VvlHjylc/ceT9W7NY3yIqLgY9pjyo7X75GxwMWkK40oX25RAionPv8osKK6gj/mWI4PmxIKnXJWtT4Cj0CLTja7Ef0+4jFGmncjL6H3VthVgpnpjBECBiXFnLaEL+jgryjnB+duU+UoqgxhLBQ6Cg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0cd608a-b7ee-43a8-2aa8-08de54301f75
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2026 12:18:00.2859
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ty4K5ZpGUYFkQ3nM8FCOyiGZs88dSY71OVMj59HJs6ZWXFX30V2UTk2qFTUzmjdYfCczJGTHQivhKwXfFvQ4RlQci562mA69AtPT5Fgd4Uk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF509E676A9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601150091
X-Proofpoint-GUID: Y2-nap6QGaLk4Geco0BdY7MojNIItv-4
X-Proofpoint-ORIG-GUID: Y2-nap6QGaLk4Geco0BdY7MojNIItv-4
X-Authority-Analysis: v=2.4 cv=ZtLg6t7G c=1 sm=1 tr=0 ts=6968db13 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VDBE-ABgvQpKTPO6jUEA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA5MCBTYWx0ZWRfX6zZiO6orGJy0
 o23iyUJgNCsJI2osEEq+wbwngu+8zSlo/0uI66bvcHBN9YlDpTnxeYHsHPlnULSw+TQp6u6LIsB
 tmdC245A90+ltw2c4IQ9MB3/g/QwWi8GAmiWlZKa1ry9Hhn29saNsoLAXNGB1J5m+kkVCrkINVs
 xUDDx/WkCK50Q+taZpyYx6pss5lDuCzlgHOv3N+AZ21428ea3USo/dfErF7vs81N6FXB5iLx62H
 NP5mjTsi/Z9Raontq7hY6aEWs1eZeP5dU9Zn3hZrBFcMeANJnvfaieYfeWX0QFUW/yLmVLVc7F7
 JR5n+DltVK9dH07x0ejMdKnJIqtuBEjsUOOF6PQ/a/C3DkibywdnX7Zb4aBQ/oXD5Wq13iDhwhp
 uiPzXTNNOS51FE/de+4pSPlG69Z43BU/mNNNpo0eX/dYz6u1EaJecyiDrgrsBKWZQJer6Iqfovz
 LRubYh/3k48LVTSUlYQ==
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4AF90140006
X-Stat-Signature: 5skuo5pt7ud9eewwqrar3y5npp9tx73p
X-HE-Tag: 1768479526-743380
X-HE-Meta: U2FsdGVkX19av9LRZ9En2E+tj75kJK1uFrjcR41YW1mBEOz52/61IJ8/ZLZ6fiuEBpPFOCH5YGss9e8DtE+up0TpwazkaQA6akCeJFPXx+kgAba8D8aqJgfpgWOly5U8nZVBHnutzhJBVIcKyptwX1e28QSBAaghhTBk23OQQTgRNpZwGhbaqIToXU1lPbV1UF9h3/zEcG/OlLRnV0A5BToCUDjEhezhd1lEClIwPFMcE9r607CHiVQlBkVHy3gFY0Fvj0cV/fLSza1LZexNg49ZhJehEaAQxLKa4R1qV6I0XUXmnEcjzqtc3vBNa9/tXWuvHUaX2860hvsOEM+25Dz+SMRSJO4nyOKS90a1DlepoZZw8o3CekxSlJPSsr6eaxurV5JBInUvEbUPvvQ5DZ4HRRtxJFtwt6X+5NEmQt1mJGL1XCxJjlVI+k62UZ8pR/YqIwrpUw/9bVeINkNwr12L9GzyhFo0ogc8Sys3REgQS8tp+zHliTvQEVg3XZCuBiLkVkPKZut8TFCLsYfFFWrEl5Ir8WJ8ue1mhgGrCnQ0mLppWJVcoJ/vGTFSMIxHUp7qu1UtW1qgKq5SKSyXWssZ+At7qycmmzaamPxbzitO9zWUMNJWajzkjj63f89mk4Z3q4gWkYduXgs2jl4Hnn3JXz8wMIwFxCGX53J3EzL/VsxoNFNTQWFGED43lRNxNOvttfY1hLlTzr5aKjrl3+WEsQqlU/npGA/6EALQhMesil8ifbIwtu0s6GR86WPbJrtE0QBu8mbtCGoH+SzbLFh99fdGuEzv7KLkVPM6vGPRh9M1Q5pBvnnHsJ7N+P5OpOXNFh3wtoVUSc9IqdJ/KO3UwfzIBV9yifv4/94t/1XtENXk1siEM/IKoPfZaKt5y9NjMfg7yebzw+6py0noICNbn9OKimx1+ECN/ZWZEBV+HSrfqCeQfce6PppNskvYL0tj3H8qOx6F3/jE8ia
 EHghKpla
 BSBilsrtsgTauXE+jqxmxAI06cfvLX9jCyHhk4uIHdggNyXUzFLTbSFUB+IHK7ffu50vOV9/cJyNfP02+kcnAIMAt/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 10:19:54AM +0100, David Hildenbrand (Red Hat) wrote:
> Let's update the balloon page references, the balloon page list, the
> BALLOON_MIGRATE counter and the isolated-pages counter in
> balloon_page_migrate(), after letting the balloon->migratepage()
> callback deal with the actual inflation+deflation.
>
> Note that we now perform the balloon list modifications outside of any
> implementation-specific locks: which is fine, there is nothing special
> about these page actions that the lock would be protecting.
>
> The old page is already no longer in the list (isolated) and the new page
> is not yet in the list.
>
> Let's use -ENOENT to communicate the special "inflation of new page
> failed after already deflating the old page" to balloon_page_migrate() so
> it can handle it accordingly.
>
> While at it, rename balloon->b_dev_info to make it match the other
> functions. Also, drop the comment above balloon_page_migrate(), which
> seems unnecessary.
>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>  arch/powerpc/platforms/pseries/cmm.c | 16 ---------
>  drivers/misc/vmw_balloon.c           | 49 +++++-----------------------
>  drivers/virtio/virtio_balloon.c      | 12 -------
>  mm/balloon_compaction.c              | 37 ++++++++++++++++++---
>  4 files changed, 41 insertions(+), 73 deletions(-)
>
> diff --git a/arch/powerpc/platforms/pseries/cmm.c b/arch/powerpc/platforms/pseries/cmm.c
> index 9a6efbc80d2ad..15f873f733a41 100644
> --- a/arch/powerpc/platforms/pseries/cmm.c
> +++ b/arch/powerpc/platforms/pseries/cmm.c
> @@ -501,8 +501,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  			   struct page *newpage, struct page *page,
>  			   enum migrate_mode mode)
>  {
> -	unsigned long flags;
> -
>  	/*
>  	 * loan/"inflate" the newpage first.
>  	 *
> @@ -517,9 +515,6 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  		return -EBUSY;
>  	}
>
> -	/* balloon page list reference */
> -	get_page(newpage);
> -
>  	/*
>  	 * When we migrate a page to a different zone, we have to fixup the
>  	 * count of both involved zones as we adjusted the managed page count
> @@ -530,22 +525,11 @@ static int cmm_migratepage(struct balloon_dev_info *b_dev_info,
>  		adjust_managed_page_count(newpage, -1);
>  	}
>
> -	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> -	balloon_page_insert(b_dev_info, newpage);
> -	__count_vm_event(BALLOON_MIGRATE);
> -	b_dev_info->isolated_pages--;
> -	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> -
>  	/*
>  	 * activate/"deflate" the old page. We ignore any errors just like the
>  	 * other callers.
>  	 */
>  	plpar_page_set_active(page);
> -
> -	balloon_page_finalize(page);
> -	/* balloon page list reference */
> -	put_page(page);
> -
>  	return 0;
>  }
>  #else /* CONFIG_BALLOON_COMPACTION */
> diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
> index 07e60a4b846aa..52b8c0f1eead7 100644
> --- a/drivers/misc/vmw_balloon.c
> +++ b/drivers/misc/vmw_balloon.c
> @@ -1724,18 +1724,17 @@ static inline void vmballoon_debugfs_exit(struct vmballoon *b)
>   * @page: a ballooned page that should be migrated.
>   * @mode: migration mode, ignored.
>   *
> - * This function is really open-coded, but that is according to the interface
> - * that balloon_compaction provides.
> - *
>   * Return: zero on success, -EAGAIN when migration cannot be performed
> - *	   momentarily, and -EBUSY if migration failed and should be retried
> - *	   with that specific page.
> + *	   momentarily, -EBUSY if migration failed and should be retried
> + *	   with that specific page, and -ENOENT when deflating @page
> + *	   succeeded but inflating @newpage failed, effectively deflating
> + *	   the balloon.
>   */
>  static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
>  				 struct page *newpage, struct page *page,
>  				 enum migrate_mode mode)
>  {
> -	unsigned long status, flags;
> +	unsigned long status;
>  	struct vmballoon *b;
>  	int ret = 0;
>
> @@ -1773,14 +1772,6 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
>  		goto out_unlock;
>  	}
>
> -	/*
> -	 * The page is isolated, so it is safe to delete it without holding
> -	 * @pages_lock . We keep holding @comm_lock since we will need it in a
> -	 * second.
> -	 */
> -	balloon_page_finalize(page);
> -	put_page(page);
> -
>  	/* Inflate */
>  	vmballoon_add_page(b, 0, newpage);
>  	status = vmballoon_lock_op(b, 1, VMW_BALLOON_4K_PAGE,
> @@ -1799,36 +1790,12 @@ static int vmballoon_migratepage(struct balloon_dev_info *b_dev_info,
>  		 * change.
>  		 */
>  		atomic64_dec(&b->size);
> -	} else {
>  		/*
> -		 * Success. Take a reference for the page, and we will add it to
> -		 * the list after acquiring the lock.
> +		 * Tell the core that we're deflating the old page and don't
> +		 * need the new page.
>  		 */
> -		get_page(newpage);
> -	}
> -
> -	/* Update the balloon list under the @pages_lock */
> -	spin_lock_irqsave(&b->b_dev_info.pages_lock, flags);
> -
> -	/*
> -	 * On inflation success, we already took a reference for the @newpage.
> -	 * If we succeed just insert it to the list and update the statistics
> -	 * under the lock.
> -	 */
> -	if (status == VMW_BALLOON_SUCCESS) {
> -		balloon_page_insert(&b->b_dev_info, newpage);
> -		__count_vm_event(BALLOON_MIGRATE);
> -	} else {
> -		__count_vm_event(BALLOON_DEFLATE);
> +		ret = -ENOENT;
>  	}
> -
> -	/*
> -	 * We deflated successfully, so regardless to the inflation success, we
> -	 * need to reduce the number of isolated_pages.
> -	 */
> -	b->b_dev_info.isolated_pages--;
> -	spin_unlock_irqrestore(&b->b_dev_info.pages_lock, flags);
> -
>  out_unlock:
>  	up_read(&b->conf_sem);
>  	return ret;
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index 74fe59f5a78c6..df2756c071dae 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -827,7 +827,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  {
>  	struct virtio_balloon *vb = container_of(vb_dev_info,
>  			struct virtio_balloon, vb_dev_info);
> -	unsigned long flags;
>
>  	/*
>  	 * In order to avoid lock contention while migrating pages concurrently
> @@ -840,8 +839,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  	if (!mutex_trylock(&vb->balloon_lock))
>  		return -EAGAIN;
>
> -	get_page(newpage); /* balloon reference */
> -
>  	/*
>  	  * When we migrate a page to a different zone and adjusted the
>  	  * managed page count when inflating, we have to fixup the count of
> @@ -854,11 +851,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  	}
>
>  	/* balloon's page migration 1st step  -- inflate "newpage" */
> -	spin_lock_irqsave(&vb_dev_info->pages_lock, flags);
> -	balloon_page_insert(vb_dev_info, newpage);
> -	vb_dev_info->isolated_pages--;
> -	__count_vm_event(BALLOON_MIGRATE);
> -	spin_unlock_irqrestore(&vb_dev_info->pages_lock, flags);
>  	vb->num_pfns = VIRTIO_BALLOON_PAGES_PER_PAGE;
>  	set_page_pfns(vb, vb->pfns, newpage);
>  	tell_host(vb, vb->inflate_vq);
> @@ -869,10 +861,6 @@ static int virtballoon_migratepage(struct balloon_dev_info *vb_dev_info,
>  	tell_host(vb, vb->deflate_vq);
>
>  	mutex_unlock(&vb->balloon_lock);
> -
> -	balloon_page_finalize(page);
> -	put_page(page); /* balloon reference */
> -
>  	return 0;
>  }
>  #endif /* CONFIG_BALLOON_COMPACTION */
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 03c5dbabb1565..5444c61bb9e76 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -232,20 +232,49 @@ static void balloon_page_putback(struct page *page)
>  	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
>  }
>
> -/* move_to_new_page() counterpart for a ballooned page */
>  static int balloon_page_migrate(struct page *newpage, struct page *page,
>  		enum migrate_mode mode)

I honestly wonder if page should be 'oldpage', or rather we should just match
args to the struct movable_operations e.g. dst, src?

>  {
> -	struct balloon_dev_info *balloon = balloon_page_device(page);
> +	struct balloon_dev_info *b_dev_info = balloon_page_device(page);
> +	unsigned long flags;
> +	int rc;
>
>  	VM_BUG_ON_PAGE(!PageLocked(page), page);
>  	VM_BUG_ON_PAGE(!PageLocked(newpage), newpage);
>
>  	/* Isolated balloon pages cannot get deflated. */

Hmm, I'm a bit confused by this comment, isn't 'page' isolated?

This comment reads like !b_dev_info implies page isolated and thus a
WARN_ON_ONCE() issue, but later you say 'Free the now-deflated page we isolated
in balloon_page_isolate().' in reference to page?

So both can't be true.

> -	if (WARN_ON_ONCE(!balloon))
> +	if (WARN_ON_ONCE(!b_dev_info))
>  		return -EAGAIN;
>
> -	return balloon->migratepage(balloon, newpage, page, mode);
> +	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
> +	switch (rc) {
> +	case 0:
> +		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +
> +		/* Insert the new page into the balloon list. */

Slightly weird to put this comment next to the pageref update then a newline
hten the actual insertion bit.

> +		get_page(newpage);
> +
> +		balloon_page_insert(b_dev_info, newpage);
> +		__count_vm_event(BALLOON_MIGRATE);
> +		break;
> +	case -ENOENT:
> +		spin_lock_irqsave(&b_dev_info->pages_lock, flags);
> +
> +		/* Old page was deflated but new page not inflated. */

Weird reference to old page and new page when old page is 'page', with dst, src
we could just say destination/source?

> +		__count_vm_event(BALLOON_DEFLATE);
> +		break;
> +	default:
> +		return rc;

Don't we need to change the isolate stats etc. if we simply fail here? Or does
the movable ops logic correctly handle this for us?

Ah I guess baloon_page_putback() would be invoked :) Fun!

> +	}

It's subjective and pedantic but I don't love this use of the switch here, it
really makes it seem like 'just another case' to do the _key_ action here of
migrating a balloon page. Also could compress things a bit, that's even more
subjective :)

Also it's kind of horrible to have the spin lock line duplicated like that,
that's more important and not clear on quick glance to see whether matching
lock/unlock.

So maybe change to something like:

	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
	if (rc < 0 && rc != -ENOENT)
		return rc;
	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
	if (rc == -ENOENT) {
		/* Old page was deflated but new page not inflated. */
		__count_vm_event(BALLOON_DEFLATE);
	} else {
		get_page(newpage);
		/* Insert the new page into the balloon list. */
		balloon_page_insert(b_dev_info, newpage);
		__count_vm_event(BALLOON_MIGRATE);
	}

Or even could be:

	rc = b_dev_info->migratepage(b_dev_info, newpage, page, mode);
	if (rc < 0 && rc != -ENOENT)
		return rc;

	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
	b_dev_info->isolated_pages--;
	if (!rc) {
		get_page(newpage);
		/* Insert the new page into the balloon list. */
		balloon_page_insert(b_dev_info, newpage);
		__count_vm_event(BALLOON_MIGRATE);
	}
	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
	/* If -ENOENT, old page was deflated but new page not inflated. */
	__count_vm_event(rc ? BALLOON_DEFLATE : BALLOON_MIGRATE);

To only lock over the operations that actually need it and to really highlight
the 'success' path?

> +
> +	b_dev_info->isolated_pages--;
> +	spin_unlock_irqrestore(&b_dev_info->pages_lock, flags);
> +
> +	/* Free the now-deflated page we isolated in balloon_page_isolate(). */
> +	balloon_page_finalize(page);
> +	put_page(page);

OK so we get on migrate, but put the source page which would have got gotten
previously I guess?

> +
> +	return 0;
>  }
>
>  const struct movable_operations balloon_mops = {
> --
> 2.52.0
>

Thanks, Lorenzo

