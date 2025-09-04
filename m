Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D047CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741DD8E000A; Thu,  4 Sep 2025 12:03:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719708E0001; Thu,  4 Sep 2025 12:03:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1328E000A; Thu,  4 Sep 2025 12:03:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2088E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:03:08 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8683119B52
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:03:07 +0000 (UTC)
X-FDA: 83852036814.13.3662245
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4749814001C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:03:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d6aUS4vb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g6a7Ypgo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757001784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=13kLxXiKk+xtYBcSVua9hGDvyZplxz1eg2gklVpacDo=;
	b=A/PZCxdKskx6B85HpP48211Dob+TZ4OSRWYu2rzILJiGnIujUd/qDf+PT1oOnAO0u/NTcs
	I4gzUHJaip3iKVnZmOOz0AuYfnVk7NJ2wWRYRFvHcnleEGv9+CZM33ZLCQKkaaf6QsFi+U
	lVcIoYiYyihol+6aauKcC6sKX9M20Jc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=d6aUS4vb;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=g6a7Ypgo;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf09.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757001784; a=rsa-sha256;
	cv=pass;
	b=tyl+FCWflRnftaztAiDxGBqtnxwJtA2oCjv8rpzgf1A+JlCQx7Kf6SzqNlWGlkZkq9QjJ+
	lnwyQmBdvkpH7H9ALSxq6g8E04ie1IReo88ADbS8AfZeXgWpTgYSP1RekkK9v1D7aES1xM
	+76+J3LKOe1ACWTARzbevmGhQJIjk90=
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FurdD004119;
	Thu, 4 Sep 2025 16:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=13kLxXiKk+xtYBcSVu
	a9hGDvyZplxz1eg2gklVpacDo=; b=d6aUS4vbg2L3/qjRHdD6alPflSFqwj9tln
	w6ub+YpnCU8r6HseXQpjrilSNzS4SuGq9MuAiDCFSeFAwHFwj+V4JrDSaHsGy9iz
	O1JdIV8h7QvIYPYQsxWIv8VIXskvy3lMks45csQ7LtpRVWGPrgKoM67o/tWSkLhC
	HsGUizg52JzcIHLDioxnP/XiUa3HPE5zI8MxveyXl/VUdfEOrkuj4QVwViBmK3ja
	9KHuvQBrHarq0WjzLpfgH8R9I7eXUTa98ULMkmWONsurxC3HwTQ6vU9EMkZ7/D/z
	wcaN5YIcrwPlIZI+jrML7HbNrB6WV1BI1I7IsxlBpae40k5VuTng==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydun00ew-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:02:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584ETVcx040662;
	Thu, 4 Sep 2025 16:02:57 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010042.outbound.protection.outlook.com [52.101.85.42])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrbfrtd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:02:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jDzRiQyYfyqTL6MMmDih5UbpQzY92dOVwr3DTibQu7nJ48L0vSm28pt78/eMf7mUj2G2k//Dnb5Ic6ZuyeqKt0WrfKw2hTZN2orcxhxJPzUDhWnr/gmjwkjRVCHjzurOJEIz8bvQEo5lVVmJxtQsx+b1AUutnYXxGc03ls7VYf+/V2oLsgX1teEiRCEr8Bw1DWRfg9sY4IhtTfjihwmXVf2w3xMt4vtGnidQcjzXT6ZWiUAVf6vFTx27hv/D1LPi+demx9q4Vsz8IHZ2WDY7O7H8tdaSpypVN7SWG40T73oJSBrUJbDFPGBj7Y0ADPhf+m9ZLrzmVFhPYc8MY90sCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=13kLxXiKk+xtYBcSVua9hGDvyZplxz1eg2gklVpacDo=;
 b=wg5yHUWaNyBmiVRPuLvoXTAOxoJ867J6x+IZpnPR+ZwG1IoMMkDj5N+x5a68L0VVV+EnOO/AxoVH5S2F0UeOfmyWzpLTK72LJszt9Ijty9W39CNlO98yOi2fgNOS25XZHChuB5ysD3b2kAo0/t2ReCWteHKn0eQiA6ailtnykR53IywgmnU2o6MJbFT4UEtvv6ghbEcKLWcERdmMqT9KXAx7RMTeQfKkaIicEdvJOXNfiYVxwqkZHkkBL0vYl/oRDIxS5G69tDJ0EKZBRUmGIjfKJ4VAkD9KMFvdc5X+UnIdhLIvydU92C4jj4hj4+VAQ16kCFq1nZcQlR/w/yRDPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=13kLxXiKk+xtYBcSVua9hGDvyZplxz1eg2gklVpacDo=;
 b=g6a7YpgossFYhpDpK2hC+dwj0bIP1YNGpYyEGIU9X2iw8UsqOwWnWlCADdmFsxTFJN57xzBDv/PFRi6NuA7SH9P4b9T8YPLcR2QM2f9EPCoQtTiFk5xtVMLRy8SJ2Sa+wUS1DnnGy+L5c78WxGvhr595ZxkZ4L7inoIX04WGzqI=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by PH0PR10MB5869.namprd10.prod.outlook.com (2603:10b6:510:14b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9094.17; Thu, 4 Sep
 2025 16:02:54 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Thu, 4 Sep 2025
 16:02:54 +0000
Date: Thu, 4 Sep 2025 17:02:52 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: akpm@linux-foundation.org, minchan@kernel.org, kernel-team@android.com,
        android-mm@google.com, David Hildenbrand <david@redhat.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: centralize and fix max map count limit checking
Message-ID: <827c844f-7106-4f62-a108-1f83544aa56e@lucifer.local>
References: <20250903232437.1454293-1-kaleshsingh@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903232437.1454293-1-kaleshsingh@google.com>
X-ClientProxiedBy: LO4P265CA0090.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2bc::11) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|PH0PR10MB5869:EE_
X-MS-Office365-Filtering-Correlation-Id: 9322da78-ea38-445f-6e4f-08ddebcc81c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|7416014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HkIMbmyhPn5Df/+Ux+cBocXGDrLtT1Gcx8bCmQdKGcVL8KHJ3RMrkUbFLNbd?=
 =?us-ascii?Q?dWCPGDzwbLEJMQtv3ce95jAOQibh5DRYBLdt2IqBgyE5CJJWf9IdhnzMEcU+?=
 =?us-ascii?Q?kW/+36AfDvtZcX55qluCe22NmMhvQf1x/XcD5EYnB7xmwUxtOkU6CW2fmVzp?=
 =?us-ascii?Q?efUmOOAgTBX1t8F5oZgxfj6lZtaz4iN7Jux+O8CqnylF1kAQ8kktnxPfmaj1?=
 =?us-ascii?Q?6MRvlLRejWqXeparN0hYqrfUML6VoiQ2PkdYSQ0CsGeWzApLPAG+wijQFFN6?=
 =?us-ascii?Q?yrhhfzQ1kplTiEIZ24XDrkHS2D6R5T7JpxSPOQeU55s9a+QX6JwKPrJudwiC?=
 =?us-ascii?Q?aC8lufJn+BJZ75jdRD0msLrrW2Ku3Sul9tZbggQFtfDze1RaS8oJjNUQd+3t?=
 =?us-ascii?Q?nJbNXSGNaV68h0hGdJ3JpAufVqOl7DaaWBoZZajSEoSaSGPpQddDvs17rJu/?=
 =?us-ascii?Q?7TwSz663+2dbYJ4RzMc4ePI/zGCLxHoNdCoNzAu1+Dimd01SV59Je2TVbJ/M?=
 =?us-ascii?Q?AIWGjHXtwRHR+FRTlBdw+g5WVz18mWduUDlzeX7V9OfJOLa/ms16FTOjsnns?=
 =?us-ascii?Q?RU+5CTih7AMd8LYTfimDNKdrur15q0o+LNrdL/Lfuz3DlJjCU7A00+2AGMie?=
 =?us-ascii?Q?okT86X2LBZrFrOgzyk5WFBNtdXzxShBzAg1NinNbrxZRGNLLxC0rRdEITJLb?=
 =?us-ascii?Q?knsjIF/DTsJmwu51P3kYGnciiJTlqRrJd/kVcq/+kL9ypdWqdt4Z9ujLuN06?=
 =?us-ascii?Q?0xsSwtiDzABlGskpYtL8Np3RmgPIeV17yLbZLRgA5+t8DL5/t+pRR0A6BW3X?=
 =?us-ascii?Q?gR3AYsvIslsQJ9NaSerrdCCzk5FHXwSwzOx0LGIrpI7j5qTlSjzCuMjHs6rI?=
 =?us-ascii?Q?pShZzFATE5BzQtQ4/Ktsn3FIWhckUtvxQ32nSU1SgAinysruvZaihPX8W1Yl?=
 =?us-ascii?Q?GP36cVTBcXqBCu0gzXR7wJ1MyeEnxF+xW71vNQwE20/k8eDBMLj/m+Xy8UbL?=
 =?us-ascii?Q?ddOm6WQmjK1IZxHjut6p1wc0bhDFVSTb6WXYscd4mTCvuvplIUODBVQll3wE?=
 =?us-ascii?Q?STrbxRSuVWn3Tj8PU2ApP6CCCNoH1qdNssmcSooYRkpTmmzD9ZM15xUsh9qt?=
 =?us-ascii?Q?hZbQ9X/w7q0ot49cL18C1+A/cuiKzlCvLEQtc+WzaJ4PxOtw7H2/S/7W5wUi?=
 =?us-ascii?Q?5+imEwVyUCoiJ/s/k/PSQBRYRys60PzXzxkFVYiob5sxG9+hTlffo+MUW1vJ?=
 =?us-ascii?Q?n734+8SOggaca/byXRRkS/mfp0Ruypf9kvN6arkcrj73R9aR6YGSQGH2UfRB?=
 =?us-ascii?Q?rIvTjzrJUx2Ey/Kps/z+BKl+pFEV7qAlkdeausJPN+AvCXzl7tc0mLRR+yzB?=
 =?us-ascii?Q?rpG34/YwfaIn3zgcsyG9Xyv1kRnRu3tMIgAyx9bVqIwxfEWiuiejDoOCr3FR?=
 =?us-ascii?Q?pJbQXbYgqvQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HITe7XnjrQMjbvx2HHKlPj0biJvfiORUfgkQf14OgTQti+YZRBWWfD4ylBn3?=
 =?us-ascii?Q?F6DwZ/t3WQMWEGtM2fZu1vCuiKd9El+xQJf3artgiVc9/MmyMhItSakqWlx5?=
 =?us-ascii?Q?QtQLi8tr0lmLG03ECYBWn9Y5DNwkMWfhroVE24WMhGZlO/SojvopzUr8lDjZ?=
 =?us-ascii?Q?3oklK9qhmlPsDPFk0b0dwdLNhccdXhWSHBDO0rMnOVCBI3K5aCdz5xvw++EK?=
 =?us-ascii?Q?xO7mm09rSIyPcWpai4UYondze/atecs4e5jXWXlJU8hXjGUoS2hX+ejSU5fj?=
 =?us-ascii?Q?7Z6BLrRXh4m5/9MXIn88onPsr8NH+TkvpvCVTVRVD4G6mos7jllzQ7Fc/bYt?=
 =?us-ascii?Q?sLoPSqZ6Kn3t3T82wf6oIzPImJ1lx9NZ2bDDNmJ7UV6bS04v9Ipd1RRRcYFF?=
 =?us-ascii?Q?zad8/nOcO1gjbkyF5VUMQlSGU03Hl53wtSKnaHv2GrCyoj5xKJf8FCEGTTUY?=
 =?us-ascii?Q?ETOmI9QPp/j5uOrbhR/hPKEH+FFYVNpmYh6Rot3kujtP5qNvOvLBmx0Hrhc7?=
 =?us-ascii?Q?PprsGiTfc41qnFpZgUdNmQbEK0PSnn88zkiemkZX+kbS/l9Tzvu9KkoJ/T3b?=
 =?us-ascii?Q?ijRIYVhZq9PcevVoK3dzT6qtzrBlRUVHVTHXboNRan8NV3Geh0nDWLTvgcHg?=
 =?us-ascii?Q?BbmWcVG+rOmRp+qCB5ZwvZsyB5sriAwKxrBKtiwikCW7l2w+qvrnH1dNdvcB?=
 =?us-ascii?Q?mRhbtO3FFeBqU8MCUx4CuKOHN+llYfl2B59E2zw2ytFxME0mcYFc+PMCSPFt?=
 =?us-ascii?Q?DkzbTaw8ssJeL05RvQ1vIkPlk0yHZWFtgegWsd7g26ppusWtMw8x1FA63UI4?=
 =?us-ascii?Q?sKqtRRi/c+MVgfpMODue4b9JppgtUfUegjBw+1w77F6SvX3IOnxti3QmTXlo?=
 =?us-ascii?Q?KUeHN7vE/ir3jcrnKMY3jtPBHCyKFqLwuOlHbbCttTVySqrvurttsUcYh4I7?=
 =?us-ascii?Q?W4L/FSAQPCmUWe+R58xPecODML3RTjjS1QwV/YeWjpclETofFSKvCov+pREm?=
 =?us-ascii?Q?xTicueCQDPGyGXZqLrXQxBxWXegrQu5Fkwb3Uv6VAucWPtkXNxSGCKdPAy6n?=
 =?us-ascii?Q?Xq+XjQ/LVwJFwFOrniWHaVMlsBOSnhrZM0ESPuuHJWVWGqZEKygdMEp+UQw3?=
 =?us-ascii?Q?6fCmXWjGR8SrQBQa0izaP01JNIGajxHBxLV6H4GLu3olHmviq6JDY6Cw94rc?=
 =?us-ascii?Q?b698Xk/gTEaK9fiyHrkZmXiWZD5Y2QmsGxfLoy7Ff6c0HXTtgOtfSGtMScEz?=
 =?us-ascii?Q?6iA1ba+IQJkFdCdorFBxnNkT/TV9FTRiQK7Mpm+QfhiNr2l5k13RaGP03S6p?=
 =?us-ascii?Q?zgGikO3Qi0A6LG86pYH8QGoAO7AUsBvpdHj6nMt/hdz/UjZDGLx7JhDz270G?=
 =?us-ascii?Q?L6n8Nqz+aETW2xQ1lkmdZrFtFIkS5Hz067iCkXSrhGpHStMQ4d2cu7ZbS/Ve?=
 =?us-ascii?Q?wK2Py7IX4PFxHgaguE3DsklprsrH0+pP8g1HOOOkKAMNrJTS3LMldzAm7FcX?=
 =?us-ascii?Q?kchHVZCW8BlpPWnXqt5337VeQ7UPiZC0byfOuoe0gnxTdx/w9+Lo8Qv3o1mB?=
 =?us-ascii?Q?OOcbWByYQTe+k6D3z7VGedHgcA18Sn7pgw5tnUDLGNzjzcNJuMfSV0ujYlpD?=
 =?us-ascii?Q?1w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	vNqU6iH24Vzf77AwhgsU7OsRPOeRGMYtjCKEUCCstQKgkbOUCxh0FBa+aZpfYaRwXyzm0ZULQwHczRDZSfFK2TbDzVx758CIRiDFLeKFFM82rihXmf5wjUYwzxLy8+GIE1LPV79BvM7nvxUZr3DpjQSHrSOCiVZG8gMTTQyz+5Pj/57+qDrvev0DX11we+Ei75DWLgZ2J4hsxSEpLRwqRqksxXkXLfEQomKB99xZ0W3gFbun1/6TNDookk+WU0TQwj/LPpw1/74cJlcfHzgKSU+fz4eDlLIZUJb+QHr28Yc9WXXGMS5E5Zjko06oZcRsVCvglaTeu1Ai3IRe92d8Bz3v+DvQYPIz4C3QvG4zMjIQMmGstOC+cb5M6bZa6Ym+s3tY4hFaB1X1npVK8T/vmGAlZvAUSCwvozzh1W/obueNKOka2kJCHuVGibfxhpQI5+f/A6Q6WyIDGPl7MKpyaFleQyWRr9BHSTwY74i7xkxiq8kQAxS0G64uDl6iMnE7xtxWUb+91NfsKFy94O5S1t2rHsJMlBh32dhPzuiJlOJfPbXoFCVQpNmhqgA09M3Q84SeXXJDWTdpBg+wecuiYzXwuZRh+4G0e6fBsczod5I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9322da78-ea38-445f-6e4f-08ddebcc81c9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2025 16:02:54.0463
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hfpz/IwsDJH4MMF38A95N9E5I01tzGmB9olFGulNDOBybjbz6YivhQyYnd7qwk3C7rdvuGmF/mH5lUIGgbzIu6elQ+wX9AxHC5BRV+Jc660=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 spamscore=0
 malwarescore=0 mlxlogscore=999 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040157
X-Proofpoint-ORIG-GUID: pDpP7lPdasbDdpmuMTC8KGyTRPj42R0c
X-Proofpoint-GUID: pDpP7lPdasbDdpmuMTC8KGyTRPj42R0c
X-Authority-Analysis: v=2.4 cv=cfXSrmDM c=1 sm=1 tr=0 ts=68b9b832 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8
 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=9w0Fa5hAWf1X5SmEhloA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1NyBTYWx0ZWRfX0qBTyKNrTWzr
 +57zccJxXwS1r2dHXRuYSHxl2xkJkuurU6tKOySZx+XIPV486RcKktAu/5Hqpu2RZ9N1T6vMcWt
 nE10BlOtphY0skBu+Zvx3rcDHMIKDrDG6iRofscyBaUmyAq898UmMs/f4T1bXHVNk+oJY06PDva
 0OHSel0rxtenn7EyTkqp11fp2TG4uCnTePVuUVLYfjW54IKtlXurQTm9ZXTsceeUrwDQJHzk7Z3
 cgKGHbRMhbJ2GwFxJS22NVndugGP9BeVqb/fRYY0kYJcqEI8ijpnsCEJVJ9LBv//QW1pG+fbeIp
 AGr6Nytf7Rq73zXLczFksbygqgGwQdYYxBOFg8zFzl7AhJZKlMiFGYkZv03p+BkF8DGwd0s4Qp3
 zjkl/r8I
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4749814001C
X-Stat-Signature: yshownk13udqrh57c93xy1zgstm6cio8
X-Rspam-User: 
X-HE-Tag: 1757001784-252008
X-HE-Meta: U2FsdGVkX185gM2fJ43v0ztzXVDjEJhW6e4wAIGi0e7HB3YGsokb2FSfaoZf6nQVmkpai5m0gJBQcwbihLh6jzRiNS79twGW0x7Tc1BKWDXVFDJQvTnNdK08JMbVhmnhcHH864E6HGihV5RsV0AYtYGJ2BGzwc0KiqQHiPTNt9ZlRWveeW71/1aCvnOksA/qd88nrJCdSLc3dDbPU3a0wljPmFSenki5vGbTiJGGW2pizAp7ehen7x5sty0Q8qzDfNGHgFe0OhKFr8q/4T/ogVTpF9cuWCIRGgH/08irQgMA21kXkbx1F7za4ysI9X1Mb9FUOl5FDAif2eNX4WXn0BENncNyZPLL792ag1XKhu6cXr9gxhAFIcrSP+x+er4TzUPI5k5URTIfcLBzq5dQ6x5ey4wkqTqAGMZpVifvRgSvhgspEm5mhpsk0tpwzFfTUUSX5PXYouANJs70jKe/xBN/Yv/9E+xmMSzO6r9N8T/sBmqEvRY/kaOmA5jqLCJlDvDn8i330tPLIh0F6dUHqWdz+heQ2E0QkEV3sMdEdVPGnmwz8ABZKzUq3xIWZtyhn9A9Yc8DsoL+JdBkyACC8sr71XWVFXT4D1HMX/JXxvx0jwfP1i9nYWFJvjIxXLciHpQJdCybOtNjYzDduVN3VYJiwaAP9uO2KSbM/6C3nvYGwii4C2oPQMuL1cC7Wp1up6LQ/sgX/TJGZLTNIEru+1Z96bCvbCnIMVVSwiJvVtfsX676OUlSQ93LgL+Hz25boluPkQjDAbt7VafRCm41oRRFyVr4oSmHy/wK+jJ9ET4m1af8vyptI4lMa0p+jXhQ+vbvJPoXRBJkEevbbjWSA4BAnacOiIAqTnl206FGH4gLz93m/XkYWERCKHcAzLNwHNM4BdWytsUchuoqI2Vz/XsNOVrTN8OgbiVlpRNR+0oca+JMQAOEEaqFg/Qklwh8vJ5UofeL/vxELXeIhZ8
 mBSD3sOw
 QbQJUV6g0mWgigDk5+Fvp5Z7y3KO5X3HCNQlolJ+vKAx0t9cbC4hgndLz3SYgt1MokY7wCAvHECZajeb9dWTs35XGbfRgzrIWqouWrQxrIVkmyYwWLCAlGUWBNRqHAZUQ50VMAplqNnYGGD+bIdC6jwRnAkCRSZ59MGCC79VcirKbbE4+zzmjG5vrjSjC6I4YaadBRnf0/6uLY+0R4LlkVlOuzt8PjZUmnYrNtFngXVjrvTyxGwjlR+lmXXkwgE1gnWZ1NPTTQhlvythJWqkp9F8miz3kwoZIsCZHNwaFsPLEEn07YZkPYjRGJS9KqYwTqz44DqLOcJZ1k0j/Vtk9KoFdlSWIArHtzQJ1qdxDchvvm8s35V6b73rPJ0M3/1K8rNueP2EO9ONQ8ANmNvLuVRjAvHHJUjTjWh1KBXOdwhWr4QhjEibMvl11xRHOaAv15sFsJpx9naQd5/yRvy9EleV472gtsf+yexIC6VTZ7Afzb+p0IDLZztBbVdOKmsF0S47KixFEVOf+2qMOBDnqAWk/nnKRP59g0Pd5w6cEhTCl4iQ7U2gVS+vTpHxPqACojECYg6U/F9qo0SjHEsoiUJjT6gMm/2T+aAsVFCfb+qjUMJA8Aj7izV2eG9xiIibcsSYgfco2s8fm5bmthsUIwpt7v3JO5BpTX2ymRnoWpnhEmLeViR4B0hyEkG5XGGSKXwrK+QMrEIXiRD1GQ/+W2i1cAu4DcGC2fMDv72PVR/+jUovRwWUfYZMONAw8oSihr78ssqFV//rtTZnZBva5+ztrG9k+ez8ab1drCSSjflHP4huUdVH9IG2Ho0uXtcRyTY2wD59CAfeo9rKqXFbfD6fAmg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:24:35PM -0700, Kalesh Singh wrote:
> The check against the max map count (sysctl_max_map_count) was
> open-coded in several places. This led to inconsistent enforcement
> and subtle bugs where the limit could be exceeded.
>
> For example, some paths would check map_count > sysctl_max_map_count
> before allocating a new VMA and incrementing the count, allowing the
> process to reach sysctl_max_map_count + 1:
>
>     int do_brk_flags(...)
>     {
>         if (mm->map_count > sysctl_max_map_count)
>             return -ENOMEM;
>
>         /* We can get here with mm->map_count == sysctl_max_map_count */
>
>         vma = vm_area_alloc(mm);
>         ...
>         mm->map_count++   /* We've now exceeded the threshold. */
>     }
>
> To fix this and unify the logic, introduce a new function,
> exceeds_max_map_count(), to consolidate the check. All open-coded
> checks are replaced with calls to this new function, ensuring the
> limit is applied uniformly and correctly.
>
> To improve encapsulation, sysctl_max_map_count is now static to
> mm/mmap.c. The new helper also adds a rate-limited warning to make
> debugging applications that exhaust their VMA limit easier.
>

Yeah this is nice thanks!

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>  include/linux/mm.h | 11 ++++++++++-
>  mm/mmap.c          | 15 ++++++++++++++-
>  mm/mremap.c        |  7 ++++---
>  mm/nommu.c         |  2 +-
>  mm/util.c          |  1 -
>  mm/vma.c           |  6 +++---
>  6 files changed, 32 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 1ae97a0b8ec7..d4e64e6a9814 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
>  #define MAPCOUNT_ELF_CORE_MARGIN	(5)
>  #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
>
> -extern int sysctl_max_map_count;
> +/**
> + * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
> + * @mm: The memory descriptor for the process.
> + * @new_vmas: The number of new VMAs the operation will create.
> + *
> + * Returns true if the operation would cause the number of VMAs to exceed
> + * the sysctl_max_map_count limit, false otherwise. A rate-limited warning
> + * is logged if the limit is exceeded.
> + */
> +extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas);

No new externs please (as Pedro also pointed out! :)

>
>  extern unsigned long sysctl_user_reserve_kbytes;
>  extern unsigned long sysctl_admin_reserve_kbytes;
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 7306253cc3b5..693a0105e6a5 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
>  		return -EOVERFLOW;
>
>  	/* Too many mappings? */
> -	if (mm->map_count > sysctl_max_map_count)
> +	if (exceeds_max_map_count(mm, 0))

Yeah this last 'mystery meat' parameter isn't amazing though to be honest, it's
kinda hard to read/understand.

E.g.:

int map_count_capacity(const struct *mm)
{
	const int map_count = mm->map_count;
	const int max_count = sysctl_max_map_count;

	return max_count > map_count ? max_count - map_count : 0;
}

Then this would become;

	if (!map_count_capacity(mm)) {
		// blah.
	}


>  		return -ENOMEM;
>
>  	/*
> @@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
>  int sysctl_legacy_va_layout;
>  #endif
>
> +static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
> +
> +bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas)
> +{
> +	if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
> +		pr_warn_ratelimited("%s (%d): Map count limit %u exceeded\n",
> +				    current->comm, current->pid,
> +				    sysctl_max_map_count);

Yeah not a fan of this, we aren't warning elsewhere, it's actually perfectly
normal for somebody to exceed this, this isn't at the level of a warning.

> +		return true;
> +	}
> +	return false;
> +}
> +
>  static const struct ctl_table mmap_table[] = {
>  		{
>  				.procname       = "max_map_count",
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e618a706aff5..793fad58302c 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
>  	 * We'd prefer to avoid failure later on in do_munmap:
>  	 * which may split one vma into three before unmapping.
>  	 */
> -	if (current->mm->map_count >= sysctl_max_map_count - 3)
> +	if (exceeds_max_map_count(current->mm, 4))
>  		return -ENOMEM;

In my version this would be:

	if (map_count_capacity(current->mm) < 4)
		return -ENOMEM;

And etc. etc. I won't do them all :)

I do think this is clearer...

>
>  	if (vma->vm_ops && vma->vm_ops->may_split) {
> @@ -1811,9 +1811,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
>  	 * split in 3 before unmapping it.
>  	 * That means 2 more maps (1 for each) to the ones we already hold.
>  	 * Check whether current map count plus 2 still leads us to 4 maps below
> -	 * the threshold, otherwise return -ENOMEM here to be more safe.
> +	 * the threshold. In other words, is the current map count + 6 at or
> +	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
>  	 */
> -	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
> +	if (exceeds_max_map_count(current->mm, 6))
>  		return -ENOMEM;
>
>  	return 0;
> diff --git a/mm/nommu.c b/mm/nommu.c
> index 8b819fafd57b..0533e1e3b266 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -1316,7 +1316,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		return -ENOMEM;
>
>  	mm = vma->vm_mm;
> -	if (mm->map_count >= sysctl_max_map_count)
> +	if (exceeds_max_map_count(mm, 1))
>  		return -ENOMEM;
>
>  	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
> diff --git a/mm/util.c b/mm/util.c
> index f814e6a59ab1..b6e83922cafe 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -751,7 +751,6 @@ EXPORT_SYMBOL(folio_mc_copy);
>  int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
>  static int sysctl_overcommit_ratio __read_mostly = 50;
>  static unsigned long sysctl_overcommit_kbytes __read_mostly;
> -int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
>  unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
>  unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
>
> diff --git a/mm/vma.c b/mm/vma.c
> index 3b12c7579831..f804c8ac8fbb 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -592,7 +592,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  		     unsigned long addr, int new_below)
>  {
> -	if (vma->vm_mm->map_count >= sysctl_max_map_count)
> +	if (exceeds_max_map_count(vma->vm_mm, 1))
>  		return -ENOMEM;
>
>  	return __split_vma(vmi, vma, addr, new_below);
> @@ -1345,7 +1345,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
>  		 * its limit temporarily, to help free resources as expected.
>  		 */
>  		if (vms->end < vms->vma->vm_end &&
> -		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
> +		    exceeds_max_map_count(vms->vma->vm_mm, 1)) {
>  			error = -ENOMEM;
>  			goto map_count_exceeded;
>  		}
> @@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
>  	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
>  		return -ENOMEM;
>
> -	if (mm->map_count > sysctl_max_map_count)
> +	if (exceeds_max_map_count(mm, 1))
>  		return -ENOMEM;
>
>  	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
> --
> 2.51.0.338.gd7d06c2dae-goog
>

