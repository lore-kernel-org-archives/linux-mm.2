Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19037CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 13:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601CA8E0016; Mon, 15 Sep 2025 09:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B19B8E0008; Mon, 15 Sep 2025 09:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BD38E0016; Mon, 15 Sep 2025 09:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2979C8E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:52:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7ED71A0661
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:52:21 +0000 (UTC)
X-FDA: 83891624082.26.DCCE8BE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 46EF5120006
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:52:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Je/bfMan";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eRJbFBJO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757944338; a=rsa-sha256;
	cv=pass;
	b=hfQPSpKVs60g5vFD7agRi2L+ZgF8Zm+vxzMlYElDypa4Z39WFnR9HdZqfF0hoLZv1qkUno
	WpklUemfWTcP9K1MJ+3VvLRJ7PvK8W6qbPp1RItf8cE32wXnmVc8nVQ/digS5FKF7d73Z/
	MrctzZgAgxNPS+jwCrpExMnKXVG3SDY=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="Je/bfMan";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=eRJbFBJO;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757944338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqola0MdN7qJFl5/SccvB5ilHkN8lF2Mp/LG0uGP1VM=;
	b=YHFiGA7dD8FsLjv7njvg5rn2HWdz8DIRbVqgypdIB8dlMQRNx3HjJehYpd3eQH9rbdj+gh
	XNw+goq00wRvsEWdL1jaFWmxg0FcyfKJMMqxqxaBXXvmTgQ5qtFjzqqmACLJ7svWI/Cjdx
	hgSDmozQqCEqXO+viut4eoecZGEEqnc=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58FDCFQw029411;
	Mon, 15 Sep 2025 13:51:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=kqola0MdN7qJFl5/Sc
	cvB5ilHkN8lF2Mp/LG0uGP1VM=; b=Je/bfManiq0Pc3vIgXwIsO8lFsOAY/vKhY
	G6gXs3RCk8ERirOMdlhZaB0itKYDIC4g3bv8PegZqi3GDPsCoqVAMSN/93icgOVT
	Uv/py9HANQzKVCjLieaC9NIKzPj7AMnTuGiQI9+sW/zH3rec20kC0NnFjC933QwQ
	SrMI+NMQcIldmOjsL6LH6StYCP16ja60Q3AF71JeUApzssS6+qPeETzjo4uoq8wf
	UsQyaC71xgdllIifCafl4Ej7WJed8d0UJhPzwmsLdf+DrRNa4U2AFJ4EXQ7R7srS
	bfiwf/8i/wzwtppt+ywJZwey6EG2ctnIBIeoRcGQ0T5SA2iuZaOw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 494y72tfst-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 13:51:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58FCoHA3010552;
	Mon, 15 Sep 2025 13:51:58 GMT
Received: from sa9pr02cu001.outbound.protection.outlook.com (mail-southcentralusazon11013063.outbound.protection.outlook.com [40.93.196.63])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 494y2b27j4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 Sep 2025 13:51:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GgFBdxd+Jv1zpCAMAHA8fHBCt+MRwQN2radDYRhINqqmaSu8vX3NsZ6NdoQagSMGCvk19VE/DUBCYyFQYz8lPLqpr70vnMhaT+X0wAkz3GQ5P6+s4TZ5urJVQSHm3EDpMrCoVS1bODjZuaV6Ro7eBJAgo7zxRwPlKRjqQnia8+5R/XEKDJJrh3OoETuAgn/lPHsoKkqCjb+nxul+D9ov7yWYiKKKSLLx4z2MfHMSVOfRURqwAiD3vGcfRL7CAQYH2w1ujTRwoWIQpFQU2bAKomJ+uwzHuJocKtA21DrZP1PB1wpFgykUuwpHwh05I7UqkuCSqrI8sKWa++46wCxbWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqola0MdN7qJFl5/SccvB5ilHkN8lF2Mp/LG0uGP1VM=;
 b=C9YLxOLhNr4oxKDBR2wtYGjijsvns9J9OLPczoQ92iMFBK8BkGC8+bm0SCWNOyvix1TAcvXI8AjPefaI1qn8EKXC99fnkWlyPpT0VvpWV7aiUppycqxRAJrq0S86690wMkRZKkovk4mkEe9L1gddmXpMBNjPdBa3BakPY3sR2BpVSy25L440iibSqM1tETnqzko/BQzqCc539iVkrVWeLxGnz6sr0HgsEzwJkExhSN6OtwDggIKouMp/M1LEh5GR/ocZYhV7NYmN6LeLVBFTXu3iIdhWd7a5XMkpof5Fei4NHf/rSmCF5IizaeapGr6mxQuZmfBelsa7NngMVjUcRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqola0MdN7qJFl5/SccvB5ilHkN8lF2Mp/LG0uGP1VM=;
 b=eRJbFBJOwSSjGm+Nf8DtPhQ19GpxtrGFa7aRWj0jwfHS8v/AxA2Umie8Wg7YYhHPO6Vc6L2+uU38nCxzmPZv3hB/dauGfRDd0xol+yHS4ZeEc2mAxcLerdS0rnvPJM4na5i5PJLHCmEGa32l2Ob/uslikIVcgeuOXhEPUQaeazs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8178.namprd10.prod.outlook.com (2603:10b6:408:28c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Mon, 15 Sep
 2025 13:51:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9115.020; Mon, 15 Sep 2025
 13:51:54 +0000
Date: Mon, 15 Sep 2025 14:51:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Jason Gunthorpe <jgg@nvidia.com>
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
        kasan-dev@googlegroups.com
Subject: Re: [PATCH v2 08/16] mm: add ability to take further action in
 vm_area_desc
Message-ID: <c9c576db-a8d6-4a69-a7f6-2de4ab11390b@lucifer.local>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
 <d85cc08dd7c5f0a4d5a3c5a5a1b75556461392a1.1757534913.git.lorenzo.stoakes@oracle.com>
 <20250915121112.GC1024672@nvidia.com>
 <77bbbfe8-871f-4bb3-ae8d-84dd328a1f7c@lucifer.local>
 <20250915124259.GF1024672@nvidia.com>
 <5be340e8-353a-4cde-8770-136a515f326a@lucifer.local>
 <20250915131142.GI1024672@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915131142.GI1024672@nvidia.com>
X-ClientProxiedBy: LO2P265CA0376.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::28) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: 61017c59-a778-4efa-9177-08ddf45f07b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RyTD4n53R7bk2i7QEH16BZGE74ArW3Fte1TI2FFlIEbCn2KofG3dLnA6Bnx8?=
 =?us-ascii?Q?kBsI0ddoitZ6mp4/9ESzU2aKKuPLEv8VVoS7lK35pG0LJv8QdEZaLBD8T9Pu?=
 =?us-ascii?Q?0sLf73XZmvaNb4HXR7WDdM982/v9jXmHPxRxOnTq08lWBiHvkfF0T4J8w3nM?=
 =?us-ascii?Q?NQlTGIhAfFUuIZOLYrfKqKW+NWNX438KGgP73OqQDA4V5kH6DeLXLArkuxQL?=
 =?us-ascii?Q?fpr0P6H4bFO13mMXwXw663ip8UpMbtogyVvkR+iK9qji6ibng3ptDhJVqkWb?=
 =?us-ascii?Q?ofZ334wSUf40ZZ6QBOnQktfLShy6gAHC4lIZ0WlkXUVyxrWthwblmb7Nif85?=
 =?us-ascii?Q?FCXQlQCyLJbuVHbsMwFbAcUlYyjjQ31zr7YWyrRl6lQcXMVJ9ugejBiCgnZw?=
 =?us-ascii?Q?KqRsGRsYvF5FZUnJWydqu8KF4Ux4b/7W8VG3pCpNy3D0ID2DN5JouKEMiR/u?=
 =?us-ascii?Q?qIyQLRIYoObReqnYOq4qyfJVaCojiua9wKWPiVPMx+WEtzGHtztyB9EP/lUz?=
 =?us-ascii?Q?JGIz78jqDvoz6DO0ExN4ZbXQZPFVtP5LzQznHHXUwrS7Rs51Zubo5W/RlOid?=
 =?us-ascii?Q?0Knk7CtKvshPl9rLa6e7/qb1C+OkV4vrS7yh7am+WVLo4RmfHxGiNNtxNXHN?=
 =?us-ascii?Q?q15RAnTC1e7LFYpPOi/Fw0d9zt1f4RT03TuzLNznNyRXnG1O3YgC601M7K0y?=
 =?us-ascii?Q?64pnPgCeZJM8Xb8umDc44U5SDOjsLpDx2SmHV2utqE3NZn8h9aGVl4KyMa0o?=
 =?us-ascii?Q?8wE0ZoxOjSRRZqU3imhTckhsrq4uxvh8dU4fUfaLEnkC4PaipfqQqzNYWRqr?=
 =?us-ascii?Q?3+tAkMi0lmc1yrTMrarfJN4jnN/Jj+i8ZkECy0jG7YqOOuEA1bpvb7cI1osZ?=
 =?us-ascii?Q?hse7xKkJsaSmtFlKO/JdterWeykaHtBC4sMPkU18zFDCrlNOgk3yu6HKE2ZM?=
 =?us-ascii?Q?EbsA2w/5ua74QXi9KiF1tgU3YOzOUnK6fxmUlhISgL196WbeHwdxGhWpP94p?=
 =?us-ascii?Q?zTOxfzu0ZQhWEqfk0abledRxUDt7keEqmpC80t1S0Aq80jnA/gaRSgwVCkXa?=
 =?us-ascii?Q?ujQgPY0MOHT/bBzrtD3kzh1ZmPC7TKfaUiQ1zMro3MCmVexu/BexQIqbTNoJ?=
 =?us-ascii?Q?BEvgKwyEfoztH6GO8WC3chJg+R0sYxK3hcXXFwwwyQEhsgQx0I7syQtrR2tO?=
 =?us-ascii?Q?3hBl0MK37hTz/1EahcHbu+1bZ4tZKxQCmsME0D/NEaWyRwr+uep1TVCiegFn?=
 =?us-ascii?Q?BpLveBo4EnD/wQvviz5ycM7LWkcleVYihcuIbPSuvgGnfRg00G3HIV+kiyKJ?=
 =?us-ascii?Q?wriH35UX4adsx+hy+9NDU4ruvQg+KYcMfYTj7t1Uj4OERM7lGx4Cjhb+88Pn?=
 =?us-ascii?Q?e/Ga8wQHXbHE+qOs6v2VYypgfGO11wuQURSwq/8RpRYq5pdReTivv8tOqmzl?=
 =?us-ascii?Q?aWLrV6AXov0=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1f23maKpzUfQPEb8tUw/BwwCraOzyEKMHo7gMKsW4nYCmAXofpgBjWI6A+e1?=
 =?us-ascii?Q?EWMBgNZgiup3VNntUQreyfeRWnk3hsJKYfKKcwQqWGb7YNZxbTXe7AiNS89S?=
 =?us-ascii?Q?vs2UKd3nGMRkkhDSLedukWqr7Z2jWpnhJMH2sGVQ1ABi/hlW7rnzoGpry35M?=
 =?us-ascii?Q?O7lzR14N4MkKYwwjihiR0kygw/HRAwhpIP6UkbCw8E74mTIYTO5vScKgOIk5?=
 =?us-ascii?Q?6U2mtinWP0t0dc1AQCMVgbK18LB0kuYdunY2MgokIiO7X5U6krGOA596OlFg?=
 =?us-ascii?Q?3XZUWXvWSbDk01/2OmctVTb8TOfg24CEpsGt8b4ECv8a34+7jQHBJl3pO7JF?=
 =?us-ascii?Q?3+rhpm+tLjXO5++8DinxvgyIjhU1CRkOupm1IY6aNp16aweRcWXN8t8ARJx3?=
 =?us-ascii?Q?ce/5z+iQEi7nG5yt/nlGeOfSyuAwwgt5TjK/q5Jz6v2DxRNhuzPo7V/PxRQ3?=
 =?us-ascii?Q?OIJ+j5vHpZrmnXMTTkbyNtIcK3q5eZVU4NE4ZGrhFGhEmJf26zqFyO5i56vD?=
 =?us-ascii?Q?CnjNCKnCs/+ypOgKcEALaovUUiCXeSxVcdGucFTrB5oLWJ4eOWfUzDbhYtoZ?=
 =?us-ascii?Q?AoyDW221f4D5Xn37RM2lQCUKWVuBPh2LvZx1v0aoFpkQ+ZzIDKss+xmdTuQP?=
 =?us-ascii?Q?oJ+c7wzmZ6YnJ0hl0JYcB/uJoGgcwdvgPuj+Dz+P1FmB5L0NfUiQG/SB+Ble?=
 =?us-ascii?Q?FJN2Q83f9N0DZGpD2on2octcZ3Q0e6ebt7UXxhX+ctbN4l6aP3WLmV0QOdff?=
 =?us-ascii?Q?KGVHc0z4h0PzdAH5B0IkDv5cG1VYhi1uFFvRmVNKZvSReYyG1czQR78/5+zU?=
 =?us-ascii?Q?fpmzHwIN35JoDX/vzJJKqIjLNfzmNKp/MwAHkkVwZ2mK3lLVQT6yAjqL/+JM?=
 =?us-ascii?Q?GJWVkVTvwlyToGjuQLzmlDummK3OHMlbRVpnP7XNAlGeRB3OBv4C39lG6JY/?=
 =?us-ascii?Q?mAm6UosALr3P5l6IrsdsZysmD4Wbw3JKeq2Oqnt4FN7mhbQEASMkJ5kHJqk+?=
 =?us-ascii?Q?e2ZSjNEjalr6rQvE7C3le3Mb7pMJsQd51W6VqlKg/MOgAOJlNjy48kGjS1z7?=
 =?us-ascii?Q?8sb9YaDAFTTHQ+Y6HExKQC+SnzDV17HsOeViWJFZS+n1/2qdLM8E5pT87xd0?=
 =?us-ascii?Q?LHMX0pcZm4vYx+BoBTG+4dxYZS2Koo6DXT3CaEDYh155/M8oN+l5/i+5VuD8?=
 =?us-ascii?Q?rmj7inhUg/CpsjEbSMjRUmcBnyEGw1ZQzumDJSqFj7J9hjGOFSEnhpLT/wy0?=
 =?us-ascii?Q?fHIGoi5fEKvbcSdHHk8YEs7QEf5ZI8W6PIa92SAdLJup+EkyXt0BhjygL2sW?=
 =?us-ascii?Q?aXQPfmXM0f/pwPqDZtDR9qKBqx7N8ZTuDR5KIQ5+UxN8MFtyn3OhjH6mQii1?=
 =?us-ascii?Q?A74ctus+dfEMXw16O9NwSv6ILjV7xhlVwuUInBHWsQ+CiaZqnYIC8xOpD/RX?=
 =?us-ascii?Q?5awjKY15xseqWaM12zCl9HL74mSPY12Nc5BYkuBbtY1e8NhUSG+gWTB9MEsA?=
 =?us-ascii?Q?U4gCzb93YSRKI+ZokkLuoNcKqw/8QFDX/5akg1a2iNyCorHTeysPrnjCW4q/?=
 =?us-ascii?Q?tSD1g52vMoIk/GvsztE/cezJaVHjmIQ7VEnVvYJG2/6A6f8iPvgiI5z/eZvM?=
 =?us-ascii?Q?dA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	r2CgnSnv92gAftfG2ElsbuVf7bKxxw2kyFDIsqGzXW6atNOzV2mPEZS9nsVJH7VmlSC6S5XLyLkD3Ti4Q5OrFt6t+QX0kbNrPK6xIFk8iBVkOxq6SO8BmVGKO3jKRsj+s/TEP+dz+O3agmYD8kzTNA9J8cZCb6LpQFZcJjPUWHM7P16GHPlVYEjH/MIMPfpg3+hio5fMCulUVz+UCO96nuAippMoUfNTxf5sys1jY6qtd3D+CDXbYfnxLPcROf0Rx1ifZt6jBTjmgXmp2OuMZft6bMVtl9XnCJIV+O06js2YkvcKJBw7ta0vqcpPi+ObVWmVfw+4Ih04oRTF8MFIIeFg7EBqM6SoNR9i+UkTvOjHR1bWwZ/DXpq7xoh28BMzGFvrEcT8HggQKwe4YtMrDRkqTZzP5ARb33DW79+3bAgVVUTPSyjj8AdUvEYZWf4VLnwb0AXqJjO6BSbN05Ix76aWo/XlykhVxI/KXX3cSluskx2awZkV6LLMZTlghzHYFS3wirybLHnriM6XbV5YnSSXaM3hiUdz/bexB/YVENbLi+cN3WT+5XHFVZpWI/ilbdI+QUhTBQ6ccFs5JYExbGPB1O2uu5vWECuvsjsEhjg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61017c59-a778-4efa-9177-08ddf45f07b3
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2025 13:51:54.6639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yT+WR51P9CDksfkZ3sF5mySHwBZVaiUnn5UUshuo89gtQUrDxoAJElPzT7h6wYEvmNfJCYyffH896iJyeSgrrdQhte9KoX/i+k36KJuvTw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8178
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_05,2025-09-12_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509150131
X-Authority-Analysis: v=2.4 cv=F9lXdrhN c=1 sm=1 tr=0 ts=68c819ff b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=mw15ZVPzND2R50_b3F4A:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: gXkSIKLhG0XouVYveTZoUWreTQ6b8lYz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTEzMDAxMyBTYWx0ZWRfXwUmNgx1yi9Lu
 12UWAiDDyqcjgrjwHEhUTlgCQFCUahzYwxuriP+JIbwFsFU39rtam3PrAjfBgfD3tzo8sxaFJUH
 rTyjWo/Unh+Eym4uvcrRv5zWgJhv15RWZ9UxPkljmNtMsf9yM7KWSOIDXdvrzv3zsFEaIoEaln1
 k2rmKhXh1mm6B2H01XMph1k61XUDk3S7j5rNXX6pR+l4k76Zh7c6VODHA5UV/x28bLnEvUZa5kL
 AgibcrsJ92MWW0iTTWHlXz0CvCwf14nMKm+s/eiVvTAtYO5RyTKgowO4dfWOtt8Gg72UXNpnqMi
 k3Syfp6lM6qQR57bXLthoQBwzmE8JPcEjdz9YBJcnP6Zuqk59TbGhm3THCqeVqb8oQgOntALzyD
 lTaM38Mg
X-Proofpoint-GUID: gXkSIKLhG0XouVYveTZoUWreTQ6b8lYz
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46EF5120006
X-Stat-Signature: q3jqabkbxy8qi17jj3wa169f6zo9mwkm
X-Rspam-User: 
X-HE-Tag: 1757944338-71285
X-HE-Meta: U2FsdGVkX18sDT2JycncRZksEtue3BQFJ7IljVmurok2qORFT2TIdCYkCDlVwaMPOnU5XIyQnLCz/VzO8PDnN89+SQy9j4iRJvGFQcucsHUEFmZguznRLOHVvZCe/qyOCq2NS5N99K4WdbE+z4kd1Fx97J15u8bcE4xouqorOPSjngT0jC5mP7lq+Yf+uTfBwnhbAKFYPJF6GfuYyblgTrJm3aCKvKNyWl+MsCc1Qut9WkyjtEzTerIeIF/N9LCGpMccTUXdMh7h9AslK1bZNe7TKHhxAM110/NnX0hxXZxqJ33eaZS5ghvnSxJ2AXd48sGAs0AF+mc88DE41oCobGuE3GP9KjyLXE4pr0mUHyeXgyARZT6pONaGARbSVAV8INWdQv9bNtQAyeiFjt4vqFE6GxpV9EplUpQzgyEOtjGZfK1TVPTPjfa7e5gXyXsZfbUCoU49WE3bEwzynuxb0y6Wp6B2Odij8KFFvcZxrJjpc4NG3PEo8EdFJhWcM49y7UJLTmSpKA5s7pnW8ktKFG/UIvRjS8KrsXf6XC8Wrj1w1WPCLpvPhqvVXk9bvlJBl0ryRbHbD0K3g3fPskYXVN1dx+X84jolkGyhPjEt6a/tr+lsUpYhciyr55FOyguiMcL0RECvzYNZm38t2L/0fyARC2UVbTwXUtT+fzrExWyq9CuoSYWSsmm38I1UK48Y7A5/gpto6qTMgn9npbYIInVf5slpnD1mz659ouWKGDd4xcEA8XNEKW3n6E+ONSgh+0KooBQdFsO5r2aIZ+dFJrcl6fhqVr2xq4KwObtC7sGTmW1tophaESSMMaNhwwQm6omTNfQtoFNeJWmwJyeIpMd3BKTMqZ8vccwP/XO3Nr8vvhsW78zXsF/XqRaQ6p3IAYbwyqp3INmz1th0qjZ3OYdtReT6cw6IIuOU8LW0NVhJc/6YLkJHmVOx/erkmyjI0iWdyBgeZbiZTI8NdVj
 OwNveCwJ
 k/4SSZbw0wN/oUFi1a4C27EBc5ESgGQL20BzfmLe2j3uK2HMJjV77WjkgJOiv3oT/2evcZa5N8aDBpySDhI9CahvRzTtxBijeC4DdnnDR5HuDFS+8PQHiOqNFX811HTWm34DrCzrDEPv1Cp//mXEdDDa9FIy/tGr3RuxH1oS5gD4cUIZMQs+byP1k3LvuWwzutIdI+IqcWyYyBMl+mmtdXryXiIM0AT52tCWVJrQrxQVb0uReCXCmORVfxV5QKNXCFNrtztqYGfb7uC3F7JrQNSgPwDXuL3Gvv+sgZuiNeZVkxc7zu6TgkERS8m49QfQLhuuAUcygkJ9a8ZhP1uUSMszhdpe0dRBlTgd2dRrMPqs7lwmTLRVPBiuYZcWSH5sBdI9idNhzMgX67nVQtf+hWteRwbmr2ho8qOQG2cFGGrRbrFu8YAXJk6UHD0g4jE4jZSj6KkqZzbZYA4O1nHzbhpwrWYOhdfyWGDv2JTXwAmJc88f33+b0CyiL8sDy2rEb8HJLspFpwg1r8UZf3JDW1yZS/bDKFbeCxLEalm81oFDLMdK3okvd5v7XoXtnuHJiXQFtay4hRp/Xd7CCCJZh2Z529RM8137AnobqBN6CVnAXC0b4uHfcyihJ7S8/YOpOfX+2IwOi0yR/gvRcF9LYFM96yR+xVvygC7wSzpyBD4vxWmf07dn4TyAUTN08LFhtP+wDvIIcLmxUdu9fIe5qxRhsJYetEYiuLNoaNl9PfMQ5BjHSxlLTzVnJMQHShIMgv+CJ/qWyASvX5SL4ve4xp292a6XM2YdCOJ3z2aeGFLqgYx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 10:11:42AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 15, 2025 at 01:54:05PM +0100, Lorenzo Stoakes wrote:
> > > Just mark the functions as manipulating the action using the 'action'
> > > in the fuction name.
> >
> > Because now sub-callers that partially map using one method and partially map
> > using another now need to have a desc too that they have to 'just know' which
> > fields to update or artificially set up.
>
> Huh? There is only on desc->action, how can you have more than one
> action with this scheme?

Because you use a custom hook that can in turn perform actions? As I've
implemented for vmcore?

>
> One action is the right thing anyhow, we can't meaningfully mix
> different action types in the same VMA. That's nonsense.

OK, except that's how 'true' mixed maps work though right? As vmcore is doing?

>
> You may need more flexible ways to get the address lists down the road
> because not every driver will be contiguous, but that should still be
> one action.
>
> > The vmcore case does something like this.
>
> vmcore is a true MIXEDMAP, it isn't doing two actions. These mixedmap
> helpers just aren't good for what mixedmap needs.. Mixed map need a
> list of physical pfns with a bit indicating if they are "special" or
> not. If you do it with a callback or a kmalloc allocation it doesn't
> matter.

Well it's a mix of actions to accomodate PFNs and normal pages as
implemented via a custom hook that can invoke each.

>
> vmcore would then populate that list with its mixture of special and
> non-sepcial memory and do a single mixedmem action.

I'm confused as to why you say a helper would be no good here, then go on
to delineate how a helper could work...

>
> I think this series should drop the mixedmem stuff, it is the most
> complicated action type. A vmalloc_user action is better for kcov.

Fine, I mean if we could find a way to explicitly just give a list of stuff
to map that'd be _great_ vs. having a custom hook.

If we can avoid custom hooks altogether that'd be ideal.

Anyway I'll drop the mixed map stuff, fine.

>
> And maybe that is just a comment overall. This would be nicer if each
> series focused on adding one action with a three-four mmap users
> converted to use it as an example case.

In future series I'll try to group by the action type.

This series is _setting up this to be a possibility at all_.

The idea was that I could put fundamentals in that should cover most cases,
I could then go on to implement them in (relative) peace...

I mean once I drop the mixed map stuff, and refactor to vmalloc_user(),
then we are pretty much doing that, modulo a single vmalloc_user() case.

So maybe I should drop the vmalloc_user() bits too and make this a
remap-only change...

But I don't want to tackle _all_ remap cases here.

I want to add this functionality in and have it ready for next cycle (yeah
not so sure about that now...) so I can then do follow up work.

Am trying to do it before Kernel Recipes which I'll be at and then a (very
very very needed) couple weeks vacaation.

Anyway maybe if I simplify there's still a shot at this landing in time...

>
> Eg there are not that many places calling vmalloc_user(), a single
> series could convert alot of them.
>
> If you did it this way we'd discover that there are already
> helpers for vmalloc_user():
>
> 	return remap_vmalloc_range(vma, mdev_state->memblk, 0);
>
> And kcov looks buggy to not be using it already. The above gets the
> VMA type right and doesn't force mixedmap :)

Right, I mean maybe.

If I can take care of low hanging fruit relatively easily then maybe it'll
be more practical to refactor the 'odd ones out'.

>
> Then the series goals are a bit better we can actually fully convert
> and remove things like remap_vmalloc_range() in single series. That
> looks feasible to me.

Right.

I'd love to drop unused stuff earlier, so _that_ is not an unreasonable
requirement.

>
> Jason

I guess I'll do a respin then as per above.

Cheers, Lorenzo

