Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A99CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 22:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BA188E0011; Mon, 10 Nov 2025 17:22:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 291A38E0002; Mon, 10 Nov 2025 17:22:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10B578E0011; Mon, 10 Nov 2025 17:22:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC8878E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:22:32 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92D9B1A02CB
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:22:32 +0000 (UTC)
X-FDA: 84096122544.13.E64663E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0C5A1100012
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:22:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dqwmpGMK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ypIXZ00B;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762813349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ES+ODnUpx6m2BxJg2i8m0/ywBdmg7etQq70a9R7KC9k=;
	b=ExdYFJI6TODdpJdz9Z85Xm+QAGC7fTQC8dBpLjYyV7rQrfa40fdoXtSAPOx4Khpq1e+K9R
	R5sAqAQAzhHiTSmpUmNzksBSTVkTtservMsSNRhhGFaDkr8xNOS9kLgDRUtrJCjc81W+WH
	qzZ7oqC8ZFtu8pQaIjr51HMzxv7fb8s=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dqwmpGMK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ypIXZ00B;
	spf=pass (imf14.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762813349; a=rsa-sha256;
	cv=pass;
	b=TYh+ppQqbOEqXgRz6WZ8GCyujWyODOBj5HEhU6YCTtyEg6r+OeSZhDveLlECnRIyQs+7Al
	HGiWxaaFHjUMlHFGfuHrG9YB6ZCte83zxlilAInhX6X/sKVc58FFBMdn2DXzK2LhhNcPG7
	C+nfnsmwKe3bXj6rdhkBE8+e3K7lK6Y=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAMIQ7h026148;
	Mon, 10 Nov 2025 22:22:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ES+ODnUpx6m2BxJg2i8m0/ywBdmg7etQq70a9R7KC9k=; b=
	dqwmpGMKqq7TC0Gp5PVypaXdQk79olLrCSoCMCdr/Athit7oT7E37UDbeCfm/CCU
	XNoWiaDJ4W/WgQkdfxcIj1rzNkSLSMpGzn9V3eo5EjUrZ6v4rB1ns4Wfip1LtxUU
	PTQwLVliBsNsZMZmlQNPxowxPFPg782bL8+ExALI+VTLJufwva5NPI7q0eM4TI1X
	wj+IMY25Av/jLby9RxZJu77wyV4DNluJ8boBWp/fVawQhDC87y+mnqYTZ+5pOtYz
	xmt7ArI+/+W6sFOLAoAN6+AYHo2+IXPF9BHQNwtLTEA33CGMLq/IeuzYHD1z0ANV
	41TMYgBoun7v8TQKtGk9BQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abr5vr2be-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 22:22:02 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAKGUhq007458;
	Mon, 10 Nov 2025 22:22:01 GMT
Received: from ph7pr06cu001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va997sw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 22:22:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UIWGDC65w4y5JL4jaW+u5n2XlnQ5pbKK85/mSObPgLZumSXSbhrUYxDwAgLOmwk2v81AuvtwFBroum3lpKKTf+EdOQuKBZcZDWZp37DDjDRthjku8Hp/5Lkb91llLu861Nht3/fAVrdxO/1mtzM85EDO+0da50QDPwL7ngy7h+xm7J7MErMVg6zVYdVCyi0Q+ErT9tIpYN/K7DK4gf3awyQLKGSzEnVntGgwe+/qQTQyx1xJ3mjqwU2y+wG6JZNIzQAdLX+HF/RuGmwHJ00SO/DOEs0awE3e9e+4mEt0/zhGiEAUCaXwFOTytbTZktm73sHkV+PvHAa40ig3VvaxNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ES+ODnUpx6m2BxJg2i8m0/ywBdmg7etQq70a9R7KC9k=;
 b=S8JdnjJPEPv3yq2LB+dnUMZrAxsESpUAkie6ABTPx1pcvhnQHPZP9uAs8g2wliXl/JoZ34G5MvgiYpDX4S65hp3AXF7Y8BT4d7ovB4giQ63tJvQ4MtWGuDeACsj/ZSEcNBRzTb+FDrr8kJnARQWzcvlfEMSK7gCJzY5LZZdTmj9B/AjqmHnRykSYMZ8rsHlyAxh1CIkP+lrRhTOaiL3Ro5gCoEr3uKhd8mnWNz3sDkMGmMw/Gei3D2ZJRiouykD+xv61iK9vNPpxBWn7AQqg9UypatiEBtfM0khFnRc6C4t7mXO3XL7WKCsEyE8az/bpMyDjYNnJ2EQLaD64ylVrgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ES+ODnUpx6m2BxJg2i8m0/ywBdmg7etQq70a9R7KC9k=;
 b=ypIXZ00BgNSEAk0T+Dg+1XXPRejAue+B4ZoINvAA9eGRSojFiV0OA2Dxit8mpa5f3dtV79jp2t21/WlKR1qCoVGDw2u4vhlkv6rkdUUNHINquo8mnadVPSLz2M/OYKxtd2TpUPc4i2yH1u84jpvRNkT5MtfeTbZQsWpltfedMZA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7622.namprd10.prod.outlook.com (2603:10b6:208:483::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 22:21:56 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 22:21:56 +0000
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
Subject: [PATCH v3 09/16] mm/huge_memory: refactor change_huge_pmd() non-present logic
Date: Mon, 10 Nov 2025 22:21:27 +0000
Message-ID: <451b85636ad711e307fdfbff19af699fdab4d05f.1762812360.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0237.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::20) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 29b15133-3027-46e1-a6cb-08de20a78f21
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?oXPkxBv3HFziTBzFTfWnJbiT71uYyaAXegJkcKLCiSCCejcQTOiCLiABSP2B?=
 =?us-ascii?Q?DHJJ3yzQdouwCLjupaMoeCPlSIIkAf98az463VjpDLy9RhrIxoK1Ky3ozzb2?=
 =?us-ascii?Q?HQhGDknLvOqLEAFJS8PiBWImZJjw/OiaEaXQDqJPzqTDOu6uqC3rHNYeIev6?=
 =?us-ascii?Q?qFmPasUDNKEk26JDz8mPjjlTJdnoPfGCZARXxTV0TkadYxx4GAYXg0pk98HX?=
 =?us-ascii?Q?O6DHUTUmflTtvpRBnKpZ/knP+C6orY7WJjhiAEqsDo8uj2xG3VqjNY/GwbkT?=
 =?us-ascii?Q?F1vkjad5XJk1EC96cXMvF8N0G6g2oErAJPSYmFmYQy/20FWbX/6qncNakDF3?=
 =?us-ascii?Q?4V9Kv3PXkMKtKC303EK5WFcatdeTLQPhkku+8VIz9HtSO54gZX4Oz1UO5adc?=
 =?us-ascii?Q?DCixi860mGwYS52OGzyjh+7opmyKExTQTEaFkShIuPQNZG82xyuLkFa127/C?=
 =?us-ascii?Q?JKnB0ACKJV+EqXTLYrUOfxAQdXFMOYDlx/uaBqaTS7EltQgzwiWEG6NaNd4d?=
 =?us-ascii?Q?lhGCMuiWFwEbCpLAlUoklNIEhhTZjTZoCCS4DtpcbbZBhFRgrVEePAZw/rPy?=
 =?us-ascii?Q?+iq1QlPhwSO0wQxjFfNAKUb6UNhIzlXXKqrfl7vCy2aiCtOBJE6pY7r/hRZO?=
 =?us-ascii?Q?FmLqH6rcp33Y9pGV9q3ZZITKYqEEygfRk58pzYa40S013yRSHIBeOljBRfXT?=
 =?us-ascii?Q?Vm/DlUMpfAtldzORLaHPrfMqqLKUGD6UG07LdoLGpFw/PFZEwKjrAcA7hu4Z?=
 =?us-ascii?Q?U6AAaWNAxpya28O4eCssj06AXtCfQhsrUrXaNiBWPinTUsKU9q14xSMPvdnr?=
 =?us-ascii?Q?/PF+01HIzD4yOVTHKiIN2Jgia2JGf7EhlVlmSLqHPxR1fZgU2ebhOS4CMYkg?=
 =?us-ascii?Q?ZwW5qzIUDdwBEBM031zRMmxA7qLt9I6jjcADfMVahG98GVMGFgIZiDDgbSLP?=
 =?us-ascii?Q?3uUVugeH25W/jQMqLC38eudopK0E3N1eamAQGMW/UrZeQPxol8ol4QZbqX42?=
 =?us-ascii?Q?yAPyS5wHFpVWKdhe3OWYNXUePoWWSE9BVuKfvzQMVR0Oh6qSPOFkmpmZIQFF?=
 =?us-ascii?Q?SjuwTyuCBi/H7mO7xkG+5/4Ivxbf74v10dgUoscrhOrwCoRwCt1zc8AVK4x7?=
 =?us-ascii?Q?exr1paNr2+ju8flpuzVgnFuxWDamkiLUzvDeM6ZPllyTwanfJkz670EFQAW9?=
 =?us-ascii?Q?njLGPKgFMbwR1eigBZ8rAGwAohRkmSEJpQnEwc1H4WjAlFqQFmE+Lf0Q09xA?=
 =?us-ascii?Q?/dEMW8xyZ6Cxtur9oVmw0zE9aU2kQjFRaiq/HkGmGRAWo4jRNaIjfWZQjh0T?=
 =?us-ascii?Q?sxF6ixgldcA2uzBRY9+UswL4SQPY0EFsOGBgWjd/KohG+3Sl7/M9ztdlHqhB?=
 =?us-ascii?Q?T42ITggzfQ3og+c8iyopP2PKfrCQ7LNTyR7SeHoHPe3n6safVgrc2BkFzVJW?=
 =?us-ascii?Q?Fpe3B/0mqB8s8REvVYurLxxkrzaA9/k+?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aajk5WwGh4Zkx1IsmIz2Nvzgqkgvv8sDUoa6JV8PWy/nKtmnCYet9BxOLFHT?=
 =?us-ascii?Q?gDOUzEQ2OSyahZOKGQiUUL80AXS7aTfvvUAQ7CE5fPEeoNLGFdGbHSF5VSkW?=
 =?us-ascii?Q?hK7yj1AkqEni9TGIgknX/PqWGZZlM+41qHBigleVOtVBPAwcHSuFzq1QP/wi?=
 =?us-ascii?Q?4iUSpEDt3rHOCWZk8eKXsC4rQGbVgtRM0itHw+HIudQX9nzic8l0Mb3BcwDq?=
 =?us-ascii?Q?mcuARdzQTObOqoPl4XSpi3RjzDWCDONDk6vuuaUVhae+MY+qvJSHV0rVL93M?=
 =?us-ascii?Q?FmNW/EwaRxiSe5GWc2Tat2u0mhxgXVk+p/oBCRLWt1iCG/4vbXtsbr7bYUBi?=
 =?us-ascii?Q?+dJ2nN6Tp9jSt7eCD8KgVsb2Pmw5np7Vk4GpJefoY1PMDoFWVG61B9lEaRBN?=
 =?us-ascii?Q?l/bMuVX86KVraqNUTEOpyMpXzVzVFH08024Ulwzut0OArVstwmQKfCKacMxL?=
 =?us-ascii?Q?ekMvMtiaG/Qzl5L/mC5SsCaZNh8Np9c0jY1CiUKj0cP1wte9leGNHW87Xx9v?=
 =?us-ascii?Q?KfgaBxndSgerXcmN7+E+k7vTMn/HIRKctNh82hYDf6JwFWmykZsFRPQ2XMqG?=
 =?us-ascii?Q?EB8FroGbsMybWeaMf8CUIFknnG35/2p8FVXccnm+zYgiSCLlY+FZiS7k9git?=
 =?us-ascii?Q?zTTAEWlZKVwRdibsAxDarLpNVrAqm9WHM7XOifiMKmu6vdw9FE/Oy+PbnVyT?=
 =?us-ascii?Q?YSJA28cs2U8YKKAaGiY5vlF3dA8hKgvk5bKaDNcOQ1ObbVoYS11ch/SYRni2?=
 =?us-ascii?Q?ordyTRlEntYkoRrf5hCEyNaHLG/qr3gzRSRvvkYXHfSXfzlVWbQz3xvCHLaT?=
 =?us-ascii?Q?1bEE5QXtlAYJsT+W+oeDArNgaUoC3XIPE0S7E4IxuWgWnAaAiWFiVTADJGd5?=
 =?us-ascii?Q?hlI277twf2SlIRoGORx+wNvc2RjnxPJXFzKcl9ZZDekQ+omAxapholuq5Fn1?=
 =?us-ascii?Q?6jST1Z2wNb78HJywh0gp8PGc9oXkuCZeEJdGO06PoAb3Af4qUCyK/+Uws9NY?=
 =?us-ascii?Q?KTzhWThycjyjGd1SA8WUmWku+cvEGZ0fDNEcv7498J7fIhpHM29N55tZfIZL?=
 =?us-ascii?Q?ztPkhPnw35BK6s9g9ILUU01l9ljzCm6gn/Yb+NcuNo2CD1QqKWtE+qtAIvmS?=
 =?us-ascii?Q?0HC5Zf/2OmBIV95xkq9+jHssLWAzs/Pwc1Jv9vrLIa55SqepzKekC4UNrdLG?=
 =?us-ascii?Q?dah9W+bsOuzXMHNk+5aXYb9SygCX6hFXUhLhFjThH6F5zGzhAjEm8POxrG91?=
 =?us-ascii?Q?SpxSegbKnA7rGOlas5bu38EO2C6p2JXFdtr1Zjfh9uDcQ5kg5b2miLqUnjP5?=
 =?us-ascii?Q?4Jm26tF/j1mkp4IMhoJu6QOvdLxAl/2tkCHsaqgh+iErXZZ8i4L2b2YpnBcs?=
 =?us-ascii?Q?O5GCMxWUfBsAtrct6w1TU+W/p1n0OU6r9D26eBDD6I1mIPWTGbnRb+pe1kM4?=
 =?us-ascii?Q?sU+StkNrhbFMmKd/9Xyzv93kWqyFbWgBOINNh/LAsRDN5+pHuvL90UOK3Hfg?=
 =?us-ascii?Q?4WZxfKVqaRBX139CqeruBGUOsUs1K50pgeQH2DviATO5hD7q9hFctMXI7NTP?=
 =?us-ascii?Q?IuM0hesOb2j8p8izdFNj3GuD58X82PnID4tVz1sXnvdrByJ/hIfwRdGP8MUg?=
 =?us-ascii?Q?vA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	BaQfCbPSqaTsAEj/f3f4JKLaaYGWLZj9nQ9C6giBR389nxwmLSDPl2f32NoH03a2RqTXPG+pazlKKEfm4c36olguUivMM9qimtlajLl8GNUQylAB+SOleK2YwR6f+L5HDH6nm7Sd/CMhaXyUhzNxUK00YSX2wgpmmQVHa5YWAd/8hSfVGicwSIlZc6MTYUJ0t5WXx3T6s0vY5GG07C6uHN72yYhFPlbRvoBRvkQ1Z8uhzH5tyQ4EJiXgXvXtYRFr+7zDHm9jsvIQsD767FSE+F7yX+YI85p0cHFwAoB6Q5dLjDEeFMElt2Q2qGiEyv5I1AD1G+5ntmjaI0wzd2En3mesfZsvk03cxo4+W8g01Lb9QbJuS95NGPOwZoPEj6f8PdvQixkiq5AIif8SI5puPQytkpGhXps0FI4AOEKTDz7f7Mv1x85mbASt2f0uhiigWGxgHPBe6b4EHD+NDmGmdA2Ly0WR4Syl6n9ZNrRf+9XphCUDe64N/4npUWwTJumr6O468K55U6lUAeBYYirfjXeBjIxnEgGtOidYcMAK2sYHVOcaaSPtVmfnJjZuJ1Z9hTZSt+LNwsnCtEjXgJc6Fs7hZnK/iHjpQd7MxTcqiSc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29b15133-3027-46e1-a6cb-08de20a78f21
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 22:21:56.6767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +xkJo1Q7ZUxf8hzrWsCqQOzdb+BRnrVzBS1AnFrO8Y8rMqwl7++shby8vzAgcctsx+WF18DA5WsRaQXG0selbt/964TLCenkod8mAovvLpw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100190
X-Proofpoint-GUID: fU10awHxOl59HnSL3uH8zrC9pdc2Jx88
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE4NCBTYWx0ZWRfX3C5liiu5Iplg
 jdDIAfhdYhfVEBcpjnMRCsZXOuRycEz6UqfzSN49DUiMPBBCLGsxnDmijJlBsy1tnqfoxE/8rlt
 bWfcA3O6UJyi4qMxCbU18+YPAFBhbMINtYHxhdpF6YXPReb5BgOXh07pjZcIqynTmeTnW776o+3
 sCYI4igbxMQtN6wwLJExLx+59xYUSeDnkwpqNvlkEz+JrxzHS6Ryi78jCfEb6tV+vAtJnZnf2B2
 OWkfcDB7U3UiyeRhH+/wFhQHr5n0J1R2HEbB42b6uDUGtK+Pbebi08kB5qihnwN96Wc7aDfDvRw
 CcvFrJgYVyZRgCzq0QoNMhsPQs1BehzxhekjOavLUR57mIf4AHdNeZiD0WeeTvnoVMFnGG0/Z+C
 sn/DpEHXLETQKaDuinqUzCZ6GVQAOA==
X-Proofpoint-ORIG-GUID: fU10awHxOl59HnSL3uH8zrC9pdc2Jx88
X-Authority-Analysis: v=2.4 cv=YN+SCBGx c=1 sm=1 tr=0 ts=6912658a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=gAL6uhOEssAPNySJDCYA:9 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0C5A1100012
X-Stat-Signature: nnkhadgypgbr5s3kaw4k6d8o7pbfyhs8
X-Rspam-User: 
X-HE-Tag: 1762813348-843243
X-HE-Meta: U2FsdGVkX19pfMASlbboQQcE3klSCKkx2WhF4B/wqlowfiJwCbf7lJakE917TQfS1FKq2mFfRJjSOkIBRTFFcCJfHzlYLtV7sstfk3+Fxdx4W4dIcTF5NyPOyL7I5cQsap6acD5zBa6XfB2YO/BcxDrLTuyUC5x1mIZk3T3pXZl0xM6YkQCYxD2C1tm+POCEBK6Bq+mAjE/EbqJMybqctM7MgLMiY7R7GBAAkpFh3/GBW3wcT8M7buyv/oGLfotkAz8MxwOJXUl6hNC/0EzmPEd85a8VHkPE6MlDmQG9NkBo9yAxoMJH8kE+AB6KQVeNqaPIqEbfK/x8Ryv/b9AITfjlshNJsNKWOUnpoFQLh63WbrKnM9Kqmh2cjoO+kfLughbvc8snDdjcUi+BNq09e2eZc/tugh1qenbb3S+ytymwU9/ntgXjaSSySsEEdjbFEpNVLJ0SKPHIE15BQurCkrWTB5XE6GRkm1XrVp1JrvGzkaUY66r87vkM4whGl9ubPNuRU5RoICfzNhdoqufj1j9/Kr7Dlm9joSIji+RqcKpYOCedX3FEZIL5eNCfC9QpxBC6UzlOXcySQav4LhK7VAOAmJjaC+vvkgF6uyX3D+1vxb8P8DWXshYfQBRKRvYKzWnzJQhL8/bvSUuEPUZLJzAcm2LH25iyJwaROlaKo5YcAb5U6DxFSg+IbSYNdcPHPNbzP6Apuo3d9igOHtnxV3TbBfjhFmAdO39DbfHDQeMy9c3RqyNitqlHqPtY7pdRv6fgY+VkKVOUQrwJqrTI049Ft1CaDWUg1mVYOFcGYwM8Qf4VJ2LyqPGOXR7hR4Ccwg0+Y/iExqRewlLR03nuDpXqZ7NX+DVARAIOGgP7pNq6dSl62XlRxiP3KJQlgW0irYmI+ywkDFM4Fv5drzqnScrdQts3liFnG6ChejjmL0B+LumiP819b1ksFd4qtW4/YUbFoQSnmsg8x/Q7neL
 Xrar69g4
 vKqtc5+qmBsSrL83f/H4O1jxRvIAd92yPakI+CH1SupT3W7dflstWgaS/MOxOLQZCqV0zOthjwyQdlS8UinR3YJ/hfPECzBp/7QFcRBU1j0HqB8pexSe/Zx6GCzcLkRB3XwDWCS8TMJALPMocDlKQEQD0XuEGYHqt2RzAeVXXBUvRSQ0w/o8FCLH75c7ELzg8KANuKLpnPdYokdfDGnUC/hj4MZKhb2z0WfLBdSkWp6FNyfGxjq7mCqTn95E6r8sRZ0pqXxwMmqRkniGGXgYJp0mh7vhGEjWlYvn9rg6u0Lk5wMmZtTb6ooV+nXv2yR8TV3eXIeu3sV4Br8a6D4YNyOYBzPZUlXlALBI9rzXoGgXBftpSYE/AYX2KKzUqf42mxvslwKp8m2RUuqTu4XwIJVQwKNMQ7NpKU6aMGM9KEXbqtCi4UFamV/LQFtEw2GGavHxkAXH/xyYGZnJoZl0EWfObzGR5wtMYu+IXcRbg+ziGWRyX34/m7rhfuCYGJoOjFiKHlBuLSRtXX04CjrGYKbeqiGUYdpQ0KIRUvMzxbA2nM4tp/Ipfgo57+zY5qxGAXA3XDMTcMwgdPSGRS2oxxfcLy8feZ2D2kAcvgPVPMoIpmr/Mq70KnzooiAOsIRW7invvgIZefwqGZsAkXvI/zyOGBK5QSDv/cSLK8x7c4zMTJXxPKPSeufeXqYoif4hZvNE1SU/tCxcciOKgu/ZTh8hKPWX+b+vjUVhfmIZd6z4ma91+TXDj8Kxw3/Tt+aStQjmq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to copy_huge_pmd(), there is a large mass of open-coded logic for
the CONFIG_ARCH_ENABLE_THP_MIGRATION non-present entry case that does not
use thp_migration_supported() consistently.

Resolve this by separating out this logic and introduce
change_non_present_huge_pmd().

No functional change intended.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/huge_memory.c | 72 ++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 33 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 31116d69e289..40a8a2c1e080 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2499,6 +2499,42 @@ bool move_huge_pmd(struct vm_area_struct *vma, unsigned long old_addr,
 	return false;
 }
 
+static void change_non_present_huge_pmd(struct mm_struct *mm,
+		unsigned long addr, pmd_t *pmd, bool uffd_wp,
+		bool uffd_wp_resolve)
+{
+	swp_entry_t entry = pmd_to_swp_entry(*pmd);
+	struct folio *folio = pfn_swap_entry_folio(entry);
+	pmd_t newpmd;
+
+	VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd));
+	if (is_writable_migration_entry(entry)) {
+		/*
+		 * A protection check is difficult so
+		 * just be safe and disable write
+		 */
+		if (folio_test_anon(folio))
+			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
+		else
+			entry = make_readable_migration_entry(swp_offset(entry));
+		newpmd = swp_entry_to_pmd(entry);
+		if (pmd_swp_soft_dirty(*pmd))
+			newpmd = pmd_swp_mksoft_dirty(newpmd);
+	} else if (is_writable_device_private_entry(entry)) {
+		entry = make_readable_device_private_entry(swp_offset(entry));
+		newpmd = swp_entry_to_pmd(entry);
+	} else {
+		newpmd = *pmd;
+	}
+
+	if (uffd_wp)
+		newpmd = pmd_swp_mkuffd_wp(newpmd);
+	else if (uffd_wp_resolve)
+		newpmd = pmd_swp_clear_uffd_wp(newpmd);
+	if (!pmd_same(*pmd, newpmd))
+		set_pmd_at(mm, addr, pmd, newpmd);
+}
+
 /*
  * Returns
  *  - 0 if PMD could not be locked
@@ -2527,41 +2563,11 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-	if (is_swap_pmd(*pmd)) {
-		swp_entry_t entry = pmd_to_swp_entry(*pmd);
-		struct folio *folio = pfn_swap_entry_folio(entry);
-		pmd_t newpmd;
-
-		VM_WARN_ON(!is_pmd_non_present_folio_entry(*pmd));
-		if (is_writable_migration_entry(entry)) {
-			/*
-			 * A protection check is difficult so
-			 * just be safe and disable write
-			 */
-			if (folio_test_anon(folio))
-				entry = make_readable_exclusive_migration_entry(swp_offset(entry));
-			else
-				entry = make_readable_migration_entry(swp_offset(entry));
-			newpmd = swp_entry_to_pmd(entry);
-			if (pmd_swp_soft_dirty(*pmd))
-				newpmd = pmd_swp_mksoft_dirty(newpmd);
-		} else if (is_writable_device_private_entry(entry)) {
-			entry = make_readable_device_private_entry(swp_offset(entry));
-			newpmd = swp_entry_to_pmd(entry);
-		} else {
-			newpmd = *pmd;
-		}
-
-		if (uffd_wp)
-			newpmd = pmd_swp_mkuffd_wp(newpmd);
-		else if (uffd_wp_resolve)
-			newpmd = pmd_swp_clear_uffd_wp(newpmd);
-		if (!pmd_same(*pmd, newpmd))
-			set_pmd_at(mm, addr, pmd, newpmd);
+	if (thp_migration_supported() && is_swap_pmd(*pmd)) {
+		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
+					    uffd_wp_resolve);
 		goto unlock;
 	}
-#endif
 
 	if (prot_numa) {
 
-- 
2.51.0


