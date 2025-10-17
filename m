Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A16E5CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C24F8E00A4; Fri, 17 Oct 2025 10:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A868E003B; Fri, 17 Oct 2025 10:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA40D8E00A4; Fri, 17 Oct 2025 10:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D11E98E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:55:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A1D581A0215
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:55:33 +0000 (UTC)
X-FDA: 84007904946.22.08C4461
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf12.hostedemail.com (Postfix) with ESMTP id EA16D40011
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:55:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=S9xyXkxD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=M4s3T2h7;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760712930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nXKN/ZmGQRS5IB+mCVlmUra6K9doAbMnP1f+Fjyn4U=;
	b=ADUsdY61AYdET1wxawukRsyBQAUztoFikQFMVzkBPbPna5/muuuXMbWOXq+TifxbGZJg+Q
	KzLKRYp7T+g27LsVZQaKYXHwBFpBYyBXjg8tMVFmexozE4KnpvjrRdoZU6Aztt6pscvoHt
	gmHhxDQy2Sc9GjkeT/CSwlMWLNFzYRo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=S9xyXkxD;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=M4s3T2h7;
	spf=pass (imf12.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760712930; a=rsa-sha256;
	cv=pass;
	b=6BGcJWDmqegnl0KmKh7p79bno44abXPW8LIUkZvEETzrSB3JolV14QSukdVjvdT8RI4xqH
	mQMwDJerxHJs9MmJ2u4Wsa8ZQfR+W2xCq+L1xTQyYMI6ZLL6/XmlqFUMwxYBJWkQTASYJk
	MOrg8/v+GrPsTGQVi5QFaxgdNIKr5bc=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59HCdbjh019437;
	Fri, 17 Oct 2025 14:55:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=4nXKN/ZmGQRS5IB+mC
	VlmUra6K9doAbMnP1f+Fjyn4U=; b=S9xyXkxDFm3nAakMzcgaQrQKDgX/Bmo3yl
	s5bRbykXoo1Ubl9RRq018TDZb+e2REU6RRiSF0p4WtI+PI6Vp+Pb4D0tfFfyFII2
	Q3zWwkpv6lt2VnUHRnWx3AA8fpPKq81flTAdUZI6tZr0KTbP/X95nHrZC29quZQG
	u1AnV5OVcwZWMMwlSyYYWwcKtPO+pPDtuIsDSWXZxTBzXhdveM4X0qFAjIkWieUa
	FlKgzkmwjTvIO6BhAI+7NiIQFb/36wBa56QYACcHnYlA1G2iJd+SWwXnvTenCLyd
	ruVaeu55aOOwhUuM7lSFnlCMHQAQ2ATBu1LenPL0BgpCYTxvYKHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59k4wh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 14:55:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59HDxjR1025851;
	Fri, 17 Oct 2025 14:55:22 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011034.outbound.protection.outlook.com [40.93.194.34])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpk7073-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Oct 2025 14:55:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nmGITJuiaTeZ3WAA8FF119yB437x5C6SDTgGDarQaaMb11QgSVMC1kTVuAN6zojkAdPWsKDBAepvVhX+NXCHVdNcNNX0HT9RcgbLXWLsFhzWymLig9aS3Drb8Grf0SIPfZZ8Ie/mim/AxtUn4l6OxIKL6tW2uGjMhg+0jh4pRoqz0x099xiz2/yogm0LvAdoCVLFK0rvSgBJd2Opg1orGESq+aIZF5Y97xP5UueqyAwsEwbeSOnz453qhLzSrLMckalAkaMMYWegCKGEv9I2DeBd9qr/EpDv0WCpfP0zu5Quij5VUOrm8QZ5cVwHcr1CqAoXGTiD9NQojThOggiPrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4nXKN/ZmGQRS5IB+mCVlmUra6K9doAbMnP1f+Fjyn4U=;
 b=jvQtwOxLtxPxutR4v/6gro1Z32HKjjeX7m+5128M3vZjyu9is05hyQIpq7k4M+sIiSJn0y+PINzbKKE8UGSczxra+pmVEPHSC1tpFvIl3C6SqjUVHI824KxJ8T+//+ntA1RDpmLG98Nws4kgxg2/1ce02R9e/L0wW3htbcxadi4DmUQ+AZzJKlOPkCY4htwXM3kKBLZs+7kLl7R13N4Uv+EDrLrKxK4SP9c2BCHsKwenQdSGy1Edbn9aHLzypmZAjRrJgUule8jz0g4PR2kwti9yv4iw31Az6HdO1unZiDgsnPS/2Hj4TII/TdLVLMxC0qba0li4Ir6Xr2DApe1/2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4nXKN/ZmGQRS5IB+mCVlmUra6K9doAbMnP1f+Fjyn4U=;
 b=M4s3T2h7rsHBIkARHG2jlGcfDVJI8zhtxvp1yH/prZgAUdNDuxXEfyZRn4roPGRQeyulbcwxEhdRYsWeoA9c6wcrVjpHbArkCRbm+DhaI1OOVDvbW/LT0oPAuZt34P7aOPSRUfr9/YdE+/UCQX0BO2QLj6fz/7bMzmR4W7SnFz8=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SN4PR10MB5590.namprd10.prod.outlook.com (2603:10b6:806:205::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.13; Fri, 17 Oct
 2025 14:55:19 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9228.011; Fri, 17 Oct 2025
 14:55:18 +0000
Date: Fri, 17 Oct 2025 15:55:16 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
        akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        linux-mm@kvack.org
Subject: Re: [Patch v2 2/2] mm/huge_memory: Optimize and simplify
 __split_unmapped_folio() logic
Message-ID: <cdd37933-d2e7-4675-82fe-62b7f0ccdd80@lucifer.local>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
 <20251016004613.514-3-richard.weiyang@gmail.com>
 <7ed84d61-0a7b-4961-82eb-fc8d38b77162@lucifer.local>
 <154924ED-0CD0-458E-B760-F9F0A92CDC89@nvidia.com>
 <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0a2c81b-a0e0-4457-b355-2363f30ecfb8@redhat.com>
X-ClientProxiedBy: LO4P123CA0222.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SN4PR10MB5590:EE_
X-MS-Office365-Filtering-Correlation-Id: 143b5b0c-0d97-4e01-a785-08de0d8d3086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?xqoAx/AVsH27WJGICiO/7Ff+aa1xp5Fm9hJ2S7C75diOdaOeysyW2NPvnYTm?=
 =?us-ascii?Q?5x6x6Yl7F6DRLTBrdrXXp3JlmCxEYwLWPjiAggEgBq8/0Dqm7rhNwbVw+aYO?=
 =?us-ascii?Q?B8fbYJsd4gE63C+2mlMOkK6EDe6qcNHan0qddYo+aOObwyklk/gQWRsBoeWq?=
 =?us-ascii?Q?cqiHqBfWp9s7Zb4Mr10vF6oMObITvwBKVMua3+aF1Ckl4EvpSJliCZoh69xS?=
 =?us-ascii?Q?wVBAxxsPSJYNjA7WKQ0z7J6k8ytBNpMW7w8wI0qyCzfHFLAEpnpk0ub1iHi2?=
 =?us-ascii?Q?EJu+WeofhV+a2JRyg6FGJ+f5PElPQZbE37zV5dkDNwgMiTSXE5vRGHvp36cy?=
 =?us-ascii?Q?TNa9+MEkEV4CwfBEcZmLkPRtercTdD3IKlib+BRF/Q/6KGvU8h07Byz+bx13?=
 =?us-ascii?Q?FjRry9+nfR6l8h8h4D0Mxzd2XODVQezDKV5/PxXz7SG4eeW4CqWxW/ORtNrt?=
 =?us-ascii?Q?q4BeK8n+0SOuasaUEzOZeeSZ/pqgj6vacBothf30hbUgaZRk8aQ/zHOooBK+?=
 =?us-ascii?Q?ONfqyhwLzboRgibF2oqeBRJDN3FyqLOomiOCTrlCD4m+UBSTBQzDirgX4NiM?=
 =?us-ascii?Q?aAl4Z7s+RImiVERZsd4OPaqoqVN9Sz6nQftOOrtC4HVvbpnuXGTIFYA8Zi6H?=
 =?us-ascii?Q?McD8qOErCGACdc4bx2G+6b6faxCEow7zQkqYRYwR0Zu35iGHQoeL9Xhf0dHy?=
 =?us-ascii?Q?bbkJybXr2gy2RKeC+2exF/DyeYYTyP3iO5XU5Q+chWffpIGynNnPhjbOprTA?=
 =?us-ascii?Q?0vFvoBYI1J+aF5m2Zf+kc3t8cV+R4S8H44kgKW6X48pCFABqe5F1VLNaSGAO?=
 =?us-ascii?Q?YhPgNCJWtuNL4OMS1zLV7GNTJ0nJonARA9tY/s0/QINF+XyfWzVy/cdcI+Yt?=
 =?us-ascii?Q?yk3qightn7rUx3+eTXj5fCqLwoNvc/75gNu5hNgANP+szqJCuLIvdDEy2KnJ?=
 =?us-ascii?Q?gjRg+KKoFlKLH5UaoCa/WAEwnzK8fi7b610URKQjPvDoRt4Nrsgg0VAR5pqF?=
 =?us-ascii?Q?F/WMqihC1XHTO5arFnlYBjMGYFn3aFLMAWdPs6KEysgj2YhonShXOV/9BEth?=
 =?us-ascii?Q?0EAj4zTxJBv6zeNZZTINUHwx0CTqNxmPguMncu7Z0mcE+pHXGQSwYe226/mt?=
 =?us-ascii?Q?lvywsmvSsz+mkGjWrm6z9JSSDB5ppojvcg8BgapbqmKtQH4K+jywiFpbnpEj?=
 =?us-ascii?Q?AODz9Ih5yuQLNRTWmwy91C2NhRb+fIcYnxcJFXJablqOqo46zYA+EVZtrS89?=
 =?us-ascii?Q?mgRAaWLQEM/WR3n2pC0sJbYmPnxkuGIC5v7dR/oa5Totbh0xb1rVH22Cp1V6?=
 =?us-ascii?Q?zhoLShyOC2qqaL2XdhL2V9SXm3RyfrknFM1iJ6iVwmtnIj1nNd6klNV5qE+W?=
 =?us-ascii?Q?sypSyV/1zxsVg4KXOdRgPzwpGziG384RLlQODreerMZQldVeaTFYbzdTp6VY?=
 =?us-ascii?Q?IuITY82doXXiVbAB5EqaQgJlWGE+DWC5K1mgWVc8i6gvsgQ/bWryqw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4TX3uG1L5fWB2Jvg3PPUSoRsniCyus62lwBuLCddUizlDJZuteHACdxaBSOM?=
 =?us-ascii?Q?tH5xbKa5DdqRTuJquB+gCdfOLMPZJKdIuaeUaFHBbgadcNyxmXW4ICN2G9eU?=
 =?us-ascii?Q?IZR7DNoBPLPSmrtdohSEP86bd+pAHaqKPY/qER0weoopPhv4CuPMpLBHaRxR?=
 =?us-ascii?Q?ZpGcbH723p8dEl9BPliCPWMVn1lczuqOAT9/ZrRn8aL7bRXKzOPpe/zfZjGJ?=
 =?us-ascii?Q?U92NRf6RWLiWOGHKWQIrijKJS4rXFkyLvcpEFQwJ+d7rcki5Q95FQakebhOR?=
 =?us-ascii?Q?lhtg+GdUqzhvs5bOmI4UUczzcJKKugMHvyBYX/rhFlhzeXMmJuU/s4wqBO/i?=
 =?us-ascii?Q?cWNM6o9zHseL1c0/ru5ohBbyM7dV0MWFeCRxJg417sCcgwrChFrh9qBOWLJG?=
 =?us-ascii?Q?9aL2te2r+aKbNaE22asPCNOtQDxzRQ76Lc698J3+xusrtbNeTM9kqFdC382w?=
 =?us-ascii?Q?BZMjo6YM3Mf6qW9TGyRbbsD2proov8PXrC2Yx9ePHfNJckt8i2JKKxLxmSSl?=
 =?us-ascii?Q?+EqdMRyDSxIWGmom+mFz5f4Kv8kTKBurZE9wQy4w8MZApbq3eWL/61oJpQKO?=
 =?us-ascii?Q?n6HTDa/mEx7aSQFwd2Fb1hCiSZ28xIF86RPsLRzmLLP/1VLaGHjz73UlTQS7?=
 =?us-ascii?Q?tlz9G1iSeOwOM2CJ+ySEHeqoh71dYCmYmfG9W7cisGqOttgdUZ9f8XaZr3/d?=
 =?us-ascii?Q?MPmp3+36fcYEhSSl0iPJ1d3TCqpxIH0wp8KuQjk4NxhCZ8QZkS6S15FyJFB8?=
 =?us-ascii?Q?F7JWJbzQCmRFtHC2sIio0cQSeckTEb+Gebih5igRVc13/BaeSDMNWycmIxSQ?=
 =?us-ascii?Q?2NptzN4xw/WDZvWJ+VE5u+Q1tsQXoQrNG6h/oOVEO7BnHHCM8r31AE5d+hCv?=
 =?us-ascii?Q?nWcBzVIbLNTL4aVFuS06zCwWjRKsJqBuzslnHfrpjJfDt6TZRX4EI1YJ+Mrw?=
 =?us-ascii?Q?ao8/3mlTefVbmiqRc8vS+9hKzftDDrwmKm7o4wJqPzXmOntm8zWcW+OwStlB?=
 =?us-ascii?Q?YxDq17edkuA0RNaAuofCRwqYJm/zXP2DSeDZm/k0qsvAL0bgqc0QQQNR00U8?=
 =?us-ascii?Q?B1LXQGcvg95QWT0A1yiBbG6Juux1XDKDrGTREQT1Ps1fCn7+Id1DPsqX82Tg?=
 =?us-ascii?Q?DXRB18W29aHDfwjg/i7PizwwOlfGOeQKKYpezFmAYBfDFfFGScAQHIaywfsO?=
 =?us-ascii?Q?XBXXizSUTEjdSUM2P65VJ0a39JJaMNzh+BBg+bHlLs1ILQ5jukTstHXvsnqq?=
 =?us-ascii?Q?9LtZyff623txK7yqUNpB6AcJZe2KL+W84PvtD2k9wHOzPRqbjmyWZ97yDwuC?=
 =?us-ascii?Q?WSp5DSXBQF3yQh5y2NFn2ZdsWspj4/WBE1vxQyrRJC4qR17jq5Tbqxl8Zcev?=
 =?us-ascii?Q?nx9o7NpoFEYZ19rEOZtotc+e15wNls6nvSjP35ncKX+5O/6+uFDi7UVKsJC7?=
 =?us-ascii?Q?It+Pl8MVvoZFDdlgqhF6XaKCAHHHKWCZpPyG25C4hBuiRD22a8un7hhA3cqP?=
 =?us-ascii?Q?fJID62AE+t9c9Xas8Qh70OjhtSp8C7ljimCur9VujJalbsGqW9LC9nF3skg6?=
 =?us-ascii?Q?XTTWVeEPcT6+djxhgYSzhy0ma6IMYlnOhxmHVEg8/6RqSEpczG79bkQjZWqZ?=
 =?us-ascii?Q?aA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6qpINFC/Yo+kEaNzg8cRXm5tyOfhKqpvjp8G98VSoV6aRpztuaSbDK6XNI0qWQqd/DyOWdywOLUIfvSOPOIpQyBJnrxJIy4TDDVvdBG4xCoEj4y4J4k45kTwtJpOKPDTkPSbxXg1P6SBlfkJtZhn8O7lmsYhOlpCqx/UioqeUisjBMOa2gQSL4teGs6AiO7YtnNVa/Kb1MktJ2Knq2RmEBT5b2yVuL7ui0o3iXHie07NFX1ZsasL9bMwNK6YgwTdYa0uE7ETwBhMQ28UyzLBL0EV9AzhW/bfQynBYhvUWsEbEIFc/klrfAHrQo7E/J3IxO0VD3tbxil7M5OrmLlr46zxVfn2y0E/EgraOgtUeM0GlbfiRiMkuemHBYVY3nOhQMOnRWijlbzBLqs7uoF496dXvEv9C+ox3sD6SDO0/WsTtstKQzgsPjCDsOZ8cOZRPArGZO0G6/133OekbLvrwjGp41hVJONfIUC2leYaGZ9ScNpKbA03MKC0n5/3CSDay0kLfDGCm97lhaClO4Fm+cFO+yNkAooK5iEH+M0U4T8i2MZ8x5v9862SB2knBMAfhZYVLMOXK+hAgQxavb159bg/94TDLPe4AH2U8SGX1Eg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 143b5b0c-0d97-4e01-a785-08de0d8d3086
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2025 14:55:18.9456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: U7JqFUIN76YbiRhLVgttJ30gHkwZZOrCR+jtW7TTmQu8O6BmYQhnzJboHF7FOiOR6VAOF3LDQxyh1KrIL5OrsZGmJFFeNO0fQA8HK4468bo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5590
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-17_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=3 adultscore=0 mlxlogscore=146
 malwarescore=0 mlxscore=3 spamscore=3 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510170110
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX4EhpbJ+FaZ2h
 GXayrGuUWlHj0VLfYrLIX3m0E5H3EWlmjLnVjamvkTsu3FmV3hn/GcXXK+QkKcbwFrKdn7eqDZD
 AD3AYkFeavcvuCqkp7l4FsUrKndLqmutdPoyX8vy0F7iTeeOfqnKEH0CLOEfNtxXvG9pQw+8ubU
 IfzgmuWzYTViBwwgy0xX1+Pouy21a9+BaFFLZVe0qEC+AO4Zprk0YCCtaUyis2OxaCXUy6tF2Dg
 uMmfCAitBwpOnHpTo/U0ZljKn5bCdbCGJRRSZM2ZksdOXPByUlEnbcEwf6SN16UkD3UIza2OUZi
 N6wyND5D9+IUF3NMFLIJP5XXWFs9aOOqTjlwBnZ1jDfaMMW+XegK4Fy0cT+eU6UkAGJAhG/L6t6
 j4NTBeJ9twU+WfKaXrZ8yjdi0XP56TWq0xml/bl2McipaObc6HA=
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68f258db b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=vGWFBcA6W7tnSFR527EA:9 a=CjuIK1q_8ugA:10
 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: p9NNh1oDEo7nytVedxfJWndvRrAL6xp2
X-Proofpoint-GUID: p9NNh1oDEo7nytVedxfJWndvRrAL6xp2
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EA16D40011
X-Stat-Signature: je8ggh5o45eyn34qsfdbmoiziu56osgc
X-Rspam-User: 
X-HE-Tag: 1760712929-474199
X-HE-Meta: U2FsdGVkX1/s6Otx3lNNqGQXtpykmTCNnExJ9P+xTYWL4CEPbjs/MFAKVEz6pfQrnRitFglXOnXitAc1WI5ReXbjLrToCFVK31kWHaH6Ke5m+GgxoN3c1Tp2bdYCqhRZWBUntPeFsZV2UhPgdns6HHY5Z/QlJtq1IeLUpNySrShVUa1Qtj/b2fA5y2v8iMd01O/g2bb2Od9u7UTGR45DNBita0LcYmX2cnJP9YtTo1BfNOXxD9binCk/VqeenBApiy6z0E0+rcGCGAdG4fDzudoURVilzkaYkgTlTdrXEth/D4cbgBctnUvrqeLH391+igaszS+RK33RveqAl4uueUDH7ePTNNPuLeyKvO52w6QqRZgwxlprIPDIelsTSSEzN2NGBx11RrmWTdiIhSl/dfaNu++Y8D69lvWndOVRTH6C4xvJnFfo4s0zLUeS+a0lmRK94ZHBAj3TBP/DQvCMk86WeQpkE8CYMt5gNqAF/X438GUBTJTNYfc1MrbxTaFGeTxIRXyCzI+WNiBvvoUoc07lcAbTPaWmFH7ELSq255VlqCxg5JHKLxNTlDW6HsFypKygNqi1XSxR12rTKqtj+xbnodOBaghXF2vsXID08+J6duDkjuWiIog57EDtew3JeNE/UeHHiLx3b05p/H9jNvyc0mn5YQenzMiX1OnOX7N3JumJbEsaHGNyYzjhlnps79ILK8LamWLjsfnsHI3eKHHbxlLBnUBXBqKZ1eE4yUImKjO4xKJe4wjTIttsRN0xRVniJfGXDo9Cjl/APrvONzZNfxUzQnjMIq2UbULyCkVQjDoCT4Or9FkCqTXylG7ypEsEpWXauguqgXPR6WdEc2t2X6NRVTA7pCruG6s6cYvp3c+EECvOGvD6YCkoLvNdjPrmNWXyGUEdXcxND+B7Fl3/1WZ5DHSO17+fVmxhTC6mLyjzbrHJc+XhGK2D3vlOfCkV5AMjj6e5zVgvtTG
 TA5j1SsZ
 VCLJ5hUSPiPxoqb4l9o9s2vLjH3S49FKj+UmiAIUbznoKEe6N35zmOJcvD64Yvl9nKauTuN/Pldye3CzDVY1ZMCek4dj89n5afKuTUGDzQTc5NbGLczlGb+YkwOARGBY8gKh9XBux6NW+l3V1zORT7zVWqq2eGWAhMBv4AAaIgjkaODumpjguOewUkha9mIszqHYDbGTbGlkV4UeD0ZBDzquV0c9G1LZ8y0PFG0xqQuQHLSUQ/HPCjHueDECrH/F3xFluJ8LozZaZTATLiAJvEW8tkUvK6hyOO8xyvsyAi6pout3mUI+iHnXk/+a1RTchdGqhcg8OGQVTX5QkvBV98sH0t+8c05hxIJUS/ndpW/n/YV8s2Lwfyp1m8BD90H2XOCISd8qT0fYvp9sEmkHHUVoP2+eXZUYmLBBCMrmum/677TpvL2aGAXLvGJ1IX3gTydQP/BtGfx6GFJauDROYzEGDYsXpzlSdiWYzNF4J5XxtkQHjnfrj6j/i7tO2V5wYAnWTxD615pndknpdgsyYrHvqvVo0vCcjhBlMHaqNDw0AyijtFuekGmqdNLcLWK3o586y+HFxI9311jZrI5wKx6VEVcmOSj0W5aojNJx3zxzR25BpRZCk5F6+HcTIuQMS79k9PKdQy1Hk3cTLV7rD4rQJqMO/wT/eCEAdFFqu2xQHpG8zbLMeFAly9uBjwVGtdUpKyAg3mMM4t1yVZqSIZEILAnJ7tTM4+v1AKqcVBACfCgpaw+H1BSKJ+64vNovlxMJSmQ5aAcpAMcr5wBmcP0gUfvTcYYXKL5As
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 04:45:17PM +0200, David Hildenbrand wrote:
> On 17.10.25 16:26, Zi Yan wrote:
> > On 17 Oct 2025, at 5:44, Lorenzo Stoakes wrote:
> >
> > > On Thu, Oct 16, 2025 at 12:46:13AM +0000, Wei Yang wrote:
> > > > Existing __split_unmapped_folio() code splits the given folio and update
> > > > stats, but it is complicated to understand.
> > > >
> > > > After simplification, __split_unmapped_folio() directly calculate and
> > > > update the folio statistics upon a successful split:
> > > >
> > > > * All resulting folios are @split_order.
> > > >
> > > > * The number of new folios are calculated directly from @old_order
> > > >    and @split_order.
> > > >
> > > > * The folio for the next split is identified as the one containing
> > > >    @split_at.
> > > >
> > > > * An xas_try_split() error is returned directly without worrying
> > > >    about stats updates.
> > >
> > > You seem to be doing two things at once, a big refactoring where you move stuff
> > > about AND changing functionality.
> >
> > No function change is done in this patchset. The wording might be
> > confusing here, it should be read like:
> >
> > After simplification, __split_unmapped_folio() directly calculate and
> > update the folio statistics upon a successful split, so An xas_try_split()
> > error is returned directly without worrying about stats updates.
> >
> > David suggested a change[1] to make it clear:
> > Stats fixup is no longer needed for an xas_try_split() error,
> > since we now update the stats only after a successful split.
> >
> >
> > [1] https://lore.kernel.org/linux-mm/518dedb8-d379-47c3-a4c1-f4afc789f1b4@redhat.com/
> >
> > >
> > > Can we split this out please? It makes review so much harder.
> >
> > I asked Wei to use a single patch for this change, since the original
> > code was complicated due to the initial implementation. After my
> > recent change (first commit 6c7de9c83)[1], __split_unmmaped_folio()
> > can be simplified like Wei did here.
>
> I think it was too much split, agreed.
>
> This patch was a bit hard for me to review, not sure if there would have
> been a better way to split some stuff out more logically.
>
> Most changes just complicated way.
>
> Not sure if splitting out the stats update change or the calculation of the
> number of folios could have been easily done.

I mean as I said to Wei/Zi, my objection is both moving code around and
making complicated changes that require you to really dig in to figure them
out _at the same time_.

It's perfectly feasible to send separate patches for non-functional
changes, I've done that myself, each building on the next to make it clear
what's going on.

I'm a little surprised at the oppositon to that...

But if you're convinced there's no other way this could be done (bit
surprising as you're asking 'why this change' several times here) I guess
I'll sit down and try to decode it.

