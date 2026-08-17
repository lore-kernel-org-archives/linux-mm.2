Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 705D8C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 03:58:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 791996B038C; Sun, 16 Aug 2026 23:58:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7411E6B038D; Sun, 16 Aug 2026 23:58:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608736B038E; Sun, 16 Aug 2026 23:58:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F74B6B038C
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 23:58:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D23040680
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:58:11 +0000 (UTC)
X-FDA: 85109403582.12.34F3F5C
Received: from OS0P286CU010.outbound.protection.outlook.com (mail-japanwestazolkn19011011.outbound.protection.outlook.com [52.103.66.11])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4F9F720003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:58:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b="iiW2uoK/";
	dmarc=pass (policy=none) header.from=outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.66.11 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786939088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=upIgUJmKeZ2BJ/JAE9XW/qy6aNP9YrzMQNe+zn4sJNQ=;
	b=d5iiw8avI+hGZLkcpjUmOcGdlni1lmaBFy7x7OZG6ZiYlK+IbHgfEE0BrtZ1YZFEnrBf84
	MtonAdIL9uzF6iT0c6UeHBlrqyldITN2GVexCF7cSa7Iclq4/HvL4oI7bVH9+BkB7aQo7V
	4Ce+cJo6FdM+sU908hLNmXiZ9ezNhUE=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b="iiW2uoK/";
	dmarc=pass (policy=none) header.from=outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf31.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.66.11 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786939088;
	b=fFZPN5n5CwLWd6VtABNGxwkKmIzvGrb6ky0Ae4kzsmdnz80fee2aHQWTW41CVEFu9OM8mr
	FngHXa7q0sgMHzk+pirSEE6KgGzNXigub5tX9dDNhX5nbOu51aQao0HRGUiB0qhm+Tc2+G
	2A5j0/th4dhEIJubrOs6y6MV2/R7BjQ=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ADUbI/3Rd5BrShnUSoLJMgBnbODIpOy9nJnAOBiwKwMjU/Tvnjn0Bu655jCcOYtGvDdOlRU2hMtTCMi2YVLstogaQxu0/vlGbCip6W/BqvxSfCrDM3bSk80drmD35+PzCfMVZQ1/R561bOtJZ4EpXnO/AlW522dfmKjokoFxu9Nk6TU2fraykMwyHBYYQCYnk89SfIcv2PD9Fg3rGpmh2IyW/afz+xTZPKK5dPYfd/ImH002XRatZ8ZiC6Qq6RDaqSe6AXTBFxYGpALIvhhZ5sz1gPwoTIBaHOIEokdqXWlhTSgdX7J/coYkItZWAKxDys3AqywvP59KpsL4psf0rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upIgUJmKeZ2BJ/JAE9XW/qy6aNP9YrzMQNe+zn4sJNQ=;
 b=YzEYt9Yu5w8vrZiWipKQDsOfJFQFA7toAhfxOTYYUh3CPbqGT3nfwRvhc1LBssopR2H9Ltl1NmbINuxZDVSk2Db+MN6D4OprmZKgzNOhdKhzk+yHCEZTJ7W3F2NESuVqOqpgduOD/F9qw8N1Z0tqQ/yc0LieH9xqorlPZXf6jIPwOhXJavjLdQoBy5624z8pKkDAPeRRSDO0tmpRvJe/S6bjlxVo5D4HYaUl/qbLdmQX7SIn3q3hOVIoJI9+im7lCkw0CrrPlFqXwd2v/svcxqrkOWzlghLCYPbBlXX7EhoWfCOUFC6n/IYBiFyqhsffijnJcH68zkh9JITV94cQKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.KR;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upIgUJmKeZ2BJ/JAE9XW/qy6aNP9YrzMQNe+zn4sJNQ=;
 b=iiW2uoK/xsVCJSOSU2XUUaHPZbQ8fykyTzlqngKZKMsaGBg5n6Y9+aUr50z7xgfVNjN31DxP1cOj7ePUBzdCYMRsrF0AdeefkQ8IYtp+zmSB39XnvBx0AzDX1vvSj8pWcoMwhxznCR9b0AAksfJiYV/SkbjzvMazT2wGA3W56Em8M9NzsvIVnx1uUj/6dtWMYBT+YwBF70qxkurUNJxe16nf4tcwPArb60+uOINBHEMYzhZQ4IRIUbCYBAfBFP54NQEKo2CqjOwAg5X59hMmzZI+CxhAeNvI/EaZYCxCJB+XMziepAIE7JKt8GXHKEHHxvIqHcqGgZvV6GHwtsBHIg==
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13) by TY4PR01MB14562.jpnprd01.prod.outlook.com
 (2603:1096:405:23b::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 03:58:00 +0000
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc]) by OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 03:58:00 +0000
From: Eric Kim <seohyun.kim@outlook.kr>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Eric Kim <seohyun.kim@outlook.kr>
Subject: [PATCH v3] mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Mon, 17 Aug 2026 12:57:42 +0900
Message-ID:
 <OS7PR01MB13914A5991BF648E81288038E96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SE2P216CA0098.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2c2::11) To OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13)
X-Microsoft-Original-Message-ID:
 <20260817035742.4774-1-seohyun.kim@outlook.kr>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7PR01MB13914:EE_|TY4PR01MB14562:EE_
X-MS-Office365-Filtering-Correlation-Id: ca325dbf-2e70-4c8f-7335-08defc13ba91
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|51005399006|15080799012|8060799015|19110799012|24021099003|23021999003|25031999004|25010399006|5072599009|40105399003|2607281247196008|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?qxpe+Jhqvuefn1ZcCGE2G9CEZRiBkEc9NIYzyJZjMZCKaC1qaJgx3wtNHfiN?=
 =?us-ascii?Q?/9gODQD1JzphfGiU6VPySh4N+iq35G7kjEnF4O1wlo6fXLiaTf8e+XXlilI2?=
 =?us-ascii?Q?MvxIqKG79oTa9QR897YASZJrDNRcwpb1UhGz6U8sNvr5CEtqxD3c4/EFWypA?=
 =?us-ascii?Q?XG8OTRr4mn5KIsdxOaI/io6h+KL7mfJ3yfkLCYdFTElcv1mRQdB4UG1emfI9?=
 =?us-ascii?Q?29zb6Zi9YxhGBhDasb6A9hFw8i5E26YFPrQTzikMM28YRdnC/OQSFDSqIguz?=
 =?us-ascii?Q?x+E9sk168Oo4mVnKF5s1jud13NkJzbDRZio3pRwp8OJeORLKNlnME0HHBQ31?=
 =?us-ascii?Q?zamvYfyqUUlvblBUwfQ6Z2PRR6Lr89w4CxWcVBh2nfkl/h5EKloa6fxaIqNp?=
 =?us-ascii?Q?7lGQPkuUxGQzxPMv/XQlpoUbGWsgNW4lLzETUP8fZU5qlIXt4/q5lEazp3fs?=
 =?us-ascii?Q?Ice4MMIKXx9+9IXaKlFMaSOpnV62Jchbb+AZ7DD7w4/mXj+cuuZTHKLio716?=
 =?us-ascii?Q?GPBspBpuwCY5+1BDIffPYPh87ZDwBxps0ZO/QmbK0ouzB1jypKWJQFE+JaI/?=
 =?us-ascii?Q?cHo3ee77FFCOPeSYHR7QIisUbneBaBC9Eee8+Hdv8c5xNQsJna+3E5FFDtEK?=
 =?us-ascii?Q?5PJ14qNoSG8bMJpz+oFG0mMkmC/2zDyea6B9VNk9stIL9h1+I+eP67IfFM9L?=
 =?us-ascii?Q?bcA64fvHRkLSev4kqXPkY67HBbUXKLCZJ3VPzp9iu2f8of6FBntQ3mhJ+qTW?=
 =?us-ascii?Q?dhJgRFBIfA6fJQ6rGe/aSFaBCbFXNxclq53a7nJ7jyF0iOOmkAJrSj9kr18z?=
 =?us-ascii?Q?qrwDQBWf5o2of3omzHxE3N9TeVJkrk0tYau148sOg5qtVCtaSsIOJz75MuHj?=
 =?us-ascii?Q?FjYgEnbhwx2zJ3ZdjrO0AnxmoNsXcnjwvQfUHRrbGtFKEQMnOJkikc/xJbh4?=
 =?us-ascii?Q?N/+3sRQpluCQFU+a9GJTGasbmGRbECf7OSaHoHiiHed6YPSe9AwikUl8bqF0?=
 =?us-ascii?Q?TC8AUKfQlCr3RUb5xpU69NwRUg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Gj2RJzyJd3Cuw6VI9VG/WGqABc14usarOxkCwE943WeoNWe1487VL73Vj9b6?=
 =?us-ascii?Q?OFsU0MCR6P51GAtZsN7YSeBI9uxdEzfuxV760fQ37cLhDgGnv75eAbvWgo//?=
 =?us-ascii?Q?uwflIwuIgEsFpK5/TAKknHLgpWj0YQ19fLbhm3d7pPVqMpnIBwx2B8BNbtVn?=
 =?us-ascii?Q?76aUpibGFC5mAsOKd0N4vekhHURTJgSf2rsHNL5k4Q6bpPRip7S8/OtxznNa?=
 =?us-ascii?Q?kU/9k18cOApJk7ejgttas+RnzZF3qq4h7z4SET9+5WCswUkIfMPGv9h6fhCE?=
 =?us-ascii?Q?g1OTlncjjITtDH6a5a2bWWPuXnGJRwL+rs0P/VON/EzgOmj0Xnwtz8V5hUU4?=
 =?us-ascii?Q?GKWpA2hy7VRPQlxKPPN2fT6HtHr/dydRImO+Vfeg3hOJADpMsDhme21liuBK?=
 =?us-ascii?Q?YJxuRdmQXF5E5YH3pZslf099Lk0NozsYpoZUQ4aF3iD4G38RI31EA9FLeamr?=
 =?us-ascii?Q?Twx+M+zehQaA73cg1hKzStkMyZkbqp7j/8dUVZQXnpxq5vXNXPauboPPTuK5?=
 =?us-ascii?Q?s47G3PKWXzFwE2KFq+CdEXkmVcG6WTvt7C7xYXHnG/edo64Tnl2EpvfQp8B1?=
 =?us-ascii?Q?OSTOdh8FfyNAb5e7CLQzd3tk53/jzNBubo5DmFLCPji3lQhCRd20wTJc98UE?=
 =?us-ascii?Q?/g93rj4wTVdt9n6accId7EXjelF+X7WtVMBBk18KeRQfKw2kZpuWiiEjt3m3?=
 =?us-ascii?Q?D2CTi34uhBNrY8jw+Hj/0jm7tOraOAQVXEEvaHJ3w67EO7jNvubPHNVhHqnv?=
 =?us-ascii?Q?OsZeZ7pVecPnWV4aPzCKsClRX+OuuGLtO6Qep11OymJhyldI2ZQ81HHfeTJR?=
 =?us-ascii?Q?1nhBSqXDoBGqd46oZ+WD+EsrdUzT8AIQe8bCUO13IpJg6CPu5tbkX/3jA/vO?=
 =?us-ascii?Q?SzryqIA+OaoY8BkyuVZ0YxgaPXSr7QcginFGuMSNZ9OsD7wrjIsGTDGCdx9u?=
 =?us-ascii?Q?qT6bJP83VhEtzcAm26vyiBAUubLP+IMhXPnpKeCcKQZPzCNFcb5UXjJ9kAeZ?=
 =?us-ascii?Q?TIJE7ciOdtRojcDaUWaWlEUygn2geBUQbI+3Mz4IuTm3ErF5slo6fcShsaq5?=
 =?us-ascii?Q?DPgQ7DOpD2xdYRcBmkiy+LJNqv6ujeDXn7RqnrOtemFVtEvTCUUBwdI9fWKJ?=
 =?us-ascii?Q?JjyAB952F/US8gGQw0OBxleAbX4P4ApEX/xSAQf6BIct4VzIlPxoMrsfOYjQ?=
 =?us-ascii?Q?yxn3Iv9f1vlZHlLttC7+OaTvrf1f1/tDjKwPWgip93ELaegkfcyZSsWkljl1?=
 =?us-ascii?Q?WepT7sRXbHGsNnTxgFZfSS2Dk8o3BNNO4VAperOS7I2FCMBX3xS3rNdq5eHD?=
 =?us-ascii?Q?Ok+WMZJdrxrxWX4Q/iWgyL6bVKbAihlp9VkZnJTDsjL4z3lDuVhTZAyeHEoW?=
 =?us-ascii?Q?uP7fAcN11cOgGxNer1L2FgHYE7ks?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-b83fc.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: ca325dbf-2e70-4c8f-7335-08defc13ba91
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB13914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 03:58:00.2964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY4PR01MB14562
X-Rspamd-Queue-Id: 4F9F720003
X-Stat-Signature: gcco5poqidyt6gdg6ipjidksgmc1grzs
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786939088-560375
X-HE-Meta: U2FsdGVkX1+dzLJroHB2jnkk5HVwX3XLBnBi/24+h5MvuBylYIhTJbDmwIvXKIdRfgN33zSSK+VBFPQ0gmautAoTqZhWPd8VAZlHUWdreGGBYp1tgUvP4+jTHpWYwE9oWHXmV7+7YGJn8jbGTXRwl6dgcTIkxvQDH/zzMZRaZTAJieOJIVzgBFk631LYGMZW7DgPZVEfEoC4/nKRXWtoZUVQs0JjVHbyFFDR0eDTrmuIkpDzSgPPhCAJ4mitZWuROEOouMLBWukeUjEc499Ljb+vePdJzPO6TETtDiTkGObi38hBfxhcJOUzDVESF35QWSVhmPfMUTwKIuaGeVGcAPSfU1u/DZkK8EQ5bGQRvGcCPof8oOPWTsVwZX+F9O1gv6GFYxga6bjdYoNx4bxwP4leZo6aYvEQgTCbrT+MT/jks0psuqCrIweCxvh6H35LwrnvPzfse23Qed9abxI7vker38HgUCpRfuJyyFSR9J5PPRbrw96FlsAT7m6j0i+q80PDJoQOnCdRHRkLOtlwnwrJ23lX5oxlJc5Xix3fIGA1IHlMbmZGudw/iZnhVHpGtNr1k2uUoksf3ypU0zPbXsLd3MniI7h2f1jRPnZrGWTzntVD/xU7eCEydNEq2fCLd+XWp7tCZJueupzA2dSfyVyRNDbkY8GaLPN08RxnL1aOFcuAD2UBwPz4vB07P5KgEHqDqEJXwljT9BfZnwEKXBL5f/HRO+95pebTaAr9JPa+GqM7EJ3AJ+DD+fRXZF6ER9/hbRXWAkC0Xub4EDQYcCxtKRjUXkSmC9FDRuVCcu9TfI3ppBH4gvl/ouQULovjSKAl0WIAdSXvO3Y8pSj7DPuRqw1rJkJj0jvQFrqoxZOQ6oU00EAp3fbq3MywR2L6wJqcn93Na1mdRuQT4tSLwyM6j9H7x8Lm/bL4mv+oyxANsH4+duEDRetAmMFrIfg+qmskCDCqGl7dWtPwSEE
 Xh81RDk3
 1GkcRK+ZibDvOS7zuqjwSCZitLly0xVlqq9crspsnkIUP5sz72/wNlq5/oLCXt+hHR34fMVhgj4UJtkjpcfS7U2LIP7QuxBIcK8GTIjdVIVbKJvmTyxlIvxH7LteZaMeqXCCCkqW/iwNR/NLIrwDRYohDa8DPTWRU5IfhAfrwlVfoAtu0LauRfSYUk59an8nHzCPUEpPfeL/H9LxiKS2hTao24OW0MmBm0n0ER0bN4xcdxA9taanKFDibY+pLjrfoPlxfon4r82KBz9I1EInbLkz+uqbVNRcLXdMME/7FM0bpDvT19t3btPHJ2X7XMxybXZT28ZvbxiZV0h/EAh5LvLgMpDUGe9pn0Z2XGJs/Z41/nvLQf+au5j4ZMIh3Dh8RDrJepKWAT8jRLQT1nfKEPJvNL62W8xBX64ZMPuKtnUekdi4JpvLohBmn0/1UNI8msawYC37A65YjWgeAifppAEjmI88H1cmKyM4vHzWNSwAz/TNp4qtLQrgOdgHwEJn+LBP6bdlHIA5azI6m1VRTWybzuVUgyfRj9zn74fK2c0IPuAEHD3qyY38vej/9U/6mbktwakm8eAsIQuaJggbkOWv4GucKqhXVOTWkQeR0ZQ9j+8I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, in anon_vma_clone(), active_anon_vma is assigned from
src->anon_vma and is used when unlocking anon_vma after linking
new AVCs. However, the corresponding lock operation uses
src->anon_vma directly.

Use active_anon_vma consistently to make the lock/unlock pair explicit.

Signed-off-by: Eric Kim <seohyun.kim@outlook.kr>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
---
v2:
- Clarify the commit message to explain that src->anon_vma and
  active_anon_vma refer to the same anon_vma.
v3:
- Carry over review tags from v2.
mm/rmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..f3fadfb69c7f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -350,7 +350,7 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src,
 	 * Now link the anon_vma's back to the newly inserted AVCs.
 	 * Note that all anon_vma's share the same root.
 	 */
-	anon_vma_lock_write(src->anon_vma);
+	anon_vma_lock_write(active_anon_vma);
 	list_for_each_entry_reverse(avc, &dst->anon_vma_chain, same_vma) {
 		struct anon_vma *anon_vma = avc->anon_vma;
 
-- 
2.55.0


