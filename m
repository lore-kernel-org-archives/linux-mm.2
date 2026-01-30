Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEFD7E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340D46B0092; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3D66B0093; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13D716B0095; Fri, 30 Jan 2026 16:00:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E078D6B0092
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A048014070B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:29 +0000 (UTC)
X-FDA: 84389848578.26.73AE6AE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf24.hostedemail.com (Postfix) with ESMTP id 25697180004
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UjnboYKY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fuIEtNG2;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=;
	b=YC2sWyfvAoNZxJx2wDPQPEMGHkfY7yZzvAbtNzL6Vh3ForhVlw1N3XEnQtXhxrnuIt7V70
	lPX14/6+UbTSQohsTnqRHHGX952aDOy5EtWQDARJ6Kw+lCiZFjcqQlMol8/OGzhlmRba1M
	TcEWpuCN0DTwum9qX/Y3h2WFSuzgb1A=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=UjnboYKY;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=fuIEtNG2;
	spf=pass (imf24.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806826; a=rsa-sha256;
	cv=pass;
	b=xl7QVsPngQbm3nkN9HIMVHR92VxpO3gujdd2WDDEHt48we7eI961pxEH///g1yfk5yAl0R
	idsF3ua436do4q3Xo2sBacgmJUhrB5MlzI4e1UQBcOfjjHOhMPaZLRh8Ip7SYfJxCX2On9
	qbMLzdUPythB6YOERCwD4w2qc/rWkts=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDIDG4028214;
	Fri, 30 Jan 2026 21:00:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=; b=
	UjnboYKYfO1w9WNsrsbMV0RLOZHED84NhzrwGsOf/SbWqYb/+ht5WEDIj7itOGgs
	5y4L52C4VzJxUReTWGnnzgY73/eAeK6PA+M/2YIsKB/ETa8vZ7KlMuPVAlYCNQTO
	KnoomC2O7qBt5yp8HFi8zFpCQP+FX65j6vtjGJ1AuLKYfD3uB8wvlTODF+feUprU
	u/9ed79u9je8tgEYLGtZtjxQDJ1F36wuzQDuv/+5CQC0ZNVUjfiz7xOfLEj/w1nq
	7yQMF6Jl1gcMfcY0VuTeTv/ZvnKPtMeueqQg+i5MlQ893scoI6s44bPK6R9i0KU3
	wwkHJp/xXRfIJC04yUCEvg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c10668cet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJ6DU4012456;
	Fri, 30 Jan 2026 21:00:05 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012051.outbound.protection.outlook.com [52.101.53.51])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5fr8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ls70rIFvIdRUvX/xCtO85Luqev66cj+KYmxp84Qzrb6YZP1OEuQfepbE2F3OG+Q/Eop4+9hZ5PfEDkfui/oEGmlXJMeMV3Qa8X82K/LChPdIoq4qwzuMSDtRNF/pIQWci315jLivVFTpw0sqmyx1peh8X5rJ9a8j7PqTTNOK63goeTrBSKoXGpH1kDVUF6mKR48m/vnLoZ6UIQrl1luwQtAUgO5s4UvXDK1wpXVf+eMKm9T4ZmxE1KuneJvm3vpimPUIbUN0seIKoKYh/BMU7bT1TGnxZPSrdJcG9AGM4spo6Iq6pGFU9Nc3OnfHDcIE4r7xnPHUTZX3+cFwzsyXYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=;
 b=loy9a4SYjoV1QF/A/dsLHiTQf5k91zxt6BdQZzkHTMHAyvo08jznqDaWZisvr75f47MymY4m+0GMnXyjZeRKoybCDUKPHxa3sY7E5n6GTG6Tb9RsFGY7jqPnKCLibdP6htglS2gaJ6Q1yJS8gbpwotETUNOZfbNNp5oM+vpmNk+I7F1rQT5y9XjxwtMP3AIUK001jBCs3mznN4m+VfriYcJ+jQhjX/aDhS1jUsu/siKRLg6BL0vdA1eNQ08VC3R/3gHFx7YGxIi0PYNKhZ6cVV6IBTdGMWGjehTzjAttK0OFPHE7boSQIlOdS1/vgr7seOMX7sgPjaM+ljb7PA4IcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L30JJ1psmkMPakOhtTEkNu26hTHGCmn7dafYI9225y4=;
 b=fuIEtNG2i8ExKcqCG6pGxp4sTrw1ZtUzMP9FGTEbCJtlVUIvJlYSogPrsf5O8IuCGUgZiLgHfIVpht+doraqBquHELLKbnce57nskphXuuaQxVMpxZcOatsJqn10S8y+/sg8ykZ/wlvlkUvBnBoWTUJ9fZbmEycuA4EBPzZAe5I=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:02 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:01 +0000
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
Subject: [PATCH v3 03/30] maple_tree: Extract use of big node from mas_wr_spanning_store()
Date: Fri, 30 Jan 2026 15:59:08 -0500
Message-ID: <20260130205935.2559335-4-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0055.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 34e97b15-c343-4d99-7084-08de60428910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DRD4jePw0xLVYlSIeoa6BRHmwD2K7d1lSWNEs+sn0tFIAzic6muxeqajLytP?=
 =?us-ascii?Q?HSwt3EAY0ZxW/VCZP1PEp1S5drbsvzQU5CJswllQv9epCJwV3h5bttEg0iSB?=
 =?us-ascii?Q?Uhcl68y0jrFLiwVICI/oQiMPw3I0JAtR9yMUr6YNEB9RI5CAs6TgFTG4X4TL?=
 =?us-ascii?Q?KHAr6DrnySAgd1peSg1eCy2maOAbnxLop+7TQuWyT0wdHIxEMA0axhrYs0uH?=
 =?us-ascii?Q?BtQaVvCa1YfT1VqqFNj6n9Z1a3tBhyuU87+E3sLV8XNaV7U29uC+7UIuZGHr?=
 =?us-ascii?Q?6GPPTkSK5bXOrncOUCDGdHzsk9AtgC119rwv0KlNnmaUFNS3t0hj6PsGoeTf?=
 =?us-ascii?Q?1CHIvg3GB4kkTFPKadX5DXcRhVy5fHHs10jfI3aYOCdFDbfdB52K5YqUGD+p?=
 =?us-ascii?Q?eykPXZlBX5c66YyPlk7ICJWkSeIWg5k3bMKWJrcdpf3+8xSx7gqt0AlGCeQk?=
 =?us-ascii?Q?8P2nTuqhvgthuU5m5CuIV80QF/wP/V86orzlPQW6lRiybv8X4hqW7r13hG4i?=
 =?us-ascii?Q?LmDUGt1q1RfYwlQyPMNBnhsyseBbs2BM/yGQ4bQlqBX+6sGLsq1l1dFBCNJ2?=
 =?us-ascii?Q?dyw/uV63+wHH/SSKqDQJolW6ejqh21Rq9064tkf3wcTAxUKwdrnt00mFA8zI?=
 =?us-ascii?Q?VL+1EQBB+/8+n60uqfsdaksEOzYFwxv8S/SDLLifqYckmCvbm8CKga7kTkrb?=
 =?us-ascii?Q?qc9/Tl+L3Y2LWlfaVP58vWHl12gC5j/okiLLtfKFudXcbvM/l4iiL9NMELop?=
 =?us-ascii?Q?CD6+LK7XLAdR1taoCiWnuE+oYtLZEbCd/yXAJEeK1ao5bUcXgSova/BfD72J?=
 =?us-ascii?Q?7gPlqjO53xm+Ik5iEMzpuzFdu/WbIfDNw2CLxro2oTqpd5GvQYtIK0/pyq4V?=
 =?us-ascii?Q?1sv5dPk6TBRkwVDLsekl32G+xCvAEaMzGgihYnCyWCL4z+VNaTgyOfvNCJDP?=
 =?us-ascii?Q?DSQZqviffoMOWUver1liCSX9HGIhmrY4CTXLPhNlOFLzmBVTVE84pRdfDqP1?=
 =?us-ascii?Q?igB5xsbbxQ1NZQCnKHrB+jAxDvbD34rSSbnUn1DdHaewHyFklIegdsti+K3O?=
 =?us-ascii?Q?sYC0K/2k/KuK2kJ5zXm4KG1IOdh9gPi2H39gwTO5EoAvc8kE1+K95WPmG2oU?=
 =?us-ascii?Q?qrOWbEc7Sq1g3RF4HmZI+v0eFErH+bAfwbBMyrV1kJ8N3s6OTTISFyMj3D4Q?=
 =?us-ascii?Q?FvxhQ6JFfeFUFgQAX8TD6qmKJbnBgqDPQWF6iiG8IcpPvMAYKvqXDf/NVyD5?=
 =?us-ascii?Q?bSE+0aiT0QWMFM1BpMUr4sB0DxuieiKXE0SjW4R/Cukt27VN2mtj/2Npkj3E?=
 =?us-ascii?Q?Bzue6nXTR9xroV85xOMtySNPPuxLd3ipkhXGvnL0xN9MnTk+STIVZjKf5l5v?=
 =?us-ascii?Q?cxtEWDx5c9pFqwoYnYWJ3knQKGWzYQPQjujH/qNg95XUCNxRJe4IfnEQgYB0?=
 =?us-ascii?Q?10/UbLB5CclNaTanmWaRN9rgHFL2CIrUjcK4ihU+mZwP//014p+g3voUhHeJ?=
 =?us-ascii?Q?O0ZQPxqqD85JV0QtPo7zT9Pse45hLgJ38d3AWbuR6SeQBFN5mVmEt/JRGtDn?=
 =?us-ascii?Q?0RDhdDGABAHk1NF3pXw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?kXfTA7Egfx+5ZN8lZ/JJ30gHfUNPcahuYounxHosJENbMFXP+QzpKzAYVuDK?=
 =?us-ascii?Q?qSLj9N1yNjbyosW2vvBVQ807+u+IyM4T0yXK7Wc0WOzz0l2qGilbV1ncYraY?=
 =?us-ascii?Q?2+ZPqv/OLP0L4fZHXt+CaYjkQFPcyX2230nFeVeMrtckvfqiDdp/A7XFnZA1?=
 =?us-ascii?Q?/dsnuunQQbhZ/kXrQNXtcMBmCqpDe8CGiKTvc1OsdqU8uJoaA/KkJGrLm8nO?=
 =?us-ascii?Q?zLskwkir7xTqpJuijXbmHv1EKhfuP1SNo0TZofWZXl4JpZ0YynoNKSrZVhGI?=
 =?us-ascii?Q?eXALVlZ4Ds+ijuF0WQPU7sKRUGxDkEQQQNxdnUHl6JF1yVULwL9n0M68wEsk?=
 =?us-ascii?Q?T/Whstn/vx5lFizDfEb1kRuy1/jPmRnE8ZdZWQpWHnEENBF4kgqnj/t+s/YV?=
 =?us-ascii?Q?yCCk+Pj9hStn8TU3iQFXzrmTX2fSSLzwNCAo1xmE4NZgcyeHlDlkpZJ0EpSL?=
 =?us-ascii?Q?X9XGZfFeIz2VovsUkEWnaJFQjFO5oPnNFCxjKWA+lIrV7IIcs642li1yG+58?=
 =?us-ascii?Q?aBQEj5vGa9WBSg16Di9pFrMXvqXbOw9QFfzKsmi5YRVL39nFx+eMBOWImoaC?=
 =?us-ascii?Q?WYA2nbFS/k+s+VR8lCotFkOAGvC2NKCFYomDAet/Nj6yXqNS5G7KPQeNg8I4?=
 =?us-ascii?Q?bz+ZR08NWl4/uxCFHw4HnjpaRucNK2QrDnLqpG6tYbBC2V4OCMP/xZmRhHoD?=
 =?us-ascii?Q?D9GXrWoe3VRsQlRynwCjlA+iqbhxndluMtn9cDOVEyF44/ksmCiNOWghnp2I?=
 =?us-ascii?Q?dhJV3B9JX8Nf53ktz+D6etRPgDXu58sxeYLL5lWswqEX6NMnN6Cb0YJsupX0?=
 =?us-ascii?Q?8IN+KMEhMJk8DSN6SMcBgVBHHDV1XKOXWM18s5sFe5Tdw6v80/c7U+S/E6UD?=
 =?us-ascii?Q?0Hp4LCb5O+wHW3qzib8W2xLGna6Ys+ioQm85McAR82/bJ3MX0kVMW2wx773h?=
 =?us-ascii?Q?sHOavi8CO76FCMWaX4g/FZoon9CBuYw1C4KF0GUHyxcAS4gG41QEod9pTNji?=
 =?us-ascii?Q?U9hldWeOiDZEvTc8cNslosOf30ps7sNPEUJuoonP1+GDb5Ukp+q29SCT7c+d?=
 =?us-ascii?Q?kdTcqK6mFo2VnrEnmTQWAoWiZXKVmFNa85gwJ/TfmO9H4kbd3MnTiYUOPlZM?=
 =?us-ascii?Q?CVvqZ8nXqNo0gkJ/anT4BTkE7k0f9yKpqqifCXpmT1ePwzAs2S501E7DLOyQ?=
 =?us-ascii?Q?I7pmGO32eT8TG9cVDEeToxNidC6LJV6XlrxDdLYnMREv6pHClUpjdH8xc/ZO?=
 =?us-ascii?Q?zAaWUfkAw47x9tWtDGvoebLTAftUzIUFUQlTZX+KIhDM6aDOUhUzwHK0s3QM?=
 =?us-ascii?Q?U8VS+AumqSL8bF1tw4x5OZsjE2YPWOgSB3P6nTBfDxxtJiOGpFRWm5EyWLOS?=
 =?us-ascii?Q?2IHbwlNtc0C4T2E1HsIdYy7ofiXnVPKuYphkgRdTiZqDSVcmaq5903a3QcK4?=
 =?us-ascii?Q?y5MipIFowz0l4tUTLdvyZlKT0V3UeJGCmG3iKIH6ivFwt9F910514l+jOOwl?=
 =?us-ascii?Q?LN+7kUf9jMWDyK7TKZa+kSWiqefTS17ppWx7knrba/Lmxl5vjN1b30rYdNQe?=
 =?us-ascii?Q?bYN6yiBroSkfi9uHxImBKWki8Lqz4x4nfQmMozUYlDyLfXzUYiU035Xnrmw0?=
 =?us-ascii?Q?TvECNVcdIDNuZCdvqvwsIbIlPjeXTbHvtkPg1vgvf7CzVlA9JmT48Z/pycO8?=
 =?us-ascii?Q?HqeTjn2Sp7FLVa05DBMHgZcY+onB6r3XCVlq4hT3525UF6cL9+58TaWmucMh?=
 =?us-ascii?Q?8bW5GfTyBw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	g+0PI45DpYHM8l/Cw+7+8cNpk9WYO5iFC2LnoYed01FLrrIXvvRIyy+XzRYJJf8TQpu0Uqw6mDkhA//SYZYUVmRILgi4mefiIw5DUUvNhBH1OMnzZ5HRyXcIUbkCdtRlKDGnzY+KGVXYEnxqxBh3sjmurVEUT0/4ZSynkGkDT/gnYoZGlRCARl+GvewPCLTf7jiRXV1A1wdjBcc7xl10IH75Z0ZhFHMZd1y9FMlQq33wLsHndIMLyB0rhOj/hW1W382FNlpJasuVzL0kPxoOXZBl3vVfizsRRvI++wPIxFBo+0VFk3C+frYHmomCcYUDYZwcqaQy0vnHg1Mf7QraSI0pXeq46zJ3Pz2L4CvDkTbAW/2mO7HpaCzlbwfMoRzD9peZsPzWV6qaTFO8Z47OJXtWAbNz3SwXrCkqZLgHy/ZJzTIr+7bdAxCABJQrpFVWZFZSQBZzJu6inzg5DRIYW+GlgMwxe54YRrcQffVdlARlY6pFML9xo5kC5Umro7hCqsEWD9NwxOgEmwAzyV1Yt+O6/D3AwPX//rpOnDJtNYkelOjzzzfGSaSbqxtP6+nxjJvYuKrmcyXUnszNe9XvQmYIG0+Pod/S6ghIf9M89wU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34e97b15-c343-4d99-7084-08de60428910
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:01.8073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qRtd8n3hCbWGvIMWz+VPWwpJGVyIZNdGHR6VBRsjVb7W9BN9QDGXpQPprGBX35JdhnvvlBdgv4qhms/03cFKJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MiBTYWx0ZWRfXyQAualn74See
 TB2Iz96sgoJpwtNsJrXAuuXB89DyLIXAoaaUcKQ3muTtluYyRGxvmphlubJrODHMu1y9aleyV1Y
 CYf3g/N+SHZYjvjxjvnyKtf9vhb8opltZFIvSw8QYvT4KJDNByvyMQPKJ1KtRMksAwEUMPWk1f6
 f937MzS1QPNwAFA3zCnZUyfGqEM7KYxF9pQBLw7vAx4wB/0CfnuTAho4yto2Xto+Rbo1MFzzWUi
 lSuo1bkYgmGYvpVPRyuRYpOctMZNLB8INk9Yf+JlxG73Ux7Ib6Z2lwenxgkEKDok81nqyLs8ghK
 SURzQZyJswSoOsyCZGc4PRnACzsEtviqr96xXrpFZDLKa/75qXC1DlC5tYun7QzzPCI39wIicuK
 3D70B3wUly+iQVRB2gZY4iXwqCRrsBQbaQP4Zjt5YuVrw/unABES3dS6IKaABBUUNI+GAjnL3vK
 42vd3Es5yNyYTb+ISFQ==
X-Proofpoint-ORIG-GUID: gMxYYy0O_Dsl5rncrGCCV5qL7s95_eRv
X-Authority-Analysis: v=2.4 cv=EebFgfmC c=1 sm=1 tr=0 ts=697d1bd7 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=_QQW3CUrkSdKJg9byCUA:9
X-Proofpoint-GUID: gMxYYy0O_Dsl5rncrGCCV5qL7s95_eRv
X-Stat-Signature: 33uira7tmronfeck3mekck8xeysceog9
X-Rspamd-Queue-Id: 25697180004
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769806825-94515
X-HE-Meta: U2FsdGVkX1/jXhlx2zfovTm57jAyloeEonYNtkl1VWtBOQAuPseG030gRnme9x2vq6EAmCZvGLb8s2J5HNlEd3hMaRIuIn75w46srwJLqdyr0JQqFZ6T8j4ZcTry6oVwtCHAY5ojsGhPhqkXS+iOaeA0DF/+b/KUK1KT3PGfxEp2s9seCp/RCeLUlrfD+0AbgNr/PjH/6+/MGxWFbBLqk2av5GXdw0Yy9u4tFVCfR+YOeGMlivv5fNj4e7cn9k+b8GpYLQHqx8S0l3xzL+Mky6Ttf4B4psTCuGTefyr82dDBlNT5hsYwKX+P8+etGBERt/o121YOKBohpXljXqGQ6/pSFdt6WpG4xgo+7x51GGol8ZoEkdxlHZojSUi5CUlObOI83IUcXjQYnHd93UULFpiqf89F/NBm3Fl9Fi/Z8fnT5O0SkGp7FhSonQsfZucUBXWtZO8fEUsd+0rfBfRgx06ZuwCze/b1QN2IaPT9XFxroEfEgkVjEbkQ0SzVmu5Fc5JTho8SAL9uM2cx4hgmjJd9sggj1qT/lkvnedPW12xHgmku28beRUZb54Rn4f38jKn1iZqS+iSaG1/w0aMJK3y7ohWqoUgktYcKtH+pcgVS61HVGrxHvYs/NKTWEHuzy4iVGJa7rEPkwFei5OK1EDkVmksaS+DkAEG+Z/cfTJVfgSkE8iF7mut5sTdkmINHdtChE+6mzulyz0hA4UnGLQPJZXbTW4SGdTj9OvWGb1kUaFNBocw8BQWq4SA/1NCSbxLSt3eiOC68cIxFJUVIdCc9fOsIpR2jgtkrW1MrGVaOEnnG7qXUcFXuD6GNc6YpmPUuvPsUi7WGcvVg/pO0yuPHHZldFJvHpWtvFh2UbqM72xYLpQbzoU5KNDwu3Jx0Py6HIJhFGvjK304Za+HEurnWKu0ve83o5cExke8E1BWpar1k/iO3M4gQjRt45ZQsv1Nu7oFOIg9g4t+IZ3q
 7u/dTgQZ
 e3PhnFUzGOReX72+37uLUplvNxC3uJUfGxVGDblJrigigBrUKyEhxva7ewijKxZAtgb7Ct7fgrXmrBnzAPbcfjWPSZo3QsOHmFxnII7GTAE4zjnEpkllgYj2SnKrL9F/rMY1/BNjqSfetBQDQYHbHuPqFNRmSJdX3VSrEbyB+SfDnxTOJoXi7Usy7JBhUphFiPxsCdIZacMa1+e4lgMVjhBQk6OY9oh05H/9vPpUiceIWxTrgZ+yyATWcfnYIaSX9HWoCy89tSLOINoQi3GJhQHyTsblN/+EV43mH5gwySCIepBeHAUJZEcD6m02/Ftg/jpdmF9I4oSJJV3r23V7MEAHG7CBmufbl90XUtg6Z6ko3pkjDBbQT8qO+6veVfgWP9hoFeNoPCjMCg9dymWga42Xzwp3ImJbUEAj5hZozXdSGM7MKAz1q8mNUiPRv5UGDHVuDwOzfDTRr53G1ggAn6SIJy4JbrFeFl2BqYr5j4DNohB2fn5htXKbkd5bChcXUui2GGpr/rf86+YVnM4zCh+1DFjikyukeH9FaCfDnPa/c2XV9Zi5LoV/zAsQanPLRiCWivSlB3EF7f4mA87unmcwwa9F8ALIlix5KcyOtfkAu0xurl8Kz0eohTN1v3MYChkAsVRpvlsRDp2zrSvSvh8ddMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Isolate big node to use in its own function.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 44 ++++++++++++++++++++++++++------------------
 1 file changed, 26 insertions(+), 18 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 70ad474e6ed14..9ab42821ee2dc 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2748,6 +2748,30 @@ static void mas_spanning_rebalance(struct ma_state *mas,
 	mas_spanning_rebalance_loop(mas, mast, count);
 }
 
+
+static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
+		struct maple_subtree_state *mast, unsigned char height,
+		struct ma_wr_state *l_wr_mas)
+{
+	struct maple_big_node b_node;
+
+	memset(&b_node, 0, sizeof(struct maple_big_node));
+	/* Copy l_mas and store the value in b_node. */
+	mas_store_b_node(l_wr_mas, &b_node, mast->orig_l->end);
+	/* Copy r_mas into b_node if there is anything to copy. */
+	if (mast->orig_r->max > mast->orig_r->last)
+		mas_mab_cp(mast->orig_r, mast->orig_r->offset,
+			   mast->orig_r->end, &b_node, b_node.b_end + 1);
+	else
+		b_node.b_end++;
+
+	/* Stop spanning searches by searching for just index. */
+	mast->orig_l->index = mast->orig_l->last = mas->index;
+
+	mast->bn = &b_node;
+	/* Combine l_mas and r_mas and split them up evenly again. */
+	return mas_spanning_rebalance(mas, mast, height);
+}
 /*
  * mas_rebalance() - Rebalance a given node.
  * @mas: The maple state
@@ -3400,10 +3424,9 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
  * span.
  * @wr_mas: The maple write state
  */
-static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
+static void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 {
 	struct maple_subtree_state mast;
-	struct maple_big_node b_node;
 	struct ma_state *mas;
 	unsigned char height;
 
@@ -3467,24 +3490,9 @@ static noinline void mas_wr_spanning_store(struct ma_wr_state *wr_mas)
 		return mas_new_root(mas, wr_mas->entry);
 	}
 
-	memset(&b_node, 0, sizeof(struct maple_big_node));
-	/* Copy l_mas and store the value in b_node. */
-	mas_store_b_node(&l_wr_mas, &b_node, l_mas.end);
-	/* Copy r_mas into b_node if there is anything to copy. */
-	if (r_mas.max > r_mas.last)
-		mas_mab_cp(&r_mas, r_mas.offset, r_mas.end,
-			   &b_node, b_node.b_end + 1);
-	else
-		b_node.b_end++;
-
-	/* Stop spanning searches by searching for just index. */
-	l_mas.index = l_mas.last = mas->index;
-
-	mast.bn = &b_node;
 	mast.orig_l = &l_mas;
 	mast.orig_r = &r_mas;
-	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, &mast, height + 1);
+	mas_wr_spanning_rebalance(mas, &mast, height + 1, &l_wr_mas);
 }
 
 /*
-- 
2.47.3


