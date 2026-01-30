Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42117E6BF10
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 21:00:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9637C6B008C; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6856B0092; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D546B0093; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5129D6B0092
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:00:29 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D08C1B1B4C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:29 +0000 (UTC)
X-FDA: 84389848578.16.B5B9656
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf04.hostedemail.com (Postfix) with ESMTP id 918B040011
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 21:00:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FHvx7hWO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J3uCt4OJ;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769806825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=;
	b=id5hrhrHDvqWrNdPFjUlW2EoyftdvAx68qIYdZDIRljivv8mDi1f3e9r25GtFxQRUOR4ke
	iSkNXC+/1sXIQUYYZLJfNoeyOOgZgqmpOt69XyZfoACRc7HPqFYL9gUfwueSmK8ahdSTBc
	64aDuv7KGkziXCxxSKf53wTfDsCP12A=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FHvx7hWO;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b=J3uCt4OJ;
	spf=pass (imf04.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769806825; a=rsa-sha256;
	cv=pass;
	b=bmqVnSru1I6pTLBpiCQcGQse4gBIo/XV8hnycVi/ez/pUtOG1mYX31syjOeP3r0P1ZaaXl
	Q331ga6UXeNXGIDmabZ0CLWxfYb+Lb/6/13Px5d+5e5ENmOKAtQBnEADa5UV5/emIxs8SH
	OfNIg9zAaC1lg0P/gLioO4W4Etd0Dzg=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60UKDSlH3910818;
	Fri, 30 Jan 2026 21:00:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=; b=
	FHvx7hWO7ktKAQPCai/VC59LTT2ZXXE9wOok23ooHOZDTunXPF2+sJxfjzv/hfMX
	fkSjtkMe1d6eHOuxAj+y02VDJn1Z1S1BYthnMMptL9RargEh9QH7nHxIGVcgW3iu
	F5TrH7N483wXW6r70iFR0QFBzeWGZx7Wh2+TMzg8mfJgJcRkXt7DQ+w80fWMi1il
	APNceQADcOeIQ5GhgMZFpBANDFwm7iNNQTu+Y/ERiZZM105/fLOR7M7EKmZ9Inyz
	aGyI79bpO5+X+QoIsGiq8OWQVXmuOxm6gDSZdOOMFb3NPpunT51UW2r4+5Ikcwy5
	nJbVLU1t6kQnchcpJD7swQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bxx09pm59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:11 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60UJ1vPR012499;
	Fri, 30 Jan 2026 21:00:09 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010027.outbound.protection.outlook.com [52.101.61.27])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bvmhe5fxw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 30 Jan 2026 21:00:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlmpbFOFkzs03Kr44467kbpAH3q46zM3ulBp/M8hoFVxVCzEviAcRyLcN6nYx250qBkaCck4Ipa12W/90Gkyik9NGP5DFgNUtqnqnq6C3rH4lDB/GDtr4xSbGql+X5Cd+BVqBK+TnmN/JlxoxQLUomF5mHeJQlSz0b6dt+Ad8ClmoBp52z2mr8pxql5WNOsyZbxrCueuJXOsTjNywiAWv4foTUpr/PYB3gbtTmvAOknn2ELWwOkIIa4jteQvFN3d5VNdqXO2zX5+ic/aGoBnOlnJoYp7Y/eiHEEldsf2uK3D7dyqzdcaOm+B3kQDaPzJoVkxyipF1hW+82RZ55gkCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=;
 b=buCIQBjOBWsipRK7/AiSyflPuQ/aDrL84ha/8KLRS3Kp5ChgNsq8HNi0KWizieNaYPSaQgh4H3gPIKjsl+X8Pb59s2CJ7wz0w2fk4TxuuQUfpZ5BPX/a45tfIrSKUZdKb+J18bL1jXdgtSZrRoF1jE5/xIlWXr8g3BIUO/Pqe0U9Bx086oFnHNG+EdPaYJjlqkuzdyxf/T9NYHtGxv6Croa2BIpZQbSvQb1sgVy2Jg5WP7WvT3F8SfqH5jSZzR5oSkkem33h8bL1shtnGz7HQm45aFM0HIfcOGcGqbiNmXdyUzUXbYFR/KdN6AUvclwebwgbEAm1myjH2CgTG2U8aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PAodV3H4Y2rNiIqjcqcBpwQAAZmeSG2ZSvqdZ0H+vd8=;
 b=J3uCt4OJDad0Rs3f4RZiJ+6LzAVxwDTAO6tt96izlE9a9LcNG7zvsQlVLaFVTFZwsiVF540Kp0xGJx+Mu8LAo94R9nTjs4i4L023csMIjIgRFSHw5K6Zk6aa8ye4OJc9uKAuFm4chuBLb9w2MWLQeEi1HT9FanzSw1HuysfTn3Y=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by CY5PR10MB5961.namprd10.prod.outlook.com (2603:10b6:930:2e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.11; Fri, 30 Jan
 2026 21:00:06 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::4b84:e58d:c708:c8ce%4]) with mapi id 15.20.9564.007; Fri, 30 Jan 2026
 21:00:06 +0000
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: maple-tree@lists.infradead.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Sidhartha Kumar <sidhartha.kumar@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Alice Ryhl <aliceryhl@google.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Arnd Bergmann <arnd@arndb.de>, Christian Kujau <lists@nerdbynature.de>,
        SeongJae Park <sj@kernel.org>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>
Subject: [PATCH v3 05/30] maple_tree: inline mas_spanning_rebalance() into mas_wr_spanning_rebalance()
Date: Fri, 30 Jan 2026 15:59:10 -0500
Message-ID: <20260130205935.2559335-6-Liam.Howlett@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
References: <20260130205935.2559335-1-Liam.Howlett@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT4PR01CA0501.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:10c::24) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|CY5PR10MB5961:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d27b696-a3d1-435b-61ea-08de60428bbd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vhuqP6A2igc6KjVgodhqDFsFrXDTiB9l+5CsjnEFlNvXgOHzewDbG5TweVri?=
 =?us-ascii?Q?CeXSw4kkElIZliwaiCNFgyo7hiya6f4TsQOh9hp4zt0UfbA03ZQA8mEiDqy2?=
 =?us-ascii?Q?fT0JBqeT+nGkPzy8KI+zNTw2vWY9+ObOfsjpxnlCHNC4L/MbV7BxnBlSkIdB?=
 =?us-ascii?Q?FwwxPzjqcsKroqtAHdXlqS6V6C2/APq3MPhYXO+C9RlE6Ts7TqDBUu/JxvrH?=
 =?us-ascii?Q?nDq3E59kmOmWXvx4q3MnEYydFhP2n+HbFzFONufo4ojBkm1sBtduPD90A0oP?=
 =?us-ascii?Q?TnoMPYZasNptx1qKBJQcsl7QzIX9BiVxbNMc6UxDxUXmNZzM8rhUqkDU+0gV?=
 =?us-ascii?Q?zQV8UU29614TqUyiZaxdTbE3Lu4uXuFvncHLexCdpEkVUdz7zA2dONTY2qgw?=
 =?us-ascii?Q?pV4oGe2uLxv9CmqErEdlA4/EX+h4cnd09ENz/7laHKg+y434Z8PXnN7wb5oh?=
 =?us-ascii?Q?tvZ4aKBqVJXFFSVz4djcX01NlJP/78S6IOpYiZQGZprkWy9xpA4btAO96SHe?=
 =?us-ascii?Q?Tg1KZQeB3ESiuJFcyOW//iAmlNwIWO2E9MRAA5uAu5XqA46XNMjxzPsGxwz9?=
 =?us-ascii?Q?gVDZ/kzWSHyVZ3CMPUC4WnEIGxOVDROrLKOuCj94g4N8fRBY5WiKcWcRgVAG?=
 =?us-ascii?Q?yDMAJQaWKlzSFJvDJ5p3wUxLJVdW/7zKvKYYie9sIovVMq8cjpMihjaB9U/S?=
 =?us-ascii?Q?pYBnpYjGMdCZnslMY9DqKZgUFVQR29B5rn8Z3C4MhbIq3vZVyJfjhTXbsKXJ?=
 =?us-ascii?Q?WclYAuM4mZdDwa/cRabDs8ixG3FrbjusGC59sF95gGVIB2YIqE5hFCmI/faH?=
 =?us-ascii?Q?tnZHg0dXvzT9NNEWoepkcp3dcrIpiq3OZc6gB/9azF+8o1kTPt47i3XV3RRL?=
 =?us-ascii?Q?hkX6IFxwUeW47F9WAbidACAL7Viasb9SVE1l8BOqvDdXqbkJni2HwoOY+hC7?=
 =?us-ascii?Q?K+Sok9nga8VNEJQ27jDaj+Q8bY4yNqtMf8uz2qnacC9xLXrLwXYXkQ8vwVYb?=
 =?us-ascii?Q?pqFbXPAenbV3hJLTAWeoCZOfwBrLz5VeWlZ7PqYDbAoRp+bKj3y3AU7pZJQ6?=
 =?us-ascii?Q?08QkNdjNgDOPX0JxmWJDxUlhixCySi9oG6E9JaLwE2bjfjjnSaHBMrJCnaZO?=
 =?us-ascii?Q?88qpsUKugw32keTxxYxMvhPeVMBS0qPWaW8zkziVddAawbrAaU96pWJ0Dyxq?=
 =?us-ascii?Q?+uILsGumuFpR6ncTH8ln/puaHPk+yiURK3DcVmqaAtdqWiaiX3MsE53DkTQn?=
 =?us-ascii?Q?emx1ZXEJ7z0CxpjtCpLnCrhq5x8doNEYNuXZAOjCuLOmqrg7qLccGbPe2w7N?=
 =?us-ascii?Q?Si+EeWGOsXPJ9DQhpYS5otDqC8w4hYa8gxD3R5fXwU5GOlr1hi9m049gsvXD?=
 =?us-ascii?Q?DXsFPCXzbiKLx7G6Qbms1L6Nu7cPuXxGIBOwfZflRIrA40ptczf6MApFLfpr?=
 =?us-ascii?Q?JNuqtVFwFgmxDwsVEoffWEeR/BNQkR/JtLC94QOb2JQnxeOjMfQBPwQhMR0R?=
 =?us-ascii?Q?BJIuobUn0xAhWou2Bvcicsn75Cb45XzQ2DZct/eQCFDcNPBOQsICqGd8sSEn?=
 =?us-ascii?Q?iZFsvGvuQ5GyCHJ7RFk=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?05r/Fz8fkVxVaMVheiERYNe3s1vdL62tPjqSC2fn9nHO5L+bMLij/Z3Zc0Oi?=
 =?us-ascii?Q?O9J+RZhuxLKmlR/sThwhOPC4EZiohWtk0Q6M6hD33SE8XdlJ478LvX1WWg9d?=
 =?us-ascii?Q?4hQGMBum7yvE//G7VxFP1kzQEXER/o23165AsOg54aO6YZtQe3ZsS4YzPtuv?=
 =?us-ascii?Q?nnrFMWAs+aF0o/VRY07EVx7Z/5MLoZm8224KAT5RmEkhtXZCMcry2qy0Hm1/?=
 =?us-ascii?Q?+KTGDasEokg4S1mMfwsqfVVJaPKEG+7kkK28+BCiM3Xd9YAeuAwag2oM0ML3?=
 =?us-ascii?Q?3n1tM2BAUw9YGpl3ADGB6QnZr6SLh9r9ihCwMeb0TgICOffKfDWe0fefxcI9?=
 =?us-ascii?Q?nYtfhAidEclK+atXJ7OT/jYhjP9ettzIOKhRitd32t6To5NDbEreZvtRarwh?=
 =?us-ascii?Q?In+ZtAci6MYUggEjBwqgjqttzriS+ZM3AsaoVD6z2vEqCTiyGv4tSZqEiOb/?=
 =?us-ascii?Q?LKiwP0VpgUYg0ia2gjeyWM2Ltw/rbOXWszWShnMOft/p0ZuBKYE1cu67s48Z?=
 =?us-ascii?Q?LTa13iIPwCJvJ4rzZdXe9xD0UQUBKY9UdmphS/FB0/laTjOInlnRMGfcSykY?=
 =?us-ascii?Q?LkPuU9tbA7aNsEQLy8zyEc2loLtv4K0fOuH0ZYf26AzOlL8YiJPXkGMsDwH4?=
 =?us-ascii?Q?QL/XdyyPUKn6FPAee0+wVoZoc3VvqBN1nrsomU9Ue4erxr0O6kC7uAEyYcWG?=
 =?us-ascii?Q?RlMYkyUTB3aHyHNg5pE6PM6XfxLXsLHKhgq05dsumE8IZaxztM25MiZWNFBY?=
 =?us-ascii?Q?1NLzE7qDy4E05EkEBw4MbgfJGFjfPp24VN1WJADkp84UyZD2+HZHXB7Utq6q?=
 =?us-ascii?Q?ENMQ71YM2jVxgNMiPb4Y9stEnIBx3Ya9eHxEwLLSAHqJuO3RKwk+MslnY/FU?=
 =?us-ascii?Q?Lw3LGKwS2LtHKurlJCzUUTCU9cNq+HUf9O1icPtWU91qLGl9HmBPYMWTlNxH?=
 =?us-ascii?Q?7MRyWYTBtcS/vKMjZE/Inf6gmc73sqImP4JdPXNe4BLuNWzBuqYL7YHdPRDC?=
 =?us-ascii?Q?PCZkaGXIFdUmHSWuftHL7BV5Sjf7HBYZK3FpjauxsXm+WSz5/NDDthu1MMRT?=
 =?us-ascii?Q?933D/2qk8KLO4FK4synwBxqsVtBWP5rVC2lrvj/oNydq0I4RanKXR7ja8ykQ?=
 =?us-ascii?Q?bVJVyp6aGTKp40H5SGp9thWWOU8S9ACf1yfw3QvAs6pVLoqqx5EzVTi6D8Yu?=
 =?us-ascii?Q?VmduHRYKLdZWidSjvBuEBZTbL7ZQ3Wm37hP8TrrnqO1GkER5YtbLLGZ0ku1g?=
 =?us-ascii?Q?W2y0tOl89ipQhJTdcEYKQtdU25KrX+EzEQU3zofK1LXgIkc0HRjPT1+vBA1o?=
 =?us-ascii?Q?jPxoCqLq1k5WAerAxnbuCpTcyw1biA4vbI19bi3y9dVWIH3riosDQP0GmIZL?=
 =?us-ascii?Q?BPKU0ZrE4vA4JcDT86GXgkXJ/W9hfFGpp5b9pak2uOim1Yz6uMKapdjUT2eL?=
 =?us-ascii?Q?TAgRhGzW6jOma0GIyPwotMxC1HmkMn3UNDskYK4fjOAe8GmkC33QZ1T8A+rI?=
 =?us-ascii?Q?P8pogIoKdMIeF8fbNMvzzsB8ZGorlPC3b49FtuNmwuzr3UDxHh2WJc9Yst00?=
 =?us-ascii?Q?BzhMQ7qKSZgJlB3yxgGL61W38S/jwH59OrhcISjVgAF9Tseyl/82m7vDeGSy?=
 =?us-ascii?Q?uCEkwzAqfOvgMJIwJxxIMKId3W40/73hgzW2LALPOcG2TVC3lgCRFm4QZvP8?=
 =?us-ascii?Q?xAjZJ9QxuLMGXZLtbtj9BaC6H6/sc2XUPXMQGFFXHUO2hk0eqMk4/DlLcxMA?=
 =?us-ascii?Q?tcykHIaRwg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CFoIPP+s8JVJPqdDHGGGrcOfbxjsEdfxo7iXZnkGCkpemiqVf4iFqrKPz7ZqZlip18TKCt0BeSd0/OWSnvQWNqbcWfnH3B/PJL3Efrw6yNh83gKWFwoq3cTHjDGepVOwKphuTvPpWKexKDg9FNrY7AUczz/7jqpIgfibp+vWxfEYH4+hRBV9MNyEt552zZGfCIb22t7R/zRovc5OenxrbPKYlkAfboLHXNf+VfQDrsMP08QlQhEQ7xhBuqMjDIC8RjoxbrXWCI7Bj3DuVN82KTxS68by5lOdeH8VdgeOvvaKmmpPYHVbmKSRdPazX/7K+C/U+3OOleibSn130Rjs5trfMgqrmlITBzmnSrocAHiYhbb8LyunrhC/8jkpw2rv98nlRntGww4emxn4p6d9fzR1u9XQOfXD8lVkpCMUaGKgG1SDUBh0nDMuBDFvLIOGHjwILg9I5x6hQf/uSOrQo0tsalihlkiOTkSG92uOIA+5g7zHjQMG565wAuGoCQXBbo8UBdGFBGMIhy3M8Ay7KPaKCe1Z86Tue3rkG8CVyiVxIfcIY1kyabF39HZKGbucfAHPQk+cfkyXyusT2lBajnLjEXalyI0elfu/MNMzOGE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d27b696-a3d1-435b-61ea-08de60428bbd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jan 2026 21:00:06.2543
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /R8NMePMufmZ4owt+G/Kf4TTSbTR7sejx2dWRTAnvKbnlMqZhfuyaQpPZywPfTydsTcKyu+DSAK4yU0IzucCxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5961
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-30_03,2026-01-30_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 mlxscore=0 spamscore=0 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2601150000 definitions=main-2601300172
X-Proofpoint-ORIG-GUID: hSAGH4K7qRiomwhugWRRFKohoF6qVRhO
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTMwMDE3MyBTYWx0ZWRfXzxPOZXS3sJYT
 yZlY503Pi/GvRFs2UasyoFdpEbwKB3DPE5Miio7+Mb03hPwnz+XwhI18NvN2emMSAYJQ/iS4RpV
 l44v2khH8Zr9BDTuOa3NHO+3MHBm5fvj5t6A17yjbcLbaIXn1VWV6Z+sZIimHkjkANCav5njRLl
 FqI8+rRo6ymxf1Zrwp9ATVmtWjKSUyII8V+3R7V5rqUYQ2eF2jZAHF/BZ1QpVSZg+jpRLM7YsQT
 AzNIEwtlv3Fd3t8nwz0ZI4jKjuFKeSA2pOk5qqGOpigyifDKtfTda0F4BQi+Cf6O/zr2hPFlx/I
 vtfr4i/8r62YP/aY8NjK2afy+kopPmx6GmuzbDeKb8VflkLJc1XcxtBibComlggL7vBP8wF3ZQD
 kjSuN21m3o7s09hIKXrZm2XpwBire2bet10OfUYpPWoBqv3Vt1QTPuLviySd5zn9bPPMrxYsFwQ
 WGBzDpMysME/qG4qMnw==
X-Authority-Analysis: v=2.4 cv=Qe5rf8bv c=1 sm=1 tr=0 ts=697d1bdb cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=yPCof4ZbAAAA:8
 a=M57lEg7Pwa7NdtlU3hgA:9
X-Proofpoint-GUID: hSAGH4K7qRiomwhugWRRFKohoF6qVRhO
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 918B040011
X-Stat-Signature: yjw8kogy6h3k31ynozaeejh83bidogds
X-Rspam-User: 
X-HE-Tag: 1769806825-141773
X-HE-Meta: U2FsdGVkX1/7zeDc8S225xDYPseDQYLeb3cSkxt2HUrIf+/QwVCJvuHUKeYC2mJo3wzkVJzTKNBEYgLNyZOrj+jEjOaNI4AiuOza2eqBZMLpJtlFOYxbx1Mx/yLhXQO89YbGiQ43JZkjyvSLHLqBVaDnPM/+GaqJmqYdtFf2DzfdWB7mFkaNs1hzFu5AoOUxwtRADG4N2f4//zBxHQLBhcegEwEhVgcPsZxNKJO+6yJ9zo0abC7MZRDjS3BYbFK0IVF35B7nVOAIbJp6pl4Gd4+q0cuOeGsQXbUe7yr9ToR8V7b8Xwda+aVoqF+zoFJptngpnFZu7pHKmuBvI9H4YcHIDvDJ8R5n+WlWaAusGDZefdE9KSncyJClnCRMK5T1NsEPgpDGMD3i/wQSDUxDEu8Mlsk0oW61sLCCtTZGqzJHoMFv7XsbO1k6h0xvySfXhoAJrOH7lF/U5PDAkPKeeUyg/VEWkNc+6gncXLhTMCqNKOEsbE4M1e1dZXSXv53RHcHRPa88Ott+I44ad4+k+4ej3G4BQ2gzckiov2QTv4VTJCUAtfTIfHauzAn9N6fqY615Y1ANM1QYcaFPUG30rXN/GP9oz2ISuidV6LBvM+TQMnDe/INS8M3NFpnfAv5kqCa1kWKrmnirgorNqKlqmUWLkQUs3rf8DYmv9mGf5ifa+gfggTUFfXVTbWBGG9uNq70UdaYFJivhMgp/cLqrLzWqktzVlpaqosQ519sWyzL8WO50al9+6/mDIVLOTsgxF2RdbFvXYCrQL+U3OamALWJnWezL7OJ1O9jrxkWR2Hj5n3M93oVbt5LvHyha4AOmf1hPv1Dm+D0AgeB895MOvh2NWv1vJ+RfXVLSOxVMc4nA8BbKyThpBcb6++veBnysXCicDkACUh11nJFqxh1lux/nLfz7rdboY7df3hUPdpORK2ZnBuamLHZCARHjR6P4DpVLKcpZOIwk62RNpfO
 zZRQW7wX
 fqIk0ODP6hY8v/bpW5QPDmVWLp0LfbBkuWvbBeYBXR+lC/kPthUXs5gIkh/MyhUTdl9/tm6l4oSuHcXeAbS/z1ID2IhOMrivD5923UU+tA2CNb/pSUif+9E1KqGdzjYISvKHjBiICMUdXoFqsopu+DeVWHAGKKfoCvXGibJ2ghsGKLGwafMtmZD80rPZEudjB21z9QtTwWO+fJnS91+gGX97SbQTMwXCUx39Wvs8X6L6Lx6qWeke8KDMZjdsl9tl1BC2Fh8Oi/PNmBIM8U9i3zpD4mIewhCHIJu8X4gb/Din/Axp98T9I68kLnOWq/pX80P6G9PIsb/F03rj7B67YMz1Gqj99HnzY93GGxD4R6vdRKHltjN6fbGw66FsL8tPrNBV3nhBlZ2zbA4hXcOkywwU96OR6N2Xd3JimeBgEnqIaz6OTZg0ZXAO6nSrhGAwDkMP9HIhm7AlK4lU/nQVohQcPpE/15KDZUnFaAJfDonMIpbc8PQSxbQ418uAOxZwf2dT4gDoPjdeDGavqLhFlDp3gbh0LWpnOagpcauy248anq/WMHmPZWWOCHKxsSfEsadyg8qKpIv/yAAZpmsJU7ysbL6anIFBnKTXt8ujyJtCc10PkfBQgGQrlwlcUCHbVnehqthQF34Dx6upY9avj+AwTPw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Copy the contents of mas_spanning_rebalance() into
mas_wr_spanning_rebalance(), in preparation of removing initial big node
use.

No functional changes intended.

Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
---
 lib/maple_tree.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 1e780427c04a0..fb14ce4a49c3c 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -2754,6 +2754,9 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 		struct ma_wr_state *l_wr_mas)
 {
 	struct maple_big_node b_node;
+	MA_STATE(l_mas, mas->tree, mas->index, mas->index);
+	MA_STATE(r_mas, mas->tree, mas->index, mas->last);
+	MA_STATE(m_mas, mas->tree, mas->index, mas->index);
 
 	memset(&b_node, 0, sizeof(struct maple_big_node));
 	/* Copy l_mas and store the value in b_node. */
@@ -2770,7 +2773,22 @@ static noinline void mas_wr_spanning_rebalance(struct ma_state *mas,
 
 	mast->bn = &b_node;
 	/* Combine l_mas and r_mas and split them up evenly again. */
-	return mas_spanning_rebalance(mas, mast, height);
+
+	/*
+	 * The tree needs to be rebalanced and leaves need to be kept at the same level.
+	 * Rebalancing is done by use of the ``struct maple_topiary``.
+	 */
+	mast->l = &l_mas;
+	mast->m = &m_mas;
+	mast->r = &r_mas;
+	l_mas.status = r_mas.status = m_mas.status = ma_none;
+
+	/* Check if this is not root and has sufficient data.  */
+	if (((mast->orig_l->min != 0) || (mast->orig_r->max != ULONG_MAX)) &&
+	    unlikely(mast->bn->b_end <= mt_min_slots[mast->bn->type]))
+		mast_spanning_rebalance(mast);
+
+	mas_spanning_rebalance_loop(mas, mast, height);
 }
 /*
  * mas_rebalance() - Rebalance a given node.
-- 
2.47.3


