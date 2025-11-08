Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0646BCCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 17:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B728E000F; Sat,  8 Nov 2025 12:09:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 303368E0003; Sat,  8 Nov 2025 12:09:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB258E000F; Sat,  8 Nov 2025 12:09:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F36428E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 12:09:33 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9334BBB65F
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:09:33 +0000 (UTC)
X-FDA: 84088076226.01.EE671D7
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 47DB8180010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 17:09:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=evyQ43f9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ugJLMimG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762621770; a=rsa-sha256;
	cv=pass;
	b=ZoaFUTVLGvuXASjwXHoHC2VMIU7L5OV2AqzGR1PTRwK4t+uDHXjmsIidn6c6yGdP0FWBYq
	XCWNRA2X+XGWLgfqIEypYQhessrDebUWaDFrxJPK5HpNB6gFTtZILa0PnD+kS31411gP9o
	2OinmzJ8YfRZcJ1IiuYsbmpwfpsqtoY=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=evyQ43f9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ugJLMimG;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf24.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762621770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=O6JnQiIXMwssSOzIXbs4Kgb9ev2ULFIBnIdq81JGF2c=;
	b=WLuDUdvvsNJk/VDYjyn/umWoloLrJIQVxUoP7WWJTiyMDY75aFTuwwxHniLvRyb7DxVelM
	CNxwkAG/ZrDaDwzpI0UWJLqGFP4+zBJGyllAH3lZXPApfiW+b05iceQ5N2wGcCVS5M6rlY
	LsH30sNq1Iql60hDx6r34iG7VvHAkWo=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8GjT4v017275;
	Sat, 8 Nov 2025 17:08:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=O6JnQiIXMwssSOzI
	Xbs4Kgb9ev2ULFIBnIdq81JGF2c=; b=evyQ43f9RXmpNsqbAOSS0uOt9brdTiTA
	jSEi4YwtP0Ef/eWts2ljYJ9IqxNBvHnNj08ot+VtUPF9HvVyaC5GnXbE9bejAxDs
	EXtR7cTcoAgEzkR6zu80MUktMAhh9NYENIWyu7wGTbfmVFiJiHy6sFqXtmcgBp+g
	f1CxutGsH6WxPElmeVJR5dewb70fRqmDQ/gVe2TRYU4kzVdWIUchiqXOVEVo2NQN
	6RotV0lU+dmCsVVt8so2KTlTK1xLU/VaWtclxVNTcQmEiCZLUDPSASUl5s4jQCjC
	hmDi6aSOvb2dFIitAy1kbZj77EBfcmu1iJq2ULq0IGuKaDboO+at6Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se01ua-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:08:56 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8B7Vn6040113;
	Sat, 8 Nov 2025 17:08:55 GMT
Received: from mw6pr02cu001.outbound.protection.outlook.com (mail-westus2azon11012007.outbound.protection.outlook.com [52.101.48.7])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va6pstt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 17:08:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o2jSsmV5tTOvbOH8BN1lV5BhZcArftjnmiaxPvMJH8AGkG7WFLuBsQhR0uU1Ju1MpHDEEtxsJ9hL3EJEaUQtaM4vNcxJ7CHD9OyoowPk9JZ5gapjiloaPdyQy7m0gjdq43zS0LKTs1Xs7VCQM+/rE4oI0dWdJf/2J3ovCrKjFSgd3oRVJFuu8HemL07TGMQe2gSYswAlJlb3zl6lhsTpy6WDVjrwNPv7MRj8kz9m2p+Xy2+T4FfZv8uxqIKzqGS3qhhPIyHm7iPD6MPBf91iRfx8XbDq9BAG14fG6TLwZnDM48HIHF00Tb/xO6yGYpW5D37lLH3eSq9eQmLCNhHnKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O6JnQiIXMwssSOzIXbs4Kgb9ev2ULFIBnIdq81JGF2c=;
 b=f1X/ULVCiPS7vkTsdN27S1XDS5g2jVBWKST3WRc33Ad09H7MIb03Hs4uxUZ69G2WBq/pvLAq637Kbd3b7j56/FN3Gv0Gy8iu383UrdDrHeB5VxZqm07+2cvbJQkZmrG3P4CDccWV40zsAjXtqH2/juaasV2jUeKFIihrttbvDR8YGWtYTx4yDMq7i/6X/fn3Y1hm4Q26drAae92cc7W5HpenaZfjH1McuhhT8R8h7XDx52+E/J8TWmbGyQqiyDiG/5sT8kcB1si2PxBSAmIi3Ke5q7QVlLZHdE7gvBjDAOsvS2UnZW/+vLHpdKmX0r0AQFoXiLyHxevQKLj41Q65zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O6JnQiIXMwssSOzIXbs4Kgb9ev2ULFIBnIdq81JGF2c=;
 b=ugJLMimGswIBQ4nMEvt5l5II/HlMvsUhuH373COsxzDKRy9XIz2FIpmAsMGBns9yp38VvU2URPY0WwmIOkgm1LKvU1s4CRWbqGLDpwTSX4kLydQSfxpcACpl2jff9PPUbuCUfF/rWygS3JwOd7DFX68m9pHJ/i/dAUsNDKYOW6w=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPF04D2D7FA7.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::785) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.15; Sat, 8 Nov
 2025 17:08:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Sat, 8 Nov 2025
 17:08:48 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
        Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, Muchun Song <muchun.song@linux.dev>,
        Oscar Salvador <osalvador@suse.de>, Vlastimil Babka <vbabka@suse.cz>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
        Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Alistair Popple <apopple@nvidia.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
        Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
        SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
        Xu Xin <xu.xin16@zte.com.cn>,
        Chengming Zhou <chengming.zhou@linux.dev>,
        Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>,
        Pedro Falcato <pfalcato@suse.de>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: [PATCH v2 00/16] mm: remove is_swap_[pte, pmd]() + non-swap entries, introduce leaf entries
Date: Sat,  8 Nov 2025 17:08:14 +0000
Message-ID: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0096.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPF04D2D7FA7:EE_
X-MS-Office365-Filtering-Correlation-Id: 81d1f818-c6fd-45d8-5219-08de1ee97b6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xemXka5lwyTH770W7DdhkmYfqcfDeG3cD2FJrbQKpUe8ow8Sc1Sp/6oPfwlD?=
 =?us-ascii?Q?wlNN8T492ZQRywTWgF6HDGKSBF3JPyQs8yGWAfVQ6hGypPhPxkDfUq7RvCyq?=
 =?us-ascii?Q?JJCG/0nn0YShmDM9/1jkzesMkUXzvPdm9MxRcZ1QmAVOlbv6qOz2a+lJDgjE?=
 =?us-ascii?Q?un6/C9sR31rgcFM74RUk9t89eYD0dV5FUpy4YovaAMS/OLjSTv9o8zJVhklO?=
 =?us-ascii?Q?4kJBRCvbq3KziN9zJjRvLKjWCisHwVdShOeHWVtk+P66LCYzGFeOa/V7S1Nj?=
 =?us-ascii?Q?/5Yy0EuXM4FZO2WfPMAVEPd6s5nP+C+QbAYZ6rS0Kg0h3MnSNJl9Ig7Tun5W?=
 =?us-ascii?Q?/AORDvEJXr+BQM819UOO8S0wqTKyxSw1AdwlAyh494Wfml20cpQaXL7KUld4?=
 =?us-ascii?Q?VrlVGGNlXUsGnhW4o//dal/jILyZc+xcZomkA1Anmi2ScNWyXEukRtfvFAP9?=
 =?us-ascii?Q?ZYWMyB0Gc0mCfkEUbNM5Fp5Nx1PeUajJrut+gujNd3ScavGrdURjlBLt8uW9?=
 =?us-ascii?Q?jA7dxLDYKMnh8taE+xPP7qdIOJ2nP4oyEDtJHlLhLylyMMXbS32uh69jqYCP?=
 =?us-ascii?Q?cAtqbnWn08UBhcHN3WlUyydTqRvFS+dyL/U9RGUyqeKbzCvufDTIBdAUWHK8?=
 =?us-ascii?Q?NXn6snEjXVhmxbkYd4Neo963OR0YeH9Eb2tx/RmZ75evct4BeI4sjRuh82L1?=
 =?us-ascii?Q?qDj87iVeWqzdZP5ACKzPS4AUu8lpJ1q42uATPxNXX2Ri0If2yJvbNptaIb7i?=
 =?us-ascii?Q?sdaFjIOYN/AO8/kf9V77LuFtuP3m6P4gayqkVlm7Z5mY5fvSxcUjpr8JdVbq?=
 =?us-ascii?Q?LvAisva7cm37zyK1/2sKXv6+ngqBnLTnhRVU8s9Qcrc9BltyYvAVAMLKJD8L?=
 =?us-ascii?Q?Awp3cVHF2Z0T0AYJYVft3nUpsg2aVw/UUVxiDJCR6yHs5i0ZdKY5Jhj2W09k?=
 =?us-ascii?Q?D3jlRXoCYsSlG4D+KBtlXAm5yudguj31My3Eh7CN156Tn6R+blzeW8PDWYzO?=
 =?us-ascii?Q?OCWYe9JsqN7yfaIqEgkntTlGPnJAxuocA5tukiqTMTwHmMa+Ligi/fxpMvI4?=
 =?us-ascii?Q?qANAiKM3YLTuxcYMQBo2DLa6nTBsu05n8bfCmWDM1/L2ouzZ6QKNTQ+rM3Qc?=
 =?us-ascii?Q?Gz3Q50q1eL0Nyk4QEDmXmhGU7QxNjOmlwlsWPuUYqxBd53bCv43nKwmpf5a0?=
 =?us-ascii?Q?RfV8D82rSYRmEgI9fnnZv5ge01Rbo+Gva/pZpDnDPBAEPK6Epl76w7GLkINp?=
 =?us-ascii?Q?vECptpgQ38pO0zBKkZUvN89rmTZtahEkEU+JhwfImyY6fEif4s8W37tVsrIy?=
 =?us-ascii?Q?QYc+vQi5R4ewC5gzumNvTmxpVZXScFFvQMWW4VYON9YeQt7anuW3TFSkdAKf?=
 =?us-ascii?Q?74PIyPwGhlb+nVGY8Pg6YQ6GJ+2AuZefIK2mFRILXzPu6eC/aZgwgIo+sZkf?=
 =?us-ascii?Q?nZ8rZkPPaLL04buv6l6dUXgLYaKTLehotHLA2Oz7tqidxZn371Kawg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bESCjY2G6fWBpp5TSaPDHj7ba+juiGkgW/3zrHlKf36sUSLcfBq1WElPv7kQ?=
 =?us-ascii?Q?Cj/xMKNtLBRQE/IAKABwev0UIOS9ayy4gVRuoxy+YWvmErU9ijaF57MzqmVM?=
 =?us-ascii?Q?xUNwsZqt6oDa32+e6R5OEdb0n46YgcKgj0ziDqjC7bNQi5EZGeNtlXrO9vFV?=
 =?us-ascii?Q?BG/moN7zjuG/mCwldAXNdMIU+899ASVZ2BRvfwj1WpnNnOD6tUFKZ4IGP+Xf?=
 =?us-ascii?Q?ddqdjR9l4+O5lC76maw5gTe1LqCX8VI1FO0cMMu+2b4Uy+cIufSCipC6G2Q5?=
 =?us-ascii?Q?pjliWGWr4r1tUHXaAnGx+j1C79w9BUD+Vx0Hz8KZBEXaTegQ/UR7Glgqzmmg?=
 =?us-ascii?Q?r8kPI/f/oBoj5JxhqyKVkJVeSeKqLFaqDqRKtG1sMmLAEw1Pkv8YK6BMoS5P?=
 =?us-ascii?Q?xmtgAlkDK3RfkGelxev1rEvTxDy2N7Gsr5Dq8UAmQPoQPx+4HCooLhnQesL5?=
 =?us-ascii?Q?05gVgJEQspAqMqr42J5E2u2VC6YcPuT6VfIZvrgiG7QD2+ueVOad9wQepRKD?=
 =?us-ascii?Q?siULpDzoz1rZ2wTJ3puGE9E2TQMp7co9/ISnDBHD24+y6v/2ayJqQPcMUIjC?=
 =?us-ascii?Q?RuxivlIZdycBGEhASC4OTunZi1q8oCH0uwSnxmfMmm52gHUaosuNFzcgEwfE?=
 =?us-ascii?Q?PSlSbBH+mjMPflACXDcHeBCNDcaJp9yke4xOM+aXA/wR7WgrY46L2WQA3ctj?=
 =?us-ascii?Q?HTGML8AcIAVGvJvqzQKYX6KMkVROQYCvCPMW7N50bN6HeXEfF8PbHnWPicg2?=
 =?us-ascii?Q?OcZAzQOYXqW6nN8ULBVk3Z7VQq7brt3dFBsuyqb12YLscn5UJsT9jBIOKwbn?=
 =?us-ascii?Q?QCG6iP3et2y7dIPkV9zqOpNQJWBIwt2z/VWX1JDmyXGgCwpeZ0N2v053ehp4?=
 =?us-ascii?Q?K8J1r6+jFwTfs4AsehCrtlvvnIoyyxcIAj8ljWkXW7/A+YlMPaMUq9sWPNrj?=
 =?us-ascii?Q?EdD1N4a4wqrhPMS6hR5xo5mXiA4AWkfATE4ad/4g2YBEr6RbQt/dUtWOTj2+?=
 =?us-ascii?Q?sQoOhwSDOo0NGcenkgOwDeotEcONjj2OCOhDp3MakNfQk0zyVZxZfUxIX1i8?=
 =?us-ascii?Q?Kts+5f8Nb+UwO9ib6A763nUZLR6nyA7KJVlvf1IulUOF346lvZjTasN655kf?=
 =?us-ascii?Q?27gYGtdCYqErypWf0KiySYh4OkUC1ahgYV9T486BNzamhUU9yv7xos0RgdRe?=
 =?us-ascii?Q?cI2ICk0/Yn2ypNmoEhEUmI4VYMwEHD9+pmJhMo79ppYDU7XA56ftO50RQhAB?=
 =?us-ascii?Q?1spVOixBRkdyH0S7MjTvhJbasqq6KRy0r1wNKvUCULlob1VBldjXTBkMo2ZJ?=
 =?us-ascii?Q?dBHJsDuz0yWs4nkPNexVnKg1hyc/dVuaAyhiEM7baaNMyYIlhzN00FQH2kfP?=
 =?us-ascii?Q?LWkLuJGS0ouE/w3+hFByhgMBRUlSqyIpS441Si0AIqKiJEAGOM0TZGpMG1QR?=
 =?us-ascii?Q?b+edc/Tu2zj1sf5w5y23XhUYDxR4rGoU+4d6+E3nHuCCgNNgnS0DFgTMQIqe?=
 =?us-ascii?Q?IhwHZURfrMGsENeMM/7Rs5jG1E8lxFfHWtbZo5OnqBSFEez4qTSUAlBaAtvE?=
 =?us-ascii?Q?Gsz+2ZpMKC+iF7oFSFdTDWhOC0OY1r7LQY9oD/IRzARj3Fxe0Kmx4OsuWbgz?=
 =?us-ascii?Q?Mg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	G/WUtttnCNnQqKNCY0tIKDpujssPWQ0p3kbhzzaSt3iMC720je6omI8Iz9qV4/ztrmeCKb5GlGLtOpCi5OQp1yH8ZphqLR5YkuCY9YHCQLu5TOyUv9mHwjMnipsrFW5JpsRONJFoBQ2Z/MCQ8TLgWsxinMWY/3pBVynknZfVoNKUi0dSfWEWfOcLOQ3M79HF85CkzxaoGSO3/lGlfM3KXzCeR9aJs1kcZNsiJQ1ygZpUUB/s9TmlaqfjvaX23PkMHl2kDwunMpHQ2uY7LELl6szqxR8NMklW5fcxwODt+EBjlIUM49Vvu6lNQRn/B9ab0LLyQsCY/mpTVavhYBvUiqxJdbzIix3VZvRkdBnU4Ib3z7Tjh3vYIEv0190gEFP+NS8VXyiPjjiCTMxT/3yrvPxfF2wCSfdWgIYK4tVyqBT+IZrm6a8tfk4wzZ0oF5JO1O8N9VhsD6RkAurA+OE0mg8yB/i3+Xhm+i0JCCn1usrmN/nI7eaK7CYOybXsUmvP4ayukx+/toXFPBXGeIPiFenpqHvKGdDWXhNgudmBkQkocCqhMtCNi1MlNranbPLdV6px4GWfs3kHGlwnfqJssyY0MuiK+qXEhYqceQL3WbM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81d1f818-c6fd-45d8-5219-08de1ee97b6d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 17:08:48.2090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XjU25Mtv8M5tBjquMffm5cSIxadsa6wrfp3vLmF5eTMprzSzM7L864WO4Macs7AyXh8VSsLiPhMgqH0SEgGJawifUPRTKlITsbm3FPvXYV8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPF04D2D7FA7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_04,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080138
X-Proofpoint-GUID: t7Z7yv3lQ0w_6E5kFhBUV5HlZVqFtzVy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfX2F34JaQfeHrf
 CoyDIiQTvI6QtlYj629svqLcorhYOeWwL6BRIqNpnwGdYOE3gvUcH+Tjheyo54w1H4M7ongFRBQ
 qCaR3Pb5eMLOYXDPk8Fq7SAe4j+vWP1QYdZMItJRSQnVd/y2SZq1XICktAojBDG2GqBGBcOuXEH
 9YxxVsr98/20Kyb+omqV0ICbFIwn4izq7DSIbehF1a17QfTY4eFYXSHoR5A6cqZaCuj5R+ckh1R
 5JggF0UEMurwrW07f7wWtJb77Z2sr+Rm1lJxgNPVBaoabYPyex8y97LIf6S5hYE5EfpviojtA79
 Zrf1c6avZwou6sQBzBaF1EekDPPntaGGnWt1XXZ/3g6EyZhZSQ/U5wvnV+kBzsHReDZgL0iwzta
 ulLN2Q2ynAuqDdyUcwrwO5+qvzzIoQ==
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f7928 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=G2-HCQ5rFf2ZBQrTsY8A:9
X-Proofpoint-ORIG-GUID: t7Z7yv3lQ0w_6E5kFhBUV5HlZVqFtzVy
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47DB8180010
X-Stat-Signature: x9f468e4aidrar6hf3fs3un189dgrs4t
X-HE-Tag: 1762621770-406371
X-HE-Meta: U2FsdGVkX1+l00AfHyDqiRB0SWH21PEmgJ34rPvKvDrFE47+e75gBAmyYSm73gl1cEBmCUOK9uSPruirDjHc+pM3brY7cxn4/BgHGBbG/xoHiGLrblK4axyvDYvoleerbVcuV9wbJ6mdmdhrY3VFxUwkv1k7aYaWRwpI+yTUyhZg9URyhvzNoyQ1zlA2Q7qPqAH0jLpCWDiDLjDbqX4zPAbd5dMiiTLhgwhVKpqrFVMasK/f8gUKPuYdJMbR+W4xIHoP9a3BllOExXQEXD+X0swBy5+FUMz619rO5E/R2BsUdViN2q48Wq5XAy7wiHR5rby95cZQiR1i0LGQpa0QPlw9UMNVeMbzmhl5RWZq/E6Dz3TkiCDwzX5635+PRwPtVQ8nQMgUQA9nRahsyoGQx37jj2i7bwt64Pz54q7pVCPmqNAG8E2RffamgmIzW4a5wjOPLg0Almsha0ZvyePuQJkkskFr5XrZyd595fv47c5+shryAOPULR2E8Lm2MGC0F7n+EdDzeZ2XYiJPYLq7p39E+C3d/F/RpmiEOA1lAaYTtGgjqgsQ+S9P8WNMGL04eUHoF65W28Fvy0YcHGse6w4h084LNlkik4Z+Qa7CeJynnmI+du++a9pLFj+vMire95oBbvskja9pJmUMQS6PQv5yvElHxYs7inWHyFfMJX966QXFRtHusdZOdYIIYL3qz0YDUjd8Q5nmzZmr3pQ+y/Dd0vG786t9TDAdDkb8GOFId1hCoCzKMTw6IyRBNPg2OJnRvBuFY9IS5xR8m/FfpgZ+erkHy2DyA3iZlCGSktoePleSJADcPmSX0+HpK/lArXN7O3EuzqofFrSFwcyiHzYI/B+Sp26McyMFfoYymTGR5wCTLsYpU45rfX/svXyD6xFX5pusaF+v7/jmWEbBzjak87EoBFdAFTOvnoRugDwlffq9jcYAJNYMCvoeN0KJzRxub9rRh/bkgC7BqYU
 Dq69+hyB
 IRDME2KFS9O3eaUzhM76mdV3oiXu0FJMmXi7UT/Vec99CPG8EpkcNtCQzHG7Fo7v0RsJWzhtlv3VQb1ydpwhYFDdfu1bZYdZnkrN2Z7vwQ2r6pl2b6v32/5yKZhxP38XeR0vvBkBq228wB6YGzI1Bqiz9dSqXRDQ94jnBBhDM/IFYvkrgwwKueO1JSIj73099VCUH7WP2C2rIxxXqIoD81nrW5OC5bn8/nOeOF/JASzuG5I9nxH6dfJqUfJ4j5dIkFAZg84FkNRvsWvFA7u0RycokMk0eqXoBx44VKJON98eu5Qt4GjX2iFIVdSKTub6Fm6FBL2JqNUAadiHLgVycNLTRgmBZDnP/I16xylS9rfnVgKurTZ8uyAt0qkmyzHdoeK/Mr4zrjFsiAL/XBxb4Y42e4zgb0cGav7oUbVmU2rjcFjflRQ7jVOiUQFh1MWmM04rD5QpPqz0/oHXjFZ59HPjoGCJiMoEFe4AibeUvalAXxKaXB+zgq/NXWdtlxSzaYjtd09kHP0jdaIZHVjYrSIBivEetryUoJdJWjo26PlT6X11ofLsmjy36LxO1+EMwLg8SlXyNJ8AmVIKhXHL8IXqRnHlJhhYEvqDL24U9aXKqsqU2V1WGGt7CKuT/v+JYzVDOu4TlSuQHD2S9Zc3ReNpahIohWEB+Qbys9ebhWTMFp5c1FXQct7c7M6xvQKPcdMb+Kq2iq6D5GKRggc+dq7Dk5LuRQjvPkJJ+EZ5fuV4jsVeShML7n3xeukmiGaprLUxlk48FAY2WuhZimWu/7A/8uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There's an established convention in the kernel that we treat leaf page
tables (so far at the PTE, PMD level) as containing 'swap entries' should
they be neither empty (i.e. p**_none() evaluating true) nor present
(i.e. p**_present() evaluating true).

However, at the same time we also have helper predicates - is_swap_pte(),
is_swap_pmd() - which are inconsistently used.

This is problematic, as it is logical to assume that should somebody wish
to operate upon a page table swap entry they should first check to see if
it is in fact one.

It also implies that perhaps, in future, we might introduce a non-present,
none page table entry that is not a swap entry.

This series resolves this issue by systematically eliminating all use of
the is_swap_pte() and is swap_pmd() predicates so we retain only the
convention that should a leaf page table entry be neither none nor present
it is a swap entry.

We also have the further issue that 'swap entry' is unfortunately a really
rather overloaded term and in fact refers to both entries for swap and for
other information such as migration entries, page table markers, and device
private entries.

We therefore have the rather 'unique' concept of a 'non-swap' swap entry.

This series therefore introduces the concept of 'software leaf entries', of
type softleaf_t, to eliminate this confusion.

A software leaf entry in this sense is any page table entry which is
non-present, and represented by the softleaf_t type. That is - page table
leaf entries which are software-controlled by the kernel.

This includes 'none' or empty entries, which are simply represented by an
zero leaf entry value.

In order to maintain compatibility as we transition the kernel to this new
type, we simply typedef swp_entry_t to softleaf_t.

We introduce a number of predicates and helpers to interact with software
leaf entries in include/linux/leafops.h which, as it imports swapops.h, can
be treated as a drop-in replacement for swapops.h wherever leaf entry
helpers are used.

Since softleaf_from_[pte, pmd]() treats present entries as they were
empty/none leaf entries, this allows for a great deal of simplification of
code throughout the code base, which this series utilises a great deal.

We additionally change from swap entry to software leaf entry handling
where it makes sense to and eliminate functions from swapops.h where
software leaf entries obviate the need for the functions.


v2:
* Folded all fixpatches into patches they fix.
* Added Vlasta's tag to patch 1 (thanks!)
* Renamed leaf_entry_t to softleaf_t and leafent_xxx() to softleaf_xxx() as
  a result of discussion between Matthew, Jason, David, Gregory & myself to
  make clearer that we abstract the concept of a software page table leaf
  entry.
* Updated all commit messages to reference softleaves.
* Updated the kdoc comment describing softleaf_t to provide more detail.
* Added a description of softleaves to the top of leafops.h.

non-RFC v1:
* As part of efforts to eliminate swp_entry_t usage, remove
  pte_none_mostly() and correct UFFD PTE marker handling.
* Introduce leaf_entry_t - credit to Gregory for naming, and to Jason for
  the concept of simply using a leafent_*() set of functions to interact
  with these entities.
* Replace pte_to_swp_entry_or_zero() with leafent_from_pte() and simply
  categorise pte_none() cases as an empty leaf entry, as per Jason.
* Eliminate get_pte_swap_entry() - as we can simply do this with
  leafent_from_pte() also, as discussed with Jason.
* Put pmd_trans_huge_lock() acquisition/release in pagemap_pmd_range()
  rather than pmd_trans_huge_lock_thp() as per Gregory.
* Eliminate pmd_to_swp_entry() and related and introduce leafent_from_pmd()
  to replace it and further propagate leaf entry usage.
* Remove the confusing and unnecessary is_hugetlb_entry_[migration,
  hwpoison]() functions.
* Replace is_pfn_swap_entry(), pfn_swap_entry_to_page(),
  is_writable_device_private_entry(), is_device_exclusive_entry(),
  is_migration_entry(), is_writable_migration_entry(),
  is_readable_migration_entry(), is_readable_exclusive_migration_entry()
  and pfn_swap_entry_folio() with leafent equivalents.
* Wrapped up the 'safe' behaviour discussed with Jason in
  leafent_from_[pte, pmd]() so these can be used unconditionally which
  simplifies things a lot.
* Further changes that are a consequence of the introduction of leaf
  entries.
https://lore.kernel.org/all/cover.1762171281.git.lorenzo.stoakes@oracle.com/

RFC:
https://lore.kernel.org/all/cover.1761288179.git.lorenzo.stoakes@oracle.com/

Lorenzo Stoakes (16):
  mm: correctly handle UFFD PTE markers
  mm: introduce leaf entry type and use to simplify leaf entry logic
  mm: avoid unnecessary uses of is_swap_pte()
  mm: eliminate is_swap_pte() when softleaf_from_pte() suffices
  mm: use leaf entries in debug pgtable + remove is_swap_pte()
  fs/proc/task_mmu: refactor pagemap_pmd_range()
  mm: avoid unnecessary use of is_swap_pmd()
  mm/huge_memory: refactor copy_huge_pmd() non-present logic
  mm/huge_memory: refactor change_huge_pmd() non-present logic
  mm: replace pmd_to_swp_entry() with softleaf_from_pmd()
  mm: introduce pmd_is_huge() and use where appropriate
  mm: remove remaining is_swap_pmd() users and is_swap_pmd()
  mm: remove non_swap_entry() and use softleaf helpers instead
  mm: remove is_hugetlb_entry_[migration, hwpoisoned]()
  mm: eliminate further swapops predicates
  mm: replace remaining pte_to_swp_entry() with softleaf_from_pte()

 MAINTAINERS                   |   1 +
 arch/s390/mm/gmap_helpers.c   |  20 +-
 arch/s390/mm/pgtable.c        |  12 +-
 fs/proc/task_mmu.c            | 294 +++++++++-------
 fs/userfaultfd.c              |  85 ++---
 include/asm-generic/hugetlb.h |   8 -
 include/linux/huge_mm.h       |  48 ++-
 include/linux/hugetlb.h       |   2 -
 include/linux/leafops.h       | 620 ++++++++++++++++++++++++++++++++++
 include/linux/migrate.h       |   2 +-
 include/linux/mm_inline.h     |   6 +-
 include/linux/mm_types.h      |  25 ++
 include/linux/swapops.h       | 273 +--------------
 include/linux/userfaultfd_k.h |  33 +-
 mm/damon/ops-common.c         |   6 +-
 mm/debug_vm_pgtable.c         |  86 +++--
 mm/filemap.c                  |   8 +-
 mm/hmm.c                      |  36 +-
 mm/huge_memory.c              | 263 +++++++-------
 mm/hugetlb.c                  | 165 ++++-----
 mm/internal.h                 |  20 +-
 mm/khugepaged.c               |  33 +-
 mm/ksm.c                      |   6 +-
 mm/madvise.c                  |  28 +-
 mm/memory-failure.c           |   8 +-
 mm/memory.c                   | 150 ++++----
 mm/mempolicy.c                |  25 +-
 mm/migrate.c                  |  45 +--
 mm/migrate_device.c           |  24 +-
 mm/mincore.c                  |  25 +-
 mm/mprotect.c                 |  59 ++--
 mm/mremap.c                   |  13 +-
 mm/page_table_check.c         |  33 +-
 mm/page_vma_mapped.c          |  65 ++--
 mm/pagewalk.c                 |  15 +-
 mm/rmap.c                     |  17 +-
 mm/shmem.c                    |   7 +-
 mm/swap_state.c               |  12 +-
 mm/swapfile.c                 |  14 +-
 mm/userfaultfd.c              |  53 +--
 40 files changed, 1560 insertions(+), 1085 deletions(-)
 create mode 100644 include/linux/leafops.h

--
2.51.0

