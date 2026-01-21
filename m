Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CBC8C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B666B00E2; Wed, 21 Jan 2026 11:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CC3C6B00E5; Wed, 21 Jan 2026 11:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9686B00E6; Wed, 21 Jan 2026 11:57:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DC0016B00E2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:57:49 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A95C31407E5
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:49 +0000 (UTC)
X-FDA: 84356577858.21.42D9EBA
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf16.hostedemail.com (Postfix) with ESMTP id 28AFC18000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:57:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mgOrf9Tl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rELcT5+b;
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fmuMmBTqiZKI+fVfWhfAWV2tRHKSesJhQgb8G9HH9HM=;
	b=o2xj6b+MzRaSXCH1O/29hYKTTwEzk3+QW1WZ0+iJGUaPKpmOjqHmCX7ndRevQZT6Udx2p5
	8f/hrOA5u4aOIshMiiwAvGrB4iygnKPaf5d/ZKlQSte1HPFVqFqGmNMCerMdOLMnAh/g7z
	r4QtxWGRGDy5LUJK9O4JoGE5lshVV3M=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mgOrf9Tl;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=rELcT5+b;
	spf=pass (imf16.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014666; a=rsa-sha256;
	cv=pass;
	b=bkLgQFVsp+d8dDAJzHG0ZXUkyX+gwxnbsuH0z3nc3cvH+W10BeqfLG24GV3A7+ZrY6zav8
	Q9tqD9rajvq1WHyFCpYR4NA7+z9HhGBDLf/2otHhIUAZaKmNiRi8tPdgtxllu5sIHWjFjJ
	JHiq64yB4wupNu/WGN8lKCVpXvI7384=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LDUvN13429899;
	Wed, 21 Jan 2026 16:57:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fmuMmBTqiZKI+fVfWhfAWV2tRHKSesJhQgb8G9HH9HM=; b=
	mgOrf9Tl3DxdovMnkgcKWStMfQ0XNK7U8mZv9RrsPT5dayl9lOwJMlsBnk3qIIjw
	gzBtXHw8JO6k8r0+49oTv9CJ24XLdMvP1p2LXWltE6gI2qHjxhrLnfkAzN3hVNib
	byoPBrpYRcCLplHGXoYWr62VukSZKYIuZgXA0AdKWGO3FDC3bGnhdXUm2pKJVZ0d
	KS3+3AkL/VLEVFb+zhuhUybCVflr8UftahLFyvUCCE6BaFe8584MYyZqZyBhZ4Gk
	QNfv7KJGQNEE+P3/A7kBPBCRz294nMW8FchtrUean8oeosmnZKKvjCRqXZ1jSyOe
	vcoy212IUrHd7mPth4FQPg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5p623-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGqYxH008425;
	Wed, 21 Jan 2026 16:57:31 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011070.outbound.protection.outlook.com [52.101.52.70])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhtc9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RomoN8aP09zCZodHCsHQkRyyOE6itcFJFdG1yjiXtOfzBdpW5JgRhB4FAFz6kp+W8v9DMjq/xSSbBnx8Hkuk7h2wGBz6SYNdUlz4xeidIPT1L02hr+Zo322PcaUGaydEF3kbFGjE0Ocil1gAwGw5mMyVZgTMVkkOxwggk8ZAixkw2vfc6hjrY2N0vnomJaj4vMzs5igsEFSSC9WyqnksHaHbuMh38M/qKFnFXJgYP0s4Oe1Rqda3dgnI2H2EKGYfAn2RYTDcQsI2Y8t/Zw7KxT/BkWvL2irfs0gwqA3Simvmu36xRBX2EmnvI6qx9bhk9TIHu33buO6M8CBxtxxFOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fmuMmBTqiZKI+fVfWhfAWV2tRHKSesJhQgb8G9HH9HM=;
 b=c2UdE7ZQeLi1rsWbIlhVszxwkfuPPjGREnIVRWNW20dctwmAHcRg6fIgVBy8MAMxGR/faDeEDVOXJrkfSV0xLLwxyK2fRFfALTDLjb80MUBhLXBTS/LPdEuHZxRve0xuK8+CISmoA6uWayBdbge0kewzCjwb+8yLyLtrVnCQ2ed3VVcE8YB3gfP6MiDeveY1cUijZ/ERumzK7+rkHDSihQgR4MVM9d1p7iDmJRG7v2bKeQvmhuxBawfDCRM21q0D6lekybU50H9hQE95+yxwMhaRpZGPBLUOkVFf4ZtLTHVW9UqQktl8FmplVSccANqkWS6oAGKU4qPo85P/4oSTGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmuMmBTqiZKI+fVfWhfAWV2tRHKSesJhQgb8G9HH9HM=;
 b=rELcT5+bDWRJ9fj7BiKNNj1p9Z3mxGBMGTe+79aQ1DaLMbqY4vmMWWITo7et7R4/dcbFU/mEkXysg7c5QgjAbye/Qoz+KU6vITgBdN5n84BTqwLiSYDvLjfhYGPXC8GIeTqHp1fDJtEhgaqTxzoBPlaf4QsJ7eJNzJ6zXKGTE4A=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:27 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:27 +0000
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
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v2 20/29] maple_tree: Separate wr_split_store and wr_rebalance store type code path
Date: Wed, 21 Jan 2026 11:45:17 -0500
Message-ID: <20260121164526.2093265-21-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0211.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:ad::14) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: a4c97f23-3f4f-45c3-0002-08de590e285e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1M0k8nT3qUiXZGqmRRqqvBOv1/1+VjrnYY7SBDzV8qkHa6/yMHQC9NJpSciY?=
 =?us-ascii?Q?XNBIhPirxFZ9M1S+VAojhx733X/UC9x/JW2p0yFsXin1TVGo+Uu7hio+1GkZ?=
 =?us-ascii?Q?ZPZ8vGXvh9BRzhGLn5b44lOK9kn1msYr1BG2l0KQAvkjkWzWoXD8wQTfEpPp?=
 =?us-ascii?Q?iHxL3CB6rMX6RyPN8j2MuDz7RRm4foHyLPM8eBAEm6FlJUBOh6NXxZPDD6+j?=
 =?us-ascii?Q?T1U3w0hJc6Lgatb3aOY5TH+WqPOimJpKRt0m9Qoii/swxFRxHDZdHedZrHiI?=
 =?us-ascii?Q?MnefIZlS8aBfP7Ypz/wVSH5wU2PHlImBUwAxPM/lqUJ0g6BZL60dw1Jiq1i2?=
 =?us-ascii?Q?Hfpr68TRlWT0yd6Rh4Lfx9x/pw61mbPwrCp8QRtkMus7CzaQKmWRXgYT7nc+?=
 =?us-ascii?Q?u0nirOWrn27//vt2PbUVComM5590KXdHePsfLAPtzxCIN4GpnORjNLV3kMZc?=
 =?us-ascii?Q?ZmLMQxarU4MdI/96IcODdJjjfYSqXhCDeGMKXVfQAWjAtCuOSFD13Hpckzx1?=
 =?us-ascii?Q?kIfnaM3UzIZDqfCLs0PpAmti/i2EWnulbEIRSNA6xEPSbz8EsKERcou2k+V1?=
 =?us-ascii?Q?BTF0kW7s8XuVA2K311BTPPvCxAmxNUkS6uHh4yNmcwyxyl0LzPnL7o4KhDxw?=
 =?us-ascii?Q?UcWr/BC4NDXEgI1JYeZZ61puMuZRYOyAwpivlesElem0ElaUQ/6jAEvcx3HO?=
 =?us-ascii?Q?bwMG38vhFj7FXpoigsYy3blrXrxTocgCLI2ENoxWanHsF0cjdwP58VYuImlk?=
 =?us-ascii?Q?D9FHI0tL6VMFFftnBe42lmpNCICBVcHw1xeTXVxw71v6kjunrwFo00vg4oPN?=
 =?us-ascii?Q?87vIA9SSNvZIgu1/GdY3u+xgdfHpdwMiTdT1wdZQ70AxQOjH3kutmW6DA7dx?=
 =?us-ascii?Q?CdQgX3nGznXmyGeYPvsZ41fEjK2/iM4S0wIp205h8zUmy4Ve7m0OpnYaKspr?=
 =?us-ascii?Q?He8hpPva0ZHUifY3lHiBwGLy/4zgZAHssvatR0c//7SJzVyopzaJKRIYft67?=
 =?us-ascii?Q?hXG3mJj/22JwkmULoL4X1GwNcQzXB2V41E+oaZyraq+IhAvXPXcPmf1ym8od?=
 =?us-ascii?Q?fTnDcA50ldtnAvWP+kkpBby3nJ5yKad4psUoTyIeXdVcZx0tWgTEWr1tUuyi?=
 =?us-ascii?Q?jn7NTXC2ALJIq9xwjhKKoeeNU+TrEbfS99BfvhzV/8IpntvvC7yZ+DRCLncS?=
 =?us-ascii?Q?ZbYE5JIM2Yx8h+BTXAX6qOTocGnfHlLLF6SACrzoDTVEiJZKebUd8IP/+hsN?=
 =?us-ascii?Q?vggEeDImgTsu/0cpdASDFtjls50pHW7lSy1kpeF4e+P5dsj7YRORxjyCEdaq?=
 =?us-ascii?Q?P0e3T/1MwSjJbnoLKiDYagcL36ljLCX9iiQ+SFtjHzFEyMAcWAWADux2d0pK?=
 =?us-ascii?Q?qetDboWuZm09L0wQ/J2oKNvM5RfZ6pAIHtZY38Se+T1JQpEIwpeaKeLMvDnn?=
 =?us-ascii?Q?lhBlmOFPFXnoENccj3AnPboxWDTAheqzcAAKvjL3crwBqNjdtPKAv6EVN6M+?=
 =?us-ascii?Q?skGcZwKrP2rtomB+NER5PZ4wdpTBUfc87y90Wzo8cijiVAf6bSlMEDe6dufL?=
 =?us-ascii?Q?w3/MRc2LUDl1XpR1PTM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?BzsWqaiUz1vLUdtTjPXjc1I2gPfPOVno1CYOU8Kk2OneZIoMf5A8ZAHPUoKj?=
 =?us-ascii?Q?sA66Ee9N2tqPxJxprbBduab7ZubvsZHHfd8Sz5dQs3gZNLwOSNpy28inghBL?=
 =?us-ascii?Q?EMO8OTdmUtXetDpVCwjpuTxXh889dmocEOsVKB0NZntSK20ovjDUcCQSFHAG?=
 =?us-ascii?Q?YhGHmz46YsgUCBW8iceL5TMiGMIBmSOLLnTYJtlHNkWQRZom/GvkznXwMMb7?=
 =?us-ascii?Q?ek5T0fxuGQwVxy3Tv+3X+Os9x5Ho0NQnCXkuZ7K3NIGhDK9I94Poo3yxx9Yn?=
 =?us-ascii?Q?+bU3DwX6XYfVGs+w4jsuI3GNQ0+XKhHrli8OZWMrpwTYuSHvHTxecdmulSa0?=
 =?us-ascii?Q?0jakXpNPuX1fgicCCC3ySHO8jeFH10R85eLUTnzqyqII7mFNMTyWC9v4RuNd?=
 =?us-ascii?Q?S+cIQ9aclXmgrdFAS7EfK/hwZEM9ilkURRPRz+9wcd7uFWrgh+m2Ab8HDLeG?=
 =?us-ascii?Q?aN18iqCrPGewy6KxazgyOMCJd/9RgdhpUiCMRbZkPLAeQj/1tpjI5rqpVy32?=
 =?us-ascii?Q?lcGe2qPm6Q1GLRn0eeYSzuv7xBGf/iAEY8cNRzVl8KrPbjhQTOmeuLkge8V1?=
 =?us-ascii?Q?KwuF65o08de/eH+OcjxfTU7enjZkDe8nEGA6IrkRfoA3pkV5xNXKV0igIvJX?=
 =?us-ascii?Q?18C5MwEv033fDwdhOtk6Hn3PWhEtiZL6IQoFKP8JNWuyXzHIbFE6baqYEkZg?=
 =?us-ascii?Q?3nu5qXa95+g2M9bnEdeVOCyUgkEksSw23IuxB3YySXrAt+dKO3Y2CSPS6QKX?=
 =?us-ascii?Q?cQqTCIz4ge8jv8LRaNtG1n/YrZpnZWmUKoFOEOvbbgSgwDuZDdaQSPfVGf16?=
 =?us-ascii?Q?Yz2O5HtAjRmz93M9/3LGq7Wzro4OwBrcRyVjaWLtOwn6pD/2zJv+ten/I39b?=
 =?us-ascii?Q?/8BU0LUsAY9pffLxZvvPQu+lBpGsDmTdiRobI7V2pdk/AsSNfbl0gVCVbokO?=
 =?us-ascii?Q?kFdnXIhQhr50qX0LyxFI5nYkH4HQySGhK30UFSddPiPhtgytU88acW3c3BuD?=
 =?us-ascii?Q?Q5tqYaiSbUf1XTTJZSDmr16FZzTL52HWkgFNamSTO7wNbderz4ESGvBhBmaO?=
 =?us-ascii?Q?GmEyFbuwyKCfRZejuQygh34jMtpf0RLJrJ3KKm40PhGwTDSZX1JN1t0mwP+c?=
 =?us-ascii?Q?T2bLLB2mSt3rfn7dUfClVCYPYYIoPjtH6ZS3AeWQuLUcV/xpR5HIP0SaWEvC?=
 =?us-ascii?Q?xBD//Sk0ObvMV9J0cHYpwR8+h+Eg7qON1fMXkbX6aokFvUQfTnndMLVx7Mzx?=
 =?us-ascii?Q?phpQyA92G2hqRMhziM6pKl3ZeHWXkdM1PZgpQs3GeSU5d326zH+MFq0Ej3nj?=
 =?us-ascii?Q?byc7nXybuh8/Z4oNZGkEwm3a/+oJTJjLzyk5FV0XvTJI0z67dxb8abJr8QOb?=
 =?us-ascii?Q?JPMDPVh1MaAa7wtI+AWDBxxj3nMPhc4fSbqX2UvIjsnwUHakABWDd9HXMRWp?=
 =?us-ascii?Q?5QF0PeGgtvQ9lWgMmYr52hFLDsVWnAr4DkLDZEckP5LjIWDDuDx7buLKiNSn?=
 =?us-ascii?Q?Y32A4zfxmNhhqAd28xmfp83MXF570R4Y1uy+rq86zN8gPtnuybq/7ynSkO4A?=
 =?us-ascii?Q?w7IxoijKqYUvVJLUlo/ClXGdMOGzMMHZfDsZsujuU4/HmiRc7cVCE/3NgZ5g?=
 =?us-ascii?Q?7kCVhYO02zUaQ2reT83DKjLPrVwGj+yeqFmTDN0gruEVYrWE648PU+qowSEw?=
 =?us-ascii?Q?vo/zXjRMTWiwnZqC4CAqdENQSn7EMoeyEtOdE4H/BQV10X/XKKnPLhXUz+t5?=
 =?us-ascii?Q?0g8J+N3AXw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	awcNiL2O4s79gnA424FEMHHSNs74pXaPgU508iOo5fWKlk8xiPy+3+zUHayRKwsqVYnIKqDvluEP/zAIuRVVzTf3E4JT/AhV1L1INtOnPhkUIMmi76ibaNnGwiI/CzYeuFF3W9D9R6HEki882lLcxVj77ACzFKCzOY6aLOUFszwi9u0IMV0tNzxSi781HCg9CC0BVUi52yih238gUY6FlrgoJMzReraGOm2zoYnPRH9QKeK5PRaIw09E7U3p/3Kc//Gyl3SnWLNsHd+KGgCwo7jV/z3AkliU75hWnoWhWaQnzXDzTNUQmQgPKPrOKuWW2ZZA1xUMJrOjGMaRy70hDAqTkEeUYUBwhV1sWiQYb6oF+9sKGaLbmXacm7qv/6RAsGAIJ5DDWx9zVh4XATdCwEoB7VKar+0u0c3PlJauOMIp+YRriHE+TE9zjoAWbbHsEHYARi4HhT3nFlSgY72bZHvuYP4aEYJCu7AyoAvfk4tKrvOFOWfdkqXikeTg8nDejVP/bqgcrvhjfMNregWpl566E3AItiobE+Kon9Av80fRm58LPHfyiwZcHKc1Q43a8blgT+c/I3+t6fXPq/0rumniOHuqBLoj7skaKXzQdvY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c97f23-3f4f-45c3-0002-08de590e285e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:27.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dy3tDqJqx/GW+5Veqykc2/jus0pNPHpHW8aHW9x4OC7MXKMtQLQuCcA6OoMppJBMxqW4GHmpY6nIpm8kL916wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfX7tsGt0l4BGmx
 UlMiEhNL1/14ByevsMxXLQRR8+THQ8bEmw0m3jrWrcvQdI4WN/n0usDoL03PnmYtpIxAn0hVJQD
 RQkakSCYmQqvH24q7l9WWlBJ9XgMTRIR13O5pUI9A4GCFSeOSi5plPHb+R9ee+Jn/shICNw4K44
 GB6BdQmxXQsiikvkh1P3HgPLtIeZ3U66jeAFjRbCMFoBk8U4LgbX8YIykpc1+uDci6QEgFeWf08
 ZMiqhgR/rQUo3JclSFQ+NfnsFsJdOEoFSV3S9bCg7IbZHJ6LaaKwc6DhraxIk45k2c4BQO/cTLf
 IvhZOfWf9fX6j/XJeuv2IJ1B2WM+m8aaEaA69cTe7lU/vzh7W9cIdwThR1eZebjOdvk5YoWPAyw
 DEA8inoHRydWL7vuutNIjymz4k7scfLR73yQneLkF2ytNZ+xxnlBNmj+byVSMJjAwTIrELj86uv
 5Kv1pFxTn1j4GBUz56A==
X-Proofpoint-GUID: rcSbxY0PmJRBdM1EnrPAOdjwvpHux5Kp
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=6971057b cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_NXkmabX6IJC5lhnbH0A:9
X-Proofpoint-ORIG-GUID: rcSbxY0PmJRBdM1EnrPAOdjwvpHux5Kp
X-Rspam-User: 
X-Rspamd-Queue-Id: 28AFC18000D
X-Rspamd-Server: rspam07
X-Stat-Signature: 5srip56hf46g1hrh4anpscxt9yqmm7ia
X-HE-Tag: 1769014665-605778
X-HE-Meta: U2FsdGVkX1890OiuW1XAdJgD7lXNCIsvN+7oSCwYB+Qttt+/GUikJyAlRPopz1PIOjUaVXy5HF1EYN03ehbgSrZYD2W2YY7OXcZHtuYj/Gg6FNSRc7QrDVoiWeZnRZzmJRhaCmVgeOnj2EEPf2M+XES0cj6luF1wmodcBydNfRsB/4z12EkZ8stjtYC2UT/Q6HF6zunO6ljGx3FqG0+54NqubTCGkgKpR1fhb6rEghFkdnzgZCmZVCs9NW+G7D/HUFYZteO74ldDGtNjaBDuPEW0JuerZSebzAXHUvwl3xBH+A+iV3+p/gtqkU0pcNAsIeB/6Ymr7TKQXHSATRYQLf+xWRbQDTTH0JdUzSZ/O2YUewvlatrI1vd/R1DbUSaBp935qqgpwSrYa6I95fVdkgtnJo+UGWs4qTClVe3dAQCzVpYEULYlJZZi6fbRPQ9FLxeLYMQYVayKF/AqbMtRRdH1AslBbQ/PPwFxr7b4LcwkKyShtks7RQ5geNoegt1FOujjjqEpBK73tslY5TMinIBWpqUj7Qsgyj79mlBSAfI4OAuf4DSaJ2IZ2eo/7mo5c6WfLqxOO3G3zjhvHs5nKujdcn4sUk3H8BGL8FH5D3B/Y7axQpxS9xeLbvWGt1+MYVXv1doVN5sDFqrksyUVmwzNEevFY/QPaUpA2GHMchVsK4OFJr0RGPVw9ZxEP7dJNsAj4xi2RrLpvu721ivnHTz8w21J/rsncBqqvGdKijfeghV0xq6SDOmpWbfaJSx/zvZBZ4kMElQ1UsrNm9xrgrGEw0/QmcihXnk3s7e/Qp2wOgwYUfBgN6bMTBY2pdV26Ly636lHWM28FFLm/JofzXFIsEyrlz5CJSa4EEui/xXLXVl1Q8Gx+fIlJ3p3oWhUPm8iZC/yG9noWUYC5cs0ZDKJKDlyfv+RMsP/OKZQRaR1pW8pSOth0zk4miYuHDbpoZYWQECQSCSgcPBgO41
 by8ssfES
 13fkoKCJmoUOlIolRGCoG5NMjF867CF5UwqHR+hYDkKbGsuKanG0Zq+8uJ3pcWXBrWfgYnkSuDm4IAZOHJpjvd/508rVMYVP+DlLywQCptS7TIaKFdDctVojuaQc1kv+lWKuth5Ub4OPPoyere4LoJhC7SqJBORmVVYa/+ticIlfHvyVayUJtP9m9zQjO3Y/HsLTzkY9fRDvAOABen7Rz3PN8jQt8SpjIUTadjQeMAKe6fT50Ges2IkSOObO63TO2Ngd8QdvIcqZus2dnTJXD8uAwVjkdlQRIz78JB1gaCXEdvrEqIQMYfF21yifHy/hHmbpVyxDa8+nAW5a5qCn4YOluj2XiRwl6uABNLPS777T/tOe3dQPOmBdQiEnMif6z1jJ95dB8o2rPDJ0GY/dx6/FKsWGrOhIV+AqdGOawE/gNdafgbboUxK0dn4FRWGjsDsqfp1w25H+tqU0DVEcgN5w6PBk0wVqoDXZSW/AB48fSb3KLH1dDcbT9Fk6df3xGmBHnjgmZCxi+JpigkwXZoHtDb93xln5D7EN1K5aIVmAAmXjBTJeqn4TeSYMx3jhxh5u9H43kWdgEbN2yA0VBc4SCKEUrafouXVjbdKrW3k4TMt/mMavFB3RHdyAzRyMQHSq3FkHBrNbpxCY8avBW4/8Zzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The split and rebalance store types both go through the same function
that uses the big node.  Separate the code paths so that each can be
updated independently.

No functional change intended

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 47 +++++++++++++++++++++++------------------------
 1 file changed, 23 insertions(+), 24 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 56586e4c70c1d..005cf46aadc10 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3713,24 +3713,6 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	mtree_range_walk(mas);
 }
 
-/*
- * mas_commit_b_node() - Commit the big node into the tree.
- * @wr_mas: The maple write state
- * @b_node: The maple big node
- */
-static noinline_for_kasan void mas_commit_b_node(struct ma_wr_state *wr_mas,
-			    struct maple_big_node *b_node)
-{
-	enum store_type type = wr_mas->mas->store_type;
-
-	WARN_ON_ONCE(type != wr_rebalance && type != wr_split_store);
-
-	if (type == wr_rebalance)
-		return mas_rebalance(wr_mas->mas, b_node);
-
-	return mas_split(wr_mas->mas, b_node);
-}
-
 /*
  * mas_root_expand() - Expand a root to a node
  * @mas: The maple state
@@ -4367,19 +4349,34 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 }
 
 /*
- * mas_wr_bnode() - Slow path for a modification.
+ * mas_wr_split() - Expand one node into two
  * @wr_mas: The write maple state
- *
- * This is where split, rebalance end up.
  */
-static void mas_wr_bnode(struct ma_wr_state *wr_mas)
+static noinline_for_kasan void mas_wr_split(struct ma_wr_state *wr_mas)
 {
 	struct maple_big_node b_node;
 
 	trace_ma_write(TP_FCT, wr_mas->mas, 0, wr_mas->entry);
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
-	mas_commit_b_node(wr_mas, &b_node);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_split_store);
+	return mas_split(wr_mas->mas, &b_node);
+}
+
+/*
+ * mas_wr_rebalance() - Insufficient data in one node needs to either get data
+ * from a sibling or absorb a sibling all together.
+ * @wr_mas: The write maple state
+ */
+static noinline_for_kasan void mas_wr_rebalance(struct ma_wr_state *wr_mas)
+{
+	struct maple_big_node b_node;
+
+	trace_ma_write(__func__, wr_mas->mas, 0, wr_mas->entry);
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	mas_store_b_node(wr_mas, &b_node, wr_mas->offset_end);
+	WARN_ON_ONCE(wr_mas->mas->store_type != wr_rebalance);
+	return mas_rebalance(wr_mas->mas, &b_node);
 }
 
 /*
@@ -4410,8 +4407,10 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 		mas_wr_spanning_store(wr_mas);
 		break;
 	case wr_split_store:
+		mas_wr_split(wr_mas);
+		break;
 	case wr_rebalance:
-		mas_wr_bnode(wr_mas);
+		mas_wr_rebalance(wr_mas);
 		break;
 	case wr_new_root:
 		mas_new_root(mas, wr_mas->entry);
-- 
2.47.3


