Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F178CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 18:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84F088E0016; Mon, 10 Nov 2025 13:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826538E0002; Mon, 10 Nov 2025 13:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE3A8E0016; Mon, 10 Nov 2025 13:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DB368E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:35:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12B71B757C
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:35:12 +0000 (UTC)
X-FDA: 84095549664.27.9DA7194
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6857F14000F
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 18:35:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Wb0a+mo9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EMPFYcMZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762799708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KiDRl0PyRotocxPu5wE7nSduFq9Wv+tg1k5wGrAXptA=;
	b=UgZbCfGHsXUE1Lhqqy2WvwARBSr0uqvJ7+FeuzMu12fDcF2yiH3f3lVn8lgEEGHy00m7ue
	gb73ADQ+G5GIEjkAsdMLGAs/lBcqO3+wNoArZE5GWq7cWcmGdeml5FfCOdUmjKVU+/ZHt0
	cuWmkQWNurflcq0IxL3o6YKq4uJPsR4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Wb0a+mo9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=EMPFYcMZ;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762799708; a=rsa-sha256;
	cv=pass;
	b=iXtPrlkT4UK8n0qYxSlqaJOQmtWzL1EtjknRYIXIROKVoeMH9VD93J0iKVndAeZ2po1vjW
	js2rSuU7oLD9mzS5OuqYVs4LyeYwA7rZkIqdtwskERSiR8hJSBzxjAeP1bvMNh+3gQ59W9
	oF+4r2C/2WQXH8h3Czb0s1LyOTMNCWg=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAIP12U025759;
	Mon, 10 Nov 2025 18:34:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=KiDRl0PyRotocxPu5w
	E7nSduFq9Wv+tg1k5wGrAXptA=; b=Wb0a+mo9xNnOzprQOwi0IgAQnlSU53GSPp
	62dpVMm/l6TP7rJf4HwouchHJH7oI3ycoO9dkKdmVGV772A3Ryf2BxeiFExlueRY
	4twDIDfMidvkcAoD2yojf3R1H+vaCxOYSLR+MEcEpWYb4d7uQ3ebMbSmmQ47lg2W
	3yoLca/xeGWts41O7lyJSNkTcbbVJuVq/uyHkhs6GfvkKUXfM5hy7Vdfx4EFdsdD
	6GOInsG8FGmkTdEoYT2niGNhuk/icBg11Hapt+nr+Pi3nnp7k2mowLym8sODDL24
	ZHGSJHUpemTpmhFi/LgtofkiJdiVdJXo2LznEF5WK51z5MmnOqqQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abnaeg0ta-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 18:34:46 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAH20Po000841;
	Mon, 10 Nov 2025 18:34:45 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011042.outbound.protection.outlook.com [40.93.194.42])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vachd25-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 18:34:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HY6kSZrw/c7xTckI68b7d6a2OVigBYixYaJkuGgRquq4mT1kZrZVAvomCg0rcVOxfcDtkBQkQv9f9nLmbPFSI5znc/upPxhwLJiET/IvjSPoJEOjZIc2srtsv/dxEWA39dry8tx0ZqtWvvKsi1zQMEVPH2z39s9OtnotdsSReCPHxg85tkd/5RiwEK5nr6gsTKihcRCkUZ4cMdvhJuijyJ9oJ9NtAW4qVVozXmPzoDltGnDldA0HXDCpkKDBpbArr7mpElH13r/R0y/jEPkP3Qld5jcrvwhJvVDyIWi09nypu0Ot4EAPNo91mBCGdamsXhKUReKgsnq6axQi80u27Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KiDRl0PyRotocxPu5wE7nSduFq9Wv+tg1k5wGrAXptA=;
 b=rlmkiKo7WhpUUIsHXEMMWo8wWDclwwGhHiR7uhEa9GC9z/+1TMENCtcw6vxZIpsXqgHBfA6qqaLevvmgTcGRxh0IX7rVSOkQdKVFW9LOfNI01TGar7VAOH/CS9KvynOom2q/4xQpG+p7k4Ie/iW9dNaG9lhtNc5RUiB2oHItWWjS34NkdeIiAs8cBjbACTjl/QBZd1jr9LQt8HQDtBFVA0QgRmNEtIwnNyguIXLRNm/ZR0cJgWaRy/ZRj6R8DNZAG1rk9uGJDYmYiHsd7yYylqg9O3s268gic50njctFpzfNUK+kk/5Ny1nn9HVjZBywcZp23mXAJWnz3LQF+pZWKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KiDRl0PyRotocxPu5wE7nSduFq9Wv+tg1k5wGrAXptA=;
 b=EMPFYcMZnK2oAl+8notYoQpT4bUcmHc9Vl+51dgXtFsphMqQc+rVDSWwcfiIzBr5cawGE7qv50JAnJQIGgVnyPRe+Kw20vNcH4cVs7twjud2UaY4WkO/5l8yci/7W7CnQba/9v/xihut9dtP9F4ShaHwfMPPaud/iLNtdzUBIMY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM4PR10MB6862.namprd10.prod.outlook.com (2603:10b6:8:105::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 18:34:41 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 18:34:41 +0000
Date: Mon, 10 Nov 2025 18:34:39 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
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
        Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
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
Subject: Re: [PATCH v2 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
Message-ID: <fed31d26-e66b-4cfa-bb4b-da5132c55e94@lucifer.local>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <cd103d9bdc8c0dbb63a0361599b02081520191b4.1762621568.git.lorenzo.stoakes@oracle.com>
 <CAMgjq7B1AzqGk7nSxwY_paTxeJt8-=+T+2Wc6dBT_6XfGFhGvA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7B1AzqGk7nSxwY_paTxeJt8-=+T+2Wc6dBT_6XfGFhGvA@mail.gmail.com>
X-ClientProxiedBy: LO4P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM4PR10MB6862:EE_
X-MS-Office365-Filtering-Correlation-Id: 82900de0-2505-4f5f-df3d-08de2087cfb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?UX4fbSqHo2VF8RuHCVemMD2jPhuME492OZGNEKS4W6EtgkiPN3XSHlIbZxdT?=
 =?us-ascii?Q?7Z2+6/VA8Q3nHL4JHmO696jmI9U5cF06F4hLXJBro0T7bw2bgm3CfjNUNVyl?=
 =?us-ascii?Q?8Y0XuP9nxYmeN4QhZgEHmJprFXuJb6UZ0Un2tgcHunkviOhgmZlKkKimgDF7?=
 =?us-ascii?Q?xXhMTP07HZzYg2Xmp5IE8xBl7Zq4nPWNKPRiHJWTqjlb4abTWsX44B/WYO4e?=
 =?us-ascii?Q?3Y3DdvS5TPOs7R2N/uoeVojfzEScgqsV9f97BAz9sY7qfWdr+jMo7r0biIh2?=
 =?us-ascii?Q?puizg30pz3QkOKnmH/r9woBMeIn645xmaWNu7bZumdb0NjsykRe6tQdj3jZS?=
 =?us-ascii?Q?Lw5HGiWrnmpQHwqW1ET3mBFNDeXzwo9K37oDiG7vcP1s5REnRzSFgUtoD9bb?=
 =?us-ascii?Q?akP+5xUgdmHMtbE3F1l0tTxSPdkHVHYYhfQTjBgPU/t5gPIsgncAxxcTQiYX?=
 =?us-ascii?Q?9c/yTt2hhnEkPsRbRrhVVnUSwIWk1UcSJUU2d2SJE9ovu1cJRPIdvSUPug32?=
 =?us-ascii?Q?91HscERlrU+OnyvlLpP93ApxG73tQ5iaLb1tFYve9Lzo3+HDZG/zuTx7rPmX?=
 =?us-ascii?Q?W+MHD9lrlwEnsgXwXJDboTw2U6x1I2rVEyUAemSAS4D+lk5n1Tev0NBmuZ5/?=
 =?us-ascii?Q?8/ojqckl/dJperNor1OXNYNcjK+fujN7YgICC+AyAdcyndWlPM2zkYDoC4Pj?=
 =?us-ascii?Q?r80AVqrWvzcdSfkQ1GMMoo6zoy4HF+rjGXEZ4KqxDil0Ad8Jzwge+phk7xgq?=
 =?us-ascii?Q?2OuBymXC113fQMDWNbBoD3m4O1l0MBfZlUIX8fEHOJUW+BH55bGG3Y8ZGaTs?=
 =?us-ascii?Q?pEHdbHt/LtGQ5nY+RsPb8PIO8ZbuQsRSu3S31iRiEFLjakpY38vvYTqrw3HZ?=
 =?us-ascii?Q?3R6LWdOCMwAbBp0/bzL/DYzslSSAfC8UxtFM64LzgmX4qkECq3JYD8tjc8iX?=
 =?us-ascii?Q?axc+GJTdvbx1vQkz7vFbI9SVaGucHDpv374gQoNorCQ/ULcEchtd2Ncc771b?=
 =?us-ascii?Q?t7BHTF7X3Xo1gGlFkKE0mm2/bElsWBqHDj34sqLE+sMQKgfpByH6I8Q57ygU?=
 =?us-ascii?Q?Hz5gZByfOJQLFq3uzPaOVxegEYTOfV1SifYMDru1R279UwBNhwD8CWaxvFqT?=
 =?us-ascii?Q?knpUZkmPoa/WKs2LcHmEDaGO8HJu1g0K23ZysvludrseDLGyn10Jtys8wy/+?=
 =?us-ascii?Q?15QMGaxGTJ7COIAWAP2HF0xY9jIQpPrWLYmerTZVI0kjEJOLQOt1SL6HaBS/?=
 =?us-ascii?Q?6V16rtP8yF6Su4B/f8HMSX8NcO5OgXwhGRfUCnMfhnntqyAaKQv96gLKQRtX?=
 =?us-ascii?Q?rdj8LAY4BfaP3wgpJcngW+xLW76hfdIHYW3qZV0qgaohy9WB9ktP3Dmsn70z?=
 =?us-ascii?Q?0LIUtyC50P/SdxhTeEAnL7Q7hAaaM5Pnbh8Pz0oB4TLRM5pI9bZo3MJIM+ns?=
 =?us-ascii?Q?xO2EImj4aqR6J+c3FkGHujbRiJ9Ca6Ga?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hB/zSt7RLjsgE0cr1We244IODM+Ssuask8wKAk8ReWTGDQyuMkMw5dRbJjmC?=
 =?us-ascii?Q?ZT77krav3qHqmb8HMpy1hysKF5DQnBbehVMexUiOmCrIp7fsIf7jFnrDRLqf?=
 =?us-ascii?Q?0qzncYEhk6p3F6hl10lcqXjc/GPwIes2m9JEIM0HhyvHhnCzCjzjKHosfFFG?=
 =?us-ascii?Q?AHczfkQ1ue+xSIKMQlROHuw3HZdKxyOpq2ZAIG9SYNbl7VKAQX6M3mUIQpcO?=
 =?us-ascii?Q?HX491ZrVbAmk12H2jBKF+FQYdoadaOfTPTQc9sYydkhYYQtv+mxg+xHGLdlA?=
 =?us-ascii?Q?DV4NDOMZ/5+RrYfaKjQU80cYt04F2kHMFUBuAM2czkDJIZFXJcI7TqQL40/U?=
 =?us-ascii?Q?6tkjiCVZbIBmhw16txbpXH9iSSnIJmiQ4eaF57KhgjMQcIPqdTtL8nee7CXo?=
 =?us-ascii?Q?MEkHCx2+tcpHflAXxbcUbB/8pOckKLglKQ410HkJfiq8hFfiwFMd3yB3Vser?=
 =?us-ascii?Q?o6vB8R+ybjK0ajbDlocEEhaGRonVCrHuBN/g1bdf7XQSZRceULvu++5WsFEV?=
 =?us-ascii?Q?f/Z09Umadwy5SMCr7SXlqTNZ/9Ls0TyqC+YFT2PLLu1IPXR13LKtS8i6JFjk?=
 =?us-ascii?Q?QdzgX3RczuguCaUbRT1qZDi5NYAbSsJw26OBQRdlrV/KgvY+WT3LNVbQhxDf?=
 =?us-ascii?Q?E9LUKYmY5SXX5CHRY2JDWvZVmRyGqgKlYdyYlGiuf3XDFe248l8FrVA2yTXf?=
 =?us-ascii?Q?S3fmKtARTIRzwsr829nfQ312Zh97j2Tu0CUNbBhO5vAjcptzaPGXpn7UcW4S?=
 =?us-ascii?Q?oCIbCHKPgTOmNK/mIib8EG2dV3KqF6em70U5aEO2N4mVvI/+TltHoxhOlKot?=
 =?us-ascii?Q?GhM3nRJEcONZ9mAT75zDcysdWkZXx2AXBJYmku+AmL9JduuIoEm+B2D5mHVB?=
 =?us-ascii?Q?9n+dhxKyms0plRuvVpLQDuKDtwjdkZKYA+/3cyQbF8zDPsmuiouS7GbJCQTU?=
 =?us-ascii?Q?g4LRMeLfBnZ3RU5VX59WD+1A5Q8LQvsFw9W6vOvwF6nlbqkHye7APvCQkxBy?=
 =?us-ascii?Q?kNXqhRayzYDLvOOJRL7wEFmK8Dc6pb4A+ZO2j1d4MdYXLXVlGbDBzRCwpwse?=
 =?us-ascii?Q?M4FH41mbmaAfof6g5ucopEhfDO/qpdFVYIUEeru6Qe8QvohYViCwS3vUBRF5?=
 =?us-ascii?Q?fugayx6JNAa2pRvzhUQfhPEl7tRTIXfopz/7JBXUZWc+SCxZ9tX/mntfVrtI?=
 =?us-ascii?Q?5OelT9e1Bqdl/hYFuPc1nMQN14iFLKmD5Az57ts3g881LCd4Ds37CtrJZ83M?=
 =?us-ascii?Q?uxKHR6/zhk/Ag85A8Tsdaq7WHTRbkGwn/2nRdPJb+QqWHXhtqg1PRTKTuZWc?=
 =?us-ascii?Q?kmK76Tj+X4ICXpOT3nz2kLwfqA2yfK8Y2AQvha+Y+MudwwC+4seUTQnfeIjM?=
 =?us-ascii?Q?TdnkDwu4R8HJy0CM0V34ENX2CThwDo55rU2N/K+EKACAPPsg83pLkPCr9kQ6?=
 =?us-ascii?Q?eV8KOkq4ZDcr4yKnkIsZDIMI+PMWsZtDBOb8+EHNa2hmIWBbaNP90V8Of18a?=
 =?us-ascii?Q?4QLCAHlMRuK4p+SKaN1yJpTET+Yq2dwT1x6DZ8qczF6tArWjDS3dPdYfO36a?=
 =?us-ascii?Q?dMxOKwj7wrr8PG9aahskzDHVUPucWTW1akufSJoCRUqAbUKjo7zTWh+uUd8n?=
 =?us-ascii?Q?qQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IgaabPtVGmTeNgA4saA/jG3NMsyJtjTtOxsqlywaZGNSMYtAlK5wSFlLH868ME6XM7VQhtJ+qrxrUeciatbkEDGJI55tYJDNozBfU3ucC3AzEpGx6VVo90tyqmuu2pn6fEOOS6TWmV91MIwDJePyXOGLFUDwocIG9s4S8NkDZqKFJ2sjNC2x47cPfKl0yN29vf5hh5xzP00gd8rC2Z82/IVC09/Xyz3A+Y3K8C7BpczRCOk9kGhcRo6LmQ2aB+gQbTAEiArOLy4aBXJaoi8+xOq7h36rfOFlppo4GLNGfK1wO9wxRlQ7rysm2b0YvYfsTh5wzFL0iYB9wwVpNP7zUksPgG9RxuNsp4lumsnd6c6Ha/izPfcMNtf0tMUQ8amxVT5gDLbvmtABp9dksNkvV5z6FCxcXFBnVktubValgZT7yTCuVFgVWDuonmxL4f5WnrQLVij8gCHwuJ9KQtBqTArY8Y3qYASenInJRzeKsteRHL0y7e0hV0G1zuPLfebbwL23+yv2jVZ+CuWhIoeXqLkVgChRgkaDdcCb9Iv5H0zG2zPC/IDx2QrJQqTdNjTA3Gcj5TGJDFd8b9GeEH7CSAqOl6sNJofRjNqO9qs0DKc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82900de0-2505-4f5f-df3d-08de2087cfb7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 18:34:41.2505
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +uygLvJULHe+h78GkwgxsXvOAxdtcPq8fsCGyii3VYSlSkh23sou8lnEYpA7Y97+z/qMm33AxEfq/3YKiaUg0lQPDoekKIoanRVQFPAFxkk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6862
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511100157
X-Authority-Analysis: v=2.4 cv=NZ3rFmD4 c=1 sm=1 tr=0 ts=69123046 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=SgyGGpZwutaeVDM0-E8A:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:13634
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE1NiBTYWx0ZWRfX7HxM69stZ4Vc
 l89n07wT3PYbvgjjMpaYmIeyj/1NAzNM0SvN8sghIs3JbPtDFpt82b7EHc1asuGwDvZ58BOSZxr
 whuXn+MUYF8uaUgk2d5o7FqbxHqqvtir/GFF8Y7LzW+LG8r9A3Kea7AeWb96iM94swxwvjTWNgL
 vi6msmYLLQdSq1gVcr4p7D3Vmlb5EQP8IWvz0CiTQcs3uYrirlDJpqb0ktut/RJ9JkqYlBOGrLY
 3k0RrZrMoYOaRLf//7LISfvzMmFENf2KGW2ZcLNLTTWQmbX/8wqfHx0Mj+a0l/qpRfe1V3QvTPq
 BboZKpskTHAQ1rNtZJMFmiA6aSh0GzuDvPrxoLgMsgrhcCC31K8VWRpMj31oNNBogPs7xP1nV5d
 sxHJ+WCjvSREyQ5BA+soUdJyQshvBtJXJBuRPATOVhvPSJPe9j0=
X-Proofpoint-GUID: ETlykdG1hB6gernfZKbzRQWsvC5eaTfp
X-Proofpoint-ORIG-GUID: ETlykdG1hB6gernfZKbzRQWsvC5eaTfp
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6857F14000F
X-Stat-Signature: 8irajo5e3aj3yeyot6g37kgjjqmb9q6u
X-Rspam-User: 
X-HE-Tag: 1762799708-104293
X-HE-Meta: U2FsdGVkX18jehdDLp/n8yw/CL1UYl3l6Fh/Y/+1/A4+Eltcjx6zdMs2GjXshi9HHFOcMPgsy8and1yFC7fh2t9mGrI2BGsvwe5cjnerJCnmKvhq2JkhIJNPXxBtJssf3tNKEOEuXiZYDhouhgoT3nhwIsJ5ATinCR5HtAbjwLhSQ+vH/tkQHBimUfOTOoG3TfE7LjyrgZJHe51lRaJmIrHCwSv33RIQb/d2XGrpzGgmn12zvJ+SytWIfwV51hHct0KOkFA8Tmdco4kJBy5lVWDf2Pb/7OEeklsJlmzu8bHA/1/Cv5lVPzbksXVpuHMHneMIUKDeH+rR9zpHblMXhHDaQoDgoyvSOY3T9b6QRSWe/246TmrPtynbyRiXI09BgcJaQxD/4VFRBlXuVEKBSbV4XH6hDbPc06R0PQWXFL94B56EWWdxk627WM8XJRy/euhPW5Q1ecmmGhnfS2x8Qo1KWsg0cPUbUc/nRW9ThZWW0CfE1hxPdFHDiJGQfN2G9SZny5HJvVBImPa+uRo5VG1p+PqnWvNykvGtVI0jqqXlAFBNff/SguDWFNV1/7Vd5RN4qv9/6KaT0UqXHc0mn039rjCkFKO501fGNQ5LSIhAJ6jH9zAlICJ+YK31ILZoaWDE5nHWnm6vtSS90TB8lEo9bsb9c4F1PRm4uwHZh0SUBdRqS6MyUeEje5eQ4AKV7sA2HVxyKoMk1/N6OamXqVoqL3uNf2A/HWir0jF5ZcMwYUV0S3fkQtCU/1jRisCYSfGVwgRCjVranfZHvYPcT9i3E4PJMj8CPvcU+4YhiFlCdKtobN8v+igUz58zH5Qs85A5kd4fEXoX+bhKIejqAivFBs/MJhuQzbwe1IjfCz3EuxAdFd2RyWisvmpC3NM8MmvmU6Lh7O3I8QqOyBlwAovPX+B4qnz+bqJyI4EdtokHVyJF7kfib0OmoJcZWiC5NZLAAgDXbWsBDVmVSnd
 q92E8rtZ
 6srDbAKQq2U7C8arJTsi8HBBvSxzHd6yPnj3nuiyTtdmWghbZQCg2THxEP0lzXmvTh0E49NXkoMFHuJL0yU/q4DWlmL3ULZKpHBGmXoQpCN3evbzucbRgU4MdQQTQAXkzNl+Q5eg1Z9uo4bfPoug0N4+1sYhoTsch5Tgp4HO9AQRQATPRJAGGY7MHBPg3BLOPwIVkjFTXjPHbobSMVhWJv32DllxZIOLDDH5u5RDu1NXjwCOcdVz7gM2iOzomv4InhSC0B6wBk8gmSAHbUPbaIoaS06PjOc3jiHx48LUsP4nClImnUKTILwoNtM3t0nXg2gzqtJQXDGcKQ8e1akHrDEhIelcEc5DMTPVkqUis1Bt2dRfTrwJVqr0VyTvpN3Dwfz207fFoATz853h0fQPGEYhP3y8DG977PiALv9SGZukC3zgWgEKNbiMC4YmNrjc6zmP70MTcmOawWPLUC32jRGOUvG/uRyQ5/OJf/q+pYEwSznPrnSzip6S3K3lVvoHnOcpMrSWC0Dzlgnkn5EcedsD0we7ky6Ef4oO3ne03hgnb2EYafnVwXsEd5qljR8TXAArhtub5kR8V2Q9QPbW+nHRoCaK2h0c6+oV/M5bI0D8idFtFQwwWhtYJTcMhsHjVcELqMFM+e6p+CklPxyRPFZqIzJuS562hu7fqk5J1fv9iepUUA5RxOqoMZrZC4axMrfGR+alEMLnv/zWNBIAKAwb1SlikPbH6+S/XhSq5uJqHi5Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 09, 2025 at 09:10:18PM +0800, Kairui Song wrote:
> Hi Lorenzo,
>
> Thanks, overloading swap entry types for things like migration always
> looked confusing to me.
>
> There is a problem with this patch as I mentioned here:
> https://lore.kernel.org/linux-mm/CAMgjq7AP383YfU3L5ZxJ9U3x-vRPnEkEUtmnPdXD29HiNC8OrA@mail.gmail.com/

Will reply there.

> > +/**
> > + * softleaf_is_swap() - Is this leaf entry a swap entry?
> > + * @entry: Leaf entry.
> > + *
> > + * Returns: true if the leaf entry is a swap entry, otherwise false.
> > + */
> > +static inline bool softleaf_is_swap(softleaf_t entry)
> > +{
> > +       return softleaf_type(entry) == SOFTLEAF_SWAP;
> > +}
> > +
> > +/**
> > + * softleaf_is_swap() - Is this leaf entry a migration entry?
> > + * @entry: Leaf entry.
> > + *
> > + * Returns: true if the leaf entry is a migration entry, otherwise false.
> > + */
> > +static inline bool softleaf_is_migration(softleaf_t entry)
>
> And a nitpick here, the kerneldoc above doesn't match the function name here.

Oops copy/paste error, will fix.

>
> And now swap functions (swap_cache_*) that expects a swp_entry_t is
> getting a softleaf_t instead, they are the same thing right now, so
> that's fine. Will we need something like a softleaf_to_swap?

Yeah that's on purpose. Chris is also keen to keep these as swp_entry_t.

Obviously the second I make this type different it'll be easy to get the
compiler to identify as it'll throw a bunch of errors :) so this will be no
problem if/when we do that.

Cheers, Lorenzo

