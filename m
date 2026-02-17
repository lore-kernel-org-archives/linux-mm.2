Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED0E8E9A022
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 17:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5309A6B0088; Tue, 17 Feb 2026 12:31:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0B06B0089; Tue, 17 Feb 2026 12:31:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2376B008A; Tue, 17 Feb 2026 12:31:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 271816B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 12:31:00 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B19DA1C16F
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:30:59 +0000 (UTC)
X-FDA: 84454639038.27.345DB41
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EA6F140003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 17:30:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MaUYS8j8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="UahB/adk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771349456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySHi1JCktjOAm6LTf6g1tYdi3mQfszggFy4igCMQsQU=;
	b=ICf1Yoa/DSchwH7m6EURm+o6YHLhDkFws7CHySsUKkPzIsClwi3l/Fvqcos8onyuGRY2Nx
	7Bj5srsrfUKzGUHCZbtblxKSeEW0Bu4oXHKJY9z2JYVEWbxZcXuuoewruIRmIM2fqUfHj6
	4asJBOvVBkSWL0rFNWbCJFAua6+BFmw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771349456; a=rsa-sha256;
	cv=pass;
	b=jN2mu6N3xUSBiuXxssUoKKMULP39/dMOjFSJdyxEylAshar/v9Em7jYVxalNtjlul1s9zw
	fYmbenUZ5vSSa0AS33alBndbqL9GxXc+Jsasdc6d7lLzpN6qgpuw6Alkq8n35ljjgeApEJ
	jJbD6R+I4otyWilDTK/dbbLezbF613U=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=MaUYS8j8;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="UahB/adk";
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HGNOck495371;
	Tue, 17 Feb 2026 17:30:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ySHi1JCktjOAm6LTf6
	g1tYdi3mQfszggFy4igCMQsQU=; b=MaUYS8j8HhyfyjEcCEg01IY6hSCahhZlsm
	4wJmeopagXiyVCfZD0UHcnV3f/iB9GAgy+9nLckUAC+gW7dgAOwVPv3zicLGqdgi
	VrgQrSEueyn8u4LaRAOf6ohuCNqX0yqU7AfwHBFkQoMl6bzHrCmW3SLIx5FNeDZv
	H9UuIntwJaUBo+aJWqTC0tAC06mRai04KjRw4o5CfyJQRBgEapj2Ehi7WczVRBb4
	tfWlUE/mMmG1Cq+ISa+wUyb+avZWufuZdQpwOgtG+Uk1T6PETb/Gkyk7MtiWJ1k0
	+zV8Htj2N+eUfVzrNDZRrWXc7UD2MkLljULPFeBs01/QnCqu70CQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4caj6mc1bv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 17:30:49 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61HGDpuI005406;
	Tue, 17 Feb 2026 17:30:48 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011047.outbound.protection.outlook.com [40.93.194.47])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ccb22sfu7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 17:30:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=poaeNgNqd36e5NfTDcsDBem395BKwXR8CunJRM4w7AAflngjgFFWPZTasL5lCAc6rrF2ukvPeIFq4obVrKz0ds5Wg6WgaFaILznJMiElnHYhKBtx28qp3na6W32bR8j6dXyBlN+aVPbAp15A5F/FV347ES+jhY3HBO9aF4rGZ7t9xQONQheytHGZPL6nd9Vnk2wvYVklS3tBw9TuAESPlJgHCkInYd6gKVPtgUp3VJ4iVViyjYMf0NswewCMwLqf/Ymt3S6KJkyfJMA97xC+ga09IHDT2M36ZJaVQtpViKK6XrZMyAurzrRSz56zaY+xy+DOfc76WWMCiepoTGO14g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySHi1JCktjOAm6LTf6g1tYdi3mQfszggFy4igCMQsQU=;
 b=qmiQJ3FvKBLdYDb0tORZMNDSeeEZnYaMFfA51LXtNfPa/+XU5kGh3BmJX+a0tWk+a2DpBwqBnz5gyS8DfmR3ePEsHPV9ioWTt4fHvRqInB9pBpOVmeaCffOsXwjAL2ft4biGTxkfhg8zT15hh6BDARjba/GMAn/4c0S28r9ItZu1X9ynu/ufNRTHdNfTtIueEOf2oZvNkkYWpqxk7Z9cJPFlp/YUYe4Sc05i1DRHMBR+5zXvFUR44/g7j9+lY+wOqq39F9TU3XIUL8UTzmYpqgkHebHZjiT3+yiRGgexlXOkjoSBrqIqNeZngQvnT8FutKMKNRYrq7Vk3Wx4vTStEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySHi1JCktjOAm6LTf6g1tYdi3mQfszggFy4igCMQsQU=;
 b=UahB/adkd93OPw+nGBsOHNaO85Vt4R9iaLpRPMgumuXaA+RyQjtqnRIyecS30CTeiOSmNuooGG7WJBzk1R2oAp8UOqrlMbV+9iWTHsRHbpCxrDs3evlqXBvQALB4sbNVQm/4eA+RBPWs84XpdJbnfmwbfUoqDikeFyzwgmqt4Zk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7397.namprd10.prod.outlook.com (2603:10b6:8:130::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Tue, 17 Feb
 2026 17:30:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9611.013; Tue, 17 Feb 2026
 17:30:36 +0000
Date: Tue, 17 Feb 2026 12:30:32 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
        syzbot <syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, baohua@kernel.org,
        baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com,
        ryan.roberts@arm.com, syzkaller-bugs@googlegroups.com, ziy@nvidia.com,
        Thomas Gleixner <tglx@kernel.org>
Subject: Re: [syzbot] [mm?] kernel BUG in __khugepaged_enter
Message-ID: <qboz5waz7u3bkxnmat4vjdi5z5o4b7xdwe2k4yqiw743mmsitr@ez5mhxy6wfp4>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	syzbot <syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com>, akpm@linux-foundation.org, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, npache@redhat.com, ryan.roberts@arm.com, 
	syzkaller-bugs@googlegroups.com, ziy@nvidia.com, Thomas Gleixner <tglx@kernel.org>
References: <6990a57d.050a0220.2757fb.0028.GAE@google.com>
 <5e95c945-dbd4-4714-afb0-9546b08ff561@kernel.org>
 <aaf78721-0bb0-40d5-9fdc-595942c66fd0@lucifer.local>
 <edc16404-2a70-41ae-9041-ca3c6b82749e@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <edc16404-2a70-41ae-9041-ca3c6b82749e@lucifer.local>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0356.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:fc::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7397:EE_
X-MS-Office365-Filtering-Correlation-Id: f04c8f72-be2f-4521-7b76-08de6e4a42d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?JIjnnjz0Dc4WfS+dtBiXYgckV6s5fBqhkQ1TMhIjUaSi6J6uHiRL8O5a9F2i?=
 =?us-ascii?Q?oYE8H3OxzrHhTEuiOrUFT+A740R2sPlYe+TaU7mt6XKHC021GictggsmUffZ?=
 =?us-ascii?Q?k7iQ8ViT67OPFMj7qik4UhDLM9Va4BOl+W55mXEy5NGMPyGwQbhF42/pkteb?=
 =?us-ascii?Q?DEh4iX7ym81hpRZ9aWpWNFDuXmafNyCN5YxkLekFgqgS40Jr+xa2cd0mkS7u?=
 =?us-ascii?Q?OSd0q6vRRTfPCuEe1SSvKX0z+cE8kUoZwuPC8EDPKrsGon6Ttbofq0V8Fuoq?=
 =?us-ascii?Q?JTHuOurrv+m00/+vDcSLIYYHzVD6eqJLVqM05FtN3TaxY9yJP93ZxX3rIhUj?=
 =?us-ascii?Q?Q9R4Jo63DlAKtd2xyUxontAI7aEb6f++L2hDJ6vQSAmYbQjsvNm+vCtxR1Eq?=
 =?us-ascii?Q?BrvWTyXIzVfi2/I5LwxfBBKYbd73K7nofCwg1AJ8xxWtXOlkOEtZi2SYw6K0?=
 =?us-ascii?Q?+EVXzDqQ92AzJwv1FdknT/yILVpvGr4Z4Al9XG1re3zBOJ7sE4Oj06oENV+j?=
 =?us-ascii?Q?lGciqsovBn7W1TUk6Mmsvrh4CMN/IuLd3yF8rmfk+ddmRgyLdb31+3bFrP74?=
 =?us-ascii?Q?FCucdJtEccNlKUPJoMEKIumDI+iFC1M0YtH9mhoDe0Hkcmx/t0Cvy3c82vEJ?=
 =?us-ascii?Q?GawXrCMoIZ+pjQ4TH6P0H0Fa8ACW1XOvlKXxuyzFFNg9o9as6des2RocAJD6?=
 =?us-ascii?Q?NNjZJ3vSu04IXKYaPEU/l2USWcas59rbcBgGK1h92Aqzqz2HowqfZYKnGLbM?=
 =?us-ascii?Q?JbHbhGnpVKtmb8jFJbMSasR64/PD7Of9EOB+7NbvYHTC/mUZroQMDstjj913?=
 =?us-ascii?Q?uM5WjufjAQObar9SRieqCsYKsojxbsh0EwueuT4qePuBRVL5ZWTEPrT5H/aX?=
 =?us-ascii?Q?SRThfvnT10Bis9tF3EvqEoskpb2oQwcvRN9JxDF7aIRumEXmPDlUi64Shofc?=
 =?us-ascii?Q?6xpJ1RzUsWLZNfcKQdFZ8f9ZY3Pb89xmfNqc7VIeDGCPg2eSOldbwlhvx5/z?=
 =?us-ascii?Q?z59E4CQVkAJ1D3UgLrSyOhDeqTFuPuYLEXuMQqmb8cULbe5pY/hXpUjoCNgN?=
 =?us-ascii?Q?QEfPI/BTGU/anjLV9ZrCdBqH78kNloMaXcg7Z+MT2qZwYJFLkz60yypCUPbb?=
 =?us-ascii?Q?DDWL7z5i29Wk6Q1L4SzX547LGzJY69kh/srl0AUKYlGixqDvtVmR2JKjcCYy?=
 =?us-ascii?Q?vdb4jPgn9bC35PVY75Nl6LbuG2kOm8LEISbeNsA1NBc+W+EtxPyfAoNSg/FK?=
 =?us-ascii?Q?wVAAFrPD95mRITrBScPTt//O7QiVBX9K16OObORwGMTP8y+Gws/6C8L9ehSi?=
 =?us-ascii?Q?kwXrahWvbpFhtiaqJVf1bVfk9OvJf1D1d9SQfKQU8By3Hu5cdHryPyJ0575r?=
 =?us-ascii?Q?yAZ1VYAkXPXbW/cLTqwNgznmJ2T5wgJ4+WBddbmaWk6+XvZJwnXovNoInXWL?=
 =?us-ascii?Q?AGLANeULXkycLAxbVIRFgQrQaKnsgQVILEDCvVsvzEiEZm360quxr+/IvnSF?=
 =?us-ascii?Q?wiNqTRIBymZmpBP72PlOk2G7XKWIG3tmYec9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?/rZP+0aGk9Byl+rPZzrBhP1Z3B+6EyBtita0SBr7FdkvLYItR/PMcHjwmjfA?=
 =?us-ascii?Q?Av5M9gmvfO6iyiYlZIDxd5lKuS4LbrHI2kjxBToKmkxthH0zKOnQv1shdZ7j?=
 =?us-ascii?Q?CKXEjq6ZIeLa0qGu3TaZfXsMXKT8dgxJb4UyjS3PKSdTa+9FGtSEoAofSOPh?=
 =?us-ascii?Q?MuwHyq0enaDqom3vVb/6VKxBSJgdXIcEL3tpnU/wQzP3Z6+0jkZjgaFnD/Ua?=
 =?us-ascii?Q?LNGija5pr1ihu0yZZCYJHHgh4klh8ph70Nm8pWqUi7tdYCQGgAdIoqfS8Vl8?=
 =?us-ascii?Q?tFCZmz1So4i0DHw3/nDwHJaCktsuW1izTLTI0DbWIgKk47A6+F1XpxiAwkNZ?=
 =?us-ascii?Q?Gay2edvHSzFHq/m8KakaTiRAF8Cq5XMXllAzulUORFMiiJ7HzI5XAQWxMxhP?=
 =?us-ascii?Q?5mYOSin70Hw27G68v6ayhMolPr+3tceB8xhLeuN5330lfhn2bsOM8uH7iorI?=
 =?us-ascii?Q?5ItU/xLwQ18GaDwlrjnNHXRb1EKXlDOVI/HH7WMZDCqHYpRDYeXIfhPqBM8u?=
 =?us-ascii?Q?wNfCqHPLjOSYiuh7r3IdY4wu2d1sAWg9GUpnJ0oF5m6IrUSmA6F57hBLMlas?=
 =?us-ascii?Q?F8J0MkQTCkxk2Zj59xN4MVxjK+5ktxYK2URKSO7NxtkFLiBzPBvt/seIaLhO?=
 =?us-ascii?Q?u0e4jyhVK1suSTVyWlKGCKEEbm8ouE9xqW6zqyLdgnNufZqFrY256t6qlOfW?=
 =?us-ascii?Q?LxQKTLX/YE1qKj/8BqWnuKwoMJHPa8FFoiE4V8eyi2iQ7hPh1tX7XvquGyGF?=
 =?us-ascii?Q?mMdZ2qSpVuc/w6eocxMMAB1+T+NkXEUYyWaKOoP+tx2dNgr2LU6X9yu3aG87?=
 =?us-ascii?Q?Zg0gbu9OVvFMaj9FfAqlApRkytZeeF9TCPFkp6h+toE6wdMnO1hc/hBNVtaN?=
 =?us-ascii?Q?xuKwXtYXxBMt1CDDdEOHtQSgCbNdz6G/zQrJiElPof4+bPSdYV+Ubv3e4xx4?=
 =?us-ascii?Q?SGjR4YjOildLqsn5/RE9pm/GPus+7bCNBarAgunFYN976ENrdnBbX1soJwls?=
 =?us-ascii?Q?md7ulvqb8jZj+u3ycLnThjspV2gF8rXSa82JFJH3Gf69kFZvinB7XeOl8oZx?=
 =?us-ascii?Q?ksVfZQiV4o90Xw1OAAkyXOfJIyc8aBI29TJtgq4smx9VjvzyF5+QeET+/nQe?=
 =?us-ascii?Q?WVUeSJ4ULZhe1ngK7Lnvb9ZdHvwgAEDyGiGSPUMfHuiWU+svcvDW47yvEOMN?=
 =?us-ascii?Q?9ekAGHDaTo1THVzP1DJ7QSSGvEDYwOl3aPYJM5cPCXRXLuz33waL89C2AM3V?=
 =?us-ascii?Q?v7pRlLMyw3TOptNOIXA8mv8ZELxw1e6N/ep6SIyUCtoXzDSVwLyskIeSsyT+?=
 =?us-ascii?Q?oblNcwgCMuR5tl3UGYToeTr18qn+VsXstLYKQn2rGwnNR8Qsd1a3PZhOEo19?=
 =?us-ascii?Q?LSfzvwt/+uLlYGBm9h1k4trzsJBINaLVxrX8qGptFhC9h/iWKE1iD9MxCtOi?=
 =?us-ascii?Q?WPdPgUuXJymucUilbxZV3aAljECQT1/N+s6R97ev9At10CgfUBGdNTJ0ymD4?=
 =?us-ascii?Q?p4NjRVCGX2P40UPPZns9zNz5CEIKYp5CHJ3o1E/2EP8FO++CSJTIHwj4jfA9?=
 =?us-ascii?Q?vimPOgDjlJGuZMF+o+mxwRnzCIbrxBCoRTCv5WSNo4hyNUio2JVbXbfC0Zht?=
 =?us-ascii?Q?xjvT+ywMRM1J1FnIrXswzd5Er+qoOsEVzdayCf+9UQf01+vlQA4Xl3Z2pvWr?=
 =?us-ascii?Q?Npk8IVJPs5cRG6YpuACbhGG8LVJ8YXO46uhagmN9GzVwIgMZj8JnwfMMZMsZ?=
 =?us-ascii?Q?Ic3yQJry4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Z7DN0lk+9zp63N/hkkKweINNiYZ8q+9lOBui/o/se741Z51C2Ct6QmyXsJg4ebkucPFxZpzdJCeVqCphYvHMQjTzR5iAEQH1RSJqITNAaVbNVjtSm/gO738ulmqWuwgBowVvUgtDTTBb5SkZ0l0/MZfY9/mawmkz+YF5goNoVBJKxBFurDE28aMCp0lN0C9jATTfJOehvbtxKZB4A1TDiMxL5bIGsm6X1VkCEBrC48i2LsM2kwK4OT4XXYwRyhkhSDFVEvUIANxuCDZZcakpyKdvSydRdO2w0th676uZc9MBx2cLGM45RK2k+hQ2PAutuoLXF3gNqnlh3bU9hcY1EaeWcCFStkH7wBprQyxmwLSD08AZoMKJ7QFVFMeu5z95B1hY6dMm1NrLW2H2b8xh+6lhnrJd6NvieT2TFsZkTaGbkcYyzPKHyGiNk71SkFdTwz06H2OAEWJ86GNGEcGKGXQgHQqG+khTcUcDUcj05S8m8LWkkfaqvSvmTGM3ant9k1vOZcN3gb/LVuJCdMS7iiVsfm6x2RK9tpltVMwTpM30/mvO+iBt2mEA3cvSNhwMSx99vFBcsYXz/MoD67e4bDLXMLU6JUF4bgRhYVzMZO0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f04c8f72-be2f-4521-7b76-08de6e4a42d2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2026 17:30:36.2341
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwEkObQxwI6qFtRHD5wLEKHlZbjt03uRvu7ATgZFpMJqyWeu+rpK3Ij8L4biid96uz1OlUsFVhgatW8se1FBTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7397
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_02,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 mlxscore=0
 malwarescore=0 spamscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602170142
X-Proofpoint-GUID: wSx01Stv2VNCQ419MCyy2TTZ421wX9Pb
X-Proofpoint-ORIG-GUID: wSx01Stv2VNCQ419MCyy2TTZ421wX9Pb
X-Authority-Analysis: v=2.4 cv=JO82csKb c=1 sm=1 tr=0 ts=6994a5c9 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=edf1wS77AAAA:8
 a=3g80flMcAAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=hSkVLCK3AAAA:8
 a=9AlV_SYZaXMV8Dt8pkMA:9 a=BhMdqm2Wqc4Q2JL7t0yJfBCtM/Y=:19 a=CjuIK1q_8ugA:10
 a=slFVYn995OdndYK6izCD:22 a=DcSpbTIhAlouE1Uv7lRv:22 a=3urWGuTZa-U-TZ_dHwj2:22
 a=cQPPKAXgyycSBL8etih5:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE0MiBTYWx0ZWRfXzx6P8ZoJSQVe
 ISyGBoiEcbftMm/MAp/siacvfDZiPNUkREHD4gslwr3QoF45g3EMI874Y/K3U+rVrPPJeEPrtHd
 LPQTuXKHTXZIafjECYy/Aje8Wl2ERAJEzsEGjBwi8RLaIXCPOUhiEld/MRhSG45vR6wNazA1jD5
 z7T5L58Oe1yFLMZkdFEO2KIzO9NI/5LN3IPKOcCrb4RISPWlu0UHrEueDziHAfFVGGLRI+FshHt
 kswEzuQWPgRek5Y22k/QYyRILnyra/NhYnruf+/zlWjRl87BEEnW3ZbXNtCnv9GQMtc/0LPwmJj
 DkK6lKM0X+WGhzMrLrqjzB+k6o34yPeWzgFL3UdLoYyaHYRwij8vec84YLkw9F8R3QoJPpdvknZ
 86eiKk8DwN5OfTOA1djDewiXl3FQlOPpTb8t3pBJw7HD+AfZczJQMW5lBsNLjWAOANf8ZrhGs4L
 t0NMt0meomNV6QqspoQ==
X-Rspamd-Server: rspam09
X-Stat-Signature: ihdkzr8jef7ju11q9usj6grgg631rbcr
X-Rspamd-Queue-Id: 1EA6F140003
X-Rspam-User: 
X-HE-Tag: 1771349455-590746
X-HE-Meta: U2FsdGVkX1/VpmzTojeCTIOOGhvMDuVvH/H9uOS+CCMH6oYu/Q5cXjp8T6hI0h2djaviPlWgCK4UBoxm2ENb6/qjLiJj3fZYrUOQta5s2B/qqca6EGlbBvLCdfAO25SyhKVHSSrO2OQ0wJldA4Ct3pqRfU1a39Ke4Q0siE1zbhZ9PnLD6BQdI+sA9L1agiQDPBuuC/fS1TideRd0q9A2OqrpbUTlZkNp1lgg6J6wMSLN0cT/KCBnoabUb2jxDo6P6KjRgrIHVtjYOzhA898YzgdfzkxrSpcXgZIrb+NuhNbVb+u9Ll1lXy89y7MSeJp7R/SUSMZczb5sEnuNUaQLTHUajB0piP5MgvxVIvJZfvhkbHJu16m1AK7F3dV03Td4byrwizE76M9Rwgsrq2yB4uNEufwtqtrdAgWVGt6ixG7hkNG0zpwbwb1OW5XEUsLUFmnL6p8EcyVgd7hhiPVGfn7Pt8QbH6JlKRQvPNOfIK7KDSmdWXecDlF8bvjBwS8zLbpfVxfmLXKr+HuhQqXZW4XpmbpPvWLR6GW0uMnCdQ+gkcTFsKMXT66hTtjYVKGgQ/B2ZOY4fMnYvs8FF18SVc5eZQ8IJRkhOxN2apxKk6GFcvdpNeI3CifEQuSC+ku2jbyRnD9S3xxUAMK9aDNQjg7r27gL/4jQ9SaPPq4s1dtDooFGkmbieJvyKDSNmsLSut2432ylsqttB1088ovlN2+T4pD8Sgt0OlCMAGUJ3ymSDAbB4VJciDdOmhGJ70GagSxkX0NGyY45Y2+PPBOGbToPrtE/EShorIJesyipsMQiD0P4irchl6/EMXCUku20twyeWOCGkEPoT50i8UrXTHwrOg8YDAiStdPbZV0Q7KhO+3vrHTjhDazFlCHcdG/9XQdW/IS5KPgHdH6AtOVGw4/iA6SswlHCm1gRlP92av9+mVav3dnyxZsZjG67OtotrcrsT0iI1Y8MKNDnpCA
 gKvH731g
 xQUHF1P0A7CESMgbz60JtZP1duavVrfeXhPfgTxRq681CQyNTHZRg4NhSxjeSGrq2HjioSbSw7eJ/fSktHViUy3kjIH2mp8Dq190VfshgNy9NVlkQHSBF98cNh4+baPuoeomKydgV68fcFmoWGdMxCZGI8BNZzKS7HL0wRhdE0vp+ldpfuf6eBfvOZMMUgbs8rTpiVa3m+n86KUHQPXXv1fOn9qnKLiGLLEr/zJBelvyPJNzOmcK535E2fQ2jO4dQM618Q31HPXVj0T2Wq65O6QKaKwVie9HPKCqLa6a6cMXGmqp0TO8yBMDxQZVCnBMIUSi4EwHzGHYl0qE5DnTGYExbSyDS0b1ZTxzEN4CmVmjgsCGPkPAvOSxlrLUB9CCSTlRj7Cs6UU7hotm96F1bCEa7GdsQo+MuQ/WDQ4mQVEsOb5NeKJwidvEEkmo+SQwxPVfePGdMuqF2driLvbfzd25cJH4LOUhUlxqXyxeCWk6DVfK7W7In8YEk8ns7NV9EFv35ZuXUoqRzDYb2Falov1RO5snZy+Tzqe9cpBxpv90K52Is8AxJ3bHG42pxv814vcicujQOuQnCSxrvcVSad5JNy5w/gd67UuWMjAyYs8Lt99mCFi6UotfNyl1of1yBwRNCYNwZ9KevkiH3+hUV/VPQkNS94HZZCTtcAVyaVLGKhRtgQ0G1quaL8EuAFjAEvSP38EdeFMmuR4sLLtf3RS/fVSYH1Cb1KuXNSZyiiuZjUP07MU9W76jCeSYkIMcUTsOGzkE6RAWWzCzDcDykqaKpPx3DbqWrqPzIa1QT8U/Qg31Du/UzFH/bH6cpPP/OJXAzfZ0eLdDPwdL+8l5mwTbF0upcQHO6ehICKF/KLRvddxKZwhmdVj9q0rzXeia63UhoSAmvxADtSQ+7vVJFAr8WKz/aB3vZzAmaNpCOniem8Fq2Quv5yAnUg1slaOLyjjiK0i1dGeFhOp1CtVHKBUQv9LHh
 zIOX28Xj
 UMC7plgt+OBrTDqdV/07Pg7DAfuRm6BP5oMEoAFctOJyZ9HR4zxFseL0PdTCMa4R/eBki685986IDHR86jGETc/pmvnUDSUXES6JkG3MnTcwbn03UubxLWoKsQo47tRzCnjM/JIQH+EZL62lquDZwwVG7ltD8KaOIL5EHgADf8VNTK7Pdr+Xh3MTfjPYWcRYMlurvdDcSzy9bDDMxJgCF6s/ntLNGXkjZn6DCtw70fryAIBUBTYdg0W7Oy+v4RiG4F9f31pozMUZImNGDFx0kt/erxnpe9yc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [260216 11:08]:
> +cc Thomas in case the commit it's sat at is indicative, there does seem to be
> some weirdness with MMF_MULTIPROCESS processes (i.e. CLONE_VM but !CLONE_THREAD)
> resulting in possible memory corruption?
> 
> We kinda need a repro to be sure though I think...
> 
> On Mon, Feb 16, 2026 at 02:43:17PM +0000, Lorenzo Stoakes wrote:
> > On Mon, Feb 16, 2026 at 03:40:21PM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/14/26 17:40, syzbot wrote:
> > > > Hello,
> > > >
> > > > syzbot found the following issue on:
> > > >
> > > > HEAD commit:    1e83ccd5921a sched/mmcid: Don't assume CID is CPU owned on..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=1169dae6580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=54ae71b284dd0e13
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=6b554d491efbe066b701
> > > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > > >
> > > > Unfortunately, I don't have any reproducer for this issue yet.
> 
> We're going to need one I fear :)

Indeed.  No clear smoking gun.

> 
> > > >
> > > > Downloadable assets:
> > > > disk image: https://storage.googleapis.com/syzbot-assets/ed43f42e3ea1/disk-1e83ccd5.raw.xz
> > > > vmlinux: https://storage.googleapis.com/syzbot-assets/d8af54a32588/vmlinux-1e83ccd5.xz
> > > > kernel image: https://storage.googleapis.com/syzbot-assets/34e6a8cc1037/bzImage-1e83ccd5.xz
> > > >
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+6b554d491efbe066b701@syzkaller.appspotmail.com
> > > >
> > > > ------------[ cut here ]------------
> > > > kernel BUG at mm/khugepaged.c:438!
> > > > Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> > > > CPU: 0 UID: 0 PID: 16472 Comm: syz.3.2372 Tainted: G     U  W    L XTNJ syzkaller #0 PREEMPT(full)
> > > > Tainted: [U]=USER, [W]=WARN, [L]=SOFTLOCKUP, [X]=AUX, [T]=RANDSTRUCT, [N]=TEST, [J]=FWCTL
> > > > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/24/2026
> > > > RIP: 0010:__khugepaged_enter+0x30a/0x380 mm/khugepaged.c:438
> > > > Code: 64 7e 8e e8 a8 dc 66 ff e8 93 e6 8d ff 5b 5d 41 5c 41 5d 41 5e 41 5f e9 04 6c 04 09 e8 7f e6 8d ff 48 89 df e8 17 33 d9 ff 90 <0f> 0b 48 89 ef e8 dc 51 f8 ff e9 3b fd ff ff e8 f2 52 f8 ff e9 e1
> > > > RSP: 0018:ffffc9000e98fba8 EFLAGS: 00010292
> > > > RAX: 000000000000031f RBX: ffff888079b24980 RCX: 0000000000000000
> > > > RDX: 000000000000031f RSI: ffffffff81e5b2c9 RDI: fffff52001d31f1c
> > > > RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
> > > > R10: 0000000080000000 R11: 0000000000000001 R12: 0000000008100177
> > > > R13: ffff88804adf9510 R14: 0000000000000000 R15: 0000000000000000
> > > > FS:  00007f06093436c0(0000) GS:ffff8881245b1000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 00007fff341d3f52 CR3: 00000000319b0000 CR4: 00000000003526f0
> > > > Call Trace:
> > > >   <TASK>
> > > >   khugepaged_enter_vma mm/khugepaged.c:467 [inline]
> > > >   khugepaged_enter_vma+0x137/0x2c0 mm/khugepaged.c:461
> > > >   do_huge_pmd_anonymous_page+0x1c8/0x1c00 mm/huge_memory.c:1469
> > > >   create_huge_pmd mm/memory.c:6102 [inline]
> > > >   __handle_mm_fault+0x1e96/0x2b50 mm/memory.c:6376
> > > >   handle_mm_fault+0x36d/0xa20 mm/memory.c:6583
> > > >   do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1334
> 
> 	vma = lock_vma_under_rcu(mm, address);
> 	if (!vma)
> 		goto lock_mmap; <--- didn't jump there, so is a VMA lock.
> 
> 	if (unlikely(access_error(error_code, vma))) {
> 		bad_area_access_error(regs, error_code, address, NULL, vma);
> 		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
> 		return;
> 	}
> 	fault = handle_mm_fault(vma, address, flags | FAULT_FLAG_VMA_LOCK, regs); <-- here
> 
> > > >   handle_page_fault arch/x86/mm/fault.c:1474 [inline]
> > > >   exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1527
> > > >   asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> > >
> > > This is the VM_BUG_ON_MM(hpage_collapse_test_exit(mm), mm), which checks
> > >
> > > 	atomic_read(&mm->mm_users) == 0;
> 
> Yeah, and that just shouldn't be possible, so maybe memory corruption?

tglx had some changes to the mm_users account for cid stuff [1].

There is also a potential double mmput() fix [2].


> 
> The crash log indicates the system is tainted by softlock
> https://syzkaller.appspot.com/text?tag=CrashLog&x=1169dae6580000 so something's
> gone horribly wrong there...
> 
> (from crash log)
> [  696.104336][T16472] pgd ffff8880319b0000 mm_users 0 mm_count 2 pgtables_bytes 155648 map_count 32
> 
> VMA's still there so exit_mmap() hasn't run yet...
> 
> But hmm we injected a fault :)
> 
> [  696.293779][T16475] FAULT_INJECTION: forcing a failure.
> [  696.293779][T16475] name fail_page_alloc, interval 1, probability 0, space 0, times 0
> 
> [  696.332139][T16475]  dump_stack_lvl+0x100/0x190
> [  696.332164][T16475]  should_fail_ex.cold+0x5/0xa
> [  696.332178][T16475]  ? prepare_alloc_pages+0x16d/0x5f0
> [  696.332200][T16475]  should_fail_alloc_page+0xeb/0x140
> [  696.332219][T16475]  prepare_alloc_pages+0x1f0/0x5f0
> [  696.332241][T16475]  __alloc_frozen_pages_noprof+0x193/0x2410
> [  696.332258][T16475]  ? stack_trace_save+0x8e/0xc0
> [  696.332277][T16475]  ? __pfx_stack_trace_save+0x10/0x10
> [  696.332297][T16475]  ? stack_depot_save_flags+0x27/0x9d0
> [  696.332315][T16475]  ? __lock_acquire+0x4a5/0x2630
> [  696.332331][T16475]  ? kasan_save_stack+0x3f/0x50
> [  696.332346][T16475]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x10
> [  696.332360][T16475]  ? copy_time_ns+0xf6/0x800
> [  696.332379][T16475]  ? unshare_nsproxy_namespaces+0xc3/0x1f0
> [  696.332408][T16475]  ? __x64_sys_unshare+0x31/0x40
> [  696.332423][T16475]  ? do_syscall_64+0x106/0xf80
> [  696.332437][T16475]  ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
> [  696.332460][T16475]  ? __sanitizer_cov_trace_switch+0x54/0x90
> [  696.332480][T16475]  ? policy_nodemask+0xed/0x4f0
> [  696.332500][T16475]  alloc_pages_mpol+0x1fb/0x550
> [  696.332519][T16475]  ? __pfx_alloc_pages_mpol+0x10/0x10
> [  696.332542][T16475]  alloc_pages_noprof+0x131/0x390
> [  696.332560][T16475]  copy_time_ns+0x11a/0x800


There are a number of failures reported, all seem to be the same
injections.

...

> Perhaps this unshare is racing with something else?

Yeah, I cannot find a particular obvious bug either.

> 
> OTOH, we _already_ had mm_users = 0 at this point (as per mm dump) so. Probably
> something before got us into this state?

This may be a previous failure that was missed or expected?  Is the
syzbot a clean run or has a full terminal output?  The outputs seem to
indicate it's the 'last test run' but not the entire log..?

Could we have already failed via the previous fix [2]?  It's not in the
tree where this bug is being reported.

> 
> [  696.332664][T16475]  ? __pfx_ksys_unshare+0x10/0x10
> [  696.332679][T16475]  ? xfd_validate_state+0x129/0x190
> [  696.332702][T16475]  __x64_sys_unshare+0x31/0x40
> [  696.332717][T16475]  do_syscall_64+0x106/0xf80
> [  696.332730][T16475]  ? clear_bhb_loop+0x40/0x90
> [  696.332747][T16475]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Also from mm dump:
> 
> flags: 00000000,840007fd
> 
> MMF_TOPDOWN | MMF_MULTIPROCESS | (core dump flags)
> 
> No MMF_VM_HUGEPAGE...
> 
> MMF_MULTIPROCESS marks this as shared between processes, as set in
> copy_process() -> copy_oom_score_adj() which has a guard:
> 
> 	/* Skip if spawning a thread or using vfork */
> 	if ((clone_flags & (CLONE_VM | CLONE_THREAD | CLONE_VFORK)) != CLONE_VM)
> 		return;
> 
> Which grabs the mm in __set_oom_adj() which as per commit 44a70adec910 ("mm,
> oom_adj: make sure processes sharing mm have same view of oom_score_adj")
> suggests processes were cloned with CLONE_VM but not CLONE_SIGHAND (which
> presumably implies !CLONE_THREAD).
> 
> Anyway it's hard to know with a repro.
> 

Thanks,
Liam

[1] https://lore.kernel.org/all/20251119172549.832764634@linutronix.de/
[2] https://lore.kernel.org/all/20260210192738.3041609-1-andrii@kernel.org/

