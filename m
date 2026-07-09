Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F6FFC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 06:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B00E6B0095; Thu,  9 Jul 2026 02:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861586B0096; Thu,  9 Jul 2026 02:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74FA56B0098; Thu,  9 Jul 2026 02:39:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 50BA46B0095
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:39:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF7F11C38F3
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:39:01 +0000 (UTC)
X-FDA: 84968285682.27.D9DACED
Received: from BL0PR03CU003.outbound.protection.outlook.com (mail-eastusazolkn19012019.outbound.protection.outlook.com [52.103.11.19])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3022340004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:38:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=Fn0K7sje;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jiahuitry@outlook.com designates 52.103.11.19 as permitted sender) smtp.mailfrom=jiahuitry@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783579139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jelvM+/BXZVGwl3Kq8XsT09nK+oprcUvo6tLqU7BXjU=;
	b=SHXSuxXwkjARNibIg2bK1FSS6OJJnisfhzKIZxm5aBEvg7iJYaj70L6H87pCFD1l334STV
	AHPwMAlgNsGCZ2vdMXOM4GZB3GjIpWwUAsfKGEwODh14ho67avSsTOoVnLIWijeErTgoaK
	FMUWF/j3gk8OJ2RCt0t2JMiLPHL4xYk=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=outlook.com header.s=selector1 header.b=Fn0K7sje;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of jiahuitry@outlook.com designates 52.103.11.19 as permitted sender) smtp.mailfrom=jiahuitry@outlook.com;
	dmarc=pass (policy=none) header.from=outlook.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783579139;
	b=k1FQwasSZVMpI6549fz9bB5SeOwDma4miyxGHuc9+JXtaVq0tB0HIl7x7ftaZ5s4WYJnys
	VzclKTXpEXOJsQ/I5TDpKGgwCajZSaueyHRIgqm9XXLBYMDJqPXZrF9OM7ZQC5ehdSgUhC
	zL0VstUn+aDr4OBd+HMy2/psQ5VcDWs=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=SA/pLPFQb9GPkrHC70K+Ya/08uwRjDT5PF/jgjYG57wFyML0bsi8EBOp9uALeWgjr4Mb90AXZMhNgVy99DH5B4FoWZw+gX88wMAlHxB2AhvsgRNRz07RXxgzS/gfC+SWZyCFiSuVNmjhA+Kbu7AlRfkvfrQEO+88pWYYkwreNdgbB3bxk4gVtYegaRFeI8QYnF40Qh20vsG90UMVwyFKbS7XLJzdQJ2qAjybgceI40Tc4q3XVvuj29VFaJJDR2FlYHrkJrTsm5bnCb7cHZGanOS2icW2JGRLoe9e+YKOKWPdBga9QpdcaSeddQNmzGGaDgCZDNBQWNUjRoDAU797GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jelvM+/BXZVGwl3Kq8XsT09nK+oprcUvo6tLqU7BXjU=;
 b=Ttp1uccqyAnYuvRPREDozhnWw+GyHWKMA/PMtS7EYdqW4+LJz3SpQSPzIrjfa+WsnhCgn6Hq/FVZYruvGARnNTYleG1Uz58W74JwN+dYl1+EHPE6fHIVMQG9g5+65NnuOybVcb4tk3XA19XVvqoCJ124nudwUfQ6z7gVpWmxaiDAZRkPVVehxhKU5racIGcNzCwwBu3iMkqwk4GeLpGK8NWKdtiyV0kpAbNlSQDjSyKuYa0I+x9rcmENHxrO9UhNO+lz7JDLALplPGPy9UxPRuCBifyjuqHp6Jh8K31xvWE00vdiJDZzdPWrobhAmq7EB/sUMRpVysWUTvJSqrl31A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jelvM+/BXZVGwl3Kq8XsT09nK+oprcUvo6tLqU7BXjU=;
 b=Fn0K7sjeJST6zdqSFYzMQsM+H8G7WK4953OcMjKQ7aP8hdzpt8iDESNqLSTLDxvj0zpVOxPGfk0dUlur7zey2WMPEfbGve+/C/nkL9aDsscw1LfS4hxZ+A/8/XePzTB+K1ycWPEoTiuqZKy0V4JwgXItPU+npuJrDEqhhlVS8KgtT0Dc8dTsH2z1j04PgUDuOAiwBidV3A/S36TeqJID8ccdMEsu6IiUAsZf1ldASNR0oyBUg+xKFgsJMKA6w3OlkPX9gYifi+sPZ6AQIeEzrKgR1R6cW4RUaGvYSLJcWR3kYogQRjqblMPNr706Qz+Mn59DvEDeIagjnxe8PrKUsg==
Received: from MN2PR02MB6654.namprd02.prod.outlook.com (2603:10b6:208:1de::19)
 by DM6PR02MB6683.namprd02.prod.outlook.com (2603:10b6:5:218::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.15; Thu, 9 Jul
 2026 06:38:57 +0000
Received: from MN2PR02MB6654.namprd02.prod.outlook.com
 ([fe80::a150:49b2:4042:3050]) by MN2PR02MB6654.namprd02.prod.outlook.com
 ([fe80::a150:49b2:4042:3050%6]) with mapi id 15.21.0181.014; Thu, 9 Jul 2026
 06:38:56 +0000
Date: Wed, 8 Jul 2026 23:38:48 -0700
From: Jiahui Zhang <jiahuitry@outlook.com>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Honggyu Kim <honggyu.kim@sk.com>
Subject: Re: [PATCH] mm/damon: prevent migration fallback to non-target nodes
Message-ID:
 <MN2PR02MB665453D2B64F0706736C36CCB5FE2@MN2PR02MB6654.namprd02.prod.outlook.com>
References: <BY5PR02MB6642569E180FF82F147E7880B5FF2@BY5PR02MB6642.namprd02.prod.outlook.com>
 <20260709003752.127954-1-sj@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260709003752.127954-1-sj@kernel.org>
X-ClientProxiedBy: TPYP295CA0042.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:7::20) To MN2PR02MB6654.namprd02.prod.outlook.com
 (2603:10b6:208:1de::19)
X-Microsoft-Original-Message-ID: <ak88NrW6mNzGivkr@s222>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR02MB6654:EE_|DM6PR02MB6683:EE_
X-MS-Office365-Filtering-Correlation-Id: c8fd4e78-2b42-43da-4605-08dedd84c01e
X-MS-Exchange-SLBlob-MailProps:
	Cq7lScuPrnrlC5lHdFGci+YUsdS3F/CIThS1wk8lbB18eUq5nPCKgBosDs5Tkuhyq3Eh7myYz9xjDTNTeevda11qhifqdmfwKdpZJvs6qY3Z7lURbjIjkWwZmb7stxKJYgaCsrBuQEaJv8A8LhK357u2A1B4SQMsApw3ynpSyXnN4fuM4UwrhsqA5LDQZSGyotp8m9zVFomD5I9qvxJR7mkhacb1wcMahA9lBj0doFl+oavim/tvjGqCw/6qnAmjvUkSnqPt0MvXaQpBLDPdq5ZDjLu2OmSrYyCodLV0kIGgKDK308XSM0s6ZE/ejPq9LlexJf/OPj7ptOzwbcDAiOqw9hRMjc6Ge00UFKUBa54dSaWfO4ZryHucwvgKftAHUwuEjenimNLSaWNWqwUVqJm7cz3HsMVLJhkwqajxjgwtCeELcuTuoG+4cPZP1/D9VjwX9hP3pNG2kIRH+ap+FNa4CGttOKoVzPrSMuJHx7TkFRw9T5RliMaqv84vr3TB8ZgHPRm9XWx/YT+U/EyWRGgC9oAXzAFuPuqSU+GMDFyaIeOoOlIym7HZwFceeGoAKmiZETtsZgPlHJlULZzh2QHm45wBYmXMOx3PwS5c7o8sybBzvQGSsJtXmn2AMLQcYCVUKZKJnMqQx9U8AmO8Vd1NduYn6O9xjmWSeDRHUpyldqKJ4SlBLWWibDL5Hio8W6HpDam5MrJzIBNgpp9myFoMzVf6uIGO1YGyZrgsPXtDqcaG7X8lRStur6Jim6M3ylwxsYWyHNo=
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|51005399006|5072599009|15080799012|4140399003|5040399003|23021999003|24021099003|6090799003|19110799012|8060799015|12091999003|18061999006|3412199025|440099028|40105399003|3430499035;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?lSjXAAzf6pSp1GUUzHTxxp27Nux9/MKdzC1lE2a8SNFvP2YhjPkQRTGmLvdK?=
 =?us-ascii?Q?K64H0u+EiJu6lW/zhGxjBSPFKhARQ6TI45Grlj3ghBEiAiH1vCidoppWdHi/?=
 =?us-ascii?Q?25I0/UYO5m04YxQffbVpdWlcYUF71mqzqjc30iyE48xIRqvl5m+OjB5dIE/3?=
 =?us-ascii?Q?OXhhfw8IbEVMpa7ZMuoVpDlBTZTEt2+jFwizmCDEdQs3NBV1rhNXRsUO0peK?=
 =?us-ascii?Q?1lf4WIiJcoLM6io6L5r8obG19QJojgom/o9f5sjt6xvWq46xzFzRiaTrzQjV?=
 =?us-ascii?Q?tomYOy/imMip9pUKZFxAvOGmj78j72C1OBA83xyVRuEZk6zvLXX0LHgLD1H2?=
 =?us-ascii?Q?3DsA/JQ6DQnq+C9aQKDSKWGU438FjnL9lTvYNxrMa33TpZljeqBCSqgVESWs?=
 =?us-ascii?Q?faFFTBt//IAdVIArpq6AidigqcyY8lalyC4n7sjMPlbgn/qTzgR7IKTYc+iZ?=
 =?us-ascii?Q?M0Y0/DFNktFeUFKlwpI3erKyv6qbAY+9o6uCJ6JUMZFZpxeRDpxemMUKLmqK?=
 =?us-ascii?Q?oXp2Mov35dAgxxO7k2R9rpEWWk+k8zkke7O9IN5AnLTMbcbPrDFoR6T4LEEK?=
 =?us-ascii?Q?jLhtPBWz/WH3eD3waKJiuVmy21SQPZsEqoGv6LEJiZOCRWdMpj5DGQZtTt4e?=
 =?us-ascii?Q?qUWaW8sNKptUNE0026i8Jyl+rqpCF8SJcZ6rVUJqRQDVGAMuJ7t9qTiecEsq?=
 =?us-ascii?Q?Rjb629ipaIg/e5OOqMk48W04oLwy67n4zX6e4FQ8kmvAlHEFjZpZ1HexuLa0?=
 =?us-ascii?Q?6bRCyQ7ZR6ALA99STdA8cliKOGaQlLwiU66HsCIyERnPix3C8F1YSlQuWZ1W?=
 =?us-ascii?Q?qJypvLgnSZyDVMzmSU+khOS9TyDxcuMMx6fXCnjj1kfs6AXX76BMiL8tzL6m?=
 =?us-ascii?Q?Fiyzd9wFzXF2YRGr3VwisQ+LmRg1dheVOmQJVtV/OAgoM1+8HzbrEN8T0dIN?=
 =?us-ascii?Q?WmnaOs5tLuU6qfdVV7HoZOg/sV6ChKrdVKH9C2nztpU3+9QG+runZSqlMY+E?=
 =?us-ascii?Q?cwY8UAV3hemeq9wKd6KLUgiIdg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?3qMXpcxf0AY0+bYA+qq3lKyBdp1dwDx2nrlE7GXAXma5uHAjdQqtlPr25qjA?=
 =?us-ascii?Q?WuB/r0Ox7IP/0fHYjZ8HWlZux5qaWaWMLSq8jPLQe26tWsoKCZMZ2wi8lXdU?=
 =?us-ascii?Q?+flNk2SD8V/0GIroYGba5y14nExWeJqqdkGmlHyuD2Hz0mYL7K5JAOD5IK6W?=
 =?us-ascii?Q?11It1pQwjEzqW/aGya09gXxOx/KYhDNHhlXUvLVIIFNqiP3Urt02o7wFYErN?=
 =?us-ascii?Q?1/xB7gQF7Pu8jCfVso3VobhypvsYUvXrmgXajlrXa6NyeSm2VpxXMi6i2vjQ?=
 =?us-ascii?Q?F6RoqjxZy1hCbPTfC3Nm+3YGYpVZ885u8ftZ+UVjd7C6AIQpFjZVGZdUU+aF?=
 =?us-ascii?Q?ydea9zimhWVr6P8W9pTElJigMV3jcSycB5gy49MWmqYqxQ23Bw8U6rd4qfz1?=
 =?us-ascii?Q?9k01w54+HC5xX1uyRgawCs6GBdgjs5JH4wTRxSc8x7KPFU6QoFZ769oILzOx?=
 =?us-ascii?Q?cAMj5vAkfOC8RB211Pe8MbMYqIvL6Vyb+KSswo6t1BgNbVBJuScYfRTZiIso?=
 =?us-ascii?Q?VrYoo/C9JZzkfH8RYDUKKVxt1PBrtXxPJRbBGTrMfVaPLG5v1EVrl/WENSV7?=
 =?us-ascii?Q?No/Nnmk0zTqgSlggY2jr0E0Cd9hMT2cmfc5AqzVgjJP7kGrkbv52B88nQjF5?=
 =?us-ascii?Q?KOfDXccw5v63hmhrGw9/uhL3DiwnSWDyXvXNPtkMtqVyleICzXB4g8doBnxV?=
 =?us-ascii?Q?NtrC+pY0y2MVRXGiyjm9MPioLKvvB4sV1ftAF8eVWNqf3Bg857fhiKFPDvoF?=
 =?us-ascii?Q?7aZ4pcWQsQzuwb29FUD3dFocm224eOlEmOQcczWaOMCFCdcQhvurhwOUL+za?=
 =?us-ascii?Q?K6TM0uHTmP0YfVJBnp5tI3Rv3baShBOeLBiDO/J/ZDPNOmuQJK9H+7SxyvUO?=
 =?us-ascii?Q?G4C4PJgDUuqW0ZSxBfY/VHxQ2K7k+3Fh8MgMLlV5YMvCOEL+odM8p8K/g69l?=
 =?us-ascii?Q?l6lMIdOnZyr3J/4T/tu8y9d5ygWA10pIdQLb8AH65GEpB5fta/v+x9KhAMs3?=
 =?us-ascii?Q?2Lf2i8pV5RI52sy6ZTqKfOi1YKOoqy9RZovHNI3QTUIjyDd2jyMnLNTpBbvP?=
 =?us-ascii?Q?qZPlQuBeKohxaSlGfXpaYFECdTI71ghrzUqYuwetaf2FqAmlTbZaC2xzAwKv?=
 =?us-ascii?Q?qjLonluoLaI5fTtyR9n+UjGpHvcyMPre1l/9ReTmrwZeFLFZearqh6drCAyE?=
 =?us-ascii?Q?4tVlyLpqFgiCLKeVVEaE5G0Zf/1yGkd/zrlbtnGWwsO/2qhy/9sh6/AupLev?=
 =?us-ascii?Q?bLsvKnjCDyvxQrTaou7PVEMuaYNcuhaUtEVb0g9GrjvRL8tlewmPq8n9+gv4?=
 =?us-ascii?Q?eZClaN7n/XPfNoSB7BkJ4pRvqmF/AHX9sWey9HQ8QNk8gRYBNdZvCJEO3Oiy?=
 =?us-ascii?Q?yXB8YQOx/zYq97M2T9g06bdDH0fW?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8fd4e78-2b42-43da-4605-08dedd84c01e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR02MB6654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2026 06:38:56.8466
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB6683
X-Stat-Signature: ewecx9g8f8wkh148egoy1ky5gejxom7g
X-Rspamd-Queue-Id: 3022340004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783579139-511675
X-HE-Meta: U2FsdGVkX1/mlk0n1osPrPyfVdUf5Q6SwTtunxe3A8ZGAA482ypC1gyO2ksQ8MTV8NUZ7OB3U+ryqOnQ2nMAxbB6n1qoOY2BT6CYre18pqxoRXnQATDsxZS0Htl6EnmSt3/fuu+pVnjtPI2mYS7gIYvH2AWZ89tFVAMQECHESSx/eUiNlGk2kBdfIRQ0YLsVSJB+t9/B4pd/gKeRYQp8NuvYzu8Z4E3DXLZWxS4K12HoBiufNToj9ISWd8ztc5aaDmVKaHlcyxorKHsLVjgFVtGdE2sLhkbGQDHZYZEdOHJNcbRZYnEa0iIR5iyE2FueDUjoVq9d4TslrZ2YXFp2XvJI5BrZkp4bjyLDaKIOBO9o6xtemLvWvHByWp6IoqNYwPTUx09yzKk02C3/edx+8QLYoo+9NkqmxgiPTZrtOu8IRAq1Xn6t6wZSl2KXJx1vpKpedlQFW/vv5CoEVgspVM3YbNMOCLuI3IE9hH/6A4xGV4yIBnGWPZ9BrwmlhmZMmykHuEarhrADN480PLmltEkeucdHg01QMHf2V94A89N9UWSclrYw1yamHBh834hgWmqn8K92LglCAZZzamgAXzbSmxzSs/7vZI43c/yJ/AAk4CDqRkXJwxMAgyD7xw25jQytyXB+SWBtF2SyDeg0blN824kddqxS7oiYt51fyJdmBkxB9PWD6pFBKoLslTKhy198pqp+pUlQgiiSHpz7lHAG0p7OVKFoPPjzyUQl4K5KnmN9ktlOBouVOpoy3an135DUyiuAjFJlgA0RuaZSHzrtv8pZ1CtvCyNNjVX6R36KJq7gBawdo+eH6HK02Nu1FWReId6F70v6GwdYcozx+gN6a1J+wrWw7nQCykSwZVKmLsvCGshBjpPw0oEf7gcWNQku6XjFXzBWBzvKwi3V/fEHGEVZHREJGlHX83otdcJsz0eS+eVWHgfmEKlPC4vdT+lZMCpyzsRw0RI3cQk
 ExuxJlzJ
 pYHFMqifPSRegixk8zk11wUBlJfYz9gEGVpHGQbk8EBGhzjD5DiHxVECqXuW0wj+xeh+1tyBL6jst9zSG5cnuy/XPKECUCRmNVyVyybB4X19XN8XhtgP4HDrBqVDX2oCVFlLTYk/oPYfDObz4LIAHWaPalHRzqX+5tt8dG+8e6UodFqaihM6L6ZgfhoIfA0me9RMqu8azIib/lWsbMEjq4GxsHWZqsumrvwMFdH6FBV7F2ZwzCzZGMq3GSFnS2H1/1S7fyosvasmuVpiwVsxi7oX2qr6U7lezd1Q6XBGhlYJYD2w/Dm/gg99O5UomFsNJqMak465Q322lJv6i1i+o0oqaGucTO+WsFmxXFYPjV/CKFOWtLafNu5ihr+fH3CYklMY3cgN2N0Akg/rYzb5L+8QgWInJUEO6P+8ACBltS4rrn8ZMOdtgNPa9qQG7II6HV5aedRAIa3Xrss3IB3TBhuJrP3d9A1xlP56pl4cDDOT+wlUn578EEntbh3XzMZTlL5npa9GVVmqUxs5/GZ/tISX8kI8BcnVuPWHkFjHg3rNLcVZ3UKHIVZf0LARRkWJOMp9YbfiZIh0zyYg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On Wed, Jul 08, 2026 at 05:37:51PM -0700, SJ Park wrote:
> > > So this patch is introducing a small behavioral change.  May I ask
> > > why you think the new behavior is better?  Have you find some 
> > > negative user impacts from the current behavior?
> > 
> > Consider a two-node tiered system, where node 0 is the fast tier and 
> > node 1 is a CPU-less slow tier, such as CXL memory.  Suppose node 0 
> > is nearly full and the user wants to promote hot regions (which reside
> > on node 1) to node 0 with a command like:
> > 
> >   sudo damo start --ops vaddr --target_pid ${workload_pid} \
> >       --damos_action migrate_hot 0 \
> >       --damos_access_rate 70% max
> > 
> > Without the __GFP_THISNODE flag, when the memory allocator finds that
> > node 0 is nearly full, it can fall back to node 1 without waking up 
> > kswapd.
> 
> Have you considered or tested running demotion-purpose DAMOS scheme together?

Yes. Running promotion and demotion schemes together allows hot regions to
be successfully promoted. However, if demotion does not catch up with the
promotion rate, allocation fallback can still happen during promotion. 
In that case, both the migrate_pages() accounting and the DAMOS statistics
(i.e., sz_applied) reported by the damos_stat_after_apply_interval 
tracepoint still show misleading numbers.

> > 
> > > We as the kernel community disallow [1] anonymous patch submissions.  Is zjh
> > > your preferred identity?  Also, it is not a strict rule, but we as the mm
> > > community prefer using a formal name if that's ok.
> > 
> > Sorry I did not notice this.  If you think the GFP flag should be added, I will
> > send a v2 of the patch and correct the Signed-off-by issue.
> 
> Yes, please give others time to comment on (say, one day?) and proceed to v2 if
> nobody disagrees to.
> 
> On the version, could you please add the clarification of the pain points you
> encountered, and how this change made it disappeared?
> 
> Also, let's change the subject prefix from mm/damon: to mm/damon/ops-common:
> 

Yes, I'll do so.

Thanks,
Jiahui Zhang


