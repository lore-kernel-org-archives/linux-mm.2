Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14819CAC59F
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 09:14:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FCB8E00E5; Thu, 18 Sep 2025 05:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6411E8E0093; Thu, 18 Sep 2025 05:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BAC38E00E5; Thu, 18 Sep 2025 05:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 381908E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:14:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCB0413BCB3
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:14:55 +0000 (UTC)
X-FDA: 83901811350.03.E32E0EF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 38D351C000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:14:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y52N4+uY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TIMLsb6W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758186891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ZWnQKPBXFipVJycdc86MGYCQplUmlHAEcateV9m3K4=;
	b=dC1ME7PhxA6WnoXX+VIAQ7P6UwKWvtXzC2yNi9OGTmopZ3VxNHX1sGVdcv47eTf1RSjUwy
	g7YvJ6OudlUc7J1j5sJ7dJYq6sb9DPQVBXWxIJZqOFXfXOadcVbROKXy+Ivhvwa50UvBom
	FFQoa+0Ng+7IO0rlTJeitPxKJBjvkYU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Y52N4+uY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=TIMLsb6W;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758186891; a=rsa-sha256;
	cv=pass;
	b=rZmgQKn2hgkkY4G8jlLswgn/seArgmWDw0pu020K9hGPim16/rAzF4qwEPw89Xw/KQZ2Na
	0Lh9rwe9Y/6oWfl5q+8HsmaG7UBMipIch9MT9TtlGZr8sjy2b5G8vqp8KwyjY1vV2d272W
	SEyF3rRTqPiIX0Vkc4IK7vTWL6+Lnjo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7gjFP019426;
	Thu, 18 Sep 2025 09:14:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1ZWnQKPBXFipVJycdc
	86MGYCQplUmlHAEcateV9m3K4=; b=Y52N4+uYcSPdNWm3+cE8QcZme36w962UaF
	KymZHicEky/9NEIx+HRDsBdWdFnAHR2XRTIJ9fqygnaOosHEg2yhB4+2IrAI44E+
	W8NG/8VnUjnPZisR0gQN4AYGKnEYsskmgo1Fy8nPqhTq/GUlMiU3pqv9RrBtsFIS
	HgI+RR/O7hTXvHxsgLLnr5KA8qLm+7bkNn90UwnF23Iihr+UIG2sG+bpycFGBvTh
	2WCo6L+GM1TdcbB3qOCVms7G+XDcLm3SAI/Qk42HFFvUmVDGOr/yUzwxc761ht+G
	txbKdFu+Cv+yPTev/2rVkVIMXmDcuqLEL0+9JOYLYa8cDPPV+MQA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx6k2gv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 09:14:30 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7Y9K2028755;
	Thu, 18 Sep 2025 09:14:29 GMT
Received: from bn1pr04cu002.outbound.protection.outlook.com (mail-eastus2azon11010023.outbound.protection.outlook.com [52.101.56.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2euku4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 09:14:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kufxMYRMJmKNvxBF6/gKsBVWCzw7W6vBmb2xrNC3TdJRZKzmwCnVCHXDdVQQSfGB9uCgUA+Y2GUd39z8b6FjQIEMOofRl2XyqgHgja60DvVIPGfrGBshhgHv9O7C9CQIntLO8IUHsooUqUhd7SuHGu3RU/+iYiLOs4syJksedyRI38Tn3VS56Kb4ihGKSewGyVrIzqCRxI7uwlVgON+A1j6uyo5SxPzPxRnBasvTBhxRWTCjpcu9U6U4NU90sR7SBecY7prIZOwYNA7NrF/Z7uz7cSB/e2GLB3B7K6T4IXa3kGorLTxp0Oy7y6RGDVtCWC11Psd9NuXv/go2YIEPUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ZWnQKPBXFipVJycdc86MGYCQplUmlHAEcateV9m3K4=;
 b=BaBoG3jDSts7LPL/D2lE79cjr3hFfmXqV7kJYmWmCZMVQJCN5hRturlmKWUm4aEXOUndxNZdHrlQX7FCcHXaYGk34udflAYQJOX+EzVVmikvcRh0DgVSRF4g+pwiOmYVzv3up1ZQLEdEQZBYJx4eV83kCJumaumDvkInGnKZA3edHq1NUw5d1oQjmR5wwS8CpnHgt4wKkxubpqyHgDXdWJpwY/ajZSP1G+2bNt5AjEEUaJd1OTD+/pOy7PEXzhXIk9rEi4lvJe4/ErWQnCGPCUOgrw7CCY1hyCnL0lmDdwcR1Ywgm9plQR/j5HZmrKgiUutc1qo0K12F4tVNMoyc1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ZWnQKPBXFipVJycdc86MGYCQplUmlHAEcateV9m3K4=;
 b=TIMLsb6WkE+3mC/ROo8ajTs6LEzNOLamfueOzt2QlzSKfYqMgUvlXTjk5XAQQP4+ok8WuOZtOUmJDFBC3dQZhX5oJbdlhA1jTGp+b2HFFCcRAJtsPamVzm1XVYPG6htA1C90FL86YnmYIHrH0E559AjYjE+NYf2IV/c8Pb4LHrc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB5991.namprd10.prod.outlook.com (2603:10b6:8:b0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 09:14:25 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 09:14:25 +0000
Date: Thu, 18 Sep 2025 10:14:23 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
        Guo Ren <guoren@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andreas Larsson <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Nicolas Pitre <nico@fluxnic.net>,
        Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>,
        David Hildenbrand <david@redhat.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Baoquan He <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Young <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Hugh Dickins <hughd@google.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        Uladzislau Rezki <urezki@gmail.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Konovalov <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>,
        Pedro Falcato <pfalcato@suse.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
        ntfs3@lists.linux.dev, kexec@lists.infradead.org,
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
        iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>,
        Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 09/14] mm: add ability to take further action in
 vm_area_desc
Message-ID: <20f1c97d-b958-474c-b3a1-8ea9a177e096@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
 <777c55010d2c94cc90913eb5aaeb703e912f99e0.1758135681.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <777c55010d2c94cc90913eb5aaeb703e912f99e0.1758135681.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P123CA0456.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1aa::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB5991:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e61236d-661a-4d75-6977-08ddf693c36a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v2AdNP/olnugc10JNQJ0Cv5Ygb+NrabsIxLX2RWSLH6MH5bE7sRGmH7tfBQ3?=
 =?us-ascii?Q?GXzDvmLZz7VugxevlpeXFVqrNCV6XRtxu8A3a5dVCarEFP8wkBvvfo6z4G2t?=
 =?us-ascii?Q?xnObd/PCdS+llHiHgrb3vXL+2lhimjitWB0yxA42TodoEjbLIW4nFy42XYpP?=
 =?us-ascii?Q?EC9usY4s6YHwpUSqkrnnG9VoODbSxjIvZLsn4v3jA96P9FhkiaJWsgaa5RdS?=
 =?us-ascii?Q?pcLFrJNiFz3Dt+1t4dEKDZ4YlABXKSZzULqvzbuKSGiNI6WEJ1kyv2CLtr1Y?=
 =?us-ascii?Q?bOerX95gKpgSFlL4cXiBjk4DAOIDUe847BirfbO5IkJ48pDMB0/G1fiOG20o?=
 =?us-ascii?Q?9a83I22gvRQ77LjQVqBl8ikVSYEzaSepcmkz0gHeuT/lGXBlT5SjbpheI0rW?=
 =?us-ascii?Q?jBvQjwxfZGLZkkoRbhzp47FslXXxpoBp08P1DX6g0C8czbbUuMDJaAdsP+9C?=
 =?us-ascii?Q?yVFaGAeukMrmruVBjIkxAIg4qwT2lCHBz4lHjj6j1dgqwP9qmLskVuTk3p2b?=
 =?us-ascii?Q?Kz63jcNdcQBuyH1aVrSP25gdw//8Kquyqy9ol+w1Fa5RPPH9DIle9dY5r0k8?=
 =?us-ascii?Q?qxyWY4T2JXVP86niJsl3C9/WUTzpI/arjj+TAeTqN0Abn98knZQqXqFinQfH?=
 =?us-ascii?Q?QCm/w1/iGeJAhc32m0iUO0qgpVRDW3C5qfRYfFwk3ezvk+FD0D8EuHg69jGo?=
 =?us-ascii?Q?SBKa2hWZnJhJHo7nP5pKbVBcoX4QxlmgoDygkEaBMWyqJKsujkLlU1vVQS2b?=
 =?us-ascii?Q?6wZJ0C1EgM/DDA5Yv//XSPa4zF4XRXOKgSQv3CliUGoevFiSN/sZkqgGeu7R?=
 =?us-ascii?Q?HeRUZYLgIZSOKcuJU7XUYhp3xFLyrVVTPUSgiK+E6evee+7lsTNYV5cr5uGT?=
 =?us-ascii?Q?Cwcgitd4kSpqoUV/YhD3dpE/NHAdbFQC11tLQiC4xvHFBzfRRdrb2bwTrOm3?=
 =?us-ascii?Q?V9QwR7O6nhKXqvrkTJg+E0e7368Q0CpZ0uQxUoWkQ8NYjyMzxexZNrIhZlyN?=
 =?us-ascii?Q?t1ZxgZ8IMZnwrwAKAJKUKtnUAND4uIJgmx5GhYZFJbEzABe1uT0xfz6ykt+o?=
 =?us-ascii?Q?iaRPgezlVkAdI2TJjHDTunqM+0NMYE4w2kqYL7b5fGOwArmwd2nU5Nrhn4Wa?=
 =?us-ascii?Q?4kjJzPXTJkCVGB1ifCK62atbApyQijiyvTG9nYVboAwSRBEhmGbo6O7c0JNl?=
 =?us-ascii?Q?wC3YvMSL0aL3KUCNXUKSbdcRZWnblQVP+XEWCkjgiNAv0/zyR7N7PjOqnhm6?=
 =?us-ascii?Q?1Z3BC6Zi3H0KBWKvmFNkzPpAjVqAQkU+Bxvur3WecCEWwKs1sjTvzEAnGKua?=
 =?us-ascii?Q?KvHu4/1UE8jBwJjeS6bQsLSNIoPRiJaMv7Cf9fy0Rv9Xxek9xLfoTrlOITxa?=
 =?us-ascii?Q?SF2CEsI36fbey2UyAfowZY4E/BmkhUOGOoxXQ4p0HDUeHPjDog=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XgmqFs4iailYvekmQzq65cMjCKFz/qU29Ez9iHty+aRKlI5wSs7oej9jWTnD?=
 =?us-ascii?Q?uzDFmx86O4orU1X8kn0Rct7PfUqkw6HKJ2C/z/9lUrLpAK1yXS89BkQ2gGCd?=
 =?us-ascii?Q?2S2VOhxKJCIsB6Jb8g7CWeIp6aflc2ByUF9X5HOsUxMeQNYl0ng4NEbsRsZP?=
 =?us-ascii?Q?jZ9nAlQ/p+GOSmCBKkB6FEXKftxAsC/EYNzhJ1CZlXymDRlPeDoKxsOCIWzs?=
 =?us-ascii?Q?/YViGcIdhk+Lc2haoxqMqkqUFwPBy+wcJTp6LYxmxP8Qdo3lX2ewT2VVXscp?=
 =?us-ascii?Q?ML3xSoNVJWvTo4A4J5Jmq8OsUN85WjEpcFi9oRKocJgRMeu1THBaEDI7HHW9?=
 =?us-ascii?Q?9NQRPcqwaA7ZxGenZL4sfjT3DXHRNOsOTJeU+mo2CYdFsjbVW+4SAb4YTLbl?=
 =?us-ascii?Q?5LPe7j8uT0OtJYB6iwTjnZTlnsWVLpgYheBT9LOEd5G35iAA7AJiQgA3vHW4?=
 =?us-ascii?Q?pkkhPPNgq6R7c4JLxUUwH9U1eDyLtUIaoml2LhvfGXEsZEvnUe4mPEELMPhP?=
 =?us-ascii?Q?k//nJHD1Ntt6eu+A13/FYNYYJPn/EbkwuKJQ5L2Nq4McgMoJmtJn7Qk2s2Zg?=
 =?us-ascii?Q?rveQf/Iu1ctvI2J9Lj3S+c3VKwaAm8zECHjF13qROPnNzZIjb6LjPbXkNAtx?=
 =?us-ascii?Q?hALkTM0xQjvQ1ASydavuu6Ey0f9rIiL9GWU0HVexEKj9DgaMZvHNHvnKxoDW?=
 =?us-ascii?Q?AyMqDvaWpTqJzy+7uZx9YAu3UFztdQUjJ+ekevK1rj6Mczr+wn6YLRHdNdF4?=
 =?us-ascii?Q?pn1DdmloejVFuQoqxkuvcRDTRf9n+Yuceis2SvSG+XOXgvJq/7omrQ9yrG5A?=
 =?us-ascii?Q?8RgWU3WA0Ic0ox9Q+Ya9dGD2Spj8ftGu6tLO53EBK9a3HtrlYWqYCL50gI1S?=
 =?us-ascii?Q?TqH3+goP36g0iXw9jlGKxp4/+Y3HkKRZCI9JOiOTuTytBF779AB6HUCB++RK?=
 =?us-ascii?Q?DqowB0XtDaEnVgw+zJ/7c21H/QDKoV/244fE9n+vZ6kwSpML/hnF3/efM4ef?=
 =?us-ascii?Q?f5iq5cC7yYOfT+7GA62kT8f+QC2M2LYaWwFu8S/uoei84NGN4T9/d/0RXhFt?=
 =?us-ascii?Q?YnjM+JK1DOPJC8enVQzqUUGEOlLqFmSvtyAvb89LwNRq/udhVtKQq+oRiABn?=
 =?us-ascii?Q?vLey5tZKdEMMnco6d2oiS2nQlCVWKpXJvprfq56DgxbPTK5Faq17ujOHL4TD?=
 =?us-ascii?Q?xb8D69cUObDimGu4iUwV6/pYrjFaIN0BMQY+kvURjuaUxuZtwsj6G+JnmRdX?=
 =?us-ascii?Q?jo82e/GHKRdmBmXha3Fe9/uEsDjVUMkzRf+68Q3eDidqAVM/ejFw4R0kKbSH?=
 =?us-ascii?Q?tM7d/i/XYTMZfGPYvARaIj900UQ0LIOj3xu7wFVei1ionOfg+TWh8qApJ85R?=
 =?us-ascii?Q?b36DiOIW0a8woB+bMaY5MXU2IFhnPjKfPK0zlQ0Q1bWoDC4M3wXTEu6hVhp3?=
 =?us-ascii?Q?3FtrnjWKIw2xtAA1IfrKB7yfzdjGCimdatl8J+8vlwvcjnTb0cgqt/XwkLuf?=
 =?us-ascii?Q?sq7TW0vKNCgXhwGQwLlGUhyMZne/J+xMYmiafnqdJE6qh5/cpKnXuTph1XN/?=
 =?us-ascii?Q?INM+k8D4/bTNpXol0SHRsPVNdG1XHY2I/LWQmigAZuPmzi6Zv2kqdyWNdQla?=
 =?us-ascii?Q?bg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YWEgk+Xl3TYMx85Sva0GQjUkoPyWQCA1+I/HyXbWEj4znv/ZKRVlw0Ap3g+6Gc+lJ2Z1XKIjEZrKWtGf/h3G4Yjm7IrcPx8x+18xS8t62+G4NNtRMiSZdvyN0mGaH1XrCq4cKXkMAkZh39ySThKkCE+HEpqGQb+Baiz+Pxets5CtTPb28BOAFroQ8BwSebRYARkwXn7OEDXJctbOTmQ2U78AoI7jDbJZ4gdN26wUb72KIsw4uUz1jJARucrZosZFDQrLvVYoKycRfc1ViqPovj5amTrQaaSiDYFyacdcVS6HFQzevIyTkN9vvk5F39mdjUr5xncRbpuLYTwMrZQLW6LwiB1XPWELxEqsVbxgmwvDs72MbydTWNthBi91a/7ZY/KXnwZ0rNzQMICr7x2MyKXTDsTs+IhZnJWQc6xyw+DzihtTw5sITWKDfAgbiua6sKSVmOzsXIbMbGtRy+iis23QSOPsASHGCqXTfLwMs4qOiKIVwK9mW/AT1Or1nVB7ngEJD3PEBHZ3UMNl4vIbgjGCdupsRqx1yb3mAse8LtogeLIu1IBNnnTTQ4gGyoFQNUQKaJCie9Ghj8y3weQ0yPZe4x9S2ld2j5mT2bVX3/s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e61236d-661a-4d75-6977-08ddf693c36a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 09:14:25.6266
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Twf7tp0S2QDNWlaAvzlH2yhH63u6wkCjGYc8QnrChh87qHQR5LzmcAZR52lBLv/kZ61qS6hoxK1BPRlXdcIN/mxYVQ88xsD5p7ShxILXj7w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5991
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 phishscore=0
 bulkscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180084
X-Authority-Analysis: v=2.4 cv=TqbmhCXh c=1 sm=1 tr=0 ts=68cbcd76 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=6GBqCms67bi5QGnjy7EA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: c1VH1OHWlz4HvKONPPdaIt_DmfqJboZ5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX8p36igjenQnU
 0nDIDwy3IcEG7R0q/8rVlHsf4/QBzw8fBM+ufq+TpQuvO3xo0Cs3Nx5cbqBo+w0jaFLASQ2N5/N
 eez9ZMuCJrbPcp0ps6lh0Y22H6+5/G/Ufj8GZXng/dl7aIVQCg4iXmW9yAkUWtKmgbtJ3xuFK68
 ZppSAlr/xEFE65bu9Yl1py81r52hBfaGVMzVkO1b0bTcWFH1Ih068sWvisOcjFjWWge5ZBNAMkV
 mKhHcyCY8DMO5CL8AiARrp/kqJhLKjgQj1E14qzB6mKY7zYha3NZmF10COuFZW6lTIN5TdOSQk1
 6Fq76N4FraFf1IJb6JBFj7mNE3qtlTeF3LxE72al2HCWc6Xvv39dCSdxVhtToiy///6ZMXmiZEm
 zfL+8jzx
X-Proofpoint-ORIG-GUID: c1VH1OHWlz4HvKONPPdaIt_DmfqJboZ5
X-Rspamd-Queue-Id: 38D351C000C
X-Rspamd-Server: rspam05
X-Stat-Signature: pqo6aw1muzfu7o9ngxhf3rmckqw9c3da
X-Rspam-User: 
X-HE-Tag: 1758186891-952691
X-HE-Meta: U2FsdGVkX1+4O2S2OvocdMPk6VhZ86q2CiMeouu6Zo+ItIrYnnMPB67bdl6yFYlz12YsbQbH5T0MWf0VCFLQv/FiMJKDh6zhUACr2dHoxH6xnHthabzup9cX2yq4HR0ZohQf11oNT34hj0zDKhmGTJ5V4Qq1bTSbNIMgbsxOVSS7fE6HIPLUqK9iL1sIN85WLznt2qbcOetTyW96QpcQQmPgGxXW5UeRVEgDQ23n8b+nlsbl+bifpYO1Nd7iJPH3SKf6OiVsB6mml66JuWyKpBgpm46dNnFs+i8xPiDU0vPGfA4rLyrYWkI35Nbvaz/C0PV4D4RwXh77cEvKOGSAHRXEK7wgfXt02TSB7s78iOqSuVrJwPLvF9DSzAzgk21hWk5/g+xvVs5fpvsrRkXbxKFJPy6yYTzv3OlCgEvCytE9/kfwYgeMcdaz7800nZwdBxocme0niyFzr1MOdSbQJD52rLtv6QQCtS3R6OgISGKi+jqnGeycrTi2UsvAD9VHU6bbaij1EHa5Dl3sXgcvDiZ2X2q3qkFL/YhT4yRXU0VeZFlbPRvUoMn+CQrxlTzrjuT0ufNuMbeg0UG9t6dsOISza590NjRc9BzoG2pcMXfWUzaRZpXVtL0T7ehO6G3PtMZMf/o9wafeLJ42S8LyC5XDFwK+SIwwmO8X0J8Dw5d4GIEZCCXIIn8LA+uuw5ujmxxE29cpcILe0MmicJq4mD1zEoYpN7qiUcwk4+nMcSw8sxX9g7DKktpKmD098jxXA645ipbmqwrJGt4dnbYomIx5KPcDA2PKeykUKFv2KKWRMiKdG+ESfUBNkRfVsXFl1QEtPjL/Sqk7PuhX5XIE9nanLKb9iQ3n8IUe0VFIqCsCgzlia+28WCxCZZm60819GSPh8a2jLb2Ufl3WKvjX9F7HyXnYFG+q1WEoEVmMzq8JHicMmGXhYvTLajFtNRAZea/zQ7UFY7jyUvuAydA
 0/P1zGQd
 LQ2Pi3KBgUiEJWSWzl7xHCLLa12zeMEocbtGB061sPuLlWVrgT8jzvSvOc5O2IGdH/bTXLo/iRk5cQjrJPAnhMAO9ZwYdcNKYEhWgIOJQPLyNz12r45gmq0PMqnA32+VEFpeYYs8TX0dfA8nqFDvl3NFpZ6Qfh3r+2ToVasJFM7qg2cof9BHi91VGhHGKyJN73T+oqUx5Anzt52o+Mu//IpVftxIfLcyNd627Mv+dqSPjf6blcdKabTbvsNJzd9J+0a7ya0lSUN447znRJDSfQP4qdppP6Psp7ak9+NfwN9Q3+P7yH9Z+LcXSitGwGxYJZ1xzEmoSwUf1qVsE02gOaDqA8IUxEuPt5/qISHp4JtzQ6AEivR7PWqvjqjgOSPH0tf5Aca7g+0LHhdTh+OmU3PQZSXQCfGqteClMM1xEF2XXq96lZXh+qsOOYBKwKmGZLfU0pyGKwqq24EzuaKIWP4bfMRNdbwFUN/FfthVkau3s+vnichZhrfcPQH5BZif256+8VdsZcmEyo85s0MZkLEifY7KS6AKPXEkwKbDW1EX9Xnd2UPQAE4qUtPRuYQIOwSYCDgkPY6b3NeAc5Svh4B7MSAHjttecmpod3+67TFufp1RdE1AgQWM/y1GE3WxtZvA2h5CKTbz0oetdGaxzXrkC+emonj/ZFwuTwyH1fYwVviPfJGr/C5MBgq9xbQheXI6cMx7TV3ZnBUeJFFPN4PLBvOyMwVxJ5ZV6Ps2QNAw4hjAvyVfPCSmyinLmCXvfLuKPfz4vKfaclRtWtHpkf4c4ljZulEdII+R2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Finally could you apply the below, which has us return an error in case of
somebody implementing a buggy nommu action.

I also include a fix for the VMA unit tests where an enum declare was not
correctly propagated.

Cheers, Lorenzo

----8<----
From 17c8037bc3bfd5cdd52369dc6140d0fbbd03480d Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Thu, 18 Sep 2025 08:08:31 +0100
Subject: [PATCH] fixup: return error on broken path, update vma_internal.h

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/util.c                        | 6 ++++--
 tools/testing/vma/vma_internal.h | 1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 0c1c68285675..30ed284bb819 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1385,17 +1385,19 @@ EXPORT_SYMBOL(mmap_action_prepare);
 int mmap_action_complete(struct mmap_action *action,
 			struct vm_area_struct *vma)
 {
+	int err = 0;
+
 	switch (action->type) {
 	case MMAP_NOTHING:
 		break;
 	case MMAP_REMAP_PFN:
 	case MMAP_IO_REMAP_PFN:
 		WARN_ON_ONCE(1); /* nommu cannot handle this. */
-
+		err = -EINVAL;
 		break;
 	}

-	return mmap_action_finish(action, vma, /* err = */0);
+	return mmap_action_finish(action, vma, err);
 }
 EXPORT_SYMBOL(mmap_action_complete);
 #endif
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 22ed38e8714e..d5028e5e905b 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -279,6 +279,7 @@ struct vm_area_struct;
 enum mmap_action_type {
 	MMAP_NOTHING,		/* Mapping is complete, no further action. */
 	MMAP_REMAP_PFN,		/* Remap PFN range. */
+	MMAP_IO_REMAP_PFN,	/* I/O remap PFN range. */
 };

 /*
--
2.51.0

