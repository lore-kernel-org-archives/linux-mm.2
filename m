Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8F0CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527018E0005; Tue,  2 Sep 2025 10:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FE0A6B000D; Tue,  2 Sep 2025 10:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ED358E0005; Tue,  2 Sep 2025 10:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A88B6B0007
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:36:28 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C314F8483A
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:36:27 +0000 (UTC)
X-FDA: 83844560814.21.AB9D1F0
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2063.outbound.protection.outlook.com [40.107.96.63])
	by imf01.hostedemail.com (Postfix) with ESMTP id EE7DB40014
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:36:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="bHf/e50v";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.96.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756823785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4kB1lUZXrLRveXwA7ZojVcM0q3spXxbxx/VVdDkprEc=;
	b=tnEsZlIrB3JjqhXgQPs2dD+4nvdJQvcB6rfW/tOxwKC7xdg/kwcqO7NNxHykZMrCEhHoi+
	mDFPTyRMrgICq6zCQnel67EzYTTGj8Eyf6M/hhOjJf9sLPjDIcbKmXL9BgbUtQjWEo0vRu
	4SjPHdFywZPsQRTxR/Obv1V/4Owh7nw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=Nvidia.com header.s=selector2 header.b="bHf/e50v";
	dmarc=pass (policy=reject) header.from=nvidia.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf01.hostedemail.com: domain of ziy@nvidia.com designates 40.107.96.63 as permitted sender) smtp.mailfrom=ziy@nvidia.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1756823785; a=rsa-sha256;
	cv=pass;
	b=SMDzuDZw+DLnfeKce6DrC9CoRYLDfjQJNcj01F7IyCj5tWaTPLKSbUlYnE+HKEic4JeQbO
	P28NOyVak5ri7atyqxEqJwRDdyzs/rHFnnAyGo0VLoNS2sSoADjaEPhuf6pm6r/p14NP1z
	QCx9Rqman++maEUIb0aWOtOtyZ2hjOc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PGuCamLm5ejnWlPKfNkExAW/pp3NfxU8Yn5ZL4AuAzhvuQgqmFewwAIbtPUcGu9w03r35X4gbBwhh6UMIgsRMjhdGxSWpufKUHS0t9XoEazIBTwHVTTMa4aalUiN9I7BxD5TWBJIRdMoqortirxCQ2+Td7bN0/0TtulkarDhlUMqZp1k2j8PgBGXsgMzcK5uPkQpbbBnAjo+1BbYm8OQcqOsM+amTUZm3+fzFT/Ijug1bCRlBXgvNJUJmQO9IoRV8GeD3K1YZDiq87OxG2oElFNAILE5WX5a6g7Hdvs24Z6UKCukNcGvttVgDq+H+mhUDM5Hsji8DPKhoAD7imbWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4kB1lUZXrLRveXwA7ZojVcM0q3spXxbxx/VVdDkprEc=;
 b=I3WMQBNl+kNzQVBuxxJ8lbBN248IsnH/SKuX6iB2g4ME0sa6Ks0bgja5l0aufAn0Wae9c9Ik7mYEucbIU0tBDuSq9yV9c/gNwkzwl2BR8A/V+dMeNG9rDPgkdvbYtMcVyVItYO5Dr+p29cn5suLnjTGA9myd7PoiDcKTBu+7213UBJwcRVYAzMoQfm9dd0xK9p0wPpAHqU7A391yrg4D1vUlMb6N5LUrf4UQO4B+qKFcW3G4gcrRIre/FTUDj3ltYStGligmChG2v/52FjBAUQN2Zy9qUmnyc70oPN0wTX0dYedygd3tp8JCJnSF/Q+xR6PYK6dW6YU4iJp/8ubezg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kB1lUZXrLRveXwA7ZojVcM0q3spXxbxx/VVdDkprEc=;
 b=bHf/e50vatx/7fmZWCw0Rl/kFL+jWtIC/On+Kb1TR9vUVjZCn3TZT+2ns39kEfJ1o+D5nf3SWXg0QvaKME6qUQb/l6COBGtheUI7VF1E7KBahctXZDfJc1q9ZUXJ+sHKCUk16a0bq3CRqT5+iqFe9+pBN2YC7h5351PDAkUK+NIe5HI5T2mlSnSrBv1wP9RYELZU/xWAlbCB4SKnzbvJzt8/bEABPiYl1DHVjmcQiBC6/W57s1u76fm0yJOTA7xWf192fQ9QXFGM3fyLTNXzYelgeRn+O10P4cVeejXPl0b0YrRJmvOl0um1rS3H1ymq0s5xsUDy6yIf7ZZIifKreg==
Received: from DS7PR12MB9473.namprd12.prod.outlook.com (2603:10b6:8:252::5) by
 LV8PR12MB9358.namprd12.prod.outlook.com (2603:10b6:408:201::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9073.27; Tue, 2 Sep
 2025 14:36:17 +0000
Received: from DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a]) by DS7PR12MB9473.namprd12.prod.outlook.com
 ([fe80::5189:ecec:d84a:133a%6]) with mapi id 15.20.9073.021; Tue, 2 Sep 2025
 14:36:17 +0000
From: Zi Yan <ziy@nvidia.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 vbabka@suse.cz, linux-mm@kvack.org, vishal.moola@gmail.com,
 David Hildenbrand <david@redhat.com>
Subject: Re: [Patch v2] mm/page_alloc: find_large_buddy() from start_pfn
 aligned order
Date: Tue, 02 Sep 2025 10:36:14 -0400
X-Mailer: MailMate (2.0r6272)
Message-ID: <6D364315-80B8-44FD-A0DE-E78244CFEB70@nvidia.com>
In-Reply-To: <20250902143357.GA6654@cmpxchg.org>
References: <20250902025807.11467-1-richard.weiyang@gmail.com>
 <20250902143357.GA6654@cmpxchg.org>
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BN9PR03CA0539.namprd03.prod.outlook.com
 (2603:10b6:408:131::34) To DS7PR12MB9473.namprd12.prod.outlook.com
 (2603:10b6:8:252::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB9473:EE_|LV8PR12MB9358:EE_
X-MS-Office365-Filtering-Correlation-Id: 67d55e3b-434a-4c33-23e4-08ddea2e133e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?V8+QWRKiKnR9o7Wma31Ur2Cs7V7Do184zkQ8yhz8YrBvQ0AStJOr2adUJWot?=
 =?us-ascii?Q?ZECXXYzxbao0mb0k/kn0TdsuVcYfPL2XGL9Kwfu/9vQzEOfcYp0W/WKM7PcO?=
 =?us-ascii?Q?GuSYPusmyzPkYQ0nk/Xqj122sBksc/UUAM5eIVHFOxB6ZpZLRokdleFKMD7f?=
 =?us-ascii?Q?IpZptIymhht8PdDqpqyxn5wdFCpGufVhGDuf7dbmfusd3wnWnEEMnIpbz6Ln?=
 =?us-ascii?Q?XRYIQEEwtqWXpRkMaVSzV7SXkBwAoJleqLIsimDPyc+J+JBeZgA/RJHxYEP8?=
 =?us-ascii?Q?KVucCjG2/kfEptbzvmrm4eqfG8OUiBX5sjOG4Ix3i/Jn/UE7vlMaZk+Db710?=
 =?us-ascii?Q?yry/Tp6Doay9Uam1g/Zti2RbhsU/klyS2Ms3csXCuyypxseFpLMu9OfbRytb?=
 =?us-ascii?Q?JwxZfH+jKfr1xC2TTe0CYRnRwxSIwjR9lBKnrH05wLdTN8UxZ01V8N7vA38r?=
 =?us-ascii?Q?Wzq0LM5YToYI+d8n40sVyfuOt3yekXnWU+BKM5sTsOlXgAx5foce21T0cMlm?=
 =?us-ascii?Q?cm/StUCIKCiMG8JAUJYZeONQmQHLfDC/z3vcwUVjshK6RshKqDIKtklmeM4J?=
 =?us-ascii?Q?b39+iq0G11PwwD9bQVUhPrOkFoKiVsT+pxwYjL9OFkP+y3RHmG/pjfM09GFI?=
 =?us-ascii?Q?I56AihGrkiFK+xEIVCiMwnlg9SMjbZC6nrv2AVEHhGfGf3tWXOV3kzLmwlpP?=
 =?us-ascii?Q?gRUZC5HBw5YBwnpNkZ53A5AM4s1n4LR8Z1TKZHFeX5nm7I4Lxz1GcUk0iC6K?=
 =?us-ascii?Q?Xb4SPsd27QZmmPeP5+65CXLw0ubdXFXLleeXit0l7PG7yIn30+KnRbeeiUg8?=
 =?us-ascii?Q?Rb5Bm/iMRAmRWJJjTgdZR7kVejvK1h9PTZlucUNTAfdc2naGCFCrSZtVw6Zi?=
 =?us-ascii?Q?f+l43JWE7qs/OajAxgxITea62dLNJXHnsgYCd4yzdHxZI0lYdmlm8Te11nCx?=
 =?us-ascii?Q?U48W6zdkDlujGZ9NXTGfcyw2gq4Fy+/9MwN+EHY2hzWdokzCJWH4akYBDcyR?=
 =?us-ascii?Q?nt7jFd2Io/08Ni0mp+RC4xiXMHIBWetKnZV4De1j/o0BIAiKkvH67k7PEGE3?=
 =?us-ascii?Q?nuJ9CupquszgGI2hQPJgQSb4sCkOVSy56cBEb5mVsgFxOLlMGKbmBiK9JRAi?=
 =?us-ascii?Q?9NNUCjsP8SdpoZ3EGR/RSld4UJlORGU2bd2r9eoch29bUvj+n6IKPTtGwXYz?=
 =?us-ascii?Q?OI7MewhHqRgYlnfJWXpSdVSOaIrDDC08B1ePw98LMr1303qzbzDEr0tpazQ5?=
 =?us-ascii?Q?FugXlWGoUuB1IUY6dqcz4Mal+y7dvm6J+ua0imeeblGtIApRKfKJLY7+9g0p?=
 =?us-ascii?Q?WQ5LmdgyTApEp5H+RRdcWEedXdtcKjpJXK9d2dvucW08BtA+5sCqGCkjknRr?=
 =?us-ascii?Q?d5IfjHQmaS2uRimtVdG2s3UNclPqY0VIPWk+or4VzN52pPOLiIy3PjkIZu64?=
 =?us-ascii?Q?LcE5+w8cSF4=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB9473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vA/ZQzrARGWV7WmwGSt4ccpqk3K6Qdu1HA7jxJcD1BrGzCyMlzO4N2kDAb8A?=
 =?us-ascii?Q?UEJMX298AYukJfu7YZu5KbiG7CMGiNNur8HQmNMKO371KlQCjMV43p64Yupj?=
 =?us-ascii?Q?M6MkxJSV1uEIGBpPdlDYMCk0Lh7jlLqJ/USPh62YeKSKHAVi5q/ZUcq5o0oS?=
 =?us-ascii?Q?hNycOTm3uQI2dWguoA/I3Hlq9uNdQabzc9xje2s8sAWMPJt9oKFGtGEXD0gC?=
 =?us-ascii?Q?XaMZDJwE+dUxfuPcN1Qg8yAPdTfJgRLULhwBvVVhsInQoySED19RNV7rulKF?=
 =?us-ascii?Q?McyIE6l0JwvmQ7PPVgbdTmEL/1rFxnE9at9EsGQkDL1wFIBaCdA4JI38AN55?=
 =?us-ascii?Q?aP5MctxbazTT833aG5JZJInN+7le6BsNK3s/nSQ3rQCdxnjdcvTepCd4ZIq8?=
 =?us-ascii?Q?J+3XUEJYmlDq7F+wNY+5lSyJ14cEgxc2CsQzca3/KJtbnu6dBlfdIkHWC1FI?=
 =?us-ascii?Q?XqvraUwT64wEmPP015hs+zNtldERNb3/jBNi/Y9WHvGU0OX0z7veL4snsOxn?=
 =?us-ascii?Q?hIaFdw4scmIRqibhPpttUIYGGCeuxta1Eq1FwiaxZTSSJBQnASKj6uAEVLfV?=
 =?us-ascii?Q?av78FCvJbYSM3Vggfcby0FW1T666++n57ZawDUVSypkm4dRKH6/dzr7B2q+E?=
 =?us-ascii?Q?GwCYkgQMWmYD0nddAG5VD8z1sG0ZBW/p7QPxEvZZYKvUaoivjy3D/QPARsPY?=
 =?us-ascii?Q?9vWmkuFJN5zg6yYVKCaXZuKco9R3XLN25gkFEcQp0oHziU3ULj0oMtI3a7Nf?=
 =?us-ascii?Q?+9yiNIWEBu6pkBBSkoKUtp5Kak5c/QZfDqjVn6STlTmYmQqp5dO1MkmXC5nP?=
 =?us-ascii?Q?EWUQwREhvK3pbsXMKdKVLY38Swr/p0ZFNlI5nutl1AeGgsGlZZP/MnWXz01h?=
 =?us-ascii?Q?tAxoK+LsS/OKBUpCEPs4HCl4DmjCoH/H/l+15+7KArrl0zo97MEhuwud8WkL?=
 =?us-ascii?Q?5QrPabV/yF7QSN3FmL2XK6sANoTl9lZcYA39e/VbLU9ZiNkiWvjk2384nZuw?=
 =?us-ascii?Q?l6w1Kqjeoc5nuNah9lnf7KuaXwUpNvjvEqW1ZOStbMlM6qpvCjS5bxob+ShZ?=
 =?us-ascii?Q?ejKnvj2LwoKCj2DYSXAaYAH/XulWmhHWRESEUAcpAsm3V0eoxiMUaXBAfqSC?=
 =?us-ascii?Q?RTm1BmxqHl91cDF2uW9sV5Y7LqFT/RjKvKFmoWVp4W09FPDFFqKKiJ0mgL8O?=
 =?us-ascii?Q?YwMZtLgU/WG4y/MmTJFPm2vxKOKc0+aSWRzjvjtUa+yJHMXv1Mz23EXWBQ4D?=
 =?us-ascii?Q?zpZF8itNq4y0BrPWtGDanFLpVnv/X0HiTuPAqTO1GfRUdmtD01LdtlTrlt9o?=
 =?us-ascii?Q?A4iVyMVKkGWyX75QD9/hbvq+c2zzknTD2gIEX+bWhJ4RAzod/EnBXaw8fTEG?=
 =?us-ascii?Q?eSKU8axovfKtNdIio0pR2DJxYixj7I5wLlp1XwGHeDFiR0w/xHLMu2UKHjuX?=
 =?us-ascii?Q?p8P7qg4lhyB9ATU/Qji9EdcOVWxSeEjWj0dpAwZdSCG/DPRa5ATrJ4RL3NM8?=
 =?us-ascii?Q?xidpFX4LBZbc6Oen3exTQEcZzgD7UK09Pwh/CwmPoyj+OI83ewzMF/TaJyd9?=
 =?us-ascii?Q?mJE6FLAMnpvkdvrHsHvE06Yh8RINEIQ0mU7E1fdO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67d55e3b-434a-4c33-23e4-08ddea2e133e
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB9473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2025 14:36:17.0218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7d9C0HYe2qybjMZxFWHYKjowIK+87AZ3xx/ncOmLlpIIQMUqKYT49ExjUcFni/Xp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9358
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EE7DB40014
X-Stat-Signature: twuyfqparxweyqt41ozfp9aziqdnyzo8
X-Rspam-User: 
X-HE-Tag: 1756823784-870587
X-HE-Meta: U2FsdGVkX1+O+AIMKcizKBHF9KyHoUKgrV61DJs14bSMdsXSHmQQ+bEgJOxL0xMRl4sX2orUkgU9TWCHggFUwcyirnCd1zWrFfLmxsuML8fvARLCI/ZEWk0Moqfm4FPgm6Dwm+BypRIvHo2ECxYqYw75fWjZfzjIhVk7n78Pg5nLduihVUdRdYzVa4ZpmTbWxGTEgdfjTjNFEVdrC9G2yBvEr5nl/abl5+/n2Uo4reODaBSo63zlLEfcASdToaB1dTLyoM1AwNrLAaRJNt8KLVzsvzbBBDB+xUeKMDW9xFHKbsEf3U9EfX0TTXvXBUG7dTY3i+XLUVOZnzh7Ytmzu8b/eOA2/Rvf0CXfycb+5nwjBa+j+32LOGQmBhdnd8w5FftiAwsA9Zenq04FFm4JEoqsWJQC41hO8ff3HQNOQAcGlubZcTmi86G4Ra4ElE+ytEi9r6Dv2dwJB2zAMqDR/rsS62s0JFeDYuKRv3JRG5qqwuGQ/UvhB/oCasCVaWJW9LhBN4FCXo0rqp8OGou1B6QlQ6UxDi3bqc8xBe2Mvzy9EvfdMtRF7EF5IAcJAarEe3PWzDB0BJI+xyYWDfckstGm/HqpjkDzyrDWjABr2kF0movut0//lYPI0hVqCDcyZA9Vif3i0gIvaXuRTmrHpvyvdBfPNKS/6bfcD6X8hLzIpxTIsjSQr3l0IjUdzUy3gBVCXhQBiGeOANQhh4955XEm5NaOHKnX7uRhSJM45sptCMhmNfgAaGZGe+GGmD+v5xq9YZe/0RnRIqNNFUK3GyU5dfFVI1UfhFscj6h5GtZXKczOoba9BRFFK34F32IsaOAJYVIah4pNkDA8So+ZmgLRTwKpCRG07eepPGFHmjaTzNAQD/fCdzhfrUVY35XKqzoM6u8tZGjz7ii8U8C7eYazaKqkT/fZ9uEbNV60w5PhtZrUnNHud5tuufX/q/oe9Phe2hh/R+Kjc5fOd7q
 aAnJJO8t
 eYKNOx4t4sJvVjQUVRu1WIV+0dHJQ365qiBj7XcfnFvStbasdNRl88uwUJSsgR6NidaVnl/dHr8Gw9G5iStpvJgKCnbBy+06vL7e1cFBaocZY7H5qY05BunSiDeYfBjKa+LyYdYHgHM09fqfjslWLyPBudRDfcdy5fh4uI8rciV5vb3e6Y2Ur+03K7B3Fd/4jARylOMgA/OdL99tUnoX7cTzZyfKoa3LchYt/JYTYm6sYZj8UbqAx6k6IFjWGE2ccKmRUzXtb+rZQhyp6l4f8NokHL12bkv5aXHlwHmGVYScs8irr30n4y8Uoht4eWwl/Ghoji0utz32qS5BQjlCRjYV76yoy++Po0eRUS52vWFVrm8Jawj7eZGJjihpw6ycoDda4gmtJR4+7p/DIe9KU5egvaF2RlIDRPZpQVgTvEWDLBGPv7KBNH8YF6MfJ8vyzxSIn7VJzJSHzZTwn2QmX7IfMZmmrJaDiSRRZ75J//h9PRchb6OBVGtCAJSEtjK0KOGmR3NRcyBR0eKPAV/WqQJiOczWdnvDj6O/v0UZHasDxvfpO7ja8+0mE0Ni680Kys00/wRI4v+dYpguqjod9g3DNB2pRWEWsMPkF5N7kEBvyuiXavoitSxBzru8PLes7UFpzgFHbkwIdfjJ+wQRrZfT71NgIoBycnbNT5MiEt5/pkd2vAREroSnWre18UkvjqpXcyezFk1Q5xh+jdrUZ9v7CojxxIAIO5J/cNgHVk2+mgz/pkUi9HJw+maxx6TszlqSn7vifNCzpepfzngoYiMs62Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2 Sep 2025, at 10:33, Johannes Weiner wrote:

> On Tue, Sep 02, 2025 at 02:58:07AM +0000, Wei Yang wrote:
>> We iterate pfn from order 0 to MAX_PAGE_ORDER aligned to find large bu=
ddy.
>> While if the order is less than start_pfn aligned order, we would get =
the
>> same pfn and do the same check again.
>>
>> Iterate from start_pfn aligned order to reduce duplicated work.
>>
>> Link: https://lkml.kernel.org/r/20250828091618.7869-1-richard.weiyang@=
gmail.com
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Cc: Johannes Weiner <hannes@cmpxchg.org>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> Reviewed-by: Zi Yan <ziy@nvidia.com>
>>
>> ---
>> v2: add comment on assignment of order
>> ---
>>  mm/page_alloc.c | 8 +++++++-
>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 07d79ae557f8..5d9ceca869e5 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -2033,7 +2033,13 @@ static int move_freepages_block(struct zone *zo=
ne, struct page *page,
>>  /* Look for a buddy that straddles start_pfn */
>>  static unsigned long find_large_buddy(unsigned long start_pfn)
>>  {
>> -	int order =3D 0;
>> +	/*
>> +	 * If start_pfn is not an order-0 PageBuddy, next PageBuddy containi=
ng
>> +	 * start_pfn has minimal order of __ffs(start_pfn) + 1. Start checki=
ng
>> +	 * the order with __ffs(start_pfn). If start_pfn is order-0 PageBudd=
y,
>> +	 * the starting order does not matter.
>> +	 */
>> +	int order =3D start_pfn ? __ffs(start_pfn) : MAX_PAGE_ORDER;
>
> This should be __ffs(start_pfn) - 1, no?
>
> If you have the lowest bit set in the pfn, you should check the
> order-1 buddy to the left first. But ffs(1) is already 1, which means
> the loop will check order-2 next.

__ffs() seems different from usespace ffs() and is 0-index, so __ffs() is=

what you mean ffs() - 1.


Best Regards,
Yan, Zi

