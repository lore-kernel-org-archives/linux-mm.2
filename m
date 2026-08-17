Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1FA8C5DF66
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 02:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35516B08DC; Sun, 16 Aug 2026 22:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEBB46B08DD; Sun, 16 Aug 2026 22:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B87926B08DE; Sun, 16 Aug 2026 22:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8192C6B08DC
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 22:34:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EC0C7C062B
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:34:43 +0000 (UTC)
X-FDA: 85109193246.02.A4D4F69
Received: from TY3P286CU002.outbound.protection.outlook.com (mail-japaneastazolkn19010016.outbound.protection.outlook.com [52.103.43.16])
	by imf13.hostedemail.com (Postfix) with ESMTP id 12B9A20002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 02:34:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=kme0ZPq2;
	dmarc=pass (policy=none) header.from=outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.16 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786934081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=71OMoiKL8aO9tPcT379r3D2MzJdi2zvLvoYYbicLe9Q=;
	b=2sY7Q1ZbwL7UvsrgeNPBhAn7ZF4cMbUuDSXZvPrpm8b5M2MvWVl7aggda0Q0CihWGNh9l9
	b/mrsEfzXycSr1piR6LAkL0n38ACe5v0YGHPC1A8vWL34VJXu4WvuWscmzUjhNSiIXll0H
	J253eLmwkfjdpDT080FZ7CspY158k5o=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=OUTLOOK.KR header.s=selector1 header.b=kme0ZPq2;
	dmarc=pass (policy=none) header.from=outlook.kr;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	spf=pass (imf13.hostedemail.com: domain of seohyun.kim@outlook.kr designates 52.103.43.16 as permitted sender) smtp.mailfrom=seohyun.kim@outlook.kr
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786934081;
	b=hBHyxkQkgDh+NkdidfmVY8QfCe73QcqIIF7LGdqboZpfambKV5qxGYKDc3w1GTlcEzc8pR
	hKaxIRoqa88BC3MOvFX0H3yxfyKFtLCYpWw6fdMsEP5mKZo8bRb8820PfVL84AmJrDuhKu
	6GcIbvOMDF9uSv0PkU/8aXS35i8ND30=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wwS4HuKb6ZyVKfVO31+K6BrNuYGfXNhFKFEn/uB49uGoMSBZ4nssaOMon1JskjXNVYdD1Cz8CCr4QEfwIhLnSHDnlmDeY4Osh9kwFBp2fmG7jIiIzl9tRfUNA09ORR3IObTRYZKyJLGRBUgNJD0DKtZMIx2BR4pQ6Q1r/BwzYIPYFkWXA2O1XuAVrjYDJfh607ePB2VEXKA2yyF/bcVOEjVPRsft7ffWso5D2yNTGVUZMq5qlo9niLm+KOKNd1mvh6StEf7NvrT+ayV7QcMS4XB+dAb0odpwIC0y3Bm+9dJ3SGFwClKUPXkK/dwbGb4oy7c+2HUmNLp9ro8WGOvjCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=71OMoiKL8aO9tPcT379r3D2MzJdi2zvLvoYYbicLe9Q=;
 b=M66FCMmubQSZzNe0ZQcH2Pfb0dLAII3PyFJd3ptMq2TFrHW7c5AAU1zou+QBmxChX4LBhoxt3L/LgYtMIxK7z+SnzL18FMqWw0n9WCAq70qAPPWgpWWe1F1UI12CN6rOiYqocYW5/+1ocHr45pnadPiRtl7R9yIMdldtuVgRB3FjaLgFxmWW8+TJ7FuHo/ZB5spV7RHfpq0dBKNLvhMA9k3KPwtVkOMzKL7bJiKnStFaYCq+63llrI6BVxDbqBQh1G5WTzfSiQlcOTE2q14+e9SGZ8jkG+X/EMPI9xfq2Js41sDH/ZkuuxF0dnoVX1HKLnz4vKmr4gyf6G/NvxX4Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=OUTLOOK.KR;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=71OMoiKL8aO9tPcT379r3D2MzJdi2zvLvoYYbicLe9Q=;
 b=kme0ZPq2XLmfdq8KPF1utP6YpmXfQT/wYtm9Lb7gxgkrL72Vb7PSbUE4vdWu3aoSUs8z8VJM4YYQIh9WJicOJ+HJ9IUNBeaSVvxGJ+P2/4IDSMZLiEYBOcFDwMUOJ5K7R6nPbBFLji0VEEZdtgq9WIDhiPRTGn8XQy4fCCVMrsFdx7h39vKV+5Ok7eg1q9fb7Ri2noRKtWdoIrFWQC35j08us1FbBOwcCYGsNzIOoPBOdxI2Jd0LiJxrozseRIUgX2tUCcmpHK8VBpyEExBryrqlJPa8yHSsMsif1s4I9m9zMcQk8M7YgzFRNyVjd9dNhWqO6yYeoxY5hyMBhYXbvg==
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13) by TY3PR01MB11113.jpnprd01.prod.outlook.com
 (2603:1096:400:3d1::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.315.17; Mon, 17 Aug
 2026 02:34:33 +0000
Received: from OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc]) by OS7PR01MB13914.jpnprd01.prod.outlook.com
 ([fe80::641e:83cf:743b:85bc%5]) with mapi id 15.21.0315.016; Mon, 17 Aug 2026
 02:34:33 +0000
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
Subject: [PATCH v2] mm/rmap: synchronize lock and unlock target in anon_vma_clone
Date: Mon, 17 Aug 2026 11:34:04 +0900
Message-ID:
 <OS7PR01MB1391443074B4A2A774B7A956C96A72@OS7PR01MB13914.jpnprd01.prod.outlook.com>
X-Mailer: git-send-email 2.55.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SEWP216CA0017.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:2b6::14) To OS7PR01MB13914.jpnprd01.prod.outlook.com
 (2603:1096:604:36b::13)
X-Microsoft-Original-Message-ID:
 <20260817023404.6404-1-seohyun.kim@outlook.kr>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS7PR01MB13914:EE_|TY3PR01MB11113:EE_
X-MS-Office365-Filtering-Correlation-Id: 3bf92f7c-5abc-40e3-f111-08defc0811d3
X-Microsoft-Antispam:
	BCL:0;ARA:14566002|5062599005|15080799012|51005399006|19110799012|8060799015|24021099003|23021999003|25031999004|25010399006|5072599009|40105399003|2607281247196008|440099028|3412199025|1710799026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?QMsqfoX9KxDDg91mAoo56tGKd8tgtC6uNvsYnkSC67jyly+DxBwDEDsgAqga?=
 =?us-ascii?Q?hCjo0iaNKBHulIZdmyZhNUQrnMiZoUg22yRJDOYOHtuRp80RZq44Buaah1qp?=
 =?us-ascii?Q?RP2gwgRj0VOzs/dh3iogyeneu3zySjIaQ1YfqLMX95e2qrFbxyrWIOXPEiLh?=
 =?us-ascii?Q?vPvCQHFnwDyvOpWgZgJDkjxMHRHnFtAvCRexKTl3mVcljaMHIAJVHycHBz7L?=
 =?us-ascii?Q?Wclpi2EbmlDjAbbgdl9xpIsQHupr9GbwVJbXOUEF7SFOvjLQeGzov8ze/krv?=
 =?us-ascii?Q?8DK6BqBuYtDflTS+m6+keTNIF8F2bmy2HU9sOnm4T3DfnKqhaNwoS/tOk9VA?=
 =?us-ascii?Q?Z89Ipq/3j3sGtiS/GJopzP7kZNn1h4ktyrapOczu17sMgrX7q08+ZUUwIHGB?=
 =?us-ascii?Q?C8D0Qvn5LKLunllYmIg1pHnlcyKvacCT6fkw4VMcZJFwdczbmDfAfVg84RmZ?=
 =?us-ascii?Q?oWrwp+dax2ISk2mSiRaYpTuQUeOw3+1tTzi4389a/iAMwaToKf7pLU6Ca0Gc?=
 =?us-ascii?Q?3hJkHJDQz1OLUXQPhtb4LGXQYApBZ9Qj6b9rUgC5zohJLwZclUQzB94HOIIm?=
 =?us-ascii?Q?lV4tpxnOwDxJ37mffMCBbKs1Ve+z0lNDR1/h/ahvisLqiP6ixqmSBPe79/09?=
 =?us-ascii?Q?Mfe0HhTp3jf5LS9d+iiU5tCIDKRG5d9C0IMaZHCdnA0bdtXX/np+LHL1s6n6?=
 =?us-ascii?Q?qxbKFO0OLsG7Xkg2pROkLeFNNvQYVybRbpYGgY9GyH0QYB/CDigK+wHsWf3o?=
 =?us-ascii?Q?8yQbK2QfQ2PMKTNASsFI0QSvHHrOqnW2MbVwkyZfpngRoivnYhmFkfZaFEwT?=
 =?us-ascii?Q?t2MYWRVk0H8gsyQLISQFi64rlCg89ikhYe+wxVF0GiFxSRjVvBaZ8VMGCHpQ?=
 =?us-ascii?Q?yA9BL03jyHTk0peUkJpjmwCBqvvTOihGGJV+WPBygVSEfI1S+NO9xe2qq/aO?=
 =?us-ascii?Q?fvv3l3f1lA9yNR7Ji1Q/9iZ2SMNT47BsrkYQxG4Nd+bIGj22xCHPAelRzAJg?=
 =?us-ascii?Q?MR9TKaT8c/Yg2Q4k4Bzukv3dEg=3D=3D?=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?4c6QD3bbF2Igv2L/ISQ6XQ4V4VJ4XkDaQo47in5gqsbSuoWYADqnMnd8CvEJ?=
 =?us-ascii?Q?HosOwvjeLwCxO8FXYTDwgSiGBBaxYeM+6eBNfhkROE1jEPxOuKGK7v2TCy2y?=
 =?us-ascii?Q?Y6wB6MZ9quZZMTYje9K28W0lNSyCshfrKx4qE7BbviAmwUBbo5U3tVRX5veE?=
 =?us-ascii?Q?0+ubEcey0i4W3+qiyVRBrogCzR0qtr4fh0F/q0YOrHhDdn0GXcwZnGJmS/U1?=
 =?us-ascii?Q?NgTz3C4cPL8hm1TOBi1jZfwpk9iuuykojRAi9tw81QjKpDkQwFLGHYf4aXcR?=
 =?us-ascii?Q?GM3LTFOFb35Qe13Jut4xcs98ddjI31nCR5l1eNYIjr7mp1E2Dar1nbAe9PhD?=
 =?us-ascii?Q?DJDB4Dgi2fFzOdfXtUYsiRZO5Rd7YQenaTrftTVSORBYl4BKi+QLX96ASGOF?=
 =?us-ascii?Q?sn6xN3CrImdDqAOZDIftdKjHJD8uMKSbaeLutnTc+HcrQ2p7/vDMAzPhIStQ?=
 =?us-ascii?Q?pAYsyL9p11Bb5J2QmNCnEArKlt61fC/0PIPIg6UjAbth8pqa4zJpXU65spDj?=
 =?us-ascii?Q?e9GMxRuPm7VuAu2uRA47LUWl/PUM4A2FOp+4cUJ81hH8l5rVjslIViP+0f3Y?=
 =?us-ascii?Q?2qBipTghTz29BfamxJwx6OoA4nxjWIEU0+iDFOgg6eZ9nfb4SF9CkdojX5U2?=
 =?us-ascii?Q?0nLFhXgr3wWJj4mXY9cCQfEM14ROZ424w/PhY5tC4CsFyXDdFRpu6aDa+c0z?=
 =?us-ascii?Q?W/MD4vsEdLySNaNwg/RJ1FQrXcJz1oZvTRl9AOB2QGxugmmcB+lwmorIy+pE?=
 =?us-ascii?Q?xBuV+FD9plpDz66s5JmZG2UrFCAfKcm2C3IbjtVdeaV09sLN+tyDMZt209wx?=
 =?us-ascii?Q?Cp3BI1FdY1Pdw4LE4X3guxDQ1c76NJJF6nzuo/YjBNBfCx/flfRtyJgx5wd0?=
 =?us-ascii?Q?I3xLBGtRJOM4IsJKpyoajBYf1paTofTP66oAhIg21Bhpe6qlC4ZYhgYRNmwB?=
 =?us-ascii?Q?GFM3yjsHuOTgkqbvT7YWpnRHp3QYt2lrfBB5LqX/de5NsHMBg+8yK58nGE9l?=
 =?us-ascii?Q?NYu5jqTupCXesZs/c8sPVj0wrxOS9sH8RgEgcQGPqc3WkHOy1R2q+4ky9d66?=
 =?us-ascii?Q?XzshjhmJ0EhD4ZvTLa5S+R9XuKn7nOm/zBaaiFukq/bZnEZkU7QLGOQ7xrtO?=
 =?us-ascii?Q?PuFLGj9iHqiFhPNOlaaJXHmbHinFDZhqHz8YE4cejwFfWJzxqdYPMec2QE1y?=
 =?us-ascii?Q?lU/Fc7P2H57TkRpVOaTWB/oAxiN5MUsmZu6jtYY6UzkroeIrrKBl5R7JKbzz?=
 =?us-ascii?Q?0kzslRSZE6k/qay8sJQseuQUnjrnHuw5RNf0KHmcFBCg4XsydDzjMkJhJqeV?=
 =?us-ascii?Q?+dNuFVDPyC5AsvDzyxVNcPkDzGWAX6uOmDW8LTaRBW2Td6w9p4xhNF8vTsDh?=
 =?us-ascii?Q?2cvv6PFbuY6v9gNeDfMGLpgRg7OW?=
X-OriginatorOrg: sct-15-20-9412-3-msonline-outlook-b83fc.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bf92f7c-5abc-40e3-f111-08defc0811d3
X-MS-Exchange-CrossTenant-AuthSource: OS7PR01MB13914.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2026 02:34:33.2131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg:
	00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY3PR01MB11113
X-Rspam-User: 
X-Rspamd-Queue-Id: 12B9A20002
X-Rspamd-Server: rspam07
X-Stat-Signature: aznco1s9cxa8cqqq69pmidfzwdi6hagp
X-HE-Tag: 1786934080-86082
X-HE-Meta: U2FsdGVkX189nd93mQkBp92eAc2+4V9yqJTbiOaArVqf9eT+qrOanvfpwvGNTOE9ucRG2MXb0m0RbJLPOVJulewxN2lGbnQrlCRGDXpjg32Cnn8IEZe3zE0wjM8fnlHN8VgiQccxRx/JUZ532KUj2ADyAktyBfIvQPtL+VnaU/PDHKSPs+udVpihi0FPRXrH53srnyqGNzoNN+GUcW/zwCJqrrT4d8mIiQx7J37d+1qEfeSJPTdj9tm6Vk+/k+LFHvpr52EhRd+eKPsS8zm4F+gHN83zBq8uK1HK8oMibUBaCalqt0pyI0NT2gJC2Xh4OdQrg9GXsDzE71/e1+RVPpIJHjX3AOwOGfnbm/JMY1UOwnWAyXUqjKPRgLub2fl2BiPVp9FVgM7gir1PlOytC2/h/iL4cI0ghuXARAcHnt0WcnIBCvAbkMA8zcA8T2qojP2XOk5m5GoVQOVt8kUKIbnGKjcr0HGWKJ5q+lW4RVfL9rr1yfeN3iKNld/N7JjI+3R/RpBzZrI9azyA459E8rAl0Q3lU0OKAeXvE6QwjUwsyULLjIfyf5nKtCSEu/bTvl3VnA2ZqqetFtR1x0+N+yxnEbe3lYLUUo9zWNYGtQXWqfRvsNr3UCid8jLsi4Kmo8a0WyYzwtHTsO866mwNb45CVRPXAuTzzZFdwyktLFFRmC28cVlu7yneje2OzaBLnYHO6fQto+8CJxIAqEtlludUAh2nrXK+Xo8kgicLrSvIS33Po1+4MHqPwXRXsg8V0ilSYYr1DN3tdqypnYf+jIFo3sc1RTR3s8fXz47EANxXnuZd8RoznplU5PzD+Hg6ZA++5PbGLGPFg83qRapVkJclHggnzvrzuknzEkyqsJCmRfj83+PxtDe9/4jIZkq2XMJhPBiJ8/He4CMSORuM3eVPtncu9urKKJYgIyGnNEDLyiWjkBfpOKY5q99ybQpcWGLGtLa2m1YNu0w/XqC
 48TMCge+
 redcv7CZqTJNlq5XB0ajxJry7Qnhz5tBOtbvkQTwfhy3mvZeVhVhoTFZ2t64pEgF7NVkbwaSaAqv0TLGHPqDDGKvbImNZDf2qvB7jZ8KLMxxYrCCawD+h78kogPXzzIFbA65NaofwZ5i7KaZwl/emn81JcX3v/3lf0vfiC5OIRt9TeprgvFXNqCNUvX3wRqj1UUxWOwX4pH3lxedbvupMPyx1mum/9tODm7qah/3k7W20hxsZobsE5ON2qW0LTzH9lVEveLzil7sWAwF88g5Bnwss1v+UXV6XI41VEq5aKHvHBllXMyxFVuQs8BxKwrVk6kD7c2Ji0cfFU74wleh5PVAqXVEmuR9v8aBgeC7xW16HpP4DeJfjeiRPORVV9Pg0wdoajezmyprbOUeB+xs2ukScGv8XcksoAvcgYJJOhVc3KQCAz0GuYRSXKxa5O9T2zyNqR5rgYXJNuCyIpmbYCRDMZN9qWrlO1ZehYH5gSkfI7cH76tKhpJv5QdaXNPYWVbGZjh+WifRZEitr172J538R9w==
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
---
v2:
- Clarify the commit message to explain that src->anon_vma and
  active_anon_vma refer to the same anon_vma.

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


