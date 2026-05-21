Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF3CCD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 20:21:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD416B0092; Thu, 21 May 2026 16:21:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37DC06B0093; Thu, 21 May 2026 16:21:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294166B0095; Thu, 21 May 2026 16:21:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4A66B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:21:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA19A1407A9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:17 +0000 (UTC)
X-FDA: 84792546594.03.EDC8B64
Received: from GVXPR05CU001.outbound.protection.outlook.com (mail-swedencentralazon11023143.outbound.protection.outlook.com [52.101.83.143])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0264880005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:21:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=lnueduua.onmicrosoft.com header.s=selector2-lnueduua-onmicrosoft-com header.b=mw88O6p5;
	spf=pass (imf30.hostedemail.com: domain of Maksym.Shcherba@lnu.edu.ua designates 52.101.83.143 as permitted sender) smtp.mailfrom=Maksym.Shcherba@lnu.edu.ua;
	dmarc=pass (policy=none) header.from=lnu.edu.ua;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779394875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MNIQTrLDxKU6vP0aJ2EkKc9Raj3e7nv1IdF8WSc4Vhk=;
	b=huA/7Idn5ICFtKkQewRLg5DImEhyU0w9eSTeOZ61/7WAePCfTPs0EbuR2i4VoKlF2L6vfe
	ExeX/b312+yuh42CqpAmWfT4fmmiq6sLzSgpt8UEBZ42J98tq09Dwn+47qxT2LeBGV/cPG
	I+Nk8/iKiUlQp7b3hC2VlQweuuVjc5k=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=lnueduua.onmicrosoft.com header.s=selector2-lnueduua-onmicrosoft-com header.b=mw88O6p5;
	spf=pass (imf30.hostedemail.com: domain of Maksym.Shcherba@lnu.edu.ua designates 52.101.83.143 as permitted sender) smtp.mailfrom=Maksym.Shcherba@lnu.edu.ua;
	dmarc=pass (policy=none) header.from=lnu.edu.ua;
	arc=reject ("signature check failed: fail, {[1] = sig:microsoft.com:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779394875; a=rsa-sha256;
	cv=fail;
	b=K07Yt2pZFe3Jm5i2qft2m3FGcNiW40+3wsqkWSav2gcw1e74IIJXtAnELpqrbewwYobaWP
	eMkJZSP3A+P35b8r/ztIbZ87cUn8K8ONcdhcFkNBbw3KO+GOYDQzzDB69wEBw2SDhtBlZr
	sA5365vVcJASFBHGUvZm3UCkYH7eb2I=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A00jIPmj/xxhpGEp9RE50oeTNDOLj1TBttB9UYhAkqEj0VQBsb4ZKMqEqfrEMs8uC13BVowtDQYmNyeReIuxJZXKfGvY0OLg/x5upkllJDL87MRnAQxg11AVWSLVQwZfxbJoYbLoJpNCn4qJqEbfnxhOBzivC5iFTlejQcidVhfa2EZdjL55qorq7+A5828Szrs2kfMg/50mjG3ueZSVdKHpYcTT61OeZMnPRkt6GquzG2DCoQ9m2cd/JftEFKyeISWgF0QqgHtnnoi3kWhR2IZKuTOuoG5U4zG1EBQPHV21sVTZhLngNDx9eJEIansu2sL7MUDgSE1B18oJ7uU0Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MNIQTrLDxKU6vP0aJ2EkKc9Raj3e7nv1IdF8WSc4Vhk=;
 b=S8yTTIkhVWbFGCK1opSJJx2GNm67SSiIzJUmsKiv9032CtwPqgjz757+91C5mn1mRAUNfK2J163ffimpETseKfJeVXfyI8gRa859Ey6Pi7vc/J29KxBWkynnnA7ElPKLJCQ6nWN7SqizU0uPftFhW/2TVVypZcLntO6/QNHvprINYddI5sbbv7OVU4t9QitBABtwzhvuLCmiW05Ck6HKB+z5l9pLkUaYq3CCp4xwjeC5RRJ82OUrqwVx+D0MlJcZAQ/4XMap+peY1zQXqLv2iVRax09wLY9hAltn8827YsPdmlH2hSUF8WOZSSNmHdZhn2WHl5+BjDHqHRBprjj6ZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=lnu.edu.ua; dmarc=pass action=none header.from=lnu.edu.ua;
 dkim=pass header.d=lnu.edu.ua; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=lnueduua.onmicrosoft.com; s=selector2-lnueduua-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MNIQTrLDxKU6vP0aJ2EkKc9Raj3e7nv1IdF8WSc4Vhk=;
 b=mw88O6p5lrT8JvL8ERYJewYrbpTzkzCJifGiTSOjPc7RNHBjj6zLnb4hk0cXUvzsZFDicSeqqGaDwWolgVe6pcxcPsX9crGXX8j4czbE+Uu4lGXDfoSWuJQ0Ltrbu6Sk13Vuoe4D4NJoSPmacatlO1us54beVrc1jhIIHYGqULo=
Received: from VI0P190MB2524.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:2ca::9)
 by VI1P190MB0655.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:128::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.17; Thu, 21 May
 2026 20:21:11 +0000
Received: from VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 ([fe80::b775:39dc:b909:e5d0]) by VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 ([fe80::b775:39dc:b909:e5d0%5]) with mapi id 15.21.0048.013; Thu, 21 May 2026
 20:21:11 +0000
From: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
To: SeongJae Park <sj@kernel.org>
Cc: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 1/2] mm/damon: fix missing parens in macro arguments
Date: Thu, 21 May 2026 23:20:19 +0300
Message-Id: <20260521202020.126500-2-maksym.shcherba@lnu.edu.ua>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521202020.126500-1-maksym.shcherba@lnu.edu.ua>
References: <20260521202020.126500-1-maksym.shcherba@lnu.edu.ua>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: WA2P291CA0021.POLP291.PROD.OUTLOOK.COM
 (2603:10a6:1d0:1e::29) To VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:800:2ca::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI0P190MB2524:EE_|VI1P190MB0655:EE_
X-MS-Office365-Filtering-Correlation-Id: 840885c3-fb17-4ee1-9260-08deb7767f92
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|786006|19092799006|376014|52116014|56012099003|22082099003|18002099003|38350700014|11063799006;
X-Microsoft-Antispam-Message-Info:
	UOZnoC8divyhFHqWv8TtyvqH9qSF3IpwDiJs5zs65Qh1kUu2tRvareb9mq3ao915Rt0ZcnvEB1Y7v7ErFeX0LzB7XftSfcH5lVEhAPAv3Ud3jSfGoc01cb4cpU5hnASySy9sh1LEfn7MbSp/iVJu4L2safzZeR2+WAxL1Rj7I+dDawPiJUBeVxtsk/HIhVaQneuFIFMsEOCXED3dWo27/1clhfuyFr80rIONBVovhNG/yQCv1v8ZEpCbexwh3MLPFRu3dNjqaDD0BArWwwM5kEFFie1TjGAInG+VspTdI/+QVtjd6ofMsCNN4Rg6x9TsfQj+GRRWrrIb64wjbR8Rt50cEkEa8Y/8cg4+vmHt1YQ4f8HevCHGqkqgwku8pPf2YyemGIvkpVzGmDwgMu/GMpJf/4aPpwJ89ZhDpeLY6WDnU9KMA53GMdKSyNFETYGSdYpfgqcDK02tAr7MzggIBl72HmZEObIjVQ0WncG8rFgAREqCj0dCrqL7H8LJtxOq9zGgMcqx7M9iaWkF9EPz8ZHc0rglBcMt/+nBVpIhMSyOfsj7nFWZINSr6Nd1H9gsP0jK7w+aaOF6pDNPn3DF4C2Oc9N+6lW7C3cIPd5AKjUi2b/z4LN1AgJVZ9L+CuGdcJqSoo7o9M0sxAflJW7140tUoZcMBiGqwSg0ohlHMzsjf2Ih8cDGg80a5w/xD1brLN+Vky0mKwlYyzyPIv+5KcvT8FQcX913LHESqfs+DDaH2NBqxRQWLYiensnm9c9D
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI0P190MB2524.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(786006)(19092799006)(376014)(52116014)(56012099003)(22082099003)(18002099003)(38350700014)(11063799006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?iYpEeFleMlgp/2EsPGJxdx1YFzSBFgVgby5fS/RqkM3lbo3l6eeX4uuD+oVE?=
 =?us-ascii?Q?GZguINxHWbny2M1lyVxfJ2NhC6HPSRVUbMb4LhVOJE7rUwfdf1cxinmsyV00?=
 =?us-ascii?Q?2qI5rD0gIkXPoDZNQr2nrVpSeJHl7XhLpFdMgeSa6plK21RMD+Dj+Ru8SQBr?=
 =?us-ascii?Q?gevRrhHJyT6HaHNqPTj4kLWS5k7vBVgjFfsYJnJYGC9NaGlAKjnavMB5A1Yo?=
 =?us-ascii?Q?dY/2zjXqh1+WL26NWrgLeRnSXet3TQKcDKfcSakBg1I3ukM1JBSAzmAmmJhO?=
 =?us-ascii?Q?uI6tNFnzN3K1mEQC6910mF7gjVOAUjGyx+Xzi7Mmj7JuxXzKUSXCr7ojeQhu?=
 =?us-ascii?Q?2G2avLBa/ZKdALvW0sTYhycth2HFesVGLZLAamqZiEG+MfwaTYdVk/V9/2zs?=
 =?us-ascii?Q?o4mLPj8kTPKh41ol69sJOa5+ARhtNg65GzaIn93YsQZf+P+Su5ZoiAVUgsD2?=
 =?us-ascii?Q?mESwHF16WHQYtRv7xrs1DedGubWSJ8PEJ98OfhdqJLrx5bNAt3ioxqv1WXzC?=
 =?us-ascii?Q?5ISnEwGFdRuHuQNUBTVsPqpr1SGjn2WnJaZH7XxtgzvforQzKHdsQB2aTWq0?=
 =?us-ascii?Q?MrY8WnfPRhod/I4K/SefGDT7kv/OIaZBD0n7QPQ3bd8+plpyDEutEiUC6m7d?=
 =?us-ascii?Q?O8FiNkjnH713HaNWN+yr0oPhIGkFAhWfsUp81BSdOaeVINrso3DGsYteX/IV?=
 =?us-ascii?Q?Px9RuRsLvU5SnxjlTbDvv0Wx4gX6WQYQMrH2TBPehrb/2LkO7oMglc+hNQX/?=
 =?us-ascii?Q?JGUCAO76QSd5MbpIrYIMZpgNeWUwKqeS7OgbNj9/C7ejyGgzrB4v2lvKjCxq?=
 =?us-ascii?Q?leZoELu2hWlnsYtdufntkjXV52M5k8SAY9tJlPZ8JYE7RCuqWf5kDMxDjNJN?=
 =?us-ascii?Q?qzcgEGfvyx/nR7gVLS338irCxZk/860ZU4ZeL6T3HKuAlhk4q18lj1eRcoxb?=
 =?us-ascii?Q?8w8cixAVgb8Md4fTloismb+sXMITEAFdqE4ap4ZtmGptgYY1N/FEfWhMxQ03?=
 =?us-ascii?Q?2JPnAsmzFprZKd4iAMMY3spFMOFgugqA4GZ/DhP2wZytTf9Q7A/DxeRBb5g6?=
 =?us-ascii?Q?VaUwwz9jbq6AQRYgo2vdOxSepdcrZZl1x/YTLQN8OaKP70Al8mqtByEV9nFE?=
 =?us-ascii?Q?72l/rpvhPgYeSVHkgbQLjONY2d1dyq7jT2m/+KvZ0Lqoa0qEJbbVfC9Az4DM?=
 =?us-ascii?Q?3D4lD74jP08Gv5n84pT3CsP1kdhIBL6SxYgoNRKiqQcq5qHApaHK4jzBVKfy?=
 =?us-ascii?Q?HtIZnSS2d1Wdo/UtqBmxi8MRo7gBmVZxpiZCq7dTRrMYzv9fz/o/b4pePPSc?=
 =?us-ascii?Q?Ucd/5dOCxqMl8pZox73y5tD84YG+7eSfqmeSMzNGWB4HHn75UovXR2c0sb61?=
 =?us-ascii?Q?LJh9EVQa9yv+oitq6fzmn3I9hTmTBTgxEWnlr+IxUfbJHbW5eGGmPJkd2Sba?=
 =?us-ascii?Q?2fIyBlHYrNc27afl7CXRl9CsM9GWEhQJdkqjst+nZcTAfjWiwIY0w0A/R093?=
 =?us-ascii?Q?5L6F6yYldcVf0OzQ4EDIc+2WIrnL5QFucH7rP7sFcUskSjPvDovX53wPAROJ?=
 =?us-ascii?Q?rUZr8+Mo4m5m731YFuCsPLVy2/CMvGD6VB61pG+ZpmLbDnitVPy8au6hY4X4?=
 =?us-ascii?Q?PxaKzioapLG7gn5Vhvx1tiK93aq5F0gKBQKJTT4SSw1YtN5VF4H8CK6PmAVT?=
 =?us-ascii?Q?Z6o6+8Idj7c2d6Bj4/ZLhbY0HvJcs0om3vG6ZgWSO94E2gmyTc+IQbq57iNT?=
 =?us-ascii?Q?BolhpxMaeZQYjMfJsIyWhmFAD7Zqamo=3D?=
X-OriginatorOrg: lnu.edu.ua
X-MS-Exchange-CrossTenant-Network-Message-Id: 840885c3-fb17-4ee1-9260-08deb7767f92
X-MS-Exchange-CrossTenant-AuthSource: VI0P190MB2524.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2026 20:21:10.9382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 70a28522-969b-451f-bdb2-abfea3aaa5bf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kGCN+iV/Rs5LvdkhWRL197x+nnyfS220cV8Kbfi6eoVWz+IiRqpUq3PZBSl6OCDVmjHzxRFVSIsgzkrzvsfGF4p+Pn6YC0nPnKfUKAu13Xs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0655
X-Rspamd-Queue-Id: 0264880005
X-Stat-Signature: 57oky64zsdx9i4cxwthum5ht3ys57cos
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779394874-626948
X-HE-Meta: U2FsdGVkX1/aMGBjcDeL1rD8fvOHPOv982HEiXFI8g8kRVh6tbAr4RMAUMcYJSWT+6VTNnYxHpAM5m0cz4uHYCWW5hFNZHRW3Qn/wmAw6Bc/do1pg+67kk+/4i4nB5Ta7tgmIVhZI+3vY/RZ5VDIOBW9LgxGrQEZPrhuU6HF0CbPx1rFYfStbui+aE5XCuxAxbw0iQPZRKSpMQ+IlIT9B7jmLfJZ5KVJELqqko0WByuwy7jkHYEmEyQl2bNRHNzPX0R1BVF+Ac8TWmr3lLGUKq8UcjWK4V8nxB8+FSJUnTTEZasW1DTKkinIM94dCpDNIVMK8MgihrgN4hW/4gAlNuVgPDdOqUiKbT3fLFovFYJsvV+0l667/uz0U+TQvQ2vjthVlIJ6Cw1W9cYwsQJjccWEpe4jW9erGxTLW9LeiPNDU5FjXRETf0bqwIv8+JjnL52EeV+g//eJcXpVCG4fIDWL9CxjKo/vNdjFrCBeqqhttAte1fM/Aiiym1pV3Byk6xqESjt11g9zDIxY0eHS30MSAEt1vWLtfdbb0Y8J5S07K/zvAl9lYPtb0zg0C9mxlWr/j+D/XcqEuZnN5W2M+kuLKWPWQywWyZ6spfb0904UytNcNdqvTdkWVEfUslu1QQ4KsFjdIoZemK8mDNbKPy8lYT2aG+xEDKgm86+LpmCWLO2NI/MovtBMMxv6ZYbByeHMj4L9YEXaIhvq3opUE9rpPv5deVg6HRm04993vmqyaiUIxkKRAbjrBs7TJFQACBabpie3GTvnCvETLOtjISEnoBQXMqIvK2g5a5Bx1jdA284DhGRR6MfQZ186ALg37haqI6YFdXf5VJKqWx5zMBg1kFp9NRMqCA4rK1FvO66T6eXL92Vz/s2cxkNd+QhzAcZ3pD3eobQADVcAkXQPwof9ObKHEhW4414h8gTlL6cwujgq4nUUAzozPwhJDuQ89aMWtcnTKM97OrA/iEc
 lrmKBxM6
 BLvbrf5PEcBmLusF6ynZPY6GsJkt//8CyrykPia/i/cS1mfzpYtVrtNwkdrX0609Fpfkef9RCJmXrIju8Q5OiBJSyw8PvLRGJEdXDtJfWyGGuvjErFhDNwNwD/BrBpxrzN+jVeNelIgyUBmg/UL4PzzNy9OQamhFgWhTSfIq3MOJVe1oisYlfsicdNPuzyKWNoWc9agzPpEVuZtqnRAv8+gdxmD3jcaQ7UoVjOugHJ9n+5Zl7TtLOWlxYqw4O708JpBciMm4hhhgj/WpwHh2us0+tZuaPG2BN4qrVsrM2Wz+Xt+oTqlt+8L5pK6hplA3ygE7LJK/x8DKYj5DQMU4f2qGk4mFl28L4YGmQtWdrOGa3JSzrAlP3KlDzXdtlhbBjvUc9PBH3vt0L5RAC4L5G5s/hdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The DAMON iterator macros do not wrap their pointer arguments with
parentheses. This can cause build failures when the argument is a
complex expression due to operator precedence issues.

Add missing parentheses around the arguments in the following macros
to prevent potential build failures:
- damon_for_each_region()
- damon_for_each_region_from()
- damon_for_each_region_safe()
- damos_for_each_quota_goal()

Assisted-by: Antigravity:Gemini-3.1-Pro
Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index df7910a39b40..abb0bbc26997 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1098,13 +1098,13 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	list_for_each_entry_safe(p, next, &(ctx)->probes, list)
 
 #define damon_for_each_region(r, t) \
-	list_for_each_entry(r, &t->regions_list, list)
+	list_for_each_entry(r, &(t)->regions_list, list)
 
 #define damon_for_each_region_from(r, t) \
-	list_for_each_entry_from(r, &t->regions_list, list)
+	list_for_each_entry_from(r, &(t)->regions_list, list)
 
 #define damon_for_each_region_safe(r, next, t) \
-	list_for_each_entry_safe(r, next, &t->regions_list, list)
+	list_for_each_entry_safe(r, next, &(t)->regions_list, list)
 
 #define damon_for_each_target(t, ctx) \
 	list_for_each_entry(t, &(ctx)->adaptive_targets, list)
@@ -1125,7 +1125,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	list_for_each_entry_safe(s, next, &(ctx)->schemes, list)
 
 #define damos_for_each_quota_goal(goal, quota) \
-	list_for_each_entry(goal, &quota->goals, list)
+	list_for_each_entry(goal, &(quota)->goals, list)
 
 #define damos_for_each_quota_goal_safe(goal, next, quota) \
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
-- 
2.34.1

