Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1F1CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 14:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6411D8E0016; Tue, 21 Oct 2025 10:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 618F38E0002; Tue, 21 Oct 2025 10:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFA98E0016; Tue, 21 Oct 2025 10:19:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0EF8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:19:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C58C013B248
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:19:33 +0000 (UTC)
X-FDA: 84022329426.07.E5FB8CE
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by imf01.hostedemail.com (Postfix) with ESMTP id D031D4000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:19:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YWHSYwR+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="0NP/hjKp";
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761056370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GbYZkIwgpDU6qH4eUWXJ3Q1zp/edP6kN4YeUArsQIRM=;
	b=yPCdfUp1o4NZiLWu3DHUlWbOdZaau68BAkiiHfyXjZetVOSKGYwBfxagJLfgme+NWjKkqv
	GJiidRmIsLQH0CJdPymZrLjtppMo3sRlLwAC8bVggeQK00b6mtwE80qBVzkxWX8+nuwrzr
	HnxxCW+twQiqiajvciWFKxCerr6Tsu8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=YWHSYwR+;
	dkim=pass header.d=oracle.onmicrosoft.com header.s=selector2-oracle-onmicrosoft-com header.b="0NP/hjKp";
	spf=pass (imf01.hostedemail.com: domain of liam.howlett@oracle.com designates 205.220.177.32 as permitted sender) smtp.mailfrom=liam.howlett@oracle.com;
	arc=pass ("microsoft.com:s=arcselector10001:i=1");
	dmarc=pass (policy=reject) header.from=oracle.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1761056370; a=rsa-sha256;
	cv=pass;
	b=RZAOywWFYu6psdHCLUDo4eT32GwKavrDET2iMrIEiiNUohmyFkP93KQMHe5lVLrrydJHLA
	fK/2cshvEu+KkEochJ8IH8lrR1t/N51lmPFO6Gx8l5iMShRwLYgpAqEnl96cXDeqypXZED
	+oZZidfD8Nt9VwHuN+ImDJqo4wAE6Mc=
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59LEJ10M023427;
	Tue, 21 Oct 2025 14:19:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=GbYZkIwgpDU6qH4eUW
	XJ3Q1zp/edP6kN4YeUArsQIRM=; b=YWHSYwR+A30Nasq7XdOOTFC3CiYAjj1UEG
	kCBVhjGX6QmVNW3pdVPaIXJT9k5HbA7xTHaIc44GhKIgSSVgtvXo7bhrTAy/39Rb
	IZAzcVBMxUzi/vZolU6OjevVDB+glkxnGNqiG/00HJHOJPjrXXix3nKyPBMTb3wm
	JEKSoDwQ2ffu+yZZU3P4Df4fiYVHTYH4gNuUvSzFT41MHghGBsHvGyX3+9A8ehY9
	ZeHSEatGRtkPX7AUyIOmmmi8YjmrpWv4PD7fcOcXAb3Z+hfeyfvLYjdzkNG7Q5s/
	TY2cCDV6Qs/arZ1ezz+wi1KUlDHIgqnyBpP3VZPwWw4Di9kq2+1g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2wawcju-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 14:19:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59LDVFYp035213;
	Tue, 21 Oct 2025 14:19:19 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012027.outbound.protection.outlook.com [52.101.53.27])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bcxeq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 14:19:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=HvQFwArkmWwtxbluKrbndbhyZ2YyGvsgDWe4Phf5s2ktuqUIXrXkCz+WGJoNvT5CTCEfM9AA/5b/vGrP7zyi8kSVUVToiLkxlAbfS+NYGfUnzg62ft+nQAT6KLawgtqWVaqRsDgHuQmo4cavps3B3F3YJmGSu6v6MUX2tHfKTl8ViT3ZHFSpigsrQvT9pYVS5PJozx15qHYC6ESLUp0H6PSIzTvFBkuZb8XifqHLaUIaFgYqoyOJl9lNdxlzZ4ZOgxkh+UntP7mVhBoMssfkGJQINH5CBSAFifs7PvoQQyP8s814c9bsxbkQ/nvoMe1OmoF5/pZ9ypYiJwoc4kbSfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GbYZkIwgpDU6qH4eUWXJ3Q1zp/edP6kN4YeUArsQIRM=;
 b=gFVwBjA9dwNc28cRfrR5tnUZLixNmG4LzXcr/boGFEWbSTT9fdLa5ICc6VBEh+ztBveuWe1LZIXBhzJgbApkJKfxy2gd+071xDm96J4MPGxDqbhrTzX8LX8SEHFoKtR33iq06dHa/ZV1D2SOEFsE4k9QYKQkm8olax9VrqlixkmSzxI82hXJTIKeHdQpz9qFnCNLtpI5+1BOm/rDcX/RB9uVkgHhs0JEbMCwLZz+AN2rM3U3q0MeMrbetp8z5LUGNvykpE0YggolUTqpiAdA2sVpHYxdqOjet4QkEc6ASqrQb41KvxgqQK0z7SxGBCIeksMzR42L604snTLj2OaR+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GbYZkIwgpDU6qH4eUWXJ3Q1zp/edP6kN4YeUArsQIRM=;
 b=0NP/hjKpHPcT1fpyrSMwDIfS7j4WARHk/8kRWbNnls2sbirb8es3HQQFTbkUn2Ib9hKryI7b2OczSYCigUck9+MCAaJl6qrDNE42gsNRJgaTxMFSd7glCuvoJC5OrsGQpmSoByqAnn/LhfcEdwC9R8UOb6IR/Bwn2nZ823Lbodk=
Received: from PH0PR10MB5777.namprd10.prod.outlook.com (2603:10b6:510:128::16)
 by BN0PR10MB4854.namprd10.prod.outlook.com (2603:10b6:408:123::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.12; Tue, 21 Oct
 2025 14:19:15 +0000
Received: from PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c]) by PH0PR10MB5777.namprd10.prod.outlook.com
 ([fe80::75a8:21cc:f343:f68c%7]) with mapi id 15.20.9228.015; Tue, 21 Oct 2025
 14:19:15 +0000
Date: Tue, 21 Oct 2025 10:19:12 -0400
From: "Liam R. Howlett" <Liam.Howlett@oracle.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Huiwen He <hehuiwen@kylinos.cn>, markus.elfring@web.de,
        aliceryhl@google.com, andrewjballance@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Fix potential NULL pointer dereference if
 mas_pop_node() fails
Message-ID: <yc7zi3u4766orj7k7czsjxpaykuwbcehhcgler4vixkfzxjgke@yqlywdfalbu4>
Mail-Followup-To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Huiwen He <hehuiwen@kylinos.cn>, markus.elfring@web.de, 
	aliceryhl@google.com, andrewjballance@gmail.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, maple-tree@lists.infradead.org
References: <9092f8af-72d9-472e-8d5c-f950c8ce782d@web.de>
 <20251019114916.1618642-1-hehuiwen@kylinos.cn>
 <aPVGqRKFcI1SjZdk@casper.infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPVGqRKFcI1SjZdk@casper.infradead.org>
User-Agent: NeoMutt/20250905
X-ClientProxiedBy: YT4PR01CA0220.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:eb::16) To PH0PR10MB5777.namprd10.prod.outlook.com
 (2603:10b6:510:128::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5777:EE_|BN0PR10MB4854:EE_
X-MS-Office365-Filtering-Correlation-Id: 80b0402d-70da-46e1-0175-08de10acd0af
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?HAAwhJfN5xfjfoUdVFW/9b/5tIQbwEQk6EcHCRmwZOq5RtB0PCGGV1rQhN1L?=
 =?us-ascii?Q?5WHdWmAFyLyLkBTd376Mf0Brlj6Ww+orqMnINyrADeY1wqCjmRXXk7PW9mMX?=
 =?us-ascii?Q?7pwbMopQRRU4lSEry6PkmNqbCxL1hfvr+hnxpmXi5oj+OwJtKZlkQ1irJTvb?=
 =?us-ascii?Q?7EwWQezssfg2nD/FMp+K513IZEcYyBJPU1l9VHQD6s+0tWwvnGrUr1Dc34t7?=
 =?us-ascii?Q?EemCX8LMlXUSSMV+pMiNxgdXoT5+6seVDQTOglLIEARy8FMO9hBewUN9Op/G?=
 =?us-ascii?Q?qnMa/qVhlc117yvudVDxKe3jc34SMW+/FXd+H8dPSlBgVKlrYblErTgXtOUu?=
 =?us-ascii?Q?oDxkpJ2+5KKHBbCepOVc03BAqfQOrJCq8tZ+9H1NGkHtE1xkB7OdAqRaJ/z4?=
 =?us-ascii?Q?7VkbtoyPQMsOAg6ACeKu6M2l4/8Ns6EdPu0N5Xv/64+Z4J/t90G/ypSUNzvJ?=
 =?us-ascii?Q?/nJYzuiZS/xytPOPhjwqPU5Tn6+VcH6o2he7OSbuLIsEbyoHjOsRCZiEZi9j?=
 =?us-ascii?Q?SdzXUPxayEfodb9gqRml2c9YLF3/DYcH3uvf5S0m2cOOuGBfgPgyHmiw186U?=
 =?us-ascii?Q?Tz9NTICapuRj4UirtqA665pWEadMOA0gh/lLj8r2aUm3DugzBg9YME/PnR/m?=
 =?us-ascii?Q?Two5yqz8+8ADMrZ4IVImWiLwYBWMYZBZFvzgITMYQZO1gKDC1LKwVoGKsggB?=
 =?us-ascii?Q?i73Crjq0jXGURgkgimgIwCIPJgov/tCTVedkgs3Ww5pN7oN6nBiDQoBCl8mq?=
 =?us-ascii?Q?ES3ldsZXyoBXQJwXR7oujPaIlz/rX+yvoI924sf8d6bI/6U2TcDewmra1+d9?=
 =?us-ascii?Q?4eTfub8etA4w1tNuidoJn3sk6XqpyzX1XEl7jI2wDoRlrAeVgE3F0/e3hEVC?=
 =?us-ascii?Q?9kc9YWo2g97kYxmWHZj6Ur96vWL2W0OSmX6CoFnG+HtzrNgXFEPm0hw5U8tK?=
 =?us-ascii?Q?OpBCPQ6oPFKHWHN9r4aE90gG1rMFJdATkAMmq7IeRpEn2cJgMyUasXGWSaAJ?=
 =?us-ascii?Q?lTFZ8GF7w4JCnKpuOHjqkYOae147jcakIrss0wViDdXWscI5ymWKlcPGvyjJ?=
 =?us-ascii?Q?Oop+f1aAM6PBp5atBqJR6cush1g3N/9QD9ldQIlGbhTCsetBcd3cFdC58Eil?=
 =?us-ascii?Q?h3WPSPAfqvoe+fw9le9KYtKz8AmEaycCC+htZCwyV9X8WNQenpbQ4txUH38D?=
 =?us-ascii?Q?NHCIuBEcqm55dx4MrqIJP0Bp3KxG4tN4EBJAzEWLReB98D5Et+oEs5ruenzH?=
 =?us-ascii?Q?bo05+AXmW5IestGM1kAtSH614Z60llRaxxicdiL9yRZ0J5/0v4x3wdE4lP5u?=
 =?us-ascii?Q?f/OMJRo5T26qlHQN9Wpiv6uN5leN+fBMlkWLJYgF9iX3tMkk55/w99s5mZPg?=
 =?us-ascii?Q?qqr14lob6quu2rhqfE6PT+DmbLyQ2JwVUrY80FhFSFpGCKzkGGwo298dq/YV?=
 =?us-ascii?Q?+YlclI5b7aGHq0LDJxXFkO68ZdqicCwx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5777.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0ARb+TXyjQIL+Ac1Pb698QPqnBvS81+0aq86UvEqR1+uA4xUqfWsfNcniclU?=
 =?us-ascii?Q?KfJxSj3sWt6sLyPxzf39KR54/wX0Ka8hzHTg5KvJF/YvgdpHzblhTy9SnL8g?=
 =?us-ascii?Q?yg/XR3EdFXP9yDMqd/ItotLfa3gTwHn8yC2y4r2dfrXMLWfeRNnjB6cgu8sd?=
 =?us-ascii?Q?HawY4D/BKilCg55jVD3RMN1vDIgicdab2j2bDZfbqu5eIGHuTHzZsh/Br99E?=
 =?us-ascii?Q?cytf7UIfdSQ8PdXSqERGb66g8khe2vdmIu5rdFprDf3dfG6DWb5sTyeSyKXL?=
 =?us-ascii?Q?uiyDCu5n2WuB/eWNALxdGj5h/qK1wIJl9gt5COEfBKTg+tj3bCdMBElU0qSJ?=
 =?us-ascii?Q?m1VVJKB4hpNneIQcdqZC9vR9qzUr6bBCNkcU4+OxhODdO9BsAGc/jzoLcAXW?=
 =?us-ascii?Q?UwwXhG7yjRzKS0GtMLvXLZJzofFqYZKhofr5NSyfhEysmKe/2B3MkaNl0TQ8?=
 =?us-ascii?Q?2TtPTinYLQta3m+K+ApVxROdEcrRM3xlTdXS/iDGLXwo9YH+OjKNnujs3aGM?=
 =?us-ascii?Q?qBjQsJD+B30DHxksGBPd9HxF2XOp/oxiDqj0LmI1lZx+ic7a26O0mVg3Qjcr?=
 =?us-ascii?Q?oc/pmKaK5XvvKyqRA9Gm/BzHGJ0pIHjZ4WrwKjoIkWbUXMLvBajQgooq4sl9?=
 =?us-ascii?Q?ugmW30ld74ClmYBRHa4qUJQiptGsg9ULXzpx1EUzN1OedXtR5Hi59t35C/pl?=
 =?us-ascii?Q?JIaC7aqbBeUY0CWHFJhJ9xHsI217pxevFU+N8jbQXs1yz9jdCelAZCfCNyhQ?=
 =?us-ascii?Q?QaFVXwVmjKmDeKyje+yvjCFFzUCrjJwsJDX55PNj+PWS35gM9X1F0DZ7N6eh?=
 =?us-ascii?Q?y32FE2WHJV0W3YhIC0cssHInL4aayS2KqvUdTefOMAdSZvlnvTmudsI6Y2mh?=
 =?us-ascii?Q?tqHbWjhL6cienX/3StCVQsS9//8R2HO4vidAGvgGz8xukTyDpwuSKENqWV5E?=
 =?us-ascii?Q?3y7eH3QDRCFpK//Gcch303UmbLhA56pAJ+ROqqHR0OBh0vToE1Wg1b0LiieJ?=
 =?us-ascii?Q?oi50wBW8xOCAnCSkDQmFUgsWrhPZz8nKlPgg5CcDV941C5r6CazxjxsKGZVi?=
 =?us-ascii?Q?m8bxwiHMQna1VRC8ED2mONhAtkvLgokmAc07Xw0QnguDbCIQ1Ogwsrqm7XmW?=
 =?us-ascii?Q?xN0fmB9V6qCVeeLxvqgcOZzn779ruoz2uu/vCQuyZ1NXeUFazN/ZAAjp7BBx?=
 =?us-ascii?Q?jtj+ZuUTfZIquBv7O3a5zuPmE99mcxGPrUZHqpWkoxQuPcImcfoqaCWHXbQ6?=
 =?us-ascii?Q?+deZ2zKmOnBu1N9x159OCglAyHMQHdn76pb1gUtcbN4CwzlIfprph33yojey?=
 =?us-ascii?Q?L6MmGt8oO7oiOXx8nhZwBIiSCP1/eMYXLaQNSigApn89ra2upvTMUIXtNalE?=
 =?us-ascii?Q?rI4DX4fmI3SADdrFiot5dgZq3OlwE1ILUxLFO+J2q++07kUSALGmEEBkOMZU?=
 =?us-ascii?Q?ecZXTPT2zR90KKQc9DEwhHyZPl7mOVxYxB26M4mtKqgMgY8C+Hlwv/OPJwmk?=
 =?us-ascii?Q?5OYXmCz1+I6aDCoTaSnd0ni98bgamUgHhoJrDxtHYJxFxJCoM8dg2RTxT8eG?=
 =?us-ascii?Q?FjzaAwm1dn9iKasFUwu40dyIn4vN7vN3eS+KgCdz?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	XV50sWF+pnjy3IL+6Ou6E6ayIc4U2MxYoCKyHJX+45e68uywBWftBzjkQCcZgkBaE+xZnOPoIjyeJwX5UlLKqv8WZB829YL8bqNITExy7OND1387R93noEx2BwfnzwQk2CzkVLrXjg4GhgCGdKr0/A8sQmb56FoxcdHFh+f1VZPkUhM3Ln1HBhFNgH9i5p10SwOqFfmv4oAbTq/fb2DJmtX/JliDHTn7t4NNps1EmfTNwMGwxXgOD5B2uRVjcitRbOEvYtYWp6RXCmVgF2VDTEZzaNvqCYcsETpYXrEThez7xcyDa5n+cIyTm/rLRyCp6BkDZsmIVWU7IJ/5A0ENwRhaB6ImZLpuqxMag1XQE50MNlJJxGSbmTBL1LX2b7Xyd5QUEvPggzhaQbuR7lSsGtXjBUPOKcR4XziueJn0wo5DIfIlPnhSncZLWusdMeK2lhreKOZZd4I75S/j2DUnvutLgOcXSaMZ5ngkrsyB6ss2fFvShl31agueKewNKAW0iaBoocYpBKnLuh6DU7YNbTtuqd1SYnkMRXERpQhWKTcUcUHIjyjPCQOiUbK3L2ME0Lyb7KeOuwLddqQxanuxUo9FEuogkrexqrJ+FAShZQs=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b0402d-70da-46e1-0175-08de10acd0af
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5777.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 14:19:15.6938
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SCq3tPL8au5ql+eX+JZyLLboFY68tAaO1RyBMwgL4UyEJFFx0g2k1Gn3SDAwCT7X7vB2KIzaTiNagU26CejMWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4854
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-21_02,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510020000 definitions=main-2510210112
X-Proofpoint-ORIG-GUID: wZEVffUXsjsMEgiIJHNHUHcrpzzx0JVK
X-Authority-Analysis: v=2.4 cv=Pf3yRyhd c=1 sm=1 tr=0 ts=68f79667 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10
 a=x6icFKpwvdMA:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=JfrnYn6hAAAA:8 a=f5smj-U2Z-2EptxQSAwA:9 a=CjuIK1q_8ugA:10
 a=1CNFftbPRP8L7MoqJWF3:22 cc=ntf awl=host:12091
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX3rnFo3aqSnDF
 mEf2uimiBDuL99SVLmFNjv8krOBhlxa9d6mYSPXZ+tZvwSf53Svqx85koSSP5n0jQ2TJkl1Hvvw
 Mf5ulpYnJ5GH8Rf1//0L6ZOgq1o2AVSr5WuIjOPWoKNlGX+u8XRvhfXmdJt7ZzyzsOQBw6VHu/H
 FcNebegKvX7CYPyXPAdM7+NRm6Wa0Duv4ILFlRvvaBhcuGzf/IeayNx02eY0DkSk1TLS2NmLGow
 EW2Zet6GgDENcRJDHXBM6CPSxKS14lGVcxJKrzA0h6oPq8d1FiS++3I/VUFuzUV29X1n6efLs+0
 CcJL/GvGW044Dr86eyQy6pnY1kXwLhXDpTXw7Jx26wem9v4fTZPTfVh+db1/Ur0UzHREM3dKRVT
 CQKbsFQmU3eMH8194mM8B0/b2Z1TRvlcb1frc5gcuNtM1kga6IM=
X-Proofpoint-GUID: wZEVffUXsjsMEgiIJHNHUHcrpzzx0JVK
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D031D4000B
X-Stat-Signature: 81iu7jxzabqo9113nm8ig3ymstgzyi18
X-Rspam-User: 
X-HE-Tag: 1761056369-39822
X-HE-Meta: U2FsdGVkX18hJBQrKNQ5HIcLVDdpXwqM7xI6gklh3nXWslGiLZWq1nUtRP3/fubVPsqEzFMRqWFa3sdM0+6jFupXLVKvETuEfujmKC6etpZS4FcxnHBzEPczDvyROj17PL162GDZfsifF7sv9xF4+NOlkMQdkXvcXWolbyVMmfhLvbX9Zm+mTGbkCyeFmmCPwM2nD2mjpeYRB6itZ/M+Qa8Wn9cXhGHD9BFB8uS0gdfy8dSExmvG54vKGxAYYl62yBpSiyYzIBUVXNnh4U/EXgE8JpBaY74jgWfOnjZfaMwG+R1gJoABaVjCkj1u7gW7JXvt7FupexICdXuO0aKPK+ExYq/4cEUFhnLG7wNvOK9vMns97K6CgF6AbsoQLYLwZqmQX/ebIHj28pa2O/sPLNrZ8UxEyjxf9qp5asLBU/5zXjMiSkLIFqH+z1F06w784STa/zCwdP0Dz0wt/mN2PIWoIsIB7lEY8Mtg+oqa0j2mp+P6yMOhAN2XfPszt64PX5GURs4sCJRVt5dI9X18h/2Wxcc1r2eRNTkobrQzvENLBgFiuYE6hLCM3L5Sb0FTWE8EnKn0SnuMSqsFn6doD7D1WxEeyRopFoeaN79aiwH+5O/uPkLKEbA3kltBbkGTeeN8h2qx/zs4UUnD0mHVL9oQCMuV7/hk5MyfOkYkFKoKsgy34kOqokOcbeSFf9CgNEuskwTngbWikI3FGGAENwD7OvPgfs1zX70eBopw1bUREA0A3G93yJDRNarbDPmhE/zTps32vORBcYepDpfY6FF6xmAFzAE5t+hBLpMjVNsPJ2xxax0MktVHczpwaRrveqt/J1UQ7LVmiMSHiOLg51K9DQ5qBrY1W1WPWTKYk4qjb+G/K8kKB300OxMunyAmV+3lyfgH6K4Z9xZMp25rU4sdtwopkuIB8ejHfSBmM7oBBJs3FsX0d+J9dknM62GZSKhd46xDQj/D2CogSyF
 9VhySoq7
 QDMGtoDjWf95n+4Cdl0kaR5KNdK88PWIaeFWqIbFFTOVaFWv9vK2uC4jB61GlKg51Q2MgID+LrCz3nHhXvlI0PBRXVGeXo0h5Q52QDTG+zKw24io5MbYLQ7FZIVToX0bNMSSlRyDAfxwJN2y9Kf7I+tPP4uzcoW4lLBMqp3YQnZfKJdME1GhRFTMu3/C+MYBHoQ1JuRxamKE7+oFzJSz/qve5zOJy405fIzM1La6TV3jSxlWwPvz6UUieL0gjhR8gt+BAmhGGUArfE33dw0UXlS1xnpiiMZ3futk/LuNeLMhjVogDLjXAwrLGIODRXe7l2jog7tI+JT203IleZ+srAf/yVmTw9EVZxWtbEi5hfzoRuEe3Q8LuNNvG3YkM08yfY4irzd2sSzUuhcVgSbvb8xzdn7Iub9Pk0BhqzphyPxZ8t32sknEVdJDQZ+eQ3lcGiRFiErZVrOaoEAqTUApQm2N4JL97vZMpwDUOwm5+3V+Pu0dTu007UlkCMqkpOGIXZUwm7FKEvu0RQpvvapJVJNs0PHyda7sRRoKrgaqHYsghz48pVRSKgsx0m5RkZjHTL78g8a4H3nzqE1hPWKq41w1cmdOEC6hz2jq2JwoPIaCB8lPAriRkjZAuEpt8CPZr3hJ3FKxMKsneZ+5qRuP1SjuwnGubjaqRYQq5FnqdJIJdsK6CdRyD8AmahruVIaQpmJqRflwssryaaqtDRr8DWrnTeV5Sl1fVW87Ri69sTEc+0HY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* Matthew Wilcox <willy@infradead.org> [251019 16:14]:
> On Sun, Oct 19, 2025 at 07:49:16PM +0800, Huiwen He wrote:
...

> 
> Do not send a v2 until somebody has a substantive comment.  I suspect
> that what you are doing here is wrong, but I lack the understanding to
> explain why it is wrong.

Thanks Matthew.

This is not necessary.

At this point we ALWAYS have enough allocations.

I'm guessing you saw the WARN_ON() and return of NULL and assumed we'd
need to check the return in caller.  This WARN_ON() is in place in case
the calculations are incorrect in some corner case (which has never
happened in mainline), so this will add extra instructions for a
significant amount of calls, especially the mas_wr_node_store() path,
with no chance of catching an error.

In fact, the only time I've seen the tree fail to allocate enough memory
is when syzbot fails allocations - and that will happen in the
preallocation stage, which does check the return.

So, thanks for looking but this patch is unnecessary.

Thanks,
Liam


