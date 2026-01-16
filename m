Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1FC6D47CD1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 10:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4960C6B0089; Fri, 16 Jan 2026 05:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43FFA6B008A; Fri, 16 Jan 2026 05:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3188F6B008C; Fri, 16 Jan 2026 05:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F1886B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 05:34:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C14A513B496
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:34:04 +0000 (UTC)
X-FDA: 84337466808.04.97EAA9E
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id 491E2C0008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:34:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lGuoIxOh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="vKgOS/ag";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768559641; a=rsa-sha256;
	cv=pass;
	b=vfbtwyK0WzfjFDAzIMlvb+x4LWOUtvzyHVljnWBd+VAHGn0o8wh5g21Ea+4yK5FyG1SC99
	jCqS03nEEt8UGqxtPBAVVnLDWRsCJECLLRNjS+C4ozuRuQuDN4lo2ChbBrTp6lHNJRJaPh
	wqIf2hGTDuYkA6uy3eRLaQdM0zYq/7A=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=lGuoIxOh;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="vKgOS/ag";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf10.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768559641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6lzeCGbe9kQuIav6c+lxN6A5Wyl0cGORGJEY61Rt15A=;
	b=MpaF7TcqUS9DOjMErgEcYu1+mvZ06hNGITDYus8tgU3REN11T0WeaNFS/M//kasoQVLcEv
	5NztECvmlEFb5b5FtZdRJ4CQLHb4nke2T7H4kwDOydrJ7jDUnkuWWjFLXNrh7xlg7LvTP+
	Jic5EHvrwfSDT9rEt1Ty7/dU2E8fPeU=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60FNNneS1430848;
	Fri, 16 Jan 2026 10:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6lzeCGbe9kQuIav6c+
	lxN6A5Wyl0cGORGJEY61Rt15A=; b=lGuoIxOh2QthBb0lBNanPH/SRn1x9RGqnP
	C9maF6oUxf6fA+jxd8lJEcVSydJpQ4YNuMPumn8q9IhALfWZJddyS8MDBO6M96tH
	hEl1ieccvaXsZdJVjqyZv5aBDqFm2LXz2rVAlZlS/rKV8KrtNASl/+S91LvqsBTM
	cn2STxUhUTJfcW2F43/RWvGCPb+beWOZuaJnlbOIL9cR4xpYNn1jP9m4wNpbwVBA
	hEaD9k8HoSq29HRZGQ2ZhWLMnxkIvnkVqULIcM7cYw7aeLbBvS3Lqs6RzkPrcgBC
	FyW0eX8wi/wDTIjQyW3OYZhwdF4gvI4uk/Ca4ILmIwvIc9GmIXvA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkre41spf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:33:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60G9eQ2M031014;
	Fri, 16 Jan 2026 10:33:55 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012052.outbound.protection.outlook.com [40.107.209.52])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd7phabv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Jan 2026 10:33:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eRh0Ql9++TcjSjFeAt+pfAyY8E4+Omcagg/K6ssrh3w1/sgA4k3mkmKZolneMXONB/3PVFyfqUhcModwUdJjKJDxOKrOhI8EwdGGh92FVa0EqPCU6I5Zl/fWsXR5V+zJ0a3HYt8XUVlXo8MpEGCXNDrrOsWeryvtqc9sBqg7Fx8ZTskkQomudt0FqAnyhwYj7owCOr37BQfdJ05JKKb8vWJsmZM2Q+MW5ImAwwFuU/bliQPWinQ7q7FaiisaeAbNHDzbSjRALnE8p2mALj87dqv6xdZKYOBz81yP1Qq3N2Lh2N9nlTchyU7mgpRS2Xstcxgv01yd2D0w9FJoU3G54g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6lzeCGbe9kQuIav6c+lxN6A5Wyl0cGORGJEY61Rt15A=;
 b=YYU8tlwnONCl6LLVKCeo5da6VQVsNqK8QaVHteGOpFryrM76KgYml8Iy5E+XuVt7xizP2Ru2BKC6k37D8YU3xiy+e4LmEKn64hme3oIAVUbPFh22lyDP504bIKDXIydRpcdjSdTmYOeI8Y18MuQmHJ3Taunai79Sjt/zo2KkanBnkVWUQooabCMLFp7IvWHEnKKBuAuKNgcy7hOaRRX7k2saJypXvqtlZH2Q+zFipUheCd8AZdss+iCxBEMuhQEQhy+4zqp0mhBayCpgPmerpd5z9cySh2LEBA9GmoRpyzOfEwj8J2WgWnmR69AkfIQfO3ETB359hKcdftFKsB7Jjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6lzeCGbe9kQuIav6c+lxN6A5Wyl0cGORGJEY61Rt15A=;
 b=vKgOS/agNAT297IeTookFex0nR/EKsbsrF6V02FaYxOPyEKETV66yq5KajATLn4tPgMaJwZdDrhfnNLruUbhBo6HR8cbOWxfMq418YBTJkaJS8IhVNnw17yYT376c6ksb7yBeHgbRoddwykx61LOl9YGy4vrMJ/Rn6bdF3lHcjg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA6PR10MB8136.namprd10.prod.outlook.com (2603:10b6:806:438::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.5; Fri, 16 Jan
 2026 10:33:52 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 16 Jan 2026
 10:33:52 +0000
Date: Fri, 16 Jan 2026 10:33:52 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: add + use vma_is_stabilised(),
 vma_assert_stabilised() helpers
Message-ID: <d01a776d-3bcd-43cb-8fc9-b94b5c3d2fa9@lucifer.local>
References: <cover.1768558900.git.lorenzo.stoakes@oracle.com>
 <0ad01ca9836e803bbf487716d2d750aed56c008f.1768558900.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ad01ca9836e803bbf487716d2d750aed56c008f.1768558900.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P123CA0176.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:18a::19) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA6PR10MB8136:EE_
X-MS-Office365-Filtering-Correlation-Id: 462443b1-f386-4369-cb35-08de54eabe18
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lqbhcNTfgCR/Oluj3ZjIriYXvH54/dpXvXyaSpD/WwLGbnfhW0dSG7DNngo1?=
 =?us-ascii?Q?eO0rgHH7uCDkbIXqGpNk9MuSLLDP/DXn5dlNWTGNyEVuOtGNHVyLgaMHXaKE?=
 =?us-ascii?Q?W/WO47xNEt18YffYpbny3cXn9EcB/gjLnjD5pOFewtSSjYwtxRDlJAI3ViJp?=
 =?us-ascii?Q?vEmObcsWIJMuedLP13Whs69rrC/rhMIKeopZz9HVvngojnBPNTmt/z9r6kie?=
 =?us-ascii?Q?0n9AxWMwxzhc+EK5xAZEpiUe8XGhgUS3+2PFpwM+995eq7iJtyP4SJWLgLh+?=
 =?us-ascii?Q?nMYY/49jDSeVsMVPq1arWFXlR5O3yPSK2O0GkHf3HYXvFRWe5o67ppCcWJLH?=
 =?us-ascii?Q?NIqeAw8Ji0he/h/M4gBI0PQezknMFyXSheTp+9bOEJdEbDoJKcuv2brBRKaF?=
 =?us-ascii?Q?PlDDaGRjrhMrgMwyzIDm7KXHszkkfbP7O/sq3rYTqIai6B9OfsFIBSdTxnKL?=
 =?us-ascii?Q?RnJ8IXohegpNIKIpTcZBlrNdKK81MnowsV/tW9u9bamLoyWF7fDdl800s+B6?=
 =?us-ascii?Q?ymfGLGYFMZTcDfxrVoYt0hbQFEIgA7kknR2VFa0WEAqDcQnjKELJjrqeAwJX?=
 =?us-ascii?Q?Lr4ebQI4+A2AB8ceoix/6/svAi3CeNI3H/Cv8Oz/YFPM0/k/xfMVdTZlPLkL?=
 =?us-ascii?Q?I6UOkdgYoWv7cDmmjmgLcyR9vXYfTy4Dra1YSVqtDZPSgSEQiaJorObn3S+/?=
 =?us-ascii?Q?EAZy15uBvE6+Lp904Mss/poKL6DN/Oq9Cl2xUU8EOneUoysbxEg/z60v2DQQ?=
 =?us-ascii?Q?7Hu2SUuWnHWw8NFpYsxq4pDjXmzb3BBgF063JqUHVDkygj+u8u06HVw3c5IC?=
 =?us-ascii?Q?hsMpel62Ok3e79WlroKdEtV5gle5gdrSptb4Z9GIPgWvPt91DTOvObf5I4Ke?=
 =?us-ascii?Q?H0JSnv9P5tNrx+7kcm3+x4BLUMRuVzsTl5LJjSM9ekPHCSUoDZTi/pXsKafi?=
 =?us-ascii?Q?xR1HkrMSwVQkdwkdi03tXmSccwu8c6YHz8IO+TD2BCUCOTgy5Lfa0KzThOfe?=
 =?us-ascii?Q?+WHAuOdAxVlEXkNJuVRfZDE6jzkAGAllP3kUJFAtDAwvQQ9kw8/KVcUdB5Lq?=
 =?us-ascii?Q?c7ZylbgmmjNx947OIECaQwfE/zQKu+ue/f4I+1nd4kHLDvyKayNJNj8l3q1f?=
 =?us-ascii?Q?mGCHe9Mz9pMhpw3+neNdH7VCtnQPVBIAZPuKVbd2QG32ryqF//CTJriGV24j?=
 =?us-ascii?Q?dzDBNlfgFtXkpIJ0hcYB+VZJlPiZJUaxgWflu7hwUDcY7TYAdFopnZmyZloO?=
 =?us-ascii?Q?SmdvCM/+qfUb9PyEzHkByoeZvqhmFIQ6sUy/XkPV5mSh9wdhXzOwzrtQ0xER?=
 =?us-ascii?Q?S+xopN77aIttYDapKVqjNBUm/pBzQqbF83sNswSZMH7uI2bBwvCoiqG24liS?=
 =?us-ascii?Q?tTB03FaOkYiiDvHELsQXYEuQpBTodIZQEDLbmrzlNPrdTSh+LUgZP4LayOIC?=
 =?us-ascii?Q?ZSDe9UN/AJI9HHmpmZ8+MhSO+JL89nFGLLxqKwpwzAUyfkbLZdgyfZW9H/Oj?=
 =?us-ascii?Q?2yQmQ4LPLgAdYNmhc7J0JCtGmiUI6aEblsn5x8TAJQMhWJ7sJ4mPqx4U9dc3?=
 =?us-ascii?Q?xEjGtcwKAx5GFHWzJug=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?AcIWjr2xkXeCSmyCArDB8UJHFGOO+ZsKEI5v4kz8S8+FxvGTvlbCYkuLUbwp?=
 =?us-ascii?Q?gxZX4fPVPwEyDx7wgx2KMMhNHjuhg6MremecfWLSRNEf4UsdcaMc+S8XRSyD?=
 =?us-ascii?Q?1EU3jiJ+hZAkrStZoxgHAKGKpFPK9kfGq0DBeiK5Wzh+bM8hpZjT8R9r33Qf?=
 =?us-ascii?Q?nlCsSCcvPm2I0bLSv3jeSfcb2OrMuYtR65TgqKUlrzoH5V2uVbGtR2QI0yfa?=
 =?us-ascii?Q?RvL1S4IT+L/0h/mV2gabIh1ud4ivVnsbMFXSE2Hidba8cPCI4B/TqQxW5KJl?=
 =?us-ascii?Q?yKky9fSuuFOV0N9dY1z/C/gqeH8AQZDwAcy8IwD8/7pVKGVq01RAXLsPUGYe?=
 =?us-ascii?Q?b76LoMyB5sSjkkDHJuJHwRp6J+WwSGo9lHBylbGAMN8mK2MES7fCIY1qZc7U?=
 =?us-ascii?Q?T8o3kx+881H3YW9X5D057SALz6oAK7r+ErZnUGw73ULI/VI63cTB7/m3uvIL?=
 =?us-ascii?Q?bUjNmhRe0S4NxHwnT1tAPxYtUIPJMo7RdCxLj0bexpZ4aE2uvFqyRLJjkb5p?=
 =?us-ascii?Q?cZi0MfXAlHehg1vCdXg2QkLA2vCsVAqlfdQs3k6o/RolfTpwZ3TamnqqCbru?=
 =?us-ascii?Q?cD1DZFSV7gLvsIMS6h93hImyoMmNVNmqmx4QTPMTIf+ErgYDWMuhaWZ7bGxl?=
 =?us-ascii?Q?P1UZVjrUDGGZE7tod/o/nttz6w5C00wVDZdxOHv7lBr+FeBJSDSN6vaKFKIg?=
 =?us-ascii?Q?TOzj0kC0dYsYKSL7MXOJKpkulaQazomKJxC7RU/RTQvdefyfof+57FD81jcb?=
 =?us-ascii?Q?fv3J6JMlI2lL5d3B4iN6gqHQCNp8RPUe2cjnsstvPM0M9yQPRsevHIwqsalC?=
 =?us-ascii?Q?GminjhMQRrfm32qyH+dML4OzySZjePGlKFlpEccNfuWfx6nL6EWq0qBd4bPl?=
 =?us-ascii?Q?ycgv6k2hf6IJHzGidnuQGPdDCKP5zQ1qT2MmdlMx4777drNJY4WRlmU7lyTu?=
 =?us-ascii?Q?T2z+aOJ4HPtR3pGLtDsjpzd0ts5Z0VRRUYu/uWUqgGvkHPSGYN9NDU4Ze3b7?=
 =?us-ascii?Q?Ttat/azUD5GZ0z1A/LSJZUTvHFltVZXtbW6qFtLUX66HesvGXsxTkF11+98M?=
 =?us-ascii?Q?u0qeMMYbMVpvkwaeds11raEYwLSsouiXxPi/wjfedvX0263GjWJs1JlAviWI?=
 =?us-ascii?Q?oYqeDpHovWF8YdCus/12uCANrrg9NyEvYymT93/oSCHbbNqFRWTCr2D6WMKh?=
 =?us-ascii?Q?FXRUQe/5MTKi+Rqcse175z8goiiD/cD5yfOGg+y6zi9vjceGbSf+av6dHBZl?=
 =?us-ascii?Q?F85ll5b0yDuKa5YsPc9CqKXPWp06Ju7pqVUudk3NME2gF7pO6Tp2aBeQ0Yw1?=
 =?us-ascii?Q?6U2JmA8OMNXvpy76tMf+DoE2u2gQ/1aAJp5Yu6ESscWEOyaVQP2WGMceusTy?=
 =?us-ascii?Q?u6GUKGDlSTCrAMWNUbXUjjdm80+7T6vCpxCi204tNOBIft7cBf7EDkv3ADqw?=
 =?us-ascii?Q?WbxH3YJ1IJUduyaAS+fwRclSAGYTmJpSD+vmB9G43FZ2/v0ck6UFYpJ24lyL?=
 =?us-ascii?Q?tZiLRFgNKQ7hZNKAFXtW33UkqFkeQDT7dOBZEp/qbzyxEu3vxFeUD7q3Piku?=
 =?us-ascii?Q?a87poTyRJDM00meo//nfz+MYG33ADAt/E1xUKh/7qCpjNOxLchH9ZeZarPVL?=
 =?us-ascii?Q?3bhWO0kQxkE+icqfIc2QQGmGLccBrHse5GPrHlgE5bOYDU446xWNT5iClYdS?=
 =?us-ascii?Q?JpkSZRHwTd667Fhz7KxiqbJRvK//8AwZB3P26Nz4UD0wfjsYfgMvfqQp4kBH?=
 =?us-ascii?Q?F4WxnTixtlgv816/ig1lnrtuo2uMiLU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	IbkA7uqwTX2As/I9gaXy0flx5DJoEpoRRr/tMVvhY4HMbdFdD8mxDoIz5G4kDuUVq3WYbX6gU2fU16WSBft2IkjwDiCI5qOvNQAnWj1JwXkf6LKKv9xOwBeS6D7Cg2kh0NpXhtB9YXloK44aJFZmBrffJZzSmXZsEiCrRrwmqoATv71PGyQE9qfmGUgJ6yOboRhRIXvtB8xoL5xcorL/utCA5Bo0z1w22RW6YfBPZAcMQXF0HQ5CKDPsMoZ6mL8sHxwrBPWaygFfjFygQzHIsuW+BQTr3NnPErldgbphBykqPo2CKSNMRK+ln4gUdNeOqdxjElzJEYiCCOiRjll5nXnEeecLJ1TsGCHt4+UDN4pQPPsbkdSWX/X419h7kEvzFvAo06MVDxh9tsc11ICls84qGfNHzKFz74ojvt1N1L5DHXp7ipLiIHmIwkrN8WsPBscPat4fLRjLSoMqlS58TBuy2WU1zt0cuOJD06oNPuWmzUVeBdi3fdXZ/rmkImfwXmYHojxSw8HIbQS8smY9oV3qcKD0LAqMCcBGMK9XNOR2vQhZav6KqosbEnPrJrJdEzJEOtUJsq6E2MeF8gOexkFZL/XriOeJFIYfhUZzz70=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462443b1-f386-4369-cb35-08de54eabe18
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2026 10:33:52.2349
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2pv+8gSgckna9GrIAerJVtNlir3Mnnd0SnQZ2MhkAfua9aIbzHXEba7s02aqQs1RBKGimrXruEEUJwdtiCC9VOZ3YNbH+zn1NTYg9GceZXM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8136
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-16_03,2026-01-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601160079
X-Proofpoint-ORIG-GUID: AsM0X9DL_hVmmmDDWz8q9Vmq51EAt9bZ
X-Authority-Analysis: v=2.4 cv=YKOSCBGx c=1 sm=1 tr=0 ts=696a1414 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=OVbOOJrrQZoyHe8WjAoA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12109
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE2MDA3OCBTYWx0ZWRfXzQSlkzvf0nej
 TYaK/7Zi5AMx74hGC6nGFbDz3JqaqSwJFs1nAtoZRKnWTYxiWmfsEw4NCmQZR/sfDdr5svJJxHn
 cRfg9edHZcqnEwJeez8X5eEOR6JXZUpDAxcevZH2FxMncJD0wYpQfdSNb315d6n3Y+lHAJaKOg4
 85xq9yOCaIpxvrLZL6ara0hvcd8s4lamPo+6gZSytrgib7nABOXoynXLCTYTxss5M8RnV5DSLda
 e0FLvzwlo35F+6UTru8Kg9Gf/q8ZkqRT9TyQZgC8H47mlapGmxjXSEfgbqyz8TNBajPl9WsPlOu
 5SQaWpa9J88vef3oRhcFAQU4H0mV2x/9f/CLPUvx/xEBnB26yIKPsEZB2WS/GrKcREGjhvrhPfv
 19N1OJXCRJ0CxdbxfTloKEKEHxCH0fLOqSL5hXbOeMSQBcO3zzZ3UnH5hWHjvcf+ICJHHUYSyvf
 YrCndNwEQunBus29+5thLmPh9Y2+Ma0jv1dN4NAc=
X-Proofpoint-GUID: AsM0X9DL_hVmmmDDWz8q9Vmq51EAt9bZ
X-Stat-Signature: fqtcrrhnzdiafa8d95mw6weg4gagryxa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 491E2C0008
X-Rspam-User: 
X-HE-Tag: 1768559641-530355
X-HE-Meta: U2FsdGVkX18Qkcy76i9EkFHO2Tr2U6dka+BUoX9AsTQgm3r6zY9pnIupis7tvH4RoZQ4EwEcZnT/V/M+GxbhkeJwdyUjPzm1BJs9vSFZaXyLnINGq6Zrkg8qkecJD5+sLb70Z8Ii9AR+mOIEUCgFa2phJAW9bVGs5KRyNwq9I6YL1fs/QQ3x+H/0lm8SbcCXByyWDAPvwamUXfZCO1uMkaOhUb5GIq5iOEHVphc9KJGGpP0STIrzLhLpBMmdgcR9xv2TDNkTHlbVyqmpd/+fiXIw4+M6IK32V9fRDiCQr6OwuvcjQjBy4T3mxBrRcw6TuN2xTaGvMo1oaNXN9D0r34+eNrKjyp3e4qoNEb+f9YXmnkealGjqTv0impOyBH9CDsGIKwpqvawDXR56/9NsFhSzeZ3imW4lBUaXM7ILxq1HiVXj5lbXhKQ5fF4M81lajeDCyRK2EsgNHj9vmbnMCkzeilvF5JU3Mj4Q+WjYSCbifjOreTjyq6xHINa1K82nXh0WCBxlK8MiDz5tGYGLK/Stzz6z37MnD/WUmBr68eq/8T9k6mVUODaAa5PFuaVKdt1wpFVkE6iZk0wZQGM+hnBiZXGxBGPqPNbWFwEjmm2hrHZ8gcLQ9x89Rbm577m/BSnTTsy00VSQ0FdxYoomS4ObHkT+LehPDSJN9OZUd/aiMYRzIhsrVFDtyWkFV5mGdN+H26R73GBbjvXe/v+NEKI9FehgqsGa7EBTJbq1w1WaZfyP5+Ck5GRn/diHH1MFvVD9/57CsvE3qzapRhxmbeVNpGaYhiZEBhks8PuBr9LySsIIFzP3nhF4TKmW72kKOvrMrTCBzllmMJP0B8ojwJAVddFDFaqkn0wlt5EoJ9ERXBcYiQGi21CI/YCxnV4KdTUdZX7tqyiXW9FBpBtWN+HiHA531NxzmXtfMS5Q90Iq3lm4PZzRNobhj/4QavEfqNff618BbbudUUmlDUv
 bGI354GN
 dyfZ8HffvK3qM7zvPvJvBTP6l+rzbOrKTSyQ8pEWRWdeVxWn4svKOp/ljct/Kr0gV5zsfxOxC5HvTfV7dbK5toSXFReakUWNvm0DeyLBNqJmio35Sr1Tu2yk8STXMf3tbSyiXUV3/7MkWR/PL4CaIbT5lQPON1iZjMXSWriGjx+5pj5vMoLR0CRfTo7XSE6RkeCZV/kwGolI1nqY7UEQap2yfFPXCFsNGDNFAvpNodbpsYnEIPT9uuw7nkTXGZuMFvyuQwyrK+7aG6VCVDQGlIzHGGt18sqwEY7TZNoJldD+Z9+gg8i1EiHgZ/29DnoKkuRZfBJmPlEcE9rX5NPRzA7OsjPkbiQChSS2SaNpKOdqZoM4DMQDezAimFA6Z79cF/t7McKuqWBu3MmymWYWj58zMxOzPsuDjSvCzBnyjFJfsgLmOOHPGegBStUpaMRsHmmAz7pyVLjNZfZJ7efcMwSac8+auEWAcqGxZui/CEcyCKInN8MIAJhDPojpG1oXSO252xufqWmRXK5nzV/GT7X2nS9A+CZjFZIb3TZELZ7CD4RU6z+3GUus+gABJRBHEOu5NiZAh5tDZeguFib+oJaKww5iyfLa/B3z6GIAhKzuzQpGqpiGwSPEmh4+zy6YdegVFydx0UzMkSauKVcWN/AIGE7aGdEwCGDDRpyOlgrmz1omz+7AplNdp3oveofEjUEUHJEUGvq63S0B6wY+MZZNZAB6r1vIJiPC1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 10:27:48AM +0000, Lorenzo Stoakes wrote:
[snip]
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index cd51e0a43c76..d87a07608295 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
[snip]
> +/**
> + * vma_assert_stabilised() - assert that this VMA cannot be changed from
> + * underneath us either by having a VMA or mmap lock held.
> + * @vma: The VMA whose stability we wish to assess.
> + *
> + * Note that this will only trigger an assert if CONFIG_DEBUG_VM is set.
> + */
> +static inline void vma_assert_stabilised(struct vm_area_struct *vma)
>  {
> -	return rwsem_is_contended(&mm->mmap_lock);
> +	VM_BUG_ON_VMA(vma_is_stabilised(vma), vma);

OK not had enough coffee this morning :))

Obviously should be !vma_is_stabilised(vma).

Andrew - could you apply the fix-patch below or just fix up my mistake
inline?  Thanks!

Cheers, Lorenzo

From c95bba4f23981584b105e0e8c1d3ce763cc619e0 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Fri, 16 Jan 2026 10:30:11 +0000
Subject: [PATCH] fix

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 include/linux/mmap_lock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index d87a07608295..cb18bfa3ae27 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -473,7 +473,7 @@ static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
  */
 static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 {
-	VM_BUG_ON_VMA(vma_is_stabilised(vma), vma);
+	VM_BUG_ON_VMA(!vma_is_stabilised(vma), vma);
 }

 #endif /* _LINUX_MMAP_LOCK_H */
--
2.52.0

