Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DE07CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4BA8E0014; Mon,  8 Sep 2025 10:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86A688E0007; Mon,  8 Sep 2025 10:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6988E0014; Mon,  8 Sep 2025 10:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FA5C8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:49:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EC25F138D15
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:49:02 +0000 (UTC)
X-FDA: 83866365324.23.E2186D9
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9A05F1C0018
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:48:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k1h3rMXQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m8DDC320;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757342939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vi+YPQQ3V6pIk1jpndNU9wG98+7ZZeptTmVNK2n7QCA=;
	b=6jtgTwGWjZVr0qXWlNIiQoBqV+5D/N55Wer5cyaWQn8BP/Xf44vS0sF88hYEisyYckZtj7
	fUwmoDd3/HydfTEhIDhVEdyp/k3nSUPrS+Ua94PRaio6ar+imyAvpd8POCIax+aIrozMuf
	zCdlqj1EoBWOhIUzNRVqNBxd2KYT9g0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757342939; a=rsa-sha256;
	cv=pass;
	b=O9BExbLV71F7OR02fijAQ+sjMoePW5z3WmyoApIcZVBLsLyIfk5Fd9ha2k7bEXWYeKC83K
	QBK+TUwRpb8jVfXaV6FTvajvW7grriDrsSJfjQVbCGpcWBlRcEtZb1V+MOEZt9RpUeg5aj
	bzpPwRuzfiTUApzKO/bP0M2s78bTj9g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=k1h3rMXQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=m8DDC320;
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 588EA8cV018664;
	Mon, 8 Sep 2025 14:48:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=vi+YPQQ3V6pIk1jpnd
	NU9wG98+7ZZeptTmVNK2n7QCA=; b=k1h3rMXQ1zbMf2d4E3qsfgtnafTVrN9dL5
	VtWXgTHcVEaaqKI22QGSzOaReDeCC6kbJgUv/Chi7vDTYBTheKGQ/KFH/AhBE5Py
	jJWu6Vk1WapTipGwOzf6Cf58x3CGC4dWb+6MdO4V7FFtTK3gqCKOeqK+eIjVqbH+
	DoAg23cB/t5fGY1fY3zfc8Ss/LFlpQwEww+ROW9wRY85vhjtyqmRHMtUuzutEdk/
	uE32xHa+Tn3QYGw0vR2DfzD7dcHNsXATNXOOSpnsXVMJsmwIPOXoyV2dVEcyMz+0
	pkmkdfWxcESBS4urH/ClFkAnz92M5sjlA7RNau4HBtwlwJjCkXcA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4920npr334-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 14:48:42 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 588Eaa1f025946;
	Mon, 8 Sep 2025 14:48:41 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010006.outbound.protection.outlook.com [52.101.193.6])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd8a4xs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 08 Sep 2025 14:48:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ty6W8WoNI6Q1ezn7Ih3mDfQL5Um0qDy7LpXwsWdKEgEhhFj6VTQLwkyMvxTsEZPND0al/bdDXSuKLjMaXAhLqzKNM1zrL+wxHFf+7Rh58TkHYIZ+hku0oCGBr3TN+wiuhQBbFpX5T7+UqQp7TCEQYOb55SXcJPL8f1IhKpndDCub4jc/2VZuEjl4GLwzo7ifGWJbiFhIqQ7EWNqmNFNIO911+NzVJ1t25wgeNOLws1MVrrD0wdET5R9fFaUtk6tkbaqJJ67melIT2kSq4i/NKN6S1wN+ru/C4Hm2fJ+/BtLeQNUX5CFkvgquNlqCazI8qvKzzJ9pEbMQoIVHg2QT+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vi+YPQQ3V6pIk1jpndNU9wG98+7ZZeptTmVNK2n7QCA=;
 b=Dhy3gKrsL9XEHXXVr+puIL4RDP7swYSv7nTFqwp+dCrjWUVWOKVKF8cdN9caBDSkIOrsy2Q1r7VCL7YunjTdMiukdCLUg0JXzWDNtyg7gM2+R2Pu3FKnaFqA53UjxLbhQWnc1fJVujp1zRFI6VV1d8Afay0u5imQBIcROF6RiBGVdiD/p3FxWg0qfHmFOxcPgxcFmDIQ2B5torLEO3exVpebzAhvW6vCMiNMyFIOLUqnFvQk8qLRqT1ZU/J7UpM6kuMTkxlP5wnFXI87kVCCM/Xpzm/o30x2D7Zo/gfJxEePLo+wKyrqyvYpKsXpgXwig54bQmkssL+qSryA45f7tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vi+YPQQ3V6pIk1jpndNU9wG98+7ZZeptTmVNK2n7QCA=;
 b=m8DDC3208FRm2riRaD3COpgrOkp2S76qi/koGy7p8TQTnSIMtFK2tIcI1rJmwT1I4o74f7MdwDcfWJDpoHVqW1ful4TRYOD+PP4uaIXfTk4JcJsn3E2wigYWdVPBCyCloqALU97jSnJCzXTyewoiBtXuqpRo50NWJCQ1qcuZfi8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY5PR10MB6216.namprd10.prod.outlook.com (2603:10b6:930:43::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Mon, 8 Sep
 2025 14:48:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Mon, 8 Sep 2025
 14:48:38 +0000
Date: Mon, 8 Sep 2025 15:48:36 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>,
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
        Christian Brauner <brauner@kernel.org>,
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
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH 00/16] expand mmap_prepare functionality, port more users
Message-ID: <9b463af0-3f29-4816-bd5d-caa282b1a9cd@lucifer.local>
References: <cover.1757329751.git.lorenzo.stoakes@oracle.com>
 <tyoifr2ym3pzx4nwqhdwap57us3msusbsmql7do4pim5ku7qtm@wjyvh5bs633s>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tyoifr2ym3pzx4nwqhdwap57us3msusbsmql7do4pim5ku7qtm@wjyvh5bs633s>
X-ClientProxiedBy: LO6P123CA0005.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:338::10) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY5PR10MB6216:EE_
X-MS-Office365-Filtering-Correlation-Id: c868d885-dac2-4b16-8a88-08ddeee6cb5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?4PEU/CENvhJ71MatBeSbjMa3W+c8BXEv8sq5juZ1PEB749mD2KotK+RfAoFm?=
 =?us-ascii?Q?tBsnKtGmT//n4XHxYa/JUT2mEbOLmEHx2b7cZm7VtqsOTMM0lOVJXfjKL5St?=
 =?us-ascii?Q?6c+/EvHUeAQ71yDwk9LHmMU7b/OlzLfyov/q+6oyRnxus3rgczBzkypi4zHY?=
 =?us-ascii?Q?O3K1wkex4J54+LkOi2OcBr6ySGCWZYZuTpzhLH56d36QEtZez23S5d7B8RZz?=
 =?us-ascii?Q?A4UtKGFqmRbmGyvofL54s7TBurjsGUVU189WL1jfcuFTd0AXIjN7l8676kfA?=
 =?us-ascii?Q?Mi6FLgNswghnY8mghFkr9des8oJpQdHZDFIcFdS/ISIe4hDDpidoWsMM5+4z?=
 =?us-ascii?Q?BDtaCojcGvwQco6db6T1k14txlGmVW9IGhOQFhd4T1Yc9fUxPHbPW3t4j4Xr?=
 =?us-ascii?Q?ZAHrFo3Al05IVMDzjsX5e+JOa+LiecNQfSp9Mg9JFuWCDPgkYH9RlwMbDdAp?=
 =?us-ascii?Q?h2xAXEZPOnPQpBpkcAAR+1Sc+pgdnrZV9OgCFGYPcF/jV8yeYNAUFwhJNpyW?=
 =?us-ascii?Q?emkjwFqxnQqpXM8nkBg3lG/YemD+bwtLuoLEz3GclGOHoLdjlbayLwUIQeAh?=
 =?us-ascii?Q?FAeYng9PgOWMTAUAIxoIr8sAI2/++RrRc2tLUY0+Z5vQPZXkekcz4Pe0ojam?=
 =?us-ascii?Q?5LI/Kli4MpljfXUT/l9LL97+fOLPnceJGLgr9W1eO20rPktbGhxoA8x/F6vy?=
 =?us-ascii?Q?wpBnng+1uQW27pzA3Pa+WX7I1mPMFgtKAAzMQpvjTJp2+yQPFdamNdvNGKhM?=
 =?us-ascii?Q?i0EM8jG2ahWIeREks0/5hAEux09gXI3hvlgae69iT7ivCdh9pR4CLMjPzCqx?=
 =?us-ascii?Q?XaG9KEtcdKpYeopRL8O1AJ2xeHoefOGJcbNlr4v3SqNuv0/D2CpY0480bzow?=
 =?us-ascii?Q?iolKRXjCCY6sUSuwy+5v1xvIjbxqsVtYrMVixdQBZowlN0NeJsZiafqP/2Li?=
 =?us-ascii?Q?Dh94PW20VIoI7UcNhd/aT80HLNpZVf0IdTwsV8u8yPp4/TJH+k2JIByrr7xw?=
 =?us-ascii?Q?gG1ygIMed5u2pzCURWv+sN2nMQPW8RxP4Ro+yX9QnxZtSazUW5PgWjBdfidh?=
 =?us-ascii?Q?FEaa6XUVRCFBkoRmcHRCHaF4v6Szd1vEi++31/C1tVURacE/Ni5/A/0O54b3?=
 =?us-ascii?Q?41ERqJilGAU/Lsjff06O55oZM2rlPi7ixl3VkFeGaClptgu96wnbggj+m1M9?=
 =?us-ascii?Q?jSzfsV7KlSpwXmmxVkrkgxh/xJ+7d6w1KdV7CKeniTTV3dFBzGK0ns7zNzyc?=
 =?us-ascii?Q?4iPbXvWgEsRrC2pZ8LCmT3q3X0pDw9Lzj9U3fCX9uaQji39QAW/eMqQtX9Zt?=
 =?us-ascii?Q?1++0nI1GRknprN/WLRYvUL5rXHNOQzFNnVP6wKpDQdDPScAMtkvQ3xmiPHQq?=
 =?us-ascii?Q?/nYA6l9n29Zbp2YvNveXyOAzDGIIJZ0i6YYyVTImOpXMnyXQOyIgeGK7IIMi?=
 =?us-ascii?Q?nZsJso6VIqc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HHxZqHm5CAFGOhGxVEK8a6Vg0V/ZWIABNPhrzuXf82VS7a7BK7/HKlrEm38u?=
 =?us-ascii?Q?p3dgzp+SDQcon7WfLQxKcvwzZnR+mA/ZiMDHGu3kDHnRHjBWDdW2w2uwuyzo?=
 =?us-ascii?Q?RaqUl5WAGcU6vWwPCbqehDyF4LF36h6M+N1QDS0G3TypzpgRlLELP5vbPVVC?=
 =?us-ascii?Q?wG+aT1OWHM+9iUpYJnkV2yd8RblW03kYZLxHNMr5zZaMhX+kddsGKk/Vh3SI?=
 =?us-ascii?Q?7sOO85Z9k0h4EDMZRxrsyOSr+KY04zTHmqryrE7qxsyCH74vFwHrVEcj7dzT?=
 =?us-ascii?Q?WE3/O3GPzd/BCHrKj0Ws2QOJVYEGbcnF/r2E/BH+XsR7O7ju2AIGJaKas1Jt?=
 =?us-ascii?Q?/tt+Wo9kAAOckxsAcLMVgeCOsVIeXN/9dwAsIjJmnX09Jfj5Ra3j8dORrXhv?=
 =?us-ascii?Q?FX8ye24zujqisamIw1Wp6v1iKY64qdhSibiX2mPF0Fldm8/jGZfrpIiXnIlB?=
 =?us-ascii?Q?Yka+g8hg6Pa3amZhtObjNxRY6DRAl7RcK9vylIqK41aFVbk3tu3qjMtao4W8?=
 =?us-ascii?Q?VZi1og5Sef1DK0UnQXYLGVZUkAkaSyXav9gMlg+sUXOq6RmOdCJOdYd/HILZ?=
 =?us-ascii?Q?PdR2ticUjpO2u4v/CJ0x8DSGIXOUYr4YyryvJgqPtOdvTX5TVgRYgVC9S/PB?=
 =?us-ascii?Q?6KHKTQbP5feZOKgFpDd9IP2ynDu08D29vuH65WOOexI9vmOYOvzde21MX4x1?=
 =?us-ascii?Q?vfqNArUP9RPFNo8A82VOBNIrec1bR1VEdwnUWfTT3jUqzt9JtmIA/XBIbKhQ?=
 =?us-ascii?Q?xjhCW1XjDexDmtlETjFiM6FKcyMiFAOh9Ig6JMp8niPYoDeDOG8L8IIZzadQ?=
 =?us-ascii?Q?zBwHPHOxKFf+r/SRJv/xXwGnav+WgfRf30FvQHrq5qhq61v+Gd6Z239kXYuZ?=
 =?us-ascii?Q?3yp3B2MHAvLhduViJrL3LDZ51dwpP409konn6sg3omzj7qMRafhN7bSsfoYn?=
 =?us-ascii?Q?P5t2mxFOjECtJJtvK3SoAP96d37RxwSjMWeBQT0ovfm9fmSn8j0CNir0k9lm?=
 =?us-ascii?Q?e81f6nREpDg98dgm1Ez97XAKiyWFLcw/SZNMpKXDnmHD/SPZHss+h+ISR6Vj?=
 =?us-ascii?Q?shVV7nJtMKcDadU5456rAGQtquBmMM2eOaNsTUwyoh/ng+5ANK9jn7M1TeRz?=
 =?us-ascii?Q?sLVB5aTKxau9RMeHLGr7GX3tVzts4m4/L+Di9WaTYExQaX142GrHgyOxnX1P?=
 =?us-ascii?Q?2n0ebdRtW0uMlabE4OLWaEeAdIHv8AUPE3WZ801J8kW8bOe/A3iwJLZLPdiw?=
 =?us-ascii?Q?ePgw0i8m0fmYOBpo5glpivym9Ec4fZJK3Gof+DqDhjEvHNrAJkn7pFp2lu6O?=
 =?us-ascii?Q?BL86t4H5yJDO/9dzCR2JuBJP+AacYh768dROP+aJlPhSmfl7BiDGmbTGrnh6?=
 =?us-ascii?Q?bCmld5xA4bInk/qkHCBOeLHXmSxaA+u0g0BvLzIBHQuxaxoafl+5lDw/rApP?=
 =?us-ascii?Q?OE+W7MLbCxjjTjB3vVwwmsqtteygRkJaFdrjmgPPG8jhlCfLIb5RBmR4ZkKI?=
 =?us-ascii?Q?gG8DwY/2lDafNaAAyuEhL2Y5HLWwWhRxequauV402DOG8OTPCK+6p5Fth/HL?=
 =?us-ascii?Q?PrZBygE0diB1xgydDtHuAiAwq4Zx4Tv1BuOyrkHM55yFJUW6G+sGqSGrCXZE?=
 =?us-ascii?Q?tQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8Ev5UQ6nUj5AeICWoFs6q6h5zCIvEASv5Fd7hwWVTSUMFZMpdIwSL71PfLAVLTgbPnuZumWbfiluJpL+rwOKu1dxf3IlT/LLiWt2iaWBDgJI8blrjkcqWA+W1y5/pwhDiOhXxnQYyParWGYeklOv6qpGdTe5OJptfbDjEZzK4qCeScrtDxfwC245T20+gBEP1ks7ZgYKwQ0ee4zXLiVdPhflM/y2oiKCPsEkKzKGW6PQzCqwp+4dZigQd/0zSr46qUyKCJ3pDn08jPINrlEXIVZG6N/wRTCXJ2CHCB47Rvnt72vNZ9PTznR1iNQk83Ja5/Fe6tOOAllPUAMIiCVu3Iiar+NJo0RHOoejNj7q0sTgt5A8hZ5uo+69hp5b/xXJEFgNH7/c3y049i7jU91cxNFaWesa41WAGjmCoC8hra3pKpi8UPaH/hl9WZzkj0A/lVyuMev4UQelEuQ8rTjS6J/+9uuv44H7cnSddgjp2p+rhk6GhNYlZOHGxquOqogOSR+m+KlkTBLvXMIO++Wx6Zfw5UAfjNR5IaI4E/Tb4gR6oGWsqLIKrB7FVICdiyntsiudchVKGZ7GvYHceO4LPAEmvFut4d3bzkNUZ3WubjA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c868d885-dac2-4b16-8a88-08ddeee6cb5e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2025 14:48:38.0014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FIQt1GE5Gm+EiKIdUuhI5ptJ+s0NWPKUjKp/w96+kgBBDmso0vRApncw7tygbJKIDTSONAEgDADWAv+9PyG2sK6wHiaGgtaUzCd0zie84HU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB6216
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_05,2025-09-08_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509080148
X-Proofpoint-GUID: 9-FMBLohZseJ5P9vfcW4ITjcZimWiPi6
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE0MiBTYWx0ZWRfX+CvuVB05mEic
 mEXd+kD/tKMKwz82PNbxHNPs+Hmj+v0nxAz0KYKLWgY7GS8kNrD5+/xj64Ln0DZZri5c8NmwVoS
 VNXJa5IteZy62se9dUnl2tnUKWU/ZIzlFhDrm5enYos8r3oIWQclt7L3E3wFTBye/tCuOc7cDSm
 pnEOHRGMrcPhEBTfbeDS6z6pnP6vknCCWzgeNjwfMf08kIPuuFyHMWGDqdUyxdCA5t9RgwhcRg2
 n3GTCoswJHw+U2muvP/+HsS8TwvzjaxB4TknhvUVqo/sSMKALuOsqo9+lY20siHnHp/DYKpM/Eh
 A2ZCviyem1S3imC/6YZz+S8WVyXrWa3XstoKxphd1jldwd+X289yq5IIT4uGsdf7l/DtxNFACpH
 cZCjf4CbafwAj/LuaOek4ejJi/wKBw==
X-Authority-Analysis: v=2.4 cv=R9QDGcRX c=1 sm=1 tr=0 ts=68beecca b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=O5qt-UPVOMkWAtKYl4MA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: 9-FMBLohZseJ5P9vfcW4ITjcZimWiPi6
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9A05F1C0018
X-Stat-Signature: dn5shziq1beo4ns6h6hw48rqaoreu8q8
X-HE-Tag: 1757342939-922878
X-HE-Meta: U2FsdGVkX1+cYSajWxqAPMUbYS3bp9Tf5JQMmP273rsJ9c2QFiFzznWMwcL/EWc+ZUrTB7RgqyPGoUPxnCldYFL1rmyUn1QBC94ExsJCvzrINujVK7sKtxEX04up92tChFatArfkg/AbIkNXc2tpOPrAG3Yr8u4/GBnHDNrqFhdv+6T4Q2dwSUhWsnezGwiR9eHpwC2bR8eYgcuwv9xFT953u/n9osGy4kwqGeGAXjGsLBa1HTYGQbMV//le4tGX5j5pN6lXvHDtTtoSQLUGwNgFe+8ajd7KMQsFYGCAmXx3BlOKuCXqCD5J4ofLRImRH+lo40Lgp91WaMvFs9e+mKQRs0DM+sxipRm73hytngxDZblWh6J2V5fBpTzdx5fbGP/CKy4LeQ2LM7c+sfCv93R6TLkBxeNMTIj/rOReD2Ebq5XAfNvREAXhCejThwdMVlYYhY8sLOjP1uKhxyUvFeCGqJ8p6TVSqneNVOycjBL1IKcbTfZK6e0Fsdgrh2zsUXObnOtdqu9S/XWr4wUTI8V3wOHSwKFiPHFLn6KAYrkkFoXW3/oXoP9ai4nHeQhGqyN/tZLoONojKBXS7FMNw6rkub+fiJToH+C+kddmyAtuj88ktiTsnkyrLM+EA7FpFhR4WtezgRkb6ask91bejmNO4ZvdM3aIQLvQNJ7L/dhKEuBgB7p4YKmaGL1vDzd/aXMRUSytmo4ENIEi3hhpJep+x76UNIpPxd8wgpF6STEtcGqF1joWzXsVN2NgjhlY9zoqdr+A/m4szwsffRXvZw6h6PXdagDh4oUq1XkuuN0ug72KE+uk7R3VOTdWiAzEjeS7D4HFhhADgByxlfdchiItCvgxP3Oz156JkyVEqzBa/PI2AYT6XIUi7AFGwzAiGO7D6bXssWiQB2TmnY2pJOVGNIhwS/htMuvAmvKvrY4BmWC5GQTAXBRZCHUqnvk0ZbOpCQri2j6PRAAoKjE
 iuWlfvnA
 hkfqsT43EGIJhDWsx0308DoNFAbPLCCsk7VqvnIUugd4gpvFaER9DC/Ay1q6Tt1zU9LwNmlsiNWG2LvLJUxQOjCUclg3vwVDcFAWGbPCxQ5Ze+C0y0r3ydvRNeElLBTHaZjUc791Os3/WTf9CLzjnNbeBmEEoxvqEtqWPDsyDKFf6pPLCZStdxDS2BMsukxdsT+MVirMdNM+j236kdi++c6dXviepU+PmisdvlVKGyk5mE/O9y8FA/yLKgJGfcL86mxqnrIgmYhJeCzNe1yUzkByl0oYcEa2Ct6j+dclUYBXj6a3u/pu0xuhLTkO+wxqlIwLUnplvK6tu7wfMmkMSNza3u8aOLq8lUdgh6FI7pwevynSFaB6ifOUN/gH3/03WYQZDC9ZsK+OkEflwIvN+SuonjMaX/01+MSsG8Yk7hmtVZycj+qVYqRH9LfTFmB5YpGFv2GYaRqYWuOhzxFJisq3avE51+9gun21LTa+GaAyPbTj+3LljRMoxhLYAOX0IR6HzQeaNWaBYaWZBwQ/R0J4J/mxFXmy9LAH+LuROT3JTdlx+1433dr7P3kCXcDtd6vXZeKVY4F27MmyWFLX3Y3xTzzlymuLERijRLcqdjdNugYSDlxqBmvSoEryA1VVO9caed2S5NPvV5bjSQNe/RXAoZaUZTaUc94dGolZqUBG+aXe2w7eGuYI1WV9345CHqFZumxfSBLpzwB03AhVjIlBUL4g1BpQdWdK48IGCPaNxRm3tnBZlJbXG77UpqPb3Kk16MFYzepxykS1Dt4RzkSAIVLvxRJERSCEHE5Zl3F18ZbQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 03:27:52PM +0200, Jan Kara wrote:
> Hi Lorenzo!

Hey! :)

> > After updating some areas that can simply use mmap_prepare as-is, and
> > performing some housekeeping, we then introduce two new hooks:
> >
> > f_op->mmap_complete - this is invoked at the point of the VMA having been
> > correctly inserted, though with the VMA write lock still held. mmap_prepare
> > must also be specified.
> >
> > This expands the use of mmap_prepare to those callers which need to
> > prepopulate mappings, as well as any which does genuinely require access to
> > the VMA.
> >
> > It's simple - we will let the caller access the VMA, but only once it's
> > established. At this point unwinding issues is simple - we just unmap the
> > VMA.
> >
> > The VMA is also then correctly initialised at this stage so there can be no
> > issues arising from a not-fully initialised VMA at this point.
> >
> > The other newly added hook is:
> >
> > f_op->mmap_abort - this is only valid in conjunction with mmap_prepare and
> > mmap_complete. This is called should an error arise between mmap_prepare
> > and mmap_complete (not as a result of mmap_prepare but rather some other
> > part of the mapping logic).
> >
> > This is required in case mmap_prepare wishes to establish state or locks
> > which need to be cleaned up on completion. If we did not provide this, then
> > this could not be permitted as this cleanup would otherwise not occur
> > should the mapping fail between the two calls.
>
> So seeing these new hooks makes me wonder: Shouldn't rather implement
> mmap(2) in a way more similar to how other f_op hooks behave like ->read or
> ->write? I.e., a hook called at rather high level - something like from
> vm_mmap_pgoff() or similar similar level - which would just call library
> functions from MM for the stuff it needs to do. Filesystems would just do
> their checks and call the generic mmap function with the vm_ops they want
> to use, more complex users could then fill in the VMA before releasing
> mmap_lock or do cleanup in case of failure... This would seem like a more
> understandable API than several hooks with rules when what gets called.

We can't just do everything at this level, because we need:

a. Information to actually know how to map the VMA before putting it in the
   maple tree.
b. Once it's there, anything else we need to do (typically - prepopulate).

The crux of this change is to avoid horrors around the VMA being passed
around not yet being properly initialised, and yet being accessible for
drivers to do 'whatever' with.

Ideally we'd have only one case, and for _nearly all_ filesystems this is
how it is actually.

But sadly some _do need_ to do extra work afterwards, most notably,
prepopulation.

Cheers, Lorenzo

