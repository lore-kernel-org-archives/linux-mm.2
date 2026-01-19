Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6367D29C33
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:07:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5497A6B025A; Mon, 19 Jan 2026 10:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3826B025C; Mon, 19 Jan 2026 10:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A1296B025D; Mon, 19 Jan 2026 10:07:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 256BB6B025A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:07:25 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C2FBB88168
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:07:24 +0000 (UTC)
X-FDA: 84349042008.07.CE4BCCF
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id 51C052000D
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:07:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ijA3o+nN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RuzjBav9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768835241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TROPiLxDudeFhOT6sKJEe5hS75+tPCzzjUAKCq7Qwjs=;
	b=Exl0badO6qha1O6nnne9o940ZZ2LjM7iDfptsLOid3/2aGbdDGl+8UPPfXd11EUmmOBYN3
	xFIQiDJiOeNqQzUj7VS1PLhaG8JhZiD8+Q5dlAt/Ro6/31INT7Yu+D7wXr7RXnBccFXV+5
	HnDmm36AkAucdpOxpuBLOKVqqMLkouA=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ijA3o+nN;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=RuzjBav9;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768835241; a=rsa-sha256;
	cv=pass;
	b=OoWcQA47PhA5lzh2ouPh2Nq3kyzRcv9qlJxy2JPtGPnCCMlxuGbUptX/5h2+Mzyk0X3AYJ
	ItX4H5x6uoAYUZWLGDGP0B9Wg+ZeeTGglQPrnR55mgKD0RECVIopN6um5ARq2aOxSezR2S
	0J5bdLUryp/yC1WZAWOiIwprNiLsIMg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60JBDhj31342126;
	Mon, 19 Jan 2026 15:07:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=TROPiLxDudeFhOT6sK
	JEe5hS75+tPCzzjUAKCq7Qwjs=; b=ijA3o+nNAMY9cf4JljNIZPR5PpS7ud5XOV
	s+WHUYXW4GS8YS7oNQIDHRl+V18vdGjrxR++S0U0F8vIzgEJJQYCNYLOAwyr43R3
	x3+thbhJ9Y9kFtynA3p6hH44g+HX78Zz+9QvxVx13EFiQimIrx8XusEvzC+gfvsV
	e2nspP8cKxvHqtIOZr0HM/DBWilqlqGIgqxI7ey9PdstCxtuINkNnDe/kaHCTzFs
	1kV8usAezj9gXSqARivpJGvEnl5DxkIWE8IMltgNVDqWFOTMqPE8CJcqEHXGiGjS
	qa2Cbc7vmxObHS9u6DLl2ecN8G7YRWTrF4ClizS6rAWLwwCf23fA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br170aeyh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 15:07:08 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60JDq7tp015492;
	Mon, 19 Jan 2026 15:07:07 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012025.outbound.protection.outlook.com [52.101.53.25])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0v8fyrp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Jan 2026 15:07:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LK91v8KvHOy8HOeB5MpvSgiu4kgRoGO9VYN7VihZlTxPPRI1YJVcFAWY+SRfjyE6yOkNWYZ8p+Ffy1r8ff9+VZJa7gYhXVIgYcwOq6I7r4cQoPbGjMwWD7Eu3SbNaoEJeis7B8K46+QThmd27inEMOVBG327P6CPaNy4mcCUADTiWeNdqx5ZMzXM2vxkl7GUabKh7sr/y5vgMH42RGTJj0+1Z/739ShamgAY4SmJOrYRtt0BjtFP5xECRsCdOJ8ejsAV5rRC0IYk/conzTxsxiAiXDxs3e2EGcV4GXEIt/8Eh9caFVE7zO42gQZ/SCN3hu8jz2qg9CY3Mc+78BKBSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TROPiLxDudeFhOT6sKJEe5hS75+tPCzzjUAKCq7Qwjs=;
 b=Bs+4N6EXMkw9CMUFLEMVb7Cag7hViqF9j5WByxJFy9GSlKge+7/B3QSVAP2axDvx2iDP6fQQ+/K0hHXhDVQLL61aU+z40OyuTuYjBDIyA9PclCI09mS+XwRr71gsKZZxVM/wL5cbVabPZ3BS83povKnRDnW5+5TEjRg3hS8dDLWxoS1bbUNgnxiSo3WVTlRBfkb5Ugms0ub+kMxRbYpDsCsHzZHw9owFx+23bBRzdMnM9apLzZ481rwwvufDZJbcnvoC1AZ5D2PETvS7xsdXjp6vcLzXjTsiGFsh7uNkIeGyuRna5v9iqo3WTpEoJgAAxVCZlUz3/kMoMPCto4uydQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TROPiLxDudeFhOT6sKJEe5hS75+tPCzzjUAKCq7Qwjs=;
 b=RuzjBav9weXP6x7FjVAahAgCuY3Y4GhE9t19cTncQD04t43CLwkC+c8CanwXjTh2t6EGVYNChAfyxUjDJ0NaWcZo0hDmQKsHBfxU80vgcVIeVK5Ky/RvEYEqEpt4qxFdpICmMRoCONIXJXL41ud9KAXxyzYPb+I/lLklfSRhqcg=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by MW4PR10MB6605.namprd10.prod.outlook.com (2603:10b6:303:229::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9520.12; Mon, 19 Jan
 2026 15:06:59 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9520.011; Mon, 19 Jan 2026
 15:06:59 +0000
Date: Mon, 19 Jan 2026 10:06:56 -0500
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev,
        Linux Memory Management List <linux-mm@kvack.org>,
        maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org,
        Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>
Subject: Re: [PATCH 16/28] maple_tree: Start using maple copy node for
 destination
Message-ID: <ljwcpjyp5fa2ixmauiep43wjbmb37fnie2vsvm7zrvb2kvg63l@zd54wiqjjorx>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>, maple-tree@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>, Matthew Wilcox <willy@infradead.org>, 
	Sidhartha Kumar <sidhartha.kumar@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Alice Ryhl <aliceryhl@google.com>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Kujau <lists@nerdbynature.de>
References: <20260115193647.1695937-17-Liam.Howlett@oracle.com>
 <202601161750.eDtUQiJr-lkp@intel.com>
 <xeipv5m2xxjfyhoqifdigymobmo5lnh6kqqloowbg4oiejqyp4@ns5iehb3kzof>
 <20260116144431.f597298658fbfe5931e15cab@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116144431.f597298658fbfe5931e15cab@linux-foundation.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4P288CA0051.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d2::9) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|MW4PR10MB6605:EE_
X-MS-Office365-Filtering-Correlation-Id: c1d96f35-0d62-4fe3-16aa-08de576c64eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?MnBlePyr/7x52dMqIgWqI1z8EfBBc6wEwCNGu5z2GF64LFID7BM+C8j/UTvg?=
 =?us-ascii?Q?jwF8R0ytnElKwGxeXOuiyBTSzOQQ9XE5V2oxjtYkJV0kqnKmOWhk7krhKZKW?=
 =?us-ascii?Q?j/fNJyUuyY2C/LruyRxlNLrjY7N3v6MR7SDoKVY+yPJH+N5lFoGCE4hUjve2?=
 =?us-ascii?Q?fUai4WuAjg3QjnyXlmpTbKHXotZficywLPPYZjUBv6OzmykcD9vUAXhuseGV?=
 =?us-ascii?Q?mw6AN1WV6Sg0cBf2Iw+wx/CVmPZ3+7HX7qg4iT/qXN8MNAdVper/hB3MVT2c?=
 =?us-ascii?Q?tDtG77ZUg9z48TCK4DxKfb7UVI4szRm1UTwIvt7xW65Zuxc4otR2N+EFodzW?=
 =?us-ascii?Q?lrqHcwQAIefowizEWOs5AZ8S/rIS4q6obYlhd3prn4gAyHxhFCwYz4Ppz6eG?=
 =?us-ascii?Q?CgVWiKGNPzsu938q06iC45hR5VvY2qAqT9kzKOuFxnqvfGiNly487MDkS6Ou?=
 =?us-ascii?Q?odA5hLdcFpQZAiUtM9xWEiSM7PAZcJUPcIUiYzbdWiSOyiCDmc0/DCDPLONN?=
 =?us-ascii?Q?G3yuHThPSX5G1jJG4DHOVBKZUPlGv33/NtcxqMC6D11tKnJu1QCCnMkDfKtY?=
 =?us-ascii?Q?/r0NLmE0v8A4tiXWb+e2/ltH80XmBqMTpFgKBm+prDpY8Gjoi9gwsKIvdtgw?=
 =?us-ascii?Q?uZVppqvtOSd6QmNngInEcUEy3QwWk0bQ/mm8g//zp2//U2huMs6uWN/CXZOP?=
 =?us-ascii?Q?8n73D8rlNHMMcs3HWKozhQe1P6LPhpweytG7RxCmZGrHdh2V99B+UZ2QEUOi?=
 =?us-ascii?Q?II9Jnido6FgNJ1AVMbF196lF0G8udVUw57IFGvrENVz5579jBf2PvbJ4zGw7?=
 =?us-ascii?Q?ufrO+V2oO0A8itOlBnquZRCPOwlsyUl30TjNvp6dlJYWGVhULG7I8pZimCO5?=
 =?us-ascii?Q?8mZVax+GixSkP2T0EZwT4wCD1w2Ki1l0/kppBZJnEV2N1sKM7NCG2DjYWhE6?=
 =?us-ascii?Q?bHDXgqSBnwEixLxwJxct0IDtKJSVKNOW+dYx1Bsr7yNUGRNZa6WNZzZTazVR?=
 =?us-ascii?Q?umSCoZBpiSf2WXXORFzg8M+0vnK7ND+zfWKxJzizevhutZWUzDxnsYRH/+V8?=
 =?us-ascii?Q?U1dEwhhOQ+Y/mkrRRyArDMWo6xXiO6QrIQYE7zHbt00i4GMJPzAFkeHsuOEJ?=
 =?us-ascii?Q?UUMtKCptzcf6StumKVOiapFQ9QTtp5nnwKWHguCCGjRNYNvRQrXcnuX2rDnJ?=
 =?us-ascii?Q?RjlGzBTMxZ4YlM+GSPGvDpt80SCrbnJSgPhaE2C2L9dAyRhb1YdiD+TJXzSb?=
 =?us-ascii?Q?8p3roeAcKvJeR8kIkoOEMXn8kHb9HqJaVNLLCsYP6UNwE4zhxqplxjqwBfJF?=
 =?us-ascii?Q?JsOynxlorxe7KS6S7rcnUDw5Krj9qcIIVi2n392ydcv+ijviUnlVAsfDwVYR?=
 =?us-ascii?Q?r/sd0fMLBO22T4Irq0A974evRwaAJglMNXJHSr1s3ijDrvqeNaqg+PNU7mpA?=
 =?us-ascii?Q?riIH1km+ztMh+iapN3zinuX4eblAWhxNRIQQESukTTRhRj5YKZIQYxnbDAew?=
 =?us-ascii?Q?Pxkk2pWeXuNQMChIPu8WodIzaSPtVqXlOTsuD8Y7fi1GHzRuP3Fo4GvPlzU6?=
 =?us-ascii?Q?WLC6TG/02FgwO+iFI1o=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?tJQBCKPK9suyddcEwKZsNt4gdGc3OZmbrBNez/s64NzDidFQD6sZ1/vXIQKR?=
 =?us-ascii?Q?M4tmotRlh43gVYaY6FsKHH4SNLtjzUuQjFM3XAklNy02yDMS0Fxr9Z205m4o?=
 =?us-ascii?Q?UMJE0xCQsr0fNr2BlMVQ5PTE6ugd/FmZRPAdSwGsO7ltjxxAA4Vg7c2ahNle?=
 =?us-ascii?Q?28MwMEYXcBl6fAf28on7aRa2aGovDi6KCuVO19qH25Zq5X37CMzKenGAaxJk?=
 =?us-ascii?Q?FcMWO/67fkcDZvRtakiIj/H/UncEh9mdgFtAG+D2+hlBMt0BEdLRub/Q7PI8?=
 =?us-ascii?Q?uIhKegipyRpdEfOG3VCYmn/VLXPdOCLdCmhlKdKEHqL3VSe7Obhql8OBIHIN?=
 =?us-ascii?Q?qWyK3OdQ+hsHgykOXMWsUiZ6Q2xykYFydK8aX7ZVKyVJrMZSLJRFiQAHi1I/?=
 =?us-ascii?Q?H49HeGyWulNeKMa+P3jHNDmtrlP0WJjRM/Mu/FfcRFN4WxzRaMfSC/MZCYh+?=
 =?us-ascii?Q?gOXM1N87famGAc3wbEtaERA8Dfe7QP6ZW2eWpNlSFo6zYJ5XQ8qT0P/M5OYa?=
 =?us-ascii?Q?+CLiLwuHBqogbXCVa8WPUlluTPRLZAK4vpeJWBWdYAlljTzMMJ+B/Btc+cX1?=
 =?us-ascii?Q?z/tvL3WRwfMfz4wgtG8MHtWIpZ1FXub0KeCHRlRyQlon+pIdAGrEhz2GJW5c?=
 =?us-ascii?Q?np/Y6FTITNjD0olznMurxSJDG22ArMhbZGMMsbI21Yx8s1pCqSEpjvt5p2Jx?=
 =?us-ascii?Q?+SnXkXFjc+F8ppLpf4Ldf9n2IkKVoGRn3VvmvMBKTF1u+6210vryohHvFyK1?=
 =?us-ascii?Q?Cw+d9vnxum8H0uoqi9LpXe3YDvPBNiDBMqBZE2ZRjcxxiT1xs2/yjNOFTAq4?=
 =?us-ascii?Q?/zm+e91YXx5WpSZikqRH6fz5XahSzc49xHS49lrQTUH0mSxkdfZl1l5mCXaX?=
 =?us-ascii?Q?Y1w5/65en1WW6jQMVNYjssNWoSG32yjmJK1BZJei7kJ/ILutpMzblbeujwh3?=
 =?us-ascii?Q?GRErXUCxcEprJ4It6TMAlfZ2ph7kF027E0CesNkUanFixJac0mA2xuEkg+VR?=
 =?us-ascii?Q?SerSa+5kxUiiT2j8QJdWy2PIVSDc0Xex9vzlUwUTw+Qh8bJzWPh5hYPFv95C?=
 =?us-ascii?Q?xIvUW1S1F7es6YjXggKn4H2ckLBusziM+M07uejxrbqcCDmPmPfs9xrZpAZF?=
 =?us-ascii?Q?82cendBNdMQEml/nNulx/SYC2xR63wQpaO4xcAed3+jmwxMhPxtFUBpozgYj?=
 =?us-ascii?Q?euLixKDo/vq9lrtyFx43v7JeLUmmh0rkLNZCDvm/Z7byJxZiKzabSNxw2IW9?=
 =?us-ascii?Q?vE0JKFn1lz7BfjNhNvXE+tJwqM5FrEPwMP1R0Fe/oI6BT4dxIZklJ0ePTDLC?=
 =?us-ascii?Q?8EX8D2U0dFFMXyZNd4De+iJOTRNywyaudcEbqGP34RBO2Utn0uV7YqvnNd7n?=
 =?us-ascii?Q?rVcD7CylO2El63jThiaH+bc8XJHCNYFjLOFWMWILVvLJUr4VMriT2OGv6J98?=
 =?us-ascii?Q?ONScRSxInWG+9PEvRvsy+T9ZxeQHldPny7GAiVf858D3iw3UfiV8eoMHtqO2?=
 =?us-ascii?Q?fH3wA35UT/XRWhVEbxa5D3yaT5Ei1iMOEBqi8/m9yOjS39Zi0jaz0aQ4OolD?=
 =?us-ascii?Q?DQREEOnX1mdLM++urCN/WmHavlmqwfkBriT+lBf0YjulxcuhWK4VCfdWBOpz?=
 =?us-ascii?Q?gxhZGvrzMYzsLNb6mhuMiJTrdVRZ1Muy8FcSAFKCBLqInEJt/sBS91m7cXCn?=
 =?us-ascii?Q?w5XqyP+4BAkLsrtMSiPUr4Or+C38x9kmSH/F7qMqHOQoalblvwym8a5CqxHF?=
 =?us-ascii?Q?dlrpluTJAg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	67jHJVenyJ7lLwDR8REPxB0SMqfovIrlll7+rFvjFDWeARnuemgTYdfDB74ii0XFuZK3cZ3+27rD1uMoItkydak+kWi/+jQPQnP7m1mpSRJyVNZk83GOtW8CewMqy/DSV8Wkdfg1spwTGmBYorag/XxM96xx5lQaLjxQQjd+FJWY5oPnKcnWecuxGXGwMxUubbXsWwNSUvQBu9AB44/IPHLfvOqkdQouGJKv1ehuelFjilyIHeIsfskbJ2gv3gz17bMUpZmL8Moye+N3CW2jw53aGPgSiMGTzOiBtaTeNdVqcw4N7iGjVbf5krZAsbsRXbzygtn/8cmeje6nCJyzymGTROWqrVmv8T7qGJlTZbEZpr9SIHXMYx5roJlpssa1NL2GLK7uhyEvwQNhewFpAQwRQDYvl2yt1G57fUCsX+ONNu2CBS11AqcrjJXXYoB/wOrMseOfnsMKbceIMX/rUIiKU/jp5zcb4y+Ecx2O7JGvSWg7tP2bOaC/u+VTufu7CVFE0Uk8Unme0cghi3EZrl1qaJRxaz48H/Yk3J10Ova9G5/eONOndDFejMwuJyH2kMqrLjx3Fk1U2tBkud9KQgEDwrcp9gvgAGKtqnJluOg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1d96f35-0d62-4fe3-16aa-08de576c64eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2026 15:06:59.6099
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TloQIT1wYCJfVjaJTcuzrrcLhS7MMv4ULeVJiYzD3571L6IN3jM/2mwm9AXj2DqqH0xs+u9pYH/7IlN4gNfuRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-19_03,2026-01-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601190126
X-Proofpoint-ORIG-GUID: 6QZelyK5xt6xmUdoEYza3U_y9iezXE9A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE5MDEyNiBTYWx0ZWRfX9VNcQJLu4/6s
 PGsGm+hEXmBH1wQmkCiowA9USdqXQaagmKzCmS6cqhouvofF4tRQ8lFWW98+7gTZ4d/jrSjmYsB
 2VIAyDK82ngJq5XgiTxz7uxZcgzh7+fcBtwINwBsn9u3lPd29cKyZPMWgAVuUJiAhryxqEZs0mz
 uuWuIvraB4BlCSY45PAOjdPiBZfY9iLV8vj3agSLGvBrCVQLJasOoQUvLvYIrulleKGnJkdxSME
 URO46/ggpzPCqxXhHCUccwxLMA615QoFW7Gy8XKEBI+/+neA6gZaOWamEAs5dLVCPyxSmGHcSpZ
 DuJXfJnjrafU2jQs6mvPv0vcZRpVBOjbLBQxqeG2tHXJlpAkMcBb8dMnJaxXBxI0fjQXgQGonqc
 0p66MoM7+swgrSxPy8bQY5XN4Mpb9ISUbKUFWg/FGe0i+VOctdGUcVphLazbD3JmW8yK7t4XthQ
 0hK3CKnJkdpymOVSBuw==
X-Proofpoint-GUID: 6QZelyK5xt6xmUdoEYza3U_y9iezXE9A
X-Authority-Analysis: v=2.4 cv=FvoIPmrq c=1 sm=1 tr=0 ts=696e489c cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8 a=2wZjMCt8fYvDNVT0PNwA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Rspam-User: 
X-Stat-Signature: 8dajoe7pbiwfcbzwst3hdher5fnq88st
X-Rspamd-Queue-Id: 51C052000D
X-Rspamd-Server: rspam04
X-HE-Tag: 1768835241-487524
X-HE-Meta: U2FsdGVkX19dS/fSGSisVXZiKgQYhkzG4TECQokpo7sUaBTiijOrmmkFsJKIXdIF9hjOjA6jTwdtuk4xhJiv+jcWyWBgRa0LRnGVAfF5Hc1N7fk1o04+r9B1F9MBCHCw2Fgst98soj2LAwsjxh/c1qavOg7Nt3PGUciHBVmM9q/KyweMCuoLlpSUURG0EOZdjXJWI1blLUqW3AT2/AUCsKPItqJhcBC/GVD7D42YQ1fkSz8pgWucvvz2VNhVGdzHyqksP4eDYvvek03zZr9t6nDV0gy1qs02HxJLVEjeJSD3mPazJWyHSuyxhq4lfAGMcXH8N3C+pDPRor3YPpFrfpOOwE3baK2WbWrVTC8qFI1FM7hzquevBzcP4s+Ed8uweE2x6lx1ZbjU0iSmrrECt3B5+6SEunjJwayQ/LCPRiidSNysuGCSYzojD23IaQpqnXybxpIyAoJvieQAR9CONICzi4C1HSvpObbrvhxz7ECM4q0prAhnnQ0HZ8jebNuP4kNMMOQjAouNpCKv35pnud9MjFwIzX+q4CqQ3LBR552PmZeeKNr8T1XelrxLnkVFgskD8acG0Efy/PgO0Wi5tCm585l+XMxwSp5R2UYoGCNL2TjaSsCxtshMMBVwnRFkGlqDljzCl7FLlYpXTaYpP+fZRapkjdrpm5mMZiMxkaYx2m55XRmE/nkz8vo+t8LPRe6/tonRUMrWEVTzmFKrbP0PVR158R+1KvpOaMa1QI9OeGRvK7ALihXK0kHlvMaHBN4zIoLm9AVA/fx4Sn0rsNVBMwSvcFkVuEipdfkQWhLhWj0Yfn0VmjVZNvR8DoMPczUTYV/BtZmGjcZrc4459juEmlEliTCuqbyME4tS6uk8p0B6popZlKlrXMhohfMGxvfvsNRoanejW5V39+CEE3sPNpe75MxjVnOcDthJu1jxBWNdiIx/Qa04x3URF8JrmIiOx38z3qOxQkzFwcc
 jhPpbBso
 7DwJjxjqCUHr51Mf/fSIVsfVEDbikvsZbQPifYFCM4q9C56q96fSkK5FC8zqKJIVcITA+WlOsQsISBsMxsoAZHNBCm3CAYvyzV5sSOEs20g4Yku/M4uOXVpEcqsBUjnZF/m/uUEHloH1JjRTBCbIJOxcWWsrV++1Mzd0PD3SCktudpTihgB6YIvsbTj1Rza7sEbFXCS/bBZOoLrO8C9z+0Vq8qE9yCRL1mEasoy9i3TJKKAId+AyfTH3KlxnsLWzd0p28k0J9+xqJ+zmCtx+G7Nt4TFqWC/3txuhF8x+ZWekfno9UTt1k5mS3g+XcX6uNBx0R3T+Igg3ePOVT1Vy7G9SHyuu+6jcKlf/Zrw+ZBAsgK0RrGJc8DRkq05/plIY4JLcE11CYwo8zfgSVGVEQ6mpGz4YzHfvZAQdkCFLV9N+XfCDGDoQt7pKoTor42m+2Q3KdRs2h6qiV1tbVb/PUogEarkZIc/2wNzWGzeIE1za+e5WWZQZMZ6UNHjWVkDJuZVesf/FD6Sc7WKvUiXYcvG0VQK5ldrZUOLi9lgi0eDZolj0rfh59lnkwFeZ/r0ZG/VSn/ribwqmNq9s55vhymzUXS0QYRnbAUHfC/TP5Nsmg1BxLQJy3CKuGQ/UZnDT3nhTT2T0tVe7V9TzfAg6Tn+FOANmD3A/Z6aJtCisKmqopXD+Z+JbuVocno3RS+yPU85nxDXLXEsyDmkp+lgQ4sxuYig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Andrew Morton <akpm@linux-foundation.org> [260116 17:44]:
> On Fri, 16 Jan 2026 15:19:30 -0500 "Liam R. Howlett" <Liam.Howlett@oracle.com> wrote:
> 
> > Fixing these in patch 16 means that future patches will need fixing.
> > 
> > I can either send you patches to fix up this and subsequent patches.  It
> > might be better for me to respin the series?
> > 
> > Let me know what you think I should do here.
> > 
> > I'll also include a final patch to correct any other sparse warnings.
> 
> Regardless of the From:, a tremendously huge v1 patchset against critical
> infrastructure at -rc5 got instaparked in my wait-and-see bucket, sorry ;)

Thanks, I somewhat expected this and am fine with it.  I didn't want to
land this in an LTS for the same sort of reason.

> 
> A full resend would suit, thanks.
> 

Sounds good!

Thanks,
Liam

