Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A05BD29FEC
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:32:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15DF6B0005; Wed, 14 Jan 2026 06:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6806B0088; Wed, 14 Jan 2026 06:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9D896B008C; Wed, 14 Jan 2026 06:32:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C72D86B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:32:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85C2D1A0486
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:32:26 +0000 (UTC)
X-FDA: 84330356292.06.D688D88
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf07.hostedemail.com (Postfix) with ESMTP id 245AE40003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:32:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g4pDEuJX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jT77bYsN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768390343; a=rsa-sha256;
	cv=pass;
	b=YiF2D0q504wGnGe8FUwjlj0ci7QwE1xTjmQazg5VtQWyapvR79EE9u8LUzvJYZhIlX7epu
	0fYLbOWvvxxZa6O2Ljk6/eNJjk0PIwKWf/MzwD6tB+htUKV9jK/fT2Owqwm4R32ml0t0tD
	MgsdXYhteHwNse/+ikCErgTebDDPwTA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=g4pDEuJX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jT77bYsN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf07.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZBCm1IIm/X1zCpjVZoH2R7dFtOhHakhNKijqCMsKVYo=;
	b=P/Msk+oOGLmOdwWlwaDFqDb0OR7lTbse8VWLDHHx5bnkrMP3BgbY93DJD9Okl1FQ06mpwZ
	Fep7NxDfXq7N16pQyAD+kb7ntAptqJEqfBwVvbPShDh+HCo2fP7Ug7MV2MGi5BjuocuZPe
	tsxJs0v4kOtNjQQeCmGzGpX8o74EIfE=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60E4DdHm1098168;
	Wed, 14 Jan 2026 11:32:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ZBCm1IIm/X1zCpjVZo
	H2R7dFtOhHakhNKijqCMsKVYo=; b=g4pDEuJXcfQeMweMr8UxiYx/AercQcC9Jw
	irL6ylim7VB7VDvfgnCBkDzrZLz/uIzfEKfboiumEawbdt/be/5scjUsZJ7rC8Ht
	Le9j/PDU4ue7PkvwRDpb9fZe+eeH8VAXKx6FVh8+vMbOp5qaoifIIdSnx3djKMkd
	5l+VOHYSiSJrdC7xKyZUGSm7a6Z8Z8VHY7AHT9MEB8+u6d8NKfEYQSM3U5DK9MoE
	FpDr+W9vj3ZeHR1QAXv3bSZ5WLZjKYbIvBXfp7EJdVRc8Cb8G3tv7TCOLEb6qdcs
	oJ3tGLG+fjyKCWlJdzfTjXTrFst3/23rUvnOCvFpIC3CHUcAQ/GQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkntb52wg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 11:32:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60EAMn9h001848;
	Wed, 14 Jan 2026 11:32:12 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010040.outbound.protection.outlook.com [52.101.61.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd79wtcj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 14 Jan 2026 11:32:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NtWp2tmEO+9Lekuuj85LUV6l+6jTot9yZImtmDwiXPsytmB9elF+IGDX6WoV8dan7J67HQOKevyLtUz8SflNzeTUXLGJV9rhcX/EGjVebPQWf1MAPcYNMnq3YUCLMSqUF5+QFWWezvqwVsiQswugxXjvU/kGJ3XsSjhWIAIH4qojzEGqfVh4K5tPZMIOJI9nY3AQjPq1KolU+N7k8PRqPV3sYFrvao0Bhg2SVJbPldFzDLze8OskFtKgUF2SbS2d1EBTf1zmmBcPYLme1tpLeIgQbgsYj6Oqa/lQoHREPtV7OT7Ku2I6OwBlUHGlOEcDCa31htM2YTgP92Q6nguwGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZBCm1IIm/X1zCpjVZoH2R7dFtOhHakhNKijqCMsKVYo=;
 b=Psz6FE6d1p6ZZLhJcUu/fBp6q3cVCF41WHJByCXRKxzAO7iB3XH6KQZRCnpFfw17nZpxXhbAETUHcsjNfb6px3uXsHUwdRgP/x7ON/CubvyJGAhnAimoEjcydhukpcPOXyi0GNzZKPq+oMwQwq2pl4Xlq6JEpTeKAOe5vJtYYySqLxTCpcf7/tnulbw5dkQTtZSyn3GE3VHWCYqmVXV+yN7WVUkHrZDXGFCF9116GsxzwOUDJKkOfzOK5NyuX8bU6v5oTXSCFtOY4Em+iuj3xLdDh+x5dthhVXYOH9DsMBJZMKXgrPlbgOzOe/YnbyqcpgTjqXmTiHAhGkaTOFKmlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZBCm1IIm/X1zCpjVZoH2R7dFtOhHakhNKijqCMsKVYo=;
 b=jT77bYsN1gunR9DCkTwnm5C2uBDr9AV0FDuVQQ6hznHdvEnYFYE/Lc/8jYIe7XYQ5xVi6TiOcl6dNmApLvnog63v3K5M4xHpOB8+OAWdruLPwCyDt5Wo0zUqiEkBgwnZC6OBtI1rhORyKzzW9VimeYKAY6t5cyhV21EYWtWZno0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB4782.namprd10.prod.outlook.com (2603:10b6:a03:2dc::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Wed, 14 Jan
 2026 11:32:08 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.005; Wed, 14 Jan 2026
 11:32:08 +0000
Date: Wed, 14 Jan 2026 11:32:12 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Chris Mason <clm@meta.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v4 5/9] mm: introduce copy-on-fork VMAs and make
 VM_MAYBE_GUARD one
Message-ID: <2456b1fb-3ea9-4632-8757-b8e0ea16dc29@lucifer.local>
References: <5d41b24e7bc622cda0af92b6d558d7f4c0d1bc8c.1763460113.git.lorenzo.stoakes@oracle.com>
 <20260113231257.3002271-1-clm@meta.com>
 <955cd0d6-8977-4bd1-8f16-a21063a5a95f@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <955cd0d6-8977-4bd1-8f16-a21063a5a95f@lucifer.local>
X-ClientProxiedBy: LO4P265CA0202.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:318::8) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB4782:EE_
X-MS-Office365-Filtering-Correlation-Id: 8562e975-774b-4b5b-5bb5-08de53608d1e
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
 =?us-ascii?Q?Sa40luhuY8jONFEAKbe1KMWzXy1tdeGI8ld7rfJLWTdTOwYGFp7mRvWTu2Oe?=
 =?us-ascii?Q?hu5pC0ngm2iYJaqm6EkakrGgFw9cVQDJZIrfYBEjrL2aEs8QHDGcExtp7JNb?=
 =?us-ascii?Q?gT8k0DBZ4h1fIwyUTFWfnCCpMPigcwlZz+i5B3wYfSu3p8gcKXRsDp7ZYCtw?=
 =?us-ascii?Q?LuH7ba2pwnGzZwuLKG+J4iOIJxmZJAb3z11/P8/gmMFPb7GcYhidPH/DOBBE?=
 =?us-ascii?Q?1nX4pjr8cuaf10IWyPEPS9XXrj8RZWH6/k9Bs13DHK1i2vDhlDmmq9g78QI4?=
 =?us-ascii?Q?TG324rnRm6nSwGOTM5TFrKhIGJUadeI2+tdxmw+k+P0DuitBdKt8OHY6NF6c?=
 =?us-ascii?Q?ozPs+j4qVjaJY7XNcYRlC6VyH/qvJJGGvVQ0a2do6F8SwqboDadqZ92GpV6g?=
 =?us-ascii?Q?joheS9EUV3wUbJFkLssIWTuxOOdKSsGLVfNLN/NgkxWLCZgBMKRtgAuGEYkC?=
 =?us-ascii?Q?YXrQIxBZdHZW4VBojbvlNjE0qtKR+IyiuPboHLWenbXvvi8/k37xmDxnCVS+?=
 =?us-ascii?Q?TiHg0HT24VwsG6L2mmLLM54fxqJRwleATSwmDB3UAGnKpDLMLa+NuIz4k6qo?=
 =?us-ascii?Q?iddJM9Zy3VhcEpTXngT+aInq1lQTQ5aUAXiT8XW0ofmjMAexPlWvLu6/fMLi?=
 =?us-ascii?Q?p+HUj3zzL3Oeu7MQVVRStLCmNQmDTV2wH/OJztVO/vB7czIKn5/6YgUxsck0?=
 =?us-ascii?Q?pexSMdnXDg8WPyzwY7J6ZbvJ9q+oHPwXDEuFs23oBOqVONFAI8/07C47AzH3?=
 =?us-ascii?Q?UnI3Ii385NrE1sFqwLhCQbolWywrOWPLgln2gXRIVpnOdYJgaKvvE0CsLyMQ?=
 =?us-ascii?Q?fKDbfrQ08OL84EdBVQfZF4bsDhjly6ordlLGDZAIgyb9oeTf8+HGbAUsndkO?=
 =?us-ascii?Q?92VxK1Dc9YY7qj4LyMsAbTMUj5wx2zUYMRpepgZoEXO0lRW5ymn5nSMHD4dJ?=
 =?us-ascii?Q?2wWAo4P2kzMfy2XJGSrviHjvex0/wnlOzFT5NeM0sXQOeiHTdNdA+h64OfRz?=
 =?us-ascii?Q?dzUJ2vv6QV6c18FMue1cUINUSlzbVzF5o29v6JAs+1k6jM3KuW5JTKsrU5tq?=
 =?us-ascii?Q?qYo/sx1k9Fz++vtEsgsg65KlNr/NmNDhl2D4xhych5PNzLyGHyp0rLWVjheP?=
 =?us-ascii?Q?z5+faP62/wnmPji/hVy3BfUT8Wc0A75HsO+1ljWW5DhlHD9K/lEMnUkvppqk?=
 =?us-ascii?Q?Yvqc3bkRR+QjXR9SmDIY8MexiZt3AWe8iywqGEENdm1mohgjOYPU8BjoZ/is?=
 =?us-ascii?Q?u08yJzLP0gWg28+BuNJp4mbzoKnVLbZ/PqYXHl/wqScawJe+xQmuuAGUunwB?=
 =?us-ascii?Q?yXGGw4E7hDqhUX/TCMRZcjkQJPP01x5MTp3MU1PG6i3tzyY/bUgjloKC4Tzw?=
 =?us-ascii?Q?S5vUQK+rp7L8f59l9Ylcc7qYGWMZDzzc45y2+KiVZZ+6IR/GylT66MPLc2RG?=
 =?us-ascii?Q?RnLuVqIB/jAZBh2kbviFKQ2vV4J2Jo/qT9Yaan2FO/4GtJrmkpX+Q7ymDn8i?=
 =?us-ascii?Q?wNptvJwahWcdfw65J9NLxNecPKGhPNtbIQ0jlsXEZfBm4xrxf7UzkAJcBIHu?=
 =?us-ascii?Q?/J4Oh8sqJsHZoMap3Nc=3D?=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?RyZoYlap0YeBefptfNX4TOb9hZ6KnFntCMghFcWeo266sSzUxrTDjtK9qm9K?=
 =?us-ascii?Q?AczCBc5xIRLSppHY8b6DFlDdhvZBLEDDwoK7EpcjLBqqBxXDv1fK3MqzsKcD?=
 =?us-ascii?Q?3A49WhSb1KcIxkQ6AdfTeSgJGD4JMRK7kx6yJGGAbbEAfSqBgVfh+EfQy6sp?=
 =?us-ascii?Q?+e6BkiGatKv4dq/VGhA+Y80USQRcTeVHRLLO/CxgakvB7Nr/YBANluHHvBQt?=
 =?us-ascii?Q?BOVNlU4fCYIvE71Lcr7FBTomWU2WcM4YEuiWX3JXdKiy4yQVycjB02GM1bSV?=
 =?us-ascii?Q?L23ofM24xITZsCQc0POfauYI4Lsjb+8ft/NQ/BVbN3r1KzrhzwYEeE/wCU8t?=
 =?us-ascii?Q?Lum9s8N4lj+eiIx33ohmUk2S3l0h5Ix63JauaJ1lvR7bu+Kyb+VXQgtPoXHx?=
 =?us-ascii?Q?AZQdkC1m1uy8ETQRoZrCzvwUPsBPAyKJu/tUPrfHJMatBwg4N/tRytaV3Xe1?=
 =?us-ascii?Q?LMI+MiIAWKbD7CK05pLmGQcqEsv+FZBsdpKTHbw4IrV5DWqFcQbdRNCMfGgH?=
 =?us-ascii?Q?uXYbXriqid/Knm+EBiLea2mPJYkiqNPl+ieTvRIQOeBz5xKBdZiniLvKY/um?=
 =?us-ascii?Q?WJ+QrliVeiAbnBsgOPRYYjTAE0R1xYTweaLav2fmI5VQf0FPURg5dJIIHjr1?=
 =?us-ascii?Q?RQK/3sITW30tq1NfL0apZDWOfABdy5SQFWaDeK/vtT89NsqC0r6BDk2akrbx?=
 =?us-ascii?Q?y/y59djoMnKwGeI5jZY/Y/ACa+1iqTcsSBAhy1oLE7GzDdtiqeA6kiCUgGLe?=
 =?us-ascii?Q?ruSpHdbn7I1o7zFZhPhjfNJrM5x6ZqdlXKRMUI4ZqLNAOm2MxjTODtlS/NeF?=
 =?us-ascii?Q?x/7vdHK3xaj+uaf/a2Pzzto1hS2r1hsUBSR1+20JGPzjNdtMWW6it+lIuaQX?=
 =?us-ascii?Q?NOynguHTrm1Ocsdebv+3EkXJ2Vm+kykcr/3IBdME+LRHUGvQAcdr+TLK3H1d?=
 =?us-ascii?Q?SQ1Fj1d7yv9gaI2DWEMaUE6McpwTnAdsjoM76aqZSGlk4FyGGQmfKTLc/09I?=
 =?us-ascii?Q?6ixEzZcwvy090/MJsnwW2ubSqqJCe/zQmRz/jMWounMyEDY64k6xnlQTeaOy?=
 =?us-ascii?Q?kZ1Xsl9cLe9nidrm5xDGMVgvQQU0JkatOSa4vCOEbayIrzI90vPTy6ymLLtn?=
 =?us-ascii?Q?1rHODog11/1VofdJONaDZOMXHdnm9C4zpukJf2KUyz8RvtQ5f/F3Q3Mtk5MF?=
 =?us-ascii?Q?2fqRhDz7jqCnhe9V9r5gSAW1HPdUpz6Xr+2WDzLn90Zzh4+5rlN0ryXeYBRv?=
 =?us-ascii?Q?M93cv/9iaXPOrX2oHpl8c6Ob/Avi/vXUsrCeL16YHuo7xF+sLsmEkJfOLGsd?=
 =?us-ascii?Q?ysUxePXHJYXB1pVx2CbXTpoxuKFVowO7pBdS+nSvFbIGENWRa7+AqCNpPu+n?=
 =?us-ascii?Q?LGP9b9Pa3JjQfTQ9UJ7BRtDs/ZKE/FLtzJjW+KsJL33dAmxnjVB5gX/zGcgH?=
 =?us-ascii?Q?MZ3qptFoDKlZvlAJ4lB0MnuObDYvp2QEblRPf6LLLYCaOHTxMM//Q0IWoBVY?=
 =?us-ascii?Q?Aehq6dbZwoT5bo1+ho5SrHRq9leGuoXB6D4vBy+38yqJqPW2K5E7N7TRiBGp?=
 =?us-ascii?Q?05kMHX8WNn0O9qtwQfDM/7vy1V9AWyHtw4W8iNC0MciYITnFOF+fUF9JTcxs?=
 =?us-ascii?Q?8Lw+A0GDE7oBUTe46+/7RuMsKCdkrDzCSDjpGVf8j4U3W1SO9hcR5sjdNnyp?=
 =?us-ascii?Q?eGcq2VFhLcWcPHOla3yW2ul3e3kYHknUxeFaCL2CTAN6l+baPZScvMNNlOP5?=
 =?us-ascii?Q?CvDbJaT/ICMtjAtZwC45RRgE9hd3VRc=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kVWc/53SkuGHk05etoVJP8BGL7PDgcXk9XuGiBofU2ATiaz+XVJs9Y7JKYa/MRGTJidfCLtVikxjrUG1fH1+I3mdovD2N1G0XIgy7k5nEzlEa4OsCuwe8yJC2Ya15+JKD/ZZjpz4ktNc9vo/23Bi6Vs8gE2rk74OcVs4RUqtGARk2lWh3MidiO7cfsiEpyrml6Zt8LXgRsH5Wk1kPdjuL7VM29Dw7NMrLGQf1ZmVDW6fcCYcsIIJw1Gj60a6R7twBxZtLnxwHwi+qPXuddFMICF3o7PoW41DWsg4Yo/BMmqozw7mUswFavq1m4IT4FsxBL96oL4KUFNLALe7445+gRlQkVKsVGRqXuLA3qeeC45nUZ+OY4RE2ALfooJQ3eGHICZdQ2y/2iN86xF2tkwWjfYR7q74dgM1rQGRXRP+7T+bH+YkLW7YOORct1a4Nr4yBGzw9ceLomPGPWsX+wqbHt5qGYxW75tN3trIRRuiVEdSzMVWCZIQrWMlT8XqSbjlOCxqdvWEOYPzBmfLe+U5V67fW8pRHnk9z3BSFHwqUcB1NbHLFyQOSDgXl3Wot9MwkY+5VaDjE20nreYZ4FswuVWObUtqPB1ZU2D6NN4NAJE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8562e975-774b-4b5b-5bb5-08de53608d1e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2026 11:32:08.4209
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNc7PjRkhxs0oUsWAplTUo0ahSAn4UBbouA8yOGT/udj0womWN2iiEJqfaML8HioJes77HNzKsnRHRkg0LL2zpLk7hHm4Yc7xWtLgWVVS9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4782
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-14_03,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=620 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601140095
X-Proofpoint-GUID: duh3YWLubxffgQbJKo9NkBO4QVTWN2h9
X-Proofpoint-ORIG-GUID: duh3YWLubxffgQbJKo9NkBO4QVTWN2h9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE0MDA5NSBTYWx0ZWRfX/r1tTUDWPYu9
 0XSupmCMc/idwxyM4JTID2J2rWdu46LOSGXXQj5uLfwt6ZtIb1NCIS9fkyF/UcFPJuuQW2PK55C
 AMo4HB5HcoJWHFpQs60w4y/nMELI3OSqggRiEyehTo+mZMpGhaPp/Tkw4OKsDq5dNGeEy30YwjE
 Lk2wUQzUxbM/QI7tWXsiHdVJ3eEHrmwbqZiHGk5W4u/XDvlBAREBvm7a4Q0AjBvFON/qOn+3h0g
 Wv/GT0s8AyYrJY7GMXsA85Nb8GTi0iWztBo5kE5QWDsLkjTS+VLoYfYgk/PMh/8fpZAxphFLiq8
 rHCBWr9rIeO50Q6aC3EJwmdyhOpxVvagjLZjuWQG7vVuTNu4Rd2Wm39Zzg93l1Sj7lEEwwteYKh
 h1kx889G7vRyLYKz7q+PnISFx8uHisDmqNkYv0h1GPQzel8UWiifnl1Z/8sjV+oCUeaj41mnWAD
 I9hXFAF29mvNDhVQlUg==
X-Authority-Analysis: v=2.4 cv=fIc0HJae c=1 sm=1 tr=0 ts=69677ebd cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vPONcj0NVKw7j5KBOh8A:9 a=CjuIK1q_8ugA:10 a=M91JV_wKSCcA:10
X-Rspam-User: 
X-Stat-Signature: xgn8oadq3s76694maiwibwjfrqbhdg1g
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 245AE40003
X-HE-Tag: 1768390342-35821
X-HE-Meta: U2FsdGVkX189uPU15Ay8lUz2I/H2MWUuYCzKov9H2JUUlMPtQwRXZaH3vEdMJM6xjr1S5eGta8knQ33bueEy19+85Sns35GDvqUGXiT+RjGxLM53YAgnj/mlm9z/9dTySIbHoiJrji4eAhUoTTYOnu3njGEC/B6JTf+sRPbEJvCvyhgSXa4VLNIFVZrFq0ITI4gjsRpXxLGMNMznUPtZ9A0aLgSz9AGj4wjpYjS6hUfe8gaeY3Di5ilMqT+yDGiU/FuvkaUHgu4O+2OrbaZ4rWeYyAhHA8nETLaqVUAenDad4uc9brpBrtmqg/F5kQzUQXm4evFLynk0A+dIVIG5zfM0rId4edHMjgLyz5D5Kha6dcUT26uhZbXcWnVWGL8KNthaIYc94CHcVvdR3NIR/OaguyKTHGrwDNlEnaoWcjficHw6CbLsoWVzzBuGw0RWCTO/swdhJWk9Tx6h+0ANoOtKH6T3Iky1gjcCLNuNqQ6MLJxqVsa3LFv3wPFY21VRmLcTc7/mTxiM2ECR1VwV470KaIkbWYVyJbkAc5Y4xY2Ft9Ft+tp7PjXwf+Qy0YufG/9NMoAh8IL/K/PIrx1dIMd7QI4cicpG1/VI6Zu9y1UYYAVH9BkVMGYE7wWRPN4XOtQuZgrxO6p1efFKT2Hy/dsF8ECMKD/6d44ZYZsOjHL0wZja5rfLIgHO47ezCxe3rwzr21qEKz8mqj1MhV47P4rVFO4sQkhuI8nMbdDMKktDDf/Rfw6Nd06TdWVeS7BGe2v85XTG8Tjsis7o8e/LhiN8q8/xTzq1gRx/eV2KfqPu/e+qmxh5QaeULvyO141YYhmSdAiUsJ9Af2z7X314resL3gu8oGNuiH1bXqttItgMGO9iKLRttXsKhnAhaot/np6mM8p7WXEU78wjIYgI08JNG37vLafNMnjfF3yfwwPq11NAXATZBpY+EJZDxoYZ2ViLVbjIFgyOWEaGdN7
 k/mQRvMN
 0sdaiOIyKLQ2GUn5hudrDtvIZAw56RH5KXBXmOPt4rTkgrQSPIN2vReqPedMBoOoK1ugfwfmsjB2XAdmk9xLLVoSGv5iaTCB7hb+WcMthR3ZstVNHyW4QC4aHosAWt20FTOwXzrirhxMDSr2R/sp8Nj4ckXxeXW8sYMQD3Nj/uDdriaDdyNC4cNg1f7RKAKKKYZSB82u/ebj1fsq3SrjtqCgNwxDp0ybv8Xb+ssaBhdO/iGuX3cr6ljZXJ+Wfm3hHyNIphJLyDG2IGPm4rA7P8aq1MWyFAwYRdBYEogeqEdpsCHN8XZ/QAaKcF6xbiC7PZ++mJrzEhINSioLwhliSDSUNJ8NkT2KW9GbMsIZqPRO3mpMU4VgpzdYxzKdLZQbYEOUhsO7djz6kX/PP4CwjpnvXtjxZ3if02anFnrBUwrFivWa59EocB6DLQl8gAKodmT0uAuXxwvjvbRzKPILZ7mTPXZfEWc0UpNRVt04UsKPzf51og7/0zLebgnAjjovwHscyBrx2IIxZSnCChrU9yElfDhvbgXjPNi/WoSS9khIfxrzGuxK7WRysVnNXhQYbzJ+7+aIL2RwI+oeKDmqvbluUjMbMC3P8IfGBvxR8e/S/8IV6vYArEMynYVw9QrLow9OtXWbMlWaGKAd/FjtyRCpBlL567tsoQXR+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 10:27:24AM +0000, Lorenzo Stoakes wrote:
> I'll send a fix.

Actually it's clear that assert is just wrong, so I'll drop it. we don't
assert elsewhere, this seems to be a 'nice to have', and I'd rather not
bother with a 'mmap or VMA lock' check here as it doesn't seem worth it.

Will send shortly.

