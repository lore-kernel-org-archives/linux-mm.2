Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AB0CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:58:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102978E0043; Mon, 13 Oct 2025 08:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B3648E000F; Mon, 13 Oct 2025 08:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96608E0043; Mon, 13 Oct 2025 08:58:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB4918E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:58:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74CF413AA19
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:58:12 +0000 (UTC)
X-FDA: 83993094024.15.AA5F3A2
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf03.hostedemail.com (Postfix) with ESMTP id 04DB72000D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:58:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gvl5bc60;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dNR47Xrp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbBEhDYg49TudfbLPuFLHV79wN1m+vzIKR15qzFlgR0=;
	b=Tn2a9/QwaLfjzG14b4Cg2Pj1McjhwTDEDvhKsYGhG10UVcKsNCU73JTjt+n8IOdEu/1kko
	Y0WKLF/+GU0PN1skygI5C600hGYtxp3B3GEoAT7JCutljbEkGW7ZyAeYQ5i6gbU+RzJbmf
	W498nya7u/2TaJkPS7NU9Qo905YOF00=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1760360289; a=rsa-sha256;
	cv=pass;
	b=HwCfeOumbex6VIvjyiC5KYyedP6CYBF+BCFohXDcn1pDGgDld4d/katR5t1rlixYX8LQqZ
	dIgTeu1rVlemK16mhAMLY0pezRnS6xqTubhiPCH0gkAW9ijzrRZlUULXdwQ8XzURn0DSeE
	9id9gmZJ3nalrEvz82hQvCaitlFDGj0=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=Gvl5bc60;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=dNR47Xrp;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf03.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59D7uLEu026963;
	Mon, 13 Oct 2025 12:58:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=jbBEhDYg49TudfbLPu
	FLHV79wN1m+vzIKR15qzFlgR0=; b=Gvl5bc60XWhvDY7AIE7G58VzeAtXza7Il2
	Mdu84/nioSHldbxtyPh6MEYkf+YfsbSZIp2gSvOCnwCvA2IxUESwhy15MO5iiTM+
	V83rKee8oC0AVC67WT2Kfn2/xSvw0lZLyAz6yyUNh4IzAWRwsXdwOx+7LNYpr7ud
	VJ7XpyedkntyUDq1yJDEzzNrOHTk9goyBiqSDgaPBKoXcCMBXGjaMMybFE/JO+XJ
	0ufj60uS9vjNqt8E/qbgA3R6gQoxA9OdW+PVk6cnGAQIU9FiSKWzlHGvWNXe6DQG
	OpwNrzKaBeiC15NnaaLBqwp0/qlE0ZFbq57GdOf6wb6iOJjkjb2Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49qe59a7v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 12:58:03 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59DCgbwD038205;
	Mon, 13 Oct 2025 12:58:02 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010047.outbound.protection.outlook.com [52.101.61.47])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49qdpdhtgw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Oct 2025 12:58:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=VpJ/V1kASRho+zvtAF35erX5pIs60sun6+UoWg6RuH4GlEw/0ubSpKbtUPlovmBiIPyg5aYPcajwPe+O+p3iLiOLgYyZJlneBDBcbc5xqRMJ73QH17hNCZ/PPlm5vEw/s89AGRvEc7KTd5CeTzY0DC/YAPJDZ48YQnP/SA31l46j9alexYar6h4BPhjgt7yJSgOFP7SkKLfE+dpNT9kn0OXNjmxlWjnhmeni1NpxdxG60t2IF2Wke9Zqg23FUDipPTItKIQkVsSNNq2HDKjhEs7x1BhrueWSl4D3j6W0yD0MMceDRjkb4t4abI5drnHKoCHTdZG/ssPHynpJc75NCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jbBEhDYg49TudfbLPuFLHV79wN1m+vzIKR15qzFlgR0=;
 b=ATn7DSqZZVyEgvOmYpqTJEM6hASgLORQ/29EKmwmtCBDEl3NUMRZHzjnJRIGntgwmheIycoC63C/7OrdaR3k6Oq5w2LdjAt1PpyGPozbI0KNvnQgCGxSpWYqs+Q5J4H6tEEfPzhDM9R2heqTipRoTa11ClU/VC/T6CNPc1P0l95r2O7pRwdXObRWij57zDd0Eibum125cne7ACGff3MhmL+/352NBCxSXyOiTSJ3wfN7FfkdXQfIkS6Ra5QHE0TncR7BsV1e9ZRx/XTQVkyfkN8dq+HE3ubXgKaRrnUW6myT0ehTUJnnB0kqMfhkYcnB8r3UaoBphsRmHz/Gz952Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbBEhDYg49TudfbLPuFLHV79wN1m+vzIKR15qzFlgR0=;
 b=dNR47XrppbzbyZAW2ma1tZ2yjp/5Gn0vixtFAJiuk8Hd7C0SR5f3F8Ubip8MOO4VVUiXbj632LvIUknG4Su2tcBeNlFDI0vy7Yk9YON9pwBqGbFI1gJfNy67x4aN332OetlGfxvw7+vtBr/Xta5kmCWVXUoTJ3DwNk769I7PhGg=
Received: from BL4PR10MB8229.namprd10.prod.outlook.com (2603:10b6:208:4e6::14)
 by BY5PR10MB4209.namprd10.prod.outlook.com (2603:10b6:a03:207::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9203.13; Mon, 13 Oct
 2025 12:57:59 +0000
Received: from BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582]) by BL4PR10MB8229.namprd10.prod.outlook.com
 ([fe80::552b:16d2:af:c582%6]) with mapi id 15.20.9203.009; Mon, 13 Oct 2025
 12:57:59 +0000
Date: Mon, 13 Oct 2025 13:57:57 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
        Ye Liu <liuye@kylinos.cn>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC RFC PATCH] mm: convert VM flags from macros to enum
Message-ID: <fa2d7db5-688c-4d04-abcd-a60f79a6bb7a@lucifer.local>
References: <20251011093054.886460-1-ye.liu@linux.dev>
 <809f552d-3282-4746-ba49-066d2bd8d44f@lucifer.local>
 <7ca0960f-9d1a-4ba4-b074-a6502578b82e@redhat.com>
 <d619784b-b967-4795-aad9-6e79d4191b83@lucifer.local>
 <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfc18351-bb77-4099-bcdd-eb2bd4f1bea5@redhat.com>
X-ClientProxiedBy: LO4P123CA0156.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:188::17) To BL4PR10MB8229.namprd10.prod.outlook.com
 (2603:10b6:208:4e6::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL4PR10MB8229:EE_|BY5PR10MB4209:EE_
X-MS-Office365-Filtering-Correlation-Id: c421b750-d5d8-44d4-d411-08de0a5822fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?c2FUOy3Lc1In17ssFsYNDCpZ7pvbIHpLXyNuie/qBBx3TOSobL78wPRiako0?=
 =?us-ascii?Q?GGGBsDw6NTBhyxHFvX7fYl68OIZxTyGzpxoRPyW8BGwkCgFGDEhu22f5Bi/N?=
 =?us-ascii?Q?uaUHAkBMqPQa+HqmrxI875FgjKAtRtLGVlM3ebB8AYmYPLNJoyx/BVKwv9kD?=
 =?us-ascii?Q?FWPuf1W8jFZBuKZUmxnjiG+fT7/EuKFWqLEMkK0auWeCpbOCmR/CBea43Inw?=
 =?us-ascii?Q?Dnwd8Kpojn1IRvgBLOoOeqC+sy4bZotmbmYmTUylM2CW1suqwnjCGkVImkP9?=
 =?us-ascii?Q?MTVpAukcsLC2ZtaNMI3gBdAc2gOf/VB78mq6iW+U27huWK9Fs6xHychzCeY9?=
 =?us-ascii?Q?f9cxxsE8WJinTXq8LaRrdh+qrvZyfZc7kFbyTPZUBlw4iXzpF2Wtbf6YXaHh?=
 =?us-ascii?Q?Z29zuSUNDCDGBVQytPX+sSk90r/l2Kwhu3mJiDH6U5gwiHGJ8DOcVuFyGlBq?=
 =?us-ascii?Q?DjxulXvW9ffh3eOozGgbqBY0/C+QyA+zyQmcchhq+IBYT+iis2caUawqdiH5?=
 =?us-ascii?Q?PMXoJg/YWwhfm6Y8epza6D69UvWjN4TZS5FR5Ampi6YyCYX4iGqG33WaDwlS?=
 =?us-ascii?Q?hsvGQxxT3yPTRNwgvFQ1eAOTz59mbiirGAmeWrSgfXNvDMPKFi4qCNLWSdV9?=
 =?us-ascii?Q?x9/9xVAgCG3/GNrKi0dtPhsNUsjUuUdnpCHYkJicdAuL6Yv5OlmK+TjIXalm?=
 =?us-ascii?Q?eaf61CpHoBH+aR97kBK9EQRk4U0HVQEl6VJpdSGSKVMQ6EQvGMTFEW/w/4mF?=
 =?us-ascii?Q?QnW5IJ3clh8+DHAckaWXArpQpo5X0Qv3XcWZmOxVRhtW6Lot/K36fijO4bL8?=
 =?us-ascii?Q?R2ectiIOdI/TqJAUmD0au57vBJ7JsP4s0WBTqI7X2MRxvf/zoubMU+yQuhpo?=
 =?us-ascii?Q?eRkmjyh6kB07IgBEYMZaV5YiucQlGb6s7+3clc+yi7HIMgSbn20kg0TKRGjP?=
 =?us-ascii?Q?Yi9TQ+qKkHC6W689LutBERfsCTo8OEgkjatdHzMflhHnAHWNUM+ClT8QpYjv?=
 =?us-ascii?Q?6sGDG8yOHOYd255NO0zAuVPu+pBKjdY04oUWE/pTc2weE+/sah+DtfboZ6O1?=
 =?us-ascii?Q?IiEvIvSnLEfrpJuf3j6UhHbMARbGaOqjEmfcO6olJs4iOjZ4GTMxF3P3ENqq?=
 =?us-ascii?Q?laXQa5jXewX2Yh3iV+OFjyrXp5h5qnwXlND9J/Os5Xn8LDZtxV2eCGxJ+lY8?=
 =?us-ascii?Q?xDhDM9zAg320YB14Bln0oPd6CVRkLx4+heMJpfGIy85E3zYMcrngjQmFcPHm?=
 =?us-ascii?Q?xn7GIDID6GXnlkxWDWQ0XZIcR2CBUnmgv1hzO1VhLd9mxC+x++u2pcs4Z7yy?=
 =?us-ascii?Q?StnK4gVJ9mkPjSLuWQgzaXk1hAVRjoUcE0YLS3xGtkY3s9XFDlHgqsDLifcN?=
 =?us-ascii?Q?hsfmipxj5FFX8DeKir+p55KD13I2Xu9NjMfLVkVL3Jq51MuvW4m8c8Oodq3I?=
 =?us-ascii?Q?Sc0XI3OmXNucwfHY8NGNQ7g2pkc5WaNu?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL4PR10MB8229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?igi8pmLqPqHU40uXN1LjM+rfibsSw4H8AP6d/EOUK7/BFvoWFAF22YKNGp2Z?=
 =?us-ascii?Q?9o8oSa+Gfzv6Sff2jWBNvdEp4Fc5LZOezWIkMQlbKLzSeYLQNCt0ioh2HKTe?=
 =?us-ascii?Q?wpxG/8SKpzaRMj4i55OV0TG2IxLtXgdLSHkB5Z3Wlc+dotCfp7OTYsVJHZJa?=
 =?us-ascii?Q?oqWkMhHK2zHIopjDFysg+o1Dkve1CS1/ZsgEaZOLkDzoDAgr5QlUReh4Nynb?=
 =?us-ascii?Q?baPDrcKP5NMXRNzHvuDlq4FDw4eR8XwS+RIcb44M9N089lp5uR6yin/qbmi7?=
 =?us-ascii?Q?x0el4WIQYklJQgO+CBJc8VQb3T+U7o+oHpKl7nC5LZMbU4sZbDOKGG6EkAGa?=
 =?us-ascii?Q?eyRErhttJSpDCB/kvAbJE9COFvkzRNQUcByLvGfzsRCHfy9ENurj2A1RgWjR?=
 =?us-ascii?Q?ddkZG77ZXuWlXnsnqUO1f7gANkzH5deq4W3YK14gERNAj+frethWCiNWA/PV?=
 =?us-ascii?Q?ZK0P4bPi1ZKOuQRbdPNZHzmlptL/ioenTLNLRPx8FaI66rUOcgW3cmbNm+xA?=
 =?us-ascii?Q?5cJPqEbZizf4vjpF8WUcIc5vwu+lB88XaLRU3KR6plToV+P8SVSQ9yTsVydq?=
 =?us-ascii?Q?HXyO7RpW07i5Fvq/60qG2eBa6ZPOI1uUvCOaEZCnibcayweeK5tRADzqTPm8?=
 =?us-ascii?Q?qA+mSv96hUxUgYheCgfIHR/ENwsYXdyCAQ0dqy4UjBKzJddW6Xt9vPVkOqDc?=
 =?us-ascii?Q?d/1BhqVnkk79usu8d1FAhgwX2jZA/GBYb6Ufuh1JwbNp1VyxzBX12rvG4jHd?=
 =?us-ascii?Q?7RzFKgmFQbRVjfT4Mq5FFoLQzNeMRJPe18oE2clya8b8Cunck+lBrHEvvPSj?=
 =?us-ascii?Q?l4VNPHsryIYJ1TbXYtxPVI65bXig8ZwiYMysAVl/6ym/G7rSa0tBiG+QEBJu?=
 =?us-ascii?Q?OcK66iFICx65SaPNfzb60aJA6yfTJYGmUFMnSS0tjmDSYP1yI38/gCuhuf2I?=
 =?us-ascii?Q?XHVr5yUyYBaK1sxFbe2x5tjQIu2V+p1dNktvl447lA8TlsbmHpDlw+GJQMhZ?=
 =?us-ascii?Q?8Jx+rf08aGWPGo11V2NUTZ1L0a+rxmLoOyCmNmZgFS+MgxF6XiFgaNvO7FNk?=
 =?us-ascii?Q?Nj8cRuX7jqUdth598DKDwUUCzRVWJLhgICNAcALRG2I/ay4YKdDqJsXzQuzv?=
 =?us-ascii?Q?2ibOs+a3oRsOjM3hSkgbKVksgwhthg1iH1p/18wFpTnLDEtuJ1Uo0/ztEcUL?=
 =?us-ascii?Q?iW4ibN3/InKj5xkP60bf1tSn8/VDVRKaA2OoKYOMLxV6csmReoxjk1HF8ied?=
 =?us-ascii?Q?AsukYVxor6A5xI604m6t2zxKt7RXXLmeq/EHb063UbS3jwiqnUckMaUUgdER?=
 =?us-ascii?Q?ifBYuU7Z9b6mGmKzPfFsYgDifl0GmvZbkL8eOeguoKIwSaRsrGwlbU+aIux9?=
 =?us-ascii?Q?pq/xAg9LeH8FTE8dyCDO2ygFXsSO2UzzdpjMIXH7EdM7S6OPhiX0aLrL353c?=
 =?us-ascii?Q?alliRKpJp3VN/o6Da6KPsnPF/mRdzHD7uTHkiFKwhPcPPzze1Ct+4kl2RWtn?=
 =?us-ascii?Q?EB4TJaEdXvl8c9wkN9LsiGMTxPCbN/MeDvzpne7JIq3nSLLjuKRjF4EMYfRe?=
 =?us-ascii?Q?rCHu+gMg+twOLxDjlfsFu/rnktUkj3FxersCxUbzGe2J54YcY1H8636jQbEs?=
 =?us-ascii?Q?BA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ppd+QAh8PUif9CSUyylBTZ3wNIhxtGeT4uT6aAbWDvU3ENp81a/aPbiIqhckWA2566TYGXPYCGsOFGUXx1e4DcI4bTcKdift3V8uVSSZSHoNYOriGWF7hJt5hsQf404dPT5YgL4FcrRUibAvwsClthd2yrEt7P3Tlse2enX9StsBOgngnZR7mpbAgcf6evXRFgtkAi2NGQn2BwEBaWjVdHpxeN2pXGGNo7afpYoDshrymeTRq2tujffQD/Wcx9DvYqEV0otJWvnlLTxYSFlUsTZlH1/xYrBfK0IVYgzpSN1wus7iLVCxx/JfbBERte1a8fOM9/VGReUNrsa3JyB+K0l6Nl3AO9UKpEHiA2rCnCoq0yIFqxdixeupENSZwGT/gu0XshHhCuD4Kre7WP2qYn3GNSdjo6h+YwfPDGTKlBLsdvQuDxpPvFNzpoFYY34s2/bne6xnhaxlGYOvoZ7QYnpBcv0zHTzwuuXSxyf0k4llByuCkgZsmj5o/wpqZm215nwasjeFzvqdEDp1N/AM2lYStYaJylygOCbmPeaa4YEB7DCIr2jrsKHHwQTDgOwQLxN0ubRhNrj4cQ4/6oQyrO3VTw6fr486UbUEz+7M+TM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c421b750-d5d8-44d4-d411-08de0a5822fe
X-MS-Exchange-CrossTenant-AuthSource: BL4PR10MB8229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2025 12:57:59.4578
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mL81qEhUuXVS5oxFGSZUxj354gzjVjh/Gi+O6Mr1gR9GUD6qw7qsLF7nSdW7vP6FLb2wWlQRvj9ybSfqQhvUEDXQcSLAnQxPVyYWrdrYlZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4209
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-13_04,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 spamscore=0 suspectscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510130057
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxMCBTYWx0ZWRfX5IqsCuEXzhA8
 4Vdm+oKXDuUJqNOZ0+DAXQPYk0dx2mFNTKwdfYoYqXGjwQo+A0UpSjy7DOBUlPN4n2iY+EKjDHK
 DYAM1aEHbM1bgus76dYFHJunTXEeH5HBbOiRM4XveeNu047jiUtQz3luICqelM1NIlXFNoEkUUe
 tfeSIGaFDaowKTrRXFePq9dROcMu+IPRRloGrP/1pQlK/A+Hlfh2YhRxJobr57iCvPX42J2vBDK
 Sk8DbMwRl+483xqS+QsVJ5TO8swycCwn540mXCx5OLyTg3N/ThhUOhqIHJC4iHgOiUjbZgaj3nT
 iTBcqjAzQXsg4G+expXE+ULZQQdbb2ut9i3dyDQhZYbBigL3aS9k8Zq83J48bkwm4G3DoD7d19F
 h/HN8rhN6J1GwSM+/Uz/7w34oYzxOleiADaU3DF3a5o7YP61zpU=
X-Authority-Analysis: v=2.4 cv=V7JwEOni c=1 sm=1 tr=0 ts=68ecf75b b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=sQkpMVnB42dyiyY2TvYA:9
 a=CjuIK1q_8ugA:10 cc=ntf awl=host:12091
X-Proofpoint-ORIG-GUID: PLpPHUYyawRMwfLFwzoWiI_AQPhR-OKO
X-Proofpoint-GUID: PLpPHUYyawRMwfLFwzoWiI_AQPhR-OKO
X-Rspamd-Server: rspam05
X-Stat-Signature: 8bt387kb7co85f7dncx5oojsjrwk847d
X-Rspam-User: 
X-Rspamd-Queue-Id: 04DB72000D
X-HE-Tag: 1760360288-159019
X-HE-Meta: U2FsdGVkX18hlXkHOBYKf+Dh35m1MqldjBlluwsSSldzaUjCqflVCLRZyeX158P05KZnnrbQvZE/7aAEQtkRLn9Vli1ZZQrDAgJE7zZ2qiaIoBoY0JPqHgXYU3qplX3WgdDqYHl4wnYF9nOnkJnqMcP9xXveqv4+5IP041JcI4x8b0A7Z/W3cLW1ttW7wAXSBNEBVHU17I9i0TSBj7YBwjsbyjNaknbGLpxV1Dr0wzHvIU33K5qlycbjNiA/ozO3hqlykB2YonLYbdokJNS97LyYZo3jNUNX+7d3ukmmhDtgCQ3s6AlIalkL8a3P/Eulny+3fsakOdk2In/2OCT1lLBAmbt/PHunQfagwgDR6fJJmELknVrMNvKJ+/GrIk3ITaCvtKxXj2fCgTfXug+SEO0z75WEAdDHf/WqIzdEHuvPcTb1kGAToUjH5qTfi6gCynzVR/5UOEcUleEWYm9lFPsJ/UQSV65FrIx89x8tQsGpgejCPgNQhWvek4x3X91gVvr/tCnVkr/VtZ8y0DaVbhSCTPJsp7CgK1rgoNXp2noei4X2Yci8zba4DPmeUm0NWAdq8gw59nVIbs6N0yO3HK++UsphNrWow4v34w9ecyDIc/4Idbdlh4xAsGbe/jQkAYQf/bgADdYB/Q71aTX5COBMc7JPfq819YZKOFLYdR53tDNJGhqyV+yQqPdVaHv7/DMa4dZsqhDAoxE+MQbI7Ad4doMgK5r4XftsXcFo0bABEaB3igb06iTbSOjFQEQDc2W2ys9OVJqDahLfx2Pjy5iG+pqdWpnZ6r7guoCBJ6gYYQXiAQQtLaCTger1592jBH8Q4HyTjbFhk7gbrKA9Su2zH5CWeSGpl0tB2L61CphGByUM313ngAroZM/i8HizJ6yOKfykk9botiB3SXiBdAHWScSeFo7aOv0jfmnMv8NOIsxxIAmYKu5V15JQxLxmSuWxicVmXtDC4Hg/qL+
 l7YwsW46
 v1Y9jroqSTpUoDsvYY5q6UEX3/75NfhjPjfOz/5qV5w9inSB1HCPXQMiI9iQwyTcTUMAviI9msFyQUoeHpJ6pMznxFVznJocgUtDsQwImt6gZ3yLvuCJkmdgsqe1bJc180szpsaWJ4glBTdQV60v0qUAu8fDAQ2xwyE6H2lmfHhJirFKFH1bKZg/00C8j7llLeo+ERKhNbk0qxjs7BOYpOONMIhYOmOHyfioFqZMb75mbMasu0UF+aOzJ3HPhCmNm0H4k70pnT4/Q2eBxapig1dZVBZ2/hj52Po9NpvdX8AcXtNwhT+D2nFfqGDN9OjW5pfIqMgfCUtdwEUi2gb9vlgPgg/t2pk4/M0KVHuWIKsPtQ+Y+6HPk704CcvHX8VxcwUjJWqetsDWiVMv6QH+BUJmnw73oE3uMwqhmAm/5bsi6qjWwZBcEpeUdAD9KUUmFYBwbrpv80S1/Kpa3ccyw3sYnclhu33FtsTy2yU4xt9bWNc3UcdxLf1IvKcwCxDtL+b9GRjqBqtSbF+0lGO8ECmLJqw1OijSipRmK1CtNI6MaJU3yttII2jqGY15D6FS9bgFQhaZQg/sH4RKmOqwJJtpZW/+qmtKZhIsMxmjC7lveSaff+y5Gh6AFtw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 02:31:35PM +0200, David Hildenbrand wrote:
> On 13.10.25 13:33, Lorenzo Stoakes wrote:
> > On Mon, Oct 13, 2025 at 01:12:20PM +0200, David Hildenbrand wrote:
> > > On 13.10.25 13:04, Lorenzo Stoakes wrote:
> > > > On Sat, Oct 11, 2025 at 05:30:52PM +0800, Ye Liu wrote:
> > > > > From: Ye Liu <liuye@kylinos.cn>
> > > > >
> > > > > Hello MM maintainers and drgn community,
> > > > >
> > > > > This RFC proposes to convert VM_* flags from #define macros to enum
> > > > > vm_flags. The motivation comes from recent drgn development where we
> > > > > encountered difficulties in implementing VM flag parsing due to the
> > > > > current macro-based approach.
> > > >
> > > > This isn't going to work sorry, it's not valid to have flag values as an enum
> > >
> > > I don't follow, can you elaborate? IIRC, the compiler will use an integer
> > > type to back the enum that will fit all values.
> >
> > switch (flags) {
> > 	case VAL1:
> > 	case VAL2:
> > 	etc.
> > }
> >
> > Is broken (compiler will say you cover all cases when you don't...)
>
> I assume you mean theoretically, because there is no such code, right?

Right, it's a general point about why enum's are not such a great idea for this.

>
> >
> > An enum implies independent values that exhaustively describe all state, however
> > these flag values are not that - they're intended to be bit fields.
> >
>
> Observe how we use an enum for FOLL_* flags, vm_fault_reason, fault_flag and
> probably other things.

FOLL_* flags are an anonymous enum, enum fault_flag is not used as a type
anywhere, nor is vm_fault_reason. So those are both kinda weird as to why we
even name the type (they're in effect anonymous).

But also 'we do X in the kernel' doesn't mean doing X is right :)

>
> But more importantly,
>
> enum pageflags { ... :)

Your reply answers this :)

>
> --
> Cheers
>
> David / dhildenb
>

