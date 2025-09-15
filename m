Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B41ECAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 14:34:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53B88E0010; Mon, 15 Sep 2025 10:34:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2B7A8E0002; Mon, 15 Sep 2025 10:34:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B19CA8E0010; Mon, 15 Sep 2025 10:34:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A10B28E0002
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:34:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 42F91140645
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:34:28 +0000 (UTC)
X-FDA: 83891730216.27.B8E90F4
Received: from SJ2PR03CU001.outbound.protection.outlook.com (mail-westusazon11012012.outbound.protection.outlook.com [52.101.43.12])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2CDC41C000F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:34:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BgSdNvPI;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.12 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757946865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2OLPJGQr7Z+rVWzl8laX+IkMurJZ2I4ncppuXQbRPY=;
	b=pfHtYbPV/ArPP3APvpUWpRife+xuaeIPq+p49yqXjK5EmRvkP1TXi91ooNcuIgGszV/tcd
	AC4ICUi6YEBSDu37/92U21bDTQNBtf5NrLVMZ8yDLmcLp9FlzFfMsmz7B+IpdGUZcSiJt4
	TVBfZk8orrw95h1/hOFc5NP7zwUbpxI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=BgSdNvPI;
	spf=pass (imf20.hostedemail.com: domain of jgg@nvidia.com designates 52.101.43.12 as permitted sender) smtp.mailfrom=jgg@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757946865; a=rsa-sha256;
	cv=pass;
	b=FhEjDfkvyn2X9O6kenpHnfNmkeba9o5r5rRBWIUra6zTUA9W9t6RIETfKWzpLDe0mn2ytz
	7LGgN0ZNAOBFmMas/+Gpesjoz4YG6h+SwoQCZaWTpeDZQePCHyEv0XOLNy+gopUr+us/81
	2/V6Frqw4nwYjHucD0KDxAc0PHeMJvQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=w/q1kqg7d7ctFBI/zK9lLnqh8AjDLmCNsuY5LQOet/RvaSn4blhi2b7gt3jNR8telINzeNVD5Q64QY5Hp+3o6QTVfu5K7x2y52jdT+eiqeA/ieRTpPOgFSpxwOjqioztXZGQ9EVRC3SMuRb03fn/d6hPpkABnNQ5ChGJfgu52dsOc5gXc76VcTeT9XQ48sl+cEB1b3CJG0kSOq7FSFLZTjyREvvWJlDnPu5B6BC7xqPGiCDoC6QEogZ0jKsOZ2/jcPoBrwPC3z6w85SvriUtO5FvKoojs8oqjhO4q0CJHGxZR5ycjdN3qBh2ioRJ0tvHPnKb7/GS+tH3WMkFrhc7UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w2OLPJGQr7Z+rVWzl8laX+IkMurJZ2I4ncppuXQbRPY=;
 b=KhqKhJ/3Cde1vw4E30jBiU46PfZ02BAj7ciN1A2+XwueIqb4ls4ZsZLqX8XVtUP0EsuCD+1Ztwko3YyWggx3n7sl20hjpXv0c1Y++oLcfwIEQvFuFlDrsuFi6iJr5bMXpaZ1LxflgC4OA8YP8ocuMJ/B70fUZKxSNWU0/vVHx+sc9+5UHxLrDL44oTYWfebT8W83vdisqtqRpImtsmjRFoPXX1TSUSmU92/jALVRNsK2Mi83LB87uTw8qPe5qT5tYeQ9rfyU0pBzaf31KmhoEVtz3PHrPFEsRy1awYfkndoAwL4cOX/ek3kBDFiflOXeEwh7zIoCtK+KTNFtdzMK0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w2OLPJGQr7Z+rVWzl8laX+IkMurJZ2I4ncppuXQbRPY=;
 b=BgSdNvPIN7Dtg7t4BYb6qqLQ2Dz1h7alCFqsxGx2ef8kgSI48cPDlEDn+AFW3SDDGrOMJbQtcjIyPieRsxmbITgisfoTWm7gSsidLNk5hqaASkd0jQ8bJO0iJc+CnXsHQ6cJO2OmqKA0pSulkvPJJKE9IWWjBNCgrkwRkVsjthl4cmwMSx6IW1mn7IwSnKGSPwtieGk2iT53BPNDJB9I2TsYdXGmaj/Mhk5LVoaMhjOcYyAFNK8L+BXEP95Pwb2lYTGSbgQN52Z7jxu2IlLOfowUN6LVoIGQ/xvjWXaqrIYL26b45zaNApGh3o6mHwTenSWSM7Ye67VVWPbcHkGTHw==
Received: from PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
 by MW4PR12MB7213.namprd12.prod.outlook.com (2603:10b6:303:22a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.22; Mon, 15 Sep
 2025 14:34:18 +0000
Received: from PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632]) by PH7PR12MB5757.namprd12.prod.outlook.com
 ([fe80::f012:300c:6bf4:7632%2]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 14:34:17 +0000
Date: Mon, 15 Sep 2025 11:34:14 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>, Guo Ren <guoren@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Arnd Bergmann <arnd@arndb.de>,
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
	Dave Martin <Dave.Martin@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-csky@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
	sparclinux@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-mm@kvack.org,
	ntfs3@lists.linux.dev, kexec@lists.infradead.org,
	kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 08/16] mm: add ability to take further action in
 vm_area_desc
Message-ID: <20250915143414.GJ1024672@nvidia.com>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <d85cc08dd7c5f0a4d5a3c5a5a1b75556461392a1.1757534913.git.lorenzo.stoakes@oracle.com>
 <20250915121112.GC1024672@nvidia.com>
 <77bbbfe8-871f-4bb3-ae8d-84dd328a1f7c@lucifer.local>
 <20250915124259.GF1024672@nvidia.com>
 <5be340e8-353a-4cde-8770-136a515f326a@lucifer.local>
 <20250915131142.GI1024672@nvidia.com>
 <c9c576db-a8d6-4a69-a7f6-2de4ab11390b@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c9c576db-a8d6-4a69-a7f6-2de4ab11390b@lucifer.local>
X-ClientProxiedBy: BYAPR01CA0022.prod.exchangelabs.com (2603:10b6:a02:80::35)
 To PH7PR12MB5757.namprd12.prod.outlook.com (2603:10b6:510:1d0::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH7PR12MB5757:EE_|MW4PR12MB7213:EE_
X-MS-Office365-Filtering-Correlation-Id: c2eb574c-df41-4d7d-a0bb-08ddf464f360
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?J0fgzA3EZhDGT7KbfP8CmsywsIxKJJVvO2ZE9bGNw3Q/f2nhzl/evKYMDZ0K?=
 =?us-ascii?Q?5oDGq400RO1n/B4DIouUv+J4gk9rvdKMyDNUqnkctgYHpW99au5EiX6svH+Z?=
 =?us-ascii?Q?X6uwd6GedpE8y1sOxbU4hG5Nv/g+p59WJ6Ran3+HbKtLMqVEvwtyHprkup0G?=
 =?us-ascii?Q?L4hH4SsCITv12/C9g4PdZhsmAji95/qjColkRsM2hUZNcKBHMxfkkj89ofJI?=
 =?us-ascii?Q?BAk8wTkiUWz4TF4cm55a5WkPz65eU3JmNfiGqHm7Ie6iODS9oIXhdZZxlG5u?=
 =?us-ascii?Q?aYiIQi5B3oNBG7KqLH3mvUN+6lljkbkRS8+VyFSq6BD96wW/pz2bNEHtEByS?=
 =?us-ascii?Q?2IUJ3Y/0/TImRFH8gikcmCD/y27a4gt0lMV45CdXbEKblstTG/X5LDzCWans?=
 =?us-ascii?Q?/F8uJzs9ufYM78XE5d5boAE7SKf6XNnfhKbecpT2W26Vt3a6alHZa5ICx5E4?=
 =?us-ascii?Q?xzHyQOE2gfDOnsPUxAfWAxNvBC0o7MtC+IYvUH0FyYL9KAJbnHRbstlZB7cr?=
 =?us-ascii?Q?Jjs7YZDDkI/xNfdMJvrmmHt/o86+FQnST283wiqbSfX3dRkDRgTCQ9Xl0M63?=
 =?us-ascii?Q?PRMDFEKDk2tvjR2mz9DGcnazhNvWeKbCM5LKImHz5JlTI5xSZJtFMn5+m4El?=
 =?us-ascii?Q?7sIx5mEr1Bpobz0gG+uLmHdKKcb2JkZu7oiSxb4/n78KO66FM2lPOU8CJtWF?=
 =?us-ascii?Q?wDS7Q8mJcbnjDqK3xQIXrzcYOPD8O7WIuwYqAqgviK6xgvALVHqx75G1Few8?=
 =?us-ascii?Q?rQiqCbGcx2dkLpq/qe3fYjLOpK/6b4NzPiOhY26QfAff45JG6G28UfKYAMcW?=
 =?us-ascii?Q?8l7A13LMzBYtjaDC0YpLPjSz+lsxZTSGl8iewfhhfNhGfBHVdA21zCE5vnhT?=
 =?us-ascii?Q?Ljm9CHsLmRxWdomaXeAdsx6pWOWhDSZyjuKWEF12MF90x4T+P+wtO+OZ7IlR?=
 =?us-ascii?Q?ZaMe7qbwpQRUQwhUMgmd6ErDjx6w03zI1csGM4yprl48xZzNtbBH35bK+yzi?=
 =?us-ascii?Q?MQjh4qyyNFbJEp17TeB7iDsHAGf235EeH7s4Fo5gMA6Xzl9gotrzBmcfeoWI?=
 =?us-ascii?Q?d4BcoqdWbK7T5ni2GcLxr3sRrGgFHwtKDEFlsQcBAKRjxxzgvBKAg0GJYcHY?=
 =?us-ascii?Q?fgseRh15/pzRbUEbkrFuXIskr0rf46kEKCd3Wqum46yrLhS4YDYrxx0vKtKk?=
 =?us-ascii?Q?8D5KLnBbMg5wS509/16GtdXZU3zrajZQSVUyk1yTa88QfhiymthLKulNK6YP?=
 =?us-ascii?Q?nKHC2Rv888t6e9cDLWt1WyeYxvVRV1JS/McPEaM8Lt0yzmmFblaYJdga139e?=
 =?us-ascii?Q?9mHbKduwb3Ro7ZZG5+9eN4XyKZAjYhQTWX6M21UWOe71yCDc6cSfNkZ4qz/4?=
 =?us-ascii?Q?lqmhEBGn49dYQWg66wddSl1nQ2l3Iv5HYESMjyWRUW7dKyNWzL7h2cmM5Vyi?=
 =?us-ascii?Q?KQeg+Aew84U=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR12MB5757.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/3WCFB0Gi/gwIic4Rv8tIjZqRx6Q/sGGJ5Qm6p67L9OhcuF316JvcdNoB0Zv?=
 =?us-ascii?Q?C4rLP8tZo0Jhy8UwiUyPDPS7BnokeqAXJ/PRnjNP3+hX1qeo6sCD9FC3CpM2?=
 =?us-ascii?Q?lP0SbNpOWvv3F4+X0wGNvsgm9WloWB4XWrgLMV9mtdLZyYcWG+duAsKP8wFI?=
 =?us-ascii?Q?dEc/3gdTdbNS9kqicJkAs3lDbeRg+rg5NIzKbIdCyJgGqHoVoSKMjr8rWx9h?=
 =?us-ascii?Q?savJcpcNanRKORwcB9+U96gwqpPNn7ctMESLs0RRkrwN/ALoV2pKy4XsUb0f?=
 =?us-ascii?Q?T4Xk91N/HsF4dfymJrT4PyRyMCB7IaGvkBJO+x83RAKTcpV+nZSrJSu8y1Xu?=
 =?us-ascii?Q?oA34OR2fZvbJav/qyShK+/wD0wD3Rox6c216DButK3DWll7puwEJQBX2UHBm?=
 =?us-ascii?Q?xy1kulgBJNXrO9w6r5hIh5xbnjN3zmv0g2i3TaIAr0a0RlUawSmHmR6Y4hoN?=
 =?us-ascii?Q?g1enrb0Gd2w8L5ZIP7RXCyQl+yExNJPY3P5/QsiXEsFBx5W7qpCP9y3LJ6CI?=
 =?us-ascii?Q?O2ftPOJfJfEPE6ncAOlz+d9ngPfbjh4+GxkKQr3J7Em4DBnfrJL/c5zY1LPf?=
 =?us-ascii?Q?wstDSaLl6ZK7aD+Qe4obdZqaznmxQ7AQ26BfYny7Z2pCD7eKqJE9V8+1y7jo?=
 =?us-ascii?Q?Cy2X7f7Pe2sm/ZXZpXICyNwkI7bXGFqEUmsLiPL7BWWsyRaL4Bf8pMJh6UDj?=
 =?us-ascii?Q?AU8XvlcclK81GLsEsoZhuA4KeU4cFYOwOg9o9U2Y1IuK+Rfjts1f/c92dE3f?=
 =?us-ascii?Q?d+oUeiwc3iveRXZ4sm9Fl0lZ1KnG+iP2N75Ii6pfm/fA1OIJ4JsLBjdCRdcG?=
 =?us-ascii?Q?tlkz8EweM9xQAeMIKRakoGxS2exPncZ6UU7dwPgOKQoSQ6r6Y7IEBh5tCbsr?=
 =?us-ascii?Q?OVxfiRdOfUpoRjdjF/6SJzNHzixxcULmWxRV8f9xWVaGlazPw1MCSWs+a8tx?=
 =?us-ascii?Q?C8utKH/bDXbwFMPDzOtIASwW8grrNTjCe5ipBnPeZAB6+cY2SG+UHwAVD84b?=
 =?us-ascii?Q?XuGxXURuPgV6GP3wsTBB5USxJWh39uQwlNiaSxpq4nIecECuWz6UoOlfwJ/Y?=
 =?us-ascii?Q?1uCAkNFM4T01plaUWjz5dyVTn6Uj9FlOSOBPfgcAeLOLXQVbiSOAq63qnwsB?=
 =?us-ascii?Q?oN5O2V+T2MRIG7mC1v6i/s0fytTnG1Pn5fhbiHWexGPUvwTbVlmbD36rAH2u?=
 =?us-ascii?Q?wm0dzulxmi5et3HAL8onV1W53DQgx6+ZXQmHL5Edzlu50Co6Jeim89hRgIcz?=
 =?us-ascii?Q?heZwAjVS+ewdGlAPwMNE12Ar1BV3lgNM72AUEdUQpQ3X4aTVgzY7wiDgfbJi?=
 =?us-ascii?Q?L1mUfEZZ7CXQ0NjiB827RFrbkh0cS5LhQoby/BjaqVACOluDAyqqfUrNAUQK?=
 =?us-ascii?Q?xIJpxn5F510cl3gnQlF13EGu1jv8pEf+z6kx5FTo73xPnFax/j/DqCVgwg66?=
 =?us-ascii?Q?IVIRidoFiaTrNbC03o8TnbL8GRQG/z9nG0KBfPLmWSCnnFRsHiH8/G91GYwX?=
 =?us-ascii?Q?TAg71dOv4QB9gZO9cHVntZSZaY110H3x5jEgMhes/qNmJNULMOUuvkh/CFBS?=
 =?us-ascii?Q?yMQ0+MSGOlIIItLUz6RTrAm+k+dvHmwygFweqt2B?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2eb574c-df41-4d7d-a0bb-08ddf464f360
X-MS-Exchange-CrossTenant-AuthSource: PH7PR12MB5757.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 14:34:17.5723
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nuekJOcIltSv64PXnhJ9nduz2Ux8IGU0sDYcCkCUw4OJvfDQhyOvEIyOeWPaznQR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7213
X-Rspamd-Queue-Id: 2CDC41C000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: iyrd56dg6is769t8ft38mibqf79xfwsf
X-HE-Tag: 1757946864-234257
X-HE-Meta: U2FsdGVkX1+f1phRiTKo77cbjHG4jKQUh+6TNa68eZAW00MktMzZUDPQBcgfTHNNOl/OKnMRdp4EU/nCHI72hfxQUGnpF4qU/V3sRF+8WNZnpg2f+Dumj1by9PZskuytNgwOIagg3lMVU3UCyyXQixxPRhUMcys27b5SNBJmFpAyENq+GifC+in0Jtp019C3xG4zU7xbuAv8WLjcfYb7PY86kTHn/8Jq0ePdJkNtMuqzHg5gQmE2cuXneOO9/7dg8rXXQIQQ8CvaHTorq6H27UpCwxG5Q8RlnoxlPeFz+j4iKTdu9jKEtCzoF8FuMMxkurkKGuElw0+saTDRKNMLIivsU3viImQp/orGP9y59gZ9T5eFK2NX//hwUBAKj+/o5Hfe5CkC9S4mlvByjA9mRNdNPgUuumHPkFAZY01yyiJjmOGTUt7IByQWrfVhMt2FbuyFo6UVfkbtQcbtzPaaLr2nuWAsqtuHZwgYzhZi4g04LJyjYfi55atAPqS6eTqhSxlmTcTeUeUJnz8sNYunrfPHoJanot7U3bFxztfNgBGUlvLZaD2TH4W2BwGo2m74BfvwuwU/N3o1qo9Id8BzQltefqLX5Yye64CRzTPPGgXinY5rqCTryLd5n5bYtzStdzRSk3nub2SDdvw5snzesLzpa6TDSUwABgWfI9L6rOF/ihqA+5Iwvgmf1wXWDYID6SmVPJU7rQD3A7rFp/VmfySrT1EnMSMnkQVVoKVNudn0Xgq/v0cnVghr0m5FdxqFipqvTe8sF8345TUf33yGyvLf7DRZ57UTay4AS2CdXaAHhVe34BThG1pshU2F2XLmswlRqvafILmRfb8mnkbWJGt+1FhqxpcUnWBsmlqF2zLv+1gAsbtM0lWn2zra/ItyriqaDL27SBbRcMYdtzxOi38kHWM9R4J6tV14f3IsK+5D31Ldrwu3J9hWWKKVomg8KLqHHM8tc2rzz3fJmc+
 SnHHWi1W
 4ffyHFqaaf6N/QpZFolNhq1vrCE5hz0mUnT0FV5gFP0tAhGVPipnSg6VgwGS2r3VtifYWOAVtMFPpJ1YsS8M/qvjiVfv8Q0vyoZRC25DlGZxiKV2YSBO9jxbzSa/fke1ftaeuCqVefQCBc9vyp34ZQ/Ojjzqm6LHQkBKsdqPiItaAhSiwFV/9/cjbOBPoXVX8gCV9KopDNTAyOsHSnVcHxagZGzUDv2CA9S6Y8rnvZLuSg3ixI42hJGObs0EMZdmCnY7ajMH5LaEb9vGoyTbk/LDFKRHeZYvS0q3QRR/59/DQ6tIey2nph7PSn5Y14WzV1bB1G2Fb17E0kdNAlZ5jRBzgNu6NZmsmsVfBUtlDqvIc2jPbaxCydqujKnvxqg/+e8yDVQ4y2nI1ftmm4xUFBc5qk1kweZKgS2LL6DDsPNpB1h/FIFY+fQrB4eaUFUT3OqBMbWVchcOxJ8OHRR0w6kW0g/FRQ6HWR3ZlLbxD6gYPW7voueHHeqPsqnbYMu6L6HYc2I7ettAbMpge0/LyKfqdVfueiJ9knVN15ARN6L/5mKo9qE6OZ8wLkHK5uTkTXB2AMYoRdbSo8r4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 02:51:52PM +0100, Lorenzo Stoakes wrote:
> > vmcore is a true MIXEDMAP, it isn't doing two actions. These mixedmap
> > helpers just aren't good for what mixedmap needs.. Mixed map need a
> > list of physical pfns with a bit indicating if they are "special" or
> > not. If you do it with a callback or a kmalloc allocation it doesn't
> > matter.
> 
> Well it's a mix of actions to accomodate PFNs and normal pages as
> implemented via a custom hook that can invoke each.

No it's not a mix of actions. The mixedmap helpers are just
wrong for actual mixedmap usage:

+static inline void mmap_action_remap(struct mmap_action *action,
+		unsigned long addr, unsigned long pfn, unsigned long size,
+		pgprot_t pgprot)
+
+static inline void mmap_action_mixedmap(struct mmap_action *action,
+		unsigned long addr, unsigned long pfn, unsigned long num_pages)

Mixed map is a list of PFNs and a flag if the PFN is special or
not. That's what makes mixed map different from the other mapping
cases.

One action per VMA, and mixed map is handled by supporting the above
lis tin some way.

> > I think this series should drop the mixedmem stuff, it is the most
> > complicated action type. A vmalloc_user action is better for kcov.
> 
> Fine, I mean if we could find a way to explicitly just give a list of stuff
> to map that'd be _great_ vs. having a custom hook.

You already proposed to allocate memory to hold an array, I suggested
to have a per-range callback. Either could work as an API for
mixedmap.

> So maybe I should drop the vmalloc_user() bits too and make this a
> remap-only change...

Sure
 
> But I don't want to tackle _all_ remap cases here.

Due 4-5 or something to show the API is working. Things like my remark
to have a better helper that does whole-vma only should show up more
clearly with a few more conversions.

It is generally a good idea when doing these reworks to look across
all the use cases patterns and try to simplify them. This is why a
series per pattern is a good idea because you are saying you found a
pattern, and here are N examples of the pattern to prove it.

Eg if a huge number of drivers are just mmaping a linear range of
memory with a fixed pgoff then a helper to support exactly that
pattern with minimal driver code should be developed.

Like below, apparently vmalloc_user() is already a pattern and already
has a simplifying safe helper.

> Anyway maybe if I simplify there's still a shot at this landing in time...

Simplify is always good to help things get merged :)
 
> > Eg there are not that many places calling vmalloc_user(), a single
> > series could convert alot of them.
> >
> > If you did it this way we'd discover that there are already
> > helpers for vmalloc_user():
> >
> > 	return remap_vmalloc_range(vma, mdev_state->memblk, 0);
> >
> > And kcov looks buggy to not be using it already. The above gets the
> > VMA type right and doesn't force mixedmap :)
> 
> Right, I mean maybe.

Maybe send out a single patch to change kcov to remap_vmalloc_range()
for this cycle? Answer the maybe?

Jason

