Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F36ACF65CB
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 10:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A404E6B0088; Mon, 26 Jan 2026 05:16:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EE1C6B0089; Mon, 26 Jan 2026 05:16:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850056B008A; Mon, 26 Jan 2026 05:16:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70F796B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:16:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 24AB713B362
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:16:55 +0000 (UTC)
X-FDA: 84373711590.15.F61161B
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2E541C0003
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 10:16:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fFwqc+wR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iOtL+8tx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769422611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqOQMo0/GnXMcGir+Mczl4rm893GMk+t188D+PE4x8Q=;
	b=iDiSeYe/dCeCd8DwWukqGDYl2O6cm5UVsW/EtDD4Tce6qN3QGnye+Gjgx+1Yu7K9M3wH6P
	ynZX5d2f/6EG//WH6mLXMUHdhG4xsmNd1hd5XG5F0SymHQBEww5wjckW1GVU+fYEsQKa8T
	IVp2zm4ajd0vW+YYhhwLDTLefoDt5WA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769422611; a=rsa-sha256;
	cv=pass;
	b=kPff3wzXp7V/xbKZlfvfr+nZhZGhxh1tQ21Df33S0SZW5wwb3MvxJZ9Mvkvi31lAbZAV8P
	P5M1iwRped1c9sYcjMtrqN28pszJYnOiUW5HLxJfMvFEIFFKMJR0QK9lVDhYjYyCPGeZ2r
	eSOuKnk7lwle+7KME4kH+EpOu1Qh7Ec=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=fFwqc+wR;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=iOtL+8tx;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf20.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60Q4bOEE488946;
	Mon, 26 Jan 2026 10:16:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=wqOQMo0/GnXMcGir+M
	czl4rm893GMk+t188D+PE4x8Q=; b=fFwqc+wRd9XGDiKKZS9rfGY/8v7t2VUEbn
	uK/shLszHCKtEvKKd74ii974o50TrRb7M1sOxxOf/ePerOcQ+ZNJVliGqqiHA/75
	6lfwxRhVKqOvWFOcXIfllIXMNC0HrIPi8yKYs0b+tHJFRo4h7hqcWVZfYxFK2Man
	pjXZjF6CyB+f+MdLwMThLHoqARy6Zf6bxgjcE7B28qBSzuvskUK9CPJKiH3Fp+Cf
	KvBszxYCnvzb8/baqNHGGYgd++cWEIPURjaxWzx0AcP9GcxiDubGC5JlsRZYqEKO
	S661Kgbz8LCeDvfnLK2Mb6k0HHvcELHSijn28fpZGVtFhtQ/OjIw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bvn09hne3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 10:16:45 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60Q9939F036087;
	Mon, 26 Jan 2026 10:16:44 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013068.outbound.protection.outlook.com [40.93.201.68])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhm1wc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 Jan 2026 10:16:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bWkXdBG+uLFLS1UlPYuxif0UGoaUkNMvwDN4IuHAjw7gq1LVbO2AGmbxl/9s4apYLEwM3kXh0KipvIKWKT+vJ0ywng/t8SLndmqBseWrieWtHF0cWyn2asWSjMMDwnHE9o0FAmbPTFejtprKFzpi2hlcTl8NzQ7n0mrbef6kfYjmMCUELfQ+QjY0xw51WsuMWdc1tm+45MyrG0Rqc1nv6HPCpLNtK8PVga2WLTrFrUmJ6ybF64yu+DH9LffrzK0enjvkmab5cXoeOXcyefbQDCI8XUq7JEj6nR/UOfyI17GbSdAY9e5VXGsNKay2WGa5K8zaW+JoI+erNuNkouGetg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wqOQMo0/GnXMcGir+Mczl4rm893GMk+t188D+PE4x8Q=;
 b=dbVjyAtpNV3wHfRsA65fTKaz1rVi0dwRfYim8TaeQqSQCHay2AjNYcLeLfFT/kkVheMk4JigKo4pnQ994F5vHXs2UKqTi1FBueaBZ0VYI9eT2P8JPrcMjFfuWswY7zxPLVoi0EPMokaeMaJ0+2bdBEchUl9J+pp7yglzTRjpNE+39xM8UfTH8cggsUnoBQIB0lr/xCJNuxv4bgRnNFN8cXoYtA5+tP2uW3npd1x51xL3L2oB20FCKfkHNVTCVAX86Pmng8a9LEoZ83CZMpfDc0fScp8viuHdzJNNXxJqBonT0fATagD0ztdeVAfdchbnv0F7ImdYXf+FQFnb+yMWng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wqOQMo0/GnXMcGir+Mczl4rm893GMk+t188D+PE4x8Q=;
 b=iOtL+8txuTpD+BqDPmmFih5GRL2NlfYsLvbGOzy4VcHNDWQMCnJePMMzxW+LoheZV0sKXLfQWLtQu4RwotjIU+HcZDglSUVQSWqwHkNe+jHYpMQDj/yU72QY4CmQhOYQ7/LgyQ6CwRXZPah2uh20+W5UPndwvqjtOHdGeMYQS3k=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by SA3PR10MB6950.namprd10.prod.outlook.com (2603:10b6:806:31d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.15; Mon, 26 Jan
 2026 10:16:40 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9520.005; Mon, 26 Jan 2026
 10:16:42 +0000
Date: Mon, 26 Jan 2026 10:16:38 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] selftests/mm: Have the harness run each test category
 separately
Message-ID: <b607c7e6-278a-4d5f-a69f-a9588f028106@lucifer.local>
References: <20260123-selftests-mm-run-suites-separately-v2-1-3e934edacbfa@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-selftests-mm-run-suites-separately-v2-1-3e934edacbfa@kernel.org>
X-ClientProxiedBy: LO6P265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2ff::14) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|SA3PR10MB6950:EE_
X-MS-Office365-Filtering-Correlation-Id: 8045d48a-6663-4c58-6824-08de5cc40028
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|7416014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?WKdnwczf6CMGr/KaAVznE8py2EIVprq1wqOPRbc8Psw8hzE5zOsC+dA9cnPa?=
 =?us-ascii?Q?Zpx7g2WGBv06k91FkjboMvg9f0TJqJ83hQCxlRWsb+FeDGoXYbrEobwOo14z?=
 =?us-ascii?Q?y7pBn5ouycm30Hap+VCa6hx12zL6Sv+hgKTEbffCOSWGJT6V2B1iw6ygudLL?=
 =?us-ascii?Q?KLYl5fXVwZ9A9fffQDBMCEGL3W9GBHIxqch0O846DiYP+Vy/swDro/PehmDO?=
 =?us-ascii?Q?qYY49tuHO593nLw5lL2kA6OJjAJ0szCZusUNiUnnYZ9X6dIiEPlYRyGeeV48?=
 =?us-ascii?Q?CjzXr+v/D+WWwwwXdss4ux9jY6zcidCETtZHeSgAJRFfw+HF16Qp5HJkp/+k?=
 =?us-ascii?Q?DQPWX6B89zrZAZURYIFlYQH7b3iAfVON7R/SOwPFihCSVaW+qGv7ti3GdpmQ?=
 =?us-ascii?Q?lvMnOD4N2A/D+X504ZdsoEUawjxrqT7M8ryKqlPYTmSzcGWZYYSe/ufSDjmm?=
 =?us-ascii?Q?sDuydfmeArjvaINckeVHrrgd+jtrkg5Z3QPR3IUO1bETMBM8HNfV1y9dtzmh?=
 =?us-ascii?Q?//OskN+E6Y5t/oy1woW+zzht380SlmdZiffWzE5WNP/5r7lAdmxxwC41vgKj?=
 =?us-ascii?Q?SEl/0KLWsjlufK8uSnSLZaCwhDy41JVJPGM9bCQlzvaNnshvcK6p2mbs0Ql9?=
 =?us-ascii?Q?O7B7mK5nqFqwf1rOVrLg60x4VSl1rdEzg+YDUW00ceOC8gA1SYjqFtsExYJn?=
 =?us-ascii?Q?YsHEa+Ozdb0F2tmONK+7/rfu7h2rMwKYxbUDb8TLH9Q+SVKzvVAVWcYTB8ro?=
 =?us-ascii?Q?5hiQw29A0+dj1K0i8nvPzNyKZMn6GlgwFDBtFz2tAflmDFMt7+zoQmskKt51?=
 =?us-ascii?Q?t5W79j7t9L2Ln3m8PPB44kYqY5YD+V+Sto9MhZUa/FSVhHqAhFZa7sLvC8h9?=
 =?us-ascii?Q?OjqVnhTyOTYEnkJw96pzrNRt/d8+glhx/iuGx4kPxJSOmtpeESCXcQGUvglR?=
 =?us-ascii?Q?NPPnaCwm8bsQLjoXGpUp+dLMa0OFy3o+HmqumEeo+QFd0ztQRoJP0B2qe80i?=
 =?us-ascii?Q?rH2HB05S20qAi3UvhIX+I8iINbZ3CSoeNcQLi6KzoSJtOSScESFHTzxnUvTi?=
 =?us-ascii?Q?ivtGvMfVeiFUcC9ZLGg1HiaApo4r+uEZfs6BMMxlGXN6V7cGiXb6HZ8+hju6?=
 =?us-ascii?Q?Fv754vmfSIwiRcfWCLp2h+AvfnqyHOrsxZ2nluwtXwsSjWrWr+aeVCAFizkj?=
 =?us-ascii?Q?zZ+9r27UPVDHZ737DArK5ccifMNXOKc5xi8Yi6B0eywdM6RwDE7PxzCN2qOZ?=
 =?us-ascii?Q?aXgua3ApPGxCjfgzAGWLwZTIWuL6AUAjJjBYKJY/srpX0g4ue0q9ATNeqRGt?=
 =?us-ascii?Q?mcufyK+pWDDSsGvjL5KiGfjPFtWi2MxWADlV+NifazxrxOCVVA/okoHohwHB?=
 =?us-ascii?Q?8fSRCIH2PjXBl9GDSfxRJcT6tfp8if9jTkLzK42QOJKay7bXrGAhxbNFqzSw?=
 =?us-ascii?Q?72OaEnQrqsdo2KrWfUn6vJfot74uxFerSxwWRrPAi+jk0p+/zg2UhZPwD2dm?=
 =?us-ascii?Q?ytfnj8gww5a4iSfyVxBCrbJ9K4gzVUuOl6tu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0v96Dht8NlHQcoRKm4pGHg/YZY2oChbf1xCGrzYNWJNVJqZ/0fOoxlW2cgP7?=
 =?us-ascii?Q?c2+nyxWYqngJKRPfcGfiYXETCa7Tr1Iwz0M+TRJ/D5l4rM3+iaBpbLitw79D?=
 =?us-ascii?Q?Nq8UTfXaqCFCOjfxBQpolx4XjZ9853TafuSz64QDMpaR35zOhIwmFH2y9IdG?=
 =?us-ascii?Q?p4ZzS11wvmmHrecvJiFvV5vNtXP9gmZz/jCBzW3zlXWXoq7Sa9j8u9IChPT+?=
 =?us-ascii?Q?YKmz9Wl3EJHQQRMBQXQyurGhfjX6PQO5To+FRa9d7u49smZcLWGgQPie4gax?=
 =?us-ascii?Q?JMW8wljUDTPJX83k/6BM1UwWv9lecILewcNDfNL8TqqInmTmrzQBKv9qO1Lb?=
 =?us-ascii?Q?m7+9Pp4wCtC2cih7u0IGfOu7zO8qFt9mgPP2XEnDL+WPMHTUitgHqMt1NnLE?=
 =?us-ascii?Q?JCaFW3kR+0cJ+owteWuBo/9o7ARUAd09O5QS/ijEEVciiIfg75I7BZotBAl8?=
 =?us-ascii?Q?CZFJsCi3lTvgTujqgB4HTqJ9LC1eSP1fBGwozfIzEQL7O4HVX9bVLO6scqYd?=
 =?us-ascii?Q?Wl3aS7hMZJT8lhzdtp4BYoef8tCh8THTNfl3NLbhr7mCuJBWTBafCr8/b6aH?=
 =?us-ascii?Q?+C6n/d7w4/XWqRFESKQgCXC2EA6cuzwE4QWFXEahWKt4YsSS8jq2OaRr9jAR?=
 =?us-ascii?Q?vh2e9GI+m3R5l36leCisHRFirRRjvoIZQx6fhRcBneaD6LsvfGxrSYBaNXgF?=
 =?us-ascii?Q?zJMIYi5rbsV1ltJkElE5nGElaGctDJ2zGQI1eG6+SaRJxkNTvs5VJsUxtTAP?=
 =?us-ascii?Q?1gZRkPR13VtSRyFMtJ6CbGRdO2SwsvQzNZdD6uUldIjUcgP79HoB2Gv6pnVh?=
 =?us-ascii?Q?4n2MyFaLty8bGJdcfHmDR5/wcdnMJajV65NRfU66UDvouWwhC4JeIkxOJtwG?=
 =?us-ascii?Q?1Hxw/sXf6+l70vAR6ozeyp5rWRMGfEfDK8tcFz0JguLSZmsefzjOWfutckX9?=
 =?us-ascii?Q?RrrAmimJ59TKamAG7f/tcE/ZM1RDGEA57Z8y0uUftkREdAoddrMPgaRrkc4o?=
 =?us-ascii?Q?xPq4/l6y3L5dYgVtinLDCG3GpDMmqGN7wErUGsw3lhEobju0s95p1RkWruav?=
 =?us-ascii?Q?nN7yWve1VqMECuM9Uv3Gx7LcSFqLa1xb8J5JKW+xjIlCBNEdgxupmUh3giQ8?=
 =?us-ascii?Q?eXW9DZg5uUAW2Uwbs4UlGK50/JhSa+PALraDJWwcRlyEQu8dBle86h7Hs1ZC?=
 =?us-ascii?Q?KDJS3UOawDS4/nrZZi9oHguHoGfBuU8wMWDxULxgrnDSOThjYEDcjotN4BeJ?=
 =?us-ascii?Q?mBs6PDVtc7wEqtiaRtNU9WZRQ71mMiaiGd8boLxUw2+5xaKQsbDdprK2EyMT?=
 =?us-ascii?Q?IIkpgJ1k25jjTCZntWnG15QTCbyjSLuJud60cjIKPUfMMAFGEqarmQWZ8J2d?=
 =?us-ascii?Q?sGl3vIslrlcqIdkDi8t6O3KK+VmC4u3qoLVG3KKqYr76ZwyfjdlqC/6lt+Qz?=
 =?us-ascii?Q?05WcpY5ff5OswyRqfUdZZLBXnEsO5hY02XC2BsCNAY2UAmfnOHhPqvuHIkVU?=
 =?us-ascii?Q?+uiHPoHZWWwvqDj2MH+W1/Dgv1jPlat5a0BhruNd4ZXA3TdnYukkbgaa7OG2?=
 =?us-ascii?Q?XE2LuXft6YE39OMhUvPSr931tYdBM/QxiLbjxFCF4Tij7wZFDD2eHi9eRLEU?=
 =?us-ascii?Q?wbFZNZTXJkXsIHdKAk+P44EN9T25depTyNqNYfrH/ZovxiVP3RaJW9sCFWYC?=
 =?us-ascii?Q?J7nfLLQsGy3w1qEgoEINzawuSPzX0LHr3u5BixsMWHWo0ppNxqESSTplOFfW?=
 =?us-ascii?Q?6f1K5PEmbmAtoFFzVuO3QaSftbc0Itw=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9xdQ/89wN2/uleTK4a2+QyXYtq/riJR5UUNBxbyfAycczrveaalx3nPAmGBus5Hsh65V0RbniaNVsV5jC8SUwCeIgyBNyHe3bkB36MlzbGBnToIp7sSzt/lbK787j5RcWKiQU786Pg6MaFthMCG2oumOxQb7xlnPELEr0RGoiqN2MclG/z5Vdf+hqOj0tgtzXer/Yg23gGNiMiH7wQWosO2I3vQqahwUfju6p4iP3Y1xu103tqiKiX+fbAHzCtYm1n5ujQ2nX+942jitltoFSDlb4SRUS3SGebEbfTNLsle7WwbyfGJ/uu0MmmseJ+FMbdLxbVewuXeJ57XwYE+y1ztNC6ouMIbgOBX16HNamAtyqd8esHH3rKP1ecnbgQwgfcwSQTCaETy/RakR9f8wKRBSH49qjD+/jc2SYKKC84oW6UWkqjT9bdNofmEma2l117ZdtyatIkVISfd1rPa6dcWs4kVVmj1b9rLXRGAzjcxtINOCrkmyclGMpthboitR0VnyjKiZm0n7YSsocY2oAMqxjX3/ojBQmI37M1rhi4n64I3DBpPlEzwWjjM3wp1qwooH7toi/PlHIJ6+AYP1VMV0eOha+9Z4lgDKYKXBx7s=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8045d48a-6663-4c58-6824-08de5cc40028
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jan 2026 10:16:42.1613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWK/VoCyPXEjAa+ZqWhFjEbNgYHTAA/3Wt252XwNY+m/ijLy8lRMNl2tiBokX/sHH/cMNgQeCdtJeFUSalurDvKAPgh1bqzHJb9xgmp31BI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB6950
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.20,FMLib:17.12.100.49
 definitions=2026-01-26_02,2026-01-22_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2601260087
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI2MDA4NyBTYWx0ZWRfXwVeJFi/fRfvM
 Jy9arBlmpqNvZ40M7zEPdbmuOVx/MlWJvTTEBiSJOn1TgTz+kW8HkCjhKHU759OMBPNVeGic/ky
 MCmw2gPT6WK3sDlACxaJTlUL6+BFPDRwa31elmLykQDbGpFhoid86CcnJB3ynAE/9+W7Hb2gqMT
 X3ooqvB6WtZWO2XrOyMpJtlcBCzsn4bJ8a1sV2qS/S5EanV0ep8gyESeGYhGQFrx0WrObszzwLz
 4irLxiTWR0wD/63Pfu/m+L89Wqy1ZufNbMd6hZ0ZdUzK67K+6UnQhwRrhYPJEQvPFkFTOEXjCJ+
 ChTbEO/HuFPjnDGUUCE2JycDZ7PlTWoBe3zDFSZrsGxIXgRqrM4E25po4orVmAL99xXLYjtEbY1
 1yHqpVBR9hryw+mHVwg0++oXBDh0j0SlMrB7DDon9f52hOuPk1db8kwr3T0oVeaqdwY/Pi4eu72
 b97MpnGp/o/F3+p4OLhAbBn4esjEJReoDiNeYkG0=
X-Proofpoint-ORIG-GUID: X1Hu2Oad6eR55zSscGdWAO2c-vQmpb-B
X-Authority-Analysis: v=2.4 cv=Rp7I7SmK c=1 sm=1 tr=0 ts=69773f0e b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=bC-a23v3AAAA:8 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8 a=fveZgB6dEr6svdTiBlcA:9
 a=CjuIK1q_8ugA:10 a=FO4_E8m0qiDe52t0p3_H:22 cc=ntf awl=host:12104
X-Proofpoint-GUID: X1Hu2Oad6eR55zSscGdWAO2c-vQmpb-B
X-Rspamd-Queue-Id: A2E541C0003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p8fqte4xxwc5yqkun17jadzt3gngqos6
X-HE-Tag: 1769422611-696484
X-HE-Meta: U2FsdGVkX19pPLXkqHCQxgHp5U7IKePuj+rIDIXROalO8tYNbRPTPIGcdq5kfX2DAj5DBfp2AW8fvk9VpH41W4fS7zDL1V4zODwNMWFHJBMuIMxZ6EdJbqSzVsPqzAdandZMMHMnw+/+JG/yIed7XJJrl7IOMx4272dxsUadxih9bIIE8RXvF/FSUs1u/1nrWsxzV4dDqBW8U5bMDg13FGLukt83qwwDfCru3zXNfmC01iQC//1TWe4gMUBvK4LVQTwOmM0Hkw8kfyRmEZDx0CsAspZWS1AKh7/b0i9/ZCN8YDFfLKAEIa0Mxbt3jbTsmInSiL6JosARzB9cUL6pQQS0PQxvSDlkzxY7WPyK2U52D145JgeJS0N3ZigON04vEGMCJwRH8p0miEkXrn8snSSgCypgxKcAtJmxzemOa1L4hgJE3gI6pwZipesbmfmM2VmzaWdR1VqZ8/Ys5A8cGo0+B9u3jtjAUADiG6XkwNP8dPcJoN69N5H9CvREID/I3CC2fGLS/XKEwvydiyZsy84y5p38JbnG+FyhGF6WwfHz3ExmF/WXsbO/tYQubtzsU/JHxEPbIzOIyDPxyLKuQNVKi4ayxpFZX2hURtKB1/wrN98KzCMt7+ZOrDP+uSHrgRKWuUkPnyj8pMC5CKVak5mpFdeyIQWSlPu96sP4qmXmnGlBsqU6xQrasiKzfsStuvFeoYuaPOUhi+ScmMQAuxaOSD9XxACsVYi6dU54CzvBYRQ+vRGrwzGjIb6zifjyWfqFNBLSlZ7N8AEfAJpYaPQoSNtXZaB/IVK3Zl+7gOhBRTGhwjQHkEGe835crMCl16WHgEBffs5n6ktuv9s1+95wYbQW0U493o8hCiwaQEyL3pVODFL5xeiQqXB88l0grQUDkkzXKpoPdyCsvFF40JGTKXPjk2H+CInKEN+D4PSoHe2zaMSGsLTKGzNRTKf8LjxE2h25EhErgH+b0A3
 PxfPNJUe
 LMAsO850hJZlusvvjfYcAiIdDg/ulQOuxfxTmJ2qYtDnAgBdbBvpssCGwMtm8iMOOpmVaUEXoPh9GUeDZtyNMpJh/5+N9Pge6y2NhF8wirIISUt+pM9gf1w2RjORuCT8drccFljSe1twvxZHPj7Q9HxiDs7y9NYa3fSQOVIdq4N589tZNqCIZ6MC4ohMEva76bxDrBL9E4HU8EhO88+itsvOjfRH+dEsD4jUJV46rnWekQriflIueyIbJS3L3/iWYKbsdUIWTfYqe5UTxOrAiK+ZO/ckvF/jA6EtCHry74JnvzoYkR8i07pUgYKu3mH9WJeKLyZ1rVBf5v6HfluzsRYhqgeJvTVpgMmcCzAo85d3cWIjUKFhTvfx2vDdXyQU8Pg7y7QEqZ7PPLJfjEpT9uyPwwwGp1Ho+8DgOXYFasEnOB6MTid7c72Jlh6fxpzDjiE+yoKXhTIfeExZ5TFGwm5KHk1EgLEFzgZ9k1LlNZXLIgXeiwbtIolyrru54aq9XKIEc8KspRV6vyk33levGroWkWfv2gJBS43XFc679QTbhK82pAMXKTYKvvsCuDHvS479RhZ0xK8BRCdwjYAKoJJfv2cyaJdZmmeOkn2Jtl7u8vKEnQADJX8q1xzkA9Nb/l7sKc4J27BmOJP1VOlS7kkdsC5VZjNpvD5gYFMHVYC2gA5TGiwcemiS3uGcQFuvcEpu7836yOXHyRXZftxxue0MoXV/m3wVAXI+SBKWg89KXrWtTTXyowHfm4CD+Uest3eDO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 10:39:24PM +0000, Mark Brown wrote:
> At present the mm selftests are integrated into the kselftest harness by
> having it run run_vmtest.sh and letting it pick it's default set of
> tests to invoke, rather than by telling the kselftest framework about
> each test program individually as is more standard.   This has some
> unfortunate interactions with the kselftest harness:
>
>  - If any of the tests hangs the harness will kill the entire mm
>    selftests run rather than just the individual test, meaning no
>    further tests get run.
>  - The timeout applied by the harness is applied to the whole run rather
>    than an individual test which frequently leads to the suite not being
>    completed in production testing.
>
> Deploy a crude but effective mitigation for these issues by telling the
> kselftest framework to run each of the test categories that run_vmtests.sh
> has separately.  Since kselftest really wants to run test programs this
> is done by providing a trivial wrapper script for each categorty that
> invokes run_vmtest.sh, this is not a thing of great elegence but it is
> clear and simple.  Since run_vmtests.sh is doing runtime support
> detection, scenario enumeration and setup for many of the tests we can't
> consistently tell the framework about the individual test programs.
>
> This has the side effect of reordering the tests, hopefully the testing
> is not overly sensitive to this.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>

Thanks for adding the comments! :)

Did a quick test locally to make sure all is good from development POV, all good
so LGTM and:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
> Changes in v2:
> - Add comments to Makefile and run_vmtests.sh about the need for
>   updates.
> - Link to v1: https://patch.msgid.link/20260120-selftests-mm-run-suites-separately-v1-1-a4334f0cbb3a@kernel.org
> ---
>  tools/testing/selftests/mm/Makefile                | 33 +++++++++++++++++++++-
>  tools/testing/selftests/mm/ksft_compaction.sh      |  4 +++
>  tools/testing/selftests/mm/ksft_cow.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_gup_test.sh        |  4 +++
>  tools/testing/selftests/mm/ksft_hmm.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_hugetlb.sh         |  4 +++
>  tools/testing/selftests/mm/ksft_hugevm.sh          |  4 +++
>  tools/testing/selftests/mm/ksft_ksm.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_ksm_numa.sh        |  4 +++
>  tools/testing/selftests/mm/ksft_madv_guard.sh      |  4 +++
>  tools/testing/selftests/mm/ksft_madv_populate.sh   |  4 +++
>  tools/testing/selftests/mm/ksft_mdwe.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_memfd_secret.sh    |  4 +++
>  tools/testing/selftests/mm/ksft_migration.sh       |  4 +++
>  tools/testing/selftests/mm/ksft_mkdirty.sh         |  4 +++
>  tools/testing/selftests/mm/ksft_mlock.sh           |  4 +++
>  tools/testing/selftests/mm/ksft_mmap.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_mremap.sh          |  4 +++
>  tools/testing/selftests/mm/ksft_page_frag.sh       |  4 +++
>  tools/testing/selftests/mm/ksft_pagemap.sh         |  4 +++
>  tools/testing/selftests/mm/ksft_pfnmap.sh          |  4 +++
>  tools/testing/selftests/mm/ksft_pkey.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_process_madv.sh    |  4 +++
>  .../testing/selftests/mm/ksft_process_mrelease.sh  |  4 +++
>  tools/testing/selftests/mm/ksft_rmap.sh            |  4 +++
>  tools/testing/selftests/mm/ksft_soft_dirty.sh      |  4 +++
>  tools/testing/selftests/mm/ksft_thp.sh             |  4 +++
>  tools/testing/selftests/mm/ksft_userfaultfd.sh     |  4 +++
>  tools/testing/selftests/mm/ksft_vma_merge.sh       |  4 +++
>  tools/testing/selftests/mm/ksft_vmalloc.sh         |  4 +++
>  tools/testing/selftests/mm/run_vmtests.sh          |  4 +++
>  31 files changed, 152 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/mm/Makefile b/tools/testing/selftests/mm/Makefile
> index eaf9312097f7..aa4951e8cb57 100644
> --- a/tools/testing/selftests/mm/Makefile
> +++ b/tools/testing/selftests/mm/Makefile
> @@ -1,6 +1,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Makefile for mm selftests
>
> +# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
> +# script so kunit knows to run it, and add it to the list below.
> +# If you do not YOUR TESTS WILL NOT RUN IN THE CI.
> +
>  LOCAL_HDRS += $(selfdir)/mm/local_config.h $(top_srcdir)/mm/gup_test.h
>  LOCAL_HDRS += $(selfdir)/mm/mseal_helpers.h
>
> @@ -146,7 +150,33 @@ endif
>  TEST_GEN_FILES += write_to_hugetlbfs
>  endif
>
> -TEST_PROGS := run_vmtests.sh
> +TEST_PROGS += ksft_compaction.sh
> +TEST_PROGS += ksft_cow.sh
> +TEST_PROGS += ksft_gup_test.sh
> +TEST_PROGS += ksft_hmm.sh
> +TEST_PROGS += ksft_hugetlb.sh
> +TEST_PROGS += ksft_hugevm.sh
> +TEST_PROGS += ksft_ksm.sh
> +TEST_PROGS += ksft_ksm_numa.sh
> +TEST_PROGS += ksft_madv_guard.sh
> +TEST_PROGS += ksft_madv_populate.sh
> +TEST_PROGS += ksft_memfd_secret.sh
> +TEST_PROGS += ksft_migration.sh
> +TEST_PROGS += ksft_mkdirty.sh
> +TEST_PROGS += ksft_mlock.sh
> +TEST_PROGS += ksft_mmap.sh
> +TEST_PROGS += ksft_mremap.sh
> +TEST_PROGS += ksft_pagemap.sh
> +TEST_PROGS += ksft_pfnmap.sh
> +TEST_PROGS += ksft_pkey.sh
> +TEST_PROGS += ksft_process_madv.sh
> +TEST_PROGS += ksft_process_mrelease.sh
> +TEST_PROGS += ksft_rmap.sh
> +TEST_PROGS += ksft_soft_dirty.sh
> +TEST_PROGS += ksft_thp.sh
> +TEST_PROGS += ksft_userfaultfd.sh
> +TEST_PROGS += ksft_vma_merge.sh
> +TEST_PROGS += ksft_vmalloc.sh
>
>  TEST_FILES := test_vmalloc.sh
>  TEST_FILES += test_hmm.sh
> @@ -154,6 +184,7 @@ TEST_FILES += va_high_addr_switch.sh
>  TEST_FILES += charge_reserved_hugetlb.sh
>  TEST_FILES += hugetlb_reparenting_test.sh
>  TEST_FILES += test_page_frag.sh
> +TEST_FILES += run_vmtests.sh
>
>  # required by charge_reserved_hugetlb.sh
>  TEST_FILES += write_hugetlb_memory.sh
> diff --git a/tools/testing/selftests/mm/ksft_compaction.sh b/tools/testing/selftests/mm/ksft_compaction.sh
> new file mode 100755
> index 000000000000..1f38f4228a34
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_compaction.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t compaction
> diff --git a/tools/testing/selftests/mm/ksft_cow.sh b/tools/testing/selftests/mm/ksft_cow.sh
> new file mode 100755
> index 000000000000..1e03a95fd5f6
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_cow.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t cow
> diff --git a/tools/testing/selftests/mm/ksft_gup_test.sh b/tools/testing/selftests/mm/ksft_gup_test.sh
> new file mode 100755
> index 000000000000..09e586d2f446
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_gup_test.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t gup_test
> diff --git a/tools/testing/selftests/mm/ksft_hmm.sh b/tools/testing/selftests/mm/ksft_hmm.sh
> new file mode 100755
> index 000000000000..0a7b04f454d5
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_hmm.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t hmm
> diff --git a/tools/testing/selftests/mm/ksft_hugetlb.sh b/tools/testing/selftests/mm/ksft_hugetlb.sh
> new file mode 100755
> index 000000000000..4f92974a4eb5
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_hugetlb.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t hugetlb
> diff --git a/tools/testing/selftests/mm/ksft_hugevm.sh b/tools/testing/selftests/mm/ksft_hugevm.sh
> new file mode 100755
> index 000000000000..377967fe9c91
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_hugevm.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t hugevm
> diff --git a/tools/testing/selftests/mm/ksft_ksm.sh b/tools/testing/selftests/mm/ksft_ksm.sh
> new file mode 100755
> index 000000000000..f6a6fe13a3b0
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_ksm.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t ksm
> diff --git a/tools/testing/selftests/mm/ksft_ksm_numa.sh b/tools/testing/selftests/mm/ksft_ksm_numa.sh
> new file mode 100755
> index 000000000000..144b41a5e3bb
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_ksm_numa.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t ksm_numa
> diff --git a/tools/testing/selftests/mm/ksft_madv_guard.sh b/tools/testing/selftests/mm/ksft_madv_guard.sh
> new file mode 100755
> index 000000000000..2d810c049182
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_madv_guard.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t madv_guard
> diff --git a/tools/testing/selftests/mm/ksft_madv_populate.sh b/tools/testing/selftests/mm/ksft_madv_populate.sh
> new file mode 100755
> index 000000000000..127e22ed02c4
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_madv_populate.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t madv_populate
> diff --git a/tools/testing/selftests/mm/ksft_mdwe.sh b/tools/testing/selftests/mm/ksft_mdwe.sh
> new file mode 100755
> index 000000000000..3dcae95ddabc
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mdwe.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mdwe
> diff --git a/tools/testing/selftests/mm/ksft_memfd_secret.sh b/tools/testing/selftests/mm/ksft_memfd_secret.sh
> new file mode 100755
> index 000000000000..56e82dd648a7
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_memfd_secret.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t memfd_secret
> diff --git a/tools/testing/selftests/mm/ksft_migration.sh b/tools/testing/selftests/mm/ksft_migration.sh
> new file mode 100755
> index 000000000000..7cf37c72d26e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_migration.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t migration
> diff --git a/tools/testing/selftests/mm/ksft_mkdirty.sh b/tools/testing/selftests/mm/ksft_mkdirty.sh
> new file mode 100755
> index 000000000000..dd6332df3204
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mkdirty.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mkdirty
> diff --git a/tools/testing/selftests/mm/ksft_mlock.sh b/tools/testing/selftests/mm/ksft_mlock.sh
> new file mode 100755
> index 000000000000..1e25ab9fdc8b
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mlock.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mlock
> diff --git a/tools/testing/selftests/mm/ksft_mmap.sh b/tools/testing/selftests/mm/ksft_mmap.sh
> new file mode 100755
> index 000000000000..2c3137ae8bc8
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mmap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mmap
> diff --git a/tools/testing/selftests/mm/ksft_mremap.sh b/tools/testing/selftests/mm/ksft_mremap.sh
> new file mode 100755
> index 000000000000..4101670d0e19
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_mremap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mremap
> diff --git a/tools/testing/selftests/mm/ksft_page_frag.sh b/tools/testing/selftests/mm/ksft_page_frag.sh
> new file mode 100755
> index 000000000000..216e20ffe390
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_page_frag.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t page_frag
> diff --git a/tools/testing/selftests/mm/ksft_pagemap.sh b/tools/testing/selftests/mm/ksft_pagemap.sh
> new file mode 100755
> index 000000000000..b8d270fdd43e
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pagemap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pagemap
> diff --git a/tools/testing/selftests/mm/ksft_pfnmap.sh b/tools/testing/selftests/mm/ksft_pfnmap.sh
> new file mode 100755
> index 000000000000..75758de968bb
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pfnmap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pfnmap
> diff --git a/tools/testing/selftests/mm/ksft_pkey.sh b/tools/testing/selftests/mm/ksft_pkey.sh
> new file mode 100755
> index 000000000000..ac944233b7f7
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_pkey.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t pkey
> diff --git a/tools/testing/selftests/mm/ksft_process_madv.sh b/tools/testing/selftests/mm/ksft_process_madv.sh
> new file mode 100755
> index 000000000000..2c3137ae8bc8
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_process_madv.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t mmap
> diff --git a/tools/testing/selftests/mm/ksft_process_mrelease.sh b/tools/testing/selftests/mm/ksft_process_mrelease.sh
> new file mode 100755
> index 000000000000..f560aa5e4218
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_process_mrelease.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t process_mrelease
> diff --git a/tools/testing/selftests/mm/ksft_rmap.sh b/tools/testing/selftests/mm/ksft_rmap.sh
> new file mode 100755
> index 000000000000..974742b9b02f
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_rmap.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t rmap
> diff --git a/tools/testing/selftests/mm/ksft_soft_dirty.sh b/tools/testing/selftests/mm/ksft_soft_dirty.sh
> new file mode 100755
> index 000000000000..d160d7fea0a9
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_soft_dirty.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t soft_dirty
> diff --git a/tools/testing/selftests/mm/ksft_thp.sh b/tools/testing/selftests/mm/ksft_thp.sh
> new file mode 100755
> index 000000000000..95321aecabdb
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_thp.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t thp
> diff --git a/tools/testing/selftests/mm/ksft_userfaultfd.sh b/tools/testing/selftests/mm/ksft_userfaultfd.sh
> new file mode 100755
> index 000000000000..92667abde6c6
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_userfaultfd.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t userfaultfd
> diff --git a/tools/testing/selftests/mm/ksft_vma_merge.sh b/tools/testing/selftests/mm/ksft_vma_merge.sh
> new file mode 100755
> index 000000000000..68449d840680
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_vma_merge.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t vma_merge
> diff --git a/tools/testing/selftests/mm/ksft_vmalloc.sh b/tools/testing/selftests/mm/ksft_vmalloc.sh
> new file mode 100755
> index 000000000000..0b5019a76612
> --- /dev/null
> +++ b/tools/testing/selftests/mm/ksft_vmalloc.sh
> @@ -0,0 +1,4 @@
> +#!/bin/sh -e
> +# SPDX-License-Identifier: GPL-2.0
> +
> +./run_vmtests.sh -t vmalloc
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index d9173f2312b7..1b4546324ba7 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -2,6 +2,10 @@
>  # SPDX-License-Identifier: GPL-2.0
>  # Please run as root
>
> +# IMPORTANT: If you add a new test CATEGORY please add a simple wrapper
> +# script so kunit knows to run it, and add it to the list below.
> +# If you do not YOUR TESTS WILL NOT RUN IN THE CI.
> +
>  # Kselftest framework requirement - SKIP code is 4.
>  ksft_skip=4
>
>
> ---
> base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
> change-id: 20260119-selftests-mm-run-suites-separately-6a4dada136c4
>
> Best regards,
> --
> Mark Brown <broonie@kernel.org>
>

