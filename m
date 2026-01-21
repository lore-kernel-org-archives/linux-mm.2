Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E71E0C44536
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54826B00F2; Wed, 21 Jan 2026 11:58:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E327A6B00F3; Wed, 21 Jan 2026 11:58:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCAA36B00F4; Wed, 21 Jan 2026 11:58:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D11E6B00F2
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:58:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 609655B1B9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:07 +0000 (UTC)
X-FDA: 84356578614.07.FC5F5EB
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf19.hostedemail.com (Postfix) with ESMTP id AAC851A0008
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:58:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kFknlZ42;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aBfQCner;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769014683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxAyGp5LPyMExoTHfMqj7smpv1S41dvj3PIcDVT1f6o=;
	b=7OVkRLxzwZ2CRkXrfDMmfn35JXuaKkCM0qXrFS5UHxmLqkYyRHUdSUvM3EfYLQ+rjxxQxH
	Op8mMx+btLFwTD3efFcZBA/R5HFerkY+DEbSMdTKE6DriZ+z45e7UVpDHycZlg0b7EEYbO
	dIXfgK2ZiKH1noDhGR84ju2AeVafb+E=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=kFknlZ42;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=aBfQCner;
	spf=pass (imf19.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769014683; a=rsa-sha256;
	cv=pass;
	b=fKPSFMtUJI78KwYUvhKGXz6bYeMR7YfLCvbgKg9kF/43kZqO82l/R4NgFOBbAzjWzVyax8
	iTEgf3ZnqiZcOOsiAYcDTqSaJSq4hY4UT7zTYmAm2xjgsi/Iatc5fGV33W65Cf6aTbXspP
	d048IbYw4IJ2i7py/ZmF9TAFAIOJPMk=
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LG0KMS3429768;
	Wed, 21 Jan 2026 16:57:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WxAyGp5LPyMExoTHfMqj7smpv1S41dvj3PIcDVT1f6o=; b=
	kFknlZ42YZsb1JhxZYF6JzrfZ9H9OXdXBt4A0VL8qZmk2soMw0hAkluWyYG//36y
	AtXpAfk+8Tk1DtPZth3X7ybwqJhNwzbRKr5TuCidGoMUGx4HZy9WvHga4jJ1ewHn
	FpUgf0Uq7EmpNEPecQyVauFaJCJyFk9UwWID2Cm9PWTXt0B2CkVUAltGRxcAhMRW
	kfclHyqBzeVGYIv0WV3zR8XlgxFJBU5cQOoXiHysAlF+RGyWcp2hQoek65ZQlUqr
	aFuPwh8erBVB4moXuUCKRnVrRz+sFzWV1o+sVXHVjsdHmRCDq3KRK7gsEw0WCHu2
	j0xaJwQIuSmC+nd9zdrdJw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br2a5p639-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:47 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGOhW7015498;
	Wed, 21 Jan 2026 16:57:46 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012064.outbound.protection.outlook.com [40.107.209.64])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbhhp1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=l3ZcMWiJXkCQ6tuYvcPPGY6GhOGejIfh+na9EJJXUmMxXOuNnZnGDbXq9Xt95gMLFLz1lL8HnINBISfbTNZVXT0lYa9T6UQKl1tBGYPqnXcd831VlY4Q1nGjfsLojybcdK6+1RLm9uZNEQGChML5+qG1OgX5aLyX2LQimqWFE+zCPgtx57rXNVBo1s6DdacDD6iNZWoLDMXUA/zr4CbBHbMfDt6fVnJXgrfwSwudw4pWOyZEN1WyL1tKjpz0c4+iTLwvkKAAjz2Z45h/BOgAT/swrFrhLz/e7ZOTJC7Eh9cisPC183Ad5mqsHpIftul3ITKD5C8tGX6pDDch2dt5SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WxAyGp5LPyMExoTHfMqj7smpv1S41dvj3PIcDVT1f6o=;
 b=inWYO5ZKxenyCnUGPI57flckBjG8RsYC5zloUjtmuAed6yT0tZKfNVUAY4y75oaS/iUk+RSCajJhL2jOzB/QJSds+dS2k7gy8BF9Uu91CkCQQQgyfj2CnVpGrX4ricQwBNllEIjAoze1w8YcTgD2dseAbAlxHZ26XiMynUIzknei8hUpm9D9nstCHsRDAQ7xxDaMPWctCwIxEMkiYF2jMWwnZbc9URubI07TSWPVyhkcNIETDMz3jczTG6laDrbZrOmtBfyroNU0iKpT1MaPsIYHxKLZe8MZ/E0DIRo3OJvjR5j/+++9BNbXUJ+EkjG38pgQMCSjCCZJX7NlRrhPTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WxAyGp5LPyMExoTHfMqj7smpv1S41dvj3PIcDVT1f6o=;
 b=aBfQCnerTIfj1ufXu1n0fbr/dxZb6F5qtmPGOFBYhuM3wncq3icaI1bR7j398rfdWRam3j+0H6UI0ApJjYfD42fPUJIyMPleiDcU8hgeiJO3qop59qOxUDq5O8a+3mcLAbU0MczLzU0TRyLXXmdwyuMhC/LlgcwSDwagWgfI+4I=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by DM4PR10MB6696.namprd10.prod.outlook.com (2603:10b6:8:110::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:42 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:42 +0000
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
Subject: [PATCH v2 26/29] maple_tree: Remove maple big node and subtree structs
Date: Wed, 21 Jan 2026 11:45:23 -0500
Message-ID: <20260121164526.2093265-27-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4P288CA0006.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:b01:d4::12) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|DM4PR10MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d7d38ab-b4d5-401d-26e8-08de590e3148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?u+Nyi69VtFHt0mlJiTMEm2Z31GmdrUheW1re89vbEMJUcFrx4q8jsSk66AZp?=
 =?us-ascii?Q?GbSPpB5u0y9/prayHTrYmYKx8bQoffUw2MiRoXL7DXF+2m6AwFHksGvg2utI?=
 =?us-ascii?Q?vMNtY/BQJBdTp8HOcBwSGlNLBA+YGONsqni+6Ea/UOH3AOAsMTR2ZQcy1xzx?=
 =?us-ascii?Q?k57PgUTkQT64vJ0rnZdR4IYVYutZb/Fw6Ey+iZGaHyOLAIvzUDB2iqGVvk3A?=
 =?us-ascii?Q?+ag/Ff6OfXBVGD6beJGyYpDiABmC9zUbzIwb3QZ6+B/Kg6pO0MHz5ZjOMTVw?=
 =?us-ascii?Q?NJavQ+BXHNotkXS7ydFaY1SPBdfP2J9/ZTof/AnPpHOjHDDaWhmP/8D4oPA0?=
 =?us-ascii?Q?7AO4m1Aqnd9e87LgKlcUc/IxpViT2zN0x8qpDhM3eFT9KosCjp35aV5kyREN?=
 =?us-ascii?Q?/Mle08hwWq+dsWZNcpg032udnauVs7F+rCZx76FN2pFtQO24iT6gcpzAbnlU?=
 =?us-ascii?Q?MROXODQ8387MGY2SRC6uuZf3PzEjpswZpvw1u7jSoe/8bbRfnn8X6ZCeKFwV?=
 =?us-ascii?Q?55aC6SdC2U03MPOe17gP3v03YcPMeW0dqKVnbgeCf2X9FoUVnblhL/49ZoI4?=
 =?us-ascii?Q?dp53SS6s8jokSSZuYnic8Bkx9olsJqM4S9z8PLUoPTzE9gfHx3m0FMwsvbNd?=
 =?us-ascii?Q?r2FG8W5ivv0lm3QkC73r5gwJ9N0uyzvgz60MOC+zYHP6SRsXeHOoH976VIkl?=
 =?us-ascii?Q?6HuVyswtg8lJUr0Lr08wW+xY8N1lGXV3WrRZ8K7SHp+XtbtzC8OlLkT5DDo0?=
 =?us-ascii?Q?CeISFhrrvHtLdXavvBXqdcue5oxuwTv8LACBj5ELRBI3P9AkTFOkm3QjH7SS?=
 =?us-ascii?Q?Gkg+W4sJF1RQZoB+mK9KRKhD0EBSiAjaTinhrONd3PY8pSfIzDS3LfcIjxCL?=
 =?us-ascii?Q?8pT2niC2Dky3+zPxD0FTCw1L7gF/l1lWDHoovuzl9yuF4wQEYW4NdipCFcca?=
 =?us-ascii?Q?NFfE7F3k8i4SrlD//QeRnSajmXC/bYFOG7agGuMUmi1PARhe9IPCwwD4UcKI?=
 =?us-ascii?Q?Fx99B/9DocH3XMiK1D2SHnTrIYYO1dt4UcDD3fSHsu5UwFym9ReYCOhawds8?=
 =?us-ascii?Q?CalVHYY9UtpsCAw+xkxBmP7mA8Hn/7qFaMPNTdrC4G+viVXR2yItXzR3ilVx?=
 =?us-ascii?Q?LnBtoNrFbUNMbonIb/y4Ni+usaRwUInWrFaS2fWBJ0vtfcxuF6Fq0oJUDY/L?=
 =?us-ascii?Q?aYV1/LCQ18v9KxQnuTzdjhSXhwHpbpqIk+9sXiP5K7Ar3IXUWIuxkUXb+J8P?=
 =?us-ascii?Q?7/xArZe5TJbdMSEZrhXK18GJByEOJCjMbSxH6NO/T1FjbFEpVKeURjEATy8X?=
 =?us-ascii?Q?bCU2bhfao+aPAXjkNZ63pwRlamMGQDTIO7z9a2E2NkTwgT9uJG1CO4+V5hnD?=
 =?us-ascii?Q?9gmWn/hqEsvMUArWtQ2Adpc+271BD4K3HnEIV7icZDwesv9CkLjOogk/DsYJ?=
 =?us-ascii?Q?tTSlQPg+ayA3HyjWWQvOYXbkk3adu7bg6YgBjRsKBeLML3XGBH70YQz/xDCo?=
 =?us-ascii?Q?VwAl4MuaYrbn7x1R9uCT8sTQZmZ0BBf/vVY3n9vvLcPcJDXgrczCJ1P4vXsR?=
 =?us-ascii?Q?W206JBFdLEy0hHBhNTg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?r/JNow6XZasMwAn6gU0ojWX4xGXK5nVISIRfTqmIuEFlowhpBKTGI3eo7lsh?=
 =?us-ascii?Q?f9FT3FRF/VDEK1QRmIHzc+jSU6CHEHOgK5nfjuCcBN+xWXAiLSQQhSeyy5rw?=
 =?us-ascii?Q?sMIS7DMPeyUbqbxwRvUyKup8y4L+uZ2fOMsBoUv1QTG227MGiZFyQAE6PAVy?=
 =?us-ascii?Q?HIPJeKE7efo5Pfi82KpQ3z8/O3k9lQ6G6CWyYetIMvnNuKSEaG7Q71gpNn/t?=
 =?us-ascii?Q?FvAX4FOMkO79fmw+PMkvySPjbE1JotaP+4LHuooZUxF6Wzjom2ixNYMbhO9d?=
 =?us-ascii?Q?7bErqdxtuSmfrH3MfhyzjNJbvoGoXfdf4+WAVoBrr23GEKmuleRooGLJolk0?=
 =?us-ascii?Q?Q4B7GkUvtTrHwHEd1jk7dLP4/xQ/Zd2GVafPGUpOsUBSd9kIEDoQFvRNhKkh?=
 =?us-ascii?Q?ejKq5OJJNM1THiiGE1FSWoOk9UfDob9bxmfs6X2qmEThCnjFAjoyGQq3NRsn?=
 =?us-ascii?Q?me8QMMja4xEqBV2pC/EF+UC9HHbvYqUU4cuUW4OJuhHxQF1Y6V0VA0Bh6eNE?=
 =?us-ascii?Q?sOX/bMPyKBnSAzOas7Dh9xLWKyvUkJ03sr2ZwOEF9QR9JYSAvwl2+Ml0wd2v?=
 =?us-ascii?Q?buQ/ieiMLLZLs9vMv8Xy2Ok4s3dHPIJ1V9P9RdL+unhC0olCbvZKKEY47oqc?=
 =?us-ascii?Q?cDCgI2S1U+gu6mDWyOXFS5KorenAUCntpywLEu7pgdPi9i8OAQy/eUhxaCr1?=
 =?us-ascii?Q?Uit50Uz+xtrLOjQw/H1wqJW6jaGBVOXyGpVNNzVZs6l7V4LIj3w36LW9UMOd?=
 =?us-ascii?Q?cMHIdXbmXQsh8qich4O/Rw3YhVLTcxwaWwEZccrH+jf9rvNIosuQoM0y5eGj?=
 =?us-ascii?Q?UhkZ0X0hWyigLPtWAh6kRV8prkCCqASTrCvsjryhWYwy+qVXyB7O5+vvvmIF?=
 =?us-ascii?Q?KrWbGwyfBy8nWYsOGRnAKZmIakVVXEI6XePM4B2aa0B2Mtwck5ALvfBcIIxc?=
 =?us-ascii?Q?pIYpJRJJiG/80iUmjKllXvkn12S4jb1XsruD7Q1MFXDnmqTJGG1xePqckVER?=
 =?us-ascii?Q?quLzwXnz5E8nJ3PLFiTdqFUIyzhXSgoF4hWVCXCpudpD7gPAQw2qdsKgACmn?=
 =?us-ascii?Q?MWTdhcEu+Sy9WuSy74PE6fAAPIOlSA6pN6oVmYE1pUoW2zaLTuvSHPyyP+iL?=
 =?us-ascii?Q?EeZyaZYY7QR7Mc3qcLM2W/cOjvI+zrELhjq2GRP91XiwbvAYfOT4x4B70I8l?=
 =?us-ascii?Q?nCR4ZIPwr5oyTAc/2eHDKoQyMxSWRkFfYJb8nLXxY/0bqm5zMVr6c7vtzvtj?=
 =?us-ascii?Q?+XmHfmd7so8bmSU+MTm7o5ejXMwseVp/i4C9IdPvhSq776ccshWL5Vt4Ljmv?=
 =?us-ascii?Q?3NEm7Dp8XNAfZr2Pbi+CSeV9nVrKIvqJBqeVx0m05r3ZWnLdJYKLS3j07+Pg?=
 =?us-ascii?Q?ycVUHBknF3xjBBHhbC8h8zaUwof+6wz/4uDkKksA3Uke4idxwvDIex0HMKrS?=
 =?us-ascii?Q?zTTUjnWWI5rVBtin6r6fXXwjBuB4ENBo0WMGIyHIx/udwirUWqaGQO9I/RlO?=
 =?us-ascii?Q?VKk6LD//X51Kn/j2yCC+3+4GVNhF8MMjsEQNIDFM1CBEDQBXHLWhtUgaXoh/?=
 =?us-ascii?Q?9sOjg1Q5NVW+WZXP/+VES2X+W1dnPkzhMw3T3rBCJB+h1FZzjcmVH/tGr6Wd?=
 =?us-ascii?Q?D5NEbtqbd0dgYS4BmUFN/vxUnVZ341Kc5KdT1heivl16b1UcrmChVsH2akzi?=
 =?us-ascii?Q?+7bJSp6PEbE7du47dLN36/98feo9reXVGc5wsbV5aQKUAYgVHUDTFczdr7mh?=
 =?us-ascii?Q?ejhB4ddqEA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MzMoiLhrJslGxN20hlgQCw/xtlrB6X4Fkhu1rqGvmxfQzJiIbrsUdzPlFpF8FiY/7gLfaO/I6AK2wf+WRbmiPol5vGzZsKd6veh+R/KQr/0AFEf5AP8hFm4rTE7XV0RlkpmUbHyi2Qd0RmU/keXmZq34TpSYGAbJiOOUcm/lcQNFsSG2ncY0PXaYY4AsrSNMQrbGXdCFQEiK6SH61uFBrJ4W87ViRTQ5KoG9R2STmXfaYsmYCVaMOWEWDgSS/WCtKdDIxCbUUCHLw08nIpsVyFa3KmXPCx2k72SI6U6RvI+CKnqMXCivVt+fZ99UtQrqBipmEMnM3SDaqw/G7kZxDfdDSsrrBe/EU97SiFxuWvfT/f0aDxd1WID5PXcVnILAno0B31Z9ikiuGxIgqHjnAIJn5h4GUAnUgFgt40muCsM+IqPqDlHlriPvK+4Vwk1vo/PdQd56vohdKBfe3qoeFIDqogQaKfAtevJwB4zYLlefrU400XCDDZS/+ljyQB9tGLDX3HYtZmCufC+OlU5eBy1em1PCzg1Fz5GSohmXOh9OA238YwgMuin/A7ONRSCtPUS2llkIO3M1G2EXSp+lxVTjWDDU6a97YyZW3Eh3jWk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d7d38ab-b4d5-401d-26e8-08de590e3148
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:42.7300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2FxUEWLjODussbJY77peA7gjCWGVwrN89rztR/wEQz3+9v1NJ3Hg5Yb9SVH/B+jQRUTIReJqmdGNbUwbVTzifg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6696
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXzoBQ3SVdIN+m
 RudcCEK7znkAJTOkSUKDHs9zVoFsSVUY5Ucr5DhIr6LNcCURJRcAU+THSEczBttqtAvRgS2EcuI
 7MEohwCpeChc5hV1tPJs/IV5Op54/cP5ZaBGttf17hmGsD3bMFUCedd4l9O1zLLLRkUWizyPyVx
 SJaEfLcvDzp9amMh4uefP+CD8+QUu/7UM1K3xgNuDwqRm9L8nArLZPCv7q8qweNwq9a186BXYKV
 D0wt90wY3+gAYkjAu9ZLBbrurr6klmnKoQTuYEgs+N33MgsXN0IKkChJFy573EspWfTOQ5/eKP9
 91dmiXnXqsEZNp0AS5kttDpuhWdJtv8kubs0S3BW1TR5wv/PwvrCq8i6rYcNOXgK9SGcIx13wma
 k2XzrzBlpTwgWhfNTL1n44DcK/X3Q2yq1zPTht1Sp3CZyDU6dc0YvIKxITnH7EG1dYGfd6mMxcQ
 +DzioRbIbyT+aPYalHA==
X-Proofpoint-GUID: UR51vKcil9Iq7mBbU6A9qYK5qaCo5rQ9
X-Authority-Analysis: v=2.4 cv=XK49iAhE c=1 sm=1 tr=0 ts=6971058b cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=AJrCfj9k8GgL1_glB6IA:9
X-Proofpoint-ORIG-GUID: UR51vKcil9Iq7mBbU6A9qYK5qaCo5rQ9
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AAC851A0008
X-Stat-Signature: x9fti8x79tqrabzfowubxmd6q3k7z1d3
X-Rspam-User: 
X-HE-Tag: 1769014683-23208
X-HE-Meta: U2FsdGVkX1/MK8nLT1oEU1dRQ934TtzrhAM68wm0dHnlxcykcc8qO77cdeEvKFvPtklltwxFFf5GADwBut4j47qLBF1+KX9lWOv9Y0++MZQKTW58jecpUdKu86ftUGmLJXGEeNEfsq+qj62fWGo6LyDK4+5Rx2y0XpRpCrTkMI2HfRA1Oi3se7H38x0jHowPR0UrPhQ2bDa+8mX04ukVE9Jh1ScuQoBSFpaVggUoy0i6P5f77Wjsw3vtjEvkcerSubl2cg53sCWiNtJ92TJ8T9ho28Ueh/yWof5CztQaf9UUXPNCbSjUnkMhPjvoCJF2L7EE17FyTc/zZLwY/+CttxV7DpSHrXRrnPKrPGUEI/AlcsDtxVks4oq8dF/+5/Pp3AKoCcqsIUxLwlzesApnJq8Tv/wxrC4QwWCWlQyQKCkHTymBAzSEMLN6yh7+yuEfgwRoF364J3QJmxIruxsp+cxbO8Cpqqf026abr9rkTWCUp0EuG8l3fCBAP/ABAKt+27uFRnq7cz5i3/qfvOMbi8k2ucz674xTHF0QcLzPFPTqPxacaD2xs1SxERXoRXv1c9PUMJfT6uQta1e7ZgumVbNaMnCsXf7saPlUq0dngF/12CZnGkhp61kuP3nfHWwPsU/yir2GpCT6krDNRxKW517NRqJDUTzxT9ww0FHg3tPsREnt41NV8x+/Vzl0jH9hPkDWM9oOHzoD7PjSCVMRpy3TtaX4k0fRat0IVjau8S0I7qDp2CG5HBSGgTcvK30aT7FSMBGbk8Gw1x7WT4ZuC6Du8FqaxLr5h/d2EPscy8nc62jFR2GvIkJV3INJVKWThMacblratj2T+qt68GcqgC/yB27MEyot3haH0CXQSZedkkPCuHcx8ZT7APKOS1wws82KokIl3A74o6UEScpGCsZtZRnLJLt1iI66me8se5AIvLHG1lGAWsc9/LkI2APwXp23kgiN/kw45rQxxcK
 Yi6WNDVC
 5ZrK121o5z1SsTml3+l5v4K6dFyRwtjrfv1TOVdkQNxawVcWkL9egXi6j8wtQDy06BhrVm1zScEuTNPnlGNLdtwYkDMX7uFdOJA+/8rUCvQ+eFCTPnF90Zi59oDf8D7esLqQ17UDQsfm6usU91rnvP9Q2obWfpW97DKzrBYlmVPfov+YzqsgIN2LYJV+E40v0EwTfjkPN2/+3yfsifwxiF9eK9WUxuW3hojLGXIQWiyomhcKv5cZvQLqapgNZ5zesK/Q9xUhMcm2oBZTzXYNQkm4+RNMOLacwdx8mA01KZ2GpE+Z8PyRs91lv1rnDTy3fhsQ7r1czjqRcO7vQMt7yV3Y/6BeSy6drzih8rz7fTlnQsv85hckwz6K6WQ28UQCI0yWzqtiXc48m/CQjNhFiQMCWZheuKhXoTnQeEDvuXobKOdgPFB6W149pS+zg4vckMz7ahjPLRwqEC6E2o5eK9T/xUMbR8iDuog7WCkFGdtyVaSgCEDazpjysEtucBUemKP4HfudpnEx1eV+pHB0uDK3oua0nGe9mpdcdL+YAKi7L5HCpCD3gfvgLjsUVEWgAv+tbY9wznqN8pKmhP+xvRG8GzEWFn6KsT9K0MpveNS5C4y0NXotRADbpE6wl1fXjEn0VeJ28Jq1jsS52HtOSnP/tYw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that no one uses the structures and functions, drop the dead code.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 1184 ----------------------------------------------
 1 file changed, 1184 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 8c97f2963b9c6..744df5a596550 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -133,45 +133,6 @@ static const unsigned char mt_min_slots[] = {
 };
 #define mt_min_slot_count(x) mt_min_slots[mte_node_type(x)]
 
-#define MAPLE_BIG_NODE_SLOTS	(MAPLE_RANGE64_SLOTS * 2 + 2)
-#define MAPLE_BIG_NODE_GAPS	(MAPLE_ARANGE64_SLOTS * 2 + 1)
-
-struct maple_big_node {
-	unsigned long pivot[MAPLE_BIG_NODE_SLOTS - 1];
-	union {
-		struct maple_enode *slot[MAPLE_BIG_NODE_SLOTS];
-		struct {
-			unsigned long padding[MAPLE_BIG_NODE_GAPS];
-			unsigned long gap[MAPLE_BIG_NODE_GAPS];
-		};
-	};
-	unsigned char b_end;
-	enum maple_type type;
-};
-
-/*
- * The maple_subtree_state is used to build a tree to replace a segment of an
- * existing tree in a more atomic way.  Any walkers of the older tree will hit a
- * dead node and restart on updates.
- */
-struct maple_subtree_state {
-	struct ma_state *orig_l;	/* Original left side of subtree */
-	struct ma_state *orig_r;	/* Original right side of subtree */
-	struct ma_state *l;		/* New left side of subtree */
-	struct ma_state *m;		/* New middle of subtree (rare) */
-	struct ma_state *r;		/* New right side of subtree */
-	struct ma_topiary *free;	/* nodes to be freed */
-	struct ma_topiary *destroy;	/* Nodes to be destroyed (walked and freed) */
-	struct maple_big_node *bn;
-};
-
-#ifdef CONFIG_KASAN_STACK
-/* Prevent mas_wr_bnode() from exceeding the stack frame limit */
-#define noinline_for_kasan noinline_for_stack
-#else
-#define noinline_for_kasan inline
-#endif
-
 /* Functions */
 static inline struct maple_node *mt_alloc_one(gfp_t gfp)
 {
@@ -1662,169 +1623,6 @@ static inline bool mas_find_child(struct ma_state *mas, struct ma_state *child)
 	return false;
 }
 
-/*
- * mab_shift_right() - Shift the data in mab right. Note, does not clean out the
- * old data or set b_node->b_end.
- * @b_node: the maple_big_node
- * @shift: the shift count
- */
-static inline void mab_shift_right(struct maple_big_node *b_node,
-				 unsigned char shift)
-{
-	unsigned long size = b_node->b_end * sizeof(unsigned long);
-
-	memmove(b_node->pivot + shift, b_node->pivot, size);
-	memmove(b_node->slot + shift, b_node->slot, size);
-	if (b_node->type == maple_arange_64)
-		memmove(b_node->gap + shift, b_node->gap, size);
-}
-
-/*
- * mab_middle_node() - Check if a middle node is needed (unlikely)
- * @b_node: the maple_big_node that contains the data.
- * @split: the potential split location
- * @slot_count: the size that can be stored in a single node being considered.
- *
- * Return: true if a middle node is required.
- */
-static inline bool mab_middle_node(struct maple_big_node *b_node, int split,
-				   unsigned char slot_count)
-{
-	unsigned char size = b_node->b_end;
-
-	if (size >= 2 * slot_count)
-		return true;
-
-	if (!b_node->slot[split] && (size >= 2 * slot_count - 1))
-		return true;
-
-	return false;
-}
-
-/*
- * mab_no_null_split() - ensure the split doesn't fall on a NULL
- * @b_node: the maple_big_node with the data
- * @split: the suggested split location
- * @slot_count: the number of slots in the node being considered.
- *
- * Return: the split location.
- */
-static inline int mab_no_null_split(struct maple_big_node *b_node,
-				    unsigned char split, unsigned char slot_count)
-{
-	if (!b_node->slot[split]) {
-		/*
-		 * If the split is less than the max slot && the right side will
-		 * still be sufficient, then increment the split on NULL.
-		 */
-		if ((split < slot_count - 1) &&
-		    (b_node->b_end - split) > (mt_min_slots[b_node->type]))
-			split++;
-		else
-			split--;
-	}
-	return split;
-}
-
-/*
- * mab_calc_split() - Calculate the split location and if there needs to be two
- * splits.
- * @mas: The maple state
- * @bn: The maple_big_node with the data
- * @mid_split: The second split, if required.  0 otherwise.
- *
- * Return: The first split location.  The middle split is set in @mid_split.
- */
-static inline int mab_calc_split(struct ma_state *mas,
-	 struct maple_big_node *bn, unsigned char *mid_split)
-{
-	unsigned char b_end = bn->b_end;
-	int split = b_end / 2; /* Assume equal split. */
-	unsigned char slot_count = mt_slots[bn->type];
-
-	/*
-	 * To support gap tracking, all NULL entries are kept together and a node cannot
-	 * end on a NULL entry, with the exception of the left-most leaf.  The
-	 * limitation means that the split of a node must be checked for this condition
-	 * and be able to put more data in one direction or the other.
-	 *
-	 * Although extremely rare, it is possible to enter what is known as the 3-way
-	 * split scenario.  The 3-way split comes about by means of a store of a range
-	 * that overwrites the end and beginning of two full nodes.  The result is a set
-	 * of entries that cannot be stored in 2 nodes.  Sometimes, these two nodes can
-	 * also be located in different parent nodes which are also full.  This can
-	 * carry upwards all the way to the root in the worst case.
-	 */
-	if (unlikely(mab_middle_node(bn, split, slot_count))) {
-		split = b_end / 3;
-		*mid_split = split * 2;
-	} else {
-		*mid_split = 0;
-	}
-
-	/* Avoid ending a node on a NULL entry */
-	split = mab_no_null_split(bn, split, slot_count);
-
-	if (unlikely(*mid_split))
-		*mid_split = mab_no_null_split(bn, *mid_split, slot_count);
-
-	return split;
-}
-
-/*
- * mas_mab_cp() - Copy data from a maple state inclusively to a maple_big_node
- * and set @b_node->b_end to the next free slot.
- * @mas: The maple state
- * @mas_start: The starting slot to copy
- * @mas_end: The end slot to copy (inclusively)
- * @b_node: The maple_big_node to place the data
- * @mab_start: The starting location in maple_big_node to store the data.
- */
-static inline void mas_mab_cp(struct ma_state *mas, unsigned char mas_start,
-			unsigned char mas_end, struct maple_big_node *b_node,
-			unsigned char mab_start)
-{
-	enum maple_type mt;
-	struct maple_node *node;
-	void __rcu **slots;
-	unsigned long *pivots, *gaps;
-	int i = mas_start, j = mab_start;
-	unsigned char piv_end;
-
-	node = mas_mn(mas);
-	mt = mte_node_type(mas->node);
-	pivots = ma_pivots(node, mt);
-	if (!i) {
-		b_node->pivot[j] = pivots[i++];
-		if (unlikely(i > mas_end))
-			goto complete;
-		j++;
-	}
-
-	piv_end = min(mas_end, mt_pivots[mt]);
-	for (; i < piv_end; i++, j++) {
-		b_node->pivot[j] = pivots[i];
-		if (unlikely(!b_node->pivot[j]))
-			goto complete;
-
-		if (unlikely(mas->max == b_node->pivot[j]))
-			goto complete;
-	}
-
-	b_node->pivot[j] = mas_safe_pivot(mas, pivots, i, mt);
-
-complete:
-	b_node->b_end = ++j;
-	j -= mab_start;
-	slots = ma_slots(node, mt);
-	memcpy(b_node->slot + mab_start, slots + mas_start, sizeof(void *) * j);
-	if (!ma_is_leaf(mt) && mt_is_alloc(mas->tree)) {
-		gaps = ma_gaps(node, mt);
-		memcpy(b_node->gap + mab_start, gaps + mas_start,
-		       sizeof(unsigned long) * j);
-	}
-}
-
 /*
  * mas_leaf_set_meta() - Set the metadata of a leaf if possible.
  * @node: The maple node
@@ -1838,134 +1636,6 @@ static inline void mas_leaf_set_meta(struct maple_node *node,
 		ma_set_meta(node, mt, 0, end);
 }
 
-/*
- * mab_mas_cp() - Copy data from maple_big_node to a maple encoded node.
- * @b_node: the maple_big_node that has the data
- * @mab_start: the start location in @b_node.
- * @mab_end: The end location in @b_node (inclusively)
- * @mas: The maple state with the maple encoded node.
- */
-static inline void mab_mas_cp(struct maple_big_node *b_node,
-			      unsigned char mab_start, unsigned char mab_end,
-			      struct ma_state *mas, bool new_max)
-{
-	int i, j = 0;
-	enum maple_type mt = mte_node_type(mas->node);
-	struct maple_node *node = mte_to_node(mas->node);
-	void __rcu **slots = ma_slots(node, mt);
-	unsigned long *pivots = ma_pivots(node, mt);
-	unsigned long *gaps = NULL;
-	unsigned char end;
-
-	if (mab_end - mab_start > mt_pivots[mt])
-		mab_end--;
-
-	if (!pivots[mt_pivots[mt] - 1])
-		slots[mt_pivots[mt]] = NULL;
-
-	i = mab_start;
-	do {
-		pivots[j++] = b_node->pivot[i++];
-	} while (i <= mab_end && likely(b_node->pivot[i]));
-
-	memcpy(slots, b_node->slot + mab_start,
-	       sizeof(void *) * (i - mab_start));
-
-	if (new_max)
-		mas->max = b_node->pivot[i - 1];
-
-	end = j - 1;
-	if (likely(!ma_is_leaf(mt) && mt_is_alloc(mas->tree))) {
-		unsigned long max_gap = 0;
-		unsigned char offset = 0;
-
-		gaps = ma_gaps(node, mt);
-		do {
-			gaps[--j] = b_node->gap[--i];
-			if (gaps[j] > max_gap) {
-				offset = j;
-				max_gap = gaps[j];
-			}
-		} while (j);
-
-		ma_set_meta(node, mt, offset, end);
-	} else {
-		mas_leaf_set_meta(node, mt, end);
-	}
-}
-
-/*
- * mas_store_b_node() - Store an @entry into the b_node while also copying the
- * data from a maple encoded node.
- * @wr_mas: the maple write state
- * @b_node: the maple_big_node to fill with data
- * @offset_end: the offset to end copying
- *
- * Return: The actual end of the data stored in @b_node
- */
-static noinline_for_kasan void mas_store_b_node(struct ma_wr_state *wr_mas,
-		struct maple_big_node *b_node, unsigned char offset_end)
-{
-	unsigned char slot;
-	unsigned char b_end;
-	/* Possible underflow of piv will wrap back to 0 before use. */
-	unsigned long piv;
-	struct ma_state *mas = wr_mas->mas;
-
-	b_node->type = wr_mas->type;
-	b_end = 0;
-	slot = mas->offset;
-	if (slot) {
-		/* Copy start data up to insert. */
-		mas_mab_cp(mas, 0, slot - 1, b_node, 0);
-		b_end = b_node->b_end;
-		piv = b_node->pivot[b_end - 1];
-	} else
-		piv = mas->min - 1;
-
-	if (piv + 1 < mas->index) {
-		/* Handle range starting after old range */
-		b_node->slot[b_end] = wr_mas->content;
-		if (!wr_mas->content)
-			b_node->gap[b_end] = mas->index - 1 - piv;
-		b_node->pivot[b_end++] = mas->index - 1;
-	}
-
-	/* Store the new entry. */
-	mas->offset = b_end;
-	b_node->slot[b_end] = wr_mas->entry;
-	b_node->pivot[b_end] = mas->last;
-
-	/* Appended. */
-	if (mas->last >= mas->max)
-		goto b_end;
-
-	/* Handle new range ending before old range ends */
-	piv = mas_safe_pivot(mas, wr_mas->pivots, offset_end, wr_mas->type);
-	if (piv > mas->last) {
-		if (offset_end != slot)
-			wr_mas->content = mas_slot_locked(mas, wr_mas->slots,
-							  offset_end);
-
-		b_node->slot[++b_end] = wr_mas->content;
-		if (!wr_mas->content)
-			b_node->gap[b_end] = piv - mas->last + 1;
-		b_node->pivot[b_end] = piv;
-	}
-
-	slot = offset_end + 1;
-	if (slot > mas->end)
-		goto b_end;
-
-	/* Copy end data to the end of the node. */
-	mas_mab_cp(mas, slot, mas->end + 1, b_node, ++b_end);
-	b_node->b_end--;
-	return;
-
-b_end:
-	b_node->b_end = b_end;
-}
-
 /*
  * mas_prev_sibling() - Find the previous node with the same parent.
  * @mas: the maple state
@@ -2010,25 +1680,6 @@ static inline bool mas_next_sibling(struct ma_state *mas)
 	return true;
 }
 
-/*
- * mas_node_or_none() - Set the enode and state.
- * @mas: the maple state
- * @enode: The encoded maple node.
- *
- * Set the node to the enode and the status.
- */
-static inline void mas_node_or_none(struct ma_state *mas,
-		struct maple_enode *enode)
-{
-	if (enode) {
-		mas->node = enode;
-		mas->status = ma_active;
-	} else {
-		mas->node = NULL;
-		mas->status = ma_none;
-	}
-}
-
 /*
  * mas_wr_node_walk() - Find the correct offset for the index in the @mas.
  *                      If @mas->index cannot be found within the containing
@@ -2062,242 +1713,6 @@ static inline void mas_wr_node_walk(struct ma_wr_state *wr_mas)
 	wr_mas->offset_end = mas->offset = offset;
 }
 
-/*
- * mast_rebalance_next() - Rebalance against the next node
- * @mast: The maple subtree state
- */
-static inline void mast_rebalance_next(struct maple_subtree_state *mast)
-{
-	unsigned char b_end = mast->bn->b_end;
-
-	mas_mab_cp(mast->orig_r, 0, mt_slot_count(mast->orig_r->node),
-		   mast->bn, b_end);
-	mast->orig_r->last = mast->orig_r->max;
-}
-
-/*
- * mast_rebalance_prev() - Rebalance against the previous node
- * @mast: The maple subtree state
- */
-static inline void mast_rebalance_prev(struct maple_subtree_state *mast)
-{
-	unsigned char end = mas_data_end(mast->orig_l) + 1;
-	unsigned char b_end = mast->bn->b_end;
-
-	mab_shift_right(mast->bn, end);
-	mas_mab_cp(mast->orig_l, 0, end - 1, mast->bn, 0);
-	mast->l->min = mast->orig_l->min;
-	mast->orig_l->index = mast->orig_l->min;
-	mast->bn->b_end = end + b_end;
-	mast->l->offset += end;
-}
-
-/*
- * mast_spanning_rebalance() - Rebalance nodes with nearest neighbour favouring
- * the node to the right.  Checking the nodes to the right then the left at each
- * level upwards until root is reached.
- * Data is copied into the @mast->bn.
- * @mast: The maple_subtree_state.
- */
-static inline
-bool mast_spanning_rebalance(struct maple_subtree_state *mast)
-{
-	struct ma_state r_tmp = *mast->orig_r;
-	struct ma_state l_tmp = *mast->orig_l;
-	unsigned char depth = 0;
-
-	do {
-		mas_ascend(mast->orig_r);
-		mas_ascend(mast->orig_l);
-		depth++;
-		if (mast->orig_r->offset < mas_data_end(mast->orig_r)) {
-			mast->orig_r->offset++;
-			do {
-				mas_descend(mast->orig_r);
-				mast->orig_r->offset = 0;
-			} while (--depth);
-
-			mast_rebalance_next(mast);
-			*mast->orig_l = l_tmp;
-			return true;
-		} else if (mast->orig_l->offset != 0) {
-			mast->orig_l->offset--;
-			do {
-				mas_descend(mast->orig_l);
-				mast->orig_l->offset =
-					mas_data_end(mast->orig_l);
-			} while (--depth);
-
-			mast_rebalance_prev(mast);
-			*mast->orig_r = r_tmp;
-			return true;
-		}
-	} while (!mte_is_root(mast->orig_r->node));
-
-	*mast->orig_r = r_tmp;
-	*mast->orig_l = l_tmp;
-	return false;
-}
-
-/*
- * mast_ascend() - Ascend the original left and right maple states.
- * @mast: the maple subtree state.
- *
- * Ascend the original left and right sides.  Set the offsets to point to the
- * data already in the new tree (@mast->l and @mast->r).
- */
-static inline void mast_ascend(struct maple_subtree_state *mast)
-{
-	MA_WR_STATE(wr_mas, mast->orig_r,  NULL);
-	mas_ascend(mast->orig_l);
-	mas_ascend(mast->orig_r);
-
-	mast->orig_r->offset = 0;
-	mast->orig_r->index = mast->r->max;
-	/* last should be larger than or equal to index */
-	if (mast->orig_r->last < mast->orig_r->index)
-		mast->orig_r->last = mast->orig_r->index;
-
-	wr_mas.type = mte_node_type(mast->orig_r->node);
-	mas_wr_node_walk(&wr_mas);
-	/* Set up the left side of things */
-	mast->orig_l->offset = 0;
-	mast->orig_l->index = mast->l->min;
-	wr_mas.mas = mast->orig_l;
-	wr_mas.type = mte_node_type(mast->orig_l->node);
-	mas_wr_node_walk(&wr_mas);
-
-	mast->bn->type = wr_mas.type;
-}
-
-/*
- * mas_new_ma_node() - Create and return a new maple node.  Helper function.
- * @mas: the maple state with the allocations.
- * @b_node: the maple_big_node with the type encoding.
- *
- * Use the node type from the maple_big_node to allocate a new node from the
- * ma_state.  This function exists mainly for code readability.
- *
- * Return: A new maple encoded node
- */
-static inline struct maple_enode
-*mas_new_ma_node(struct ma_state *mas, struct maple_big_node *b_node)
-{
-	return mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)), b_node->type);
-}
-
-/*
- * mas_mab_to_node() - Set up right and middle nodes
- *
- * @mas: the maple state that contains the allocations.
- * @b_node: the node which contains the data.
- * @left: The pointer which will have the left node
- * @right: The pointer which may have the right node
- * @middle: the pointer which may have the middle node (rare)
- * @mid_split: the split location for the middle node
- *
- * Return: the split of left.
- */
-static inline unsigned char mas_mab_to_node(struct ma_state *mas,
-	struct maple_big_node *b_node, struct maple_enode **left,
-	struct maple_enode **right, struct maple_enode **middle,
-	unsigned char *mid_split)
-{
-	unsigned char split = 0;
-	unsigned char slot_count = mt_slots[b_node->type];
-
-	*left = mas_new_ma_node(mas, b_node);
-	*right = NULL;
-	*middle = NULL;
-	*mid_split = 0;
-
-	if (b_node->b_end < slot_count) {
-		split = b_node->b_end;
-	} else {
-		split = mab_calc_split(mas, b_node, mid_split);
-		*right = mas_new_ma_node(mas, b_node);
-	}
-
-	if (*mid_split)
-		*middle = mas_new_ma_node(mas, b_node);
-
-	return split;
-
-}
-
-/*
- * mab_set_b_end() - Add entry to b_node at b_node->b_end and increment the end
- * pointer.
- * @b_node: the big node to add the entry
- * @mas: the maple state to get the pivot (mas->max)
- * @entry: the entry to add, if NULL nothing happens.
- */
-static inline void mab_set_b_end(struct maple_big_node *b_node,
-				 struct ma_state *mas,
-				 void *entry)
-{
-	if (!entry)
-		return;
-
-	b_node->slot[b_node->b_end] = entry;
-	if (mt_is_alloc(mas->tree))
-		b_node->gap[b_node->b_end] = mas_max_gap(mas);
-	b_node->pivot[b_node->b_end++] = mas->max;
-}
-
-/*
- * mas_set_split_parent() - combine_then_separate helper function.  Sets the parent
- * of @mas->node to either @left or @right, depending on @slot and @split
- *
- * @mas: the maple state with the node that needs a parent
- * @left: possible parent 1
- * @right: possible parent 2
- * @slot: the slot the mas->node was placed
- * @split: the split location between @left and @right
- */
-static inline void mas_set_split_parent(struct ma_state *mas,
-					struct maple_enode *left,
-					struct maple_enode *right,
-					unsigned char *slot, unsigned char split)
-{
-	if (mas_is_none(mas))
-		return;
-
-	if ((*slot) <= split)
-		mas_set_parent(mas, mas->node, left, *slot);
-	else if (right)
-		mas_set_parent(mas, mas->node, right, (*slot) - split - 1);
-
-	(*slot)++;
-}
-
-/*
- * mte_mid_split_check() - Check if the next node passes the mid-split
- * @l: Pointer to left encoded maple node.
- * @m: Pointer to middle encoded maple node.
- * @r: Pointer to right encoded maple node.
- * @slot: The offset
- * @split: The split location.
- * @mid_split: The middle split.
- */
-static inline void mte_mid_split_check(struct maple_enode **l,
-				       struct maple_enode **r,
-				       struct maple_enode *right,
-				       unsigned char slot,
-				       unsigned char *split,
-				       unsigned char mid_split)
-{
-	if (*r == right)
-		return;
-
-	if (slot < mid_split)
-		return;
-
-	*l = *r;
-	*r = right;
-	*split = mid_split;
-}
-
 static inline void rebalance_sib(struct ma_state *parent, struct ma_state *sib)
 {
 	*sib = *parent;
@@ -2349,43 +1764,6 @@ void spanning_sib(struct ma_wr_state *l_wr_mas,
 	WARN_ON_ONCE(1);
 }
 
-/*
- * mast_set_split_parents() - Helper function to set three nodes parents.  Slot
- * is taken from @mast->l.
- * @mast: the maple subtree state
- * @left: the left node
- * @right: the right node
- * @split: the split location.
- */
-static inline void mast_set_split_parents(struct maple_subtree_state *mast,
-					  struct maple_enode *left,
-					  struct maple_enode *middle,
-					  struct maple_enode *right,
-					  unsigned char split,
-					  unsigned char mid_split)
-{
-	unsigned char slot;
-	struct maple_enode *l = left;
-	struct maple_enode *r = right;
-
-	if (mas_is_none(mast->l))
-		return;
-
-	if (middle)
-		r = middle;
-
-	slot = mast->l->offset;
-
-	mte_mid_split_check(&l, &r, right, slot, &split, mid_split);
-	mas_set_split_parent(mast->l, l, r, &slot, split);
-
-	mte_mid_split_check(&l, &r, right, slot, &split, mid_split);
-	mas_set_split_parent(mast->m, l, r, &slot, split);
-
-	mte_mid_split_check(&l, &r, right, slot, &split, mid_split);
-	mas_set_split_parent(mast->r, l, r, &slot, split);
-}
-
 /*
  * mas_topiary_node() - Dispose of a single node
  * @mas: The maple state for pushing nodes
@@ -2641,103 +2019,6 @@ void node_finalise(struct maple_node *node, enum maple_type mt,
 		ma_set_meta(node, mt, gap_slot, end - 1);
 }
 
-/*
- * mast_cp_to_nodes() - Copy data out to nodes.
- * @mast: The maple subtree state
- * @left: The left encoded maple node
- * @middle: The middle encoded maple node
- * @right: The right encoded maple node
- * @split: The location to split between left and (middle ? middle : right)
- * @mid_split: The location to split between middle and right.
- */
-static inline void mast_cp_to_nodes(struct maple_subtree_state *mast,
-	struct maple_enode *left, struct maple_enode *middle,
-	struct maple_enode *right, unsigned char split, unsigned char mid_split)
-{
-	bool new_lmax = true;
-
-	mas_node_or_none(mast->l, left);
-	mas_node_or_none(mast->m, middle);
-	mas_node_or_none(mast->r, right);
-
-	mast->l->min = mast->orig_l->min;
-	if (split == mast->bn->b_end) {
-		mast->l->max = mast->orig_r->max;
-		new_lmax = false;
-	}
-
-	mab_mas_cp(mast->bn, 0, split, mast->l, new_lmax);
-
-	if (middle) {
-		mab_mas_cp(mast->bn, 1 + split, mid_split, mast->m, true);
-		mast->m->min = mast->bn->pivot[split] + 1;
-		split = mid_split;
-	}
-
-	mast->r->max = mast->orig_r->max;
-	if (right) {
-		mab_mas_cp(mast->bn, 1 + split, mast->bn->b_end, mast->r, false);
-		mast->r->min = mast->bn->pivot[split] + 1;
-	}
-}
-
-/*
- * mast_combine_cp_left - Copy in the original left side of the tree into the
- * combined data set in the maple subtree state big node.
- * @mast: The maple subtree state
- */
-static inline void mast_combine_cp_left(struct maple_subtree_state *mast)
-{
-	unsigned char l_slot = mast->orig_l->offset;
-
-	if (!l_slot)
-		return;
-
-	mas_mab_cp(mast->orig_l, 0, l_slot - 1, mast->bn, 0);
-}
-
-/*
- * mast_combine_cp_right: Copy in the original right side of the tree into the
- * combined data set in the maple subtree state big node.
- * @mast: The maple subtree state
- */
-static inline void mast_combine_cp_right(struct maple_subtree_state *mast)
-{
-	if (mast->bn->pivot[mast->bn->b_end - 1] >= mast->orig_r->max)
-		return;
-
-	mas_mab_cp(mast->orig_r, mast->orig_r->offset + 1,
-		   mt_slot_count(mast->orig_r->node), mast->bn,
-		   mast->bn->b_end);
-	mast->orig_r->last = mast->orig_r->max;
-}
-
-/*
- * mast_sufficient: Check if the maple subtree state has enough data in the big
- * node to create at least one sufficient node
- * @mast: the maple subtree state
- */
-static inline bool mast_sufficient(struct maple_subtree_state *mast)
-{
-	if (mast->bn->b_end > mt_min_slot_count(mast->orig_l->node))
-		return true;
-
-	return false;
-}
-
-/*
- * mast_overflow: Check if there is too much data in the subtree state for a
- * single node.
- * @mast: The maple subtree state
- */
-static inline bool mast_overflow(struct maple_subtree_state *mast)
-{
-	if (mast->bn->b_end > mt_slot_count(mast->orig_l->node))
-		return true;
-
-	return false;
-}
-
 static inline void *mtree_range_walk(struct ma_state *mas)
 {
 	unsigned long *pivots;
@@ -3296,158 +2577,6 @@ static inline void cp_dst_to_slots(struct maple_copy *cp, unsigned long min,
 	cp->max = max;
 }
 
-static void mas_spanning_rebalance_loop(struct ma_state *mas,
-		struct maple_subtree_state *mast, unsigned char count)
-{
-
-	unsigned char split, mid_split;
-	unsigned char slot = 0;
-	unsigned char new_height = 0; /* used if node is a new root */
-	struct maple_enode *left = NULL, *middle = NULL, *right = NULL;
-	struct maple_enode *old_enode;
-
-	/*
-	 * Each level of the tree is examined and balanced, pushing data to the left or
-	 * right, or rebalancing against left or right nodes is employed to avoid
-	 * rippling up the tree to limit the amount of churn.  Once a new sub-section of
-	 * the tree is created, there may be a mix of new and old nodes.  The old nodes
-	 * will have the incorrect parent pointers and currently be in two trees: the
-	 * original tree and the partially new tree.  To remedy the parent pointers in
-	 * the old tree, the new data is swapped into the active tree and a walk down
-	 * the tree is performed and the parent pointers are updated.
-	 * See mas_topiary_replace() for more information.
-	 */
-	while (count--) {
-		mast->bn->b_end--;
-		mast->bn->type = mte_node_type(mast->orig_l->node);
-		split = mas_mab_to_node(mas, mast->bn, &left, &right, &middle,
-					&mid_split);
-		mast_set_split_parents(mast, left, middle, right, split,
-				       mid_split);
-		mast_cp_to_nodes(mast, left, middle, right, split, mid_split);
-		new_height++;
-
-		/*
-		 * Copy data from next level in the tree to mast->bn from next
-		 * iteration
-		 */
-		memset(mast->bn, 0, sizeof(struct maple_big_node));
-		mast->bn->type = mte_node_type(left);
-
-		/* Root already stored in l->node. */
-		if (mas_is_root_limits(mast->l))
-			goto new_root;
-
-		mast_ascend(mast);
-		mast_combine_cp_left(mast);
-		mast->l->offset = mast->bn->b_end;
-		mab_set_b_end(mast->bn, mast->l, left);
-		mab_set_b_end(mast->bn, mast->m, middle);
-		mab_set_b_end(mast->bn, mast->r, right);
-
-		/* Copy anything necessary out of the right node. */
-		mast_combine_cp_right(mast);
-		mast->orig_l->last = mast->orig_l->max;
-
-		if (mast_sufficient(mast)) {
-			if (mast_overflow(mast))
-				continue;
-
-			if (mast->orig_l->node == mast->orig_r->node) {
-			       /*
-				* The data in b_node should be stored in one
-				* node and in the tree
-				*/
-				slot = mast->l->offset;
-				break;
-			}
-
-			continue;
-		}
-
-		/* May be a new root stored in mast->bn */
-		if (mas_is_root_limits(mast->orig_l))
-			break;
-
-		mast_spanning_rebalance(mast);
-
-		/* rebalancing from other nodes may require another loop. */
-		if (!count)
-			count++;
-	}
-
-	mast->l->node = mt_mk_node(ma_mnode_ptr(mas_pop_node(mas)),
-				mte_node_type(mast->orig_l->node));
-
-	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
-	new_height++;
-	mas_set_parent(mas, left, mast->l->node, slot);
-	if (middle)
-		mas_set_parent(mas, middle, mast->l->node, ++slot);
-
-	if (right)
-		mas_set_parent(mas, right, mast->l->node, ++slot);
-
-	if (mas_is_root_limits(mast->l)) {
-new_root:
-		mas_mn(mast->l)->parent = ma_parent_ptr(mas_tree_parent(mas));
-		while (!mte_is_root(mast->orig_l->node))
-			mast_ascend(mast);
-	} else {
-		mas_mn(mast->l)->parent = mas_mn(mast->orig_l)->parent;
-	}
-
-	old_enode = mast->orig_l->node;
-	mas->depth = mast->l->depth;
-	mas->node = mast->l->node;
-	mas->min = mast->l->min;
-	mas->max = mast->l->max;
-	mas->offset = mast->l->offset;
-	mas_wmb_replace(mas, old_enode, new_height);
-	mtree_range_walk(mas);
-}
-
-/*
- * mas_spanning_rebalance() - Rebalance across two nodes which may not be peers.
- * @mas: The starting maple state
- * @mast: The maple_subtree_state, keeps track of 4 maple states.
- * @count: The estimated count of iterations needed.
- *
- * Follow the tree upwards from @l_mas and @r_mas for @count, or until the root
- * is hit.  First @b_node is split into two entries which are inserted into the
- * next iteration of the loop.  @b_node is returned populated with the final
- * iteration. @mas is used to obtain allocations.  orig_l_mas keeps track of the
- * nodes that will remain active by using orig_l_mas->index and orig_l_mas->last
- * to account of what has been copied into the new sub-tree.  The update of
- * orig_l_mas->last is used in mas_consume to find the slots that will need to
- * be either freed or destroyed.  orig_l_mas->depth keeps track of the height of
- * the new sub-tree in case the sub-tree becomes the full tree.
- */
-static void mas_spanning_rebalance(struct ma_state *mas,
-		struct maple_subtree_state *mast, unsigned char count)
-{
-
-	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
-
-	/*
-	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
-	 * Rebalancing is done by use of the ``struct maple_topiary``.
-	 */
-	mast->l = &l_mas;
-	mast->m = &m_mas;
-	mast->r = &r_mas;
-	l_mas.status = r_mas.status = m_mas.status = ma_none;
-
-	/* Check if this is not root and has sufficient data.  */
-	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
-	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
-		mast_spanning_rebalance(mast);
-
-	mas_spanning_rebalance_loop(mas, mast, count);
-}
-
 static inline bool cp_is_new_root(struct maple_copy *cp, struct ma_state *mas)
 {
 	if (cp->min || cp->max != ULONG_MAX)
@@ -3586,319 +2715,6 @@ static inline bool rebalance_ascend(struct maple_copy *cp,
 	return true;
 }
 
-/*
- * mas_rebalance() - Rebalance a given node.
- * @mas: The maple state
- * @b_node: The big maple node.
- *
- * Rebalance two nodes into a single node or two new nodes that are sufficient.
- * Continue upwards until tree is sufficient.
- */
-static inline void mas_rebalance(struct ma_state *mas,
-				struct maple_big_node *b_node)
-{
-	char empty_count = mas_mt_height(mas);
-	struct maple_subtree_state mast;
-	unsigned char shift, b_end = ++b_node->b_end;
-
-	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-
-	trace_ma_op(TP_FCT, mas);
-
-	/*
-	 * Rebalancing occurs if a node is insufficient.  Data is rebalanced
-	 * against the node to the right if it exists, otherwise the node to the
-	 * left of this node is rebalanced against this node.  If rebalancing
-	 * causes just one node to be produced instead of two, then the parent
-	 * is also examined and rebalanced if it is insufficient.  Every level
-	 * tries to combine the data in the same way.  If one node contains the
-	 * entire range of the tree, then that node is used as a new root node.
-	 */
-
-	mast.orig_l = &l_mas;
-	mast.orig_r = &r_mas;
-	mast.bn = b_node;
-	mast.bn->type = mte_node_type(mas->node);
-
-	l_mas = r_mas = *mas;
-
-	if (mas_next_sibling(&r_mas)) {
-		mas_mab_cp(&r_mas, 0, mt_slot_count(r_mas.node), b_node, b_end);
-		r_mas.last = r_mas.index = r_mas.max;
-	} else {
-		mas_prev_sibling(&l_mas);
-		shift = mas_data_end(&l_mas) + 1;
-		mab_shift_right(b_node, shift);
-		mas->offset += shift;
-		mas_mab_cp(&l_mas, 0, shift - 1, b_node, 0);
-		b_node->b_end = shift + b_end;
-		l_mas.index = l_mas.last = l_mas.min;
-	}
-
-	return mas_spanning_rebalance(mas, &mast, empty_count);
-}
-
-/*
- * mas_split_final_node() - Split the final node in a subtree operation.
- * @mast: the maple subtree state
- * @mas: The maple state
- */
-static inline void mas_split_final_node(struct maple_subtree_state *mast,
-					struct ma_state *mas)
-{
-	struct maple_enode *ancestor;
-
-	if (mte_is_root(mas->node)) {
-		if (mt_is_alloc(mas->tree))
-			mast->bn->type = maple_arange_64;
-		else
-			mast->bn->type = maple_range_64;
-	}
-	/*
-	 * Only a single node is used here, could be root.
-	 * The Big_node data should just fit in a single node.
-	 */
-	ancestor = mas_new_ma_node(mas, mast->bn);
-	mas_set_parent(mas, mast->l->node, ancestor, mast->l->offset);
-	mas_set_parent(mas, mast->r->node, ancestor, mast->r->offset);
-	mte_to_node(ancestor)->parent = mas_mn(mas)->parent;
-
-	mast->l->node = ancestor;
-	mab_mas_cp(mast->bn, 0, mt_slots[mast->bn->type] - 1, mast->l, true);
-	mas->offset = mast->bn->b_end - 1;
-}
-
-/*
- * mast_fill_bnode() - Copy data into the big node in the subtree state
- * @mast: The maple subtree state
- * @mas: the maple state
- * @skip: The number of entries to skip for new nodes insertion.
- */
-static inline void mast_fill_bnode(struct maple_subtree_state *mast,
-					 struct ma_state *mas,
-					 unsigned char skip)
-{
-	bool cp = true;
-	unsigned char split;
-
-	memset(mast->bn, 0, sizeof(struct maple_big_node));
-
-	if (mte_is_root(mas->node)) {
-		cp = false;
-	} else {
-		mas_ascend(mas);
-		mas->offset = mte_parent_slot(mas->node);
-	}
-
-	if (cp && mast->l->offset)
-		mas_mab_cp(mas, 0, mast->l->offset - 1, mast->bn, 0);
-
-	split = mast->bn->b_end;
-	mab_set_b_end(mast->bn, mast->l, mast->l->node);
-	mast->r->offset = mast->bn->b_end;
-	mab_set_b_end(mast->bn, mast->r, mast->r->node);
-	if (mast->bn->pivot[mast->bn->b_end - 1] == mas->max)
-		cp = false;
-
-	if (cp)
-		mas_mab_cp(mas, split + skip, mt_slot_count(mas->node) - 1,
-			   mast->bn, mast->bn->b_end);
-
-	mast->bn->b_end--;
-	mast->bn->type = mte_node_type(mas->node);
-}
-
-/*
- * mast_split_data() - Split the data in the subtree state big node into regular
- * nodes.
- * @mast: The maple subtree state
- * @mas: The maple state
- * @split: The location to split the big node
- */
-static inline void mast_split_data(struct maple_subtree_state *mast,
-	   struct ma_state *mas, unsigned char split)
-{
-	unsigned char p_slot;
-
-	mab_mas_cp(mast->bn, 0, split, mast->l, true);
-	mte_set_pivot(mast->r->node, 0, mast->r->max);
-	mab_mas_cp(mast->bn, split + 1, mast->bn->b_end, mast->r, false);
-	mast->l->offset = mte_parent_slot(mas->node);
-	mast->l->max = mast->bn->pivot[split];
-	mast->r->min = mast->l->max + 1;
-	if (mte_is_leaf(mas->node))
-		return;
-
-	p_slot = mast->orig_l->offset;
-	mas_set_split_parent(mast->orig_l, mast->l->node, mast->r->node,
-			     &p_slot, split);
-	mas_set_split_parent(mast->orig_r, mast->l->node, mast->r->node,
-			     &p_slot, split);
-}
-
-/*
- * mas_push_data() - Instead of splitting a node, it is beneficial to push the
- * data to the right or left node if there is room.
- * @mas: The maple state
- * @mast: The maple subtree state
- * @left: Push left or not.
- *
- * Keeping the height of the tree low means faster lookups.
- *
- * Return: True if pushed, false otherwise.
- */
-static inline bool mas_push_data(struct ma_state *mas,
-				struct maple_subtree_state *mast, bool left)
-{
-	unsigned char slot_total = mast->bn->b_end;
-	unsigned char end, space, split;
-
-	MA_STATE(tmp_mas, mas->tree, mas->index, mas->last);
-	tmp_mas = *mas;
-	tmp_mas.depth = mast->l->depth;
-
-	if (left && !mas_prev_sibling(&tmp_mas))
-		return false;
-	else if (!left && !mas_next_sibling(&tmp_mas))
-		return false;
-
-	end = mas_data_end(&tmp_mas);
-	slot_total += end;
-	space = 2 * mt_slot_count(mas->node) - 2;
-	/* -2 instead of -1 to ensure there isn't a triple split */
-	if (ma_is_leaf(mast->bn->type))
-		space--;
-
-	if (mas->max == ULONG_MAX)
-		space--;
-
-	if (slot_total >= space)
-		return false;
-
-	/* Get the data; Fill mast->bn */
-	mast->bn->b_end++;
-	if (left) {
-		mab_shift_right(mast->bn, end + 1);
-		mas_mab_cp(&tmp_mas, 0, end, mast->bn, 0);
-		mast->bn->b_end = slot_total + 1;
-	} else {
-		mas_mab_cp(&tmp_mas, 0, end, mast->bn, mast->bn->b_end);
-	}
-
-	/* Configure mast for splitting of mast->bn */
-	split = mt_slots[mast->bn->type] - 2;
-	if (left) {
-		/*  Switch mas to prev node  */
-		*mas = tmp_mas;
-		/* Start using mast->l for the left side. */
-		tmp_mas.node = mast->l->node;
-		*mast->l = tmp_mas;
-	} else {
-		tmp_mas.node = mast->r->node;
-		*mast->r = tmp_mas;
-		split = slot_total - split;
-	}
-	split = mab_no_null_split(mast->bn, split, mt_slots[mast->bn->type]);
-	/* Update parent slot for split calculation. */
-	if (left)
-		mast->orig_l->offset += end + 1;
-
-	mast_split_data(mast, mas, split);
-	mast_fill_bnode(mast, mas, 2);
-	mas_split_final_node(mast, mas);
-	return true;
-}
-
-/*
- * mas_split() - Split data that is too big for one node into two.
- * @mas: The maple state
- * @b_node: The maple big node
- */
-static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
-{
-	struct maple_subtree_state mast;
-	int height = 0;
-	unsigned int orig_height = mas_mt_height(mas);
-	unsigned char mid_split, split = 0;
-	struct maple_enode *old;
-
-	/*
-	 * Splitting is handled differently from any other B-tree; the Maple
-	 * Tree splits upwards.  Splitting up means that the split operation
-	 * occurs when the walk of the tree hits the leaves and not on the way
-	 * down.  The reason for splitting up is that it is impossible to know
-	 * how much space will be needed until the leaf is (or leaves are)
-	 * reached.  Since overwriting data is allowed and a range could
-	 * overwrite more than one range or result in changing one entry into 3
-	 * entries, it is impossible to know if a split is required until the
-	 * data is examined.
-	 *
-	 * Splitting is a balancing act between keeping allocations to a minimum
-	 * and avoiding a 'jitter' event where a tree is expanded to make room
-	 * for an entry followed by a contraction when the entry is removed.  To
-	 * accomplish the balance, there are empty slots remaining in both left
-	 * and right nodes after a split.
-	 */
-	MA_STATE(l_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(prev_l_mas, mas->tree, mas->index, mas->last);
-	MA_STATE(prev_r_mas, mas->tree, mas->index, mas->last);
-
-	trace_ma_op(TP_FCT, mas);
-
-	mast.l = &l_mas;
-	mast.r = &r_mas;
-	mast.orig_l = &prev_l_mas;
-	mast.orig_r = &prev_r_mas;
-	mast.bn = b_node;
-
-	while (height++ <= orig_height) {
-		if (mt_slots[b_node->type] > b_node->b_end) {
-			mas_split_final_node(&mast, mas);
-			break;
-		}
-
-		l_mas = r_mas = *mas;
-		l_mas.node = mas_new_ma_node(mas, b_node);
-		r_mas.node = mas_new_ma_node(mas, b_node);
-		/*
-		 * Another way that 'jitter' is avoided is to terminate a split up early if the
-		 * left or right node has space to spare.  This is referred to as "pushing left"
-		 * or "pushing right" and is similar to the B* tree, except the nodes left or
-		 * right can rarely be reused due to RCU, but the ripple upwards is halted which
-		 * is a significant savings.
-		 */
-		/* Try to push left. */
-		if (mas_push_data(mas, &mast, true)) {
-			height++;
-			break;
-		}
-		/* Try to push right. */
-		if (mas_push_data(mas, &mast, false)) {
-			height++;
-			break;
-		}
-
-		split = mab_calc_split(mas, b_node, &mid_split);
-		mast_split_data(&mast, mas, split);
-		/*
-		 * Usually correct, mab_mas_cp in the above call overwrites
-		 * r->max.
-		 */
-		mast.r->max = mas->max;
-		mast_fill_bnode(&mast, mas, 1);
-		prev_l_mas = *mast.l;
-		prev_r_mas = *mast.r;
-	}
-
-	/* Set the original node as dead */
-	old = mas->node;
-	mas->node = l_mas.node;
-	mas_wmb_replace(mas, old, height);
-	mtree_range_walk(mas);
-}
-
 /*
  * mas_root_expand() - Expand a root to a node
  * @mas: The maple state
-- 
2.47.3


