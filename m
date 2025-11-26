Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 857F3D1118E
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 18:07:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7D596B0010; Wed, 26 Nov 2025 13:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55436B009D; Wed, 26 Nov 2025 13:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D176B009E; Wed, 26 Nov 2025 13:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BDDBF6B0010
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:07:17 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 552EDBAEB0
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:07:17 +0000 (UTC)
X-FDA: 84153540114.21.89D88B2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3230C0018
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 18:07:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nlu6cApp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ov8xOouM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764180434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYnN5FZXquOgkJ/PQcnaL1q+GhP8uLZJ8ivcUpdvU10=;
	b=F5tMl6ytAP3PQdA7T6IqAp9JJXl59nCdK34jlnx1ROYAYUPIsd8CA/GyYg1vnMpcSLOZYs
	0vSApFQHE74mdc1X/ZHloXaTdrHYaWSJISyZj8q175elfIMo8Jq5y7BDnP2ju0o/Uxvf0W
	l3eGTWERsUb+k/N+nuuyuofF2t6o8Ng=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764180434; a=rsa-sha256;
	cv=pass;
	b=of6oLxY1TYZmyWojPh+A4v/B0mxIGXtTsa8ymYBgx7F23lUkA2/TXunYatJLcgch0QWRrB
	leuvz/6QUnjNEiwG7l3FMWl4hzEmSBrWV9DaoW51MYIVV3OkHrC6VNJS1ur0SfdAvWUqiQ
	VmSXS6cBvEx12P1/r/Nd7YU2dCAtgQM=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=nlu6cApp;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ov8xOouM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5AQGGdUx2725861;
	Wed, 26 Nov 2025 18:06:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VYnN5FZXquOgkJ/PQc
	naL1q+GhP8uLZJ8ivcUpdvU10=; b=nlu6cApplLZniNjsoYaPQi3I13WJOjyJeF
	jEiHVkz74WGlwxGlYUsKIxtgPrqU1CQ7Zf45iRUwN7a3GVOUbWHC6zKCyvjZirzB
	BU0Lim55fHsvOaB4ouP8oXk3JIGozQ46alMHaOhlcf9r6C/yBDODOzn8pOC15VqC
	fctry/NvuiJIzV9CpDXJQ4MA5CYUtvCwvTbuqHheeWrkzlgUUKX5LZJ9yYtnLZ0Z
	1zFs+AjJEXQDr8rnv9zb/0epPoqK9oNzPhusSeYWYKnBHrPWBCrDMigQlZQwMN8O
	xyNXhKcMAKm62Nkw290+py93BaAAdbwVozRFK1o90bQ1Mdzwcj+Q==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4ak7ycn26d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 18:06:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AQGg52x032768;
	Wed, 26 Nov 2025 18:06:58 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013032.outbound.protection.outlook.com [40.107.201.32])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ak3mbavec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 26 Nov 2025 18:06:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=v8YJtf+DLUjHUX0ATM01MBmAUJ9yroEBnA0DXGqEmyF0pqYmr8vKl2u3VUzdwMhTPOEH9QFtKuTG+VlxaVRR0rn2YlLUP16t9IgoE6iD6fJZ8IB2chl+HtvmxPI3U//QQa4itwKWWB9rXcjHkjk0PrXvLs49+AbKBPQuC1l78v2CHih7P7H8R1h2I+2WsZNWpnnfGHrUj5A5EYqJa1rLdZzBKcucOVy/IFpAHVUEHdgfrE83s++i0TQQAl69yAy8yrqd4BiHMhuKxn3R8i969XbNlYzrQlxqjBqiRpI8DHeTYPcHP1PdtmL7PX/F4WvcxxOPlgkg8dHe8tQgOeY/QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VYnN5FZXquOgkJ/PQcnaL1q+GhP8uLZJ8ivcUpdvU10=;
 b=h9ccBnz3zvwykR90XeBeDMQ9ttgmVZh4y1nJZM1AOD+OS9Gi4aPvGYw4qbJ7I2X8ASlDMkOPL4J0wkG+SHLaR7gTJpyMeBeKDmv/e83qaAoSWZJi89CrXGmgihqIDt9M2IvzYHacSuKwcnN/Ga7rZzjesaSlN8vG5mdgu2j80DkWJ9pOwYPAKkRbQAUqAc3LAc07wEQ1KBFKKxdrLew3b3rWdLMUNAI+2t2fseV+sseYly8ka84CTzWTUtjKQRqjz5qYM6eUF5QnnUgHN7VPZ++4Q0taby/DisLQ0XQ/wM9h8iExyrh7QaEd5j9ANV1cg+KM5NRNkGkf+PR2HJm13w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VYnN5FZXquOgkJ/PQcnaL1q+GhP8uLZJ8ivcUpdvU10=;
 b=ov8xOouMFPhSbKfxmy4xtmnyXY8is1PRqaMUHRYuiXx8dWEL7uBrRtHcf4Hcif9+6p2ba6v0A7Q/t6f7Q2mguWc2O7Ej8xF8SB832mWnraHRPbLMj4GjIYm+h+PcY0Zze9ABw78RZQLd/QGYAxCJeotFVl8VRKqlZTzR3T6e+gE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6465.namprd10.prod.outlook.com (2603:10b6:930:63::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.11; Wed, 26 Nov
 2025 18:06:55 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9366.009; Wed, 26 Nov 2025
 18:06:55 +0000
Date: Wed, 26 Nov 2025 18:06:53 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH v2] mm: fix vma_start_write_killable() signal handling
Message-ID: <c35ab0c0-97c3-4565-ba2d-5c418ecac593@lucifer.local>
References: <20251126174500.2498895-1-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251126174500.2498895-1-willy@infradead.org>
X-ClientProxiedBy: LO4P302CA0032.GBRP302.PROD.OUTLOOK.COM
 (2603:10a6:600:317::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6465:EE_
X-MS-Office365-Filtering-Correlation-Id: 97a66c1c-2646-4edf-2ce7-08de2d169587
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?/FZsH7ekjxg8Z9pOo1kb71TTcU5t5DRgRyue4nbd5sI9Jes40LUw3bO+oWUi?=
 =?us-ascii?Q?kPuhyRTJqzEfsKrrgm3Z9pb2tuf7J0e3lfxHOlU6elqh/NRPhb/f25MH1crA?=
 =?us-ascii?Q?Oyz6llBP3KHmU3BxUeuLyajEyqCLXdhLOEqByZI5YKRqAfCXds5TCC54C6+a?=
 =?us-ascii?Q?/Dy7plkza6uvwxxcH7anHM0IOFregP8M7EP2qqXSKjEkmm9t3ZZT6YdGffm5?=
 =?us-ascii?Q?rlHTltLif2xjGLkwZM4DmRpzgAbz6nwU5rCUqyEGae4e0+InAYn2fAMz1vy8?=
 =?us-ascii?Q?roOHg97+uJRqaMQhE4dSAMxmeTLaoq3yE5Rq4/acNFA4dA4R/buo+emlTpto?=
 =?us-ascii?Q?KHcqzGzSoYnXnmzNfuOCHDanqfOSFmn7ELFl7wC+Cwf8YtKM5UTiFmebeo1J?=
 =?us-ascii?Q?pes2UrQBqpQ2NTN/LtePIS6fHUvjDW7BLnfqWPfgHFHfV9T4QLkn4eeWC7aw?=
 =?us-ascii?Q?w9VrTUliASYv5FjXCdo3dS1T5Pwvoz7jV6o4xwDPA2zeGGu3caiZ9Txn3Att?=
 =?us-ascii?Q?CcYE8fD/MvAjfDKidFLVqdhpeO5DQeNGRAeVDBpphRTlkZpSRk0/uaW6fdqm?=
 =?us-ascii?Q?3KSGNGMGC1+Q6f3+DkCJ1RYKjqitiUJb8wpVxKVGjzOG3bx2cFy+LYYLysAT?=
 =?us-ascii?Q?S8WTICJLMR1kYZQ0iO7cmeGDWu21tUxJFzTLmaQ4+Da5oEMsrmXit9HP82kI?=
 =?us-ascii?Q?40EKgnQ97VUuxvCRQkXFLWL/ELnrv/w6hgwoeYznbEV+6gx9huhs+yh6k8x7?=
 =?us-ascii?Q?lqyMLKITQLn/HyEwnU60fA83s/0wJnIxoAgjrcIuML7rdV9JtkP4CD7N9lVz?=
 =?us-ascii?Q?yJzJXEARgXnVjfOawuBGLTBEJDiRRMx5//FymsM0gFetNvTydKp2TxUQseDR?=
 =?us-ascii?Q?WsjjMqLOvAD7fW4pKB2oEeAYWHYn890EdfMfw+/o15ffBpsSLWjerR1nTt32?=
 =?us-ascii?Q?Ti9PCxOoG3lnpN2PjxpnjN0V96fDega/27Zmu6T+wrY08/PGZtQr4IPDFaF0?=
 =?us-ascii?Q?ZIWm6a6zB4Wcm2DQOD7abjDH8dil4wUgbqY7w8pevR3IpZr0YgFzMYFPAEwb?=
 =?us-ascii?Q?ctT0eZdtX2gY17KOfgkGg/kI1cvSDWI5UaqZzVJDPPAmR/XXysBhebXPI/YN?=
 =?us-ascii?Q?Zu0Xo4mL77E8sxU8wy1xngambogMF9h2/Uf527hlFrRUD/QCK9KYN/7WEOQI?=
 =?us-ascii?Q?ssUdXqjWXROnXONov1oo9YaE4zyxOUir3mNPcqMIM8pbO10QQcTIcbgcu47v?=
 =?us-ascii?Q?xk4xQ513F2EXOFgoqJF/KiV0I+CCJhL9nQRVpUy2zxPQODlF3RY1pH8CKe2M?=
 =?us-ascii?Q?6tB1LWcdVkdgIPsisSnT4Ex0PJP5hX3TX6Tqp13gvVTuMj2K5jkrm5PtkZb4?=
 =?us-ascii?Q?+DPztirjRxXgWf0OOI9WM1qpQNfhYXWZld7d9gz/KI3q4Yz5ejuATQLEr+p5?=
 =?us-ascii?Q?WVxD3I5tMkT2h9U02wqhZuGLMN4lZpKo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BzY2FXE54nHq5KbDaUczQUEb7tbhLUM7/5PFn8gFiMCV8d5LX+ePmY/PGlWO?=
 =?us-ascii?Q?5MSwe43jnuca/uVpzcopkDaovE71rV6hyliWsjwjqxUQ82RbLh9Vv9jzYL7G?=
 =?us-ascii?Q?pZeMUKQtA7LbSz2Qs6EWjI3JnDcjXf4QpX6B4cdu5+pHQLV9TIwapu0UM83v?=
 =?us-ascii?Q?O66+r/KI2lnryRpTU3CUG7tXNgTPDVqx5pek5yjm6MxNVM3fo5psAnVP2NXN?=
 =?us-ascii?Q?Ng/v9IFk0LQTyXNmqBKjcZ74KZblSNhmv++bccAHvqQSLe+uXw/1PHeNpuuV?=
 =?us-ascii?Q?RCmx+i3MnR0jlFP9AbHBdReeVVIkYgHqWJmww0FAE89kfFf+5X7/pGnuHZZI?=
 =?us-ascii?Q?+94/01MWcFBozK6wIpD6vSDXl7YbcYQE3P3PtFqj10IU7yrqJdA7MKkfA47A?=
 =?us-ascii?Q?wp4RMJKy1AlzYHQ/3VZrhkPlkhbeHDn9li6DCwfhM8JMqK5aRR9KEigcrcut?=
 =?us-ascii?Q?7tKh5UROdGhF84RKYHzdfo73p7FOhPLdihzboR2u1TkGKuK1SUIgkfQ83Z1z?=
 =?us-ascii?Q?vGa9SjpYr3jkYPJAEoHEroTsO+xOxcq1NV4NuyIWz8sKhgZiFMeYzxfxFmU+?=
 =?us-ascii?Q?dAYts6farSFjoDg27Fe17eeal9gX7kasqb2ah159kNX7G4IO2nq3c4QC1oaY?=
 =?us-ascii?Q?9qe/ar0+o/U7osYRhi78wrz3iBiSSxdlEet5HbgIg6O3Zwaxr1RJX0XaNgnM?=
 =?us-ascii?Q?i11XyzJPliLaWlFZ23jXdCAgarHrGxMuFlF9Q/0xBfY+B/KnoT2xi4EWRbO7?=
 =?us-ascii?Q?MEv8TUhafdcdajglLftcaiW4wnJmCyx1R09RzXvn7DeEUZU19p582TQ3gyhf?=
 =?us-ascii?Q?MQLza6wtH2jahcUkTF+YaGu5zheaH0GWqov3BpN5wKzy3tRyMtgBG7u50GWr?=
 =?us-ascii?Q?ZF3Yan8hUjlaRbO9fdGwBlxysdozQYxp+VyicZt2CSr1gnAVMeXUQI75w6HQ?=
 =?us-ascii?Q?lZcB4jTsnD8PsO+jigl9VmrZbTLu81geAvdEsx+Yb9AU3q8Sje0koAxdUqut?=
 =?us-ascii?Q?nX0W1SzMsVDUOX7d1LtX9c4nzwGtW14PZSbzk131hrv6vGj+qCicwrRB8iok?=
 =?us-ascii?Q?nbojAgfe01etnnX+A7TaK+nAR1ULfySPNWGfHW4YB7ZLh/pvBR3wiPgd7xO2?=
 =?us-ascii?Q?So5KAkAVHmIk/uRKLqt6qnhxpMTyGd/smvwQgZF55H7cnScxw13wyqm5/I4i?=
 =?us-ascii?Q?6gdJ+R9oNtv7IZDcbqLRqA5661yble8MT3mFkLu8+nVC8A1IOB4KeleXFmnu?=
 =?us-ascii?Q?UnN+YwBVyVSD6Zf1Ig68fn3KSJvqAx6kX3aCK6rKCQmW9GW3jQDrP0mrFWpj?=
 =?us-ascii?Q?KA20dQDE21WEj44HoVsmzNA4228N0IbfJqtHptNO8wUqGukhR3H9DmBWvQ2Q?=
 =?us-ascii?Q?j1pSWzhpKWH9vl4AkQi3APtq7zlEDHlBPGP/g3+Zk2w3esLxKWcCFoq1vTIy?=
 =?us-ascii?Q?HbSdEdNDKyItO4vaiqWnrzWYy8etI7Um8cjbLhL71VYIoX2JjmpIYa+OeHxi?=
 =?us-ascii?Q?FU4JvMM8EW6A6U4o2GoTcyett5yoYGW/LJRLypn4L1wr7gP8t2mfvbcUZ2HG?=
 =?us-ascii?Q?FbBKVG1DCe+v2yDuBuXRXdpdOE0HnrXDEF6cr5doxR3zqTnYzgd7I0hizGRE?=
 =?us-ascii?Q?1A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ba2spQN2JG+jlD4jkqR1MJYDJV4CVkopvg69/pIudLJuYHY2u8xOaHp6Q/J4zjgIwQLRU9LrFC9msDpC0XdEMLbX+KBp/qd/Q9DBf98yedG8apq4/aVRREfXAY+WOYyHM2gABJJGZFbPDhpbW5ptNG5Q7OKgw8YwzFk85wXNzO9wCEW68JnR7Pfl+BwI6l6yneD0WyuHaQkbL30PTOf7HiNGVde+8m6h//3uHPgEWmkjmeZRkHN/Chws0mBir84SYnCAsBcispEsiSY0Q0CGeTxZ0Qeag6x4vJuOoNBYGSS1lQt+0LZ3Z6fc6e4ybqFmtzX9KAaNaxrTV49MUPm/QBCWv4Ovs45pwDeKBgIlLwP8r31YfL0UYLYPqg+/9ZSAMInwGg4LQjgnhQ+qaOfKCsGBA03AXNGdcj6r4Djg+LnT4a/8FORHuJ9Cm763Ffv8v/5aIOQ10bM8DI+YIicLOOHlnbe2bqmZhsa6AHjKbCFTftFfXn+ChPsQCzpOmf3TvNff2VMxl6NHx7DeSBlCPQmc9EbOhA4wpPt5QgapNDtX0eWMwPIA9vg+mVAorVWqIvX4W7daUQNshfXHjznxp3Izg/phCafxTB3eKn393z0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97a66c1c-2646-4edf-2ce7-08de2d169587
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2025 18:06:55.5212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PKHW1YPnlAwQHdFJuxfENeZA32aXpvsxtEtaJGRM6SiqMTBKvzZ8+yVNpw4PIyJ0YCmng10Y79AyuXad7AN6AmZrPwkXMPQDoum1bnzuNAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6465
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-25_02,2025-11-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=831 bulkscore=0
 mlxscore=0 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511260147
X-Proofpoint-GUID: fbsZmnyfb5iA4SlYZxYIKmdyAYYkD9Cr
X-Proofpoint-ORIG-GUID: fbsZmnyfb5iA4SlYZxYIKmdyAYYkD9Cr
X-Authority-Analysis: v=2.4 cv=RofI7SmK c=1 sm=1 tr=0 ts=692741c3 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=hSkVLCK3AAAA:8 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=yPCof4ZbAAAA:8
 a=MYHAFnyLvaJ7i5f1S8wA:9 a=CjuIK1q_8ugA:10 a=cQPPKAXgyycSBL8etih5:22
 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI2MDE0OCBTYWx0ZWRfXySOo1D6qTHex
 MKaVDjnOe/SguD3TQryYfvxh2gDrzoDcD4CGGcNBh8Luhk4Gu4BXag1uQY/annJ8GQNXW1WCCCH
 X/Tgz++poR5gBjgg1+JSO6d1nPXk22N5CPFd8p1SY2f0Cma2HkTusbCiV2jILbPV8yxclUdy0Ab
 xSRPp9KJezZej6E2pH1U1f2rS3UxB/5uxWDpDSWsNYVeXzniXfC3lxw89FpZ3sZYDEFmUPKZi4L
 +wlD5KSsfVGM3jEZEKkfXLrLnFF5csG5ZOyY+pvuMnu+g8qtxOT8I/7Vg6vLtqOUTmk41tzJall
 0zJLkBUI77BGCHlWZIhUvjASJlQKo/vLhZYeq2fjWjqfg5qJvclTqYLgGyDQRdmKtqzf5eBaIlX
 VJ1wE+943xhrtlzPRjDfAd/mQgWknw==
X-Rspamd-Queue-Id: B3230C0018
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: rg3sepxm9cbg1k7pm6m11qmtsen6wyhq
X-HE-Tag: 1764180433-229197
X-HE-Meta: U2FsdGVkX1/KUAH/RhYcbkMCNr9fYX/g36NVTucWR39yC6D3/AlR1JINml8sQmsFXd1Dosabu/Oy78AE8cnFFmqx/Q5lOydIpCGsZhkAA4u+uXXFvsjelZjbZCHwyirqqTa/OBEUJcKXfxPeWLRGWxP4Bjg9QWcncsPInpb+2kH7y1dLv3lulIBw0DA6YzLKj/ez4/Qg3iQbjBNhHaSpfoMHVCj/boeme+PjVpWG6GjWcEkNuZBplt4zib5DwyibThKxz8e6cV6Ak555V1sLDhXVs1961n2gvYwTIxbNSuM/Ade4EEVkQzgZX3KL/G1g+QDIFd/dZ7F3+UeKMKM1PIg0s4mPPoQjnLteBOz8BP3LaiN/aK2MacNiKTCId9gyZ0q72uzOic3k0ifWe7PZQOTVQuN3JyBkw1Fnjk7s1I07PE2t+74wUtoq/QVxiSKWG2AkpOjkwkbZkhCsJfUiz5t6MJZjmCiJFmga2efKZa65LIuODi70LllQ/H3sfB8Wvwb0slxssaNr3Gd9lMbsn8sGV5CkCmbgEYYoE6WRyGXzlr1B5Zt0e08RST9Ghly0fSKiv5TJWLFT23AWg5T7as6jleDXNwxSyF8TC5RUv5m6KejqoYlyIwScIPLrGodHC4R3fLJQz1F6AdYjfnJstJ3E0guvS1jhwb5sPx0cqX5Lqxvjsr+36YGC0ILpEuhEHZZZgFCL/0MRLGRj4NTlZmCpOjclBwIJGT/d9LnJgH5JsY8mWp6CLxjsPej7raDSoPpjfmd2bOLJjA6WRjiqGbwIx1dHLXZWxYfsYDajUXeET4zMm5GJ9Eqc3V2wjg7vzWt9VZ68QzFoFU0IPHA+0jE6poJumReCwNF2XdSdzGa56OYto/L9iwwryIzZ5tir82jdmHLYsYAl6EJkCsbDa6/oxilYrehNXbau6tzOWuD0OF2zhu1linBok7c8waSD70ek36lE8UruWxR+j8O
 xDUv9XP2
 dTQHfe1I6UtscqzOb2pvB8uDFFHbG80+nGLCT75+7e3KHCI+GwNRXDxgZ/Qa+dxHrxK5cmBkt+V0pB4vsJvRygd4dWccy3ZWDQ353TPm379r+BveHRKwfV99AMEOfbBdCEg/y+V1MBQRnRQTGflTbBx0vak6qt6W+1RxpICyuz5TRUcmVgFhvVF+KPDcW8XxaS/LGBZG0cDPtZIq+zWiaXU1uhFMY3sRPZgCLDB5XHLS6I7kRWAmkBU1cdALGQL/Vb3MtKE3a9gFJ17H2gzm+XyAt1iUex/UnxLRChnYug4MTQ7UNbEkP+WQlOdpKOUpU2nhD1p6ZDG8KRfQo3NXrxfJkgP0LTO4ILxRtwOlF+Nv0JVJyZH0EvFANdMAuIjuEQM6t69mwmDEkM8i4AtRYyHHX+jGdmF9BDUf8pUku3v4Jng8WXWzTYpDMKKaJ1ndNL8Ypb4fDrgwsn+akf0jA/yNeEToyFZ7MOtcDjqqipd4ETfIi9C2jEpYgJgVvGQ9CoRslbCGYo3Fapdt8eRX1WAanMFLsRja6hDq6W7pCtkGotzYl8Cl/xk2ZATXo8BM9/GLE9adU/0Ovtdf4NsqVvMxySI04iyrJ4XbIZ+4M0Su8D3pCvHTDUGOlPsoadMHhKSQVQHh1N3dptYMvbV+O4dYiUwpF1b/I1XxfWuPrbe5u3vk7EmVdiSFOXlTJ9x+aGpxZStXaaq4+3iQV6bwozJNvcdGLHmwOJkkyV4bkrAWEW+UtMfM1oT/alsiWB2bXgnEbCmavXnB2gdWQBiWLWxvBhfnwfCUzcPrXgK35mvkp9d7V/ke66R16CqdKFdNdpGWOrs9yhBYtIJ9CeDWbtUKM3pA+/C+KI9MY/sZ0+RwewtTJQjusC+6Ij12fVLATtxSzheBof1R9sCVIX8qnl6xGPwJT0lrw8lDoclvFR64gmN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 26, 2025 at 05:44:58PM +0000, Matthew Wilcox (Oracle) wrote:
> If we get a signal, we need to restore the vm_refcnt.  We don't think
> that the refcount can actually be decremented to zero here as it
> requires the VMA to be detached, and the vma_mark_detached() uses
> TASK_UNINTERRUPTIBLE.  However, that's a bit subtle, so handle it
> as if the refcount was zero at the start of this function.
>
> Reported-by: syzbot+5b19bad23ac7f44bf8b8@syzkaller.appspotmail.com
> Fixes: 2197bb60f890 ("mm: add vma_start_write_killable()")
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/mmap_lock.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index e6e5570d1ec7..3c9bf2f96280 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -74,6 +74,14 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  		   refcount_read(&vma->vm_refcnt) == tgt_refcnt,
>  		   state);
>  	if (err) {
> +		if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcnt)) {

Really think we should WARN_ON_ONCE() as Vlasta suggested.

It's an 'impossible' situation so we should make that clear. And we should
find out about it if the impossible happens... :)

> +			/*
> +			 * We got a fatal signal, but the last reader went
> +			 * away as well.  Resolve the race in favour of

This is very subtle, I don't think this really explains this clearly
enough.

Maybe put something like:

	/* Couldn't wait on readers probably due to a fatal signal, so unlock. */

Before the refcount_sub_and_test()

And:

	/* Shouldn't be possible - VMA entirely detached, so treat it as such. */

Before err = 0?

> +			 * the vma being detached.
> +			 */
> +			err = 0;

< pre-existing issue >

As discussed off-list, this name is horrible.

It's a value that returns 1 if attached and now locked, 0 if detached, or an
error code if the RCU waiter fails.

It's not an error code and this actually tripped me up reading this code.

We can address it elsewhere however.


> +		}
>  		rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  		return err;
>  	}
> --
> 2.47.2
>
>

Thanks, Lorenzo

