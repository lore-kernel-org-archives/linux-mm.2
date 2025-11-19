Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7797CF2588
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 07:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BA076B002B; Wed, 19 Nov 2025 02:03:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16ACD6B002C; Wed, 19 Nov 2025 02:03:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0313F6B0062; Wed, 19 Nov 2025 02:03:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E0C656B002B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:03:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2DF9716038E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:02:57 +0000 (UTC)
X-FDA: 84126464394.30.4458AAE
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf06.hostedemail.com (Postfix) with ESMTP id D6378180002
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:02:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VEHNZmPO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YTd+qe8d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763535774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AAZsb+F3vBl6bdv2+yhqEH+v9GkXZO8p/pcqf1FO9es=;
	b=6jIQO56i71ZIGUrVhV3ybqvKNAy4jbbQkAq81CK/WiwJS7ELkAf+Vd8ZvODYuuKCEu3BYa
	HV4QD0MQdysqLEf8/aTDuC9+xoDX4WFX9JLUxujGWPoRSpLz2pgpumzdR+DNysObMbf/xr
	b8qfv8SiDZhZVqUey5Qzw5LONvfU6Zo=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1763535774; a=rsa-sha256;
	cv=pass;
	b=1hzJpZARSwXrSCVvuq1pTBvweGXyFaXQGvVw8Yy8x982qPaVeL0v1iPNHyeO/46jxEfw5u
	znPZO+8R3LBd5Z4cAazQ7GwSSXhvU0qbmMdVPky8r52M1qvLG9la6QEgriFTR7hgBj+Dcm
	DGufNNAXg6YvL4DEcPvJ7pv0rakrkAE=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=VEHNZmPO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=YTd+qe8d;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf06.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AILNg2c020622;
	Wed, 19 Nov 2025 07:02:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AAZsb+F3vBl6bdv2+y
	hqEH+v9GkXZO8p/pcqf1FO9es=; b=VEHNZmPORCSx9DBFtWHPIwD+Cz7EI+y/Zc
	RGFFXZ638c1ivNaqDK6Ai0QsGTNc9zia0KOYWqB/FDjoP+SoNk4K/YzvJEzmXPVq
	W8vjZuD8MRLEWuLAwbRyhCRJvUiIZt6n/j+Iglje3FwYL5jONxnB48WgPUHsXkor
	G2m105wW2pT8WqtqRdnfUuEfukl36qL2miArW+kCytJfpqfA0v5jN0KrFwg1wA4W
	TwsJg3qzcSBbRlRE7Xro1O0Ncv9FDboEnFMxo362zgTZwXIIbz22WsczelrmqiCR
	XUrXYYIupzID3xekKHyFdYzUhczvJa9SfH0HGDQNdjA9hYtIKa0w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejbupcq9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 07:02:39 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AJ5Jt0k007206;
	Wed, 19 Nov 2025 07:02:39 GMT
Received: from sj2pr03cu001.outbound.protection.outlook.com (mail-westusazon11012028.outbound.protection.outlook.com [52.101.43.28])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefya7066-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Nov 2025 07:02:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xc5ry1DGlLTIm55UfbionZ3H0/eX72zCjfzREO/8uT4JjIvkzC+6hBrpX5ILmYhI0+lWwXei4n3y8zmC8h8y3RecA7E6jxxN0rBnFYySUFxUwdu8xBSyvei40ldz9rH3fIc7zYrHYoNC1l+gRb8lco8fsIQaWtDTpvPEwfIE9hWi05FyeuZvRkNB/U8gUnQzz3gArjIidG1gQ5fmdTWYCr/XRmNIDYwhiUSGRYmazpw/VgPbubQUR+wLEHLLYpUesvffpwLFrruO4QHPCI3U+30OtMfHKOGBTx24YSMMZCM3GDhLryCSlwGPscDWdKmyxMjaNHdLp6jE+Uk5pEPRGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AAZsb+F3vBl6bdv2+yhqEH+v9GkXZO8p/pcqf1FO9es=;
 b=Cd/srjkze3CRt3vAkP2h3hAt7Re3qXNzpfT8VQKxKw5d0BgPP0kyJDjcCdk89A3ucwhP/A6UNX23r/53S8iCAsJrhnjCcFY0OW3zZ50msnzLxw52yFJEG8pBEEscbTrT/8abSo67xw7sYExN3xzBBL7qfq0/d1IZl8aoCNQHO/clUQLvQuSefHVd6RrTBTlCy/ztj6HhSk8K4JtCStGUmjjC8L5yzqP5u1dJnnkQC9uUqI0ekdaPd+43YN5oyt9DeJOrZd4eTPeytn2W4N717D/HhhPMaHA73PotWES7/uXzQbzWdNWhXxLbI6OUUdp5GjSfSNs+y5ALd+cz6Tbm/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AAZsb+F3vBl6bdv2+yhqEH+v9GkXZO8p/pcqf1FO9es=;
 b=YTd+qe8dYglpkPkxouEHK76PBAxSjhxq+3lICP9IQ8M5282//4ioIuGpUi7e9z5v7C9r1xWNu2llvAhcBUmbZUDeLSHW8VreSrXTi4bYphV0oVXoiqFWvoKMJkPix88gfHC/rqOU9QPYPep7Kqs5mWyUe3/Tk3vZgF2zDyeE/OA=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by DS4PPF415C917DC.namprd10.prod.outlook.com (2603:10b6:f:fc00::d19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.10; Wed, 19 Nov
 2025 07:02:36 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%7]) with mapi id 15.20.9343.009; Wed, 19 Nov 2025
 07:02:36 +0000
Date: Wed, 19 Nov 2025 07:02:31 +0000
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH] mm: Tweak __vma_enter_locked()
Message-ID: <8d4744ee-3f5a-460f-824f-11c632732da1@lucifer.local>
References: <20251119042639.3937024-1-willy@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251119042639.3937024-1-willy@infradead.org>
X-ClientProxiedBy: LO0P123CA0011.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:354::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|DS4PPF415C917DC:EE_
X-MS-Office365-Filtering-Correlation-Id: b787e663-18f7-45e0-589b-08de27399e9d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?je3EeSZQDxMkyeaswZCA/7W1FPjKGIi9Iv2LsqhZiBZGrGGqWPzslAX6vVwu?=
 =?us-ascii?Q?vRXlHzqBNlZAzihFtyOC+Wh87WSBoBtNRiXC24cNmifrPr4mzwvEU2BUckmr?=
 =?us-ascii?Q?tAnk3YmFISrRNsjY1YnrjWrrVn9RtZb7I2SRrUgBoBeL96kApbCOfVp23ZBS?=
 =?us-ascii?Q?p/mKCeM3CUqYcchJ1RpMl3OR2dyWdncbD+Plrn0Qd5tS1/mwx1z8NdjV/LHZ?=
 =?us-ascii?Q?9iJT5Xi3/vr6TqLJ35uG40hD3kZirOE8zbEyPwOatxzRrg6BZyOUf63zsrca?=
 =?us-ascii?Q?Pyz8iV8ltMLEnbzFzNLJOLzt/BdnkVURGe5DBrq+WkGDX2MBLY9vq8YKpUoa?=
 =?us-ascii?Q?pg+BVIQLItD6HbnOq+ScJZi6VQGWM91rHjoQ8WpKtWH4KJRywm3S0WxcS8Q3?=
 =?us-ascii?Q?sd1RvATesmWaxZGUTuW3pLsBMaKecn+LRDXWSUq5Pl/LL0Lg2gmWlrokwbD3?=
 =?us-ascii?Q?EH9OwfC2UQqhGhA1gbWM00oeB9tuVxHhj4fGx5hSpZGedFwQUBWuZvSfeep6?=
 =?us-ascii?Q?xVsdyyLnjCkRuMEtxT6WDGcuawy0Fw8O5PXwL2pxeAsrsAeuQlF4ukaGXV0E?=
 =?us-ascii?Q?0FyaPhJ4wQLDtt1TV/J7kthy+rmE+1Lb2wZSTKqH9veCX75JYJXuacIX93D1?=
 =?us-ascii?Q?54XDVMfE9VT/tQ+ygt3fXvhZyWLmAAeYOZjpFCgNsUxxgvkxbkVzIexTGbHr?=
 =?us-ascii?Q?dl8bvRDpEl6Y+SDMh3OS/fGJbMRj6V/CUfkGsNvFZtqcpsApHLLvRGuNbqNh?=
 =?us-ascii?Q?u/3kS0cDuM+X9HeoJ5GbUoEGRlIJandderK1XmwN/svYC4qKmgzKsV5BvxQ2?=
 =?us-ascii?Q?yVJZ+Y1GRe2IBfNMeHeO8e6b+1ZYui/pJIDSusULrID88XUdkRrvOlkqcTz7?=
 =?us-ascii?Q?TRGvlpiwTgAITUSgBIZFQiULn0dNcESOuaou2ibborkuHSMPXz6O9vMFUZ49?=
 =?us-ascii?Q?qEQsEOpRQEVlGodisazIgegHoQID55/HKUbewn+X/iqgiTRiNgCdikqTRa65?=
 =?us-ascii?Q?ahdwdo2neBPoqrFtk365jwZSgjrvGdONdrx+5rk4VgbfwmjdzOm76uhgAnL2?=
 =?us-ascii?Q?/DNGkUPB8YlAKVZDmFbJ3zual65PeDGvnO7kGyoit+trfghGyLp39EmvKaAj?=
 =?us-ascii?Q?f/SzlywIbphyv+rGqqZHhXULtfeZawImF9YsrrGbJgxnKkZpRt0LS4b9BWNW?=
 =?us-ascii?Q?hzNe4zuVmQHOrYJSUvlYhhfEkEVYlu2VTZwEpqOkCHn2vTscQcjRr2fUSuWE?=
 =?us-ascii?Q?8N/u+RG9Kuqop3P11ujFnN/1ZnnxvYed5OgtlEEaDB/yanxHrAUub0+4OxWL?=
 =?us-ascii?Q?DZZNxX330HRNJJIMUPWgomHsVM/8rMuBy4ASdo4Ti9KQoxH75EV70ZgjgkYS?=
 =?us-ascii?Q?d9sZudimm22Vy5+/dFJeiIU5Mp39QBghM3N73LNTy9xw9j1IrYWIddZzSh9k?=
 =?us-ascii?Q?10xFFa5rua+QoWZVXcvsyt0hm4Rt5OQ6?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Xowa934uG1zDoln2SOkeGlBM7oMCIt2FoOkLj8rroNV1XumisL2faFRRb3A5?=
 =?us-ascii?Q?kECjMekBnMKWHd6vzKPxY+XJCJF+S4t3kbp7DX14UEjIjLJZVMO9/MYb3w+g?=
 =?us-ascii?Q?1zIU+I1USfPZZHmKERK13TGpTkKX+dR/5y33hgufttShTMwdBLYgO2nISmg4?=
 =?us-ascii?Q?9nZI6V2qgv3qDV2o7ZgdApuHdxlLDLv+zI2WFyNkS4Y+kwBszI3i1wni5gCl?=
 =?us-ascii?Q?nMWF+I6LJu6DOhZsPaYKRCUzeGtHpytDUYzvBqafNnQWgE2XsshpFUn060ec?=
 =?us-ascii?Q?UpGX+awDm32/+H1pR5jGdxf5xzn6SyjXApziK/b9RdBRrIGr447crR9PV/CZ?=
 =?us-ascii?Q?n296C7izZgZjXAv9/NsebbkM/sDxS/uPF8PiwgEJh94RzV7caG7Mo11TqynH?=
 =?us-ascii?Q?uOnhAD2LVpK7dPxFTL9m7r7XfQ47VXBri3J0h4+mdW+6kceKbLm385mXXCfw?=
 =?us-ascii?Q?0/V7FQugD05xHDwyJ23fjBmRwzYBPZ7iNKsMDIB/iXSDxwFj8Ny3oNzGyDsJ?=
 =?us-ascii?Q?3mVNZ/2KABPgmXf4g/Y+SecFm1uVPK0rZzuiPlZZJ0hd4pnC16QGP7aG3sbB?=
 =?us-ascii?Q?P0Jte5LiKixQwqJQ+VR0IejjLuoB6kcNloGRxtr3gFGy4I2pkXdA7ZK3qgqs?=
 =?us-ascii?Q?7h7XhJpw5Q4QwIAFD+tCKPdBuPUt7+0oE/oKGRAXKZsbjc8XMC/3fMDmUKbd?=
 =?us-ascii?Q?pH9dGHAePDxM4OI5Ek6C2DHdwyOsizPfUxSBX+DVbn04PxmjZklFraq7jh1k?=
 =?us-ascii?Q?Sj2WXV/xAQGkMuJDCwHLg6Xb8fvKyUF7eH5XMmMLtB2oipZv0pg7v+SBUrkx?=
 =?us-ascii?Q?rcWZic959LS8NB8sqmDyjKRMEluwwIqRPfLCHA6PTwtcV7AZ+Wts0mQLDT4n?=
 =?us-ascii?Q?WKOiFliY4F1LFa3kHgmnOhBxq+nJe8oEBn/j4Z8N6CJBUwk/1EDuNdJh/cJ7?=
 =?us-ascii?Q?RCmb2UgkNR5XEyVrAp12dkszRNJ4Tcm5YXh2pfEZdKIud7owET9LzcC632kT?=
 =?us-ascii?Q?2/skQsVeK+04sSLZWiB7GuZ/diigq3sxbg4eom1Wv6ORs6MbXCXxiyfds1tF?=
 =?us-ascii?Q?uDWyjPq/cUIFpx0e8lX5FcIVTfTfJrtc/mWo2kxoulfnTppvKyyxGVfxNRUK?=
 =?us-ascii?Q?1hq+WccQhjIRMOhKzwSbfKIHlACWfex7hu6L9KcYfyTsCd4z4RuP/udq/RTL?=
 =?us-ascii?Q?LtlV3F/bnFImzYLtIwvJTp7O0e0TCcIhJkiJFfax5qjDS0fNc5/aG8tFAQg0?=
 =?us-ascii?Q?U5Ytf85HYOwMtt+EfUnYEWuCkgKohdyhZZPDhGpNbZEQiwmxFIIISAZ8bj3k?=
 =?us-ascii?Q?TW+y31T6PtrOqaC2Z77UrFzCsvd/P1l8o7bCZtAsqJMsyH09wRHbCk5tVnMO?=
 =?us-ascii?Q?SuJuHS4b1su3NlFGyZRCWJuguVx1dvro7XYOv20jOpUsaitfE1waA8Mb06nI?=
 =?us-ascii?Q?W9Vc/3PGPJswJHoYTjvP9KDjoA17Pbs8TUumDB9+WuZ+pOAbsEGlNUtX1bxz?=
 =?us-ascii?Q?BRqnD8aSxzVotTKiP0jtDNZlEf+Pg+qU6HcUQvJt8Ke/Vv3BbV0FrZWtvogZ?=
 =?us-ascii?Q?HdDkiJYFNUvyfEHnVEWEFCJWCY1osNhcSRoRxn1WfOW9/yRLUj4A47qogo1e?=
 =?us-ascii?Q?NQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	hhXH/krEc1Gl8zoSThNYBKpNoCY+K+ej3YeakGAgWTkfdiwk9112CnP1K2LbAo3UuuSGKEXqis/QLWCnBscK043moNnvCUq7CsYO4fDixEaJzIxa7edIackMoiW8K1LfjxVkVmzg5hRlWxu2t9FwX3R95kWsOe6uwZ9pj4S3HF/yCbCqqkdDRiYTfgRJNBazpdUJ/po2UFuhuuajbt6TKX6kq3XimFMTp5pwPgtH77qa0TEksOj8XNFPLODFhbtB3K0PRaD8vgVereh27CUL1DY5LyELxSeanmS8XhoiNPmzPZ2AUM09lhDU1M+YmIEwsdOvOsxkJizdwj+ts7CFlZZ63OQISAGaD4Lxeu4F5KRtlXkblIqPlNzP24L8NZSZHXSa9ulDxVm4c8aSi7x6JSZQWUjTL1vUMNNvH+aHqKVaUre6fY0hjX5Wsu9KziJjnv/CJLx7tkxqLRkwN5tHNblxXR+ienG40C4vHTM0spotX4Vqrk/iVuVxKlqKSpjLi1Qy2i4Uu6XgDwFqLNS8v0iCn2aCj9i3LX0RZqsNGdyioHqm+T130n1X+c2nezJ/QwVDxEWJGHEyqeRiGj79PUrnORIjnBgAUPGxZevSDZw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b787e663-18f7-45e0-589b-08de27399e9d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2025 07:02:36.1478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: l6YpcmMhrz3RLU2BRRKYZUEvksprf+izV+mQAap86+zgZSgsDvb82rbCWNvqNxizbcd7FTe/+RHAGkLVZLYOWgCC6fViumPp5NuPphxw6Jc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS4PPF415C917DC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-19_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=949 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511190053
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMiBTYWx0ZWRfX2yd/2BDt6QWp
 EADfac6PwUvsTmR5foScfOGyZ7tR90sTJvFEoImedH5GSBSdDpb7ZRX7/za4Zm4jxYuQZHXXcA2
 Q4W8jhQnqucCg0AyYuhWIOIsIFCgEAqdFwaUSVmzttb8ER2l0IZb7ai6U8jk/SqjNMotVY2XcQn
 +zM2/GDm/iNu5cIUmXczXfNsvWXz42NcuJCnDoC/jFYI3GE0CaStJmUIV2AaeZg9nN8j01ioRfl
 6XyfRt4VTdvA+25bj+dRBP7no8sKp8vDo3PjesRk+qaEd2qy4qovTsMPC4d6x/QtQiybLfUGQMU
 05peGxYGy3ZozN3qy4EK/w6yHRKtfpSeX0Sv61dHmcFok9LsPRMdacDUxA4ryz+2aqJMZrklxwX
 XWLVpv3kkZ7KgQ0JfrpKUCXQ9JAerQ==
X-Proofpoint-GUID: E5nM_VJySkKJVmYijJe97cNhq_yfR4VD
X-Proofpoint-ORIG-GUID: E5nM_VJySkKJVmYijJe97cNhq_yfR4VD
X-Authority-Analysis: v=2.4 cv=Rdydyltv c=1 sm=1 tr=0 ts=691d6b8f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=6UeiqGixMTsA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=yPCof4ZbAAAA:8 a=1XWaLZrsAAAA:8 a=uIuiFJZiaEcmlN1lFwMA:9
 a=CjuIK1q_8ugA:10 a=1CNFftbPRP8L7MoqJWF3:22
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D6378180002
X-Stat-Signature: wu4c8peejz9wem9ck1eupqx15dgox5x8
X-Rspam-User: 
X-HE-Tag: 1763535773-243932
X-HE-Meta: U2FsdGVkX18fYuv/5J60+zeMJ7F1bZwkRnyFAhPvWdgeEe2PSwabilwrz0yz39fGJkFCK3aqGnyWNzf2qJrJeSZl2o9fR39Hzrb/RMeYY2zfvhMuLEJBJOge39YJuBy2THfXfwRRwMc3Z69qNBV02rGUtW6nFy7YQDJQTLIvFfDJof7V5ptaDzv7s7zAQafX9tsAblzTLnIvFn57+x5gzZSxos8mM+Eh84cEY+Ow5Hh83aBeOzPqODuzo7NjTf79vgUHvVCOotRM2I6dHnCahTJkRsxuSFkfGHrkgOOkl0giT4dF6VCB9ofuvD3h45JmWeNuu+ohgAK0H39/KTOkQeuES48r4i6sPeoeZiwcw+QmBhz/ijqrIfZCRJ64cUP9qFeeJAa3SzmNKjIozVTJVe/jbueZsZGIyu/v21aklsvK+Mmh9SCTGrViE7jO5ck2jCXhTbcBEARAcWtUiCHh6uhP/vaUocYlPYeG7mptsf56OxFse8+Ov0uWoN1muM/gVfSm83GJYXxpphUFLJhNKKPF5SNfGGeTl9T6BB5okk0HzH5eCFANjKqkVSsiS7RjDwnbvWZM80j8bFxJngL8Uu/liSh+DVWCFg9zZo/ofj4HtbzhnpK8Fr2+Ijg9Q48W88LR0aM6krnpxuDUNH5lRL/bFykB91JqLE8BPCy8tu1VonH82zdkj4LJZ7irsei5tRxO+dgohPakNamWV/VEkmd71BK2iCgIvcz60WRSc+D4LtmestjfRamSPAFJj5iRsUgYGzJ8oOMJeRsfL49YDJ0qja1g5p0jVjggP99Ut/P0RIlwNPWZxWfqdV3YAnR6OMGUv9KQAX/Ay94g+dQWLyxg7xEWAtJK/w62wJGl0WsyvSp77vuT9wMJrPzM5n72FuM8SQgLErRd5TYtQOR1od4AkGUo/ULgum6aKyUG12V6DpszAnAkjnZdsND4zV5YCaj6iZHQYaUiS0a6nAV
 Ta9xa0hj
 MSjXb7/LAdGcmh1YxfSh4yhSGuaz2M2gPGihkft11usYBu+k/T3pzx7zyilrCnsdDeyw7tCn2lGooLr5/unSiIs0lWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 04:26:35AM +0000, Matthew Wilcox (Oracle) wrote:
> Move the commentary on how __vma_enter_locked() behaves from the
> body of __vma_start_write() to the head of __vma_enter_locked() and
> merge it with the existing documentation.  Also add a call to
> mmap_assert_write_locked().
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> ---
>  mm/mmap_lock.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index f2532af6208c..e6e5570d1ec7 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -46,9 +46,9 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
>  /*
> - * Return value: 0 if vma detached,
> - * 1 if vma attached with no readers,
> - * -EINTR if signal received,
> + * __vma_enter_locked() returns 0 immediately if the vma is not
> + * attached, otherwise it waits for any current readers to finish and
> + * returns 1.  Returns -EINTR if a signal is received while waiting.
>   */
>  static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  		bool detaching, int state)
> @@ -56,6 +56,8 @@ static inline int __vma_enter_locked(struct vm_area_struct *vma,
>  	int err;
>  	unsigned int tgt_refcnt = VMA_LOCK_OFFSET;
>
> +	mmap_assert_write_locked(vma->vm_mm);

This is nice, actually was thinking the other day we need more asserts like this
in these lock functions.

> +
>  	/* Additional refcnt if the vma is attached. */
>  	if (!detaching)
>  		tgt_refcnt++;
> @@ -91,11 +93,6 @@ int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_seq,
>  {
>  	int locked;
>
> -	/*
> -	 * __vma_enter_locked() returns false immediately if the vma is not
> -	 * attached, otherwise it waits until refcnt is indicating that vma
> -	 * is attached with no readers.
> -	 */
>  	locked = __vma_enter_locked(vma, false, state);
>  	if (locked < 0)
>  		return locked;
> --
> 2.47.2
>
>

