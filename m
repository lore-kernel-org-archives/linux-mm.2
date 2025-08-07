Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D4C9C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 16:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4FF8E0005; Thu,  7 Aug 2025 12:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC60B8E0001; Thu,  7 Aug 2025 12:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98DA98E0005; Thu,  7 Aug 2025 12:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84D3C8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:29:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3770FBC94B
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:29:39 +0000 (UTC)
X-FDA: 83750497278.09.E48FE39
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf02.hostedemail.com (Postfix) with ESMTP id B315780009
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 16:29:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OUKvI3KT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RC7oKg69;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754584175; a=rsa-sha256;
	cv=pass;
	b=DqHH92iA2Z11A8t9QbNy/dY/ixXR+EhCes5RUTRFus2ZEIe57/FWh84pr1zVzp9uE4sTRC
	5p0nLrWfU7DpxzxbhezdJ+/xyxBXGv+1f1i3ZquyCZSAplI/ilENqOYBWlPKc3BLjj0iC+
	zmNR5OX50zChdiBOnHgoie/0IBtOI3k=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=OUKvI3KT;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RC7oKg69;
	spf=pass (imf02.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754584175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l16pDzghuDRsAuja8p75FbXoGk4Y2QEWcRkRnTtPuUU=;
	b=fs5w/gpumtTxK27mcZgdfmm+QvZ5rPrV5sqiK7aJE/4aGhNntUOuzQgWsVQjN7qwO7ECyq
	DaqSkX08zReA4gFJ23svcYg8E1BJM0UT48Ajn8CIvvRU6zVYyK0JZSXW9uLVHw4BwdOrnr
	HJ9PAr0nkDmBP6KAKloMOhzDp+R4ZRk=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 577FGGS0018025;
	Thu, 7 Aug 2025 16:29:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=l16pDzghuDRsAuja8p
	75FbXoGk4Y2QEWcRkRnTtPuUU=; b=OUKvI3KTFjYPRxVjo4Gd1RtB1pQsB3JCrZ
	3rroWG13FW4/uxX1SO0FDEOOTrInEHWwGmgXT9/Rfqq5yaKzDWq6bGNusiCIvzpD
	dzAj53lsyxfi3hu9t7FUDctSRg2zNjBKYUKrQXnPr5KMVUEqppSwLYxr7uguqadH
	ZIg53bvTea40zk0HWvOBzce7KjvdTLzjAc5xDiApUvvWMNdOLxOgVkTTwMK/Vkvr
	YX6YtwjYi/dzQGcdbdfAddCJC6kEBxXSaV+HSmRUhh9Rxlwabq3K2tDY10qYiSEt
	yHHxgcz1W7GjWqYgH08bD0/v0hR2VXxP3IlzVSzJ8CFoxIovbfgA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpve4jax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:29:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 577FJO6A005633;
	Thu, 7 Aug 2025 16:29:27 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwyp0kj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 07 Aug 2025 16:29:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o6myNH/xDsH3jr5UX37ck9MPknIOg5mtbJMIK0Uel/6URK2S8gTYqElbdQilAdRQNeXJTE7muvslnb8C8ooDBwdOhzywOhBlAyDuxrHRvvEbTokOj8WJ0C2Pt3eLgK2TcR9jSkxsOCpU5MO6dnagrJEEFiRlH6p01O56oP4plOTzzNFi+wwuROwqHJ0MmBON/zqNKYmiqZZXYwkfCRwfzoMmtuxua+6CeXYbJTX70Iu0zmXyAY0NM2Pt8oR/fUQvaVxod/yITM1GrcqZYmxYK6Td/HCNtUqmIp76+Er3GEzsRgd6NDSJq6ei6XPK4W8PbbAZNf3VHfy6PaixJYU5MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l16pDzghuDRsAuja8p75FbXoGk4Y2QEWcRkRnTtPuUU=;
 b=wA/0dA2wT9Fl6hUPUiNxMs02DvhY9O7h/AWU94vHXjLl3c96f9dBL+f35JEMUndyOB33f+Y1hS0dGlEbl4P/J2BkcM9wETSQ+/9gtOrj2O1cVgTpZpSxc0cRqjYeC/twafxsPOVjroL9KAxEW417zUZsfqnELKvQMlgBom0GTD/IYAQM5iOsRx0idhN/7z9GZLqdEMBfaDGvXKNNRHCv0XnAm5QRxy45jg1wK/SC4WRhxuHW+DndzMXIJE2kKa8ibWd3Tjv69H+oD1w6Qq1RIfKsvrhUGeZMUDD0+4EmN63566OWDwantWPD1Xapa/Gd7ZieJ2mS3XoYuFB6xwQJKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l16pDzghuDRsAuja8p75FbXoGk4Y2QEWcRkRnTtPuUU=;
 b=RC7oKg69BD7WxL15mibKRNXJgW4i6RHwIFG/x/8Q73JCVIYqfYlkfHP3oG8dr5yEleaXDXIO3QTLBhDRM4qsoaSEp69YL/6dsesuq23QBCKdlVAoivb4PReMpwjXg38iiP4Euca7ONJ1yMT8zkhu7DkhEU6tjTPnAiW9k8eZK3g=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DS0PR10MB7979.namprd10.prod.outlook.com (2603:10b6:8:1ab::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.20; Thu, 7 Aug
 2025 16:29:23 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%5]) with mapi id 15.20.9009.013; Thu, 7 Aug 2025
 16:29:23 +0000
Date: Thu, 7 Aug 2025 12:29:19 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Andrew Ballance <andrewjballance@gmail.com>,
        Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
        =?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>,
        Benno Lossin <lossin@kernel.org>,
        Andreas Hindborg <a.hindborg@kernel.org>,
        Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        rust-for-linux@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] rust: maple_tree: add MapleTreeAlloc
Message-ID: <jfqpnx7iatu5q3tnzwhuv6cav5y2444jyyjxnia3py6bqfb3bl@ijqc35utzpwk>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
 <20250726-maple-tree-v1-3-27a3da7cb8e5@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250726-maple-tree-v1-3-27a3da7cb8e5@google.com>
User-Agent: NeoMutt/20250510
X-ClientProxiedBy: YT4PR01CA0336.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10a::20) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DS0PR10MB7979:EE_
X-MS-Office365-Filtering-Correlation-Id: 273a87c4-4eb5-4eb2-0de6-08ddd5cf918a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?hwR/f9hOG8/YltcBo/dFEiuivVB89GKk3VG+LWcZqkvy3kKjD22nPwDwYGXC?=
 =?us-ascii?Q?q+yiV4rHUxilHTPQQshQR40ESEz6rV6+9k97WscoSCp1xdb3ncIxO69M2mO/?=
 =?us-ascii?Q?9Tdm/silVUjw0qhi2NtoCvlsf0G1Okzh8siZwx0U5zaILV39KK2BugFPn0hD?=
 =?us-ascii?Q?aO4XUWgfhbyeqYmaaFAQvwtIfbt5V6tZn1ciStFW1mS1FRZogSM++3J2j8zv?=
 =?us-ascii?Q?1/AsEFh2Uer9iMGl9BjIzcABt5d7hzW+Clil3hhYpXvxpmvT2y9UY+MjCU2b?=
 =?us-ascii?Q?5huB8fmlO7qAaXLqjplNM9R1IcEvJXgPTKSGNSSjvPBUVcvI/Maz0UgofmcL?=
 =?us-ascii?Q?k3BlIH1stpATAWFQU1rjk+9wFjt9NsJoQhN8+BdWeUyxwkxM2kD1izPrgpiD?=
 =?us-ascii?Q?XDjPjyQ/uJOe8knDucwCc5ZoJ7kLf6rygN5a8QMsd5mhkHCPMYBf+y+PTmaH?=
 =?us-ascii?Q?t8OmxpV3RaEtppPPnr7sF0iuwF2vm4AnOv1Z3zARKOikBXfj0zSTNDK1gtb8?=
 =?us-ascii?Q?r3DwlHbrJvv3zY+6kNIOYPpDyLURYYOkGbW77RIKCUsgBXynySp9YStwqicd?=
 =?us-ascii?Q?xZi+5tGdCaPoepnB8nNmmQzHxQIaG0PbXyS/CN57AJqCooFAiuvHmf1/aspZ?=
 =?us-ascii?Q?p6aMRssmgnGocIvBfIaN2qcXQW6UK+88UbF1I3ZYdW11wV1Jz3pIFljsXhN+?=
 =?us-ascii?Q?P5AfDjOe/x4bkeMweginZc6oT2BPu5e6QlQvtCZzZSVFLBRtayuc9fAv6kCP?=
 =?us-ascii?Q?6b1cYHRk/idMuDE+i2ehZM4s76W4219nWXqJeoslc/5u76eEyLBHgqK4UEnf?=
 =?us-ascii?Q?BKLyKdDJuqKIPDagLbl+7GU+7HF09d2NXUjAC/QSoWsNxF8jty7dSZ82Yqw4?=
 =?us-ascii?Q?lJTQdWzEsgVX+5VIafBRh6u/d6IHSyawZ5u3Ylz7wWgzqNU919gSOqFtAy5J?=
 =?us-ascii?Q?LAwzI7t6ZLD+mQeEQw/MSvpQxwaQidSla/jg1FLuccRi3eJp7huR94S3c4tS?=
 =?us-ascii?Q?WLPj2BTjGKorkMo6UgWhZg6UK1nZZGRteLhMCxhgt5bBfMbp4If6aRcWsrAc?=
 =?us-ascii?Q?lA6tEMTE5uLN8qXiwsvCRTOc7emNh5voZBtsKR5elRxDqaeyqIRaGDugy4PX?=
 =?us-ascii?Q?aPdt2PHnsWRgfkSh8+4wDqyADGmyLDclXWQEsImxlW/Goat6B/VARYN2xDTs?=
 =?us-ascii?Q?ARzwVMBhCOxxYj8wltgIA5i0J+1YXf1h4oA0c5LdlIDUbZ5LWysFquyC5kat?=
 =?us-ascii?Q?FI9wEw5kkepWNWGJhibYoCHrwAhZoVkkPu393L4o6KZyE+s8c3iKvcJB9GSp?=
 =?us-ascii?Q?GXthy7/GJqeqZQNuBaJQ88gg9jaU63dKVdVDdfxTRLhnv/SXbbR9cnyZd/93?=
 =?us-ascii?Q?ytLGb2Fmk1GNGyVO5rAc8lEQR4VyeePcHvdWuLuVTM7xjkpWT3DK4D495aVb?=
 =?us-ascii?Q?GBqQvVCikUE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Txj5P2bn7UZOquphDDP4Nz/tIAECcQhTvgmLMdLF0tJDMBtf62ODpC+w7RyL?=
 =?us-ascii?Q?SPtCZMe4ExAkszKnSewxkpcbAmGu9tscprvTkKHB10HX3TaP/sPUEghJaDa5?=
 =?us-ascii?Q?1XlTz8kyoT+Zm/6gnkN4c23ai8b9cRr+HEsOr+dVzZWifzAO3RJcn+VjJdIz?=
 =?us-ascii?Q?PRMjP9yqQCD6fbXDZj2qEsnuzvAthLSYEqCi0wS6MRIbu3Xo4+cDjuJ4M4oP?=
 =?us-ascii?Q?Fk0D2Co8WKDlGmEY9oMxcuHRZbnyNSWN/w2EEmcsSETY5KMwLMnPZzJQlMpf?=
 =?us-ascii?Q?3Tc7Smy+rH7ilQfcdgTAw+zSXykC5aL8P2Mkvb3lxdbn9BwNB95oqsm3SyFg?=
 =?us-ascii?Q?hCqJ6rn/Wgvr+sh6RTRWhpVYBmwz0w8TjTCenHSJZr//qZnI89xOGyEJscI4?=
 =?us-ascii?Q?uknH932xzMonGFE5qpEjIA5Qc4Jahl4HxsRVKKs/LS3VQAnGcdDyMa8Nelxo?=
 =?us-ascii?Q?3xASB4EHrAEnc3LD4WJy4UeVjnZk8eHbIKNqIEZOLtTS0kSL3EtapKYQIkUL?=
 =?us-ascii?Q?K3ESFtjGxky0pHc2QS2vPo9tJ1aPm7u/fmCwJZcaelu+yBBQl/r0Xde5bcr+?=
 =?us-ascii?Q?fgIWne3nZxuxK+8Tn+vzcSjCRUyTGKquzt4DyZotQ259/cQzokomjX2Ztdxd?=
 =?us-ascii?Q?NopeKB5IEJNTzlfmZuMLK+nF+6sndm+QZdPpIP8BlPTG4yyCaPpq6klVwipr?=
 =?us-ascii?Q?Vy6uskZo1dLodHi84w9przlbua2kmkoCQ+P0ComhjSmnZf1pANyE9op1N5YI?=
 =?us-ascii?Q?TwSv4iqyAjN65zVYUnI+h2tGfNh0qY5dl2PMsHn3cq5zZyGD0MlkYSVeSB/2?=
 =?us-ascii?Q?nA2DaAN0tcH8uwCfX9vANnfuVftbh3tEyqMjr/zfNdkZrCftf5YL+Gl7VxH+?=
 =?us-ascii?Q?C/2TWS3gqxY8X7PV3lML+tDZrI1d53q6ExnEKJeWPNb6aLfbC+D64ggto0M1?=
 =?us-ascii?Q?x5sRkN2FrgKMZj4KTvSoN1B0UIHH82c3PxPuzQBDb+L0J702iaED8AH/GWdL?=
 =?us-ascii?Q?ymnMlq4ui6H4OiwmCwzR35ZSrVWQ6/QwH6NOyx2uU09/ewGzew916+1ULKZ6?=
 =?us-ascii?Q?Nbr1oCYW+72egtlLFOYOtuujLBkoWbavigPAwT4ESuReCuUJysKobYoaHwUa?=
 =?us-ascii?Q?eqzX3KMnj4f/lqbFI+u8D1HiO/qSsVZh7GK4qAXOjAHZDozDCZZCMpqRDsHL?=
 =?us-ascii?Q?P4C/x/Ap5jfQgusdgta+q4Hv35weaDAatikQS1tBrTAc/TSEc1/xrsFqel3M?=
 =?us-ascii?Q?KHGWYYflxaN/F3WZfJcqrEdRUxAjR9MOzz27r5hrS1xvb0sM9iMtE8/HFJnA?=
 =?us-ascii?Q?TU4W5oyevW2ae7bdnkpee3zO52j33+FB9DvKgVw1zZ5KCywK433iE/QSenSq?=
 =?us-ascii?Q?qRYSVNZzOh6GKF5t8PXSfajb2mqbpih6f2++R1rkUboxtBcSm5dzmW99zsXi?=
 =?us-ascii?Q?DJFNBPnBn4gbimZLQHhqAyVfppvZPuSVOGzs+75Ph2UN76t+w1O2bWEUFkTJ?=
 =?us-ascii?Q?jluC0hIUY8SdJJpXvKgXb9+WssVBkxvVUh19IgNBgkusFoky+cb72gi9qtTD?=
 =?us-ascii?Q?rhkA2X8O5BDZZtinE2YzhmdtpCvkdoO1jKNLzrvp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MNJqaOqMptC91bn253rc+8Pv9QVpV0w13oYnNxSZ+1+rkL1U/YRV8QW5MCpZ76JV8UUXA2RpuoLoEDZMddLtxZevOJ5D6PpFGdDCLhVEqZyXBg/YXfX6uIeSIp/zjNw1ccW55y9D94fXZ30yuy+Sv/TPgOVVF2l4eJerZwG5wBffK4W7VhWEHy+zTUfsg2FlC2CRwpGd/DWQoukybPnlaLwUQFa8N8f8Zsy5DRKsezuqklQqVXAlRwmDiJXZRX/Oewe/IopaFcYXShh9XMPVJoWWL/RhX5CDfyLeUUTahPWjGS+li5ka76iOX/QO/Z3gBVBFaUaG37+nQkoxKmzunyYefCAJxmnBpkYDg6KJa8U9NP32YrSeOLJyAhWPnFrUbifqYfLGxO+bYuog8PDBBjBDb7nO2D0Hf3IcXwKjPUptgYxoxTViFEzbiQHYsXmlFCEhfTCVxoifV2aARUqMGoFCdSwDBpE+z6Mc9jtdYtjiLYyrZuYLF86hVtTiKgvbOoMm2JZausztjNZdI89FtlI+0BOVnBKBE0PWrFN5oc2BPD9Q2XbVgNWcK3SWVD5hBOcxFKdjGZSq+Qg/ay6hplP4m4TY2CVwkJZvwSm29tM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 273a87c4-4eb5-4eb2-0de6-08ddd5cf918a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2025 16:29:23.5180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m8Tr1AxEi0vk2LklzBbHXidtj/flbFXndwl66xM4hx90xFtqUdO/hUho7ul+2LHGQvD6mqjEDWOMN8TjvdgwMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7979
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-07_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 spamscore=0 adultscore=0 phishscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508070134
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDEzNCBTYWx0ZWRfX93txX6bSI0vg
 xrPWz36XkF9KOP6M3yM4+vknUjPYN9cIj6I15VRzowg4fHq15Pjcfe1g9FdZgpDuQUv5UA6vv/q
 UIULHvhIyLf7fC9pTJE8WOPKuzJ8S3pvb1ZScriLzqOXkVScLXIDWCnpI4XpQUNDgNrkbMAmuZ0
 Q0gYRpOTM2jbFFl3DQMmbY/5vhs5q8XIzIF7RaV6fuMVF9tHvSpKeIyFOCj1jJEfd7v6XyF0YxT
 dmponJYIOtV3IfNI5F1pvIAg5phhTv4H++S6CRj2cgSpgRNb/XHlmReXoRCyWOP3wfMO3ih5QFz
 s0xgZJ08CpvgqEh6NHgQsv0Qfq3tcJHtV2Eri4tVHN8yuUX0SPtiznyw2dlx22poqdnc2J4kjUm
 gdu2qG3PtOyZWiXu22/Tpx5nvcgv22NZGzgqqj+7pBVuO7FhG1I7fByMzenXhZKpa/6IG4ZU
X-Authority-Analysis: v=2.4 cv=ApPu3P9P c=1 sm=1 tr=0 ts=6894d468 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=1XWaLZrsAAAA:8 a=TrWHwkQYThArbQDjACMA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12069
X-Proofpoint-ORIG-GUID: zsIDP28sMhBEnhmnHJUHCGFqTqUqoSBh
X-Proofpoint-GUID: zsIDP28sMhBEnhmnHJUHCGFqTqUqoSBh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B315780009
X-Stat-Signature: p9pgat43rpppn7d3cpuwpj5mbujdyy8s
X-HE-Tag: 1754584175-988826
X-HE-Meta: U2FsdGVkX19xUmNbULRxfqrS8P/l/Nd2tcvRHaV46UAN+xIviPM0sBEF38UHunZzV2deGTvYZ++NfPmxWljKKjuvKWcZq/z0rOdYi7MwKzNmAmS5nbsTlaNX3MKspZCYFLe0NUpdZmnLTKSZYTlN+ZHQltFxFwA69Xhht/GTSha7/ox+CMGW+kO51IpvGfB0bwlpdf9CFCCl7TA6d7qtaqOU04EilfRmTgnvD+2OEFvenRrtnKYLdwd7PT+z7wVILodHrG0x9KprMEaqP1fDMbtrUh59+YsamNXOE6L/vu8lC7ebjxLro/hR123CbDVx4XVel+ISu3qRsMsNmxbRb3oJuT3nIbizW8+ML1VOA2vSZkjMG3r5J/yRRN6WnGmUhIeu+ZCvLDT83+4VKocr3hRYuAI3vMeKBRXUtTnHgBaGW2JLaWm+PJrqjsTin+CNd7qVp6HxHxl/mksQWU6BwCDaww5x31PZc2TvpYjKMKStQ9Uj4q12qeLns5ArLnCnT+CRtlbKHWTGxRECmYWRfqm9OuBMrwjo8dTF4pW0fNf3eaR2my2rK8ifvQauhnpdd7u+IEDWhEWRb9vG8aBc4+PvUcddL3u4GaFVMi+Jvu8HmJo/yV55q0bMdNi268SJC+pXcbsNX15gJp+IxYxk5iRir7sIcTLFZQvN10UdUhzNWEI8fZpJEKwN9tAchmuCdeiAvkObFbL4Dvz/DaC2/v4MwP9EYUhJdFHp+JYJ803s96Z5N2NbgwYfnATH/5+oEvoU4m++TKv174UwlDTrP4Cg+5d6xrLe+7O9Qg/wYIYDYVgZm9U6gMy7P5+BO6OeEY2tMuEiyPU/k7VWNjPVvMvNXyrq7wYzqQZhDZPsl8juL+u8hQPJM151qANSpiK0HKLbcEYFOsNmjVszqdyHs+SH7sDBcpC/bgBiqfR1ZeHCtzwM29sSrtJjdUjezQER/tiSh8aAiBBQGVxnX0T
 0/4Qvznx
 YT/HVUgZmgtbkJZayjKvhGn2c240y1jLjapWOXn9wCXWXqbbbYXLYPVcIJg+pT+KTcQvTciW+z9gvPLFDLiRJs2q+ezWxSAmUt0qtBxcQBldvgQhWTVN4tHhPL+jRfYsqn41Pr4RqPMPSVcPG5EVu6RjvOtOZvzhr7cMO8heDNBdR11ohmYOqHT3T6ySuxOpSif1KEjXtwnJ2dwpIDQQoVJS7KWoqM5FxnXNNekt3tciGjgvpI61D4ODCcJxPCWr7Gvjiu24cy5ert19ejM4bBXR8GWcjmDYk3OsjS3X7o45qlYUF1UrU1uccsMz16h3UUr/9y3vmcvs13chm/UzXOnO5KtGQB2Tqu6Z1CbWAWA99Y7OKy4XN8PZfkayi4mUzgag/PywHPjcQfR94pDruT8Rq3tA+AGHVkFjZw3lEXWVfXJVdlMdKy5qXwmmuc2MUHRkohBg75LcHyDz8CW2xrn2H16mEvpuW5cFgWUbCd758H9yqhgiDHCKJE1EQN+7VnM2nYN++5oVsk1Mft6BTprl8oz7scY2n7yVKizOqWVsOKP0TOQ4yS2WGdiuAxY/YDuus6ZNXJRTqsbEliQ7njrhuBQqTs7QAGhfmYivtInIjoX0zLHlxvSLCjdZKD/XOvgvcv0MUzDKUFdPsE9Qg8y2/8EpsXOcKqFVvrxc9FUzuvz252n92It5UBtQpu8x3V1DNsGaK1xmSPLH19dvrFmuJcwmpiOdLZ61LiwLsPC0tiuIXMK2MAyl382RoB01b67yvqyCnByBAqqx0hO3ITs0K9P9JWOZ3MXRqE/Y947d8mmZYR4qvI401qfhLyXt2xwgDyCa13NWjY2c+TcVcD++hTTwDaeiKWzSK/ZMg4c4TaMQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Alice Ryhl <aliceryhl@google.com> [250726 09:23]:
> To support allocation trees, we introduce a new type MapleTreeAlloc for
> the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To ensure
> that you can only call mtree_alloc_range on an allocation tree, we
> restrict thta method to the new MapleTreeAlloc type. However, all
Typo here  ^

> methods on MapleTree remain accessible to MapleTreeAlloc as allocation
> trees can use the other methods without issues.

I guess this is for some rust side error translation because the C side
already returns the error?

> 
> Signed-off-by: Alice Ryhl <aliceryhl@google.com>
> ---
>  rust/kernel/maple_tree.rs | 158 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 158 insertions(+)
> 
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
> index c7ef504a9c78065b3d5752b4f5337fb6277182d1..8c025d2c395b6d57f1fb16214b4e87d4e7942d6f 100644
> --- a/rust/kernel/maple_tree.rs
> +++ b/rust/kernel/maple_tree.rs
> @@ -32,6 +32,26 @@ pub struct MapleTree<T: ForeignOwnable> {
>      _p: PhantomData<T>,
>  }
>  
> +/// A maple tree with `MT_FLAGS_ALLOC_RANGE` set.
> +///
> +/// All methods on [`MapleTree`] are also accessible on this type.
> +#[pin_data]
> +#[repr(transparent)]
> +pub struct MapleTreeAlloc<T: ForeignOwnable> {
> +    #[pin]
> +    tree: MapleTree<T>,
> +}
> +
> +// Make MapleTree methods usable on MapleTreeAlloc.
> +impl<T: ForeignOwnable> core::ops::Deref for MapleTreeAlloc<T> {
> +    type Target = MapleTree<T>;
> +
> +    #[inline]
> +    fn deref(&self) -> &MapleTree<T> {
> +        &self.tree
> +    }
> +}
> +
>  #[inline]
>  fn to_maple_range(range: impl RangeBounds<usize>) -> Option<(usize, usize)> {
>      let first = match range.start_bound() {
> @@ -342,6 +362,107 @@ pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
>      }
>  }
>  
> +impl<T: ForeignOwnable> MapleTreeAlloc<T> {
> +    /// Create a new allocation tree.
> +    pub fn new() -> impl PinInit<Self> {
> +        let tree = pin_init!(MapleTree {
> +            // SAFETY: This initializes a maple tree into a pinned slot. The maple tree will be
> +            // destroyed in Drop before the memory location becomes invalid.
> +            tree <- Opaque::ffi_init(|slot| unsafe {
> +                bindings::mt_init_flags(slot, bindings::MT_FLAGS_ALLOC_RANGE)
> +            }),
> +            _p: PhantomData,
> +        });
> +
> +        pin_init!(MapleTreeAlloc { tree <- tree })
> +    }
> +
> +    /// Insert an entry with the given size somewhere in the given range.
> +    ///
> +    /// The maple tree will search for a location in the given range where there is space to insert
> +    /// the new range. If there is not enough available space, then an error will be returned.
> +    ///
> +    /// The index of the new range is returned.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// use kernel::maple_tree::{MapleTreeAlloc, AllocErrorKind};
> +    ///
> +    /// let tree = KBox::pin_init(MapleTreeAlloc::<KBox<i32>>::new(), GFP_KERNEL)?;
> +    ///
> +    /// let ten = KBox::new(10, GFP_KERNEL)?;
> +    /// let twenty = KBox::new(20, GFP_KERNEL)?;
> +    /// let thirty = KBox::new(30, GFP_KERNEL)?;
> +    /// let hundred = KBox::new(100, GFP_KERNEL)?;
> +    ///
> +    /// // Allocate three ranges.
> +    /// let idx1 = tree.alloc_range(100, ten, ..1000, GFP_KERNEL)?;
> +    /// let idx2 = tree.alloc_range(100, twenty, ..1000, GFP_KERNEL)?;
> +    /// let idx3 = tree.alloc_range(100, thirty, ..1000, GFP_KERNEL)?;
> +    ///
> +    /// assert_eq!(idx1, 0);
> +    /// assert_eq!(idx2, 100);
> +    /// assert_eq!(idx3, 200);
> +    ///
> +    /// // This will fail because the remaining space is too small.
> +    /// assert_eq!(
> +    ///     tree.alloc_range(800, hundred, ..1000, GFP_KERNEL).unwrap_err().cause,
> +    ///     AllocErrorKind::Busy,
> +    /// );
> +    /// # Ok::<_, Error>(())
> +    /// ```
> +    pub fn alloc_range<R>(
> +        &self,
> +        size: usize,
> +        value: T,
> +        range: R,
> +        gfp: Flags,
> +    ) -> Result<usize, AllocError<T>>
> +    where
> +        R: RangeBounds<usize>,
> +    {
> +        let Some((min, max)) = to_maple_range(range) else {
> +            return Err(AllocError {
> +                value,
> +                cause: AllocErrorKind::InvalidRequest,
> +            });
> +        };
> +
> +        let ptr = T::into_foreign(value);
> +        let mut index = 0;
> +
> +        // SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
> +        let res = to_result(unsafe {
> +            bindings::mtree_alloc_range(
> +                self.tree.tree.get(),
> +                &mut index,
> +                ptr,
> +                size,
> +                min,
> +                max,
> +                gfp.as_raw(),
> +            )
> +        });
> +
> +        if let Err(err) = res {
> +            // SAFETY: As `mtree_alloc_range` failed, it is safe to take back ownership.
> +            let value = unsafe { T::from_foreign(ptr) };
> +
> +            let cause = if err == ENOMEM {
> +                AllocErrorKind::Nomem
> +            } else if err == EBUSY {
> +                AllocErrorKind::Busy
> +            } else {
> +                AllocErrorKind::InvalidRequest
> +            };
> +            Err(AllocError { value, cause })
> +        } else {
> +            Ok(index)
> +        }
> +    }
> +}
> +
>  /// Error type for failure to insert a new value.
>  pub struct InsertError<T> {
>      /// The value that could not be inserted.
> @@ -378,3 +499,40 @@ fn from(insert_err: InsertError<T>) -> Error {
>          Error::from(insert_err.cause)
>      }
>  }
> +
> +/// Error type for failure to insert a new value.
> +pub struct AllocError<T> {
> +    /// The value that could not be inserted.
> +    pub value: T,
> +    /// The reason for the failure to insert.
> +    pub cause: AllocErrorKind,
> +}
> +
> +/// The reason for the failure to insert.
> +#[derive(PartialEq, Eq, Copy, Clone)]
> +pub enum AllocErrorKind {
> +    /// There is not enough space for the requested allocation.
> +    Busy,
> +    /// Failure to allocate memory.
> +    Nomem,
> +    /// The insertion request was invalid.
> +    InvalidRequest,
> +}
> +
> +impl From<AllocErrorKind> for Error {
> +    #[inline]
> +    fn from(kind: AllocErrorKind) -> Error {
> +        match kind {
> +            AllocErrorKind::Busy => EBUSY,
> +            AllocErrorKind::Nomem => ENOMEM,
> +            AllocErrorKind::InvalidRequest => EINVAL,
> +        }
> +    }
> +}
> +
> +impl<T> From<AllocError<T>> for Error {
> +    #[inline]
> +    fn from(insert_err: AllocError<T>) -> Error {
> +        Error::from(insert_err.cause)
> +    }
> +}
> 
> -- 
> 2.50.1.470.g6ba607880d-goog
> 

