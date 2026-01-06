Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06CA7C47BF2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 13:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5372E6B0005; Tue,  6 Jan 2026 08:51:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E13F6B0093; Tue,  6 Jan 2026 08:51:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B31D6B0095; Tue,  6 Jan 2026 08:51:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AA3E6B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 08:51:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C823454F10
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:51:50 +0000 (UTC)
X-FDA: 84301677180.16.63E6E50
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6271820003
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:51:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oCL2aS41;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n910Ip3t;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767707507; a=rsa-sha256;
	cv=pass;
	b=eC7S5/Ya/v0E2ua/myFFdn8zMQ/dFXDnco/02/TLzsFyD2cDfRQLO9/odLwjR8xw7oBf+I
	6AW6cVFIQ65jgaDAsCRWCXGo8kbKk1awWKCwCSFD8/WExAwY07PYLfau7pVwemJdk85d2R
	9jj2PZsNH35e2YIr6NbZXZDQZnwBtLE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=oCL2aS41;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=n910Ip3t;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767707507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4agBBHjEKToUu6kHlJQ+JkmVSn+0RA11RtdixBdHcs=;
	b=4HF/XzbUkC3Fbbvmp7/8xoKC4uVyMCKWaNOjAMkwUYsyDCV+/YHSJwsZx+VkqF/ZLq+Ct3
	RAEwToxn9JxIPOKu/qAi/SqdXQPYqcvf54ZOKerZxiiUgjfygvdpiqaOp35dGp9NhEmKGn
	MdvIAIAnH1hDPARBYJNKz02fMnVlLJI=
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 606DiGGd3646191;
	Tue, 6 Jan 2026 13:51:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=V4agBBHjEKToUu6kHl
	JQ+JkmVSn+0RA11RtdixBdHcs=; b=oCL2aS41djCg9avw5rQXGpd071V39e0yQJ
	fH2k7gHILneVB0hqOEbwSyYGyOb36JA6c/hoSX5DkprxBVXWIPA3+6bqQJHRQ6Mo
	HGKQ6gX+49sGEnfrqzjYkdV40dwKwTn+uB/+x6Rbjn/l9QoQqo4KSEjfc12HcUHd
	zs7J86Yur1ZzxLZZCeQJAVyk+dRmL5bJaWN0DBOhjDHAKD9AzcP4TNpCfaNIAqSO
	rptewbaVM5Pw9g9B6knVOiTDHAGvqryikPOiDKezyWrRBtLmE3ci/l4uTwSGOg15
	9d0K3CNDd/6wS7THK80nbvHsuBoJ126Tnus2Kf6BF1bzX2kuafaA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bh3hq80a6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:51:42 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 606BpMIH020928;
	Tue, 6 Jan 2026 13:51:41 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013036.outbound.protection.outlook.com [40.93.201.36])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4besj8c2hx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Jan 2026 13:51:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=j3u5noPlyj5yTciHkSpvhe07xe5PysLXw3mqv5/nKQ5pm9ou00zox33Ng1CCaxCWAD2Fntyi6tEleLkk5XpQhwEIh1QQcVYN2eBHBBlEsgWVA7pX7tbioqoCLL829VMU0QoyYyP2tZjbXZk3FDvefGGDFJ3hDBDjs2jBfvOnG+BJZoUbkVoSGy/4fGA9c8DuYFRk7iX8uBjc9XQWhmQfb5J9Z7MXhhGLDcz+VLRkNEdq54XyhDtufgpq5QF+nApKV1S24jBXFhSrNccJQuIEVbWnRLtAV+nQ8XoeAQhEmPzkZ6SSlOOvm8r+w0MS5Objiz9uS288EyMsmz15Gi1NFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V4agBBHjEKToUu6kHlJQ+JkmVSn+0RA11RtdixBdHcs=;
 b=psVhM9lhnOP2Q38iOYGmpJNu9t7GLR93YahpTRf45pLFc/8v1ot+BREEpbGJ5J3pUwM8NUwg7TJrdIvgDmsFlqdZ/rVGxz+5h1m26hPOAWtADibtUjKQQ4LCWq25bXYTadIrd6HuSARWFCQopwPG+FL2OyNJ7YmyllXm4Nr9YrUqjlaANSOCaERIH4WkuGYp06Mnd3ynoRLPdmycDaN4wQMfUsq50Yh7JNOEO1aPXCA5PqHLj35RaH2XGmEyImSh9xEd+UTsbcNE/DntFgyfir+gqx1mENxuxP9mAbVu63J+HpGN/BYwjqQSaDU+6HoQ0O83yd/NkUpUSAX27VKETg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V4agBBHjEKToUu6kHlJQ+JkmVSn+0RA11RtdixBdHcs=;
 b=n910Ip3tqrqTk+3mnF1jNOdmVp/iMCKqDpA2BWEgOeTMbAOdPjMEQMmzSayvV84at8ZLdSuEAqZcjEFQSuZ7wyUW1RCHzu0eulhNPDMpARGpgPfwJvLLynuZVNYIxpCnvo8zfv6Etzf3A/ykK95E6rmnZUsCcK7T5yCtaZvLu2c=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CHAPR10MB997699.namprd10.prod.outlook.com (2603:10b6:610:2f4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9478.4; Tue, 6 Jan
 2026 13:51:39 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::f3ea:674e:7f2e:b711%6]) with mapi id 15.20.9478.004; Tue, 6 Jan 2026
 13:51:38 +0000
Date: Tue, 6 Jan 2026 13:51:40 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>,
        David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>,
        Harry Yoo <harry.yoo@oracle.com>, Jann Horn <jannh@google.com>,
        Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
        Pedro Falcato <pfalcato@suse.de>, Chris Li <chriscli@google.com>,
        Barry Song <v-songbaohua@oppo.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] mm/rmap: improve anon_vma_clone(),
 unlink_anon_vmas() comments, add asserts
Message-ID: <358a6bbd-521d-4d82-aee8-367026ba568f@lucifer.local>
References: <cover.1765970117.git.lorenzo.stoakes@oracle.com>
 <3acc90a8613d5e2ea8882d60b5677228e6fe624d.1765970117.git.lorenzo.stoakes@oracle.com>
 <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fkgm4eqdwymljueszhsfyvm2zksc6x4vagca2mlnpl7vtawap4@d7obev7d5hce>
X-ClientProxiedBy: LO4P265CA0037.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ac::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CHAPR10MB997699:EE_
X-MS-Office365-Filtering-Correlation-Id: c40fd2cf-1fc8-472d-2c26-08de4d2ab6f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?loeZl2s7a98FQuWu8HTzBSjHRavGcp2OAiwGZ4hLC5y1Wfeg71iHo8+bfVnf?=
 =?us-ascii?Q?DZsBD9JxBglhPIpBfmzvCwH1A0TFvQx/LmSL3eVEXNIjGZ1KIwg6E8UKCfkw?=
 =?us-ascii?Q?HYMpLAMFtt7ef7+6YQN+AfeDYpC/VpUf2lmfYA3jzvY3jFGi3fnua5M5J+IA?=
 =?us-ascii?Q?CLqJ2kUEtCqg0CGmX8YBcxHQ8b6qeDUSVYaOtk5YJ0sEwDugQrGy8lQC//l+?=
 =?us-ascii?Q?c4HVMh7F++ndtRnr8cQZHE8mPKJ0kOEK7RyDlQVajndSAlGxjPd/9RsKxGdQ?=
 =?us-ascii?Q?X4Z3NTkcRam/bZJlbmQrd5AWj55Z3X9TMM+bQaOTiLWSU8CnWmO6Jarm6GtN?=
 =?us-ascii?Q?zv2/dkezC0aWK6uyMJ4mhzi0VpzpIEtyxXRKsadFj/7wtLTtjGFKt5ddCjlE?=
 =?us-ascii?Q?+Sv6MdrqkmCbzEFHIYGw/Prehxj/hBEicAfak59JfAkDEoFuvj/IUfKC2Ur9?=
 =?us-ascii?Q?sgTcKhiuRTouoXOW2tf56kDLYU4FHmrGtV6lMXbq4O9Z/4U6Hfqwo5icpSFj?=
 =?us-ascii?Q?P7Yz//4NBAnTYKREnXC26CEfqVTzCoaSgudg/HnHDiWRNyYLmCqXhz62W+xt?=
 =?us-ascii?Q?ABEhNmP+kl08KprRFxT2eBFn65ePYovItVXka2xLh9BqlNNqFXywWe500nYS?=
 =?us-ascii?Q?HQ1Y/s1gqUuMt2W7lMg7DxpyRI0KoLdmzXHyKwONjRO1GVSpZC/tINvAmOqq?=
 =?us-ascii?Q?jdiOY8XySeHC//wgY8Ft8s1y0wh0PEhtVe5aOSINQJNVmca4qAUWzVlAHJGv?=
 =?us-ascii?Q?52OqzKorqEgSvbqipTm8VBXwBzlcDYfE8zHofDf4ZdxbwgCy9D/+4W/GW8xg?=
 =?us-ascii?Q?6LTtPn6uLQgu7Ov1ZvtRr/DexlsXZmCqObPzCjxeHSeCQXgqrEZVbTIaBrRK?=
 =?us-ascii?Q?bNwwz1CHpqEVAhbAGIgA9vhKMEDK2SSWEB/8tD1k4J+6zv82nrPHEkepBm2X?=
 =?us-ascii?Q?sKZR0akzZq4RxkGVPTTdGk21n6R6v2CdCPj+fWpDAcI20UdTVBVD/8QFbKdX?=
 =?us-ascii?Q?mdk8BHjrUgSH2rhxnQMa9FZvMwN6pAA5K8OzwPuh4AtASHqQM3rxrgOwWEay?=
 =?us-ascii?Q?Y4Nd2axhOi9P47wbIo8y+dQ2ujrjmz4DOoDPks58e+Oq9IXLAJIZTCGh425d?=
 =?us-ascii?Q?P8OedwTNgCBaE67MzU+c/xiB8o8TBwkqyuAeqbHt56MhOGRr0jD9Rdf3noxz?=
 =?us-ascii?Q?E1wrYbQXrY8e2XPBR+FjDRkoAjYjpL/gQOJrYB6lMd9ibhCIrCo0IjXWYSuC?=
 =?us-ascii?Q?CEC6wxeckBjryHoCPQwo7ygLTpLBzAP+NsXlh0LD3IMTpeO1YctALJfh3UnB?=
 =?us-ascii?Q?roPvJKKPvyoXOxYQ6tRCF3pM82kHcShC7mCpWFRUbJSCvtxlOaQcH/ssIC9D?=
 =?us-ascii?Q?qq1UeJg1p3Cwsn1HktA+pdkRyu8wGYlT5RqeYIg/sKLh/Pk1WMXdZNmEByV5?=
 =?us-ascii?Q?7Ieg3sORXj03a3KzdEbKnifPJBQRtHDsiaLbwflDOIf/MwV4wK2DCvht47BS?=
 =?us-ascii?Q?2kNDo7zDdlyxSDY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?LvXLYpJjdOK6nb19XKRQTHr0pKZEFpS+6ouGJni0AJxTiqpLsplF9TE7NOoo?=
 =?us-ascii?Q?EQwwsfyW/+Bxs1samiy1Gn5Jt7uL3VPsOPxeAnleB8LvHD6gQ8itSxp/vzmL?=
 =?us-ascii?Q?0/kQEKmNB1dL5mZLQ04R497YhPptzxRhAHqImc8pwQr/Frh5dv35lN2WMuRj?=
 =?us-ascii?Q?tC3fQ/JzmqW9oIAzp02vaq8ud9OjmBNUXPRmr3jmpyrGlz0Vb0tF7RzJVCcK?=
 =?us-ascii?Q?/2rOK4smARJZ0dHjBBlZlFoZMu5UTaMxqCVW6o8izMV5ng0RA7qEzEGghcwM?=
 =?us-ascii?Q?KUR/ai5JT7W7KsximSmZgei6vMVLKmPTo/m7gFpfzZXatEijAxsTCN5R4rAd?=
 =?us-ascii?Q?3x9i2/yZ1Rn8XYcNuzd8tdpK20skHEkwEk6LCcFvTP+IkF4kEELCiVKwL0Rh?=
 =?us-ascii?Q?hZKhWO/kwoK26oQsjtVkmBnVniebVuvMvD7w15fkkYybmXvRzUAko6f2Te22?=
 =?us-ascii?Q?8Mq5SIxZpucKNMc+mzqFJJcuYn0ZvxuzuRcbiN0Nh3OyppeqrOcgdiJQs9Sf?=
 =?us-ascii?Q?7W2DjYR0UEPB0c9b27GOol6Zl/PR52MF72iU05K47YsskpfWUsdkuxeCrH2u?=
 =?us-ascii?Q?jovpoYmTroqsBUbbgZ/fKLCenmfH0WraYIiBkqRz1iYkqTex1yvi9bM1g49l?=
 =?us-ascii?Q?nhuzpmrTWOcKs9QB3xPZkrIrjCb03ggAAJRid90/PeVHs9lO09sERDeYBz+D?=
 =?us-ascii?Q?0AdoNtPpxJOvUfpvk9AVPvazJ2ADS2JNU5VXIallQoX36BPvdTGG0HfZwW5d?=
 =?us-ascii?Q?dBtwJKq18mtc6iH8eYrLoz85em2Fq/k/MzCUPJ5+3+5qLG8OkQ5lyFqR8FMm?=
 =?us-ascii?Q?pGnLgH+p8//6VLm35o9fQkX7GGGjCicRohaklawedbv1nLCkB6oD4r9WyC8T?=
 =?us-ascii?Q?Io5xto9gCKjPo7KuQwhIF1sSfEFyVwtPaT4gFAyX57wuNE7CekkF0owvqLYH?=
 =?us-ascii?Q?jFNRHHKg/hxsdlTuID86d6fAOXusKdN7bvs+LXeXSeG7z5qUzriT5nxo+tgt?=
 =?us-ascii?Q?bxyJN18XAlgbcSwh81DzjyHyYNmsoSVtkHAFiYZjxDGN6B0i9UDSZS0Twn5X?=
 =?us-ascii?Q?QwvWv5/dkW5rAUxBNGyDCm+GNGBZKG3G4Ab1So+ap5UbvF/hZvelqvpNblwR?=
 =?us-ascii?Q?VONLWziqMF07D+eaWVB8Az34V1GTRjFfYA+cexc6eOCq60Lnyp041HV2ajLn?=
 =?us-ascii?Q?Sxs/A1qaO+Jwft/E1i3gMfOE4Ng1ShtaA0cLhtXAR2KZSC4cgBUNQKx3QhXf?=
 =?us-ascii?Q?wj7s6Re4M1ZB52H1dgRezRYy2BR5bjMq1MmvNi0Q2QSFX2aa9YdcIzJbxJtG?=
 =?us-ascii?Q?dQkGoxktIcdcdEKCB7+hyazsTkrO0I7k2aOMvBmRtQvO/GmAY712xn+DTbz9?=
 =?us-ascii?Q?VSsZwQtxWOiJOmh/hG82HRZNriR3W4lVmJqupV694Ls4U/fCVQnA/WvsX0yv?=
 =?us-ascii?Q?q9rVPCCNIdgaLzPAT8p+4w91FpeKj7LEVIQN1fkfoM7epCyM5rq+FQmxjbCR?=
 =?us-ascii?Q?wtlL474VouEWQ4GkNM/gOzcYG1DJu0fduPqq5RmyZ9nxNQ4jxtLzKsrnLbkM?=
 =?us-ascii?Q?uO0HFJiqySjPNr42ergvYmGMXgiLKuILnrhba32oIhHVJswFTD1J+fdjurUR?=
 =?us-ascii?Q?fj7t2GExY8uCCmcQWB9+B1Shkwyyt+hHgQMO2VUrdaV+eVfWdEw1EAH3avfh?=
 =?us-ascii?Q?QyKJW0SH1Z+1TjjyhfK9dC/Qhazm1mGpYEqTWAqQGPBiH8Iq9W6ksE1Q1R77?=
 =?us-ascii?Q?KwUr/RCMB5J0f1N41doTBZjqxM4C8oo=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	7AErYc++ZYTKFIB8bd8Mb7uMeVLlTgm75ulHGihBI3jaUK59bUgk8szR1a+eHnfUcK+DkTjhYk180lnnY+v5fsLdMjE74H3JEr3uexQyzwe7aEnH3rxQTHDqXQ3XZFz8xB8js1gs43QQsWU2xcdBJXVt0zzp16Mg+Eb5K6Jo4f/K4VMAhsCOBYBBrf+ediHkqHYDNisT+nOgnDdz5wDmGU+AicUk5JADkNYRaZ0JHdhXczXx1Xe+LOjK6e3Xhe62qHSTQ5yQKpaRON6adzX5p97zmeVg27njKu4huVkFputW4WPTHX+46mg6EN2o/z4fUqhn4c/LGE3B9XTYqwUn9NUa39kR1A6tb604PLvTBwIKWrHg9W1ylh9fm6gwGxIGUrHcSdPjfe/r5xkhxkoQAv7ulDpcS2AfCw9RIvVni7jfDGe5w3gWzCBy1/Jp8kmaKBXJL2OcCEEf77zfwh9Xv5M5aNuO9StVAEXQIp47QnUD1U1y0YChGsSBjMYmNas73tXqmBXiJYCAsMOq4tQiaOzQAvbnxoZrgDvj1jH+IaTNh8SArbmuAig6cqrjxtRVgcvON6jYGWG6v/f0wTKFkAV9jNoKvsFP8zUgKn2Pf/A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c40fd2cf-1fc8-472d-2c26-08de4d2ab6f9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2026 13:51:38.8370
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MfxB8GnxruL8qbs/ySoSw7v7C8MXqqTvMIo0yfk/FFTZ9T3FoOZdo6UUen1hhnQ5BPMu+v38MrLgvwU95UquRkWHRtFkPz//C0Up8XEfMLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CHAPR10MB997699
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_01,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 spamscore=0
 mlxlogscore=919 phishscore=0 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601060120
X-Authority-Analysis: v=2.4 cv=Zvzg6t7G c=1 sm=1 tr=0 ts=695d136e cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=yPCof4ZbAAAA:8 a=6zXbdAcdbj6q05AyOaQA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: zM0XkPo9Ym_3Xo7QSqAXPguq5w9qndeg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA2MDEyMSBTYWx0ZWRfX89mXhtBzELXX
 9HJYkL/M/Q475mqbsg0BxzTXDfV7eQM74OV7dA6/VPEEKXx05ejpy+PgDn/CVM47JbxWiQd+xqn
 dIPG1IHmYPVwtikncAF13FRYhtVMGbIbsKIRwoj9rm2G6YJ8wPCpQylgp1xyFFv292F8z/J1Kxs
 HnGMYVU59u/jTQbs6jNuUBh2dmu31A9sMn2kluCB6Hr4XqtW+KO3xl4P2ii44jzgtmsrMdHUWBr
 XFRzW3Vbu+uVpfh/RsAtmTlkobnKtihJIoXf/nK8B6oP98BtaTje2uq4wttHlBdRinmXsJUR4Hx
 5C+6l//njq5naMKNENR79Rh9wVFJnqiRFNWLJr4WbYnpdQQj1eO4oXtLTOJNPxvSH+00x90Lr4V
 oOkkP1g5JIz67wKABaeYa+QD1hDoJeFbEA6PPqIk85KJCoGgRg2NG7eeAdGAve+B/p3YsOY/yrP
 VIkB2HJav4qZXIuOAmw==
X-Proofpoint-ORIG-GUID: zM0XkPo9Ym_3Xo7QSqAXPguq5w9qndeg
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6271820003
X-Stat-Signature: efky84dkxfu41j1zgpzq47yy9cerdety
X-Rspam-User: 
X-HE-Tag: 1767707507-753097
X-HE-Meta: U2FsdGVkX1+nE6JLibNMTSkQZZjUpNj8Cd3dA1pdq2CHCg49WQIH9mRh2JMZQbyXYQGUo9EObTVyG+FT1MAGFkhmjkMxzNf8bbYQVXFd/gtFy274gDuNEB2i++CXnAH/7YXOiwmQDjiDWxaI7nx5FsbQF2LLEcir4ai35+T6o5CPHMYgkiDzb1J0iLQeNlQlQVsoZBXQgGxvJuAD+FrLeESBYxmyfGGrEqOIjDOBXpUWoE54KsBxipwTekwr9NlUKHGrVHMfAd7okTdcB+Ow2QpfY6bb2H7wZzPA4tZzztO4/XBd2qC84sAlvkUe1CVTYGmypmvqbKmTUViio0NZ7gDyZiCSFv+Yc55IQAqkOgsiY6FRkYrCiYT/9Pa16uLlzF62AbaMf/jWiuFzNsK66ViUVIXfpo8TlpQqlt//Ar2DHb+tS4rPABHUkwut6gbMZhzvrZ4V52t/GHQiNChI30XMTBE41UaxqMHRk+WuOfMbBLnWp22VSooeSW5ORJH3kuz2FCrDSoVf9xRdqsTC6Nx/vevK1KE7Hfy0KeHeVkEI6PJ2ZaY6gP1nuK395fSV8p+hFRVpPdyfhr7PIA9fM5tu9rELkFwmiAYefM7GzgXXd9kAfppCTp315WywDAiJ0wICzHX8Dl177k7aLVoUA4CykkqgRoxL2PwUAuWL6Tj7MM2HHq1wdyJQVL4bwa8nXO7UHXwcRX4vhXbSXbC6EzShZ4d53WCxy77ThJZLuErTdWgYh+BgquRxhd+u3P2k52fRm4fCQUpod8UrMv08yD0TgZ9Q6yChdr9bGO3xeb1WrxUZsUEAoqzCaxU4FIKCwLS2mPmoZnbJeEBpkHOJvAwDsPUDu0wuc6CJWAfwzStl11Ce6u1cPHY8i/4grVH77BVi6zAyzT3D6AIhOUnp3JTs/EnhK2c26xkBPb/t0F4GvllBREeTucG8mlbr5fpzB8eGawsh9I/4wPQUc4T
 lZTSayHp
 JzelNkHDpAeRojldelQDexmPLRliN0cbC8jnz9JHI8PN1hnRRJ5Qgz3L0BAN5RDvQGnlHiete1AQMNt7N/DUwNxtaltAhA+HGigyZJoITP5HXLLKCPo4SN12RSu+6FyhsZ7QxXTNxcnTo199dwnq7yWapgxNvr0ajn6QkjQ4fbnNXNvf9D+8H5Zj5+ZccAyohNEVVGN01BANSRQReNbJ/SkfT2qWy1FwchflBPC1WePOMkPtw8RGtZ+eHN88QD2OqvmR3KE0v9FNQC3mqC0K+8irX7WTz9kRhdFdHeMZ1bcTwQN5umFWWtFbVVz667bHZ1/biyVaF0/wtAhaJtoDTytKCrlEeNAZGvJrfPDiZ7anML7GrerT+Bz1cHbyiATW4T07ond7u9JhWMejVN0EJJ6S8/J3OTXZGGw30yW7R2xgVbEXYlJoqosWaHjRU+Gh7/zhxdLax2q2fO/hboD/9zEjHbcYsC5n61IUZM5qAEZWFoz7sHk6S0eZQLcobCpjaO8YF7E0S5HR6Sx+yCs0Ul2l+skVb6fz+h6aefta0COTuggWRihw6NgMWOYkebQXHHXfJ15MU0IeEGiY0m2QgnLSgyAAoiuLz+gxjasfDj9M58Kj6216Qy0z7ZXEScgw7Y/OHkjg0Vp87eQzOt6n/O3BJ5Tr0l/Nx0Wg12LojKBnVRWw1CB1BYfMm24u35RE976wL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 01:22:02PM -0500, Liam R. Howlett wrote:
> * Lorenzo Stoakes <lorenzo.stoakes@oracle.com> [251217 07:27]:
> > Add kdoc comments, describe exactly what these functinos are used for in
> > detail, pointing out importantly that the anon_vma_clone() !dst->anon_vma
> > && src->anon_vma dance is ONLY for fork.
> >
> > Both are confusing functions that will be refactored in a subsequent patch
> > but the first stage is establishing documentation and some invariatns.
> >
> > Add some basic CONFIG_DEBUG_VM asserts that help document expected state,
> > specifically:
> >
> > anon_vma_clone()
> > - mmap write lock held.
> > - We do nothing if src VMA is not faulted.
> > - The destination VMA has no anon_vma_chain yet.
> > - We are always operating on the same active VMA (i.e. vma->anon-vma).
> > - If not forking, must operate on the same mm_struct.
> >
> > unlink_anon_vmas()
> > - mmap lock held (read on unmap downgraded).
> > - That unfaulted VMAs are no-ops.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks!

