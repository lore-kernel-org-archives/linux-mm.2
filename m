Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E3AC44506
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 18:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFEF6B0005; Wed, 21 Jan 2026 13:07:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BA266B00C6; Wed, 21 Jan 2026 13:07:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BCF6B00C8; Wed, 21 Jan 2026 13:07:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E69B96B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 13:07:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94E918CAC0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:07:34 +0000 (UTC)
X-FDA: 84356753628.27.B196DB3
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0FA2C1C002E
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 18:07:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mD8FTYR6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qj0iHBpo;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769018851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=;
	b=1b2GgThjoLsdxUKi9Tksa5Zawu+6xZrjOaLUi6PhH8TfEb2r7ntv7ZiuQOWs/h+u20eJVa
	2r6umdYs8sNe1jMiGadwzPdnd6GWeV14DPED6hAbem4VuuPXEjK/3fT/81AuRJo0jnw02R
	GZK/uzRz/LS6Zk7U18a20bo8U9CrpUM=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=mD8FTYR6;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=Qj0iHBpo;
	spf=pass (imf21.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769018851; a=rsa-sha256;
	cv=pass;
	b=lgC6avaHUXA7ujv/+IXGsTiJp5F1zozvxYT4t5VlPes4+kDcUfZJffGjmUtKdQPb1VqkU1
	ErjSB4kxqiALHtAPEGfzaNvgGAhOwobtdR3W4Acnu0bu4FppwklG3fZjJCS/MZLIZAj3ZI
	aZyO1ws64TkAk9fY1M53ByZG/Ni0uhk=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60LESadW3031067;
	Wed, 21 Jan 2026 16:57:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=; b=
	mD8FTYR6+oqzEGqsBw+ub8tbopbl/pR1CL4cw8T6DqsszTJ/sFNxYBkhED28F8V0
	+ZtNpraGKOzPJXGC7ZdizOPMvEjs+gPDtT+SlJXNh0AaVpWv9Z/nxLC8RV9Y5x2Q
	HHr8IF8nZ4j6GgQBNdMdpnHNXFjBtflV+k67H1jaGs6tDTUP/ymlwwFtzRwxhlGx
	TjTf53jxeiieaQzL2sa+HPZKq+MsxkuGKpQVdLOT23DXWwkiJPyjLPu8GEDePyO8
	xYkKS0hFusfLoLw71oG3XPxMjrpFseZi75wY5gHKiDnhYNffHComkDflDFb4NpYk
	x27soSH2JgZ7LRP94gLebw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4br10vx8mh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60LGNgJi008393;
	Wed, 21 Jan 2026 16:57:12 GMT
Received: from ph8pr06cu001.outbound.protection.outlook.com (mail-westus3azon11012023.outbound.protection.outlook.com [40.107.209.23])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4br0vbht22-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Jan 2026 16:57:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=tti6q6iA5j16GvKPLWrg6w/pWvLZD0BfKNvLLOesK1DKd18oEWVLttaMJI2pvfJNAwZAK9aky74QxIh1bRtL736r8a91vYxbJiSYFJvgW91bHoo62rMfASgalQ+3DUjz/gxCx5jz+yoJXAoshzDM3BLPg3Tj/QOU5ubg6S2w5B/TancF06AGdaCN1TWfvYusM9KN7UJIbY1HDAwRj6ruRoiYOL7Xr0GWpT7XYF6GcP29SuTJAG8TR+Yc0mNHyXORjuCh/1Xe8tf2PhnQgYz2O0XFDI/nQr5lde7OK/XeZ/vJaxZCmMHbmR9I1REp9sBJGZzveVSK2+8PKwatjQuYRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=;
 b=qH1Z6x2cEkPC4T0UG2pu9bg0L5KDU0ubHU3Gic6VQ4LXXDX28sQC9+RZuOzHwPn0eI1msme1967tukGmOuWZxh2od2/xuKdp1C00i2KrEYjubG91VVseeE4m06YZCKH2N76lNcYLaTkLzvjr4pb2EAEAIz3K1f8MUhO/GvsVxCAU++uGMP7QIfeDXli3ApSYKdYIK9mCZYc7UMQgMfTtm1O7u36VBMRrx5RA2wwSp7ha9Ba9ct6AMDt5YerMA+NfonrGWabwnDTpMxraIl4fcplP6u5YPpkwYVq1ySxB83C310ysiNrJUqs+Ng9wLBuDcP4mbX+6OEQynDP1ncmhXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7EhrgKQnDfJ+QTXrI98tq9qj6wGR4JohjeNGICPwKP8=;
 b=Qj0iHBpoj0+Irq89Ivq9OhCt1cMTRaUVw8U20dSqoDuuIt0ZuyzNajFBcEmnBE7cm2a99nubhIKArR/hVouuofwxbp5RnQaN2NT7sk8nbnk8E4LQ4P0Y1itqMQRXQalnWEt2U/gXrHP+hHtP6GJFeyGbDhfpFfuCSxNa2e0hxxY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by LV8PR10MB7727.namprd10.prod.outlook.com (2603:10b6:408:1ed::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.9; Wed, 21 Jan
 2026 16:57:08 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9542.008; Wed, 21 Jan 2026
 16:57:08 +0000
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
Subject: [PATCH v2 11/29] maple_tree: Introduce maple_copy node and use it in mas_spanning_rebalance()
Date: Wed, 21 Jan 2026 11:45:08 -0500
Message-ID: <20260121164526.2093265-12-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
References: <20260121164526.2093265-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT2PR01CA0013.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:38::18) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|LV8PR10MB7727:EE_
X-MS-Office365-Filtering-Correlation-Id: 31a9a476-4c88-44bf-7313-08de590e1bcc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v3fJ/M7+A7cxsknWn5h9cYhOeebyGOdo9Et7VB5AsJKvT7KwZI9jtBRgo2VG?=
 =?us-ascii?Q?fbTw9yFyyVYPy61Ctr7OigO1ZzRUE8WCieFQKdkGaOOJwechIrKSrS2RiwIY?=
 =?us-ascii?Q?LZOWVCG27nZ/SP0T3CMt0T2A9r6GRy0k1OSQ0pHfyk4sRM0coCp1E2Ic7XRc?=
 =?us-ascii?Q?Dnmalc+It32ISw297iWnxsv6gbnr7doLwXIKolb9bziYNTeXIQGSrGCrp8rz?=
 =?us-ascii?Q?mHul3jrAgNWNUSEHCgv8xUQPdyG8CPIlzUMaI4m/ITyGJMVo7R/fd47UH7Rf?=
 =?us-ascii?Q?s0FB0hCbjThi4ppxplKC7EfoXIHPw0j5P9pIt7KEcJf4v6p1XsGMXO+LUbXx?=
 =?us-ascii?Q?B56SWskVSzulMwYqFvebJjNRvqBYsge1RHDWPtz/aWsI0TRzmVo/xtdaTUaX?=
 =?us-ascii?Q?UsMOmhqbGqhU9ufI78NG4LTBfxYewgiv07bV1LnoSF49C0tgH2WTu8aN5+nK?=
 =?us-ascii?Q?uwnh2sY7JvI3nG/4cy+4ar8UgAHNrvH5VPu8ZTgY81tXnr6mqqLp6JNgvD0A?=
 =?us-ascii?Q?QxpAwNyPIj8XfB06d79u6LnSVLWp8qVpW06YhWHmrwFIVvgkqblhWwCM01z2?=
 =?us-ascii?Q?a1VJK88wBxwmKQFTa4fijHS10qWbc0/vJPkjpxA9skFqGkwHKvSNontMS56s?=
 =?us-ascii?Q?IV+3ZRFbC7R47Nm6FS2//Erb1fKTsp8jYoyVG9PQRUNIUFV+F2vhYH3+AXD2?=
 =?us-ascii?Q?8ihKfM9d88+O0hwf0bi/EXmkN4XOEE4dHXUA/oM71H97JQfNNlBBF4ExtAPl?=
 =?us-ascii?Q?4RoGbVrXJ+Lu2hoNYkUwe6ykLgP2cMqWLyHnzyT0exfNxEFb4gr5sXB3mwJM?=
 =?us-ascii?Q?s4s4c7dhHAd8IpL6J+4l16DSI5DyICIstm22LJxwJy/wJSmdeRWOMeTXOOW8?=
 =?us-ascii?Q?P86T3+FSroBim0JTRZPmWhb2QwXAjHE0jRlXKlD4w43Y7FTULBrtKO6yqF7T?=
 =?us-ascii?Q?krGW5E2RijpOGs+iSwEFtCiFdWiAQsr2C9d1RA7LxnNU0+Gy1QiZBGLDqhS8?=
 =?us-ascii?Q?XBAQYwppUY5A4ipV19lQBy0lBYd3GW1eBrY0VrDR2jrQkFFZtCA+o2zXHN6W?=
 =?us-ascii?Q?rKVjo4XaZNp2amfx3rZq7zRzE2UZtXYw2lHrDIjgb84AlSrr7RcTiMrcXW39?=
 =?us-ascii?Q?54o3ctQvJDq6LW0DKyaz1Dg6EOtnYk9oUGG0N6kUTK0+xCg1q8IMJ3UwPM60?=
 =?us-ascii?Q?fZZrWsai2+na+kzemHyI1Ka/MeNlum/c8ZxjsGLlUP2Z8+y9JtaZKbAKJm2g?=
 =?us-ascii?Q?cL7BSz0t17C10jfetyC1TFt9Zb4oKC07vUKJEBIImwLmExjTN9KARx278eem?=
 =?us-ascii?Q?mEYFUsnr+bQu3GjuO8O6oZbDvHqBpiR9dV5775jDszhEpdV39AlJrXE5APu6?=
 =?us-ascii?Q?Ck5YOe9VKgMIArvLIA1WCwrT0IwvXxas7n+1v1hCLO6DpNPije+hbTnIfr1X?=
 =?us-ascii?Q?hLGCsfyJrGr6t/+dn0tNdo81cbIPImayvkCVNDu7FdzwJGDfG5ejIn+rZEsc?=
 =?us-ascii?Q?e6KtxWhU57yEmRVzrTuUWkpdZ+HKL5kdUQAuopFcUqX7+beKAcPSoUaTC3YI?=
 =?us-ascii?Q?wIkbz0skcfBOY4xT+hY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?c19Q7weWujBOau6Xt3uULERypjj/GJFMep4x/YctXGiNLXMOmkADoQ9/CZJ8?=
 =?us-ascii?Q?PXcITCnA0vl8mBIxGUfPAo0VRZwk0NtVvJav+zWJ//9dpw7NrlOhJwH0z49l?=
 =?us-ascii?Q?dX7vrq2ll7BfDn4vGhkBjwoBg3E8QY/4rDQeFZnJDem1INwAlMbsmG3cdhKV?=
 =?us-ascii?Q?lOqu5bsiEK+LCvoKNXzxleKXQmWY5NHfj9RdEAUJP+aFW/gpafmXVel4M0zy?=
 =?us-ascii?Q?ikCeJHqAsXknbK4jHZcdTjnL37MHve+P9jgouCA193jxay2w76zlkdGukw3F?=
 =?us-ascii?Q?qEiQH7gtepulRyuCcM5r6y0akmb8JeRDxPuNTZSaGfKC2hr4e0bT/RCXr8wE?=
 =?us-ascii?Q?52/Dkv+Aw/2HlSksrN3mwcrWJ1bOThqHzP+jVuKx4sUOc2nagdeGQvn+ND9Z?=
 =?us-ascii?Q?g0eoPkHZk2u4WB8qoDKJYOvtNs4S9vcAhmLgshIxZv7ax8Jfj1dFHz9tgFGU?=
 =?us-ascii?Q?lVn8dEX38M6ZW50+UDyKTGCwJIwLVpHFapRzpciEWdGqu5pqR6erMK6JvIXT?=
 =?us-ascii?Q?H5QLkFEx/Mlijq0YxDFkj3HsRg4A6ebNCqqXrhLFwZSCbfDdFdwCNP3QaalU?=
 =?us-ascii?Q?FRA+VN6grXphcP3HUdGSRv0oUv0Y5DdWScj/9qctsZeJd5SBfFe4nS75VXn3?=
 =?us-ascii?Q?7EVI2wZEaX0w2zPslGs1sH1HgHNtdQXqZ7m5JRNCvLe5saKBIFtxvC1Nm2JX?=
 =?us-ascii?Q?Ni/Yq6tg54tVcL8CzVYna+2rRkJDq6+L+xxS9LXA7WDbgogUx2HXHGFHV9wp?=
 =?us-ascii?Q?+5hN+Sr8hCHvlHbwlGzNTKOQeor7A3TEkQ5wAnUnPeQZhVEcLOGXVxYyK/U9?=
 =?us-ascii?Q?kWRQCODAPZgxoSKYimJpI9mTB9JfHMO6i+49tUfqptGWSsAJsVRXHiwagLdY?=
 =?us-ascii?Q?sZ+rQJoBwG2LHr4v5H9QJeKruyX7b1qNw43Xds8CkpHeT7xAKrhclltm/u7s?=
 =?us-ascii?Q?pk2TTPe2OcILIR1R8puVIC/p+Q6w6+jEV6j/sruJ08gnwqOdhMorRHphPB8a?=
 =?us-ascii?Q?aVE2zArZVm4AO8keXmgCNrRA8gcqfiMssc2ePL6uOKat0Ma1ZqZDGCDYYPdX?=
 =?us-ascii?Q?kldmcwbFjLJKz9V1jM0UynA964tznSK0/vTVy+gUvcxd2fRBLy5sLLRV03IM?=
 =?us-ascii?Q?gppyosCtl7LDOT6Yo84IniQEMSFaD/q32FQXY332K4yTrB3t4Q7z61dqB5A/?=
 =?us-ascii?Q?jdIiytS5wmW2yDWl0gTbGTmEpPDPPvqybjjfUlsE31/+7KR2oiRNkHQAA9Py?=
 =?us-ascii?Q?ScszkP4fgroqusK2Zk9o9ix1gj3SyK4su/OfTW0f6gdHRXgNJjI0LycaOilo?=
 =?us-ascii?Q?+LPZ4lydtxohcGuJnUvILYlxQgn0ridTIzAHKBmD+X+AfCus5Sc7qISWlWMx?=
 =?us-ascii?Q?GFO4LxkymC5q1C+rlnW3b3rdthw+abt2jTJmqa9UT5Ktq2efdluxw2GbTk5z?=
 =?us-ascii?Q?3E0GrDtMY1kuxkvoYn6b71JsjARpdKm+YV/0UxfU1sCsYnMZzX1/1yEWpeL8?=
 =?us-ascii?Q?iPFnT5tUdJTKC+OVLQvwgzgWiAaeIZFIHk6eNoOLNalwj8o5Tdw/sRlefWuS?=
 =?us-ascii?Q?oteiLbnjqeWuhlMmcAZ5Jsdt/tW2HWUGgcppPlumpETPXq67GFutuBcktEbd?=
 =?us-ascii?Q?m62qwO2kKRkBqTr+CVmLnheNfiyFzRBSqBJzv5jbzsrVWynWynLqcNDRJh+2?=
 =?us-ascii?Q?en0g9kGroaUT+GrNh06A3J5yfWG1ckrMSrSwfFKiVRvOqQpAS6YGPxYmuzZQ?=
 =?us-ascii?Q?kqqw15PtYQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8e0ZImXQvdZ6oHNUDpCW6NhUNe+gDI4i6rBYqBGR3bt2MUsQjMCmIIf8nXneRChYaAqAkHBJ4qnH5lRGwM5g6epo5loeIamjc6wzumP5JwgBsXZE/2tEOjh8HFBbnJS7/OQ0B1aoATwVC1kii36yiN5D/AmRctDkfJTi2QM3t3NLEOO6KYB9uWRyODzZEqGWYdrrOmeeUOERvYMT859onaLvwBw/Jp/5CwNDuIrYtpikEB42J9mAGHAAFCgbgwkIzUmIa3rx2v2Umxpp5pxVhIMXgfffX5FNEDCDXq+KgIUgYFGqAFBw50IScmHoXhiPpXlj4ZyyjbhHIOYpLB9b7Kp4va4eizKLA5XR8NOgeA3MfqI4Q9te0ayQsCsO2Jm19QyheAjc2/UQnVlJ8PCS0iv/2w2sbrwaz8CPb+3ofpZBGu4OVW5VqB/NWeUgw6aqdK1FXSoyXcH5fWBlVyw65DTGsW0VDidsE/7A3Rk2bWfH4RlQinfDBOeMMQRC/uAd1aYbZG7Dn4JRntma8Lx+G5KpTqyxoJtb+uxZzX6iCJ2471h6XqhX1IF9KekhVkOc4JZ8HnDJ4pzG7O/HGHFOtXIgkXjmoPvHIaTK92y2/iY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a9a476-4c88-44bf-7313-08de590e1bcc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2026 16:57:06.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KCbtkVCbglfAZ7FmZoMWry4wqnipQBzrdGpO/OvG/n7q28ok1FVMk0jnCG30ehehy9qZ1J0DYYwgER8RFRjJJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR10MB7727
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-21_02,2026-01-20_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 malwarescore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601210142
X-Authority-Analysis: v=2.4 cv=H4nWAuYi c=1 sm=1 tr=0 ts=69710569 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=Fk0WoDt32--Uo3WLaF4A:9
X-Proofpoint-GUID: F4GrGlrhaNv7uBFlG6dpRCv07fDbTDiX
X-Proofpoint-ORIG-GUID: F4GrGlrhaNv7uBFlG6dpRCv07fDbTDiX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTIxMDE0MyBTYWx0ZWRfXzaLf3Yl0pWQ3
 +GItNb7ViyI6qxPYH2ZXhCVvkdxhWqVPFM+KFuCnPkPi9SoZ0k/vLU6dBwDCLW9rh56HO7FKljK
 cZ9VWrb6lms2YczmtiPQ7lSGXsxa7P4KqHnACIkWeOlquwLR502PLbPQjToxCogXpnp6YWTElZt
 kQyEt/pw2LHeXf076DLm5LA6XepUVLuBBqIZfCHlwOZS/nKC0lHewaXDsZi18+g9PNypY//pcCP
 DWzjwSLNoJpSiecPzUTT1j7rXOhizWMUerc9v2wZ4+BRhIoBWktRNzqYLsQmKTkh28tn325Y/Ty
 Wev0C1UXzZUvxGx8S5ianmeaeO+bRglqKMG7VInsFP/M+aDQThEHOQ0NtKVeX2SKlR/ZE1mG4cw
 qO0wk4VJjDsji7JhLzyCPME8mvIHp8SmiChCB0mH0maPhu0NvqbghGgYhge0lDORZN+Dz78Dt03
 9qag4GT2b6iGMtaepMw==
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0FA2C1C002E
X-Stat-Signature: rmjidi9s9xoyha9c8a93t3edw3u3igjj
X-Rspam-User: 
X-HE-Tag: 1769018850-227845
X-HE-Meta: U2FsdGVkX19OAdMMuoBf6MOUpr+MYDLPuO3ZbpP/mFlAy+bzG78/Maf5f1zidFThcUmUs2hjggAdFkfLY1hX+zK3rTI6IxpMvtKdCXsJj8Cm4ihYoSzg4Kk+bu56lG8RWX0jOpmoPQuSvSTtirCkXIRzpqyOqRyuqsfwHeBHDQVKpvheF2f9kqvSzqpWIb3sDncXrUvAvF1E+cAG7nhNn5W+PXzGD49hK7U9LGahVu4j50M7vnid6LI/986LPM+NeKZ3byw6AMkDtCmxtc7xujNl79BB53Cfa/a3ZmZEEsRzM+NGRjKG+OupQyx3/C9MFdzWUthTr7GalGdmsQhhVCKUeMF8/lXf8+KZS4+OLViAoSbsekMHVd2KEoQ9Zr90ugVBgO+xmgjstQ15V6vIltelBidjaRqNNjnm1dzrcylvYBPkDwkg4DVJL7PLqdo8O4Po6A4aEMhAymuC01g0vi1F9j0ntCZ3QStG/mMYfL1l65r5Oz0xdP2LEeXJVVmwTBdUdabvr5wUGcvzvLpIiTpDXPvZKomXiu5uwKcZB8WacNObnHgJCmNCQkM/6uKY68etrqj67li/P/DfCM/gTvyekrysvAiQdLLzPeJJRG5o5B1tDXfbUt3QX/kZpBYES4TLq+LPh0lvRm3hg3GAJWX/QGG6UD8yChPg1AxuOIMRMR2YoZf5in3H2KkULqjfzSz+bZ2sBULKR60xwrVHwJ9eXRkqY8bi6I3lQAMheYNRKP63dEYSdxQrY5Qpf9R7X6W9jtvsD0iTdVqmdJy1Ce1l+mMygNPBbjMkMdP2nG/EhT4eT5lBqVdIwHEIhyngFD7lJCi+ulN8y5LpXJvWyBUJpfXZY3lD5O8gIP7bBmaTYa66/5FLg8ZBqKWGvkczRYg69/+ItDUz1weycQ6XQUnGAzlWgg8cuHVgyU9KSkOW1gPlzL5FrkdtOqFAFGO7vA7CQjaIq7AKXdoHHDo
 ve7PDeRV
 7sekULHe1Xi4X9AVv3KH7UWmk0qQFp3r6iqkwQDaCr83As+HJlefX9nr8DSSi4X0VHyPwEWz26ahJDNQy1czpctxh1ZzZc7f1j8T2IOkJisqxLcVK65g4YFq3Luenc5ieAyEnnNwWWuSe5N1FodDLfPloANEBi4NDoNMj1MmbdfBmE8R2tNh/EJzssmN8W5PWLM6bu5KG0CWffa1NltZv9e4OO5z5WTRqsKJpaf+Lnm7pJrSGqlouGvgHAsbCih5y0x6PRZeX/Nq7i+7VZKoa/m8mdpm1uKHqtbgmQQpO+JBoXNne3wpc6oU9BXUk1yZqkmE7jR2341cjUUO7p1waBK6XDAEmP0i2vGbl0vxxUG4uPC3HS6Ua8JfPu9OVglZ9aeX2hASZnUIwvp+Q43Fy43qEQLZTGkRMxJYXHX6l9X1LSJM4l7zeyipHRyBKYLWR3UhRNGhORqEyuAV/zZezcHaaUuwDnvTcqzo3H5KJygVsnZ/xwuDtlb6fnanlLnDYQnlvtuqwXTlN5EXNdb02/r/OEAZ2/XLLyVmhQtYgvBPZ/f+rCYSDqFlkeCI/2zvGneDjOoLxOXQor724qERqeRGQmUh1V5WC1jt3RUPJnP3LBh3Sklf8xIxFXjBXXPtHeEgPW7yTR9loVaNIIskCR0agVg==
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


