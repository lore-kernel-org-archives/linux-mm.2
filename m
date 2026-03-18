Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A203710775E7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEDC46B02BD; Wed, 18 Mar 2026 13:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC4466B02BE; Wed, 18 Mar 2026 13:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CFD6B02BF; Wed, 18 Mar 2026 13:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A6E326B02BD
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:08:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D2C31DAEA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:08:44 +0000 (UTC)
X-FDA: 84559818168.08.AA8D272
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012014.outbound.protection.outlook.com [40.107.200.14])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7DFB6A0011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:08:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="omHy/FSC";
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773853721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z+JGHJNsK1EOrjuX/u2OF4n2qUECyxguijABjVcX98U=;
	b=Jak1uRfwZ7sU70k2ADMUFDubvTRTmE7IBoA7ga06kt1KlS7QP21KDTkXz3R960+4EQ9Unm
	WL8upZJvM0W0/nZoCGz0yPOevGVwbvwk4sWAIW9KdUZ0cqqFvIyUfSfUA8ONc6SkPgZeqp
	Q0lSb5rWVB+hWG44WadaHk+GKylkcIQ=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773853721; a=rsa-sha256;
	cv=pass;
	b=G1ozm4kDrOmmgQUP2D6HAjEoE+mHSGHS63KPYW9Zu108HgmvQMpRBFhp1XI5n4QvLQtIKP
	/9tkbwNXWDUwlf+Ys6iMT/72utPiOXXtg/zyt4i8jA6Ru1LDsWjjG6Pc4c6Ybr7JeApARN
	rQq8u70P3hJcTRE3xiXRkwSElMFKg+s=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="omHy/FSC";
	spf=pass (imf15.hostedemail.com: domain of ziy@nvidia.com designates 40.107.200.14 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=llFR5ZHH9FHAbZvlfwJcVMfOVG7WRtWqG8pUpqHSFRRnJFi23pC5K6GGaYrK36aCe9kEoZznZHUE+qAPkvWB5tn7h6islbssRjrErbCb2wrPMB1RaJDx17dnbr4FtSTVvbW70MiB9fMXwDqR1/zyoPQJXA67HjP2xmWTUuPMw4CSWpH17RDYWpJdve6s0ulM7ETfUnxAw1ohwehZq19qrmu5Z6BaTNOA4M8pEW3MnIe3q+G/5mJZN9Yv83y0GGBSBlbydAaIBwKjOHQjPB/VqAeWEgtNdhBQ67568T6jKDwmxRRUvUMeOsTYLz8Pc6gfxpGfODQHIPlx3j8lprwi3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z+JGHJNsK1EOrjuX/u2OF4n2qUECyxguijABjVcX98U=;
 b=vKmx3k9TMJWQGbjazUNXt3inZTvMarVSGFvJ2gkvSja8u9SQ5LO0yW7QxpT3EEHrzHSPyCF3/dzK7ARAPwS4zYSjNqUWe9i+ejaFOPodjGg0xR6d6z1fzHLZEYrmqCx0WqakMX7t4pm5hQ+dh+xhiGweT0BdCIhhMaWV2dMg7BO4mtk2R8aYiqRBqSn+851y1quAXaDbZZ8VaivWpxs6Ug2LX8798ne5SWaoP8TKaGdXVUVeZv7oQpkOOzk11JnCJH3ZSlHzobKV190otFwfSDX8KoOKLgCM02hqQ/rehN8aF58ype2YetmugmV0sra5ywbOwJPC8pNyp54UWvXD1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z+JGHJNsK1EOrjuX/u2OF4n2qUECyxguijABjVcX98U=;
 b=omHy/FSCD8kLjWVz8w2Th8xk+UVOWx745c2pkOs9b8bho82iVaKSBSJLbdRMZj3a+N/9AaSzgC3w0PaChWv5KzBRTWzzCnJE1aknU6YU6v33nrgFdzzvz+/4rMP0K3renB8J6KhLZ7oUOWcnGzRaUFUSMP6L2OJHZxS1TN/i92MdRKKvewS+J29jsBsX6cjpUAHHpMS5WayVC4aR0LE7jcfh8xrm8cRAuOBc0JfHekGLfE7O2X82cAfQRy15+opf9gZA24gdwL87Fq7945YYv9oxCc+FhHWvFbuhQbQ3srg5G3KWD4jaZPUJke8TPc2tVeAiDka568A8B/n+DoBaWg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 CH8PR12MB9789.namprd12.prod.outlook.com (2603:10b6:610:260::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9723.19; Wed, 18 Mar
 2026 17:08:33 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::f01d:73d2:2dda:c7b2%4]) with mapi id 15.20.9723.016; Wed, 18 Mar 2026
 17:08:31 +0000
From: Zi Yan <ziy@nvidia.com>
To: =?utf-8?b?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
 Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>,
 Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 2/3] kho: fix deferred init of kho scratch
Date: Wed, 18 Mar 2026 13:08:26 -0400
X-Mailer: MailMate (2.0r6290)
Message-ID: <0D1F59C7-CA35-49C8-B341-32D8C7F4A345@nvidia.com>
In-Reply-To: <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
References: <20260317141534.815634-1-mclapinski@google.com>
 <20260317141534.815634-3-mclapinski@google.com>
 <AD9E1B18-C813-480E-894C-FEEB51EE8A93@nvidia.com>
 <CAAi7L5dSOxXETv-bYs4hJ1SfixMBQXS4fmfKs3SzVvQ=yY7oSg@mail.gmail.com>
 <76559EF5-8740-4691-8776-0ADD1CCBF2A4@nvidia.com>
 <CAAi7L5ex+66qgFzRkLDbuOmC=cVrMyBctPZv6wd15n1rc2U9KQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY3PR05CA0028.namprd05.prod.outlook.com
 (2603:10b6:a03:254::33) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|CH8PR12MB9789:EE_
X-MS-Office365-Filtering-Correlation-Id: 4999e8f2-34cb-4db7-c9ed-08de8510fb61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|7416014|376014|366016|7053199007|56012099003|18002099003|22082099003;
X-Microsoft-Antispam-Message-Info:
	Y0cOfsRjvpnjGqRniRaTrHhB2vxz3Oh9qWF11YyHMge9nQRZRDD9WTYNJhtxSbB8EmjwOvXnh/g5utKw1GESaxnvaDMi9P/jNTSbWVF1w73GtNjLee+v0ymAD2wK2PTupLQlsFy+qMnGWjY4lotFNfqXjcKmHccvrZMHn5jF9jkGTTok8d+vLNwwq4zQ4KyXFL3avH+bOVck+VQySzyq5yyPXOkThQvIazTQPsW86RjLi764ebDqihY2h8SpY3sv0sar88beZP7EaXbvFjUxAqLonX+afndVAA/h4H7ofCgkp4hOuQC3nTr6YuUrSGfWCLH3vIVMlyYo3hZOCvA9LlO9NYM436Yqra1QidYYNhuE69cfptPYnbtd0ab1qT5nXDmZf0OgeY5+SIYR+5djfmEjNJeiEdIxqSX25uxBtQ4JVOMEOTd2uRAHZShL0MgBzmhDK3iX2iMugQXW/OlaidKL7LIb0lW2+fg9LuSwsdV437Oz5OqlRr4J8W6FNfTMTXc9PoXbZloRoDJyOskjZMvGeM5O5ksh9CKCx5L7edKLp51A8DcktSrdSBXmVzzDhyFqZARveh5N3z+yyTwK94Mg3OCxXO1k6zQJi45P24Hriyl6qi6e2LFiRXgaHdx87uUUWxI1jhZ8tMr8y5sjlGMAr8gWqaEITKFsWlc8WXvnfgURWUe3N1AXuinfO65K/n6UrYO13Z8mo8xyQb0aPyxlM9znNFSgKnCxa7BciJM=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(7053199007)(56012099003)(18002099003)(22082099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OUF4cVI3Q0kxNXo5c3NpU2NrZ3JCRDFIdW1rZ29JTTErSlJTMHY3dXJoTlRs?=
 =?utf-8?B?SndnMVZkTmlibWZQRXZyUTZMVjFYeWRUS0l1SlNSNHNKa3gxQmJQSWJsdjBM?=
 =?utf-8?B?VkpyR0dhVG9ueFRwZi9PK1JDNlZ5cjhBYnhEOVNmdi9TTDlFbkRNUzRENGw2?=
 =?utf-8?B?emd1UFhTbkd0Z05zRUdMZU5nOVRsZ2JpL0Jpa0VRV2xYUk40V3RBZ0FxeU1C?=
 =?utf-8?B?N3NLTGRpSDY1a2RVWHJYeHdNNGdERGd5djhJbHhYUm1ZZmpETzlVR0tubFZn?=
 =?utf-8?B?M2xEeEYzMEhpa0FGYnlGcHFGMy8wRzBqSWpER0JnWjUyL08wRTRpc0lTUDFQ?=
 =?utf-8?B?UHplK1NNSEx1SjA3N01RZW1SeCtCODdLSXRiMGl6SHVtenpEMEZSZ0drVXFB?=
 =?utf-8?B?Si9ZaXFBYzRXS0dLMDZLUmp6N1d2RGplSHIxYzhDWVhlNWliSGNnMG54aEJH?=
 =?utf-8?B?c2hPMkJkTzc3WFJqajJDb3BFQ1lpQnVCVi9aaWxGVmNTT21uUzNmV1pnZFhs?=
 =?utf-8?B?dFlJSlVUcXVqbnhUajluTU42dUlTcXNiMVpJMnJCbjNxM3Rmd3BhM0Nrcnd5?=
 =?utf-8?B?NHo2dUU1QzBLenBZV21ic0NGWXpYSm9SN1VHL0hKSUkxekVLcTJqaUFWVVY3?=
 =?utf-8?B?bFFpcEZyMHdZcmw1UGNIU2w4ZmdEWmNlc2JxVjVmMDluOUE5ZDZST1JJcU9y?=
 =?utf-8?B?MXluUkk0YWZwMTRkdDUrOXNnWlFMa2VUM3krMlV2RTZCN3cvTTBHRHcxQWZR?=
 =?utf-8?B?VEk3MXpBYmg1OVo3WWVlU2xCRmF0enNuZXJMekdHREhiOWFaSWpKR1NKS1BO?=
 =?utf-8?B?Q1Q4bVFMN1J3eHJQS1hUcFVhOTkwTjNxUGlPSDRLU0FNTWpHMitacXdUV0Rk?=
 =?utf-8?B?ZkZiY2RPanhRajNUY1BoSGZjajUyREJ5RUhNZnpvY2cyVVdxV1ZmazFRYUg5?=
 =?utf-8?B?NUtvZGoxR2R6bVpyakhCdHgzOThnVzFzTHdGZllWcjJLWk1mS25ncjBCRVg2?=
 =?utf-8?B?eDJIL2E5N0ZTL1JlNkgwek5qb2szU01wTzFUaCt3SSs0elpVWFlTUjU0UlV6?=
 =?utf-8?B?OURMQWR1RDRsOS9VR3JRdzBTeGFiVFF6STNmSWRXRHd0cUxYeDcyL0NaMFdm?=
 =?utf-8?B?NmhkeGV0aC96YkpqaUwveUN2Z0xnNmt1VmpHNVRyZ0JieWFkL3R0SFJFcDdX?=
 =?utf-8?B?bkRqY2NUUlVoem5LbkdqWUY5RE5XbVl2SVBDWlIrWEJmaVpHSDdwWE40VDRI?=
 =?utf-8?B?M2x2SEdkYkpjNUVrTlIyc2xPV3h6aW9TOFJmUXpRV1RHR25QSzhYRS91SGFH?=
 =?utf-8?B?Yyt4dmFvditDelMwQ0FCcStKb25LRzh5azFqY1JzUnJVZ2h2WFdOd1p1NnU2?=
 =?utf-8?B?RGpndVF5enp5b2MzWkVoRVpRYVFYZVZDWjl2WUFkM2VpUXpoZ1JoSEdGUWtE?=
 =?utf-8?B?R1N1TTRnS3M2THhuelpUNFAwOWk0VEZaY2JRcEJ1QjRHekh3aElhMEhqYW4x?=
 =?utf-8?B?eFBUM3A4SmtZbEk2NTdOdTQ4MllZYzNHYjE5elp3Q0RCMWR4OTNlRVlRYzYw?=
 =?utf-8?B?akhhZCt5RW1HRExwVnJTMmk5VlhGQUI1Rk1iTzZZOExFckIyRVYwVUxEeXdX?=
 =?utf-8?B?b05kK0h2K2NrcTZxbHNNQ2VreUtrcUJreWI4NUJaUzE1UE1ORUxuSlRIV1Bq?=
 =?utf-8?B?S2tXdUN1SW5ZcmdhRC92MmM1OWcyZkdvRFM1QUdGbjRUQ2hKSEUrbFlyWFpC?=
 =?utf-8?B?S28rc0tUeUlPQVpoNUg0cnVPQmJ6Sm5DekhlKzVkbExtbGpvbjN4WVF3ZkNC?=
 =?utf-8?B?bGRSbjB3RVFpOHZlMnVjWStQaVV6KzdITGlTdm5TMGw2dVgwRURjcXpUV09N?=
 =?utf-8?B?eklrb1FYOGZBbTQ3dDNmSjc5RFZKcXowM3BVM1Z5UTlyOTY2L0tYYXJJTjJQ?=
 =?utf-8?B?S1lmVWxadVVqOGRqRnZxdDBFb1JDS0Nvbk9MdTBnNmtSeXBrT3V0aC9RdHZj?=
 =?utf-8?B?WTI5WTBTaGR0dm52WGxtMDduWEdlMXY0anNUNmZhSUJzUlZOWVpjM3BrT3kw?=
 =?utf-8?B?WGpsc01vZWlLMlV0ekEveWxqQmFISFlWOCtPUnY1ZGNocVNERVJPRHB3SVRq?=
 =?utf-8?B?Q3RtUzZraGJWa0Q4a2t0UGN0SVBKTkRHNXhzVVMvY3lwMUY0S3IrK29YcGNW?=
 =?utf-8?B?dUZ4QWFzQWxjRTZSNXc3VSs2ZmNZZGNwZTlMdzQwV0JZdkN2cEE4OXpqdEEv?=
 =?utf-8?B?bk9CcjBScE80c0RuQlg0bTd1SHhyVGRremNpamN5S3pkQk4yU1lpczdzTUhj?=
 =?utf-8?Q?3YmimAuJUVTwpLIR5b?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4999e8f2-34cb-4db7-c9ed-08de8510fb61
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2026 17:08:31.8594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: F2h7qgw2VnyTi63YntRf1m122/zclZodmQ6ZtKDaYv4pKmIcj0fQ6N9qijjU/S1i
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH8PR12MB9789
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7DFB6A0011
X-Stat-Signature: mgaaqnhmfnbfn5s6oey7x7z79mdwnb6i
X-HE-Tag: 1773853721-980303
X-HE-Meta: U2FsdGVkX1+4h6l6VA0Zwp4strzYtSQ5Df/rim3mTEePPKrVaRiSjALJC3bD6TAYeXaQdXTwpXfyfjEVFPSgJZ+yPD40IX9UpTUUel0y4UWUWSbyzc+nNhRgaCELuHU+K7wQ5jIqBeWVGQucsbU1mdFAisEug0IVCEvy0JiE6X9EO1SH45i5mdMLZePJxDZpzeXHLwyiDOp5zPa3H8h31/5ClLwpPpXkogVld5rJ/yNuHUCdYbrWifiVkdsj7oMybxwQh7jDj8FCHvzXjkIDXIKcDxemQ8qZEnBZtl7qOVGLSOgCn0zANqU0UdxP3HQSKLU+DQtnAvbHqJ7jN+L7HZIiA0/JI/NhgEHS8ZFFLD6ehvMH3lZ+Ly510sanxuDrLdWZNqw0822eOg2AK3fDlmZxdxOeP0ESyDq2yYd2XKG/YYKL95cHPZ4gL8r86gOYoBlefURzCQCZKz2rN+2w7Ha2i7LwBam1Lvbt6BLyjDlzL+TkYhwi5cA0vRjoalKbwFPTYEZBDTNA6mgehP6MmZpar8Ajpi2YlQKk6MToYnctKzNlUaUaXtmEjVDIA64OEavN0RMhVhaQwYJI7Wj9ZYC1Z8RBgyhc968IDri2rfdsf3QImUWQpTXghyi4ytDH/ldgKRwzNdw71PjnbVkJC0FsX0dOzo1zkRrsmn6olNFdADCFgkjmQ1GBH3ZtHWq5K7LJ4K8WSkc1RpeoOmoc23QZWiF7wCMaTvaGPJtFMyFaFczzq4hCKLKes93NX35n56mb0MU22KmzzHtQVKh39cd/Si/Wj3pkOteZBrtTF1eXI6xhS9dkZw25kEd7yMCST58RWiLTWg8OGpHF0LdHrOQM7TEfFghipCKv90FKVNVITwaf7ltusm/pfJnx6abRRf5dt3Qydpm2epan7R++gr+aZPKq96jtuJLcLGbz+YMmDYZ8eECveR8lUiVav+GnFFwWPL2WNxT2ITD/QaZ
 Rbmgtz8D
 x0g+TkON1qrqO6iwvAU8o/9Ef/NeUHozYiVqkpZ7Hc7DXTaMkTOxTAk7GoZzxckW1Dkd7aQJ4+R4hcH7F2mKSuVCtBpVs1Vf+0qb6FXZW1NpIoVNmkThpuXswMogqZn7eDLi+1Nf61XthYgRHPuEjlLA7O5kbaaHHTXytOmgjds0bvYPiAaeQFbA7qIl2fcNvC+h0+LQctBbH0sEjqwu18TCUDlCy+6NWritcXLYmEevyokiyc6cVaCA1EOwUPFdNJW8tKv3IQ6P2CkfDZk28pANXRg8HpDO+5JLQ06tfl6ebjd1XP/i2PmfhDEPbhA4tuAngYPdTx2X8HChaFsigXwOwQUpTQ9txiKc6nME9ldBUyAIHnqK2s0rVxBzfE4pkWjBiJB0V1x8c7l+GP7u2BuWRJ34+35KcWdCXFFTt9crBr3gDJ8775+soExTUPbQFMhHu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18 Mar 2026, at 11:45, Michał Cłapiński wrote:

> On Wed, Mar 18, 2026 at 4:26 PM Zi Yan <ziy@nvidia.com> wrote:
>>
>> On 18 Mar 2026, at 11:18, Michał Cłapiński wrote:
>>
>>> On Wed, Mar 18, 2026 at 4:10 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>
>>>> On 17 Mar 2026, at 10:15, Michal Clapinski wrote:
>>>>
>>>>> Currently, if DEFERRED is enabled, kho_release_scratch will initialize
>>>>> the struct pages and set migratetype of kho scratch. Unless the whole
>>>>> scratch fit below first_deferred_pfn, some of that will be overwritten
>>>>> either by deferred_init_pages or memmap_init_reserved_pages.
>>>>>
>>>>> To fix it, I modified kho_release_scratch to only set the migratetype
>>>>> on already initialized pages. Then, modified init_pageblock_migratetype
>>>>> to set the migratetype to CMA if the page is located inside scratch.
>>>>>
>>>>> Signed-off-by: Michal Clapinski <mclapinski@google.com>
>>>>> ---
>>>>>  include/linux/memblock.h           |  2 --
>>>>>  kernel/liveupdate/kexec_handover.c | 10 ++++++----
>>>>>  mm/memblock.c                      | 22 ----------------------
>>>>>  mm/page_alloc.c                    |  7 +++++++
>>>>>  4 files changed, 13 insertions(+), 28 deletions(-)
>>>>>
>>>>
>>>> <snip>
>>>>
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index ee81f5c67c18..5ca078dde61d 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -55,6 +55,7 @@
>>>>>  #include <linux/cacheinfo.h>
>>>>>  #include <linux/pgalloc_tag.h>
>>>>>  #include <linux/mmzone_lock.h>
>>>>> +#include <linux/kexec_handover.h>
>>>>>  #include <asm/div64.h>
>>>>>  #include "internal.h"
>>>>>  #include "shuffle.h"
>>>>> @@ -549,6 +550,12 @@ void __meminit init_pageblock_migratetype(struct page *page,
>>>>>                    migratetype < MIGRATE_PCPTYPES))
>>>>>               migratetype = MIGRATE_UNMOVABLE;
>>>>>
>>>>> +     /*
>>>>> +      * Mark KHO scratch as CMA so no unmovable allocations are made there.
>>>>> +      */
>>>>> +     if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
>>>>> +             migratetype = MIGRATE_CMA;
>>>>> +
>>>>
>>>> If this is only for deferred init code, why not put it in deferred_free_pages()?
>>>> Otherwise, all init_pageblock_migratetype() callers need to pay the penalty
>>>> of traversing kho_scratch array.
>>>
>>> Because reserve_bootmem_region() doesn't call deferred_free_pages().
>>> So I would also have to modify it.
>>>
>>> And the early initialization won't pay the penalty of traversing the
>>> kho_scratch array, since then kho_scratch is NULL.
>>
>> How about hugetlb_bootmem_init_migratetype(), init_cma_pageblock(),
>> init_cma_reserved_pageblock(), __init_page_from_nid(), memmap_init_range(),
>> __init_zone_device_page()?
>>
>> 1. are they having any PFN range overlapping with kho?
>> 2. is kho_scratch NULL for them?
>>
>> 1 tells us whether putting code in init_pageblock_migratetype() could save
>> the hassle of changing all above locations.
>> 2 tells us how many callers are affected by traversing kho_scratch.
>
> I could try answering those questions but
>
> 1. I'm new to this and I'm not sure how correct the answers will be.
>
> 2. If you're not using CONFIG_KEXEC_HANDOVER, the performance penalty
> will be zero.
> If you are using it, currently you have to disable
> CONFIG_DEFERRED_STRUCT_PAGE_INIT and the performance hit from this is
> far, far greater. This solution saves 0.5s on my setup (100GB of
> memory). We can always improve the performance further in the future.
>

OK, I asked Claude for help and the answer is that not all callers of
init_pageblock_migratetype() touch kho scratch memory regions. Basically,
you only need to perform the kho_scratch_overlap() check in
__init_page_from_nid() to achieve the same end result.


The below is the analysis from Claude.
Based on my understanding,
1. memmap_init_range() is done before kho_memory_init(), so it does not need
the check.

2. __init_zone_device_page() is not relevant.

3. init_cma_reserved_pageblock() / init_cma_pageblock() are already set
to MIGRATE_CMA.

4. hugetlb is not used by kho scratch, so also does not need the check.

5. kho_release_scratch() already takes care of it.

The remaining memblock_free_pages() needs a check, but I am not 100%.


# kho_scratch_overlap() in init_pageblock_migratetype() — scope analysis

## Context

Commit a7700b3c6779 ("kho: fix deferred init of kho scratch") added a
kho_scratch_overlap() call inside init_pageblock_migratetype() in
mm/page_alloc.c:

```c
if (unlikely(kho_scratch_overlap(page_to_phys(page), PAGE_SIZE)))
    migratetype = MIGRATE_CMA;
```

kho_scratch_overlap() does a NULL check followed by a loop over the
kho_scratch array. For non-KHO boots (kho_scratch == NULL) the cost is
a single NULL load and branch. For KHO boots the loop runs on every call
to init_pageblock_migratetype().

## Question

Does this add overhead for callers whose memory range cannot overlap
with scratch? Can the check be moved to the caller side?

## Call site analysis

init_pageblock_migratetype() has nine call sites. The init call ordering
relevant to scratch is:

```
setup_arch()
  zone_sizes_init() -> free_area_init() -> memmap_init_range()   [1]

mm_init_free_all() / start_kernel():
  kho_memory_init() -> kho_release_scratch()                     [2]
  memblock_free_all()
    free_low_memory_core_early()
      memmap_init_reserved_pages()
        reserve_bootmem_region() -> __init_deferred_page()
          -> __init_page_from_nid()                              [3]
  deferred init kthreads -> __init_page_from_nid()               [4]
```

### Per call site

**mm/mm_init.c — __init_page_from_nid() (deferred init)**

Called for every deferred pfn (>= first_deferred_pfn). Scratch pages
in the deferred range are not touched by kho_release_scratch() (new
code clips end_pfn to first_deferred_pfn) and not touched by
memmap_init_range() (stops at first_deferred_pfn). This path sets
MIGRATE_MOVABLE on deferred scratch pageblocks after
kho_release_scratch() has already run.

**Needs the fix: yes.**

Both sub-paths that reach this function for deferred scratch pages:
- deferred init kthreads [4]
- reserve_bootmem_region() -> __init_deferred_page() [3]
  (early_page_initialised() returns early for non-deferred pfns, so
  __init_page_from_nid() is only reached for deferred pfns here too)

**mm/mm_init.c — memmap_init_range()**

Runs during setup_arch() [1], before kho_memory_init() [2]. Sets
MIGRATE_MOVABLE on scratch pageblocks, but kho_release_scratch() runs
afterward and correctly overrides to MIGRATE_CMA for non-deferred
scratch. For deferred scratch, memmap_init_range() stops at
first_deferred_pfn and never processes them.

**Needs the fix: no.**

**mm/mm_init.c — __init_zone_device_page()**

ZONE_DEVICE path only. Scratch is normal RAM, not ZONE_DEVICE.

**Needs the fix: no.**

**mm/mm_init.c — memblock_free_pages() (lines ~2012 and ~2023)**

Called by memblock_free_all() for free (non-reserved) memblock regions.
Scratch is memblock-reserved and released through the CMA path, not
through memblock_free_all().

**Needs the fix: no.**

**mm/mm_init.c — init_cma_reserved_pageblock() / init_cma_pageblock()**

Both already pass MIGRATE_CMA. The kho_scratch_overlap() check would
be redundant even if scratch reaches these paths.

**Needs the fix: no (redundant).**

**mm/hugetlb.c — __prep_compound_gigantic_folio()**

Gigantic hugepage setup. Scratch regions are not used for gigantic
hugepages.

**Needs the fix: no.**

**kernel/liveupdate/kexec_handover.c — kho_release_scratch()**

Already passes MIGRATE_CMA. Additionally, kho_scratch is NULL at the
point kho_release_scratch() runs (kho_memory_init() sets kho_scratch
only after kho_release_scratch() returns), so kho_scratch_overlap()
would return false regardless.

**Needs the fix: no.**

## Conclusion

The only path that actually requires the MIGRATE_CMA override is
__init_page_from_nid(). All problematic sub-paths (deferred init
kthreads and reserve_bootmem_region()) converge there.

The check could be moved to __init_page_from_nid() to keep the
KHO-specific concern out of the generic init_pageblock_migratetype():

```c
/* mm/mm_init.c: __init_page_from_nid() */
if (pageblock_aligned(pfn)) {
    enum migratetype mt = MIGRATE_MOVABLE;
    if (kho_scratch_overlap(PFN_PHYS(pfn), PAGE_SIZE))
        mt = MIGRATE_CMA;
    init_pageblock_migratetype(pfn_to_page(pfn), mt, false);
}
```

__init_page_from_nid() is only compiled under CONFIG_DEFERRED_STRUCT_PAGE_INIT,
which is the only configuration where the bug can occur, so the
kho_scratch_overlap() call would be naturally gated by that config.



Best Regards,
Yan, Zi

