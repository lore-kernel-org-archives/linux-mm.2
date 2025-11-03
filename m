Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CEE6CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 17:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84BA28E00B4; Mon,  3 Nov 2025 12:30:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822878E0057; Mon,  3 Nov 2025 12:30:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA6B8E00B4; Mon,  3 Nov 2025 12:30:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE4E8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 12:30:40 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1AD113A264
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:30:39 +0000 (UTC)
X-FDA: 84069985398.19.BCA8F3E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4FD1F40018
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 17:30:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jSnAv3rv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P18flET8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762191036; a=rsa-sha256;
	cv=pass;
	b=O8CFKKVIENQHMBdzvaAYJnNiLcr0+AkVFTNMKaWuwFI5qT4HEcIQlYWbvILISlXM+TxrfY
	xzgq9/n/SQGUeYOff0bHkeCYZMTQs4GuxuuhWZe/ZrV1gJon8xaaGSNonhISV3ewcrJ5dS
	lsXByeASWJ2SoIItEuYiKqScedUgTFk=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=jSnAv3rv;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=P18flET8;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762191036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u4hMALxrPp6WO6iq6TVlY0nEs/mc3p46nmnDCV6l8Hk=;
	b=A9cdtuEzmEzr1izixoUc9viIPsYyrGn8HKM7nii9szEjjbIbMdTlqz1uU9lxXAEYpGAn/v
	ke0iQmDiuei8XJU3cGOTK39ij8Iu/fBrnilSehI71D6TxogkY4HyxQXtEod0ytP6tJJ2xv
	FPXNCfj11zQcLMPn8lbtd+DftFOGapc=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3HOMfd004371;
	Mon, 3 Nov 2025 17:30:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u4hMALxrPp6WO6iq6T
	VlY0nEs/mc3p46nmnDCV6l8Hk=; b=jSnAv3rvnmCZGsbR7UfSmeBv0HjCHck6iP
	sfWYIK5TzNKteO2dijFu9zBQQtbmQsHdUC+efw2wL9GtGyrLgyL47HWMfWcgtd/b
	VgQnDldl6WBbQm9KdWTqiJqTTTHw1iLKS3SvgPQuul58VFU/Xo1av1FAJsC11qN0
	/e1ExGwcAAQfnWq81dqpDStqx/w3mngsqRybpxdGE1zQr54lYb7IMHm8e0xYnuW8
	bXimKQJ5blQC/0trtmcYS5EuSwDTS5cgoYLjQlG5cHIqpPt9wcoujLD13Kpg/sdK
	ck90ca4st1YWYDm29VbnsHkr7k324aD0ljhXm7XnRstOc6T3ME/g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4a70rxg0jb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 17:30:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A3HEHk0009623;
	Mon, 3 Nov 2025 17:30:18 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013001.outbound.protection.outlook.com [40.107.201.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a58nbyp07-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 03 Nov 2025 17:30:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fY7TWMsyr7D3W+G31HG+GgmehyUFuRVokWiZROPOWzcasnY2z6sr8F3t4snB+j68bLE7Bx983JUu0brb884I3NicLfDPofAirguyC2swFs2SHgR/8pL2i/DN4Uk60IpDbr/m3zERsQpimb2gbkh9hMrDLJGsLnMithTpbzagfguc3IiS448y4n75C+rS/ROwZjMqOjyqVHFoST3OH6XDqDyH49bb236KXFymF4eeDzwgBG+UWn12LUuAp8x9HRyiyYqg61Da0xl0bxDZD3SH2Ip7a+ACLhk/WdNKjR1EPPfi94LKuNwDSISpjtL/n6o21x7Od8Y8wuBdPFnu8TdFug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u4hMALxrPp6WO6iq6TVlY0nEs/mc3p46nmnDCV6l8Hk=;
 b=OTMOH1Gh75j5wGSLOH76qq0NzjKrzpCfh21pCqEx0004gfgDq22BDrQ8mE7zt9os2OSv1mdJkFQY1a3k88DhyWWMuymIpt/GyWD78rjAW+dTOg9mRB+aLHorMr691MigHhC7eTnDYoz2d9cfulcVm4bt8HeASFeUhNjaATECaMXBfWzwwyPiJciERaCOhXRjfutdjunkOqlQcmvBsqTPL3skfXbpy1Zn38xds3ssI82+u2Mz5X4W2uvGVIfaged6M3wUf/Jdm/UrhBMm4HA+XAz/EphZe4180HaPrOMrcwcO0at9GI/aFT+0+f2ChFKknxvUrW6iZvqbhMta3OLREg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u4hMALxrPp6WO6iq6TVlY0nEs/mc3p46nmnDCV6l8Hk=;
 b=P18flET8eJubVcb51seA6ohiubLdvKU1xaTpSbwPIhDO6axC19c1anPAJOSnexZMCMS6eUCY4GCPqqMNBg4/pWj/kdX+UExCpTj7JxAis6JLSQaBwx8cmydeLMqdZBn3wq1AnElnL68nnxz4kVavfwz29oHyyMD2n2kFTSKoQCM=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8009.namprd10.prod.outlook.com (2603:10b6:408:285::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.16; Mon, 3 Nov
 2025 17:30:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9253.018; Mon, 3 Nov 2025
 17:30:13 +0000
Date: Mon, 3 Nov 2025 17:30:11 +0000
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
Subject: Re: [PATCH 10/16] mm: replace pmd_to_swp_entry() with
 leafent_from_pmd()
Message-ID: <f63cc2b4-77f4-4eaf-afad-9586ef57c8bd@lucifer.local>
References: <cover.1762171281.git.lorenzo.stoakes@oracle.com>
 <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38c26e75ed00263e9ecbebb0c045dd6d8183ec67.1762171281.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO6P123CA0040.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:2fe::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8009:EE_
X-MS-Office365-Filtering-Correlation-Id: 65fe7fe8-0053-4769-bb14-08de1afea5b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?D6ieFrXgw6wZgXdfjgbCB33c8SMeV2CKx5xMTJxPDkv9dur7/2cOAt6284IN?=
 =?us-ascii?Q?sKsjByHKjcPM+1RM4x5KyC3QUE4qt6gxoCzADEfteEl8Zd3pmjrkqJOU2lzd?=
 =?us-ascii?Q?UNM17RiglPZ4hXRoWz9zR8MOqxXpZfF0Zw16Gim15Gw+6vSNHFkt2tLyOP32?=
 =?us-ascii?Q?3pcF6N8toA0IimcYjlg0ONsd/Kxr9ZFwrlZLZLBzpY4FmvQGZObvNFFMSjS/?=
 =?us-ascii?Q?uztkDEIsbQ6RGICKIn3blOYvuzEjg8y+9zcEHqIKjgC1LqOJ0RmNPzDA2pXa?=
 =?us-ascii?Q?ROkucUbpZy0e2bzYzYFo2nQybBPdjFd5j8veT3G0ueKnEPk18KCPv/SqxNku?=
 =?us-ascii?Q?CbIjBiXvzu4ohXLSEMWZuzZ88/pHULutz2iSktYolyszLqCF0bJgLxufxbaS?=
 =?us-ascii?Q?F8V7IWK9dOORP7BSouMTnM49pKeUOoIH5nbGbfvmuV7EB7wv+CCFCVZyNyJl?=
 =?us-ascii?Q?dB6oMgmoUea1T8fdUBXkXIuUqwU9iJ7L5K5PZLYHF2351Yn8iAiPKgh7t+wJ?=
 =?us-ascii?Q?IA3EJ7vdtpe9xjuBli3hwvlrJIk/ACE0+spWMW1dIREMwxiKpk7l58I73Y9V?=
 =?us-ascii?Q?XhLjGqUaCfiABkEfXajT76j55IHMW30dSXopSZ5ZksWR/pyok0tFGi+NfyIM?=
 =?us-ascii?Q?6yb+aZrc7P3CH4NjSnj5N4MZk/F+B46iXhyKZl8+WnJxsBMZyIFV8q/oY874?=
 =?us-ascii?Q?V+j8rIKFjmpjvunVhX8gIctr3HhjWiyH9QlYOFCbdMmmjo8yYyBCFHpQbdYk?=
 =?us-ascii?Q?s1aco84zD5ceFOu5mM6d3t6vw1fL0sa5ImWWClfNhzaZo5kHdKd5tou1osGp?=
 =?us-ascii?Q?foHXmeiYIDWj+luVWLyVdmocOixM8RcZg/kXSckCYDsEeGAH13s4NbFopf9q?=
 =?us-ascii?Q?QQ3Xex7QvSkU43w3lbD7xeQzT7Bzf8kL6bwRiFpsCjSI3jYGkaZDU6WVBCbA?=
 =?us-ascii?Q?zDhGmn6XxopmBvFC2J9G/j+sOxAWdU8GeK7I8Frh9hks5qsWeJ1URnzNYZdu?=
 =?us-ascii?Q?e1viF7WQ+pD01NrgdyYzetn47G2N6d0Wqfjy1JMla01IC3xeTkLGW0F3QWd1?=
 =?us-ascii?Q?2K5qPh9ESj8mOTMQlsLl01BcaE9WRQiRVFFnuH/gsGVGdnmAO06SShoSRZx8?=
 =?us-ascii?Q?lRWM0lZ/0bdHkyy0EhKwcHVTj/EQuPnhdaDVpBQR/KdUXaLjPyjmEjgPMw0A?=
 =?us-ascii?Q?QTE8Nidn9DcYmGBtJXGKysLk+hWmSpJC4rpn3Rpsi3uTY8qPQ1vMj58Scrgw?=
 =?us-ascii?Q?OxwHUrnqx6Ff5hRnCst0SQg16RY6rtx9EZ+vHwKusGFdFpaA+7N7fPadJ99H?=
 =?us-ascii?Q?meRoHUY+tWuU68njURUCm0N9IOtOkvbEAWyRYkNU2yaqH5lcsRcnlvk1mluE?=
 =?us-ascii?Q?14eJTmgRCGhJKOQ5Gva4h7MbNVNoH/rslRTy/jhsKjDZO8/PLJu3xHP2Dy9p?=
 =?us-ascii?Q?roJiqbMGWCdS9HnN9n2T+tJAEJgt9OH9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zAIq+KiqpOIegZQqPMEbHfnwSx2759rqLjyMplFlqJlE+9VvtZ/xiCEnhecY?=
 =?us-ascii?Q?gEdz85Ro/uJo80E1lrQPGDTFsu15O/xwEhEsZlt8BvTKN1eAFAccH/wy+z7B?=
 =?us-ascii?Q?vhZhuAbD5CzEAxPn6mlrmiTyOK1avIRLqHawD69IDmYJqaPHtQZfmZyAcXq6?=
 =?us-ascii?Q?mS3q4Tp1qR32Mfw42X7CEpFnAT05lXg2DJXN+AWV12nZFVTtmqrS38UeKOTN?=
 =?us-ascii?Q?jnrJDhh5bvA0Kv9d2ojXkFYjQ9VOQuJvyucYjWfTkJyGWAMyUw3S4df0iShz?=
 =?us-ascii?Q?Z130LNPfeOAvdXcnVpQSf71L9a6fK+EXNwncUau6yb9kJFeWLCKBiva1ZAFO?=
 =?us-ascii?Q?jcLDbEN5WH49UX48keRWIe+TKZv1fCjySZ6xgyGSDkhyfj/Ho1CwkjZczCnn?=
 =?us-ascii?Q?owehlzLRn0GwRFuV1nD0HGCcWpgTG+ppskPUOWiEOIqZb/7nr5iM9i/izJ+b?=
 =?us-ascii?Q?qBIsn1Gv093Rt4qlrbkdjyG1sXEYfAZ1da7Z9BYWgWPi9N7r/R9e6PNBR3MZ?=
 =?us-ascii?Q?0V/oO4rcYaI/4zlNIqgujv3zg02twokrmovY8PmNqGcsxtxveKNiM+i3RqRw?=
 =?us-ascii?Q?Z58GZMdOcgFh2N3QFhoc/+v9bGJFB/1Gl0hnIOV5UKjsNSpQVDZILIlEFP2D?=
 =?us-ascii?Q?VHYgvxGx+Ku7gKYBHJEJ7EpImhdB7+xcDy4UDNya+szORwDOVWlAUeadtC5N?=
 =?us-ascii?Q?MZem7LxxVkgVRJBnbqpZU03dqUxJly4YVFH0ILxxDVPcaaMflRVHlcRuZaLh?=
 =?us-ascii?Q?nq9k3N0DrpXd9tq6iZdJB5D4ZLNUd3+4RK84TWWjNwl1wbA6YPPcrQhnRShd?=
 =?us-ascii?Q?Ks3l/x8gBTtQKu0ElekW9dzmo/5xcgowga9OEE6g9YlwzWM/r7dh4+8pU1Uc?=
 =?us-ascii?Q?wi9OP+EI1JuwNG34VwNRk9exVxXpHW8xv5qmLtvlwLf8k+mDQNwoQgzkiNXL?=
 =?us-ascii?Q?a8xOu+ne/aA92u6oaw193+KzWkxVRRDlZQqzy0zWef03y3Pamz07nPKhahDa?=
 =?us-ascii?Q?67SB2zH0Kvknzqx8aA3/P7WWIecICc5KYPa5djUqItLVL2jxKyFd/hpJvygF?=
 =?us-ascii?Q?eyjny5q2lazK0MAmTzCtacYbyKA9/NjiXgaMaF/df5DCKp/QLVmMklS3xKio?=
 =?us-ascii?Q?ZjHC2ro7Zd880EJg1z5dCHp+2tZi4g4zTB5osVM7L5+1QGNqqkoYiqYqBibR?=
 =?us-ascii?Q?CCcWrtYxg0nYBu+f+GfC8DtAe0TEPgBR9t43igsxMNqNh6y7dQqblPe0CXAd?=
 =?us-ascii?Q?Ybzhlo+KbN4DH/kgNMs2QaH9BFsKYSi6k55v1cFSXiSuKRs8NvapfRsIOMM4?=
 =?us-ascii?Q?03TthQ/sN26coCa78BO8fxSj6Qe38iEGNOC6z+HBavUG9UlEkzO4kww4isH4?=
 =?us-ascii?Q?EuA2hHd+SZTQUTtDu5FYLxxSgY7nwLb3R4ooMQDOi3sQCE/kByMO6hOoEcXm?=
 =?us-ascii?Q?6u7IkkGvkqS+1vG01Etd3CLCC7/V61oDAiazYXxqZRlz78emk+jyM0Q1Hc0a?=
 =?us-ascii?Q?dRO7mXMwrT+cLOCq5+l0YMOp6tFF7fw+wOz8mMb5XgOx5QcLNywFbHlVz76X?=
 =?us-ascii?Q?DrDVf/TOekjBiZOWhCDaO1JC9ZvGne4oHD12eTJoj6eLIUXPEETHMFDl0m8P?=
 =?us-ascii?Q?cA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iu4viWdd5CLx5JRNhi88pHT/PGYBfB39cfoGWPHlPTQu8a68VijdmS7BhGWwS1+oPULKHuaDyNnT45GSYkZK3mv1A4WwlscToxehuCQQQNK2JiQIL97Vx2g7MJLBeI7OHyCEV7f0/BEGaDClCWWfa/MuvE/exKKSpYxD+UKOnnnUQBFBHCBsFVgss2HI6/+nJsStadEUa2ATfI21iD6MxCmuhuuYrPYBTwR4/9HAt3GNgGRSAQXb4UXjlSzrDzDwVnRBlvXawNA5c9+Bw5HDlvI1chGwOoxGOSr0MPsL35Pn20tACwJ90NEN9qOznPy0nlcIue62Mg2534lehuFsVeaKW8Kr+ap6M4BlHKaDKfTWntxrSnYSJif0ZPTRJ+gY5E6wIw4anpe6oaAnzWJuA+WW9lMoPWzT3YoERMu8X3T75gWRucX02IIag4fzAfkeXMoP9++fSqwRldKtHDdoO4Ibm8ANCZO0PcothUF8PRx78ResFF69mllmrn/jqcNr+R74oujVpx3egorkpokGRyX6qBkdD5MY/yY1U0x1XT0kHjBAuMJUKOY1GwxYx1WWHza9fxOG7jlsS6rPNyLOlc+vbZXKku4u7ufqxmfGSVY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65fe7fe8-0053-4769-bb14-08de1afea5b7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2025 17:30:13.8174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xT/tNq3TEqgIgsGH9HDDGNleByucKTcn9wtA6OUy99mQT7xHMCCn6PNM25YeZUPiaibghYiX3O08MMMlkJpW7rECznyk2Q3n8OBgPMHk1yM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8009
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-03_03,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511030157
X-Authority-Analysis: v=2.4 cv=AJS1/0o2 c=1 sm=1 tr=0 ts=6908e6ab b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=2nnoC_BD_BCbiUeGNzAA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:13657
X-Proofpoint-GUID: A9jCTCvC2iu7mIh6EBLk6b30y24gMdZv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAzMDE1NiBTYWx0ZWRfX708jJgc54mBz
 y8+A/XEvloookUIvVeGNny7rp74m8iiGXx5oI/WU0CJlIuEF4jIhvldvks1C4g/yZV2X42fC7eR
 /CEqXWi9vncHirPYB4gB6uo/8veJlOMA4Q5JziisKS6/uNy+ZFkBirI+BitbGWPX7QT7cxnOGd0
 hwSnEvYfY7D1VZudsCibOLIDFaVAbjbs7mYryzM4ht3P146TxzVYAWwXvDKi7b1tzUTYloAT1gn
 pHFdx46JSCVC8zqhFZ7TTJXp1VGhFZp+OvHGtS8a7VCBdqsUChe4BGhWMVKti+faMr8ni3rRsVh
 JQZbVv669bdrLYxBW1kIc8hpI4hM0Fwtw8yP0iqZb0eclR+1lSLzFbTqiHruETx7C97MbIWev8e
 QDryw7oy88mIhkKMiMg4YTWQI1UukN38G/T+7W/r/sXasSgsFoM=
X-Proofpoint-ORIG-GUID: A9jCTCvC2iu7mIh6EBLk6b30y24gMdZv
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4FD1F40018
X-Stat-Signature: 9kzb1mte9kmqpgixu9x395kxez6835tk
X-Rspam-User: 
X-HE-Tag: 1762191036-684418
X-HE-Meta: U2FsdGVkX19lYLgCvYFcDUK+rKjx6dPxxbApENK1Amdv9eJPQINolL15JkUC+MUwNOqvjBBtfcFW/lGOIwdhZhOsb1RlA3/m76g0DQTYimFxrj0RSQpG2Sy/XBxSMVH6L22Ub7L8g2NdYUqh8YXOcNnvpOmRqbDUdWeMvuru94Wfhx+UWXnunUEwZJ7xFGIjWxNE7WcwhkOvd6tJvzEP6roq30ToOB98ZmXkJlUgWGYv5jccYQI2OOCFHggF99INLFW++pZ2l8HERv/ZBNzX43Ib25fn6RwTuBGc3xP6LoaEbJvReZ6ERg1skTu0utraivteBCRU8U0M7+FhPRlzQYC4M+DpdPX9hxtIrSOC21jGMKGN72rl8Q166BPhBgVS7tDM2NAp3raCsJHVvxGJXSDzoWXJw/LZlF0vIEL2inIXgw6CAbDrM+t4wljoX24BkRfFMk2Gh1FoYaHDmCTMW3utPIVm8tPaMC5Po7OF/eJtRFb5NBz1AEB4Equ8jzaOcOys606QRDCh+DdR0hbX4ovrKjMcstCVRULpLxkjz8EUvVIPk1qVXQQjm+chXzybr3mqYxgV5zaRimeWnvfQvdB5gxDtr7prHd488Erl9HFGM9iSDsxL+rkeGzrT0qkYGQDhJ4RJ7MgqUtUk8qsueJVW5oYzHBFAv697CjLa2dQavFzuq79FbfyEetuB1ewTLk/zFel9Qyb8e7X9mCFhwDA2QdMK1CvbTQ2OglIcoufzDm8sam1vYZGvffE19ZQv19FbQc0zcp1i47gvW8+NuVuHExMbp2Vzr9KDQLCik90UKY7S/cghz6xH8KzGRNqEat4oULMr6iTXkpQwsYFlL2K7vcrxguxJqqQB5dnYbEiNUbNInyHQdjgqrmaMFCPrBThtWqthbmtUQAhx0f6nzvINLZ3tTxbfmLMGe0wAxCIArItBe9ZXVofYZj7jOjWslDI8lbHYJdGf6YlAmY+
 E21r9KVU
 zu8goM58t2ri4FqCK6nRt5GHPpv1QmtMcI16q5Nl+GVtFlhVyi+LF5PAayvGZYCFarxso/GTNH1LtFfwipIL87HyiR1xTfRYNr03K7RtzAr6l5jNxshR1my1HiFSFNADpiR75Ajz5UYwBL5pNDU6FI/8sopwZsbYyZLJIBCFVVlvrnfvZ7WuA6WAX66PWa/psez4p/btYy9gJC/vkCuigRXcJMcjYAJ0adTe74HhnEobJzwYQYeSECBB+lP8bmyo3ODxQlSMlYoIIvVzzFHl402cMsg5Yuj6lYm91HzzD+utEXTj3w2yyT4wmY3DlZt0S+ERrZB0dbll4a+T4Nh55saF/wkcqntBsHOzuNaM0xMXnitCzZgcNJHAIbpw2mxNYNoB1l83hsVZpDQSINOfP6CVOYc/B2AgwGFRZLVYcF/cSHk5VWtOxG7jW1hVUgzUxwXUuLLCzqMZEAdo1KuMs8BaoZOfq3fjfpQHDmN4MXZfX1TjN2tNA+SeiyaIN/grxgFSNrLdT2xVfjvP/Hb0copbaabxer5jsAMm40hJ+cVJ6Jr1vDf43GLcCeVeUqkHJc36qwgVc5wFHNHvj7H91Ro0gFx0TpcUKhHoP/gGnRCeseh7gPziNS9npXsXkFmX43ZLlUWtm+AdKN5dhvF2/8SQg47U//znW5CcjWyX7gLAtAfLG4gw7JzAoYAUNqAoeQtK448ur+XbiuvzM2vtr1M3/d1y3lTx2lZ8ZxpPiS4t0MHH0o0rIQtIrJTr1QaNyaxTXurNepfrVdxKKGcGxJIrB0Xk2xnDldHAy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Again header dependencies and configurations strike again, could you apply this
fix-patch to resolve issues with allnoconfig + arches that disable
e.g. CONFIG_SWAP? Thanks! :)

Cheers, Lorenzo

----8<----
From e68fa65fc278cf45a9e32a440eda07e1ca16895c Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Mon, 3 Nov 2025 17:08:07 +0000
Subject: [PATCH] fixpatch

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/leafops.h | 10 ++++++++++
 include/linux/migrate.h |  1 -
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 027209b63472..4af6fb87ac42 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -71,6 +71,7 @@ static inline pte_t leafent_to_pte(leaf_entry_t entry)
 	return swp_entry_to_pte(entry);
 }

+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
 /**
  * leafent_from_pmd() - Obtain a leaf entry from a PMD entry.
  * @pmd: PMD entry.
@@ -97,6 +98,15 @@ static inline leaf_entry_t leafent_from_pmd(pmd_t pmd)
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }

+#else
+
+static inline leaf_entry_t leafent_from_pmd(pmd_t pmd)
+{
+	return leafent_mk_none();
+}
+
+#endif
+
 /**
  * leafent_is_none() - Is the leaf entry empty?
  * @entry: Leaf entry.
diff --git a/include/linux/migrate.h b/include/linux/migrate.h
index 010b70c4dc3e..222cdc6ea792 100644
--- a/include/linux/migrate.h
+++ b/include/linux/migrate.h
@@ -6,7 +6,6 @@
 #include <linux/mempolicy.h>
 #include <linux/migrate_mode.h>
 #include <linux/hugetlb.h>
-#include <linux/leafops.h>

 typedef struct folio *new_folio_t(struct folio *folio, unsigned long private);
 typedef void free_folio_t(struct folio *folio, unsigned long private);
--
2.51.0

