Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1C28C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4696B007B; Wed,  5 Aug 2026 12:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65636B0088; Wed,  5 Aug 2026 12:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D5F6B008A; Wed,  5 Aug 2026 12:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6AB6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:47:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1DCA31C0EB4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:47:01 +0000 (UTC)
X-FDA: 85067795442.11.FD6B92C
Received: from DM1PR04CU001.outbound.protection.outlook.com (mail-centralusazon11010021.outbound.protection.outlook.com [52.101.61.21])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4880880008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:46:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dTzYKaHC;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785948418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/k+7yw9+y6XNAEhoZ3OlSQsIbO/zu0CnhzQboBCJn7Y=;
	b=EZ2LHVuCLFlCvhSBRYixRUHOPgzgZVQWi3xpSO4l7t99mJNwMsK1JVDideGRsP50UxRpks
	CbkT6CZxNPZkVFLMJ02sGrHfsVFmNUhaVRuKdEs/97yNhj9f361n0rSU9HQXsLDfq7D013
	fD20/Yg4kwHM/LEHW7pCmcYvucDgWWY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785948418;
	b=bRlWJuppK3I0arB3EtZxt3Ml2kKhYOtEJIzwzSayA7CWK8npjuT/zSXYVvwaY+ZH40ZEZk
	ZU+0kRQSaZjL80p69yS8K16/TyC4NieXIXRyx/YyaTGVXQpG25ffng1xKBjHtqiYC/Ef9V
	qvu0hBqaaZNVqUb7blMza9NmwigDNh8=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b=dTzYKaHC;
	spf=pass (imf30.hostedemail.com: domain of ziy@nvidia.com designates 52.101.61.21 as permitted sender) smtp.mailfrom=ziy@nvidia.com;
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bg8cIIedsuucSjpygVIaYe/fOcDLMGB0bKarElRdfxg42euhFjt2EFOTiYQPjsoNTnHojP+XEaozPQHeQsbtlTQaqhlrYfw5ApeIApdLkFpmltsAq8Blg7GoHLKGhDcrNhO40R1DQhIjm/KOsFIhyUfkb0R1YPcu/UxJE0K0E/2dxD2NeOpYIIPEctZmyggp2jr3VGZzE4CN/dD4Auh2UXD65D2sHWyH2m+sDzoj1IEh8/Fb0IWWQgTf5HcCAegTtQ8IuTorfRgc+bba8dWTgIuXueuU90Bk2c0kSsZJJtfzi0FuuE8lBnUTktFrTEcNVlCieqUEjGhMIV+Un4W4eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/k+7yw9+y6XNAEhoZ3OlSQsIbO/zu0CnhzQboBCJn7Y=;
 b=ZJrEnmKIzc9PrQZTP172f+3uWELoffGHrPH5A4X47G9Zn3EKXrDZIar9PqyiiulMvXyHTbhkkysdSVZ1Ll96ZIlTQbF7YgdgDsYzWC1EoHRIxjvggB1x4WdQG4HA+e2YRLv2r/20iozIevXY+Lr1BhYGVXeNnxnyjNEO3FXXcKYUpaijbZvASCVlJ9g4H7Zfh079g24UwlQH4Ok952c8d/K4Ms+9mF6ajr5aGIdELLL+cSWbHtdR6PsJkhMfvvpKkJ2fzlwugaBHiyuxGpjgLFc0Zq5/fis4qUzCI8EVB0/HciKfFxqXQrV+fK6pcD0akeVZKbT7fJVAuM38XGSpAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/k+7yw9+y6XNAEhoZ3OlSQsIbO/zu0CnhzQboBCJn7Y=;
 b=dTzYKaHCgmZFI6aot2d3TBuf8HCElOvuxPG/2KRwcqfzGSnCQheR9o3tfE5t9asv2tYNALh+nYLt7TvkRVN1dQBGiuL30LEjwnSkhW/oGPZ5ozn1VytRCqUNZaUoSJTAe02xMKpgTbyOtv8wJ+FkaibY5O2XEJjL/tL5od8WpDyv9alitq1f6C+C/hQoLPnCq7g06+F18ORXiRj4oz5jD8R1ctYm9gp72nd4mBBra1VxTFK6xKwFoRbnafxy0bWmisnc1+YyJo+WsoUAbjxZsoPYJFXj5pY49P9XiFvpdtO7u+gwlNMHDeWQJ3xKmZDkhvSeFGlQOlWTBzbdB0HZnw==
Received: from IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
 by CY5PR12MB6348.namprd12.prod.outlook.com (2603:10b6:930:f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.270.18; Wed, 5 Aug
 2026 16:46:49 +0000
Received: from IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16]) by IA0PR12MB8374.namprd12.prod.outlook.com
 ([fe80::d85f:4c87:ae84:3f16%5]) with mapi id 15.21.0292.018; Wed, 5 Aug 2026
 16:46:46 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 05 Aug 2026 12:46:44 -0400
Message-Id: <DKH5VECNN2LF.M3RGFY0NORWI@nvidia.com>
To: "Baolin Wang" <baolin.wang@linux.alibaba.com>,
 <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>
From: "Zi Yan" <ziy@nvidia.com>
Subject: Re: [PATCH v2 4/4] selftests: mm: add mTHP collapse test cases
Cc: <liam@infradead.org>, <nico.pache@linux.dev>, <dev.jain@arm.com>,
 <ryan.roberts@arm.com>, <baohua@kernel.org>, <lance.yang@linux.dev>,
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
In-Reply-To: <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
X-ClientProxiedBy: DS7PR06CA0011.namprd06.prod.outlook.com (2603:10b6:8:2a::6)
 To IA0PR12MB8374.namprd12.prod.outlook.com (2603:10b6:208:40e::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB8374:EE_|CY5PR12MB6348:EE_
X-MS-Office365-Filtering-Correlation-Id: 4affd8b3-45fa-4c64-8f70-08def31122fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|23010399003|7416014|366016|1800799024|6133799003|10067099003|56012099006|11063799006|4143699003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	zV3jNgl7l3qVTcFZFnYNGfkLaQgQhpTe8uimIi0u1kTsTVfAc07+iMvKZ5t1dcXkuNZJSG/0E9QV8ZoFhIoIEB/HrPTV6LTGwIWhtJODuFRdP9mS4aCdK1c2uIUTD1vRxLMVMtiWTfwgTZHtTQjsVp6s5SVNl0hwqKxRHB/I3LyXq1fbXu1FuTcUhtcQ/TwnmKaz2/KPTaJTUlZxM+mdTW5TbH49f8diW/T6jUN3R3bU+bEWseZd/07d6JOefS2At0AIU2mq43IGItT+zUgplAlB6B3GCvQ4LYK9wnfmXkMMvWC4fbjtaVFI57FDhHxYzJ25vFPBq8qtemeYzrw3/OdI5NZ+BmK8aHvQeeleiqvgLUpj+60L9sg1szKoDixxlngie52xUKK4N/TdW5IBIP8ePi4apJUZFT2AjXB4GzO9Ncw6uOTNCogkTNJZTiTgH+hJUxNUL7ycaYqKp97960Sy90pm/7/8bCzkfgtSCI9jwFRUh0z79numAKUlg5x+Hlh3VoAcsnGFiu2yu8WqpfUv6iHxg8qGgu/okXjoZWfrIWhCK3M+yDBa8vxx0r8NQ6ze+W75sG5TuJasPF9C5uzPXYV1c0RnII+2MiAnnEAIt/P173Zoy/TFguoG5kyUXjV7pAtNRnWMTU+aixOK/i+Fc503StNNzC1NZfQ/VIA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB8374.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(7416014)(366016)(1800799024)(6133799003)(10067099003)(56012099006)(11063799006)(4143699003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?RmhYZVpPRFlqYjh5TmxzTnpaRmk1bXdxZ01wRzEyVkhPZ3Z5cnkrY0toMjcv?=
 =?utf-8?B?NW5qa0c1L1VkM3U0ZDhaZ0lwVUttVFowUVViWE85ZDNtY0xxT1dXSnpXOEdB?=
 =?utf-8?B?N1JxbWkxeFlUWTlGekFzTTFDWDJkY0NVeU1YcFpjblRwajZvZXhrcXJzS3Iz?=
 =?utf-8?B?VS9kMUR2cmtJcC8wUEVaeVpMaE9HeFVzZHdZTS9ZV2hUTXRjZlFPbGNERGlV?=
 =?utf-8?B?T3E5NEdCOW9YcjBlL2ErTGw4OUdtK2I5dGluOGw0S3ZIZlE1Wm42VjArM3RK?=
 =?utf-8?B?MUs4TVNlQXp6NTZ3MkJ6clN6U0hlUG9ETjhoWlFOc2laZ2Q4c1pySk9sYnpu?=
 =?utf-8?B?L3I2TXVyRWIzcDJPY2xEcWZVMktET05MRk9iT1ZZaUJrUVRvdkJhc3ZROTI4?=
 =?utf-8?B?T1ltOSt2VTQrY2FVeU45QU5ZM3ZjSlBEcXdwQy9EdEpQbC9Wbk02UnNXZm5y?=
 =?utf-8?B?eGlOVmZNYVd1TitRekFaOGk0a0x0M1RUSkRrRjRjdmpzdi9RNVRTMGxNZHJs?=
 =?utf-8?B?U3ZhNTRHeHpYMzlZZ0ZxdFFVdXZyUVRsZjNNUlkrN2xPN1BId3J0eFF3NVRW?=
 =?utf-8?B?TFdHY0Y4REE4Q05BYWIxQWkzVnB4YjJ6VWxJd3BWam10WHp6UlNQQWxlZjZk?=
 =?utf-8?B?L3VPdU9sYXhSWXU5UG9JWmpOaGtPbjcvbkkyMFc2MWw1VmIzOFB1ZlZreElP?=
 =?utf-8?B?QkJIcVBPQjVzdE5ORzc2VDdxRGxJS1IxMktnUnk5WkEvRktQZk5hVzV2eFov?=
 =?utf-8?B?SWlBWTBMSHNPSXdjNU5tRXBtOStyRnhWblJVVkh2WnZ0VldFUmkrM1NRT3pj?=
 =?utf-8?B?Wkdsbi9SamJpMW5EN1hGeVZXcEN5TTJPZE55MmQ3MHAwWmJHbVl5dTJYY3dH?=
 =?utf-8?B?WVFSVmx0TDZtWTREU1l6YlVOVkR4aUxMdGJCcU1uaFhaV1hyMjRNSFJObzQ4?=
 =?utf-8?B?di9oUnl0bVBYSG5iOUZLYkpMOFB5aThPVGd4dVM0OUt4cVZwWnp1TXdjdk5o?=
 =?utf-8?B?bnhBelZjRnZOYUJORjBNZ2NJZGxKaHNkTmwvQWNDS2FYcktRL2FUTmxNVWp3?=
 =?utf-8?B?a1pqRGxvdDQzRHk4dU9MTlhDZTVOTDUxRGplYmpzQWVQTlQrQVJFbnBTWWh1?=
 =?utf-8?B?a21BeHBtYWprbFhVY0gyc2VXcy9rdGY5UlZnUzZVZFJrcVRIc2Y1Q082bUNM?=
 =?utf-8?B?cXhCT2tEQjJHOGNlSjc5ajByWFBhVFJKaWpLTlNFaWVJN0pMUStJdGdMVWNh?=
 =?utf-8?B?cmxHS2thYnhGNkVxY0NlUUJXYjhVOHlINm5oSnRrMEdXRlVzL1RaY1h5NjZ6?=
 =?utf-8?B?NjhMS1FUMGQzUjNqMGFMRDg5Y0UyNituNTdqRTlxY0hXVDkxR1IrV1VCM1Ju?=
 =?utf-8?B?a0pLL21OemlvSVFpdTI1S285ditSV1h3My9OR05MUVZwRmJYN28yRHVOM2lt?=
 =?utf-8?B?TGpLNDNlRDVESGtGbTMvbW5LN0R2ZlRjN3Q4N3NQQ2h4c285bDFSWkZadkQ4?=
 =?utf-8?B?MjRCSVNvc0ticGxTUnVrcGhqazJDUWFDZDJHc3JsT0E2TzRqLzY0Z0NsQ1Jm?=
 =?utf-8?B?aktTZjBZcXdZZ2sxdWl4b0lDazFIMm9mODZ6Q20reDIzWkNnR0lTT0JnUVpH?=
 =?utf-8?B?U0h5ZGV6Z3VyWUZad0JOL3BDR3lVY1ZGTEp1Sm90NnhvaVlGTGVhaUNTZ215?=
 =?utf-8?B?TXFDRGY3c3hDQTNiLytKNlZlQUNudEFKbUx5cVo0ZnNsUlhKM2ZQR2FlbDNM?=
 =?utf-8?B?amdNUW9yLzhIbXRxS0RyclR2b29lZmMvMlpKMjVheXFGYnlmd3I1cHh3UmpI?=
 =?utf-8?B?TVRTOUtJU2YyR0VoeEpqejgwQUw3R0dKaTY3UUdiUkpKbUducWpsalFCV0VP?=
 =?utf-8?B?S3BTQmlZV0JJcjNld0JTVjJxbkVzTUE2cmYrK29SMmY3YVNXSHJLRmpQSWc5?=
 =?utf-8?B?aXJBM0JOQmw5Y1JuMUZ3U2ljMjF5THd2aTdMZEJ5Wm9aUm1zUjdaYjRlNUZx?=
 =?utf-8?B?NlVFeVIzanFrQWRtV1ZBdlpDeHcxbVM1eWh6blA5OS9nK2IyVGRuWkx0czhC?=
 =?utf-8?B?Uk9RUllpbWRKSlRRbmNOazZYM1k2cVFKaEtRZEttVWpnYXErRW5VODcrMy9D?=
 =?utf-8?B?TXo1aUV2eHdBa0hwMDQzbktMamFrOFl0SXB2VUZYNTllRTdkWU1aL3NKcENS?=
 =?utf-8?B?eCtLWUUvbDJEZWMvM0dsM2RQUTJWMVFLOUpreXpuRnBTbWpsSW9ZeXo1MG9s?=
 =?utf-8?B?RFBrdkdGRjVmOUZwVDlKR3dkVVY3bzJSYng5aUdQR1hDd1hZVTRhbjI4czJk?=
 =?utf-8?Q?gQrd+zuLQqzuv6VOGB?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4affd8b3-45fa-4c64-8f70-08def31122fb
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB8374.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Aug 2026 16:46:46.2340
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YuqVpavDgPWLvUtjKF1dReM53hCfL4v0GRMQanx2c324VKw1aDzPMAg3xPitvHIO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6348
X-Rspamd-Queue-Id: 4880880008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: kxk6whb86f4h7s8qhcanx65z1crndsa9
X-HE-Tag: 1785948418-406718
X-HE-Meta: U2FsdGVkX19awdkKT3A5sj0fpDJbirez0ehC4z44qRNF6FLz1u5jdhkHJzedRIt4lIBYHxzGUic5ENmk/0EtkwRNM9CqDeAN0WaohGJ0qhYr0wNR7eUTKEhHv0O4sUF4jTuUn/aWL22+OdXsdDjtFJ9ElYkNy8VYfrBF3tDfoN8v1TXrFWDcuULspFl8Ph/OxCDhJ09/J/og0jYpiDN/V5ohQG+bAlr4ZctVoqVj7TZ+dtglbykC0WPT5uAJ4JjzVPN+HuQ+lukVu5XwVaOfFwOsd4Mos5NZ6NLJG/lKq0HQDiRKryjwHd7S5BTaHkLPsxpI5rXuYqilYg9eCuxaosWhMcvy2CA6qpKlbtI2oSLTL0tTMIB9U6OgviCkWKjypmgzNR6OoL8luMASht6YmBNWIX9zpohvwxr9QSb2MVMj8CSlfxXC3M4lrPFtGZ+fksxuWmjIcCpQqSWTg0kz9+dJ4pyVCdKCqub1RKpt8HIas7oP2JSMNmE5ilzs3lIALMQTfcLUu2hk1yB3DKSbgZ6pAYpsoedwgKoO/OTqJKqiQrVLdb0aamGqeRU6cxZEDmWViMlY83esAUyn5//HvRfKJQJCw+1itUOtlpamgf+5NRf+2h8WhckeuR9wxhTO7E/BEcRP4YfU/ahpMDwotfeXFS5HsYYcctYM5/pRXLS8qK6DU0TPSfkizHRqbWfo+VG5UTkhm5MnDqo2lUagUAq/gi3NoymA0dwIFNebjxFNYjchYtJ7qRX3EUq3avB6tprgmVu1QVKZKv9NGBBVnXdP9wRKe1/tOs4dOpz9xjkmBJWNqccBsshrdKR+r9cLZOKy/3IWjHDEONZ5IXUgQUSdQi/0beSk7AOlJO/QAM98ab3yew5gR7YjJq6bVbfNNk2q1BRyAs3qsxxu/IBoEnoeh9dWb3GPxVxTgfz+WYjvjMxj2AJ+8OBllGpp8BySo4XbCPo+Z4j/WEX+KgM
 AJPamMXG
 AaRmhm399A4Wa794pGpjCM/1qEGyD7FGWE996uHsisGxfgFK3gcsy8qOx5bruBaDj/a2T4k1LbAEOlgpzIRb9WujBoOG8d+YOQ13n7QKpCD5xDmyTXfg+EQBqbGIXxPdTNYVJJ3o+1+cfmWsV0pouzGXtKWg3PB27mChlW9Uz6VwR2X/6utcuqSEZn1BBvgEQYwWfmaPAvwHkiBDB5Z7Wwwhlnga5HTTVkrU0axOWYgWwUA3Xc2rzQYoaxPaJccoL156iKFp560n9Q30oVxYBm+hvX6lwi+ilT6Gw4gvKlSNrPZB71jGAnAsr0ciSbPbVtDGH1DJQ42Ad+u1zEIlV880/2avWPilxKsAr+thJ5yXYuEnJwVcSFfjtIBA09EgS4dy6RuU6HgbKRTSoCm3IgJ04ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '=
-c'
> parameter to specify the collapse order. Additionally, added mTHP collaps=
e
> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mt=
hp'
> for anonymous folios. All khugepaged test cases passed.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  tools/testing/selftests/mm/khugepaged.c   | 130 ++++++++++++++++++----
>  tools/testing/selftests/mm/run_vmtests.sh |   2 +
>  2 files changed, 113 insertions(+), 19 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/self=
tests/mm/khugepaged.c
> index f69be6be0ecd..64d6da6aa90d 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -26,9 +26,11 @@
> =20
>  #define BASE_ADDR ((void *)(1UL << 30))
>  static unsigned long hpage_pmd_size;
> +static int hpage_pmd_order;
>  static unsigned long page_size;
>  static int hpage_pmd_nr;
>  static int anon_order;
> +static int collapse_order;

<snip>

> =20
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/se=
lftests/mm/run_vmtests.sh
> index 687d115e3bd8..d09f9f6a384e 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -410,6 +410,8 @@ CATEGORY=3D"thp" run_test ./khugepaged all:shmem
> =20
>  CATEGORY=3D"thp" run_test ./khugepaged -s 4 all:shmem
> =20
> +CATEGORY=3D"thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon

Why only testing collapse_order =3D=3D 4? It is more useful to test all
possible mTHP orders. -c can accept common separated order and a range.


Why only testing mthp_khugepaged:anon? IIRC, file and shmem are not
supported, so khugepaged should reject them, right?


> +
>  # Try to create XFS if not provided
>  if [ -z "${SPLIT_HUGE_PAGE_TEST_XFS_PATH}" ]; then
>      if test_selected "thp"; then




--=20
Best Regards,
Yan, Zi


