Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A98B8EE6B46
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 18:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E641C6B0089; Fri,  6 Feb 2026 13:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3AE66B0092; Fri,  6 Feb 2026 13:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FC26B0093; Fri,  6 Feb 2026 13:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C18F26B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 13:33:44 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6E903B77F8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:33:44 +0000 (UTC)
X-FDA: 84414880368.19.761D355
Received: from PH7PR06CU001.outbound.protection.outlook.com (mail-westus3azon11010062.outbound.protection.outlook.com [52.101.201.62])
	by imf11.hostedemail.com (Postfix) with ESMTP id ABA1E40010
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:33:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WR0O/1nN";
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770402821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KMxb2nEfL+sUixgAVhE79B2Ru3zDNGxWTVR96wpr0zY=;
	b=Xxdt6cEctgUYeAXb3GM3CTRx5YZoTgtDYDFq6ysQgqvxcBpw6uyjw4J43QYlx4kHfc/x8J
	hx7CwP7ggemjVHJ2/5xA98bof7rEOyqHm3kW7javV21eAXWqQuSz/Q+cAeSlQ9/xCKv1Cc
	oiXNuoTDY3nFikRaX2Z5x8Iua8YhFsA=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="WR0O/1nN";
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 52.101.201.62 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770402821; a=rsa-sha256;
	cv=pass;
	b=a76Md+cxJCcryHpB3bOhoZ45FSBZ4ehKJXWKkV6amf79kpw996yyXdbK0GtlLX/PimkEzD
	wjhn8Q9inkuZjigPtXtyI+XtQZGPtx39Cdq+BcgS4BYuZiz6Kwz4pmEJzyG17DRr1pfITT
	B/XXWh/lz8K03qYJ25tYhABIRV4oOcM=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pljCEsIpCrxlzoW/9gcKVPBVLLACbn+lrG2Byd3tJC/qr8MWiwO6Uv/dKUUsMm9P+ovyyRxLqKO1X/cvTIztd31W0t/a4ZgpRdN2D6I6EW+4AyqnxVV5X+S+kF0BKkQvO3lBm0yJukdj6E0a06but3Thld2EeCjOx55e5MkdIAFdfxeC5OHI3+ZICsmTWwSCddv26JMtnqeCuuWpnX+gvNxCewpdnwi2rrU/YtBfRfvKrvnzcYObpMW875dr5MBLGSjcDfUNzoG/7iC7pEZV87EWtvJqfSIlc3WNtv/Wce3xoQsRblCiSWj3oBqP8CKwFAqnCOg9BBy33Ycg+iuiJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KMxb2nEfL+sUixgAVhE79B2Ru3zDNGxWTVR96wpr0zY=;
 b=zLf86+vSAsia4C99NxuVlrLUs1evpiWqEoNVvdTjEJrVJbn/Zk2hr7zdHXy5kpI015GErqrLS59Lb560Z4v3zYcUHCCAxzZaOUtQklk4i8abD1zHs2NtSEr4sP2viD7g7bkxJ5HjEv2C292OoyQmqMVR7qv1+1fqXBhc9d9FpqJgmR+zJlT6q0C5bQ3avdNEd96v6gyn1b0z9WtrCUg9BOC0wqng7JmBqF4gXq6ZOAhH22w/TCiDs7a7MX3VFHUSROggSebQtAnnWZeS147LyDdwgRz9oTfTnByYj143c4wy3Y+lIKq8S/l+BcE77+9xIjJXW5Kaa4zStjPquRVGng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KMxb2nEfL+sUixgAVhE79B2Ru3zDNGxWTVR96wpr0zY=;
 b=WR0O/1nNMGBp9R7wsF2yhUtrFthGwKoH5Eda1tuv6nwXxcL85e+cwb+iOjTXmpE/VYHhgk4W0DRSBgNOHGYMePA9qEJlu/XHthyDNThxQkZ/PinDKqJSqFVImECm43n0yXXPXDc8tAeW034PRnrUsXCySF/RhdFzMrGVHj5pu+fwyHm1tA5CqDBrScdI+WuSz0yKi2oadopQ5aCX29/lwTDDWzoOxZ4Hd4KGhOrGo4mPA/daj3Y89FB/YmHX/vQV04dLbC1VEREfZbRGyrgyZEBQePD0oZb0Xy8m0NCPYwg5VHivyySq3GIGLTjfvhG8WMclwfUgZRcCyh8s3LByog==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 BN7PPF28614436A.namprd12.prod.outlook.com (2603:10b6:40f:fc02::6c9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9587.12; Fri, 6 Feb
 2026 18:33:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9587.013; Fri, 6 Feb 2026
 18:33:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <vbabka@suse.cz>,
 <chrisl@kernel.org>, <kasong@tencent.com>, <hughd@google.com>,
 <ryncsn@gmail.com>, <stable@vger.kernel.org>,
 David Hildenbrand <david@kernel.org>, <surenb@google.com>,
 Matthew Wilcox <willy@infradead.org>, <mhocko@suse.com>,
 <hannes@cmpxchg.org>, <jackmanb@google.com>, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH] mm/page_alloc: clear page->private in split_page() for
 tail pages
Date: Fri, 06 Feb 2026 13:33:28 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <B6CDB0B7-CB9A-492E-90DA-F8D7E3B037E1@nvidia.com>
In-Reply-To: <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com>
References: <CABXGCs03XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ3PwP0mGXA@mail.gmail.com>
 <20260206174017.128673-1-mikhail.v.gavrilov@gmail.com>
 <3BB6BA1D-3756-4FC6-B00D-79DF49D75C51@nvidia.com>
 <CABXGCsOMzrQTsByYraNby_MXnTuYBNt2vbWu65KCGX6bmi11iQ@mail.gmail.com>
 <F36AF979-5BE3-4399-9420-F41A475EA87D@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0037.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::14) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|BN7PPF28614436A:EE_
X-MS-Office365-Filtering-Correlation-Id: be91d9c4-d20c-412e-67e6-08de65ae3d7c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?UWpJUytvK2ZIekFOamYwSStBQzlqK0VFZzRacHVCL29VZXc3MmRTaTdIMndY?=
 =?utf-8?B?SmJaNGRoeWFKNXVEU0tmZTNPMGI3TVlDeHlZK01udmRjOGdBeW1iVGgwRnN4?=
 =?utf-8?B?cUpBUHdrQUJHVzBROHRDRHhaVUNLYWZDck5BRWhPZVJKNHlQTXYya2xrTGEv?=
 =?utf-8?B?Ukl0M2ttM3AyQ3ZTNzVlQ0ZQbkc3TSsxbG5yNGgxZDFRV0lYNE9KbGdic2tm?=
 =?utf-8?B?d2YySGMzNHpuZFFPcGpyUktNVjdSWWlFcFRPemZwSjBpaGdXU0djMXdBMDc1?=
 =?utf-8?B?ZFdGd2FnMWdCT2sxTVBEV3V6NGtIWVdGVGczcEpMQzRpMkhvcUZzdnozNDE0?=
 =?utf-8?B?UTVtcGJZb2dCZHFLdTlzMVFMRDhQazNZbitMa0dFWk9naUhWdEVBMDB5TTJY?=
 =?utf-8?B?UzV3cUlza0lBaHVzMjlMOU9CWENvUm9PakhWNkZmVmJoRjlFeENxUnltQ01V?=
 =?utf-8?B?emMzb05qdXZWSEVCRFFIcTl2RHgxOWhIR3JrcC9XazFhK2xNeTR3S2JxUllu?=
 =?utf-8?B?M2w5ai8rdjl1Qnlzelp0VTNyZUNqYy9SbWxUcEVreU9WeHhDalJSdklVa2tp?=
 =?utf-8?B?dUowNS9vUHFRY3RpTGZKaW94VU9ld0FLT0xjTnlUODNhM25OM091cXFMTXYv?=
 =?utf-8?B?cHI1dlJ0SG9YYXZaOGZWYkkzSVdvREJrOVVhTmdoMkc3R2Q4d1lTRXd5aloz?=
 =?utf-8?B?WXhYazEzV2ROTHdYMVA3blNFa0U3cDFCNFFMV25ZTGxHd3Y4bHZwUy9RczAz?=
 =?utf-8?B?S0Z6ME9kNTdUbGNZUmU4TWoyd3pIbkpTbDl0TEdTSWFSeFR0WUJib09Fc0Yx?=
 =?utf-8?B?eUNnOHNsZnl5T3A4MmsyYWdaREs5Z01mYS9vek9maXhlWm5nc1BIYTRFVG56?=
 =?utf-8?B?bGp6dGRscDFjTWg5czhuWG1qb29jRXNOUGVlbTdoVG91c1FweEVFUTF5Q3ZV?=
 =?utf-8?B?QzEyem8yYzhOYVMvUFRNdXc4WWgvMDRGSGpoNGVsQTYvSkRTVXVyRHBKMWlY?=
 =?utf-8?B?a21CNU5NQnFlNmhiekN4T3BIRm9uVGtDZ2VPcUErc0NuNngzQ05oV3dFaEtN?=
 =?utf-8?B?Sk1VVk1NY0t5RTh3VDM4NWFQTU92UEZmbjlKc0J4dDZPZ0c3QzBFSy9XNzJN?=
 =?utf-8?B?c0RMSG1BT3paVkZaV0FwcDM4ZXpKNGZ1UG5TT1lVSWhoR0I4cnpXRDlZeEMv?=
 =?utf-8?B?R0NxbHNpYkI2MWw3T0tCNmFYVitEV1M1cW9zVWRWQklrTk9DNGZoTGJkQ1Np?=
 =?utf-8?B?aGw3UDd2NGVQcExkTCs4L3FiMWtmSTNoV3NxTEM4WW0vY21XSUdRZDZ4d2Ja?=
 =?utf-8?B?K3VzUWFJVnMvSC9aRTRNdyt1N2lmbnIxSHNXOWpsSWtUQVRwM2ZoRmMwYUpP?=
 =?utf-8?B?b2F2aUpXNzIwN3dUZHNBTmM3Q3lPNnpVcm9rUU9kKzA1KzROOXB3RG9RUkhp?=
 =?utf-8?B?aVpWZzJ0QkNBVllaQStRczFNQjErK2wvMjBkM3VoRlUxOG5mU1NqU0JlU1F0?=
 =?utf-8?B?d01nZ0hVN1BtcjZrN21XSFN3WnVZMU1CQyt3MEVxOEVZeXB2QnhZYXh3VG5B?=
 =?utf-8?B?d04xNk1Eb2kyOTVHMVgrU2FDcGhzSWhLd2IxZEY0WjVrRVppMWhXV054dmZD?=
 =?utf-8?B?MWVwV2Jac2lWbUtSNVowWXBmU3g5Sk43eWtITzRQbFlRYzNxcHVUaG9reDNn?=
 =?utf-8?B?bmlWQThYK21SeTVLTjlGcTNENkVtVC9Jd0g0U0RObTRVZHpxdGNoTjd4d0p2?=
 =?utf-8?B?bU04ZWlwYU94QUdxNmtZajNWOTg4dGp1aEh3ZDdtMkttTDFsZzJrWHhpRTNm?=
 =?utf-8?B?UkZLZ0s0dWw4c0prUzFiU2laTG42cXRpLzJrMndwYVloWDgzMmVFYkNBR3F3?=
 =?utf-8?B?ZHh0MlAvSytWcXdrcmJkVmVkOUIvcUpOd3VSY1VESUJiTVcvWGlkam1iaFRq?=
 =?utf-8?B?R25FbVBZK3FhV1AxRW1UZjVHWVZ6OTZkRi9KOEFwR1UyVGI3VE5WaHlWVzBW?=
 =?utf-8?B?andVOUh0WjZoU1NwcFdSMjFVY2I2MHVKRmdwc3hQdjRBQzNUc1phR0VUOGpB?=
 =?utf-8?B?bmdTQ1JZRlFWU2J5cWNSeHhqQVdtNXlzQVoraHVRdkJCTXZoWGZuV2ljRkRM?=
 =?utf-8?Q?aKnhGSHHZUa2FC8zcjpCbG6FV?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?QUJjZXRlS21RTjlmejZKczFCbVM5dlNLd25wN29aY1d3S0g5cXVFVWN6SGxB?=
 =?utf-8?B?THVmWXRrdDBSdXkyY3RBQ1RvOXJGaWlYK2ZMUVlsdGZaNFNzdEtYbTc2VUFB?=
 =?utf-8?B?WEFLYjJEMERFMmpRQTVka0g3MVYrZ1cwMUt6R3FDSUtHTnFwQjVZWlVTSkxO?=
 =?utf-8?B?OTIrblUxWERTZGY3TzhVdkxVbHlnTWJmT21mRk51M2hlRUk5M0dydC9UK3BU?=
 =?utf-8?B?ZGk0ODFuNGhvUHVQV0NMcndTNVNrNXNKZW05TDFaSDEvQ0RFZ0lybWMyYXdQ?=
 =?utf-8?B?dHBpTmNTaldCZ204Y2JieXpIVEx4Y3QzOStzb21PR0NJM1MyQWJaVEMyT2Jn?=
 =?utf-8?B?WEI1cWJ2bnkxRVNka2U5azJYUjdQWGUwWmt5K3RNQksreFFyT3dmYk56RVVj?=
 =?utf-8?B?WmtuNWlHSjRIdjE0RWgzaE1hcnVTK3NYRW5TdVE1WHB1cVoxUzhlTVUxakox?=
 =?utf-8?B?YWl6NDZtY3QvVERBR2lneUZ5V05UU2lnbWNHN0ZEK3NIL2M3a1B4dFQ1UEh6?=
 =?utf-8?B?bmRIZlM0U0hRSEtrQ01ybFZweSs1eG9JZjZ0VTVhYlN6aWYxMlVueFI2Q0NY?=
 =?utf-8?B?R24rWUVENGVkV04zMS9SdzEwTmJvL2Y5K2NIWmZJejVvN0k4YnBLd3A3Z1hZ?=
 =?utf-8?B?MStJcWI0VWxhNVYzangveXkzdHBFeG0zQzJQTjFXL04vbXZtS1ZyVm9kcTVY?=
 =?utf-8?B?cVRQTWc5dXZEbFRqdzVXclczR0FHWnhuczVjdmhrcEk4NWZVM3ArVmo1Yy90?=
 =?utf-8?B?a1hGakhubnprdmQ4L25jRjU0ZXkxK1h1ZWFpSmxOTlc4SlBQVGgxbXZndnlh?=
 =?utf-8?B?OXdvSlFma0Nyc3JJVVFCS2VuZEFRVUdSelJ5MnNONEh5ZEh3UFNUWWlOU3h2?=
 =?utf-8?B?ZVZLVHRGVkZmazZobHZKczNhbUs3eUdyNjRKOGpINTRZTnBJWlpDeUhEK0VK?=
 =?utf-8?B?ZWhBbHZoTlFlZlkvNEVuZW1YZXhKalhwSFR1MitDL1JmcVVJd1hOUkErSjFY?=
 =?utf-8?B?RGQ1eXpRK0Q1ay85MW1LUlhNWTNTVzgyVXljWUozVHk4SnRZTFVDRVlrZDI3?=
 =?utf-8?B?Mllhd3dOY2tmWHo3WFFOMUdoZXRpNHpUaW9NMHRYQ2JYNzM1Z3U1R3ZCZ010?=
 =?utf-8?B?N3R4WVNOTThlenRXN1h5VXIwWC9UWU9hOHhBWjZZWjN6RUFSQnAzZlhscVFJ?=
 =?utf-8?B?OEt4L1ZWeFB3aFg3NFovV1p1bGFHSWxSaEg4YXU5UUdNcGkvZUQzRi9PbjNu?=
 =?utf-8?B?Z1JwMFhoYXQzUWNsMGtFejkxblhDcFdSMnNyU2EyK09zYVVhcWQ2dnVzVkxH?=
 =?utf-8?B?VE9sYkZ5aGVPMENsSVBwNUsxbWRjeFN6Tng5ZGlDZnM5aWR6Mjl5YU1HcW13?=
 =?utf-8?B?SFNuUGcxRG5zVzAxVzVMeVU0WDArRHdjT3E0ajFYRHJ1d2orajl3U0UzaVhE?=
 =?utf-8?B?dWRzMW5KTkpqeE1MN056K1VCVjQySXBJbll5bFp5T0ltQVFmTXphUC9nRHB6?=
 =?utf-8?B?d0NQcVd3SlA3YVhrdm5kSm82V2JZWGtpNHV2U3pOTEdlMnBsbWJPNGlVZy9X?=
 =?utf-8?B?QWV2MFA4UWZvQlBPbWdTamxLcnV2V05HZWphbUNXZnBUWWZRZUdlcmZLWWIv?=
 =?utf-8?B?c2hsUGUvUVFqMG96MDhYQ2s1a2w4aHk0NmpoalZpYSs4ckFTbjM2N04yTEY3?=
 =?utf-8?B?UG9YcVVwMktMOHR2czA0NlBlcGVrWUtzbEhmaThnZS9qaitDT1NOdlI5N0FI?=
 =?utf-8?B?SFNHT2FZb01IYnNLUkZtWjNxUDNkT01JV0xjcHVKQk5Pb2ZjczV4SldnSUZM?=
 =?utf-8?B?RGo2eEkrTDJsTXJ3ayt0Smg2bkJ6QTlDSjczM1dnV2pQSGdSZTNYZ0YyQWVm?=
 =?utf-8?B?eWZkcTlpMTRXZkVTSFRJQUdwNmlqKzNpMzU5SXRWZnNNd2FxZVIweEFCR1Z5?=
 =?utf-8?B?dktLbnJZOGViQTYydjFnNTV0QndyTjlieE5lN281eU9BSm45ZUdHaGhHUTNz?=
 =?utf-8?B?Zk1BMkNYYjRmb0JISXRDNHU1ZTZuV3EzUEhRMnoxNG02eWg3aCtHbThjRllE?=
 =?utf-8?B?b1JIdGYvakJYRnppZ2FVTFgxUEFYVkVyYUNrZmZ4Y1RiV2lOS3crU3pDR1lQ?=
 =?utf-8?B?eWVVMnZmbk15TzZTeFoyZVZOZjdhNXBqZFlYMkFiK0NuZHBWczVqZEdRVmpX?=
 =?utf-8?B?OG9zZGdLcXY1UExIU0o4ekR0cG93OGJ2dmRsZmlwWWpNd1BsQUhDeVN0L3R2?=
 =?utf-8?B?S3NJblA3NkluYnVlUGNOS0dLMDlqL2prVEsycFUxQUliZmRJM3Q3a096L3ly?=
 =?utf-8?Q?zaWzCHx7Dkm4NSycUJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be91d9c4-d20c-412e-67e6-08de65ae3d7c
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2026 18:33:36.5312
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 25WLuSJ7tp5Mb/2jzIlc0VwTwRYzDor1mez/nDzXE9g1NFfikJ9J08jzJ/R8h97/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PPF28614436A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ABA1E40010
X-Stat-Signature: 9zbu41rg33jkim6uncwkzaggarszi65j
X-Rspam-User: 
X-HE-Tag: 1770402821-131742
X-HE-Meta: U2FsdGVkX1/d3Urvd3atqRlbYmsUNZYx8gxWRDuqE0TFn1bdiO4P6lzrP9crk9p0lmDkWfiQ3PnLZ5F8anWh+CfP5nwIdkMP11wfLbXFkFRX2V4be9HC9pupmCxAO3mgPCxAkxVgpQU5WJ0uu7IfHYyctUQeFnRi9Ov4q3uoqqRXjMVV119TwmG4zUFTTvloVm5GS/QKGQIlEblrZvViQEtaGIAEhmFwCntdBMcKawxI830QhIPYdEjPNrPwYUegZjHWl/PnwEDJWxRM8GVCw8l1NHsD0FZIBsO7vFLPf0I/IfBL1W5TRTHJugSSNZ7Licmq8MyTLg0hGgNAwkjZMuijidnGnSlBwdZpTB7n0UPw29KLHmYf+ck30P/unDC3inQM4z9Uuyr3qwmTJZDAnxXgKdTHAy7Sc+0XPcHXjdPhtd2aAlNRHZexztMh3DA9BR6dcNvGlxpKQ1zqqHQ3Q8fhOabH9HK5lKOg5u8RnyEWNfvp/dtOnh/7SVz8+luMPicY+lOl+gNcU6Sp6XYpWkDQVlxraFbxFJoE+eWWME7nSxkh6am+7iolrBnYuHVABM25/xvr2Z31sMXtdVeKrdlqARofjxx9diCDfXpNS5pkbAMbPhpHQajHZfgQBRDYpOo7IECBlH/9xMkjin0+685AIUcWP7iIgz+tJIuIUFNBv1tlnv8bFo9+ad6WUhDER50PdMOltml3mhpcI9gmjOtXhhLvyYo1RBajLGNTaLCKLcFa76jECIERzViZD5+bCVWSMGpLxKHoAmrYv+xE4nMUhh8RtBMGkovgcxIZ7kY401rvllVZx1AO3a9GliHE4F4B/ZIk+JcqJ7RPyT49UmhjkL8L2eO4NgfPInyn5bUYtQtgPxkHG/3twx0PvfAinJ5MsT+jg1eEjqUZBYseS2aMwYG5u0ey9czolnv5TieLIvytsWW3bH8P2FCVaoW4ycd9gDeb2UFDbk+siN6
 XRJmKMhM
 uDiBdpgN2Om7f7FwNbu81EaV7U+r1u257GyNqCtCaHQsQkqA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hit send too soon, sorry about that.

On 6 Feb 2026, at 13:29, Zi Yan wrote:

> On 6 Feb 2026, at 13:21, Mikhail Gavrilov wrote:
>
>> Hi, Yan
>>
>> On Fri, Feb 6, 2026 at 11:08=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> Do you have a reproducer for this issue?
>>
>> Yes, I have a stress test that reliably reproduces the crash.
>> It cycles swapon/swapoff on 8GB zram under memory pressure:
>> https://gist.github.com/NTMan/4ed363793ebd36bd702a39283f06cee1

Got it.

Merging replies from Kairui from another email:

This patch is from previous discussion:
https://lore.kernel.org/linux-mm/CABXGCsO3XcXt5GDae7d74ynC6P6G2gLw3ZrwAYvSQ=
3PwP0mGXA@mail.gmail.com/

It looks odd to me too. That bug starts with vmalloc dropping
__GFP_COMP in commit 3b8000ae185c, because with __GFP_COMP, the
allocator does clean the ->private of tail pages on allocation with
prep_compound_page. Without __GFP_COMP, these ->private fields are
left as it is.

>>
>>> Last time I checked page->private usage, I find users clears ->private =
before free a page.
>>> I wonder which one I was missing.
>>
>> The issue is not about freeing - it's about allocation.

I assume everyone zeros used ->private, head or tail, so PageBuddy has
all zeroed ->private.

>> When buddy allocator merges/splits pages, it uses page->private to store=
 order.
>> When a high-order page is later allocated and split via split_page(),
>> tail pages still have their old page->private values.

No, in __free_one_page(), if a free page is merged to a higher order,
it is deleted from free list and its ->private is zeroed. There should not
be any non zero private.

>> The path is:
>> 1. Page freed =E2=86=92 free_pages_prepare() does NOT clear page->privat=
e

Right. The code assume page->private is zero for all pages, head or tail
if it is compound.

>> 2. Page goes to buddy allocator =E2=86=92 buddy uses page->private for o=
rder
>> 3. Page allocated as high-order =E2=86=92 post_alloc_hook() only clears =
head
>> page's private
>> 4. split_page() called =E2=86=92 tail pages keep stale page->private
>>
>>> Clearing ->private in split_page() looks like a hack instead of a fix.
>>
>> I discussed this with Kairui Song earlier in the thread. We considered:
>>
>> 1. Fix in post_alloc_hook() - would need to clear all pages, not just he=
ad
>> 2. Fix in swapfile.c - doesn't work because stale value could
>> accidentally equal SWP_CONTINUED
>> 3. Fix in split_page() - ensures pages are properly initialized for
>> independent use
>>
>> The comment in vmalloc.c says split pages should be usable
>> independently ("some use page->mapping, page->lru, etc."), so
>> split_page() initializing the pages seems appropriate.
>>
>> But I agree post_alloc_hook() might be a cleaner place. Would you
>> prefer a patch there instead?

I think it is better to find out which code causes non zero ->private
at page free time.

Best Regards,
Yan, Zi

