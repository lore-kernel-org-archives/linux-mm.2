Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAB1CD8C85
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 15:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8228F8E0006; Thu, 13 Nov 2025 10:38:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3278E0002; Thu, 13 Nov 2025 10:38:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CCA8E0006; Thu, 13 Nov 2025 10:38:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49F448E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 10:38:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06B5A160A5D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:38:31 +0000 (UTC)
X-FDA: 84105990822.03.70B716B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8987314001F
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:38:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TYCzqV0Y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y9aYqBpR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763048307; a=rsa-sha256;
	cv=pass;
	b=N0Z+A5sRvRuBwZupKTpnUY/gS2fE3x6In7zscHMUINudXXz+LLAOliiIMWll41rQeA0FXK
	5Yb+inEoHNxwTIzEISkVNFchrNN/1S1sLQCSD2AsJawb4o3cK9HrxwFzkc13ZcQ2byHGmQ
	iB6IaeTkNWa/+1r0HvJaK1/peBg8i/A=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=TYCzqV0Y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=y9aYqBpR;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763048307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ab6Uc8xj5uVAvD0uUt6AKk1KfouZY4mRIdRX43TD3lg=;
	b=jSJYZK2hxqfjRnZuCBPD2dLq7F3icl174pqEh43sLzz3cYCvWh722M20iz05flscqcSgqq
	xfSsGWQ39Tbt6hwfsW6MgTFEuQeL4RYg9142PYBzZHbu9+wx4pHFEidLRxF+TOusBz+4ZE
	+pcV7/hbxEQRASEwtLLCoxmTbyyunCE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADE9tDc012292;
	Thu, 13 Nov 2025 15:33:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ab6Uc8xj5uVAvD0uUt
	6AKk1KfouZY4mRIdRX43TD3lg=; b=TYCzqV0YaFZBHUY10N1Zict+EdfwVFa6lY
	8ji05l0kWqW4soMBl6UGqcD3Yfddc68e5abp4/wIc4D3l5fkRm6WyDWHP8pytdmt
	2ZUqLWFgPPB/gHd4BG5LLXENHrlIS7HKhd8Bv0PlyXMmB18+IR0zTzv/otkN7Wki
	WIOSuZ8otN+V5UXsYfM6r033nVQNu0i1QQGwsM/PkbxJUF340/g+jSKwbB/JI65h
	mRu+05dHLWTiarQKsJrhcZCCfgTZ0ABe7WOzIdL44eR1BoYPqBa/iOu5MmYXuKE8
	fx21LF4kQGzEYDN5EIx/Ers/nNRIyXiNBZBvvFwoCeXmpC4LQKew==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqt2kb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 15:33:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ADDwOh0027744;
	Thu, 13 Nov 2025 15:33:05 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012054.outbound.protection.outlook.com [40.107.200.54])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vagb6pt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 15:33:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mbNyoWSS5loHlGaLx+cSgsduFEjBcoWJu5NMK5XMWAQXaJ0EhhHu9o2ZKU1aYfKyBKNviIDGMOlCFoEHU1o0I14DwnjdBKv861toiOt+IlGVeEHAATsn4o5i4VK7BWZf3unSFvCToK+aHONWDz5xT6NqXoKyttcfZx8uj4A1WY7Dd4zYcFCY81fuDAFQN/CznFw7sQQSNR9L23KHDLJpnvmZso6QmSI8k/sa2uyYOaQ5BlIxBTMFd2yIvcFriER9xmJbPVhJG2Zly5C9ew5EVgndUBMVB0+YkUS/QzhA3iweN1k4VD8NlgkVe0YisCDc++8Rayjv2oUtCK0lT2h7wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ab6Uc8xj5uVAvD0uUt6AKk1KfouZY4mRIdRX43TD3lg=;
 b=ucs7MoSRBX4MDHLQ2cClJzJQ2HYIYJMICAFPUrIkVf7JpoKAwxfPaSoKyeS1JgurvDza1KbWTM2pkhaxraVNbrxupS998cCBNNBicJmbdDsrDDqNj0+wizO8/w6mKmTVNoSRt8e4AT6Sds7Mld2ZLxYcAc/eKMqsqHeXLotbIn6aSKMdpT0POnhqJ4ZwVf25SBUpBBYcOhj3Dh1FatW2zN9AeVWW8tZSvqzjDzoHWAUjheN7utftAIVacwNmwf92LbVIL7yrs0NhT5i0tSx0QyBtlGc22sXflJ0x8MaKd74gfPLoLI3zj/A5VYInNEoccBVbfls+Xpv1AB7Vdm0KZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ab6Uc8xj5uVAvD0uUt6AKk1KfouZY4mRIdRX43TD3lg=;
 b=y9aYqBpRagMXJW7D0jr01/B3t9ntNo4yzrsEvgCVPeyoEG9IEPMuzNaKpr0WEhnMscoD9dSSnvJqNcPopfd/2CArkn94KCKynuR2Vf+7XAVyeUkbAMQmrbshKj30FRcRJe7byzUldxAoDYSWOxK1g4VK9FUNaaZ7gv/qf+w+qQU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS0PR10MB7980.namprd10.prod.outlook.com (2603:10b6:8:1b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.16; Thu, 13 Nov
 2025 15:32:58 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 15:32:58 +0000
Date: Thu, 13 Nov 2025 15:32:55 +0000
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
Subject: Re: [PATCH v3 02/16] mm: introduce leaf entry type and use to
 simplify leaf entry logic
Message-ID: <4d8510ae-1ed8-440d-b864-d75147c05510@lucifer.local>
References: <cover.1762812360.git.lorenzo.stoakes@oracle.com>
 <c879383aac77d96a03e4d38f7daba893cd35fc76.1762812360.git.lorenzo.stoakes@oracle.com>
 <b55a87cc-239c-4475-88aa-6296e67b4e7d@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b55a87cc-239c-4475-88aa-6296e67b4e7d@lucifer.local>
X-ClientProxiedBy: LO4P265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS0PR10MB7980:EE_
X-MS-Office365-Filtering-Correlation-Id: 3f589e65-15ca-4f06-bae7-08de22c9ec6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?46eQhyCGLj9NS25HIHqNgIhL/ZZOA2l3xb3xAVkdVEN8Rw+Ex8+qXEnMfnQ/?=
 =?us-ascii?Q?9Vddk5tUOuJWQPJ+9kvMm+i5RnWVPPYTk12ucdv3pz/lsLpmMe0gqYk7A6r8?=
 =?us-ascii?Q?YtnQLktOHrJpyjnGC9b8s55NVHlg7sku4eo4RXGRZSLsO08h7vro6Ih+sKEV?=
 =?us-ascii?Q?gmxh8ld+Pdz+ly5RI4KC6IfdtNDvR3qvcnhSf956T08gtorCiGL2MrYQmiZP?=
 =?us-ascii?Q?eATKOowLsAgHH6/BrZrMW1Z4+WBLa3dlu4vuiElqHOwxfuxCqDcnGev81hhv?=
 =?us-ascii?Q?6HmQ3y0my180co+jeRaKISEYLPtD5ed21HaxocT6o8YPExW7zmsGRkLcx8vk?=
 =?us-ascii?Q?W2Vgvyq3qgOW9X6aqoG7Z3SxLK+zDQOvtbfL1DAfOjjPlEBQWinCgP7dpcPx?=
 =?us-ascii?Q?+JmuopW5YPEjW7Ph0FvCjI0VanBhIb7jicf/ksMaSpBzGBbsR3Y7SmuB8YdM?=
 =?us-ascii?Q?1aPeFXzjK/kgGV8kNvFSA/8bJxktnArkNZGJXUA2YU+KzvdH2Feeku0/J+cr?=
 =?us-ascii?Q?4ZCkDi4rwCOGEO2RI/fufrd+rhbGQylssdjw3gMvbgr230DisJ3CP/7ePkYI?=
 =?us-ascii?Q?Ox1IQhXfkImiA3CtwKYNcubI+SpPQzSvM5rjijsVqu91PCrF7grDpwSRu7jR?=
 =?us-ascii?Q?7wXr98+M1IW5Ge4i24yZl/jC6gGrIvH02fuy14mp9X2SuxLXPFMtxb02wzTr?=
 =?us-ascii?Q?IwFXIvq5OtgRp38RFtMNjOuzn6l5GCPS61iKH9XGVrHy5NSa/4XUDc+gl/lG?=
 =?us-ascii?Q?upo6tWM2T20kxjBhhm8sFuuXfhGRYzKiCrWoerhH38qM05LKf1CFeoLb6d87?=
 =?us-ascii?Q?XxmT85zwcd9+c7ZZezSB5+Z9iVgPuoMywE+uZxlT726OsvRyase/UoTEN2pB?=
 =?us-ascii?Q?j4nAA2o+WcqSR8MY8sDALD+peFchDLtPuNMOlCl8lBwrzjlzPhB5vzOJXQkx?=
 =?us-ascii?Q?dSXzhjZAGug21EMvDZq+mTRSdQKBup9QWo2urZYei7GQOEjyjtpqPxGd7ONN?=
 =?us-ascii?Q?H2k3xll9i/9u4BYwHveqtwFPcqOES8HOOYHz60ojzZKrJon0H0WOLiP0uZMq?=
 =?us-ascii?Q?9c71UrdUXBwUZnNEvU19If1YfFHEQ9JIcInKMcblgs2ZzZpUl9bPYmNA/oP0?=
 =?us-ascii?Q?oti8layCf1WIU4ON2LRJ52YvMXx4APr0eFxD/QR1mFuN+YwVYlMe/B+9f9YT?=
 =?us-ascii?Q?SB0JOgNwmvhIm4Mdo1TgzFDgNQbmjj+ESviR/zWKqiH1mTD52DMrj5ctX6yX?=
 =?us-ascii?Q?alEFJMd4mrBmqWkisIMlq6t9kh2yeT3vDGTWav204YF+fJUQeYHu+CTdAbLI?=
 =?us-ascii?Q?r4xVqEucRaBTROAODXOSVjav6gM8d9/nEQl2kce0hpXIiEmMwVVDgc55lXyh?=
 =?us-ascii?Q?mVln4S0ILd92Iie6TFEIHwZ4QdSFeDNjPwfIsQRvi+gP4KrHJH4idp5yIFZe?=
 =?us-ascii?Q?0l7412thoODaq0FtvMCV36y+YVDN6K88?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hgvrkHMFsDn/LtpogLXXz08k6xISKwBhENblta5jD2NtswUvgzci66JdstYz?=
 =?us-ascii?Q?NV4VxVt1vON6+SbZMRvnTLZgvIobKtUAfcJXei4F0LD2Y2/WUqOBGM9WKZ9z?=
 =?us-ascii?Q?UcpolA6s6B+s702bbbycA0Ro4O12Rz+KGLtIdsi9tnOpE1Z8DIaNGGpJUP87?=
 =?us-ascii?Q?wBJKtC1AEK6PrnvHo1WJL0a1pZAce0mpRCfddMkeSa74/80F9/OX6SUxEt4I?=
 =?us-ascii?Q?oRDXLG+coLhYUDt0Es443Eyrvto3Ed0cGjxQR7o0TAdBwA2QfFuE/RubbJGx?=
 =?us-ascii?Q?29WUhSBav4gqWqZGodhc9WmNHQOps8Q02zhCXPNU6OXboLiSgiAQlOgiQsKR?=
 =?us-ascii?Q?HOsjyDayVXwnCTwLR4mUQd14srqq4cEb42l9GWSR7gnyBbFmjPUoycdlRec+?=
 =?us-ascii?Q?bFEsEMDv8+M5GcnKrCjhC//sHPwUA6Y6ix8LepMtSzl2TWCMYmUHzhe7Oqgn?=
 =?us-ascii?Q?XjB4+ESR8YE3umRoeP557lUfRyp02156GW5ryOPTU7drohhOd4uMM6acnRXa?=
 =?us-ascii?Q?Dmvc3rvUXQuifl/XgEM+Q0YDkhqyIE3ZPADLssqhxfg6enZjh/Ju3eZMFqr/?=
 =?us-ascii?Q?mQWwK9x8K4i21gti9b9m4Hs+jENqE4+AabmKYOXt3TU2HH0GDzNbMogBRTGi?=
 =?us-ascii?Q?S5BhzlDDgYtF98Oa1eUiE9vMYamcKUXlX/o1PLajEDOnicGYeHFLJftijsZp?=
 =?us-ascii?Q?wg9kUTzNjdY5z5l6L1B5Mf7sH8auPfdaC+uvlSNoUAzyNrs13AT66zKh6a/Y?=
 =?us-ascii?Q?pdaFSbaQXF5XLfMb9APO+VegnsXL80WiXzJAwemujwjbB+HZHBvNWccQrm17?=
 =?us-ascii?Q?T3vsGr/TCHYOk8vm7bb6+HIaRsgkhkec03/k06rWQRrWGy/gRVP5WruhT+O9?=
 =?us-ascii?Q?RpBI9D8jqM6/GsMQn6gQdUi/4SCGdzSITxwERpK3EKXYSpDTOp/toL7xDFpo?=
 =?us-ascii?Q?nTawA5nFz+KcCrhWUMoSUcRgbXlb5zMbBEj4y9zaCs/8Mpt19NYEHIIroR7F?=
 =?us-ascii?Q?o6WM/0SkVseHvyT6EujXVQ88VvJwkl/0RDwC+qXZPsjT16OoxFmjudbfGmMT?=
 =?us-ascii?Q?VQy0a1phguptbyN+904kPoCGasI9tZTj0sD//lC+GaLzZ+ttRETrH/3eOQ6N?=
 =?us-ascii?Q?FD4w+dVLKasEQvxAzXKvqhq/zDYrDIieNZqedvDd4YK/LhDO+GqFctaGuLdC?=
 =?us-ascii?Q?o3Wcyvl8E6IfuAbxXPQvK5RKQEgyFtdG+C8/2rWGVLmrAIw3HX4mm6zqRZP0?=
 =?us-ascii?Q?e/AuEyUc1cYvLiw/3RllJkp7vdUUVKZKlkbnApIUSMQddbsSiKLwA3Xlk+AQ?=
 =?us-ascii?Q?dI/RRW9P9JI42VruwCOea/p+o2j8J/T4vxp6MU4Qb3tCW1CofTPj+3ljVli0?=
 =?us-ascii?Q?PR6yJWKAZwPlZgFbAtLJta5KraNCcCpa8rri5exEs7/loiWcvDYTqIG/Ook4?=
 =?us-ascii?Q?OhpJh90ECAqcm0UPZ7sNJAQffzbzHo+mjMvNRmTLn3G8PPdkBXF/pwbr/gEF?=
 =?us-ascii?Q?N3Zv5Lj58lVLnFeOs9mURiRC2bhrs5a5b8mvopws6O1VjEeWTdNo0eUvfc6d?=
 =?us-ascii?Q?Fo+vtX3UR1Ll8BAvttyt7aeZbKfEldiPSRLIeiWaMcPnewTso5lxrIDv9Bj6?=
 =?us-ascii?Q?qw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Kjicl+ag4+vz2T9yCAkShMmvaIb4NiC2CzG+an4d7Nf+B62yCuCCWLSxnZ5fU31Dwbs5O50uFmg2XxrRPoIWUeeeSqirY/pkWeGeAqshXBS51O2s2kFnDDS4ADY90QnvUszk3U/aA8WbG3eZ1MXuPJ9+sdArLnrQAP5/DPHUI6GLrP7DP8nJM0mr0B8jXeEtUOnxOdD/4O0UfI8GL2X1HqPzPbxmjiSs83P5FhXzpzcK2Zh71YppVG97nm2M6mcRL/SmgVr86Pd+VF+MyDra0MmbOB7EcyS39XNJ2QQCyaPPytnMBzZUrs+qj16gcvRpyfINrJufg0/pq858S5HoQ6d6d9XT6W5f+lv7pTrLktti22kap8abkrK4xKWEqQKnQGzgbFhvmTvZK6QWyWomMJKdqpFg+JofroVRRX39NiGNK8eivQ3+KRX94h3TK+dDRA+QhTIyrDAMbqTAuSw58jNsgqqI/9CIa2X2HQ38QweFyGSB7NT9+XirnRaouipAauDSW3fUELegpm/976zoWTKvmv5wyK9+PBCeHmf5UQwBSidXIZfuT7r3yv1i+z7JudyR0SyKz6IEM32GqQnhPBRgW/RsfbgiH4VPJfxxdJI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f589e65-15ca-4f06-bae7-08de22c9ec6e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 15:32:58.4711
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nieS3OaXPMl0oN7/MnrHtMHirKvag9SSdGmw70ACeZp9xavpMVFuu5FHDJAdskRJ4BYpqK685WhXxXOUfUfqBav4lbhzncWVtNP8gMNa2ow=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7980
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-13_02,2025-11-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130120
X-Proofpoint-GUID: WoQ43RVj0uQSQui1M2NTICKJxwnh8BzP
X-Proofpoint-ORIG-GUID: WoQ43RVj0uQSQui1M2NTICKJxwnh8BzP
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfX/Zcm+1wSPsP8
 uZW5A5NWhx64sRrCLO3KaB9SUw4Hq4d2AOCWCepMsgPDd1aJzGEvLsVuYv2rs4OujJWEB79edew
 uv4f0ZKhxi8HQWfvEMuZR0ddPfXOHz3UuznWDafwq8If+N0g6Xs9Jk5RnK01/1bZ+8jQ7aLp65M
 pOPuJChEgPah6Tpwl5oBJpn9lXtmTj2Gb4CR6tz1671aibA2B+MVbtff3VeVwFUPZwBq8+zRboV
 2747h5k/ORrVPQW4/WDlB69Kmic+HKZYqsfDMsODNO8XjfU0F5L3XWIfd+gfmXxuB3T6X9g7LCY
 wAvC/ITPsQPVWkpNOgL+PMjF64PcJSyfFnzESVgy9YL6aVGCQHvR+MGaVVDs5MYl7LUVgk52w2x
 Y96AM+ZJixHlMNpkLnbGmNVgsy5W9GcFn/BNpS+TpOrHyu3g6GE=
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=6915fa31 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=_kY1ol5zgQWaeB7_AXgA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13634
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8987314001F
X-Stat-Signature: n7msuhamdng6g3w3hiasjn5fcdwzrsra
X-Rspam-User: 
X-HE-Tag: 1763048307-743199
X-HE-Meta: U2FsdGVkX195XuGN6GCvahXucfMd1qFvTDGOwxikNNO21Yr0wKAkuW57eXCSMVfkLW9dKzw+dCbjIskkeEC0+LXmNSB5CzT0WgYzf5FxIttvwkRIn58/raF+G/tiy+FozKIHZ6kt8+r7pdgV20T5Y1u3NWNvX6uu5PqizmU7kjJvWUGLJ4Zo+sJwKFpnLKfapX5F4avAMs7iEJx5WVx+RSNiHdWb2M/8INJ+mPPldqYOslOXPo9BPz6UCvpRVOQjomOxq+sG9I3QTJmhtzIAmr595NasURlv8OCbnTwapLTNqDFKZ2UJhafnmYTiSGBoKbMGQlvqKRGOro2Nn8JiqHHh6McIWjzdMNfPd/lgPHDKZ5SMQa/NdzeNRgSTVO3emDBMuqgH1Ds7PT641bR4lcbL21KESMNBQ7QVvWgytxFO6UXBqSbQjhe9+d+vNFviSIq60Bgc7klTbtklTeov9Vvs5MnqJHqDXnjEUqEY5THQD76I37qu6iwb8E1gN3zyF11XXpGehOkXvWXXafIC34JRY4JNuTIHo+OVkKDfkYXAXmGDmXc2WO+WChjPT0+p7gFFWKycehmhNRPyQERBMk2PMqsOQVb8iADmR+RWFBibXkWKVfHpFJOyYHi+Qtkxu77A3FgciBTt2B63kVU1yeZr9S8IQTxlCP8GeH9ikhBhvTA2vthiuk1Fsu6Eg2mUpBZ4nRvZo0Vl+FOP+0kaduzUyoK50hAvc7SXVMCsqdApHEYCXWUtKotdd9Qw7efKm6LNSCpOVJ+czoWv6QHuA/U5SVgpL59s5Vx3GNmIEDy71FroYoCJFSPkVQwye+c5PFXDO1Dshgz21OvHvHOmTS4/49r4rS+mBzouOKL+qYpMNsb/P4dWyRTNkaIPGHwVikzwzxq+ZrFbHGL+ukIOIDicGWEClaS9Plq9QNzoYrZ2yCnJU1wvpiYvL71284PexDfeR9b4j6RIVNtfEpC
 BAnAybSA
 CrHyt7TURQgOMde5yJeuodKWTZnBnQSLRwX+f0+oblgL7r2dEFhDUEBEGPj2gCm82LZMvkRgX3sl5JDVCUYUMe/wN0xamKzRw/qx2XqG4Wyhw0vrYlv7+gL4dqRUP2m/k1qfNjbcoT6ic55Z+Iw/yYpLYn6DK0vLXtyF6n3GxK/1uVWGu8QvrDAnr7cpCNqM5hrDSrzpaNw3pj8fUP0XHqk4jF0LXUyTp0FtBy5L+IZMty4VEMEls8YP0XquubPRjOJmkaI8VNvuDGRWvMuLFGDwO6hwVgcU2m5FXjZWntmHaqm1u667PMAQN+1+qZOoZWWjxc9Ikw2FWyCZMgBDm+ArPPf2LKPymUIl8difM09K/enBY2f+964fHwsbDjnrw7kkko3oqIaYhRj2zG6e8cfbUXi/gTDTQnf/rTo2A16Gc2C60bvrjC30edghDMBP2hnvuJAxtb6RyacywwjOwzcGsMrri14+kA9lJkvzZvfxE3qu8Ld/D8aEintUJCowyLKKFwwbhR0VmLlJw+Ob+KRe2md7jT7EiowAKfdLhJcPFeXmfFl0mf63sLg3piddnbZ1IdMEmjE5q+B5Orlofb59vbjasU0BM4qvVNtFQ09J9xN+F2QbouJRxaUSRPJsgdF25ueBxjs0FsOYIWaFO/LPrfl9VXm6RD8OxWlndvHuIfuM40KZdZqEyxkBM6bDf7mP1+nAS5Qb0LL22PqSsFaTYOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OK Andrew please disregard and drop this, I was being too paranoid...

Comment at SWAP_ENTRY_INVALID indicates 0,0 is reserved as I thought before.

Cheers, Lorenzo

On Thu, Nov 13, 2025 at 02:56:09PM +0000, Lorenzo Stoakes wrote:
> Hi Andrew,
>
> Please apply the attached fix-patch.
>
> This ensures that we do not accidentally conflict with any valid swap
> entry. We can do so without occupying any additional swap (softleaf) type.
>
> Cheers, Lorenzo
>
> ----8<----
> From 78439310eded5db10692c3e8d0d322bdd6409eff Mon Sep 17 00:00:00 2001
> From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Date: Thu, 13 Nov 2025 14:20:34 +0000
> Subject: [PATCH] mm: avoid any possible collision between swap entries,
>  SOFTLEAF_NONE
>
> The way swap entries are encoded varies by architecture. For x86-64 for
> instance, the encoded swap offset is the one's complement of the specified
> swap offset.
>
> As a result, device 0, offset 0 would be encoded as 0..01..10b.
>
> This means it is possible to specify a PTE entry that is both device 0,
> offset 0 and something that will be identified as a swap entry rather than
> a pte_none() entry.
>
> For other architectures, the encoding may preclude such entries being
> valid.
>
> The softleaf implementation currently depends on a 0..0b entry being
> uniquely identifiable as a none entry.
>
> This is therefore not a safe assumption, so let's fix that.
>
> PTE markers unconditionally occupy a softleaf type, and currently use only
> 3 bits of the offset field to encode their type with no further information
> recorded.
>
> It is therefore no issue at all to add an additional marker type
> designating the field as a none entry.
>
> We also make the none checks more canonical by adjusting softleaf_is_none()
> to reference softleaf_mk_none().
>
> By doing so we avoid any possible collision with swap file entries while
> taking up no further meaningful resource.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/leafops.h | 8 +++++---
>  include/linux/swap.h    | 1 +
>  include/linux/swapops.h | 6 +++++-
>  3 files changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index cff9d94fd5d1..74fd95b55e9c 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -40,7 +40,8 @@ enum softleaf_type {
>   */
>  static inline softleaf_t softleaf_mk_none(void)
>  {
> -	return ((softleaf_t) { 0 });
> +	/* Uniquely identifies none entry. */
> +	return make_pte_marker_entry(PTE_MARKER_SOFTLEAF_NONE);
>  }
>
>  /**
> @@ -72,7 +73,7 @@ static inline softleaf_t softleaf_from_pte(pte_t pte)
>   */
>  static inline bool softleaf_is_none(softleaf_t entry)
>  {
> -	return entry.val == 0;
> +	return entry.val == softleaf_mk_none().val;
>  }
>
>  /**
> @@ -199,7 +200,8 @@ static inline bool softleaf_is_hwpoison(softleaf_t entry)
>   */
>  static inline bool softleaf_is_marker(softleaf_t entry)
>  {
> -	return softleaf_type(entry) == SOFTLEAF_MARKER;
> +	return softleaf_type(entry) == SOFTLEAF_MARKER &&
> +		!softleaf_is_none(entry);
>  }
>
>  /**
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 38ca3df68716..e5abea55448b 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -112,6 +112,7 @@ static inline int current_is_kswapd(void)
>  #define SWP_HWPOISON_NUM 0
>  #endif
>
> +/* Leave a type reserved for softleaf none. */
>  #define MAX_SWAPFILES \
>  	((1 << MAX_SWAPFILES_SHIFT) - SWP_DEVICE_NUM - \
>  	SWP_MIGRATION_NUM - SWP_HWPOISON_NUM - \
> diff --git a/include/linux/swapops.h b/include/linux/swapops.h
> index 0a4b3f51ecf5..04e74716a845 100644
> --- a/include/linux/swapops.h
> +++ b/include/linux/swapops.h
> @@ -419,7 +419,11 @@ typedef unsigned long pte_marker;
>   * PROT_NONE, rather than if they were a memory hole or equivalent.
>   */
>  #define  PTE_MARKER_GUARD			BIT(2)
> -#define  PTE_MARKER_MASK			(BIT(3) - 1)
> +
> +/* Internal use by the softleaf implementation to represent 'none' entries. */
> +#define  PTE_MARKER_SOFTLEAF_NONE		BIT(3)
> +
> +#define  PTE_MARKER_MASK			(BIT(4) - 1)
>
>  static inline swp_entry_t make_pte_marker_entry(pte_marker marker)
>  {
> --
> 2.51.0

