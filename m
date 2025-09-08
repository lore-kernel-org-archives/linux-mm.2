Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31AF4CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 09:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EC178E0016; Mon,  8 Sep 2025 05:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89C168E0001; Mon,  8 Sep 2025 05:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7160D8E0016; Mon,  8 Sep 2025 05:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 570348E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 05:31:40 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 239F811B1DF
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:31:40 +0000 (UTC)
X-FDA: 83865565560.12.3A530E2
Received: from AS8PR04CU009.outbound.protection.outlook.com (mail-westeuropeazon11011036.outbound.protection.outlook.com [52.101.70.36])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8CA958000A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 09:31:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=i2y6ickj;
	dkim=pass header.d=arm.com header.s=selector1 header.b=i2y6ickj;
	spf=pass (imf02.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.70.36 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1757323896; a=rsa-sha256;
	cv=pass;
	b=oOX4bHsrojGc8FaqqZUfFgDQNzgQgTUmp5vA8/FCiuVwJlfRtEMCKPgg5IJFJH8RZ6dxAd
	sBjYasUyROS8M3tESB7vxiapn3c7zWP0+Hm1+hKZ4LTlUbt3srvsMJqJm7hRZCwTbaqhf3
	KL8qEH3sa10PVQrJZmmCMx3SGHJ50gY=
ARC-Authentication-Results: i=3;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=i2y6ickj;
	dkim=pass header.d=arm.com header.s=selector1 header.b=i2y6ickj;
	spf=pass (imf02.hostedemail.com: domain of YeoReum.Yun@arm.com designates 52.101.70.36 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2")
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757323896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ca+HaUjALnyCJht2ic4lnms/jl5V6Hbxrc4FeHuxbs=;
	b=dMBEqn689WhadkCXQst0X6Wx7ipTEGTiVbAatknVkLuvly8nUAThhlo68uSI32vGQuOZK1
	DOKdk2rp6x080mPEqNZuY5h+doKPdKNrG9n1DYX7WhlBT87iymwd0yUloF1tF53HavHnMf
	ObpZgu30igEVYmn9FW6aweXjI9jpwKY=
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=UvOwiHbBnOmW354gh9MfuzVl9m+dVZNamvM/jJBSe9xwP17V4DLACbCQQMl/G9AHUBMD4oOAqxApOciJNIyxmpRj790aMCbxAHS7NtvgXm5Hgc6hXf7TSH+a+C8AYpq4ToYul8bXHby53dytu0Ke83ZxAIAzHxOdoIa5wOajJTnEEEThgqU90kq7tumL+kdK5Y4kAxPS6HRvTVJYXLlymVUodqG62f74iMLbuO1FVxudeRZLmnJZieP9Vu8Ru4vNpZdFcA+9ur/0yC1L8FG/bAfXOPu2NIwz0p2wStFC0FmmSHBzbTpmulX1C4RLrERMFJylYemT70wFu6PiIQpo8Q==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ca+HaUjALnyCJht2ic4lnms/jl5V6Hbxrc4FeHuxbs=;
 b=Bz48cn1uFO6w4D//XSm27KqDG1xYH0uv4qRhmH9jYyCtlQHmPfHMsEumWory/Xeia5JuWRA+hCKCfJai32JI3pOCMJ7Yl98O/rCxBeMHnmXBcO+6WjS4krbmcOXdRnAskTwdJITXIAAih7O286fWSjYxjR0pBr0ATDiN7CPs/JSXaJCb+vUc6OxRJ3+5/VK9HHieKtEILcwUCEgL8LOUhpxjfP7mqEmesB3V5nKrqS8pnSKYmYCUkeb13JJ2OEpp0V0qYP3c4m7WJ/+zuZ9Oc/UEZz8YnNAQDPO8VTLttD5Ck04ymkm8zghzjj5nxlM/dsaDywc8ex/qOVWTFulzeQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=kvack.org smtp.mailfrom=arm.com; dmarc=pass
 (p=none sp=none pct=100) action=none header.from=arm.com; dkim=pass
 (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ca+HaUjALnyCJht2ic4lnms/jl5V6Hbxrc4FeHuxbs=;
 b=i2y6ickjg+BBy46UgPnTXqLouzMa5P0nREgbgRVdgxF3m6V0l9nWs2HisbdG2Qx497sMUm1qL6MIGuczu9g1hWaIGroCs9VsGcWmjPhPQh3SiW/knxTlMOnzcWrajXrGJFdstQoviKZnjrgXOyASLacyaxp5U0mnhYP9MIj7Yr8=
Received: from AS4P189CA0038.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::10)
 by GVXPR08MB11319.eurprd08.prod.outlook.com (2603:10a6:150:2c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 09:31:30 +0000
Received: from AM2PEPF0001C70A.eurprd05.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::6b) by AS4P189CA0038.outlook.office365.com
 (2603:10a6:20b:5dd::10) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9094.22 via Frontend Transport; Mon,
 8 Sep 2025 09:31:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C70A.mail.protection.outlook.com (10.167.16.198) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.9115.13
 via Frontend Transport; Mon, 8 Sep 2025 09:31:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GzcY3S/NwHk8YU5gaMzhhD43VmzVbu70esFVbh4NJIWCf6AAeQODSri1HTzaDoXIGK4E6BVCjH6jKTFquvzLkqDSgnBWBM7pUbsbEw0ZK7VVhl4Etv2/xBKkZjpyQwmt/ZFcqFH3942Yo4DTkt36cCLWuw1UMLxN+sDJPW3lPJbdtCMu/WT9ty3mzLl2RcNVZ4qx0x1JC2N/kpI6e3p/VV6qVctkSCuyQPV8wbUO3NOeErgGAOwvjU/N1cIsiRwHzWfDl+Dpi4Z+N7O5B9vGg5YxzZZWWNw5AS5umljUdCXr2ytoKyY67GVUv0CunOxgOCIwSsRYZZMZo1Yrscsr7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9ca+HaUjALnyCJht2ic4lnms/jl5V6Hbxrc4FeHuxbs=;
 b=w3/A5pq11Dv4TfL+I1HTtYpi6gfV4BAbolYwPzZ82nQqrJ46Hci4tKNw+9sDqjvI1A8RCIFl5s4rfQnxKQ1hVc60+6UCvqLoVYk0Oc6Qkpp1qQLBBVlwTCDjMP2c85hQ/FE+rkloofVCSaonDUVCLZT9iWQ8sKJKTS7DK9QZ0TF1ekk748/rvbz17kXESVtFklxtTbYZc1l8gupbQl0qwCF9266ClFBZIzl2uow2AZsDyiAgsypmJHJ6tt0Ji5uKJ6VX/SfBCdEG+/cWNSjcEZebTyYp+PXCIK22WB79ZtIsFfToSahGcygIOn32pP7DvinmVzqqbBLcVo9vOM/1hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9ca+HaUjALnyCJht2ic4lnms/jl5V6Hbxrc4FeHuxbs=;
 b=i2y6ickjg+BBy46UgPnTXqLouzMa5P0nREgbgRVdgxF3m6V0l9nWs2HisbdG2Qx497sMUm1qL6MIGuczu9g1hWaIGroCs9VsGcWmjPhPQh3SiW/knxTlMOnzcWrajXrGJFdstQoviKZnjrgXOyASLacyaxp5U0mnhYP9MIj7Yr8=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DB5PR08MB10163.eurprd08.prod.outlook.com
 (2603:10a6:10:4a2::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.19; Mon, 8 Sep
 2025 09:30:46 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.9094.018; Mon, 8 Sep 2025
 09:30:46 +0000
Date: Mon, 8 Sep 2025 10:30:42 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v2 7/7] mm: update lazy_mmu documentation
Message-ID: <aL6iQh9HSzSNweta@e129823.arm.com>
References: <20250908073931.4159362-1-kevin.brodsky@arm.com>
 <20250908073931.4159362-8-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250908073931.4159362-8-kevin.brodsky@arm.com>
X-ClientProxiedBy: LO0P123CA0001.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::10) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DB5PR08MB10163:EE_|AM2PEPF0001C70A:EE_|GVXPR08MB11319:EE_
X-MS-Office365-Filtering-Correlation-Id: 7fb38d49-76cb-44c8-0ea8-08ddeeba7cf2
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?mc/DZxczjZ5Tw2y2bRBKf0jJHfY+1cMA183gNizjtcemH+ZB6krdHoCtKs9R?=
 =?us-ascii?Q?rEJZs/LC5FySiZNsw3OEze6JaYBGi0ZCo5Y1i+wUqAxrxi/xLg0+b2PW0Gan?=
 =?us-ascii?Q?Hu/+9PDxEcA77rBe/Yh7D/Az17HYKu40TcOSRu1P+US5HSyCfQoOvi5ELPRq?=
 =?us-ascii?Q?5eZeUGNgNMkn/ZFX0b/UZiwiOJxyeBoHNR6n2mjRMx2Flr5aZ7V2fn6EwsXg?=
 =?us-ascii?Q?dvOpVtROyIAbWwS5fLKl1j0EOvJEjrK4auYck66gcxAPyT5Y6tPl2g66UJsj?=
 =?us-ascii?Q?Z2fJYGN1+lbSrhHwQTY6EVbjuaZxGTzNc5n0nUsAPp13uW/w/JgGL3mI7ifw?=
 =?us-ascii?Q?7OMQ2ua7VlYXlN2MyEqT0h96Lju0H5zfEX3qa/RAkU11sek6lCiemA0VuNPl?=
 =?us-ascii?Q?NuDR6Yln525bAPXGEeMySiMCrnAzqOy3MQtW+cLPZl1uUlFXm79ls38/EVxf?=
 =?us-ascii?Q?+8985IkQv4MwD0DNH/810b63nObzJTpG8mCsfoM7NoI3Y2xEHjXJ4UWCyFmw?=
 =?us-ascii?Q?n3Lf5n0u97GnsoY1ZWsQRT3A3kwfX2UiQ/JxjDsL1/HV/1GCd2D5fTwJyxje?=
 =?us-ascii?Q?r+UdHO34piBXqaDHtUrD9WJ9X2Te1LpCZWRrkLmirVg7TF8SD1C586L2faBE?=
 =?us-ascii?Q?s8MYWY+q/+wAtCm5r/LR1G2subFbmR6YBERC3NkG1AjC4EtkqHCrWbIpDFqK?=
 =?us-ascii?Q?Yp0kv4+CbLK1qrcmI3TrXsoYf60aI1eWziINMLyV7aaGzJr9dH01VqqvJgHd?=
 =?us-ascii?Q?GI2fBNpbd3z2ox8ki8ZB56AJrbs480Lve32YosjzL4HGtswerOjeenSABtOf?=
 =?us-ascii?Q?WBl6unX6bePwxK4Nyf2zDhwq9ofO8k/pOPab68TPd4FgEO/lA6+8pOxcVcC6?=
 =?us-ascii?Q?nH78oMLuowaLLtIXM+IoPLqRl9peIcogbwjmYUxCHmBLrDJrrT6+8dFwEMs7?=
 =?us-ascii?Q?xOIvat6w/nNGERI4HOUjfhc6im/VEYmpMAJhKkh/ltgnbQqGCdZouyTFOQgW?=
 =?us-ascii?Q?s3J0cA4fqHVrIS4SJwPevCqg+iuYqMUSSxHA1qQrePuEPuAeodE9uX10tZnR?=
 =?us-ascii?Q?9WvNrlYf0fiIoON6+9hJWzDaa8EDhDE4ZdPuLXWD2vQIzaFklWrjyTrYLNtu?=
 =?us-ascii?Q?TT78A/By49svFpkhHxJZO/7jMSkcKgxCRaA/luU/uYr9a801PnD0E257pvHS?=
 =?us-ascii?Q?DJ4KK6Qd+NcRDVeM2oEMdCKngB4DYGjsVxdAuxAcPcve6w2BsoAs6WQ3Tky0?=
 =?us-ascii?Q?2Bn/tBJteswJYy5tOUPIdsP4xbVCbB8AXSlXf8NxSvSIWcC+D34DnphRjFUR?=
 =?us-ascii?Q?cg0P1/M//myZDtL3vDQhP85m5gCoFPifWkrCBHVxIWGN4HvWiGzEZFG0bu2L?=
 =?us-ascii?Q?Q6Ik/xyCfc/tylrShjryeRisEg3lMfj0ExlOKia3+jqeDHXqWlB++yhQWpcM?=
 =?us-ascii?Q?6WSLbvrg5cM=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB5PR08MB10163
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	6d139c24-8f97-4caf-4e9c-08ddeeba63f9
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|14060799003|82310400026|35042699022|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?neAHsbAqzGVc+6f1QfzwFSYXmgTFhynXySmqSOUOfWAEVwIUmXC0nNW3/pph?=
 =?us-ascii?Q?g2QffH8PQ6rsZauFr72jEs7DSijJGKF86Ppxg4pZZPFNI7WKH9+X+rnoZ9KX?=
 =?us-ascii?Q?yjsN08UDNuDMGSIF66rUFI5Ik89737JO/y88Ou6FFToRL3XoBFIt0yWtoLx8?=
 =?us-ascii?Q?8Zp4SVzaYhBismrLCQEP1ckRaZ1xWnKejd4z/r6CmV+KnWU7yRvLcvxHOhaF?=
 =?us-ascii?Q?mD1265XStw5+KXZ3FcAFWqeLY6OdOnHw9XK8jL+kI3zGWWZFHUW13WSfBtPc?=
 =?us-ascii?Q?HZyhkxLeNtMFstzOatYrXjuSb7mYOjcMDpVKOo4TkaBjc61jv+85C3oGlyny?=
 =?us-ascii?Q?uLQSxFSUeWxQY2Z6CoA5FhvACIGH6XYh9QPLQ7tLm4xTIoEpFRRn7TxE8J8S?=
 =?us-ascii?Q?Zga0w5tdla8rXWTuPwLj/+oL68N9sSohs1AVSgBpGl6shyIYKeYMczcWWjpf?=
 =?us-ascii?Q?gFdb1oXHkzy349XLyb7/P4Zl34QpR8GE94DII5E498Kk2xgKuUlBIYa9/DUN?=
 =?us-ascii?Q?F/gBuwiOiZQyfOQqvVWrh4SZ4HeXVFwT97ZKIubI6H5NKVJ0nzbeadpTftf2?=
 =?us-ascii?Q?JLAMwPbSCR01iwbw6w6ubmBqv6AHMNkaXGqjOUqo1p7W/gb4AOUrBEyxxwxM?=
 =?us-ascii?Q?D+31RaFA+HeXm+wB9qFMpL9XEgGSseA6d7sBz4sfRKA/43JygfXGLZ65IGNB?=
 =?us-ascii?Q?qj84vNOIX1ZxAj0y1go4tX7tR47/Uj5zXfDMePdSt6wUEkoWmiLFHh2zwpPx?=
 =?us-ascii?Q?S8iHAHC9cLk8BMu4BzsnP7orbYQJcI7RQhMYS9ZwSjU5oyuyraFX2ps3aIKd?=
 =?us-ascii?Q?gYwCkZdpzUizRXxbGnR/q2hCGiASYVhSNrdLK5/ohfM9LWEsi/MscoD6VeZ7?=
 =?us-ascii?Q?v+2zYRPhEz/ZFfw8VwPr9Gyy0rJUef09se3IFnjfKDAFPbhDQRUoOjv6SAC5?=
 =?us-ascii?Q?5QvL0mdbE61uTsEy2UzP4NpF7DLMRQWZFguYU3PBphjIwhHPECfM9efzm53s?=
 =?us-ascii?Q?v+2SC5xbeq8nj6umOGZ2CcFn/qQEjPiOkk6mF3vC6eXT9rHE36HrQsgCF/gI?=
 =?us-ascii?Q?SNNQCcq9DUOO8ZDf19nBL4U6h3pCDWXOyt+vu43Op1tI1LBkx2+qsB4CoHa0?=
 =?us-ascii?Q?Wbww+E6aPS3ljau0xTW00ez6I1nsUoHud1Z27o1MZHUGcq/stZzS8liDgX6t?=
 =?us-ascii?Q?1nA9Xyj86K0/lkmsGLhYGKHpgvs3qCHgZms//M2XcYbrsWiZJEp4abVyCi3z?=
 =?us-ascii?Q?u+snfaYEaOGuU/cBW2aJc/NXRkP0Sb1QXbZnLCaX3yXTP9Gv7POCgyFyVyqj?=
 =?us-ascii?Q?9N2I7vpHRQ6i1JNK+KioENRtKhudHbDARCZvVmdi47TKZobIuENzAj37wWpy?=
 =?us-ascii?Q?FDx7Y/ZLmBNGCUlZx/C04X6Pu1xxFiy4m6PMAoP2tYkmOwFmEAAg4lIBV3M3?=
 =?us-ascii?Q?H5Z7XSt8amoqOPD3uLm+p3dCjjJbP2SKk5HVoDzomHKO1WsZ7ybBrotmNVUJ?=
 =?us-ascii?Q?KBv3UuvOgymoWvm+Uy0OdW1Hr77qDqT07sbO?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(14060799003)(82310400026)(35042699022)(376014)(7416014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 09:31:28.3034
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fb38d49-76cb-44c8-0ea8-08ddeeba7cf2
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C70A.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB11319
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8CA958000A
X-Stat-Signature: k935zddenp1gyn119bhc8fsarr3se18j
X-Rspam-User: 
X-HE-Tag: 1757323896-782247
X-HE-Meta: U2FsdGVkX180Rd1o8Jc+nlKtpMiioGCmYFP+t2UJh4clE3cgclNq5pDOOpKu+3p+XJFWR5F0Fl4c4UkAvWdwA2RuVcWIbcknI3ql62PFVevc1JH4sKKF13GS9BVLrasx1jWu/GLwdF9CQKoln7S1oDWvHtvX56DSAQPW6pQM3TU8rhCwyQNAdPmxVnjs3ISb84z6oKRb6wqvZclvjU1PioW2PufJpjEQqPhWQ2piB99Lo6UiOG7c156GqqcJy0y/RegGDZ0wImwcxXI7u2SVDaEUkzgAwSoxuqDXfvZoSeYVh7YRBWN6h1AXfwi0xMPWWxglg4odke1GVbjXb+F3h96CtWNmhoAXiRb8vvbn6mqVSeDfqB7HDb2JfdZpfpYsonj7xglm/nDBjjbA1HjFfPgqxK5+w5AmPcMZSNL6xAWNxnMYktrntzp4HaO6TT8752TjfXi8QoHISjJfQiVGCKwyxDTwhbpS+VCg20WyqOY4n2/Ex0mU5svSw4YV3HBhatDiz4blNFIjNtt9OPshJpj0juZRnKxY+zNyvSfyJ+iSr9iQHusqx4wqXLGJ1azh9CLcSY165kEuGebdvNwFOt2rqTD8tuF1ySkUiOrYcHh2pxKMPyT5WllNy5fP2RhC/xx8ria0DXhs0JQSkErXHm1ILEsm9NcvHwVad6E/URPrxikbN2PukPV4IIeA4mxQX7hGWM9NS47bLonk0M0odUVq9KTuBN0u5BPSBiZXU4KytEQSmfWu2DheOqRI5UT3dcMxEj5nBgZFp9qsEBHtmsvYJ+EOTC7UEoGng7J3A1MGG2nH1Tmovtg8lQ3jsTdoETdgcrhOEabugokjT4FsScm73/U68HIUgodsbCqQ7W0kWL6pK//pZ26EOQeFeMQacJW5fZzatW4DL3G23hCwziis3QRX0NJtic8FVQcUhZKePPnaEW4LS6Jbze0X5oGy9nPo9zhhlDE17XE8XjK
 8o7N0Vw3
 zrWc0JgzIpqLM+k8kP2zGbjBIXzKxuryfy4CvZtMRNZ5WgZ5f1x73GrahTCmftqxv1PRhjYyOyqX+2/SjhisuV+DROhg4ahZcDwzwNtHh8pm6nwSuxlII9K6GON0/JZhfPSek04J6ldZ+Yw74T2pnuFGJ1fISxj7DfalJO5TAJo03PhQLSnQgin/JLnVYNg6T/ZJEbfaINQXs4EEZj/5V9ERRHJmpppeplXWsl56townpQD/TEjjqh/WG1UEUcR8qMTRK3UltErS9GHfEZE71KZ3M0UnLQvOj/KPIg2O9QRUZhTXM0Idmy/Q17Vp/t5KI9IaRAsjd1+wd/tYoTlq8QWTfcEi+u0IsXBXNRJePSN2sTPRiW4YEN7fxvGo1S23GP/swCkYL5fk28e8iE1F8nZNW5K40Jge6BFHA+bDPMf80+4ubS7FBPi72MRODtdk97RUeV9DTzLNJVxyDKI/ea5C5W15eET3yy7jshWoVG5fXLpgVQjRrr3Srv+G1DoMJkKlzaahvWeXCJ3DGN/8duqR1r2puptwlAdgp8+8CK3pnTyD05PcgWvzb9CFyDQ4h1QQAoyztG9km61hMhBexkCQ3S/u6iT/fvnpsovk2cubMPXaBE/wv4oOS9h2PwKwAaRINtZX9VVLFaNq4ngdpcIUqBixDppLjo3ULiQh0iP11pVVkvV/wucmew6v7ATivHKtDthGYSuzoTNxz3iMeVYG2Azw6T/P7Xj6Oil+fLy0nDJY+iQOFtV/8hqpCaFW34lWMZZ8Nd6wKicpIx3HjSqweZqAqRg5Ng2Zv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>

On Mon, Sep 08, 2025 at 08:39:31AM +0100, Kevin Brodsky wrote:
> We now support nested lazy_mmu sections on all architectures
> implementing the API. Update the API comment accordingly.
>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---
>  include/linux/pgtable.h | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index df0eb898b3fc..85cd1fdb914f 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -228,8 +228,18 @@ static inline int pmd_dirty(pmd_t pmd)
>   * of the lazy mode. So the implementation must assume preemption may be enabled
>   * and cpu migration is possible; it must take steps to be robust against this.
>   * (In practice, for user PTE updates, the appropriate page table lock(s) are
> - * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
> - * and the mode cannot be used in interrupt context.
> + * held, but for kernel PTE updates, no lock is held). The mode cannot be used
> + * in interrupt context.
> + *
> + * Calls may be nested: an arch_{enter,leave}_lazy_mmu_mode() pair may be called
> + * while the lazy MMU mode has already been enabled. An implementation should
> + * handle this using the state returned by enter() and taken by the matching
> + * leave() call; the LAZY_MMU_{DEFAULT,NESTED} flags can be used to indicate
> + * whether this enter/leave pair is nested inside another or not. (It is up to
> + * the implementation to track whether the lazy MMU mode is enabled at any point
> + * in time.) The expectation is that leave() will flush any batched state
> + * unconditionally, but only leave the lazy MMU mode if the passed state is not
> + * LAZY_MMU_NESTED.
>   */
>  #ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>  typedef int lazy_mmu_state_t;
> --
> 2.47.0
>
>

--
Sincerely,
Yeoreum Yun

