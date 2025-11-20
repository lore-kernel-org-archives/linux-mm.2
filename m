Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79FFFCF64B0
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 04:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5EB96B0011; Wed, 19 Nov 2025 23:00:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0ED16B0026; Wed, 19 Nov 2025 23:00:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAEEB6B0027; Wed, 19 Nov 2025 23:00:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A9A5C6B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:00:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B581BAF99
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:00:10 +0000 (UTC)
X-FDA: 84129632580.23.AF4F300
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012009.outbound.protection.outlook.com [52.101.48.9])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4293A2000C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:00:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c7mObXxK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763611207; a=rsa-sha256;
	cv=pass;
	b=oHKdCQWN839Ylbgyn02lH5YvUNbLiaq29W9lX+NK4imJ8DMSvh4Oqfv12PKLKEgaHqx/eE
	2KvdB5j+iUPXqBwQVlEumYr8XgHpkKjH7EJoxmORRzO/TnjjRVxQ8sJZtVMkGs0Kwcz4fb
	xXMlvlF6LIWWd+B91FWzJDTSGEi9ya8=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=c7mObXxK;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of ziy@nvidia.com designates 52.101.48.9 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763611207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PNXBLiCMHhED8X36qHc1iYGzZ9DzxchckqB8SysLbaY=;
	b=C1YrxPkas9xn7qPYFUTy6AS3clp6Wjh+OaXOUfOFV0qwjaYZW0lbrV6Go9vvdMFqD+YJ7O
	5PqRC6FA0m78kXP9XsDmdjMKzWjW2jj9w63eb5JliWs+51GlETfGHp8iZdntDvVFGeJnNy
	9j+67cfCyYGw/xZccAByJoVOGx8dsRI=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=e9YOKD+C1gH0rvC7ogeSSIb+XSLCQk9YLZi+W+CuB/kf3orZZP6Pr7gz3STiu6SYo+A1O6isbR9d1xu5GrEOuEYvmwjbmevK9UNeySyV8rsJTg2AH+Xmj+pd3R+5m4ueB3TBP1d0ffrecVtArgCq2g0Ynvhmmz9sf0+2V1phCNW5ckZ1z8/vf72JM8NvJM+IlMOVfdW90qKMOZZlMYo7k7ZC+GMFimfwoRrlFXB/utEYEOw92INEdEN5tFiQSbdM3hxfCIPVhchzcBuvSl1PDuIlXdTMcaej6Kwc5137o1KUUP34YnJsyD8uDUShMe4yK7kew2kzjlSu9kJRzM9/wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PNXBLiCMHhED8X36qHc1iYGzZ9DzxchckqB8SysLbaY=;
 b=EbpsBuLbByuib20Sk0ZM7wcdQSMGiNHrHtjfFcNlfLO8XJ8F7mQyPCo1YR8lVP+YOZRJ0NoBIQRozN5ZF4o585aGDTDlbRoOoCx4CRpqTApXRh/DOV6kG/qIu9VG7Qf/9qehNgUc89rrZX8oknva2wspy93+m+oCvjCY9xMh465kc/1kHb3mX5wIPzinHwU1fV87r8Ndk+vJKvwQP8+28xxDAR4uXzV8AlnCT7hfODqPBx90xF4OmHl6Iwtxuq3JgvaEIePcFsyP6ojWtNuHgSGjKveICD2fcHrZeu57JYgbgSaNNu1evRIsSI694X8emYDwtRUVn9bXp2gRXf+ELQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PNXBLiCMHhED8X36qHc1iYGzZ9DzxchckqB8SysLbaY=;
 b=c7mObXxKkdRrQXF2aQIXQSPauqhZHzJdGgQ+UIOjbaH+qnkccsDowj6sig5L3FPF/LYt3SZaCod4X7viUe0r6KKXEWt7SuwPQywHIPYVgqV5LeQk9ZwHPrYZ5hNddoB3BsRr1zP7WWqcwmuSbwoulC0gRiDI/dqmSgF0Uf/8G4468tL+qkVmVlY3AIGKxgxLBFz3W0SQhPRyg7lKnt7PblGDJszfdOQgEUphn/wfdkuaa8eswPsPnT3cjSti902DXyigsz46EcNaIRTmtDqy1pjqe/6kPth274RraySMbbGe+MtEloOs4nNv4JsLlw1gVFrSkLPlNL2H/bnRegM2AQ==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB7914.namprd12.prod.outlook.com (2603:10b6:510:27d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 04:00:02 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%5]) with mapi id 15.20.9343.009; Thu, 20 Nov 2025
 04:00:02 +0000
From: Zi Yan <ziy@nvidia.com>
To: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/3] folio->mapping == NULL check issue
Date: Wed, 19 Nov 2025 22:59:50 -0500
Message-ID: <20251120035953.1115736-1-ziy@nvidia.com>
X-Mailer: git-send-email 2.51.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0095.namprd02.prod.outlook.com
 (2603:10b6:208:51::36) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB7914:EE_
X-MS-Office365-Filtering-Correlation-Id: 11ce5c60-4b76-4fdf-bc73-08de27e94824
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?B1NS6Xdp6AnUCXHIGVSpkTeGUcrsvZ5r5mP3Em9b3/uTWuzT14rHjpiu/UwD?=
 =?us-ascii?Q?RFMNAaIWQJST4bZJNB0EkDfn5QaqNmBw9FdnBVVmqtkmjP6+oM3T3rih7EKC?=
 =?us-ascii?Q?QYiQYlZlfPvNIL/IFC29b+hW9hIPRYNSgACpIGy/eLXu3pZciVtstawWKFvY?=
 =?us-ascii?Q?byn6fFe1fre8F2O6nwe6xc8/SrDowMIF0U0Can7FBKL2zzNksuClhuVVnTvj?=
 =?us-ascii?Q?Tg+S8W2wvgNd/Byc2Z4Jxa5vPiKCSPGQ0fkEQbJvXyAn+8XBSEqScz4LN4R1?=
 =?us-ascii?Q?bxROUXWwOhqJUPrx0n/1fPaWgxPqlsXQJuOpHweanP/SaJQd1VCJKZg3NwE/?=
 =?us-ascii?Q?JphLOb5QhnloLO65Vlmr8nTl5rPvRZhNxOyAgXF9uscRxrIc8ObpwGjMvjNJ?=
 =?us-ascii?Q?4pEmJS1vrbPrtTJ+i1kmEIZn2kTT4FqqATs3Gqcd6Xaqw2BtCpwMHhCKWRwc?=
 =?us-ascii?Q?zNVUn1CtbK92W/Zqf9the0UnB4IHEf3KFNCWYS6NS35QCAqPZIxavGi/hXel?=
 =?us-ascii?Q?ZAPrCerakNY9u9oqsdI3Pn5V6u9nJAXF4leLTebPQUx0y3sIDMHtVqRnU22X?=
 =?us-ascii?Q?83iby+uqzC2VxEvsTbX6/OZIV+G3eZpX4WQfx5wOm6UhCCMEQuzjfMnXJTQ0?=
 =?us-ascii?Q?VopgiXnAFBRZbXNL2fIzVF32MJTFiocjAS6k48WR6CDQ6Jr2J/ZHm25DUfwm?=
 =?us-ascii?Q?WIwjzcqiWoLQbI8L3oimepxHKItjb3mMPOteNbVb+HUXFQuy74igb0AuwqLP?=
 =?us-ascii?Q?7+rZRsYQFCGgxBZCObWAgxGxMdby0DCP+kiAYxFbyenYoZSFPs0/HI5D3N5C?=
 =?us-ascii?Q?ODWgmK14rFj/Hs8cLnzTvXKF7Wlrx41oeHx7+fXlw7CBC8do9G73Z0a/yE0j?=
 =?us-ascii?Q?KyPKxaKT9L6E1oVOruJ9jQlQ9vG5PkHhKPNpZULXsbMzaGIgddoc3t6CNNaD?=
 =?us-ascii?Q?Mlmoo/N+Qd3vUmCr+372wTHwGFQLJV9Zbkx6BE1fh/BoG7pbMyU4MvJBobgA?=
 =?us-ascii?Q?5IZ1NQYaw0oq/Kd9Y+Yh6B50ZoEbwaSDCzu3zG5xUeFsblEzaZOtEQgUfddN?=
 =?us-ascii?Q?acaBYXtU0ktzvb96OL7wfvym/67wJpQdDlv6c2Z9Rqm/dyfSPyk0ds5fpeZ1?=
 =?us-ascii?Q?SFk8uyFH2+jvh4vT648t+xlvkPssyd6jvaZ14x6+Ptt1HvBwlj+E/LXxMres?=
 =?us-ascii?Q?tIi9fsGA3w2QyzYjZQJRqPmlUSuDgiDa9Z+Pk0HMLQ+xDdKEFTWfzC7C/+a6?=
 =?us-ascii?Q?BM8O941hisayDgKeCpSkkd73uZFy5Xt8BIBx6Oe+WY6Hb0BRMjN0cHFL4y3Q?=
 =?us-ascii?Q?1opipZSOKzRzwEOAKdw3VSSskdsEmca5Y+JF+6ne+cBnEHJmR3CA7SsXm/oS?=
 =?us-ascii?Q?7ov6SL/sQGokvPXV6nI8cQ/zLH19TD+5Htu04/9XDIOpfR6V8MJmSMJuTko2?=
 =?us-ascii?Q?BnweEPs2F2UVBR07TEQEr81oyCE+kPfDqe323hAkX187GmUduf9h/A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?G8Glrlpz5lLV9zts1dUc/i6cKIog7AsSn9LKxO97NnF0RoAig6j2evhScsFY?=
 =?us-ascii?Q?0c27Q8TnuBX9bmCENzYm774uCV7BYJFl1kjD4c4QBVzFtpLEx/b0YBmvHMsi?=
 =?us-ascii?Q?0sHd9WJT1x5vWnSQS0anegSS4pi8Mi27Way5lL1S0p38thTN82rKEsLMgubG?=
 =?us-ascii?Q?oUIFqOkDq4RUSJ7MfLYW65nDJe4UANoE56JO4d1ZaBBSOBfSsu4cdHEcI8VO?=
 =?us-ascii?Q?9lPJ/BfzqSvqBbJZzfVZf+FICViBKuY2sWPMpORUiEh68R8VeFcS/Pnbva/z?=
 =?us-ascii?Q?Pap26nn4tk0UE5RN/gz/FbdBhEkUz/4/Q/ksnj4Z2D137OYyGixhlp6Tq3OY?=
 =?us-ascii?Q?ZprWfjNG5BYa48Es1TyZMGhR1MJo7/fpmhiG4DquJNhZDqnf4aPPM1YI0pqI?=
 =?us-ascii?Q?P8ZdhQJzxAFJ+2jm0e8SPPdu/0JCPqccmVGwn8dcsP4qDB3fe0SkWKqcm2VJ?=
 =?us-ascii?Q?pwFUdOBRSzK3S3M1RK2jQ+ytRyvpVI0cXmuqXfW/o1TgzrRKsUqfvDsclcO9?=
 =?us-ascii?Q?FkkdqGbcLh20OKgU0vLZCd7CzsOAgssZzzvQT6iBv+eVB/1Le8cq8YfxZQe1?=
 =?us-ascii?Q?UtPhQRTyrLSD68YqIlKIgKikKbZ4UiehXfJXnsG2+bhpiRFPQIScmtgHDdIo?=
 =?us-ascii?Q?1JpeIsWnqhM+NeAoMBKYuvbOybGKkb+5kHQ7mBethHwn5r28+jzm0tnibYLt?=
 =?us-ascii?Q?KKOlYI0UtLgS6DmA60n4aDuIJCxmz01XVPeU+bHsy6oVO41o4vOZChm9eQ6F?=
 =?us-ascii?Q?DE0tFKvB0/yk7LeaIYBjNc5nMKJqPnvkFEmgeh8XnnSMDC32ExyiO44K2vhN?=
 =?us-ascii?Q?oqeURu1SA9YEFJegnaiwxFB/esIYjgJ/wCP/rxFRMW8/XkxGX/pXaLNNrlHi?=
 =?us-ascii?Q?C9t1iPPsHRX3CwLM56R9RzcrlrJ4NThhurseqKp1XqQghBcZJGSASXHnHey3?=
 =?us-ascii?Q?Ktac97fMQhX7cilSzGlRP7ecpHNos45+vOLkanFJJfikXVTIKk20FmdXF4/I?=
 =?us-ascii?Q?idZ79zsDlTsVldEoo6JyugUgjUre9qoB0Hlr7foe2nZlGhBCJEJ8uCY8lJgL?=
 =?us-ascii?Q?upA7nBpw4R7kO0W5ZWMmVP6hjydjv4sEnbXRgYBFRdv0SvzByhyjDUM0cZTs?=
 =?us-ascii?Q?F3NlIG+mtCIRi8k6dVP/dm5U2+KjB9FeEKzUFVr/ybHxtKjnd/s+IM+uBuJg?=
 =?us-ascii?Q?S+HE+NJECvge0fha6UaPaes+fhjWjHRQ3CL9wKpGfgCtnuUZDJUPXAXk3zqn?=
 =?us-ascii?Q?FccrxxbYVATQx8BhN1Ukyp2WgvC1umpgmmvORU2lfnBcvR1u5c8PmnyDSZae?=
 =?us-ascii?Q?0WqmhJC4hhaPWuFyDXJcFdNRyZl8ynwwnKA8TsYkok9sumg2/vWWUT3bdqAf?=
 =?us-ascii?Q?OooCcUSomzkmAL2CN6PKsHwPLcMJsYzYGDA/i1V420Jl+ADODpt2ZxDStXj9?=
 =?us-ascii?Q?mZzg9IG5ZUy26tqD1gNd7KRIBIWEbXdhbG/OXBA4eJhFlPgosnEi7IuLDAvj?=
 =?us-ascii?Q?0vF5d6U+jrqcdvjwl5/nz/tQwMu5tFy234jyhbl56ZPdxu5kC9REDiEIXsoC?=
 =?us-ascii?Q?PYBuT/8QTYjBNKTr9DwcCB+7ZLenZx9quzR7CIg5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 11ce5c60-4b76-4fdf-bc73-08de27e94824
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 04:00:02.5616
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E92nhDlbtRp0nUkGB1Uc0yheEXhbS4V/PkZ1B5yqQhfc6oTAkeWBtCVNqq0IeFO1
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7914
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4293A2000C
X-Stat-Signature: 77xi1rk5gr1zpxe7arsipciisgapkbrq
X-HE-Tag: 1763611207-853814
X-HE-Meta: U2FsdGVkX1+PeuUdgjZxFWAzrD2+zBdbXVADkzvEqDVzy6btXCzRbfjmR55QWWz0MNqI5kL3OJFDSvO2lXpgYYrr4B5xPl7EYDs1e9FgSLSNsfYJYCchUbyPc5n8bT1KtzzN01/maqyTYo7DHESJ23RIirJzVOhxE1688gXIw7bCq8CJqeJp1gi7LSeBmKi2j6dHw/cNSIFKTVP0NN/EyLKIPFvHWIYOxdNJ4JbqYMOAYSpQezxXBAysVnG3vzwChZMXMdX0n/ybeZ4CZv4MBMmNsICTSYlkOrk1ifJgJisKqibqlXvEgBJcNxe4ZS2Sj3q+XOS/hATTb0qeG3OseqU+XfnQzzHKySNEH0BvfI7VvCj4E4sesNAkS9an2IQZDH8RI037p9KbU3hTZDWOtDJrhJAoh3rZip6SR9OqHIJqXy46FqHXA/I56qFoSMggaQ2Karg6rbLTYRSoktnzI+q4FzPrqxc0g0d4CNK1YAGxJ1MBlljGV5JnPnjla9WwkMzJcURiGvESuu4TXmMJeVUh3wtCaBr5tk+2TrTasAhPdmmKD8t7Vlf7fWokhDd7ZyIZo8ghdFJCZMrv7Z/ihRZwJm5U4DVppglFBqWSXtzWS4wP5OSKOdcevxKyF9HpMtojYcylkSparRAIHcSoeJhDICFGPs9OFpoFXIGjuJ6sjQ1+WQcpMuB0vreNK80/bSXjbSYAHIPsUVfbj5zMjrhBs6CZDRP1SniPaDkzoYPGVT7RLRtzZaz/NaOwjPxAGgmCY4KKacrIlCqGcjGrKtTNzGcC+/STBUSCO+Rd8lWADTxCjVmCG8XDye3E4Z4s1KmaPfQs4rEe23VYpNn9FsJYRnQuMWz74MBvOeHpjPDhllckOk1wxbE8v8RtFST7Lno7XFZk0sNrDBvWpdy8sZG8wxzYvJDALeNAljubiytziZaI7cTR5DKKJvl/If6XMThzloB1qGPNFbikJZD
 V8JyIJ+4
 RvCIxSRVo4WCdCznyN/oURo/523GhzE7QWYbA6SdLdHZEy8kLqrUXCnKSbOgsjZSjGSkQoy2eTc4aFODdXmRyGrEffylRubhxQIt/e/8xsVryQ4S1Cl6HhOsqj6U8xF00Tdwk6ERz+uOlqG11Y4Rn9K+uFJ37/DBP61eXD7qjitb0ijXrU+gDZ0HjtbbaGsx6Zy9PfdYUB10X9Hc0sWK5U+W5THS+XDJGlEE5qpJZcXqcTmbEGZ0kRJQLj5U6wMeBHulkKEZj3tj5JVYLChb5MyZJaP4vekYvDooRMjfqOVg3peZ112vkuEHjSUoCVvp664q1lnjxc3e7t2Q9bGEWjEk5qYk64qSupDeRHpuiEDhbmut8B7FtERF/pD3G0D2bpY5ivRQkXrjG+1bswuIUtvHjXs50lEROOv94y7nCwbifWLaEghfbejKlsr7ouRTXqcDQ2u1F5EJO3y4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

Based on Wei's observation[1], this patchset is trying to solve several
potential issues:
1. Patch 1, 2: dereferencing NULL folio->mapping in
   try_folio_split_to_order() for future users,
2. Patch 3: improper handling of negative return value of
   min_order_for_split() in mm/memory-failure.c

No bug is present for the existing code.

For 1, try_folio_split_to_order() is used in
truncate_inode_partial_folio() and it is fine since folio->mapping is
always not NULL there.

For 2, mm/memory-failure.c code does not check for -EBUSY return value of
min_order_for_split() and directly passes it to a folio split function.
The code works by accident but needs to be fixed.

folio_split_supported() does not check if folio->mapping is NULL, but
can dereference it in some cases. My current fix is adding a kernel-doc
to clarify this requirement. An alternative is to add folio->mapping
check and return -EBUSY and return -EINVAL for the other checks. But
folio_split_supported() will no longer checks for "supported",
folio_split_can_split() might be a better name. Then, the existing
can_split_folio() might better be renamed to
folio_split_refcount_check(). In addition, try_folio_split_to_order(),
which calls folio_split_supported(), might want to handle -EBUSY separately
to avoid calling split_huge_page_to_order() when the folio is truncated
for a known -EBUSY error.

Let me know your thoughts. Thanks.

Link: https://lore.kernel.org/all/20251120004735.52z7r4xmogw7mbsj@master/ [1]

Zi Yan (3):
  mm/huge_memory: prevent NULL pointer dereference in
    try_folio_split_to_order()
  mm/huge_memory: add kernel-doc for folio_split_supported()
  mm/memory-failure: handle min_order_for_split() error code properly

 include/linux/huge_mm.h |  7 +++++++
 mm/huge_memory.c        | 17 +++++++++++++++++
 mm/memory-failure.c     |  8 ++++++--
 3 files changed, 30 insertions(+), 2 deletions(-)

-- 
2.51.0


