Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F630CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A690B6B0011; Wed, 10 Sep 2025 16:23:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19D96B0012; Wed, 10 Sep 2025 16:23:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA806B0022; Wed, 10 Sep 2025 16:23:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 791206B0011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:23:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44AC757980
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:23:00 +0000 (UTC)
X-FDA: 83874464520.19.3EEE2C5
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB755160005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:22:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lj8xAgLI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=luJiU53S;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757535777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cG/XxwNz5xQssOe9Mru2Eu/iCohBsLiNJ9+rdrZYTo=;
	b=vh3bN9+fR7O1jeYMNUhBsyM+h0NiZn9ffzdJLeG66DXv55kWVjo+vXE4WrLqr0jCkcse4m
	QJb0UMcvKCYFYsySiynYj4S8/O7RtSMJd6PozzN9nZjIImn3kheKdzxm/5gKvbl2ugaF+p
	TuRf2JIedfzCSYGvY9WmXCrawcXRe1I=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Lj8xAgLI;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=luJiU53S;
	spf=pass (imf08.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757535777; a=rsa-sha256;
	cv=pass;
	b=4qGOFuutRuCr56CPUnhRYxevca4EJMkhWj+lBcu36zE2vVRGK3EWJtzTIydawsb90PxLg7
	Ya+Xg4P5FCn0l1FeCb1vHrbId/CqK/yc9MSlw8rNFOkEr9yjMQPEeXOJbtap5AS6G683Wx
	ZBAUf3g5M1guMCitCAIULWSgy8OcyJM=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58AGfiDh009732;
	Wed, 10 Sep 2025 20:22:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=0cG/XxwNz5xQssOe9Mru2Eu/iCohBsLiNJ9+rdrZYTo=; b=
	Lj8xAgLIWkEh0BNVFY4pd+bH3NZxLci7FZK/j6X2Xwh12KJNUdQI6nZLdOORpmGU
	BAkXWo3g9nt//ItZ+Sz9Xj5CzfqcFuklnS50xhf6q3HC+UMAKbDO8Q5/OX+IUzNg
	FeomKicfsiS0R5CoSGBToaAKFS5a/IHdlIa0lvo5mZM5r+537x29dQC6+mMriczl
	zjkQdmSrukzZ/qmFBr6QKD3PDVb88F6tM9Dq3CTl2kJ/tHsCKz/f4/l75XQ5rnGo
	5ijuvWHnqZ6CyeeKhEmPDD8xoD9APiLAn273eCODqJHJr//3cmoyPehwtRZ4ay4I
	86f+77cHE/KRNbDIODV+fQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4922shvv1r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 20:22:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58AJvaTY026078;
	Wed, 10 Sep 2025 20:22:39 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011001.outbound.protection.outlook.com [52.101.57.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 490bdbhb9x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 20:22:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Q6rRZq7/WihSnRViSUn84VUpngOtv2PpNx82xWZhePStJ2uatw4liElf61qO9nPqy2nnYHAFMcpdgFVseAblYTM3Gw99QH/hmmXWENGeQdihQFcldmpeI4zulfAxw6ydg9vJHc9HQFTt3UdM6B7wiPMiKQZ1pGc55/7Z6uOrzLahCwkcPJW/dfdNmkU0pF+bUkZEJ8hu5RMKEKg9Dv59Ue75hyur80EadsQ+2GBCW62yOGfh5n3bTjRzznNm9m8Dn+43xrlnKPncZeHDQWA0flaGaLkrrSg6Gcpyt9OHsGarQhBWIvmXBdNi8CF6GdBNlot6HFI5PISfVmbE6nBlJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0cG/XxwNz5xQssOe9Mru2Eu/iCohBsLiNJ9+rdrZYTo=;
 b=PpUtLVwthEi25soaJg7PKAdNIkKxExocmlxIoIti/kwBrR5hk6lHa2ROjP9i7PXnbyhzOcTSsWgxiKK3/FuhM6BYcASLWwVRaQjaR2w7Daj11eix+JNf6QOfg2MurWbuE8Acbhc1Z5/P4T31B/mOvN7zehD3AhHDThYXZ7eizcJUklrfgzjnc/AS2+vx0UCeSGDBvbl0c4UcQxMRDjtlUTjTFzjxvuDFgItAcPQc6VgKq9aK/aeVMFi0CLmHchz2ThVcz+8UZ01RcrtR/MVdDqX8buDPNZe6UdzLmm6jbxQckbGuHerdErXBeejUgiNgRJS5mWuP2u6wVoTmBb2B1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0cG/XxwNz5xQssOe9Mru2Eu/iCohBsLiNJ9+rdrZYTo=;
 b=luJiU53SG9w8xepgigdlIS4jn7FI435dGlHfZXlPUlxp2IXTbEOU5HKS3V31cW2uSDVgfXagJxyLq3JDzDhZttmAqHVLAE1Jv/eJcYZkokr5erExqrhVrN4QbnXy4/GLCYay6CK4hrFWrz2RLWX1cayQQX14MYH+OKuxTJzpFq0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CO6PR10MB5789.namprd10.prod.outlook.com (2603:10b6:303:140::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Wed, 10 Sep
 2025 20:22:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Wed, 10 Sep 2025
 20:22:36 +0000
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
        kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v2 03/16] mm: add vma_desc_size(), vma_desc_pages() helpers
Date: Wed, 10 Sep 2025 21:21:58 +0100
Message-ID: <5ac75e5ac627c06e62401dfda8c908eadac8dfec.1757534913.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
References: <cover.1757534913.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: GV3PEPF00007A88.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:158:401::615) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CO6PR10MB5789:EE_
X-MS-Office365-Filtering-Correlation-Id: 80c6830d-5a12-45f1-1b9f-08ddf0a7c7be
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?RPpCrNp16cOF2S7rCLqWC0KWR1dIx03OZAFJJgwpcW4/8IpXlAktM33Rb1xq?=
 =?us-ascii?Q?ibwdcduAA/gVEebSoQbhtDUnJfHcF6pPp6O8vBJDMyyLseZ61Pxvjko6In8M?=
 =?us-ascii?Q?ptjfftnMSRuMhuRXbs3dd5wka+LLriga9dtgUqLwdfdlCS0RwZO9znvv2ZMM?=
 =?us-ascii?Q?ODvtmWCxvxMm78R3yXUGH36ulIKwGwvuyj5yadO+YNZi2KNOo4oV1Szk3hxR?=
 =?us-ascii?Q?AJ1zbJ7BGXFiOD6mJt7xXplkHEZPVfxSCl6jx3S1p9698Il2Ighn55iv/5YL?=
 =?us-ascii?Q?yE2hQcaYnYhAHv7S92ML7CKEK5UGzXSdL6SnX2ApUIhmdG9pBhrlm9ZzNeUo?=
 =?us-ascii?Q?rZ/LcXmzyUZpbYBEDLY6L5O6vIYtj2tVBZlRBuIyH/NN9PilA9iKWfhAO83+?=
 =?us-ascii?Q?E+PptIVkOr2TG2YaJgaJMppuzNVPV8+3pK4y9kd/gNx/al/jcu3zaqj5R7RD?=
 =?us-ascii?Q?Nvpf+sTie8kg8VKTC5HBPBS7aoFaOq9LKRmIrjWvmlEbcCVmP3Jzw1X+M0Fj?=
 =?us-ascii?Q?fr2Sm0PDfnsWRCOi8CxzixWcBPbbizZzC/3lqRFSzQzIiiSQNuFy9ENtEoWy?=
 =?us-ascii?Q?xMnSMNgU+brwgJbCpsohjyolOSbKcqovhMcdd6evY3LJlpVSQl/zJ/J2a6jh?=
 =?us-ascii?Q?zp5iqx5fDcouoWPe3pni++dGFw2PW34qWjDJrK25ufwf4ur3UW6xIfyOacjz?=
 =?us-ascii?Q?Fg19I5PMoaRv/8vEgVB22wUwTyMCMfMJ2YwzkMuAxiXoTd9MvIsrfq3gynVJ?=
 =?us-ascii?Q?Oo1WeUC5V5QVPv79dQikBm6p2wKggJ0soQ+QyYf3sDD043DOdPxhSxbdEAI/?=
 =?us-ascii?Q?z1kRTXCmnhELNrz04rzPPgZAJjsM6sq5aZ/j1A0wU9x4+aBdp6Rl96QBn4N6?=
 =?us-ascii?Q?o9CSepY2eIYL18k7JoxppkIq7Rha84YifmqhM1DuI9cXepfh93Q6IfdPiDKk?=
 =?us-ascii?Q?rdE42Y/pi3FTlIvxn2+ToXBwwNlBfPtafWYo9Sgx7r6y/ojCVLEhQ1r4EIEQ?=
 =?us-ascii?Q?T+yeCLFA3a49JAuE1K+56cSoO02jRYrdkc3ehRyTtTkfEqKCN0T4PXA1+rDr?=
 =?us-ascii?Q?qeJqKotH6eVFTg1bksjZFeDS3iGzKWIXbJCwXqip6W6MRgN6FomFBA11UlO3?=
 =?us-ascii?Q?/eeHPYOb1acNRlHArBcIs1h8l+DzCAJO4VO2WyfVIGwRg2z8YjeSqN2mfm/t?=
 =?us-ascii?Q?K3Jqc/zpmZPlCdR7UM4lzzyYh52+NaZAzea3oeQHlnChG29KhJn0rmkP5kHw?=
 =?us-ascii?Q?Hg1wc4sp9VgLx3gvcB2OV6ZSUgFFMtx+xj4JIv9VxsSXChI5SWt9GFeCklH3?=
 =?us-ascii?Q?LWqsKQ4fzdrSbA7lO635/GRJLcNnRxY1bAB9vmUWdS8VJCjVwQhcotvIWkwz?=
 =?us-ascii?Q?lZWsjpecqRgkrOZEe65QP+2VO6wVJzd0j16MPLDxLjjAVK6lCGkJ7sD2VUA1?=
 =?us-ascii?Q?Ss1YY94VI0Y=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/cMYCpoC9cubvWYVx+Y4H8PT5er2B5xWMu6RQkf0Tt3lzygJYio3MaPsBpaN?=
 =?us-ascii?Q?tlh0C7+IqSZbTBaNE0qRrBpiE6lm2szbD0+7B8arUlNbggLu/PRxJ2TDLOxE?=
 =?us-ascii?Q?9WkYV19T0mK+yscuxdISVBBWJHdQk0aIw5ZrerV2a/Nq3NNFOYAXVtFMSa8q?=
 =?us-ascii?Q?RshYMDsStTGZHOluyt9HhYxWUkMsHM53kLxWYEWpZvBxnLCDOe9/v4Rtav3j?=
 =?us-ascii?Q?M4hzWfbaWA5BUPiK96cjgm6pDTBE+Gs2g9c2yBeWq4BaLVUnZBu3P+PdPPv3?=
 =?us-ascii?Q?v4zg9b0MXLPAJ/CQYJlqJfEnLh9brubbW0eRNwY/AMarxqaQkgFhniQFLyEL?=
 =?us-ascii?Q?CrGy8ajf80fqbozNQ2Cz0nWY79VN9pUde7PMLPEmmK0roaoPoZyAPS/MwBMk?=
 =?us-ascii?Q?eYfMaRMgwzEYEVyJn7HmRie5pHAwk1edsXJGzS9L+66FqQLuafrgtXEe5Fop?=
 =?us-ascii?Q?tEx5AIn38cE5DwDNVj1ZY0FeoAJA+7TPWeCUlvdPJqpVar9o1+B7kxsXj9vc?=
 =?us-ascii?Q?4zazp3EVWga9TnZxuqUPSlFrkc3IoxAQM9vZZ4cf7WUGYxVJrdg5hHZTtfYx?=
 =?us-ascii?Q?4sx3OeuMTZq2IGu5pGeT5Vo05me4rBivU2b0xx0EVQ1rV/Q58sDC+BDhFqak?=
 =?us-ascii?Q?6IDpmmwLmwkLcLT/luhuNW7yoN4PTk6YvWlEfiNI7ICF+S7dcqPRC9UYH/0d?=
 =?us-ascii?Q?FlHew4G9jwFU/dW7PEoOiotScZY11EPbHxa5Wko3PMX6KJ3/yHiFKsPirBUQ?=
 =?us-ascii?Q?yoZ352hdzNFYmlxvL5bp0iRq9Bl3SPVg2Hkgi0liCOCedD1aSU8kSKB+6fUI?=
 =?us-ascii?Q?IjKv1R4/wi7m6Oqk9mg1vGPHs9H61w5KcNi4dakgYj57l9JWAgLU2ZVEPKIK?=
 =?us-ascii?Q?8IZwTObwAi/SrC7bMVh2EMaPCnPRA8O/I9J1guxZmEg7RlMSXL33dalC7dfd?=
 =?us-ascii?Q?LDxraB00JQpgifuS0X+YYoaSKkSQgjsIdhXQilMHHyrTBvbwDvhkGSPy2eHD?=
 =?us-ascii?Q?mz2zznLSQSyErWVaTKLOWtbZZCS51E1FcV7w+T7DuLnXvG40D6CAqxdSgqHg?=
 =?us-ascii?Q?xvMgtHJfsFziDVKOPxkKOzKLownFem8gwywJgyiAenLtQRxrGX6cJsC5znUX?=
 =?us-ascii?Q?yK7K3gmifThlDGTUJWo5c6zIArCqQzV9hdJuO4wKwZ+q62O+Hh9H/UW9CgJX?=
 =?us-ascii?Q?EUldpRARVGcUSfLGSqvlClcOcbjUPTIrT1B4DuYDrGEW9mBVSjNTjlzArhmA?=
 =?us-ascii?Q?J7cqpAFMbz7sffMG0Puj2GzECPkwTCaz4vjZ7JR0B3mudas8VpanrsWDxEsN?=
 =?us-ascii?Q?RtJ2fKomqWBPuxmbP8ueU0vVceyxzwp+nxTYQDJitCV+4LiaCU1bPEWkAnSa?=
 =?us-ascii?Q?I92pJTDL5w4+EqOrpMdlG8CCyr95nP/OPphTZ9cV+yfbpkcyQQa537TAUFo2?=
 =?us-ascii?Q?kPupAq3imLrFez2ERCA8BIZTVerGcF0oMpKQVj7YbxMjN/aVVu7V0GowRt48?=
 =?us-ascii?Q?Og4J4PtnEkN0AO364qyfdIM5SHnaxqkEgKzFXL4V3U9O/oP9rdiNiI/UkBcf?=
 =?us-ascii?Q?/MopYQVAPxRq2eJd5GUzwg/MtuLb8fiUyWyvjWsEYzubSylyN80A5ITLw2yq?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	e5QL+UltWhgNK55CQ4Vdx9W9ZxpSLyDyVK6fY9DCuovKgOOSapO3+bPIJQMtY5rj1R7/IqW+zEN+afxRwk4R5SlbtRG82cg8NR0XGhbSEGeazuXVWr2sMWKXE1iBqhG3gnFbtdJLy3CcmyLGDVaBSGXJJ5mWRia9gGc39EYC1x8Oc7TcnJksIl9J/mI6hfv2sBqkuTXmNAEF9dyL9ZdVwidMIpZ1FgnjYx9fvJF7ntkSdDtrcxYWGBTtQW3oeN1EUeaj3iqj/BWesfhjsfmb0olv/DpJJtCopsNx4A9gTRCr/FFAtuD9hF9UevmqIu8qDX36dZGJGvyNUnIOKj+m40TjxZRbK3SoINEPc2lbMum2muifWhMpQPoNRdw+NWl3xvrLPO/Q0CxwmaaGvTIGwH54UGVXwswdwlj5t5Src2OpWOjUJ7YNyIDqCxnHKLuL/lPRZ7wgBK97aDjHVjaLe4ol3TPNNaJd1rpVPsNO0ZERyDB1ty0eqrsUX8/nAYTRPsgO3J30PN32KpU09Koo+Z37XEy/suO+CZGP5fava4+B/9Z5fsTs/hWFF4Ip9Di5KDcvnjjr+3A+k4fhrKFq+BMKxPyOlakkit8CCjQgKiQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80c6830d-5a12-45f1-1b9f-08ddf0a7c7be
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2025 20:22:35.9639
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZMr4UfGVvpBLrDD9mwJEuoXh3Epd/aFmFW5cGmHA4YOAMVpamZ0QFdZPchXOxxFnFNhkrWAQDT/324pWRoA8J/WuXc9oOLOyrLljrhpQSY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5789
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 mlxscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509100189
X-Authority-Analysis: v=2.4 cv=esTfzppX c=1 sm=1 tr=0 ts=68c1de10 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=yJojWOMRYYMA:10
 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=V8PVCHvh7cpLA54rH4kA:9 cc=ntf
 awl=host:13614
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE2NSBTYWx0ZWRfX1r+yBw/PKBbE
 JuzNuRhiahSbCxapF6nIwYRcrkXrGSIdRS2sSsm6WRAa7/L2KrYgH6mfVgDlE0MWCi2YBtc6gMg
 BUfqzLtXYfi0tZqTlwhOeY/cHVuHMunezOPBMVkpB26PKVRz9C3KYLCUk+UHJr5hJ22pBVNBI9x
 X9FYTdDe08lEm/XaHJnxz8rlBQJt2uREWTkCqAfLhbuPkXbH+AsZfEL1swY0EJYOnp58oEb6GXl
 Xs6MeZ22kITolBXA8goNM85jkAjfuZw5/loSJcLjCiDH3Az4Yr0FtkIr5ccNATP9xCeHmft7ScQ
 0RDReZHdy7QRcMLgewFYAPuF3P8LsIOrym5T9RBPnJBDqulQ0FPk6PorV3CppYtScA/GD1X+Z6O
 7wPXqzd7WYgRrjs9NhoHVALUqqQhTg==
X-Proofpoint-GUID: 9zhFaUdicrhfnM6rPj9dikALdF6Jz3Wl
X-Proofpoint-ORIG-GUID: 9zhFaUdicrhfnM6rPj9dikALdF6Jz3Wl
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EB755160005
X-Stat-Signature: c4ck4ixs5gb37ftkput51qq1kkfu4dip
X-HE-Tag: 1757535776-438883
X-HE-Meta: U2FsdGVkX1+CW9sQABJ8yB4w4cx0y9nu3nrkXR0MkgrCEMolSIhJmno+ygLbFnqSqaewkJWaeFEDVfbrH0xYy92Dp0gh3c6bbgKn5Ia3nk/pSHJ/tNu9hjtZigR1zV+N1Vn1aSkvWzt14h9a/3VcwXDXqdL2Fkqa2sURjVMa4JR+CQ8xIA5K6phpusItNkTr7zVh/F5AHl8adgtbcpxGyWnlsQSGDUkxFQpPnx7grHmCTmBDU4UBY/JnJZ8t1f0DNhY3bRq/IzpdGMFT+8Gm29XXPYaLEarjGqaXmm0izPDH4HzpuSAYxAX/5LefMDxhK/boIV/3UO4qhztMJUFTM9UqWhR4wjDPzPArZpJjGTNU/Ir3vtwKRXU9gYzLhFgdQaWknYn6eqkkVTAmM2fW4BW8iQxU1JSyRZJClAXKyCobFsR7na7yQRIbCiLpSAokzWK0kk/B+Aefw3Lzd3PB+sImKmaVg/e/uVj1V6fsp+OgJYKFNHYgZzGtq4C//tteBW5ZQCB7oVUUs7W6wqzlGh/uIhI+f/3Yq/NMM2lKlfGjtTH6UZU2hu9RHZuOi5MIn7TAhQJAgNJiMhmb4zdSwp+ylKATADPSNlDIkY0VD00MRnmwt7/agd9lU6BsfGJAcC1dSLFzqs8DW1qrVTrMntPDPH+7HdfUzqi6CUWV+lkvFWQVpTl6PgnQ3MfF3mX/noGJPRylH6mpXtxYNbbedOx8wRcV23TzoWCFS6adjnlEy3gzY2tb8gBbEba3XplYSCkF0Tm5LE4zipiTumuKGzGRnmiXwI9bEPGZ7J4fiwIkJgJNxumktwHw2byddLF2Z01FGi3UgInAyiru+kq8ufh+4CtHmeDdZae3t6c3DFNZgys4hFIKB5UvprzuQp4M/uMxwJDjpIYs8wu15V/OT3s42XPiWS2VjVzLS3v4ogne90yNKWvJQqn9tWks7DmDPHDeFK+cdeBGhQ2Ruea
 uC99jkIr
 5UAWMSNQThFnQYzAapppxnpaThBEYNdnfIyMiu5Mx1DrLiM4DepTcYmkFspDgdMdHZVZzf9NOccV5XuiQrf/AxDWAjU5DUosVPB+i+t7I5H0xogQQDg9ALGjY/BNKVu5yVlezc0WWQvneY2ApFeJ6ZkCMDfpMxkQbox6jg32rH64RFM39pEADGggnB5Zf5x4Oy/39BEmWmd+TQmpPkQKYs7JaaELynbHNeTbV3RIV6ILhCV/CQ/MAYDzAZcV4wPJsEeKLQGcf5QNaYwJ20dQ5CIHYSqF/jd6+XYx6zfu5YkhwN7gpVh8wS4UjNL/UB2I1ktYiB1Pt5+jq9/qrsmw/2C1A6ewys0v08x2PNP8g6KK/xERDy+8/M3MZNeOnmRnqgvJA2XU6CmNfiWgj892CMwjD2urf9GklGDtDO/4jR+Y7JFvQiIlyZk2oHwDpoYfdJHpiVILGOJpTstoCc/qVF02CqrXb/f4e5dtE9f78Kgob7/o6IVOwerPfV06TgTOnIufsBKXD02n8aEvchT4jwv55oTDDMqLxR0aqUIxC52w8/R5tHPBMb+helg24+PP2ihQ0eIlcUftdrAq8Arb1eeiUSYuaV54gSdeYqWB+qmyiu6nW49IJMr0dEwl3tggjaR3i5YqQMsmouHiS95dt9B0gizz9eVXFB+QTtXlglcHCN0NQy7DWUGif2fIjiQGX14GI4zf/xOShDFvP+KdMBaqPsOIHfQAndSFzc5Nz+9Q5OIE8MRCkVIKa9cipYucKbrdJ33QGu/MY3SyBPC7DLzGOOUPrmVwk4l+HbQyXM4oNukY1P3iX28YoB2USKLUab6SJRvRdrjl1vnQIQV9Cgey9wTIXZTK7PivR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's useful to be able to determine the size of a VMA descriptor range used
on f_op->mmap_prepare, expressed both in bytes and pages, so add helpers
for both and update code that could make use of it to do so.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 fs/ntfs3/file.c    |  2 +-
 include/linux/mm.h | 10 ++++++++++
 mm/secretmem.c     |  2 +-
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index c1ece707b195..86eb88f62714 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -304,7 +304,7 @@ static int ntfs_file_mmap_prepare(struct vm_area_desc *desc)
 
 	if (rw) {
 		u64 to = min_t(loff_t, i_size_read(inode),
-			       from + desc->end - desc->start);
+			       from + vma_desc_size(desc));
 
 		if (is_sparsed(ni)) {
 			/* Allocate clusters for rw map. */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 892fe5dbf9de..0b97589aec6d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3572,6 +3572,16 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+static inline unsigned long vma_desc_size(struct vm_area_desc *desc)
+{
+	return desc->end - desc->start;
+}
+
+static inline unsigned long vma_desc_pages(struct vm_area_desc *desc)
+{
+	return vma_desc_size(desc) >> PAGE_SHIFT;
+}
+
 /* Look up the first VMA which exactly match the interval vm_start ... vm_end */
 static inline struct vm_area_struct *find_exact_vma(struct mm_struct *mm,
 				unsigned long vm_start, unsigned long vm_end)
diff --git a/mm/secretmem.c b/mm/secretmem.c
index 60137305bc20..62066ddb1e9c 100644
--- a/mm/secretmem.c
+++ b/mm/secretmem.c
@@ -120,7 +120,7 @@ static int secretmem_release(struct inode *inode, struct file *file)
 
 static int secretmem_mmap_prepare(struct vm_area_desc *desc)
 {
-	const unsigned long len = desc->end - desc->start;
+	const unsigned long len = vma_desc_size(desc);
 
 	if ((desc->vm_flags & (VM_SHARED | VM_MAYSHARE)) == 0)
 		return -EINVAL;
-- 
2.51.0


