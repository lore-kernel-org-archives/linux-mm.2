Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2783CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:39:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63216900078; Wed, 13 Aug 2025 09:39:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E282900044; Wed, 13 Aug 2025 09:39:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AAC5900078; Wed, 13 Aug 2025 09:39:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37065900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:39:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E78B45883C
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:39:29 +0000 (UTC)
X-FDA: 83771841258.02.A12C724
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8F4064000D
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:39:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LS253VEX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wMQd8Iwg;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1755092366; a=rsa-sha256;
	cv=pass;
	b=5AiNX/jfGDieIymZ+6Wkzh6JDTywxoUuJ+I9Us3+Pdt5GBVfGooDZFYluhJmDrRS8umX3B
	xtk+zpv8Ud+vIXDIGg2YcwROmYeDFWH+XZgTtU/j64bka0sX5Ci+EnGTMDvUYacpyY1FFv
	1o2IwJ6qn8p521a1PB4kc6cjR4NgQ0E=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=LS253VEX;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wMQd8Iwg;
	spf=pass (imf11.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1UuZ7KxfqxqOMu2byINrQu2EY16zw3bxaxwX/3i5LjY=;
	b=xiWVd56SwuelMyaTqHSObDuDIOccfBJmH2fo15JLtZj5B1IeuOijK8J8eSUOTO1TPQAxLT
	n+/5jeH2EM3R0OmntHZjgzmwle6XPdHXeQxToabjzjQL9U6rYdqYKJjABQUnbI5RBmu+zi
	Bi3LFDxiRlcQusrv8oi8lQ9pkJVskY4=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57DDNBdM023013;
	Wed, 13 Aug 2025 13:38:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=1UuZ7KxfqxqOMu2byI
	NrQu2EY16zw3bxaxwX/3i5LjY=; b=LS253VEXOckOlJLaoOc99/cJTM2MBs+OHS
	q7NJHrM35Cz/d24rwHVba/56rSfQywjcdlIbaHkUVkH6//tbp9TxeHOwhOPlny+A
	Uc1Yln92XToS8bir1TL6k7ngthlWaaMAwzmKb4UImS7KbaMajKW7Jnh70EV43MRE
	ehxGB70XMYxb7Gj0bNBwxTtFQMB3qiGZhM496iFIlT/L71dTzzd39SmMCIha3DIk
	ifGtqLpnB6uyglPH/jyyKh7eFISED1ik3DITSBSd+04hLNGONzGJMjg0NNUtefAg
	+3hP4lviyFGFhyYFwJKdCoaQBVGjxDtlel9XkLO8FYAZ84A5SvMA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dvrfygs0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 13:38:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57DCXnlo017390;
	Wed, 13 Aug 2025 13:38:57 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012067.outbound.protection.outlook.com [40.107.209.67])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsbdtg9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 Aug 2025 13:38:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=R0EQSv8YoPlGvrScodgXSfZMpSqbVlJ8xrTVCYWKZvYmOtxA2XV51fJPXZTdi+e38ZpwWKLtEMbiq6K/uV2B5prxoEqU0Az9gcMWgZRG3+UFcnXlLlCd0QxbHT9PUcwJMNzLdkyC54z0TFc9wtAynLVUeiR/Kp27B2+vuv15YaQRRUXY0aLJOAhhUDUz1Lv8x1O5efh4HQ8/D0xoSUdN38lVHtCTUpQrciyHnQdMhY05dag7OLB5Kig9HBV8Yx5oY35Tc8vazHYrYnFpeLVlcp1NJirkXI9PMD4+kIieY6r/ilrGM/HoXF7wTFpqh4tfJUDEiBvmT0oJ4yPDLbbLmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1UuZ7KxfqxqOMu2byINrQu2EY16zw3bxaxwX/3i5LjY=;
 b=pYK/W3eTW32nB7vTzRidmodC8lH7Y5MO1V+YRYwV2efVyS04/Nwy3RN9kZyF5Ql5JLorOTiUpTBs6iBKe+k/p+KUy76do9UVOZ4JJ85cfqeuDxfT6DXz2fdGXX6N8L5dy5Hg/dZdIkz6PuJXfyKb5HcdngIFhAFkXYR8KAMxdDJv0jUXQfH6mpiC5lmuxRcREte00CFNq2KNrIGo1q9CALm8yRFxtRIVeeZEo5D2bBuXxRwQdIFZB2NKZTxoQUFvpAxhDTNaBlapfbF+9yhFSa0vKhaYRgQVoeV8Yn98rZXQLn843HpdLvnrldNllKnbbwWE0NN+8o0TI5AbqAzRZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1UuZ7KxfqxqOMu2byINrQu2EY16zw3bxaxwX/3i5LjY=;
 b=wMQd8Iwg07Q1yUQgghYU/7NNa6M4bgjwcPL8jsVfZ7hh7pcom/BWZ8idLfcsovS2grzLZxt7NwPpJ3PNTUHBCZna7h8MQ79Pdm/8Qwuoz0wLtjUscsfsMiP+JN1IU7Jieezenm83T5AE8IPLBO8cQYrFwQkOG+6IOHFl1Of8qhU=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS7PR10MB5200.namprd10.prod.outlook.com (2603:10b6:5:3a6::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.15; Wed, 13 Aug
 2025 13:38:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9031.012; Wed, 13 Aug 2025
 13:38:54 +0000
Date: Wed, 13 Aug 2025 14:38:47 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, david@redhat.com,
        vbabka@suse.cz, peterx@redhat.com, jannh@google.com,
        hannes@cmpxchg.org, mhocko@kernel.org, paulmck@kernel.org,
        shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org,
        josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net,
        willy@infradead.org, osalvador@suse.de, andrii@kernel.org,
        ryan.roberts@arm.com, christophe.leroy@csgroup.eu,
        tjmercier@google.com, kaleshsingh@google.com, aha310510@gmail.com,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v4 1/3] selftests/proc: test PROCMAP_QUERY ioctl while
 vma is concurrently modified
Message-ID: <7d3b4b0c-f905-4622-95a8-e4d076dc71d4@lucifer.local>
References: <20250808152850.2580887-1-surenb@google.com>
 <20250808152850.2580887-2-surenb@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250808152850.2580887-2-surenb@google.com>
X-ClientProxiedBy: LO4P123CA0117.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:192::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS7PR10MB5200:EE_
X-MS-Office365-Filtering-Correlation-Id: 7050e0c5-5077-46a2-fe78-08ddda6ebecf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1dpE/JjXyC37w1jjCXWMbf7HE8KGreMz6hWXMgvtGFTTcnzcSu920CqXJX/J?=
 =?us-ascii?Q?MAeoC+MQ6V/JBdm8d1DCABnhCy2u/6v6LqKeSj0XrCHSK0P0brOB8nuVETrg?=
 =?us-ascii?Q?6X10v4u/8lOXsNnkRFcQLYQQoYAREPn+qR2lf58zA2U2e1F/xPaaKOREGMSd?=
 =?us-ascii?Q?jySGZVzEPKYkbE0Um4qycyk1sOqTRK7ygH1BtDS150eGbpmRv5jxMS+xSfmg?=
 =?us-ascii?Q?To2See5knuNL9p8xxPzh1RxXHSPdUV4aNW4QROqQ6xnOtQn+XhAsyFUmyPGn?=
 =?us-ascii?Q?xyeQFUSeAncCY5PSe8gktngvtv4qOoyGNq6bucmv8kGMdBe/AuqgcQ3ZOpzK?=
 =?us-ascii?Q?354Zaqs1XQ9t3CGlQ0UcaAD35B7IvMprJGik46mK8S8qqrxo8Rc2pgDuoUUm?=
 =?us-ascii?Q?f7zkLsBMKUNYrg7ncY7FLh76kVyHheD2snj6zhKJK0FEeoskYFvbf18iYJtF?=
 =?us-ascii?Q?prnwcKOtCCju8VKQrloS+W6pxqnlLAJf6nUcKJig+PnbY/6nS1QmezahP/X2?=
 =?us-ascii?Q?Nk4KRS4aygcDhHkocj5zSYcYAwHETjq9h2riQ6d/w193swjRfpWX7FHlO+Pq?=
 =?us-ascii?Q?6JX4X76GGNMdh/QsdarNfw4XQFF5rZlRX5O+2YUvnyZInGlQesnganPppCeN?=
 =?us-ascii?Q?ilv8+F5qIVprQtQGIWe8RceFyyE/WPdjY1raudmu98TiQrTxFZy/6R7VwH0e?=
 =?us-ascii?Q?QqKyK4EFAODeu84ySPkGVLAN3Un6r1UQveXFqnSJSptpfNObIg/MMqbnePWt?=
 =?us-ascii?Q?svkE/EnOirLyFNWt3cToQPKtyB3hSEHhXuarWfUZN5elNbSdW3J7Uz+m9kpP?=
 =?us-ascii?Q?boQBwP1BJDgmDmDWNHZqBPNb8gXJ3dl1HpRE/k7sprSOTfIoaHpEGG7e5EMp?=
 =?us-ascii?Q?AbIYq25/Y5e3OnusfftAwkLrPhTjpB6iMu9zwf29VSbi/C3e2BIFeYulm95b?=
 =?us-ascii?Q?BwgXzhwGnfSQW2XBgR1GEKbW1TKz7goU4iLDkLUoRV6wyMY5FQ9Oj3+xJGd3?=
 =?us-ascii?Q?lXlQ14A9mjCmOR2hCLDKKQ1fByGMHxkkTBXHMvqJwVsesWV3zNIl7GExwMKI?=
 =?us-ascii?Q?GsUGfAwkDz5mFHkDOvyKKNm46QS7bA8EnMUTGoLIoTphRixK6QnBFKKjvlQS?=
 =?us-ascii?Q?hpB8hX3mCumxQ1yMuEV0PLFjDcW/hCBsp0Os8EaxvODYAiNr0KFaCchXNMD8?=
 =?us-ascii?Q?beP8c1q9jxnw91KZd/sAoZ2nrIBsE+DNTWz/b2xGwtabsf8k44wlFsc7A7qe?=
 =?us-ascii?Q?kIe+3JQF1xvzPsySLYzk3cFUHcDvhAIlKWpAjhDGdfSNWDtyNiY0rskZ+Okq?=
 =?us-ascii?Q?8KiW5XF9teBGGvaJSUncFtpCkdQ6K4l1FDNgYHBSz8f6hv8KhmartFmfhJye?=
 =?us-ascii?Q?tad5MRq95Oy9ioxzkVNXOeFf+4CURErSFtnnywlsh2klgWERObRrFvDfpAks?=
 =?us-ascii?Q?mYdGhFycMwo=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8My9l9oqvw6G0fab8FMBgiViwbiwKYQfbXbnfRUhZCBgR3Eanzfa9Z0IZe/3?=
 =?us-ascii?Q?z7HEEDYFRCPw2yivrhfIjJFHfs87IR+d9Kz2WkiSUCVtuB8DNeaqSgNV63jr?=
 =?us-ascii?Q?neSc4i1LZtSFZvft5I+3cDku3srtbVZ66sO09s6A5NiyBtleP7n3am6lHmvs?=
 =?us-ascii?Q?unY9XF/bexI70S1vyvlvjW99kL6g82LVPqBavB9hFlwwQmXsmbmt8O1TJ8Ph?=
 =?us-ascii?Q?6DaZ8LQgQWIrO7eBw2GOT+5dpWaXDsMOIAx52KvkFp7FOJLI5SJWWhwcv8++?=
 =?us-ascii?Q?O2MCI/pimXGvkpaiClWSilLfVhadV8Y57mDlZV79m8TI+nPeYFYrZLNwB5lh?=
 =?us-ascii?Q?Vf+ysid7R5+TASaAQzmvyjrteyN9taCQqUv7qCkFptoUnGoMWhFEG7iss3wv?=
 =?us-ascii?Q?nfqKmuFJWViZf4uhz9yF1zr9xCemDr7VG7+9+falPExVdQr/To5R1IkguaGg?=
 =?us-ascii?Q?f4pWXUb0Q2aRzXXX0MwmaFpJMElIaEpS83OcJdgDlQLLnHWbks9OrpkRl+Ey?=
 =?us-ascii?Q?fpj/G/a6XIC1zZgjx4pdzISGBmcSfU+InUcr8rcpsAeiV/jxkYKhz0bZtWkP?=
 =?us-ascii?Q?VMDwRDJugCEoXVEguo6WPnreVZkzqptQlO4+A6k1SWhrOqvkfRE70rHVAJSe?=
 =?us-ascii?Q?hfRlLpB2aUYmRVUHQqUJtYe9Ed1gVDScy2BF38BWAPt69MQPLOxxPgEo5SE5?=
 =?us-ascii?Q?y7C+C+wRczNk6j0jC5u3w9vAXXCDQJgur7IdELLALBzmjRbIwe0+KSmeA4qe?=
 =?us-ascii?Q?sIO14vbjFD/E8uT2tx+3bgFr5kQLeyQa4VBaWR8jJuvMBD+QTjAeCiXwD5o+?=
 =?us-ascii?Q?kXh8/MrjxBQiuSOV19bYOhCut6ZzyLy/sN8hepA2FL0At1mhx5pg87R9H06q?=
 =?us-ascii?Q?F0TPDA1+UAC3LuGX5ljfTJg6RSecV5i6XQlFKFKSRmRBu/j9022yCT9am+zm?=
 =?us-ascii?Q?dmo3Y8v5FNo3qmcQ1EHZAtzDeU6WZd1MFnNINwRRqZN23CESrg+sNSx7DeOU?=
 =?us-ascii?Q?cJHdVvSQxwQHrKCEeWWwhvJp0ja9zVeXgOmK13uUemqOoD4l1HO7H+2VPVIR?=
 =?us-ascii?Q?sLa5bU6pAxD7dojO3+F0AXPVtjP+K1b8o1AF/ailDzr4YkN0SvTbt55fZrJO?=
 =?us-ascii?Q?jr7Dr9GtAYFt+0mwNsiU1PH1/k8oYTU6YPWy3U81q/xGslVx27tg81WEuJ8K?=
 =?us-ascii?Q?CiOe450TdQL6js8PINVDyiFMDrfq9Hp02vHaGyYt7/C8xxWX0xIiNuj3TdgD?=
 =?us-ascii?Q?9TTp46e73PYFtfu+Z5PsAdFhBrrEwMC1MrQ5GZCRCjl0jYas1WTlV3VDXI9w?=
 =?us-ascii?Q?6Bs1BvQhLtiRz3+/G1cJiSXVgm3dJFi1+Cl/p8U6of1zifsc8FLv82hbs5Yy?=
 =?us-ascii?Q?3LWSF6ZH2S7BkGiWDiLVOPBgOTS8Y1MSFlG/8PbSCp8TVPu8rlvIp129FsXb?=
 =?us-ascii?Q?O7lyhBlhppgEpc5YcMAz8MnTuMLbdwTQmfu1R1gGri8CCt6H7LH4gTcxwFst?=
 =?us-ascii?Q?n6xnHtMCxIZSIamBncpWSNAqsNfYMP1OD9w5kg3IGJOp5nPueDdmaslwad0N?=
 =?us-ascii?Q?Wp9+uQandhMVn2agXCfRKcsyGZ3/OOUI+YoMcREBrl1P3pinHxt1NGQe4xYa?=
 =?us-ascii?Q?IA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	o3zfsaWmvk4axLA9CjZqyzPUktxd7Yb96Kwu804+q/RSdtkR+NjeilOVcCZe82EF0CjnJBDosyJ3Mj2KssMliwNhtluysqawg86UYsEvI5cvZyySNvDTXnFDLJNkQyX6LymjwO6Bd7BJ8mc2FxL1RKwBjbi35BHYXe+z12nMfLfiQBEd198CVEFUrTwN4S7ehfCojVeu4+fmG1QO3yMoupRzCQvpGG8UMEJYleiitE0dAnuPMf34JTShXuXZx6INncRRWBgNoSgMRYOWO/27CwP1o9g3vcaHm+MbuhhRRmpSZgannhI0/Ma9Z4RGhPRIJgq1YEwcpn7RQvnN/2wrbEyPpSrMUyH0bsetEIyg97HZh2U67aQ+bucTLOY3avuc9FsBDGtWvIi6j+YU0cJh8L9Ciq5raRIWxCRA3onV4dGiR+oOKP4EySDFH8F0DIau5J87LRJkj6tgxv22bsPLevOB2bm01gHgsFf1hPNh3f3wXUaTdKGzXbNFPp2Vcpz9493oomGACQf9u1TuvynlZNbfKna4YhxzXVD5/Yf3zf5XY1d2r3ijEul3UvbwjbJ2fhW/3N1n/UBQ/YD+RWvJb9gTI/a2Re4DLx+5B4wp4YY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7050e0c5-5077-46a2-fe78-08ddda6ebecf
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2025 13:38:54.0037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aGlZtt4dHoorrLewUSjxcfGC7xe9Hwo5NvmvPEpbapD0PhN1qnrraDpWZYWfNuAX1nzta4hOMlsCHarjC9rqT5NLeIjrImkNBQBMQT1Ch6w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5200
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-13_01,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508130128
X-Authority-Analysis: v=2.4 cv=B/S50PtM c=1 sm=1 tr=0 ts=689c9572 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=-xGtGpdhqmp0rC1n79sA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: wnxQMEIqqHwTxAS96HyXhZ3zyxgJ1CrH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEzMDEyOCBTYWx0ZWRfX/xDIp63dKCL6
 2g32WYAC1pqFpPUl06NYTYD0xiCXTew0vQi70HmuTYnLKEciCOI3u0sngWh1y0CBu+28NZGhU+O
 hFVlqbS+BzG0hM6XvH7+/jiwuUGFoFzIVXCoe2EX1IxxDGkc3mErNwkDrK9856cNIzeAWK41Rbn
 rOXFWm9bddeB/ZKTNG9nvNPpewIR30pmpF3yiQod0jWgaY+aMw6oV71riJAqWWrvArawJoVunV3
 IF6KNKQ9stPgc1b4PtXLhFZktkOOe5kuL8eS78kziBoV+8+nIlCHd05P4DpkPAWCrb+2+v31g0U
 Qr438F2AmNKxPxApbogNDMsYMk7FzgPNHf56imWUwTfrHELr5ANwwtysHwZ+bSR91zc08MIiYH7
 e9Nbxcctfxly46IxBgnViSbcxxZPOpxnYZlhQzeuQUdtUuN9P6Q8i2fsCMslrAB37kynB1Z1
X-Proofpoint-GUID: wnxQMEIqqHwTxAS96HyXhZ3zyxgJ1CrH
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8F4064000D
X-Stat-Signature: 3t7oiiaczg777gp5uqxoogu1awgzq8rj
X-Rspam-User: 
X-HE-Tag: 1755092366-889230
X-HE-Meta: U2FsdGVkX1+UFjyvNnnHyRranO09EVy8Vr5KILLM3Qan3nyhlp8bg3SCN0GIvZI4AHVD7IUrbGOKx/G+HB29+VUxcQNWjp8wphVC58J2r2o5L+7EGug19267ebaZ21DdKwbjEuTMfdC8xlmt1229LHguPDbtEsOvIPwB+svAec6GRDl+plKturclmY/jCC86HC+licW2EJk7GAKcXBi4Mlugmgi4OVO7Q1p/Aj4r8tSQ/Dj3mNzUREho+2so9tmwa5GcH24t44OaT5kr3r5Z9e1GeNIwx1kQhZpvQ1S2vHlCNySrKEccWgE4UKvacSp9sXGcDq8XlFFFNzheLxkyV60oQoBmVWGw1dQoUtLhynTeWo2nJ0jy7MjIFlfRZyh73WbYdu0GKaSaN9+0bMEa975feZl1zrT/9Y3jO88QUftdE14LllZ7kpzIxeiquvq9obXPU2kebXAHBpeP0M5lVyQVjDylYQ1qgxftDJLZu6Qlf4Bti317eNbYS3br+fgYTA5JJ5aLRgNAbmyw5xh7Rdp6a47qhgnUeh6QLj2vJ//3ANlJJBMvrb9VeuO6nFFcULqDvjyfLm0KEm4ymp34QJD7/lRuKbS/1wujCKGimWCOg7qHWXpETo484tpLAV/q2JTP877OnBpTZK90KO7FOuYliObq3gDiUiMiKUdVC2+MomGLDr8O/Qi5f8N+EHdf3htCNhmZ8VLIqYm/DU9Pan6T8cCPVpl7ZoBATIYIEtM5OWvNAR93dZk9nnWHXq1mjhkUDCo34lwjVBi7PuwkFVuubbc1fe8BisLJLRs4km0MDE/23Gg8mQ5ZuQFf6YVd5E9plvYkYqxCsOhBt6ZoBlhBKxV4lmd7KNQwqjbulXt+DrUGRSMBYmoqnjIyWS2PeHzCKeVlF14XVfOyhUky4Ty3+PLSK9rysYLzgNvkOCUrxMQicG3tiMVK6N4i44773Fvr+BaHutV1DT2lkNJ
 rKq043x2
 i3yFx07507cgZWll3t9UPF1xUGc/aliOs8uhw6tB8IKkkVWvC4HWmQr7DZ+tEOTh/hXo83VzImJmXjiqaT6mCvxMg9vgGzly1g6F88sHfl3L6wP+2blVz7lLscpLXd7p/wEox6PLbknBDWlwJRtRNskPgJo8NZ2NB4m5tHu/4m1ZyYjWAMa/5S9vU8m2jGOIo30Y2m7L9lhug/UcnEAo8ZkRtuMi//XZnIJCCkDHiDviER8fh2pdKyQqsSQd0hmJ/9c7l0sooyom1OX7NP6Ibplck45qaGI2nAynxhCu4Vwv4UhPJnBCAwC5sLT9t9TVfIRCdydUkqn2RTYnvdRYRsTJwEAVb/v7KqcC52SsyrxWCUBrRM6/IskYaOGwVLz4F9uuDDzzvF0lM+ho0eu6+Wy98R6Tmd3gTOHSJMjuNlGIUvCj5vG+zcnUO8JgGoTDCuhBQNa/56ddhvizSNfE4upSSfVYnMdTkRUebFX7PbW6dnfAQjs1t+3Og+4yY60aBYF/E22K3p1DS4hHuvTFlVHJoDc10OWGE+k+GeQbypjI2vy89+w95lfWJVGuyjt/YB35SU++R5Nolcf4s2zaxxpq9nGIDreOF2voTo4p7cLju6jaxLiBtESHkCH0qdSxr9q4zFONj+ToULnN8iks0BY17q7jbsfCdH+ZySik1lw3RHWaWA30vvYrlT5LxhVmz8yYz4mdLazjteztIMBka8oYmPAMwDU34h3m6EmT2k9jhJ91k0X0/yAN8tgSKRHIJ1HU0+V3hEopNPhXdc1sG3HrlAfp1Kmh7Qf8yW5KUK/ehDiJK/XfTePn9P2OWyS2XcmnlIxLg7e6Qg20=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 08, 2025 at 08:28:47AM -0700, Suren Baghdasaryan wrote:
> Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl operation
> correctness while the vma is being concurrently modified.
>

General comment, but I really feel like this stuff is mm-specific. Yes it uses
proc, but it's using it to check for mm functionality.

I mean I'd love for these to be in the mm self tests but I get obviously why
they're in the proc ones...

> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Tested-by: SeongJae Park <sj@kernel.org>
> Acked-by: SeongJae Park <sj@kernel.org>

The tests themselves look good, had a good look through. But I've given you
some nice ASCII diagrams to sprinkle liberally around :)

Anyway for tests themselves:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  tools/testing/selftests/proc/proc-maps-race.c | 65 +++++++++++++++++++
>  1 file changed, 65 insertions(+)
>
> diff --git a/tools/testing/selftests/proc/proc-maps-race.c b/tools/testing/selftests/proc/proc-maps-race.c
> index 94bba4553130..a546475db550 100644
> --- a/tools/testing/selftests/proc/proc-maps-race.c
> +++ b/tools/testing/selftests/proc/proc-maps-race.c
> @@ -32,6 +32,8 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <linux/fs.h>
> +#include <sys/ioctl.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <sys/types.h>
> @@ -317,6 +319,25 @@ static bool capture_mod_pattern(FIXTURE_DATA(proc_maps_race) *self,
>  	       strcmp(restored_first_line->text, self->first_line.text) == 0;
>  }
>
> +static bool query_addr_at(int maps_fd, void *addr,
> +			  unsigned long *vma_start, unsigned long *vma_end)
> +{
> +	struct procmap_query q;
> +
> +	memset(&q, 0, sizeof(q));
> +	q.size = sizeof(q);
> +	/* Find the VMA at the split address */
> +	q.query_addr = (unsigned long long)addr;
> +	q.query_flags = 0;
> +	if (ioctl(maps_fd, PROCMAP_QUERY, &q))
> +		return false;
> +
> +	*vma_start = q.vma_start;
> +	*vma_end = q.vma_end;
> +
> +	return true;
> +}
> +
>  static inline bool split_vma(FIXTURE_DATA(proc_maps_race) *self)
>  {
>  	return mmap(self->mod_info->addr, self->page_size, self->mod_info->prot | PROT_EXEC,
> @@ -559,6 +580,8 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
>  	do {
>  		bool last_line_changed;
>  		bool first_line_changed;
> +		unsigned long vma_start;
> +		unsigned long vma_end;
>
>  		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
>
> @@ -595,6 +618,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_split)
>  		first_line_changed = strcmp(new_first_line.text, self->first_line.text) != 0;
>  		ASSERT_EQ(last_line_changed, first_line_changed);
>
> +		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */

Typo ioclt -> ioctl.

I think a little misleading, we're just testing whether we find a VMA at
mod_info->addr + self->page_size.


> +		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
> +					  &vma_start, &vma_end));
> +		/*
> +		 * The vma at the split address can be either the same as
> +		 * original one (if read before the split) or the same as the
> +		 * first line in the second page (if read after the split).
> +		 */
> +		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
> +			     vma_end == self->last_line.end_addr) ||
> +			    (vma_start == split_first_line.start_addr &&
> +			     vma_end == split_first_line.end_addr));
> +

So I'd make things clearer here with a comment like:

	We are mmap()'ing a distinct VMA over the start of a 3 page
	mapping, which will cause the first page to be unmapped, and we can
	observe two states:

                read
                  |
                  v
	|---------|------------------|
	|         |                  |
	|    A    |         B        | or:
	|         |                  |
	|---------|------------------|

                  |
                  v
	|----------------------------|
	|                            |
	|              A             |
	|                            |
	|----------------------------|

	If we see entries in /proc/$pid/maps it'll be:

	7fa86aa15000-7fa86aa16000 rw-p 00000000 00:00 0  (A)
	7fa86aa16000-7fa86aa18000 rw-p 00000000 00:00 0  (B)

	Or:

	7fa86aa15000-7fa86aa18000 rw-p 00000000 00:00 0  (A)

	So we assert that the reported range is equivalent to one of these.

Obviously you can mix this in where you feel it makes sense.

>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
>  	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> @@ -636,6 +672,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
>  	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
>  	start_test_loop(&start_ts, self->verbose);
>  	do {
> +		unsigned long vma_start;
> +		unsigned long vma_end;
> +
>  		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
>
>  		/* Check if we read vmas after shrinking it */
> @@ -662,6 +701,16 @@ TEST_F(proc_maps_race, test_maps_tearing_from_resize)
>  					"Expand result invalid", self));
>  		}
>
> +		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> +		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr, &vma_start, &vma_end));

Same comments as above.

> +		/*
> +		 * The vma should stay at the same address and have either the
> +		 * original size of 3 pages or 1 page if read after shrinking.
> +		 */
> +		ASSERT_TRUE(vma_start == self->last_line.start_addr &&
> +			    (vma_end - vma_start == self->page_size * 3 ||
> +			     vma_end - vma_start == self->page_size));


So I'd make things clearer here with a comment like:

	We are shrinking and expanding a VMA from 1 page to 3 pages:

       read
        |
        v
	|---------|
	|         |
	|    A    |
	|         |
	|---------|

        |
        v
	|----------------------------|
	|                            |
	|              A             |
	|                            |
	|----------------------------|

	If we see entries in /proc/$pid/maps it'll be:

	7fa86aa15000-7fa86aa16000 rw-p 00000000 00:00 0  (A)

	Or:

	7fa86aa15000-7fa86aa18000 rw-p 00000000 00:00 0  (A)

	So we assert that the reported range is equivalent to one of these.


> +
>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
>  	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> @@ -703,6 +752,9 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
>  	clock_gettime(CLOCK_MONOTONIC_COARSE, &start_ts);
>  	start_test_loop(&start_ts, self->verbose);
>  	do {
> +		unsigned long vma_start;
> +		unsigned long vma_end;
> +
>  		ASSERT_TRUE(read_boundary_lines(self, &new_last_line, &new_first_line));
>
>  		/* Check if we read vmas after remapping it */
> @@ -729,6 +781,19 @@ TEST_F(proc_maps_race, test_maps_tearing_from_remap)
>  					"Remap restore result invalid", self));
>  		}
>
> +		/* Check if PROCMAP_QUERY ioclt() finds the right VMA */
> +		ASSERT_TRUE(query_addr_at(self->maps_fd, mod_info->addr + self->page_size,
> +					  &vma_start, &vma_end));

Same comments as above.


> +		/*
> +		 * The vma should either stay at the same address and have the
> +		 * original size of 3 pages or we should find the remapped vma
> +		 * at the remap destination address with size of 1 page.
> +		 */
> +		ASSERT_TRUE((vma_start == self->last_line.start_addr &&
> +			     vma_end - vma_start == self->page_size * 3) ||
> +			    (vma_start == self->last_line.start_addr + self->page_size &&
> +			     vma_end - vma_start == self->page_size));
> +

Again be good to have more explanation here, similar comments to abov.

	We are mremap()'ing the last page of the next VMA (B) into the
	midle of the current one (A) (using MREMAP_DONTUNMAP leaving the
	last page of the original VMA zapped but in place:

      read
        |
        v             R/W                            R/O
	|----------------------------| |------------------.---------|
	|                            | |                  .         |
	|              A             | |              B   .         |
	|                            | |                  .         |
	|----------------------------| |------------------.---------|

	This will unmap the middle of A, splitting it in two, before
	placing a copy of B there (Which has different prot bits than A):

        |
	v   R/W       R/O      R/W                   R/O
	|---------|---------|--------| |----------------------------|
	|         |         |        | |                            |
	|    A1   |    B2   |   A2   | |              B             |
	|         |         |        | |                            |
	|---------|---------|--------| |----------------------------|

	But then we 'patch' B2 back to R/W prot bits, causing B2 to get
	merged:

	|
	v             R/W                            R/O
	|----------------------------| |----------------------------|
	|                            | |                            |
	|              A             | |              B             |
	|                            | |                            |
	|----------------------------| |----------------------------|

	If we see entries in /proc/$pid/maps it'll be:

	7fa86aa15000-7fa86aa18000 rw-p 00000000 00:00 0  (A)
	7fa86aa19000-7fa86aa20000 r--p 00000000 00:00 0  (B)

	Or:

	7fa86aa15000-7fa86aa16000 rw-p 00000000 00:00 0  (A1)
	7fa86aa16000-7fa86aa17000 r--p 00000000 00:00 0  (B2)
	7fa86aa17000-7fa86aa18000 rw-p 00000000 00:00 0  (A3)
	7fa86aa19000-7fa86aa20000 r--p 00000000 00:00 0  (B)

	We are always examining the first line, so we simply assert that
	this remains in place and we observe 1 page or 3 pages.

>  		clock_gettime(CLOCK_MONOTONIC_COARSE, &end_ts);
>  		end_test_iteration(&end_ts, self->verbose);
>  	} while (end_ts.tv_sec - start_ts.tv_sec < self->duration_sec);
> --
> 2.50.1.703.g449372360f-goog
>

