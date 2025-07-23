Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A887C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 15:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E861B8E0031; Wed, 23 Jul 2025 11:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E56F48E0002; Wed, 23 Jul 2025 11:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E918E0031; Wed, 23 Jul 2025 11:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BA8258E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:20:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A48516012D
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:20:28 +0000 (UTC)
X-FDA: 83695890936.18.D67499B
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0724B40016
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 15:20:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=okdpISQi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jM4+kG9F;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753284025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dU3JwXRaqojaJvn26qh/2S1e1W8MurEapbCr1sRRDl4=;
	b=a8JX2Y2yEjNl0mleAGtxIhs2lEAl6EbMmq93qS+ejVEWa7OQR5O7IZzZXjkZyD9OEFdT0I
	O6LGc4hIRokSHIE3NQ9PVsnyGabkprUs4oB0m7cgNOWd/S2yPjO15dG1X6q4ZayjBuDZ70
	G9ZNHGRlxPSsgonOrNYn4OtYbXyUH3w=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=okdpISQi;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=jM4+kG9F;
	spf=pass (imf01.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1753284025; a=rsa-sha256;
	cv=pass;
	b=COGf/Vz9a/RXXeV3nrUqmfdeXft0cjKlE3ewL7nAYJ8pGAxPKH+TuQ7lqiqw4U8U1dJZLd
	9uXcJ+5qHQkHQ2efyylURvMx6zvlZP2wHaqrPetp+jrb3vhPLoo7SUTIM76onehFvkYjgn
	HOtOajz5TNCL+br2yM+/T1h4/K3FSVc=
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56N8NMwn024672;
	Wed, 23 Jul 2025 15:20:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=dU3JwXRaqojaJvn26q
	h/2S1e1W8MurEapbCr1sRRDl4=; b=okdpISQilnIwTh7n8TRkcSrFWS3aDpM3f6
	BhDtJ0ygkjI9YqxXh72OuxvxXDJXEoD6LZPG969F/DTnlsEBrIcp14Z9wkRlQDo8
	xU1xMku2iqTzCyRjYfzd9g6WfIi3dbD3UsF+etJ0e55VG5sJsoA3VAGZnl3Jcj8F
	NPtqiMY5mIH/O1R5MGULCbirzGcHpnLAblweq63B9GiJnWniIx79DutbPlw/CG+M
	xDRnfx9awB6zATN+y5QBArpLb+vXw/OfS3pt/X6jBbIlMaej5qPPF2STP8PAKBmb
	uZFywVxn+iN33gzeS72635leOFYs9wpm3ys1lg2pvwVJYxHKQ51Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2frp5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 15:20:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56NEtjDJ014433;
	Wed, 23 Jul 2025 15:20:20 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011003.outbound.protection.outlook.com [52.101.62.3])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801th2148-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 23 Jul 2025 15:20:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=O1fYeb23gLoAs09DKY07hcsqgERvLHtq1DuchUFVGGdeiIV7qMgskPzjn6jf9DFcFj3skRUWWRe+EZYaMcouMLQR2VzcNBLxyxtl4Rak0x4wQ5iIlr/jGX6dD+GO7Pme0s5x8UEqfr3gD9Bhq81O5O9XDYOMG2u01CAX0orycTt9HslW5bNeRBqGs3uLC8NoSbga2f+tVmxhp/DODWJz38F2tXWvOI+7gjzHh3kqn7+sXofB5b7gbyNI/4XMYz67WxXedm7WvaO1kjm/CvbGzKmCY8teQaYQha+vRe1job2oZootf6F6A0TH8ZzQJBQepkMOe2H8KzpQBJThmnf0wA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dU3JwXRaqojaJvn26qh/2S1e1W8MurEapbCr1sRRDl4=;
 b=pSMXtW5pC9ZFk/1JgtS/vnh/R0hena4tFN03Fo2tNknI+bjjnbHUJ4TLIDl3F/OY3NhV1utq244ejbMvWZc+SA0KvWglNiKF9UQIDwCddtySxKH6RAeqbP8Wo82SUx9mUpAOr7iGtb72pZwWsQ3K1+IbXCy+RDRvYJ6ubdD0jzwFPN/zEg8UI28bgO4ivAAwk4ILzeF4GzxC6U2rr7zLFr9ma/N+TPJEnjBcSbszQrKijwjJ9D3emCWSNyHiShqHfyxg2m6fg7jMH3HsUjJYiBiDZs3W2XCNve9Pngnm8O1S5E27zmusc2jDv9eijRWCRodBTv8TI8VePQhduK52Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dU3JwXRaqojaJvn26qh/2S1e1W8MurEapbCr1sRRDl4=;
 b=jM4+kG9FzAoRHMOaMaPvIP1TWU6IeZ6Qy+SZ7wgXcEKFZC61onfUaWlBrIYDN+u+u+LyYgz90KzkV1RvAViXMHtZYsonzpsDLO/M3nXsanXZpUC3c0/GGLm/2qEk0uLID3PCkygCPcWtTd+PVSC30I/mvursQuT+f/Dj2lpLrOc=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by BN0PR10MB5016.namprd10.prod.outlook.com (2603:10b6:408:12e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8964.21; Wed, 23 Jul
 2025 15:20:17 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%4]) with mapi id 15.20.8943.029; Wed, 23 Jul 2025
 15:20:17 +0000
Date: Wed, 23 Jul 2025 16:20:14 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] MAINTAINERS: add MM MISC section, add missing files
 to MISC and CORE
Message-ID: <2dff6de0-f34a-424a-8b2a-61b420404451@lucifer.local>
References: <20250723095823.21940-1-lorenzo.stoakes@oracle.com>
 <abbaed17-955a-44cc-9593-10c1afa4c6a3@lucifer.local>
 <2f5512f6-1f0e-4e54-b9c3-8a0501843bbe@suse.cz>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f5512f6-1f0e-4e54-b9c3-8a0501843bbe@suse.cz>
X-ClientProxiedBy: LO4P123CA0020.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::7) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|BN0PR10MB5016:EE_
X-MS-Office365-Filtering-Correlation-Id: 486e8b26-5519-4639-59b3-08ddc9fc6e0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?AxajMm/ES+HCMVWco/vWQJgy3W78F+TiKKuOFznBu2R7+DR1+MhPZAbvFy+y?=
 =?us-ascii?Q?2BgUgFGlvMfj75Hp/jhQKzR6ls0LTXuFX3nlvT0vKrjMrZRzZL+dNG+M0xvh?=
 =?us-ascii?Q?rJN/QgxLxLJptOuXGiwx9ikB+ENNx1iKaOYRueDFqyxbVtlJB6sV++7uQNVR?=
 =?us-ascii?Q?PjxBIVfvjUv8EfNZrNJjSFu4adLJjLyVJTZYwYwviIw5ojlOOEd1V0sIUY7K?=
 =?us-ascii?Q?/TY74PZeJS/AdnS7JfvTTE9B4LqSTmjcKGV0aR1ku6YyyJX9w1yTe74uuIow?=
 =?us-ascii?Q?VWX+5J8c2RFU79ofjhXPyr0+KHysgN48KUvTH9EVMgFZAss8UbBbUtKjw8S0?=
 =?us-ascii?Q?RB/HOvhT47B8CoXjRJCtJJFkIBrGHMGZCblGCEY9YKvQEjwUKTc65+ZKWBk+?=
 =?us-ascii?Q?RdLuLCSZup4Rw4lq8gFpSL6wvTvN2How6CCgDno4z4nPEIiqBbmTYFFVNhyM?=
 =?us-ascii?Q?QKZd0lcCWH5nAkbGgQPvQpnP6VISqgmLfZIELf3WduGEDeJ8PNEh90txQqXA?=
 =?us-ascii?Q?IS1vlwc2viao372e52gBPlMDAFfky5e0alhV6MDg5/8VjIJMMvSWCzowT7Wi?=
 =?us-ascii?Q?7/9DDhloBwqmyez38YIvuKfg9hMH0z7ptE5p0HEiOwgTYklhkBiZaRs3tvh9?=
 =?us-ascii?Q?xoiJK0sdRGn+e0aSSdjjKOA6jFDVLZc71Ukctd4KVAckvLXHnim4hJc9pAhb?=
 =?us-ascii?Q?vo4xG8LmU7GyTpKrr+7zjV6NIrqt23hxXAXy3Itl911GJKVCV6w2XserUlbR?=
 =?us-ascii?Q?3Cnn4ewkx5JmBhoDFc2lWxyls7FtsANbq9ZXKVHoQSum2hbmRCTkorAdZyRT?=
 =?us-ascii?Q?vZoLpytRAPD19G/aQvgNRAlD60iebE4H3t9qIywxYR9RDnjzaSuBxSG+O6d7?=
 =?us-ascii?Q?s2teiqjRigFzFlanpN/gbqw2bruIeXhOmQQvCjPb6vYPG3ZCFLBVIvbiEmaG?=
 =?us-ascii?Q?Mpa3SG8bBdxgUQ+7eJrW0E7GW47JXvO614esSkCClLiFeny0WMaaPRrr6IkI?=
 =?us-ascii?Q?QdI0V/ur8/URJusu9RRT9qyydYIIabjfLRcUMA+kzgIOpQXIxvfh5/CtARQD?=
 =?us-ascii?Q?GOhVlhxithifCTtNS1Lw3CqguKZ7mytS+25MfEEACvfOHmXBQJMen2vRPHSH?=
 =?us-ascii?Q?2YKJO5tifg4I1c8JWbLgVhMSsiuwBMAn2XkPbqhnzwikqjXeyppNGUP1WsDi?=
 =?us-ascii?Q?/8bqIPnaIBbjMjIHK/sjcdol+zdiEaifDgz4KwG2T8sMzxzmQqZdLKI8C+SN?=
 =?us-ascii?Q?or/1HM/wmHHqLHr9AM7h2lO1V6DKmWkqisoQnAYAuOwk9oNOfRTJUlq/X/BQ?=
 =?us-ascii?Q?Dolem1+hZOShbSQDbcPZfLWjz9UkM8SgD/jh/Phhg2BIJf5jzHda3pFnqd4+?=
 =?us-ascii?Q?PV3Wd1bAvvB+3fWF8lPxG2wLBpEmQjVIU2MD0pCOTlmq3fw6YQeyMTdCpZOu?=
 =?us-ascii?Q?3xyF/biCKAI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3eq5VQ513UTdhkWSRZUGWTr3+q/hbB+lFgbmKQ8RGWsrGnc55xpCTNM5h4Ow?=
 =?us-ascii?Q?Llp+DMRCW6PTY1y8otWFs/yj7Hzr4QnuinoO7Nss6al/dhKlMDUg9z7uvfnp?=
 =?us-ascii?Q?stwIX+Ymt1i/ULmCXkzTOxP72FHYJAC8AQHUmhMSyjAfR/pvnjZNcjofd6rd?=
 =?us-ascii?Q?GaGToOyf7KqNvqfakB2Op5MG2bx9TXFGUVenfB7cU/9k5uYg185nTWQnuQdx?=
 =?us-ascii?Q?PrObLI17Fbmg6jy/N3+FaCxlfWLjVVTOXrlWX0isirPRrvKb6YHxSEjo8Gft?=
 =?us-ascii?Q?piiB9VFsl1DZgAa+xlm5I0BG/N7udzZNJjRoh0YVYNXRl7KcWc7JHiE5dhiQ?=
 =?us-ascii?Q?P1ccVQmEjx7C4YxLjOI+BdP5r0RkYYSNOZfs3h1TnoDGDi59U/7jt0AtygHw?=
 =?us-ascii?Q?dlQ313bMXCiRvbp4HnkCPcLD8g5O628VjpSn7DGNuT3JpVp77fkrnnPeDQyJ?=
 =?us-ascii?Q?AOgBf5tXN9GvMsrPT6pRsIMJIfYf4Sj/AlMbfN0Ag2U6PWFMGDGtOUG4TYwA?=
 =?us-ascii?Q?MTSN2mqby4oazvlFEYhRuex08s2WnXJL6Z2xiRHTHmPMcAeYpyYBLFvZ6rf0?=
 =?us-ascii?Q?6T4/Cfval/0BL+diGC9zhDVpi6sJS3FC9AmB45gyTH3vckA4rqGaLqzmmpWt?=
 =?us-ascii?Q?bGgrNgMRHDXeq7rSfrD0xol12lM0lwFaLDroZ98U89aKXN/jQFMd1meIltc2?=
 =?us-ascii?Q?gFHF9nEA4R8VmF0css6qkDX5Lztp8IIiqc09pAmfg4kCh1KgNjT6kwVniHGn?=
 =?us-ascii?Q?PSg3WQ/QFpW3hnVKAwI2EKOBbJ8TVqj/rADm3uK9LWHbli/eOWWqFmwSIK/n?=
 =?us-ascii?Q?I5qdKNZpQOcpevev/4nmjQD5pf0DWmHEtmU4kJ0mBhyvxL+PIwsmjZ4fBBGq?=
 =?us-ascii?Q?xOlcdnGEMZXvLH25+vlftva5saAtMcV6MNzv/3H3LoMbVjSISGmzqBduOxDx?=
 =?us-ascii?Q?7O/Q5lqQ9VuvUQBzhR4KoRmPj82j4TPwsfav0bjl/3pryitOlXOpv+9uBMb6?=
 =?us-ascii?Q?r6o37AOjEH98k/WXhkyb0VJQicAET4k+GP/NBmG58PJaLw76H2Q52CEDgLgP?=
 =?us-ascii?Q?A3RgpgKmUAZVrGrZTZKZWZurX+6pVjifAmT/jDoQqVnOFqS1K+rMbUYwKX2q?=
 =?us-ascii?Q?aI+wY5O+pi2JAFBtWuwA6PcSOvKNOXmX0hhL0gmnVItXyecRAL9P81CY67Pr?=
 =?us-ascii?Q?olrxg7xZaaxl/9MELbt2gr1nccCM3IFNeMYMkH3301NFwLEE8qUyBLdEpR42?=
 =?us-ascii?Q?3cVruv7q9OVCh4evS1OFDjJmLigdXvelKvP12sotahmnLYsZXusKTnHQOJw+?=
 =?us-ascii?Q?3TOMp5rSbKmcxR3eBUyhUHsGg6Wi7tDy/vm2i4SITD8K8/s7jcjQCOg58vz+?=
 =?us-ascii?Q?TEbDJBzgl+8IpTnul5onQrgaPsfXQ4N0uujWrwguBctqVykSmyRe3eefe+5G?=
 =?us-ascii?Q?H7FgDHmteDjiR8fJptTmsQhRWM1gpOYEAX+bQI67aQoiGjUAfq5jLeE3Do43?=
 =?us-ascii?Q?RrjuiLF9PeTeBgYyRxBXDeReb0Kk9j5DnZDmuXswOKiyz1XqS1QtwHb9LrLc?=
 =?us-ascii?Q?r67Uxx/ZqxTYiM38XVfK5ulV+c+VoDjX+U7f6qJfc29uuo2LDOsVFjiTRLBH?=
 =?us-ascii?Q?Aw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	MpDfjx8ETXl1I91CF+pgP0JsA8y+6RpJtciy42Y3HBYV1nIY+Qs3IWm9D4zjMFwz2DTRLl10EmPIvudZwfeSq2Cy1/9yECpodqyonVSVQ6+locgSiTaNKeAqrxm47/JTzrGmbfydMvOiS9XtVd8ybHzLVnsmCTO2JvdaX/eQIwAh64BHNVmYS5rtu4y9tzdRj8W1uwhDeGQtdFFVIl9t2EQowGSSaK+1G40Uq9PuTl3YOKaHyYzlqIrlIDGxSkTkRLt3NZsSw4L4B33pa2qa8v2X+VoGfGRKTbsA+Ukolm0FUqMbMqOMwjl9K5wPAdTTffWI20dTjbuifu9LCITp2rKSpBQMLTVcxrUJGW31+e+V85b9zLzQ3OesS/A5+Bc7NgW6phkKOQvJ2f7NlcU5Y+WYEuOoBX9OVBOQrb4936jvZBfCLdo8PEoT9YTfiraSnmdBTK+21vYjSt3yNHVJ57WLgnVSb6kHrJGJ/in8L5gFlScudr7y8BWpsLuXpyJ5w5IK3TAQLlx+eY/edZehgqjyD6G+8wgg4igxs2PbHuHb2CUZ8bOztIZ4p2xm66PT0IRfuEv3EwzLfa4Ya6+1I03yUv9xYUMlg9lCDlR+rbU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486e8b26-5519-4639-59b3-08ddc9fc6e0f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2025 15:20:17.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZP1x1M+YI/rGingNOpPFY3nKoYERXZyB2nLMVnahYgqNAfw0cLc4+J8NjJIBx54E4zaHvAOI6J04jPHKfLTbBNWb7fSJdGo/QumGYQBvA/Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-23_02,2025-07-23_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507230132
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=6880fdb4 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10
 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=oNUIkQQTeta2rd6WHSYA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12061
X-Proofpoint-GUID: 3-5QBHS3zBD69meklTfBkmyqlJHwOFkt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIzMDEzMiBTYWx0ZWRfX1xL0wLrRDKIk
 bfV1cGWIEHSTmJdQj9KhyQqWTY1qRfVmcoOTwy9s7qKIa2PEEERq77HAZBSUVpPIvbtVkKoHCl2
 PYGKcKmwbUlvczNDjwYm8djrrIBBkcaClrKMKhEsmW1pqrByRgUWTfBSx6s34dBTHcsohSB1aAm
 KnBSbWkBiE+7nzjZMXLJ2HXDJA39sQOnAYXjrRCQpWYrWm9bFTd0TABlg2RW8JQ8SygQSJvkM8O
 wiKDNNM4Bmu0A7OtI3R0OcHNtAXADuDB7xt0+jnFxBCxEoGaBcFHaWgm7si+DDO1xYPlACyH+lM
 sR9leX9J1dW0DfSXRcrDiswyu1RobMH/sX7V/btSBSrMA8kA0t4ozM1K8/svinRg3mhbwvvqH/J
 hmru5b1G61qe3k2/rVwwjWrruRk5XABNFXuB9E6IYYmdsWAIH/Vqin+92EnZ6a/CcOvfX26y
X-Proofpoint-ORIG-GUID: 3-5QBHS3zBD69meklTfBkmyqlJHwOFkt
X-Stat-Signature: t6bsy4hia44a91qn3w6nrb8ej9s4ctpa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0724B40016
X-Rspam-User: 
X-HE-Tag: 1753284024-36356
X-HE-Meta: U2FsdGVkX192k0jI0NxeKsnmUwG9qXlc8S1F/6V/QW4otDlL024oEMYyMI6Y1G+zRCBwXjg0wpbVH+9ht7cf0qVEUrbn/lrr4msTARy1SIlvGHKG0Yz5m3MZ26QY38OjOOP2PnvcOIVJ3bs1PvnYnUbtuVixcB5Xz5yl+1O73F+YWP/YZmFm+IIOjyybnaxfD6k9SHF3o99SQykzCLFJ0ib0fWXsQ/5CEzP1hx8cvRtUoOjC2mUvD/1iM+G7toO+VMNFq8zAMpqDo1JVcvyajc0QWE92TWAZz86PsdCvWVyiQ58W9YMTW393gfDnXGBGgcnp6C0BOLpbdJlPT7eQKRlHsIiwysSWJ52Y//1+NTl8WVreNOBIc05wXTuLQqYOdW3fEvBj3uC+cR35U0uuPHsAGtZHjP0dV4lUlvdKPngIzcq65fIjly1BBojpwDWC6HNXFHiIoQkibM3VCy347lQy+MNMFTOvDSl39nWdIu4iFT78+Gcg1MNMAIISdYSaTXVjnVJKdLPpavmn/NpIv6kYzEMLNBq4SOHrKkPXjlERoLqC8/vt1sJEeBb/DSJTnm//R/x7QmFgtM+Mgxma++BQmXvSk3PtfNBWlMMT+sYGpnqsdBGJbSiwnpnmwTRKwgRSVQsJ61QsRaAHaYadXJ2/qqC10KSpBVHIUi1+uPfpAUzSvbuuaLPWCylwI+mnqu+knRqfkfqGHS5QLPOabCveSvBNt2rXH/CqmcRYJcoJnSIron7JkqiBzJIDIZDFl2cdcUtU3DcEdhmDTtWJCtHjvSxiMp/i8DX9Mbz6Z+D1HTwJB4M0kMvu8oAqoC1WNFy7tpqX8Wo4t+Ug639mxy5OxCSn6fRFKfE1p2IuAalHQJacOW736SxmHm9yx4KVNhwT2LOXxstmvQZwiXU0q2PXYMYFYBJiULZirnXpK3yKmxODG5setWeeJkXDt1n3i+nmN7n2YmRgCd4CsFX
 xjz4/ioe
 8Wun8Xqoq6lUCiSl+9wXbWRx6jag99d+QdTDf2ba2If+Xxgv+hMcmjfLOvkzv7dtUrXPSb7IbP5xnpEIj3sGKOCNZdt1fTKBx1PR7iYZE0E8gN/6O6mENdhz8P7/88RDDaANgjZcn7J7PlTrFgtdfhk6X3WFgsCmaJdu+K1a3+4m8W1k57G6xJ1te4M/8bM8QjfMhrsnvZSc4z4p2GOmjxOjj5i1tTKCmgSsniE88VSIMXvTjJuyIWr4WL5Kfs0MqPq2o32P98yDk11YeyZU8rkKPkooHRZ70QUPHLOqaIT8s/S7CoEnuLOsXPHqAToVzGo2PvK9RSAzdb0BlaafX5qALedG5570IQzsVQ7Kcayi5zKkf51oHAeuipKND2YrZUeXdbmmAAcZ+bwyPY4f5wctyS3DVmDNY5Olkj6NgJ62UzE0HYs6uWo8AOAfgT2mkEmmoJMkHWooJL9+0p2kHTuAAv66BuUBMrmhGdQABPPb9AVG8uYPERqv9Nxh69mzP86/om5idLEIH/xAALI1RZe93Fqhf/9+LI/FoIiBjHWIzVkpwXbPNiYC+38AJHVrq3+HffFSTgd4a+Vi3ZIcRLPYKrZaxb/cMSXvBzFM5tucEEPtifJb/2yuorH9TnKArcySeLXZFd3nBsD9rqiXQxGIgX3EsgpOzMtSZn2h1D5PA8ISl+dkvJjJ0ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 05:13:05PM +0200, Vlastimil Babka wrote:
> On 7/23/25 17:05, Lorenzo Stoakes wrote:
> > Hi Andrew,
> >
> > Please apply the attached fix-patch removing duplicated header files
> > accidentally included in the MEMORY MANAGEMENT - MISC section, as pointed
> > out by David.
> >
> > Thanks, Lorenzo
> >
> > ----8<----
> > From 9a94ef4511f6d0cb39f5edcc963b2aadc11febed Mon Sep 17 00:00:00 2001
> > From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Date: Wed, 23 Jul 2025 16:02:27 +0100
> > Subject: [PATCH] MAINTAINERS: remove duplicated header files from mm misc
> >  section
> >
> > These are present in other sections already, so remove them.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > ---
> >  MAINTAINERS | 3 ---
> >  1 file changed, 3 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 5a9d4c57add4..5a6cb44635a2 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -15860,11 +15860,8 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> >  F:	Documentation/admin-guide/mm/
> >  F:	Documentation/mm/
> >  F:	include/linux/memory-tiers.h
> > -F:	include/linux/mempolicy.h
> >  F:	include/linux/mempool.h
>
> You could take out this one too as it's going to SLAB via my tree?

You said you weren't taking this, I assumed in general...

https://lore.kernel.org/all/a3f60194-3498-4dce-b0f0-e16e706f66ee@suse.cz/

...but from off list now I see you meant you were adding but not removing.


Andrew - if it's easy could you drop "include/linux/mempool.h" from here.

If not it's not a big deal to have this in both sections briefly... :)

Thanks, Lorenzo

>
> > -F:	include/linux/memremap.h
> >  F:	include/linux/mmu_notifier.h
> > -F:	include/trace/events/ksm.h
> >  F:	mm/backing-dev.c
> >  F:	mm/cma.c
> >  F:	mm/cma_debug.c
> > --
> > 2.50.1
>

