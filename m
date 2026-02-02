Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A224E7DEF2
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 14:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6268C6B00C1; Mon,  2 Feb 2026 09:59:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608546B00C2; Mon,  2 Feb 2026 09:59:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CA256B00C3; Mon,  2 Feb 2026 09:59:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3670F6B00C1
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:59:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E2F1AD2C52
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:59:00 +0000 (UTC)
X-FDA: 84399824040.19.7001E1D
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id 60A411C0013
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 14:58:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GMewAOFx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZgghFN4k;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770044337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GyHDLVQWdpxnJmQ7Zon0Grk2Xg+U/1ygXHw14Ts0moQ=;
	b=nLxq7q2G7rDNsfNgugb/VlPQtg015IxAMhhMg0JVvrbbdhi9KX7J7Urpq1XuC5u1RKOw9N
	C8b3N3fVbGBgsH3i2QUppm84j+jV0IIuyL/ZCRnwO08TXbA9sljXWWsQmYJ1x15ZVy32nC
	FoWjjSX77iGP/TKkrHbcVHw0liuHw8o=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GMewAOFx;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=ZgghFN4k;
	spf=pass (imf20.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770044337; a=rsa-sha256;
	cv=pass;
	b=pG2T377vIZJv4s3WE/KoxIVbBdWaTh7Tzopm0/0qJpcaDAGPv3RlGL5bSfdq3S/Mhz2vFU
	6q0i4Ke/a0/lKGvXhKEsIfMCktYCyPXNqDR2wf76Yb9tWa3VUQnJC0WIQHKqGInA5Fde2B
	pWZ5pX5b7oN/gBdwNhdNRHUnN5g6hYM=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6128uSwS769181;
	Mon, 2 Feb 2026 14:58:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GyHDLVQWdpxnJmQ7Zo
	n0Grk2Xg+U/1ygXHw14Ts0moQ=; b=GMewAOFxPbyEEKGdCAcXG8RxKIBH93QRol
	GIdFA2XtgMzLQociNFGZdRqdFT0b+4ROtLZmHawsnQIzadQxZbsD2dA/8EFnSBww
	Y0w3ZBKVRwtWl7lG697lePcC7hWjN1uqBiCfVaHBXETs+2XAn3meGhtI3F8XUHNf
	5qWOY0ZcUNbfy9/Bj0QiJJssIpCMOYpolESBc5bsnrPpf9Dt73Wzn2cr60+/PC4p
	ZoCC6mzlExkn7VTbakVSLh4N+RXcco/QvgkXRFja0xlfvH0Cx0D7vAocaDzkJgtk
	qzUW7XR0a7WOvHncWvRyjWbxvTJn7kkRf4BDYpnnDZ93+hEzInnw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c1atajcet-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 14:58:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 612EA8HJ002182;
	Mon, 2 Feb 2026 14:58:39 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012012.outbound.protection.outlook.com [40.107.200.12])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186k14en-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 02 Feb 2026 14:58:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o9Nc9XllSOaxEiJyeh0fbEg/O5BOiLGbAvYFQ339XXuXWXn5EYphwoYRlJCLygTDL8qasoYDOHz6W0JmXEUh8zA4pS3kRGH9dp0JMNidznLhYumDO8rJnRChBUhQLT4pG9P0NPPdiT+kjKDvt+etkkJE/XzZQ6R/rBshA2JQjGI81iShtVJcKYMytJzqfgoTfH3BjzWn6IeFD1I+rfNx8Gd0csCA6uAZkTO/NXbes0Y6h+AFZCT45HFaL6ftmxgRSfXrbVFuytp1fNBKNJN56UH75iPg66Oi4AffFP0C1O36yh28lTPym9TPJ7IYB9WELzv4lpXhoKOXXpTPMfyQCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GyHDLVQWdpxnJmQ7Zon0Grk2Xg+U/1ygXHw14Ts0moQ=;
 b=uAE5wZeqeXKNeDsZc6pm8Ge5iQ/FnW9Bj5h0n9kd5y9vN//UWZ4dTythfrm8zx2r6X7N+hQrIgmueaEvOOB5tbiunfF4PLj2oFSedTDcFp0FVaetY9jl1Fk4aNkW6ACqvPqkRnPr9NZnkXjulwTZRbdsKlsmdXeWUImnUOlTHu/C36jP4PFWtv0moj70AmgoG3Du90/ppz9PdbDGlTLt4j56b0UBMUbb59+DT3kqcpghh6ONGrl637nFW4CpvJgHVg9QTK8ijyPfirSPU4pQRC8gQUx3QFu5B0Pv5wBC0LgduV9reKoSUKUFYH3x0M80IdzSTM6E7STfUwsb39h9Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GyHDLVQWdpxnJmQ7Zon0Grk2Xg+U/1ygXHw14Ts0moQ=;
 b=ZgghFN4kW1y8EVWxDSh+mb9TsU+fapW7CRsCKDhW01oMOURg38bjSPEnyL3YX0j/tC9HorYbM0otuYCJg7GCdcvn7En0ecCmQbnzlapl+dECw+4Fzi17mr/+tdfTUEYBe2xv9rOkm5bY4A+4lwUa71BpX32NKNowPfz5SJSjbCY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BLAPR10MB5060.namprd10.prod.outlook.com (2603:10b6:208:333::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Mon, 2 Feb
 2026 14:58:36 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.016; Mon, 2 Feb 2026
 14:58:35 +0000
Date: Mon, 2 Feb 2026 09:58:31 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH v3 21/30] maple_tree: Add cp_is_new_root() helper
Message-ID: <hdmikz55tn5gwbl6y2bxwo4gyt4dc6bc7u57oidwbotncfexeq@efa6s2xpgkz7>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>
References: <20260130205935.2559335-22-Liam.Howlett@oracle.com>
 <20260201001043.88706-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260201001043.88706-1-sj@kernel.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT2PR01CA0024.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::29) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BLAPR10MB5060:EE_
X-MS-Office365-Filtering-Correlation-Id: c151c893-c00a-49d9-b8d2-08de626b8a0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Ai/+DKuuNc/oebUaNVDMcAEJl4tbvYHv7QfCxhg0Adn5hM6hsAZc4GxRDM9u?=
 =?us-ascii?Q?305Jbm9sPXkIqXbQhiKereEo9A9173WsHzYQOPl219voGo8PxBDbX+NA2p6v?=
 =?us-ascii?Q?L2S0RSUxP/l0oKU7h6zUyKe6PnXmxFiWZ92itltwAyrhEGnXqBOV3zvoP+Ad?=
 =?us-ascii?Q?d9/AGvsKvv0ano5G+PcEfyxzzlAb+xDepXxH+mpLnUGIHLfLrqFacG9YGRV/?=
 =?us-ascii?Q?DNibKyclttjrm0qdazs2Fbm+RU/JcgeQp2k2Qi4pjCO54t1uZYDDWTDG0Mhg?=
 =?us-ascii?Q?c75ek4T9UAv7g1pGdXMSzZHzAshoDMDJmadwKE8xfG+QWoI2JPKLefP9tPTi?=
 =?us-ascii?Q?bQgJ2cAcRCN5AzNySF7BT9+V5tUkXJ4WM6jI3sWXKs15gbbZANgxtW+Sr4Pr?=
 =?us-ascii?Q?q2K87JbxglKWFcK1ldgGiZfe+eEDn/8ECbwzqgNbGAG/w0xR2ixX7s50e9qh?=
 =?us-ascii?Q?PjXJJQSAinkSFRH7nfq+cw0MWIyQptlBw1g1mOeXunQzqbX2a2mb5vHz7QXF?=
 =?us-ascii?Q?HgYEHRIoRsj3F/jeuTJjowFMRsCW/xxZWjkGO6jG4YZBqvFuFNN7NrYkP1y9?=
 =?us-ascii?Q?bfN9JJIe3+WOH92lUIJDXQfvJl3rMB5V/J/pfrlAEm5BLVeE5U7bABLDz7jO?=
 =?us-ascii?Q?DL6HIcyrE1D2tNzc98fg8uD/nz2cVD3NbssvU8yUi3ROYmjSq5alWpYSlupZ?=
 =?us-ascii?Q?UVWBS2uhl1Bid+p7fwict0S6l0trN4j2ppG4yftM1vF16S1yryitsD8ZfmFi?=
 =?us-ascii?Q?RlRlRsdoqr39Ftr0TYfl+2jWADAcf9G+JFNW3HGKGpqCQynTXInBoUODnufu?=
 =?us-ascii?Q?CDKVBuvw12igbIcSO7hY4AmmsVPPnSC2rZZslLioB955cxLdm+wTODn77kH0?=
 =?us-ascii?Q?vOzVosgFxltF43KVRpGqdqBh3MLp9fH1oCKfyfgXqVXcpXlxbeV67ZKXplZR?=
 =?us-ascii?Q?ExrgoUz/h7LmJoiBZSPO7g2irLBP1emoqrfvaod+7XXIux23TcQBIDR6gxUJ?=
 =?us-ascii?Q?MbirVO59dhU+PrREBzOSJXZzvbjRcnet1Yz99j5Ait2XugvTgz1P6qw/8X3C?=
 =?us-ascii?Q?hDuDX2ptFRqSgZD3TA7jPn/MxDx0aDGy/1eRj9b3Vm3uT2sn9Zg1tW4tw5jv?=
 =?us-ascii?Q?jpChJpMU8QQvlX60V7l+lRWA+LF5BZIZb7BlVcXG/60eOKnYJLI/VdnIpJBB?=
 =?us-ascii?Q?yLaPjs+vbbQKGEG+nkwHeW/skIjjTKZ5DfluN2nM9wwzVJqxLA8FLRLYBztV?=
 =?us-ascii?Q?zAWYGYrGmwWk4lsBd8jcXAc8AefaswFD4MdtkqaAKrImZeXgJp70Aw3pQjsY?=
 =?us-ascii?Q?R1LZvaBTplpy1oLQKvCgvrvw0qc1C90eVZNIfnsk3kZKN9NnKr7C/RFQxJOF?=
 =?us-ascii?Q?mMEHZ1IvpQ4bFIcT5Owpb1xRQeJPVdu8TnAU4X/zqD1z6OJ0chHldTN6g5Va?=
 =?us-ascii?Q?ojr6l5ZQX4bhipgOHxu4PQvcRLrLehJreXAdgCcmD2CDtiOw5VJoVlX5Dt99?=
 =?us-ascii?Q?b8vmt4n5+bMrl/TmuVCxcPIpSRtrslzvn79K?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RIhI3La7TVCT59U9LvdxME7tLfzbR25IesgW8Mc70f88SuMzDk6LWQU0iMDp?=
 =?us-ascii?Q?7rsWpHZmgbrzfbSf3WWS3LTNrALFvVWRjtToJ7KvoR432IDQCoK9a5KMg/gs?=
 =?us-ascii?Q?XC1rM4HS+nYiFyne12Eth8LUrgnweH6I4B4+Cwimqf7tw5y6A/U8rMB4Iga5?=
 =?us-ascii?Q?shPAqRJyJPTyJb59GDPtZwvxapKSon2yUZekAGXWdjLfDNspof6PQRFt9Tgl?=
 =?us-ascii?Q?G/yVeIWQNb640VU/pgQhZ42jeE7dm2FuF8QKBY3dvUAs7FkrqSxEAZBSCTAS?=
 =?us-ascii?Q?v1k+3mATIYGu3FEP05j8zBIxbwOgTwxXXtAvhNPwmcuxqlPX5d6PbIN7lZdr?=
 =?us-ascii?Q?f6G1MeQgAfH52uqdmS8z9oDQeZE3KeC4Ce3wpi6UU5N/7Di+Qr+zaioc6vMI?=
 =?us-ascii?Q?vORsN4Th0eNW7zmGylIQwV5Y9cNx36V1TJfnbjtLfeqQCXlyXvVAWswL2cY7?=
 =?us-ascii?Q?ujL/Cd5p0sdFEaSRlojaKNqS/8MxS0S7shhmN+JYFndtlAVueb80kq23yH2C?=
 =?us-ascii?Q?23B16vjCKKevkhV7FIqFVRp7ad86jVe+FMyyy5TCzDpFBT6aHOFPHn8Upszt?=
 =?us-ascii?Q?fl0LB3Jhpea6Yjgj9j0gAoUD9sJpyiNYYTUNbyKTHolYiDkvsTLqnqIQYMr+?=
 =?us-ascii?Q?7fAZFmtTGsUeW30M3PmpDNR3U42C1rq8y+nHoRIOzlc5VodCwqLWizTVOyRD?=
 =?us-ascii?Q?7iFiTFrZ8Mlspi3kHAENgf80zgkyqBlxwFz1oVL2VyUEP6dLZ+iByauFN/Bg?=
 =?us-ascii?Q?aQE5RYqh+oqOUPM3HV/BmZD3rDkFYmrzljd+HvNQwoUGLTE91H7KaqOOASyJ?=
 =?us-ascii?Q?Ia9rkgoucuUQdNVTltiHKRIlm3kphBKy4Y/pmsJCxvupwuBtmHK1a6P0HE6e?=
 =?us-ascii?Q?+DhpQMMjTAOZLQj2ae8gIOtYL2NwaYjcPAQpsaIlnd34b5C7didz8JxAP9CP?=
 =?us-ascii?Q?aqUCP0qd9HrFKyTbcK9kg4YAKlCghUvdOBrG8XLGz5H7FkjJrTzIggN43Ttb?=
 =?us-ascii?Q?xPWcbi7nGLlr2u51ybAh4vJ9e5tZ5EXo2GdT6T5QMMBlODAGxoCUYqBZMfQI?=
 =?us-ascii?Q?W5ubymlwb7vcT4Kn96xgIw35h/DH9Fr78cSBR6aKL+PagA3K8dj2+8E4hSLY?=
 =?us-ascii?Q?dIGfd7SzxqWefdTXi8dFCadFmXdcpjGNqNjnHUguPf+eEGFblhy8VZXEP7f1?=
 =?us-ascii?Q?Gp0Efs2RKBYZ0BmbZH6eFokKYviCPxU/aI7QodFVsnA1HCRfe7c2Bsbeltzi?=
 =?us-ascii?Q?iHfeFjcQZvlCx91bDpbYjBbE7/pVaGa2VFlzMnDJVo9Xr9fSJsdUDSYect5W?=
 =?us-ascii?Q?9+8NYUK7YzE1SvaNIsE7B2l+cWwup4JDwAPlJS41UqKorgELfLp/bXSbCF2B?=
 =?us-ascii?Q?y1dTp3XVF22x9glTbY5/7n83bAK2WckjRwsLUKLIYLcmGW0CH6GmZ9ameUoh?=
 =?us-ascii?Q?dNRGiyUjKNfC4c+f0PCajH38IAyTfKRHVG48xvdNL1Rm0sDV/VWLXWftix9Y?=
 =?us-ascii?Q?AFoaXk5sjMlFepRaJlvOQ6U27Y5lVdEsx0gb4mvA/QD9WdGwOr/QC7oSEARI?=
 =?us-ascii?Q?ngutdSrMFWboYmr9rqDp0cBZDzV1AX5JY3BekLzU/edTFtKxEn8e58vgTiAJ?=
 =?us-ascii?Q?2B4ITBdRvtLIqkFrqOdYA3CLccjpLHLmDQMULjF3aKyQlcDy7Q98RlamEN9R?=
 =?us-ascii?Q?QcnfCdcZC7IqEnTZr1VYCATq+chwuKo3KukQTyD+RZvYGYXIdYY52D5kB7Iy?=
 =?us-ascii?Q?JDNFXI1DYg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	p0PizxttRPNjbbUJTCjlLCsyvaUKt6sRo0FhuF9K6CEWqRShXa/DEcZiFAhBO/Hyzu/ekJI5EO0EFvwRR5+DRH11IU8h0zPPlZ0XV8wiNMf8Qx/WSOBWSwG3lNmyWzkOTWJ/Df/iMugguOqquvLawP0ZMxzRDR5lB+BT7vEWzekhktjwl9MpM8mnlKVFwqIgTEcUxjP9neZ3pvxw+8tkiUabiMR4hGItK0YdzlMaVb2bmowiU/TS7WTYIgpesGis6AEtcHpphotWGGI85WGB9sJHTxPh7dI4vpt+hNyF3C2QCFvZ1OBUo5wHqLtHfGDS5wNJbtv3jfVTzgj1fi7ZIKjlv4FOOnemu35XtS/L5V1ZS8Ekysh1bq+cZgdtL0eiCa7vSOCQHn4VV6drcj7ov6vsidFGfUNajsxDD2YAfvY0UAv9EtAt0Se4ag/zl8achupcNTjGOXN9Po4lzL/gfdirkEtd0UPeC+1F6AgaT2TvOhYv7qPwIvkigVOluPx3X6x1lraGS2foHa1eBIYLivJzJFMnf9JILBNmj4wEFZPYL7+CsPbRS5pu7Ptr6+YbLqZ/BHHMIdZIGLski3I3LVNkslF1tkRzHTtTrT0W7w0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c151c893-c00a-49d9-b8d2-08de626b8a0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2026 14:58:35.5107
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1BzL2o4qzXV7xxcwCokWxps3jW0IBLdg3a2BO/EAtdz3HSzW2aI4NXsoARF9xoll3kVp0o0S5Ka58Tg+tf9HVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5060
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-02_04,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 malwarescore=0 mlxscore=0 adultscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2602020118
X-Proofpoint-GUID: SmakGzEyEeUxqCf93zaWUR2BKdkEZ5CF
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAyMDExOCBTYWx0ZWRfX4/S1SaZvJCEN
 YyVVtFBgQ//QSE8pcte2tkQf+ISc6+HxfNGUL4pvwo6y/MYVKkskvnIIPYlPylY2JWrIGU9VDV6
 MJ4QnqSgfJ/+Wy7YyMo3WR7gRU1rzPO9pdEWAfIwY4H/KJDFAvHMpA4NghEPBHXCah7xnrpYZvm
 VoA5sJ61MkAa3tafsuXNTNBToOhxKLEKw7X9MURlohyT0txo0PNCl6UmiAmDfRZ2jDwbURpl1Co
 DRCSmV4p79cGo7CI1P3VhI4Op6KrAgEmSFKppFtEtgxkJ2xktSfQXDKRZhi1OqAXNTGYSxF4oYi
 aZUmIDk9ctTlJ5HHBkHJ8xs7ZWuagFmZhJxbvicSPY4QJ457jcdMKay53yzSONodWs1vEpJaYJJ
 BwiaKdbd4+um4iLDcSV4py3jqWyNaWKXocEqMqusBEXzFvIRNSLjpYUWOshAuU0fMkkeZoCdCaC
 1JbM5ahXdgJiUCbbPe2f//+uUKrpVvq6uVgm8CzI=
X-Proofpoint-ORIG-GUID: SmakGzEyEeUxqCf93zaWUR2BKdkEZ5CF
X-Authority-Analysis: v=2.4 cv=IaqKmGqa c=1 sm=1 tr=0 ts=6980bba0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=HzLeVaNsDn8A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=FJefyi64AsqcEvUjZOgA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12104
X-Rspamd-Server: rspam11
X-Stat-Signature: ffxq9ytp5ar43en6ytw8a5ycbjap7syt
X-Rspam-User: 
X-Rspamd-Queue-Id: 60A411C0013
X-HE-Tag: 1770044337-439093
X-HE-Meta: U2FsdGVkX1+7w5jSnpC9bKLb6VdsYdWNcpoTAiEVmHbCYQXmXjmBkQvhLY15btSvDj9nCmsYFbwWxju7lhTmRmIvg1FylZHM7Q7IBbYbHmb0duGN9HYu4mNphuIhJiy8AnCUoJaV5SXBTU9aW6GBaTwynjFthCpwh0K0PRHhf4EA5Lm8Qr0DlPVcHj+aHs1pb5ayS7biwj9cZtdVD1dmBsrhfHcgDhAO+OUlp3cqGDl8mznWl+Qh2u9XDqGtbwbndStERNwli9b7i2v2zKp8Tzgn//O8NOtsBPW9nRU/5Y8oCrw//b42EE+XDrSiMkRQ0meCtEVk6sfbYX3VbbU0DuzhoJCQebn2UBg0kdOJDtc6auiEVKTf1w1YImgzASKtWfP6FO9YIcgVwMHLZKtmcUFVXXSmFqHHVNMvsXdqxKJcT0hV6InK9U0qYxrclJrH8w6m05sALDyZaYGkoLhxdubipa2KzMr/ENg9vO7dXbFtPWg45cmNt4Z28n9miYVl+RoqtHyHhLM9CzwzqD7u3rwtkD9Ux++g9WABk9hKPIqfpR4+jIgdvXyKyc7yMDrOzOlqCHdwikEa418p9dokAeV0wOHMxZyouyL+b9pLblU38PHHfC+NHJa2zIbDiwGGbAiAdEG4sd6RF4FuxGiJTgYVc62NkCL5NbBihQ+dWT/VYEUqmB10WABjC2EYOyJ8qlkx6IkdN0J6Jnt8Q+zIRkxE4EOXUxQWHRjm/v2kS9uqqZzspCQ8sqj8JE8yBmybI6CJdMrncNk8wiSOEyZBncsctyxv7ygcu6CPwZvISc3pqhE4OHoartCmcgytKh0dvWrmILsyVHh08uE6Gno+m68Rbw1h6LO2ylg5Y+SZsif6e/S8iT78t/YKEXzI0Hd6OmFNlAibC92RHOchT/to5tZMdVHgZmXZmyflR8bYBLQfU/URr+k5wrK56hVRDgomjW1bHkLTPLps1J1Bygr
 ForKZ2kR
 0sTy1DWeKU7nC/X6WMKL/AFPDAfokv/bOxwWEDXS/0qwfAXWGQqRSNNxFtEyJLfjlh7ry7p5CrW3px8pqRHkdVMI/zNEcISrvbbyI97FH59YjsF1lxblUAkM8FiI0Kf7ERgG4VMobMKT5/XgBfuYbnsGcO8aJset6eWGVgWSU82HUl9zuM8A7NoapvdxKyMY6IG3KgUT1RH0u8qRPWtQTQsuC6Fy6E8SS/csnHSnziN/XjakdYvpe/9IULNpA5QVEkSbS39oEKo9/bo7c/yLDdB2WSrJLfAaXQXbVqWhP+Vz9be5HYZJp5jcMdgqS2u2XGm3iiba0nE/hJLxlKVTFR5qr2K8czjtKtOESyyaZhvvFC3tlddC5w9Dyequ26kgRY6JvQtt2LPoCFIIR4Fb00fEP4dIN1T7ktIHu3xvoKFTP7nQPrV2fOcumJKqE89Kyl2sRcTKEA614f43EYL6Aaa3ndxzMBLeqlDb/O5Vmv/Gn/CmKL/AuV42CEWWF8O7rWDvHHTidck7ePrjMdiUROMkfE8HmiR6KDuFLAgv7mzChW7FmP4BQhrr/qLr4b96txec7p2tiFBBglBDOlil9ezYSg9ocs6bw0Unmuf62+FEesu26whBjcxbeTFOErydTeIu9fahwWRj4E1NOgUr1LgDQMgQHYhf4NdHwBhqRUTg44DLnx5dsM4kpxCoMa2biSvHvGXdj+yRXfBXOzcGteJE8EQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* SeongJae Park <sj@kernel.org> [260131 19:10]:
> Hello,
> 
> On Fri, 30 Jan 2026 15:59:26 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > Add a helper to do what is needed when the maple copy node contains a
> > new root node.  This is useful for future commits and is
> > self-documenting code.
> > 
> > Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> > ---
> >  lib/maple_tree.c | 70 ++++++++++++++++++++++++++----------------------
> >  1 file changed, 38 insertions(+), 32 deletions(-)
> > 
> > diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> > index 5280fa6d2d6ec..42038e42a4c7e 100644
> > --- a/lib/maple_tree.c
> > +++ b/lib/maple_tree.c
> > @@ -3337,6 +3337,43 @@ static void mas_spanning_rebalance(struct ma_state *mas,
> >  	mas_spanning_rebalance_loop(mas, mast, count);
> >  }
> >  
> > +static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
> > +{
> > +	if (cp->min || cp->max != ULONG_MAX)
> > +		return false;
> > +
> > +	if (cp->d_count != 1) {
> > +		enum maple_type mt = maple_arange_64;
> > +
> > +		if (!mt_is_alloc(mas->tree))
> > +			mt = maple_range_64;
> > +
> > +		cp->data = cp->d_count;
> > +		cp->s_count = 0;
> > +		dst_setup(cp, mas, mt);
> > +		init_cp_src(cp);
> > +		node_copy(mas, cp->src[0].node, 0, cp->data, cp->max, maple_copy,
> > +			  cp->dst[0].node, 0, mt);
> > +		node_finalise(cp->dst[0].node, mt, cp->end + 1);
> > +		/*
> > +		 * Warning, see cp_leaf_init() comment and rcu_assign_pointer()
> > +		 * documentation.  Since this is a new root, there are no
> > +		 * read-side operations that can view it until it is insert into
> > +		 * the tree after an rcu_assign_pointer() call.
> > +		 */
> > +		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> 
> I just found the above makes my build test using an old version compiler fails.
> Fortunately, seems it is same to the one we discussed before [1], and same
> mitigation like below attached patch works, at least for my test setup.

Thanks SJ.

This is still with gcc 8.1.0?

I thought debian stable would be old enough.

Thanks,
Liam

> 
> [1] https://lore.kernel.org/dwhxxuil4zkesmyj6xviyyyfedrcd65h6qd4bplmcrsg36purj@f523i7t6nxag
> 
> 
> Thanks,
> SJ
> 
> [...]
> === >8 ===
> From ecc4e468d72c431d53043c8a61fddb6ddf2ecf7c Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Sat, 31 Jan 2026 16:02:56 -0800
> Subject: [PATCH] lib/mape_tree: temporal build fix
> 
> Without the fix, build with old compilers fails like below:
> 
>   CC      lib/maple_tree.o
> In file included from .../arch/arm64/include/asm/rwonce.h:67,
>                  from .../include/linux/compiler.h:380,
>                  from .../include/linux/array_size.h:5,
>                  from .../include/linux/kernel.h:16,
>                  from .../include/linux/maple_tree.h:11,
>                  from .../lib/maple_tree.c:56:
> .../lib/maple_tree.c: In function 'cp_is_new_root':
> .../include/linux/rcupdate.h:555:36: error: dereferencing pointer to incomplete type 'struct maple_enode'
>   555 | #define RCU_INITIALIZER(v) (typeof(*(v)) __force __rcu *)(v)
>       |                                    ^~~~
> .../include/asm-generic/rwonce.h:55:33: note: in definition of macro '__WRITE_ONCE'
>    55 |  *(volatile typeof(x) *)&(x) = (val);    \
>       |                                 ^~~
> .../include/linux/rcupdate.h:1046:3: note: in expansion of macro 'WRITE_ONCE'
>  1046 |   WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>       |   ^~~~~~~~~~
> .../include/linux/rcupdate.h:1046:17: note: in expansion of macro 'RCU_INITIALIZER'
>  1046 |   WRITE_ONCE(p, RCU_INITIALIZER(v)); \
>       |                 ^~~~~~~~~~~~~~~
> .../lib/maple_tree.c:3364:3: note: in expansion of macro 'RCU_INIT_POINTER'
>  3364 |   RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
>       |   ^~~~~~~~~~~~~~~~
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  lib/maple_tree.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index c522419e99f4e..eb2855269332a 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3361,7 +3361,8 @@ static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
>  		 * read-side operations that can view it until it is insert into
>  		 * the tree after an rcu_assign_pointer() call.
>  		 */
> -		RCU_INIT_POINTER(cp->slot[0], mt_mk_node(cp->dst[0].node, mt));
> +		RCU_INIT_POINTER(cp->slot[0],
> +				(void *)mt_mk_node(cp->dst[0].node, mt));
>  		cp->height++;
>  	}
>  	WARN_ON_ONCE(cp->dst[0].node != mte_to_node(
> -- 
> 2.47.3
> 

