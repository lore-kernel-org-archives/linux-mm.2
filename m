Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE1C2C87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 03:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49FA78E0006; Sun, 10 Aug 2025 23:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 429118E000A; Sun, 10 Aug 2025 23:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9E28E0006; Sun, 10 Aug 2025 23:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E8326B00B0
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:43:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BC6213785F
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:43:21 +0000 (UTC)
X-FDA: 83763081402.17.86D70C2
Received: from TYPPR03CU001.outbound.protection.outlook.com (mail-japaneastazon11012034.outbound.protection.outlook.com [52.101.126.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2AC8B40002
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 03:43:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b="M2VjGCe/";
	spf=pass (imf27.hostedemail.com: domain of zhao.xichao@vivo.com designates 52.101.126.34 as permitted sender) smtp.mailfrom=zhao.xichao@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754883798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bZNhe5BaW2iApbq4BISISCgpd4cNpGKbdxT255hz7Wg=;
	b=XTdHvdTicD5nsX2mI0yiX6VAaz2q5824Gp0as5Y6GWZHnBJPUTudSh3YCQkxTh3iQCl1WZ
	PEoP7wBi7dND/pj+/M52xnzbCrLCp9HSv9c6BxnRU9jNHkJAFY7j21whlRkF4rWRcnH3Tr
	8F+XCtlbGcbeonY5ZzfEMbU4hlKmXcg=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=vivo.com header.s=selector2 header.b="M2VjGCe/";
	spf=pass (imf27.hostedemail.com: domain of zhao.xichao@vivo.com designates 52.101.126.34 as permitted sender) smtp.mailfrom=zhao.xichao@vivo.com;
	dmarc=pass (policy=quarantine) header.from=vivo.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1754883798; a=rsa-sha256;
	cv=pass;
	b=RTADHAacpgJxvlCPG1d62aiQ+u1Pasa2FK3g3OGREK33oka2ZW6s67cgXMge2DHgTMWbDt
	jXyJVzZnm5CSv0ZO6+mnXphvh9JB6dXMHs0qAOREn1gdzzRhPOEfCrOqSyQDU9YPCbU/Vv
	OcJ2C17Lh5z+Uvh6v5+yZNDsd3iaAIc=
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qbZRApYT/LGA78jbg0WUkczHMKP4BfeDD3ripegcsCc747HzYBTaMJVaHCS/MJGXD4dek1UXXJ9Tj/XhhEFYKDOkr2g8m+Rig+U6Fsa33gD0snihGzRGtZ1stXfephlpdjwc9uqNUm9TDKuxfY10IeeQ/tJNR/TqdaU0LOFxva6IWNZE5ZuT/tAmhu7q+NLvMrnNLkQwNbBlS5KNd2PeEREomEt0941rRdsuRQmwACFMggkQK3yUkkzR+mxlBpollqLR6p2A0Ic/ytDU1pgEnbDNNmFrQ9nIEcm+A/wLBNxjr6w5/DDT3lYc2F4xx8PoB1xAFXcHmARJfrON4lLMeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bZNhe5BaW2iApbq4BISISCgpd4cNpGKbdxT255hz7Wg=;
 b=TYna/2s+40InNjKaDIPO8U9K8xqtvZ2Be26Xj0eEZ9YnRYVnF5QQpFBjkxEpnk9gsRIPSpkYuEzQkyrr8AKbNlVwjRmu/MOdTpRmb5ZEGk7eDinWUqr7EddEzm1GTvmdJW60lR2LZvftIsu4anJvXKqpd92Jwg83yCwTAwnNRSsvRcQD2p7zNYKWMQs/W3Lziz2c4Hy+bDKCAfMz+uO2NXACpWuen5OSuLjk3zzSFwtjKaL6n816zQz1VcA6y9w/OqxqiwxLFcGLi0qveUCA9u9k7c/GF3zpiDVNLnnIil0H+0uy8KKsbpvXYlbPDvYq5YIp35WL03AU2I8dzhsAuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bZNhe5BaW2iApbq4BISISCgpd4cNpGKbdxT255hz7Wg=;
 b=M2VjGCe/AZY98z7Z/3Cm2HGdRjbjGeTpzgcEC1G5chwsQ2iOecdTruUgJ5RZ8WNtjGBqpWyd4bJG+KpPpFeDsmLB6jRX9oE2aADetVwtxBa6X+nuAIeChdGj4urcwGu//waamEkYdw3yl2TNyGtS4sVsI3OwuboW5pbXr8Mq+VN8MmVBluZKAJqgypT5tltVuNM2KulGO1Mv4F41Zo+cCHHiZkuINA0Hne6zdY3f8z7xsk32IZi7iUF/i07T2xn4oa9Gx/sOtGa0WSXyk0eCnnRwykV3RDaORp/bIW1tiv59DbS52Y8rr6zBUud0tnnM8FPnTeJs+BiVjTe3zKLbiA==
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com (2603:1096:820:d8::5)
 by KL1PR06MB6905.apcprd06.prod.outlook.com (2603:1096:820:12a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Mon, 11 Aug
 2025 03:43:10 +0000
Received: from KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb]) by KL1PR06MB6020.apcprd06.prod.outlook.com
 ([fe80::4ec9:a94d:c986:2ceb%5]) with mapi id 15.20.9009.018; Mon, 11 Aug 2025
 03:43:09 +0000
From: Xichao Zhao <zhao.xichao@vivo.com>
To: ryabinin.a.a@gmail.com,
	akpm@linux-foundation.org
Cc: glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Xichao Zhao <zhao.xichao@vivo.com>
Subject: [PATCH] mm: remove unnecessary pointer variables
Date: Mon, 11 Aug 2025 11:42:57 +0800
Message-Id: <20250811034257.154862-1-zhao.xichao@vivo.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR06CA0010.apcprd06.prod.outlook.com
 (2603:1096:4:186::6) To KL1PR06MB6020.apcprd06.prod.outlook.com
 (2603:1096:820:d8::5)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: KL1PR06MB6020:EE_|KL1PR06MB6905:EE_
X-MS-Office365-Filtering-Correlation-Id: b6d5bf0e-e28c-4ecb-d7ca-08ddd889300a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|52116014|366016|1800799024|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gJEwACizBY95GLMfpwdcFxphKcIprvpNrtNMmb7X9aVDsFEd4wQzEi3V37QU?=
 =?us-ascii?Q?DKlmRlPh99mqsw4qdHMRPtvQP0Wk283OW7VyCnhw7RnRXdtxSiKGxxr1Vb7m?=
 =?us-ascii?Q?tePkwEcgjyxcA5S4Aa7AcwcvwkzFvjHbDkT9MiHCRb8Iv1Vw9QJNR2/Z5sMN?=
 =?us-ascii?Q?VIcmzDwYaNY2VpvMUqVDBvJ6y2agLMwPWg6ifx+yV+fpcBK1WH0QVD0y3aO0?=
 =?us-ascii?Q?G/lZIrEGEVu+m1Xfh7i3t1xpov2zhTkvc4w0CKU/w1ou3Ck1IwkYwPdE9END?=
 =?us-ascii?Q?JTSMd0Cvdlbhoacb2IxmQFSyEm/2YC3pjQTnuh4S4uKhAvNT7EuPq6BC+cQp?=
 =?us-ascii?Q?I0HaPBclICJwyVLppzQO1wcglZLnP5pjZKLlp9y6gvm502ahbAEJvherPbKI?=
 =?us-ascii?Q?ovipOYXna3JsGol3K7BgTmCBD3lZXcpZCs8iymZh2vz2yDxyd23vgfLDagAi?=
 =?us-ascii?Q?rgA8BiT0NEfahi6OojPhpGks56IrN6CnPLF8U2KA7v9QwtMGPpD9mvV/2qg9?=
 =?us-ascii?Q?ZAmiaY94Li/aZxT4IqCDEAdFLv6K/atPQKoquKUOWPQ45+BE0JDgHW/KO7dU?=
 =?us-ascii?Q?TpQ6VsuPkTQoXrFlZt1J4Sn9EFFFcMTksbb8iBDcVmMSu53x1xJQ0qBjeUVG?=
 =?us-ascii?Q?k+9C7rv1RvDP8Kklonv82CFCYbE5YqwjiKmSI6GT6QV9rhjAHhOVr6emXwad?=
 =?us-ascii?Q?KsQ0VlhB8qpWYDb3eqIxfk4eGk5aO2NaHlqjVijhn24RkPF3Xd/vIC+/hfXp?=
 =?us-ascii?Q?hB2p7V0VPnzavjr8OknhLzX1vod9j3o4fLSnqumBhrc+4G8dqxMKPWdmAAHO?=
 =?us-ascii?Q?UCgxdDPfMLQpK9ep5iIP/84N7xwCn6CqBud1pWZW6HRfB4jomxW7bt0i+uZb?=
 =?us-ascii?Q?C+DVaitLZVi+QFQItmWPfYuUZ4YlF+EUdb/rKRocb7ok0akg7frWP/dEL+LG?=
 =?us-ascii?Q?Gy2wu7gtU9E2dEJqiIhz9/3tyjxd3JqEjuquFFcgg/kRzqPJLR1dufjGThM8?=
 =?us-ascii?Q?j42SaWxhnbqx5+IVvBnxzPvJC1t/nw5tDM3EkkZ0G04ykt1F8z7/a1N0/7Yp?=
 =?us-ascii?Q?unvedN+IX3U6bQvE8FSchLUVugQBlYmKf0e9Js++TuZveusXo+tdxfZY9T3U?=
 =?us-ascii?Q?IiAYEKOI4YezRB5C/b9QTvhSCAM+akR/8f/CIixQWLS7QbFo7sbdeGtlIHBo?=
 =?us-ascii?Q?LyYyGN53QYHHfcAx1oekrWpIf5ZS5zcBV6p+rdCVEaX9j56y2MMBYXRZb4e2?=
 =?us-ascii?Q?xD3njz476QE4HD81ZP6MEG3nZ6X/dPfEdKSAj7hfBbIDtjePkgrJ994SEAU9?=
 =?us-ascii?Q?72ZegQVrKz016MXy3XmzYpjr7RXwGGPa1Juj9KlpK8txOn+nhj+2jXbletlI?=
 =?us-ascii?Q?HDaELCCaC+Fy2bhnBx7on8ZCt+QqSRt4YzxwnnFSD2yLJvcnIijYf6CX+EKI?=
 =?us-ascii?Q?kp8gszew2vAbvccVmLrHWAXgmiLoVLOOYAdWJQaIuUVXGwPbkdztBQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1PR06MB6020.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(52116014)(366016)(1800799024)(38350700014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DYgUskcmN8t8YZCtpnCUK2+q0dnww4b/ZB2OSTeA9qtZ/DYn50n5MdNILY4q?=
 =?us-ascii?Q?rKxRnzTFF9U3r/j8M+65o9EvYNryjd7CqLlBPGc5Ty8ciptHrlOT/A2dU8HC?=
 =?us-ascii?Q?LbP9g/ovwDlwfy+e5a1e7/HWpojzAqjjlxaPZbONisKBKDg5H4hz/34SkBtO?=
 =?us-ascii?Q?jCmOY0I4YUFiNlfkaIwSEzoVi8jAODqfK/givtxpCLhz7dvJHbV7oP0Dg25I?=
 =?us-ascii?Q?+YU7OpX4I/EoHAjHPKQXUCMU3NMOzin1CsZWKpeRS0CCIiJLGxXCWMOOBjuF?=
 =?us-ascii?Q?gaqWw8IvfblWkClsVEVqmUSZorz71vFunmqY30iA06pmAvReZ9jlHdi2XfnC?=
 =?us-ascii?Q?gYL9VDZ1kduiHyy/TFMdDjNBlOW0tww9kR2DI25G2vB8dCcBDNAv/pEzFCNb?=
 =?us-ascii?Q?ApHDiRN+vemfufZp9gQATkHBgvzqPjVllxcdPS/3nsLqopOzCtTnoOSf6Ef1?=
 =?us-ascii?Q?jK/zGY2ooOxNpBMQKgURjihhB5BQjw6Eo0PlZxwwy8Gwy4lmZSEx8bsOIAK9?=
 =?us-ascii?Q?Olj5qj67CkG62Wa46BvuoIZTe0MlM1ijOKjw+NBYblnqrJIXR84RCExg3xgC?=
 =?us-ascii?Q?qnX1lbROzlJtnmZ2wFeVzfFdoB7patfxhi1OdrQzo6CRxPiitJLQX4Ap7Ij9?=
 =?us-ascii?Q?7O31n9kekZ3l2vdJ5/HayHH28DLddR5+YkngdhqTRtLzVO4FXc0gRQDMuIKv?=
 =?us-ascii?Q?6QZl1SK1g/YQlYukQigXSCI9TBjDR/aISKEk7sm4eZ54tdOGKBXXuujCna+i?=
 =?us-ascii?Q?z96cII6RKt4CCtH+FMUXLF7aeCSKmm2IYQPk2rowWVx43YYAYmKnZDqu8bqa?=
 =?us-ascii?Q?1sK5UWPvrcynYVnNBwaaNfobg8Werul6eQCI3dzRa4irtZJsiH33pKwzESyN?=
 =?us-ascii?Q?hLi5ZRx2kqBiXLIiSHsOjlu084D75NR9g669CPc2uwafRFj3uLoVBrgVTIkf?=
 =?us-ascii?Q?4cQajrSRhwK60B4vc/oV9EBtnHL1rdVDasXvkyUvoPCAK7GBN5ALv0aksAZj?=
 =?us-ascii?Q?BnvCa7xIHQRBozRu12FEWLgjSmVPvsm57qEQNEr3Yvl3PQFnsgJgS/4z1SIt?=
 =?us-ascii?Q?WV7Jbgq6ndNh3QOuScWBeV1jw0O/7X9q6f1tL2HMEeWdWxsiw+T316hNZ727?=
 =?us-ascii?Q?ESeaol74C2CAHo7s32GSozMhPFRWX49I5MpJNPJYvzCohoMweMxpdjnXjK6k?=
 =?us-ascii?Q?yx/LEBns7jI21uWgfnvDDBcdMzd8mvdV0gLFpE/9d57OAqaBngLxe3blXnPA?=
 =?us-ascii?Q?hUEQzT22hAQwzDbpad9L1gp3iQFsdN/XkDjE82zX/1E/Rf+DfvhRhXkO0qI6?=
 =?us-ascii?Q?ZaiuVCNhXPZmvVLQ0XnM6rYeTKtYNR6uNIiUGnJ3rNHM4mM8Gd16MOpZ6dgy?=
 =?us-ascii?Q?6D2p7bbn94OsndkGLiX08wkkLHnvkQUvGcWAO3e56q4CunAr/O2LmOX0IcbI?=
 =?us-ascii?Q?s5N39JKhYn0GXYkD8Wy5kPLy+qKZKdBUe8iY9OePWsJ3AdLXkq6983lLg02w?=
 =?us-ascii?Q?74yfGIHRggPgOI8/4bAGqfSIp+ATDvLEhmUWT28/Q8gwHH+GIgTNTikiB6HO?=
 =?us-ascii?Q?nvOvPDRh3AvWYuhUUSFM7WPnUU+4dU2rW/T5H+qy?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6d5bf0e-e28c-4ecb-d7ca-08ddd889300a
X-MS-Exchange-CrossTenant-AuthSource: KL1PR06MB6020.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Aug 2025 03:43:08.9219
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aXO4m8Y5Rb4rZJad121IBGX3PBedG2sX8QGGdY54OZFHWkIZKtmTaOnf+yLkvbDung0en05Yj0OcPD7OFhwMYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR06MB6905
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AC8B40002
X-Rspamd-Server: rspam06
X-Stat-Signature: is3foeh8sahpofd1rtw78u79neuamh31
X-HE-Tag: 1754883797-77096
X-HE-Meta: U2FsdGVkX19XyUgPdCuXfHSF4jasxq49MV8H7ygV+vtR4SqKppVpIWRkSfcsnV/a/LxwfOLAeikLM459B3zg/Cn1VH13Q1RpEC0t7QimnPXhQaAPddkLBjNfNisQkRaVQablBmCgVwN5SAhyvZDCR8U+Xwap6NN0ocsaUyjSsvnJs4h0QjlZoAa8KT1hnYe+SPv8/B7ET5P/t24gHEpWStNsuqpWZAbCmXytIRtmxzZQetTJpkrvqoATV0ZJ8JWigWDnjMrLXBGnilDNDu0MCByNbcJ2pFlntMPZAfhemm1evxySPoMlzuRycy0yyI32KVzxENkaqaMcVDxV9qHnouqDUKxVbVC2OfvnMu0dwUZ7A6d/nDW+5AJLzTWXJvu2+J/6Kq9M9AeNQJVXYYqzKeLKgi647KE6k/BMgKXwjpn7oDdFut31S5g4QeHL17RV1R66iBSuVUqz+CtRQFKepKnZnKFvBIEJ1nRGzuR9riq8crikJOI/CKA0yDq+R3AeGXVVdSnUdGbsr4o3+JDcGR12OAquFPhqYF5f6xUV3tml7rXiJiyKmpxq+vW4yDbw44x9v0fXAElfXQS147YNE6/MMr8QyW8Bbirz6FZI/gLxduMltk3+gMVjpUeNIqzCErmiJeXqjzVonzy1yC+h+Bn2igU0hzQ9YkOtbfy8fIdS4I3qGuUPrgcJn1kTPqITRuL45G/pnTZ4V4lbeTni1G4RFdq3Wjf9x0eDkbitSetUD7ahSyXHK6yQhiXpdmFZTE/aGYat31LcI7i5EFc6BwXyHtyNFKgXmEHUbJvZT9ku0FVBKyM9FohWjONZPe3LmL7HqQECvUE9FrFA08XjaNHRRPlrKl641gzCaWstcwX//MsW91jG0y124iQza2Mp1FzWHkYUgaj1oZIqnd4+PgZqEp/oNsB+76oNsV459sP1lUNo6WmSWAjhgjRdqHFb4b9SKMaRiAeL1j8tCiP
 ld/mlHaE
 8mffJ03jD8sZuvHhUkJ/ezccI0+0qVEOpUUhng5HB5sBB/upX1a7mbVxj57tjrdP7fe51OiKfCDgZsiiNMijVUOPD7kvU2MOK2cXE8OZ5GGeu/zdSd8ibqZll1X7M/ZcsvxF01gH7BQznoZVBos/VzRG8v24YnEkSsLAPUB0a3OzOvuvxkn0f09ldN1yLzkekwpfOz+7hO4nIEV0fPMlnRCPMaoHLQEj3qsygbT00TvrqSUJiLasJdNSR0hkLDELnerUHVO+L3oVLwIsAtqZzds1l0ZDcNLFfd6CkZrf02sbYGdiWPZCm/b2d2VHoudUdV3o1CBUWzuVgKxZ+0o7XqKhG4yC0PAaEgabV1GvYnSV24mMwyOtlbAz9AGAfA6sc9GXPR3rTiNTwTVIgUd4/jCtpMqZ1v1jO2PXgg6O7CYkFejPlKNjBSk6ktqN88bGUaFDZqmAmjpdgspMJY/dpqLUJS7UfiW25315PXAxTKi97IOTRQU2RZ0nzu0E6mwN5hwT5//btLAbjIlVWvRIoXNrVnwjLsrZEyLSZFkhffIZo2HJsQFpuwevj+7Ma3PAR8BndA51MD/rw1S0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Simplify the code to enhance readability and maintain a consistent
coding style.

Signed-off-by: Xichao Zhao <zhao.xichao@vivo.com>
---
 mm/kasan/init.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/kasan/init.c b/mm/kasan/init.c
index ced6b29fcf76..e5810134813c 100644
--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -266,11 +266,9 @@ int __ref kasan_populate_early_shadow(const void *shadow_start,
 		}
 
 		if (pgd_none(*pgd)) {
-			p4d_t *p;
 
 			if (slab_is_available()) {
-				p = p4d_alloc(&init_mm, pgd, addr);
-				if (!p)
+				if (!p4d_alloc(&init_mm, pgd, addr))
 					return -ENOMEM;
 			} else {
 				pgd_populate(&init_mm, pgd,
-- 
2.34.1


