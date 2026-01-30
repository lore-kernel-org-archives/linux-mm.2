Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3D2E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E56976B009F; Fri, 30 Jan 2026 16:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC9396B00A0; Fri, 30 Jan 2026 16:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C12A66B00A1; Fri, 30 Jan 2026 16:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE606B009F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6844E8C36D
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:56 +0000 (UTC)
X-FDA: 84389849712.21.3D21D22
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id F342B160006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DjjgQR+y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Jun/OfVK";
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GggqnMr1CdAEFqCqYjCEDFfCefwKB68K6xk+1Y1Dq5U=;
	b=oxwwQEVAfbovi1NiuGNyd0mEz7bQ7A0XIJq/jomd7TDwutiHYFqbGQCIrE96c0BKlFDYFd
	nnZggJaJXz6GvK+6BCQ9+ZPWmaJ0QUfp/IZbZVDBk45hPMcxaxGOLTaOTPLQ2NBy2cQIHw
	HvFobmDg2pgrBpNDzqck6BBCgEL7WUg=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=DjjgQR+y;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="Jun/OfVK";
	spf=pass (imf08.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806853; a=rsa-sha256;
	cv=pass;
	b=vxslSsVCrA0/EUVpJk7nDZQQXu0Qpf660TscGLRjJgcyJa0tntrmoRN+semyXl+ObB9TRF
	kwebFhR9+VYUGn1T/VLGfmv9Aan3fHmuOn0f/sk2NEUT4MNTDEUfnVZoj8gcVXhVa/16dE
	AM19eGOWxZesHaGEyHoIDCo9SDzXyXc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDPhf3910766;
	Fri, 30 Jan 2026 21:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=GggqnMr1CdAEFqCqYjCEDFfCefwKB68K6xk+1Y1Dq5U=; b=
	DjjgQR+yKHW/Mg9MNLAArotMmEmFh3oQMjaTZaj3E9OqhEPXZqGIImo8zRlYcfPo
	pVl4rBlwNzJPqFp6tuqAbwPsPp8CSBYBFL0ly6RZ6Pv8q2yi23rwDjoWtdgZyPJ0
	kO6+9kOEacoPnID1OAmvyg+5b1TFyffkaSDA7LL1BJZq0RGr8XKGhyab6ERtET9U
	cPW8tdmsZT8C3PygrS4n14KUjOSa7Wc5tZ5yKFErTAwb/e6SUpj0ITIjL5b6KN87
	wk4gEZeFeNtgnDeBYKvbdSMiAtBSJtINeC1hGDn3zKaFS5fBNAJMDSJgxey6yhC4
	iQtKf5yfatKgIwcjmr4gRQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09pm67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJV0Fd011872;
	Fri, 30 Jan 2026 21:00:43 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11010024.outbound.protection.outlook.com [40.93.198.24])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5h1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=KO0n+BTGK3KrFVvIalmTNM0yuxf+HJFxjVZsDz75QW5qUdTjg7ZSFLrXlflRRcXWNZek+CRDJQqJHg1v+lwzFEznNjyoJgzpxkSDX4r46cFBhwrFaWVXBaifJkT8ZGjy5xn7NOawAT4zUOFKwWQov3+ys+EJz0SfpXE/tR56SVETNcxSTQLTTduuR8ReDUtaDkdegKXrFlShIuN8T/o16ZQvaNt2IBzdXDZ5veSahZL0k9tjaBvpIQDlMXZ1NTKPVjD8dtVoYq//cFnok22hCRG7QHz+udXaksy6b9caand+ZRf7+0+8CsX/N0iWlcmriZLFzr/TPYzPrIuxFm4SWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GggqnMr1CdAEFqCqYjCEDFfCefwKB68K6xk+1Y1Dq5U=;
 b=V1HXk/Bo3BdW3e+WGisHr9FkON9BKsRDhqRca4qkqD6pCymBh3FKUmlGBwZo36G11LsAXcsODiR5XJfKmarmiG7ntQaZXkzGHKbSKhvxuMEVWmeAN2dpG5VHOh/oVVdgNw5+tX89Yn/BarZKgcHm12QWy98dgdFibCfkIcekh6G8mS2UKGGJ6ChoBdcGLBtDYD8UJHHMleHoBlpMuqVQCi7Yityc2WJsX9Tnm8g2A0ViGSmre4Bnit3aQQjLjyRdWBocmu8v7mSDIo00OqH8qlbLlGZX8G2D1EzqLNE5OStIS9zqG793w12d1Xg23uYPJC9Xk3Olj/G0J3s43dDLZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GggqnMr1CdAEFqCqYjCEDFfCefwKB68K6xk+1Y1Dq5U=;
 b=Jun/OfVKWPXxiRbKf7GUnPC8tjqX5d92qnqE2Qo+akrl6VIGhCs9DFsr7fPAg0LPGX/a6jQtkVy6nrBsWI/mVqwKYbKVLAkl9xJxlc02HUlC6jP4wpvmErd8bH0SCYZR25VEmPNAtzuLhDulYodYWS41Oe7d+HW/05zxAPhzWuY=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by SA6PR10MB8061.namprd10.prod.outlook.com (2603:10b6:806:43a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:39 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:39 +0000
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
Subject: [PATCH v3 19/30] maple_tree: Remove unnecessary return statements
Date: Fri, 30 Jan 2026 15:59:24 -0500
Message-ID: <20260130205935.2559335-20-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0272.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:109::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|SA6PR10MB8061:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a6b3e21-e3ef-4206-f437-08de60429f33
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1DsKWZFITXO/lWQLEcZ4pGOTxdkdh+J0cLok4T82gdILOukLRlNvwaHbXZYe?=
 =?us-ascii?Q?pGTmzUgI3IsaVi6xAx4iNp/gc73ba5YwP3Hz9pNi3UUq7xofFzsur8ysqCPk?=
 =?us-ascii?Q?XXb5KAWAj8drZzBjtzgvIjgMqWzwBOeKJNDZZWl0UVQS21fYSgi7etn4rjtd?=
 =?us-ascii?Q?uOgWMrtGDT8sbBU1TOmlPV32O0KgeaZgs/7Z2hJbCdBrx/J2A1quK6m5sEod?=
 =?us-ascii?Q?6I7MBIWBCo7USlfvt6yCMp6rCess56vDrLOoODwDHqWVezTjvaLzE8Y3I0G8?=
 =?us-ascii?Q?7EWSCmv3s3t8YoqIVoc0BmI+t1D6c4a1yf7Q0nwo+9HP6ky0ndkBtzUZVU3k?=
 =?us-ascii?Q?HnVnZSJYP6cRloSNkbnSN//Cvy7/0tk5rE2AR+LXAQx3RNgA6XmCd18aqLCW?=
 =?us-ascii?Q?Ac/RfF0lue6SNep+OGrM67TIhIa8ueCZV+j2wUsWOEOheJlO+1NB4G061Ebo?=
 =?us-ascii?Q?BggsBgbwue8H8xihyJbwu12pBAyekDToxqT2Au12an3yt7sFm/EauVbD2frK?=
 =?us-ascii?Q?yvrQI6m205xfyHp3ctw+d7P5Ifebl2NaHZVrhquNo+ZUPwPlkAvjQb+lQdVE?=
 =?us-ascii?Q?pSUs9qRU7TWeH5TH/XlNf5XodQNXjr/RMxBqdB+ZaVwo/R058J+IsABrdz1C?=
 =?us-ascii?Q?Mw79FFJE7tTHnGC6VvsWpPey9Z9XiQH6wPS4EdyK6uV6IJShoNjx2GiRelt7?=
 =?us-ascii?Q?WhP95P6FvP6x4+M8Lg81yEWzCcpjuQZFp/wXqZWq4HTD//xJbVpkVRM3u8+L?=
 =?us-ascii?Q?hpIbeyQx78GMOCYzpQhMwLPJMCTpN7+Ts0QlAzdPWQydQuFN+TeB4e1scPt8?=
 =?us-ascii?Q?us9LD5RCSZTmZGgV+7SvOwV7sCK3c4yFxOj8Ghxr4awmmi+POC3vKfGTzA7e?=
 =?us-ascii?Q?RVJCgf52fWsYBoLM5KpGg2qccM/+DWtUGsPLHl6RfNfbt1mu76gvRp5cVm9G?=
 =?us-ascii?Q?ZObZW/i4kWBaYdZkUN+ty6/0dmY5a+hnCA3H86TezFcW80Ckh1hb3mkTo/zb?=
 =?us-ascii?Q?gOPDSMGTfV8Jns933a1vrjQ8Nj1bJ7De9bYOGzLzWrDhNFIHKpB+v/TLNF+U?=
 =?us-ascii?Q?3kNvr3sfyP7OMU2lJfDSOYH8WWTl8goI9HaZymXEJO8UBYT2dffW5q1sPSK4?=
 =?us-ascii?Q?ikwqZdmyg9AUhysk8In4ma3aXcstpn8xMFrKUufXQpe/S88cw9LpAP81T+nO?=
 =?us-ascii?Q?fYp+sTPA5XAQaLky7qPQ4KM74JURV7go9nBijI7MkaWxZT2Vz/JZbUNKRKSN?=
 =?us-ascii?Q?YwOT+SnnfJACKKPue4uGmvoso6HXB57nmx7ANSF21FsngBQNvaGaY/8ypn0t?=
 =?us-ascii?Q?81cV/R+XLqTV/9/Vv79oSTdtI+Q0gxM1HH4XfpcBIC3gS+NgGE9H3cdc3mPo?=
 =?us-ascii?Q?nMAa5QICBw8GaO5LlILwi6gB857jPKho/VdVMhJmQWWoUVgpb5avi5Uyc6Rf?=
 =?us-ascii?Q?F6pw4jCKEPdo+9IrSEexNdNYoN1FaBUHboByqdTJ3EnfSKzLEOO69JMgHAhR?=
 =?us-ascii?Q?prtpp0S/sIJIoLD4xtzBLPmkNBm/q+6th5/JBubiPrHmpkudUC7kIcTAJAxj?=
 =?us-ascii?Q?lyXuA3Y6poMXQ8J/k78=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?62ZNCspy7IaJII16Z/OGa5FUSXVfKBhGt2C+usM2aK8o9Nmqxxq06t0lD0as?=
 =?us-ascii?Q?rmv+0tkRf8qpvI+fy8v4tKqAUxYw7UIgH+EEBiV/+rUIOneTvkSPH7A7o6NH?=
 =?us-ascii?Q?Hg2lkq639qiwtculzshC9pTLEjbM5vCqWMWPeoWz3vp4cO9f/Ku2EfdtPtEu?=
 =?us-ascii?Q?5f055l9f9MF3Lg3/yeHqsnqAQDwLxtVGnNRMwtKmO5xuUuxZcY9EenaiY3w3?=
 =?us-ascii?Q?CJgpb35sAYgpIJ7Dodrvrif2+qyT+576pYZI1PT5W+DTGSVc1VdF3NuTxLJc?=
 =?us-ascii?Q?BHJzExhvsRwBgjw62uTjbKP9mhvyQeDUVrDbfvCl0+oJpeL4LuV/ijNq2Bc5?=
 =?us-ascii?Q?wxy1tcssRye9Obmlk5ijFKvM92OzNnVwHYnFIGYb1UIxmf+mD6zcfLlIvzKJ?=
 =?us-ascii?Q?TKNY48FBFNErWRZAwI9A8mWYMm905guFCA/dFHl1mSxbE/NsR/j8zGGdWqMi?=
 =?us-ascii?Q?Jqd/l+NWyObmPHqfpaeobKZ5bdg/iId2jWwtxtmAZFkNeDcOB06+GsCNNhc6?=
 =?us-ascii?Q?3FO/pGkHGN2k4J9HnvbtEQwjz4Ba0MdPzlh7A6D7bReWsunfImo+e6gp994m?=
 =?us-ascii?Q?HItN0df97eYr/is6wpRDGc/2hOnekNoFyxaOyAErfWyTFc5couaKB6/6cNwD?=
 =?us-ascii?Q?ihsL40xxKKjdICK0XSj7gnojS0IOZPXG+b2oDiCpAplPJTmNrZVkwkuyP/aK?=
 =?us-ascii?Q?mYg5OBQQA9HYFMthudYOZAD7Yy//othbi6BRx5eD5ga/OWhd3rNPSAXWnz29?=
 =?us-ascii?Q?hRMGZcs29JdF2OKkntcuMPg/8GmCavFZJDJAzfRfsydE4T+AuNKMSmQdCjHO?=
 =?us-ascii?Q?uIxAZUZMD3oYzK1JccYCgJTjSLPSUH0AM8FK8dekACGGo5TpyiIoswDrBYhf?=
 =?us-ascii?Q?FLX/fR4BgqAUJrJj2+Z2EWmG8KRQzM7Xq9JUl14ZwJWtdG0PC3hhMJ3LRAVh?=
 =?us-ascii?Q?m8ZAioC+WkysmXMrij6O8snfbAKKOg4OsT8tCC9yf+12REUKpRsKQwzlCfoK?=
 =?us-ascii?Q?lPY3Y8MUs3spvQukdKVv3Ys2P9bsjL44gLbT1yW8yEDOX0bIAnO1h5/623nF?=
 =?us-ascii?Q?gtl4TtR/nxJITKtekSo6i8+nOhT8VtYLLO2jN8eBfa50gsxdt6SdWTnzFZri?=
 =?us-ascii?Q?f7GANGM+KzhbqymutTPkMZ86eKZJCM6uvfc0P+EXAUdmQfBgWAxpWQn1ytET?=
 =?us-ascii?Q?Ok6ReijrfISyAGa7bDX4iLYMJwYRZxV2L3L7ob+q8Yw+ofoJR8vc1cg3xRNE?=
 =?us-ascii?Q?P9+aUQZYlwk/5sl58ZRM14w7q2C9AezcSRp8z/WTzVlswOMt2Jtu7LbPT8BN?=
 =?us-ascii?Q?McAAEuAAbj5Zs6wRJlhAi06qKG0m3psffJD8sIZCwxjIHRjesJXNlM4WYKRB?=
 =?us-ascii?Q?unF0bBusICt6SBU2/kJHlOy6DmL72pF1rSo9WfDAVj6OZE8xufAw4JSQdl1B?=
 =?us-ascii?Q?DBQD36usofTZ287HqnY+39RepU96pBDObB+/usq69PxGlOf9ECxQzhP1FB9D?=
 =?us-ascii?Q?vEkyFGpZRLJSECYYUGNRJ1olttgnpBzNUZgQSpBw5w8WdjkNihW16OyflEXU?=
 =?us-ascii?Q?Vmn5e6YOdnujlRa0igHBv0liYX5EQS9B/mNY8e+JqNnmC1IKRsd9an7FwUz6?=
 =?us-ascii?Q?Njy/o5RdLUFa7CvmQQYKmoT5QxtQZCmW0FGUwLaxpvlnLObTHBbXbFtHvWaL?=
 =?us-ascii?Q?+tSqonYp/CRs5WSOY8OP4XQdFsci7/+iWRrBiZwrQvZHiErqWJ3kS/P/47vZ?=
 =?us-ascii?Q?zeK+17BOaw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	kgHS/oPw1MlHS0hs4gynYl448+baqGhfBd64ccI/CmNHjN40qma7MINzH6bCl2Fm+8FJ9TQDNT8wMC4utEP7mCsvgeLpjE/grcsEhG5Q2xZj2Om6QKnon0Fg/DncUHLfjdEtijwBcmXoAJPLXUNf9mEKTG7hNmR088S8sXnY5sx+MxFbXW71MWqo/X7SwuQkFUzaqoBv/xaQDv4QWnaCp1t5lexVQI1gdgrCCmv80unkYIHzhvmf7nEoPxH/s2gIFM1/h7HobreaUjFkvJGJ7PMSJAJNu7vguOTXmNPfulFkK5gVTTHqEmwuTUj4Eok8guVe16BM650Zeg24OC8qVrweClcZpaA3oErC+q+b8ph2EjMJmRydt9uvsKXLNHIbiHwAYe2aJR2h5U+Uwta4Gq5Nh+pmV4WG848eImygBL774Y1T7vocHxRA5mVR3zgqkgRpY3l9FjqnPaAdnB9XxNu69ol+kBvCeka2058GX54scID1YAMIz/O7MJINIbv/gFP7kcxFhkTnZ2KwV1FtK7ZnjtM9wTZmCyJe8LC2gItFE2eIyWHrFwFAzUX6NKE+590HexhjpZO4+JmvhYXDTuB5zLpUmSa93/PvAAsSp8Q=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a6b3e21-e3ef-4206-f437-08de60429f33
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:39.0091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ILQUJbwBTaq/1zQ5x1EF1Haa2HSK+iD42H56ET/834InvVdKy0YeuNcUYTbr2Bps9ZBE/FS/EyqrzgURvkedPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA6PR10MB8061
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: 6psFSQNhZ1JTqxNkvpA7myfs9ey7BCqK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXzp/NpypPoeUw
 SACykloyDpqvOFFnathZZv8y1MqwsAhLYerzhVNMaox8g3GRjJghNVb88ZV+orTM2KsrxLL2azy
 fvlOPPpcPwiDiGwF2Zfkks8ekDuB30kt5UVNtneU7Iy1iwzn5EYjKZqtOxmfYQf2CJepz3zxgxv
 BKap/PjYrlYGHZHrW+GGwbNjeSWLQ96BN3PhuQETA7CbcFDq0DVGL7TOg0rlx8B3sE5qPyaEFZx
 NM4ihYGFr5wJskM+gTRdj/fQ97E3GaKKjlntVPJu6Eb0gDiv0XPxA8scIRJ2GyHinlcV1D2ABVB
 YQjvd5j6D6Dn3P37cYVCCZ7LRwDJ2yQokBn6MK49E+mJ5q1wYSckFGJPsB77hHv6oKDNnyZyTJD
 4dD0LqtT7w5gxVI1e8FBv/jRHu2UO0rPIuuPCuFLXLG54T7tUaSdlVuOB+1ko7OwVmaxPs0pUBu
 QOOBo9IfwJY+AAISmBg==
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697d1bfc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=k0M0yfqvNG3lIp37doYA:9
X-Proofpoint-GUID: 6psFSQNhZ1JTqxNkvpA7myfs9ey7BCqK
X-Stat-Signature: xb49oqiytuxwtc17rrk9wdfkyau6xnwo
X-Rspamd-Queue-Id: F342B160006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769806852-771926
X-HE-Meta: U2FsdGVkX1/atOzIYj9S6WWc49hoBGjAsUSNJUhnA7gEn5a1/UCWpU6cQktPfv2x5MvpNaoj3UKAsdRMRLwXmS1aDy+jJo4bB4PnFM4bLpegyAfuqgQvyvgZ1MdkcBI18THpqW/YGX89nUrDf6RlrjQ9c1yXfzGJ5FtIjUyTnb8FAmeNVMkAix/7EimcjTEv6nP9c4X3U5JvMFN+4ulKlaXIohdfg2L4WiN0MTv/SaLsiWPVLMMbKK7DBM6fCSSKaoXNMBvx3Yvv5X2bqdHj6bvmCE6DI99cTIHzdrDa9fRfJEnRJzPeodyOWYIQ3RTcIgQ9YFFQoRwDXwP9OmJ3neZpqbOlryNqLSmHyreBhQGRSSm/909M4sFlO5tI6b9YKXZEuclA1kUmM9HKEbwmg8cGB6JJU/IH7l06ty69QsvZy4ZmQNRxaN7KiDgBaxpW51kLIzY9+OdO1j/n+ayabf+GZDhQbfJf2RPquOETNBq/I5Hkn+x4QJn52/t4UNmOYwGNE7tNNNKI/wu/N7nnNQh/X5++t4DYw5i6m1VmLbIqhusLKzZ6tzBG9wPce03HOL9QZXaY9VOjKaJY0qLYa1FvqtTxplu/uBdWnloJHQZxRsM2vRDNncqh4uOZpW52AEFCT91hFRgoOnOE/UWh31sGoPB9bsKCUDb/AjAR+NVpwJsgMgDtedo2MVWel8+iIOJzsfRJX4mk6dGR/fAQ/5lMmKILH6idHjwSYT1fI8d4kx8lCl/wlXXK21iCOXr4OtJHDBzQz7GawKGFeKpaS8j0I0duyIn7C3BsXLyHRJpE0h5XL0AYMFGTmhZBl0yTuBnXWutPnKTbO0P8BZG+ym984aYoZ4UtD5kqXY9Zw0vq6O+afDgI1ezSCu3a26y3M9qmH7K14sTGXb2UStuPQHASqly1QzLpkka7rap6ailKmW1ozGJ0qiwlg5Rv4GMcJDZVF/5Im4WLeI4lEA7
 kwvy4p+8
 EiZhHQU6rKM5D3pX9vUWMzf67On4jC3lVg3ijrqsPc50DbjuRbrHAMnwqK64IUWSHLqzEAY+dUIK9UoabXowQ2XsvRik34ti44ebwpACKN6HJc+ASoQ/m5VZBtUoZKPiN5gOlBZTBHCjY1iFfbkl/3MTXR7GjqJGIlejXGpiNfauUAIuG91z4X3EeX3Ztq4qjlEzXhbWoGGqAeLBTVt+mi/Ej1LfIVSb5vn4P35B85gI/TPQo2Bemx+DUm7XDbUEIEFrmsqnuKYUmUII+C5ancKhAJnZMOwb60xWnOhGZt+IOozGLWc6JKWIkpMHe8IADzzPQZ5Q0IhU6AmM02BSJ6Ybw1sXYToo2xJl+hPqmZWvLWYgGvx2bgL61rg/AnRZPCYvfdRuICvTSglT3DkJdbqD86y//Mj9EOe0i2wIVRK6V0JksFZB/icP5yn/3lYZBkTMcCwkA2XqqJAmzccv6P9Md7OEnC5bvGIzD76ghjqqfMca3divh7zBr9dqFA7NYD2LylyaUtFnn7JDx89wAPQaZg8Ric42iZghZs8HJ51dlcMV+D1ihJYhQcQC+fZXtCvNHG/OsALhRq7Qt8mwzp40hbOBI5lVAvHB/pZOmCk7OXBEYAmx5LvnISqFCp36ifGG2CnnTJYkfRHdx0QCaEl24SY6cCz0NxIIkzTcJehSMdtXBWxdZ4Gy3rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Functions do not need to state return at the end, unless skipping
unwind.  These can safely be dropped.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index a10f71620e732..4a64b4f37aeb3 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -3294,7 +3294,6 @@ static void mas_spanning_rebalance_loop(struct ma_state *mas,
 	mas->offset = mast->l->offset;
 	mas_wmb_replace(mas, old_enode, new_height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3718,7 +3717,6 @@ static void mas_split(struct ma_state *mas, struct maple_big_node *b_node)
 	mas->node = l_mas.node;
 	mas_wmb_replace(mas, old, height);
 	mtree_range_walk(mas);
-	return;
 }
 
 /*
@@ -3779,7 +3777,6 @@ static inline void mas_root_expand(struct ma_state *mas, void *entry)
 	ma_set_meta(node, maple_leaf_64, 0, slot);
 	/* swap the new root into the tree */
 	rcu_assign_pointer(mas->tree->ma_root, mte_mk_root(mas->node));
-	return;
 }
 
 /*
@@ -4051,8 +4048,6 @@ static inline void mas_new_root(struct ma_state *mas, void *entry)
 done:
 	if (xa_is_node(root))
 		mte_destroy_walk(root, mas->tree);
-
-	return;
 }
 /*
  * mas_wr_spanning_store() - Create a subtree with the store operation completed
@@ -4215,7 +4210,6 @@ static inline void mas_wr_node_store(struct ma_wr_state *wr_mas,
 	trace_ma_write(TP_FCT, mas, 0, wr_mas->entry);
 	mas_update_gap(mas);
 	mas->end = new_end;
-	return;
 }
 
 /*
@@ -4263,8 +4257,6 @@ static inline void mas_wr_slot_store(struct ma_wr_state *wr_mas)
 	 */
 	if (!wr_mas->entry || gap)
 		mas_update_gap(mas);
-
-	return;
 }
 
 static inline void mas_wr_extend_null(struct ma_wr_state *wr_mas)
@@ -4378,7 +4370,6 @@ static inline void mas_wr_append(struct ma_wr_state *wr_mas,
 
 	mas->end = new_end;
 	trace_ma_write(TP_FCT, mas, new_end, wr_mas->entry);
-	return;
 }
 
 /*
@@ -4437,8 +4428,6 @@ static inline void mas_wr_store_entry(struct ma_wr_state *wr_mas)
 	case wr_invalid:
 		MT_BUG_ON(mas->tree, 1);
 	}
-
-	return;
 }
 
 static inline void mas_wr_prealloc_setup(struct ma_wr_state *wr_mas)
-- 
2.47.3


