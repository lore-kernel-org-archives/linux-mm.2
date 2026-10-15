Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC57ACC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD33C6B008A; Thu, 15 Oct 2026 11:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83E16B008C; Thu, 15 Oct 2026 11:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B3E6B0092; Thu, 15 Oct 2026 11:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 90E4D6B008A
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:11:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03F621601D7
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:26 +0000 (UTC)
X-FDA: 85325199414.18.B56EB0C
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023079.outbound.protection.outlook.com [52.101.72.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id DD2EA100005
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:11:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=ATIfl1Ld;
	spf=pass (imf14.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.72.79 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792077084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m9YaHDaEjEdehNiDleZ9euJiyuhEBWgTmpeXWC5DC+0=;
	b=NR6W478cMiKURtx9JVAhE2kd1MQNf9Kr521lk4Ko6Zo2loXd3b6YZu2ryzbJGw7VbyPC3J
	lRpFIR5+jWsvTOez+MIvbN1xgE0oEUswtxY7FFXNqLry1K2wCfLOGSu4u45DuIR5pokmZe
	59oD9ON7WuDNuCVI2RoJSIKvESHMob8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792077084;
	b=F0zXny43Wx6L5+yJg/pCcTsg3Nm9YTmeXmPf3lYINcn1Fmq3wGyjdk6jdv1rwck/irOklZ
	y4G/EKj5dqoFmvr040p9ZfL7WwX6OqrKCIKNhe7ue0JjKltrJoZAPy5dNPadrILGrkZ+X0
	oWvfi9DCaxmER4GAMaDxUYO2JDs8qu4=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=codasip.com header.s=selector1 header.b=ATIfl1Ld;
	spf=pass (imf14.hostedemail.com: domain of florian.schmaus@codasip.com designates 52.101.72.79 as permitted sender) smtp.mailfrom=florian.schmaus@codasip.com;
	dmarc=pass (policy=quarantine) header.from=codasip.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jjQuXIZsW7w85lh0uDFvYK+UvmhkpzKiWFiw2OC7XX0u+75SfwPca2GVRXK+Lm0MzwpQjxDyv9k9MNiJ1tcTl+AxwupeNpDYDliMR6S3YRPTnSIcg8pb43d50wqfxUVUMWOSZhqOeJl/HRfQbsr96N5sWseEE1VKKQnq7G11bemmkrB7wiPN30LIzCijJyFuXOPmO7vW90zJyBg+kUwTJz4y8Vixu7aIQq5FP3X7cLwoCKYiEY6RzuLM1UL2MAzqD9b3KIoRFWyon/DP+u8nof8Rs4YMMrTkPJ9CGM53wyC+oLCifk1jWYEngXanLPuAB1pJvh2pBqT/rF9FUdsa4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9YaHDaEjEdehNiDleZ9euJiyuhEBWgTmpeXWC5DC+0=;
 b=UjlUMxpS2pQXARaz9I1JTGnRMSC8EPOFQnr2WoOuITm38wW//9XInB4WAKIMNL6bkaLX89FtkLnVXDfbl5w2NEkmyIxA4A2Pbl1Jkd59/eDEV3n9VPCqeE7RftvW+dOTha/Y2jGuhB234isf+oLHuWD0tG/ddWtViU/9Ux+RvMPCdeCYs/ZtgkNZfXlgxLIiSszrrDZHADtky2SYrZpKBk2SJLkYtT+MXxI2/hkC5A9vfAl0iatZe9lpd5pdpe+RE4ri177ivbgPFdxV/6pwSsb693hK2IDaid7vtZ87BG7/Av0c6zGJw2b51ODBtYqeG29zAUm4/tsu0vtkMCT2Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=codasip.com; dmarc=pass action=none header.from=codasip.com;
 dkim=pass header.d=codasip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codasip.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9YaHDaEjEdehNiDleZ9euJiyuhEBWgTmpeXWC5DC+0=;
 b=ATIfl1LdHH7rY4CiV9y4AP4V+fR+XinH8MOrwcn40dq+K9PqhiBz7B/3sqGNlbkDr7quv4akvvW06qznSnMZnrz/LYX7NrFKGwKgsunez9ZFEUgPr3iqMim3F9GXpNZQ42Je88FLQONYyftyiDG5tVqapZAS3RcTaP4nCkAa1/iTkT2wSoHDrln3wxSL8DCmJT0Fc1Wumbq3yELgv0GgmG2hHxG60TCy1sswdfxlECJuHu5M3z6x5IeiWY82l0wQkLIs5yKRKwYSnE0KRv+vAqHWy4BCH2qWGTvsghDoFiVpq1KspJgeGXuD6QYi4tKc0lltK2/cM0vlBzA+nY1mug==
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:1f4::5)
 by DB9P192MB1898.EURP192.PROD.OUTLOOK.COM (2603:10a6:10:39d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.522.13; Thu, 15 Oct
 2026 15:11:18 +0000
Received: from AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c]) by AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 ([fe80::f0e5:8465:302:9a9c%4]) with mapi id 15.21.0522.013; Thu, 15 Oct 2026
 15:11:18 +0000
From: Florian Schmaus <florian.schmaus@codasip.com>
Subject: [PATCH 0/3] maple_tree: fix two bugs when freeing RCU-mode trees
Date: Thu, 15 Oct 2026 17:11:14 +0200
Message-Id: <20261015-maple-tree-fix-slab-corruption-v1-0-160d97f7304c@codasip.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABLt0GoC/yWN0QrCMAxFf2Xk2UBTqKi/Ij50baaVuZWkG8LYv
 xv18cC5526gLIUVLt0GwmvRMk8GdOggPeJ0ZyzZGLzzR3IU8BXryNiEGYfyRh1jj2kWWWqzKWY
 a3PkUPGUKYJEqbNrv4Hr7sy79k1P7VmHfP9ikPjqCAAAA
X-Change-ID: 20261015-maple-tree-fix-slab-corruption-d1f098521d15
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
 linux-mm@kvack.org, Florian Schmaus <florian.schmaus@codasip.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2769;
 i=florian.schmaus@codasip.com; h=from:subject:message-id;
 bh=1ZZWIBRvyOEj+TTOxvG5x0qV3sNVwOnl8HZyQGPPO8w=;
 b=owGbwMvMwMWoZLn8xddWhSDG02pJDFkX3gobnDggU7Vzd47HMft9M9Qu9Inceh2iZ++XHfXr0
 GorTh/NTsb1LAyMXAwzxRRZppeyzrdSvPMw+8nvdTCDWJlApkiLNDAAAQsDX25iXqmRjpGeqbah
 niGQoWMUD5HTY9DILC4uTS3STSsocsjLL0ksyczPK9bLL0jNK0gv0EvLTCvJyMgvKk4FGqGXl1p
 iaW5uamBq6WbsaGTo4uxqaObkauLm5OhqZGRs6WjuauFmamFqZGBqxMDFKQBzzaut7P8UHuWGrT
 /hG88666aPxI2seGlvRtnoMtm2ly6VTCHpJ76u+TnVXSpgH+cSSdeTXnxvhLJKbXedXhq8/NXNz
 QuDpXeXbjqtwjWHYYl9SWHznE1cfhXdnp4ds7hrTB//MF0XMf/ri3n1kafXbfvb+fKnruhMa3ne
 RD0rKdmVeVcq2PaKpTxgNd74yusQaxXXeqvagrNOU+dFebvJxVc+uHexRfr39KjXybWxs4Qe3nP
 jVlqXNl89Z4f4s7QXWrc+flcQlvS4nBURechY8OGeXQtVNgfsDvLe2C+3/Of/XR8XFEfzLy857x
 G1WFBx1ucFX/dcnbBgaz0v86oXizYHT/ixUpLT03nlbM9AZmmeJa0A
X-Developer-Key: i=florian.schmaus@codasip.com; a=openpgp;
 fpr=1357B01865B2503C18453D208CAC2A9678548E35
X-ClientProxiedBy: FR2P281CA0028.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::15) To AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:1f4::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9P192MB0983:EE_|DB9P192MB1898:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a7135c3-6b80-4e08-7c70-08df2ace9023
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|366016|1800799024|10070799003|23010399003|56012099006|261009223027099003|18002099003|10067099003|6133799003;
X-Microsoft-Antispam-Message-Info:
	ahrblo5e2iM24h04Ykp0aBGsAY8dAeB6jUwrP3Tp3mWUAvQXltujl9PsRqV7aQ3AabvVTkOdxNfvcAg65TZ3ITnVg2ZC5wf/mml1prG+ZZxAQI0dHBqk6gZs+N6ESJLR4AXf8PLuzCbx+MbNcNswiK6J6PQHn/1JuK+j+CAl9VPXq7/3HcOXBGnTdcyO60PUUjd9OVeWQB+DTnRl7pOv7ITHxYZD+h7o7ou68b3ysWEY66ochmLM1ZuvQRyD+mcSy18NSyXcPeJdpEQYfjrVeURIhnUPCMNliZSiyc1tNFJ03/Leh1rdmaFwFPBuZYcwu2FO09H7APb1HI6J7XrX/lD0osrkZnmOTaz/8PXclrWMtIQj/tQOwcFX0KVTsaJRnDFfjYlchyOCgr/AkYkBhEZUYDZDnBmFDaLI/AFexOv0uLzB/7QA5+BbPqEq9p08wOs0rpEjvVrPHK4WTPzEiZMoHxIZYkVacTcf5Z+9K+hnmHM9cJqblejkGFrEu8YfrzgFSCPTS3wmDe4tMCBPA5gW0HJbTPeaJZZwhvCw8VouYU0lb0szFp/yUlFZzH8Mtma6ZQUPkjFD6r+tLqBrrNBi1C0CkjKuJV9W4SrsriRn+nNIVjfohibhhPlbZHRq
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9P192MB0983.EURP192.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(10070799003)(23010399003)(56012099006)(261009223027099003)(18002099003)(10067099003)(6133799003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?OElyUlFEMG54aVZqT3lNcTdTRmdqUWtMcWxlajA3Y211RjhCWU5LN1MxcmJj?=
 =?utf-8?B?WXVHRERkVmFEbHFQbm44bmQ2NEVoK0wrWU8wWXZXS05LdTI4TVJjaGI0aXFL?=
 =?utf-8?B?TGdmeHRKdnZ2a1g1ZndORzRPMk1rNitnZUFmZVRtV2dWczdTcXA2OWk1a0R3?=
 =?utf-8?B?UkpOMHVyemE4TlVzeFNDY0hVUnpXbDhyK1dvUHg3dXM1TitMMEltYnF2YzVj?=
 =?utf-8?B?ZmdpSlBVOE50TnN5ZWRRNnFIWXdLYUs2aTUyTVB1cUluU2hQNWM0QTFsUmlZ?=
 =?utf-8?B?blJQSEFsS1YrdkQ0Mno4cjdKNDJCd0U3NU1rZ0hVNy9KU3NtRlZOcHY3UFJ2?=
 =?utf-8?B?MzRoM0VFYTlENVJNVHpIOFlQSEZoVmF6TFdMeHl6dmVsVi9HS3lLbWoyejkr?=
 =?utf-8?B?SDVmRGp3VmZ3MjBtc1kzREEzWlF6R2JmeHd6Q0RDaW82TURVdVRSajdGKzFC?=
 =?utf-8?B?TVdiajRCZmFIdVU5L0xKZWVqMHB4a2NWUWd5R2E5NDZ0emVwN29aaVpiT05B?=
 =?utf-8?B?RklLOFdmUGdIVzNpMGZGandhY2NtVlBjRDVaVlF1a0NYMHl6UWdBbGtHOUdi?=
 =?utf-8?B?YlJYRE9zNk14VTRvOVB1U1huNUsrcndqWGRVZXh0T1p5UHlIdXNUM1hZdW0v?=
 =?utf-8?B?anhZR3orQmZUR1pXZG5vRytTcGVuTWszbzFEUlFTczNPb2I1K0cxT1BsQTNS?=
 =?utf-8?B?dW5pR0twbU83OVBsNXlPY3VhdU4xSjQrQ1VuSzJuSkxVSDlPeko3ZWVGeExz?=
 =?utf-8?B?NlJuWjJVeGt1QWVvT01KSUtCeE1SczZQemV1UGl2M0ZEdzNIWjEzZk5JbHA2?=
 =?utf-8?B?WkZqelI4bWhZejk1V3ZzSUtRa0Ria0ZHRXRMcDliZDIvWk5uU0RMMEpoRExs?=
 =?utf-8?B?RmFHTFJLR1NGRkpQUkdQc2dKRC9iRXB0VVVEamRoU0RxTEEvOCt0anl2U3ly?=
 =?utf-8?B?aUJPWDNMblF2dHlkRzlzZzdTVHljWGxORjRuQWZpellOOGl6T0t4WFJIbDZl?=
 =?utf-8?B?anRFdmRCajcrSjIyNlU5aGk4dTN3cFpKeWtuYWhEK1ZTTTJ1eTNKT1Nkc3Yx?=
 =?utf-8?B?amx5NkVPampFbGYvd09QQ2hQOExvMGsxU0JDd0JXbXozSkhCZDI0UXBMVVN6?=
 =?utf-8?B?VGluR3E0WklkUXdYcWt1akQ4QWxOZTdTVE4vVXBsaS9mOVVhOUdOSmkzN2tQ?=
 =?utf-8?B?T210ZER5cjl2b0J5aEFwYWxiYnhzZjVIM3paNGRHa1p4aE41MnB3alNtems5?=
 =?utf-8?B?Z3pCRnVHcEtoekhVRXpEeDB3TFBOaS9DNzlPQm1EVFAwMjNCYnBTeFZsTm00?=
 =?utf-8?B?QlFWRGdJNGhIN2pSMDFKMm9kVmg3T3NLanhPcFhvaUtmU1BjS3dWUVhCZHJZ?=
 =?utf-8?B?K3lEemxzREFWcUlBWkZZZmZ1VVo5NVY4bTQ3MndKRGN5UEZBVkttL1ZLLzJF?=
 =?utf-8?B?U2FlTVo3b0M4QU1OdGpvVHE3UFYvZ2N6RzhwVlEvWjgycnBWTVltMUdQVFEr?=
 =?utf-8?B?MXpRVFhBRzVybHQyeGxZZXM1bTJ1LysyUEpOazA5SDJxaXhQYjZOZkJLVTVC?=
 =?utf-8?B?ekhqM3Bpd3ZsTlArT0FWT29nUnEyeFNaNzNnNS9OcGZLYkVlL05TaWF2ekho?=
 =?utf-8?B?Q3NlYnBvMFRWeTUwVEdBd1dpTGZnSWJGSDNtU2RrRVFTeEZDWnZNUFAxNHcy?=
 =?utf-8?B?Zy9nT0hYWjUxamlpdGJId0JlQ3NpaVlodnZMSmx1NDlmUDNJQWE4dVppM3Fm?=
 =?utf-8?B?YWdaNmNLeGZmNCtLVE9rQUNubWxhUGpneEYySFZmNlh3R3lHRDYwNkQzWDg1?=
 =?utf-8?B?eHB3bHF6SWd1b25zVXEyN1Fxa0hMblQ0cExxSk1ZVE85d05NWVZTRjZYTjE4?=
 =?utf-8?B?VEVYWWx5R25ESnVKSEkxYlY4YjJvb0RlRStYdmQwRmpyRGRWUFJFR08wZnZv?=
 =?utf-8?B?Y09xTWZEZHZJazFKNTlnRzR4Q1A5bzQ0U2ZXenFld1VXOGVMbG5Bc29Bblpk?=
 =?utf-8?B?L1g1SHZndS81VSsxK0FyeHJpa3l6aWh4ZVEwUnpCcDF1K2VsMUtXb2ZaZjdy?=
 =?utf-8?B?VjRXTFZhd3R4b1oyN3VJVzI5R2RyRUQ4MU5udXBaWjNnZ0hKQWUvZlBzYndQ?=
 =?utf-8?B?VkFQRXRvYmhsQVJBSzJLVHRBMGRQQ1hSdk11a0duMTZ4d1FLWDhYUXhIL1gr?=
 =?utf-8?B?VU9lV2FVOUt4eStZUklOQmxlNEJ1MUt2UTczMzdGSHdjcFVreG0xMnh1Vy9F?=
 =?utf-8?B?VnU5b0pLUjY4WDdCS1Zsc1dYWWRvVlplNSs3M2s2b1p1MHFwaHdxZW4rbEtv?=
 =?utf-8?B?YXlQQS9iK054eG9SM1k2SGYwZFpETVpMVmNNVmd3d3NmMTVaYkNxM0RGZzFG?=
 =?utf-8?Q?y7C3QFd5fozq3YJVDOchG92jyC6PQt2bqeHquHPuVuEv3?=
X-MS-Exchange-AntiSpam-MessageData-1: bzTGnQNhqXRcYKEmYVaPyCjpTZS5G9nbSBw=
X-OriginatorOrg: codasip.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a7135c3-6b80-4e08-7c70-08df2ace9023
X-MS-Exchange-CrossTenant-AuthSource: AM9P192MB0983.EURP192.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Oct 2026 15:11:18.1577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0d91ffef-bb81-4cbd-b9b8-552583685f20
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p9a7856nmkvkuDm2lGUdRElxppaOf0lIUGqeTyXuojXslKsqItK9gqNLPN5IAx4rPTkj+wQD2vKhLvteDkcskkaw9tb0k6mI2dcp6XInqvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P192MB1898
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DD2EA100005
X-Rspam-User: 
X-Stat-Signature: tp54ku7fnnx9rr13dgaw1tden1be1wzt
X-HE-Tag: 1792077083-45094
X-HE-Meta: U2FsdGVkX1/8pKnJ5QaxSSMjdvl612hNRCfggFOu/btR7mqpp6/Ja/DjtjsEOvss4lxUURnog1imt2pDLQcoflibuAOM/SccDKfFD9RtbnTM0erCDNO3MOo305LiV/eHiFhd+WPXgycYxoBl1O+VXejUI3+0nqD5hNj2JTfi+K9l2VwV/9mdXdQQyHRr1yW1sDwKi4RyBg5DM/vhhjII1EHaudfHJoNu/52MA3hUGqMpNw961jK+2ESlAgdb10pDYOSTYkgn9D3Ip0VwoitEkC7xKboL0xTOurNiCITx2jl0kJu0d4b0Xi7mwGUDQLAjOdHKQgBTZYR6C0zMUChfJRlb2nIO0c1LB4WfoS2mGdmUkSREVF7Sj2n3RHIRRPJKNW4SiG+qdEJtBIgO9vpx9t8Tenb9GkS92xRXmjr/RTDfXoX+AuUpNSg/KXCcMY6kqosX+AbLUM0MmQq5lH+KdWXS0WCfc3/au74AI6V2V5AzKfu1SsEKbz056uOXW4hjsLkwDiiE7CD3EVThTUHWbkXZdn+lqF6TI5mGPQnZR40RRVBOqRzAlR0O4Z/T0dnAOF/zuoEE9cwriY1iTy2d4W7DqRJ5GT0j+YHtoy71m05uTY0Hj9fb2i2T8AIyKRqNewBoi37SG+WjUYRQ4FKo6hNLk0EecHjAEVKQAQnMkKi1lue0gKg3Q+jEH/TXQBLWsT6YpyO2PKTYDk61yy31mdv7zklg/nAom3HlPPQAWhUIw2quYp1rUkXeVH6JkBvalaLsLHobqTrHU0Da9Lm2Wldg136sYmbv27kFCd38s3vpkGFkomvgTgYgziF3GlrPzYpESqdJcjCtCvUj7AN+0BmBxNOf9QvLvOQXZMadCSFkwnT+27juEOWJU8q+iPBnED72tBzO3KGBGEktPf4/M5OCarpqI651RT4uO8ywwmoIe8L/v7mxQU6N/s3s2Z3HwoeeXr5s2/DipN4wkHH
 BUKOzTEG
 3zcLgldylwx8t6C7BP2iI/dF/sRWlSr4skZ06PxPpZzDej7tobZEjWnjLyqFn80T0xqMn5UABboPYoPj8hRUc3BIx4TjuTy++YIRzKF6p3HXd+O8qbugjN4GcqaVAw9s4Sd/c6CNN6PrhkjX0zObOoUfw9VfLvomsmL4sokXeMK/5+/dDJpvdBUIbB0ML8vRXlDb3gO5L0G6XP3pZDBFrZL9jDrsixHx3/oqxQOpDYuAWmDeWZ4XwD3pIpdQd0GiUsseUtBvN+JNmpL0GK6uLijx01H7+kThBTJqYRrFU765VZld06ea01EDXyWgd+CZb67UO9Pe9oQWvefW/nihJQiK1l1wul7xVBz1Xbc3qupunKSjDcZ9BVurQxL3ELH75M2zWtFSr+cytVTJgg0rHisXVKbhSqrFuOF/hHIY+qM/+X0RhTFV+Q7rtmGzVRQPI6sjghRfAcRlX6rCP770m5tM2+ww3J9XPaA5UozYshFOo7JRi9N1DMWrnxUeNW+7DuSFa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Destroying a non-allocation maple tree with MT_FLAGS_USE_RCU defers freeing
its nodes to mt_free_walk(). There are two independent bugs on that path,
both caused by the metadata that a maple_range_64 node may keep in its last
slot:

 1. mt_free_walk() takes the metadata of a node with 15 children for a
    child node and dereferences it.
    Reproduced with: 2768 ranges / height 4

 2. mt_destroy_walk() takes the last child of a full node for metadata
    and corrupts its pointer, so mt_free_walk() frees a bogus address.
    Reproduced with: 120 ranges / a full root

Patch 3 adds a regression test for both cases to lib/test_maple_tree.c.

Testing: on x86_64, in the userspace test harness
(tools/testing/radix-tree) built with ASan and UBSan, the new test fails at
120 ranges without patch 2 and at 2768 ranges without patch 1. With the
whole series, all maple tree tests pass. The full suite also passes on
s390x (big-endian) under qemu-user.

No in-tree user is known to hit either bug, because all in-tree RCU-mode
trees (mm_mt, sparse_irqs) are allocation trees, whose nodes keep the
metadata in a separate field.

We identified these issues on a CHERI [1, 2] system, which provides
fine-grained memory protection through architectural capabilities. Our
CHERI Linux port uses plain RCU-mode maple trees for CHERI-based temporal
safety via revocation and destroys them after every revocation sweep, which
exercises a path that in-tree users do not reach. Unlike traditional
MMU-based protection, under which zeroing the low bytes of a node pointer
silently yields another "valid" address, CHERI invalidated the damaged
pointer: the partial write cleared its capability tag. Consequently, the
kernel trapped at the next use of that pointer, and the bounds of the
faulting capability, exactly one maple node, pointed to a corrupted maple
node pointer. We then reproduced both bugs without CHERI on x86 with the
userspace test harness under ASan.

1: https://www.cl.cam.ac.uk/research/security/ctsrd/cheri/
2: https://codasip.com/solutions/riscv-processor-safety-security/cheri/

Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
---
Florian Schmaus (3):
      maple_tree: do not descend into metadata in mt_free_walk()
      maple_tree: do not clear the metadata of a full dead node
      maple_tree: add a test for destroying RCU-mode trees

 lib/maple_tree.c      | 19 +++++++++++++++----
 lib/test_maple_tree.c | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 47 insertions(+), 4 deletions(-)
---
base-commit: 4056b3c9d3c92ea45955641dbafeb9b960e146ef
change-id: 20261015-maple-tree-fix-slab-corruption-d1f098521d15

Best regards,
--  
Florian Schmaus <florian.schmaus@codasip.com>


