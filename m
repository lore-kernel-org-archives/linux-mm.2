Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42A7AE9A052
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 17:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 608976B0005; Thu, 19 Feb 2026 12:07:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BF886B0089; Thu, 19 Feb 2026 12:07:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497E86B008A; Thu, 19 Feb 2026 12:07:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37A7E6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 12:07:44 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E00A459931
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:07:43 +0000 (UTC)
X-FDA: 84461838006.20.3AF5461
Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010048.outbound.protection.outlook.com [40.93.198.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id 18A3F40005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:07:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lA9C9zLM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771520861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GT5gmXxg7MSOGJokwh5PJaDS620JoLGAqONa4Qox1uQ=;
	b=zb0Zv2JU7qB18el33wgSjSteoiip9Yg66klt0LFfTOdOQ0x1NqTr0W4dSc4gNXAn7KQvhk
	iLyFpxSIwHFhPnDSJ0W1OXAiAjuOUNsQ1v7An0QNTwfXBq8cuHfjDtHTDKF6IbA/ENxQYf
	Hf58ZuMcAEiEocTtvtgurSCC5wuqKgc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771520861; a=rsa-sha256;
	cv=pass;
	b=R8oj2tcRt8L9cV4pbLk3UgR0pdKRDMfKKCSQQaIb5he2MIBKdD+dtSIDay/5kB4qG04/xF
	yOFfnMX9j5zA1QjSWox/eRTaJPWGKSiMcMW6s5cr8E9TAqNfIjg2oWZeEfpxYfq6g5I9/G
	thWxtCCMmO1YKh8qBMW6ErG+PINAzfE=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=lA9C9zLM;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf11.hostedemail.com: domain of ziy@nvidia.com designates 40.93.198.48 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XYPMrIgfCdNrO+A0m8cQ5K6JP08KZGNfI9zwL6u01wo6KpWH296atOdh+3iAJALAvquHlWHFW7A/w70B1073JtEh84Bh4yMxG96oAj6RPFpqrvhaG3gLuzz/crK6HM5T1pm4GxhxVYNgCKvFL6Np34ElxZPgYBvzRRv0H5x+fNKAQA3opqts2tJYUa0ZlVPHXbHNVxY+eYeT4f92zp6FzVaYuIzj8iK92ds7+vxkrgzreOtjEdUcZfDIGHrfK88i0c+CjTGRjMD4WqO+X7bNnagca6TNTCm6fxvpX7y2u92+DJGCr77jOU4KnUp46byhix7y2L+ne+xB2ILtGCXAVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GT5gmXxg7MSOGJokwh5PJaDS620JoLGAqONa4Qox1uQ=;
 b=VmZFVLqUbdRFJJzmbbiqrCmUZhFf/YgMsL31nmnKU8YQMq60OTJbr4VUpaComTOVawtIV3J6GXGnDrOKPADpANlCYFN1ae4VuN82f6PFkgSIPvEjd6baGtk/CJU42ZurE7KdB4w0KcEmUKPDvr2DUKOpZQRxmwN8M0f2cRvEHEjaBteqKgEC+bBaQzAsDVX5iYho8PbKPCdrpfu7o2dLtbS/0thH+eOxiH8Xxh3ElrX3BUanNZtbHQdIGIjAy/TCdsek25+b+8XZHjgOcvvvVdsPR49U931CBv2fBwXHAO+bjSMv/cDNOOUIY2Ob+EwUi7V8pY0VnW7QdDkYVMjWKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GT5gmXxg7MSOGJokwh5PJaDS620JoLGAqONa4Qox1uQ=;
 b=lA9C9zLMvvX++TWHO/e1gZYIQPyYvmihWyUT0zrAkoxZeSy8c6qvkg8Mfq5GbL3YiRfYHDem7VNQwBD53o60+vaevD89WnzkG3gWT3sE9OJ0mvatuALbG7H2LugzZ2X8/t/YDrgTqymKuefLyknra6aLXnz+zIqBzu7iJWGZubF0i4CuDLj9SG1ob+j2P9dGTreuluixBTcrZfRwmaq2WuT71Qdk5BbIOWdzHx31pyqIELGzcBEE+hQyqHozQ/sSzGbgRzDwmfikrNT+fxIw3WDBhvdVxyIQkqAFdKTzKBqmIgr7qeB9GOAtLgiuh8b2DM2IEPaQ2tjZHxnBeJnzLA==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 PH7PR12MB6561.namprd12.prod.outlook.com (2603:10b6:510:213::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.15; Thu, 19 Feb
 2026 17:07:36 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9632.015; Thu, 19 Feb 2026
 17:07:36 +0000
From: Zi Yan <ziy@nvidia.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org
Subject: Re: [LSF/MM/BPF TOPIC] Towards removing CONFIG_PAGE_MAPCOUNT
Date: Thu, 19 Feb 2026 12:07:33 -0500
X-Mailer: MailMate (2.0r6290)
Message-ID: <F0B18B46-EC62-47F7-88FB-C55B0E7FAE1C@nvidia.com>
In-Reply-To: <fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org>
References: <c3bb0140-942d-49d2-bdc3-210b55435356@kernel.org>
 <fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BYAPR06CA0003.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::16) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|PH7PR12MB6561:EE_
X-MS-Office365-Filtering-Correlation-Id: 1c181db5-a789-47b4-1474-08de6fd96148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?TG9tYkljQ0taNWozTGxGcUJzalYxMytqeHNmVnBWbkgwNkRrRzJTQnZVMFZ6?=
 =?utf-8?B?QXVMVERsK0FtRXIyaklra1paY2dHWFdOU1haUUJlRlAyZUpWdHdENzg0RXZL?=
 =?utf-8?B?T21nczBDTmlmK3llaGNmKzd0R3EyQXRZU1E5Mlp5bGtwRmdraXdRTUdlekps?=
 =?utf-8?B?UWl3b0c5czE5a2txZW4xdDFvNjg2ZENSUjNMdE8vTGlBL1VJWmFkNFc4dnVp?=
 =?utf-8?B?bnoycVF6cXZZa3Y0Y3ZZU01sYXZab1N5dXRJdnpTbDByWVROV1llQU9Iayts?=
 =?utf-8?B?amFsRDA4SGRhek5HWXhmZEo0RzZqR25EdWc1dkxZZ3pxVWJVeGtkTE1lY2s0?=
 =?utf-8?B?c1BKYzIyazc4a1lpTVN2ZExFbnFBQmY4YWxQTG9EVHVvenFsTTJ2Rm1IejV1?=
 =?utf-8?B?Zngrdy8rV1JkUEtOOTM3TDh3emwzNHhoZEtlek1BMTlhVE9Ucm9vZ3Z6Rkpv?=
 =?utf-8?B?OFhEZFUxUGxRbU5HV25ZNnFwWEJPUnpOaXg2Y2xTODdtbHFCaGZ1d2syN2d2?=
 =?utf-8?B?d0ZXQzE3OVFSUWQyMjdTL1dqc1dtWXQ5eTlKcnJLMjZsTVVyVVhyNks4RlQy?=
 =?utf-8?B?TCtHTUVrTVJLbjJhU1FSVUhRaGNMMDdiRmppVFBOcGVsVTdlam42d0ZkTXNH?=
 =?utf-8?B?QkVYSmZCVDlnZWJYa2J1OUZPbHlrcHRqeVR6b2NDdXpEeCtqZHhjRWQyWWV4?=
 =?utf-8?B?NldVellBZjc0ODJQRUVYcEdaTVN1SnIvbWFZR25uV2tkRnRCSjhTcGxSdmlq?=
 =?utf-8?B?aE9FRHVpNjN0Wm5sckVDL2VSMjdRU01SZDNhT2ZkR1Z1V29CQkV0NHdBeDRG?=
 =?utf-8?B?T09qajF0U3orOEVvcEtPdjFFdm1PVTByaGdSZXFCeWVLS0x2Q3RVdWlLWGEy?=
 =?utf-8?B?eXM4VzUyOVR6TGRXT3RTTkdxUWZhdklWWFBUbmwybkFZeGUzZ2pCM0dOTGk2?=
 =?utf-8?B?RUhxVE1zZlVaSjV6UkxGV2hTcXNMaW5ETzUzNXRveXl4WTlYQW4xNXRnUXlR?=
 =?utf-8?B?U3ZGaTR4cXZFTEJ5d2k3aVZtU0JWV3dUQS9vcmdrdTdqRU5pY3IwdUxST0xx?=
 =?utf-8?B?Uk4vMjBVaGhhUklHS3BoSDVXWGg2eW01S2JiZ25TT1ZsdWNMMDVIWUlSbmpM?=
 =?utf-8?B?Wnphc0ltUHpCcXo1RnFHa3FkSVVtWW5LQ1F1YWQ0bWowU1FYUXQ3YkhTUWdJ?=
 =?utf-8?B?RnZXVjZlR1EyaHJaUnJGcFRRL2xxYmlzVVA4ZFlPcFFab3R2Q1IvcU85ZERK?=
 =?utf-8?B?bGxpamRwMElyek12WHZPbTlmckQyWGp3bkJGQThuS2w4RG8yUDhtV2twL0lS?=
 =?utf-8?B?MXdIcDRkekUyZzg0VlFjc1hCQWJUNlFoWUFMbVJuQ3BMT0xodjlDK1VkbTZI?=
 =?utf-8?B?UURYRkkzY0VETnEwUktCZlp6cXUxOHZYWmJ5Qm8vd2QzRUZaNExiZmJnYVFx?=
 =?utf-8?B?Y0l1SUgzUnk4MThwTGcwMUVDb2NyMzNUc3Uzb1A2SkhCeGNQM1VFeE45Z3R6?=
 =?utf-8?B?MEF6WGo2aWdZbmphNTZ5YUhXWVJ4SFpVaU1BNGNoTkRmK29TNnlSOHNrR0Zu?=
 =?utf-8?B?YnJTcGprdkVQQUNuNnRadUswRGNOOWhYemJhU1gyMG1ZaVJzQjJxbjF5c3U4?=
 =?utf-8?B?d1Q1WGl0SzJBdFgyU1lWVHNvUkc0d1l6R0JJYlV2cS9qZVZ1eHYrVUhacXpF?=
 =?utf-8?B?RUlSQmZteEFjZzhVR3pIQVZoUzNsNmV5OFhPckpkcHNJMnRZQ0JZNHNIbDBU?=
 =?utf-8?B?VTRKNzBGbVdCdE9YanJsdkJqbUNsYVJacUtWM2FpNEk5R2UyUWN6eWh3cTZw?=
 =?utf-8?B?WG5Kb1U5MkF6dmhaNldEdTZVNytjNHFtOEtOSUdMSXk1d214YlZOcTd4U3o3?=
 =?utf-8?B?QXUybmtEWTU5TmM1MzFBa1VTZ0RjUmtWWXVhQTg1SnIwbk5LcWdhQkcxRG9V?=
 =?utf-8?B?aWhobWxTY2ZBVTczbUVlcFVuOXRVWGdpM0tGbjVWNE1jdVI3RmFURU84MUdr?=
 =?utf-8?B?SERiWCtBb2x4YXBiSTk1ZXF5Q2gwZmIrN3RCMnpIMUFFODI3NTY1LzRQUlpS?=
 =?utf-8?B?Z3FKVnZRWm9zYTdUYS95dmlJR3h3TWJrZnQzc1JkVy94RjJnSDFYQUlrZWFu?=
 =?utf-8?Q?AVrY=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?dTVUL2JTNWtHVTZWRERJcjRoR3FkdklIRGU3Wk1NbHhUZUpVQnU0VWt6dk8v?=
 =?utf-8?B?ZGRxbzJPQ3cwTDJlaTh4bDFDc1FTN3YvTzVuc2pLdjZCOC9yV1ovM21aQ2o2?=
 =?utf-8?B?NGRBdXlEREM2Nnl0azUwdlFNTDZkZWUvRDVqUnBPTEFYYndZQVBQRUFrM2s0?=
 =?utf-8?B?eTJneWZzZS81aW1yTnpacUl3aEJiVkpiSGhKRDVYcWxxMHZVSm5scGZmc24y?=
 =?utf-8?B?UlR6RnB4RUI5Mk9UWTdCdTBQUjNPZjdmbXNYeUpheUlQU05UUXZMRTZhVWRS?=
 =?utf-8?B?Z1JjVDE1d2xRSHF4cEZOZGNWVXBCc21EbzBnVVloclhuUTFIeENUVjh4bVhL?=
 =?utf-8?B?KzhNcnZ6Qk80dlh1L0w1RmNHcW95WG1zTmRycVN0d2ttdWljbSt0UXdGekJm?=
 =?utf-8?B?czA5VU11S29SQVRuN0lkbks1VEMzME5sclhIdC85Wm1jSFNQSjJyWTRQMFpa?=
 =?utf-8?B?YkJLb1RTcFpRbmNTYnJBdS9PUW1GZjdiQTNoZFNNK2h4bHU3U0QvdU93K1Ba?=
 =?utf-8?B?MEs1RFpHR3d0a2gyYnAwVGN5RkdDVEpJREwxd0IreVN0bkl0UWFxcXpSY0px?=
 =?utf-8?B?bHZ1dkg2K1FEV0o2NUxTSGN6d3lSSDJJcnRkNjVZdGZtVVdvSzVybE1icTdr?=
 =?utf-8?B?UkFuOXRjOU5qTlFWRWw4REJyQStRSFNzVXBDMVRCeXVBaUgxZEZVa1BONE91?=
 =?utf-8?B?KzFvRHgvazRxZ25OSUxzamNUcmRQeWE0eXBjK3JIWWNSYTczUkM4dHhRUFo0?=
 =?utf-8?B?cCtyMm1NN1ZHRjQvL20yc0lGaHFPem9CMzZXUksyTnI1SDZhdUFVemJEMEpj?=
 =?utf-8?B?b2FsS3prR29yK0ZPRTNxVDNxemkvNlBGcUNWRUp2aVppNkFkSmpmVjRBNUFM?=
 =?utf-8?B?TFk0eVVhK1lETzZkcmdTYWRqK2JqdGVrVlNhTWVPTy92L3JiMmN2WFEwcU8v?=
 =?utf-8?B?RDJtYzdocStGYW11NEZ3OE11Y2NtcG1xdGVnSmRMMWNhMTdsbVpZalM0MXpZ?=
 =?utf-8?B?Y21jSkJtMVdtOUROY3V4bGJHaW52eFVLV29LT1oyb3EwU3NySml1QVNzUEdZ?=
 =?utf-8?B?T1gvRCtVMUJuNGVaOFZCZGU2anJ2bEFLTnFVdDQ4L2taaXVoQ1BUWWIweW9s?=
 =?utf-8?B?S1dxRklpVWVQWk9aNUZ3QXc5UUdjUkFKM0Jmb3A2TlZCeFBHMHFkNDFITUc1?=
 =?utf-8?B?alJPNkhXUHY2M21TeWdnY0poYVBrcW1qTHd5eXZ5SkU4UXJsdkkrSUNrZHpx?=
 =?utf-8?B?Q0Y0dGdvS0RYNHhoMlVKVzloM2xlUDlITjZNUDFMemVTLzdQVElWb3Q1RDJ2?=
 =?utf-8?B?UndHemt1Tk4yUXRDRWpxQmdOUjJDTG1WTEFjTXkwMk8vKzA4N2NReHNvWnNw?=
 =?utf-8?B?Y2JZVkJ2WjJhUVBodzRvTERjb2hCaEozMkpXWDFzdTkwaVlYUXNzYmJ3Szl3?=
 =?utf-8?B?cmxGRWhXcm42bTY1dUlCR3Z0TkwyeEFkcjNRSjdqNFg1NFp4b1E1VmkvZ0ZY?=
 =?utf-8?B?UEVXWS9mbDdNeXdQRkJ6ZkRVckpVSFhFNnBYY0N1dzNwY3c5ZEhlZ2dmbDJK?=
 =?utf-8?B?cTB0ODgyd0pvM2tFMk9IckROUFlVSnZ0UzZxOUgvZVVIV2dTV2NxeE1VNE5E?=
 =?utf-8?B?SlVCWGsyY0pRRHpqSEhSbjg0Z2JkREVXRmlWemdzajhDN3g1WXArLzEzLzl6?=
 =?utf-8?B?ZHE5QmRRWUdOYUNGRlpPTktiRkZLZ3ZKL3JmejZ3RDJwQ1VwMG13bkhuaDZa?=
 =?utf-8?B?a25yVzFNdmNJNGEzdTM3TWN4SDF0S0FxLzVmWFRoMEFnS1h1YTlTWDdoZEcx?=
 =?utf-8?B?VUxkWW1EUEVocU1BOE5ZYjkrNndobmRsUnJXMXBQbjRxMWE5QnFFanlOSWxP?=
 =?utf-8?B?N2ZmaWdtdTdiWTByUWtJeUQ5ZXF6cW1IdVlKaUhnTDlyTnZxTGJxemc0Zm0w?=
 =?utf-8?B?cXdOS1RsUld1YU02dkErWWlxRGgzUHEzcDdWQjFnZXJQQndjMXJlOVI2Z3hK?=
 =?utf-8?B?V0FoSGs2NTYzTjNwRHJrYUpRTVhnRjNXaTAwODdFNG54aE10dzk0WmQ1U1pM?=
 =?utf-8?B?TzZNMEdHUWszRVZyclVKMkR3Zjd6UWhlTDNmZGxkU0o4aFE4d1dRdjJ6bHJl?=
 =?utf-8?B?dVQzSXhZd2taY2NMcmhOV2FiOWovOTRLSFpNNXVxbDA3ZDVSNmFvc2NCZGJZ?=
 =?utf-8?B?YUZKekF4S1hPb0E0MnMxektxdW5talRjTUQzQTVHQk94VWdua3NtTzBMSllp?=
 =?utf-8?B?Q2VoYVR5aU5zcnVMajJYdUVvcG95YXV5akpuaVRRZ3k5UVB3UEdCOWJSV3pZ?=
 =?utf-8?B?T3lRV3M1Lytuck9idlA0Sk1ZaFpZNVIzVUZvV1djTlZtemxLbDhZQT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c181db5-a789-47b4-1474-08de6fd96148
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2026 17:07:36.5849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dhpc4I5wkmFsiM5HW1Fk2bXKOt8iJZUAqGVGsv1dIYQT1rJr/iUdxqgGwwgH2XMs
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6561
X-Rspamd-Server: rspam09
X-Stat-Signature: 715497f7js6y5neqeg3ag4uwhczo6bix
X-Rspamd-Queue-Id: 18A3F40005
X-Rspam-User: 
X-HE-Tag: 1771520860-690620
X-HE-Meta: U2FsdGVkX19WdvstGD7Klfp2zmGRKFCA/rD3afEpV1vosac3l5W4pgRpzkyI/pQJ+RtPV9pUMFiZfOmUNYIB1E5Z93PyY9TFUzpGOKs4ee+oUy4UVYAmSYzchrZXl+G2aI5osjC/q/Sy0bGrvo4t+NKGU8bNkYkRwqshImPa0K0OGO4KbUJMEDean3FHoQupbZIudLvYNrE62u6+Gs7/KYeq62sgB15jA6qYM97etv0lIDCxncEOLF1e+cqUQO65qzH1U4Fa/dnTQNyLkB1MGUpKxNQL/LWstQYcHbSOQpZBn+c0mK36CYGWES9hwTZhqoF5mKS9i4XpFRYg44FKdg4QK29p9WdtFiVVXcl0CYp8ix4oSob5l1OjEsPuKi7M1dOhVqztoBbkpE2KAsFAfMYMZj0yzV2aiIuFHsLK4/VSFKrRJeHdGZZ0OGfNd+IG5PdpcUr6GX8mxmrdk59J1TFGQfjm8HRhYhu6wqy30WObqNwOAjdemHX6Y4OSPRia+VGQL45mGsEeWFMvvQQXwdIjLaAbTpAPPQBka7ai9h0QI1awxg1zoM9ZHRLLxFVESxHZHSVFDcCuZ2jD5YJSCFQaxIeZZ745z1jFwCWqlSDHfDnw5n6BWictqDcitJhGfYV5ND1Z9AIhi424IdCxr0mDx7PjoIoClpa/FAQZq7rZPItO4kaWJWZBVKJmGf3gR7FZ8L8UDiUEIsvAbQjxeIGq9C5ZSJP5mvGNf1F09UkbFT6alvDC4+o64PleawVn2IUv8/1h9bLwzjDPjD6uaOee5WlA3qUEs9ZbyoncpqQMYEUIdo3KpldCOTlYoUA1b2p/L4bGtDLkoTu5Di/FVE+U2dKx7qGT4TxOSdlj5bugYdtT6Vilt02oS99yU7fpTVSRzm8SA9bfyYoOubbDfXuM8iXyUHVZUEUFbCUmsmzqsK3UIRpuvE0DlQg0WptQjZaN03Aq1wi5jFxGEUo
 ZQHrVwuP
 Bls+rDRfeF9rqbo9lF3oDo+cBzs5qR6cwJiXyVJ15Smr1HOnUhR+lYK4SLb7N/Rb/vNErbWotFjwFqb1u+GXyhoB4wEbrSEkiplGQHM83uL0N0wCEFmRj9oBtmqhWVgNuHHMd/R5839U5N8ixsvBJA6bXvKckXh4AkEGlOp4740lcYePcimoJ2yVfiJozCWExFOrFrRBwc3qBj1m6dr1GhyfcoWWek4S97ROjoaPnI8P4Qf/6klcmrvRQoaB59Oss+7PsE07qZiqBNCh6LMRilmG2DlYf98gri5JwFPiEsBJ//y7BZW4TBEAReFvPN92YTWpohph5zsMgJqa9N96Eo/Ve4p7LO9qd5BogBQkHbZxnkQiA1xbIlQwrFJMvmz6AcnoKWVMHsg26bp66LxlqEFriU2xrZkna6cYnm12z1o5mQerlITVy52wteLb5IgdgvRZlc8GIwmvasf6RRW0B6FT7KiTlHkEMeGou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17 Feb 2026, at 16:04, David Hildenbrand (Arm) wrote:

> Hi,
>
> although I like mapcounts very much, I'd rather prefer to not have mapcou=
nt work on my todo list.
>
> We now have CONFIG_NO_PAGE_MAPCOUNT in the kernel that doesn't touch any =
mapcount values of tail pages, which is great. But we still have CONFIG_PAG=
E_MAPCOUNT around, being used as default.
>
>
> To make my dream come true, some things I have in mind are still pending.=
 In particular, I want to:
>
> (a) Support mapping of folios > PMD through PMDs.
>
> (b) Get rid of CONFIG_PAGE_MAPCOUNT to stop messing with
>     page->_mapcount on tail pages and to cleanup the rmap code.
>
> (c) Better detect partially-mapped anon folios with
>     CONFIG_NO_PAGE_MAPCOUNT.
>
> + some other small things.
>
>
> I discussed some of these challenges at LSF/MM 2024 [1], before we had CO=
NFIG_NO_PAGE_MAPCOUNT. No we have it and we can discuss the next steps.
>
>
> Sorting out (a) is fairly easy once we removed CONFIG_PAGE_MAPCOUNT: we'l=
l primarily have to split folio->_entire_mapcount into folio->_pmd_mapcount=
 and folio->_pud_mapcount.

Then, for PMD sized folio, _pmd_mapcount is its =E2=80=9C_entire_mapcount=
=E2=80=9D, for
PUD sized folio, _pud_mapcount is its =E2=80=9C_entire_mapcount=E2=80=9D. F=
or mulit-PMD
or multi-PUD folio, _pmd_mapcount and _pud_mapcount are similar to
_nr_pages_mapped but with PMD_NR/PUD_NR multiplier. Maybe we would have
_pte_mapcount instead of _nr_pages_mapped?

>
> Sorting out (b) requires switching to CONFIG_NO_PAGE_MAPCOUNT first, whic=
h will imply some imprecision with large folios to:
>
> (1) Process memory stats: Pss + Uss accounting like "Pss" and "Shared_"
>     vs "Private_" in /proc/$PID/smaps and /proc/$PID/smaps_rollup
>
> (2) PM_MMAP_EXCLUSIVE flag in /proc/$PID/pagemap
>
> (3) System memory stats: "mapped" memory like "AnonPages", "Mapped"
>     and "Shmem" in /proc/meminfo
>
> And some other smaller things. While I think that all changes here should=
 be fine, I want to be a bit careful and have a discussion on how to tackle=
 it without realizing in a couple of releases that some use cases still req=
uire CONFIG_PAGE_MAPCOUNT.
>
> Sorting out (c) is a harder nut to crack, and I wonder to which degree we=
 care and whether I am being too careful. I have some ideas that I want to =
discuss. One idea is to just remove the deferred split lists and let memory=
 reclaim deal with that:

Or let a workqueue to walk rmap to check if an unmapped subpage indeed has
no mapping left and put that folio in deferred_split list. Or let the
deferred_list_scan does the rmap walk and decide whether to split the folio=
.

> but that one might be discussed in another session I'll propose around th=
e deferred split lists.
>
>
> [1] https://lwn.net/Articles/1013649/
>
> --=20
> Cheers,
>
> David


Best Regards,
Yan, Zi

