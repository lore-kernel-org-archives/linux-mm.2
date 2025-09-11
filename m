Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08BB0CA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 09:13:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53DBD900005; Thu, 11 Sep 2025 05:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5151B8E0001; Thu, 11 Sep 2025 05:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DD2C900005; Thu, 11 Sep 2025 05:13:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 274208E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 05:13:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C05E41403F8
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:13:27 +0000 (UTC)
X-FDA: 83876406054.13.28C8575
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 690C1120009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 09:13:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HS29jZPW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KgSRRfhy;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757582004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmyrphaNhjZ2Xu8763UrLVexo8Fv0j7TMAWk8RUty7U=;
	b=KPjXZA8jxb2RVJ7GA50uK/xf12FyqUOAhq2C0OVZow0f2fyEB0UP1ri2TNe4twwrjipCws
	JloAfqE7Xy7wqJ1Y82x79H5a6T4oycP85z9bFbkoi3owi3kqgzfQO7zKzmTgbvBc5c3rC3
	3Ga2r8eRx+C8549B/t1/bS6Xf8UiGzk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757582004; a=rsa-sha256;
	cv=pass;
	b=EJrrDNKZnGNOsR1Ir/qgI/apgv2DUQEcGAwfPQQ22r3oIFHlndHvH+c4fqcCrcppL/tq5q
	3nACErVP7EkYBe0ypmpU1CFyVVZ+Lw9jJLMteZfREG+mGUObCN8vVQ6OJqh9HlRR6pem4n
	PUmuzohuXfUKrV+eczPdAuCc1i93VIk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=HS29jZPW;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=KgSRRfhy;
	spf=pass (imf29.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B8fmkk020336;
	Thu, 11 Sep 2025 09:13:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=QmyrphaNhjZ2Xu8763
	UrLVexo8Fv0j7TMAWk8RUty7U=; b=HS29jZPWISIccF1A4+QsrO8CmMWEidrL3R
	iAjURt2OCJ4iP/uPmfubFaLNMv45MXrKXjNCUp5T+Of5NVgiTiDkfZZbfMFfoFkJ
	lU5HQDeE+O/lIg0avHwS+L/hLwYiGMfRpJcQ8u3FBs5/cPc9WSJ44dox/59iq597
	IyrSyRcuQZIuQNHN+bQWIlLFQNqWyNh4jRDyDUUXTEuz7IlHXw2ORYjD7XPVJvpf
	QJjK6bixk/AeMYRqq61iFj5Ff9KbxWxViPW0nkCg3f7QyMtBIJygJH9m1XMkodnM
	ZAnGAnoH88bSGkTe1a4dl0p+2nReLbe5ROAZtvPvXTd2T+Zq2lrg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4921m2wvr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:13:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58B80K8l032885;
	Thu, 11 Sep 2025 09:13:12 GMT
Received: from sn4pr2101cu001.outbound.protection.outlook.com (mail-southcentralusazon11012066.outbound.protection.outlook.com [40.93.195.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdd5uw7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 09:13:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TXAP5cZGttDC52BH4Cpx0nGfzUnB6Eg3JBM/y/SCiPKbdkl34flJVunh4Y4GuVsxO/wrqRj4FfeFYrLX+wI+JvIJ7OeJ75VG6lPUixULKpwgvdruWxwQi8G4j+Z+HRYKXH7tkTdeyp6+/wS7J8aRk3gDTOtqwodLugce3mPs3FNrc8qR7iObFlr8/RdFY/YTt9PAJhOuVEdBYzuzxZNnUykr793ycHToniTl3Ft6HDsJAhyRKRqcm9LIkhvTQnK9jZCm8UJTAWB8JckA59ZlxGL3a4+wipDaI2Y+54492IOuzVxAqoL2xH+Vlxv16OYnw25WmuZggYLIueSPdDZcEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QmyrphaNhjZ2Xu8763UrLVexo8Fv0j7TMAWk8RUty7U=;
 b=p80weVsLfHTc4UVt1/bWWJfZKPRUrhAAvQ/WraNj6ELT9M5STwkM4IdzPaW2cUXx9fKMHesi+9B/mtUzjygtXuycuOhUz8SZGdDqgTPnw5wTOmbdi85wiqp8C69xjn8FWYeqCK4yp6i1hlxszJlHw9Fz40weG8aD8xuk51eStz66L0pqASQ2oH2grlVcM4933VQokvdsYxJkz1IxmgVPZ8723gzE0Cm17w69A0Rv38JcxznGIJCYqE/02dJiyat2Dj4K/5KGFEI4dg3JxY9M8sWwzb85LvgBlbp9aX5OQ1t94NHMpAW23mZzodQgQVMoraY0H3GqvPt8eUq4KN5uKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QmyrphaNhjZ2Xu8763UrLVexo8Fv0j7TMAWk8RUty7U=;
 b=KgSRRfhyIh5JVcfhqUfEIL785leMOTBEz4Nsm6jO6ApfOY/CFYmfC1hQr+rIUAw1bwDjUjG52eXNVCSMvGoJGSnHcYlPRf+nhI11MYxOgCPlD48D20STY0hBo6fLJ3XS4eW2knFHMrjGEfxloVY8YRYA+r423ft1Rflc7GsT5SI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ0PR10MB6430.namprd10.prod.outlook.com (2603:10b6:a03:486::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.22; Thu, 11 Sep
 2025 09:13:10 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.021; Thu, 11 Sep 2025
 09:13:10 +0000
Date: Thu, 11 Sep 2025 10:13:06 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, maple-tree@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Hildenbrand <david@redhat.com>, Vlastimil Babka <vbabka@suse.cz>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        Charan Teja Kalla <quic_charante@quicinc.com>,
        shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com,
        bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 6/9] mm: Change dup_mmap() recovery
Message-ID: <c4cae5fa-9136-4e9a-b6ac-6073ebbabffb@lucifer.local>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-7-Liam.Howlett@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-7-Liam.Howlett@oracle.com>
X-ClientProxiedBy: MM0P280CA0033.SWEP280.PROD.OUTLOOK.COM
 (2603:10a6:190:b::13) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ0PR10MB6430:EE_
X-MS-Office365-Filtering-Correlation-Id: b8e1b379-716a-42bf-335b-08ddf1136d95
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?F3Ju1oTdOyxrAlwu6Ntu1UEYiMsNjdwjGrmG/X7sUbJkCIIwty3sqJ1H0j6H?=
 =?us-ascii?Q?vFjyOIdtJqp0+3V3j56LP97wZje0nLzgR+ygig2+9I1aIcbQ0VdLXZGPborv?=
 =?us-ascii?Q?xn9yiMjeqYiAcagKnPCcS0lU8Nn7+mmslMHc0m+l3JkCQdP5iSjG/uMLrNDd?=
 =?us-ascii?Q?d9Q2CXM6DNG9C3YVF6wj2Vy90ksYA6LDoRPhIJYQfexx1Uq/168cEqbnmwCb?=
 =?us-ascii?Q?vpOHu401N9xLmYYvbzHzZoZ63AB2Jg5U4YXAdE/QMaaywieOzXofcxvAN248?=
 =?us-ascii?Q?v84a80ABzEOvSf0NqKo8zAJhDCnwRh0eoF5G9E6rsrf9rjX/1nMhIax/mhoG?=
 =?us-ascii?Q?ro6ppqMj7tRED9wNOcjqusbwWywNwbq6oZixSja9pNizYjx8twCzIrX9Ljko?=
 =?us-ascii?Q?X4BE/xPi20c04FD+B0OmXsHoN1M7ZfCR7WC1xA0Vv7hVO9qm6ycUJhF7em31?=
 =?us-ascii?Q?cR1KIlfzC3lxv+SHdoHO3uNR6Dfse6MT0qn8tJcuVoeL1SHcmuHaX0TOcFgi?=
 =?us-ascii?Q?XxjNRebJovwCHH56cdgUdJw1aK/LzHaml03pKXnll0qOTPUgEnZwgUo+3s5+?=
 =?us-ascii?Q?YRdhyYT02PFnE22KN9J0do+qRgM1wtH6qfeHvUJwY8cS9sElDqhepbizevct?=
 =?us-ascii?Q?t3IZ2hOR2QwLVh4fw4GBZ1Jbo5vjx/3L9lHbBGxTZQfu/MQqqH96MqSKXHxv?=
 =?us-ascii?Q?Hi6BCokQCq9UNVhputlD4HFC0U2Epu5Pl3V43kw8eLlFKqOEtgp6T92MVcDN?=
 =?us-ascii?Q?+OmaNB8IU53cF3B9q7TJDsT9LSWhtvUT122axScEF2WKwocF0omUVa7QZW9Q?=
 =?us-ascii?Q?lzAMxjLFniMCSiOryCvBcYyxaDYJIyrrnxNRDJfWMjaA0PWlPsoqV72f9YSx?=
 =?us-ascii?Q?LA9dqEokxiszWMZwVwMr6RIqjL8UYS8rMt9bcf6GWqnLdx1zLs/HC4+PJQId?=
 =?us-ascii?Q?ULEv8d3zfDHcYIYxWJ+LUyT4Rj3U3ra6mpekS+OYg3uAu1e0nYG76W0oWTI1?=
 =?us-ascii?Q?k8oPjJ0I/pCDiIqZ2PO4AUar6FD3+hkVtfpPI5imDnJ0AsHKrYbDja+/0hWd?=
 =?us-ascii?Q?4fi1yoORAAIEBFINxUaJSkh0kyyffOqlxpBCylC1ims9GiSeE9XN51S6w703?=
 =?us-ascii?Q?nSvh8th8gv44Bo1dy6R8s3igXBSNcoMhOw/TFi/CqO4UWzoZ25ijrX3IMobr?=
 =?us-ascii?Q?n1OFkp2cKVlk8ZwGYhtyIqkAyMbUAj3e90jlpeoPLteRvR0gdO7j0Uz1Z2dP?=
 =?us-ascii?Q?m2V86WEsH1TmzvtPBvIbV2MpXMU6Z9BJ13PCfeqGQ+La4fdcOs3lO/8yDL27?=
 =?us-ascii?Q?u3A6NFhfdyuCZChWJLPwy+S3z+/GnorwSCPSUFPTwYyR+1I3IsFcb/woPOoV?=
 =?us-ascii?Q?LIBwZYAGnDQxkdgrnXqvlCkRfyOXOqaeh73K77qdqPFAcH+iIsCMZcWKqKmv?=
 =?us-ascii?Q?CwmlEjnO4PY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?L/dQoKjUXEYm7mNNshiVp4mFCo2Ar0duOTKg9CrQiWrf7yvo6IQoP8/MsbVf?=
 =?us-ascii?Q?UC/lMpaNkc0XHofBOIeUC5VFsHzIvh2x2HmZSKxXg6fUunbwV+JAxgUlbM2C?=
 =?us-ascii?Q?G+6r/502pv4us46ccOFBWQgsLquSLsFRee1De4UJsT5SkfKGFJPy/usTSJ/1?=
 =?us-ascii?Q?fYUMUApakCs4hcFsRAKO3HNUyE4U+xQYyDqkEshytePts4w/KN88u1mv60jA?=
 =?us-ascii?Q?eZDMMN6Wmvq82ssdXPzfdvM9Vb8kP8/W/cINUOG1HjFuE6ghy6V30gid5IXh?=
 =?us-ascii?Q?lDr0/JXN0rWxFGiI0gdShwS4nV1VwO0d+D/tcfnQRS/ZtNz6zp/uOwOMMCwX?=
 =?us-ascii?Q?nAIK/zqwoxQmhoxa5eV5cVHDFjqWsESqPq4fjYPxutPZutZbB/FM348nwAjp?=
 =?us-ascii?Q?FpWNzZgomIfTyaulCdSkKh/+MajQnzl/DTeAyG35epCQEOVw7p/49cTSufcd?=
 =?us-ascii?Q?NZtniVyinJSzkDF24BViI25h6pkuMdGVnfoLeK0BGEpQ8hHybsNNGOMEFeVw?=
 =?us-ascii?Q?R+9G5GDRT3vo2K7T1Je1q6ytWppXV+J8l/XZdIIE1XyabmHnlPdwciuqxxgG?=
 =?us-ascii?Q?hFqSt5/usIRJyUjhubXB1AG3pylj7kfqLcH0G9k5rUxaoQ4P1zgliqfg7s5c?=
 =?us-ascii?Q?MtucVTZVfo/2ROmulFM+b0F21BUfhLCvFYvmXJI5HBCFot7AuZyILMWWW4Zg?=
 =?us-ascii?Q?LL/9+SsRFngeH8R9spqR4jytV4bsPdoxUm+WT3eGzHI4Tts4zhsJ4wwpQPDk?=
 =?us-ascii?Q?uDeuPk3Rg60fqgl5zki++9Apt7Oe2Mp5PPRCgtXNgK5hQ10AweYPf5PwLl7t?=
 =?us-ascii?Q?PfehdxXzHgx41FMzieqXTX+JdZfGSodkg6gJG3tPw2wwaRIJP+5nQvL3qkD5?=
 =?us-ascii?Q?/+F7FGP1j8shO77axNQSywj+QEbGPJe8dHmz9kz52hcr0ymN+kwwx1wP4JLQ?=
 =?us-ascii?Q?olmHBvHCndvS+yjZVk15zDKmAoeJesz8M5owPNr8sV4OATkqA3X7ZdKzDgug?=
 =?us-ascii?Q?/me4+RepB4y1va9kg6gcycgQH40lStJ8lrAEVa3F/ZCZMe34p5Oheq1vxlAn?=
 =?us-ascii?Q?D5P/2sQqr4ueNK/98PX94a+ZOsIukyMSctQDxTyXxlsfPQ6wzJHkJW/8ZL+5?=
 =?us-ascii?Q?du6FlqI2t4bTmn0U1QdSj8i7omZ3KP8xezwtzQsCLgUc3Oc0Flzqf6XtnAjm?=
 =?us-ascii?Q?YJRc9HDr7QIzHa5cUx37V0QnhjCTh8URg8yxNn2T1gkiTOdi0Cwd5oawoqsc?=
 =?us-ascii?Q?8geeqCzYAfsgQxIRZ6FbhW4Qo0q8hPfr1pewBXr4roRhqFhHoHEVldk9j3Iv?=
 =?us-ascii?Q?MF3s03ts/lVX9VO7rvkoImJsZl8q4N2FylgTMq3LAgD7f5NOeQ9xQ3j3+/M6?=
 =?us-ascii?Q?nFjEITmb62ibRv9Hz/zlI89UD9/zy43S6VRcC0PS3bcjrodGdhUsocfEaxOb?=
 =?us-ascii?Q?tBCnXGLK7Vu20RlJTIL/pzGXiIEOUZyxqgBLRaORc57UZ6hmQHPYuPwSkg9o?=
 =?us-ascii?Q?d6QzEzE5CIeBCq8O5OK+ao2EY5aQjKrFb+zVKHBV2Co+cLP4KtAYNGD5037x?=
 =?us-ascii?Q?sfSVKjI63PNXV0aTfx7TzwIjLDHeWDpbIOKIgJNd+hiaxBNCO7skliSzZZmh?=
 =?us-ascii?Q?dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	wIB3ruKpHqz5BxhRmm+G4CwVag0etQT0OHzf55TQ3OMgM8VmsccIJT026XvnEg20DSPPUEnr9gDeBfpPpJ4tXhXyZGV+dKZJjFx2yAabvk22uRJ03AWFQRY5/lITtA9uRKxP6cihXoiCZ4Veo3m7oLcNNdL+GpxB2gicPxDpkMVx7qsNjKbz7WBnBKSwy8r0lzmPL6WlyST3mdG+HxHKSl7LPc/P4gompSfRfBvz6PKaBVUXcmS6kWIcORf20M+AsRiRKtVfST9LImvLQKK4jdp8Hfuspq+0KgxumISRbnG1DvFxugjc6dPrBRoGZlCttOFGIHyrFgfePZBhk7vf7A5cbACwxJqS6/VzzyiIWLAHDcIM8DOfw04fTFYFeX3jHrEw0at8Ja8GAyS6lAT8AymmdNSsoBcQLUr+GcxM2zojolr/CvO+DSiKK10dsd67QcDKXK3mCx/UwFY6L76hLNtvLJWZ1HBwr0BnZ0YXXmGGbA/9XPrP1sa2sGHqeTWSgITsatSVAaqRaQughRZedioXQrIQ/U6Nmq46eQc/JSEIE3eWRbb5V9zz76dIaqZ+mws5qionUabgi3DfQ/k24I4FdeWJ6WmIU5qqJVdLJ6E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8e1b379-716a-42bf-335b-08ddf1136d95
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2025 09:13:10.2612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CSMvRwtgCOMAqYeBkwGi0nARJVcFguYeWFWq3WPEoL06Zp9sbHPBEFzu+GQc1Enr8RCRIk6ZcpxvkQhSqyg5QZCeF9HeXGEDqwGWJvAjm5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB6430
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-10_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509110082
X-Proofpoint-GUID: WZjythUcME-tpBrvgll-dO5jitOiIO1_
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1MSBTYWx0ZWRfX6AN893awNzCt
 uXI2c4RkENWQlo2C3k2byukRHo9EIr1Cc702AZbYBWhpNu1fJc3UqQxHIuTHmotoV7UmkLDpslZ
 DtQ/sS2Je9Y8iuE96/daxTlW28Ktmm11DswXB+uQFzyhL4FvuuGBnKvmjtM9ZwSDP4dQEP3lO2H
 q00lylZAewh0IRLRYwJugMH1EtNkgE8T5VH4E8NHOXyN3anAWj1uPfjzv3csfAj7h0HsbvcfEXc
 /6WTt0FaVZOiZmgh+kNKyW0XQqbnJI0/D13lsQL14YBl6T7VPowUrllHkXOnEtZBQB3HwVzAb6m
 Nj7V3lb6sr3QfY/6VC8VMXOv3h+Vmkyot7M6WA2wSfAz5N8vGLNvLh5GepNAGvoixvSYbTVG8Kd
 ugSoVugj
X-Authority-Analysis: v=2.4 cv=Dp5W+H/+ c=1 sm=1 tr=0 ts=68c292a9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=yPCof4ZbAAAA:8 a=_CHCh9fYoIstuK1Pa9wA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: WZjythUcME-tpBrvgll-dO5jitOiIO1_
X-Rspamd-Queue-Id: 690C1120009
X-Stat-Signature: dm8fihe8ed4spbh1m8x65phqgku5zmiu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757582004-383931
X-HE-Meta: U2FsdGVkX18bs5mEAn0y5DFa2LrpZbBf7GdGi97hgJihTBV1yvK0IzXKKPho2C3x0DW0pQDaIikvfjqvtBS3JXi6ryUQ0y0iOTKj6snOCPGjrV1C03RngM4PioOkpXdRKdY7icAM+Szeh8R1nfreCUJ/t3IaEQe2wuYkMWppbctsB/s6CLRfH349RyRshAykYSb/HA1NRa5SzxTglq7DbatzFwjvCXpii0LySe0sJUZEIcMyUOM0MBaM3QMOdd8TWy4DkbAnfl40HmQCy2Wq8AjJ9QAVfaXMcTMJHzO09V2R25vra8rUYifUER3a6FTvp7HA4ZggIO/XALus1gPp/cA3szV+eco2niiv/vsfqijztyUdpFtvbsJcFEE2f96eOWO1WasaRf3ApkAHVPtCBTAhJNQck0CBxGKDAxmCrBKXKFCIj5L/3LxFJ9CqtMdQLISygEiLKfMcnTccRa4B5GGkaQh0K5cNle3LlFu11XA0994wpJYoJb32a8fkA2zrxs/EA07jV3+rXq2BcOMIEdXUw7q0urKVrkAlrhFGQ9QOIAQQlmGCGIAl159bevDlOxErV9afAO64CWEusCxn5gZrrLH1v8da52EZfmt/fyi7ls9sSdMvaNjr0HHQQ97aXHX83dVz5WyNjRvIL/ynPhpWipxHZ5T8KgLAc5a6fhTby9LnC/NNBP2rhy9JVdN1S+f69f+cPeBcCjbWQcWhJmi9LwF11jAuyHoJ23OtguIC1Tq3uvuopEz1G3A+1Q18qIy/U2QZ/JGqr2X5sa8eaFXRS8BTdGo0oftO2Gebaq+6T5SDFNkDbPP7x11xqExr041srDxMt94AmLkynaOwaJFkTe5ItSIx+E7ourrQK8pyw+jBAPC4LG2M8tq6fo6jvE1uX+BQi8iGd34CJteBMMXzfirThJHJpbZCBUGsHBnHKr3fJwOYuvIb0lBytaqhcSsR2evLTPIQnY2ZUoX
 pmIwY2Ip
 tviTfouf5KJzWxgm0AaBb/9jY2p9+kizCeJ5K/D18MTZ4eIpfvyJWPfBFh4oN5HriLws166fg4i8bJz1VKvxOhUwc79HmNe2xzGE1eAIkOX8r0WuhH3qpfOyUO5V74ZEiMzEB94zo9BOHtfl3zlCtxMAP2Ks9MpioWZ3o9oC8JxSF1vcEGaql+TdXezjuKRZJrscVvOedbL5LKFOvikTu+ZCH/YGE0U9QG9LPo5MlizHRvvYhrYCpj08ndRmVTLiq20TvN8yImLMMNlldvP/ASnV2cLeTHmlSHBZGe8RrfQ/KcrWgLmTpllR1eksOt4zsxNf79jTZk/ZWOKkUFppyo4+CiLprjAzJbHmfYZk4lGhyzCUYe/wo4T6HY1OfBqPT9hqChtv172WSTG0+0Oeb5nGhSaOS6o0fPev1ckA+87MOrC8QWna+9KJwWTrRL455qTkInM/RaxPYg+DiWQPxwwA0eWLn2092UMZRv/OGXkQ0UaodaaQ0RZs5HG/E4HZ/q4EX5CrCnVU/i/p8xz0VdJ26vJhiGYFXO0mVYW4+hto17WvLXDEw/TB7gGp87dmEcTXDw9UgHa8WlMZzyCOzt0HcSfY4e+e96TEgj4YKuP89L4kx1FK/tzdzxAsxFKfpmFcfw07OLXLV/2yiF2kyoC7NNT/sxEFcKusxWI1+GG3idaYfOPRYcuk/DrO48yspWRP6lO6NBv0Q5AEL/MNyvk/PUQGj2vp6i/dnN62vVA8LklSooNwM59XXUQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:42PM -0400, Liam R. Howlett wrote:
> When the dup_mmap() fails during the vma duplication or setup, don't
> write the XA_ZERO entry in the vma tree.  Instead, destroy the tree and
> free the new resources, leaving an empty vma tree.
>
> Using XA_ZERO introduced races where the vma could be found between
> dup_mmap() dropping all locks and exit_mmap() taking the locks.  The
> race can occur because the mm can be reached through the other trees
> via successfully copied vmas and other methods such as the swapoff code.
>
> XA_ZERO was marking the location to stop vma removal and pagetable
> freeing.  The newly created arguments to the unmap_vmas() and
> free_pgtables() serve this function.
>
> Replacing the XA_ZERO entry use with the new argument list also means
> the checks for xa_is_zero() are no longer necessary so these are also
> removed.
>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/memory.c |  6 +-----
>  mm/mmap.c   | 42 +++++++++++++++++++++++++++++++-----------
>  2 files changed, 32 insertions(+), 16 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 24716b3713f66..829cd94950182 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -408,8 +408,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		 * be 0.  This will underflow and is okay.
>  		 */
>  		next = mas_find(mas, tree_max - 1);
> -		if (unlikely(xa_is_zero(next)))
> -			next = NULL;
>
>  		/*
>  		 * Hide vma from rmap and truncate_pagecache before freeing
> @@ -428,8 +426,6 @@ void free_pgtables(struct mmu_gather *tlb, struct ma_state *mas,
>  		while (next && next->vm_start <= vma->vm_end + PMD_SIZE) {
>  			vma = next;
>  			next = mas_find(mas, tree_max - 1);
> -			if (unlikely(xa_is_zero(next)))
> -				next = NULL;
>  			if (mm_wr_locked)
>  				vma_start_write(vma);
>  			unlink_anon_vmas(vma);
> @@ -2129,7 +2125,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct ma_state *mas,
>  				 mm_wr_locked);
>  		hugetlb_zap_end(vma, &details);
>  		vma = mas_find(mas, tree_end - 1);
> -	} while (vma && likely(!xa_is_zero(vma)));
> +	} while (vma);
>  	mmu_notifier_invalidate_range_end(&range);
>  }
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 0f4808f135fe6..aa4770b8d7f1e 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1288,7 +1288,7 @@ void exit_mmap(struct mm_struct *mm)
>  	arch_exit_mmap(mm);
>
>  	vma = vma_next(&vmi);
> -	if (!vma || unlikely(xa_is_zero(vma))) {
> +	if (!vma) {
>  		/* Can happen if dup_mmap() received an OOM */
>  		mmap_read_unlock(mm);
>  		mmap_write_lock(mm);
> @@ -1858,20 +1858,40 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  		ksm_fork(mm, oldmm);
>  		khugepaged_fork(mm, oldmm);
>  	} else {
> +		unsigned long max;
>
>  		/*
> -		 * The entire maple tree has already been duplicated. If the
> -		 * mmap duplication fails, mark the failure point with
> -		 * XA_ZERO_ENTRY. In exit_mmap(), if this marker is encountered,
> -		 * stop releasing VMAs that have not been duplicated after this
> -		 * point.
> +		 * The entire maple tree has already been duplicated, but
> +		 * replacing the vmas failed at mpnt (which could be NULL if
> +		 * all were allocated but the last vma was not fully set up).
> +		 * Use the start address of the failure point to clean up the
> +		 * partially initialized tree.
>  		 */

Thanks for this! Great comment.

> -		if (mpnt) {
> -			mas_set_range(&vmi.mas, mpnt->vm_start, mpnt->vm_end - 1);
> -			mas_store(&vmi.mas, XA_ZERO_ENTRY);
> -			/* Avoid OOM iterating a broken tree */
> -			mm_flags_set(MMF_OOM_SKIP, mm);
> +		if (!mm->map_count) {
> +			/* zero vmas were written to the new tree. */
> +			max = 0;
> +		} else if (mpnt) {
> +			/* partial tree failure */
> +			max = mpnt->vm_start;
> +		} else {
> +			/* All vmas were written to the new tree */
> +			max = ULONG_MAX;
>  		}
> +
> +		/* Hide mm from oom killer because the memory is being freed */
> +		mm_flags_set(MMF_OOM_SKIP, mm);
> +		if (max) {
> +			vma_iter_set(&vmi, 0);
> +			tmp = vma_next(&vmi);
> +			flush_cache_mm(mm);
> +			unmap_region(&vmi.mas, /* vma = */ tmp,
> +				     /*vma_min = */ 0, /* vma_max = */ max,
> +				     /* pg_max = */ max, /* prev = */ NULL,
> +				     /* next = */ NULL);

Thanks! This really helps.

> +			charge = tear_down_vmas(mm, &vmi, tmp, max);
> +			vm_unacct_memory(charge);
> +		}
> +		__mt_destroy(&mm->mm_mt);
>  		/*
>  		 * The mm_struct is going to exit, but the locks will be dropped
>  		 * first.  Set the mm_struct as unstable is advisable as it is
> --
> 2.47.2
>

