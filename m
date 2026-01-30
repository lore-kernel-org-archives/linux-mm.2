Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2A28E6BF3B
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFB6D6B00C1; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4AE36B00C4; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C116B00C1; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE046B00C2
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:01:17 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36B4116047F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:17 +0000 (UTC)
X-FDA: 84389850594.27.0D95C4E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id C74F540009
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:01:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JPc3j+Cm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kvcryKoN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806873; a=rsa-sha256;
	cv=pass;
	b=PyvUpGTMkXBmEmVlS2EmFgfTZ5yFSUqY0gTV53ebi3gYuMaqGIowKysw8cSHAbqdOjpcrI
	i5n29p1AkpcOH6R4wekhw5Q0IX0hmT208oVuixTOmINl8ZuC1FknjPOIL+6JgBDrDO1jd7
	tdhTbQ+kGZ+2TM30g0bnkW4fqLj6Ulw=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=JPc3j+Cm;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=kvcryKoN;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf12.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZLwJevaMWXDFxxnCCpFIXoCfds/6RV8WV3DvXjTdOw=;
	b=BMgHFLw8ahR7xvs/fTtCOdRQZwPK6A5AG/7jyYWSjjTX+qzFdYMGbta1CuHpQCABsri+XK
	x6GcZbcfYyVuchRrhpVCAaP/PCtGtI08DI4ZZRhWLYctvZysH8tHjwXIr2tCI7Msa000yf
	3SFT+c04o5cfLPSlWSqH4h5usi5SWjs=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKEX5k610898;
	Fri, 30 Jan 2026 21:00:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cZLwJevaMWXDFxxnCCpFIXoCfds/6RV8WV3DvXjTdOw=; b=
	JPc3j+CmEF1Bp8o4djyKk+ugUz0TtRQEWnGU9bfjpf1YilUzwOXLQVJmFmfWZKJ4
	LMG6ucg2r9mXrA3HspyLfRPR88k6LhdfNbJhh6tctRbB5aLN0K181ts2WcyIq/hT
	BWMxtyvYDpHdp3TXWwv9qSOwJo9kP7WF8+rnsoenn5Rj5aAplzqHAnp+8QTIQArg
	waxxFQflpSGyng0GuIOlUFaFB/A3lY7P/Ydg9Fq1vgt1a76hJa54trxAyBuwnnum
	Y1yQ2Go5FT4Yiv56h4aLjNAGx6sphkjeqtUoZCvWWDGDh+GTvsT8KfBMKexn4aqm
	vXRUCq/5r9i0Iz0uYN6kFA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10d88bpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJV7Bt001764;
	Fri, 30 Jan 2026 21:00:55 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013009.outbound.protection.outlook.com [40.107.201.9])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhjqvgx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=x5ftklkvlTfatNTKcCCCzM7PD18R+4FdoDw3amrF4DV3PWr0yfC4nL7KYQq+p3xO6lnWZ1X89byAsQQqLKf7YYqt6fqIDa/mYe/+60QdUBb1ajXwwbDRPaw2Z2E/FiICsz7mDWXe07J1nwYaDgs9GEM8hQCMwGKUy9Q0b9zGkYn0oKFGj4jYcR2b3Q+NKZKfti4DnqmsagmDAwkPlHlXiCC++CNFhUPK4X5umVLTP7wz8EHf3irvnlAuKxle2HqNWHqkaQ2Rq9ws+6THbguw6hzZ7hkdp0vsO7exDUulvzH0X1aHHZYZHAMY4jNOYnhPH+OJwUjC018K4HUWuuKhnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZLwJevaMWXDFxxnCCpFIXoCfds/6RV8WV3DvXjTdOw=;
 b=kecG/+zIx4AeNfvy7/Qytz1kdM4IkDgq8e90VzIY5R2RIbXTwiQOgvq1DawKwS6O3eAI7gznVQLRc/7G6sxNRg8RLEBPgYP3VZmDipeaN8sXU2UWyyybvtyo++Hbkoc6wDrKQVz/aBOPgT8pfRu4vKMQrZiB7j94qf3ZdG0PzXzcGJgWUMibdsJvOXymtD2LErXEIgcSA+f9wtu39Uwo5ZTmovRI1RiTHl6R2Z3kuuic3VqLO+wMD2AaJfnVyjTH/T88QmslWnkVpDW7m6tlIgMmZQ3bMVl8WH+ue1CBWgy5OnCiB9eSVPsqp63kmoouERrpmUv2DxOt11qYNq4Qgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZLwJevaMWXDFxxnCCpFIXoCfds/6RV8WV3DvXjTdOw=;
 b=kvcryKoNkf/h32Y64gcSxpIXuEWW4qwoZmbY9PtJ84lvxw/6VQh0uONfgBGkuT8q8uxUYK2wDfM9H5s/6KPporaKETTHOhFnEPMCHDIkBLNORKYI+HBcNYAMMPfZQDCiruveI9ot3rgiG3EWEGeWVoURzN4AS1a32Rv7LGmMwEo=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:52 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:52 +0000
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
Subject: [PATCH v3 25/30] maple_tree: Add cp_converged() helper
Date: Fri, 30 Jan 2026 15:59:30 -0500
Message-ID: <20260130205935.2559335-26-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0414.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10b::22) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 4142fced-790f-4e2c-4789-08de6042a772
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Gj4FJ0fAOTH/OadcernX7DkyRiaFTnyCDYl3LmplVmAqS3lGqvCDS4RpEWKR?=
 =?us-ascii?Q?276H7UE03lyBUzZNOH9trPFIkFf1H1KO1J790ywvFBzZvyHRk/7RmIhGx3mW?=
 =?us-ascii?Q?drFs3aC0KRbxd9L2Mwkud683J3tJpoJd8FHwAatZFI8n70XyViIPHgIEJy6H?=
 =?us-ascii?Q?u224hIbyR9dQKTzJb0IJFRuoUnUojAUZKWR3RDSD1ZnqhfXJiCVp3NsKX72F?=
 =?us-ascii?Q?j1WUqLjKp0u6i+J65DqNe4DdQrvWdGbeBXtHtn2aFn8hKjpP7npDyvuEUked?=
 =?us-ascii?Q?9qbHkSvjGgB7+1pmobZgYrkjWOitnFvbRQKjYX/tTGfHAlNCHzRnzfGRvvEl?=
 =?us-ascii?Q?NCjFkPccoekE/VI5wK/hJORzEIJQhSGRe0v3YZXpyXQLaqyHm6IgYupl9+F/?=
 =?us-ascii?Q?FU059u1xTJU7FJq5OlPsszijmLszfprlwCa4Tm+IxSfUSOw+HnGVXzVIjOaj?=
 =?us-ascii?Q?lNUNSlqr9g9ZAm556vsHi9W5EBXWloLRjOas//3/x3jj2CAZpJ/8jQbT+EHm?=
 =?us-ascii?Q?ZGb9lX1WYfSmcU38tUFvfcUEUbMSRp1gxLPgfYvosnAT6V37udjEiW3byGC6?=
 =?us-ascii?Q?rEUcsLqajPPPZumfFOAPu/XrSGUeSChav3iS7so3DXdKFCSqz7NXw7/A4zmY?=
 =?us-ascii?Q?ThtDADNS/6Lr56lw3aSYw1CMjqTTfT6qJFB9mhqs/eW9AFh6nmo0vkljj7QT?=
 =?us-ascii?Q?oLvTor3x7f5x4Puw6FWZrMXN6N/l8WkFf3jTNTpgUie1zuNZ8P0ofeuhPJCy?=
 =?us-ascii?Q?4wKBTq3RQLlCxNwV6PKDh1jLaC5JbjCQH4Nz3HjCnJRpdOMiRsm2HE1Yj36S?=
 =?us-ascii?Q?J5KG2zPph9BKHzy3TrcLRDmkC0ZHhyPV1rihyyRMxLZIphfsLDQLZ3Dliazc?=
 =?us-ascii?Q?HTjPoKyM6KRQ+PjTwPWZGUQCOGK+CI5Z+SxlKXLTKhkQG7BrTScJu9iYzJi9?=
 =?us-ascii?Q?tbdrvCJmwzvd7nHXu9oi8AusdehLQa+183PnujUJgwdPqS9pmVfoMs4pWnXE?=
 =?us-ascii?Q?W26o4UtKn2hxblIY5eXNlPscGgp8NIf1kI8gZRSqCCmAyWHJbqfPG/BJv9k7?=
 =?us-ascii?Q?mjUIQLb7yZkOwUiSk6Xi7Ncl4uhznfmflBdgpWF4PUQKeewWqDBAlJjTclJ9?=
 =?us-ascii?Q?DM5lIGBzN+UQrGDJVEDakSMkjQuFP0i6+IQapFr3yb/oP4OLWlhlqqMWe703?=
 =?us-ascii?Q?PK8d6xoAQweWSLHILnG7R6qjmxhvM6Ucy1rZCtaS3yH8lJiB9QZBnEbzcGxW?=
 =?us-ascii?Q?MUkp2b5wCND2AWWYGFtQjHywxOXt7NoATdzeroFEebiUUe3jqbTmmebbXJbJ?=
 =?us-ascii?Q?aUJmhTnvcJ9LYFyYmJ48C8T8YHgtRgmHpE24w265x7aZjdIycuYnqiwNAgok?=
 =?us-ascii?Q?zvWzsV0laz5w+LAjwiKwzx3LQuGuIoTSvsy0WQDrhYv/NXKSv5VAQ+wKL6+F?=
 =?us-ascii?Q?LC4pgR09gXv9yOnerIGtfYnKQ8uzO03nwctlPOGl/hgnOUCgV3h1APY9wtlr?=
 =?us-ascii?Q?arQTuq0Ms5QrBgRMXOLn80/JqhHYBm5KU9BSb7MwnyQUFsiPyDenQbwBQH5A?=
 =?us-ascii?Q?1Li9r3yu1uO3Gu2uaYQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Srd37Zbok8vsBeto2D1LD4L2xwOTpf5mzNEe+xSJ992LiV67pgKngI/Q0MyG?=
 =?us-ascii?Q?Rzmilr8p+bRC8QTsvh53BDuysjBVRN59y8mivuSkTOu/toVSXoANhA6eSh9q?=
 =?us-ascii?Q?cMmI+F9A6AIyWJTfn1FeOzXWrYS7f46ctxEzS9Ll9t+LD87Y739wcjGGkdFp?=
 =?us-ascii?Q?1iScYMaRLFV071PDGax8Ifd8NDouvSsR5Vu5Cz2g//ZtvfTDq9VV8x7Nw2u1?=
 =?us-ascii?Q?qUNZm1cmLcmOJHxSJObkVJ00X3K411MiwaYsCef+xaVM/kDBYYNr5vojnZpX?=
 =?us-ascii?Q?kpVv54X8gYp0+v41/BqQ2zG//TBPXIqGhJ6X6pOFHjr7nwYUvy3V9vi3B0Ic?=
 =?us-ascii?Q?FpY44TtU/Vl34zAcisDM6YPTnxHUpOnW4P9H/LYjUlKcnM4VLGcI4slznnVp?=
 =?us-ascii?Q?IUCBX/4xgdJaiBcxP4MU6XfPlCCVYnlpsY5s+mzR2Acln8b+shpzUhOtoAN5?=
 =?us-ascii?Q?doAVXBeUhB/iU+RvE3EbIXeGQib04ORsv84aDNoKNCv2a4z9vm4RH4ReDUF1?=
 =?us-ascii?Q?97H6Gu3SWYFWMlZVADp4JsrQxtnkZ3JqEngsTlZGUMcsJixM7Sa+kiQ68tMC?=
 =?us-ascii?Q?ozIuG9iU0yD//MDhfoDw0vkjO7BJbHK5FMds2/VQJShMv+hz5HSg0WpYdoIR?=
 =?us-ascii?Q?Bf7S0wZ8C3rKIFlxf6GwqzQMvL/vKzwaNPUcRts/c/PuInmOO7cnffNYCYGh?=
 =?us-ascii?Q?bQrqRhETIbX1O6K9mBpUFN0EnNXSFjuS1ORQ6UxJZbCGsL40pP70cXPB5US+?=
 =?us-ascii?Q?clYBs8daZo4EZkzmwdSzD6AQJpKuoaPmJEc+4Bg9Gs3AG6gm89UAUjgxZAp0?=
 =?us-ascii?Q?t0609beGNoEDg5jvHSHS/HSc9VOWtmaprJ7CJ90h4auHv3Ycxg+BsvCoNLyK?=
 =?us-ascii?Q?MJG14RN1FxLDDc47ruQCh1SmLg3UkE/9TrFP2xSQUNoGGWgY4Et/UH1kbrOP?=
 =?us-ascii?Q?/2i0BtC2h3+jJuvYwijKR9f5awK6ynV2N7tu/sM07pvj4Wh+9C9/PqBF+1Rr?=
 =?us-ascii?Q?HvYaAAHQMRpxWdlOf6nEKy8ebwrNgiPknL/3COx4IeSgRhFutPsK+ogQlPt6?=
 =?us-ascii?Q?xjE/daq7U1KD1NJJDD4tkZs0A2+RDBjQlJC71jX3i5i13Gho/bWOZpcKDzEU?=
 =?us-ascii?Q?6zZgg2M8N0wRaq9qyOctTj386oLagZwQVwj6stKbaulETxUE9jVhjFu/2n1g?=
 =?us-ascii?Q?SRDFFzINJToduyHTABE/5Ihk8ZUEUc+pObfaXJG3kSGjiAvVXXCNHu7RhJZj?=
 =?us-ascii?Q?FQY8fIsNrEuPy2heJcVnBA66EScoQmdhCpUnv6PZAn2k9+XW9s2YbfHkF6Ku?=
 =?us-ascii?Q?5YEDY/BZtPWRnTaEUjZH9qez/NhVDt/wJ8HXT5a/mJZ6ptggeLUlq1eWCXXr?=
 =?us-ascii?Q?K3qhCEAWu1Wy2tuZRFTktlUnDxLobKh/Wyw96wNsaa3SvKAxSE//K8D1bXUU?=
 =?us-ascii?Q?5X0eSC93HBMP8BD9h7M7/Oc3Yi14ZzmoZsafEdRiNnGnPrskwz1QJ56+BDFV?=
 =?us-ascii?Q?l9/vG9i5VfYPVdzL9Y8KMrNmQp68AW7yUFFOymgYdtiYcvFOCgeazzdcsPS/?=
 =?us-ascii?Q?Dmo0wjBZLLMpPFetoeZz8IxMKYZYJ8ErplbGiAZyFFlJVAYidLw7KAFVdaI8?=
 =?us-ascii?Q?UEwsqE7hnymaKSIwS7rfnMFPuZ6pg3ILl6RqgSC7Z+2lqPRNNpGHkII/vm4z?=
 =?us-ascii?Q?NptqGpwxxDNGWwNUHRKjU9nlKR0QLUA473/rVFJEOQ6L/2wXAtp3LI+vnaFw?=
 =?us-ascii?Q?YbwFLR8l7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	PLHzSSPozKacIO2icX94jcp6/mL1u+/uVkmPf/cuQ95rLhNbBvBvgDV0fMPHRcqegg+6SnpbyFxMDGneEYouo4AI00UB229irkwXyGMJ7CcHs5+1wkeUM45rAqe0iwE8dyCFKhKYJZYo3/9nHjNa4Xqc9NnA6xyY/NP+2rd8j4UO/lIAbYKI7Zu6mktbuGWsZKlyhFIKy41FUT9jjLthWQoBzxfRrd0FhG7Yl/4GesbIuAnZZcTWckLSaoinq2KdTyYtxQczhRl6CqBSinPK5C+ssrsaJxmO41iHBmaCRGqzR4jUAWBuf/oWqWfkNtn76Q+uCIoMLcLU8HTEtyYDbklP3d75hFC+3UXTGySXvAidILQIDWlS0W+kP9G5Gd+q1mBpuz+Gj0FYdbsPmhRL0V2UAZmhWPVq7Rzl3lyIVsaRrkg0U0PnyLNa/kiTy7+v8+l+bEkRQijNWPqvBNBvT4/5IhPVRYLhAYoAvqBhAvAnjG4U09AbnpoKb+2KrrDFssO6kX0VM/P8pPvraGxWrCEokpxnq8wtxMVRIiGG70zw//L01zUa+y3QK6h6VDAcdOctdOUK/RM6MGcjMgd5QEa0ElsqE18hn4MZrnEa94o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4142fced-790f-4e2c-4789-08de6042a772
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:52.7464
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BdOLQnYigWssoszjIsAOQv4lOqIstelSyJ2bsZOAoYVRQqZfw/QrXKMBzkJAUkx8sggV+O9D+0mHH+2T2llCKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 spamscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-GUID: EI2iLiMAnfcfuT1xdoJERqqAh9HdtDT7
X-Proofpoint-ORIG-GUID: EI2iLiMAnfcfuT1xdoJERqqAh9HdtDT7
X-Authority-Analysis: v=2.4 cv=YuoChoYX c=1 sm=1 tr=0 ts=697d1c08 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=MoTMpwtd16bSVnSR3GwA:9 cc=ntf awl=host:13644
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfX3uLmn3JpTXQ1
 uA9WPggPmvMrdSKNh/ZsR/a5+BHeXqv/nVS2DihPw138pDXyxpeIV+/Qs+j7T9nGaf+UVklxf8S
 AXVaCjZ5JTSpptQyGyfoGjPxOJrs9PC+CtQHU8z9hBZwEerMg95yWAwiFat6ndCEtwu6drEmN9T
 UYDKNq6Iix2UG91TVjdCzqr8cS0dI1lFP89tjOk5wmRB9V3Jy7TFNtB9z0GC9Im8zzCdBbXV2Ul
 QCTUDehPsQVIjf1RA+om3b3PJlCIUJ49iHkj+UezMnGmgegNiMs/F5lIHyVOP02vg0b6r3tCVJD
 7njpzNJUpx0pWlq9fDBFmT1813f31u60XvgAXK7kbJgtdZCNjn0+qwoIvarDSM5rK01wbIue8L6
 BQ6Eoh3G9DudsfqjAvX3grNuPHbh966BPkYnsoSQpIulljNnWPT8x/tp1N94V+vsfWvPtt0BIz+
 XutMp9BmH0udz2FmOFl6Fz45elw9vYrGfu8uv2WQ=
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C74F540009
X-Stat-Signature: ogr4utxytupkam1q59j7hed3d1poy5r4
X-HE-Tag: 1769806873-597875
X-HE-Meta: U2FsdGVkX180OE35yRTU3gl/QFfP9j/2jiPD4jTw8+ruzjuRKmTUoESWnIihffeLs6HKbynSeihOO6EOCXQFNZ9tRGYKhGtfqJxZKh27qX9xV9hTFcIjYQZ5wXYbnYByln3rAY8qNYrrXOtsdIQ/Z1Kddxx2rjUCyHZBC9ryMWmWEUMvE1qMZNBBQ5bdQjYKaGxhhjeZb0z8gd04ah5i88QKU9hTXewZK4nO975UMi0Qw8aFGhhqShViDhKXrHzqlpd9g0yQ9741njc2D6vcR9hgGFHPcnvQM7O6VYwZr//LHyrPOXLrGHsozZKa3dvj5YDhbUg4srOHZ/iGMHTTRbUQ+lKiyWTU+t6SD0wfoavxFn5mgAN1hLA6fkh5yCI9yRcSsxqPJH9xFfTb3Ib75I5FJV5+UWrHLT+1JCVdK3+ZXtGM1dm7LHYmNk0LxFjHUNKlPTpgsVKopnHU6J92Zd3NIqhTfUV+V+OEpd87rzjKw+Ug3zsrGku7ukN4K7tjuEafJG6MczmCO+11FAyguC5yy7wTrjMIs5WAAUEvFmh/ePbzUw7yLRxtMdoVPIzMfx764OEjijLh7tBYlfCPWf3dKHLrlbJKii+AQ2MtWLbey0NY95uuNJw+br/VomJQja8QrOGA9UkyV+xQ3hqKX64JxGC3CzVwwLgVxPTPPf6ZtMX2mRig7QlqGgRgoktwT3Cpfojk1fcF4BP0j/T2jG1ZtR6pIKrnmj4Al6QlnN43UO6raRpvdoSM4tn4VeFAwYRerqhLHxFDUll4VXPTP54nPP68GunOUS+iiQ4hmZw05aihmbAxnFfeO7r4xHEO6oct1limg2cn1vnO1SLAETfme6QJtZnVMw1tgGjmL/GgRdf70ECv3Cb8KOrJDCr7rbLTifqPCg+t1uOZVJ2gi7sg8NaobZ4WAvl7IyCp2ALKy7aE3XEtwcPbFxFQpRrDrebxuL6IQQNOS4BDG+o
 u6Bc8BEw
 OX6aunVwukTBhwSOJ8zzAzTazg4LTFAQkBZhN10+qYKk2LhGShXazBo/MuZ1ujipnVTS/qYB1IvIOABT1ZEN6rDGFr6nxv4ct0dEudJVGPwDPsaeq4R6WslJa8KXiKuWa9S72CqtMRs/3Sf01A2IqYMqCe86f6vR/iChraB6UhVFz5HOaCC8K5mpUFGv4IKs8ilCW7votfKHMbrPx6JaptFwFWOMvEiH7SncGx/SsUR7+Vj2JqpfBLVzLOhCGew9fVlY71le8G66/XY60wXxiQJUIltJdzofzMGFR05dMqj891TzfJ2To2QqbxdHb59ZFDHkjFBmSIPLeTEdB3KXFwmkxlJHbLklGHlIE/d17uoYUQvLg8FLoRUBQbv3UI1KEr7HI48fvFm619P8m+w0pbiFNBFzLs+mUqlk24tVeIQaPrFqaG4wdt496hI5wxK4LQklZb2cG/nS+tez/G1FYyXfo74mUqO2mia9ZGn/8xKtASGWV58SAOzDn/dJOwOFqbCenr5HFYyPTRuee/Oy9BWXSUmum/Vg/yRw44SE7V0Sip+XqbepE7cgZAthybUwWzY0zIKMrTPompwDdONGvI2w2yggtBKDzK1dSx0EbIlhyBmL5M4BB5YOVVkBH6VmNcm/jSJNZM2FZdYGSwrNUUIg+UblN7og0LYC6hPT7E8hsbemvc59po718hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the maple copy node converges into a single entry, then certain
operations can stop ascending the tree.

This is used more later.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1e79dfbb024a0..f04989f8a115e 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3493,6 +3493,16 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 	return true;
 }
 
+static inline bool cp_converged(struct maple_copy *cp, struct ma_state *mas,
+				struct ma_state *sib)
+{
+	if (cp->d_count != 1 || sib->end)
+		return false;
+
+	cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	return true;
+}
+
 /*
  * spanning_ascend() - See if a spanning store operation has to keep walking up
  * the tree
@@ -3575,10 +3585,8 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	if (cp_is_new_root(cp, mas))
 		return false;
 
-	if (cp->d_count == 1 && !sib->end) {
-		cp->dst[0].node->parent = ma_parent_ptr(mas_mn(mas)->parent);
+	if (cp_converged(cp, mas, sib))
 		return false;
-	}
 
 	cp->height++;
 	copy_tree_location(parent, mas);
-- 
2.47.3


