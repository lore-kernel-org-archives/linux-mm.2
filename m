Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F75BC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 18:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB076B00DF; Tue,  4 Aug 2026 14:16:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8BB76B00E0; Tue,  4 Aug 2026 14:16:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B796B00E3; Tue,  4 Aug 2026 14:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C39F6B00DF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:16:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A1FD1C0183
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:16:57 +0000 (UTC)
X-FDA: 85064393274.23.A3C60D0
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012036.outbound.protection.outlook.com [52.101.43.36])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3874E1A000E
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 18:16:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VBfV1x+g;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785867414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kj7DMHIDrNT/06c7dzPGllQor6AFlNLSVU9wkDWp7Rc=;
	b=QS7bdvzqkC2EbQgksHR/q2/wE9t9D0RYOU9MaThWIyLjBhZsGXOgo8lVKApuszTGIOE58Z
	M5tipy6SeBnWIWSBnTBYKsa0v23fZM2xD/K8Ym2gZf8CsewdvBfxMUp46GS6ptjT/BGSXE
	UrqaFpkcab/ndTgdwN6TwXWp3/LPwtg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785867414;
	b=Hm9CpnPzWp3oFnVTJ8rK/2EeoFzhXS3eYjuqHVFvYTBVWSKF6zQilp9ItjRp3El/U6Zt3t
	TIp9itTIf0qc1fQl79Ki1VPelS8nliRe+6jL0ajT/BG5z8iWzrUqF3ejRT7/GC36fqz/Ct
	S0g2lovVY2KzgK0TxbCIm1Rz3qHK100=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=VBfV1x+g;
	spf=pass (imf19.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.36 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q0JHbCq6eH/ynEKngRwLycV+GBdbPxLc5bDRr9at9Sr3CLM8pXOPxQU8KO7UIHx3EuSsgX9KKLIhvq/jCbDYfxmzD6hACnR7XDkcYcVnEPt0PXFriPKlzH02GqnycVN2N+zHf3rPnFDSPr0egNWAkCPQagfA1odG2JNzizQea2a3sEi5CmBfsCZJB7Nny91y/vwlfpuNDTfL7NOZvTJCGv4OeiMuCzhh94VFVdgnklJ6TF9JSqFtfGSwn6nfGbo1s0TXQbNtyLoe5vTkjrrBgweQ+zmUhFtEzzKyp5OiyEm8vZQRjSHDk1yDreizSBISv+nBvc0LZPSLTjSr/z//fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kj7DMHIDrNT/06c7dzPGllQor6AFlNLSVU9wkDWp7Rc=;
 b=kI5DPOQgOMEHPkWAxagdSoexKbb6Zv4mO1byhSx6T6yTOj+sLIbFoLU+P9rQKUhP184vDRy2CaqjfPaMbG3RcfEt/LAU/eWCm7AlrYtvE28aLNKNteB9PtYQ2VkYYABXrm0ROOo0SCesMI/qi9cmGaGGBt2AHazpTlUYetwq/JKb2rkM+ZMLIxcxai3YtOFrST2VaKJeQ3e+gIceCHIUlELsGjVgRfYUGX9+IKe08gUiPlJikBTaT+3q7NGTWkZGbhxehp3wRrsQWNTh20B+JeNAQyj89e9RSGidcdxrVAj+jWm8cswZcm0TA51rPGSoig61cqSoROtn8Iy6cQU5fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kj7DMHIDrNT/06c7dzPGllQor6AFlNLSVU9wkDWp7Rc=;
 b=VBfV1x+g/IP+obnOYa9fcQIpTZxy0Rb3ZDkD5JskHtIy28LTlHZdLh3v4hrkjg0SmI7TSorXVeAstZ9xeLJT8960Bh9m45xl2D6n5fvyCUj3o5BM5IqNIZYoYqqhtQeUNAC57wUeSU8uWZSKCuyhi9cfWqe4V3023lQ+RDw8NDL4deZ4nDn7kn8t3vJE8zOxXO8PzqvX2UTlLHe/WAn2CMA7a/Mz1sBF1Y4QNRPK/KGdVGE2DYc2bCYvQYSL8YQbKhySWJ3Ohu1nAqUN2tjCLpfbLSBSVlNiBD3R0HfaReOq3MjfTYD8eWjR54dTd6ZeViGF9P6avM30AyvnetPVNQ==
Received: from LV8PR12MB9620.namprd12.prod.outlook.com (2603:10b6:408:2a1::19)
 by DS0PR12MB7728.namprd12.prod.outlook.com (2603:10b6:8:13a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Tue, 4 Aug
 2026 18:16:47 +0000
Received: from LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528]) by LV8PR12MB9620.namprd12.prod.outlook.com
 ([fe80::299d:f5e0:3550:1528%4]) with mapi id 15.21.0292.015; Tue, 4 Aug 2026
 18:16:47 +0000
Date: Tue, 4 Aug 2026 15:16:46 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org,
	tj@kernel.org, urezki@gmail.com, catalin.marinas@arm.com,
	will@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com,
	gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <20260804181646.GI27883@nvidia.com>
References: <20260715180455.515692-1-yang@os.amperecomputing.com>
 <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com>
 <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com>
 <amCPBrdltFSE_fEf@J2N7QTR9R3>
 <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
 <4887267b-dc26-4c33-96ca-8dff054a0d1f@kernel.org>
 <anHuLy52o5S9Nlwp@lucifer>
 <anH1CgpwS3PHeDRq@lucifer>
 <20260804144054.GE27883@nvidia.com>
 <anIqO2AiVlLTEPOd@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anIqO2AiVlLTEPOd@casper.infradead.org>
X-ClientProxiedBy: BN9PR03CA0247.namprd03.prod.outlook.com
 (2603:10b6:408:ff::12) To LV8PR12MB9620.namprd12.prod.outlook.com
 (2603:10b6:408:2a1::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV8PR12MB9620:EE_|DS0PR12MB7728:EE_
X-MS-Office365-Filtering-Correlation-Id: 16b958ff-d6c3-488a-df90-08def2548c0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|1800799024|7416014|376014|366016|4143699003|56012099006|11063799006|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	PmUwXPInLuiywzlN8DTmMobq8kEd9uMhkOWUCYmEZv4zl+RUbts+tvv3++suMIffLdQ8zFe5p8jonauCAiUsQ+DEVinmT4BoAN9dqaEutc38UZOP5R5AYANaI+1pDFbfvsSgG18Vo5SzcJHF71tZMmAhuCIGC2D8375qFduStPKXQ10JPiiKbrXfaxhkpNX2NwDP2I9+CPxEUh+n/awcZ47RZLphoDKWEGYZk9x+v4oWS5RzHm+J644LxkaZEb6zN5UF6MK0DH+0pgFMBI17FokZpzi45pjxu4RoEKZy1KkCoQoZe2xgrjqSK4y12eH54THj1LbPYuM6YtSVgyqaLekm9duMnnoLIJuuCSlfyRnkZWbxvpfSnQcf+aWq30Dk41vzrpQ3kEIn5wLVt9V2BtQPcqmwXV2McmJMRNuEtKxb4Y2VFIXIBUm07DRm0MvdvBOcP/h0WpBlM2m65oQec7wIDjEy/8cZb4ODdE8i5RwdiI0t3EihahFYR/2stPTk+B7onUv78kbbSabpjeLEOGM9KtSafMTXIqQgY5y83thg63aXPEiN9ZlJQiu+Lgo11Ku8RwaEIc7fwG1aMfrf9hBv0v10InU7TICE83InD8iHH8C6kn2fwb23RUrL5DeEeZFbF9ADOZHTFcnVrmzhmGPZySa450mIdZ6MitbxH+s=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV8PR12MB9620.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(1800799024)(7416014)(376014)(366016)(4143699003)(56012099006)(11063799006)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T8twyPhAWeiWeFgIOznTevcWg6lfXvMJE9RZCOlZ3wHpihYJyWPkWT/4q83q?=
 =?us-ascii?Q?2vH2cGeE7dHjNNJzX1qPO5ptDit0X6OgH8TvuxkLKtnIyYutk8VBm/OR0+p0?=
 =?us-ascii?Q?YGcK8Q/NmvVtDBvwH2XT/4Pd+dHJtAirNb+kIUGctQvPaBATK/J9tHODWa2Z?=
 =?us-ascii?Q?ZoBTdJDbb2a0ivDGDLl5pYrE0y2tSNcexcAgfSNQiCUC7zxd82VQERR0ZuOg?=
 =?us-ascii?Q?WPczW6Mge5FV8uVGf+KSG2Iwh/8syY4NLUk+CvGbaCc4E4msTqWt79bjOvVu?=
 =?us-ascii?Q?X9C6C0QZ0esm7FbQQPvX3K5ZvbQif1BDlT5jasnuObD4di89xFU3JjA/8S/F?=
 =?us-ascii?Q?BOp7HZepYFJevRfRxfMYC7wDAR1Y0pAfXM0DergNNwLR74v+ABAugpebVcId?=
 =?us-ascii?Q?RB4Ig9i0LlW590oXMUQtBiTrYkRhQFiu/s/toV/9htib6lgcNtzxyJMtpL8E?=
 =?us-ascii?Q?OQMa3jbwJ21vL+UXBZPj7N2MVItHO1t3CLOhHT+D6Eot6KQF9quYyN/qAKCy?=
 =?us-ascii?Q?ljo4Mkd3afIGqSiR6bKe5cKYjVemBCJp6DHmOMh30jQ/Z/znDUNS0YGJoIwz?=
 =?us-ascii?Q?6MojbrVaI0cw46Sj5XZenWOXU+goyxrOBUhiSTGELyz6o351PGdOcnQrUbmy?=
 =?us-ascii?Q?4hI+BtoOXSOQxApI3qI83+S+LN0MzwhJgiK+G4xBv5+KqihnBSP6MvUPhfJc?=
 =?us-ascii?Q?EaAqPI3CYW9UxO/inu9Psr26y1vBptZYtQOKOcs/Iyb7ogtePb/mcAg5Wb4/?=
 =?us-ascii?Q?YUj5NGeh0Ouq/lKmipqeNLA1/qu+9njCdEcjsND3SbsL5nC5Ucv9gK+PbUhO?=
 =?us-ascii?Q?5dWjpQibzD/WWxw4+7RbHSOJljZRfAWxvaoOlqOKC/nMV8quTsbHy/OumQOd?=
 =?us-ascii?Q?6/5wNfzvL1gGjPlUPswgzbcVSj7+/A6iXKJir5uSTZD6nNOs8mQ3qIWbwuZg?=
 =?us-ascii?Q?LtMeDbO3XbDC4M4edp+u2LiPtfO5SH3APLSR3qeWVCzSBJu2sSTVvjBXk+K9?=
 =?us-ascii?Q?xrB+zm+oLHVNjD+6SzcyH1iTxFXRGNU2yemd0GrwlYhZtMYB9Vi33XHqe1Ke?=
 =?us-ascii?Q?+lANoj5FcvJA/SVZRSmL1SvhnvH053QWx+Kye73tTBZFzEQNl2gwLHsGeGi9?=
 =?us-ascii?Q?N/GOJWWfnNPEzprTmtmUVtHHFgfDnftwPRYaQ2OCSFmHb1/iD7+27Jmd58FA?=
 =?us-ascii?Q?Y8ZpB0BiD//0RSJp8kQ/8FZaPWj3kdXX8miTmMACvH/xM3uS1HShORWfKNHK?=
 =?us-ascii?Q?FeJcJx6mk8Pg3vYFYLPkaFm9gm2NQ3/gxfwQcYzXWnuapjk9xJSVnRxvxARv?=
 =?us-ascii?Q?dpHEhCq1MoAShcpyYhuVOd7sDow/DJWz0HWAYKFHj+ju6xOMpUGhDVfYGnk2?=
 =?us-ascii?Q?mX4MiiiZhhcg9OxwfLVO9f6TagHIQBrmeYIOT9c0CVIbZv2bsIrowFFPog/r?=
 =?us-ascii?Q?Su/xuCQuaqZoCGwk2+6AqnzPh8glSbKQ72w1HI/U9r3miFSzJICYjUUY88V4?=
 =?us-ascii?Q?xxIXVD1Mefp8TJKszsfbrd40KPTthIx7OibmJd1JqWj6ZQyYruiqpKPrJOOB?=
 =?us-ascii?Q?9p6HZnMxiCELF8qk71Ne5wcUAa+2vS72qwTqBGR2vEgYMNdFdQ3VroaoLzB3?=
 =?us-ascii?Q?pMf0i+a4TR2B7GNYZfnlKstLT/Dv3KBwCYlreFkiH1k1eWPx5SF4WEuktLG2?=
 =?us-ascii?Q?Lz0cyu9ERhszI1lfjA/kkK3VFpiw2I/lZdC4E1ToLQsolUHaJODgsSeUToyP?=
 =?us-ascii?Q?SPW9cGoSBA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16b958ff-d6c3-488a-df90-08def2548c0a
X-MS-Exchange-CrossTenant-AuthSource: LV8PR12MB9620.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 18:16:47.5577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4EaM129/elEpDcJkD60NwtrnW0tvRPYviP5M9dga3SSEVhhwWzzJaTzyp1+/1+pX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7728
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3874E1A000E
X-Stat-Signature: 4tisbu464cqakns16784pkwyjp4ceuo9
X-Rspam-User: 
X-HE-Tag: 1785867414-875273
X-HE-Meta: U2FsdGVkX1/HtKm9YqkagdV6fnTfpPZx1Mnz3QlvQaiWYCcnZjpsTcAxEc9nZ6KBO13O1q4G88GPA7cRGa5PrKlWfIAYohavHuhZGlLu0iJVvW0WSeV9K06dc3N4Ij038CCv0/se5FIdD6YgcuHyBddZgsHby4wK2IX82mha68LgZNhA8FYsAM/DKQg0I1DAarHxqBZ+UgOXPwPhjPkniBjzn355cplPB9de0/e4TuGZaDoXTWKIQ+hLzDY1HvA+8Ji3HeidmjCFXsXXo9KraI+iRezaTYahkxMiy3gxX/KzkE5uUR4Wzkpl4tPZzDh2/jJ9ItkZ2WzUvXEMYPIJOkl5wYR1OnsGdQvSxZbLD5YBnOSE45L9Zlwyj5Vp7Kk8ksCYJ4KPk9V45zKSSjIYU6k57irGjOIY6ZNJkvFCydvRYR/U51mgjrfssIgJnJ1/ExnBrEvLU/6Y6czm7JW8EnEA/4DaaWosRJfuMmUOHqaHYwZdWsTuY/XaTRSg1nsEN2SHKXhpXU+m8Al36/gwPxaSnV5hz0QvXVUOiZUEaJ1Phfvzkz/xvORTP4bHk4Y/oDvKPFtkIKNfRgRYfzGwW5yGG0xOLcl73F+BI9PkklJLNHtJF1VeCx4F7B1NoPgzKhOpZmTfcNr/uYrDL7fSo3FsANauz2AFSgoWbywNF43CDmYnP2kIwSXzSDBo+8TZI2b1cV3K+NW7dxsY3JJHrgs/VXqnlQJe9S/LX3iF1iHdbepLrqHMyvJ5ARznWNw2P7en3cPRIn88haoEuNZHBkZdHgDLWPkAq/KMmnyhcLWTlNQyZ5pqnnggx5URIAmyWJfz8TuqoEfJE8U4KKFvJbHAFEoMNU8u0EJWpid+bk+zaSLAjqWv3+nXqys1MPRFC4SWyEk9WZ3ZTf588rPMIZfKiFUKeDlR4CSFf2vOcm0pRRrWYkLhi0AIAQfGQ+Z6NNECpe8ntA3NHu0f5+X
 iLnNSYDG
 FHlIzD1Dq8y8pMOu1nj3AVes90gZ5fBJCbWMJeeTapbb/SByXJXPeL59IBlxltJlFM628V0hJnoJZ/wc93YCvZPYtfcCl4jBcKAZ2rFcsvAFGPCrxJsCd3yUxZ5ets2RW5IE7R7cDE4ki07tn1k9Mq/188nBZXD574lSeHGUeihjeBGKjw0jcsX81uMf0A4h1FArqleEFzFG99rxRERRKAXNKIlcxIQwY1C41gmwIRZAp5MyRR8PmtFQWcVoa0ZIDiqfmaGdBLA+SZZudFpMbKBFdvx1P2f4eRXYFqqtOA8meY/hgfWDZoickDwHMQ1pZotfcoR5ye1OIkRzhiNa7HGcEKfJiRUbPjDB/VR7Yn9bJqGgYxGvqY5Dps0SDHwWY2IHPsU2mXWQCcWmjNdZtVLAu2K3FR6J4juSZFV1E1Et9ZkoTf68RBcx9a+CVSE+fXIxsqO85HjSmjXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 07:06:51PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 04, 2026 at 11:40:54AM -0300, Jason Gunthorpe wrote:
> > That said there is still a merit for things like replicating .text, and
> > I think we will also have some multi-socket systems that would benefit
> > from this too..
> 
> Are you referring to kernel text replication or userspace text
> replication?  If the latter, I don't think we need per-CPU page tables
> to do it.

In a sense both, if you build a system with poor cross-socket
performance then there can be big wins to replicate .text.

I've thought kernel needs to do it with text replication, there are
too many absolute relocations to make two .text VAs work?

Userspace can meaningfully work on a non-replicated basis where single
processes are localized to sockets. I think people do things like this
already, but AFAIK it is not ergonomic to setup.

Jason

