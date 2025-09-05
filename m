Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A97DACA1010
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 15:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF658E0009; Fri,  5 Sep 2025 11:30:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7C18E0001; Fri,  5 Sep 2025 11:30:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0D68E0009; Fri,  5 Sep 2025 11:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D95E58E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 11:30:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 935B913A6FE
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:30:25 +0000 (UTC)
X-FDA: 83855583210.17.CA2453F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf13.hostedemail.com (Postfix) with ESMTP id F3F7A20016
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:30:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SfbOx53a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VzkYN1y7;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757086222; a=rsa-sha256;
	cv=pass;
	b=bnw6lVN4dY5HUHbnWoih/jGz6MnmcrRFB6qU2qGEunHCqX3M6qLIayJJQqO0g3savCbglA
	7B0ueg9C5XabjcrMq9PMNhVzkCn4/7ARtYHfzA6M5L3k5lS0FO3bbEIupPy8j1DzfFDlRl
	Tr1Ri3SEoo/HB2RQydo/BU4QfhUrW7I=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=SfbOx53a;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=VzkYN1y7;
	spf=pass (imf13.hostedemail.com: domain of lorenzo.stoakes@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=lorenzo.stoakes@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757086222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=98zaC7lE+hd2w+l0ylIYRi1l5+WKJFoSGx3Wkhw5QjU=;
	b=hNvl9Ozjki/JkxmNRmU3DmYoUOMfANvO4nGUdlVaHCYcHulbjviUVGPOrObxZAZ5CylQev
	7NwzJd3IoYfwAxI5yc3vlXh0+QiukyLcEmwC9tHJx1jvQYm7wZYqtKBdDyhKxEMf0VlUXJ
	wJ0vBHKqo5SH6JBeeP/MCT/9a/ccRMY=
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 585EMrv2005178;
	Fri, 5 Sep 2025 15:30:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=98zaC7lE+hd2w+l0yl
	IYRi1l5+WKJFoSGx3Wkhw5QjU=; b=SfbOx53aRRgEl7LxKLmorNE8UqjgjKRc1a
	Prj7vm/K1lVKIWEkNOwmJOD1ALtKXzYX/nNHW10tyEhfu8aGZQTZWjLES5qIvC/j
	nzobIEUQ54i/vKLoRmt+ZRWEXP+zM8LL/qf6fOBi/dixRY7/294dHmEUmIlbGNM0
	qJzjNvXM3ueY1q/AhyT95y5CueDBypUC7aSqnfrczx9vGGAEBB/d7jVfemPVqPFI
	k/u+kLB79YiKvgov0M07UeW1prAl6Dh4eCCGO0WWKLk5T6sWsHpWCPFGX5NMMbzj
	N6gSOXxOIfKPVLmE52LaRc8hjveWDCGBybwllswmtHRcz5R06qWQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4901ewg5b6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:30:15 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 585DrHEP034387;
	Fri, 5 Sep 2025 15:30:14 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48v01sacyv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Sep 2025 15:30:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=pb0W+nE9mKTweMysHQgkFDTOyElI1/Pz0ucXsYAo4mCZEj/XO07LLUPt2Si/ziqLeIIZMcYHKj4dolbxhtOgJ4aeX2K+v66wDAKcLTN+Vbe2WKU1KXOlMrVLzbeok77mGski16TkUAZTjVFEwxAp7+9HNBqQl0Y98BuT2K+wpNV2Bjqovl9urdYJfPKyIR861q9czB7vV38ELQEl3WIrmfDumLYgeiAJ3ny1iWL9AAKogUg8lhsLFkeHcx9Fhh8/nRePZ4mTotC7MqGz1zAmMMBdc9OTlfehZcyX5vlN0pDv56prtcWHwq+KDN4pH2fYM5uHeWqjQZhZMke+LWcQ2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98zaC7lE+hd2w+l0ylIYRi1l5+WKJFoSGx3Wkhw5QjU=;
 b=pRHqfyoyzBxOB9y/htCSP4yiOveV5w6fmJw6EGRNiaiUbh6s3FqCuKA1YtAZ1UthCodbQn8IMiDR01HqcnxynYZZz11lIR7kWrF6RFHj2TSLHgeVmEz6zvKKTEhMfofDQu00xBxYSbBC4fRWS/7UFIG2Va7TuwlXD8nFElzZPFQ4BVyouuNrojwFnrro+V0cdvMbFtCRD9QbGEZduRWzlkk/8mwYaRZs/Y3Go+tLnTQlDGvvu+UST/nqPjPkDyMGLoxfu7o8rgM0YUHpM2LtOIYEdmSrQpNmuvVICVu/FZYReFMeg17X33fN+foSZk/AlswwLYiSY1HlRRfJNdaWxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98zaC7lE+hd2w+l0ylIYRi1l5+WKJFoSGx3Wkhw5QjU=;
 b=VzkYN1y7UEKDNaIoMWbK6hRIIitQXqDdorqzbQ7gnHARgleGsom3waRTGBx5G6XXS0wSoO3Ztb4mdsuPu3ZrZVcc/ISlXCD5erJFV0hbwiE2pe8ZYHhdc+p86ZGtNis2rczHaOqqd0lRA5aydmPPuLxisf0O/iIHatle2sOlDdE=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by LV3PR10MB8060.namprd10.prod.outlook.com (2603:10b6:408:288::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Fri, 5 Sep
 2025 15:30:11 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%5]) with mapi id 15.20.9094.016; Fri, 5 Sep 2025
 15:30:11 +0000
Date: Fri, 5 Sep 2025 16:30:09 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
        Usama Arif <usamaarif642@gmail.com>
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
Message-ID: <0cd87ad4-206c-4367-b7e8-9c1ccddc15c7@lucifer.local>
References: <20250905141137.3529867-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905141137.3529867-1-david@redhat.com>
X-ClientProxiedBy: LO4P123CA0298.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:196::15) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|LV3PR10MB8060:EE_
X-MS-Office365-Filtering-Correlation-Id: 49b79090-a33b-4e53-3fa3-08ddec911a82
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5G+6Ts2zGGM988OzQHze8yRcQ5L4Bhgmsval1boMpUUUMsmot23+sYR3NZfW?=
 =?us-ascii?Q?OGVxtgPYFjhRE5nMNK4hcXgiIKLQCZnDehV1juIZojaO4x7d4chUj1ReVrYW?=
 =?us-ascii?Q?Qw/6OxDtVGSkI1YcirbbbJf/3vJCOXjrhhdhukHwImVOvq2FJwgp62pi9PIB?=
 =?us-ascii?Q?mP/6lIFJ6fuHFLUUebyavZH97/Chv9/8oQgW9nFWoAHJrQxC0o8ibzCiPf0W?=
 =?us-ascii?Q?KJlOiI1hIWbu8FTWJqNufnH4cUCkV9JcH6Ia7lU0GPKa+heN8eOmW9b4RpGx?=
 =?us-ascii?Q?xfxzayd1Db2V2FhEK61ZtAZkPfhVzcV7Yh6fS/SfY/l6lrA9PaqbJ8taG09Q?=
 =?us-ascii?Q?31ffVkM/BloyoWDnq1YqYHpP9HC1uqK8XRtel3n2hKxTIKVdr/1CO+c2Ll1Y?=
 =?us-ascii?Q?sh9VM9aVmEsaCV2FnxT01N1D6KVBVm/Ha8fP6iTeArXNi7KNE52znMM6vE8g?=
 =?us-ascii?Q?uryKQe7xb88V9j2wxiaIsLiVZ/HfLon5TjkfGGYggj3BFHxkxhQiUGWIglP5?=
 =?us-ascii?Q?9qjM3Aqce3092IiDe4caMhUKtu+87WzPKNirxskvFFySAQSbDzFfj4rXesbk?=
 =?us-ascii?Q?GIIBpcL1z4azjfooW2I57jSubAJ1+eqIZlmlHpxSwJsdmyft3Gry5EuK13R0?=
 =?us-ascii?Q?p5+1oU1xc1O+hEnYUWwnu4wBgUL8yO1dQpuf/TH3OfsdVYGcrxqcwv/EFgnq?=
 =?us-ascii?Q?JBYtN3rzSQ1IxBdlbGwhxiytW3ZQpS4uhcavgTxe4DXZljsH78NBi+KWczqK?=
 =?us-ascii?Q?eLDiMlkDbAbRCIjDgVFtPf8zOcdxrBGdtlgN5hv2Ypme4IAZDH4rzPv2JDr7?=
 =?us-ascii?Q?jIJ90pkoxUIBmJ9wiIs1tYy7OnNxg83dtzIoDtwU36TBqHCgFJQXco3plIXR?=
 =?us-ascii?Q?EPYrjzQ0tNu1S9fadenNAfPD5AUlwuMcM7PxQjudFM+Oo5BbV+WeDjdG1V2D?=
 =?us-ascii?Q?bUUGcyYpqn2R3CCAMYCssVPphyEF6favlozvYG5+MMsdJ2A5zBPR1Le7n4E8?=
 =?us-ascii?Q?LqLJp5UDwdit2OoUUyuon8x6Jqd29wnyE136IC72VJ1wX4z5K5RVKewUdNBu?=
 =?us-ascii?Q?C01NWCRstjavZhX2iDW27XopxMu1n4Wz3Tq4RPPj4tpL+2X9uwniYrJmzsuE?=
 =?us-ascii?Q?uykVwGCymWRr1dO2pmvIzGXh1EXs5ymraGab0h1K77hySwTLEm6vLocejAKR?=
 =?us-ascii?Q?msD74+X/FQ9GJuKZdvfqONmVXFDkw/e0Ej5X86vGG2pVwvkp+5ATSxYCcEuB?=
 =?us-ascii?Q?2GbhJwZKfZHI7fcNzVXmp7CCH/E15vCCE3mMHKpra2MsCc/krLpcCB3hADCI?=
 =?us-ascii?Q?bimTs0a8SMTpa7xAgBWEYJoiSCU/zOZDdkYRiQWIiis/thAc5Ri+9gr/uvbT?=
 =?us-ascii?Q?RbdjpuCAkrdEPDRXF6ek2tQlnJRsL8hog3gZ3qcfVBjnu9qlAbIRNFVlvt0+?=
 =?us-ascii?Q?2CgGyOt0Z78=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?36S0GWrV5UVG5lcSpUTsvOSOsyXg5naBdg1jv1wKKM3GchGzxYefOZPN99lw?=
 =?us-ascii?Q?Tkk1pGruknUd/ZjSARjxrvvUlmpWR7KlO2EqdF5YEgMb8fQrKafiZjenDvhg?=
 =?us-ascii?Q?HMj2HZZBpP7bnZJCaB02r00kS+i6s/EdBNNnaoI7Day5ppRxMMCu4zNlWrbz?=
 =?us-ascii?Q?mtGbDkdMlLjeVeq7cwkG6iIu7+aFZFzx0o3zZBonDigTJIqHlSS4tWGGmkNg?=
 =?us-ascii?Q?v3Rzg7KhGsh4uShG/iRdKJWZwbpGZmcikkcSqYmVep+C2LwYqY+BSfApEpOG?=
 =?us-ascii?Q?H4UWVIQjUAPh9dv8F5lpjac/oOJrFyE0qjSrbUk4PzPArLppOG1Kc48d7zh1?=
 =?us-ascii?Q?bYlEXtJXn1I+jdp4EqgOWmVDmsJnfUud2Q9qP/hjsG+sEt3ynkhEvdNq4vLi?=
 =?us-ascii?Q?6Nj1aTlhO84tl+5YLgJEBvaOUpjxBucFIQ0wamfGVIs4c/qRlVGHIWRuA6Tt?=
 =?us-ascii?Q?CwygvwqaMFvadRRcPcLOmw+RaYbpix3iHmStLMzXUWd+UiphFYTTNaPuSEgK?=
 =?us-ascii?Q?hNB0pp3KciIuv4W6yzCLPF17iae8UF/NQABoT0enFaL+CLSXTcRo/W0yYZs+?=
 =?us-ascii?Q?qTZSRtJWKz1PqZq4OwHQnDFOlPpPMClPN6Cqv4OnALTv9Iu6dM6ZNKRI+Mzl?=
 =?us-ascii?Q?iRtWwzDVvqYYjmuqrcMqsHT1303D/eY+nGrrppWlr64iTcvfikJO2zQ5mAaC?=
 =?us-ascii?Q?WhH+ELEufe2NW7MbWu02q36fCrW1jse3jHtLXKDgNFhfaWKqAWowgIGBZ83S?=
 =?us-ascii?Q?KOD7bFA4QFOckG9PjVQ0Vf7S3qwxbjv3QBuTt/SWT0eb+qzcP0LGfTdIyDn9?=
 =?us-ascii?Q?wJp0XKcoYI7nxrFVBfHdyQtATETF28CUWPivEiUg4Afr4AnHTNBQNJNFnoGJ?=
 =?us-ascii?Q?jBxEQD4VQOitB5yzc6LWnZtvnH2tYraklvt/wVv6X+qarU7rYPGuSiGuyA1q?=
 =?us-ascii?Q?UEtpoqhlqdjQrla7FMfeIxJ0pCYWVzNA/zCytA4tlYiXKTHJ/H4oy26+L27o?=
 =?us-ascii?Q?2MXP2RwuMnMZBYqanu5wPKyS7Oln00cXbWgD35F7ukRXKkjXe1gLK1RaDis5?=
 =?us-ascii?Q?zO0hr8/K2TlT3elX38JwVmQGov0UyBUNuD5RVtnRN9YYDc3F9I7GF/HPvlLv?=
 =?us-ascii?Q?3zyOB+U/aBO77+2At14G5qaeeFj+YKSnZEfsy9iYAw1wkU6IMwlkSUXLNBtg?=
 =?us-ascii?Q?KL8kJ9j0FpMOIPy4CQcdxb+q/XwfLU+pOuE19RIaOTEjs+eFKIegCMkduaRU?=
 =?us-ascii?Q?8QL+uh+GA6kqsg4ocP3TEyUb/SX6pUlDJKbc17wcFVsLWbGazE0+q641djbB?=
 =?us-ascii?Q?zd9wYUrRhA62rmxhLNnYL2K9Dt/Sr0jwliyiTfG5KKM9vWFAI3wcJlM6w7nh?=
 =?us-ascii?Q?HeLNpzHxq52G7DOxfZrU7N0+6OBOwbTnd/loMs8vMxOdYV5UYNoIpjggrXVl?=
 =?us-ascii?Q?KrxU2Zuejqh1+bsjIXTMHblQDxoWKxIKhkPrOrwIdHN2L2kqiujMY1u4AbIq?=
 =?us-ascii?Q?nR6SxNB8XQXyvPi0eFXlqhoK87teaQF7FUWMyx1v2Dds/nYKt9U0FGKCGZ2m?=
 =?us-ascii?Q?TXz6V0D6OT6gg2plhMsYjxGRqUzLvHuEJvc7KQwn1n6sJhbPbN3tevfl17TL?=
 =?us-ascii?Q?FQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	24vUgWyEgxxYeMIzdiIoLxZuN4D0FwFxorRNv3pHpzbKfv4vXRtXppFaTcp9cVxKwRpCNsH2vkmS2wfThR0ysT8vCD1Sg70m9zU9zetYS2+aFQ6e8+wMgXGnXrztB+5tOEwxUiATfgWJgV17sXenQEkn6tzqXivqzbTUEP4vzDGFCatW05DaUS5g7F41Kp4k/bTEw47Eb41fPt5kFlgW/ku+8baCfBae+U7P9FpzWIR4ilwyJ6iQo811f3ws3a2YX8XiZOBttsl81oFhetyZfawnkMZkrtS0kkWyUly876o2Wm+qBoppmdN5hY4PnviwFR7xuB/kbtKavICbdGvnAFOxVcBdFWhXaV8lnfy0dqaUzBPYE9IN7sVuHDLWGAk97qaaCrIe1q5Vps50YnQFsf6p0qXssjcTj7By2Q7wXEtUOO6txT8vqRzGvQnpLoqX11G/4de7AGf6lJPAiAE+nyyI56OrcBqq48+knIJF4PLVZ7RAa5idl0EiOwZtBaKshUhGiaNZvMu4IbPk2AE2+p6SjNJ39ClQa+RRk1dNbFmCdpOHeFpRYAS8zBbiTx4JagE7jaNXB0PdWx93Lrs5bOAaIpMK0Rd3I64w1kAJCIg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 49b79090-a33b-4e53-3fa3-08ddec911a82
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2025 15:30:11.6182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cVkRIVXeXQljX+PbGT3ajAjLmOPGK4223RjtaX5ZQzQeQNqcz7+/HVN6tn5WRtp5Y+l+VxJiT8mBz5hX7QONsXFjyNjvQD671R+mqAtccCg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR10MB8060
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_05,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 suspectscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509050152
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA1MDE0MCBTYWx0ZWRfX2BeDwZa0x6Nu
 3HrlnXBnkxXXIWKMZn88SCU9cc1ecbCqmDkVZ1gvIjtyzUHHLA6uKzZ+CF47y/+C4GtGFj+OZDA
 e9u6CBYrrUeZzIyiR46Qc5C1cpcdIr8aEUXJMln9d/NCBfhdfR9UFjqnkOZNXn7hPgc0y4FPFg2
 v/wBk6lmX45N9PKet/GRKJVLa058IZcyyq2Fi/R4zi8hMr+DHBnnpoUSOdw8ziSqvoBgxfRh8zJ
 9DfPnIhDn8+Xbre4bELXlMZ7ruEh1WRKbfb6YVSe0DcKPDGYrvhrJRmr3m8MJ+qxgPVOVQDt9O8
 YfG2Ic2PIq+Jgpw2dlCX/iqCuTHntY14LLr/rvGYnHOhn6VEUh3Ry5e3w34JelCXKnraNPxTtDh
 fSf/VIDw
X-Authority-Analysis: v=2.4 cv=bLAWIO+Z c=1 sm=1 tr=0 ts=68bb0207 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=yJojWOMRYYMA:10 a=GoEa3M9JfhUA:10 a=Z4Rwk6OoAAAA:8 a=yPCof4ZbAAAA:8
 a=Ikd4Dj_1AAAA:8 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=PRfKf8xcJO_4-veeR3AA:9 a=CjuIK1q_8ugA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: huD7cF49tyvj_yew0WFJFNyVUsAP9W94
X-Proofpoint-GUID: huD7cF49tyvj_yew0WFJFNyVUsAP9W94
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F3F7A20016
X-Stat-Signature: pab1c5j44mfwj88cs6q5i575eeffqkdz
X-Rspam-User: 
X-HE-Tag: 1757086221-693381
X-HE-Meta: U2FsdGVkX196Aae0TxTmPoryN/F+NJNZ/TYzebyr9NEbZDoPRPFuw75pZ6iFMwX0H4hD7fNFHWoEQVqojXHx370vqFh2NcHsWJOx3UuS5GhRbZ4Wjn7SESJBZ8sazLA9iDVbpeyfZTbd44TvUikCWAio18w50b7OeJrkKLInofq6Oq8L5vGHkF7g9Ogtj/nVZRCfiqLr6+QFFyUxY2LqkmKXP3kQJSb9PVnnW6WGwZohwJmRdfLw6Cbucp4aeKWMCcqAEFqmg175a/qYrUGZEcQJNAHCUsLEJNsBNFAXBcbQHvaFAKdtfO1lLxZYSJFdh6btBYsemwsjftAJpDsUSevZXkKO/CO5L0CTvfLAcgv4wrng4QdQrvoh/25CN/q21iej97uYl8EyRS2tIooBKD9LauMUdkpGXSSXiqPTT8kR1tJS30tY8NL7dlhFTfvw6WAfgkSHIsgcEv05V3g7C/Glq+STje151u2iBqkjdj+XXaDTgLgXMT/BrzhTUJMRZYAfuFnjZCczfSe9uujnB/pDgCugxk7st1BmznptX9iUSMr3eQydGkFiA2v3kg7js3T8ZnNWsvfg8aoBia91pTm5WYop881TnNQSo3cwbuzYWywITKoF4USLGLRRvlWxxxNx8rQBTjaSaBhib5rLYZ3LI4pBqqy78+bkEhYNd0aWB8LZM+v1+oLr1LCaeZi8JaEUQ2DGRFtIStin9ysyoNPEBMQmAj+xipOW97z+AdpfHTXkBWaHTxkpJZWRejBpZQnSuqZDAirdty+5i2lTUUEHS8vY4od0G7IDAUeleDuhMNLnOGdp+CteRHiv231GKyanLjqSMVeXNG4V6Y9ncdYHY+SByypwY9sLICrqahnA00DZzu1bmPKEFcWfjDKSdB7jnlwQH6aD8yBxgmLnXiGYrM5L0jF6Do1hZ9KXo/+zxP8hyliAk9AQMSBJmbS/cjKa+7o7XeLd+g/z8tY
 12XJN9I8
 2AyX8U9AMXYORP5+DQcRO7iiS5b63iTJWEh5Jt3gEGL+hujczyyW7cQl6vGQLMytFQE0MZykOMx6CD+nG9H9+hNcPrxAd2tSY+EGzyPp8vHChuDzpX/NDq03NQ4bfQRiT3ZaCIHWbAZ1gjrTDACb9OB4BbSK8IALFKkaSqes5812IBLrZpA5ddG8IysXRC8NVjdNEsUYMv+zsyBSVPj3Nd2RCtZRqCOyPMX53rL11uEf+Gg57L8Khr7lQliQo17K66eg2tG9Ew4pfe3A1bSmmVk62vM8D2LNQ5WJshyvOOghyjuEBnJMpuCrGzirxuWbusEKUqsmnlt8no4aYHczlZ/P2zaHsZP7QalLm8nPjb84N/YmqRqYSIqbCZUPpMIwA8eXlY+saL4az/7z7qBQ4sckP3q6fw+rizJip47f+APFf6PxPBcYgJopZSVlo3VtbyaqmCthnewnqo8ve7oUFJnQzNVv3b3uI8SK992K+G4KaaYur26bXFShOjkLmRn6rd+FarNng1w4iuakFdZQGCg3/tmGLuN68d9jp/HgLvYmpzJzkIphhr9nDFBKPD4oRQY/UZFG2CRt+eohx1xzDPHdCen8oEz7h/e0khVoYYlD0YhRu5Zoqa4Vh6sVDY4VSe/3Ven1LnWQucWDqYFIBbm7Oat6nba8iPyaq0959FiVFArrP1wcSpH9jmXloMen5sF6kaeQwiWPweT+a/cieHYpF3fTVvdXCHfjaOlRBiQtasiDNwIIjbURS1wX8WJcKtMVeotYKUvoRGILEFZwZw8laTII8UDY1YNMV3SlBcWRO24EvXrKhn/tTXuGRRO/A+ePmhTHef9ROFgtjR0Sm945FAG5zlLMDoGc5IW0/STcHZRE5k61UeyAkfYuvYyYbjvXQ55zzaraFM9u32sLwyc0ziBei+QJRb/I+dPq/0N2JpJ+K2iVyD9pjFcXZC2HCHre05jdH11ScRAvHS7nPd1lne8CD
 y4jWKECH
 Teibr37ETMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 05, 2025 at 04:11:37PM +0200, David Hildenbrand wrote:
> We added an early exit in thp_underused(), probably to avoid scanning
> pages when there is no chance for success.
>
> However, assume we have max_ptes_none = 511 (default).
>
> Nothing should stop us from freeing all pages part of a THP that

Freeing 'all pages which are part of a THP' rather?

> is completely zero (512) and khugepaged will for sure not try to

that is -> that are?

> instantiate a THP in that case (512 shared zeropages).

But if you write faulted they're not the zero page? And how are they shared? I
mean be being dumb here.

>
> This can just trivially happen if someone writes a single 0 byte into a
> PMD area, or of course, when data ends up being zero later.
>
> So let's remove that early exit.
>
> Do we want to CC stable? Hm, not sure. Probably not urgent.

Surely this is worth having?

>
> Note that, as default, the THP shrinker is active
> (/sys/kernel/mm/transparent_hugepage/shrink_underused = 1), and all
> THPs are added to the deferred split lists. However, with the
> max_ptes_none default we would never scan them. We would not do that. If

Nit but 'we would not do that' is kinda duplicative here :)

> that's not desirable, we should just disable the shrinker as default,
> also not adding all THPs to the deferred split lists.
>
> Easy to reproduce:
>
> 1) Allocate some THPs filled with 0s
>
> <prog.c>
>  #include <string.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <sys/mman.h>
>
>  const size_t size = 1024*1024*1024;
>
>  int main(void)
>  {
>          size_t offs;
>          char *area;
>
>          area = mmap(0, size, PROT_READ | PROT_WRITE,
>                      MAP_ANON | MAP_PRIVATE, -1, 0);
>          if (area == MAP_FAILED) {
>                  printf("mmap failed\n");
>                  exit(-1);
>          }
>          madvise(area, size, MADV_HUGEPAGE);
>
>          for (offs = 0; offs < size; offs += getpagesize())
>                  area[offs] = 0;
>          pause();
>  }
> <\prog.c>
>
> 2) Trigger the shrinker
>
> E.g., memory pressure through memhog
>
> 3) Observe that THPs are not getting reclaimed
>
> $ cat /proc/`pgrep prog`/smaps_rollup
>
> Would list ~1GiB of AnonHugePages. With this fix, they would get
> reclaimed as expected.

Yikes!

>
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

LGTM, so:

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

> ---
>  mm/huge_memory.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd74189..aa3ed7a86435b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>  	void *kaddr;
>  	int i;
>
> -	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
> -		return false;
> -
>  	for (i = 0; i < folio_nr_pages(folio); i++) {
>  		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>  		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> --
> 2.50.1
>

