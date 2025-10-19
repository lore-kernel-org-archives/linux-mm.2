Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E1CECCD1A7
	for <linux-mm@archiver.kernel.org>; Sun, 19 Oct 2025 07:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAF038E0019; Sun, 19 Oct 2025 03:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C38498E0002; Sun, 19 Oct 2025 03:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB2978E0019; Sun, 19 Oct 2025 03:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 959B38E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 03:25:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39B7F11A7EE
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:25:49 +0000 (UTC)
X-FDA: 84014029218.06.7E37B11
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf14.hostedemail.com (Postfix) with ESMTP id B5F03100002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 07:25:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WyH/fSTH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZECDosFj;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760858745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ogRUWcfKUFrxORa8/onFppSEA6eDWshYbMToUvDNO5w=;
	b=XOd5DvhgBmD8MFyP+YM6GybgpNOxvwiPGrYbX8CROYaZA6AQe09nUek/ydfo6Ez0CVQMaX
	iwb6GhqSE+GG1B052pWQBdX/lIb8KKYL+2d/DqZ6xm7/eN2xz6unjGpKVy5g0DJIurOxuT
	ZxaT5EMs2O4EzSphbdty69nA94smOlw=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b="WyH/fSTH";
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZECDosFj;
	spf=pass (imf14.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760858745; a=rsa-sha256;
	cv=pass;
	b=iTEa230rn8SM4slOHqKCxD1S9VT2hcA1kxRBPzI0nPzyDeRT5E0RjFCkwuqE68Fs/G8IDu
	t2IMjIW6KLcvJMxqIwsB3aiIPhL8pnpZL5jiT4xLvUhEGX5YmwdjNAo+JLhzEE1UwlHzqa
	7bgbQ5oTast7yIJm8dZ4wrXoIAxNfeQ=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59J6hpP0013847;
	Sun, 19 Oct 2025 07:25:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ogRUWcfKUFrxORa8/onFppSEA6eDWshYbMToUvDNO5w=; b=
	WyH/fSTHBBf6u4jozWVMuh7vMxqI5w41Q0ruVllJA8AP8HdtplfO4zMuypqecae/
	KIVq7OIUpOQzXSiSq1rRs8Ye3pj2+b8AB9IgRnGE4L+cchW2b/58Okl/x7bPfjN/
	uh0JpVxJv+a/QgNXwZDWFFz9CfMYCXIs7dD38FlhPYwZ19sjIQToCt1sM08ufWOH
	FkoKFfUtXLFb26M1Qs3z8SoZFPbc/H6J59kLOS3R8duBzX0HWSovNEbR2swVwH5i
	OrJI8mEdxFz2dimUWCkjQaMbZawSEVpf9Vgj3GtaVepxQGHYia52XdiYgl20AJCZ
	i5bajeWwTBJwOJuQxbiiFw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v301rtjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 07:25:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59J318EY013103;
	Sun, 19 Oct 2025 07:25:41 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011019.outbound.protection.outlook.com [52.101.57.19])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1b9rmb9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 19 Oct 2025 07:25:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RXiVDiN4+NvrPSnE+dpyf6liKEmQKvFNBQSPNCHpf1Ov+irZ4m4Hi7iTHKdK2APJ1iWg5TvzSrPplovVbc0jPRFC+4+WjSxurVLlsgMTLXEa0jsfrHP7hmwfuH2dEEFKJj40JCwT77/Kpr5BE8AnQlFvKj/kVxBOC0Og1eQF3WikPv0oJJFb4yteQeyM4DydKP8ncJETnTEpiy9wGIp0vWFwtiTAdoMJHgp/Kwg6yRhVg8zXIH+gtIl3PElO1F4NMMt+l0h9oY6+KBkfczGvBgifHGAtK57gMpECpjE9uUWe9A6nU8Cc2yCSbsxmof1uA6p4sz6/Gsi2YDEKEW7xFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ogRUWcfKUFrxORa8/onFppSEA6eDWshYbMToUvDNO5w=;
 b=szYWrMwEX4TUa35fNVxR39f3Jb9f9/i5IYNSU8BJbfkpdoNM4esqn9/fBalPFA5N5XsFbsa43GIADQuEHNUiXRjyA+3HD8rJY1F+/mHeiN+3i0oAtOD4ZMPcODPPTEDS+ThB4XxlEuSqhozVjJoL4oPQL7A97a9H0mpuER32QF0bSqW6VhVO/hAFwdC2rhj9cA6Pp99CHwzGazfqoWvkXX1Ongq2ISw4dxvyNUCYILh6hXDyfWOueVDjIAAnPqeROyud144Bar5lv1Ibc3j+75smOQTrWy6ydFjYiw1FSQIXLxQpaS4ALzwecLMA6Wdky02OtiobigRWgXZBSSDKSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ogRUWcfKUFrxORa8/onFppSEA6eDWshYbMToUvDNO5w=;
 b=ZECDosFjf7r4b1qMsRrHcyOmhOxnQOYVmgH9hSCFMnXvEZI/WmerJdVaaG2XhCxF13zgFJaQTlHnNQZsxziqovXe71E4GLVXw/PLdcepkKTzMLdZWUFApC8tD1OIE4jUNYYhcQeSX4C/Tug6+pvYMZukKm5IGsUxe32vjiHxUgI=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by IA3PR10MB8759.namprd10.prod.outlook.com (2603:10b6:208:574::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9182.20; Sun, 19 Oct
 2025 07:25:38 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::f238:6143:104c:da23%5]) with mapi id 15.20.9228.014; Sun, 19 Oct 2025
 07:25:38 +0000
From: Harry Yoo <harry.yoo@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH V1 1/2] MAINTAINERS: add include/linux/pgalloc.h to MM CORE section
Date: Sun, 19 Oct 2025 16:25:08 +0900
Message-ID: <20251019072509.9488-2-harry.yoo@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251019072509.9488-1-harry.yoo@oracle.com>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0074.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2bc::10) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|IA3PR10MB8759:EE_
X-MS-Office365-Filtering-Correlation-Id: eb77c7a7-9e85-4c6d-1c45-08de0ee0b398
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?sk8wcB8g7tiSUbsuuoU8lK64LRMivVLEqmc5nLzoHXXq7kHy81tZj79H2lK3?=
 =?us-ascii?Q?Lx+i+n1+KhTvupIIDF3laBJRdAYudFwTHFKyPxI/b2UpLBzU8W1yROXg7gih?=
 =?us-ascii?Q?pfPksxNR0g2tCF3hupiPPNeMpEzwFwXPPiELAXTrwRPWTUwdOCjR8B51N+bW?=
 =?us-ascii?Q?hcIO2v628odt58DFPICCZdVCRqzPlSNG51Gz2ecBCNYyg8CbOYbbIqJrmV7+?=
 =?us-ascii?Q?TXOksLKv64D+Rci8BZRk4hW1bAh7QkWq+aAT4R1kSxscfcSoQPdN7aWWBmah?=
 =?us-ascii?Q?LDCFuWRHD7ipipR9KNjnEZfGbc/ZY//A6DYXT6mtn+PU6sTXynFWJLSbUSR9?=
 =?us-ascii?Q?/P81aGQTjdjCwDE3/XW03TRH4vePE7mDfLQLTRVPJzUzvxOCx9TRBsquaX4L?=
 =?us-ascii?Q?ToyjdhIBLyDjlgFmWuZ2bMC0ctx1PTgNva7xtqiNTWVwUPpqgVDRygA4XxNU?=
 =?us-ascii?Q?Nyvx3426CZpCHT7metZ/WK7ouHevpnoYfjEtMRMRPsz6Wr3oI/0qhLskiK28?=
 =?us-ascii?Q?KLJJEDs+8jmZat13cttYJ4x6WMv9IIYYshAFJ79vwyW6fk4Oi4oiJ0kE+/nK?=
 =?us-ascii?Q?v6NqhE1MK9XBpIELZwr0/aA/QBN29m9kkfrQxsXd2IoAHJffZex9MlWoL9mI?=
 =?us-ascii?Q?7foLShHRRyz2J1u/bWOx17t4W+Hni+tRqbW900qNITgviSZrrWvbNwYqldFA?=
 =?us-ascii?Q?nXAXvLMPU4gqhp4yxOlgCctbzaC4h25XloB/mNZ3tAQ2dNTWjUzm5ocXauRO?=
 =?us-ascii?Q?uXEU0IKfbiyrhk2bf+dVARCy0RYGCecc6B09Cm5hgoGeePbTziG5nQQOdtAQ?=
 =?us-ascii?Q?h/WhouM5Q6hsGm40dKcZQdVJBqBMf3oJiWk+0D1s9NcQnu+FpQW84/0RqRHu?=
 =?us-ascii?Q?SAJoHuLXBYGUxNz7jNuTF6k9gzaEHzBO6c/AYk4S1Uz/gFpvPwslszF4ukeR?=
 =?us-ascii?Q?ZhYxhGkNfQIOttmdpFU7SyKxB4+4brgSUWvJp7f/9lbck+3ivIPehxNK6kDr?=
 =?us-ascii?Q?q7vSul4ADNmopS1J0ANIUNt7FwjPxD/UXQTxYK13hWa4VvYbv2jAIjlQ1bfX?=
 =?us-ascii?Q?QKQFDKxdk3MHam0QLyjgpGqtYM68erhWaAs0YaO2Oj9HcmUhEw/frovnV/l5?=
 =?us-ascii?Q?ordSTikWdD2zKlZXEkHeLp1ZfBWYCPw30cN3ae+BvuxrCIA/1APpd7wT83hL?=
 =?us-ascii?Q?hZrCSC49zT/EjVuKNs5uHfcA4gcqGDr1+5KGWLaUuI4ib8xK4T31icPTaHFR?=
 =?us-ascii?Q?6kTGc9owxq4SWES9OGzK6dMnSPWBphcX02GJyh5ekDDQh2yqBIRcrNFbIgGQ?=
 =?us-ascii?Q?dS4jt/wwcJqFeXj0HGOkBpB4Gjvfkq2ReRu+cwp4xTZJEsCc+P9wYnKqAh9K?=
 =?us-ascii?Q?sgnCcdD9qk9iH8wy47QxTQKNnMEqriry++q5mUseb6OHMNTLhoAJC7nrq/PW?=
 =?us-ascii?Q?VQQhjZ0P9IzK9eQjtXCgYtiO/gVPvM4B?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0rlze0f83KmgQRW2gh+II0P2FLKUYM3bI/ED569YrefCgk4iCgJQEla4imdQ?=
 =?us-ascii?Q?W22GFrj0YUs48mu29oX8YmwpBHADrC4o3tHU36p1VqbSMX5tsEfsyDDKeP7g?=
 =?us-ascii?Q?UoqupL8bteF6nC9ltzWOaldG+pZZmcN/Oc+5BjWW6IIweJ02mXCQw4h+lfA2?=
 =?us-ascii?Q?gjfmdkS2nbSCYcZ09dWJQIFo8OZvAOVfwRi9br06FY1LCo9gRZ581RnZu71X?=
 =?us-ascii?Q?kRN0eIknWqIXv6rAVxmuiKiMOb23g91ZwVCju6+a0q1iGRkHOiTVcIPTc4cy?=
 =?us-ascii?Q?B67gFo9QpjI01MKJ7OiCDfppI+0gdw9/grF9BPdEaZGo9W2nvDGhOVzjxlD0?=
 =?us-ascii?Q?sqQ+56EEVtRFBvZMfLCFK3WjiKkxt/ij/kxE94BpYnAKmqegLcb7tTg/w7dI?=
 =?us-ascii?Q?je16/vwdt7bQ81V8cYOqfVVnETqbo4X60ai8Ga2uyGPEenVsNWg+ILV9zrpw?=
 =?us-ascii?Q?Rql4g6OaPhr0gIYG2b5bAfaLqvRN2cTitgG4a+Dc8S2gfBteIJtt2jgHSowO?=
 =?us-ascii?Q?5xGgN9sN24CDfIKGB0NvVfh6CMW++j2IZ0+QRH2oBdGhVIpdj4Wsmij58XjS?=
 =?us-ascii?Q?GXNQXE2xGnx4BZ6yBzxMXHLtZkw7xrduqDzWq3rkVNyF3a4yuehFaSfRRtZ4?=
 =?us-ascii?Q?JnPUousuhNpJb8599ogjTKH+fv2ou6kreURux7GTO+vXTg+Yed4b0YD5TZk4?=
 =?us-ascii?Q?2vMABFa14TUZQHgbXxCwaxx1LEyHmqG+x66rHrXIlCKFd8PBKePF8j4yNXEo?=
 =?us-ascii?Q?x4I5gup+ZPltxaap0mj9cXmcYKSj3LGbn7Ks+hxWe0c8gnvRfHEkihRsZEzg?=
 =?us-ascii?Q?JqI6OG2Q+44HivV1OjiWtFIIkAdEa1fzNgPWVFtvjVlilx/VDD6AK0Fhjh/f?=
 =?us-ascii?Q?xynBRQcziF1Hwr+Y8uR8Wfz+9OqhwCylYFODPSAwhgBy9ikYEgHz7Lj9Z1Pj?=
 =?us-ascii?Q?AE42k+HWdKYDqS8PyQ+PXiBw72RrQtw2ORP9bhyVZ6bYnPTd89Od2ZDKWWn0?=
 =?us-ascii?Q?jL315nqPUQxFcSfFSCE4bYQ4xm2lviZscv1zrIO1y4d3IeYUWNMQ9iWg9NNz?=
 =?us-ascii?Q?ljHXFaWZiclGWPAlCN+uuZhEk68Q2Z4POD0EZq+CyD5iA5EOh6wohGwomvgG?=
 =?us-ascii?Q?gvtgY4P7Ii5vLJd3WLSEupcmOe5PYmbPdh9r5JaCH7/NtEe1tJ+8tuKJs1Og?=
 =?us-ascii?Q?KFn7E4CdLCgndiKwpTXv50bCTts00QJTnGBRPLDgdye1v/ONUbdV5wBCK3W2?=
 =?us-ascii?Q?1n/Ur9wyLVLwRVpk4piJYff03FF2BW9HnCnJY3l5A3/Vno9GFFmWVNCM+roE?=
 =?us-ascii?Q?Upszt8MFT7DlXAd3LILPaIqfRU/+tIcPOkgwYDAgLtIHxReClwzjareWd/n+?=
 =?us-ascii?Q?Q1zGEVgn0VvmlXOdZOB5wPvocvOqdl2kMMWOEDkQcNSpNinrKP7qgsq4otlR?=
 =?us-ascii?Q?peNvZS7lKIfgwd8YfzAif/ZdKbuypCqnfWr+aOiKpq3HJMktsj+Jf4s0zZH1?=
 =?us-ascii?Q?BctqAvI7AyOLf2l3gerx6mKCS2Qhxv3/S5pCNvK+rjNoCOu43LNbHOKWkSLZ?=
 =?us-ascii?Q?+Foo+gTq+uG1WHR42imzweURH+lu2wwgTW8VRSaa?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	SrOtlxa86RaGpFD0YE08/DibMwoAqCa4Ql1wQnDbUBxT9lbL+7/cgFrudRaBXuBWIqfG7G3+ag67Qtgwhctz1/KdrHDOBV6U1QmFJJgipwtk3Bw6wQfWQgOCXtCFOfW++HilldEzxNKP2SP4R9KQ/uFxUoY2mfhxYzSK7sODKVjJE/Kt8ahELfNCxiizvkhtY19Cpf+oYmG9/EckT9QHRVKkVdkCEsY38gEO8BLcODK207gZnkNmyOaH4TRWatvNWzEznBu/tLzzKIds9I3lL3M7lImLquNBD6cun+JXz2Ko6nx4xI1cy8mlq3hp0Knb33rV6QOlepokMbwPp+py2CCa8kPD5+XoyF/tBbUguz6XhKFdv91v+ki4xPHNBcIPdWsn4l3NwdMjcd9IokkSQh8cm8rlN/3KMPSs1fBHI9vDDewIp42xz0cpkwKJyNK6sBWq1dJ1iu2qEusPdyLWSse9SnI3d+VUNZCP08gdxEaaQe5b5liWpga/pD39Sg+E/Fff2xzwXSDBZe+vONMiazLhTN1uEH5nj7mOlhiZv06tEaZOOB8MyG93JSLzp4W3OpUqJaFw2Au/fE+dNHFjjfPTiIpwl/6vazXsAwAD1ZQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb77c7a7-9e85-4c6d-1c45-08de0ee0b398
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Oct 2025 07:25:38.3426
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U5OWnwDKRx3CGtCOX65OBElSCrOfGije8BEfrjn27Qpg6PxguTmI7Xst/rcw28QowG9LxN0z3lFTStRd1ruYAg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR10MB8759
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-19_03,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510190050
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMSBTYWx0ZWRfX/N1T2JkBBpkS
 202VRmyVWzLJKD4AbrCWxllhwaP24QST8N+7XSUjHZHlIAMduIljfQMlNbvEqROqq/HbzXAa/VB
 NED7ZFjmzRlVLMFYN8QVUSV8kcveUDf70Bzd5V6xerY5qYldHPbbIIgIIuqNISteZSC9ufVV1sN
 22s3ZvjjrUNLgcQ48cXhkUNAMa71CZq7hOurb2JayIqURjnA9SU0e5jzYhAhR05+PuHJ2SWhQcg
 hYfkQcILKJZV3mrWvLSrfusP/Gj7lpNjHefadMkwVOzxO/zHACXcgPK5ctC8aNUnuJgAss7pfL7
 SzCdK2+1maHfNlYd2NwsQM5AEvGjJbmec34TsQKHz5x+3zUsofKZELJrth6WibvCTDW6/oP1Acc
 IN/8k3VY6CroBWjkrGOvNNT6Zoys9w==
X-Authority-Analysis: v=2.4 cv=Gb4aXAXL c=1 sm=1 tr=0 ts=68f49275 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=tYLnn7715BZPU535iPgA:9
X-Proofpoint-GUID: CMbfGHanSEI8E2gy08eyGaqr2iBBKWvk
X-Proofpoint-ORIG-GUID: CMbfGHanSEI8E2gy08eyGaqr2iBBKWvk
X-Stat-Signature: 8mb65gsutuzfri55b87wsooytq8zcgxm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5F03100002
X-HE-Tag: 1760858745-716089
X-HE-Meta: U2FsdGVkX1+elIgFsX6zKsDVBis3qN2gc0dJnpRvbVfWZloo4oTyChZX0GGpP/aNoCs/W9DfQ5cTCk74OqTwMrQZY+gQ05mz/2kfpJyLAB5RdBe5YLuiSJu1h5c8EnCX6KrkYZFmGd0NXGXAvOVx9Ql22qYchsddT2ubOTybcF+6Ix5ZUJepuhsLo4XiUnQ4aUL4Ibc0r/ldfgB68UQPPeyAe+MMmw/0P6RMwqLgkSzUXyM8/7TvYu9q0vnox5ciD7h75liZhurd+sACt1hgPIsmLixPdcvmEK49WJCzH8T0IGgL4VqYmTRdWEDhzAD3XMKJcuXO/rYjeC3epqlKSyYic+4M+R53zRG8U3L2ngqF7MYcNDsfn4IdYRxuy0gFpdcACLQy7EtWSnlD+zvv3zcCRYzMcamI3zzYBb2daP95U3TBHNiqA5rezC+168xJvreg8RPEK61Tr55DcLB+AR+y2j6BWWhcQBkhuoUPzRY/r6oPm3Gg6XmiyAV4EbxAlUkmSQp7M3yYd1Fu5hBhy4/7eClyDK+KJajS8Yv1GSYDDFb/QeiVoMweMzyTfdliYGnrKaiSavxHU7TQL/Uj8bazHLjq2vNENrIaGygMh8kCbh3AtaUKvBzHHo50MvWl1fiZCMzdds2LZoQ4C0dvgLWAWTPrs5/eNb5JoNeutjWPhsIFgHTDnewmrbDIrLtL0cD4ZdKnRQtzrG3m67L5ApOR1/Sp928/RJTIkLMt109uh2ncuoJwKbOfdyLQnyvztGKUS0C/7ovCZ7ah5cDNwzZDImgUSOnbOzXq9QX75fZ4jB+pHwdLO3eZJ/cKh4nyhBkgqDLwTOQTQpQnXuZikWVyVM5aN1g8GOe52so8g70lWQEnqkzkAGo1zQWELkGhXtQUDc0ncXUNQ/VWbvIo6OKMot5cDGGrkXUPxxB/HeWiZXpSn/0dej0/90PhDd2Hcv3PX4hmJHQz4dfwwzH
 yoBS6syx
 jbx1FNxNIrV4jO0KRX5Pb4xeqh0ECCPrb0n1HIv52r56OAFDK+6zbH/OYhvaxPaFcv3btoAtmu7ZN5m/4QPe3W8ztYsVzZwqur1vf88HoSe0gGEK5IvUYcpAsjFc/p+BBP2KQuKNZ3lUZ+n/CFKMsP04tkSHPj89DplyygMHcj/ja2MXULQSLuQCFwqwaEPaOJGlV+KMyJ643OUeHL/rdReK4p5hvDoVGyxclqsiMFIRTbOTqh6j80KhyeakNtx5gn0TYvApg3weNv7ljCE1a4TZoGr9Zkm6GSqZ7FO88ZHnnlNc/rwPJ9vQNhDuVeB0tirudXhGGF1nGS13Oz6iPnIBbjQQjttNMcjrS8iNX5UiFUGBsWO1G+nfKFcejfw2Tah7P3Qp1eNOY0t3rhUC+k3pb60ea2DTwDRUNpmwKVGuMDNtTH1dO6ED9d1WPJFxYxnavyp6u9EW2Dpp00Tt9/ou8HK5aKIMl+xjxuFKQAdEeQhE1kVWaap5Xp2cm2mdPsNL0gd4cD8FTQClNqP3XZjCrqYuGOIfxHcIy77tr3WubCvtsLHLsMK/nJaHmGjg/dyWg4lRFa6astWkYcmnI1xygCXej5BzEuK8AotOG7ko8O2ype6yMJ0svcwW1cf442JKZz/6zhZIivtQTMydDEGrS9fLWLWWHGH/BYn5+r/rTWAk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since include/linux/pgtable.h is already listed in the MM CORE section,
add it to the section as well to keep it maintained by the appropriate
maintainers.

Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..dedb9525c2bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16249,6 +16249,7 @@ F:	include/linux/mmdebug.h
 F:	include/linux/mmu_notifier.h
 F:	include/linux/pagewalk.h
 F:	include/linux/pgtable.h
+F:	include/linux/pgalloc.h
 F:	include/linux/ptdump.h
 F:	include/linux/vmpressure.h
 F:	include/linux/vmstat.h
-- 
2.43.0


