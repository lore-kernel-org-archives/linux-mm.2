Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B96ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 10:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4AC8E00D8; Thu, 18 Sep 2025 06:08:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B95998E0093; Thu, 18 Sep 2025 06:08:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CC78E00D8; Thu, 18 Sep 2025 06:08:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 96C128E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 06:08:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 36F6F1DFC50
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:08:55 +0000 (UTC)
X-FDA: 83901947430.12.B424E8A
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id B94DD20011
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:08:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZlUA6gfK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wpr+DH7q;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758190132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1P1D6e+g4gOPxoFL9cyOYXBJsgnRY2n4UDqZ4diCWQ=;
	b=Hjzk5oHsH7A02awZG9qK0tI6I5dWWIOF05MVavkYfP8z2O7u69iw2j7J6ICQYs0tVblD5F
	zrrv5xXJeBRZMx6cL6dBfDuBMZl6Mum5zkWI4KNjpwg0wToRUXcKJzAGLrl5xS6p3mzbzw
	taA0KMUlNzSyDaNI04MU0X34APR8JK0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=ZlUA6gfK;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=wpr+DH7q;
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758190132; a=rsa-sha256;
	cv=pass;
	b=7piSUOLjV2ZsvL7MJunr9hI/GwLu5a10lLAwNVQ8R3HOpfWJtWRsDtqWBQsC6BqkYmFVaQ
	IoOyUHUQ91ZQiSi4ZJH9fdzPald2iC47u23Iu6AmlcDNKOKI4u6bmAFlNn59mky0Gx2KoS
	+bh9iYKxFU1JvaYYpl4syEAiypNzi84=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58I7fvNk021229;
	Thu, 18 Sep 2025 10:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=y1P1D6e+g4gOPxoFL9
	cyOYXBJsgnRY2n4UDqZ4diCWQ=; b=ZlUA6gfKAqknEaovV2C655jB1dKWvECrU1
	1r7u7dv8aRwc92tR/6eVeQjYoDqseLtftO30yf+yX2I/qkDq5RnnZf4lPGUmS76+
	hlfAnMknGH7mxa0kLBHSDohtChXFi30bPYWlA6Lj5gUEP6YnwfFAcj4T1FigPW/V
	h0F7m4/GmxLXmLwIHvsW8/yltjf+XPUq+qJ+DPcPtStE79ex0D2bCa48Pfe5b7iD
	HsWVEBe7ot1st5sOsUNABzVcu+r7Z2Aj7oTPziuASS9AhsWIXhMrp/RfpHlla/GZ
	5wRiqvKZ7C3aXNp5BR68m+lypvhSysqU76Pmsll+DJ2EBZPWkiSQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 497fx9u6bq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 10:08:49 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58I80UQm035170;
	Thu, 18 Sep 2025 10:08:48 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012063.outbound.protection.outlook.com [52.101.53.63])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 494y2n7kmq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 10:08:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=cO1gyEhS/n2CuBidFOvv7kZREGeAawPpy/PKigibv9qdrDHcWheuzUb2SVXRuKBtoBoUoT8zsbaI0uctAgEzrvDIiLY17kaqUnjApH6F3IIjfJpxhc8gl55mFFcwsH6yJFFsbDweVaIFxl9cLzYUopTKb+FKC1WJZON7E2K93BP7ivI2VK6WuhJR+CC52pETkhUkOwRRItOn4s4Xm7inDjHSYGLJ8ib8o0zw/tK1Vs4yWxJNMjIbZzkV+PNr6LZ9ClCrK06hVIpPsMTRupNr6SWLjLG33K3i+rhIMVN4nkwpACXI5CsmidJ16c2Weq71oT2YaKTUjPa3MpQnPmhfpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y1P1D6e+g4gOPxoFL9cyOYXBJsgnRY2n4UDqZ4diCWQ=;
 b=nxV5FPoZJ2YvpX2qfjWcM9kMDjkqn2uL/2Mb/9KSs/WdmR9GcuS7Tn02wzsoanxlitfnDiGoGOw7desj9ghKYqQCag9t/7F9pBIuvqnIGROc4U9vna3bs8zdQGSVG8qClOXMkGGK6gnnTM5S4uClrbx4rdSsnbj57z3DvF9bitwUjL8R/6KPO2VRBBfrNh9LDug/XDA5ByWorD7eoX3nW1sQejdao0gdbSmhrXQu+3DjqaiCREFbaXSX0XO8NPbirCs/KLgyFZR/TN1smRC5vUKkjrtUqQpKTIlC+UMQzocWs1BkSJE5mjwPDM1HFV5iyqnk1me7BJgKKyxvagrWNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1P1D6e+g4gOPxoFL9cyOYXBJsgnRY2n4UDqZ4diCWQ=;
 b=wpr+DH7q4nkO0UU2JIq6HFNothjXDgRa9ruzoYpnNgXo+tpEv05RWjerSq1GTAT96xeyWhc0HjeMky429/M3Z+5nUWTdDCzuuDhHV8KZMJkV/zPSk8+cK4JfOhtUS8uBOaWPP4JKsvratkwgcAt48bBxHQI+daY+EyQ5cS+Ch5Q=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH7PR10MB6379.namprd10.prod.outlook.com (2603:10b6:510:1a9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9115.19; Thu, 18 Sep
 2025 10:08:46 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%2]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 10:08:45 +0000
Date: Thu, 18 Sep 2025 11:08:43 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [akpm-mm:mm-unstable 235/243] include/linux/mm.h:3679:16: error:
 incompatible types when returning type 'pgprot_t' but 'long unsigned int'
 was expected
Message-ID: <12683f6b-6756-45df-bc23-c29cd5c04d6f@lucifer.local>
References: <202509181744.SIHyVUMm-lkp@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202509181744.SIHyVUMm-lkp@intel.com>
X-ClientProxiedBy: LO4P123CA0006.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:150::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH7PR10MB6379:EE_
X-MS-Office365-Filtering-Correlation-Id: d95961ba-783c-4aaf-2195-08ddf69b5aa4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?O8mVY/1Oqmj+XaIzOCjrx2zbKTSLhxbwHz4yIVThc1Ttgaoy6LRRtLgQc49f?=
 =?us-ascii?Q?nrYypWTdyineglY4wtnSSaCxXNOvd0i16aI4t5qLUn1DxEsoxEJzRaPdkX/B?=
 =?us-ascii?Q?3RQj4/gfCB9xjEgEaYGe3L+QokNOiS1mExhETn7Ok0MT2amfcu1Xmqi76u1u?=
 =?us-ascii?Q?Uo293V7pQ28qKyh4x0Yfu8vIk6/yEMT5huNGUmuQ9xJMmm1D+ecjYQ0f51gE?=
 =?us-ascii?Q?iimdadZfincHCJqntP6Dmves3tZNLhIWhaDtBcNh3zd2hyV305cwjP/N0p+W?=
 =?us-ascii?Q?82knQzHNjp5yy3SOWngntmYg3eyxasslgS8zjjVzKbVJBPdh6bE0xGSWiMe5?=
 =?us-ascii?Q?L2pm0Oi2pkJCwT6ffHew4w+FrnwzPZUtRZ9LWoZxOSiVSwFHDXIa83UFFeJW?=
 =?us-ascii?Q?nfHiCZYwbIU3lvfbcVhnfvQVK2vy6bsPjkwRCWh3eyjshK3F2SX+ushrkNk9?=
 =?us-ascii?Q?92a5m+CWc3cU2xLxXLKQ86qAjrsc3bfjrsUbFUQoJ7/liBGZwUbgvKMz4Fb3?=
 =?us-ascii?Q?TITNb4csjRArL2TNkhIFsofVmV4tpPlxZCVNrklVjBU/qSqoOSfMZWrWgoCN?=
 =?us-ascii?Q?+ygl3ap1cotCL9w0cHiYfACnEOzCqTHau1eMoEFpuR0gazCrHStpCKBHv7co?=
 =?us-ascii?Q?XqAw8EjhoEvobU9W+xzR2Ma3iYc8BfXCs25Sm6WagE1O+vmyZ+W9HDPLLEwo?=
 =?us-ascii?Q?pv8ggIMCTSbxRQa7G+FBxsqq4Q7qce3Cc4M7DOpK29k7e7aGOmdsHsdb9NWl?=
 =?us-ascii?Q?1QOk1vE6ie5RNxSztZz8sRmTRNkUGpiUoPMlcHp4ekOmpP2e1PoiCYfzqG8q?=
 =?us-ascii?Q?+zpVJ8QTXffjoyXtTlRVbZ7hvlgH+mGtsocU887+GP5M8NTYwgrRtVvmumY1?=
 =?us-ascii?Q?pKZHbJ+Zr5q+7vm8aQ3Qe6jP4reVW/mNxAwFamMnSQAm369upN/EMVjBzKDD?=
 =?us-ascii?Q?7c95SWc6s32xYj5nxh5JDW5r1zZxYdauVdo5GyogmPwCO8GCXDN8tqVSnltd?=
 =?us-ascii?Q?z1E02h7BhHKGUxwqVneg7aGOXImvHyv0MgTOhQsMMFXvwRgjTUQKClnFOj8c?=
 =?us-ascii?Q?9sUBfOni2Kd4BqJxC9extq8wTfcJRnv2ShPt8qN+xf88VQdjon0Ne7/ZJd/A?=
 =?us-ascii?Q?PFnN6ddTzZGN/7h8tUHbMDhSfnSl+2LO8z4lNsDvn5X3oGBehdZRzmt2J00Y?=
 =?us-ascii?Q?OJ92rqqgY0e2xhMTTmyvju0S0zPrcaTm8JKaPP9k4K8rhCSW6XKo/MHR8949?=
 =?us-ascii?Q?f/zAH6iPCu4VZWc9NcYndonxk4jhxC18fjTtVu8Pj5t4MNdPspgB6ixf6o/T?=
 =?us-ascii?Q?hdU+gXTJoA3ZotMJBcCNKHFg4WHgnadG3SrzlQtWHA1kLf5HlYVxoolVTvgk?=
 =?us-ascii?Q?5NcFPrFTLTd0TAJNBuIs3YpTZru3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?foOB/d4dU8Mr3qBQEzWGcHVUesyT2sadPeW5HQWWqv9bqi7Fnn94vijXRK2M?=
 =?us-ascii?Q?nyUbdw2dQ2Bv6UpIq5AWIo0Ie2GrtZcJh0PsqdUmbBef7OQPjLORtt0GAaUf?=
 =?us-ascii?Q?Hhn1R2li+Er6ZrcbrkAikSBWrIGgAE7KGy2KOrKy3+/jUmRHlg63zDFdbwyy?=
 =?us-ascii?Q?EMdhNAnQDZHeQJmFfSyRxPbR0aP+HzwokA19C+CFaqkAVzKmA2Tfm4LDa3ll?=
 =?us-ascii?Q?Z52oT5kQ0QMSM7vxoHBNbi/soPE+RVthCB7sN/6DmNcCS5YUVlKKhLKEjJU8?=
 =?us-ascii?Q?deCIX49XXZCdTDYk4etsOBdbtGQWwhWigJF0ywDBO7xZZASv84l0/Znivlet?=
 =?us-ascii?Q?/93eM0ulONNlYcXY5OM3udev2TbIB4OddloaJrrmdOOkBhNyYs0GYdcp0B3a?=
 =?us-ascii?Q?SNZANSEGFfzM/pXjm29SIzDJoIURMxTmQsfRlPDy4W/0dh3EFoIQ771vzvdF?=
 =?us-ascii?Q?rk91OGYbtCXBJ8GIi2OXQEHv1/+jb9niVgmHHFCYxjLO5hWttRbnZOabSmey?=
 =?us-ascii?Q?zzawOv3B6q3eQPwmCvJyE7Ixlb3UHdPve7fGg2eX4o8MGo6a/SzyLVysWQJd?=
 =?us-ascii?Q?Pua19xrfNbBlluj2nncWvHKyF7g4Qr+VT86pgDsTjsnZ8X//0xqn/PuGRhee?=
 =?us-ascii?Q?CwZlBFlj5tGAHkCbLDovb0TqLEPXZ/6ZbdsKBfoPnGQuBrginFDFWydffqXK?=
 =?us-ascii?Q?EM0L0oiEBx+mxRW6w6I+m3zhJ0WOw8YcrBlePERUtUUj1rPht5Tk9f0LK7p/?=
 =?us-ascii?Q?uSIj9QaVnd2/vpywPoWkbUZ2z9Gza5Z1tKzvbTTuN8Eyims1Ek+5wUnt5PcW?=
 =?us-ascii?Q?p61Yyp8RUWJKdADNZMQWzQdLU8mOV9ggF8EdSlEAI1J7Z8/EfRP3pZkVeV54?=
 =?us-ascii?Q?9ghjUwVZuI1w71lHIByuKM4Aob8S0JNwXmmJLjcQPdWsaMDa2W7bpm9RvR51?=
 =?us-ascii?Q?PPNTWxO/TNBfQUBMTdi3inNNHX1jxK4/gZYEFJmEHiBmMS1FcfBuY4gUiVui?=
 =?us-ascii?Q?KdCXG18+mkc/+PjlPL3x/P08IG/pPaYk1JBPbPy9Bqk5L0XtbDuNW2A9MQCY?=
 =?us-ascii?Q?t/WdfslJ2YI0Ky5yjnXn8uZhe9JNFck2xam/ZRh4n6CU2dze8UfTf/a6zOsq?=
 =?us-ascii?Q?C0K4Jdrip9+nsVcThSW4+1S9pfo3SmN1iIY8yME3sSbDQ2QxA3QU5A6LLfPP?=
 =?us-ascii?Q?Z6C4Da7/tKG4eEhGuUoGk/jVixdQ+9Y3a7QHwnyi7VmdvP4wSXfdfCvRYpET?=
 =?us-ascii?Q?9y+Xew4qQpl4g/8Sz7ueEXa9fmshqaMve54ge+mdflnnsr7AREIaKGiKIFW3?=
 =?us-ascii?Q?gNs9GIjYSe01wzqj8B3oQPa+W4i8YOkf+hmf8f5dhe4TBVgSjJRSmIOIrUQ+?=
 =?us-ascii?Q?2OFogMjqwtIz9AEUQQLk8a/msRMmUQdx7ibP/STNFt/5yu35jtV0/GMEsQNi?=
 =?us-ascii?Q?l9t3KFPus2Mvy1jIse7tT6aqrSvI/1Zr8YhsLKG6kw2Uk8T9KlMVWWdGQfED?=
 =?us-ascii?Q?CM8wTKZ+1mPQNh9eQhNrIdgtXV7QICi8h4Uxv/i2VGZtJuiZhq2g2yIJPqqa?=
 =?us-ascii?Q?ONX7Zy7PSvSRqo/qJahWvmfkEzBdFQqgaD4tubRdjMuoKJ4ZmxA4xE4TN4m5?=
 =?us-ascii?Q?eQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V+WKj7loDd/IutmJUK7FvzFpwZ380b/6OP0/zVWYJJoDWGt3XkI9t1UuOiwcZiMNFq1f+vc1TR1k5JfQK+mWZjRoXigt1dEbA027WBPuzI3tfFRasA7VXj0fJeY11/Iam0Wu2y5diATtb5G8ul8AOsYAA8t7XudIVq8+6rB6+8kgfjgn2ugH6Y55tE1IxqvKuU0BN35gT/PQzsI/l0DkRtIpzAfOpADH08t9Y8asSIT/wQwyVJsQXXDU7XyJ4d78fr5W3c9TRah9eSCGMpSBhtuX9yUt7dpDQXROIaFu5X/zKGKOlhsLeQMLN1vUJqKdHKLIl8eoZXJTSXylqreJLBPUtYqspV0vC+WLoPyBXeieW2CiV+cDlvMkFngUNee1yj6VgM7lhMmNTPAUF45zxAn79uCzTNyDWz3RTqu441oSVlyKHoeG4GqPWJliwOaDDhNYmgyFr/gKnyE4WGa9V+lOz+s/2AKnCwDWD9UOITdyp16Mr4/ReBOt/DiTN6WYNXTmoalwA60Pf96nySaBvLzZ7MEniXNJP16G8HAvZrbNXcDzefxjxD5ki6/+1J2rYOqEmn/HRchoA9qW2DTzoMLHC8AMc6HxTlcACqHpjUY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d95961ba-783c-4aaf-2195-08ddf69b5aa4
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 10:08:45.8147
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0rK7l0Fb4yS7X1nGT9BhZKcNLMFp1LnJwgGICTNS5se6uHc3N6XKT3r9mPeyX8EFtvkc7pceRG7cYa+pOxqoczgWJmeI4aT9goPClWeJ/lA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6379
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-18_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509180093
X-Proofpoint-ORIG-GUID: nWNi2LisMtaN7A85oc6M9X1W3rxg5r5P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwMiBTYWx0ZWRfXwx+JzMwjU4uU
 vG4bYClumFznNwJf7H+LS3XHEGjawnOYxCHvxQktIyxu0oDoO8pWJk4yD1oYjzAZYJ/QGtRGDkW
 G1GP7FGNSXoSKwoWFqgiv57eniDdQIllezZFP5Icge1KyAZ33fGYhd8nNYZ2CxB6+C3pTcy/YhZ
 1DzKftA6dn6OckimNegDspfDxmUuAqtBWpzXhivgYr7heo5YqQWNzO3SUmDW8gmPQQU6jSkX8bj
 Pcn7XZmwSwjEnY/yStLvfT2XK677tnDxc9Q2iqc4Mlg5eclSIhBhV6n/JC3THv8JQpxkRYzwace
 ayLgExwutgC6qxuISGHezrRmj1WpuL9luuImHfpGCr6Gb4pJgt9HOV9C1OkTk2OseIi0tPL/HKD
 kFwhBrz/cV6pCl3S+bLkd+htdqclQw==
X-Proofpoint-GUID: nWNi2LisMtaN7A85oc6M9X1W3rxg5r5P
X-Authority-Analysis: v=2.4 cv=C7vpyRP+ c=1 sm=1 tr=0 ts=68cbda32 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=VwQbUJbxAAAA:8 a=i3X5FwGiAAAA:8
 a=QyXUC8HyAAAA:8 a=FaMdWeGAsr8DPNTVIdsA:9 a=CjuIK1q_8ugA:10
 a=mmqRlSCDY2ywfjPLJ4af:22 cc=ntf awl=host:13614
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B94DD20011
X-Stat-Signature: nbjzj8ye19ou1gkbjnpj8sbzrj5nte8r
X-HE-Tag: 1758190131-788028
X-HE-Meta: U2FsdGVkX1/3ZIVJgWuN3PmSajJ9xp6Vy1e4zm3KoKIq2b67AhG21NerLUWqAayKfxIZFMn1HhPca6vFc0Hp3olJMlYrQ9OnBZtsIfESyRnV2QT9cOQIGysVDnuwebx3UxBxvNdIC9hGJkH+mgEXVwFXXaEdqIfjzA+6SDGsyXCk37MGb6e7TxljTScVxZ6FiUvEru7n5Bd9ggLPAXIvj33KkaoOaAwuRiyM+WYkt3Z+O3jH+/wh2AVvPCh/rbRDIxTuzM3ExHsk2OsmPwh+/cYY3409ETEfqo1szB5PWhGVW+On2pmdVlrF4VhMyodFEvSo1dO85krEd3agPfDxrkvMfqaDTYFsNcm6/SjrCMl6dT/ozebwOLhCqU0xMpMiHrq7n900Nqt2bYQbHt0UAKNbbY/PnIdqis/146uRJlvsA2izaRGfcqeG5t3ts0qm3z5u/CVcSUfaCYWqhnFHfWVlJvLlHrSx/dSs+ShsXClpx25YNH7UPW3ARiDwTIDFgKxp/Gs5CbxcRdMSqn78wpLM8oH74ZEqAE/F/VDUd30fzUBO59sfy4mCVlswIHM/oSI1JDm7P/1IM5gKXSNAbLq+IJ9gac8q/VS9vTVkNvbclETsAvFPLSZ5xyXY9CfgvEEte+9ShfSOU0Da3J9lZup8WxcAcxXEXe5zi0HAXP5h4pyhG7Ldi9xK38T7SIqOU9AahapguHSFm3H0iMQ2GTx3PfeH9C/PHFKpRfZgOnheft0GR2g+6uwTYbSdtSIZQZzDraiIjhjNgpoRoniyAGrU/8BuP022ROpnf3aGw+Mpud7XNkA64vMWiOVWqsgvJODYTZxSvIRRDLcfsCfQNn5/s+ixkuKzsZoMnqBHLU5v9nZAr9NHxZjn9bYz6baBX0tiafz41Lff3HQoeNIX6r58b7OIHABwFY2BXvFY1G8dRD705gcEnAvEB23IPsyl+f+oXbZ5BiuPctfWD/9
 FexWZfEM
 o5O4NHTd/L/5DhGIXuWHknWHXqj1r4WReRhBza8KI7ubnqwf7HDDrnE7bG0TNtqD83TzW4dmVYLFc3dm9bmLX1razWVyoT+rTOESz0pH4BKGKJImSf1gQuw7OdGCGl2iWXsWVm/+6k/MsvXJJYb0W4Tick8QjZ1sEgbLRx9oa19n2y90RvU2oCX4szPqSlE2VN+xvqtiWsLXeNZR+Q4+HF0rf/6qqBk2a0/79oaL5SqdteYK+7jao+IaJHn88Wgw+Egs033DL/gVn/06j+U1Stmwjx83Z3wZjE4jeH0wA3D7iVThtPr/sSz8rLAhh4mm/z3MZF8g3X7DJ+q131iVtHWlmovLJMXqDgZH61GBXLLXaqLZFcHKonJsJCPC3JHcvEPOdU27AzMQjMD9sBINGMzIS9fe+VDGaFloMELIUZplPxNAyLpwoHO1JAWf9QxpbBrowfyUj2EHTCbNiMQpazfrSC8qckH8kJZGCsnDcYH9DyWFef1g9FYjGLhgFpBJnsyrzm9aRyMoNdFA6lRudLHq9DOUwkL3El3Peehq8bSvxFLZZQy4r2Ge9LDmEGbHriHlCpShrGMGK0rs+h9+NMkRObfTApehhWoMeVvd9jXlG0/kK+sHaXceuc6tfu5Jgj7Rftb9y0/YfVxdU+53EEKItlq3Mkd8qqGmvLXDu20OS2JcpYQoVb77D0diW1DKNghW3FhyVN4BcYn/G1hZ+XUsG0vnFOpEV9UIeI59WNWYqpyU+eYaGR1F8GnPxxxkWp+uPiEJl6UXurZjvaQrzUeC9JtcX4fUlRlcVHWa5xljOCMdT+XVkPve7okMk8xs6ALQ2H9bmkLXSRt88pg8iu3f+vYonuoMwDMuw556+0+sjR033AG5D0KKyAiob39bsOoPTZutJ2Yy2fV8cdkosBQyt8TFD9CNtNRiOfzZ9pN15nWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 05:52:51PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   1f98191f08b46ad015d4480af96541b521fa2411
> commit: 322cdf975a863b1d694bfb2d4232eef49944b91f [235/243] mm: abstract io_remap_pfn_range() based on PFN
> config: csky-randconfig-002-20250918 (https://download.01.org/0day-ci/archive/20250918/202509181744.SIHyVUMm-lkp@intel.com/config)
> compiler: csky-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250918/202509181744.SIHyVUMm-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202509181744.SIHyVUMm-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    In file included from arch/csky/include/asm/cacheflush.h:6,
>                     from include/linux/cacheflush.h:5,
>                     from include/linux/highmem.h:8,
>                     from include/linux/bvec.h:10,
>                     from include/linux/blk_types.h:10,
>                     from include/linux/buffer_head.h:12,
>                     from fs/hfsplus/hfsplus_fs.h:22,
>                     from fs/hfsplus/attributes.c:10:
>    include/linux/mm.h: In function 'io_remap_pfn_range_prot':
> >> include/linux/mm.h:3679:16: error: incompatible types when returning type 'pgprot_t' but 'long unsigned int' was expected
>     3679 |         return prot;
>          |                ^~~~


This is fixed in fix-patches already sent. We don't even need to have this logic at all :)

