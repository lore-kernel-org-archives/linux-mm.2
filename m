Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64B56CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:28:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C168D8E0001; Tue,  9 Sep 2025 05:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC75A6B00A4; Tue,  9 Sep 2025 05:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F838E0001; Tue,  9 Sep 2025 05:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 93F286B0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:28:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F2F5119F12
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:13 +0000 (UTC)
X-FDA: 83869185666.05.5F6DAA5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DB7FC0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:28:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sEOw2SBQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mX8lvcZp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757410090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Br2lsHHBQ93MV4HFWNYl9NvEGaDrPzctnOuPDsCEVTw=;
	b=bR2ugPZgK+OBtAM/pFEOGrAYDP025ooOOUDMaBS5Gmy69GoAyko121+Z+8SicHNusiNMyG
	AIFQzonnKJs55Cr8fnF9wnJwqGvGszJVGNKqDK4b9YMpU+5Fjvcj4Dqfm9oL8SMWSpdXKK
	PYA23xe9rncwEHRbMrKIvuJNTWrLEPw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757410090; a=rsa-sha256;
	cv=pass;
	b=5SRSFm4tRQpNTfII4GQsHkoG3pz68ph1/xaA+YHF6o4jKOGboYnBXFyXCWzUwWO+qryG2g
	2I208K9cnb4/MziRHv/qr5ng+BoRr8Ad2HNh91MCEgK6af4yI8K76G4PLWViZHVqMvx382
	H/UrjV5zwxd3E3c4zY24MyHCA3kjYqM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=sEOw2SBQ;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=mX8lvcZp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf22.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5897fngP008578;
	Tue, 9 Sep 2025 09:27:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Br2lsHHBQ93MV4HFWN
	Yl9NvEGaDrPzctnOuPDsCEVTw=; b=sEOw2SBQicXfR9628nIR6HeG7bp5Kh0azU
	xEiowNkq3v/+mJfCrQTt6LXPzL+Orz2dFGDUARBKfdWbVx6Wja0OW/zQVI3sMh+T
	9TqZw7abnLibvvwB3615ZHL4eyqoI68C4uViA/b5yjd8Dwmr+sn9ElbGQkC7SS4I
	sAHL2wb+4MwCim6DNmjGtk/kOQZOpdfbZGCdBk1B8YkLDVPj1YSaeJpHVQ3Vv+SL
	BSgzVhFIHeqc7gK1hjl673zFAtjJ5dxvcx+tsGm7UjnQRLurRX7HPXMXN5BQiUdX
	wbQx+nO3JDkwJomPU+GFsMwRO8wA3rJJwJ1OKaPX0rj3sk5KEW/g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922jgsetv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:27:54 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5899COLI026002;
	Tue, 9 Sep 2025 09:27:53 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2071.outbound.protection.outlook.com [40.107.237.71])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bd9c55c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Sep 2025 09:27:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cnEhmNkF5TP7nicf1TprwEzdpexvdMjIj8bKH6PUnqG9O0xTYAKZwYSr9Qn49AMeROTtVjZnoOGH1L+x5FWq2bEuUJmDqAdeDy2KkXhwdJU2M5YA9fhekJWIhoMGG1hsyYj576untV/pzs6mHAgGLw4anNRU6FW8kYYRDQgxPnynOQXishjnKuAgF/MJMP7jh8mTvhMltYnUXwlfRTw/NwyMt0PVs346fWhtUQ0ly/23WOa6URYhmgooEx7CMGioOH3I80PWMRpEoUYAXAtb7L9RXUHC2y/qbFQ668J/Lk7TnONk7EyzU7QDlJokApGR22tCCXjDlGmRV6IeshZw5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Br2lsHHBQ93MV4HFWNYl9NvEGaDrPzctnOuPDsCEVTw=;
 b=LVT/n3Dx/hC9z3KBQlFy9P0Mkqz6ftR6MTWtiAvxXtlxyAnDfFEI3fwij9cwEKKzQQygH2RWqM067LOxSl7OnCBZ31EQo41RANQ6yhZ5dxfqc1kONJJRBH5dvpG0Hb7sP8WxNYrTjs8u+GjNoLdQhNIhIxtgUSXwJ1e9isoQPEFwATTjdzwVYEN+jxrZrAgT8D3qbad5zOQYG5bi51DFuB8aRPz461HFfDMNR66ER25NEZ0ljfgSz/W4vTV7FXoW7SCMP8bEbJjO9PF2E+rWn7mdsoP8zbXH9z5r5V6hupa4Q1GMzhSccpNRYhTvT8WPIDzCrW0k5iruUjG6XtPrsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Br2lsHHBQ93MV4HFWNYl9NvEGaDrPzctnOuPDsCEVTw=;
 b=mX8lvcZpCAGy0y1uZ65N/H90Armz6/5PF7QZNHI+srxedI1iZ4wntMiLQAZg/G7JKv2DsB/o2b5EmoO4y6lPgtfOK7jUc3N5GXkh33olRwWlSOszbRKmT8d4m1y1YybIhfmA14QHZuf4VjuG55o/g7YcRXRpGEK36/rV+RXGxlw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7128.namprd10.prod.outlook.com (2603:10b6:8:dd::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9094.22; Tue, 9 Sep 2025 09:27:50 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Tue, 9 Sep 2025
 09:27:50 +0000
Date: Tue, 9 Sep 2025 10:27:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
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
        Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>
Subject: Re: [PATCH 12/16] mm: update resctl to use mmap_prepare,
 mmap_complete, mmap_abort
Message-ID: <ac670176-99b3-4f88-98ab-34a43927290c@lucifer.local>
References: <d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes@oracle.com>
 <202509091127.USj6agt3-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509091127.USj6agt3-lkp@intel.com>
X-ClientProxiedBy: AS4P190CA0012.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::12) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7128:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c929b7-38b8-4243-be0c-08ddef83257a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9/xxULi4T8lWQ+iUxzveedA/iT8vVFWitU9B8CWtamjEW+AwAVf+yX19ASiX?=
 =?us-ascii?Q?Q3XCb+qOHkkhmhuGOZhasANp92yipYiy6Fdnih6XDgS5ncfl2P1m4OvXv2xA?=
 =?us-ascii?Q?9KwuW5r95bjW6Bz3aIpr8ReFOMmWS8iqq3MQRVEaBkscjD6fLp6roUYb9G7a?=
 =?us-ascii?Q?1jOML2xrV8IEW0Lejaos9GJ0zdP/byT77N+8IohEMrfU7Pfk+fASYl3HzQHj?=
 =?us-ascii?Q?BJ8BMh2L9Po7LtJUCDh9vMec8tx5eDxcStfoNuq+ZKrZ/eMFdT50Bg+RtLCb?=
 =?us-ascii?Q?DiWAQGD9wMzIz/ScbYx4iyZBc6zY+Vm/S3ReUXc+vLb1oYBT0ZxAnHUnUtTj?=
 =?us-ascii?Q?VahF/XNWJzMo6KmuXJl720s9zh6s0fdRxy1ItoR3+M8i0oScyArZxHCs0L9K?=
 =?us-ascii?Q?T8PLLr7KLa0Zrt0rfW8TXuJ3NsFeLOHN7ggbE2H3Pfamo7bHluWV5E5+pb5g?=
 =?us-ascii?Q?Xpy4UDC+5nhEOV0sGQjMVL/ARFqJ+TWTrfOGO8/s5C9Id3pDCW0NbvOp5k7n?=
 =?us-ascii?Q?pZEW2GaChTk9n1Lx0DORYeLjUxlX0Vd6tVbSdeiBKaaOmPn2liglTuD1tgCb?=
 =?us-ascii?Q?elVqw4E1AhzC8LyQSXO/r65cCMx53/FLZYsfs8T1gh4cclQV3Zw0rwzrOwiB?=
 =?us-ascii?Q?V8dkRr8NkLFl3X+n/khJa8j+vLDvVge1Janwx7cZ2UfCQPn8CZ5+RiTePHBR?=
 =?us-ascii?Q?3W96/CPjQ+fLK8TQVrj8pN7sZ9zQf9c0zmDnWUmFPacK71YqZg8dw9870Bjk?=
 =?us-ascii?Q?gvaXUp7CwtyHippWLJ3BJUenMO/hFPLV+q2rAcZBYCYMJsoGzX/5Q92p5g4K?=
 =?us-ascii?Q?IsuZqnU1TTsEgcx+7eOjG2B3rA6upuehsfuzTjMbmH6qIpwg4xdkROPuyZUB?=
 =?us-ascii?Q?pEZp9bLXQOHgPgWjOj0xHumhlcyJgkMIH4Hclb4Gh0Yk7BdmYJ0tutO304YH?=
 =?us-ascii?Q?oDz37uVntFio7ulWZPDSU4RfqsciDu0PdY7aupTv9WwVdP9SBc0AIse289vR?=
 =?us-ascii?Q?nTJA6RTBCtk/pt2gCw7YihFveRNhSH6P1lYIbtBKUmmNy6vph/bSR5+5/Vb4?=
 =?us-ascii?Q?KBHWU0f25EMk+0b5NmmDmhAJwsniSymHWsPMDMcHhAtZPuCFx94sdOKgQyk9?=
 =?us-ascii?Q?tphDtbsiuaJjRbFAitHyCqyyL6d02KyykjXYfG7f6g3r92bbtFiraKfJ/jEG?=
 =?us-ascii?Q?iifzSqGDBSshWbDRbvgbLgJu43QkzQT+DYYaInexepxF1pBp8CVuzFx3X15Y?=
 =?us-ascii?Q?7fffDSKnZWCCUkdnmm4zEXOA3pMzYwsDndL8rMgjuwbswUf4azW0XJZI9U0S?=
 =?us-ascii?Q?0MaL93hfPU63UEpN22JHqFvtKp7niXKX72ZeT6ZT6WG+5zgp70StkvZbqSTL?=
 =?us-ascii?Q?9nEJfAcOntGU/RkRfNDBmiyPxKfy?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?235vHDmGH7unL8ANe7sAd5Ho4LGXnswWMnmyIhcf9G26llzC5Nmo5VWiHbnm?=
 =?us-ascii?Q?1+gzUAQotA3S0BST5THerlUg+EdfM3R90CuMjTsPHk4+hMU2JAUFr/pyQqTg?=
 =?us-ascii?Q?IlIY4asJgTu0b+yqvOe/Yw5B8X8sFFUCeihN0pL1aZpd6ZqOH+CfizJQwkij?=
 =?us-ascii?Q?PHYEKi1Kkr5ra4DPHMtA4TVpTtbWL4veYvSpzwRvthT3LbwbWZzHEel9A8RH?=
 =?us-ascii?Q?9V7M/j/k729SvA2blNTHOHVJ7B9nQvxXWDfed/CBEDwA31u+xcxXlUPDBGtr?=
 =?us-ascii?Q?3OPjFdT6QNdtLGUrQtC93H+qZbXVXBzPCggPXQdCJab6Ji2ECPg4vx1AzY++?=
 =?us-ascii?Q?QHuXIXzuZRXQ56FYEqs3QI3BCywe0OHd58Q0U163ltQ7pDPnPQiXDp8z8LuY?=
 =?us-ascii?Q?GPtKhSPiat8UEEiy96NK4LFgaE+e8NXvrgQI12XOFv5uZtrJKLxQhvTIbjyP?=
 =?us-ascii?Q?Q+r9vTfeoDL1qSvDz5mnzMnnh2Hd9XivnZ37m5Sj5QsMaDvAe+HyHvE7pP+b?=
 =?us-ascii?Q?FrhnwXqM0Jeq3APS4wy7CCqx1g7Aj8mxNejnt5kAQTShV7CYGuGL+JhPhNS4?=
 =?us-ascii?Q?HyG0GUWR66who3VunG4tdyvOUQ7totfG77fZwWO6TF8CcWdzHAfEhAY299St?=
 =?us-ascii?Q?vPpbU2fhZINpGQebqLwisghs5ATFpKDmoRk1LbF62lUIf2+hM/LsH5v6rwQw?=
 =?us-ascii?Q?hAEuCZqihH0e9/+IK6DPp++iixPmUAS88ceSbMa0AHIkhoPhcYso9GvrHU0C?=
 =?us-ascii?Q?nmUinVBmXGVgo6sHPbofnAXBWWP6i2VphG3SQ84KQpYbAQeAx7X7lJ6dNTif?=
 =?us-ascii?Q?qO6HDc1BnfzkB1ohIzQXiIEHcyJVQB8tgdEXzOMcvpdIqAmCKyhR5Pdo/vrp?=
 =?us-ascii?Q?Swmc5FFhtWbS3HzagDSdURASCGmJY2Xg6V+BTtddtGrog7zZcxexII8ibDIy?=
 =?us-ascii?Q?pNJAgUsFe1ux6voBlgRZmX4An9L5jnAtwidFVEUmQ5X0SaLNeEonL7g1x0WA?=
 =?us-ascii?Q?dr38bL4Pq19x0aWp/lkLim6BPjbPqs2erOCxRULx6SDywwjFgDK8BW2587Wu?=
 =?us-ascii?Q?1Ql3BIatKeHW+70vB+XtZ7yEBtWjOr6pGY6ZTNnti4+3A5VsH1ivpmIh5EK0?=
 =?us-ascii?Q?/hzp8MgCXHoCO3Gjk5Q+J3L6ksvaWuJ7ch0+kmdH6hNjyGsr2MWwFSnJsLWp?=
 =?us-ascii?Q?fne/QXPHt7VXiDHOHAtr1Fyf7PmtuCzIpu9oGXiqSk4cDK1c0R4bl8qS7dlm?=
 =?us-ascii?Q?TMURQ9Oy4pQE9Tb7rIQU9wHmLATlarDdmJ2DnXK/7TBbC/28IiYNN6ZKTJ/6?=
 =?us-ascii?Q?oKTUFm2Xdt/PtRg7cs4tpyn1BP7FY/g/VKok8p6eDY/nbe+nOITyNuG4YMqT?=
 =?us-ascii?Q?aiZ8jO8tWum3nxOSnPCINVkYFfTFYLgGu3Nzv+4syU7HTtIZGiRxwrgxLQzy?=
 =?us-ascii?Q?MdY4Ts+6emkQG+rDpIogj3OJqeIdMowkkAo1qKkY5kCnhgdIuuPEU1o6VG9B?=
 =?us-ascii?Q?0FWEyzt4c9p5kRoZT6AsXZ9EANmIsKOa24nsnPTtEJDzE7hzdJ4JwYrX9Jt0?=
 =?us-ascii?Q?82zWc4DRUe9MgXXSidbJAi9XEZqdL0xEDwEwNcfURFNoQJVVeKm+tibCadAE?=
 =?us-ascii?Q?TA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6eSfOtVx9J8wtQsDRgke/htJpcHaRuvnTiOMtSvyfXjHrMS0Rp2ALGRMzMaRek3ly3RRtiC1shPMEYFQqQzdQOvRWlNd0NWSma6r/EXQ3objqkVVdOv5GJGh9MydNJx+GNTV4umIAPR/Vakh9zCp9Waj/sGM2FQoV6ZFwzV+VO1cgada1esm+1LGV8DM+gOLW0OTRkUHo7ApZSId8O58kC8Vfx9i2AAiR8PVG3WrE2mWh4HUx499VY+tiLsYefXM8S7gNQZDTuzc4SyOz7G3cTScwPxooi4UIC6GmzGk5qVPCDW70TsjguvjY2CGlJJbtKKWe4OgJ9az0hrcvfSbgLQ2WQ654OxkLdfEVgkQn6sT4A3K/MYs/vebfXif98X2hdqE/t3TvRjqzsaWfRlCb4lyAxMDwe1BmLIbtOsx5NAUEyW0QYfOFAv3KXNpP84cElc3FNA0qXFEr4Vv9arWRPlhdrT9crvOEBPeCyS9uvUoldCaNOJKW1/ydUARY3DtCAKy5EcOkxjGGy+sytemI4cBkko0NSea8b9OKOuvPvinus2J9E/D3dLeBlcpZMkMxglLoz2t9c6AD4M+Z/1QQ62p2ad8xQNMUu+0xyiF8Wc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c929b7-38b8-4243-be0c-08ddef83257a
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2025 09:27:50.6622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMCeC+/Px6JLOCCXYhjpY2xUGXMGugbKuuyt5uEo4WJAb34uNneN8pgxnvPQsHG2GROr+DnE7xmvZlgAppdIx9Cb8A/9LirZYluH8RtL2xI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7128
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-08_06,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509090092
X-Proofpoint-ORIG-GUID: BcbP896nHQHONB-3kCYrd9TQ85AsPkH4
X-Authority-Analysis: v=2.4 cv=PLMP+eqC c=1 sm=1 tr=0 ts=68bff31a b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=anyJmfQTAAAA:8 a=NEAV23lmAAAA:8
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=i3X5FwGiAAAA:8 a=QyXUC8HyAAAA:8
 a=sEyC4P4DraPXkTr3xI8A:9 a=CjuIK1q_8ugA:10 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf
 awl=host:13614
X-Proofpoint-GUID: BcbP896nHQHONB-3kCYrd9TQ85AsPkH4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2MiBTYWx0ZWRfX/h76PISWIUBf
 kDx3r7d4OK1jIJWRqxqX1TTgyKFctTfw5zjaVA0P3srsJfTf8EPsT6JvDdPHK7Ietm99EtuFOE1
 B//3fzKIlAaSyKK42Q//W7UzOTzUNPOIdt6kdyER31MB+CGLYdrrxIUr5VpSV302fj0YIFMcWyi
 lfzHbFx8JQe6JAQvoT+b2ufDR+FVDe5eRIi3v5zbZOzcppZqkgzcv+/gMIyFJHUA20sibv8ltKz
 doabncnPji3F2KDGeozgKTanD5oeNcnmAmATnmi3OMSI4SzbliLaf8P5/2rZU9L6zzt6W3F4Iym
 3MITTrlMh1q3dGWbftB0RbokdCO5t8JY2Xwvdv2ahvQ7YJOLMh3iC3K5NOtSTDN2qIHB7aK11uo
 AnTuMrRk6wdDZ4ZPvxnUBCxA/0SnUg==
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2DB7FC0008
X-Stat-Signature: zme6im4sufrstt8jx1x34kjxfh3ofwh6
X-Rspam-User: 
X-HE-Tag: 1757410090-753624
X-HE-Meta: U2FsdGVkX19lNhLpqC9u+OroWB374AV8ReF1IzTxeVGxwmYJ9m1Wyu57Oerj/mEM8PEGjnfI8uBoGw9EXJu3LVo9geSjfNnxikViYdg415l8Ho0va6p4W9ZmqKv26nmZS/aWe8Xy7E52xdno0s7uKZzNXdKURsOxagbq51ZZDpsjfmvgAMZ22gqmkOT88kqPk3rd7D0+1wtAaBG3wqwo3OnlxXDNcPzvtOwaGRe7GqnLXm5nIodS4ylwbSEmW9+oBFF31deeIXpscpa9RrhnTFlAycgHu8swEglrIww9zCxsUbruSxl56cgSoUtKnF5Fr7/fEcr0CJIaWD19bnrLIDhChnfTUzc9Ao4eAtlqz6PDCA2DsFQL9jI9yFs4CbdyzOSZUI7+fyfZJ9Te+DM6QsEtd1sZgEcQw9219nHfBTWy3ZhY434VcSSnpZ+hXlwZZGIEOGXPya1/xrNVT2e0kIwtnXepuXWabpHrAdZa4WKbbNJAn1TC8i1HbosLFC7mutb/xVL81k5oc1GG0vUEUmsTOlBXMtu6rl+HBf/8YWdxz0WUmbiGOP8rF2yLaWmk7vFcIzQKUtOpQ4CfofPEwuQVsTLgiaWKpBtd9Vo/FQ/LOI+ZWq4hqg1LVgVcCEBrgZUb1LeJulRxd9w555txdg15oPVORXU7DoiAbMazFXlTbcmXrawA1SLjQafbY5jTfRIWGkXzWXSQ5vLvCutcxR03XAmJ7niXgOTqoY/1Su4jq3jfs2cIorsJbNm8Ot1ZCeXnlDp1bYK1MgnFlXUsJJei+2Vp/WQdKyuIuTO4nCsDX9aQ9SK/28fwU6uOf1TL3CsptVZUI80OFDleWWL8bY7DJ5aL06mGIQRKqUZPWRqRhW+kIOtXA81vRYsybXKowk6StGKVuwKXX3XWYQigbgHmsnCoi7TQP4Vfdbas/M7bKJeGSoGEwD8zf83YUe0DFjmmqRqZTdWmzUX0gEA
 FhBUwSob
 MDYlH7QND6+igO6wo/DIKcd2M/2/k+MTu0XRnjs8nvXTdrLjIaWo4ZZA2i61sXC8AJ4aA5OwnSa6aiLFuIqC42jJfDd/dsL8iZHwvkQBhWA9waMkoZbaqWDOboltoaz3fYGpARivQMNoXPCjK8mIlg6YGF5WVuyw208gR2XCoxbMSkvwZCmil4GCglnwDsorQHyrk7Oro13p0TsAlPMzc7Dd3LBBtdAtZnc2NttE/1yvzzAf7r7x0PX5VE28r4H6xO1jkbDKAWKSmzEjRzfDXJI8E9ACRDNG0qC8SWwvrNSWAGOWfPXRAHv26rq6iz1e7DyP+6RrveQv4iOqHC5LTe6dRO+nIMRXwsHN1hkREej3nhWN1p1Jf6j8euJmE/cRIIX7TdFfozx5oE/YbrCGE40FB7bXruYJ6IQMWvQWhsN3IQ1RkMpVtbIogntyYGQb5NLmf2CYAuJ5v2k7eW8J/QlEReiIJpKp6e1Nxk2Ns7UfT3lD8Boov9qVpC54Fi/vovdeHf1PsLfbGqbYGHjFC7RhWw2XyAzB6nN/7vAmPnN04y0HvP4/FfdoL58KmETU4fvRUNzUXjJ4/wRQWB+zV5hOaXcLHj6klOaG6wCa3pvB0R1RuAvzzl8X5tOKMOjabZ5eCcS51Bk13PEjNYZSNSeSZfIR8yDINg772XykUpQNKeUqMxJmWTm63glePNWXuu+YcQcr/xuXyo4XvPwNvboaT8Rz4FvoFCpMw2HucfElQAtoZLakP+4dMn/VLL7aXyJHCUTzXPd1XElQgwEZ7zbjQC7I+jhIZU/qUSBJumx9jtl7KeLsnzb3w9qOk/OkU6kRFWAX33u5RuruBCBrgzPmEr6nGCgjti9FcbltCtyNYGBO0aTm2+slktH0NMIRb3srEV6uL56DFkk3H/LNtN9aA8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 11:26:50AM +0800, kernel test robot wrote:
> Hi Lorenzo,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
> [cannot apply to brauner-vfs/vfs.all char-misc/char-misc-testing char-misc/char-misc-next char-misc/char-misc-linus s390/features lwn/docs-next linus/master v6.17-rc5 next-20250908]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Stoakes/mm-shmem-update-shmem-to-use-mmap_prepare/20250908-191516
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/d9e9407d2ee4119c83a704a80763e5344afb42f5.1757329751.git.lorenzo.stoakes%40oracle.com
> patch subject: [PATCH 12/16] mm: update resctl to use mmap_prepare, mmap_complete, mmap_abort
> config: i386-buildonly-randconfig-001-20250909 (https://download.01.org/0day-ci/archive/20250909/202509091127.USj6agt3-lkp@intel.com/config)
> compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250909/202509091127.USj6agt3-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509091127.USj6agt3-lkp@intel.com/
>
> All warnings (new ones prefixed by >>):
>
>    In file included from include/linux/mm.h:1096,
>                     from include/linux/mman.h:6,
>                     from fs/resctrl/pseudo_lock.c:19:
>    include/linux/huge_mm.h: In function 'split_huge_page_to_list_to_order':
>    include/linux/huge_mm.h:591:23: warning: unused variable 'folio' [-Wunused-variable]
>      591 |         struct folio *folio = page_folio(page);
>          |                       ^~~~~
>    include/linux/huge_mm.h: In function 'split_huge_page':
>    include/linux/huge_mm.h:598:23: warning: unused variable 'folio' [-Wunused-variable]
>      598 |         struct folio *folio = page_folio(page);
>          |                       ^~~~~

(These are nothing to do with the series of course.)

>    fs/resctrl/pseudo_lock.c: In function 'pseudo_lock_dev_mmap_complete':
> >> fs/resctrl/pseudo_lock.c:1006:23: warning: variable 'psize' set but not used [-Wunused-but-set-variable]
>     1006 |         unsigned long psize;
>          |                       ^~~~~
>

Ack, will refactor!

>
> vim +/psize +1006 fs/resctrl/pseudo_lock.c
>
> 7168ae330e8105 James Morse     2025-05-15   997
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08   998  static int pseudo_lock_dev_mmap_complete(struct file *filp, struct vm_area_struct *vma,
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08   999  					 const void *context)
> 7168ae330e8105 James Morse     2025-05-15  1000  {
> 7168ae330e8105 James Morse     2025-05-15  1001  	unsigned long vsize = vma->vm_end - vma->vm_start;
> 7168ae330e8105 James Morse     2025-05-15  1002  	unsigned long off = vma->vm_pgoff << PAGE_SHIFT;
> 7168ae330e8105 James Morse     2025-05-15  1003  	struct pseudo_lock_region *plr;
> 7168ae330e8105 James Morse     2025-05-15  1004  	struct rdtgroup *rdtgrp;
> 7168ae330e8105 James Morse     2025-05-15  1005  	unsigned long physical;
> 7168ae330e8105 James Morse     2025-05-15 @1006  	unsigned long psize;
> 7168ae330e8105 James Morse     2025-05-15  1007
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1008  	rdtgrp = filp->private_data;
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1009  	plr = rdtgrp->plr;
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1010
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1011  	physical = __pa(plr->kmem) >> PAGE_SHIFT;
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1012  	psize = plr->size - off;
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1013
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1014  	memset(plr->kmem + off, 0, vsize);
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1015
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1016  	if (remap_pfn_range_complete(vma, vma->vm_start, physical + vma->vm_pgoff,
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1017  			    vsize, vma->vm_page_prot)) {
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1018  		mutex_unlock(&rdtgroup_mutex);
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1019  		return -EAGAIN;
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1020  	}
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1021
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1022  	mutex_unlock(&rdtgroup_mutex);
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1023  	return 0;
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1024  }
> 5ef190013e9b31 Lorenzo Stoakes 2025-09-08  1025
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

Cheers, Lorenzo

