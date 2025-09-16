Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F76CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 631208E0017; Tue, 16 Sep 2025 10:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6087D8E000A; Tue, 16 Sep 2025 10:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 482068E0017; Tue, 16 Sep 2025 10:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DEEB8E000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:13:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B30671A01E5
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:13:42 +0000 (UTC)
X-FDA: 83895306684.19.32A91BD
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf30.hostedemail.com (Postfix) with ESMTP id 43CD480017
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:13:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sBI2XXCP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="T/YTpFdp";
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758032019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruEIYstPei+cg0+sO0ubGZXHFUxCYPzBsVrX0D4uMIs=;
	b=1qWqgGdAE5YtNHYDfODyCG/I1+ZSklLh/sh6AsvWM4AhWTRABjyKt6FPX9y+BZ2maG0DQv
	bx1IBQbfPL+nkcNcx219peupNO86JDUq5kYSl0SUOie/Z0UvNnVOFLua2EldjctHvXK28r
	/jGd3YtalhC2A261SInu42F8iYEl4as=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sBI2XXCP;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="T/YTpFdp";
	spf=pass (imf30.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758032019; a=rsa-sha256;
	cv=pass;
	b=WqkrE5XpB8NhDA9iLeHnEM5SBm5P0Emq29c4h4ZciNH9Br6egKTvMvIArVst39kvC6a2EG
	HWH0FecaQgxHxbrL9YlEJoBUHWCsP5c0vhYEkPKLxjOYCdKZKkz1TNQmW5e+OKThFCzZbV
	tYfuF4khDNlwmYs+FSDCRHhCu7/h8lk=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58GCsFdX022032;
	Tue, 16 Sep 2025 14:13:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ruEIYstPei+cg0+sO0ubGZXHFUxCYPzBsVrX0D4uMIs=; b=
	sBI2XXCP2G+iG7ShIUurU75RlOLaqwJtzpUG2VfsbpJ7cDEbfusJYbme/5sNl0dv
	IQdEWAnt0ctnsV2z6GvSp38MwQ5N+sSWo/K/qm2kgjutxFiWef7HAslJ0mVjrnNq
	tVGS9k7gNu1qYk9Zjus+0NKiosW99/Ldu0Q85Ak128DiGbDa6xrK0nkw+hCJqNWe
	F5qdFi2FwGyjcIytGRLOPsKA9lGfv0zBa7ZvZqHuYya3eptgfP4vF5Wy2dZ1lL6D
	eSAUrDF6evn/r7wLuXZINnvG/K0bfJi0wEzqBuduUGecqLRcrRLrNwutQzMces/i
	H1FmIuTWwhAl44BSqFW0sQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494yd8mspw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 14:13:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58GDfijB033734;
	Tue, 16 Sep 2025 14:13:22 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010061.outbound.protection.outlook.com [52.101.46.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ced7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Sep 2025 14:13:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=M7XznNmINTNGuBEhYvvutxhQq1TOc2tszi/7t7K2H0HMxAULnDqBoPdJ3BnS+3vZQIAR1tlIao1wfD29jHELYcmRNdZOZ8dNXHakUzNijIkX0S8wsNpg9VGik9FWhmKmiwAnFd8zDYHUcvgp++Yr3zPK8aqPCoIkTLxVS/wSW9SF0Dc4EGsDbAktseiF20hrBfwPcat0gBCziiJI26w6g3dVsiIzOqyn5W50mti2FrmIwPM4rYw5eauIW6xBsB1wHJZTZRjwdAEDmWdnw+YGSiHrwbyg7+2qymzB56L+70WYCqFUJ+pJ00tmDDdpv8ePxdNlRDmTb3pqjJnJa9gYFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruEIYstPei+cg0+sO0ubGZXHFUxCYPzBsVrX0D4uMIs=;
 b=FU7rXti5n3IWIBC+vR0vB1TE5y+GZ8BI4VDrSDBeeop0CUVMLDnwvMGLPm7es8nNgI8xOg0aF/UxwH4QPvCE3o6EPbKIuMIby3urljju69Fd4xV21RUjFaV9kLGQ0a2TFWPbFSceRFNxeZFS4NpSF3uK1a60mB6DLqEjfo28Ixt7tOD5czCG1P/8wTZla94rxwkeAX65LJqfwHgpgh2INMl8ACVIj+8z95ZvITVyyqfUv2yQThLZ9gSKmgxTdmJ8zL/8Dnh/kXI3ZSpVA/HSvO7lo4v0+hoQ/sOAKIEOK93XNOlcIzd82XxJWoXCcARMWbh4TEKyugK/mdWoCGtk8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruEIYstPei+cg0+sO0ubGZXHFUxCYPzBsVrX0D4uMIs=;
 b=T/YTpFdpZjJPFWiTXVNGoPT9tgWxZBgtwvxP8by9VjuYnAaoRloole2Kfkde/ebnl3kAjbfXvGKUtIPXFpKVwFHBGJyjBvNxCK6GTIijAqgVOb3jb5uN24szAch/qn1BXKIkz7KdN73NAVIfsJuEkTzkYAuPio2d/G5v+Pn/ue8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8108.namprd10.prod.outlook.com (2603:10b6:408:28b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Tue, 16 Sep
 2025 14:12:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.022; Tue, 16 Sep 2025
 14:12:54 +0000
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
Subject: [PATCH v3 07/13] mm: introduce io_remap_pfn_range_[prepare, complete]()
Date: Tue, 16 Sep 2025 15:11:53 +0100
Message-ID: <3d8f72ece78c1b470382b6a1f12eef0eacd4c068.1758031792.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
References: <cover.1758031792.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8108:EE_
X-MS-Office365-Filtering-Correlation-Id: 20420397-30fd-48e0-c6b1-08ddf52b20c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i8nNL/vO0aUYdIfp2jrX9L7DBAaGnRfsTA89ZcNtWClsHuqqfQOF4cpWkQHY?=
 =?us-ascii?Q?M+1ZObW/BTgHyGELBlptCgKz9R2zuNx+rMJo1dujV90jeCWUU9jC6q1UaiMG?=
 =?us-ascii?Q?C8NBdDZHvauYd2XQdd1PTRurNqq6eV6Dwyaspi3QlLS75/PqV+0IHv2rTS2S?=
 =?us-ascii?Q?w2MQtmlBIz0J6VemIRmxT7NslvXtphqj0/0NGtEy8whAM8hRFUftLMP/Qfvr?=
 =?us-ascii?Q?+1S6HxEUve4zJrcvupxD3+3Hck53o5FAvoAdK3CryESz8JetFbUMiSeRJRVt?=
 =?us-ascii?Q?++z47//1OXPZx6LqYY/8vN+sADK84gx4IFAXEKPGtC/W5RjX/UlragLa2ByC?=
 =?us-ascii?Q?EanyX+Ksxz9Qo4PTj6Y9NWKXDIwZcBhns4/ybolr8W4mKxxk/xQGXKZGavEM?=
 =?us-ascii?Q?MTda1tXya63m+keC1fWRuuRXWL1AXAFmvsxPTJQZBY3EjtmEOZtST3G8jiL5?=
 =?us-ascii?Q?2Sx7h0YVaX6FZzuK0ZWzMLBRSiBIOS0wicMUZxbvCJWcdTgYK4qWOtpNhdZN?=
 =?us-ascii?Q?oz5Q0/am25xMFD5/vnNcxcsY043EBbKv9VYm9BJ/bS8WwK1z7+lchfFHB/PG?=
 =?us-ascii?Q?jwTKUBFm9B1s6R4uRBDLUm+Gh3UICYJAns+rzWcWoSInrOa3sCoHyMGe9aLT?=
 =?us-ascii?Q?j3VBvfEvUkEuJV6onHaNKA2pfcXDbKecJSN6aAWzyHoLyzgPKWGHUZgiADrs?=
 =?us-ascii?Q?o4vyAUQosA2cyimY83c4xQL2UZA+0qnrHBoSrO+bVYeKkB/KVk6XastD/uCV?=
 =?us-ascii?Q?YmdWOIyYOHZ9jhZTlfWAulSrJGLY8PZc9Y5ZWFbtQ4XFL8mu0UKx08cWTMps?=
 =?us-ascii?Q?CFxjSCm/yZ5GSxVvqeqRiT4MnlFZ8rFRTwxVnm4ldWzjf5ZvTMiIk/feDgi4?=
 =?us-ascii?Q?8RsOJRsQe9+0R/gRb3g3n/XDZJcvrAbqLUOW+uSXPlKV7o9AwsVo6AnXaUE7?=
 =?us-ascii?Q?6ItqqqrUEOEkY8UiVZaxii0up5tDpk5q2AStUiD5gtaY5ZMFTgsQMCiAN2h4?=
 =?us-ascii?Q?NwTIgT+oj7zDOUvVMK0+w0+IANdZAOWNaLbq3wAjLvZtUo8ATi9yxhG68iPe?=
 =?us-ascii?Q?clAPWvflWZZBNSFuLLhK8lo5YOI1M+dzC5Ob+CEBc+KuYoQGwFsvPpbqVdFb?=
 =?us-ascii?Q?T2p2UX40hcW+Cpv2gZ9VGQh4O4uBqkiyDTBYwci8x/o+24uGbo4ZvM6B+c8S?=
 =?us-ascii?Q?ZJNrN3sxiGjR97QEj7n2YyvF7/Kh+s7rah6d9+H0gS9dtCHBYPqJuNsNudAT?=
 =?us-ascii?Q?Jowb13KG2ZeKermExsNAasvY9h/F6T53GSS1hbTlGnwWGGrYXB+t6Fxvx37n?=
 =?us-ascii?Q?AVT/ixPu3m7LC0HIQnp9VfeVvPbaBWqEuyCiYwSBvrxWaQ1ZeOLqX7KwJhch?=
 =?us-ascii?Q?7tJcwSMJ3fxb0kMM0KINi7mapG/JAaRgNWfPR9tyhIGPetlpxxurIn5A3XYu?=
 =?us-ascii?Q?fDaz/zE2JfU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?67yoQeH51lLBjeyJqiz5SA0Tk5fIrGC8yfeP8fv5QlgfPWioOTeY0CIPAUuV?=
 =?us-ascii?Q?+u4CY5+AGW2QesQnQNc+2hLspH2v6rlUfBBNPR0XyaUK6rEmAz3vwCbHzJxb?=
 =?us-ascii?Q?UzUoi3YVL/Y3JAhikIivpVQl4Yjd/+5Dtv06JH4cG3Rb/bbot4UZpVlQ5Fmi?=
 =?us-ascii?Q?NCld/uW1IGMJuu9kNHTd3J0essc7EfZ+QhbA5Vb6ih1gVaM0+yxSjq9zpRQ/?=
 =?us-ascii?Q?lKLTvyby9ldgUXrBiFJzqcpEV1uEEkFXiDESaDoCRBuF+M4Ex8ZHIYbO0wfv?=
 =?us-ascii?Q?bCVq0oedvAegCl8XE+TvMHrxfJuU7N77eq28Xp7FRqBIzAty/7+zOik/FHte?=
 =?us-ascii?Q?4I73GjNrIesxt7vpGu85B+YjB+q22E2MVJzhrGHahQJCcgXK43OYtrYiml5A?=
 =?us-ascii?Q?pjDf4h+6Ym4Nf4fbOcpgQKWb7B61MNpM23JqN5pLY5H86oMDGv5tfsAtGzTH?=
 =?us-ascii?Q?yT8LuA5RAsR8AhQdMhpPKA91Afdbu2jsRL6iTum9v0P0430PRx75SYX9h0wv?=
 =?us-ascii?Q?wyKQHjCKyAY7s92SQYdqrlYj145rmCHMpojEEnYLFktPVL1jFh81L4/tl4OT?=
 =?us-ascii?Q?nDWMIWASZsk8drIKSeqDTZUMf12q686U4U4T/n5rDy+Ii+oVCypbTKyS3DiK?=
 =?us-ascii?Q?6ZUquLL90lNDiBKMXnyPm/O1ofSOnyLFsEfFsuHiYIGywFPR9kWl8wnJmcma?=
 =?us-ascii?Q?ea518OaQ+AViRRArQ+1hPnoh0Nl84TqaHbJOEtgQyUtwMl2Yi3ZiKRS7Wb/W?=
 =?us-ascii?Q?+KwUORbTpuGW3QGYYyJVfz1Rhiaz0jCNC3ByNpeQji6CFAow1+sYEiKtCGzt?=
 =?us-ascii?Q?bIsbzWvCof+kDbde3zaiCJQt7PwxSuM4UUrfJ0o/qlBnY6v1Hi3vdMTrqv43?=
 =?us-ascii?Q?sOATmx9v6WFRNv8cwnKvAMNcuP48BshnVwNk5LiofJ/cAN/Om6jVZABYw/ic?=
 =?us-ascii?Q?etAiPjuGFzACg7NiFlu1xDp8Qe1JM/Z4zwqQbLnXWrXB1ZLfTATOd4NXD5ou?=
 =?us-ascii?Q?sgY27oXPo5c6c+sbVjp5IzTxBS0ZA6mgr8QtJIks1luGNdIT83h27ZJy4wAV?=
 =?us-ascii?Q?RoAnLd8g96MwR9InIGgTKKo2T/ZDkC5BY704mbnubeEc60fX6UmXask1e49X?=
 =?us-ascii?Q?hr9nK6OuQ66lASDgwuRk06So5i89PopnZnUEiK72cx9xvfkEiSC/eSoUrIDD?=
 =?us-ascii?Q?fmzBin2yzTQTV3uVDloG6XaV+y8wWeJ85nNEy9M/BrYttOeX3GMmjAQGQvH7?=
 =?us-ascii?Q?gO9Tf3wmYKsixZgOO8mrbjBDmaWM6PrNnP19MSiOtfvyDqKQQsVaoIf6fYMK?=
 =?us-ascii?Q?Gn0WAjNT5FxsiN9ulPyuwLZyVaIdst9ypMsvZHgm/QneBOpz8Fd8iqdsCt3X?=
 =?us-ascii?Q?FCln+6CVjx2gPh/7o2Yz3KR9dabDFRSbQXOA6eoyCI4XtJbmWX/3Acr7PXCg?=
 =?us-ascii?Q?iIkOCBNLrZzY5zqopdsqyq4OLqRsvdanRXu1ci2mbcLjjk4C0FmGH0z4tHSD?=
 =?us-ascii?Q?WrBDVPW2Nes9tIKC0Nw6DuqBRRrQqd1SovH7O8QTgaYpoD48RnaN8NrgUcLl?=
 =?us-ascii?Q?dTLYCkgt/eozzxKVmBoAzeKxlKN5/hE7CjuXfMbrbgqeK4Hg15W7CWOKS3qy?=
 =?us-ascii?Q?gA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	d8ZWaeQPqAgkHUPptWYhcq9PecT7AEbM5dRT1VFpvWKvGMgu4Ez16uLHbnYYBOJVBjPP1zlKu6VCW6lcbD81lcq3H6v9SiAG5r03HReoF/Xe+tdWijmr4yHERW8KuD64FWBvzAf9W7RvmC0C0+Pt1Inu6NVTq7sANkXaS5lUQx51H99S1t9eDGLZgQ57hJbEHxCVpqKLOb4DUj7jnqT8ymYrqzXjhTcKvrcvUzO3Nyh1RKh+4+NXQl0L3iF1tthy0djvA22f7Re55rRbvqGtUQnjB8hVkgoArMfa8FntxwfYA/yaMF9ETSUSGWFRA7ye1HdtLskwP++4xaMKeZHAdD8cv2FNWVRzNUq7psfjPzord9pFsPWlsuoe5jdobyfy4IUaVzsUVRipNvUbNZHKJwECkNmdq+zPiB3mNcc+2gcvwLO9qwErx8jklkdZj0FD7gyTcFJFyA4K699uzZB4vzYeA08/boI51fHPZRxfz5sReK6PZ0VDyCztCNKXmjFbzbi9/WbozB5Y1Q3VpPt6+5U0RTPxOqvKBk3VBxprbLLjUCPg+OXyXabmFXuAZL0iwux5sIJlhTgQKwADT3s/dDyCXrLVhpsrloJqeyaVDQE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20420397-30fd-48e0-c6b1-08ddf52b20c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2025 14:12:54.0495
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P1P56Bmoz5k82Wsbxlv3an2bonbtbDRAsCNCIZLsjtDTgct4kiqldYPRcr90AuZKW1xG6mKZOuN5eFwBqHv29/eMGo8Uo9/PcLKtv2+8AvE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8108
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-16_02,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509160132
X-Proofpoint-GUID: j7ZIjWRyjzm3drZeg1PaROASAFiPCR5W
X-Authority-Analysis: v=2.4 cv=M5RNKzws c=1 sm=1 tr=0 ts=68c97083 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=4wz7WGFsSwjB45XCXqQA:9
X-Proofpoint-ORIG-GUID: j7ZIjWRyjzm3drZeg1PaROASAFiPCR5W
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxNiBTYWx0ZWRfXyjiV+xIjTAtC
 9e7AEoGLFZyx5MORz5hhGBmTlVGUaM9/ZZHs0FntvazrHC0xUB2CFQRtQycHp+/xC3eHdQf6Zqr
 6wcaH3PztpKAxyjEf5wTNdEF/+6R/e3abvkO2rx+9qEEGgLTUtr/iYNgLB+Gh1SPxjdKKwNtGMa
 /3ce7UfsjOtiZtcE48ou3+BkwWGoEobLdkNp1oAgCsvBZmX81SkPM7/iamcWpMIkgVcy/IYKAAj
 10RIueCQA2EJ3CHqPpOFIjpxNkspnRyuQJVDJkiYs4fWGVwFKxNneElJYrqjbS+UCtrC43f0lca
 ztiuj/8qCg7Dl75m9xnM3wSwRR2KiwUk1SoXAdCmOG2KC6KeprMbUJOcEvJecAMDbvSJt127dZ8
 /XGDxHoD
X-Rspamd-Queue-Id: 43CD480017
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 8emteyy11xwdxtxa5dzxezrhwizpdtjw
X-HE-Tag: 1758032019-676937
X-HE-Meta: U2FsdGVkX1/l4V5HlMMtiCuZ+D4ki+FN2DlFAaesgX2WdBd0WGGyIGUos27fsasTNqz95TlxWaC7RXqa2n9YpZ1ZQxddM6Zf2I+gMv0SpBUJHww2+4eg7uiRP7I0eD4lFpmIdgK1gbBNiXv1uwONGRCuHwLh8OyNvhlQvl/DY6cxcoy4mhaBpcUnkqRDDZgsmJA0HX4kxzxJt3VfuouzwzkAi7f1xvUhX0yfE371R9XlCWGCbzmxuV/kPb8KYr2mMy0fKTF+uuOdbxC9B4cJcnyx3cQ5RDa5dGg/aQhSzzYegt+sSoinhM0pCku7YPso6ZhmnAIeXLwR02zmbCnvqwxxJ6Azglu+k5lQrozsgti01x8p9fz8Aj0bATGz6FdZ2b1Ln2U5dsA90r+JwIKWplPQXRVMIobTdfQspsx8/+JaapabsMdd/gPm08JmkXPT7SYWEx+F7nhtjTK0ocISCzkNzmkflaR58v3rUmTG6czHDw+3KDZ17cLpugX2yPwiUo3a3eflwYvOa23E0aHatZJ3u82LDamC8fvXS0sE58TPEr56x1N+lCmWInvHggpVcpeq8UXfeiFqlslRxGGotyulNOzTekH787zXtZqkqJ2sqXwf8QzVAv/gMmJIBmyzR2zmidnw+1XLro7Jf7xS/oDpUk3i91yFlDT6gd/RPIyI0khSxiFB5YGiLmRMJBCc83Ry68beVPIzO8tbawVZWsV+r6qtrtl3dQw8G65VkfIARzW2LVKtt5tUanRp0zLfBI/gD2ubKQj0R82d5bQpin2N4kSqt0r6xBVmtjqBNVuHab2IBmSsScFblI0fUFbTce4ZpwSLsgHx2TN26DJHZ4ujzndi3HJi6oWXrLfIv9MAhfGiJn8/KPaRGPx+G8wwfM/u7BkLndHMcOsOBBOr62YY8p/yKFH7pEnzjzo6jUo8TQImmgTSIH8RREidtlTL6VGFKXp7E1MFto2BIfh
 D87hEv6P
 +u0ZrnFfa/aWlDj5oPPNe+G5/DgiPqDckNdN5fwei9TWhYxnS59Tz+j0YJUgIohXgCviRo5G45o+U+NYCMvrj+8l/Sgu+DSf8DLvE5DV+CzzmKVPAm7R9P/H+onJiNRkG4OGJCnSM9DF7wkEQuxOvY0IiE6tjb4k2QQYQLHEoS2TqTO6pEt6iqvU1yAf3IwBef/eshtNU1VHMlCW2ZAX+Pw0uBRBW+wVjNlh7VWxhuyLpEESP4Ob6iZ7h/FI60dw1fkL63Z2YCKPBHxxsYvniVQr3xrgG8qJQuCvR+F3IkS+RS1VwvkbbbGjlAEij+rx4ePH1HF3SNemHX7+GCzZQMbnfCFG9Ah3DpjsQxcMP2OMIybzdRQUuhUvzaFMoCtTcN+DmBMTbj3fHDnmO89U5HNxeW/vRrFYJy4O7sJBk41Y8bYo+5IXVnJ05Zd0nirk9CV0UOPw7GrA9JhpWI2btPXx8fPAmpMV0nriEyprS443ro3whDGX8LhOqiZH85h7OugmFEswFI7PyTC10FMXhcAZWHBbGgsNSfIQzFahmOyoY/8jkGs13dle0B/kf9Plyn3OG+tyYnV0Gfe5+IH/zygIXz44WRTJZ3MaVjLp0jy8jw7I2LDiZZ915P9G77W0lp9SMP8wS7/do4q+rxaULnryq6HVebZOdPwt9rZ6NVAO5Gq7RdcAUga1G4kQl1Y4eorKRZJg8HA1BbkWzbwiiYUWcBjppBQy7z9BNbdSnheIlsov1O2vXnw0slSaiO4da/ghNVKMO/ij5yqjYH88p01jRE23wzKp8rT1OBAAroNTliWMWpREz0ftmA8Yd6QOWwsUgHbMAOgYcbqtEeMnz8sJwLqni6GCFopd0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We introduce the io_remap*() equivalents of remap_pfn_range_prepare() and
remap_pfn_range_complete() to allow for I/O remapping via mmap_prepare.

We have to make some architecture-specific changes for those architectures
which define customised handlers.

It doesn't really make sense to make this internal-only as arches specify
their version of these functions so we declare these in mm.h.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 arch/csky/include/asm/pgtable.h     |  5 +++++
 arch/mips/alchemy/common/setup.c    | 28 ++++++++++++++++++++++---
 arch/mips/include/asm/pgtable.h     | 10 +++++++++
 arch/sparc/include/asm/pgtable_32.h | 32 +++++++++++++++++++++++++----
 arch/sparc/include/asm/pgtable_64.h | 32 +++++++++++++++++++++++++----
 include/linux/mm.h                  | 18 ++++++++++++++++
 6 files changed, 114 insertions(+), 11 deletions(-)

diff --git a/arch/csky/include/asm/pgtable.h b/arch/csky/include/asm/pgtable.h
index 5a394be09c35..c83505839a06 100644
--- a/arch/csky/include/asm/pgtable.h
+++ b/arch/csky/include/asm/pgtable.h
@@ -266,4 +266,9 @@ void update_mmu_cache_range(struct vm_fault *vmf, struct vm_area_struct *vma,
 #define io_remap_pfn_range(vma, vaddr, pfn, size, prot) \
 	remap_pfn_range(vma, vaddr, pfn, size, prot)
 
+/* default io_remap_pfn_range_prepare can be used. */
+
+#define io_remap_pfn_range_complete(vma, addr, pfn, size, prot) \
+	remap_pfn_range_complete(vma, addr, pfn, size, prot)
+
 #endif /* __ASM_CSKY_PGTABLE_H */
diff --git a/arch/mips/alchemy/common/setup.c b/arch/mips/alchemy/common/setup.c
index a7a6d31a7a41..a4ab02776994 100644
--- a/arch/mips/alchemy/common/setup.c
+++ b/arch/mips/alchemy/common/setup.c
@@ -94,12 +94,34 @@ phys_addr_t fixup_bigphys_addr(phys_addr_t phys_addr, phys_addr_t size)
 	return phys_addr;
 }
 
-int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
-		unsigned long pfn, unsigned long size, pgprot_t prot)
+static unsigned long calc_pfn(unsigned long pfn, unsigned long size)
 {
 	phys_addr_t phys_addr = fixup_bigphys_addr(pfn << PAGE_SHIFT, size);
 
-	return remap_pfn_range(vma, vaddr, phys_addr >> PAGE_SHIFT, size, prot);
+	return phys_addr >> PAGE_SHIFT;
+}
+
+int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
+		unsigned long pfn, unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, vaddr, calc_pfn(pfn, size), size, prot);
 }
 EXPORT_SYMBOL(io_remap_pfn_range);
+
+void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+			       unsigned long size)
+{
+	remap_pfn_range_prepare(desc, calc_pfn(pfn, size));
+}
+EXPORT_SYMBOL(io_remap_pfn_range_prepare);
+
+int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, calc_pfn(pfn, size),
+			size, prot);
+}
+EXPORT_SYMBOL(io_remap_pfn_range_complete);
+
 #endif /* CONFIG_MIPS_FIXUP_BIGPHYS_ADDR */
diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
index ae73ecf4c41a..6a8964f55a31 100644
--- a/arch/mips/include/asm/pgtable.h
+++ b/arch/mips/include/asm/pgtable.h
@@ -607,6 +607,16 @@ phys_addr_t fixup_bigphys_addr(phys_addr_t addr, phys_addr_t size);
 int io_remap_pfn_range(struct vm_area_struct *vma, unsigned long vaddr,
 		unsigned long pfn, unsigned long size, pgprot_t prot);
 #define io_remap_pfn_range io_remap_pfn_range
+
+void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+		unsigned long size);
+#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
+
+int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot);
+#define io_remap_pfn_range_complete io_remap_pfn_range_complete
+
 #else
 #define fixup_bigphys_addr(addr, size)	(addr)
 #endif /* CONFIG_MIPS_FIXUP_BIGPHYS_ADDR */
diff --git a/arch/sparc/include/asm/pgtable_32.h b/arch/sparc/include/asm/pgtable_32.h
index 7c199c003ffe..30749c5ffe95 100644
--- a/arch/sparc/include/asm/pgtable_32.h
+++ b/arch/sparc/include/asm/pgtable_32.h
@@ -397,10 +397,11 @@ __get_iospace (unsigned long addr)
 
 int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
 		    unsigned long, pgprot_t);
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t pgprot);
 
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long from, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+static inline unsigned long calc_io_remap_pfn(unsigned long pfn)
 {
 	unsigned long long offset, space, phys_base;
 
@@ -408,10 +409,33 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 	space = GET_IOSPACE(pfn);
 	phys_base = offset | (space << 32ULL);
 
-	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
+	return phys_base >> PAGE_SHIFT;
+}
+
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long from, unsigned long pfn,
+				     unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, calc_io_remap_pfn(pfn), size, prot);
 }
 #define io_remap_pfn_range io_remap_pfn_range
 
+static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+		unsigned long size)
+{
+	remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
+}
+#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
+
+static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
+			size, prot);
+}
+#define io_remap_pfn_range_complete io_remap_pfn_range_complete
+
 #define __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
 #define ptep_set_access_flags(__vma, __address, __ptep, __entry, __dirty) \
 ({									  \
diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 669cd02469a1..b06f55915653 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -1050,6 +1050,9 @@ int page_in_phys_avail(unsigned long paddr);
 
 int remap_pfn_range(struct vm_area_struct *, unsigned long, unsigned long,
 		    unsigned long, pgprot_t);
+void remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn);
+int remap_pfn_range_complete(struct vm_area_struct *vma, unsigned long addr,
+		unsigned long pfn, unsigned long size, pgprot_t pgprot);
 
 void adi_restore_tags(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pte_t pte);
@@ -1084,9 +1087,7 @@ static inline int arch_unmap_one(struct mm_struct *mm,
 	return 0;
 }
 
-static inline int io_remap_pfn_range(struct vm_area_struct *vma,
-				     unsigned long from, unsigned long pfn,
-				     unsigned long size, pgprot_t prot)
+static inline unsigned long calc_io_remap_pfn(unsigned long pfn)
 {
 	unsigned long offset = GET_PFN(pfn) << PAGE_SHIFT;
 	int space = GET_IOSPACE(pfn);
@@ -1094,10 +1095,33 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 
 	phys_base = offset | (((unsigned long) space) << 32UL);
 
-	return remap_pfn_range(vma, from, phys_base >> PAGE_SHIFT, size, prot);
+	return phys_base >> PAGE_SHIFT;
+}
+
+static inline int io_remap_pfn_range(struct vm_area_struct *vma,
+				     unsigned long from, unsigned long pfn,
+				     unsigned long size, pgprot_t prot)
+{
+	return remap_pfn_range(vma, from, calc_io_remap_pfn(pfn), size, prot);
 }
 #define io_remap_pfn_range io_remap_pfn_range
 
+static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+	unsigned long size)
+{
+	return remap_pfn_range_prepare(desc, calc_io_remap_pfn(pfn));
+}
+#define io_remap_pfn_range_prepare io_remap_pfn_range_prepare
+
+static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, calc_io_remap_pfn(pfn),
+					size, prot);
+}
+#define io_remap_pfn_range_complete io_remap_pfn_range_complete
+
 static inline unsigned long __untagged_addr(unsigned long start)
 {
 	if (adi_capable()) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 3277e035006d..6d4cc7cdf1e1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3684,6 +3684,24 @@ static inline int io_remap_pfn_range(struct vm_area_struct *vma,
 }
 #endif
 
+#ifndef io_remap_pfn_range_prepare
+static inline void io_remap_pfn_range_prepare(struct vm_area_desc *desc, unsigned long pfn,
+	unsigned long size)
+{
+	return remap_pfn_range_prepare(desc, pfn);
+}
+#endif
+
+#ifndef io_remap_pfn_range_complete
+static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t prot)
+{
+	return remap_pfn_range_complete(vma, addr, pfn, size,
+			pgprot_decrypted(prot));
+}
+#endif
+
 static inline vm_fault_t vmf_error(int err)
 {
 	if (err == -ENOMEM)
-- 
2.51.0


