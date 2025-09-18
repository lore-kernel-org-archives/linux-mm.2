Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C22CCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3937280032; Thu, 18 Sep 2025 09:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10718E0093; Thu, 18 Sep 2025 09:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0056280032; Thu, 18 Sep 2025 09:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AD8A28E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:10:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69B1783EFF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:10:27 +0000 (UTC)
X-FDA: 83902404894.17.4A3046E
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf28.hostedemail.com (Postfix) with ESMTP id 15D72C0016
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:10:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C4In6sow;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I02cMMGq;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6RZkWJEgO8OT/6IShP89tysYSZRBuTMEsu2Acbl1M4A=;
	b=XIxEKYxDb25OauZ3KnT5ntIiUUq8wGOmD8mzGueafXiMwWCmAX6zbFpWxtm6UFN13OY1Bo
	kmBl+a0EFQs3GBVK9bzcDl0k6xMEwQZoY5IVFeX2vp0an9sTqZWouJgZa4VyEMIwcTnr5l
	/IDKBA5wdprPdZJP9aAiTmyaUrudt3g=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758201024; a=rsa-sha256;
	cv=pass;
	b=hDRBJN4VvL39nH86xUwaGCX660Vp5EpIDdz4fvT+Yy6wtdOdbzBN4zHXVyYiGasQnfyyOQ
	7L8UMDV7xMd9JawcDkMPblOrqcS3ZFXHMCqw32Yqd95nhENQhVIcYgTDCEFcT3nXDEvmpX
	DMVjmzfjipJNNHImc/lH3pMW7IyCh68=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=C4In6sow;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=I02cMMGq;
	spf=pass (imf28.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7ftvu029856;
	Thu, 18 Sep 2025 13:10:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=6RZkWJEgO8OT/6IShP
	89tysYSZRBuTMEsu2Acbl1M4A=; b=C4In6sowBy+tsX8Pst8gfSEaRS05XjVJvP
	7fC89y/DuzkeSgWIw8+PgytdTy5LsAn9D2KUqfdJ16cBBkgh7xWimiPhr6NNPqUU
	Vpc73yRiYsKTEK0JMwU6tVEvBITk9/rkMsii24rm6KD0yYlV7jXFJSxf8koW+esX
	5jLnzH6T7QIg85agrJqCP49YG9ZHI8QBy2qVAzGZUZmRhS7k8LMn/C+saAeBrvd7
	WbatbXEy0dFqKpuQbG/VI3jEN94W59xxRmLjW8EHzquxEpBGGS9jk6P4Vu5nNTEB
	pFBcn4297sfXZBbzWXRtnvKWoPuxQ1/qwB14Jm5+uj1vSv4BekVQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx8kana-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:10:15 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58ICxjqM027247;
	Thu, 18 Sep 2025 13:10:14 GMT
Received: from dm5pr21cu001.outbound.protection.outlook.com (mail-centralusazon11011004.outbound.protection.outlook.com [52.101.62.4])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2ncsh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 13:10:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lvrYib4+SC7UB4MkwDkQYygaSOQHP5VKgYsnz9kPXwOEhrlmNJDaOMv9aV/sHQwuqnh8CkiAEA+z8VAS9bWmGQJOpDW5vag4IMliWXRhEsQUriX18QxCh6x1CpLfwjlGkMEu1/l8N+RRoaM164oThvjsFWyPXEl7Vu3m0C2crUy8DSvUozCCvXCeM08P7/BG01T9n7cngkO8WviFhXme6o7E5TTgNrhIuSGv726jJq4/k6jZtzXbqt5WyuEdP0dpvysWAJlT7Cusn3OGbGfZ+cilndWj71Tiw9LvAZDK4wKH4Gey5VDO0zz0zmaJ+NTBA23C5fqw3l7cs3EB/L77zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RZkWJEgO8OT/6IShP89tysYSZRBuTMEsu2Acbl1M4A=;
 b=go+t8vU/ZsqkOgPvhjgBMgjS/wEnoSbugI0IDdObfVpIrf9Agsx0GZSzw1vO/pF8VZp4rs8yA0CleU1O+qRYErH9clH1b7h9dsUEdu9JLwP/uu4PyD6Xd/dIw1xHzqcSHfWp99hFSC0ypKiXWKmdNklNVk4UWNyux8dtXWZfYgpvx6SUbBzxws/cIIC/8gE1nVHX7emXU4OGSdA981pXyDli46caGeES1XMjau4I7yfxYIGEOkGQMt5ernOlEAClSJDyoZP/QemzfZ6LnvuhwifIqOQLcxLJF7NJoJZY+FtPBhz5PAn510stU/QUtc0t4kWB3ubpCm9DST3d9hYvaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6RZkWJEgO8OT/6IShP89tysYSZRBuTMEsu2Acbl1M4A=;
 b=I02cMMGq4LXrxjrO32zTJKVSdtf/QkBdhB5Uiq1aPom80FITLChSmG6I+Z6t4WyQ2fhnVtFE2i8l4C8Ak8Ilp1HB3wYoFO+P/lT/WklSMuovWvkYRMyanX/xe/OXth5r/gkGvkWmRT5jNZwJ7ocJymISzl9bqcfy8k+RHrxin8I=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SJ5PPFDE7085185.namprd10.prod.outlook.com (2603:10b6:a0f:fc02::7d6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Thu, 18 Sep
 2025 13:10:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 13:10:11 +0000
Date: Thu, 18 Sep 2025 14:10:05 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kirill@shutemov.name
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 2/2] mm/rmap: Improve mlock tracking for large folios
Message-ID: <429481ef-6527-40f5-b7a0-c9370fd1e374@lucifer.local>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-3-kirill@shutemov.name>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250918112157.410172-3-kirill@shutemov.name>
X-ClientProxiedBy: LO2P265CA0323.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::23) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SJ5PPFDE7085185:EE_
X-MS-Office365-Filtering-Correlation-Id: 06acded0-05f2-4949-b975-08ddf6b4b2e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?ziY0WWnhay5wIXSQJ5iOCRjtsr/evqNvPEquB4g3gcrriYZ3nWyVfA+IFEax?=
 =?us-ascii?Q?RpqVkr7YlykIS0HwvZ/qk8bZ4OiInUbkqycIsoWzZflfgh9Lu+h5hPQ3LzWN?=
 =?us-ascii?Q?VZNFspwY87h5Y+j97mOdCK91FFKx5jAyCyx/L46jG/axDbJIghx5zf5fCK2X?=
 =?us-ascii?Q?GT/z1Q6W51MgjQvT6xOcMEva5ji9kQx+/jcLO9qOz1QFj3irXkvfiH8I5pfI?=
 =?us-ascii?Q?W6QMWKmm9Ni0wBydG4IUNRQSAddgGMc5wSeeAVjg7bk532OBsDT7DMn8NNiT?=
 =?us-ascii?Q?y43p7GONdj7EVZrzJ1Z8Rkn0A7CZ4FEEOAOW81flE1ewcjHrzaPCsCLG1wy2?=
 =?us-ascii?Q?vN8xMgEJVDHDFi6P9BracfM/wBdJ8VVSoPpQO5rf5OvJMTmkfjG5Fhxqogy4?=
 =?us-ascii?Q?DZjcSdShuQY990B0kd+oADawGkjYzUyRIpfCG9wmBGJrTiPWMnu8fanLTE3Z?=
 =?us-ascii?Q?D1XsoRaQcHJzcqE/Kdm/srB/gvJqQwc5z3ETqJuT6OdwVCm0Vy9j19y36R0T?=
 =?us-ascii?Q?ryaAOWDR42m5z5MC1NCBd1tMzQ35xKN5F7NH6s1zx1Y1mXemcHKpc7NrQ+mW?=
 =?us-ascii?Q?KNR/PRs2Q9QlSKbj98lCWFdNDJUkAUgMBlApjx//nfMAQpZOg8MrZGBlokro?=
 =?us-ascii?Q?/b1yyLRySy/YGdNzCfwA3675Rf4qumAuCCq6wKn+JanOFj8T+9AuraOy6Y7g?=
 =?us-ascii?Q?L0VpBi6QABZIJB5Junh1QgaVnSB42IREMwvoslxTXXgUluvH3KNdQf6CHHY1?=
 =?us-ascii?Q?JaLNX/tmLFSiJnpFXe1fYbr0NrqRecXtMNfD+RU5eLna+E3Mkf8kA9SOGF4L?=
 =?us-ascii?Q?aw4JwUqG56NFryZryYQEqyocEMF4pV2+g/spTfVICCBMOYO+AMIu4wph3grs?=
 =?us-ascii?Q?4KdCVOpXZYq3cylmXk4pDwTL5oz346E3BCxzrdkchr/ZQ8FveDi2beAQCCsv?=
 =?us-ascii?Q?TZD3sN8o1a6MHyjzfEXqDtyCrDpXIuW5wTQ8I+8btWtalsiGY0LbW5PB0UnU?=
 =?us-ascii?Q?ch4dff2c4q4AVhYrnra9SQm/AofDGrDtC/NjapVKGCDNq9/dtT4NrAu/5zQo?=
 =?us-ascii?Q?38I9K7ft3XuOtmVBeOQxKaHFay9LtNC4NZVj1ZiIeLK+WslrMlxz+aj8wsg2?=
 =?us-ascii?Q?Q4xNKh1oklpHUQdfViWq8EUUGKO1CeM9DF5Tc/eE4zlQnSthdgR7mCeOnjl5?=
 =?us-ascii?Q?W+qOpHNeL6cuS960S5AWtpO8qIcIYvKJ+0tm5A1FxYH3s8dmQ1cvdTHGGpmt?=
 =?us-ascii?Q?dAd4028IxY+xjCIolk8SoaN+2MRQMH5H1WtSlTOuykO3qEAUCWTYpAiTnEat?=
 =?us-ascii?Q?NmMjPq+0Sd6RAxqvHOIh3ajwLQiOzS9CKa7NJJUno+xqqkjSbO8R5hFoxKpW?=
 =?us-ascii?Q?1AletfhuSuq32F5iRGB0SwLFgkkCKXEHvyGWxn9LT3zg+7z1/aS3U9Oiotrg?=
 =?us-ascii?Q?iUek1g5btdc=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?j8pOvkt+RsdW8s97zP1wgyt2n7Q2mQkGwbU/lOkMskQPgTR6V2NvaZ8tyPWF?=
 =?us-ascii?Q?EPHAa+oGoFXR+Y2h9T4yJUuqEB4J4oCaWNqwYLsM56Q0ovLzpIJOLWUdM1UR?=
 =?us-ascii?Q?6lLDEv2IvM1D+5udNEnXdjDoiHu7rJoiSArB+dADz2qFnqB7qi7IUCu/isPr?=
 =?us-ascii?Q?q+sg9bBUJqRlc3etAs3YpQEJs6tfNM29ME6lgRJethrUlHtUIvg6QlnIYJIC?=
 =?us-ascii?Q?UBxyEsWIKhWgJ3bGszGghYTzfIo4ZpSIQVYwtM2lBQ7I4AgcI0sjyB5Jw+zi?=
 =?us-ascii?Q?zypjcWYKecO/xuQYzEW7ISbN00y1f9FLhE8JGjDQzcTtmFgnfQwbK4MRJvVV?=
 =?us-ascii?Q?rtM7xpBVKObi1dTmaC9K0YEYj5LzTPb1SA5jaJAGWmqAC4JMUPVSohe1cB8B?=
 =?us-ascii?Q?pJi9YEc6sXwwgcdSFOU7BOXN2Ni6zmlNAqzFe0M71VfysVtFXVk5TR8we+Il?=
 =?us-ascii?Q?aCBQfzhWI/LYL1GlhxERR56IabM/gIHjdcOFBfNRr+tQlQTZnOBy+v7chYGg?=
 =?us-ascii?Q?AbFrglesMzJQgo3RWFElNA/8YiyOdMA1ATrqSD+gfHEi/tnxIpzSdPf+4kUO?=
 =?us-ascii?Q?hUQSPIgfYkwXeLdcBbBNDeLH4dLBQyDt7MkIo8g9BzAkBbxJmMbL7mdJAcIk?=
 =?us-ascii?Q?kD0MKr8ZBCS+FVir9T6yXXa685eZtmMbx7ypa16XkQXQF2VAMRjIXvocg0FR?=
 =?us-ascii?Q?k4MxTl9K/YjQGBaAZfLzWSsKeEVqvOJTwpnJXXWkE5IFb4jisTyxfUTkQwlM?=
 =?us-ascii?Q?H4WqHpY4jwipbAxXtR2Trre4AQhhKhT2jYvFzvadhr/miEWEiryAyDxVvnEj?=
 =?us-ascii?Q?xaPQr4qTe71bnXARqYkUvH2nJlDchmoOKIXDQND9V6dCSZDSth6QVVkk4Ar7?=
 =?us-ascii?Q?2QVtv0Fu8vljgxk7sPWjevInD57FGvCpnS8Htpu3F/kNsIjW2rJhf5gg3pYE?=
 =?us-ascii?Q?rPTmb0VAP0xB4Bf4z5wke169NDhwWNAQ8ENIiNFNqYY+mSG3+S/OoCOagd6U?=
 =?us-ascii?Q?lwNiK/C5bqQprgNDwXngXbM3K5og0XZyuYVF4o6EZqbLyzBmgUYXibWjDcOd?=
 =?us-ascii?Q?0IroxTZJ0oLu3p3csqrbniWfih5LT4H0Fk2b9M/eyGlzTEt5tkGn0UwH9LZP?=
 =?us-ascii?Q?U7jOLNC+MH/lgra5H9oTgaGk4eYj25lxDKX0tdjWWtwF4z6v1MrWwIPyXjfb?=
 =?us-ascii?Q?piXOXKP6IJ5UCHP+dVnW2QpaIO/AL8T72hxa4/fNAakRNC4L69fbfQ1vCZi3?=
 =?us-ascii?Q?8qazwXmcfZie+39Z9NmPvy+pyNHRSDW3QxkG5COIGMn3y4S8hWR3woRuLTgU?=
 =?us-ascii?Q?7tVZiWoe2sHq1MURJQOqg/V24TV8epP27/5wpKdE1Dm4eF3JDFbLVQ4+yfHY?=
 =?us-ascii?Q?oHBTxYgxjzvYB5bI3I7Yt1s6Gc5SqbQJQ6F+TUvhvnILCRCfMUVnG78WnX5m?=
 =?us-ascii?Q?Pn2y+oC2DSzfMKafFijmt60YdX0dFj/2cJOxfhRaMuhcPitZ56QFvHiMPbDh?=
 =?us-ascii?Q?do/qhJrmcayOeSAV5pCBwtes6OEMjH2nNpsMpoYRyY5I93VERJNCvZobOH/F?=
 =?us-ascii?Q?0GliWrVNYpOtsYhPJW0kEIdVSO6kVxi3YA+uOrcQ4v79C1lVote/71oCyGBt?=
 =?us-ascii?Q?rA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	iAzg+LMHr6CJu2303G7inio2FypCqrwTMhymm6W5dIY31nUNhIQKSag1ctEys0Ufw3cJUwFc8Okd3kBQr3DgtmtPAbCBjCL6G+4gnzg2DlPamHe8EaTJKcanuPMzYe/u9IVJbc8+4lEew6Plf2df0yd5CqAC1f5E0DIlBK9S9SKfmj4Xqp3huxdbazgUuj1Y1lyUjNapE9Ncda+5iOQqwIR/iatUHpxG9QYVlXWUAfSb4SGTTuhYSLPYd6T6h+qfeZKfN3YAiZe2KFZ9TFRUW+U8eTj0aLNm/Re95ShYvF3+CSOyS0lbiBBtT0Hoc4sSci+/fmY6bf7kR6B0H0wejVJuO1Y6uKKW1qulyn6nipX3Xm3fL78vqn4GdrMnAoTWjbN7kVhBgOdTTUpizvYE+L+oWvgVICiw9gHV7sIVVZP5ZRLQDSb+7EToWnF+0t4LcFecMVvss5Y/IIdLxqES1Lkq89UY0uJiWwfrroBujQtDkkP7/YkWZtlCCEQIdHLCRHGzL8hJwErS08hqQSC1eM+R5fv0iSqQpsJJ51bXME5dp7p8JKPN9P8j6JaHSMHu/CssQi+UB/KMcOsohZPujasjorkEHbVvzxYEH9zTEQM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 06acded0-05f2-4949-b975-08ddf6b4b2e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 13:10:11.3310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: urIQB1i6+DoQ6QJGZegtPhGrgD+0QGbs7LkqjojA0hR/NiN+gRqOIuiQZYD5P6xrPT0VeibWd7MuKdf6B/N+dYDQxXw91dtZAbvhs9QBQUA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ5PPFDE7085185
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-18_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0
 mlxlogscore=999 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509180122
X-Authority-Analysis: v=2.4 cv=JNU7s9Kb c=1 sm=1 tr=0 ts=68cc04b7 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=4Oon2TNoxb6aggn6gj4A:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12083
X-Proofpoint-ORIG-GUID: GSdI6Jc22Z-Sr-m-gcdwhsYcYXJCN_zH
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfX1YlzpdZeR+pQ
 oVi0CVMnGbFHCVoZc/50ju99bKrckIH7hN8LXTDG0WFxMNs35SDIUL4hpcCvDSiTTneBavCS12n
 WhfwtJDGw+CRUYzCy0UoSu4hbJk5kOi6LQWvM3Hi9XEHm8cPs6uwA4u/l3sccVn4GfX1vitbTKi
 wlWRyBdURfCmi2Z+jrsnH+ru80t7HYtlFEJm8hTblmTs6A1Iz4qGN86dnextjnEDCjeyfjsFkkN
 H5gOQC7oIM7Q+tRBNkNyIDju72xN2ZGsfGH2/+ZTU+E82nOidB3DVrTR3xHQB+HtaFg6HuE/Dvp
 HnfSUwBcuoKXIlZ/RwRYny0/I0eW3RAvLiivdgMmjTnsBxeno9CJZEZsYDGYr1ylhgHKVGRNJ9x
 kayDQ6j9sCKxxd1Ih+LH4MeEpkOUSg==
X-Proofpoint-GUID: GSdI6Jc22Z-Sr-m-gcdwhsYcYXJCN_zH
X-Stat-Signature: cqoub96emm6jqoaengaqgjwffkmb77h4
X-Rspam-User: 
X-Rspamd-Queue-Id: 15D72C0016
X-Rspamd-Server: rspam10
X-HE-Tag: 1758201023-271475
X-HE-Meta: U2FsdGVkX18/vg3XnbnozrRRlwl76Fb+TGinvF3Oommr/R6/ttKVubMN2I5H3qaRAxLaDuzLrjybXPLP25X6mjYKJS0P7nNrh1FhR2D54uagZjiB1TK7K7GJ4ankLf/S0GJGYYdni90L2ircOSDo5f+4nfQ0/aNmiktk//AoOnyvQ05gZT4eAo2ePyCICXmplCPXlZo+QHBvnOraKDsKs2N6Jl4FvUlfKefXu/isSoP/bqwuCyOoPirOygPnZ4BqJLzMnynzWWaRVSFd5ohdCuo75T/XLvqtymcTGpu6nT9CJ6M8PrxOJQ0nReUUYpR39ofUbfCL+uJXhe/1ePyMa1YLNiTeInd3kd/7KSZj3frJUaH/8aIa602LxDn6lMKV4f8653b+kjdCfKpapgtrtkHOvXajT+Xi4RQcqt4ZBSZy02qad3loUSmFXoAsmzZeLWOGu5H85BeOH34vLH5Ew4yWwqVcTfz1d+4GlQBtiVLkUQUiRBbDRqIKX8/gyXqGDR0qmWQq/yMaYuxApKuVEEHawSdOFf/6DFaUTfbfyZIngPZtNknTxhDt3+0tQyZcHqGPKwNM941QwFCpMRsOBY8QWRiI777OrpMltiTNBLhQ3ZoLGBrcVTAzq4mjac9cR9DhSuE8EtKpsHkt3Z5gCXyTyr4ywi8w7TYAWyJGRyin9CxEIcDTJBaeeKCvio86yC4NIPSEEcf/4aQRA0eaJPP7IRBOw0ezCif9PFHFk709Trg3YPhLCNQDzSolvdDCefIBR+owViRw/8MdT0DHZ+50VtQI4zY8MS4UiZMt0tqiO0IWqwCzPQQIeYTEi+zoZoG+npgsUewp4VbU04yAGcO/S67NL1JEPma9HujMtKqeD2AE7rcewrbRLetBHxsdJrc2Qf/bbySevuxCostddmGi0mo7rh9pQRN5taT4Ni1Vcobd8MV0/VlZ+UAoeMUcW1bRSbrcvJL6cmDtnQU
 6zeg/azf
 fOiPXslqhDBW8wn5r1Bm3sBgWtoXlMR8DdxNyTLQHOUoqJnyHvX2anOGQmAAv4JiXrIxSaalNl+WB9B025xLMDi7FygyFDlO8JLrLMuueJLsHhR0/67DsJaDqH4DYMxb3a/6BppJ/jl4QcMBMRCbADPJ9tO4WHMXG00MTjRaMogBW9A0X4LcAdBgDuc0yzj8Db2qR9pbflqwb7HIXS6So2lWRfV4vvjcQpEZQjIZidP4FMTGIKbi7Ky+fphCqBo7VzSQT5NluWDzoCCZIDJb1ZEoVa3aSKGHudkKnY37Q43inxQhAZL3jaOZYhM+0NbgKjrAGSlDfeorWbESktoR1TEbjsojFZAZJXG02J3xZH+5sHDgnTg6TkQ06PvnDNe3TTOhbsNCIYRajNsJmbny+pDiKJHfzDIYusXWLtkFPSDGNky5GnYAqv5ghdni3aKkM+zUeM9m8ah8VBnfK9j7veDFtAyTLhC0i+XINWZoZUttB99qAy0Jw6SobXL9lurZY1oPWFd3hOZcOvtNBEFfaPdazAOpO612CqQNBhQUCt05GrAT0I0cFzJYzPla+MKDaj+jSWk4l7il4z2KQmOA+9mKFUSvghlNdL2/85vEUGCSjyNafGlMsttC4eMrULWrNNVyyugM8CM4R0gg39Hgjs9V+luY+aLm5w0LjOPg/ZfqtyTgs4O7GEHim+SUCIWB0zf+cpou4Xml/4JLnlawXJ4MiSmh0uUJQafzIAIKteu+gMqQEvUtOcN0ilXHGQpWDu272
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:21:57PM +0100, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
>
> The kernel currently does not mlock large folios when adding them to
> rmap, stating that it is difficult to confirm that the folio is fully
> mapped and safe to mlock it. However, nowadays the caller passes a
> number of pages of the folio that are getting mapped, making it easy to
> check if the entire folio is mapped to the VMA.
>
> mlock the folio on rmap if it is fully mapped to the VMA.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>

The logic looks good to me, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

But note the comments below.

> ---
>  mm/rmap.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 568198e9efc2..ca8d4ef42c2d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1478,13 +1478,8 @@ static __always_inline void __folio_add_anon_rmap(struct folio *folio,
>  				 PageAnonExclusive(cur_page), folio);
>  	}
>
> -	/*
> -	 * For large folio, only mlock it if it's fully mapped to VMA. It's
> -	 * not easy to check whether the large folio is fully mapped to VMA
> -	 * here. Only mlock normal 4K folio and leave page reclaim to handle
> -	 * large folio.
> -	 */
> -	if (!folio_test_large(folio))
> +	/* Only mlock it if the folio is fully mapped to the VMA */
> +	if (folio_nr_pages(folio) == nr_pages)

OK this is nice, as partially mapped will have folio_nr_pages() != nr_pages. So
logically this must be correct.

>  		mlock_vma_folio(folio, vma);
>  }
>
> @@ -1620,8 +1615,8 @@ static __always_inline void __folio_add_file_rmap(struct folio *folio,
>  	nr = __folio_add_rmap(folio, page, nr_pages, vma, level, &nr_pmdmapped);
>  	__folio_mod_stat(folio, nr, nr_pmdmapped);
>
> -	/* See comments in folio_add_anon_rmap_*() */
> -	if (!folio_test_large(folio))
> +	/* Only mlock it if the folio is fully mapped to the VMA */
> +	if (folio_nr_pages(folio) == nr_pages)
>  		mlock_vma_folio(folio, vma);
>  }
>
> --
> 2.50.1
>

I see in try_to_unmap_one():

		if (!(flags & TTU_IGNORE_MLOCK) &&
		    (vma->vm_flags & VM_LOCKED)) {
			/* Restore the mlock which got missed */
			if (!folio_test_large(folio))
				mlock_vma_folio(folio, vma);

Do we care about this?

It seems like folio_referenced_one() does some similar logic:

		if (vma->vm_flags & VM_LOCKED) {
			if (!folio_test_large(folio) || !pvmw.pte) {
				/* Restore the mlock which got missed */
				mlock_vma_folio(folio, vma);
				page_vma_mapped_walk_done(&pvmw);
				pra->vm_flags |= VM_LOCKED;
				return false; /* To break the loop */
			}

...

	if ((vma->vm_flags & VM_LOCKED) &&
			folio_test_large(folio) &&
			folio_within_vma(folio, vma)) {
		unsigned long s_align, e_align;

		s_align = ALIGN_DOWN(start, PMD_SIZE);
		e_align = ALIGN_DOWN(start + folio_size(folio) - 1, PMD_SIZE);

		/* folio doesn't cross page table boundary and fully mapped */
		if ((s_align == e_align) && (ptes == folio_nr_pages(folio))) {
			/* Restore the mlock which got missed */
			mlock_vma_folio(folio, vma);
			pra->vm_flags |= VM_LOCKED;
			return false; /* To break the loop */
		}
	}

So maybe we could do something similar in try_to_unmap_one()?

