Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3932E6BF39
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB386B009B; Fri, 30 Jan 2026 16:00:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7EB46B009D; Fri, 30 Jan 2026 16:00:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940096B009E; Fri, 30 Jan 2026 16:00:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77B356B009B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:47 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 26CF4160802
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:47 +0000 (UTC)
X-FDA: 84389849334.19.A8E635F
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id B417910000F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dPRFOODz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LzX+Qsln;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=;
	b=wYVNp5Vt9iC+Ej0a3x9KlcTLjUYEaclI+3k/NxjzQ1G/6mLyTuHF+COSC15qgKBiivVt0W
	IRogkMn9R7fEB8e6IncN237/Q0wHsP6Nrs9APL7BzVtrMwdoa1Q2JDC1KztbRWig7y/O/k
	Jy7LNSlYMiYSAb81VD2Bxf/k6aAStnc=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=dPRFOODz;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=LzX+Qsln;
	spf=pass (imf14.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806843; a=rsa-sha256;
	cv=pass;
	b=bd/f+SGkMfCKt0lcPbsuHXsAPXciSwiuPdtdvVPS6yUON+jVddqizk2aooOm8GyjXZU4HE
	OfkS+5goMxdmmPJegqOt/XZHwep7qILtl21V8fWqxtc/oeHtQPYTtyOSrR6//CC6v9PkPu
	0Uomkzcmq2KrkXeapgHryPVnvCmQbWc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDRnT3910790;
	Fri, 30 Jan 2026 21:00:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=; b=
	dPRFOODzWTq+fUfSfcKjP20tGaLnMx0m1BMzS2tYiWMIt6zBFI+I/FsEMoEooGDJ
	G2GtN7XW6B99n6fnM76XR/mP4K9ZbD7MjKu5sBV/SBpA+eRd/0ehp/WU4EOIw5Pb
	Mthlq3gVGG99oqcvBmYtm31+JqopygeiSg2CVTYwZo7rlxp0WnJEpFdjbDdE3fiC
	McbgRbrkXnhPDGxDhfUJ7OCJQqeYaeXKckPkfEEjd3C2Dftc6DJiqUJZ5CO00hSJ
	uVfYRhJzGyB93kMmrDlISmVfJq5rvw4Mi06RPYo01fq8cJkQIDvdUlfgjjEGK6RU
	CnwrAr8YAFOCQuEWxTDnQw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09pm60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:34 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UIkbKD032726;
	Fri, 30 Jan 2026 21:00:32 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010008.outbound.protection.outlook.com [40.93.198.8])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe4g0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dJBFX1cbrM/iEjfPn8mSwNTrnmCAjVGyn9y/CYO+GHgkjEukFaLNDIqUrVBrmpc5CI1LEXCZw2t9WMbhfYp+PQEAoygFOfVOO/kV4HyEC7RGeXLEopREXLguO86eAu0T+lEUtICnj83QtdarT7O0Ij/i2F/ckWcxDQwY2ZpzgbB2rzUFCbcFDbFoUEnxOC5alH+N/mXkAnpOH7N1/8CGK5EeXVBB1dkQTkfPZXHe434/sukIIrFuDmqDkHTsGq22N7KvVO2LLNOBv0MF8uckFisuLzIV6aM0UAixRHi0qTYj6LXU5o/s7Bq0rhe8JcOf8SD7u8ogrDbb3NQP9EWJyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=;
 b=DDWl/AtmLoey1C+K3JVEvmDtowRZ8THk9+efnBl8VjE6BMt9j8mRBXJCqcNqQkeCqEJVTmNOQMyfrYRDZWVkOx3x75rUqP4s9tusRCQVC/XyDoyp1a7rgn/iVUZtAC5qTg1oQBstOtY8q71UjZP7fMTwMHNwK5m4AHjEbF6AX1K73dOjMu8Ddw+q533V4nw7MxBIx8sq5TWzULSuXKGJk2L8iS55oopIbSivenktqDRm7Rzj4XQdlz/MTdn9caI5NGkP2RC4VFDZnqDDia7xHdzBgz0JD2ihAa08bBUcFD0UhF+PYlvYUb/kkOE5978tOk6Q8u1DN/uOIioxYQHJtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=;
 b=LzX+QslnQEPyw7816lw3PM7JKBcaJ7DGh2D9QvrGKyaEJBe9zOn3pf17ldAIBez++E3DaZygEgoEvb7FMuW422Zy0uxDPPnP4/MIT8G384s4u1L9/EyQYx9xu9meE4zEfAa1nPt2luCpDo+rippvlNQKrlWTyhtgxZ+H5xeSk6o=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:27 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:27 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 11/30] maple_tree: Introduce maple_copy node and use it in mas_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:16 -0500
Message-ID: <20260130205935.2559335-12-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0088.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ff::21) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: c344bdc9-fec1-4ef5-2189-08de604293fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O2rdKbkGzGWqbVy9QWH9muVtYR8ZzkBRhJ+DX8vuabR2I8opLXtadwO7POHN?=
 =?us-ascii?Q?Wxw1TOV+j0qumWAhEt7qZGHqFQGn0RYscC+X3dCIW+/kHU1ZHdTiNdVFKoPm?=
 =?us-ascii?Q?0MTphL+5qdAFsnushtYVvd30XEijlax/pIeUATWDhkU1tJ0KosS9vaCfQwL0?=
 =?us-ascii?Q?8R1WS9mfcKAzLOc2oEjj9wZ8ZeXHS80prZVzIu4noixUNf5M0YUIEKy4Y0LV?=
 =?us-ascii?Q?IGCwoE+yorol+sMI+8oKPA6DGaVbG0xJh02ZnPkiuzH6geLKLOVqjpOCH0Nh?=
 =?us-ascii?Q?A77grzgXrqWLa4QSXpN85MgWiPZ9PI7rI9DoAedfJFnA2RHNuWzRBgtt6axb?=
 =?us-ascii?Q?iqllHN16gcugtsRYR/oTuIw8TVCEM1Kpnnzpd9RPIZVruBeB4tn5MbsufNXX?=
 =?us-ascii?Q?VzbFmSwTAPIAAZZXkzGTPvVNf3W1q/ElI2a7N/WhYgEmGKWW0ELnC193hzne?=
 =?us-ascii?Q?6GsUTt6yPKJUuevrk+JkwLsmHRUGbXXjE7oGRS+otHBeqD4WKJk9Ss9aMvGO?=
 =?us-ascii?Q?9Cr560ojvNsJtUYySauhvSstzH3jKJhtlh6oJdnMrhw/qENncFiqD1HKsSEE?=
 =?us-ascii?Q?RImi1gXwTYmvtXFLh4bfnvBQo60dW3EPTDZUWAKjtnK811o2gpe+3gz2ea7E?=
 =?us-ascii?Q?YbyymjBNODaOM04hqoBwybznsl84cJnd9vjSIHmuG8njuftQR0diL62itd8J?=
 =?us-ascii?Q?9MME2kTpycEZzjQ+fRF4hiSGNMGYmQBH65hQe7bfaR998DzGCZeju6q+dnys?=
 =?us-ascii?Q?vsIJ3Gj7rOS3Yx0Ylo5vgH0rGB3iHnmcSQneuszr9XoG5EfjMyZ6iob66jNS?=
 =?us-ascii?Q?sya3EhXou/6cswphegKVK4dWtvHxHFXtnb/bv+DPCU+N1HR4kxOxNeJ3j+7O?=
 =?us-ascii?Q?nIXw1a/Mvy3bLJd3ah9zwvzOLhBvTGbxEKeyzCEn/ciINK1us41EIy33jNP1?=
 =?us-ascii?Q?PC3D4fgF1H5RMVNT7rLu4I/pQC7zE2nFK6yRdD/4yWySLwTM2pqjv2CVEN4e?=
 =?us-ascii?Q?ZfJXGTcQkZl6bqn27F8f43x5nlXclFqtbAnxTzWb7oQYTh13lEOVDujeVzUq?=
 =?us-ascii?Q?zK0otM+ynpY1eNRh6tzhyQuxOQYHFOCi7I2dTcQyuMWXeVr7adpdzXwG/ZD4?=
 =?us-ascii?Q?uwRnTBorBh/jOJJ2p8c28KkWc8xgOWy3O5ljxuzTA4NE2MU8FwYcA2JEt6nh?=
 =?us-ascii?Q?B6Zchh7NGkjVP3ZbhxPNJ0aaFdwZTep85Ausb5g531Vd+X5oUPDq+Zo/gdHe?=
 =?us-ascii?Q?/9BN6Ees/kyzmit/+hEcjIG0HRpe//j7WinSq/Eb7DZsdyydFBxLtlPdyr3i?=
 =?us-ascii?Q?FP8krR6YVKMZSJzhV8+g6v9BV3QtsZzeNw4LHxJk+OvfJbJzWZy9Ag1Z0yDd?=
 =?us-ascii?Q?QlbRmRC1rNK1N28TZsw3rKXmwIurBM7z6k1G1dTFHPAHX5Nb9bvU3Ls4Oo5G?=
 =?us-ascii?Q?3xXRb8Rcj7WL5WBt7qsuAguzZ54J6ANj1OVMX5GxY2AIVr0ZrN415KY8FVOp?=
 =?us-ascii?Q?BLNmNf/11FGgZXiLze6m2u6eb9IVtbC2298wmhFS55JlO3guucaCnrtd/6HG?=
 =?us-ascii?Q?GVs8hwhcfUk3XtfFEhM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WxtA9H/jcdD56dzGXPW0TLgUEqbOkTgIoIr0inqPWqVf/k/PAnpTWsWWiOde?=
 =?us-ascii?Q?uZuugJAcON7r6EPP7AdI6ezg3okwx7wVzS1Rr+EhvLeq6QT3spH9d7FmqouF?=
 =?us-ascii?Q?lsPMyzKY9Y3sXkIw+lVC9co4dKOqeRWteKsJmdr6Fj/q4wwmQe5UowNPkEhT?=
 =?us-ascii?Q?RhNSVDe3LcTeMfLzQgP4dcleCovhIVxf71czTK7GevbZVjGRkNoyRdS0Wgxk?=
 =?us-ascii?Q?GqSo5hLfUay21FvhsS7/aKhvDS8bo9UM/9Ohs91MokFkrdMzNdYszJHntpv8?=
 =?us-ascii?Q?ff4Eomgusmqe4cSF9ezXEAgtiCElwjJFlEUnsjvguf7AB6eLP02UoNbPY5SJ?=
 =?us-ascii?Q?Ql1apWet+vc+9LkTqo6tG+JAu2A/+I2lk2mFyZXqGk9uwt2MHeymRM50eyHe?=
 =?us-ascii?Q?aa+wgTQ8guU574JdgUHziVQ+C1BIAN4cVbrAmW/WOIAda5QAQqlGC9cHjodb?=
 =?us-ascii?Q?1qv44UDhO3n3zFEG6G/SCJHtWHn6VCLxjeg8Z0b7bh9k1TQstIlCxO4KFw9D?=
 =?us-ascii?Q?xGizEAAP2S41ZowvUlop/Nkkiig26l9lkCncYqHQe+FEl8QM+Yw+ZOSR9Utd?=
 =?us-ascii?Q?Tq0j5TkOCT35RhCd3JXV6liyXB+a9SJRJHt0YC2/OShv7V4NYtB5wBpy+pBu?=
 =?us-ascii?Q?FMZ6x1j+ZVi49+XsvI8+3vjDy94fOYnBuFDkFPtPmYHnGDVGI7Gvqt/T7N58?=
 =?us-ascii?Q?yS0KSba8Q7AiCNmAHPvPs/lcS2AyJIdGfFZZVSppjSIfE6Hn/XX8JEN1RPoN?=
 =?us-ascii?Q?fYZjaICfE0pPRX98Kuxd8X5KFucDR3AC2O0PDGZeSyZQeBqXfXJAwIJ8eoPp?=
 =?us-ascii?Q?D7IEu5Mg8S3DOtYjbKh+0xY0YpVW+vP/1XUSQdYXVSxWHTouGj0g58omoSV1?=
 =?us-ascii?Q?vSsVCgw2TkA94ZUMJ1sao9dGzg4UefKnMxoETDYSHs47qrgFz1MjmhRdJfBi?=
 =?us-ascii?Q?2F+61iXb8vGFm1e+983cBkCL/MhcTPzEIghpjAtEMKxLY+r0oH295Ha0BLqF?=
 =?us-ascii?Q?MBPr3fUgUy56KwDYGGUp8JAu28vpykHv7ezokbXUtjYNg/ruCgjDMsjr5lIR?=
 =?us-ascii?Q?PtF3Apcrk+n9ZVGuDp01/DPIp2g6DlXTeKTZXLR0q3KG6YfilrcPL9anmXEe?=
 =?us-ascii?Q?cbc6FzP+rhVFwa9tzf6YtwXK94H/jxOUQrdjn8RBdIPyl24766/zGk4/jhuO?=
 =?us-ascii?Q?61+uPC+51T290dWNsvPK7yPc/LQmQ6mO+gj9npfh25Hn5gMxeBSvDYYIE5d7?=
 =?us-ascii?Q?AP7XRgJq4F4uTBlzDUB2t3hn0OD+8Cdnxr/TIsE7q+OhU5/OvsfB8AyONA8I?=
 =?us-ascii?Q?otGyOiMMsrfE4FaQT9BlJQP8WHCy64JQygbkKOnY6JLW2X4NLjWhXhXnyS+G?=
 =?us-ascii?Q?GezWOvTsX+B5PBw+wpeLoq/I05KF9lSBcktfks/hDz1PywMrK6hr7JjlB8X2?=
 =?us-ascii?Q?eCNpobJFuV26/fZYUPQIrs5haNdmFbJOHVDlNmQ0mAYSNaO9NwGJfODedX5L?=
 =?us-ascii?Q?TpSoay+hyZBr5D/ECGvyTO7T53mTOk1vS03PIC0Zt2Ex3OBeQFo2FQ2TVMOj?=
 =?us-ascii?Q?ZWHHmkCTzdzREjhJtmXeg+At9JCn4t2l/Q2PQd1dFR5PGLXH3x1WNtYBQYvN?=
 =?us-ascii?Q?/5tbKsmsLcfZ+U8oXTckECq0Z+doDZLI+k0bZhCkakZKfzWk81ipCWiqo7iN?=
 =?us-ascii?Q?U32a1s0PqLWecYcdYXT2Vp2yHbAbuWPDRyEnNgC78Zkp9igRly7PTy+4H6Ej?=
 =?us-ascii?Q?N0oi4hGuGw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7187CSqHhVfpwkoo4miYGNlwbQZpIROA3T8FjrfFYTnbXvMh/HCiLus8wAciA7bo3yMT9c1ydVginxlQ0W6cpUn2Q1SPbp9dLqVUyxt1hAVuaHGy5dPTqYxL65n+dNURav3QdjOAVYFkTvoJI4xHtkohcqQVOXuI3lfmO9qeWukCkJ9VlQlWSvuwRPkmGU+MVo15/g+YJ2YmEp++39Qs4575CzZB7Sx4lj9ErrsVThbVSWC5QolR/NNiWf2kHemzBvLSv72z3cE5ALsG+6FwCmet6iikBQmm02HHat6kDi8GUvPClckZ9vf4y0wqPGhepffvpAvAlo/wEcnuGwmluZ4WmxP+ZcHYWeFnANR0NEQV6hOgJPS/ScBUM4afDxUvTjUlhorUvxxNwEITTutfoPpqTMt6nxury9yapG1Ph5+nnDnAEcQT22nEC8tYgfuy9A08ZK+c8iAi44E/YYQM8IRwoXhlJpC3c5A0Z8Yq1ODWU+G9dj2r4dUBcwdokfqpohUR5FKmSy2slo9fpFmpPdx7eOSqz8+d2D3iC7xUnM8ZL/eM8dsUrUv9KJl+7+pTgFDcPeuxpL4bDEPAGoio7dW7r7BNblb5LMDqurbFsMA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c344bdc9-fec1-4ef5-2189-08de604293fb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:20.0889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ua0CeFzfSOB7TFUkwpt8SPdV9HkUgEJTEGsw6A+3QPsanhHbuMg7rEvpPS9DgD7RTodkL6Cq06WUs6ojKnM3qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: OPLX61kJxbeSS2oIhiFrTZ7vWqATBPSZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX20F+bV467hTa
 V3npmLAcWpO6kvMoB8p4/L+7ZWb7Yo3vlB+3Pe7nvfsVeZu/9a9wZf9L0uFqTNu0ukJdL3CPVqV
 JbxiyeCNMKIRjYyvStcBfcxXkSZ/8zG8bOTtd29ZYdB/2ZHJfvOAQu5cjWDtOw3C70lfDD4Bg6G
 dJkFDR+GOsxgt5V1GK11vuBzN4W7s3IzaUmlj+zM1qVyxw/mUgCr/Qla5EdNgmbkbGKWaP5lFtP
 8/zqNH8jfRCuqw6H3QE+NQh0cVraSkMLehB4MV7QT7R6SkSJ9Puu9el29/pUEk9eT5OkRJHJRZG
 DXqH643cobmtBrsGgwR+4T6H2NlKefRuQeQVzIeBorzWpIOXWUty5HaMnWJqZY2MrMN31ZfedXP
 Jg8wrjT3M6VMFug+c0tEEhzMbEfk8Re1SY1V5dTfY9JZyBh4rHTD+I8D3b74thv6DFdVTl3tt+r
 gFITXrfTbINAjYWwgSQ==
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697d1bf2 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Fk0WoDt32--Uo3WLaF4A:9
X-Proofpoint-GUID: OPLX61kJxbeSS2oIhiFrTZ7vWqATBPSZ
X-Rspam-User: 
X-Rspamd-Queue-Id: B417910000F
X-Rspamd-Server: rspam07
X-Stat-Signature: w85d7oru9gi8gtczfyu4tapgcizzt5uy
X-HE-Tag: 1769806843-521325
X-HE-Meta: U2FsdGVkX18Zh5/K5uAco3LILu0aMl1NalG8f5S/s1Bjw6hhNrTsW5tKNv5xIt87b5UQ2Fc3KkwZGwAd5fIutaeb+sdeJAPz4tPk14a13jCuNnBbLh9SpuK2rq981HhfU/uLzi/1Mh9J1BSHZkySCeaAG5t97bTzhsEoA/nPeKJ9jcWJRbiIM9IFOJZdcng408j1bpdR6wLysTT4rKqXqntvzUO47IVkCOdwKFVJ8V8U0+G8KpmL2+BwLBJSN2V5YlLZpODiCCUDTvLOskVNse8lr7gv3EEVAXoaWNCRpaTj1LaZK8UBgDeC5WK7jU8s6vSURndrwM12MwoA4j9hhKhIZrUl+LpNiM7g0y2fEB3UP9vQOFkJd4gOU6geT1mGGOEzrNI7hRqrSRBM2nCoMLTwXbdh6g8cH0SH1bZPuxuRsMN2WFvj1g/RTFfq67D4croMoG6ZNUx9OzHHNy3H2hLL3h6dzDbGlPEJ1uCS66w+SXFl81BeqxOHrEaAy6oKHdJAHSrp1zYbudctGbgKzql3pkvCtJMe2ItZaQHE3gNhM0lC2uZlJISG6iuIA3+IOy1fuQH2/MLmOllPje6okbfW0qRrwegy3+WRNCNblPmGJO2m2sqQK1adL6mh3zfJ+XyGHyHiVJUqOdwIDdQoc3in3KAfUEkjfRFjiPgFipcXZdyjOJ8MF2hgdeJSBUHVrpHDBz0rdeI1I0Iz4Ps+oLVYwsmyus9HC/1aWfeNKcX1EEvtWNKaJNKcGq0Tva7RoSJMHvHS9M3/McrGCYDjJh7xVNZXvsPqrJIywLUeIEBgo9W5XDZSIi+gVSAL174s8Ht8hS6w3jzV/jPfau1mQuvHL5r6iB7TPzoOI3SN9Wg82XLnEQV5I+NAAwAU0J8aIm9tVZzGsi7MIqcqOPtGFtH4xoDUERwM/fsbz7MLWw7l4ep/wD4b0VGwH+XFokLWSMt5Og69D1awPnUdLMm
 6uEYzl1C
 eDL6+4a+aszAgx655xfQhazBYjmptAdr0hYjVuLWjJx3sZiQLpjnK+7qVSjw+UZmmUdT/iUtdhaKMKQRCNY3fvmMNtjlyE7l4Ha15EDC9VrvN2UcbGqnS9N4iDOA4z+5b79YKMxPiwrq3OqefpvPyXw4vHUZ7ZqnGJWmPwTpUkQFYj703FH7D/BL/6qY8YhWBxcX3B+AFI+mcVBh1bIELgQwqTEW0nnUVsChSUCgjYBA78NaijyZwsUmQn98hioUBZQvdqxG0KyieCkum6xeyFN/mBR3GRhYpIgdLAwu0ThEFRrLYU6DcMLZFhfPSQBfzE2Wa/9SHXvZyyZy6eWpHkb8BTjdwyYrVY8KtAALL+UNKg78O9U+Wa7v7zEmHuDy1myiHt6+HACKYFifpTOUqybfSqfXahKWMOAqOoF2KT6Lenh68rjOdeUddI8qypEMUSadWNktezhKKQIJ1+2y5MXptGHd9rJmgqFn6tHcsn0eBkXn6DiNUBbgPKz6v+/2ydb4Tenu/LtkCNSRd65tZGfCNkyTbN3A6Rn8bB5l+t4Y79ZHko5Bvt59GAlZ2EIwWuAgGZ/hy0zoNxZficpUQRb3AFTpXz4u/fVqQRU3ZM1WVrkGGmiSEvT5ORKKin1qoJXLmDaTJvKJ49EZwXCNx7YADSIzVszpweGsfmHSlMeHlP01pwcjpbKUU3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce an internal-memory only node type called maple_copy to
facilitate internal copy operations.  Use it in mas_spanning_rebalance()
for just the leaf nodes.  Initially, the maple_copy node is used to
configure the source nodes and copy the data into the big_node.

The maple_copy contains a list of source entries with start and end
offsets.  One of the maple_copy entries can be itself with an offset of
0 to 2, representing the data where the store partially overwrites
entries, or fully overwrites the entry.  The side effect is that the
source nodes no longer have to worry about partially copying the
existing offset if it is not fully overwritten.

This is in preparation of removal of the maple big_node, but for the
time being the data is copied to the big node to limit the change size.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 include/linux/maple_tree.h |  26 +++++++
 lib/maple_tree.c           | 140 ++++++++++++++++++++++++++++++++++---
 2 files changed, 157 insertions(+), 9 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 7b8aad47121e7..9bc7fa89bc2ee 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -139,6 +139,7 @@ enum maple_type {
 	maple_leaf_64,
 	maple_range_64,
 	maple_arange_64,
+	maple_copy,
 };
 
 enum store_type {
@@ -154,6 +155,30 @@ enum store_type {
 	wr_slot_store,
 };
 
+struct maple_copy {
+	struct {
+		struct maple_node *node;
+		unsigned long max;
+		unsigned char start;
+		unsigned char end;
+		enum maple_type mt;
+	} src[4];
+	/* Simulated node */
+	void __rcu *slot[3];
+	unsigned long min;
+	union {
+		unsigned long pivot[3];
+		struct {
+			void *_pad[2];
+			unsigned long max;
+		};
+	};
+	unsigned char end;
+
+	/*Avoid passing these around */
+	unsigned char s_count;
+};
+
 /**
  * DOC: Maple tree flags
  *
@@ -299,6 +324,7 @@ struct maple_node {
 		};
 		struct maple_range_64 mr64;
 		struct maple_arange_64 ma64;
+		struct maple_copy cp;
 	};
 };
 
diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index caac936bd8d40..554fdffd6c5b9 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -605,6 +605,8 @@ static inline unsigned long *ma_pivots(struct maple_node *node,
 	case maple_range_64:
 	case maple_leaf_64:
 		return node->mr64.pivot;
+	case maple_copy:
+		return node->cp.pivot;
 	case maple_dense:
 		return NULL;
 	}
@@ -624,6 +626,7 @@ static inline unsigned long *ma_gaps(struct maple_node *node,
 	switch (type) {
 	case maple_arange_64:
 		return node->ma64.gap;
+	case maple_copy:
 	case maple_range_64:
 	case maple_leaf_64:
 	case maple_dense:
@@ -690,6 +693,7 @@ static inline void mte_set_pivot(struct maple_enode *mn, unsigned char piv,
 	case maple_arange_64:
 		node->ma64.pivot[piv] = val;
 		break;
+	case maple_copy:
 	case maple_dense:
 		break;
 	}
@@ -711,6 +715,8 @@ static inline void __rcu **ma_slots(struct maple_node *mn, enum maple_type mt)
 	case maple_range_64:
 	case maple_leaf_64:
 		return mn->mr64.slot;
+	case maple_copy:
+		return mn->cp.slot;
 	case maple_dense:
 		return mn->slot;
 	}
@@ -2595,6 +2601,110 @@ static inline void *mtree_range_walk(struct ma_state *mas)
 	return NULL;
 }
 
+/*
+ * cp_leaf_init() - Initialize a maple_copy node for the leaf level of a
+ * spanning store
+ * @cp: The maple copy node
+ * @mas: The maple state
+ * @l_wr_mas: The left write state of the spanning store
+ * @r_wr_mas: The right write state of the spanning store
+ */
+static inline void cp_leaf_init(struct maple_copy *cp,
+		struct ma_state *mas, struct ma_wr_state *l_wr_mas,
+		struct ma_wr_state *r_wr_mas)
+{
+	unsigned char end = 0;
+
+	/*
+	 * WARNING: The use of RCU_INIT_POINTER() makes it extremely important
+	 * to not expose the maple_copy node to any readers.  Exposure may
+	 * result in buggy code when a compiler reorders the instructions.
+	 */
+
+	/* Create entries to insert including split entries to left and right */
+	if (l_wr_mas->r_min < mas->index) {
+		end++;
+		RCU_INIT_POINTER(cp->slot[0], l_wr_mas->content);
+		cp->pivot[0] = mas->index - 1;
+	}
+	RCU_INIT_POINTER(cp->slot[end], l_wr_mas->entry);
+	cp->pivot[end] = mas->last;
+
+	if (r_wr_mas->end_piv > mas->last) {
+		end++;
+		RCU_INIT_POINTER(cp->slot[end],
+				 r_wr_mas->slots[r_wr_mas->offset_end]);
+		cp->pivot[end] = r_wr_mas->end_piv;
+	}
+
+	cp->min = l_wr_mas->r_min;
+	cp->max = cp->pivot[end];
+	cp->end = end;
+}
+
+static inline void append_wr_mas_cp(struct maple_copy *cp,
+	struct ma_wr_state *wr_mas, unsigned char start, unsigned char end)
+{
+	unsigned char count;
+
+	count = cp->s_count;
+	cp->src[count].node = wr_mas->node;
+	cp->src[count].mt = wr_mas->type;
+	if (wr_mas->mas->end <= end)
+		cp->src[count].max = wr_mas->mas->max;
+	else
+		cp->src[count].max = wr_mas->pivots[end];
+
+	cp->src[count].start = start;
+	cp->src[count].end = end;
+	cp->s_count++;
+}
+
+static inline void init_cp_src(struct maple_copy *cp)
+{
+	cp->src[cp->s_count].node = ma_mnode_ptr(cp);
+	cp->src[cp->s_count].mt = maple_copy;
+	cp->src[cp->s_count].max = cp->max;
+	cp->src[cp->s_count].start = 0;
+	cp->src[cp->s_count].end = cp->end;
+	cp->s_count++;
+}
+
+static inline
+void cp_data_write(struct maple_copy *cp, struct maple_big_node *b_node)
+{
+	struct maple_node *src;
+	unsigned char s;
+	unsigned char src_end, s_offset;
+	unsigned long *b_pivots, *cp_pivots;
+	void __rcu **b_slots, **cp_slots;
+	enum maple_type s_mt;
+
+	b_node->b_end = 0;
+
+	s = 0;
+	b_pivots = b_node->pivot;
+	b_slots = (void __rcu **)b_node->slot;
+	do {
+		unsigned char size;
+
+		src = cp->src[s].node;
+		s_mt = cp->src[s].mt;
+		s_offset = cp->src[s].start;
+		src_end = cp->src[s].end;
+		size = src_end - s_offset + 1;
+		cp_pivots = ma_pivots(src, s_mt) + s_offset;
+		cp_slots = ma_slots(src, s_mt) + s_offset;
+		memcpy(b_slots, cp_slots, size * sizeof(void __rcu *));
+		if (size > 1)
+			memcpy(b_pivots, cp_pivots, (size - 1) * sizeof(unsigned long));
+		b_pivots[size - 1] = cp->src[s].max;
+		b_pivots += size;
+		b_slots += size;
+		b_node->b_end += size;
+	} while (++s < cp->s_count);
+}
+
 static void mas_spanning_rebalance_loop(struct ma_state *mas,
 		struct maple_subtree_state *mast, unsigned char count)
 {
@@ -2750,10 +2860,11 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 
 
 static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
-		struct ma_wr_state *wr_mas, struct ma_wr_state *r_wr_mas)
+		struct ma_wr_state *l_wr_mas, struct ma_wr_state *r_wr_mas)
 {
 	struct maple_subtree_state mast;
 	struct maple_big_node b_node;
+	struct maple_copy cp;
 	unsigned char height;
 	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
 	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
@@ -2765,15 +2876,26 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 	mast.orig_l = &mast_l_mas;
 	mast.orig_r = r_wr_mas->mas;
 	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(wr_mas, &b_node, mast.orig_l->end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (mast.orig_r->max > mast.orig_r->last)
-		mas_mab_cp(mast.orig_r, mast.orig_r->offset,
-			   mast.orig_r->end, &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
+	cp.s_count = 0;
+	cp_leaf_init(&cp, mas, l_wr_mas, r_wr_mas);
+	/* Copy left 0 - offset */
+	if (l_wr_mas->mas->offset) {
+		unsigned char off = l_wr_mas->mas->offset - 1;
+
+		append_wr_mas_cp(&cp, l_wr_mas, 0, off);
+		cp.src[cp.s_count - 1].max = cp.min - 1;
+	}
+
+	init_cp_src(&cp);
+
+	/* Copy right from offset_end + 1 to end */
+	if (r_wr_mas->mas->end != r_wr_mas->offset_end)
+		append_wr_mas_cp(&cp, r_wr_mas, r_wr_mas->offset_end + 1,
+			       r_wr_mas->mas->end);
+
 
+	b_node.type = l_wr_mas->type;
+	cp_data_write(&cp, &b_node);
 	/* Stop spanning searches by searching for just index. */
 	mast.orig_l->last = mas->index;
 
-- 
2.47.3


