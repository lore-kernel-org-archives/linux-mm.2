Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D57E5CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A846B0007; Mon, 17 Nov 2025 08:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22BD56B0008; Mon, 17 Nov 2025 08:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CC0B6B000A; Mon, 17 Nov 2025 08:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB9886B0007
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:59:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0DD3B363D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:59:02 +0000 (UTC)
X-FDA: 84120255324.19.E381280
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 27540C000C
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:58:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XdJeAS0P;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VPNqXz6h;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763387939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/6+giOS6kQKcJeHrLNXWF54tIBQojT8V2ti0fTxOe1w=;
	b=RzrKqGQRbA4ZDaejkJrvTZBe+Pgq/XAPzvoh3nJ7IJdVdybW4RJAwCjzJgXeLG5m9loyil
	0cJar6b6rGuz82+1S2wmRyfGtk8g3pz/S/sy61zBv+mAL0EzZy9h6oxy+s0Bk41HyrB1it
	M7PgKTmng3GCx4O9JtckHFGKVDFn5iQ=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=XdJeAS0P;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VPNqXz6h;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763387939; a=rsa-sha256;
	cv=pass;
	b=zh6S1Snw0dLQS1GumOGTw0J9wO9c6bK/cdbmz4MMp8iUEvMuTe0vRXZBFYnPW4UNUbtuLq
	ypAb/2Rysk2eyC+6pjiA7EZB89leP1Xl8dFDZDsvgtEsE3HLbSjgXF3pwqSPecLG1xSMs/
	UN0rXj2fm2I9r+zRAB3T3pU37cX9Ugo=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHC8YUP002321;
	Mon, 17 Nov 2025 13:58:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=/6+giOS6kQKcJeHrLN
	XWF54tIBQojT8V2ti0fTxOe1w=; b=XdJeAS0Pf+KiV6/aFj64JPGO6CnHEg4wuW
	bQGT+lVorHyuWP9SaWcD3F6s6QJk8lSGDYcTtuGvclahoGARbzecr0wcRUdYo99Y
	v7k6dMtJLrKxtOgMeAshT7CexDob5ulI8ejEpXWpPsdu1JPPpvR9IuZtCpvhbo1y
	STf4S+cU01j41DiS2yHMSvv/F9OuxOaX+4Pa639xnZi1d55YLI7BPqqiF8cw49di
	R4N9KYEV5s/YJitENoQ46mafRGh2VZ2dMaVkvti1yo3qDNjR7E3+XPtJUOt/sZKL
	2qppCk5Nxm97TKHzzTlhYjK1irhlmz0rJBErer9qJZ8/+s5e0pWA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej962f92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 13:58:48 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AHDa2qm007932;
	Mon, 17 Nov 2025 13:58:47 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012001.outbound.protection.outlook.com [52.101.53.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefy7qth5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Nov 2025 13:58:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=QbqeFwMVv3cLUOkEoG8N1mvN9nEcG+0MJzCLPBJTzxyeJLWRs+LACz8lfSlE8+tA/lZbxcCkDgbszu4SulGkZKjITyvp9jCCW/+dlJw1HawIuEFFZCRsM2djnLKby2WPkhwQukMsKyFiq9o2dE3e+RnnQxYeIy4VIeewkq682FbWOhD83n/rxvzERmYpJpI7N4O4zlcKOWGxaeSQVRiWbp+cIuPq0ALtqQ+kdhNQiatNowaNw3PfYUe9ehex7VyV6vlS0SfFU/LOCDWBTFxKg6wLyjMdxXLRMiT9C729/r4IBT6uyj0G8SCywJZog4NVOvIi2xanqpD6jGXvpNDAlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/6+giOS6kQKcJeHrLNXWF54tIBQojT8V2ti0fTxOe1w=;
 b=ktb7eqVYZvAeKaimr1EXkBK6/mKCbUsHsQsQBw3xe/79VO2xCazRoaBJ2T1VcwXod9fKTUpXI9nT3vghsbXZ8Y+EbfF6Ror6uESiFfyCmnnxIJoqy/s4Zb/AEJF62BGC1iGyWDAngECzdRX2r0vITeiW4gV9txaf87Ravfl8f/7Mqk6jH8pUWO9LKJrKErX/ygBKWImNMOT8eSKZ0UABB1/HZwiPc9n6v911EAcBMvFaaPvPTnqtqKzvoDf8Xim9sojLhEzrVfwyp4/0xcIMw6cJvPK+iCr1h9WBwpeFt4SZo6qgHHFb+lWrNfbV8Pup6UoUDmCK4e+LnY4GJ2/dOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6+giOS6kQKcJeHrLNXWF54tIBQojT8V2ti0fTxOe1w=;
 b=VPNqXz6hmlfcqvjAyF8gaLmXuSc4yelEU2sQ1qKFTWISWKPp1XyMG5Fxp+IdGv/VYyUcUBJpVDAlRuBMnqalKbtODj7Dv5z371T5gsQgJeGnfYcu8EY7FXVxyeBt4htECh+tAy/62FOz36NRRK9xIk++us3rzuP0uAmlKNBFrNs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA2PR10MB4507.namprd10.prod.outlook.com (2603:10b6:806:119::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.22; Mon, 17 Nov
 2025 13:58:43 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9320.021; Mon, 17 Nov 2025
 13:58:43 +0000
Date: Mon, 17 Nov 2025 13:58:35 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>
Subject: Re: [PATCH v3 3/8] mm: implement sticky VMA flags
Message-ID: <13ae542f-5c47-4511-b0ad-6d1e9dcbdc9d@lucifer.local>
References: <cover.1762531708.git.lorenzo.stoakes@oracle.com>
 <1ee529ff912f71b3460d0d21bc5b32ca89d63513.1762531708.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ee529ff912f71b3460d0d21bc5b32ca89d63513.1762531708.git.lorenzo.stoakes@oracle.com>
X-ClientProxiedBy: LO4P123CA0085.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:190::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA2PR10MB4507:EE_
X-MS-Office365-Filtering-Correlation-Id: 8b28bad7-f901-4835-fe19-08de25e16b54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?mR8ThMtNgVHGj90E8EKLzla0bmyv62LTSPUxu8JlWL+EN128CyF6QNnlaX3m?=
 =?us-ascii?Q?yPyz5gQhCrfz//XZGjQFx/0/8IlyaW67hj9WjLZYKsPUL07HjJ1L5rn5bxaO?=
 =?us-ascii?Q?zWhqfFz52LkQdVbCjZlN37178OHntr99vTc5QbRZNzdoRmhsWj9lEXIEhhB5?=
 =?us-ascii?Q?Y+qdVXaYLiLcSvZUNKlVJvjxpiEDK4bO+k+cJYBwsFCtbna6M14sfokyEaKq?=
 =?us-ascii?Q?JiNT5MR7L2OX6YRQ2MSaJrx/Om0awbjw0xwbw1Nw0ZuCYHZgsSnQm7cIhuQh?=
 =?us-ascii?Q?6qrwYr47QBLB/QSoq/EfwhqkyxnvbowcpuGGQWR61mP4ExCqvDZ1P086Dxbk?=
 =?us-ascii?Q?UUzUDn0cX+jfEjX+j4lsK2or2s0JQPU7oY9MvazYWmELragIsRu3YmxLSMyC?=
 =?us-ascii?Q?tDgqHTmfCR/QGtXUhFi5xv1dCnNYEjP3RPwA1r9W6k82DISEOQOaaq0h35rM?=
 =?us-ascii?Q?tr0LtzauqlS/kZcwWiV05IO/dUpHYRBNTGqi0NFXPKbs+olGYLWhdJiSE5y8?=
 =?us-ascii?Q?vFvyMYSIjI2ArHRV3GtH1jNSQrUFbtrK0rbg26+fWjGSZFcz5hagaaCasDWO?=
 =?us-ascii?Q?sYsfKTm59F+QlKkh234FN2RvH8F8AlNqyWLetiMoq+n0ExXCV25dN3TFcVC0?=
 =?us-ascii?Q?VK13d4yKVN9UxgKMb8XtXeTRo3jiJPBjQfhQTahQezo9omBmd7s9SoaKrMal?=
 =?us-ascii?Q?KJ7TMj3YcIi6c3pY+S7dj7Kcq6EIU8xXS44Kd8kPXE6L7zY7DMVOhIOMvt1n?=
 =?us-ascii?Q?PGNqlcFVyB2msL/suhbYVld4/8K9S2dGPyfXzBx0Pg8lZGpxasBrPEX7pCCc?=
 =?us-ascii?Q?tKy1vHDWo/Bzy7bdE1u97swRFo1gfwtt/G/VPz0G4cnejNdg10ZZrdt143SZ?=
 =?us-ascii?Q?IdvAPeF4MrO1+a3zk3U2eCFVNh2uY4KHk0eiTLyZ41Yvp1Zg6nGR4VSvG4aH?=
 =?us-ascii?Q?IwfBQX+bmhwLCB+qiQU6ShoxAWN13QVnLmrO7/BlSeJ3zIYwOut5aG5WSXxc?=
 =?us-ascii?Q?64eqsum99ZQy/XNG3mdRoSqjxUiGVphGkEooVKSb1yA+r8hG525GL30PTfWd?=
 =?us-ascii?Q?Sj6I9u/YAWwA3JkTW+mxo0QOLojzhQs/XF5Ofmq6lHHdPwQni+HZ0xNIVosZ?=
 =?us-ascii?Q?8aHLXCMNaCsXScBuhvi0Ues30EAQ7gh1xoYLYgAtTTQ3q71SWAOik3/zPriz?=
 =?us-ascii?Q?HfxLUCn/q4UhA5dh91L7Lcn2vf9PwbOV7UsVuQjF5+uIdJUK8f7CL66KcoFw?=
 =?us-ascii?Q?yqpXrb3rfXUq2ugBHfroLbE0WHWG4pNSJoy9V+DW2xynmlG6CG7Tiy23AZYR?=
 =?us-ascii?Q?+sEsPxg9912nrUU33TVNAXIm+Xp8E+3i6i7O3c5CKO3Z4f9z+A/coygwcUYj?=
 =?us-ascii?Q?4+p6k03+lxfuP1XCCCw5w7rPsKUIJQYICbTIRDE6dbiony+eHSi2iq8uP9Fx?=
 =?us-ascii?Q?2jBaj4jgsfiSWhKFY6UDxVzh+EQI3/mn?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Qd1tmRGArQU4t3j+mH3wWhEy58uzj1ryhPCbdMZc/qIF8UmLUUFks8QhwMF3?=
 =?us-ascii?Q?WeX3MndOj1NuAoLTYLRAP7k+OWlRxDT7me4OcdyH3js4ImVLNjGKbopPcGA+?=
 =?us-ascii?Q?RPNDl7iFow3H56xws4TDKBBL3KYgWkCBE0GprsxCiWoeRkJ7GCBfJt4Z6nhP?=
 =?us-ascii?Q?98NOqG8mOqLuf+rc6o2Rb0ht764VWc2CMK7btT/GdhtI2mYvVvsNHHIc1ytY?=
 =?us-ascii?Q?wcDP15BNcAn4SwXwAoPOrGS7ls3eV0iyAw7UePMLAkZKuSYqu0EBCPfYQ3ob?=
 =?us-ascii?Q?PyQyv8hy3wngnHCi3Wu3C8MW7aPHwYuM9oIYG78vE4SGWJ9hjL+3kNeU/M3b?=
 =?us-ascii?Q?uH6+x+ul6Qbc69WthNEDObdMi/ubbnUBu+P1HifqZCzuwqB+6MZIoGOXFVTX?=
 =?us-ascii?Q?Ds7jxsWuIahJIuYPdXKXi88WumJ6WR66XrZ6cXjjJGV0MLDctpHlJhyTpxpn?=
 =?us-ascii?Q?33dXv+yOVOVDRBNgxqkGlCcGIlSPpdk3+P8uqF8TEquO2jn++ss4+gbgjqKK?=
 =?us-ascii?Q?qIFt5Bvb+G0EmyyUpUA0VbynM5TpIga4DBR9xOhJKSzqWAgGvTcb/PTnERNX?=
 =?us-ascii?Q?Y88VpMEuFiZpRmy5+jHXxRLASzIJgIjAQhMdG5ex48L1mu8/s3rnpxoh+3Cb?=
 =?us-ascii?Q?m2HL2PlULj/CN0YMq3EMxRRW7LWlsLr5zHbtHnlV2u39Qb7G/Da4hEb3ykJX?=
 =?us-ascii?Q?WUzgeKmrUZVbue9NbH5aojoj62KA+OR22tlnhV2UDhl+u88QC6WAY9MEcT4h?=
 =?us-ascii?Q?ea0juHiboCxlJAl+B9Xqj+/tV+s+Dp/YvJIopYcV1A2DQ1nU+vWwwkCNy2Tp?=
 =?us-ascii?Q?1foKO9q29g4fx3jOSLjUanUZ62h94TiaNMz3Isunz8KfGDf+QzLFvGbVNQBY?=
 =?us-ascii?Q?kPPeGq8eUh6hXDRVlyCzSZaJvw66SJm7MC2yiBfdEiM66AKPeAiQlcBIB24Q?=
 =?us-ascii?Q?I/+ok17VO6jj90QR/4P7szrmS44sEhhgj03zvOqoTRodQfgxNJvhMZfxZWad?=
 =?us-ascii?Q?sLR5DXD6ZnEsOgC3svLkZetLLWlzEdG2N3n0XVRsLKvuwevz3TJcH9wdHo5W?=
 =?us-ascii?Q?SI2t0Qv0PQjfxzNYJKn1xzO5ywS+U8NIhZZGDFJl650qgQl9TxP06J23L+54?=
 =?us-ascii?Q?3L56xaIdbKk3VrRyUuGlrFNXDbfV0juNzuAsaZ3uIhwmqxhJCiXxrx66y0nP?=
 =?us-ascii?Q?EqGKVWNFzS0KTTS0N0F0Xem2yAdZogXFBM0hra4nlL9IQveiv7I9f7wgDINL?=
 =?us-ascii?Q?iOHpL5A9UOpGC7tUl1AhaPQZDt0Q+adQX2fAcrhn9H1rwc53obN65lQ9+h1R?=
 =?us-ascii?Q?+1K+owUbohAC0+z4B8F2o3+8EFMOKAJT0lqayykVvfzvJTn3lFIYhgqZuQK8?=
 =?us-ascii?Q?1wrrgpEoTkbTyrWVLl7SIQ3GutKlCeljplcl2VaRT+7+rUrYeysq9Rqbf55s?=
 =?us-ascii?Q?O1NPV/3YNF631sXxMA4UkrPbZbW+4Tck07mIdybrHawk/FX4IUWcFwzbjbEQ?=
 =?us-ascii?Q?R+o4ubgTUSameb7EsO8vZMzWxCLWy56xyEpkjd4Awt+l3xPBL//M6+HDKBeL?=
 =?us-ascii?Q?ZVq7j7Ls3QwezplVVpG4mjrukxomVEVQO+5SA3t5HOJhhysfG6awVZR+W6hF?=
 =?us-ascii?Q?cg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	jgV7sOm0VLDSNamX2O/evuzrcNKGC0qc2bWMokQY6QvyYkDe7fD+R0mnlnHOW/fOH2bP3eX7Ny2DD2wtzKfrEXtWSwUu1y9/MNcp/Qri6aaXJwi7e1WNAfyE8Hk6eFwbY6/vQSKVjyTWaPHQVQ2RiUYkJ++zmVN4Zn8GK91sZg4SpXs5pT33vIxxVyKqfCOrFLKZZ50smWzvn8ySLoYVcO6XcJblxqu6/w/4GruOq8JfO4zUblbQ/cG7ySrw4WqdtraYfXbgQV3MDbsAcwObI9cZsI15jwmI2g0N30O3JKDQjtNARNeyI3wmbdqBR42wxyIFUgA20Fv89cph0n60NA3FsYr1d4FE/s+HMTcdHrCf9It8hb+Wt0oNA9aoAzExKro9Mlq4y8rXbE7xtEwEPNHUAnEsUmf5xzJSoOqJHE7R0qBPL1V++tFiPcKFIZkZqBEk4SGteyp28+6FdjjHjvNwkK9xKhdfy3o3xz2CV7g1jOpcxCPL8MkUYArLD1bpTiR1SS3lRorSA5N0i+FE06Jr41Hh7FefU1QcWbT7Dxm/3cHfWV0Wh3TRPNwRuJR/0FAyByqSUTuYrtd+3Ox0bCzs1yBDcGrFiL4xHs2nYOU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b28bad7-f901-4835-fe19-08de25e16b54
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2025 13:58:43.3101
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oySD+Qb4brMBcPY9HQGweVX19JKaV4iFS1TKdeRtGAQHhmRDZsbY1LSQdMcC+iAyel3hvwQe7obhFRVE0zSjoI9/zQ3A2he3ZcJlOMQYaqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4507
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-17_03,2025-11-13_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=774 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511170119
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691b2a18 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=LAZjyR3N21Zz2PLOVAEA:9 a=CjuIK1q_8ugA:10
 a=nl4s5V0KI7Kw-pW0DWrs:22 a=pHzHmUro8NiASowvMSCR:22 a=xoEH_sTeL_Rfw54TyV31:22
X-Proofpoint-GUID: slBRcbLiN0B2MF6dM1A-nH-jFitYWKTZ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX4ikvzE8NC71F
 p07a/c1X4AhaFnD0/sUesAV18a20xc8WtKsqtKdGUVrGUs2elFyvhOlQg3X2KNLPHHVdutEVmAa
 5RT5LE97vh8kUoBOJf40NVVZGbMeoci7MVnMAP3t13ZfZfu65PdfyAADohF8SydqQWHO8Ic/tly
 WED2GN0Sr5ZGznkPThpn7GOcGlKHLg5wpQAGpfvQtxuH8pbEemUL+VGg0UfRH5FqpbTLu7HsnZ2
 8nJHZRkmaYrTvi+qgXsF9GQ5Th4A4FBEiPfx1h5TWy2EFiMd5RXcn9YRj8pH7w3qDOUtxTUrsTL
 pfSrE06nY/Ox2mO+ycE46I6YKMc1otpaWpkKPRcu6+6oSPDFcoLqn8STW9giq0ciF8g0j3uE9xv
 Kgz1A+bYypm71BiSa/c7balAbWapVg==
X-Proofpoint-ORIG-GUID: slBRcbLiN0B2MF6dM1A-nH-jFitYWKTZ
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 27540C000C
X-Stat-Signature: hexhuqskjnpdrcy8pgrwttnw87wes4jz
X-Rspam-User: 
X-HE-Tag: 1763387938-263941
X-HE-Meta: U2FsdGVkX1+8OxMHMnpwQcAA+lfl9vj7b3Fk8vVY9oiQxzhzL+0iPRxiaPUymgPiJ3SJNDEL3oinyB6ph4BgQI4razR1CdNCcS8JBLz9paceK+uKr/jH+OK658hZG9BOnZWGPHeW13DwEt+dndGXvW/sVYm/lRKe4lb09AwpUL7fynWHizQMnWuoAgx1sbGXxxf4uHhXLm8yoYux4nu6F2+/9BRKUemuH4cHP2Q+eRSjZ8yldah7Yihot5J0l7lU1I6goRxgDM6YTXg1CRiKMbFBtkwTCYciKwtBL172mbgz+XnlkNz5JRyHizjVCacmNySHp9OIC3lpjv1YLunwYsGKKO5EL2HR9MrY9bw3EWfvgRr6xtuAzq8F+pkL0DcIgyzM+3OBLCT8Y4n9Y0cuN7naq119Wgo6dCTmgSYa8OSnWmDpMVpbwCOx6J5MuQFkveRVwcBSQnbREHTZxwSK4FqEXbZ5vsdKoQ+bZbOBQ12OKNOWoDVAxhW7gq4M61PwX/r3WmAyx9VRoAqPWmD56tWPLL1zOmL8JLOxq5a1Bekg+ePrj0zVj2frMeCV51Sdy8L6PK7BCNoOKzkLxtPkF3QW041T1TBYPet08sMI6Db1FMC0liFew69ckMhFKJSKQxhLQvjUxrCs/n9Zz7Y9RHirZZE6pp5WdZvWXNPaLWRXY47rzKAYeELuyAVxiBwWBYoeMjmJG1ASwenQdmPFwpzG3NKi7wBGzrzSE/pFyXR+pJuNUJj10MdANaC3a4uGtQa14vKDlGF1pEajbKLjyO6jUT4pEdmf4H+cwkrcZSVMBF5dhSxrDq0Wy7tHA4x+vzeF/feLLiYh3+B7uKHzVJRQNAdQwhQ0WNfbfLZPsAUIZHJHvNro/Rs2TVmIEfNtZaPoJYorv1aRmaXTdgrMJ57nYJ9mBCkG2ec4YH62cAE0jUOtwvLbuES1rMkhb9T1fWYtZUyC+qB9fYtCEb+
 slaftG3/
 JXxeh66ufksHqKMDKj/1A9EqTQelZ7RfVW0gBUZ37fByAtf+PW25RnyOdv2yGgb3lGHRqplJ127MpCPRfex6sgqDLSKN8kJJmtT0safZ4uuB6TzdDlQTWx6bK7oGCUjbT8h12PPnFyjsVW4FYTrEYjf7A4LMKjgBdi5p099pLiA6HuaGQ7VMsXY6Wi9pUGUFvesqI270Dyb8obwN+EvjAT1czSBYxYLN0S8EjO8qiF95QnaUkSQYIdSfHcVjtsqFGZbC/Wdom8loF93+L4ZIj/QAfKuHXgtnLnMHW8hxpOK8gAjgQxZudaHJhLfr7UPmJviIj1fhCt1ih2c3ayQVUR+GLUvRjJVIWpT+z5ytIA8Y2qEkZU17PFnOOdC00+7aB+hqjvyPkFIFfkztm6b+8xTfzr6CJodFSR/bWaPL7Uo6xuoVqyFjRkiv+PCLvbUrXsXsZqmG4Hw2WkuXWqQnB7N0CA3y5LEOsMlbDS6/ooget4/Z/kSqKJuLkyKD1e6ENzF5JIU5myp2Z74U4+jfadHehJY010DObGcQrpn3qqMGf/OaGa4cGDaO4CrWHHqe49nA2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

We need to also update those callers that unconditionally set VMA flags via
vm_flags_reset() and vm_flags_reset_once() to account for sticky flags.

Please apply the attached fix-patch to fix this :)

Thanks, Lorenzo

----8<----
From 15c8661499f118ac8d422a8344c8017f24590ad0 Mon Sep 17 00:00:00 2001
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Date: Mon, 17 Nov 2025 13:24:37 +0000
Subject: [PATCH] fixup

Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
---
 mm/madvise.c  | 3 +++
 mm/mlock.c    | 3 +++
 mm/mprotect.c | 3 +++
 3 files changed, 9 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index fb1c86e630b6..e651675eaaaf 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -172,6 +172,9 @@ static int madvise_update_vma(vm_flags_t new_flags,
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);

+	/* Account for sticky flags. */
+	new_flags |= vma->vm_flags;
+
 	madv_behavior->vma = vma;

 	/* vm_flags is protected by the mmap_lock held in write mode. */
diff --git a/mm/mlock.c b/mm/mlock.c
index bb0776f5ef7c..7455a1f6a98c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -484,6 +484,9 @@ static int mlock_fixup(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		goto out;
 	}

+	/* Account for sticky flags. */
+	newflags |= vma->vm_flags;
+
 	/*
 	* Keep track of amount of locked VM.
 	*/
diff --git a/mm/mprotect.c b/mm/mprotect.c
index ab4e06cd9a69..145417471201 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -762,6 +762,9 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 		goto fail;
 	}

+	/* Account for sticky flags. */
+	newflags |= vma->vm_flags;
+
 	*pprev = vma;

 	/*
--
2.51.0

