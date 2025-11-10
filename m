Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61CFCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 22:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8CE8E0017; Mon, 10 Nov 2025 17:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556678E001D; Mon, 10 Nov 2025 17:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DDE8E0017; Mon, 10 Nov 2025 17:22:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB0D78E0018
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 17:22:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 87E401A02BC
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:22:50 +0000 (UTC)
X-FDA: 84096123300.21.E813AE1
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F94C180004
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:22:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NWbbg7Hc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ddh4QU5+;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762813367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3biM3jPk/T84wrFDEkrtg6nQEHWQ6QNNYccvVkfwbPk=;
	b=4w6UrZ2yuwMJx5udGeflnjGd1Vla2qAQ5dG3vV7CwiPjGWpsptzuvO9RC6OwXfKmRT4bCA
	m6I1580dc/wdYHnTZJPBSuLyy9Yw9bzqCznNwTbm2fYvl7o+tHZLlxGKghbbw4kRUBCUgr
	ahexuNuIU4WUyoCtbr+Gcl0+a5aiMd4=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=NWbbg7Hc;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ddh4QU5+;
	spf=pass (imf16.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762813367; a=rsa-sha256;
	cv=pass;
	b=D3HL6SDd/TxmXsCMeDvnbNZ7GoZwPFHzuM7L1CferxfA4fTFL7xDTe6tdR1W7JtEQdZGys
	HbekvnVH0bknZiawZyCCjz/Qgux06ZE60C/MqC/x06JwUfNjBhe8VpWmir1edVpH/XJf33
	NbQDGsqNykvZxRtKENTy6aVd0mwrKEg=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAL8hmT009313;
	Mon, 10 Nov 2025 22:22:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=3biM3jPk/T84wrFDEkrtg6nQEHWQ6QNNYccvVkfwbPk=; b=
	NWbbg7HcPQWOnT6F5UoUgKu89jQEyVhbCpp8h3tksM9jUms5OjqPfu+KWJ4txLTG
	3rxCaU4BVMY9uSVbq7QO/5fgnes/r1a+pUbHFKE5+k+jgBT6T7cEXfaGtAb29Yy6
	pOJc937cT5HC5HFX1kiiTjMp8+hsjd+780cUa3xkJNKOBannkMX8nf6ECNK/OClo
	slvOH3qNWf3HOpcyfGsxpu0QeuXXEgTF4CWmefAEqsGAK0xNVss5me7BDsE/zC1c
	tOsK4lruhRc2bBvuOEzeoldIVAaSI9u2UmE/WbiYvk39tJFV5rQcocECq4oDdtcx
	Poq7x34mUpXZvTlx9JzmUA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4abqpug5sv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 22:22:09 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAK9m0m040038;
	Mon, 10 Nov 2025 22:22:08 GMT
Received: from co1pr03cu002.outbound.protection.outlook.com (mail-westus2azon11010055.outbound.protection.outlook.com [52.101.46.55])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va8ryxq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Nov 2025 22:22:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XF4D6ItagaXh9hOyDOtHnI3p3Bx6g4qclhnZw0GN6BdZaSDPPrYSnc3VTy+vUjarIelIiQB6sDWGChamd8UyKmH2GMfm+1wNFFYuUwBPZiM7NxKATaBFi3qIndDhdCd8Abo3pTy4HeAmYeBTJb9PxozCr7JkfG2uVWiQ/YRMnJnoOV8WBXq4FW/goKQENIKyfg7oSEQA2uHFRQ51NTLEmsrRJIA64D02aWPfXGQs81MAK8NQYVr9CVZ0D5RNRR15o7wAtn4yt5ehjR/Ss7HO23+jPVaHCfw+wIevNb0i5j9ryLOXY9URURYVQ8MfbXDiFS1fha3bJX7402tlXmUQjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3biM3jPk/T84wrFDEkrtg6nQEHWQ6QNNYccvVkfwbPk=;
 b=WvXEEKfrau6M5CGN/WT1NgTbfu8wt5dEjqLRK+dlQ1tGXq+QqaVPuuPt6w+4dT4+ZYtVxkIsY/vpSPO2pGJmI3EZYMeYLbL/JpTPPjkUMJENqODo6W/e0W6SZH2Wmipo2y11Zpy+uwoypNUSrbVVzJg45jyCcjcTJwMrTL11bjzMcxBCpUs+RXtkiBKhRYdFKxKThAei+XDbuwJvuc2HUgoPCNGCOL3l2nmv+n5r7t5uv8z6rlI6aw/uw30SUDjXbVP+CIM/dpcDNMviO/2TlJtsxHfXp+lpG02U+BpEuGWOY0ZLbd5BMnJWhwc41lf5e1Un5Ld2R9yPd4IB7Cq1mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3biM3jPk/T84wrFDEkrtg6nQEHWQ6QNNYccvVkfwbPk=;
 b=ddh4QU5+R2plnbhbRvAcWCYP1M/UEjLylOt770/VQ/o30ja8HOZAzfdMkpgC1RM2QAFFHVWOjj5fE/cngpQy47YjSwde3AJAfzbQy6OqEeiaa7OPFAJx2JYKsmYrph3XuLG5W5+HJl1fPbalUPUy5AFMsB75ZER736uavUYXnDE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA0PR10MB7622.namprd10.prod.outlook.com (2603:10b6:208:483::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.16; Mon, 10 Nov
 2025 22:22:03 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9298.010; Mon, 10 Nov 2025
 22:22:03 +0000
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
Subject: [PATCH v3 12/16] mm: remove remaining is_swap_pmd() users and is_swap_pmd()
Date: Mon, 10 Nov 2025 22:21:30 +0000
Message-ID: <1628b00b00c8498bbd2c20b82117ee87845fb738.1762812360.git.lorenzo.stoakes@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0486.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13a::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA0PR10MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d2b8b58-206a-495b-86df-08de20a792fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1xttGCUXK3m7os1+4FS61OFZittB+ieABCNCUBTh1oR2kEUVEZwVRJG6fHAZ?=
 =?us-ascii?Q?/43xTY6+YPHZKnWK8QW+GHa9iCxpyEWOSjzQEcV0p6dtNbNIXrjnwJeIRkjL?=
 =?us-ascii?Q?+ao59JqhX7Y0pS44d5mtc6W6XH+74YuIJCC8RUB/mMmoMoj6BGoRMLTWCMme?=
 =?us-ascii?Q?Pi5ulVGloMO97ojsQcUQCwzgG/FvWy7M0dTuvHFFg29xnFXa/txvVivWSwN9?=
 =?us-ascii?Q?UtVEU+RHcGK4SPYrbuRcOEyieQGNupL/N5KjekCESuivywTHjUuVg0jD9lQT?=
 =?us-ascii?Q?ofpg71Va3sj3GUtY2HU9IqpiD4Zgn9EpWnoEGONJJpi1guYbwMV8RbLXEWbm?=
 =?us-ascii?Q?wlBlVlK7YVEIEUwaRL/5A9HsNXa0zylQpzAtwShzXjt2P4HtbwNgjAriPipe?=
 =?us-ascii?Q?XNbV0ZEyCJh6H+lFSCCGcxGTz0ugwmRr9JzAMRdLRQiw854dtUwBvboQGW6X?=
 =?us-ascii?Q?nRWZrfwbxBfyMbWdN6dS24kXXAlWc0nPa9jNmUodfbnZKEF8JHXUgVRoXSV6?=
 =?us-ascii?Q?MAgXtor472EKXZ5wt5UMzuT6gGa5gi0UM9M7xsUYlrfYWgiTYZnZxAlf0unS?=
 =?us-ascii?Q?uzG9PvM1Ou7qLUp3RDhblkw4fQ9lAf5Wl3ZwP2Kz4R0bccE5zOq817RC0XVm?=
 =?us-ascii?Q?vv1hMqIaOQPa9I4i9T0yek37NGAohDxPyPSBT3z5ezP7TQVGR1AxY+PxDZkz?=
 =?us-ascii?Q?7XG/PfzknyJ6C/xgWGWWARoDcujRlcSET3LbYzc6D8HvlA8oPPBKcz7C4v4H?=
 =?us-ascii?Q?/RGJgyQjK96/iZey0phtuaZ2tTRwX2xKQ/Ek4glbly243PYuSQcBc9rVoe/3?=
 =?us-ascii?Q?iH+Z54xfOvk4JGvKrle3vOTHq+4V12TACL2mSGbwUtFR9XJIoBzYS1U/Hx9Q?=
 =?us-ascii?Q?Ywc47gIn8KWxIeuGhYkYoI1s45s0LghmZtAKcoaVmVdaT8PFbnuaEjCVus7e?=
 =?us-ascii?Q?FPROEXcXDK+KJWyZZaVuwqjA8rmH89xPD0MrNI5Yazk3K6/j1qXBEtoHMLpA?=
 =?us-ascii?Q?x7LOXoGPDoGaMlus922O+08KrMoVRMTB4BoNV3i38vPHj96BnHOK6sUKadD4?=
 =?us-ascii?Q?9M6ElMqncr1H8F9leb+tQ5GBgwVClSuZKchW5orz3z1t6TRnQfo6t9UCFBS7?=
 =?us-ascii?Q?K291tQBETs4Az69TqQzWCLa3yCRLlAq+xh4j6FvaX2dZMQEDhGw+cSwgmx1i?=
 =?us-ascii?Q?JGA0wVrtnrojmNaDqIiwS+dPoz0qQtwgL7F5Tixvxd1gND2sBZ0/HfFwf2Aa?=
 =?us-ascii?Q?1jOAOAyzMFKBE7oheGwmP4QYZ/TSmZ73b4lN3pmjTMZHzLctX9TsGWylY64+?=
 =?us-ascii?Q?xZx5pSsNRZUc0Xc6g3OvfCh43Mm/GpF9PUC6vdQKaksEcNa2PzwxtFHTM6vs?=
 =?us-ascii?Q?lk4tW2prTgJOQz+TfqeKZ1UPuRfaKtaKPesWSsSfpaagtcmliEfoQomMIW7r?=
 =?us-ascii?Q?5skT/LRqDcgeVwBIWivCp8jkup4Tjcff?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gZzCXysvSXuLNysxKYiELlczyrpxDiyAQyuSi9/FjgFBymkqHcBbPJ6vcAf/?=
 =?us-ascii?Q?8FoZZfSBNQGOkEstcJNfFqZHhpa0P7UU0PXQLPJ9AFLkhEj5+h/GUTv3Yobk?=
 =?us-ascii?Q?Af8T7mylmlswGlyLT8/mx92Yl5QYzwy7nnGYs/HUgzMybZXShyt9Hd91/c5X?=
 =?us-ascii?Q?89fxOWf5nq5hImboo/SMiH+gdvt2oaTvvT3u/PjVNO3sHS46sA2dnkRV0VVN?=
 =?us-ascii?Q?D57gqi7OKAjmR0DvKLEYecXktvG+P1jS6wH7o3+YHGFIuiUMMBn4fNXZmcxD?=
 =?us-ascii?Q?kk2P7wMLiXDrtE5bl90FXmE+ALSXQEc3U/+Y8mPqoV7xLvUZFXTbcYR1rIzb?=
 =?us-ascii?Q?GaPVmTxj90XvuOmoYpCOjU0H21tVo4dXvJo0ZsKK4AwHIFl1Z5j7JNqx7pYh?=
 =?us-ascii?Q?KoBx4DZ8/rTFuU3LkvEKWL/4sidk0pFYUkhVaKN4phqXhhFH4lITKWgnzYg2?=
 =?us-ascii?Q?0QTNhCCciCeqvdOQzA5eY9gbU9icuz+71NolVhO+je1ONTObkHJmLSec3ZUB?=
 =?us-ascii?Q?xZ+YPSA0/0928TF885NLe+ElZK1dheCTEWmOw7B/kbwufmYOeDm5ZcyZEOcj?=
 =?us-ascii?Q?4/9PZzOJo+oIX0CwcOV7ecC6/ZXUAMQ3QYT1/SYHs+Bw1o3xNIECYunz+D0t?=
 =?us-ascii?Q?UmTWr2gKJoBqWU5aQN+MFhvq5IQLyOcB6JdpSSUJ+Fybv1rPKUG5HMSeBhKy?=
 =?us-ascii?Q?t9XAKtyQRSgwf0tgICOUWeOicuzHuuUxV3hhXBxduBAj0zLhAnQ8vxusEWOs?=
 =?us-ascii?Q?3TZgs532xXS4A/v2eoAVYB1p4x7JqN2MJfQkI5+vc/VguQHVyHZN58Mi1Yi6?=
 =?us-ascii?Q?o0dAgA5N1YNrTFxwmfBwKgL4HTw3x57QJsHV3MFBFKMZODpJk8Fr+PXyrNZ0?=
 =?us-ascii?Q?69xf2Ts7kkTxL6cmBj2i1uCLWvgiJhWvW6EnSkSeueAD3OfbLEvnbOjJ1gB5?=
 =?us-ascii?Q?l71/Y59bNKVQ2XjD4St5eHqRdC06xVl3BUDZGAmAqMqhwTt19bh8Z9iINhpd?=
 =?us-ascii?Q?YMVFqSfGAseQDjh5sX/esR1T//wilS9aPm/H0FUUqENl8awzY8i0wC6EdLiP?=
 =?us-ascii?Q?412r0ea0GNq6NhCMrIU60j8sYTHuyHPJgc9zhH639acl8LAYls07UXsMCM85?=
 =?us-ascii?Q?olU8o2Tg2n5HVp8BnXkyr4f1qF0CoPJ2IHtVxLwzqVA334RiY+u9ryG1HZpK?=
 =?us-ascii?Q?cTWh3hQBrpljAfoktqlypvIBR7+D9w6fpWDqtXpy8biMu64zy2qZV9nRfpAV?=
 =?us-ascii?Q?nt80y1m1dQBlrrsnTifGVrKf3Y0i3ryjTYMQpuaASoaxZko82RhLRv6lTqR2?=
 =?us-ascii?Q?7KJP7xOKPKs9VwZNxz23ROlQExEMxciJYr6tsI9BucaJNG9M13QVV5D8yZGz?=
 =?us-ascii?Q?VHGj40Ujs1JMzoEc3YpqO1ynR5onVkwa7QPyHbQJKnbSb+BNJYtnkH5/YTdX?=
 =?us-ascii?Q?O3EhuwpL/JXoSjRPoA1jNGDfapEULL+zuHoUmhWA6X8/QB++8M35G5pAx7LE?=
 =?us-ascii?Q?TbQHsTD5HoTmvUKVSGtiwPGMuV/KrANga+kBuP/gsLfCdBp6IjplwriUz+BW?=
 =?us-ascii?Q?tAtMGcfYC7wkh6TgYVabuBhN8ZwV3dAHlStiHi9uDgmSPO5H0hOYQOR+tctU?=
 =?us-ascii?Q?FA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2/WlQcONr/M7bedLoCeUwG0hPDlT3tzV6DEctmr4C16INEOsTJXuR6tYWpUQ6a/RvyXAlBnn0xjjhzPxur9QxijonXWp6oumuoTCIlYM5YqGZTIibfMnGXaIbkgJOR7PCecYiOtLOckpLpYtJkti71SZzZb0NgthHmmGSa/fc3NilWwg+711vbqVUroAvIk+W4QA/oylAaWVsDpXaQnPAwg33RE/oasuR2YCS0GarYkV67/EruVbQs1QJFhF+3AuAGo3M3pX87hyitHzfdmgmxVtDnk18FVduFir880juoQNVtYcCs5bgaEg5EVHxya2oSBZhJxUs+RbqdtBhNYTC2vtBd8X0G+pmm282M+mGX6pRvlG9AUyUpiePxN0Zuu/cV/SiHp44/t8FhjMhbSVnJy8x53rY8sZM3SUxcGD7X9SdwgwizmUYRC+4/7Y/LMF6jSdSqp6YVrC4F5IaM5Is/S3gXSMpGBOMY2fe/XKkaBXbtVQEYN14WM7W+VhR4HzR7uXtI87cUYY53j/uUQE85XCqjYtH9z24j4TDUlmg5sam3WT7QZuDCE6jyaCFhELWVkgvbYRMHdRG7+FwLSFyGGKGL5nBjW97KCepWv/Axw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d2b8b58-206a-495b-86df-08de20a792fb
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2025 22:22:03.1397
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IVXll7YBZ2zdv8jjWxLPYF3EcqbyKJl40EnLvFHhynYR4FmTJpVZS3bXxCZgf8a30clRfub1F1mdYNLzZuSmN+bUM0ePHC1gHfjkIToPsUQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB7622
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-10_07,2025-11-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511100190
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEwMDE3OSBTYWx0ZWRfX/gt0jNyXG1g9
 +ycAB6ZwYLy5UYCwy7EQ8+qN4JyuofDBIPQBiyxR4yOsDD0ip9fjvP7aM1kfeIlJuf0V1zs/o2R
 QBRO/M2naEghIzzE3XmF2TMskFHvG/jjOm63CqpAqgGZ0cNmHG4z2qrw64nOARhI1kw3MvTcV6j
 XPhn/c127LQ5thafUux2yBPLawLoVBV6ieTKwXYA9e5df+YNZTME15ybq3rWDwGzWuj51I1lW5g
 cmlOoA4SLFSOiY+qduWZLSePYPIlOZn69+da69W62GBDf0KSQO7/euXJJyJeZM0TKdfvgrq0X2E
 W4INggvTWCD4vGqw7u+QwWNJIbGQo7ptplxTWUu52sKnivivF57AnFUz7I9RKgJzZvP3GDxktTG
 cUS3eX0iZuGKZeIdisDkjJmu2G0j6A==
X-Authority-Analysis: v=2.4 cv=H5rWAuYi c=1 sm=1 tr=0 ts=69126591 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=xbP9_UvFYPnkkC6NLJ8A:9
X-Proofpoint-ORIG-GUID: doCR_rOvSkfIp61ccpOnZMngjov1HWev
X-Proofpoint-GUID: doCR_rOvSkfIp61ccpOnZMngjov1HWev
X-Rspamd-Queue-Id: 0F94C180004
X-Stat-Signature: whkfo7w6abxk9x8ig4irgyxwu7sdsox6
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762813366-305886
X-HE-Meta: U2FsdGVkX18HKbSBjkoUaXlmchNgmGQlSvSv9Ntqeio66VsABPggAE4B6RbS9Yf314t4TPbukeXIEuc44SXXCP/SBWlSK34/4PfMFXWEFGeOh4H75bm71KxH83d9GQh9428XUmvIwKy4w5lvzfEoZWzxfeV3wjrwuWDBI0p1FLs4I+OAp1Zii8aE5lxCkqcbAg3uN4wCV7AbjNhxF7lPazKSmr6hwAPnmP8N6iZPPn1CStO8YgjXTyLaRzoF33f3VVu5Rq4eu3pkyt53/ZR9lN42c/6yG9+ev4Xfe1qjsE5Y1xhRbHT/ebIJGYjoTxdnTZOOs/lZnm0ax+YInJKnSaZDmyk9/n6+pwlwHx/qDAZZNU8L6icm6CVonUkoETkI1Ps/yxzLD7NunuiyuiBE+a5BnVRw0jqzHz9RM16aKmfb3jCd9Ng/ztfNheWJbMl3SrNMnQP83iuuwlCR/SwmCwzvx7/6V93pLOvQuldNDAM3R1tWCPrmqI3riDEEQK1KF+MsxVIL8lR5yO/ZHb9+6Z3NT5pI8knggCClvX4r32cKXsPXY7WJBGpJr2IPI6x+XhJQ+RIW6xL+Zks7CG9ztIIRnoaXrLM252w0pw5vuEfIMk2QlExuvk0gQyJyRsBSQE6oyyCBL1eQ/gR+rfRZvt/EXx2F19fyYFYByHXRoLVxvV+nfig/TAXEfz4qm+2cjuYNtGA+sL9PFRe8SCyF6/JV3jwz9jxnwGPhaA/geaNDOXSol1xABIk67WD+1SJRs2SzCV/cj7Dxiob4RAvVLABuTgUhFQi/TyX9dpC4n4u8TG/B1Uv2q8mqOypxbOMMit9oz51qC5ZR7EGKFb/CDTNJ0UE97L6polvyzYTKz3oZwfdoCgeeABM9ePlx329GVHHMC1ZcETPquUTHq/cVEKG0nu1mEFlSAjC4el9fArpqEQy84eVpZomjs4iqtWL3Y63/nHfTfXOO0OCab/M
 MCmroQRC
 cKCBHdSNZN2JhijP0Uois2h9heWjWKsMUewm8yidPcvGhE99f+OC2qUbzTYey6MNwyVAlrQOcFPmTP3P7n/WDAnXneZakteqtHb4XlawibsNol8e2HFofwYsvwOimDo5rxQ080648wI/+72sVXEeUhYCl1qT9vrBEaN05RCHhS2LKNyAi4ru1b9P1Ng4l1ONvb2ksjZX65B0BkQZRW3C2V8/zdcaEDX2OJHYefIr8hYncs6PXPoXj84DxXmoRsp/An3j0+vyBXknHAKjbP3B5waKpIPO6SO1HETIkUvH1vXwYctDkjK7MXF+t3XYQwFcctVMn0xkTmrOrHbeDdeIEZWoagp2Kkb3Sh6vnRaIyfq3Db9icmLWY6nd6WSJblSj2EINuy88HVfcWmx47b7RvkwhVqjHG8797pONZoRkXfqzWSGu5cPuzOhJt/3dXMdFsUbKfR1TO5uF/kck17wjnaVTFfPH2YecOVbnDRte06eB0ylMafmHNWg2kHonJzqo0L8ureOTjk+2SQP83QHdgMWu6Z0/hOzG3Ktr8qmCIzOWQAXGx5eMp2QcrdXefm+mb+dHWuGN+P4wMF+QizKC/4c0Mz8q2RYF2DCPJdAn8l9M9leE88mW+pElFPYJ3BFORm3kux0K66A8URs7LV/mWdd27eMN4xmx4vojOwOJSna00bNKLVwvoyJQIZdO36ffaoHcQA7zxlElMhfNy20g13NQfI9ImbfVikilQtGwHUAiKRfDXvucVf+qDqsKZwuLwAchWAvhUfqhpw4iBYaaxfFbO48KB2RzEuG+g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update copy_huge_pmd() and change_huge_pmd() to use pmd_is_valid_softleaf()
- as this checks for the only valid non-present huge PMD states.

Also update mm/debug_vm_pgtable.c to explicitly test for a valid leaf PMD
entry (which it was not before, which was incorrect), and have it test
against pmd_is_huge() and pmd_is_valid_softleaf() rather than
is_swap_pmd().

With these changes done there are no further users of is_swap_pmd(), so
remove it.

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/huge_mm.h |  9 ---------
 mm/debug_vm_pgtable.c   | 25 +++++++++++++++----------
 mm/huge_memory.c        |  5 +++--
 3 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index 403e13009631..79f16b5aa5f0 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -486,11 +486,6 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma, unsigned long start,
 spinlock_t *__pmd_trans_huge_lock(pmd_t *pmd, struct vm_area_struct *vma);
 spinlock_t *__pud_trans_huge_lock(pud_t *pud, struct vm_area_struct *vma);
 
-static inline int is_swap_pmd(pmd_t pmd)
-{
-	return !pmd_none(pmd) && !pmd_present(pmd);
-}
-
 /* mmap_lock must be held on entry */
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
@@ -693,10 +688,6 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 					 struct vm_area_struct *next)
 {
 }
-static inline int is_swap_pmd(pmd_t pmd)
-{
-	return 0;
-}
 static inline spinlock_t *pmd_trans_huge_lock(pmd_t *pmd,
 		struct vm_area_struct *vma)
 {
diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index fff311830959..608d1011ce03 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -74,6 +74,7 @@ struct pgtable_debug_args {
 	unsigned long		fixed_pte_pfn;
 
 	swp_entry_t		swp_entry;
+	swp_entry_t		leaf_entry;
 };
 
 static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
@@ -745,7 +746,7 @@ static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args)
 	WARN_ON(pmd_soft_dirty(pmd_clear_soft_dirty(pmd)));
 }
 
-static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
+static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args)
 {
 	pmd_t pmd;
 
@@ -757,15 +758,16 @@ static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args)
 		return;
 
 	pr_debug("Validating PMD swap soft dirty\n");
-	pmd = swp_entry_to_pmd(args->swp_entry);
-	WARN_ON(!is_swap_pmd(pmd));
+	pmd = swp_entry_to_pmd(args->leaf_entry);
+	WARN_ON(!pmd_is_huge(pmd));
+	WARN_ON(!pmd_is_valid_softleaf(pmd));
 
 	WARN_ON(!pmd_swp_soft_dirty(pmd_swp_mksoft_dirty(pmd)));
 	WARN_ON(pmd_swp_soft_dirty(pmd_swp_clear_soft_dirty(pmd)));
 }
 #else  /* !CONFIG_TRANSPARENT_HUGEPAGE */
 static void __init pmd_soft_dirty_tests(struct pgtable_debug_args *args) { }
-static void __init pmd_swap_soft_dirty_tests(struct pgtable_debug_args *args) { }
+static void __init pmd_leaf_soft_dirty_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 
 static void __init pte_swap_exclusive_tests(struct pgtable_debug_args *args)
@@ -818,7 +820,7 @@ static void __init pte_swap_tests(struct pgtable_debug_args *args)
 }
 
 #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
-static void __init pmd_swap_tests(struct pgtable_debug_args *args)
+static void __init pmd_softleaf_tests(struct pgtable_debug_args *args)
 {
 	swp_entry_t arch_entry;
 	pmd_t pmd1, pmd2;
@@ -827,15 +829,16 @@ static void __init pmd_swap_tests(struct pgtable_debug_args *args)
 		return;
 
 	pr_debug("Validating PMD swap\n");
-	pmd1 = swp_entry_to_pmd(args->swp_entry);
-	WARN_ON(!is_swap_pmd(pmd1));
+	pmd1 = swp_entry_to_pmd(args->leaf_entry);
+	WARN_ON(!pmd_is_huge(pmd1));
+	WARN_ON(!pmd_is_valid_softleaf(pmd1));
 
 	arch_entry = __pmd_to_swp_entry(pmd1);
 	pmd2 = __swp_entry_to_pmd(arch_entry);
 	WARN_ON(memcmp(&pmd1, &pmd2, sizeof(pmd1)));
 }
 #else  /* !CONFIG_ARCH_ENABLE_THP_MIGRATION */
-static void __init pmd_swap_tests(struct pgtable_debug_args *args) { }
+static void __init pmd_softleaf_tests(struct pgtable_debug_args *args) { }
 #endif /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
 
 static void __init swap_migration_tests(struct pgtable_debug_args *args)
@@ -1229,6 +1232,8 @@ static int __init init_args(struct pgtable_debug_args *args)
 	max_swap_offset = swp_offset(pte_to_swp_entry(swp_entry_to_pte(swp_entry(0, ~0UL))));
 	/* Create a swp entry with all possible bits set while still being swap. */
 	args->swp_entry = swp_entry(MAX_SWAPFILES - 1, max_swap_offset);
+	/* Create a non-present migration entry. */
+	args->leaf_entry = make_writable_migration_entry(~0UL);
 
 	/*
 	 * Allocate (huge) pages because some of the tests need to access
@@ -1318,12 +1323,12 @@ static int __init debug_vm_pgtable(void)
 	pte_soft_dirty_tests(&args);
 	pmd_soft_dirty_tests(&args);
 	pte_swap_soft_dirty_tests(&args);
-	pmd_swap_soft_dirty_tests(&args);
+	pmd_leaf_soft_dirty_tests(&args);
 
 	pte_swap_exclusive_tests(&args);
 
 	pte_swap_tests(&args);
-	pmd_swap_tests(&args);
+	pmd_softleaf_tests(&args);
 
 	swap_migration_tests(&args);
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f0bdc987596..d1a5c5f01d94 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1875,7 +1875,8 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	ret = -EAGAIN;
 	pmd = *src_pmd;
 
-	if (unlikely(thp_migration_supported() && is_swap_pmd(pmd))) {
+	if (unlikely(thp_migration_supported() &&
+		     pmd_is_valid_softleaf(pmd))) {
 		copy_huge_non_present_pmd(dst_mm, src_mm, dst_pmd, src_pmd, addr,
 					  dst_vma, src_vma, pmd, pgtable);
 		ret = 0;
@@ -2562,7 +2563,7 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	if (!ptl)
 		return 0;
 
-	if (thp_migration_supported() && is_swap_pmd(*pmd)) {
+	if (thp_migration_supported() && pmd_is_valid_softleaf(*pmd)) {
 		change_non_present_huge_pmd(mm, addr, pmd, uffd_wp,
 					    uffd_wp_resolve);
 		goto unlock;
-- 
2.51.0


