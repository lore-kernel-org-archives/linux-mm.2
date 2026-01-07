Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12166CF6BF2
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 06:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58D8D6B0092; Wed,  7 Jan 2026 01:55:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54F1D6B0093; Wed,  7 Jan 2026 01:55:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FCC76B0095; Wed,  7 Jan 2026 01:55:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6926B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 01:55:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCE36139114
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:55:26 +0000 (UTC)
X-FDA: 84304256652.11.1BC2222
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf29.hostedemail.com (Postfix) with ESMTP id 628E0120004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:55:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GCrOGkb9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GCxvD1/o";
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767768923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtU6+zuQIv+xiQwm7Mq5SehZZJ069V9tP6LFACbW5tw=;
	b=kqjMNixt05knD2e/sX33rzh2kxicKf0xOORi5OeGxqIAXxlw8hzDDGLg2h1JCcFX2D9AV/
	ji0AFp5axB7uDKdROx4fSszgIZMQtjrcngmnfTSkD6XM+h1urDFT7e0tQGB73X1LZ6Um8o
	ibBb6lRq5Uo3CDrlHQFSIZXpuL34ZvA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=GCrOGkb9;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="GCxvD1/o";
	spf=pass (imf29.hostedemail.com: domain of harry.yoo@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=harry.yoo@oracle.com;
	dmarc=pass (policy=reject) header.from=oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1767768923; a=rsa-sha256;
	cv=pass;
	b=Mjlu7fTG+vLj3y6TxxHExTV600V+hR5PpxH2nBeXemA58D5aD3S5j+AGNyYBIyKCYfOOoP
	yTtEukE8bEa2TlKyVDF8R0OdsWc1RtMEcxFuo8ENdvQqhF8RRGRI92e0ko5S4d7SnLZGA0
	qXZP7uWPJX6X+i0nbbkI9RQetPDz6BU=
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6074KTsw1673967;
	Wed, 7 Jan 2026 06:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=VtU6+zuQIv+xiQwm7M
	q5SehZZJ069V9tP6LFACbW5tw=; b=GCrOGkb9KDTE1uqF+6IkUvFMuhCpmDGFml
	/wLDHyhhD5K7m1jmYekZtXWQZGiOmWzhXX6J7auRw8EkB2eaqs0aYzbEhuX75ru2
	ORv65Qky07zmkIiFiRi7SLI+dtLDsBCV3IQ2No8NTOsOnPMrr/SGdDNn5J0Rc7q9
	oO1mPHSJBJ+Fy0owlxhaYqtYvACBRqEdoipMAu9UYjyU8lmt81vXlRvhOuQjXuWT
	eLhLVYtlzeolK8CrzMjLdaVQpXRn6t2mKI6V0loDoQ86piEc1kjKdHsvouhbfeNz
	qWq49C0ID4J4VgLN/eHU2s6G5B8bLVsdORc2zFNLz9RCzUp94/4A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bhgcf03cq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 06:55:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6074WVXq030878;
	Wed, 7 Jan 2026 06:55:09 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013033.outbound.protection.outlook.com [40.93.201.33])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4besjdhepr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 07 Jan 2026 06:55:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I7GnfN7WSP/Rcz655H6q9s4xV1HGVsUkQv9m7tJfobu4dAK73lDuC7dWEPJSUmbtFYlgOOXheMh49qnFKvIfwp/qQk5mq8Ku5hkO9u9TgIC1vKzLAb3ojBqRInsKIl1M9RCVkeYEy6yFLyEzGR5Lh5T0TEhelhu/5TRkLS8qe38/MM56fZP6fTNYEMdAdK1V1NNBUiXj14t+6FWhEFlI3BK9f/4we405Yr+wsiKrcSzglnPORRqs2AV7l0fwaqG67a+2OfEKphEygdM+A833zJO60Zq/b3146PONoLj4iEFhG1ThYLnCpW5d0mZrZd2x1ffG8msWAE5zHv3UBZutWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VtU6+zuQIv+xiQwm7Mq5SehZZJ069V9tP6LFACbW5tw=;
 b=H+mrGTzlDprbtL1cDEiuyUQuZNwHj2USHqyRIArd9mhz9zUmRF4Zn1WVZUM5+jdiLiWYVMYWEo3NgEGXI/NGAg/AxYMfT8tehD0BcaFX4dgbC+FYGFc/guNC5YR2lW9asQBADvqozkN2jyuXk7oi3OArjgXX2YKmsVMA+R6Poukpv+30wQnIEpRMHnHr5/LMgftcJmYXuZUpezyiM6+yM4muEhXJBjstyOlsPht1IphQnmwt/m+6baBSPmsCNjBeDQwjvojfMME81Zi9G4usBnMLASmxW8/+h9M6nM6IVaPrJe6R7yKCEIRYYgyCfwbbVnGlyh64AHXV0bsmd+63Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VtU6+zuQIv+xiQwm7Mq5SehZZJ069V9tP6LFACbW5tw=;
 b=GCxvD1/ofR96KklUQQT4w1b7tsaL2P5N3B/f6hjhJNBMBKM7nKATm2790nR1AD1uTicsHX+HdhV8LgstBK5OYa+/gJWYDIJhmr3BDR2CKdpcRxZ48Y59rDjbkdXpxejjf0Z6Yt0VpaV79UQzg2rEoxAT0LGaMVzqqFCNAzhGtHE=
Received: from CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16)
 by PH0PR10MB5628.namprd10.prod.outlook.com (2603:10b6:510:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.2; Wed, 7 Jan
 2026 06:55:05 +0000
Received: from CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71]) by CH3PR10MB7329.namprd10.prod.outlook.com
 ([fe80::c2a4:fdda:f0c2:6f71%7]) with mapi id 15.20.9499.002; Wed, 7 Jan 2026
 06:55:05 +0000
Date: Wed, 7 Jan 2026 15:54:54 +0900
From: Harry Yoo <harry.yoo@oracle.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com,
        will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
        Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
        surenb@google.com, mhocko@suse.com, riel@surriel.com, jannh@google.com,
        willy@infradead.org, baohua@kernel.org, dev.jain@arm.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <aV4DPmDxOsrYAa7X@hyeyoo>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: SE2P216CA0104.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c4::8) To CH3PR10MB7329.namprd10.prod.outlook.com
 (2603:10b6:610:12c::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR10MB7329:EE_|PH0PR10MB5628:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a0d6a9d-7332-4c46-b3c4-08de4db9afe7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|366016|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?w98otacZcb0oKZJnprxx9JnU+d2vjEWWtk10hrzfhg/cjD5zIQqSxMEUSFPH?=
 =?us-ascii?Q?vNoZiW1StPEpH1L/YLnYvWw7hvWAvkv0uEYk3vNB/1MdCd6e9ZVBnkv3o5n2?=
 =?us-ascii?Q?qHNzkKBJ8+Q4mpNwk/0TPBrADDWVYloJ8lNYhapkPZTWbmt+vGeRHVN6I/mc?=
 =?us-ascii?Q?a65uZ2uXe7ILbVKlIfGxZ8UZeF0a8YimvlX+95Krfr5AA3pvQnwMP/xiQtzq?=
 =?us-ascii?Q?jP0c6bJGDsTeMpuHvhsYr/n3FqgTEnXg0Cj44zI33e4LHWGPJeoeXz7PZPBL?=
 =?us-ascii?Q?zRyQkDgNzxiYBBtEZgDCpb1mEycJvmHhYbml3ACKaW2nOmHuCqEeEOitY9ty?=
 =?us-ascii?Q?C0VBoTFEK71zXbF5cguTrc72cQiVMtGpCdK0x0cz1cU27JA7W0ipTmfmefAF?=
 =?us-ascii?Q?m9KqN96g7vaKIglw6QF6C0TjQU4ewzqj0ND0o9wBw2ImYoWb9NDUJZuHnvba?=
 =?us-ascii?Q?eXV+uAndi9MTcJZ3xV3HKhBuvgW4lr42k2ZRosA/Dn7dxsrKlzaC59kfyuuo?=
 =?us-ascii?Q?oGTj1DFyjag/2F1HQxZ6zxvM38U+VJZcXrRl26krAdczVbFcW2E6gI61chC6?=
 =?us-ascii?Q?y4Fr8ADzg4vMSzxBaN5t7ccs06xTA2P+kyLVtPb2ZNRvYXVdBT6+gDRUM/Lb?=
 =?us-ascii?Q?mTgQZmcMdeX5fTUvEO6rqkPbLH/1QVyPwOUcx8hwIOpdl76zWxJc6WC6YRQo?=
 =?us-ascii?Q?eR8iXZmTlHN4CWArrpo1K1VN0WTvLwDNHQvY1t3yRKGG5NTiEazthqTAA4i4?=
 =?us-ascii?Q?xEB01bVrisxBqXRlKwe4QLNp+1m9QHsrzGj3beGGdu8LgUyyF2R/1tW0JyUd?=
 =?us-ascii?Q?JFiM5NQ8AtBx4ibtTgVJt82es21ZpJgSPC03sciNKSLJ7CeeySTb4UWqFuUY?=
 =?us-ascii?Q?ohH4wG8W4DJUbAIHrMRLUn3eSaCObfvkdKQSHqx1WRJv7gz8svjfG2E5Att9?=
 =?us-ascii?Q?aLe+EKWBOum6WQKiyqgTw9gLx8QTg9K6T5JRs2iQcogbtOFM8BznYU7RlVjE?=
 =?us-ascii?Q?dye3kPphIW96EZUtl8G7uomBuirGZ2EIvy1RwQESTQUyqEo3rRuljogaaNgX?=
 =?us-ascii?Q?l5wBcDchgbqy29aTgj0ypFLDgz5ofPTVfu5XezklezfNa2GGGRZItbblYgAS?=
 =?us-ascii?Q?jep+BXISh/e4E2HnY8WjQMuA3sr6GrKUVFKDrKzxDaudeIbMsXfg3h24Rr8p?=
 =?us-ascii?Q?qAILCi4lapWWcaqdW5RyFcT7bKAuCZphuG8ilPwMaxnjr+F/dRw8gnnVldHf?=
 =?us-ascii?Q?rgs1H5xVSVYkOaC0XFUpIRbt0rNbHO9bJcxatD0dK2Lim9/LC+8NrdekKEok?=
 =?us-ascii?Q?fNxUZGGBaO4b/22cXzGpPrCHURtxobPB57AjKeA6QFTtfRxDc0vXeSSA/yLZ?=
 =?us-ascii?Q?JX77GtN2r+KXcGnC2zbxMxjFq2timi0oTraL2kLeiu9DixgXyk0l/9Xxl9DP?=
 =?us-ascii?Q?6hBnHYZtAGW11caH6A1y2H1/QUe4vZbvHjpM6C9Y/7IBQorf0e/WAg=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR10MB7329.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?yEGp7SHrbE5S0q9mqcqWDyxM0RdT0dNaA9WcOI9qSeqcE181EWYQVwaV+y6D?=
 =?us-ascii?Q?PzXIcf3gcerHKWdIdAEBWrSUpMDCGg+HyL+ExDR3uuMbonxOR/UhW/A4b/kt?=
 =?us-ascii?Q?ba0DxBB0UnC15eDzJt2PpAmvDMFMEWSmp8MWVK0frYJVltd2VTLHQNOl8cVz?=
 =?us-ascii?Q?6fEYTxx30nO8miFkK9eKetNYZAEcmR7IGcZHDgMefMq+5kPq9k4CikOMouFr?=
 =?us-ascii?Q?INQ5xJWyrqkb56XkzAYC9YLBO6e2cSRzVsqTrzIWQhGZe8SYHIj+l+wJrLj5?=
 =?us-ascii?Q?66CiRsps3BegfcCxV9rxIkPRW05QhegmvnjIxyGX/lQvla4w6jiPcDVpNWaD?=
 =?us-ascii?Q?IbzhkrCEhOpJgSyhPBdLsJOn53ND7HuC+I2E0KfMsWwI7nrRZ74bw53Wun5O?=
 =?us-ascii?Q?RAyCjsFbwbn2tpExtJ46+HxD8URF3sxBs3URZJQdmWvr89x5egrfkEQNGd0g?=
 =?us-ascii?Q?0DJZOUg97jneo8wnzSSGR+mgHeT6zz5QD7rpNpFFGTEFqeBkLv9jTXakdloX?=
 =?us-ascii?Q?+DfO3vBrAIGi6IPny7SzppOrrUVBE1jrjaMsA0mu9eTdFFzzPPkEsWA0g3f0?=
 =?us-ascii?Q?r8R/WEwnK7Psz3Htih00vQfTPEFzafrP4Z1ieFlDWZg0DZiYlWptdr4Dzd4K?=
 =?us-ascii?Q?oNpm+jIFo6xLiUm6Y/YQ8hkPnXuT8cHHRel9HFiFqqXqYWfElqMBnlq50jUm?=
 =?us-ascii?Q?PRIyQ2o3pfhao4+8PIMVzJsJs6YryrOvMr5zuGI/2bFB+xZEWAwdiN/gbBXS?=
 =?us-ascii?Q?eLDUQ9AuLKGw/a4ixoTJNNGPFS+2r5QqOuD0C5aJuO0lbNNp9srkJFGivuGs?=
 =?us-ascii?Q?MEkyX7xnAhj+fhPqdEn8dIyAxv6mGrM4r5XArkCObMGOx6xHb+t50w10AIaB?=
 =?us-ascii?Q?ffvO8LUED3jFZrMG1wB7qJk+VgK//L3YR/c4Na7ooN3LKoG8UybvoYvJUo2C?=
 =?us-ascii?Q?v91ZyULQlBqnhr6HXkoYUfjt5dRA0zNRQvNcw01Dt2wi3TkLmhPlw0pgO90E?=
 =?us-ascii?Q?8wgekkuqCSZr+rZbF6pwBLz1OP/42QA7Dus6+qmJYk7KvuG9/nTqLi+6DIOb?=
 =?us-ascii?Q?SDy7SAcsMND8JHjadM9crWXnPK4ab5xEcaVQ7TSAEcrm+zJhqxMowP59A/Qr?=
 =?us-ascii?Q?9FzKDKHzEfKbdifbgJIOGSsn3olay/MrxFOD4c2WaArHt3TkeLKlNPuIhZ1+?=
 =?us-ascii?Q?ApvB+Lc8PJt1HfejJIzHfDe57fdR2d1qW3IU3q9ZDF93tcVdJZn6EkpMzVnI?=
 =?us-ascii?Q?dAXDj08e8edVncn2knXdrwJ5B9W3yOL26EZVIhY8z/r2vKxaHWPjfxAP9w/+?=
 =?us-ascii?Q?y+XBhuIpuDZkSSGuUp8n7s8TtLar8fEApFRuj9Lb6q1s+zDuKnFTJA7SQOIZ?=
 =?us-ascii?Q?r8qRW8q2IAjRHUmrs8+gskmKbTy0LZl/uvtidJQZuzimbbw0cOrpVAG64z4X?=
 =?us-ascii?Q?VM5pasT84gi8d4lVpSGtI8aRYWH7PXW2RqOSozmkzdUgA1TLyY57rCU80wQD?=
 =?us-ascii?Q?MkGGhMxShLShPC2v6kzlvNtTUJzI5OPccTplwVMAKP1XlDscgG35F73FrokL?=
 =?us-ascii?Q?j7kLWTacoHTFm2CIKz9TBhNJiAp+NRB9A42tjJsbZ8Vj/QPFwxniiLak1wL5?=
 =?us-ascii?Q?EZdJTfCkQHmWmZFOBt5Zhl9K+OkkOpFN+8+6wvgV3MNy9YdSHL4tyM/Hhdph?=
 =?us-ascii?Q?+b0/m+QrSbOgcWljrp6+91RvTIcs9aD/RrTTASss4puA1gMOg43R8VI0Tuxx?=
 =?us-ascii?Q?71VtXSXh6A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	6rAo2plAbEnEsFKHl7oZkI3vsafkI/eO5xAx1M3XDg7IrDM40qifNiz9Te2/1S3yfIetOysrmsJcYCIct8CHCcJdlbxurk2N/WQSfvJdTy5E+LC68YTDzZBVAo50s+RslE0VRb/FA1E7BAjCO2Bt21eI1xlqMCglmvt2OnxvNUnwo7sgtz1ykWhpZo8qWqlhswAzqENgB9bd2AOWG7HLV3JDeEkPhslsIfGcOvmW987EIzDZF0ZSoE9Jd2/peA3N/m6bL26H8HvYGgKXFK61agqOT6PQII1OyWTrDIdqoLTXgt/fgXtRn5WmWIdyj4ML886gSl9cglMpT40izn5X3ji07WEUiXikKyBhdBxKwXMoWfJYafIKFeOvFH371QtKX2FlnKtEOaUK0yqzOxuRdt3aQjLmWs471GyTZI5/6A+QWLduZmskYKPBLubB9R8orrXP5aCZmh82RgYNqOm45HiB8nHKnEJNBACpe5ssV3tQmpnJdZGMdvRi+k2L2aNAel1EzdsQ5MTe9xAy4KA+YwEJcOuukzixLL1BH/T22ypt9xE4NKLdnhZNdx2Ni5Gn7GlPhR6OR9eKXUJ1nt2PPOaldqcyl1sXfwoKHhKtH/4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a0d6a9d-7332-4c46-b3c4-08de4db9afe7
X-MS-Exchange-CrossTenant-AuthSource: CH3PR10MB7329.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2026 06:55:05.1803
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E9EpUKBaOw93amuv81p3D6gImRZ3a5uwVuuwH/NITMr78giLGqRrP0cHLIb4noW3UDbKD7VWOqHBRHWUrlwE+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5628
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-06_03,2026-01-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601070054
X-Authority-Analysis: v=2.4 cv=V/9wEOni c=1 sm=1 tr=0 ts=695e034d b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=vUbySO9Y5rIA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=7CQSdrXTAAAA:8 a=SRrdq9N9AAAA:8
 a=yPCof4ZbAAAA:8 a=Z6DevEtsiDC8T2Dzv4MA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22 cc=ntf awl=host:13654
X-Proofpoint-ORIG-GUID: TOojnbia4t25ZmV2iaCGwth4uCsZqsD-
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA3MDA1NCBTYWx0ZWRfX7dHx2iOCr5yr
 qAdAipHF5DsEAg+JVgLbQXbrQ1x3avxnYxS01z7PmZi4zh5ksWvSLmYISed0lFB8IOwosjR/SW3
 Bvz4/QSNOFr23ojHSIB8OHV8Wo22y4Nz3ZSZqmVGveSzePPA28WNZmkw1RTNCKX3zq5HszV61rL
 ChWrno/tdxeY0gXAYFHM+8hm1eiC5+F4YH5K+LTCLm328jEXitOVNYQMIbNppNZfUHYZRHCIl5n
 BFtKI0Jy6mw63R/LEN7G5LoDJjfra8fzQsx7rcSV9TG4+QmuM9FPU3rK7n7J/afNFzLs9Cfhqjv
 8GR0dtYvxVooH7E4UiS5n9VW/BybHFwPRPuTWBbCmD4L5+a0IPGFh1sq21j3PQpDCBeEwSGGwSI
 AbOXGaci4Bbmv4/F6OnqeN/6MYCEP5LX9KpWn43Snc01AItp/xjmlhYYDQSOYl+9w5jM6tL5Soc
 UlQY/nWd47SiJcYao8jnz85TJSW+NCxGaFFzu80U=
X-Proofpoint-GUID: TOojnbia4t25ZmV2iaCGwth4uCsZqsD-
X-Rspamd-Server: rspam02
X-Stat-Signature: fe184ohhc9hgejqp9qwfichrexnycmnw
X-Rspam-User: 
X-Rspamd-Queue-Id: 628E0120004
X-HE-Tag: 1767768923-193862
X-HE-Meta: U2FsdGVkX19V56y+qJeQ73lT0mDnfIaD8hy1hkdz6sMxIF/CvQ7QLKqyGnSkAWiiiJ7ET9tECmYfsjVBSbYeZuMW+w3FZxZ9nfOnKelVhbdDqXm4vMBJPURAPMUukyxdi5+GD+3wW5oOtj83OjHOEO7gnSiaQQUXZphI2GbjKn0ACWrfaKWRPow1vnwHr8F3DejlKwFZEbUoHlkIl9VkIwnDSmWY5P279pkpcUK8+pSy6H7f9ij5sQehrGGXEcjaJXSbT56VUzcKgsKw9jNkXqrpsoSNh8BKipETheNbLd/g7QO09bWIZvPvbQU9DVR2VpkbbXlAulzbgCicN6N9N86tcsJ1E72hq/gJSBHPWNVACaVSNqR6xY3zEHLCz7TIYvUc8RXKXeF16guBxLwsN/OOCdufFQJm3eFVqkKeWwlieVI20JUReES3i5NUJGpJ8VpMU+Rg3T1MxP4N/K8H3XaMhPHTBe6WeP9NFlPiiXWiMouBZHZiIAvrmTfCAzvKG9KNo3OXJ+qvF6Zuq2jJeFuDJnPl70GG3stckdYaxJjj8KH3zEG5JW/5rgqltdtJE64CdFC2JMxGyfxU5MAS7lRUuu65gqrTq5C2n58mNAc/AXRTBqBBGT9xeEkq5zV143nmBUF1ufnNIKwlLFrkbZ0PUy092zncWj/or2sMA/oPLwi00qkAukJP0jZL9zhHZqT2MrC5lXU/grnZJWAD/su8qpkTTYWviaE+IVx8H5KbD7stBSGTMsiyF9AFNcdkLTuUT/fUzovtU4HVJnI6BL0R8zxe4Z8YXPFnEqZLj9FSV+52Qtcxcnz0PmoDKHXQ8Hk+OtcyQLSopebm7NcYuHvS2rzKed1My94/w/jiYfYs70j/J/K+CmXzUggjndtNqKWzXSstmF/5Glai69+OLXHp/gke9ldAcpFfOb0oUgNctfgNRPCznwseDjTaufkTxwq33GmK6oLg6ndz7RD
 Srd4pLb/
 G2yS4+eKgaZaXcHXXQN1h5tkK7uqp0IIBkabdLqeCWBA6sdXJSOfN+lLGD6CoGhQeszpOBTWfyJKofAPNRTehJut/fxxAVGpmGTe5qioZ3c+bl4fwkBwPQMb1a/GqvdoP5NjDMVQ0fMH9wGW56UGK5zuEu5skGXaPMz0wlTtuNEFyzntZ0hEf5A0J3LT2OGzXgzw8T7TDSi8VASQX11Ylz6sQDPmsW0pUYXzJba5LdnVadx2xYl1XeZKdt6m1BXZ+vksLTbkmmUqEv77oArUpeUgyCQyZ11hbbQRnA7nnJSVczV3/whGm28Edx3mc5TcBD0wGPWTJTx8AUiGdFwnoa//yOWqjsoZdUqtPyTyHOV46n3XmL/kSCGs3FMpLgP4Pxxr2JDkPka6kMTBwNIC4VIcoFX5BqjmUeUJemP6XhQ2lEgCMfwaqoCYwaKiDZCWRxrATl7eT/HlBUk0YHYa9tl+lG7mhbgGTU5WRtjozx7TGcv+v13ouWJe/qVzK/PdbkbxZwuUaebnuXfasG+oSZKObzmQRpBbEN3wwLCMlnKBaq/+zCzCKDVvlHIJ/NdcjlWK84cd8XUgqWdopFtykRo55zAFGijYOhL6E3dxjqNDMOoLRcJ4pKLK5Xq5fq+LQ9BUGnun3776WPr2DxtAEiZkjJvlD12OgImVo33AInUbrumU+OFf8Ni3m7udrm28N5j3efkTsKkwootqKpYJdMDh5xKwKwZKFBX+JkOHL1FIUmqurDnBBr8wy/HKTB48U5BrKx9eBl6S+Qmnf5dqRkyijWxDNaVQCsNV204RWRXSvFEz9FGYVGAuPQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
> Similar to folio_referenced_one(), we can apply batched unmapping for file
> large folios to optimize the performance of file folios reclamation.
> 
> Barry previously implemented batched unmapping for lazyfree anonymous large
> folios[1] and did not further optimize anonymous large folios or file-backed
> large folios at that stage. As for file-backed large folios, the batched
> unmapping support is relatively straightforward, as we only need to clear
> the consecutive (present) PTE entries for file-backed large folios.
>
> Performance testing:
> Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
> reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
> 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
> on my X86 machine) with this patch.
> 
> W/o patch:
> real    0m1.018s
> user    0m0.000s
> sys     0m1.018s
> 
> W/ patch:
> real	0m0.249s
> user	0m0.000s
> sys	0m0.249s
> 
> [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
> Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
> Acked-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---

Looks good to me, so:
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

-- 
Cheers,
Harry / Hyeonggon

