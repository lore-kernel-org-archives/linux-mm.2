Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668C8C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 09:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A95346B008A; Thu, 31 Jul 2025 05:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C7C6B008C; Thu, 31 Jul 2025 05:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934256B0092; Thu, 31 Jul 2025 05:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 846AF6B008A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:35:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B310BACF3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:35:26 +0000 (UTC)
X-FDA: 83724051852.24.1E26061
Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013066.outbound.protection.outlook.com [40.107.162.66])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9796540009
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 09:35:21 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fL5BxanV;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fL5BxanV;
	spf=pass (imf12.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.162.66 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=3; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753954522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruIpSZUqfvMrmnWE1xn7+5VUSgYg7TssEEKOBw5dck0=;
	b=dnS2RDbpgyXEHCmTClSCKIKTa6+A6nRRd0BmpXRNTwc8ysLYEK06Ru0SsXCoNY9QSnU9dF
	vbqwXVyftsMKdWCvj0uOP4jDT8wzigX4oabu1um3aOdPXnEGLL5YplpQTQu6urA/QgKDCq
	Ek2qx13lUvITP34WNioHGJiDOHDrvZs=
ARC-Seal: i=3; s=arc-20220608; d=hostedemail.com; t=1753954522; a=rsa-sha256;
	cv=pass;
	b=Bo+QthP+AB9UcTuQFZyz2fxe1iRAR8/r384Q2t8h0x0xdWxK+nzG4K1zGae3Fofv4BCTgy
	jWOh7xpl7ubqD0IA9GpEyLOoUZ5bXPxoB6GAv3teC20rYJaG+AyFp/kpxZAVX5Z4E92fwB
	xYmlalZWkffXBYDY5LeIFqJTLWmiVlw=
ARC-Authentication-Results: i=3;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fL5BxanV;
	dkim=pass header.d=arm.com header.s=selector1 header.b=fL5BxanV;
	spf=pass (imf12.hostedemail.com: domain of YeoReum.Yun@arm.com designates 40.107.162.66 as permitted sender) smtp.mailfrom=YeoReum.Yun@arm.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=2");
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=2; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=pass;
 b=DhDLGvMUUinWRrqEhXTFAgXFhyEWsqs5En0I5+UgvPAIPfPZU8CGy81XYbPZ5touA9+HQfMsb9BauCVEntbMwVpBnfOBrqgFv7ClZdaGSiiyzq5wJ+wAVJtIb7MPYmxuanH5rjkYyDNPq1Lv/KYYyOPd9IUUioula2EXNWa3gIKBLik3jHha7o44FV3s2ZmeeClVdeWtOlpU6gnxh8MkWHGPopx4z+C7NLizpY0O6lTBbYD3wPO+ItB9PsFgi4PheZnQt/8O3rd2W3vboMbhMGrfwW0HwTg7Sj+luxZaHtBRwXFCoBo1zOWQnNO/i0B+vM+DUYaRgwlm6pI6y0XemA==
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruIpSZUqfvMrmnWE1xn7+5VUSgYg7TssEEKOBw5dck0=;
 b=Xvk+TgKXOyYzCx5Xbcivn8uR7O74IHK4a2hPVlXAwpOFB35hjcQBlipDYzSk33c8Sp5qyq+Cr8hz9XDxV8oEd+IRxPpBmrWuj0TqU/L/m0EQ3/lo9+vkvQhSRmz6N13APMwG2Qzp4A+N/MceOUf/6yVq30ZMF6DBjfQejluBKibwwXtSJHPkyG6ZjvsKKkO6rHhbxNMYwfPF1YJY0lhrZpw76gBD3KkFFcHN1j4C1N3pADR+36oD/9Y7bem/JCYBIgSvs+QNKKlAvoTfFxm/h7IWvxE3opcaCrxm/9UDTDLEX9y4rD+mV1GP0IxTpDW5wzQlA/RDanwzFjvdAInfzQ==
ARC-Authentication-Results: i=2; mx.microsoft.com 1; spf=pass (sender ip is
 4.158.2.129) smtp.rcpttodomain=linutronix.de smtp.mailfrom=arm.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=arm.com;
 dkim=pass (signature was verified) header.d=arm.com; arc=pass (0 oda=1 ltdi=1
 spf=[1,1,smtp.mailfrom=arm.com] dkim=[1,1,header.d=arm.com]
 dmarc=[1,1,header.from=arm.com])
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruIpSZUqfvMrmnWE1xn7+5VUSgYg7TssEEKOBw5dck0=;
 b=fL5BxanVe3BCf4+1ixcsoUWjUHKW0OoCNs89qwpOddzDMQee260ZQQi63/pukHn3s/YsDbHqtouwzs/IXe5wPKnW3YAQ8IuuaTfhuXdFutefqtaQtvbyJh7rpxkMVhwyTYV7dmOAo/yl3OD6Q/KBg6COgKhcq9t2nAr+XTkqFUo=
Received: from AS4P189CA0041.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:5dd::15)
 by GVXPR08MB10714.eurprd08.prod.outlook.com (2603:10a6:150:159::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.11; Thu, 31 Jul
 2025 09:35:17 +0000
Received: from AM2PEPF0001C713.eurprd05.prod.outlook.com
 (2603:10a6:20b:5dd:cafe::c6) by AS4P189CA0041.outlook.office365.com
 (2603:10a6:20b:5dd::15) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.12 via Frontend Transport; Thu,
 31 Jul 2025 09:35:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 4.158.2.129)
 smtp.mailfrom=arm.com; dkim=pass (signature was verified)
 header.d=arm.com;dmarc=pass action=none header.from=arm.com;
Received-SPF: Pass (protection.outlook.com: domain of arm.com designates
 4.158.2.129 as permitted sender) receiver=protection.outlook.com;
 client-ip=4.158.2.129; helo=outbound-uk1.az.dlp.m.darktrace.com; pr=C
Received: from outbound-uk1.az.dlp.m.darktrace.com (4.158.2.129) by
 AM2PEPF0001C713.mail.protection.outlook.com (10.167.16.183) with Microsoft
 SMTP Server (version=TLS1_3, cipher=TLS_AES_256_GCM_SHA384) id 15.20.8989.10
 via Frontend Transport; Thu, 31 Jul 2025 09:35:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eINLlb4a7l1/B+KRDe92F6lM+7kk6PGQX+OfVBAS469XsKe8BGuU8ZjN0EC8nkLd6KMFfUsdVsJSwKf0sMASchVgkFXm71mVZpwuVI5f8R9PC8rS4ATS8Wk4Hy8pt9IFabbOYqSWCTM9P29gd/ZMw5YBO5D6d6AsKStHVTD6QxWN00ObLDQcss89L6BojAPKfzj3Of4t5ZzNNim/Iqn8oXae+Q5zYkUcM2jkVcN+Z2rfhsAzbMVoLU34EmTIshHiB+916NAH+fjpJF0XGhlccyMLDkQwJRRidDPy93xnKhpDiHzHIsF1ywBW2aFHq8rO7yzcgTKiYtzC4k7fTraxIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ruIpSZUqfvMrmnWE1xn7+5VUSgYg7TssEEKOBw5dck0=;
 b=ssMRB9p6Lviecc2g6a2Qtx9bTST0+MXYPJlGzxNvSRDEGe09Ck83TXjoNtEg3VlAsxs/Ae8CExUlhLK0CICVnBQUOcUwbGGcBtYiTRjxHVbL071fpNE4IJ5tkzZrJtXjPhP0hcZINXSBD//VSaAKtGIvPtaOakzIcTWNwVKyx+QKbOX4uTCadStsaqM08w/44Vpl61aAWw1qNa5wSuM9HZpaUXmN/2NVy3t0YovO4G3Roim+Mf6llEM9pk68h35OfnGrFuk+Qm1iMx4w03MHGwvxhv119oKskgOezf4eRT1UsANVYH5BQOoX5BR6vGkmqr/wrxEgAlbJWK79ysPvkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=arm.com; dmarc=pass action=none header.from=arm.com; dkim=pass
 header.d=arm.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arm.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ruIpSZUqfvMrmnWE1xn7+5VUSgYg7TssEEKOBw5dck0=;
 b=fL5BxanVe3BCf4+1ixcsoUWjUHKW0OoCNs89qwpOddzDMQee260ZQQi63/pukHn3s/YsDbHqtouwzs/IXe5wPKnW3YAQ8IuuaTfhuXdFutefqtaQtvbyJh7rpxkMVhwyTYV7dmOAo/yl3OD6Q/KBg6COgKhcq9t2nAr+XTkqFUo=
Authentication-Results-Original: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arm.com;
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20) by DBBPR08MB6011.eurprd08.prod.outlook.com
 (2603:10a6:10:209::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8989.13; Thu, 31 Jul
 2025 09:34:42 +0000
Received: from GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739]) by GV1PR08MB10521.eurprd08.prod.outlook.com
 ([fe80::d430:4ef9:b30b:c739%7]) with mapi id 15.20.8989.013; Thu, 31 Jul 2025
 09:34:42 +0000
Date: Thu, 31 Jul 2025 10:34:39 +0100
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas.weissschuh@linutronix.de>
Cc: ryabinin.a.a@gmail.com, glider@google.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kasan: disable kasan_strings() kunit test when
 CONFIG_FORTIFY_SOURCE enabled
Message-ID: <aIs4rwZ1o53iTuP/@e129823.arm.com>
References: <20250731090246.887442-1-yeoreum.yun@arm.com>
 <20250731110823-9224fbee-6d66-4029-9e92-19447cbcda64@linutronix.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250731110823-9224fbee-6d66-4029-9e92-19447cbcda64@linutronix.de>
X-ClientProxiedBy: LO4P123CA0640.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:296::21) To GV1PR08MB10521.eurprd08.prod.outlook.com
 (2603:10a6:150:163::20)
MIME-Version: 1.0
X-MS-TrafficTypeDiagnostic:
	GV1PR08MB10521:EE_|DBBPR08MB6011:EE_|AM2PEPF0001C713:EE_|GVXPR08MB10714:EE_
X-MS-Office365-Filtering-Correlation-Id: 807c9022-3348-4c68-6d42-08ddd0158e50
x-checkrecipientrouted: true
NoDisclaimer: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam-Untrusted: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info-Original:
 =?us-ascii?Q?Yd/Sr9sr4rBUduJ0nfMtXHVNAq3tfHyo3EALKeOIU6gmZy+DotfbfpPRbMdm?=
 =?us-ascii?Q?WhC8815ldH2MsWksWSKMQB1q2lfHM3kimTxjCvdzz4ETfyOaqKln6uape3sK?=
 =?us-ascii?Q?Cfy2OLBsvtvHKT4l5hme/Oap/F8Uduz4ZCzdhWRSHM9sR+Yw8U3A9+2IC0c7?=
 =?us-ascii?Q?Zt/qLJfUpdo0TUCW65O9XRmJ5wDUu0fGL9bmjzZFJvMlDoTnGfUDJgpYnSS5?=
 =?us-ascii?Q?itfkT3fhGygOdnhVIDsjt7ejPpvMMDBGilaWDyNgAkQVglKmXxIDdfgeNmBT?=
 =?us-ascii?Q?5EJnRohKtDvczIDARBDtAIfAddoO+uRKra4Fcq5c8C8W8K0n2YynBq+h+Jal?=
 =?us-ascii?Q?lgYokKmiyTfHKmW8Au8T/usWhbG1eWbrGuWaPLpGrWT8/ld1PqLuZuslW8u5?=
 =?us-ascii?Q?1p2CMxULhuENzLMs22XyPq2z6GUXspAFa998+EU85v4Q81KvFpZ0EVHDYeO4?=
 =?us-ascii?Q?3Lgyx+Aq1uZvv7INmUB9+SxUbe7HtBjzsf6bhcjOf5pryq8TMVzxDMNwxvx4?=
 =?us-ascii?Q?XoRJWGRfnauxq4J5m8IY47y8kZReP9Wd+DP3zIikXJauPz+LOcLMR/NWoHeS?=
 =?us-ascii?Q?yRJWdNp3LdSX6MUX153xXXhWRIb32ulJ2eFTCo2QoZdKOV050vV6J3VgV0EI?=
 =?us-ascii?Q?JWv45tCcyHaaQnkAO+bPevm4JB0u+rurAHkbCERH92VX2uiifGmyHURNV5He?=
 =?us-ascii?Q?aWExQ7cQjpDCBe6YWHQ+bvzm9zWr03KqwvrJ18u4m1kYkt8i2EibWRhuwOzW?=
 =?us-ascii?Q?p8pe1/mTBsVhMq86xIWNE6IE/spBys2tSwXku41I0t6AJ3ZORbIeD7HC3/HT?=
 =?us-ascii?Q?cWw9fpasy9w0SQjSXIrNsWjq35SmwAhS0ucSTzs3DtRW8bBNlmkHw3i98WuJ?=
 =?us-ascii?Q?F/zDDhWwkERx6+e0mmK5UqeTKosToZU/anVxLOurR8uHfvP1kDbVv0ppN89i?=
 =?us-ascii?Q?2PHWve0lT9N0pBgL5cq8fXqmzUy0EHq3LVft2u/s3IrkbQrp0ujudqxMGqs0?=
 =?us-ascii?Q?8dApdx/ts81QprYQrLNqjyNbGJnPnsuoI2X6h+PuUOcjuf4j9focm5lUTxke?=
 =?us-ascii?Q?tJhTqn2vJEIy/g2hI7p7CYwndl4ukfGCE0iZnP8LA+DLOgLHmoB9XWuLi4xJ?=
 =?us-ascii?Q?u8UU1ycy6/sfktxN9LpKfWKkqHiHgdnw/5FIcE47IWQgKrSi4sUhChsDhPGg?=
 =?us-ascii?Q?casG2XCULd0tNXeytnLsQswvfGpDZFL4lmC7EDS0oQq0/ossXY47O5hJgc+w?=
 =?us-ascii?Q?LWzCXo8XSv+4bbG8cvqgOJ9afc+O13/f5q03g4MRRRvHmNaGuuTvQ8nn12Oe?=
 =?us-ascii?Q?gn7anJTYC/LgUILazUOAELuvILULOYq5IiBjN3wlIvD/sIc/t8fc12BGDpX6?=
 =?us-ascii?Q?9c8iIR/2Owr8DM3EmlxnJg3ini6W6B4+hDAoNrwRzZd+CKPxLoiNtkCd+Jir?=
 =?us-ascii?Q?ugBQukwJ14A=3D?=
X-Forefront-Antispam-Report-Untrusted:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR08MB10521.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR08MB6011
X-EOPAttributedMessage: 0
X-MS-Exchange-Transport-CrossTenantHeadersStripped:
 AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id-Prvs:
	ff4e2618-4cd2-4190-9e48-08ddd0157a1f
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|35042699022|82310400026|36860700013|14060799003|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?uzuZpYLQWH8c8xrc1TY3qGUz20s6ibi9kBENoUXMJdS8By1iyqZ46isY6V7v?=
 =?us-ascii?Q?+Uai5RtC2eB7erRRlS6QrdTjeN+fPNaKAgK78YF7WgvcJmDpOWwYzTQkH+pC?=
 =?us-ascii?Q?CWcOMBUJTGUGx/nTF6eacdQZAkRWNavgMnAQO5m24pd67KRSbv9qmjxNfRlw?=
 =?us-ascii?Q?eCqumFN3oSZzb/LD7paGdp1pJrCu/T0aGAztzJCuJQEk0M+aFngDm+5m/HPe?=
 =?us-ascii?Q?mmNP389G1rcM2Vt19ZA86OJrepggwt6um1gmlvsZDZ07830qF1qP23iD0Ma6?=
 =?us-ascii?Q?hsJeqS62LrseDLJoep7F7rKwEr89CKCNhUiaVgVQHwESTffAFJRxpW0iAJlv?=
 =?us-ascii?Q?cf6VBwcuR9wSnTfUqFax3FqakjvwOLeTAZ+/ymrI76Ml9FkLY5+yalWjn53U?=
 =?us-ascii?Q?1V6RiNrFgor3NAepd+xVtsMApu1mTAwRtxMsolwxN+XJ1inDtPNo2mSIqsC1?=
 =?us-ascii?Q?b2XKd+jOVP6Ufm7t8TOFDrGdiGxNDxCmmK6Gv0l1ZUCCmUCwzGgiK5GJwbIi?=
 =?us-ascii?Q?9xrMs/qeJFwbnY23bllKXaQuEczmlsA6xlFxEQlkWkVpHKrHTYi2C5zF2Rcm?=
 =?us-ascii?Q?cGYyhRe6VkmXnlZ5StfksYfkopVg8+V5brVg0XL0dOaqDt1RJF0fDn0o+7YL?=
 =?us-ascii?Q?zGsGxETsKj1jP2rYYwhiJZJM+78CrO4JVvMP+uBGdm8Hagc2BOx7GdJfNYjD?=
 =?us-ascii?Q?NPBRg+gX9FTllM8JDfNvECYdHfCtlPjlabqcfQ5zTONyYqPXrnY8cAsjMBfP?=
 =?us-ascii?Q?qllJE1N+MP8ai6nCAJ4KFas60RwqXD38QGqc1HnouaLWeXnuTy2DwC1WG9zk?=
 =?us-ascii?Q?7zOvliwBqL2WiOlUgWScX1+jNz78WDckYXPWBtnqJfHVViUQtPnGfdUt43E5?=
 =?us-ascii?Q?SX1RDroxc7mT4WQKW/9lwUJPMiUdcVHEX3xB0S4kmbun0029C0Tm/QFl+Ert?=
 =?us-ascii?Q?tBuVpqHx9ozWyUfCfvHsV4TtXQEuYiKSgg8sCN4tkOzESf6/TRnV2QvNv3qr?=
 =?us-ascii?Q?02cA6iYXZGSTq/ikeZeTVBF//xkBpI53oO49a9z28A2aMds6ogDKJPS2ka8e?=
 =?us-ascii?Q?2uyzdhD2HlADtSZLdeWKKwMLasd5KUSICQol5mgU+qu6B2qtPE9lhrFaR4kY?=
 =?us-ascii?Q?/ofZG4Cr/B4hC42QvsB43vCulnsaNtF84Eck/Fxq7NPTaK2HuPTY3sBj/FCj?=
 =?us-ascii?Q?RneQ4obbVegofxOOaj6ezUtt/ZYD7MCXC18+y7mhErqNk2kG8IJ70x7NP09I?=
 =?us-ascii?Q?RxqzTtfKkHs0gRHvgLbu6q/B/JzxHMxrd1f37Ixmg8goH1ZbnSLwsHC3QaXg?=
 =?us-ascii?Q?ZDcTYc9hwWKg9Y4GgT6lwIoUmQ1Zrs8eq3EJ7GZz+f9laI4LSQZ1qOlmoouV?=
 =?us-ascii?Q?uGZTv7mHPHXfkhngpqn80Qd38Ibz7qVfTlUF2BZwlzNMwzPDln3yHwPpBBF/?=
 =?us-ascii?Q?KSIWkr9m3s9IQ86FpWfhwQbXOCZgj0+cJwZFdGsPxnvu5nFjrKhhdOqxul+Q?=
 =?us-ascii?Q?dib44MDcHmNhQuLoGetMgXR5PHOtNzLnjP2S?=
X-Forefront-Antispam-Report:
	CIP:4.158.2.129;CTRY:GB;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:outbound-uk1.az.dlp.m.darktrace.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(35042699022)(82310400026)(36860700013)(14060799003)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: arm.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2025 09:35:15.6098
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 807c9022-3348-4c68-6d42-08ddd0158e50
X-MS-Exchange-CrossTenant-Id: f34e5979-57d9-4aaa-ad4d-b122a662184d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=f34e5979-57d9-4aaa-ad4d-b122a662184d;Ip=[4.158.2.129];Helo=[outbound-uk1.az.dlp.m.darktrace.com]
X-MS-Exchange-CrossTenant-AuthSource:
	AM2PEPF0001C713.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GVXPR08MB10714
X-Rspamd-Queue-Id: 9796540009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: bbepetx63i3nxazamcynasm3745pc7wa
X-HE-Tag: 1753954521-499048
X-HE-Meta: U2FsdGVkX1+I1EIn73F5GfPImgukpbhGPHb6ZVfp3HiDde852MWMW6DfpXrjuOek92tZSb+617vlKx5a4i1A9Ch8VMh/pMfAldGySHO1kgJIIZLRpENZUmKC7MBZZVeCyvwp3mqKPAeqBKwbzP1Bh569puyQkEG3hegqfuMDCN42U9ZGzkta2n41Jy7D3IL/7vm9Fz/+qsxryI8tw+LmGcYhxUNWteXKCqm1curhaAjBJVThNrPsvwArOpO/ujm/BY0NSCgxX2l2LWx5I2UqVNEaz25DxUa14X3fmFZbsa+kCjbypA/+SNF/8WPBozvmD08NXKzc5Wtp2T8GDkmYCLiOdwKM/V0U3vz9W8TwSmJRdnUFchY2l2BXki4JDJtrjTtgNEda+Km2MCuYYzYTBdYupdp9RSeJ4alJ/Skv4wa/71X0N2rR1CT0+UAudy64FtZHYP/sBiqa3bDNdI8EOSRmeGsESojcqix10DFbkYVotjk5xNHC04R4zigzQpQ8oIno9cClDa3rDeT9GtEr2a33pRTVi7rJXBLL2LIg2rvC0wpF4yWVXQhfqf1RTaImXsg5+DytzN24J+FXVVeUpyfVPc4mQXkgXy+HcLm1tBd6g00bONTKhbj6boam61LIc7NmnWOGd4uSnUg830ZSOPYOdT2F6RraMbf8JEec4Mh8AUq8JK1gcx4tomJUX2I1xvwUkGZIIaWv54tviLlvfVaPY7n3hy1iMDqBfATbc4xzev5hgI49tjuXYcANeBH8AXQ5CXXxxEF5Tng9/ujGCVUkw0JMUo+WqDhzvRv5z2xJ6Zmm60FRK/FY3O3E9rnAAraMV3q0SxiqfdIPABsYeK0t9rw7iK+bzLCTrvdDMDPWt6+A51rNXVUL1V53zSBgMadtKSpXKv3VH9iQ1+EtZfNUbWSl+tNiFjEjkTcjgCMnpmkhVIfKaWp0FmuLRkFjNJoi4SqLXmN8reflSgr
 6W2Q/Hdv
 Dm8SMAM7qxojRZEHOVsurJYEOTAhXmBfVkcTMNGwDflSaAbJb7yWUxilPH7dbeFdqCZMyPUOS25oPBOlFw4nRANPdcKpylVdudq/QxUvYIW5Osj3j3Qk9mhgzfFo2hcn61YZWWiCirsjMntoLaaLe3Vz7JcnsoYEfCSbvi3qBJ5fqMMXjx8zF4D7ohc45pi6GfnAN/HVmqfoUooiIiG83zCudUbJH9GDDt8t213MFSuaRXhFVHOLHIjowAALI+ACqmh34U6A63mVEapUZl8DbvlpRrSo3TFqxj/6M046y3cH+kaBv+kWFCjPv1cZw7MN2L7LQLcgfD+fVMVt/o+0LEj4Bip216dn/ulchMv/i+H6PedCwAKkTC9QtAjyDQRIB2e2LCHaCUGG5jBt/NTZdJujuUftuH1WDtxpzch2HmqSGVZyVWdphQ6GR7Un6M39gf+OyG1IDQKFF4t2LILIeHxwGnniMPkG1sU8ASKAfHhMi4kgIKPf6YvGWlEN4cgVFhIx5bTdCmaLJmFB53W6i6C+QRVIKPi68uYOaDTrb+YH6KqMHu5efaXTLpR/A9RVbsq3Da9fQDx18kastFpkl4f0cLQ/puF0xq3pFqqtoqZAORQue3jOb2JYYn2vQqDWM6Z60ejnWSzlsWQlbToYtUCyTiiOYuP24bAT+RYuxvvzJAgcUsG5ZfVnlb5tJa9OaCIhwXSSOBSuMb/4NM2s65uOPUTfcc9OEXTFe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thomas,

> > When CONFIG_FORTIFY_SOURCE is enabled, invalid access from source
> > triggers __fortify_panic() which kills running task.
> >
> > This makes failured of kasan_strings() kunit testcase since the
> > kunit-try-cacth kthread running kasan_string() dies before checking the
> > fault.
> >
> > To address this, skip kasan_strings() kunit test when
> > CONFIG_FORTIFY_SOURCE is enabled.
> >
> > Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> > ---
> >  mm/kasan/kasan_test_c.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
> > index 5f922dd38ffa..1577d3edabb4 100644
> > --- a/mm/kasan/kasan_test_c.c
> > +++ b/mm/kasan/kasan_test_c.c
> > @@ -1576,6 +1576,12 @@ static void kasan_strings(struct kunit *test)
> >  	 */
> >  	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_AMD_MEM_ENCRYPT);
> >
> > +	/*
> > +	 * Harden common str/mem functions kills the kunit-try-catch thread
> > +	 * before checking the fault.
> > +	 */
> > +	KASAN_TEST_NEEDS_CONFIG_OFF(test, CONFIG_FORTIFY_SOURCE);
>
> Would it be enough to enable -D__NO_FORTIFY for the whole of kasan_test_c.c?

It would be better. I'll add it to Makefile unless other comment is.

Thanks!

[...]
--
Sincerely,
Yeoreum Yun

