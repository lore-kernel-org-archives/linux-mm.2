Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81FF0CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 09:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C92A58E00C0; Tue, 26 Aug 2025 05:46:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6A468E00A8; Tue, 26 Aug 2025 05:46:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B388E00C0; Tue, 26 Aug 2025 05:46:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94C288E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 05:46:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38C115AD2E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:46:40 +0000 (UTC)
X-FDA: 83818428960.19.9B4C537
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf23.hostedemail.com (Postfix) with ESMTP id D08BE140003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:46:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KE6qnDwH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fQt/L8xb";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756201597; a=rsa-sha256;
	cv=pass;
	b=J+p8QIaIDOUGhsLaE6IY6Fg96LLseHoC5ig3JSBjBm+GJ0QbK2oZ1OfNLG37mMIqsRNnjL
	drdqEIx/9keAxxMz4QUSfX8fvTptnOOKEwagfHy+9+zsdWpHFItz6Nhb5tM3+BfwMAotJu
	Btro/Bpa2CEEKhiBHE6lbp29s/3x3+c=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=KE6qnDwH;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="fQt/L8xb";
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf23.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756201597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0q/u7kJf+d2Ygw2Ab2xg0hFXmaP4PBy66PXh6rfrM6c=;
	b=sIcW3s0tramrwX7bgdCj+1Jy5wyVZn2XXGopnRFJpiqlnmH4AbDs68aoSNnncF5hyMYx19
	KU5wHDRuUGk5o5eZDCuci4qLx7Q7ll03gAuRxrCFPXNtF5FNUTegINH7ds+yoV0HKwRM7T
	xZWaTUOPFhKPz5Y/8SJEwfSBr2fHntE=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q8lsHt001264;
	Tue, 26 Aug 2025 09:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=0q/u7kJf+d2Ygw2Ab2
	xg0hFXmaP4PBy66PXh6rfrM6c=; b=KE6qnDwHAhUs/T6eJGi3Eyz3ilV7yJu2EB
	Wg+UlhRlWa74Xllkd05JjguVTEVKo/WnfFoe9e+SYnQIk9/H4rQueiHC39NkQltt
	67FTBpsEz4GyOx41BwSWg3SLAc1y+7KJxtjN1XTn2r4Q6jng66vU709LkfGtWIgr
	0WvyCiEvn1YpF6mPHDZSXnr5bTwrxaJ3NAHB+3GbClUfibHa05be+4PzsKZvdQAG
	oGEvO52+Vj3glWeLVMCkvvTzEC1iQ0bN7ug0TAqNy5hx6mwXd0ZHcqwalY+/Gosc
	F3Pj8y/5HgylgRXRCh5vfN2E/UqocRUgziMFVYbQW+/yCQCCXSxg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48q5pt44wf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:46:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57Q9bGIm018982;
	Tue, 26 Aug 2025 09:46:31 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04on2077.outbound.protection.outlook.com [40.107.100.77])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48q439d1mw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 26 Aug 2025 09:46:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IEM75Pr5fKcYrcgnZ36JsgDHTTEnB7J3dI77pnHN5eaBFqm/28PMSHBTlna7MdLqAgpnj4M2MG++nE50a341FGBtbAfjo9h3nOMyZ+djintKe+XL5nAsXKP+zcGK8EvcaNgq648DnWwbAdgzemDhdv6AkXlCONsIQI2CB8wpQz9A/3eZnu06X6/Uo6fw+96zzY458ZVeStm+jFfod9EGfeU2z+oGy8lL9CmdahSOv8OHcK51eKbBeXYd2We2y/qMwP/62mJHZt0JvR4Ci5vFHN/E+5U5akrY0HLsSe2HmRVh8kwNbctbeYQd1YAUMH21xR/62XHNyC0l+moRCtaDxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0q/u7kJf+d2Ygw2Ab2xg0hFXmaP4PBy66PXh6rfrM6c=;
 b=Q5YOLM8YEumtK+5WnBePXr2PjJMRjBK6VAOMUmjYynmZzewpKfwBoYFGRjSjA8J+LhQ7oMuXwa2v3fvw2Ua0Lfq1FPtvrN7EhWxItT2IAcH1zttNn51JV+shfgWyttttIaLC1y08cNPRF2VnaoRfacGbH0Ypr236tD7YITRUeUrYh/YNA8IVChNOwjMWKOaX596uCjf7POGGyKaKo3fNIVK7DKYH5Z2lT7IWWnq5axTnZf77NPxV8UKKUFtzQSiLvFRuKrzIsvYbMce6w2DKcR54WSAJKloOtNvJdWE4EKDrxAQAuYchSoccbSfUVSjAU/c73wEyHMdDdiCswyM7Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0q/u7kJf+d2Ygw2Ab2xg0hFXmaP4PBy66PXh6rfrM6c=;
 b=fQt/L8xbBpaeTrrWMAUKtIs1noCYVOtxc4XUNZjIDGCJ/R3bd1yCrfOgobnqWDVXs3ZuXq9Idzqi/b+eiPfqj4/C5v1RKP8+EpZUhJfwBm7nx0Uv1N9P+C0jFzi5UBGvKpw9/KqIsDur9LSJJJ0P1z+XQNbrzvyt2e4O0QnH2nw=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DM3PPFA35BF3976.namprd10.prod.outlook.com (2603:10b6:f:fc00::c3c) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.21; Tue, 26 Aug
 2025 09:46:28 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9052.019; Tue, 26 Aug 2025
 09:46:28 +0000
Date: Tue, 26 Aug 2025 10:46:24 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Suren Baghdasaryan <surenb@google.com>,
        "Liam R . Howlett" <Liam.Howlett@oracle.com>,
        David Hildenbrand <david@redhat.com>, Kees Cook <kees@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Rik van Riel <riel@surriel.com>, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V1 2/2] mm: document when rmap locks can be skipped when
 setting need_rmap_locks
Message-ID: <6a8a32a5-95f0-4dc7-8a75-80cf639069ef@lucifer.local>
References: <20250826065848.346066-1-harry.yoo@oracle.com>
 <20250826065848.346066-2-harry.yoo@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250826065848.346066-2-harry.yoo@oracle.com>
X-ClientProxiedBy: MM0P280CA0062.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:8::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DM3PPFA35BF3976:EE_
X-MS-Office365-Filtering-Correlation-Id: e2f14be3-7cbc-4038-2d0b-08dde4856dee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OdlexQU1mt/g4q0oIYxTP7itUkNLbrmYjPTmG9spBjAlCityBqt2ivaUXzyn?=
 =?us-ascii?Q?no9AMpO7CEE/FfJ8p1zhhUucP4ZwmEuLyqCagKKOgLKjj/hS91xtEpau6KoA?=
 =?us-ascii?Q?QtBJLnNvHtO4yANEV0LMVWKPa7Ugs5GOoRWi8iKOh8sdA8MPdE2Tfdca7CuC?=
 =?us-ascii?Q?T2DufzzB67aOEKL6W4IDfghPvyYk3tnyaMsvA8T6oPzdQfTcgATDdC9Hcfpi?=
 =?us-ascii?Q?UhIyxgJUHgokzdR1DJ2ZZBJrXfAz+0BGW5O4GxrKTO8SK2bpK5+Iic1+2nEe?=
 =?us-ascii?Q?yZQSLW436hmw1t2SDRxX9f2EzO8hC+hDbLk4C8rwTfsgnG1VgrIAyuofwRcr?=
 =?us-ascii?Q?MNuAEfuHgzdIc7QAaZJ/pck0GiOmJ7i/xRWzbjx/iwxMYbSAGwXiumlZWN2H?=
 =?us-ascii?Q?8BYQ6WzZTTg0V0Cguxygq+UMGzKmBg00/AdNwQ/cZ6O40/uAMcGapWaypdi+?=
 =?us-ascii?Q?GGwibCXmRMfXR82c1H//phxbRJlbmeYjG1NMep35IscSpFEYwhZ96/VkVOHA?=
 =?us-ascii?Q?z0p5RQ/pRGpxwa0RcDSH6w5xdh8yNfxIYOM7/AxaaPUrDci8ydogBa16XIE6?=
 =?us-ascii?Q?14Ii82WGWHaQTvtwhbPFgKwu9CZ3ZSdLduUA/+SpNL/lKoqk9Ye/opDSL52B?=
 =?us-ascii?Q?En9P5rpI4J2Y4WVSVHGLPfDR5209BeMv8jDSY8OD+u0RL7r6ud8q/I/rwDL+?=
 =?us-ascii?Q?KeUMhDyd1oLMTHIz6ukJVU/innVwnqQWQYTuIniFAgWqPpj5HMdgGwehpekZ?=
 =?us-ascii?Q?oflKo0YDxUUR/JLDaDyKaaSj5W4lCB206uOmz+NZUUk0NBSvIbIzW0YI5SdG?=
 =?us-ascii?Q?OUuajTK6DatEWPVc6xnHocWooi9lezEi1PgtaCmgHBQ5rRdiiJMIjutOGTfM?=
 =?us-ascii?Q?IE4y/9LuP3wiGL7QuxE6KpHXCsWEc2PTj1M1APb7huO3C5HpUUqhQ6VdxWkC?=
 =?us-ascii?Q?ly8cyJYplghAI0qCYCMhHwzW+sTfv30rich+yPxAzZD4jPsvyklpdL46BJrN?=
 =?us-ascii?Q?eRqWZ1GBI00Ya796bIGkwaQ1ybwlilN9FOqgO2ncIlP+/0qV1aARfNR2T5r4?=
 =?us-ascii?Q?KbmrR57mG4D5MvMapbJy22DvM7Qp1jaExr+6V6AC0H3D9apcm+wKm9TnL6F1?=
 =?us-ascii?Q?xIPTpy9Q/863ZeO1B9w+0LW/uX5C3O6Vb5LUTa5nQ5IXytJ+jHMJyZI4wbwZ?=
 =?us-ascii?Q?ijm2ni/A48tGajbIrZl/SvpqizyykPMGhkPQGkNbsLZ57zJMP3P+6ouTr8LC?=
 =?us-ascii?Q?E4fYit6o+23qau4+FCGFCsTbWBBjx0sSPwNrM0itezg8XjD1cm6/l5rJsDFD?=
 =?us-ascii?Q?D1ZkGSKZ2i0bju1mr4V+SlaANrHZxvOKAi/tTRMd8TvJjv+td/ltcbWJkn1k?=
 =?us-ascii?Q?VmRvoICNhseX1jjR+ggAH4i43W8PoDCBAsNVUbpyuvBAsQmMcg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Un8KirW/43kUN+OVF7wQgBuWE80DGknt0ZCYG2gNT2Kv+nrUG5gVFqNY8iLG?=
 =?us-ascii?Q?DOVyIT7jql9A+6swZ8ZTWezOITFrpN9XEv6vTjJ/xpYyWfsQonnHBPaJUjAZ?=
 =?us-ascii?Q?6sxfR7neU7Q0/M3I7pg5HzB/bO63oKOCvoXlSbIgcaHW+PgD/WUihhEsPWbd?=
 =?us-ascii?Q?tENt+KlHcJCOOVEeqeSyq/SeEDLVMcR95x4GVkR4RxDOUIKX1INGZYu5hd+M?=
 =?us-ascii?Q?VdqOr0RaT6Zj/ty7aLhMuYsPnsZqo3tq+1gZhFWM3F1AUdrXEaVGLIIv5O4x?=
 =?us-ascii?Q?acN0KK0d4/FkhAX+twtacxXqgmWCsEeIng/Za8V+xwgrzRAKtCikMGeDxZNE?=
 =?us-ascii?Q?Oz7yZ1zRD2SJwpKhQTGmTx+Pf98czRsWXQcVi3FoPt4XFAyK1Iw4UvbBzJju?=
 =?us-ascii?Q?L3sIPjL5avkX0cXsHAjwyTuzDYAYNVXJVdAJ1AvMOSOx73uMn8wplwQJXvqB?=
 =?us-ascii?Q?bqokDq5odFONFcp9QOG0UspyNlCO91CXnuBOpbkVMctrdI9ycc1aEwivagdU?=
 =?us-ascii?Q?pQxcyM2h6w0TUq1KN1/4JqcJNJ8t3LOluLvLqC4K4tKMPKs6hGotjBN9h4yK?=
 =?us-ascii?Q?PuHZAja/PPnIx0QTwCrW8INQqNtqf+ODIz6gJN/mgSOnoCBxOCHhsP564Oej?=
 =?us-ascii?Q?iIegtq1B1AknPpHxppQVLJbk7rOzutWiI/ewvUl+goH/Tjw2DNQH0vJcSeb1?=
 =?us-ascii?Q?Uw7eZBX46MOgGOHh65/ARU3j9WAtHLO6nH2CGTvrIv0y4K7kBBkyhqrd2MLz?=
 =?us-ascii?Q?YwZvS8d97yGQCvg5NCl5ffUBTXGQfCXQqgucPxRxcUsDm7bmIuqR5qI9yhOG?=
 =?us-ascii?Q?t5+ayfi9GMMuxGhZ75ajFWQswLWQp1V1CwXA3vYeKpmTQqbrvrzYX7BgbFvj?=
 =?us-ascii?Q?TLweyltkUbpBqn9XWd46viWDz5q8Ffcu+a5nVv7hDp63+kQJwEc4qt/qsuoj?=
 =?us-ascii?Q?tMcpd24eCvkF2AmLjavTSME42hQdXYrIK7J5Ne2xkmpg4JwU0Glafjti8xX1?=
 =?us-ascii?Q?TrERGDVoywMVktElMp1AD+zHo0Wb5xBFiO4MVHM+OY5rI9Qe2YJ7Kqjc0QH+?=
 =?us-ascii?Q?+2Ubltj8xbGUGwFWmwP10jvFfqCbyk6mEAd4yMuJw7YH/2UiOg+GbD669RTx?=
 =?us-ascii?Q?YdPHr5VEtti6dljzBg0VZ/JrEjsmDmJIKkC21UDRsMrhErtBiMm2ok2YsTyo?=
 =?us-ascii?Q?vOThyFr6cBQf3Qh50ud8K0gC/sK8DnDSEhh5adCnCm3jdeT9XP0uGYUH45yO?=
 =?us-ascii?Q?KopVr3eIk1J9qYOHiTsQV9NHHbV8aRLIDCyWAeDfeo+vB2HZ/b0owssZ7XAq?=
 =?us-ascii?Q?KpAKhVXes0Oy3fJPefZwLnp2iuIygNo6io5Wy21CCliQdLzvlGC/oSq8ITzv?=
 =?us-ascii?Q?SsIaYY4y+1UFINGyXFiRERHe5UchAgh3mtGF38QpWN2RUvLX172Ec2mZ1NFc?=
 =?us-ascii?Q?TvBXueIlhLfuPu7XiQFuDb3+Apkq3dLxxtQy4B2NGLo9+T+3CX9E+U0QE8Up?=
 =?us-ascii?Q?Z2aTSJMnp+NjBQbj1hrdYfqzyhJ2wG/YzeBxM/mZxCJ00/GZnBCNnao8Oj+N?=
 =?us-ascii?Q?IogPoUn+AmanJPZJ6zShQd45zJumVCkDYIsRvTKjhSI6N4XPtLcx+POVPx7T?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	bG/AAfhiKYZV+Zdhll3+XiBk9dLd3K/1G8aLcu3ckRF2DT/+B6ADVVad1JDMifFpQtZO2Kun7cvxadnzduNLfGjRUsex9E8WoYuY/47xLqKXxA5C7TF7G3b5eCDaiVRqfwXRDxgsDxBEbbyx45X5Nc6+Az10KBhgQliNTE/qgCRqaCrkkp1yUl6Sx4pMCEMYOUkK93WB1EbBVCHSZfIvMpyoVsXW1A+GxklXZbEQ20K8ujb8IRoNnWqWpZWh2ESBKhwycpMIoxg7YI5uk1xFRh6m/YC8089RpakKnXmEmC+XFUjlJEE0iNhUxYER85exGyyTaxZ+QgCY+0iofcSy/ynJL6DVwxVn4axtxRBOVGQqPLxEeT63zZ2PHJN/oxM91MKmiS6FUlbgYKajXoMJlXZinCqCwWGTJEnHU3yWeFpqhS+ZR+ufaGlBqRxuqOAcgsGtlM0U5FPnO6/y3kDIqH+WS+bTcOA7+IJ1YkU1xSb0uV0Mrx3OHiYD7fiYadahAp4ciUyjRy63YFecbovXvqTxMfA4S6eaLK271iT/UmixAXVrGoJ0O6uu3qFXeqfpMbocZyaSL6IrwZqPQFwofdpd6nxuBanUg+ehzjUpClA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f14be3-7cbc-4038-2d0b-08dde4856dee
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Aug 2025 09:46:28.4418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AF/djWzxw1MdbNx1x7s391EPvDaTlu75WMAtPz7W2TIzNYAKW51hLZsp7FPxrjg5i3m2TixSzyjW+BDMQP5hET//YkxgyVP86UtxvgXB64A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFA35BF3976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-26_02,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 mlxscore=0 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508260085
X-Proofpoint-ORIG-GUID: JTrkoZcYPAZsAVRT_lWcuVsebkLttkAR
X-Proofpoint-GUID: JTrkoZcYPAZsAVRT_lWcuVsebkLttkAR
X-Authority-Analysis: v=2.4 cv=EcXIQOmC c=1 sm=1 tr=0 ts=68ad8278 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=2OwXVqhp2XgA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=8Z0Aofs3deCmuYkeYmMA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDAzMCBTYWx0ZWRfX7eF2YGJI6Cn8
 l/x9fP0C0Fkq7UD8jjOyT9Oh6n1Nw3u9bSwTUnDpdA7DqhO0X8jXC5FNkE9aZcUi2fNcoUpJ0iy
 xvPBG7CEiRb6hVbCBOQjXEqSE3ZQ5NXfvfaTzMCpScWHzz07LD2k9OypT5YthMCNTwi/XXF7ZRp
 jZwB2opw8PqQGvelq92PvtUd1T/CYseNueY2QOm7un+hC4+FrFhvCtokLS1Gb3WYUb/FzPTybyy
 zCdoX9dhxBM1yC4Lg0rxtvr3XbE273rj4/dGb5Uif3RmekUrxa6L+FWIFKHPk/oO+9NXtJc3M2A
 E54dqNCUSAJLxkdrNwSaQvFaT4I6EJFKDfm7dRXBuBvs5YtgB4t9oQTi9feqBmAe98HLfVZTlxf
 JuePvHCi
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: D08BE140003
X-Stat-Signature: jjap3rakupknmpr4qrty7krtwb9so6t1
X-HE-Tag: 1756201596-304383
X-HE-Meta: U2FsdGVkX1+iRKIfQlCf1D1Nt8UcKoCKjp6YN5CoLxfpDkX6GRAHM7/xm/dqBYO2qDjg55CGRk4dkQbFtusZngGrUwtUr5q0GCSCXdAc/DMJDxV1pxYl4RWn1tyXcu+7C6QTmCiWImHWbAZar6sRHKURKyD/fs5RBZDX+49+Qsnsw9y/QzOVhJWUaKoi9P4stUwwMksbEFQsDjGH4YExub3G+Kd/Pka7ihNhkwUknOg3bcyFfFUHf25EmlqQHxPpgZOgZaD2v9N/1FLptIlEXQEbSzC5kKVgOh73Q7oPqpNxG2eGaw8OsvxeuyFCHXEMphiw2stxRXwzB4eJVlhqgJD0GiEU9mwwCnCSWbH4zkF0jO/dVj4P7RMufc+6bPRrawEIiBPIXB2biwKiy7YkfHVk2SS5hg/O8mWL9vNqLzQgjZ/dpoKRFIHO2eRL5WnIhFDx7AdOQbiTsxP2O5KYaHqfdbvXL0DsythGJaNLstICnwYxiSXM7d5UGj6RwQVYAdydedg9HKcWSd8RPsTUPFEewBWFGKlxHWayXOhtBQbe9og6APSji+n+0kkJcIZvwU1xK8uUT4aSoRMBk8G9+Hjlj6KXp2oP0EJcB12jFU5SgtjOFJmSUdk+NYMAv5NcmnfTttYAsgopnlvApglyKkVgg2aU/lUeXXHT+XuC/NyV21suB8jvFfG8GVoVI6XTAcnU7S1uQ8u1mDlM26MsFH25jCv0v94JRBmx9YhqGH2FHnL9MXhEzlXkuBg/jVEQViVwOXgpScPpL7fVoepZNyYH2f6cvafa9Dyzbuds67Iw6PvuIUsIkSP8HOiCd/l9PFbiXH2fVHdcr1Q9M2wRGWlkSb+uWw4uflkIr9ipLtNcXOJpQKwkG0rrRCRBbdmitAJkVkLk8knDh/ZA2joRpKYgyYkRlRoxsJosUEm/a/traIhxFQim1yHBrkYjdxwA+FKneesRSxZ6smfXIFL
 Ig9g4pZ0
 mm9jyOXeSlqXRmFjwKplKOzOK8f8z0crZFL/u3DwvxTU6T4ZN1nE7LPHzuEJVW2/FbWfZMD83EfowVNZo5hEpwCu0BpGVXvc+mUdxWYOsVZyCMz11lZ9ckm9C2qxcC/gAsz+jDTIgvWumM6y3wNTuOfZwgdutBG6EQJ+M0TKzRt5GZVbnz5lBjnC1bNTaWuL1BfRc+srCMfJnFlMLtgkahZ3xmqJBInQsefa6pZjqKtcKImeAxG54+JtAFx0DZIl0j5TQImeadZtG4M0iXa4lkGs2DJQHDwcJscwTQ5u4dUGuUZv5j0OZcW5eYtkuGgY4law2C4NrieTHcg402P0f28ikATgzK5/9CqlMCUIdJ5W0VBcNskdctl+AJgjYuKuJeMm0rL9qIHRBoy433z/ldbVWbexnBMWXUqbTGT0NriaORa127HmyU27P2NvbnLLB7woyuhB+Iep5jQADB4NN42XfdxWFm7AiSi1qSm7Rcc2X6eGLaZqb8jf2ZtZuUG9y817iB1cr37ILWx6m4VWWDj5GAfPsBVyL8Dpaoa9A059xUMGDOCSHVCNtgwMBOFviH8MsWkigPaHXsiVuudWkMyqRhupJ+xNBONw21vQASrl8IjZiol9MImuANiDhjxzMQ5kRxPkrV44CeJHUIyuZzVL2AGEscCQ8oFbGAQBI18PQ/YuE631q07vA00Bqn16ZthnjrpY7xWYZ30gw7c0zsGf9Y7rCGqrZ2m3F2FORlVB5SiQb3ZqVpEA9Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 03:58:48PM +0900, Harry Yoo wrote:
> While move_ptes() explains when rmap locks can be skipped, when reading
> the code setting pmc.need_rmap_locks it is not immediately obvious when
> need_rmap_locks can be false. Add a brief explanation in copy_vma() and
> relocate_vma_down(), and add a pointer to the comment in move_ptes().
>
> Meanwhile, fix and improve the comment in move_ptes().
>
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>

This is great thanks! :)

> ---
>  mm/mremap.c   | 4 +++-
>  mm/vma.c      | 7 +++++++
>  mm/vma_exec.c | 5 +++++
>  3 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e618a706aff5..86adb872bea0 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -218,8 +218,10 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  	 * When need_rmap_locks is false, we use other ways to avoid
>  	 * such races:
>  	 *
> -	 * - During exec() shift_arg_pages(), we use a specially tagged vma
> +	 * - During exec() relocate_vma_down(), we use a specially tagged vma
>  	 *   which rmap call sites look for using vma_is_temporary_stack().
> +	 *   Folios mapped in the temporary stack vma cannot be migrated until
> +	 *   the relocation is complete.

Can we actually move this comment over to move_page_tables()? As this is
relevant to the whole operation. Also could you put a comment referencing this
comment in copy_vma_and_data() as this is where we actually determine whether
this is the case or not in _most cases_.

Let's just get all the 'need rmap locks' and 'corner cases where it's fine
anyway' in one place that is logical :)

Also could you put a comment in copy_vma() over in mm/vma.c saying 'see the
comment in mm/mremap.c' or even risk mentioning the function name (risky as code
changes but still :P) e.g. 'see comment in move_page_tables()' or something.

I'm confused by the 'folios mapped' and 'migrate' bits - and I think people will
be confused by that.

I think better to say 'page tables for the temporary stack cannot be adjusted
until the relocation is complete'.

>  	 *
>  	 * - During mremap(), new_vma is often known to be placed after vma
>  	 *   in rmap traversal order. This ensures rmap will always observe

This whole bit after could really do with some ASCII diagrams btw :)) ;) but you
know maybe out of scope here.

> diff --git a/mm/vma.c b/mm/vma.c
> index 3b12c7579831..3da49f79e9ba 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -1842,6 +1842,11 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  	vmg.next = vma_iter_next_rewind(&vmi, NULL);
>  	new_vma = vma_merge_new_range(&vmg);
>
> +	/*
> +	 * rmap locks can be skipped as long as new_vma is traversed
> +	 * after vma during rmap walk (new_vma->vm_pgoff >= vma->vm_pgoff).
> +	 * See the comment in move_ptes().
> +	 */

Obv. would prefer this to say 'move_page_tables()' as mentioned above :P

>  	if (new_vma) {
>  		/*
>  		 * Source vma may have been merged into new_vma
> @@ -1879,6 +1884,8 @@ struct vm_area_struct *copy_vma(struct vm_area_struct **vmap,
>  			new_vma->vm_ops->open(new_vma);
>  		if (vma_link(mm, new_vma))
>  			goto out_vma_link;
> +
> +		/* new_vma->pg_off is always >= vma->pg_off if not merged */

Err, new_vma is NULL? :) I'm not sure this comment is too useful.

>  		*need_rmap_locks = false;
>  	}
>  	return new_vma;
> diff --git a/mm/vma_exec.c b/mm/vma_exec.c
> index 922ee51747a6..a895dd39ac46 100644
> --- a/mm/vma_exec.c
> +++ b/mm/vma_exec.c
> @@ -63,6 +63,11 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
>  	 * process cleanup to remove whatever mess we made.
>  	 */
>  	pmc.for_stack = true;
> +	/*
> +	 * pmc.need_rmap_locks is false since rmap locks can be safely skipped
> +	 * because migration is disabled for this vma during relocation.
> +	 * See the comment in move_ptes().
> +	 */

Let's reword this also, people will get confused about migration here.

'pmc.need_rmap_locks is false since rmap explicitly checks for
vma_is_temporary_stack() and thus extra care does not need to be taken here
during stack relocation. See the comment in move_page_tables().'


>  	if (length != move_page_tables(&pmc))
>  		return -ENOMEM;
>
> --
> 2.43.0
>

Cheers, Lorenzo

