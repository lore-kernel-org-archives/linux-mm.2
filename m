Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53079D74ED9
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 14:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D2E76B04D7; Fri, 23 Jan 2026 09:02:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA4E6B04D8; Fri, 23 Jan 2026 09:02:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6580F6B04D9; Fri, 23 Jan 2026 09:02:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F5A66B04D7
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 09:02:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ECAF3B8112
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:02:50 +0000 (UTC)
X-FDA: 84363394500.04.78383FA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5404180016
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 14:02:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=llEN0ka5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t6g1ExWr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769176967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sa3LN6gtYgsqilhtpay2+gV1rmadjN43LUfionlvcno=;
	b=aPVtLyjIFfMLQ5wjYZFAo4IHFR1neRSMrNjtiP/M2wYJkZaVxZDB0ZJU5svnAl62D7Yb+n
	VGFjIRqa6kb9A4CAEG3Zw6MQiykP240FswEMM2Jh93JVIcGXqe3RzklJO5tKPEpKu/0hDR
	nQUOpzr2rrgtnSLc/9unVVmjPZXMHKk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769176967; a=rsa-sha256;
	cv=pass;
	b=tCUSuV1/AikHE4Ls+wTifkW2oFe20PpwrcpiA1uJ4PW+EnwJM/b2UCYt/AytOpPLbWrNTn
	1B9OIoQLBzK8GWuuB194LwOWIjj+c53aTbDHJitm8jfpfVe/huHPU0xH0HxtxLeXGwvti4
	hGqSqH0JvAjVX66n9EjYxiiDOf8CygU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=llEN0ka5;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=t6g1ExWr;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf02.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60N3ELKS1884148;
	Fri, 23 Jan 2026 14:02:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Sa3LN6gtYgsqilhtpa
	y2+gV1rmadjN43LUfionlvcno=; b=llEN0ka5yFkIrCaaTuMrSK2/RM80XLLcWW
	XPMzfsXWrakdLSdqDiqj/AEGnE6J0qdmq97bt7ykXEPVLYE2dFKz7KvO6u37fwWd
	81N4B/iHXoiRk0xwxJwKs2fNRGB5Wfuk2dr79rwT80QdNiaubI6MTcF2vv3lqubR
	JmLr9QVXYVzzB6evDHrBSCF8flzIc7ycBa/f8xqyR0RSIZaMmaXOSorXfaEcgvRx
	RNIN1mTRWSFQTNIYKVF2VKaj9mIHPhAyO2TLFn1zZ5BO9kpJSeuIPhtauQDwsZOv
	KGrMhsiwsAK0WTZZhD80dGkqLWmUU0LI8Lhk9H875RLr2PSHGtsA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br1b8jdkw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 14:02:29 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60NDAnRM025019;
	Fri, 23 Jan 2026 14:02:28 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010050.outbound.protection.outlook.com [52.101.61.50])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bujd1fg9k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 23 Jan 2026 14:02:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WFOoUNzkE8rM2XmpRYgXJ5srYCpNzoVEXMcti6WwmZmqZBv3kdzNs0tmcEzgOoEBhYihz0v8X5Qj/fKmsFUTdfMavCDVroQdxmr/hco11unGS3/mKlEjRTFIgy0YMgoD10q5OB0r951azLFMcxKYj6Bxu0pDyhGWyBOGgM/7WCUFrlDIHraOtADjk3l5Em/mV5o+uMg8FmXYqAFAvdoq23WxbpnlygnZgf4DgirXy8zlahKPiEGLV6pQ0AupgQX1mEECPoK4a5gZfkCXNvVV78AvnFdaLZMAPJxsSGfdTIwtSsjFFaov4JKeQsU4uYLeLiWnLbcGz3UiM/jKk1W02w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Sa3LN6gtYgsqilhtpay2+gV1rmadjN43LUfionlvcno=;
 b=SKe1yQ+xCU6aAesPemgCn/qaauc+OkyQoqP7qGe0ilYqRRTxIkUXhXkRDBiNTgVDklnkDjo5bwc+ao/Jtca3cimvF78yVRGtcLiVyk6yxK5aOtBt0g8fQbnd7Pcg/+o9xtTU7zrNuRJaxiLeQsIv2e5+58dL71UsP8AIi2tVr7PMOVAKPnv0Ec5lbKJQR7Mg/I/fsEjVB9zRakQ/SdFfQbiaSF4YOo8k5tp0VPUsklAIearHRJ0MsHQvTaiv4gZe5TIc94F6FHb58rXEF2Te/ipXzKocdhoSJ6M2N+Ce8wJ/GUSTTg5nHFnmEVxlDwzeNjO07X+4VQfsXa7//qqDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sa3LN6gtYgsqilhtpay2+gV1rmadjN43LUfionlvcno=;
 b=t6g1ExWryvjxp1JuxIIalxfd7HZUNm5D8gwZSNonioRhFAuWobs98/Kn+v4XrJvBcxORH6whzief+8CTpTh7xUJhm+XCFBaEp1ywSQ6tSH6w1eEFA7vYyrE9OacVeyTDuq+fmUSqH/9TFZuJYs4FcLZGcZLeqRRx9yHX5Utw0lQ=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SN7PR10MB7047.namprd10.prod.outlook.com (2603:10b6:806:349::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.11; Fri, 23 Jan
 2026 14:02:20 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Fri, 23 Jan 2026
 14:02:20 +0000
Date: Fri, 23 Jan 2026 14:02:24 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
        Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clrkwllms@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Message-ID: <39d0c3b8-b38c-4a1c-a2da-a99440884560@lucifer.local>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
X-ClientProxiedBy: LO4P265CA0005.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ad::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SN7PR10MB7047:EE_
X-MS-Office365-Filtering-Correlation-Id: 22766e00-9b21-4117-54ea-08de5a8806a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GR7rfWNz+BQdiW7tyJM4p6tCgD6wCu8J21x154qrc4GfkIN/5i9ETxs8YpEB?=
 =?us-ascii?Q?DOT29dbObS0oBgMF9I9lRyhu+NLYx+5IAXnDICIre0Z1byEkmQk9NQq3K+7s?=
 =?us-ascii?Q?6/1ecsNZ6E2YV9Iy5S29BQSi0QxXOqipOC18QOxLdL3i7GJ3coJ9LYFvWef8?=
 =?us-ascii?Q?JZIt0YXjbqaZR2X5RkMVk1yVb6HiH0wQsPbKPmC+t6Ovw3U3tMKbz8bEqQ3P?=
 =?us-ascii?Q?Kib/uH4MJN040y94JxbbhCy3sZPHr1vHuCin04hmfVhfD6WhXlTfIK2aSPgi?=
 =?us-ascii?Q?aH2d4YJpOtYiU8QuehLoF5h956XnRLlLEpM9uokZB/iXYnn7CBXn+8iqUrD8?=
 =?us-ascii?Q?pWqANOkfB6k3LPn2peqSRlfUdVGkQlM5tTP1oYltnrVrrm6I+0uFabgCTZ6z?=
 =?us-ascii?Q?NaHEGwD6pADZuj+uZLCr6e56P496Uj8UGTpgVhv5oZCkMR9fYsW6zZl1uZPf?=
 =?us-ascii?Q?6PkW0S3q3hoUmfUI+uQnjvHIqqvdds/VYgnpObMQOpl68N22TD6b4rkADZRT?=
 =?us-ascii?Q?6yqYHnuBeHQ9/A1huvyfx6to0W/XjnhBDQSLbFS393mfd+zFS2LM83o2gVJK?=
 =?us-ascii?Q?RkMg2jCOTEoFgbY0TVReCowU/0zXaweEtuo/rUQKpz/1gGXghKgWLrZGniYN?=
 =?us-ascii?Q?mdoaFi7jNVqzfiR5nqIUKBBlmGdtCkq8bE+bn1htvPV6wWqYHLYUcpH2IJCw?=
 =?us-ascii?Q?cxDnrOOLPlTLO69DYRMsKChMvh9HV4M+q4qwCCbvfPYnYwRje3PlLSrC2mDw?=
 =?us-ascii?Q?uLCbbl3hr21g8P41oBM4MLyf4rIN7W4IPSIRrsWxCdGA08WfrygdhgGHeWuo?=
 =?us-ascii?Q?ua4/OSyqnQBnSIwWlYolhRsCJmgrKU91WPXJX/5BOSrEuYIcLj7DPGEhBYYN?=
 =?us-ascii?Q?q8/Ivl+6bXKVzTCTzvGj9HiqJkeaVd7YG5DfeHc8niG5UkdV/Jx3x8jDgeiE?=
 =?us-ascii?Q?FCzHrWdh8qslCIpL9UBV/pK9WKZG5V/6FpOamV283Nj+ZS2ObPHOMFBepxvw?=
 =?us-ascii?Q?n03p59F9hBc6WvrD/Qylk0ip2HWp5j1L/5oxVJki9MIRINj2f9I2iD35+8Rk?=
 =?us-ascii?Q?LJnAcr/GErW63U6/rtmqThTqnQBo96Bge1zQgmg07CcHR7g3UbuyyJg+xBf0?=
 =?us-ascii?Q?Ym9f8EFwnfi4Frd9pesNxEd6lYCeWUbY/dEvU6kOfxgsKbV/NyXs5iVSGwKI?=
 =?us-ascii?Q?1PnUikdjD1No+h1zfpdDDZcuRJJkC0PiI/CQHoQfFqQyk5W0Bivgf9ywOMmU?=
 =?us-ascii?Q?SOIKTsoKRst/U9+iuygrZqqpp+SC2dKoY6QKllxiqoyB9tpvRAvlY5f7LJfu?=
 =?us-ascii?Q?PaNO8Fi3KG5etbzHzE9kmkFRqUEZEFZ8g1ECe4PDuuasSoNg8Q0GhDuJq4pg?=
 =?us-ascii?Q?gWHMrd49+k1L5UERe7YGjVizJn6Bf9bw6Bzy7HbwUjVbVAw4eosBEdhpbWxe?=
 =?us-ascii?Q?izNLM4paAE2W1/rtQw8ZogAz3iKroZTmBCgeva7LBeazhi4PCFA4dOeeyNpv?=
 =?us-ascii?Q?LjR1ICzSgOY9XSgnPlcIIiDem+Ei3/5XoFxaOoWqPHqu6d0ucNBxDqC38CkO?=
 =?us-ascii?Q?fBGOQwy2E7xICAZJkyg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?w5CUSxnwMk4hQ/qzJ41KWC3HGg8o0QhKqG5G98JBrYQH4ouAzsgQiHKoG+u4?=
 =?us-ascii?Q?OwocpdkSburxS0uYhbwRcuPx1KxBb6/QsKQlChmBFPiumDa+5i0Jt6lbGv05?=
 =?us-ascii?Q?gU1RoJJbVkOfCOC1ZzUJBhGEfLGGut+Xp20/SuisPqp0/7LD15HWGGLPAXCO?=
 =?us-ascii?Q?to/krdt825VLZm58IX1QM+Ku5suUQnVMiGvKcF/Vs3i7VO0ucnwkpFCgs4aa?=
 =?us-ascii?Q?4BheoxDhwzXkHZRFY3rDtU3DDrpHA8cgliFmJrt66gIOiWWk7rpn/idgVq0J?=
 =?us-ascii?Q?jCIabqHN++xzfu405zN1XxpFi9ApSXoqMNtdl1i9WTiQ/DrY0OQncOTq6ZUq?=
 =?us-ascii?Q?VsEIB2jYcOqK5gHXLl3eDiHFLzqj+T7oNZxbX9aQk0iLUgYjk3Ypj8DQDZJT?=
 =?us-ascii?Q?bEQHj8PJo7OEjO37ulxTYRbH4EkCwCjLgRsq7xNEyChOAa00Orl4OLsReewy?=
 =?us-ascii?Q?NU2EO7p8wgJlBjQBuUXYkbw2PiBBDex6+flJVfGrn/04K55ciRtUF626Wh9F?=
 =?us-ascii?Q?8r5kXNMR5Hawu8j2BS/k3hWEHn/YqkyJDRrBZm8pzB3tDaujccp1C1AWvoVi?=
 =?us-ascii?Q?ptTvIvAdMJH6ryEcWi7R7IyD/H92QFdGRF+v0YPM2AIswInMqBHiDJ+dY+oU?=
 =?us-ascii?Q?yjk0ez4f327RiZALy6iIHPkEXJ//L5FXdNSi/wtvE3axCPJ+G6HEgSePtPB6?=
 =?us-ascii?Q?r0mZ5XdcJtxQ3HH/GRgCWTrgw5YvM7ojZ8JJii+bgNEbuWxKA3Ez7tuU9rD9?=
 =?us-ascii?Q?vQ8CfGE2Ane00kcQRwRBpmOi0u98Ch0KttLFjJE/SR50w0fxi0olDzyrrD4O?=
 =?us-ascii?Q?dzhqEtQ0xfNrhwVZEbq6WFhAZQzD8sKaZK++pDJgDZtKWihjLR+D49vqmdk4?=
 =?us-ascii?Q?wUg0rPmza2dHYFRvDB4PVgMMugM5dgw0GFR4IYt9VvX5f07JSWkiO17+IRg2?=
 =?us-ascii?Q?iwc+O2ztOLmo1mZbKjRjol6cx8ScQrH2lB0YM8s8wNX5FgJvioCZZ+O/6PTA?=
 =?us-ascii?Q?ws4wCZVewiHQe3ooCErsc8RF3bBKgp5MlOPdbajLBGsCZIgGr2GJJ9GLHTpy?=
 =?us-ascii?Q?7N7nEbU3qFHiY4TQKYlyMZ6USl2yt+Buxnsm2ULgf+Ghu4q50ygdYNSxOJgk?=
 =?us-ascii?Q?uR8aiXq0XGHOJoMJz4V+IjEbCxwkqTbpHchoGxX0kNCnJbwTWMCv1fcURry1?=
 =?us-ascii?Q?+efBAwHUjrAQgwXKM/g2gZ5Z6Rt0EVJpRKtkhwi/686d6nbeYWi8fUmbvxP4?=
 =?us-ascii?Q?DG/1E5ujVoSQfo61ePh1umPO9H+sbEUlnfhmnN+Uq/cS1gjw+uEtJQHUcbkj?=
 =?us-ascii?Q?hiGHl4uutL5YX35+6pRhB1LrIhxOi0ryWpVI0sxVkfZXTjZX+WLOYwBd/wPN?=
 =?us-ascii?Q?5gaObKCu3zm9jYFLsBrVddKDKZerbQ6ybLmaqF7tPGLG22zNbI/ecp4LCW1T?=
 =?us-ascii?Q?98gS8PQcShQYcXUCQJ+Dbg0dLMIimMziNiwkLjfHYWS3U4LPt9sKlwY/wcNf?=
 =?us-ascii?Q?VTsPUs9euoylpA8kxkGH6xyl1q+FLH22ZxXJTFXvkqFLrR/ywdAD56LoQLaK?=
 =?us-ascii?Q?ANGNw+TtTlnOgsYtP5/f1WBmhdqt4biFjJN5WZzK45oH2Wa0OjwpH2sf5a9j?=
 =?us-ascii?Q?YbPxi5gKVcRILPhyBd0bG8mASp3U7/1fw9dyxbvYu7mYuZ/yGhLg/dnbKwd/?=
 =?us-ascii?Q?ujWl7VenuzMmE+txC7/Usa2rc6I6tLMGvHcN+7PvNUh6lJROJjRrTxEIWy7m?=
 =?us-ascii?Q?i9VowLv7h2yW1m2pPS30lHo0MKDbd58=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	43jBmgKB2R9apHdcJ/EVPJ69JSzlNrAf2pVV2bPJC6fwrrJX86DYeDKljs+qD3BwNxtbm4TQBlu7HiqOUgFfLSIM3mUmdTVw4jx/niAAjirfort5n0RWZZK6e3GmEY3CAgG65+vqh90ue4P8ANSTLxYtDqeKNmVyohioZX/abs7al3pPFf0/VTf6jKmmm0WA6uPJOsL2O3L/byiy9swiNvv3Rhn+4scxBnBPcW85URYGSB0zEhDjpwNCljrolfQVCJLqVQXHJ+z49JD1bKwdi3qzxMIsTYgl+WnwtdrhCIlzqL9lVq/RM0PZrF1OuWptk0HAePum/JqVJIs0xAahLb0vdyXaHdL0URqM/okv4kfuvFBEc4dVhrcRTf2+lJRYStfjQN7GKdT+xm2bE9nMnQkuJRT/p7U8BrLxNoQtNwmog7P1eaR/9FR3mu67byzd5JV0XQzVzXiVGFVbTYxCwUYrzDSz/LALCXqeJTjQEtixIUKCHUwm/IAfFkg2kN6OPXxQUzkIV8D4NevZXESw2VS2n7EU8ez/kxH5Ercri/wXS4t6ZRAyCcXuB6gvPKRC6yVW62wrgrvu5MIC90yo51Xjx4VUhWWJub4j16JO1tM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22766e00-9b21-4117-54ea-08de5a8806a3
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2026 14:02:20.8159
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3u9k2Ol2XiRmMytZt8oyp3mWyKYTWPFZ95fnO0XWAs+92LaKDrffXfHYwSJclX5NIXcJve/QhlNHEXMlCMDFebPq6KY5q65Aiol6tAiMtgA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB7047
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-23_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601230114
X-Authority-Analysis: v=2.4 cv=WbcBqkhX c=1 sm=1 tr=0 ts=69737f75 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=eftg3_9N-y_0ycaEm2UA:9 a=CjuIK1q_8ugA:10 cc=ntf
 awl=host:12104
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIzMDExNCBTYWx0ZWRfX1anWJ8i4S8+g
 ijtKO0JNvGBcBUJRGb6MokN+BfkGjyX2s+sIt8UnBDUlh1z1FxjcNzK1j3evYq3qzNAvVFVE7cT
 9KFtPrel6KJAnAzeoKfPgDQpZsdJSAl652BGZo4rthZ+ovih5MLL/AUic360Nk9E9FZsqDMXJiJ
 ZYOzPOy7yvCiEfi6n8IekJqKg92LxEm9N+6vRjMuTixXTiL0BE2Q0Z7SYD+uMJYnTYyBs51C0Ye
 g/E8DjJ5Sdp3uo4iNksTrnUzdbwxB7AE/cP3pcVGCaQRAph5PMS1qX/WQku500nWmioJkyGAzBA
 +X7QXvhqa2HFG9tGnb71iObEKBeERF3Tc1BrNgjirPeUNvzPYR7tjYQGyymTev7qEYBySiAj0/P
 14K6xYPmCHylB6Npjm/zDXznQPnZpDDT2CzAv37YavlYkl2ZFYIJ4HrdRNWmwBW09NnqlVWWBCf
 iiDkUP0vEVU/GfFdptL5hJ5CWs1a48uZH2li0SzA=
X-Proofpoint-ORIG-GUID: fRYe7Npz57SlLcDhJuDCx33S10r2wkfd
X-Proofpoint-GUID: fRYe7Npz57SlLcDhJuDCx33S10r2wkfd
X-Rspamd-Queue-Id: 5404180016
X-Stat-Signature: yf1dj3x9ar7yoqf5qxs8gkz34gnw7cie
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769176967-331248
X-HE-Meta: U2FsdGVkX191PgRVhWKHQZAWLBjnn8a3rXnqIjiv3C73I7FrcVr+vBzn3U0yl0leVnPdX0JG1hYCNT4C/rKxf5kYTeAzdogU+1MoEHitGawCRfHXiV19N/59oc/WKXpcE4feHxq1WI5GntQ4jWOHV/VIuM7HaGIFDHFiSZvEjQDxaOU4dfm8B5RSLWPg2JlucO9aM331kaqeyaJKbjOY3BUinaOp/OrQSDEjdTFUy7BZNMHWcfj8MalGJHOFBivwcVWdDBfik2RpLG5b8G/eTLKf2SIOsD1FD00Vr4aViX1HLoXIa8aqq4qhiv3IlG7lllNYhMb2luNx8qq6GzH/CDsvfXj8OzTjR/QMLnyxUhWzaEp2feBE+mHrhT81zEkSMOLF67qoAl1M48BqK0UaCu2+/zvf/zibL77HoIxSCPB92PD2ohzOsW7WEHbqV97l3Z2sYV3CcyLGjll300pqgb+IR0MqdpqWjpjTBK4vhmyFiqTiXhdtU3TKxK4yz4JdvaAZAM/+0pTDq3DT1GFlI5tnIuziATBDjnG63ue3WCW978BZY0B9eaWlWtUlKR9TkY19kJM+fLZTCDc6A3QKuPQa5Pwq/3V1RfXJhC8bOd21d7vryIUKThCWk9lQJTvnydM+dyBBs1DrguqAzeOFWRgO2OKJnYgZWdFaJZhff0YzlDpiX5rSuqinfg7Qiz33AryyufbpbyhJvv5fGOcBA+sbzqm7knZ/LrOXNqDtykBnNcDkND4QdEbffmdic0gKysMF46rh6FI1vAGsMCVrHfwOzy1122kHLalDTSYAtUqqoga4ECV1j9BIKVJoDTzBso8TwzDHPYR5aKcMZgJwFWk9olnvXw31fHrxLJGgDYB/7ObKpbiUMknpEsYFsiptPJ/YH5q72DtrMm0Vjxdd1vVxuEPmFfgfCtsJxzE2wnfuOfdwHs0iXV72idUvGY3vYLfBCk13Nktz5E8kkN3
 AjOwSgyi
 wVJ1MyPA2GW7VVZnj29q7y68jFDbKg9XQqga6QjTZM24/P1Z++mK3lZ/PoCVML9c3n7O7ONFapsKrUunL4MPK2bJMHgTduPMX0IMQWo++DjXOGv64BagLoq54iBUleMxFTu0l/iqk5cuvEfpOcLhkWwDJjbNQTfYG9XLWt5smcRPb+aO5sv87M2UgNc1RjceaXjg+1Y7pbTLjCYlTefs422z3b76X1sn5hHLY8OYm6biqhRs+oTd79ttH49kb1CywrJde6XBNT4WYwCJLCb9CRhAHECOpw6S0xmSQvWA/IwXB9TQEzBjvFzkUkgLasoJMsK22dKLV9zgLg2duzJbXP3zZ1/LLD197O6QEl/kQ7FpGcAbQMtvtHgf9F3WWur3LQAoNlms5RQ0LwdUGcVEHK5tdU+Agqw4yV/AWPOizCq05+1aNG0DodnoL/MMV/IoVBZesusdb2VniT4l/w+GD20p5oU++thBir6MyqzrjAzWIShN7csC3S6gQ/iZBIeyY7r8HWMJo9fsru0G473dt9rR8n95C/MIGrW8RiIy7CQ2WCmkNBWCFiXGivmTUbKzpssGnOlx8JrgtdZdVSH7SfS3SrrXGYfd3UpXxySthgqWVDwr0Ie16rCzOzdqOtXOjFnbrcpzAmjVYFscgWzapk+NMtj8NrhCL5fh2iVor4uKy/JfRFzd1dcMZ7wWU82N8nCXNbDaQYxONCD8ZK9VbIVz2nJh3A7WFP8CWMMsLEqTkb4xYVs1dSSixL45teDbyBeh1rayF4bZOqTs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 06:36:03PM +0100, Vlastimil Babka wrote:
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > The is_vma_writer_only() function is misnamed - this isn't determining if
> > there is only a write lock, as it checks for the presence of the
> > VM_REFCNT_EXCLUDE_READERS_FLAG.
> >
> > Really, it is checking to see whether readers are excluded, with a
> > possibility of a false positive in the case of a detachment (there we
> > expect the vma->vm_refcnt to eventually be set to
> > VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it to
> > eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
> >
> > Rename the function accordingly.
> >
> > Relatedly, we use a finnicky __refcount_dec_and_test() primitive directly
> > in vma_refcount_put(), using the old value to determine what the reference
> > count ought to be after the operation is complete (ignoring racing
> > reference count adjustments).
> >
> > Wrap this into a __vma_refcount_put() function, which we can then utilise
> > in vma_mark_detached() and thus keep the refcount primitive usage
> > abstracted.
> >
> > Also adjust comments, removing duplicative comments covered elsewhere and
> > adding more to aid understanding.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Again very useful, thanks!

Thanks.

>
> > ---
> >  include/linux/mmap_lock.h | 62 +++++++++++++++++++++++++++++++--------
> >  mm/mmap_lock.c            | 18 +++++-------
> >  2 files changed, 57 insertions(+), 23 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index a764439d0276..0b3614aadbb4 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -122,15 +122,27 @@ static inline void vma_lock_init(struct vm_area_struct *vma, bool reset_refcnt)
> >  	vma->vm_lock_seq = UINT_MAX;
> >  }
> >
> > -static inline bool is_vma_writer_only(int refcnt)
> > +/**
> > + * are_readers_excluded() - Determine whether @refcnt describes a VMA which has
> > + * excluded all VMA read locks.
> > + * @refcnt: The VMA reference count obtained from vm_area_struct->vm_refcnt.
> > + *
> > + * We may be raced by other readers temporarily incrementing the reference
> > + * count, though the race window is very small, this might cause spurious
> > + * wakeups.
>
> I think this part about spurious wakeups belongs more to the usage of the
> function in vma_refcount_put()? Because there are no wakeups done here. So
> it should be enough to explain how it can be false positive like in the
> paragraph below.

OK moved the paragraph to vma_refcount_put().

>
> > + *
> > + * In the case of a detached VMA, we may incorrectly indicate that readers are
> > + * excluded when one remains, because in that scenario we target a refcount of
> > + * VM_REFCNT_EXCLUDE_READERS_FLAG, rather than the attached target of
> > + * VM_REFCNT_EXCLUDE_READERS_FLAG + 1.
> > + *
> > + * However, the race window for that is very small so it is unlikely.
> > + *
> > + * Returns: true if readers are excluded, false otherwise.
> > + */
> > +static inline bool are_readers_excluded(int refcnt)
>
> I wonder if a include/linux/ header should have such a generically named
> function (I understand it's necessary for it to be here). Maybe prefix the
> name and make the comment not a kerneldoc because it's going to be only the
> vma locking implementation using it and not the vma locking end-users? (i.e.
> it's "intermediate").

OK, renamed to __vma_are_readers_excluded() and dropped the kdoc.

>
> >  {
> >  	/*
> > -	 * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READERS_FLAG
> > -	 * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1) if it is
> > -	 * attached. Waiting on a detached vma happens only in
> > -	 * vma_mark_detached() and is a rare case, therefore most of the time
> > -	 * there will be no unnecessary wakeup.
> > -	 *
> >  	 * See the comment describing the vm_area_struct->vm_refcnt field for
> >  	 * details of possible refcnt values.
> >  	 */
> > @@ -138,18 +150,42 @@ static inline bool is_vma_writer_only(int refcnt)
> >  		refcnt <= VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
> >  }
> >
> > +static inline bool __vma_refcount_put(struct vm_area_struct *vma, int *refcnt)
>
> Basically change are_readers_excluded() like this, with __vma prefix?

Yup did that already.

>
> But this one could IMHO use use some comment (also not kerneldoc) saying
> what the return value and *refcnt indicate?

I felt doing that would be overdocumenting... I've had people moan about that
before :) but sure makes sense.

Added:

/*
 * Actually decrement the VMA reference count.
 *
 * The functions sets *refcnt to the reference count immediately prior to the
 * decrement if refcnt is not NULL.
 *
 * Returns true if the decrement resulted in the VMA being detached
 * (i.e. reduced it to zero), or false otherwise.
 */

Cheers, Lorenzo

