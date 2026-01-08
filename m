Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A4FD1D47F
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 16:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 249CD6B0005; Thu,  8 Jan 2026 11:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200236B0088; Thu,  8 Jan 2026 11:07:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4D66B0089; Thu,  8 Jan 2026 11:07:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E74536B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 11:07:23 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C08A56EB4
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:07:23 +0000 (UTC)
X-FDA: 84309276366.30.B46CFD6
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id 25D851A0008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 16:07:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="HCjmg/50";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZRZlqBxc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767888440; a=rsa-sha256;
	cv=pass;
	b=1Yw1tWuaGwUwVlRIuEKorGT/AxReDBLcpwG2xfqvv3ri0J0nypJKGJBxXuar6q/TA7849B
	nYgIXhQvGgcxPixwuhL+q/D0sehFTXQh2T9lU4SJb7XN+ajFSjCMqFW07pxcWabWw3og6y
	sKueR8Fe46/4xKiUCMyl+p/DXY0fB2U=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="HCjmg/50";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZRZlqBxc;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf19.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767888440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LQcJr9uMKNDv9T3TpolsnL4aClJGNdhK7SChGlhJ0oc=;
	b=MZlbbyq1CHa2nNnzi/2FBNtcCM4sPHr/qn0TVO2BTrZsviurpXn/7xEXcKyJtshweVLxsn
	jrq3hPuJGkixfJPpQlXjaaL8JeapWYF6DWFLAtU3dviddlLsv89T78Z0MaUNqMQGF9LJ+x
	0ZneDF/D9M+GjlfrHjwDkS0kLJ5HbLk=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 608E9uYG284757;
	Thu, 8 Jan 2026 16:01:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=LQcJr9uMKNDv9T3Tpo
	lsnL4aClJGNdhK7SChGlhJ0oc=; b=HCjmg/50vyp0FT1jb80mbEIZ6/t68E84fb
	qr2jfkjNvYGe5ykQITEz+EFvtfOCoptU9Kkqz1pU2Z4HYi6RlsHX8zrEYM4BWMy+
	dCycZqxGnbAEU2EZMlXb/XWinKJ49kNT9WDgMYet7m69yqyjonZblwGZSFkbdLf0
	nMUkQ210h8SeBTLcnpJ1LoTDcYCsrB8skxJhRcRmj1V8YawpepvFxt0TgyqLHSwm
	/mocBtFE2LJsbYNZxwBUId7k/BOetnw5utM2JTSLOZWNV72/KTxPVazgm7Yxb72e
	dmWG+ffRKOrzpPZpze84fg4pdA34aZDMTHpUvzfpetkRrw78obRw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bje3vg5t3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 16:01:46 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 608EsgWf008662;
	Thu, 8 Jan 2026 16:01:45 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011064.outbound.protection.outlook.com [52.101.52.64])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besjb84uq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 08 Jan 2026 16:01:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nXwR8er83C+1UdyY/IpMAKjGNC/wo2FwoyIEg0N/YLp8v5ne0MrFzNbauPlmN5aCPOMrQzoYeVJRrGssAYLCqlMa8duTUatTnqVWdaz9CEK3cAzDTzevnZnwAq9oCym6ZkLe4bKsTIMhj3u989n5OziuZx33Da902aAt6pTOPv+lEKlkiP4senRh8itrqetjuHyrGeDbvDpKMjWcuK0j52GzeDGDp430jA6QUMuWe03zBNc28eh9206Gr3wgSuA+K3jGArhWtf0wwtKP1BRclu7iCvMS8IIqWKZNFs/zyWROjiKNHSlYerU5/RSbgUA5WjCrOi1QZ258yA15fd3kbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LQcJr9uMKNDv9T3TpolsnL4aClJGNdhK7SChGlhJ0oc=;
 b=F5azI3aqsDTFZkQCHa5xDyIKDUiVxqus/vQpzG4nt0eRaBy6O11nrcIT5D/9zEX0s+kSOKxeALl9wbKJmQrZx6gbWdPGZtSVkSavYFnPrkyWVtV39zfuDywGy2iXC39jYRPPD+LzTPQDT0nSZ/osIFT/gpJ2ttSZGRV4NAOpqhLJE+xb7h4m931G0jNu071SXhjuRygBtN1bmTjf7msJ2CirCZgyhiEOiKd5VpCWFqyW5NR3mkAT0joHxunF13idGcmQaIieUWyUK00syIusq6IiwOa/hRUesaD1TMPk3oalxirYmmkrGVAJM17QfvGlXn9DijqmSDh4jl9Wf6kv5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LQcJr9uMKNDv9T3TpolsnL4aClJGNdhK7SChGlhJ0oc=;
 b=ZRZlqBxc5C9Pqk0QO7T+XVU/ZDJ2fayGUsv7+vwergj+1iOdohbJAn+Fkblu/ejUr/9mpmDovMhwMew0oNx8/1qsbnjGCcgtrpwnORY9Urgq+9X1E7NZj2yvwpVjqG/v8A63pj+Za7UH/GeUgWgmm3IqBWyw9gGFoddQ7PbeWb0=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA3PR10MB8539.namprd10.prod.outlook.com (2603:10b6:208:580::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.4; Thu, 8 Jan
 2026 16:01:38 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9499.002; Thu, 8 Jan 2026
 16:01:38 +0000
Date: Thu, 8 Jan 2026 16:01:41 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
        ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
        ryan.roberts@arm.com, dev.jain@arm.com, corbet@lwn.net,
        rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
        baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
        wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
        sunnanyong@huawei.com, vishal.moola@gmail.com,
        thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
        kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
        anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
        will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
        cl@gentwo.org, jglisse@google.com, surenb@google.com,
        zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
        mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
        richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz,
        rppt@kernel.org, jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v13 mm-new 05/16] khugepaged: introduce is_mthp_order
 helper
Message-ID: <e01ef904-38b1-4c3b-8bad-cebdb4d0117c@lucifer.local>
References: <20251201174627.23295-1-npache@redhat.com>
 <20251201174627.23295-6-npache@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201174627.23295-6-npache@redhat.com>
X-ClientProxiedBy: LO2P265CA0507.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:13b::14) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA3PR10MB8539:EE_
X-MS-Office365-Filtering-Correlation-Id: 38912392-da2f-4485-4109-08de4ecf34e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|7416014|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HIC+LT0nHt26bRvVzIeS3qszHDiboMKIJfZYLr0ABx/sX87nTXjrOZJjOKpD?=
 =?us-ascii?Q?sFaYslQUUSW8YQbMRFUNiWXS2raQ3lcSs4M9Bl0yYkHSHRcr3f2JAgWuNcar?=
 =?us-ascii?Q?3rtJpozHunOBdFcCqiE7J/qEZUfSeWe9jqdxVpcHv2pxFnDcQQP1mAEZ4YYF?=
 =?us-ascii?Q?gc4CMayWCvD6hqRr21c8H57zYlXKUTPmE+p0XozdpTKw/fFQMD3nRKSRTSSz?=
 =?us-ascii?Q?TkX3KwmGAQ4W9O81TWcgH9Fe/B74HAcLT4e7dYczQJYIw+vBZP4D49AuLn+e?=
 =?us-ascii?Q?7sHNj7/Fb8BUnkQwUL1MDtDDx1CoIqAdJaV+hFjeOgZ5OgM1gtdUQU1woWGW?=
 =?us-ascii?Q?+WvpuRImRJqniha/0DcgZ0RkTota14EIgsSku9cmp7BDy9AKbjjhx2IQkiwt?=
 =?us-ascii?Q?I4yEOqU4sjaBhFqHoMuCV+ychQto3PNRlkWpemWWD1XSu1H2eaUTs7e8s2XO?=
 =?us-ascii?Q?Cx/R/dsooD5NK2ruxy6Ero8+dEQVTnBBDgpOWGf4cfwbi5RG30Ex26b3PD/f?=
 =?us-ascii?Q?ELCWqd6qsOOq0iEIrJFM7EM3t2WmWAQ9AZt1kUBD5qBOoGVoDM6TfAYbr1Gj?=
 =?us-ascii?Q?pLXCJHSlSS3Nyd/St8yrrqTCd6gBPkSTUIfo8GEK6T/aXP3uSYtR4oWp+WZj?=
 =?us-ascii?Q?llI8h+udxMHPrD7pYoZDGozbaGals5CWlg69m3L7jy7RzhLiqYOh93Jdhkba?=
 =?us-ascii?Q?+ibW/PKwww5L7eU9Xe/zACM2BFKyhclc3NyD7GQ+BOy1ku7DGlaplL7oA8+m?=
 =?us-ascii?Q?NaAyDCmXGlnSCZuqDP4xGAY7C4J8a54w7E7CmeWRZGXZ05O7SPLBNbS7JyyE?=
 =?us-ascii?Q?tNA9PpPWf9WJ7LaxxbqxTqvtnrRASN0FYqMxJYjHpw14DFU+iV5l6SyNIpmP?=
 =?us-ascii?Q?j7Z9haA1avVOd16ykUEZQ0ixONQkt58lk4YLoMmWbMl6q96OSQwGTo6zEjho?=
 =?us-ascii?Q?Pxp/EWlbM59DuwQAHLfJXQGneFxBwn6+dxmv+1P0cuyVbw5PhJHwI5c56fcF?=
 =?us-ascii?Q?rMPHhOU/6MXvz+J/8ROFJHEpumQihpfVR3CGiIfcatuAYuJJqq/HZWceJMj6?=
 =?us-ascii?Q?M6qzzNn8w8ukP+B2ux9F59iVgl9mLg0qUhAaewQBojQQh8zjYla+VsArJF0f?=
 =?us-ascii?Q?aSbLyRuZ/RccE7S87jphjGZqa7zKpNE+P/U5J1l3TU5319h2Bh/vvWjM9Xiy?=
 =?us-ascii?Q?FNc6paGOer73r8SKuP8SXDq/prsmzq+myOyT1X0c91Fk7s3X6leLz8vvUKCm?=
 =?us-ascii?Q?PYl4xDFRtRFckkmuyRKW0EQdzTiGYxIf6gMPP8hF2lkEY3CdVMgKFYaZjHVM?=
 =?us-ascii?Q?73D9YuCibRdxpNu2IdXSEabBa1yaaj8M7BWNkqnKVsgPZGnsAtZFP5rM/2mu?=
 =?us-ascii?Q?hr0X1quaQ2YZO0+zzZ4EmxB311OuS5eFcBjqN5qE6NINOBr8eOgf9LpcSg3h?=
 =?us-ascii?Q?TZu0pws+WjaFVT/mE27VQiUo+FOMy9va?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?FfpA+Bw+fTunllrAsspyj/J181mXx1KO6OO5Z2qs998ie5vC8ah0lw0b33qi?=
 =?us-ascii?Q?wY/id6eGl7E82yqU3BDLNC9ub+8PS31dds3HLiVV3yPkaeqcaEy3YRQYYD50?=
 =?us-ascii?Q?+B438pAActNjbTpps0XvIYVRkfXtTDCn05YA6c8lXt0TGKQ0dLw9Ba9JLy+S?=
 =?us-ascii?Q?vl04Dj4nBZ0zsolvCgXCRsSx7K+TcN/b9BhjNlCJQjdBdhaBHFUYx+TxoITr?=
 =?us-ascii?Q?QzdPjL7fKp+ETnKFmnoXzjlEVKV0Su7U+MiTWKekbFn/B4zWKeH5gE0toGlt?=
 =?us-ascii?Q?A2pfLOtS8RuwxdDnPwHkTiU5D0c7A8qP9m5Yl4ODM7BCDE1ZWExdCU3DWroj?=
 =?us-ascii?Q?A/ifK9550UR6J5xebg9P4jYJEHj8FhgEbtedBWFbhHrOdh1h+8Ec/vZjGpw4?=
 =?us-ascii?Q?RTlpwsqRPAzE7olHA60V7FID5rbBkGXKhOTvwonS/07ed/l7kJTqZrKMFw6e?=
 =?us-ascii?Q?BZFZmyzniLnhLM19Ig3jfbfGZiss8NE8Jzvv4QnsRs9DN1N1UX4xmiUFBDCE?=
 =?us-ascii?Q?kiptXYOsL7I6OFIbUGLJNXJb2anNpa2ap8AIjlg9HvOMtjOnoF+PwfMyNHRG?=
 =?us-ascii?Q?VzoagEr9xuPIca4OKhMrcB/YDB9vxvjqTdPDQ44GeyAZ080hzzPwFsxi1hDL?=
 =?us-ascii?Q?1tw75PoDwo7qK9Ei2/Qg3OZ6v2LuvEC13Fi9kfONkf3aU75BrYgg5+j8k+N2?=
 =?us-ascii?Q?sbWMD+M0z2QxH3fw62nrf64IeVEO8RDykl55lD2zHvTgWPbTKVXi9WkbYCI4?=
 =?us-ascii?Q?WhzIyiaOGOcwkz9Oq2K8YRHKTVsBdaWR2mte/cZf+bRnMRP5ZVrenmgoGbNe?=
 =?us-ascii?Q?oJAhcPV+UF9rJLVrTFyaurgT5rqMHb91oQR6eXaa4xATPUzhuurQhxKy5C06?=
 =?us-ascii?Q?EXEFCOTYbQnzOlWF3O4UZwLbYXkaxQdULM9/cRP5ql6XhagiEoQxoV1lbbBF?=
 =?us-ascii?Q?MIy/wBhNaweH4pdCMstGtj3YFcPhAcQFWiYjNW/elCTx3bO9RPh0ICZOjDBR?=
 =?us-ascii?Q?qiZDsFQKLdlMxrLxICkJdrqX2rHKGr1nmZgVJ/J9GEJTw+owP+CRfp8e0D1V?=
 =?us-ascii?Q?W9c5lZSI1TB5BI9D9ZY7Udj8smVwmnjvxFV4i2qnkjVQttBMQSXoVH2kBED1?=
 =?us-ascii?Q?90MKqg5A/d+SbBiXXcsJ1SfYNp8TtEf2UC1se9kIISZu3i8go0imksGRw+Ib?=
 =?us-ascii?Q?MlkYZNErrMJ9FivaTh7/KF5wJTwoi0rQHwkRV4U5Le9VWWxzwhtAhXrBEwAL?=
 =?us-ascii?Q?925nUVyFUhugoYC/rxaXYGeBaD+UF9wRodkOg8iHCT8JpftUyrrM4RQ5a0Bg?=
 =?us-ascii?Q?YlHArRNPEcj7oc09iuB5ctbpK7fJYAC01zJO0yAgqsSwlIhnwLUCvnmRC9yM?=
 =?us-ascii?Q?FcghMg8pqvPqiWEctFq1dM2YBU0fyBR8rmO6+oZzHrOsW0HbXKH9K2KInE2D?=
 =?us-ascii?Q?Q5m8+jlndfWKOIT5kkI4I6T7XiFqRxEy0aFajR2kdX9P/CizfBHHgRj57a3v?=
 =?us-ascii?Q?P+YZ03wZM5sPV+PIU8Ap+qyUXbfMW5KOF1ocuo7UNCtliVpIL2luBP9yC/nw?=
 =?us-ascii?Q?nGBZ8BERG3CHxqBeYipf/XpLqNQv8gB92gntEuizcRc8rNrT0y6RbWpGnGqa?=
 =?us-ascii?Q?9FYYgdKdSmd/3Kva8sbuIbHaWtmJhG5BUPtkZUsu7/RlMD6yFcGHeRpTaoCz?=
 =?us-ascii?Q?/xj8clch5iuNzIMOlrGfC7kcYEUXwT40AisqawHnZzklExe8ht6YnV074w0I?=
 =?us-ascii?Q?ziTwNLHh2+YfuE+DyGVSvrkseqeB+IQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Jzo0zNcktMGQRlOHNrTTmnMnE0TB8lNm1C/6sNg/+4NHNyn+WSmW61UKbWS08XdVdwO2+0fjO98YVrgfFZkrEi6li3D29OEpkMy1J/5vMdIdB7SBApgmAKDAziMyzFjVbCrQlOWxLPJwrTBptpm5u/puF27V3ukKRjF92UiTW6YzbZzBRvDVKBS4JhmtBwC1+aJF6uk4yCYv0U3cAlXR+11RZ6p1Ay1Ye4d8Opv4dIM1567BPjTn42nn6o/ifRhk3B7EVxxDiRL4kvhQ07uToFbNorTWd8G5WQFtPhe3q1MyF1CbwwuutD7oLcUhXrWAuYwMs8rrJrTEUzisB/0j4d0KLnr7mQ7+g9A4vVYswLLsurlVjGHqsf7HZyoDTFm3HliZFuTiW7s+Y9DRZyuLT+4IvyTpgQcMV3TvlHZNFGIFxAgWEFT3Py5SgufwL/3XpdRw0js2r5K8nLKRZ1HFIihmsCqssbeo45gLTbgDFE3nnnguC87cLeYhANyS7kmPwY40JqvvrNcnTlOownl5udyk64wmrUhRWn33qrJCr+F0o//p1Oa+/n2rADbDRLcrSY0VXZ7uVi/80stPprEkk1wNnEfGuvqCClInpUsxLPM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38912392-da2f-4485-4109-08de4ecf34e1
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2026 16:01:38.7527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nzY5WTKdWAC6CF6ySLNv1wPnCXFH4FVoGRSUd35BSvuwrdCVPIzfzGGcvDCemsMqt2QGK1txtuAchZpHGcFVd2xDi1XPJUoe7NX1v0efuRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8539
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-08_03,2026-01-08_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2512120000 definitions=main-2601080117
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA4MDExNyBTYWx0ZWRfX9iNGmj1D4ckM
 8c8D/F19y4y6LeZWS55/TWJu0DqOrjoOw440rCV/1fRdVeF3PeRMPS9sy61BG655szxlowdM3J0
 ZZoiTUKr2y2GyNhH6soL4C2nzI5qmwXNXqAkXJwGE5UjmfhHFokiRxkrBQwsP9KzrBXipftBLwR
 SIRn3+bwdm42w3I+gDzK5AjQWFqJB6FmeTk9kPYJeXNbkOa8c4copt1zhGk8XZEHdZM1VivIbme
 RA5kgmurNDdt2sTjzSkTiH+FFNGIpVUoBvZpCoNYbu1Tqs8gwKSlR17tqqd3isRhitfsQ2K9mLK
 uZkY1XcUI0xOc5WgCoh38D/ovTS6XVTU9G/y8YZYWAzo3+6C/KsdP8zJlkf/2mLUFcwdd5yQ75r
 2lnbUWWqal5biSdF+yA1MM09s/lrH516LoZOOhKQbbK+/l5w2xwuTQzq3JP70yr5B21k9mcYnor
 2Rm1qKyb5zQOTHq9q2Q==
X-Authority-Analysis: v=2.4 cv=fe+gCkQF c=1 sm=1 tr=0 ts=695fd4ea b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=20KFwNOVAAAA:8 a=YfLgxWDG23JpKDAEbGMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: odtV31I391oEQU7pjPg3uqpcArjFjDkQ
X-Proofpoint-GUID: odtV31I391oEQU7pjPg3uqpcArjFjDkQ
X-Rspam-User: 
X-Stat-Signature: duay8uz5x9k7oig7pydosddci1sd75je
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 25D851A0008
X-HE-Tag: 1767888439-832558
X-HE-Meta: U2FsdGVkX19GPatNJlkAuQtEZo1mk2p+Ffk+hDPqRGGuwI4HsEEPTS9x/+psGhwiSS7vcpNSDQzV84BCzAZDtIL6GRPWd6xXyQaqjx4b02XOyqX7cAy4jdAmvrDHPknVVBHNdO3eaEZGlaf19FXT9YIBDUOabl1CrUleEdcumecBIqt4Hq8ERBb5pRcEsMwNSbrW6UaJX11/e1Z+HBrdGZUIJQn4wjzTkIrt+Tvdec34OixH5KXM0tfGcKQEDtMmdsPb2ozR0hUtfYR2llqYOkDjvIFs22i2NL3KR5rcbDbiXQy+EfOYiU27dOcgE3TVEFzSFaFvz5pKTxAoi4jtzfQAonsW6O+7R+oe9UuvyE/uX9CWcYlXPbwUI2Mveqhhye0/AzZVXcIqx3Nq7tReT6OvR3yRg3DS/ohEdsyc3NM6T3liKIgB7K27lCZiTgPI8cNNtveRjQaLMVPOMRrUmh7/a+/5ax3VzGTaU/wmIJAtU+qvLr5A+0SFi/X8+DDJkpoEq1k2JhE4kbLEL9Ej4L/xT9RLQVJ1ls4b2uorFr8r4AAJj2xFRnB5Y9b0cZbf5jvLUTRdAIXU9KAnUhbI7Rq5zOe4m/RpOvFdodxgRmp78/Pmo9UxdJ6/l4XxUXJnJpZlnOvOfrTp2qnMEfF9aVinu0NuVcit0X3DlT//tp4txA9rL8PyAVkbAbY8g9bICtvzmU45dJ3zizxo8jBkgMKTzIQa+I9FZfHCLyWVtwQG4VQkOHEkMyAB+hNS3rscDWTDlxe6KMGv7aHL+YNxVE/sOG4+yo7L7Rr5h9yrYQ6UdLDodEUPKavMFAmWGEFbl91AjdkJOYQCjZ0dhgZXXgiLURDkrmVCmn1x/gTy9k3ho8XJ4y0+pDNWGoM1uQVj21jZGd7ZkMVdJJHcbYq0LEL6KYM++HF3BTL0OzubWvGitcnaIb8aODvinHI8QjsjMry56xVGFbtkJrPQ7K5
 3g6ALdhd
 dsluJttFI6AUKAjqHzkrbGl1nApbAs/Mtg/PBLcQ6OQByLZ3CpiIxl+73W1+YgU/G3AmLvcTwHU9Ji4/7rR267VUVAPJ1AEgd3Irm7e23cJQC/uina4cG/B/r1pHJWtvB/Wx51a/+7roMMDF9Da9gHJJoph9AbcG1iGO9FJrGaJAhJ4/vPZ0ZXIGAbwoVhzpohUoQI1MzpHDnpCt313NN1DYvjOlJZO7Li7ILE8rSvzRiR5wjxpTfPT3DIGxM+QX0fbADxJaAAd9NhZt80ANWzjeahoYXhx8xPUv8sTEk1Qnt0TaLSVW3VtT9oh13mx0FQdKjKvS5EFyenBjZ5v4CvtlajJwqFz0RV8a09aAznxStr3dC/OPMHOSd5lLa1ziV/Zi5XZliJAcB65iJkgIvdeG3EVwPq2+93J0DdnRCgvUB7CZqUQe+lRqxGcZqCaqgeWVJpo2Ztu6r/6d4418zBXGpFyvJuNqL4fyQdO7kF9FKDsFVzSirHKqgipdi3T3ps6pHWdF8JVIdePgKFZc11Bq/9KAoCOgZE+uvjM9frgYBz9e78/YHC5KiRlq3pvEirhnV40cpqgAFh8S2nGLGty1Xs3PnsEBrSHLGbTe4yjLIUpPBUUYL4gZtfCOmr7pHwY2koJRWCNZ+x32plAcbvVkV9bd+D0PFWurnlWCKHqjKZ4vI8WQxNk1BE4SCNieejjp5mZhFoiU0V+ZVRn0PB69libjI6Dd7FPug4j317WxYYdR5wHdgoJ+KyLCJcRDmOZw+cw0sAfX/12Rgb2+gdNWCbhJFBKow1kWr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 10:46:16AM -0700, Nico Pache wrote:
> In order to add mTHP support, we will often be checking if a given order
> is a mTHP or PMD order. Lets create a simple helper function to keep the
> code clean and readable.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Notwithstanding what Zi said re: using elsewhere (please do :), LGTM so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/khugepaged.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8599c7fa112e..9c041141b2e3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -338,6 +338,11 @@ static bool pte_none_or_zero(pte_t pte)
>  	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
>  }
>
> +static bool is_mthp_order(unsigned int order)
> +{
> +	return order != HPAGE_PMD_ORDER;
> +}
> +
>  int hugepage_madvise(struct vm_area_struct *vma,
>  		     vm_flags_t *vm_flags, int advice)
>  {
> @@ -1071,13 +1076,13 @@ static int alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
>  	folio = __folio_alloc(gfp, order, node, &cc->alloc_nmask);
>  	if (!folio) {
>  		*foliop = NULL;
> -		if (order == HPAGE_PMD_ORDER)
> +		if (!is_mthp_order(order))
>  			count_vm_event(THP_COLLAPSE_ALLOC_FAILED);
>  		count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC_FAILED);
>  		return SCAN_ALLOC_HUGE_PAGE_FAIL;
>  	}
>
> -	if (order == HPAGE_PMD_ORDER)
> +	if (!is_mthp_order(order))
>  		count_vm_event(THP_COLLAPSE_ALLOC);
>  	count_mthp_stat(order, MTHP_STAT_COLLAPSE_ALLOC);
>
> --
> 2.51.1
>

